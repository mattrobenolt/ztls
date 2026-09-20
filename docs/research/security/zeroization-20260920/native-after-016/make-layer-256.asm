
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000109bac8 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>:
 109bac8: d107c3ff     	sub	sp, sp, #0x1f0
 109bacc: a91c7bfd     	stp	x29, x30, [sp, #0x1c0]
 109bad0: a91d57fc     	stp	x28, x21, [sp, #0x1d0]
 109bad4: a91e4ff4     	stp	x20, x19, [sp, #0x1e0]
 109bad8: 910703fd     	add	x29, sp, #0x1c0
 109badc: 12003c29     	and	w9, w1, #0xffff
 109bae0: 52826028     	mov	w8, #0x1301             // =4865
 109bae4: aa0203f4     	mov	x20, x2
 109bae8: aa0003f3     	mov	x19, x0
 109baec: 6b08013f     	cmp	w9, w8
 109baf0: 910203f5     	add	x21, sp, #0x80
 109baf4: 910003e8     	mov	x8, sp
 109baf8: 540000e0     	b.eq	 <L0>
 109bafc: 5282604a     	mov	w10, #0x1302            // =4866
 109bb00: 6b0a013f     	cmp	w9, w10
 109bb04: 540002c1     	b.ne	 <L1>
 109bb08: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109bb0c: 91207129     	add	x9, x9, #0x81c
 109bb10: 14000015     	b	 <L2>
<L0>:
 109bb14: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109bb18: 911f6129     	add	x9, x9, #0x7d8
 109bb1c: b27f0100     	orr	x0, x8, #0x2
 109bb20: ad400520     	ldp	q0, q1, [x9]
 109bb24: 52820009     	mov	w9, #0x1000             // =4096
 109bb28: 790163e9     	strh	w9, [sp, #0xb0]
 109bb2c: 52800129     	mov	w9, #0x9                // =9
 109bb30: 9102c3e2     	add	x2, sp, #0xb0
 109bb34: 3902cbe9     	strb	w9, [sp, #0xb2]
 109bb38: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109bb3c: 9120f929     	add	x9, x9, #0x83e
 109bb40: ad0007e0     	stp	q0, q1, [sp]
 109bb44: ad400680     	ldp	q0, q1, [x20]
 109bb48: f9400129     	ldr	x9, [x9]
 109bb4c: 910203e4     	add	x4, sp, #0x80
 109bb50: 52800201     	mov	w1, #0x10               // =16
 109bb54: 790043ff     	strh	wzr, [sp, #0x20]
 109bb58: 14000012     	b	 <L3>
<L1>:
 109bb5c: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109bb60: 911fe929     	add	x9, x9, #0x7fa
<L2>:
 109bb64: ad400520     	ldp	q0, q1, [x9]
 109bb68: 52840009     	mov	w9, #0x2000             // =8192
 109bb6c: 790163e9     	strh	w9, [sp, #0xb0]
 109bb70: 52800129     	mov	w9, #0x9                // =9
 109bb74: b27f0100     	orr	x0, x8, #0x2
 109bb78: 3902cbe9     	strb	w9, [sp, #0xb2]
 109bb7c: 90fffb69     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 109bb80: 9120f929     	add	x9, x9, #0x83e
 109bb84: ad0007e0     	stp	q0, q1, [sp]
 109bb88: ad400680     	ldp	q0, q1, [x20]
 109bb8c: f9400129     	ldr	x9, [x9]
 109bb90: 790043ff     	strh	wzr, [sp, #0x20]
 109bb94: 9102c3e2     	add	x2, sp, #0xb0
 109bb98: 910203e4     	add	x4, sp, #0x80
 109bb9c: 52800401     	mov	w1, #0x20               // =32
<L3>:
 109bba0: f80332a9     	stur	x9, [x21, #0x33]
 109bba4: 52800f29     	mov	w9, #0x79               // =121
 109bba8: ad0407e0     	stp	q0, q1, [sp, #0x80]
 109bbac: 7803b2a9     	sturh	w9, [x21, #0x3b]
 109bbb0: 528001a3     	mov	w3, #0xd                // =13
 109bbb4: 94000045     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 109bbb8: 52818008     	mov	w8, #0xc00              // =3072
 109bbbc: 3cc023e0     	ldur	q0, [sp, #0x2]
 109bbc0: 3cc123e1     	ldur	q1, [sp, #0x12]
 109bbc4: 790163e8     	strh	w8, [sp, #0xb0]
 109bbc8: 52800108     	mov	w8, #0x8                // =8
 109bbcc: 910093e0     	add	x0, sp, #0x24
 109bbd0: 3902cbe8     	strb	w8, [sp, #0xb2]
 109bbd4: d28d8e88     	mov	x8, #0x6c74             // =27764
 109bbd8: 9102c3e2     	add	x2, sp, #0xb0
 109bbdc: 3c8022a0     	stur	q0, [x21, #0x2]
 109bbe0: f2a62e68     	movk	x8, #0x3173, lsl #16
 109bbe4: 910183e4     	add	x4, sp, #0x60
 109bbe8: 3c8122a1     	stur	q1, [x21, #0x12]
 109bbec: ad400680     	ldp	q0, q1, [x20]
 109bbf0: f2c40668     	movk	x8, #0x2033, lsl #32
 109bbf4: 794003f4     	ldrh	w20, [sp]
 109bbf8: 52800181     	mov	w1, #0xc                // =12
 109bbfc: f2eecd28     	movk	x8, #0x7669, lsl #48
 109bc00: 52800183     	mov	w3, #0xc                // =12
 109bc04: 3902efff     	strb	wzr, [sp, #0xbb]
 109bc08: ad0307e0     	stp	q0, q1, [sp, #0x60]
 109bc0c: f80332a8     	stur	x8, [x21, #0x33]
 109bc10: 910203f5     	add	x21, sp, #0x80
 109bc14: 9400002d     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 109bc18: 52826028     	mov	w8, #0x1301             // =4865
 109bc1c: 3cc023e0     	ldur	q0, [sp, #0x2]
 109bc20: 3cc123e1     	ldur	q1, [sp, #0x12]
 109bc24: 52800409     	mov	w9, #0x20               // =32
 109bc28: 5280020a     	mov	w10, #0x10              // =16
 109bc2c: 6b08029f     	cmp	w20, w8
 109bc30: 9a890143     	csel	x3, x10, x9, eq
 109bc34: 9102c3e0     	add	x0, sp, #0xb0
 109bc38: b27f02a2     	orr	x2, x21, #0x2
 109bc3c: 2a1403e1     	mov	w1, w20
 109bc40: ad0187e0     	stp	q0, q1, [sp, #0x30]
 109bc44: 790103f4     	strh	w20, [sp, #0x80]
 109bc48: 97ff801f     	bl	 <crypto.backend_openssl.aeadInit>
 109bc4c: 794183e8     	ldrh	w8, [sp, #0xc0]
 109bc50: 35000068     	cbnz	w8,  <L4>
 109bc54: 3dc02fe0     	ldr	q0, [sp, #0xb0]
 109bc58: 3d8017e0     	str	q0, [sp, #0x50]
<L4>:
 109bc5c: 6f00e400     	movi	v0.2d, #0000000000000000
 109bc60: 52826069     	mov	w9, #0x1303             // =4867
 109bc64: 52a0200a     	mov	w10, #0x1000000         // =16777216
 109bc68: 6b09029f     	cmp	w20, w9
 109bc6c: d2c00209     	mov	x9, #0x1000000000       // =68719476736
 109bc70: 9a8a0129     	csel	x9, x9, x10, eq
 109bc74: 3d8003e0     	str	q0, [sp]
 109bc78: 3d8007e0     	str	q0, [sp, #0x10]
 109bc7c: 790043ff     	strh	wzr, [sp, #0x20]
 109bc80: ad420be0     	ldp	q0, q2, [sp, #0x40]
 109bc84: 3dc00fe1     	ldr	q1, [sp, #0x30]
 109bc88: a900267f     	stp	xzr, x9, [x19]
 109bc8c: f84243e9     	ldur	x9, [sp, #0x24]
 109bc90: b9402fea     	ldr	w10, [sp, #0x2c]
 109bc94: 3c82a261     	stur	q1, [x19, #0x2a]
 109bc98: 3d800662     	str	q2, [x19, #0x10]
 109bc9c: 79004274     	strh	w20, [x19, #0x20]
 109bca0: 79005274     	strh	w20, [x19, #0x28]
 109bca4: 3c83a260     	stur	q0, [x19, #0x3a]
 109bca8: f804a269     	stur	x9, [x19, #0x4a]
 109bcac: b805226a     	stur	w10, [x19, #0x52]
 109bcb0: 7900b268     	strh	w8, [x19, #0x58]
 109bcb4: a95e4ff4     	ldp	x20, x19, [sp, #0x1e0]
 109bcb8: a95d57fc     	ldp	x28, x21, [sp, #0x1d0]
 109bcbc: a95c7bfd     	ldp	x29, x30, [sp, #0x1c0]
 109bcc0: 9107c3ff     	add	sp, sp, #0x1f0
 109bcc4: d65f03c0     	ret
