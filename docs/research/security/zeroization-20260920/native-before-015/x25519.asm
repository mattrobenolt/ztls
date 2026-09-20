
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081bd4 <x25519.sharedSecret>:
 1081bd4: d102c3ff     	sub	sp, sp, #0xb0
 1081bd8: a9077bfd     	stp	x29, x30, [sp, #0x70]
 1081bdc: f90043f7     	str	x23, [sp, #0x80]
 1081be0: a90957f6     	stp	x22, x21, [sp, #0x90]
 1081be4: a90a4ff4     	stp	x20, x19, [sp, #0xa0]
 1081be8: 9101c3fd     	add	x29, sp, #0x70
 1081bec: ad400420     	ldp	q0, q1, [x1]
 1081bf0: aa0203f4     	mov	x20, x2
 1081bf4: aa0003f3     	mov	x19, x0
 1081bf8: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
 1081bfc: 94056da5     	bl	 <ERR_set_mark@plt>
 1081c00: d100c3a2     	sub	x2, x29, #0x30
 1081c04: 52808140     	mov	w0, #0x40a              // =1034
 1081c08: aa1f03e1     	mov	x1, xzr
 1081c0c: 52800403     	mov	w3, #0x20               // =32
 1081c10: 94056db0     	bl	 <EVP_PKEY_new_raw_private_key@plt>
 1081c14: f0fffc15     	adrp	x21, 0x1004000 <__anon_415846+0x150>
 1081c18: 9108c2b5     	add	x21, x21, #0x230
 1081c1c: b4000340     	cbz	x0,  <L1>
 1081c20: 910063b6     	add	x22, x29, #0x18
 1081c24: d10023b7     	sub	x23, x29, #0x8
 1081c28: 781f83bf     	sturh	wzr, [x29, #-0x8]
 1081c2c: f9000fa0     	str	x0, [x29, #0x18]
 1081c30: 94056da0     	bl	 <ERR_pop_to_mark@plt>
 1081c34: 794002e8     	ldrh	w8, [x23]
 1081c38: 35000308     	cbnz	w8,  <L2>
<L0>:
 1081c3c: ad400680     	ldp	q0, q1, [x20]
 1081c40: f94002d4     	ldr	x20, [x22]
 1081c44: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
 1081c48: 94056d92     	bl	 <ERR_set_mark@plt>
 1081c4c: d100c3a2     	sub	x2, x29, #0x30
 1081c50: 52808140     	mov	w0, #0x40a              // =1034
 1081c54: aa1f03e1     	mov	x1, xzr
 1081c58: 52800403     	mov	w3, #0x20               // =32
 1081c5c: 94056da1     	bl	 <EVP_PKEY_new_raw_public_key@plt>
 1081c60: b40002a0     	cbz	x0,  <L3>
 1081c64: 910063b5     	add	x21, x29, #0x18
 1081c68: d10023b6     	sub	x22, x29, #0x8
 1081c6c: 781f83bf     	sturh	wzr, [x29, #-0x8]
 1081c70: f9000fa0     	str	x0, [x29, #0x18]
 1081c74: 94056d8f     	bl	 <ERR_pop_to_mark@plt>
 1081c78: 794002d6     	ldrh	w22, [x22]
 1081c7c: 34000256     	cbz	w22,  <L4>
 1081c80: 1400002b     	b	 <L6>
<L1>:
 1081c84: 910022b7     	add	x23, x21, #0x8
 1081c88: aa1503f6     	mov	x22, x21
 1081c8c: 94056d89     	bl	 <ERR_pop_to_mark@plt>
 1081c90: 794002e8     	ldrh	w8, [x23]
 1081c94: 34fffd48     	cbz	w8,  <L0>
<L2>:
 1081c98: 79000268     	strh	w8, [x19]
 1081c9c: a94a4ff4     	ldp	x20, x19, [sp, #0xa0]
 1081ca0: f94043f7     	ldr	x23, [sp, #0x80]
 1081ca4: a94957f6     	ldp	x22, x21, [sp, #0x90]
 1081ca8: a9477bfd     	ldp	x29, x30, [sp, #0x70]
 1081cac: 9102c3ff     	add	sp, sp, #0xb0
 1081cb0: d65f03c0     	ret
<L3>:
 1081cb4: 910022b6     	add	x22, x21, #0x8
 1081cb8: 94056d7e     	bl	 <ERR_pop_to_mark@plt>
 1081cbc: 794002d6     	ldrh	w22, [x22]
 1081cc0: 35000376     	cbnz	w22,  <L6>
<L4>:
 1081cc4: f94002b5     	ldr	x21, [x21]
 1081cc8: 910003e2     	mov	x2, sp
 1081ccc: aa1403e0     	mov	x0, x20
 1081cd0: aa1503e1     	mov	x1, x21
 1081cd4: 940028a1     	bl	 <crypto.backend_openssl.sharedSecretDerive>
 1081cd8: 72003c1f     	tst	w0, #0xffff
 1081cdc: 54000221     	b.ne	 <L5>
 1081ce0: ad4007e0     	ldp	q0, q1, [sp]
 1081ce4: aa1503e0     	mov	x0, x21
 1081ce8: ad0107e0     	stp	q0, q1, [sp, #0x20]
 1081cec: 94056d61     	bl	 <EVP_PKEY_free@plt>
 1081cf0: aa1403e0     	mov	x0, x20
 1081cf4: 94056d5f     	bl	 <EVP_PKEY_free@plt>
 1081cf8: ad4107e0     	ldp	q0, q1, [sp, #0x20]
 1081cfc: 7900027f     	strh	wzr, [x19]
 1081d00: 3c802260     	stur	q0, [x19, #0x2]
 1081d04: 3c812261     	stur	q1, [x19, #0x12]
 1081d08: a94a4ff4     	ldp	x20, x19, [sp, #0xa0]
 1081d0c: f94043f7     	ldr	x23, [sp, #0x80]
 1081d10: a94957f6     	ldp	x22, x21, [sp, #0x90]
 1081d14: a9477bfd     	ldp	x29, x30, [sp, #0x70]
 1081d18: 9102c3ff     	add	sp, sp, #0xb0
 1081d1c: d65f03c0     	ret
<L5>:
 1081d20: 2a0003f6     	mov	w22, w0
 1081d24: aa1503e0     	mov	x0, x21
 1081d28: 94056d52     	bl	 <EVP_PKEY_free@plt>
<L6>:
 1081d2c: aa1403e0     	mov	x0, x20
 1081d30: 94056d50     	bl	 <EVP_PKEY_free@plt>
 1081d34: 79000276     	strh	w22, [x19]
 1081d38: a94a4ff4     	ldp	x20, x19, [sp, #0xa0]
 1081d3c: f94043f7     	ldr	x23, [sp, #0x80]
 1081d40: a94957f6     	ldp	x22, x21, [sp, #0x90]
 1081d44: a9477bfd     	ldp	x29, x30, [sp, #0x70]
 1081d48: 9102c3ff     	add	sp, sp, #0xb0
 1081d4c: d65f03c0     	ret
