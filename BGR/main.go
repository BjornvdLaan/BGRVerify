package main

import (
	"crypto/rsa"
	"fmt"
)

func main() {
	var publickeys []rsa.PublicKey
	var messages []string

	sig := NewSig()

	fmt.Println("sig", sig.x)

	for i := 0; i < 5; i++ {
		keys := BGRKeyGen()
		message := "MESSAGE " + string(i)
		publickeys = append(publickeys, keys.pk)
		messages = append(messages, message)

		sig = BGRSign(message, keys, sig)
	}

	fmt.Println("Verifying..")
	BGRVerify(publickeys, messages, sig.r, sig)

}