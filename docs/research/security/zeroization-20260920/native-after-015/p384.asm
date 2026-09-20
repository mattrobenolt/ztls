
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081dd0 <p384.sharedSecret>:
 1081dd0: d10303ff     	sub	sp, sp, #0xc0
 1081dd4: a9087bfd     	stp	x29, x30, [sp, #0x80]
 1081dd8: f9004bf7     	str	x23, [sp, #0x90]
 1081ddc: a90a57f6     	stp	x22, x21, [sp, #0xa0]
 1081de0: a90b4ff4     	stp	x20, x19, [sp, #0xb0]
 1081de4: 910203fd     	add	x29, sp, #0x80
 1081de8: ad400400     	ldp	q0, q1, [x0]
 1081dec: aa0103f4     	mov	x20, x1
 1081df0: 3dc00802     	ldr	q2, [x0, #0x20]
 1081df4: d10043a0     	sub	x0, x29, #0x10
 1081df8: 910003e1     	mov	x1, sp
 1081dfc: aa0203f3     	mov	x19, x2
 1081e00: ad0007e0     	stp	q0, q1, [sp]
 1081e04: 3d800be2     	str	q2, [sp, #0x20]
 1081e08: 9400932a     	bl	 <crypto.backend_openssl.p384PrivateKeyFromSecret>
 1081e0c: 785f83a0     	ldurh	w0, [x29, #-0x8]
 1081e10: 35000500     	cbnz	w0,  <L2>
 1081e14: ad420680     	ldp	q0, q1, [x20, #0x40]
 1081e18: d10043a0     	sub	x0, x29, #0x10
 1081e1c: 39418288     	ldrb	w8, [x20, #0x60]
 1081e20: 910003e1     	mov	x1, sp
 1081e24: ad0207e0     	stp	q0, q1, [sp, #0x40]
 1081e28: ad400680     	ldp	q0, q1, [x20]
 1081e2c: 390183e8     	strb	w8, [sp, #0x60]
 1081e30: ad0007e0     	stp	q0, q1, [sp]
 1081e34: ad410a80     	ldp	q0, q2, [x20, #0x20]
 1081e38: f85f03b4     	ldur	x20, [x29, #-0x10]
 1081e3c: ad010be0     	stp	q0, q2, [sp, #0x20]
 1081e40: 9400938a     	bl	 <crypto.backend_openssl.p384PublicKeyFromRaw>
 1081e44: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081e48: 35000288     	cbnz	w8,  <L0>
 1081e4c: f85f03b5     	ldur	x21, [x29, #-0x10]
 1081e50: aa1403e0     	mov	x0, x20
 1081e54: aa1303e2     	mov	x2, x19
 1081e58: aa1503e1     	mov	x1, x21
 1081e5c: 94000c4d     	bl	 <crypto.backend_openssl.p384SharedSecretDerive>
 1081e60: 2a0003f6     	mov	w22, w0
 1081e64: 12003c17     	and	w23, w0, #0xffff
 1081e68: aa1503e0     	mov	x0, x21
 1081e6c: 94056bd9     	bl	 <EVP_PKEY_free@plt>
 1081e70: aa1403e0     	mov	x0, x20
 1081e74: 94056bd7     	bl	 <EVP_PKEY_free@plt>
 1081e78: 350001b7     	cbnz	w23,  <L1>
 1081e7c: 2a1f03e0     	mov	w0, wzr
 1081e80: a94b4ff4     	ldp	x20, x19, [sp, #0xb0]
 1081e84: f9404bf7     	ldr	x23, [sp, #0x90]
 1081e88: a94a57f6     	ldp	x22, x21, [sp, #0xa0]
 1081e8c: a9487bfd     	ldp	x29, x30, [sp, #0x80]
 1081e90: 910303ff     	add	sp, sp, #0xc0
 1081e94: d65f03c0     	ret
<L0>:
 1081e98: aa1403e0     	mov	x0, x20
 1081e9c: 2a0803f5     	mov	w21, w8
 1081ea0: 94056bcc     	bl	 <EVP_PKEY_free@plt>
 1081ea4: 2a1503e0     	mov	w0, w21
 1081ea8: 14000002     	b	 <L2>
<L1>:
 1081eac: 2a1603e0     	mov	w0, w22
<L2>:
 1081eb0: 6f00e400     	movi	v0.2d, #0000000000000000
 1081eb4: 3d800a60     	str	q0, [x19, #0x20]
 1081eb8: 3d800660     	str	q0, [x19, #0x10]
 1081ebc: 3d800260     	str	q0, [x19]
 1081ec0: a94b4ff4     	ldp	x20, x19, [sp, #0xb0]
 1081ec4: f9404bf7     	ldr	x23, [sp, #0x90]
 1081ec8: a94a57f6     	ldp	x22, x21, [sp, #0xa0]
 1081ecc: a9487bfd     	ldp	x29, x30, [sp, #0x80]
 1081ed0: 910303ff     	add	sp, sp, #0xc0
 1081ed4: d65f03c0     	ret
