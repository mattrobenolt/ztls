
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107ec24 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>:
 107ec24: d10783ff     	sub	sp, sp, #0x1e0
 107ec28: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
 107ec2c: f900dbfc     	str	x28, [sp, #0x1b0]
 107ec30: a91c57f6     	stp	x22, x21, [sp, #0x1c0]
 107ec34: a91d4ff4     	stp	x20, x19, [sp, #0x1d0]
 107ec38: 910683fd     	add	x29, sp, #0x1a0
 107ec3c: 12003c29     	and	w9, w1, #0xffff
 107ec40: 52826028     	mov	w8, #0x1301             // =4865
 107ec44: aa0203f4     	mov	x20, x2
 107ec48: aa0003f3     	mov	x19, x0
 107ec4c: 6b08013f     	cmp	w9, w8
 107ec50: 910243f6     	add	x22, sp, #0x90
 107ec54: 910003e8     	mov	x8, sp
 107ec58: 540000e0     	b.eq	 <L0>
 107ec5c: 5282604a     	mov	w10, #0x1302            // =4866
 107ec60: 6b0a013f     	cmp	w9, w10
 107ec64: 540002a1     	b.ne	 <L1>
 107ec68: d0fffc49     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 107ec6c: 913f3129     	add	x9, x9, #0xfcc
 107ec70: 14000014     	b	 <L2>
<L0>:
 107ec74: d0fffc49     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 107ec78: 913e2129     	add	x9, x9, #0xf88
 107ec7c: f0fffc4a     	adrp	x10, 0x1009000 <__anon_51030+0x980>
 107ec80: 913d814a     	add	x10, x10, #0xf60
 107ec84: ad400520     	ldp	q0, q1, [x9]
 107ec88: 52820009     	mov	w9, #0x1000             // =4096
 107ec8c: f940014a     	ldr	x10, [x10]
 107ec90: b27f0100     	orr	x0, x8, #0x2
 107ec94: 790123e9     	strh	w9, [sp, #0x90]
 107ec98: 52800129     	mov	w9, #0x9                // =9
 107ec9c: 910243e2     	add	x2, sp, #0x90
 107eca0: 39024be9     	strb	w9, [sp, #0x92]
 107eca4: 52800f29     	mov	w9, #0x79               // =121
 107eca8: 52800201     	mov	w1, #0x10               // =16
 107ecac: 790043ff     	strh	wzr, [sp, #0x20]
 107ecb0: ad0007e0     	stp	q0, q1, [sp]
 107ecb4: 14000011     	b	 <L3>
<L1>:
 107ecb8: d0fffc49     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 107ecbc: 913ea929     	add	x9, x9, #0xfaa
<L2>:
 107ecc0: ad400520     	ldp	q0, q1, [x9]
 107ecc4: 52840009     	mov	w9, #0x2000             // =8192
 107ecc8: f0fffc4a     	adrp	x10, 0x1009000 <__anon_51030+0x980>
 107eccc: 913d814a     	add	x10, x10, #0xf60
 107ecd0: 790123e9     	strh	w9, [sp, #0x90]
 107ecd4: 52800129     	mov	w9, #0x9                // =9
 107ecd8: f940014a     	ldr	x10, [x10]
 107ecdc: 790043ff     	strh	wzr, [sp, #0x20]
 107ece0: 39024be9     	strb	w9, [sp, #0x92]
 107ece4: 52800f29     	mov	w9, #0x79               // =121
 107ece8: b27f0100     	orr	x0, x8, #0x2
 107ecec: ad0007e0     	stp	q0, q1, [sp]
 107ecf0: 910243e2     	add	x2, sp, #0x90
 107ecf4: 52800401     	mov	w1, #0x20               // =32
<L3>:
 107ecf8: f80032ca     	stur	x10, [x22, #0x3]
 107ecfc: 7800b2c9     	sturh	w9, [x22, #0xb]
 107ed00: 528001a3     	mov	w3, #0xd                // =13
 107ed04: aa1403e4     	mov	x4, x20
 107ed08: 94008ab8     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ed0c: 52818008     	mov	w8, #0xc00              // =3072
 107ed10: 3cc023e0     	ldur	q0, [sp, #0x2]
 107ed14: 3cc123e1     	ldur	q1, [sp, #0x12]
 107ed18: 790123e8     	strh	w8, [sp, #0x90]
 107ed1c: 52800108     	mov	w8, #0x8                // =8
 107ed20: 794003f5     	ldrh	w21, [sp]
 107ed24: 39024be8     	strb	w8, [sp, #0x92]
 107ed28: d28d8e88     	mov	x8, #0x6c74             // =27764
 107ed2c: 910093e0     	add	x0, sp, #0x24
 107ed30: f2a62e68     	movk	x8, #0x3173, lsl #16
 107ed34: 910243e2     	add	x2, sp, #0x90
 107ed38: 52800181     	mov	w1, #0xc                // =12
 107ed3c: f2c40668     	movk	x8, #0x2033, lsl #32
 107ed40: 52800183     	mov	w3, #0xc                // =12
 107ed44: aa1403e4     	mov	x4, x20
 107ed48: f2eecd28     	movk	x8, #0x7669, lsl #48
 107ed4c: 3c86e3e0     	stur	q0, [sp, #0x6e]
 107ed50: 3c87e3e1     	stur	q1, [sp, #0x7e]
 107ed54: f80032c8     	stur	x8, [x22, #0x3]
 107ed58: 9101b3f6     	add	x22, sp, #0x6c
 107ed5c: 39026fff     	strb	wzr, [sp, #0x9b]
 107ed60: 94008aa2     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ed64: 52826028     	mov	w8, #0x1301             // =4865
 107ed68: 3cc023e0     	ldur	q0, [sp, #0x2]
 107ed6c: 3cc123e1     	ldur	q1, [sp, #0x12]
 107ed70: 52800409     	mov	w9, #0x20               // =32
 107ed74: 5280020a     	mov	w10, #0x10              // =16
 107ed78: 6b0802bf     	cmp	w21, w8
 107ed7c: 9a890143     	csel	x3, x10, x9, eq
 107ed80: 910243e0     	add	x0, sp, #0x90
 107ed84: b27f02c2     	orr	x2, x22, #0x2
 107ed88: 2a1503e1     	mov	w1, w21
 107ed8c: ad0187e0     	stp	q0, q1, [sp, #0x30]
 107ed90: 7900dbf5     	strh	w21, [sp, #0x6c]
 107ed94: 94003507     	bl	 <crypto.backend_openssl.aeadInit>
 107ed98: 794143e8     	ldrh	w8, [sp, #0xa0]
 107ed9c: 35000068     	cbnz	w8,  <L4>
 107eda0: 3dc027e0     	ldr	q0, [sp, #0x90]
 107eda4: 3d8017e0     	str	q0, [sp, #0x50]
<L4>:
 107eda8: 6f00e400     	movi	v0.2d, #0000000000000000
 107edac: 52826069     	mov	w9, #0x1303             // =4867
 107edb0: 52a0200a     	mov	w10, #0x1000000         // =16777216
 107edb4: 6b0902bf     	cmp	w21, w9
 107edb8: d2c00209     	mov	x9, #0x1000000000       // =68719476736
 107edbc: 9a8a0129     	csel	x9, x9, x10, eq
 107edc0: 3d8003e0     	str	q0, [sp]
 107edc4: 3d8007e0     	str	q0, [sp, #0x10]
 107edc8: 790043ff     	strh	wzr, [sp, #0x20]
 107edcc: ad420be0     	ldp	q0, q2, [sp, #0x40]
 107edd0: 3dc00fe1     	ldr	q1, [sp, #0x30]
 107edd4: a900267f     	stp	xzr, x9, [x19]
 107edd8: f84243e9     	ldur	x9, [sp, #0x24]
 107eddc: b9402fea     	ldr	w10, [sp, #0x2c]
 107ede0: 3c82a261     	stur	q1, [x19, #0x2a]
 107ede4: 3d800662     	str	q2, [x19, #0x10]
 107ede8: 79004275     	strh	w21, [x19, #0x20]
 107edec: 79005275     	strh	w21, [x19, #0x28]
 107edf0: 3c83a260     	stur	q0, [x19, #0x3a]
 107edf4: f804a269     	stur	x9, [x19, #0x4a]
 107edf8: b805226a     	stur	w10, [x19, #0x52]
 107edfc: 7900b268     	strh	w8, [x19, #0x58]
 107ee00: a95d4ff4     	ldp	x20, x19, [sp, #0x1d0]
 107ee04: f940dbfc     	ldr	x28, [sp, #0x1b0]
 107ee08: a95c57f6     	ldp	x22, x21, [sp, #0x1c0]
 107ee0c: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
 107ee10: 910783ff     	add	sp, sp, #0x1e0
 107ee14: d65f03c0     	ret
