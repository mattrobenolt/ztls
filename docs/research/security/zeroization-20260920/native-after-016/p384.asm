
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010a4f00 <p384.sharedSecret>:
 10a4f00: d102c3ff     	sub	sp, sp, #0xb0
 10a4f04: a9087bfd     	stp	x29, x30, [sp, #0x80]
 10a4f08: a90957f6     	stp	x22, x21, [sp, #0x90]
 10a4f0c: a90a4ff4     	stp	x20, x19, [sp, #0xa0]
 10a4f10: 910203fd     	add	x29, sp, #0x80
 10a4f14: ad400400     	ldp	q0, q1, [x0]
 10a4f18: aa0103f5     	mov	x21, x1
 10a4f1c: 3dc00802     	ldr	q2, [x0, #0x20]
 10a4f20: d10043a0     	sub	x0, x29, #0x10
 10a4f24: 910003e1     	mov	x1, sp
 10a4f28: aa0203f3     	mov	x19, x2
 10a4f2c: ad0007e0     	stp	q0, q1, [sp]
 10a4f30: 3d800be2     	str	q2, [sp, #0x20]
 10a4f34: 94000158     	bl	 <crypto.backend_openssl.p384PrivateKeyFromSecret>
 10a4f38: 785f83b4     	ldurh	w20, [x29, #-0x8]
 10a4f3c: 35000454     	cbnz	w20,  <L1>
 10a4f40: ad4206a0     	ldp	q0, q1, [x21, #0x40]
 10a4f44: d10043a0     	sub	x0, x29, #0x10
 10a4f48: 394182a8     	ldrb	w8, [x21, #0x60]
 10a4f4c: 910003e1     	mov	x1, sp
 10a4f50: ad0207e0     	stp	q0, q1, [sp, #0x40]
 10a4f54: ad4006a0     	ldp	q0, q1, [x21]
 10a4f58: 390183e8     	strb	w8, [sp, #0x60]
 10a4f5c: ad0007e0     	stp	q0, q1, [sp]
 10a4f60: ad410aa0     	ldp	q0, q2, [x21, #0x20]
 10a4f64: f85f03b5     	ldur	x21, [x29, #-0x10]
 10a4f68: ad010be0     	stp	q0, q2, [sp, #0x20]
 10a4f6c: 94000109     	bl	 <crypto.backend_openssl.p384PublicKeyFromRaw>
 10a4f70: 785f83b4     	ldurh	w20, [x29, #-0x8]
 10a4f74: 35000254     	cbnz	w20,  <L0>
 10a4f78: f85f03b6     	ldur	x22, [x29, #-0x10]
 10a4f7c: aa1503e0     	mov	x0, x21
 10a4f80: aa1303e2     	mov	x2, x19
 10a4f84: aa1603e1     	mov	x1, x22
 10a4f88: 94000051     	bl	 <crypto.backend_openssl.p384SharedSecretDerive>
 10a4f8c: 12003c14     	and	w20, w0, #0xffff
 10a4f90: aa1603e0     	mov	x0, x22
 10a4f94: 94050017     	bl	 <EVP_PKEY_free@plt>
 10a4f98: aa1503e0     	mov	x0, x21
 10a4f9c: 94050015     	bl	 <EVP_PKEY_free@plt>
 10a4fa0: 35000134     	cbnz	w20,  <L1>
 10a4fa4: 2a1403e0     	mov	w0, w20
 10a4fa8: a94a4ff4     	ldp	x20, x19, [sp, #0xa0]
 10a4fac: a94957f6     	ldp	x22, x21, [sp, #0x90]
 10a4fb0: a9487bfd     	ldp	x29, x30, [sp, #0x80]
 10a4fb4: 9102c3ff     	add	sp, sp, #0xb0
 10a4fb8: d65f03c0     	ret
<L0>:
 10a4fbc: aa1503e0     	mov	x0, x21
 10a4fc0: 9405000c     	bl	 <EVP_PKEY_free@plt>
<L1>:
 10a4fc4: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4fc8: 3d800a60     	str	q0, [x19, #0x20]
 10a4fcc: 3d800660     	str	q0, [x19, #0x10]
 10a4fd0: 3d800260     	str	q0, [x19]
 10a4fd4: 2a1403e0     	mov	w0, w20
 10a4fd8: a94a4ff4     	ldp	x20, x19, [sp, #0xa0]
 10a4fdc: a94957f6     	ldp	x22, x21, [sp, #0x90]
 10a4fe0: a9487bfd     	ldp	x29, x30, [sp, #0x80]
 10a4fe4: 9102c3ff     	add	sp, sp, #0xb0
 10a4fe8: d65f03c0     	ret
