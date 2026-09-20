
/tmp/ztls-signoff-20260919/125-before-6d73a0a/016-aarch64-linux-gnu.o:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000000000 <audit_key384>:
<L0>:
       0: d10583ff     	sub	sp, sp, #0x160
       4: a9147bfd     	stp	x29, x30, [sp, #0x140]
       8: f900abfc     	str	x28, [sp, #0x150]
       c: 910503fd     	add	x29, sp, #0x140
      10: ad400400     	ldp	q0, q1, [x0]
      14: d100c3a8     	sub	x8, x29, #0x30
      18: 52840009     	mov	w9, #0x2000             // =8192
      1c: 910013e2     	add	x2, sp, #0x4
      20: d100c3a4     	sub	x4, x29, #0x30
      24: 79000be9     	strh	w9, [sp, #0x4]
      28: 52800129     	mov	w9, #0x9                // =9
      2c: 528001a3     	mov	w3, #0xd                // =13
      30: ad000500     	stp	q0, q1, [x8]
      34: 3dc00800     	ldr	q0, [x0, #0x20]
      38: aa0103e0     	mov	x0, x1
      3c: 52800401     	mov	w1, #0x20               // =32
      40: 39001be9     	strb	w9, [sp, #0x6]
      44: 3d800900     	str	q0, [x8, #0x20]
      48: 90000008     	adrp	x8, 0x0 <audit_key384>
		0000000000000048:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
      4c: 91000108     	add	x8, x8, #0x0
		000000000000004c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
      50: f9400108     	ldr	x8, [x8]
      54: f80073e8     	stur	x8, [sp, #0x7]
      58: 52800f28     	mov	w8, #0x79               // =121
      5c: 7800f3e8     	sturh	w8, [sp, #0xf]
      60: 94000005     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
      64: a9547bfd     	ldp	x29, x30, [sp, #0x140]
      68: f940abfc     	ldr	x28, [sp, #0x150]
      6c: 910583ff     	add	sp, sp, #0x160
      70: d65f03c0     	ret

0000000000000074 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
      74: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
      78: a9016ffc     	stp	x28, x27, [sp, #0x10]
      7c: a90267fa     	stp	x26, x25, [sp, #0x20]
      80: a9035ff8     	stp	x24, x23, [sp, #0x30]
      84: a90457f6     	stp	x22, x21, [sp, #0x40]
      88: a9054ff4     	stp	x20, x19, [sp, #0x50]
      8c: 910003fd     	mov	x29, sp
      90: d11b43ff     	sub	sp, sp, #0x6d0
      94: ad400480     	ldp	q0, q1, [x4]
      98: 52800028     	mov	w8, #0x1                // =1
      9c: 3dc00882     	ldr	q2, [x4, #0x20]
      a0: aa0303f3     	mov	x19, x3
      a4: f100c03f     	cmp	x1, #0x30
      a8: 3905b3e8     	strb	w8, [sp, #0x16c]
      ac: 90000008     	adrp	x8, 0x0 <audit_key384>
		00000000000000ac:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x10
      b0: 91000108     	add	x8, x8, #0x0
		00000000000000b0:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x10
      b4: a90283e2     	stp	x2, x0, [sp, #0x28]
      b8: ad0987e0     	stp	q0, q1, [sp, #0x130]
      bc: 3d8057e2     	str	q2, [sp, #0x150]
      c0: f9000fe1     	str	x1, [sp, #0x18]
      c4: 54000bc2     	b.hs	 <L4>
      c8: f90003ff     	str	xzr, [sp]
<L0>:
      cc: f9400fe9     	ldr	x9, [sp, #0x18]
      d0: f100c128     	subs	x8, x9, #0x30
      d4: 9a883137     	csel	x23, x9, x8, lo
      d8: b4003f17     	cbz	x23,  <L43>
      dc: 6f00e402     	movi	v2.2d, #0000000000000000
      e0: ad4987e0     	ldp	q0, q1, [sp, #0x130]
      e4: 3dc057e3     	ldr	q3, [sp, #0x150]
      e8: aa1f03e8     	mov	x8, xzr
      ec: 911383e9     	add	x9, sp, #0x4e0
      f0: d10243aa     	sub	x10, x29, #0x90
      f4: 52800b8b     	mov	w11, #0x5c              // =92
      f8: ad3b87a0     	stp	q0, q1, [x29, #-0x90]
      fc: ad3c8ba3     	stp	q3, q2, [x29, #-0x70]
     100: ad3d8ba2     	stp	q2, q2, [x29, #-0x50]
     104: ad3e8ba2     	stp	q2, q2, [x29, #-0x30]
<L1>:
     108: 3868694c     	ldrb	w12, [x10, x8]
     10c: 8b08012d     	add	x13, x9, x8
     110: 91000508     	add	x8, x8, #0x1
     114: f102011f     	cmp	x8, #0x80
     118: 4a0b018c     	eor	w12, w12, w11
     11c: 390381ac     	strb	w12, [x13, #0xe0]
     120: 54ffff41     	b.ne	 <L1>
     124: aa1f03e8     	mov	x8, xzr
     128: d10243a9     	sub	x9, x29, #0x90
     12c: 528006ca     	mov	w10, #0x36              // =54
     130: 910c03eb     	add	x11, sp, #0x300
<L2>:
     134: 3868692c     	ldrb	w12, [x9, x8]
     138: 4a0a018c     	eor	w12, w12, w10
     13c: 3828696c     	strb	w12, [x11, x8]
     140: 91000508     	add	x8, x8, #0x1
     144: f102011f     	cmp	x8, #0x80
     148: 54ffff61     	b.ne	 <L2>
     14c: 90000008     	adrp	x8, 0x0 <audit_key384>
		000000000000014c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x10
     150: 91000108     	add	x8, x8, #0x0
		0000000000000150:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x10
     154: 911383e0     	add	x0, sp, #0x4e0
     158: ad450500     	ldp	q0, q1, [x8, #0xa0]
     15c: 910c03e1     	add	x1, sp, #0x300
     160: ad0883e1     	stp	q1, q0, [sp, #0x110]
     164: 3d8163e0     	str	q0, [sp, #0x580]
     168: ad460900     	ldp	q0, q2, [x8, #0xc0]
     16c: 3d8167e1     	str	q1, [sp, #0x590]
     170: ad0783e2     	stp	q2, q0, [sp, #0xf0]
     174: 3d816be0     	str	q0, [sp, #0x5a0]
     178: ad430101     	ldp	q1, q0, [x8, #0x60]
     17c: 3d816fe2     	str	q2, [sp, #0x5b0]
     180: ad0687e0     	stp	q0, q1, [sp, #0xd0]
     184: 3d8157e0     	str	q0, [sp, #0x550]
     188: ad440102     	ldp	q2, q0, [x8, #0x80]
     18c: 3d8153e1     	str	q1, [sp, #0x540]
     190: ad058be0     	stp	q0, q2, [sp, #0xb0]
     194: 3d815fe0     	str	q0, [sp, #0x570]
     198: ad410101     	ldp	q1, q0, [x8, #0x20]
     19c: 3d815be2     	str	q2, [sp, #0x560]
     1a0: ad0487e0     	stp	q0, q1, [sp, #0x90]
     1a4: 3d8147e0     	str	q0, [sp, #0x510]
     1a8: ad420102     	ldp	q2, q0, [x8, #0x40]
     1ac: 3d8143e1     	str	q1, [sp, #0x500]
     1b0: ad038be0     	stp	q0, q2, [sp, #0x70]
     1b4: 3d814fe0     	str	q0, [sp, #0x530]
     1b8: ad400101     	ldp	q1, q0, [x8]
     1bc: 3d814be2     	str	q2, [sp, #0x520]
     1c0: ad0287e0     	stp	q0, q1, [sp, #0x50]
     1c4: 3d813be1     	str	q1, [sp, #0x4e0]
     1c8: 3d813fe0     	str	q0, [sp, #0x4f0]
     1cc: 940001c3     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     1d0: f94273e8     	ldr	x8, [sp, #0x4e0]
     1d4: f94277e9     	ldr	x9, [sp, #0x4e8]
     1d8: f9400feb     	ldr	x11, [sp, #0x18]
     1dc: b102010a     	adds	x10, x8, #0x80
     1e0: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     1e4: 9a893529     	cinc	x9, x9, hs
     1e8: f100bd7f     	cmp	x11, #0x2f
     1ec: f90273ea     	str	x10, [sp, #0x4e0]
     1f0: f90277e9     	str	x9, [sp, #0x4e8]
     1f4: 54002489     	b.ls	 <L29>
     1f8: 34002208     	cbz	w8,  <L26>
     1fc: 7101411f     	cmp	w8, #0x50
     200: 540021c3     	b.lo	 <L26>
     204: 52801009     	mov	w9, #0x80               // =128
     208: 911383ea     	add	x10, sp, #0x4e0
     20c: f9401be1     	ldr	x1, [sp, #0x30]
     210: cb080136     	sub	x22, x9, x8
     214: 91014158     	add	x24, x10, #0x50
     218: 8b080300     	add	x0, x24, x8
     21c: aa1603e2     	mov	x2, x22
<L3>:
     220: 94000000     	bl	 <L3>
		0000000000000220:  R_AARCH64_CALL26	memcpy
     224: 911383e0     	add	x0, sp, #0x4e0
     228: aa1803e1     	mov	x1, x24
     22c: 940001ab     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     230: 2a1f03e8     	mov	w8, wzr
     234: 3916c3ff     	strb	wzr, [sp, #0x5b0]
     238: 14000101     	b	 <L27>
<L4>:
     23c: ad450101     	ldp	q1, q0, [x8, #0xa0]
     240: d2401a69     	eor	x9, x19, #0x7f
     244: a900cfe9     	stp	x9, x19, [sp, #0x8]
     248: 9105c3e9     	add	x9, sp, #0x170
     24c: 910c03fc     	add	x28, sp, #0x300
     250: 91014129     	add	x9, x9, #0x50
     254: aa1f03ea     	mov	x10, xzr
     258: 911183fb     	add	x27, sp, #0x460
     25c: ad0807e0     	stp	q0, q1, [sp, #0x100]
     260: ad460101     	ldp	q1, q0, [x8, #0xc0]
     264: f90093e9     	str	x9, [sp, #0x120]
     268: 91014389     	add	x9, x28, #0x50
     26c: 52800b95     	mov	w21, #0x5c              // =92
     270: 528006d6     	mov	w22, #0x36              // =54
     274: d10243b4     	sub	x20, x29, #0x90
     278: 52800039     	mov	w25, #0x1               // =1
     27c: ad0707e0     	stp	q0, q1, [sp, #0xe0]
     280: ad430101     	ldp	q1, q0, [x8, #0x60]
     284: 52800038     	mov	w24, #0x1               // =1
     288: f90013e9     	str	x9, [sp, #0x20]
     28c: ad0607e0     	stp	q0, q1, [sp, #0xc0]
     290: ad440101     	ldp	q1, q0, [x8, #0x80]
     294: ad0507e0     	stp	q0, q1, [sp, #0xa0]
     298: ad410101     	ldp	q1, q0, [x8, #0x20]
     29c: ad0407e0     	stp	q0, q1, [sp, #0x80]
     2a0: ad420101     	ldp	q1, q0, [x8, #0x40]
     2a4: ad0307e0     	stp	q0, q1, [sp, #0x60]
     2a8: ad400101     	ldp	q1, q0, [x8]
     2ac: 52800608     	mov	w8, #0x30               // =48
     2b0: f90003e8     	str	x8, [sp]
     2b4: ad0207e0     	stp	q0, q1, [sp, #0x40]
     2b8: 1400001b     	b	 <L8>
<L5>:
     2bc: aa1f03f9     	mov	x25, xzr
<L6>:
     2c0: f94013e9     	ldr	x9, [sp, #0x20]
     2c4: 8b190281     	add	x1, x20, x25
     2c8: 8b284120     	add	x0, x9, w8, uxtw
     2cc: 52800608     	mov	w8, #0x30               // =48
     2d0: cb19011a     	sub	x26, x8, x25
     2d4: aa1a03e2     	mov	x2, x26
<L7>:
     2d8: 94000000     	bl	 <L7>
		00000000000002d8:  R_AARCH64_CALL26	memcpy
     2dc: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     2e0: b100c2e9     	adds	x9, x23, #0x30
     2e4: 910c03e0     	add	x0, sp, #0x300
     2e8: f90183e9     	str	x9, [sp, #0x300]
     2ec: 9a93366a     	cinc	x10, x19, hs
     2f0: 0b1a0108     	add	w8, w8, w26
     2f4: f90187ea     	str	x10, [sp, #0x308]
     2f8: 390f43e8     	strb	w8, [sp, #0x3d0]
     2fc: a94327e8     	ldp	x8, x9, [sp, #0x30]
     300: 8b090101     	add	x1, x8, x9
     304: 94000966     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     308: a94123f3     	ldp	x19, x8, [sp, #0x10]
     30c: 2a1f03f9     	mov	w25, wzr
     310: 11000718     	add	w24, w24, #0x1
     314: 5280060a     	mov	w10, #0x30              // =48
     318: 3905b3f8     	strb	w24, [sp, #0x16c]
     31c: f101811f     	cmp	x8, #0x60
     320: 54ffed63     	b.lo	 <L0>
<L8>:
     324: ad4987e0     	ldp	q0, q1, [sp, #0x130]
     328: aa1f03e8     	mov	x8, xzr
     32c: 3dc057e2     	ldr	q2, [sp, #0x150]
     330: f9001fea     	str	x10, [sp, #0x38]
     334: 3d811be0     	str	q0, [sp, #0x460]
     338: 6f00e400     	movi	v0.2d, #0000000000000000
     33c: 3d811fe1     	str	q1, [sp, #0x470]
     340: 3d8123e2     	str	q2, [sp, #0x480]
     344: ad018360     	stp	q0, q0, [x27, #0x30]
     348: ad028360     	stp	q0, q0, [x27, #0x50]
     34c: 3c870360     	stur	q0, [x27, #0x70]
<L9>:
     350: 38686b69     	ldrb	w9, [x27, x8]
     354: 8b08038a     	add	x10, x28, x8
     358: 91000508     	add	x8, x8, #0x1
     35c: f102011f     	cmp	x8, #0x80
     360: 4a150129     	eor	w9, w9, w21
     364: 39038149     	strb	w9, [x10, #0xe0]
     368: 54ffff41     	b.ne	 <L9>
     36c: aa1f03e8     	mov	x8, xzr
<L10>:
     370: 38686b69     	ldrb	w9, [x27, x8]
     374: 4a160129     	eor	w9, w9, w22
     378: 38286a89     	strb	w9, [x20, x8]
     37c: 91000508     	add	x8, x8, #0x1
     380: f102011f     	cmp	x8, #0x80
     384: 54ffff61     	b.ne	 <L10>
     388: ad4807e0     	ldp	q0, q1, [sp, #0x100]
     38c: 910c03e0     	add	x0, sp, #0x300
     390: d10243a1     	sub	x1, x29, #0x90
     394: ad1d03e1     	stp	q1, q0, [sp, #0x3a0]
     398: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
     39c: ad1e03e1     	stp	q1, q0, [sp, #0x3c0]
     3a0: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
     3a4: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     3a8: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
     3ac: ad1c03e1     	stp	q1, q0, [sp, #0x380]
     3b0: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     3b4: ad1903e1     	stp	q1, q0, [sp, #0x320]
     3b8: ad4307e0     	ldp	q0, q1, [sp, #0x60]
     3bc: ad1a03e1     	stp	q1, q0, [sp, #0x340]
     3c0: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     3c4: ad1803e1     	stp	q1, q0, [sp, #0x300]
     3c8: 94000144     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     3cc: f94183e8     	ldr	x8, [sp, #0x300]
     3d0: f94187e9     	ldr	x9, [sp, #0x308]
     3d4: 9105c3e0     	add	x0, sp, #0x170
     3d8: 910c03e1     	add	x1, sp, #0x300
     3dc: 52802c02     	mov	w2, #0x160              // =352
     3e0: b1020108     	adds	x8, x8, #0x80
     3e4: 9a893529     	cinc	x9, x9, hs
     3e8: f90183e8     	str	x8, [sp, #0x300]
     3ec: f90187e9     	str	x9, [sp, #0x308]
<L11>:
     3f0: 94000000     	bl	 <L11>
		00000000000003f0:  R_AARCH64_CALL26	memcpy
     3f4: 394903e8     	ldrb	w8, [sp, #0x240]
     3f8: 37000439     	tbnz	w25, #0x0,  <L16>
     3fc: 34000208     	cbz	w8,  <L13>
     400: 7101411f     	cmp	w8, #0x50
     404: 540001c3     	b.lo	 <L13>
     408: 52801009     	mov	w9, #0x80               // =128
     40c: f94093f7     	ldr	x23, [sp, #0x120]
     410: f9401be1     	ldr	x1, [sp, #0x30]
     414: cb080139     	sub	x25, x9, x8
     418: 8b0802e0     	add	x0, x23, x8
     41c: aa1903e2     	mov	x2, x25
<L12>:
     420: 94000000     	bl	 <L12>
		0000000000000420:  R_AARCH64_CALL26	memcpy
     424: 9105c3e0     	add	x0, sp, #0x170
     428: aa1703e1     	mov	x1, x23
     42c: 9400012b     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     430: 2a1f03e8     	mov	w8, wzr
     434: 390903ff     	strb	wzr, [sp, #0x240]
     438: 14000002     	b	 <L14>
<L13>:
     43c: aa1f03f9     	mov	x25, xzr
<L14>:
     440: f94093e9     	ldr	x9, [sp, #0x120]
     444: 8b284120     	add	x0, x9, w8, uxtw
     448: 52800608     	mov	w8, #0x30               // =48
     44c: cb19011a     	sub	x26, x8, x25
     450: f9401be8     	ldr	x8, [sp, #0x30]
     454: aa1a03e2     	mov	x2, x26
     458: 8b190101     	add	x1, x8, x25
<L15>:
     45c: 94000000     	bl	 <L15>
		000000000000045c:  R_AARCH64_CALL26	memcpy
     460: a9572be9     	ldp	x9, x10, [sp, #0x170]
     464: 394903e8     	ldrb	w8, [sp, #0x240]
     468: 0b1a0108     	add	w8, w8, w26
     46c: b100c129     	adds	x9, x9, #0x30
     470: 390903e8     	strb	w8, [sp, #0x240]
     474: 9a8a354a     	cinc	x10, x10, hs
     478: a9172be9     	stp	x9, x10, [sp, #0x170]
<L16>:
     47c: 34000248     	cbz	w8,  <L18>
     480: f94007ea     	ldr	x10, [sp, #0x8]
     484: 2a0803e9     	mov	w9, w8
     488: eb09015f     	cmp	x10, x9
     48c: 540001c2     	b.hs	 <L18>
     490: 5280100a     	mov	w10, #0x80              // =128
     494: f94093f7     	ldr	x23, [sp, #0x120]
     498: f94017e1     	ldr	x1, [sp, #0x28]
     49c: 4b080159     	sub	w25, w10, w8
     4a0: 8b0902e0     	add	x0, x23, x9
     4a4: aa1903e2     	mov	x2, x25
<L17>:
     4a8: 94000000     	bl	 <L17>
		00000000000004a8:  R_AARCH64_CALL26	memcpy
     4ac: 9105c3e0     	add	x0, sp, #0x170
     4b0: aa1703e1     	mov	x1, x23
     4b4: 94000109     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     4b8: 2a1f03e8     	mov	w8, wzr
     4bc: 390903ff     	strb	wzr, [sp, #0x240]
     4c0: 14000002     	b	 <L19>
<L18>:
     4c4: aa1f03f9     	mov	x25, xzr
<L19>:
     4c8: f94093e9     	ldr	x9, [sp, #0x120]
     4cc: cb19027a     	sub	x26, x19, x25
     4d0: aa1a03e2     	mov	x2, x26
     4d4: 8b284120     	add	x0, x9, w8, uxtw
     4d8: f94017e8     	ldr	x8, [sp, #0x28]
     4dc: 8b190101     	add	x1, x8, x25
<L20>:
     4e0: 94000000     	bl	 <L20>
		00000000000004e0:  R_AARCH64_CALL26	memcpy
     4e4: a9572be9     	ldp	x9, x10, [sp, #0x170]
     4e8: 394903e8     	ldrb	w8, [sp, #0x240]
     4ec: 0b1a0108     	add	w8, w8, w26
     4f0: ab130137     	adds	x23, x9, x19
     4f4: 390903e8     	strb	w8, [sp, #0x240]
     4f8: 9a8a3553     	cinc	x19, x10, hs
     4fc: a9174ff7     	stp	x23, x19, [sp, #0x170]
     500: 34000228     	cbz	w8,  <L22>
     504: 7101fd1f     	cmp	w8, #0x7f
     508: 540001e3     	b.lo	 <L22>
     50c: f94093f3     	ldr	x19, [sp, #0x120]
     510: 52801009     	mov	w9, #0x80               // =128
     514: 9105b3e1     	add	x1, sp, #0x16c
     518: 4b080139     	sub	w25, w9, w8
     51c: 8b284260     	add	x0, x19, w8, uxtw
     520: aa1903e2     	mov	x2, x25
<L21>:
     524: 94000000     	bl	 <L21>
		0000000000000524:  R_AARCH64_CALL26	memcpy
     528: 9105c3e0     	add	x0, sp, #0x170
     52c: aa1303e1     	mov	x1, x19
     530: 940000ea     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     534: a9574ff7     	ldp	x23, x19, [sp, #0x170]
     538: 2a1f03e8     	mov	w8, wzr
     53c: 390903ff     	strb	wzr, [sp, #0x240]
     540: 14000002     	b	 <L23>
<L22>:
     544: aa1f03f9     	mov	x25, xzr
<L23>:
     548: f94093e9     	ldr	x9, [sp, #0x120]
     54c: 8b284120     	add	x0, x9, w8, uxtw
     550: 52800028     	mov	w8, #0x1                // =1
     554: cb19011a     	sub	x26, x8, x25
     558: 9105b3e8     	add	x8, sp, #0x16c
     55c: 8b190101     	add	x1, x8, x25
     560: aa1a03e2     	mov	x2, x26
<L24>:
     564: 94000000     	bl	 <L24>
		0000000000000564:  R_AARCH64_CALL26	memcpy
     568: 394903e8     	ldrb	w8, [sp, #0x240]
     56c: b10006e9     	adds	x9, x23, #0x1
     570: 9105c3e0     	add	x0, sp, #0x170
     574: 9a93366a     	cinc	x10, x19, hs
     578: d10243a1     	sub	x1, x29, #0x90
     57c: 0b1a0108     	add	w8, w8, w26
     580: a9172be9     	stp	x9, x10, [sp, #0x170]
     584: 390903e8     	strb	w8, [sp, #0x240]
     588: 940008c5     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     58c: ad4807e0     	ldp	q0, q1, [sp, #0x100]
     590: 9105c3e8     	add	x8, sp, #0x170
     594: 910c03e0     	add	x0, sp, #0x300
     598: 91038101     	add	x1, x8, #0xe0
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
     5d0: 940000c2     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     5d4: f94183e9     	ldr	x9, [sp, #0x300]
     5d8: f94187ea     	ldr	x10, [sp, #0x308]
     5dc: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     5e0: b1020137     	adds	x23, x9, #0x80
     5e4: 9a8a3553     	cinc	x19, x10, hs
     5e8: f90183f7     	str	x23, [sp, #0x300]
     5ec: f90187f3     	str	x19, [sp, #0x308]
     5f0: 34ffe668     	cbz	w8,  <L5>
     5f4: 7101411f     	cmp	w8, #0x50
     5f8: 54ffe623     	b.lo	 <L5>
     5fc: 52801009     	mov	w9, #0x80               // =128
     600: f94013f3     	ldr	x19, [sp, #0x20]
     604: d10243a1     	sub	x1, x29, #0x90
     608: cb080139     	sub	x25, x9, x8
     60c: 8b080260     	add	x0, x19, x8
     610: aa1903e2     	mov	x2, x25
<L25>:
     614: 94000000     	bl	 <L25>
		0000000000000614:  R_AARCH64_CALL26	memcpy
     618: 910c03e0     	add	x0, sp, #0x300
     61c: aa1303e1     	mov	x1, x19
     620: 940000ae     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     624: f94187f3     	ldr	x19, [sp, #0x308]
     628: f94183f7     	ldr	x23, [sp, #0x300]
     62c: 2a1f03e8     	mov	w8, wzr
     630: 390f43ff     	strb	wzr, [sp, #0x3d0]
     634: 17ffff23     	b	 <L6>
<L26>:
     638: aa1f03f6     	mov	x22, xzr
<L27>:
     63c: 911383e9     	add	x9, sp, #0x4e0
     640: 5280060a     	mov	w10, #0x30              // =48
     644: 8b284128     	add	x8, x9, w8, uxtw
     648: cb160158     	sub	x24, x10, x22
     64c: aa1803e2     	mov	x2, x24
     650: 91014100     	add	x0, x8, #0x50
     654: f9401be8     	ldr	x8, [sp, #0x30]
     658: 8b160101     	add	x1, x8, x22
<L28>:
     65c: 94000000     	bl	 <L28>
		000000000000065c:  R_AARCH64_CALL26	memcpy
     660: f94273e9     	ldr	x9, [sp, #0x4e0]
     664: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     668: f94277ea     	ldr	x10, [sp, #0x4e8]
     66c: b100c129     	adds	x9, x9, #0x30
     670: 0b180108     	add	w8, w8, w24
     674: 9a8a354a     	cinc	x10, x10, hs
     678: 3916c3e8     	strb	w8, [sp, #0x5b0]
     67c: f90273e9     	str	x9, [sp, #0x4e0]
     680: f90277ea     	str	x10, [sp, #0x4e8]
<L29>:
     684: 34000288     	cbz	w8,  <L31>
     688: 2a0803e9     	mov	w9, w8
     68c: 8b09026a     	add	x10, x19, x9
     690: f102015f     	cmp	x10, #0x80
     694: 54000203     	b.lo	 <L31>
     698: 5280100a     	mov	w10, #0x80              // =128
     69c: 911383eb     	add	x11, sp, #0x4e0
     6a0: f94017e1     	ldr	x1, [sp, #0x28]
     6a4: 4b080158     	sub	w24, w10, w8
     6a8: 91014176     	add	x22, x11, #0x50
     6ac: aa1303f4     	mov	x20, x19
     6b0: 8b0902c0     	add	x0, x22, x9
     6b4: aa1803e2     	mov	x2, x24
<L30>:
     6b8: 94000000     	bl	 <L30>
		00000000000006b8:  R_AARCH64_CALL26	memcpy
     6bc: 911383e0     	add	x0, sp, #0x4e0
     6c0: aa1603e1     	mov	x1, x22
     6c4: 94000085     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     6c8: 2a1f03e8     	mov	w8, wzr
     6cc: 3916c3ff     	strb	wzr, [sp, #0x5b0]
     6d0: 14000003     	b	 <L32>
<L31>:
     6d4: aa1303f4     	mov	x20, x19
     6d8: aa1f03f8     	mov	x24, xzr
<L32>:
     6dc: 911383f3     	add	x19, sp, #0x4e0
     6e0: cb180299     	sub	x25, x20, x24
     6e4: 91014276     	add	x22, x19, #0x50
     6e8: aa1903e2     	mov	x2, x25
     6ec: 8b2842c0     	add	x0, x22, w8, uxtw
     6f0: f94017e8     	ldr	x8, [sp, #0x28]
     6f4: 8b180101     	add	x1, x8, x24
<L33>:
     6f8: 94000000     	bl	 <L33>
		00000000000006f8:  R_AARCH64_CALL26	memcpy
     6fc: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     700: f94273e9     	ldr	x9, [sp, #0x4e0]
     704: f94277ea     	ldr	x10, [sp, #0x4e8]
     708: 0b190108     	add	w8, w8, w25
     70c: ab140139     	adds	x25, x9, x20
     710: 9a8a3558     	cinc	x24, x10, hs
     714: 3916c3e8     	strb	w8, [sp, #0x5b0]
     718: f90273f9     	str	x25, [sp, #0x4e0]
     71c: f90277f8     	str	x24, [sp, #0x4e8]
     720: 34000228     	cbz	w8,  <L35>
     724: 7101fd1f     	cmp	w8, #0x7f
     728: 540001e3     	b.lo	 <L35>
     72c: 52801009     	mov	w9, #0x80               // =128
     730: 8b2842c0     	add	x0, x22, w8, uxtw
     734: 9105b3e1     	add	x1, sp, #0x16c
     738: 4b080134     	sub	w20, w9, w8
     73c: aa1403e2     	mov	x2, x20
<L34>:
     740: 94000000     	bl	 <L34>
		0000000000000740:  R_AARCH64_CALL26	memcpy
     744: 911383e0     	add	x0, sp, #0x4e0
     748: aa1603e1     	mov	x1, x22
     74c: 94000063     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     750: f94277f8     	ldr	x24, [sp, #0x4e8]
     754: f94273f9     	ldr	x25, [sp, #0x4e0]
     758: 2a1f03e8     	mov	w8, wzr
     75c: 3916c3ff     	strb	wzr, [sp, #0x5b0]
     760: 14000002     	b	 <L36>
<L35>:
     764: aa1f03f4     	mov	x20, xzr
<L36>:
     768: 52800029     	mov	w9, #0x1                // =1
     76c: 8b2842c0     	add	x0, x22, w8, uxtw
     770: 9105b3e8     	add	x8, sp, #0x16c
     774: cb140135     	sub	x21, x9, x20
     778: 8b140101     	add	x1, x8, x20
     77c: aa1503e2     	mov	x2, x21
<L37>:
     780: 94000000     	bl	 <L37>
		0000000000000780:  R_AARCH64_CALL26	memcpy
     784: 3956c3e8     	ldrb	w8, [sp, #0x5b0]
     788: b1000729     	adds	x9, x25, #0x1
     78c: 911383e0     	add	x0, sp, #0x4e0
     790: 9a98370a     	cinc	x10, x24, hs
     794: d10243a1     	sub	x1, x29, #0x90
     798: f90273e9     	str	x9, [sp, #0x4e0]
     79c: 0b150108     	add	w8, w8, w21
     7a0: f90277ea     	str	x10, [sp, #0x4e8]
     7a4: d10243b6     	sub	x22, x29, #0x90
     7a8: 3916c3e8     	strb	w8, [sp, #0x5b0]
     7ac: 9400083c     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     7b0: ad4887e0     	ldp	q0, q1, [sp, #0x110]
     7b4: 910c03e8     	add	x8, sp, #0x300
     7b8: 910c03e0     	add	x0, sp, #0x300
     7bc: 91038261     	add	x1, x19, #0xe0
     7c0: 91014114     	add	x20, x8, #0x50
     7c4: ad1d03e1     	stp	q1, q0, [sp, #0x3a0]
     7c8: ad4787e0     	ldp	q0, q1, [sp, #0xf0]
     7cc: ad1e03e1     	stp	q1, q0, [sp, #0x3c0]
     7d0: ad4687e0     	ldp	q0, q1, [sp, #0xd0]
     7d4: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     7d8: ad4587e0     	ldp	q0, q1, [sp, #0xb0]
     7dc: ad1c03e1     	stp	q1, q0, [sp, #0x380]
     7e0: ad4487e0     	ldp	q0, q1, [sp, #0x90]
     7e4: ad1903e1     	stp	q1, q0, [sp, #0x320]
     7e8: ad4387e0     	ldp	q0, q1, [sp, #0x70]
     7ec: ad1a03e1     	stp	q1, q0, [sp, #0x340]
     7f0: ad4287e0     	ldp	q0, q1, [sp, #0x50]
     7f4: ad1803e1     	stp	q1, q0, [sp, #0x300]
     7f8: 94000038     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     7fc: f94183e9     	ldr	x9, [sp, #0x300]
     800: f94187ea     	ldr	x10, [sp, #0x308]
     804: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     808: b1020138     	adds	x24, x9, #0x80
     80c: 9a8a3553     	cinc	x19, x10, hs
     810: f90183f8     	str	x24, [sp, #0x300]
     814: f90187f3     	str	x19, [sp, #0x308]
     818: 34000228     	cbz	w8,  <L39>
     81c: 7101411f     	cmp	w8, #0x50
     820: 540001e3     	b.lo	 <L39>
     824: 52801009     	mov	w9, #0x80               // =128
     828: 8b080280     	add	x0, x20, x8
     82c: d10243a1     	sub	x1, x29, #0x90
     830: cb080135     	sub	x21, x9, x8
     834: aa1503e2     	mov	x2, x21
<L38>:
     838: 94000000     	bl	 <L38>
		0000000000000838:  R_AARCH64_CALL26	memcpy
     83c: 910c03e0     	add	x0, sp, #0x300
     840: aa1403e1     	mov	x1, x20
     844: 94000025     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     848: f94187f3     	ldr	x19, [sp, #0x308]
     84c: f94183f8     	ldr	x24, [sp, #0x300]
     850: 2a1f03e8     	mov	w8, wzr
     854: 390f43ff     	strb	wzr, [sp, #0x3d0]
     858: 14000002     	b	 <L40>
<L39>:
     85c: aa1f03f5     	mov	x21, xzr
<L40>:
     860: 52800609     	mov	w9, #0x30               // =48
     864: 8b284280     	add	x0, x20, w8, uxtw
     868: 8b1502c1     	add	x1, x22, x21
     86c: cb150134     	sub	x20, x9, x21
     870: aa1403e2     	mov	x2, x20
<L41>:
     874: 94000000     	bl	 <L41>
		0000000000000874:  R_AARCH64_CALL26	memcpy
     878: 394f43e8     	ldrb	w8, [sp, #0x3d0]
     87c: b100c309     	adds	x9, x24, #0x30
     880: 910c03e0     	add	x0, sp, #0x300
     884: 9a93366a     	cinc	x10, x19, hs
     888: 910b43e1     	add	x1, sp, #0x2d0
     88c: f90183e9     	str	x9, [sp, #0x300]
     890: 0b140108     	add	w8, w8, w20
     894: f90187ea     	str	x10, [sp, #0x308]
     898: 390f43e8     	strb	w8, [sp, #0x3d0]
     89c: 94000800     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     8a0: f9401be8     	ldr	x8, [sp, #0x30]
     8a4: f94003e9     	ldr	x9, [sp]
     8a8: 910b43e1     	add	x1, sp, #0x2d0
     8ac: aa1703e2     	mov	x2, x23
     8b0: 8b090100     	add	x0, x8, x9
<L42>:
     8b4: 94000000     	bl	 <L42>
		00000000000008b4:  R_AARCH64_CALL26	memcpy
<L43>:
     8b8: 911b43ff     	add	sp, sp, #0x6d0
     8bc: a9454ff4     	ldp	x20, x19, [sp, #0x50]
     8c0: a94457f6     	ldp	x22, x21, [sp, #0x40]
     8c4: a9435ff8     	ldp	x24, x23, [sp, #0x30]
     8c8: a94267fa     	ldp	x26, x25, [sp, #0x20]
     8cc: a9416ffc     	ldp	x28, x27, [sp, #0x10]
     8d0: a8c67bfd     	ldp	x29, x30, [sp], #0x60
     8d4: d65f03c0     	ret

00000000000008d8 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
     8d8: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
     8dc: f9000bf5     	str	x21, [sp, #0x10]
     8e0: a9024ff4     	stp	x20, x19, [sp, #0x20]
     8e4: 910003fd     	mov	x29, sp
     8e8: d10a03ff     	sub	sp, sp, #0x280
     8ec: ad400420     	ldp	q0, q1, [x1]
     8f0: 910003e8     	mov	x8, sp
     8f4: ad410c22     	ldp	q2, q3, [x1, #0x20]
     8f8: 91020108     	add	x8, x8, #0x80
     8fc: ad421424     	ldp	q4, q5, [x1, #0x40]
     900: 52800809     	mov	w9, #0x40               // =64
     904: 4e200800     	rev64	v0.16b, v0.16b
     908: 4e200821     	rev64	v1.16b, v1.16b
     90c: 4e200842     	rev64	v2.16b, v2.16b
     910: 4e200863     	rev64	v3.16b, v3.16b
     914: 4e200884     	rev64	v4.16b, v4.16b
     918: 4e2008a5     	rev64	v5.16b, v5.16b
     91c: ad0007e0     	stp	q0, q1, [sp]
     920: ad430426     	ldp	q6, q1, [x1, #0x60]
     924: ad010fe2     	stp	q2, q3, [sp, #0x20]
     928: ad0217e4     	stp	q4, q5, [sp, #0x40]
     92c: 4e2008c6     	rev64	v6.16b, v6.16b
     930: 4e200821     	rev64	v1.16b, v1.16b
     934: ad0307e6     	stp	q6, q1, [sp, #0x60]
<L0>:
     938: a978290e     	ldp	x14, x10, [x8, #-0x80]
     93c: f1000529     	subs	x9, x9, #0x1
     940: f85f010b     	ldur	x11, [x8, #-0x10]
     944: f85c810f     	ldur	x15, [x8, #-0x38]
     948: 93ca054c     	ror	x12, x10, #0x1
     94c: 93cb4d6d     	ror	x13, x11, #0x13
     950: caca218c     	eor	x12, x12, x10, ror #8
     954: cacbf5ad     	eor	x13, x13, x11, ror #61
     958: ca4a1d8a     	eor	x10, x12, x10, lsr #7
     95c: 8b0e01ec     	add	x12, x15, x14
     960: ca4b19ab     	eor	x11, x13, x11, lsr #6
     964: 8b0a018a     	add	x10, x12, x10
     968: 8b0b014a     	add	x10, x10, x11
     96c: f800850a     	str	x10, [x8], #0x8
     970: 54fffe41     	b.ne	 <L0>
     974: a942a40c     	ldp	x12, x9, [x0, #0x28]
     978: 9e66000d     	fmov	x13, d0
     97c: a9430c11     	ldp	x17, x3, [x0, #0x30]
     980: a943840f     	ldp	x15, x1, [x0, #0x38]
     984: 93c9392e     	ror	x14, x9, #0xe
     988: a9412808     	ldp	x8, x10, [x0, #0x10]
     98c: 8a090065     	and	x5, x3, x9
     990: a942400b     	ldp	x11, x16, [x0, #0x20]
     994: cac949d2     	eor	x18, x14, x9, ror #18
     998: a944080e     	ldp	x14, x2, [x0, #0x40]
     99c: 8a290024     	bic	x4, x1, x9
     9a0: 93c87106     	ror	x6, x8, #0x1c
     9a4: cac9a652     	eor	x18, x18, x9, ror #41
     9a8: 8b0d004d     	add	x13, x2, x13
     9ac: aa0400a2     	orr	x2, x5, x4
     9b0: cac888c4     	eor	x4, x6, x8, ror #34
     9b4: 8b0201ad     	add	x13, x13, x2
     9b8: d295c442     	mov	x2, #0xae22             // =44578
     9bc: aa0a0165     	orr	x5, x11, x10
     9c0: f2bae502     	movk	x2, #0xd728, lsl #16
     9c4: cac89c84     	eor	x4, x4, x8, ror #39
     9c8: 8a0800a5     	and	x5, x5, x8
     9cc: f2c5f302     	movk	x2, #0x2f98, lsl #32
     9d0: 8a0a0166     	and	x6, x11, x10
     9d4: f2e85142     	movk	x2, #0x428a, lsl #48
     9d8: aa0600a5     	orr	x5, x5, x6
     9dc: 8b0201a2     	add	x2, x13, x2
     9e0: 8b020247     	add	x7, x18, x2
     9e4: a941c80d     	ldp	x13, x18, [x0, #0x18]
     9e8: 8b0c00e2     	add	x2, x7, x12
     9ec: 8b0400ac     	add	x12, x5, x4
     9f0: f94007e4     	ldr	x4, [sp, #0x8]
     9f4: 8b07018c     	add	x12, x12, x7
     9f8: 93c23845     	ror	x5, x2, #0xe
     9fc: 8a220066     	bic	x6, x3, x2
     a00: 8b040021     	add	x1, x1, x4
     a04: d28cb9a4     	mov	x4, #0x65cd             // =26061
     a08: 8a020127     	and	x7, x9, x2
     a0c: 93cc7193     	ror	x19, x12, #0x1c
     a10: f2a47de4     	movk	x4, #0x23ef, lsl #16
     a14: cac248a5     	eor	x5, x5, x2, ror #18
     a18: aa0600e6     	orr	x6, x7, x6
     a1c: f2c89224     	movk	x4, #0x4491, lsl #32
     a20: 8a080147     	and	x7, x10, x8
     a24: 8b060021     	add	x1, x1, x6
     a28: f2ee26e4     	movk	x4, #0x7137, lsl #48
     a2c: cacc8a66     	eor	x6, x19, x12, ror #34
     a30: cac2a4a5     	eor	x5, x5, x2, ror #41
     a34: 8b040021     	add	x1, x1, x4
     a38: aa080144     	orr	x4, x10, x8
     a3c: cacc9cc6     	eor	x6, x6, x12, ror #39
     a40: 8a040184     	and	x4, x12, x4
     a44: 8b050025     	add	x5, x1, x5
     a48: aa070084     	orr	x4, x4, x7
     a4c: 8b0b00a1     	add	x1, x5, x11
     a50: 8b0400cb     	add	x11, x6, x4
     a54: f9400be4     	ldr	x4, [sp, #0x10]
     a58: 8b05016b     	add	x11, x11, x5
     a5c: 8a210126     	bic	x6, x9, x1
     a60: 8a010047     	and	x7, x2, x1
     a64: 93c13825     	ror	x5, x1, #0xe
     a68: 93cb7173     	ror	x19, x11, #0x1c
     a6c: aa0600e6     	orr	x6, x7, x6
     a70: 8b040063     	add	x3, x3, x4
     a74: aa080187     	orr	x7, x12, x8
     a78: 8b060063     	add	x3, x3, x6
     a7c: d28765e6     	mov	x6, #0x3b2f             // =15151
     a80: cac148a5     	eor	x5, x5, x1, ror #18
     a84: cacb8a64     	eor	x4, x19, x11, ror #34
     a88: f2bd89a6     	movk	x6, #0xec4d, lsl #16
     a8c: 8a070167     	and	x7, x11, x7
     a90: f2df79e6     	movk	x6, #0xfbcf, lsl #32
     a94: cac1a4a5     	eor	x5, x5, x1, ror #41
     a98: 8a080193     	and	x19, x12, x8
     a9c: f2f6b806     	movk	x6, #0xb5c0, lsl #48
     aa0: cacb9c84     	eor	x4, x4, x11, ror #39
     aa4: 8b060063     	add	x3, x3, x6
     aa8: aa1300e6     	orr	x6, x7, x19
     aac: 8b050063     	add	x3, x3, x5
     ab0: 8b060085     	add	x5, x4, x6
     ab4: a941cfe6     	ldp	x6, x19, [sp, #0x18]
     ab8: 8b0a0064     	add	x4, x3, x10
     abc: 8b0300aa     	add	x10, x5, x3
     ac0: 8a240045     	bic	x5, x2, x4
     ac4: 8a040027     	and	x7, x1, x4
     ac8: aa0500e5     	orr	x5, x7, x5
     acc: 93c43883     	ror	x3, x4, #0xe
     ad0: 93ca7147     	ror	x7, x10, #0x1c
     ad4: 8b060129     	add	x9, x9, x6
     ad8: 8b020262     	add	x2, x19, x2
     adc: aa0b0155     	orr	x21, x10, x11
     ae0: 8b050129     	add	x9, x9, x5
     ae4: d29b7785     	mov	x5, #0xdbbc             // =56252
     ae8: cac44863     	eor	x3, x3, x4, ror #18
     aec: f2b03125     	movk	x5, #0x8189, lsl #16
     af0: caca88e6     	eor	x6, x7, x10, ror #34
     af4: 8a0c0167     	and	x7, x11, x12
     af8: f2db74a5     	movk	x5, #0xdba5, lsl #32
     afc: cac4a463     	eor	x3, x3, x4, ror #41
     b00: f2fd36a5     	movk	x5, #0xe9b5, lsl #48
     b04: caca9cc6     	eor	x6, x6, x10, ror #39
     b08: 8b050129     	add	x9, x9, x5
     b0c: aa0c0165     	orr	x5, x11, x12
     b10: 8a050145     	and	x5, x10, x5
     b14: 8b030129     	add	x9, x9, x3
     b18: aa0700a3     	orr	x3, x5, x7
     b1c: 8b0300c5     	add	x5, x6, x3
     b20: 8b080123     	add	x3, x9, x8
     b24: d296a706     	mov	x6, #0xb538             // =46392
     b28: 8b0900a9     	add	x9, x5, x9
     b2c: 93c33865     	ror	x5, x3, #0xe
     b30: f2be6906     	movk	x6, #0xf348, lsl #16
     b34: 93c97127     	ror	x7, x9, #0x1c
     b38: 8a230033     	bic	x19, x1, x3
     b3c: 8a030094     	and	x20, x4, x3
     b40: f2d84b66     	movk	x6, #0xc25b, lsl #32
     b44: cac348a5     	eor	x5, x5, x3, ror #18
     b48: aa130293     	orr	x19, x20, x19
     b4c: cac988e7     	eor	x7, x7, x9, ror #34
     b50: f2e72ac6     	movk	x6, #0x3956, lsl #48
     b54: 8b130042     	add	x2, x2, x19
     b58: 8a0b0154     	and	x20, x10, x11
     b5c: cac3a4a5     	eor	x5, x5, x3, ror #41
     b60: 8a150133     	and	x19, x9, x21
     b64: 8b060042     	add	x2, x2, x6
     b68: cac99ce6     	eor	x6, x7, x9, ror #39
     b6c: aa140267     	orr	x7, x19, x20
     b70: 8b050042     	add	x2, x2, x5
     b74: 8b0700c6     	add	x6, x6, x7
     b78: 8b0c0045     	add	x5, x2, x12
     b7c: d29a0327     	mov	x7, #0xd019             // =53273
     b80: 8b0200cc     	add	x12, x6, x2
     b84: a9429bf3     	ldp	x19, x6, [sp, #0x28]
     b88: 93c538a2     	ror	x2, x5, #0xe
     b8c: f2b6c0a7     	movk	x7, #0xb605, lsl #16
     b90: 8a250094     	bic	x20, x4, x5
     b94: 8a050075     	and	x21, x3, x5
     b98: f2c23e27     	movk	x7, #0x11f1, lsl #32
     b9c: 8b010261     	add	x1, x19, x1
     ba0: 93cc7193     	ror	x19, x12, #0x1c
     ba4: cac54842     	eor	x2, x2, x5, ror #18
     ba8: aa1402b4     	orr	x20, x21, x20
     bac: f2eb3e27     	movk	x7, #0x59f1, lsl #48
     bb0: aa0a0135     	orr	x21, x9, x10
     bb4: cacc8a73     	eor	x19, x19, x12, ror #34
     bb8: 8b140021     	add	x1, x1, x20
     bbc: 8a0a0134     	and	x20, x9, x10
     bc0: cac5a442     	eor	x2, x2, x5, ror #41
     bc4: 8a150195     	and	x21, x12, x21
     bc8: 8b070021     	add	x1, x1, x7
     bcc: cacc9e67     	eor	x7, x19, x12, ror #39
     bd0: aa1402b3     	orr	x19, x21, x20
     bd4: 8b0400c4     	add	x4, x6, x4
     bd8: 8b020021     	add	x1, x1, x2
     bdc: aa090195     	orr	x21, x12, x9
     be0: 8b1300e7     	add	x7, x7, x19
     be4: 8b0b0022     	add	x2, x1, x11
     be8: 8b0100eb     	add	x11, x7, x1
     bec: 93c23841     	ror	x1, x2, #0xe
     bf0: d289f367     	mov	x7, #0x4f9b             // =20379
     bf4: 93cb7166     	ror	x6, x11, #0x1c
     bf8: f2b5e327     	movk	x7, #0xaf19, lsl #16
     bfc: 8a220073     	bic	x19, x3, x2
     c00: 8a0200b4     	and	x20, x5, x2
     c04: f2d05487     	movk	x7, #0x82a4, lsl #32
     c08: cac24821     	eor	x1, x1, x2, ror #18
     c0c: cacb88c6     	eor	x6, x6, x11, ror #34
     c10: aa130293     	orr	x19, x20, x19
     c14: f2f247e7     	movk	x7, #0x923f, lsl #48
     c18: 8a090194     	and	x20, x12, x9
     c1c: 8b130084     	add	x4, x4, x19
     c20: 8a150173     	and	x19, x11, x21
     c24: cacb9cc6     	eor	x6, x6, x11, ror #39
     c28: cac2a421     	eor	x1, x1, x2, ror #41
     c2c: 8b070084     	add	x4, x4, x7
     c30: aa140267     	orr	x7, x19, x20
     c34: 8b0700c6     	add	x6, x6, x7
     c38: a9439ff3     	ldp	x19, x7, [sp, #0x38]
     c3c: 8b010081     	add	x1, x4, x1
     c40: 8b0a0024     	add	x4, x1, x10
     c44: 8b0100c1     	add	x1, x6, x1
     c48: d290230a     	mov	x10, #0x8118            // =33048
     c4c: 93c43886     	ror	x6, x4, #0xe
     c50: 8b030263     	add	x3, x19, x3
     c54: 93c17033     	ror	x19, x1, #0x1c
     c58: f2bb4daa     	movk	x10, #0xda6d, lsl #16
     c5c: 8a2400b4     	bic	x20, x5, x4
     c60: 8a040055     	and	x21, x2, x4
     c64: f2cbdaaa     	movk	x10, #0x5ed5, lsl #32
     c68: cac448c6     	eor	x6, x6, x4, ror #18
     c6c: aa1402b4     	orr	x20, x21, x20
     c70: cac18a73     	eor	x19, x19, x1, ror #34
     c74: f2f5638a     	movk	x10, #0xab1c, lsl #48
     c78: aa0c0175     	orr	x21, x11, x12
     c7c: 8b140063     	add	x3, x3, x20
     c80: 8a0c0174     	and	x20, x11, x12
     c84: cac4a4c6     	eor	x6, x6, x4, ror #41
     c88: 8a150035     	and	x21, x1, x21
     c8c: 8b0a006a     	add	x10, x3, x10
     c90: cac19e63     	eor	x3, x19, x1, ror #39
     c94: aa1402b3     	orr	x19, x21, x20
     c98: 8b06014a     	add	x10, x10, x6
     c9c: 8b0500e5     	add	x5, x7, x5
     ca0: 8b130066     	add	x6, x3, x19
     ca4: 8b090143     	add	x3, x10, x9
     ca8: aa0b0035     	orr	x21, x1, x11
     cac: 8b0a00c9     	add	x9, x6, x10
     cb0: 93c3386a     	ror	x10, x3, #0xe
     cb4: d2804846     	mov	x6, #0x242              // =578
     cb8: 93c97127     	ror	x7, x9, #0x1c
     cbc: f2b46066     	movk	x6, #0xa303, lsl #16
     cc0: 8a230053     	bic	x19, x2, x3
     cc4: 8a030094     	and	x20, x4, x3
     cc8: f2d55306     	movk	x6, #0xaa98, lsl #32
     ccc: cac3494a     	eor	x10, x10, x3, ror #18
     cd0: aa130293     	orr	x19, x20, x19
     cd4: cac988e7     	eor	x7, x7, x9, ror #34
     cd8: f2fb00e6     	movk	x6, #0xd807, lsl #48
     cdc: 8b1300a5     	add	x5, x5, x19
     ce0: 8a0b0034     	and	x20, x1, x11
     ce4: cac3a54a     	eor	x10, x10, x3, ror #41
     ce8: 8a150133     	and	x19, x9, x21
     cec: 8b0600a5     	add	x5, x5, x6
     cf0: cac99ce6     	eor	x6, x7, x9, ror #39
     cf4: aa140267     	orr	x7, x19, x20
     cf8: 8b0a00aa     	add	x10, x5, x10
     cfc: 8b0700c6     	add	x6, x6, x7
     d00: 8b0c0145     	add	x5, x10, x12
     d04: d28df7c7     	mov	x7, #0x6fbe             // =28606
     d08: 8b0a00cc     	add	x12, x6, x10
     d0c: a9449bf3     	ldp	x19, x6, [sp, #0x48]
     d10: 93c538aa     	ror	x10, x5, #0xe
     d14: f2a8ae07     	movk	x7, #0x4570, lsl #16
     d18: 8a250094     	bic	x20, x4, x5
     d1c: 8a050075     	and	x21, x3, x5
     d20: f2cb6027     	movk	x7, #0x5b01, lsl #32
     d24: 8b020262     	add	x2, x19, x2
     d28: 93cc7193     	ror	x19, x12, #0x1c
     d2c: cac5494a     	eor	x10, x10, x5, ror #18
     d30: aa1402b4     	orr	x20, x21, x20
     d34: f2e25067     	movk	x7, #0x1283, lsl #48
     d38: aa010135     	orr	x21, x9, x1
     d3c: cacc8a73     	eor	x19, x19, x12, ror #34
     d40: 8b140042     	add	x2, x2, x20
     d44: 8a010134     	and	x20, x9, x1
     d48: cac5a54a     	eor	x10, x10, x5, ror #41
     d4c: 8a150195     	and	x21, x12, x21
     d50: 8b070042     	add	x2, x2, x7
     d54: cacc9e67     	eor	x7, x19, x12, ror #39
     d58: aa1402b3     	orr	x19, x21, x20
     d5c: 8b0400c4     	add	x4, x6, x4
     d60: 8b0a004a     	add	x10, x2, x10
     d64: aa090195     	orr	x21, x12, x9
     d68: 8b1300e7     	add	x7, x7, x19
     d6c: 8b0b0142     	add	x2, x10, x11
     d70: 8b0a00ea     	add	x10, x7, x10
     d74: 93c2384b     	ror	x11, x2, #0xe
     d78: d2965187     	mov	x7, #0xb28c             // =45708
     d7c: 93ca7146     	ror	x6, x10, #0x1c
     d80: f2a9dc87     	movk	x7, #0x4ee4, lsl #16
     d84: 8a220073     	bic	x19, x3, x2
     d88: 8a0200b4     	and	x20, x5, x2
     d8c: f2d0b7c7     	movk	x7, #0x85be, lsl #32
     d90: cac2496b     	eor	x11, x11, x2, ror #18
     d94: caca88c6     	eor	x6, x6, x10, ror #34
     d98: aa130293     	orr	x19, x20, x19
     d9c: f2e48627     	movk	x7, #0x2431, lsl #48
     da0: 8a090194     	and	x20, x12, x9
     da4: 8b130084     	add	x4, x4, x19
     da8: 8a150153     	and	x19, x10, x21
     dac: caca9cc6     	eor	x6, x6, x10, ror #39
     db0: cac2a56b     	eor	x11, x11, x2, ror #41
     db4: 8b070084     	add	x4, x4, x7
     db8: aa140267     	orr	x7, x19, x20
     dbc: 8b0700c6     	add	x6, x6, x7
     dc0: a9459ff3     	ldp	x19, x7, [sp, #0x58]
     dc4: 8b0b008b     	add	x11, x4, x11
     dc8: 8b010164     	add	x4, x11, x1
     dcc: 8b0b00cb     	add	x11, x6, x11
     dd0: d2969c41     	mov	x1, #0xb4e2             // =46306
     dd4: 93c43886     	ror	x6, x4, #0xe
     dd8: 8b030263     	add	x3, x19, x3
     ddc: 93cb7173     	ror	x19, x11, #0x1c
     de0: f2babfe1     	movk	x1, #0xd5ff, lsl #16
     de4: 8a2400b4     	bic	x20, x5, x4
     de8: 8a040055     	and	x21, x2, x4
     dec: f2cfb861     	movk	x1, #0x7dc3, lsl #32
     df0: cac448c6     	eor	x6, x6, x4, ror #18
     df4: aa1402b4     	orr	x20, x21, x20
     df8: cacb8a73     	eor	x19, x19, x11, ror #34
     dfc: f2eaa181     	movk	x1, #0x550c, lsl #48
     e00: aa0c0155     	orr	x21, x10, x12
     e04: 8b140063     	add	x3, x3, x20
     e08: 8a0c0154     	and	x20, x10, x12
     e0c: cac4a4c6     	eor	x6, x6, x4, ror #41
     e10: 8a150175     	and	x21, x11, x21
     e14: 8b010061     	add	x1, x3, x1
     e18: cacb9e63     	eor	x3, x19, x11, ror #39
     e1c: aa1402b3     	orr	x19, x21, x20
     e20: 8b060026     	add	x6, x1, x6
     e24: 8b0500e5     	add	x5, x7, x5
     e28: 8b130063     	add	x3, x3, x19
     e2c: 8b0900c1     	add	x1, x6, x9
     e30: aa0a0175     	orr	x21, x11, x10
     e34: 8b060069     	add	x9, x3, x6
     e38: 93c13823     	ror	x3, x1, #0xe
     e3c: d2912de6     	mov	x6, #0x896f             // =35183
     e40: 93c97127     	ror	x7, x9, #0x1c
     e44: f2be4f66     	movk	x6, #0xf27b, lsl #16
     e48: 8a210053     	bic	x19, x2, x1
     e4c: 8a010094     	and	x20, x4, x1
     e50: f2cbae86     	movk	x6, #0x5d74, lsl #32
     e54: cac14863     	eor	x3, x3, x1, ror #18
     e58: aa130293     	orr	x19, x20, x19
     e5c: cac988e7     	eor	x7, x7, x9, ror #34
     e60: f2ee57c6     	movk	x6, #0x72be, lsl #48
     e64: 8b1300a5     	add	x5, x5, x19
     e68: 8a0a0174     	and	x20, x11, x10
     e6c: cac1a463     	eor	x3, x3, x1, ror #41
     e70: 8a150133     	and	x19, x9, x21
     e74: 8b0600a5     	add	x5, x5, x6
     e78: cac99ce6     	eor	x6, x7, x9, ror #39
     e7c: aa140267     	orr	x7, x19, x20
     e80: 8b0300a5     	add	x5, x5, x3
     e84: 8b0700c6     	add	x6, x6, x7
     e88: 8b0c00a3     	add	x3, x5, x12
     e8c: d292d627     	mov	x7, #0x96b1             // =38577
     e90: 8b0500cc     	add	x12, x6, x5
     e94: a9469bf3     	ldp	x19, x6, [sp, #0x68]
     e98: 93c33865     	ror	x5, x3, #0xe
     e9c: f2a762c7     	movk	x7, #0x3b16, lsl #16
     ea0: 8a230094     	bic	x20, x4, x3
     ea4: 8a030035     	and	x21, x1, x3
     ea8: f2d63fc7     	movk	x7, #0xb1fe, lsl #32
     eac: 8b020262     	add	x2, x19, x2
     eb0: 93cc7193     	ror	x19, x12, #0x1c
     eb4: cac348a5     	eor	x5, x5, x3, ror #18
     eb8: aa1402b4     	orr	x20, x21, x20
     ebc: f2f01bc7     	movk	x7, #0x80de, lsl #48
     ec0: aa0b0135     	orr	x21, x9, x11
     ec4: cacc8a73     	eor	x19, x19, x12, ror #34
     ec8: 8b140042     	add	x2, x2, x20
     ecc: 8a0b0134     	and	x20, x9, x11
     ed0: cac3a4a5     	eor	x5, x5, x3, ror #41
     ed4: 8a150195     	and	x21, x12, x21
     ed8: 8b070042     	add	x2, x2, x7
     edc: cacc9e67     	eor	x7, x19, x12, ror #39
     ee0: aa1402b3     	orr	x19, x21, x20
     ee4: 8b0400c4     	add	x4, x6, x4
     ee8: 8b050045     	add	x5, x2, x5
     eec: aa090195     	orr	x21, x12, x9
     ef0: 8b1300e7     	add	x7, x7, x19
     ef4: 8b0a00a2     	add	x2, x5, x10
     ef8: 8b0500ea     	add	x10, x7, x5
     efc: 93c23845     	ror	x5, x2, #0xe
     f00: d28246a7     	mov	x7, #0x1235             // =4661
     f04: 93ca7146     	ror	x6, x10, #0x1c
     f08: f2a4b8e7     	movk	x7, #0x25c7, lsl #16
     f0c: 8a220033     	bic	x19, x1, x2
     f10: 8a020074     	and	x20, x3, x2
     f14: cac248a5     	eor	x5, x5, x2, ror #18
     f18: f2c0d4e7     	movk	x7, #0x6a7, lsl #32
     f1c: caca88c6     	eor	x6, x6, x10, ror #34
     f20: aa130293     	orr	x19, x20, x19
     f24: f2f37b87     	movk	x7, #0x9bdc, lsl #48
     f28: 8a090194     	and	x20, x12, x9
     f2c: 8b130084     	add	x4, x4, x19
     f30: cac2a4a5     	eor	x5, x5, x2, ror #41
     f34: 8a150153     	and	x19, x10, x21
     f38: caca9cc6     	eor	x6, x6, x10, ror #39
     f3c: 8b070084     	add	x4, x4, x7
     f40: aa140267     	orr	x7, x19, x20
     f44: 8b050085     	add	x5, x4, x5
     f48: 8b0700c6     	add	x6, x6, x7
     f4c: 8b0b00a4     	add	x4, x5, x11
     f50: d284d287     	mov	x7, #0x2694             // =9876
     f54: 8b0500cb     	add	x11, x6, x5
     f58: a9479bf3     	ldp	x19, x6, [sp, #0x78]
     f5c: 93c43885     	ror	x5, x4, #0xe
     f60: f2b9ed27     	movk	x7, #0xcf69, lsl #16
     f64: 8a240074     	bic	x20, x3, x4
     f68: 8a040055     	and	x21, x2, x4
     f6c: f2de2e87     	movk	x7, #0xf174, lsl #32
     f70: 8b010261     	add	x1, x19, x1
     f74: 93cb7173     	ror	x19, x11, #0x1c
     f78: cac448a5     	eor	x5, x5, x4, ror #18
     f7c: aa1402b4     	orr	x20, x21, x20
     f80: f2f83367     	movk	x7, #0xc19b, lsl #48
     f84: aa0c0155     	orr	x21, x10, x12
     f88: cacb8a73     	eor	x19, x19, x11, ror #34
     f8c: 8b140021     	add	x1, x1, x20
     f90: 8a0c0154     	and	x20, x10, x12
     f94: cac4a4a5     	eor	x5, x5, x4, ror #41
     f98: 8a150175     	and	x21, x11, x21
     f9c: 8b070021     	add	x1, x1, x7
     fa0: cacb9e67     	eor	x7, x19, x11, ror #39
     fa4: aa1402b3     	orr	x19, x21, x20
     fa8: 8b0300c3     	add	x3, x6, x3
     fac: 8b050025     	add	x5, x1, x5
     fb0: aa0a0175     	orr	x21, x11, x10
     fb4: 8b1300e7     	add	x7, x7, x19
     fb8: 8b0900a1     	add	x1, x5, x9
     fbc: 8b0500e9     	add	x9, x7, x5
     fc0: 93c13825     	ror	x5, x1, #0xe
     fc4: d2895a47     	mov	x7, #0x4ad2             // =19154
     fc8: 93c97126     	ror	x6, x9, #0x1c
     fcc: f2b3de27     	movk	x7, #0x9ef1, lsl #16
     fd0: 8a210053     	bic	x19, x2, x1
     fd4: 8a010094     	and	x20, x4, x1
     fd8: cac148a5     	eor	x5, x5, x1, ror #18
     fdc: f2cd3827     	movk	x7, #0x69c1, lsl #32
     fe0: cac988c6     	eor	x6, x6, x9, ror #34
     fe4: aa130293     	orr	x19, x20, x19
     fe8: f2fc9367     	movk	x7, #0xe49b, lsl #48
     fec: 8a0a0174     	and	x20, x11, x10
     ff0: 8b130063     	add	x3, x3, x19
     ff4: cac1a4a5     	eor	x5, x5, x1, ror #41
     ff8: 8a150133     	and	x19, x9, x21
     ffc: cac99cc6     	eor	x6, x6, x9, ror #39
    1000: 8b070063     	add	x3, x3, x7
    1004: aa140267     	orr	x7, x19, x20
    1008: 8b050065     	add	x5, x3, x5
    100c: 8b0700c6     	add	x6, x6, x7
    1010: 8b0c00a3     	add	x3, x5, x12
    1014: d284bc67     	mov	x7, #0x25e3             // =9699
    1018: 8b0500cc     	add	x12, x6, x5
    101c: a9489bf3     	ldp	x19, x6, [sp, #0x88]
    1020: 93c33865     	ror	x5, x3, #0xe
    1024: f2a709e7     	movk	x7, #0x384f, lsl #16
    1028: 8a230094     	bic	x20, x4, x3
    102c: 8a030035     	and	x21, x1, x3
    1030: f2c8f0c7     	movk	x7, #0x4786, lsl #32
    1034: 8b020262     	add	x2, x19, x2
    1038: 93cc7193     	ror	x19, x12, #0x1c
    103c: cac348a5     	eor	x5, x5, x3, ror #18
    1040: aa1402b4     	orr	x20, x21, x20
    1044: f2fdf7c7     	movk	x7, #0xefbe, lsl #48
    1048: aa0b0135     	orr	x21, x9, x11
    104c: cacc8a73     	eor	x19, x19, x12, ror #34
    1050: 8b140042     	add	x2, x2, x20
    1054: 8a0b0134     	and	x20, x9, x11
    1058: cac3a4a5     	eor	x5, x5, x3, ror #41
    105c: 8a150195     	and	x21, x12, x21
    1060: 8b070042     	add	x2, x2, x7
    1064: cacc9e67     	eor	x7, x19, x12, ror #39
    1068: aa1402b3     	orr	x19, x21, x20
    106c: 8b0400c4     	add	x4, x6, x4
    1070: 8b050045     	add	x5, x2, x5
    1074: aa090195     	orr	x21, x12, x9
    1078: 8b1300e7     	add	x7, x7, x19
    107c: 8b0a00a2     	add	x2, x5, x10
    1080: 8b0500ea     	add	x10, x7, x5
    1084: 93c23845     	ror	x5, x2, #0xe
    1088: d29ab6a7     	mov	x7, #0xd5b5             // =54709
    108c: 93ca7146     	ror	x6, x10, #0x1c
    1090: f2b17187     	movk	x7, #0x8b8c, lsl #16
    1094: 8a220033     	bic	x19, x1, x2
    1098: 8a020074     	and	x20, x3, x2
    109c: cac248a5     	eor	x5, x5, x2, ror #18
    10a0: f2d3b8c7     	movk	x7, #0x9dc6, lsl #32
    10a4: caca88c6     	eor	x6, x6, x10, ror #34
    10a8: aa130293     	orr	x19, x20, x19
    10ac: f2e1f827     	movk	x7, #0xfc1, lsl #48
    10b0: 8a090194     	and	x20, x12, x9
    10b4: 8b130084     	add	x4, x4, x19
    10b8: cac2a4a5     	eor	x5, x5, x2, ror #41
    10bc: 8a150153     	and	x19, x10, x21
    10c0: caca9cc6     	eor	x6, x6, x10, ror #39
    10c4: 8b070084     	add	x4, x4, x7
    10c8: aa140267     	orr	x7, x19, x20
    10cc: 8b050085     	add	x5, x4, x5
    10d0: 8b0700c6     	add	x6, x6, x7
    10d4: 8b0b00a4     	add	x4, x5, x11
    10d8: d2938ca7     	mov	x7, #0x9c65             // =40037
    10dc: 8b0500cb     	add	x11, x6, x5
    10e0: a9499bf3     	ldp	x19, x6, [sp, #0x98]
    10e4: 93c43885     	ror	x5, x4, #0xe
    10e8: f2aef587     	movk	x7, #0x77ac, lsl #16
    10ec: 8a240074     	bic	x20, x3, x4
    10f0: 8a040055     	and	x21, x2, x4
    10f4: f2d43987     	movk	x7, #0xa1cc, lsl #32
    10f8: 8b010261     	add	x1, x19, x1
    10fc: 93cb7173     	ror	x19, x11, #0x1c
    1100: cac448a5     	eor	x5, x5, x4, ror #18
    1104: aa1402b4     	orr	x20, x21, x20
    1108: f2e48187     	movk	x7, #0x240c, lsl #48
    110c: aa0c0155     	orr	x21, x10, x12
    1110: cacb8a73     	eor	x19, x19, x11, ror #34
    1114: 8b140021     	add	x1, x1, x20
    1118: 8a0c0154     	and	x20, x10, x12
    111c: cac4a4a5     	eor	x5, x5, x4, ror #41
    1120: 8a150175     	and	x21, x11, x21
    1124: 8b070021     	add	x1, x1, x7
    1128: cacb9e67     	eor	x7, x19, x11, ror #39
    112c: aa1402b3     	orr	x19, x21, x20
    1130: 8b0300c3     	add	x3, x6, x3
    1134: 8b050025     	add	x5, x1, x5
    1138: aa0a0175     	orr	x21, x11, x10
    113c: 8b1300e7     	add	x7, x7, x19
    1140: 8b0900a1     	add	x1, x5, x9
    1144: 8b0500e9     	add	x9, x7, x5
    1148: 93c13825     	ror	x5, x1, #0xe
    114c: d2804ea7     	mov	x7, #0x275              // =629
    1150: 93c97126     	ror	x6, x9, #0x1c
    1154: f2ab2567     	movk	x7, #0x592b, lsl #16
    1158: 8a210053     	bic	x19, x2, x1
    115c: 8a010094     	and	x20, x4, x1
    1160: cac148a5     	eor	x5, x5, x1, ror #18
    1164: f2c58de7     	movk	x7, #0x2c6f, lsl #32
    1168: cac988c6     	eor	x6, x6, x9, ror #34
    116c: aa130293     	orr	x19, x20, x19
    1170: f2e5bd27     	movk	x7, #0x2de9, lsl #48
    1174: 8a0a0174     	and	x20, x11, x10
    1178: 8b130063     	add	x3, x3, x19
    117c: cac1a4a5     	eor	x5, x5, x1, ror #41
    1180: 8a150133     	and	x19, x9, x21
    1184: cac99cc6     	eor	x6, x6, x9, ror #39
    1188: 8b070063     	add	x3, x3, x7
    118c: aa140267     	orr	x7, x19, x20
    1190: 8b050065     	add	x5, x3, x5
    1194: 8b0700c6     	add	x6, x6, x7
    1198: 8b0c00a3     	add	x3, x5, x12
    119c: d29c9067     	mov	x7, #0xe483             // =58499
    11a0: 8b0500cc     	add	x12, x6, x5
    11a4: a94a9bf3     	ldp	x19, x6, [sp, #0xa8]
    11a8: 93c33865     	ror	x5, x3, #0xe
    11ac: f2add4c7     	movk	x7, #0x6ea6, lsl #16
    11b0: 8a230094     	bic	x20, x4, x3
    11b4: 8a030035     	and	x21, x1, x3
    11b8: f2d09547     	movk	x7, #0x84aa, lsl #32
    11bc: 8b020262     	add	x2, x19, x2
    11c0: 93cc7193     	ror	x19, x12, #0x1c
    11c4: cac348a5     	eor	x5, x5, x3, ror #18
    11c8: aa1402b4     	orr	x20, x21, x20
    11cc: f2e94e87     	movk	x7, #0x4a74, lsl #48
    11d0: aa0b0135     	orr	x21, x9, x11
    11d4: cacc8a73     	eor	x19, x19, x12, ror #34
    11d8: 8b140042     	add	x2, x2, x20
    11dc: 8a0b0134     	and	x20, x9, x11
    11e0: cac3a4a5     	eor	x5, x5, x3, ror #41
    11e4: 8a150195     	and	x21, x12, x21
    11e8: 8b070042     	add	x2, x2, x7
    11ec: cacc9e67     	eor	x7, x19, x12, ror #39
    11f0: aa1402b3     	orr	x19, x21, x20
    11f4: 8b0400c4     	add	x4, x6, x4
    11f8: 8b050045     	add	x5, x2, x5
    11fc: aa090195     	orr	x21, x12, x9
    1200: 8b1300e7     	add	x7, x7, x19
    1204: 8b0a00a2     	add	x2, x5, x10
    1208: 8b0500ea     	add	x10, x7, x5
    120c: 93c23845     	ror	x5, x2, #0xe
    1210: d29f7a87     	mov	x7, #0xfbd4             // =64468
    1214: 93ca7146     	ror	x6, x10, #0x1c
    1218: f2b7a827     	movk	x7, #0xbd41, lsl #16
    121c: 8a220033     	bic	x19, x1, x2
    1220: 8a020074     	and	x20, x3, x2
    1224: cac248a5     	eor	x5, x5, x2, ror #18
    1228: f2d53b87     	movk	x7, #0xa9dc, lsl #32
    122c: caca88c6     	eor	x6, x6, x10, ror #34
    1230: aa130293     	orr	x19, x20, x19
    1234: f2eb9607     	movk	x7, #0x5cb0, lsl #48
    1238: 8a090194     	and	x20, x12, x9
    123c: 8b130084     	add	x4, x4, x19
    1240: cac2a4a5     	eor	x5, x5, x2, ror #41
    1244: 8a150153     	and	x19, x10, x21
    1248: caca9cc6     	eor	x6, x6, x10, ror #39
    124c: 8b070084     	add	x4, x4, x7
    1250: aa140267     	orr	x7, x19, x20
    1254: 8b050085     	add	x5, x4, x5
    1258: 8b0700c6     	add	x6, x6, x7
    125c: 8b0b00a4     	add	x4, x5, x11
    1260: d28a76a7     	mov	x7, #0x53b5             // =21429
    1264: 8b0500cb     	add	x11, x6, x5
    1268: a94b9bf3     	ldp	x19, x6, [sp, #0xb8]
    126c: 93c43885     	ror	x5, x4, #0xe
    1270: f2b06227     	movk	x7, #0x8311, lsl #16
    1274: 8a240074     	bic	x20, x3, x4
    1278: 8a040055     	and	x21, x2, x4
    127c: f2d11b47     	movk	x7, #0x88da, lsl #32
    1280: 8b010261     	add	x1, x19, x1
    1284: 93cb7173     	ror	x19, x11, #0x1c
    1288: cac448a5     	eor	x5, x5, x4, ror #18
    128c: aa1402b4     	orr	x20, x21, x20
    1290: f2eedf27     	movk	x7, #0x76f9, lsl #48
    1294: aa0c0155     	orr	x21, x10, x12
    1298: cacb8a73     	eor	x19, x19, x11, ror #34
    129c: 8b140021     	add	x1, x1, x20
    12a0: 8a0c0154     	and	x20, x10, x12
    12a4: cac4a4a5     	eor	x5, x5, x4, ror #41
    12a8: 8a150175     	and	x21, x11, x21
    12ac: 8b070021     	add	x1, x1, x7
    12b0: cacb9e67     	eor	x7, x19, x11, ror #39
    12b4: aa1402b3     	orr	x19, x21, x20
    12b8: 8b0300c3     	add	x3, x6, x3
    12bc: 8b050025     	add	x5, x1, x5
    12c0: aa0a0175     	orr	x21, x11, x10
    12c4: 8b1300e7     	add	x7, x7, x19
    12c8: 8b0900a1     	add	x1, x5, x9
    12cc: 8b0500e9     	add	x9, x7, x5
    12d0: 93c13825     	ror	x5, x1, #0xe
    12d4: d29bf567     	mov	x7, #0xdfab             // =57259
    12d8: 93c97126     	ror	x6, x9, #0x1c
    12dc: f2bdccc7     	movk	x7, #0xee66, lsl #16
    12e0: 8a210053     	bic	x19, x2, x1
    12e4: 8a010094     	and	x20, x4, x1
    12e8: cac148a5     	eor	x5, x5, x1, ror #18
    12ec: f2ca2a47     	movk	x7, #0x5152, lsl #32
    12f0: cac988c6     	eor	x6, x6, x9, ror #34
    12f4: aa130293     	orr	x19, x20, x19
    12f8: f2f307c7     	movk	x7, #0x983e, lsl #48
    12fc: 8a0a0174     	and	x20, x11, x10
    1300: 8b130063     	add	x3, x3, x19
    1304: cac1a4a5     	eor	x5, x5, x1, ror #41
    1308: 8a150133     	and	x19, x9, x21
    130c: cac99cc6     	eor	x6, x6, x9, ror #39
    1310: 8b070063     	add	x3, x3, x7
    1314: aa140267     	orr	x7, x19, x20
    1318: 8b050065     	add	x5, x3, x5
    131c: 8b0700c6     	add	x6, x6, x7
    1320: 8b0c00a3     	add	x3, x5, x12
    1324: d2864207     	mov	x7, #0x3210             // =12816
    1328: 8b0500cc     	add	x12, x6, x5
    132c: a94c9bf3     	ldp	x19, x6, [sp, #0xc8]
    1330: 93c33865     	ror	x5, x3, #0xe
    1334: f2a5b687     	movk	x7, #0x2db4, lsl #16
    1338: 8a230094     	bic	x20, x4, x3
    133c: 8a030035     	and	x21, x1, x3
    1340: f2d8cda7     	movk	x7, #0xc66d, lsl #32
    1344: 8b020262     	add	x2, x19, x2
    1348: 93cc7193     	ror	x19, x12, #0x1c
    134c: cac348a5     	eor	x5, x5, x3, ror #18
    1350: aa1402b4     	orr	x20, x21, x20
    1354: f2f50627     	movk	x7, #0xa831, lsl #48
    1358: aa0b0135     	orr	x21, x9, x11
    135c: cacc8a73     	eor	x19, x19, x12, ror #34
    1360: 8b140042     	add	x2, x2, x20
    1364: 8a0b0134     	and	x20, x9, x11
    1368: cac3a4a5     	eor	x5, x5, x3, ror #41
    136c: 8a150195     	and	x21, x12, x21
    1370: 8b070042     	add	x2, x2, x7
    1374: cacc9e67     	eor	x7, x19, x12, ror #39
    1378: aa1402b3     	orr	x19, x21, x20
    137c: 8b0400c4     	add	x4, x6, x4
    1380: 8b050045     	add	x5, x2, x5
    1384: aa090195     	orr	x21, x12, x9
    1388: 8b1300e7     	add	x7, x7, x19
    138c: 8b0a00a2     	add	x2, x5, x10
    1390: 8b0500ea     	add	x10, x7, x5
    1394: 93c23845     	ror	x5, x2, #0xe
    1398: d28427e7     	mov	x7, #0x213f             // =8511
    139c: 93ca7146     	ror	x6, x10, #0x1c
    13a0: f2b31f67     	movk	x7, #0x98fb, lsl #16
    13a4: 8a220033     	bic	x19, x1, x2
    13a8: 8a020074     	and	x20, x3, x2
    13ac: cac248a5     	eor	x5, x5, x2, ror #18
    13b0: f2c4f907     	movk	x7, #0x27c8, lsl #32
    13b4: caca88c6     	eor	x6, x6, x10, ror #34
    13b8: aa130293     	orr	x19, x20, x19
    13bc: f2f60067     	movk	x7, #0xb003, lsl #48
    13c0: 8a090194     	and	x20, x12, x9
    13c4: 8b130084     	add	x4, x4, x19
    13c8: cac2a4a5     	eor	x5, x5, x2, ror #41
    13cc: 8a150153     	and	x19, x10, x21
    13d0: caca9cc6     	eor	x6, x6, x10, ror #39
    13d4: 8b070084     	add	x4, x4, x7
    13d8: aa140267     	orr	x7, x19, x20
    13dc: 8b050085     	add	x5, x4, x5
    13e0: 8b0700c6     	add	x6, x6, x7
    13e4: 8b0b00a4     	add	x4, x5, x11
    13e8: d281dc87     	mov	x7, #0xee4              // =3812
    13ec: 8b0500cb     	add	x11, x6, x5
    13f0: a94d9bf3     	ldp	x19, x6, [sp, #0xd8]
    13f4: 93c43885     	ror	x5, x4, #0xe
    13f8: f2b7dde7     	movk	x7, #0xbeef, lsl #16
    13fc: 8a240074     	bic	x20, x3, x4
    1400: 8a040055     	and	x21, x2, x4
    1404: f2cff8e7     	movk	x7, #0x7fc7, lsl #32
    1408: 8b010261     	add	x1, x19, x1
    140c: 93cb7173     	ror	x19, x11, #0x1c
    1410: cac448a5     	eor	x5, x5, x4, ror #18
    1414: aa1402b4     	orr	x20, x21, x20
    1418: f2f7eb27     	movk	x7, #0xbf59, lsl #48
    141c: aa0c0155     	orr	x21, x10, x12
    1420: cacb8a73     	eor	x19, x19, x11, ror #34
    1424: 8b140021     	add	x1, x1, x20
    1428: 8a0c0154     	and	x20, x10, x12
    142c: cac4a4a5     	eor	x5, x5, x4, ror #41
    1430: 8a150175     	and	x21, x11, x21
    1434: 8b070021     	add	x1, x1, x7
    1438: cacb9e67     	eor	x7, x19, x11, ror #39
    143c: aa1402b3     	orr	x19, x21, x20
    1440: 8b0300c3     	add	x3, x6, x3
    1444: 8b050025     	add	x5, x1, x5
    1448: aa0a0175     	orr	x21, x11, x10
    144c: 8b1300e7     	add	x7, x7, x19
    1450: 8b0900a1     	add	x1, x5, x9
    1454: 8b0500e9     	add	x9, x7, x5
    1458: 93c13825     	ror	x5, x1, #0xe
    145c: d291f847     	mov	x7, #0x8fc2             // =36802
    1460: 93c97126     	ror	x6, x9, #0x1c
    1464: f2a7b507     	movk	x7, #0x3da8, lsl #16
    1468: 8a210053     	bic	x19, x2, x1
    146c: 8a010094     	and	x20, x4, x1
    1470: cac148a5     	eor	x5, x5, x1, ror #18
    1474: f2c17e67     	movk	x7, #0xbf3, lsl #32
    1478: cac988c6     	eor	x6, x6, x9, ror #34
    147c: aa130293     	orr	x19, x20, x19
    1480: f2f8dc07     	movk	x7, #0xc6e0, lsl #48
    1484: 8a0a0174     	and	x20, x11, x10
    1488: 8b130063     	add	x3, x3, x19
    148c: cac1a4a5     	eor	x5, x5, x1, ror #41
    1490: 8a150133     	and	x19, x9, x21
    1494: cac99cc6     	eor	x6, x6, x9, ror #39
    1498: 8b070063     	add	x3, x3, x7
    149c: aa140267     	orr	x7, x19, x20
    14a0: 8b050065     	add	x5, x3, x5
    14a4: 8b0700c6     	add	x6, x6, x7
    14a8: 8b0c00a3     	add	x3, x5, x12
    14ac: d294e4a7     	mov	x7, #0xa725             // =42789
    14b0: 8b0500cc     	add	x12, x6, x5
    14b4: a94e9bf3     	ldp	x19, x6, [sp, #0xe8]
    14b8: 93c33865     	ror	x5, x3, #0xe
    14bc: f2b26147     	movk	x7, #0x930a, lsl #16
    14c0: 8a230094     	bic	x20, x4, x3
    14c4: 8a030035     	and	x21, x1, x3
    14c8: f2d228e7     	movk	x7, #0x9147, lsl #32
    14cc: 8b020262     	add	x2, x19, x2
    14d0: 93cc7193     	ror	x19, x12, #0x1c
    14d4: cac348a5     	eor	x5, x5, x3, ror #18
    14d8: aa1402b4     	orr	x20, x21, x20
    14dc: f2fab4e7     	movk	x7, #0xd5a7, lsl #48
    14e0: aa0b0135     	orr	x21, x9, x11
    14e4: cacc8a73     	eor	x19, x19, x12, ror #34
    14e8: 8b140042     	add	x2, x2, x20
    14ec: 8a0b0134     	and	x20, x9, x11
    14f0: cac3a4a5     	eor	x5, x5, x3, ror #41
    14f4: 8a150195     	and	x21, x12, x21
    14f8: 8b070042     	add	x2, x2, x7
    14fc: cacc9e67     	eor	x7, x19, x12, ror #39
    1500: aa1402b3     	orr	x19, x21, x20
    1504: 8b0400c4     	add	x4, x6, x4
    1508: 8b050045     	add	x5, x2, x5
    150c: aa090195     	orr	x21, x12, x9
    1510: 8b1300e7     	add	x7, x7, x19
    1514: 8b0a00a2     	add	x2, x5, x10
    1518: 8b0500ea     	add	x10, x7, x5
    151c: 93c23845     	ror	x5, x2, #0xe
    1520: d2904de7     	mov	x7, #0x826f             // =33391
    1524: 93ca7146     	ror	x6, x10, #0x1c
    1528: f2bc0067     	movk	x7, #0xe003, lsl #16
    152c: 8a220033     	bic	x19, x1, x2
    1530: 8a020074     	and	x20, x3, x2
    1534: cac248a5     	eor	x5, x5, x2, ror #18
    1538: f2cc6a27     	movk	x7, #0x6351, lsl #32
    153c: caca88c6     	eor	x6, x6, x10, ror #34
    1540: aa130293     	orr	x19, x20, x19
    1544: f2e0d947     	movk	x7, #0x6ca, lsl #48
    1548: 8a090194     	and	x20, x12, x9
    154c: 8b130084     	add	x4, x4, x19
    1550: cac2a4a5     	eor	x5, x5, x2, ror #41
    1554: 8a150153     	and	x19, x10, x21
    1558: caca9cc6     	eor	x6, x6, x10, ror #39
    155c: 8b070084     	add	x4, x4, x7
    1560: aa140267     	orr	x7, x19, x20
    1564: 8b050085     	add	x5, x4, x5
    1568: 8b0700c6     	add	x6, x6, x7
    156c: 8b0b00a4     	add	x4, x5, x11
    1570: d28dce07     	mov	x7, #0x6e70             // =28272
    1574: 8b0500cb     	add	x11, x6, x5
    1578: a94f9bf3     	ldp	x19, x6, [sp, #0xf8]
    157c: 93c43885     	ror	x5, x4, #0xe
    1580: f2a141c7     	movk	x7, #0xa0e, lsl #16
    1584: 8a240074     	bic	x20, x3, x4
    1588: 8a040055     	and	x21, x2, x4
    158c: f2c52ce7     	movk	x7, #0x2967, lsl #32
    1590: 8b010261     	add	x1, x19, x1
    1594: 93cb7173     	ror	x19, x11, #0x1c
    1598: cac448a5     	eor	x5, x5, x4, ror #18
    159c: aa1402b4     	orr	x20, x21, x20
    15a0: f2e28527     	movk	x7, #0x1429, lsl #48
    15a4: aa0c0155     	orr	x21, x10, x12
    15a8: cacb8a73     	eor	x19, x19, x11, ror #34
    15ac: 8b140021     	add	x1, x1, x20
    15b0: 8a0c0154     	and	x20, x10, x12
    15b4: cac4a4a5     	eor	x5, x5, x4, ror #41
    15b8: 8a150175     	and	x21, x11, x21
    15bc: 8b070021     	add	x1, x1, x7
    15c0: cacb9e67     	eor	x7, x19, x11, ror #39
    15c4: aa1402b3     	orr	x19, x21, x20
    15c8: 8b0300c3     	add	x3, x6, x3
    15cc: 8b050025     	add	x5, x1, x5
    15d0: aa0a0175     	orr	x21, x11, x10
    15d4: 8b1300e7     	add	x7, x7, x19
    15d8: 8b0900a1     	add	x1, x5, x9
    15dc: 8b0500e9     	add	x9, x7, x5
    15e0: 93c13825     	ror	x5, x1, #0xe
    15e4: d285ff87     	mov	x7, #0x2ffc             // =12284
    15e8: 93c97126     	ror	x6, x9, #0x1c
    15ec: f2a8da47     	movk	x7, #0x46d2, lsl #16
    15f0: 8a210053     	bic	x19, x2, x1
    15f4: 8a010094     	and	x20, x4, x1
    15f8: cac148a5     	eor	x5, x5, x1, ror #18
    15fc: f2c150a7     	movk	x7, #0xa85, lsl #32
    1600: cac988c6     	eor	x6, x6, x9, ror #34
    1604: aa130293     	orr	x19, x20, x19
    1608: f2e4f6e7     	movk	x7, #0x27b7, lsl #48
    160c: 8a0a0174     	and	x20, x11, x10
    1610: 8b130063     	add	x3, x3, x19
    1614: cac1a4a5     	eor	x5, x5, x1, ror #41
    1618: 8a150133     	and	x19, x9, x21
    161c: cac99cc6     	eor	x6, x6, x9, ror #39
    1620: 8b070063     	add	x3, x3, x7
    1624: aa140267     	orr	x7, x19, x20
    1628: 8b050065     	add	x5, x3, x5
    162c: 8b0700c6     	add	x6, x6, x7
    1630: 8b0c00a3     	add	x3, x5, x12
    1634: d29924c7     	mov	x7, #0xc926             // =51494
    1638: 8b0500cc     	add	x12, x6, x5
    163c: a9509bf3     	ldp	x19, x6, [sp, #0x108]
    1640: 93c33865     	ror	x5, x3, #0xe
    1644: f2ab84c7     	movk	x7, #0x5c26, lsl #16
    1648: 8a230094     	bic	x20, x4, x3
    164c: 8a030035     	and	x21, x1, x3
    1650: f2c42707     	movk	x7, #0x2138, lsl #32
    1654: 8b020262     	add	x2, x19, x2
    1658: 93cc7193     	ror	x19, x12, #0x1c
    165c: cac348a5     	eor	x5, x5, x3, ror #18
    1660: aa1402b4     	orr	x20, x21, x20
    1664: f2e5c367     	movk	x7, #0x2e1b, lsl #48
    1668: aa0b0135     	orr	x21, x9, x11
    166c: cacc8a73     	eor	x19, x19, x12, ror #34
    1670: 8b140042     	add	x2, x2, x20
    1674: 8a0b0134     	and	x20, x9, x11
    1678: cac3a4a5     	eor	x5, x5, x3, ror #41
    167c: 8a150195     	and	x21, x12, x21
    1680: 8b070042     	add	x2, x2, x7
    1684: cacc9e67     	eor	x7, x19, x12, ror #39
    1688: aa1402b3     	orr	x19, x21, x20
    168c: 8b0400c4     	add	x4, x6, x4
    1690: 8b050045     	add	x5, x2, x5
    1694: aa090195     	orr	x21, x12, x9
    1698: 8b1300e7     	add	x7, x7, x19
    169c: 8b0a00a2     	add	x2, x5, x10
    16a0: 8b0500ea     	add	x10, x7, x5
    16a4: 93c23845     	ror	x5, x2, #0xe
    16a8: d2855da7     	mov	x7, #0x2aed             // =10989
    16ac: 93ca7146     	ror	x6, x10, #0x1c
    16b0: f2ab5887     	movk	x7, #0x5ac4, lsl #16
    16b4: 8a220033     	bic	x19, x1, x2
    16b8: 8a020074     	and	x20, x3, x2
    16bc: cac248a5     	eor	x5, x5, x2, ror #18
    16c0: f2cdbf87     	movk	x7, #0x6dfc, lsl #32
    16c4: caca88c6     	eor	x6, x6, x10, ror #34
    16c8: aa130293     	orr	x19, x20, x19
    16cc: f2e9a587     	movk	x7, #0x4d2c, lsl #48
    16d0: 8a090194     	and	x20, x12, x9
    16d4: 8b130084     	add	x4, x4, x19
    16d8: cac2a4a5     	eor	x5, x5, x2, ror #41
    16dc: 8a150153     	and	x19, x10, x21
    16e0: caca9cc6     	eor	x6, x6, x10, ror #39
    16e4: 8b070084     	add	x4, x4, x7
    16e8: aa140267     	orr	x7, x19, x20
    16ec: 8b050085     	add	x5, x4, x5
    16f0: 8b0700c6     	add	x6, x6, x7
    16f4: 8b0b00a4     	add	x4, x5, x11
    16f8: d2967be7     	mov	x7, #0xb3df             // =46047
    16fc: 8b0500cb     	add	x11, x6, x5
    1700: a9519bf3     	ldp	x19, x6, [sp, #0x118]
    1704: 93c43885     	ror	x5, x4, #0xe
    1708: f2b3b2a7     	movk	x7, #0x9d95, lsl #16
    170c: 8a240074     	bic	x20, x3, x4
    1710: 8a040055     	and	x21, x2, x4
    1714: f2c1a267     	movk	x7, #0xd13, lsl #32
    1718: 8b010261     	add	x1, x19, x1
    171c: 93cb7173     	ror	x19, x11, #0x1c
    1720: cac448a5     	eor	x5, x5, x4, ror #18
    1724: aa1402b4     	orr	x20, x21, x20
    1728: f2ea6707     	movk	x7, #0x5338, lsl #48
    172c: aa0c0155     	orr	x21, x10, x12
    1730: cacb8a73     	eor	x19, x19, x11, ror #34
    1734: 8b140021     	add	x1, x1, x20
    1738: 8a0c0154     	and	x20, x10, x12
    173c: cac4a4a5     	eor	x5, x5, x4, ror #41
    1740: 8a150175     	and	x21, x11, x21
    1744: 8b070021     	add	x1, x1, x7
    1748: cacb9e67     	eor	x7, x19, x11, ror #39
    174c: aa1402b3     	orr	x19, x21, x20
    1750: 8b0300c3     	add	x3, x6, x3
    1754: 8b050025     	add	x5, x1, x5
    1758: aa0a0175     	orr	x21, x11, x10
    175c: 8b1300e7     	add	x7, x7, x19
    1760: 8b0900a1     	add	x1, x5, x9
    1764: 8b0500e9     	add	x9, x7, x5
    1768: 93c13825     	ror	x5, x1, #0xe
    176c: d28c7bc7     	mov	x7, #0x63de             // =25566
    1770: 93c97126     	ror	x6, x9, #0x1c
    1774: f2b175e7     	movk	x7, #0x8baf, lsl #16
    1778: 8a210053     	bic	x19, x2, x1
    177c: 8a010094     	and	x20, x4, x1
    1780: cac148a5     	eor	x5, x5, x1, ror #18
    1784: f2ce6a87     	movk	x7, #0x7354, lsl #32
    1788: cac988c6     	eor	x6, x6, x9, ror #34
    178c: aa130293     	orr	x19, x20, x19
    1790: f2eca147     	movk	x7, #0x650a, lsl #48
    1794: 8a0a0174     	and	x20, x11, x10
    1798: 8b130063     	add	x3, x3, x19
    179c: cac1a4a5     	eor	x5, x5, x1, ror #41
    17a0: 8a150133     	and	x19, x9, x21
    17a4: cac99cc6     	eor	x6, x6, x9, ror #39
    17a8: 8b070063     	add	x3, x3, x7
    17ac: aa140267     	orr	x7, x19, x20
    17b0: 8b050065     	add	x5, x3, x5
    17b4: 8b0700c6     	add	x6, x6, x7
    17b8: 8b0c00a3     	add	x3, x5, x12
    17bc: d2965507     	mov	x7, #0xb2a8             // =45736
    17c0: 8b0500cc     	add	x12, x6, x5
    17c4: a9529bf3     	ldp	x19, x6, [sp, #0x128]
    17c8: 93c33865     	ror	x5, x3, #0xe
    17cc: f2a78ee7     	movk	x7, #0x3c77, lsl #16
    17d0: 8a230094     	bic	x20, x4, x3
    17d4: 8a030035     	and	x21, x1, x3
    17d8: f2c15767     	movk	x7, #0xabb, lsl #32
    17dc: 8b020262     	add	x2, x19, x2
    17e0: 93cc7193     	ror	x19, x12, #0x1c
    17e4: cac348a5     	eor	x5, x5, x3, ror #18
    17e8: aa1402b4     	orr	x20, x21, x20
    17ec: f2eecd47     	movk	x7, #0x766a, lsl #48
    17f0: aa0b0135     	orr	x21, x9, x11
    17f4: cacc8a73     	eor	x19, x19, x12, ror #34
    17f8: 8b140042     	add	x2, x2, x20
    17fc: 8a0b0134     	and	x20, x9, x11
    1800: cac3a4a5     	eor	x5, x5, x3, ror #41
    1804: 8a150195     	and	x21, x12, x21
    1808: 8b070042     	add	x2, x2, x7
    180c: cacc9e67     	eor	x7, x19, x12, ror #39
    1810: aa1402b3     	orr	x19, x21, x20
    1814: 8b0400c4     	add	x4, x6, x4
    1818: 8b050045     	add	x5, x2, x5
    181c: aa090195     	orr	x21, x12, x9
    1820: 8b1300e7     	add	x7, x7, x19
    1824: 8b0a00a2     	add	x2, x5, x10
    1828: 8b0500ea     	add	x10, x7, x5
    182c: 93c23845     	ror	x5, x2, #0xe
    1830: d295dcc7     	mov	x7, #0xaee6             // =44774
    1834: 93ca7146     	ror	x6, x10, #0x1c
    1838: f2a8fda7     	movk	x7, #0x47ed, lsl #16
    183c: 8a220033     	bic	x19, x1, x2
    1840: 8a020074     	and	x20, x3, x2
    1844: cac248a5     	eor	x5, x5, x2, ror #18
    1848: f2d925c7     	movk	x7, #0xc92e, lsl #32
    184c: caca88c6     	eor	x6, x6, x10, ror #34
    1850: aa130293     	orr	x19, x20, x19
    1854: f2f03847     	movk	x7, #0x81c2, lsl #48
    1858: 8a090194     	and	x20, x12, x9
    185c: 8b130084     	add	x4, x4, x19
    1860: cac2a4a5     	eor	x5, x5, x2, ror #41
    1864: 8a150153     	and	x19, x10, x21
    1868: caca9cc6     	eor	x6, x6, x10, ror #39
    186c: 8b070084     	add	x4, x4, x7
    1870: aa140267     	orr	x7, x19, x20
    1874: 8b050085     	add	x5, x4, x5
    1878: 8b0700c6     	add	x6, x6, x7
    187c: 8b0b00a4     	add	x4, x5, x11
    1880: d286a767     	mov	x7, #0x353b             // =13627
    1884: 8b0500cb     	add	x11, x6, x5
    1888: a9539bf3     	ldp	x19, x6, [sp, #0x138]
    188c: 93c43885     	ror	x5, x4, #0xe
    1890: f2a29047     	movk	x7, #0x1482, lsl #16
    1894: 8a240074     	bic	x20, x3, x4
    1898: 8a040055     	and	x21, x2, x4
    189c: f2c590a7     	movk	x7, #0x2c85, lsl #32
    18a0: 8b010261     	add	x1, x19, x1
    18a4: 93cb7173     	ror	x19, x11, #0x1c
    18a8: cac448a5     	eor	x5, x5, x4, ror #18
    18ac: aa1402b4     	orr	x20, x21, x20
    18b0: f2f24e47     	movk	x7, #0x9272, lsl #48
    18b4: aa0c0155     	orr	x21, x10, x12
    18b8: cacb8a73     	eor	x19, x19, x11, ror #34
    18bc: 8b140021     	add	x1, x1, x20
    18c0: 8a0c0154     	and	x20, x10, x12
    18c4: cac4a4a5     	eor	x5, x5, x4, ror #41
    18c8: 8a150175     	and	x21, x11, x21
    18cc: 8b070021     	add	x1, x1, x7
    18d0: cacb9e67     	eor	x7, x19, x11, ror #39
    18d4: aa1402b3     	orr	x19, x21, x20
    18d8: 8b0300c3     	add	x3, x6, x3
    18dc: 8b050025     	add	x5, x1, x5
    18e0: aa0a0175     	orr	x21, x11, x10
    18e4: 8b1300e7     	add	x7, x7, x19
    18e8: 8b0900a1     	add	x1, x5, x9
    18ec: 8b0500e9     	add	x9, x7, x5
    18f0: 93c13825     	ror	x5, x1, #0xe
    18f4: d2806c87     	mov	x7, #0x364              // =868
    18f8: 93c97126     	ror	x6, x9, #0x1c
    18fc: f2a99e27     	movk	x7, #0x4cf1, lsl #16
    1900: 8a210053     	bic	x19, x2, x1
    1904: 8a010094     	and	x20, x4, x1
    1908: cac148a5     	eor	x5, x5, x1, ror #18
    190c: f2dd1427     	movk	x7, #0xe8a1, lsl #32
    1910: cac988c6     	eor	x6, x6, x9, ror #34
    1914: aa130293     	orr	x19, x20, x19
    1918: f2f457e7     	movk	x7, #0xa2bf, lsl #48
    191c: 8a0a0174     	and	x20, x11, x10
    1920: 8b130063     	add	x3, x3, x19
    1924: cac1a4a5     	eor	x5, x5, x1, ror #41
    1928: 8a150133     	and	x19, x9, x21
    192c: cac99cc6     	eor	x6, x6, x9, ror #39
    1930: 8b070063     	add	x3, x3, x7
    1934: aa140267     	orr	x7, x19, x20
    1938: 8b050065     	add	x5, x3, x5
    193c: 8b0700c6     	add	x6, x6, x7
    1940: 8b0c00a3     	add	x3, x5, x12
    1944: d2860027     	mov	x7, #0x3001             // =12289
    1948: 8b0500cc     	add	x12, x6, x5
    194c: a9549bf3     	ldp	x19, x6, [sp, #0x148]
    1950: 93c33865     	ror	x5, x3, #0xe
    1954: f2b78847     	movk	x7, #0xbc42, lsl #16
    1958: 8a230094     	bic	x20, x4, x3
    195c: 8a030035     	and	x21, x1, x3
    1960: f2ccc967     	movk	x7, #0x664b, lsl #32
    1964: 8b020262     	add	x2, x19, x2
    1968: 93cc7193     	ror	x19, x12, #0x1c
    196c: cac348a5     	eor	x5, x5, x3, ror #18
    1970: aa1402b4     	orr	x20, x21, x20
    1974: f2f50347     	movk	x7, #0xa81a, lsl #48
    1978: aa0b0135     	orr	x21, x9, x11
    197c: cacc8a73     	eor	x19, x19, x12, ror #34
    1980: 8b140042     	add	x2, x2, x20
    1984: 8a0b0134     	and	x20, x9, x11
    1988: cac3a4a5     	eor	x5, x5, x3, ror #41
    198c: 8a150195     	and	x21, x12, x21
    1990: 8b070042     	add	x2, x2, x7
    1994: cacc9e67     	eor	x7, x19, x12, ror #39
    1998: aa1402b3     	orr	x19, x21, x20
    199c: 8b0400c4     	add	x4, x6, x4
    19a0: 8b050045     	add	x5, x2, x5
    19a4: aa090195     	orr	x21, x12, x9
    19a8: 8b1300e7     	add	x7, x7, x19
    19ac: 8b0a00a2     	add	x2, x5, x10
    19b0: 8b0500ea     	add	x10, x7, x5
    19b4: 93c23845     	ror	x5, x2, #0xe
    19b8: d292f227     	mov	x7, #0x9791             // =38801
    19bc: 93ca7146     	ror	x6, x10, #0x1c
    19c0: f2ba1f07     	movk	x7, #0xd0f8, lsl #16
    19c4: 8a220033     	bic	x19, x1, x2
    19c8: 8a020074     	and	x20, x3, x2
    19cc: cac248a5     	eor	x5, x5, x2, ror #18
    19d0: f2d16e07     	movk	x7, #0x8b70, lsl #32
    19d4: caca88c6     	eor	x6, x6, x10, ror #34
    19d8: aa130293     	orr	x19, x20, x19
    19dc: f2f84967     	movk	x7, #0xc24b, lsl #48
    19e0: 8a090194     	and	x20, x12, x9
    19e4: 8b130084     	add	x4, x4, x19
    19e8: cac2a4a5     	eor	x5, x5, x2, ror #41
    19ec: 8a150153     	and	x19, x10, x21
    19f0: caca9cc6     	eor	x6, x6, x10, ror #39
    19f4: 8b070084     	add	x4, x4, x7
    19f8: aa140267     	orr	x7, x19, x20
    19fc: 8b050085     	add	x5, x4, x5
    1a00: 8b0700c6     	add	x6, x6, x7
    1a04: 8b0b00a4     	add	x4, x5, x11
    1a08: d297c607     	mov	x7, #0xbe30             // =48688
    1a0c: 8b0500cb     	add	x11, x6, x5
    1a10: a9559bf3     	ldp	x19, x6, [sp, #0x158]
    1a14: 93c43885     	ror	x5, x4, #0xe
    1a18: f2a0ca87     	movk	x7, #0x654, lsl #16
    1a1c: 8a240074     	bic	x20, x3, x4
    1a20: 8a040055     	and	x21, x2, x4
    1a24: f2ca3467     	movk	x7, #0x51a3, lsl #32
    1a28: 8b010261     	add	x1, x19, x1
    1a2c: 93cb7173     	ror	x19, x11, #0x1c
    1a30: cac448a5     	eor	x5, x5, x4, ror #18
    1a34: aa1402b4     	orr	x20, x21, x20
    1a38: f2f8ed87     	movk	x7, #0xc76c, lsl #48
    1a3c: aa0c0155     	orr	x21, x10, x12
    1a40: cacb8a73     	eor	x19, x19, x11, ror #34
    1a44: 8b140021     	add	x1, x1, x20
    1a48: 8a0c0154     	and	x20, x10, x12
    1a4c: cac4a4a5     	eor	x5, x5, x4, ror #41
    1a50: 8a150175     	and	x21, x11, x21
    1a54: 8b070021     	add	x1, x1, x7
    1a58: cacb9e67     	eor	x7, x19, x11, ror #39
    1a5c: aa1402b3     	orr	x19, x21, x20
    1a60: 8b0300c3     	add	x3, x6, x3
    1a64: 8b050025     	add	x5, x1, x5
    1a68: aa0a0175     	orr	x21, x11, x10
    1a6c: 8b1300e7     	add	x7, x7, x19
    1a70: 8b0900a1     	add	x1, x5, x9
    1a74: 8b0500e9     	add	x9, x7, x5
    1a78: 93c13825     	ror	x5, x1, #0xe
    1a7c: d28a4307     	mov	x7, #0x5218             // =21016
    1a80: 93c97126     	ror	x6, x9, #0x1c
    1a84: f2badde7     	movk	x7, #0xd6ef, lsl #16
    1a88: 8a210053     	bic	x19, x2, x1
    1a8c: 8a010094     	and	x20, x4, x1
    1a90: cac148a5     	eor	x5, x5, x1, ror #18
    1a94: f2dd0327     	movk	x7, #0xe819, lsl #32
    1a98: cac988c6     	eor	x6, x6, x9, ror #34
    1a9c: aa130293     	orr	x19, x20, x19
    1aa0: f2fa3247     	movk	x7, #0xd192, lsl #48
    1aa4: 8a0a0174     	and	x20, x11, x10
    1aa8: 8b130063     	add	x3, x3, x19
    1aac: cac1a4a5     	eor	x5, x5, x1, ror #41
    1ab0: 8a150133     	and	x19, x9, x21
    1ab4: cac99cc6     	eor	x6, x6, x9, ror #39
    1ab8: 8b070063     	add	x3, x3, x7
    1abc: aa140267     	orr	x7, x19, x20
    1ac0: 8b050065     	add	x5, x3, x5
    1ac4: 8b0700c6     	add	x6, x6, x7
    1ac8: 8b0c00a3     	add	x3, x5, x12
    1acc: d2952207     	mov	x7, #0xa910             // =43280
    1ad0: 8b0500cc     	add	x12, x6, x5
    1ad4: a9569bf3     	ldp	x19, x6, [sp, #0x168]
    1ad8: 93c33865     	ror	x5, x3, #0xe
    1adc: f2aaaca7     	movk	x7, #0x5565, lsl #16
    1ae0: 8a230094     	bic	x20, x4, x3
    1ae4: 8a030035     	and	x21, x1, x3
    1ae8: f2c0c487     	movk	x7, #0x624, lsl #32
    1aec: 8b020262     	add	x2, x19, x2
    1af0: 93cc7193     	ror	x19, x12, #0x1c
    1af4: cac348a5     	eor	x5, x5, x3, ror #18
    1af8: aa1402b4     	orr	x20, x21, x20
    1afc: f2fad327     	movk	x7, #0xd699, lsl #48
    1b00: aa0b0135     	orr	x21, x9, x11
    1b04: cacc8a73     	eor	x19, x19, x12, ror #34
    1b08: 8b140042     	add	x2, x2, x20
    1b0c: 8a0b0134     	and	x20, x9, x11
    1b10: cac3a4a5     	eor	x5, x5, x3, ror #41
    1b14: 8a150195     	and	x21, x12, x21
    1b18: 8b070042     	add	x2, x2, x7
    1b1c: cacc9e67     	eor	x7, x19, x12, ror #39
    1b20: aa1402b3     	orr	x19, x21, x20
    1b24: 8b0400c4     	add	x4, x6, x4
    1b28: 8b050045     	add	x5, x2, x5
    1b2c: aa090195     	orr	x21, x12, x9
    1b30: 8b1300e7     	add	x7, x7, x19
    1b34: 8b0a00a2     	add	x2, x5, x10
    1b38: 8b0500ea     	add	x10, x7, x5
    1b3c: 93c23845     	ror	x5, x2, #0xe
    1b40: d2840547     	mov	x7, #0x202a             // =8234
    1b44: 93ca7146     	ror	x6, x10, #0x1c
    1b48: f2aaee27     	movk	x7, #0x5771, lsl #16
    1b4c: 8a220033     	bic	x19, x1, x2
    1b50: 8a020074     	and	x20, x3, x2
    1b54: cac248a5     	eor	x5, x5, x2, ror #18
    1b58: f2c6b0a7     	movk	x7, #0x3585, lsl #32
    1b5c: caca88c6     	eor	x6, x6, x10, ror #34
    1b60: aa130293     	orr	x19, x20, x19
    1b64: f2fe81c7     	movk	x7, #0xf40e, lsl #48
    1b68: 8a090194     	and	x20, x12, x9
    1b6c: 8b130084     	add	x4, x4, x19
    1b70: cac2a4a5     	eor	x5, x5, x2, ror #41
    1b74: 8a150153     	and	x19, x10, x21
    1b78: caca9cc6     	eor	x6, x6, x10, ror #39
    1b7c: 8b070084     	add	x4, x4, x7
    1b80: aa140267     	orr	x7, x19, x20
    1b84: 8b050085     	add	x5, x4, x5
    1b88: 8b0700c6     	add	x6, x6, x7
    1b8c: 8b0b00a4     	add	x4, x5, x11
    1b90: d29a3707     	mov	x7, #0xd1b8             // =53688
    1b94: 8b0500cb     	add	x11, x6, x5
    1b98: a9579bf3     	ldp	x19, x6, [sp, #0x178]
    1b9c: 93c43885     	ror	x5, x4, #0xe
    1ba0: f2a65767     	movk	x7, #0x32bb, lsl #16
    1ba4: 8a240074     	bic	x20, x3, x4
    1ba8: 8a040055     	and	x21, x2, x4
    1bac: f2d40e07     	movk	x7, #0xa070, lsl #32
    1bb0: 8b010261     	add	x1, x19, x1
    1bb4: 93cb7173     	ror	x19, x11, #0x1c
    1bb8: cac448a5     	eor	x5, x5, x4, ror #18
    1bbc: aa1402b4     	orr	x20, x21, x20
    1bc0: f2e20d47     	movk	x7, #0x106a, lsl #48
    1bc4: aa0c0155     	orr	x21, x10, x12
    1bc8: cacb8a73     	eor	x19, x19, x11, ror #34
    1bcc: 8b140021     	add	x1, x1, x20
    1bd0: 8a0c0154     	and	x20, x10, x12
    1bd4: cac4a4a5     	eor	x5, x5, x4, ror #41
    1bd8: 8a150175     	and	x21, x11, x21
    1bdc: 8b070021     	add	x1, x1, x7
    1be0: cacb9e67     	eor	x7, x19, x11, ror #39
    1be4: aa1402b3     	orr	x19, x21, x20
    1be8: 8b0300c3     	add	x3, x6, x3
    1bec: 8b050025     	add	x5, x1, x5
    1bf0: aa0a0175     	orr	x21, x11, x10
    1bf4: 8b1300e7     	add	x7, x7, x19
    1bf8: 8b0900a1     	add	x1, x5, x9
    1bfc: 8b0500e9     	add	x9, x7, x5
    1c00: 93c13825     	ror	x5, x1, #0xe
    1c04: d29a1907     	mov	x7, #0xd0c8             // =53448
    1c08: 93c97126     	ror	x6, x9, #0x1c
    1c0c: f2b71a47     	movk	x7, #0xb8d2, lsl #16
    1c10: 8a210053     	bic	x19, x2, x1
    1c14: 8a010094     	and	x20, x4, x1
    1c18: cac148a5     	eor	x5, x5, x1, ror #18
    1c1c: f2d822c7     	movk	x7, #0xc116, lsl #32
    1c20: cac988c6     	eor	x6, x6, x9, ror #34
    1c24: aa130293     	orr	x19, x20, x19
    1c28: f2e33487     	movk	x7, #0x19a4, lsl #48
    1c2c: 8a0a0174     	and	x20, x11, x10
    1c30: 8b130063     	add	x3, x3, x19
    1c34: cac1a4a5     	eor	x5, x5, x1, ror #41
    1c38: 8a150133     	and	x19, x9, x21
    1c3c: cac99cc6     	eor	x6, x6, x9, ror #39
    1c40: 8b070063     	add	x3, x3, x7
    1c44: aa140267     	orr	x7, x19, x20
    1c48: 8b050065     	add	x5, x3, x5
    1c4c: 8b0700c6     	add	x6, x6, x7
    1c50: 8b0c00a3     	add	x3, x5, x12
    1c54: d2956a67     	mov	x7, #0xab53             // =43859
    1c58: 8b0500cc     	add	x12, x6, x5
    1c5c: a9589bf3     	ldp	x19, x6, [sp, #0x188]
    1c60: 93c33865     	ror	x5, x3, #0xe
    1c64: f2aa2827     	movk	x7, #0x5141, lsl #16
    1c68: 8a230094     	bic	x20, x4, x3
    1c6c: 8a030035     	and	x21, x1, x3
    1c70: f2cd8107     	movk	x7, #0x6c08, lsl #32
    1c74: 8b020262     	add	x2, x19, x2
    1c78: 93cc7193     	ror	x19, x12, #0x1c
    1c7c: cac348a5     	eor	x5, x5, x3, ror #18
    1c80: aa1402b4     	orr	x20, x21, x20
    1c84: f2e3c6e7     	movk	x7, #0x1e37, lsl #48
    1c88: aa0b0135     	orr	x21, x9, x11
    1c8c: cacc8a73     	eor	x19, x19, x12, ror #34
    1c90: 8b140042     	add	x2, x2, x20
    1c94: 8a0b0134     	and	x20, x9, x11
    1c98: cac3a4a5     	eor	x5, x5, x3, ror #41
    1c9c: 8a150195     	and	x21, x12, x21
    1ca0: 8b070042     	add	x2, x2, x7
    1ca4: cacc9e67     	eor	x7, x19, x12, ror #39
    1ca8: aa1402b3     	orr	x19, x21, x20
    1cac: 8b0400c4     	add	x4, x6, x4
    1cb0: 8b050045     	add	x5, x2, x5
    1cb4: aa090195     	orr	x21, x12, x9
    1cb8: 8b1300e7     	add	x7, x7, x19
    1cbc: 8b0a00a2     	add	x2, x5, x10
    1cc0: 8b0500ea     	add	x10, x7, x5
    1cc4: 93c23845     	ror	x5, x2, #0xe
    1cc8: d29d7327     	mov	x7, #0xeb99             // =60313
    1ccc: 93ca7146     	ror	x6, x10, #0x1c
    1cd0: f2bbf1c7     	movk	x7, #0xdf8e, lsl #16
    1cd4: 8a220033     	bic	x19, x1, x2
    1cd8: 8a020074     	and	x20, x3, x2
    1cdc: cac248a5     	eor	x5, x5, x2, ror #18
    1ce0: f2cee987     	movk	x7, #0x774c, lsl #32
    1ce4: caca88c6     	eor	x6, x6, x10, ror #34
    1ce8: aa130293     	orr	x19, x20, x19
    1cec: f2e4e907     	movk	x7, #0x2748, lsl #48
    1cf0: 8a090194     	and	x20, x12, x9
    1cf4: 8b130084     	add	x4, x4, x19
    1cf8: cac2a4a5     	eor	x5, x5, x2, ror #41
    1cfc: 8a150153     	and	x19, x10, x21
    1d00: caca9cc6     	eor	x6, x6, x10, ror #39
    1d04: 8b070084     	add	x4, x4, x7
    1d08: aa140267     	orr	x7, x19, x20
    1d0c: 8b050085     	add	x5, x4, x5
    1d10: 8b0700c6     	add	x6, x6, x7
    1d14: 8b0b00a4     	add	x4, x5, x11
    1d18: d2891507     	mov	x7, #0x48a8             // =18600
    1d1c: 8b0500cb     	add	x11, x6, x5
    1d20: a9599bf3     	ldp	x19, x6, [sp, #0x198]
    1d24: 93c43885     	ror	x5, x4, #0xe
    1d28: f2bc3367     	movk	x7, #0xe19b, lsl #16
    1d2c: 8a240074     	bic	x20, x3, x4
    1d30: 8a040055     	and	x21, x2, x4
    1d34: f2d796a7     	movk	x7, #0xbcb5, lsl #32
    1d38: 8b010261     	add	x1, x19, x1
    1d3c: 93cb7173     	ror	x19, x11, #0x1c
    1d40: cac448a5     	eor	x5, x5, x4, ror #18
    1d44: aa1402b4     	orr	x20, x21, x20
    1d48: f2e69607     	movk	x7, #0x34b0, lsl #48
    1d4c: aa0c0155     	orr	x21, x10, x12
    1d50: cacb8a73     	eor	x19, x19, x11, ror #34
    1d54: 8b140021     	add	x1, x1, x20
    1d58: 8a0c0154     	and	x20, x10, x12
    1d5c: cac4a4a5     	eor	x5, x5, x4, ror #41
    1d60: 8a150175     	and	x21, x11, x21
    1d64: 8b070021     	add	x1, x1, x7
    1d68: cacb9e67     	eor	x7, x19, x11, ror #39
    1d6c: aa1402b3     	orr	x19, x21, x20
    1d70: 8b0300c3     	add	x3, x6, x3
    1d74: 8b050025     	add	x5, x1, x5
    1d78: aa0a0175     	orr	x21, x11, x10
    1d7c: 8b1300e7     	add	x7, x7, x19
    1d80: 8b0900a1     	add	x1, x5, x9
    1d84: 8b0500e9     	add	x9, x7, x5
    1d88: 93c13825     	ror	x5, x1, #0xe
    1d8c: d28b4c67     	mov	x7, #0x5a63             // =23139
    1d90: 93c97126     	ror	x6, x9, #0x1c
    1d94: f2b8b927     	movk	x7, #0xc5c9, lsl #16
    1d98: 8a210053     	bic	x19, x2, x1
    1d9c: 8a010094     	and	x20, x4, x1
    1da0: cac148a5     	eor	x5, x5, x1, ror #18
    1da4: f2c19667     	movk	x7, #0xcb3, lsl #32
    1da8: cac988c6     	eor	x6, x6, x9, ror #34
    1dac: aa130293     	orr	x19, x20, x19
    1db0: f2e72387     	movk	x7, #0x391c, lsl #48
    1db4: 8a0a0174     	and	x20, x11, x10
    1db8: 8b130063     	add	x3, x3, x19
    1dbc: cac1a4a5     	eor	x5, x5, x1, ror #41
    1dc0: 8a150133     	and	x19, x9, x21
    1dc4: cac99cc6     	eor	x6, x6, x9, ror #39
    1dc8: 8b070063     	add	x3, x3, x7
    1dcc: aa140267     	orr	x7, x19, x20
    1dd0: 8b050063     	add	x3, x3, x5
    1dd4: 8b0700c6     	add	x6, x6, x7
    1dd8: 8b0c0065     	add	x5, x3, x12
    1ddc: d2915967     	mov	x7, #0x8acb             // =35531
    1de0: 8b0300cc     	add	x12, x6, x3
    1de4: a95a9bf3     	ldp	x19, x6, [sp, #0x1a8]
    1de8: 93c538a3     	ror	x3, x5, #0xe
    1dec: f2bc6827     	movk	x7, #0xe341, lsl #16
    1df0: 8a250094     	bic	x20, x4, x5
    1df4: 8a050035     	and	x21, x1, x5
    1df8: f2d54947     	movk	x7, #0xaa4a, lsl #32
    1dfc: 8b020262     	add	x2, x19, x2
    1e00: 93cc7193     	ror	x19, x12, #0x1c
    1e04: cac54863     	eor	x3, x3, x5, ror #18
    1e08: aa1402b4     	orr	x20, x21, x20
    1e0c: f2e9db07     	movk	x7, #0x4ed8, lsl #48
    1e10: aa0b0135     	orr	x21, x9, x11
    1e14: cacc8a73     	eor	x19, x19, x12, ror #34
    1e18: 8b140042     	add	x2, x2, x20
    1e1c: 8a0b0134     	and	x20, x9, x11
    1e20: cac5a463     	eor	x3, x3, x5, ror #41
    1e24: 8a150195     	and	x21, x12, x21
    1e28: 8b070042     	add	x2, x2, x7
    1e2c: cacc9e67     	eor	x7, x19, x12, ror #39
    1e30: aa1402b3     	orr	x19, x21, x20
    1e34: 8b0400c4     	add	x4, x6, x4
    1e38: 8b030043     	add	x3, x2, x3
    1e3c: aa090195     	orr	x21, x12, x9
    1e40: 8b1300e7     	add	x7, x7, x19
    1e44: 8b0a0062     	add	x2, x3, x10
    1e48: 8b0300ea     	add	x10, x7, x3
    1e4c: 93c23843     	ror	x3, x2, #0xe
    1e50: d29c6e67     	mov	x7, #0xe373             // =58227
    1e54: 93ca7146     	ror	x6, x10, #0x1c
    1e58: f2aeec67     	movk	x7, #0x7763, lsl #16
    1e5c: 8a220033     	bic	x19, x1, x2
    1e60: 8a0200b4     	and	x20, x5, x2
    1e64: cac24863     	eor	x3, x3, x2, ror #18
    1e68: f2d949e7     	movk	x7, #0xca4f, lsl #32
    1e6c: caca88c6     	eor	x6, x6, x10, ror #34
    1e70: aa130293     	orr	x19, x20, x19
    1e74: f2eb7387     	movk	x7, #0x5b9c, lsl #48
    1e78: 8a090194     	and	x20, x12, x9
    1e7c: 8b130084     	add	x4, x4, x19
    1e80: cac2a463     	eor	x3, x3, x2, ror #41
    1e84: 8a150153     	and	x19, x10, x21
    1e88: caca9cc6     	eor	x6, x6, x10, ror #39
    1e8c: 8b070084     	add	x4, x4, x7
    1e90: aa140267     	orr	x7, x19, x20
    1e94: 8b030083     	add	x3, x4, x3
    1e98: d2971473     	mov	x19, #0xb8a3            // =47267
    1e9c: 8b0700c7     	add	x7, x6, x7
    1ea0: 8b0b0066     	add	x6, x3, x11
    1ea4: f2bad653     	movk	x19, #0xd6b2, lsl #16
    1ea8: 8b0300eb     	add	x11, x7, x3
    1eac: a95b9fe4     	ldp	x4, x7, [sp, #0x1b8]
    1eb0: 93c638c3     	ror	x3, x6, #0xe
    1eb4: 8a2600b4     	bic	x20, x5, x6
    1eb8: 8a060055     	and	x21, x2, x6
    1ebc: f2cdfe73     	movk	x19, #0x6ff3, lsl #32
    1ec0: aa1402b4     	orr	x20, x21, x20
    1ec4: aa0c0155     	orr	x21, x10, x12
    1ec8: 8b010081     	add	x1, x4, x1
    1ecc: 93cb7164     	ror	x4, x11, #0x1c
    1ed0: cac64863     	eor	x3, x3, x6, ror #18
    1ed4: f2ed05d3     	movk	x19, #0x682e, lsl #48
    1ed8: 8b140021     	add	x1, x1, x20
    1edc: 8a0c0154     	and	x20, x10, x12
    1ee0: cacb8884     	eor	x4, x4, x11, ror #34
    1ee4: cac6a463     	eor	x3, x3, x6, ror #41
    1ee8: 8a150175     	and	x21, x11, x21
    1eec: 8b130021     	add	x1, x1, x19
    1ef0: aa1402b3     	orr	x19, x21, x20
    1ef4: 8b0500e5     	add	x5, x7, x5
    1ef8: cacb9c84     	eor	x4, x4, x11, ror #39
    1efc: 8b030021     	add	x1, x1, x3
    1f00: aa0a0175     	orr	x21, x11, x10
    1f04: 8b090023     	add	x3, x1, x9
    1f08: 8b130084     	add	x4, x4, x19
    1f0c: 8a230053     	bic	x19, x2, x3
    1f10: 8a0300d4     	and	x20, x6, x3
    1f14: 8b010089     	add	x9, x4, x1
    1f18: 93c33861     	ror	x1, x3, #0xe
    1f1c: d2965f84     	mov	x4, #0xb2fc             // =45820
    1f20: 93c97127     	ror	x7, x9, #0x1c
    1f24: f2abbde4     	movk	x4, #0x5def, lsl #16
    1f28: aa130293     	orr	x19, x20, x19
    1f2c: f2d05dc4     	movk	x4, #0x82ee, lsl #32
    1f30: cac34821     	eor	x1, x1, x3, ror #18
    1f34: 8b1300a5     	add	x5, x5, x19
    1f38: cac988e7     	eor	x7, x7, x9, ror #34
    1f3c: f2ee91e4     	movk	x4, #0x748f, lsl #48
    1f40: 8a0a0174     	and	x20, x11, x10
    1f44: cac3a421     	eor	x1, x1, x3, ror #41
    1f48: 8a150133     	and	x19, x9, x21
    1f4c: 8b0400a4     	add	x4, x5, x4
    1f50: cac99ce5     	eor	x5, x7, x9, ror #39
    1f54: aa140267     	orr	x7, x19, x20
    1f58: d285ec13     	mov	x19, #0x2f60            // =12128
    1f5c: 8b010081     	add	x1, x4, x1
    1f60: f2a862f3     	movk	x19, #0x4317, lsl #16
    1f64: 8b0700a7     	add	x7, x5, x7
    1f68: 8b0c0025     	add	x5, x1, x12
    1f6c: f2cc6df3     	movk	x19, #0x636f, lsl #32
    1f70: 8b0100ec     	add	x12, x7, x1
    1f74: a95c9fe4     	ldp	x4, x7, [sp, #0x1c8]
    1f78: 93c538a1     	ror	x1, x5, #0xe
    1f7c: 8a2500d4     	bic	x20, x6, x5
    1f80: 8a050075     	and	x21, x3, x5
    1f84: aa1402b4     	orr	x20, x21, x20
    1f88: f2ef14b3     	movk	x19, #0x78a5, lsl #48
    1f8c: aa0b0135     	orr	x21, x9, x11
    1f90: 8b020082     	add	x2, x4, x2
    1f94: 93cc7184     	ror	x4, x12, #0x1c
    1f98: cac54821     	eor	x1, x1, x5, ror #18
    1f9c: 8b140042     	add	x2, x2, x20
    1fa0: 8a0b0134     	and	x20, x9, x11
    1fa4: 8a150195     	and	x21, x12, x21
    1fa8: cacc8884     	eor	x4, x4, x12, ror #34
    1fac: cac5a421     	eor	x1, x1, x5, ror #41
    1fb0: 8b130042     	add	x2, x2, x19
    1fb4: aa1402b3     	orr	x19, x21, x20
    1fb8: 8b0600e6     	add	x6, x7, x6
    1fbc: aa090195     	orr	x21, x12, x9
    1fc0: cacc9c84     	eor	x4, x4, x12, ror #39
    1fc4: 8b010041     	add	x1, x2, x1
    1fc8: 8b130082     	add	x2, x4, x19
    1fcc: 8b0a0024     	add	x4, x1, x10
    1fd0: 8b01004a     	add	x10, x2, x1
    1fd4: 93c43881     	ror	x1, x4, #0xe
    1fd8: d2956e42     	mov	x2, #0xab72             // =43890
    1fdc: 93ca7147     	ror	x7, x10, #0x1c
    1fe0: f2b43e02     	movk	x2, #0xa1f0, lsl #16
    1fe4: 8a240073     	bic	x19, x3, x4
    1fe8: 8a0400b4     	and	x20, x5, x4
    1fec: cac44821     	eor	x1, x1, x4, ror #18
    1ff0: f2cf0282     	movk	x2, #0x7814, lsl #32
    1ff4: aa130293     	orr	x19, x20, x19
    1ff8: caca88e7     	eor	x7, x7, x10, ror #34
    1ffc: f2f09902     	movk	x2, #0x84c8, lsl #48
    2000: 8b1300c6     	add	x6, x6, x19
    2004: cac4a421     	eor	x1, x1, x4, ror #41
    2008: 8a090194     	and	x20, x12, x9
    200c: 8a150153     	and	x19, x10, x21
    2010: 8b0200c2     	add	x2, x6, x2
    2014: caca9ce6     	eor	x6, x7, x10, ror #39
    2018: aa140267     	orr	x7, x19, x20
    201c: 8b010041     	add	x1, x2, x1
    2020: a95dcfe2     	ldp	x2, x19, [sp, #0x1d8]
    2024: 8b0700c7     	add	x7, x6, x7
    2028: 8b0b0026     	add	x6, x1, x11
    202c: 8b0100e1     	add	x1, x7, x1
    2030: d2873d8b     	mov	x11, #0x39ec            // =14828
    2034: 93c638c7     	ror	x7, x6, #0xe
    2038: f2a34c8b     	movk	x11, #0x1a64, lsl #16
    203c: 8a2600b4     	bic	x20, x5, x6
    2040: 8b030042     	add	x2, x2, x3
    2044: 93c17023     	ror	x3, x1, #0x1c
    2048: 8a060095     	and	x21, x4, x6
    204c: f2c0410b     	movk	x11, #0x208, lsl #32
    2050: cac648e7     	eor	x7, x7, x6, ror #18
    2054: aa1402b4     	orr	x20, x21, x20
    2058: cac18863     	eor	x3, x3, x1, ror #34
    205c: f2f198eb     	movk	x11, #0x8cc7, lsl #48
    2060: aa0c0155     	orr	x21, x10, x12
    2064: 8b140042     	add	x2, x2, x20
    2068: 8a0c0154     	and	x20, x10, x12
    206c: cac6a4e7     	eor	x7, x7, x6, ror #41
    2070: 8a150035     	and	x21, x1, x21
    2074: 8b0b004b     	add	x11, x2, x11
    2078: cac19c62     	eor	x2, x3, x1, ror #39
    207c: aa1402a3     	orr	x3, x21, x20
    2080: 8b07016b     	add	x11, x11, x7
    2084: 8b050265     	add	x5, x19, x5
    2088: 8b030043     	add	x3, x2, x3
    208c: 8b090162     	add	x2, x11, x9
    2090: aa0a0035     	orr	x21, x1, x10
    2094: 8b0b0069     	add	x9, x3, x11
    2098: d283c503     	mov	x3, #0x1e28             // =7720
    209c: 93c2384b     	ror	x11, x2, #0xe
    20a0: 93c97127     	ror	x7, x9, #0x1c
    20a4: f2a46c63     	movk	x3, #0x2363, lsl #16
    20a8: 8a220093     	bic	x19, x4, x2
    20ac: 8a0200d4     	and	x20, x6, x2
    20b0: f2dfff43     	movk	x3, #0xfffa, lsl #32
    20b4: cac2496b     	eor	x11, x11, x2, ror #18
    20b8: aa130293     	orr	x19, x20, x19
    20bc: cac988e7     	eor	x7, x7, x9, ror #34
    20c0: f2f217c3     	movk	x3, #0x90be, lsl #48
    20c4: 8b1300a5     	add	x5, x5, x19
    20c8: 8a0a0034     	and	x20, x1, x10
    20cc: 8a150133     	and	x19, x9, x21
    20d0: 8b0300a3     	add	x3, x5, x3
    20d4: cac99ce5     	eor	x5, x7, x9, ror #39
    20d8: cac2a56b     	eor	x11, x11, x2, ror #41
    20dc: aa140267     	orr	x7, x19, x20
    20e0: 8b0700a5     	add	x5, x5, x7
    20e4: a95e9ff3     	ldp	x19, x7, [sp, #0x1e8]
    20e8: 8b0b006b     	add	x11, x3, x11
    20ec: 8b0c0163     	add	x3, x11, x12
    20f0: 8b0b00ab     	add	x11, x5, x11
    20f4: d297bd2c     	mov	x12, #0xbde9            // =48617
    20f8: 93c33865     	ror	x5, x3, #0xe
    20fc: 8b040264     	add	x4, x19, x4
    2100: 93cb7173     	ror	x19, x11, #0x1c
    2104: f2bbd04c     	movk	x12, #0xde82, lsl #16
    2108: 8a2300d4     	bic	x20, x6, x3
    210c: 8a030055     	and	x21, x2, x3
    2110: f2cd9d6c     	movk	x12, #0x6ceb, lsl #32
    2114: cac348a5     	eor	x5, x5, x3, ror #18
    2118: aa1402b4     	orr	x20, x21, x20
    211c: cacb8a73     	eor	x19, x19, x11, ror #34
    2120: f2f48a0c     	movk	x12, #0xa450, lsl #48
    2124: aa010135     	orr	x21, x9, x1
    2128: 8b140084     	add	x4, x4, x20
    212c: 8a010134     	and	x20, x9, x1
    2130: cac3a4a5     	eor	x5, x5, x3, ror #41
    2134: 8a150175     	and	x21, x11, x21
    2138: 8b0c008c     	add	x12, x4, x12
    213c: cacb9e64     	eor	x4, x19, x11, ror #39
    2140: aa1402b3     	orr	x19, x21, x20
    2144: 8b05018c     	add	x12, x12, x5
    2148: 8b0600e6     	add	x6, x7, x6
    214c: 8b130085     	add	x5, x4, x19
    2150: 8b0a0184     	add	x4, x12, x10
    2154: aa090175     	orr	x21, x11, x9
    2158: 8b0c00aa     	add	x10, x5, x12
    215c: 93c4388c     	ror	x12, x4, #0xe
    2160: d28f22a5     	mov	x5, #0x7915             // =30997
    2164: 93ca7147     	ror	x7, x10, #0x1c
    2168: f2b658c5     	movk	x5, #0xb2c6, lsl #16
    216c: 8a240053     	bic	x19, x2, x4
    2170: 8a040074     	and	x20, x3, x4
    2174: f2d47ee5     	movk	x5, #0xa3f7, lsl #32
    2178: cac4498c     	eor	x12, x12, x4, ror #18
    217c: aa130293     	orr	x19, x20, x19
    2180: caca88e7     	eor	x7, x7, x10, ror #34
    2184: f2f7df25     	movk	x5, #0xbef9, lsl #48
    2188: 8b1300c6     	add	x6, x6, x19
    218c: 8a090174     	and	x20, x11, x9
    2190: cac4a58c     	eor	x12, x12, x4, ror #41
    2194: 8a150153     	and	x19, x10, x21
    2198: 8b0500c5     	add	x5, x6, x5
    219c: caca9ce6     	eor	x6, x7, x10, ror #39
    21a0: aa140267     	orr	x7, x19, x20
    21a4: 8b0c00ac     	add	x12, x5, x12
    21a8: 8b0700c5     	add	x5, x6, x7
    21ac: a95f9fe6     	ldp	x6, x7, [sp, #0x1f8]
    21b0: 8b010181     	add	x1, x12, x1
    21b4: 8b0c00ac     	add	x12, x5, x12
    21b8: 93c13825     	ror	x5, x1, #0xe
    21bc: 8a210073     	bic	x19, x3, x1
    21c0: 8a010094     	and	x20, x4, x1
    21c4: 93cc7195     	ror	x21, x12, #0x1c
    21c8: 8b0200c2     	add	x2, x6, x2
    21cc: aa130286     	orr	x6, x20, x19
    21d0: d28a6573     	mov	x19, #0x532b            // =21291
    21d4: cac148a5     	eor	x5, x5, x1, ror #18
    21d8: 8b060042     	add	x2, x2, x6
    21dc: f2bc6e53     	movk	x19, #0xe372, lsl #16
    21e0: cacc8aa6     	eor	x6, x21, x12, ror #34
    21e4: aa0b0154     	orr	x20, x10, x11
    21e8: f2cf1e53     	movk	x19, #0x78f2, lsl #32
    21ec: cac1a4a5     	eor	x5, x5, x1, ror #41
    21f0: 8a140194     	and	x20, x12, x20
    21f4: f2f8ce33     	movk	x19, #0xc671, lsl #48
    21f8: cacc9cc6     	eor	x6, x6, x12, ror #39
    21fc: 8b0300e3     	add	x3, x7, x3
    2200: 8b130042     	add	x2, x2, x19
    2204: 8a0b0153     	and	x19, x10, x11
    2208: aa130293     	orr	x19, x20, x19
    220c: 8b050045     	add	x5, x2, x5
    2210: 8b1300c6     	add	x6, x6, x19
    2214: 8b0900a2     	add	x2, x5, x9
    2218: 8b0500c9     	add	x9, x6, x5
    221c: 93c23845     	ror	x5, x2, #0xe
    2220: d28c3386     	mov	x6, #0x619c             // =24988
    2224: 93c97127     	ror	x7, x9, #0x1c
    2228: f2bd44c6     	movk	x6, #0xea26, lsl #16
    222c: 8a220093     	bic	x19, x4, x2
    2230: 8a020034     	and	x20, x1, x2
    2234: cac248a5     	eor	x5, x5, x2, ror #18
    2238: f2c7d9c6     	movk	x6, #0x3ece, lsl #32
    223c: aa130293     	orr	x19, x20, x19
    2240: cac988e7     	eor	x7, x7, x9, ror #34
    2244: f2f944e6     	movk	x6, #0xca27, lsl #48
    2248: aa0a0194     	orr	x20, x12, x10
    224c: 8b130063     	add	x3, x3, x19
    2250: cac2a4a5     	eor	x5, x5, x2, ror #41
    2254: 8a0a0193     	and	x19, x12, x10
    2258: 8a140134     	and	x20, x9, x20
    225c: 8b060063     	add	x3, x3, x6
    2260: cac99ce6     	eor	x6, x7, x9, ror #39
    2264: aa130287     	orr	x7, x20, x19
    2268: 8b050065     	add	x5, x3, x5
    226c: 8b0b00a3     	add	x3, x5, x11
    2270: f94107f3     	ldr	x19, [sp, #0x208]
    2274: 8b0700c6     	add	x6, x6, x7
    2278: 8a030054     	and	x20, x2, x3
    227c: 8b0500cb     	add	x11, x6, x5
    2280: 93c33865     	ror	x5, x3, #0xe
    2284: d29840e6     	mov	x6, #0xc207             // =49671
    2288: 93cb7167     	ror	x7, x11, #0x1c
    228c: f2a43806     	movk	x6, #0x21c0, lsl #16
    2290: 8b040264     	add	x4, x19, x4
    2294: 8a230033     	bic	x19, x1, x3
    2298: cac348a5     	eor	x5, x5, x3, ror #18
    229c: f2d718e6     	movk	x6, #0xb8c7, lsl #32
    22a0: aa130293     	orr	x19, x20, x19
    22a4: cacb88e7     	eor	x7, x7, x11, ror #34
    22a8: f2fa30c6     	movk	x6, #0xd186, lsl #48
    22ac: aa0c0134     	orr	x20, x9, x12
    22b0: 8b130084     	add	x4, x4, x19
    22b4: cac3a4a5     	eor	x5, x5, x3, ror #41
    22b8: 8a0c0133     	and	x19, x9, x12
    22bc: 8a140174     	and	x20, x11, x20
    22c0: 8b060084     	add	x4, x4, x6
    22c4: cacb9ce6     	eor	x6, x7, x11, ror #39
    22c8: aa130287     	orr	x7, x20, x19
    22cc: 8b050085     	add	x5, x4, x5
    22d0: 8b0a00a4     	add	x4, x5, x10
    22d4: f9410bf3     	ldr	x19, [sp, #0x210]
    22d8: 8b0700c6     	add	x6, x6, x7
    22dc: 8a040074     	and	x20, x3, x4
    22e0: 8b0500ca     	add	x10, x6, x5
    22e4: 93c43885     	ror	x5, x4, #0xe
    22e8: d29d63c6     	mov	x6, #0xeb1e             // =60190
    22ec: 93ca7147     	ror	x7, x10, #0x1c
    22f0: f2b9bc06     	movk	x6, #0xcde0, lsl #16
    22f4: 8b010261     	add	x1, x19, x1
    22f8: 8a240053     	bic	x19, x2, x4
    22fc: cac448a5     	eor	x5, x5, x4, ror #18
    2300: f2cfbac6     	movk	x6, #0x7dd6, lsl #32
    2304: aa130293     	orr	x19, x20, x19
    2308: caca88e7     	eor	x7, x7, x10, ror #34
    230c: f2fd5b46     	movk	x6, #0xeada, lsl #48
    2310: aa090174     	orr	x20, x11, x9
    2314: 8b130021     	add	x1, x1, x19
    2318: cac4a4a5     	eor	x5, x5, x4, ror #41
    231c: 8a090173     	and	x19, x11, x9
    2320: 8a140154     	and	x20, x10, x20
    2324: 8b060021     	add	x1, x1, x6
    2328: caca9ce6     	eor	x6, x7, x10, ror #39
    232c: aa130287     	orr	x7, x20, x19
    2330: 8b050025     	add	x5, x1, x5
    2334: 8b0c00a1     	add	x1, x5, x12
    2338: f9410ff3     	ldr	x19, [sp, #0x218]
    233c: 8b0700c6     	add	x6, x6, x7
    2340: 8a010094     	and	x20, x4, x1
    2344: 8b0500cc     	add	x12, x6, x5
    2348: 93c13825     	ror	x5, x1, #0xe
    234c: d29a2f06     	mov	x6, #0xd178             // =53624
    2350: 93cc7187     	ror	x7, x12, #0x1c
    2354: f2bdcdc6     	movk	x6, #0xee6e, lsl #16
    2358: 8b020262     	add	x2, x19, x2
    235c: 8a210073     	bic	x19, x3, x1
    2360: cac148a5     	eor	x5, x5, x1, ror #18
    2364: f2c9efe6     	movk	x6, #0x4f7f, lsl #32
    2368: aa130293     	orr	x19, x20, x19
    236c: cacc88e7     	eor	x7, x7, x12, ror #34
    2370: f2feafa6     	movk	x6, #0xf57d, lsl #48
    2374: aa0b0154     	orr	x20, x10, x11
    2378: 8b130042     	add	x2, x2, x19
    237c: cac1a4a5     	eor	x5, x5, x1, ror #41
    2380: 8a0b0153     	and	x19, x10, x11
    2384: 8a140194     	and	x20, x12, x20
    2388: 8b060042     	add	x2, x2, x6
    238c: cacc9ce6     	eor	x6, x7, x12, ror #39
    2390: aa130287     	orr	x7, x20, x19
    2394: 8b050045     	add	x5, x2, x5
    2398: 8b0900a2     	add	x2, x5, x9
    239c: f94113f3     	ldr	x19, [sp, #0x220]
    23a0: 8b0700c6     	add	x6, x6, x7
    23a4: 8a020034     	and	x20, x1, x2
    23a8: 8b0500c9     	add	x9, x6, x5
    23ac: 93c23845     	ror	x5, x2, #0xe
    23b0: d28df746     	mov	x6, #0x6fba             // =28602
    23b4: 93c97127     	ror	x7, x9, #0x1c
    23b8: f2ae42e6     	movk	x6, #0x7217, lsl #16
    23bc: 8b030263     	add	x3, x19, x3
    23c0: 8a220093     	bic	x19, x4, x2
    23c4: cac248a5     	eor	x5, x5, x2, ror #18
    23c8: f2ccf546     	movk	x6, #0x67aa, lsl #32
    23cc: aa130293     	orr	x19, x20, x19
    23d0: cac988e7     	eor	x7, x7, x9, ror #34
    23d4: f2e0de06     	movk	x6, #0x6f0, lsl #48
    23d8: aa0a0194     	orr	x20, x12, x10
    23dc: 8b130063     	add	x3, x3, x19
    23e0: cac2a4a5     	eor	x5, x5, x2, ror #41
    23e4: 8a0a0193     	and	x19, x12, x10
    23e8: 8a140134     	and	x20, x9, x20
    23ec: 8b060063     	add	x3, x3, x6
    23f0: cac99ce6     	eor	x6, x7, x9, ror #39
    23f4: aa130287     	orr	x7, x20, x19
    23f8: 8b050065     	add	x5, x3, x5
    23fc: 8b0b00a3     	add	x3, x5, x11
    2400: f94117f3     	ldr	x19, [sp, #0x228]
    2404: 8b0700c6     	add	x6, x6, x7
    2408: 8a030054     	and	x20, x2, x3
    240c: 8b0500cb     	add	x11, x6, x5
    2410: 93c33865     	ror	x5, x3, #0xe
    2414: d29314c6     	mov	x6, #0x98a6             // =39078
    2418: 93cb7167     	ror	x7, x11, #0x1c
    241c: f2b45906     	movk	x6, #0xa2c8, lsl #16
    2420: 8b040264     	add	x4, x19, x4
    2424: 8a230033     	bic	x19, x1, x3
    2428: cac348a5     	eor	x5, x5, x3, ror #18
    242c: f2cfb8a6     	movk	x6, #0x7dc5, lsl #32
    2430: aa130293     	orr	x19, x20, x19
    2434: cacb88e7     	eor	x7, x7, x11, ror #34
    2438: f2e14c66     	movk	x6, #0xa63, lsl #48
    243c: aa0c0134     	orr	x20, x9, x12
    2440: 8b130084     	add	x4, x4, x19
    2444: cac3a4a5     	eor	x5, x5, x3, ror #41
    2448: 8a0c0133     	and	x19, x9, x12
    244c: 8a140174     	and	x20, x11, x20
    2450: 8b060084     	add	x4, x4, x6
    2454: cacb9ce6     	eor	x6, x7, x11, ror #39
    2458: aa130287     	orr	x7, x20, x19
    245c: 8b050085     	add	x5, x4, x5
    2460: 8b0a00a4     	add	x4, x5, x10
    2464: f9411bf3     	ldr	x19, [sp, #0x230]
    2468: 8b0700c6     	add	x6, x6, x7
    246c: 8a040074     	and	x20, x3, x4
    2470: 8b0500ca     	add	x10, x6, x5
    2474: 93c43885     	ror	x5, x4, #0xe
    2478: d281b5c6     	mov	x6, #0xdae              // =3502
    247c: 93ca7147     	ror	x7, x10, #0x1c
    2480: f2b7df26     	movk	x6, #0xbef9, lsl #16
    2484: 8b010261     	add	x1, x19, x1
    2488: 8a240053     	bic	x19, x2, x4
    248c: cac448a5     	eor	x5, x5, x4, ror #18
    2490: f2d30086     	movk	x6, #0x9804, lsl #32
    2494: aa130293     	orr	x19, x20, x19
    2498: caca88e7     	eor	x7, x7, x10, ror #34
    249c: f2e227e6     	movk	x6, #0x113f, lsl #48
    24a0: aa090174     	orr	x20, x11, x9
    24a4: 8b130021     	add	x1, x1, x19
    24a8: cac4a4a5     	eor	x5, x5, x4, ror #41
    24ac: 8a090173     	and	x19, x11, x9
    24b0: 8a140154     	and	x20, x10, x20
    24b4: 8b060021     	add	x1, x1, x6
    24b8: caca9ce6     	eor	x6, x7, x10, ror #39
    24bc: aa130287     	orr	x7, x20, x19
    24c0: 8b050021     	add	x1, x1, x5
    24c4: 8b0c0025     	add	x5, x1, x12
    24c8: f9411ff3     	ldr	x19, [sp, #0x238]
    24cc: 8b0700c6     	add	x6, x6, x7
    24d0: 8a050094     	and	x20, x4, x5
    24d4: 8b0100cc     	add	x12, x6, x1
    24d8: 93c538a1     	ror	x1, x5, #0xe
    24dc: d288e366     	mov	x6, #0x471b             // =18203
    24e0: 93cc7187     	ror	x7, x12, #0x1c
    24e4: f2a26386     	movk	x6, #0x131c, lsl #16
    24e8: 8b020262     	add	x2, x19, x2
    24ec: 8a250073     	bic	x19, x3, x5
    24f0: cac54821     	eor	x1, x1, x5, ror #18
    24f4: f2c166a6     	movk	x6, #0xb35, lsl #32
    24f8: aa130293     	orr	x19, x20, x19
    24fc: cacc88e7     	eor	x7, x7, x12, ror #34
    2500: f2e36e26     	movk	x6, #0x1b71, lsl #48
    2504: aa0b0154     	orr	x20, x10, x11
    2508: 8b130042     	add	x2, x2, x19
    250c: cac5a421     	eor	x1, x1, x5, ror #41
    2510: 8a0b0153     	and	x19, x10, x11
    2514: 8a140194     	and	x20, x12, x20
    2518: 8b060042     	add	x2, x2, x6
    251c: cacc9ce6     	eor	x6, x7, x12, ror #39
    2520: aa130287     	orr	x7, x20, x19
    2524: 8b010041     	add	x1, x2, x1
    2528: 8b090022     	add	x2, x1, x9
    252c: f94123f3     	ldr	x19, [sp, #0x240]
    2530: 8b0700c6     	add	x6, x6, x7
    2534: 93c23849     	ror	x9, x2, #0xe
    2538: 8a0200b4     	and	x20, x5, x2
    253c: 8b0100c1     	add	x1, x6, x1
    2540: d28fb086     	mov	x6, #0x7d84             // =32132
    2544: 8b030263     	add	x3, x19, x3
    2548: 93c17027     	ror	x7, x1, #0x1c
    254c: f2a46086     	movk	x6, #0x2304, lsl #16
    2550: 8a220093     	bic	x19, x4, x2
    2554: cac24929     	eor	x9, x9, x2, ror #18
    2558: f2cefea6     	movk	x6, #0x77f5, lsl #32
    255c: aa130293     	orr	x19, x20, x19
    2560: cac188e7     	eor	x7, x7, x1, ror #34
    2564: f2e51b66     	movk	x6, #0x28db, lsl #48
    2568: aa0a0194     	orr	x20, x12, x10
    256c: 8b130063     	add	x3, x3, x19
    2570: cac2a529     	eor	x9, x9, x2, ror #41
    2574: 8a0a0193     	and	x19, x12, x10
    2578: 8a140034     	and	x20, x1, x20
    257c: 8b060063     	add	x3, x3, x6
    2580: cac19ce6     	eor	x6, x7, x1, ror #39
    2584: aa130287     	orr	x7, x20, x19
    2588: 8b090069     	add	x9, x3, x9
    258c: f94127f3     	ldr	x19, [sp, #0x248]
    2590: 8b0700c6     	add	x6, x6, x7
    2594: 8b0b0123     	add	x3, x9, x11
    2598: 8b0900cb     	add	x11, x6, x9
    259c: 93c33869     	ror	x9, x3, #0xe
    25a0: d2849266     	mov	x6, #0x2493             // =9363
    25a4: 93cb7167     	ror	x7, x11, #0x1c
    25a8: f2a818e6     	movk	x6, #0x40c7, lsl #16
    25ac: 8b040264     	add	x4, x19, x4
    25b0: 8a2300b3     	bic	x19, x5, x3
    25b4: 8a030054     	and	x20, x2, x3
    25b8: cac34929     	eor	x9, x9, x3, ror #18
    25bc: f2d56f66     	movk	x6, #0xab7b, lsl #32
    25c0: aa130293     	orr	x19, x20, x19
    25c4: cacb88e7     	eor	x7, x7, x11, ror #34
    25c8: f2e65946     	movk	x6, #0x32ca, lsl #48
    25cc: aa0c0034     	orr	x20, x1, x12
    25d0: 8b130084     	add	x4, x4, x19
    25d4: cac3a529     	eor	x9, x9, x3, ror #41
    25d8: 8a0c0033     	and	x19, x1, x12
    25dc: 8a140174     	and	x20, x11, x20
    25e0: 8b060084     	add	x4, x4, x6
    25e4: cacb9ce6     	eor	x6, x7, x11, ror #39
    25e8: aa130287     	orr	x7, x20, x19
    25ec: 8b090089     	add	x9, x4, x9
    25f0: f9412bf3     	ldr	x19, [sp, #0x250]
    25f4: 8b0700c6     	add	x6, x6, x7
    25f8: 8b0a0124     	add	x4, x9, x10
    25fc: 8b0900ca     	add	x10, x6, x9
    2600: 93c43889     	ror	x9, x4, #0xe
    2604: d297d786     	mov	x6, #0xbebc             // =48828
    2608: 93ca7147     	ror	x7, x10, #0x1c
    260c: f2a2b926     	movk	x6, #0x15c9, lsl #16
    2610: 8b050265     	add	x5, x19, x5
    2614: 8a240053     	bic	x19, x2, x4
    2618: 8a040074     	and	x20, x3, x4
    261c: cac44929     	eor	x9, x9, x4, ror #18
    2620: f2d7c146     	movk	x6, #0xbe0a, lsl #32
    2624: aa130293     	orr	x19, x20, x19
    2628: caca88e7     	eor	x7, x7, x10, ror #34
    262c: f2e793c6     	movk	x6, #0x3c9e, lsl #48
    2630: aa010174     	orr	x20, x11, x1
    2634: 8b1300a5     	add	x5, x5, x19
    2638: cac4a529     	eor	x9, x9, x4, ror #41
    263c: 8a010173     	and	x19, x11, x1
    2640: 8a140154     	and	x20, x10, x20
    2644: 8b0600a5     	add	x5, x5, x6
    2648: caca9ce6     	eor	x6, x7, x10, ror #39
    264c: aa130287     	orr	x7, x20, x19
    2650: 8b0900a9     	add	x9, x5, x9
    2654: f9412fe5     	ldr	x5, [sp, #0x258]
    2658: 8b0700c6     	add	x6, x6, x7
    265c: 8b0c012c     	add	x12, x9, x12
    2660: d281a987     	mov	x7, #0xd4c              // =3404
    2664: 8b0900c9     	add	x9, x6, x9
    2668: 93cc3986     	ror	x6, x12, #0xe
    266c: 8b0200a2     	add	x2, x5, x2
    2670: 93c97125     	ror	x5, x9, #0x1c
    2674: f2b38207     	movk	x7, #0x9c10, lsl #16
    2678: 8a2c0073     	bic	x19, x3, x12
    267c: 8a0c0094     	and	x20, x4, x12
    2680: cacc48c6     	eor	x6, x6, x12, ror #18
    2684: f2ccf887     	movk	x7, #0x67c4, lsl #32
    2688: aa130293     	orr	x19, x20, x19
    268c: cac988a5     	eor	x5, x5, x9, ror #34
    2690: f2e863a7     	movk	x7, #0x431d, lsl #48
    2694: aa0b0154     	orr	x20, x10, x11
    2698: 8b130042     	add	x2, x2, x19
    269c: cacca4c6     	eor	x6, x6, x12, ror #41
    26a0: 8a0b0153     	and	x19, x10, x11
    26a4: 8a140134     	and	x20, x9, x20
    26a8: 8b070042     	add	x2, x2, x7
    26ac: cac99ca5     	eor	x5, x5, x9, ror #39
    26b0: aa130287     	orr	x7, x20, x19
    26b4: 8b060046     	add	x6, x2, x6
    26b8: 8b0100c2     	add	x2, x6, x1
    26bc: f94133f3     	ldr	x19, [sp, #0x260]
    26c0: 8b0700a5     	add	x5, x5, x7
    26c4: 8a020194     	and	x20, x12, x2
    26c8: 8b0600a1     	add	x1, x5, x6
    26cc: 93c23845     	ror	x5, x2, #0xe
    26d0: d28856c6     	mov	x6, #0x42b6             // =17078
    26d4: 93c17027     	ror	x7, x1, #0x1c
    26d8: f2b967c6     	movk	x6, #0xcb3e, lsl #16
    26dc: 8b030263     	add	x3, x19, x3
    26e0: 8a220093     	bic	x19, x4, x2
    26e4: cac248a5     	eor	x5, x5, x2, ror #18
    26e8: f2da97c6     	movk	x6, #0xd4be, lsl #32
    26ec: aa130293     	orr	x19, x20, x19
    26f0: cac188e7     	eor	x7, x7, x1, ror #34
    26f4: f2e998a6     	movk	x6, #0x4cc5, lsl #48
    26f8: aa0a0134     	orr	x20, x9, x10
    26fc: 8b130063     	add	x3, x3, x19
    2700: cac2a4a5     	eor	x5, x5, x2, ror #41
    2704: 8a0a0133     	and	x19, x9, x10
    2708: 8a140034     	and	x20, x1, x20
    270c: 8b060063     	add	x3, x3, x6
    2710: cac19ce6     	eor	x6, x7, x1, ror #39
    2714: aa130287     	orr	x7, x20, x19
    2718: 8b050063     	add	x3, x3, x5
    271c: f94137e5     	ldr	x5, [sp, #0x268]
    2720: 8b0b006b     	add	x11, x3, x11
    2724: 8b010231     	add	x17, x17, x1
    2728: 8b0700c6     	add	x6, x6, x7
    272c: d28fc547     	mov	x7, #0x7e2a             // =32298
    2730: 8a2b0193     	bic	x19, x12, x11
    2734: 8b0300c3     	add	x3, x6, x3
    2738: 93cb3966     	ror	x6, x11, #0xe
    273c: 8b0400a4     	add	x4, x5, x4
    2740: 93c37065     	ror	x5, x3, #0x1c
    2744: f2bf8ca7     	movk	x7, #0xfc65, lsl #16
    2748: 8a0b0054     	and	x20, x2, x11
    274c: cacb48c6     	eor	x6, x6, x11, ror #18
    2750: f2c53387     	movk	x7, #0x299c, lsl #32
    2754: aa130293     	orr	x19, x20, x19
    2758: cac388a5     	eor	x5, x5, x3, ror #34
    275c: f2eb2fe7     	movk	x7, #0x597f, lsl #48
    2760: aa090034     	orr	x20, x1, x9
    2764: 8b130084     	add	x4, x4, x19
    2768: cacba4c6     	eor	x6, x6, x11, ror #41
    276c: 8a090033     	and	x19, x1, x9
    2770: 8a140074     	and	x20, x3, x20
    2774: 8b070084     	add	x4, x4, x7
    2778: cac39ca5     	eor	x5, x5, x3, ror #39
    277c: aa130293     	orr	x19, x20, x19
    2780: 8b060084     	add	x4, x4, x6
    2784: f9413be7     	ldr	x7, [sp, #0x270]
    2788: 8b1300a5     	add	x5, x5, x19
    278c: 8b0a008a     	add	x10, x4, x10
    2790: d29f5d94     	mov	x20, #0xfaec            // =64236
    2794: 8b0400a4     	add	x4, x5, x4
    2798: 93ca3945     	ror	x5, x10, #0xe
    279c: 8b0c00ec     	add	x12, x7, x12
    27a0: 8a2a0046     	bic	x6, x2, x10
    27a4: 8a0a0167     	and	x7, x11, x10
    27a8: 93c47093     	ror	x19, x4, #0x1c
    27ac: f2a75ad4     	movk	x20, #0x3ad6, lsl #16
    27b0: caca48a5     	eor	x5, x5, x10, ror #18
    27b4: aa0600e6     	orr	x6, x7, x6
    27b8: f2cdf574     	movk	x20, #0x6fab, lsl #32
    27bc: 8b06018c     	add	x12, x12, x6
    27c0: cac48a66     	eor	x6, x19, x4, ror #34
    27c4: f2ebf974     	movk	x20, #0x5fcb, lsl #48
    27c8: cacaa4a5     	eor	x5, x5, x10, ror #41
    27cc: f9413fe7     	ldr	x7, [sp, #0x278]
    27d0: aa010073     	orr	x19, x3, x1
    27d4: 8b14018c     	add	x12, x12, x20
    27d8: 8a010074     	and	x20, x3, x1
    27dc: 8a130093     	and	x19, x4, x19
    27e0: cac49cc6     	eor	x6, x6, x4, ror #39
    27e4: 8b05018c     	add	x12, x12, x5
    27e8: 8b0200e2     	add	x2, x7, x2
    27ec: aa140267     	orr	x7, x19, x20
    27f0: 8b090189     	add	x9, x12, x9
    27f4: 8b0700c1     	add	x1, x6, x7
    27f8: 8a290167     	bic	x7, x11, x9
    27fc: 8a090153     	and	x19, x10, x9
    2800: 8b030210     	add	x16, x16, x3
    2804: 8b0c002c     	add	x12, x1, x12
    2808: 93c93921     	ror	x1, x9, #0xe
    280c: aa030085     	orr	x5, x4, x3
    2810: 8a030083     	and	x3, x4, x3
    2814: 8b040252     	add	x18, x18, x4
    2818: aa070264     	orr	x4, x19, x7
    281c: 93cc7186     	ror	x6, x12, #0x1c
    2820: cac94821     	eor	x1, x1, x9, ror #18
    2824: 8b040042     	add	x2, x2, x4
    2828: d28b02e4     	mov	x4, #0x5817             // =22551
    282c: a9024012     	stp	x18, x16, [x0, #0x20]
    2830: f2a948e4     	movk	x4, #0x4a47, lsl #16
    2834: cacc88c6     	eor	x6, x6, x12, ror #34
    2838: cac9a421     	eor	x1, x1, x9, ror #41
    283c: f2c33184     	movk	x4, #0x198c, lsl #32
    2840: 8b0901e9     	add	x9, x15, x9
    2844: f2ed8884     	movk	x4, #0x6c44, lsl #48
    2848: 8b040042     	add	x2, x2, x4
    284c: 8a050184     	and	x4, x12, x5
    2850: cacc9cc5     	eor	x5, x6, x12, ror #39
    2854: aa030083     	orr	x3, x4, x3
    2858: 8b010041     	add	x1, x2, x1
    285c: 8b0c01ac     	add	x12, x13, x12
    2860: 8b0300b0     	add	x16, x5, x3
    2864: 8b010231     	add	x17, x17, x1
    2868: 8b01020f     	add	x15, x16, x1
    286c: a9032411     	stp	x17, x9, [x0, #0x30]
    2870: f9402409     	ldr	x9, [x0, #0x48]
    2874: 8b0f0108     	add	x8, x8, x15
    2878: a9013008     	stp	x8, x12, [x0, #0x10]
    287c: 8b0a01c8     	add	x8, x14, x10
    2880: 8b0b0129     	add	x9, x9, x11
    2884: a9042408     	stp	x8, x9, [x0, #0x40]
    2888: 910a03ff     	add	sp, sp, #0x280
    288c: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2890: f9400bf5     	ldr	x21, [sp, #0x10]
    2894: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2898: d65f03c0     	ret

000000000000289c <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    289c: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    28a0: a90157f6     	stp	x22, x21, [sp, #0x10]
    28a4: a9024ff4     	stp	x20, x19, [sp, #0x20]
    28a8: 910003fd     	mov	x29, sp
    28ac: 39434008     	ldrb	w8, [x0, #0xd0]
    28b0: 52801016     	mov	w22, #0x80              // =128
    28b4: 91014015     	add	x21, x0, #0x50
    28b8: aa0103f3     	mov	x19, x1
    28bc: aa0003f4     	mov	x20, x0
    28c0: 2a1f03e1     	mov	w1, wzr
    28c4: cb0802c2     	sub	x2, x22, x8
    28c8: 8b0802a0     	add	x0, x21, x8
<L0>:
    28cc: 94000000     	bl	 <L0>
		00000000000028cc:  R_AARCH64_CALL26	memset
    28d0: 39434288     	ldrb	w8, [x20, #0xd0]
    28d4: 38286ab6     	strb	w22, [x21, x8]
    28d8: 39434288     	ldrb	w8, [x20, #0xd0]
    28dc: 11000509     	add	w9, w8, #0x1
    28e0: 7101bd1f     	cmp	w8, #0x6f
    28e4: 39034289     	strb	w9, [x20, #0xd0]
    28e8: 54000129     	b.ls	 <L1>
    28ec: aa1403e0     	mov	x0, x20
    28f0: aa1503e1     	mov	x1, x21
    28f4: 97fff7f9     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    28f8: 6f00e400     	movi	v0.2d, #0000000000000000
    28fc: ad0082a0     	stp	q0, q0, [x21, #0x10]
    2900: ad0182a0     	stp	q0, q0, [x21, #0x30]
    2904: ad0282a0     	stp	q0, q0, [x21, #0x50]
    2908: 3d8002a0     	str	q0, [x21]
<L1>:
    290c: f9400688     	ldr	x8, [x20, #0x8]
    2910: aa1403e0     	mov	x0, x20
    2914: aa1503e1     	mov	x1, x21
    2918: d375fd09     	lsr	x9, x8, #53
    291c: d36dfd0a     	lsr	x10, x8, #45
    2920: d34dfd0b     	lsr	x11, x8, #13
    2924: 1e270120     	fmov	s0, w9
    2928: d365fd09     	lsr	x9, x8, #37
    292c: 4e031d40     	mov	v0.b[1], w10
    2930: f940028a     	ldr	x10, [x20]
    2934: 93ca950c     	extr	x12, x8, x10, #0x25
    2938: 93cab50e     	extr	x14, x8, x10, #0x2d
    293c: 93cad50d     	extr	x13, x8, x10, #0x35
    2940: 4e051d20     	mov	v0.b[2], w9
    2944: d35dfd09     	lsr	x9, x8, #29
    2948: 4e071d20     	mov	v0.b[3], w9
    294c: d355fd09     	lsr	x9, x8, #21
    2950: 4e091d20     	mov	v0.b[4], w9
    2954: 93ca7509     	extr	x9, x8, x10, #0x1d
    2958: 9e670124     	fmov	d4, x9
    295c: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		000000000000295c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst16
    2960: 9e670183     	fmov	d3, x12
    2964: 3dc00125     	ldr	q5, [x9]
		0000000000002964:  R_AARCH64_LDST128_ABS_LO12_NC	.rodata.cst16
    2968: d345fd09     	lsr	x9, x8, #5
    296c: 4e0b1d60     	mov	v0.b[5], w11
    2970: 9e6701c2     	fmov	d2, x14
    2974: 93caf508     	extr	x8, x8, x10, #0x3d
    2978: 9e6701a1     	fmov	d1, x13
    297c: 53057d4b     	lsr	w11, w10, #5
    2980: 39033a8b     	strb	w11, [x20, #0xce]
    2984: 4e056021     	tbl	v1.16b, { v1.16b, v2.16b, v3.16b, v4.16b }, v5.16b
    2988: 4e0d1d20     	mov	v0.b[6], w9
    298c: 531d7149     	lsl	w9, w10, #3
    2990: 39033e89     	strb	w9, [x20, #0xcf]
    2994: 530d7d49     	lsr	w9, w10, #13
    2998: 53157d4a     	lsr	w10, w10, #21
    299c: 0e212821     	xtn	v1.8b, v1.8h
    29a0: 4e0f1d00     	mov	v0.b[7], w8
    29a4: 39033689     	strb	w9, [x20, #0xcd]
    29a8: 3903328a     	strb	w10, [x20, #0xcc]
    29ac: bd00ca81     	str	s1, [x20, #0xc8]
    29b0: fd006280     	str	d0, [x20, #0xc0]
    29b4: 97fff7c9     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    29b8: f9400a88     	ldr	x8, [x20, #0x10]
    29bc: dac00d08     	rev	x8, x8
    29c0: f9000268     	str	x8, [x19]
    29c4: f9400e88     	ldr	x8, [x20, #0x18]
    29c8: dac00d08     	rev	x8, x8
    29cc: f9000668     	str	x8, [x19, #0x8]
    29d0: f9401288     	ldr	x8, [x20, #0x20]
    29d4: dac00d08     	rev	x8, x8
    29d8: f9000a68     	str	x8, [x19, #0x10]
    29dc: f9401688     	ldr	x8, [x20, #0x28]
    29e0: dac00d08     	rev	x8, x8
    29e4: f9000e68     	str	x8, [x19, #0x18]
    29e8: f9401a88     	ldr	x8, [x20, #0x30]
    29ec: dac00d08     	rev	x8, x8
    29f0: f9001268     	str	x8, [x19, #0x20]
    29f4: f9401e88     	ldr	x8, [x20, #0x38]
    29f8: dac00d08     	rev	x8, x8
    29fc: f9001668     	str	x8, [x19, #0x28]
    2a00: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2a04: a94157f6     	ldp	x22, x21, [sp, #0x10]
    2a08: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2a0c: d65f03c0     	ret

0000000000002a10 <audit_master384>:
    2a10: d10703ff     	sub	sp, sp, #0x1c0
    2a14: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
    2a18: a91b4ffc     	stp	x28, x19, [sp, #0x1b0]
    2a1c: 910683fd     	add	x29, sp, #0x1a0
    2a20: ad400400     	ldp	q0, q1, [x0]
    2a24: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002a24:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x12d
    2a28: 91000129     	add	x9, x9, #0x0
		0000000000002a28:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x12d
    2a2c: 52860008     	mov	w8, #0x3000             // =12288
    2a30: 9000000a     	adrp	x10, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002a30:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xf0
    2a34: 9100014a     	add	x10, x10, #0x0
		0000000000002a34:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xf0
    2a38: 7900c3e8     	strh	w8, [sp, #0x60]
    2a3c: 528001a8     	mov	w8, #0xd                // =13
    2a40: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
    2a44: ad400520     	ldp	q0, q1, [x9]
    2a48: f940014b     	ldr	x11, [x10]
    2a4c: 39018be8     	strb	w8, [sp, #0x62]
    2a50: f8405148     	ldur	x8, [x10, #0x5]
    2a54: 3dc00802     	ldr	q2, [x0, #0x20]
    2a58: aa0103f3     	mov	x19, x1
    2a5c: 910183ea     	add	x10, sp, #0x60
    2a60: 3c8713e0     	stur	q0, [sp, #0x71]
    2a64: 3dc00920     	ldr	q0, [x9, #0x20]
    2a68: 9100c3e0     	add	x0, sp, #0x30
    2a6c: f80633eb     	stur	x11, [sp, #0x63]
    2a70: 910183e2     	add	x2, sp, #0x60
    2a74: d100c3a4     	sub	x4, x29, #0x30
    2a78: f90037e8     	str	x8, [sp, #0x68]
    2a7c: 52800608     	mov	w8, #0x30               // =48
    2a80: 52800601     	mov	w1, #0x30               // =48
    2a84: 52800823     	mov	w3, #0x41               // =65
    2a88: 3c9f03a2     	stur	q2, [x29, #-0x10]
    2a8c: 3c821141     	stur	q1, [x10, #0x21]
    2a90: 3901c3e8     	strb	w8, [sp, #0x70]
    2a94: 3c831140     	stur	q0, [x10, #0x31]
    2a98: 97fff577     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    2a9c: 90000002     	adrp	x2, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002a9c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xfd
    2aa0: 91000042     	add	x2, x2, #0x0
		0000000000002aa0:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xfd
    2aa4: 910003e0     	mov	x0, sp
    2aa8: 9100c3e1     	add	x1, sp, #0x30
    2aac: 94000009     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    2ab0: ad4007e0     	ldp	q0, q1, [sp]
    2ab4: 3dc00be2     	ldr	q2, [sp, #0x20]
    2ab8: ad000660     	stp	q0, q1, [x19]
    2abc: 3d800a62     	str	q2, [x19, #0x20]
    2ac0: a95b4ffc     	ldp	x28, x19, [sp, #0x1b0]
    2ac4: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
    2ac8: 910703ff     	add	sp, sp, #0x1c0
    2acc: d65f03c0     	ret

0000000000002ad0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2ad0: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    2ad4: a9016ffc     	stp	x28, x27, [sp, #0x10]
    2ad8: a90267fa     	stp	x26, x25, [sp, #0x20]
    2adc: a9035ff8     	stp	x24, x23, [sp, #0x30]
    2ae0: a90457f6     	stp	x22, x21, [sp, #0x40]
    2ae4: a9054ff4     	stp	x20, x19, [sp, #0x50]
    2ae8: 910003fd     	mov	x29, sp
    2aec: d10f43ff     	sub	sp, sp, #0x3d0
    2af0: 6f00e401     	movi	v1.2d, #0000000000000000
    2af4: ad400820     	ldp	q0, q2, [x1]
    2af8: 3dc00823     	ldr	q3, [x1, #0x20]
    2afc: aa0203f4     	mov	x20, x2
    2b00: aa0003f3     	mov	x19, x0
    2b04: aa1f03e8     	mov	x8, xzr
    2b08: 910443f7     	add	x23, sp, #0x110
    2b0c: 9109c3e9     	add	x9, sp, #0x270
    2b10: 52800b8a     	mov	w10, #0x5c              // =92
    2b14: ad138be0     	stp	q0, q2, [sp, #0x270]
    2b18: ad1487e3     	stp	q3, q1, [sp, #0x290]
    2b1c: ad1587e1     	stp	q1, q1, [sp, #0x2b0]
    2b20: ad1687e1     	stp	q1, q1, [sp, #0x2d0]
<L0>:
    2b24: 3868692b     	ldrb	w11, [x9, x8]
    2b28: 8b0802ec     	add	x12, x23, x8
    2b2c: 91000508     	add	x8, x8, #0x1
    2b30: f102011f     	cmp	x8, #0x80
    2b34: 4a0a016b     	eor	w11, w11, w10
    2b38: 3903818b     	strb	w11, [x12, #0xe0]
    2b3c: 54ffff41     	b.ne	 <L0>
    2b40: aa1f03e8     	mov	x8, xzr
    2b44: 9109c3e9     	add	x9, sp, #0x270
    2b48: 528006ca     	mov	w10, #0x36              // =54
    2b4c: d10383ab     	sub	x11, x29, #0xe0
<L1>:
    2b50: 3868692c     	ldrb	w12, [x9, x8]
    2b54: 4a0a018c     	eor	w12, w12, w10
    2b58: 3828696c     	strb	w12, [x11, x8]
    2b5c: 91000508     	add	x8, x8, #0x1
    2b60: f102011f     	cmp	x8, #0x80
    2b64: 54ffff61     	b.ne	 <L1>
    2b68: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002b68:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x10
    2b6c: 91000108     	add	x8, x8, #0x0
		0000000000002b6c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x10
    2b70: 910443e0     	add	x0, sp, #0x110
    2b74: ad450500     	ldp	q0, q1, [x8, #0xa0]
    2b78: d10383a1     	sub	x1, x29, #0xe0
    2b7c: 910443f9     	add	x25, sp, #0x110
    2b80: d10383b8     	sub	x24, x29, #0xe0
    2b84: ad0603e1     	stp	q1, q0, [sp, #0xc0]
    2b88: ad0d87e0     	stp	q0, q1, [sp, #0x1b0]
    2b8c: ad460900     	ldp	q0, q2, [x8, #0xc0]
    2b90: ad0503e2     	stp	q2, q0, [sp, #0xa0]
    2b94: ad0e8be0     	stp	q0, q2, [sp, #0x1d0]
    2b98: ad430101     	ldp	q1, q0, [x8, #0x60]
    2b9c: ad0407e0     	stp	q0, q1, [sp, #0x80]
    2ba0: ad0b83e1     	stp	q1, q0, [sp, #0x170]
    2ba4: ad440102     	ldp	q2, q0, [x8, #0x80]
    2ba8: ad030be0     	stp	q0, q2, [sp, #0x60]
    2bac: ad0c83e2     	stp	q2, q0, [sp, #0x190]
    2bb0: ad410101     	ldp	q1, q0, [x8, #0x20]
    2bb4: ad0207e0     	stp	q0, q1, [sp, #0x40]
    2bb8: ad0983e1     	stp	q1, q0, [sp, #0x130]
    2bbc: ad420102     	ldp	q2, q0, [x8, #0x40]
    2bc0: ad010be0     	stp	q0, q2, [sp, #0x20]
    2bc4: ad0a83e2     	stp	q2, q0, [sp, #0x150]
    2bc8: ad400101     	ldp	q1, q0, [x8]
    2bcc: ad0007e0     	stp	q0, q1, [sp]
    2bd0: ad0883e1     	stp	q1, q0, [sp, #0x110]
    2bd4: 97fff741     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2bd8: a95127e8     	ldp	x8, x9, [sp, #0x110]
    2bdc: b102011a     	adds	x26, x8, #0x80
    2be0: 394783e8     	ldrb	w8, [sp, #0x1e0]
    2be4: 9a89353b     	cinc	x27, x9, hs
    2be8: a9116ffa     	stp	x26, x27, [sp, #0x110]
    2bec: 34000248     	cbz	w8,  <L3>
    2bf0: 7101411f     	cmp	w8, #0x50
    2bf4: 54000203     	b.lo	 <L3>
    2bf8: 52801009     	mov	w9, #0x80               // =128
    2bfc: 910443ea     	add	x10, sp, #0x110
    2c00: aa1403e1     	mov	x1, x20
    2c04: cb080135     	sub	x21, x9, x8
    2c08: 91014156     	add	x22, x10, #0x50
    2c0c: 8b0802c0     	add	x0, x22, x8
    2c10: aa1503e2     	mov	x2, x21
<L2>:
    2c14: 94000000     	bl	 <L2>
		0000000000002c14:  R_AARCH64_CALL26	memcpy
    2c18: 910443e0     	add	x0, sp, #0x110
    2c1c: aa1603e1     	mov	x1, x22
    2c20: 97fff72e     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2c24: a9516ffa     	ldp	x26, x27, [sp, #0x110]
    2c28: 2a1f03e8     	mov	w8, wzr
    2c2c: 390783ff     	strb	wzr, [sp, #0x1e0]
    2c30: 14000002     	b	 <L4>
<L3>:
    2c34: aa1f03f5     	mov	x21, xzr
<L4>:
    2c38: 52800609     	mov	w9, #0x30               // =48
    2c3c: 8b284328     	add	x8, x25, w8, uxtw
    2c40: 8b150281     	add	x1, x20, x21
    2c44: cb150136     	sub	x22, x9, x21
    2c48: 91014100     	add	x0, x8, #0x50
    2c4c: aa1603e2     	mov	x2, x22
<L5>:
    2c50: 94000000     	bl	 <L5>
		0000000000002c50:  R_AARCH64_CALL26	memcpy
    2c54: 394783e8     	ldrb	w8, [sp, #0x1e0]
    2c58: b100c349     	adds	x9, x26, #0x30
    2c5c: 910443e0     	add	x0, sp, #0x110
    2c60: 9a9b376a     	cinc	x10, x27, hs
    2c64: 9109c3e1     	add	x1, sp, #0x270
    2c68: 0b160108     	add	w8, w8, w22
    2c6c: a9112be9     	stp	x9, x10, [sp, #0x110]
    2c70: 9109c3f6     	add	x22, sp, #0x270
    2c74: 390783e8     	strb	w8, [sp, #0x1e0]
    2c78: 97ffff09     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2c7c: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    2c80: d10383a0     	sub	x0, x29, #0xe0
    2c84: 910382e1     	add	x1, x23, #0xe0
    2c88: 91014314     	add	x20, x24, #0x50
    2c8c: ad3e03a1     	stp	q1, q0, [x29, #-0x40]
    2c90: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
    2c94: ad3f03a1     	stp	q1, q0, [x29, #-0x20]
    2c98: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    2c9c: ad3c03a1     	stp	q1, q0, [x29, #-0x80]
    2ca0: ad4307e0     	ldp	q0, q1, [sp, #0x60]
    2ca4: ad3d03a1     	stp	q1, q0, [x29, #-0x60]
    2ca8: ad4207e0     	ldp	q0, q1, [sp, #0x40]
    2cac: ad3a03a1     	stp	q1, q0, [x29, #-0xc0]
    2cb0: ad4107e0     	ldp	q0, q1, [sp, #0x20]
    2cb4: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
    2cb8: ad4007e0     	ldp	q0, q1, [sp]
    2cbc: ad3903a1     	stp	q1, q0, [x29, #-0xe0]
    2cc0: 97fff706     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2cc4: a9722ba9     	ldp	x9, x10, [x29, #-0xe0]
    2cc8: 385f03a8     	ldurb	w8, [x29, #-0x10]
    2ccc: b1020138     	adds	x24, x9, #0x80
    2cd0: 9a8a3557     	cinc	x23, x10, hs
    2cd4: a9325fb8     	stp	x24, x23, [x29, #-0xe0]
    2cd8: 34000208     	cbz	w8,  <L7>
    2cdc: 7101411f     	cmp	w8, #0x50
    2ce0: 540001c3     	b.lo	 <L7>
    2ce4: 52801009     	mov	w9, #0x80               // =128
    2ce8: 8b080280     	add	x0, x20, x8
    2cec: 9109c3e1     	add	x1, sp, #0x270
    2cf0: cb080135     	sub	x21, x9, x8
    2cf4: aa1503e2     	mov	x2, x21
<L6>:
    2cf8: 94000000     	bl	 <L6>
		0000000000002cf8:  R_AARCH64_CALL26	memcpy
    2cfc: d10383a0     	sub	x0, x29, #0xe0
    2d00: aa1403e1     	mov	x1, x20
    2d04: 97fff6f5     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2d08: a9725fb8     	ldp	x24, x23, [x29, #-0xe0]
    2d0c: 2a1f03e8     	mov	w8, wzr
    2d10: 381f03bf     	sturb	wzr, [x29, #-0x10]
    2d14: 14000002     	b	 <L8>
<L7>:
    2d18: aa1f03f5     	mov	x21, xzr
<L8>:
    2d1c: 52800609     	mov	w9, #0x30               // =48
    2d20: 8b284280     	add	x0, x20, w8, uxtw
    2d24: 8b1502c1     	add	x1, x22, x21
    2d28: cb150134     	sub	x20, x9, x21
    2d2c: aa1403e2     	mov	x2, x20
<L9>:
    2d30: 94000000     	bl	 <L9>
		0000000000002d30:  R_AARCH64_CALL26	memcpy
    2d34: 385f03a8     	ldurb	w8, [x29, #-0x10]
    2d38: b100c309     	adds	x9, x24, #0x30
    2d3c: d10383a0     	sub	x0, x29, #0xe0
    2d40: 9a9736ea     	cinc	x10, x23, hs
    2d44: 910383e1     	add	x1, sp, #0xe0
    2d48: 0b140108     	add	w8, w8, w20
    2d4c: a9322ba9     	stp	x9, x10, [x29, #-0xe0]
    2d50: 381f03a8     	sturb	w8, [x29, #-0x10]
    2d54: 97fffed2     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2d58: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    2d5c: 3dc043e2     	ldr	q2, [sp, #0x100]
    2d60: 3d800a62     	str	q2, [x19, #0x20]
    2d64: ad000660     	stp	q0, q1, [x19]
    2d68: 910f43ff     	add	sp, sp, #0x3d0
    2d6c: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    2d70: a94457f6     	ldp	x22, x21, [sp, #0x40]
    2d74: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    2d78: a94267fa     	ldp	x26, x25, [sp, #0x20]
    2d7c: a9416ffc     	ldp	x28, x27, [sp, #0x10]
    2d80: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    2d84: d65f03c0     	ret

0000000000002d88 <audit_handshake384>:
    2d88: d10743ff     	sub	sp, sp, #0x1d0
    2d8c: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
    2d90: f900dbfc     	str	x28, [sp, #0x1b0]
    2d94: a91c4ff4     	stp	x20, x19, [sp, #0x1c0]
    2d98: 910683fd     	add	x29, sp, #0x1a0
    2d9c: ad400400     	ldp	q0, q1, [x0]
    2da0: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002da0:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x12d
    2da4: 91000108     	add	x8, x8, #0x0
		0000000000002da4:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x12d
    2da8: 52860009     	mov	w9, #0x3000             // =12288
    2dac: 9000000a     	adrp	x10, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002dac:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xf0
    2db0: 9100014a     	add	x10, x10, #0x0
		0000000000002db0:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xf0
    2db4: 7900c3e9     	strh	w9, [sp, #0x60]
    2db8: 528001a9     	mov	w9, #0xd                // =13
    2dbc: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
    2dc0: ad400500     	ldp	q0, q1, [x8]
    2dc4: f940014b     	ldr	x11, [x10]
    2dc8: 39018be9     	strb	w9, [sp, #0x62]
    2dcc: f8405149     	ldur	x9, [x10, #0x5]
    2dd0: 3dc00802     	ldr	q2, [x0, #0x20]
    2dd4: aa0203f3     	mov	x19, x2
    2dd8: aa0103f4     	mov	x20, x1
    2ddc: 3c8713e0     	stur	q0, [sp, #0x71]
    2de0: 3dc00900     	ldr	q0, [x8, #0x20]
    2de4: 910183ea     	add	x10, sp, #0x60
    2de8: f80633eb     	stur	x11, [sp, #0x63]
    2dec: 9100c3e0     	add	x0, sp, #0x30
    2df0: 910183e2     	add	x2, sp, #0x60
    2df4: f90037e9     	str	x9, [sp, #0x68]
    2df8: 52800609     	mov	w9, #0x30               // =48
    2dfc: d100c3a4     	sub	x4, x29, #0x30
    2e00: 52800601     	mov	w1, #0x30               // =48
    2e04: 52800823     	mov	w3, #0x41               // =65
    2e08: 3c9f03a2     	stur	q2, [x29, #-0x10]
    2e0c: 3c821141     	stur	q1, [x10, #0x21]
    2e10: 3901c3e9     	strb	w9, [sp, #0x70]
    2e14: 3c831140     	stur	q0, [x10, #0x31]
    2e18: 97fff497     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    2e1c: 910003e0     	mov	x0, sp
    2e20: 9100c3e1     	add	x1, sp, #0x30
    2e24: aa1403e2     	mov	x2, x20
    2e28: 97ffff2a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    2e2c: ad4007e0     	ldp	q0, q1, [sp]
    2e30: 3dc00be2     	ldr	q2, [sp, #0x20]
    2e34: ad000660     	stp	q0, q1, [x19]
    2e38: 3d800a62     	str	q2, [x19, #0x20]
    2e3c: a95c4ff4     	ldp	x20, x19, [sp, #0x1c0]
    2e40: f940dbfc     	ldr	x28, [sp, #0x1b0]
    2e44: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
    2e48: 910743ff     	add	sp, sp, #0x1d0
    2e4c: d65f03c0     	ret

0000000000002e50 <audit_key256>:
    2e50: d10543ff     	sub	sp, sp, #0x150
    2e54: a9137bfd     	stp	x29, x30, [sp, #0x130]
    2e58: f900a3fc     	str	x28, [sp, #0x140]
    2e5c: 9104c3fd     	add	x29, sp, #0x130
    2e60: ad400400     	ldp	q0, q1, [x0]
    2e64: d10083a8     	sub	x8, x29, #0x20
    2e68: 52820009     	mov	w9, #0x1000             // =4096
    2e6c: 910013e2     	add	x2, sp, #0x4
    2e70: d10083a4     	sub	x4, x29, #0x20
    2e74: 79000be9     	strh	w9, [sp, #0x4]
    2e78: 52800129     	mov	w9, #0x9                // =9
    2e7c: aa0103e0     	mov	x0, x1
    2e80: ad000500     	stp	q0, q1, [x8]
    2e84: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1728>
		0000000000002e84:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
    2e88: 91000108     	add	x8, x8, #0x0
		0000000000002e88:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
    2e8c: f9400108     	ldr	x8, [x8]
    2e90: 52800201     	mov	w1, #0x10               // =16
    2e94: 528001a3     	mov	w3, #0xd                // =13
    2e98: 39001be9     	strb	w9, [sp, #0x6]
    2e9c: f80073e8     	stur	x8, [sp, #0x7]
    2ea0: 52800f28     	mov	w8, #0x79               // =121
    2ea4: 7800f3e8     	sturh	w8, [sp, #0xf]
    2ea8: 94000005     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    2eac: a9537bfd     	ldp	x29, x30, [sp, #0x130]
    2eb0: f940a3fc     	ldr	x28, [sp, #0x140]
    2eb4: 910543ff     	add	sp, sp, #0x150
    2eb8: d65f03c0     	ret

0000000000002ebc <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
    2ebc: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    2ec0: a9016ffc     	stp	x28, x27, [sp, #0x10]
    2ec4: a90267fa     	stp	x26, x25, [sp, #0x20]
    2ec8: a9035ff8     	stp	x24, x23, [sp, #0x30]
    2ecc: a90457f6     	stp	x22, x21, [sp, #0x40]
    2ed0: a9054ff4     	stp	x20, x19, [sp, #0x50]
    2ed4: 910003fd     	mov	x29, sp
    2ed8: d10883ff     	sub	sp, sp, #0x220
    2edc: aa0303f5     	mov	x21, x3
    2ee0: aa0203f6     	mov	x22, x2
    2ee4: aa0003f3     	mov	x19, x0
    2ee8: 52800028     	mov	w8, #0x1                // =1
    2eec: f100803f     	cmp	x1, #0x20
    2ef0: 910303fa     	add	x26, sp, #0xc0
    2ef4: 390033e8     	strb	w8, [sp, #0xc]
    2ef8: 54000322     	b.hs	 <L1>
    2efc: aa0103f4     	mov	x20, x1
    2f00: 910303e0     	add	x0, sp, #0xc0
    2f04: aa0403e1     	mov	x1, x4
    2f08: 910303f9     	add	x25, sp, #0xc0
    2f0c: 940000f7     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
    2f10: 3944a3e8     	ldrb	w8, [sp, #0x128]
    2f14: 34000508     	cbz	w8,  <L3>
    2f18: 8b0802a9     	add	x9, x21, x8
    2f1c: f101013f     	cmp	x9, #0x40
    2f20: 540004a3     	b.lo	 <L3>
    2f24: 52800809     	mov	w9, #0x40               // =64
    2f28: 910303ea     	add	x10, sp, #0xc0
    2f2c: aa1603e1     	mov	x1, x22
    2f30: cb080138     	sub	x24, x9, x8
    2f34: 9100a157     	add	x23, x10, #0x28
    2f38: 8b0802e0     	add	x0, x23, x8
    2f3c: aa1803e2     	mov	x2, x24
<L0>:
    2f40: 94000000     	bl	 <L0>
		0000000000002f40:  R_AARCH64_CALL26	memcpy
    2f44: 910303e0     	add	x0, sp, #0xc0
    2f48: aa1703e1     	mov	x1, x23
    2f4c: 94000163     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    2f50: 2a1f03e8     	mov	w8, wzr
    2f54: 3904a3ff     	strb	wzr, [sp, #0x128]
    2f58: 14000018     	b	 <L4>
<L1>:
    2f5c: 910043f9     	add	x25, sp, #0x10
    2f60: 910043e0     	add	x0, sp, #0x10
    2f64: aa0403e1     	mov	x1, x4
    2f68: 9100a334     	add	x20, x25, #0x28
    2f6c: 940000df     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
    2f70: 3941e3e8     	ldrb	w8, [sp, #0x78]
    2f74: 340005a8     	cbz	w8,  <L8>
    2f78: d24016a9     	eor	x9, x21, #0x3f
    2f7c: eb08013f     	cmp	x9, x8
    2f80: 54000542     	b.hs	 <L8>
    2f84: 52800809     	mov	w9, #0x40               // =64
    2f88: 8b080280     	add	x0, x20, x8
    2f8c: aa1603e1     	mov	x1, x22
    2f90: cb080137     	sub	x23, x9, x8
    2f94: aa1703e2     	mov	x2, x23
<L2>:
    2f98: 94000000     	bl	 <L2>
		0000000000002f98:  R_AARCH64_CALL26	memcpy
    2f9c: 910043e0     	add	x0, sp, #0x10
    2fa0: aa1403e1     	mov	x1, x20
    2fa4: 9400014d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    2fa8: 2a1f03e8     	mov	w8, wzr
    2fac: 3901e3ff     	strb	wzr, [sp, #0x78]
    2fb0: 1400001f     	b	 <L9>
<L3>:
    2fb4: aa1f03f8     	mov	x24, xzr
<L4>:
    2fb8: 9100a337     	add	x23, x25, #0x28
    2fbc: cb1802b9     	sub	x25, x21, x24
    2fc0: 8b1802c1     	add	x1, x22, x24
    2fc4: 8b2842e0     	add	x0, x23, w8, uxtw
    2fc8: aa1903e2     	mov	x2, x25
<L5>:
    2fcc: 94000000     	bl	 <L5>
		0000000000002fcc:  R_AARCH64_CALL26	memcpy
    2fd0: 3944a3e8     	ldrb	w8, [sp, #0x128]
    2fd4: f9401349     	ldr	x9, [x26, #0x20]
    2fd8: 2b190108     	adds	w8, w8, w25
    2fdc: 8b150138     	add	x24, x9, x21
    2fe0: 3904a3e8     	strb	w8, [sp, #0x128]
    2fe4: f9001358     	str	x24, [x26, #0x20]
    2fe8: 540005a0     	b.eq	 <L12>
    2fec: 7100fd1f     	cmp	w8, #0x3f
    2ff0: 54000563     	b.lo	 <L12>
    2ff4: 52800809     	mov	w9, #0x40               // =64
    2ff8: 8b2842e0     	add	x0, x23, w8, uxtw
    2ffc: 910033e1     	add	x1, sp, #0xc
<L6>:
    3000: 4b080135     	sub	w21, w9, w8
    3004: aa1503e2     	mov	x2, x21
<L7>:
    3008: 94000000     	bl	 <L7>
		0000000000003008:  R_AARCH64_CALL26	memcpy
    300c: 910303e0     	add	x0, sp, #0xc0
    3010: aa1703e1     	mov	x1, x23
    3014: 94000131     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3018: f9401358     	ldr	x24, [x26, #0x20]
    301c: 2a1f03e8     	mov	w8, wzr
    3020: 3904a3ff     	strb	wzr, [sp, #0x128]
    3024: 1400001f     	b	 <L13>
<L8>:
    3028: aa1f03f7     	mov	x23, xzr
<L9>:
    302c: 8b284280     	add	x0, x20, w8, uxtw
    3030: cb1702b8     	sub	x24, x21, x23
    3034: 8b1702c1     	add	x1, x22, x23
    3038: aa1803e2     	mov	x2, x24
    303c: d101c3bb     	sub	x27, x29, #0x70
<L10>:
    3040: 94000000     	bl	 <L10>
		0000000000003040:  R_AARCH64_CALL26	memcpy
    3044: 3941e3e8     	ldrb	w8, [sp, #0x78]
    3048: f9401be9     	ldr	x9, [sp, #0x30]
    304c: 2b180108     	adds	w8, w8, w24
    3050: 8b150137     	add	x23, x9, x21
    3054: 3901e3e8     	strb	w8, [sp, #0x78]
    3058: f9001bf7     	str	x23, [sp, #0x30]
    305c: 540008a0     	b.eq	 <L16>
    3060: 7100fd1f     	cmp	w8, #0x3f
    3064: 54000863     	b.lo	 <L16>
    3068: 52800809     	mov	w9, #0x40               // =64
    306c: 8b284280     	add	x0, x20, w8, uxtw
    3070: 910033e1     	add	x1, sp, #0xc
    3074: 4b080135     	sub	w21, w9, w8
    3078: aa1503e2     	mov	x2, x21
<L11>:
    307c: 94000000     	bl	 <L11>
		000000000000307c:  R_AARCH64_CALL26	memcpy
    3080: 910043e0     	add	x0, sp, #0x10
    3084: aa1403e1     	mov	x1, x20
    3088: 94000114     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    308c: f9401bf7     	ldr	x23, [sp, #0x30]
    3090: 2a1f03e8     	mov	w8, wzr
    3094: 3901e3ff     	strb	wzr, [sp, #0x78]
    3098: 14000037     	b	 <L17>
<L12>:
    309c: aa1f03f5     	mov	x21, xzr
<L13>:
    30a0: 52800029     	mov	w9, #0x1                // =1
    30a4: 8b2842e0     	add	x0, x23, w8, uxtw
    30a8: 910033e8     	add	x8, sp, #0xc
    30ac: cb150136     	sub	x22, x9, x21
    30b0: 8b150101     	add	x1, x8, x21
    30b4: aa1603e2     	mov	x2, x22
<L14>:
    30b8: 94000000     	bl	 <L14>
		00000000000030b8:  R_AARCH64_CALL26	memcpy
    30bc: 3944a3e8     	ldrb	w8, [sp, #0x128]
    30c0: 91000709     	add	x9, x24, #0x1
    30c4: 910303e0     	add	x0, sp, #0xc0
    30c8: d10243a1     	sub	x1, x29, #0x90
    30cc: f9001349     	str	x9, [x26, #0x20]
    30d0: 910303f5     	add	x21, sp, #0xc0
    30d4: 0b160108     	add	w8, w8, w22
    30d8: d10243b7     	sub	x23, x29, #0x90
    30dc: 3904a3e8     	strb	w8, [sp, #0x128]
    30e0: 940000b2     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    30e4: 90000008     	adrp	x8, 0x3000 <L6>
		00000000000030e4:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x160
    30e8: 91000108     	add	x8, x8, #0x0
		00000000000030e8:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x160
    30ec: d101c3a0     	sub	x0, x29, #0x70
    30f0: ad420500     	ldp	q0, q1, [x8, #0x40]
    30f4: 3dc01902     	ldr	q2, [x8, #0x60]
    30f8: 9101c2a1     	add	x1, x21, #0x70
    30fc: d101c3b5     	sub	x21, x29, #0x70
    3100: 3d805742     	str	q2, [x26, #0x150]
    3104: ad098740     	stp	q0, q1, [x26, #0x130]
    3108: ad400500     	ldp	q0, q1, [x8]
    310c: ad078740     	stp	q0, q1, [x26, #0xf0]
    3110: ad410900     	ldp	q0, q2, [x8, #0x20]
    3114: ad088b40     	stp	q0, q2, [x26, #0x110]
    3118: 940000f0     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    311c: f9408b49     	ldr	x9, [x26, #0x110]
    3120: 385f83a8     	ldurb	w8, [x29, #-0x8]
    3124: 9100a2b5     	add	x21, x21, #0x28
    3128: 91010138     	add	x24, x9, #0x40
    312c: f9008b58     	str	x24, [x26, #0x110]
    3130: 34000868     	cbz	w8,  <L20>
    3134: 7100811f     	cmp	w8, #0x20
    3138: 54000823     	b.lo	 <L20>
    313c: 52800809     	mov	w9, #0x40               // =64
    3140: 8b0802a0     	add	x0, x21, x8
    3144: d10243a1     	sub	x1, x29, #0x90
    3148: cb080136     	sub	x22, x9, x8
    314c: aa1603e2     	mov	x2, x22
<L15>:
    3150: 94000000     	bl	 <L15>
		0000000000003150:  R_AARCH64_CALL26	memcpy
    3154: d101c3a0     	sub	x0, x29, #0x70
    3158: aa1503e1     	mov	x1, x21
    315c: 940000df     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3160: f9408b58     	ldr	x24, [x26, #0x110]
    3164: 2a1f03e8     	mov	w8, wzr
    3168: 381f83bf     	sturb	wzr, [x29, #-0x8]
    316c: 14000035     	b	 <L21>
<L16>:
    3170: aa1f03f5     	mov	x21, xzr
<L17>:
    3174: 52800029     	mov	w9, #0x1                // =1
    3178: 8b284280     	add	x0, x20, w8, uxtw
    317c: 910033e8     	add	x8, sp, #0xc
    3180: cb150136     	sub	x22, x9, x21
    3184: 8b150101     	add	x1, x8, x21
    3188: 9100a374     	add	x20, x27, #0x28
    318c: aa1603e2     	mov	x2, x22
<L18>:
    3190: 94000000     	bl	 <L18>
		0000000000003190:  R_AARCH64_CALL26	memcpy
    3194: 3941e3e8     	ldrb	w8, [sp, #0x78]
    3198: 910006e9     	add	x9, x23, #0x1
    319c: 910043e0     	add	x0, sp, #0x10
    31a0: d10243a1     	sub	x1, x29, #0x90
    31a4: f9001be9     	str	x9, [sp, #0x30]
    31a8: 0b160108     	add	w8, w8, w22
    31ac: d10243b6     	sub	x22, x29, #0x90
    31b0: 3901e3e8     	strb	w8, [sp, #0x78]
    31b4: 9400007d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    31b8: 90000008     	adrp	x8, 0x3000 <L6>
		00000000000031b8:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x160
    31bc: 91000108     	add	x8, x8, #0x0
		00000000000031bc:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x160
    31c0: d101c3a0     	sub	x0, x29, #0x70
    31c4: ad420500     	ldp	q0, q1, [x8, #0x40]
    31c8: 3dc01902     	ldr	q2, [x8, #0x60]
    31cc: 9101c321     	add	x1, x25, #0x70
    31d0: 3d805742     	str	q2, [x26, #0x150]
    31d4: ad098740     	stp	q0, q1, [x26, #0x130]
    31d8: ad400500     	ldp	q0, q1, [x8]
    31dc: ad078740     	stp	q0, q1, [x26, #0xf0]
    31e0: ad410900     	ldp	q0, q2, [x8, #0x20]
    31e4: ad088b40     	stp	q0, q2, [x26, #0x110]
    31e8: 940000bc     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    31ec: f9408b49     	ldr	x9, [x26, #0x110]
    31f0: 385f83a8     	ldurb	w8, [x29, #-0x8]
    31f4: 91010137     	add	x23, x9, #0x40
    31f8: f9008b57     	str	x23, [x26, #0x110]
    31fc: 34000488     	cbz	w8,  <L24>
    3200: 7100811f     	cmp	w8, #0x20
    3204: 54000443     	b.lo	 <L24>
    3208: 52800809     	mov	w9, #0x40               // =64
    320c: 8b080280     	add	x0, x20, x8
    3210: d10243a1     	sub	x1, x29, #0x90
    3214: cb080135     	sub	x21, x9, x8
    3218: aa1503e2     	mov	x2, x21
<L19>:
    321c: 94000000     	bl	 <L19>
		000000000000321c:  R_AARCH64_CALL26	memcpy
    3220: d101c3a0     	sub	x0, x29, #0x70
    3224: aa1403e1     	mov	x1, x20
    3228: 940000ac     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    322c: f9408b57     	ldr	x23, [x26, #0x110]
    3230: 2a1f03e8     	mov	w8, wzr
    3234: 381f83bf     	sturb	wzr, [x29, #-0x8]
    3238: 14000016     	b	 <L25>
<L20>:
    323c: aa1f03f6     	mov	x22, xzr
<L21>:
    3240: 52800409     	mov	w9, #0x20               // =32
    3244: 8b2842a0     	add	x0, x21, w8, uxtw
    3248: 8b1602e1     	add	x1, x23, x22
    324c: cb160135     	sub	x21, x9, x22
    3250: aa1503e2     	mov	x2, x21
<L22>:
    3254: 94000000     	bl	 <L22>
		0000000000003254:  R_AARCH64_CALL26	memcpy
    3258: 385f83a8     	ldurb	w8, [x29, #-0x8]
    325c: 91008309     	add	x9, x24, #0x20
    3260: d101c3a0     	sub	x0, x29, #0x70
    3264: d102c3a1     	sub	x1, x29, #0xb0
    3268: f9008b49     	str	x9, [x26, #0x110]
    326c: 0b150108     	add	w8, w8, w21
    3270: 381f83a8     	sturb	w8, [x29, #-0x8]
    3274: 9400004d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3278: d102c3a1     	sub	x1, x29, #0xb0
    327c: aa1303e0     	mov	x0, x19
    3280: aa1403e2     	mov	x2, x20
<L23>:
    3284: 94000000     	bl	 <L23>
		0000000000003284:  R_AARCH64_CALL26	memcpy
    3288: 14000010     	b	 <L27>
<L24>:
    328c: aa1f03f5     	mov	x21, xzr
<L25>:
    3290: 52800409     	mov	w9, #0x20               // =32
    3294: 8b284280     	add	x0, x20, w8, uxtw
    3298: 8b1502c1     	add	x1, x22, x21
    329c: cb150134     	sub	x20, x9, x21
    32a0: aa1403e2     	mov	x2, x20
<L26>:
    32a4: 94000000     	bl	 <L26>
		00000000000032a4:  R_AARCH64_CALL26	memcpy
    32a8: 385f83a8     	ldurb	w8, [x29, #-0x8]
    32ac: 910082e9     	add	x9, x23, #0x20
    32b0: d101c3a0     	sub	x0, x29, #0x70
    32b4: aa1303e1     	mov	x1, x19
    32b8: f9008b49     	str	x9, [x26, #0x110]
    32bc: 0b140108     	add	w8, w8, w20
    32c0: 381f83a8     	sturb	w8, [x29, #-0x8]
    32c4: 94000039     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
<L27>:
    32c8: 910883ff     	add	sp, sp, #0x220
    32cc: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    32d0: a94457f6     	ldp	x22, x21, [sp, #0x40]
    32d4: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    32d8: a94267fa     	ldp	x26, x25, [sp, #0x20]
    32dc: a9416ffc     	ldp	x28, x27, [sp, #0x10]
    32e0: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    32e4: d65f03c0     	ret

00000000000032e8 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>:
    32e8: d10443ff     	sub	sp, sp, #0x110
    32ec: a90f7bfd     	stp	x29, x30, [sp, #0xf0]
    32f0: a9104ffc     	stp	x28, x19, [sp, #0x100]
    32f4: 9103c3fd     	add	x29, sp, #0xf0
    32f8: 4f02e780     	movi	v0.16b, #0x5c
    32fc: ad400424     	ldp	q4, q1, [x1]
    3300: 4f01e6c2     	movi	v2.16b, #0x36
    3304: 90000008     	adrp	x8, 0x3000 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x144>
		0000000000003304:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x160
    3308: 91000108     	add	x8, x8, #0x0
		0000000000003308:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x160
    330c: aa0003f3     	mov	x19, x0
    3310: 910003e0     	mov	x0, sp
    3314: d10103a1     	sub	x1, x29, #0x40
    3318: 6e201c23     	eor	v3.16b, v1.16b, v0.16b
    331c: 3d802be0     	str	q0, [sp, #0xa0]
    3320: 6e221c21     	eor	v1.16b, v1.16b, v2.16b
    3324: ad3f0ba2     	stp	q2, q2, [x29, #-0x20]
    3328: ad0403e3     	stp	q3, q0, [sp, #0x80]
    332c: 6e221c83     	eor	v3.16b, v4.16b, v2.16b
    3330: 6e201c80     	eor	v0.16b, v4.16b, v0.16b
    3334: ad3e07a3     	stp	q3, q1, [x29, #-0x40]
    3338: ad420d02     	ldp	q2, q3, [x8, #0x40]
    333c: 3dc01901     	ldr	q1, [x8, #0x60]
    3340: ad020fe2     	stp	q2, q3, [sp, #0x40]
    3344: ad0303e1     	stp	q1, q0, [sp, #0x60]
    3348: ad400102     	ldp	q2, q0, [x8]
    334c: ad0003e2     	stp	q2, q0, [sp]
    3350: ad410500     	ldp	q0, q1, [x8, #0x20]
    3354: ad0107e0     	stp	q0, q1, [sp, #0x20]
    3358: 94000060     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    335c: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    3360: f94013e8     	ldr	x8, [sp, #0x20]
    3364: 91010108     	add	x8, x8, #0x40
    3368: ad040660     	stp	q0, q1, [x19, #0x80]
    336c: 3dc02be0     	ldr	q0, [sp, #0xa0]
    3370: f90013e8     	str	x8, [sp, #0x20]
    3374: 3d802a60     	str	q0, [x19, #0xa0]
    3378: ad4203e1     	ldp	q1, q0, [sp, #0x40]
    337c: ad020261     	stp	q1, q0, [x19, #0x40]
    3380: ad430be0     	ldp	q0, q2, [sp, #0x60]
    3384: ad030a60     	stp	q0, q2, [x19, #0x60]
    3388: ad4003e1     	ldp	q1, q0, [sp]
    338c: ad000261     	stp	q1, q0, [x19]
    3390: ad410be0     	ldp	q0, q2, [sp, #0x20]
    3394: ad010a60     	stp	q0, q2, [x19, #0x20]
    3398: a9504ffc     	ldp	x28, x19, [sp, #0x100]
    339c: a94f7bfd     	ldp	x29, x30, [sp, #0xf0]
    33a0: 910443ff     	add	sp, sp, #0x110
    33a4: d65f03c0     	ret

00000000000033a8 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
    33a8: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    33ac: f9000bf5     	str	x21, [sp, #0x10]
    33b0: a9024ff4     	stp	x20, x19, [sp, #0x20]
    33b4: 910003fd     	mov	x29, sp
    33b8: 3941a009     	ldrb	w9, [x0, #0x68]
    33bc: 52800808     	mov	w8, #0x40               // =64
    33c0: 9100a015     	add	x21, x0, #0x28
    33c4: aa0103f3     	mov	x19, x1
    33c8: aa0003f4     	mov	x20, x0
    33cc: 2a1f03e1     	mov	w1, wzr
    33d0: cb090102     	sub	x2, x8, x9
    33d4: 8b0902a0     	add	x0, x21, x9
<L0>:
    33d8: 94000000     	bl	 <L0>
		00000000000033d8:  R_AARCH64_CALL26	memset
    33dc: 3941a288     	ldrb	w8, [x20, #0x68]
    33e0: 52801009     	mov	w9, #0x80               // =128
    33e4: 38286aa9     	strb	w9, [x21, x8]
    33e8: 3941a288     	ldrb	w8, [x20, #0x68]
    33ec: 11000509     	add	w9, w8, #0x1
    33f0: 7100dd1f     	cmp	w8, #0x37
    33f4: 3901a289     	strb	w9, [x20, #0x68]
    33f8: 54000109     	b.ls	 <L1>
    33fc: aa1403e0     	mov	x0, x20
    3400: aa1503e1     	mov	x1, x21
    3404: 94000035     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3408: 6f00e400     	movi	v0.2d, #0000000000000000
    340c: f9001abf     	str	xzr, [x21, #0x30]
    3410: ad0082a0     	stp	q0, q0, [x21, #0x10]
    3414: 3d8002a0     	str	q0, [x21]
<L1>:
    3418: f9401288     	ldr	x8, [x20, #0x20]
    341c: aa1403e0     	mov	x0, x20
    3420: aa1503e1     	mov	x1, x21
    3424: 531d7109     	lsl	w9, w8, #3
    3428: d345fd0a     	lsr	x10, x8, #5
    342c: 39019e89     	strb	w9, [x20, #0x67]
    3430: d34dfd09     	lsr	x9, x8, #13
    3434: 39019a8a     	strb	w10, [x20, #0x66]
    3438: d355fd0a     	lsr	x10, x8, #21
    343c: 39019689     	strb	w9, [x20, #0x65]
    3440: d35dfd09     	lsr	x9, x8, #29
    3444: 3901928a     	strb	w10, [x20, #0x64]
    3448: d365fd0a     	lsr	x10, x8, #37
    344c: 39018e89     	strb	w9, [x20, #0x63]
    3450: d36dfd09     	lsr	x9, x8, #45
    3454: d375fd08     	lsr	x8, x8, #53
    3458: 39018a8a     	strb	w10, [x20, #0x62]
    345c: 39018689     	strb	w9, [x20, #0x61]
    3460: 39018288     	strb	w8, [x20, #0x60]
    3464: 9400001d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3468: b9400288     	ldr	w8, [x20]
    346c: 5ac00908     	rev	w8, w8
    3470: b9000268     	str	w8, [x19]
    3474: b9400688     	ldr	w8, [x20, #0x4]
    3478: 5ac00908     	rev	w8, w8
    347c: b9000668     	str	w8, [x19, #0x4]
    3480: b9400a88     	ldr	w8, [x20, #0x8]
    3484: 5ac00908     	rev	w8, w8
    3488: b9000a68     	str	w8, [x19, #0x8]
    348c: b9400e88     	ldr	w8, [x20, #0xc]
    3490: 5ac00908     	rev	w8, w8
    3494: b9000e68     	str	w8, [x19, #0xc]
    3498: b9401288     	ldr	w8, [x20, #0x10]
    349c: 5ac00908     	rev	w8, w8
    34a0: b9001268     	str	w8, [x19, #0x10]
    34a4: b9401688     	ldr	w8, [x20, #0x14]
    34a8: 5ac00908     	rev	w8, w8
    34ac: b9001668     	str	w8, [x19, #0x14]
    34b0: b9401a88     	ldr	w8, [x20, #0x18]
    34b4: 5ac00908     	rev	w8, w8
    34b8: b9001a68     	str	w8, [x19, #0x18]
    34bc: b9401e88     	ldr	w8, [x20, #0x1c]
    34c0: 5ac00908     	rev	w8, w8
    34c4: b9001e68     	str	w8, [x19, #0x1c]
    34c8: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    34cc: f9400bf5     	ldr	x21, [sp, #0x10]
    34d0: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    34d4: d65f03c0     	ret

00000000000034d8 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
    34d8: d10443ff     	sub	sp, sp, #0x110
    34dc: a9107bfd     	stp	x29, x30, [sp, #0x100]
    34e0: 910403fd     	add	x29, sp, #0x100
    34e4: ad400420     	ldp	q0, q1, [x1]
    34e8: 910003e8     	mov	x8, sp
    34ec: ad410c22     	ldp	q2, q3, [x1, #0x20]
    34f0: 91010108     	add	x8, x8, #0x40
    34f4: 52800609     	mov	w9, #0x30               // =48
    34f8: 6e200800     	rev32	v0.16b, v0.16b
    34fc: 6e200821     	rev32	v1.16b, v1.16b
    3500: 6e200842     	rev32	v2.16b, v2.16b
    3504: 6e200863     	rev32	v3.16b, v3.16b
    3508: ad0007e0     	stp	q0, q1, [sp]
    350c: ad010fe2     	stp	q2, q3, [sp, #0x20]
<L0>:
    3510: 2978290e     	ldp	w14, w10, [x8, #-0x40]
    3514: b85f810b     	ldur	w11, [x8, #-0x8]
    3518: b85e410f     	ldur	w15, [x8, #-0x1c]
    351c: f1000529     	subs	x9, x9, #0x1
    3520: 138a1d4c     	ror	w12, w10, #0x7
    3524: 138b456d     	ror	w13, w11, #0x11
    3528: 4aca498c     	eor	w12, w12, w10, ror #18
    352c: 4acb4dad     	eor	w13, w13, w11, ror #19
    3530: 4a4a0d8a     	eor	w10, w12, w10, lsr #3
    3534: 0b0e01ec     	add	w12, w15, w14
    3538: 4a4b29ab     	eor	w11, w13, w11, lsr #10
    353c: 0b0a018a     	add	w10, w12, w10
    3540: 0b0b014a     	add	w10, w10, w11
    3544: b800450a     	str	w10, [x8], #0x4
    3548: 54fffe41     	b.ne	 <L0>
    354c: 2941b009     	ldp	w9, w12, [x0, #0xc]
    3550: 29402c08     	ldp	w8, w11, [x0]
    3554: 2942b40f     	ldp	w15, w13, [x0, #0x14]
    3558: 1e26000e     	fmov	w14, s0
    355c: 138c1990     	ror	w16, w12, #0x6
    3560: b9401c11     	ldr	w17, [x0, #0x1c]
    3564: 13880902     	ror	w2, w8, #0x2
    3568: b940080a     	ldr	w10, [x0, #0x8]
    356c: 52889223     	mov	w3, #0x4491             // =17553
    3570: 0a2c01b2     	bic	w18, w13, w12
    3574: 0a0c01e1     	and	w1, w15, w12
    3578: 4acc2e10     	eor	w16, w16, w12, ror #11
    357c: 0b0e022e     	add	w14, w17, w14
    3580: 5285f311     	mov	w17, #0x2f98            // =12184
    3584: 2a120032     	orr	w18, w1, w18
    3588: 4ac83441     	eor	w1, w2, w8, ror #13
    358c: 72a85151     	movk	w17, #0x428a, lsl #16
    3590: 2a0b0142     	orr	w2, w10, w11
    3594: 0b1201ce     	add	w14, w14, w18
    3598: 4acc6610     	eor	w16, w16, w12, ror #25
    359c: 0a080052     	and	w18, w2, w8
    35a0: 0b1101ce     	add	w14, w14, w17
    35a4: 4ac85831     	eor	w17, w1, w8, ror #22
    35a8: 0a0b0141     	and	w1, w10, w11
    35ac: 2a010252     	orr	w18, w18, w1
    35b0: 0b0e0210     	add	w16, w16, w14
    35b4: 72ae26e3     	movk	w3, #0x7137, lsl #16
    35b8: 0b110251     	add	w17, w18, w17
    35bc: 0b09020e     	add	w14, w16, w9
    35c0: 0b100229     	add	w9, w17, w16
    35c4: 138e19d0     	ror	w16, w14, #0x6
    35c8: 0a0e0182     	and	w2, w12, w14
    35cc: 2940c7e1     	ldp	w1, w17, [sp, #0x4]
    35d0: 13890932     	ror	w18, w9, #0x2
    35d4: 4ace2e10     	eor	w16, w16, w14, ror #11
    35d8: ad400c02     	ldp	q2, q3, [x0]
    35dc: 0b0101ad     	add	w13, w13, w1
    35e0: 0a2e01e1     	bic	w1, w15, w14
    35e4: 4ac93652     	eor	w18, w18, w9, ror #13
    35e8: 2a010041     	orr	w1, w2, w1
    35ec: 2a080162     	orr	w2, w11, w8
    35f0: 4ace6610     	eor	w16, w16, w14, ror #25
    35f4: 0b0101ad     	add	w13, w13, w1
    35f8: 4ac95a52     	eor	w18, w18, w9, ror #22
    35fc: 0a020121     	and	w1, w9, w2
    3600: 0a080162     	and	w2, w11, w8
    3604: 0b0301ad     	add	w13, w13, w3
    3608: 0b1101ef     	add	w15, w15, w17
    360c: 2a020021     	orr	w1, w1, w2
    3610: 0b1001b0     	add	w16, w13, w16
    3614: 2a080131     	orr	w17, w9, w8
    3618: 0b010252     	add	w18, w18, w1
    361c: 0b0a020d     	add	w13, w16, w10
    3620: 0b10024a     	add	w10, w18, w16
    3624: 138d19b2     	ror	w18, w13, #0x6
    3628: 0a2d0182     	bic	w2, w12, w13
    362c: 138a0941     	ror	w1, w10, #0x2
    3630: 0a0d01c3     	and	w3, w14, w13
    3634: 529f79f0     	mov	w16, #0xfbcf            // =64463
    3638: 4acd2e52     	eor	w18, w18, w13, ror #11
    363c: 2a020062     	orr	w2, w3, w2
    3640: 72b6b810     	movk	w16, #0xb5c0, lsl #16
    3644: 4aca3421     	eor	w1, w1, w10, ror #13
    3648: 0a080123     	and	w3, w9, w8
    364c: 0a110151     	and	w17, w10, w17
    3650: 0b0201ef     	add	w15, w15, w2
    3654: 4acd6652     	eor	w18, w18, w13, ror #25
    3658: 2a030231     	orr	w17, w17, w3
    365c: 4aca5821     	eor	w1, w1, w10, ror #22
    3660: 0b1001ef     	add	w15, w15, w16
    3664: 529b74b0     	mov	w16, #0xdba5            // =56229
    3668: 0b1201f2     	add	w18, w15, w18
    366c: 72bd36b0     	movk	w16, #0xe9b5, lsl #16
    3670: 0b110031     	add	w17, w1, w17
    3674: 0b0b024f     	add	w15, w18, w11
    3678: 0b12022b     	add	w11, w17, w18
    367c: 138f19e1     	ror	w1, w15, #0x6
    3680: 0a0f01a3     	and	w3, w13, w15
    3684: 2941cbf1     	ldp	w17, w18, [sp, #0xc]
    3688: 138b0962     	ror	w2, w11, #0x2
    368c: 4acf2c21     	eor	w1, w1, w15, ror #11
    3690: 0b11018c     	add	w12, w12, w17
    3694: 0a2f01d1     	bic	w17, w14, w15
    3698: 4acb3442     	eor	w2, w2, w11, ror #13
    369c: 2a110071     	orr	w17, w3, w17
    36a0: 2a090143     	orr	w3, w10, w9
    36a4: 4acf6421     	eor	w1, w1, w15, ror #25
    36a8: 0b11018c     	add	w12, w12, w17
    36ac: 0a090151     	and	w17, w10, w9
    36b0: 0a030163     	and	w3, w11, w3
    36b4: 4acb5842     	eor	w2, w2, w11, ror #22
    36b8: 2a110071     	orr	w17, w3, w17
    36bc: 0b10018c     	add	w12, w12, w16
    36c0: 0b010190     	add	w16, w12, w1
    36c4: 0b0e024e     	add	w14, w18, w14
    36c8: 2a0a0172     	orr	w18, w11, w10
    36cc: 0b110051     	add	w17, w2, w17
    36d0: 0b08020c     	add	w12, w16, w8
    36d4: 0b100228     	add	w8, w17, w16
    36d8: 138c1991     	ror	w17, w12, #0x6
    36dc: 0a2c01a2     	bic	w2, w13, w12
    36e0: 13880901     	ror	w1, w8, #0x2
    36e4: 0a0c01e3     	and	w3, w15, w12
    36e8: 52984b70     	mov	w16, #0xc25b            // =49755
    36ec: 4acc2e31     	eor	w17, w17, w12, ror #11
    36f0: 2a020062     	orr	w2, w3, w2
    36f4: 72a72ad0     	movk	w16, #0x3956, lsl #16
    36f8: 4ac83421     	eor	w1, w1, w8, ror #13
    36fc: 0a0a0163     	and	w3, w11, w10
    3700: 0a120112     	and	w18, w8, w18
    3704: 0b0201ce     	add	w14, w14, w2
    3708: 4acc6631     	eor	w17, w17, w12, ror #25
    370c: 2a030252     	orr	w18, w18, w3
    3710: 4ac85821     	eor	w1, w1, w8, ror #22
    3714: 0b1001ce     	add	w14, w14, w16
    3718: 52823e30     	mov	w16, #0x11f1            // =4593
    371c: 0b1101d1     	add	w17, w14, w17
    3720: 72ab3e30     	movk	w16, #0x59f1, lsl #16
    3724: 0b120032     	add	w18, w1, w18
    3728: 0b09022e     	add	w14, w17, w9
    372c: 0b110249     	add	w9, w18, w17
    3730: 138e19c1     	ror	w1, w14, #0x6
    3734: 0a0e0183     	and	w3, w12, w14
    3738: 2942cbf1     	ldp	w17, w18, [sp, #0x14]
    373c: 13890922     	ror	w2, w9, #0x2
    3740: 4ace2c21     	eor	w1, w1, w14, ror #11
    3744: 0b0d022d     	add	w13, w17, w13
    3748: 0a2e01f1     	bic	w17, w15, w14
    374c: 4ac93442     	eor	w2, w2, w9, ror #13
    3750: 2a110071     	orr	w17, w3, w17
    3754: 2a0b0103     	orr	w3, w8, w11
    3758: 4ace6421     	eor	w1, w1, w14, ror #25
    375c: 0b1101ad     	add	w13, w13, w17
    3760: 0a0b0111     	and	w17, w8, w11
    3764: 0a030123     	and	w3, w9, w3
    3768: 4ac95842     	eor	w2, w2, w9, ror #22
    376c: 2a110071     	orr	w17, w3, w17
    3770: 0b1001ad     	add	w13, w13, w16
    3774: 0b0101b0     	add	w16, w13, w1
    3778: 0b0f024f     	add	w15, w18, w15
    377c: 2a080132     	orr	w18, w9, w8
    3780: 0b110051     	add	w17, w2, w17
    3784: 0b0a020d     	add	w13, w16, w10
    3788: 0b10022a     	add	w10, w17, w16
    378c: 138d19b1     	ror	w17, w13, #0x6
    3790: 0a2d0182     	bic	w2, w12, w13
    3794: 138a0941     	ror	w1, w10, #0x2
    3798: 0a0d01c3     	and	w3, w14, w13
    379c: 52905490     	mov	w16, #0x82a4            // =33444
    37a0: 4acd2e31     	eor	w17, w17, w13, ror #11
    37a4: 2a020062     	orr	w2, w3, w2
    37a8: 72b247f0     	movk	w16, #0x923f, lsl #16
    37ac: 4aca3421     	eor	w1, w1, w10, ror #13
    37b0: 0a080123     	and	w3, w9, w8
    37b4: 0a120152     	and	w18, w10, w18
    37b8: 0b0201ef     	add	w15, w15, w2
    37bc: 4acd6631     	eor	w17, w17, w13, ror #25
    37c0: 2a030252     	orr	w18, w18, w3
    37c4: 4aca5821     	eor	w1, w1, w10, ror #22
    37c8: 0b1001ef     	add	w15, w15, w16
    37cc: 528bdab0     	mov	w16, #0x5ed5            // =24277
    37d0: 0b1101f1     	add	w17, w15, w17
    37d4: 72b56390     	movk	w16, #0xab1c, lsl #16
    37d8: 0b120032     	add	w18, w1, w18
    37dc: 0b0b022f     	add	w15, w17, w11
    37e0: 0b11024b     	add	w11, w18, w17
    37e4: 138f19e1     	ror	w1, w15, #0x6
    37e8: 0a0f01a3     	and	w3, w13, w15
    37ec: 2943cbf1     	ldp	w17, w18, [sp, #0x1c]
    37f0: 138b0962     	ror	w2, w11, #0x2
    37f4: 4acf2c21     	eor	w1, w1, w15, ror #11
    37f8: 0b0c022c     	add	w12, w17, w12
    37fc: 0a2f01d1     	bic	w17, w14, w15
    3800: 4acb3442     	eor	w2, w2, w11, ror #13
    3804: 2a110071     	orr	w17, w3, w17
    3808: 2a090143     	orr	w3, w10, w9
    380c: 4acf6421     	eor	w1, w1, w15, ror #25
    3810: 0b11018c     	add	w12, w12, w17
    3814: 0a090151     	and	w17, w10, w9
    3818: 0a030163     	and	w3, w11, w3
    381c: 4acb5842     	eor	w2, w2, w11, ror #22
    3820: 2a110071     	orr	w17, w3, w17
    3824: 0b10018c     	add	w12, w12, w16
    3828: 0b010190     	add	w16, w12, w1
    382c: 0b0e024e     	add	w14, w18, w14
    3830: 2a0a0172     	orr	w18, w11, w10
    3834: 0b110051     	add	w17, w2, w17
    3838: 0b08020c     	add	w12, w16, w8
    383c: 0b100228     	add	w8, w17, w16
    3840: 138c1991     	ror	w17, w12, #0x6
    3844: 0a2c01a2     	bic	w2, w13, w12
    3848: 13880901     	ror	w1, w8, #0x2
    384c: 0a0c01e3     	and	w3, w15, w12
    3850: 52955310     	mov	w16, #0xaa98            // =43672
    3854: 4acc2e31     	eor	w17, w17, w12, ror #11
    3858: 2a020062     	orr	w2, w3, w2
    385c: 72bb00f0     	movk	w16, #0xd807, lsl #16
    3860: 4ac83421     	eor	w1, w1, w8, ror #13
    3864: 0a0a0163     	and	w3, w11, w10
    3868: 0a120112     	and	w18, w8, w18
    386c: 0b0201ce     	add	w14, w14, w2
    3870: 4acc6631     	eor	w17, w17, w12, ror #25
    3874: 2a030252     	orr	w18, w18, w3
    3878: 4ac85821     	eor	w1, w1, w8, ror #22
    387c: 0b1001ce     	add	w14, w14, w16
    3880: 528b6030     	mov	w16, #0x5b01            // =23297
    3884: 0b1101d1     	add	w17, w14, w17
    3888: 72a25070     	movk	w16, #0x1283, lsl #16
    388c: 0b120032     	add	w18, w1, w18
    3890: 0b09022e     	add	w14, w17, w9
    3894: 0b110249     	add	w9, w18, w17
    3898: 138e19c1     	ror	w1, w14, #0x6
    389c: 0a0e0183     	and	w3, w12, w14
    38a0: 2944cbf1     	ldp	w17, w18, [sp, #0x24]
    38a4: 13890922     	ror	w2, w9, #0x2
    38a8: 4ace2c21     	eor	w1, w1, w14, ror #11
    38ac: 0b0d022d     	add	w13, w17, w13
    38b0: 0a2e01f1     	bic	w17, w15, w14
    38b4: 4ac93442     	eor	w2, w2, w9, ror #13
    38b8: 2a110071     	orr	w17, w3, w17
    38bc: 2a0b0103     	orr	w3, w8, w11
    38c0: 4ace6421     	eor	w1, w1, w14, ror #25
    38c4: 0b1101ad     	add	w13, w13, w17
    38c8: 0a0b0111     	and	w17, w8, w11
    38cc: 0a030123     	and	w3, w9, w3
    38d0: 4ac95842     	eor	w2, w2, w9, ror #22
    38d4: 2a110071     	orr	w17, w3, w17
    38d8: 0b1001ad     	add	w13, w13, w16
    38dc: 0b0101b0     	add	w16, w13, w1
    38e0: 0b0f024f     	add	w15, w18, w15
    38e4: 2a080132     	orr	w18, w9, w8
    38e8: 0b110051     	add	w17, w2, w17
    38ec: 0b0a020d     	add	w13, w16, w10
    38f0: 0b10022a     	add	w10, w17, w16
    38f4: 138d19b1     	ror	w17, w13, #0x6
    38f8: 0a2d0182     	bic	w2, w12, w13
    38fc: 138a0941     	ror	w1, w10, #0x2
    3900: 0a0d01c3     	and	w3, w14, w13
    3904: 5290b7d0     	mov	w16, #0x85be            // =34238
    3908: 4acd2e31     	eor	w17, w17, w13, ror #11
    390c: 2a020062     	orr	w2, w3, w2
    3910: 72a48630     	movk	w16, #0x2431, lsl #16
    3914: 4aca3421     	eor	w1, w1, w10, ror #13
    3918: 0a080123     	and	w3, w9, w8
    391c: 0a120152     	and	w18, w10, w18
    3920: 0b0201ef     	add	w15, w15, w2
    3924: 4acd6631     	eor	w17, w17, w13, ror #25
    3928: 2a030252     	orr	w18, w18, w3
    392c: 4aca5821     	eor	w1, w1, w10, ror #22
    3930: 0b1001ef     	add	w15, w15, w16
    3934: 528fb870     	mov	w16, #0x7dc3            // =32195
    3938: 0b1101f1     	add	w17, w15, w17
    393c: 72aaa190     	movk	w16, #0x550c, lsl #16
    3940: 0b120032     	add	w18, w1, w18
    3944: 0b0b022f     	add	w15, w17, w11
    3948: 0b11024b     	add	w11, w18, w17
    394c: 138f19e1     	ror	w1, w15, #0x6
    3950: 0a0f01a3     	and	w3, w13, w15
    3954: 2945cbf1     	ldp	w17, w18, [sp, #0x2c]
    3958: 138b0962     	ror	w2, w11, #0x2
    395c: 4acf2c21     	eor	w1, w1, w15, ror #11
    3960: 0b0c022c     	add	w12, w17, w12
    3964: 0a2f01d1     	bic	w17, w14, w15
    3968: 4acb3442     	eor	w2, w2, w11, ror #13
    396c: 2a110071     	orr	w17, w3, w17
    3970: 2a090143     	orr	w3, w10, w9
    3974: 4acf6421     	eor	w1, w1, w15, ror #25
    3978: 0b11018c     	add	w12, w12, w17
    397c: 0a090151     	and	w17, w10, w9
    3980: 0a030163     	and	w3, w11, w3
    3984: 4acb5842     	eor	w2, w2, w11, ror #22
    3988: 2a110071     	orr	w17, w3, w17
    398c: 0b10018c     	add	w12, w12, w16
    3990: 0b010190     	add	w16, w12, w1
    3994: 0b0e024e     	add	w14, w18, w14
    3998: 2a0a0172     	orr	w18, w11, w10
    399c: 0b110051     	add	w17, w2, w17
    39a0: 0b08020c     	add	w12, w16, w8
    39a4: 0b100228     	add	w8, w17, w16
    39a8: 138c1991     	ror	w17, w12, #0x6
    39ac: 0a2c01a2     	bic	w2, w13, w12
    39b0: 13880901     	ror	w1, w8, #0x2
    39b4: 0a0c01e3     	and	w3, w15, w12
    39b8: 528bae90     	mov	w16, #0x5d74            // =23924
    39bc: 4acc2e31     	eor	w17, w17, w12, ror #11
    39c0: 2a020062     	orr	w2, w3, w2
    39c4: 72ae57d0     	movk	w16, #0x72be, lsl #16
    39c8: 4ac83421     	eor	w1, w1, w8, ror #13
    39cc: 0a0a0163     	and	w3, w11, w10
    39d0: 0a120112     	and	w18, w8, w18
    39d4: 0b0201ce     	add	w14, w14, w2
    39d8: 4acc6631     	eor	w17, w17, w12, ror #25
    39dc: 2a030252     	orr	w18, w18, w3
    39e0: 4ac85821     	eor	w1, w1, w8, ror #22
    39e4: 0b1001ce     	add	w14, w14, w16
    39e8: 52963fd0     	mov	w16, #0xb1fe            // =45566
    39ec: 0b1101d1     	add	w17, w14, w17
    39f0: 72b01bd0     	movk	w16, #0x80de, lsl #16
    39f4: 0b120032     	add	w18, w1, w18
    39f8: 0b09022e     	add	w14, w17, w9
    39fc: 0b110249     	add	w9, w18, w17
    3a00: 138e19c1     	ror	w1, w14, #0x6
    3a04: 0a0e0183     	and	w3, w12, w14
    3a08: 2946cbf1     	ldp	w17, w18, [sp, #0x34]
    3a0c: 13890922     	ror	w2, w9, #0x2
    3a10: 4ace2c21     	eor	w1, w1, w14, ror #11
    3a14: 0b0d022d     	add	w13, w17, w13
    3a18: 0a2e01f1     	bic	w17, w15, w14
    3a1c: 4ac93442     	eor	w2, w2, w9, ror #13
    3a20: 2a110071     	orr	w17, w3, w17
    3a24: 2a0b0103     	orr	w3, w8, w11
    3a28: 4ace6421     	eor	w1, w1, w14, ror #25
    3a2c: 0b1101ad     	add	w13, w13, w17
    3a30: 0a0b0111     	and	w17, w8, w11
    3a34: 0a030123     	and	w3, w9, w3
    3a38: 4ac95842     	eor	w2, w2, w9, ror #22
    3a3c: 2a110071     	orr	w17, w3, w17
    3a40: 0b1001ad     	add	w13, w13, w16
    3a44: 0b0101b0     	add	w16, w13, w1
    3a48: 0b0f024f     	add	w15, w18, w15
    3a4c: 2a080132     	orr	w18, w9, w8
    3a50: 0b110051     	add	w17, w2, w17
    3a54: 0b0a020d     	add	w13, w16, w10
    3a58: 0b10022a     	add	w10, w17, w16
    3a5c: 138d19b1     	ror	w17, w13, #0x6
    3a60: 0a2d0182     	bic	w2, w12, w13
    3a64: 138a0941     	ror	w1, w10, #0x2
    3a68: 0a0d01c3     	and	w3, w14, w13
    3a6c: 5280d4f0     	mov	w16, #0x6a7             // =1703
    3a70: 4acd2e31     	eor	w17, w17, w13, ror #11
    3a74: 2a020062     	orr	w2, w3, w2
    3a78: 72b37b90     	movk	w16, #0x9bdc, lsl #16
    3a7c: 4aca3421     	eor	w1, w1, w10, ror #13
    3a80: 0a080123     	and	w3, w9, w8
    3a84: 0a120152     	and	w18, w10, w18
    3a88: 0b0201ef     	add	w15, w15, w2
    3a8c: 4acd6631     	eor	w17, w17, w13, ror #25
    3a90: 2a030252     	orr	w18, w18, w3
    3a94: 4aca5821     	eor	w1, w1, w10, ror #22
    3a98: 0b1001ef     	add	w15, w15, w16
    3a9c: 529e2e90     	mov	w16, #0xf174            // =61812
    3aa0: 0b1101f1     	add	w17, w15, w17
    3aa4: 72b83370     	movk	w16, #0xc19b, lsl #16
    3aa8: 0b120032     	add	w18, w1, w18
    3aac: 0b0b022f     	add	w15, w17, w11
    3ab0: 0b11024b     	add	w11, w18, w17
    3ab4: 138f19e1     	ror	w1, w15, #0x6
    3ab8: 0a0f01a3     	and	w3, w13, w15
    3abc: 2947cbf1     	ldp	w17, w18, [sp, #0x3c]
    3ac0: 138b0962     	ror	w2, w11, #0x2
    3ac4: 4acf2c21     	eor	w1, w1, w15, ror #11
    3ac8: 0b0c022c     	add	w12, w17, w12
    3acc: 0a2f01d1     	bic	w17, w14, w15
    3ad0: 4acb3442     	eor	w2, w2, w11, ror #13
    3ad4: 2a110071     	orr	w17, w3, w17
    3ad8: 2a090143     	orr	w3, w10, w9
    3adc: 4acf6421     	eor	w1, w1, w15, ror #25
    3ae0: 0b11018c     	add	w12, w12, w17
    3ae4: 0a090151     	and	w17, w10, w9
    3ae8: 0a030163     	and	w3, w11, w3
    3aec: 4acb5842     	eor	w2, w2, w11, ror #22
    3af0: 2a110071     	orr	w17, w3, w17
    3af4: 0b10018c     	add	w12, w12, w16
    3af8: 0b010190     	add	w16, w12, w1
    3afc: 0b0e024e     	add	w14, w18, w14
    3b00: 2a0a0172     	orr	w18, w11, w10
    3b04: 0b110051     	add	w17, w2, w17
    3b08: 0b08020c     	add	w12, w16, w8
    3b0c: 0b100228     	add	w8, w17, w16
    3b10: 138c1991     	ror	w17, w12, #0x6
    3b14: 0a2c01a2     	bic	w2, w13, w12
    3b18: 13880901     	ror	w1, w8, #0x2
    3b1c: 0a0c01e3     	and	w3, w15, w12
    3b20: 528d3830     	mov	w16, #0x69c1            // =27073
    3b24: 4acc2e31     	eor	w17, w17, w12, ror #11
    3b28: 2a020062     	orr	w2, w3, w2
    3b2c: 72bc9370     	movk	w16, #0xe49b, lsl #16
    3b30: 4ac83421     	eor	w1, w1, w8, ror #13
    3b34: 0a0a0163     	and	w3, w11, w10
    3b38: 0a120112     	and	w18, w8, w18
    3b3c: 0b0201ce     	add	w14, w14, w2
    3b40: 4acc6631     	eor	w17, w17, w12, ror #25
    3b44: 2a030252     	orr	w18, w18, w3
    3b48: 4ac85821     	eor	w1, w1, w8, ror #22
    3b4c: 0b1001ce     	add	w14, w14, w16
    3b50: 5288f0d0     	mov	w16, #0x4786            // =18310
    3b54: 0b1101d1     	add	w17, w14, w17
    3b58: 72bdf7d0     	movk	w16, #0xefbe, lsl #16
    3b5c: 0b120032     	add	w18, w1, w18
    3b60: 0b09022e     	add	w14, w17, w9
    3b64: 0b110249     	add	w9, w18, w17
    3b68: 138e19c1     	ror	w1, w14, #0x6
    3b6c: 0a0e0183     	and	w3, w12, w14
    3b70: 2948cbf1     	ldp	w17, w18, [sp, #0x44]
    3b74: 13890922     	ror	w2, w9, #0x2
    3b78: 4ace2c21     	eor	w1, w1, w14, ror #11
    3b7c: 0b0d022d     	add	w13, w17, w13
    3b80: 0a2e01f1     	bic	w17, w15, w14
    3b84: 4ac93442     	eor	w2, w2, w9, ror #13
    3b88: 2a110071     	orr	w17, w3, w17
    3b8c: 2a0b0103     	orr	w3, w8, w11
    3b90: 4ace6421     	eor	w1, w1, w14, ror #25
    3b94: 0b1101ad     	add	w13, w13, w17
    3b98: 0a0b0111     	and	w17, w8, w11
    3b9c: 0a030123     	and	w3, w9, w3
    3ba0: 4ac95842     	eor	w2, w2, w9, ror #22
    3ba4: 2a110071     	orr	w17, w3, w17
    3ba8: 0b1001ad     	add	w13, w13, w16
    3bac: 0b0101b0     	add	w16, w13, w1
    3bb0: 0b0f024f     	add	w15, w18, w15
    3bb4: 2a080132     	orr	w18, w9, w8
    3bb8: 0b110051     	add	w17, w2, w17
    3bbc: 0b0a020d     	add	w13, w16, w10
    3bc0: 0b10022a     	add	w10, w17, w16
    3bc4: 138d19b1     	ror	w17, w13, #0x6
    3bc8: 0a2d0182     	bic	w2, w12, w13
    3bcc: 138a0941     	ror	w1, w10, #0x2
    3bd0: 0a0d01c3     	and	w3, w14, w13
    3bd4: 5293b8d0     	mov	w16, #0x9dc6            // =40390
    3bd8: 4acd2e31     	eor	w17, w17, w13, ror #11
    3bdc: 2a020062     	orr	w2, w3, w2
    3be0: 72a1f830     	movk	w16, #0xfc1, lsl #16
    3be4: 4aca3421     	eor	w1, w1, w10, ror #13
    3be8: 0a080123     	and	w3, w9, w8
    3bec: 0a120152     	and	w18, w10, w18
    3bf0: 0b0201ef     	add	w15, w15, w2
    3bf4: 4acd6631     	eor	w17, w17, w13, ror #25
    3bf8: 2a030252     	orr	w18, w18, w3
    3bfc: 4aca5821     	eor	w1, w1, w10, ror #22
    3c00: 0b1001ef     	add	w15, w15, w16
    3c04: 52943990     	mov	w16, #0xa1cc            // =41420
    3c08: 0b1101f1     	add	w17, w15, w17
    3c0c: 72a48190     	movk	w16, #0x240c, lsl #16
    3c10: 0b120032     	add	w18, w1, w18
    3c14: 0b0b022f     	add	w15, w17, w11
    3c18: 0b11024b     	add	w11, w18, w17
    3c1c: 138f19e1     	ror	w1, w15, #0x6
    3c20: 0a0f01a3     	and	w3, w13, w15
    3c24: 2949cbf1     	ldp	w17, w18, [sp, #0x4c]
    3c28: 138b0962     	ror	w2, w11, #0x2
    3c2c: 4acf2c21     	eor	w1, w1, w15, ror #11
    3c30: 0b0c022c     	add	w12, w17, w12
    3c34: 0a2f01d1     	bic	w17, w14, w15
    3c38: 4acb3442     	eor	w2, w2, w11, ror #13
    3c3c: 2a110071     	orr	w17, w3, w17
    3c40: 2a090143     	orr	w3, w10, w9
    3c44: 4acf6421     	eor	w1, w1, w15, ror #25
    3c48: 0b11018c     	add	w12, w12, w17
    3c4c: 0a090151     	and	w17, w10, w9
    3c50: 0a030163     	and	w3, w11, w3
    3c54: 4acb5842     	eor	w2, w2, w11, ror #22
    3c58: 2a110071     	orr	w17, w3, w17
    3c5c: 0b10018c     	add	w12, w12, w16
    3c60: 0b010190     	add	w16, w12, w1
    3c64: 0b0e024e     	add	w14, w18, w14
    3c68: 2a0a0172     	orr	w18, w11, w10
    3c6c: 0b110051     	add	w17, w2, w17
    3c70: 0b08020c     	add	w12, w16, w8
    3c74: 0b100228     	add	w8, w17, w16
    3c78: 138c1991     	ror	w17, w12, #0x6
    3c7c: 0a2c01a2     	bic	w2, w13, w12
    3c80: 13880901     	ror	w1, w8, #0x2
    3c84: 0a0c01e3     	and	w3, w15, w12
    3c88: 52858df0     	mov	w16, #0x2c6f            // =11375
    3c8c: 4acc2e31     	eor	w17, w17, w12, ror #11
    3c90: 2a020062     	orr	w2, w3, w2
    3c94: 72a5bd30     	movk	w16, #0x2de9, lsl #16
    3c98: 4ac83421     	eor	w1, w1, w8, ror #13
    3c9c: 0a0a0163     	and	w3, w11, w10
    3ca0: 0a120112     	and	w18, w8, w18
    3ca4: 0b0201ce     	add	w14, w14, w2
    3ca8: 4acc6631     	eor	w17, w17, w12, ror #25
    3cac: 2a030252     	orr	w18, w18, w3
    3cb0: 4ac85821     	eor	w1, w1, w8, ror #22
    3cb4: 0b1001ce     	add	w14, w14, w16
    3cb8: 52909550     	mov	w16, #0x84aa            // =33962
    3cbc: 0b1101d1     	add	w17, w14, w17
    3cc0: 72a94e90     	movk	w16, #0x4a74, lsl #16
    3cc4: 0b120032     	add	w18, w1, w18
    3cc8: 0b09022e     	add	w14, w17, w9
    3ccc: 0b110249     	add	w9, w18, w17
    3cd0: 138e19c1     	ror	w1, w14, #0x6
    3cd4: 0a0e0183     	and	w3, w12, w14
    3cd8: 294acbf1     	ldp	w17, w18, [sp, #0x54]
    3cdc: 13890922     	ror	w2, w9, #0x2
    3ce0: 4ace2c21     	eor	w1, w1, w14, ror #11
    3ce4: 0b0d022d     	add	w13, w17, w13
    3ce8: 0a2e01f1     	bic	w17, w15, w14
    3cec: 4ac93442     	eor	w2, w2, w9, ror #13
    3cf0: 2a110071     	orr	w17, w3, w17
    3cf4: 2a0b0103     	orr	w3, w8, w11
    3cf8: 4ace6421     	eor	w1, w1, w14, ror #25
    3cfc: 0b1101ad     	add	w13, w13, w17
    3d00: 0a0b0111     	and	w17, w8, w11
    3d04: 0a030123     	and	w3, w9, w3
    3d08: 4ac95842     	eor	w2, w2, w9, ror #22
    3d0c: 2a110071     	orr	w17, w3, w17
    3d10: 0b1001ad     	add	w13, w13, w16
    3d14: 0b0101b0     	add	w16, w13, w1
    3d18: 0b0f024f     	add	w15, w18, w15
    3d1c: 2a080132     	orr	w18, w9, w8
    3d20: 0b110051     	add	w17, w2, w17
    3d24: 0b0a020d     	add	w13, w16, w10
    3d28: 0b10022a     	add	w10, w17, w16
    3d2c: 138d19b1     	ror	w17, w13, #0x6
    3d30: 0a2d0182     	bic	w2, w12, w13
    3d34: 138a0941     	ror	w1, w10, #0x2
    3d38: 0a0d01c3     	and	w3, w14, w13
    3d3c: 52953b90     	mov	w16, #0xa9dc            // =43484
    3d40: 4acd2e31     	eor	w17, w17, w13, ror #11
    3d44: 2a020062     	orr	w2, w3, w2
    3d48: 72ab9610     	movk	w16, #0x5cb0, lsl #16
    3d4c: 4aca3421     	eor	w1, w1, w10, ror #13
    3d50: 0a080123     	and	w3, w9, w8
    3d54: 0a120152     	and	w18, w10, w18
    3d58: 0b0201ef     	add	w15, w15, w2
    3d5c: 4acd6631     	eor	w17, w17, w13, ror #25
    3d60: 2a030252     	orr	w18, w18, w3
    3d64: 4aca5821     	eor	w1, w1, w10, ror #22
    3d68: 0b1001ef     	add	w15, w15, w16
    3d6c: 52911b50     	mov	w16, #0x88da            // =35034
    3d70: 0b1101f1     	add	w17, w15, w17
    3d74: 72aedf30     	movk	w16, #0x76f9, lsl #16
    3d78: 0b120032     	add	w18, w1, w18
    3d7c: 0b0b022f     	add	w15, w17, w11
    3d80: 0b11024b     	add	w11, w18, w17
    3d84: 138f19e1     	ror	w1, w15, #0x6
    3d88: 0a0f01a3     	and	w3, w13, w15
    3d8c: 294bcbf1     	ldp	w17, w18, [sp, #0x5c]
    3d90: 138b0962     	ror	w2, w11, #0x2
    3d94: 4acf2c21     	eor	w1, w1, w15, ror #11
    3d98: 0b0c022c     	add	w12, w17, w12
    3d9c: 0a2f01d1     	bic	w17, w14, w15
    3da0: 4acb3442     	eor	w2, w2, w11, ror #13
    3da4: 2a110071     	orr	w17, w3, w17
    3da8: 2a090143     	orr	w3, w10, w9
    3dac: 4acf6421     	eor	w1, w1, w15, ror #25
    3db0: 0b11018c     	add	w12, w12, w17
    3db4: 0a090151     	and	w17, w10, w9
    3db8: 0a030163     	and	w3, w11, w3
    3dbc: 4acb5842     	eor	w2, w2, w11, ror #22
    3dc0: 2a110071     	orr	w17, w3, w17
    3dc4: 0b10018c     	add	w12, w12, w16
    3dc8: 0b010190     	add	w16, w12, w1
    3dcc: 0b0e024e     	add	w14, w18, w14
    3dd0: 2a0a0172     	orr	w18, w11, w10
    3dd4: 0b110051     	add	w17, w2, w17
    3dd8: 0b08020c     	add	w12, w16, w8
    3ddc: 0b100228     	add	w8, w17, w16
    3de0: 138c1991     	ror	w17, w12, #0x6
    3de4: 0a2c01a2     	bic	w2, w13, w12
    3de8: 13880901     	ror	w1, w8, #0x2
    3dec: 0a0c01e3     	and	w3, w15, w12
    3df0: 528a2a50     	mov	w16, #0x5152            // =20818
    3df4: 4acc2e31     	eor	w17, w17, w12, ror #11
    3df8: 2a020062     	orr	w2, w3, w2
    3dfc: 72b307d0     	movk	w16, #0x983e, lsl #16
    3e00: 4ac83421     	eor	w1, w1, w8, ror #13
    3e04: 0a0a0163     	and	w3, w11, w10
    3e08: 0a120112     	and	w18, w8, w18
    3e0c: 0b0201ce     	add	w14, w14, w2
    3e10: 4acc6631     	eor	w17, w17, w12, ror #25
    3e14: 2a030252     	orr	w18, w18, w3
    3e18: 4ac85821     	eor	w1, w1, w8, ror #22
    3e1c: 0b1001ce     	add	w14, w14, w16
    3e20: 5298cdb0     	mov	w16, #0xc66d            // =50797
    3e24: 0b1101d1     	add	w17, w14, w17
    3e28: 72b50630     	movk	w16, #0xa831, lsl #16
    3e2c: 0b120032     	add	w18, w1, w18
    3e30: 0b09022e     	add	w14, w17, w9
    3e34: 0b110249     	add	w9, w18, w17
    3e38: 138e19c1     	ror	w1, w14, #0x6
    3e3c: 0a0e0183     	and	w3, w12, w14
    3e40: 294ccbf1     	ldp	w17, w18, [sp, #0x64]
    3e44: 13890922     	ror	w2, w9, #0x2
    3e48: 4ace2c21     	eor	w1, w1, w14, ror #11
    3e4c: 0b0d022d     	add	w13, w17, w13
    3e50: 0a2e01f1     	bic	w17, w15, w14
    3e54: 4ac93442     	eor	w2, w2, w9, ror #13
    3e58: 2a110071     	orr	w17, w3, w17
    3e5c: 2a0b0103     	orr	w3, w8, w11
    3e60: 4ace6421     	eor	w1, w1, w14, ror #25
    3e64: 0b1101ad     	add	w13, w13, w17
    3e68: 0a0b0111     	and	w17, w8, w11
    3e6c: 0a030123     	and	w3, w9, w3
    3e70: 4ac95842     	eor	w2, w2, w9, ror #22
    3e74: 2a110071     	orr	w17, w3, w17
    3e78: 0b1001ad     	add	w13, w13, w16
    3e7c: 0b0101b0     	add	w16, w13, w1
    3e80: 0b0f024f     	add	w15, w18, w15
    3e84: 2a080132     	orr	w18, w9, w8
    3e88: 0b110051     	add	w17, w2, w17
    3e8c: 0b0a020d     	add	w13, w16, w10
    3e90: 0b10022a     	add	w10, w17, w16
    3e94: 138d19b1     	ror	w17, w13, #0x6
    3e98: 0a2d0182     	bic	w2, w12, w13
    3e9c: 138a0941     	ror	w1, w10, #0x2
    3ea0: 0a0d01c3     	and	w3, w14, w13
    3ea4: 5284f910     	mov	w16, #0x27c8            // =10184
    3ea8: 4acd2e31     	eor	w17, w17, w13, ror #11
    3eac: 2a020062     	orr	w2, w3, w2
    3eb0: 72b60070     	movk	w16, #0xb003, lsl #16
    3eb4: 4aca3421     	eor	w1, w1, w10, ror #13
    3eb8: 0a080123     	and	w3, w9, w8
    3ebc: 0a120152     	and	w18, w10, w18
    3ec0: 0b0201ef     	add	w15, w15, w2
    3ec4: 4acd6631     	eor	w17, w17, w13, ror #25
    3ec8: 2a030252     	orr	w18, w18, w3
    3ecc: 4aca5821     	eor	w1, w1, w10, ror #22
    3ed0: 0b1001ef     	add	w15, w15, w16
    3ed4: 528ff8f0     	mov	w16, #0x7fc7            // =32711
    3ed8: 0b1101f1     	add	w17, w15, w17
    3edc: 72b7eb30     	movk	w16, #0xbf59, lsl #16
    3ee0: 0b120032     	add	w18, w1, w18
    3ee4: 0b0b022f     	add	w15, w17, w11
    3ee8: 0b11024b     	add	w11, w18, w17
    3eec: 138f19e1     	ror	w1, w15, #0x6
    3ef0: 0a0f01a3     	and	w3, w13, w15
    3ef4: 294dcbf1     	ldp	w17, w18, [sp, #0x6c]
    3ef8: 138b0962     	ror	w2, w11, #0x2
    3efc: 4acf2c21     	eor	w1, w1, w15, ror #11
    3f00: 0b0c022c     	add	w12, w17, w12
    3f04: 0a2f01d1     	bic	w17, w14, w15
    3f08: 4acb3442     	eor	w2, w2, w11, ror #13
    3f0c: 2a110071     	orr	w17, w3, w17
    3f10: 2a090143     	orr	w3, w10, w9
    3f14: 4acf6421     	eor	w1, w1, w15, ror #25
    3f18: 0b11018c     	add	w12, w12, w17
    3f1c: 0a090151     	and	w17, w10, w9
    3f20: 0a030163     	and	w3, w11, w3
    3f24: 4acb5842     	eor	w2, w2, w11, ror #22
    3f28: 2a110071     	orr	w17, w3, w17
    3f2c: 0b10018c     	add	w12, w12, w16
    3f30: 0b010190     	add	w16, w12, w1
    3f34: 0b0e024e     	add	w14, w18, w14
    3f38: 2a0a0172     	orr	w18, w11, w10
    3f3c: 0b110051     	add	w17, w2, w17
    3f40: 0b08020c     	add	w12, w16, w8
    3f44: 0b100228     	add	w8, w17, w16
    3f48: 138c1991     	ror	w17, w12, #0x6
    3f4c: 0a2c01a2     	bic	w2, w13, w12
    3f50: 13880901     	ror	w1, w8, #0x2
    3f54: 0a0c01e3     	and	w3, w15, w12
    3f58: 52817e70     	mov	w16, #0xbf3             // =3059
    3f5c: 4acc2e31     	eor	w17, w17, w12, ror #11
    3f60: 2a020062     	orr	w2, w3, w2
    3f64: 72b8dc10     	movk	w16, #0xc6e0, lsl #16
    3f68: 4ac83421     	eor	w1, w1, w8, ror #13
    3f6c: 0a0a0163     	and	w3, w11, w10
    3f70: 0a120112     	and	w18, w8, w18
    3f74: 0b0201ce     	add	w14, w14, w2
    3f78: 4acc6631     	eor	w17, w17, w12, ror #25
    3f7c: 2a030252     	orr	w18, w18, w3
    3f80: 4ac85821     	eor	w1, w1, w8, ror #22
    3f84: 0b1001ce     	add	w14, w14, w16
    3f88: 529228f0     	mov	w16, #0x9147            // =37191
    3f8c: 0b1101d1     	add	w17, w14, w17
    3f90: 72bab4f0     	movk	w16, #0xd5a7, lsl #16
    3f94: 0b120032     	add	w18, w1, w18
    3f98: 0b09022e     	add	w14, w17, w9
    3f9c: 0b110249     	add	w9, w18, w17
    3fa0: 138e19c1     	ror	w1, w14, #0x6
    3fa4: 0a0e0183     	and	w3, w12, w14
    3fa8: 294ecbf1     	ldp	w17, w18, [sp, #0x74]
    3fac: 13890922     	ror	w2, w9, #0x2
    3fb0: 4ace2c21     	eor	w1, w1, w14, ror #11
    3fb4: 0b0d022d     	add	w13, w17, w13
    3fb8: 0a2e01f1     	bic	w17, w15, w14
    3fbc: 4ac93442     	eor	w2, w2, w9, ror #13
    3fc0: 2a110071     	orr	w17, w3, w17
    3fc4: 2a0b0103     	orr	w3, w8, w11
    3fc8: 4ace6421     	eor	w1, w1, w14, ror #25
    3fcc: 0b1101ad     	add	w13, w13, w17
    3fd0: 0a0b0111     	and	w17, w8, w11
    3fd4: 0a030123     	and	w3, w9, w3
    3fd8: 4ac95842     	eor	w2, w2, w9, ror #22
    3fdc: 2a110071     	orr	w17, w3, w17
    3fe0: 0b1001ad     	add	w13, w13, w16
    3fe4: 0b0101b0     	add	w16, w13, w1
    3fe8: 0b0f024f     	add	w15, w18, w15
    3fec: 2a080132     	orr	w18, w9, w8
    3ff0: 0b110051     	add	w17, w2, w17
    3ff4: 0b0a020d     	add	w13, w16, w10
    3ff8: 0b10022a     	add	w10, w17, w16
    3ffc: 138d19b1     	ror	w17, w13, #0x6
    4000: 0a2d0182     	bic	w2, w12, w13
    4004: 138a0941     	ror	w1, w10, #0x2
    4008: 0a0d01c3     	and	w3, w14, w13
    400c: 528c6a30     	mov	w16, #0x6351            // =25425
    4010: 4acd2e31     	eor	w17, w17, w13, ror #11
    4014: 2a020062     	orr	w2, w3, w2
    4018: 72a0d950     	movk	w16, #0x6ca, lsl #16
    401c: 4aca3421     	eor	w1, w1, w10, ror #13
    4020: 0a080123     	and	w3, w9, w8
    4024: 0a120152     	and	w18, w10, w18
    4028: 0b0201ef     	add	w15, w15, w2
    402c: 4acd6631     	eor	w17, w17, w13, ror #25
    4030: 2a030252     	orr	w18, w18, w3
    4034: 4aca5821     	eor	w1, w1, w10, ror #22
    4038: 0b1001ef     	add	w15, w15, w16
    403c: 52852cf0     	mov	w16, #0x2967            // =10599
    4040: 0b1101f1     	add	w17, w15, w17
    4044: 72a28530     	movk	w16, #0x1429, lsl #16
    4048: 0b120032     	add	w18, w1, w18
    404c: 0b0b022f     	add	w15, w17, w11
    4050: 0b11024b     	add	w11, w18, w17
    4054: 138f19e1     	ror	w1, w15, #0x6
    4058: 0a0f01a3     	and	w3, w13, w15
    405c: 294fcbf1     	ldp	w17, w18, [sp, #0x7c]
    4060: 138b0962     	ror	w2, w11, #0x2
    4064: 4acf2c21     	eor	w1, w1, w15, ror #11
    4068: 0b0c022c     	add	w12, w17, w12
    406c: 0a2f01d1     	bic	w17, w14, w15
    4070: 4acb3442     	eor	w2, w2, w11, ror #13
    4074: 2a110071     	orr	w17, w3, w17
    4078: 2a090143     	orr	w3, w10, w9
    407c: 4acf6421     	eor	w1, w1, w15, ror #25
    4080: 0b11018c     	add	w12, w12, w17
    4084: 0a090151     	and	w17, w10, w9
    4088: 0a030163     	and	w3, w11, w3
    408c: 4acb5842     	eor	w2, w2, w11, ror #22
    4090: 2a110071     	orr	w17, w3, w17
    4094: 0b10018c     	add	w12, w12, w16
    4098: 0b010190     	add	w16, w12, w1
    409c: 0b0e024e     	add	w14, w18, w14
    40a0: 2a0a0172     	orr	w18, w11, w10
    40a4: 0b110051     	add	w17, w2, w17
    40a8: 0b08020c     	add	w12, w16, w8
    40ac: 0b100228     	add	w8, w17, w16
    40b0: 138c1991     	ror	w17, w12, #0x6
    40b4: 0a2c01a2     	bic	w2, w13, w12
    40b8: 13880901     	ror	w1, w8, #0x2
    40bc: 0a0c01e3     	and	w3, w15, w12
    40c0: 528150b0     	mov	w16, #0xa85             // =2693
    40c4: 4acc2e31     	eor	w17, w17, w12, ror #11
    40c8: 2a020062     	orr	w2, w3, w2
    40cc: 72a4f6f0     	movk	w16, #0x27b7, lsl #16
    40d0: 4ac83421     	eor	w1, w1, w8, ror #13
    40d4: 0a0a0163     	and	w3, w11, w10
    40d8: 0a120112     	and	w18, w8, w18
    40dc: 0b0201ce     	add	w14, w14, w2
    40e0: 4acc6631     	eor	w17, w17, w12, ror #25
    40e4: 2a030252     	orr	w18, w18, w3
    40e8: 4ac85821     	eor	w1, w1, w8, ror #22
    40ec: 0b1001ce     	add	w14, w14, w16
    40f0: 52842710     	mov	w16, #0x2138            // =8504
    40f4: 0b1101d1     	add	w17, w14, w17
    40f8: 72a5c370     	movk	w16, #0x2e1b, lsl #16
    40fc: 0b120032     	add	w18, w1, w18
    4100: 0b09022e     	add	w14, w17, w9
    4104: 0b110249     	add	w9, w18, w17
    4108: 138e19c1     	ror	w1, w14, #0x6
    410c: 0a0e0183     	and	w3, w12, w14
    4110: 2950cbf1     	ldp	w17, w18, [sp, #0x84]
    4114: 13890922     	ror	w2, w9, #0x2
    4118: 4ace2c21     	eor	w1, w1, w14, ror #11
    411c: 0b0d022d     	add	w13, w17, w13
    4120: 0a2e01f1     	bic	w17, w15, w14
    4124: 4ac93442     	eor	w2, w2, w9, ror #13
    4128: 2a110071     	orr	w17, w3, w17
    412c: 2a0b0103     	orr	w3, w8, w11
    4130: 4ace6421     	eor	w1, w1, w14, ror #25
    4134: 0b1101ad     	add	w13, w13, w17
    4138: 0a0b0111     	and	w17, w8, w11
    413c: 0a030123     	and	w3, w9, w3
    4140: 4ac95842     	eor	w2, w2, w9, ror #22
    4144: 2a110071     	orr	w17, w3, w17
    4148: 0b1001ad     	add	w13, w13, w16
    414c: 0b0101b0     	add	w16, w13, w1
    4150: 0b0f024f     	add	w15, w18, w15
    4154: 2a080132     	orr	w18, w9, w8
    4158: 0b110051     	add	w17, w2, w17
    415c: 0b0a020d     	add	w13, w16, w10
    4160: 0b10022a     	add	w10, w17, w16
    4164: 138d19b1     	ror	w17, w13, #0x6
    4168: 0a2d0182     	bic	w2, w12, w13
    416c: 138a0941     	ror	w1, w10, #0x2
    4170: 0a0d01c3     	and	w3, w14, w13
    4174: 528dbf90     	mov	w16, #0x6dfc            // =28156
    4178: 4acd2e31     	eor	w17, w17, w13, ror #11
    417c: 2a020062     	orr	w2, w3, w2
    4180: 72a9a590     	movk	w16, #0x4d2c, lsl #16
    4184: 4aca3421     	eor	w1, w1, w10, ror #13
    4188: 0a080123     	and	w3, w9, w8
    418c: 0a120152     	and	w18, w10, w18
    4190: 0b0201ef     	add	w15, w15, w2
    4194: 4acd6631     	eor	w17, w17, w13, ror #25
    4198: 2a030252     	orr	w18, w18, w3
    419c: 4aca5821     	eor	w1, w1, w10, ror #22
    41a0: 0b1001ef     	add	w15, w15, w16
    41a4: 5281a270     	mov	w16, #0xd13             // =3347
    41a8: 0b1101f1     	add	w17, w15, w17
    41ac: 72aa6710     	movk	w16, #0x5338, lsl #16
    41b0: 0b120032     	add	w18, w1, w18
    41b4: 0b0b022f     	add	w15, w17, w11
    41b8: 0b11024b     	add	w11, w18, w17
    41bc: 138f19e1     	ror	w1, w15, #0x6
    41c0: 0a0f01a3     	and	w3, w13, w15
    41c4: 2951cbf1     	ldp	w17, w18, [sp, #0x8c]
    41c8: 138b0962     	ror	w2, w11, #0x2
    41cc: 4acf2c21     	eor	w1, w1, w15, ror #11
    41d0: 0b0c022c     	add	w12, w17, w12
    41d4: 0a2f01d1     	bic	w17, w14, w15
    41d8: 4acb3442     	eor	w2, w2, w11, ror #13
    41dc: 2a110071     	orr	w17, w3, w17
    41e0: 2a090143     	orr	w3, w10, w9
    41e4: 4acf6421     	eor	w1, w1, w15, ror #25
    41e8: 0b11018c     	add	w12, w12, w17
    41ec: 0a090151     	and	w17, w10, w9
    41f0: 0a030163     	and	w3, w11, w3
    41f4: 4acb5842     	eor	w2, w2, w11, ror #22
    41f8: 2a110071     	orr	w17, w3, w17
    41fc: 0b10018c     	add	w12, w12, w16
    4200: 0b010190     	add	w16, w12, w1
    4204: 0b0e024e     	add	w14, w18, w14
    4208: 2a0a0172     	orr	w18, w11, w10
    420c: 0b110051     	add	w17, w2, w17
    4210: 0b08020c     	add	w12, w16, w8
    4214: 0b100228     	add	w8, w17, w16
    4218: 138c1991     	ror	w17, w12, #0x6
    421c: 0a2c01a2     	bic	w2, w13, w12
    4220: 13880901     	ror	w1, w8, #0x2
    4224: 0a0c01e3     	and	w3, w15, w12
    4228: 528e6a90     	mov	w16, #0x7354            // =29524
    422c: 4acc2e31     	eor	w17, w17, w12, ror #11
    4230: 2a020062     	orr	w2, w3, w2
    4234: 72aca150     	movk	w16, #0x650a, lsl #16
    4238: 4ac83421     	eor	w1, w1, w8, ror #13
    423c: 0a0a0163     	and	w3, w11, w10
    4240: 0a120112     	and	w18, w8, w18
    4244: 0b0201ce     	add	w14, w14, w2
    4248: 4acc6631     	eor	w17, w17, w12, ror #25
    424c: 2a030252     	orr	w18, w18, w3
    4250: 4ac85821     	eor	w1, w1, w8, ror #22
    4254: 0b1001ce     	add	w14, w14, w16
    4258: 52815770     	mov	w16, #0xabb             // =2747
    425c: 0b1101d1     	add	w17, w14, w17
    4260: 72aecd50     	movk	w16, #0x766a, lsl #16
    4264: 0b120032     	add	w18, w1, w18
    4268: 0b09022e     	add	w14, w17, w9
    426c: 0b110249     	add	w9, w18, w17
    4270: 138e19c1     	ror	w1, w14, #0x6
    4274: 0a0e0183     	and	w3, w12, w14
    4278: 2952cbf1     	ldp	w17, w18, [sp, #0x94]
    427c: 13890922     	ror	w2, w9, #0x2
    4280: 4ace2c21     	eor	w1, w1, w14, ror #11
    4284: 0b0d022d     	add	w13, w17, w13
    4288: 0a2e01f1     	bic	w17, w15, w14
    428c: 4ac93442     	eor	w2, w2, w9, ror #13
    4290: 2a110071     	orr	w17, w3, w17
    4294: 2a0b0103     	orr	w3, w8, w11
    4298: 4ace6421     	eor	w1, w1, w14, ror #25
    429c: 0b1101ad     	add	w13, w13, w17
    42a0: 0a0b0111     	and	w17, w8, w11
    42a4: 0a030123     	and	w3, w9, w3
    42a8: 4ac95842     	eor	w2, w2, w9, ror #22
    42ac: 2a110071     	orr	w17, w3, w17
    42b0: 0b1001ad     	add	w13, w13, w16
    42b4: 0b0101b0     	add	w16, w13, w1
    42b8: 0b0f024f     	add	w15, w18, w15
    42bc: 2a080132     	orr	w18, w9, w8
    42c0: 0b110051     	add	w17, w2, w17
    42c4: 0b0a020d     	add	w13, w16, w10
    42c8: 0b10022a     	add	w10, w17, w16
    42cc: 138d19b1     	ror	w17, w13, #0x6
    42d0: 0a2d0182     	bic	w2, w12, w13
    42d4: 138a0941     	ror	w1, w10, #0x2
    42d8: 0a0d01c3     	and	w3, w14, w13
    42dc: 529925d0     	mov	w16, #0xc92e            // =51502
    42e0: 4acd2e31     	eor	w17, w17, w13, ror #11
    42e4: 2a020062     	orr	w2, w3, w2
    42e8: 72b03850     	movk	w16, #0x81c2, lsl #16
    42ec: 4aca3421     	eor	w1, w1, w10, ror #13
    42f0: 0a080123     	and	w3, w9, w8
    42f4: 0a120152     	and	w18, w10, w18
    42f8: 0b0201ef     	add	w15, w15, w2
    42fc: 4acd6631     	eor	w17, w17, w13, ror #25
    4300: 2a030252     	orr	w18, w18, w3
    4304: 4aca5821     	eor	w1, w1, w10, ror #22
    4308: 0b1001ef     	add	w15, w15, w16
    430c: 528590b0     	mov	w16, #0x2c85            // =11397
    4310: 0b1101f1     	add	w17, w15, w17
    4314: 72b24e50     	movk	w16, #0x9272, lsl #16
    4318: 0b120032     	add	w18, w1, w18
    431c: 0b0b022f     	add	w15, w17, w11
    4320: 0b11024b     	add	w11, w18, w17
    4324: 138f19e1     	ror	w1, w15, #0x6
    4328: 0a0f01a3     	and	w3, w13, w15
    432c: 2953cbf1     	ldp	w17, w18, [sp, #0x9c]
    4330: 138b0962     	ror	w2, w11, #0x2
    4334: 4acf2c21     	eor	w1, w1, w15, ror #11
    4338: 0b0c022c     	add	w12, w17, w12
    433c: 0a2f01d1     	bic	w17, w14, w15
    4340: 4acb3442     	eor	w2, w2, w11, ror #13
    4344: 2a110071     	orr	w17, w3, w17
    4348: 2a090143     	orr	w3, w10, w9
    434c: 4acf6421     	eor	w1, w1, w15, ror #25
    4350: 0b11018c     	add	w12, w12, w17
    4354: 0a090151     	and	w17, w10, w9
    4358: 0a030163     	and	w3, w11, w3
    435c: 4acb5842     	eor	w2, w2, w11, ror #22
    4360: 2a110071     	orr	w17, w3, w17
    4364: 0b10018c     	add	w12, w12, w16
    4368: 0b010190     	add	w16, w12, w1
    436c: 0b0e024e     	add	w14, w18, w14
    4370: 2a0a0172     	orr	w18, w11, w10
    4374: 0b110051     	add	w17, w2, w17
    4378: 0b08020c     	add	w12, w16, w8
    437c: 0b100228     	add	w8, w17, w16
    4380: 138c1991     	ror	w17, w12, #0x6
    4384: 0a2c01a2     	bic	w2, w13, w12
    4388: 13880901     	ror	w1, w8, #0x2
    438c: 0a0c01e3     	and	w3, w15, w12
    4390: 529d1430     	mov	w16, #0xe8a1            // =59553
    4394: 4acc2e31     	eor	w17, w17, w12, ror #11
    4398: 2a020062     	orr	w2, w3, w2
    439c: 72b457f0     	movk	w16, #0xa2bf, lsl #16
    43a0: 4ac83421     	eor	w1, w1, w8, ror #13
    43a4: 0a0a0163     	and	w3, w11, w10
    43a8: 0a120112     	and	w18, w8, w18
    43ac: 0b0201ce     	add	w14, w14, w2
    43b0: 4acc6631     	eor	w17, w17, w12, ror #25
    43b4: 2a030252     	orr	w18, w18, w3
    43b8: 4ac85821     	eor	w1, w1, w8, ror #22
    43bc: 0b1001ce     	add	w14, w14, w16
    43c0: 528cc970     	mov	w16, #0x664b            // =26187
    43c4: 0b1101d1     	add	w17, w14, w17
    43c8: 72b50350     	movk	w16, #0xa81a, lsl #16
    43cc: 0b120032     	add	w18, w1, w18
    43d0: 0b09022e     	add	w14, w17, w9
    43d4: 0b110249     	add	w9, w18, w17
    43d8: 138e19c1     	ror	w1, w14, #0x6
    43dc: 0a0e0183     	and	w3, w12, w14
    43e0: 2954cbf1     	ldp	w17, w18, [sp, #0xa4]
    43e4: 13890922     	ror	w2, w9, #0x2
    43e8: 4ace2c21     	eor	w1, w1, w14, ror #11
    43ec: 0b0d022d     	add	w13, w17, w13
    43f0: 0a2e01f1     	bic	w17, w15, w14
    43f4: 4ac93442     	eor	w2, w2, w9, ror #13
    43f8: 2a110071     	orr	w17, w3, w17
    43fc: 2a0b0103     	orr	w3, w8, w11
    4400: 4ace6421     	eor	w1, w1, w14, ror #25
    4404: 0b1101ad     	add	w13, w13, w17
    4408: 0a0b0111     	and	w17, w8, w11
    440c: 0a030123     	and	w3, w9, w3
    4410: 4ac95842     	eor	w2, w2, w9, ror #22
    4414: 2a110071     	orr	w17, w3, w17
    4418: 0b1001ad     	add	w13, w13, w16
    441c: 0b0101b0     	add	w16, w13, w1
    4420: 0b0f024f     	add	w15, w18, w15
    4424: 2a080132     	orr	w18, w9, w8
    4428: 0b110051     	add	w17, w2, w17
    442c: 0b0a020d     	add	w13, w16, w10
    4430: 0b10022a     	add	w10, w17, w16
    4434: 138d19b1     	ror	w17, w13, #0x6
    4438: 0a2d0182     	bic	w2, w12, w13
    443c: 138a0941     	ror	w1, w10, #0x2
    4440: 0a0d01c3     	and	w3, w14, w13
    4444: 52916e10     	mov	w16, #0x8b70            // =35696
    4448: 4acd2e31     	eor	w17, w17, w13, ror #11
    444c: 2a020062     	orr	w2, w3, w2
    4450: 72b84970     	movk	w16, #0xc24b, lsl #16
    4454: 4aca3421     	eor	w1, w1, w10, ror #13
    4458: 0a080123     	and	w3, w9, w8
    445c: 0a120152     	and	w18, w10, w18
    4460: 0b0201ef     	add	w15, w15, w2
    4464: 4acd6631     	eor	w17, w17, w13, ror #25
    4468: 2a030252     	orr	w18, w18, w3
    446c: 4aca5821     	eor	w1, w1, w10, ror #22
    4470: 0b1001ef     	add	w15, w15, w16
    4474: 528a3470     	mov	w16, #0x51a3            // =20899
    4478: 0b1101f1     	add	w17, w15, w17
    447c: 72b8ed90     	movk	w16, #0xc76c, lsl #16
    4480: 0b120032     	add	w18, w1, w18
    4484: 0b0b022f     	add	w15, w17, w11
    4488: 0b11024b     	add	w11, w18, w17
    448c: 138f19e1     	ror	w1, w15, #0x6
    4490: 0a0f01a3     	and	w3, w13, w15
    4494: 2955cbf1     	ldp	w17, w18, [sp, #0xac]
    4498: 138b0962     	ror	w2, w11, #0x2
    449c: 4acf2c21     	eor	w1, w1, w15, ror #11
    44a0: 0b0c022c     	add	w12, w17, w12
    44a4: 0a2f01d1     	bic	w17, w14, w15
    44a8: 4acb3442     	eor	w2, w2, w11, ror #13
    44ac: 2a110071     	orr	w17, w3, w17
    44b0: 2a090143     	orr	w3, w10, w9
    44b4: 4acf6421     	eor	w1, w1, w15, ror #25
    44b8: 0b11018c     	add	w12, w12, w17
    44bc: 0a090151     	and	w17, w10, w9
    44c0: 0a030163     	and	w3, w11, w3
    44c4: 4acb5842     	eor	w2, w2, w11, ror #22
    44c8: 2a110071     	orr	w17, w3, w17
    44cc: 0b10018c     	add	w12, w12, w16
    44d0: 0b010190     	add	w16, w12, w1
    44d4: 0b0e024e     	add	w14, w18, w14
    44d8: 2a0a0172     	orr	w18, w11, w10
    44dc: 0b110051     	add	w17, w2, w17
    44e0: 0b08020c     	add	w12, w16, w8
    44e4: 0b100228     	add	w8, w17, w16
    44e8: 138c1991     	ror	w17, w12, #0x6
    44ec: 0a2c01a2     	bic	w2, w13, w12
    44f0: 13880901     	ror	w1, w8, #0x2
    44f4: 0a0c01e3     	and	w3, w15, w12
    44f8: 529d0330     	mov	w16, #0xe819            // =59417
    44fc: 4acc2e31     	eor	w17, w17, w12, ror #11
    4500: 2a020062     	orr	w2, w3, w2
    4504: 72ba3250     	movk	w16, #0xd192, lsl #16
    4508: 4ac83421     	eor	w1, w1, w8, ror #13
    450c: 0a0a0163     	and	w3, w11, w10
    4510: 0a120112     	and	w18, w8, w18
    4514: 0b0201ce     	add	w14, w14, w2
    4518: 4acc6631     	eor	w17, w17, w12, ror #25
    451c: 2a030252     	orr	w18, w18, w3
    4520: 4ac85821     	eor	w1, w1, w8, ror #22
    4524: 0b1001ce     	add	w14, w14, w16
    4528: 5280c490     	mov	w16, #0x624             // =1572
    452c: 0b1101d1     	add	w17, w14, w17
    4530: 72bad330     	movk	w16, #0xd699, lsl #16
    4534: 0b120032     	add	w18, w1, w18
    4538: 0b09022e     	add	w14, w17, w9
    453c: 0b110249     	add	w9, w18, w17
    4540: 138e19c1     	ror	w1, w14, #0x6
    4544: 0a0e0183     	and	w3, w12, w14
    4548: 2956cbf1     	ldp	w17, w18, [sp, #0xb4]
    454c: 13890922     	ror	w2, w9, #0x2
    4550: 4ace2c21     	eor	w1, w1, w14, ror #11
    4554: 0b0d022d     	add	w13, w17, w13
    4558: 0a2e01f1     	bic	w17, w15, w14
    455c: 4ac93442     	eor	w2, w2, w9, ror #13
    4560: 2a110071     	orr	w17, w3, w17
    4564: 2a0b0103     	orr	w3, w8, w11
    4568: 4ace6421     	eor	w1, w1, w14, ror #25
    456c: 0b1101ad     	add	w13, w13, w17
    4570: 0a0b0111     	and	w17, w8, w11
    4574: 0a030123     	and	w3, w9, w3
    4578: 4ac95842     	eor	w2, w2, w9, ror #22
    457c: 2a110071     	orr	w17, w3, w17
    4580: 0b1001ad     	add	w13, w13, w16
    4584: 0b0101b0     	add	w16, w13, w1
    4588: 0b0f024f     	add	w15, w18, w15
    458c: 2a080132     	orr	w18, w9, w8
    4590: 0b110051     	add	w17, w2, w17
    4594: 0b0a020d     	add	w13, w16, w10
    4598: 0b10022a     	add	w10, w17, w16
    459c: 138d19b1     	ror	w17, w13, #0x6
    45a0: 0a2d0182     	bic	w2, w12, w13
    45a4: 138a0941     	ror	w1, w10, #0x2
    45a8: 0a0d01c3     	and	w3, w14, w13
    45ac: 5286b0b0     	mov	w16, #0x3585            // =13701
    45b0: 4acd2e31     	eor	w17, w17, w13, ror #11
    45b4: 2a020062     	orr	w2, w3, w2
    45b8: 72be81d0     	movk	w16, #0xf40e, lsl #16
    45bc: 4aca3421     	eor	w1, w1, w10, ror #13
    45c0: 0a080123     	and	w3, w9, w8
    45c4: 0a120152     	and	w18, w10, w18
    45c8: 0b0201ef     	add	w15, w15, w2
    45cc: 4acd6631     	eor	w17, w17, w13, ror #25
    45d0: 2a030252     	orr	w18, w18, w3
    45d4: 4aca5821     	eor	w1, w1, w10, ror #22
    45d8: 0b1001ef     	add	w15, w15, w16
    45dc: 52940e10     	mov	w16, #0xa070            // =41072
    45e0: 0b1101f1     	add	w17, w15, w17
    45e4: 72a20d50     	movk	w16, #0x106a, lsl #16
    45e8: 0b120032     	add	w18, w1, w18
    45ec: 0b0b022f     	add	w15, w17, w11
    45f0: 0b11024b     	add	w11, w18, w17
    45f4: 138f19e1     	ror	w1, w15, #0x6
    45f8: 0a0f01a3     	and	w3, w13, w15
    45fc: 2957cbf1     	ldp	w17, w18, [sp, #0xbc]
    4600: 138b0962     	ror	w2, w11, #0x2
    4604: 4acf2c21     	eor	w1, w1, w15, ror #11
    4608: 0b0c022c     	add	w12, w17, w12
    460c: 0a2f01d1     	bic	w17, w14, w15
    4610: 4acb3442     	eor	w2, w2, w11, ror #13
    4614: 2a110071     	orr	w17, w3, w17
    4618: 2a090143     	orr	w3, w10, w9
    461c: 4acf6421     	eor	w1, w1, w15, ror #25
    4620: 0b11018c     	add	w12, w12, w17
    4624: 0a090151     	and	w17, w10, w9
    4628: 0a030163     	and	w3, w11, w3
    462c: 4acb5842     	eor	w2, w2, w11, ror #22
    4630: 2a110071     	orr	w17, w3, w17
    4634: 0b10018c     	add	w12, w12, w16
    4638: 0b010190     	add	w16, w12, w1
    463c: 0b0e024e     	add	w14, w18, w14
    4640: 2a0a0172     	orr	w18, w11, w10
    4644: 0b110051     	add	w17, w2, w17
    4648: 0b08020c     	add	w12, w16, w8
    464c: 0b100228     	add	w8, w17, w16
    4650: 138c1991     	ror	w17, w12, #0x6
    4654: 0a2c01a2     	bic	w2, w13, w12
    4658: 13880901     	ror	w1, w8, #0x2
    465c: 0a0c01e3     	and	w3, w15, w12
    4660: 529822d0     	mov	w16, #0xc116            // =49430
    4664: 4acc2e31     	eor	w17, w17, w12, ror #11
    4668: 2a020062     	orr	w2, w3, w2
    466c: 72a33490     	movk	w16, #0x19a4, lsl #16
    4670: 4ac83421     	eor	w1, w1, w8, ror #13
    4674: 0a0a0163     	and	w3, w11, w10
    4678: 0a120112     	and	w18, w8, w18
    467c: 0b0201ce     	add	w14, w14, w2
    4680: 4acc6631     	eor	w17, w17, w12, ror #25
    4684: 2a030252     	orr	w18, w18, w3
    4688: 4ac85821     	eor	w1, w1, w8, ror #22
    468c: 0b1001ce     	add	w14, w14, w16
    4690: 528d8110     	mov	w16, #0x6c08            // =27656
    4694: 0b1101d1     	add	w17, w14, w17
    4698: 72a3c6f0     	movk	w16, #0x1e37, lsl #16
    469c: 0b120032     	add	w18, w1, w18
    46a0: 0b09022e     	add	w14, w17, w9
    46a4: 0b110249     	add	w9, w18, w17
    46a8: 138e19c1     	ror	w1, w14, #0x6
    46ac: 0a0e0183     	and	w3, w12, w14
    46b0: 2958cbf1     	ldp	w17, w18, [sp, #0xc4]
    46b4: 13890922     	ror	w2, w9, #0x2
    46b8: 4ace2c21     	eor	w1, w1, w14, ror #11
    46bc: 0b0d022d     	add	w13, w17, w13
    46c0: 0a2e01f1     	bic	w17, w15, w14
    46c4: 4ac93442     	eor	w2, w2, w9, ror #13
    46c8: 2a110071     	orr	w17, w3, w17
    46cc: 2a0b0103     	orr	w3, w8, w11
    46d0: 4ace6421     	eor	w1, w1, w14, ror #25
    46d4: 0b1101ad     	add	w13, w13, w17
    46d8: 0a0b0111     	and	w17, w8, w11
    46dc: 0a030123     	and	w3, w9, w3
    46e0: 4ac95842     	eor	w2, w2, w9, ror #22
    46e4: 2a110071     	orr	w17, w3, w17
    46e8: 0b1001ad     	add	w13, w13, w16
    46ec: 0b0101b0     	add	w16, w13, w1
    46f0: 0b0f024f     	add	w15, w18, w15
    46f4: 2a080132     	orr	w18, w9, w8
    46f8: 0b110051     	add	w17, w2, w17
    46fc: 0b0a020d     	add	w13, w16, w10
    4700: 0b10022a     	add	w10, w17, w16
    4704: 138d19b1     	ror	w17, w13, #0x6
    4708: 0a2d0182     	bic	w2, w12, w13
    470c: 138a0941     	ror	w1, w10, #0x2
    4710: 0a0d01c3     	and	w3, w14, w13
    4714: 528ee990     	mov	w16, #0x774c            // =30540
    4718: 4acd2e31     	eor	w17, w17, w13, ror #11
    471c: 2a020062     	orr	w2, w3, w2
    4720: 72a4e910     	movk	w16, #0x2748, lsl #16
    4724: 4aca3421     	eor	w1, w1, w10, ror #13
    4728: 0a080123     	and	w3, w9, w8
    472c: 0a120152     	and	w18, w10, w18
    4730: 0b0201ef     	add	w15, w15, w2
    4734: 4acd6631     	eor	w17, w17, w13, ror #25
    4738: 2a030252     	orr	w18, w18, w3
    473c: 4aca5821     	eor	w1, w1, w10, ror #22
    4740: 0b1001ef     	add	w15, w15, w16
    4744: 529796b0     	mov	w16, #0xbcb5            // =48309
    4748: 0b1101f1     	add	w17, w15, w17
    474c: 72a69610     	movk	w16, #0x34b0, lsl #16
    4750: 0b120032     	add	w18, w1, w18
    4754: 0b0b022f     	add	w15, w17, w11
    4758: 0b11024b     	add	w11, w18, w17
    475c: 138f19e1     	ror	w1, w15, #0x6
    4760: 0a0f01a3     	and	w3, w13, w15
    4764: 2959cbf1     	ldp	w17, w18, [sp, #0xcc]
    4768: 138b0962     	ror	w2, w11, #0x2
    476c: 4acf2c21     	eor	w1, w1, w15, ror #11
    4770: 0b0c022c     	add	w12, w17, w12
    4774: 0a2f01d1     	bic	w17, w14, w15
    4778: 4acb3442     	eor	w2, w2, w11, ror #13
    477c: 2a110071     	orr	w17, w3, w17
    4780: 2a090143     	orr	w3, w10, w9
    4784: 4acf6421     	eor	w1, w1, w15, ror #25
    4788: 0b11018c     	add	w12, w12, w17
    478c: 0a090151     	and	w17, w10, w9
    4790: 0a030163     	and	w3, w11, w3
    4794: 4acb5842     	eor	w2, w2, w11, ror #22
    4798: 2a110071     	orr	w17, w3, w17
    479c: 0b10018c     	add	w12, w12, w16
    47a0: 0b010190     	add	w16, w12, w1
    47a4: 0b0e024e     	add	w14, w18, w14
    47a8: 2a0a0172     	orr	w18, w11, w10
    47ac: 0b110051     	add	w17, w2, w17
    47b0: 0b08020c     	add	w12, w16, w8
    47b4: 0b100228     	add	w8, w17, w16
    47b8: 138c1991     	ror	w17, w12, #0x6
    47bc: 0a2c01a2     	bic	w2, w13, w12
    47c0: 13880901     	ror	w1, w8, #0x2
    47c4: 0a0c01e3     	and	w3, w15, w12
    47c8: 52819670     	mov	w16, #0xcb3             // =3251
    47cc: 4acc2e31     	eor	w17, w17, w12, ror #11
    47d0: 2a020062     	orr	w2, w3, w2
    47d4: 72a72390     	movk	w16, #0x391c, lsl #16
    47d8: 4ac83421     	eor	w1, w1, w8, ror #13
    47dc: 0a0a0163     	and	w3, w11, w10
    47e0: 0a120112     	and	w18, w8, w18
    47e4: 0b0201ce     	add	w14, w14, w2
    47e8: 4acc6631     	eor	w17, w17, w12, ror #25
    47ec: 2a030252     	orr	w18, w18, w3
    47f0: 4ac85821     	eor	w1, w1, w8, ror #22
    47f4: 0b1001ce     	add	w14, w14, w16
    47f8: 52954942     	mov	w2, #0xaa4a             // =43594
    47fc: 0b1101ce     	add	w14, w14, w17
    4800: 72a9db02     	movk	w2, #0x4ed8, lsl #16
    4804: 0b120031     	add	w17, w1, w18
    4808: 0b0901d0     	add	w16, w14, w9
    480c: 0b0e0229     	add	w9, w17, w14
    4810: 13901a12     	ror	w18, w16, #0x6
    4814: 0a100183     	and	w3, w12, w16
    4818: 295ac7ee     	ldp	w14, w17, [sp, #0xd4]
    481c: 13890921     	ror	w1, w9, #0x2
    4820: 4ad02e52     	eor	w18, w18, w16, ror #11
    4824: 0b0d01cd     	add	w13, w14, w13
    4828: 0a3001ee     	bic	w14, w15, w16
    482c: 4ac93421     	eor	w1, w1, w9, ror #13
    4830: 2a0e006e     	orr	w14, w3, w14
    4834: 2a0b0103     	orr	w3, w8, w11
    4838: 4ad06652     	eor	w18, w18, w16, ror #25
    483c: 0b0e01ad     	add	w13, w13, w14
    4840: 0a0b010e     	and	w14, w8, w11
    4844: 0a030123     	and	w3, w9, w3
    4848: 4ac95821     	eor	w1, w1, w9, ror #22
    484c: 2a0e006e     	orr	w14, w3, w14
    4850: 0b0201ad     	add	w13, w13, w2
    4854: 0b1201b2     	add	w18, w13, w18
    4858: 0b0f022f     	add	w15, w17, w15
    485c: 2a080131     	orr	w17, w9, w8
    4860: 0b0e002e     	add	w14, w1, w14
    4864: 0b0a024d     	add	w13, w18, w10
    4868: 0b1201ca     	add	w10, w14, w18
    486c: 138d19b2     	ror	w18, w13, #0x6
    4870: 0a2d0182     	bic	w2, w12, w13
    4874: 138a0941     	ror	w1, w10, #0x2
    4878: 0a0d0203     	and	w3, w16, w13
    487c: 529949ee     	mov	w14, #0xca4f            // =51791
    4880: 4acd2e52     	eor	w18, w18, w13, ror #11
    4884: 2a020062     	orr	w2, w3, w2
    4888: 72ab738e     	movk	w14, #0x5b9c, lsl #16
    488c: 4aca3421     	eor	w1, w1, w10, ror #13
    4890: 0a080123     	and	w3, w9, w8
    4894: 0a110151     	and	w17, w10, w17
    4898: 0b0201ef     	add	w15, w15, w2
    489c: 4acd6652     	eor	w18, w18, w13, ror #25
    48a0: 2a030231     	orr	w17, w17, w3
    48a4: 4aca5821     	eor	w1, w1, w10, ror #22
    48a8: 0b0e01ee     	add	w14, w15, w14
    48ac: 528dfe62     	mov	w2, #0x6ff3             // =28659
    48b0: 0b1201ce     	add	w14, w14, w18
    48b4: 72ad05c2     	movk	w2, #0x682e, lsl #16
    48b8: 0b110031     	add	w17, w1, w17
    48bc: 0b0b01cf     	add	w15, w14, w11
    48c0: 0b0e022b     	add	w11, w17, w14
    48c4: 138f19f2     	ror	w18, w15, #0x6
    48c8: 0a0f01a3     	and	w3, w13, w15
    48cc: 295bc7ee     	ldp	w14, w17, [sp, #0xdc]
    48d0: 138b0961     	ror	w1, w11, #0x2
    48d4: 4acf2e52     	eor	w18, w18, w15, ror #11
    48d8: 0b0c01cc     	add	w12, w14, w12
    48dc: 0a2f020e     	bic	w14, w16, w15
    48e0: 4acb3421     	eor	w1, w1, w11, ror #13
    48e4: 2a0e006e     	orr	w14, w3, w14
    48e8: 2a090143     	orr	w3, w10, w9
    48ec: 4acf6652     	eor	w18, w18, w15, ror #25
    48f0: 0b0e018c     	add	w12, w12, w14
    48f4: 0a09014e     	and	w14, w10, w9
    48f8: 0a030163     	and	w3, w11, w3
    48fc: 4acb5821     	eor	w1, w1, w11, ror #22
    4900: 2a0e006e     	orr	w14, w3, w14
    4904: 0b02018c     	add	w12, w12, w2
    4908: 0b12018c     	add	w12, w12, w18
    490c: 0b100230     	add	w16, w17, w16
    4910: 2a0a0171     	orr	w17, w11, w10
    4914: 0b0e0032     	add	w18, w1, w14
    4918: 0b08018e     	add	w14, w12, w8
    491c: 52905dc8     	mov	w8, #0x82ee             // =33518
    4920: 0b0c024c     	add	w12, w18, w12
    4924: 138e19d2     	ror	w18, w14, #0x6
    4928: 0a2e01a2     	bic	w2, w13, w14
    492c: 138c0981     	ror	w1, w12, #0x2
    4930: 0a0e01e3     	and	w3, w15, w14
    4934: 72ae91e8     	movk	w8, #0x748f, lsl #16
    4938: 4ace2e52     	eor	w18, w18, w14, ror #11
    493c: 2a020062     	orr	w2, w3, w2
    4940: 0a0a0163     	and	w3, w11, w10
    4944: 4acc3421     	eor	w1, w1, w12, ror #13
    4948: 0a110191     	and	w17, w12, w17
    494c: 0b020210     	add	w16, w16, w2
    4950: 4ace6652     	eor	w18, w18, w14, ror #25
    4954: 2a030231     	orr	w17, w17, w3
    4958: 0b080208     	add	w8, w16, w8
    495c: 4acc5821     	eor	w1, w1, w12, ror #22
    4960: 528c6de2     	mov	w2, #0x636f             // =25455
    4964: 0b120108     	add	w8, w8, w18
    4968: 72af14a2     	movk	w2, #0x78a5, lsl #16
    496c: 0b110031     	add	w17, w1, w17
    4970: 0b090110     	add	w16, w8, w9
    4974: 0b080229     	add	w9, w17, w8
    4978: 13901a12     	ror	w18, w16, #0x6
    497c: 0a1001c3     	and	w3, w14, w16
    4980: 295cc7e8     	ldp	w8, w17, [sp, #0xe4]
    4984: 13890921     	ror	w1, w9, #0x2
    4988: 4ad02e52     	eor	w18, w18, w16, ror #11
    498c: 0b0d0108     	add	w8, w8, w13
    4990: 0a3001ed     	bic	w13, w15, w16
    4994: 4ac93421     	eor	w1, w1, w9, ror #13
    4998: 2a0d006d     	orr	w13, w3, w13
    499c: 2a0b0183     	orr	w3, w12, w11
    49a0: 4ad06652     	eor	w18, w18, w16, ror #25
    49a4: 0b0d0108     	add	w8, w8, w13
    49a8: 0a0b018d     	and	w13, w12, w11
    49ac: 0a030123     	and	w3, w9, w3
    49b0: 4ac95821     	eor	w1, w1, w9, ror #22
    49b4: 2a0d006d     	orr	w13, w3, w13
    49b8: 0b020108     	add	w8, w8, w2
    49bc: 0b120108     	add	w8, w8, w18
    49c0: 0b0f022f     	add	w15, w17, w15
    49c4: 2a0c0131     	orr	w17, w9, w12
    49c8: 0b0d0032     	add	w18, w1, w13
    49cc: 0b0a010d     	add	w13, w8, w10
    49d0: 528f028a     	mov	w10, #0x7814            // =30740
    49d4: 0b080248     	add	w8, w18, w8
    49d8: 138d19b2     	ror	w18, w13, #0x6
    49dc: 0a2d01c2     	bic	w2, w14, w13
    49e0: 13880901     	ror	w1, w8, #0x2
    49e4: 0a0d0203     	and	w3, w16, w13
    49e8: 72b0990a     	movk	w10, #0x84c8, lsl #16
    49ec: 4acd2e52     	eor	w18, w18, w13, ror #11
    49f0: 2a020062     	orr	w2, w3, w2
    49f4: 0a0c0123     	and	w3, w9, w12
    49f8: 4ac83421     	eor	w1, w1, w8, ror #13
    49fc: 0a110111     	and	w17, w8, w17
    4a00: 0b0201ef     	add	w15, w15, w2
    4a04: 4acd6652     	eor	w18, w18, w13, ror #25
    4a08: 2a030231     	orr	w17, w17, w3
    4a0c: 0b0a01ea     	add	w10, w15, w10
    4a10: 4ac85821     	eor	w1, w1, w8, ror #22
    4a14: 52804102     	mov	w2, #0x208              // =520
    4a18: 0b12014a     	add	w10, w10, w18
    4a1c: 72b198e2     	movk	w2, #0x8cc7, lsl #16
    4a20: 0b110031     	add	w17, w1, w17
    4a24: 0b0b014f     	add	w15, w10, w11
    4a28: 0b0a022a     	add	w10, w17, w10
    4a2c: 138f19f2     	ror	w18, w15, #0x6
    4a30: 0a0f01a3     	and	w3, w13, w15
    4a34: 295dc7eb     	ldp	w11, w17, [sp, #0xec]
    4a38: 138a0941     	ror	w1, w10, #0x2
    4a3c: 4acf2e52     	eor	w18, w18, w15, ror #11
    4a40: 0b0e016b     	add	w11, w11, w14
    4a44: 0a2f020e     	bic	w14, w16, w15
    4a48: 4aca3421     	eor	w1, w1, w10, ror #13
    4a4c: 2a0e006e     	orr	w14, w3, w14
    4a50: 2a090103     	orr	w3, w8, w9
    4a54: 4acf6652     	eor	w18, w18, w15, ror #25
    4a58: 0b0e016b     	add	w11, w11, w14
    4a5c: 0a09010e     	and	w14, w8, w9
    4a60: 0a030143     	and	w3, w10, w3
    4a64: 4aca5821     	eor	w1, w1, w10, ror #22
    4a68: 2a0e006e     	orr	w14, w3, w14
    4a6c: 0b02016b     	add	w11, w11, w2
    4a70: 0b12016b     	add	w11, w11, w18
    4a74: 0b100230     	add	w16, w17, w16
    4a78: 2a080151     	orr	w17, w10, w8
    4a7c: 0b0e002e     	add	w14, w1, w14
    4a80: 0b0c016c     	add	w12, w11, w12
    4a84: 0b0b01cb     	add	w11, w14, w11
    4a88: 138c1992     	ror	w18, w12, #0x6
    4a8c: 0a2c01a2     	bic	w2, w13, w12
    4a90: 138b0961     	ror	w1, w11, #0x2
    4a94: 0a0c01e3     	and	w3, w15, w12
    4a98: 529fff4e     	mov	w14, #0xfffa            // =65530
    4a9c: 4acc2e52     	eor	w18, w18, w12, ror #11
    4aa0: 2a020062     	orr	w2, w3, w2
    4aa4: 72b217ce     	movk	w14, #0x90be, lsl #16
    4aa8: 4acb3421     	eor	w1, w1, w11, ror #13
    4aac: 0a080143     	and	w3, w10, w8
    4ab0: 0a110171     	and	w17, w11, w17
    4ab4: 0b020210     	add	w16, w16, w2
    4ab8: 4acc6652     	eor	w18, w18, w12, ror #25
    4abc: 2a030231     	orr	w17, w17, w3
    4ac0: 4acb5821     	eor	w1, w1, w11, ror #22
    4ac4: 0b0e020e     	add	w14, w16, w14
    4ac8: 0b1201ce     	add	w14, w14, w18
    4acc: 0b110031     	add	w17, w1, w17
    4ad0: 0b0901c9     	add	w9, w14, w9
    4ad4: 295ec3f2     	ldp	w18, w16, [sp, #0xf4]
    4ad8: 0b0e022e     	add	w14, w17, w14
    4adc: 13891921     	ror	w1, w9, #0x6
    4ae0: 0a090183     	and	w3, w12, w9
    4ae4: 138e09c2     	ror	w2, w14, #0x2
    4ae8: 528d9d71     	mov	w17, #0x6ceb            // =27883
    4aec: 0b0d024d     	add	w13, w18, w13
    4af0: 0a2901f2     	bic	w18, w15, w9
    4af4: 4ac92c21     	eor	w1, w1, w9, ror #11
    4af8: 4ace3442     	eor	w2, w2, w14, ror #13
    4afc: 2a120072     	orr	w18, w3, w18
    4b00: 2a0a0163     	orr	w3, w11, w10
    4b04: 72b48a11     	movk	w17, #0xa450, lsl #16
    4b08: 0b1201ad     	add	w13, w13, w18
    4b0c: 0a0a0172     	and	w18, w11, w10
    4b10: 0a0301c3     	and	w3, w14, w3
    4b14: 4ac96421     	eor	w1, w1, w9, ror #25
    4b18: 4ace5842     	eor	w2, w2, w14, ror #22
    4b1c: 2a120072     	orr	w18, w3, w18
    4b20: 0b1101ad     	add	w13, w13, w17
    4b24: 0b0f020f     	add	w15, w16, w15
    4b28: 0b0101ad     	add	w13, w13, w1
    4b2c: 0b120051     	add	w17, w2, w18
    4b30: 0b0801a8     	add	w8, w13, w8
    4b34: 0b0d022d     	add	w13, w17, w13
    4b38: 52947ef1     	mov	w17, #0xa3f7            // =41975
    4b3c: 13881912     	ror	w18, w8, #0x6
    4b40: 138d09a1     	ror	w1, w13, #0x2
    4b44: 0a280190     	bic	w16, w12, w8
    4b48: 0a080122     	and	w2, w9, w8
    4b4c: 72b7df31     	movk	w17, #0xbef9, lsl #16
    4b50: 4ac82e52     	eor	w18, w18, w8, ror #11
    4b54: 4acd3421     	eor	w1, w1, w13, ror #13
    4b58: 2a100050     	orr	w16, w2, w16
    4b5c: 2a0b01c2     	orr	w2, w14, w11
    4b60: 0b1001ef     	add	w15, w15, w16
    4b64: 0a0b01d0     	and	w16, w14, w11
    4b68: 0a0201a2     	and	w2, w13, w2
    4b6c: 4ac86652     	eor	w18, w18, w8, ror #25
    4b70: 4acd5821     	eor	w1, w1, w13, ror #22
    4b74: 2a100050     	orr	w16, w2, w16
    4b78: 0b1101ef     	add	w15, w15, w17
    4b7c: b940fff1     	ldr	w17, [sp, #0xfc]
    4b80: 0b1201ef     	add	w15, w15, w18
    4b84: 0b100030     	add	w16, w1, w16
    4b88: 0b0a01ea     	add	w10, w15, w10
    4b8c: 0b0f020f     	add	w15, w16, w15
    4b90: 0b0c022c     	add	w12, w17, w12
    4b94: 138a1952     	ror	w18, w10, #0x6
    4b98: 138f09e1     	ror	w1, w15, #0x2
    4b9c: 0a2a0131     	bic	w17, w9, w10
    4ba0: 0a0a0102     	and	w2, w8, w10
    4ba4: 528f1e50     	mov	w16, #0x78f2            // =30962
    4ba8: 4aca2e52     	eor	w18, w18, w10, ror #11
    4bac: 4acf3421     	eor	w1, w1, w15, ror #13
    4bb0: 2a110051     	orr	w17, w2, w17
    4bb4: 2a0e01a2     	orr	w2, w13, w14
    4bb8: 72b8ce30     	movk	w16, #0xc671, lsl #16
    4bbc: 0b11018c     	add	w12, w12, w17
    4bc0: 0a0e01b1     	and	w17, w13, w14
    4bc4: 0a0201e2     	and	w2, w15, w2
    4bc8: 4aca6652     	eor	w18, w18, w10, ror #25
    4bcc: 4acf5821     	eor	w1, w1, w15, ror #22
    4bd0: 2a110051     	orr	w17, w2, w17
    4bd4: 0b10018c     	add	w12, w12, w16
    4bd8: 0b12018c     	add	w12, w12, w18
    4bdc: 0b110030     	add	w16, w1, w17
    4be0: 0b0b018b     	add	w11, w12, w11
    4be4: 0b0c0210     	add	w16, w16, w12
    4be8: 1e270161     	fmov	s1, w11
    4bec: 1e270200     	fmov	s0, w16
    4bf0: 4e0c1d41     	mov	v1.s[1], w10
    4bf4: 4e0c1de0     	mov	v0.s[1], w15
    4bf8: 4e141d01     	mov	v1.s[2], w8
    4bfc: 4e141da0     	mov	v0.s[2], w13
    4c00: 4e1c1d21     	mov	v1.s[3], w9
    4c04: 4e1c1dc0     	mov	v0.s[3], w14
    4c08: 4ea18461     	add	v1.4s, v3.4s, v1.4s
    4c0c: 4ea08440     	add	v0.4s, v2.4s, v0.4s
    4c10: ad000400     	stp	q0, q1, [x0]
    4c14: a9507bfd     	ldp	x29, x30, [sp, #0x100]
    4c18: 910443ff     	add	sp, sp, #0x110
    4c1c: d65f03c0     	ret

0000000000004c20 <audit_master256>:
    4c20: d10643ff     	sub	sp, sp, #0x190
    4c24: a9177bfd     	stp	x29, x30, [sp, #0x170]
    4c28: a9184ffc     	stp	x28, x19, [sp, #0x180]
    4c2c: 9105c3fd     	add	x29, sp, #0x170
    4c30: 90000009     	adrp	x9, 0x4000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0xb28>
		0000000000004c30:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32+0x20
    4c34: 91000129     	add	x9, x9, #0x0
		0000000000004c34:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32+0x20
    4c38: 52840008     	mov	w8, #0x2000             // =8192
    4c3c: ad400920     	ldp	q0, q2, [x9]
    4c40: 790083e8     	strh	w8, [sp, #0x40]
    4c44: 528001a8     	mov	w8, #0xd                // =13
    4c48: 90000009     	adrp	x9, 0x4000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0xb28>
		0000000000004c48:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xf0
    4c4c: 91000129     	add	x9, x9, #0x0
		0000000000004c4c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xf0
    4c50: f940012a     	ldr	x10, [x9]
    4c54: 39010be8     	strb	w8, [sp, #0x42]
    4c58: f8405128     	ldur	x8, [x9, #0x5]
    4c5c: 3c8513e0     	stur	q0, [sp, #0x51]
    4c60: ad400001     	ldp	q1, q0, [x0]
    4c64: aa0103f3     	mov	x19, x1
    4c68: f80433ea     	stur	x10, [sp, #0x43]
    4c6c: 910083e0     	add	x0, sp, #0x20
    4c70: f90027e8     	str	x8, [sp, #0x48]
    4c74: 52800408     	mov	w8, #0x20               // =32
    4c78: 910103e2     	add	x2, sp, #0x40
    4c7c: d10083a4     	sub	x4, x29, #0x20
    4c80: 52800401     	mov	w1, #0x20               // =32
    4c84: 52800623     	mov	w3, #0x31               // =49
    4c88: ad3f03a1     	stp	q1, q0, [x29, #-0x20]
    4c8c: 390143e8     	strb	w8, [sp, #0x50]
    4c90: 3c8613e2     	stur	q2, [sp, #0x61]
    4c94: 97fff88a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    4c98: 90000002     	adrp	x2, 0x4000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0xb28>
		0000000000004c98:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32
    4c9c: 91000042     	add	x2, x2, #0x0
		0000000000004c9c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32
    4ca0: 910003e0     	mov	x0, sp
    4ca4: 910083e1     	add	x1, sp, #0x20
    4ca8: 94000007     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    4cac: ad4007e0     	ldp	q0, q1, [sp]
    4cb0: ad000660     	stp	q0, q1, [x19]
    4cb4: a9584ffc     	ldp	x28, x19, [sp, #0x180]
    4cb8: a9577bfd     	ldp	x29, x30, [sp, #0x170]
    4cbc: 910643ff     	add	sp, sp, #0x190
    4cc0: d65f03c0     	ret

0000000000004cc4 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
    4cc4: d10683ff     	sub	sp, sp, #0x1a0
    4cc8: a9167bfd     	stp	x29, x30, [sp, #0x160]
    4ccc: a9175ffc     	stp	x28, x23, [sp, #0x170]
    4cd0: a91857f6     	stp	x22, x21, [sp, #0x180]
    4cd4: a9194ff4     	stp	x20, x19, [sp, #0x190]
    4cd8: 910583fd     	add	x29, sp, #0x160
    4cdc: aa0003f3     	mov	x19, x0
    4ce0: 910083e0     	add	x0, sp, #0x20
    4ce4: aa0203f4     	mov	x20, x2
    4ce8: 910083f7     	add	x23, sp, #0x20
    4cec: 97fff97f     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
    4cf0: 394223e8     	ldrb	w8, [sp, #0x88]
    4cf4: 34000228     	cbz	w8,  <L1>
    4cf8: 7100811f     	cmp	w8, #0x20
    4cfc: 540001e3     	b.lo	 <L1>
    4d00: 52800809     	mov	w9, #0x40               // =64
    4d04: 910083ea     	add	x10, sp, #0x20
    4d08: aa1403e1     	mov	x1, x20
    4d0c: cb080135     	sub	x21, x9, x8
    4d10: 9100a156     	add	x22, x10, #0x28
    4d14: 8b0802c0     	add	x0, x22, x8
    4d18: aa1503e2     	mov	x2, x21
<L0>:
    4d1c: 94000000     	bl	 <L0>
		0000000000004d1c:  R_AARCH64_CALL26	memcpy
    4d20: 910083e0     	add	x0, sp, #0x20
    4d24: aa1603e1     	mov	x1, x22
    4d28: 97fff9ec     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    4d2c: 2a1f03e8     	mov	w8, wzr
    4d30: 390223ff     	strb	wzr, [sp, #0x88]
    4d34: 14000002     	b	 <L2>
<L1>:
    4d38: aa1f03f5     	mov	x21, xzr
<L2>:
    4d3c: 52800409     	mov	w9, #0x20               // =32
    4d40: 8b2842e8     	add	x8, x23, w8, uxtw
    4d44: 8b150281     	add	x1, x20, x21
    4d48: cb150136     	sub	x22, x9, x21
    4d4c: 9100a100     	add	x0, x8, #0x28
    4d50: aa1603e2     	mov	x2, x22
<L3>:
    4d54: 94000000     	bl	 <L3>
		0000000000004d54:  R_AARCH64_CALL26	memcpy
    4d58: 394223e8     	ldrb	w8, [sp, #0x88]
    4d5c: f94023e9     	ldr	x9, [sp, #0x40]
    4d60: 910083e0     	add	x0, sp, #0x20
    4d64: d10243a1     	sub	x1, x29, #0x90
    4d68: 0b160108     	add	w8, w8, w22
    4d6c: 91008129     	add	x9, x9, #0x20
    4d70: d10243b6     	sub	x22, x29, #0x90
    4d74: 390223e8     	strb	w8, [sp, #0x88]
    4d78: f90023e9     	str	x9, [sp, #0x40]
    4d7c: 97fff98b     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    4d80: 90000008     	adrp	x8, 0x4000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0xb28>
		0000000000004d80:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x160
    4d84: 91000108     	add	x8, x8, #0x0
		0000000000004d84:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x160
    4d88: d101c3a0     	sub	x0, x29, #0x70
    4d8c: ad420500     	ldp	q0, q1, [x8, #0x40]
    4d90: 3dc01902     	ldr	q2, [x8, #0x60]
    4d94: 9101c2e1     	add	x1, x23, #0x70
    4d98: d101c3b4     	sub	x20, x29, #0x70
    4d9c: 3c9f03a2     	stur	q2, [x29, #-0x10]
    4da0: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
    4da4: ad400500     	ldp	q0, q1, [x8]
    4da8: ad3c87a0     	stp	q0, q1, [x29, #-0x70]
    4dac: ad410900     	ldp	q0, q2, [x8, #0x20]
    4db0: ad3d8ba0     	stp	q0, q2, [x29, #-0x50]
    4db4: 97fff9c9     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    4db8: f85b03a9     	ldur	x9, [x29, #-0x50]
    4dbc: 385f83a8     	ldurb	w8, [x29, #-0x8]
    4dc0: 9100a294     	add	x20, x20, #0x28
    4dc4: 91010137     	add	x23, x9, #0x40
    4dc8: f81b03b7     	stur	x23, [x29, #-0x50]
    4dcc: 34000208     	cbz	w8,  <L5>
    4dd0: 7100811f     	cmp	w8, #0x20
    4dd4: 540001c3     	b.lo	 <L5>
    4dd8: 52800809     	mov	w9, #0x40               // =64
    4ddc: 8b080280     	add	x0, x20, x8
    4de0: d10243a1     	sub	x1, x29, #0x90
    4de4: cb080135     	sub	x21, x9, x8
    4de8: aa1503e2     	mov	x2, x21
<L4>:
    4dec: 94000000     	bl	 <L4>
		0000000000004dec:  R_AARCH64_CALL26	memcpy
    4df0: d101c3a0     	sub	x0, x29, #0x70
    4df4: aa1403e1     	mov	x1, x20
    4df8: 97fff9b8     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    4dfc: f85b03b7     	ldur	x23, [x29, #-0x50]
    4e00: 2a1f03e8     	mov	w8, wzr
    4e04: 381f83bf     	sturb	wzr, [x29, #-0x8]
    4e08: 14000002     	b	 <L6>
<L5>:
    4e0c: aa1f03f5     	mov	x21, xzr
<L6>:
    4e10: 52800409     	mov	w9, #0x20               // =32
    4e14: 8b284280     	add	x0, x20, w8, uxtw
    4e18: 8b1502c1     	add	x1, x22, x21
    4e1c: cb150134     	sub	x20, x9, x21
    4e20: aa1403e2     	mov	x2, x20
<L7>:
    4e24: 94000000     	bl	 <L7>
		0000000000004e24:  R_AARCH64_CALL26	memcpy
    4e28: 385f83a8     	ldurb	w8, [x29, #-0x8]
    4e2c: 910082e9     	add	x9, x23, #0x20
    4e30: d101c3a0     	sub	x0, x29, #0x70
    4e34: 910003e1     	mov	x1, sp
    4e38: f81b03a9     	stur	x9, [x29, #-0x50]
    4e3c: 0b140108     	add	w8, w8, w20
    4e40: 381f83a8     	sturb	w8, [x29, #-0x8]
    4e44: 97fff959     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    4e48: ad4007e0     	ldp	q0, q1, [sp]
    4e4c: ad000660     	stp	q0, q1, [x19]
    4e50: a9594ff4     	ldp	x20, x19, [sp, #0x190]
    4e54: a95857f6     	ldp	x22, x21, [sp, #0x180]
    4e58: a9575ffc     	ldp	x28, x23, [sp, #0x170]
    4e5c: a9567bfd     	ldp	x29, x30, [sp, #0x160]
    4e60: 910683ff     	add	sp, sp, #0x1a0
    4e64: d65f03c0     	ret

0000000000004e68 <audit_handshake256>:
    4e68: d10683ff     	sub	sp, sp, #0x1a0
    4e6c: a9177bfd     	stp	x29, x30, [sp, #0x170]
    4e70: f900c3fc     	str	x28, [sp, #0x180]
    4e74: a9194ff4     	stp	x20, x19, [sp, #0x190]
    4e78: 9105c3fd     	add	x29, sp, #0x170
    4e7c: 90000008     	adrp	x8, 0x4000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0xb28>
		0000000000004e7c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32+0x20
    4e80: 91000108     	add	x8, x8, #0x0
		0000000000004e80:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32+0x20
    4e84: 90000009     	adrp	x9, 0x4000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0xb28>
		0000000000004e84:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xf0
    4e88: 91000129     	add	x9, x9, #0x0
		0000000000004e88:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xf0
    4e8c: ad400900     	ldp	q0, q2, [x8]
    4e90: 52840008     	mov	w8, #0x2000             // =8192
    4e94: f940012a     	ldr	x10, [x9]
    4e98: aa0203f3     	mov	x19, x2
    4e9c: 790083e8     	strh	w8, [sp, #0x40]
    4ea0: 528001a8     	mov	w8, #0xd                // =13
    4ea4: aa0103f4     	mov	x20, x1
    4ea8: 3c8513e0     	stur	q0, [sp, #0x51]
    4eac: ad400001     	ldp	q1, q0, [x0]
    4eb0: 39010be8     	strb	w8, [sp, #0x42]
    4eb4: f8405128     	ldur	x8, [x9, #0x5]
    4eb8: 910083e0     	add	x0, sp, #0x20
    4ebc: f80433ea     	stur	x10, [sp, #0x43]
    4ec0: 910103e2     	add	x2, sp, #0x40
    4ec4: d10083a4     	sub	x4, x29, #0x20
    4ec8: f90027e8     	str	x8, [sp, #0x48]
    4ecc: 52800408     	mov	w8, #0x20               // =32
    4ed0: 52800401     	mov	w1, #0x20               // =32
    4ed4: 52800623     	mov	w3, #0x31               // =49
    4ed8: ad3f03a1     	stp	q1, q0, [x29, #-0x20]
    4edc: 390143e8     	strb	w8, [sp, #0x50]
    4ee0: 3c8613e2     	stur	q2, [sp, #0x61]
    4ee4: 97fff7f6     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    4ee8: 910003e0     	mov	x0, sp
    4eec: 910083e1     	add	x1, sp, #0x20
    4ef0: aa1403e2     	mov	x2, x20
    4ef4: 97ffff74     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    4ef8: ad4007e0     	ldp	q0, q1, [sp]
    4efc: ad000660     	stp	q0, q1, [x19]
    4f00: a9594ff4     	ldp	x20, x19, [sp, #0x190]
    4f04: f940c3fc     	ldr	x28, [sp, #0x180]
    4f08: a9577bfd     	ldp	x29, x30, [sp, #0x170]
    4f0c: 910683ff     	add	sp, sp, #0x1a0
    4f10: d65f03c0     	ret
