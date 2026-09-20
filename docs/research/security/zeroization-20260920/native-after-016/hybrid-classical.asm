
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010a6b34 <hybrid_kex.deriveClassicalSecret>:
 10a6b34: d105c3ff     	sub	sp, sp, #0x170
 10a6b38: a9157bfd     	stp	x29, x30, [sp, #0x150]
 10a6b3c: a9164ffc     	stp	x28, x19, [sp, #0x160]
 10a6b40: 910543fd     	add	x29, sp, #0x150
 10a6b44: 12003c28     	and	w8, w1, #0xffff
 10a6b48: 71005d1f     	cmp	w8, #0x17
 10a6b4c: 540004c0     	b.eq	 <L0>
 10a6b50: 7100611f     	cmp	w8, #0x18
 10a6b54: 540006e1     	b.ne	 <L1>
 10a6b58: f101849f     	cmp	x4, #0x61
 10a6b5c: 54000941     	b.ne	 <L3>
 10a6b60: 39400068     	ldrb	w8, [x3]
 10a6b64: 7100111f     	cmp	w8, #0x4
 10a6b68: 540008e1     	b.ne	 <L3>
 10a6b6c: 3944c848     	ldrb	w8, [x2, #0x132]
 10a6b70: 340009a8     	cbz	w8,  <L4>
 10a6b74: ad420460     	ldp	q0, q1, [x3, #0x40]
 10a6b78: aa0003f3     	mov	x19, x0
 10a6b7c: 39418068     	ldrb	w8, [x3, #0x60]
 10a6b80: d100c3a0     	sub	x0, x29, #0x30
 10a6b84: d10283a1     	sub	x1, x29, #0xa0
 10a6b88: ad3d07a0     	stp	q0, q1, [x29, #-0x60]
 10a6b8c: ad400460     	ldp	q0, q1, [x3]
 10a6b90: 381c03a8     	sturb	w8, [x29, #-0x40]
 10a6b94: ad3b07a0     	stp	q0, q1, [x29, #-0xa0]
 10a6b98: ad410860     	ldp	q0, q2, [x3, #0x20]
 10a6b9c: 3ccc1041     	ldur	q1, [x2, #0xc1]
 10a6ba0: ad3c0ba0     	stp	q0, q2, [x29, #-0x80]
 10a6ba4: 3ccb1040     	ldur	q0, [x2, #0xb1]
 10a6ba8: 3cca1042     	ldur	q2, [x2, #0xa1]
 10a6bac: aa0503e2     	mov	x2, x5
 10a6bb0: ad3f07a0     	stp	q0, q1, [x29, #-0x20]
 10a6bb4: 3c9d03a2     	stur	q2, [x29, #-0x30]
 10a6bb8: 97fff8d2     	bl	 <p384.sharedSecret>
 10a6bbc: 72003c1f     	tst	w0, #0xffff
 10a6bc0: 54000821     	b.ne	 <L5>
 10a6bc4: d0fffae8     	adrp	x8, 0x1004000 <__anon_17159+0x20>
 10a6bc8: 91158108     	add	x8, x8, #0x560
 10a6bcc: 3dc00100     	ldr	q0, [x8]
 10a6bd0: 3d800260     	str	q0, [x19]
 10a6bd4: a9564ffc     	ldp	x28, x19, [sp, #0x160]
 10a6bd8: a9557bfd     	ldp	x29, x30, [sp, #0x150]
 10a6bdc: 9105c3ff     	add	sp, sp, #0x170
 10a6be0: d65f03c0     	ret
<L0>:
 10a6be4: f101049f     	cmp	x4, #0x41
 10a6be8: 540004e1     	b.ne	 <L3>
 10a6bec: 39400068     	ldrb	w8, [x3]
 10a6bf0: 7100111f     	cmp	w8, #0x4
 10a6bf4: 54000481     	b.ne	 <L3>
 10a6bf8: ad410460     	ldp	q0, q1, [x3, #0x20]
 10a6bfc: aa0003f3     	mov	x19, x0
 10a6c00: 39410068     	ldrb	w8, [x3, #0x40]
 10a6c04: 910243e0     	add	x0, sp, #0x90
 10a6c08: 910103e1     	add	x1, sp, #0x40
 10a6c0c: ad0307e0     	stp	q0, q1, [sp, #0x60]
 10a6c10: ad400061     	ldp	q1, q0, [x3]
 10a6c14: 390203e8     	strb	w8, [sp, #0x80]
 10a6c18: ad0203e1     	stp	q1, q0, [sp, #0x40]
 10a6c1c: ad420042     	ldp	q2, q0, [x2, #0x40]
 10a6c20: aa0503e2     	mov	x2, x5
 10a6c24: ad0483e2     	stp	q2, q0, [sp, #0x90]
 10a6c28: 97fff8f1     	bl	 <p256.sharedSecret>
 10a6c2c: 1400000c     	b	 <L2>
<L1>:
 10a6c30: f100809f     	cmp	x4, #0x20
 10a6c34: 54000281     	b.ne	 <L3>
 10a6c38: ad400460     	ldp	q0, q1, [x3]
 10a6c3c: aa0003f3     	mov	x19, x0
 10a6c40: 910083e0     	add	x0, sp, #0x20
 10a6c44: 910003e1     	mov	x1, sp
 10a6c48: ad0007e0     	stp	q0, q1, [sp]
 10a6c4c: ad400840     	ldp	q0, q2, [x2]
 10a6c50: aa0503e2     	mov	x2, x5
 10a6c54: ad010be0     	stp	q0, q2, [sp, #0x20]
 10a6c58: 97ff5488     	bl	 <x25519.sharedSecret>
<L2>:
 10a6c5c: 72003c1f     	tst	w0, #0xffff
 10a6c60: 54000321     	b.ne	 <L5>
 10a6c64: d0fffae8     	adrp	x8, 0x1004000 <__anon_17159+0x20>
 10a6c68: 910a0108     	add	x8, x8, #0x280
 10a6c6c: 3dc00100     	ldr	q0, [x8]
 10a6c70: 3d800260     	str	q0, [x19]
 10a6c74: a9564ffc     	ldp	x28, x19, [sp, #0x160]
 10a6c78: a9557bfd     	ldp	x29, x30, [sp, #0x150]
 10a6c7c: 9105c3ff     	add	sp, sp, #0x170
 10a6c80: d65f03c0     	ret
<L3>:
 10a6c84: d0fffae8     	adrp	x8, 0x1004000 <__anon_17159+0x20>
 10a6c88: 9105c108     	add	x8, x8, #0x170
 10a6c8c: 3dc00100     	ldr	q0, [x8]
 10a6c90: 3d800000     	str	q0, [x0]
 10a6c94: a9564ffc     	ldp	x28, x19, [sp, #0x160]
 10a6c98: a9557bfd     	ldp	x29, x30, [sp, #0x150]
 10a6c9c: 9105c3ff     	add	sp, sp, #0x170
 10a6ca0: d65f03c0     	ret
<L4>:
 10a6ca4: b0fffae8     	adrp	x8, 0x1003000 <writev+0x1003000>
 10a6ca8: 913a0108     	add	x8, x8, #0xe80
 10a6cac: 3dc00100     	ldr	q0, [x8]
 10a6cb0: 3d800000     	str	q0, [x0]
 10a6cb4: a9564ffc     	ldp	x28, x19, [sp, #0x160]
 10a6cb8: a9557bfd     	ldp	x29, x30, [sp, #0x150]
 10a6cbc: 9105c3ff     	add	sp, sp, #0x170
 10a6cc0: d65f03c0     	ret
<L5>:
 10a6cc4: 79001260     	strh	w0, [x19, #0x8]
 10a6cc8: a9564ffc     	ldp	x28, x19, [sp, #0x160]
 10a6ccc: a9557bfd     	ldp	x29, x30, [sp, #0x150]
 10a6cd0: 9105c3ff     	add	sp, sp, #0x170
 10a6cd4: d65f03c0     	ret
