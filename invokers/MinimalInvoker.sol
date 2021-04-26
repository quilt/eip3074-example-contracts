// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MinimalInvoker {
    function call(uint256 yParity, uint256 r, uint256 s, address payable addr, bytes memory data) external payable {
        address signer;
        bool success;
        assembly {
            signer := auth(0, yParity, r, s)
            success := authcall(0, addr, callvalue(), 0, add(data, 0x20), mload(data), 0, 0)
        }
        require(success, "authcall failed");
    }
}