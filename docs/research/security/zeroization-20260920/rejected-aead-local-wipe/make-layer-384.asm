
zig-out/memory.N4aX4N/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107e9f0 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>:
 107e9f0: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 107e9f4: f9000bfc     	str	x28, [sp, #0x10]
 107e9f8: a9025ff8     	stp	x24, x23, [sp, #0x20]
 107e9fc: a90357f6     	stp	x22, x21, [sp, #0x30]
 107ea00: a9044ff4     	stp	x20, x19, [sp, #0x40]
 107ea04: 910003fd     	mov	x29, sp
 107ea08: d10843ff     	sub	sp, sp, #0x210
 107ea0c: 12003c28     	and	w8, w1, #0xffff
 107ea10: 52826029     	mov	w9, #0x1301             // =4865
 107ea14: aa0203f5     	mov	x21, x2
 107ea18: 2a0103f4     	mov	w20, w1
 107ea1c: aa0003f3     	mov	x19, x0
 107ea20: 6b09011f     	cmp	w8, w9
 107ea24: 910253f7     	add	x23, sp, #0x94
 107ea28: 54000100     	b.eq	0x107ea48 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer+0x58>
 107ea2c: 52826049     	mov	w9, #0x1302             // =4866
 107ea30: 6b09011f     	cmp	w8, w9
 107ea34: 540002a1     	b.ne	0x107ea88 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer+0x98>
 107ea38: 52800129     	mov	w9, #0x9                // =9
 107ea3c: 52840008     	mov	w8, #0x2000             // =8192
 107ea40: 9101cbea     	add	x10, sp, #0x72
 107ea44: 14000014     	b	0x107ea94 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer+0xa4>
 107ea48: 52800129     	mov	w9, #0x9                // =9
 107ea4c: 9100bbea     	add	x10, sp, #0x2e
 107ea50: 52820008     	mov	w8, #0x1000             // =4096
 107ea54: 39040be9     	strb	w9, [sp, #0x102]
 107ea58: f0fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 107ea5c: 913c0129     	add	x9, x9, #0xf00
 107ea60: f9400129     	ldr	x9, [x9]
 107ea64: 91000956     	add	x22, x10, #0x2
 107ea68: 790203e8     	strh	w8, [sp, #0x100]
 107ea6c: 52800f28     	mov	w8, #0x79               // =121
 107ea70: 910403e2     	add	x2, sp, #0x100
 107ea74: aa1603e0     	mov	x0, x22
 107ea78: 52800201     	mov	w1, #0x10               // =16
 107ea7c: 780772e8     	sturh	w8, [x23, #0x77]
 107ea80: f806f2e9     	stur	x9, [x23, #0x6f]
 107ea84: 14000010     	b	0x107eac4 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer+0xd4>
 107ea88: 52800129     	mov	w9, #0x9                // =9
 107ea8c: 52840008     	mov	w8, #0x2000             // =8192
 107ea90: 910143ea     	add	x10, sp, #0x50
 107ea94: 39040be9     	strb	w9, [sp, #0x102]
 107ea98: f0fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 107ea9c: 913c0129     	add	x9, x9, #0xf00
 107eaa0: f9400129     	ldr	x9, [x9]
 107eaa4: 790203e8     	strh	w8, [sp, #0x100]
 107eaa8: 52800f28     	mov	w8, #0x79               // =121
 107eaac: 91000956     	add	x22, x10, #0x2
 107eab0: 780772e8     	sturh	w8, [x23, #0x77]
 107eab4: 910403e2     	add	x2, sp, #0x100
 107eab8: f806f2e9     	stur	x9, [x23, #0x6f]
 107eabc: aa1603e0     	mov	x0, x22
 107eac0: 52800401     	mov	w1, #0x20               // =32
 107eac4: 528001a3     	mov	w3, #0xd                // =13
 107eac8: aa1503e4     	mov	x4, x21
 107eacc: 9400884c     	bl	0x10a0bfc <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107ead0: 52818008     	mov	w8, #0xc00              // =3072
 107ead4: ad4006c0     	ldp	q0, q1, [x22]
 107ead8: 790203e8     	strh	w8, [sp, #0x100]
 107eadc: 52800108     	mov	w8, #0x8                // =8
 107eae0: 910253e0     	add	x0, sp, #0x94
 107eae4: 39040be8     	strb	w8, [sp, #0x102]
 107eae8: d28d8e88     	mov	x8, #0x6c74             // =27764
 107eaec: 910403e2     	add	x2, sp, #0x100
 107eaf0: f2a62e68     	movk	x8, #0x3173, lsl #16
 107eaf4: 52800181     	mov	w1, #0xc                // =12
 107eaf8: 52800183     	mov	w3, #0xc                // =12
 107eafc: f2c40668     	movk	x8, #0x2033, lsl #32
 107eb00: aa1503e4     	mov	x4, x21
 107eb04: 3c84a2e0     	stur	q0, [x23, #0x4a]
 107eb08: f2eecd28     	movk	x8, #0x7669, lsl #48
 107eb0c: 3c85a2e1     	stur	q1, [x23, #0x5a]
 107eb10: 910373f8     	add	x24, sp, #0xdc
 107eb14: f806f2e8     	stur	x8, [x23, #0x6f]
 107eb18: 39042fff     	strb	wzr, [sp, #0x10b]
 107eb1c: 94008838     	bl	0x10a0bfc <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107eb20: ad4006c0     	ldp	q0, q1, [x22]
 107eb24: 52826028     	mov	w8, #0x1301             // =4865
 107eb28: 52800409     	mov	w9, #0x20               // =32
 107eb2c: 5280020a     	mov	w10, #0x10              // =16
 107eb30: 6b34211f     	cmp	w8, w20, uxth
 107eb34: 9a890143     	csel	x3, x10, x9, eq
 107eb38: 910403e0     	add	x0, sp, #0x100
 107eb3c: b27f0302     	orr	x2, x24, #0x2
 107eb40: 2a1403e1     	mov	w1, w20
 107eb44: ad0507e0     	stp	q0, q1, [sp, #0xa0]
 107eb48: 7901bbf4     	strh	w20, [sp, #0xdc]
 107eb4c: 94003581     	bl	0x108c150 <crypto.backend_openssl.aeadInit>
 107eb50: 794223e8     	ldrh	w8, [sp, #0x110]
 107eb54: 35000068     	cbnz	w8, 0x107eb60 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer+0x170>
 107eb58: 3dc043e0     	ldr	q0, [sp, #0x100]
 107eb5c: 3d8033e0     	str	q0, [sp, #0xc0]
 107eb60: 6f00e400     	movi	v0.2d, #0000000000000000
 107eb64: 52826069     	mov	w9, #0x1303             // =4867
 107eb68: 79005bff     	strh	wzr, [sp, #0x2c]
 107eb6c: 52a0200a     	mov	w10, #0x1000000         // =16777216
 107eb70: 6b34213f     	cmp	w9, w20, uxth
 107eb74: d2c00209     	mov	x9, #0x1000000000       // =68719476736
 107eb78: 9a8a0129     	csel	x9, x9, x10, eq
 107eb7c: 3d8003e0     	str	q0, [sp]
 107eb80: 3d8007e0     	str	q0, [sp, #0x10]
 107eb84: ad458be0     	ldp	q0, q2, [sp, #0xb0]
 107eb88: 3dc02be1     	ldr	q1, [sp, #0xa0]
 107eb8c: a900267f     	stp	xzr, x9, [x19]
 107eb90: f94002e9     	ldr	x9, [x23]
 107eb94: b9409fea     	ldr	w10, [sp, #0x9c]
 107eb98: 3c82a261     	stur	q1, [x19, #0x2a]
 107eb9c: 3d800662     	str	q2, [x19, #0x10]
 107eba0: 79004274     	strh	w20, [x19, #0x20]
 107eba4: 79005274     	strh	w20, [x19, #0x28]
 107eba8: 3c83a260     	stur	q0, [x19, #0x3a]
 107ebac: f804a269     	stur	x9, [x19, #0x4a]
 107ebb0: b805226a     	stur	w10, [x19, #0x52]
 107ebb4: 7900b268     	strh	w8, [x19, #0x58]
 107ebb8: 910843ff     	add	sp, sp, #0x210
 107ebbc: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 107ebc0: f9400bfc     	ldr	x28, [sp, #0x10]
 107ebc4: a94357f6     	ldp	x22, x21, [sp, #0x30]
 107ebc8: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 107ebcc: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 107ebd0: d65f03c0     	ret
