package main

import (
	"crypto/ecdsa"
	"fmt"

	"crypto/rand"
	"encoding/hex"
	"github.com/ethereum/go-ethereum/common/math"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/crypto/secp256k1"
	"github.com/miguelmota/go-solidity-sha3"
)

func main() {
	key := keygen()
	message := "TEST"

	fmt.Println(hex.EncodeToString(solsha3.SoliditySHA3(solsha3.String(message))))

	sig, prefixedmsg := sign(message, key)

	fmt.Println("private key:", hex.EncodeToString(math.PaddedBigBytes(key.D, 32)))
	fmt.Println("address:", hex.EncodeToString(crypto.PubkeyToAddress(key.PublicKey).Bytes()))
	fmt.Println("message:", hex.EncodeToString(prefixedmsg))
	fmt.Println("signature:", hex.EncodeToString(sig))

}

func keygen() (*ecdsa.PrivateKey) {
	key, err := ecdsa.GenerateKey(crypto.S256(), rand.Reader)

	if err != nil {
		panic(err)
	}

	return key
}

func sign(message string, key *ecdsa.PrivateKey) ([]byte, []byte) {
	// Turn the message into a 32-byte hash
	hash := solsha3.SoliditySHA3(solsha3.String(message))
	// Prefix and then hash to mimic behavior of eth_sign
	prefixed := solsha3.SoliditySHA3(solsha3.String("\x19Ethereum Signed Message:\n32"), solsha3.Bytes32(hash))
	sig, err := secp256k1.Sign(prefixed, math.PaddedBigBytes(key.D, 32))

	if err != nil {
		panic(err)
	}

	return sig, prefixed
}
