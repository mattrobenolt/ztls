
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107be78 <x25519.sharedSecret>:
 107be78: d101c3ff     	sub	sp, sp, #0x70
 107be7c: a9037bfd     	stp	x29, x30, [sp, #0x30]
 107be80: f90023f7     	str	x23, [sp, #0x40]
 107be84: a90557f6     	stp	x22, x21, [sp, #0x50]
 107be88: a9064ff4     	stp	x20, x19, [sp, #0x60]
 107be8c: 9100c3fd     	add	x29, sp, #0x30
 107be90: ad400400     	ldp	q0, q1, [x0]
 107be94: aa0203f3     	mov	x19, x2
 107be98: aa0103f4     	mov	x20, x1
 107be9c: ad0007e0     	stp	q0, q1, [sp]
 107bea0: 9405a410     	bl	 <ERR_set_mark@plt>
 107bea4: 910003e2     	mov	x2, sp
 107bea8: 52808140     	mov	w0, #0x40a              // =1034
 107beac: aa1f03e1     	mov	x1, xzr
 107beb0: 52800403     	mov	w3, #0x20               // =32
 107beb4: 9405a447     	bl	 <EVP_PKEY_new_raw_private_key@plt>
 107beb8: b0fffc56     	adrp	x22, 0x1004000 <__anon_17159+0x20>
 107bebc: 910202d6     	add	x22, x22, #0x80
 107bec0: b4000120     	cbz	x0,  <L0>
 107bec4: 910063b7     	add	x23, x29, #0x18
 107bec8: d10023b5     	sub	x21, x29, #0x8
 107becc: 781f83bf     	sturh	wzr, [x29, #-0x8]
 107bed0: f9000fa0     	str	x0, [x29, #0x18]
 107bed4: 9405a417     	bl	 <ERR_pop_to_mark@plt>
 107bed8: 794002b5     	ldrh	w21, [x21]
 107bedc: 340000f5     	cbz	w21,  <L1>
 107bee0: 1400002f     	b	 <L6>
<L0>:
 107bee4: 910022d5     	add	x21, x22, #0x8
 107bee8: aa1603f7     	mov	x23, x22
 107beec: 9405a411     	bl	 <ERR_pop_to_mark@plt>
 107bef0: 794002b5     	ldrh	w21, [x21]
 107bef4: 35000555     	cbnz	w21,  <L6>
<L1>:
 107bef8: ad400680     	ldp	q0, q1, [x20]
 107befc: f94002f4     	ldr	x20, [x23]
 107bf00: ad0007e0     	stp	q0, q1, [sp]
 107bf04: 9405a3f7     	bl	 <ERR_set_mark@plt>
 107bf08: 910003e2     	mov	x2, sp
 107bf0c: 52808140     	mov	w0, #0x40a              // =1034
 107bf10: aa1f03e1     	mov	x1, xzr
 107bf14: 52800403     	mov	w3, #0x20               // =32
 107bf18: 9405a432     	bl	 <EVP_PKEY_new_raw_public_key@plt>
 107bf1c: b4000340     	cbz	x0,  <L4>
 107bf20: 910063b6     	add	x22, x29, #0x18
 107bf24: d10023b5     	sub	x21, x29, #0x8
 107bf28: 781f83bf     	sturh	wzr, [x29, #-0x8]
 107bf2c: f9000fa0     	str	x0, [x29, #0x18]
 107bf30: 9405a400     	bl	 <ERR_pop_to_mark@plt>
 107bf34: 794002b5     	ldrh	w21, [x21]
 107bf38: 350002f5     	cbnz	w21,  <L5>
<L2>:
 107bf3c: f94002d6     	ldr	x22, [x22]
 107bf40: aa1403e0     	mov	x0, x20
 107bf44: aa1303e2     	mov	x2, x19
 107bf48: aa1603e1     	mov	x1, x22
 107bf4c: 94000018     	bl	 <crypto.backend_openssl.sharedSecretDerive>
 107bf50: 12003c15     	and	w21, w0, #0xffff
 107bf54: aa1603e0     	mov	x0, x22
 107bf58: 9405a426     	bl	 <EVP_PKEY_free@plt>
 107bf5c: aa1403e0     	mov	x0, x20
 107bf60: 9405a424     	bl	 <EVP_PKEY_free@plt>
 107bf64: 350001d5     	cbnz	w21,  <L6>
<L3>:
 107bf68: 2a1503e0     	mov	w0, w21
 107bf6c: a9464ff4     	ldp	x20, x19, [sp, #0x60]
 107bf70: f94023f7     	ldr	x23, [sp, #0x40]
 107bf74: a94557f6     	ldp	x22, x21, [sp, #0x50]
 107bf78: a9437bfd     	ldp	x29, x30, [sp, #0x30]
 107bf7c: 9101c3ff     	add	sp, sp, #0x70
 107bf80: d65f03c0     	ret
<L4>:
 107bf84: 910022d5     	add	x21, x22, #0x8
 107bf88: 9405a3ea     	bl	 <ERR_pop_to_mark@plt>
 107bf8c: 794002b5     	ldrh	w21, [x21]
 107bf90: 34fffd75     	cbz	w21,  <L2>
<L5>:
 107bf94: aa1403e0     	mov	x0, x20
 107bf98: 9405a416     	bl	 <EVP_PKEY_free@plt>
<L6>:
 107bf9c: 6f00e400     	movi	v0.2d, #0000000000000000
 107bfa0: 3d800660     	str	q0, [x19, #0x10]
 107bfa4: 3d800260     	str	q0, [x19]
 107bfa8: 17fffff0     	b	 <L3>
