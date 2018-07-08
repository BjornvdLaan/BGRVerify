package main

import (
	"fmt"
	"crypto/rsa"
)

// Aggregate signature
type BGRSig struct {
	r [][]byte  // r[1] ... r[i] contain strings of length rlen;
	x []byte  // x is the current value x[i] of length xlen
	h []byte   // h is the current value h[i] of length hlen
	b []bool   // b[1] ... b[i] contain a single bit each;
}

func NewSig() BGRSig {
	return BGRSig{}
}

/*
func (sig *BGRSig) SetX(x []byte) {
	x_length := len(x)

	if x_length < 32 {
		prefix := make([]byte, 32 - x_length)
		sig.x = append(prefix, x...)
	} else {
		sig.x = x
	}
}

func (sig *BGRSig) SetH(h []byte) {
	h_length := len(h)

	if h_length < 32 {
		prefix := make([]byte, 32 - h_length)
		sig.h = append(prefix, h...)
	} else {
		sig.h = h
	}
}
*/

func (sig BGRSig) String() string {
	return fmt.Sprintf("x_i: %d\nh_i: %d\nb: %t", sig.x, sig.h, sig.b)
}

// Keys of a data source
type BGRKey struct {
	sk rsa.PrivateKey
	pk rsa.PublicKey
}


