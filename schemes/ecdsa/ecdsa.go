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
	"io/ioutil"
)

func main() {
	key := KeyGen()

	msg := read_file()
	label := fmt.Sprintf("example.com/api/%d", 1)
	message := msg + label

	sig, prefixedmsg := Sign(message, key)

	fmt.Println("address:", hex.EncodeToString(crypto.PubkeyToAddress(key.PublicKey).Bytes()))
	fmt.Println("message:", hex.EncodeToString([]byte(message)))
	fmt.Println("prefixed message:", hex.EncodeToString(prefixedmsg))
	fmt.Println("signature:", hex.EncodeToString(sig))
}

func KeyGen() (*ecdsa.PrivateKey) {
	key, err := ecdsa.GenerateKey(crypto.S256(), rand.Reader)

	if err != nil {
		panic(err)
	}

	return key
}

func Sign(message string, key *ecdsa.PrivateKey) ([]byte, []byte) {
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

func read_file() (string) {
	b, err := ioutil.ReadFile("data.txt") // just pass the file name
	if err != nil {
		fmt.Print(err)
	}

	//fmt.Println(b) // print the content as 'bytes'

	return string(b) // convert content to a 'string'
}
