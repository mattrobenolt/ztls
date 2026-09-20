
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107ea30 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>:
 107ea30: d10783ff     	sub	sp, sp, #0x1e0
 107ea34: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
 107ea38: f900dbfc     	str	x28, [sp, #0x1b0]
 107ea3c: a91c57f6     	stp	x22, x21, [sp, #0x1c0]
 107ea40: a91d4ff4     	stp	x20, x19, [sp, #0x1d0]
 107ea44: 910683fd     	add	x29, sp, #0x1a0
 107ea48: 12003c29     	and	w9, w1, #0xffff
 107ea4c: 52826028     	mov	w8, #0x1301             // =4865
 107ea50: aa0203f4     	mov	x20, x2
 107ea54: aa0003f3     	mov	x19, x0
 107ea58: 6b08013f     	cmp	w9, w8
 107ea5c: 910243f6     	add	x22, sp, #0x90
 107ea60: 910003e8     	mov	x8, sp
 107ea64: 540000e0     	b.eq	 <L0>
 107ea68: 5282604a     	mov	w10, #0x1302            // =4866
 107ea6c: 6b0a013f     	cmp	w9, w10
 107ea70: 540002a1     	b.ne	 <L1>
 107ea74: d0fffc49     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 107ea78: 913f3129     	add	x9, x9, #0xfcc
 107ea7c: 14000014     	b	 <L2>
<L0>:
 107ea80: d0fffc49     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 107ea84: 913e2129     	add	x9, x9, #0xf88
 107ea88: f0fffc4a     	adrp	x10, 0x1009000 <__anon_51030+0x980>
 107ea8c: 913d814a     	add	x10, x10, #0xf60
 107ea90: ad400520     	ldp	q0, q1, [x9]
 107ea94: 52820009     	mov	w9, #0x1000             // =4096
 107ea98: f940014a     	ldr	x10, [x10]
 107ea9c: b27f0100     	orr	x0, x8, #0x2
 107eaa0: 790123e9     	strh	w9, [sp, #0x90]
 107eaa4: 52800129     	mov	w9, #0x9                // =9
 107eaa8: 910243e2     	add	x2, sp, #0x90
 107eaac: 39024be9     	strb	w9, [sp, #0x92]
 107eab0: 52800f29     	mov	w9, #0x79               // =121
 107eab4: 52800201     	mov	w1, #0x10               // =16
 107eab8: 790043ff     	strh	wzr, [sp, #0x20]
 107eabc: ad0007e0     	stp	q0, q1, [sp]
 107eac0: 14000011     	b	 <L3>
<L1>:
 107eac4: d0fffc49     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 107eac8: 913ea929     	add	x9, x9, #0xfaa
<L2>:
 107eacc: ad400520     	ldp	q0, q1, [x9]
 107ead0: 52840009     	mov	w9, #0x2000             // =8192
 107ead4: f0fffc4a     	adrp	x10, 0x1009000 <__anon_51030+0x980>
 107ead8: 913d814a     	add	x10, x10, #0xf60
 107eadc: 790123e9     	strh	w9, [sp, #0x90]
 107eae0: 52800129     	mov	w9, #0x9                // =9
 107eae4: f940014a     	ldr	x10, [x10]
 107eae8: 790043ff     	strh	wzr, [sp, #0x20]
 107eaec: 39024be9     	strb	w9, [sp, #0x92]
 107eaf0: 52800f29     	mov	w9, #0x79               // =121
 107eaf4: b27f0100     	orr	x0, x8, #0x2
 107eaf8: ad0007e0     	stp	q0, q1, [sp]
 107eafc: 910243e2     	add	x2, sp, #0x90
 107eb00: 52800401     	mov	w1, #0x20               // =32
<L3>:
 107eb04: f80032ca     	stur	x10, [x22, #0x3]
 107eb08: 7800b2c9     	sturh	w9, [x22, #0xb]
 107eb0c: 528001a3     	mov	w3, #0xd                // =13
 107eb10: aa1403e4     	mov	x4, x20
 107eb14: 94008852     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107eb18: 52818008     	mov	w8, #0xc00              // =3072
 107eb1c: 3cc023e0     	ldur	q0, [sp, #0x2]
 107eb20: 3cc123e1     	ldur	q1, [sp, #0x12]
 107eb24: 790123e8     	strh	w8, [sp, #0x90]
 107eb28: 52800108     	mov	w8, #0x8                // =8
 107eb2c: 794003f5     	ldrh	w21, [sp]
 107eb30: 39024be8     	strb	w8, [sp, #0x92]
 107eb34: d28d8e88     	mov	x8, #0x6c74             // =27764
 107eb38: 910093e0     	add	x0, sp, #0x24
 107eb3c: f2a62e68     	movk	x8, #0x3173, lsl #16
 107eb40: 910243e2     	add	x2, sp, #0x90
 107eb44: 52800181     	mov	w1, #0xc                // =12
 107eb48: f2c40668     	movk	x8, #0x2033, lsl #32
 107eb4c: 52800183     	mov	w3, #0xc                // =12
 107eb50: aa1403e4     	mov	x4, x20
 107eb54: f2eecd28     	movk	x8, #0x7669, lsl #48
 107eb58: 3c86e3e0     	stur	q0, [sp, #0x6e]
 107eb5c: 3c87e3e1     	stur	q1, [sp, #0x7e]
 107eb60: f80032c8     	stur	x8, [x22, #0x3]
 107eb64: 9101b3f6     	add	x22, sp, #0x6c
 107eb68: 39026fff     	strb	wzr, [sp, #0x9b]
 107eb6c: 9400883c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 107eb70: 52826028     	mov	w8, #0x1301             // =4865
 107eb74: 3cc023e0     	ldur	q0, [sp, #0x2]
 107eb78: 3cc123e1     	ldur	q1, [sp, #0x12]
 107eb7c: 52800409     	mov	w9, #0x20               // =32
 107eb80: 5280020a     	mov	w10, #0x10              // =16
 107eb84: 6b0802bf     	cmp	w21, w8
 107eb88: 9a890143     	csel	x3, x10, x9, eq
 107eb8c: 910243e0     	add	x0, sp, #0x90
 107eb90: b27f02c2     	orr	x2, x22, #0x2
 107eb94: 2a1503e1     	mov	w1, w21
 107eb98: ad0187e0     	stp	q0, q1, [sp, #0x30]
 107eb9c: 7900dbf5     	strh	w21, [sp, #0x6c]
 107eba0: 94003584     	bl	 <crypto.backend_openssl.aeadInit>
 107eba4: 794143e8     	ldrh	w8, [sp, #0xa0]
 107eba8: 35000068     	cbnz	w8,  <L4>
 107ebac: 3dc027e0     	ldr	q0, [sp, #0x90]
 107ebb0: 3d8017e0     	str	q0, [sp, #0x50]
<L4>:
 107ebb4: 6f00e400     	movi	v0.2d, #0000000000000000
 107ebb8: 52826069     	mov	w9, #0x1303             // =4867
 107ebbc: 52a0200a     	mov	w10, #0x1000000         // =16777216
 107ebc0: 6b0902bf     	cmp	w21, w9
 107ebc4: d2c00209     	mov	x9, #0x1000000000       // =68719476736
 107ebc8: 9a8a0129     	csel	x9, x9, x10, eq
 107ebcc: 3d8003e0     	str	q0, [sp]
 107ebd0: 3d8007e0     	str	q0, [sp, #0x10]
 107ebd4: 790043ff     	strh	wzr, [sp, #0x20]
 107ebd8: ad420be0     	ldp	q0, q2, [sp, #0x40]
 107ebdc: 3dc00fe1     	ldr	q1, [sp, #0x30]
 107ebe0: a900267f     	stp	xzr, x9, [x19]
 107ebe4: f84243e9     	ldur	x9, [sp, #0x24]
 107ebe8: b9402fea     	ldr	w10, [sp, #0x2c]
 107ebec: 3c82a261     	stur	q1, [x19, #0x2a]
 107ebf0: 3d800662     	str	q2, [x19, #0x10]
 107ebf4: 79004275     	strh	w21, [x19, #0x20]
 107ebf8: 79005275     	strh	w21, [x19, #0x28]
 107ebfc: 3c83a260     	stur	q0, [x19, #0x3a]
 107ec00: f804a269     	stur	x9, [x19, #0x4a]
 107ec04: b805226a     	stur	w10, [x19, #0x52]
 107ec08: 7900b268     	strh	w8, [x19, #0x58]
 107ec0c: a95d4ff4     	ldp	x20, x19, [sp, #0x1d0]
 107ec10: f940dbfc     	ldr	x28, [sp, #0x1b0]
 107ec14: a95c57f6     	ldp	x22, x21, [sp, #0x1c0]
 107ec18: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
 107ec1c: 910783ff     	add	sp, sp, #0x1e0
 107ec20: d65f03c0     	ret
