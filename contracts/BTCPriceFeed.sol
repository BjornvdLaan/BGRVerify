pragma solidity ^0.4.1;

import "./imported/JsmnSolLib.sol";
import "./imported/bytesutils.sol";
import "./imported/tlsnutils.sol";

contract BTCPriceFeed {
    using bytesutils for *;

    bytes prf = hex"20001000ffff03000f342cb6795605002e1b34b67956050040000000040000004747b4bc12342f8f1284ade439dab6c9e65c8c1a21baf5aad04826f92f322dbfa329b5e234c8e667ee67d48f93cffdb6618711b1cf41086923136f5acbda498802850000474554202f70726f78792e70793f75726c3d68747470732533412f2f696e6465782e626974636f696e2e636f6d2f6170692f76302f6c6f6f6b757025334674696d652533443135303135343536303020485454502f312e310d0a486f73743a20746c732d6e2e6f72670d0a436f6e6e656374696f6e3a206b6565702d616c6976650d0a0d0a48cbc6d79e5d485108825791a8b93cb4027e0101485454502f312e3120323030204f4b0d0a446174653a204672692c2031312041756720323031372031323a34373a313020474d540d0a5365727665723a204170616368652f322e342e3620285265642048617420456e7465727072697365204c696e757829204f70656e53534c2f312e302e31652d66697073205048502f352e342e3136206d6f645f6e73732f312e302e3134204e53532f332e33302e310d0a436f6e6e656374696f6e3a20636c6f73650d0a582d506f77657265642d42793a20457870726573730d0a4163636573732d436f6e74726f6c2d416c6c6f772d4f726967696e3a202a0d0a457870697265733a205361742c2031322041756720323031372030303a31353a303020474d540d0a436f6e74656e742d4c656e6774683a203338390d0a455461673a20572f223138352d682b7163754d5a6a337470702b5a6e4b2f714f703641220d0a436f6e74656e742d547970653a206170706c69636174696f6e2f6a736f6e3b20636861727365743d7574662d380d0a0d0a42635e88507a700fc6f26c78ee946e9d028501017b0a2020226f70656e223a207b0a20202020227072696365223a203237343433352c0a202020202274696d65223a207b0a20202020202022756e6978223a20313530313435393230302c0a2020202020202269736f223a2022323031372d30372d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a203238333931382c0a202020202274696d65223a207b0a20202020202022756e6978223a20313530313534353630302c0a2020202020202269736f223a2022323031372d30382d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a203238333931382c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313530313534353630302c0a2020202020202269736f223a2022323031372d30382d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d61bf0574796575ddff1b1155f5919f28";

    /**
    This method is used to measure only the transaction costs
    */
    function transactioncost(bytes memory proof) returns (bool) {
        revert();
    }

    /**
    This method is used to measure only the verification costs
    */
    function verificationcost() {
        uint n = 10; //NOTE: change this parameter to set the amount of signatures that will be verified

        for (uint i = 0; i < n; i++) {
            verifyProof(prf);
        }
    }

    /**
    This method is used to measure only the storage costs
    */
    // Mapping from timestamp to BTC price in USD cents (= 10**-2 USD)
    mapping(uint32 => uint32) timestamp_to_price;
    function storagecost() returns (bool) {

        uint n = 10; //NOTE: change this parameter to set the number of messages signatures that will be stored

        for (uint i = 0; i < n; i++) {

            //The parser code from function submitProofOfPrice.

            // Check HTTP Request
            bytes memory request = tlsnutils.getHTTPRequestURL(prf);
            // Check that the first part is correct
            require(request.toSlice().startsWith("/proxy.py?url=https%3A//index.bitcoin.com/api/v0/lookup%3Ftime%3D".toSlice()));
            // Check that the second part is not too long
            require(request.toSlice().find("%3D".toSlice()).len() == 13);

            // Check the host (kind of redundant due to signature check)
            bytes memory host = tlsnutils.getHost(prf);
            require(host.toSlice().equals("tls-n.org".toSlice()));

            // Get the body
            bytes memory body = tlsnutils.getHTTPBody(prf);

            uint32 timestamp0;
            uint32 price0;
            uint32 timestamp1;
            uint32 price1;
            // Parse the timestamps
            (timestamp0, price0, timestamp1, price1) = this.parseBitcoinComFeed(string(body));
            // Insert the timestamps
            timestamp_to_price[timestamp0] = price0;
            timestamp_to_price[timestamp1] = price1;
        }

        return true;
    }

    function verifyProof(bytes memory proof) returns (bool) {
        // Check if proof is valid
        // Elliptic curve parameters for the TLS certificate of tls-n.org
        uint256 qx = 0x0de2583dc1b70c4d17936f6ca4d2a07aa2aba06b76a97e60e62af286adc1cc09;
        uint256 qy = 0x68ba8822c94e79903406a002f4bc6a982d1b473f109debb2aa020c66f642144a;
        return tlsnutils.verifyProof(proof, qx, qy);
    }

	// Function that allows proof submission
    function submitProofOfPrice(bytes memory proof) {
        // Check if proof is valid
        // Elliptic curve parameters for the TLS certificate of tls-n.org
        uint256 qx = 0x0de2583dc1b70c4d17936f6ca4d2a07aa2aba06b76a97e60e62af286adc1cc09;
        uint256 qy = 0x68ba8822c94e79903406a002f4bc6a982d1b473f109debb2aa020c66f642144a;
        require(tlsnutils.verifyProof(proof, qx, qy));

        // Check HTTP Request
        bytes memory request = tlsnutils.getHTTPRequestURL(proof);
        // Check that the first part is correct
        require(request.toSlice().startsWith("/proxy.py?url=https%3A//index.bitcoin.com/api/v0/lookup%3Ftime%3D".toSlice()));
        // Check that the second part is not too long
        require(request.toSlice().find("%3D".toSlice()).len() == 13);

        // Check the host (kind of redundant due to signature check)
        bytes memory host = tlsnutils.getHost(proof);
        require(host.toSlice().equals("tls-n.org".toSlice()));

        // Get the body
        bytes memory body = tlsnutils.getHTTPBody(proof);

        uint32 timestamp0;
        uint32 price0;
        uint32 timestamp1;
        uint32 price1;
		// Parse the timestamps
        (timestamp0, price0, timestamp1, price1) = this.parseBitcoinComFeed(string(body));
		// Insert the timestamps
        timestamp_to_price[timestamp0] = price0;
        timestamp_to_price[timestamp1] = price1;
    }

	// Request a securely inserted price
	// Throws if no price found for given timestamp
	function getPrice(uint32 timestamp) returns (uint32){
		uint32 price = timestamp_to_price[timestamp];
		// Make sure this mapping element exists
		require(price > 0);
		return price;
	}

    // Perform parsing of result using JsmnSolLib
    // Returns: opening timestamp, opening price, closing timestamp, closing price
    function parseBitcoinComFeed(string json) external returns(uint32 timestamp0, uint32 price0, uint32 timestamp1, uint32 price1){
        uint res;
        string memory val;
        JsmnSolLib.Token[] memory tokens;
        JsmnSolLib.Token memory t;
        uint num_tokens;
        // Parse JSON
        (res, tokens, num_tokens) = JsmnSolLib.parse(json, 50);
        require(res == 0);

        // Find opening tag
        t = tokens[1];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "open") == 0);

        // Ensure price is in result
        t = tokens[3];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "price") == 0);

        // Read start price of the day
        t = tokens[4];
        price0 = uint32(JsmnSolLib.parseInt(JsmnSolLib.getBytes(json, t.start, t.end)));
        require(price0 > 0);

        // Read time tag
        t = tokens[5];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "time") == 0);

        // Ensure time is unix timestamp
        t = tokens[7];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "unix") == 0);

        // Get opening timestamp
        t = tokens[8];
        timestamp0 = uint32(JsmnSolLib.parseInt(JsmnSolLib.getBytes(json, t.start, t.end)));
        require(timestamp0 > 0);

        // Get closing tag
        t = tokens[11];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "close") == 0);

        // Get price tag
        t = tokens[13];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "price") == 0);

        // Get closing price
        t = tokens[14];
        price1 = uint32(JsmnSolLib.parseInt(JsmnSolLib.getBytes(json, t.start, t.end)));
        require(price1 > 0);

        // Get time tag
        t = tokens[15];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "time") == 0);

        // Ensure time is unix timestamp
        t = tokens[17];
        val = JsmnSolLib.getBytes(json, t.start, t.end);
        require(JsmnSolLib.strCompare(val, "unix") == 0);

        // Get closing timestamp
        t = tokens[18];
        timestamp1 = uint32(JsmnSolLib.parseInt(JsmnSolLib.getBytes(json, t.start, t.end)));
        require(timestamp1 > 0);

    }

}

