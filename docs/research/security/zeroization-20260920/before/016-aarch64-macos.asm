
/tmp/ztls-signoff-20260919/125-before-6d73a0a/016-aarch64-macos.o:	file format mach-o arm64

Disassembly of section __TEXT,__text:

0000000000000000 <ltmp0>:
<L0>:
       0: d10583ff     	sub	sp, sp, #0x160
       4: a9146ffc     	stp	x28, x27, [sp, #0x140]
       8: a9157bfd     	stp	x29, x30, [sp, #0x150]
       c: 910543fd     	add	x29, sp, #0x150
      10: d10103a8     	sub	x8, x29, #0x40
      14: ad400400     	ldp	q0, q1, [x0]
      18: ad000500     	stp	q0, q1, [x8]
      1c: 3dc00800     	ldr	q0, [x0, #0x20]
      20: 3d800900     	str	q0, [x8, #0x20]
      24: 52840008     	mov	w8, #0x2000             ; =8192
      28: 79000be8     	strh	w8, [sp, #0x4]
      2c: 52800128     	mov	w8, #0x9                ; =9
      30: 39001be8     	strb	w8, [sp, #0x6]
      34: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000034:  ARM64_RELOC_PAGE21	___anon_718
      38: 91000108     	add	x8, x8, #0x0
		0000000000000038:  ARM64_RELOC_PAGEOFF12	___anon_718
      3c: f9400108     	ldr	x8, [x8]
      40: f80073e8     	stur	x8, [sp, #0x7]
      44: 52800f28     	mov	w8, #0x79               ; =121
      48: 7800f3e8     	sturh	w8, [sp, #0xf]
      4c: 910013e2     	add	x2, sp, #0x4
      50: d10103a4     	sub	x4, x29, #0x40
      54: aa0103e0     	mov	x0, x1
      58: 52800401     	mov	w1, #0x20               ; =32
      5c: 528001a3     	mov	w3, #0xd                ; =13
<L1>:
      60: 94000000     	bl	 <L1>
		0000000000000060:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
      64: a9557bfd     	ldp	x29, x30, [sp, #0x150]
      68: a9546ffc     	ldp	x28, x27, [sp, #0x140]
      6c: 910583ff     	add	sp, sp, #0x160
      70: d65f03c0     	ret

0000000000000074 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
      74: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
      78: a90167fa     	stp	x26, x25, [sp, #0x10]
      7c: a9025ff8     	stp	x24, x23, [sp, #0x20]
      80: a90357f6     	stp	x22, x21, [sp, #0x30]
      84: a9044ff4     	stp	x20, x19, [sp, #0x40]
      88: a9057bfd     	stp	x29, x30, [sp, #0x50]
      8c: 910143fd     	add	x29, sp, #0x50
      90: d11b43ff     	sub	sp, sp, #0x6d0
      94: aa0303fb     	mov	x27, x3
      98: a90283e2     	stp	x2, x0, [sp, #0x28]
      9c: ad400480     	ldp	q0, q1, [x4]
      a0: ad0987e0     	stp	q0, q1, [sp, #0x130]
      a4: 3dc00880     	ldr	q0, [x4, #0x20]
      a8: 3d8057e0     	str	q0, [sp, #0x150]
      ac: 52800028     	mov	w8, #0x1                ; =1
      b0: 3905bfe8     	strb	w8, [sp, #0x16f]
      b4: 90000009     	adrp	x9, 0x0 <ltmp0>
		00000000000000b4:  ARM64_RELOC_PAGE21	___anon_817
      b8: 91000129     	add	x9, x9, #0x0
		00000000000000b8:  ARM64_RELOC_PAGEOFF12	___anon_817
      bc: f9000fe1     	str	x1, [sp, #0x18]
      c0: f100c03f     	cmp	x1, #0x30
      c4: 54000c02     	b.hs	 <L6>
      c8: f90003ff     	str	xzr, [sp]
<L0>:
      cc: f9400fe9     	ldr	x9, [sp, #0x18]
      d0: f100c128     	subs	x8, x9, #0x30
      d4: 9a883137     	csel	x23, x9, x8, lo
      d8: b4003f57     	cbz	x23,  <L59>
      dc: d2800008     	mov	x8, #0x0                ; =0
      e0: ad4987e0     	ldp	q0, q1, [sp, #0x130]
      e4: ad3907a0     	stp	q0, q1, [x29, #-0xe0]
      e8: 3dc057e0     	ldr	q0, [sp, #0x150]
      ec: 6f00e401     	movi.2d	v1, #0000000000000000
      f0: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
      f4: ad3b07a1     	stp	q1, q1, [x29, #-0xa0]
      f8: 911383e9     	add	x9, sp, #0x4e0
      fc: d10383aa     	sub	x10, x29, #0xe0
     100: 52800b8b     	mov	w11, #0x5c              ; =92
     104: ad3c07a1     	stp	q1, q1, [x29, #-0x80]
<L1>:
     108: 8b08012c     	add	x12, x9, x8
     10c: 3868694d     	ldrb	w13, [x10, x8]
     110: 4a0b01ad     	eor	w13, w13, w11
     114: 3903818d     	strb	w13, [x12, #0xe0]
     118: 91000508     	add	x8, x8, #0x1
     11c: f102011f     	cmp	x8, #0x80
     120: 54ffff41     	b.ne	 <L1>
     124: d2800008     	mov	x8, #0x0                ; =0
     128: d10383a9     	sub	x9, x29, #0xe0
     12c: 528006ca     	mov	w10, #0x36              ; =54
     130: 910c03eb     	add	x11, sp, #0x300
<L2>:
     134: 3868692c     	ldrb	w12, [x9, x8]
     138: 4a0a018c     	eor	w12, w12, w10
     13c: 3828696c     	strb	w12, [x11, x8]
     140: 91000508     	add	x8, x8, #0x1
     144: f102011f     	cmp	x8, #0x80
     148: 54ffff61     	b.ne	 <L2>
     14c: 90000008     	adrp	x8, 0x0 <ltmp0>
		000000000000014c:  ARM64_RELOC_PAGE21	___anon_817
     150: 91000108     	add	x8, x8, #0x0
		0000000000000150:  ARM64_RELOC_PAGEOFF12	___anon_817
     154: ad450500     	ldp	q0, q1, [x8, #0xa0]
     158: ad0883e1     	stp	q1, q0, [sp, #0x110]
     15c: 3d8163e0     	str	q0, [sp, #0x580]
     160: 3d8167e1     	str	q1, [sp, #0x590]
     164: ad460500     	ldp	q0, q1, [x8, #0xc0]
     168: ad0783e1     	stp	q1, q0, [sp, #0xf0]
     16c: 3d816be0     	str	q0, [sp, #0x5a0]
     170: 3d816fe1     	str	q1, [sp, #0x5b0]
     174: ad430500     	ldp	q0, q1, [x8, #0x60]
     178: ad0683e1     	stp	q1, q0, [sp, #0xd0]
     17c: 3d8153e0     	str	q0, [sp, #0x540]
     180: 3d8157e1     	str	q1, [sp, #0x550]
     184: ad440500     	ldp	q0, q1, [x8, #0x80]
     188: ad0583e1     	stp	q1, q0, [sp, #0xb0]
     18c: 3d815be0     	str	q0, [sp, #0x560]
     190: 3d815fe1     	str	q1, [sp, #0x570]
     194: ad410500     	ldp	q0, q1, [x8, #0x20]
     198: ad0483e1     	stp	q1, q0, [sp, #0x90]
     19c: 3d8143e0     	str	q0, [sp, #0x500]
     1a0: 3d8147e1     	str	q1, [sp, #0x510]
     1a4: ad420500     	ldp	q0, q1, [x8, #0x40]
     1a8: 3d801fe0     	str	q0, [sp, #0x70]
     1ac: 3d814be0     	str	q0, [sp, #0x520]
     1b0: 3d8017e1     	str	q1, [sp, #0x50]
     1b4: 3d814fe1     	str	q1, [sp, #0x530]
     1b8: ad400500     	ldp	q0, q1, [x8]
     1bc: 3d8023e0     	str	q0, [sp, #0x80]
     1c0: 3d813be0     	str	q0, [sp, #0x4e0]
     1c4: 3d801be1     	str	q1, [sp, #0x60]
     1c8: 3d813fe1     	str	q1, [sp, #0x4f0]
     1cc: 911383e0     	add	x0, sp, #0x4e0
     1d0: 910c03e1     	add	x1, sp, #0x300
<L3>:
     1d4: 94000000     	bl	 <L3>
		00000000000001d4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     1d8: f94277e8     	ldr	x8, [sp, #0x4e8]
     1dc: f94273e9     	ldr	x9, [sp, #0x4e0]
     1e0: b1020129     	adds	x9, x9, #0x80
     1e4: 9a883508     	cinc	x8, x8, hs
     1e8: f90273e9     	str	x9, [sp, #0x4e0]
     1ec: f90277e8     	str	x8, [sp, #0x4e8]
     1f0: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     1f4: f9400fe9     	ldr	x9, [sp, #0x18]
     1f8: f100bd3f     	cmp	x9, #0x2f
     1fc: 540024a9     	b.ls	 <L39>
     200: 34002228     	cbz	w8,  <L36>
     204: 7101411f     	cmp	w8, #0x50
     208: 540021e3     	b.lo	 <L36>
     20c: 52801009     	mov	w9, #0x80               ; =128
     210: cb080136     	sub	x22, x9, x8
     214: 911383e9     	add	x9, sp, #0x4e0
     218: 91014138     	add	x24, x9, #0x50
     21c: 8b080300     	add	x0, x24, x8
     220: f9401be1     	ldr	x1, [sp, #0x30]
     224: aa1603e2     	mov	x2, x22
<L4>:
     228: 94000000     	bl	 <L4>
		0000000000000228:  ARM64_RELOC_BRANCH26	_memcpy
     22c: 911383e0     	add	x0, sp, #0x4e0
     230: aa1803e1     	mov	x1, x24
<L5>:
     234: 94000000     	bl	 <L5>
		0000000000000234:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     238: 52800008     	mov	w8, #0x0                ; =0
     23c: 3916c3ff     	strb	wzr, [sp, #0x5b0]
     240: 14000102     	b	 <L37>
<L6>:
     244: d280000a     	mov	x10, #0x0               ; =0
     248: d2401b68     	eor	x8, x27, #0x7f
     24c: f90007e8     	str	x8, [sp, #0x8]
     250: 911183fc     	add	x28, sp, #0x460
     254: ad450121     	ldp	q1, q0, [x9, #0xa0]
     258: ad0807e0     	stp	q0, q1, [sp, #0x100]
     25c: 9105c3e8     	add	x8, sp, #0x170
     260: 91014108     	add	x8, x8, #0x50
     264: f90093e8     	str	x8, [sp, #0x120]
     268: 910c03f3     	add	x19, sp, #0x300
     26c: 91014268     	add	x8, x19, #0x50
     270: f90013e8     	str	x8, [sp, #0x20]
     274: ad460121     	ldp	q1, q0, [x9, #0xc0]
     278: ad0707e0     	stp	q0, q1, [sp, #0xe0]
     27c: 52800b95     	mov	w21, #0x5c              ; =92
     280: 528006d6     	mov	w22, #0x36              ; =54
     284: ad430121     	ldp	q1, q0, [x9, #0x60]
     288: ad0607e0     	stp	q0, q1, [sp, #0xc0]
     28c: d10383b4     	sub	x20, x29, #0xe0
     290: ad440121     	ldp	q1, q0, [x9, #0x80]
     294: ad0507e0     	stp	q0, q1, [sp, #0xa0]
     298: ad410121     	ldp	q1, q0, [x9, #0x20]
     29c: ad0407e0     	stp	q0, q1, [sp, #0x80]
     2a0: ad420121     	ldp	q1, q0, [x9, #0x40]
     2a4: ad0307e0     	stp	q0, q1, [sp, #0x60]
     2a8: 52800608     	mov	w8, #0x30               ; =48
     2ac: f90003e8     	str	x8, [sp]
     2b0: 52800039     	mov	w25, #0x1               ; =1
     2b4: 52800038     	mov	w24, #0x1               ; =1
     2b8: ad400121     	ldp	q1, q0, [x9]
     2bc: ad0207e0     	stp	q0, q1, [sp, #0x40]
     2c0: f9000bfb     	str	x27, [sp, #0x10]
     2c4: 1400001b     	b	 <L11>
<L7>:
     2c8: d2800019     	mov	x25, #0x0               ; =0
<L8>:
     2cc: 52800609     	mov	w9, #0x30               ; =48
     2d0: cb19013a     	sub	x26, x9, x25
     2d4: f94013e9     	ldr	x9, [sp, #0x20]
     2d8: 8b284120     	add	x0, x9, w8, uxtw
     2dc: 8b190281     	add	x1, x20, x25
     2e0: aa1a03e2     	mov	x2, x26
<L9>:
     2e4: 94000000     	bl	 <L9>
		00000000000002e4:  ARM64_RELOC_BRANCH26	_memcpy
     2e8: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     2ec: 0b1a0108     	add	w8, w8, w26
     2f0: 390f43e8     	strb	w8, [sp, #0x3d0]
     2f4: b100c368     	adds	x8, x27, #0x30
     2f8: 9a9736e9     	cinc	x9, x23, hs
     2fc: f90187e9     	str	x9, [sp, #0x308]
     300: f90183e8     	str	x8, [sp, #0x300]
     304: 910c03e0     	add	x0, sp, #0x300
     308: a94327e8     	ldp	x8, x9, [sp, #0x30]
     30c: 8b090101     	add	x1, x8, x9
<L10>:
     310: 94000000     	bl	 <L10>
		0000000000000310:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     314: 52800019     	mov	w25, #0x0               ; =0
     318: 11000718     	add	w24, w24, #0x1
     31c: 3905bff8     	strb	w24, [sp, #0x16f]
     320: 5280060a     	mov	w10, #0x30              ; =48
     324: a94123fb     	ldp	x27, x8, [sp, #0x10]
     328: f101811f     	cmp	x8, #0x60
     32c: 54ffed03     	b.lo	 <L0>
<L11>:
     330: f9001fea     	str	x10, [sp, #0x38]
     334: d2800008     	mov	x8, #0x0                ; =0
     338: ad4987e0     	ldp	q0, q1, [sp, #0x130]
     33c: 3d811be0     	str	q0, [sp, #0x460]
     340: 3d811fe1     	str	q1, [sp, #0x470]
     344: 3dc057e0     	ldr	q0, [sp, #0x150]
     348: 3d8123e0     	str	q0, [sp, #0x480]
     34c: 6f00e400     	movi.2d	v0, #0000000000000000
     350: ad018380     	stp	q0, q0, [x28, #0x30]
     354: ad028380     	stp	q0, q0, [x28, #0x50]
     358: 3c870380     	stur	q0, [x28, #0x70]
<L12>:
     35c: 8b080269     	add	x9, x19, x8
     360: 38686b8a     	ldrb	w10, [x28, x8]
     364: 4a15014a     	eor	w10, w10, w21
     368: 3903812a     	strb	w10, [x9, #0xe0]
     36c: 91000508     	add	x8, x8, #0x1
     370: f102011f     	cmp	x8, #0x80
     374: 54ffff41     	b.ne	 <L12>
     378: d2800008     	mov	x8, #0x0                ; =0
<L13>:
     37c: 38686b89     	ldrb	w9, [x28, x8]
     380: 4a160129     	eor	w9, w9, w22
     384: 38286a89     	strb	w9, [x20, x8]
     388: 91000508     	add	x8, x8, #0x1
     38c: f102011f     	cmp	x8, #0x80
     390: 54ffff61     	b.ne	 <L13>
     394: ad4807e0     	ldp	q0, q1, [sp, #0x100]
     398: ad1d03e1     	stp	q1, q0, [sp, #0x3a0]
     39c: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
     3a0: ad1e03e1     	stp	q1, q0, [sp, #0x3c0]
     3a4: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
     3a8: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     3ac: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
     3b0: ad1c03e1     	stp	q1, q0, [sp, #0x380]
     3b4: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     3b8: ad1903e1     	stp	q1, q0, [sp, #0x320]
     3bc: ad4307e0     	ldp	q0, q1, [sp, #0x60]
     3c0: ad1a03e1     	stp	q1, q0, [sp, #0x340]
     3c4: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     3c8: ad1803e1     	stp	q1, q0, [sp, #0x300]
     3cc: 910c03e0     	add	x0, sp, #0x300
     3d0: d10383a1     	sub	x1, x29, #0xe0
<L14>:
     3d4: 94000000     	bl	 <L14>
		00000000000003d4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     3d8: f94187e8     	ldr	x8, [sp, #0x308]
     3dc: f94183e9     	ldr	x9, [sp, #0x300]
     3e0: b1020129     	adds	x9, x9, #0x80
     3e4: 9a883508     	cinc	x8, x8, hs
     3e8: f90183e9     	str	x9, [sp, #0x300]
     3ec: f90187e8     	str	x8, [sp, #0x308]
     3f0: 9105c3e0     	add	x0, sp, #0x170
     3f4: 910c03e1     	add	x1, sp, #0x300
     3f8: 52802c02     	mov	w2, #0x160              ; =352
<L15>:
     3fc: 94000000     	bl	 <L15>
		00000000000003fc:  ARM64_RELOC_BRANCH26	_memcpy
     400: 394903e8     	ldrb	w8, [sp, #0x240]
     404: 37000439     	tbnz	w25, #0x0,  <L21>
     408: 34000208     	cbz	w8,  <L18>
     40c: 7101411f     	cmp	w8, #0x50
     410: 540001c3     	b.lo	 <L18>
     414: 52801009     	mov	w9, #0x80               ; =128
     418: cb080139     	sub	x25, x9, x8
     41c: f94093f7     	ldr	x23, [sp, #0x120]
     420: 8b0802e0     	add	x0, x23, x8
     424: f9401be1     	ldr	x1, [sp, #0x30]
     428: aa1903e2     	mov	x2, x25
<L16>:
     42c: 94000000     	bl	 <L16>
		000000000000042c:  ARM64_RELOC_BRANCH26	_memcpy
     430: 9105c3e0     	add	x0, sp, #0x170
     434: aa1703e1     	mov	x1, x23
<L17>:
     438: 94000000     	bl	 <L17>
		0000000000000438:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     43c: 52800008     	mov	w8, #0x0                ; =0
     440: 390903ff     	strb	wzr, [sp, #0x240]
     444: 14000002     	b	 <L19>
<L18>:
     448: d2800019     	mov	x25, #0x0               ; =0
<L19>:
     44c: 52800609     	mov	w9, #0x30               ; =48
     450: cb19013a     	sub	x26, x9, x25
     454: f94093e9     	ldr	x9, [sp, #0x120]
     458: 8b284120     	add	x0, x9, w8, uxtw
     45c: f9401be8     	ldr	x8, [sp, #0x30]
     460: 8b190101     	add	x1, x8, x25
     464: aa1a03e2     	mov	x2, x26
<L20>:
     468: 94000000     	bl	 <L20>
		0000000000000468:  ARM64_RELOC_BRANCH26	_memcpy
     46c: 394903e8     	ldrb	w8, [sp, #0x240]
     470: 0b1a0108     	add	w8, w8, w26
     474: 390903e8     	strb	w8, [sp, #0x240]
     478: a95727ea     	ldp	x10, x9, [sp, #0x170]
     47c: b100c14a     	adds	x10, x10, #0x30
     480: 9a893529     	cinc	x9, x9, hs
     484: a91727ea     	stp	x10, x9, [sp, #0x170]
<L21>:
     488: 34000248     	cbz	w8,  <L24>
     48c: 2a0803e9     	mov	w9, w8
     490: f94007ea     	ldr	x10, [sp, #0x8]
     494: eb09015f     	cmp	x10, x9
     498: 540001c2     	b.hs	 <L24>
     49c: 5280100a     	mov	w10, #0x80              ; =128
     4a0: 4b080159     	sub	w25, w10, w8
     4a4: f94093f7     	ldr	x23, [sp, #0x120]
     4a8: 8b0902e0     	add	x0, x23, x9
     4ac: f94017e1     	ldr	x1, [sp, #0x28]
     4b0: aa1903e2     	mov	x2, x25
<L22>:
     4b4: 94000000     	bl	 <L22>
		00000000000004b4:  ARM64_RELOC_BRANCH26	_memcpy
     4b8: 9105c3e0     	add	x0, sp, #0x170
     4bc: aa1703e1     	mov	x1, x23
<L23>:
     4c0: 94000000     	bl	 <L23>
		00000000000004c0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     4c4: 52800008     	mov	w8, #0x0                ; =0
     4c8: 390903ff     	strb	wzr, [sp, #0x240]
     4cc: 14000002     	b	 <L25>
<L24>:
     4d0: d2800019     	mov	x25, #0x0               ; =0
<L25>:
     4d4: cb19037a     	sub	x26, x27, x25
     4d8: f94093e9     	ldr	x9, [sp, #0x120]
     4dc: 8b284120     	add	x0, x9, w8, uxtw
     4e0: f94017e8     	ldr	x8, [sp, #0x28]
     4e4: 8b190101     	add	x1, x8, x25
     4e8: aa1a03e2     	mov	x2, x26
<L26>:
     4ec: 94000000     	bl	 <L26>
		00000000000004ec:  ARM64_RELOC_BRANCH26	_memcpy
     4f0: 394903e8     	ldrb	w8, [sp, #0x240]
     4f4: a95727ea     	ldp	x10, x9, [sp, #0x170]
     4f8: ab1b0157     	adds	x23, x10, x27
     4fc: 9a89353b     	cinc	x27, x9, hs
     500: a9176ff7     	stp	x23, x27, [sp, #0x170]
     504: 0b1a0108     	add	w8, w8, w26
     508: 390903e8     	strb	w8, [sp, #0x240]
     50c: 34000228     	cbz	w8,  <L29>
     510: 7101fd1f     	cmp	w8, #0x7f
     514: 540001e3     	b.lo	 <L29>
     518: 52801009     	mov	w9, #0x80               ; =128
     51c: 4b080139     	sub	w25, w9, w8
     520: f94093f7     	ldr	x23, [sp, #0x120]
     524: 8b2842e0     	add	x0, x23, w8, uxtw
     528: 9105bfe1     	add	x1, sp, #0x16f
     52c: aa1903e2     	mov	x2, x25
<L27>:
     530: 94000000     	bl	 <L27>
		0000000000000530:  ARM64_RELOC_BRANCH26	_memcpy
     534: 9105c3e0     	add	x0, sp, #0x170
     538: aa1703e1     	mov	x1, x23
<L28>:
     53c: 94000000     	bl	 <L28>
		000000000000053c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     540: 52800008     	mov	w8, #0x0                ; =0
     544: 390903ff     	strb	wzr, [sp, #0x240]
     548: a9576ff7     	ldp	x23, x27, [sp, #0x170]
     54c: 14000002     	b	 <L30>
<L29>:
     550: d2800019     	mov	x25, #0x0               ; =0
<L30>:
     554: 52800029     	mov	w9, #0x1                ; =1
     558: cb19013a     	sub	x26, x9, x25
     55c: f94093e9     	ldr	x9, [sp, #0x120]
     560: 8b284120     	add	x0, x9, w8, uxtw
     564: 9105bfe8     	add	x8, sp, #0x16f
     568: 8b190101     	add	x1, x8, x25
     56c: aa1a03e2     	mov	x2, x26
<L31>:
     570: 94000000     	bl	 <L31>
		0000000000000570:  ARM64_RELOC_BRANCH26	_memcpy
     574: 394903e8     	ldrb	w8, [sp, #0x240]
     578: 0b1a0108     	add	w8, w8, w26
     57c: 390903e8     	strb	w8, [sp, #0x240]
     580: b10006e8     	adds	x8, x23, #0x1
     584: 9a9b3769     	cinc	x9, x27, hs
     588: a91727e8     	stp	x8, x9, [sp, #0x170]
     58c: 9105c3e0     	add	x0, sp, #0x170
     590: d10383a1     	sub	x1, x29, #0xe0
<L32>:
     594: 94000000     	bl	 <L32>
		0000000000000594:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     598: ad4807e0     	ldp	q0, q1, [sp, #0x100]
     59c: ad1d03e1     	stp	q1, q0, [sp, #0x3a0]
     5a0: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
     5a4: ad1e03e1     	stp	q1, q0, [sp, #0x3c0]
     5a8: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
     5ac: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     5b0: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
     5b4: ad1c03e1     	stp	q1, q0, [sp, #0x380]
     5b8: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     5bc: ad1903e1     	stp	q1, q0, [sp, #0x320]
     5c0: ad4307e0     	ldp	q0, q1, [sp, #0x60]
     5c4: ad1a03e1     	stp	q1, q0, [sp, #0x340]
     5c8: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     5cc: ad1803e1     	stp	q1, q0, [sp, #0x300]
     5d0: 910c03e0     	add	x0, sp, #0x300
     5d4: 9105c3e8     	add	x8, sp, #0x170
     5d8: 91038101     	add	x1, x8, #0xe0
<L33>:
     5dc: 94000000     	bl	 <L33>
		00000000000005dc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     5e0: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     5e4: f94187e9     	ldr	x9, [sp, #0x308]
     5e8: f94183ea     	ldr	x10, [sp, #0x300]
     5ec: b102015b     	adds	x27, x10, #0x80
     5f0: 9a893537     	cinc	x23, x9, hs
     5f4: f90183fb     	str	x27, [sp, #0x300]
     5f8: f90187f7     	str	x23, [sp, #0x308]
     5fc: 34ffe668     	cbz	w8,  <L7>
     600: 7101411f     	cmp	w8, #0x50
     604: 54ffe623     	b.lo	 <L7>
     608: 52801009     	mov	w9, #0x80               ; =128
     60c: cb080139     	sub	x25, x9, x8
     610: f94013f7     	ldr	x23, [sp, #0x20]
     614: 8b0802e0     	add	x0, x23, x8
     618: d10383a1     	sub	x1, x29, #0xe0
     61c: aa1903e2     	mov	x2, x25
<L34>:
     620: 94000000     	bl	 <L34>
		0000000000000620:  ARM64_RELOC_BRANCH26	_memcpy
     624: 910c03e0     	add	x0, sp, #0x300
     628: aa1703e1     	mov	x1, x23
<L35>:
     62c: 94000000     	bl	 <L35>
		000000000000062c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     630: 52800008     	mov	w8, #0x0                ; =0
     634: 390f43ff     	strb	wzr, [sp, #0x3d0]
     638: f94187f7     	ldr	x23, [sp, #0x308]
     63c: f94183fb     	ldr	x27, [sp, #0x300]
     640: 17ffff23     	b	 <L8>
<L36>:
     644: d2800016     	mov	x22, #0x0               ; =0
<L37>:
     648: 52800609     	mov	w9, #0x30               ; =48
     64c: cb160138     	sub	x24, x9, x22
     650: 911383e9     	add	x9, sp, #0x4e0
     654: 8b284128     	add	x8, x9, w8, uxtw
     658: 91014100     	add	x0, x8, #0x50
     65c: f9401be8     	ldr	x8, [sp, #0x30]
     660: 8b160101     	add	x1, x8, x22
     664: aa1803e2     	mov	x2, x24
<L38>:
     668: 94000000     	bl	 <L38>
		0000000000000668:  ARM64_RELOC_BRANCH26	_memcpy
     66c: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     670: 0b180108     	add	w8, w8, w24
     674: 3916c3e8     	strb	w8, [sp, #0x5b0]
     678: f94277e9     	ldr	x9, [sp, #0x4e8]
     67c: f94273ea     	ldr	x10, [sp, #0x4e0]
     680: b100c14a     	adds	x10, x10, #0x30
     684: 9a893529     	cinc	x9, x9, hs
     688: f90273ea     	str	x10, [sp, #0x4e0]
     68c: f90277e9     	str	x9, [sp, #0x4e8]
<L39>:
     690: 34000268     	cbz	w8,  <L42>
     694: 2a0803e9     	mov	w9, w8
     698: 8b09036a     	add	x10, x27, x9
     69c: f102015f     	cmp	x10, #0x80
     6a0: 540001e3     	b.lo	 <L42>
     6a4: 5280100a     	mov	w10, #0x80              ; =128
     6a8: 4b080158     	sub	w24, w10, w8
     6ac: 911383e8     	add	x8, sp, #0x4e0
     6b0: 91014116     	add	x22, x8, #0x50
     6b4: 8b0902c0     	add	x0, x22, x9
     6b8: f94017e1     	ldr	x1, [sp, #0x28]
     6bc: aa1803e2     	mov	x2, x24
<L40>:
     6c0: 94000000     	bl	 <L40>
		00000000000006c0:  ARM64_RELOC_BRANCH26	_memcpy
     6c4: 911383e0     	add	x0, sp, #0x4e0
     6c8: aa1603e1     	mov	x1, x22
<L41>:
     6cc: 94000000     	bl	 <L41>
		00000000000006cc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     6d0: 52800008     	mov	w8, #0x0                ; =0
     6d4: 3916c3ff     	strb	wzr, [sp, #0x5b0]
     6d8: 14000002     	b	 <L43>
<L42>:
     6dc: d2800018     	mov	x24, #0x0               ; =0
<L43>:
     6e0: cb180379     	sub	x25, x27, x24
     6e4: 911383f3     	add	x19, sp, #0x4e0
     6e8: 91014276     	add	x22, x19, #0x50
     6ec: 8b2842c0     	add	x0, x22, w8, uxtw
     6f0: f94017e8     	ldr	x8, [sp, #0x28]
     6f4: 8b180101     	add	x1, x8, x24
     6f8: aa1903e2     	mov	x2, x25
<L44>:
     6fc: 94000000     	bl	 <L44>
		00000000000006fc:  ARM64_RELOC_BRANCH26	_memcpy
     700: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     704: f94277e9     	ldr	x9, [sp, #0x4e8]
     708: f94273ea     	ldr	x10, [sp, #0x4e0]
     70c: ab1b015a     	adds	x26, x10, x27
     710: 9a893538     	cinc	x24, x9, hs
     714: f90273fa     	str	x26, [sp, #0x4e0]
     718: f90277f8     	str	x24, [sp, #0x4e8]
     71c: 0b190108     	add	w8, w8, w25
     720: 3916c3e8     	strb	w8, [sp, #0x5b0]
     724: 34000228     	cbz	w8,  <L47>
     728: 7101fd1f     	cmp	w8, #0x7f
     72c: 540001e3     	b.lo	 <L47>
     730: 52801009     	mov	w9, #0x80               ; =128
     734: 4b080134     	sub	w20, w9, w8
     738: 8b2842c0     	add	x0, x22, w8, uxtw
     73c: 9105bfe1     	add	x1, sp, #0x16f
     740: aa1403e2     	mov	x2, x20
<L45>:
     744: 94000000     	bl	 <L45>
		0000000000000744:  ARM64_RELOC_BRANCH26	_memcpy
     748: 911383e0     	add	x0, sp, #0x4e0
     74c: aa1603e1     	mov	x1, x22
<L46>:
     750: 94000000     	bl	 <L46>
		0000000000000750:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     754: 52800008     	mov	w8, #0x0                ; =0
     758: 3916c3ff     	strb	wzr, [sp, #0x5b0]
     75c: f94277f8     	ldr	x24, [sp, #0x4e8]
     760: f94273fa     	ldr	x26, [sp, #0x4e0]
     764: 14000002     	b	 <L48>
<L47>:
     768: d2800014     	mov	x20, #0x0               ; =0
<L48>:
     76c: 9105bfe9     	add	x9, sp, #0x16f
     770: 5280002a     	mov	w10, #0x1               ; =1
     774: cb140155     	sub	x21, x10, x20
     778: 8b2842c0     	add	x0, x22, w8, uxtw
     77c: 8b140121     	add	x1, x9, x20
     780: aa1503e2     	mov	x2, x21
<L49>:
     784: 94000000     	bl	 <L49>
		0000000000000784:  ARM64_RELOC_BRANCH26	_memcpy
     788: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     78c: 0b150108     	add	w8, w8, w21
     790: 3916c3e8     	strb	w8, [sp, #0x5b0]
     794: b1000748     	adds	x8, x26, #0x1
     798: 9a983709     	cinc	x9, x24, hs
     79c: f90277e9     	str	x9, [sp, #0x4e8]
     7a0: f90273e8     	str	x8, [sp, #0x4e0]
     7a4: d10383b8     	sub	x24, x29, #0xe0
     7a8: 911383e0     	add	x0, sp, #0x4e0
     7ac: d10383a1     	sub	x1, x29, #0xe0
<L50>:
     7b0: 94000000     	bl	 <L50>
		00000000000007b0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     7b4: ad4887e0     	ldp	q0, q1, [sp, #0x110]
     7b8: ad1d03e1     	stp	q1, q0, [sp, #0x3a0]
     7bc: ad4787e0     	ldp	q0, q1, [sp, #0xf0]
     7c0: ad1e03e1     	stp	q1, q0, [sp, #0x3c0]
     7c4: ad4687e0     	ldp	q0, q1, [sp, #0xd0]
     7c8: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     7cc: ad4587e0     	ldp	q0, q1, [sp, #0xb0]
     7d0: ad1c03e1     	stp	q1, q0, [sp, #0x380]
     7d4: ad4487e0     	ldp	q0, q1, [sp, #0x90]
     7d8: ad1903e1     	stp	q1, q0, [sp, #0x320]
     7dc: 3dc01fe1     	ldr	q1, [sp, #0x70]
     7e0: ad4283e2     	ldp	q2, q0, [sp, #0x50]
     7e4: ad1a0be1     	stp	q1, q2, [sp, #0x340]
     7e8: 910c03e8     	add	x8, sp, #0x300
     7ec: 91014114     	add	x20, x8, #0x50
     7f0: 3dc023e1     	ldr	q1, [sp, #0x80]
     7f4: ad1803e1     	stp	q1, q0, [sp, #0x300]
     7f8: 910c03e0     	add	x0, sp, #0x300
     7fc: 91038261     	add	x1, x19, #0xe0
<L51>:
     800: 94000000     	bl	 <L51>
		0000000000000800:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     804: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     808: f94187e9     	ldr	x9, [sp, #0x308]
     80c: f94183ea     	ldr	x10, [sp, #0x300]
     810: b1020159     	adds	x25, x10, #0x80
     814: 9a893533     	cinc	x19, x9, hs
     818: f90183f9     	str	x25, [sp, #0x300]
     81c: f90187f3     	str	x19, [sp, #0x308]
     820: 34000228     	cbz	w8,  <L54>
     824: 7101411f     	cmp	w8, #0x50
     828: 540001e3     	b.lo	 <L54>
     82c: 52801009     	mov	w9, #0x80               ; =128
     830: cb080135     	sub	x21, x9, x8
     834: 8b080280     	add	x0, x20, x8
     838: d10383a1     	sub	x1, x29, #0xe0
     83c: aa1503e2     	mov	x2, x21
<L52>:
     840: 94000000     	bl	 <L52>
		0000000000000840:  ARM64_RELOC_BRANCH26	_memcpy
     844: 910c03e0     	add	x0, sp, #0x300
     848: aa1403e1     	mov	x1, x20
<L53>:
     84c: 94000000     	bl	 <L53>
		000000000000084c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     850: 52800008     	mov	w8, #0x0                ; =0
     854: 390f43ff     	strb	wzr, [sp, #0x3d0]
     858: f94187f3     	ldr	x19, [sp, #0x308]
     85c: f94183f9     	ldr	x25, [sp, #0x300]
     860: 14000002     	b	 <L55>
<L54>:
     864: d2800015     	mov	x21, #0x0               ; =0
<L55>:
     868: 52800609     	mov	w9, #0x30               ; =48
     86c: cb150136     	sub	x22, x9, x21
     870: 8b284280     	add	x0, x20, w8, uxtw
     874: 8b150301     	add	x1, x24, x21
     878: aa1603e2     	mov	x2, x22
<L56>:
     87c: 94000000     	bl	 <L56>
		000000000000087c:  ARM64_RELOC_BRANCH26	_memcpy
     880: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     884: 0b160108     	add	w8, w8, w22
     888: 390f43e8     	strb	w8, [sp, #0x3d0]
     88c: b100c328     	adds	x8, x25, #0x30
     890: 9a933669     	cinc	x9, x19, hs
     894: f90187e9     	str	x9, [sp, #0x308]
     898: f90183e8     	str	x8, [sp, #0x300]
     89c: 910c03e0     	add	x0, sp, #0x300
     8a0: 910b43e1     	add	x1, sp, #0x2d0
<L57>:
     8a4: 94000000     	bl	 <L57>
		00000000000008a4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     8a8: f9401be8     	ldr	x8, [sp, #0x30]
     8ac: f94003e9     	ldr	x9, [sp]
     8b0: 8b090100     	add	x0, x8, x9
     8b4: 910b43e1     	add	x1, sp, #0x2d0
     8b8: aa1703e2     	mov	x2, x23
<L58>:
     8bc: 94000000     	bl	 <L58>
		00000000000008bc:  ARM64_RELOC_BRANCH26	_memcpy
<L59>:
     8c0: 911b43ff     	add	sp, sp, #0x6d0
     8c4: a9457bfd     	ldp	x29, x30, [sp, #0x50]
     8c8: a9444ff4     	ldp	x20, x19, [sp, #0x40]
     8cc: a94357f6     	ldp	x22, x21, [sp, #0x30]
     8d0: a9425ff8     	ldp	x24, x23, [sp, #0x20]
     8d4: a94167fa     	ldp	x26, x25, [sp, #0x10]
     8d8: a8c66ffc     	ldp	x28, x27, [sp], #0x60
     8dc: d65f03c0     	ret

00000000000008e0 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
     8e0: a9bd6ffc     	stp	x28, x27, [sp, #-0x30]!
     8e4: a9014ff4     	stp	x20, x19, [sp, #0x10]
     8e8: a9027bfd     	stp	x29, x30, [sp, #0x20]
     8ec: 910083fd     	add	x29, sp, #0x20
     8f0: d10a03ff     	sub	sp, sp, #0x280
     8f4: ad400420     	ldp	q0, q1, [x1]
     8f8: 4e200800     	rev64.16b	v0, v0
     8fc: 4e200821     	rev64.16b	v1, v1
     900: ad0007e0     	stp	q0, q1, [sp]
     904: ad410821     	ldp	q1, q2, [x1, #0x20]
     908: 4e200821     	rev64.16b	v1, v1
     90c: 4e200842     	rev64.16b	v2, v2
     910: ad010be1     	stp	q1, q2, [sp, #0x20]
     914: ad420821     	ldp	q1, q2, [x1, #0x40]
     918: 4e200821     	rev64.16b	v1, v1
     91c: 4e200842     	rev64.16b	v2, v2
     920: ad020be1     	stp	q1, q2, [sp, #0x40]
     924: ad430821     	ldp	q1, q2, [x1, #0x60]
     928: 4e200821     	rev64.16b	v1, v1
     92c: 4e200842     	rev64.16b	v2, v2
     930: ad030be1     	stp	q1, q2, [sp, #0x60]
     934: 910003e8     	mov	x8, sp
     938: 91020108     	add	x8, x8, #0x80
     93c: 52800809     	mov	w9, #0x40               ; =64
<L0>:
     940: a9782d0a     	ldp	x10, x11, [x8, #-0x80]
     944: 93cb056c     	ror	x12, x11, #0x1
     948: cacb218c     	eor	x12, x12, x11, ror #8
     94c: ca4b1d8b     	eor	x11, x12, x11, lsr #7
     950: f85c810c     	ldur	x12, [x8, #-0x38]
     954: 8b0a018a     	add	x10, x12, x10
     958: 8b0b014a     	add	x10, x10, x11
     95c: f85f010b     	ldur	x11, [x8, #-0x10]
     960: 93cb4d6c     	ror	x12, x11, #0x13
     964: cacbf58c     	eor	x12, x12, x11, ror #61
     968: ca4b198b     	eor	x11, x12, x11, lsr #6
     96c: 8b0b014a     	add	x10, x10, x11
     970: f800850a     	str	x10, [x8], #0x8
     974: f1000529     	subs	x9, x9, #0x1
     978: 54fffe41     	b.ne	 <L0>
     97c: a940a7ea     	ldp	x10, x9, [sp, #0x8]
     980: a942a00b     	ldp	x11, x8, [x0, #0x28]
     984: 93c8390d     	ror	x13, x8, #0xe
     988: a941080c     	ldp	x12, x2, [x0, #0x10]
     98c: cac849ad     	eor	x13, x13, x8, ror #18
     990: cac8a5b0     	eor	x16, x13, x8, ror #41
     994: a9438c0d     	ldp	x13, x3, [x0, #0x38]
     998: 8a28006f     	bic	x15, x3, x8
     99c: a943100e     	ldp	x14, x4, [x0, #0x30]
     9a0: 8a080091     	and	x17, x4, x8
     9a4: aa0f0231     	orr	x17, x17, x15
     9a8: 9e660001     	fmov	x1, d0
     9ac: a944140f     	ldp	x15, x5, [x0, #0x40]
     9b0: 8b0100a1     	add	x1, x5, x1
     9b4: 8b110031     	add	x17, x1, x17
     9b8: d295c441     	mov	x1, #0xae22             ; =44578
     9bc: f2bae501     	movk	x1, #0xd728, lsl #16
     9c0: f2c5f301     	movk	x1, #0x2f98, lsl #32
     9c4: f2e85141     	movk	x1, #0x428a, lsl #48
     9c8: 8b010231     	add	x17, x17, x1
     9cc: 8b110205     	add	x5, x16, x17
     9d0: 93cc7190     	ror	x16, x12, #0x1c
     9d4: cacc8a10     	eor	x16, x16, x12, ror #34
     9d8: cacc9e11     	eor	x17, x16, x12, ror #39
     9dc: a9419c10     	ldp	x16, x7, [x0, #0x18]
     9e0: aa0200e1     	orr	x1, x7, x2
     9e4: 8a0c0021     	and	x1, x1, x12
     9e8: 8a0200e6     	and	x6, x7, x2
     9ec: aa060021     	orr	x1, x1, x6
     9f0: 8b110031     	add	x17, x1, x17
     9f4: 8b050221     	add	x1, x17, x5
     9f8: a9421811     	ldp	x17, x6, [x0, #0x20]
     9fc: 8b0600a6     	add	x6, x5, x6
     a00: 8a260085     	bic	x5, x4, x6
     a04: 93c638d3     	ror	x19, x6, #0xe
     a08: cac64a73     	eor	x19, x19, x6, ror #18
     a0c: cac6a673     	eor	x19, x19, x6, ror #41
     a10: 8a060114     	and	x20, x8, x6
     a14: aa050285     	orr	x5, x20, x5
     a18: 8b0a006a     	add	x10, x3, x10
     a1c: 8b05014a     	add	x10, x10, x5
     a20: d28cb9a3     	mov	x3, #0x65cd             ; =26061
     a24: f2a47de3     	movk	x3, #0x23ef, lsl #16
     a28: f2c89223     	movk	x3, #0x4491, lsl #32
     a2c: f2ee26e3     	movk	x3, #0x7137, lsl #48
     a30: 8b03014a     	add	x10, x10, x3
     a34: 8b130143     	add	x3, x10, x19
     a38: 93c1702a     	ror	x10, x1, #0x1c
     a3c: cac1894a     	eor	x10, x10, x1, ror #34
     a40: cac19d4a     	eor	x10, x10, x1, ror #39
     a44: aa0c0045     	orr	x5, x2, x12
     a48: 8a050025     	and	x5, x1, x5
     a4c: 8a0c0053     	and	x19, x2, x12
     a50: aa1300a5     	orr	x5, x5, x19
     a54: 8b05014a     	add	x10, x10, x5
     a58: 8b03014a     	add	x10, x10, x3
     a5c: 8b070063     	add	x3, x3, x7
     a60: 8a230105     	bic	x5, x8, x3
     a64: 93c33867     	ror	x7, x3, #0xe
     a68: cac348e7     	eor	x7, x7, x3, ror #18
     a6c: cac3a4e7     	eor	x7, x7, x3, ror #41
     a70: 8a0300d3     	and	x19, x6, x3
     a74: aa050265     	orr	x5, x19, x5
     a78: 8b090089     	add	x9, x4, x9
     a7c: 8b050129     	add	x9, x9, x5
     a80: d28765e4     	mov	x4, #0x3b2f             ; =15151
     a84: f2bd89a4     	movk	x4, #0xec4d, lsl #16
     a88: f2df79e4     	movk	x4, #0xfbcf, lsl #32
     a8c: f2f6b804     	movk	x4, #0xb5c0, lsl #48
     a90: 8b040129     	add	x9, x9, x4
     a94: 8b070124     	add	x4, x9, x7
     a98: 93ca7149     	ror	x9, x10, #0x1c
     a9c: caca8929     	eor	x9, x9, x10, ror #34
     aa0: caca9d29     	eor	x9, x9, x10, ror #39
     aa4: aa0c0025     	orr	x5, x1, x12
     aa8: 8a050145     	and	x5, x10, x5
     aac: 8a0c0027     	and	x7, x1, x12
     ab0: aa0700a5     	orr	x5, x5, x7
     ab4: 8b050129     	add	x9, x9, x5
     ab8: 8b040129     	add	x9, x9, x4
     abc: 8b020084     	add	x4, x4, x2
     ac0: 8a2400c2     	bic	x2, x6, x4
     ac4: 93c43885     	ror	x5, x4, #0xe
     ac8: cac448a5     	eor	x5, x5, x4, ror #18
     acc: cac4a4a5     	eor	x5, x5, x4, ror #41
     ad0: 8a040067     	and	x7, x3, x4
     ad4: aa0200e2     	orr	x2, x7, x2
     ad8: a941cfe7     	ldp	x7, x19, [sp, #0x18]
     adc: 8b070108     	add	x8, x8, x7
     ae0: 8b020108     	add	x8, x8, x2
     ae4: d29b7782     	mov	x2, #0xdbbc             ; =56252
     ae8: f2b03122     	movk	x2, #0x8189, lsl #16
     aec: f2db74a2     	movk	x2, #0xdba5, lsl #32
     af0: f2fd36a2     	movk	x2, #0xe9b5, lsl #48
     af4: 8b020108     	add	x8, x8, x2
     af8: 8b050102     	add	x2, x8, x5
     afc: 93c97128     	ror	x8, x9, #0x1c
     b00: cac98908     	eor	x8, x8, x9, ror #34
     b04: cac99d08     	eor	x8, x8, x9, ror #39
     b08: aa010145     	orr	x5, x10, x1
     b0c: 8a050125     	and	x5, x9, x5
     b10: 8a010147     	and	x7, x10, x1
     b14: aa0700a5     	orr	x5, x5, x7
     b18: 8b050108     	add	x8, x8, x5
     b1c: 8b020108     	add	x8, x8, x2
     b20: 8b0c0045     	add	x5, x2, x12
     b24: 8a250062     	bic	x2, x3, x5
     b28: 93c538a7     	ror	x7, x5, #0xe
     b2c: cac548e7     	eor	x7, x7, x5, ror #18
     b30: cac5a4e7     	eor	x7, x7, x5, ror #41
     b34: 8a050094     	and	x20, x4, x5
     b38: aa020282     	orr	x2, x20, x2
     b3c: 8b060266     	add	x6, x19, x6
     b40: 8b0200c2     	add	x2, x6, x2
     b44: d296a706     	mov	x6, #0xb538             ; =46392
     b48: f2be6906     	movk	x6, #0xf348, lsl #16
     b4c: f2d84b66     	movk	x6, #0xc25b, lsl #32
     b50: f2e72ac6     	movk	x6, #0x3956, lsl #48
     b54: 8b060042     	add	x2, x2, x6
     b58: 8b070046     	add	x6, x2, x7
     b5c: 93c87102     	ror	x2, x8, #0x1c
     b60: cac88842     	eor	x2, x2, x8, ror #34
     b64: cac89c42     	eor	x2, x2, x8, ror #39
     b68: aa0a0127     	orr	x7, x9, x10
     b6c: 8a070107     	and	x7, x8, x7
     b70: 8a0a0133     	and	x19, x9, x10
     b74: aa1300e7     	orr	x7, x7, x19
     b78: 8b070042     	add	x2, x2, x7
     b7c: 8b060042     	add	x2, x2, x6
     b80: 8b0100c6     	add	x6, x6, x1
     b84: 8a260081     	bic	x1, x4, x6
     b88: 93c638c7     	ror	x7, x6, #0xe
     b8c: cac648e7     	eor	x7, x7, x6, ror #18
     b90: cac6a4e7     	eor	x7, x7, x6, ror #41
     b94: 8a0600b3     	and	x19, x5, x6
     b98: aa010261     	orr	x1, x19, x1
     b9c: a942d3f3     	ldp	x19, x20, [sp, #0x28]
     ba0: 8b030263     	add	x3, x19, x3
     ba4: 8b010061     	add	x1, x3, x1
     ba8: d29a0323     	mov	x3, #0xd019             ; =53273
     bac: f2b6c0a3     	movk	x3, #0xb605, lsl #16
     bb0: f2c23e23     	movk	x3, #0x11f1, lsl #32
     bb4: f2eb3e23     	movk	x3, #0x59f1, lsl #48
     bb8: 8b030021     	add	x1, x1, x3
     bbc: 8b070023     	add	x3, x1, x7
     bc0: 93c27041     	ror	x1, x2, #0x1c
     bc4: cac28821     	eor	x1, x1, x2, ror #34
     bc8: cac29c21     	eor	x1, x1, x2, ror #39
     bcc: aa090107     	orr	x7, x8, x9
     bd0: 8a070047     	and	x7, x2, x7
     bd4: 8a090113     	and	x19, x8, x9
     bd8: aa1300e7     	orr	x7, x7, x19
     bdc: 8b070021     	add	x1, x1, x7
     be0: 8b030021     	add	x1, x1, x3
     be4: 8b0a0063     	add	x3, x3, x10
     be8: 8a2300aa     	bic	x10, x5, x3
     bec: 93c33867     	ror	x7, x3, #0xe
     bf0: cac348e7     	eor	x7, x7, x3, ror #18
     bf4: cac3a4e7     	eor	x7, x7, x3, ror #41
     bf8: 8a0300d3     	and	x19, x6, x3
     bfc: aa0a026a     	orr	x10, x19, x10
     c00: 8b040284     	add	x4, x20, x4
     c04: 8b0a008a     	add	x10, x4, x10
     c08: d289f364     	mov	x4, #0x4f9b             ; =20379
     c0c: f2b5e324     	movk	x4, #0xaf19, lsl #16
     c10: f2d05484     	movk	x4, #0x82a4, lsl #32
     c14: f2f247e4     	movk	x4, #0x923f, lsl #48
     c18: 8b04014a     	add	x10, x10, x4
     c1c: 8b070144     	add	x4, x10, x7
     c20: 93c1702a     	ror	x10, x1, #0x1c
     c24: cac1894a     	eor	x10, x10, x1, ror #34
     c28: cac19d4a     	eor	x10, x10, x1, ror #39
     c2c: aa080047     	orr	x7, x2, x8
     c30: 8a070027     	and	x7, x1, x7
     c34: 8a080053     	and	x19, x2, x8
     c38: aa1300e7     	orr	x7, x7, x19
     c3c: 8b07014a     	add	x10, x10, x7
     c40: 8b04014a     	add	x10, x10, x4
     c44: 8b090084     	add	x4, x4, x9
     c48: 8a2400c9     	bic	x9, x6, x4
     c4c: 93c43887     	ror	x7, x4, #0xe
     c50: cac448e7     	eor	x7, x7, x4, ror #18
     c54: cac4a4e7     	eor	x7, x7, x4, ror #41
     c58: 8a040073     	and	x19, x3, x4
     c5c: aa090269     	orr	x9, x19, x9
     c60: a943d3f3     	ldp	x19, x20, [sp, #0x38]
     c64: 8b050265     	add	x5, x19, x5
     c68: 8b0900a9     	add	x9, x5, x9
     c6c: d2902305     	mov	x5, #0x8118             ; =33048
     c70: f2bb4da5     	movk	x5, #0xda6d, lsl #16
     c74: f2cbdaa5     	movk	x5, #0x5ed5, lsl #32
     c78: f2f56385     	movk	x5, #0xab1c, lsl #48
     c7c: 8b050129     	add	x9, x9, x5
     c80: 8b070125     	add	x5, x9, x7
     c84: 93ca7149     	ror	x9, x10, #0x1c
     c88: caca8929     	eor	x9, x9, x10, ror #34
     c8c: caca9d29     	eor	x9, x9, x10, ror #39
     c90: aa020027     	orr	x7, x1, x2
     c94: 8a070147     	and	x7, x10, x7
     c98: 8a020033     	and	x19, x1, x2
     c9c: aa1300e7     	orr	x7, x7, x19
     ca0: 8b070129     	add	x9, x9, x7
     ca4: 8b050129     	add	x9, x9, x5
     ca8: 8b0800a5     	add	x5, x5, x8
     cac: 8a250068     	bic	x8, x3, x5
     cb0: 93c538a7     	ror	x7, x5, #0xe
     cb4: cac548e7     	eor	x7, x7, x5, ror #18
     cb8: cac5a4e7     	eor	x7, x7, x5, ror #41
     cbc: 8a050093     	and	x19, x4, x5
     cc0: aa080268     	orr	x8, x19, x8
     cc4: 8b060286     	add	x6, x20, x6
     cc8: 8b0800c8     	add	x8, x6, x8
     ccc: d2804846     	mov	x6, #0x242              ; =578
     cd0: f2b46066     	movk	x6, #0xa303, lsl #16
     cd4: f2d55306     	movk	x6, #0xaa98, lsl #32
     cd8: f2fb00e6     	movk	x6, #0xd807, lsl #48
     cdc: 8b060108     	add	x8, x8, x6
     ce0: 8b070106     	add	x6, x8, x7
     ce4: 93c97128     	ror	x8, x9, #0x1c
     ce8: cac98908     	eor	x8, x8, x9, ror #34
     cec: cac99d08     	eor	x8, x8, x9, ror #39
     cf0: aa010147     	orr	x7, x10, x1
     cf4: 8a070127     	and	x7, x9, x7
     cf8: 8a010153     	and	x19, x10, x1
     cfc: aa1300e7     	orr	x7, x7, x19
     d00: 8b070108     	add	x8, x8, x7
     d04: 8b060108     	add	x8, x8, x6
     d08: 8b0200c6     	add	x6, x6, x2
     d0c: 8a260082     	bic	x2, x4, x6
     d10: 93c638c7     	ror	x7, x6, #0xe
     d14: cac648e7     	eor	x7, x7, x6, ror #18
     d18: cac6a4e7     	eor	x7, x7, x6, ror #41
     d1c: 8a0600b3     	and	x19, x5, x6
     d20: aa020262     	orr	x2, x19, x2
     d24: a944d3f3     	ldp	x19, x20, [sp, #0x48]
     d28: 8b030263     	add	x3, x19, x3
     d2c: 8b020062     	add	x2, x3, x2
     d30: d28df7c3     	mov	x3, #0x6fbe             ; =28606
     d34: f2a8ae03     	movk	x3, #0x4570, lsl #16
     d38: f2cb6023     	movk	x3, #0x5b01, lsl #32
     d3c: f2e25063     	movk	x3, #0x1283, lsl #48
     d40: 8b030042     	add	x2, x2, x3
     d44: 8b070043     	add	x3, x2, x7
     d48: 93c87102     	ror	x2, x8, #0x1c
     d4c: cac88842     	eor	x2, x2, x8, ror #34
     d50: cac89c42     	eor	x2, x2, x8, ror #39
     d54: aa0a0127     	orr	x7, x9, x10
     d58: 8a070107     	and	x7, x8, x7
     d5c: 8a0a0133     	and	x19, x9, x10
     d60: aa1300e7     	orr	x7, x7, x19
     d64: 8b070042     	add	x2, x2, x7
     d68: 8b030042     	add	x2, x2, x3
     d6c: 8b010063     	add	x3, x3, x1
     d70: 8a2300a1     	bic	x1, x5, x3
     d74: 93c33867     	ror	x7, x3, #0xe
     d78: cac348e7     	eor	x7, x7, x3, ror #18
     d7c: cac3a4e7     	eor	x7, x7, x3, ror #41
     d80: 8a0300d3     	and	x19, x6, x3
     d84: aa010261     	orr	x1, x19, x1
     d88: 8b040284     	add	x4, x20, x4
     d8c: 8b010081     	add	x1, x4, x1
     d90: d2965184     	mov	x4, #0xb28c             ; =45708
     d94: f2a9dc84     	movk	x4, #0x4ee4, lsl #16
     d98: f2d0b7c4     	movk	x4, #0x85be, lsl #32
     d9c: f2e48624     	movk	x4, #0x2431, lsl #48
     da0: 8b040021     	add	x1, x1, x4
     da4: 8b070024     	add	x4, x1, x7
     da8: 93c27041     	ror	x1, x2, #0x1c
     dac: cac28821     	eor	x1, x1, x2, ror #34
     db0: cac29c21     	eor	x1, x1, x2, ror #39
     db4: aa090107     	orr	x7, x8, x9
     db8: 8a070047     	and	x7, x2, x7
     dbc: 8a090113     	and	x19, x8, x9
     dc0: aa1300e7     	orr	x7, x7, x19
     dc4: 8b070021     	add	x1, x1, x7
     dc8: 8b040021     	add	x1, x1, x4
     dcc: 8b0a0084     	add	x4, x4, x10
     dd0: 8a2400ca     	bic	x10, x6, x4
     dd4: 93c43887     	ror	x7, x4, #0xe
     dd8: cac448e7     	eor	x7, x7, x4, ror #18
     ddc: cac4a4e7     	eor	x7, x7, x4, ror #41
     de0: 8a040073     	and	x19, x3, x4
     de4: aa0a026a     	orr	x10, x19, x10
     de8: a945d3f3     	ldp	x19, x20, [sp, #0x58]
     dec: 8b050265     	add	x5, x19, x5
     df0: 8b0a00aa     	add	x10, x5, x10
     df4: d2969c45     	mov	x5, #0xb4e2             ; =46306
     df8: f2babfe5     	movk	x5, #0xd5ff, lsl #16
     dfc: f2cfb865     	movk	x5, #0x7dc3, lsl #32
     e00: f2eaa185     	movk	x5, #0x550c, lsl #48
     e04: 8b05014a     	add	x10, x10, x5
     e08: 8b070145     	add	x5, x10, x7
     e0c: 93c1702a     	ror	x10, x1, #0x1c
     e10: cac1894a     	eor	x10, x10, x1, ror #34
     e14: cac19d4a     	eor	x10, x10, x1, ror #39
     e18: aa080047     	orr	x7, x2, x8
     e1c: 8a070027     	and	x7, x1, x7
     e20: 8a080053     	and	x19, x2, x8
     e24: aa1300e7     	orr	x7, x7, x19
     e28: 8b07014a     	add	x10, x10, x7
     e2c: 8b05014a     	add	x10, x10, x5
     e30: 8b0900a5     	add	x5, x5, x9
     e34: 8a250069     	bic	x9, x3, x5
     e38: 93c538a7     	ror	x7, x5, #0xe
     e3c: cac548e7     	eor	x7, x7, x5, ror #18
     e40: cac5a4e7     	eor	x7, x7, x5, ror #41
     e44: 8a050093     	and	x19, x4, x5
     e48: aa090269     	orr	x9, x19, x9
     e4c: 8b060286     	add	x6, x20, x6
     e50: 8b0900c9     	add	x9, x6, x9
     e54: d2912de6     	mov	x6, #0x896f             ; =35183
     e58: f2be4f66     	movk	x6, #0xf27b, lsl #16
     e5c: f2cbae86     	movk	x6, #0x5d74, lsl #32
     e60: f2ee57c6     	movk	x6, #0x72be, lsl #48
     e64: 8b060129     	add	x9, x9, x6
     e68: 8b070126     	add	x6, x9, x7
     e6c: 93ca7149     	ror	x9, x10, #0x1c
     e70: caca8929     	eor	x9, x9, x10, ror #34
     e74: caca9d29     	eor	x9, x9, x10, ror #39
     e78: aa020027     	orr	x7, x1, x2
     e7c: 8a070147     	and	x7, x10, x7
     e80: 8a020033     	and	x19, x1, x2
     e84: aa1300e7     	orr	x7, x7, x19
     e88: 8b070129     	add	x9, x9, x7
     e8c: 8b060129     	add	x9, x9, x6
     e90: 8b0800c6     	add	x6, x6, x8
     e94: 8a260088     	bic	x8, x4, x6
     e98: 93c638c7     	ror	x7, x6, #0xe
     e9c: cac648e7     	eor	x7, x7, x6, ror #18
     ea0: cac6a4e7     	eor	x7, x7, x6, ror #41
     ea4: 8a0600b3     	and	x19, x5, x6
     ea8: aa080268     	orr	x8, x19, x8
     eac: a946d3f3     	ldp	x19, x20, [sp, #0x68]
     eb0: 8b030263     	add	x3, x19, x3
     eb4: 8b080068     	add	x8, x3, x8
     eb8: d292d623     	mov	x3, #0x96b1             ; =38577
     ebc: f2a762c3     	movk	x3, #0x3b16, lsl #16
     ec0: f2d63fc3     	movk	x3, #0xb1fe, lsl #32
     ec4: f2f01bc3     	movk	x3, #0x80de, lsl #48
     ec8: 8b030108     	add	x8, x8, x3
     ecc: 8b070103     	add	x3, x8, x7
     ed0: 93c97128     	ror	x8, x9, #0x1c
     ed4: cac98908     	eor	x8, x8, x9, ror #34
     ed8: cac99d08     	eor	x8, x8, x9, ror #39
     edc: aa010147     	orr	x7, x10, x1
     ee0: 8a070127     	and	x7, x9, x7
     ee4: 8a010153     	and	x19, x10, x1
     ee8: aa1300e7     	orr	x7, x7, x19
     eec: 8b070108     	add	x8, x8, x7
     ef0: 8b030108     	add	x8, x8, x3
     ef4: 8b020063     	add	x3, x3, x2
     ef8: 8a2300a2     	bic	x2, x5, x3
     efc: 93c33867     	ror	x7, x3, #0xe
     f00: cac348e7     	eor	x7, x7, x3, ror #18
     f04: cac3a4e7     	eor	x7, x7, x3, ror #41
     f08: 8a0300d3     	and	x19, x6, x3
     f0c: aa020262     	orr	x2, x19, x2
     f10: 8b040284     	add	x4, x20, x4
     f14: 8b020082     	add	x2, x4, x2
     f18: d28246a4     	mov	x4, #0x1235             ; =4661
     f1c: f2a4b8e4     	movk	x4, #0x25c7, lsl #16
     f20: f2c0d4e4     	movk	x4, #0x6a7, lsl #32
     f24: f2f37b84     	movk	x4, #0x9bdc, lsl #48
     f28: 8b040042     	add	x2, x2, x4
     f2c: 8b070044     	add	x4, x2, x7
     f30: 93c87102     	ror	x2, x8, #0x1c
     f34: cac88842     	eor	x2, x2, x8, ror #34
     f38: cac89c42     	eor	x2, x2, x8, ror #39
     f3c: aa0a0127     	orr	x7, x9, x10
     f40: 8a070107     	and	x7, x8, x7
     f44: 8a0a0133     	and	x19, x9, x10
     f48: aa1300e7     	orr	x7, x7, x19
     f4c: 8b070042     	add	x2, x2, x7
     f50: 8b040042     	add	x2, x2, x4
     f54: 8b010084     	add	x4, x4, x1
     f58: 8a2400c1     	bic	x1, x6, x4
     f5c: 93c43887     	ror	x7, x4, #0xe
     f60: cac448e7     	eor	x7, x7, x4, ror #18
     f64: cac4a4e7     	eor	x7, x7, x4, ror #41
     f68: 8a040073     	and	x19, x3, x4
     f6c: aa010261     	orr	x1, x19, x1
     f70: a947d3f3     	ldp	x19, x20, [sp, #0x78]
     f74: 8b050265     	add	x5, x19, x5
     f78: 8b0100a1     	add	x1, x5, x1
     f7c: d284d285     	mov	x5, #0x2694             ; =9876
     f80: f2b9ed25     	movk	x5, #0xcf69, lsl #16
     f84: f2de2e85     	movk	x5, #0xf174, lsl #32
     f88: f2f83365     	movk	x5, #0xc19b, lsl #48
     f8c: 8b050021     	add	x1, x1, x5
     f90: 8b070025     	add	x5, x1, x7
     f94: 93c27041     	ror	x1, x2, #0x1c
     f98: cac28821     	eor	x1, x1, x2, ror #34
     f9c: cac29c21     	eor	x1, x1, x2, ror #39
     fa0: aa090107     	orr	x7, x8, x9
     fa4: 8a070047     	and	x7, x2, x7
     fa8: 8a090113     	and	x19, x8, x9
     fac: aa1300e7     	orr	x7, x7, x19
     fb0: 8b070021     	add	x1, x1, x7
     fb4: 8b050021     	add	x1, x1, x5
     fb8: 8b0a00a5     	add	x5, x5, x10
     fbc: 8a25006a     	bic	x10, x3, x5
     fc0: 93c538a7     	ror	x7, x5, #0xe
     fc4: cac548e7     	eor	x7, x7, x5, ror #18
     fc8: cac5a4e7     	eor	x7, x7, x5, ror #41
     fcc: 8a050093     	and	x19, x4, x5
     fd0: aa0a026a     	orr	x10, x19, x10
     fd4: 8b060286     	add	x6, x20, x6
     fd8: 8b0a00ca     	add	x10, x6, x10
     fdc: d2895a46     	mov	x6, #0x4ad2             ; =19154
     fe0: f2b3de26     	movk	x6, #0x9ef1, lsl #16
     fe4: f2cd3826     	movk	x6, #0x69c1, lsl #32
     fe8: f2fc9366     	movk	x6, #0xe49b, lsl #48
     fec: 8b06014a     	add	x10, x10, x6
     ff0: 8b070146     	add	x6, x10, x7
     ff4: 93c1702a     	ror	x10, x1, #0x1c
     ff8: cac1894a     	eor	x10, x10, x1, ror #34
     ffc: cac19d4a     	eor	x10, x10, x1, ror #39
    1000: aa080047     	orr	x7, x2, x8
    1004: 8a070027     	and	x7, x1, x7
    1008: 8a080053     	and	x19, x2, x8
    100c: aa1300e7     	orr	x7, x7, x19
    1010: 8b07014a     	add	x10, x10, x7
    1014: 8b06014a     	add	x10, x10, x6
    1018: 8b0900c6     	add	x6, x6, x9
    101c: 8a260089     	bic	x9, x4, x6
    1020: 93c638c7     	ror	x7, x6, #0xe
    1024: cac648e7     	eor	x7, x7, x6, ror #18
    1028: cac6a4e7     	eor	x7, x7, x6, ror #41
    102c: 8a0600b3     	and	x19, x5, x6
    1030: aa090269     	orr	x9, x19, x9
    1034: a948d3f3     	ldp	x19, x20, [sp, #0x88]
    1038: 8b030263     	add	x3, x19, x3
    103c: 8b090069     	add	x9, x3, x9
    1040: d284bc63     	mov	x3, #0x25e3             ; =9699
    1044: f2a709e3     	movk	x3, #0x384f, lsl #16
    1048: f2c8f0c3     	movk	x3, #0x4786, lsl #32
    104c: f2fdf7c3     	movk	x3, #0xefbe, lsl #48
    1050: 8b030129     	add	x9, x9, x3
    1054: 8b070123     	add	x3, x9, x7
    1058: 93ca7149     	ror	x9, x10, #0x1c
    105c: caca8929     	eor	x9, x9, x10, ror #34
    1060: caca9d29     	eor	x9, x9, x10, ror #39
    1064: aa020027     	orr	x7, x1, x2
    1068: 8a070147     	and	x7, x10, x7
    106c: 8a020033     	and	x19, x1, x2
    1070: aa1300e7     	orr	x7, x7, x19
    1074: 8b070129     	add	x9, x9, x7
    1078: 8b030129     	add	x9, x9, x3
    107c: 8b080063     	add	x3, x3, x8
    1080: 8a2300a8     	bic	x8, x5, x3
    1084: 93c33867     	ror	x7, x3, #0xe
    1088: cac348e7     	eor	x7, x7, x3, ror #18
    108c: cac3a4e7     	eor	x7, x7, x3, ror #41
    1090: 8a0300d3     	and	x19, x6, x3
    1094: aa080268     	orr	x8, x19, x8
    1098: 8b040284     	add	x4, x20, x4
    109c: 8b080088     	add	x8, x4, x8
    10a0: d29ab6a4     	mov	x4, #0xd5b5             ; =54709
    10a4: f2b17184     	movk	x4, #0x8b8c, lsl #16
    10a8: f2d3b8c4     	movk	x4, #0x9dc6, lsl #32
    10ac: f2e1f824     	movk	x4, #0xfc1, lsl #48
    10b0: 8b040108     	add	x8, x8, x4
    10b4: 8b070104     	add	x4, x8, x7
    10b8: 93c97128     	ror	x8, x9, #0x1c
    10bc: cac98908     	eor	x8, x8, x9, ror #34
    10c0: cac99d08     	eor	x8, x8, x9, ror #39
    10c4: aa010147     	orr	x7, x10, x1
    10c8: 8a070127     	and	x7, x9, x7
    10cc: 8a010153     	and	x19, x10, x1
    10d0: aa1300e7     	orr	x7, x7, x19
    10d4: 8b070108     	add	x8, x8, x7
    10d8: 8b040108     	add	x8, x8, x4
    10dc: 8b020084     	add	x4, x4, x2
    10e0: 8a2400c2     	bic	x2, x6, x4
    10e4: 93c43887     	ror	x7, x4, #0xe
    10e8: cac448e7     	eor	x7, x7, x4, ror #18
    10ec: cac4a4e7     	eor	x7, x7, x4, ror #41
    10f0: 8a040073     	and	x19, x3, x4
    10f4: aa020262     	orr	x2, x19, x2
    10f8: a949d3f3     	ldp	x19, x20, [sp, #0x98]
    10fc: 8b050265     	add	x5, x19, x5
    1100: 8b0200a2     	add	x2, x5, x2
    1104: d2938ca5     	mov	x5, #0x9c65             ; =40037
    1108: f2aef585     	movk	x5, #0x77ac, lsl #16
    110c: f2d43985     	movk	x5, #0xa1cc, lsl #32
    1110: f2e48185     	movk	x5, #0x240c, lsl #48
    1114: 8b050042     	add	x2, x2, x5
    1118: 8b070045     	add	x5, x2, x7
    111c: 93c87102     	ror	x2, x8, #0x1c
    1120: cac88842     	eor	x2, x2, x8, ror #34
    1124: cac89c42     	eor	x2, x2, x8, ror #39
    1128: aa0a0127     	orr	x7, x9, x10
    112c: 8a070107     	and	x7, x8, x7
    1130: 8a0a0133     	and	x19, x9, x10
    1134: aa1300e7     	orr	x7, x7, x19
    1138: 8b070042     	add	x2, x2, x7
    113c: 8b050042     	add	x2, x2, x5
    1140: 8b0100a5     	add	x5, x5, x1
    1144: 8a250061     	bic	x1, x3, x5
    1148: 93c538a7     	ror	x7, x5, #0xe
    114c: cac548e7     	eor	x7, x7, x5, ror #18
    1150: cac5a4e7     	eor	x7, x7, x5, ror #41
    1154: 8a050093     	and	x19, x4, x5
    1158: aa010261     	orr	x1, x19, x1
    115c: 8b060286     	add	x6, x20, x6
    1160: 8b0100c1     	add	x1, x6, x1
    1164: d2804ea6     	mov	x6, #0x275              ; =629
    1168: f2ab2566     	movk	x6, #0x592b, lsl #16
    116c: f2c58de6     	movk	x6, #0x2c6f, lsl #32
    1170: f2e5bd26     	movk	x6, #0x2de9, lsl #48
    1174: 8b060021     	add	x1, x1, x6
    1178: 8b070026     	add	x6, x1, x7
    117c: 93c27041     	ror	x1, x2, #0x1c
    1180: cac28821     	eor	x1, x1, x2, ror #34
    1184: cac29c21     	eor	x1, x1, x2, ror #39
    1188: aa090107     	orr	x7, x8, x9
    118c: 8a070047     	and	x7, x2, x7
    1190: 8a090113     	and	x19, x8, x9
    1194: aa1300e7     	orr	x7, x7, x19
    1198: 8b070021     	add	x1, x1, x7
    119c: 8b060021     	add	x1, x1, x6
    11a0: 8b0a00c6     	add	x6, x6, x10
    11a4: 8a26008a     	bic	x10, x4, x6
    11a8: 93c638c7     	ror	x7, x6, #0xe
    11ac: cac648e7     	eor	x7, x7, x6, ror #18
    11b0: cac6a4e7     	eor	x7, x7, x6, ror #41
    11b4: 8a0600b3     	and	x19, x5, x6
    11b8: aa0a026a     	orr	x10, x19, x10
    11bc: a94ad3f3     	ldp	x19, x20, [sp, #0xa8]
    11c0: 8b030263     	add	x3, x19, x3
    11c4: 8b0a006a     	add	x10, x3, x10
    11c8: d29c9063     	mov	x3, #0xe483             ; =58499
    11cc: f2add4c3     	movk	x3, #0x6ea6, lsl #16
    11d0: f2d09543     	movk	x3, #0x84aa, lsl #32
    11d4: f2e94e83     	movk	x3, #0x4a74, lsl #48
    11d8: 8b03014a     	add	x10, x10, x3
    11dc: 8b070143     	add	x3, x10, x7
    11e0: 93c1702a     	ror	x10, x1, #0x1c
    11e4: cac1894a     	eor	x10, x10, x1, ror #34
    11e8: cac19d4a     	eor	x10, x10, x1, ror #39
    11ec: aa080047     	orr	x7, x2, x8
    11f0: 8a070027     	and	x7, x1, x7
    11f4: 8a080053     	and	x19, x2, x8
    11f8: aa1300e7     	orr	x7, x7, x19
    11fc: 8b07014a     	add	x10, x10, x7
    1200: 8b03014a     	add	x10, x10, x3
    1204: 8b090063     	add	x3, x3, x9
    1208: 8a2300a9     	bic	x9, x5, x3
    120c: 93c33867     	ror	x7, x3, #0xe
    1210: cac348e7     	eor	x7, x7, x3, ror #18
    1214: cac3a4e7     	eor	x7, x7, x3, ror #41
    1218: 8a0300d3     	and	x19, x6, x3
    121c: aa090269     	orr	x9, x19, x9
    1220: 8b040284     	add	x4, x20, x4
    1224: 8b090089     	add	x9, x4, x9
    1228: d29f7a84     	mov	x4, #0xfbd4             ; =64468
    122c: f2b7a824     	movk	x4, #0xbd41, lsl #16
    1230: f2d53b84     	movk	x4, #0xa9dc, lsl #32
    1234: f2eb9604     	movk	x4, #0x5cb0, lsl #48
    1238: 8b040129     	add	x9, x9, x4
    123c: 8b070124     	add	x4, x9, x7
    1240: 93ca7149     	ror	x9, x10, #0x1c
    1244: caca8929     	eor	x9, x9, x10, ror #34
    1248: caca9d29     	eor	x9, x9, x10, ror #39
    124c: aa020027     	orr	x7, x1, x2
    1250: 8a070147     	and	x7, x10, x7
    1254: 8a020033     	and	x19, x1, x2
    1258: aa1300e7     	orr	x7, x7, x19
    125c: 8b070129     	add	x9, x9, x7
    1260: 8b040129     	add	x9, x9, x4
    1264: 8b080084     	add	x4, x4, x8
    1268: 8a2400c8     	bic	x8, x6, x4
    126c: 93c43887     	ror	x7, x4, #0xe
    1270: cac448e7     	eor	x7, x7, x4, ror #18
    1274: cac4a4e7     	eor	x7, x7, x4, ror #41
    1278: 8a040073     	and	x19, x3, x4
    127c: aa080268     	orr	x8, x19, x8
    1280: a94bd3f3     	ldp	x19, x20, [sp, #0xb8]
    1284: 8b050265     	add	x5, x19, x5
    1288: 8b0800a8     	add	x8, x5, x8
    128c: d28a76a5     	mov	x5, #0x53b5             ; =21429
    1290: f2b06225     	movk	x5, #0x8311, lsl #16
    1294: f2d11b45     	movk	x5, #0x88da, lsl #32
    1298: f2eedf25     	movk	x5, #0x76f9, lsl #48
    129c: 8b050108     	add	x8, x8, x5
    12a0: 8b070105     	add	x5, x8, x7
    12a4: 93c97128     	ror	x8, x9, #0x1c
    12a8: cac98908     	eor	x8, x8, x9, ror #34
    12ac: cac99d08     	eor	x8, x8, x9, ror #39
    12b0: aa010147     	orr	x7, x10, x1
    12b4: 8a070127     	and	x7, x9, x7
    12b8: 8a010153     	and	x19, x10, x1
    12bc: aa1300e7     	orr	x7, x7, x19
    12c0: 8b070108     	add	x8, x8, x7
    12c4: 8b050108     	add	x8, x8, x5
    12c8: 8b0200a5     	add	x5, x5, x2
    12cc: 8a250062     	bic	x2, x3, x5
    12d0: 93c538a7     	ror	x7, x5, #0xe
    12d4: cac548e7     	eor	x7, x7, x5, ror #18
    12d8: cac5a4e7     	eor	x7, x7, x5, ror #41
    12dc: 8a050093     	and	x19, x4, x5
    12e0: aa020262     	orr	x2, x19, x2
    12e4: 8b060286     	add	x6, x20, x6
    12e8: 8b0200c2     	add	x2, x6, x2
    12ec: d29bf566     	mov	x6, #0xdfab             ; =57259
    12f0: f2bdccc6     	movk	x6, #0xee66, lsl #16
    12f4: f2ca2a46     	movk	x6, #0x5152, lsl #32
    12f8: f2f307c6     	movk	x6, #0x983e, lsl #48
    12fc: 8b060042     	add	x2, x2, x6
    1300: 8b070046     	add	x6, x2, x7
    1304: 93c87102     	ror	x2, x8, #0x1c
    1308: cac88842     	eor	x2, x2, x8, ror #34
    130c: cac89c42     	eor	x2, x2, x8, ror #39
    1310: aa0a0127     	orr	x7, x9, x10
    1314: 8a070107     	and	x7, x8, x7
    1318: 8a0a0133     	and	x19, x9, x10
    131c: aa1300e7     	orr	x7, x7, x19
    1320: 8b070042     	add	x2, x2, x7
    1324: 8b060042     	add	x2, x2, x6
    1328: 8b0100c6     	add	x6, x6, x1
    132c: 8a260081     	bic	x1, x4, x6
    1330: 93c638c7     	ror	x7, x6, #0xe
    1334: cac648e7     	eor	x7, x7, x6, ror #18
    1338: cac6a4e7     	eor	x7, x7, x6, ror #41
    133c: 8a0600b3     	and	x19, x5, x6
    1340: aa010261     	orr	x1, x19, x1
    1344: a94cd3f3     	ldp	x19, x20, [sp, #0xc8]
    1348: 8b030263     	add	x3, x19, x3
    134c: 8b010061     	add	x1, x3, x1
    1350: d2864203     	mov	x3, #0x3210             ; =12816
    1354: f2a5b683     	movk	x3, #0x2db4, lsl #16
    1358: f2d8cda3     	movk	x3, #0xc66d, lsl #32
    135c: f2f50623     	movk	x3, #0xa831, lsl #48
    1360: 8b030021     	add	x1, x1, x3
    1364: 8b070023     	add	x3, x1, x7
    1368: 93c27041     	ror	x1, x2, #0x1c
    136c: cac28821     	eor	x1, x1, x2, ror #34
    1370: cac29c21     	eor	x1, x1, x2, ror #39
    1374: aa090107     	orr	x7, x8, x9
    1378: 8a070047     	and	x7, x2, x7
    137c: 8a090113     	and	x19, x8, x9
    1380: aa1300e7     	orr	x7, x7, x19
    1384: 8b070021     	add	x1, x1, x7
    1388: 8b030021     	add	x1, x1, x3
    138c: 8b0a0063     	add	x3, x3, x10
    1390: 8a2300aa     	bic	x10, x5, x3
    1394: 93c33867     	ror	x7, x3, #0xe
    1398: cac348e7     	eor	x7, x7, x3, ror #18
    139c: cac3a4e7     	eor	x7, x7, x3, ror #41
    13a0: 8a0300d3     	and	x19, x6, x3
    13a4: aa0a026a     	orr	x10, x19, x10
    13a8: 8b040284     	add	x4, x20, x4
    13ac: 8b0a008a     	add	x10, x4, x10
    13b0: d28427e4     	mov	x4, #0x213f             ; =8511
    13b4: f2b31f64     	movk	x4, #0x98fb, lsl #16
    13b8: f2c4f904     	movk	x4, #0x27c8, lsl #32
    13bc: f2f60064     	movk	x4, #0xb003, lsl #48
    13c0: 8b04014a     	add	x10, x10, x4
    13c4: 8b070144     	add	x4, x10, x7
    13c8: 93c1702a     	ror	x10, x1, #0x1c
    13cc: cac1894a     	eor	x10, x10, x1, ror #34
    13d0: cac19d4a     	eor	x10, x10, x1, ror #39
    13d4: aa080047     	orr	x7, x2, x8
    13d8: 8a070027     	and	x7, x1, x7
    13dc: 8a080053     	and	x19, x2, x8
    13e0: aa1300e7     	orr	x7, x7, x19
    13e4: 8b07014a     	add	x10, x10, x7
    13e8: 8b04014a     	add	x10, x10, x4
    13ec: 8b090084     	add	x4, x4, x9
    13f0: 8a2400c9     	bic	x9, x6, x4
    13f4: 93c43887     	ror	x7, x4, #0xe
    13f8: cac448e7     	eor	x7, x7, x4, ror #18
    13fc: cac4a4e7     	eor	x7, x7, x4, ror #41
    1400: 8a040073     	and	x19, x3, x4
    1404: aa090269     	orr	x9, x19, x9
    1408: a94dd3f3     	ldp	x19, x20, [sp, #0xd8]
    140c: 8b050265     	add	x5, x19, x5
    1410: 8b0900a9     	add	x9, x5, x9
    1414: d281dc85     	mov	x5, #0xee4              ; =3812
    1418: f2b7dde5     	movk	x5, #0xbeef, lsl #16
    141c: f2cff8e5     	movk	x5, #0x7fc7, lsl #32
    1420: f2f7eb25     	movk	x5, #0xbf59, lsl #48
    1424: 8b050129     	add	x9, x9, x5
    1428: 8b070125     	add	x5, x9, x7
    142c: 93ca7149     	ror	x9, x10, #0x1c
    1430: caca8929     	eor	x9, x9, x10, ror #34
    1434: caca9d29     	eor	x9, x9, x10, ror #39
    1438: aa020027     	orr	x7, x1, x2
    143c: 8a070147     	and	x7, x10, x7
    1440: 8a020033     	and	x19, x1, x2
    1444: aa1300e7     	orr	x7, x7, x19
    1448: 8b070129     	add	x9, x9, x7
    144c: 8b050129     	add	x9, x9, x5
    1450: 8b0800a5     	add	x5, x5, x8
    1454: 8a250068     	bic	x8, x3, x5
    1458: 93c538a7     	ror	x7, x5, #0xe
    145c: cac548e7     	eor	x7, x7, x5, ror #18
    1460: cac5a4e7     	eor	x7, x7, x5, ror #41
    1464: 8a050093     	and	x19, x4, x5
    1468: aa080268     	orr	x8, x19, x8
    146c: 8b060286     	add	x6, x20, x6
    1470: 8b0800c8     	add	x8, x6, x8
    1474: d291f846     	mov	x6, #0x8fc2             ; =36802
    1478: f2a7b506     	movk	x6, #0x3da8, lsl #16
    147c: f2c17e66     	movk	x6, #0xbf3, lsl #32
    1480: f2f8dc06     	movk	x6, #0xc6e0, lsl #48
    1484: 8b060108     	add	x8, x8, x6
    1488: 8b070106     	add	x6, x8, x7
    148c: 93c97128     	ror	x8, x9, #0x1c
    1490: cac98908     	eor	x8, x8, x9, ror #34
    1494: cac99d08     	eor	x8, x8, x9, ror #39
    1498: aa010147     	orr	x7, x10, x1
    149c: 8a070127     	and	x7, x9, x7
    14a0: 8a010153     	and	x19, x10, x1
    14a4: aa1300e7     	orr	x7, x7, x19
    14a8: 8b070108     	add	x8, x8, x7
    14ac: 8b060108     	add	x8, x8, x6
    14b0: 8b0200c6     	add	x6, x6, x2
    14b4: 8a260082     	bic	x2, x4, x6
    14b8: 93c638c7     	ror	x7, x6, #0xe
    14bc: cac648e7     	eor	x7, x7, x6, ror #18
    14c0: cac6a4e7     	eor	x7, x7, x6, ror #41
    14c4: 8a0600b3     	and	x19, x5, x6
    14c8: aa020262     	orr	x2, x19, x2
    14cc: a94ed3f3     	ldp	x19, x20, [sp, #0xe8]
    14d0: 8b030263     	add	x3, x19, x3
    14d4: 8b020062     	add	x2, x3, x2
    14d8: d294e4a3     	mov	x3, #0xa725             ; =42789
    14dc: f2b26143     	movk	x3, #0x930a, lsl #16
    14e0: f2d228e3     	movk	x3, #0x9147, lsl #32
    14e4: f2fab4e3     	movk	x3, #0xd5a7, lsl #48
    14e8: 8b030042     	add	x2, x2, x3
    14ec: 8b070043     	add	x3, x2, x7
    14f0: 93c87102     	ror	x2, x8, #0x1c
    14f4: cac88842     	eor	x2, x2, x8, ror #34
    14f8: cac89c42     	eor	x2, x2, x8, ror #39
    14fc: aa0a0127     	orr	x7, x9, x10
    1500: 8a070107     	and	x7, x8, x7
    1504: 8a0a0133     	and	x19, x9, x10
    1508: aa1300e7     	orr	x7, x7, x19
    150c: 8b070042     	add	x2, x2, x7
    1510: 8b030042     	add	x2, x2, x3
    1514: 8b010063     	add	x3, x3, x1
    1518: 8a2300a1     	bic	x1, x5, x3
    151c: 93c33867     	ror	x7, x3, #0xe
    1520: cac348e7     	eor	x7, x7, x3, ror #18
    1524: cac3a4e7     	eor	x7, x7, x3, ror #41
    1528: 8a0300d3     	and	x19, x6, x3
    152c: aa010261     	orr	x1, x19, x1
    1530: 8b040284     	add	x4, x20, x4
    1534: 8b010081     	add	x1, x4, x1
    1538: d2904de4     	mov	x4, #0x826f             ; =33391
    153c: f2bc0064     	movk	x4, #0xe003, lsl #16
    1540: f2cc6a24     	movk	x4, #0x6351, lsl #32
    1544: f2e0d944     	movk	x4, #0x6ca, lsl #48
    1548: 8b040021     	add	x1, x1, x4
    154c: 8b070024     	add	x4, x1, x7
    1550: 93c27041     	ror	x1, x2, #0x1c
    1554: cac28821     	eor	x1, x1, x2, ror #34
    1558: cac29c21     	eor	x1, x1, x2, ror #39
    155c: aa090107     	orr	x7, x8, x9
    1560: 8a070047     	and	x7, x2, x7
    1564: 8a090113     	and	x19, x8, x9
    1568: aa1300e7     	orr	x7, x7, x19
    156c: 8b070021     	add	x1, x1, x7
    1570: 8b040021     	add	x1, x1, x4
    1574: 8b0a0084     	add	x4, x4, x10
    1578: 8a2400ca     	bic	x10, x6, x4
    157c: 93c43887     	ror	x7, x4, #0xe
    1580: cac448e7     	eor	x7, x7, x4, ror #18
    1584: cac4a4e7     	eor	x7, x7, x4, ror #41
    1588: 8a040073     	and	x19, x3, x4
    158c: aa0a026a     	orr	x10, x19, x10
    1590: a94fd3f3     	ldp	x19, x20, [sp, #0xf8]
    1594: 8b050265     	add	x5, x19, x5
    1598: 8b0a00aa     	add	x10, x5, x10
    159c: d28dce05     	mov	x5, #0x6e70             ; =28272
    15a0: f2a141c5     	movk	x5, #0xa0e, lsl #16
    15a4: f2c52ce5     	movk	x5, #0x2967, lsl #32
    15a8: f2e28525     	movk	x5, #0x1429, lsl #48
    15ac: 8b05014a     	add	x10, x10, x5
    15b0: 8b070145     	add	x5, x10, x7
    15b4: 93c1702a     	ror	x10, x1, #0x1c
    15b8: cac1894a     	eor	x10, x10, x1, ror #34
    15bc: cac19d4a     	eor	x10, x10, x1, ror #39
    15c0: aa080047     	orr	x7, x2, x8
    15c4: 8a070027     	and	x7, x1, x7
    15c8: 8a080053     	and	x19, x2, x8
    15cc: aa1300e7     	orr	x7, x7, x19
    15d0: 8b07014a     	add	x10, x10, x7
    15d4: 8b05014a     	add	x10, x10, x5
    15d8: 8b0900a5     	add	x5, x5, x9
    15dc: 8a250069     	bic	x9, x3, x5
    15e0: 93c538a7     	ror	x7, x5, #0xe
    15e4: cac548e7     	eor	x7, x7, x5, ror #18
    15e8: cac5a4e7     	eor	x7, x7, x5, ror #41
    15ec: 8a050093     	and	x19, x4, x5
    15f0: aa090269     	orr	x9, x19, x9
    15f4: 8b060286     	add	x6, x20, x6
    15f8: 8b0900c9     	add	x9, x6, x9
    15fc: d285ff86     	mov	x6, #0x2ffc             ; =12284
    1600: f2a8da46     	movk	x6, #0x46d2, lsl #16
    1604: f2c150a6     	movk	x6, #0xa85, lsl #32
    1608: f2e4f6e6     	movk	x6, #0x27b7, lsl #48
    160c: 8b060129     	add	x9, x9, x6
    1610: 8b070126     	add	x6, x9, x7
    1614: 93ca7149     	ror	x9, x10, #0x1c
    1618: caca8929     	eor	x9, x9, x10, ror #34
    161c: caca9d29     	eor	x9, x9, x10, ror #39
    1620: aa020027     	orr	x7, x1, x2
    1624: 8a070147     	and	x7, x10, x7
    1628: 8a020033     	and	x19, x1, x2
    162c: aa1300e7     	orr	x7, x7, x19
    1630: 8b070129     	add	x9, x9, x7
    1634: 8b060129     	add	x9, x9, x6
    1638: 8b0800c6     	add	x6, x6, x8
    163c: 8a260088     	bic	x8, x4, x6
    1640: 93c638c7     	ror	x7, x6, #0xe
    1644: cac648e7     	eor	x7, x7, x6, ror #18
    1648: cac6a4e7     	eor	x7, x7, x6, ror #41
    164c: 8a0600b3     	and	x19, x5, x6
    1650: aa080268     	orr	x8, x19, x8
    1654: a950d3f3     	ldp	x19, x20, [sp, #0x108]
    1658: 8b030263     	add	x3, x19, x3
    165c: 8b080068     	add	x8, x3, x8
    1660: d29924c3     	mov	x3, #0xc926             ; =51494
    1664: f2ab84c3     	movk	x3, #0x5c26, lsl #16
    1668: f2c42703     	movk	x3, #0x2138, lsl #32
    166c: f2e5c363     	movk	x3, #0x2e1b, lsl #48
    1670: 8b030108     	add	x8, x8, x3
    1674: 8b070103     	add	x3, x8, x7
    1678: 93c97128     	ror	x8, x9, #0x1c
    167c: cac98908     	eor	x8, x8, x9, ror #34
    1680: cac99d08     	eor	x8, x8, x9, ror #39
    1684: aa010147     	orr	x7, x10, x1
    1688: 8a070127     	and	x7, x9, x7
    168c: 8a010153     	and	x19, x10, x1
    1690: aa1300e7     	orr	x7, x7, x19
    1694: 8b070108     	add	x8, x8, x7
    1698: 8b030108     	add	x8, x8, x3
    169c: 8b020063     	add	x3, x3, x2
    16a0: 8a2300a2     	bic	x2, x5, x3
    16a4: 93c33867     	ror	x7, x3, #0xe
    16a8: cac348e7     	eor	x7, x7, x3, ror #18
    16ac: cac3a4e7     	eor	x7, x7, x3, ror #41
    16b0: 8a0300d3     	and	x19, x6, x3
    16b4: aa020262     	orr	x2, x19, x2
    16b8: 8b040284     	add	x4, x20, x4
    16bc: 8b020082     	add	x2, x4, x2
    16c0: d2855da4     	mov	x4, #0x2aed             ; =10989
    16c4: f2ab5884     	movk	x4, #0x5ac4, lsl #16
    16c8: f2cdbf84     	movk	x4, #0x6dfc, lsl #32
    16cc: f2e9a584     	movk	x4, #0x4d2c, lsl #48
    16d0: 8b040042     	add	x2, x2, x4
    16d4: 8b070044     	add	x4, x2, x7
    16d8: 93c87102     	ror	x2, x8, #0x1c
    16dc: cac88842     	eor	x2, x2, x8, ror #34
    16e0: cac89c42     	eor	x2, x2, x8, ror #39
    16e4: aa0a0127     	orr	x7, x9, x10
    16e8: 8a070107     	and	x7, x8, x7
    16ec: 8a0a0133     	and	x19, x9, x10
    16f0: aa1300e7     	orr	x7, x7, x19
    16f4: 8b070042     	add	x2, x2, x7
    16f8: 8b040042     	add	x2, x2, x4
    16fc: 8b010084     	add	x4, x4, x1
    1700: 8a2400c1     	bic	x1, x6, x4
    1704: 93c43887     	ror	x7, x4, #0xe
    1708: cac448e7     	eor	x7, x7, x4, ror #18
    170c: cac4a4e7     	eor	x7, x7, x4, ror #41
    1710: 8a040073     	and	x19, x3, x4
    1714: aa010261     	orr	x1, x19, x1
    1718: a951d3f3     	ldp	x19, x20, [sp, #0x118]
    171c: 8b050265     	add	x5, x19, x5
    1720: 8b0100a1     	add	x1, x5, x1
    1724: d2967be5     	mov	x5, #0xb3df             ; =46047
    1728: f2b3b2a5     	movk	x5, #0x9d95, lsl #16
    172c: f2c1a265     	movk	x5, #0xd13, lsl #32
    1730: f2ea6705     	movk	x5, #0x5338, lsl #48
    1734: 8b050021     	add	x1, x1, x5
    1738: 8b070025     	add	x5, x1, x7
    173c: 93c27041     	ror	x1, x2, #0x1c
    1740: cac28821     	eor	x1, x1, x2, ror #34
    1744: cac29c21     	eor	x1, x1, x2, ror #39
    1748: aa090107     	orr	x7, x8, x9
    174c: 8a070047     	and	x7, x2, x7
    1750: 8a090113     	and	x19, x8, x9
    1754: aa1300e7     	orr	x7, x7, x19
    1758: 8b070021     	add	x1, x1, x7
    175c: 8b050021     	add	x1, x1, x5
    1760: 8b0a00a5     	add	x5, x5, x10
    1764: 8a25006a     	bic	x10, x3, x5
    1768: 93c538a7     	ror	x7, x5, #0xe
    176c: cac548e7     	eor	x7, x7, x5, ror #18
    1770: cac5a4e7     	eor	x7, x7, x5, ror #41
    1774: 8a050093     	and	x19, x4, x5
    1778: aa0a026a     	orr	x10, x19, x10
    177c: 8b060286     	add	x6, x20, x6
    1780: 8b0a00ca     	add	x10, x6, x10
    1784: d28c7bc6     	mov	x6, #0x63de             ; =25566
    1788: f2b175e6     	movk	x6, #0x8baf, lsl #16
    178c: f2ce6a86     	movk	x6, #0x7354, lsl #32
    1790: f2eca146     	movk	x6, #0x650a, lsl #48
    1794: 8b06014a     	add	x10, x10, x6
    1798: 8b070146     	add	x6, x10, x7
    179c: 93c1702a     	ror	x10, x1, #0x1c
    17a0: cac1894a     	eor	x10, x10, x1, ror #34
    17a4: cac19d4a     	eor	x10, x10, x1, ror #39
    17a8: aa080047     	orr	x7, x2, x8
    17ac: 8a070027     	and	x7, x1, x7
    17b0: 8a080053     	and	x19, x2, x8
    17b4: aa1300e7     	orr	x7, x7, x19
    17b8: 8b07014a     	add	x10, x10, x7
    17bc: 8b06014a     	add	x10, x10, x6
    17c0: 8b0900c6     	add	x6, x6, x9
    17c4: 8a260089     	bic	x9, x4, x6
    17c8: 93c638c7     	ror	x7, x6, #0xe
    17cc: cac648e7     	eor	x7, x7, x6, ror #18
    17d0: cac6a4e7     	eor	x7, x7, x6, ror #41
    17d4: 8a0600b3     	and	x19, x5, x6
    17d8: aa090269     	orr	x9, x19, x9
    17dc: a952d3f3     	ldp	x19, x20, [sp, #0x128]
    17e0: 8b030263     	add	x3, x19, x3
    17e4: 8b090069     	add	x9, x3, x9
    17e8: d2965503     	mov	x3, #0xb2a8             ; =45736
    17ec: f2a78ee3     	movk	x3, #0x3c77, lsl #16
    17f0: f2c15763     	movk	x3, #0xabb, lsl #32
    17f4: f2eecd43     	movk	x3, #0x766a, lsl #48
    17f8: 8b030129     	add	x9, x9, x3
    17fc: 8b070123     	add	x3, x9, x7
    1800: 93ca7149     	ror	x9, x10, #0x1c
    1804: caca8929     	eor	x9, x9, x10, ror #34
    1808: caca9d29     	eor	x9, x9, x10, ror #39
    180c: aa020027     	orr	x7, x1, x2
    1810: 8a070147     	and	x7, x10, x7
    1814: 8a020033     	and	x19, x1, x2
    1818: aa1300e7     	orr	x7, x7, x19
    181c: 8b070129     	add	x9, x9, x7
    1820: 8b030129     	add	x9, x9, x3
    1824: 8b080063     	add	x3, x3, x8
    1828: 8a2300a8     	bic	x8, x5, x3
    182c: 93c33867     	ror	x7, x3, #0xe
    1830: cac348e7     	eor	x7, x7, x3, ror #18
    1834: cac3a4e7     	eor	x7, x7, x3, ror #41
    1838: 8a0300d3     	and	x19, x6, x3
    183c: aa080268     	orr	x8, x19, x8
    1840: 8b040284     	add	x4, x20, x4
    1844: 8b080088     	add	x8, x4, x8
    1848: d295dcc4     	mov	x4, #0xaee6             ; =44774
    184c: f2a8fda4     	movk	x4, #0x47ed, lsl #16
    1850: f2d925c4     	movk	x4, #0xc92e, lsl #32
    1854: f2f03844     	movk	x4, #0x81c2, lsl #48
    1858: 8b040108     	add	x8, x8, x4
    185c: 8b070104     	add	x4, x8, x7
    1860: 93c97128     	ror	x8, x9, #0x1c
    1864: cac98908     	eor	x8, x8, x9, ror #34
    1868: cac99d08     	eor	x8, x8, x9, ror #39
    186c: aa010147     	orr	x7, x10, x1
    1870: 8a070127     	and	x7, x9, x7
    1874: 8a010153     	and	x19, x10, x1
    1878: aa1300e7     	orr	x7, x7, x19
    187c: 8b070108     	add	x8, x8, x7
    1880: 8b040108     	add	x8, x8, x4
    1884: 8b020084     	add	x4, x4, x2
    1888: 8a2400c2     	bic	x2, x6, x4
    188c: 93c43887     	ror	x7, x4, #0xe
    1890: cac448e7     	eor	x7, x7, x4, ror #18
    1894: cac4a4e7     	eor	x7, x7, x4, ror #41
    1898: 8a040073     	and	x19, x3, x4
    189c: aa020262     	orr	x2, x19, x2
    18a0: a953d3f3     	ldp	x19, x20, [sp, #0x138]
    18a4: 8b050265     	add	x5, x19, x5
    18a8: 8b0200a2     	add	x2, x5, x2
    18ac: d286a765     	mov	x5, #0x353b             ; =13627
    18b0: f2a29045     	movk	x5, #0x1482, lsl #16
    18b4: f2c590a5     	movk	x5, #0x2c85, lsl #32
    18b8: f2f24e45     	movk	x5, #0x9272, lsl #48
    18bc: 8b050042     	add	x2, x2, x5
    18c0: 8b070045     	add	x5, x2, x7
    18c4: 93c87102     	ror	x2, x8, #0x1c
    18c8: cac88842     	eor	x2, x2, x8, ror #34
    18cc: cac89c42     	eor	x2, x2, x8, ror #39
    18d0: aa0a0127     	orr	x7, x9, x10
    18d4: 8a070107     	and	x7, x8, x7
    18d8: 8a0a0133     	and	x19, x9, x10
    18dc: aa1300e7     	orr	x7, x7, x19
    18e0: 8b070042     	add	x2, x2, x7
    18e4: 8b050042     	add	x2, x2, x5
    18e8: 8b0100a5     	add	x5, x5, x1
    18ec: 8a250061     	bic	x1, x3, x5
    18f0: 93c538a7     	ror	x7, x5, #0xe
    18f4: cac548e7     	eor	x7, x7, x5, ror #18
    18f8: cac5a4e7     	eor	x7, x7, x5, ror #41
    18fc: 8a050093     	and	x19, x4, x5
    1900: aa010261     	orr	x1, x19, x1
    1904: 8b060286     	add	x6, x20, x6
    1908: 8b0100c1     	add	x1, x6, x1
    190c: d2806c86     	mov	x6, #0x364              ; =868
    1910: f2a99e26     	movk	x6, #0x4cf1, lsl #16
    1914: f2dd1426     	movk	x6, #0xe8a1, lsl #32
    1918: f2f457e6     	movk	x6, #0xa2bf, lsl #48
    191c: 8b060021     	add	x1, x1, x6
    1920: 8b070026     	add	x6, x1, x7
    1924: 93c27041     	ror	x1, x2, #0x1c
    1928: cac28821     	eor	x1, x1, x2, ror #34
    192c: cac29c21     	eor	x1, x1, x2, ror #39
    1930: aa090107     	orr	x7, x8, x9
    1934: 8a070047     	and	x7, x2, x7
    1938: 8a090113     	and	x19, x8, x9
    193c: aa1300e7     	orr	x7, x7, x19
    1940: 8b070021     	add	x1, x1, x7
    1944: 8b060021     	add	x1, x1, x6
    1948: 8b0a00c6     	add	x6, x6, x10
    194c: 8a26008a     	bic	x10, x4, x6
    1950: 93c638c7     	ror	x7, x6, #0xe
    1954: cac648e7     	eor	x7, x7, x6, ror #18
    1958: cac6a4e7     	eor	x7, x7, x6, ror #41
    195c: 8a0600b3     	and	x19, x5, x6
    1960: aa0a026a     	orr	x10, x19, x10
    1964: a954d3f3     	ldp	x19, x20, [sp, #0x148]
    1968: 8b030263     	add	x3, x19, x3
    196c: 8b0a006a     	add	x10, x3, x10
    1970: d2860023     	mov	x3, #0x3001             ; =12289
    1974: f2b78843     	movk	x3, #0xbc42, lsl #16
    1978: f2ccc963     	movk	x3, #0x664b, lsl #32
    197c: f2f50343     	movk	x3, #0xa81a, lsl #48
    1980: 8b03014a     	add	x10, x10, x3
    1984: 8b070143     	add	x3, x10, x7
    1988: 93c1702a     	ror	x10, x1, #0x1c
    198c: cac1894a     	eor	x10, x10, x1, ror #34
    1990: cac19d4a     	eor	x10, x10, x1, ror #39
    1994: aa080047     	orr	x7, x2, x8
    1998: 8a070027     	and	x7, x1, x7
    199c: 8a080053     	and	x19, x2, x8
    19a0: aa1300e7     	orr	x7, x7, x19
    19a4: 8b07014a     	add	x10, x10, x7
    19a8: 8b03014a     	add	x10, x10, x3
    19ac: 8b090063     	add	x3, x3, x9
    19b0: 8a2300a9     	bic	x9, x5, x3
    19b4: 93c33867     	ror	x7, x3, #0xe
    19b8: cac348e7     	eor	x7, x7, x3, ror #18
    19bc: cac3a4e7     	eor	x7, x7, x3, ror #41
    19c0: 8a0300d3     	and	x19, x6, x3
    19c4: aa090269     	orr	x9, x19, x9
    19c8: 8b040284     	add	x4, x20, x4
    19cc: 8b090089     	add	x9, x4, x9
    19d0: d292f224     	mov	x4, #0x9791             ; =38801
    19d4: f2ba1f04     	movk	x4, #0xd0f8, lsl #16
    19d8: f2d16e04     	movk	x4, #0x8b70, lsl #32
    19dc: f2f84964     	movk	x4, #0xc24b, lsl #48
    19e0: 8b040129     	add	x9, x9, x4
    19e4: 8b070124     	add	x4, x9, x7
    19e8: 93ca7149     	ror	x9, x10, #0x1c
    19ec: caca8929     	eor	x9, x9, x10, ror #34
    19f0: caca9d29     	eor	x9, x9, x10, ror #39
    19f4: aa020027     	orr	x7, x1, x2
    19f8: 8a070147     	and	x7, x10, x7
    19fc: 8a020033     	and	x19, x1, x2
    1a00: aa1300e7     	orr	x7, x7, x19
    1a04: 8b070129     	add	x9, x9, x7
    1a08: 8b040129     	add	x9, x9, x4
    1a0c: 8b080084     	add	x4, x4, x8
    1a10: 8a2400c8     	bic	x8, x6, x4
    1a14: 93c43887     	ror	x7, x4, #0xe
    1a18: cac448e7     	eor	x7, x7, x4, ror #18
    1a1c: cac4a4e7     	eor	x7, x7, x4, ror #41
    1a20: 8a040073     	and	x19, x3, x4
    1a24: aa080268     	orr	x8, x19, x8
    1a28: a955d3f3     	ldp	x19, x20, [sp, #0x158]
    1a2c: 8b050265     	add	x5, x19, x5
    1a30: 8b0800a8     	add	x8, x5, x8
    1a34: d297c605     	mov	x5, #0xbe30             ; =48688
    1a38: f2a0ca85     	movk	x5, #0x654, lsl #16
    1a3c: f2ca3465     	movk	x5, #0x51a3, lsl #32
    1a40: f2f8ed85     	movk	x5, #0xc76c, lsl #48
    1a44: 8b050108     	add	x8, x8, x5
    1a48: 8b070105     	add	x5, x8, x7
    1a4c: 93c97128     	ror	x8, x9, #0x1c
    1a50: cac98908     	eor	x8, x8, x9, ror #34
    1a54: cac99d08     	eor	x8, x8, x9, ror #39
    1a58: aa010147     	orr	x7, x10, x1
    1a5c: 8a070127     	and	x7, x9, x7
    1a60: 8a010153     	and	x19, x10, x1
    1a64: aa1300e7     	orr	x7, x7, x19
    1a68: 8b070108     	add	x8, x8, x7
    1a6c: 8b050108     	add	x8, x8, x5
    1a70: 8b0200a5     	add	x5, x5, x2
    1a74: 8a250062     	bic	x2, x3, x5
    1a78: 93c538a7     	ror	x7, x5, #0xe
    1a7c: cac548e7     	eor	x7, x7, x5, ror #18
    1a80: cac5a4e7     	eor	x7, x7, x5, ror #41
    1a84: 8a050093     	and	x19, x4, x5
    1a88: aa020262     	orr	x2, x19, x2
    1a8c: 8b060286     	add	x6, x20, x6
    1a90: 8b0200c2     	add	x2, x6, x2
    1a94: d28a4306     	mov	x6, #0x5218             ; =21016
    1a98: f2badde6     	movk	x6, #0xd6ef, lsl #16
    1a9c: f2dd0326     	movk	x6, #0xe819, lsl #32
    1aa0: f2fa3246     	movk	x6, #0xd192, lsl #48
    1aa4: 8b060042     	add	x2, x2, x6
    1aa8: 8b070046     	add	x6, x2, x7
    1aac: 93c87102     	ror	x2, x8, #0x1c
    1ab0: cac88842     	eor	x2, x2, x8, ror #34
    1ab4: cac89c42     	eor	x2, x2, x8, ror #39
    1ab8: aa0a0127     	orr	x7, x9, x10
    1abc: 8a070107     	and	x7, x8, x7
    1ac0: 8a0a0133     	and	x19, x9, x10
    1ac4: aa1300e7     	orr	x7, x7, x19
    1ac8: 8b070042     	add	x2, x2, x7
    1acc: 8b060042     	add	x2, x2, x6
    1ad0: 8b0100c6     	add	x6, x6, x1
    1ad4: 8a260081     	bic	x1, x4, x6
    1ad8: 93c638c7     	ror	x7, x6, #0xe
    1adc: cac648e7     	eor	x7, x7, x6, ror #18
    1ae0: cac6a4e7     	eor	x7, x7, x6, ror #41
    1ae4: 8a0600b3     	and	x19, x5, x6
    1ae8: aa010261     	orr	x1, x19, x1
    1aec: a956d3f3     	ldp	x19, x20, [sp, #0x168]
    1af0: 8b030263     	add	x3, x19, x3
    1af4: 8b010061     	add	x1, x3, x1
    1af8: d2952203     	mov	x3, #0xa910             ; =43280
    1afc: f2aaaca3     	movk	x3, #0x5565, lsl #16
    1b00: f2c0c483     	movk	x3, #0x624, lsl #32
    1b04: f2fad323     	movk	x3, #0xd699, lsl #48
    1b08: 8b030021     	add	x1, x1, x3
    1b0c: 8b070023     	add	x3, x1, x7
    1b10: 93c27041     	ror	x1, x2, #0x1c
    1b14: cac28821     	eor	x1, x1, x2, ror #34
    1b18: cac29c21     	eor	x1, x1, x2, ror #39
    1b1c: aa090107     	orr	x7, x8, x9
    1b20: 8a070047     	and	x7, x2, x7
    1b24: 8a090113     	and	x19, x8, x9
    1b28: aa1300e7     	orr	x7, x7, x19
    1b2c: 8b070021     	add	x1, x1, x7
    1b30: 8b030021     	add	x1, x1, x3
    1b34: 8b0a0063     	add	x3, x3, x10
    1b38: 8a2300aa     	bic	x10, x5, x3
    1b3c: 93c33867     	ror	x7, x3, #0xe
    1b40: cac348e7     	eor	x7, x7, x3, ror #18
    1b44: cac3a4e7     	eor	x7, x7, x3, ror #41
    1b48: 8a0300d3     	and	x19, x6, x3
    1b4c: aa0a026a     	orr	x10, x19, x10
    1b50: 8b040284     	add	x4, x20, x4
    1b54: 8b0a008a     	add	x10, x4, x10
    1b58: d2840544     	mov	x4, #0x202a             ; =8234
    1b5c: f2aaee24     	movk	x4, #0x5771, lsl #16
    1b60: f2c6b0a4     	movk	x4, #0x3585, lsl #32
    1b64: f2fe81c4     	movk	x4, #0xf40e, lsl #48
    1b68: 8b04014a     	add	x10, x10, x4
    1b6c: 8b070144     	add	x4, x10, x7
    1b70: 93c1702a     	ror	x10, x1, #0x1c
    1b74: cac1894a     	eor	x10, x10, x1, ror #34
    1b78: cac19d4a     	eor	x10, x10, x1, ror #39
    1b7c: aa080047     	orr	x7, x2, x8
    1b80: 8a070027     	and	x7, x1, x7
    1b84: 8a080053     	and	x19, x2, x8
    1b88: aa1300e7     	orr	x7, x7, x19
    1b8c: 8b07014a     	add	x10, x10, x7
    1b90: 8b04014a     	add	x10, x10, x4
    1b94: 8b090084     	add	x4, x4, x9
    1b98: 8a2400c9     	bic	x9, x6, x4
    1b9c: 93c43887     	ror	x7, x4, #0xe
    1ba0: cac448e7     	eor	x7, x7, x4, ror #18
    1ba4: cac4a4e7     	eor	x7, x7, x4, ror #41
    1ba8: 8a040073     	and	x19, x3, x4
    1bac: aa090269     	orr	x9, x19, x9
    1bb0: a957d3f3     	ldp	x19, x20, [sp, #0x178]
    1bb4: 8b050265     	add	x5, x19, x5
    1bb8: 8b0900a9     	add	x9, x5, x9
    1bbc: d29a3705     	mov	x5, #0xd1b8             ; =53688
    1bc0: f2a65765     	movk	x5, #0x32bb, lsl #16
    1bc4: f2d40e05     	movk	x5, #0xa070, lsl #32
    1bc8: f2e20d45     	movk	x5, #0x106a, lsl #48
    1bcc: 8b050129     	add	x9, x9, x5
    1bd0: 8b070125     	add	x5, x9, x7
    1bd4: 93ca7149     	ror	x9, x10, #0x1c
    1bd8: caca8929     	eor	x9, x9, x10, ror #34
    1bdc: caca9d29     	eor	x9, x9, x10, ror #39
    1be0: aa020027     	orr	x7, x1, x2
    1be4: 8a070147     	and	x7, x10, x7
    1be8: 8a020033     	and	x19, x1, x2
    1bec: aa1300e7     	orr	x7, x7, x19
    1bf0: 8b070129     	add	x9, x9, x7
    1bf4: 8b050129     	add	x9, x9, x5
    1bf8: 8b0800a5     	add	x5, x5, x8
    1bfc: 8a250068     	bic	x8, x3, x5
    1c00: 93c538a7     	ror	x7, x5, #0xe
    1c04: cac548e7     	eor	x7, x7, x5, ror #18
    1c08: cac5a4e7     	eor	x7, x7, x5, ror #41
    1c0c: 8a050093     	and	x19, x4, x5
    1c10: aa080268     	orr	x8, x19, x8
    1c14: 8b060286     	add	x6, x20, x6
    1c18: 8b0800c8     	add	x8, x6, x8
    1c1c: d29a1906     	mov	x6, #0xd0c8             ; =53448
    1c20: f2b71a46     	movk	x6, #0xb8d2, lsl #16
    1c24: f2d822c6     	movk	x6, #0xc116, lsl #32
    1c28: f2e33486     	movk	x6, #0x19a4, lsl #48
    1c2c: 8b060108     	add	x8, x8, x6
    1c30: 8b070106     	add	x6, x8, x7
    1c34: 93c97128     	ror	x8, x9, #0x1c
    1c38: cac98908     	eor	x8, x8, x9, ror #34
    1c3c: cac99d08     	eor	x8, x8, x9, ror #39
    1c40: aa010147     	orr	x7, x10, x1
    1c44: 8a070127     	and	x7, x9, x7
    1c48: 8a010153     	and	x19, x10, x1
    1c4c: aa1300e7     	orr	x7, x7, x19
    1c50: 8b070108     	add	x8, x8, x7
    1c54: 8b060108     	add	x8, x8, x6
    1c58: 8b0200c6     	add	x6, x6, x2
    1c5c: 8a260082     	bic	x2, x4, x6
    1c60: 93c638c7     	ror	x7, x6, #0xe
    1c64: cac648e7     	eor	x7, x7, x6, ror #18
    1c68: cac6a4e7     	eor	x7, x7, x6, ror #41
    1c6c: 8a0600b3     	and	x19, x5, x6
    1c70: aa020262     	orr	x2, x19, x2
    1c74: a958d3f3     	ldp	x19, x20, [sp, #0x188]
    1c78: 8b030263     	add	x3, x19, x3
    1c7c: 8b020062     	add	x2, x3, x2
    1c80: d2956a63     	mov	x3, #0xab53             ; =43859
    1c84: f2aa2823     	movk	x3, #0x5141, lsl #16
    1c88: f2cd8103     	movk	x3, #0x6c08, lsl #32
    1c8c: f2e3c6e3     	movk	x3, #0x1e37, lsl #48
    1c90: 8b030042     	add	x2, x2, x3
    1c94: 8b070043     	add	x3, x2, x7
    1c98: 93c87102     	ror	x2, x8, #0x1c
    1c9c: cac88842     	eor	x2, x2, x8, ror #34
    1ca0: cac89c42     	eor	x2, x2, x8, ror #39
    1ca4: aa0a0127     	orr	x7, x9, x10
    1ca8: 8a070107     	and	x7, x8, x7
    1cac: 8a0a0133     	and	x19, x9, x10
    1cb0: aa1300e7     	orr	x7, x7, x19
    1cb4: 8b070042     	add	x2, x2, x7
    1cb8: 8b030042     	add	x2, x2, x3
    1cbc: 8b010063     	add	x3, x3, x1
    1cc0: 8a2300a1     	bic	x1, x5, x3
    1cc4: 93c33867     	ror	x7, x3, #0xe
    1cc8: cac348e7     	eor	x7, x7, x3, ror #18
    1ccc: cac3a4e7     	eor	x7, x7, x3, ror #41
    1cd0: 8a0300d3     	and	x19, x6, x3
    1cd4: aa010261     	orr	x1, x19, x1
    1cd8: 8b040284     	add	x4, x20, x4
    1cdc: 8b010081     	add	x1, x4, x1
    1ce0: d29d7324     	mov	x4, #0xeb99             ; =60313
    1ce4: f2bbf1c4     	movk	x4, #0xdf8e, lsl #16
    1ce8: f2cee984     	movk	x4, #0x774c, lsl #32
    1cec: f2e4e904     	movk	x4, #0x2748, lsl #48
    1cf0: 8b040021     	add	x1, x1, x4
    1cf4: 8b070024     	add	x4, x1, x7
    1cf8: 93c27041     	ror	x1, x2, #0x1c
    1cfc: cac28821     	eor	x1, x1, x2, ror #34
    1d00: cac29c21     	eor	x1, x1, x2, ror #39
    1d04: aa090107     	orr	x7, x8, x9
    1d08: 8a070047     	and	x7, x2, x7
    1d0c: 8a090113     	and	x19, x8, x9
    1d10: aa1300e7     	orr	x7, x7, x19
    1d14: 8b070021     	add	x1, x1, x7
    1d18: 8b040021     	add	x1, x1, x4
    1d1c: 8b0a0084     	add	x4, x4, x10
    1d20: 8a2400ca     	bic	x10, x6, x4
    1d24: 93c43887     	ror	x7, x4, #0xe
    1d28: cac448e7     	eor	x7, x7, x4, ror #18
    1d2c: cac4a4e7     	eor	x7, x7, x4, ror #41
    1d30: 8a040073     	and	x19, x3, x4
    1d34: aa0a026a     	orr	x10, x19, x10
    1d38: a959d3f3     	ldp	x19, x20, [sp, #0x198]
    1d3c: 8b050265     	add	x5, x19, x5
    1d40: 8b0a00aa     	add	x10, x5, x10
    1d44: d2891505     	mov	x5, #0x48a8             ; =18600
    1d48: f2bc3365     	movk	x5, #0xe19b, lsl #16
    1d4c: f2d796a5     	movk	x5, #0xbcb5, lsl #32
    1d50: f2e69605     	movk	x5, #0x34b0, lsl #48
    1d54: 8b05014a     	add	x10, x10, x5
    1d58: 8b070145     	add	x5, x10, x7
    1d5c: 93c1702a     	ror	x10, x1, #0x1c
    1d60: cac1894a     	eor	x10, x10, x1, ror #34
    1d64: cac19d4a     	eor	x10, x10, x1, ror #39
    1d68: aa080047     	orr	x7, x2, x8
    1d6c: 8a070027     	and	x7, x1, x7
    1d70: 8a080053     	and	x19, x2, x8
    1d74: aa1300e7     	orr	x7, x7, x19
    1d78: 8b07014a     	add	x10, x10, x7
    1d7c: 8b05014a     	add	x10, x10, x5
    1d80: 8b0900a5     	add	x5, x5, x9
    1d84: 8a250069     	bic	x9, x3, x5
    1d88: 93c538a7     	ror	x7, x5, #0xe
    1d8c: cac548e7     	eor	x7, x7, x5, ror #18
    1d90: cac5a4e7     	eor	x7, x7, x5, ror #41
    1d94: 8a050093     	and	x19, x4, x5
    1d98: aa090269     	orr	x9, x19, x9
    1d9c: 8b060286     	add	x6, x20, x6
    1da0: 8b0900c9     	add	x9, x6, x9
    1da4: d28b4c66     	mov	x6, #0x5a63             ; =23139
    1da8: f2b8b926     	movk	x6, #0xc5c9, lsl #16
    1dac: f2c19666     	movk	x6, #0xcb3, lsl #32
    1db0: f2e72386     	movk	x6, #0x391c, lsl #48
    1db4: 8b060129     	add	x9, x9, x6
    1db8: 8b070126     	add	x6, x9, x7
    1dbc: 93ca7149     	ror	x9, x10, #0x1c
    1dc0: caca8929     	eor	x9, x9, x10, ror #34
    1dc4: caca9d29     	eor	x9, x9, x10, ror #39
    1dc8: aa020027     	orr	x7, x1, x2
    1dcc: 8a070147     	and	x7, x10, x7
    1dd0: 8a020033     	and	x19, x1, x2
    1dd4: aa1300e7     	orr	x7, x7, x19
    1dd8: 8b070129     	add	x9, x9, x7
    1ddc: 8b060129     	add	x9, x9, x6
    1de0: 8b0800c6     	add	x6, x6, x8
    1de4: 8a260088     	bic	x8, x4, x6
    1de8: 93c638c7     	ror	x7, x6, #0xe
    1dec: cac648e7     	eor	x7, x7, x6, ror #18
    1df0: cac6a4e7     	eor	x7, x7, x6, ror #41
    1df4: 8a0600b3     	and	x19, x5, x6
    1df8: aa080268     	orr	x8, x19, x8
    1dfc: a95ad3f3     	ldp	x19, x20, [sp, #0x1a8]
    1e00: 8b030263     	add	x3, x19, x3
    1e04: 8b080068     	add	x8, x3, x8
    1e08: d2915963     	mov	x3, #0x8acb             ; =35531
    1e0c: f2bc6823     	movk	x3, #0xe341, lsl #16
    1e10: f2d54943     	movk	x3, #0xaa4a, lsl #32
    1e14: f2e9db03     	movk	x3, #0x4ed8, lsl #48
    1e18: 8b030108     	add	x8, x8, x3
    1e1c: 8b070103     	add	x3, x8, x7
    1e20: 93c97128     	ror	x8, x9, #0x1c
    1e24: cac98908     	eor	x8, x8, x9, ror #34
    1e28: cac99d08     	eor	x8, x8, x9, ror #39
    1e2c: aa010147     	orr	x7, x10, x1
    1e30: 8a070127     	and	x7, x9, x7
    1e34: 8a010153     	and	x19, x10, x1
    1e38: aa1300e7     	orr	x7, x7, x19
    1e3c: 8b070108     	add	x8, x8, x7
    1e40: 8b030108     	add	x8, x8, x3
    1e44: 8b020063     	add	x3, x3, x2
    1e48: 8a2300a2     	bic	x2, x5, x3
    1e4c: 93c33867     	ror	x7, x3, #0xe
    1e50: cac348e7     	eor	x7, x7, x3, ror #18
    1e54: cac3a4e7     	eor	x7, x7, x3, ror #41
    1e58: 8a0300d3     	and	x19, x6, x3
    1e5c: aa020262     	orr	x2, x19, x2
    1e60: 8b040284     	add	x4, x20, x4
    1e64: 8b020082     	add	x2, x4, x2
    1e68: d29c6e64     	mov	x4, #0xe373             ; =58227
    1e6c: f2aeec64     	movk	x4, #0x7763, lsl #16
    1e70: f2d949e4     	movk	x4, #0xca4f, lsl #32
    1e74: f2eb7384     	movk	x4, #0x5b9c, lsl #48
    1e78: 8b040042     	add	x2, x2, x4
    1e7c: 8b070044     	add	x4, x2, x7
    1e80: 93c87102     	ror	x2, x8, #0x1c
    1e84: cac88842     	eor	x2, x2, x8, ror #34
    1e88: cac89c42     	eor	x2, x2, x8, ror #39
    1e8c: aa0a0127     	orr	x7, x9, x10
    1e90: 8a070107     	and	x7, x8, x7
    1e94: 8a0a0133     	and	x19, x9, x10
    1e98: aa1300e7     	orr	x7, x7, x19
    1e9c: 8b070042     	add	x2, x2, x7
    1ea0: 8b040042     	add	x2, x2, x4
    1ea4: 8b010084     	add	x4, x4, x1
    1ea8: 8a2400c1     	bic	x1, x6, x4
    1eac: 93c43887     	ror	x7, x4, #0xe
    1eb0: cac448e7     	eor	x7, x7, x4, ror #18
    1eb4: cac4a4e7     	eor	x7, x7, x4, ror #41
    1eb8: 8a040073     	and	x19, x3, x4
    1ebc: aa010261     	orr	x1, x19, x1
    1ec0: a95bd3f3     	ldp	x19, x20, [sp, #0x1b8]
    1ec4: 8b050265     	add	x5, x19, x5
    1ec8: 8b0100a1     	add	x1, x5, x1
    1ecc: d2971465     	mov	x5, #0xb8a3             ; =47267
    1ed0: f2bad645     	movk	x5, #0xd6b2, lsl #16
    1ed4: f2cdfe65     	movk	x5, #0x6ff3, lsl #32
    1ed8: f2ed05c5     	movk	x5, #0x682e, lsl #48
    1edc: 8b050021     	add	x1, x1, x5
    1ee0: 8b070025     	add	x5, x1, x7
    1ee4: 93c27041     	ror	x1, x2, #0x1c
    1ee8: cac28821     	eor	x1, x1, x2, ror #34
    1eec: cac29c21     	eor	x1, x1, x2, ror #39
    1ef0: aa090107     	orr	x7, x8, x9
    1ef4: 8a070047     	and	x7, x2, x7
    1ef8: 8a090113     	and	x19, x8, x9
    1efc: aa1300e7     	orr	x7, x7, x19
    1f00: 8b070021     	add	x1, x1, x7
    1f04: 8b050021     	add	x1, x1, x5
    1f08: 8b0a00a5     	add	x5, x5, x10
    1f0c: 8a25006a     	bic	x10, x3, x5
    1f10: 93c538a7     	ror	x7, x5, #0xe
    1f14: cac548e7     	eor	x7, x7, x5, ror #18
    1f18: cac5a4e7     	eor	x7, x7, x5, ror #41
    1f1c: 8a050093     	and	x19, x4, x5
    1f20: aa0a026a     	orr	x10, x19, x10
    1f24: 8b060286     	add	x6, x20, x6
    1f28: 8b0a00ca     	add	x10, x6, x10
    1f2c: d2965f86     	mov	x6, #0xb2fc             ; =45820
    1f30: f2abbde6     	movk	x6, #0x5def, lsl #16
    1f34: f2d05dc6     	movk	x6, #0x82ee, lsl #32
    1f38: f2ee91e6     	movk	x6, #0x748f, lsl #48
    1f3c: 8b06014a     	add	x10, x10, x6
    1f40: 8b070146     	add	x6, x10, x7
    1f44: 93c1702a     	ror	x10, x1, #0x1c
    1f48: cac1894a     	eor	x10, x10, x1, ror #34
    1f4c: cac19d4a     	eor	x10, x10, x1, ror #39
    1f50: aa080047     	orr	x7, x2, x8
    1f54: 8a070027     	and	x7, x1, x7
    1f58: 8a080053     	and	x19, x2, x8
    1f5c: aa1300e7     	orr	x7, x7, x19
    1f60: 8b07014a     	add	x10, x10, x7
    1f64: 8b06014a     	add	x10, x10, x6
    1f68: 8b0900c6     	add	x6, x6, x9
    1f6c: 8a260089     	bic	x9, x4, x6
    1f70: 93c638c7     	ror	x7, x6, #0xe
    1f74: cac648e7     	eor	x7, x7, x6, ror #18
    1f78: cac6a4e7     	eor	x7, x7, x6, ror #41
    1f7c: 8a0600b3     	and	x19, x5, x6
    1f80: aa090269     	orr	x9, x19, x9
    1f84: a95cd3f3     	ldp	x19, x20, [sp, #0x1c8]
    1f88: 8b030263     	add	x3, x19, x3
    1f8c: 8b090069     	add	x9, x3, x9
    1f90: d285ec03     	mov	x3, #0x2f60             ; =12128
    1f94: f2a862e3     	movk	x3, #0x4317, lsl #16
    1f98: f2cc6de3     	movk	x3, #0x636f, lsl #32
    1f9c: f2ef14a3     	movk	x3, #0x78a5, lsl #48
    1fa0: 8b030129     	add	x9, x9, x3
    1fa4: 8b070123     	add	x3, x9, x7
    1fa8: 93ca7149     	ror	x9, x10, #0x1c
    1fac: caca8929     	eor	x9, x9, x10, ror #34
    1fb0: caca9d29     	eor	x9, x9, x10, ror #39
    1fb4: aa020027     	orr	x7, x1, x2
    1fb8: 8a070147     	and	x7, x10, x7
    1fbc: 8a020033     	and	x19, x1, x2
    1fc0: aa1300e7     	orr	x7, x7, x19
    1fc4: 8b070129     	add	x9, x9, x7
    1fc8: 8b030129     	add	x9, x9, x3
    1fcc: 8b080063     	add	x3, x3, x8
    1fd0: 8a2300a8     	bic	x8, x5, x3
    1fd4: 93c33867     	ror	x7, x3, #0xe
    1fd8: cac348e7     	eor	x7, x7, x3, ror #18
    1fdc: cac3a4e7     	eor	x7, x7, x3, ror #41
    1fe0: 8a0300d3     	and	x19, x6, x3
    1fe4: aa080268     	orr	x8, x19, x8
    1fe8: 8b040284     	add	x4, x20, x4
    1fec: 8b080088     	add	x8, x4, x8
    1ff0: d2956e44     	mov	x4, #0xab72             ; =43890
    1ff4: f2b43e04     	movk	x4, #0xa1f0, lsl #16
    1ff8: f2cf0284     	movk	x4, #0x7814, lsl #32
    1ffc: f2f09904     	movk	x4, #0x84c8, lsl #48
    2000: 8b040108     	add	x8, x8, x4
    2004: 8b070104     	add	x4, x8, x7
    2008: 93c97128     	ror	x8, x9, #0x1c
    200c: cac98908     	eor	x8, x8, x9, ror #34
    2010: cac99d08     	eor	x8, x8, x9, ror #39
    2014: aa010147     	orr	x7, x10, x1
    2018: 8a070127     	and	x7, x9, x7
    201c: 8a010153     	and	x19, x10, x1
    2020: aa1300e7     	orr	x7, x7, x19
    2024: 8b070108     	add	x8, x8, x7
    2028: 8b040108     	add	x8, x8, x4
    202c: 8b020084     	add	x4, x4, x2
    2030: 8a2400c2     	bic	x2, x6, x4
    2034: 93c43887     	ror	x7, x4, #0xe
    2038: cac448e7     	eor	x7, x7, x4, ror #18
    203c: cac4a4e7     	eor	x7, x7, x4, ror #41
    2040: 8a040073     	and	x19, x3, x4
    2044: aa020262     	orr	x2, x19, x2
    2048: a95dd3f3     	ldp	x19, x20, [sp, #0x1d8]
    204c: 8b050265     	add	x5, x19, x5
    2050: 8b0200a2     	add	x2, x5, x2
    2054: d2873d85     	mov	x5, #0x39ec             ; =14828
    2058: f2a34c85     	movk	x5, #0x1a64, lsl #16
    205c: f2c04105     	movk	x5, #0x208, lsl #32
    2060: f2f198e5     	movk	x5, #0x8cc7, lsl #48
    2064: 8b050042     	add	x2, x2, x5
    2068: 8b070045     	add	x5, x2, x7
    206c: 93c87102     	ror	x2, x8, #0x1c
    2070: cac88842     	eor	x2, x2, x8, ror #34
    2074: cac89c42     	eor	x2, x2, x8, ror #39
    2078: aa0a0127     	orr	x7, x9, x10
    207c: 8a070107     	and	x7, x8, x7
    2080: 8a0a0133     	and	x19, x9, x10
    2084: aa1300e7     	orr	x7, x7, x19
    2088: 8b070042     	add	x2, x2, x7
    208c: 8b050042     	add	x2, x2, x5
    2090: 8b0100a5     	add	x5, x5, x1
    2094: 8a250061     	bic	x1, x3, x5
    2098: 93c538a7     	ror	x7, x5, #0xe
    209c: cac548e7     	eor	x7, x7, x5, ror #18
    20a0: cac5a4e7     	eor	x7, x7, x5, ror #41
    20a4: 8a050093     	and	x19, x4, x5
    20a8: aa010261     	orr	x1, x19, x1
    20ac: 8b060286     	add	x6, x20, x6
    20b0: 8b0100c1     	add	x1, x6, x1
    20b4: d283c506     	mov	x6, #0x1e28             ; =7720
    20b8: f2a46c66     	movk	x6, #0x2363, lsl #16
    20bc: f2dfff46     	movk	x6, #0xfffa, lsl #32
    20c0: f2f217c6     	movk	x6, #0x90be, lsl #48
    20c4: 8b060021     	add	x1, x1, x6
    20c8: 8b070026     	add	x6, x1, x7
    20cc: 93c27041     	ror	x1, x2, #0x1c
    20d0: cac28821     	eor	x1, x1, x2, ror #34
    20d4: cac29c21     	eor	x1, x1, x2, ror #39
    20d8: aa090107     	orr	x7, x8, x9
    20dc: 8a070047     	and	x7, x2, x7
    20e0: 8a090113     	and	x19, x8, x9
    20e4: aa1300e7     	orr	x7, x7, x19
    20e8: 8b070021     	add	x1, x1, x7
    20ec: 8b060021     	add	x1, x1, x6
    20f0: 8b0a00ca     	add	x10, x6, x10
    20f4: 8a2a0086     	bic	x6, x4, x10
    20f8: 93ca3947     	ror	x7, x10, #0xe
    20fc: caca48e7     	eor	x7, x7, x10, ror #18
    2100: cacaa4e7     	eor	x7, x7, x10, ror #41
    2104: 8a0a00b3     	and	x19, x5, x10
    2108: aa060266     	orr	x6, x19, x6
    210c: a95ed3f3     	ldp	x19, x20, [sp, #0x1e8]
    2110: 8b030263     	add	x3, x19, x3
    2114: 8b060063     	add	x3, x3, x6
    2118: d297bd26     	mov	x6, #0xbde9             ; =48617
    211c: f2bbd046     	movk	x6, #0xde82, lsl #16
    2120: f2cd9d66     	movk	x6, #0x6ceb, lsl #32
    2124: f2f48a06     	movk	x6, #0xa450, lsl #48
    2128: 8b060063     	add	x3, x3, x6
    212c: 8b070066     	add	x6, x3, x7
    2130: 93c17023     	ror	x3, x1, #0x1c
    2134: cac18863     	eor	x3, x3, x1, ror #34
    2138: cac19c63     	eor	x3, x3, x1, ror #39
    213c: aa080047     	orr	x7, x2, x8
    2140: 8a070027     	and	x7, x1, x7
    2144: 8a080053     	and	x19, x2, x8
    2148: aa1300e7     	orr	x7, x7, x19
    214c: 8b070063     	add	x3, x3, x7
    2150: 8b060063     	add	x3, x3, x6
    2154: 8b0900c7     	add	x7, x6, x9
    2158: 8a2700a9     	bic	x9, x5, x7
    215c: 93c738e6     	ror	x6, x7, #0xe
    2160: cac748c6     	eor	x6, x6, x7, ror #18
    2164: cac7a4c6     	eor	x6, x6, x7, ror #41
    2168: 8a070153     	and	x19, x10, x7
    216c: aa090269     	orr	x9, x19, x9
    2170: 8b040284     	add	x4, x20, x4
    2174: 8b090089     	add	x9, x4, x9
    2178: d28f22a4     	mov	x4, #0x7915             ; =30997
    217c: f2b658c4     	movk	x4, #0xb2c6, lsl #16
    2180: f2d47ee4     	movk	x4, #0xa3f7, lsl #32
    2184: f2f7df24     	movk	x4, #0xbef9, lsl #48
    2188: 8b040129     	add	x9, x9, x4
    218c: 8b060124     	add	x4, x9, x6
    2190: 93c37069     	ror	x9, x3, #0x1c
    2194: cac38929     	eor	x9, x9, x3, ror #34
    2198: cac39d29     	eor	x9, x9, x3, ror #39
    219c: aa020026     	orr	x6, x1, x2
    21a0: 8a060066     	and	x6, x3, x6
    21a4: 8a020033     	and	x19, x1, x2
    21a8: aa1300c6     	orr	x6, x6, x19
    21ac: 8b060129     	add	x9, x9, x6
    21b0: 8b040129     	add	x9, x9, x4
    21b4: 8b080086     	add	x6, x4, x8
    21b8: 8a260148     	bic	x8, x10, x6
    21bc: 93c638c4     	ror	x4, x6, #0xe
    21c0: cac64884     	eor	x4, x4, x6, ror #18
    21c4: cac6a484     	eor	x4, x4, x6, ror #41
    21c8: 8a0600f3     	and	x19, x7, x6
    21cc: aa080268     	orr	x8, x19, x8
    21d0: a95fd3f3     	ldp	x19, x20, [sp, #0x1f8]
    21d4: 8b050265     	add	x5, x19, x5
    21d8: 8b0800a8     	add	x8, x5, x8
    21dc: d28a6565     	mov	x5, #0x532b             ; =21291
    21e0: f2bc6e45     	movk	x5, #0xe372, lsl #16
    21e4: f2cf1e45     	movk	x5, #0x78f2, lsl #32
    21e8: f2f8ce25     	movk	x5, #0xc671, lsl #48
    21ec: 8b050108     	add	x8, x8, x5
    21f0: 8b040108     	add	x8, x8, x4
    21f4: 93c97124     	ror	x4, x9, #0x1c
    21f8: cac98884     	eor	x4, x4, x9, ror #34
    21fc: cac99c84     	eor	x4, x4, x9, ror #39
    2200: aa010065     	orr	x5, x3, x1
    2204: 8a050125     	and	x5, x9, x5
    2208: 8a010073     	and	x19, x3, x1
    220c: aa1300a5     	orr	x5, x5, x19
    2210: 8b050084     	add	x4, x4, x5
    2214: 8b080084     	add	x4, x4, x8
    2218: 8b020113     	add	x19, x8, x2
    221c: 8a3300e8     	bic	x8, x7, x19
    2220: 93d33a62     	ror	x2, x19, #0xe
    2224: 8a1300c5     	and	x5, x6, x19
    2228: aa0800a8     	orr	x8, x5, x8
    222c: cad34842     	eor	x2, x2, x19, ror #18
    2230: cad3a442     	eor	x2, x2, x19, ror #41
    2234: 8b0a028a     	add	x10, x20, x10
    2238: 8b080148     	add	x8, x10, x8
    223c: d28c338a     	mov	x10, #0x619c            ; =24988
    2240: f2bd44ca     	movk	x10, #0xea26, lsl #16
    2244: f2c7d9ca     	movk	x10, #0x3ece, lsl #32
    2248: f2f944ea     	movk	x10, #0xca27, lsl #48
    224c: 8b0a0108     	add	x8, x8, x10
    2250: 8b02010a     	add	x10, x8, x2
    2254: 93c47088     	ror	x8, x4, #0x1c
    2258: cac48908     	eor	x8, x8, x4, ror #34
    225c: cac49d08     	eor	x8, x8, x4, ror #39
    2260: aa030122     	orr	x2, x9, x3
    2264: 8a020082     	and	x2, x4, x2
    2268: 8a030125     	and	x5, x9, x3
    226c: aa050042     	orr	x2, x2, x5
    2270: 8b020108     	add	x8, x8, x2
    2274: 8b0a0108     	add	x8, x8, x10
    2278: 8b010142     	add	x2, x10, x1
    227c: 8a2200ca     	bic	x10, x6, x2
    2280: 93c23841     	ror	x1, x2, #0xe
    2284: cac24821     	eor	x1, x1, x2, ror #18
    2288: cac2a421     	eor	x1, x1, x2, ror #41
    228c: 8a020265     	and	x5, x19, x2
    2290: aa0a00aa     	orr	x10, x5, x10
    2294: f94107e5     	ldr	x5, [sp, #0x208]
    2298: 8b0700a5     	add	x5, x5, x7
    229c: 8b0a00aa     	add	x10, x5, x10
    22a0: d29840e5     	mov	x5, #0xc207             ; =49671
    22a4: f2a43805     	movk	x5, #0x21c0, lsl #16
    22a8: f2d718e5     	movk	x5, #0xb8c7, lsl #32
    22ac: f2fa30c5     	movk	x5, #0xd186, lsl #48
    22b0: 8b05014a     	add	x10, x10, x5
    22b4: 8b010141     	add	x1, x10, x1
    22b8: 93c8710a     	ror	x10, x8, #0x1c
    22bc: cac8894a     	eor	x10, x10, x8, ror #34
    22c0: cac89d4a     	eor	x10, x10, x8, ror #39
    22c4: aa090085     	orr	x5, x4, x9
    22c8: 8a050105     	and	x5, x8, x5
    22cc: 8a090087     	and	x7, x4, x9
    22d0: aa0700a5     	orr	x5, x5, x7
    22d4: 8b05014a     	add	x10, x10, x5
    22d8: 8b01014a     	add	x10, x10, x1
    22dc: 8b030023     	add	x3, x1, x3
    22e0: 8a230261     	bic	x1, x19, x3
    22e4: 93c33865     	ror	x5, x3, #0xe
    22e8: cac348a5     	eor	x5, x5, x3, ror #18
    22ec: cac3a4a5     	eor	x5, x5, x3, ror #41
    22f0: 8a030047     	and	x7, x2, x3
    22f4: aa0100e1     	orr	x1, x7, x1
    22f8: f9410be7     	ldr	x7, [sp, #0x210]
    22fc: 8b0600e6     	add	x6, x7, x6
    2300: 8b0100c1     	add	x1, x6, x1
    2304: d29d63c6     	mov	x6, #0xeb1e             ; =60190
    2308: f2b9bc06     	movk	x6, #0xcde0, lsl #16
    230c: f2cfbac6     	movk	x6, #0x7dd6, lsl #32
    2310: f2fd5b46     	movk	x6, #0xeada, lsl #48
    2314: 8b060021     	add	x1, x1, x6
    2318: 8b050025     	add	x5, x1, x5
    231c: 93ca7141     	ror	x1, x10, #0x1c
    2320: caca8821     	eor	x1, x1, x10, ror #34
    2324: caca9c21     	eor	x1, x1, x10, ror #39
    2328: aa040106     	orr	x6, x8, x4
    232c: 8a060146     	and	x6, x10, x6
    2330: 8a040107     	and	x7, x8, x4
    2334: aa0700c6     	orr	x6, x6, x7
    2338: 8b060021     	add	x1, x1, x6
    233c: 8b050021     	add	x1, x1, x5
    2340: 8b0900a5     	add	x5, x5, x9
    2344: 8a250049     	bic	x9, x2, x5
    2348: 93c538a6     	ror	x6, x5, #0xe
    234c: cac548c6     	eor	x6, x6, x5, ror #18
    2350: cac5a4c6     	eor	x6, x6, x5, ror #41
    2354: 8a050067     	and	x7, x3, x5
    2358: aa0900e9     	orr	x9, x7, x9
    235c: f9410fe7     	ldr	x7, [sp, #0x218]
    2360: 8b1300e7     	add	x7, x7, x19
    2364: 8b0900e9     	add	x9, x7, x9
    2368: d29a2f07     	mov	x7, #0xd178             ; =53624
    236c: f2bdcdc7     	movk	x7, #0xee6e, lsl #16
    2370: f2c9efe7     	movk	x7, #0x4f7f, lsl #32
    2374: f2feafa7     	movk	x7, #0xf57d, lsl #48
    2378: 8b070129     	add	x9, x9, x7
    237c: 8b060126     	add	x6, x9, x6
    2380: 93c17029     	ror	x9, x1, #0x1c
    2384: cac18929     	eor	x9, x9, x1, ror #34
    2388: cac19d29     	eor	x9, x9, x1, ror #39
    238c: aa080147     	orr	x7, x10, x8
    2390: 8a070027     	and	x7, x1, x7
    2394: 8a080153     	and	x19, x10, x8
    2398: aa1300e7     	orr	x7, x7, x19
    239c: 8b070129     	add	x9, x9, x7
    23a0: 8b060129     	add	x9, x9, x6
    23a4: 8b0400c4     	add	x4, x6, x4
    23a8: 8a240066     	bic	x6, x3, x4
    23ac: 93c43887     	ror	x7, x4, #0xe
    23b0: cac448e7     	eor	x7, x7, x4, ror #18
    23b4: cac4a4e7     	eor	x7, x7, x4, ror #41
    23b8: 8a0400b3     	and	x19, x5, x4
    23bc: aa060266     	orr	x6, x19, x6
    23c0: f94113f3     	ldr	x19, [sp, #0x220]
    23c4: 8b020262     	add	x2, x19, x2
    23c8: 8b060042     	add	x2, x2, x6
    23cc: d28df746     	mov	x6, #0x6fba             ; =28602
    23d0: f2ae42e6     	movk	x6, #0x7217, lsl #16
    23d4: f2ccf546     	movk	x6, #0x67aa, lsl #32
    23d8: f2e0de06     	movk	x6, #0x6f0, lsl #48
    23dc: 8b060042     	add	x2, x2, x6
    23e0: 8b070046     	add	x6, x2, x7
    23e4: 93c97122     	ror	x2, x9, #0x1c
    23e8: cac98842     	eor	x2, x2, x9, ror #34
    23ec: cac99c42     	eor	x2, x2, x9, ror #39
    23f0: aa0a0027     	orr	x7, x1, x10
    23f4: 8a070127     	and	x7, x9, x7
    23f8: 8a0a0033     	and	x19, x1, x10
    23fc: aa1300e7     	orr	x7, x7, x19
    2400: 8b070042     	add	x2, x2, x7
    2404: 8b060042     	add	x2, x2, x6
    2408: 8b0800c6     	add	x6, x6, x8
    240c: 8a2600a8     	bic	x8, x5, x6
    2410: 93c638c7     	ror	x7, x6, #0xe
    2414: cac648e7     	eor	x7, x7, x6, ror #18
    2418: cac6a4e7     	eor	x7, x7, x6, ror #41
    241c: 8a060093     	and	x19, x4, x6
    2420: aa080268     	orr	x8, x19, x8
    2424: f94117f3     	ldr	x19, [sp, #0x228]
    2428: 8b030263     	add	x3, x19, x3
    242c: 8b080068     	add	x8, x3, x8
    2430: d29314c3     	mov	x3, #0x98a6             ; =39078
    2434: f2b45903     	movk	x3, #0xa2c8, lsl #16
    2438: f2cfb8a3     	movk	x3, #0x7dc5, lsl #32
    243c: f2e14c63     	movk	x3, #0xa63, lsl #48
    2440: 8b030108     	add	x8, x8, x3
    2444: 8b070103     	add	x3, x8, x7
    2448: 93c27048     	ror	x8, x2, #0x1c
    244c: cac28908     	eor	x8, x8, x2, ror #34
    2450: cac29d08     	eor	x8, x8, x2, ror #39
    2454: aa010127     	orr	x7, x9, x1
    2458: 8a070047     	and	x7, x2, x7
    245c: 8a010133     	and	x19, x9, x1
    2460: aa1300e7     	orr	x7, x7, x19
    2464: 8b070108     	add	x8, x8, x7
    2468: 8b030108     	add	x8, x8, x3
    246c: 8b0a0063     	add	x3, x3, x10
    2470: 8a23008a     	bic	x10, x4, x3
    2474: 93c33867     	ror	x7, x3, #0xe
    2478: cac348e7     	eor	x7, x7, x3, ror #18
    247c: cac3a4e7     	eor	x7, x7, x3, ror #41
    2480: 8a0300d3     	and	x19, x6, x3
    2484: aa0a026a     	orr	x10, x19, x10
    2488: f9411bf3     	ldr	x19, [sp, #0x230]
    248c: 8b050265     	add	x5, x19, x5
    2490: 8b0a00aa     	add	x10, x5, x10
    2494: d281b5c5     	mov	x5, #0xdae              ; =3502
    2498: f2b7df25     	movk	x5, #0xbef9, lsl #16
    249c: f2d30085     	movk	x5, #0x9804, lsl #32
    24a0: f2e227e5     	movk	x5, #0x113f, lsl #48
    24a4: 8b05014a     	add	x10, x10, x5
    24a8: 8b070145     	add	x5, x10, x7
    24ac: 93c8710a     	ror	x10, x8, #0x1c
    24b0: cac8894a     	eor	x10, x10, x8, ror #34
    24b4: cac89d4a     	eor	x10, x10, x8, ror #39
    24b8: aa090047     	orr	x7, x2, x9
    24bc: 8a070107     	and	x7, x8, x7
    24c0: 8a090053     	and	x19, x2, x9
    24c4: aa1300e7     	orr	x7, x7, x19
    24c8: 8b07014a     	add	x10, x10, x7
    24cc: 8b05014a     	add	x10, x10, x5
    24d0: 8b0100a5     	add	x5, x5, x1
    24d4: 8a2500c1     	bic	x1, x6, x5
    24d8: 93c538a7     	ror	x7, x5, #0xe
    24dc: cac548e7     	eor	x7, x7, x5, ror #18
    24e0: cac5a4e7     	eor	x7, x7, x5, ror #41
    24e4: 8a050073     	and	x19, x3, x5
    24e8: aa010261     	orr	x1, x19, x1
    24ec: f9411ff3     	ldr	x19, [sp, #0x238]
    24f0: 8b040264     	add	x4, x19, x4
    24f4: 8b010081     	add	x1, x4, x1
    24f8: d288e364     	mov	x4, #0x471b             ; =18203
    24fc: f2a26384     	movk	x4, #0x131c, lsl #16
    2500: f2c166a4     	movk	x4, #0xb35, lsl #32
    2504: f2e36e24     	movk	x4, #0x1b71, lsl #48
    2508: 8b040021     	add	x1, x1, x4
    250c: 8b070024     	add	x4, x1, x7
    2510: 93ca7141     	ror	x1, x10, #0x1c
    2514: caca8821     	eor	x1, x1, x10, ror #34
    2518: caca9c21     	eor	x1, x1, x10, ror #39
    251c: aa020107     	orr	x7, x8, x2
    2520: 8a070147     	and	x7, x10, x7
    2524: 8a020113     	and	x19, x8, x2
    2528: aa1300e7     	orr	x7, x7, x19
    252c: 8b070021     	add	x1, x1, x7
    2530: 8b040021     	add	x1, x1, x4
    2534: 8b090084     	add	x4, x4, x9
    2538: 8a240069     	bic	x9, x3, x4
    253c: 93c43887     	ror	x7, x4, #0xe
    2540: cac448e7     	eor	x7, x7, x4, ror #18
    2544: cac4a4e7     	eor	x7, x7, x4, ror #41
    2548: 8a0400b3     	and	x19, x5, x4
    254c: aa090269     	orr	x9, x19, x9
    2550: f94123f3     	ldr	x19, [sp, #0x240]
    2554: 8b060266     	add	x6, x19, x6
    2558: 8b0900c9     	add	x9, x6, x9
    255c: d28fb086     	mov	x6, #0x7d84             ; =32132
    2560: f2a46086     	movk	x6, #0x2304, lsl #16
    2564: f2cefea6     	movk	x6, #0x77f5, lsl #32
    2568: f2e51b66     	movk	x6, #0x28db, lsl #48
    256c: 8b060129     	add	x9, x9, x6
    2570: 8b070126     	add	x6, x9, x7
    2574: 93c17029     	ror	x9, x1, #0x1c
    2578: cac18929     	eor	x9, x9, x1, ror #34
    257c: cac19d29     	eor	x9, x9, x1, ror #39
    2580: aa080147     	orr	x7, x10, x8
    2584: 8a070027     	and	x7, x1, x7
    2588: 8a080153     	and	x19, x10, x8
    258c: aa1300e7     	orr	x7, x7, x19
    2590: 8b070129     	add	x9, x9, x7
    2594: 8b060129     	add	x9, x9, x6
    2598: 8b0200c6     	add	x6, x6, x2
    259c: 8a2600a2     	bic	x2, x5, x6
    25a0: 93c638c7     	ror	x7, x6, #0xe
    25a4: cac648e7     	eor	x7, x7, x6, ror #18
    25a8: cac6a4e7     	eor	x7, x7, x6, ror #41
    25ac: 8a060093     	and	x19, x4, x6
    25b0: aa020262     	orr	x2, x19, x2
    25b4: f94127f3     	ldr	x19, [sp, #0x248]
    25b8: 8b030263     	add	x3, x19, x3
    25bc: 8b020062     	add	x2, x3, x2
    25c0: d2849263     	mov	x3, #0x2493             ; =9363
    25c4: f2a818e3     	movk	x3, #0x40c7, lsl #16
    25c8: f2d56f63     	movk	x3, #0xab7b, lsl #32
    25cc: f2e65943     	movk	x3, #0x32ca, lsl #48
    25d0: 8b030042     	add	x2, x2, x3
    25d4: 8b070043     	add	x3, x2, x7
    25d8: 93c97122     	ror	x2, x9, #0x1c
    25dc: cac98842     	eor	x2, x2, x9, ror #34
    25e0: cac99c42     	eor	x2, x2, x9, ror #39
    25e4: aa0a0027     	orr	x7, x1, x10
    25e8: 8a070127     	and	x7, x9, x7
    25ec: 8a0a0033     	and	x19, x1, x10
    25f0: aa1300e7     	orr	x7, x7, x19
    25f4: 8b070042     	add	x2, x2, x7
    25f8: 8b030042     	add	x2, x2, x3
    25fc: 8b080067     	add	x7, x3, x8
    2600: 8a270088     	bic	x8, x4, x7
    2604: 93c738e3     	ror	x3, x7, #0xe
    2608: cac74863     	eor	x3, x3, x7, ror #18
    260c: cac7a463     	eor	x3, x3, x7, ror #41
    2610: 8a0700d3     	and	x19, x6, x7
    2614: aa080268     	orr	x8, x19, x8
    2618: f9412bf3     	ldr	x19, [sp, #0x250]
    261c: 8b050265     	add	x5, x19, x5
    2620: 8b0800a8     	add	x8, x5, x8
    2624: d297d785     	mov	x5, #0xbebc             ; =48828
    2628: f2a2b925     	movk	x5, #0x15c9, lsl #16
    262c: f2d7c145     	movk	x5, #0xbe0a, lsl #32
    2630: f2e793c5     	movk	x5, #0x3c9e, lsl #48
    2634: 8b050108     	add	x8, x8, x5
    2638: 8b030108     	add	x8, x8, x3
    263c: 93c27043     	ror	x3, x2, #0x1c
    2640: cac28863     	eor	x3, x3, x2, ror #34
    2644: cac29c63     	eor	x3, x3, x2, ror #39
    2648: aa010125     	orr	x5, x9, x1
    264c: 8a050045     	and	x5, x2, x5
    2650: 8a010133     	and	x19, x9, x1
    2654: aa1300a5     	orr	x5, x5, x19
    2658: 8b050063     	add	x3, x3, x5
    265c: 8b080063     	add	x3, x3, x8
    2660: 8b0a010a     	add	x10, x8, x10
    2664: 8a2a00c8     	bic	x8, x6, x10
    2668: 93ca3945     	ror	x5, x10, #0xe
    266c: caca48a5     	eor	x5, x5, x10, ror #18
    2670: cacaa4a5     	eor	x5, x5, x10, ror #41
    2674: 8a0a00f3     	and	x19, x7, x10
    2678: aa080268     	orr	x8, x19, x8
    267c: f9412ff3     	ldr	x19, [sp, #0x258]
    2680: 8b040264     	add	x4, x19, x4
    2684: 8b080088     	add	x8, x4, x8
    2688: d281a984     	mov	x4, #0xd4c              ; =3404
    268c: f2b38204     	movk	x4, #0x9c10, lsl #16
    2690: f2ccf884     	movk	x4, #0x67c4, lsl #32
    2694: f2e863a4     	movk	x4, #0x431d, lsl #48
    2698: 8b040108     	add	x8, x8, x4
    269c: 8b050104     	add	x4, x8, x5
    26a0: 93c37068     	ror	x8, x3, #0x1c
    26a4: cac38908     	eor	x8, x8, x3, ror #34
    26a8: cac39d08     	eor	x8, x8, x3, ror #39
    26ac: aa090045     	orr	x5, x2, x9
    26b0: 8a050065     	and	x5, x3, x5
    26b4: 8a090053     	and	x19, x2, x9
    26b8: aa1300a5     	orr	x5, x5, x19
    26bc: 8b050108     	add	x8, x8, x5
    26c0: 8b040108     	add	x8, x8, x4
    26c4: 8b010081     	add	x1, x4, x1
    26c8: 8a2100e4     	bic	x4, x7, x1
    26cc: 93c13825     	ror	x5, x1, #0xe
    26d0: cac148a5     	eor	x5, x5, x1, ror #18
    26d4: cac1a4a5     	eor	x5, x5, x1, ror #41
    26d8: 8a010153     	and	x19, x10, x1
    26dc: aa040264     	orr	x4, x19, x4
    26e0: f94133f3     	ldr	x19, [sp, #0x260]
    26e4: 8b060266     	add	x6, x19, x6
    26e8: 8b0400c4     	add	x4, x6, x4
    26ec: d28856c6     	mov	x6, #0x42b6             ; =17078
    26f0: f2b967c6     	movk	x6, #0xcb3e, lsl #16
    26f4: f2da97c6     	movk	x6, #0xd4be, lsl #32
    26f8: f2e998a6     	movk	x6, #0x4cc5, lsl #48
    26fc: 8b060084     	add	x4, x4, x6
    2700: 8b050085     	add	x5, x4, x5
    2704: 93c87104     	ror	x4, x8, #0x1c
    2708: cac88884     	eor	x4, x4, x8, ror #34
    270c: cac89c84     	eor	x4, x4, x8, ror #39
    2710: aa020066     	orr	x6, x3, x2
    2714: 8a060106     	and	x6, x8, x6
    2718: 8a020073     	and	x19, x3, x2
    271c: aa1300c6     	orr	x6, x6, x19
    2720: 8b060084     	add	x4, x4, x6
    2724: 8b050084     	add	x4, x4, x5
    2728: 8b0900a9     	add	x9, x5, x9
    272c: 8a290145     	bic	x5, x10, x9
    2730: 93c93926     	ror	x6, x9, #0xe
    2734: cac948c6     	eor	x6, x6, x9, ror #18
    2738: cac9a4c6     	eor	x6, x6, x9, ror #41
    273c: 8a090033     	and	x19, x1, x9
    2740: aa050265     	orr	x5, x19, x5
    2744: f94137f3     	ldr	x19, [sp, #0x268]
    2748: 8b070267     	add	x7, x19, x7
    274c: 8b0500e5     	add	x5, x7, x5
    2750: d28fc547     	mov	x7, #0x7e2a             ; =32298
    2754: f2bf8ca7     	movk	x7, #0xfc65, lsl #16
    2758: f2c53387     	movk	x7, #0x299c, lsl #32
    275c: f2eb2fe7     	movk	x7, #0x597f, lsl #48
    2760: 8b0700a5     	add	x5, x5, x7
    2764: 8b0600a5     	add	x5, x5, x6
    2768: 93c47086     	ror	x6, x4, #0x1c
    276c: cac488c6     	eor	x6, x6, x4, ror #34
    2770: cac49cc6     	eor	x6, x6, x4, ror #39
    2774: aa030107     	orr	x7, x8, x3
    2778: 8a070087     	and	x7, x4, x7
    277c: 8a030113     	and	x19, x8, x3
    2780: aa1300e7     	orr	x7, x7, x19
    2784: 8b0700c6     	add	x6, x6, x7
    2788: 8b0500c6     	add	x6, x6, x5
    278c: 8b0200a2     	add	x2, x5, x2
    2790: 8a220025     	bic	x5, x1, x2
    2794: 93c23847     	ror	x7, x2, #0xe
    2798: cac248e7     	eor	x7, x7, x2, ror #18
    279c: cac2a4e7     	eor	x7, x7, x2, ror #41
    27a0: 8a020133     	and	x19, x9, x2
    27a4: aa050265     	orr	x5, x19, x5
    27a8: f9413bf3     	ldr	x19, [sp, #0x270]
    27ac: 8b0a026a     	add	x10, x19, x10
    27b0: 8b05014a     	add	x10, x10, x5
    27b4: d29f5d85     	mov	x5, #0xfaec             ; =64236
    27b8: f2a75ac5     	movk	x5, #0x3ad6, lsl #16
    27bc: f2cdf565     	movk	x5, #0x6fab, lsl #32
    27c0: f2ebf965     	movk	x5, #0x5fcb, lsl #48
    27c4: 8b05014a     	add	x10, x10, x5
    27c8: 8b07014a     	add	x10, x10, x7
    27cc: 93c670c5     	ror	x5, x6, #0x1c
    27d0: cac688a5     	eor	x5, x5, x6, ror #34
    27d4: cac69ca5     	eor	x5, x5, x6, ror #39
    27d8: aa080087     	orr	x7, x4, x8
    27dc: 8a0700c7     	and	x7, x6, x7
    27e0: 8a080093     	and	x19, x4, x8
    27e4: aa1300e7     	orr	x7, x7, x19
    27e8: 8b0700a5     	add	x5, x5, x7
    27ec: 8b0a00a5     	add	x5, x5, x10
    27f0: 8b03014a     	add	x10, x10, x3
    27f4: 8a2a0123     	bic	x3, x9, x10
    27f8: 93ca3947     	ror	x7, x10, #0xe
    27fc: caca48e7     	eor	x7, x7, x10, ror #18
    2800: cacaa4e7     	eor	x7, x7, x10, ror #41
    2804: 8a0a0053     	and	x19, x2, x10
    2808: aa030263     	orr	x3, x19, x3
    280c: f9413ff3     	ldr	x19, [sp, #0x278]
    2810: 8b010261     	add	x1, x19, x1
    2814: 8b030021     	add	x1, x1, x3
    2818: d28b02e3     	mov	x3, #0x5817             ; =22551
    281c: f2a948e3     	movk	x3, #0x4a47, lsl #16
    2820: f2c33183     	movk	x3, #0x198c, lsl #32
    2824: f2ed8883     	movk	x3, #0x6c44, lsl #48
    2828: 8b030021     	add	x1, x1, x3
    282c: 8b070021     	add	x1, x1, x7
    2830: aa0400c3     	orr	x3, x6, x4
    2834: 8a0300a3     	and	x3, x5, x3
    2838: 8a0400c7     	and	x7, x6, x4
    283c: aa070063     	orr	x3, x3, x7
    2840: 93c570a7     	ror	x7, x5, #0x1c
    2844: cac588e7     	eor	x7, x7, x5, ror #34
    2848: cac59ce7     	eor	x7, x7, x5, ror #39
    284c: 8b0300e3     	add	x3, x7, x3
    2850: 8b010063     	add	x3, x3, x1
    2854: 8b03018c     	add	x12, x12, x3
    2858: 8b050210     	add	x16, x16, x5
    285c: a901400c     	stp	x12, x16, [x0, #0x10]
    2860: 8b06022c     	add	x12, x17, x6
    2864: 8b04016b     	add	x11, x11, x4
    2868: a9022c0c     	stp	x12, x11, [x0, #0x20]
    286c: 8b0801c8     	add	x8, x14, x8
    2870: 8b010108     	add	x8, x8, x1
    2874: 8b0a01aa     	add	x10, x13, x10
    2878: a9032808     	stp	x8, x10, [x0, #0x30]
    287c: 8b0201e8     	add	x8, x15, x2
    2880: f940240a     	ldr	x10, [x0, #0x48]
    2884: 8b090149     	add	x9, x10, x9
    2888: a9042408     	stp	x8, x9, [x0, #0x40]
    288c: 910a03ff     	add	sp, sp, #0x280
    2890: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    2894: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    2898: a8c36ffc     	ldp	x28, x27, [sp], #0x30
    289c: d65f03c0     	ret

00000000000028a0 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    28a0: a9bd57f6     	stp	x22, x21, [sp, #-0x30]!
    28a4: a9014ff4     	stp	x20, x19, [sp, #0x10]
    28a8: a9027bfd     	stp	x29, x30, [sp, #0x20]
    28ac: 910083fd     	add	x29, sp, #0x20
    28b0: aa0103f3     	mov	x19, x1
    28b4: aa0003f4     	mov	x20, x0
    28b8: 91014015     	add	x21, x0, #0x50
    28bc: 39434008     	ldrb	w8, [x0, #0xd0]
    28c0: 52801016     	mov	w22, #0x80              ; =128
    28c4: cb0802c1     	sub	x1, x22, x8
    28c8: 8b0802a0     	add	x0, x21, x8
<L0>:
    28cc: 94000000     	bl	 <L0>
		00000000000028cc:  ARM64_RELOC_BRANCH26	_bzero
    28d0: 39434288     	ldrb	w8, [x20, #0xd0]
    28d4: 38286ab6     	strb	w22, [x21, x8]
    28d8: 39434288     	ldrb	w8, [x20, #0xd0]
    28dc: 11000509     	add	w9, w8, #0x1
    28e0: 39034289     	strb	w9, [x20, #0xd0]
    28e4: 7101bd1f     	cmp	w8, #0x6f
    28e8: 54000129     	b.ls	 <L2>
    28ec: aa1403e0     	mov	x0, x20
    28f0: aa1503e1     	mov	x1, x21
<L1>:
    28f4: 94000000     	bl	 <L1>
		00000000000028f4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    28f8: 6f00e400     	movi.2d	v0, #0000000000000000
    28fc: ad0282a0     	stp	q0, q0, [x21, #0x50]
    2900: ad0182a0     	stp	q0, q0, [x21, #0x30]
    2904: ad0082a0     	stp	q0, q0, [x21, #0x10]
    2908: 3d8002a0     	str	q0, [x21]
<L2>:
    290c: a9402e8a     	ldp	x10, x11, [x20]
    2910: d345fd68     	lsr	x8, x11, #5
    2914: 531d7149     	lsl	w9, w10, #3
    2918: 39033e89     	strb	w9, [x20, #0xcf]
    291c: 53057d49     	lsr	w9, w10, #5
    2920: 39033a89     	strb	w9, [x20, #0xce]
    2924: d34dfd69     	lsr	x9, x11, #13
    2928: 530d7d4c     	lsr	w12, w10, #13
    292c: 3903368c     	strb	w12, [x20, #0xcd]
    2930: d355fd6c     	lsr	x12, x11, #21
    2934: 53157d4d     	lsr	w13, w10, #21
    2938: 93cad56e     	extr	x14, x11, x10, #0x35
    293c: 93cab56f     	extr	x15, x11, x10, #0x2d
    2940: 3903328d     	strb	w13, [x20, #0xcc]
    2944: 93ca956d     	extr	x13, x11, x10, #0x25
    2948: 93ca7570     	extr	x16, x11, x10, #0x1d
    294c: d35dfd71     	lsr	x17, x11, #29
    2950: d365fd60     	lsr	x0, x11, #37
    2954: d36dfd61     	lsr	x1, x11, #45
    2958: d375fd62     	lsr	x2, x11, #53
    295c: 9e670203     	fmov	d3, x16
    2960: 9e6701a2     	fmov	d2, x13
    2964: 9e6701e1     	fmov	d1, x15
    2968: 9e6701c0     	fmov	d0, x14
    296c: 9000000d     	adrp	x13, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		000000000000296c:  ARM64_RELOC_PAGE21	lCPI3_0
    2970: 3dc001a4     	ldr	q4, [x13]
		0000000000002970:  ARM64_RELOC_PAGEOFF12	lCPI3_0
    2974: 4e046000     	tbl.16b	v0, { v0, v1, v2, v3 }, v4
    2978: 93caf56a     	extr	x10, x11, x10, #0x3d
    297c: 0e212800     	xtn.8b	v0, v0
    2980: 1e270041     	fmov	s1, w2
    2984: 4e031c21     	mov.b	v1[1], w1
    2988: 4e051c01     	mov.b	v1[2], w0
    298c: 4e071e21     	mov.b	v1[3], w17
    2990: 4e091d81     	mov.b	v1[4], w12
    2994: 4e0b1d21     	mov.b	v1[5], w9
    2998: bd00ca80     	str	s0, [x20, #0xc8]
    299c: 4e0d1d01     	mov.b	v1[6], w8
    29a0: 4e0f1d41     	mov.b	v1[7], w10
    29a4: fd006281     	str	d1, [x20, #0xc0]
    29a8: aa1403e0     	mov	x0, x20
    29ac: aa1503e1     	mov	x1, x21
<L3>:
    29b0: 94000000     	bl	 <L3>
		00000000000029b0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    29b4: f9400a88     	ldr	x8, [x20, #0x10]
    29b8: dac00d08     	rev	x8, x8
    29bc: f9000268     	str	x8, [x19]
    29c0: f9400e88     	ldr	x8, [x20, #0x18]
    29c4: dac00d08     	rev	x8, x8
    29c8: f9000668     	str	x8, [x19, #0x8]
    29cc: f9401288     	ldr	x8, [x20, #0x20]
    29d0: dac00d08     	rev	x8, x8
    29d4: f9000a68     	str	x8, [x19, #0x10]
    29d8: f9401688     	ldr	x8, [x20, #0x28]
    29dc: dac00d08     	rev	x8, x8
    29e0: f9000e68     	str	x8, [x19, #0x18]
    29e4: f9401a88     	ldr	x8, [x20, #0x30]
    29e8: dac00d08     	rev	x8, x8
    29ec: f9001268     	str	x8, [x19, #0x20]
    29f0: f9401e88     	ldr	x8, [x20, #0x38]
    29f4: dac00d08     	rev	x8, x8
    29f8: f9001668     	str	x8, [x19, #0x28]
    29fc: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    2a00: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    2a04: a8c357f6     	ldp	x22, x21, [sp], #0x30
    2a08: d65f03c0     	ret

0000000000002a0c <_audit_master384>:
    2a0c: d10643ff     	sub	sp, sp, #0x190
    2a10: a9174ff4     	stp	x20, x19, [sp, #0x170]
    2a14: a9187bfd     	stp	x29, x30, [sp, #0x180]
    2a18: 910603fd     	add	x29, sp, #0x180
    2a1c: aa0103f3     	mov	x19, x1
    2a20: aa0003e4     	mov	x4, x0
    2a24: 90000008     	adrp	x8, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002a24:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    2a28: 91000108     	add	x8, x8, #0x0
		0000000000002a28:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    2a2c: ad400500     	ldp	q0, q1, [x8]
    2a30: 3c8713e0     	stur	q0, [sp, #0x71]
    2a34: 52860009     	mov	w9, #0x3000             ; =12288
    2a38: 7900c3e9     	strh	w9, [sp, #0x60]
    2a3c: 528001a9     	mov	w9, #0xd                ; =13
    2a40: 39018be9     	strb	w9, [sp, #0x62]
    2a44: 90000009     	adrp	x9, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002a44:  ARM64_RELOC_PAGE21	___anon_2099
    2a48: 91000129     	add	x9, x9, #0x0
		0000000000002a48:  ARM64_RELOC_PAGEOFF12	___anon_2099
    2a4c: f940012a     	ldr	x10, [x9]
    2a50: f80633ea     	stur	x10, [sp, #0x63]
    2a54: 910183ea     	add	x10, sp, #0x60
    2a58: f8405129     	ldur	x9, [x9, #0x5]
    2a5c: f90037e9     	str	x9, [sp, #0x68]
    2a60: 52800609     	mov	w9, #0x30               ; =48
    2a64: 3901c3e9     	strb	w9, [sp, #0x70]
    2a68: 3c821141     	stur	q1, [x10, #0x21]
    2a6c: 3dc00900     	ldr	q0, [x8, #0x20]
    2a70: 3c831140     	stur	q0, [x10, #0x31]
    2a74: 9100c3e0     	add	x0, sp, #0x30
    2a78: 910183e2     	add	x2, sp, #0x60
    2a7c: 52800601     	mov	w1, #0x30               ; =48
    2a80: 52800823     	mov	w3, #0x41               ; =65
<L0>:
    2a84: 94000000     	bl	 <L0>
		0000000000002a84:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
    2a88: 90000002     	adrp	x2, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002a88:  ARM64_RELOC_PAGE21	_memx.Array(48).zero
    2a8c: 91000042     	add	x2, x2, #0x0
		0000000000002a8c:  ARM64_RELOC_PAGEOFF12	_memx.Array(48).zero
    2a90: 910003e0     	mov	x0, sp
    2a94: 9100c3e1     	add	x1, sp, #0x30
<L1>:
    2a98: 94000000     	bl	 <L1>
		0000000000002a98:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
    2a9c: ad4007e0     	ldp	q0, q1, [sp]
    2aa0: ad000660     	stp	q0, q1, [x19]
    2aa4: 3dc00be0     	ldr	q0, [sp, #0x20]
    2aa8: 3d800a60     	str	q0, [x19, #0x20]
    2aac: a9587bfd     	ldp	x29, x30, [sp, #0x180]
    2ab0: a9574ff4     	ldp	x20, x19, [sp, #0x170]
    2ab4: 910643ff     	add	sp, sp, #0x190
    2ab8: d65f03c0     	ret

0000000000002abc <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2abc: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
    2ac0: a90167fa     	stp	x26, x25, [sp, #0x10]
    2ac4: a9025ff8     	stp	x24, x23, [sp, #0x20]
    2ac8: a90357f6     	stp	x22, x21, [sp, #0x30]
    2acc: a9044ff4     	stp	x20, x19, [sp, #0x40]
    2ad0: a9057bfd     	stp	x29, x30, [sp, #0x50]
    2ad4: 910143fd     	add	x29, sp, #0x50
    2ad8: d10f43ff     	sub	sp, sp, #0x3d0
    2adc: aa0203f4     	mov	x20, x2
    2ae0: aa0003f3     	mov	x19, x0
    2ae4: d2800008     	mov	x8, #0x0                ; =0
    2ae8: ad400420     	ldp	q0, q1, [x1]
    2aec: ad1387e0     	stp	q0, q1, [sp, #0x270]
    2af0: 3dc00820     	ldr	q0, [x1, #0x20]
    2af4: 6f00e401     	movi.2d	v1, #0000000000000000
    2af8: ad1487e0     	stp	q0, q1, [sp, #0x290]
    2afc: ad1587e1     	stp	q1, q1, [sp, #0x2b0]
    2b00: ad1687e1     	stp	q1, q1, [sp, #0x2d0]
    2b04: 910443f7     	add	x23, sp, #0x110
    2b08: 9109c3e9     	add	x9, sp, #0x270
    2b0c: 52800b8a     	mov	w10, #0x5c              ; =92
<L0>:
    2b10: 8b0802eb     	add	x11, x23, x8
    2b14: 3868692c     	ldrb	w12, [x9, x8]
    2b18: 4a0a018c     	eor	w12, w12, w10
    2b1c: 3903816c     	strb	w12, [x11, #0xe0]
    2b20: 91000508     	add	x8, x8, #0x1
    2b24: f102011f     	cmp	x8, #0x80
    2b28: 54ffff41     	b.ne	 <L0>
    2b2c: d2800008     	mov	x8, #0x0                ; =0
    2b30: 9109c3e9     	add	x9, sp, #0x270
    2b34: 528006ca     	mov	w10, #0x36              ; =54
    2b38: 910bc3eb     	add	x11, sp, #0x2f0
<L1>:
    2b3c: 3868692c     	ldrb	w12, [x9, x8]
    2b40: 4a0a018c     	eor	w12, w12, w10
    2b44: 3828696c     	strb	w12, [x11, x8]
    2b48: 91000508     	add	x8, x8, #0x1
    2b4c: f102011f     	cmp	x8, #0x80
    2b50: 54ffff61     	b.ne	 <L1>
    2b54: 90000008     	adrp	x8, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002b54:  ARM64_RELOC_PAGE21	___anon_817
    2b58: 91000108     	add	x8, x8, #0x0
		0000000000002b58:  ARM64_RELOC_PAGEOFF12	___anon_817
    2b5c: ad450500     	ldp	q0, q1, [x8, #0xa0]
    2b60: ad0603e1     	stp	q1, q0, [sp, #0xc0]
    2b64: ad0d87e0     	stp	q0, q1, [sp, #0x1b0]
    2b68: ad460500     	ldp	q0, q1, [x8, #0xc0]
    2b6c: ad0503e1     	stp	q1, q0, [sp, #0xa0]
    2b70: ad0e87e0     	stp	q0, q1, [sp, #0x1d0]
    2b74: ad430500     	ldp	q0, q1, [x8, #0x60]
    2b78: ad0403e1     	stp	q1, q0, [sp, #0x80]
    2b7c: ad0b87e0     	stp	q0, q1, [sp, #0x170]
    2b80: ad440500     	ldp	q0, q1, [x8, #0x80]
    2b84: ad0303e1     	stp	q1, q0, [sp, #0x60]
    2b88: ad0c87e0     	stp	q0, q1, [sp, #0x190]
    2b8c: ad410500     	ldp	q0, q1, [x8, #0x20]
    2b90: ad0203e1     	stp	q1, q0, [sp, #0x40]
    2b94: ad0987e0     	stp	q0, q1, [sp, #0x130]
    2b98: ad420500     	ldp	q0, q1, [x8, #0x40]
    2b9c: 3d800fe0     	str	q0, [sp, #0x30]
    2ba0: ad0a87e0     	stp	q0, q1, [sp, #0x150]
    2ba4: 3d8007e1     	str	q1, [sp, #0x10]
    2ba8: ad400500     	ldp	q0, q1, [x8]
    2bac: 3d800be0     	str	q0, [sp, #0x20]
    2bb0: ad0887e0     	stp	q0, q1, [sp, #0x110]
    2bb4: 3d8003e1     	str	q1, [sp]
    2bb8: 910443f9     	add	x25, sp, #0x110
    2bbc: 910bc3f8     	add	x24, sp, #0x2f0
    2bc0: 910443e0     	add	x0, sp, #0x110
    2bc4: 910bc3e1     	add	x1, sp, #0x2f0
<L2>:
    2bc8: 94000000     	bl	 <L2>
		0000000000002bc8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    2bcc: a95123e9     	ldp	x9, x8, [sp, #0x110]
    2bd0: b102013b     	adds	x27, x9, #0x80
    2bd4: 9a88351a     	cinc	x26, x8, hs
    2bd8: a9116bfb     	stp	x27, x26, [sp, #0x110]
    2bdc: 394783e8     	ldrb	w8, [sp, #0x1e0]
    2be0: 34000248     	cbz	w8,  <L5>
    2be4: 7101411f     	cmp	w8, #0x50
    2be8: 54000203     	b.lo	 <L5>
    2bec: 52801009     	mov	w9, #0x80               ; =128
    2bf0: cb080135     	sub	x21, x9, x8
    2bf4: 910443e9     	add	x9, sp, #0x110
    2bf8: 91014136     	add	x22, x9, #0x50
    2bfc: 8b0802c0     	add	x0, x22, x8
    2c00: aa1403e1     	mov	x1, x20
    2c04: aa1503e2     	mov	x2, x21
<L3>:
    2c08: 94000000     	bl	 <L3>
		0000000000002c08:  ARM64_RELOC_BRANCH26	_memcpy
    2c0c: 910443e0     	add	x0, sp, #0x110
    2c10: aa1603e1     	mov	x1, x22
<L4>:
    2c14: 94000000     	bl	 <L4>
		0000000000002c14:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    2c18: 52800008     	mov	w8, #0x0                ; =0
    2c1c: 390783ff     	strb	wzr, [sp, #0x1e0]
    2c20: a9516bfb     	ldp	x27, x26, [sp, #0x110]
    2c24: 14000002     	b	 <L6>
<L5>:
    2c28: d2800015     	mov	x21, #0x0               ; =0
<L6>:
    2c2c: 52800609     	mov	w9, #0x30               ; =48
    2c30: cb150136     	sub	x22, x9, x21
    2c34: 8b284328     	add	x8, x25, w8, uxtw
    2c38: 91014100     	add	x0, x8, #0x50
    2c3c: 8b150281     	add	x1, x20, x21
    2c40: aa1603e2     	mov	x2, x22
<L7>:
    2c44: 94000000     	bl	 <L7>
		0000000000002c44:  ARM64_RELOC_BRANCH26	_memcpy
    2c48: 394783e8     	ldrb	w8, [sp, #0x1e0]
    2c4c: 0b160108     	add	w8, w8, w22
    2c50: 390783e8     	strb	w8, [sp, #0x1e0]
    2c54: b100c368     	adds	x8, x27, #0x30
    2c58: 9a9a3749     	cinc	x9, x26, hs
    2c5c: a91127e8     	stp	x8, x9, [sp, #0x110]
    2c60: 9109c3f9     	add	x25, sp, #0x270
    2c64: 910443e0     	add	x0, sp, #0x110
    2c68: 9109c3e1     	add	x1, sp, #0x270
<L8>:
    2c6c: 94000000     	bl	 <L8>
		0000000000002c6c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    2c70: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    2c74: ad1c83e1     	stp	q1, q0, [sp, #0x390]
    2c78: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
    2c7c: ad1d83e1     	stp	q1, q0, [sp, #0x3b0]
    2c80: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    2c84: ad1a83e1     	stp	q1, q0, [sp, #0x350]
    2c88: ad4307e0     	ldp	q0, q1, [sp, #0x60]
    2c8c: ad1b83e1     	stp	q1, q0, [sp, #0x370]
    2c90: ad4207e0     	ldp	q0, q1, [sp, #0x40]
    2c94: ad1883e1     	stp	q1, q0, [sp, #0x310]
    2c98: 3dc00fe1     	ldr	q1, [sp, #0x30]
    2c9c: ad408fe2     	ldp	q2, q3, [sp, #0x10]
    2ca0: ad198be1     	stp	q1, q2, [sp, #0x330]
    2ca4: 91014314     	add	x20, x24, #0x50
    2ca8: 3dc003e0     	ldr	q0, [sp]
    2cac: ad1783e3     	stp	q3, q0, [sp, #0x2f0]
    2cb0: 910bc3e0     	add	x0, sp, #0x2f0
    2cb4: 910382e1     	add	x1, x23, #0xe0
<L9>:
    2cb8: 94000000     	bl	 <L9>
		0000000000002cb8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    2cbc: 394f03e8     	ldrb	w8, [sp, #0x3c0]
    2cc0: f9417fe9     	ldr	x9, [sp, #0x2f8]
    2cc4: f9417bea     	ldr	x10, [sp, #0x2f0]
    2cc8: b1020158     	adds	x24, x10, #0x80
    2ccc: 9a893537     	cinc	x23, x9, hs
    2cd0: f9017bf8     	str	x24, [sp, #0x2f0]
    2cd4: f9017ff7     	str	x23, [sp, #0x2f8]
    2cd8: 34000228     	cbz	w8,  <L12>
    2cdc: 7101411f     	cmp	w8, #0x50
    2ce0: 540001e3     	b.lo	 <L12>
    2ce4: 52801009     	mov	w9, #0x80               ; =128
    2ce8: cb080135     	sub	x21, x9, x8
    2cec: 8b080280     	add	x0, x20, x8
    2cf0: 9109c3e1     	add	x1, sp, #0x270
    2cf4: aa1503e2     	mov	x2, x21
<L10>:
    2cf8: 94000000     	bl	 <L10>
		0000000000002cf8:  ARM64_RELOC_BRANCH26	_memcpy
    2cfc: 910bc3e0     	add	x0, sp, #0x2f0
    2d00: aa1403e1     	mov	x1, x20
<L11>:
    2d04: 94000000     	bl	 <L11>
		0000000000002d04:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    2d08: 52800008     	mov	w8, #0x0                ; =0
    2d0c: 390f03ff     	strb	wzr, [sp, #0x3c0]
    2d10: f9417ff7     	ldr	x23, [sp, #0x2f8]
    2d14: f9417bf8     	ldr	x24, [sp, #0x2f0]
    2d18: 14000002     	b	 <L13>
<L12>:
    2d1c: d2800015     	mov	x21, #0x0               ; =0
<L13>:
    2d20: 52800609     	mov	w9, #0x30               ; =48
    2d24: cb150136     	sub	x22, x9, x21
    2d28: 8b284280     	add	x0, x20, w8, uxtw
    2d2c: 8b150321     	add	x1, x25, x21
    2d30: aa1603e2     	mov	x2, x22
<L14>:
    2d34: 94000000     	bl	 <L14>
		0000000000002d34:  ARM64_RELOC_BRANCH26	_memcpy
    2d38: 394f03e8     	ldrb	w8, [sp, #0x3c0]
    2d3c: 0b160108     	add	w8, w8, w22
    2d40: 390f03e8     	strb	w8, [sp, #0x3c0]
    2d44: b100c308     	adds	x8, x24, #0x30
    2d48: 9a9736e9     	cinc	x9, x23, hs
    2d4c: f9017fe9     	str	x9, [sp, #0x2f8]
    2d50: f9017be8     	str	x8, [sp, #0x2f0]
    2d54: 910bc3e0     	add	x0, sp, #0x2f0
    2d58: 910383e1     	add	x1, sp, #0xe0
<L15>:
    2d5c: 94000000     	bl	 <L15>
		0000000000002d5c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    2d60: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    2d64: ad000660     	stp	q0, q1, [x19]
    2d68: 3dc043e0     	ldr	q0, [sp, #0x100]
    2d6c: 3d800a60     	str	q0, [x19, #0x20]
    2d70: 910f43ff     	add	sp, sp, #0x3d0
    2d74: a9457bfd     	ldp	x29, x30, [sp, #0x50]
    2d78: a9444ff4     	ldp	x20, x19, [sp, #0x40]
    2d7c: a94357f6     	ldp	x22, x21, [sp, #0x30]
    2d80: a9425ff8     	ldp	x24, x23, [sp, #0x20]
    2d84: a94167fa     	ldp	x26, x25, [sp, #0x10]
    2d88: a8c66ffc     	ldp	x28, x27, [sp], #0x60
    2d8c: d65f03c0     	ret

0000000000002d90 <_audit_handshake384>:
    2d90: d10683ff     	sub	sp, sp, #0x1a0
    2d94: a9176ffc     	stp	x28, x27, [sp, #0x170]
    2d98: a9184ff4     	stp	x20, x19, [sp, #0x180]
    2d9c: a9197bfd     	stp	x29, x30, [sp, #0x190]
    2da0: 910643fd     	add	x29, sp, #0x190
    2da4: aa0203f3     	mov	x19, x2
    2da8: aa0103f4     	mov	x20, x1
    2dac: aa0003e4     	mov	x4, x0
    2db0: 90000008     	adrp	x8, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002db0:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    2db4: 91000108     	add	x8, x8, #0x0
		0000000000002db4:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    2db8: ad400500     	ldp	q0, q1, [x8]
    2dbc: 3c8713e0     	stur	q0, [sp, #0x71]
    2dc0: 52860009     	mov	w9, #0x3000             ; =12288
    2dc4: 7900c3e9     	strh	w9, [sp, #0x60]
    2dc8: 528001a9     	mov	w9, #0xd                ; =13
    2dcc: 39018be9     	strb	w9, [sp, #0x62]
    2dd0: 90000009     	adrp	x9, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002dd0:  ARM64_RELOC_PAGE21	___anon_2099
    2dd4: 91000129     	add	x9, x9, #0x0
		0000000000002dd4:  ARM64_RELOC_PAGEOFF12	___anon_2099
    2dd8: f940012a     	ldr	x10, [x9]
    2ddc: f80633ea     	stur	x10, [sp, #0x63]
    2de0: 910183ea     	add	x10, sp, #0x60
    2de4: f8405129     	ldur	x9, [x9, #0x5]
    2de8: f90037e9     	str	x9, [sp, #0x68]
    2dec: 52800609     	mov	w9, #0x30               ; =48
    2df0: 3901c3e9     	strb	w9, [sp, #0x70]
    2df4: 3c821141     	stur	q1, [x10, #0x21]
    2df8: 3dc00900     	ldr	q0, [x8, #0x20]
    2dfc: 3c831140     	stur	q0, [x10, #0x31]
    2e00: 9100c3e0     	add	x0, sp, #0x30
    2e04: 910183e2     	add	x2, sp, #0x60
    2e08: 52800601     	mov	w1, #0x30               ; =48
    2e0c: 52800823     	mov	w3, #0x41               ; =65
<L0>:
    2e10: 94000000     	bl	 <L0>
		0000000000002e10:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
    2e14: 910003e0     	mov	x0, sp
    2e18: 9100c3e1     	add	x1, sp, #0x30
    2e1c: aa1403e2     	mov	x2, x20
<L1>:
    2e20: 94000000     	bl	 <L1>
		0000000000002e20:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
    2e24: ad4007e0     	ldp	q0, q1, [sp]
    2e28: ad000660     	stp	q0, q1, [x19]
    2e2c: 3dc00be0     	ldr	q0, [sp, #0x20]
    2e30: 3d800a60     	str	q0, [x19, #0x20]
    2e34: a9597bfd     	ldp	x29, x30, [sp, #0x190]
    2e38: a9584ff4     	ldp	x20, x19, [sp, #0x180]
    2e3c: a9576ffc     	ldp	x28, x27, [sp, #0x170]
    2e40: 910683ff     	add	sp, sp, #0x1a0
    2e44: d65f03c0     	ret

0000000000002e48 <_audit_key256>:
    2e48: d10543ff     	sub	sp, sp, #0x150
    2e4c: a9136ffc     	stp	x28, x27, [sp, #0x130]
    2e50: a9147bfd     	stp	x29, x30, [sp, #0x140]
    2e54: 910503fd     	add	x29, sp, #0x140
    2e58: d100c3a8     	sub	x8, x29, #0x30
    2e5c: ad400400     	ldp	q0, q1, [x0]
    2e60: ad000500     	stp	q0, q1, [x8]
    2e64: 52820008     	mov	w8, #0x1000             ; =4096
    2e68: 79000be8     	strh	w8, [sp, #0x4]
    2e6c: 52800128     	mov	w8, #0x9                ; =9
    2e70: 39001be8     	strb	w8, [sp, #0x6]
    2e74: 90000008     	adrp	x8, 0x2000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1720>
		0000000000002e74:  ARM64_RELOC_PAGE21	___anon_718
    2e78: 91000108     	add	x8, x8, #0x0
		0000000000002e78:  ARM64_RELOC_PAGEOFF12	___anon_718
    2e7c: f9400108     	ldr	x8, [x8]
    2e80: f80073e8     	stur	x8, [sp, #0x7]
    2e84: 52800f28     	mov	w8, #0x79               ; =121
    2e88: 7800f3e8     	sturh	w8, [sp, #0xf]
    2e8c: 910013e2     	add	x2, sp, #0x4
    2e90: d100c3a4     	sub	x4, x29, #0x30
    2e94: aa0103e0     	mov	x0, x1
    2e98: 52800201     	mov	w1, #0x10               ; =16
    2e9c: 528001a3     	mov	w3, #0xd                ; =13
<L0>:
    2ea0: 94000000     	bl	 <L0>
		0000000000002ea0:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
    2ea4: a9547bfd     	ldp	x29, x30, [sp, #0x140]
    2ea8: a9536ffc     	ldp	x28, x27, [sp, #0x130]
    2eac: 910543ff     	add	sp, sp, #0x150
    2eb0: d65f03c0     	ret

0000000000002eb4 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
    2eb4: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
    2eb8: a90167fa     	stp	x26, x25, [sp, #0x10]
    2ebc: a9025ff8     	stp	x24, x23, [sp, #0x20]
    2ec0: a90357f6     	stp	x22, x21, [sp, #0x30]
    2ec4: a9044ff4     	stp	x20, x19, [sp, #0x40]
    2ec8: a9057bfd     	stp	x29, x30, [sp, #0x50]
    2ecc: 910143fd     	add	x29, sp, #0x50
    2ed0: d10903ff     	sub	sp, sp, #0x240
    2ed4: aa0303f5     	mov	x21, x3
    2ed8: aa0203f6     	mov	x22, x2
    2edc: aa0003f3     	mov	x19, x0
    2ee0: ad400480     	ldp	q0, q1, [x4]
    2ee4: ad0007e0     	stp	q0, q1, [sp]
    2ee8: 52800028     	mov	w8, #0x1                ; =1
    2eec: 3900bfe8     	strb	w8, [sp, #0x2f]
    2ef0: f100803f     	cmp	x1, #0x20
    2ef4: 54000322     	b.hs	 <L3>
    2ef8: aa0103f4     	mov	x20, x1
    2efc: 910383fa     	add	x26, sp, #0xe0
    2f00: 910383e0     	add	x0, sp, #0xe0
    2f04: 910003e1     	mov	x1, sp
<L0>:
    2f08: 94000000     	bl	 <L0>
		0000000000002f08:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
    2f0c: 394523e8     	ldrb	w8, [sp, #0x148]
    2f10: 34000508     	cbz	w8,  <L7>
    2f14: 8b0802a9     	add	x9, x21, x8
    2f18: f101013f     	cmp	x9, #0x40
    2f1c: 540004a3     	b.lo	 <L7>
    2f20: 52800809     	mov	w9, #0x40               ; =64
    2f24: cb080138     	sub	x24, x9, x8
    2f28: 910383e9     	add	x9, sp, #0xe0
    2f2c: 9100a137     	add	x23, x9, #0x28
    2f30: 8b0802e0     	add	x0, x23, x8
    2f34: aa1603e1     	mov	x1, x22
    2f38: aa1803e2     	mov	x2, x24
<L1>:
    2f3c: 94000000     	bl	 <L1>
		0000000000002f3c:  ARM64_RELOC_BRANCH26	_memcpy
    2f40: 910383e0     	add	x0, sp, #0xe0
    2f44: aa1703e1     	mov	x1, x23
<L2>:
    2f48: 94000000     	bl	 <L2>
		0000000000002f48:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    2f4c: 52800008     	mov	w8, #0x0                ; =0
    2f50: 390523ff     	strb	wzr, [sp, #0x148]
    2f54: 14000018     	b	 <L8>
<L3>:
    2f58: 9100c3f9     	add	x25, sp, #0x30
    2f5c: 9100a334     	add	x20, x25, #0x28
    2f60: 9100c3e0     	add	x0, sp, #0x30
    2f64: 910003e1     	mov	x1, sp
<L4>:
    2f68: 94000000     	bl	 <L4>
		0000000000002f68:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
    2f6c: 394263e8     	ldrb	w8, [sp, #0x98]
    2f70: 340005a8     	cbz	w8,  <L13>
    2f74: d24016a9     	eor	x9, x21, #0x3f
    2f78: eb08013f     	cmp	x9, x8
    2f7c: 54000542     	b.hs	 <L13>
    2f80: 52800809     	mov	w9, #0x40               ; =64
    2f84: cb080137     	sub	x23, x9, x8
    2f88: 8b080280     	add	x0, x20, x8
    2f8c: aa1603e1     	mov	x1, x22
    2f90: aa1703e2     	mov	x2, x23
<L5>:
    2f94: 94000000     	bl	 <L5>
		0000000000002f94:  ARM64_RELOC_BRANCH26	_memcpy
    2f98: 9100c3e0     	add	x0, sp, #0x30
    2f9c: aa1403e1     	mov	x1, x20
<L6>:
    2fa0: 94000000     	bl	 <L6>
		0000000000002fa0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    2fa4: 52800008     	mov	w8, #0x0                ; =0
    2fa8: 390263ff     	strb	wzr, [sp, #0x98]
    2fac: 1400001f     	b	 <L14>
<L7>:
    2fb0: d2800018     	mov	x24, #0x0               ; =0
<L8>:
    2fb4: cb1802b9     	sub	x25, x21, x24
    2fb8: 9100a357     	add	x23, x26, #0x28
    2fbc: 8b2842e0     	add	x0, x23, w8, uxtw
    2fc0: 8b1802c1     	add	x1, x22, x24
    2fc4: aa1903e2     	mov	x2, x25
<L9>:
    2fc8: 94000000     	bl	 <L9>
		0000000000002fc8:  ARM64_RELOC_BRANCH26	_memcpy
    2fcc: 394523e8     	ldrb	w8, [sp, #0x148]
    2fd0: f94083e9     	ldr	x9, [sp, #0x100]
    2fd4: 8b150138     	add	x24, x9, x21
    2fd8: f90083f8     	str	x24, [sp, #0x100]
    2fdc: 2b190108     	adds	w8, w8, w25
    2fe0: 390523e8     	strb	w8, [sp, #0x148]
    2fe4: 540005a0     	b.eq	 <L18>
    2fe8: 7100fd1f     	cmp	w8, #0x3f
    2fec: 54000563     	b.lo	 <L18>
    2ff0: 52800809     	mov	w9, #0x40               ; =64
    2ff4: 4b080135     	sub	w21, w9, w8
    2ff8: 8b2842e0     	add	x0, x23, w8, uxtw
    2ffc: 9100bfe1     	add	x1, sp, #0x2f
<L10>:
    3000: aa1503e2     	mov	x2, x21
<L11>:
    3004: 94000000     	bl	 <L11>
		0000000000003004:  ARM64_RELOC_BRANCH26	_memcpy
    3008: 910383e0     	add	x0, sp, #0xe0
    300c: aa1703e1     	mov	x1, x23
<L12>:
    3010: 94000000     	bl	 <L12>
		0000000000003010:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3014: 52800008     	mov	w8, #0x0                ; =0
    3018: 390523ff     	strb	wzr, [sp, #0x148]
    301c: f94083f8     	ldr	x24, [sp, #0x100]
    3020: 1400001f     	b	 <L19>
<L13>:
    3024: d2800017     	mov	x23, #0x0               ; =0
<L14>:
    3028: d10303ba     	sub	x26, x29, #0xc0
    302c: cb1702b8     	sub	x24, x21, x23
    3030: 8b284280     	add	x0, x20, w8, uxtw
    3034: 8b1702c1     	add	x1, x22, x23
    3038: aa1803e2     	mov	x2, x24
<L15>:
    303c: 94000000     	bl	 <L15>
		000000000000303c:  ARM64_RELOC_BRANCH26	_memcpy
    3040: 394263e8     	ldrb	w8, [sp, #0x98]
    3044: f9402be9     	ldr	x9, [sp, #0x50]
    3048: 8b15013b     	add	x27, x9, x21
    304c: f9002bfb     	str	x27, [sp, #0x50]
    3050: 2b180108     	adds	w8, w8, w24
    3054: 390263e8     	strb	w8, [sp, #0x98]
    3058: 540008a0     	b.eq	 <L25>
    305c: 7100fd1f     	cmp	w8, #0x3f
    3060: 54000863     	b.lo	 <L25>
    3064: 52800809     	mov	w9, #0x40               ; =64
    3068: 4b080136     	sub	w22, w9, w8
    306c: 8b284280     	add	x0, x20, w8, uxtw
    3070: 9100bfe1     	add	x1, sp, #0x2f
    3074: aa1603e2     	mov	x2, x22
<L16>:
    3078: 94000000     	bl	 <L16>
		0000000000003078:  ARM64_RELOC_BRANCH26	_memcpy
    307c: 9100c3e0     	add	x0, sp, #0x30
    3080: aa1403e1     	mov	x1, x20
<L17>:
    3084: 94000000     	bl	 <L17>
		0000000000003084:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3088: 52800008     	mov	w8, #0x0                ; =0
    308c: 390263ff     	strb	wzr, [sp, #0x98]
    3090: f9402bfb     	ldr	x27, [sp, #0x50]
    3094: 14000037     	b	 <L26>
<L18>:
    3098: d2800015     	mov	x21, #0x0               ; =0
<L19>:
    309c: 9100bfe9     	add	x9, sp, #0x2f
    30a0: 5280002a     	mov	w10, #0x1               ; =1
    30a4: cb150156     	sub	x22, x10, x21
    30a8: 8b2842e0     	add	x0, x23, w8, uxtw
    30ac: 8b150121     	add	x1, x9, x21
    30b0: aa1603e2     	mov	x2, x22
<L20>:
    30b4: 94000000     	bl	 <L20>
		00000000000030b4:  ARM64_RELOC_BRANCH26	_memcpy
    30b8: 394523e8     	ldrb	w8, [sp, #0x148]
    30bc: 0b160108     	add	w8, w8, w22
    30c0: 390523e8     	strb	w8, [sp, #0x148]
    30c4: 91000708     	add	x8, x24, #0x1
    30c8: f90083e8     	str	x8, [sp, #0x100]
    30cc: 910383f5     	add	x21, sp, #0xe0
    30d0: d10383b8     	sub	x24, x29, #0xe0
    30d4: 910383e0     	add	x0, sp, #0xe0
    30d8: d10383a1     	sub	x1, x29, #0xe0
<L21>:
    30dc: 94000000     	bl	 <L21>
		00000000000030dc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
    30e0: 90000008     	adrp	x8, 0x3000 <L10>
		00000000000030e0:  ARM64_RELOC_PAGE21	___anon_7680
    30e4: 91000108     	add	x8, x8, #0x0
		00000000000030e4:  ARM64_RELOC_PAGEOFF12	___anon_7680
    30e8: ad420500     	ldp	q0, q1, [x8, #0x40]
    30ec: ad3c07a0     	stp	q0, q1, [x29, #-0x80]
    30f0: 3dc01900     	ldr	q0, [x8, #0x60]
    30f4: 3c9a03a0     	stur	q0, [x29, #-0x60]
    30f8: ad400500     	ldp	q0, q1, [x8]
    30fc: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
    3100: ad410101     	ldp	q1, q0, [x8, #0x20]
    3104: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
    3108: d10303b6     	sub	x22, x29, #0xc0
    310c: d10303a0     	sub	x0, x29, #0xc0
    3110: 9101c2a1     	add	x1, x21, #0x70
<L22>:
    3114: 94000000     	bl	 <L22>
		0000000000003114:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3118: 385a83a8     	ldurb	w8, [x29, #-0x58]
    311c: f85603a9     	ldur	x9, [x29, #-0xa0]
    3120: 9100a2d5     	add	x21, x22, #0x28
    3124: 91010139     	add	x25, x9, #0x40
    3128: f81603b9     	stur	x25, [x29, #-0xa0]
    312c: 34000868     	cbz	w8,  <L32>
    3130: 7100811f     	cmp	w8, #0x20
    3134: 54000823     	b.lo	 <L32>
    3138: 52800809     	mov	w9, #0x40               ; =64
    313c: cb080136     	sub	x22, x9, x8
    3140: 8b0802a0     	add	x0, x21, x8
    3144: d10383a1     	sub	x1, x29, #0xe0
    3148: aa1603e2     	mov	x2, x22
<L23>:
    314c: 94000000     	bl	 <L23>
		000000000000314c:  ARM64_RELOC_BRANCH26	_memcpy
    3150: d10303a0     	sub	x0, x29, #0xc0
    3154: aa1503e1     	mov	x1, x21
<L24>:
    3158: 94000000     	bl	 <L24>
		0000000000003158:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    315c: 52800008     	mov	w8, #0x0                ; =0
    3160: 381a83bf     	sturb	wzr, [x29, #-0x58]
    3164: f85603b9     	ldur	x25, [x29, #-0xa0]
    3168: 14000035     	b	 <L33>
<L25>:
    316c: d2800016     	mov	x22, #0x0               ; =0
<L26>:
    3170: 9100a355     	add	x21, x26, #0x28
    3174: 9100bfe9     	add	x9, sp, #0x2f
    3178: 5280002a     	mov	w10, #0x1               ; =1
    317c: cb160157     	sub	x23, x10, x22
    3180: 8b284280     	add	x0, x20, w8, uxtw
    3184: 8b160121     	add	x1, x9, x22
    3188: aa1703e2     	mov	x2, x23
<L27>:
    318c: 94000000     	bl	 <L27>
		000000000000318c:  ARM64_RELOC_BRANCH26	_memcpy
    3190: 394263e8     	ldrb	w8, [sp, #0x98]
    3194: 0b170108     	add	w8, w8, w23
    3198: 390263e8     	strb	w8, [sp, #0x98]
    319c: 91000768     	add	x8, x27, #0x1
    31a0: f9002be8     	str	x8, [sp, #0x50]
    31a4: d10383b7     	sub	x23, x29, #0xe0
    31a8: 9100c3e0     	add	x0, sp, #0x30
    31ac: d10383a1     	sub	x1, x29, #0xe0
<L28>:
    31b0: 94000000     	bl	 <L28>
		00000000000031b0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
    31b4: 90000008     	adrp	x8, 0x3000 <L10>
		00000000000031b4:  ARM64_RELOC_PAGE21	___anon_7680
    31b8: 91000108     	add	x8, x8, #0x0
		00000000000031b8:  ARM64_RELOC_PAGEOFF12	___anon_7680
    31bc: ad420500     	ldp	q0, q1, [x8, #0x40]
    31c0: ad3c07a0     	stp	q0, q1, [x29, #-0x80]
    31c4: 3dc01900     	ldr	q0, [x8, #0x60]
    31c8: 3c9a03a0     	stur	q0, [x29, #-0x60]
    31cc: ad400500     	ldp	q0, q1, [x8]
    31d0: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
    31d4: ad410101     	ldp	q1, q0, [x8, #0x20]
    31d8: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
    31dc: d10303a0     	sub	x0, x29, #0xc0
    31e0: 9101c321     	add	x1, x25, #0x70
<L29>:
    31e4: 94000000     	bl	 <L29>
		00000000000031e4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    31e8: 385a83a8     	ldurb	w8, [x29, #-0x58]
    31ec: f85603a9     	ldur	x9, [x29, #-0xa0]
    31f0: 91010138     	add	x24, x9, #0x40
    31f4: f81603b8     	stur	x24, [x29, #-0xa0]
    31f8: 34000488     	cbz	w8,  <L37>
    31fc: 7100811f     	cmp	w8, #0x20
    3200: 54000443     	b.lo	 <L37>
    3204: 52800809     	mov	w9, #0x40               ; =64
    3208: cb080134     	sub	x20, x9, x8
    320c: 8b0802a0     	add	x0, x21, x8
    3210: d10383a1     	sub	x1, x29, #0xe0
    3214: aa1403e2     	mov	x2, x20
<L30>:
    3218: 94000000     	bl	 <L30>
		0000000000003218:  ARM64_RELOC_BRANCH26	_memcpy
    321c: d10303a0     	sub	x0, x29, #0xc0
    3220: aa1503e1     	mov	x1, x21
<L31>:
    3224: 94000000     	bl	 <L31>
		0000000000003224:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3228: 52800008     	mov	w8, #0x0                ; =0
    322c: 381a83bf     	sturb	wzr, [x29, #-0x58]
    3230: f85603b8     	ldur	x24, [x29, #-0xa0]
    3234: 14000016     	b	 <L38>
<L32>:
    3238: d2800016     	mov	x22, #0x0               ; =0
<L33>:
    323c: 52800409     	mov	w9, #0x20               ; =32
    3240: cb160137     	sub	x23, x9, x22
    3244: 8b2842a0     	add	x0, x21, w8, uxtw
    3248: 8b160301     	add	x1, x24, x22
    324c: aa1703e2     	mov	x2, x23
<L34>:
    3250: 94000000     	bl	 <L34>
		0000000000003250:  ARM64_RELOC_BRANCH26	_memcpy
    3254: 385a83a8     	ldurb	w8, [x29, #-0x58]
    3258: 0b170108     	add	w8, w8, w23
    325c: 381a83a8     	sturb	w8, [x29, #-0x58]
    3260: 91008328     	add	x8, x25, #0x20
    3264: f81603a8     	stur	x8, [x29, #-0xa0]
    3268: d10303a0     	sub	x0, x29, #0xc0
    326c: d10403a1     	sub	x1, x29, #0x100
<L35>:
    3270: 94000000     	bl	 <L35>
		0000000000003270:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
    3274: d10403a1     	sub	x1, x29, #0x100
    3278: aa1303e0     	mov	x0, x19
    327c: aa1403e2     	mov	x2, x20
<L36>:
    3280: 94000000     	bl	 <L36>
		0000000000003280:  ARM64_RELOC_BRANCH26	_memcpy
    3284: 14000010     	b	 <L41>
<L37>:
    3288: d2800014     	mov	x20, #0x0               ; =0
<L38>:
    328c: 52800409     	mov	w9, #0x20               ; =32
    3290: cb140136     	sub	x22, x9, x20
    3294: 8b2842a0     	add	x0, x21, w8, uxtw
    3298: 8b1402e1     	add	x1, x23, x20
    329c: aa1603e2     	mov	x2, x22
<L39>:
    32a0: 94000000     	bl	 <L39>
		00000000000032a0:  ARM64_RELOC_BRANCH26	_memcpy
    32a4: 385a83a8     	ldurb	w8, [x29, #-0x58]
    32a8: 0b160108     	add	w8, w8, w22
    32ac: 381a83a8     	sturb	w8, [x29, #-0x58]
    32b0: 91008308     	add	x8, x24, #0x20
    32b4: f81603a8     	stur	x8, [x29, #-0xa0]
    32b8: d10303a0     	sub	x0, x29, #0xc0
    32bc: aa1303e1     	mov	x1, x19
<L40>:
    32c0: 94000000     	bl	 <L40>
		00000000000032c0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L41>:
    32c4: 910903ff     	add	sp, sp, #0x240
    32c8: a9457bfd     	ldp	x29, x30, [sp, #0x50]
    32cc: a9444ff4     	ldp	x20, x19, [sp, #0x40]
    32d0: a94357f6     	ldp	x22, x21, [sp, #0x30]
    32d4: a9425ff8     	ldp	x24, x23, [sp, #0x20]
    32d8: a94167fa     	ldp	x26, x25, [sp, #0x10]
    32dc: a8c66ffc     	ldp	x28, x27, [sp], #0x60
    32e0: d65f03c0     	ret

00000000000032e4 <_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>:
    32e4: d10443ff     	sub	sp, sp, #0x110
    32e8: a90f4ff4     	stp	x20, x19, [sp, #0xf0]
    32ec: a9107bfd     	stp	x29, x30, [sp, #0x100]
    32f0: 910403fd     	add	x29, sp, #0x100
    32f4: aa0003f3     	mov	x19, x0
    32f8: 4f02e780     	movi.16b	v0, #0x5c
    32fc: ad400821     	ldp	q1, q2, [x1]
    3300: 6e201c23     	eor.16b	v3, v1, v0
    3304: 6e201c44     	eor.16b	v4, v2, v0
    3308: ad0403e4     	stp	q4, q0, [sp, #0x80]
    330c: 3d802be0     	str	q0, [sp, #0xa0]
    3310: 4f01e6c0     	movi.16b	v0, #0x36
    3314: 6e201c21     	eor.16b	v1, v1, v0
    3318: 6e201c42     	eor.16b	v2, v2, v0
    331c: ad3d8ba1     	stp	q1, q2, [x29, #-0x50]
    3320: ad3e83a0     	stp	q0, q0, [x29, #-0x30]
    3324: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003324:  ARM64_RELOC_PAGE21	___anon_7680
    3328: 91000108     	add	x8, x8, #0x0
		0000000000003328:  ARM64_RELOC_PAGEOFF12	___anon_7680
    332c: ad420500     	ldp	q0, q1, [x8, #0x40]
    3330: ad0207e0     	stp	q0, q1, [sp, #0x40]
    3334: 3dc01900     	ldr	q0, [x8, #0x60]
    3338: ad030fe0     	stp	q0, q3, [sp, #0x60]
    333c: ad400500     	ldp	q0, q1, [x8]
    3340: ad0007e0     	stp	q0, q1, [sp]
    3344: ad410101     	ldp	q1, q0, [x8, #0x20]
    3348: ad0103e1     	stp	q1, q0, [sp, #0x20]
    334c: 910003e0     	mov	x0, sp
    3350: d10143a1     	sub	x1, x29, #0x50
<L0>:
    3354: 94000000     	bl	 <L0>
		0000000000003354:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3358: f94013e8     	ldr	x8, [sp, #0x20]
    335c: 91010108     	add	x8, x8, #0x40
    3360: f90013e8     	str	x8, [sp, #0x20]
    3364: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    3368: ad040660     	stp	q0, q1, [x19, #0x80]
    336c: 3dc02be0     	ldr	q0, [sp, #0xa0]
    3370: 3d802a60     	str	q0, [x19, #0xa0]
    3374: ad4207e0     	ldp	q0, q1, [sp, #0x40]
    3378: ad020660     	stp	q0, q1, [x19, #0x40]
    337c: ad4303e1     	ldp	q1, q0, [sp, #0x60]
    3380: ad030261     	stp	q1, q0, [x19, #0x60]
    3384: ad4007e0     	ldp	q0, q1, [sp]
    3388: ad000660     	stp	q0, q1, [x19]
    338c: ad4103e1     	ldp	q1, q0, [sp, #0x20]
    3390: ad010261     	stp	q1, q0, [x19, #0x20]
    3394: a9507bfd     	ldp	x29, x30, [sp, #0x100]
    3398: a94f4ff4     	ldp	x20, x19, [sp, #0xf0]
    339c: 910443ff     	add	sp, sp, #0x110
    33a0: d65f03c0     	ret

00000000000033a4 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
    33a4: a9bd57f6     	stp	x22, x21, [sp, #-0x30]!
    33a8: a9014ff4     	stp	x20, x19, [sp, #0x10]
    33ac: a9027bfd     	stp	x29, x30, [sp, #0x20]
    33b0: 910083fd     	add	x29, sp, #0x20
    33b4: aa0103f3     	mov	x19, x1
    33b8: aa0003f4     	mov	x20, x0
    33bc: 9100a015     	add	x21, x0, #0x28
    33c0: 3941a008     	ldrb	w8, [x0, #0x68]
    33c4: 52800809     	mov	w9, #0x40               ; =64
    33c8: cb080121     	sub	x1, x9, x8
    33cc: 8b0802a0     	add	x0, x21, x8
<L0>:
    33d0: 94000000     	bl	 <L0>
		00000000000033d0:  ARM64_RELOC_BRANCH26	_bzero
    33d4: 3941a288     	ldrb	w8, [x20, #0x68]
    33d8: 52801009     	mov	w9, #0x80               ; =128
    33dc: 38286aa9     	strb	w9, [x21, x8]
    33e0: 3941a288     	ldrb	w8, [x20, #0x68]
    33e4: 11000509     	add	w9, w8, #0x1
    33e8: 3901a289     	strb	w9, [x20, #0x68]
    33ec: 7100dd1f     	cmp	w8, #0x37
    33f0: 54000109     	b.ls	 <L2>
    33f4: aa1403e0     	mov	x0, x20
    33f8: aa1503e1     	mov	x1, x21
<L1>:
    33fc: 94000000     	bl	 <L1>
		00000000000033fc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3400: f9001abf     	str	xzr, [x21, #0x30]
    3404: 6f00e400     	movi.2d	v0, #0000000000000000
    3408: ad0082a0     	stp	q0, q0, [x21, #0x10]
    340c: 3d8002a0     	str	q0, [x21]
<L2>:
    3410: f9401288     	ldr	x8, [x20, #0x20]
    3414: 531d7109     	lsl	w9, w8, #3
    3418: 39019e89     	strb	w9, [x20, #0x67]
    341c: d345fd09     	lsr	x9, x8, #5
    3420: 39019a89     	strb	w9, [x20, #0x66]
    3424: d34dfd09     	lsr	x9, x8, #13
    3428: 39019689     	strb	w9, [x20, #0x65]
    342c: d355fd09     	lsr	x9, x8, #21
    3430: 39019289     	strb	w9, [x20, #0x64]
    3434: d35dfd09     	lsr	x9, x8, #29
    3438: 39018e89     	strb	w9, [x20, #0x63]
    343c: d365fd09     	lsr	x9, x8, #37
    3440: 39018a89     	strb	w9, [x20, #0x62]
    3444: d36dfd09     	lsr	x9, x8, #45
    3448: 39018689     	strb	w9, [x20, #0x61]
    344c: d375fd08     	lsr	x8, x8, #53
    3450: 39018288     	strb	w8, [x20, #0x60]
    3454: aa1403e0     	mov	x0, x20
    3458: aa1503e1     	mov	x1, x21
<L3>:
    345c: 94000000     	bl	 <L3>
		000000000000345c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3460: b9400288     	ldr	w8, [x20]
    3464: 5ac00908     	rev	w8, w8
    3468: b9000268     	str	w8, [x19]
    346c: b9400688     	ldr	w8, [x20, #0x4]
    3470: 5ac00908     	rev	w8, w8
    3474: b9000668     	str	w8, [x19, #0x4]
    3478: b9400a88     	ldr	w8, [x20, #0x8]
    347c: 5ac00908     	rev	w8, w8
    3480: b9000a68     	str	w8, [x19, #0x8]
    3484: b9400e88     	ldr	w8, [x20, #0xc]
    3488: 5ac00908     	rev	w8, w8
    348c: b9000e68     	str	w8, [x19, #0xc]
    3490: b9401288     	ldr	w8, [x20, #0x10]
    3494: 5ac00908     	rev	w8, w8
    3498: b9001268     	str	w8, [x19, #0x10]
    349c: b9401688     	ldr	w8, [x20, #0x14]
    34a0: 5ac00908     	rev	w8, w8
    34a4: b9001668     	str	w8, [x19, #0x14]
    34a8: b9401a88     	ldr	w8, [x20, #0x18]
    34ac: 5ac00908     	rev	w8, w8
    34b0: b9001a68     	str	w8, [x19, #0x18]
    34b4: b9401e88     	ldr	w8, [x20, #0x1c]
    34b8: 5ac00908     	rev	w8, w8
    34bc: b9001e68     	str	w8, [x19, #0x1c]
    34c0: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    34c4: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    34c8: a8c357f6     	ldp	x22, x21, [sp], #0x30
    34cc: d65f03c0     	ret

00000000000034d0 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
    34d0: a9bf7bfd     	stp	x29, x30, [sp, #-0x10]!
    34d4: 910003fd     	mov	x29, sp
    34d8: ad400420     	ldp	q0, q1, [x1]
    34dc: 6e200803     	rev32.16b	v3, v0
    34e0: 6e200824     	rev32.16b	v4, v1
    34e4: ad410420     	ldp	q0, q1, [x1, #0x20]
    34e8: 6e200806     	rev32.16b	v6, v0
    34ec: 6e200825     	rev32.16b	v5, v1
    34f0: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		00000000000034f0:  ARM64_RELOC_PAGE21	lCPI11_0
    34f4: 3dc00100     	ldr	q0, [x8]
		00000000000034f4:  ARM64_RELOC_PAGEOFF12	lCPI11_0
    34f8: 4ea08467     	add.4s	v7, v3, v0
    34fc: ad400402     	ldp	q2, q1, [x0]
    3500: 4ea21c40     	mov.16b	v0, v2
    3504: 5e074022     	sha256h.4s	q2, q1, v7
    3508: 5e075001     	sha256h2.4s	q1, q0, v7
    350c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000350c:  ARM64_RELOC_PAGE21	lCPI11_1
    3510: 3dc00100     	ldr	q0, [x8]
		0000000000003510:  ARM64_RELOC_PAGEOFF12	lCPI11_1
    3514: 4ea08487     	add.4s	v7, v4, v0
    3518: 4ea21c40     	mov.16b	v0, v2
    351c: 5e074022     	sha256h.4s	q2, q1, v7
    3520: 5e075001     	sha256h2.4s	q1, q0, v7
    3524: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003524:  ARM64_RELOC_PAGE21	lCPI11_2
    3528: 3dc00100     	ldr	q0, [x8]
		0000000000003528:  ARM64_RELOC_PAGEOFF12	lCPI11_2
    352c: 4ea084c7     	add.4s	v7, v6, v0
    3530: 4ea21c40     	mov.16b	v0, v2
    3534: 5e074022     	sha256h.4s	q2, q1, v7
    3538: 5e075001     	sha256h2.4s	q1, q0, v7
    353c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000353c:  ARM64_RELOC_PAGE21	lCPI11_3
    3540: 3dc00100     	ldr	q0, [x8]
		0000000000003540:  ARM64_RELOC_PAGEOFF12	lCPI11_3
    3544: 4ea084a7     	add.4s	v7, v5, v0
    3548: 4ea21c40     	mov.16b	v0, v2
    354c: 5e074022     	sha256h.4s	q2, q1, v7
    3550: 5e075001     	sha256h2.4s	q1, q0, v7
    3554: 5e282883     	sha256su0.4s	v3, v4
    3558: 5e0560c3     	sha256su1.4s	v3, v6, v5
    355c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000355c:  ARM64_RELOC_PAGE21	lCPI11_4
    3560: 3dc00100     	ldr	q0, [x8]
		0000000000003560:  ARM64_RELOC_PAGEOFF12	lCPI11_4
    3564: 4ea08467     	add.4s	v7, v3, v0
    3568: 4ea21c40     	mov.16b	v0, v2
    356c: 5e074022     	sha256h.4s	q2, q1, v7
    3570: 5e075001     	sha256h2.4s	q1, q0, v7
    3574: 5e2828c4     	sha256su0.4s	v4, v6
    3578: 5e0360a4     	sha256su1.4s	v4, v5, v3
    357c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000357c:  ARM64_RELOC_PAGE21	lCPI11_5
    3580: 3dc00100     	ldr	q0, [x8]
		0000000000003580:  ARM64_RELOC_PAGEOFF12	lCPI11_5
    3584: 4ea08487     	add.4s	v7, v4, v0
    3588: 4ea21c40     	mov.16b	v0, v2
    358c: 5e074022     	sha256h.4s	q2, q1, v7
    3590: 5e075001     	sha256h2.4s	q1, q0, v7
    3594: 5e2828a6     	sha256su0.4s	v6, v5
    3598: 5e046066     	sha256su1.4s	v6, v3, v4
    359c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000359c:  ARM64_RELOC_PAGE21	lCPI11_6
    35a0: 3dc00100     	ldr	q0, [x8]
		00000000000035a0:  ARM64_RELOC_PAGEOFF12	lCPI11_6
    35a4: 4ea084c7     	add.4s	v7, v6, v0
    35a8: 4ea21c40     	mov.16b	v0, v2
    35ac: 5e074022     	sha256h.4s	q2, q1, v7
    35b0: 5e075001     	sha256h2.4s	q1, q0, v7
    35b4: 5e282865     	sha256su0.4s	v5, v3
    35b8: 5e066085     	sha256su1.4s	v5, v4, v6
    35bc: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		00000000000035bc:  ARM64_RELOC_PAGE21	lCPI11_7
    35c0: 3dc00100     	ldr	q0, [x8]
		00000000000035c0:  ARM64_RELOC_PAGEOFF12	lCPI11_7
    35c4: 4ea084a7     	add.4s	v7, v5, v0
    35c8: 4ea21c40     	mov.16b	v0, v2
    35cc: 5e074022     	sha256h.4s	q2, q1, v7
    35d0: 5e075001     	sha256h2.4s	q1, q0, v7
    35d4: 5e282883     	sha256su0.4s	v3, v4
    35d8: 5e0560c3     	sha256su1.4s	v3, v6, v5
    35dc: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		00000000000035dc:  ARM64_RELOC_PAGE21	lCPI11_8
    35e0: 3dc00100     	ldr	q0, [x8]
		00000000000035e0:  ARM64_RELOC_PAGEOFF12	lCPI11_8
    35e4: 4ea08467     	add.4s	v7, v3, v0
    35e8: 4ea21c40     	mov.16b	v0, v2
    35ec: 5e074022     	sha256h.4s	q2, q1, v7
    35f0: 5e075001     	sha256h2.4s	q1, q0, v7
    35f4: 5e2828c4     	sha256su0.4s	v4, v6
    35f8: 5e0360a4     	sha256su1.4s	v4, v5, v3
    35fc: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		00000000000035fc:  ARM64_RELOC_PAGE21	lCPI11_9
    3600: 3dc00100     	ldr	q0, [x8]
		0000000000003600:  ARM64_RELOC_PAGEOFF12	lCPI11_9
    3604: 4ea08487     	add.4s	v7, v4, v0
    3608: 4ea21c40     	mov.16b	v0, v2
    360c: 5e074022     	sha256h.4s	q2, q1, v7
    3610: 5e075001     	sha256h2.4s	q1, q0, v7
    3614: 5e2828a6     	sha256su0.4s	v6, v5
    3618: 5e046066     	sha256su1.4s	v6, v3, v4
    361c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000361c:  ARM64_RELOC_PAGE21	lCPI11_10
    3620: 3dc00100     	ldr	q0, [x8]
		0000000000003620:  ARM64_RELOC_PAGEOFF12	lCPI11_10
    3624: 4ea084c7     	add.4s	v7, v6, v0
    3628: 4ea21c40     	mov.16b	v0, v2
    362c: 5e074022     	sha256h.4s	q2, q1, v7
    3630: 5e075001     	sha256h2.4s	q1, q0, v7
    3634: 5e282865     	sha256su0.4s	v5, v3
    3638: 5e066085     	sha256su1.4s	v5, v4, v6
    363c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000363c:  ARM64_RELOC_PAGE21	lCPI11_11
    3640: 3dc00100     	ldr	q0, [x8]
		0000000000003640:  ARM64_RELOC_PAGEOFF12	lCPI11_11
    3644: 4ea084a7     	add.4s	v7, v5, v0
    3648: 4ea21c40     	mov.16b	v0, v2
    364c: 5e074022     	sha256h.4s	q2, q1, v7
    3650: 5e075001     	sha256h2.4s	q1, q0, v7
    3654: 5e282883     	sha256su0.4s	v3, v4
    3658: 5e0560c3     	sha256su1.4s	v3, v6, v5
    365c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000365c:  ARM64_RELOC_PAGE21	lCPI11_12
    3660: 3dc00100     	ldr	q0, [x8]
		0000000000003660:  ARM64_RELOC_PAGEOFF12	lCPI11_12
    3664: 4ea08467     	add.4s	v7, v3, v0
    3668: 4ea21c40     	mov.16b	v0, v2
    366c: 5e074022     	sha256h.4s	q2, q1, v7
    3670: 5e075001     	sha256h2.4s	q1, q0, v7
    3674: 5e2828c4     	sha256su0.4s	v4, v6
    3678: 5e0360a4     	sha256su1.4s	v4, v5, v3
    367c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000367c:  ARM64_RELOC_PAGE21	lCPI11_13
    3680: 3dc00100     	ldr	q0, [x8]
		0000000000003680:  ARM64_RELOC_PAGEOFF12	lCPI11_13
    3684: 4ea08487     	add.4s	v7, v4, v0
    3688: 4ea21c40     	mov.16b	v0, v2
    368c: 5e074022     	sha256h.4s	q2, q1, v7
    3690: 5e075001     	sha256h2.4s	q1, q0, v7
    3694: 5e2828a6     	sha256su0.4s	v6, v5
    3698: 5e046066     	sha256su1.4s	v6, v3, v4
    369c: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		000000000000369c:  ARM64_RELOC_PAGE21	lCPI11_14
    36a0: 3dc00100     	ldr	q0, [x8]
		00000000000036a0:  ARM64_RELOC_PAGEOFF12	lCPI11_14
    36a4: 4ea084c7     	add.4s	v7, v6, v0
    36a8: 4ea21c40     	mov.16b	v0, v2
    36ac: 5e074022     	sha256h.4s	q2, q1, v7
    36b0: 5e075001     	sha256h2.4s	q1, q0, v7
    36b4: 5e282865     	sha256su0.4s	v5, v3
    36b8: 5e066085     	sha256su1.4s	v5, v4, v6
    36bc: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		00000000000036bc:  ARM64_RELOC_PAGE21	lCPI11_15
    36c0: 3dc00100     	ldr	q0, [x8]
		00000000000036c0:  ARM64_RELOC_PAGEOFF12	lCPI11_15
    36c4: 4ea084a3     	add.4s	v3, v5, v0
    36c8: 4ea21c40     	mov.16b	v0, v2
    36cc: 5e034022     	sha256h.4s	q2, q1, v3
    36d0: 5e035001     	sha256h2.4s	q1, q0, v3
    36d4: ad400c00     	ldp	q0, q3, [x0]
    36d8: 4ea28400     	add.4s	v0, v0, v2
    36dc: 4ea18461     	add.4s	v1, v3, v1
    36e0: ad000400     	stp	q0, q1, [x0]
    36e4: a8c17bfd     	ldp	x29, x30, [sp], #0x10
    36e8: d65f03c0     	ret

00000000000036ec <_audit_master256>:
    36ec: d10643ff     	sub	sp, sp, #0x190
    36f0: a9174ff4     	stp	x20, x19, [sp, #0x170]
    36f4: a9187bfd     	stp	x29, x30, [sp, #0x180]
    36f8: 910603fd     	add	x29, sp, #0x180
    36fc: aa0103f3     	mov	x19, x1
    3700: ad400400     	ldp	q0, q1, [x0]
    3704: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
    3708: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003708:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
    370c: 91000108     	add	x8, x8, #0x0
		000000000000370c:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
    3710: ad400500     	ldp	q0, q1, [x8]
    3714: 3c8513e0     	stur	q0, [sp, #0x51]
    3718: 52840008     	mov	w8, #0x2000             ; =8192
    371c: 790083e8     	strh	w8, [sp, #0x40]
    3720: 528001a8     	mov	w8, #0xd                ; =13
    3724: 39010be8     	strb	w8, [sp, #0x42]
    3728: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003728:  ARM64_RELOC_PAGE21	___anon_2099
    372c: 91000108     	add	x8, x8, #0x0
		000000000000372c:  ARM64_RELOC_PAGEOFF12	___anon_2099
    3730: f9400109     	ldr	x9, [x8]
    3734: f80433e9     	stur	x9, [sp, #0x43]
    3738: f8405108     	ldur	x8, [x8, #0x5]
    373c: f90027e8     	str	x8, [sp, #0x48]
    3740: 52800408     	mov	w8, #0x20               ; =32
    3744: 390143e8     	strb	w8, [sp, #0x50]
    3748: 3c8613e1     	stur	q1, [sp, #0x61]
    374c: 910083e0     	add	x0, sp, #0x20
    3750: 910103e2     	add	x2, sp, #0x40
    3754: d100c3a4     	sub	x4, x29, #0x30
    3758: 52800401     	mov	w1, #0x20               ; =32
    375c: 52800623     	mov	w3, #0x31               ; =49
<L0>:
    3760: 94000000     	bl	 <L0>
		0000000000003760:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
    3764: 90000002     	adrp	x2, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003764:  ARM64_RELOC_PAGE21	_memx.Array(32).zero
    3768: 91000042     	add	x2, x2, #0x0
		0000000000003768:  ARM64_RELOC_PAGEOFF12	_memx.Array(32).zero
    376c: 910003e0     	mov	x0, sp
    3770: 910083e1     	add	x1, sp, #0x20
<L1>:
    3774: 94000000     	bl	 <L1>
		0000000000003774:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
    3778: ad4007e0     	ldp	q0, q1, [sp]
    377c: ad000660     	stp	q0, q1, [x19]
    3780: a9587bfd     	ldp	x29, x30, [sp, #0x180]
    3784: a9574ff4     	ldp	x20, x19, [sp, #0x170]
    3788: 910643ff     	add	sp, sp, #0x190
    378c: d65f03c0     	ret

0000000000003790 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
    3790: d106c3ff     	sub	sp, sp, #0x1b0
    3794: a9166ffc     	stp	x28, x27, [sp, #0x160]
    3798: a9175ff8     	stp	x24, x23, [sp, #0x170]
    379c: a91857f6     	stp	x22, x21, [sp, #0x180]
    37a0: a9194ff4     	stp	x20, x19, [sp, #0x190]
    37a4: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
    37a8: 910683fd     	add	x29, sp, #0x1a0
    37ac: aa0203f4     	mov	x20, x2
    37b0: aa0003f3     	mov	x19, x0
    37b4: 910083f7     	add	x23, sp, #0x20
    37b8: 910083e0     	add	x0, sp, #0x20
<L0>:
    37bc: 94000000     	bl	 <L0>
		00000000000037bc:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
    37c0: 394223e8     	ldrb	w8, [sp, #0x88]
    37c4: 34000228     	cbz	w8,  <L3>
    37c8: 7100811f     	cmp	w8, #0x20
    37cc: 540001e3     	b.lo	 <L3>
    37d0: 52800809     	mov	w9, #0x40               ; =64
    37d4: cb080135     	sub	x21, x9, x8
    37d8: 910083e9     	add	x9, sp, #0x20
    37dc: 9100a136     	add	x22, x9, #0x28
    37e0: 8b0802c0     	add	x0, x22, x8
    37e4: aa1403e1     	mov	x1, x20
    37e8: aa1503e2     	mov	x2, x21
<L1>:
    37ec: 94000000     	bl	 <L1>
		00000000000037ec:  ARM64_RELOC_BRANCH26	_memcpy
    37f0: 910083e0     	add	x0, sp, #0x20
    37f4: aa1603e1     	mov	x1, x22
<L2>:
    37f8: 94000000     	bl	 <L2>
		00000000000037f8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    37fc: 52800008     	mov	w8, #0x0                ; =0
    3800: 390223ff     	strb	wzr, [sp, #0x88]
    3804: 14000002     	b	 <L4>
<L3>:
    3808: d2800015     	mov	x21, #0x0               ; =0
<L4>:
    380c: 52800409     	mov	w9, #0x20               ; =32
    3810: cb150136     	sub	x22, x9, x21
    3814: 8b2842e8     	add	x8, x23, w8, uxtw
    3818: 9100a100     	add	x0, x8, #0x28
    381c: 8b150281     	add	x1, x20, x21
    3820: aa1603e2     	mov	x2, x22
<L5>:
    3824: 94000000     	bl	 <L5>
		0000000000003824:  ARM64_RELOC_BRANCH26	_memcpy
    3828: 394223e8     	ldrb	w8, [sp, #0x88]
    382c: 0b160108     	add	w8, w8, w22
    3830: 390223e8     	strb	w8, [sp, #0x88]
    3834: f94023e8     	ldr	x8, [sp, #0x40]
    3838: 91008108     	add	x8, x8, #0x20
    383c: f90023e8     	str	x8, [sp, #0x40]
    3840: 910343f8     	add	x24, sp, #0xd0
    3844: 910083e0     	add	x0, sp, #0x20
    3848: 910343e1     	add	x1, sp, #0xd0
<L6>:
    384c: 94000000     	bl	 <L6>
		000000000000384c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
    3850: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003850:  ARM64_RELOC_PAGE21	___anon_7680
    3854: 91000108     	add	x8, x8, #0x0
		0000000000003854:  ARM64_RELOC_PAGEOFF12	___anon_7680
    3858: ad420500     	ldp	q0, q1, [x8, #0x40]
    385c: ad3c87a0     	stp	q0, q1, [x29, #-0x70]
    3860: 3dc01900     	ldr	q0, [x8, #0x60]
    3864: 3c9b03a0     	stur	q0, [x29, #-0x50]
    3868: ad400500     	ldp	q0, q1, [x8]
    386c: ad3a87a0     	stp	q0, q1, [x29, #-0xb0]
    3870: ad410101     	ldp	q1, q0, [x8, #0x20]
    3874: ad3b83a1     	stp	q1, q0, [x29, #-0x90]
    3878: d102c3b4     	sub	x20, x29, #0xb0
    387c: d102c3a0     	sub	x0, x29, #0xb0
    3880: 9101c2e1     	add	x1, x23, #0x70
<L7>:
    3884: 94000000     	bl	 <L7>
		0000000000003884:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    3888: 385b83a8     	ldurb	w8, [x29, #-0x48]
    388c: f85703a9     	ldur	x9, [x29, #-0x90]
    3890: 9100a294     	add	x20, x20, #0x28
    3894: 91010137     	add	x23, x9, #0x40
    3898: f81703b7     	stur	x23, [x29, #-0x90]
    389c: 34000208     	cbz	w8,  <L10>
    38a0: 7100811f     	cmp	w8, #0x20
    38a4: 540001c3     	b.lo	 <L10>
    38a8: 52800809     	mov	w9, #0x40               ; =64
    38ac: cb080135     	sub	x21, x9, x8
    38b0: 8b080280     	add	x0, x20, x8
    38b4: 910343e1     	add	x1, sp, #0xd0
    38b8: aa1503e2     	mov	x2, x21
<L8>:
    38bc: 94000000     	bl	 <L8>
		00000000000038bc:  ARM64_RELOC_BRANCH26	_memcpy
    38c0: d102c3a0     	sub	x0, x29, #0xb0
    38c4: aa1403e1     	mov	x1, x20
<L9>:
    38c8: 94000000     	bl	 <L9>
		00000000000038c8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
    38cc: 52800008     	mov	w8, #0x0                ; =0
    38d0: 381b83bf     	sturb	wzr, [x29, #-0x48]
    38d4: f85703b7     	ldur	x23, [x29, #-0x90]
    38d8: 14000002     	b	 <L11>
<L10>:
    38dc: d2800015     	mov	x21, #0x0               ; =0
<L11>:
    38e0: 52800409     	mov	w9, #0x20               ; =32
    38e4: cb150136     	sub	x22, x9, x21
    38e8: 8b284280     	add	x0, x20, w8, uxtw
    38ec: 8b150301     	add	x1, x24, x21
    38f0: aa1603e2     	mov	x2, x22
<L12>:
    38f4: 94000000     	bl	 <L12>
		00000000000038f4:  ARM64_RELOC_BRANCH26	_memcpy
    38f8: 385b83a8     	ldurb	w8, [x29, #-0x48]
    38fc: 0b160108     	add	w8, w8, w22
    3900: 381b83a8     	sturb	w8, [x29, #-0x48]
    3904: 910082e8     	add	x8, x23, #0x20
    3908: f81703a8     	stur	x8, [x29, #-0x90]
    390c: d102c3a0     	sub	x0, x29, #0xb0
    3910: 910003e1     	mov	x1, sp
<L13>:
    3914: 94000000     	bl	 <L13>
		0000000000003914:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
    3918: ad4007e0     	ldp	q0, q1, [sp]
    391c: ad000660     	stp	q0, q1, [x19]
    3920: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
    3924: a9594ff4     	ldp	x20, x19, [sp, #0x190]
    3928: a95857f6     	ldp	x22, x21, [sp, #0x180]
    392c: a9575ff8     	ldp	x24, x23, [sp, #0x170]
    3930: a9566ffc     	ldp	x28, x27, [sp, #0x160]
    3934: 9106c3ff     	add	sp, sp, #0x1b0
    3938: d65f03c0     	ret

000000000000393c <_audit_handshake256>:
    393c: d10683ff     	sub	sp, sp, #0x1a0
    3940: a9176ffc     	stp	x28, x27, [sp, #0x170]
    3944: a9184ff4     	stp	x20, x19, [sp, #0x180]
    3948: a9197bfd     	stp	x29, x30, [sp, #0x190]
    394c: 910643fd     	add	x29, sp, #0x190
    3950: aa0203f3     	mov	x19, x2
    3954: aa0103f4     	mov	x20, x1
    3958: ad400400     	ldp	q0, q1, [x0]
    395c: ad3e07a0     	stp	q0, q1, [x29, #-0x40]
    3960: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003960:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
    3964: 91000108     	add	x8, x8, #0x0
		0000000000003964:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
    3968: ad400500     	ldp	q0, q1, [x8]
    396c: 3c8513e0     	stur	q0, [sp, #0x51]
    3970: 52840008     	mov	w8, #0x2000             ; =8192
    3974: 790083e8     	strh	w8, [sp, #0x40]
    3978: 528001a8     	mov	w8, #0xd                ; =13
    397c: 39010be8     	strb	w8, [sp, #0x42]
    3980: 90000008     	adrp	x8, 0x3000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x14c>
		0000000000003980:  ARM64_RELOC_PAGE21	___anon_2099
    3984: 91000108     	add	x8, x8, #0x0
		0000000000003984:  ARM64_RELOC_PAGEOFF12	___anon_2099
    3988: f9400109     	ldr	x9, [x8]
    398c: f80433e9     	stur	x9, [sp, #0x43]
    3990: f8405108     	ldur	x8, [x8, #0x5]
    3994: f90027e8     	str	x8, [sp, #0x48]
    3998: 52800408     	mov	w8, #0x20               ; =32
    399c: 390143e8     	strb	w8, [sp, #0x50]
    39a0: 3c8613e1     	stur	q1, [sp, #0x61]
    39a4: 910083e0     	add	x0, sp, #0x20
    39a8: 910103e2     	add	x2, sp, #0x40
    39ac: d10103a4     	sub	x4, x29, #0x40
    39b0: 52800401     	mov	w1, #0x20               ; =32
    39b4: 52800623     	mov	w3, #0x31               ; =49
<L0>:
    39b8: 94000000     	bl	 <L0>
		00000000000039b8:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
    39bc: 910003e0     	mov	x0, sp
    39c0: 910083e1     	add	x1, sp, #0x20
    39c4: aa1403e2     	mov	x2, x20
<L1>:
    39c8: 94000000     	bl	 <L1>
		00000000000039c8:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
    39cc: ad4007e0     	ldp	q0, q1, [sp]
    39d0: ad000660     	stp	q0, q1, [x19]
    39d4: a9597bfd     	ldp	x29, x30, [sp, #0x190]
    39d8: a9584ff4     	ldp	x20, x19, [sp, #0x180]
    39dc: a9576ffc     	ldp	x28, x27, [sp, #0x170]
    39e0: 910683ff     	add	sp, sp, #0x1a0
    39e4: d65f03c0     	ret
