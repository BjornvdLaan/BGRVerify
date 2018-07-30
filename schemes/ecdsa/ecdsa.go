// Copyright 2017 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.
package main

import (
"crypto/ecdsa"
"crypto/elliptic"
"fmt"

"github.com/ethereum/go-ethereum/common/math"
"github.com/ethereum/go-ethereum/crypto/secp256k1"
"crypto/rand"
"github.com/miguelmota/go-solidity-sha3"
	"encoding/hex"
	"strconv"
)

type Signature struct {
	Raw   []byte
	Hash  [32]byte
	R     [32]byte
	S     [32]byte
	V     uint8
}

func main() {
	pk, sk := KeyGen()
	fmt.Println(sk)

	message := "TEST"
	hash := solsha3.SoliditySHA3(solsha3.String("\x19Ethereum Signed Message:\n"+strconv.FormatInt(int64(len(message)),10)+message))

	sig := Sign(message, sk)
	fmt.Println("Signed")

	fmt.Println("Hash", bytestohex(hash))
	fmt.Println("PK", bytestohex(pk))
	fmt.Println("R", bytes32tohex(sig.R))
	fmt.Println("S", bytes32tohex(sig.S))
	fmt.Println("V", sig.V)
	fmt.Println("Sig", bytestohex(sig.Raw))

	ver := VerifySignature(pk, message, sig.Raw)
	fmt.Println(ver)

	}

func KeyGen() (pubkey []byte, privkey []byte) {
	key, err := ecdsa.GenerateKey(S256(), rand.Reader)
	if err != nil {
		panic(err)
	}

	fmt.Println(key.X, key.Y)
	pubkey = elliptic.Marshal(S256(), key.X, key.Y)
	return pubkey, math.PaddedBigBytes(key.D, 32)
}

// Sign calculates an ECDSA signature.
//
// This function is susceptible to chosen plaintext attacks that can leak
// information about the private key that is used for signing. Callers must
// be aware that the given hash cannot be chosen by an adversary. Common
// solution is to hash any input before calculating the signature.
//
// The produced signature is in the [R || S || V] format where V is 0 or 1.
func Sign(message string, sk []byte) (Signature) {
	hash := solsha3.SoliditySHA3(solsha3.String("\x19Ethereum Signed Message:\n"+strconv.FormatInt(int64(len(message)),10)+message))
	signature, _ := secp256k1.Sign(hash, sk)

	return Signature{
		signature,
		bytes32(hash),
		bytes32(signature[:32]),
		bytes32(signature[32:64]),
		uint8(int(signature[64])) + 27, // Yes add 27, weird Ethereum quirk
	}
}

// VerifySignature checks that the given public key created signature over hash.
// The public key should be in compressed (33 bytes) or uncompressed (65 bytes) format.
// The signature should have the 64 byte [R || S] format.
func VerifySignature(pubkey []byte, message string, signature []byte) bool {
	hash := solsha3.SoliditySHA3(solsha3.String("\x19Ethereum Signed Message:\n"+strconv.FormatInt(int64(len(message)),10)+message))
	return secp256k1.VerifySignature(pubkey, hash, signature[:64])
}

// S256 returns an instance of the secp256k1 curve.
func S256() elliptic.Curve {
	return secp256k1.S256()
}

func bytes32(b []byte) [32]byte {
	var array32 [32]byte
	copy(array32[:], b)
	return array32
}

func bytestohex(x []byte) string {
	return hex.EncodeToString(x)
}

func bytes32tohex(x [32]byte) string {
	return hex.EncodeToString(x[:])
}

