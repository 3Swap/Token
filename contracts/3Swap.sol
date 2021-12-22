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
}
