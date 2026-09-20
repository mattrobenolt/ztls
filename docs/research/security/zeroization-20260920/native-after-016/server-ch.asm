
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010a286c <ServerHandshake.processClientHelloMessage>:
 10a286c: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
 10a2870: a9016ffc     	stp	x28, x27, [sp, #0x10]
 10a2874: a90267fa     	stp	x26, x25, [sp, #0x20]
 10a2878: a9035ff8     	stp	x24, x23, [sp, #0x30]
 10a287c: a90457f6     	stp	x22, x21, [sp, #0x40]
 10a2880: a9054ff4     	stp	x20, x19, [sp, #0x50]
 10a2884: 910003fd     	mov	x29, sp
 10a2888: d14007ff     	sub	sp, sp, #0x1, lsl #12   // =0x1000
 10a288c: d13f83ff     	sub	sp, sp, #0xfe0
 10a2890: 9140103c     	add	x28, x1, #0x4, lsl #12  // =0x4000
 10a2894: aa0103f3     	mov	x19, x1
 10a2898: 39690b88     	ldrb	w8, [x28, #0xa42]
 10a289c: 12000508     	and	w8, w8, #0x3
 10a28a0: 7100091f     	cmp	w8, #0x2
 10a28a4: 54000061     	b.ne	 <L0>
 10a28a8: 39290b9f     	strb	wzr, [x28, #0xa42]
 10a28ac: b905767f     	str	wzr, [x19, #0x574]
<L0>:
 10a28b0: f941d668     	ldr	x8, [x19, #0x3a8]
 10a28b4: f1000d1f     	cmp	x8, #0x3
 10a28b8: 54000468     	b.hi	 <L4>
 10a28bc: 3966c794     	ldrb	w20, [x28, #0x9b1]
 10a28c0: b4000608     	cbz	x8,  <L9>
 10a28c4: f941d269     	ldr	x9, [x19, #0x3a0]
 10a28c8: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 10a28cc: 7940012a     	ldrh	w10, [x9]
 10a28d0: 0b0b014a     	add	w10, w10, w11
 10a28d4: 7100095f     	cmp	w10, #0x2
 10a28d8: 54000368     	b.hi	 <L4>
 10a28dc: f100051f     	cmp	x8, #0x1
 10a28e0: aa0903ea     	mov	x10, x9
 10a28e4: aa0803eb     	mov	x11, x8
 10a28e8: 540001e1     	b.ne	 <L3>
<L1>:
 10a28ec: 7840254c     	ldrh	w12, [x10], #0x2
 10a28f0: 12823d4d     	mov	w13, #-0x11eb           // =-4587
 10a28f4: 0b0d018c     	add	w12, w12, w13
 10a28f8: 71000d9f     	cmp	w12, #0x3
 10a28fc: 540003a2     	b.hs	 <L7>
 10a2900: f100056b     	subs	x11, x11, #0x1
 10a2904: 54ffff41     	b.ne	 <L1>
 10a2908: 52823daa     	mov	w10, #0x11ed            // =4589
<L2>:
 10a290c: 7840252b     	ldrh	w11, [x9], #0x2
 10a2910: 6b0a017f     	cmp	w11, w10
 10a2914: 54000320     	b.eq	 <L8>
 10a2918: f1000508     	subs	x8, x8, #0x1
 10a291c: 54ffff81     	b.ne	 <L2>
 10a2920: 14000018     	b	 <L9>
<L3>:
 10a2924: 7940052a     	ldrh	w10, [x9, #0x2]
 10a2928: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 10a292c: 0b0b014b     	add	w11, w10, w11
 10a2930: 7100097f     	cmp	w11, #0x2
 10a2934: 54000088     	b.hi	 <L4>
 10a2938: 7940012b     	ldrh	w11, [x9]
 10a293c: 6b0a017f     	cmp	w11, w10
 10a2940: 540021e1     	b.ne	 <L22>
<L4>:
 10a2944: 52800268     	mov	w8, #0x13               // =19
<L5>:
 10a2948: 79002008     	strh	w8, [x0, #0x10]
<L6>:
 10a294c: 914007ff     	add	sp, sp, #0x1, lsl #12   // =0x1000
 10a2950: 913f83ff     	add	sp, sp, #0xfe0
 10a2954: a9454ff4     	ldp	x20, x19, [sp, #0x50]
 10a2958: a94457f6     	ldp	x22, x21, [sp, #0x40]
 10a295c: a9435ff8     	ldp	x24, x23, [sp, #0x30]
 10a2960: a94267fa     	ldp	x26, x25, [sp, #0x20]
 10a2964: a9416ffc     	ldp	x28, x27, [sp, #0x10]
 10a2968: a8c67bfd     	ldp	x29, x30, [sp], #0x60
 10a296c: d65f03c0     	ret
<L7>:
 10a2970: 52800288     	mov	w8, #0x14               // =20
 10a2974: 17fffff5     	b	 <L5>
<L8>:
 10a2978: 396f1f88     	ldrb	w8, [x28, #0xbc7]
 10a297c: 340024e8     	cbz	w8,  <L29>
<L9>:
 10a2980: a90c83e2     	stp	x2, x0, [sp, #0xc8]
 10a2984: 910363e0     	add	x0, sp, #0xd8
 10a2988: aa0203e1     	mov	x1, x2
 10a298c: aa0303e2     	mov	x2, x3
 10a2990: f9004fe5     	str	x5, [sp, #0x98]
 10a2994: a90b8fe4     	stp	x4, x3, [sp, #0xb8]
 10a2998: 94001578     	bl	 <client_hello.parse>
 10a299c: 7944d3e8     	ldrh	w8, [sp, #0x268]
 10a29a0: 35012988     	cbnz	w8,  <L163>
 10a29a4: a94de3f7     	ldp	x23, x24, [sp, #0xd8]
 10a29a8: 52893148     	mov	w8, #0x498a             // =18826
 10a29ac: 52893229     	mov	w9, #0x4991             // =18833
 10a29b0: 914007f6     	add	x22, sp, #0x1, lsl #12  // =0x1000
 10a29b4: 9109c3e0     	add	x0, sp, #0x270
 10a29b8: 910363e1     	add	x1, sp, #0xd8
 10a29bc: 52803202     	mov	w2, #0x190              // =400
 10a29c0: 8b08027a     	add	x26, x19, x8
 10a29c4: 8b090275     	add	x21, x19, x9
 10a29c8: 913ac2d6     	add	x22, x22, #0xeb0
 10a29cc: 9109c3fb     	add	x27, sp, #0x270
 10a29d0: 9109c3f9     	add	x25, sp, #0x270
 10a29d4: 940507f0     	bl	 <memcpy>
 10a29d8: 340003f4     	cbz	w20,  <L12>
 10a29dc: 3cc17340     	ldur	q0, [x26, #0x17]
 10a29e0: 911003e0     	add	x0, sp, #0x400
 10a29e4: 9109c3e1     	add	x1, sp, #0x270
 10a29e8: 3d8023e0     	str	q0, [sp, #0x80]
 10a29ec: 3dc002a0     	ldr	q0, [x21]
 10a29f0: 3d802be0     	str	q0, [sp, #0xa0]
 10a29f4: 940014ac     	bl	 <ServerHandshake.retryClientHelloDigest>
 10a29f8: 3dc06760     	ldr	q0, [x27, #0x190]
 10a29fc: 3dc02be1     	ldr	q1, [sp, #0xa0]
 10a2a00: 9109c3e9     	add	x9, sp, #0x270
 10a2a04: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 10a2a08: 6e205800     	mvn	v0.16b, v0.16b
 10a2a0c: 6e30a800     	umaxv	b0, v0.16b
 10a2a10: 1e260008     	fmov	w8, s0
 10a2a14: 37000108     	tbnz	w8, #0x0,  <L10>
 10a2a18: 3dc06920     	ldr	q0, [x9, #0x1a0]
 10a2a1c: 3dc023e1     	ldr	q1, [sp, #0x80]
 10a2a20: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 10a2a24: 6e205800     	mvn	v0.16b, v0.16b
 10a2a28: 6e30a800     	umaxv	b0, v0.16b
 10a2a2c: 1e260008     	fmov	w8, s0
 10a2a30: 36001608     	tbz	w8, #0x0,  <L20>
<L10>:
 10a2a34: f0fffb48     	adrp	x8, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10a2a38: 913de108     	add	x8, x8, #0xf78
 10a2a3c: 3dc00100     	ldr	q0, [x8]
 10a2a40: 52800548     	mov	w8, #0x2a               // =42
<L11>:
 10a2a44: f9406be9     	ldr	x9, [sp, #0xd0]
 10a2a48: 3d800120     	str	q0, [x9]
 10a2a4c: f9000928     	str	x8, [x9, #0x10]
 10a2a50: 17ffffbf     	b	 <L6>
<L12>:
 10a2a54: f9406be8     	ldr	x8, [sp, #0xd0]
 10a2a58: 914007fb     	add	x27, sp, #0x1, lsl #12  // =0x1000
 10a2a5c: 91063f30     	add	x16, x25, #0x18f
 10a2a60: 9115037b     	add	x27, x27, #0x540
 10a2a64: f9003ff5     	str	x21, [sp, #0x78]
<L13>:
 10a2a68: 3943c279     	ldrb	w25, [x19, #0xf0]
 10a2a6c: 34001139     	cbz	w25,  <L16>
 10a2a70: 79530a74     	ldrh	w20, [x19, #0x984]
<L14>:
 10a2a74: f90053f0     	str	x16, [sp, #0xa0]
 10a2a78: f9415ff8     	ldr	x24, [sp, #0x2b8]
 10a2a7c: f941de77     	ldr	x23, [x19, #0x3b8]
 10a2a80: f9415be0     	ldr	x0, [sp, #0x2b0]
 10a2a84: f941da62     	ldr	x2, [x19, #0x3b0]
 10a2a88: 79130a74     	strh	w20, [x19, #0x984]
 10a2a8c: aa1803e1     	mov	x1, x24
 10a2a90: aa1703e3     	mov	x3, x23
 10a2a94: 940013ed     	bl	 <client_hello.Parsed.selectAlpn>
 10a2a98: f9020a60     	str	x0, [x19, #0x410]
 10a2a9c: f9020e61     	str	x1, [x19, #0x418]
 10a2aa0: b4000118     	cbz	x24,  <L15>
 10a2aa4: b40000f7     	cbz	x23,  <L15>
 10a2aa8: b50000c0     	cbnz	x0,  <L15>
 10a2aac: b0fffb28     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a2ab0: 912ac108     	add	x8, x8, #0xab0
 10a2ab4: 3dc00100     	ldr	q0, [x8]
 10a2ab8: 528005e8     	mov	w8, #0x2f               // =47
 10a2abc: 17ffffe2     	b	 <L11>
<L15>:
 10a2ac0: f94153e8     	ldr	x8, [sp, #0x2a0]
 10a2ac4: f94157e9     	ldr	x9, [sp, #0x2a8]
 10a2ac8: 911083f7     	add	x23, sp, #0x420
 10a2acc: f94197e1     	ldr	x1, [sp, #0x328]
 10a2ad0: f9021268     	str	x8, [x19, #0x420]
 10a2ad4: f9021669     	str	x9, [x19, #0x428]
 10a2ad8: b4001761     	cbz	x1,  <L23>
 10a2adc: f9419be2     	ldr	x2, [sp, #0x330]
 10a2ae0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a2ae4: aa1f03e3     	mov	x3, xzr
 10a2ae8: 913ac000     	add	x0, x0, #0xeb0
 10a2aec: 52800024     	mov	w4, #0x1                // =1
 10a2af0: 97ff7ade     	bl	 <mem.findScalarPos__anon_12800>
 10a2af4: 394022c8     	ldrb	w8, [x22, #0x8]
 10a2af8: f9418be9     	ldr	x9, [sp, #0x310]
 10a2afc: 7100011f     	cmp	w8, #0x0
 10a2b00: 1a9f07ea     	cset	w10, ne
 10a2b04: 39001b4a     	strb	w10, [x26, #0x6]
 10a2b08: b4003489     	cbz	x9,  <L45>
 10a2b0c: 34003468     	cbz	w8,  <L45>
 10a2b10: 3943a748     	ldrb	w8, [x26, #0xe9]
 10a2b14: 7200051f     	tst	w8, #0x3
 10a2b18: 54003401     	b.ne	 <L45>
 10a2b1c: 394e2268     	ldrb	w8, [x19, #0x388]
 10a2b20: 340033c8     	cbz	w8,  <L45>
 10a2b24: f941c264     	ldr	x4, [x19, #0x380]
 10a2b28: f941be63     	ldr	x3, [x19, #0x378]
 10a2b2c: 7100033f     	cmp	w25, #0x0
 10a2b30: f94067e2     	ldr	x2, [sp, #0xc8]
 10a2b34: 9a9303e6     	csel	x6, xzr, x19, eq
 10a2b38: 911083e0     	add	x0, sp, #0x420
 10a2b3c: 910363e1     	add	x1, sp, #0xd8
 10a2b40: 2a1403e5     	mov	w5, w20
 10a2b44: 911083f8     	add	x24, sp, #0x420
 10a2b48: 9400113a     	bl	 <ServerHandshake.selectPskWithTranscript>
 10a2b4c: 7948a3e8     	ldrh	w8, [sp, #0x450]
 10a2b50: 35011c08     	cbnz	w8,  <L163>
 10a2b54: 395123e8     	ldrb	w8, [sp, #0x448]
 10a2b58: 34003208     	cbz	w8,  <L45>
 10a2b5c: 7841530a     	ldurh	w10, [x24, #0x15]
 10a2b60: 9115566b     	add	x11, x19, #0x555
 10a2b64: 3841730c     	ldurb	w12, [x24, #0x17]
 10a2b68: f94213e1     	ldr	x1, [sp, #0x420]
 10a2b6c: f94217e2     	ldr	x2, [sp, #0x428]
 10a2b70: b94433e8     	ldr	w8, [sp, #0x430]
 10a2b74: 7900016a     	strh	w10, [x11]
 10a2b78: 79487fea     	ldrh	w10, [sp, #0x43e]
 10a2b7c: b841a2eb     	ldur	w11, [x23, #0x1a]
 10a2b80: 39155e6c     	strb	w12, [x19, #0x557]
 10a2b84: 91156a6c     	add	x12, x19, #0x55a
 10a2b88: 3950d3e9     	ldrb	w9, [sp, #0x434]
 10a2b8c: 790abe6a     	strh	w10, [x19, #0x55e]
 10a2b90: f94053ea     	ldr	x10, [sp, #0xa0]
 10a2b94: 794873f7     	ldrh	w23, [sp, #0x438]
 10a2b98: b900018b     	str	w11, [x12]
 10a2b9c: 5280002b     	mov	w11, #0x1               // =1
 10a2ba0: f94223ec     	ldr	x12, [sp, #0x440]
 10a2ba4: 3940014a     	ldrb	w10, [x10]
 10a2ba8: f902a261     	str	x1, [x19, #0x540]
 10a2bac: f902a662     	str	x2, [x19, #0x548]
 10a2bb0: 7100055f     	cmp	w10, #0x1
 10a2bb4: b9055268     	str	w8, [x19, #0x550]
 10a2bb8: 39155269     	strb	w9, [x19, #0x554]
 10a2bbc: 790ab277     	strh	w23, [x19, #0x558]
 10a2bc0: 3915826b     	strb	w11, [x19, #0x560]
 10a2bc4: 7913066c     	strh	w12, [x19, #0x982]
 10a2bc8: 54002e81     	b.ne	 <L45>
 10a2bcc: 34002e69     	cbz	w9,  <L45>
 10a2bd0: b9056e68     	str	w8, [x19, #0x56c]
 10a2bd4: 78415308     	ldurh	w8, [x24, #0x15]
 10a2bd8: 3841730a     	ldurb	w10, [x24, #0x17]
 10a2bdc: 5282604b     	mov	w11, #0x1302            // =4866
 10a2be0: 3915c269     	strb	w9, [x19, #0x570]
 10a2be4: 9115c669     	add	x9, x19, #0x571
 10a2be8: 6b0b02ff     	cmp	w23, w11
 10a2bec: 79000128     	strh	w8, [x9]
 10a2bf0: 3915ce6a     	strb	w10, [x19, #0x573]
 10a2bf4: 54002701     	b.ne	 <L43>
 10a2bf8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a2bfc: b0fffb23     	adrp	x3, 0x1007000 <__anon_13230+0x8>
 10a2c00: 912be063     	add	x3, x3, #0xaf8
 10a2c04: 91368000     	add	x0, x0, #0xda0
 10a2c08: 940012c2     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 10a2c0c: 914007e8     	add	x8, sp, #0x1, lsl #12   // =0x1000
 10a2c10: a94c03e1     	ldp	x1, x0, [sp, #0xc0]
 10a2c14: 913ac108     	add	x8, x8, #0xeb0
 10a2c18: 91005502     	add	x2, x8, #0x15
 10a2c1c: 97fff704     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).hash>
 10a2c20: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 10a2c24: 52800229     	mov	w9, #0x11               // =17
 10a2c28: 52860008     	mov	w8, #0x3000             // =12288
 10a2c2c: 913ac14a     	add	x10, x10, #0xeb0
 10a2c30: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a2c34: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a2c38: 39000949     	strb	w9, [x10, #0x2]
 10a2c3c: b0fffb29     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 10a2c40: 91344129     	add	x9, x9, #0xd10
 10a2c44: 3dc00120     	ldr	q0, [x9]
 10a2c48: 793d63e8     	strh	w8, [sp, #0x1eb0]
 10a2c4c: 52860c68     	mov	w8, #0x3063             // =12387
 10a2c50: 911163e0     	add	x0, sp, #0x458
 10a2c54: 913ac042     	add	x2, x2, #0xeb0
 10a2c58: 91368084     	add	x4, x4, #0xda0
 10a2c5c: 52800601     	mov	w1, #0x30               // =48
 10a2c60: 528008a3     	mov	w3, #0x45               // =69
 10a2c64: 78013148     	sturh	w8, [x10, #0x13]
 10a2c68: 3c803140     	stur	q0, [x10, #0x3]
 10a2c6c: 97ffec22     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a2c70: 911223e0     	add	x0, sp, #0x488
 10a2c74: 911163e2     	add	x2, sp, #0x458
 10a2c78: 52826041     	mov	w1, #0x1302             // =4866
 10a2c7c: 911223f7     	add	x23, sp, #0x488
 10a2c80: 97ffe30e     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 10a2c84: 7949c3e8     	ldrh	w8, [sp, #0x4e0]
 10a2c88: 34002708     	cbz	w8,  <L44>
 10a2c8c: 14000891     	b	 <L163>
<L16>:
 10a2c90: f941ce69     	ldr	x9, [x19, #0x398]
 10a2c94: b4000a89     	cbz	x9,  <L24>
 10a2c98: b4000a78     	cbz	x24,  <L24>
 10a2c9c: f941ca6b     	ldr	x11, [x19, #0x390]
 10a2ca0: aa1f03ea     	mov	x10, xzr
 10a2ca4: 1282606c     	mov	w12, #-0x1304           // =-4868
 10a2ca8: 529fffad     	mov	w13, #0xfffd            // =65533
 10a2cac: 14000004     	b	 <L18>
<L17>:
 10a2cb0: 9100054a     	add	x10, x10, #0x1
 10a2cb4: eb09015f     	cmp	x10, x9
 10a2cb8: 54000960     	b.eq	 <L24>
<L18>:
 10a2cbc: 786a7974     	ldrh	w20, [x11, x10, lsl #1]
 10a2cc0: 0b0c028e     	add	w14, w20, w12
 10a2cc4: 6b2e21bf     	cmp	w13, w14, uxth
 10a2cc8: 54ffff48     	b.hi	 <L17>
 10a2ccc: aa1f03ee     	mov	x14, xzr
<L19>:
 10a2cd0: 786e6aef     	ldrh	w15, [x23, x14]
 10a2cd4: 5ac009ef     	rev	w15, w15
 10a2cd8: 6b4f429f     	cmp	w20, w15, lsr #16
 10a2cdc: 54ffecc0     	b.eq	 <L14>
 10a2ce0: 910009ce     	add	x14, x14, #0x2
 10a2ce4: eb1801df     	cmp	x14, x24
 10a2ce8: 54ffff43     	b.lo	 <L19>
 10a2cec: 17fffff1     	b	 <L17>
<L20>:
 10a2cf0: 3940a34a     	ldrb	w10, [x26, #0x28]
 10a2cf4: f9418be9     	ldr	x9, [sp, #0x310]
 10a2cf8: aa1503ee     	mov	x14, x21
 10a2cfc: f9406be8     	ldr	x8, [sp, #0xd0]
 10a2d00: 3600080a     	tbz	w10, #0x0,  <L26>
 10a2d04: 5289366a     	mov	w10, #0x49b3            // =18867
 10a2d08: 914007fb     	add	x27, sp, #0x1, lsl #12  // =0x1000
 10a2d0c: 914007ec     	add	x12, sp, #0x1, lsl #12  // =0x1000
 10a2d10: 8b0a026a     	add	x10, x19, x10
 10a2d14: 9115037b     	add	x27, x27, #0x540
 10a2d18: 913ac18c     	add	x12, x12, #0xeb0
 10a2d1c: ad428540     	ldp	q0, q1, [x10, #0x50]
 10a2d20: 3dc01d42     	ldr	q2, [x10, #0x70]
 10a2d24: 914007f6     	add	x22, sp, #0x1, lsl #12  // =0x1000
 10a2d28: 3d827b62     	str	q2, [x27, #0x9e0]
 10a2d2c: 3dc00142     	ldr	q2, [x10]
 10a2d30: 913ac2d6     	add	x22, x22, #0xeb0
 10a2d34: 3d827360     	str	q0, [x27, #0x9c0]
 10a2d38: 3cc79140     	ldur	q0, [x10, #0x79]
 10a2d3c: 3d827761     	str	q1, [x27, #0x9d0]
 10a2d40: 3c879180     	stur	q0, [x12, #0x79]
 10a2d44: ad408141     	ldp	q1, q0, [x10, #0x10]
 10a2d48: 3942218b     	ldrb	w11, [x12, #0x88]
 10a2d4c: 3d800182     	str	q2, [x12]
 10a2d50: ad008181     	stp	q1, q0, [x12, #0x10]
 10a2d54: ad418d41     	ldp	q1, q3, [x10, #0x30]
 10a2d58: f9418fea     	ldr	x10, [sp, #0x318]
 10a2d5c: 92400d61     	and	x1, x11, #0xf
 10a2d60: ad018d81     	stp	q1, q3, [x12, #0x30]
 10a2d64: b40005e9     	cbz	x9,  <L30>
 10a2d68: f100095f     	cmp	x10, #0x2
 10a2d6c: 540008a2     	b.hs	 <L34>
<L21>:
 10a2d70: 52800309     	mov	w9, #0x18               // =24
 10a2d74: 79002109     	strh	w9, [x8, #0x10]
 10a2d78: 17fffef5     	b	 <L6>
<L22>:
 10a2d7c: f100091f     	cmp	x8, #0x2
 10a2d80: aa0903ea     	mov	x10, x9
 10a2d84: aa0803eb     	mov	x11, x8
 10a2d88: 54ffdb20     	b.eq	 <L1>
 10a2d8c: 7940092a     	ldrh	w10, [x9, #0x4]
 10a2d90: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 10a2d94: 0b0b014b     	add	w11, w10, w11
 10a2d98: 7100097f     	cmp	w11, #0x2
 10a2d9c: 54ffdd48     	b.hi	 <L4>
 10a2da0: 7940012b     	ldrh	w11, [x9]
 10a2da4: 6b0a017f     	cmp	w11, w10
 10a2da8: 54ffdce0     	b.eq	 <L4>
 10a2dac: 7940052b     	ldrh	w11, [x9, #0x2]
 10a2db0: 6b0a017f     	cmp	w11, w10
 10a2db4: aa0903ea     	mov	x10, x9
 10a2db8: aa0803eb     	mov	x11, x8
 10a2dbc: 54ffd981     	b.ne	 <L1>
 10a2dc0: 17fffee1     	b	 <L4>
<L23>:
 10a2dc4: f9418be8     	ldr	x8, [sp, #0x310]
 10a2dc8: 39001b5f     	strb	wzr, [x26, #0x6]
 10a2dcc: b4001e68     	cbz	x8,  <L45>
 10a2dd0: b0fffb28     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a2dd4: 912b2108     	add	x8, x8, #0xac8
 10a2dd8: 3dc00100     	ldr	q0, [x8]
 10a2ddc: 528004c8     	mov	w8, #0x26               // =38
 10a2de0: 17ffff19     	b	 <L11>
<L24>:
 10a2de4: f0fffb49     	adrp	x9, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10a2de8: 913d8129     	add	x9, x9, #0xf60
 10a2dec: 3dc00120     	ldr	q0, [x9]
 10a2df0: 528005c9     	mov	w9, #0x2e               // =46
<L25>:
 10a2df4: 3d800100     	str	q0, [x8]
 10a2df8: f9000909     	str	x9, [x8, #0x10]
 10a2dfc: 17fffed4     	b	 <L6>
<L26>:
 10a2e00: 914007fb     	add	x27, sp, #0x1, lsl #12  // =0x1000
 10a2e04: 9115037b     	add	x27, x27, #0x540
 10a2e08: b4000249     	cbz	x9,  <L33>
<L27>:
 10a2e0c: 52800549     	mov	w9, #0x2a               // =42
<L28>:
 10a2e10: 79002109     	strh	w9, [x8, #0x10]
 10a2e14: 17fffece     	b	 <L6>
<L29>:
 10a2e18: 528002a8     	mov	w8, #0x15               // =21
 10a2e1c: 17fffecb     	b	 <L5>
<L30>:
 10a2e20: aa1f03f4     	mov	x20, xzr
<L31>:
 10a2e24: eb140029     	subs	x9, x1, x20
 10a2e28: 54000149     	b.ls	 <L33>
 10a2e2c: 8b14128a     	add	x10, x20, x20, lsl #4
 10a2e30: 914007eb     	add	x11, sp, #0x1, lsl #12  // =0x1000
 10a2e34: 913ac16b     	add	x11, x11, #0xeb0
 10a2e38: 8b0b014a     	add	x10, x10, x11
 10a2e3c: 9100414a     	add	x10, x10, #0x10
<L32>:
 10a2e40: 3841154b     	ldrb	w11, [x10], #0x11
 10a2e44: 3607fe4b     	tbz	w11, #0x0,  <L27>
 10a2e48: f1000529     	subs	x9, x9, #0x1
 10a2e4c: 54ffffa1     	b.ne	 <L32>
<L33>:
 10a2e50: 3966c789     	ldrb	w9, [x28, #0x9b1]
 10a2e54: 9109c3ea     	add	x10, sp, #0x270
 10a2e58: f9003fee     	str	x14, [sp, #0x78]
 10a2e5c: 91063d50     	add	x16, x10, #0x18f
 10a2e60: 34ffe049     	cbz	w9,  <L13>
 10a2e64: 394fffe9     	ldrb	w9, [sp, #0x3ff]
 10a2e68: 3607e009     	tbz	w9, #0x0,  <L13>
 10a2e6c: f0fffb49     	adrp	x9, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10a2e70: 913de129     	add	x9, x9, #0xf78
 10a2e74: 3dc00120     	ldr	q0, [x9]
 10a2e78: 52800549     	mov	w9, #0x2a               // =42
 10a2e7c: 17ffffde     	b	 <L25>
<L34>:
 10a2e80: 7940012b     	ldrh	w11, [x9]
 10a2e84: 5ac0056f     	rev16	w15, w11
 10a2e88: 910011eb     	add	x11, x15, #0x4
 10a2e8c: eb0a017f     	cmp	x11, x10
 10a2e90: 540011c8     	b.hi	 <L42>
 10a2e94: 910009eb     	add	x11, x15, #0x2
 10a2e98: 786b692c     	ldrh	w12, [x9, x11]
 10a2e9c: cb0b014d     	sub	x13, x10, x11
 10a2ea0: 5ac0058c     	rev16	w12, w12
 10a2ea4: 9100098c     	add	x12, x12, #0x2
 10a2ea8: eb0d019f     	cmp	x12, x13
 10a2eac: 540010e1     	b.ne	 <L42>
 10a2eb0: 9100096b     	add	x11, x11, #0x2
 10a2eb4: cb0b014d     	sub	x13, x10, x11
 10a2eb8: 3400538f     	cbz	w15,  <L95>
 10a2ebc: 91000931     	add	x17, x9, #0x2
 10a2ec0: 8b0b0129     	add	x9, x9, x11
 10a2ec4: aa1f03f4     	mov	x20, xzr
 10a2ec8: a904a7ef     	stp	x15, x9, [sp, #0x48]
 10a2ecc: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 10a2ed0: aa1f03f0     	mov	x16, xzr
 10a2ed4: 91368129     	add	x9, x9, #0xda0
 10a2ed8: aa1f03ea     	mov	x10, xzr
 10a2edc: d1000432     	sub	x18, x1, #0x1
 10a2ee0: 9100a129     	add	x9, x9, #0x28
 10a2ee4: a9073bfa     	stp	x26, x14, [sp, #0x70]
 10a2ee8: a90347e9     	stp	x9, x17, [sp, #0x30]
 10a2eec: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 10a2ef0: 913ac129     	add	x9, x9, #0xeb0
 10a2ef4: f90023ed     	str	x13, [sp, #0x40]
 10a2ef8: 91004129     	add	x9, x9, #0x10
 10a2efc: f90017e1     	str	x1, [sp, #0x28]
 10a2f00: a901cbe9     	stp	x9, x18, [sp, #0x18]
<L35>:
 10a2f04: 91000a09     	add	x9, x16, #0x2
 10a2f08: eb0901eb     	subs	x11, x15, x9
 10a2f0c: 54fff323     	b.lo	 <L21>
 10a2f10: 78706a2c     	ldrh	w12, [x17, x16]
 10a2f14: 5ac00580     	rev16	w0, w12
 10a2f18: 9100100c     	add	x12, x0, #0x4
 10a2f1c: eb0c017f     	cmp	x11, x12
 10a2f20: 540050c3     	b.lo	 <L97>
 10a2f24: eb0d015f     	cmp	x10, x13
 10a2f28: 54fff242     	b.hs	 <L21>
 10a2f2c: f9402beb     	ldr	x11, [sp, #0x50]
 10a2f30: 9100054c     	add	x12, x10, #0x1
 10a2f34: 386a696b     	ldrb	w11, [x11, x10]
 10a2f38: cb0c01aa     	sub	x10, x13, x12
 10a2f3c: eb0b015f     	cmp	x10, x11
 10a2f40: 54004fc3     	b.lo	 <L97>
 10a2f44: b0fffb28     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a2f48: 91214108     	add	x8, x8, #0x850
 10a2f4c: f101001f     	cmp	x0, #0x40
 10a2f50: ad418500     	ldp	q0, q1, [x8, #0x30]
 10a2f54: 8b090239     	add	x25, x17, x9
 10a2f58: aa0003f5     	mov	x21, x0
 10a2f5c: a905afec     	stp	x12, x11, [sp, #0x58]
 10a2f60: f90053f0     	str	x16, [sp, #0xa0]
 10a2f64: 3d822760     	str	q0, [x27, #0x890]
 10a2f68: 3d822b61     	str	q1, [x27, #0x8a0]
 10a2f6c: ad428500     	ldp	q0, q1, [x8, #0x50]
 10a2f70: 3d823361     	str	q1, [x27, #0x8c0]
 10a2f74: ad408901     	ldp	q1, q2, [x8, #0x10]
 10a2f78: 3d822f60     	str	q0, [x27, #0x8b0]
 10a2f7c: 3dc00100     	ldr	q0, [x8]
 10a2f80: 3d821b60     	str	q0, [x27, #0x860]
 10a2f84: 3d821f61     	str	q1, [x27, #0x870]
 10a2f88: 3d822362     	str	q2, [x27, #0x880]
 10a2f8c: 540000a2     	b.hs	 <L36>
 10a2f90: f90043ff     	str	xzr, [sp, #0x80]
 10a2f94: aa1f03e9     	mov	x9, xzr
 10a2f98: aa1f03e8     	mov	x8, xzr
 10a2f9c: 14000010     	b	 <L38>
<L36>:
 10a2fa0: aa1f03e8     	mov	x8, xzr
<L37>:
 10a2fa4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a2fa8: 8b080321     	add	x1, x25, x8
 10a2fac: aa0803fa     	mov	x26, x8
 10a2fb0: 91368000     	add	x0, x0, #0xda0
 10a2fb4: 97ffe4c9     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 10a2fb8: 91020348     	add	x8, x26, #0x80
 10a2fbc: eb15011f     	cmp	x8, x21
 10a2fc0: 91010348     	add	x8, x26, #0x40
 10a2fc4: 54ffff09     	b.ls	 <L37>
 10a2fc8: 39632369     	ldrb	w9, [x27, #0x8c8]
 10a2fcc: f94ee3ea     	ldr	x10, [sp, #0x1dc0]
 10a2fd0: aa1503e0     	mov	x0, x21
 10a2fd4: f9403bfa     	ldr	x26, [sp, #0x70]
 10a2fd8: f90043ea     	str	x10, [sp, #0x80]
<L38>:
 10a2fdc: f9401bea     	ldr	x10, [sp, #0x30]
 10a2fe0: f90037e0     	str	x0, [sp, #0x68]
 10a2fe4: cb080002     	sub	x2, x0, x8
 10a2fe8: 8b080321     	add	x1, x25, x8
 10a2fec: aa0203f9     	mov	x25, x2
 10a2ff0: 8b090140     	add	x0, x10, x9
 10a2ff4: 94050668     	bl	 <memcpy>
 10a2ff8: 39632368     	ldrb	w8, [x27, #0x8c8]
 10a2ffc: f94043e9     	ldr	x9, [sp, #0x80]
 10a3000: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3004: f94037ea     	ldr	x10, [sp, #0x68]
 10a3008: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a300c: 91368000     	add	x0, x0, #0xda0
 10a3010: 0b190108     	add	w8, w8, w25
 10a3014: 911b0021     	add	x1, x1, #0x6c0
 10a3018: 8b0a0129     	add	x9, x9, x10
 10a301c: 39232368     	strb	w8, [x27, #0x8c8]
 10a3020: f90ee3e9     	str	x9, [sp, #0x1dc0]
 10a3024: 97ffea7f     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10a3028: f94017e1     	ldr	x1, [sp, #0x28]
 10a302c: eb01029f     	cmp	x20, x1
 10a3030: 540002e2     	b.hs	 <L40>
 10a3034: a941cbe9     	ldp	x9, x18, [sp, #0x18]
 10a3038: 8b141288     	add	x8, x20, x20, lsl #4
 10a303c: a9443fed     	ldp	x13, x15, [sp, #0x40]
 10a3040: 3dc06360     	ldr	q0, [x27, #0x180]
 10a3044: f9403fee     	ldr	x14, [sp, #0x78]
 10a3048: f94053ec     	ldr	x12, [sp, #0xa0]
 10a304c: f9401ff1     	ldr	x17, [sp, #0x38]
 10a3050: 8b08012a     	add	x10, x9, x8
 10a3054: f9406be8     	ldr	x8, [sp, #0xd0]
<L39>:
 10a3058: 3cdf0141     	ldur	q1, [x10, #-0x10]
 10a305c: 6ea18c01     	cmeq	v1.4s, v0.4s, v1.4s
 10a3060: 6e205821     	mvn	v1.16b, v1.16b
 10a3064: 6eb0a821     	umaxv	s1, v1.4s
 10a3068: 1e260029     	fmov	w9, s1
 10a306c: 36000189     	tbz	w9, #0x0,  <L41>
 10a3070: 3841154b     	ldrb	w11, [x10], #0x11
 10a3074: 52800549     	mov	w9, #0x2a               // =42
 10a3078: 3607eccb     	tbz	w11, #0x0,  <L28>
 10a307c: eb14025f     	cmp	x18, x20
 10a3080: 91000694     	add	x20, x20, #0x1
 10a3084: 54fffea1     	b.ne	 <L39>
 10a3088: 17ffff62     	b	 <L28>
<L40>:
 10a308c: a9443fed     	ldp	x13, x15, [sp, #0x40]
 10a3090: f9403fee     	ldr	x14, [sp, #0x78]
 10a3094: f94053ec     	ldr	x12, [sp, #0xa0]
 10a3098: f9401ff1     	ldr	x17, [sp, #0x38]
<L41>:
 10a309c: eb01029f     	cmp	x20, x1
 10a30a0: 5400e840     	b.eq	 <L152>
 10a30a4: 8b150188     	add	x8, x12, x21
 10a30a8: 91000694     	add	x20, x20, #0x1
 10a30ac: 91001910     	add	x16, x8, #0x6
 10a30b0: a945a3e9     	ldp	x9, x8, [sp, #0x58]
 10a30b4: eb0f021f     	cmp	x16, x15
 10a30b8: 8b08012a     	add	x10, x9, x8
 10a30bc: f9406be8     	ldr	x8, [sp, #0xd0]
 10a30c0: 54fff223     	b.lo	 <L35>
 10a30c4: 1400021b     	b	 <L96>
<L42>:
 10a30c8: 528002c9     	mov	w9, #0x16               // =22
 10a30cc: 79002109     	strh	w9, [x8, #0x10]
 10a30d0: 17fffe1f     	b	 <L6>
<L43>:
 10a30d4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a30d8: f0fffd43     	adrp	x3, 0x104e000 <__anon_429238+0xb615>
 10a30dc: 91364063     	add	x3, x3, #0xd90
 10a30e0: 91368000     	add	x0, x0, #0xda0
 10a30e4: 94000f5a     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10a30e8: 914007e8     	add	x8, sp, #0x1, lsl #12   // =0x1000
 10a30ec: a94c03e1     	ldp	x1, x0, [sp, #0xc0]
 10a30f0: 913ac108     	add	x8, x8, #0xeb0
 10a30f4: 91005502     	add	x2, x8, #0x15
 10a30f8: 97ffeac6     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).hash>
 10a30fc: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 10a3100: 52800229     	mov	w9, #0x11               // =17
 10a3104: 52840008     	mov	w8, #0x2000             // =8192
 10a3108: 913ac14a     	add	x10, x10, #0xeb0
 10a310c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a3110: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a3114: 39000949     	strb	w9, [x10, #0x2]
 10a3118: 90fffb29     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 10a311c: 91344129     	add	x9, x9, #0xd10
 10a3120: 3dc00120     	ldr	q0, [x9]
 10a3124: 793d63e8     	strh	w8, [sp, #0x1eb0]
 10a3128: 52840c68     	mov	w8, #0x2063             // =8291
 10a312c: 9113a3e0     	add	x0, sp, #0x4e8
 10a3130: 913ac042     	add	x2, x2, #0xeb0
 10a3134: 91368084     	add	x4, x4, #0xda0
 10a3138: 52800401     	mov	w1, #0x20               // =32
 10a313c: 528006a3     	mov	w3, #0x35               // =53
 10a3140: 78013148     	sturh	w8, [x10, #0x13]
 10a3144: 3c803140     	stur	q0, [x10, #0x3]
 10a3148: 97ffe2e0     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a314c: 911423e0     	add	x0, sp, #0x508
 10a3150: 9113a3e2     	add	x2, sp, #0x4e8
 10a3154: 2a1703e1     	mov	w1, w23
 10a3158: 911423f7     	add	x23, sp, #0x508
 10a315c: 97ffe25b     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10a3160: 794ac3e8     	ldrh	w8, [sp, #0x560]
 10a3164: 3500eb68     	cbnz	w8,  <L163>
<L44>:
 10a3168: ad4106e0     	ldp	q0, q1, [x23, #0x20]
 10a316c: f9402ae8     	ldr	x8, [x23, #0x50]
 10a3170: 3dc012e2     	ldr	q2, [x23, #0x40]
 10a3174: f9029a68     	str	x8, [x19, #0x530]
 10a3178: 52800028     	mov	w8, #0x1                // =1
 10a317c: 3d814260     	str	q0, [x19, #0x500]
 10a3180: 3d814661     	str	q1, [x19, #0x510]
 10a3184: ad4006e0     	ldp	q0, q1, [x23]
 10a3188: 3d814a62     	str	q2, [x19, #0x520]
 10a318c: 3914e268     	strb	w8, [x19, #0x538]
 10a3190: 3d813a60     	str	q0, [x19, #0x4e0]
 10a3194: 3d813e61     	str	q1, [x19, #0x4f0]
<L45>:
 10a3198: 9109c3e8     	add	x8, sp, #0x270
 10a319c: 9115b3e0     	add	x0, sp, #0x56c
 10a31a0: 2a1f03e1     	mov	w1, wzr
 10a31a4: 5280d082     	mov	w2, #0x684              // =1668
 10a31a8: 913143f8     	add	x24, sp, #0xc50
 10a31ac: 91014117     	add	x23, x8, #0x50
 10a31b0: 94050590     	bl	 <memset>
 10a31b4: 6f00e400     	movi	v0.2d, #0000000000000000
 10a31b8: 39660268     	ldrb	w8, [x19, #0x980]
 10a31bc: 911083f9     	add	x25, sp, #0x420
 10a31c0: 393103ff     	strb	wzr, [sp, #0xc40]
 10a31c4: 3d81f720     	str	q0, [x25, #0x7d0]
 10a31c8: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a31cc: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a31d0: 3d820320     	str	q0, [x25, #0x800]
 10a31d4: 3d820720     	str	q0, [x25, #0x810]
 10a31d8: 34000448     	cbz	w8,  <L46>
 10a31dc: 7952fe6b     	ldrh	w11, [x19, #0x97e]
 10a31e0: 52823d48     	mov	w8, #0x11ea             // =4586
 10a31e4: 6b08017f     	cmp	w11, w8
 10a31e8: f9405fe8     	ldr	x8, [sp, #0xb8]
 10a31ec: 54000fcc     	b.gt	 <L60>
 10a31f0: f9406bea     	ldr	x10, [sp, #0xd0]
 10a31f4: f9404fe9     	ldr	x9, [sp, #0x98]
 10a31f8: 71005d7f     	cmp	w11, #0x17
 10a31fc: 54001d40     	b.eq	 <L77>
 10a3200: 7100617f     	cmp	w11, #0x18
 10a3204: 54001fa0     	b.eq	 <L78>
 10a3208: 7100757f     	cmp	w11, #0x1d
 10a320c: 54002a01     	b.ne	 <L84>
 10a3210: 394d67eb     	ldrb	w11, [sp, #0x359]
 10a3214: 340029cb     	cbz	w11,  <L84>
 10a3218: 394e6feb     	ldrb	w11, [sp, #0x39b]
 10a321c: 3500298b     	cbnz	w11,  <L84>
 10a3220: 394ff7eb     	ldrb	w11, [sp, #0x3fd]
 10a3224: 3500294b     	cbnz	w11,  <L84>
 10a3228: 394c23eb     	ldrb	w11, [sp, #0x308]
 10a322c: 7200057f     	tst	w11, #0x3
 10a3230: 540028e1     	b.ne	 <L84>
 10a3234: 9109c3ea     	add	x10, sp, #0x270
 10a3238: 9109c3ec     	add	x12, sp, #0x270
 10a323c: 393133ff     	strb	wzr, [sp, #0xc4c]
 10a3240: 3ccc9140     	ldur	q0, [x10, #0xc9]
 10a3244: f84db14b     	ldur	x11, [x10, #0xdb]
 10a3248: f84e114a     	ldur	x10, [x10, #0xe1]
 10a324c: 784d9195     	ldurh	w21, [x12, #0xd9]
 10a3250: 3d801700     	str	q0, [x24, #0x50]
 10a3254: f9062beb     	str	x11, [sp, #0xc50]
 10a3258: f800630a     	stur	x10, [x24, #0x6]
 10a325c: 140001dd     	b	 <L102>
<L46>:
 10a3260: f941d666     	ldr	x6, [x19, #0x3a8]
 10a3264: f9405fe8     	ldr	x8, [sp, #0xb8]
 10a3268: b4000e46     	cbz	x6,  <L63>
 10a326c: 394c23e9     	ldrb	w9, [sp, #0x308]
 10a3270: a94c0be3     	ldp	x3, x2, [sp, #0xc0]
 10a3274: f941d26b     	ldr	x11, [x19, #0x3a0]
 10a3278: 1200052c     	and	w12, w9, #0x3
 10a327c: f9404fe9     	ldr	x9, [sp, #0x98]
 10a3280: 34000f8c     	cbz	w12,  <L65>
 10a3284: 7945a3ee     	ldrh	w14, [sp, #0x2d0]
 10a3288: 7945d3ef     	ldrh	w15, [sp, #0x2e8]
 10a328c: aa1f03ed     	mov	x13, xzr
 10a3290: 794603f0     	ldrh	w16, [sp, #0x300]
 10a3294: 12823d51     	mov	w17, #-0x11eb           // =-4587
 10a3298: 52823db2     	mov	w18, #0x11ed            // =4589
 10a329c: 14000004     	b	 <L48>
<L47>:
 10a32a0: 910005ad     	add	x13, x13, #0x1
 10a32a4: eb0601bf     	cmp	x13, x6
 10a32a8: 54000e40     	b.eq	 <L65>
<L48>:
 10a32ac: 786d7961     	ldrh	w1, [x11, x13, lsl #1]
 10a32b0: 12003c2a     	and	w10, w1, #0xffff
 10a32b4: 0b110140     	add	w0, w10, w17
 10a32b8: 7100081f     	cmp	w0, #0x2
 10a32bc: 54000422     	b.hs	 <L54>
 10a32c0: 6b2121df     	cmp	w14, w1, uxth
 10a32c4: 54000101     	b.ne	 <L50>
 10a32c8: aa0b03e0     	mov	x0, x11
 10a32cc: aa0603ea     	mov	x10, x6
<L49>:
 10a32d0: 78402404     	ldrh	w4, [x0], #0x2
 10a32d4: 6b21209f     	cmp	w4, w1, uxth
 10a32d8: 540033c0     	b.eq	 <L100>
 10a32dc: f100054a     	subs	x10, x10, #0x1
 10a32e0: 54ffff81     	b.ne	 <L49>
<L50>:
 10a32e4: 7100059f     	cmp	w12, #0x1
 10a32e8: 54fffdc0     	b.eq	 <L47>
 10a32ec: 6b2121ff     	cmp	w15, w1, uxth
 10a32f0: 54000101     	b.ne	 <L52>
 10a32f4: aa0b03e0     	mov	x0, x11
 10a32f8: aa0603e4     	mov	x4, x6
<L51>:
 10a32fc: 7840240a     	ldrh	w10, [x0], #0x2
 10a3300: 6b21215f     	cmp	w10, w1, uxth
 10a3304: 540023c0     	b.eq	 <L85>
 10a3308: f1000484     	subs	x4, x4, #0x1
 10a330c: 54ffff81     	b.ne	 <L51>
<L52>:
 10a3310: 7100099f     	cmp	w12, #0x2
 10a3314: 54fffc60     	b.eq	 <L47>
 10a3318: 6b21221f     	cmp	w16, w1, uxth
 10a331c: 54fffc21     	b.ne	 <L47>
 10a3320: aa0b03e0     	mov	x0, x11
 10a3324: aa0603e4     	mov	x4, x6
<L53>:
 10a3328: 7840240a     	ldrh	w10, [x0], #0x2
 10a332c: 6b21215f     	cmp	w10, w1, uxth
 10a3330: 540027e0     	b.eq	 <L90>
 10a3334: f1000484     	subs	x4, x4, #0x1
 10a3338: 54ffff81     	b.ne	 <L53>
 10a333c: 17ffffd9     	b	 <L47>
<L54>:
 10a3340: 6b12015f     	cmp	w10, w18
 10a3344: 54fffae1     	b.ne	 <L47>
 10a3348: 6b1201df     	cmp	w14, w18
 10a334c: 54000161     	b.ne	 <L56>
 10a3350: 3948f74a     	ldrb	w10, [x26, #0x23d]
 10a3354: 3400012a     	cbz	w10,  <L56>
 10a3358: aa0b03e0     	mov	x0, x11
 10a335c: aa0603e4     	mov	x4, x6
<L55>:
 10a3360: 7840240a     	ldrh	w10, [x0], #0x2
 10a3364: 52823da1     	mov	w1, #0x11ed             // =4589
 10a3368: 6b01015f     	cmp	w10, w1
 10a336c: 54002f20     	b.eq	 <L100>
 10a3370: f1000484     	subs	x4, x4, #0x1
 10a3374: 54ffff61     	b.ne	 <L55>
<L56>:
 10a3378: 7100059f     	cmp	w12, #0x1
 10a337c: 54fff920     	b.eq	 <L47>
 10a3380: 6b1201ff     	cmp	w15, w18
 10a3384: 54000141     	b.ne	 <L58>
 10a3388: 3948f74a     	ldrb	w10, [x26, #0x23d]
 10a338c: 3400010a     	cbz	w10,  <L58>
 10a3390: aa0b03e0     	mov	x0, x11
 10a3394: aa0603e1     	mov	x1, x6
<L57>:
 10a3398: 7840240a     	ldrh	w10, [x0], #0x2
 10a339c: 6b12015f     	cmp	w10, w18
 10a33a0: 54002be0     	b.eq	 <L94>
 10a33a4: f1000421     	subs	x1, x1, #0x1
 10a33a8: 54ffff81     	b.ne	 <L57>
<L58>:
 10a33ac: 7100099f     	cmp	w12, #0x2
 10a33b0: 54fff780     	b.eq	 <L47>
 10a33b4: 6b12021f     	cmp	w16, w18
 10a33b8: 54fff741     	b.ne	 <L47>
 10a33bc: 3948f74a     	ldrb	w10, [x26, #0x23d]
 10a33c0: 34fff70a     	cbz	w10,  <L47>
 10a33c4: aa0b03e0     	mov	x0, x11
 10a33c8: aa0603e1     	mov	x1, x6
<L59>:
 10a33cc: 7840240a     	ldrh	w10, [x0], #0x2
 10a33d0: 6b12015f     	cmp	w10, w18
 10a33d4: 54002b80     	b.eq	 <L98>
 10a33d8: f1000421     	subs	x1, x1, #0x1
 10a33dc: 54ffff81     	b.ne	 <L59>
 10a33e0: 17ffffb0     	b	 <L47>
<L60>:
 10a33e4: 12823d48     	mov	w8, #-0x11eb            // =-4587
 10a33e8: f9406bea     	ldr	x10, [sp, #0xd0]
 10a33ec: 0b080168     	add	w8, w11, w8
 10a33f0: 7100091f     	cmp	w8, #0x2
 10a33f4: 540000c3     	b.lo	 <L61>
 10a33f8: 52823da8     	mov	w8, #0x11ed             // =4589
 10a33fc: 6b08017f     	cmp	w11, w8
 10a3400: 54001a61     	b.ne	 <L84>
 10a3404: 3948f748     	ldrb	w8, [x26, #0x23d]
 10a3408: 34001a08     	cbz	w8,  <L83>
<L61>:
 10a340c: f941d668     	ldr	x8, [x19, #0x3a8]
 10a3410: b40019c8     	cbz	x8,  <L83>
 10a3414: f941d269     	ldr	x9, [x19, #0x3a0]
<L62>:
 10a3418: 7840252c     	ldrh	w12, [x9], #0x2
 10a341c: 6b0b019f     	cmp	w12, w11
 10a3420: 54001560     	b.eq	 <L82>
 10a3424: f1000508     	subs	x8, x8, #0x1
 10a3428: 54ffff81     	b.ne	 <L62>
 10a342c: 140000c7     	b	 <L83>
<L63>:
 10a3430: a94cb3e2     	ldp	x2, x12, [sp, #0xc8]
 10a3434: 394ce3ed     	ldrb	w13, [sp, #0x338]
 10a3438: f94063e3     	ldr	x3, [sp, #0xc0]
 10a343c: f9404fe9     	ldr	x9, [sp, #0x98]
 10a3440: 394d67ea     	ldrb	w10, [sp, #0x359]
 10a3444: 34001aca     	cbz	w10,  <L87>
<L64>:
 10a3448: 9109c3ec     	add	x12, sp, #0x270
 10a344c: 393133ff     	strb	wzr, [sp, #0xc4c]
 10a3450: 3ccc9180     	ldur	q0, [x12, #0xc9]
 10a3454: f84db18a     	ldur	x10, [x12, #0xdb]
 10a3458: f84e118b     	ldur	x11, [x12, #0xe1]
 10a345c: 784d9195     	ldurh	w21, [x12, #0xd9]
 10a3460: 3d801700     	str	q0, [x24, #0x50]
 10a3464: f9062bea     	str	x10, [sp, #0xc50]
 10a3468: f800630b     	stur	x11, [x24, #0x6]
 10a346c: 14000159     	b	 <L102>
<L65>:
 10a3470: 394ce3ed     	ldrb	w13, [sp, #0x338]
 10a3474: f9406bec     	ldr	x12, [sp, #0xd0]
 10a3478: aa1a03f7     	mov	x23, x26
 10a347c: aa1f03ee     	mov	x14, xzr
 10a3480: 90fffb2f     	adrp	x15, 0x1007000 <__anon_13230+0x8>
 10a3484: 912e61ef     	add	x15, x15, #0xb98
 10a3488: 90fffb35     	adrp	x21, 0x1007000 <__anon_13230+0x8>
 10a348c: 912e72b5     	add	x21, x21, #0xb9c
 10a3490: 52823d52     	mov	w18, #0x11ea            // =4586
 10a3494: 90fffb36     	adrp	x22, 0x1007000 <__anon_13230+0x8>
 10a3498: 912e82d6     	add	x22, x22, #0xba0
 10a349c: 12823d41     	mov	w1, #-0x11eb            // =-4587
 10a34a0: 90fffb24     	adrp	x4, 0x1007000 <__anon_13230+0x8>
 10a34a4: 912eb884     	add	x4, x4, #0xbae
 10a34a8: 52823da5     	mov	w5, #0x11ed             // =4589
 10a34ac: 90fffb30     	adrp	x16, 0x1007000 <__anon_13230+0x8>
 10a34b0: 912e9210     	add	x16, x16, #0xba4
 10a34b4: 52823d67     	mov	w7, #0x11eb             // =4587
 10a34b8: 90fffb20     	adrp	x0, 0x1007000 <__anon_13230+0x8>
 10a34bc: 912ea000     	add	x0, x0, #0xba8
 10a34c0: 52823d98     	mov	w24, #0x11ec            // =4588
 10a34c4: 90fffb39     	adrp	x25, 0x1007000 <__anon_13230+0x8>
 10a34c8: 912eb339     	add	x25, x25, #0xbac
 10a34cc: 14000004     	b	 <L67>
<L66>:
 10a34d0: 910005ce     	add	x14, x14, #0x1
 10a34d4: eb0601df     	cmp	x14, x6
 10a34d8: 54001580     	b.eq	 <L86>
<L67>:
 10a34dc: 786e7971     	ldrh	w17, [x11, x14, lsl #1]
 10a34e0: 6b12023f     	cmp	w17, w18
 10a34e4: 5400012c     	b.gt	 <L68>
 10a34e8: 71005e3f     	cmp	w17, #0x17
 10a34ec: 540001e0     	b.eq	 <L69>
 10a34f0: 7100623f     	cmp	w17, #0x18
 10a34f4: 54000260     	b.eq	 <L72>
 10a34f8: 7100763f     	cmp	w17, #0x1d
 10a34fc: aa0f03ea     	mov	x10, x15
 10a3500: 54000260     	b.eq	 <L74>
 10a3504: 1400000d     	b	 <L71>
<L68>:
 10a3508: 6b07023f     	cmp	w17, w7
 10a350c: 54000120     	b.eq	 <L70>
 10a3510: 6b18023f     	cmp	w17, w24
 10a3514: 540001a0     	b.eq	 <L73>
 10a3518: 6b05023f     	cmp	w17, w5
 10a351c: 540000e1     	b.ne	 <L71>
 10a3520: aa1903ea     	mov	x10, x25
 10a3524: 1400000a     	b	 <L74>
<L69>:
 10a3528: aa1503ea     	mov	x10, x21
 10a352c: 14000008     	b	 <L74>
<L70>:
 10a3530: aa1003ea     	mov	x10, x16
 10a3534: 14000006     	b	 <L74>
<L71>:
 10a3538: aa0403ea     	mov	x10, x4
 10a353c: 14000004     	b	 <L74>
<L72>:
 10a3540: aa1603ea     	mov	x10, x22
 10a3544: 14000002     	b	 <L74>
<L73>:
 10a3548: aa0003ea     	mov	x10, x0
<L74>:
 10a354c: 7940014a     	ldrh	w10, [x10]
 10a3550: 7104015f     	cmp	w10, #0x100
 10a3554: 54fffbe3     	b.lo	 <L66>
 10a3558: 120015ba     	and	w26, w13, #0x3f
 10a355c: 9240094a     	and	x10, x10, #0x7
 10a3560: 1aca274a     	lsr	w10, w26, w10
 10a3564: 3607fb6a     	tbz	w10, #0x0,  <L66>
 10a3568: 0b01022a     	add	w10, w17, w1
 10a356c: 7100095f     	cmp	w10, #0x2
 10a3570: 540000a3     	b.lo	 <L75>
 10a3574: 6b05023f     	cmp	w17, w5
 10a3578: 54fffac1     	b.ne	 <L66>
 10a357c: 3948f6ea     	ldrb	w10, [x23, #0x23d]
 10a3580: 34fffa8a     	cbz	w10,  <L66>
<L75>:
 10a3584: aa0b03fe     	mov	x30, x11
 10a3588: aa0603ea     	mov	x10, x6
<L76>:
 10a358c: 784027da     	ldrh	w26, [x30], #0x2
 10a3590: 6b11035f     	cmp	w26, w17
 10a3594: 54000620     	b.eq	 <L79>
 10a3598: f100054a     	subs	x10, x10, #0x1
 10a359c: 54ffff81     	b.ne	 <L76>
 10a35a0: 17ffffcc     	b	 <L66>
<L77>:
 10a35a4: 394e6feb     	ldrb	w11, [sp, #0x39b]
 10a35a8: 34000d2b     	cbz	w11,  <L84>
 10a35ac: 394d67eb     	ldrb	w11, [sp, #0x359]
 10a35b0: 35000ceb     	cbnz	w11,  <L84>
 10a35b4: 394ff7eb     	ldrb	w11, [sp, #0x3fd]
 10a35b8: 35000cab     	cbnz	w11,  <L84>
 10a35bc: 394c23eb     	ldrb	w11, [sp, #0x308]
 10a35c0: 7200057f     	tst	w11, #0x3
 10a35c4: 54000c41     	b.ne	 <L84>
 10a35c8: 9109c3ea     	add	x10, sp, #0x270
 10a35cc: 5280002b     	mov	w11, #0x1               // =1
 10a35d0: 7946d7f5     	ldrh	w21, [sp, #0x36a]
 10a35d4: 9103f14c     	add	x12, x10, #0xfc
 10a35d8: 3ccea140     	ldur	q0, [x10, #0xea]
 10a35dc: 393133eb     	strb	w11, [sp, #0xc4c]
 10a35e0: ad400981     	ldp	q1, q2, [x12]
 10a35e4: 3d801700     	str	q0, [x24, #0x50]
 10a35e8: 3cc1f180     	ldur	q0, [x12, #0x1f]
 10a35ec: ad000b01     	stp	q1, q2, [x24]
 10a35f0: 3c81f300     	stur	q0, [x24, #0x1f]
 10a35f4: 140000f7     	b	 <L102>
<L78>:
 10a35f8: 3948f74b     	ldrb	w11, [x26, #0x23d]
 10a35fc: 34000a8b     	cbz	w11,  <L84>
 10a3600: 394ff7eb     	ldrb	w11, [sp, #0x3fd]
 10a3604: 34000a4b     	cbz	w11,  <L84>
 10a3608: 394d67eb     	ldrb	w11, [sp, #0x359]
 10a360c: 35000a0b     	cbnz	w11,  <L84>
 10a3610: 394e6feb     	ldrb	w11, [sp, #0x39b]
 10a3614: 350009cb     	cbnz	w11,  <L84>
 10a3618: 394c23eb     	ldrb	w11, [sp, #0x308]
 10a361c: 7200057f     	tst	w11, #0x3
 10a3620: 54000961     	b.ne	 <L84>
 10a3624: 9109c3ea     	add	x10, sp, #0x270
 10a3628: 5280004c     	mov	w12, #0x2               // =2
 10a362c: 9104b14b     	add	x11, x10, #0x12c
 10a3630: 9104f94a     	add	x10, x10, #0x13e
 10a3634: 393133ec     	strb	w12, [sp, #0xc4c]
 10a3638: 3dc00160     	ldr	q0, [x11]
 10a363c: ad410941     	ldp	q1, q2, [x10, #0x20]
 10a3640: 3d801700     	str	q0, [x24, #0x50]
 10a3644: 3cc3f140     	ldur	q0, [x10, #0x3f]
 10a3648: ad010b01     	stp	q1, q2, [x24, #0x20]
 10a364c: 3c83f300     	stur	q0, [x24, #0x3f]
 10a3650: ad400540     	ldp	q0, q1, [x10]
 10a3654: 14000073     	b	 <L89>
<L79>:
 10a3658: f94143e5     	ldr	x5, [sp, #0x280]
 10a365c: f94147e6     	ldr	x6, [sp, #0x288]
 10a3660: 913303e0     	add	x0, sp, #0xcc0
 10a3664: 9109c3e4     	add	x4, sp, #0x270
 10a3668: aa1303e1     	mov	x1, x19
 10a366c: 2a1403e7     	mov	w7, w20
 10a3670: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10a3674: 790003f1     	strh	w17, [sp]
 10a3678: 94000975     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10a367c: 7959a3e8     	ldrh	w8, [sp, #0xcd0]
 10a3680: 3500c1a8     	cbnz	w8,  <L162>
 10a3684: f94053e8     	ldr	x8, [sp, #0xa0]
 10a3688: f94663f4     	ldr	x20, [sp, #0xcc0]
 10a368c: aa1303e0     	mov	x0, x19
 10a3690: f94667f5     	ldr	x21, [sp, #0xcc8]
 10a3694: 39400101     	ldrb	w1, [x8]
 10a3698: 94000940     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 10a369c: 6f00e400     	movi	v0.2d, #0000000000000000
 10a36a0: 390002ff     	strb	wzr, [x23]
<L80>:
 10a36a4: 911083e8     	add	x8, sp, #0x420
 10a36a8: 3d81f500     	str	q0, [x8, #0x7d0]
 10a36ac: 3d81f900     	str	q0, [x8, #0x7e0]
 10a36b0: 3d81fd00     	str	q0, [x8, #0x7f0]
 10a36b4: 3d820100     	str	q0, [x8, #0x800]
 10a36b8: 3d820500     	str	q0, [x8, #0x810]
<L81>:
 10a36bc: f9406be8     	ldr	x8, [sp, #0xd0]
 10a36c0: 7900211f     	strh	wzr, [x8, #0x10]
 10a36c4: a9005514     	stp	x20, x21, [x8]
 10a36c8: 17fffca1     	b	 <L6>
<L82>:
 10a36cc: 394d67e8     	ldrb	w8, [sp, #0x359]
 10a36d0: 350003c8     	cbnz	w8,  <L83>
 10a36d4: 394e6fe8     	ldrb	w8, [sp, #0x39b]
 10a36d8: 35000388     	cbnz	w8,  <L83>
 10a36dc: 394ff7e8     	ldrb	w8, [sp, #0x3fd]
 10a36e0: 35000348     	cbnz	w8,  <L83>
 10a36e4: 394c23e8     	ldrb	w8, [sp, #0x308]
 10a36e8: 12000508     	and	w8, w8, #0x3
 10a36ec: 7100051f     	cmp	w8, #0x1
 10a36f0: 540002c1     	b.ne	 <L83>
 10a36f4: 7945a3e8     	ldrh	w8, [sp, #0x2d0]
 10a36f8: 6b0b011f     	cmp	w8, w11
 10a36fc: 54000261     	b.ne	 <L83>
 10a3700: 9115b3e2     	add	x2, sp, #0x56c
 10a3704: 912fc3e3     	add	x3, sp, #0xbf0
 10a3708: aa1303e0     	mov	x0, x19
 10a370c: aa1703e1     	mov	x1, x23
 10a3710: 94000bb8     	bl	 <ServerHandshake.encapsulateHybrid>
 10a3714: 72003c1f     	tst	w0, #0xffff
 10a3718: 5400be21     	b.ne	 <L164>
 10a371c: 52800068     	mov	w8, #0x3                // =3
 10a3720: 9109c3e9     	add	x9, sp, #0x270
 10a3724: 3dc002e0     	ldr	q0, [x23]
 10a3728: b8462129     	ldur	w9, [x9, #0x62]
 10a372c: 393133e8     	strb	w8, [sp, #0xc4c]
 10a3730: 7945afe8     	ldrh	w8, [sp, #0x2d6]
 10a3734: 7945a3f5     	ldrh	w21, [sp, #0x2d0]
 10a3738: 3d801700     	str	q0, [x24, #0x50]
 10a373c: b90c53e9     	str	w9, [sp, #0xc50]
 10a3740: 7918abe8     	strh	w8, [sp, #0xc54]
 10a3744: 140000a1     	b	 <L101>
<L83>:
 10a3748: 6f00e400     	movi	v0.2d, #0000000000000000
<L84>:
 10a374c: d0fffb48     	adrp	x8, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10a3750: 913de108     	add	x8, x8, #0xf78
 10a3754: 52800549     	mov	w9, #0x2a               // =42
 10a3758: 3dc00101     	ldr	q1, [x8]
 10a375c: 3d820720     	str	q0, [x25, #0x810]
 10a3760: 3d820320     	str	q0, [x25, #0x800]
 10a3764: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a3768: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a376c: 3d81f720     	str	q0, [x25, #0x7d0]
 10a3770: f9000949     	str	x9, [x10, #0x10]
 10a3774: 3d800141     	str	q1, [x10]
 10a3778: 17fffc75     	b	 <L6>
<L85>:
 10a377c: 9109c3e8     	add	x8, sp, #0x270
 10a3780: 9101a117     	add	x23, x8, #0x68
 10a3784: 14000073     	b	 <L100>
<L86>:
 10a3788: aa1703fa     	mov	x26, x23
 10a378c: 911083f9     	add	x25, sp, #0x420
 10a3790: 913143f8     	add	x24, sp, #0xc50
 10a3794: 394d67ea     	ldrb	w10, [sp, #0x359]
 10a3798: 35ffe58a     	cbnz	w10,  <L64>
<L87>:
 10a379c: 394e6fea     	ldrb	w10, [sp, #0x39b]
 10a37a0: 340001ea     	cbz	w10,  <L88>
 10a37a4: 9109c3ec     	add	x12, sp, #0x270
 10a37a8: 5280002a     	mov	w10, #0x1               // =1
 10a37ac: 9109c3eb     	add	x11, sp, #0x270
 10a37b0: 3ccea180     	ldur	q0, [x12, #0xea]
 10a37b4: 393133ea     	strb	w10, [sp, #0xc4c]
 10a37b8: 9103f16a     	add	x10, x11, #0xfc
 10a37bc: 3ccfc181     	ldur	q1, [x12, #0xfc]
 10a37c0: 7946d7f5     	ldrh	w21, [sp, #0x36a]
 10a37c4: 3d801700     	str	q0, [x24, #0x50]
 10a37c8: 3dc00540     	ldr	q0, [x10, #0x10]
 10a37cc: ad000301     	stp	q1, q0, [x24]
 10a37d0: 3cc1f141     	ldur	q1, [x10, #0x1f]
 10a37d4: 3c81f301     	stur	q1, [x24, #0x1f]
 10a37d8: 1400007e     	b	 <L102>
<L88>:
 10a37dc: 394ff7ea     	ldrb	w10, [sp, #0x3fd]
 10a37e0: 340002ca     	cbz	w10,  <L91>
 10a37e4: 3948f74a     	ldrb	w10, [x26, #0x23d]
 10a37e8: 3400028a     	cbz	w10,  <L91>
 10a37ec: 9109c3ea     	add	x10, sp, #0x270
 10a37f0: 9109c3eb     	add	x11, sp, #0x270
 10a37f4: 9104b14a     	add	x10, x10, #0x12c
 10a37f8: 9104f96b     	add	x11, x11, #0x13e
 10a37fc: 3dc00140     	ldr	q0, [x10]
 10a3800: ad410961     	ldp	q1, q2, [x11, #0x20]
 10a3804: 5280004a     	mov	w10, #0x2               // =2
 10a3808: 3d801700     	str	q0, [x24, #0x50]
 10a380c: 3cc3f160     	ldur	q0, [x11, #0x3f]
 10a3810: ad010b01     	stp	q1, q2, [x24, #0x20]
 10a3814: 3c83f300     	stur	q0, [x24, #0x3f]
 10a3818: ad400560     	ldp	q0, q1, [x11]
 10a381c: 393133ea     	strb	w10, [sp, #0xc4c]
<L89>:
 10a3820: 79475bf5     	ldrh	w21, [sp, #0x3ac]
 10a3824: ad000700     	stp	q0, q1, [x24]
 10a3828: 1400006a     	b	 <L102>
<L90>:
 10a382c: 9109c3e8     	add	x8, sp, #0x270
 10a3830: 91020117     	add	x23, x8, #0x80
 10a3834: 14000047     	b	 <L100>
<L91>:
 10a3838: 90fffb2a     	adrp	x10, 0x1007000 <__anon_13230+0x8>
 10a383c: 7957314a     	ldrh	w10, [x10, #0xb98]
 10a3840: 7104015f     	cmp	w10, #0x100
 10a3844: 54000283     	b.lo	 <L92>
 10a3848: 120015ab     	and	w11, w13, #0x3f
 10a384c: 9240094a     	and	x10, x10, #0x7
 10a3850: 1aca256a     	lsr	w10, w11, w10
 10a3854: 3600020a     	tbz	w10, #0x0,  <L92>
 10a3858: f94143e5     	ldr	x5, [sp, #0x280]
 10a385c: f94147e6     	ldr	x6, [sp, #0x288]
 10a3860: 913363e0     	add	x0, sp, #0xcd8
 10a3864: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10a3868: 528003a9     	mov	w9, #0x1d               // =29
 10a386c: 9109c3e4     	add	x4, sp, #0x270
 10a3870: aa1303e1     	mov	x1, x19
 10a3874: 2a1403e7     	mov	w7, w20
 10a3878: 790003e9     	strh	w9, [sp]
 10a387c: 940008f4     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10a3880: 7959d3e8     	ldrh	w8, [sp, #0xce8]
 10a3884: 35001a48     	cbnz	w8,  <L109>
 10a3888: f9466ff4     	ldr	x20, [sp, #0xcd8]
 10a388c: f94673f5     	ldr	x21, [sp, #0xce0]
 10a3890: 14000017     	b	 <L93>
<L92>:
 10a3894: 90fffb2a     	adrp	x10, 0x1007000 <__anon_13230+0x8>
 10a3898: 7957394a     	ldrh	w10, [x10, #0xb9c]
 10a389c: 7104015f     	cmp	w10, #0x100
 10a38a0: 5400a2c3     	b.lo	 <L150>
 10a38a4: 120015ab     	and	w11, w13, #0x3f
 10a38a8: 9240094a     	and	x10, x10, #0x7
 10a38ac: 1aca256a     	lsr	w10, w11, w10
 10a38b0: 3600a24a     	tbz	w10, #0x0,  <L150>
 10a38b4: f94143e5     	ldr	x5, [sp, #0x280]
 10a38b8: f94147e6     	ldr	x6, [sp, #0x288]
 10a38bc: 9133c3e0     	add	x0, sp, #0xcf0
 10a38c0: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10a38c4: 528002e9     	mov	w9, #0x17               // =23
 10a38c8: 9109c3e4     	add	x4, sp, #0x270
 10a38cc: aa1303e1     	mov	x1, x19
 10a38d0: 2a1403e7     	mov	w7, w20
 10a38d4: 790003e9     	strh	w9, [sp]
 10a38d8: 940008dd     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10a38dc: 795a03e8     	ldrh	w8, [sp, #0xd00]
 10a38e0: 35001768     	cbnz	w8,  <L109>
 10a38e4: f9467bf4     	ldr	x20, [sp, #0xcf0]
 10a38e8: f9467ff5     	ldr	x21, [sp, #0xcf8]
<L93>:
 10a38ec: f94053e8     	ldr	x8, [sp, #0xa0]
 10a38f0: aa1303e0     	mov	x0, x19
 10a38f4: 39400101     	ldrb	w1, [x8]
 10a38f8: 940008a8     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 10a38fc: 6f00e400     	movi	v0.2d, #0000000000000000
 10a3900: 3900035f     	strb	wzr, [x26]
 10a3904: 3d81f720     	str	q0, [x25, #0x7d0]
 10a3908: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a390c: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a3910: 3d820320     	str	q0, [x25, #0x800]
 10a3914: 3d820720     	str	q0, [x25, #0x810]
 10a3918: 17ffff69     	b	 <L81>
<L94>:
 10a391c: 9109c3e8     	add	x8, sp, #0x270
 10a3920: 9101a117     	add	x23, x8, #0x68
 10a3924: 1400000a     	b	 <L99>
<L95>:
 10a3928: aa1f03ea     	mov	x10, xzr
 10a392c: aa1f03f4     	mov	x20, xzr
<L96>:
 10a3930: eb0d015f     	cmp	x10, x13
 10a3934: 54ffa780     	b.eq	 <L31>
<L97>:
 10a3938: 528002e9     	mov	w9, #0x17               // =23
 10a393c: 79002109     	strh	w9, [x8, #0x10]
 10a3940: 17fffc03     	b	 <L6>
<L98>:
 10a3944: 9109c3e8     	add	x8, sp, #0x270
 10a3948: 91020117     	add	x23, x8, #0x80
<L99>:
 10a394c: 52823da1     	mov	w1, #0x11ed             // =4589
<L100>:
 10a3950: a9400ee2     	ldp	x2, x3, [x23]
 10a3954: 528952a8     	mov	w8, #0x4a95             // =19093
 10a3958: 9115b3e9     	add	x9, sp, #0x56c
 10a395c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3960: 52800a0a     	mov	w10, #0x50              // =80
 10a3964: 913ac000     	add	x0, x0, #0xeb0
 10a3968: 8b080264     	add	x4, x19, x8
 10a396c: b27f0125     	orr	x5, x9, #0x2
 10a3970: 912fc3e7     	add	x7, sp, #0xbf0
 10a3974: 5280d026     	mov	w6, #0x681              // =1665
 10a3978: f90003ea     	str	x10, [sp]
 10a397c: 94000b3b     	bl	 <hybrid_kex.encapsulate>
 10a3980: 797da3e8     	ldrh	w8, [sp, #0x1ed0]
 10a3984: 3500a1e8     	cbnz	w8,  <L154>
 10a3988: b95ebbe8     	ldr	w8, [sp, #0x1eb8]
 10a398c: b95ecbe9     	ldr	w9, [sp, #0x1ec8]
 10a3990: 5280006a     	mov	w10, #0x3               // =3
 10a3994: 3dc002e0     	ldr	q0, [x23]
 10a3998: 794022f5     	ldrh	w21, [x23, #0x10]
 10a399c: 3932f3ea     	strb	w10, [sp, #0xcbc]
 10a39a0: 12002908     	and	w8, w8, #0x7ff
 10a39a4: 12001929     	and	w9, w9, #0x7f
 10a39a8: 393133ea     	strb	w10, [sp, #0xc4c]
 10a39ac: 790adbe8     	strh	w8, [sp, #0x56c]
 10a39b0: b84122e8     	ldur	w8, [x23, #0x12]
 10a39b4: 393103e9     	strb	w9, [sp, #0xc40]
 10a39b8: 79402ee9     	ldrh	w9, [x23, #0x16]
 10a39bc: 3d801700     	str	q0, [x24, #0x50]
 10a39c0: b90c53e8     	str	w8, [sp, #0xc50]
 10a39c4: 7918abe9     	strh	w9, [sp, #0xc54]
<L101>:
 10a39c8: f9405fe8     	ldr	x8, [sp, #0xb8]
 10a39cc: f9404fe9     	ldr	x9, [sp, #0x98]
<L102>:
 10a39d0: 397133ea     	ldrb	w10, [sp, #0xc4c]
 10a39d4: 2a0a03f6     	mov	w22, w10
 10a39d8: 1200054a     	and	w10, w10, #0x3
 10a39dc: 7100055f     	cmp	w10, #0x1
 10a39e0: 5400014c     	b.gt	 <L103>
 10a39e4: 3500034a     	cbnz	w10,  <L104>
 10a39e8: 528956aa     	mov	w10, #0x4ab5            // =19125
 10a39ec: 528003ab     	mov	w11, #0x1d              // =29
 10a39f0: 391d5b1f     	strb	wzr, [x24, #0x756]
 10a39f4: 8b0a026a     	add	x10, x19, x10
 10a39f8: 79130e6b     	strh	w11, [x19, #0x986]
 10a39fc: ad400540     	ldp	q0, q1, [x10]
 10a3a00: ad068700     	stp	q0, q1, [x24, #0xd0]
 10a3a04: 1400002a     	b	 <L106>
<L103>:
 10a3a08: 7100095f     	cmp	w10, #0x2
 10a3a0c: 540003a1     	b.ne	 <L105>
 10a3a10: 52896cca     	mov	w10, #0x4b66            // =19302
 10a3a14: 5280030b     	mov	w11, #0x18              // =24
 10a3a18: 8b0a026a     	add	x10, x19, x10
 10a3a1c: 79130e6b     	strh	w11, [x19, #0x986]
 10a3a20: 5280004b     	mov	w11, #0x2               // =2
 10a3a24: ad420540     	ldp	q0, q1, [x10, #0x40]
 10a3a28: 391d5b0b     	strb	w11, [x24, #0x756]
 10a3a2c: 3941814b     	ldrb	w11, [x10, #0x60]
 10a3a30: ad088700     	stp	q0, q1, [x24, #0x110]
 10a3a34: ad400540     	ldp	q0, q1, [x10]
 10a3a38: 393603eb     	strb	w11, [sp, #0xd80]
 10a3a3c: ad068700     	stp	q0, q1, [x24, #0xd0]
 10a3a40: ad410940     	ldp	q0, q2, [x10, #0x20]
 10a3a44: ad078b00     	stp	q0, q2, [x24, #0xf0]
 10a3a48: 14000019     	b	 <L106>
<L104>:
 10a3a4c: 52895eaa     	mov	w10, #0x4af5            // =19189
 10a3a50: 528002eb     	mov	w11, #0x17              // =23
 10a3a54: 8b0a026a     	add	x10, x19, x10
 10a3a58: 79130e6b     	strh	w11, [x19, #0x986]
 10a3a5c: 5280002b     	mov	w11, #0x1               // =1
 10a3a60: ad410540     	ldp	q0, q1, [x10, #0x20]
 10a3a64: 391d5b0b     	strb	w11, [x24, #0x756]
 10a3a68: 3941014b     	ldrb	w11, [x10, #0x40]
 10a3a6c: ad078700     	stp	q0, q1, [x24, #0xf0]
 10a3a70: ad400141     	ldp	q1, q0, [x10]
 10a3a74: 393583eb     	strb	w11, [sp, #0xd60]
 10a3a78: ad068301     	stp	q1, q0, [x24, #0xd0]
 10a3a7c: 1400000c     	b	 <L106>
<L105>:
 10a3a80: 52800068     	mov	w8, #0x3                // =3
 10a3a84: 9115b3e1     	add	x1, sp, #0x56c
 10a3a88: 5280d082     	mov	w2, #0x684              // =1668
 10a3a8c: 391d5b08     	strb	w8, [x24, #0x756]
 10a3a90: 913483e8     	add	x8, sp, #0xd20
 10a3a94: b27f0100     	orr	x0, x8, #0x2
 10a3a98: 79130e75     	strh	w21, [x19, #0x986]
 10a3a9c: 791a43f5     	strh	w21, [sp, #0xd20]
 10a3aa0: 940503bd     	bl	 <memcpy>
 10a3aa4: f9404fe9     	ldr	x9, [sp, #0x98]
 10a3aa8: f9405fe8     	ldr	x8, [sp, #0xb8]
<L106>:
 10a3aac: 3955826a     	ldrb	w10, [x19, #0x560]
 10a3ab0: 52894eab     	mov	w11, #0x4a75            // =19061
 10a3ab4: d1001522     	sub	x2, x9, #0x5
 10a3ab8: 8b0b0269     	add	x9, x19, x11
 10a3abc: f9003bfa     	str	x26, [sp, #0x70]
 10a3ac0: 3400062a     	cbz	w10,  <L108>
 10a3ac4: ad400520     	ldp	q0, q1, [x9]
 10a3ac8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3acc: f94147f7     	ldr	x23, [sp, #0x288]
 10a3ad0: f94143e4     	ldr	x4, [sp, #0x280]
 10a3ad4: 914007e3     	add	x3, sp, #0x1, lsl #12   // =0x1000
 10a3ad8: 79530669     	ldrh	w9, [x19, #0x982]
 10a3adc: 910f6000     	add	x0, x0, #0x3d8
 10a3ae0: 91001501     	add	x1, x8, #0x5
 10a3ae4: 3d81db00     	str	q0, [x24, #0x760]
 10a3ae8: 910ec063     	add	x3, x3, #0x3b0
 10a3aec: 913483e7     	add	x7, sp, #0xd20
 10a3af0: 3d81df01     	str	q1, [x24, #0x770]
 10a3af4: aa1703e5     	mov	x5, x23
 10a3af8: 2a1403e6     	mov	w6, w20
 10a3afc: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 10a3b00: 790003e9     	strh	w9, [sp]
 10a3b04: 910f6318     	add	x24, x24, #0x3d8
 10a3b08: 94000754     	bl	 <server_hello.encodeWithKeyShareAndPsk>
 10a3b0c: 7967d3e8     	ldrh	w8, [sp, #0x13e8]
 10a3b10: 350005e8     	cbnz	w8,  <L109>
<L107>:
 10a3b14: a9406b18     	ldp	x24, x26, [x24]
 10a3b18: 528002cc     	mov	w12, #0x16              // =22
 10a3b1c: f9405fe9     	ldr	x9, [sp, #0xb8]
 10a3b20: f9406be8     	ldr	x8, [sp, #0xd0]
 10a3b24: 2a1503ed     	mov	w13, w21
 10a3b28: f9404fea     	ldr	x10, [sp, #0x98]
 10a3b2c: 5ac00b4b     	rev	w11, w26
 10a3b30: 3900012c     	strb	w12, [x9]
 10a3b34: 5280606c     	mov	w12, #0x303             // =771
 10a3b38: 53107d6b     	lsr	w11, w11, #16
 10a3b3c: 91001755     	add	x21, x26, #0x5
 10a3b40: 7800112c     	sturh	w12, [x9, #0x1]
 10a3b44: 7800312b     	sturh	w11, [x9, #0x3]
 10a3b48: b4000637     	cbz	x23,  <L111>
 10a3b4c: 3966026b     	ldrb	w11, [x19, #0x980]
 10a3b50: 350005eb     	cbnz	w11,  <L111>
 10a3b54: cb15014a     	sub	x10, x10, x21
 10a3b58: f100155f     	cmp	x10, #0x5
 10a3b5c: 54000468     	b.hi	 <L110>
 10a3b60: 6f00e400     	movi	v0.2d, #0000000000000000
 10a3b64: 528000a9     	mov	w9, #0x5                // =5
 10a3b68: 3d820720     	str	q0, [x25, #0x810]
 10a3b6c: 3d820320     	str	q0, [x25, #0x800]
 10a3b70: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a3b74: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a3b78: 3d81f720     	str	q0, [x25, #0x7d0]
 10a3b7c: 79002109     	strh	w9, [x8, #0x10]
 10a3b80: 17fffb73     	b	 <L6>
<L108>:
 10a3b84: ad400520     	ldp	q0, q1, [x9]
 10a3b88: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3b8c: f94147f7     	ldr	x23, [sp, #0x288]
 10a3b90: f94143e4     	ldr	x4, [sp, #0x280]
 10a3b94: 914007e3     	add	x3, sp, #0x1, lsl #12   // =0x1000
 10a3b98: 91106000     	add	x0, x0, #0x418
 10a3b9c: 91001501     	add	x1, x8, #0x5
 10a3ba0: 910fc063     	add	x3, x3, #0x3f0
 10a3ba4: 3d81eb00     	str	q0, [x24, #0x7a0]
 10a3ba8: 913483e7     	add	x7, sp, #0xd20
 10a3bac: aa1703e5     	mov	x5, x23
 10a3bb0: 3d81ef01     	str	q1, [x24, #0x7b0]
 10a3bb4: 2a1403e6     	mov	w6, w20
 10a3bb8: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 10a3bbc: 91106318     	add	x24, x24, #0x418
 10a3bc0: 940006a3     	bl	 <server_hello.encodeWithKeyShare>
 10a3bc4: 796853e8     	ldrh	w8, [sp, #0x1428]
 10a3bc8: 34fffa68     	cbz	w8,  <L107>
<L109>:
 10a3bcc: 6f00e400     	movi	v0.2d, #0000000000000000
 10a3bd0: 3d820720     	str	q0, [x25, #0x810]
 10a3bd4: 3d820320     	str	q0, [x25, #0x800]
 10a3bd8: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a3bdc: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a3be0: 3d81f720     	str	q0, [x25, #0x7d0]
 10a3be4: 140004bb     	b	 <L163>
<L110>:
 10a3be8: 8b150129     	add	x9, x9, x21
 10a3bec: 5280028a     	mov	w10, #0x14              // =20
 10a3bf0: 5280606b     	mov	w11, #0x303             // =771
 10a3bf4: 72a0200b     	movk	w11, #0x100, lsl #16
 10a3bf8: 3900012a     	strb	w10, [x9]
 10a3bfc: 5280002a     	mov	w10, #0x1               // =1
 10a3c00: b800112b     	stur	w11, [x9, #0x1]
 10a3c04: 91002f55     	add	x21, x26, #0xb
 10a3c08: 3900152a     	strb	w10, [x9, #0x5]
<L111>:
 10a3c0c: 120006ca     	and	w10, w22, #0x3
 10a3c10: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 10a3c14: 7100055f     	cmp	w10, #0x1
 10a3c18: 91124129     	add	x9, x9, #0x490
 10a3c1c: 5400030c     	b.gt	 <L112>
 10a3c20: 350006ea     	cbnz	w10,  <L113>
 10a3c24: 913143ec     	add	x12, sp, #0xc50
 10a3c28: 528952aa     	mov	w10, #0x4a95            // =19093
 10a3c2c: f9462be8     	ldr	x8, [sp, #0xc50]
 10a3c30: 3dc01580     	ldr	q0, [x12, #0x50]
 10a3c34: 8b0a026a     	add	x10, x19, x10
 10a3c38: f840618b     	ldur	x11, [x12, #0x6]
 10a3c3c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3c40: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a3c44: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a3c48: 3d821180     	str	q0, [x12, #0x840]
 10a3c4c: ad400540     	ldp	q0, q1, [x10]
 10a3c50: 9112c000     	add	x0, x0, #0x4b0
 10a3c54: 91124021     	add	x1, x1, #0x490
 10a3c58: 91110042     	add	x2, x2, #0x440
 10a3c5c: 792943ed     	strh	w13, [sp, #0x14a0]
 10a3c60: f8012128     	stur	x8, [x9, #0x12]
 10a3c64: f90a57eb     	str	x11, [sp, #0x14a8]
 10a3c68: ad010520     	stp	q0, q1, [x9, #0x20]
 10a3c6c: 97ff6083     	bl	 <x25519.sharedSecret>
 10a3c70: 72003c1f     	tst	w0, #0xffff
 10a3c74: 54000700     	b.eq	 <L114>
 10a3c78: 14000450     	b	 <L153>
<L112>:
 10a3c7c: 7100095f     	cmp	w10, #0x2
 10a3c80: 540006e1     	b.ne	 <L115>
 10a3c84: 913143ea     	add	x10, sp, #0xc50
 10a3c88: 528966c8     	mov	w8, #0x4b36             // =19254
 10a3c8c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3c90: ad408941     	ldp	q1, q2, [x10, #0x10]
 10a3c94: 3dc01540     	ldr	q0, [x10, #0x50]
 10a3c98: 8b080268     	add	x8, x19, x8
 10a3c9c: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a3ca0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a3ca4: 3d802d20     	str	q0, [x9, #0xb0]
 10a3ca8: 3dc00140     	ldr	q0, [x10]
 10a3cac: 9116c000     	add	x0, x0, #0x5b0
 10a3cb0: 3c8d2121     	stur	q1, [x9, #0xd2]
 10a3cb4: 3dc00d41     	ldr	q1, [x10, #0x30]
 10a3cb8: 91150021     	add	x1, x1, #0x540
 10a3cbc: 3c812360     	stur	q0, [x27, #0x12]
 10a3cc0: 91110042     	add	x2, x2, #0x440
 10a3cc4: 3c8f2121     	stur	q1, [x9, #0xf2]
 10a3cc8: 3cc3f141     	ldur	q1, [x10, #0x3f]
 10a3ccc: 3c8e2122     	stur	q2, [x9, #0xe2]
 10a3cd0: 3c851361     	stur	q1, [x27, #0x51]
 10a3cd4: ad408500     	ldp	q0, q1, [x8, #0x10]
 10a3cd8: 792aa3ed     	strh	w13, [sp, #0x1550]
 10a3cdc: ad040760     	stp	q0, q1, [x27, #0x80]
 10a3ce0: 3dc00101     	ldr	q1, [x8]
 10a3ce4: 3d801f61     	str	q1, [x27, #0x70]
 10a3ce8: 94000486     	bl	 <p384.sharedSecret>
 10a3cec: 72003c1f     	tst	w0, #0xffff
 10a3cf0: 54008641     	b.ne	 <L153>
 10a3cf4: 52800617     	mov	w23, #0x30              // =48
 10a3cf8: 14000021     	b	 <L116>
<L113>:
 10a3cfc: 913143ea     	add	x10, sp, #0xc50
 10a3d00: 52895aa8     	mov	w8, #0x4ad5             // =19157
 10a3d04: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3d08: 3dc01540     	ldr	q0, [x10, #0x50]
 10a3d0c: ad400941     	ldp	q1, q2, [x10]
 10a3d10: 8b080268     	add	x8, x19, x8
 10a3d14: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a3d18: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a3d1c: 3d801120     	str	q0, [x9, #0x40]
 10a3d20: 3cc1f140     	ldur	q0, [x10, #0x1f]
 10a3d24: 91148000     	add	x0, x0, #0x520
 10a3d28: 3c852121     	stur	q1, [x9, #0x52]
 10a3d2c: 91134021     	add	x1, x1, #0x4d0
 10a3d30: 91110042     	add	x2, x2, #0x440
 10a3d34: 3c862122     	stur	q2, [x9, #0x62]
 10a3d38: 3c871120     	stur	q0, [x9, #0x71]
 10a3d3c: ad400101     	ldp	q1, q0, [x8]
 10a3d40: 7929c3ed     	strh	w13, [sp, #0x14e0]
 10a3d44: ad048121     	stp	q1, q0, [x9, #0x90]
 10a3d48: 940004a9     	bl	 <p256.sharedSecret>
 10a3d4c: 72003c1f     	tst	w0, #0xffff
 10a3d50: 54008341     	b.ne	 <L153>
<L114>:
 10a3d54: 52800417     	mov	w23, #0x20              // =32
 10a3d58: 14000009     	b	 <L116>
<L115>:
 10a3d5c: 397103e9     	ldrb	w9, [sp, #0xc40]
 10a3d60: 92401937     	and	x23, x9, #0x7f
 10a3d64: 34007b97     	cbz	w23,  <L148>
 10a3d68: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3d6c: 912fc3e1     	add	x1, sp, #0xbf0
 10a3d70: aa1703e2     	mov	x2, x23
 10a3d74: 91110000     	add	x0, x0, #0x440
 10a3d78: 94050307     	bl	 <memcpy>
<L116>:
 10a3d7c: a94c07e8     	ldp	x8, x1, [sp, #0xc0]
 10a3d80: 910c4276     	add	x22, x19, #0x310
 10a3d84: 3943c269     	ldrb	w9, [x19, #0xf0]
 10a3d88: 5282604a     	mov	w10, #0x1302            // =4866
 10a3d8c: f9004ff7     	str	x23, [sp, #0x98]
 10a3d90: 6b0a029f     	cmp	w20, w10
 10a3d94: 9119baca     	add	x10, x22, #0x66e
 10a3d98: f90037f5     	str	x21, [sp, #0x68]
 10a3d9c: f90043ea     	str	x10, [sp, #0x80]
 10a3da0: 54000261     	b.ne	 <L117>
 10a3da4: 340003c9     	cbz	w9,  <L118>
 10a3da8: ad450660     	ldp	q0, q1, [x19, #0xa0]
 10a3dac: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 10a3db0: 911b0129     	add	x9, x9, #0x6c0
 10a3db4: ad110760     	stp	q0, q1, [x27, #0x220]
 10a3db8: ad460a60     	ldp	q0, q2, [x19, #0xc0]
 10a3dbc: ad120b60     	stp	q0, q2, [x27, #0x240]
 10a3dc0: ad430261     	ldp	q1, q0, [x19, #0x60]
 10a3dc4: ad0f0361     	stp	q1, q0, [x27, #0x1e0]
 10a3dc8: ad440262     	ldp	q2, q0, [x19, #0x80]
 10a3dcc: ad100362     	stp	q2, q0, [x27, #0x200]
 10a3dd0: ad410261     	ldp	q1, q0, [x19, #0x20]
 10a3dd4: ad0d0361     	stp	q1, q0, [x27, #0x1a0]
 10a3dd8: ad420262     	ldp	q2, q0, [x19, #0x40]
 10a3ddc: ad0e0362     	stp	q2, q0, [x27, #0x1c0]
 10a3de0: ad400261     	ldp	q1, q0, [x19]
 10a3de4: ad0c0361     	stp	q1, q0, [x27, #0x180]
 10a3de8: 1400000f     	b	 <L119>
<L117>:
 10a3dec: 34000c89     	cbz	w9,  <L124>
 10a3df0: ad418660     	ldp	q0, q1, [x19, #0x30]
 10a3df4: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 10a3df8: 91234129     	add	x9, x9, #0x8d0
 10a3dfc: ad1e0760     	stp	q0, q1, [x27, #0x3c0]
 10a3e00: ad428262     	ldp	q2, q0, [x19, #0x50]
 10a3e04: 3dc00261     	ldr	q1, [x19]
 10a3e08: ad1f0362     	stp	q2, q0, [x27, #0x3e0]
 10a3e0c: ad408e60     	ldp	q0, q3, [x19, #0x10]
 10a3e10: ad1c8361     	stp	q1, q0, [x27, #0x390]
 10a3e14: 3d80ef63     	str	q3, [x27, #0x3b0]
 10a3e18: 1400005b     	b	 <L125>
<L118>:
 10a3e1c: 90fffb29     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 10a3e20: 91238129     	add	x9, x9, #0x8e0
<L119>:
 10a3e24: ad450520     	ldp	q0, q1, [x9, #0xa0]
 10a3e28: ad0a0760     	stp	q0, q1, [x27, #0x140]
 10a3e2c: ad460920     	ldp	q0, q2, [x9, #0xc0]
 10a3e30: ad0b0b60     	stp	q0, q2, [x27, #0x160]
 10a3e34: ad430121     	ldp	q1, q0, [x9, #0x60]
 10a3e38: ad080361     	stp	q1, q0, [x27, #0x100]
 10a3e3c: ad440122     	ldp	q2, q0, [x9, #0x80]
 10a3e40: ad090362     	stp	q2, q0, [x27, #0x120]
 10a3e44: ad410121     	ldp	q1, q0, [x9, #0x20]
 10a3e48: ad060361     	stp	q1, q0, [x27, #0xc0]
 10a3e4c: ad420122     	ldp	q2, q0, [x9, #0x40]
 10a3e50: ad070362     	stp	q2, q0, [x27, #0xe0]
 10a3e54: ad400121     	ldp	q1, q0, [x9]
 10a3e58: 3945c369     	ldrb	w9, [x27, #0x170]
 10a3e5c: ad050361     	stp	q1, q0, [x27, #0xa0]
 10a3e60: 34000289     	cbz	w9,  <L120>
 10a3e64: 8b09010a     	add	x10, x8, x9
 10a3e68: f102015f     	cmp	x10, #0x80
 10a3e6c: 54000223     	b.lo	 <L120>
 10a3e70: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 10a3e74: 52801008     	mov	w8, #0x80               // =128
 10a3e78: 9117814a     	add	x10, x10, #0x5e0
 10a3e7c: cb090119     	sub	x25, x8, x9
 10a3e80: 91014154     	add	x20, x10, #0x50
 10a3e84: aa1903e2     	mov	x2, x25
 10a3e88: 8b090280     	add	x0, x20, x9
 10a3e8c: 940502c2     	bl	 <memcpy>
 10a3e90: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3e94: aa1403e1     	mov	x1, x20
 10a3e98: 91178000     	add	x0, x0, #0x5e0
 10a3e9c: 97ffea16     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 10a3ea0: a94c07e8     	ldp	x8, x1, [sp, #0xc0]
 10a3ea4: 2a1f03e9     	mov	w9, wzr
 10a3ea8: 3905c37f     	strb	wzr, [x27, #0x170]
 10a3eac: 14000002     	b	 <L121>
<L120>:
 10a3eb0: aa1f03f9     	mov	x25, xzr
<L121>:
 10a3eb4: b279032a     	orr	x10, x25, #0x80
 10a3eb8: eb08015f     	cmp	x10, x8
 10a3ebc: 54000168     	b.hi	 <L123>
<L122>:
 10a3ec0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3ec4: 8b190021     	add	x1, x1, x25
 10a3ec8: 91178000     	add	x0, x0, #0x5e0
 10a3ecc: 97ffea0a     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 10a3ed0: a94c07e8     	ldp	x8, x1, [sp, #0xc0]
 10a3ed4: 91040329     	add	x9, x25, #0x100
 10a3ed8: 91020339     	add	x25, x25, #0x80
 10a3edc: eb08013f     	cmp	x9, x8
 10a3ee0: 54ffff09     	b.ls	 <L122>
 10a3ee4: 3945c369     	ldrb	w9, [x27, #0x170]
<L123>:
 10a3ee8: aa1603f7     	mov	x23, x22
 10a3eec: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 10a3ef0: cb190115     	sub	x21, x8, x25
 10a3ef4: 8b190021     	add	x1, x1, x25
 10a3ef8: 9117814a     	add	x10, x10, #0x5e0
 10a3efc: aa1503e2     	mov	x2, x21
 10a3f00: aa0803f6     	mov	x22, x8
 10a3f04: 91014154     	add	x20, x10, #0x50
 10a3f08: 8b294280     	add	x0, x20, w9, uxtw
 10a3f0c: 940502a2     	bl	 <memcpy>
 10a3f10: f94af3e9     	ldr	x9, [sp, #0x15e0]
 10a3f14: 3945c368     	ldrb	w8, [x27, #0x170]
 10a3f18: f94af7ea     	ldr	x10, [sp, #0x15e8]
 10a3f1c: ab160129     	adds	x9, x9, x22
 10a3f20: 0b150108     	add	w8, w8, w21
 10a3f24: 9a8a354a     	cinc	x10, x10, hs
 10a3f28: 3905c368     	strb	w8, [x27, #0x170]
 10a3f2c: f90af3e9     	str	x9, [sp, #0x15e0]
 10a3f30: f90af7ea     	str	x10, [sp, #0x15e8]
 10a3f34: 34000c28     	cbz	w8,  <L130>
 10a3f38: 8b080349     	add	x9, x26, x8
 10a3f3c: aa1703f6     	mov	x22, x23
 10a3f40: f102013f     	cmp	x9, #0x80
 10a3f44: 540026a3     	b.lo	 <L138>
 10a3f48: 52801009     	mov	w9, #0x80               // =128
 10a3f4c: 8b080280     	add	x0, x20, x8
 10a3f50: aa1803e1     	mov	x1, x24
 10a3f54: 4b080135     	sub	w21, w9, w8
 10a3f58: aa1503e2     	mov	x2, x21
 10a3f5c: 9405028e     	bl	 <memcpy>
 10a3f60: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3f64: aa1403e1     	mov	x1, x20
 10a3f68: 91178000     	add	x0, x0, #0x5e0
 10a3f6c: 97ffe9e2     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 10a3f70: 2a1f03e8     	mov	w8, wzr
 10a3f74: 3905c37f     	strb	wzr, [x27, #0x170]
 10a3f78: 14000129     	b	 <L139>
<L124>:
 10a3f7c: 90fffb29     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 10a3f80: 91214129     	add	x9, x9, #0x850
<L125>:
 10a3f84: ad428122     	ldp	q2, q0, [x9, #0x50]
 10a3f88: 3dc01123     	ldr	q3, [x9, #0x40]
 10a3f8c: ad1b8362     	stp	q2, q0, [x27, #0x370]
 10a3f90: ad400520     	ldp	q0, q1, [x9]
 10a3f94: ad190760     	stp	q0, q1, [x27, #0x320]
 10a3f98: ad410920     	ldp	q0, q2, [x9, #0x20]
 10a3f9c: 394e2369     	ldrb	w9, [x27, #0x388]
 10a3fa0: ad1a8f62     	stp	q2, q3, [x27, #0x350]
 10a3fa4: 3d80d360     	str	q0, [x27, #0x340]
 10a3fa8: 34000289     	cbz	w9,  <L126>
 10a3fac: 8b09010a     	add	x10, x8, x9
 10a3fb0: f101015f     	cmp	x10, #0x40
 10a3fb4: 54000223     	b.lo	 <L126>
 10a3fb8: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 10a3fbc: 52800808     	mov	w8, #0x40               // =64
 10a3fc0: 9121814a     	add	x10, x10, #0x860
 10a3fc4: cb090119     	sub	x25, x8, x9
 10a3fc8: 9100a157     	add	x23, x10, #0x28
 10a3fcc: aa1903e2     	mov	x2, x25
 10a3fd0: 8b0902e0     	add	x0, x23, x9
 10a3fd4: 94050270     	bl	 <memcpy>
 10a3fd8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a3fdc: aa1703e1     	mov	x1, x23
 10a3fe0: 91218000     	add	x0, x0, #0x860
 10a3fe4: 97ffe0bd     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 10a3fe8: a94c07e8     	ldp	x8, x1, [sp, #0xc0]
 10a3fec: 2a1f03e9     	mov	w9, wzr
 10a3ff0: 390e237f     	strb	wzr, [x27, #0x388]
 10a3ff4: 14000002     	b	 <L127>
<L126>:
 10a3ff8: aa1f03f9     	mov	x25, xzr
<L127>:
 10a3ffc: 9101032a     	add	x10, x25, #0x40
 10a4000: f90033f6     	str	x22, [sp, #0x60]
 10a4004: eb08015f     	cmp	x10, x8
 10a4008: 54000168     	b.hi	 <L129>
<L128>:
 10a400c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4010: 8b190021     	add	x1, x1, x25
 10a4014: 91218000     	add	x0, x0, #0x860
 10a4018: 97ffe0b0     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 10a401c: a94c07e8     	ldp	x8, x1, [sp, #0xc0]
 10a4020: 91020329     	add	x9, x25, #0x80
 10a4024: 91010339     	add	x25, x25, #0x40
 10a4028: eb08013f     	cmp	x9, x8
 10a402c: 54ffff09     	b.ls	 <L128>
 10a4030: 394e2369     	ldrb	w9, [x27, #0x388]
<L129>:
 10a4034: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 10a4038: cb190116     	sub	x22, x8, x25
 10a403c: 8b190021     	add	x1, x1, x25
 10a4040: 9121814a     	add	x10, x10, #0x860
 10a4044: aa1603e2     	mov	x2, x22
 10a4048: aa0803f7     	mov	x23, x8
 10a404c: 9100a155     	add	x21, x10, #0x28
 10a4050: 8b2942a0     	add	x0, x21, w9, uxtw
 10a4054: 94050250     	bl	 <memcpy>
 10a4058: 394e2368     	ldrb	w8, [x27, #0x388]
 10a405c: f94c43e9     	ldr	x9, [sp, #0x1880]
 10a4060: 2b160108     	adds	w8, w8, w22
 10a4064: 8b170129     	add	x9, x9, x23
 10a4068: 390e2368     	strb	w8, [x27, #0x388]
 10a406c: f90c43e9     	str	x9, [sp, #0x1880]
 10a4070: 540002a0     	b.eq	 <L131>
 10a4074: 8b080349     	add	x9, x26, x8
 10a4078: f9404ff7     	ldr	x23, [sp, #0x98]
 10a407c: f101013f     	cmp	x9, #0x40
 10a4080: 54000243     	b.lo	 <L132>
 10a4084: 52800809     	mov	w9, #0x40               // =64
 10a4088: 8b0802a0     	add	x0, x21, x8
 10a408c: aa1803e1     	mov	x1, x24
 10a4090: 4b080136     	sub	w22, w9, w8
 10a4094: aa1603e2     	mov	x2, x22
 10a4098: 9405023f     	bl	 <memcpy>
 10a409c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a40a0: aa1503e1     	mov	x1, x21
 10a40a4: 91218000     	add	x0, x0, #0x860
 10a40a8: 97ffe08c     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 10a40ac: 2a1f03e8     	mov	w8, wzr
 10a40b0: 390e237f     	strb	wzr, [x27, #0x388]
 10a40b4: 14000006     	b	 <L133>
<L130>:
 10a40b8: aa1f03f5     	mov	x21, xzr
 10a40bc: aa1703f6     	mov	x22, x23
 10a40c0: 140000d7     	b	 <L139>
<L131>:
 10a40c4: f9404ff7     	ldr	x23, [sp, #0x98]
<L132>:
 10a40c8: aa1f03f6     	mov	x22, xzr
<L133>:
 10a40cc: 910102c9     	add	x9, x22, #0x40
 10a40d0: eb1a013f     	cmp	x9, x26
 10a40d4: 54000148     	b.hi	 <L135>
<L134>:
 10a40d8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a40dc: 8b160301     	add	x1, x24, x22
 10a40e0: 91218000     	add	x0, x0, #0x860
 10a40e4: 97ffe07d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 10a40e8: 910202c8     	add	x8, x22, #0x80
 10a40ec: 910102d6     	add	x22, x22, #0x40
 10a40f0: eb1a011f     	cmp	x8, x26
 10a40f4: 54ffff29     	b.ls	 <L134>
 10a40f8: 394e2368     	ldrb	w8, [x27, #0x388]
<L135>:
 10a40fc: 8b2842a0     	add	x0, x21, w8, uxtw
 10a4100: cb160355     	sub	x21, x26, x22
 10a4104: 8b160301     	add	x1, x24, x22
 10a4108: aa1503e2     	mov	x2, x21
 10a410c: 94050222     	bl	 <memcpy>
 10a4110: 394e2368     	ldrb	w8, [x27, #0x388]
 10a4114: f94c43e9     	ldr	x9, [sp, #0x1880]
 10a4118: 3955826a     	ldrb	w10, [x19, #0x560]
 10a411c: 0b150108     	add	w8, w8, w21
 10a4120: 8b1a0129     	add	x9, x9, x26
 10a4124: 390e2368     	strb	w8, [x27, #0x388]
 10a4128: f90c43e9     	str	x9, [sp, #0x1880]
 10a412c: 3400016a     	cbz	w10,  <L136>
 10a4130: f942a662     	ldr	x2, [x19, #0x548]
 10a4134: f942a261     	ldr	x1, [x19, #0x540]
 10a4138: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a413c: d0fffd43     	adrp	x3, 0x104e000 <__anon_429238+0xb615>
 10a4140: 91364063     	add	x3, x3, #0xd90
 10a4144: 91250000     	add	x0, x0, #0x940
 10a4148: 914007f5     	add	x21, sp, #0x1, lsl #12  // =0x1000
 10a414c: 912502b5     	add	x21, x21, #0x940
 10a4150: 94000b3f     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10a4154: 14000003     	b	 <L137>
<L136>:
 10a4158: d0fffd55     	adrp	x21, 0x104e000 <__anon_429238+0xb615>
 10a415c: 9139c2b5     	add	x21, x21, #0xe70
<L137>:
 10a4160: ad5a8760     	ldp	q0, q1, [x27, #0x350]
 10a4164: f0fffd48     	adrp	x8, 0x104f000 <__anon_394452+0x10>
 10a4168: 91054108     	add	x8, x8, #0x150
 10a416c: f94033e9     	ldr	x9, [sp, #0x60]
 10a4170: 914007fa     	add	x26, sp, #0x1, lsl #12  // =0x1000
 10a4174: 913ac35a     	add	x26, x26, #0xeb0
 10a4178: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a417c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4180: 3d822760     	str	q0, [x27, #0x890]
 10a4184: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4188: f9403bf9     	ldr	x25, [sp, #0x70]
 10a418c: 3d822b61     	str	q1, [x27, #0x8a0]
 10a4190: ad5b8760     	ldp	q0, q1, [x27, #0x370]
 10a4194: 3900013f     	strb	wzr, [x9]
 10a4198: 52800416     	mov	w22, #0x20              // =32
 10a419c: 9135c000     	add	x0, x0, #0xd70
 10a41a0: 913ac042     	add	x2, x2, #0xeb0
 10a41a4: 913a0084     	add	x4, x4, #0xe80
 10a41a8: 52800401     	mov	w1, #0x20               // =32
 10a41ac: 3d823361     	str	q1, [x27, #0x8c0]
 10a41b0: ad598b61     	ldp	q1, q2, [x27, #0x330]
 10a41b4: 3d822f60     	str	q0, [x27, #0x8b0]
 10a41b8: 3dc0cb60     	ldr	q0, [x27, #0x320]
 10a41bc: 52800623     	mov	w3, #0x31               // =49
 10a41c0: 39004356     	strb	w22, [x26, #0x10]
 10a41c4: 3d821b60     	str	q0, [x27, #0x860]
 10a41c8: 3d821f61     	str	q1, [x27, #0x870]
 10a41cc: ad4006a0     	ldp	q0, q1, [x21]
 10a41d0: 52840015     	mov	w21, #0x2000            // =8192
 10a41d4: 3d822362     	str	q2, [x27, #0x880]
 10a41d8: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a41dc: 3d825360     	str	q0, [x27, #0x940]
 10a41e0: 3d825761     	str	q1, [x27, #0x950]
 10a41e4: ad400500     	ldp	q0, q1, [x8]
 10a41e8: 528001a8     	mov	w8, #0xd                // =13
 10a41ec: 39000b48     	strb	w8, [x26, #0x2]
 10a41f0: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a41f4: 912e2908     	add	x8, x8, #0xb8a
 10a41f8: f9400109     	ldr	x9, [x8]
 10a41fc: f8405108     	ldur	x8, [x8, #0x5]
 10a4200: 3c811340     	stur	q0, [x26, #0x11]
 10a4204: 3c821341     	stur	q1, [x26, #0x21]
 10a4208: f8003349     	stur	x9, [x26, #0x3]
 10a420c: f90f5fe8     	str	x8, [sp, #0x1eb8]
 10a4210: 97ffdeae     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a4214: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4218: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a421c: 914007e3     	add	x3, sp, #0x1, lsl #12   // =0x1000
 10a4220: 91350000     	add	x0, x0, #0xd40
 10a4224: 91110021     	add	x1, x1, #0x440
 10a4228: 9135c063     	add	x3, x3, #0xd70
 10a422c: aa1703e2     	mov	x2, x23
 10a4230: 94000b07     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10a4234: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4238: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a423c: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a4240: 91368000     	add	x0, x0, #0xda0
 10a4244: 9135c021     	add	x1, x1, #0xd70
 10a4248: 3d821360     	str	q0, [x27, #0x840]
 10a424c: 3d820f60     	str	q0, [x27, #0x830]
 10a4250: 97ffe5f4     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10a4254: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4258: 912da908     	add	x8, x8, #0xb6a
 10a425c: 3dc21361     	ldr	q1, [x27, #0x840]
 10a4260: 3dc00100     	ldr	q0, [x8]
 10a4264: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4268: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a426c: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4270: 52800257     	mov	w23, #0x12              // =18
 10a4274: 528c6d38     	mov	w24, #0x6369            // =25449
 10a4278: 3c803340     	stur	q0, [x26, #0x3]
 10a427c: 3dc20f60     	ldr	q0, [x27, #0x830]
 10a4280: 913a0000     	add	x0, x0, #0xe80
 10a4284: 913ac042     	add	x2, x2, #0xeb0
 10a4288: 91350084     	add	x4, x4, #0xd40
 10a428c: 52800401     	mov	w1, #0x20               // =32
 10a4290: 528006c3     	mov	w3, #0x36               // =54
 10a4294: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a4298: 39000b57     	strb	w23, [x26, #0x2]
 10a429c: 78013358     	sturh	w24, [x26, #0x13]
 10a42a0: 39005756     	strb	w22, [x26, #0x15]
 10a42a4: 3c816340     	stur	q0, [x26, #0x16]
 10a42a8: 3c826341     	stur	q1, [x26, #0x26]
 10a42ac: 97ffde87     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a42b0: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a42b4: 912d6108     	add	x8, x8, #0xb58
 10a42b8: 3dc21361     	ldr	q1, [x27, #0x840]
 10a42bc: 3dc00100     	ldr	q0, [x8]
 10a42c0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a42c4: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a42c8: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a42cc: 91368000     	add	x0, x0, #0xda0
 10a42d0: 913ac042     	add	x2, x2, #0xeb0
 10a42d4: 3c803340     	stur	q0, [x26, #0x3]
 10a42d8: 3dc20f60     	ldr	q0, [x27, #0x830]
 10a42dc: 91350084     	add	x4, x4, #0xd40
 10a42e0: 52800401     	mov	w1, #0x20               // =32
 10a42e4: 528006c3     	mov	w3, #0x36               // =54
 10a42e8: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a42ec: 39000b57     	strb	w23, [x26, #0x2]
 10a42f0: 78013358     	sturh	w24, [x26, #0x13]
 10a42f4: 39005756     	strb	w22, [x26, #0x15]
 10a42f8: 3c816340     	stur	q0, [x26, #0x16]
 10a42fc: 3c826341     	stur	q1, [x26, #0x26]
 10a4300: 97ffde72     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a4304: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4308: 912df108     	add	x8, x8, #0xb7c
 10a430c: 3dc20360     	ldr	q0, [x27, #0x800]
 10a4310: 3dc20761     	ldr	q1, [x27, #0x810]
 10a4314: f9400117     	ldr	x23, [x8]
 10a4318: f8406118     	ldur	x24, [x8, #0x6]
 10a431c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4320: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4324: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4328: 528001d6     	mov	w22, #0xe               // =14
 10a432c: 91260000     	add	x0, x0, #0x980
 10a4330: 913ac042     	add	x2, x2, #0xeb0
 10a4334: 913a0084     	add	x4, x4, #0xe80
 10a4338: 52800401     	mov	w1, #0x20               // =32
 10a433c: 52800243     	mov	w3, #0x12               // =18
 10a4340: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a4344: 3d811b60     	str	q0, [x27, #0x460]
 10a4348: 3d811f61     	str	q1, [x27, #0x470]
 10a434c: 39000b56     	strb	w22, [x26, #0x2]
 10a4350: f8003357     	stur	x23, [x26, #0x3]
 10a4354: f8009358     	stur	x24, [x26, #0x9]
 10a4358: 3900475f     	strb	wzr, [x26, #0x11]
 10a435c: 97ffde5b     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a4360: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4364: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4368: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a436c: 91258000     	add	x0, x0, #0x960
 10a4370: 913ac042     	add	x2, x2, #0xeb0
 10a4374: 91368084     	add	x4, x4, #0xda0
 10a4378: 52800401     	mov	w1, #0x20               // =32
 10a437c: 52800243     	mov	w3, #0x12               // =18
 10a4380: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a4384: 39000b56     	strb	w22, [x26, #0x2]
 10a4388: f8003357     	stur	x23, [x26, #0x3]
 10a438c: f8009358     	stur	x24, [x26, #0x9]
 10a4390: 3900475f     	strb	wzr, [x26, #0x11]
 10a4394: 97ffde4d     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a4398: 6f00e400     	movi	v0.2d, #0000000000000000
 10a439c: 3900035f     	strb	wzr, [x26]
 10a43a0: 9105ca68     	add	x8, x19, #0x172
 10a43a4: 3d820360     	str	q0, [x27, #0x800]
 10a43a8: 3d820760     	str	q0, [x27, #0x810]
 10a43ac: 3d825760     	str	q0, [x27, #0x950]
 10a43b0: 3d825360     	str	q0, [x27, #0x940]
 10a43b4: 3d821f60     	str	q0, [x27, #0x870]
 10a43b8: 3d821b60     	str	q0, [x27, #0x860]
 10a43bc: ad5b0760     	ldp	q0, q1, [x27, #0x360]
 10a43c0: 3dc0e362     	ldr	q2, [x27, #0x380]
 10a43c4: 7943c275     	ldrh	w21, [x19, #0x1e0]
 10a43c8: 7902e274     	strh	w20, [x19, #0x170]
 10a43cc: 3d805a62     	str	q2, [x19, #0x160]
 10a43d0: ad0a0660     	stp	q0, q1, [x19, #0x140]
 10a43d4: ad590760     	ldp	q0, q1, [x27, #0x320]
 10a43d8: 3908ca7f     	strb	wzr, [x19, #0x232]
 10a43dc: ad080660     	stp	q0, q1, [x19, #0x100]
 10a43e0: ad5a0b60     	ldp	q0, q2, [x27, #0x340]
 10a43e4: 3dc11f61     	ldr	q1, [x27, #0x470]
 10a43e8: ad090a60     	stp	q0, q2, [x19, #0x120]
 10a43ec: 3dc11b60     	ldr	q0, [x27, #0x460]
 10a43f0: 3dc11762     	ldr	q2, [x27, #0x450]
 10a43f4: ad000500     	stp	q0, q1, [x8]
 10a43f8: 3dc11360     	ldr	q0, [x27, #0x440]
 10a43fc: 91064a68     	add	x8, x19, #0x192
 10a4400: 3dc10f61     	ldr	q1, [x27, #0x430]
 10a4404: ad000900     	stp	q0, q2, [x8]
 10a4408: 3dc10b60     	ldr	q0, [x27, #0x420]
 10a440c: 9106ca68     	add	x8, x19, #0x1b2
 10a4410: ad000500     	stp	q0, q1, [x8]
 10a4414: 140000f9     	b	 <L144>
<L138>:
 10a4418: aa1f03f5     	mov	x21, xzr
<L139>:
 10a441c: f9404ff7     	ldr	x23, [sp, #0x98]
 10a4420: b27902a9     	orr	x9, x21, #0x80
 10a4424: eb1a013f     	cmp	x9, x26
 10a4428: 54000148     	b.hi	 <L141>
<L140>:
 10a442c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4430: 8b150301     	add	x1, x24, x21
 10a4434: 91178000     	add	x0, x0, #0x5e0
 10a4438: 97ffe8af     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 10a443c: 910402a8     	add	x8, x21, #0x100
 10a4440: 910202b5     	add	x21, x21, #0x80
 10a4444: eb1a011f     	cmp	x8, x26
 10a4448: 54ffff29     	b.ls	 <L140>
 10a444c: 3945c368     	ldrb	w8, [x27, #0x170]
<L141>:
 10a4450: 8b284280     	add	x0, x20, w8, uxtw
 10a4454: cb150354     	sub	x20, x26, x21
 10a4458: 8b150301     	add	x1, x24, x21
 10a445c: aa1403e2     	mov	x2, x20
 10a4460: 9405014d     	bl	 <memcpy>
 10a4464: 3945c368     	ldrb	w8, [x27, #0x170]
 10a4468: f94af3e9     	ldr	x9, [sp, #0x15e0]
 10a446c: f94af7ea     	ldr	x10, [sp, #0x15e8]
 10a4470: 0b140108     	add	w8, w8, w20
 10a4474: ab1a0129     	adds	x9, x9, x26
 10a4478: 3905c368     	strb	w8, [x27, #0x170]
 10a447c: 39558268     	ldrb	w8, [x19, #0x560]
 10a4480: 9a8a354a     	cinc	x10, x10, hs
 10a4484: f90af3e9     	str	x9, [sp, #0x15e0]
 10a4488: 52800029     	mov	w9, #0x1                // =1
 10a448c: f90af7ea     	str	x10, [sp, #0x15e8]
 10a4490: 390002c9     	strb	w9, [x22]
 10a4494: 34000168     	cbz	w8,  <L142>
 10a4498: f942a662     	ldr	x2, [x19, #0x548]
 10a449c: f942a261     	ldr	x1, [x19, #0x540]
 10a44a0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a44a4: f0fffb03     	adrp	x3, 0x1007000 <__anon_13230+0x8>
 10a44a8: 912be063     	add	x3, x3, #0xaf8
 10a44ac: 911e8000     	add	x0, x0, #0x7a0
 10a44b0: 914007f4     	add	x20, sp, #0x1, lsl #12  // =0x1000
 10a44b4: 911e8294     	add	x20, x20, #0x7a0
 10a44b8: 94000c96     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 10a44bc: 14000003     	b	 <L143>
<L142>:
 10a44c0: f0fffb14     	adrp	x20, 0x1007000 <__anon_13230+0x8>
 10a44c4: 912ca294     	add	x20, x20, #0xb28
<L143>:
 10a44c8: ad4a0760     	ldp	q0, q1, [x27, #0x140]
 10a44cc: d0fffb88     	adrp	x8, 0x1016000 <__anon_413583>
 10a44d0: 9114d108     	add	x8, x8, #0x534
 10a44d4: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 10a44d8: f0fffb09     	adrp	x9, 0x1007000 <__anon_13230+0x8>
 10a44dc: 912e2929     	add	x9, x9, #0xb8a
 10a44e0: 913ac318     	add	x24, x24, #0xeb0
 10a44e4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a44e8: 3d824360     	str	q0, [x27, #0x900]
 10a44ec: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a44f0: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a44f4: 3d824761     	str	q1, [x27, #0x910]
 10a44f8: ad4b0760     	ldp	q0, q1, [x27, #0x160]
 10a44fc: f9403bf9     	ldr	x25, [sp, #0x70]
 10a4500: 52800615     	mov	w21, #0x30              // =48
 10a4504: 9135c000     	add	x0, x0, #0xd70
 10a4508: 913ac042     	add	x2, x2, #0xeb0
 10a450c: 913a0084     	add	x4, x4, #0xe80
 10a4510: 52800601     	mov	w1, #0x30               // =48
 10a4514: 3d824b60     	str	q0, [x27, #0x920]
 10a4518: 52800823     	mov	w3, #0x41               // =65
 10a451c: 3d824f61     	str	q1, [x27, #0x930]
 10a4520: ad480760     	ldp	q0, q1, [x27, #0x100]
 10a4524: 39004315     	strb	w21, [x24, #0x10]
 10a4528: 3d823360     	str	q0, [x27, #0x8c0]
 10a452c: 3d823761     	str	q1, [x27, #0x8d0]
 10a4530: ad490760     	ldp	q0, q1, [x27, #0x120]
 10a4534: 3d823b60     	str	q0, [x27, #0x8e0]
 10a4538: 3d823f61     	str	q1, [x27, #0x8f0]
 10a453c: ad460760     	ldp	q0, q1, [x27, #0xc0]
 10a4540: 3d822360     	str	q0, [x27, #0x880]
 10a4544: 3d822761     	str	q1, [x27, #0x890]
 10a4548: ad470760     	ldp	q0, q1, [x27, #0xe0]
 10a454c: 3d822b60     	str	q0, [x27, #0x8a0]
 10a4550: 3d822f61     	str	q1, [x27, #0x8b0]
 10a4554: ad450760     	ldp	q0, q1, [x27, #0xa0]
 10a4558: 3d821b60     	str	q0, [x27, #0x860]
 10a455c: 3d821f61     	str	q1, [x27, #0x870]
 10a4560: ad400680     	ldp	q0, q1, [x20]
 10a4564: 3d825360     	str	q0, [x27, #0x940]
 10a4568: 3dc00a80     	ldr	q0, [x20, #0x20]
 10a456c: 52860014     	mov	w20, #0x3000            // =12288
 10a4570: 3d825761     	str	q1, [x27, #0x950]
 10a4574: ad408901     	ldp	q1, q2, [x8, #0x10]
 10a4578: 3d825b60     	str	q0, [x27, #0x960]
 10a457c: 3dc00100     	ldr	q0, [x8]
 10a4580: 528001a8     	mov	w8, #0xd                // =13
 10a4584: 39000b08     	strb	w8, [x24, #0x2]
 10a4588: f9400128     	ldr	x8, [x9]
 10a458c: f8405129     	ldur	x9, [x9, #0x5]
 10a4590: 3c831302     	stur	q2, [x24, #0x31]
 10a4594: 3c811300     	stur	q0, [x24, #0x11]
 10a4598: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a459c: f8003308     	stur	x8, [x24, #0x3]
 10a45a0: f90f5fe9     	str	x9, [sp, #0x1eb8]
 10a45a4: 3c821301     	stur	q1, [x24, #0x21]
 10a45a8: 97ffe5d3     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a45ac: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a45b0: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a45b4: 914007e3     	add	x3, sp, #0x1, lsl #12   // =0x1000
 10a45b8: 91350000     	add	x0, x0, #0xd40
 10a45bc: 91110021     	add	x1, x1, #0x440
 10a45c0: 9135c063     	add	x3, x3, #0xd70
 10a45c4: aa1703e2     	mov	x2, x23
 10a45c8: 94000c52     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 10a45cc: 6f00e400     	movi	v0.2d, #0000000000000000
 10a45d0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a45d4: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a45d8: 91368000     	add	x0, x0, #0xda0
 10a45dc: 9135c021     	add	x1, x1, #0xd70
 10a45e0: 3d821760     	str	q0, [x27, #0x850]
 10a45e4: 3d821360     	str	q0, [x27, #0x840]
 10a45e8: 3d820f60     	str	q0, [x27, #0x830]
 10a45ec: 97fff033     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 10a45f0: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a45f4: 912da908     	add	x8, x8, #0xb6a
 10a45f8: 3dc21361     	ldr	q1, [x27, #0x840]
 10a45fc: 3dc00100     	ldr	q0, [x8]
 10a4600: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4604: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4608: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a460c: 52800256     	mov	w22, #0x12              // =18
 10a4610: 528c6d37     	mov	w23, #0x6369            // =25449
 10a4614: 3c803300     	stur	q0, [x24, #0x3]
 10a4618: 3dc20f60     	ldr	q0, [x27, #0x830]
 10a461c: 913a0000     	add	x0, x0, #0xe80
 10a4620: 913ac042     	add	x2, x2, #0xeb0
 10a4624: 91350084     	add	x4, x4, #0xd40
 10a4628: 52800601     	mov	w1, #0x30               // =48
 10a462c: 3c816300     	stur	q0, [x24, #0x16]
 10a4630: 3dc21760     	ldr	q0, [x27, #0x850]
 10a4634: 528008c3     	mov	w3, #0x46               // =70
 10a4638: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a463c: 39000b16     	strb	w22, [x24, #0x2]
 10a4640: 78013317     	sturh	w23, [x24, #0x13]
 10a4644: 39005715     	strb	w21, [x24, #0x15]
 10a4648: 3c826301     	stur	q1, [x24, #0x26]
 10a464c: 3c836300     	stur	q0, [x24, #0x36]
 10a4650: 97ffe5a9     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a4654: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4658: 912d6108     	add	x8, x8, #0xb58
 10a465c: 3dc21361     	ldr	q1, [x27, #0x840]
 10a4660: 3dc00100     	ldr	q0, [x8]
 10a4664: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4668: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a466c: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4670: 91368000     	add	x0, x0, #0xda0
 10a4674: 913ac042     	add	x2, x2, #0xeb0
 10a4678: 3c803300     	stur	q0, [x24, #0x3]
 10a467c: 3dc20f60     	ldr	q0, [x27, #0x830]
 10a4680: 91350084     	add	x4, x4, #0xd40
 10a4684: 52800601     	mov	w1, #0x30               // =48
 10a4688: 528008c3     	mov	w3, #0x46               // =70
 10a468c: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a4690: 3c816300     	stur	q0, [x24, #0x16]
 10a4694: 3dc21760     	ldr	q0, [x27, #0x850]
 10a4698: 39000b16     	strb	w22, [x24, #0x2]
 10a469c: 78013317     	sturh	w23, [x24, #0x13]
 10a46a0: 39005715     	strb	w21, [x24, #0x15]
 10a46a4: 3c826301     	stur	q1, [x24, #0x26]
 10a46a8: 3c836300     	stur	q0, [x24, #0x36]
 10a46ac: 97ffe592     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a46b0: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a46b4: 912df108     	add	x8, x8, #0xb7c
 10a46b8: 3dc20360     	ldr	q0, [x27, #0x800]
 10a46bc: 3dc20761     	ldr	q1, [x27, #0x810]
 10a46c0: 3dc20b62     	ldr	q2, [x27, #0x820]
 10a46c4: f9400116     	ldr	x22, [x8]
 10a46c8: f8406117     	ldur	x23, [x8, #0x6]
 10a46cc: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a46d0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a46d4: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a46d8: 528001d5     	mov	w21, #0xe               // =14
 10a46dc: 91200000     	add	x0, x0, #0x800
 10a46e0: 913ac042     	add	x2, x2, #0xeb0
 10a46e4: 913a0084     	add	x4, x4, #0xe80
 10a46e8: 52800601     	mov	w1, #0x30               // =48
 10a46ec: 52800243     	mov	w3, #0x12               // =18
 10a46f0: ad178760     	stp	q0, q1, [x27, #0x2f0]
 10a46f4: 3d80c762     	str	q2, [x27, #0x310]
 10a46f8: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a46fc: 39000b15     	strb	w21, [x24, #0x2]
 10a4700: f8003316     	stur	x22, [x24, #0x3]
 10a4704: f8009317     	stur	x23, [x24, #0x9]
 10a4708: 3900471f     	strb	wzr, [x24, #0x11]
 10a470c: 97ffe57a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a4710: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4714: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4718: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a471c: 911f4000     	add	x0, x0, #0x7d0
 10a4720: 913ac042     	add	x2, x2, #0xeb0
 10a4724: 91368084     	add	x4, x4, #0xda0
 10a4728: 52800601     	mov	w1, #0x30               // =48
 10a472c: 52800243     	mov	w3, #0x12               // =18
 10a4730: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a4734: 39000b15     	strb	w21, [x24, #0x2]
 10a4738: f8003316     	stur	x22, [x24, #0x3]
 10a473c: f8009317     	stur	x23, [x24, #0x9]
 10a4740: 3900471f     	strb	wzr, [x24, #0x11]
 10a4744: 97ffe56c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a4748: 6f00e400     	movi	v0.2d, #0000000000000000
 10a474c: 3900031f     	strb	wzr, [x24]
 10a4750: 91078a68     	add	x8, x19, #0x1e2
 10a4754: 52826055     	mov	w21, #0x1302            // =4866
 10a4758: 3d820360     	str	q0, [x27, #0x800]
 10a475c: 3d820760     	str	q0, [x27, #0x810]
 10a4760: 3d820b60     	str	q0, [x27, #0x820]
 10a4764: 3d825360     	str	q0, [x27, #0x940]
 10a4768: 3d825760     	str	q0, [x27, #0x950]
 10a476c: 3d825b60     	str	q0, [x27, #0x960]
 10a4770: 3d821b60     	str	q0, [x27, #0x860]
 10a4774: 3d821f60     	str	q0, [x27, #0x870]
 10a4778: 3d822360     	str	q0, [x27, #0x880]
 10a477c: ad4a0760     	ldp	q0, q1, [x27, #0x140]
 10a4780: 7903c275     	strh	w21, [x19, #0x1e0]
 10a4784: 390c0a7f     	strb	wzr, [x19, #0x302]
 10a4788: ad0d0660     	stp	q0, q1, [x19, #0x1a0]
 10a478c: ad4b0362     	ldp	q2, q0, [x27, #0x160]
 10a4790: ad0e0262     	stp	q2, q0, [x19, #0x1c0]
 10a4794: ad480361     	ldp	q1, q0, [x27, #0x100]
 10a4798: ad0b0261     	stp	q1, q0, [x19, #0x160]
 10a479c: ad490362     	ldp	q2, q0, [x27, #0x120]
 10a47a0: 7942e274     	ldrh	w20, [x19, #0x170]
 10a47a4: ad0c0262     	stp	q2, q0, [x19, #0x180]
 10a47a8: ad460361     	ldp	q1, q0, [x27, #0xc0]
 10a47ac: ad090261     	stp	q1, q0, [x19, #0x120]
 10a47b0: ad470362     	ldp	q2, q0, [x27, #0xe0]
 10a47b4: ad0a0262     	stp	q2, q0, [x19, #0x140]
 10a47b8: ad450361     	ldp	q1, q0, [x27, #0xa0]
 10a47bc: ad080261     	stp	q1, q0, [x19, #0x100]
 10a47c0: ad578362     	ldp	q2, q0, [x27, #0x2f0]
 10a47c4: 3dc0c761     	ldr	q1, [x27, #0x310]
 10a47c8: ad000102     	stp	q2, q0, [x8]
 10a47cc: 3dc0bb62     	ldr	q2, [x27, #0x2e0]
 10a47d0: 3d800901     	str	q1, [x8, #0x20]
 10a47d4: ad560760     	ldp	q0, q1, [x27, #0x2c0]
 10a47d8: 91084a68     	add	x8, x19, #0x212
 10a47dc: 3d800902     	str	q2, [x8, #0x20]
 10a47e0: ad000500     	stp	q0, q1, [x8]
 10a47e4: ad550f60     	ldp	q0, q3, [x27, #0x2a0]
 10a47e8: 3dc0a761     	ldr	q1, [x27, #0x290]
 10a47ec: 91090a68     	add	x8, x19, #0x242
 10a47f0: ad008d00     	stp	q0, q3, [x8, #0x10]
 10a47f4: 3d800101     	str	q1, [x8]
<L144>:
 10a47f8: a947a3e9     	ldp	x9, x8, [sp, #0x78]
 10a47fc: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4800: 9105ca76     	add	x22, x19, #0x172
 10a4804: b900011f     	str	wzr, [x8]
 10a4808: 394c4268     	ldrb	w8, [x19, #0x310]
 10a480c: ad000260     	stp	q0, q0, [x19]
 10a4810: ad010260     	stp	q0, q0, [x19, #0x20]
 10a4814: ad020260     	stp	q0, q0, [x19, #0x40]
 10a4818: ad030260     	stp	q0, q0, [x19, #0x60]
 10a481c: ad040260     	stp	q0, q0, [x19, #0x80]
 10a4820: ad050260     	stp	q0, q0, [x19, #0xa0]
 10a4824: ad060260     	stp	q0, q0, [x19, #0xc0]
 10a4828: ad070260     	stp	q0, q0, [x19, #0xe0]
 10a482c: ad000120     	stp	q0, q0, [x9]
 10a4830: ad010120     	stp	q0, q0, [x9, #0x20]
 10a4834: ad020120     	stp	q0, q0, [x9, #0x40]
 10a4838: ad030120     	stp	q0, q0, [x9, #0x60]
 10a483c: ad040120     	stp	q0, q0, [x9, #0x80]
 10a4840: 3c89b120     	stur	q0, [x9, #0x9b]
 10a4844: 36001268     	tbz	w8, #0x0,  <L145>
 10a4848: ad498660     	ldp	q0, q1, [x19, #0x130]
 10a484c: 914007fa     	add	x26, sp, #0x1, lsl #12  // =0x1000
 10a4850: 913ac35a     	add	x26, x26, #0xeb0
 10a4854: 91064a68     	add	x8, x19, #0x192
 10a4858: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a485c: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a4860: 913ac000     	add	x0, x0, #0xeb0
 10a4864: 793e43f4     	strh	w20, [sp, #0x1f20]
 10a4868: ad018740     	stp	q0, q1, [x26, #0x30]
 10a486c: ad4a8262     	ldp	q2, q0, [x19, #0x150]
 10a4870: 3dc04261     	ldr	q1, [x19, #0x100]
 10a4874: 912d8021     	add	x1, x1, #0xb60
 10a4878: ad028342     	stp	q2, q0, [x26, #0x50]
 10a487c: ad488e60     	ldp	q0, q3, [x19, #0x110]
 10a4880: 3dc00102     	ldr	q2, [x8]
 10a4884: ad000341     	stp	q1, q0, [x26]
 10a4888: ad4006c0     	ldp	q0, q1, [x22]
 10a488c: 91078a76     	add	x22, x19, #0x1e2
 10a4890: 3d800b43     	str	q3, [x26, #0x20]
 10a4894: 3c892342     	stur	q2, [x26, #0x92]
 10a4898: 3c872340     	stur	q0, [x26, #0x72]
 10a489c: 3c882341     	stur	q1, [x26, #0x82]
 10a48a0: ad408500     	ldp	q0, q1, [x8, #0x10]
 10a48a4: 3c8a2340     	stur	q0, [x26, #0xa2]
 10a48a8: 3dc00d00     	ldr	q0, [x8, #0x30]
 10a48ac: 3c8b2341     	stur	q1, [x26, #0xb2]
 10a48b0: 3dc07661     	ldr	q1, [x19, #0x1d0]
 10a48b4: 3c8c2340     	stur	q0, [x26, #0xc2]
 10a48b8: 3d803741     	str	q1, [x26, #0xd0]
 10a48bc: ad4006c0     	ldp	q0, q1, [x22]
 10a48c0: 3d821b60     	str	q0, [x27, #0x860]
 10a48c4: 3dc00ac0     	ldr	q0, [x22, #0x20]
 10a48c8: 3d821f61     	str	q1, [x27, #0x870]
 10a48cc: 3d822360     	str	q0, [x27, #0x880]
 10a48d0: 97ffef7a     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 10a48d4: ad4006c0     	ldp	q0, q1, [x22]
 10a48d8: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a48dc: 912da908     	add	x8, x8, #0xb6a
 10a48e0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a48e4: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a48e8: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a48ec: 52860014     	mov	w20, #0x3000            // =12288
 10a48f0: 528c6d37     	mov	w23, #0x6369            // =25449
 10a48f4: 3d825360     	str	q0, [x27, #0x940]
 10a48f8: 3dc00ac0     	ldr	q0, [x22, #0x20]
 10a48fc: 52800256     	mov	w22, #0x12              // =18
 10a4900: 52800618     	mov	w24, #0x30              // =48
 10a4904: 912e4000     	add	x0, x0, #0xb90
 10a4908: 913ac042     	add	x2, x2, #0xeb0
 10a490c: 3d825b60     	str	q0, [x27, #0x960]
 10a4910: 3dc00100     	ldr	q0, [x8]
 10a4914: 913a0084     	add	x4, x4, #0xe80
 10a4918: 52800601     	mov	w1, #0x30               // =48
 10a491c: 528008c3     	mov	w3, #0x46               // =70
 10a4920: 3d825761     	str	q1, [x27, #0x950]
 10a4924: 3c803340     	stur	q0, [x26, #0x3]
 10a4928: 3dc18b60     	ldr	q0, [x27, #0x620]
 10a492c: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a4930: 3c816340     	stur	q0, [x26, #0x16]
 10a4934: 3dc18f60     	ldr	q0, [x27, #0x630]
 10a4938: 39000b56     	strb	w22, [x26, #0x2]
 10a493c: 3c826340     	stur	q0, [x26, #0x26]
 10a4940: 3dc19360     	ldr	q0, [x27, #0x640]
 10a4944: 78013357     	sturh	w23, [x26, #0x13]
 10a4948: 39005758     	strb	w24, [x26, #0x15]
 10a494c: 3c836340     	stur	q0, [x26, #0x36]
 10a4950: 97ffe4e9     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a4954: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4958: 912d6108     	add	x8, x8, #0xb58
 10a495c: 3dc18f61     	ldr	q1, [x27, #0x630]
 10a4960: 3dc00100     	ldr	q0, [x8]
 10a4964: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4968: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a496c: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4970: 912f0000     	add	x0, x0, #0xbc0
 10a4974: 913ac042     	add	x2, x2, #0xeb0
 10a4978: 3c803340     	stur	q0, [x26, #0x3]
 10a497c: 3dc18b60     	ldr	q0, [x27, #0x620]
 10a4980: 91368084     	add	x4, x4, #0xda0
 10a4984: 52800601     	mov	w1, #0x30               // =48
 10a4988: 528008c3     	mov	w3, #0x46               // =70
 10a498c: 793d63f4     	strh	w20, [sp, #0x1eb0]
 10a4990: 3c816340     	stur	q0, [x26, #0x16]
 10a4994: 3dc19360     	ldr	q0, [x27, #0x640]
 10a4998: 39000b56     	strb	w22, [x26, #0x2]
 10a499c: 78013357     	sturh	w23, [x26, #0x13]
 10a49a0: 39005758     	strb	w24, [x26, #0x15]
 10a49a4: 3c826341     	stur	q1, [x26, #0x26]
 10a49a8: 3c836340     	stur	q0, [x26, #0x36]
 10a49ac: 97ffe4d2     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10a49b0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a49b4: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a49b8: 2a1503e1     	mov	w1, w21
 10a49bc: 91314000     	add	x0, x0, #0xc50
 10a49c0: 912e4042     	add	x2, x2, #0xb90
 10a49c4: 97ffdbbd     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 10a49c8: 797953e8     	ldrh	w8, [sp, #0x1ca8]
 10a49cc: 35002088     	cbnz	w8,  <L155>
 10a49d0: 3dc1a360     	ldr	q0, [x27, #0x680]
 10a49d4: 3dc1a761     	ldr	q1, [x27, #0x690]
 10a49d8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a49dc: 3dc1ab62     	ldr	q2, [x27, #0x6a0]
 10a49e0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a49e4: f94e33f6     	ldr	x22, [sp, #0x1c60]
 10a49e8: f94e37f4     	ldr	x20, [sp, #0x1c68]
 10a49ec: 91338000     	add	x0, x0, #0xce0
 10a49f0: 9132c042     	add	x2, x2, #0xcb0
 10a49f4: 2a1503e1     	mov	w1, w21
 10a49f8: 3d81df60     	str	q0, [x27, #0x770]
 10a49fc: 3d81e361     	str	q1, [x27, #0x780]
 10a4a00: 3d81e762     	str	q2, [x27, #0x790]
 10a4a04: 97ffdbad     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 10a4a08: 797a73e8     	ldrh	w8, [sp, #0x1d38]
 10a4a0c: f9404fe2     	ldr	x2, [sp, #0x98]
 10a4a10: 35001f28     	cbnz	w8,  <L157>
 10a4a14: 3dc1c760     	ldr	q0, [x27, #0x710]
 10a4a18: 3dc1cf61     	ldr	q1, [x27, #0x730]
 10a4a1c: 91122268     	add	x8, x19, #0x488
 10a4a20: 3dc1d362     	ldr	q2, [x27, #0x740]
 10a4a24: f94e9be9     	ldr	x9, [sp, #0x1d30]
 10a4a28: f9022276     	str	x22, [x19, #0x440]
 10a4a2c: 3d810e60     	str	q0, [x19, #0x430]
 10a4a30: 3dc1d760     	ldr	q0, [x27, #0x750]
 10a4a34: 3d811661     	str	q1, [x19, #0x450]
 10a4a38: 3dc1f361     	ldr	q1, [x27, #0x7c0]
 10a4a3c: 3d811e60     	str	q0, [x19, #0x470]
 10a4a40: 3dc1f760     	ldr	q0, [x27, #0x7d0]
 10a4a44: 3d811a62     	str	q2, [x19, #0x460]
 10a4a48: 3dc1fb62     	ldr	q2, [x27, #0x7e0]
 10a4a4c: ad010101     	stp	q1, q0, [x8, #0x20]
 10a4a50: 3dc1eb60     	ldr	q0, [x27, #0x7a0]
 10a4a54: 3dc1ef61     	ldr	q1, [x27, #0x7b0]
 10a4a58: 3d801102     	str	q2, [x8, #0x40]
 10a4a5c: ad000500     	stp	q0, q1, [x8]
 10a4a60: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4a64: f94e53e8     	ldr	x8, [sp, #0x1ca0]
 10a4a68: f9022674     	str	x20, [x19, #0x448]
 10a4a6c: f9024268     	str	x8, [x19, #0x480]
 10a4a70: f9026e69     	str	x9, [x19, #0x4d8]
 10a4a74: 3d81ab60     	str	q0, [x27, #0x6a0]
 10a4a78: 3d81a760     	str	q0, [x27, #0x690]
 10a4a7c: 3d81a360     	str	q0, [x27, #0x680]
 10a4a80: 3d819f60     	str	q0, [x27, #0x670]
 10a4a84: 3d819b60     	str	q0, [x27, #0x660]
 10a4a88: 3d819760     	str	q0, [x27, #0x650]
 10a4a8c: 14000077     	b	 <L146>
<L145>:
 10a4a90: ad4a0660     	ldp	q0, q1, [x19, #0x140]
 10a4a94: 914007fa     	add	x26, sp, #0x1, lsl #12  // =0x1000
 10a4a98: 913ac35a     	add	x26, x26, #0xeb0
 10a4a9c: 3dc05a62     	ldr	q2, [x19, #0x160]
 10a4aa0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4aa4: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10a4aa8: 913ac000     	add	x0, x0, #0xeb0
 10a4aac: ad020740     	stp	q0, q1, [x26, #0x40]
 10a4ab0: ad480660     	ldp	q0, q1, [x19, #0x100]
 10a4ab4: 3d801b42     	str	q2, [x26, #0x60]
 10a4ab8: 91270021     	add	x1, x1, #0x9c0
 10a4abc: ad000740     	stp	q0, q1, [x26]
 10a4ac0: ad490a60     	ldp	q0, q2, [x19, #0x120]
 10a4ac4: ad010b40     	stp	q0, q2, [x26, #0x20]
 10a4ac8: ad4002c1     	ldp	q1, q0, [x22]
 10a4acc: 3d821b61     	str	q1, [x27, #0x860]
 10a4ad0: 3d821f60     	str	q0, [x27, #0x870]
 10a4ad4: 97ffe3d3     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10a4ad8: ad4006c0     	ldp	q0, q1, [x22]
 10a4adc: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4ae0: 912da908     	add	x8, x8, #0xb6a
 10a4ae4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4ae8: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4aec: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4af0: 52840015     	mov	w21, #0x2000            // =8192
 10a4af4: 52800256     	mov	w22, #0x12              // =18
 10a4af8: 3d825360     	str	q0, [x27, #0x940]
 10a4afc: 3dc00100     	ldr	q0, [x8]
 10a4b00: 528c6d37     	mov	w23, #0x6369            // =25449
 10a4b04: 52800418     	mov	w24, #0x20              // =32
 10a4b08: 91278000     	add	x0, x0, #0x9e0
 10a4b0c: 913ac042     	add	x2, x2, #0xeb0
 10a4b10: 3c803340     	stur	q0, [x26, #0x3]
 10a4b14: 3dc12360     	ldr	q0, [x27, #0x480]
 10a4b18: 913a0084     	add	x4, x4, #0xe80
 10a4b1c: 52800401     	mov	w1, #0x20               // =32
 10a4b20: 528006c3     	mov	w3, #0x36               // =54
 10a4b24: 3d825761     	str	q1, [x27, #0x950]
 10a4b28: 3c816340     	stur	q0, [x26, #0x16]
 10a4b2c: 3dc12760     	ldr	q0, [x27, #0x490]
 10a4b30: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a4b34: 39000b56     	strb	w22, [x26, #0x2]
 10a4b38: 78013357     	sturh	w23, [x26, #0x13]
 10a4b3c: 39005758     	strb	w24, [x26, #0x15]
 10a4b40: 3c826340     	stur	q0, [x26, #0x26]
 10a4b44: 97ffdc61     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a4b48: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4b4c: 912d6108     	add	x8, x8, #0xb58
 10a4b50: 3dc12761     	ldr	q1, [x27, #0x490]
 10a4b54: 3dc00100     	ldr	q0, [x8]
 10a4b58: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4b5c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4b60: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10a4b64: 91280000     	add	x0, x0, #0xa00
 10a4b68: 913ac042     	add	x2, x2, #0xeb0
 10a4b6c: 3c803340     	stur	q0, [x26, #0x3]
 10a4b70: 3dc12360     	ldr	q0, [x27, #0x480]
 10a4b74: 91368084     	add	x4, x4, #0xda0
 10a4b78: 52800401     	mov	w1, #0x20               // =32
 10a4b7c: 528006c3     	mov	w3, #0x36               // =54
 10a4b80: 793d63f5     	strh	w21, [sp, #0x1eb0]
 10a4b84: 39000b56     	strb	w22, [x26, #0x2]
 10a4b88: 78013357     	sturh	w23, [x26, #0x13]
 10a4b8c: 39005758     	strb	w24, [x26, #0x15]
 10a4b90: 3c816340     	stur	q0, [x26, #0x16]
 10a4b94: 3c826341     	stur	q1, [x26, #0x26]
 10a4b98: 97ffdc4c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10a4b9c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4ba0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4ba4: 2a1403e1     	mov	w1, w20
 10a4ba8: 912a0000     	add	x0, x0, #0xa80
 10a4bac: 91278042     	add	x2, x2, #0x9e0
 10a4bb0: 97ffdbc6     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10a4bb4: 7975b3e8     	ldrh	w8, [sp, #0x1ad8]
 10a4bb8: 35001188     	cbnz	w8,  <L156>
 10a4bbc: 3dc13360     	ldr	q0, [x27, #0x4c0]
 10a4bc0: 3dc13761     	ldr	q1, [x27, #0x4d0]
 10a4bc4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4bc8: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10a4bcc: f94d4bf6     	ldr	x22, [sp, #0x1a90]
 10a4bd0: f94d4ff5     	ldr	x21, [sp, #0x1a98]
 10a4bd4: 912c0000     	add	x0, x0, #0xb00
 10a4bd8: 912b8042     	add	x2, x2, #0xae0
 10a4bdc: 2a1403e1     	mov	w1, w20
 10a4be0: 3d816b60     	str	q0, [x27, #0x5a0]
 10a4be4: 3d816f61     	str	q1, [x27, #0x5b0]
 10a4be8: 97ffdbb8     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10a4bec: 7976b3e8     	ldrh	w8, [sp, #0x1b58]
 10a4bf0: f9404fe2     	ldr	x2, [sp, #0x98]
 10a4bf4: 350012a8     	cbnz	w8,  <L159>
 10a4bf8: 3dc15360     	ldr	q0, [x27, #0x540]
 10a4bfc: 3dc15b61     	ldr	q1, [x27, #0x560]
 10a4c00: 91122268     	add	x8, x19, #0x488
 10a4c04: 3dc15f62     	ldr	q2, [x27, #0x570]
 10a4c08: f94dabe9     	ldr	x9, [sp, #0x1b50]
 10a4c0c: f9022276     	str	x22, [x19, #0x440]
 10a4c10: 3d810e60     	str	q0, [x19, #0x430]
 10a4c14: 3dc16360     	ldr	q0, [x27, #0x580]
 10a4c18: 3d811661     	str	q1, [x19, #0x450]
 10a4c1c: 3dc17b61     	ldr	q1, [x27, #0x5e0]
 10a4c20: 3d811e60     	str	q0, [x19, #0x470]
 10a4c24: 3dc17f60     	ldr	q0, [x27, #0x5f0]
 10a4c28: 3d811a62     	str	q2, [x19, #0x460]
 10a4c2c: 3dc18362     	ldr	q2, [x27, #0x600]
 10a4c30: ad010101     	stp	q1, q0, [x8, #0x20]
 10a4c34: 3dc17360     	ldr	q0, [x27, #0x5c0]
 10a4c38: 3dc17761     	ldr	q1, [x27, #0x5d0]
 10a4c3c: 3d801102     	str	q2, [x8, #0x40]
 10a4c40: ad000500     	stp	q0, q1, [x8]
 10a4c44: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4c48: f94d6be8     	ldr	x8, [sp, #0x1ad0]
 10a4c4c: f9022675     	str	x21, [x19, #0x448]
 10a4c50: f9024268     	str	x8, [x19, #0x480]
 10a4c54: f9026e69     	str	x9, [x19, #0x4d8]
 10a4c58: 3d813760     	str	q0, [x27, #0x4d0]
 10a4c5c: 3d813360     	str	q0, [x27, #0x4c0]
 10a4c60: 3d812f60     	str	q0, [x27, #0x4b0]
 10a4c64: 3d812b60     	str	q0, [x27, #0x4a0]
<L146>:
 10a4c68: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4c6c: f94037f4     	ldr	x20, [sp, #0x68]
 10a4c70: 2a1f03e1     	mov	w1, wzr
 10a4c74: 91110000     	add	x0, x0, #0x440
 10a4c78: 9404fede     	bl	 <memset>
 10a4c7c: f94053e8     	ldr	x8, [sp, #0xa0]
 10a4c80: 39400108     	ldrb	w8, [x8]
 10a4c84: 360000c8     	tbz	w8, #0x0,  <L147>
 10a4c88: 3954e268     	ldrb	w8, [x19, #0x538]
 10a4c8c: 35000088     	cbnz	w8,  <L147>
 10a4c90: 52800028     	mov	w8, #0x1                // =1
 10a4c94: b905767f     	str	wzr, [x19, #0x574]
 10a4c98: 39290b88     	strb	w8, [x28, #0xa42]
<L147>:
 10a4c9c: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4ca0: 52800028     	mov	w8, #0x1                // =1
 10a4ca4: 39000328     	strb	w8, [x25]
 10a4ca8: 911083e8     	add	x8, sp, #0x420
 10a4cac: 3d81f500     	str	q0, [x8, #0x7d0]
 10a4cb0: 3d81f900     	str	q0, [x8, #0x7e0]
 10a4cb4: 3d81fd00     	str	q0, [x8, #0x7f0]
 10a4cb8: 3d820100     	str	q0, [x8, #0x800]
 10a4cbc: 3d820500     	str	q0, [x8, #0x810]
 10a4cc0: f9406be9     	ldr	x9, [sp, #0xd0]
 10a4cc4: f9405fe8     	ldr	x8, [sp, #0xb8]
 10a4cc8: 7900213f     	strh	wzr, [x9, #0x10]
 10a4ccc: a9005128     	stp	x8, x20, [x9]
 10a4cd0: 17fff71f     	b	 <L6>
<L148>:
 10a4cd4: 528000e0     	mov	w0, #0x7                // =7
<L149>:
 10a4cd8: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4cdc: 3d820720     	str	q0, [x25, #0x810]
 10a4ce0: 3d820320     	str	q0, [x25, #0x800]
 10a4ce4: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a4ce8: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a4cec: 3d81f720     	str	q0, [x25, #0x7d0]
 10a4cf0: 79002100     	strh	w0, [x8, #0x10]
 10a4cf4: 17fff716     	b	 <L6>
<L150>:
 10a4cf8: f0fffb0a     	adrp	x10, 0x1007000 <__anon_13230+0x8>
 10a4cfc: 7957414a     	ldrh	w10, [x10, #0xba0]
 10a4d00: 7104015f     	cmp	w10, #0x100
 10a4d04: 54000383     	b.lo	 <L151>
 10a4d08: 120015ab     	and	w11, w13, #0x3f
 10a4d0c: 9240094a     	and	x10, x10, #0x7
 10a4d10: 1aca256a     	lsr	w10, w11, w10
 10a4d14: 3600030a     	tbz	w10, #0x0,  <L151>
 10a4d18: 3948f74a     	ldrb	w10, [x26, #0x23d]
 10a4d1c: 340002ca     	cbz	w10,  <L151>
 10a4d20: f94143e5     	ldr	x5, [sp, #0x280]
 10a4d24: f94147e6     	ldr	x6, [sp, #0x288]
 10a4d28: 913423e0     	add	x0, sp, #0xd08
 10a4d2c: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10a4d30: 52800309     	mov	w9, #0x18               // =24
 10a4d34: 9109c3e4     	add	x4, sp, #0x270
 10a4d38: aa1303e1     	mov	x1, x19
 10a4d3c: 2a1403e7     	mov	w7, w20
 10a4d40: 790003e9     	strh	w9, [sp]
 10a4d44: 940003c2     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10a4d48: 795a33e8     	ldrh	w8, [sp, #0xd18]
 10a4d4c: 35000b48     	cbnz	w8,  <L162>
 10a4d50: f94053e8     	ldr	x8, [sp, #0xa0]
 10a4d54: f94687f4     	ldr	x20, [sp, #0xd08]
 10a4d58: aa1303e0     	mov	x0, x19
 10a4d5c: f9468bf5     	ldr	x21, [sp, #0xd10]
 10a4d60: 39400101     	ldrb	w1, [x8]
 10a4d64: 9400038d     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 10a4d68: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4d6c: 3900035f     	strb	wzr, [x26]
 10a4d70: 17fffa4d     	b	 <L80>
<L151>:
 10a4d74: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4d78: f0fffb08     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10a4d7c: 912b8108     	add	x8, x8, #0xae0
 10a4d80: 3dc00101     	ldr	q1, [x8]
 10a4d84: 52800509     	mov	w9, #0x28               // =40
 10a4d88: 3d820720     	str	q0, [x25, #0x810]
 10a4d8c: 3d820320     	str	q0, [x25, #0x800]
 10a4d90: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a4d94: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a4d98: 3d81f720     	str	q0, [x25, #0x7d0]
 10a4d9c: f9000989     	str	x9, [x12, #0x10]
 10a4da0: 3d800181     	str	q1, [x12]
 10a4da4: 17fff6ea     	b	 <L6>
<L152>:
 10a4da8: f9406be8     	ldr	x8, [sp, #0xd0]
 10a4dac: 52800549     	mov	w9, #0x2a               // =42
 10a4db0: 79002109     	strh	w9, [x8, #0x10]
 10a4db4: 17fff6e6     	b	 <L6>
<L153>:
 10a4db8: f9406be8     	ldr	x8, [sp, #0xd0]
 10a4dbc: 17ffffc7     	b	 <L149>
<L154>:
 10a4dc0: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4dc4: 3d81f720     	str	q0, [x25, #0x7d0]
 10a4dc8: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a4dcc: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a4dd0: 3d820320     	str	q0, [x25, #0x800]
 10a4dd4: 3d820720     	str	q0, [x25, #0x810]
 10a4dd8: 1400003e     	b	 <L163>
<L155>:
 10a4ddc: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4de0: 2a0803f3     	mov	w19, w8
 10a4de4: 14000012     	b	 <L158>
<L156>:
 10a4de8: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4dec: 2a0803f3     	mov	w19, w8
 10a4df0: 14000024     	b	 <L160>
<L157>:
 10a4df4: aa1603e0     	mov	x0, x22
 10a4df8: 2a0803f3     	mov	w19, w8
 10a4dfc: 94050071     	bl	 <EVP_CIPHER_CTX_free@plt>
 10a4e00: aa1403e0     	mov	x0, x20
 10a4e04: 9405006f     	bl	 <EVP_CIPHER_CTX_free@plt>
 10a4e08: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4e0c: f90e27ff     	str	xzr, [sp, #0x1c48]
 10a4e10: f90e23ff     	str	xzr, [sp, #0x1c40]
 10a4e14: f90e1fff     	str	xzr, [sp, #0x1c38]
 10a4e18: f90e1bff     	str	xzr, [sp, #0x1c30]
 10a4e1c: f90e13ff     	str	xzr, [sp, #0x1c20]
 10a4e20: 3d81b760     	str	q0, [x27, #0x6d0]
 10a4e24: 3d81b360     	str	q0, [x27, #0x6c0]
 10a4e28: 3d81af60     	str	q0, [x27, #0x6b0]
<L158>:
 10a4e2c: 3d81ab60     	str	q0, [x27, #0x6a0]
 10a4e30: 3d81a760     	str	q0, [x27, #0x690]
 10a4e34: 3d81a360     	str	q0, [x27, #0x680]
 10a4e38: 3d819f60     	str	q0, [x27, #0x670]
 10a4e3c: 3d819b60     	str	q0, [x27, #0x660]
 10a4e40: 3d819760     	str	q0, [x27, #0x650]
 10a4e44: 14000013     	b	 <L161>
<L159>:
 10a4e48: aa1603e0     	mov	x0, x22
 10a4e4c: 2a0803f3     	mov	w19, w8
 10a4e50: 9405005c     	bl	 <EVP_CIPHER_CTX_free@plt>
 10a4e54: aa1503e0     	mov	x0, x21
 10a4e58: 9405005a     	bl	 <EVP_CIPHER_CTX_free@plt>
 10a4e5c: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4e60: f90d3fff     	str	xzr, [sp, #0x1a78]
 10a4e64: f90d3bff     	str	xzr, [sp, #0x1a70]
 10a4e68: f90d37ff     	str	xzr, [sp, #0x1a68]
 10a4e6c: f90d33ff     	str	xzr, [sp, #0x1a60]
 10a4e70: f90d2bff     	str	xzr, [sp, #0x1a50]
 10a4e74: 3d814360     	str	q0, [x27, #0x500]
 10a4e78: 3d813f60     	str	q0, [x27, #0x4f0]
 10a4e7c: 3d813b60     	str	q0, [x27, #0x4e0]
<L160>:
 10a4e80: 3d813760     	str	q0, [x27, #0x4d0]
 10a4e84: 3d813360     	str	q0, [x27, #0x4c0]
 10a4e88: 3d812f60     	str	q0, [x27, #0x4b0]
 10a4e8c: 3d812b60     	str	q0, [x27, #0x4a0]
<L161>:
 10a4e90: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10a4e94: f9404fe2     	ldr	x2, [sp, #0x98]
 10a4e98: 2a1f03e1     	mov	w1, wzr
 10a4e9c: 91110000     	add	x0, x0, #0x440
 10a4ea0: 9404fe54     	bl	 <memset>
 10a4ea4: f9406be8     	ldr	x8, [sp, #0xd0]
 10a4ea8: 2a1303e0     	mov	w0, w19
 10a4eac: 911083f9     	add	x25, sp, #0x420
 10a4eb0: 17ffff8a     	b	 <L149>
<L162>:
 10a4eb4: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4eb8: 911083e9     	add	x9, sp, #0x420
 10a4ebc: 3d820520     	str	q0, [x9, #0x810]
 10a4ec0: 3d820120     	str	q0, [x9, #0x800]
 10a4ec4: 3d81fd20     	str	q0, [x9, #0x7f0]
 10a4ec8: 3d81f920     	str	q0, [x9, #0x7e0]
 10a4ecc: 3d81f520     	str	q0, [x9, #0x7d0]
<L163>:
 10a4ed0: f9406be9     	ldr	x9, [sp, #0xd0]
 10a4ed4: 79002128     	strh	w8, [x9, #0x10]
 10a4ed8: 17fff69d     	b	 <L6>
<L164>:
 10a4edc: 6f00e400     	movi	v0.2d, #0000000000000000
 10a4ee0: 3d820720     	str	q0, [x25, #0x810]
 10a4ee4: 3d820320     	str	q0, [x25, #0x800]
 10a4ee8: 3d81ff20     	str	q0, [x25, #0x7f0]
 10a4eec: 3d81fb20     	str	q0, [x25, #0x7e0]
 10a4ef0: 3d81f720     	str	q0, [x25, #0x7d0]
 10a4ef4: f9406be8     	ldr	x8, [sp, #0xd0]
 10a4ef8: 79002100     	strh	w0, [x8, #0x10]
 10a4efc: 17fff694     	b	 <L6>
