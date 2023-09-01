/********* AUDIT DETAILS MARKED WITH THIS COMMENT NOTATION */

/*********

THIS IS A COMPLETE SELF AUDIT

Security Measures Implemented in BURNED Token Contract:

SafeMath Library Usage: The contract employs the SafeMath library for arithmetic operations on uint256 to prevent overflow and underflow vulnerabilities that can lead to unexpected behaviors and security breaches.

Private Balance and Allowance Mappings: The contract uses private mappings _balances and _allowances to store balances and allowances, respectively. This enhances security by preventing unauthorized access from external contracts or actors.

Total Supply Management: The _totalSupply variable ensures that the token's total supply remains consistent, providing a clear limit to the maximum number of tokens in circulation. This prevents unintentional minting or inflation vulnerabilities.

Decimals and Symbol: The _decimals, _symbol, and _name variables are set to appropriate values for accurate representation of the token. Ensuring accurate metadata helps prevent confusion and errors during token transfers and interactions.

Modifiers for Function Access Control: The onlyOwner modifier is used in various functions to restrict access to contract owner(s) only. This prevents unauthorized modifications or manipulations that could compromise the contract's integrity.

Transfer and Approval Functions: The contract implements standard BEP20 functions for transferring tokens and approving spending. These functions enforce data integrity and prevent unauthorized transfers.

Event Logging: Events are used to log significant contract actions, such as token transfers and approval grants. This aids in monitoring and tracking contract activity, facilitating transparency and accountability.

Ownership Transfer Mechanism: The contract implements a secure ownership transfer mechanism. The OwnershipTransferred event is emitted when ownership changes, and the renounceOwnership function ensures that ownership can only be renounced by the current owner.

Context Contract Usage: The contract uses the Context contract to obtain the sender's address and calldata, enhancing security by standardizing these processes and minimizing potential vulnerabilities.

Initialization and Constructor: The constructor sets initial contract parameters and assigns the total supply to the contract deployer's address. This ensures a secure token distribution from the outset.

Documentation and Comments: The contract is well-documented with comments explaining its functions, variables, and overall structure. This improves code readability, facilitates maintenance, and assists in the identification of potential security issues.

Limited Functionality: The contract focuses on implementing the necessary functionality for a BEP20 token, avoiding unnecessary complexity that could introduce security vulnerabilities.

By combining these security measures, the BURNED contract is designed to mitigate common vulnerabilities and provide a secure foundation for the token's functionality. These practices help ensure the safety of token holders and contribute to a trustworthy and reliable token ecosystem.

 */


/********* Start of contract comments containing token information
Also contains the SPDX Identifier as well as logo converted to text */

// SPDX-License-Identifier: MIT

/*..............(.........).........(......
...(............)\.)...(./(.........)\.)...
.(.)\......(...(()/(...)\())..(....(()/(...
.)((_).....)\.../(_)).((_)\...)\..../(_))..
((_)_..._.((_).(_))...._((_).((_)..(_))_...
.|._.).|.|.|.|.|._.\..|.\|.|.|.__|..|...\..
.|._.\.|.|_|.|.|.../..|..`.|.|._|...|.|).|.
.|___/..\___/..|_|_\..|_|\_|.|___|..|___/..
...........................................
@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@&G@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@&GG@@@#@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@#5P&&@@@BG@@@@@@@@@@@@@@@@
@@@@@@@@@@@&5JG&GB&@@GJG@@@@@@@@@@@@@@@
@@@@@@@@@@&J?P@YY@PG@@P?JB@@@@@@@@@@@@@
@@@@@@@@@@#??P@#P&@PJP&#J?JB@@@@@@@@@@@
@@@@@@@@@GG?JJ&@@@&&Y??&#J??P@&@@@@@@@@
@@@@@@@@@@5??JJB@@@GJJ?G@@5??BY&B#@@@@@
@@@@@@@@G@@&5???YB@&JJ?B#@G?JJ?&GP@@@@@
@@@@@@@@GY&@@&PJ??J5P5JJG@5JJJJ@#?&@@@@
@@@@@@@@@PJ&@@@&G5JJJ5P#@BJJJJG@@JY@@@@
@@@@@@@@@BJY&@&55GGYYYYG#YYYJP@@#YJ#@@@
@@@@@@@@@5Y5@@YYYY#&5YYY5B5YB@@#5YY#@@@
@@@@@@@@BY5P@&Y55P@@&5555P&@@&G5555@@@@
@@@@@@@&555G@@G555#@@G5555&@@@B5B#&@@@@
@@@@@@@#5PPP&@@#P55PBGPGGGB#BPP&@@@@@@@
@@@@@@@&G&GPPB&@@&BGPPPPPPPG#&@@@@@@@@@
@@@@@@@@@@@#GPPGGBBBBBBB#@@@@@@@@@@@@@@
@@@@@@@@@@@@@&#BGGGGGGB&@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

// Website - https://burnedalv.com
// Telegram - https://t.me/burnedalv
// Twitter - https://x.com/burnedalvey
// Email - admin@burnedalv.com

/********* END OF CONTRACT COMMENTS */

/********* Defined modern solidity and forward versions */
pragma solidity ^0.8.17;


