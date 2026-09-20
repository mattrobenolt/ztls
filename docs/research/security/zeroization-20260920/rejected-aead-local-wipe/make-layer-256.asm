
zig-out/memory.N4aX4N/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

000000000107ebd4 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>:
 107ebd4: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 107ebd8: f9000bfc     	str	x28, [sp, #0x10]
 107ebdc: a9025ff8     	stp	x24, x23, [sp, #0x20]
 107ebe0: a90357f6     	stp	x22, x21, [sp, #0x30]
 107ebe4: a9044ff4     	stp	x20, x19, [sp, #0x40]
 107ebe8: 910003fd     	mov	x29, sp
 107ebec: d10843ff     	sub	sp, sp, #0x210
 107ebf0: 12003c28     	and	w8, w1, #0xffff
 107ebf4: 52826029     	mov	w9, #0x1301             // =4865
 107ebf8: aa0203f5     	mov	x21, x2
 107ebfc: 2a0103f4     	mov	w20, w1
 107ec00: aa0003f3     	mov	x19, x0
 107ec04: 6b09011f     	cmp	w8, w9
 107ec08: 910253f7     	add	x23, sp, #0x94
 107ec0c: 54000100     	b.eq	0x107ec2c <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer+0x58>
 107ec10: 52826049     	mov	w9, #0x1302             // =4866
 107ec14: 6b09011f     	cmp	w8, w9
 107ec18: 540002a1     	b.ne	0x107ec6c <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer+0x98>
 107ec1c: 52800129     	mov	w9, #0x9                // =9
 107ec20: 52840008     	mov	w8, #0x2000             // =8192
 107ec24: 9101cbea     	add	x10, sp, #0x72
 107ec28: 14000014     	b	0x107ec78 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer+0xa4>
 107ec2c: 52800129     	mov	w9, #0x9                // =9
 107ec30: 9100bbea     	add	x10, sp, #0x2e
 107ec34: 52820008     	mov	w8, #0x1000             // =4096
 107ec38: 39040be9     	strb	w9, [sp, #0x102]
 107ec3c: f0fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 107ec40: 913c0129     	add	x9, x9, #0xf00
 107ec44: f9400129     	ldr	x9, [x9]
 107ec48: 91000956     	add	x22, x10, #0x2
 107ec4c: 790203e8     	strh	w8, [sp, #0x100]
 107ec50: 52800f28     	mov	w8, #0x79               // =121
 107ec54: 910403e2     	add	x2, sp, #0x100
 107ec58: aa1603e0     	mov	x0, x22
 107ec5c: 52800201     	mov	w1, #0x10               // =16
 107ec60: 780772e8     	sturh	w8, [x23, #0x77]
 107ec64: f806f2e9     	stur	x9, [x23, #0x6f]
 107ec68: 14000010     	b	0x107eca8 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer+0xd4>
 107ec6c: 52800129     	mov	w9, #0x9                // =9
 107ec70: 52840008     	mov	w8, #0x2000             // =8192
 107ec74: 910143ea     	add	x10, sp, #0x50
 107ec78: 39040be9     	strb	w9, [sp, #0x102]
 107ec7c: f0fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 107ec80: 913c0129     	add	x9, x9, #0xf00
 107ec84: f9400129     	ldr	x9, [x9]
 107ec88: 790203e8     	strh	w8, [sp, #0x100]
 107ec8c: 52800f28     	mov	w8, #0x79               // =121
 107ec90: 91000956     	add	x22, x10, #0x2
 107ec94: 780772e8     	sturh	w8, [x23, #0x77]
 107ec98: 910403e2     	add	x2, sp, #0x100
 107ec9c: f806f2e9     	stur	x9, [x23, #0x6f]
 107eca0: aa1603e0     	mov	x0, x22
 107eca4: 52800401     	mov	w1, #0x20               // =32
 107eca8: 528001a3     	mov	w3, #0xd                // =13
 107ecac: aa1503e4     	mov	x4, x21
 107ecb0: 94008ab6     	bl	0x10a1788 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ecb4: 52818008     	mov	w8, #0xc00              // =3072
 107ecb8: ad4006c0     	ldp	q0, q1, [x22]
 107ecbc: 790203e8     	strh	w8, [sp, #0x100]
 107ecc0: 52800108     	mov	w8, #0x8                // =8
 107ecc4: 910253e0     	add	x0, sp, #0x94
 107ecc8: 39040be8     	strb	w8, [sp, #0x102]
 107eccc: d28d8e88     	mov	x8, #0x6c74             // =27764
 107ecd0: 910403e2     	add	x2, sp, #0x100
 107ecd4: f2a62e68     	movk	x8, #0x3173, lsl #16
 107ecd8: 52800181     	mov	w1, #0xc                // =12
 107ecdc: 52800183     	mov	w3, #0xc                // =12
 107ece0: f2c40668     	movk	x8, #0x2033, lsl #32
 107ece4: aa1503e4     	mov	x4, x21
 107ece8: 3c84a2e0     	stur	q0, [x23, #0x4a]
 107ecec: f2eecd28     	movk	x8, #0x7669, lsl #48
 107ecf0: 3c85a2e1     	stur	q1, [x23, #0x5a]
 107ecf4: 910373f8     	add	x24, sp, #0xdc
 107ecf8: f806f2e8     	stur	x8, [x23, #0x6f]
 107ecfc: 39042fff     	strb	wzr, [sp, #0x10b]
 107ed00: 94008aa2     	bl	0x10a1788 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 107ed04: ad4006c0     	ldp	q0, q1, [x22]
 107ed08: 52826028     	mov	w8, #0x1301             // =4865
 107ed0c: 52800409     	mov	w9, #0x20               // =32
 107ed10: 5280020a     	mov	w10, #0x10              // =16
 107ed14: 6b34211f     	cmp	w8, w20, uxth
 107ed18: 9a890143     	csel	x3, x10, x9, eq
 107ed1c: 910403e0     	add	x0, sp, #0x100
 107ed20: b27f0302     	orr	x2, x24, #0x2
 107ed24: 2a1403e1     	mov	w1, w20
 107ed28: ad0507e0     	stp	q0, q1, [sp, #0xa0]
 107ed2c: 7901bbf4     	strh	w20, [sp, #0xdc]
 107ed30: 94003508     	bl	0x108c150 <crypto.backend_openssl.aeadInit>
 107ed34: 794223e8     	ldrh	w8, [sp, #0x110]
 107ed38: 35000068     	cbnz	w8, 0x107ed44 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer+0x170>
 107ed3c: 3dc043e0     	ldr	q0, [sp, #0x100]
 107ed40: 3d8033e0     	str	q0, [sp, #0xc0]
 107ed44: 6f00e400     	movi	v0.2d, #0000000000000000
 107ed48: 52826069     	mov	w9, #0x1303             // =4867
 107ed4c: 79005bff     	strh	wzr, [sp, #0x2c]
 107ed50: 52a0200a     	mov	w10, #0x1000000         // =16777216
 107ed54: 6b34213f     	cmp	w9, w20, uxth
 107ed58: d2c00209     	mov	x9, #0x1000000000       // =68719476736
 107ed5c: 9a8a0129     	csel	x9, x9, x10, eq
 107ed60: 3d8003e0     	str	q0, [sp]
 107ed64: 3d8007e0     	str	q0, [sp, #0x10]
 107ed68: ad458be0     	ldp	q0, q2, [sp, #0xb0]
 107ed6c: 3dc02be1     	ldr	q1, [sp, #0xa0]
 107ed70: a900267f     	stp	xzr, x9, [x19]
 107ed74: f94002e9     	ldr	x9, [x23]
 107ed78: b9409fea     	ldr	w10, [sp, #0x9c]
 107ed7c: 3c82a261     	stur	q1, [x19, #0x2a]
 107ed80: 3d800662     	str	q2, [x19, #0x10]
 107ed84: 79004274     	strh	w20, [x19, #0x20]
 107ed88: 79005274     	strh	w20, [x19, #0x28]
 107ed8c: 3c83a260     	stur	q0, [x19, #0x3a]
 107ed90: f804a269     	stur	x9, [x19, #0x4a]
 107ed94: b805226a     	stur	w10, [x19, #0x52]
 107ed98: 7900b268     	strh	w8, [x19, #0x58]
 107ed9c: 910843ff     	add	sp, sp, #0x210
 107eda0: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 107eda4: f9400bfc     	ldr	x28, [sp, #0x10]
 107eda8: a94357f6     	ldp	x22, x21, [sp, #0x30]
 107edac: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 107edb0: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 107edb4: d65f03c0     	ret
