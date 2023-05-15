# Smart Wallet Contract

This contract implements a smart wallet that allows users to deposit, withdraw, and send money to other users. The smart wallet also has an owner and guards who can add or remove allowed users and guards.

## Structs

The contract has three structs:

1.  contractOwnerInfo: Stores the contract owner's address and total balance.
2.  Transaction: Stores the amount, timestamp, and description of each transaction.
3.  userAccount: Stores the user's address, balance, transaction history, and allowed and guard status.

## Events

The contract also has three events:

1.  depositEvent: Emitted when a user deposits money into their account.
2.  withdrawEvent: Emitted when a user withdraws money from their account.
3.  Transfer: Emitted when a user sends money to another user.

## Modifiers

The contract has several modifiers:

1.  onlyOwner: Restricts access to functions that can only be called by the contract owner.
2.  onlyGuard: Restricts access to functions that can only be called by guards.
3.  onlyAllowed: Restricts access to functions that can only be called by allowed users.

## Functions

The contract has several functions:

1.  addGuard(address \_guard): Adds a new guard.
2.  removeGuard(address \_guard): Removes a guard.
3.  addAllowed(address \_user): Adds a new allowed user.
4.  removeAllowed(address \_user): Removes an allowed user.
5.  createAccount(): Creates a new user account.
6.  deposit(): Deposits funds into the user's account.
7.  withdraw(uint256 \_amt): Withdraws funds from the user's account.
8.  sendMoney(address payable \_to, uint256 \_amt): Sends funds to another user.

The addGuard, removeGuard, addAllowed, and removeAllowed functions can only be called by the contract owner or guards. The createAccount, deposit, withdraw, and sendMoney functions can only be called by allowed users.

The contract also checks if a user has enough balance before allowing them to withdraw or send money. It also checks if the contract has enough balance to complete the transaction. Additionally, the contract prevents users from sending money to themselves and ensures that the receiver has a valid account and is allowed to receive funds.
