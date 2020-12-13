// SPDX-License-Identifier: MIt
pragma solidity >=0.4.22 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is ERC20, Ownable {
    using SafeMath for uint256;

    constructor() public ERC20("Silver", "SLV") Ownable() {
        uint256 initialSupply = 1000000 * 10**18;
        _mint(msg.sender, initialSupply);
    }

    function claimERC20Tokens() public {
        _mint(msg.sender, 10 * 10**18);
    }
}
