// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract GLDToken is ERC721 {
    using SafeMath for uint256;
    uint256 public nextTokenId = 0;

    constructor() public ERC721("Gold", "GLD") {}

    function mint(address to) public {
        _safeMint(to, totalSupply().add(1));
        nextTokenId.add(1);
    }
}
