package main

import (
	"crypto/rsa"
	"fmt"
	"math/big"
)

func main() {
	var publickeys []rsa.PublicKey
	var messages []string

	amount_of_signers := 3

	sig := NewSig()

	for i := 0; i < amount_of_signers; i++ {
		keys := BGRKeyGen()
		message := fmt.Sprintf("%s %d", "MESSAGE", i)
		publickeys = append(publickeys, keys.pk)
		messages = append(messages, message)

		sig = BGRSign(message, keys, sig)
	}

	fmt.Println("Verifying..")
	fmt.Println(BGRVerify(publickeys, messages, sig.r, sig))
	fmt.Println(sig)
	fmt.Println("r:", sig.r)
	fmt.Println("pk:", publickeys)

	//This can be sent to solidity
	fmt.Println("x",new(big.Int).SetBytes(sig.x))
	fmt.Println("h",new(big.Int).SetBytes(sig.h))

	for j := 0; j < amount_of_signers; j++ {
		fmt.Printf("r%d: %d\n",j,new(big.Int).SetBytes(sig.r[j]))
	}
}
