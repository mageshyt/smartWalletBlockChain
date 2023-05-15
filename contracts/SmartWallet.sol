// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SmartWallet {
    // State Variables

    struct contractOwnerInfo {
        address owner;
        uint256 totalBalance;
    }

    struct Transaction {
        uint256 amount;
        uint256 timestamp;
        string description;
    }

    struct userAccount {
        address acc_no;
        uint256 balance;
        mapping(address => Transaction[]) transactionHistory;
        bool isAllowed;
        bool isGuard;
    }

    mapping(address => userAccount) private userAccounts;

    contractOwnerInfo public contractOwner;

    // constructor
    constructor() {
        contractOwner.owner = msg.sender; // set the owner of the contract
    }

    // Event
    event depositeEvent(address indexed _from, uint256 _value);
    event withdrawEvent(address indexed _to, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // modifiers
    modifier onlyOwner() {
        require(
            msg.sender == contractOwner.owner,
            "Only the owner can call this function"
        );
        _;
    }

    modifier onlyGuard() {
        require(
            userAccounts[msg.sender].isGuard == true,
            "Only the guard can call this function"
        );
        _;
    }

    modifier onlyAllowed() {
        require(
            userAccounts[msg.sender].isAllowed == true,
            "Only the allowed user can call this function"
        );
        _;
    }

    // functions

    function addGuard(address _guard) public onlyOwner {
        userAccounts[_guard].isGuard = true;
        userAccounts[_guard].isAllowed = true;
    }

    function removeGuard(address _guard) public onlyOwner {
        userAccounts[_guard].isGuard = false;
        userAccounts[_guard].isAllowed = false;
    }

    // guard or owner can add or remove allowed users
    function addAllowed(address _user) public onlyGuard {
        // user should have an account
        require(
            userAccounts[_user].acc_no != address(0),
            "The user doesn't have an account"
        );

        // user should not be owner
        require(
            _user != contractOwner.owner,
            "You can't add the owner as an allowed user"
        );
        userAccounts[_user].isAllowed = true;
    }

    function removeAllowed(address _user) public onlyGuard {
        // user should have an account
        require(
            userAccounts[_user].acc_no != address(0),
            "The user doesn't have an account"
        );

        // user should not be owner
        require(
            _user != contractOwner.owner,
            "You can't remove the owner as an allowed user"
        );

        userAccounts[_user].isAllowed = false;
    }

    // create account
    function createAccount() public {
        require(
            userAccounts[msg.sender].acc_no == address(0),
            "You already have an account"
        );
        userAccounts[msg.sender].acc_no = msg.sender;
        userAccounts[msg.sender].isAllowed = true;
    }

    function deposite() public payable onlyAllowed {
        userAccounts[msg.sender].balance += msg.value;
        userAccounts[msg.sender].transactionHistory[msg.sender].push(
            Transaction(msg.value, block.timestamp, "deposite")
        );

        emit depositeEvent(msg.sender, msg.value);
    }

    function withdraw(uint256 _amt) public onlyAllowed {
        // check if the user has enough balance
        require(
            userAccounts[msg.sender].balance >= _amt,
            "You don't have enough balance"
        );

        // check if the contract has enough balance
        require(
            address(this).balance >= _amt,
            "The contract doesn't have enough balance"
        );

        // transfer the amount to the user
        payable(msg.sender).transfer(_amt);

        // update the balance of the user
        userAccounts[msg.sender].balance -= _amt;

        // update the transaction history
        userAccounts[msg.sender].transactionHistory[msg.sender].push(
            Transaction(_amt, block.timestamp, "withdraw")
        );

        emit withdrawEvent(msg.sender, _amt);
    }

    // Send money

    function sendMoney(
        address payable _to,
        uint256 _amt
    ) public onlyAllowed returns (bool) {
        require(
            userAccounts[msg.sender].balance >= _amt,
            "You don't have enough balance"
        );

        // check if the contract has enough balance
        require(
            address(this).balance >= _amt,
            "The contract doesn't have enough balance"
        );

        // self transfer not allowed
        require(_to != msg.sender, "You can't send money to yourself");
        // check receiver address is valid
        require(_to != address(0), "Invalid address");

        // check receiver had a account
        require(
            userAccounts[_to].acc_no != address(0),
            "The receiver doesn't have an account"
        );
        // check receiver is allowed
        require(
            userAccounts[_to].isAllowed == true,
            "The receiver is not allowed"
        );
        // transfer the amount to the user
        _to.transfer(_amt);

        // update the balance of the user
        userAccounts[msg.sender].balance -= _amt;

        // update the transaction history
        userAccounts[msg.sender].transactionHistory[msg.sender].push(
            Transaction(_amt, block.timestamp, "send money")
        );

        // update the balance of the receiver
        userAccounts[_to].balance += _amt;

        // update the transaction history
        userAccounts[_to].transactionHistory[_to].push(
            Transaction(_amt, block.timestamp, "receive money")
        );

        emit Transfer(msg.sender, _to, _amt); // event [from , to , amount]

        return true;
    }

    function getBalance() public view returns (uint) {
        //    covert to eth

        return userAccounts[msg.sender].balance;
    }

    function getTransactionHistory()
        public
        view
        returns (Transaction[] memory)
    {
        return userAccounts[msg.sender].transactionHistory[msg.sender];
    }

    function getContractBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function userDetails(
        address _user
    ) public view returns (address, uint256, bool, bool) {
        return (
            userAccounts[_user].acc_no,
            userAccounts[_user].balance,
            userAccounts[_user].isAllowed,
            userAccounts[_user].isGuard
        );
    }

    // function to get owner address
    function getOwner() public view returns (address) {
        return contractOwner.owner;
    }
}
