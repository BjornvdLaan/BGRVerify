pragma solidity 0.4.21;


contract BGRUtils {
    function GHash(bytes x) returns (bytes) {
        bytes hash = bytes32ToBytes(keccak256(x)); //+ hash + hash + hash + hash + hash + hash + hash;
        return hash;
        //bytes empty = [byte(0), ];
    }

    function HHash(bytes x) returns (bytes) {
        return keccak256(x);
    }

    /*function MergeBytes(bytes memory a, bytes memory b) public pure returns (bytes memory c) {
        // Store the length of the first array
        uint alen = a.length;
        // Store the length of BOTH arrays
        uint totallen = alen + b.length;
        // Count the loops required for array a (sets of 32 bytes)
        uint loopsa = (a.length + 31) / 32;
        // Count the loops required for array b (sets of 32 bytes)
        uint loopsb = (b.length + 31) / 32;
        assembly {
            let m := mload(0x40)
        // Load the length of both arrays to the head of the new bytes array
            mstore(m, totallen)
        // Add the contents of a to the array
            for {  let i := 0 } lt(i, loopsa) { i := add(1, i) } { mstore(add(m, mul(32, add(1, i))), mload(add(a, mul(32, add(1, i))))) }
        // Add the contents of b to the array
            for {  let i := 0 } lt(i, loopsb) { i := add(1, i) } { mstore(add(m, add(mul(32, add(1, i)), alen)), mload(add(b, mul(32, add(1, i))))) }
            mstore(0x40, add(m, add(32, totallen)))
            c := m
        }
    }*/

    // Combines 'self' and 'other' into a single array.
    // Returns the concatenated arrays:
    //  [self[0], self[1], ... , self[self.length - 1], other[0], other[1], ... , other[other.length - 1]]
    // The length of the new array is 'self.length + other.length'
    function concat(bytes memory self, bytes memory other) internal pure returns (bytes memory) {
        bytes memory ret = new bytes(self.length + other.length);
        var (src, srcLen) = Memory.fromBytes(self);
        var (src2, src2Len) = Memory.fromBytes(other);
        var (dest,) = Memory.fromBytes(ret);
        var dest2 = dest + src2Len;
        Memory.copy(src, dest, srcLen);
        Memory.copy(src2, dest2, src2Len);
        return ret;
    }

    function toBytes(bytes32 self) internal pure returns (bytes memory bts) {
        bts = new bytes(32);
        assembly {
            mstore(add(bts, /*BYTES_HEADER_SIZE*/32), self)
        }
    }

    function bytes32ToBytes(bytes32 data) internal pure returns (bytes) {
        uint i = 0;
        while (i < 32 && uint(data[i]) != 0) {
            ++i;
        }
        bytes memory result = new bytes(i);
        i = 0;
        while (i < 32 && data[i] != 0) {
            result[i] = data[i];
            ++i;
        }
        return result;
    }
}
