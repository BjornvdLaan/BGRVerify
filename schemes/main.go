package main

import (
	"crypto/rsa"
	"fmt"
	"crypto/rand"
	"os"
	"math/big"
	. "./bgls"
)

func main() {
	//bls()
	//bgls()
	multibgls()
	//rsaverify()
	//bgr()
}

func ecdsa() {
	//sk := KeyGen()
	fmt.Println("efse")
}

func bls() {
	curve := CurveSystem(Altbn128)

	//generate key
	x, _, X, _ := KeyGen(curve)

	message := read_file_bytes()
	label := []byte(fmt.Sprintf("example.com/api/%d", 1))
	//concatenate label
	concat := append(message, label...)

	//create signature
	sig := Sign(curve, x, X, concat)

	//verify
	fmt.Println("verification:", VerifySingleSignature(curve, sig, X, concat))

	fmt.Println("sig:", sig.ToAffineCoords())
	fmt.Println("message:", bytestohex(concat))
	fmt.Println("key", X.ToAffineCoords())
}

func multibgls() {
	number_of_signers := 10
	curve := CurveSystem(Altbn128)

	var sigs []Point
	var publickeys []Point
	var msgs [][]byte

	//Initialization
	for i := 0; i < number_of_signers; i++ {
		//generate key
		x, _, X, _ := KeyGen(curve)

		message := read_file_bytes()
		label := []byte(fmt.Sprintf("example.com/api/%d", i))
		//concatenate label
		concat := append(message, label...)

		//create signature
		sig := Sign(curve, x, X, concat)

		//save for later
		publickeys = append(publickeys, X)
		msgs = append(msgs, concat)
		sigs = append(sigs, sig)

		//aggregate signature
		aggsig := AggregateSignatures(sigs[:i+1])

		//verify
		if VerifyAggregateSignature(curve, aggsig, publickeys[:i+1], msgs[:i+1]) {
			//print signature
			fmt.Println("sig", i, aggsig.ToAffineCoords())
		} else {
			fmt.Println("false")
		}
	}

	//print keys
	for j := 0; j < len(publickeys); j++ {
		fmt.Println("key:", j, publickeys[j].ToAffineCoords())
	}

	//print messages
	for k := 0; k < len(msgs); k++ {
		fmt.Println("msg:", k, bytestohex(msgs[k]))
	}

}

func bgls() {
	number_of_signers := 10
	curve := CurveSystem(Altbn128)

	var sigs []Point
	var publickeys []Point
	var msgs [][]byte

	//Initialization
	for i := 0; i < number_of_signers; i++ {
		//generate key
		x, _, X, _ := KeyGen(curve)

		message := read_file_bytes()
		label := []byte(fmt.Sprintf("example.com/api/%d", i))
		//concatenate label
		concat := append(message, label...)

		//create signature
		sig := Sign(curve, x, X, concat)

		//save for later
		publickeys = append(publickeys, X)
		msgs = append(msgs, concat)
		sigs = append(sigs, sig)
	}

	//aggregate signature
	aggsig := AggregateSignatures(sigs)

	//verify
	fmt.Println(VerifyAggregateSignature(curve, aggsig, publickeys, msgs))

	//print signature
	fmt.Println("sig:", aggsig.ToAffineCoords())

	//print keys
	for j := 0; j < len(publickeys); j++ {
		fmt.Println("key:", j, publickeys[j].ToAffineCoords())
	}

	//print messages
	for k := 0; k < len(publickeys); k++ {
		fmt.Println("msg:", k, bytestohex(msgs[k]))
	}
}

func rsaverify() {
	number_of_signers := 10

	var signatures [][]byte
	var publickeys []rsa.PublicKey

	for i := 0; i < number_of_signers; i++ {
		sk, _ := rsa.GenerateKey(rand.Reader, 2048)
		message := read_file()
		sig := signPKCS15(message, sk)

		//verify signature
		if verifyPKCS15(message, sig, sk.PublicKey) {
			signatures = append(signatures, sig)
			publickeys = append(publickeys, sk.PublicKey)
		} else {
			os.Exit(2)
		}
	}

	for ki, ke := range publickeys {
		fmt.Println("N:", ki, bytestohex(ke.N.Bytes()))
	}

	for si, se := range signatures {
		fmt.Println("S:", si, bytestohex(se))
	}

}

func bgr() {
	number_of_signers := 10

	var keys []BGRKey
	var publickeys []rsa.PublicKey
	var messages []string
	var labels []string

	//Initialization
	for i := 0; i < number_of_signers; i++ {
		key := BGRKeyGen()
		message := read_file()
		//message := fmt.Sprintf("%s %d", "MESSAGE", i)
		label := fmt.Sprintf("example.com/api/%d", i)

		keys = append(keys, key)
		publickeys = append(publickeys, key.pk)
		messages = append(messages, message)
		labels = append(labels, label)
		}

	fmt.Println("Keys")
	for ki, ke := range publickeys {
		fmt.Println(ki, bytestohex(ke.N.Bytes()))
	}

	var sig BGRSig

	for j := 1; j < number_of_signers + 1; j++ {
		fmt.Println("Number of signers:", j)

		//create clean signature
		sig = NewSig()

		for k := 0; k < j; k++ {
			sig = BGRSign(messages[k], labels[k], keys[k], sig)
		}
		fmt.Println("Signature creation successful:", j)

		//verify
		if BGRVerify(publickeys[:j], messages[:j], labels[:j], sig) {
			fmt.Println("Verified:", j)

			fmt.Println("x:", bytestohex(sig.x))
			fmt.Println("h:", bytestohex(sig.h))
			fmt.Println("b:", sig.b)

			for l := 0; l < j; l++ {
				fmt.Printf("r%d: %d\n", l, new(big.Int).SetBytes(sig.r[l]))
			}


		} else {
			os.Exit(2)
		}

	}

}
