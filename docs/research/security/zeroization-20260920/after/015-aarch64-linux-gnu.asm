
/tmp/ztls-signoff-20260919/125-after-direct-buffers/015-aarch64-linux-gnu.o:	file format elf64-littleaarch64

Disassembly of section .text:

0000000000000000 <audit_handshake256>:
<L0>:
       0: d10603ff     	sub	sp, sp, #0x180
       4: a9157bfd     	stp	x29, x30, [sp, #0x150]
       8: f900b3fc     	str	x28, [sp, #0x160]
       c: a9174ff4     	stp	x20, x19, [sp, #0x170]
      10: 910543fd     	add	x29, sp, #0x150
      14: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		0000000000000014:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32+0x20
      18: 91000108     	add	x8, x8, #0x0
		0000000000000018:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32+0x20
      1c: 90000009     	adrp	x9, 0x0 <audit_handshake256>
		000000000000001c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
      20: 91000129     	add	x9, x9, #0x0
		0000000000000020:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
      24: ad400500     	ldp	q0, q1, [x8]
      28: 52840008     	mov	w8, #0x2000             // =8192
      2c: f940012a     	ldr	x10, [x9]
      30: aa0203f3     	mov	x19, x2
      34: 790083e8     	strh	w8, [sp, #0x40]
      38: 528001a8     	mov	w8, #0xd                // =13
      3c: aa0103f4     	mov	x20, x1
      40: 39010be8     	strb	w8, [sp, #0x42]
      44: f8405128     	ldur	x8, [x9, #0x5]
      48: aa0003e4     	mov	x4, x0
      4c: f80433ea     	stur	x10, [sp, #0x43]
      50: 910083e0     	add	x0, sp, #0x20
      54: 910103e2     	add	x2, sp, #0x40
      58: f90027e8     	str	x8, [sp, #0x48]
      5c: 52800408     	mov	w8, #0x20               // =32
      60: 52800401     	mov	w1, #0x20               // =32
      64: 52800623     	mov	w3, #0x31               // =49
      68: 3c8513e0     	stur	q0, [sp, #0x51]
      6c: 390143e8     	strb	w8, [sp, #0x50]
      70: 3c8613e1     	stur	q1, [sp, #0x61]
      74: 94000078     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
      78: 910003e0     	mov	x0, sp
      7c: 910083e1     	add	x1, sp, #0x20
      80: aa1403e2     	mov	x2, x20
      84: 9400000b     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
      88: 6f00e400     	movi	v0.2d, #0000000000000000
      8c: 3d800fe0     	str	q0, [sp, #0x30]
      90: 3d800be0     	str	q0, [sp, #0x20]
      94: ad4007e0     	ldp	q0, q1, [sp]
      98: ad000660     	stp	q0, q1, [x19]
      9c: a9574ff4     	ldp	x20, x19, [sp, #0x170]
      a0: f940b3fc     	ldr	x28, [sp, #0x160]
      a4: a9557bfd     	ldp	x29, x30, [sp, #0x150]
      a8: 910603ff     	add	sp, sp, #0x180
      ac: d65f03c0     	ret

00000000000000b0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
      b0: d10683ff     	sub	sp, sp, #0x1a0
      b4: a9167bfd     	stp	x29, x30, [sp, #0x160]
      b8: a9175ffc     	stp	x28, x23, [sp, #0x170]
      bc: a91857f6     	stp	x22, x21, [sp, #0x180]
      c0: a9194ff4     	stp	x20, x19, [sp, #0x190]
      c4: 910583fd     	add	x29, sp, #0x160
      c8: aa0003f3     	mov	x19, x0
      cc: 910083e0     	add	x0, sp, #0x20
      d0: aa0203f4     	mov	x20, x2
      d4: 910083f7     	add	x23, sp, #0x20
      d8: 9400016a     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
      dc: 394223e8     	ldrb	w8, [sp, #0x88]
      e0: 34000228     	cbz	w8,  <L1>
      e4: 7100811f     	cmp	w8, #0x20
      e8: 540001e3     	b.lo	 <L1>
      ec: 52800809     	mov	w9, #0x40               // =64
      f0: 910083ea     	add	x10, sp, #0x20
      f4: aa1403e1     	mov	x1, x20
      f8: cb080135     	sub	x21, x9, x8
      fc: 9100a156     	add	x22, x10, #0x28
     100: 8b0802c0     	add	x0, x22, x8
     104: aa1503e2     	mov	x2, x21
<L0>:
     108: 94000000     	bl	 <L0>
		0000000000000108:  R_AARCH64_CALL26	memcpy
     10c: 910083e0     	add	x0, sp, #0x20
     110: aa1603e1     	mov	x1, x22
     114: 940001d7     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     118: 2a1f03e8     	mov	w8, wzr
     11c: 390223ff     	strb	wzr, [sp, #0x88]
     120: 14000002     	b	 <L2>
<L1>:
     124: aa1f03f5     	mov	x21, xzr
<L2>:
     128: 52800409     	mov	w9, #0x20               // =32
     12c: 8b2842e8     	add	x8, x23, w8, uxtw
     130: 8b150281     	add	x1, x20, x21
     134: cb150136     	sub	x22, x9, x21
     138: 9100a100     	add	x0, x8, #0x28
     13c: aa1603e2     	mov	x2, x22
<L3>:
     140: 94000000     	bl	 <L3>
		0000000000000140:  R_AARCH64_CALL26	memcpy
     144: 394223e8     	ldrb	w8, [sp, #0x88]
     148: f94023e9     	ldr	x9, [sp, #0x40]
     14c: 910083e0     	add	x0, sp, #0x20
     150: d10243a1     	sub	x1, x29, #0x90
     154: 0b160108     	add	w8, w8, w22
     158: 91008129     	add	x9, x9, #0x20
     15c: d10243b6     	sub	x22, x29, #0x90
     160: 390223e8     	strb	w8, [sp, #0x88]
     164: f90023e9     	str	x9, [sp, #0x40]
     168: 94000176     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     16c: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		000000000000016c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     170: 91000108     	add	x8, x8, #0x0
		0000000000000170:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     174: d101c3a0     	sub	x0, x29, #0x70
     178: ad420500     	ldp	q0, q1, [x8, #0x40]
     17c: 3dc01902     	ldr	q2, [x8, #0x60]
     180: 9101c2e1     	add	x1, x23, #0x70
     184: d101c3b4     	sub	x20, x29, #0x70
     188: 3c9f03a2     	stur	q2, [x29, #-0x10]
     18c: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
     190: ad400500     	ldp	q0, q1, [x8]
     194: ad3c87a0     	stp	q0, q1, [x29, #-0x70]
     198: ad410900     	ldp	q0, q2, [x8, #0x20]
     19c: ad3d8ba0     	stp	q0, q2, [x29, #-0x50]
     1a0: 940001b4     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     1a4: f85b03a9     	ldur	x9, [x29, #-0x50]
     1a8: 385f83a8     	ldurb	w8, [x29, #-0x8]
     1ac: 9100a294     	add	x20, x20, #0x28
     1b0: 91010137     	add	x23, x9, #0x40
     1b4: f81b03b7     	stur	x23, [x29, #-0x50]
     1b8: 34000208     	cbz	w8,  <L5>
     1bc: 7100811f     	cmp	w8, #0x20
     1c0: 540001c3     	b.lo	 <L5>
     1c4: 52800809     	mov	w9, #0x40               // =64
     1c8: 8b080280     	add	x0, x20, x8
     1cc: d10243a1     	sub	x1, x29, #0x90
     1d0: cb080135     	sub	x21, x9, x8
     1d4: aa1503e2     	mov	x2, x21
<L4>:
     1d8: 94000000     	bl	 <L4>
		00000000000001d8:  R_AARCH64_CALL26	memcpy
     1dc: d101c3a0     	sub	x0, x29, #0x70
     1e0: aa1403e1     	mov	x1, x20
     1e4: 940001a3     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     1e8: f85b03b7     	ldur	x23, [x29, #-0x50]
     1ec: 2a1f03e8     	mov	w8, wzr
     1f0: 381f83bf     	sturb	wzr, [x29, #-0x8]
     1f4: 14000002     	b	 <L6>
<L5>:
     1f8: aa1f03f5     	mov	x21, xzr
<L6>:
     1fc: 52800409     	mov	w9, #0x20               // =32
     200: 8b284280     	add	x0, x20, w8, uxtw
     204: 8b1502c1     	add	x1, x22, x21
     208: cb150134     	sub	x20, x9, x21
     20c: aa1403e2     	mov	x2, x20
<L7>:
     210: 94000000     	bl	 <L7>
		0000000000000210:  R_AARCH64_CALL26	memcpy
     214: 385f83a8     	ldurb	w8, [x29, #-0x8]
     218: 910082e9     	add	x9, x23, #0x20
     21c: d101c3a0     	sub	x0, x29, #0x70
     220: 910003e1     	mov	x1, sp
     224: f81b03a9     	stur	x9, [x29, #-0x50]
     228: 0b140108     	add	w8, w8, w20
     22c: 381f83a8     	sturb	w8, [x29, #-0x8]
     230: 94000144     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     234: ad4007e0     	ldp	q0, q1, [sp]
     238: ad000660     	stp	q0, q1, [x19]
     23c: a9594ff4     	ldp	x20, x19, [sp, #0x190]
     240: a95857f6     	ldp	x22, x21, [sp, #0x180]
     244: a9575ffc     	ldp	x28, x23, [sp, #0x170]
     248: a9567bfd     	ldp	x29, x30, [sp, #0x160]
     24c: 910683ff     	add	sp, sp, #0x1a0
     250: d65f03c0     	ret

0000000000000254 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     254: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
     258: a9016ffc     	stp	x28, x27, [sp, #0x10]
     25c: a90267fa     	stp	x26, x25, [sp, #0x20]
     260: a9035ff8     	stp	x24, x23, [sp, #0x30]
     264: a90457f6     	stp	x22, x21, [sp, #0x40]
     268: a9054ff4     	stp	x20, x19, [sp, #0x50]
     26c: 910003fd     	mov	x29, sp
     270: d10883ff     	sub	sp, sp, #0x220
     274: aa0303f5     	mov	x21, x3
     278: aa0203f6     	mov	x22, x2
     27c: aa0003f3     	mov	x19, x0
     280: 52800028     	mov	w8, #0x1                // =1
     284: f100803f     	cmp	x1, #0x20
     288: 910303fa     	add	x26, sp, #0xc0
     28c: 390033e8     	strb	w8, [sp, #0xc]
     290: 54000322     	b.hs	 <L1>
     294: aa0103f4     	mov	x20, x1
     298: 910303e0     	add	x0, sp, #0xc0
     29c: aa0403e1     	mov	x1, x4
     2a0: 910303f9     	add	x25, sp, #0xc0
     2a4: 940000f7     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
     2a8: 3944a3e8     	ldrb	w8, [sp, #0x128]
     2ac: 34000508     	cbz	w8,  <L3>
     2b0: 8b0802a9     	add	x9, x21, x8
     2b4: f101013f     	cmp	x9, #0x40
     2b8: 540004a3     	b.lo	 <L3>
     2bc: 52800809     	mov	w9, #0x40               // =64
     2c0: 910303ea     	add	x10, sp, #0xc0
     2c4: aa1603e1     	mov	x1, x22
     2c8: cb080138     	sub	x24, x9, x8
     2cc: 9100a157     	add	x23, x10, #0x28
     2d0: 8b0802e0     	add	x0, x23, x8
     2d4: aa1803e2     	mov	x2, x24
<L0>:
     2d8: 94000000     	bl	 <L0>
		00000000000002d8:  R_AARCH64_CALL26	memcpy
     2dc: 910303e0     	add	x0, sp, #0xc0
     2e0: aa1703e1     	mov	x1, x23
     2e4: 94000163     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     2e8: 2a1f03e8     	mov	w8, wzr
     2ec: 3904a3ff     	strb	wzr, [sp, #0x128]
     2f0: 14000018     	b	 <L4>
<L1>:
     2f4: 910043f9     	add	x25, sp, #0x10
     2f8: 910043e0     	add	x0, sp, #0x10
     2fc: aa0403e1     	mov	x1, x4
     300: 9100a334     	add	x20, x25, #0x28
     304: 940000df     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
     308: 3941e3e8     	ldrb	w8, [sp, #0x78]
     30c: 340005a8     	cbz	w8,  <L7>
     310: d24016a9     	eor	x9, x21, #0x3f
     314: eb08013f     	cmp	x9, x8
     318: 54000542     	b.hs	 <L7>
     31c: 52800809     	mov	w9, #0x40               // =64
     320: 8b080280     	add	x0, x20, x8
     324: aa1603e1     	mov	x1, x22
     328: cb080137     	sub	x23, x9, x8
     32c: aa1703e2     	mov	x2, x23
<L2>:
     330: 94000000     	bl	 <L2>
		0000000000000330:  R_AARCH64_CALL26	memcpy
     334: 910043e0     	add	x0, sp, #0x10
     338: aa1403e1     	mov	x1, x20
     33c: 9400014d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     340: 2a1f03e8     	mov	w8, wzr
     344: 3901e3ff     	strb	wzr, [sp, #0x78]
     348: 1400001f     	b	 <L8>
<L3>:
     34c: aa1f03f8     	mov	x24, xzr
<L4>:
     350: 9100a337     	add	x23, x25, #0x28
     354: cb1802b9     	sub	x25, x21, x24
     358: 8b1802c1     	add	x1, x22, x24
     35c: 8b2842e0     	add	x0, x23, w8, uxtw
     360: aa1903e2     	mov	x2, x25
<L5>:
     364: 94000000     	bl	 <L5>
		0000000000000364:  R_AARCH64_CALL26	memcpy
     368: 3944a3e8     	ldrb	w8, [sp, #0x128]
     36c: f9401349     	ldr	x9, [x26, #0x20]
     370: 2b190108     	adds	w8, w8, w25
     374: 8b150138     	add	x24, x9, x21
     378: 3904a3e8     	strb	w8, [sp, #0x128]
     37c: f9001358     	str	x24, [x26, #0x20]
     380: 540005a0     	b.eq	 <L11>
     384: 7100fd1f     	cmp	w8, #0x3f
     388: 54000563     	b.lo	 <L11>
     38c: 52800809     	mov	w9, #0x40               // =64
     390: 8b2842e0     	add	x0, x23, w8, uxtw
     394: 910033e1     	add	x1, sp, #0xc
     398: 4b080135     	sub	w21, w9, w8
     39c: aa1503e2     	mov	x2, x21
<L6>:
     3a0: 94000000     	bl	 <L6>
		00000000000003a0:  R_AARCH64_CALL26	memcpy
     3a4: 910303e0     	add	x0, sp, #0xc0
     3a8: aa1703e1     	mov	x1, x23
     3ac: 94000131     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     3b0: f9401358     	ldr	x24, [x26, #0x20]
     3b4: 2a1f03e8     	mov	w8, wzr
     3b8: 3904a3ff     	strb	wzr, [sp, #0x128]
     3bc: 1400001f     	b	 <L12>
<L7>:
     3c0: aa1f03f7     	mov	x23, xzr
<L8>:
     3c4: 8b284280     	add	x0, x20, w8, uxtw
     3c8: cb1702b8     	sub	x24, x21, x23
     3cc: 8b1702c1     	add	x1, x22, x23
     3d0: aa1803e2     	mov	x2, x24
     3d4: d101c3bb     	sub	x27, x29, #0x70
<L9>:
     3d8: 94000000     	bl	 <L9>
		00000000000003d8:  R_AARCH64_CALL26	memcpy
     3dc: 3941e3e8     	ldrb	w8, [sp, #0x78]
     3e0: f9401be9     	ldr	x9, [sp, #0x30]
     3e4: 2b180108     	adds	w8, w8, w24
     3e8: 8b150137     	add	x23, x9, x21
     3ec: 3901e3e8     	strb	w8, [sp, #0x78]
     3f0: f9001bf7     	str	x23, [sp, #0x30]
     3f4: 540008a0     	b.eq	 <L15>
     3f8: 7100fd1f     	cmp	w8, #0x3f
     3fc: 54000863     	b.lo	 <L15>
     400: 52800809     	mov	w9, #0x40               // =64
     404: 8b284280     	add	x0, x20, w8, uxtw
     408: 910033e1     	add	x1, sp, #0xc
     40c: 4b080135     	sub	w21, w9, w8
     410: aa1503e2     	mov	x2, x21
<L10>:
     414: 94000000     	bl	 <L10>
		0000000000000414:  R_AARCH64_CALL26	memcpy
     418: 910043e0     	add	x0, sp, #0x10
     41c: aa1403e1     	mov	x1, x20
     420: 94000114     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     424: f9401bf7     	ldr	x23, [sp, #0x30]
     428: 2a1f03e8     	mov	w8, wzr
     42c: 3901e3ff     	strb	wzr, [sp, #0x78]
     430: 14000037     	b	 <L16>
<L11>:
     434: aa1f03f5     	mov	x21, xzr
<L12>:
     438: 52800029     	mov	w9, #0x1                // =1
     43c: 8b2842e0     	add	x0, x23, w8, uxtw
     440: 910033e8     	add	x8, sp, #0xc
     444: cb150136     	sub	x22, x9, x21
     448: 8b150101     	add	x1, x8, x21
     44c: aa1603e2     	mov	x2, x22
<L13>:
     450: 94000000     	bl	 <L13>
		0000000000000450:  R_AARCH64_CALL26	memcpy
     454: 3944a3e8     	ldrb	w8, [sp, #0x128]
     458: 91000709     	add	x9, x24, #0x1
     45c: 910303e0     	add	x0, sp, #0xc0
     460: d10243a1     	sub	x1, x29, #0x90
     464: f9001349     	str	x9, [x26, #0x20]
     468: 910303f5     	add	x21, sp, #0xc0
     46c: 0b160108     	add	w8, w8, w22
     470: d10243b7     	sub	x23, x29, #0x90
     474: 3904a3e8     	strb	w8, [sp, #0x128]
     478: 940000b2     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     47c: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		000000000000047c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     480: 91000108     	add	x8, x8, #0x0
		0000000000000480:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     484: d101c3a0     	sub	x0, x29, #0x70
     488: ad420500     	ldp	q0, q1, [x8, #0x40]
     48c: 3dc01902     	ldr	q2, [x8, #0x60]
     490: 9101c2a1     	add	x1, x21, #0x70
     494: d101c3b5     	sub	x21, x29, #0x70
     498: 3d805742     	str	q2, [x26, #0x150]
     49c: ad098740     	stp	q0, q1, [x26, #0x130]
     4a0: ad400500     	ldp	q0, q1, [x8]
     4a4: ad078740     	stp	q0, q1, [x26, #0xf0]
     4a8: ad410900     	ldp	q0, q2, [x8, #0x20]
     4ac: ad088b40     	stp	q0, q2, [x26, #0x110]
     4b0: 940000f0     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     4b4: f9408b49     	ldr	x9, [x26, #0x110]
     4b8: 385f83a8     	ldurb	w8, [x29, #-0x8]
     4bc: 9100a2b5     	add	x21, x21, #0x28
     4c0: 91010138     	add	x24, x9, #0x40
     4c4: f9008b58     	str	x24, [x26, #0x110]
     4c8: 34000868     	cbz	w8,  <L19>
     4cc: 7100811f     	cmp	w8, #0x20
     4d0: 54000823     	b.lo	 <L19>
     4d4: 52800809     	mov	w9, #0x40               // =64
     4d8: 8b0802a0     	add	x0, x21, x8
     4dc: d10243a1     	sub	x1, x29, #0x90
     4e0: cb080136     	sub	x22, x9, x8
     4e4: aa1603e2     	mov	x2, x22
<L14>:
     4e8: 94000000     	bl	 <L14>
		00000000000004e8:  R_AARCH64_CALL26	memcpy
     4ec: d101c3a0     	sub	x0, x29, #0x70
     4f0: aa1503e1     	mov	x1, x21
     4f4: 940000df     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     4f8: f9408b58     	ldr	x24, [x26, #0x110]
     4fc: 2a1f03e8     	mov	w8, wzr
     500: 381f83bf     	sturb	wzr, [x29, #-0x8]
     504: 14000035     	b	 <L20>
<L15>:
     508: aa1f03f5     	mov	x21, xzr
<L16>:
     50c: 52800029     	mov	w9, #0x1                // =1
     510: 8b284280     	add	x0, x20, w8, uxtw
     514: 910033e8     	add	x8, sp, #0xc
     518: cb150136     	sub	x22, x9, x21
     51c: 8b150101     	add	x1, x8, x21
     520: 9100a374     	add	x20, x27, #0x28
     524: aa1603e2     	mov	x2, x22
<L17>:
     528: 94000000     	bl	 <L17>
		0000000000000528:  R_AARCH64_CALL26	memcpy
     52c: 3941e3e8     	ldrb	w8, [sp, #0x78]
     530: 910006e9     	add	x9, x23, #0x1
     534: 910043e0     	add	x0, sp, #0x10
     538: d10243a1     	sub	x1, x29, #0x90
     53c: f9001be9     	str	x9, [sp, #0x30]
     540: 0b160108     	add	w8, w8, w22
     544: d10243b6     	sub	x22, x29, #0x90
     548: 3901e3e8     	strb	w8, [sp, #0x78]
     54c: 9400007d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     550: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		0000000000000550:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     554: 91000108     	add	x8, x8, #0x0
		0000000000000554:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     558: d101c3a0     	sub	x0, x29, #0x70
     55c: ad420500     	ldp	q0, q1, [x8, #0x40]
     560: 3dc01902     	ldr	q2, [x8, #0x60]
     564: 9101c321     	add	x1, x25, #0x70
     568: 3d805742     	str	q2, [x26, #0x150]
     56c: ad098740     	stp	q0, q1, [x26, #0x130]
     570: ad400500     	ldp	q0, q1, [x8]
     574: ad078740     	stp	q0, q1, [x26, #0xf0]
     578: ad410900     	ldp	q0, q2, [x8, #0x20]
     57c: ad088b40     	stp	q0, q2, [x26, #0x110]
     580: 940000bc     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     584: f9408b49     	ldr	x9, [x26, #0x110]
     588: 385f83a8     	ldurb	w8, [x29, #-0x8]
     58c: 91010137     	add	x23, x9, #0x40
     590: f9008b57     	str	x23, [x26, #0x110]
     594: 34000488     	cbz	w8,  <L23>
     598: 7100811f     	cmp	w8, #0x20
     59c: 54000443     	b.lo	 <L23>
     5a0: 52800809     	mov	w9, #0x40               // =64
     5a4: 8b080280     	add	x0, x20, x8
     5a8: d10243a1     	sub	x1, x29, #0x90
     5ac: cb080135     	sub	x21, x9, x8
     5b0: aa1503e2     	mov	x2, x21
<L18>:
     5b4: 94000000     	bl	 <L18>
		00000000000005b4:  R_AARCH64_CALL26	memcpy
     5b8: d101c3a0     	sub	x0, x29, #0x70
     5bc: aa1403e1     	mov	x1, x20
     5c0: 940000ac     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     5c4: f9408b57     	ldr	x23, [x26, #0x110]
     5c8: 2a1f03e8     	mov	w8, wzr
     5cc: 381f83bf     	sturb	wzr, [x29, #-0x8]
     5d0: 14000016     	b	 <L24>
<L19>:
     5d4: aa1f03f6     	mov	x22, xzr
<L20>:
     5d8: 52800409     	mov	w9, #0x20               // =32
     5dc: 8b2842a0     	add	x0, x21, w8, uxtw
     5e0: 8b1602e1     	add	x1, x23, x22
     5e4: cb160135     	sub	x21, x9, x22
     5e8: aa1503e2     	mov	x2, x21
<L21>:
     5ec: 94000000     	bl	 <L21>
		00000000000005ec:  R_AARCH64_CALL26	memcpy
     5f0: 385f83a8     	ldurb	w8, [x29, #-0x8]
     5f4: 91008309     	add	x9, x24, #0x20
     5f8: d101c3a0     	sub	x0, x29, #0x70
     5fc: d102c3a1     	sub	x1, x29, #0xb0
     600: f9008b49     	str	x9, [x26, #0x110]
     604: 0b150108     	add	w8, w8, w21
     608: 381f83a8     	sturb	w8, [x29, #-0x8]
     60c: 9400004d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     610: d102c3a1     	sub	x1, x29, #0xb0
     614: aa1303e0     	mov	x0, x19
     618: aa1403e2     	mov	x2, x20
<L22>:
     61c: 94000000     	bl	 <L22>
		000000000000061c:  R_AARCH64_CALL26	memcpy
     620: 14000010     	b	 <L26>
<L23>:
     624: aa1f03f5     	mov	x21, xzr
<L24>:
     628: 52800409     	mov	w9, #0x20               // =32
     62c: 8b284280     	add	x0, x20, w8, uxtw
     630: 8b1502c1     	add	x1, x22, x21
     634: cb150134     	sub	x20, x9, x21
     638: aa1403e2     	mov	x2, x20
<L25>:
     63c: 94000000     	bl	 <L25>
		000000000000063c:  R_AARCH64_CALL26	memcpy
     640: 385f83a8     	ldurb	w8, [x29, #-0x8]
     644: 910082e9     	add	x9, x23, #0x20
     648: d101c3a0     	sub	x0, x29, #0x70
     64c: aa1303e1     	mov	x1, x19
     650: f9008b49     	str	x9, [x26, #0x110]
     654: 0b140108     	add	w8, w8, w20
     658: 381f83a8     	sturb	w8, [x29, #-0x8]
     65c: 94000039     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
<L26>:
     660: 910883ff     	add	sp, sp, #0x220
     664: a9454ff4     	ldp	x20, x19, [sp, #0x50]
     668: a94457f6     	ldp	x22, x21, [sp, #0x40]
     66c: a9435ff8     	ldp	x24, x23, [sp, #0x30]
     670: a94267fa     	ldp	x26, x25, [sp, #0x20]
     674: a9416ffc     	ldp	x28, x27, [sp, #0x10]
     678: a8c67bfd     	ldp	x29, x30, [sp], #0x60
     67c: d65f03c0     	ret

0000000000000680 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>:
     680: d10443ff     	sub	sp, sp, #0x110
     684: a90f7bfd     	stp	x29, x30, [sp, #0xf0]
     688: a9104ffc     	stp	x28, x19, [sp, #0x100]
     68c: 9103c3fd     	add	x29, sp, #0xf0
     690: 4f02e780     	movi	v0.16b, #0x5c
     694: 4f01e6c1     	movi	v1.16b, #0x36
     698: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		0000000000000698:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     69c: 91000108     	add	x8, x8, #0x0
		000000000000069c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     6a0: ad400823     	ldp	q3, q2, [x1]
     6a4: aa0003f3     	mov	x19, x0
     6a8: 910003e0     	mov	x0, sp
     6ac: d10103a1     	sub	x1, x29, #0x40
     6b0: 6e201c44     	eor	v4.16b, v2.16b, v0.16b
     6b4: ad0483e0     	stp	q0, q0, [sp, #0x90]
     6b8: 6e211c65     	eor	v5.16b, v3.16b, v1.16b
     6bc: ad3f07a1     	stp	q1, q1, [x29, #-0x20]
     6c0: 6e211c41     	eor	v1.16b, v2.16b, v1.16b
     6c4: 6e201c60     	eor	v0.16b, v3.16b, v0.16b
     6c8: ad420d02     	ldp	q2, q3, [x8, #0x40]
     6cc: ad0393e0     	stp	q0, q4, [sp, #0x70]
     6d0: ad020fe2     	stp	q2, q3, [sp, #0x40]
     6d4: ad400102     	ldp	q2, q0, [x8]
     6d8: ad3e07a5     	stp	q5, q1, [x29, #-0x40]
     6dc: 3dc01901     	ldr	q1, [x8, #0x60]
     6e0: 3d801be1     	str	q1, [sp, #0x60]
     6e4: ad0003e2     	stp	q2, q0, [sp]
     6e8: ad410500     	ldp	q0, q1, [x8, #0x20]
     6ec: ad0107e0     	stp	q0, q1, [sp, #0x20]
     6f0: 94000060     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     6f4: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     6f8: f94013e8     	ldr	x8, [sp, #0x20]
     6fc: 91010108     	add	x8, x8, #0x40
     700: ad040660     	stp	q0, q1, [x19, #0x80]
     704: 3dc02be0     	ldr	q0, [sp, #0xa0]
     708: f90013e8     	str	x8, [sp, #0x20]
     70c: 3d802a60     	str	q0, [x19, #0xa0]
     710: ad4203e1     	ldp	q1, q0, [sp, #0x40]
     714: ad020261     	stp	q1, q0, [x19, #0x40]
     718: ad430be0     	ldp	q0, q2, [sp, #0x60]
     71c: ad030a60     	stp	q0, q2, [x19, #0x60]
     720: ad4003e1     	ldp	q1, q0, [sp]
     724: ad000261     	stp	q1, q0, [x19]
     728: ad410be0     	ldp	q0, q2, [sp, #0x20]
     72c: ad010a60     	stp	q0, q2, [x19, #0x20]
     730: a9504ffc     	ldp	x28, x19, [sp, #0x100]
     734: a94f7bfd     	ldp	x29, x30, [sp, #0xf0]
     738: 910443ff     	add	sp, sp, #0x110
     73c: d65f03c0     	ret

0000000000000740 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     740: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
     744: f9000bf5     	str	x21, [sp, #0x10]
     748: a9024ff4     	stp	x20, x19, [sp, #0x20]
     74c: 910003fd     	mov	x29, sp
     750: 3941a009     	ldrb	w9, [x0, #0x68]
     754: 52800808     	mov	w8, #0x40               // =64
     758: 9100a015     	add	x21, x0, #0x28
     75c: aa0103f3     	mov	x19, x1
     760: aa0003f4     	mov	x20, x0
     764: 2a1f03e1     	mov	w1, wzr
     768: cb090102     	sub	x2, x8, x9
     76c: 8b0902a0     	add	x0, x21, x9
<L0>:
     770: 94000000     	bl	 <L0>
		0000000000000770:  R_AARCH64_CALL26	memset
     774: 3941a288     	ldrb	w8, [x20, #0x68]
     778: 52801009     	mov	w9, #0x80               // =128
     77c: 38286aa9     	strb	w9, [x21, x8]
     780: 3941a288     	ldrb	w8, [x20, #0x68]
     784: 11000509     	add	w9, w8, #0x1
     788: 7100dd1f     	cmp	w8, #0x37
     78c: 3901a289     	strb	w9, [x20, #0x68]
     790: 54000109     	b.ls	 <L1>
     794: aa1403e0     	mov	x0, x20
     798: aa1503e1     	mov	x1, x21
     79c: 94000035     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     7a0: 6f00e400     	movi	v0.2d, #0000000000000000
     7a4: f9001abf     	str	xzr, [x21, #0x30]
     7a8: ad0082a0     	stp	q0, q0, [x21, #0x10]
     7ac: 3d8002a0     	str	q0, [x21]
<L1>:
     7b0: f9401288     	ldr	x8, [x20, #0x20]
     7b4: aa1403e0     	mov	x0, x20
     7b8: aa1503e1     	mov	x1, x21
     7bc: 531d7109     	lsl	w9, w8, #3
     7c0: d345fd0a     	lsr	x10, x8, #5
     7c4: 39019e89     	strb	w9, [x20, #0x67]
     7c8: d34dfd09     	lsr	x9, x8, #13
     7cc: 39019a8a     	strb	w10, [x20, #0x66]
     7d0: d355fd0a     	lsr	x10, x8, #21
     7d4: 39019689     	strb	w9, [x20, #0x65]
     7d8: d35dfd09     	lsr	x9, x8, #29
     7dc: 3901928a     	strb	w10, [x20, #0x64]
     7e0: d365fd0a     	lsr	x10, x8, #37
     7e4: 39018e89     	strb	w9, [x20, #0x63]
     7e8: d36dfd09     	lsr	x9, x8, #45
     7ec: d375fd08     	lsr	x8, x8, #53
     7f0: 39018a8a     	strb	w10, [x20, #0x62]
     7f4: 39018689     	strb	w9, [x20, #0x61]
     7f8: 39018288     	strb	w8, [x20, #0x60]
     7fc: 9400001d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     800: b9400288     	ldr	w8, [x20]
     804: 5ac00908     	rev	w8, w8
     808: b9000268     	str	w8, [x19]
     80c: b9400688     	ldr	w8, [x20, #0x4]
     810: 5ac00908     	rev	w8, w8
     814: b9000668     	str	w8, [x19, #0x4]
     818: b9400a88     	ldr	w8, [x20, #0x8]
     81c: 5ac00908     	rev	w8, w8
     820: b9000a68     	str	w8, [x19, #0x8]
     824: b9400e88     	ldr	w8, [x20, #0xc]
     828: 5ac00908     	rev	w8, w8
     82c: b9000e68     	str	w8, [x19, #0xc]
     830: b9401288     	ldr	w8, [x20, #0x10]
     834: 5ac00908     	rev	w8, w8
     838: b9001268     	str	w8, [x19, #0x10]
     83c: b9401688     	ldr	w8, [x20, #0x14]
     840: 5ac00908     	rev	w8, w8
     844: b9001668     	str	w8, [x19, #0x14]
     848: b9401a88     	ldr	w8, [x20, #0x18]
     84c: 5ac00908     	rev	w8, w8
     850: b9001a68     	str	w8, [x19, #0x18]
     854: b9401e88     	ldr	w8, [x20, #0x1c]
     858: 5ac00908     	rev	w8, w8
     85c: b9001e68     	str	w8, [x19, #0x1c]
     860: a9424ff4     	ldp	x20, x19, [sp, #0x20]
     864: f9400bf5     	ldr	x21, [sp, #0x10]
     868: a8c37bfd     	ldp	x29, x30, [sp], #0x30
     86c: d65f03c0     	ret

0000000000000870 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     870: a9bc7bfd     	stp	x29, x30, [sp, #-0x40]!
     874: f9000bf7     	str	x23, [sp, #0x10]
     878: a90257f6     	stp	x22, x21, [sp, #0x20]
     87c: a9034ff4     	stp	x20, x19, [sp, #0x30]
     880: 910003fd     	mov	x29, sp
     884: d12403ff     	sub	sp, sp, #0x900
     888: ad400420     	ldp	q0, q1, [x1]
     88c: d10403a8     	sub	x8, x29, #0x100
     890: ad410c22     	ldp	q2, q3, [x1, #0x20]
     894: 911c03e9     	add	x9, sp, #0x700
     898: 911803ea     	add	x10, sp, #0x600
     89c: 911403eb     	add	x11, sp, #0x500
     8a0: 911003ec     	add	x12, sp, #0x400
     8a4: 6e200800     	rev32	v0.16b, v0.16b
     8a8: 6e200821     	rev32	v1.16b, v1.16b
     8ac: 910c03ed     	add	x13, sp, #0x300
     8b0: 910803ee     	add	x14, sp, #0x200
     8b4: 9100e10f     	add	x15, x8, #0x38
     8b8: 9100e130     	add	x16, x9, #0x38
     8bc: 9100e151     	add	x17, x10, #0x38
     8c0: b27e0172     	orr	x18, x11, #0x4
     8c4: b27e0181     	orr	x1, x12, #0x4
     8c8: b27e01a2     	orr	x2, x13, #0x4
     8cc: 910091c3     	add	x3, x14, #0x24
     8d0: 52800804     	mov	w4, #0x40               // =64
     8d4: ad0007e0     	stp	q0, q1, [sp]
     8d8: 6e200841     	rev32	v1.16b, v2.16b
     8dc: 6e200862     	rev32	v2.16b, v3.16b
     8e0: 910403e5     	add	x5, sp, #0x100
     8e4: 910003e6     	mov	x6, sp
     8e8: ad010be1     	stp	q1, q2, [sp, #0x20]
<L0>:
     8ec: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     8f0: 8b040027     	add	x7, x1, x4
     8f4: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     8f8: 8b040213     	add	x19, x16, x4
     8fc: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     900: 3dc003f8     	ldr	q24, [sp]
     904: 8b040054     	add	x20, x2, x4
     908: ad0e0be1     	stp	q1, q2, [sp, #0x1c0]
     90c: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     910: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     914: 8b040235     	add	x21, x17, x4
     918: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     91c: 8b0400b6     	add	x22, x5, x4
     920: ad0f07e3     	stp	q3, q1, [sp, #0x1e0]
     924: 8b040077     	add	x23, x3, x4
     928: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     92c: ad054dd2     	stp	q18, q19, [x14, #0xa0]
     930: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     934: ad035dd6     	stp	q22, q23, [x14, #0x60]
     938: ad071dc6     	stp	q6, q7, [x14, #0xe0]
     93c: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     940: ad0c07e2     	stp	q2, q1, [sp, #0x180]
     944: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     948: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     94c: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     950: ad0d07e3     	stp	q3, q1, [sp, #0x1a0]
     954: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     958: ad0615c4     	stp	q4, q5, [x14, #0xc0]
     95c: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     960: ad035d96     	stp	q22, q23, [x12, #0x60]
     964: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     968: ad0a07e2     	stp	q2, q1, [sp, #0x140]
     96c: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     970: ad054d92     	stp	q18, q19, [x12, #0xa0]
     974: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     978: ad035d56     	stp	q22, q23, [x10, #0x60]
     97c: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     980: ad0b07e3     	stp	q3, q1, [sp, #0x160]
     984: ad4007e2     	ldp	q2, q1, [sp]
     988: ad0445d0     	stp	q16, q17, [x14, #0x80]
     98c: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     990: ad054d52     	stp	q18, q19, [x10, #0xa0]
     994: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     998: ad0807e2     	stp	q2, q1, [sp, #0x100]
     99c: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     9a0: ad0065d8     	stp	q24, q25, [x14]
     9a4: 3dc003f8     	ldr	q24, [sp]
     9a8: ad035d16     	stp	q22, q23, [x8, #0x60]
     9ac: ad416be2     	ldp	q2, q26, [sp, #0x20]
     9b0: ad0907e3     	stp	q3, q1, [sp, #0x120]
     9b4: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     9b8: ad0255d4     	stp	q20, q21, [x14, #0x40]
     9bc: b85c02d6     	ldur	w22, [x22, #-0x40]
     9c0: ad0169c2     	stp	q2, q26, [x14, #0x20]
     9c4: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     9c8: ad054d12     	stp	q18, q19, [x8, #0xa0]
     9cc: b85c02f7     	ldur	w23, [x23, #-0x40]
     9d0: ad0609a1     	stp	q1, q2, [x13, #0xc0]
     9d4: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     9d8: ad0705a3     	stp	q3, q1, [x13, #0xe0]
     9dc: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     9e0: ad071d86     	stp	q6, q7, [x12, #0xe0]
     9e4: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     9e8: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     9ec: ad0405a2     	stp	q2, q1, [x13, #0x80]
     9f0: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     9f4: ad0505a3     	stp	q3, q1, [x13, #0xa0]
     9f8: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     9fc: ad061584     	stp	q4, q5, [x12, #0xc0]
     a00: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     a04: ad0205a2     	stp	q2, q1, [x13, #0x40]
     a08: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     a0c: ad0305a3     	stp	q3, q1, [x13, #0x60]
     a10: ad4007e2     	ldp	q2, q1, [sp]
     a14: ad044590     	stp	q16, q17, [x12, #0x80]
     a18: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     a1c: ad0005a2     	stp	q2, q1, [x13]
     a20: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     a24: ad006598     	stp	q24, q25, [x12]
     a28: 3dc003f8     	ldr	q24, [sp]
     a2c: ad416be2     	ldp	q2, q26, [sp, #0x20]
     a30: ad0105a3     	stp	q3, q1, [x13, #0x20]
     a34: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     a38: ad025594     	stp	q20, q21, [x12, #0x40]
     a3c: b85c0294     	ldur	w20, [x20, #-0x40]
     a40: ad016982     	stp	q2, q26, [x12, #0x20]
     a44: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     a48: b85c00e7     	ldur	w7, [x7, #-0x40]
     a4c: 138748e7     	ror	w7, w7, #0x12
     a50: ad060961     	stp	q1, q2, [x11, #0xc0]
     a54: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     a58: 4ad41ce7     	eor	w7, w7, w20, ror #7
     a5c: 8b040254     	add	x20, x18, x4
     a60: ad070563     	stp	q3, q1, [x11, #0xe0]
     a64: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     a68: ad071d46     	stp	q6, q7, [x10, #0xe0]
     a6c: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     a70: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     a74: ad040562     	stp	q2, q1, [x11, #0x80]
     a78: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     a7c: ad050563     	stp	q3, q1, [x11, #0xa0]
     a80: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     a84: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     a88: ad061544     	stp	q4, q5, [x10, #0xc0]
     a8c: ad020562     	stp	q2, q1, [x11, #0x40]
     a90: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     a94: ad030563     	stp	q3, q1, [x11, #0x60]
     a98: ad4007e2     	ldp	q2, q1, [sp]
     a9c: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     aa0: ad044550     	stp	q16, q17, [x10, #0x80]
     aa4: ad000562     	stp	q2, q1, [x11]
     aa8: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     aac: ad416be2     	ldp	q2, q26, [sp, #0x20]
     ab0: ad006558     	stp	q24, q25, [x10]
     ab4: 3dc003f8     	ldr	q24, [sp]
     ab8: ad010563     	stp	q3, q1, [x11, #0x20]
     abc: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     ac0: ad016942     	stp	q2, q26, [x10, #0x20]
     ac4: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     ac8: ad025554     	stp	q20, q21, [x10, #0x40]
     acc: b85c0294     	ldur	w20, [x20, #-0x40]
     ad0: b85c02b5     	ldur	w21, [x21, #-0x40]
     ad4: ad060921     	stp	q1, q2, [x9, #0xc0]
     ad8: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     adc: 4a540ce7     	eor	w7, w7, w20, lsr #3
     ae0: 0b1602f4     	add	w20, w23, w22
     ae4: ad070523     	stp	q3, q1, [x9, #0xe0]
     ae8: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     aec: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     af0: ad071d06     	stp	q6, q7, [x8, #0xe0]
     af4: 0b070287     	add	w7, w20, w7
     af8: ad040522     	stp	q2, q1, [x9, #0x80]
     afc: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     b00: ad050523     	stp	q3, q1, [x9, #0xa0]
     b04: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     b08: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     b0c: ad061504     	stp	q4, q5, [x8, #0xc0]
     b10: ad020522     	stp	q2, q1, [x9, #0x40]
     b14: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     b18: ad030523     	stp	q3, q1, [x9, #0x60]
     b1c: ad4007e2     	ldp	q2, q1, [sp]
     b20: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     b24: ad044510     	stp	q16, q17, [x8, #0x80]
     b28: ad000522     	stp	q2, q1, [x9]
     b2c: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     b30: ad416be2     	ldp	q2, q26, [sp, #0x20]
     b34: ad006518     	stp	q24, q25, [x8]
     b38: ad010523     	stp	q3, q1, [x9, #0x20]
     b3c: b85c0273     	ldur	w19, [x19, #-0x40]
     b40: ad016902     	stp	q2, q26, [x8, #0x20]
     b44: ad025514     	stp	q20, q21, [x8, #0x40]
     b48: 13934e73     	ror	w19, w19, #0x13
     b4c: 4ad54673     	eor	w19, w19, w21, ror #17
     b50: 8b0401f5     	add	x21, x15, x4
     b54: b85c02b5     	ldur	w21, [x21, #-0x40]
     b58: 4a552a73     	eor	w19, w19, w21, lsr #10
     b5c: 0b1300e7     	add	w7, w7, w19
     b60: b82468c7     	str	w7, [x6, x4]
     b64: 91001084     	add	x4, x4, #0x4
     b68: f104009f     	cmp	x4, #0x100
     b6c: 54ffec01     	b.ne	 <L0>
     b70: 2941b009     	ldp	w9, w12, [x0, #0xc]
     b74: 29402c08     	ldp	w8, w11, [x0]
     b78: 2942b40f     	ldp	w15, w13, [x0, #0x14]
     b7c: 1e26000e     	fmov	w14, s0
     b80: 138c1990     	ror	w16, w12, #0x6
     b84: b9401c11     	ldr	w17, [x0, #0x1c]
     b88: 13880902     	ror	w2, w8, #0x2
     b8c: b940080a     	ldr	w10, [x0, #0x8]
     b90: 52889223     	mov	w3, #0x4491             // =17553
     b94: 0a2c01b2     	bic	w18, w13, w12
     b98: 0a0c01e1     	and	w1, w15, w12
     b9c: 4acc2e10     	eor	w16, w16, w12, ror #11
     ba0: 0b0e022e     	add	w14, w17, w14
     ba4: 5285f311     	mov	w17, #0x2f98            // =12184
     ba8: 2a120032     	orr	w18, w1, w18
     bac: 4ac83441     	eor	w1, w2, w8, ror #13
     bb0: 72a85151     	movk	w17, #0x428a, lsl #16
     bb4: 2a0b0142     	orr	w2, w10, w11
     bb8: 0b1201ce     	add	w14, w14, w18
     bbc: 4acc6610     	eor	w16, w16, w12, ror #25
     bc0: 0a080052     	and	w18, w2, w8
     bc4: 0b1101ce     	add	w14, w14, w17
     bc8: 4ac85831     	eor	w17, w1, w8, ror #22
     bcc: 0a0b0141     	and	w1, w10, w11
     bd0: 2a010252     	orr	w18, w18, w1
     bd4: 0b0e0210     	add	w16, w16, w14
     bd8: 72ae26e3     	movk	w3, #0x7137, lsl #16
     bdc: 0b110251     	add	w17, w18, w17
     be0: 0b09020e     	add	w14, w16, w9
     be4: 0b100229     	add	w9, w17, w16
     be8: 138e19d0     	ror	w16, w14, #0x6
     bec: 0a2e01e1     	bic	w1, w15, w14
     bf0: 2940c7f2     	ldp	w18, w17, [sp, #0x4]
     bf4: 0a0e0182     	and	w2, w12, w14
     bf8: 4ace2e10     	eor	w16, w16, w14, ror #11
     bfc: 2a010041     	orr	w1, w2, w1
     c00: 2a080162     	orr	w2, w11, w8
     c04: 0b1201ad     	add	w13, w13, w18
     c08: 13890932     	ror	w18, w9, #0x2
     c0c: 4ace6610     	eor	w16, w16, w14, ror #25
     c10: 0b0101ad     	add	w13, w13, w1
     c14: 0a020121     	and	w1, w9, w2
     c18: 0a080162     	and	w2, w11, w8
     c1c: 4ac93652     	eor	w18, w18, w9, ror #13
     c20: 0b0301ad     	add	w13, w13, w3
     c24: 2a020021     	orr	w1, w1, w2
     c28: 0b1001b0     	add	w16, w13, w16
     c2c: 0b1101ef     	add	w15, w15, w17
     c30: 2a080131     	orr	w17, w9, w8
     c34: 4ac95a52     	eor	w18, w18, w9, ror #22
     c38: 0b0a020d     	add	w13, w16, w10
     c3c: 0a2d0182     	bic	w2, w12, w13
     c40: 0a0d01c3     	and	w3, w14, w13
     c44: 0b010252     	add	w18, w18, w1
     c48: 2a020062     	orr	w2, w3, w2
     c4c: 0a080123     	and	w3, w9, w8
     c50: 0b10024a     	add	w10, w18, w16
     c54: 138d19b2     	ror	w18, w13, #0x6
     c58: 529f79f0     	mov	w16, #0xfbcf            // =64463
     c5c: 138a0941     	ror	w1, w10, #0x2
     c60: 72b6b810     	movk	w16, #0xb5c0, lsl #16
     c64: 0a110151     	and	w17, w10, w17
     c68: 4acd2e52     	eor	w18, w18, w13, ror #11
     c6c: 0b0201ef     	add	w15, w15, w2
     c70: 2a030231     	orr	w17, w17, w3
     c74: 4aca3421     	eor	w1, w1, w10, ror #13
     c78: 0b1001ef     	add	w15, w15, w16
     c7c: 529b74b0     	mov	w16, #0xdba5            // =56229
     c80: 4acd6652     	eor	w18, w18, w13, ror #25
     c84: 72bd36b0     	movk	w16, #0xe9b5, lsl #16
     c88: 4aca5821     	eor	w1, w1, w10, ror #22
     c8c: ad400c02     	ldp	q2, q3, [x0]
     c90: 0b1201f2     	add	w18, w15, w18
     c94: 0b110031     	add	w17, w1, w17
     c98: 0b0b024f     	add	w15, w18, w11
     c9c: 0b12022b     	add	w11, w17, w18
     ca0: 138f19e1     	ror	w1, w15, #0x6
     ca4: 0a0f01a3     	and	w3, w13, w15
     ca8: 2941cbf1     	ldp	w17, w18, [sp, #0xc]
     cac: 138b0962     	ror	w2, w11, #0x2
     cb0: 4acf2c21     	eor	w1, w1, w15, ror #11
     cb4: 0b11018c     	add	w12, w12, w17
     cb8: 0a2f01d1     	bic	w17, w14, w15
     cbc: 4acb3442     	eor	w2, w2, w11, ror #13
     cc0: 2a110071     	orr	w17, w3, w17
     cc4: 2a090143     	orr	w3, w10, w9
     cc8: 4acf6421     	eor	w1, w1, w15, ror #25
     ccc: 0b11018c     	add	w12, w12, w17
     cd0: 0a090151     	and	w17, w10, w9
     cd4: 0a030163     	and	w3, w11, w3
     cd8: 4acb5842     	eor	w2, w2, w11, ror #22
     cdc: 2a110071     	orr	w17, w3, w17
     ce0: 0b10018c     	add	w12, w12, w16
     ce4: 0b010190     	add	w16, w12, w1
     ce8: 0b0e024e     	add	w14, w18, w14
     cec: 2a0a0172     	orr	w18, w11, w10
     cf0: 0b110051     	add	w17, w2, w17
     cf4: 0b08020c     	add	w12, w16, w8
     cf8: 0b100228     	add	w8, w17, w16
     cfc: 138c1991     	ror	w17, w12, #0x6
     d00: 0a2c01a2     	bic	w2, w13, w12
     d04: 13880901     	ror	w1, w8, #0x2
     d08: 0a0c01e3     	and	w3, w15, w12
     d0c: 52984b70     	mov	w16, #0xc25b            // =49755
     d10: 4acc2e31     	eor	w17, w17, w12, ror #11
     d14: 2a020062     	orr	w2, w3, w2
     d18: 72a72ad0     	movk	w16, #0x3956, lsl #16
     d1c: 4ac83421     	eor	w1, w1, w8, ror #13
     d20: 0a0a0163     	and	w3, w11, w10
     d24: 0a120112     	and	w18, w8, w18
     d28: 0b0201ce     	add	w14, w14, w2
     d2c: 4acc6631     	eor	w17, w17, w12, ror #25
     d30: 2a030252     	orr	w18, w18, w3
     d34: 4ac85821     	eor	w1, w1, w8, ror #22
     d38: 0b1001ce     	add	w14, w14, w16
     d3c: 52823e30     	mov	w16, #0x11f1            // =4593
     d40: 0b1101d1     	add	w17, w14, w17
     d44: 72ab3e30     	movk	w16, #0x59f1, lsl #16
     d48: 0b120032     	add	w18, w1, w18
     d4c: 0b09022e     	add	w14, w17, w9
     d50: 0b110249     	add	w9, w18, w17
     d54: 138e19c1     	ror	w1, w14, #0x6
     d58: 0a0e0183     	and	w3, w12, w14
     d5c: 2942cbf1     	ldp	w17, w18, [sp, #0x14]
     d60: 13890922     	ror	w2, w9, #0x2
     d64: 4ace2c21     	eor	w1, w1, w14, ror #11
     d68: 0b0d022d     	add	w13, w17, w13
     d6c: 0a2e01f1     	bic	w17, w15, w14
     d70: 4ac93442     	eor	w2, w2, w9, ror #13
     d74: 2a110071     	orr	w17, w3, w17
     d78: 2a0b0103     	orr	w3, w8, w11
     d7c: 4ace6421     	eor	w1, w1, w14, ror #25
     d80: 0b1101ad     	add	w13, w13, w17
     d84: 0a0b0111     	and	w17, w8, w11
     d88: 0a030123     	and	w3, w9, w3
     d8c: 4ac95842     	eor	w2, w2, w9, ror #22
     d90: 2a110071     	orr	w17, w3, w17
     d94: 0b1001ad     	add	w13, w13, w16
     d98: 0b0101b0     	add	w16, w13, w1
     d9c: 0b0f024f     	add	w15, w18, w15
     da0: 2a080132     	orr	w18, w9, w8
     da4: 0b110051     	add	w17, w2, w17
     da8: 0b0a020d     	add	w13, w16, w10
     dac: 0b10022a     	add	w10, w17, w16
     db0: 138d19b1     	ror	w17, w13, #0x6
     db4: 0a2d0182     	bic	w2, w12, w13
     db8: 138a0941     	ror	w1, w10, #0x2
     dbc: 0a0d01c3     	and	w3, w14, w13
     dc0: 52905490     	mov	w16, #0x82a4            // =33444
     dc4: 4acd2e31     	eor	w17, w17, w13, ror #11
     dc8: 2a020062     	orr	w2, w3, w2
     dcc: 72b247f0     	movk	w16, #0x923f, lsl #16
     dd0: 4aca3421     	eor	w1, w1, w10, ror #13
     dd4: 0a080123     	and	w3, w9, w8
     dd8: 0a120152     	and	w18, w10, w18
     ddc: 0b0201ef     	add	w15, w15, w2
     de0: 4acd6631     	eor	w17, w17, w13, ror #25
     de4: 2a030252     	orr	w18, w18, w3
     de8: 4aca5821     	eor	w1, w1, w10, ror #22
     dec: 0b1001ef     	add	w15, w15, w16
     df0: 528bdab0     	mov	w16, #0x5ed5            // =24277
     df4: 0b1101f1     	add	w17, w15, w17
     df8: 72b56390     	movk	w16, #0xab1c, lsl #16
     dfc: 0b120032     	add	w18, w1, w18
     e00: 0b0b022f     	add	w15, w17, w11
     e04: 0b11024b     	add	w11, w18, w17
     e08: 138f19e1     	ror	w1, w15, #0x6
     e0c: 0a0f01a3     	and	w3, w13, w15
     e10: 2943cbf1     	ldp	w17, w18, [sp, #0x1c]
     e14: 138b0962     	ror	w2, w11, #0x2
     e18: 4acf2c21     	eor	w1, w1, w15, ror #11
     e1c: 0b0c022c     	add	w12, w17, w12
     e20: 0a2f01d1     	bic	w17, w14, w15
     e24: 4acb3442     	eor	w2, w2, w11, ror #13
     e28: 2a110071     	orr	w17, w3, w17
     e2c: 2a090143     	orr	w3, w10, w9
     e30: 4acf6421     	eor	w1, w1, w15, ror #25
     e34: 0b11018c     	add	w12, w12, w17
     e38: 0a090151     	and	w17, w10, w9
     e3c: 0a030163     	and	w3, w11, w3
     e40: 4acb5842     	eor	w2, w2, w11, ror #22
     e44: 2a110071     	orr	w17, w3, w17
     e48: 0b10018c     	add	w12, w12, w16
     e4c: 0b010190     	add	w16, w12, w1
     e50: 0b0e024e     	add	w14, w18, w14
     e54: 2a0a0172     	orr	w18, w11, w10
     e58: 0b110051     	add	w17, w2, w17
     e5c: 0b08020c     	add	w12, w16, w8
     e60: 0b100228     	add	w8, w17, w16
     e64: 138c1991     	ror	w17, w12, #0x6
     e68: 0a2c01a2     	bic	w2, w13, w12
     e6c: 13880901     	ror	w1, w8, #0x2
     e70: 0a0c01e3     	and	w3, w15, w12
     e74: 52955310     	mov	w16, #0xaa98            // =43672
     e78: 4acc2e31     	eor	w17, w17, w12, ror #11
     e7c: 2a020062     	orr	w2, w3, w2
     e80: 72bb00f0     	movk	w16, #0xd807, lsl #16
     e84: 4ac83421     	eor	w1, w1, w8, ror #13
     e88: 0a0a0163     	and	w3, w11, w10
     e8c: 0a120112     	and	w18, w8, w18
     e90: 0b0201ce     	add	w14, w14, w2
     e94: 4acc6631     	eor	w17, w17, w12, ror #25
     e98: 2a030252     	orr	w18, w18, w3
     e9c: 4ac85821     	eor	w1, w1, w8, ror #22
     ea0: 0b1001ce     	add	w14, w14, w16
     ea4: 528b6030     	mov	w16, #0x5b01            // =23297
     ea8: 0b1101d1     	add	w17, w14, w17
     eac: 72a25070     	movk	w16, #0x1283, lsl #16
     eb0: 0b120032     	add	w18, w1, w18
     eb4: 0b09022e     	add	w14, w17, w9
     eb8: 0b110249     	add	w9, w18, w17
     ebc: 138e19c1     	ror	w1, w14, #0x6
     ec0: 0a0e0183     	and	w3, w12, w14
     ec4: 2944cbf1     	ldp	w17, w18, [sp, #0x24]
     ec8: 13890922     	ror	w2, w9, #0x2
     ecc: 4ace2c21     	eor	w1, w1, w14, ror #11
     ed0: 0b0d022d     	add	w13, w17, w13
     ed4: 0a2e01f1     	bic	w17, w15, w14
     ed8: 4ac93442     	eor	w2, w2, w9, ror #13
     edc: 2a110071     	orr	w17, w3, w17
     ee0: 2a0b0103     	orr	w3, w8, w11
     ee4: 4ace6421     	eor	w1, w1, w14, ror #25
     ee8: 0b1101ad     	add	w13, w13, w17
     eec: 0a0b0111     	and	w17, w8, w11
     ef0: 0a030123     	and	w3, w9, w3
     ef4: 4ac95842     	eor	w2, w2, w9, ror #22
     ef8: 2a110071     	orr	w17, w3, w17
     efc: 0b1001ad     	add	w13, w13, w16
     f00: 0b0101b0     	add	w16, w13, w1
     f04: 0b0f024f     	add	w15, w18, w15
     f08: 2a080132     	orr	w18, w9, w8
     f0c: 0b110051     	add	w17, w2, w17
     f10: 0b0a020d     	add	w13, w16, w10
     f14: 0b10022a     	add	w10, w17, w16
     f18: 138d19b1     	ror	w17, w13, #0x6
     f1c: 0a2d0182     	bic	w2, w12, w13
     f20: 138a0941     	ror	w1, w10, #0x2
     f24: 0a0d01c3     	and	w3, w14, w13
     f28: 5290b7d0     	mov	w16, #0x85be            // =34238
     f2c: 4acd2e31     	eor	w17, w17, w13, ror #11
     f30: 2a020062     	orr	w2, w3, w2
     f34: 72a48630     	movk	w16, #0x2431, lsl #16
     f38: 4aca3421     	eor	w1, w1, w10, ror #13
     f3c: 0a080123     	and	w3, w9, w8
     f40: 0a120152     	and	w18, w10, w18
     f44: 0b0201ef     	add	w15, w15, w2
     f48: 4acd6631     	eor	w17, w17, w13, ror #25
     f4c: 2a030252     	orr	w18, w18, w3
     f50: 4aca5821     	eor	w1, w1, w10, ror #22
     f54: 0b1001ef     	add	w15, w15, w16
     f58: 528fb870     	mov	w16, #0x7dc3            // =32195
     f5c: 0b1101f1     	add	w17, w15, w17
     f60: 72aaa190     	movk	w16, #0x550c, lsl #16
     f64: 0b120032     	add	w18, w1, w18
     f68: 0b0b022f     	add	w15, w17, w11
     f6c: 0b11024b     	add	w11, w18, w17
     f70: 138f19e1     	ror	w1, w15, #0x6
     f74: 0a0f01a3     	and	w3, w13, w15
     f78: 2945cbf1     	ldp	w17, w18, [sp, #0x2c]
     f7c: 138b0962     	ror	w2, w11, #0x2
     f80: 4acf2c21     	eor	w1, w1, w15, ror #11
     f84: 0b0c022c     	add	w12, w17, w12
     f88: 0a2f01d1     	bic	w17, w14, w15
     f8c: 4acb3442     	eor	w2, w2, w11, ror #13
     f90: 2a110071     	orr	w17, w3, w17
     f94: 2a090143     	orr	w3, w10, w9
     f98: 4acf6421     	eor	w1, w1, w15, ror #25
     f9c: 0b11018c     	add	w12, w12, w17
     fa0: 0a090151     	and	w17, w10, w9
     fa4: 0a030163     	and	w3, w11, w3
     fa8: 4acb5842     	eor	w2, w2, w11, ror #22
     fac: 2a110071     	orr	w17, w3, w17
     fb0: 0b10018c     	add	w12, w12, w16
     fb4: 0b010190     	add	w16, w12, w1
     fb8: 0b0e024e     	add	w14, w18, w14
     fbc: 2a0a0172     	orr	w18, w11, w10
     fc0: 0b110051     	add	w17, w2, w17
     fc4: 0b08020c     	add	w12, w16, w8
     fc8: 0b100228     	add	w8, w17, w16
     fcc: 138c1991     	ror	w17, w12, #0x6
     fd0: 0a2c01a2     	bic	w2, w13, w12
     fd4: 13880901     	ror	w1, w8, #0x2
     fd8: 0a0c01e3     	and	w3, w15, w12
     fdc: 528bae90     	mov	w16, #0x5d74            // =23924
     fe0: 4acc2e31     	eor	w17, w17, w12, ror #11
     fe4: 2a020062     	orr	w2, w3, w2
     fe8: 72ae57d0     	movk	w16, #0x72be, lsl #16
     fec: 4ac83421     	eor	w1, w1, w8, ror #13
     ff0: 0a0a0163     	and	w3, w11, w10
     ff4: 0a120112     	and	w18, w8, w18
     ff8: 0b0201ce     	add	w14, w14, w2
     ffc: 4acc6631     	eor	w17, w17, w12, ror #25
    1000: 2a030252     	orr	w18, w18, w3
    1004: 4ac85821     	eor	w1, w1, w8, ror #22
    1008: 0b1001ce     	add	w14, w14, w16
    100c: 52963fd0     	mov	w16, #0xb1fe            // =45566
    1010: 0b1101d1     	add	w17, w14, w17
    1014: 72b01bd0     	movk	w16, #0x80de, lsl #16
    1018: 0b120032     	add	w18, w1, w18
    101c: 0b09022e     	add	w14, w17, w9
    1020: 0b110249     	add	w9, w18, w17
    1024: 138e19c1     	ror	w1, w14, #0x6
    1028: 0a0e0183     	and	w3, w12, w14
    102c: 2946cbf1     	ldp	w17, w18, [sp, #0x34]
    1030: 13890922     	ror	w2, w9, #0x2
    1034: 4ace2c21     	eor	w1, w1, w14, ror #11
    1038: 0b0d022d     	add	w13, w17, w13
    103c: 0a2e01f1     	bic	w17, w15, w14
    1040: 4ac93442     	eor	w2, w2, w9, ror #13
    1044: 2a110071     	orr	w17, w3, w17
    1048: 2a0b0103     	orr	w3, w8, w11
    104c: 4ace6421     	eor	w1, w1, w14, ror #25
    1050: 0b1101ad     	add	w13, w13, w17
    1054: 0a0b0111     	and	w17, w8, w11
    1058: 0a030123     	and	w3, w9, w3
    105c: 4ac95842     	eor	w2, w2, w9, ror #22
    1060: 2a110071     	orr	w17, w3, w17
    1064: 0b1001ad     	add	w13, w13, w16
    1068: 0b0101b0     	add	w16, w13, w1
    106c: 0b0f024f     	add	w15, w18, w15
    1070: 2a080132     	orr	w18, w9, w8
    1074: 0b110051     	add	w17, w2, w17
    1078: 0b0a020d     	add	w13, w16, w10
    107c: 0b10022a     	add	w10, w17, w16
    1080: 138d19b1     	ror	w17, w13, #0x6
    1084: 0a2d0182     	bic	w2, w12, w13
    1088: 138a0941     	ror	w1, w10, #0x2
    108c: 0a0d01c3     	and	w3, w14, w13
    1090: 5280d4f0     	mov	w16, #0x6a7             // =1703
    1094: 4acd2e31     	eor	w17, w17, w13, ror #11
    1098: 2a020062     	orr	w2, w3, w2
    109c: 72b37b90     	movk	w16, #0x9bdc, lsl #16
    10a0: 4aca3421     	eor	w1, w1, w10, ror #13
    10a4: 0a080123     	and	w3, w9, w8
    10a8: 0a120152     	and	w18, w10, w18
    10ac: 0b0201ef     	add	w15, w15, w2
    10b0: 4acd6631     	eor	w17, w17, w13, ror #25
    10b4: 2a030252     	orr	w18, w18, w3
    10b8: 4aca5821     	eor	w1, w1, w10, ror #22
    10bc: 0b1001ef     	add	w15, w15, w16
    10c0: 529e2e90     	mov	w16, #0xf174            // =61812
    10c4: 0b1101f1     	add	w17, w15, w17
    10c8: 72b83370     	movk	w16, #0xc19b, lsl #16
    10cc: 0b120032     	add	w18, w1, w18
    10d0: 0b0b022f     	add	w15, w17, w11
    10d4: 0b11024b     	add	w11, w18, w17
    10d8: 138f19e1     	ror	w1, w15, #0x6
    10dc: 0a0f01a3     	and	w3, w13, w15
    10e0: 2947cbf1     	ldp	w17, w18, [sp, #0x3c]
    10e4: 138b0962     	ror	w2, w11, #0x2
    10e8: 4acf2c21     	eor	w1, w1, w15, ror #11
    10ec: 0b0c022c     	add	w12, w17, w12
    10f0: 0a2f01d1     	bic	w17, w14, w15
    10f4: 4acb3442     	eor	w2, w2, w11, ror #13
    10f8: 2a110071     	orr	w17, w3, w17
    10fc: 2a090143     	orr	w3, w10, w9
    1100: 4acf6421     	eor	w1, w1, w15, ror #25
    1104: 0b11018c     	add	w12, w12, w17
    1108: 0a090151     	and	w17, w10, w9
    110c: 0a030163     	and	w3, w11, w3
    1110: 4acb5842     	eor	w2, w2, w11, ror #22
    1114: 2a110071     	orr	w17, w3, w17
    1118: 0b10018c     	add	w12, w12, w16
    111c: 0b010190     	add	w16, w12, w1
    1120: 0b0e024e     	add	w14, w18, w14
    1124: 2a0a0172     	orr	w18, w11, w10
    1128: 0b110051     	add	w17, w2, w17
    112c: 0b08020c     	add	w12, w16, w8
    1130: 0b100228     	add	w8, w17, w16
    1134: 138c1991     	ror	w17, w12, #0x6
    1138: 0a2c01a2     	bic	w2, w13, w12
    113c: 13880901     	ror	w1, w8, #0x2
    1140: 0a0c01e3     	and	w3, w15, w12
    1144: 528d3830     	mov	w16, #0x69c1            // =27073
    1148: 4acc2e31     	eor	w17, w17, w12, ror #11
    114c: 2a020062     	orr	w2, w3, w2
    1150: 72bc9370     	movk	w16, #0xe49b, lsl #16
    1154: 4ac83421     	eor	w1, w1, w8, ror #13
    1158: 0a0a0163     	and	w3, w11, w10
    115c: 0a120112     	and	w18, w8, w18
    1160: 0b0201ce     	add	w14, w14, w2
    1164: 4acc6631     	eor	w17, w17, w12, ror #25
    1168: 2a030252     	orr	w18, w18, w3
    116c: 4ac85821     	eor	w1, w1, w8, ror #22
    1170: 0b1001ce     	add	w14, w14, w16
    1174: 5288f0d0     	mov	w16, #0x4786            // =18310
    1178: 0b1101d1     	add	w17, w14, w17
    117c: 72bdf7d0     	movk	w16, #0xefbe, lsl #16
    1180: 0b120032     	add	w18, w1, w18
    1184: 0b09022e     	add	w14, w17, w9
    1188: 0b110249     	add	w9, w18, w17
    118c: 138e19c1     	ror	w1, w14, #0x6
    1190: 0a0e0183     	and	w3, w12, w14
    1194: 2948cbf1     	ldp	w17, w18, [sp, #0x44]
    1198: 13890922     	ror	w2, w9, #0x2
    119c: 4ace2c21     	eor	w1, w1, w14, ror #11
    11a0: 0b0d022d     	add	w13, w17, w13
    11a4: 0a2e01f1     	bic	w17, w15, w14
    11a8: 4ac93442     	eor	w2, w2, w9, ror #13
    11ac: 2a110071     	orr	w17, w3, w17
    11b0: 2a0b0103     	orr	w3, w8, w11
    11b4: 4ace6421     	eor	w1, w1, w14, ror #25
    11b8: 0b1101ad     	add	w13, w13, w17
    11bc: 0a0b0111     	and	w17, w8, w11
    11c0: 0a030123     	and	w3, w9, w3
    11c4: 4ac95842     	eor	w2, w2, w9, ror #22
    11c8: 2a110071     	orr	w17, w3, w17
    11cc: 0b1001ad     	add	w13, w13, w16
    11d0: 0b0101b0     	add	w16, w13, w1
    11d4: 0b0f024f     	add	w15, w18, w15
    11d8: 2a080132     	orr	w18, w9, w8
    11dc: 0b110051     	add	w17, w2, w17
    11e0: 0b0a020d     	add	w13, w16, w10
    11e4: 0b10022a     	add	w10, w17, w16
    11e8: 138d19b1     	ror	w17, w13, #0x6
    11ec: 0a2d0182     	bic	w2, w12, w13
    11f0: 138a0941     	ror	w1, w10, #0x2
    11f4: 0a0d01c3     	and	w3, w14, w13
    11f8: 5293b8d0     	mov	w16, #0x9dc6            // =40390
    11fc: 4acd2e31     	eor	w17, w17, w13, ror #11
    1200: 2a020062     	orr	w2, w3, w2
    1204: 72a1f830     	movk	w16, #0xfc1, lsl #16
    1208: 4aca3421     	eor	w1, w1, w10, ror #13
    120c: 0a080123     	and	w3, w9, w8
    1210: 0a120152     	and	w18, w10, w18
    1214: 0b0201ef     	add	w15, w15, w2
    1218: 4acd6631     	eor	w17, w17, w13, ror #25
    121c: 2a030252     	orr	w18, w18, w3
    1220: 4aca5821     	eor	w1, w1, w10, ror #22
    1224: 0b1001ef     	add	w15, w15, w16
    1228: 52943990     	mov	w16, #0xa1cc            // =41420
    122c: 0b1101f1     	add	w17, w15, w17
    1230: 72a48190     	movk	w16, #0x240c, lsl #16
    1234: 0b120032     	add	w18, w1, w18
    1238: 0b0b022f     	add	w15, w17, w11
    123c: 0b11024b     	add	w11, w18, w17
    1240: 138f19e1     	ror	w1, w15, #0x6
    1244: 0a0f01a3     	and	w3, w13, w15
    1248: 2949cbf1     	ldp	w17, w18, [sp, #0x4c]
    124c: 138b0962     	ror	w2, w11, #0x2
    1250: 4acf2c21     	eor	w1, w1, w15, ror #11
    1254: 0b0c022c     	add	w12, w17, w12
    1258: 0a2f01d1     	bic	w17, w14, w15
    125c: 4acb3442     	eor	w2, w2, w11, ror #13
    1260: 2a110071     	orr	w17, w3, w17
    1264: 2a090143     	orr	w3, w10, w9
    1268: 4acf6421     	eor	w1, w1, w15, ror #25
    126c: 0b11018c     	add	w12, w12, w17
    1270: 0a090151     	and	w17, w10, w9
    1274: 0a030163     	and	w3, w11, w3
    1278: 4acb5842     	eor	w2, w2, w11, ror #22
    127c: 2a110071     	orr	w17, w3, w17
    1280: 0b10018c     	add	w12, w12, w16
    1284: 0b010190     	add	w16, w12, w1
    1288: 0b0e024e     	add	w14, w18, w14
    128c: 2a0a0172     	orr	w18, w11, w10
    1290: 0b110051     	add	w17, w2, w17
    1294: 0b08020c     	add	w12, w16, w8
    1298: 0b100228     	add	w8, w17, w16
    129c: 138c1991     	ror	w17, w12, #0x6
    12a0: 0a2c01a2     	bic	w2, w13, w12
    12a4: 13880901     	ror	w1, w8, #0x2
    12a8: 0a0c01e3     	and	w3, w15, w12
    12ac: 52858df0     	mov	w16, #0x2c6f            // =11375
    12b0: 4acc2e31     	eor	w17, w17, w12, ror #11
    12b4: 2a020062     	orr	w2, w3, w2
    12b8: 72a5bd30     	movk	w16, #0x2de9, lsl #16
    12bc: 4ac83421     	eor	w1, w1, w8, ror #13
    12c0: 0a0a0163     	and	w3, w11, w10
    12c4: 0a120112     	and	w18, w8, w18
    12c8: 0b0201ce     	add	w14, w14, w2
    12cc: 4acc6631     	eor	w17, w17, w12, ror #25
    12d0: 2a030252     	orr	w18, w18, w3
    12d4: 4ac85821     	eor	w1, w1, w8, ror #22
    12d8: 0b1001ce     	add	w14, w14, w16
    12dc: 52909550     	mov	w16, #0x84aa            // =33962
    12e0: 0b1101d1     	add	w17, w14, w17
    12e4: 72a94e90     	movk	w16, #0x4a74, lsl #16
    12e8: 0b120032     	add	w18, w1, w18
    12ec: 0b09022e     	add	w14, w17, w9
    12f0: 0b110249     	add	w9, w18, w17
    12f4: 138e19c1     	ror	w1, w14, #0x6
    12f8: 0a0e0183     	and	w3, w12, w14
    12fc: 294acbf1     	ldp	w17, w18, [sp, #0x54]
    1300: 13890922     	ror	w2, w9, #0x2
    1304: 4ace2c21     	eor	w1, w1, w14, ror #11
    1308: 0b0d022d     	add	w13, w17, w13
    130c: 0a2e01f1     	bic	w17, w15, w14
    1310: 4ac93442     	eor	w2, w2, w9, ror #13
    1314: 2a110071     	orr	w17, w3, w17
    1318: 2a0b0103     	orr	w3, w8, w11
    131c: 4ace6421     	eor	w1, w1, w14, ror #25
    1320: 0b1101ad     	add	w13, w13, w17
    1324: 0a0b0111     	and	w17, w8, w11
    1328: 0a030123     	and	w3, w9, w3
    132c: 4ac95842     	eor	w2, w2, w9, ror #22
    1330: 2a110071     	orr	w17, w3, w17
    1334: 0b1001ad     	add	w13, w13, w16
    1338: 0b0101b0     	add	w16, w13, w1
    133c: 0b0f024f     	add	w15, w18, w15
    1340: 2a080132     	orr	w18, w9, w8
    1344: 0b110051     	add	w17, w2, w17
    1348: 0b0a020d     	add	w13, w16, w10
    134c: 0b10022a     	add	w10, w17, w16
    1350: 138d19b1     	ror	w17, w13, #0x6
    1354: 0a2d0182     	bic	w2, w12, w13
    1358: 138a0941     	ror	w1, w10, #0x2
    135c: 0a0d01c3     	and	w3, w14, w13
    1360: 52953b90     	mov	w16, #0xa9dc            // =43484
    1364: 4acd2e31     	eor	w17, w17, w13, ror #11
    1368: 2a020062     	orr	w2, w3, w2
    136c: 72ab9610     	movk	w16, #0x5cb0, lsl #16
    1370: 4aca3421     	eor	w1, w1, w10, ror #13
    1374: 0a080123     	and	w3, w9, w8
    1378: 0a120152     	and	w18, w10, w18
    137c: 0b0201ef     	add	w15, w15, w2
    1380: 4acd6631     	eor	w17, w17, w13, ror #25
    1384: 2a030252     	orr	w18, w18, w3
    1388: 4aca5821     	eor	w1, w1, w10, ror #22
    138c: 0b1001ef     	add	w15, w15, w16
    1390: 52911b50     	mov	w16, #0x88da            // =35034
    1394: 0b1101f1     	add	w17, w15, w17
    1398: 72aedf30     	movk	w16, #0x76f9, lsl #16
    139c: 0b120032     	add	w18, w1, w18
    13a0: 0b0b022f     	add	w15, w17, w11
    13a4: 0b11024b     	add	w11, w18, w17
    13a8: 138f19e1     	ror	w1, w15, #0x6
    13ac: 0a0f01a3     	and	w3, w13, w15
    13b0: 294bcbf1     	ldp	w17, w18, [sp, #0x5c]
    13b4: 138b0962     	ror	w2, w11, #0x2
    13b8: 4acf2c21     	eor	w1, w1, w15, ror #11
    13bc: 0b0c022c     	add	w12, w17, w12
    13c0: 0a2f01d1     	bic	w17, w14, w15
    13c4: 4acb3442     	eor	w2, w2, w11, ror #13
    13c8: 2a110071     	orr	w17, w3, w17
    13cc: 2a090143     	orr	w3, w10, w9
    13d0: 4acf6421     	eor	w1, w1, w15, ror #25
    13d4: 0b11018c     	add	w12, w12, w17
    13d8: 0a090151     	and	w17, w10, w9
    13dc: 0a030163     	and	w3, w11, w3
    13e0: 4acb5842     	eor	w2, w2, w11, ror #22
    13e4: 2a110071     	orr	w17, w3, w17
    13e8: 0b10018c     	add	w12, w12, w16
    13ec: 0b010190     	add	w16, w12, w1
    13f0: 0b0e024e     	add	w14, w18, w14
    13f4: 2a0a0172     	orr	w18, w11, w10
    13f8: 0b110051     	add	w17, w2, w17
    13fc: 0b08020c     	add	w12, w16, w8
    1400: 0b100228     	add	w8, w17, w16
    1404: 138c1991     	ror	w17, w12, #0x6
    1408: 0a2c01a2     	bic	w2, w13, w12
    140c: 13880901     	ror	w1, w8, #0x2
    1410: 0a0c01e3     	and	w3, w15, w12
    1414: 528a2a50     	mov	w16, #0x5152            // =20818
    1418: 4acc2e31     	eor	w17, w17, w12, ror #11
    141c: 2a020062     	orr	w2, w3, w2
    1420: 72b307d0     	movk	w16, #0x983e, lsl #16
    1424: 4ac83421     	eor	w1, w1, w8, ror #13
    1428: 0a0a0163     	and	w3, w11, w10
    142c: 0a120112     	and	w18, w8, w18
    1430: 0b0201ce     	add	w14, w14, w2
    1434: 4acc6631     	eor	w17, w17, w12, ror #25
    1438: 2a030252     	orr	w18, w18, w3
    143c: 4ac85821     	eor	w1, w1, w8, ror #22
    1440: 0b1001ce     	add	w14, w14, w16
    1444: 5298cdb0     	mov	w16, #0xc66d            // =50797
    1448: 0b1101d1     	add	w17, w14, w17
    144c: 72b50630     	movk	w16, #0xa831, lsl #16
    1450: 0b120032     	add	w18, w1, w18
    1454: 0b09022e     	add	w14, w17, w9
    1458: 0b110249     	add	w9, w18, w17
    145c: 138e19c1     	ror	w1, w14, #0x6
    1460: 0a0e0183     	and	w3, w12, w14
    1464: 294ccbf1     	ldp	w17, w18, [sp, #0x64]
    1468: 13890922     	ror	w2, w9, #0x2
    146c: 4ace2c21     	eor	w1, w1, w14, ror #11
    1470: 0b0d022d     	add	w13, w17, w13
    1474: 0a2e01f1     	bic	w17, w15, w14
    1478: 4ac93442     	eor	w2, w2, w9, ror #13
    147c: 2a110071     	orr	w17, w3, w17
    1480: 2a0b0103     	orr	w3, w8, w11
    1484: 4ace6421     	eor	w1, w1, w14, ror #25
    1488: 0b1101ad     	add	w13, w13, w17
    148c: 0a0b0111     	and	w17, w8, w11
    1490: 0a030123     	and	w3, w9, w3
    1494: 4ac95842     	eor	w2, w2, w9, ror #22
    1498: 2a110071     	orr	w17, w3, w17
    149c: 0b1001ad     	add	w13, w13, w16
    14a0: 0b0101b0     	add	w16, w13, w1
    14a4: 0b0f024f     	add	w15, w18, w15
    14a8: 2a080132     	orr	w18, w9, w8
    14ac: 0b110051     	add	w17, w2, w17
    14b0: 0b0a020d     	add	w13, w16, w10
    14b4: 0b10022a     	add	w10, w17, w16
    14b8: 138d19b1     	ror	w17, w13, #0x6
    14bc: 0a2d0182     	bic	w2, w12, w13
    14c0: 138a0941     	ror	w1, w10, #0x2
    14c4: 0a0d01c3     	and	w3, w14, w13
    14c8: 5284f910     	mov	w16, #0x27c8            // =10184
    14cc: 4acd2e31     	eor	w17, w17, w13, ror #11
    14d0: 2a020062     	orr	w2, w3, w2
    14d4: 72b60070     	movk	w16, #0xb003, lsl #16
    14d8: 4aca3421     	eor	w1, w1, w10, ror #13
    14dc: 0a080123     	and	w3, w9, w8
    14e0: 0a120152     	and	w18, w10, w18
    14e4: 0b0201ef     	add	w15, w15, w2
    14e8: 4acd6631     	eor	w17, w17, w13, ror #25
    14ec: 2a030252     	orr	w18, w18, w3
    14f0: 4aca5821     	eor	w1, w1, w10, ror #22
    14f4: 0b1001ef     	add	w15, w15, w16
    14f8: 528ff8f0     	mov	w16, #0x7fc7            // =32711
    14fc: 0b1101f1     	add	w17, w15, w17
    1500: 72b7eb30     	movk	w16, #0xbf59, lsl #16
    1504: 0b120032     	add	w18, w1, w18
    1508: 0b0b022f     	add	w15, w17, w11
    150c: 0b11024b     	add	w11, w18, w17
    1510: 138f19e1     	ror	w1, w15, #0x6
    1514: 0a0f01a3     	and	w3, w13, w15
    1518: 294dcbf1     	ldp	w17, w18, [sp, #0x6c]
    151c: 138b0962     	ror	w2, w11, #0x2
    1520: 4acf2c21     	eor	w1, w1, w15, ror #11
    1524: 0b0c022c     	add	w12, w17, w12
    1528: 0a2f01d1     	bic	w17, w14, w15
    152c: 4acb3442     	eor	w2, w2, w11, ror #13
    1530: 2a110071     	orr	w17, w3, w17
    1534: 2a090143     	orr	w3, w10, w9
    1538: 4acf6421     	eor	w1, w1, w15, ror #25
    153c: 0b11018c     	add	w12, w12, w17
    1540: 0a090151     	and	w17, w10, w9
    1544: 0a030163     	and	w3, w11, w3
    1548: 4acb5842     	eor	w2, w2, w11, ror #22
    154c: 2a110071     	orr	w17, w3, w17
    1550: 0b10018c     	add	w12, w12, w16
    1554: 0b010190     	add	w16, w12, w1
    1558: 0b0e024e     	add	w14, w18, w14
    155c: 2a0a0172     	orr	w18, w11, w10
    1560: 0b110051     	add	w17, w2, w17
    1564: 0b08020c     	add	w12, w16, w8
    1568: 0b100228     	add	w8, w17, w16
    156c: 138c1991     	ror	w17, w12, #0x6
    1570: 0a2c01a2     	bic	w2, w13, w12
    1574: 13880901     	ror	w1, w8, #0x2
    1578: 0a0c01e3     	and	w3, w15, w12
    157c: 52817e70     	mov	w16, #0xbf3             // =3059
    1580: 4acc2e31     	eor	w17, w17, w12, ror #11
    1584: 2a020062     	orr	w2, w3, w2
    1588: 72b8dc10     	movk	w16, #0xc6e0, lsl #16
    158c: 4ac83421     	eor	w1, w1, w8, ror #13
    1590: 0a0a0163     	and	w3, w11, w10
    1594: 0a120112     	and	w18, w8, w18
    1598: 0b0201ce     	add	w14, w14, w2
    159c: 4acc6631     	eor	w17, w17, w12, ror #25
    15a0: 2a030252     	orr	w18, w18, w3
    15a4: 4ac85821     	eor	w1, w1, w8, ror #22
    15a8: 0b1001ce     	add	w14, w14, w16
    15ac: 529228f0     	mov	w16, #0x9147            // =37191
    15b0: 0b1101d1     	add	w17, w14, w17
    15b4: 72bab4f0     	movk	w16, #0xd5a7, lsl #16
    15b8: 0b120032     	add	w18, w1, w18
    15bc: 0b09022e     	add	w14, w17, w9
    15c0: 0b110249     	add	w9, w18, w17
    15c4: 138e19c1     	ror	w1, w14, #0x6
    15c8: 0a0e0183     	and	w3, w12, w14
    15cc: 294ecbf1     	ldp	w17, w18, [sp, #0x74]
    15d0: 13890922     	ror	w2, w9, #0x2
    15d4: 4ace2c21     	eor	w1, w1, w14, ror #11
    15d8: 0b0d022d     	add	w13, w17, w13
    15dc: 0a2e01f1     	bic	w17, w15, w14
    15e0: 4ac93442     	eor	w2, w2, w9, ror #13
    15e4: 2a110071     	orr	w17, w3, w17
    15e8: 2a0b0103     	orr	w3, w8, w11
    15ec: 4ace6421     	eor	w1, w1, w14, ror #25
    15f0: 0b1101ad     	add	w13, w13, w17
    15f4: 0a0b0111     	and	w17, w8, w11
    15f8: 0a030123     	and	w3, w9, w3
    15fc: 4ac95842     	eor	w2, w2, w9, ror #22
    1600: 2a110071     	orr	w17, w3, w17
    1604: 0b1001ad     	add	w13, w13, w16
    1608: 0b0101b0     	add	w16, w13, w1
    160c: 0b0f024f     	add	w15, w18, w15
    1610: 2a080132     	orr	w18, w9, w8
    1614: 0b110051     	add	w17, w2, w17
    1618: 0b0a020d     	add	w13, w16, w10
    161c: 0b10022a     	add	w10, w17, w16
    1620: 138d19b1     	ror	w17, w13, #0x6
    1624: 0a2d0182     	bic	w2, w12, w13
    1628: 138a0941     	ror	w1, w10, #0x2
    162c: 0a0d01c3     	and	w3, w14, w13
    1630: 528c6a30     	mov	w16, #0x6351            // =25425
    1634: 4acd2e31     	eor	w17, w17, w13, ror #11
    1638: 2a020062     	orr	w2, w3, w2
    163c: 72a0d950     	movk	w16, #0x6ca, lsl #16
    1640: 4aca3421     	eor	w1, w1, w10, ror #13
    1644: 0a080123     	and	w3, w9, w8
    1648: 0a120152     	and	w18, w10, w18
    164c: 0b0201ef     	add	w15, w15, w2
    1650: 4acd6631     	eor	w17, w17, w13, ror #25
    1654: 2a030252     	orr	w18, w18, w3
    1658: 4aca5821     	eor	w1, w1, w10, ror #22
    165c: 0b1001ef     	add	w15, w15, w16
    1660: 52852cf0     	mov	w16, #0x2967            // =10599
    1664: 0b1101f1     	add	w17, w15, w17
    1668: 72a28530     	movk	w16, #0x1429, lsl #16
    166c: 0b120032     	add	w18, w1, w18
    1670: 0b0b022f     	add	w15, w17, w11
    1674: 0b11024b     	add	w11, w18, w17
    1678: 138f19e1     	ror	w1, w15, #0x6
    167c: 0a0f01a3     	and	w3, w13, w15
    1680: 294fcbf1     	ldp	w17, w18, [sp, #0x7c]
    1684: 138b0962     	ror	w2, w11, #0x2
    1688: 4acf2c21     	eor	w1, w1, w15, ror #11
    168c: 0b0c022c     	add	w12, w17, w12
    1690: 0a2f01d1     	bic	w17, w14, w15
    1694: 4acb3442     	eor	w2, w2, w11, ror #13
    1698: 2a110071     	orr	w17, w3, w17
    169c: 2a090143     	orr	w3, w10, w9
    16a0: 4acf6421     	eor	w1, w1, w15, ror #25
    16a4: 0b11018c     	add	w12, w12, w17
    16a8: 0a090151     	and	w17, w10, w9
    16ac: 0a030163     	and	w3, w11, w3
    16b0: 4acb5842     	eor	w2, w2, w11, ror #22
    16b4: 2a110071     	orr	w17, w3, w17
    16b8: 0b10018c     	add	w12, w12, w16
    16bc: 0b010190     	add	w16, w12, w1
    16c0: 0b0e024e     	add	w14, w18, w14
    16c4: 2a0a0172     	orr	w18, w11, w10
    16c8: 0b110051     	add	w17, w2, w17
    16cc: 0b08020c     	add	w12, w16, w8
    16d0: 0b100228     	add	w8, w17, w16
    16d4: 138c1991     	ror	w17, w12, #0x6
    16d8: 0a2c01a2     	bic	w2, w13, w12
    16dc: 13880901     	ror	w1, w8, #0x2
    16e0: 0a0c01e3     	and	w3, w15, w12
    16e4: 528150b0     	mov	w16, #0xa85             // =2693
    16e8: 4acc2e31     	eor	w17, w17, w12, ror #11
    16ec: 2a020062     	orr	w2, w3, w2
    16f0: 72a4f6f0     	movk	w16, #0x27b7, lsl #16
    16f4: 4ac83421     	eor	w1, w1, w8, ror #13
    16f8: 0a0a0163     	and	w3, w11, w10
    16fc: 0a120112     	and	w18, w8, w18
    1700: 0b0201ce     	add	w14, w14, w2
    1704: 4acc6631     	eor	w17, w17, w12, ror #25
    1708: 2a030252     	orr	w18, w18, w3
    170c: 4ac85821     	eor	w1, w1, w8, ror #22
    1710: 0b1001ce     	add	w14, w14, w16
    1714: 52842710     	mov	w16, #0x2138            // =8504
    1718: 0b1101d1     	add	w17, w14, w17
    171c: 72a5c370     	movk	w16, #0x2e1b, lsl #16
    1720: 0b120032     	add	w18, w1, w18
    1724: 0b09022e     	add	w14, w17, w9
    1728: 0b110249     	add	w9, w18, w17
    172c: 138e19c1     	ror	w1, w14, #0x6
    1730: 0a0e0183     	and	w3, w12, w14
    1734: 2950cbf1     	ldp	w17, w18, [sp, #0x84]
    1738: 13890922     	ror	w2, w9, #0x2
    173c: 4ace2c21     	eor	w1, w1, w14, ror #11
    1740: 0b0d022d     	add	w13, w17, w13
    1744: 0a2e01f1     	bic	w17, w15, w14
    1748: 4ac93442     	eor	w2, w2, w9, ror #13
    174c: 2a110071     	orr	w17, w3, w17
    1750: 2a0b0103     	orr	w3, w8, w11
    1754: 4ace6421     	eor	w1, w1, w14, ror #25
    1758: 0b1101ad     	add	w13, w13, w17
    175c: 0a0b0111     	and	w17, w8, w11
    1760: 0a030123     	and	w3, w9, w3
    1764: 4ac95842     	eor	w2, w2, w9, ror #22
    1768: 2a110071     	orr	w17, w3, w17
    176c: 0b1001ad     	add	w13, w13, w16
    1770: 0b0101b0     	add	w16, w13, w1
    1774: 0b0f024f     	add	w15, w18, w15
    1778: 2a080132     	orr	w18, w9, w8
    177c: 0b110051     	add	w17, w2, w17
    1780: 0b0a020d     	add	w13, w16, w10
    1784: 0b10022a     	add	w10, w17, w16
    1788: 138d19b1     	ror	w17, w13, #0x6
    178c: 0a2d0182     	bic	w2, w12, w13
    1790: 138a0941     	ror	w1, w10, #0x2
    1794: 0a0d01c3     	and	w3, w14, w13
    1798: 528dbf90     	mov	w16, #0x6dfc            // =28156
    179c: 4acd2e31     	eor	w17, w17, w13, ror #11
    17a0: 2a020062     	orr	w2, w3, w2
    17a4: 72a9a590     	movk	w16, #0x4d2c, lsl #16
    17a8: 4aca3421     	eor	w1, w1, w10, ror #13
    17ac: 0a080123     	and	w3, w9, w8
    17b0: 0a120152     	and	w18, w10, w18
    17b4: 0b0201ef     	add	w15, w15, w2
    17b8: 4acd6631     	eor	w17, w17, w13, ror #25
    17bc: 2a030252     	orr	w18, w18, w3
    17c0: 4aca5821     	eor	w1, w1, w10, ror #22
    17c4: 0b1001ef     	add	w15, w15, w16
    17c8: 5281a270     	mov	w16, #0xd13             // =3347
    17cc: 0b1101f1     	add	w17, w15, w17
    17d0: 72aa6710     	movk	w16, #0x5338, lsl #16
    17d4: 0b120032     	add	w18, w1, w18
    17d8: 0b0b022f     	add	w15, w17, w11
    17dc: 0b11024b     	add	w11, w18, w17
    17e0: 138f19e1     	ror	w1, w15, #0x6
    17e4: 0a0f01a3     	and	w3, w13, w15
    17e8: 2951cbf1     	ldp	w17, w18, [sp, #0x8c]
    17ec: 138b0962     	ror	w2, w11, #0x2
    17f0: 4acf2c21     	eor	w1, w1, w15, ror #11
    17f4: 0b0c022c     	add	w12, w17, w12
    17f8: 0a2f01d1     	bic	w17, w14, w15
    17fc: 4acb3442     	eor	w2, w2, w11, ror #13
    1800: 2a110071     	orr	w17, w3, w17
    1804: 2a090143     	orr	w3, w10, w9
    1808: 4acf6421     	eor	w1, w1, w15, ror #25
    180c: 0b11018c     	add	w12, w12, w17
    1810: 0a090151     	and	w17, w10, w9
    1814: 0a030163     	and	w3, w11, w3
    1818: 4acb5842     	eor	w2, w2, w11, ror #22
    181c: 2a110071     	orr	w17, w3, w17
    1820: 0b10018c     	add	w12, w12, w16
    1824: 0b010190     	add	w16, w12, w1
    1828: 0b0e024e     	add	w14, w18, w14
    182c: 2a0a0172     	orr	w18, w11, w10
    1830: 0b110051     	add	w17, w2, w17
    1834: 0b08020c     	add	w12, w16, w8
    1838: 0b100228     	add	w8, w17, w16
    183c: 138c1991     	ror	w17, w12, #0x6
    1840: 0a2c01a2     	bic	w2, w13, w12
    1844: 13880901     	ror	w1, w8, #0x2
    1848: 0a0c01e3     	and	w3, w15, w12
    184c: 528e6a90     	mov	w16, #0x7354            // =29524
    1850: 4acc2e31     	eor	w17, w17, w12, ror #11
    1854: 2a020062     	orr	w2, w3, w2
    1858: 72aca150     	movk	w16, #0x650a, lsl #16
    185c: 4ac83421     	eor	w1, w1, w8, ror #13
    1860: 0a0a0163     	and	w3, w11, w10
    1864: 0a120112     	and	w18, w8, w18
    1868: 0b0201ce     	add	w14, w14, w2
    186c: 4acc6631     	eor	w17, w17, w12, ror #25
    1870: 2a030252     	orr	w18, w18, w3
    1874: 4ac85821     	eor	w1, w1, w8, ror #22
    1878: 0b1001ce     	add	w14, w14, w16
    187c: 52815770     	mov	w16, #0xabb             // =2747
    1880: 0b1101d1     	add	w17, w14, w17
    1884: 72aecd50     	movk	w16, #0x766a, lsl #16
    1888: 0b120032     	add	w18, w1, w18
    188c: 0b09022e     	add	w14, w17, w9
    1890: 0b110249     	add	w9, w18, w17
    1894: 138e19c1     	ror	w1, w14, #0x6
    1898: 0a0e0183     	and	w3, w12, w14
    189c: 2952cbf1     	ldp	w17, w18, [sp, #0x94]
    18a0: 13890922     	ror	w2, w9, #0x2
    18a4: 4ace2c21     	eor	w1, w1, w14, ror #11
    18a8: 0b0d022d     	add	w13, w17, w13
    18ac: 0a2e01f1     	bic	w17, w15, w14
    18b0: 4ac93442     	eor	w2, w2, w9, ror #13
    18b4: 2a110071     	orr	w17, w3, w17
    18b8: 2a0b0103     	orr	w3, w8, w11
    18bc: 4ace6421     	eor	w1, w1, w14, ror #25
    18c0: 0b1101ad     	add	w13, w13, w17
    18c4: 0a0b0111     	and	w17, w8, w11
    18c8: 0a030123     	and	w3, w9, w3
    18cc: 4ac95842     	eor	w2, w2, w9, ror #22
    18d0: 2a110071     	orr	w17, w3, w17
    18d4: 0b1001ad     	add	w13, w13, w16
    18d8: 0b0101b0     	add	w16, w13, w1
    18dc: 0b0f024f     	add	w15, w18, w15
    18e0: 2a080132     	orr	w18, w9, w8
    18e4: 0b110051     	add	w17, w2, w17
    18e8: 0b0a020d     	add	w13, w16, w10
    18ec: 0b10022a     	add	w10, w17, w16
    18f0: 138d19b1     	ror	w17, w13, #0x6
    18f4: 0a2d0182     	bic	w2, w12, w13
    18f8: 138a0941     	ror	w1, w10, #0x2
    18fc: 0a0d01c3     	and	w3, w14, w13
    1900: 529925d0     	mov	w16, #0xc92e            // =51502
    1904: 4acd2e31     	eor	w17, w17, w13, ror #11
    1908: 2a020062     	orr	w2, w3, w2
    190c: 72b03850     	movk	w16, #0x81c2, lsl #16
    1910: 4aca3421     	eor	w1, w1, w10, ror #13
    1914: 0a080123     	and	w3, w9, w8
    1918: 0a120152     	and	w18, w10, w18
    191c: 0b0201ef     	add	w15, w15, w2
    1920: 4acd6631     	eor	w17, w17, w13, ror #25
    1924: 2a030252     	orr	w18, w18, w3
    1928: 4aca5821     	eor	w1, w1, w10, ror #22
    192c: 0b1001ef     	add	w15, w15, w16
    1930: 528590b0     	mov	w16, #0x2c85            // =11397
    1934: 0b1101f1     	add	w17, w15, w17
    1938: 72b24e50     	movk	w16, #0x9272, lsl #16
    193c: 0b120032     	add	w18, w1, w18
    1940: 0b0b022f     	add	w15, w17, w11
    1944: 0b11024b     	add	w11, w18, w17
    1948: 138f19e1     	ror	w1, w15, #0x6
    194c: 0a0f01a3     	and	w3, w13, w15
    1950: 2953cbf1     	ldp	w17, w18, [sp, #0x9c]
    1954: 138b0962     	ror	w2, w11, #0x2
    1958: 4acf2c21     	eor	w1, w1, w15, ror #11
    195c: 0b0c022c     	add	w12, w17, w12
    1960: 0a2f01d1     	bic	w17, w14, w15
    1964: 4acb3442     	eor	w2, w2, w11, ror #13
    1968: 2a110071     	orr	w17, w3, w17
    196c: 2a090143     	orr	w3, w10, w9
    1970: 4acf6421     	eor	w1, w1, w15, ror #25
    1974: 0b11018c     	add	w12, w12, w17
    1978: 0a090151     	and	w17, w10, w9
    197c: 0a030163     	and	w3, w11, w3
    1980: 4acb5842     	eor	w2, w2, w11, ror #22
    1984: 2a110071     	orr	w17, w3, w17
    1988: 0b10018c     	add	w12, w12, w16
    198c: 0b010190     	add	w16, w12, w1
    1990: 0b0e024e     	add	w14, w18, w14
    1994: 2a0a0172     	orr	w18, w11, w10
    1998: 0b110051     	add	w17, w2, w17
    199c: 0b08020c     	add	w12, w16, w8
    19a0: 0b100228     	add	w8, w17, w16
    19a4: 138c1991     	ror	w17, w12, #0x6
    19a8: 0a2c01a2     	bic	w2, w13, w12
    19ac: 13880901     	ror	w1, w8, #0x2
    19b0: 0a0c01e3     	and	w3, w15, w12
    19b4: 529d1430     	mov	w16, #0xe8a1            // =59553
    19b8: 4acc2e31     	eor	w17, w17, w12, ror #11
    19bc: 2a020062     	orr	w2, w3, w2
    19c0: 72b457f0     	movk	w16, #0xa2bf, lsl #16
    19c4: 4ac83421     	eor	w1, w1, w8, ror #13
    19c8: 0a0a0163     	and	w3, w11, w10
    19cc: 0a120112     	and	w18, w8, w18
    19d0: 0b0201ce     	add	w14, w14, w2
    19d4: 4acc6631     	eor	w17, w17, w12, ror #25
    19d8: 2a030252     	orr	w18, w18, w3
    19dc: 4ac85821     	eor	w1, w1, w8, ror #22
    19e0: 0b1001ce     	add	w14, w14, w16
    19e4: 528cc970     	mov	w16, #0x664b            // =26187
    19e8: 0b1101d1     	add	w17, w14, w17
    19ec: 72b50350     	movk	w16, #0xa81a, lsl #16
    19f0: 0b120032     	add	w18, w1, w18
    19f4: 0b09022e     	add	w14, w17, w9
    19f8: 0b110249     	add	w9, w18, w17
    19fc: 138e19c1     	ror	w1, w14, #0x6
    1a00: 0a0e0183     	and	w3, w12, w14
    1a04: 2954cbf1     	ldp	w17, w18, [sp, #0xa4]
    1a08: 13890922     	ror	w2, w9, #0x2
    1a0c: 4ace2c21     	eor	w1, w1, w14, ror #11
    1a10: 0b0d022d     	add	w13, w17, w13
    1a14: 0a2e01f1     	bic	w17, w15, w14
    1a18: 4ac93442     	eor	w2, w2, w9, ror #13
    1a1c: 2a110071     	orr	w17, w3, w17
    1a20: 2a0b0103     	orr	w3, w8, w11
    1a24: 4ace6421     	eor	w1, w1, w14, ror #25
    1a28: 0b1101ad     	add	w13, w13, w17
    1a2c: 0a0b0111     	and	w17, w8, w11
    1a30: 0a030123     	and	w3, w9, w3
    1a34: 4ac95842     	eor	w2, w2, w9, ror #22
    1a38: 2a110071     	orr	w17, w3, w17
    1a3c: 0b1001ad     	add	w13, w13, w16
    1a40: 0b0101b0     	add	w16, w13, w1
    1a44: 0b0f024f     	add	w15, w18, w15
    1a48: 2a080132     	orr	w18, w9, w8
    1a4c: 0b110051     	add	w17, w2, w17
    1a50: 0b0a020d     	add	w13, w16, w10
    1a54: 0b10022a     	add	w10, w17, w16
    1a58: 138d19b1     	ror	w17, w13, #0x6
    1a5c: 0a2d0182     	bic	w2, w12, w13
    1a60: 138a0941     	ror	w1, w10, #0x2
    1a64: 0a0d01c3     	and	w3, w14, w13
    1a68: 52916e10     	mov	w16, #0x8b70            // =35696
    1a6c: 4acd2e31     	eor	w17, w17, w13, ror #11
    1a70: 2a020062     	orr	w2, w3, w2
    1a74: 72b84970     	movk	w16, #0xc24b, lsl #16
    1a78: 4aca3421     	eor	w1, w1, w10, ror #13
    1a7c: 0a080123     	and	w3, w9, w8
    1a80: 0a120152     	and	w18, w10, w18
    1a84: 0b0201ef     	add	w15, w15, w2
    1a88: 4acd6631     	eor	w17, w17, w13, ror #25
    1a8c: 2a030252     	orr	w18, w18, w3
    1a90: 4aca5821     	eor	w1, w1, w10, ror #22
    1a94: 0b1001ef     	add	w15, w15, w16
    1a98: 528a3470     	mov	w16, #0x51a3            // =20899
    1a9c: 0b1101f1     	add	w17, w15, w17
    1aa0: 72b8ed90     	movk	w16, #0xc76c, lsl #16
    1aa4: 0b120032     	add	w18, w1, w18
    1aa8: 0b0b022f     	add	w15, w17, w11
    1aac: 0b11024b     	add	w11, w18, w17
    1ab0: 138f19e1     	ror	w1, w15, #0x6
    1ab4: 0a0f01a3     	and	w3, w13, w15
    1ab8: 2955cbf1     	ldp	w17, w18, [sp, #0xac]
    1abc: 138b0962     	ror	w2, w11, #0x2
    1ac0: 4acf2c21     	eor	w1, w1, w15, ror #11
    1ac4: 0b0c022c     	add	w12, w17, w12
    1ac8: 0a2f01d1     	bic	w17, w14, w15
    1acc: 4acb3442     	eor	w2, w2, w11, ror #13
    1ad0: 2a110071     	orr	w17, w3, w17
    1ad4: 2a090143     	orr	w3, w10, w9
    1ad8: 4acf6421     	eor	w1, w1, w15, ror #25
    1adc: 0b11018c     	add	w12, w12, w17
    1ae0: 0a090151     	and	w17, w10, w9
    1ae4: 0a030163     	and	w3, w11, w3
    1ae8: 4acb5842     	eor	w2, w2, w11, ror #22
    1aec: 2a110071     	orr	w17, w3, w17
    1af0: 0b10018c     	add	w12, w12, w16
    1af4: 0b010190     	add	w16, w12, w1
    1af8: 0b0e024e     	add	w14, w18, w14
    1afc: 2a0a0172     	orr	w18, w11, w10
    1b00: 0b110051     	add	w17, w2, w17
    1b04: 0b08020c     	add	w12, w16, w8
    1b08: 0b100228     	add	w8, w17, w16
    1b0c: 138c1991     	ror	w17, w12, #0x6
    1b10: 0a2c01a2     	bic	w2, w13, w12
    1b14: 13880901     	ror	w1, w8, #0x2
    1b18: 0a0c01e3     	and	w3, w15, w12
    1b1c: 529d0330     	mov	w16, #0xe819            // =59417
    1b20: 4acc2e31     	eor	w17, w17, w12, ror #11
    1b24: 2a020062     	orr	w2, w3, w2
    1b28: 72ba3250     	movk	w16, #0xd192, lsl #16
    1b2c: 4ac83421     	eor	w1, w1, w8, ror #13
    1b30: 0a0a0163     	and	w3, w11, w10
    1b34: 0a120112     	and	w18, w8, w18
    1b38: 0b0201ce     	add	w14, w14, w2
    1b3c: 4acc6631     	eor	w17, w17, w12, ror #25
    1b40: 2a030252     	orr	w18, w18, w3
    1b44: 4ac85821     	eor	w1, w1, w8, ror #22
    1b48: 0b1001ce     	add	w14, w14, w16
    1b4c: 5280c490     	mov	w16, #0x624             // =1572
    1b50: 0b1101d1     	add	w17, w14, w17
    1b54: 72bad330     	movk	w16, #0xd699, lsl #16
    1b58: 0b120032     	add	w18, w1, w18
    1b5c: 0b09022e     	add	w14, w17, w9
    1b60: 0b110249     	add	w9, w18, w17
    1b64: 138e19c1     	ror	w1, w14, #0x6
    1b68: 0a0e0183     	and	w3, w12, w14
    1b6c: 2956cbf1     	ldp	w17, w18, [sp, #0xb4]
    1b70: 13890922     	ror	w2, w9, #0x2
    1b74: 4ace2c21     	eor	w1, w1, w14, ror #11
    1b78: 0b0d022d     	add	w13, w17, w13
    1b7c: 0a2e01f1     	bic	w17, w15, w14
    1b80: 4ac93442     	eor	w2, w2, w9, ror #13
    1b84: 2a110071     	orr	w17, w3, w17
    1b88: 2a0b0103     	orr	w3, w8, w11
    1b8c: 4ace6421     	eor	w1, w1, w14, ror #25
    1b90: 0b1101ad     	add	w13, w13, w17
    1b94: 0a0b0111     	and	w17, w8, w11
    1b98: 0a030123     	and	w3, w9, w3
    1b9c: 4ac95842     	eor	w2, w2, w9, ror #22
    1ba0: 2a110071     	orr	w17, w3, w17
    1ba4: 0b1001ad     	add	w13, w13, w16
    1ba8: 0b0101b0     	add	w16, w13, w1
    1bac: 0b0f024f     	add	w15, w18, w15
    1bb0: 2a080132     	orr	w18, w9, w8
    1bb4: 0b110051     	add	w17, w2, w17
    1bb8: 0b0a020d     	add	w13, w16, w10
    1bbc: 0b10022a     	add	w10, w17, w16
    1bc0: 138d19b1     	ror	w17, w13, #0x6
    1bc4: 0a2d0182     	bic	w2, w12, w13
    1bc8: 138a0941     	ror	w1, w10, #0x2
    1bcc: 0a0d01c3     	and	w3, w14, w13
    1bd0: 5286b0b0     	mov	w16, #0x3585            // =13701
    1bd4: 4acd2e31     	eor	w17, w17, w13, ror #11
    1bd8: 2a020062     	orr	w2, w3, w2
    1bdc: 72be81d0     	movk	w16, #0xf40e, lsl #16
    1be0: 4aca3421     	eor	w1, w1, w10, ror #13
    1be4: 0a080123     	and	w3, w9, w8
    1be8: 0a120152     	and	w18, w10, w18
    1bec: 0b0201ef     	add	w15, w15, w2
    1bf0: 4acd6631     	eor	w17, w17, w13, ror #25
    1bf4: 2a030252     	orr	w18, w18, w3
    1bf8: 4aca5821     	eor	w1, w1, w10, ror #22
    1bfc: 0b1001ef     	add	w15, w15, w16
    1c00: 52940e10     	mov	w16, #0xa070            // =41072
    1c04: 0b1101f1     	add	w17, w15, w17
    1c08: 72a20d50     	movk	w16, #0x106a, lsl #16
    1c0c: 0b120032     	add	w18, w1, w18
    1c10: 0b0b022f     	add	w15, w17, w11
    1c14: 0b11024b     	add	w11, w18, w17
    1c18: 138f19e1     	ror	w1, w15, #0x6
    1c1c: 0a0f01a3     	and	w3, w13, w15
    1c20: 2957cbf1     	ldp	w17, w18, [sp, #0xbc]
    1c24: 138b0962     	ror	w2, w11, #0x2
    1c28: 4acf2c21     	eor	w1, w1, w15, ror #11
    1c2c: 0b0c022c     	add	w12, w17, w12
    1c30: 0a2f01d1     	bic	w17, w14, w15
    1c34: 4acb3442     	eor	w2, w2, w11, ror #13
    1c38: 2a110071     	orr	w17, w3, w17
    1c3c: 2a090143     	orr	w3, w10, w9
    1c40: 4acf6421     	eor	w1, w1, w15, ror #25
    1c44: 0b11018c     	add	w12, w12, w17
    1c48: 0a090151     	and	w17, w10, w9
    1c4c: 0a030163     	and	w3, w11, w3
    1c50: 4acb5842     	eor	w2, w2, w11, ror #22
    1c54: 2a110071     	orr	w17, w3, w17
    1c58: 0b10018c     	add	w12, w12, w16
    1c5c: 0b010190     	add	w16, w12, w1
    1c60: 0b0e024e     	add	w14, w18, w14
    1c64: 2a0a0172     	orr	w18, w11, w10
    1c68: 0b110051     	add	w17, w2, w17
    1c6c: 0b08020c     	add	w12, w16, w8
    1c70: 0b100228     	add	w8, w17, w16
    1c74: 138c1991     	ror	w17, w12, #0x6
    1c78: 0a2c01a2     	bic	w2, w13, w12
    1c7c: 13880901     	ror	w1, w8, #0x2
    1c80: 0a0c01e3     	and	w3, w15, w12
    1c84: 529822d0     	mov	w16, #0xc116            // =49430
    1c88: 4acc2e31     	eor	w17, w17, w12, ror #11
    1c8c: 2a020062     	orr	w2, w3, w2
    1c90: 72a33490     	movk	w16, #0x19a4, lsl #16
    1c94: 4ac83421     	eor	w1, w1, w8, ror #13
    1c98: 0a0a0163     	and	w3, w11, w10
    1c9c: 0a120112     	and	w18, w8, w18
    1ca0: 0b0201ce     	add	w14, w14, w2
    1ca4: 4acc6631     	eor	w17, w17, w12, ror #25
    1ca8: 2a030252     	orr	w18, w18, w3
    1cac: 4ac85821     	eor	w1, w1, w8, ror #22
    1cb0: 0b1001ce     	add	w14, w14, w16
    1cb4: 528d8110     	mov	w16, #0x6c08            // =27656
    1cb8: 0b1101d1     	add	w17, w14, w17
    1cbc: 72a3c6f0     	movk	w16, #0x1e37, lsl #16
    1cc0: 0b120032     	add	w18, w1, w18
    1cc4: 0b09022e     	add	w14, w17, w9
    1cc8: 0b110249     	add	w9, w18, w17
    1ccc: 138e19c1     	ror	w1, w14, #0x6
    1cd0: 0a0e0183     	and	w3, w12, w14
    1cd4: 2958cbf1     	ldp	w17, w18, [sp, #0xc4]
    1cd8: 13890922     	ror	w2, w9, #0x2
    1cdc: 4ace2c21     	eor	w1, w1, w14, ror #11
    1ce0: 0b0d022d     	add	w13, w17, w13
    1ce4: 0a2e01f1     	bic	w17, w15, w14
    1ce8: 4ac93442     	eor	w2, w2, w9, ror #13
    1cec: 2a110071     	orr	w17, w3, w17
    1cf0: 2a0b0103     	orr	w3, w8, w11
    1cf4: 4ace6421     	eor	w1, w1, w14, ror #25
    1cf8: 0b1101ad     	add	w13, w13, w17
    1cfc: 0a0b0111     	and	w17, w8, w11
    1d00: 0a030123     	and	w3, w9, w3
    1d04: 4ac95842     	eor	w2, w2, w9, ror #22
    1d08: 2a110071     	orr	w17, w3, w17
    1d0c: 0b1001ad     	add	w13, w13, w16
    1d10: 0b0101b0     	add	w16, w13, w1
    1d14: 0b0f024f     	add	w15, w18, w15
    1d18: 2a080132     	orr	w18, w9, w8
    1d1c: 0b110051     	add	w17, w2, w17
    1d20: 0b0a020d     	add	w13, w16, w10
    1d24: 0b10022a     	add	w10, w17, w16
    1d28: 138d19b1     	ror	w17, w13, #0x6
    1d2c: 0a2d0182     	bic	w2, w12, w13
    1d30: 138a0941     	ror	w1, w10, #0x2
    1d34: 0a0d01c3     	and	w3, w14, w13
    1d38: 528ee990     	mov	w16, #0x774c            // =30540
    1d3c: 4acd2e31     	eor	w17, w17, w13, ror #11
    1d40: 2a020062     	orr	w2, w3, w2
    1d44: 72a4e910     	movk	w16, #0x2748, lsl #16
    1d48: 4aca3421     	eor	w1, w1, w10, ror #13
    1d4c: 0a080123     	and	w3, w9, w8
    1d50: 0a120152     	and	w18, w10, w18
    1d54: 0b0201ef     	add	w15, w15, w2
    1d58: 4acd6631     	eor	w17, w17, w13, ror #25
    1d5c: 2a030252     	orr	w18, w18, w3
    1d60: 4aca5821     	eor	w1, w1, w10, ror #22
    1d64: 0b1001ef     	add	w15, w15, w16
    1d68: 529796b0     	mov	w16, #0xbcb5            // =48309
    1d6c: 0b1101f1     	add	w17, w15, w17
    1d70: 72a69610     	movk	w16, #0x34b0, lsl #16
    1d74: 0b120032     	add	w18, w1, w18
    1d78: 0b0b022f     	add	w15, w17, w11
    1d7c: 0b11024b     	add	w11, w18, w17
    1d80: 138f19e1     	ror	w1, w15, #0x6
    1d84: 0a0f01a3     	and	w3, w13, w15
    1d88: 2959cbf1     	ldp	w17, w18, [sp, #0xcc]
    1d8c: 138b0962     	ror	w2, w11, #0x2
    1d90: 4acf2c21     	eor	w1, w1, w15, ror #11
    1d94: 0b0c022c     	add	w12, w17, w12
    1d98: 0a2f01d1     	bic	w17, w14, w15
    1d9c: 4acb3442     	eor	w2, w2, w11, ror #13
    1da0: 2a110071     	orr	w17, w3, w17
    1da4: 2a090143     	orr	w3, w10, w9
    1da8: 4acf6421     	eor	w1, w1, w15, ror #25
    1dac: 0b11018c     	add	w12, w12, w17
    1db0: 0a090151     	and	w17, w10, w9
    1db4: 0a030163     	and	w3, w11, w3
    1db8: 4acb5842     	eor	w2, w2, w11, ror #22
    1dbc: 2a110071     	orr	w17, w3, w17
    1dc0: 0b10018c     	add	w12, w12, w16
    1dc4: 0b010190     	add	w16, w12, w1
    1dc8: 0b0e024e     	add	w14, w18, w14
    1dcc: 2a0a0172     	orr	w18, w11, w10
    1dd0: 0b110051     	add	w17, w2, w17
    1dd4: 0b08020c     	add	w12, w16, w8
    1dd8: 0b100228     	add	w8, w17, w16
    1ddc: 138c1991     	ror	w17, w12, #0x6
    1de0: 0a2c01a2     	bic	w2, w13, w12
    1de4: 13880901     	ror	w1, w8, #0x2
    1de8: 0a0c01e3     	and	w3, w15, w12
    1dec: 52819670     	mov	w16, #0xcb3             // =3251
    1df0: 4acc2e31     	eor	w17, w17, w12, ror #11
    1df4: 2a020062     	orr	w2, w3, w2
    1df8: 72a72390     	movk	w16, #0x391c, lsl #16
    1dfc: 4ac83421     	eor	w1, w1, w8, ror #13
    1e00: 0a0a0163     	and	w3, w11, w10
    1e04: 0a120112     	and	w18, w8, w18
    1e08: 0b0201ce     	add	w14, w14, w2
    1e0c: 4acc6631     	eor	w17, w17, w12, ror #25
    1e10: 2a030252     	orr	w18, w18, w3
    1e14: 4ac85821     	eor	w1, w1, w8, ror #22
    1e18: 0b1001ce     	add	w14, w14, w16
    1e1c: 52954942     	mov	w2, #0xaa4a             // =43594
    1e20: 0b1101ce     	add	w14, w14, w17
    1e24: 72a9db02     	movk	w2, #0x4ed8, lsl #16
    1e28: 0b120031     	add	w17, w1, w18
    1e2c: 0b0901d0     	add	w16, w14, w9
    1e30: 0b0e0229     	add	w9, w17, w14
    1e34: 13901a12     	ror	w18, w16, #0x6
    1e38: 0a100183     	and	w3, w12, w16
    1e3c: 295ac7ee     	ldp	w14, w17, [sp, #0xd4]
    1e40: 13890921     	ror	w1, w9, #0x2
    1e44: 4ad02e52     	eor	w18, w18, w16, ror #11
    1e48: 0b0d01cd     	add	w13, w14, w13
    1e4c: 0a3001ee     	bic	w14, w15, w16
    1e50: 4ac93421     	eor	w1, w1, w9, ror #13
    1e54: 2a0e006e     	orr	w14, w3, w14
    1e58: 2a0b0103     	orr	w3, w8, w11
    1e5c: 4ad06652     	eor	w18, w18, w16, ror #25
    1e60: 0b0e01ad     	add	w13, w13, w14
    1e64: 0a0b010e     	and	w14, w8, w11
    1e68: 0a030123     	and	w3, w9, w3
    1e6c: 4ac95821     	eor	w1, w1, w9, ror #22
    1e70: 2a0e006e     	orr	w14, w3, w14
    1e74: 0b0201ad     	add	w13, w13, w2
    1e78: 0b1201b2     	add	w18, w13, w18
    1e7c: 0b0f022f     	add	w15, w17, w15
    1e80: 2a080131     	orr	w17, w9, w8
    1e84: 0b0e002e     	add	w14, w1, w14
    1e88: 0b0a024d     	add	w13, w18, w10
    1e8c: 0b1201ca     	add	w10, w14, w18
    1e90: 138d19b2     	ror	w18, w13, #0x6
    1e94: 0a2d0182     	bic	w2, w12, w13
    1e98: 138a0941     	ror	w1, w10, #0x2
    1e9c: 0a0d0203     	and	w3, w16, w13
    1ea0: 529949ee     	mov	w14, #0xca4f            // =51791
    1ea4: 4acd2e52     	eor	w18, w18, w13, ror #11
    1ea8: 2a020062     	orr	w2, w3, w2
    1eac: 72ab738e     	movk	w14, #0x5b9c, lsl #16
    1eb0: 4aca3421     	eor	w1, w1, w10, ror #13
    1eb4: 0a080123     	and	w3, w9, w8
    1eb8: 0a110151     	and	w17, w10, w17
    1ebc: 0b0201ef     	add	w15, w15, w2
    1ec0: 4acd6652     	eor	w18, w18, w13, ror #25
    1ec4: 2a030231     	orr	w17, w17, w3
    1ec8: 4aca5821     	eor	w1, w1, w10, ror #22
    1ecc: 0b0e01ee     	add	w14, w15, w14
    1ed0: 528dfe62     	mov	w2, #0x6ff3             // =28659
    1ed4: 0b1201ce     	add	w14, w14, w18
    1ed8: 72ad05c2     	movk	w2, #0x682e, lsl #16
    1edc: 0b110031     	add	w17, w1, w17
    1ee0: 0b0b01cf     	add	w15, w14, w11
    1ee4: 0b0e022b     	add	w11, w17, w14
    1ee8: 138f19f2     	ror	w18, w15, #0x6
    1eec: 0a0f01a3     	and	w3, w13, w15
    1ef0: 295bc7ee     	ldp	w14, w17, [sp, #0xdc]
    1ef4: 138b0961     	ror	w1, w11, #0x2
    1ef8: 4acf2e52     	eor	w18, w18, w15, ror #11
    1efc: 0b0c01cc     	add	w12, w14, w12
    1f00: 0a2f020e     	bic	w14, w16, w15
    1f04: 4acb3421     	eor	w1, w1, w11, ror #13
    1f08: 2a0e006e     	orr	w14, w3, w14
    1f0c: 2a090143     	orr	w3, w10, w9
    1f10: 4acf6652     	eor	w18, w18, w15, ror #25
    1f14: 0b0e018c     	add	w12, w12, w14
    1f18: 0a09014e     	and	w14, w10, w9
    1f1c: 0a030163     	and	w3, w11, w3
    1f20: 4acb5821     	eor	w1, w1, w11, ror #22
    1f24: 2a0e006e     	orr	w14, w3, w14
    1f28: 0b02018c     	add	w12, w12, w2
    1f2c: 0b12018c     	add	w12, w12, w18
    1f30: 0b100230     	add	w16, w17, w16
    1f34: 2a0a0171     	orr	w17, w11, w10
    1f38: 0b0e0032     	add	w18, w1, w14
    1f3c: 0b08018e     	add	w14, w12, w8
    1f40: 52905dc8     	mov	w8, #0x82ee             // =33518
    1f44: 0b0c024c     	add	w12, w18, w12
    1f48: 138e19d2     	ror	w18, w14, #0x6
    1f4c: 0a2e01a2     	bic	w2, w13, w14
    1f50: 138c0981     	ror	w1, w12, #0x2
    1f54: 0a0e01e3     	and	w3, w15, w14
    1f58: 72ae91e8     	movk	w8, #0x748f, lsl #16
    1f5c: 4ace2e52     	eor	w18, w18, w14, ror #11
    1f60: 2a020062     	orr	w2, w3, w2
    1f64: 0a0a0163     	and	w3, w11, w10
    1f68: 4acc3421     	eor	w1, w1, w12, ror #13
    1f6c: 0a110191     	and	w17, w12, w17
    1f70: 0b020210     	add	w16, w16, w2
    1f74: 4ace6652     	eor	w18, w18, w14, ror #25
    1f78: 2a030231     	orr	w17, w17, w3
    1f7c: 0b080208     	add	w8, w16, w8
    1f80: 4acc5821     	eor	w1, w1, w12, ror #22
    1f84: 528c6de2     	mov	w2, #0x636f             // =25455
    1f88: 0b120108     	add	w8, w8, w18
    1f8c: 72af14a2     	movk	w2, #0x78a5, lsl #16
    1f90: 0b110031     	add	w17, w1, w17
    1f94: 0b090110     	add	w16, w8, w9
    1f98: 0b080229     	add	w9, w17, w8
    1f9c: 13901a12     	ror	w18, w16, #0x6
    1fa0: 0a1001c3     	and	w3, w14, w16
    1fa4: 295cc7e8     	ldp	w8, w17, [sp, #0xe4]
    1fa8: 13890921     	ror	w1, w9, #0x2
    1fac: 4ad02e52     	eor	w18, w18, w16, ror #11
    1fb0: 0b0d0108     	add	w8, w8, w13
    1fb4: 0a3001ed     	bic	w13, w15, w16
    1fb8: 4ac93421     	eor	w1, w1, w9, ror #13
    1fbc: 2a0d006d     	orr	w13, w3, w13
    1fc0: 2a0b0183     	orr	w3, w12, w11
    1fc4: 4ad06652     	eor	w18, w18, w16, ror #25
    1fc8: 0b0d0108     	add	w8, w8, w13
    1fcc: 0a0b018d     	and	w13, w12, w11
    1fd0: 0a030123     	and	w3, w9, w3
    1fd4: 4ac95821     	eor	w1, w1, w9, ror #22
    1fd8: 2a0d006d     	orr	w13, w3, w13
    1fdc: 0b020108     	add	w8, w8, w2
    1fe0: 0b120108     	add	w8, w8, w18
    1fe4: 0b0f022f     	add	w15, w17, w15
    1fe8: 2a0c0131     	orr	w17, w9, w12
    1fec: 0b0d0032     	add	w18, w1, w13
    1ff0: 0b0a010d     	add	w13, w8, w10
    1ff4: 528f028a     	mov	w10, #0x7814            // =30740
    1ff8: 0b080248     	add	w8, w18, w8
    1ffc: 138d19b2     	ror	w18, w13, #0x6
    2000: 0a2d01c2     	bic	w2, w14, w13
    2004: 13880901     	ror	w1, w8, #0x2
    2008: 0a0d0203     	and	w3, w16, w13
    200c: 72b0990a     	movk	w10, #0x84c8, lsl #16
    2010: 4acd2e52     	eor	w18, w18, w13, ror #11
    2014: 2a020062     	orr	w2, w3, w2
    2018: 0a0c0123     	and	w3, w9, w12
    201c: 4ac83421     	eor	w1, w1, w8, ror #13
    2020: 0a110111     	and	w17, w8, w17
    2024: 0b0201ef     	add	w15, w15, w2
    2028: 4acd6652     	eor	w18, w18, w13, ror #25
    202c: 2a030231     	orr	w17, w17, w3
    2030: 0b0a01ea     	add	w10, w15, w10
    2034: 4ac85821     	eor	w1, w1, w8, ror #22
    2038: 52804102     	mov	w2, #0x208              // =520
    203c: 0b12014a     	add	w10, w10, w18
    2040: 72b198e2     	movk	w2, #0x8cc7, lsl #16
    2044: 0b110031     	add	w17, w1, w17
    2048: 0b0b014f     	add	w15, w10, w11
    204c: 0b0a022a     	add	w10, w17, w10
    2050: 138f19f2     	ror	w18, w15, #0x6
    2054: 0a0f01a3     	and	w3, w13, w15
    2058: 295dc7eb     	ldp	w11, w17, [sp, #0xec]
    205c: 138a0941     	ror	w1, w10, #0x2
    2060: 4acf2e52     	eor	w18, w18, w15, ror #11
    2064: 0b0e016b     	add	w11, w11, w14
    2068: 0a2f020e     	bic	w14, w16, w15
    206c: 4aca3421     	eor	w1, w1, w10, ror #13
    2070: 2a0e006e     	orr	w14, w3, w14
    2074: 2a090103     	orr	w3, w8, w9
    2078: 4acf6652     	eor	w18, w18, w15, ror #25
    207c: 0b0e016b     	add	w11, w11, w14
    2080: 0a09010e     	and	w14, w8, w9
    2084: 0a030143     	and	w3, w10, w3
    2088: 4aca5821     	eor	w1, w1, w10, ror #22
    208c: 2a0e006e     	orr	w14, w3, w14
    2090: 0b02016b     	add	w11, w11, w2
    2094: 0b12016b     	add	w11, w11, w18
    2098: 0b100230     	add	w16, w17, w16
    209c: 2a080151     	orr	w17, w10, w8
    20a0: 0b0e002e     	add	w14, w1, w14
    20a4: 0b0c016c     	add	w12, w11, w12
    20a8: 0b0b01cb     	add	w11, w14, w11
    20ac: 138c1992     	ror	w18, w12, #0x6
    20b0: 0a2c01a2     	bic	w2, w13, w12
    20b4: 138b0961     	ror	w1, w11, #0x2
    20b8: 0a0c01e3     	and	w3, w15, w12
    20bc: 529fff4e     	mov	w14, #0xfffa            // =65530
    20c0: 4acc2e52     	eor	w18, w18, w12, ror #11
    20c4: 2a020062     	orr	w2, w3, w2
    20c8: 72b217ce     	movk	w14, #0x90be, lsl #16
    20cc: 4acb3421     	eor	w1, w1, w11, ror #13
    20d0: 0a080143     	and	w3, w10, w8
    20d4: 0a110171     	and	w17, w11, w17
    20d8: 0b020210     	add	w16, w16, w2
    20dc: 4acc6652     	eor	w18, w18, w12, ror #25
    20e0: 2a030231     	orr	w17, w17, w3
    20e4: 4acb5821     	eor	w1, w1, w11, ror #22
    20e8: 0b0e020e     	add	w14, w16, w14
    20ec: 0b1201ce     	add	w14, w14, w18
    20f0: 0b110031     	add	w17, w1, w17
    20f4: 0b0901c9     	add	w9, w14, w9
    20f8: 295ec3f2     	ldp	w18, w16, [sp, #0xf4]
    20fc: 0b0e022e     	add	w14, w17, w14
    2100: 13891921     	ror	w1, w9, #0x6
    2104: 0a090183     	and	w3, w12, w9
    2108: 138e09c2     	ror	w2, w14, #0x2
    210c: 528d9d71     	mov	w17, #0x6ceb            // =27883
    2110: 0b0d024d     	add	w13, w18, w13
    2114: 0a2901f2     	bic	w18, w15, w9
    2118: 4ac92c21     	eor	w1, w1, w9, ror #11
    211c: 4ace3442     	eor	w2, w2, w14, ror #13
    2120: 2a120072     	orr	w18, w3, w18
    2124: 2a0a0163     	orr	w3, w11, w10
    2128: 72b48a11     	movk	w17, #0xa450, lsl #16
    212c: 0b1201ad     	add	w13, w13, w18
    2130: 0a0a0172     	and	w18, w11, w10
    2134: 0a0301c3     	and	w3, w14, w3
    2138: 4ac96421     	eor	w1, w1, w9, ror #25
    213c: 4ace5842     	eor	w2, w2, w14, ror #22
    2140: 2a120072     	orr	w18, w3, w18
    2144: 0b1101ad     	add	w13, w13, w17
    2148: 0b0f020f     	add	w15, w16, w15
    214c: 0b0101ad     	add	w13, w13, w1
    2150: 0b120051     	add	w17, w2, w18
    2154: 0b0801a8     	add	w8, w13, w8
    2158: 0b0d022d     	add	w13, w17, w13
    215c: 52947ef1     	mov	w17, #0xa3f7            // =41975
    2160: 13881912     	ror	w18, w8, #0x6
    2164: 138d09a1     	ror	w1, w13, #0x2
    2168: 0a280190     	bic	w16, w12, w8
    216c: 0a080122     	and	w2, w9, w8
    2170: 72b7df31     	movk	w17, #0xbef9, lsl #16
    2174: 4ac82e52     	eor	w18, w18, w8, ror #11
    2178: 4acd3421     	eor	w1, w1, w13, ror #13
    217c: 2a100050     	orr	w16, w2, w16
    2180: 2a0b01c2     	orr	w2, w14, w11
    2184: 0b1001ef     	add	w15, w15, w16
    2188: 0a0b01d0     	and	w16, w14, w11
    218c: 0a0201a2     	and	w2, w13, w2
    2190: 4ac86652     	eor	w18, w18, w8, ror #25
    2194: 4acd5821     	eor	w1, w1, w13, ror #22
    2198: 2a100050     	orr	w16, w2, w16
    219c: 0b1101ef     	add	w15, w15, w17
    21a0: b940fff1     	ldr	w17, [sp, #0xfc]
    21a4: 0b1201ef     	add	w15, w15, w18
    21a8: 0b100030     	add	w16, w1, w16
    21ac: 0b0a01ea     	add	w10, w15, w10
    21b0: 0b0f020f     	add	w15, w16, w15
    21b4: 0b0c022c     	add	w12, w17, w12
    21b8: 138a1952     	ror	w18, w10, #0x6
    21bc: 138f09e1     	ror	w1, w15, #0x2
    21c0: 0a2a0131     	bic	w17, w9, w10
    21c4: 0a0a0102     	and	w2, w8, w10
    21c8: 528f1e50     	mov	w16, #0x78f2            // =30962
    21cc: 4aca2e52     	eor	w18, w18, w10, ror #11
    21d0: 4acf3421     	eor	w1, w1, w15, ror #13
    21d4: 2a110051     	orr	w17, w2, w17
    21d8: 2a0e01a2     	orr	w2, w13, w14
    21dc: 72b8ce30     	movk	w16, #0xc671, lsl #16
    21e0: 0b11018c     	add	w12, w12, w17
    21e4: 0a0e01b1     	and	w17, w13, w14
    21e8: 0a0201e2     	and	w2, w15, w2
    21ec: 4aca6652     	eor	w18, w18, w10, ror #25
    21f0: 4acf5821     	eor	w1, w1, w15, ror #22
    21f4: 2a110051     	orr	w17, w2, w17
    21f8: 0b10018c     	add	w12, w12, w16
    21fc: 0b12018c     	add	w12, w12, w18
    2200: 0b110030     	add	w16, w1, w17
    2204: 0b0b018b     	add	w11, w12, w11
    2208: 0b0c0210     	add	w16, w16, w12
    220c: 1e270161     	fmov	s1, w11
    2210: 1e270200     	fmov	s0, w16
    2214: 4e0c1d41     	mov	v1.s[1], w10
    2218: 4e0c1de0     	mov	v0.s[1], w15
    221c: 4e141d01     	mov	v1.s[2], w8
    2220: 4e141da0     	mov	v0.s[2], w13
    2224: 4e1c1d21     	mov	v1.s[3], w9
    2228: 4e1c1dc0     	mov	v0.s[3], w14
    222c: 4ea18461     	add	v1.4s, v3.4s, v1.4s
    2230: 4ea08440     	add	v0.4s, v2.4s, v0.4s
    2234: ad000400     	stp	q0, q1, [x0]
    2238: 912403ff     	add	sp, sp, #0x900
    223c: a9434ff4     	ldp	x20, x19, [sp, #0x30]
    2240: f9400bf7     	ldr	x23, [sp, #0x10]
    2244: a94257f6     	ldp	x22, x21, [sp, #0x20]
    2248: a8c47bfd     	ldp	x29, x30, [sp], #0x40
    224c: d65f03c0     	ret

0000000000002250 <audit_master256>:
    2250: d105c3ff     	sub	sp, sp, #0x170
    2254: a9157bfd     	stp	x29, x30, [sp, #0x150]
    2258: a9164ffc     	stp	x28, x19, [sp, #0x160]
    225c: 910543fd     	add	x29, sp, #0x150
    2260: 52840008     	mov	w8, #0x2000             // =8192
    2264: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002264:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32+0x20
    2268: 91000129     	add	x9, x9, #0x0
		0000000000002268:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32+0x20
    226c: ad400520     	ldp	q0, q1, [x9]
    2270: 790083e8     	strh	w8, [sp, #0x40]
    2274: 528001a8     	mov	w8, #0xd                // =13
    2278: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002278:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
    227c: 91000129     	add	x9, x9, #0x0
		000000000000227c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
    2280: f940012a     	ldr	x10, [x9]
    2284: 39010be8     	strb	w8, [sp, #0x42]
    2288: f8405128     	ldur	x8, [x9, #0x5]
    228c: aa0103f3     	mov	x19, x1
    2290: aa0003e4     	mov	x4, x0
    2294: 910083e0     	add	x0, sp, #0x20
    2298: f80433ea     	stur	x10, [sp, #0x43]
    229c: 910103e2     	add	x2, sp, #0x40
    22a0: 52800401     	mov	w1, #0x20               // =32
    22a4: f90027e8     	str	x8, [sp, #0x48]
    22a8: 52800408     	mov	w8, #0x20               // =32
    22ac: 52800623     	mov	w3, #0x31               // =49
    22b0: 3c8513e0     	stur	q0, [sp, #0x51]
    22b4: 390143e8     	strb	w8, [sp, #0x50]
    22b8: 3c8613e1     	stur	q1, [sp, #0x61]
    22bc: 97fff7e6     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    22c0: 90000002     	adrp	x2, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		00000000000022c0:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32
    22c4: 91000042     	add	x2, x2, #0x0
		00000000000022c4:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32
    22c8: 910003e0     	mov	x0, sp
    22cc: 910083e1     	add	x1, sp, #0x20
    22d0: 97fff778     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    22d4: 6f00e400     	movi	v0.2d, #0000000000000000
    22d8: 3d800fe0     	str	q0, [sp, #0x30]
    22dc: 3d800be0     	str	q0, [sp, #0x20]
    22e0: ad4007e0     	ldp	q0, q1, [sp]
    22e4: ad000660     	stp	q0, q1, [x19]
    22e8: a9564ffc     	ldp	x28, x19, [sp, #0x160]
    22ec: a9557bfd     	ldp	x29, x30, [sp, #0x150]
    22f0: 9105c3ff     	add	sp, sp, #0x170
    22f4: d65f03c0     	ret

00000000000022f8 <audit_key256>:
    22f8: d104c3ff     	sub	sp, sp, #0x130
    22fc: a9117bfd     	stp	x29, x30, [sp, #0x110]
    2300: f90093fc     	str	x28, [sp, #0x120]
    2304: 910443fd     	add	x29, sp, #0x110
    2308: 52800129     	mov	w9, #0x9                // =9
    230c: 52820008     	mov	w8, #0x1000             // =4096
    2310: aa0003e4     	mov	x4, x0
    2314: 39001be9     	strb	w9, [sp, #0x6]
    2318: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002318:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x1c0
    231c: 91000129     	add	x9, x9, #0x0
		000000000000231c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x1c0
    2320: f9400129     	ldr	x9, [x9]
    2324: 79000be8     	strh	w8, [sp, #0x4]
    2328: 52800f28     	mov	w8, #0x79               // =121
    232c: 910013e2     	add	x2, sp, #0x4
    2330: aa0103e0     	mov	x0, x1
    2334: 52800201     	mov	w1, #0x10               // =16
    2338: 528001a3     	mov	w3, #0xd                // =13
    233c: 7800f3e8     	sturh	w8, [sp, #0xf]
    2340: f80073e9     	stur	x9, [sp, #0x7]
    2344: 97fff7c4     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    2348: a9517bfd     	ldp	x29, x30, [sp, #0x110]
    234c: f94093fc     	ldr	x28, [sp, #0x120]
    2350: 9104c3ff     	add	sp, sp, #0x130
    2354: d65f03c0     	ret

0000000000002358 <audit_handshake384>:
    2358: d10683ff     	sub	sp, sp, #0x1a0
    235c: a9177bfd     	stp	x29, x30, [sp, #0x170]
    2360: f900c3fc     	str	x28, [sp, #0x180]
    2364: a9194ff4     	stp	x20, x19, [sp, #0x190]
    2368: 9105c3fd     	add	x29, sp, #0x170
    236c: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		000000000000236c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x70
    2370: 91000108     	add	x8, x8, #0x0
		0000000000002370:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x70
    2374: 52860009     	mov	w9, #0x3000             // =12288
    2378: ad400500     	ldp	q0, q1, [x8]
    237c: 7900c3e9     	strh	w9, [sp, #0x60]
    2380: 528001a9     	mov	w9, #0xd                // =13
    2384: 9000000a     	adrp	x10, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002384:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
    2388: 9100014a     	add	x10, x10, #0x0
		0000000000002388:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
    238c: f940014b     	ldr	x11, [x10]
    2390: 39018be9     	strb	w9, [sp, #0x62]
    2394: f8405149     	ldur	x9, [x10, #0x5]
    2398: 3c8713e0     	stur	q0, [sp, #0x71]
    239c: 3dc00900     	ldr	q0, [x8, #0x20]
    23a0: aa0203f3     	mov	x19, x2
    23a4: aa0103f4     	mov	x20, x1
    23a8: aa0003e4     	mov	x4, x0
    23ac: f80633eb     	stur	x11, [sp, #0x63]
    23b0: 910183ea     	add	x10, sp, #0x60
    23b4: f90037e9     	str	x9, [sp, #0x68]
    23b8: 52800609     	mov	w9, #0x30               // =48
    23bc: 9100c3e0     	add	x0, sp, #0x30
    23c0: 910183e2     	add	x2, sp, #0x60
    23c4: 52800601     	mov	w1, #0x30               // =48
    23c8: 52800823     	mov	w3, #0x41               // =65
    23cc: 3c821141     	stur	q1, [x10, #0x21]
    23d0: 3901c3e9     	strb	w9, [sp, #0x70]
    23d4: 3c831140     	stur	q0, [x10, #0x31]
    23d8: 940000b6     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    23dc: 910003e0     	mov	x0, sp
    23e0: 9100c3e1     	add	x1, sp, #0x30
    23e4: aa1403e2     	mov	x2, x20
    23e8: 9400000e     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    23ec: 6f00e400     	movi	v0.2d, #0000000000000000
    23f0: 3d8017e0     	str	q0, [sp, #0x50]
    23f4: 3d8013e0     	str	q0, [sp, #0x40]
    23f8: 3d800fe0     	str	q0, [sp, #0x30]
    23fc: ad4007e0     	ldp	q0, q1, [sp]
    2400: 3dc00be2     	ldr	q2, [sp, #0x20]
    2404: ad000660     	stp	q0, q1, [x19]
    2408: 3d800a62     	str	q2, [x19, #0x20]
    240c: a9594ff4     	ldp	x20, x19, [sp, #0x190]
    2410: f940c3fc     	ldr	x28, [sp, #0x180]
    2414: a9577bfd     	ldp	x29, x30, [sp, #0x170]
    2418: 910683ff     	add	sp, sp, #0x1a0
    241c: d65f03c0     	ret

0000000000002420 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2420: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    2424: f9000bfc     	str	x28, [sp, #0x10]
    2428: a90267fa     	stp	x26, x25, [sp, #0x20]
    242c: a9035ff8     	stp	x24, x23, [sp, #0x30]
    2430: a90457f6     	stp	x22, x21, [sp, #0x40]
    2434: a9054ff4     	stp	x20, x19, [sp, #0x50]
    2438: 910003fd     	mov	x29, sp
    243c: d10e03ff     	sub	sp, sp, #0x380
    2440: 4f02e780     	movi	v0.16b, #0x5c
    2444: 4f01e6c2     	movi	v2.16b, #0x36
    2448: 3dc00824     	ldr	q4, [x1, #0x20]
    244c: ad400c21     	ldp	q1, q3, [x1]
    2450: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002450:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xb0
    2454: 91000108     	add	x8, x8, #0x0
		0000000000002454:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xb0
    2458: aa0003f3     	mov	x19, x0
    245c: 910443e0     	add	x0, sp, #0x110
    2460: d10383a1     	sub	x1, x29, #0xe0
    2464: aa0203f4     	mov	x20, x2
    2468: 910443f7     	add	x23, sp, #0x110
    246c: 6e201c25     	eor	v5.16b, v1.16b, v0.16b
    2470: 6e201c66     	eor	v6.16b, v3.16b, v0.16b
    2474: 6e201c87     	eor	v7.16b, v4.16b, v0.16b
    2478: 6e221c21     	eor	v1.16b, v1.16b, v2.16b
    247c: 6e221c63     	eor	v3.16b, v3.16b, v2.16b
    2480: ad1183e0     	stp	q0, q0, [sp, #0x230]
    2484: ad1283e0     	stp	q0, q0, [sp, #0x250]
    2488: 6e221c84     	eor	v4.16b, v4.16b, v2.16b
    248c: d10383b8     	sub	x24, x29, #0xe0
    2490: ad3b0ba2     	stp	q2, q2, [x29, #-0xa0]
    2494: ad0f9be5     	stp	q5, q6, [sp, #0x1f0]
    2498: ad1083e7     	stp	q7, q0, [sp, #0x210]
    249c: ad390fa1     	stp	q1, q3, [x29, #-0xe0]
    24a0: ad450500     	ldp	q0, q1, [x8, #0xa0]
    24a4: ad3a0ba4     	stp	q4, q2, [x29, #-0xc0]
    24a8: ad3c0ba2     	stp	q2, q2, [x29, #-0x80]
    24ac: ad0603e1     	stp	q1, q0, [sp, #0xc0]
    24b0: ad0d87e0     	stp	q0, q1, [sp, #0x1b0]
    24b4: ad460102     	ldp	q2, q0, [x8, #0xc0]
    24b8: ad050be0     	stp	q0, q2, [sp, #0xa0]
    24bc: ad0e83e2     	stp	q2, q0, [sp, #0x1d0]
    24c0: ad430101     	ldp	q1, q0, [x8, #0x60]
    24c4: ad0407e0     	stp	q0, q1, [sp, #0x80]
    24c8: ad0b83e1     	stp	q1, q0, [sp, #0x170]
    24cc: ad440102     	ldp	q2, q0, [x8, #0x80]
    24d0: ad030be0     	stp	q0, q2, [sp, #0x60]
    24d4: ad0c83e2     	stp	q2, q0, [sp, #0x190]
    24d8: ad410101     	ldp	q1, q0, [x8, #0x20]
    24dc: ad0207e0     	stp	q0, q1, [sp, #0x40]
    24e0: ad0983e1     	stp	q1, q0, [sp, #0x130]
    24e4: ad420102     	ldp	q2, q0, [x8, #0x40]
    24e8: ad010be0     	stp	q0, q2, [sp, #0x20]
    24ec: ad0a83e2     	stp	q2, q0, [sp, #0x150]
    24f0: ad400101     	ldp	q1, q0, [x8]
    24f4: ad0007e0     	stp	q0, q1, [sp]
    24f8: ad0883e1     	stp	q1, q0, [sp, #0x110]
    24fc: 940002b0     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2500: a95127e8     	ldp	x8, x9, [sp, #0x110]
    2504: b1020119     	adds	x25, x8, #0x80
    2508: 394783e8     	ldrb	w8, [sp, #0x1e0]
    250c: 9a89353a     	cinc	x26, x9, hs
    2510: a9116bf9     	stp	x25, x26, [sp, #0x110]
    2514: 34000248     	cbz	w8,  <L1>
    2518: 7101411f     	cmp	w8, #0x50
    251c: 54000203     	b.lo	 <L1>
    2520: 52801009     	mov	w9, #0x80               // =128
    2524: 910443ea     	add	x10, sp, #0x110
    2528: aa1403e1     	mov	x1, x20
    252c: cb080135     	sub	x21, x9, x8
    2530: 91014156     	add	x22, x10, #0x50
    2534: 8b0802c0     	add	x0, x22, x8
    2538: aa1503e2     	mov	x2, x21
<L0>:
    253c: 94000000     	bl	 <L0>
		000000000000253c:  R_AARCH64_CALL26	memcpy
    2540: 910443e0     	add	x0, sp, #0x110
    2544: aa1603e1     	mov	x1, x22
    2548: 9400029d     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    254c: a9516bf9     	ldp	x25, x26, [sp, #0x110]
    2550: 2a1f03e8     	mov	w8, wzr
    2554: 390783ff     	strb	wzr, [sp, #0x1e0]
    2558: 14000002     	b	 <L2>
<L1>:
    255c: aa1f03f5     	mov	x21, xzr
<L2>:
    2560: 52800609     	mov	w9, #0x30               // =48
    2564: 8b2842e8     	add	x8, x23, w8, uxtw
    2568: 8b150281     	add	x1, x20, x21
    256c: cb150136     	sub	x22, x9, x21
    2570: 91014100     	add	x0, x8, #0x50
    2574: aa1603e2     	mov	x2, x22
<L3>:
    2578: 94000000     	bl	 <L3>
		0000000000002578:  R_AARCH64_CALL26	memcpy
    257c: 394783e8     	ldrb	w8, [sp, #0x1e0]
    2580: b100c329     	adds	x9, x25, #0x30
    2584: 910443e0     	add	x0, sp, #0x110
    2588: 9a9a374a     	cinc	x10, x26, hs
    258c: 9109c3e1     	add	x1, sp, #0x270
    2590: 0b160108     	add	w8, w8, w22
    2594: a9112be9     	stp	x9, x10, [sp, #0x110]
    2598: 9109c3f6     	add	x22, sp, #0x270
    259c: 390783e8     	strb	w8, [sp, #0x1e0]
    25a0: 9400022a     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    25a4: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    25a8: d10383a0     	sub	x0, x29, #0xe0
    25ac: 910382e1     	add	x1, x23, #0xe0
    25b0: 91014314     	add	x20, x24, #0x50
    25b4: ad3e03a1     	stp	q1, q0, [x29, #-0x40]
    25b8: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
    25bc: ad3f03a1     	stp	q1, q0, [x29, #-0x20]
    25c0: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    25c4: ad3c03a1     	stp	q1, q0, [x29, #-0x80]
    25c8: ad4307e0     	ldp	q0, q1, [sp, #0x60]
    25cc: ad3d03a1     	stp	q1, q0, [x29, #-0x60]
    25d0: ad4207e0     	ldp	q0, q1, [sp, #0x40]
    25d4: ad3a03a1     	stp	q1, q0, [x29, #-0xc0]
    25d8: ad4107e0     	ldp	q0, q1, [sp, #0x20]
    25dc: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
    25e0: ad4007e0     	ldp	q0, q1, [sp]
    25e4: ad3903a1     	stp	q1, q0, [x29, #-0xe0]
    25e8: 94000275     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    25ec: a9722ba9     	ldp	x9, x10, [x29, #-0xe0]
    25f0: 385f03a8     	ldurb	w8, [x29, #-0x10]
    25f4: b1020138     	adds	x24, x9, #0x80
    25f8: 9a8a3557     	cinc	x23, x10, hs
    25fc: a9325fb8     	stp	x24, x23, [x29, #-0xe0]
    2600: 34000208     	cbz	w8,  <L5>
    2604: 7101411f     	cmp	w8, #0x50
    2608: 540001c3     	b.lo	 <L5>
    260c: 52801009     	mov	w9, #0x80               // =128
    2610: 8b080280     	add	x0, x20, x8
    2614: 9109c3e1     	add	x1, sp, #0x270
    2618: cb080135     	sub	x21, x9, x8
    261c: aa1503e2     	mov	x2, x21
<L4>:
    2620: 94000000     	bl	 <L4>
		0000000000002620:  R_AARCH64_CALL26	memcpy
    2624: d10383a0     	sub	x0, x29, #0xe0
    2628: aa1403e1     	mov	x1, x20
    262c: 94000264     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2630: a9725fb8     	ldp	x24, x23, [x29, #-0xe0]
    2634: 2a1f03e8     	mov	w8, wzr
    2638: 381f03bf     	sturb	wzr, [x29, #-0x10]
    263c: 14000002     	b	 <L6>
<L5>:
    2640: aa1f03f5     	mov	x21, xzr
<L6>:
    2644: 52800609     	mov	w9, #0x30               // =48
    2648: 8b284280     	add	x0, x20, w8, uxtw
    264c: 8b1502c1     	add	x1, x22, x21
    2650: cb150134     	sub	x20, x9, x21
    2654: aa1403e2     	mov	x2, x20
<L7>:
    2658: 94000000     	bl	 <L7>
		0000000000002658:  R_AARCH64_CALL26	memcpy
    265c: 385f03a8     	ldurb	w8, [x29, #-0x10]
    2660: b100c309     	adds	x9, x24, #0x30
    2664: d10383a0     	sub	x0, x29, #0xe0
    2668: 9a9736ea     	cinc	x10, x23, hs
    266c: 910383e1     	add	x1, sp, #0xe0
    2670: 0b140108     	add	w8, w8, w20
    2674: a9322ba9     	stp	x9, x10, [x29, #-0xe0]
    2678: 381f03a8     	sturb	w8, [x29, #-0x10]
    267c: 940001f3     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2680: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    2684: 3dc043e2     	ldr	q2, [sp, #0x100]
    2688: 3d800a62     	str	q2, [x19, #0x20]
    268c: ad000660     	stp	q0, q1, [x19]
    2690: 910e03ff     	add	sp, sp, #0x380
    2694: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    2698: f9400bfc     	ldr	x28, [sp, #0x10]
    269c: a94457f6     	ldp	x22, x21, [sp, #0x40]
    26a0: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    26a4: a94267fa     	ldp	x26, x25, [sp, #0x20]
    26a8: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    26ac: d65f03c0     	ret

00000000000026b0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
    26b0: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    26b4: a9016ffc     	stp	x28, x27, [sp, #0x10]
    26b8: a90267fa     	stp	x26, x25, [sp, #0x20]
    26bc: a9035ff8     	stp	x24, x23, [sp, #0x30]
    26c0: a90457f6     	stp	x22, x21, [sp, #0x40]
    26c4: a9054ff4     	stp	x20, x19, [sp, #0x50]
    26c8: 910003fd     	mov	x29, sp
    26cc: d11a43ff     	sub	sp, sp, #0x690
    26d0: ad400482     	ldp	q2, q1, [x4]
    26d4: 52800028     	mov	w8, #0x1                // =1
    26d8: 3dc00880     	ldr	q0, [x4, #0x20]
    26dc: aa0303f4     	mov	x20, x3
    26e0: aa0103f5     	mov	x21, x1
    26e4: 910d03fb     	add	x27, sp, #0x340
    26e8: f100c03f     	cmp	x1, #0x30
    26ec: 3906b3e8     	strb	w8, [sp, #0x1ac]
    26f0: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		00000000000026f0:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xb0
    26f4: 91000108     	add	x8, x8, #0x0
		00000000000026f4:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xb0
    26f8: a90b03e2     	stp	x2, x0, [sp, #0xb0]
    26fc: ad0083e1     	stp	q1, q0, [sp, #0x10]
    2700: 3d8003e2     	str	q2, [sp]
    2704: 54000922     	b.hs	 <L2>
    2708: f9001bff     	str	xzr, [sp, #0x30]
<L0>:
    270c: f100c2a8     	subs	x8, x21, #0x30
    2710: 9a8832b7     	csel	x23, x21, x8, lo
    2714: b40038b7     	cbz	x23,  <L39>
    2718: 4f02e780     	movi	v0.16b, #0x5c
    271c: ad401be7     	ldp	q7, q6, [sp]
    2720: 4f01e6c1     	movi	v1.16b, #0x36
    2724: 3dc00be5     	ldr	q5, [sp, #0x20]
    2728: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002728:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xb0
    272c: 91000108     	add	x8, x8, #0x0
		000000000000272c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xb0
    2730: 911483e0     	add	x0, sp, #0x520
    2734: 910d03e1     	add	x1, sp, #0x340
    2738: 6e201ce2     	eor	v2.16b, v7.16b, v0.16b
    273c: 6e201cc3     	eor	v3.16b, v6.16b, v0.16b
    2740: 6e201ca4     	eor	v4.16b, v5.16b, v0.16b
    2744: ad020761     	stp	q1, q1, [x27, #0x40]
    2748: ad030761     	stp	q1, q1, [x27, #0x60]
    274c: ad160f62     	stp	q2, q3, [x27, #0x2c0]
    2750: 6e211ce2     	eor	v2.16b, v7.16b, v1.16b
    2754: 6e211cc3     	eor	v3.16b, v6.16b, v1.16b
    2758: ad170364     	stp	q4, q0, [x27, #0x2e0]
    275c: 6e211ca4     	eor	v4.16b, v5.16b, v1.16b
    2760: ad180360     	stp	q0, q0, [x27, #0x300]
    2764: ad000f62     	stp	q2, q3, [x27]
    2768: ad010764     	stp	q4, q1, [x27, #0x20]
    276c: ad190360     	stp	q0, q0, [x27, #0x320]
    2770: ad400102     	ldp	q2, q0, [x8]
    2774: ad0c03e2     	stp	q2, q0, [sp, #0x180]
    2778: ad0f0362     	stp	q2, q0, [x27, #0x1e0]
    277c: ad420500     	ldp	q0, q1, [x8, #0x40]
    2780: ad0b07e0     	stp	q0, q1, [sp, #0x160]
    2784: ad110760     	stp	q0, q1, [x27, #0x220]
    2788: ad410901     	ldp	q1, q2, [x8, #0x20]
    278c: ad0a0be1     	stp	q1, q2, [sp, #0x140]
    2790: ad100b61     	stp	q1, q2, [x27, #0x200]
    2794: ad440102     	ldp	q2, q0, [x8, #0x80]
    2798: ad0903e2     	stp	q2, q0, [sp, #0x120]
    279c: ad130362     	stp	q2, q0, [x27, #0x260]
    27a0: ad430500     	ldp	q0, q1, [x8, #0x60]
    27a4: ad0807e0     	stp	q0, q1, [sp, #0x100]
    27a8: ad120760     	stp	q0, q1, [x27, #0x240]
    27ac: ad460901     	ldp	q1, q2, [x8, #0xc0]
    27b0: ad070be1     	stp	q1, q2, [sp, #0xe0]
    27b4: ad150b61     	stp	q1, q2, [x27, #0x2a0]
    27b8: ad450102     	ldp	q2, q0, [x8, #0xa0]
    27bc: ad0603e2     	stp	q2, q0, [sp, #0xc0]
    27c0: ad140362     	stp	q2, q0, [x27, #0x280]
    27c4: 940001fe     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    27c8: a95e2768     	ldp	x8, x9, [x27, #0x1e0]
    27cc: b102010a     	adds	x10, x8, #0x80
    27d0: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    27d4: 9a893529     	cinc	x9, x9, hs
    27d8: f100bebf     	cmp	x21, #0x2f
    27dc: a91e276a     	stp	x10, x9, [x27, #0x1e0]
    27e0: 540021e9     	b.ls	 <L25>
    27e4: 34001fa8     	cbz	w8,  <L22>
    27e8: 7101411f     	cmp	w8, #0x50
    27ec: 54001f63     	b.lo	 <L22>
    27f0: 52801009     	mov	w9, #0x80               // =128
    27f4: 911483ea     	add	x10, sp, #0x520
    27f8: f9405fe1     	ldr	x1, [sp, #0xb8]
    27fc: cb080136     	sub	x22, x9, x8
    2800: 91014158     	add	x24, x10, #0x50
    2804: 8b080300     	add	x0, x24, x8
    2808: aa1603e2     	mov	x2, x22
<L1>:
    280c: 94000000     	bl	 <L1>
		000000000000280c:  R_AARCH64_CALL26	memcpy
    2810: 911483e0     	add	x0, sp, #0x520
    2814: aa1803e1     	mov	x1, x24
    2818: 940001e9     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    281c: 2a1f03e8     	mov	w8, wzr
    2820: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    2824: 140000ee     	b	 <L23>
<L2>:
    2828: 4f02e783     	movi	v3.16b, #0x5c
    282c: 4f01e6c4     	movi	v4.16b, #0x36
    2830: d2401a89     	eor	x9, x20, #0x7f
    2834: f9001fe9     	str	x9, [sp, #0x38]
    2838: 9106c3e9     	add	x9, sp, #0x1b0
    283c: aa1f03fc     	mov	x28, xzr
    2840: 91014377     	add	x23, x27, #0x50
    2844: 91014138     	add	x24, x9, #0x50
    2848: 52800039     	mov	w25, #0x1               // =1
    284c: 52800033     	mov	w19, #0x1               // =1
    2850: f90057f5     	str	x21, [sp, #0xa8]
    2854: 6e231c46     	eor	v6.16b, v2.16b, v3.16b
    2858: 6e231c25     	eor	v5.16b, v1.16b, v3.16b
    285c: 6e231c03     	eor	v3.16b, v0.16b, v3.16b
    2860: 6e241c21     	eor	v1.16b, v1.16b, v4.16b
    2864: 6e241c00     	eor	v0.16b, v0.16b, v4.16b
    2868: 6e241c42     	eor	v2.16b, v2.16b, v4.16b
    286c: ad041be5     	stp	q5, q6, [sp, #0x80]
    2870: ad0207e0     	stp	q0, q1, [sp, #0x40]
    2874: ad400101     	ldp	q1, q0, [x8]
    2878: ad030fe2     	stp	q2, q3, [sp, #0x60]
    287c: ad0c07e0     	stp	q0, q1, [sp, #0x180]
    2880: ad410101     	ldp	q1, q0, [x8, #0x20]
    2884: ad0b07e0     	stp	q0, q1, [sp, #0x160]
    2888: ad420101     	ldp	q1, q0, [x8, #0x40]
    288c: ad0a07e0     	stp	q0, q1, [sp, #0x140]
    2890: ad430101     	ldp	q1, q0, [x8, #0x60]
    2894: ad0907e0     	stp	q0, q1, [sp, #0x120]
    2898: ad440101     	ldp	q1, q0, [x8, #0x80]
    289c: ad0807e0     	stp	q0, q1, [sp, #0x100]
    28a0: ad450101     	ldp	q1, q0, [x8, #0xa0]
    28a4: ad0707e0     	stp	q0, q1, [sp, #0xe0]
    28a8: ad460101     	ldp	q1, q0, [x8, #0xc0]
    28ac: 52800608     	mov	w8, #0x30               // =48
    28b0: f9001be8     	str	x8, [sp, #0x30]
    28b4: ad0607e0     	stp	q0, q1, [sp, #0xc0]
    28b8: 1400001a     	b	 <L6>
<L3>:
    28bc: aa1f03f9     	mov	x25, xzr
<L4>:
    28c0: 8b2842e0     	add	x0, x23, w8, uxtw
    28c4: 52800608     	mov	w8, #0x30               // =48
    28c8: cb19011a     	sub	x26, x8, x25
    28cc: 911283e8     	add	x8, sp, #0x4a0
    28d0: 8b190101     	add	x1, x8, x25
    28d4: aa1a03e2     	mov	x2, x26
<L5>:
    28d8: 94000000     	bl	 <L5>
		00000000000028d8:  R_AARCH64_CALL26	memcpy
    28dc: 395043e8     	ldrb	w8, [sp, #0x410]
    28e0: b100c2c9     	adds	x9, x22, #0x30
    28e4: 910d03e0     	add	x0, sp, #0x340
    28e8: 9a9536aa     	cinc	x10, x21, hs
    28ec: 0b1a0108     	add	w8, w8, w26
    28f0: a9002b69     	stp	x9, x10, [x27]
    28f4: 391043e8     	strb	w8, [sp, #0x410]
    28f8: f9405fe8     	ldr	x8, [sp, #0xb8]
    28fc: 8b1c0101     	add	x1, x8, x28
    2900: 94000152     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2904: f94057f5     	ldr	x21, [sp, #0xa8]
    2908: 2a1f03f9     	mov	w25, wzr
    290c: 11000673     	add	w19, w19, #0x1
    2910: 5280061c     	mov	w28, #0x30              // =48
    2914: 3906b3f3     	strb	w19, [sp, #0x1ac]
    2918: f10182bf     	cmp	x21, #0x60
    291c: 54ffef83     	b.lo	 <L0>
<L6>:
    2920: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    2924: 910d03e0     	add	x0, sp, #0x340
    2928: 911283e1     	add	x1, sp, #0x4a0
    292c: ad070361     	stp	q1, q0, [x27, #0xe0]
    2930: 4f02e780     	movi	v0.16b, #0x5c
    2934: 3dc01fe1     	ldr	q1, [sp, #0x70]
    2938: ad080361     	stp	q1, q0, [x27, #0x100]
    293c: ad090360     	stp	q0, q0, [x27, #0x120]
    2940: ad0a0360     	stp	q0, q0, [x27, #0x140]
    2944: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    2948: ad0b0361     	stp	q1, q0, [x27, #0x160]
    294c: 4f01e6c0     	movi	v0.16b, #0x36
    2950: 3dc013e1     	ldr	q1, [sp, #0x40]
    2954: ad0c0361     	stp	q1, q0, [x27, #0x180]
    2958: ad0d0360     	stp	q0, q0, [x27, #0x1a0]
    295c: ad0e0360     	stp	q0, q0, [x27, #0x1c0]
    2960: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    2964: ad000361     	stp	q1, q0, [x27]
    2968: ad4a03e1     	ldp	q1, q0, [sp, #0x140]
    296c: ad020760     	stp	q0, q1, [x27, #0x40]
    2970: ad4b03e1     	ldp	q1, q0, [sp, #0x160]
    2974: ad010760     	stp	q0, q1, [x27, #0x20]
    2978: ad4803e1     	ldp	q1, q0, [sp, #0x100]
    297c: ad040760     	stp	q0, q1, [x27, #0x80]
    2980: ad4903e1     	ldp	q1, q0, [sp, #0x120]
    2984: ad030760     	stp	q0, q1, [x27, #0x60]
    2988: ad4603e1     	ldp	q1, q0, [sp, #0xc0]
    298c: ad060760     	stp	q0, q1, [x27, #0xc0]
    2990: ad4703e1     	ldp	q1, q0, [sp, #0xe0]
    2994: ad050760     	stp	q0, q1, [x27, #0xa0]
    2998: 94000189     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    299c: a9402768     	ldp	x8, x9, [x27]
    29a0: 9106c3e0     	add	x0, sp, #0x1b0
    29a4: 910d03e1     	add	x1, sp, #0x340
    29a8: 52802c02     	mov	w2, #0x160              // =352
    29ac: b1020108     	adds	x8, x8, #0x80
    29b0: 9a893529     	cinc	x9, x9, hs
    29b4: a9002768     	stp	x8, x9, [x27]
<L7>:
    29b8: 94000000     	bl	 <L7>
		00000000000029b8:  R_AARCH64_CALL26	memcpy
    29bc: 394a03e8     	ldrb	w8, [sp, #0x280]
    29c0: 370003f9     	tbnz	w25, #0x0,  <L12>
    29c4: 340001e8     	cbz	w8,  <L9>
    29c8: 7101411f     	cmp	w8, #0x50
    29cc: 540001a3     	b.lo	 <L9>
    29d0: 52801009     	mov	w9, #0x80               // =128
    29d4: f9405fe1     	ldr	x1, [sp, #0xb8]
    29d8: 8b080300     	add	x0, x24, x8
    29dc: cb080139     	sub	x25, x9, x8
    29e0: aa1903e2     	mov	x2, x25
<L8>:
    29e4: 94000000     	bl	 <L8>
		00000000000029e4:  R_AARCH64_CALL26	memcpy
    29e8: 9106c3e0     	add	x0, sp, #0x1b0
    29ec: aa1803e1     	mov	x1, x24
    29f0: 94000173     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    29f4: 2a1f03e8     	mov	w8, wzr
    29f8: 390a03ff     	strb	wzr, [sp, #0x280]
    29fc: 14000002     	b	 <L10>
<L9>:
    2a00: aa1f03f9     	mov	x25, xzr
<L10>:
    2a04: 8b284300     	add	x0, x24, w8, uxtw
    2a08: 52800608     	mov	w8, #0x30               // =48
    2a0c: cb19011a     	sub	x26, x8, x25
    2a10: f9405fe8     	ldr	x8, [sp, #0xb8]
    2a14: aa1a03e2     	mov	x2, x26
    2a18: 8b190101     	add	x1, x8, x25
<L11>:
    2a1c: 94000000     	bl	 <L11>
		0000000000002a1c:  R_AARCH64_CALL26	memcpy
    2a20: a95b2be9     	ldp	x9, x10, [sp, #0x1b0]
    2a24: 394a03e8     	ldrb	w8, [sp, #0x280]
    2a28: 0b1a0108     	add	w8, w8, w26
    2a2c: b100c129     	adds	x9, x9, #0x30
    2a30: 390a03e8     	strb	w8, [sp, #0x280]
    2a34: 9a8a354a     	cinc	x10, x10, hs
    2a38: a91b2be9     	stp	x9, x10, [sp, #0x1b0]
<L12>:
    2a3c: 34000228     	cbz	w8,  <L14>
    2a40: f9401fea     	ldr	x10, [sp, #0x38]
    2a44: 2a0803e9     	mov	w9, w8
    2a48: eb09015f     	cmp	x10, x9
    2a4c: 540001a2     	b.hs	 <L14>
    2a50: 5280100a     	mov	w10, #0x80              // =128
    2a54: f9405be1     	ldr	x1, [sp, #0xb0]
    2a58: 8b090300     	add	x0, x24, x9
    2a5c: 4b080159     	sub	w25, w10, w8
    2a60: aa1903e2     	mov	x2, x25
<L13>:
    2a64: 94000000     	bl	 <L13>
		0000000000002a64:  R_AARCH64_CALL26	memcpy
    2a68: 9106c3e0     	add	x0, sp, #0x1b0
    2a6c: aa1803e1     	mov	x1, x24
    2a70: 94000153     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2a74: 2a1f03e8     	mov	w8, wzr
    2a78: 390a03ff     	strb	wzr, [sp, #0x280]
    2a7c: 14000002     	b	 <L15>
<L14>:
    2a80: aa1f03f9     	mov	x25, xzr
<L15>:
    2a84: 8b284300     	add	x0, x24, w8, uxtw
    2a88: f9405be8     	ldr	x8, [sp, #0xb0]
    2a8c: cb19029a     	sub	x26, x20, x25
    2a90: aa1a03e2     	mov	x2, x26
    2a94: 8b190101     	add	x1, x8, x25
<L16>:
    2a98: 94000000     	bl	 <L16>
		0000000000002a98:  R_AARCH64_CALL26	memcpy
    2a9c: a95b2be9     	ldp	x9, x10, [sp, #0x1b0]
    2aa0: 394a03e8     	ldrb	w8, [sp, #0x280]
    2aa4: 0b1a0108     	add	w8, w8, w26
    2aa8: ab140136     	adds	x22, x9, x20
    2aac: 390a03e8     	strb	w8, [sp, #0x280]
    2ab0: 9a8a3555     	cinc	x21, x10, hs
    2ab4: a91b57f6     	stp	x22, x21, [sp, #0x1b0]
    2ab8: 34000208     	cbz	w8,  <L18>
    2abc: 7101fd1f     	cmp	w8, #0x7f
    2ac0: 540001c3     	b.lo	 <L18>
    2ac4: 52801009     	mov	w9, #0x80               // =128
    2ac8: 8b284300     	add	x0, x24, w8, uxtw
    2acc: 9106b3e1     	add	x1, sp, #0x1ac
    2ad0: 4b080139     	sub	w25, w9, w8
    2ad4: aa1903e2     	mov	x2, x25
<L17>:
    2ad8: 94000000     	bl	 <L17>
		0000000000002ad8:  R_AARCH64_CALL26	memcpy
    2adc: 9106c3e0     	add	x0, sp, #0x1b0
    2ae0: aa1803e1     	mov	x1, x24
    2ae4: 94000136     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2ae8: a95b57f6     	ldp	x22, x21, [sp, #0x1b0]
    2aec: 2a1f03e8     	mov	w8, wzr
    2af0: 390a03ff     	strb	wzr, [sp, #0x280]
    2af4: 14000002     	b	 <L19>
<L18>:
    2af8: aa1f03f9     	mov	x25, xzr
<L19>:
    2afc: 8b284300     	add	x0, x24, w8, uxtw
    2b00: 52800028     	mov	w8, #0x1                // =1
    2b04: cb19011a     	sub	x26, x8, x25
    2b08: 9106b3e8     	add	x8, sp, #0x1ac
    2b0c: 8b190101     	add	x1, x8, x25
    2b10: aa1a03e2     	mov	x2, x26
<L20>:
    2b14: 94000000     	bl	 <L20>
		0000000000002b14:  R_AARCH64_CALL26	memcpy
    2b18: 394a03e8     	ldrb	w8, [sp, #0x280]
    2b1c: b10006c9     	adds	x9, x22, #0x1
    2b20: 9106c3e0     	add	x0, sp, #0x1b0
    2b24: 9a9536aa     	cinc	x10, x21, hs
    2b28: 911283e1     	add	x1, sp, #0x4a0
    2b2c: 0b1a0108     	add	w8, w8, w26
    2b30: a91b2be9     	stp	x9, x10, [sp, #0x1b0]
    2b34: 390a03e8     	strb	w8, [sp, #0x280]
    2b38: 940000c4     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2b3c: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    2b40: 9106c3e8     	add	x8, sp, #0x1b0
    2b44: 910d03e0     	add	x0, sp, #0x340
    2b48: 91038101     	add	x1, x8, #0xe0
    2b4c: ad050361     	stp	q1, q0, [x27, #0xa0]
    2b50: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    2b54: ad060361     	stp	q1, q0, [x27, #0xc0]
    2b58: ad4907e0     	ldp	q0, q1, [sp, #0x120]
    2b5c: ad030361     	stp	q1, q0, [x27, #0x60]
    2b60: ad4807e0     	ldp	q0, q1, [sp, #0x100]
    2b64: ad040361     	stp	q1, q0, [x27, #0x80]
    2b68: ad4b07e0     	ldp	q0, q1, [sp, #0x160]
    2b6c: ad010361     	stp	q1, q0, [x27, #0x20]
    2b70: ad4a07e0     	ldp	q0, q1, [sp, #0x140]
    2b74: ad020361     	stp	q1, q0, [x27, #0x40]
    2b78: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    2b7c: ad000361     	stp	q1, q0, [x27]
    2b80: 9400010f     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2b84: a9402b69     	ldp	x9, x10, [x27]
    2b88: 395043e8     	ldrb	w8, [sp, #0x410]
    2b8c: b1020136     	adds	x22, x9, #0x80
    2b90: 9a8a3555     	cinc	x21, x10, hs
    2b94: a9005776     	stp	x22, x21, [x27]
    2b98: 34ffe928     	cbz	w8,  <L3>
    2b9c: 7101411f     	cmp	w8, #0x50
    2ba0: 54ffe8e3     	b.lo	 <L3>
    2ba4: 52801009     	mov	w9, #0x80               // =128
    2ba8: 8b0802e0     	add	x0, x23, x8
    2bac: 911283e1     	add	x1, sp, #0x4a0
    2bb0: cb080139     	sub	x25, x9, x8
    2bb4: aa1903e2     	mov	x2, x25
<L21>:
    2bb8: 94000000     	bl	 <L21>
		0000000000002bb8:  R_AARCH64_CALL26	memcpy
    2bbc: 910d03e0     	add	x0, sp, #0x340
    2bc0: aa1703e1     	mov	x1, x23
    2bc4: 940000fe     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2bc8: a9405776     	ldp	x22, x21, [x27]
    2bcc: 2a1f03e8     	mov	w8, wzr
    2bd0: 391043ff     	strb	wzr, [sp, #0x410]
    2bd4: 17ffff3b     	b	 <L4>
<L22>:
    2bd8: aa1f03f6     	mov	x22, xzr
<L23>:
    2bdc: 911483e9     	add	x9, sp, #0x520
    2be0: 5280060a     	mov	w10, #0x30              // =48
    2be4: 8b284128     	add	x8, x9, w8, uxtw
    2be8: cb160158     	sub	x24, x10, x22
    2bec: aa1803e2     	mov	x2, x24
    2bf0: 91014100     	add	x0, x8, #0x50
    2bf4: f9405fe8     	ldr	x8, [sp, #0xb8]
    2bf8: 8b160101     	add	x1, x8, x22
<L24>:
    2bfc: 94000000     	bl	 <L24>
		0000000000002bfc:  R_AARCH64_CALL26	memcpy
    2c00: a95e2b69     	ldp	x9, x10, [x27, #0x1e0]
    2c04: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    2c08: 0b180108     	add	w8, w8, w24
    2c0c: b100c129     	adds	x9, x9, #0x30
    2c10: 3917c3e8     	strb	w8, [sp, #0x5f0]
    2c14: 9a8a354a     	cinc	x10, x10, hs
    2c18: a91e2b69     	stp	x9, x10, [x27, #0x1e0]
<L25>:
    2c1c: 34000268     	cbz	w8,  <L27>
    2c20: 2a0803e9     	mov	w9, w8
    2c24: 8b09028a     	add	x10, x20, x9
    2c28: f102015f     	cmp	x10, #0x80
    2c2c: 540001e3     	b.lo	 <L27>
    2c30: 5280100a     	mov	w10, #0x80              // =128
    2c34: 911483eb     	add	x11, sp, #0x520
    2c38: f9405be1     	ldr	x1, [sp, #0xb0]
    2c3c: 4b080158     	sub	w24, w10, w8
    2c40: 91014176     	add	x22, x11, #0x50
    2c44: 8b0902c0     	add	x0, x22, x9
    2c48: aa1803e2     	mov	x2, x24
<L26>:
    2c4c: 94000000     	bl	 <L26>
		0000000000002c4c:  R_AARCH64_CALL26	memcpy
    2c50: 911483e0     	add	x0, sp, #0x520
    2c54: aa1603e1     	mov	x1, x22
    2c58: 940000d9     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2c5c: 2a1f03e8     	mov	w8, wzr
    2c60: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    2c64: 14000002     	b	 <L28>
<L27>:
    2c68: aa1f03f8     	mov	x24, xzr
<L28>:
    2c6c: 911483f3     	add	x19, sp, #0x520
    2c70: cb180299     	sub	x25, x20, x24
    2c74: 91014276     	add	x22, x19, #0x50
    2c78: aa1903e2     	mov	x2, x25
    2c7c: 8b2842c0     	add	x0, x22, w8, uxtw
    2c80: f9405be8     	ldr	x8, [sp, #0xb0]
    2c84: 8b180101     	add	x1, x8, x24
<L29>:
    2c88: 94000000     	bl	 <L29>
		0000000000002c88:  R_AARCH64_CALL26	memcpy
    2c8c: a95e2b69     	ldp	x9, x10, [x27, #0x1e0]
    2c90: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    2c94: 0b190108     	add	w8, w8, w25
    2c98: ab140139     	adds	x25, x9, x20
    2c9c: 3917c3e8     	strb	w8, [sp, #0x5f0]
    2ca0: 9a8a3558     	cinc	x24, x10, hs
    2ca4: a91e6379     	stp	x25, x24, [x27, #0x1e0]
    2ca8: 34000208     	cbz	w8,  <L31>
    2cac: 7101fd1f     	cmp	w8, #0x7f
    2cb0: 540001c3     	b.lo	 <L31>
    2cb4: 52801009     	mov	w9, #0x80               // =128
    2cb8: 8b2842c0     	add	x0, x22, w8, uxtw
    2cbc: 9106b3e1     	add	x1, sp, #0x1ac
    2cc0: 4b080134     	sub	w20, w9, w8
    2cc4: aa1403e2     	mov	x2, x20
<L30>:
    2cc8: 94000000     	bl	 <L30>
		0000000000002cc8:  R_AARCH64_CALL26	memcpy
    2ccc: 911483e0     	add	x0, sp, #0x520
    2cd0: aa1603e1     	mov	x1, x22
    2cd4: 940000ba     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2cd8: a95e6379     	ldp	x25, x24, [x27, #0x1e0]
    2cdc: 2a1f03e8     	mov	w8, wzr
    2ce0: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    2ce4: 14000002     	b	 <L32>
<L31>:
    2ce8: aa1f03f4     	mov	x20, xzr
<L32>:
    2cec: 52800029     	mov	w9, #0x1                // =1
    2cf0: 8b2842c0     	add	x0, x22, w8, uxtw
    2cf4: 9106b3e8     	add	x8, sp, #0x1ac
    2cf8: cb140135     	sub	x21, x9, x20
    2cfc: 8b140101     	add	x1, x8, x20
    2d00: aa1503e2     	mov	x2, x21
<L33>:
    2d04: 94000000     	bl	 <L33>
		0000000000002d04:  R_AARCH64_CALL26	memcpy
    2d08: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    2d0c: b1000729     	adds	x9, x25, #0x1
    2d10: 911483e0     	add	x0, sp, #0x520
    2d14: 9a98370a     	cinc	x10, x24, hs
    2d18: 911283e1     	add	x1, sp, #0x4a0
    2d1c: 911283f6     	add	x22, sp, #0x4a0
    2d20: 0b150108     	add	w8, w8, w21
    2d24: a91e2b69     	stp	x9, x10, [x27, #0x1e0]
    2d28: 3917c3e8     	strb	w8, [sp, #0x5f0]
    2d2c: 94000047     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2d30: ad4603e1     	ldp	q1, q0, [sp, #0xc0]
    2d34: 910d03e8     	add	x8, sp, #0x340
    2d38: 910d03e0     	add	x0, sp, #0x340
    2d3c: 91038261     	add	x1, x19, #0xe0
    2d40: 91014114     	add	x20, x8, #0x50
    2d44: ad050361     	stp	q1, q0, [x27, #0xa0]
    2d48: ad4703e1     	ldp	q1, q0, [sp, #0xe0]
    2d4c: ad060361     	stp	q1, q0, [x27, #0xc0]
    2d50: ad4803e1     	ldp	q1, q0, [sp, #0x100]
    2d54: ad030361     	stp	q1, q0, [x27, #0x60]
    2d58: ad4903e1     	ldp	q1, q0, [sp, #0x120]
    2d5c: ad040361     	stp	q1, q0, [x27, #0x80]
    2d60: ad4a03e1     	ldp	q1, q0, [sp, #0x140]
    2d64: ad010361     	stp	q1, q0, [x27, #0x20]
    2d68: ad4b03e1     	ldp	q1, q0, [sp, #0x160]
    2d6c: ad020361     	stp	q1, q0, [x27, #0x40]
    2d70: ad4c03e1     	ldp	q1, q0, [sp, #0x180]
    2d74: ad000361     	stp	q1, q0, [x27]
    2d78: 94000091     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2d7c: a9402b69     	ldp	x9, x10, [x27]
    2d80: 395043e8     	ldrb	w8, [sp, #0x410]
    2d84: b1020138     	adds	x24, x9, #0x80
    2d88: 9a8a3553     	cinc	x19, x10, hs
    2d8c: a9004f78     	stp	x24, x19, [x27]
    2d90: 34000208     	cbz	w8,  <L35>
    2d94: 7101411f     	cmp	w8, #0x50
    2d98: 540001c3     	b.lo	 <L35>
    2d9c: 52801009     	mov	w9, #0x80               // =128
    2da0: 8b080280     	add	x0, x20, x8
    2da4: 911283e1     	add	x1, sp, #0x4a0
    2da8: cb080135     	sub	x21, x9, x8
    2dac: aa1503e2     	mov	x2, x21
<L34>:
    2db0: 94000000     	bl	 <L34>
		0000000000002db0:  R_AARCH64_CALL26	memcpy
    2db4: 910d03e0     	add	x0, sp, #0x340
    2db8: aa1403e1     	mov	x1, x20
    2dbc: 94000080     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2dc0: a9404f78     	ldp	x24, x19, [x27]
    2dc4: 2a1f03e8     	mov	w8, wzr
    2dc8: 391043ff     	strb	wzr, [sp, #0x410]
    2dcc: 14000002     	b	 <L36>
<L35>:
    2dd0: aa1f03f5     	mov	x21, xzr
<L36>:
    2dd4: 52800609     	mov	w9, #0x30               // =48
    2dd8: 8b284280     	add	x0, x20, w8, uxtw
    2ddc: 8b1502c1     	add	x1, x22, x21
    2de0: cb150134     	sub	x20, x9, x21
    2de4: aa1403e2     	mov	x2, x20
<L37>:
    2de8: 94000000     	bl	 <L37>
		0000000000002de8:  R_AARCH64_CALL26	memcpy
    2dec: 395043e8     	ldrb	w8, [sp, #0x410]
    2df0: b100c309     	adds	x9, x24, #0x30
    2df4: 910d03e0     	add	x0, sp, #0x340
    2df8: 9a93366a     	cinc	x10, x19, hs
    2dfc: 910c43e1     	add	x1, sp, #0x310
    2e00: 0b140108     	add	w8, w8, w20
    2e04: a9002b69     	stp	x9, x10, [x27]
    2e08: 391043e8     	strb	w8, [sp, #0x410]
    2e0c: 9400000f     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2e10: f9405fe8     	ldr	x8, [sp, #0xb8]
    2e14: f9401be9     	ldr	x9, [sp, #0x30]
    2e18: 910c43e1     	add	x1, sp, #0x310
    2e1c: aa1703e2     	mov	x2, x23
    2e20: 8b090100     	add	x0, x8, x9
<L38>:
    2e24: 94000000     	bl	 <L38>
		0000000000002e24:  R_AARCH64_CALL26	memcpy
<L39>:
    2e28: 911a43ff     	add	sp, sp, #0x690
    2e2c: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    2e30: a94457f6     	ldp	x22, x21, [sp, #0x40]
    2e34: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    2e38: a94267fa     	ldp	x26, x25, [sp, #0x20]
    2e3c: a9416ffc     	ldp	x28, x27, [sp, #0x10]
    2e40: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    2e44: d65f03c0     	ret

0000000000002e48 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    2e48: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    2e4c: a90157f6     	stp	x22, x21, [sp, #0x10]
    2e50: a9024ff4     	stp	x20, x19, [sp, #0x20]
    2e54: 910003fd     	mov	x29, sp
    2e58: 39434008     	ldrb	w8, [x0, #0xd0]
    2e5c: 52801016     	mov	w22, #0x80              // =128
    2e60: 91014015     	add	x21, x0, #0x50
    2e64: aa0103f3     	mov	x19, x1
    2e68: aa0003f4     	mov	x20, x0
    2e6c: 2a1f03e1     	mov	w1, wzr
    2e70: cb0802c2     	sub	x2, x22, x8
    2e74: 8b0802a0     	add	x0, x21, x8
<L0>:
    2e78: 94000000     	bl	 <L0>
		0000000000002e78:  R_AARCH64_CALL26	memset
    2e7c: 39434288     	ldrb	w8, [x20, #0xd0]
    2e80: 38286ab6     	strb	w22, [x21, x8]
    2e84: 39434288     	ldrb	w8, [x20, #0xd0]
    2e88: 11000509     	add	w9, w8, #0x1
    2e8c: 7101bd1f     	cmp	w8, #0x6f
    2e90: 39034289     	strb	w9, [x20, #0xd0]
    2e94: 54000129     	b.ls	 <L1>
    2e98: aa1403e0     	mov	x0, x20
    2e9c: aa1503e1     	mov	x1, x21
    2ea0: 94000047     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2ea4: 6f00e400     	movi	v0.2d, #0000000000000000
    2ea8: ad0082a0     	stp	q0, q0, [x21, #0x10]
    2eac: ad0182a0     	stp	q0, q0, [x21, #0x30]
    2eb0: ad0282a0     	stp	q0, q0, [x21, #0x50]
    2eb4: 3d8002a0     	str	q0, [x21]
<L1>:
    2eb8: f9400688     	ldr	x8, [x20, #0x8]
    2ebc: aa1403e0     	mov	x0, x20
    2ec0: aa1503e1     	mov	x1, x21
    2ec4: d375fd09     	lsr	x9, x8, #53
    2ec8: d36dfd0a     	lsr	x10, x8, #45
    2ecc: d34dfd0b     	lsr	x11, x8, #13
    2ed0: 1e270120     	fmov	s0, w9
    2ed4: d365fd09     	lsr	x9, x8, #37
    2ed8: 4e031d40     	mov	v0.b[1], w10
    2edc: f940028a     	ldr	x10, [x20]
    2ee0: 93ca950c     	extr	x12, x8, x10, #0x25
    2ee4: 93cab50e     	extr	x14, x8, x10, #0x2d
    2ee8: 93cad50d     	extr	x13, x8, x10, #0x35
    2eec: 4e051d20     	mov	v0.b[2], w9
    2ef0: d35dfd09     	lsr	x9, x8, #29
    2ef4: 4e071d20     	mov	v0.b[3], w9
    2ef8: d355fd09     	lsr	x9, x8, #21
    2efc: 4e091d20     	mov	v0.b[4], w9
    2f00: 93ca7509     	extr	x9, x8, x10, #0x1d
    2f04: 9e670124     	fmov	d4, x9
    2f08: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x1790>
		0000000000002f08:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst16
    2f0c: 9e670183     	fmov	d3, x12
    2f10: 3dc00125     	ldr	q5, [x9]
		0000000000002f10:  R_AARCH64_LDST128_ABS_LO12_NC	.rodata.cst16
    2f14: d345fd09     	lsr	x9, x8, #5
    2f18: 4e0b1d60     	mov	v0.b[5], w11
    2f1c: 9e6701c2     	fmov	d2, x14
    2f20: 93caf508     	extr	x8, x8, x10, #0x3d
    2f24: 9e6701a1     	fmov	d1, x13
    2f28: 53057d4b     	lsr	w11, w10, #5
    2f2c: 39033a8b     	strb	w11, [x20, #0xce]
    2f30: 4e056021     	tbl	v1.16b, { v1.16b, v2.16b, v3.16b, v4.16b }, v5.16b
    2f34: 4e0d1d20     	mov	v0.b[6], w9
    2f38: 531d7149     	lsl	w9, w10, #3
    2f3c: 39033e89     	strb	w9, [x20, #0xcf]
    2f40: 530d7d49     	lsr	w9, w10, #13
    2f44: 53157d4a     	lsr	w10, w10, #21
    2f48: 0e212821     	xtn	v1.8b, v1.8h
    2f4c: 4e0f1d00     	mov	v0.b[7], w8
    2f50: 39033689     	strb	w9, [x20, #0xcd]
    2f54: 3903328a     	strb	w10, [x20, #0xcc]
    2f58: bd00ca81     	str	s1, [x20, #0xc8]
    2f5c: fd006280     	str	d0, [x20, #0xc0]
    2f60: 94000017     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2f64: f9400a88     	ldr	x8, [x20, #0x10]
    2f68: dac00d08     	rev	x8, x8
    2f6c: f9000268     	str	x8, [x19]
    2f70: f9400e88     	ldr	x8, [x20, #0x18]
    2f74: dac00d08     	rev	x8, x8
    2f78: f9000668     	str	x8, [x19, #0x8]
    2f7c: f9401288     	ldr	x8, [x20, #0x20]
    2f80: dac00d08     	rev	x8, x8
    2f84: f9000a68     	str	x8, [x19, #0x10]
    2f88: f9401688     	ldr	x8, [x20, #0x28]
    2f8c: dac00d08     	rev	x8, x8
    2f90: f9000e68     	str	x8, [x19, #0x18]
    2f94: f9401a88     	ldr	x8, [x20, #0x30]
    2f98: dac00d08     	rev	x8, x8
    2f9c: f9001268     	str	x8, [x19, #0x20]
    2fa0: f9401e88     	ldr	x8, [x20, #0x38]
    2fa4: dac00d08     	rev	x8, x8
    2fa8: f9001668     	str	x8, [x19, #0x28]
    2fac: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2fb0: a94157f6     	ldp	x22, x21, [sp, #0x10]
    2fb4: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2fb8: d65f03c0     	ret

0000000000002fbc <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    2fbc: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    2fc0: f9000bf5     	str	x21, [sp, #0x10]
    2fc4: a9024ff4     	stp	x20, x19, [sp, #0x20]
    2fc8: 910003fd     	mov	x29, sp
    2fcc: d10a03ff     	sub	sp, sp, #0x280
    2fd0: ad400420     	ldp	q0, q1, [x1]
    2fd4: 910003e8     	mov	x8, sp
    2fd8: ad410c22     	ldp	q2, q3, [x1, #0x20]
    2fdc: 91020108     	add	x8, x8, #0x80
    2fe0: ad421424     	ldp	q4, q5, [x1, #0x40]
    2fe4: 5280080a     	mov	w10, #0x40              // =64
    2fe8: 4e200800     	rev64	v0.16b, v0.16b
    2fec: 4e200821     	rev64	v1.16b, v1.16b
    2ff0: 4e200842     	rev64	v2.16b, v2.16b
    2ff4: 4e200863     	rev64	v3.16b, v3.16b
    2ff8: 4e200884     	rev64	v4.16b, v4.16b
    2ffc: 4e2008a5     	rev64	v5.16b, v5.16b
    3000: ad0007e0     	stp	q0, q1, [sp]
    3004: ad430426     	ldp	q6, q1, [x1, #0x60]
    3008: 9e660009     	fmov	x9, d0
    300c: ad010fe2     	stp	q2, q3, [sp, #0x20]
    3010: ad0217e4     	stp	q4, q5, [sp, #0x40]
    3014: 4e2008c6     	rev64	v6.16b, v6.16b
    3018: 4e200821     	rev64	v1.16b, v1.16b
    301c: aa0903eb     	mov	x11, x9
    3020: ad0307e6     	stp	q6, q1, [sp, #0x60]
<L0>:
    3024: f85c810c     	ldur	x12, [x8, #-0x38]
    3028: f85f010d     	ldur	x13, [x8, #-0x10]
    302c: f100054a     	subs	x10, x10, #0x1
    3030: 8b0b018c     	add	x12, x12, x11
    3034: f858810b     	ldur	x11, [x8, #-0x78]
    3038: 93cd4daf     	ror	x15, x13, #0x13
    303c: 93cb056e     	ror	x14, x11, #0x1
    3040: cacdf5ef     	eor	x15, x15, x13, ror #61
    3044: cacb21ce     	eor	x14, x14, x11, ror #8
    3048: ca4d19ed     	eor	x13, x15, x13, lsr #6
    304c: ca4b1dce     	eor	x14, x14, x11, lsr #7
    3050: 8b0e018c     	add	x12, x12, x14
    3054: 8b0d018c     	add	x12, x12, x13
    3058: f800850c     	str	x12, [x8], #0x8
    305c: 54fffe41     	b.ne	 <L0>
    3060: a943a812     	ldp	x18, x10, [x0, #0x38]
    3064: d29b7794     	mov	x20, #0xdbbc            // =56252
    3068: a942a00e     	ldp	x14, x8, [x0, #0x28]
    306c: f2b03134     	movk	x20, #0x8189, lsl #16
    3070: a9410c0d     	ldp	x13, x3, [x0, #0x10]
    3074: f2db74b4     	movk	x20, #0xdba5, lsl #32
    3078: f2fd36b4     	movk	x20, #0xe9b5, lsl #48
    307c: a9432c0f     	ldp	x15, x11, [x0, #0x30]
    3080: 8a28014c     	bic	x12, x10, x8
    3084: 8a080250     	and	x16, x18, x8
    3088: 93c83901     	ror	x1, x8, #0xe
    308c: aa0c0210     	orr	x16, x16, x12
    3090: a944440c     	ldp	x12, x17, [x0, #0x40]
    3094: cac84821     	eor	x1, x1, x8, ror #18
    3098: 8b090229     	add	x9, x17, x9
    309c: 93cd71b1     	ror	x17, x13, #0x1c
    30a0: cac8a421     	eor	x1, x1, x8, ror #41
    30a4: 8b100129     	add	x9, x9, x16
    30a8: d295c450     	mov	x16, #0xae22            // =44578
    30ac: f2bae510     	movk	x16, #0xd728, lsl #16
    30b0: cacd8a31     	eor	x17, x17, x13, ror #34
    30b4: f2c5f310     	movk	x16, #0x2f98, lsl #32
    30b8: f2e85150     	movk	x16, #0x428a, lsl #48
    30bc: cacd9e31     	eor	x17, x17, x13, ror #39
    30c0: 8b100130     	add	x16, x9, x16
    30c4: a9419009     	ldp	x9, x4, [x0, #0x18]
    30c8: 8b100021     	add	x1, x1, x16
    30cc: a9421810     	ldp	x16, x6, [x0, #0x20]
    30d0: aa030082     	orr	x2, x4, x3
    30d4: 8a030085     	and	x5, x4, x3
    30d8: 8a0d0042     	and	x2, x2, x13
    30dc: aa050045     	orr	x5, x2, x5
    30e0: 8b060022     	add	x2, x1, x6
    30e4: 8b1100b1     	add	x17, x5, x17
    30e8: f94007e5     	ldr	x5, [sp, #0x8]
    30ec: 8a220246     	bic	x6, x18, x2
    30f0: 8b010231     	add	x17, x17, x1
    30f4: 93c23841     	ror	x1, x2, #0xe
    30f8: 8a020107     	and	x7, x8, x2
    30fc: 8b05014a     	add	x10, x10, x5
    3100: d28cb9a5     	mov	x5, #0x65cd             // =26061
    3104: 93d17233     	ror	x19, x17, #0x1c
    3108: f2a47de5     	movk	x5, #0x23ef, lsl #16
    310c: cac24821     	eor	x1, x1, x2, ror #18
    3110: aa0600e6     	orr	x6, x7, x6
    3114: f2c89225     	movk	x5, #0x4491, lsl #32
    3118: 8b06014a     	add	x10, x10, x6
    311c: cad18a66     	eor	x6, x19, x17, ror #34
    3120: f2ee26e5     	movk	x5, #0x7137, lsl #48
    3124: cac2a421     	eor	x1, x1, x2, ror #41
    3128: 8a0d0067     	and	x7, x3, x13
    312c: 8b05014a     	add	x10, x10, x5
    3130: aa0d0065     	orr	x5, x3, x13
    3134: cad19cc6     	eor	x6, x6, x17, ror #39
    3138: 8a050225     	and	x5, x17, x5
    313c: 8b01014a     	add	x10, x10, x1
    3140: aa0700a5     	orr	x5, x5, x7
    3144: 8b040141     	add	x1, x10, x4
    3148: 8b0500c4     	add	x4, x6, x5
    314c: f9400be5     	ldr	x5, [sp, #0x10]
    3150: 8a210106     	bic	x6, x8, x1
    3154: 8b0a008a     	add	x10, x4, x10
    3158: 93c13824     	ror	x4, x1, #0xe
    315c: 8a010047     	and	x7, x2, x1
    3160: 8b050252     	add	x18, x18, x5
    3164: d28765e5     	mov	x5, #0x3b2f             // =15151
    3168: 93ca7153     	ror	x19, x10, #0x1c
    316c: f2bd89a5     	movk	x5, #0xec4d, lsl #16
    3170: cac14884     	eor	x4, x4, x1, ror #18
    3174: aa0600e6     	orr	x6, x7, x6
    3178: f2df79e5     	movk	x5, #0xfbcf, lsl #32
    317c: 8b060252     	add	x18, x18, x6
    3180: caca8a66     	eor	x6, x19, x10, ror #34
    3184: f2f6b805     	movk	x5, #0xb5c0, lsl #48
    3188: cac1a484     	eor	x4, x4, x1, ror #41
    318c: 8a0d0227     	and	x7, x17, x13
    3190: 8b050252     	add	x18, x18, x5
    3194: aa0d0225     	orr	x5, x17, x13
    3198: caca9cc6     	eor	x6, x6, x10, ror #39
    319c: 8a050145     	and	x5, x10, x5
    31a0: 8b040252     	add	x18, x18, x4
    31a4: aa0700a4     	orr	x4, x5, x7
    31a8: 8b030243     	add	x3, x18, x3
    31ac: 8b0400c4     	add	x4, x6, x4
    31b0: a9419be5     	ldp	x5, x6, [sp, #0x18]
    31b4: 8b120092     	add	x18, x4, x18
    31b8: 93c33864     	ror	x4, x3, #0xe
    31bc: 8a030033     	and	x19, x1, x3
    31c0: 93d27247     	ror	x7, x18, #0x1c
    31c4: aa0a0255     	orr	x21, x18, x10
    31c8: 8b050108     	add	x8, x8, x5
    31cc: 8a230045     	bic	x5, x2, x3
    31d0: cac34884     	eor	x4, x4, x3, ror #18
    31d4: cad288e7     	eor	x7, x7, x18, ror #34
    31d8: aa050265     	orr	x5, x19, x5
    31dc: aa110153     	orr	x19, x10, x17
    31e0: 8b050108     	add	x8, x8, x5
    31e4: cac3a484     	eor	x4, x4, x3, ror #41
    31e8: 8a130245     	and	x5, x18, x19
    31ec: cad29ce7     	eor	x7, x7, x18, ror #39
    31f0: 8a110153     	and	x19, x10, x17
    31f4: 8b140108     	add	x8, x8, x20
    31f8: aa1300a5     	orr	x5, x5, x19
    31fc: 8b040108     	add	x8, x8, x4
    3200: 8b0200c2     	add	x2, x6, x2
    3204: 8b0500e5     	add	x5, x7, x5
    3208: 8b0d0104     	add	x4, x8, x13
    320c: d296a707     	mov	x7, #0xb538             // =46392
    3210: 8b0800a8     	add	x8, x5, x8
    3214: 93c43885     	ror	x5, x4, #0xe
    3218: f2be6907     	movk	x7, #0xf348, lsl #16
    321c: 93c87106     	ror	x6, x8, #0x1c
    3220: 8a240033     	bic	x19, x1, x4
    3224: 8a040074     	and	x20, x3, x4
    3228: cac448a5     	eor	x5, x5, x4, ror #18
    322c: f2d84b67     	movk	x7, #0xc25b, lsl #32
    3230: aa130293     	orr	x19, x20, x19
    3234: cac888c6     	eor	x6, x6, x8, ror #34
    3238: f2e72ac7     	movk	x7, #0x3956, lsl #48
    323c: 8a0a0254     	and	x20, x18, x10
    3240: 8b130042     	add	x2, x2, x19
    3244: cac4a4a5     	eor	x5, x5, x4, ror #41
    3248: 8a150113     	and	x19, x8, x21
    324c: cac89cc6     	eor	x6, x6, x8, ror #39
    3250: 8b070042     	add	x2, x2, x7
    3254: aa140267     	orr	x7, x19, x20
    3258: 8b050045     	add	x5, x2, x5
    325c: d29a0333     	mov	x19, #0xd019            // =53273
    3260: 8b0700c6     	add	x6, x6, x7
    3264: 8b1100a2     	add	x2, x5, x17
    3268: f2b6c0b3     	movk	x19, #0xb605, lsl #16
    326c: 8b0500d1     	add	x17, x6, x5
    3270: a9429be7     	ldp	x7, x6, [sp, #0x28]
    3274: 93c23845     	ror	x5, x2, #0xe
    3278: 8a220074     	bic	x20, x3, x2
    327c: 8a020095     	and	x21, x4, x2
    3280: f2c23e33     	movk	x19, #0x11f1, lsl #32
    3284: aa1402b4     	orr	x20, x21, x20
    3288: aa120115     	orr	x21, x8, x18
    328c: 8b0100e1     	add	x1, x7, x1
    3290: 93d17227     	ror	x7, x17, #0x1c
    3294: cac248a5     	eor	x5, x5, x2, ror #18
    3298: f2eb3e33     	movk	x19, #0x59f1, lsl #48
    329c: 8b140021     	add	x1, x1, x20
    32a0: 8a120114     	and	x20, x8, x18
    32a4: cad188e7     	eor	x7, x7, x17, ror #34
    32a8: cac2a4a5     	eor	x5, x5, x2, ror #41
    32ac: 8a150235     	and	x21, x17, x21
    32b0: 8b130021     	add	x1, x1, x19
    32b4: aa1402b3     	orr	x19, x21, x20
    32b8: 8b0300c3     	add	x3, x6, x3
    32bc: cad19ce7     	eor	x7, x7, x17, ror #39
    32c0: 8b050025     	add	x5, x1, x5
    32c4: aa080235     	orr	x21, x17, x8
    32c8: 8b0a00a1     	add	x1, x5, x10
    32cc: 8b1300e7     	add	x7, x7, x19
    32d0: 8a210093     	bic	x19, x4, x1
    32d4: 8a010054     	and	x20, x2, x1
    32d8: 8b0500ea     	add	x10, x7, x5
    32dc: 93c13825     	ror	x5, x1, #0xe
    32e0: d289f367     	mov	x7, #0x4f9b             // =20379
    32e4: 93ca7146     	ror	x6, x10, #0x1c
    32e8: f2b5e327     	movk	x7, #0xaf19, lsl #16
    32ec: aa130293     	orr	x19, x20, x19
    32f0: cac148a5     	eor	x5, x5, x1, ror #18
    32f4: f2d05487     	movk	x7, #0x82a4, lsl #32
    32f8: 8a080234     	and	x20, x17, x8
    32fc: caca88c6     	eor	x6, x6, x10, ror #34
    3300: f2f247e7     	movk	x7, #0x923f, lsl #48
    3304: 8b130063     	add	x3, x3, x19
    3308: cac1a4a5     	eor	x5, x5, x1, ror #41
    330c: 8a150153     	and	x19, x10, x21
    3310: 8b070063     	add	x3, x3, x7
    3314: caca9cc6     	eor	x6, x6, x10, ror #39
    3318: aa140267     	orr	x7, x19, x20
    331c: d2902313     	mov	x19, #0x8118            // =33048
    3320: 8b050065     	add	x5, x3, x5
    3324: f2bb4db3     	movk	x19, #0xda6d, lsl #16
    3328: 8b0700c6     	add	x6, x6, x7
    332c: 8b1200a3     	add	x3, x5, x18
    3330: f2cbdab3     	movk	x19, #0x5ed5, lsl #32
    3334: 8b0500d2     	add	x18, x6, x5
    3338: a9439be7     	ldp	x7, x6, [sp, #0x38]
    333c: 93c33865     	ror	x5, x3, #0xe
    3340: 8a230054     	bic	x20, x2, x3
    3344: 8a030035     	and	x21, x1, x3
    3348: aa1402b4     	orr	x20, x21, x20
    334c: aa110155     	orr	x21, x10, x17
    3350: f2f56393     	movk	x19, #0xab1c, lsl #48
    3354: 8b0400e4     	add	x4, x7, x4
    3358: 93d27247     	ror	x7, x18, #0x1c
    335c: cac348a5     	eor	x5, x5, x3, ror #18
    3360: 8b140084     	add	x4, x4, x20
    3364: 8a110154     	and	x20, x10, x17
    3368: 8a150255     	and	x21, x18, x21
    336c: cad288e7     	eor	x7, x7, x18, ror #34
    3370: cac3a4a5     	eor	x5, x5, x3, ror #41
    3374: 8b130084     	add	x4, x4, x19
    3378: aa1402b3     	orr	x19, x21, x20
    337c: 8b0200c2     	add	x2, x6, x2
    3380: aa0a0255     	orr	x21, x18, x10
    3384: cad29ce7     	eor	x7, x7, x18, ror #39
    3388: 8b050085     	add	x5, x4, x5
    338c: 8b0800a4     	add	x4, x5, x8
    3390: 8b1300e7     	add	x7, x7, x19
    3394: 8a240033     	bic	x19, x1, x4
    3398: 8a040074     	and	x20, x3, x4
    339c: 8b0500e8     	add	x8, x7, x5
    33a0: 93c43885     	ror	x5, x4, #0xe
    33a4: d2804847     	mov	x7, #0x242              // =578
    33a8: 93c87106     	ror	x6, x8, #0x1c
    33ac: f2b46067     	movk	x7, #0xa303, lsl #16
    33b0: aa130293     	orr	x19, x20, x19
    33b4: cac448a5     	eor	x5, x5, x4, ror #18
    33b8: f2d55307     	movk	x7, #0xaa98, lsl #32
    33bc: 8a0a0254     	and	x20, x18, x10
    33c0: cac888c6     	eor	x6, x6, x8, ror #34
    33c4: f2fb00e7     	movk	x7, #0xd807, lsl #48
    33c8: 8b130042     	add	x2, x2, x19
    33cc: cac4a4a5     	eor	x5, x5, x4, ror #41
    33d0: 8a150113     	and	x19, x8, x21
    33d4: 8b070042     	add	x2, x2, x7
    33d8: cac89cc6     	eor	x6, x6, x8, ror #39
    33dc: aa140267     	orr	x7, x19, x20
    33e0: d28df7d3     	mov	x19, #0x6fbe            // =28606
    33e4: 8b050045     	add	x5, x2, x5
    33e8: f2a8ae13     	movk	x19, #0x4570, lsl #16
    33ec: 8b0700c6     	add	x6, x6, x7
    33f0: 8b1100a2     	add	x2, x5, x17
    33f4: f2cb6033     	movk	x19, #0x5b01, lsl #32
    33f8: 8b0500d1     	add	x17, x6, x5
    33fc: a9449be7     	ldp	x7, x6, [sp, #0x48]
    3400: 93c23845     	ror	x5, x2, #0xe
    3404: 8a220074     	bic	x20, x3, x2
    3408: 8a020095     	and	x21, x4, x2
    340c: aa1402b4     	orr	x20, x21, x20
    3410: aa120115     	orr	x21, x8, x18
    3414: f2e25073     	movk	x19, #0x1283, lsl #48
    3418: 8b0100e1     	add	x1, x7, x1
    341c: 93d17227     	ror	x7, x17, #0x1c
    3420: cac248a5     	eor	x5, x5, x2, ror #18
    3424: 8b140021     	add	x1, x1, x20
    3428: 8a120114     	and	x20, x8, x18
    342c: 8a150235     	and	x21, x17, x21
    3430: cad188e7     	eor	x7, x7, x17, ror #34
    3434: cac2a4a5     	eor	x5, x5, x2, ror #41
    3438: 8b130021     	add	x1, x1, x19
    343c: aa1402b3     	orr	x19, x21, x20
    3440: 8b0300c3     	add	x3, x6, x3
    3444: aa080235     	orr	x21, x17, x8
    3448: cad19ce7     	eor	x7, x7, x17, ror #39
    344c: 8b050025     	add	x5, x1, x5
    3450: 8b0a00a1     	add	x1, x5, x10
    3454: 8b1300e7     	add	x7, x7, x19
    3458: 8a210093     	bic	x19, x4, x1
    345c: 8a010054     	and	x20, x2, x1
    3460: 8b0500ea     	add	x10, x7, x5
    3464: 93c13825     	ror	x5, x1, #0xe
    3468: d2965187     	mov	x7, #0xb28c             // =45708
    346c: 93ca7146     	ror	x6, x10, #0x1c
    3470: f2a9dc87     	movk	x7, #0x4ee4, lsl #16
    3474: aa130293     	orr	x19, x20, x19
    3478: cac148a5     	eor	x5, x5, x1, ror #18
    347c: f2d0b7c7     	movk	x7, #0x85be, lsl #32
    3480: 8a080234     	and	x20, x17, x8
    3484: caca88c6     	eor	x6, x6, x10, ror #34
    3488: f2e48627     	movk	x7, #0x2431, lsl #48
    348c: 8b130063     	add	x3, x3, x19
    3490: cac1a4a5     	eor	x5, x5, x1, ror #41
    3494: 8a150153     	and	x19, x10, x21
    3498: 8b070063     	add	x3, x3, x7
    349c: caca9cc6     	eor	x6, x6, x10, ror #39
    34a0: aa140267     	orr	x7, x19, x20
    34a4: d2969c53     	mov	x19, #0xb4e2            // =46306
    34a8: 8b050065     	add	x5, x3, x5
    34ac: f2babff3     	movk	x19, #0xd5ff, lsl #16
    34b0: 8b0700c6     	add	x6, x6, x7
    34b4: 8b1200a3     	add	x3, x5, x18
    34b8: f2cfb873     	movk	x19, #0x7dc3, lsl #32
    34bc: 8b0500d2     	add	x18, x6, x5
    34c0: a9459be7     	ldp	x7, x6, [sp, #0x58]
    34c4: 93c33865     	ror	x5, x3, #0xe
    34c8: 8a230054     	bic	x20, x2, x3
    34cc: 8a030035     	and	x21, x1, x3
    34d0: aa1402b4     	orr	x20, x21, x20
    34d4: aa110155     	orr	x21, x10, x17
    34d8: f2eaa193     	movk	x19, #0x550c, lsl #48
    34dc: 8b0400e4     	add	x4, x7, x4
    34e0: 93d27247     	ror	x7, x18, #0x1c
    34e4: cac348a5     	eor	x5, x5, x3, ror #18
    34e8: 8b140084     	add	x4, x4, x20
    34ec: 8a110154     	and	x20, x10, x17
    34f0: 8a150255     	and	x21, x18, x21
    34f4: cad288e7     	eor	x7, x7, x18, ror #34
    34f8: cac3a4a5     	eor	x5, x5, x3, ror #41
    34fc: 8b130084     	add	x4, x4, x19
    3500: aa1402b3     	orr	x19, x21, x20
    3504: 8b0200c2     	add	x2, x6, x2
    3508: aa0a0255     	orr	x21, x18, x10
    350c: cad29ce7     	eor	x7, x7, x18, ror #39
    3510: 8b050085     	add	x5, x4, x5
    3514: 8b0800a4     	add	x4, x5, x8
    3518: 8b1300e7     	add	x7, x7, x19
    351c: 8a240033     	bic	x19, x1, x4
    3520: 8a040074     	and	x20, x3, x4
    3524: 8b0500e8     	add	x8, x7, x5
    3528: 93c43885     	ror	x5, x4, #0xe
    352c: d2912de7     	mov	x7, #0x896f             // =35183
    3530: 93c87106     	ror	x6, x8, #0x1c
    3534: f2be4f67     	movk	x7, #0xf27b, lsl #16
    3538: aa130293     	orr	x19, x20, x19
    353c: cac448a5     	eor	x5, x5, x4, ror #18
    3540: f2cbae87     	movk	x7, #0x5d74, lsl #32
    3544: 8a0a0254     	and	x20, x18, x10
    3548: cac888c6     	eor	x6, x6, x8, ror #34
    354c: f2ee57c7     	movk	x7, #0x72be, lsl #48
    3550: 8b130042     	add	x2, x2, x19
    3554: cac4a4a5     	eor	x5, x5, x4, ror #41
    3558: 8a150113     	and	x19, x8, x21
    355c: 8b070042     	add	x2, x2, x7
    3560: cac89cc6     	eor	x6, x6, x8, ror #39
    3564: aa140267     	orr	x7, x19, x20
    3568: d292d633     	mov	x19, #0x96b1            // =38577
    356c: 8b050045     	add	x5, x2, x5
    3570: f2a762d3     	movk	x19, #0x3b16, lsl #16
    3574: 8b0700c6     	add	x6, x6, x7
    3578: 8b1100a2     	add	x2, x5, x17
    357c: f2d63fd3     	movk	x19, #0xb1fe, lsl #32
    3580: 8b0500d1     	add	x17, x6, x5
    3584: a9469be7     	ldp	x7, x6, [sp, #0x68]
    3588: 93c23845     	ror	x5, x2, #0xe
    358c: 8a220074     	bic	x20, x3, x2
    3590: 8a020095     	and	x21, x4, x2
    3594: aa1402b4     	orr	x20, x21, x20
    3598: aa120115     	orr	x21, x8, x18
    359c: f2f01bd3     	movk	x19, #0x80de, lsl #48
    35a0: 8b0100e1     	add	x1, x7, x1
    35a4: 93d17227     	ror	x7, x17, #0x1c
    35a8: cac248a5     	eor	x5, x5, x2, ror #18
    35ac: 8b140021     	add	x1, x1, x20
    35b0: 8a120114     	and	x20, x8, x18
    35b4: 8a150235     	and	x21, x17, x21
    35b8: cad188e7     	eor	x7, x7, x17, ror #34
    35bc: cac2a4a5     	eor	x5, x5, x2, ror #41
    35c0: 8b130021     	add	x1, x1, x19
    35c4: aa1402b3     	orr	x19, x21, x20
    35c8: 8b0300c3     	add	x3, x6, x3
    35cc: aa080235     	orr	x21, x17, x8
    35d0: cad19ce7     	eor	x7, x7, x17, ror #39
    35d4: 8b050025     	add	x5, x1, x5
    35d8: 8b0a00a1     	add	x1, x5, x10
    35dc: 8b1300e7     	add	x7, x7, x19
    35e0: 8a210093     	bic	x19, x4, x1
    35e4: 8a010054     	and	x20, x2, x1
    35e8: 8b0500ea     	add	x10, x7, x5
    35ec: 93c13825     	ror	x5, x1, #0xe
    35f0: d28246a7     	mov	x7, #0x1235             // =4661
    35f4: 93ca7146     	ror	x6, x10, #0x1c
    35f8: f2a4b8e7     	movk	x7, #0x25c7, lsl #16
    35fc: aa130293     	orr	x19, x20, x19
    3600: cac148a5     	eor	x5, x5, x1, ror #18
    3604: f2c0d4e7     	movk	x7, #0x6a7, lsl #32
    3608: 8a080234     	and	x20, x17, x8
    360c: caca88c6     	eor	x6, x6, x10, ror #34
    3610: f2f37b87     	movk	x7, #0x9bdc, lsl #48
    3614: 8b130063     	add	x3, x3, x19
    3618: cac1a4a5     	eor	x5, x5, x1, ror #41
    361c: 8a150153     	and	x19, x10, x21
    3620: 8b070063     	add	x3, x3, x7
    3624: caca9cc6     	eor	x6, x6, x10, ror #39
    3628: aa140267     	orr	x7, x19, x20
    362c: d284d293     	mov	x19, #0x2694            // =9876
    3630: 8b050065     	add	x5, x3, x5
    3634: f2b9ed33     	movk	x19, #0xcf69, lsl #16
    3638: 8b0700c6     	add	x6, x6, x7
    363c: 8b1200a3     	add	x3, x5, x18
    3640: f2de2e93     	movk	x19, #0xf174, lsl #32
    3644: 8b0500d2     	add	x18, x6, x5
    3648: a9479be7     	ldp	x7, x6, [sp, #0x78]
    364c: 93c33865     	ror	x5, x3, #0xe
    3650: 8a230054     	bic	x20, x2, x3
    3654: 8a030035     	and	x21, x1, x3
    3658: aa1402b4     	orr	x20, x21, x20
    365c: aa110155     	orr	x21, x10, x17
    3660: f2f83373     	movk	x19, #0xc19b, lsl #48
    3664: 8b0400e4     	add	x4, x7, x4
    3668: 93d27247     	ror	x7, x18, #0x1c
    366c: cac348a5     	eor	x5, x5, x3, ror #18
    3670: 8b140084     	add	x4, x4, x20
    3674: 8a110154     	and	x20, x10, x17
    3678: 8a150255     	and	x21, x18, x21
    367c: cad288e7     	eor	x7, x7, x18, ror #34
    3680: cac3a4a5     	eor	x5, x5, x3, ror #41
    3684: 8b130084     	add	x4, x4, x19
    3688: aa1402b3     	orr	x19, x21, x20
    368c: 8b0200c2     	add	x2, x6, x2
    3690: aa0a0255     	orr	x21, x18, x10
    3694: cad29ce7     	eor	x7, x7, x18, ror #39
    3698: 8b050085     	add	x5, x4, x5
    369c: 8b0800a4     	add	x4, x5, x8
    36a0: 8b1300e7     	add	x7, x7, x19
    36a4: 8a240033     	bic	x19, x1, x4
    36a8: 8a040074     	and	x20, x3, x4
    36ac: 8b0500e8     	add	x8, x7, x5
    36b0: 93c43885     	ror	x5, x4, #0xe
    36b4: d2895a47     	mov	x7, #0x4ad2             // =19154
    36b8: 93c87106     	ror	x6, x8, #0x1c
    36bc: f2b3de27     	movk	x7, #0x9ef1, lsl #16
    36c0: aa130293     	orr	x19, x20, x19
    36c4: cac448a5     	eor	x5, x5, x4, ror #18
    36c8: f2cd3827     	movk	x7, #0x69c1, lsl #32
    36cc: 8a0a0254     	and	x20, x18, x10
    36d0: cac888c6     	eor	x6, x6, x8, ror #34
    36d4: f2fc9367     	movk	x7, #0xe49b, lsl #48
    36d8: 8b130042     	add	x2, x2, x19
    36dc: cac4a4a5     	eor	x5, x5, x4, ror #41
    36e0: 8a150113     	and	x19, x8, x21
    36e4: 8b070042     	add	x2, x2, x7
    36e8: cac89cc6     	eor	x6, x6, x8, ror #39
    36ec: aa140267     	orr	x7, x19, x20
    36f0: d284bc73     	mov	x19, #0x25e3            // =9699
    36f4: 8b050045     	add	x5, x2, x5
    36f8: f2a709f3     	movk	x19, #0x384f, lsl #16
    36fc: 8b0700c6     	add	x6, x6, x7
    3700: 8b1100a2     	add	x2, x5, x17
    3704: f2c8f0d3     	movk	x19, #0x4786, lsl #32
    3708: 8b0500d1     	add	x17, x6, x5
    370c: a9489be7     	ldp	x7, x6, [sp, #0x88]
    3710: 93c23845     	ror	x5, x2, #0xe
    3714: 8a220074     	bic	x20, x3, x2
    3718: 8a020095     	and	x21, x4, x2
    371c: aa1402b4     	orr	x20, x21, x20
    3720: aa120115     	orr	x21, x8, x18
    3724: f2fdf7d3     	movk	x19, #0xefbe, lsl #48
    3728: 8b0100e1     	add	x1, x7, x1
    372c: 93d17227     	ror	x7, x17, #0x1c
    3730: cac248a5     	eor	x5, x5, x2, ror #18
    3734: 8b140021     	add	x1, x1, x20
    3738: 8a120114     	and	x20, x8, x18
    373c: 8a150235     	and	x21, x17, x21
    3740: cad188e7     	eor	x7, x7, x17, ror #34
    3744: cac2a4a5     	eor	x5, x5, x2, ror #41
    3748: 8b130021     	add	x1, x1, x19
    374c: aa1402b3     	orr	x19, x21, x20
    3750: 8b0300c3     	add	x3, x6, x3
    3754: aa080235     	orr	x21, x17, x8
    3758: cad19ce7     	eor	x7, x7, x17, ror #39
    375c: 8b050025     	add	x5, x1, x5
    3760: 8b0a00a1     	add	x1, x5, x10
    3764: 8b1300e7     	add	x7, x7, x19
    3768: 8a210093     	bic	x19, x4, x1
    376c: 8a010054     	and	x20, x2, x1
    3770: 8b0500ea     	add	x10, x7, x5
    3774: 93c13825     	ror	x5, x1, #0xe
    3778: d29ab6a7     	mov	x7, #0xd5b5             // =54709
    377c: 93ca7146     	ror	x6, x10, #0x1c
    3780: f2b17187     	movk	x7, #0x8b8c, lsl #16
    3784: aa130293     	orr	x19, x20, x19
    3788: cac148a5     	eor	x5, x5, x1, ror #18
    378c: f2d3b8c7     	movk	x7, #0x9dc6, lsl #32
    3790: 8a080234     	and	x20, x17, x8
    3794: caca88c6     	eor	x6, x6, x10, ror #34
    3798: f2e1f827     	movk	x7, #0xfc1, lsl #48
    379c: 8b130063     	add	x3, x3, x19
    37a0: cac1a4a5     	eor	x5, x5, x1, ror #41
    37a4: 8a150153     	and	x19, x10, x21
    37a8: 8b070063     	add	x3, x3, x7
    37ac: caca9cc6     	eor	x6, x6, x10, ror #39
    37b0: aa140267     	orr	x7, x19, x20
    37b4: d2938cb3     	mov	x19, #0x9c65            // =40037
    37b8: 8b050065     	add	x5, x3, x5
    37bc: f2aef593     	movk	x19, #0x77ac, lsl #16
    37c0: 8b0700c6     	add	x6, x6, x7
    37c4: 8b1200a3     	add	x3, x5, x18
    37c8: f2d43993     	movk	x19, #0xa1cc, lsl #32
    37cc: 8b0500d2     	add	x18, x6, x5
    37d0: a9499be7     	ldp	x7, x6, [sp, #0x98]
    37d4: 93c33865     	ror	x5, x3, #0xe
    37d8: 8a230054     	bic	x20, x2, x3
    37dc: 8a030035     	and	x21, x1, x3
    37e0: aa1402b4     	orr	x20, x21, x20
    37e4: aa110155     	orr	x21, x10, x17
    37e8: f2e48193     	movk	x19, #0x240c, lsl #48
    37ec: 8b0400e4     	add	x4, x7, x4
    37f0: 93d27247     	ror	x7, x18, #0x1c
    37f4: cac348a5     	eor	x5, x5, x3, ror #18
    37f8: 8b140084     	add	x4, x4, x20
    37fc: 8a110154     	and	x20, x10, x17
    3800: 8a150255     	and	x21, x18, x21
    3804: cad288e7     	eor	x7, x7, x18, ror #34
    3808: cac3a4a5     	eor	x5, x5, x3, ror #41
    380c: 8b130084     	add	x4, x4, x19
    3810: aa1402b3     	orr	x19, x21, x20
    3814: 8b0200c2     	add	x2, x6, x2
    3818: aa0a0255     	orr	x21, x18, x10
    381c: cad29ce7     	eor	x7, x7, x18, ror #39
    3820: 8b050085     	add	x5, x4, x5
    3824: 8b0800a4     	add	x4, x5, x8
    3828: 8b1300e7     	add	x7, x7, x19
    382c: 8a240033     	bic	x19, x1, x4
    3830: 8a040074     	and	x20, x3, x4
    3834: 8b0500e8     	add	x8, x7, x5
    3838: 93c43885     	ror	x5, x4, #0xe
    383c: d2804ea7     	mov	x7, #0x275              // =629
    3840: 93c87106     	ror	x6, x8, #0x1c
    3844: f2ab2567     	movk	x7, #0x592b, lsl #16
    3848: aa130293     	orr	x19, x20, x19
    384c: cac448a5     	eor	x5, x5, x4, ror #18
    3850: f2c58de7     	movk	x7, #0x2c6f, lsl #32
    3854: 8a0a0254     	and	x20, x18, x10
    3858: cac888c6     	eor	x6, x6, x8, ror #34
    385c: f2e5bd27     	movk	x7, #0x2de9, lsl #48
    3860: 8b130042     	add	x2, x2, x19
    3864: cac4a4a5     	eor	x5, x5, x4, ror #41
    3868: 8a150113     	and	x19, x8, x21
    386c: 8b070042     	add	x2, x2, x7
    3870: cac89cc6     	eor	x6, x6, x8, ror #39
    3874: aa140267     	orr	x7, x19, x20
    3878: d29c9073     	mov	x19, #0xe483            // =58499
    387c: 8b050045     	add	x5, x2, x5
    3880: f2add4d3     	movk	x19, #0x6ea6, lsl #16
    3884: 8b0700c6     	add	x6, x6, x7
    3888: 8b1100a2     	add	x2, x5, x17
    388c: f2d09553     	movk	x19, #0x84aa, lsl #32
    3890: 8b0500d1     	add	x17, x6, x5
    3894: a94a9be7     	ldp	x7, x6, [sp, #0xa8]
    3898: 93c23845     	ror	x5, x2, #0xe
    389c: 8a220074     	bic	x20, x3, x2
    38a0: 8a020095     	and	x21, x4, x2
    38a4: aa1402b4     	orr	x20, x21, x20
    38a8: aa120115     	orr	x21, x8, x18
    38ac: f2e94e93     	movk	x19, #0x4a74, lsl #48
    38b0: 8b0100e1     	add	x1, x7, x1
    38b4: 93d17227     	ror	x7, x17, #0x1c
    38b8: cac248a5     	eor	x5, x5, x2, ror #18
    38bc: 8b140021     	add	x1, x1, x20
    38c0: 8a120114     	and	x20, x8, x18
    38c4: 8a150235     	and	x21, x17, x21
    38c8: cad188e7     	eor	x7, x7, x17, ror #34
    38cc: cac2a4a5     	eor	x5, x5, x2, ror #41
    38d0: 8b130021     	add	x1, x1, x19
    38d4: aa1402b3     	orr	x19, x21, x20
    38d8: 8b0300c3     	add	x3, x6, x3
    38dc: aa080235     	orr	x21, x17, x8
    38e0: cad19ce7     	eor	x7, x7, x17, ror #39
    38e4: 8b050025     	add	x5, x1, x5
    38e8: 8b0a00a1     	add	x1, x5, x10
    38ec: 8b1300e7     	add	x7, x7, x19
    38f0: 8a210093     	bic	x19, x4, x1
    38f4: 8a010054     	and	x20, x2, x1
    38f8: 8b0500ea     	add	x10, x7, x5
    38fc: 93c13825     	ror	x5, x1, #0xe
    3900: d29f7a87     	mov	x7, #0xfbd4             // =64468
    3904: 93ca7146     	ror	x6, x10, #0x1c
    3908: f2b7a827     	movk	x7, #0xbd41, lsl #16
    390c: aa130293     	orr	x19, x20, x19
    3910: cac148a5     	eor	x5, x5, x1, ror #18
    3914: f2d53b87     	movk	x7, #0xa9dc, lsl #32
    3918: 8a080234     	and	x20, x17, x8
    391c: caca88c6     	eor	x6, x6, x10, ror #34
    3920: f2eb9607     	movk	x7, #0x5cb0, lsl #48
    3924: 8b130063     	add	x3, x3, x19
    3928: cac1a4a5     	eor	x5, x5, x1, ror #41
    392c: 8a150153     	and	x19, x10, x21
    3930: 8b070063     	add	x3, x3, x7
    3934: caca9cc6     	eor	x6, x6, x10, ror #39
    3938: aa140267     	orr	x7, x19, x20
    393c: d28a76b3     	mov	x19, #0x53b5            // =21429
    3940: 8b050065     	add	x5, x3, x5
    3944: f2b06233     	movk	x19, #0x8311, lsl #16
    3948: 8b0700c6     	add	x6, x6, x7
    394c: 8b1200a3     	add	x3, x5, x18
    3950: f2d11b53     	movk	x19, #0x88da, lsl #32
    3954: 8b0500d2     	add	x18, x6, x5
    3958: a94b9be7     	ldp	x7, x6, [sp, #0xb8]
    395c: 93c33865     	ror	x5, x3, #0xe
    3960: 8a230054     	bic	x20, x2, x3
    3964: 8a030035     	and	x21, x1, x3
    3968: aa1402b4     	orr	x20, x21, x20
    396c: aa110155     	orr	x21, x10, x17
    3970: f2eedf33     	movk	x19, #0x76f9, lsl #48
    3974: 8b0400e4     	add	x4, x7, x4
    3978: 93d27247     	ror	x7, x18, #0x1c
    397c: cac348a5     	eor	x5, x5, x3, ror #18
    3980: 8b140084     	add	x4, x4, x20
    3984: 8a110154     	and	x20, x10, x17
    3988: 8a150255     	and	x21, x18, x21
    398c: cad288e7     	eor	x7, x7, x18, ror #34
    3990: cac3a4a5     	eor	x5, x5, x3, ror #41
    3994: 8b130084     	add	x4, x4, x19
    3998: aa1402b3     	orr	x19, x21, x20
    399c: 8b0200c2     	add	x2, x6, x2
    39a0: aa0a0255     	orr	x21, x18, x10
    39a4: cad29ce7     	eor	x7, x7, x18, ror #39
    39a8: 8b050085     	add	x5, x4, x5
    39ac: 8b0800a4     	add	x4, x5, x8
    39b0: 8b1300e7     	add	x7, x7, x19
    39b4: 8a240033     	bic	x19, x1, x4
    39b8: 8a040074     	and	x20, x3, x4
    39bc: 8b0500e8     	add	x8, x7, x5
    39c0: 93c43885     	ror	x5, x4, #0xe
    39c4: d29bf567     	mov	x7, #0xdfab             // =57259
    39c8: 93c87106     	ror	x6, x8, #0x1c
    39cc: f2bdccc7     	movk	x7, #0xee66, lsl #16
    39d0: aa130293     	orr	x19, x20, x19
    39d4: cac448a5     	eor	x5, x5, x4, ror #18
    39d8: f2ca2a47     	movk	x7, #0x5152, lsl #32
    39dc: 8a0a0254     	and	x20, x18, x10
    39e0: cac888c6     	eor	x6, x6, x8, ror #34
    39e4: f2f307c7     	movk	x7, #0x983e, lsl #48
    39e8: 8b130042     	add	x2, x2, x19
    39ec: cac4a4a5     	eor	x5, x5, x4, ror #41
    39f0: 8a150113     	and	x19, x8, x21
    39f4: 8b070042     	add	x2, x2, x7
    39f8: cac89cc6     	eor	x6, x6, x8, ror #39
    39fc: aa140267     	orr	x7, x19, x20
    3a00: d2864213     	mov	x19, #0x3210            // =12816
    3a04: 8b050045     	add	x5, x2, x5
    3a08: f2a5b693     	movk	x19, #0x2db4, lsl #16
    3a0c: 8b0700c6     	add	x6, x6, x7
    3a10: 8b1100a2     	add	x2, x5, x17
    3a14: f2d8cdb3     	movk	x19, #0xc66d, lsl #32
    3a18: 8b0500d1     	add	x17, x6, x5
    3a1c: a94c9be7     	ldp	x7, x6, [sp, #0xc8]
    3a20: 93c23845     	ror	x5, x2, #0xe
    3a24: 8a220074     	bic	x20, x3, x2
    3a28: 8a020095     	and	x21, x4, x2
    3a2c: aa1402b4     	orr	x20, x21, x20
    3a30: aa120115     	orr	x21, x8, x18
    3a34: f2f50633     	movk	x19, #0xa831, lsl #48
    3a38: 8b0100e1     	add	x1, x7, x1
    3a3c: 93d17227     	ror	x7, x17, #0x1c
    3a40: cac248a5     	eor	x5, x5, x2, ror #18
    3a44: 8b140021     	add	x1, x1, x20
    3a48: 8a120114     	and	x20, x8, x18
    3a4c: 8a150235     	and	x21, x17, x21
    3a50: cad188e7     	eor	x7, x7, x17, ror #34
    3a54: cac2a4a5     	eor	x5, x5, x2, ror #41
    3a58: 8b130021     	add	x1, x1, x19
    3a5c: aa1402b3     	orr	x19, x21, x20
    3a60: 8b0300c3     	add	x3, x6, x3
    3a64: aa080235     	orr	x21, x17, x8
    3a68: cad19ce7     	eor	x7, x7, x17, ror #39
    3a6c: 8b050025     	add	x5, x1, x5
    3a70: 8b0a00a1     	add	x1, x5, x10
    3a74: 8b1300e7     	add	x7, x7, x19
    3a78: 8a210093     	bic	x19, x4, x1
    3a7c: 8a010054     	and	x20, x2, x1
    3a80: 8b0500ea     	add	x10, x7, x5
    3a84: 93c13825     	ror	x5, x1, #0xe
    3a88: d28427e7     	mov	x7, #0x213f             // =8511
    3a8c: 93ca7146     	ror	x6, x10, #0x1c
    3a90: f2b31f67     	movk	x7, #0x98fb, lsl #16
    3a94: aa130293     	orr	x19, x20, x19
    3a98: cac148a5     	eor	x5, x5, x1, ror #18
    3a9c: f2c4f907     	movk	x7, #0x27c8, lsl #32
    3aa0: 8a080234     	and	x20, x17, x8
    3aa4: caca88c6     	eor	x6, x6, x10, ror #34
    3aa8: f2f60067     	movk	x7, #0xb003, lsl #48
    3aac: 8b130063     	add	x3, x3, x19
    3ab0: cac1a4a5     	eor	x5, x5, x1, ror #41
    3ab4: 8a150153     	and	x19, x10, x21
    3ab8: 8b070063     	add	x3, x3, x7
    3abc: caca9cc6     	eor	x6, x6, x10, ror #39
    3ac0: aa140267     	orr	x7, x19, x20
    3ac4: d281dc93     	mov	x19, #0xee4             // =3812
    3ac8: 8b050065     	add	x5, x3, x5
    3acc: f2b7ddf3     	movk	x19, #0xbeef, lsl #16
    3ad0: 8b0700c6     	add	x6, x6, x7
    3ad4: 8b1200a3     	add	x3, x5, x18
    3ad8: f2cff8f3     	movk	x19, #0x7fc7, lsl #32
    3adc: 8b0500d2     	add	x18, x6, x5
    3ae0: a94d9be7     	ldp	x7, x6, [sp, #0xd8]
    3ae4: 93c33865     	ror	x5, x3, #0xe
    3ae8: 8a230054     	bic	x20, x2, x3
    3aec: 8a030035     	and	x21, x1, x3
    3af0: aa1402b4     	orr	x20, x21, x20
    3af4: aa110155     	orr	x21, x10, x17
    3af8: f2f7eb33     	movk	x19, #0xbf59, lsl #48
    3afc: 8b0400e4     	add	x4, x7, x4
    3b00: 93d27247     	ror	x7, x18, #0x1c
    3b04: cac348a5     	eor	x5, x5, x3, ror #18
    3b08: 8b140084     	add	x4, x4, x20
    3b0c: 8a110154     	and	x20, x10, x17
    3b10: 8a150255     	and	x21, x18, x21
    3b14: cad288e7     	eor	x7, x7, x18, ror #34
    3b18: cac3a4a5     	eor	x5, x5, x3, ror #41
    3b1c: 8b130084     	add	x4, x4, x19
    3b20: aa1402b3     	orr	x19, x21, x20
    3b24: 8b0200c2     	add	x2, x6, x2
    3b28: aa0a0255     	orr	x21, x18, x10
    3b2c: cad29ce7     	eor	x7, x7, x18, ror #39
    3b30: 8b050085     	add	x5, x4, x5
    3b34: 8b0800a4     	add	x4, x5, x8
    3b38: 8b1300e7     	add	x7, x7, x19
    3b3c: 8a240033     	bic	x19, x1, x4
    3b40: 8a040074     	and	x20, x3, x4
    3b44: 8b0500e8     	add	x8, x7, x5
    3b48: 93c43885     	ror	x5, x4, #0xe
    3b4c: d291f847     	mov	x7, #0x8fc2             // =36802
    3b50: 93c87106     	ror	x6, x8, #0x1c
    3b54: f2a7b507     	movk	x7, #0x3da8, lsl #16
    3b58: aa130293     	orr	x19, x20, x19
    3b5c: cac448a5     	eor	x5, x5, x4, ror #18
    3b60: f2c17e67     	movk	x7, #0xbf3, lsl #32
    3b64: 8a0a0254     	and	x20, x18, x10
    3b68: cac888c6     	eor	x6, x6, x8, ror #34
    3b6c: f2f8dc07     	movk	x7, #0xc6e0, lsl #48
    3b70: 8b130042     	add	x2, x2, x19
    3b74: cac4a4a5     	eor	x5, x5, x4, ror #41
    3b78: 8a150113     	and	x19, x8, x21
    3b7c: 8b070042     	add	x2, x2, x7
    3b80: cac89cc6     	eor	x6, x6, x8, ror #39
    3b84: aa140267     	orr	x7, x19, x20
    3b88: d294e4b3     	mov	x19, #0xa725            // =42789
    3b8c: 8b050045     	add	x5, x2, x5
    3b90: f2b26153     	movk	x19, #0x930a, lsl #16
    3b94: 8b0700c6     	add	x6, x6, x7
    3b98: 8b1100a2     	add	x2, x5, x17
    3b9c: f2d228f3     	movk	x19, #0x9147, lsl #32
    3ba0: 8b0500d1     	add	x17, x6, x5
    3ba4: a94e9be7     	ldp	x7, x6, [sp, #0xe8]
    3ba8: 93c23845     	ror	x5, x2, #0xe
    3bac: 8a220074     	bic	x20, x3, x2
    3bb0: 8a020095     	and	x21, x4, x2
    3bb4: aa1402b4     	orr	x20, x21, x20
    3bb8: aa120115     	orr	x21, x8, x18
    3bbc: f2fab4f3     	movk	x19, #0xd5a7, lsl #48
    3bc0: 8b0100e1     	add	x1, x7, x1
    3bc4: 93d17227     	ror	x7, x17, #0x1c
    3bc8: cac248a5     	eor	x5, x5, x2, ror #18
    3bcc: 8b140021     	add	x1, x1, x20
    3bd0: 8a120114     	and	x20, x8, x18
    3bd4: 8a150235     	and	x21, x17, x21
    3bd8: cad188e7     	eor	x7, x7, x17, ror #34
    3bdc: cac2a4a5     	eor	x5, x5, x2, ror #41
    3be0: 8b130021     	add	x1, x1, x19
    3be4: aa1402b3     	orr	x19, x21, x20
    3be8: 8b0300c3     	add	x3, x6, x3
    3bec: aa080235     	orr	x21, x17, x8
    3bf0: cad19ce7     	eor	x7, x7, x17, ror #39
    3bf4: 8b050025     	add	x5, x1, x5
    3bf8: 8b0a00a1     	add	x1, x5, x10
    3bfc: 8b1300e7     	add	x7, x7, x19
    3c00: 8a210093     	bic	x19, x4, x1
    3c04: 8a010054     	and	x20, x2, x1
    3c08: 8b0500ea     	add	x10, x7, x5
    3c0c: 93c13825     	ror	x5, x1, #0xe
    3c10: d2904de7     	mov	x7, #0x826f             // =33391
    3c14: 93ca7146     	ror	x6, x10, #0x1c
    3c18: f2bc0067     	movk	x7, #0xe003, lsl #16
    3c1c: aa130293     	orr	x19, x20, x19
    3c20: cac148a5     	eor	x5, x5, x1, ror #18
    3c24: f2cc6a27     	movk	x7, #0x6351, lsl #32
    3c28: 8a080234     	and	x20, x17, x8
    3c2c: caca88c6     	eor	x6, x6, x10, ror #34
    3c30: f2e0d947     	movk	x7, #0x6ca, lsl #48
    3c34: 8b130063     	add	x3, x3, x19
    3c38: cac1a4a5     	eor	x5, x5, x1, ror #41
    3c3c: 8a150153     	and	x19, x10, x21
    3c40: 8b070063     	add	x3, x3, x7
    3c44: caca9cc6     	eor	x6, x6, x10, ror #39
    3c48: aa140267     	orr	x7, x19, x20
    3c4c: d28dce13     	mov	x19, #0x6e70            // =28272
    3c50: 8b050065     	add	x5, x3, x5
    3c54: f2a141d3     	movk	x19, #0xa0e, lsl #16
    3c58: 8b0700c6     	add	x6, x6, x7
    3c5c: 8b1200a3     	add	x3, x5, x18
    3c60: f2c52cf3     	movk	x19, #0x2967, lsl #32
    3c64: 8b0500d2     	add	x18, x6, x5
    3c68: a94f9be7     	ldp	x7, x6, [sp, #0xf8]
    3c6c: 93c33865     	ror	x5, x3, #0xe
    3c70: 8a230054     	bic	x20, x2, x3
    3c74: 8a030035     	and	x21, x1, x3
    3c78: aa1402b4     	orr	x20, x21, x20
    3c7c: aa110155     	orr	x21, x10, x17
    3c80: f2e28533     	movk	x19, #0x1429, lsl #48
    3c84: 8b0400e4     	add	x4, x7, x4
    3c88: 93d27247     	ror	x7, x18, #0x1c
    3c8c: cac348a5     	eor	x5, x5, x3, ror #18
    3c90: 8b140084     	add	x4, x4, x20
    3c94: 8a110154     	and	x20, x10, x17
    3c98: 8a150255     	and	x21, x18, x21
    3c9c: cad288e7     	eor	x7, x7, x18, ror #34
    3ca0: cac3a4a5     	eor	x5, x5, x3, ror #41
    3ca4: 8b130084     	add	x4, x4, x19
    3ca8: aa1402b3     	orr	x19, x21, x20
    3cac: 8b0200c2     	add	x2, x6, x2
    3cb0: aa0a0255     	orr	x21, x18, x10
    3cb4: cad29ce7     	eor	x7, x7, x18, ror #39
    3cb8: 8b050085     	add	x5, x4, x5
    3cbc: 8b0800a4     	add	x4, x5, x8
    3cc0: 8b1300e7     	add	x7, x7, x19
    3cc4: 8a240033     	bic	x19, x1, x4
    3cc8: 8a040074     	and	x20, x3, x4
    3ccc: 8b0500e8     	add	x8, x7, x5
    3cd0: 93c43885     	ror	x5, x4, #0xe
    3cd4: d285ff87     	mov	x7, #0x2ffc             // =12284
    3cd8: 93c87106     	ror	x6, x8, #0x1c
    3cdc: f2a8da47     	movk	x7, #0x46d2, lsl #16
    3ce0: aa130293     	orr	x19, x20, x19
    3ce4: cac448a5     	eor	x5, x5, x4, ror #18
    3ce8: f2c150a7     	movk	x7, #0xa85, lsl #32
    3cec: 8a0a0254     	and	x20, x18, x10
    3cf0: cac888c6     	eor	x6, x6, x8, ror #34
    3cf4: f2e4f6e7     	movk	x7, #0x27b7, lsl #48
    3cf8: 8b130042     	add	x2, x2, x19
    3cfc: cac4a4a5     	eor	x5, x5, x4, ror #41
    3d00: 8a150113     	and	x19, x8, x21
    3d04: 8b070042     	add	x2, x2, x7
    3d08: cac89cc6     	eor	x6, x6, x8, ror #39
    3d0c: aa140267     	orr	x7, x19, x20
    3d10: d29924d3     	mov	x19, #0xc926            // =51494
    3d14: 8b050045     	add	x5, x2, x5
    3d18: f2ab84d3     	movk	x19, #0x5c26, lsl #16
    3d1c: 8b0700c6     	add	x6, x6, x7
    3d20: 8b1100a2     	add	x2, x5, x17
    3d24: f2c42713     	movk	x19, #0x2138, lsl #32
    3d28: 8b0500d1     	add	x17, x6, x5
    3d2c: a9509be7     	ldp	x7, x6, [sp, #0x108]
    3d30: 93c23845     	ror	x5, x2, #0xe
    3d34: 8a220074     	bic	x20, x3, x2
    3d38: 8a020095     	and	x21, x4, x2
    3d3c: aa1402b4     	orr	x20, x21, x20
    3d40: aa120115     	orr	x21, x8, x18
    3d44: f2e5c373     	movk	x19, #0x2e1b, lsl #48
    3d48: 8b0100e1     	add	x1, x7, x1
    3d4c: 93d17227     	ror	x7, x17, #0x1c
    3d50: cac248a5     	eor	x5, x5, x2, ror #18
    3d54: 8b140021     	add	x1, x1, x20
    3d58: 8a120114     	and	x20, x8, x18
    3d5c: 8a150235     	and	x21, x17, x21
    3d60: cad188e7     	eor	x7, x7, x17, ror #34
    3d64: cac2a4a5     	eor	x5, x5, x2, ror #41
    3d68: 8b130021     	add	x1, x1, x19
    3d6c: aa1402b3     	orr	x19, x21, x20
    3d70: 8b0300c3     	add	x3, x6, x3
    3d74: aa080235     	orr	x21, x17, x8
    3d78: cad19ce7     	eor	x7, x7, x17, ror #39
    3d7c: 8b050025     	add	x5, x1, x5
    3d80: 8b0a00a1     	add	x1, x5, x10
    3d84: 8b1300e7     	add	x7, x7, x19
    3d88: 8a210093     	bic	x19, x4, x1
    3d8c: 8a010054     	and	x20, x2, x1
    3d90: 8b0500ea     	add	x10, x7, x5
    3d94: 93c13825     	ror	x5, x1, #0xe
    3d98: d2855da7     	mov	x7, #0x2aed             // =10989
    3d9c: 93ca7146     	ror	x6, x10, #0x1c
    3da0: f2ab5887     	movk	x7, #0x5ac4, lsl #16
    3da4: aa130293     	orr	x19, x20, x19
    3da8: cac148a5     	eor	x5, x5, x1, ror #18
    3dac: f2cdbf87     	movk	x7, #0x6dfc, lsl #32
    3db0: 8a080234     	and	x20, x17, x8
    3db4: caca88c6     	eor	x6, x6, x10, ror #34
    3db8: f2e9a587     	movk	x7, #0x4d2c, lsl #48
    3dbc: 8b130063     	add	x3, x3, x19
    3dc0: cac1a4a5     	eor	x5, x5, x1, ror #41
    3dc4: 8a150153     	and	x19, x10, x21
    3dc8: 8b070063     	add	x3, x3, x7
    3dcc: caca9cc6     	eor	x6, x6, x10, ror #39
    3dd0: aa140267     	orr	x7, x19, x20
    3dd4: d2967bf3     	mov	x19, #0xb3df            // =46047
    3dd8: 8b050065     	add	x5, x3, x5
    3ddc: f2b3b2b3     	movk	x19, #0x9d95, lsl #16
    3de0: 8b0700c6     	add	x6, x6, x7
    3de4: 8b1200a3     	add	x3, x5, x18
    3de8: f2c1a273     	movk	x19, #0xd13, lsl #32
    3dec: 8b0500d2     	add	x18, x6, x5
    3df0: a9519be7     	ldp	x7, x6, [sp, #0x118]
    3df4: 93c33865     	ror	x5, x3, #0xe
    3df8: 8a230054     	bic	x20, x2, x3
    3dfc: 8a030035     	and	x21, x1, x3
    3e00: aa1402b4     	orr	x20, x21, x20
    3e04: aa110155     	orr	x21, x10, x17
    3e08: f2ea6713     	movk	x19, #0x5338, lsl #48
    3e0c: 8b0400e4     	add	x4, x7, x4
    3e10: 93d27247     	ror	x7, x18, #0x1c
    3e14: cac348a5     	eor	x5, x5, x3, ror #18
    3e18: 8b140084     	add	x4, x4, x20
    3e1c: 8a110154     	and	x20, x10, x17
    3e20: 8a150255     	and	x21, x18, x21
    3e24: cad288e7     	eor	x7, x7, x18, ror #34
    3e28: cac3a4a5     	eor	x5, x5, x3, ror #41
    3e2c: 8b130084     	add	x4, x4, x19
    3e30: aa1402b3     	orr	x19, x21, x20
    3e34: 8b0200c2     	add	x2, x6, x2
    3e38: aa0a0255     	orr	x21, x18, x10
    3e3c: cad29ce7     	eor	x7, x7, x18, ror #39
    3e40: 8b050085     	add	x5, x4, x5
    3e44: 8b0800a4     	add	x4, x5, x8
    3e48: 8b1300e7     	add	x7, x7, x19
    3e4c: 8a240033     	bic	x19, x1, x4
    3e50: 8a040074     	and	x20, x3, x4
    3e54: 8b0500e8     	add	x8, x7, x5
    3e58: 93c43885     	ror	x5, x4, #0xe
    3e5c: d28c7bc7     	mov	x7, #0x63de             // =25566
    3e60: 93c87106     	ror	x6, x8, #0x1c
    3e64: f2b175e7     	movk	x7, #0x8baf, lsl #16
    3e68: aa130293     	orr	x19, x20, x19
    3e6c: cac448a5     	eor	x5, x5, x4, ror #18
    3e70: f2ce6a87     	movk	x7, #0x7354, lsl #32
    3e74: 8a0a0254     	and	x20, x18, x10
    3e78: cac888c6     	eor	x6, x6, x8, ror #34
    3e7c: f2eca147     	movk	x7, #0x650a, lsl #48
    3e80: 8b130042     	add	x2, x2, x19
    3e84: cac4a4a5     	eor	x5, x5, x4, ror #41
    3e88: 8a150113     	and	x19, x8, x21
    3e8c: 8b070042     	add	x2, x2, x7
    3e90: cac89cc6     	eor	x6, x6, x8, ror #39
    3e94: aa140267     	orr	x7, x19, x20
    3e98: d2965513     	mov	x19, #0xb2a8            // =45736
    3e9c: 8b050045     	add	x5, x2, x5
    3ea0: f2a78ef3     	movk	x19, #0x3c77, lsl #16
    3ea4: 8b0700c6     	add	x6, x6, x7
    3ea8: 8b1100a2     	add	x2, x5, x17
    3eac: f2c15773     	movk	x19, #0xabb, lsl #32
    3eb0: 8b0500d1     	add	x17, x6, x5
    3eb4: a9529be7     	ldp	x7, x6, [sp, #0x128]
    3eb8: 93c23845     	ror	x5, x2, #0xe
    3ebc: 8a220074     	bic	x20, x3, x2
    3ec0: 8a020095     	and	x21, x4, x2
    3ec4: aa1402b4     	orr	x20, x21, x20
    3ec8: aa120115     	orr	x21, x8, x18
    3ecc: f2eecd53     	movk	x19, #0x766a, lsl #48
    3ed0: 8b0100e1     	add	x1, x7, x1
    3ed4: 93d17227     	ror	x7, x17, #0x1c
    3ed8: cac248a5     	eor	x5, x5, x2, ror #18
    3edc: 8b140021     	add	x1, x1, x20
    3ee0: 8a120114     	and	x20, x8, x18
    3ee4: 8a150235     	and	x21, x17, x21
    3ee8: cad188e7     	eor	x7, x7, x17, ror #34
    3eec: cac2a4a5     	eor	x5, x5, x2, ror #41
    3ef0: 8b130021     	add	x1, x1, x19
    3ef4: aa1402b3     	orr	x19, x21, x20
    3ef8: 8b0300c3     	add	x3, x6, x3
    3efc: aa080235     	orr	x21, x17, x8
    3f00: cad19ce7     	eor	x7, x7, x17, ror #39
    3f04: 8b050025     	add	x5, x1, x5
    3f08: 8b0a00a1     	add	x1, x5, x10
    3f0c: 8b1300e7     	add	x7, x7, x19
    3f10: 8a210093     	bic	x19, x4, x1
    3f14: 8a010054     	and	x20, x2, x1
    3f18: 8b0500ea     	add	x10, x7, x5
    3f1c: 93c13825     	ror	x5, x1, #0xe
    3f20: d295dcc7     	mov	x7, #0xaee6             // =44774
    3f24: 93ca7146     	ror	x6, x10, #0x1c
    3f28: f2a8fda7     	movk	x7, #0x47ed, lsl #16
    3f2c: aa130293     	orr	x19, x20, x19
    3f30: cac148a5     	eor	x5, x5, x1, ror #18
    3f34: f2d925c7     	movk	x7, #0xc92e, lsl #32
    3f38: 8a080234     	and	x20, x17, x8
    3f3c: caca88c6     	eor	x6, x6, x10, ror #34
    3f40: f2f03847     	movk	x7, #0x81c2, lsl #48
    3f44: 8b130063     	add	x3, x3, x19
    3f48: cac1a4a5     	eor	x5, x5, x1, ror #41
    3f4c: 8a150153     	and	x19, x10, x21
    3f50: 8b070063     	add	x3, x3, x7
    3f54: caca9cc6     	eor	x6, x6, x10, ror #39
    3f58: aa140267     	orr	x7, x19, x20
    3f5c: d286a773     	mov	x19, #0x353b            // =13627
    3f60: 8b050065     	add	x5, x3, x5
    3f64: f2a29053     	movk	x19, #0x1482, lsl #16
    3f68: 8b0700c6     	add	x6, x6, x7
    3f6c: 8b1200a3     	add	x3, x5, x18
    3f70: f2c590b3     	movk	x19, #0x2c85, lsl #32
    3f74: 8b0500d2     	add	x18, x6, x5
    3f78: a9539be7     	ldp	x7, x6, [sp, #0x138]
    3f7c: 93c33865     	ror	x5, x3, #0xe
    3f80: 8a230054     	bic	x20, x2, x3
    3f84: 8a030035     	and	x21, x1, x3
    3f88: aa1402b4     	orr	x20, x21, x20
    3f8c: aa110155     	orr	x21, x10, x17
    3f90: f2f24e53     	movk	x19, #0x9272, lsl #48
    3f94: 8b0400e4     	add	x4, x7, x4
    3f98: 93d27247     	ror	x7, x18, #0x1c
    3f9c: cac348a5     	eor	x5, x5, x3, ror #18
    3fa0: 8b140084     	add	x4, x4, x20
    3fa4: 8a110154     	and	x20, x10, x17
    3fa8: 8a150255     	and	x21, x18, x21
    3fac: cad288e7     	eor	x7, x7, x18, ror #34
    3fb0: cac3a4a5     	eor	x5, x5, x3, ror #41
    3fb4: 8b130084     	add	x4, x4, x19
    3fb8: aa1402b3     	orr	x19, x21, x20
    3fbc: 8b0200c2     	add	x2, x6, x2
    3fc0: aa0a0255     	orr	x21, x18, x10
    3fc4: cad29ce7     	eor	x7, x7, x18, ror #39
    3fc8: 8b050085     	add	x5, x4, x5
    3fcc: 8b0800a4     	add	x4, x5, x8
    3fd0: 8b1300e7     	add	x7, x7, x19
    3fd4: 8a240033     	bic	x19, x1, x4
    3fd8: 8a040074     	and	x20, x3, x4
    3fdc: 8b0500e8     	add	x8, x7, x5
    3fe0: 93c43885     	ror	x5, x4, #0xe
    3fe4: d2806c87     	mov	x7, #0x364              // =868
    3fe8: 93c87106     	ror	x6, x8, #0x1c
    3fec: f2a99e27     	movk	x7, #0x4cf1, lsl #16
    3ff0: aa130293     	orr	x19, x20, x19
    3ff4: cac448a5     	eor	x5, x5, x4, ror #18
    3ff8: f2dd1427     	movk	x7, #0xe8a1, lsl #32
    3ffc: 8a0a0254     	and	x20, x18, x10
    4000: cac888c6     	eor	x6, x6, x8, ror #34
    4004: f2f457e7     	movk	x7, #0xa2bf, lsl #48
    4008: 8b130042     	add	x2, x2, x19
    400c: cac4a4a5     	eor	x5, x5, x4, ror #41
    4010: 8a150113     	and	x19, x8, x21
    4014: 8b070042     	add	x2, x2, x7
    4018: cac89cc6     	eor	x6, x6, x8, ror #39
    401c: aa140267     	orr	x7, x19, x20
    4020: d2860033     	mov	x19, #0x3001            // =12289
    4024: 8b050045     	add	x5, x2, x5
    4028: f2b78853     	movk	x19, #0xbc42, lsl #16
    402c: 8b0700c6     	add	x6, x6, x7
    4030: 8b1100a2     	add	x2, x5, x17
    4034: f2ccc973     	movk	x19, #0x664b, lsl #32
    4038: 8b0500d1     	add	x17, x6, x5
    403c: a9549be7     	ldp	x7, x6, [sp, #0x148]
    4040: 93c23845     	ror	x5, x2, #0xe
    4044: 8a220074     	bic	x20, x3, x2
    4048: 8a020095     	and	x21, x4, x2
    404c: aa1402b4     	orr	x20, x21, x20
    4050: aa120115     	orr	x21, x8, x18
    4054: f2f50353     	movk	x19, #0xa81a, lsl #48
    4058: 8b0100e1     	add	x1, x7, x1
    405c: 93d17227     	ror	x7, x17, #0x1c
    4060: cac248a5     	eor	x5, x5, x2, ror #18
    4064: 8b140021     	add	x1, x1, x20
    4068: 8a120114     	and	x20, x8, x18
    406c: 8a150235     	and	x21, x17, x21
    4070: cad188e7     	eor	x7, x7, x17, ror #34
    4074: cac2a4a5     	eor	x5, x5, x2, ror #41
    4078: 8b130021     	add	x1, x1, x19
    407c: aa1402b3     	orr	x19, x21, x20
    4080: 8b0300c3     	add	x3, x6, x3
    4084: aa080235     	orr	x21, x17, x8
    4088: cad19ce7     	eor	x7, x7, x17, ror #39
    408c: 8b050025     	add	x5, x1, x5
    4090: 8b0a00a1     	add	x1, x5, x10
    4094: 8b1300e7     	add	x7, x7, x19
    4098: 8a210093     	bic	x19, x4, x1
    409c: 8a010054     	and	x20, x2, x1
    40a0: 8b0500ea     	add	x10, x7, x5
    40a4: 93c13825     	ror	x5, x1, #0xe
    40a8: d292f227     	mov	x7, #0x9791             // =38801
    40ac: 93ca7146     	ror	x6, x10, #0x1c
    40b0: f2ba1f07     	movk	x7, #0xd0f8, lsl #16
    40b4: aa130293     	orr	x19, x20, x19
    40b8: cac148a5     	eor	x5, x5, x1, ror #18
    40bc: f2d16e07     	movk	x7, #0x8b70, lsl #32
    40c0: 8a080234     	and	x20, x17, x8
    40c4: caca88c6     	eor	x6, x6, x10, ror #34
    40c8: f2f84967     	movk	x7, #0xc24b, lsl #48
    40cc: 8b130063     	add	x3, x3, x19
    40d0: cac1a4a5     	eor	x5, x5, x1, ror #41
    40d4: 8a150153     	and	x19, x10, x21
    40d8: 8b070063     	add	x3, x3, x7
    40dc: caca9cc6     	eor	x6, x6, x10, ror #39
    40e0: aa140267     	orr	x7, x19, x20
    40e4: d297c613     	mov	x19, #0xbe30            // =48688
    40e8: 8b050065     	add	x5, x3, x5
    40ec: f2a0ca93     	movk	x19, #0x654, lsl #16
    40f0: 8b0700c6     	add	x6, x6, x7
    40f4: 8b1200a3     	add	x3, x5, x18
    40f8: f2ca3473     	movk	x19, #0x51a3, lsl #32
    40fc: 8b0500d2     	add	x18, x6, x5
    4100: a9559be7     	ldp	x7, x6, [sp, #0x158]
    4104: 93c33865     	ror	x5, x3, #0xe
    4108: 8a230054     	bic	x20, x2, x3
    410c: 8a030035     	and	x21, x1, x3
    4110: aa1402b4     	orr	x20, x21, x20
    4114: aa110155     	orr	x21, x10, x17
    4118: f2f8ed93     	movk	x19, #0xc76c, lsl #48
    411c: 8b0400e4     	add	x4, x7, x4
    4120: 93d27247     	ror	x7, x18, #0x1c
    4124: cac348a5     	eor	x5, x5, x3, ror #18
    4128: 8b140084     	add	x4, x4, x20
    412c: 8a110154     	and	x20, x10, x17
    4130: 8a150255     	and	x21, x18, x21
    4134: cad288e7     	eor	x7, x7, x18, ror #34
    4138: cac3a4a5     	eor	x5, x5, x3, ror #41
    413c: 8b130084     	add	x4, x4, x19
    4140: aa1402b3     	orr	x19, x21, x20
    4144: 8b0200c2     	add	x2, x6, x2
    4148: aa0a0255     	orr	x21, x18, x10
    414c: cad29ce7     	eor	x7, x7, x18, ror #39
    4150: 8b050085     	add	x5, x4, x5
    4154: 8b0800a4     	add	x4, x5, x8
    4158: 8b1300e7     	add	x7, x7, x19
    415c: 8a240033     	bic	x19, x1, x4
    4160: 8a040074     	and	x20, x3, x4
    4164: 8b0500e8     	add	x8, x7, x5
    4168: 93c43885     	ror	x5, x4, #0xe
    416c: d28a4307     	mov	x7, #0x5218             // =21016
    4170: 93c87106     	ror	x6, x8, #0x1c
    4174: f2badde7     	movk	x7, #0xd6ef, lsl #16
    4178: aa130293     	orr	x19, x20, x19
    417c: cac448a5     	eor	x5, x5, x4, ror #18
    4180: f2dd0327     	movk	x7, #0xe819, lsl #32
    4184: 8a0a0254     	and	x20, x18, x10
    4188: cac888c6     	eor	x6, x6, x8, ror #34
    418c: f2fa3247     	movk	x7, #0xd192, lsl #48
    4190: 8b130042     	add	x2, x2, x19
    4194: cac4a4a5     	eor	x5, x5, x4, ror #41
    4198: 8a150113     	and	x19, x8, x21
    419c: 8b070042     	add	x2, x2, x7
    41a0: cac89cc6     	eor	x6, x6, x8, ror #39
    41a4: aa140267     	orr	x7, x19, x20
    41a8: d2952213     	mov	x19, #0xa910            // =43280
    41ac: 8b050045     	add	x5, x2, x5
    41b0: f2aaacb3     	movk	x19, #0x5565, lsl #16
    41b4: 8b0700c6     	add	x6, x6, x7
    41b8: 8b1100a2     	add	x2, x5, x17
    41bc: f2c0c493     	movk	x19, #0x624, lsl #32
    41c0: 8b0500d1     	add	x17, x6, x5
    41c4: a9569be7     	ldp	x7, x6, [sp, #0x168]
    41c8: 93c23845     	ror	x5, x2, #0xe
    41cc: 8a220074     	bic	x20, x3, x2
    41d0: 8a020095     	and	x21, x4, x2
    41d4: aa1402b4     	orr	x20, x21, x20
    41d8: aa120115     	orr	x21, x8, x18
    41dc: f2fad333     	movk	x19, #0xd699, lsl #48
    41e0: 8b0100e1     	add	x1, x7, x1
    41e4: 93d17227     	ror	x7, x17, #0x1c
    41e8: cac248a5     	eor	x5, x5, x2, ror #18
    41ec: 8b140021     	add	x1, x1, x20
    41f0: 8a120114     	and	x20, x8, x18
    41f4: 8a150235     	and	x21, x17, x21
    41f8: cad188e7     	eor	x7, x7, x17, ror #34
    41fc: cac2a4a5     	eor	x5, x5, x2, ror #41
    4200: 8b130021     	add	x1, x1, x19
    4204: aa1402b3     	orr	x19, x21, x20
    4208: 8b0300c3     	add	x3, x6, x3
    420c: aa080235     	orr	x21, x17, x8
    4210: cad19ce7     	eor	x7, x7, x17, ror #39
    4214: 8b050025     	add	x5, x1, x5
    4218: 8b0a00a1     	add	x1, x5, x10
    421c: 8b1300e7     	add	x7, x7, x19
    4220: 8a210093     	bic	x19, x4, x1
    4224: 8a010054     	and	x20, x2, x1
    4228: 8b0500ea     	add	x10, x7, x5
    422c: 93c13825     	ror	x5, x1, #0xe
    4230: d2840547     	mov	x7, #0x202a             // =8234
    4234: 93ca7146     	ror	x6, x10, #0x1c
    4238: f2aaee27     	movk	x7, #0x5771, lsl #16
    423c: aa130293     	orr	x19, x20, x19
    4240: cac148a5     	eor	x5, x5, x1, ror #18
    4244: f2c6b0a7     	movk	x7, #0x3585, lsl #32
    4248: 8a080234     	and	x20, x17, x8
    424c: caca88c6     	eor	x6, x6, x10, ror #34
    4250: f2fe81c7     	movk	x7, #0xf40e, lsl #48
    4254: 8b130063     	add	x3, x3, x19
    4258: cac1a4a5     	eor	x5, x5, x1, ror #41
    425c: 8a150153     	and	x19, x10, x21
    4260: 8b070063     	add	x3, x3, x7
    4264: caca9cc6     	eor	x6, x6, x10, ror #39
    4268: aa140267     	orr	x7, x19, x20
    426c: d29a3713     	mov	x19, #0xd1b8            // =53688
    4270: 8b050065     	add	x5, x3, x5
    4274: f2a65773     	movk	x19, #0x32bb, lsl #16
    4278: 8b0700c6     	add	x6, x6, x7
    427c: 8b1200a3     	add	x3, x5, x18
    4280: f2d40e13     	movk	x19, #0xa070, lsl #32
    4284: 8b0500d2     	add	x18, x6, x5
    4288: a9579be7     	ldp	x7, x6, [sp, #0x178]
    428c: 93c33865     	ror	x5, x3, #0xe
    4290: 8a230054     	bic	x20, x2, x3
    4294: 8a030035     	and	x21, x1, x3
    4298: aa1402b4     	orr	x20, x21, x20
    429c: aa110155     	orr	x21, x10, x17
    42a0: f2e20d53     	movk	x19, #0x106a, lsl #48
    42a4: 8b0400e4     	add	x4, x7, x4
    42a8: 93d27247     	ror	x7, x18, #0x1c
    42ac: cac348a5     	eor	x5, x5, x3, ror #18
    42b0: 8b140084     	add	x4, x4, x20
    42b4: 8a110154     	and	x20, x10, x17
    42b8: 8a150255     	and	x21, x18, x21
    42bc: cad288e7     	eor	x7, x7, x18, ror #34
    42c0: cac3a4a5     	eor	x5, x5, x3, ror #41
    42c4: 8b130084     	add	x4, x4, x19
    42c8: aa1402b3     	orr	x19, x21, x20
    42cc: 8b0200c2     	add	x2, x6, x2
    42d0: aa0a0255     	orr	x21, x18, x10
    42d4: cad29ce7     	eor	x7, x7, x18, ror #39
    42d8: 8b050085     	add	x5, x4, x5
    42dc: 8b0800a4     	add	x4, x5, x8
    42e0: 8b1300e7     	add	x7, x7, x19
    42e4: 8a240033     	bic	x19, x1, x4
    42e8: 8a040074     	and	x20, x3, x4
    42ec: 8b0500e8     	add	x8, x7, x5
    42f0: 93c43885     	ror	x5, x4, #0xe
    42f4: d29a1907     	mov	x7, #0xd0c8             // =53448
    42f8: 93c87106     	ror	x6, x8, #0x1c
    42fc: f2b71a47     	movk	x7, #0xb8d2, lsl #16
    4300: aa130293     	orr	x19, x20, x19
    4304: cac448a5     	eor	x5, x5, x4, ror #18
    4308: f2d822c7     	movk	x7, #0xc116, lsl #32
    430c: 8a0a0254     	and	x20, x18, x10
    4310: cac888c6     	eor	x6, x6, x8, ror #34
    4314: f2e33487     	movk	x7, #0x19a4, lsl #48
    4318: 8b130042     	add	x2, x2, x19
    431c: cac4a4a5     	eor	x5, x5, x4, ror #41
    4320: 8a150113     	and	x19, x8, x21
    4324: 8b070042     	add	x2, x2, x7
    4328: cac89cc6     	eor	x6, x6, x8, ror #39
    432c: aa140267     	orr	x7, x19, x20
    4330: d2956a73     	mov	x19, #0xab53            // =43859
    4334: 8b050045     	add	x5, x2, x5
    4338: f2aa2833     	movk	x19, #0x5141, lsl #16
    433c: 8b0700c6     	add	x6, x6, x7
    4340: 8b1100a2     	add	x2, x5, x17
    4344: f2cd8113     	movk	x19, #0x6c08, lsl #32
    4348: 8b0500d1     	add	x17, x6, x5
    434c: a9589be7     	ldp	x7, x6, [sp, #0x188]
    4350: 93c23845     	ror	x5, x2, #0xe
    4354: 8a220074     	bic	x20, x3, x2
    4358: 8a020095     	and	x21, x4, x2
    435c: aa1402b4     	orr	x20, x21, x20
    4360: aa120115     	orr	x21, x8, x18
    4364: f2e3c6f3     	movk	x19, #0x1e37, lsl #48
    4368: 8b0100e1     	add	x1, x7, x1
    436c: 93d17227     	ror	x7, x17, #0x1c
    4370: cac248a5     	eor	x5, x5, x2, ror #18
    4374: 8b140021     	add	x1, x1, x20
    4378: 8a120114     	and	x20, x8, x18
    437c: 8a150235     	and	x21, x17, x21
    4380: cad188e7     	eor	x7, x7, x17, ror #34
    4384: cac2a4a5     	eor	x5, x5, x2, ror #41
    4388: 8b130021     	add	x1, x1, x19
    438c: aa1402b3     	orr	x19, x21, x20
    4390: 8b0300c3     	add	x3, x6, x3
    4394: aa080235     	orr	x21, x17, x8
    4398: cad19ce7     	eor	x7, x7, x17, ror #39
    439c: 8b050025     	add	x5, x1, x5
    43a0: 8b0a00a1     	add	x1, x5, x10
    43a4: 8b1300e7     	add	x7, x7, x19
    43a8: 8a210093     	bic	x19, x4, x1
    43ac: 8a010054     	and	x20, x2, x1
    43b0: 8b0500ea     	add	x10, x7, x5
    43b4: 93c13825     	ror	x5, x1, #0xe
    43b8: d29d7327     	mov	x7, #0xeb99             // =60313
    43bc: 93ca7146     	ror	x6, x10, #0x1c
    43c0: f2bbf1c7     	movk	x7, #0xdf8e, lsl #16
    43c4: aa130293     	orr	x19, x20, x19
    43c8: cac148a5     	eor	x5, x5, x1, ror #18
    43cc: f2cee987     	movk	x7, #0x774c, lsl #32
    43d0: 8a080234     	and	x20, x17, x8
    43d4: caca88c6     	eor	x6, x6, x10, ror #34
    43d8: f2e4e907     	movk	x7, #0x2748, lsl #48
    43dc: 8b130063     	add	x3, x3, x19
    43e0: cac1a4a5     	eor	x5, x5, x1, ror #41
    43e4: 8a150153     	and	x19, x10, x21
    43e8: 8b070063     	add	x3, x3, x7
    43ec: caca9cc6     	eor	x6, x6, x10, ror #39
    43f0: aa140267     	orr	x7, x19, x20
    43f4: d2891513     	mov	x19, #0x48a8            // =18600
    43f8: 8b050065     	add	x5, x3, x5
    43fc: f2bc3373     	movk	x19, #0xe19b, lsl #16
    4400: 8b0700c6     	add	x6, x6, x7
    4404: 8b1200a3     	add	x3, x5, x18
    4408: f2d796b3     	movk	x19, #0xbcb5, lsl #32
    440c: 8b0500d2     	add	x18, x6, x5
    4410: a9599be7     	ldp	x7, x6, [sp, #0x198]
    4414: 93c33865     	ror	x5, x3, #0xe
    4418: 8a230054     	bic	x20, x2, x3
    441c: 8a030035     	and	x21, x1, x3
    4420: aa1402b4     	orr	x20, x21, x20
    4424: aa110155     	orr	x21, x10, x17
    4428: f2e69613     	movk	x19, #0x34b0, lsl #48
    442c: 8b0400e4     	add	x4, x7, x4
    4430: 93d27247     	ror	x7, x18, #0x1c
    4434: cac348a5     	eor	x5, x5, x3, ror #18
    4438: 8b140084     	add	x4, x4, x20
    443c: 8a110154     	and	x20, x10, x17
    4440: 8a150255     	and	x21, x18, x21
    4444: cad288e7     	eor	x7, x7, x18, ror #34
    4448: cac3a4a5     	eor	x5, x5, x3, ror #41
    444c: 8b130084     	add	x4, x4, x19
    4450: aa1402b3     	orr	x19, x21, x20
    4454: 8b0200c2     	add	x2, x6, x2
    4458: aa0a0255     	orr	x21, x18, x10
    445c: cad29ce7     	eor	x7, x7, x18, ror #39
    4460: 8b050085     	add	x5, x4, x5
    4464: 8b0800a4     	add	x4, x5, x8
    4468: 8b1300e7     	add	x7, x7, x19
    446c: 8a240033     	bic	x19, x1, x4
    4470: 8a040074     	and	x20, x3, x4
    4474: 8b0500e8     	add	x8, x7, x5
    4478: 93c43885     	ror	x5, x4, #0xe
    447c: d28b4c67     	mov	x7, #0x5a63             // =23139
    4480: 93c87106     	ror	x6, x8, #0x1c
    4484: f2b8b927     	movk	x7, #0xc5c9, lsl #16
    4488: aa130293     	orr	x19, x20, x19
    448c: cac448a5     	eor	x5, x5, x4, ror #18
    4490: f2c19667     	movk	x7, #0xcb3, lsl #32
    4494: 8a0a0254     	and	x20, x18, x10
    4498: cac888c6     	eor	x6, x6, x8, ror #34
    449c: f2e72387     	movk	x7, #0x391c, lsl #48
    44a0: 8b130042     	add	x2, x2, x19
    44a4: cac4a4a5     	eor	x5, x5, x4, ror #41
    44a8: 8a150113     	and	x19, x8, x21
    44ac: 8b070042     	add	x2, x2, x7
    44b0: cac89cc6     	eor	x6, x6, x8, ror #39
    44b4: aa140267     	orr	x7, x19, x20
    44b8: d2915973     	mov	x19, #0x8acb            // =35531
    44bc: 8b050045     	add	x5, x2, x5
    44c0: f2bc6833     	movk	x19, #0xe341, lsl #16
    44c4: 8b0700c6     	add	x6, x6, x7
    44c8: 8b1100a2     	add	x2, x5, x17
    44cc: f2d54953     	movk	x19, #0xaa4a, lsl #32
    44d0: 8b0500d1     	add	x17, x6, x5
    44d4: a95a9be7     	ldp	x7, x6, [sp, #0x1a8]
    44d8: 93c23845     	ror	x5, x2, #0xe
    44dc: 8a220074     	bic	x20, x3, x2
    44e0: 8a020095     	and	x21, x4, x2
    44e4: aa1402b4     	orr	x20, x21, x20
    44e8: aa120115     	orr	x21, x8, x18
    44ec: f2e9db13     	movk	x19, #0x4ed8, lsl #48
    44f0: 8b0100e1     	add	x1, x7, x1
    44f4: 93d17227     	ror	x7, x17, #0x1c
    44f8: cac248a5     	eor	x5, x5, x2, ror #18
    44fc: 8b140021     	add	x1, x1, x20
    4500: 8a120114     	and	x20, x8, x18
    4504: 8a150235     	and	x21, x17, x21
    4508: cad188e7     	eor	x7, x7, x17, ror #34
    450c: cac2a4a5     	eor	x5, x5, x2, ror #41
    4510: 8b130021     	add	x1, x1, x19
    4514: aa1402b3     	orr	x19, x21, x20
    4518: 8b0300c3     	add	x3, x6, x3
    451c: aa080235     	orr	x21, x17, x8
    4520: cad19ce7     	eor	x7, x7, x17, ror #39
    4524: 8b050025     	add	x5, x1, x5
    4528: 8b0a00a1     	add	x1, x5, x10
    452c: 8b1300e7     	add	x7, x7, x19
    4530: 8a210093     	bic	x19, x4, x1
    4534: 8a010054     	and	x20, x2, x1
    4538: 8b0500ea     	add	x10, x7, x5
    453c: 93c13825     	ror	x5, x1, #0xe
    4540: d29c6e67     	mov	x7, #0xe373             // =58227
    4544: 93ca7146     	ror	x6, x10, #0x1c
    4548: f2aeec67     	movk	x7, #0x7763, lsl #16
    454c: aa130293     	orr	x19, x20, x19
    4550: cac148a5     	eor	x5, x5, x1, ror #18
    4554: f2d949e7     	movk	x7, #0xca4f, lsl #32
    4558: 8a080234     	and	x20, x17, x8
    455c: caca88c6     	eor	x6, x6, x10, ror #34
    4560: f2eb7387     	movk	x7, #0x5b9c, lsl #48
    4564: 8b130063     	add	x3, x3, x19
    4568: cac1a4a5     	eor	x5, x5, x1, ror #41
    456c: 8a150153     	and	x19, x10, x21
    4570: 8b070063     	add	x3, x3, x7
    4574: caca9cc6     	eor	x6, x6, x10, ror #39
    4578: aa140267     	orr	x7, x19, x20
    457c: d2971473     	mov	x19, #0xb8a3            // =47267
    4580: 8b050065     	add	x5, x3, x5
    4584: f2bad653     	movk	x19, #0xd6b2, lsl #16
    4588: 8b0700c6     	add	x6, x6, x7
    458c: 8b1200a3     	add	x3, x5, x18
    4590: f2cdfe73     	movk	x19, #0x6ff3, lsl #32
    4594: 8b0500d2     	add	x18, x6, x5
    4598: a95b9be7     	ldp	x7, x6, [sp, #0x1b8]
    459c: 93c33865     	ror	x5, x3, #0xe
    45a0: 8a230054     	bic	x20, x2, x3
    45a4: 8a030035     	and	x21, x1, x3
    45a8: aa1402b4     	orr	x20, x21, x20
    45ac: aa110155     	orr	x21, x10, x17
    45b0: f2ed05d3     	movk	x19, #0x682e, lsl #48
    45b4: 8b0400e4     	add	x4, x7, x4
    45b8: 93d27247     	ror	x7, x18, #0x1c
    45bc: cac348a5     	eor	x5, x5, x3, ror #18
    45c0: 8b140084     	add	x4, x4, x20
    45c4: 8a110154     	and	x20, x10, x17
    45c8: 8a150255     	and	x21, x18, x21
    45cc: cad288e7     	eor	x7, x7, x18, ror #34
    45d0: cac3a4a5     	eor	x5, x5, x3, ror #41
    45d4: 8b130084     	add	x4, x4, x19
    45d8: aa1402b3     	orr	x19, x21, x20
    45dc: 8b0200c2     	add	x2, x6, x2
    45e0: aa0a0255     	orr	x21, x18, x10
    45e4: cad29ce7     	eor	x7, x7, x18, ror #39
    45e8: 8b050085     	add	x5, x4, x5
    45ec: 8b0800a4     	add	x4, x5, x8
    45f0: 8b1300e7     	add	x7, x7, x19
    45f4: 8a240033     	bic	x19, x1, x4
    45f8: 8a040074     	and	x20, x3, x4
    45fc: 8b0500e8     	add	x8, x7, x5
    4600: 93c43885     	ror	x5, x4, #0xe
    4604: d2965f87     	mov	x7, #0xb2fc             // =45820
    4608: 93c87106     	ror	x6, x8, #0x1c
    460c: f2abbde7     	movk	x7, #0x5def, lsl #16
    4610: aa130293     	orr	x19, x20, x19
    4614: cac448a5     	eor	x5, x5, x4, ror #18
    4618: f2d05dc7     	movk	x7, #0x82ee, lsl #32
    461c: 8a0a0254     	and	x20, x18, x10
    4620: cac888c6     	eor	x6, x6, x8, ror #34
    4624: f2ee91e7     	movk	x7, #0x748f, lsl #48
    4628: 8b130042     	add	x2, x2, x19
    462c: cac4a4a5     	eor	x5, x5, x4, ror #41
    4630: 8a150113     	and	x19, x8, x21
    4634: 8b070042     	add	x2, x2, x7
    4638: cac89cc6     	eor	x6, x6, x8, ror #39
    463c: aa140267     	orr	x7, x19, x20
    4640: d285ec13     	mov	x19, #0x2f60            // =12128
    4644: 8b050045     	add	x5, x2, x5
    4648: f2a862f3     	movk	x19, #0x4317, lsl #16
    464c: 8b0700c6     	add	x6, x6, x7
    4650: 8b1100a2     	add	x2, x5, x17
    4654: f2cc6df3     	movk	x19, #0x636f, lsl #32
    4658: 8b0500d1     	add	x17, x6, x5
    465c: a95c9be7     	ldp	x7, x6, [sp, #0x1c8]
    4660: 93c23845     	ror	x5, x2, #0xe
    4664: 8a220074     	bic	x20, x3, x2
    4668: 8a020095     	and	x21, x4, x2
    466c: aa1402b4     	orr	x20, x21, x20
    4670: aa120115     	orr	x21, x8, x18
    4674: f2ef14b3     	movk	x19, #0x78a5, lsl #48
    4678: 8b0100e1     	add	x1, x7, x1
    467c: 93d17227     	ror	x7, x17, #0x1c
    4680: cac248a5     	eor	x5, x5, x2, ror #18
    4684: 8b140021     	add	x1, x1, x20
    4688: 8a120114     	and	x20, x8, x18
    468c: 8a150235     	and	x21, x17, x21
    4690: cad188e7     	eor	x7, x7, x17, ror #34
    4694: cac2a4a5     	eor	x5, x5, x2, ror #41
    4698: 8b130021     	add	x1, x1, x19
    469c: aa1402b3     	orr	x19, x21, x20
    46a0: 8b0300c3     	add	x3, x6, x3
    46a4: aa080235     	orr	x21, x17, x8
    46a8: cad19ce7     	eor	x7, x7, x17, ror #39
    46ac: 8b050021     	add	x1, x1, x5
    46b0: 8b0a0025     	add	x5, x1, x10
    46b4: 8b1300e7     	add	x7, x7, x19
    46b8: 8a250093     	bic	x19, x4, x5
    46bc: 8a050054     	and	x20, x2, x5
    46c0: 8b0100ea     	add	x10, x7, x1
    46c4: 93c538a1     	ror	x1, x5, #0xe
    46c8: d2956e47     	mov	x7, #0xab72             // =43890
    46cc: 93ca7146     	ror	x6, x10, #0x1c
    46d0: f2b43e07     	movk	x7, #0xa1f0, lsl #16
    46d4: aa130293     	orr	x19, x20, x19
    46d8: cac54821     	eor	x1, x1, x5, ror #18
    46dc: f2cf0287     	movk	x7, #0x7814, lsl #32
    46e0: 8a080234     	and	x20, x17, x8
    46e4: caca88c6     	eor	x6, x6, x10, ror #34
    46e8: f2f09907     	movk	x7, #0x84c8, lsl #48
    46ec: 8b130063     	add	x3, x3, x19
    46f0: cac5a421     	eor	x1, x1, x5, ror #41
    46f4: 8a150153     	and	x19, x10, x21
    46f8: 8b070063     	add	x3, x3, x7
    46fc: caca9cc6     	eor	x6, x6, x10, ror #39
    4700: aa140267     	orr	x7, x19, x20
    4704: d2873d93     	mov	x19, #0x39ec            // =14828
    4708: 8b010061     	add	x1, x3, x1
    470c: f2a34c93     	movk	x19, #0x1a64, lsl #16
    4710: 8b0700c6     	add	x6, x6, x7
    4714: 8b120023     	add	x3, x1, x18
    4718: f2c04113     	movk	x19, #0x208, lsl #32
    471c: 8b0100d2     	add	x18, x6, x1
    4720: a95d9be7     	ldp	x7, x6, [sp, #0x1d8]
    4724: 93c33861     	ror	x1, x3, #0xe
    4728: 8a230054     	bic	x20, x2, x3
    472c: 8a0300b5     	and	x21, x5, x3
    4730: aa1402b4     	orr	x20, x21, x20
    4734: aa110155     	orr	x21, x10, x17
    4738: f2f198f3     	movk	x19, #0x8cc7, lsl #48
    473c: 8b0400e4     	add	x4, x7, x4
    4740: 93d27247     	ror	x7, x18, #0x1c
    4744: cac34821     	eor	x1, x1, x3, ror #18
    4748: 8b140084     	add	x4, x4, x20
    474c: 8a110154     	and	x20, x10, x17
    4750: 8a150255     	and	x21, x18, x21
    4754: cad288e7     	eor	x7, x7, x18, ror #34
    4758: cac3a421     	eor	x1, x1, x3, ror #41
    475c: 8b130084     	add	x4, x4, x19
    4760: aa1402b3     	orr	x19, x21, x20
    4764: 8b0200c2     	add	x2, x6, x2
    4768: aa0a0255     	orr	x21, x18, x10
    476c: cad29ce7     	eor	x7, x7, x18, ror #39
    4770: 8b010084     	add	x4, x4, x1
    4774: 8b080081     	add	x1, x4, x8
    4778: 8b1300e7     	add	x7, x7, x19
    477c: 8a2100b3     	bic	x19, x5, x1
    4780: 8a010074     	and	x20, x3, x1
    4784: 8b0400e8     	add	x8, x7, x4
    4788: 93c13824     	ror	x4, x1, #0xe
    478c: d283c507     	mov	x7, #0x1e28             // =7720
    4790: 93c87106     	ror	x6, x8, #0x1c
    4794: f2a46c67     	movk	x7, #0x2363, lsl #16
    4798: aa130293     	orr	x19, x20, x19
    479c: cac14884     	eor	x4, x4, x1, ror #18
    47a0: f2dfff47     	movk	x7, #0xfffa, lsl #32
    47a4: 8a0a0254     	and	x20, x18, x10
    47a8: cac888c6     	eor	x6, x6, x8, ror #34
    47ac: f2f217c7     	movk	x7, #0x90be, lsl #48
    47b0: 8b130042     	add	x2, x2, x19
    47b4: cac1a484     	eor	x4, x4, x1, ror #41
    47b8: 8a150113     	and	x19, x8, x21
    47bc: 8b070042     	add	x2, x2, x7
    47c0: cac89cc6     	eor	x6, x6, x8, ror #39
    47c4: aa140267     	orr	x7, x19, x20
    47c8: d297bd33     	mov	x19, #0xbde9            // =48617
    47cc: 8b040044     	add	x4, x2, x4
    47d0: f2bbd053     	movk	x19, #0xde82, lsl #16
    47d4: 8b0700c6     	add	x6, x6, x7
    47d8: 8b110082     	add	x2, x4, x17
    47dc: f2cd9d73     	movk	x19, #0x6ceb, lsl #32
    47e0: 8b0400d1     	add	x17, x6, x4
    47e4: a95e9be7     	ldp	x7, x6, [sp, #0x1e8]
    47e8: 93c23844     	ror	x4, x2, #0xe
    47ec: 8a220074     	bic	x20, x3, x2
    47f0: 8a020035     	and	x21, x1, x2
    47f4: aa1402b4     	orr	x20, x21, x20
    47f8: aa120115     	orr	x21, x8, x18
    47fc: f2f48a13     	movk	x19, #0xa450, lsl #48
    4800: 8b0500e5     	add	x5, x7, x5
    4804: 93d17227     	ror	x7, x17, #0x1c
    4808: cac24884     	eor	x4, x4, x2, ror #18
    480c: 8b1400a5     	add	x5, x5, x20
    4810: 8a120114     	and	x20, x8, x18
    4814: 8a150235     	and	x21, x17, x21
    4818: cad188e7     	eor	x7, x7, x17, ror #34
    481c: cac2a484     	eor	x4, x4, x2, ror #41
    4820: 8b1300a5     	add	x5, x5, x19
    4824: aa1402b3     	orr	x19, x21, x20
    4828: 8b0300c3     	add	x3, x6, x3
    482c: aa080235     	orr	x21, x17, x8
    4830: cad19ce7     	eor	x7, x7, x17, ror #39
    4834: 8b0400a5     	add	x5, x5, x4
    4838: 8b0a00a4     	add	x4, x5, x10
    483c: 8b1300e7     	add	x7, x7, x19
    4840: 8a240033     	bic	x19, x1, x4
    4844: 8a040054     	and	x20, x2, x4
    4848: 8b0500ea     	add	x10, x7, x5
    484c: 93c43885     	ror	x5, x4, #0xe
    4850: d28f22a7     	mov	x7, #0x7915             // =30997
    4854: 93ca7146     	ror	x6, x10, #0x1c
    4858: f2b658c7     	movk	x7, #0xb2c6, lsl #16
    485c: aa130293     	orr	x19, x20, x19
    4860: cac448a5     	eor	x5, x5, x4, ror #18
    4864: f2d47ee7     	movk	x7, #0xa3f7, lsl #32
    4868: 8a080234     	and	x20, x17, x8
    486c: caca88c6     	eor	x6, x6, x10, ror #34
    4870: f2f7df27     	movk	x7, #0xbef9, lsl #48
    4874: 8b130063     	add	x3, x3, x19
    4878: cac4a4a5     	eor	x5, x5, x4, ror #41
    487c: 8a150153     	and	x19, x10, x21
    4880: 8b070063     	add	x3, x3, x7
    4884: caca9cc6     	eor	x6, x6, x10, ror #39
    4888: aa140267     	orr	x7, x19, x20
    488c: 8b050065     	add	x5, x3, x5
    4890: 8b0700c6     	add	x6, x6, x7
    4894: a95fcfe7     	ldp	x7, x19, [sp, #0x1f8]
    4898: 8b1200a3     	add	x3, x5, x18
    489c: 8b0500d2     	add	x18, x6, x5
    48a0: 93c33865     	ror	x5, x3, #0xe
    48a4: 8a230046     	bic	x6, x2, x3
    48a8: 8a030094     	and	x20, x4, x3
    48ac: 93d27255     	ror	x21, x18, #0x1c
    48b0: 8b0100e1     	add	x1, x7, x1
    48b4: d28a6567     	mov	x7, #0x532b             // =21291
    48b8: aa060286     	orr	x6, x20, x6
    48bc: cac348a5     	eor	x5, x5, x3, ror #18
    48c0: f2bc6e47     	movk	x7, #0xe372, lsl #16
    48c4: f2cf1e47     	movk	x7, #0x78f2, lsl #32
    48c8: 8b060021     	add	x1, x1, x6
    48cc: cad28aa6     	eor	x6, x21, x18, ror #34
    48d0: f2f8ce27     	movk	x7, #0xc671, lsl #48
    48d4: aa110154     	orr	x20, x10, x17
    48d8: cac3a4a5     	eor	x5, x5, x3, ror #41
    48dc: 8b070021     	add	x1, x1, x7
    48e0: 8a110147     	and	x7, x10, x17
    48e4: 8a140254     	and	x20, x18, x20
    48e8: cad29cc6     	eor	x6, x6, x18, ror #39
    48ec: aa070287     	orr	x7, x20, x7
    48f0: 8b050025     	add	x5, x1, x5
    48f4: 8b0800a1     	add	x1, x5, x8
    48f8: 8b020262     	add	x2, x19, x2
    48fc: 8b0700c6     	add	x6, x6, x7
    4900: 8a210093     	bic	x19, x4, x1
    4904: 8a010074     	and	x20, x3, x1
    4908: 8b0500c8     	add	x8, x6, x5
    490c: 93c13825     	ror	x5, x1, #0xe
    4910: d28c3386     	mov	x6, #0x619c             // =24988
    4914: 93c87107     	ror	x7, x8, #0x1c
    4918: f2bd44c6     	movk	x6, #0xea26, lsl #16
    491c: aa130293     	orr	x19, x20, x19
    4920: cac148a5     	eor	x5, x5, x1, ror #18
    4924: f2c7d9c6     	movk	x6, #0x3ece, lsl #32
    4928: aa0a0254     	orr	x20, x18, x10
    492c: cac888e7     	eor	x7, x7, x8, ror #34
    4930: f2f944e6     	movk	x6, #0xca27, lsl #48
    4934: 8b130042     	add	x2, x2, x19
    4938: cac1a4a5     	eor	x5, x5, x1, ror #41
    493c: 8a0a0253     	and	x19, x18, x10
    4940: 8a140114     	and	x20, x8, x20
    4944: 8b060042     	add	x2, x2, x6
    4948: cac89ce6     	eor	x6, x7, x8, ror #39
    494c: aa130287     	orr	x7, x20, x19
    4950: 8b050045     	add	x5, x2, x5
    4954: f94107f3     	ldr	x19, [sp, #0x208]
    4958: 8b0700c6     	add	x6, x6, x7
    495c: 8b1100a2     	add	x2, x5, x17
    4960: 8b0500d1     	add	x17, x6, x5
    4964: 93c23845     	ror	x5, x2, #0xe
    4968: d29840e6     	mov	x6, #0xc207             // =49671
    496c: 93d17227     	ror	x7, x17, #0x1c
    4970: f2a43806     	movk	x6, #0x21c0, lsl #16
    4974: 8b040264     	add	x4, x19, x4
    4978: 8a220073     	bic	x19, x3, x2
    497c: 8a020034     	and	x20, x1, x2
    4980: cac248a5     	eor	x5, x5, x2, ror #18
    4984: f2d718e6     	movk	x6, #0xb8c7, lsl #32
    4988: aa130293     	orr	x19, x20, x19
    498c: cad188e7     	eor	x7, x7, x17, ror #34
    4990: f2fa30c6     	movk	x6, #0xd186, lsl #48
    4994: aa120114     	orr	x20, x8, x18
    4998: 8b130084     	add	x4, x4, x19
    499c: cac2a4a5     	eor	x5, x5, x2, ror #41
    49a0: 8a120113     	and	x19, x8, x18
    49a4: 8a140234     	and	x20, x17, x20
    49a8: 8b060084     	add	x4, x4, x6
    49ac: cad19ce6     	eor	x6, x7, x17, ror #39
    49b0: aa130287     	orr	x7, x20, x19
    49b4: 8b050085     	add	x5, x4, x5
    49b8: f9410bf3     	ldr	x19, [sp, #0x210]
    49bc: 8b0700c6     	add	x6, x6, x7
    49c0: 8b0a00a4     	add	x4, x5, x10
    49c4: 8b0500ca     	add	x10, x6, x5
    49c8: 93c43885     	ror	x5, x4, #0xe
    49cc: d29d63c6     	mov	x6, #0xeb1e             // =60190
    49d0: 93ca7147     	ror	x7, x10, #0x1c
    49d4: f2b9bc06     	movk	x6, #0xcde0, lsl #16
    49d8: 8b030263     	add	x3, x19, x3
    49dc: 8a240033     	bic	x19, x1, x4
    49e0: 8a040054     	and	x20, x2, x4
    49e4: cac448a5     	eor	x5, x5, x4, ror #18
    49e8: f2cfbac6     	movk	x6, #0x7dd6, lsl #32
    49ec: aa130293     	orr	x19, x20, x19
    49f0: caca88e7     	eor	x7, x7, x10, ror #34
    49f4: f2fd5b46     	movk	x6, #0xeada, lsl #48
    49f8: aa080234     	orr	x20, x17, x8
    49fc: 8b130063     	add	x3, x3, x19
    4a00: cac4a4a5     	eor	x5, x5, x4, ror #41
    4a04: 8a080233     	and	x19, x17, x8
    4a08: 8a140154     	and	x20, x10, x20
    4a0c: 8b060063     	add	x3, x3, x6
    4a10: caca9ce6     	eor	x6, x7, x10, ror #39
    4a14: aa130287     	orr	x7, x20, x19
    4a18: 8b050065     	add	x5, x3, x5
    4a1c: f9410ff3     	ldr	x19, [sp, #0x218]
    4a20: 8b0700c6     	add	x6, x6, x7
    4a24: 8b1200a3     	add	x3, x5, x18
    4a28: 8b0500d2     	add	x18, x6, x5
    4a2c: 93c33865     	ror	x5, x3, #0xe
    4a30: d29a2f06     	mov	x6, #0xd178             // =53624
    4a34: 93d27247     	ror	x7, x18, #0x1c
    4a38: f2bdcdc6     	movk	x6, #0xee6e, lsl #16
    4a3c: 8b010261     	add	x1, x19, x1
    4a40: 8a230053     	bic	x19, x2, x3
    4a44: 8a030094     	and	x20, x4, x3
    4a48: cac348a5     	eor	x5, x5, x3, ror #18
    4a4c: f2c9efe6     	movk	x6, #0x4f7f, lsl #32
    4a50: aa130293     	orr	x19, x20, x19
    4a54: cad288e7     	eor	x7, x7, x18, ror #34
    4a58: f2feafa6     	movk	x6, #0xf57d, lsl #48
    4a5c: aa110154     	orr	x20, x10, x17
    4a60: 8b130021     	add	x1, x1, x19
    4a64: cac3a4a5     	eor	x5, x5, x3, ror #41
    4a68: 8a110153     	and	x19, x10, x17
    4a6c: 8a140254     	and	x20, x18, x20
    4a70: 8b060021     	add	x1, x1, x6
    4a74: cad29ce6     	eor	x6, x7, x18, ror #39
    4a78: aa130287     	orr	x7, x20, x19
    4a7c: 8b050025     	add	x5, x1, x5
    4a80: f94113f3     	ldr	x19, [sp, #0x220]
    4a84: 8b0700c6     	add	x6, x6, x7
    4a88: 8b0800a1     	add	x1, x5, x8
    4a8c: 8b0500c8     	add	x8, x6, x5
    4a90: 93c13825     	ror	x5, x1, #0xe
    4a94: d28df746     	mov	x6, #0x6fba             // =28602
    4a98: 93c87107     	ror	x7, x8, #0x1c
    4a9c: f2ae42e6     	movk	x6, #0x7217, lsl #16
    4aa0: 8b020262     	add	x2, x19, x2
    4aa4: 8a210093     	bic	x19, x4, x1
    4aa8: 8a010074     	and	x20, x3, x1
    4aac: cac148a5     	eor	x5, x5, x1, ror #18
    4ab0: f2ccf546     	movk	x6, #0x67aa, lsl #32
    4ab4: aa130293     	orr	x19, x20, x19
    4ab8: cac888e7     	eor	x7, x7, x8, ror #34
    4abc: f2e0de06     	movk	x6, #0x6f0, lsl #48
    4ac0: aa0a0254     	orr	x20, x18, x10
    4ac4: 8b130042     	add	x2, x2, x19
    4ac8: cac1a4a5     	eor	x5, x5, x1, ror #41
    4acc: 8a0a0253     	and	x19, x18, x10
    4ad0: 8a140114     	and	x20, x8, x20
    4ad4: 8b060042     	add	x2, x2, x6
    4ad8: cac89ce6     	eor	x6, x7, x8, ror #39
    4adc: aa130287     	orr	x7, x20, x19
    4ae0: 8b050045     	add	x5, x2, x5
    4ae4: f94117f3     	ldr	x19, [sp, #0x228]
    4ae8: 8b0700c6     	add	x6, x6, x7
    4aec: 8b1100a2     	add	x2, x5, x17
    4af0: 8b0500d1     	add	x17, x6, x5
    4af4: 93c23845     	ror	x5, x2, #0xe
    4af8: d29314c6     	mov	x6, #0x98a6             // =39078
    4afc: 93d17227     	ror	x7, x17, #0x1c
    4b00: f2b45906     	movk	x6, #0xa2c8, lsl #16
    4b04: 8b040264     	add	x4, x19, x4
    4b08: 8a220073     	bic	x19, x3, x2
    4b0c: 8a020034     	and	x20, x1, x2
    4b10: cac248a5     	eor	x5, x5, x2, ror #18
    4b14: f2cfb8a6     	movk	x6, #0x7dc5, lsl #32
    4b18: aa130293     	orr	x19, x20, x19
    4b1c: cad188e7     	eor	x7, x7, x17, ror #34
    4b20: f2e14c66     	movk	x6, #0xa63, lsl #48
    4b24: aa120114     	orr	x20, x8, x18
    4b28: 8b130084     	add	x4, x4, x19
    4b2c: cac2a4a5     	eor	x5, x5, x2, ror #41
    4b30: 8a120113     	and	x19, x8, x18
    4b34: 8a140234     	and	x20, x17, x20
    4b38: 8b060084     	add	x4, x4, x6
    4b3c: cad19ce6     	eor	x6, x7, x17, ror #39
    4b40: aa130287     	orr	x7, x20, x19
    4b44: 8b050085     	add	x5, x4, x5
    4b48: f9411bf3     	ldr	x19, [sp, #0x230]
    4b4c: 8b0700c6     	add	x6, x6, x7
    4b50: 8b0a00a4     	add	x4, x5, x10
    4b54: 8b0500ca     	add	x10, x6, x5
    4b58: 93c43885     	ror	x5, x4, #0xe
    4b5c: d281b5c6     	mov	x6, #0xdae              // =3502
    4b60: 93ca7147     	ror	x7, x10, #0x1c
    4b64: f2b7df26     	movk	x6, #0xbef9, lsl #16
    4b68: 8b030263     	add	x3, x19, x3
    4b6c: 8a240033     	bic	x19, x1, x4
    4b70: 8a040054     	and	x20, x2, x4
    4b74: cac448a5     	eor	x5, x5, x4, ror #18
    4b78: f2d30086     	movk	x6, #0x9804, lsl #32
    4b7c: aa130293     	orr	x19, x20, x19
    4b80: caca88e7     	eor	x7, x7, x10, ror #34
    4b84: f2e227e6     	movk	x6, #0x113f, lsl #48
    4b88: aa080234     	orr	x20, x17, x8
    4b8c: 8b130063     	add	x3, x3, x19
    4b90: cac4a4a5     	eor	x5, x5, x4, ror #41
    4b94: 8a080233     	and	x19, x17, x8
    4b98: 8a140154     	and	x20, x10, x20
    4b9c: 8b060063     	add	x3, x3, x6
    4ba0: caca9ce6     	eor	x6, x7, x10, ror #39
    4ba4: aa130287     	orr	x7, x20, x19
    4ba8: 8b050065     	add	x5, x3, x5
    4bac: f9411ff3     	ldr	x19, [sp, #0x238]
    4bb0: 8b0700c6     	add	x6, x6, x7
    4bb4: 8b1200a3     	add	x3, x5, x18
    4bb8: 8b0500d2     	add	x18, x6, x5
    4bbc: 93c33865     	ror	x5, x3, #0xe
    4bc0: d288e366     	mov	x6, #0x471b             // =18203
    4bc4: 93d27247     	ror	x7, x18, #0x1c
    4bc8: f2a26386     	movk	x6, #0x131c, lsl #16
    4bcc: 8b010261     	add	x1, x19, x1
    4bd0: 8a230053     	bic	x19, x2, x3
    4bd4: 8a030094     	and	x20, x4, x3
    4bd8: cac348a5     	eor	x5, x5, x3, ror #18
    4bdc: f2c166a6     	movk	x6, #0xb35, lsl #32
    4be0: aa130293     	orr	x19, x20, x19
    4be4: cad288e7     	eor	x7, x7, x18, ror #34
    4be8: f2e36e26     	movk	x6, #0x1b71, lsl #48
    4bec: aa110154     	orr	x20, x10, x17
    4bf0: 8b130021     	add	x1, x1, x19
    4bf4: cac3a4a5     	eor	x5, x5, x3, ror #41
    4bf8: 8a110153     	and	x19, x10, x17
    4bfc: 8a140254     	and	x20, x18, x20
    4c00: 8b060021     	add	x1, x1, x6
    4c04: cad29ce6     	eor	x6, x7, x18, ror #39
    4c08: aa130287     	orr	x7, x20, x19
    4c0c: 8b050021     	add	x1, x1, x5
    4c10: f94123f3     	ldr	x19, [sp, #0x240]
    4c14: 8b0700c6     	add	x6, x6, x7
    4c18: 8b080025     	add	x5, x1, x8
    4c1c: 8b0100c1     	add	x1, x6, x1
    4c20: 93c538a8     	ror	x8, x5, #0xe
    4c24: d28fb086     	mov	x6, #0x7d84             // =32132
    4c28: 93c17027     	ror	x7, x1, #0x1c
    4c2c: f2a46086     	movk	x6, #0x2304, lsl #16
    4c30: 8b020262     	add	x2, x19, x2
    4c34: 8a250093     	bic	x19, x4, x5
    4c38: 8a050074     	and	x20, x3, x5
    4c3c: cac54908     	eor	x8, x8, x5, ror #18
    4c40: f2cefea6     	movk	x6, #0x77f5, lsl #32
    4c44: aa130293     	orr	x19, x20, x19
    4c48: cac188e7     	eor	x7, x7, x1, ror #34
    4c4c: f2e51b66     	movk	x6, #0x28db, lsl #48
    4c50: aa0a0254     	orr	x20, x18, x10
    4c54: 8b130042     	add	x2, x2, x19
    4c58: cac5a508     	eor	x8, x8, x5, ror #41
    4c5c: 8a0a0253     	and	x19, x18, x10
    4c60: 8a140034     	and	x20, x1, x20
    4c64: 8b060042     	add	x2, x2, x6
    4c68: cac19ce6     	eor	x6, x7, x1, ror #39
    4c6c: aa130287     	orr	x7, x20, x19
    4c70: 8b080048     	add	x8, x2, x8
    4c74: f94127f3     	ldr	x19, [sp, #0x248]
    4c78: 8b0700c6     	add	x6, x6, x7
    4c7c: 8b110102     	add	x2, x8, x17
    4c80: 8b0800d1     	add	x17, x6, x8
    4c84: 93c23848     	ror	x8, x2, #0xe
    4c88: d2849266     	mov	x6, #0x2493             // =9363
    4c8c: 93d17227     	ror	x7, x17, #0x1c
    4c90: f2a818e6     	movk	x6, #0x40c7, lsl #16
    4c94: 8b040264     	add	x4, x19, x4
    4c98: 8a220073     	bic	x19, x3, x2
    4c9c: 8a0200b4     	and	x20, x5, x2
    4ca0: cac24908     	eor	x8, x8, x2, ror #18
    4ca4: f2d56f66     	movk	x6, #0xab7b, lsl #32
    4ca8: aa130293     	orr	x19, x20, x19
    4cac: cad188e7     	eor	x7, x7, x17, ror #34
    4cb0: f2e65946     	movk	x6, #0x32ca, lsl #48
    4cb4: aa120034     	orr	x20, x1, x18
    4cb8: 8b130084     	add	x4, x4, x19
    4cbc: cac2a508     	eor	x8, x8, x2, ror #41
    4cc0: 8a120033     	and	x19, x1, x18
    4cc4: 8a140234     	and	x20, x17, x20
    4cc8: 8b060084     	add	x4, x4, x6
    4ccc: cad19ce6     	eor	x6, x7, x17, ror #39
    4cd0: aa130287     	orr	x7, x20, x19
    4cd4: 8b080088     	add	x8, x4, x8
    4cd8: f9412bf3     	ldr	x19, [sp, #0x250]
    4cdc: 8b0700c6     	add	x6, x6, x7
    4ce0: 8b0a0104     	add	x4, x8, x10
    4ce4: 8b0800ca     	add	x10, x6, x8
    4ce8: 93c43888     	ror	x8, x4, #0xe
    4cec: d297d786     	mov	x6, #0xbebc             // =48828
    4cf0: 93ca7147     	ror	x7, x10, #0x1c
    4cf4: f2a2b926     	movk	x6, #0x15c9, lsl #16
    4cf8: 8b030263     	add	x3, x19, x3
    4cfc: 8a2400b3     	bic	x19, x5, x4
    4d00: 8a040054     	and	x20, x2, x4
    4d04: cac44908     	eor	x8, x8, x4, ror #18
    4d08: f2d7c146     	movk	x6, #0xbe0a, lsl #32
    4d0c: aa130293     	orr	x19, x20, x19
    4d10: caca88e7     	eor	x7, x7, x10, ror #34
    4d14: f2e793c6     	movk	x6, #0x3c9e, lsl #48
    4d18: aa010234     	orr	x20, x17, x1
    4d1c: 8b130063     	add	x3, x3, x19
    4d20: cac4a508     	eor	x8, x8, x4, ror #41
    4d24: 8a010233     	and	x19, x17, x1
    4d28: 8a140154     	and	x20, x10, x20
    4d2c: 8b060063     	add	x3, x3, x6
    4d30: caca9ce6     	eor	x6, x7, x10, ror #39
    4d34: aa130287     	orr	x7, x20, x19
    4d38: 8b080068     	add	x8, x3, x8
    4d3c: f9412fe3     	ldr	x3, [sp, #0x258]
    4d40: 8b0700c6     	add	x6, x6, x7
    4d44: 8b120112     	add	x18, x8, x18
    4d48: d281a987     	mov	x7, #0xd4c              // =3404
    4d4c: 8b0800c8     	add	x8, x6, x8
    4d50: 93d23a46     	ror	x6, x18, #0xe
    4d54: 8b050063     	add	x3, x3, x5
    4d58: 93c87105     	ror	x5, x8, #0x1c
    4d5c: f2b38207     	movk	x7, #0x9c10, lsl #16
    4d60: 8a320053     	bic	x19, x2, x18
    4d64: 8a120094     	and	x20, x4, x18
    4d68: cad248c6     	eor	x6, x6, x18, ror #18
    4d6c: f2ccf887     	movk	x7, #0x67c4, lsl #32
    4d70: aa130293     	orr	x19, x20, x19
    4d74: cac888a5     	eor	x5, x5, x8, ror #34
    4d78: f2e863a7     	movk	x7, #0x431d, lsl #48
    4d7c: aa110154     	orr	x20, x10, x17
    4d80: 8b130063     	add	x3, x3, x19
    4d84: cad2a4c6     	eor	x6, x6, x18, ror #41
    4d88: 8a110153     	and	x19, x10, x17
    4d8c: 8a140114     	and	x20, x8, x20
    4d90: 8b070063     	add	x3, x3, x7
    4d94: cac89ca5     	eor	x5, x5, x8, ror #39
    4d98: aa130287     	orr	x7, x20, x19
    4d9c: 8b060066     	add	x6, x3, x6
    4da0: 8b0100c3     	add	x3, x6, x1
    4da4: f94133f3     	ldr	x19, [sp, #0x260]
    4da8: 8b0700a5     	add	x5, x5, x7
    4dac: 8a030254     	and	x20, x18, x3
    4db0: 8b0600a1     	add	x1, x5, x6
    4db4: 93c33865     	ror	x5, x3, #0xe
    4db8: d28856c6     	mov	x6, #0x42b6             // =17078
    4dbc: 93c17027     	ror	x7, x1, #0x1c
    4dc0: f2b967c6     	movk	x6, #0xcb3e, lsl #16
    4dc4: 8b020262     	add	x2, x19, x2
    4dc8: 8a230093     	bic	x19, x4, x3
    4dcc: cac348a5     	eor	x5, x5, x3, ror #18
    4dd0: f2da97c6     	movk	x6, #0xd4be, lsl #32
    4dd4: aa130293     	orr	x19, x20, x19
    4dd8: cac188e7     	eor	x7, x7, x1, ror #34
    4ddc: f2e998a6     	movk	x6, #0x4cc5, lsl #48
    4de0: aa0a0114     	orr	x20, x8, x10
    4de4: 8b130042     	add	x2, x2, x19
    4de8: cac3a4a5     	eor	x5, x5, x3, ror #41
    4dec: 8a0a0113     	and	x19, x8, x10
    4df0: 8a140034     	and	x20, x1, x20
    4df4: 8b060042     	add	x2, x2, x6
    4df8: cac19ce6     	eor	x6, x7, x1, ror #39
    4dfc: aa130287     	orr	x7, x20, x19
    4e00: 8b050042     	add	x2, x2, x5
    4e04: f94137e5     	ldr	x5, [sp, #0x268]
    4e08: 8b110051     	add	x17, x2, x17
    4e0c: 8b0101ef     	add	x15, x15, x1
    4e10: 8b0700c6     	add	x6, x6, x7
    4e14: d28fc547     	mov	x7, #0x7e2a             // =32298
    4e18: 8a310253     	bic	x19, x18, x17
    4e1c: 8b0200c2     	add	x2, x6, x2
    4e20: 93d13a26     	ror	x6, x17, #0xe
    4e24: 8b0400a4     	add	x4, x5, x4
    4e28: 93c27045     	ror	x5, x2, #0x1c
    4e2c: f2bf8ca7     	movk	x7, #0xfc65, lsl #16
    4e30: 8a110074     	and	x20, x3, x17
    4e34: cad148c6     	eor	x6, x6, x17, ror #18
    4e38: f2c53387     	movk	x7, #0x299c, lsl #32
    4e3c: aa130293     	orr	x19, x20, x19
    4e40: cac288a5     	eor	x5, x5, x2, ror #34
    4e44: f2eb2fe7     	movk	x7, #0x597f, lsl #48
    4e48: aa080034     	orr	x20, x1, x8
    4e4c: 8b130084     	add	x4, x4, x19
    4e50: cad1a4c6     	eor	x6, x6, x17, ror #41
    4e54: 8a080033     	and	x19, x1, x8
    4e58: 8a140054     	and	x20, x2, x20
    4e5c: 8b070084     	add	x4, x4, x7
    4e60: cac29ca5     	eor	x5, x5, x2, ror #39
    4e64: aa130293     	orr	x19, x20, x19
    4e68: 8b060084     	add	x4, x4, x6
    4e6c: f9413be7     	ldr	x7, [sp, #0x270]
    4e70: 8b1300a5     	add	x5, x5, x19
    4e74: 8b0a008a     	add	x10, x4, x10
    4e78: d29f5d94     	mov	x20, #0xfaec            // =64236
    4e7c: 8b0400a4     	add	x4, x5, x4
    4e80: 93ca3945     	ror	x5, x10, #0xe
    4e84: 8b1200f2     	add	x18, x7, x18
    4e88: 8a2a0066     	bic	x6, x3, x10
    4e8c: 8a0a0227     	and	x7, x17, x10
    4e90: 93c47093     	ror	x19, x4, #0x1c
    4e94: f2a75ad4     	movk	x20, #0x3ad6, lsl #16
    4e98: caca48a5     	eor	x5, x5, x10, ror #18
    4e9c: aa0600e6     	orr	x6, x7, x6
    4ea0: f2cdf574     	movk	x20, #0x6fab, lsl #32
    4ea4: 8b060252     	add	x18, x18, x6
    4ea8: cac48a66     	eor	x6, x19, x4, ror #34
    4eac: f2ebf974     	movk	x20, #0x5fcb, lsl #48
    4eb0: cacaa4a5     	eor	x5, x5, x10, ror #41
    4eb4: f9413fe7     	ldr	x7, [sp, #0x278]
    4eb8: aa010053     	orr	x19, x2, x1
    4ebc: 8b140252     	add	x18, x18, x20
    4ec0: 8a010054     	and	x20, x2, x1
    4ec4: 8a130093     	and	x19, x4, x19
    4ec8: cac49cc6     	eor	x6, x6, x4, ror #39
    4ecc: 8b050252     	add	x18, x18, x5
    4ed0: 8b0300e3     	add	x3, x7, x3
    4ed4: aa140267     	orr	x7, x19, x20
    4ed8: 8b080248     	add	x8, x18, x8
    4edc: 8b0700c1     	add	x1, x6, x7
    4ee0: 8a280227     	bic	x7, x17, x8
    4ee4: 8a080153     	and	x19, x10, x8
    4ee8: 8b0201ce     	add	x14, x14, x2
    4eec: 8b120032     	add	x18, x1, x18
    4ef0: 93c83901     	ror	x1, x8, #0xe
    4ef4: aa020085     	orr	x5, x4, x2
    4ef8: 8a020082     	and	x2, x4, x2
    4efc: 8b040210     	add	x16, x16, x4
    4f00: aa070264     	orr	x4, x19, x7
    4f04: 93d27246     	ror	x6, x18, #0x1c
    4f08: cac84821     	eor	x1, x1, x8, ror #18
    4f0c: 8b040063     	add	x3, x3, x4
    4f10: d28b02e4     	mov	x4, #0x5817             // =22551
    4f14: a9023810     	stp	x16, x14, [x0, #0x20]
    4f18: f2a948e4     	movk	x4, #0x4a47, lsl #16
    4f1c: cad288c6     	eor	x6, x6, x18, ror #34
    4f20: cac8a421     	eor	x1, x1, x8, ror #41
    4f24: f2c33184     	movk	x4, #0x198c, lsl #32
    4f28: 8b080168     	add	x8, x11, x8
    4f2c: 8b120129     	add	x9, x9, x18
    4f30: f2ed8884     	movk	x4, #0x6c44, lsl #48
    4f34: 8b0a018a     	add	x10, x12, x10
    4f38: 8b040063     	add	x3, x3, x4
    4f3c: 8a050244     	and	x4, x18, x5
    4f40: cad29cc5     	eor	x5, x6, x18, ror #39
    4f44: 8b010061     	add	x1, x3, x1
    4f48: aa020082     	orr	x2, x4, x2
    4f4c: 8b0101ef     	add	x15, x15, x1
    4f50: 8b0200ae     	add	x14, x5, x2
    4f54: a903200f     	stp	x15, x8, [x0, #0x30]
    4f58: f9402408     	ldr	x8, [x0, #0x48]
    4f5c: 8b0101cb     	add	x11, x14, x1
    4f60: 8b0b01ab     	add	x11, x13, x11
    4f64: 8b110108     	add	x8, x8, x17
    4f68: a901240b     	stp	x11, x9, [x0, #0x10]
    4f6c: a904200a     	stp	x10, x8, [x0, #0x40]
    4f70: 910a03ff     	add	sp, sp, #0x280
    4f74: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    4f78: f9400bf5     	ldr	x21, [sp, #0x10]
    4f7c: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    4f80: d65f03c0     	ret

0000000000004f84 <audit_master384>:
    4f84: d10643ff     	sub	sp, sp, #0x190
    4f88: a9177bfd     	stp	x29, x30, [sp, #0x170]
    4f8c: a9184ffc     	stp	x28, x19, [sp, #0x180]
    4f90: 9105c3fd     	add	x29, sp, #0x170
    4f94: 90000009     	adrp	x9, 0x4000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1044>
		0000000000004f94:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x70
    4f98: 91000129     	add	x9, x9, #0x0
		0000000000004f98:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x70
    4f9c: 52860008     	mov	w8, #0x3000             // =12288
    4fa0: ad400520     	ldp	q0, q1, [x9]
    4fa4: 7900c3e8     	strh	w8, [sp, #0x60]
    4fa8: 528001a8     	mov	w8, #0xd                // =13
    4fac: 9000000a     	adrp	x10, 0x4000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1044>
		0000000000004fac:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
    4fb0: 9100014a     	add	x10, x10, #0x0
		0000000000004fb0:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
    4fb4: f940014b     	ldr	x11, [x10]
    4fb8: 39018be8     	strb	w8, [sp, #0x62]
    4fbc: f8405148     	ldur	x8, [x10, #0x5]
    4fc0: 3c8713e0     	stur	q0, [sp, #0x71]
    4fc4: 3dc00920     	ldr	q0, [x9, #0x20]
    4fc8: aa0103f3     	mov	x19, x1
    4fcc: aa0003e4     	mov	x4, x0
    4fd0: f80633eb     	stur	x11, [sp, #0x63]
    4fd4: 910183ea     	add	x10, sp, #0x60
    4fd8: f90037e8     	str	x8, [sp, #0x68]
    4fdc: 52800608     	mov	w8, #0x30               // =48
    4fe0: 9100c3e0     	add	x0, sp, #0x30
    4fe4: 910183e2     	add	x2, sp, #0x60
    4fe8: 52800601     	mov	w1, #0x30               // =48
    4fec: 52800823     	mov	w3, #0x41               // =65
    4ff0: 3c821141     	stur	q1, [x10, #0x21]
    4ff4: 3901c3e8     	strb	w8, [sp, #0x70]
    4ff8: 3c831140     	stur	q0, [x10, #0x31]
    4ffc: 97fff5ad     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
<L0>:
    5000: 90000002     	adrp	x2, 0x5000 <L0>
		0000000000005000:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x190
    5004: 91000042     	add	x2, x2, #0x0
		0000000000005004:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x190
    5008: 910003e0     	mov	x0, sp
    500c: 9100c3e1     	add	x1, sp, #0x30
    5010: 97fff504     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    5014: 6f00e400     	movi	v0.2d, #0000000000000000
    5018: 3d8017e0     	str	q0, [sp, #0x50]
    501c: 3d8013e0     	str	q0, [sp, #0x40]
    5020: 3d800fe0     	str	q0, [sp, #0x30]
    5024: ad4007e0     	ldp	q0, q1, [sp]
    5028: 3dc00be2     	ldr	q2, [sp, #0x20]
    502c: ad000660     	stp	q0, q1, [x19]
    5030: 3d800a62     	str	q2, [x19, #0x20]
    5034: a9584ffc     	ldp	x28, x19, [sp, #0x180]
    5038: a9577bfd     	ldp	x29, x30, [sp, #0x170]
    503c: 910643ff     	add	sp, sp, #0x190
    5040: d65f03c0     	ret

0000000000005044 <audit_key384>:
    5044: d104c3ff     	sub	sp, sp, #0x130
    5048: a9117bfd     	stp	x29, x30, [sp, #0x110]
    504c: f90093fc     	str	x28, [sp, #0x120]
    5050: 910443fd     	add	x29, sp, #0x110
    5054: 52800129     	mov	w9, #0x9                // =9
    5058: 52840008     	mov	w8, #0x2000             // =8192
    505c: aa0003e4     	mov	x4, x0
    5060: 39001be9     	strb	w9, [sp, #0x6]
    5064: 90000009     	adrp	x9, 0x5000 <audit_master384+0x7c>
		0000000000005064:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x1c0
    5068: 91000129     	add	x9, x9, #0x0
		0000000000005068:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x1c0
    506c: f9400129     	ldr	x9, [x9]
    5070: 79000be8     	strh	w8, [sp, #0x4]
    5074: 52800f28     	mov	w8, #0x79               // =121
    5078: 910013e2     	add	x2, sp, #0x4
    507c: aa0103e0     	mov	x0, x1
    5080: 52800401     	mov	w1, #0x20               // =32
    5084: 528001a3     	mov	w3, #0xd                // =13
    5088: 7800f3e8     	sturh	w8, [sp, #0xf]
    508c: f80073e9     	stur	x9, [sp, #0x7]
    5090: 97fff588     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    5094: a9517bfd     	ldp	x29, x30, [sp, #0x110]
    5098: f94093fc     	ldr	x28, [sp, #0x120]
    509c: 9104c3ff     	add	sp, sp, #0x130
    50a0: d65f03c0     	ret
