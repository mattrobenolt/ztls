
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081b78 <x25519.sharedSecret>:
 1081b78: d101c3ff     	sub	sp, sp, #0x70
 1081b7c: a9037bfd     	stp	x29, x30, [sp, #0x30]
 1081b80: f90023f7     	str	x23, [sp, #0x40]
 1081b84: a90557f6     	stp	x22, x21, [sp, #0x50]
 1081b88: a9064ff4     	stp	x20, x19, [sp, #0x60]
 1081b8c: 9100c3fd     	add	x29, sp, #0x30
 1081b90: ad400400     	ldp	q0, q1, [x0]
 1081b94: aa0203f3     	mov	x19, x2
 1081b98: aa0103f4     	mov	x20, x1
 1081b9c: ad0007e0     	stp	q0, q1, [sp]
 1081ba0: 94056c94     	bl	 <ERR_set_mark@plt>
 1081ba4: 910003e2     	mov	x2, sp
 1081ba8: 52808140     	mov	w0, #0x40a              // =1034
 1081bac: aa1f03e1     	mov	x1, xzr
 1081bb0: 52800403     	mov	w3, #0x20               // =32
 1081bb4: 94056c9f     	bl	 <EVP_PKEY_new_raw_private_key@plt>
 1081bb8: f0fffc15     	adrp	x21, 0x1004000 <__anon_415810+0x110>
 1081bbc: 9109c2b5     	add	x21, x21, #0x270
 1081bc0: b4000120     	cbz	x0,  <L0>
 1081bc4: 910063b6     	add	x22, x29, #0x18
 1081bc8: d10023b7     	sub	x23, x29, #0x8
 1081bcc: 781f83bf     	sturh	wzr, [x29, #-0x8]
 1081bd0: f9000fa0     	str	x0, [x29, #0x18]
 1081bd4: 94056c8f     	bl	 <ERR_pop_to_mark@plt>
 1081bd8: 794002e0     	ldrh	w0, [x23]
 1081bdc: 340000e0     	cbz	w0,  <L1>
 1081be0: 14000034     	b	 <L6>
<L0>:
 1081be4: 910022b7     	add	x23, x21, #0x8
 1081be8: aa1503f6     	mov	x22, x21
 1081bec: 94056c89     	bl	 <ERR_pop_to_mark@plt>
 1081bf0: 794002e0     	ldrh	w0, [x23]
 1081bf4: 350005e0     	cbnz	w0,  <L6>
<L1>:
 1081bf8: ad400680     	ldp	q0, q1, [x20]
 1081bfc: f94002d4     	ldr	x20, [x22]
 1081c00: ad0007e0     	stp	q0, q1, [sp]
 1081c04: 94056c7b     	bl	 <ERR_set_mark@plt>
 1081c08: 910003e2     	mov	x2, sp
 1081c0c: 52808140     	mov	w0, #0x40a              // =1034
 1081c10: aa1f03e1     	mov	x1, xzr
 1081c14: 52800403     	mov	w3, #0x20               // =32
 1081c18: 94056c8a     	bl	 <EVP_PKEY_new_raw_public_key@plt>
 1081c1c: b4000360     	cbz	x0,  <L3>
 1081c20: 910063b5     	add	x21, x29, #0x18
 1081c24: d10023b6     	sub	x22, x29, #0x8
 1081c28: 781f83bf     	sturh	wzr, [x29, #-0x8]
 1081c2c: f9000fa0     	str	x0, [x29, #0x18]
 1081c30: 94056c78     	bl	 <ERR_pop_to_mark@plt>
 1081c34: 794002c8     	ldrh	w8, [x22]
 1081c38: 35000308     	cbnz	w8,  <L4>
<L2>:
 1081c3c: f94002b5     	ldr	x21, [x21]
 1081c40: aa1403e0     	mov	x0, x20
 1081c44: aa1303e2     	mov	x2, x19
 1081c48: aa1503e1     	mov	x1, x21
 1081c4c: 94002892     	bl	 <crypto.backend_openssl.sharedSecretDerive>
 1081c50: 2a0003f6     	mov	w22, w0
 1081c54: 12003c17     	and	w23, w0, #0xffff
 1081c58: aa1503e0     	mov	x0, x21
 1081c5c: 94056c5d     	bl	 <EVP_PKEY_free@plt>
 1081c60: aa1403e0     	mov	x0, x20
 1081c64: 94056c5b     	bl	 <EVP_PKEY_free@plt>
 1081c68: 35000237     	cbnz	w23,  <L5>
 1081c6c: 2a1f03e0     	mov	w0, wzr
 1081c70: a9464ff4     	ldp	x20, x19, [sp, #0x60]
 1081c74: f94023f7     	ldr	x23, [sp, #0x40]
 1081c78: a94557f6     	ldp	x22, x21, [sp, #0x50]
 1081c7c: a9437bfd     	ldp	x29, x30, [sp, #0x30]
 1081c80: 9101c3ff     	add	sp, sp, #0x70
 1081c84: d65f03c0     	ret
<L3>:
 1081c88: 910022b6     	add	x22, x21, #0x8
 1081c8c: 94056c61     	bl	 <ERR_pop_to_mark@plt>
 1081c90: 794002c8     	ldrh	w8, [x22]
 1081c94: 34fffd48     	cbz	w8,  <L2>
<L4>:
 1081c98: aa1403e0     	mov	x0, x20
 1081c9c: 2a0803f5     	mov	w21, w8
 1081ca0: 94056c4c     	bl	 <EVP_PKEY_free@plt>
 1081ca4: 2a1503e0     	mov	w0, w21
 1081ca8: 14000002     	b	 <L6>
<L5>:
 1081cac: 2a1603e0     	mov	w0, w22
<L6>:
 1081cb0: 6f00e400     	movi	v0.2d, #0000000000000000
 1081cb4: 3d800660     	str	q0, [x19, #0x10]
 1081cb8: 3d800260     	str	q0, [x19]
 1081cbc: a9464ff4     	ldp	x20, x19, [sp, #0x60]
 1081cc0: f94023f7     	ldr	x23, [sp, #0x40]
 1081cc4: a94557f6     	ldp	x22, x21, [sp, #0x50]
 1081cc8: a9437bfd     	ldp	x29, x30, [sp, #0x30]
 1081ccc: 9101c3ff     	add	sp, sp, #0x70
 1081cd0: d65f03c0     	ret
