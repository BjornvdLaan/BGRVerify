// Copyright (C) 2018 Authors
// distributed under Apache 2.0 license

package bgls

import (
	"crypto/rand"
	"math/big"
	"os"
	"testing"

	. "../curves"
	"github.com/stretchr/testify/assert"
	"fmt"
)

var curves = []CurveSystem{Altbn128}
var benchmarkCurve = Altbn128

func TestSingleSigner(t *testing.T) {
	for _, curve := range curves {
		sk, vk, err := KeyGen(curve)
		assert.Nil(t, err, "Key generation failed")
		d := make([]byte, 64)
		_, err = rand.Read(d)
		assert.Nil(t, err, "test data generation failed")
		sig := Sign(curve, sk, d)
		assert.True(t, VerifySingleSignature(curve, sig, vk, d), "Standard BLS "+
			"signature verification failed")

		sigTmp := sig.Copy()
		sigTmp, _ = sigTmp.Add(curve.GetG1())
		sig2 := sigTmp
		assert.False(t, VerifySingleSignature(curve, sig2, vk, d), "Standard BLS "+
			"signature verification succeeding when it shouldn't")

		// TODO Add tests to show that this doesn't succeed if d or vk is altered
	}
}

func TestAggregation(t *testing.T) {
	for _, curve := range curves {
		N, Size := 6, 32
		msgs := make([][]byte, N+1)
		sigs := make([]Point, N+1)
		pubkeys := make([]Point, N+1)
		for i := 0; i < N; i++ {
			msgs[i] = make([]byte, Size)
			rand.Read(msgs[i])

			sk, vk, _ := KeyGen(curve)
			sig := Sign(curve, sk, msgs[i])
			pubkeys[i] = vk
			sigs[i] = sig
		}
		aggSig := AggregateSignatures(sigs[:N])
		assert.True(t, VerifyAggregateSignature(curve, aggSig, pubkeys[:N], msgs[:N]),
			"Aggregate Point1 verification failed")
		assert.False(t, VerifyAggregateSignature(curve, aggSig, pubkeys[:N-1], msgs[:N]),
			"Aggregate Point1 verification succeeding without enough pubkeys")
		skf, vkf, _ := KeyGen(curve)
		pubkeys[N] = vkf
		sigs[N] = Sign(curve, skf, msgs[0])
		msgs[N] = msgs[0]
		aggSig = AggregateSignatures(sigs)
		assert.False(t, VerifyAggregateSignature(curve, aggSig, pubkeys, msgs),
			"Aggregate Signature succeeding with duplicate messages")
		assert.False(t, VerifyAggregateSignature(curve, aggSig, pubkeys[:N], msgs[:N]),
			"Aggregate Point1 succeeding with invalid signature")
		msgs[0] = msgs[1]
		msgs[1] = msgs[N]
		aggSig = AggregateSignatures(sigs[:N])
		assert.False(t, VerifyAggregateSignature(curve, aggSig, pubkeys[:N], msgs[:N]),
			"Aggregate Point1 succeeded with messages 0 and 1 switched")

		// TODO Add tests to make sure there is no mutation
	}
}

func BenchmarkKeygen(b *testing.B) {
	b.ResetTimer()
	curve := Altbn128
	for i := 0; i < b.N; i++ {
		_, _, res := KeyGen(curve)
		if res != nil {
			b.Error("key gen failure")
		}
	}
}

func BenchmarkAltBnHashToCurve(b *testing.B) {
	curve := Altbn128
	ms := make([][]byte, b.N)
	for i := 0; i < b.N; i++ {
		ms[i] = make([]byte, 64)
		rand.Read(ms[i])
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		curve.HashToG1(ms[i])
	}
}

