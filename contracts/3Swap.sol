pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/Context.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract ThreeSwap is Context, Ownable, ERC20 {
  constructor(
    string memory name_,
    string memory symbol_,
    uint256 amount_
  ) Ownable() ERC20(name_, symbol_) {
    _mint(_msgSender(), amount_);
  }

  mapping(address => bool) _permitted;

  modifier onlyPermitted() {
    require(
      _permitted[_msgSender()],
      'only permitted addresses can call this function'
    );
    _;
  }

  /** @dev Release ERC20 tokens stuck in contract
   *  @param token_ Token contract address
   *  @param to_ Address to send the token to
   *  @param amount_ Amount to send
   */
  function returnERC20(
    address token_,
    address to_,
    uint256 amount_
  ) external onlyOwner {
    require(token_ != address(0), 'token address cannot be zero address');
    require(to_ != address(0), 'recipient address cannot be zero address');
    require(IERC20(token_).transfer(to_, amount_), 'could not transfer tokens');
  }

  /** @dev Release Ether stuck in contract
   *  @param to_ Address to send Ether to
   *  @param amount_ Amount of Ether to send
   */
  function returnEther(address to_, uint256 amount_) external onlyOwner {
    require(to_ != address(0), 'recipient address cannot be zero address');
    address payable _to = payable(to_);
    _to.transfer(amount_);
  }

  /** @dev Function to mint tokens. Can only be called by permitted accounts
   *  @param account_ The address to mint tokens for
   *  @param amount_ The amount of tokens to mint
   */
  function mint(address account_, uint256 amount_) external onlyPermitted {
    _mint(account_, amount_);
  }

  /** @dev Function to burn tokens. Can only be called by permitted accounts
   *  @param account_ The address whose tokens should be burned
   *  @param amount_ The amount of tokens to burn
   */
  function burn(address account_, uint256 amount_) external onlyPermitted {
    _burn(account_, amount_);
  }

  /** @dev Function to give an address minting and burning permission. Can only be called by the contract owner
   *  @param account_ The address to give permission to
   */
  function addPermitted(address account_) external onlyOwner {
    require(!_permitted[account_], 'address already granted permission');
    _permitted[account_] = true;
  }

  /** @dev Function to rescind permission from an address. Can only be called by the contract owner
   *  @param account_ The address to rescind permission from
   */
  function removePermitted(address account_) external onlyOwner {
    require(_permitted[account_], 'address has not been granted permission');
    _permitted[account_] = false;
  }
}
