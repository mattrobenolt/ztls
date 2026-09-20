
zig-out/memory.N4aX4N/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081b18 <x25519.sharedSecret>:
 1081b18: d101c3ff     	sub	sp, sp, #0x70
 1081b1c: a9037bfd     	stp	x29, x30, [sp, #0x30]
 1081b20: f90023f7     	str	x23, [sp, #0x40]
 1081b24: a90557f6     	stp	x22, x21, [sp, #0x50]
 1081b28: a9064ff4     	stp	x20, x19, [sp, #0x60]
 1081b2c: 9100c3fd     	add	x29, sp, #0x30
 1081b30: ad400400     	ldp	q0, q1, [x0]
 1081b34: aa0203f3     	mov	x19, x2
 1081b38: aa0103f4     	mov	x20, x1
 1081b3c: ad0007e0     	stp	q0, q1, [sp]
 1081b40: 94056c94     	bl	 <ERR_set_mark@plt>
 1081b44: 910003e2     	mov	x2, sp
 1081b48: 52808140     	mov	w0, #0x40a              // =1034
 1081b4c: aa1f03e1     	mov	x1, xzr
 1081b50: 52800403     	mov	w3, #0x20               // =32
 1081b54: 94056c9f     	bl	 <EVP_PKEY_new_raw_private_key@plt>
 1081b58: f0fffc15     	adrp	x21, 0x1004000 <__anon_415806+0x110>
 1081b5c: 9109c2b5     	add	x21, x21, #0x270
 1081b60: b4000120     	cbz	x0,  <L0>
 1081b64: 910063b6     	add	x22, x29, #0x18
 1081b68: d10023b7     	sub	x23, x29, #0x8
 1081b6c: 781f83bf     	sturh	wzr, [x29, #-0x8]
 1081b70: f9000fa0     	str	x0, [x29, #0x18]
 1081b74: 94056c8f     	bl	 <ERR_pop_to_mark@plt>
 1081b78: 794002e0     	ldrh	w0, [x23]
 1081b7c: 340000e0     	cbz	w0,  <L1>
 1081b80: 14000034     	b	 <L6>
<L0>:
 1081b84: 910022b7     	add	x23, x21, #0x8
 1081b88: aa1503f6     	mov	x22, x21
 1081b8c: 94056c89     	bl	 <ERR_pop_to_mark@plt>
 1081b90: 794002e0     	ldrh	w0, [x23]
 1081b94: 350005e0     	cbnz	w0,  <L6>
<L1>:
 1081b98: ad400680     	ldp	q0, q1, [x20]
 1081b9c: f94002d4     	ldr	x20, [x22]
 1081ba0: ad0007e0     	stp	q0, q1, [sp]
 1081ba4: 94056c7b     	bl	 <ERR_set_mark@plt>
 1081ba8: 910003e2     	mov	x2, sp
 1081bac: 52808140     	mov	w0, #0x40a              // =1034
 1081bb0: aa1f03e1     	mov	x1, xzr
 1081bb4: 52800403     	mov	w3, #0x20               // =32
 1081bb8: 94056c8a     	bl	 <EVP_PKEY_new_raw_public_key@plt>
 1081bbc: b4000360     	cbz	x0,  <L3>
 1081bc0: 910063b5     	add	x21, x29, #0x18
 1081bc4: d10023b6     	sub	x22, x29, #0x8
 1081bc8: 781f83bf     	sturh	wzr, [x29, #-0x8]
 1081bcc: f9000fa0     	str	x0, [x29, #0x18]
 1081bd0: 94056c78     	bl	 <ERR_pop_to_mark@plt>
 1081bd4: 794002c8     	ldrh	w8, [x22]
 1081bd8: 35000308     	cbnz	w8,  <L4>
<L2>:
 1081bdc: f94002b5     	ldr	x21, [x21]
 1081be0: aa1403e0     	mov	x0, x20
 1081be4: aa1303e2     	mov	x2, x19
 1081be8: aa1503e1     	mov	x1, x21
 1081bec: 94002892     	bl	 <crypto.backend_openssl.sharedSecretDerive>
 1081bf0: 2a0003f6     	mov	w22, w0
 1081bf4: 12003c17     	and	w23, w0, #0xffff
 1081bf8: aa1503e0     	mov	x0, x21
 1081bfc: 94056c5d     	bl	 <EVP_PKEY_free@plt>
 1081c00: aa1403e0     	mov	x0, x20
 1081c04: 94056c5b     	bl	 <EVP_PKEY_free@plt>
 1081c08: 35000237     	cbnz	w23,  <L5>
 1081c0c: 2a1f03e0     	mov	w0, wzr
 1081c10: a9464ff4     	ldp	x20, x19, [sp, #0x60]
 1081c14: f94023f7     	ldr	x23, [sp, #0x40]
 1081c18: a94557f6     	ldp	x22, x21, [sp, #0x50]
 1081c1c: a9437bfd     	ldp	x29, x30, [sp, #0x30]
 1081c20: 9101c3ff     	add	sp, sp, #0x70
 1081c24: d65f03c0     	ret
<L3>:
 1081c28: 910022b6     	add	x22, x21, #0x8
 1081c2c: 94056c61     	bl	 <ERR_pop_to_mark@plt>
 1081c30: 794002c8     	ldrh	w8, [x22]
 1081c34: 34fffd48     	cbz	w8,  <L2>
<L4>:
 1081c38: aa1403e0     	mov	x0, x20
 1081c3c: 2a0803f5     	mov	w21, w8
 1081c40: 94056c4c     	bl	 <EVP_PKEY_free@plt>
 1081c44: 2a1503e0     	mov	w0, w21
 1081c48: 14000002     	b	 <L6>
<L5>:
 1081c4c: 2a1603e0     	mov	w0, w22
<L6>:
 1081c50: 6f00e400     	movi	v0.2d, #0000000000000000
 1081c54: 3d800660     	str	q0, [x19, #0x10]
 1081c58: 3d800260     	str	q0, [x19]
 1081c5c: a9464ff4     	ldp	x20, x19, [sp, #0x60]
 1081c60: f94023f7     	ldr	x23, [sp, #0x40]
 1081c64: a94557f6     	ldp	x22, x21, [sp, #0x50]
 1081c68: a9437bfd     	ldp	x29, x30, [sp, #0x30]
 1081c6c: 9101c3ff     	add	sp, sp, #0x70
 1081c70: d65f03c0     	ret

0000000001081c74 <p256.sharedSecret>:
 1081c74: d10283ff     	sub	sp, sp, #0xa0
 1081c78: a9067bfd     	stp	x29, x30, [sp, #0x60]
 1081c7c: f9003bf7     	str	x23, [sp, #0x70]
 1081c80: a90857f6     	stp	x22, x21, [sp, #0x80]
 1081c84: a9094ff4     	stp	x20, x19, [sp, #0x90]
 1081c88: 910183fd     	add	x29, sp, #0x60
 1081c8c: ad400400     	ldp	q0, q1, [x0]
 1081c90: aa0203f3     	mov	x19, x2
 1081c94: aa0103f4     	mov	x20, x1
 1081c98: ad0007e0     	stp	q0, q1, [sp]
 1081c9c: 94056c3d     	bl	 <ERR_set_mark@plt>
 1081ca0: d10043a0     	sub	x0, x29, #0x10
 1081ca4: 910003e1     	mov	x1, sp
 1081ca8: 9400aa3d     	bl	 <crypto.backend_openssl.p256PrivateKeyFromSecretImpl>
 1081cac: 94056c41     	bl	 <ERR_pop_to_mark@plt>
 1081cb0: 785f83a0     	ldurh	w0, [x29, #-0x8]
 1081cb4: 350004c0     	cbnz	w0,  <L2>
 1081cb8: ad410680     	ldp	q0, q1, [x20, #0x20]
 1081cbc: d10043a0     	sub	x0, x29, #0x10
 1081cc0: 39410288     	ldrb	w8, [x20, #0x40]
 1081cc4: 910003e1     	mov	x1, sp
 1081cc8: ad0107e0     	stp	q0, q1, [sp, #0x20]
 1081ccc: ad400281     	ldp	q1, q0, [x20]
 1081cd0: f85f03b4     	ldur	x20, [x29, #-0x10]
 1081cd4: 390103e8     	strb	w8, [sp, #0x40]
 1081cd8: ad0003e1     	stp	q1, q0, [sp]
 1081cdc: 9400923c     	bl	 <crypto.backend_openssl.p256PublicKeyFromRaw>
 1081ce0: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081ce4: 35000288     	cbnz	w8,  <L0>
 1081ce8: f85f03b5     	ldur	x21, [x29, #-0x10]
 1081cec: aa1403e0     	mov	x0, x20
 1081cf0: aa1303e2     	mov	x2, x19
 1081cf4: aa1503e1     	mov	x1, x21
 1081cf8: 94000c56     	bl	 <crypto.backend_openssl.p256SharedSecretDerive>
 1081cfc: 2a0003f6     	mov	w22, w0
 1081d00: 12003c17     	and	w23, w0, #0xffff
 1081d04: aa1503e0     	mov	x0, x21
 1081d08: 94056c1a     	bl	 <EVP_PKEY_free@plt>
 1081d0c: aa1403e0     	mov	x0, x20
 1081d10: 94056c18     	bl	 <EVP_PKEY_free@plt>
 1081d14: 350001b7     	cbnz	w23,  <L1>
 1081d18: 2a1f03e0     	mov	w0, wzr
 1081d1c: a9494ff4     	ldp	x20, x19, [sp, #0x90]
 1081d20: f9403bf7     	ldr	x23, [sp, #0x70]
 1081d24: a94857f6     	ldp	x22, x21, [sp, #0x80]
 1081d28: a9467bfd     	ldp	x29, x30, [sp, #0x60]
 1081d2c: 910283ff     	add	sp, sp, #0xa0
 1081d30: d65f03c0     	ret
<L0>:
 1081d34: aa1403e0     	mov	x0, x20
 1081d38: 2a0803f5     	mov	w21, w8
 1081d3c: 94056c0d     	bl	 <EVP_PKEY_free@plt>
 1081d40: 2a1503e0     	mov	w0, w21
 1081d44: 14000002     	b	 <L2>
<L1>:
 1081d48: 2a1603e0     	mov	w0, w22
<L2>:
 1081d4c: 6f00e400     	movi	v0.2d, #0000000000000000
 1081d50: 3d800660     	str	q0, [x19, #0x10]
 1081d54: 3d800260     	str	q0, [x19]
 1081d58: a9494ff4     	ldp	x20, x19, [sp, #0x90]
 1081d5c: f9403bf7     	ldr	x23, [sp, #0x70]
 1081d60: a94857f6     	ldp	x22, x21, [sp, #0x80]
 1081d64: a9467bfd     	ldp	x29, x30, [sp, #0x60]
 1081d68: 910283ff     	add	sp, sp, #0xa0
 1081d6c: d65f03c0     	ret

0000000001081d70 <p384.sharedSecret>:
 1081d70: d10303ff     	sub	sp, sp, #0xc0
 1081d74: a9087bfd     	stp	x29, x30, [sp, #0x80]
 1081d78: f9004bf7     	str	x23, [sp, #0x90]
 1081d7c: a90a57f6     	stp	x22, x21, [sp, #0xa0]
 1081d80: a90b4ff4     	stp	x20, x19, [sp, #0xb0]
 1081d84: 910203fd     	add	x29, sp, #0x80
 1081d88: ad400400     	ldp	q0, q1, [x0]
 1081d8c: aa0103f4     	mov	x20, x1
 1081d90: 3dc00802     	ldr	q2, [x0, #0x20]
 1081d94: d10043a0     	sub	x0, x29, #0x10
 1081d98: 910003e1     	mov	x1, sp
 1081d9c: aa0203f3     	mov	x19, x2
 1081da0: ad0007e0     	stp	q0, q1, [sp]
 1081da4: 3d800be2     	str	q2, [sp, #0x20]
 1081da8: 9400932a     	bl	 <crypto.backend_openssl.p384PrivateKeyFromSecret>
 1081dac: 785f83a0     	ldurh	w0, [x29, #-0x8]
 1081db0: 35000500     	cbnz	w0,  <L2>
 1081db4: ad420680     	ldp	q0, q1, [x20, #0x40]
 1081db8: d10043a0     	sub	x0, x29, #0x10
 1081dbc: 39418288     	ldrb	w8, [x20, #0x60]
 1081dc0: 910003e1     	mov	x1, sp
 1081dc4: ad0207e0     	stp	q0, q1, [sp, #0x40]
 1081dc8: ad400680     	ldp	q0, q1, [x20]
 1081dcc: 390183e8     	strb	w8, [sp, #0x60]
 1081dd0: ad0007e0     	stp	q0, q1, [sp]
 1081dd4: ad410a80     	ldp	q0, q2, [x20, #0x20]
 1081dd8: f85f03b4     	ldur	x20, [x29, #-0x10]
 1081ddc: ad010be0     	stp	q0, q2, [sp, #0x20]
 1081de0: 9400938a     	bl	 <crypto.backend_openssl.p384PublicKeyFromRaw>
 1081de4: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081de8: 35000288     	cbnz	w8,  <L0>
 1081dec: f85f03b5     	ldur	x21, [x29, #-0x10]
 1081df0: aa1403e0     	mov	x0, x20
 1081df4: aa1303e2     	mov	x2, x19
 1081df8: aa1503e1     	mov	x1, x21
 1081dfc: 94000c4d     	bl	 <crypto.backend_openssl.p384SharedSecretDerive>
 1081e00: 2a0003f6     	mov	w22, w0
 1081e04: 12003c17     	and	w23, w0, #0xffff
 1081e08: aa1503e0     	mov	x0, x21
 1081e0c: 94056bd9     	bl	 <EVP_PKEY_free@plt>
 1081e10: aa1403e0     	mov	x0, x20
 1081e14: 94056bd7     	bl	 <EVP_PKEY_free@plt>
 1081e18: 350001b7     	cbnz	w23,  <L1>
 1081e1c: 2a1f03e0     	mov	w0, wzr
 1081e20: a94b4ff4     	ldp	x20, x19, [sp, #0xb0]
 1081e24: f9404bf7     	ldr	x23, [sp, #0x90]
 1081e28: a94a57f6     	ldp	x22, x21, [sp, #0xa0]
 1081e2c: a9487bfd     	ldp	x29, x30, [sp, #0x80]
 1081e30: 910303ff     	add	sp, sp, #0xc0
 1081e34: d65f03c0     	ret
<L0>:
 1081e38: aa1403e0     	mov	x0, x20
 1081e3c: 2a0803f5     	mov	w21, w8
 1081e40: 94056bcc     	bl	 <EVP_PKEY_free@plt>
 1081e44: 2a1503e0     	mov	w0, w21
 1081e48: 14000002     	b	 <L2>
<L1>:
 1081e4c: 2a1603e0     	mov	w0, w22
<L2>:
 1081e50: 6f00e400     	movi	v0.2d, #0000000000000000
 1081e54: 3d800a60     	str	q0, [x19, #0x20]
 1081e58: 3d800660     	str	q0, [x19, #0x10]
 1081e5c: 3d800260     	str	q0, [x19]
 1081e60: a94b4ff4     	ldp	x20, x19, [sp, #0xb0]
 1081e64: f9404bf7     	ldr	x23, [sp, #0x90]
 1081e68: a94a57f6     	ldp	x22, x21, [sp, #0xa0]
 1081e6c: a9487bfd     	ldp	x29, x30, [sp, #0x80]
 1081e70: 910303ff     	add	sp, sp, #0xc0
 1081e74: d65f03c0     	ret
