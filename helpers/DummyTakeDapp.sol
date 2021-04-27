// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token//ERC20/presets/ERC20PresetMinterPauser.sol";

contract DummyTakeDapp {
    ERC20PresetMinterPauser immutable token;
    
    constructor(ERC20PresetMinterPauser _token) {
        token = _token;
    }
    
    function take(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
    }
}
