
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107e968 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>:
 107e968: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 107e96c: f9000bfc     	str	x28, [sp, #0x10]
 107e970: a9025ff8     	stp	x24, x23, [sp, #0x20]
 107e974: a90357f6     	stp	x22, x21, [sp, #0x30]
 107e978: a9044ff4     	stp	x20, x19, [sp, #0x40]
 107e97c: 910003fd     	mov	x29, sp
 107e980: d10783ff     	sub	sp, sp, #0x1e0
 107e984: 12003c28     	and	w8, w1, #0xffff
 107e988: 52826038     	mov	w24, #0x1301            // =4865
 107e98c: aa0203f5     	mov	x21, x2
 107e990: 2a0103f4     	mov	w20, w1
 107e994: aa0003f3     	mov	x19, x0
 107e998: 6b18011f     	cmp	w8, w24
 107e99c: 9101e3f6     	add	x22, sp, #0x78
 107e9a0: 540002e0     	b.eq	 <L0>
 107e9a4: 52826058     	mov	w24, #0x1302            // =4866
 107e9a8: 6b18011f     	cmp	w8, w24
 107e9ac: 540004e1     	b.ne	 <L1>
 107e9b0: 52800129     	mov	w9, #0x9                // =9
 107e9b4: 52840008     	mov	w8, #0x2000             // =8192
 107e9b8: 910123f7     	add	x23, sp, #0x48
 107e9bc: 39034be9     	strb	w9, [sp, #0xd2]
 107e9c0: f0fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 107e9c4: 913b0129     	add	x9, x9, #0xec0
 107e9c8: f9400129     	ldr	x9, [x9]
 107e9cc: 7901a3e8     	strh	w8, [sp, #0xd0]
 107e9d0: 52800f28     	mov	w8, #0x79               // =121
 107e9d4: b27f02e0     	orr	x0, x23, #0x2
 107e9d8: 910343e2     	add	x2, sp, #0xd0
 107e9dc: 52800401     	mov	w1, #0x20               // =32
 107e9e0: 528001a3     	mov	w3, #0xd                // =13
 107e9e4: aa1503e4     	mov	x4, x21
 107e9e8: 780632c8     	sturh	w8, [x22, #0x63]
 107e9ec: f805b2c9     	stur	x9, [x22, #0x5b]
 107e9f0: 940088cc     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107e9f4: 790093f8     	strh	w24, [sp, #0x48]
 107e9f8: 14000027     	b	 <L2>
<L0>:
 107e9fc: 52800129     	mov	w9, #0x9                // =9
 107ea00: 52820008     	mov	w8, #0x1000             // =4096
 107ea04: 910003f7     	mov	x23, sp
 107ea08: 39034be9     	strb	w9, [sp, #0xd2]
 107ea0c: f0fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 107ea10: 913b0129     	add	x9, x9, #0xec0
 107ea14: f9400129     	ldr	x9, [x9]
 107ea18: 7901a3e8     	strh	w8, [sp, #0xd0]
 107ea1c: 52800f28     	mov	w8, #0x79               // =121
 107ea20: b27f02e0     	orr	x0, x23, #0x2
 107ea24: 910343e2     	add	x2, sp, #0xd0
 107ea28: 52800201     	mov	w1, #0x10               // =16
 107ea2c: 528001a3     	mov	w3, #0xd                // =13
 107ea30: aa1503e4     	mov	x4, x21
 107ea34: 780632c8     	sturh	w8, [x22, #0x63]
 107ea38: f805b2c9     	stur	x9, [x22, #0x5b]
 107ea3c: 940088b9     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107ea40: 790003f8     	strh	w24, [sp]
 107ea44: 14000014     	b	 <L2>
<L1>:
 107ea48: 52800129     	mov	w9, #0x9                // =9
 107ea4c: 52840008     	mov	w8, #0x2000             // =8192
 107ea50: 910093f7     	add	x23, sp, #0x24
 107ea54: 39034be9     	strb	w9, [sp, #0xd2]
 107ea58: f0fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 107ea5c: 913b0129     	add	x9, x9, #0xec0
 107ea60: f9400129     	ldr	x9, [x9]
 107ea64: 7901a3e8     	strh	w8, [sp, #0xd0]
 107ea68: 52800f28     	mov	w8, #0x79               // =121
 107ea6c: b27f02e0     	orr	x0, x23, #0x2
 107ea70: 910343e2     	add	x2, sp, #0xd0
 107ea74: 52800401     	mov	w1, #0x20               // =32
 107ea78: 528001a3     	mov	w3, #0xd                // =13
 107ea7c: aa1503e4     	mov	x4, x21
 107ea80: 780632c8     	sturh	w8, [x22, #0x63]
 107ea84: f805b2c9     	stur	x9, [x22, #0x5b]
 107ea88: 940088a6     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107ea8c: 52826068     	mov	w8, #0x1303             // =4867
 107ea90: 79004be8     	strh	w8, [sp, #0x24]
<L2>:
 107ea94: 52818008     	mov	w8, #0xc00              // =3072
 107ea98: 52800109     	mov	w9, #0x8                // =8
 107ea9c: 9101b3e0     	add	x0, sp, #0x6c
 107eaa0: 7901a3e8     	strh	w8, [sp, #0xd0]
 107eaa4: d28d8e88     	mov	x8, #0x6c74             // =27764
 107eaa8: 910343e2     	add	x2, sp, #0xd0
 107eaac: f2a62e68     	movk	x8, #0x3173, lsl #16
 107eab0: 52800181     	mov	w1, #0xc                // =12
 107eab4: 52800183     	mov	w3, #0xc                // =12
 107eab8: f2c40668     	movk	x8, #0x2033, lsl #32
 107eabc: aa1503e4     	mov	x4, x21
 107eac0: 39034be9     	strb	w9, [sp, #0xd2]
 107eac4: f2eecd28     	movk	x8, #0x7669, lsl #48
 107eac8: 39036fff     	strb	wzr, [sp, #0xdb]
 107eacc: 910343f8     	add	x24, sp, #0xd0
 107ead0: f805b2c8     	stur	x8, [x22, #0x5b]
 107ead4: 94008893     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107ead8: ad4006e0     	ldp	q0, q1, [x23]
 107eadc: 9102e3e0     	add	x0, sp, #0xb8
 107eae0: 794042e8     	ldrh	w8, [x23, #0x20]
 107eae4: 794042e9     	ldrh	w9, [x23, #0x20]
 107eae8: b27f0302     	orr	x2, x24, #0x2
 107eaec: 3c87e3e0     	stur	q0, [sp, #0x7e]
 107eaf0: 3c8162c1     	stur	q1, [x22, #0x16]
 107eaf4: ad4006e0     	ldp	q0, q1, [x23]
 107eaf8: 79013fe8     	strh	w8, [sp, #0x9e]
 107eafc: 52826028     	mov	w8, #0x1301             // =4865
 107eb00: 7901e3e9     	strh	w9, [sp, #0xf0]
 107eb04: 52800209     	mov	w9, #0x10               // =16
 107eb08: ad0687e0     	stp	q0, q1, [sp, #0xd0]
 107eb0c: 7941a3f5     	ldrh	w21, [sp, #0xd0]
 107eb10: 6b0802bf     	cmp	w21, w8
 107eb14: 52800408     	mov	w8, #0x20               // =32
 107eb18: 2a1503e1     	mov	w1, w21
 107eb1c: 9a880123     	csel	x3, x9, x8, eq
 107eb20: 940035d5     	bl	 <crypto.backend_openssl.aeadInit>
 107eb24: 794193e8     	ldrh	w8, [sp, #0xc8]
 107eb28: 350003c8     	cbnz	w8,  <L4>
 107eb2c: 3dc012c0     	ldr	q0, [x22, #0x40]
 107eb30: 3d802be0     	str	q0, [sp, #0xa0]
<L3>:
 107eb34: 52826069     	mov	w9, #0x1303             // =4867
 107eb38: d2c0020a     	mov	x10, #0x1000000000      // =68719476736
 107eb3c: 3dc02be0     	ldr	q0, [sp, #0xa0]
 107eb40: 6b34213f     	cmp	w9, w20, uxth
 107eb44: 52a02009     	mov	w9, #0x1000000          // =16777216
 107eb48: 3cc783e1     	ldur	q1, [sp, #0x78]
 107eb4c: 9a890149     	csel	x9, x10, x9, eq
 107eb50: 3d800660     	str	q0, [x19, #0x10]
 107eb54: 3dc006c0     	ldr	q0, [x22, #0x10]
 107eb58: a900267f     	stp	xzr, x9, [x19]
 107eb5c: f9404fe9     	ldr	x9, [sp, #0x98]
 107eb60: f846c3ea     	ldur	x10, [sp, #0x6c]
 107eb64: 3c822261     	stur	q1, [x19, #0x22]
 107eb68: f8042269     	stur	x9, [x19, #0x42]
 107eb6c: b94077e9     	ldr	w9, [sp, #0x74]
 107eb70: 79004275     	strh	w21, [x19, #0x20]
 107eb74: 3c832260     	stur	q0, [x19, #0x32]
 107eb78: f804a26a     	stur	x10, [x19, #0x4a]
 107eb7c: b8052269     	stur	w9, [x19, #0x52]
 107eb80: 7900b268     	strh	w8, [x19, #0x58]
 107eb84: 910783ff     	add	sp, sp, #0x1e0
 107eb88: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 107eb8c: f9400bfc     	ldr	x28, [sp, #0x10]
 107eb90: a94357f6     	ldp	x22, x21, [sp, #0x30]
 107eb94: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 107eb98: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 107eb9c: d65f03c0     	ret
<L4>:
 107eba0: 17ffffe5     	b	 <L3>
