
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081e7c <p384.sharedSecret>:
 1081e7c: d10483ff     	sub	sp, sp, #0x120
 1081e80: a90e7bfd     	stp	x29, x30, [sp, #0xe0]
 1081e84: f9007bfc     	str	x28, [sp, #0xf0]
 1081e88: a91057f6     	stp	x22, x21, [sp, #0x100]
 1081e8c: a9114ff4     	stp	x20, x19, [sp, #0x110]
 1081e90: 910383fd     	add	x29, sp, #0xe0
 1081e94: ad400420     	ldp	q0, q1, [x1]
 1081e98: aa0003f3     	mov	x19, x0
 1081e9c: 3dc00822     	ldr	q2, [x1, #0x20]
 1081ea0: d10043a0     	sub	x0, x29, #0x10
 1081ea4: 910183e1     	add	x1, sp, #0x60
 1081ea8: aa0203f4     	mov	x20, x2
 1081eac: ad0307e0     	stp	q0, q1, [sp, #0x60]
 1081eb0: 3d8023e2     	str	q2, [sp, #0x80]
 1081eb4: 9400934b     	bl	 <crypto.backend_openssl.p384PrivateKeyFromSecret>
 1081eb8: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081ebc: 35000548     	cbnz	w8,  <L0>
 1081ec0: ad420680     	ldp	q0, q1, [x20, #0x40]
 1081ec4: d10043a0     	sub	x0, x29, #0x10
 1081ec8: 39418288     	ldrb	w8, [x20, #0x60]
 1081ecc: 910183e1     	add	x1, sp, #0x60
 1081ed0: ad0507e0     	stp	q0, q1, [sp, #0xa0]
 1081ed4: ad400680     	ldp	q0, q1, [x20]
 1081ed8: 390303e8     	strb	w8, [sp, #0xc0]
 1081edc: ad0307e0     	stp	q0, q1, [sp, #0x60]
 1081ee0: ad410a80     	ldp	q0, q2, [x20, #0x20]
 1081ee4: f85f03b4     	ldur	x20, [x29, #-0x10]
 1081ee8: ad040be0     	stp	q0, q2, [sp, #0x80]
 1081eec: 940093ab     	bl	 <crypto.backend_openssl.p384PublicKeyFromRaw>
 1081ef0: 785f83b5     	ldurh	w21, [x29, #-0x8]
 1081ef4: 35000475     	cbnz	w21,  <L1>
 1081ef8: f85f03b5     	ldur	x21, [x29, #-0x10]
 1081efc: 910003e2     	mov	x2, sp
 1081f00: aa1403e0     	mov	x0, x20
 1081f04: aa1503e1     	mov	x1, x21
 1081f08: 94000c53     	bl	 <crypto.backend_openssl.p384SharedSecretDerive>
 1081f0c: 72003c1f     	tst	w0, #0xffff
 1081f10: 540004a1     	b.ne	 <L2>
 1081f14: ad4007e0     	ldp	q0, q1, [sp]
 1081f18: aa1503e0     	mov	x0, x21
 1081f1c: 3dc00be2     	ldr	q2, [sp, #0x20]
 1081f20: ad0187e0     	stp	q0, q1, [sp, #0x30]
 1081f24: 3d8017e2     	str	q2, [sp, #0x50]
 1081f28: 94056cd2     	bl	 <EVP_PKEY_free@plt>
 1081f2c: aa1403e0     	mov	x0, x20
 1081f30: 94056cd0     	bl	 <EVP_PKEY_free@plt>
 1081f34: ad4187e0     	ldp	q0, q1, [sp, #0x30]
 1081f38: 3dc017e2     	ldr	q2, [sp, #0x50]
 1081f3c: 7900027f     	strh	wzr, [x19]
 1081f40: 3c822262     	stur	q2, [x19, #0x22]
 1081f44: 3c802260     	stur	q0, [x19, #0x2]
 1081f48: 3c812261     	stur	q1, [x19, #0x12]
 1081f4c: a9514ff4     	ldp	x20, x19, [sp, #0x110]
 1081f50: f9407bfc     	ldr	x28, [sp, #0xf0]
 1081f54: a95057f6     	ldp	x22, x21, [sp, #0x100]
 1081f58: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 1081f5c: 910483ff     	add	sp, sp, #0x120
 1081f60: d65f03c0     	ret
<L0>:
 1081f64: 79000268     	strh	w8, [x19]
 1081f68: a9514ff4     	ldp	x20, x19, [sp, #0x110]
 1081f6c: f9407bfc     	ldr	x28, [sp, #0xf0]
 1081f70: a95057f6     	ldp	x22, x21, [sp, #0x100]
 1081f74: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 1081f78: 910483ff     	add	sp, sp, #0x120
 1081f7c: d65f03c0     	ret
<L1>:
 1081f80: aa1403e0     	mov	x0, x20
 1081f84: 94056cbb     	bl	 <EVP_PKEY_free@plt>
 1081f88: 79000275     	strh	w21, [x19]
 1081f8c: a9514ff4     	ldp	x20, x19, [sp, #0x110]
 1081f90: f9407bfc     	ldr	x28, [sp, #0xf0]
 1081f94: a95057f6     	ldp	x22, x21, [sp, #0x100]
 1081f98: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 1081f9c: 910483ff     	add	sp, sp, #0x120
 1081fa0: d65f03c0     	ret
<L2>:
 1081fa4: 2a0003f6     	mov	w22, w0
 1081fa8: aa1503e0     	mov	x0, x21
 1081fac: 94056cb1     	bl	 <EVP_PKEY_free@plt>
 1081fb0: aa1403e0     	mov	x0, x20
 1081fb4: 94056caf     	bl	 <EVP_PKEY_free@plt>
 1081fb8: 79000276     	strh	w22, [x19]
 1081fbc: a9514ff4     	ldp	x20, x19, [sp, #0x110]
 1081fc0: f9407bfc     	ldr	x28, [sp, #0xf0]
 1081fc4: a95057f6     	ldp	x22, x21, [sp, #0x100]
 1081fc8: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 1081fcc: 910483ff     	add	sp, sp, #0x120
 1081fd0: d65f03c0     	ret
