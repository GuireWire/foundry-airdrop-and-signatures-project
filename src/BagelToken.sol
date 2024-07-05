// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BagelToken is ERC20, Ownable {
    constructor() ERC20("Bagel", "BT") Ownable(msg.sender) {
        // _mint(msg.sender, 1000000 * 10 * decimals()); // we don't want initial supply so no need for this line
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }
}