func BenchmarkSigning(b *testing.B) {
	curve := Altbn128
	sks := make([]*big.Int, b.N)
	ms := make([][]byte, b.N)
	for i := 0; i < b.N; i++ {
		ms[i] = make([]byte, 64)
		rand.Read(ms[i])
		sk, _, _ := KeyGen(curve)
		sks[i] = sk
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_ = Sign(curve, sks[i], ms[i])
	}
}

func BenchmarkVerification(b *testing.B) {
	curve := Altbn128
	message := make([]byte, 64)
	rand.Read(message)
	sk, vk, _ := KeyGen(curve)
	sig := Sign(curve, sk, message)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		if !VerifySingleSignature(curve, sig, vk, message) {
			b.Error("verification failed")
		}
	}
}

var vks []Point
var sgs []Point
var msg []byte

func TestMain(m *testing.M) {
	vks = make([]Point, 2048)
	sgs = make([]Point, 2048)
	msg = make([]byte, 64)
	rand.Read(msg)
	for i := 0; i < 2048; i++ {
		sk, vk, _ := KeyGen(benchmarkCurve)
		vks[i] = vk
		sgs[i] = DistinctMsgSign(benchmarkCurve, sk, msg)
	}
	os.Exit(m.Run())
}

func BenchmarkAggregateVerification(b *testing.B) {
	verifkeys := make([]Point, b.N)
	sigs := make([]Point, b.N)
	messages := make([][]byte, b.N)
	for i := 0; i < b.N; i++ {
		messages[i] = make([]byte, 64)
		rand.Read(messages[i])
		sk, vk, _ := KeyGen(benchmarkCurve)
		verifkeys[i] = vk
		sigs[i] = Sign(benchmarkCurve, sk, messages[i])
	}
	aggsig := AggregateSignatures(sigs)
	b.ResetTimer()
	if !VerifyAggregateSignature(benchmarkCurve, aggsig, verifkeys, messages) {
		b.Error("Aggregate verificaton failed")
	}
}

func TestDistinctMsgSingleSigner(t *testing.T) {
	fmt.Println(curves)
	for _, curve := range curves {
		sk, vk, err := KeyGen(curve)
		assert.Nil(t, err, "Key generation failed")
		msg := make([]byte, 64)
		_, err = rand.Read(msg)
		assert.Nil(t, err, "test data generation failed")
		sig := DistinctMsgSign(curve, sk, msg)
		assert.True(t, DistinctMsgVerifySingleSignature(curve, sig, vk, msg), "Point1 verification failed")

		sig2 := sig.Copy()
		sig2, _ = sig2.Add(curve.GetG1())
		assert.False(t, DistinctMsgVerifySingleSignature(curve, sig2, vk, msg), "Point1 verification succeeding when it shouldn't")
	}
}

func TestDistinctMsgAggregation(t *testing.T) {
	fmt.Println(curves)

	for _, curve := range curves {
		N, Size := 6, 32
		msgs := make([][]byte, N)
		sigs := make([]Point, N)
		pubkeys := make([]Point, N)
		for i := 0; i < N; i++ {
			msgs[i] = make([]byte, Size)
			rand.Read(msgs[i])

			sk, vk, _ := KeyGen(curve)
			sig := DistinctMsgSign(curve, sk, msgs[i])
			pubkeys[i] = vk
			sigs[i] = sig
		}
		aggSig := AggregatePoints(sigs)
		assert.True(t, DistinctMsgVerifyAggregateSignature(curve, aggSig, pubkeys, msgs),
			"Aggregate Point1 verification failed")
		assert.False(t, DistinctMsgVerifyAggregateSignature(curve, aggSig, pubkeys[:N-1], msgs),
			"Aggregate Point1 verification succeeding without enough pubkeys")
		msgs[0] = msgs[1]
		aggSig = AggregatePoints(sigs)
		assert.False(t, VerifyAggregateSignature(curve, aggSig, pubkeys, msgs),
			"Aggregate Point1 succeeded with messages 0 and 1 switched")

		// TODO Add tests to make sure there is no mutation
	}
}
