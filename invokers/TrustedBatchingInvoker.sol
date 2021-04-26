contract TrustedBatchingInvoker {
    struct Signature {
        bool v;
        uint256 r;
        uint256 s;
    }
    
    struct Call {
        uint64 gas;
        address addr;
        uint256 value;
        bytes data;
    }
    
    function computeCommit(address sender) public pure returns (bytes32 commit) {
        return bytes32(uint256(uint160(sender)));
    }
    
    function auth(Signature calldata sig) public view returns (address signer) {
        bytes32 commit = computeCommit(msg.sender);
        bool v = sig.v; uint256 r = sig.r; uint256 s = sig.s;
        assembly {
            signer := auth(commit, v, r, s)
        }
    }
    
    function authcall(Call calldata call) internal returns (bool success) {
        uint64 _gas = call.gas; address addr = call.addr; uint256 value = call.value; bytes memory data = call.data;
        assembly {
            success := authcall(_gas, addr, value, 0, add(data, 0x20), mload(data), 0, 0)
        }
    }
    
    
    function requireAll(Signature calldata sig, Call[] calldata calls) external payable {
        address signer = auth(sig);
        require(signer != address(0), "invalid signature!");
        
        for (uint256 i = 0; i < calls.length; i++) {
            bool success = authcall(calls[i]);
            require(success, "unsuccessful call!");
        }
    }
}