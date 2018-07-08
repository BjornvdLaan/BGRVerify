package ecdsa

import "github.com/ethereum/go-ethereum/crypto"

type Signature struct {
	Raw   []byte
	Hash  [32]byte
	R     [32]byte
	S     [32]byte
	V     uint8
}

func Sign(message string) Signature {
	hashRaw := crypto.Keccak256([]byte(message))
	signature, err := crypto.Sign(hashRaw, p.ecdsa)
	p.errorHandler.Handle(err, "Signature error")

	return Signature{
		signature,
		p.bytes32(hashRaw),
		p.bytes32(signature[:32]),
		p.bytes32(signature[32:64]),
		uint8(int(signature[65])) + 27, // Yes add 27, weird Ethereum quirk
	}
}
