package main

import (
	"crypto/rsa"
	"crypto/rand"
	"fmt"
	"os"
	"math/big"
	"github.com/bjornvdlaan/go-solidity-sha3"
	"encoding/hex"
	"io/ioutil"
)

func read_file() (string) {
	b, err := ioutil.ReadFile("data.txt") // just pass the file name
	if err != nil {
		fmt.Print(err)
	}

	//fmt.Println(b) // print the content as 'bytes'

	return string(b) // convert content to a 'string'
}

func G(h []byte) []byte {
	GHash := solsha3.SoliditySHA3(solsha3.Bytes32(h))

	two := append(GHash, GHash...)
	four := append(two, two...)

	//two_s := append(make([]byte, 32), GHash...)
	//four_s := append(two_s, two...)

	eight := append(four, four...)

	eight[0] = 0

	return eight
}

func H(N []byte, m string, s string, r []byte, x []byte) []byte {
	res := solsha3.SoliditySHA3(
		solsha3.Bytes32(N),
		solsha3.String(m),
		solsha3.String(s),
		solsha3.Bytes16(r),
		solsha3.String(x),
	)

	return res
}

func bytestohex(x []byte) string {
	return hex.EncodeToString(x)
}

func biginttohex(x *big.Int) string {
	return hex.EncodeToString((x).Bytes())
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
	res := new(big.Int).Exp(new(big.Int).SetBytes(message), e_big, pk.N).Bytes()
	return res
}

func pi_inverse(message []byte, sk rsa.PrivateKey) []byte {
	res := new(big.Int).Exp(new(big.Int).SetBytes(message), sk.D, sk.N).Bytes()
	return res
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
		X[0] = X[0] + 128
	} else {
		X = append([]byte(nil), x...)

	}

	return X
}

func print_binary(b []byte) {
	for _, n := range (b) {
		fmt.Printf("%08b", n)
	}
	fmt.Println("")
}

func split2(X []byte) (bool, []byte) {
	var b bool
	x := make([]byte, len(X))

	n := make([]byte, 32)
	n[0] = 128 //128 == 100000000

	comparison := new(big.Int).SetBytes(X).Cmp(new(big.Int).SetBytes(n))

	if comparison == 0 || comparison == 1 { //if X >= 2^(bits-1)
		b = true
		print_binary(X)
		x = new(big.Int).Sub(new(big.Int).SetBytes(X), new(big.Int).SetBytes(n)).Bytes()
		print_binary(x)
	} else {
		b = false
		x = append([]byte(nil), X...)
	}

	return b, x
}

func split_inverse2(b bool, x []byte) []byte {
	X := make([]byte, len(x))

	n := make([]byte, 32)
	n[0] = 128 //128 == 100000000

	if b == true {
		X = new(big.Int).Add(new(big.Int).SetBytes(x), new(big.Int).SetBytes(n)).Bytes()
	} else {
		X = append([]byte(nil), x...)
	}

	return X
}
