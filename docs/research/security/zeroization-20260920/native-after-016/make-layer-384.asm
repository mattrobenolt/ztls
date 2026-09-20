
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000109b8b8 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>:
 109b8b8: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
 109b8bc: a90157fc     	stp	x28, x21, [sp, #0x10]
 109b8c0: a9024ff4     	stp	x20, x19, [sp, #0x20]
 109b8c4: 910003fd     	mov	x29, sp
 109b8c8: d10743ff     	sub	sp, sp, #0x1d0
 109b8cc: 12003c29     	and	w9, w1, #0xffff
 109b8d0: 52826028     	mov	w8, #0x1301             // =4865
 109b8d4: aa0203f4     	mov	x20, x2
 109b8d8: aa0003f3     	mov	x19, x0
 109b8dc: 6b08013f     	cmp	w9, w8
 109b8e0: 910243f5     	add	x21, sp, #0x90
 109b8e4: 910003e8     	mov	x8, sp
 109b8e8: 540000e0     	b.eq	 <L0>
 109b8ec: 5282604a     	mov	w10, #0x1302            // =4866
 109b8f0: 6b0a013f     	cmp	w9, w10
 109b8f4: 540002c1     	b.ne	 <L1>
 109b8f8: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109b8fc: 91207129     	add	x9, x9, #0x81c
 109b900: 14000015     	b	 <L2>
<L0>:
 109b904: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109b908: 911f6129     	add	x9, x9, #0x7d8
 109b90c: b27f0100     	orr	x0, x8, #0x2
 109b910: ad400520     	ldp	q0, q1, [x9]
 109b914: 52820009     	mov	w9, #0x1000             // =4096
 109b918: 790123e9     	strh	w9, [sp, #0x90]
 109b91c: 52800129     	mov	w9, #0x9                // =9
 109b920: 910243e2     	add	x2, sp, #0x90
 109b924: 39024be9     	strb	w9, [sp, #0x92]
 109b928: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109b92c: 9120f929     	add	x9, x9, #0x83e
 109b930: ad0007e0     	stp	q0, q1, [sp]
 109b934: ad400282     	ldp	q2, q0, [x20]
 109b938: f9400129     	ldr	x9, [x9]
 109b93c: d100c3a4     	sub	x4, x29, #0x30
 109b940: 52800201     	mov	w1, #0x10               // =16
 109b944: 790043ff     	strh	wzr, [sp, #0x20]
 109b948: 14000012     	b	 <L3>
<L1>:
 109b94c: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109b950: 911fe929     	add	x9, x9, #0x7fa
<L2>:
 109b954: ad400520     	ldp	q0, q1, [x9]
 109b958: 52840009     	mov	w9, #0x2000             // =8192
 109b95c: 790123e9     	strh	w9, [sp, #0x90]
 109b960: 52800129     	mov	w9, #0x9                // =9
 109b964: b27f0100     	orr	x0, x8, #0x2
 109b968: 39024be9     	strb	w9, [sp, #0x92]
 109b96c: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109b970: 9120f929     	add	x9, x9, #0x83e
 109b974: ad0007e0     	stp	q0, q1, [sp]
 109b978: ad400282     	ldp	q2, q0, [x20]
 109b97c: f9400129     	ldr	x9, [x9]
 109b980: 790043ff     	strh	wzr, [sp, #0x20]
 109b984: 910243e2     	add	x2, sp, #0x90
 109b988: d100c3a4     	sub	x4, x29, #0x30
 109b98c: 52800401     	mov	w1, #0x20               // =32
<L3>:
 109b990: ad3e83a2     	stp	q2, q0, [x29, #-0x30]
 109b994: 3dc00a80     	ldr	q0, [x20, #0x20]
 109b998: f80032a9     	stur	x9, [x21, #0x3]
 109b99c: 52800f29     	mov	w9, #0x79               // =121
 109b9a0: 3c9f03a0     	stur	q0, [x29, #-0x10]
 109b9a4: 7800b2a9     	sturh	w9, [x21, #0xb]
 109b9a8: 528001a3     	mov	w3, #0xd                // =13
 109b9ac: 940008d2     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 109b9b0: 52818008     	mov	w8, #0xc00              // =3072
 109b9b4: 3cc023e0     	ldur	q0, [sp, #0x2]
 109b9b8: 3cc123e1     	ldur	q1, [sp, #0x12]
 109b9bc: 790123e8     	strh	w8, [sp, #0x90]
 109b9c0: 52800108     	mov	w8, #0x8                // =8
 109b9c4: 910093e0     	add	x0, sp, #0x24
 109b9c8: 39024be8     	strb	w8, [sp, #0x92]
 109b9cc: d28d8e88     	mov	x8, #0x6c74             // =27764
 109b9d0: 910243e2     	add	x2, sp, #0x90
 109b9d4: 3c86e3e0     	stur	q0, [sp, #0x6e]
 109b9d8: ad400a80     	ldp	q0, q2, [x20]
 109b9dc: f2a62e68     	movk	x8, #0x3173, lsl #16
 109b9e0: 3c87e3e1     	stur	q1, [sp, #0x7e]
 109b9e4: 3dc00a81     	ldr	q1, [x20, #0x20]
 109b9e8: f2c40668     	movk	x8, #0x2033, lsl #32
 109b9ec: 794003f4     	ldrh	w20, [sp]
 109b9f0: d100c3a4     	sub	x4, x29, #0x30
 109b9f4: f2eecd28     	movk	x8, #0x7669, lsl #48
 109b9f8: 52800181     	mov	w1, #0xc                // =12
 109b9fc: 52800183     	mov	w3, #0xc                // =12
 109ba00: ad3e8ba0     	stp	q0, q2, [x29, #-0x30]
 109ba04: 3c9f03a1     	stur	q1, [x29, #-0x10]
 109ba08: f80032a8     	stur	x8, [x21, #0x3]
 109ba0c: 9101b3f5     	add	x21, sp, #0x6c
 109ba10: 39026fff     	strb	wzr, [sp, #0x9b]
 109ba14: 940008b8     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 109ba18: 52826028     	mov	w8, #0x1301             // =4865
 109ba1c: 3cc023e0     	ldur	q0, [sp, #0x2]
 109ba20: 3cc123e1     	ldur	q1, [sp, #0x12]
 109ba24: 52800409     	mov	w9, #0x20               // =32
 109ba28: 5280020a     	mov	w10, #0x10              // =16
 109ba2c: 6b08029f     	cmp	w20, w8
 109ba30: 9a890143     	csel	x3, x10, x9, eq
 109ba34: 910243e0     	add	x0, sp, #0x90
 109ba38: b27f02a2     	orr	x2, x21, #0x2
 109ba3c: 2a1403e1     	mov	w1, w20
 109ba40: ad0187e0     	stp	q0, q1, [sp, #0x30]
 109ba44: 7900dbf4     	strh	w20, [sp, #0x6c]
 109ba48: 97ff809f     	bl	 <crypto.backend_openssl.aeadInit>
 109ba4c: 794143e8     	ldrh	w8, [sp, #0xa0]
 109ba50: 35000068     	cbnz	w8,  <L4>
 109ba54: 3dc027e0     	ldr	q0, [sp, #0x90]
 109ba58: 3d8017e0     	str	q0, [sp, #0x50]
<L4>:
 109ba5c: 6f00e400     	movi	v0.2d, #0000000000000000
 109ba60: 52826069     	mov	w9, #0x1303             // =4867
 109ba64: 52a0200a     	mov	w10, #0x1000000         // =16777216
 109ba68: 6b09029f     	cmp	w20, w9
 109ba6c: d2c00209     	mov	x9, #0x1000000000       // =68719476736
 109ba70: 9a8a0129     	csel	x9, x9, x10, eq
 109ba74: 3d8003e0     	str	q0, [sp]
 109ba78: 3d8007e0     	str	q0, [sp, #0x10]
 109ba7c: 790043ff     	strh	wzr, [sp, #0x20]
 109ba80: ad420be0     	ldp	q0, q2, [sp, #0x40]
 109ba84: 3dc00fe1     	ldr	q1, [sp, #0x30]
 109ba88: a900267f     	stp	xzr, x9, [x19]
 109ba8c: f84243e9     	ldur	x9, [sp, #0x24]
 109ba90: b9402fea     	ldr	w10, [sp, #0x2c]
 109ba94: 3c82a261     	stur	q1, [x19, #0x2a]
 109ba98: 3d800662     	str	q2, [x19, #0x10]
 109ba9c: 79004274     	strh	w20, [x19, #0x20]
 109baa0: 79005274     	strh	w20, [x19, #0x28]
 109baa4: 3c83a260     	stur	q0, [x19, #0x3a]
 109baa8: f804a269     	stur	x9, [x19, #0x4a]
 109baac: b805226a     	stur	w10, [x19, #0x52]
 109bab0: 7900b268     	strh	w8, [x19, #0x58]
 109bab4: 910743ff     	add	sp, sp, #0x1d0
 109bab8: a9424ff4     	ldp	x20, x19, [sp, #0x20]
 109babc: a94157fc     	ldp	x28, x21, [sp, #0x10]
 109bac0: a8c37bfd     	ldp	x29, x30, [sp], #0x30
 109bac4: d65f03c0     	ret
