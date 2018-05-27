package main

import (
	"crypto/rsa"
	"crypto/rand"
	"fmt"
	"os"
	"math/big"
	"github.com/miguelmota/go-solidity-sha3"
)

func G(h []byte) []byte {
	GHash := solsha3.SoliditySHA3(solsha3.Bytes32(h))

	two := append(GHash, GHash...)
	four := append(two, two...)

	two_s := append(make([]byte, 32), GHash...)
	four_s := append(two_s, two...)

	eight := append(four_s, four...)

	return eight

	}

func H(key rsa.PublicKey, m string, r []byte, x []byte) []byte {
	return solsha3.SoliditySHA3(
		solsha3.String(key), //TODO: should be fingerprint
		solsha3.String(m),
		solsha3.String(r),
		solsha3.String(x),
	)
}

func generateRandomString(n int) []byte {
	b := make([]byte, n)
	_, err := rand.Read(b)

	if err != nil {
		fmt.Println(err.Error)
		os.Exit(1)
	}

	return b
}

func xor(string1 []byte, string2 []byte) []byte {
	n := len(string1)
	m := len(string2)

	//if one is an empty string, use the convention from paper
	if n == 0 {
		return string2
	} else if m == 0 {
		return string1
	} else if n == m {
		b := make([]byte, n)

		for i := 0; i < n; i++ {
			b[i] = string1[i] ^ string2[i]
		}

		return b
	} else {
		fmt.Println("XOR Error", n, m)
		os.Exit(2)
	}
	return nil
}

func pi(message []byte, pk rsa.PublicKey) []byte {
	e_big := big.NewInt(int64(pk.E))
	return new(big.Int).Exp(new(big.Int).SetBytes(message), e_big, pk.N).Bytes()
}

func pi_inverse(message []byte, sk rsa.PrivateKey) []byte {
	return new(big.Int).Exp(new(big.Int).SetBytes(message), sk.D, sk.N).Bytes()
}

func split(X []byte) (bool, []byte) {
	var b bool
	x := make([]byte, len(X))

	//128 == 100000000
	if X[0] >= 128 {
		b = true
		x = append([]byte(nil), X...)
		x[0] = x[0] - 128
	} else {
		b = false
		x = append([]byte(nil), X...)
	}

	return b, x
}

func split_inverse(b bool, x []byte) []byte {
	X := make([]byte, len(x))

	if b == true {
		X = append([]byte(nil), x...)
		X[0] = X[0] - 128
	} else {
		X = append([]byte(nil), x...)

	}

	return X
}


func pi2(message []byte, pk rsa.PublicKey) []byte {
	//l := len(message) / 2
	p1 := message[0:128]
	p2 := message[128:]

	e_big := big.NewInt(int64(pk.E))

	e1 := new(big.Int).Exp(new(big.Int).SetBytes(p1), e_big, pk.N).Bytes()
	e2 := new(big.Int).Exp(new(big.Int).SetBytes(p2), e_big, pk.N).Bytes()

	return append(e1, e2...)

	//e_big := big.NewInt(int64(pk.E))
	//return new(big.Int).Exp(new(big.Int).SetBytes(message), e_big, pk.N).Bytes()
}

func pi_inverse2(message []byte, sk rsa.PrivateKey) []byte {
	//l := len(message) / 2
	p1 := message[0:128]
	p2 := message[128:]

	e1 := new(big.Int).Exp(new(big.Int).SetBytes(p1), sk.D, sk.N).Bytes()
	e2 := new(big.Int).Exp(new(big.Int).SetBytes(p2), sk.D, sk.N).Bytes()

	fmt.Println("M", len(message))
	fmt.Println("P", len(p1), len(p2))
	fmt.Println("E",len(e1), len(e2))
	fmt.Println(len(append(e1, e2...)))

	return append(e1, e2...)
}