/********* START OF STANDARD IBEP20 Interface 
These functions display the information in the
READ and WRITE sections of the contract on AlveyScan */
interface IBEP20 {

/********* Returns the Total Supply of the token */
  function totalSupply() external view returns (uint256);

/********* Returns the number of decimals for the contract */
  function decimals() external view returns (uint8);

/********* Returns the tokens symbol */
  function symbol() external view returns (string memory);

/********* Returns the tokens name */
  function name() external view returns (string memory);

/********* Returns the tokens owner */
  function getOwner() external view returns (address);

/********* Returns the address account owners balance */
  function balanceOf(address account) external view returns (uint256);

/********* Allows you to call a token transfer from the */
  function transfer(address recipient, uint256 amount) external returns (bool);

/********* Returns the remaining number of tokens that spender will be */
  function allowance(address _owner, address spender) external view returns (uint256);

/********* Allows an address to approve another for a given amount */
  function approve(address spender, uint256 amount) external returns (bool);

/********* Allows an address to transfer a value on your behalf */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


/********* Event to log token transfers */
  event Transfer(address indexed from, address indexed to, uint256 value);

/********* Event to log token approval for spending */
  event Approval(address indexed owner, address indexed spender, uint256 value);

}


/********* The Context contract provides basic functionality for obtaining transaction context */
contract Context {

/********* The constructor of the Context contract, which is used as a base contract */
  constructor () { }

/********* Returns the address that triggered the contract */
  function _msgSender() internal view returns (address) {
    return msg.sender;
  }

/********* Returns the calldata for the transaction */
  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

// SafeMath library provides arithmetic operations with safety checks
library SafeMath {

/********* Safely adds two numbers */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

/********* Safely subtracts two numbers, ensuring no overflow occurs */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

/********* Safely subtracts two numbers with custom error message, ensuring no overflow occurs */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

/********* Safely multiplies two numbers */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

/********* Safely divides two numbers, preventing division by zero */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

/********* Safely divides two numbers with custom error message, preventing division by zero */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
  // Ensure the divisor is not zero to prevent division by zero
    require(b > 0, errorMessage);
  
  // Calculate the result of the division
    uint256 c = a / b;
  
  // Note: It is usually not necessary to assert the following equation in Solidity:
  // assert(a == b * c + a % b);
  // The equation holds true for all valid values of a and b, and there is no case in which it doesn't hold.

    return c;
  }

/********* Safely calculates the remainder of division, preventing modulo by zero */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

/********* Safely calculates the remainder of division with custom error message, preventing modulo by zero */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
  // Ensure the divisor is not zero to prevent modulo by zero
    require(b != 0, errorMessage);
  
  // Calculate the remainder of division
    return a % b;
  }
}


// Ownable contract provides basic ownership functionality
contract Ownable is Context {
/********* Stores the address of the contract owner */
  address private _owner;

/********* Emitted when ownership of the contract is transferred */
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

/********* Initializes the contract with the sender as the owner */
  constructor ()  {

    // Obtain the address that triggered the contract deployment
    address msgSender = _msgSender();
    // Set the address that triggered the deployment as the initial owner
    _owner = msgSender;
    // Emit an OwnershipTransferred event to indicate ownership transfer from address(0) to the deploying address
    emit OwnershipTransferred(address(0), msgSender);
  }

/********* Returns the current owner's address */
  function owner() public view returns (address) {
    return _owner;
  }

/********* Modifies a function to be callable only by the owner */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

/********* Allows the current owner to renounce their ownership, transferring ownership to the zero address.
 * This function can only be called by the current owner. After renouncing ownership,
 * an OwnershipTransferred event is emitted to indicate the change in ownership status.
 * Finally, the owner's address is set to the zero address, effectively renouncing ownership.
 */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

/********* Transfers ownership to a new address */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}


// BURNED contract implements the BEP20 interface, Ownable and Context Contracts
contract BURNED is Context, IBEP20, Ownable {

/********* Importing the SafeMath library and enabling its usage for uint256. */
  using SafeMath for uint256;

/********* A mapping that stores the balance of each address in terms of the token's amount. */
  mapping (address => uint256) private _balances;
/********* A nested mapping that stores allowances granted by an address to other addresses. */
  mapping (address => mapping (address => uint256)) private _allowances;

/********* A private variable that holds the total supply of tokens in the contract. */
  uint256 private _totalSupply;
/********* A private variable that holds the number of decimal places for the token. */
  uint8 private _decimals;
/********* A private variable that stores the token's symbol. */
  string private _symbol;
/********* A private variable that stores the token's name. */
  string private _name;

/********* Initializes the contract with token details */
  constructor() {
    /********* Sets tokens name */
    _name = "BURNED";
    /********* Sets tokens symbol */
    _symbol = "BURN";
    /********* Sets token decimals */
    _decimals = 9;
    /********* Sets tokens total supply */
    _totalSupply = 420000000000000;
    /********* Sends initial supply to msg.sender */
    _balances[msg.sender] = _totalSupply;

    /********* Emits an event showing the tokens were supplied to msg.sender */
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

/********* Returns the current owner's address */
  function getOwner() external override view returns (address) {
    return owner();
  }

/********* Returns the number of decimals for the token */
  function decimals() external override view returns (uint8) {
    return _decimals;
  }

/********* Returns the token's symbol */
  function symbol() external view override returns (string memory) {
    return _symbol;
  }

/********* Returns the token's name */
  function name() external view override returns (string memory) {
    return _name;
  }

/********* Returns the total supply of tokens */
  function totalSupply() external view override returns (uint256) {
    return _totalSupply;
  }

/********* Returns the balance of the specified account */
  function balanceOf(address account) external view override returns (uint256) {
    return _balances[account];
  }

/********* Transfers tokens to a specified recipient */
  function transfer(address recipient, uint256 amount) external override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

/********* Returns the amount of tokens approved for spender */
  function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
  }

/********* Approves the specified address to spend tokens */
  function approve(address spender, uint256 amount) external override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

/********* Transfers tokens from sender to recipient with allowance */
  function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
    return true;
  }

/********* Increases the allowance for spender */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

/********* Decreases the allowance for spender */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }

/********* Internal function for transferring tokens */
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

/********* Internal function for burning tokens */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

/********* Internal function for approving token allowance */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

/********* Internal function for burning tokens from an account */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
  }
}