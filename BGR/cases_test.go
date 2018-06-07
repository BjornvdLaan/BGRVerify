package main

import (
	"testing"
	"crypto/rsa"
)

func TestOneSigner(t *testing.T) {
	var publickeys []rsa.PublicKey
	var messages []string

	sig := NewSig()

	keys := BGRKeyGen()
	message := "MESSAGE 1"
	publickeys = append(publickeys, keys.pk)
	messages = append(messages, message)

	sig = BGRSign(message, keys, sig)

	verify, _ :=  BGRVerify(publickeys, messages, sig.r, sig)

	if verify == false {
		t.Fatal("Failed to verify ")
	}
}

func TestTwoSigners(t *testing.T) {
	var publickeys []rsa.PublicKey
	var messages []string

	sig := NewSig()

	for i := 0; i < 2; i++ {
		keys := BGRKeyGen()
		message := "MESSAGE " + string(i)
		publickeys = append(publickeys, keys.pk)
		messages = append(messages, message)

		sig = BGRSign(message, keys, sig)
	}

	verify, _ :=  BGRVerify(publickeys, messages, sig.r, sig)

	if verify == false {
		t.Fatal("Failed to verify ")
	}
}

func TestTenSigners(t *testing.T) {
	var publickeys []rsa.PublicKey
	var messages []string

	sig := NewSig()

	for i := 0; i < 10; i++ {
		keys := BGRKeyGen()
		message := "MESSAGE " + string(i)
		publickeys = append(publickeys, keys.pk)
		messages = append(messages, message)

		sig = BGRSign(message, keys, sig)
	}

	verify, _ :=  BGRVerify(publickeys, messages, sig.r, sig)

	if verify == false {
		t.Fatal("Failed to verify ")
	}
}