package main

import (
	"crypto/rand"
	"crypto/rsa"
	"math/big"
)

// Constants
const LH int = 32
const LX int = 256
const LR int = 16
const LK int = 32

// Generates a BGR public/private key pair
func BGRKeyGen() BGRKey {
	sk, _ := rsa.GenerateKey(rand.Reader, 2048) //big: 2048, small: 256 bytes
	pk := sk.PublicKey

	return BGRKey{sk: *sk, pk: pk}
}

func BGRSign(m string, s string, keys BGRKey, prevsig BGRSig) (BGRSig) {
	x := prevsig.x
	h := prevsig.h

	//Line 1
	r_new := generateRandomString(16) //big: 16, small: 2 bytes

	//Line 2
	eta := H(keys.pk.N.Bytes(), m, s, r_new, x)

	//Line 3
	h_new := xor(h, eta)

	//Line 4
	g := G(h_new)

	//Line 5
	y := xor(g, x)

	//Line 6
	X_new := pi_inverse(y, keys.sk)
	b_new, x_new := split(X_new) //Section F of paper

	//Line 7
	sig := NewSig()
	sig.x = x_new
	sig.h = h_new
	sig.r = append(prevsig.r, r_new)
	sig.b = append(prevsig.b, b_new)

	return sig
}

func BGRVerify(publickeys []rsa.PublicKey, messages []string, labels []string, signature BGRSig) bool {
	x_prev := signature.x
	h_prev := signature.h
	r := signature.r
	b := signature.b

	for i := len(publickeys) - 1; i > 0; i-- {
		//Line 2
		X := split_inverse(b[i], x_prev)
		y := pi(X, publickeys[i])

		//Line 3
		g := G(h_prev)

		//Line 4
		x_prev = xor(g, y)

		//Line 5
		eta := H(publickeys[i].N.Bytes(), messages[i], labels[i], r[i], x_prev)

		//Line 6
		h_prev = xor(h_prev, eta)
	}

	//Line 7
	HHash := H(publickeys[0].N.Bytes(), messages[0], labels[0], r[0], nil)
	GHash := G(h_prev)
	pig := pi(split_inverse(signature.b[0], x_prev), publickeys[0])

	/*
	fmt.Println("h_prev", h_prev)
	fmt.Println("h_hash", HHash)
	fmt.Println("pig", pig)
	fmt.Println("g_hash", GHash)
	*/

	//convert everything to numbers for comparison
	h_prev_num := new(big.Int).SetBytes(h_prev)
	HHash_num := new(big.Int).SetBytes(HHash)
	pig_num := new(big.Int).SetBytes(pig)
	GHash_num := new(big.Int).SetBytes(GHash)

	return h_prev_num.Cmp(HHash_num) == 0 && pig_num.Cmp(GHash_num) == 0
}


