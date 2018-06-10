package main

import (
	"crypto/rand"
	"crypto/sha256"
	"crypto"
	"fmt"
	"os"
	"crypto/rsa"
)

func signRSA(msg string, rsaPrivateKey *rsa.PrivateKey) ([]byte) {

	// crypto/rand.Reader is a good source of entropy for blinding the RSA
	// operation.
	rng := rand.Reader

	message := []byte(msg)

	// Only small messages can be signed directly; thus the hash of a
	// message, rather than the message itself, is signed. This requires
	// that the hash function be collision resistant. SHA-256 is the
	// least-strong hash function that should be used for this at the time
	// of writing (2016).
	hashed := sha256.Sum256(message)

	signature, err := rsa.SignPSS(rng, rsaPrivateKey, crypto.SHA256, hashed[:], nil)

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error from signing: %s\n", err)
		return make([]byte, 0)
	}

	/*fmt.Println("Message:", bytestohex(message))
	fmt.Printf("e: %x\n", rsaPrivateKey.E)
	fmt.Printf("N: %x\n", rsaPrivateKey.N)
	fmt.Println("Signature:", bytestohex(signature))*/

	return signature
}

func verifyRSA(msg string, signature []byte, rsaPublicKey rsa.PublicKey) (bool) {

	message := []byte(msg)
	//signature, _ := hex.DecodeString("ad2766728615cc7a746cc553916380ca7bfa4f8983b990913bc69eb0556539a350ff0f8fe65ddfd3ebe91fe1c299c2fac135bc8c61e26be44ee259f2f80c1530")

	// Only small messages can be signed directly; thus the hash of a
	// message, rather than the message itself, is signed. This requires
	// that the hash function be collision resistant. SHA-256 is the
	// least-strong hash function that should be used for this at the time
	// of writing (2016).
	hashed := sha256.Sum256(message)

	err := rsa.VerifyPSS(&rsaPublicKey, crypto.SHA256, hashed[:], signature, nil)

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error from verification: %s\n", err)
		return false
	}

	// signature is a valid signature of message from the public key.
	return true
}