
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107eba4 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>:
 107eba4: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 107eba8: f9000bfc     	str	x28, [sp, #0x10]
 107ebac: a9025ff8     	stp	x24, x23, [sp, #0x20]
 107ebb0: a90357f6     	stp	x22, x21, [sp, #0x30]
 107ebb4: a9044ff4     	stp	x20, x19, [sp, #0x40]
 107ebb8: 910003fd     	mov	x29, sp
 107ebbc: d10783ff     	sub	sp, sp, #0x1e0
 107ebc0: 12003c28     	and	w8, w1, #0xffff
 107ebc4: 52826038     	mov	w24, #0x1301            // =4865
 107ebc8: aa0203f5     	mov	x21, x2
 107ebcc: 2a0103f4     	mov	w20, w1
 107ebd0: aa0003f3     	mov	x19, x0
 107ebd4: 6b18011f     	cmp	w8, w24
 107ebd8: 9101e3f6     	add	x22, sp, #0x78
 107ebdc: 540002e0     	b.eq	 <L0>
 107ebe0: 52826058     	mov	w24, #0x1302            // =4866
 107ebe4: 6b18011f     	cmp	w8, w24
 107ebe8: 540004e1     	b.ne	 <L1>
 107ebec: 52800129     	mov	w9, #0x9                // =9
 107ebf0: 52840008     	mov	w8, #0x2000             // =8192
 107ebf4: 910123f7     	add	x23, sp, #0x48
 107ebf8: 39034be9     	strb	w9, [sp, #0xd2]
 107ebfc: f0fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 107ec00: 913b0129     	add	x9, x9, #0xec0
 107ec04: f9400129     	ldr	x9, [x9]
 107ec08: 7901a3e8     	strh	w8, [sp, #0xd0]
 107ec0c: 52800f28     	mov	w8, #0x79               // =121
 107ec10: b27f02e0     	orr	x0, x23, #0x2
 107ec14: 910343e2     	add	x2, sp, #0xd0
 107ec18: 52800401     	mov	w1, #0x20               // =32
 107ec1c: 528001a3     	mov	w3, #0xd                // =13
 107ec20: aa1503e4     	mov	x4, x21
 107ec24: 780632c8     	sturh	w8, [x22, #0x63]
 107ec28: f805b2c9     	stur	x9, [x22, #0x5b]
 107ec2c: 94008b20     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ec30: 790093f8     	strh	w24, [sp, #0x48]
 107ec34: 14000027     	b	 <L2>
<L0>:
 107ec38: 52800129     	mov	w9, #0x9                // =9
 107ec3c: 52820008     	mov	w8, #0x1000             // =4096
 107ec40: 910003f7     	mov	x23, sp
 107ec44: 39034be9     	strb	w9, [sp, #0xd2]
 107ec48: f0fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 107ec4c: 913b0129     	add	x9, x9, #0xec0
 107ec50: f9400129     	ldr	x9, [x9]
 107ec54: 7901a3e8     	strh	w8, [sp, #0xd0]
 107ec58: 52800f28     	mov	w8, #0x79               // =121
 107ec5c: b27f02e0     	orr	x0, x23, #0x2
 107ec60: 910343e2     	add	x2, sp, #0xd0
 107ec64: 52800201     	mov	w1, #0x10               // =16
 107ec68: 528001a3     	mov	w3, #0xd                // =13
 107ec6c: aa1503e4     	mov	x4, x21
 107ec70: 780632c8     	sturh	w8, [x22, #0x63]
 107ec74: f805b2c9     	stur	x9, [x22, #0x5b]
 107ec78: 94008b0d     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ec7c: 790003f8     	strh	w24, [sp]
 107ec80: 14000014     	b	 <L2>
<L1>:
 107ec84: 52800129     	mov	w9, #0x9                // =9
 107ec88: 52840008     	mov	w8, #0x2000             // =8192
 107ec8c: 910093f7     	add	x23, sp, #0x24
 107ec90: 39034be9     	strb	w9, [sp, #0xd2]
 107ec94: f0fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 107ec98: 913b0129     	add	x9, x9, #0xec0
 107ec9c: f9400129     	ldr	x9, [x9]
 107eca0: 7901a3e8     	strh	w8, [sp, #0xd0]
 107eca4: 52800f28     	mov	w8, #0x79               // =121
 107eca8: b27f02e0     	orr	x0, x23, #0x2
 107ecac: 910343e2     	add	x2, sp, #0xd0
 107ecb0: 52800401     	mov	w1, #0x20               // =32
 107ecb4: 528001a3     	mov	w3, #0xd                // =13
 107ecb8: aa1503e4     	mov	x4, x21
 107ecbc: 780632c8     	sturh	w8, [x22, #0x63]
 107ecc0: f805b2c9     	stur	x9, [x22, #0x5b]
 107ecc4: 94008afa     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ecc8: 52826068     	mov	w8, #0x1303             // =4867
 107eccc: 79004be8     	strh	w8, [sp, #0x24]
<L2>:
 107ecd0: 52818008     	mov	w8, #0xc00              // =3072
 107ecd4: 52800109     	mov	w9, #0x8                // =8
 107ecd8: 9101b3e0     	add	x0, sp, #0x6c
 107ecdc: 7901a3e8     	strh	w8, [sp, #0xd0]
 107ece0: d28d8e88     	mov	x8, #0x6c74             // =27764
 107ece4: 910343e2     	add	x2, sp, #0xd0
 107ece8: f2a62e68     	movk	x8, #0x3173, lsl #16
 107ecec: 52800181     	mov	w1, #0xc                // =12
 107ecf0: 52800183     	mov	w3, #0xc                // =12
 107ecf4: f2c40668     	movk	x8, #0x2033, lsl #32
 107ecf8: aa1503e4     	mov	x4, x21
 107ecfc: 39034be9     	strb	w9, [sp, #0xd2]
 107ed00: f2eecd28     	movk	x8, #0x7669, lsl #48
 107ed04: 39036fff     	strb	wzr, [sp, #0xdb]
 107ed08: 910343f8     	add	x24, sp, #0xd0
 107ed0c: f805b2c8     	stur	x8, [x22, #0x5b]
 107ed10: 94008ae7     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ed14: ad4006e0     	ldp	q0, q1, [x23]
 107ed18: 9102e3e0     	add	x0, sp, #0xb8
 107ed1c: 794042e8     	ldrh	w8, [x23, #0x20]
 107ed20: 794042e9     	ldrh	w9, [x23, #0x20]
 107ed24: b27f0302     	orr	x2, x24, #0x2
 107ed28: 3c87e3e0     	stur	q0, [sp, #0x7e]
 107ed2c: 3c8162c1     	stur	q1, [x22, #0x16]
 107ed30: ad4006e0     	ldp	q0, q1, [x23]
 107ed34: 79013fe8     	strh	w8, [sp, #0x9e]
 107ed38: 52826028     	mov	w8, #0x1301             // =4865
 107ed3c: 7901e3e9     	strh	w9, [sp, #0xf0]
 107ed40: 52800209     	mov	w9, #0x10               // =16
 107ed44: ad0687e0     	stp	q0, q1, [sp, #0xd0]
 107ed48: 7941a3f5     	ldrh	w21, [sp, #0xd0]
 107ed4c: 6b0802bf     	cmp	w21, w8
 107ed50: 52800408     	mov	w8, #0x20               // =32
 107ed54: 2a1503e1     	mov	w1, w21
 107ed58: 9a880123     	csel	x3, x9, x8, eq
 107ed5c: 94003546     	bl	 <crypto.backend_openssl.aeadInit>
 107ed60: 794193e8     	ldrh	w8, [sp, #0xc8]
 107ed64: 350003c8     	cbnz	w8,  <L4>
 107ed68: 3dc012c0     	ldr	q0, [x22, #0x40]
 107ed6c: 3d802be0     	str	q0, [sp, #0xa0]
<L3>:
 107ed70: 52826069     	mov	w9, #0x1303             // =4867
 107ed74: d2c0020a     	mov	x10, #0x1000000000      // =68719476736
 107ed78: 3dc02be0     	ldr	q0, [sp, #0xa0]
 107ed7c: 6b34213f     	cmp	w9, w20, uxth
 107ed80: 52a02009     	mov	w9, #0x1000000          // =16777216
 107ed84: 3cc783e1     	ldur	q1, [sp, #0x78]
 107ed88: 9a890149     	csel	x9, x10, x9, eq
 107ed8c: 3d800660     	str	q0, [x19, #0x10]
 107ed90: 3dc006c0     	ldr	q0, [x22, #0x10]
 107ed94: a900267f     	stp	xzr, x9, [x19]
 107ed98: f9404fe9     	ldr	x9, [sp, #0x98]
 107ed9c: f846c3ea     	ldur	x10, [sp, #0x6c]
 107eda0: 3c822261     	stur	q1, [x19, #0x22]
 107eda4: f8042269     	stur	x9, [x19, #0x42]
 107eda8: b94077e9     	ldr	w9, [sp, #0x74]
 107edac: 79004275     	strh	w21, [x19, #0x20]
 107edb0: 3c832260     	stur	q0, [x19, #0x32]
 107edb4: f804a26a     	stur	x10, [x19, #0x4a]
 107edb8: b8052269     	stur	w9, [x19, #0x52]
 107edbc: 7900b268     	strh	w8, [x19, #0x58]
 107edc0: 910783ff     	add	sp, sp, #0x1e0
 107edc4: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 107edc8: f9400bfc     	ldr	x28, [sp, #0x10]
 107edcc: a94357f6     	ldp	x22, x21, [sp, #0x30]
 107edd0: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 107edd4: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 107edd8: d65f03c0     	ret
<L4>:
 107eddc: 17ffffe5     	b	 <L3>
