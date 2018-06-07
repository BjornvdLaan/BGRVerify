const tlsn = require("../verifytlsn");

const m = "0x"+"20001000ffff03000f342cb6795605002e1b34b67956050040000000040000004747b4bc12342f8f1284ade439dab6c9e65c8c1a21baf5aad04826f92f322dbfa329b5e234c8e667ee67d48f93cffdb6618711b1cf41086923136f5acbda498802850000474554202f70726f78792e70793f75726c3d68747470732533412f2f696e6465782e626974636f696e2e636f6d2f6170692f76302f6c6f6f6b757025334674696d652533443135303135343536303020485454502f312e310d0a486f73743a20746c732d6e2e6f72670d0a436f6e6e656374696f6e3a206b6565702d616c6976650d0a0d0a48cbc6d79e5d485108825791a8b93cb4027e0101485454502f312e3120323030204f4b0d0a446174653a204672692c2031312041756720323031372031323a34373a313020474d540d0a5365727665723a204170616368652f322e342e3620285265642048617420456e7465727072697365204c696e757829204f70656e53534c2f312e302e31652d66697073205048502f352e342e3136206d6f645f6e73732f312e302e3134204e53532f332e33302e310d0a436f6e6e656374696f6e3a20636c6f73650d0a582d506f77657265642d42793a20457870726573730d0a4163636573732d436f6e74726f6c2d416c6c6f772d4f726967696e3a202a0d0a457870697265733a205361742c2031322041756720323031372030303a31353a303020474d540d0a436f6e74656e742d4c656e6774683a203338390d0a455461673a20572f223138352d682b7163754d5a6a337470702b5a6e4b2f714f703641220d0a436f6e74656e742d547970653a206170706c69636174696f6e2f6a736f6e3b20636861727365743d7574662d380d0a0d0a42635e88507a700fc6f26c78ee946e9d028501017b0a2020226f70656e223a207b0a20202020227072696365223a203237343433352c0a202020202274696d65223a207b0a20202020202022756e6978223a20313530313435393230302c0a2020202020202269736f223a2022323031372d30372d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a203238333931382c0a202020202274696d65223a207b0a20202020202022756e6978223a20313530313534353630302c0a2020202020202269736f223a2022323031372d30382d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a203238333931382c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313530313534353630302c0a2020202020202269736f223a2022323031372d30382d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d61bf0574796575ddff1b1155f5919f28";

verify();

//Here we have only one function because the parameters is set in the contract.
//Note that to measure only verification costs, we cannot send the parameters in the transaction as it must be empty.
function verify() {
    tlsn.verify(m)
}
