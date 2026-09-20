
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081d50 <p256.sharedSecret>:
 1081d50: d10343ff     	sub	sp, sp, #0xd0
 1081d54: a90a7bfd     	stp	x29, x30, [sp, #0xa0]
 1081d58: a90b57f6     	stp	x22, x21, [sp, #0xb0]
 1081d5c: a90c4ff4     	stp	x20, x19, [sp, #0xc0]
 1081d60: 910283fd     	add	x29, sp, #0xa0
 1081d64: ad400420     	ldp	q0, q1, [x1]
 1081d68: aa0203f4     	mov	x20, x2
 1081d6c: aa0003f3     	mov	x19, x0
 1081d70: ad0207e0     	stp	q0, q1, [sp, #0x40]
 1081d74: 94056d47     	bl	 <ERR_set_mark@plt>
 1081d78: d10043a0     	sub	x0, x29, #0x10
 1081d7c: 910103e1     	add	x1, sp, #0x40
 1081d80: 9400aa64     	bl	 <crypto.backend_openssl.p256PrivateKeyFromSecretImpl>
 1081d84: 94056d4b     	bl	 <ERR_pop_to_mark@plt>
 1081d88: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081d8c: 35000468     	cbnz	w8,  <L0>
 1081d90: ad410680     	ldp	q0, q1, [x20, #0x20]
 1081d94: d10043a0     	sub	x0, x29, #0x10
 1081d98: 39410288     	ldrb	w8, [x20, #0x40]
 1081d9c: 910103e1     	add	x1, sp, #0x40
 1081da0: ad0307e0     	stp	q0, q1, [sp, #0x60]
 1081da4: ad400281     	ldp	q1, q0, [x20]
 1081da8: f85f03b4     	ldur	x20, [x29, #-0x10]
 1081dac: 390203e8     	strb	w8, [sp, #0x80]
 1081db0: ad0203e1     	stp	q1, q0, [sp, #0x40]
 1081db4: 9400926a     	bl	 <crypto.backend_openssl.p256PublicKeyFromRaw>
 1081db8: 785f83b5     	ldurh	w21, [x29, #-0x8]
 1081dbc: 350003b5     	cbnz	w21,  <L1>
 1081dc0: f85f03b5     	ldur	x21, [x29, #-0x10]
 1081dc4: 910003e2     	mov	x2, sp
 1081dc8: aa1403e0     	mov	x0, x20
 1081dcc: aa1503e1     	mov	x1, x21
 1081dd0: 94000c69     	bl	 <crypto.backend_openssl.p256SharedSecretDerive>
 1081dd4: 72003c1f     	tst	w0, #0xffff
 1081dd8: 540003c1     	b.ne	 <L2>
 1081ddc: ad4007e0     	ldp	q0, q1, [sp]
 1081de0: aa1503e0     	mov	x0, x21
 1081de4: ad0107e0     	stp	q0, q1, [sp, #0x20]
 1081de8: 94056d22     	bl	 <EVP_PKEY_free@plt>
 1081dec: aa1403e0     	mov	x0, x20
 1081df0: 94056d20     	bl	 <EVP_PKEY_free@plt>
 1081df4: ad4107e0     	ldp	q0, q1, [sp, #0x20]
 1081df8: 7900027f     	strh	wzr, [x19]
 1081dfc: 3c802260     	stur	q0, [x19, #0x2]
 1081e00: 3c812261     	stur	q1, [x19, #0x12]
 1081e04: a94c4ff4     	ldp	x20, x19, [sp, #0xc0]
 1081e08: a94b57f6     	ldp	x22, x21, [sp, #0xb0]
 1081e0c: a94a7bfd     	ldp	x29, x30, [sp, #0xa0]
 1081e10: 910343ff     	add	sp, sp, #0xd0
 1081e14: d65f03c0     	ret
<L0>:
 1081e18: 79000268     	strh	w8, [x19]
 1081e1c: a94c4ff4     	ldp	x20, x19, [sp, #0xc0]
 1081e20: a94b57f6     	ldp	x22, x21, [sp, #0xb0]
 1081e24: a94a7bfd     	ldp	x29, x30, [sp, #0xa0]
 1081e28: 910343ff     	add	sp, sp, #0xd0
 1081e2c: d65f03c0     	ret
<L1>:
 1081e30: aa1403e0     	mov	x0, x20
 1081e34: 94056d0f     	bl	 <EVP_PKEY_free@plt>
 1081e38: 79000275     	strh	w21, [x19]
 1081e3c: a94c4ff4     	ldp	x20, x19, [sp, #0xc0]
 1081e40: a94b57f6     	ldp	x22, x21, [sp, #0xb0]
 1081e44: a94a7bfd     	ldp	x29, x30, [sp, #0xa0]
 1081e48: 910343ff     	add	sp, sp, #0xd0
 1081e4c: d65f03c0     	ret
<L2>:
 1081e50: 2a0003f6     	mov	w22, w0
 1081e54: aa1503e0     	mov	x0, x21
 1081e58: 94056d06     	bl	 <EVP_PKEY_free@plt>
 1081e5c: aa1403e0     	mov	x0, x20
 1081e60: 94056d04     	bl	 <EVP_PKEY_free@plt>
 1081e64: 79000276     	strh	w22, [x19]
 1081e68: a94c4ff4     	ldp	x20, x19, [sp, #0xc0]
 1081e6c: a94b57f6     	ldp	x22, x21, [sp, #0xb0]
 1081e70: a94a7bfd     	ldp	x29, x30, [sp, #0xa0]
 1081e74: 910343ff     	add	sp, sp, #0xd0
 1081e78: d65f03c0     	ret
