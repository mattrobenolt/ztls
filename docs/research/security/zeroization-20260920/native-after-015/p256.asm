
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081cd4 <p256.sharedSecret>:
 1081cd4: d10283ff     	sub	sp, sp, #0xa0
 1081cd8: a9067bfd     	stp	x29, x30, [sp, #0x60]
 1081cdc: f9003bf7     	str	x23, [sp, #0x70]
 1081ce0: a90857f6     	stp	x22, x21, [sp, #0x80]
 1081ce4: a9094ff4     	stp	x20, x19, [sp, #0x90]
 1081ce8: 910183fd     	add	x29, sp, #0x60
 1081cec: ad400400     	ldp	q0, q1, [x0]
 1081cf0: aa0203f3     	mov	x19, x2
 1081cf4: aa0103f4     	mov	x20, x1
 1081cf8: ad0007e0     	stp	q0, q1, [sp]
 1081cfc: 94056c3d     	bl	 <ERR_set_mark@plt>
 1081d00: d10043a0     	sub	x0, x29, #0x10
 1081d04: 910003e1     	mov	x1, sp
 1081d08: 9400aa3d     	bl	 <crypto.backend_openssl.p256PrivateKeyFromSecretImpl>
 1081d0c: 94056c41     	bl	 <ERR_pop_to_mark@plt>
 1081d10: 785f83a0     	ldurh	w0, [x29, #-0x8]
 1081d14: 350004c0     	cbnz	w0,  <L2>
 1081d18: ad410680     	ldp	q0, q1, [x20, #0x20]
 1081d1c: d10043a0     	sub	x0, x29, #0x10
 1081d20: 39410288     	ldrb	w8, [x20, #0x40]
 1081d24: 910003e1     	mov	x1, sp
 1081d28: ad0107e0     	stp	q0, q1, [sp, #0x20]
 1081d2c: ad400281     	ldp	q1, q0, [x20]
 1081d30: f85f03b4     	ldur	x20, [x29, #-0x10]
 1081d34: 390103e8     	strb	w8, [sp, #0x40]
 1081d38: ad0003e1     	stp	q1, q0, [sp]
 1081d3c: 9400923c     	bl	 <crypto.backend_openssl.p256PublicKeyFromRaw>
 1081d40: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081d44: 35000288     	cbnz	w8,  <L0>
 1081d48: f85f03b5     	ldur	x21, [x29, #-0x10]
 1081d4c: aa1403e0     	mov	x0, x20
 1081d50: aa1303e2     	mov	x2, x19
 1081d54: aa1503e1     	mov	x1, x21
 1081d58: 94000c56     	bl	 <crypto.backend_openssl.p256SharedSecretDerive>
 1081d5c: 2a0003f6     	mov	w22, w0
 1081d60: 12003c17     	and	w23, w0, #0xffff
 1081d64: aa1503e0     	mov	x0, x21
 1081d68: 94056c1a     	bl	 <EVP_PKEY_free@plt>
 1081d6c: aa1403e0     	mov	x0, x20
 1081d70: 94056c18     	bl	 <EVP_PKEY_free@plt>
 1081d74: 350001b7     	cbnz	w23,  <L1>
 1081d78: 2a1f03e0     	mov	w0, wzr
 1081d7c: a9494ff4     	ldp	x20, x19, [sp, #0x90]
 1081d80: f9403bf7     	ldr	x23, [sp, #0x70]
 1081d84: a94857f6     	ldp	x22, x21, [sp, #0x80]
 1081d88: a9467bfd     	ldp	x29, x30, [sp, #0x60]
 1081d8c: 910283ff     	add	sp, sp, #0xa0
 1081d90: d65f03c0     	ret
<L0>:
 1081d94: aa1403e0     	mov	x0, x20
 1081d98: 2a0803f5     	mov	w21, w8
 1081d9c: 94056c0d     	bl	 <EVP_PKEY_free@plt>
 1081da0: 2a1503e0     	mov	w0, w21
 1081da4: 14000002     	b	 <L2>
<L1>:
 1081da8: 2a1603e0     	mov	w0, w22
<L2>:
 1081dac: 6f00e400     	movi	v0.2d, #0000000000000000
 1081db0: 3d800660     	str	q0, [x19, #0x10]
 1081db4: 3d800260     	str	q0, [x19]
 1081db8: a9494ff4     	ldp	x20, x19, [sp, #0x90]
 1081dbc: f9403bf7     	ldr	x23, [sp, #0x70]
 1081dc0: a94857f6     	ldp	x22, x21, [sp, #0x80]
 1081dc4: a9467bfd     	ldp	x29, x30, [sp, #0x60]
 1081dc8: 910283ff     	add	sp, sp, #0xa0
 1081dcc: d65f03c0     	ret
