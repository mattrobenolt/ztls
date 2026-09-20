
/tmp/ztls-signoff-20260919/125-before-6d73a0a/015-aarch64-linux-gnu.o:	file format elf64-littleaarch64

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
      74: 94000075     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
      78: 910003e0     	mov	x0, sp
      7c: 910083e1     	add	x1, sp, #0x20
      80: aa1403e2     	mov	x2, x20
      84: 94000008     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
      88: ad4007e0     	ldp	q0, q1, [sp]
      8c: ad000660     	stp	q0, q1, [x19]
      90: a9574ff4     	ldp	x20, x19, [sp, #0x170]
      94: f940b3fc     	ldr	x28, [sp, #0x160]
      98: a9557bfd     	ldp	x29, x30, [sp, #0x150]
      9c: 910603ff     	add	sp, sp, #0x180
      a0: d65f03c0     	ret

00000000000000a4 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
      a4: d10683ff     	sub	sp, sp, #0x1a0
      a8: a9167bfd     	stp	x29, x30, [sp, #0x160]
      ac: a9175ffc     	stp	x28, x23, [sp, #0x170]
      b0: a91857f6     	stp	x22, x21, [sp, #0x180]
      b4: a9194ff4     	stp	x20, x19, [sp, #0x190]
      b8: 910583fd     	add	x29, sp, #0x160
      bc: aa0003f3     	mov	x19, x0
      c0: 910083e0     	add	x0, sp, #0x20
      c4: aa0203f4     	mov	x20, x2
      c8: 910083f7     	add	x23, sp, #0x20
      cc: 9400016a     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
      d0: 394223e8     	ldrb	w8, [sp, #0x88]
      d4: 34000228     	cbz	w8,  <L1>
      d8: 7100811f     	cmp	w8, #0x20
      dc: 540001e3     	b.lo	 <L1>
      e0: 52800809     	mov	w9, #0x40               // =64
      e4: 910083ea     	add	x10, sp, #0x20
      e8: aa1403e1     	mov	x1, x20
      ec: cb080135     	sub	x21, x9, x8
      f0: 9100a156     	add	x22, x10, #0x28
      f4: 8b0802c0     	add	x0, x22, x8
      f8: aa1503e2     	mov	x2, x21
<L0>:
      fc: 94000000     	bl	 <L0>
		00000000000000fc:  R_AARCH64_CALL26	memcpy
     100: 910083e0     	add	x0, sp, #0x20
     104: aa1603e1     	mov	x1, x22
     108: 940001d7     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     10c: 2a1f03e8     	mov	w8, wzr
     110: 390223ff     	strb	wzr, [sp, #0x88]
     114: 14000002     	b	 <L2>
<L1>:
     118: aa1f03f5     	mov	x21, xzr
<L2>:
     11c: 52800409     	mov	w9, #0x20               // =32
     120: 8b2842e8     	add	x8, x23, w8, uxtw
     124: 8b150281     	add	x1, x20, x21
     128: cb150136     	sub	x22, x9, x21
     12c: 9100a100     	add	x0, x8, #0x28
     130: aa1603e2     	mov	x2, x22
<L3>:
     134: 94000000     	bl	 <L3>
		0000000000000134:  R_AARCH64_CALL26	memcpy
     138: 394223e8     	ldrb	w8, [sp, #0x88]
     13c: f94023e9     	ldr	x9, [sp, #0x40]
     140: 910083e0     	add	x0, sp, #0x20
     144: d10243a1     	sub	x1, x29, #0x90
     148: 0b160108     	add	w8, w8, w22
     14c: 91008129     	add	x9, x9, #0x20
     150: d10243b6     	sub	x22, x29, #0x90
     154: 390223e8     	strb	w8, [sp, #0x88]
     158: f90023e9     	str	x9, [sp, #0x40]
     15c: 94000176     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     160: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		0000000000000160:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     164: 91000108     	add	x8, x8, #0x0
		0000000000000164:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     168: d101c3a0     	sub	x0, x29, #0x70
     16c: ad420500     	ldp	q0, q1, [x8, #0x40]
     170: 3dc01902     	ldr	q2, [x8, #0x60]
     174: 9101c2e1     	add	x1, x23, #0x70
     178: d101c3b4     	sub	x20, x29, #0x70
     17c: 3c9f03a2     	stur	q2, [x29, #-0x10]
     180: ad3e87a0     	stp	q0, q1, [x29, #-0x30]
     184: ad400500     	ldp	q0, q1, [x8]
     188: ad3c87a0     	stp	q0, q1, [x29, #-0x70]
     18c: ad410900     	ldp	q0, q2, [x8, #0x20]
     190: ad3d8ba0     	stp	q0, q2, [x29, #-0x50]
     194: 940001b4     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     198: f85b03a9     	ldur	x9, [x29, #-0x50]
     19c: 385f83a8     	ldurb	w8, [x29, #-0x8]
     1a0: 9100a294     	add	x20, x20, #0x28
     1a4: 91010137     	add	x23, x9, #0x40
     1a8: f81b03b7     	stur	x23, [x29, #-0x50]
     1ac: 34000208     	cbz	w8,  <L5>
     1b0: 7100811f     	cmp	w8, #0x20
     1b4: 540001c3     	b.lo	 <L5>
     1b8: 52800809     	mov	w9, #0x40               // =64
     1bc: 8b080280     	add	x0, x20, x8
     1c0: d10243a1     	sub	x1, x29, #0x90
     1c4: cb080135     	sub	x21, x9, x8
     1c8: aa1503e2     	mov	x2, x21
<L4>:
     1cc: 94000000     	bl	 <L4>
		00000000000001cc:  R_AARCH64_CALL26	memcpy
     1d0: d101c3a0     	sub	x0, x29, #0x70
     1d4: aa1403e1     	mov	x1, x20
     1d8: 940001a3     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     1dc: f85b03b7     	ldur	x23, [x29, #-0x50]
     1e0: 2a1f03e8     	mov	w8, wzr
     1e4: 381f83bf     	sturb	wzr, [x29, #-0x8]
     1e8: 14000002     	b	 <L6>
<L5>:
     1ec: aa1f03f5     	mov	x21, xzr
<L6>:
     1f0: 52800409     	mov	w9, #0x20               // =32
     1f4: 8b284280     	add	x0, x20, w8, uxtw
     1f8: 8b1502c1     	add	x1, x22, x21
     1fc: cb150134     	sub	x20, x9, x21
     200: aa1403e2     	mov	x2, x20
<L7>:
     204: 94000000     	bl	 <L7>
		0000000000000204:  R_AARCH64_CALL26	memcpy
     208: 385f83a8     	ldurb	w8, [x29, #-0x8]
     20c: 910082e9     	add	x9, x23, #0x20
     210: d101c3a0     	sub	x0, x29, #0x70
     214: 910003e1     	mov	x1, sp
     218: f81b03a9     	stur	x9, [x29, #-0x50]
     21c: 0b140108     	add	w8, w8, w20
     220: 381f83a8     	sturb	w8, [x29, #-0x8]
     224: 94000144     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     228: ad4007e0     	ldp	q0, q1, [sp]
     22c: ad000660     	stp	q0, q1, [x19]
     230: a9594ff4     	ldp	x20, x19, [sp, #0x190]
     234: a95857f6     	ldp	x22, x21, [sp, #0x180]
     238: a9575ffc     	ldp	x28, x23, [sp, #0x170]
     23c: a9567bfd     	ldp	x29, x30, [sp, #0x160]
     240: 910683ff     	add	sp, sp, #0x1a0
     244: d65f03c0     	ret

0000000000000248 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     248: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
     24c: a9016ffc     	stp	x28, x27, [sp, #0x10]
     250: a90267fa     	stp	x26, x25, [sp, #0x20]
     254: a9035ff8     	stp	x24, x23, [sp, #0x30]
     258: a90457f6     	stp	x22, x21, [sp, #0x40]
     25c: a9054ff4     	stp	x20, x19, [sp, #0x50]
     260: 910003fd     	mov	x29, sp
     264: d10883ff     	sub	sp, sp, #0x220
     268: aa0303f5     	mov	x21, x3
     26c: aa0203f6     	mov	x22, x2
     270: aa0003f3     	mov	x19, x0
     274: 52800028     	mov	w8, #0x1                // =1
     278: f100803f     	cmp	x1, #0x20
     27c: 910303fa     	add	x26, sp, #0xc0
     280: 390033e8     	strb	w8, [sp, #0xc]
     284: 54000322     	b.hs	 <L1>
     288: aa0103f4     	mov	x20, x1
     28c: 910303e0     	add	x0, sp, #0xc0
     290: aa0403e1     	mov	x1, x4
     294: 910303f9     	add	x25, sp, #0xc0
     298: 940000f7     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
     29c: 3944a3e8     	ldrb	w8, [sp, #0x128]
     2a0: 34000508     	cbz	w8,  <L3>
     2a4: 8b0802a9     	add	x9, x21, x8
     2a8: f101013f     	cmp	x9, #0x40
     2ac: 540004a3     	b.lo	 <L3>
     2b0: 52800809     	mov	w9, #0x40               // =64
     2b4: 910303ea     	add	x10, sp, #0xc0
     2b8: aa1603e1     	mov	x1, x22
     2bc: cb080138     	sub	x24, x9, x8
     2c0: 9100a157     	add	x23, x10, #0x28
     2c4: 8b0802e0     	add	x0, x23, x8
     2c8: aa1803e2     	mov	x2, x24
<L0>:
     2cc: 94000000     	bl	 <L0>
		00000000000002cc:  R_AARCH64_CALL26	memcpy
     2d0: 910303e0     	add	x0, sp, #0xc0
     2d4: aa1703e1     	mov	x1, x23
     2d8: 94000163     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     2dc: 2a1f03e8     	mov	w8, wzr
     2e0: 3904a3ff     	strb	wzr, [sp, #0x128]
     2e4: 14000018     	b	 <L4>
<L1>:
     2e8: 910043f9     	add	x25, sp, #0x10
     2ec: 910043e0     	add	x0, sp, #0x10
     2f0: aa0403e1     	mov	x1, x4
     2f4: 9100a334     	add	x20, x25, #0x28
     2f8: 940000df     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>
     2fc: 3941e3e8     	ldrb	w8, [sp, #0x78]
     300: 340005a8     	cbz	w8,  <L7>
     304: d24016a9     	eor	x9, x21, #0x3f
     308: eb08013f     	cmp	x9, x8
     30c: 54000542     	b.hs	 <L7>
     310: 52800809     	mov	w9, #0x40               // =64
     314: 8b080280     	add	x0, x20, x8
     318: aa1603e1     	mov	x1, x22
     31c: cb080137     	sub	x23, x9, x8
     320: aa1703e2     	mov	x2, x23
<L2>:
     324: 94000000     	bl	 <L2>
		0000000000000324:  R_AARCH64_CALL26	memcpy
     328: 910043e0     	add	x0, sp, #0x10
     32c: aa1403e1     	mov	x1, x20
     330: 9400014d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     334: 2a1f03e8     	mov	w8, wzr
     338: 3901e3ff     	strb	wzr, [sp, #0x78]
     33c: 1400001f     	b	 <L8>
<L3>:
     340: aa1f03f8     	mov	x24, xzr
<L4>:
     344: 9100a337     	add	x23, x25, #0x28
     348: cb1802b9     	sub	x25, x21, x24
     34c: 8b1802c1     	add	x1, x22, x24
     350: 8b2842e0     	add	x0, x23, w8, uxtw
     354: aa1903e2     	mov	x2, x25
<L5>:
     358: 94000000     	bl	 <L5>
		0000000000000358:  R_AARCH64_CALL26	memcpy
     35c: 3944a3e8     	ldrb	w8, [sp, #0x128]
     360: f9401349     	ldr	x9, [x26, #0x20]
     364: 2b190108     	adds	w8, w8, w25
     368: 8b150138     	add	x24, x9, x21
     36c: 3904a3e8     	strb	w8, [sp, #0x128]
     370: f9001358     	str	x24, [x26, #0x20]
     374: 540005a0     	b.eq	 <L11>
     378: 7100fd1f     	cmp	w8, #0x3f
     37c: 54000563     	b.lo	 <L11>
     380: 52800809     	mov	w9, #0x40               // =64
     384: 8b2842e0     	add	x0, x23, w8, uxtw
     388: 910033e1     	add	x1, sp, #0xc
     38c: 4b080135     	sub	w21, w9, w8
     390: aa1503e2     	mov	x2, x21
<L6>:
     394: 94000000     	bl	 <L6>
		0000000000000394:  R_AARCH64_CALL26	memcpy
     398: 910303e0     	add	x0, sp, #0xc0
     39c: aa1703e1     	mov	x1, x23
     3a0: 94000131     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     3a4: f9401358     	ldr	x24, [x26, #0x20]
     3a8: 2a1f03e8     	mov	w8, wzr
     3ac: 3904a3ff     	strb	wzr, [sp, #0x128]
     3b0: 1400001f     	b	 <L12>
<L7>:
     3b4: aa1f03f7     	mov	x23, xzr
<L8>:
     3b8: 8b284280     	add	x0, x20, w8, uxtw
     3bc: cb1702b8     	sub	x24, x21, x23
     3c0: 8b1702c1     	add	x1, x22, x23
     3c4: aa1803e2     	mov	x2, x24
     3c8: d101c3bb     	sub	x27, x29, #0x70
<L9>:
     3cc: 94000000     	bl	 <L9>
		00000000000003cc:  R_AARCH64_CALL26	memcpy
     3d0: 3941e3e8     	ldrb	w8, [sp, #0x78]
     3d4: f9401be9     	ldr	x9, [sp, #0x30]
     3d8: 2b180108     	adds	w8, w8, w24
     3dc: 8b150137     	add	x23, x9, x21
     3e0: 3901e3e8     	strb	w8, [sp, #0x78]
     3e4: f9001bf7     	str	x23, [sp, #0x30]
     3e8: 540008a0     	b.eq	 <L15>
     3ec: 7100fd1f     	cmp	w8, #0x3f
     3f0: 54000863     	b.lo	 <L15>
     3f4: 52800809     	mov	w9, #0x40               // =64
     3f8: 8b284280     	add	x0, x20, w8, uxtw
     3fc: 910033e1     	add	x1, sp, #0xc
     400: 4b080135     	sub	w21, w9, w8
     404: aa1503e2     	mov	x2, x21
<L10>:
     408: 94000000     	bl	 <L10>
		0000000000000408:  R_AARCH64_CALL26	memcpy
     40c: 910043e0     	add	x0, sp, #0x10
     410: aa1403e1     	mov	x1, x20
     414: 94000114     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     418: f9401bf7     	ldr	x23, [sp, #0x30]
     41c: 2a1f03e8     	mov	w8, wzr
     420: 3901e3ff     	strb	wzr, [sp, #0x78]
     424: 14000037     	b	 <L16>
<L11>:
     428: aa1f03f5     	mov	x21, xzr
<L12>:
     42c: 52800029     	mov	w9, #0x1                // =1
     430: 8b2842e0     	add	x0, x23, w8, uxtw
     434: 910033e8     	add	x8, sp, #0xc
     438: cb150136     	sub	x22, x9, x21
     43c: 8b150101     	add	x1, x8, x21
     440: aa1603e2     	mov	x2, x22
<L13>:
     444: 94000000     	bl	 <L13>
		0000000000000444:  R_AARCH64_CALL26	memcpy
     448: 3944a3e8     	ldrb	w8, [sp, #0x128]
     44c: 91000709     	add	x9, x24, #0x1
     450: 910303e0     	add	x0, sp, #0xc0
     454: d10243a1     	sub	x1, x29, #0x90
     458: f9001349     	str	x9, [x26, #0x20]
     45c: 910303f5     	add	x21, sp, #0xc0
     460: 0b160108     	add	w8, w8, w22
     464: d10243b7     	sub	x23, x29, #0x90
     468: 3904a3e8     	strb	w8, [sp, #0x128]
     46c: 940000b2     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     470: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		0000000000000470:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     474: 91000108     	add	x8, x8, #0x0
		0000000000000474:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     478: d101c3a0     	sub	x0, x29, #0x70
     47c: ad420500     	ldp	q0, q1, [x8, #0x40]
     480: 3dc01902     	ldr	q2, [x8, #0x60]
     484: 9101c2a1     	add	x1, x21, #0x70
     488: d101c3b5     	sub	x21, x29, #0x70
     48c: 3d805742     	str	q2, [x26, #0x150]
     490: ad098740     	stp	q0, q1, [x26, #0x130]
     494: ad400500     	ldp	q0, q1, [x8]
     498: ad078740     	stp	q0, q1, [x26, #0xf0]
     49c: ad410900     	ldp	q0, q2, [x8, #0x20]
     4a0: ad088b40     	stp	q0, q2, [x26, #0x110]
     4a4: 940000f0     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     4a8: f9408b49     	ldr	x9, [x26, #0x110]
     4ac: 385f83a8     	ldurb	w8, [x29, #-0x8]
     4b0: 9100a2b5     	add	x21, x21, #0x28
     4b4: 91010138     	add	x24, x9, #0x40
     4b8: f9008b58     	str	x24, [x26, #0x110]
     4bc: 34000868     	cbz	w8,  <L19>
     4c0: 7100811f     	cmp	w8, #0x20
     4c4: 54000823     	b.lo	 <L19>
     4c8: 52800809     	mov	w9, #0x40               // =64
     4cc: 8b0802a0     	add	x0, x21, x8
     4d0: d10243a1     	sub	x1, x29, #0x90
     4d4: cb080136     	sub	x22, x9, x8
     4d8: aa1603e2     	mov	x2, x22
<L14>:
     4dc: 94000000     	bl	 <L14>
		00000000000004dc:  R_AARCH64_CALL26	memcpy
     4e0: d101c3a0     	sub	x0, x29, #0x70
     4e4: aa1503e1     	mov	x1, x21
     4e8: 940000df     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     4ec: f9408b58     	ldr	x24, [x26, #0x110]
     4f0: 2a1f03e8     	mov	w8, wzr
     4f4: 381f83bf     	sturb	wzr, [x29, #-0x8]
     4f8: 14000035     	b	 <L20>
<L15>:
     4fc: aa1f03f5     	mov	x21, xzr
<L16>:
     500: 52800029     	mov	w9, #0x1                // =1
     504: 8b284280     	add	x0, x20, w8, uxtw
     508: 910033e8     	add	x8, sp, #0xc
     50c: cb150136     	sub	x22, x9, x21
     510: 8b150101     	add	x1, x8, x21
     514: 9100a374     	add	x20, x27, #0x28
     518: aa1603e2     	mov	x2, x22
<L17>:
     51c: 94000000     	bl	 <L17>
		000000000000051c:  R_AARCH64_CALL26	memcpy
     520: 3941e3e8     	ldrb	w8, [sp, #0x78]
     524: 910006e9     	add	x9, x23, #0x1
     528: 910043e0     	add	x0, sp, #0x10
     52c: d10243a1     	sub	x1, x29, #0x90
     530: f9001be9     	str	x9, [sp, #0x30]
     534: 0b160108     	add	w8, w8, w22
     538: d10243b6     	sub	x22, x29, #0x90
     53c: 3901e3e8     	strb	w8, [sp, #0x78]
     540: 9400007d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     544: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		0000000000000544:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     548: 91000108     	add	x8, x8, #0x0
		0000000000000548:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     54c: d101c3a0     	sub	x0, x29, #0x70
     550: ad420500     	ldp	q0, q1, [x8, #0x40]
     554: 3dc01902     	ldr	q2, [x8, #0x60]
     558: 9101c321     	add	x1, x25, #0x70
     55c: 3d805742     	str	q2, [x26, #0x150]
     560: ad098740     	stp	q0, q1, [x26, #0x130]
     564: ad400500     	ldp	q0, q1, [x8]
     568: ad078740     	stp	q0, q1, [x26, #0xf0]
     56c: ad410900     	ldp	q0, q2, [x8, #0x20]
     570: ad088b40     	stp	q0, q2, [x26, #0x110]
     574: 940000bc     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     578: f9408b49     	ldr	x9, [x26, #0x110]
     57c: 385f83a8     	ldurb	w8, [x29, #-0x8]
     580: 91010137     	add	x23, x9, #0x40
     584: f9008b57     	str	x23, [x26, #0x110]
     588: 34000488     	cbz	w8,  <L23>
     58c: 7100811f     	cmp	w8, #0x20
     590: 54000443     	b.lo	 <L23>
     594: 52800809     	mov	w9, #0x40               // =64
     598: 8b080280     	add	x0, x20, x8
     59c: d10243a1     	sub	x1, x29, #0x90
     5a0: cb080135     	sub	x21, x9, x8
     5a4: aa1503e2     	mov	x2, x21
<L18>:
     5a8: 94000000     	bl	 <L18>
		00000000000005a8:  R_AARCH64_CALL26	memcpy
     5ac: d101c3a0     	sub	x0, x29, #0x70
     5b0: aa1403e1     	mov	x1, x20
     5b4: 940000ac     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     5b8: f9408b57     	ldr	x23, [x26, #0x110]
     5bc: 2a1f03e8     	mov	w8, wzr
     5c0: 381f83bf     	sturb	wzr, [x29, #-0x8]
     5c4: 14000016     	b	 <L24>
<L19>:
     5c8: aa1f03f6     	mov	x22, xzr
<L20>:
     5cc: 52800409     	mov	w9, #0x20               // =32
     5d0: 8b2842a0     	add	x0, x21, w8, uxtw
     5d4: 8b1602e1     	add	x1, x23, x22
     5d8: cb160135     	sub	x21, x9, x22
     5dc: aa1503e2     	mov	x2, x21
<L21>:
     5e0: 94000000     	bl	 <L21>
		00000000000005e0:  R_AARCH64_CALL26	memcpy
     5e4: 385f83a8     	ldurb	w8, [x29, #-0x8]
     5e8: 91008309     	add	x9, x24, #0x20
     5ec: d101c3a0     	sub	x0, x29, #0x70
     5f0: d102c3a1     	sub	x1, x29, #0xb0
     5f4: f9008b49     	str	x9, [x26, #0x110]
     5f8: 0b150108     	add	w8, w8, w21
     5fc: 381f83a8     	sturb	w8, [x29, #-0x8]
     600: 9400004d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     604: d102c3a1     	sub	x1, x29, #0xb0
     608: aa1303e0     	mov	x0, x19
     60c: aa1403e2     	mov	x2, x20
<L22>:
     610: 94000000     	bl	 <L22>
		0000000000000610:  R_AARCH64_CALL26	memcpy
     614: 14000010     	b	 <L26>
<L23>:
     618: aa1f03f5     	mov	x21, xzr
<L24>:
     61c: 52800409     	mov	w9, #0x20               // =32
     620: 8b284280     	add	x0, x20, w8, uxtw
     624: 8b1502c1     	add	x1, x22, x21
     628: cb150134     	sub	x20, x9, x21
     62c: aa1403e2     	mov	x2, x20
<L25>:
     630: 94000000     	bl	 <L25>
		0000000000000630:  R_AARCH64_CALL26	memcpy
     634: 385f83a8     	ldurb	w8, [x29, #-0x8]
     638: 910082e9     	add	x9, x23, #0x20
     63c: d101c3a0     	sub	x0, x29, #0x70
     640: aa1303e1     	mov	x1, x19
     644: f9008b49     	str	x9, [x26, #0x110]
     648: 0b140108     	add	w8, w8, w20
     64c: 381f83a8     	sturb	w8, [x29, #-0x8]
     650: 94000039     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
<L26>:
     654: 910883ff     	add	sp, sp, #0x220
     658: a9454ff4     	ldp	x20, x19, [sp, #0x50]
     65c: a94457f6     	ldp	x22, x21, [sp, #0x40]
     660: a9435ff8     	ldp	x24, x23, [sp, #0x30]
     664: a94267fa     	ldp	x26, x25, [sp, #0x20]
     668: a9416ffc     	ldp	x28, x27, [sp, #0x10]
     66c: a8c67bfd     	ldp	x29, x30, [sp], #0x60
     670: d65f03c0     	ret

0000000000000674 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>:
     674: d10443ff     	sub	sp, sp, #0x110
     678: a90f7bfd     	stp	x29, x30, [sp, #0xf0]
     67c: a9104ffc     	stp	x28, x19, [sp, #0x100]
     680: 9103c3fd     	add	x29, sp, #0xf0
     684: 4f02e780     	movi	v0.16b, #0x5c
     688: 4f01e6c1     	movi	v1.16b, #0x36
     68c: 90000008     	adrp	x8, 0x0 <audit_handshake256>
		000000000000068c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata
     690: 91000108     	add	x8, x8, #0x0
		0000000000000690:  R_AARCH64_ADD_ABS_LO12_NC	.rodata
     694: ad400823     	ldp	q3, q2, [x1]
     698: aa0003f3     	mov	x19, x0
     69c: 910003e0     	mov	x0, sp
     6a0: d10103a1     	sub	x1, x29, #0x40
     6a4: 6e201c44     	eor	v4.16b, v2.16b, v0.16b
     6a8: ad0483e0     	stp	q0, q0, [sp, #0x90]
     6ac: 6e211c65     	eor	v5.16b, v3.16b, v1.16b
     6b0: ad3f07a1     	stp	q1, q1, [x29, #-0x20]
     6b4: 6e211c41     	eor	v1.16b, v2.16b, v1.16b
     6b8: 6e201c60     	eor	v0.16b, v3.16b, v0.16b
     6bc: ad420d02     	ldp	q2, q3, [x8, #0x40]
     6c0: ad0393e0     	stp	q0, q4, [sp, #0x70]
     6c4: ad020fe2     	stp	q2, q3, [sp, #0x40]
     6c8: ad400102     	ldp	q2, q0, [x8]
     6cc: ad3e07a5     	stp	q5, q1, [x29, #-0x40]
     6d0: 3dc01901     	ldr	q1, [x8, #0x60]
     6d4: 3d801be1     	str	q1, [sp, #0x60]
     6d8: ad0003e2     	stp	q2, q0, [sp]
     6dc: ad410500     	ldp	q0, q1, [x8, #0x20]
     6e0: ad0107e0     	stp	q0, q1, [sp, #0x20]
     6e4: 94000060     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     6e8: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     6ec: f94013e8     	ldr	x8, [sp, #0x20]
     6f0: 91010108     	add	x8, x8, #0x40
     6f4: ad040660     	stp	q0, q1, [x19, #0x80]
     6f8: 3dc02be0     	ldr	q0, [sp, #0xa0]
     6fc: f90013e8     	str	x8, [sp, #0x20]
     700: 3d802a60     	str	q0, [x19, #0xa0]
     704: ad4203e1     	ldp	q1, q0, [sp, #0x40]
     708: ad020261     	stp	q1, q0, [x19, #0x40]
     70c: ad430be0     	ldp	q0, q2, [sp, #0x60]
     710: ad030a60     	stp	q0, q2, [x19, #0x60]
     714: ad4003e1     	ldp	q1, q0, [sp]
     718: ad000261     	stp	q1, q0, [x19]
     71c: ad410be0     	ldp	q0, q2, [sp, #0x20]
     720: ad010a60     	stp	q0, q2, [x19, #0x20]
     724: a9504ffc     	ldp	x28, x19, [sp, #0x100]
     728: a94f7bfd     	ldp	x29, x30, [sp, #0xf0]
     72c: 910443ff     	add	sp, sp, #0x110
     730: d65f03c0     	ret

0000000000000734 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     734: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
     738: f9000bf5     	str	x21, [sp, #0x10]
     73c: a9024ff4     	stp	x20, x19, [sp, #0x20]
     740: 910003fd     	mov	x29, sp
     744: 3941a009     	ldrb	w9, [x0, #0x68]
     748: 52800808     	mov	w8, #0x40               // =64
     74c: 9100a015     	add	x21, x0, #0x28
     750: aa0103f3     	mov	x19, x1
     754: aa0003f4     	mov	x20, x0
     758: 2a1f03e1     	mov	w1, wzr
     75c: cb090102     	sub	x2, x8, x9
     760: 8b0902a0     	add	x0, x21, x9
<L0>:
     764: 94000000     	bl	 <L0>
		0000000000000764:  R_AARCH64_CALL26	memset
     768: 3941a288     	ldrb	w8, [x20, #0x68]
     76c: 52801009     	mov	w9, #0x80               // =128
     770: 38286aa9     	strb	w9, [x21, x8]
     774: 3941a288     	ldrb	w8, [x20, #0x68]
     778: 11000509     	add	w9, w8, #0x1
     77c: 7100dd1f     	cmp	w8, #0x37
     780: 3901a289     	strb	w9, [x20, #0x68]
     784: 54000109     	b.ls	 <L1>
     788: aa1403e0     	mov	x0, x20
     78c: aa1503e1     	mov	x1, x21
     790: 94000035     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     794: 6f00e400     	movi	v0.2d, #0000000000000000
     798: f9001abf     	str	xzr, [x21, #0x30]
     79c: ad0082a0     	stp	q0, q0, [x21, #0x10]
     7a0: 3d8002a0     	str	q0, [x21]
<L1>:
     7a4: f9401288     	ldr	x8, [x20, #0x20]
     7a8: aa1403e0     	mov	x0, x20
     7ac: aa1503e1     	mov	x1, x21
     7b0: 531d7109     	lsl	w9, w8, #3
     7b4: d345fd0a     	lsr	x10, x8, #5
     7b8: 39019e89     	strb	w9, [x20, #0x67]
     7bc: d34dfd09     	lsr	x9, x8, #13
     7c0: 39019a8a     	strb	w10, [x20, #0x66]
     7c4: d355fd0a     	lsr	x10, x8, #21
     7c8: 39019689     	strb	w9, [x20, #0x65]
     7cc: d35dfd09     	lsr	x9, x8, #29
     7d0: 3901928a     	strb	w10, [x20, #0x64]
     7d4: d365fd0a     	lsr	x10, x8, #37
     7d8: 39018e89     	strb	w9, [x20, #0x63]
     7dc: d36dfd09     	lsr	x9, x8, #45
     7e0: d375fd08     	lsr	x8, x8, #53
     7e4: 39018a8a     	strb	w10, [x20, #0x62]
     7e8: 39018689     	strb	w9, [x20, #0x61]
     7ec: 39018288     	strb	w8, [x20, #0x60]
     7f0: 9400001d     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     7f4: b9400288     	ldr	w8, [x20]
     7f8: 5ac00908     	rev	w8, w8
     7fc: b9000268     	str	w8, [x19]
     800: b9400688     	ldr	w8, [x20, #0x4]
     804: 5ac00908     	rev	w8, w8
     808: b9000668     	str	w8, [x19, #0x4]
     80c: b9400a88     	ldr	w8, [x20, #0x8]
     810: 5ac00908     	rev	w8, w8
     814: b9000a68     	str	w8, [x19, #0x8]
     818: b9400e88     	ldr	w8, [x20, #0xc]
     81c: 5ac00908     	rev	w8, w8
     820: b9000e68     	str	w8, [x19, #0xc]
     824: b9401288     	ldr	w8, [x20, #0x10]
     828: 5ac00908     	rev	w8, w8
     82c: b9001268     	str	w8, [x19, #0x10]
     830: b9401688     	ldr	w8, [x20, #0x14]
     834: 5ac00908     	rev	w8, w8
     838: b9001668     	str	w8, [x19, #0x14]
     83c: b9401a88     	ldr	w8, [x20, #0x18]
     840: 5ac00908     	rev	w8, w8
     844: b9001a68     	str	w8, [x19, #0x18]
     848: b9401e88     	ldr	w8, [x20, #0x1c]
     84c: 5ac00908     	rev	w8, w8
     850: b9001e68     	str	w8, [x19, #0x1c]
     854: a9424ff4     	ldp	x20, x19, [sp, #0x20]
     858: f9400bf5     	ldr	x21, [sp, #0x10]
     85c: a8c37bfd     	ldp	x29, x30, [sp], #0x30
     860: d65f03c0     	ret

0000000000000864 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     864: a9bc7bfd     	stp	x29, x30, [sp, #-0x40]!
     868: f9000bf7     	str	x23, [sp, #0x10]
     86c: a90257f6     	stp	x22, x21, [sp, #0x20]
     870: a9034ff4     	stp	x20, x19, [sp, #0x30]
     874: 910003fd     	mov	x29, sp
     878: d12403ff     	sub	sp, sp, #0x900
     87c: ad400420     	ldp	q0, q1, [x1]
     880: d10403a8     	sub	x8, x29, #0x100
     884: ad410c22     	ldp	q2, q3, [x1, #0x20]
     888: 911c03e9     	add	x9, sp, #0x700
     88c: 911803ea     	add	x10, sp, #0x600
     890: 911403eb     	add	x11, sp, #0x500
     894: 911003ec     	add	x12, sp, #0x400
     898: 6e200800     	rev32	v0.16b, v0.16b
     89c: 6e200821     	rev32	v1.16b, v1.16b
     8a0: 910c03ed     	add	x13, sp, #0x300
     8a4: 910803ee     	add	x14, sp, #0x200
     8a8: 9100e10f     	add	x15, x8, #0x38
     8ac: 9100e130     	add	x16, x9, #0x38
     8b0: 9100e151     	add	x17, x10, #0x38
     8b4: b27e0172     	orr	x18, x11, #0x4
     8b8: b27e0181     	orr	x1, x12, #0x4
     8bc: b27e01a2     	orr	x2, x13, #0x4
     8c0: 910091c3     	add	x3, x14, #0x24
     8c4: 52800804     	mov	w4, #0x40               // =64
     8c8: ad0007e0     	stp	q0, q1, [sp]
     8cc: 6e200841     	rev32	v1.16b, v2.16b
     8d0: 6e200862     	rev32	v2.16b, v3.16b
     8d4: 910403e5     	add	x5, sp, #0x100
     8d8: 910003e6     	mov	x6, sp
     8dc: ad010be1     	stp	q1, q2, [sp, #0x20]
<L0>:
     8e0: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     8e4: 8b040027     	add	x7, x1, x4
     8e8: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     8ec: 8b040213     	add	x19, x16, x4
     8f0: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     8f4: 3dc003f8     	ldr	q24, [sp]
     8f8: 8b040054     	add	x20, x2, x4
     8fc: ad0e0be1     	stp	q1, q2, [sp, #0x1c0]
     900: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     904: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     908: 8b040235     	add	x21, x17, x4
     90c: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     910: 8b0400b6     	add	x22, x5, x4
     914: ad0f07e3     	stp	q3, q1, [sp, #0x1e0]
     918: 8b040077     	add	x23, x3, x4
     91c: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     920: ad054dd2     	stp	q18, q19, [x14, #0xa0]
     924: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     928: ad035dd6     	stp	q22, q23, [x14, #0x60]
     92c: ad071dc6     	stp	q6, q7, [x14, #0xe0]
     930: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     934: ad0c07e2     	stp	q2, q1, [sp, #0x180]
     938: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     93c: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     940: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     944: ad0d07e3     	stp	q3, q1, [sp, #0x1a0]
     948: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     94c: ad0615c4     	stp	q4, q5, [x14, #0xc0]
     950: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     954: ad035d96     	stp	q22, q23, [x12, #0x60]
     958: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     95c: ad0a07e2     	stp	q2, q1, [sp, #0x140]
     960: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     964: ad054d92     	stp	q18, q19, [x12, #0xa0]
     968: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     96c: ad035d56     	stp	q22, q23, [x10, #0x60]
     970: ad435ff6     	ldp	q22, q23, [sp, #0x60]
     974: ad0b07e3     	stp	q3, q1, [sp, #0x160]
     978: ad4007e2     	ldp	q2, q1, [sp]
     97c: ad0445d0     	stp	q16, q17, [x14, #0x80]
     980: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     984: ad054d52     	stp	q18, q19, [x10, #0xa0]
     988: ad454ff2     	ldp	q18, q19, [sp, #0xa0]
     98c: ad0807e2     	stp	q2, q1, [sp, #0x100]
     990: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     994: ad0065d8     	stp	q24, q25, [x14]
     998: 3dc003f8     	ldr	q24, [sp]
     99c: ad035d16     	stp	q22, q23, [x8, #0x60]
     9a0: ad416be2     	ldp	q2, q26, [sp, #0x20]
     9a4: ad0907e3     	stp	q3, q1, [sp, #0x120]
     9a8: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     9ac: ad0255d4     	stp	q20, q21, [x14, #0x40]
     9b0: b85c02d6     	ldur	w22, [x22, #-0x40]
     9b4: ad0169c2     	stp	q2, q26, [x14, #0x20]
     9b8: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     9bc: ad054d12     	stp	q18, q19, [x8, #0xa0]
     9c0: b85c02f7     	ldur	w23, [x23, #-0x40]
     9c4: ad0609a1     	stp	q1, q2, [x13, #0xc0]
     9c8: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     9cc: ad0705a3     	stp	q3, q1, [x13, #0xe0]
     9d0: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     9d4: ad071d86     	stp	q6, q7, [x12, #0xe0]
     9d8: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     9dc: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     9e0: ad0405a2     	stp	q2, q1, [x13, #0x80]
     9e4: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     9e8: ad0505a3     	stp	q3, q1, [x13, #0xa0]
     9ec: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     9f0: ad061584     	stp	q4, q5, [x12, #0xc0]
     9f4: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     9f8: ad0205a2     	stp	q2, q1, [x13, #0x40]
     9fc: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     a00: ad0305a3     	stp	q3, q1, [x13, #0x60]
     a04: ad4007e2     	ldp	q2, q1, [sp]
     a08: ad044590     	stp	q16, q17, [x12, #0x80]
     a0c: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     a10: ad0005a2     	stp	q2, q1, [x13]
     a14: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     a18: ad006598     	stp	q24, q25, [x12]
     a1c: 3dc003f8     	ldr	q24, [sp]
     a20: ad416be2     	ldp	q2, q26, [sp, #0x20]
     a24: ad0105a3     	stp	q3, q1, [x13, #0x20]
     a28: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     a2c: ad025594     	stp	q20, q21, [x12, #0x40]
     a30: b85c0294     	ldur	w20, [x20, #-0x40]
     a34: ad016982     	stp	q2, q26, [x12, #0x20]
     a38: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     a3c: b85c00e7     	ldur	w7, [x7, #-0x40]
     a40: 138748e7     	ror	w7, w7, #0x12
     a44: ad060961     	stp	q1, q2, [x11, #0xc0]
     a48: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     a4c: 4ad41ce7     	eor	w7, w7, w20, ror #7
     a50: 8b040254     	add	x20, x18, x4
     a54: ad070563     	stp	q3, q1, [x11, #0xe0]
     a58: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     a5c: ad071d46     	stp	q6, q7, [x10, #0xe0]
     a60: 3dc03fe7     	ldr	q7, [sp, #0xf0]
     a64: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     a68: ad040562     	stp	q2, q1, [x11, #0x80]
     a6c: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     a70: ad050563     	stp	q3, q1, [x11, #0xa0]
     a74: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     a78: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     a7c: ad061544     	stp	q4, q5, [x10, #0xc0]
     a80: ad020562     	stp	q2, q1, [x11, #0x40]
     a84: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     a88: ad030563     	stp	q3, q1, [x11, #0x60]
     a8c: ad4007e2     	ldp	q2, q1, [sp]
     a90: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     a94: ad044550     	stp	q16, q17, [x10, #0x80]
     a98: ad000562     	stp	q2, q1, [x11]
     a9c: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     aa0: ad416be2     	ldp	q2, q26, [sp, #0x20]
     aa4: ad006558     	stp	q24, q25, [x10]
     aa8: 3dc003f8     	ldr	q24, [sp]
     aac: ad010563     	stp	q3, q1, [x11, #0x20]
     ab0: ad468fe5     	ldp	q5, q3, [sp, #0xd0]
     ab4: ad016942     	stp	q2, q26, [x10, #0x20]
     ab8: ad460be1     	ldp	q1, q2, [sp, #0xc0]
     abc: ad025554     	stp	q20, q21, [x10, #0x40]
     ac0: b85c0294     	ldur	w20, [x20, #-0x40]
     ac4: b85c02b5     	ldur	w21, [x21, #-0x40]
     ac8: ad060921     	stp	q1, q2, [x9, #0xc0]
     acc: ad4707e6     	ldp	q6, q1, [sp, #0xe0]
     ad0: 4a540ce7     	eor	w7, w7, w20, lsr #3
     ad4: 0b1602f4     	add	w20, w23, w22
     ad8: ad070523     	stp	q3, q1, [x9, #0xe0]
     adc: ad4407e2     	ldp	q2, q1, [sp, #0x80]
     ae0: ad448ff1     	ldp	q17, q3, [sp, #0x90]
     ae4: ad071d06     	stp	q6, q7, [x8, #0xe0]
     ae8: 0b070287     	add	w7, w20, w7
     aec: ad040522     	stp	q2, q1, [x9, #0x80]
     af0: ad4593e1     	ldp	q1, q4, [sp, #0xb0]
     af4: ad050523     	stp	q3, q1, [x9, #0xa0]
     af8: ad4207e2     	ldp	q2, q1, [sp, #0x40]
     afc: ad428ff5     	ldp	q21, q3, [sp, #0x50]
     b00: ad061504     	stp	q4, q5, [x8, #0xc0]
     b04: ad020522     	stp	q2, q1, [x9, #0x40]
     b08: ad43c3e1     	ldp	q1, q16, [sp, #0x70]
     b0c: ad030523     	stp	q3, q1, [x9, #0x60]
     b10: ad4007e2     	ldp	q2, q1, [sp]
     b14: ad408ff9     	ldp	q25, q3, [sp, #0x10]
     b18: ad044510     	stp	q16, q17, [x8, #0x80]
     b1c: ad000522     	stp	q2, q1, [x9]
     b20: ad41d3e1     	ldp	q1, q20, [sp, #0x30]
     b24: ad416be2     	ldp	q2, q26, [sp, #0x20]
     b28: ad006518     	stp	q24, q25, [x8]
     b2c: ad010523     	stp	q3, q1, [x9, #0x20]
     b30: b85c0273     	ldur	w19, [x19, #-0x40]
     b34: ad016902     	stp	q2, q26, [x8, #0x20]
     b38: ad025514     	stp	q20, q21, [x8, #0x40]
     b3c: 13934e73     	ror	w19, w19, #0x13
     b40: 4ad54673     	eor	w19, w19, w21, ror #17
     b44: 8b0401f5     	add	x21, x15, x4
     b48: b85c02b5     	ldur	w21, [x21, #-0x40]
     b4c: 4a552a73     	eor	w19, w19, w21, lsr #10
     b50: 0b1300e7     	add	w7, w7, w19
     b54: b82468c7     	str	w7, [x6, x4]
     b58: 91001084     	add	x4, x4, #0x4
     b5c: f104009f     	cmp	x4, #0x100
     b60: 54ffec01     	b.ne	 <L0>
     b64: 2941b009     	ldp	w9, w12, [x0, #0xc]
     b68: 29402c08     	ldp	w8, w11, [x0]
     b6c: 2942b40f     	ldp	w15, w13, [x0, #0x14]
     b70: 1e26000e     	fmov	w14, s0
     b74: 138c1990     	ror	w16, w12, #0x6
     b78: b9401c11     	ldr	w17, [x0, #0x1c]
     b7c: 13880902     	ror	w2, w8, #0x2
     b80: b940080a     	ldr	w10, [x0, #0x8]
     b84: 52889223     	mov	w3, #0x4491             // =17553
     b88: 0a2c01b2     	bic	w18, w13, w12
     b8c: 0a0c01e1     	and	w1, w15, w12
     b90: 4acc2e10     	eor	w16, w16, w12, ror #11
     b94: 0b0e022e     	add	w14, w17, w14
     b98: 5285f311     	mov	w17, #0x2f98            // =12184
     b9c: 2a120032     	orr	w18, w1, w18
     ba0: 4ac83441     	eor	w1, w2, w8, ror #13
     ba4: 72a85151     	movk	w17, #0x428a, lsl #16
     ba8: 2a0b0142     	orr	w2, w10, w11
     bac: 0b1201ce     	add	w14, w14, w18
     bb0: 4acc6610     	eor	w16, w16, w12, ror #25
     bb4: 0a080052     	and	w18, w2, w8
     bb8: 0b1101ce     	add	w14, w14, w17
     bbc: 4ac85831     	eor	w17, w1, w8, ror #22
     bc0: 0a0b0141     	and	w1, w10, w11
     bc4: 2a010252     	orr	w18, w18, w1
     bc8: 0b0e0210     	add	w16, w16, w14
     bcc: 72ae26e3     	movk	w3, #0x7137, lsl #16
     bd0: 0b110251     	add	w17, w18, w17
     bd4: 0b09020e     	add	w14, w16, w9
     bd8: 0b100229     	add	w9, w17, w16
     bdc: 138e19d0     	ror	w16, w14, #0x6
     be0: 0a2e01e1     	bic	w1, w15, w14
     be4: 2940c7f2     	ldp	w18, w17, [sp, #0x4]
     be8: 0a0e0182     	and	w2, w12, w14
     bec: 4ace2e10     	eor	w16, w16, w14, ror #11
     bf0: 2a010041     	orr	w1, w2, w1
     bf4: 2a080162     	orr	w2, w11, w8
     bf8: 0b1201ad     	add	w13, w13, w18
     bfc: 13890932     	ror	w18, w9, #0x2
     c00: 4ace6610     	eor	w16, w16, w14, ror #25
     c04: 0b0101ad     	add	w13, w13, w1
     c08: 0a020121     	and	w1, w9, w2
     c0c: 0a080162     	and	w2, w11, w8
     c10: 4ac93652     	eor	w18, w18, w9, ror #13
     c14: 0b0301ad     	add	w13, w13, w3
     c18: 2a020021     	orr	w1, w1, w2
     c1c: 0b1001b0     	add	w16, w13, w16
     c20: 0b1101ef     	add	w15, w15, w17
     c24: 2a080131     	orr	w17, w9, w8
     c28: 4ac95a52     	eor	w18, w18, w9, ror #22
     c2c: 0b0a020d     	add	w13, w16, w10
     c30: 0a2d0182     	bic	w2, w12, w13
     c34: 0a0d01c3     	and	w3, w14, w13
     c38: 0b010252     	add	w18, w18, w1
     c3c: 2a020062     	orr	w2, w3, w2
     c40: 0a080123     	and	w3, w9, w8
     c44: 0b10024a     	add	w10, w18, w16
     c48: 138d19b2     	ror	w18, w13, #0x6
     c4c: 529f79f0     	mov	w16, #0xfbcf            // =64463
     c50: 138a0941     	ror	w1, w10, #0x2
     c54: 72b6b810     	movk	w16, #0xb5c0, lsl #16
     c58: 0a110151     	and	w17, w10, w17
     c5c: 4acd2e52     	eor	w18, w18, w13, ror #11
     c60: 0b0201ef     	add	w15, w15, w2
     c64: 2a030231     	orr	w17, w17, w3
     c68: 4aca3421     	eor	w1, w1, w10, ror #13
     c6c: 0b1001ef     	add	w15, w15, w16
     c70: 529b74b0     	mov	w16, #0xdba5            // =56229
     c74: 4acd6652     	eor	w18, w18, w13, ror #25
     c78: 72bd36b0     	movk	w16, #0xe9b5, lsl #16
     c7c: 4aca5821     	eor	w1, w1, w10, ror #22
     c80: ad400c02     	ldp	q2, q3, [x0]
     c84: 0b1201f2     	add	w18, w15, w18
     c88: 0b110031     	add	w17, w1, w17
     c8c: 0b0b024f     	add	w15, w18, w11
     c90: 0b12022b     	add	w11, w17, w18
     c94: 138f19e1     	ror	w1, w15, #0x6
     c98: 0a0f01a3     	and	w3, w13, w15
     c9c: 2941cbf1     	ldp	w17, w18, [sp, #0xc]
     ca0: 138b0962     	ror	w2, w11, #0x2
     ca4: 4acf2c21     	eor	w1, w1, w15, ror #11
     ca8: 0b11018c     	add	w12, w12, w17
     cac: 0a2f01d1     	bic	w17, w14, w15
     cb0: 4acb3442     	eor	w2, w2, w11, ror #13
     cb4: 2a110071     	orr	w17, w3, w17
     cb8: 2a090143     	orr	w3, w10, w9
     cbc: 4acf6421     	eor	w1, w1, w15, ror #25
     cc0: 0b11018c     	add	w12, w12, w17
     cc4: 0a090151     	and	w17, w10, w9
     cc8: 0a030163     	and	w3, w11, w3
     ccc: 4acb5842     	eor	w2, w2, w11, ror #22
     cd0: 2a110071     	orr	w17, w3, w17
     cd4: 0b10018c     	add	w12, w12, w16
     cd8: 0b010190     	add	w16, w12, w1
     cdc: 0b0e024e     	add	w14, w18, w14
     ce0: 2a0a0172     	orr	w18, w11, w10
     ce4: 0b110051     	add	w17, w2, w17
     ce8: 0b08020c     	add	w12, w16, w8
     cec: 0b100228     	add	w8, w17, w16
     cf0: 138c1991     	ror	w17, w12, #0x6
     cf4: 0a2c01a2     	bic	w2, w13, w12
     cf8: 13880901     	ror	w1, w8, #0x2
     cfc: 0a0c01e3     	and	w3, w15, w12
     d00: 52984b70     	mov	w16, #0xc25b            // =49755
     d04: 4acc2e31     	eor	w17, w17, w12, ror #11
     d08: 2a020062     	orr	w2, w3, w2
     d0c: 72a72ad0     	movk	w16, #0x3956, lsl #16
     d10: 4ac83421     	eor	w1, w1, w8, ror #13
     d14: 0a0a0163     	and	w3, w11, w10
     d18: 0a120112     	and	w18, w8, w18
     d1c: 0b0201ce     	add	w14, w14, w2
     d20: 4acc6631     	eor	w17, w17, w12, ror #25
     d24: 2a030252     	orr	w18, w18, w3
     d28: 4ac85821     	eor	w1, w1, w8, ror #22
     d2c: 0b1001ce     	add	w14, w14, w16
     d30: 52823e30     	mov	w16, #0x11f1            // =4593
     d34: 0b1101d1     	add	w17, w14, w17
     d38: 72ab3e30     	movk	w16, #0x59f1, lsl #16
     d3c: 0b120032     	add	w18, w1, w18
     d40: 0b09022e     	add	w14, w17, w9
     d44: 0b110249     	add	w9, w18, w17
     d48: 138e19c1     	ror	w1, w14, #0x6
     d4c: 0a0e0183     	and	w3, w12, w14
     d50: 2942cbf1     	ldp	w17, w18, [sp, #0x14]
     d54: 13890922     	ror	w2, w9, #0x2
     d58: 4ace2c21     	eor	w1, w1, w14, ror #11
     d5c: 0b0d022d     	add	w13, w17, w13
     d60: 0a2e01f1     	bic	w17, w15, w14
     d64: 4ac93442     	eor	w2, w2, w9, ror #13
     d68: 2a110071     	orr	w17, w3, w17
     d6c: 2a0b0103     	orr	w3, w8, w11
     d70: 4ace6421     	eor	w1, w1, w14, ror #25
     d74: 0b1101ad     	add	w13, w13, w17
     d78: 0a0b0111     	and	w17, w8, w11
     d7c: 0a030123     	and	w3, w9, w3
     d80: 4ac95842     	eor	w2, w2, w9, ror #22
     d84: 2a110071     	orr	w17, w3, w17
     d88: 0b1001ad     	add	w13, w13, w16
     d8c: 0b0101b0     	add	w16, w13, w1
     d90: 0b0f024f     	add	w15, w18, w15
     d94: 2a080132     	orr	w18, w9, w8
     d98: 0b110051     	add	w17, w2, w17
     d9c: 0b0a020d     	add	w13, w16, w10
     da0: 0b10022a     	add	w10, w17, w16
     da4: 138d19b1     	ror	w17, w13, #0x6
     da8: 0a2d0182     	bic	w2, w12, w13
     dac: 138a0941     	ror	w1, w10, #0x2
     db0: 0a0d01c3     	and	w3, w14, w13
     db4: 52905490     	mov	w16, #0x82a4            // =33444
     db8: 4acd2e31     	eor	w17, w17, w13, ror #11
     dbc: 2a020062     	orr	w2, w3, w2
     dc0: 72b247f0     	movk	w16, #0x923f, lsl #16
     dc4: 4aca3421     	eor	w1, w1, w10, ror #13
     dc8: 0a080123     	and	w3, w9, w8
     dcc: 0a120152     	and	w18, w10, w18
     dd0: 0b0201ef     	add	w15, w15, w2
     dd4: 4acd6631     	eor	w17, w17, w13, ror #25
     dd8: 2a030252     	orr	w18, w18, w3
     ddc: 4aca5821     	eor	w1, w1, w10, ror #22
     de0: 0b1001ef     	add	w15, w15, w16
     de4: 528bdab0     	mov	w16, #0x5ed5            // =24277
     de8: 0b1101f1     	add	w17, w15, w17
     dec: 72b56390     	movk	w16, #0xab1c, lsl #16
     df0: 0b120032     	add	w18, w1, w18
     df4: 0b0b022f     	add	w15, w17, w11
     df8: 0b11024b     	add	w11, w18, w17
     dfc: 138f19e1     	ror	w1, w15, #0x6
     e00: 0a0f01a3     	and	w3, w13, w15
     e04: 2943cbf1     	ldp	w17, w18, [sp, #0x1c]
     e08: 138b0962     	ror	w2, w11, #0x2
     e0c: 4acf2c21     	eor	w1, w1, w15, ror #11
     e10: 0b0c022c     	add	w12, w17, w12
     e14: 0a2f01d1     	bic	w17, w14, w15
     e18: 4acb3442     	eor	w2, w2, w11, ror #13
     e1c: 2a110071     	orr	w17, w3, w17
     e20: 2a090143     	orr	w3, w10, w9
     e24: 4acf6421     	eor	w1, w1, w15, ror #25
     e28: 0b11018c     	add	w12, w12, w17
     e2c: 0a090151     	and	w17, w10, w9
     e30: 0a030163     	and	w3, w11, w3
     e34: 4acb5842     	eor	w2, w2, w11, ror #22
     e38: 2a110071     	orr	w17, w3, w17
     e3c: 0b10018c     	add	w12, w12, w16
     e40: 0b010190     	add	w16, w12, w1
     e44: 0b0e024e     	add	w14, w18, w14
     e48: 2a0a0172     	orr	w18, w11, w10
     e4c: 0b110051     	add	w17, w2, w17
     e50: 0b08020c     	add	w12, w16, w8
     e54: 0b100228     	add	w8, w17, w16
     e58: 138c1991     	ror	w17, w12, #0x6
     e5c: 0a2c01a2     	bic	w2, w13, w12
     e60: 13880901     	ror	w1, w8, #0x2
     e64: 0a0c01e3     	and	w3, w15, w12
     e68: 52955310     	mov	w16, #0xaa98            // =43672
     e6c: 4acc2e31     	eor	w17, w17, w12, ror #11
     e70: 2a020062     	orr	w2, w3, w2
     e74: 72bb00f0     	movk	w16, #0xd807, lsl #16
     e78: 4ac83421     	eor	w1, w1, w8, ror #13
     e7c: 0a0a0163     	and	w3, w11, w10
     e80: 0a120112     	and	w18, w8, w18
     e84: 0b0201ce     	add	w14, w14, w2
     e88: 4acc6631     	eor	w17, w17, w12, ror #25
     e8c: 2a030252     	orr	w18, w18, w3
     e90: 4ac85821     	eor	w1, w1, w8, ror #22
     e94: 0b1001ce     	add	w14, w14, w16
     e98: 528b6030     	mov	w16, #0x5b01            // =23297
     e9c: 0b1101d1     	add	w17, w14, w17
     ea0: 72a25070     	movk	w16, #0x1283, lsl #16
     ea4: 0b120032     	add	w18, w1, w18
     ea8: 0b09022e     	add	w14, w17, w9
     eac: 0b110249     	add	w9, w18, w17
     eb0: 138e19c1     	ror	w1, w14, #0x6
     eb4: 0a0e0183     	and	w3, w12, w14
     eb8: 2944cbf1     	ldp	w17, w18, [sp, #0x24]
     ebc: 13890922     	ror	w2, w9, #0x2
     ec0: 4ace2c21     	eor	w1, w1, w14, ror #11
     ec4: 0b0d022d     	add	w13, w17, w13
     ec8: 0a2e01f1     	bic	w17, w15, w14
     ecc: 4ac93442     	eor	w2, w2, w9, ror #13
     ed0: 2a110071     	orr	w17, w3, w17
     ed4: 2a0b0103     	orr	w3, w8, w11
     ed8: 4ace6421     	eor	w1, w1, w14, ror #25
     edc: 0b1101ad     	add	w13, w13, w17
     ee0: 0a0b0111     	and	w17, w8, w11
     ee4: 0a030123     	and	w3, w9, w3
     ee8: 4ac95842     	eor	w2, w2, w9, ror #22
     eec: 2a110071     	orr	w17, w3, w17
     ef0: 0b1001ad     	add	w13, w13, w16
     ef4: 0b0101b0     	add	w16, w13, w1
     ef8: 0b0f024f     	add	w15, w18, w15
     efc: 2a080132     	orr	w18, w9, w8
     f00: 0b110051     	add	w17, w2, w17
     f04: 0b0a020d     	add	w13, w16, w10
     f08: 0b10022a     	add	w10, w17, w16
     f0c: 138d19b1     	ror	w17, w13, #0x6
     f10: 0a2d0182     	bic	w2, w12, w13
     f14: 138a0941     	ror	w1, w10, #0x2
     f18: 0a0d01c3     	and	w3, w14, w13
     f1c: 5290b7d0     	mov	w16, #0x85be            // =34238
     f20: 4acd2e31     	eor	w17, w17, w13, ror #11
     f24: 2a020062     	orr	w2, w3, w2
     f28: 72a48630     	movk	w16, #0x2431, lsl #16
     f2c: 4aca3421     	eor	w1, w1, w10, ror #13
     f30: 0a080123     	and	w3, w9, w8
     f34: 0a120152     	and	w18, w10, w18
     f38: 0b0201ef     	add	w15, w15, w2
     f3c: 4acd6631     	eor	w17, w17, w13, ror #25
     f40: 2a030252     	orr	w18, w18, w3
     f44: 4aca5821     	eor	w1, w1, w10, ror #22
     f48: 0b1001ef     	add	w15, w15, w16
     f4c: 528fb870     	mov	w16, #0x7dc3            // =32195
     f50: 0b1101f1     	add	w17, w15, w17
     f54: 72aaa190     	movk	w16, #0x550c, lsl #16
     f58: 0b120032     	add	w18, w1, w18
     f5c: 0b0b022f     	add	w15, w17, w11
     f60: 0b11024b     	add	w11, w18, w17
     f64: 138f19e1     	ror	w1, w15, #0x6
     f68: 0a0f01a3     	and	w3, w13, w15
     f6c: 2945cbf1     	ldp	w17, w18, [sp, #0x2c]
     f70: 138b0962     	ror	w2, w11, #0x2
     f74: 4acf2c21     	eor	w1, w1, w15, ror #11
     f78: 0b0c022c     	add	w12, w17, w12
     f7c: 0a2f01d1     	bic	w17, w14, w15
     f80: 4acb3442     	eor	w2, w2, w11, ror #13
     f84: 2a110071     	orr	w17, w3, w17
     f88: 2a090143     	orr	w3, w10, w9
     f8c: 4acf6421     	eor	w1, w1, w15, ror #25
     f90: 0b11018c     	add	w12, w12, w17
     f94: 0a090151     	and	w17, w10, w9
     f98: 0a030163     	and	w3, w11, w3
     f9c: 4acb5842     	eor	w2, w2, w11, ror #22
     fa0: 2a110071     	orr	w17, w3, w17
     fa4: 0b10018c     	add	w12, w12, w16
     fa8: 0b010190     	add	w16, w12, w1
     fac: 0b0e024e     	add	w14, w18, w14
     fb0: 2a0a0172     	orr	w18, w11, w10
     fb4: 0b110051     	add	w17, w2, w17
     fb8: 0b08020c     	add	w12, w16, w8
     fbc: 0b100228     	add	w8, w17, w16
     fc0: 138c1991     	ror	w17, w12, #0x6
     fc4: 0a2c01a2     	bic	w2, w13, w12
     fc8: 13880901     	ror	w1, w8, #0x2
     fcc: 0a0c01e3     	and	w3, w15, w12
     fd0: 528bae90     	mov	w16, #0x5d74            // =23924
     fd4: 4acc2e31     	eor	w17, w17, w12, ror #11
     fd8: 2a020062     	orr	w2, w3, w2
     fdc: 72ae57d0     	movk	w16, #0x72be, lsl #16
     fe0: 4ac83421     	eor	w1, w1, w8, ror #13
     fe4: 0a0a0163     	and	w3, w11, w10
     fe8: 0a120112     	and	w18, w8, w18
     fec: 0b0201ce     	add	w14, w14, w2
     ff0: 4acc6631     	eor	w17, w17, w12, ror #25
     ff4: 2a030252     	orr	w18, w18, w3
     ff8: 4ac85821     	eor	w1, w1, w8, ror #22
     ffc: 0b1001ce     	add	w14, w14, w16
    1000: 52963fd0     	mov	w16, #0xb1fe            // =45566
    1004: 0b1101d1     	add	w17, w14, w17
    1008: 72b01bd0     	movk	w16, #0x80de, lsl #16
    100c: 0b120032     	add	w18, w1, w18
    1010: 0b09022e     	add	w14, w17, w9
    1014: 0b110249     	add	w9, w18, w17
    1018: 138e19c1     	ror	w1, w14, #0x6
    101c: 0a0e0183     	and	w3, w12, w14
    1020: 2946cbf1     	ldp	w17, w18, [sp, #0x34]
    1024: 13890922     	ror	w2, w9, #0x2
    1028: 4ace2c21     	eor	w1, w1, w14, ror #11
    102c: 0b0d022d     	add	w13, w17, w13
    1030: 0a2e01f1     	bic	w17, w15, w14
    1034: 4ac93442     	eor	w2, w2, w9, ror #13
    1038: 2a110071     	orr	w17, w3, w17
    103c: 2a0b0103     	orr	w3, w8, w11
    1040: 4ace6421     	eor	w1, w1, w14, ror #25
    1044: 0b1101ad     	add	w13, w13, w17
    1048: 0a0b0111     	and	w17, w8, w11
    104c: 0a030123     	and	w3, w9, w3
    1050: 4ac95842     	eor	w2, w2, w9, ror #22
    1054: 2a110071     	orr	w17, w3, w17
    1058: 0b1001ad     	add	w13, w13, w16
    105c: 0b0101b0     	add	w16, w13, w1
    1060: 0b0f024f     	add	w15, w18, w15
    1064: 2a080132     	orr	w18, w9, w8
    1068: 0b110051     	add	w17, w2, w17
    106c: 0b0a020d     	add	w13, w16, w10
    1070: 0b10022a     	add	w10, w17, w16
    1074: 138d19b1     	ror	w17, w13, #0x6
    1078: 0a2d0182     	bic	w2, w12, w13
    107c: 138a0941     	ror	w1, w10, #0x2
    1080: 0a0d01c3     	and	w3, w14, w13
    1084: 5280d4f0     	mov	w16, #0x6a7             // =1703
    1088: 4acd2e31     	eor	w17, w17, w13, ror #11
    108c: 2a020062     	orr	w2, w3, w2
    1090: 72b37b90     	movk	w16, #0x9bdc, lsl #16
    1094: 4aca3421     	eor	w1, w1, w10, ror #13
    1098: 0a080123     	and	w3, w9, w8
    109c: 0a120152     	and	w18, w10, w18
    10a0: 0b0201ef     	add	w15, w15, w2
    10a4: 4acd6631     	eor	w17, w17, w13, ror #25
    10a8: 2a030252     	orr	w18, w18, w3
    10ac: 4aca5821     	eor	w1, w1, w10, ror #22
    10b0: 0b1001ef     	add	w15, w15, w16
    10b4: 529e2e90     	mov	w16, #0xf174            // =61812
    10b8: 0b1101f1     	add	w17, w15, w17
    10bc: 72b83370     	movk	w16, #0xc19b, lsl #16
    10c0: 0b120032     	add	w18, w1, w18
    10c4: 0b0b022f     	add	w15, w17, w11
    10c8: 0b11024b     	add	w11, w18, w17
    10cc: 138f19e1     	ror	w1, w15, #0x6
    10d0: 0a0f01a3     	and	w3, w13, w15
    10d4: 2947cbf1     	ldp	w17, w18, [sp, #0x3c]
    10d8: 138b0962     	ror	w2, w11, #0x2
    10dc: 4acf2c21     	eor	w1, w1, w15, ror #11
    10e0: 0b0c022c     	add	w12, w17, w12
    10e4: 0a2f01d1     	bic	w17, w14, w15
    10e8: 4acb3442     	eor	w2, w2, w11, ror #13
    10ec: 2a110071     	orr	w17, w3, w17
    10f0: 2a090143     	orr	w3, w10, w9
    10f4: 4acf6421     	eor	w1, w1, w15, ror #25
    10f8: 0b11018c     	add	w12, w12, w17
    10fc: 0a090151     	and	w17, w10, w9
    1100: 0a030163     	and	w3, w11, w3
    1104: 4acb5842     	eor	w2, w2, w11, ror #22
    1108: 2a110071     	orr	w17, w3, w17
    110c: 0b10018c     	add	w12, w12, w16
    1110: 0b010190     	add	w16, w12, w1
    1114: 0b0e024e     	add	w14, w18, w14
    1118: 2a0a0172     	orr	w18, w11, w10
    111c: 0b110051     	add	w17, w2, w17
    1120: 0b08020c     	add	w12, w16, w8
    1124: 0b100228     	add	w8, w17, w16
    1128: 138c1991     	ror	w17, w12, #0x6
    112c: 0a2c01a2     	bic	w2, w13, w12
    1130: 13880901     	ror	w1, w8, #0x2
    1134: 0a0c01e3     	and	w3, w15, w12
    1138: 528d3830     	mov	w16, #0x69c1            // =27073
    113c: 4acc2e31     	eor	w17, w17, w12, ror #11
    1140: 2a020062     	orr	w2, w3, w2
    1144: 72bc9370     	movk	w16, #0xe49b, lsl #16
    1148: 4ac83421     	eor	w1, w1, w8, ror #13
    114c: 0a0a0163     	and	w3, w11, w10
    1150: 0a120112     	and	w18, w8, w18
    1154: 0b0201ce     	add	w14, w14, w2
    1158: 4acc6631     	eor	w17, w17, w12, ror #25
    115c: 2a030252     	orr	w18, w18, w3
    1160: 4ac85821     	eor	w1, w1, w8, ror #22
    1164: 0b1001ce     	add	w14, w14, w16
    1168: 5288f0d0     	mov	w16, #0x4786            // =18310
    116c: 0b1101d1     	add	w17, w14, w17
    1170: 72bdf7d0     	movk	w16, #0xefbe, lsl #16
    1174: 0b120032     	add	w18, w1, w18
    1178: 0b09022e     	add	w14, w17, w9
    117c: 0b110249     	add	w9, w18, w17
    1180: 138e19c1     	ror	w1, w14, #0x6
    1184: 0a0e0183     	and	w3, w12, w14
    1188: 2948cbf1     	ldp	w17, w18, [sp, #0x44]
    118c: 13890922     	ror	w2, w9, #0x2
    1190: 4ace2c21     	eor	w1, w1, w14, ror #11
    1194: 0b0d022d     	add	w13, w17, w13
    1198: 0a2e01f1     	bic	w17, w15, w14
    119c: 4ac93442     	eor	w2, w2, w9, ror #13
    11a0: 2a110071     	orr	w17, w3, w17
    11a4: 2a0b0103     	orr	w3, w8, w11
    11a8: 4ace6421     	eor	w1, w1, w14, ror #25
    11ac: 0b1101ad     	add	w13, w13, w17
    11b0: 0a0b0111     	and	w17, w8, w11
    11b4: 0a030123     	and	w3, w9, w3
    11b8: 4ac95842     	eor	w2, w2, w9, ror #22
    11bc: 2a110071     	orr	w17, w3, w17
    11c0: 0b1001ad     	add	w13, w13, w16
    11c4: 0b0101b0     	add	w16, w13, w1
    11c8: 0b0f024f     	add	w15, w18, w15
    11cc: 2a080132     	orr	w18, w9, w8
    11d0: 0b110051     	add	w17, w2, w17
    11d4: 0b0a020d     	add	w13, w16, w10
    11d8: 0b10022a     	add	w10, w17, w16
    11dc: 138d19b1     	ror	w17, w13, #0x6
    11e0: 0a2d0182     	bic	w2, w12, w13
    11e4: 138a0941     	ror	w1, w10, #0x2
    11e8: 0a0d01c3     	and	w3, w14, w13
    11ec: 5293b8d0     	mov	w16, #0x9dc6            // =40390
    11f0: 4acd2e31     	eor	w17, w17, w13, ror #11
    11f4: 2a020062     	orr	w2, w3, w2
    11f8: 72a1f830     	movk	w16, #0xfc1, lsl #16
    11fc: 4aca3421     	eor	w1, w1, w10, ror #13
    1200: 0a080123     	and	w3, w9, w8
    1204: 0a120152     	and	w18, w10, w18
    1208: 0b0201ef     	add	w15, w15, w2
    120c: 4acd6631     	eor	w17, w17, w13, ror #25
    1210: 2a030252     	orr	w18, w18, w3
    1214: 4aca5821     	eor	w1, w1, w10, ror #22
    1218: 0b1001ef     	add	w15, w15, w16
    121c: 52943990     	mov	w16, #0xa1cc            // =41420
    1220: 0b1101f1     	add	w17, w15, w17
    1224: 72a48190     	movk	w16, #0x240c, lsl #16
    1228: 0b120032     	add	w18, w1, w18
    122c: 0b0b022f     	add	w15, w17, w11
    1230: 0b11024b     	add	w11, w18, w17
    1234: 138f19e1     	ror	w1, w15, #0x6
    1238: 0a0f01a3     	and	w3, w13, w15
    123c: 2949cbf1     	ldp	w17, w18, [sp, #0x4c]
    1240: 138b0962     	ror	w2, w11, #0x2
    1244: 4acf2c21     	eor	w1, w1, w15, ror #11
    1248: 0b0c022c     	add	w12, w17, w12
    124c: 0a2f01d1     	bic	w17, w14, w15
    1250: 4acb3442     	eor	w2, w2, w11, ror #13
    1254: 2a110071     	orr	w17, w3, w17
    1258: 2a090143     	orr	w3, w10, w9
    125c: 4acf6421     	eor	w1, w1, w15, ror #25
    1260: 0b11018c     	add	w12, w12, w17
    1264: 0a090151     	and	w17, w10, w9
    1268: 0a030163     	and	w3, w11, w3
    126c: 4acb5842     	eor	w2, w2, w11, ror #22
    1270: 2a110071     	orr	w17, w3, w17
    1274: 0b10018c     	add	w12, w12, w16
    1278: 0b010190     	add	w16, w12, w1
    127c: 0b0e024e     	add	w14, w18, w14
    1280: 2a0a0172     	orr	w18, w11, w10
    1284: 0b110051     	add	w17, w2, w17
    1288: 0b08020c     	add	w12, w16, w8
    128c: 0b100228     	add	w8, w17, w16
    1290: 138c1991     	ror	w17, w12, #0x6
    1294: 0a2c01a2     	bic	w2, w13, w12
    1298: 13880901     	ror	w1, w8, #0x2
    129c: 0a0c01e3     	and	w3, w15, w12
    12a0: 52858df0     	mov	w16, #0x2c6f            // =11375
    12a4: 4acc2e31     	eor	w17, w17, w12, ror #11
    12a8: 2a020062     	orr	w2, w3, w2
    12ac: 72a5bd30     	movk	w16, #0x2de9, lsl #16
    12b0: 4ac83421     	eor	w1, w1, w8, ror #13
    12b4: 0a0a0163     	and	w3, w11, w10
    12b8: 0a120112     	and	w18, w8, w18
    12bc: 0b0201ce     	add	w14, w14, w2
    12c0: 4acc6631     	eor	w17, w17, w12, ror #25
    12c4: 2a030252     	orr	w18, w18, w3
    12c8: 4ac85821     	eor	w1, w1, w8, ror #22
    12cc: 0b1001ce     	add	w14, w14, w16
    12d0: 52909550     	mov	w16, #0x84aa            // =33962
    12d4: 0b1101d1     	add	w17, w14, w17
    12d8: 72a94e90     	movk	w16, #0x4a74, lsl #16
    12dc: 0b120032     	add	w18, w1, w18
    12e0: 0b09022e     	add	w14, w17, w9
    12e4: 0b110249     	add	w9, w18, w17
    12e8: 138e19c1     	ror	w1, w14, #0x6
    12ec: 0a0e0183     	and	w3, w12, w14
    12f0: 294acbf1     	ldp	w17, w18, [sp, #0x54]
    12f4: 13890922     	ror	w2, w9, #0x2
    12f8: 4ace2c21     	eor	w1, w1, w14, ror #11
    12fc: 0b0d022d     	add	w13, w17, w13
    1300: 0a2e01f1     	bic	w17, w15, w14
    1304: 4ac93442     	eor	w2, w2, w9, ror #13
    1308: 2a110071     	orr	w17, w3, w17
    130c: 2a0b0103     	orr	w3, w8, w11
    1310: 4ace6421     	eor	w1, w1, w14, ror #25
    1314: 0b1101ad     	add	w13, w13, w17
    1318: 0a0b0111     	and	w17, w8, w11
    131c: 0a030123     	and	w3, w9, w3
    1320: 4ac95842     	eor	w2, w2, w9, ror #22
    1324: 2a110071     	orr	w17, w3, w17
    1328: 0b1001ad     	add	w13, w13, w16
    132c: 0b0101b0     	add	w16, w13, w1
    1330: 0b0f024f     	add	w15, w18, w15
    1334: 2a080132     	orr	w18, w9, w8
    1338: 0b110051     	add	w17, w2, w17
    133c: 0b0a020d     	add	w13, w16, w10
    1340: 0b10022a     	add	w10, w17, w16
    1344: 138d19b1     	ror	w17, w13, #0x6
    1348: 0a2d0182     	bic	w2, w12, w13
    134c: 138a0941     	ror	w1, w10, #0x2
    1350: 0a0d01c3     	and	w3, w14, w13
    1354: 52953b90     	mov	w16, #0xa9dc            // =43484
    1358: 4acd2e31     	eor	w17, w17, w13, ror #11
    135c: 2a020062     	orr	w2, w3, w2
    1360: 72ab9610     	movk	w16, #0x5cb0, lsl #16
    1364: 4aca3421     	eor	w1, w1, w10, ror #13
    1368: 0a080123     	and	w3, w9, w8
    136c: 0a120152     	and	w18, w10, w18
    1370: 0b0201ef     	add	w15, w15, w2
    1374: 4acd6631     	eor	w17, w17, w13, ror #25
    1378: 2a030252     	orr	w18, w18, w3
    137c: 4aca5821     	eor	w1, w1, w10, ror #22
    1380: 0b1001ef     	add	w15, w15, w16
    1384: 52911b50     	mov	w16, #0x88da            // =35034
    1388: 0b1101f1     	add	w17, w15, w17
    138c: 72aedf30     	movk	w16, #0x76f9, lsl #16
    1390: 0b120032     	add	w18, w1, w18
    1394: 0b0b022f     	add	w15, w17, w11
    1398: 0b11024b     	add	w11, w18, w17
    139c: 138f19e1     	ror	w1, w15, #0x6
    13a0: 0a0f01a3     	and	w3, w13, w15
    13a4: 294bcbf1     	ldp	w17, w18, [sp, #0x5c]
    13a8: 138b0962     	ror	w2, w11, #0x2
    13ac: 4acf2c21     	eor	w1, w1, w15, ror #11
    13b0: 0b0c022c     	add	w12, w17, w12
    13b4: 0a2f01d1     	bic	w17, w14, w15
    13b8: 4acb3442     	eor	w2, w2, w11, ror #13
    13bc: 2a110071     	orr	w17, w3, w17
    13c0: 2a090143     	orr	w3, w10, w9
    13c4: 4acf6421     	eor	w1, w1, w15, ror #25
    13c8: 0b11018c     	add	w12, w12, w17
    13cc: 0a090151     	and	w17, w10, w9
    13d0: 0a030163     	and	w3, w11, w3
    13d4: 4acb5842     	eor	w2, w2, w11, ror #22
    13d8: 2a110071     	orr	w17, w3, w17
    13dc: 0b10018c     	add	w12, w12, w16
    13e0: 0b010190     	add	w16, w12, w1
    13e4: 0b0e024e     	add	w14, w18, w14
    13e8: 2a0a0172     	orr	w18, w11, w10
    13ec: 0b110051     	add	w17, w2, w17
    13f0: 0b08020c     	add	w12, w16, w8
    13f4: 0b100228     	add	w8, w17, w16
    13f8: 138c1991     	ror	w17, w12, #0x6
    13fc: 0a2c01a2     	bic	w2, w13, w12
    1400: 13880901     	ror	w1, w8, #0x2
    1404: 0a0c01e3     	and	w3, w15, w12
    1408: 528a2a50     	mov	w16, #0x5152            // =20818
    140c: 4acc2e31     	eor	w17, w17, w12, ror #11
    1410: 2a020062     	orr	w2, w3, w2
    1414: 72b307d0     	movk	w16, #0x983e, lsl #16
    1418: 4ac83421     	eor	w1, w1, w8, ror #13
    141c: 0a0a0163     	and	w3, w11, w10
    1420: 0a120112     	and	w18, w8, w18
    1424: 0b0201ce     	add	w14, w14, w2
    1428: 4acc6631     	eor	w17, w17, w12, ror #25
    142c: 2a030252     	orr	w18, w18, w3
    1430: 4ac85821     	eor	w1, w1, w8, ror #22
    1434: 0b1001ce     	add	w14, w14, w16
    1438: 5298cdb0     	mov	w16, #0xc66d            // =50797
    143c: 0b1101d1     	add	w17, w14, w17
    1440: 72b50630     	movk	w16, #0xa831, lsl #16
    1444: 0b120032     	add	w18, w1, w18
    1448: 0b09022e     	add	w14, w17, w9
    144c: 0b110249     	add	w9, w18, w17
    1450: 138e19c1     	ror	w1, w14, #0x6
    1454: 0a0e0183     	and	w3, w12, w14
    1458: 294ccbf1     	ldp	w17, w18, [sp, #0x64]
    145c: 13890922     	ror	w2, w9, #0x2
    1460: 4ace2c21     	eor	w1, w1, w14, ror #11
    1464: 0b0d022d     	add	w13, w17, w13
    1468: 0a2e01f1     	bic	w17, w15, w14
    146c: 4ac93442     	eor	w2, w2, w9, ror #13
    1470: 2a110071     	orr	w17, w3, w17
    1474: 2a0b0103     	orr	w3, w8, w11
    1478: 4ace6421     	eor	w1, w1, w14, ror #25
    147c: 0b1101ad     	add	w13, w13, w17
    1480: 0a0b0111     	and	w17, w8, w11
    1484: 0a030123     	and	w3, w9, w3
    1488: 4ac95842     	eor	w2, w2, w9, ror #22
    148c: 2a110071     	orr	w17, w3, w17
    1490: 0b1001ad     	add	w13, w13, w16
    1494: 0b0101b0     	add	w16, w13, w1
    1498: 0b0f024f     	add	w15, w18, w15
    149c: 2a080132     	orr	w18, w9, w8
    14a0: 0b110051     	add	w17, w2, w17
    14a4: 0b0a020d     	add	w13, w16, w10
    14a8: 0b10022a     	add	w10, w17, w16
    14ac: 138d19b1     	ror	w17, w13, #0x6
    14b0: 0a2d0182     	bic	w2, w12, w13
    14b4: 138a0941     	ror	w1, w10, #0x2
    14b8: 0a0d01c3     	and	w3, w14, w13
    14bc: 5284f910     	mov	w16, #0x27c8            // =10184
    14c0: 4acd2e31     	eor	w17, w17, w13, ror #11
    14c4: 2a020062     	orr	w2, w3, w2
    14c8: 72b60070     	movk	w16, #0xb003, lsl #16
    14cc: 4aca3421     	eor	w1, w1, w10, ror #13
    14d0: 0a080123     	and	w3, w9, w8
    14d4: 0a120152     	and	w18, w10, w18
    14d8: 0b0201ef     	add	w15, w15, w2
    14dc: 4acd6631     	eor	w17, w17, w13, ror #25
    14e0: 2a030252     	orr	w18, w18, w3
    14e4: 4aca5821     	eor	w1, w1, w10, ror #22
    14e8: 0b1001ef     	add	w15, w15, w16
    14ec: 528ff8f0     	mov	w16, #0x7fc7            // =32711
    14f0: 0b1101f1     	add	w17, w15, w17
    14f4: 72b7eb30     	movk	w16, #0xbf59, lsl #16
    14f8: 0b120032     	add	w18, w1, w18
    14fc: 0b0b022f     	add	w15, w17, w11
    1500: 0b11024b     	add	w11, w18, w17
    1504: 138f19e1     	ror	w1, w15, #0x6
    1508: 0a0f01a3     	and	w3, w13, w15
    150c: 294dcbf1     	ldp	w17, w18, [sp, #0x6c]
    1510: 138b0962     	ror	w2, w11, #0x2
    1514: 4acf2c21     	eor	w1, w1, w15, ror #11
    1518: 0b0c022c     	add	w12, w17, w12
    151c: 0a2f01d1     	bic	w17, w14, w15
    1520: 4acb3442     	eor	w2, w2, w11, ror #13
    1524: 2a110071     	orr	w17, w3, w17
    1528: 2a090143     	orr	w3, w10, w9
    152c: 4acf6421     	eor	w1, w1, w15, ror #25
    1530: 0b11018c     	add	w12, w12, w17
    1534: 0a090151     	and	w17, w10, w9
    1538: 0a030163     	and	w3, w11, w3
    153c: 4acb5842     	eor	w2, w2, w11, ror #22
    1540: 2a110071     	orr	w17, w3, w17
    1544: 0b10018c     	add	w12, w12, w16
    1548: 0b010190     	add	w16, w12, w1
    154c: 0b0e024e     	add	w14, w18, w14
    1550: 2a0a0172     	orr	w18, w11, w10
    1554: 0b110051     	add	w17, w2, w17
    1558: 0b08020c     	add	w12, w16, w8
    155c: 0b100228     	add	w8, w17, w16
    1560: 138c1991     	ror	w17, w12, #0x6
    1564: 0a2c01a2     	bic	w2, w13, w12
    1568: 13880901     	ror	w1, w8, #0x2
    156c: 0a0c01e3     	and	w3, w15, w12
    1570: 52817e70     	mov	w16, #0xbf3             // =3059
    1574: 4acc2e31     	eor	w17, w17, w12, ror #11
    1578: 2a020062     	orr	w2, w3, w2
    157c: 72b8dc10     	movk	w16, #0xc6e0, lsl #16
    1580: 4ac83421     	eor	w1, w1, w8, ror #13
    1584: 0a0a0163     	and	w3, w11, w10
    1588: 0a120112     	and	w18, w8, w18
    158c: 0b0201ce     	add	w14, w14, w2
    1590: 4acc6631     	eor	w17, w17, w12, ror #25
    1594: 2a030252     	orr	w18, w18, w3
    1598: 4ac85821     	eor	w1, w1, w8, ror #22
    159c: 0b1001ce     	add	w14, w14, w16
    15a0: 529228f0     	mov	w16, #0x9147            // =37191
    15a4: 0b1101d1     	add	w17, w14, w17
    15a8: 72bab4f0     	movk	w16, #0xd5a7, lsl #16
    15ac: 0b120032     	add	w18, w1, w18
    15b0: 0b09022e     	add	w14, w17, w9
    15b4: 0b110249     	add	w9, w18, w17
    15b8: 138e19c1     	ror	w1, w14, #0x6
    15bc: 0a0e0183     	and	w3, w12, w14
    15c0: 294ecbf1     	ldp	w17, w18, [sp, #0x74]
    15c4: 13890922     	ror	w2, w9, #0x2
    15c8: 4ace2c21     	eor	w1, w1, w14, ror #11
    15cc: 0b0d022d     	add	w13, w17, w13
    15d0: 0a2e01f1     	bic	w17, w15, w14
    15d4: 4ac93442     	eor	w2, w2, w9, ror #13
    15d8: 2a110071     	orr	w17, w3, w17
    15dc: 2a0b0103     	orr	w3, w8, w11
    15e0: 4ace6421     	eor	w1, w1, w14, ror #25
    15e4: 0b1101ad     	add	w13, w13, w17
    15e8: 0a0b0111     	and	w17, w8, w11
    15ec: 0a030123     	and	w3, w9, w3
    15f0: 4ac95842     	eor	w2, w2, w9, ror #22
    15f4: 2a110071     	orr	w17, w3, w17
    15f8: 0b1001ad     	add	w13, w13, w16
    15fc: 0b0101b0     	add	w16, w13, w1
    1600: 0b0f024f     	add	w15, w18, w15
    1604: 2a080132     	orr	w18, w9, w8
    1608: 0b110051     	add	w17, w2, w17
    160c: 0b0a020d     	add	w13, w16, w10
    1610: 0b10022a     	add	w10, w17, w16
    1614: 138d19b1     	ror	w17, w13, #0x6
    1618: 0a2d0182     	bic	w2, w12, w13
    161c: 138a0941     	ror	w1, w10, #0x2
    1620: 0a0d01c3     	and	w3, w14, w13
    1624: 528c6a30     	mov	w16, #0x6351            // =25425
    1628: 4acd2e31     	eor	w17, w17, w13, ror #11
    162c: 2a020062     	orr	w2, w3, w2
    1630: 72a0d950     	movk	w16, #0x6ca, lsl #16
    1634: 4aca3421     	eor	w1, w1, w10, ror #13
    1638: 0a080123     	and	w3, w9, w8
    163c: 0a120152     	and	w18, w10, w18
    1640: 0b0201ef     	add	w15, w15, w2
    1644: 4acd6631     	eor	w17, w17, w13, ror #25
    1648: 2a030252     	orr	w18, w18, w3
    164c: 4aca5821     	eor	w1, w1, w10, ror #22
    1650: 0b1001ef     	add	w15, w15, w16
    1654: 52852cf0     	mov	w16, #0x2967            // =10599
    1658: 0b1101f1     	add	w17, w15, w17
    165c: 72a28530     	movk	w16, #0x1429, lsl #16
    1660: 0b120032     	add	w18, w1, w18
    1664: 0b0b022f     	add	w15, w17, w11
    1668: 0b11024b     	add	w11, w18, w17
    166c: 138f19e1     	ror	w1, w15, #0x6
    1670: 0a0f01a3     	and	w3, w13, w15
    1674: 294fcbf1     	ldp	w17, w18, [sp, #0x7c]
    1678: 138b0962     	ror	w2, w11, #0x2
    167c: 4acf2c21     	eor	w1, w1, w15, ror #11
    1680: 0b0c022c     	add	w12, w17, w12
    1684: 0a2f01d1     	bic	w17, w14, w15
    1688: 4acb3442     	eor	w2, w2, w11, ror #13
    168c: 2a110071     	orr	w17, w3, w17
    1690: 2a090143     	orr	w3, w10, w9
    1694: 4acf6421     	eor	w1, w1, w15, ror #25
    1698: 0b11018c     	add	w12, w12, w17
    169c: 0a090151     	and	w17, w10, w9
    16a0: 0a030163     	and	w3, w11, w3
    16a4: 4acb5842     	eor	w2, w2, w11, ror #22
    16a8: 2a110071     	orr	w17, w3, w17
    16ac: 0b10018c     	add	w12, w12, w16
    16b0: 0b010190     	add	w16, w12, w1
    16b4: 0b0e024e     	add	w14, w18, w14
    16b8: 2a0a0172     	orr	w18, w11, w10
    16bc: 0b110051     	add	w17, w2, w17
    16c0: 0b08020c     	add	w12, w16, w8
    16c4: 0b100228     	add	w8, w17, w16
    16c8: 138c1991     	ror	w17, w12, #0x6
    16cc: 0a2c01a2     	bic	w2, w13, w12
    16d0: 13880901     	ror	w1, w8, #0x2
    16d4: 0a0c01e3     	and	w3, w15, w12
    16d8: 528150b0     	mov	w16, #0xa85             // =2693
    16dc: 4acc2e31     	eor	w17, w17, w12, ror #11
    16e0: 2a020062     	orr	w2, w3, w2
    16e4: 72a4f6f0     	movk	w16, #0x27b7, lsl #16
    16e8: 4ac83421     	eor	w1, w1, w8, ror #13
    16ec: 0a0a0163     	and	w3, w11, w10
    16f0: 0a120112     	and	w18, w8, w18
    16f4: 0b0201ce     	add	w14, w14, w2
    16f8: 4acc6631     	eor	w17, w17, w12, ror #25
    16fc: 2a030252     	orr	w18, w18, w3
    1700: 4ac85821     	eor	w1, w1, w8, ror #22
    1704: 0b1001ce     	add	w14, w14, w16
    1708: 52842710     	mov	w16, #0x2138            // =8504
    170c: 0b1101d1     	add	w17, w14, w17
    1710: 72a5c370     	movk	w16, #0x2e1b, lsl #16
    1714: 0b120032     	add	w18, w1, w18
    1718: 0b09022e     	add	w14, w17, w9
    171c: 0b110249     	add	w9, w18, w17
    1720: 138e19c1     	ror	w1, w14, #0x6
    1724: 0a0e0183     	and	w3, w12, w14
    1728: 2950cbf1     	ldp	w17, w18, [sp, #0x84]
    172c: 13890922     	ror	w2, w9, #0x2
    1730: 4ace2c21     	eor	w1, w1, w14, ror #11
    1734: 0b0d022d     	add	w13, w17, w13
    1738: 0a2e01f1     	bic	w17, w15, w14
    173c: 4ac93442     	eor	w2, w2, w9, ror #13
    1740: 2a110071     	orr	w17, w3, w17
    1744: 2a0b0103     	orr	w3, w8, w11
    1748: 4ace6421     	eor	w1, w1, w14, ror #25
    174c: 0b1101ad     	add	w13, w13, w17
    1750: 0a0b0111     	and	w17, w8, w11
    1754: 0a030123     	and	w3, w9, w3
    1758: 4ac95842     	eor	w2, w2, w9, ror #22
    175c: 2a110071     	orr	w17, w3, w17
    1760: 0b1001ad     	add	w13, w13, w16
    1764: 0b0101b0     	add	w16, w13, w1
    1768: 0b0f024f     	add	w15, w18, w15
    176c: 2a080132     	orr	w18, w9, w8
    1770: 0b110051     	add	w17, w2, w17
    1774: 0b0a020d     	add	w13, w16, w10
    1778: 0b10022a     	add	w10, w17, w16
    177c: 138d19b1     	ror	w17, w13, #0x6
    1780: 0a2d0182     	bic	w2, w12, w13
    1784: 138a0941     	ror	w1, w10, #0x2
    1788: 0a0d01c3     	and	w3, w14, w13
    178c: 528dbf90     	mov	w16, #0x6dfc            // =28156
    1790: 4acd2e31     	eor	w17, w17, w13, ror #11
    1794: 2a020062     	orr	w2, w3, w2
    1798: 72a9a590     	movk	w16, #0x4d2c, lsl #16
    179c: 4aca3421     	eor	w1, w1, w10, ror #13
    17a0: 0a080123     	and	w3, w9, w8
    17a4: 0a120152     	and	w18, w10, w18
    17a8: 0b0201ef     	add	w15, w15, w2
    17ac: 4acd6631     	eor	w17, w17, w13, ror #25
    17b0: 2a030252     	orr	w18, w18, w3
    17b4: 4aca5821     	eor	w1, w1, w10, ror #22
    17b8: 0b1001ef     	add	w15, w15, w16
    17bc: 5281a270     	mov	w16, #0xd13             // =3347
    17c0: 0b1101f1     	add	w17, w15, w17
    17c4: 72aa6710     	movk	w16, #0x5338, lsl #16
    17c8: 0b120032     	add	w18, w1, w18
    17cc: 0b0b022f     	add	w15, w17, w11
    17d0: 0b11024b     	add	w11, w18, w17
    17d4: 138f19e1     	ror	w1, w15, #0x6
    17d8: 0a0f01a3     	and	w3, w13, w15
    17dc: 2951cbf1     	ldp	w17, w18, [sp, #0x8c]
    17e0: 138b0962     	ror	w2, w11, #0x2
    17e4: 4acf2c21     	eor	w1, w1, w15, ror #11
    17e8: 0b0c022c     	add	w12, w17, w12
    17ec: 0a2f01d1     	bic	w17, w14, w15
    17f0: 4acb3442     	eor	w2, w2, w11, ror #13
    17f4: 2a110071     	orr	w17, w3, w17
    17f8: 2a090143     	orr	w3, w10, w9
    17fc: 4acf6421     	eor	w1, w1, w15, ror #25
    1800: 0b11018c     	add	w12, w12, w17
    1804: 0a090151     	and	w17, w10, w9
    1808: 0a030163     	and	w3, w11, w3
    180c: 4acb5842     	eor	w2, w2, w11, ror #22
    1810: 2a110071     	orr	w17, w3, w17
    1814: 0b10018c     	add	w12, w12, w16
    1818: 0b010190     	add	w16, w12, w1
    181c: 0b0e024e     	add	w14, w18, w14
    1820: 2a0a0172     	orr	w18, w11, w10
    1824: 0b110051     	add	w17, w2, w17
    1828: 0b08020c     	add	w12, w16, w8
    182c: 0b100228     	add	w8, w17, w16
    1830: 138c1991     	ror	w17, w12, #0x6
    1834: 0a2c01a2     	bic	w2, w13, w12
    1838: 13880901     	ror	w1, w8, #0x2
    183c: 0a0c01e3     	and	w3, w15, w12
    1840: 528e6a90     	mov	w16, #0x7354            // =29524
    1844: 4acc2e31     	eor	w17, w17, w12, ror #11
    1848: 2a020062     	orr	w2, w3, w2
    184c: 72aca150     	movk	w16, #0x650a, lsl #16
    1850: 4ac83421     	eor	w1, w1, w8, ror #13
    1854: 0a0a0163     	and	w3, w11, w10
    1858: 0a120112     	and	w18, w8, w18
    185c: 0b0201ce     	add	w14, w14, w2
    1860: 4acc6631     	eor	w17, w17, w12, ror #25
    1864: 2a030252     	orr	w18, w18, w3
    1868: 4ac85821     	eor	w1, w1, w8, ror #22
    186c: 0b1001ce     	add	w14, w14, w16
    1870: 52815770     	mov	w16, #0xabb             // =2747
    1874: 0b1101d1     	add	w17, w14, w17
    1878: 72aecd50     	movk	w16, #0x766a, lsl #16
    187c: 0b120032     	add	w18, w1, w18
    1880: 0b09022e     	add	w14, w17, w9
    1884: 0b110249     	add	w9, w18, w17
    1888: 138e19c1     	ror	w1, w14, #0x6
    188c: 0a0e0183     	and	w3, w12, w14
    1890: 2952cbf1     	ldp	w17, w18, [sp, #0x94]
    1894: 13890922     	ror	w2, w9, #0x2
    1898: 4ace2c21     	eor	w1, w1, w14, ror #11
    189c: 0b0d022d     	add	w13, w17, w13
    18a0: 0a2e01f1     	bic	w17, w15, w14
    18a4: 4ac93442     	eor	w2, w2, w9, ror #13
    18a8: 2a110071     	orr	w17, w3, w17
    18ac: 2a0b0103     	orr	w3, w8, w11
    18b0: 4ace6421     	eor	w1, w1, w14, ror #25
    18b4: 0b1101ad     	add	w13, w13, w17
    18b8: 0a0b0111     	and	w17, w8, w11
    18bc: 0a030123     	and	w3, w9, w3
    18c0: 4ac95842     	eor	w2, w2, w9, ror #22
    18c4: 2a110071     	orr	w17, w3, w17
    18c8: 0b1001ad     	add	w13, w13, w16
    18cc: 0b0101b0     	add	w16, w13, w1
    18d0: 0b0f024f     	add	w15, w18, w15
    18d4: 2a080132     	orr	w18, w9, w8
    18d8: 0b110051     	add	w17, w2, w17
    18dc: 0b0a020d     	add	w13, w16, w10
    18e0: 0b10022a     	add	w10, w17, w16
    18e4: 138d19b1     	ror	w17, w13, #0x6
    18e8: 0a2d0182     	bic	w2, w12, w13
    18ec: 138a0941     	ror	w1, w10, #0x2
    18f0: 0a0d01c3     	and	w3, w14, w13
    18f4: 529925d0     	mov	w16, #0xc92e            // =51502
    18f8: 4acd2e31     	eor	w17, w17, w13, ror #11
    18fc: 2a020062     	orr	w2, w3, w2
    1900: 72b03850     	movk	w16, #0x81c2, lsl #16
    1904: 4aca3421     	eor	w1, w1, w10, ror #13
    1908: 0a080123     	and	w3, w9, w8
    190c: 0a120152     	and	w18, w10, w18
    1910: 0b0201ef     	add	w15, w15, w2
    1914: 4acd6631     	eor	w17, w17, w13, ror #25
    1918: 2a030252     	orr	w18, w18, w3
    191c: 4aca5821     	eor	w1, w1, w10, ror #22
    1920: 0b1001ef     	add	w15, w15, w16
    1924: 528590b0     	mov	w16, #0x2c85            // =11397
    1928: 0b1101f1     	add	w17, w15, w17
    192c: 72b24e50     	movk	w16, #0x9272, lsl #16
    1930: 0b120032     	add	w18, w1, w18
    1934: 0b0b022f     	add	w15, w17, w11
    1938: 0b11024b     	add	w11, w18, w17
    193c: 138f19e1     	ror	w1, w15, #0x6
    1940: 0a0f01a3     	and	w3, w13, w15
    1944: 2953cbf1     	ldp	w17, w18, [sp, #0x9c]
    1948: 138b0962     	ror	w2, w11, #0x2
    194c: 4acf2c21     	eor	w1, w1, w15, ror #11
    1950: 0b0c022c     	add	w12, w17, w12
    1954: 0a2f01d1     	bic	w17, w14, w15
    1958: 4acb3442     	eor	w2, w2, w11, ror #13
    195c: 2a110071     	orr	w17, w3, w17
    1960: 2a090143     	orr	w3, w10, w9
    1964: 4acf6421     	eor	w1, w1, w15, ror #25
    1968: 0b11018c     	add	w12, w12, w17
    196c: 0a090151     	and	w17, w10, w9
    1970: 0a030163     	and	w3, w11, w3
    1974: 4acb5842     	eor	w2, w2, w11, ror #22
    1978: 2a110071     	orr	w17, w3, w17
    197c: 0b10018c     	add	w12, w12, w16
    1980: 0b010190     	add	w16, w12, w1
    1984: 0b0e024e     	add	w14, w18, w14
    1988: 2a0a0172     	orr	w18, w11, w10
    198c: 0b110051     	add	w17, w2, w17
    1990: 0b08020c     	add	w12, w16, w8
    1994: 0b100228     	add	w8, w17, w16
    1998: 138c1991     	ror	w17, w12, #0x6
    199c: 0a2c01a2     	bic	w2, w13, w12
    19a0: 13880901     	ror	w1, w8, #0x2
    19a4: 0a0c01e3     	and	w3, w15, w12
    19a8: 529d1430     	mov	w16, #0xe8a1            // =59553
    19ac: 4acc2e31     	eor	w17, w17, w12, ror #11
    19b0: 2a020062     	orr	w2, w3, w2
    19b4: 72b457f0     	movk	w16, #0xa2bf, lsl #16
    19b8: 4ac83421     	eor	w1, w1, w8, ror #13
    19bc: 0a0a0163     	and	w3, w11, w10
    19c0: 0a120112     	and	w18, w8, w18
    19c4: 0b0201ce     	add	w14, w14, w2
    19c8: 4acc6631     	eor	w17, w17, w12, ror #25
    19cc: 2a030252     	orr	w18, w18, w3
    19d0: 4ac85821     	eor	w1, w1, w8, ror #22
    19d4: 0b1001ce     	add	w14, w14, w16
    19d8: 528cc970     	mov	w16, #0x664b            // =26187
    19dc: 0b1101d1     	add	w17, w14, w17
    19e0: 72b50350     	movk	w16, #0xa81a, lsl #16
    19e4: 0b120032     	add	w18, w1, w18
    19e8: 0b09022e     	add	w14, w17, w9
    19ec: 0b110249     	add	w9, w18, w17
    19f0: 138e19c1     	ror	w1, w14, #0x6
    19f4: 0a0e0183     	and	w3, w12, w14
    19f8: 2954cbf1     	ldp	w17, w18, [sp, #0xa4]
    19fc: 13890922     	ror	w2, w9, #0x2
    1a00: 4ace2c21     	eor	w1, w1, w14, ror #11
    1a04: 0b0d022d     	add	w13, w17, w13
    1a08: 0a2e01f1     	bic	w17, w15, w14
    1a0c: 4ac93442     	eor	w2, w2, w9, ror #13
    1a10: 2a110071     	orr	w17, w3, w17
    1a14: 2a0b0103     	orr	w3, w8, w11
    1a18: 4ace6421     	eor	w1, w1, w14, ror #25
    1a1c: 0b1101ad     	add	w13, w13, w17
    1a20: 0a0b0111     	and	w17, w8, w11
    1a24: 0a030123     	and	w3, w9, w3
    1a28: 4ac95842     	eor	w2, w2, w9, ror #22
    1a2c: 2a110071     	orr	w17, w3, w17
    1a30: 0b1001ad     	add	w13, w13, w16
    1a34: 0b0101b0     	add	w16, w13, w1
    1a38: 0b0f024f     	add	w15, w18, w15
    1a3c: 2a080132     	orr	w18, w9, w8
    1a40: 0b110051     	add	w17, w2, w17
    1a44: 0b0a020d     	add	w13, w16, w10
    1a48: 0b10022a     	add	w10, w17, w16
    1a4c: 138d19b1     	ror	w17, w13, #0x6
    1a50: 0a2d0182     	bic	w2, w12, w13
    1a54: 138a0941     	ror	w1, w10, #0x2
    1a58: 0a0d01c3     	and	w3, w14, w13
    1a5c: 52916e10     	mov	w16, #0x8b70            // =35696
    1a60: 4acd2e31     	eor	w17, w17, w13, ror #11
    1a64: 2a020062     	orr	w2, w3, w2
    1a68: 72b84970     	movk	w16, #0xc24b, lsl #16
    1a6c: 4aca3421     	eor	w1, w1, w10, ror #13
    1a70: 0a080123     	and	w3, w9, w8
    1a74: 0a120152     	and	w18, w10, w18
    1a78: 0b0201ef     	add	w15, w15, w2
    1a7c: 4acd6631     	eor	w17, w17, w13, ror #25
    1a80: 2a030252     	orr	w18, w18, w3
    1a84: 4aca5821     	eor	w1, w1, w10, ror #22
    1a88: 0b1001ef     	add	w15, w15, w16
    1a8c: 528a3470     	mov	w16, #0x51a3            // =20899
    1a90: 0b1101f1     	add	w17, w15, w17
    1a94: 72b8ed90     	movk	w16, #0xc76c, lsl #16
    1a98: 0b120032     	add	w18, w1, w18
    1a9c: 0b0b022f     	add	w15, w17, w11
    1aa0: 0b11024b     	add	w11, w18, w17
    1aa4: 138f19e1     	ror	w1, w15, #0x6
    1aa8: 0a0f01a3     	and	w3, w13, w15
    1aac: 2955cbf1     	ldp	w17, w18, [sp, #0xac]
    1ab0: 138b0962     	ror	w2, w11, #0x2
    1ab4: 4acf2c21     	eor	w1, w1, w15, ror #11
    1ab8: 0b0c022c     	add	w12, w17, w12
    1abc: 0a2f01d1     	bic	w17, w14, w15
    1ac0: 4acb3442     	eor	w2, w2, w11, ror #13
    1ac4: 2a110071     	orr	w17, w3, w17
    1ac8: 2a090143     	orr	w3, w10, w9
    1acc: 4acf6421     	eor	w1, w1, w15, ror #25
    1ad0: 0b11018c     	add	w12, w12, w17
    1ad4: 0a090151     	and	w17, w10, w9
    1ad8: 0a030163     	and	w3, w11, w3
    1adc: 4acb5842     	eor	w2, w2, w11, ror #22
    1ae0: 2a110071     	orr	w17, w3, w17
    1ae4: 0b10018c     	add	w12, w12, w16
    1ae8: 0b010190     	add	w16, w12, w1
    1aec: 0b0e024e     	add	w14, w18, w14
    1af0: 2a0a0172     	orr	w18, w11, w10
    1af4: 0b110051     	add	w17, w2, w17
    1af8: 0b08020c     	add	w12, w16, w8
    1afc: 0b100228     	add	w8, w17, w16
    1b00: 138c1991     	ror	w17, w12, #0x6
    1b04: 0a2c01a2     	bic	w2, w13, w12
    1b08: 13880901     	ror	w1, w8, #0x2
    1b0c: 0a0c01e3     	and	w3, w15, w12
    1b10: 529d0330     	mov	w16, #0xe819            // =59417
    1b14: 4acc2e31     	eor	w17, w17, w12, ror #11
    1b18: 2a020062     	orr	w2, w3, w2
    1b1c: 72ba3250     	movk	w16, #0xd192, lsl #16
    1b20: 4ac83421     	eor	w1, w1, w8, ror #13
    1b24: 0a0a0163     	and	w3, w11, w10
    1b28: 0a120112     	and	w18, w8, w18
    1b2c: 0b0201ce     	add	w14, w14, w2
    1b30: 4acc6631     	eor	w17, w17, w12, ror #25
    1b34: 2a030252     	orr	w18, w18, w3
    1b38: 4ac85821     	eor	w1, w1, w8, ror #22
    1b3c: 0b1001ce     	add	w14, w14, w16
    1b40: 5280c490     	mov	w16, #0x624             // =1572
    1b44: 0b1101d1     	add	w17, w14, w17
    1b48: 72bad330     	movk	w16, #0xd699, lsl #16
    1b4c: 0b120032     	add	w18, w1, w18
    1b50: 0b09022e     	add	w14, w17, w9
    1b54: 0b110249     	add	w9, w18, w17
    1b58: 138e19c1     	ror	w1, w14, #0x6
    1b5c: 0a0e0183     	and	w3, w12, w14
    1b60: 2956cbf1     	ldp	w17, w18, [sp, #0xb4]
    1b64: 13890922     	ror	w2, w9, #0x2
    1b68: 4ace2c21     	eor	w1, w1, w14, ror #11
    1b6c: 0b0d022d     	add	w13, w17, w13
    1b70: 0a2e01f1     	bic	w17, w15, w14
    1b74: 4ac93442     	eor	w2, w2, w9, ror #13
    1b78: 2a110071     	orr	w17, w3, w17
    1b7c: 2a0b0103     	orr	w3, w8, w11
    1b80: 4ace6421     	eor	w1, w1, w14, ror #25
    1b84: 0b1101ad     	add	w13, w13, w17
    1b88: 0a0b0111     	and	w17, w8, w11
    1b8c: 0a030123     	and	w3, w9, w3
    1b90: 4ac95842     	eor	w2, w2, w9, ror #22
    1b94: 2a110071     	orr	w17, w3, w17
    1b98: 0b1001ad     	add	w13, w13, w16
    1b9c: 0b0101b0     	add	w16, w13, w1
    1ba0: 0b0f024f     	add	w15, w18, w15
    1ba4: 2a080132     	orr	w18, w9, w8
    1ba8: 0b110051     	add	w17, w2, w17
    1bac: 0b0a020d     	add	w13, w16, w10
    1bb0: 0b10022a     	add	w10, w17, w16
    1bb4: 138d19b1     	ror	w17, w13, #0x6
    1bb8: 0a2d0182     	bic	w2, w12, w13
    1bbc: 138a0941     	ror	w1, w10, #0x2
    1bc0: 0a0d01c3     	and	w3, w14, w13
    1bc4: 5286b0b0     	mov	w16, #0x3585            // =13701
    1bc8: 4acd2e31     	eor	w17, w17, w13, ror #11
    1bcc: 2a020062     	orr	w2, w3, w2
    1bd0: 72be81d0     	movk	w16, #0xf40e, lsl #16
    1bd4: 4aca3421     	eor	w1, w1, w10, ror #13
    1bd8: 0a080123     	and	w3, w9, w8
    1bdc: 0a120152     	and	w18, w10, w18
    1be0: 0b0201ef     	add	w15, w15, w2
    1be4: 4acd6631     	eor	w17, w17, w13, ror #25
    1be8: 2a030252     	orr	w18, w18, w3
    1bec: 4aca5821     	eor	w1, w1, w10, ror #22
    1bf0: 0b1001ef     	add	w15, w15, w16
    1bf4: 52940e10     	mov	w16, #0xa070            // =41072
    1bf8: 0b1101f1     	add	w17, w15, w17
    1bfc: 72a20d50     	movk	w16, #0x106a, lsl #16
    1c00: 0b120032     	add	w18, w1, w18
    1c04: 0b0b022f     	add	w15, w17, w11
    1c08: 0b11024b     	add	w11, w18, w17
    1c0c: 138f19e1     	ror	w1, w15, #0x6
    1c10: 0a0f01a3     	and	w3, w13, w15
    1c14: 2957cbf1     	ldp	w17, w18, [sp, #0xbc]
    1c18: 138b0962     	ror	w2, w11, #0x2
    1c1c: 4acf2c21     	eor	w1, w1, w15, ror #11
    1c20: 0b0c022c     	add	w12, w17, w12
    1c24: 0a2f01d1     	bic	w17, w14, w15
    1c28: 4acb3442     	eor	w2, w2, w11, ror #13
    1c2c: 2a110071     	orr	w17, w3, w17
    1c30: 2a090143     	orr	w3, w10, w9
    1c34: 4acf6421     	eor	w1, w1, w15, ror #25
    1c38: 0b11018c     	add	w12, w12, w17
    1c3c: 0a090151     	and	w17, w10, w9
    1c40: 0a030163     	and	w3, w11, w3
    1c44: 4acb5842     	eor	w2, w2, w11, ror #22
    1c48: 2a110071     	orr	w17, w3, w17
    1c4c: 0b10018c     	add	w12, w12, w16
    1c50: 0b010190     	add	w16, w12, w1
    1c54: 0b0e024e     	add	w14, w18, w14
    1c58: 2a0a0172     	orr	w18, w11, w10
    1c5c: 0b110051     	add	w17, w2, w17
    1c60: 0b08020c     	add	w12, w16, w8
    1c64: 0b100228     	add	w8, w17, w16
    1c68: 138c1991     	ror	w17, w12, #0x6
    1c6c: 0a2c01a2     	bic	w2, w13, w12
    1c70: 13880901     	ror	w1, w8, #0x2
    1c74: 0a0c01e3     	and	w3, w15, w12
    1c78: 529822d0     	mov	w16, #0xc116            // =49430
    1c7c: 4acc2e31     	eor	w17, w17, w12, ror #11
    1c80: 2a020062     	orr	w2, w3, w2
    1c84: 72a33490     	movk	w16, #0x19a4, lsl #16
    1c88: 4ac83421     	eor	w1, w1, w8, ror #13
    1c8c: 0a0a0163     	and	w3, w11, w10
    1c90: 0a120112     	and	w18, w8, w18
    1c94: 0b0201ce     	add	w14, w14, w2
    1c98: 4acc6631     	eor	w17, w17, w12, ror #25
    1c9c: 2a030252     	orr	w18, w18, w3
    1ca0: 4ac85821     	eor	w1, w1, w8, ror #22
    1ca4: 0b1001ce     	add	w14, w14, w16
    1ca8: 528d8110     	mov	w16, #0x6c08            // =27656
    1cac: 0b1101d1     	add	w17, w14, w17
    1cb0: 72a3c6f0     	movk	w16, #0x1e37, lsl #16
    1cb4: 0b120032     	add	w18, w1, w18
    1cb8: 0b09022e     	add	w14, w17, w9
    1cbc: 0b110249     	add	w9, w18, w17
    1cc0: 138e19c1     	ror	w1, w14, #0x6
    1cc4: 0a0e0183     	and	w3, w12, w14
    1cc8: 2958cbf1     	ldp	w17, w18, [sp, #0xc4]
    1ccc: 13890922     	ror	w2, w9, #0x2
    1cd0: 4ace2c21     	eor	w1, w1, w14, ror #11
    1cd4: 0b0d022d     	add	w13, w17, w13
    1cd8: 0a2e01f1     	bic	w17, w15, w14
    1cdc: 4ac93442     	eor	w2, w2, w9, ror #13
    1ce0: 2a110071     	orr	w17, w3, w17
    1ce4: 2a0b0103     	orr	w3, w8, w11
    1ce8: 4ace6421     	eor	w1, w1, w14, ror #25
    1cec: 0b1101ad     	add	w13, w13, w17
    1cf0: 0a0b0111     	and	w17, w8, w11
    1cf4: 0a030123     	and	w3, w9, w3
    1cf8: 4ac95842     	eor	w2, w2, w9, ror #22
    1cfc: 2a110071     	orr	w17, w3, w17
    1d00: 0b1001ad     	add	w13, w13, w16
    1d04: 0b0101b0     	add	w16, w13, w1
    1d08: 0b0f024f     	add	w15, w18, w15
    1d0c: 2a080132     	orr	w18, w9, w8
    1d10: 0b110051     	add	w17, w2, w17
    1d14: 0b0a020d     	add	w13, w16, w10
    1d18: 0b10022a     	add	w10, w17, w16
    1d1c: 138d19b1     	ror	w17, w13, #0x6
    1d20: 0a2d0182     	bic	w2, w12, w13
    1d24: 138a0941     	ror	w1, w10, #0x2
    1d28: 0a0d01c3     	and	w3, w14, w13
    1d2c: 528ee990     	mov	w16, #0x774c            // =30540
    1d30: 4acd2e31     	eor	w17, w17, w13, ror #11
    1d34: 2a020062     	orr	w2, w3, w2
    1d38: 72a4e910     	movk	w16, #0x2748, lsl #16
    1d3c: 4aca3421     	eor	w1, w1, w10, ror #13
    1d40: 0a080123     	and	w3, w9, w8
    1d44: 0a120152     	and	w18, w10, w18
    1d48: 0b0201ef     	add	w15, w15, w2
    1d4c: 4acd6631     	eor	w17, w17, w13, ror #25
    1d50: 2a030252     	orr	w18, w18, w3
    1d54: 4aca5821     	eor	w1, w1, w10, ror #22
    1d58: 0b1001ef     	add	w15, w15, w16
    1d5c: 529796b0     	mov	w16, #0xbcb5            // =48309
    1d60: 0b1101f1     	add	w17, w15, w17
    1d64: 72a69610     	movk	w16, #0x34b0, lsl #16
    1d68: 0b120032     	add	w18, w1, w18
    1d6c: 0b0b022f     	add	w15, w17, w11
    1d70: 0b11024b     	add	w11, w18, w17
    1d74: 138f19e1     	ror	w1, w15, #0x6
    1d78: 0a0f01a3     	and	w3, w13, w15
    1d7c: 2959cbf1     	ldp	w17, w18, [sp, #0xcc]
    1d80: 138b0962     	ror	w2, w11, #0x2
    1d84: 4acf2c21     	eor	w1, w1, w15, ror #11
    1d88: 0b0c022c     	add	w12, w17, w12
    1d8c: 0a2f01d1     	bic	w17, w14, w15
    1d90: 4acb3442     	eor	w2, w2, w11, ror #13
    1d94: 2a110071     	orr	w17, w3, w17
    1d98: 2a090143     	orr	w3, w10, w9
    1d9c: 4acf6421     	eor	w1, w1, w15, ror #25
    1da0: 0b11018c     	add	w12, w12, w17
    1da4: 0a090151     	and	w17, w10, w9
    1da8: 0a030163     	and	w3, w11, w3
    1dac: 4acb5842     	eor	w2, w2, w11, ror #22
    1db0: 2a110071     	orr	w17, w3, w17
    1db4: 0b10018c     	add	w12, w12, w16
    1db8: 0b010190     	add	w16, w12, w1
    1dbc: 0b0e024e     	add	w14, w18, w14
    1dc0: 2a0a0172     	orr	w18, w11, w10
    1dc4: 0b110051     	add	w17, w2, w17
    1dc8: 0b08020c     	add	w12, w16, w8
    1dcc: 0b100228     	add	w8, w17, w16
    1dd0: 138c1991     	ror	w17, w12, #0x6
    1dd4: 0a2c01a2     	bic	w2, w13, w12
    1dd8: 13880901     	ror	w1, w8, #0x2
    1ddc: 0a0c01e3     	and	w3, w15, w12
    1de0: 52819670     	mov	w16, #0xcb3             // =3251
    1de4: 4acc2e31     	eor	w17, w17, w12, ror #11
    1de8: 2a020062     	orr	w2, w3, w2
    1dec: 72a72390     	movk	w16, #0x391c, lsl #16
    1df0: 4ac83421     	eor	w1, w1, w8, ror #13
    1df4: 0a0a0163     	and	w3, w11, w10
    1df8: 0a120112     	and	w18, w8, w18
    1dfc: 0b0201ce     	add	w14, w14, w2
    1e00: 4acc6631     	eor	w17, w17, w12, ror #25
    1e04: 2a030252     	orr	w18, w18, w3
    1e08: 4ac85821     	eor	w1, w1, w8, ror #22
    1e0c: 0b1001ce     	add	w14, w14, w16
    1e10: 52954942     	mov	w2, #0xaa4a             // =43594
    1e14: 0b1101ce     	add	w14, w14, w17
    1e18: 72a9db02     	movk	w2, #0x4ed8, lsl #16
    1e1c: 0b120031     	add	w17, w1, w18
    1e20: 0b0901d0     	add	w16, w14, w9
    1e24: 0b0e0229     	add	w9, w17, w14
    1e28: 13901a12     	ror	w18, w16, #0x6
    1e2c: 0a100183     	and	w3, w12, w16
    1e30: 295ac7ee     	ldp	w14, w17, [sp, #0xd4]
    1e34: 13890921     	ror	w1, w9, #0x2
    1e38: 4ad02e52     	eor	w18, w18, w16, ror #11
    1e3c: 0b0d01cd     	add	w13, w14, w13
    1e40: 0a3001ee     	bic	w14, w15, w16
    1e44: 4ac93421     	eor	w1, w1, w9, ror #13
    1e48: 2a0e006e     	orr	w14, w3, w14
    1e4c: 2a0b0103     	orr	w3, w8, w11
    1e50: 4ad06652     	eor	w18, w18, w16, ror #25
    1e54: 0b0e01ad     	add	w13, w13, w14
    1e58: 0a0b010e     	and	w14, w8, w11
    1e5c: 0a030123     	and	w3, w9, w3
    1e60: 4ac95821     	eor	w1, w1, w9, ror #22
    1e64: 2a0e006e     	orr	w14, w3, w14
    1e68: 0b0201ad     	add	w13, w13, w2
    1e6c: 0b1201b2     	add	w18, w13, w18
    1e70: 0b0f022f     	add	w15, w17, w15
    1e74: 2a080131     	orr	w17, w9, w8
    1e78: 0b0e002e     	add	w14, w1, w14
    1e7c: 0b0a024d     	add	w13, w18, w10
    1e80: 0b1201ca     	add	w10, w14, w18
    1e84: 138d19b2     	ror	w18, w13, #0x6
    1e88: 0a2d0182     	bic	w2, w12, w13
    1e8c: 138a0941     	ror	w1, w10, #0x2
    1e90: 0a0d0203     	and	w3, w16, w13
    1e94: 529949ee     	mov	w14, #0xca4f            // =51791
    1e98: 4acd2e52     	eor	w18, w18, w13, ror #11
    1e9c: 2a020062     	orr	w2, w3, w2
    1ea0: 72ab738e     	movk	w14, #0x5b9c, lsl #16
    1ea4: 4aca3421     	eor	w1, w1, w10, ror #13
    1ea8: 0a080123     	and	w3, w9, w8
    1eac: 0a110151     	and	w17, w10, w17
    1eb0: 0b0201ef     	add	w15, w15, w2
    1eb4: 4acd6652     	eor	w18, w18, w13, ror #25
    1eb8: 2a030231     	orr	w17, w17, w3
    1ebc: 4aca5821     	eor	w1, w1, w10, ror #22
    1ec0: 0b0e01ee     	add	w14, w15, w14
    1ec4: 528dfe62     	mov	w2, #0x6ff3             // =28659
    1ec8: 0b1201ce     	add	w14, w14, w18
    1ecc: 72ad05c2     	movk	w2, #0x682e, lsl #16
    1ed0: 0b110031     	add	w17, w1, w17
    1ed4: 0b0b01cf     	add	w15, w14, w11
    1ed8: 0b0e022b     	add	w11, w17, w14
    1edc: 138f19f2     	ror	w18, w15, #0x6
    1ee0: 0a0f01a3     	and	w3, w13, w15
    1ee4: 295bc7ee     	ldp	w14, w17, [sp, #0xdc]
    1ee8: 138b0961     	ror	w1, w11, #0x2
    1eec: 4acf2e52     	eor	w18, w18, w15, ror #11
    1ef0: 0b0c01cc     	add	w12, w14, w12
    1ef4: 0a2f020e     	bic	w14, w16, w15
    1ef8: 4acb3421     	eor	w1, w1, w11, ror #13
    1efc: 2a0e006e     	orr	w14, w3, w14
    1f00: 2a090143     	orr	w3, w10, w9
    1f04: 4acf6652     	eor	w18, w18, w15, ror #25
    1f08: 0b0e018c     	add	w12, w12, w14
    1f0c: 0a09014e     	and	w14, w10, w9
    1f10: 0a030163     	and	w3, w11, w3
    1f14: 4acb5821     	eor	w1, w1, w11, ror #22
    1f18: 2a0e006e     	orr	w14, w3, w14
    1f1c: 0b02018c     	add	w12, w12, w2
    1f20: 0b12018c     	add	w12, w12, w18
    1f24: 0b100230     	add	w16, w17, w16
    1f28: 2a0a0171     	orr	w17, w11, w10
    1f2c: 0b0e0032     	add	w18, w1, w14
    1f30: 0b08018e     	add	w14, w12, w8
    1f34: 52905dc8     	mov	w8, #0x82ee             // =33518
    1f38: 0b0c024c     	add	w12, w18, w12
    1f3c: 138e19d2     	ror	w18, w14, #0x6
    1f40: 0a2e01a2     	bic	w2, w13, w14
    1f44: 138c0981     	ror	w1, w12, #0x2
    1f48: 0a0e01e3     	and	w3, w15, w14
    1f4c: 72ae91e8     	movk	w8, #0x748f, lsl #16
    1f50: 4ace2e52     	eor	w18, w18, w14, ror #11
    1f54: 2a020062     	orr	w2, w3, w2
    1f58: 0a0a0163     	and	w3, w11, w10
    1f5c: 4acc3421     	eor	w1, w1, w12, ror #13
    1f60: 0a110191     	and	w17, w12, w17
    1f64: 0b020210     	add	w16, w16, w2
    1f68: 4ace6652     	eor	w18, w18, w14, ror #25
    1f6c: 2a030231     	orr	w17, w17, w3
    1f70: 0b080208     	add	w8, w16, w8
    1f74: 4acc5821     	eor	w1, w1, w12, ror #22
    1f78: 528c6de2     	mov	w2, #0x636f             // =25455
    1f7c: 0b120108     	add	w8, w8, w18
    1f80: 72af14a2     	movk	w2, #0x78a5, lsl #16
    1f84: 0b110031     	add	w17, w1, w17
    1f88: 0b090110     	add	w16, w8, w9
    1f8c: 0b080229     	add	w9, w17, w8
    1f90: 13901a12     	ror	w18, w16, #0x6
    1f94: 0a1001c3     	and	w3, w14, w16
    1f98: 295cc7e8     	ldp	w8, w17, [sp, #0xe4]
    1f9c: 13890921     	ror	w1, w9, #0x2
    1fa0: 4ad02e52     	eor	w18, w18, w16, ror #11
    1fa4: 0b0d0108     	add	w8, w8, w13
    1fa8: 0a3001ed     	bic	w13, w15, w16
    1fac: 4ac93421     	eor	w1, w1, w9, ror #13
    1fb0: 2a0d006d     	orr	w13, w3, w13
    1fb4: 2a0b0183     	orr	w3, w12, w11
    1fb8: 4ad06652     	eor	w18, w18, w16, ror #25
    1fbc: 0b0d0108     	add	w8, w8, w13
    1fc0: 0a0b018d     	and	w13, w12, w11
    1fc4: 0a030123     	and	w3, w9, w3
    1fc8: 4ac95821     	eor	w1, w1, w9, ror #22
    1fcc: 2a0d006d     	orr	w13, w3, w13
    1fd0: 0b020108     	add	w8, w8, w2
    1fd4: 0b120108     	add	w8, w8, w18
    1fd8: 0b0f022f     	add	w15, w17, w15
    1fdc: 2a0c0131     	orr	w17, w9, w12
    1fe0: 0b0d0032     	add	w18, w1, w13
    1fe4: 0b0a010d     	add	w13, w8, w10
    1fe8: 528f028a     	mov	w10, #0x7814            // =30740
    1fec: 0b080248     	add	w8, w18, w8
    1ff0: 138d19b2     	ror	w18, w13, #0x6
    1ff4: 0a2d01c2     	bic	w2, w14, w13
    1ff8: 13880901     	ror	w1, w8, #0x2
    1ffc: 0a0d0203     	and	w3, w16, w13
    2000: 72b0990a     	movk	w10, #0x84c8, lsl #16
    2004: 4acd2e52     	eor	w18, w18, w13, ror #11
    2008: 2a020062     	orr	w2, w3, w2
    200c: 0a0c0123     	and	w3, w9, w12
    2010: 4ac83421     	eor	w1, w1, w8, ror #13
    2014: 0a110111     	and	w17, w8, w17
    2018: 0b0201ef     	add	w15, w15, w2
    201c: 4acd6652     	eor	w18, w18, w13, ror #25
    2020: 2a030231     	orr	w17, w17, w3
    2024: 0b0a01ea     	add	w10, w15, w10
    2028: 4ac85821     	eor	w1, w1, w8, ror #22
    202c: 52804102     	mov	w2, #0x208              // =520
    2030: 0b12014a     	add	w10, w10, w18
    2034: 72b198e2     	movk	w2, #0x8cc7, lsl #16
    2038: 0b110031     	add	w17, w1, w17
    203c: 0b0b014f     	add	w15, w10, w11
    2040: 0b0a022a     	add	w10, w17, w10
    2044: 138f19f2     	ror	w18, w15, #0x6
    2048: 0a0f01a3     	and	w3, w13, w15
    204c: 295dc7eb     	ldp	w11, w17, [sp, #0xec]
    2050: 138a0941     	ror	w1, w10, #0x2
    2054: 4acf2e52     	eor	w18, w18, w15, ror #11
    2058: 0b0e016b     	add	w11, w11, w14
    205c: 0a2f020e     	bic	w14, w16, w15
    2060: 4aca3421     	eor	w1, w1, w10, ror #13
    2064: 2a0e006e     	orr	w14, w3, w14
    2068: 2a090103     	orr	w3, w8, w9
    206c: 4acf6652     	eor	w18, w18, w15, ror #25
    2070: 0b0e016b     	add	w11, w11, w14
    2074: 0a09010e     	and	w14, w8, w9
    2078: 0a030143     	and	w3, w10, w3
    207c: 4aca5821     	eor	w1, w1, w10, ror #22
    2080: 2a0e006e     	orr	w14, w3, w14
    2084: 0b02016b     	add	w11, w11, w2
    2088: 0b12016b     	add	w11, w11, w18
    208c: 0b100230     	add	w16, w17, w16
    2090: 2a080151     	orr	w17, w10, w8
    2094: 0b0e002e     	add	w14, w1, w14
    2098: 0b0c016c     	add	w12, w11, w12
    209c: 0b0b01cb     	add	w11, w14, w11
    20a0: 138c1992     	ror	w18, w12, #0x6
    20a4: 0a2c01a2     	bic	w2, w13, w12
    20a8: 138b0961     	ror	w1, w11, #0x2
    20ac: 0a0c01e3     	and	w3, w15, w12
    20b0: 529fff4e     	mov	w14, #0xfffa            // =65530
    20b4: 4acc2e52     	eor	w18, w18, w12, ror #11
    20b8: 2a020062     	orr	w2, w3, w2
    20bc: 72b217ce     	movk	w14, #0x90be, lsl #16
    20c0: 4acb3421     	eor	w1, w1, w11, ror #13
    20c4: 0a080143     	and	w3, w10, w8
    20c8: 0a110171     	and	w17, w11, w17
    20cc: 0b020210     	add	w16, w16, w2
    20d0: 4acc6652     	eor	w18, w18, w12, ror #25
    20d4: 2a030231     	orr	w17, w17, w3
    20d8: 4acb5821     	eor	w1, w1, w11, ror #22
    20dc: 0b0e020e     	add	w14, w16, w14
    20e0: 0b1201ce     	add	w14, w14, w18
    20e4: 0b110031     	add	w17, w1, w17
    20e8: 0b0901c9     	add	w9, w14, w9
    20ec: 295ec3f2     	ldp	w18, w16, [sp, #0xf4]
    20f0: 0b0e022e     	add	w14, w17, w14
    20f4: 13891921     	ror	w1, w9, #0x6
    20f8: 0a090183     	and	w3, w12, w9
    20fc: 138e09c2     	ror	w2, w14, #0x2
    2100: 528d9d71     	mov	w17, #0x6ceb            // =27883
    2104: 0b0d024d     	add	w13, w18, w13
    2108: 0a2901f2     	bic	w18, w15, w9
    210c: 4ac92c21     	eor	w1, w1, w9, ror #11
    2110: 4ace3442     	eor	w2, w2, w14, ror #13
    2114: 2a120072     	orr	w18, w3, w18
    2118: 2a0a0163     	orr	w3, w11, w10
    211c: 72b48a11     	movk	w17, #0xa450, lsl #16
    2120: 0b1201ad     	add	w13, w13, w18
    2124: 0a0a0172     	and	w18, w11, w10
    2128: 0a0301c3     	and	w3, w14, w3
    212c: 4ac96421     	eor	w1, w1, w9, ror #25
    2130: 4ace5842     	eor	w2, w2, w14, ror #22
    2134: 2a120072     	orr	w18, w3, w18
    2138: 0b1101ad     	add	w13, w13, w17
    213c: 0b0f020f     	add	w15, w16, w15
    2140: 0b0101ad     	add	w13, w13, w1
    2144: 0b120051     	add	w17, w2, w18
    2148: 0b0801a8     	add	w8, w13, w8
    214c: 0b0d022d     	add	w13, w17, w13
    2150: 52947ef1     	mov	w17, #0xa3f7            // =41975
    2154: 13881912     	ror	w18, w8, #0x6
    2158: 138d09a1     	ror	w1, w13, #0x2
    215c: 0a280190     	bic	w16, w12, w8
    2160: 0a080122     	and	w2, w9, w8
    2164: 72b7df31     	movk	w17, #0xbef9, lsl #16
    2168: 4ac82e52     	eor	w18, w18, w8, ror #11
    216c: 4acd3421     	eor	w1, w1, w13, ror #13
    2170: 2a100050     	orr	w16, w2, w16
    2174: 2a0b01c2     	orr	w2, w14, w11
    2178: 0b1001ef     	add	w15, w15, w16
    217c: 0a0b01d0     	and	w16, w14, w11
    2180: 0a0201a2     	and	w2, w13, w2
    2184: 4ac86652     	eor	w18, w18, w8, ror #25
    2188: 4acd5821     	eor	w1, w1, w13, ror #22
    218c: 2a100050     	orr	w16, w2, w16
    2190: 0b1101ef     	add	w15, w15, w17
    2194: b940fff1     	ldr	w17, [sp, #0xfc]
    2198: 0b1201ef     	add	w15, w15, w18
    219c: 0b100030     	add	w16, w1, w16
    21a0: 0b0a01ea     	add	w10, w15, w10
    21a4: 0b0f020f     	add	w15, w16, w15
    21a8: 0b0c022c     	add	w12, w17, w12
    21ac: 138a1952     	ror	w18, w10, #0x6
    21b0: 138f09e1     	ror	w1, w15, #0x2
    21b4: 0a2a0131     	bic	w17, w9, w10
    21b8: 0a0a0102     	and	w2, w8, w10
    21bc: 528f1e50     	mov	w16, #0x78f2            // =30962
    21c0: 4aca2e52     	eor	w18, w18, w10, ror #11
    21c4: 4acf3421     	eor	w1, w1, w15, ror #13
    21c8: 2a110051     	orr	w17, w2, w17
    21cc: 2a0e01a2     	orr	w2, w13, w14
    21d0: 72b8ce30     	movk	w16, #0xc671, lsl #16
    21d4: 0b11018c     	add	w12, w12, w17
    21d8: 0a0e01b1     	and	w17, w13, w14
    21dc: 0a0201e2     	and	w2, w15, w2
    21e0: 4aca6652     	eor	w18, w18, w10, ror #25
    21e4: 4acf5821     	eor	w1, w1, w15, ror #22
    21e8: 2a110051     	orr	w17, w2, w17
    21ec: 0b10018c     	add	w12, w12, w16
    21f0: 0b12018c     	add	w12, w12, w18
    21f4: 0b110030     	add	w16, w1, w17
    21f8: 0b0b018b     	add	w11, w12, w11
    21fc: 0b0c0210     	add	w16, w16, w12
    2200: 1e270161     	fmov	s1, w11
    2204: 1e270200     	fmov	s0, w16
    2208: 4e0c1d41     	mov	v1.s[1], w10
    220c: 4e0c1de0     	mov	v0.s[1], w15
    2210: 4e141d01     	mov	v1.s[2], w8
    2214: 4e141da0     	mov	v0.s[2], w13
    2218: 4e1c1d21     	mov	v1.s[3], w9
    221c: 4e1c1dc0     	mov	v0.s[3], w14
    2220: 4ea18461     	add	v1.4s, v3.4s, v1.4s
    2224: 4ea08440     	add	v0.4s, v2.4s, v0.4s
    2228: ad000400     	stp	q0, q1, [x0]
    222c: 912403ff     	add	sp, sp, #0x900
    2230: a9434ff4     	ldp	x20, x19, [sp, #0x30]
    2234: f9400bf7     	ldr	x23, [sp, #0x10]
    2238: a94257f6     	ldp	x22, x21, [sp, #0x20]
    223c: a8c47bfd     	ldp	x29, x30, [sp], #0x40
    2240: d65f03c0     	ret

0000000000002244 <audit_master256>:
    2244: d105c3ff     	sub	sp, sp, #0x170
    2248: a9157bfd     	stp	x29, x30, [sp, #0x150]
    224c: a9164ffc     	stp	x28, x19, [sp, #0x160]
    2250: 910543fd     	add	x29, sp, #0x150
    2254: 52840008     	mov	w8, #0x2000             // =8192
    2258: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		0000000000002258:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32+0x20
    225c: 91000129     	add	x9, x9, #0x0
		000000000000225c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32+0x20
    2260: ad400520     	ldp	q0, q1, [x9]
    2264: 790083e8     	strh	w8, [sp, #0x40]
    2268: 528001a8     	mov	w8, #0xd                // =13
    226c: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		000000000000226c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
    2270: 91000129     	add	x9, x9, #0x0
		0000000000002270:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
    2274: f940012a     	ldr	x10, [x9]
    2278: 39010be8     	strb	w8, [sp, #0x42]
    227c: f8405128     	ldur	x8, [x9, #0x5]
    2280: aa0103f3     	mov	x19, x1
    2284: aa0003e4     	mov	x4, x0
    2288: 910083e0     	add	x0, sp, #0x20
    228c: f80433ea     	stur	x10, [sp, #0x43]
    2290: 910103e2     	add	x2, sp, #0x40
    2294: 52800401     	mov	w1, #0x20               // =32
    2298: f90027e8     	str	x8, [sp, #0x48]
    229c: 52800408     	mov	w8, #0x20               // =32
    22a0: 52800623     	mov	w3, #0x31               // =49
    22a4: 3c8513e0     	stur	q0, [sp, #0x51]
    22a8: 390143e8     	strb	w8, [sp, #0x50]
    22ac: 3c8613e1     	stur	q1, [sp, #0x61]
    22b0: 97fff7e6     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    22b4: 90000002     	adrp	x2, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		00000000000022b4:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst32
    22b8: 91000042     	add	x2, x2, #0x0
		00000000000022b8:  R_AARCH64_ADD_ABS_LO12_NC	.rodata.cst32
    22bc: 910003e0     	mov	x0, sp
    22c0: 910083e1     	add	x1, sp, #0x20
    22c4: 97fff778     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    22c8: ad4007e0     	ldp	q0, q1, [sp]
    22cc: ad000660     	stp	q0, q1, [x19]
    22d0: a9564ffc     	ldp	x28, x19, [sp, #0x160]
    22d4: a9557bfd     	ldp	x29, x30, [sp, #0x150]
    22d8: 9105c3ff     	add	sp, sp, #0x170
    22dc: d65f03c0     	ret

00000000000022e0 <audit_key256>:
    22e0: d104c3ff     	sub	sp, sp, #0x130
    22e4: a9117bfd     	stp	x29, x30, [sp, #0x110]
    22e8: f90093fc     	str	x28, [sp, #0x120]
    22ec: 910443fd     	add	x29, sp, #0x110
    22f0: 52800129     	mov	w9, #0x9                // =9
    22f4: 52820008     	mov	w8, #0x1000             // =4096
    22f8: aa0003e4     	mov	x4, x0
    22fc: 39001be9     	strb	w9, [sp, #0x6]
    2300: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		0000000000002300:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x1c0
    2304: 91000129     	add	x9, x9, #0x0
		0000000000002304:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x1c0
    2308: f9400129     	ldr	x9, [x9]
    230c: 79000be8     	strh	w8, [sp, #0x4]
    2310: 52800f28     	mov	w8, #0x79               // =121
    2314: 910013e2     	add	x2, sp, #0x4
    2318: aa0103e0     	mov	x0, x1
    231c: 52800201     	mov	w1, #0x10               // =16
    2320: 528001a3     	mov	w3, #0xd                // =13
    2324: 7800f3e8     	sturh	w8, [sp, #0xf]
    2328: f80073e9     	stur	x9, [sp, #0x7]
    232c: 97fff7c7     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    2330: a9517bfd     	ldp	x29, x30, [sp, #0x110]
    2334: f94093fc     	ldr	x28, [sp, #0x120]
    2338: 9104c3ff     	add	sp, sp, #0x130
    233c: d65f03c0     	ret

0000000000002340 <audit_handshake384>:
    2340: d10683ff     	sub	sp, sp, #0x1a0
    2344: a9177bfd     	stp	x29, x30, [sp, #0x170]
    2348: f900c3fc     	str	x28, [sp, #0x180]
    234c: a9194ff4     	stp	x20, x19, [sp, #0x190]
    2350: 9105c3fd     	add	x29, sp, #0x170
    2354: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		0000000000002354:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x70
    2358: 91000108     	add	x8, x8, #0x0
		0000000000002358:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x70
    235c: 52860009     	mov	w9, #0x3000             // =12288
    2360: ad400500     	ldp	q0, q1, [x8]
    2364: 7900c3e9     	strh	w9, [sp, #0x60]
    2368: 528001a9     	mov	w9, #0xd                // =13
    236c: 9000000a     	adrp	x10, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		000000000000236c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
    2370: 9100014a     	add	x10, x10, #0x0
		0000000000002370:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
    2374: f940014b     	ldr	x11, [x10]
    2378: 39018be9     	strb	w9, [sp, #0x62]
    237c: f8405149     	ldur	x9, [x10, #0x5]
    2380: 3c8713e0     	stur	q0, [sp, #0x71]
    2384: 3dc00900     	ldr	q0, [x8, #0x20]
    2388: aa0203f3     	mov	x19, x2
    238c: aa0103f4     	mov	x20, x1
    2390: aa0003e4     	mov	x4, x0
    2394: f80633eb     	stur	x11, [sp, #0x63]
    2398: 910183ea     	add	x10, sp, #0x60
    239c: f90037e9     	str	x9, [sp, #0x68]
    23a0: 52800609     	mov	w9, #0x30               // =48
    23a4: 9100c3e0     	add	x0, sp, #0x30
    23a8: 910183e2     	add	x2, sp, #0x60
    23ac: 52800601     	mov	w1, #0x30               // =48
    23b0: 52800823     	mov	w3, #0x41               // =65
    23b4: 3c821141     	stur	q1, [x10, #0x21]
    23b8: 3901c3e9     	strb	w9, [sp, #0x70]
    23bc: 3c831140     	stur	q0, [x10, #0x31]
    23c0: 940000b2     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    23c4: 910003e0     	mov	x0, sp
    23c8: 9100c3e1     	add	x1, sp, #0x30
    23cc: aa1403e2     	mov	x2, x20
    23d0: 9400000a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    23d4: ad4007e0     	ldp	q0, q1, [sp]
    23d8: 3dc00be2     	ldr	q2, [sp, #0x20]
    23dc: ad000660     	stp	q0, q1, [x19]
    23e0: 3d800a62     	str	q2, [x19, #0x20]
    23e4: a9594ff4     	ldp	x20, x19, [sp, #0x190]
    23e8: f940c3fc     	ldr	x28, [sp, #0x180]
    23ec: a9577bfd     	ldp	x29, x30, [sp, #0x170]
    23f0: 910683ff     	add	sp, sp, #0x1a0
    23f4: d65f03c0     	ret

00000000000023f8 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    23f8: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    23fc: f9000bfc     	str	x28, [sp, #0x10]
    2400: a90267fa     	stp	x26, x25, [sp, #0x20]
    2404: a9035ff8     	stp	x24, x23, [sp, #0x30]
    2408: a90457f6     	stp	x22, x21, [sp, #0x40]
    240c: a9054ff4     	stp	x20, x19, [sp, #0x50]
    2410: 910003fd     	mov	x29, sp
    2414: d10e03ff     	sub	sp, sp, #0x380
    2418: 4f02e780     	movi	v0.16b, #0x5c
    241c: 4f01e6c2     	movi	v2.16b, #0x36
    2420: 3dc00824     	ldr	q4, [x1, #0x20]
    2424: ad400c21     	ldp	q1, q3, [x1]
    2428: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		0000000000002428:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xb0
    242c: 91000108     	add	x8, x8, #0x0
		000000000000242c:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xb0
    2430: aa0003f3     	mov	x19, x0
    2434: 910443e0     	add	x0, sp, #0x110
    2438: d10383a1     	sub	x1, x29, #0xe0
    243c: aa0203f4     	mov	x20, x2
    2440: 910443f7     	add	x23, sp, #0x110
    2444: 6e201c25     	eor	v5.16b, v1.16b, v0.16b
    2448: 6e201c66     	eor	v6.16b, v3.16b, v0.16b
    244c: 6e201c87     	eor	v7.16b, v4.16b, v0.16b
    2450: 6e221c21     	eor	v1.16b, v1.16b, v2.16b
    2454: 6e221c63     	eor	v3.16b, v3.16b, v2.16b
    2458: ad1183e0     	stp	q0, q0, [sp, #0x230]
    245c: ad1283e0     	stp	q0, q0, [sp, #0x250]
    2460: 6e221c84     	eor	v4.16b, v4.16b, v2.16b
    2464: d10383b8     	sub	x24, x29, #0xe0
    2468: ad3b0ba2     	stp	q2, q2, [x29, #-0xa0]
    246c: ad0f9be5     	stp	q5, q6, [sp, #0x1f0]
    2470: ad1083e7     	stp	q7, q0, [sp, #0x210]
    2474: ad390fa1     	stp	q1, q3, [x29, #-0xe0]
    2478: ad450500     	ldp	q0, q1, [x8, #0xa0]
    247c: ad3a0ba4     	stp	q4, q2, [x29, #-0xc0]
    2480: ad3c0ba2     	stp	q2, q2, [x29, #-0x80]
    2484: ad0603e1     	stp	q1, q0, [sp, #0xc0]
    2488: ad0d87e0     	stp	q0, q1, [sp, #0x1b0]
    248c: ad460102     	ldp	q2, q0, [x8, #0xc0]
    2490: ad050be0     	stp	q0, q2, [sp, #0xa0]
    2494: ad0e83e2     	stp	q2, q0, [sp, #0x1d0]
    2498: ad430101     	ldp	q1, q0, [x8, #0x60]
    249c: ad0407e0     	stp	q0, q1, [sp, #0x80]
    24a0: ad0b83e1     	stp	q1, q0, [sp, #0x170]
    24a4: ad440102     	ldp	q2, q0, [x8, #0x80]
    24a8: ad030be0     	stp	q0, q2, [sp, #0x60]
    24ac: ad0c83e2     	stp	q2, q0, [sp, #0x190]
    24b0: ad410101     	ldp	q1, q0, [x8, #0x20]
    24b4: ad0207e0     	stp	q0, q1, [sp, #0x40]
    24b8: ad0983e1     	stp	q1, q0, [sp, #0x130]
    24bc: ad420102     	ldp	q2, q0, [x8, #0x40]
    24c0: ad010be0     	stp	q0, q2, [sp, #0x20]
    24c4: ad0a83e2     	stp	q2, q0, [sp, #0x150]
    24c8: ad400101     	ldp	q1, q0, [x8]
    24cc: ad0007e0     	stp	q0, q1, [sp]
    24d0: ad0883e1     	stp	q1, q0, [sp, #0x110]
    24d4: 940002b0     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    24d8: a95127e8     	ldp	x8, x9, [sp, #0x110]
    24dc: b1020119     	adds	x25, x8, #0x80
    24e0: 394783e8     	ldrb	w8, [sp, #0x1e0]
    24e4: 9a89353a     	cinc	x26, x9, hs
    24e8: a9116bf9     	stp	x25, x26, [sp, #0x110]
    24ec: 34000248     	cbz	w8,  <L1>
    24f0: 7101411f     	cmp	w8, #0x50
    24f4: 54000203     	b.lo	 <L1>
    24f8: 52801009     	mov	w9, #0x80               // =128
    24fc: 910443ea     	add	x10, sp, #0x110
    2500: aa1403e1     	mov	x1, x20
    2504: cb080135     	sub	x21, x9, x8
    2508: 91014156     	add	x22, x10, #0x50
    250c: 8b0802c0     	add	x0, x22, x8
    2510: aa1503e2     	mov	x2, x21
<L0>:
    2514: 94000000     	bl	 <L0>
		0000000000002514:  R_AARCH64_CALL26	memcpy
    2518: 910443e0     	add	x0, sp, #0x110
    251c: aa1603e1     	mov	x1, x22
    2520: 9400029d     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2524: a9516bf9     	ldp	x25, x26, [sp, #0x110]
    2528: 2a1f03e8     	mov	w8, wzr
    252c: 390783ff     	strb	wzr, [sp, #0x1e0]
    2530: 14000002     	b	 <L2>
<L1>:
    2534: aa1f03f5     	mov	x21, xzr
<L2>:
    2538: 52800609     	mov	w9, #0x30               // =48
    253c: 8b2842e8     	add	x8, x23, w8, uxtw
    2540: 8b150281     	add	x1, x20, x21
    2544: cb150136     	sub	x22, x9, x21
    2548: 91014100     	add	x0, x8, #0x50
    254c: aa1603e2     	mov	x2, x22
<L3>:
    2550: 94000000     	bl	 <L3>
		0000000000002550:  R_AARCH64_CALL26	memcpy
    2554: 394783e8     	ldrb	w8, [sp, #0x1e0]
    2558: b100c329     	adds	x9, x25, #0x30
    255c: 910443e0     	add	x0, sp, #0x110
    2560: 9a9a374a     	cinc	x10, x26, hs
    2564: 9109c3e1     	add	x1, sp, #0x270
    2568: 0b160108     	add	w8, w8, w22
    256c: a9112be9     	stp	x9, x10, [sp, #0x110]
    2570: 9109c3f6     	add	x22, sp, #0x270
    2574: 390783e8     	strb	w8, [sp, #0x1e0]
    2578: 9400022a     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    257c: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    2580: d10383a0     	sub	x0, x29, #0xe0
    2584: 910382e1     	add	x1, x23, #0xe0
    2588: 91014314     	add	x20, x24, #0x50
    258c: ad3e03a1     	stp	q1, q0, [x29, #-0x40]
    2590: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
    2594: ad3f03a1     	stp	q1, q0, [x29, #-0x20]
    2598: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    259c: ad3c03a1     	stp	q1, q0, [x29, #-0x80]
    25a0: ad4307e0     	ldp	q0, q1, [sp, #0x60]
    25a4: ad3d03a1     	stp	q1, q0, [x29, #-0x60]
    25a8: ad4207e0     	ldp	q0, q1, [sp, #0x40]
    25ac: ad3a03a1     	stp	q1, q0, [x29, #-0xc0]
    25b0: ad4107e0     	ldp	q0, q1, [sp, #0x20]
    25b4: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
    25b8: ad4007e0     	ldp	q0, q1, [sp]
    25bc: ad3903a1     	stp	q1, q0, [x29, #-0xe0]
    25c0: 94000275     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    25c4: a9722ba9     	ldp	x9, x10, [x29, #-0xe0]
    25c8: 385f03a8     	ldurb	w8, [x29, #-0x10]
    25cc: b1020138     	adds	x24, x9, #0x80
    25d0: 9a8a3557     	cinc	x23, x10, hs
    25d4: a9325fb8     	stp	x24, x23, [x29, #-0xe0]
    25d8: 34000208     	cbz	w8,  <L5>
    25dc: 7101411f     	cmp	w8, #0x50
    25e0: 540001c3     	b.lo	 <L5>
    25e4: 52801009     	mov	w9, #0x80               // =128
    25e8: 8b080280     	add	x0, x20, x8
    25ec: 9109c3e1     	add	x1, sp, #0x270
    25f0: cb080135     	sub	x21, x9, x8
    25f4: aa1503e2     	mov	x2, x21
<L4>:
    25f8: 94000000     	bl	 <L4>
		00000000000025f8:  R_AARCH64_CALL26	memcpy
    25fc: d10383a0     	sub	x0, x29, #0xe0
    2600: aa1403e1     	mov	x1, x20
    2604: 94000264     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2608: a9725fb8     	ldp	x24, x23, [x29, #-0xe0]
    260c: 2a1f03e8     	mov	w8, wzr
    2610: 381f03bf     	sturb	wzr, [x29, #-0x10]
    2614: 14000002     	b	 <L6>
<L5>:
    2618: aa1f03f5     	mov	x21, xzr
<L6>:
    261c: 52800609     	mov	w9, #0x30               // =48
    2620: 8b284280     	add	x0, x20, w8, uxtw
    2624: 8b1502c1     	add	x1, x22, x21
    2628: cb150134     	sub	x20, x9, x21
    262c: aa1403e2     	mov	x2, x20
<L7>:
    2630: 94000000     	bl	 <L7>
		0000000000002630:  R_AARCH64_CALL26	memcpy
    2634: 385f03a8     	ldurb	w8, [x29, #-0x10]
    2638: b100c309     	adds	x9, x24, #0x30
    263c: d10383a0     	sub	x0, x29, #0xe0
    2640: 9a9736ea     	cinc	x10, x23, hs
    2644: 910383e1     	add	x1, sp, #0xe0
    2648: 0b140108     	add	w8, w8, w20
    264c: a9322ba9     	stp	x9, x10, [x29, #-0xe0]
    2650: 381f03a8     	sturb	w8, [x29, #-0x10]
    2654: 940001f3     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2658: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    265c: 3dc043e2     	ldr	q2, [sp, #0x100]
    2660: 3d800a62     	str	q2, [x19, #0x20]
    2664: ad000660     	stp	q0, q1, [x19]
    2668: 910e03ff     	add	sp, sp, #0x380
    266c: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    2670: f9400bfc     	ldr	x28, [sp, #0x10]
    2674: a94457f6     	ldp	x22, x21, [sp, #0x40]
    2678: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    267c: a94267fa     	ldp	x26, x25, [sp, #0x20]
    2680: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    2684: d65f03c0     	ret

0000000000002688 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
    2688: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
    268c: a9016ffc     	stp	x28, x27, [sp, #0x10]
    2690: a90267fa     	stp	x26, x25, [sp, #0x20]
    2694: a9035ff8     	stp	x24, x23, [sp, #0x30]
    2698: a90457f6     	stp	x22, x21, [sp, #0x40]
    269c: a9054ff4     	stp	x20, x19, [sp, #0x50]
    26a0: 910003fd     	mov	x29, sp
    26a4: d11a43ff     	sub	sp, sp, #0x690
    26a8: ad400482     	ldp	q2, q1, [x4]
    26ac: 52800028     	mov	w8, #0x1                // =1
    26b0: 3dc00880     	ldr	q0, [x4, #0x20]
    26b4: aa0303f4     	mov	x20, x3
    26b8: aa0103f5     	mov	x21, x1
    26bc: 910d03fb     	add	x27, sp, #0x340
    26c0: f100c03f     	cmp	x1, #0x30
    26c4: 3906b3e8     	strb	w8, [sp, #0x1ac]
    26c8: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		00000000000026c8:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xb0
    26cc: 91000108     	add	x8, x8, #0x0
		00000000000026cc:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xb0
    26d0: a90b03e2     	stp	x2, x0, [sp, #0xb0]
    26d4: ad0083e1     	stp	q1, q0, [sp, #0x10]
    26d8: 3d8003e2     	str	q2, [sp]
    26dc: 54000922     	b.hs	 <L2>
    26e0: f9001bff     	str	xzr, [sp, #0x30]
<L0>:
    26e4: f100c2a8     	subs	x8, x21, #0x30
    26e8: 9a8832b7     	csel	x23, x21, x8, lo
    26ec: b40038b7     	cbz	x23,  <L39>
    26f0: 4f02e780     	movi	v0.16b, #0x5c
    26f4: ad401be7     	ldp	q7, q6, [sp]
    26f8: 4f01e6c1     	movi	v1.16b, #0x36
    26fc: 3dc00be5     	ldr	q5, [sp, #0x20]
    2700: 90000008     	adrp	x8, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		0000000000002700:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xb0
    2704: 91000108     	add	x8, x8, #0x0
		0000000000002704:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xb0
    2708: 911483e0     	add	x0, sp, #0x520
    270c: 910d03e1     	add	x1, sp, #0x340
    2710: 6e201ce2     	eor	v2.16b, v7.16b, v0.16b
    2714: 6e201cc3     	eor	v3.16b, v6.16b, v0.16b
    2718: 6e201ca4     	eor	v4.16b, v5.16b, v0.16b
    271c: ad020761     	stp	q1, q1, [x27, #0x40]
    2720: ad030761     	stp	q1, q1, [x27, #0x60]
    2724: ad160f62     	stp	q2, q3, [x27, #0x2c0]
    2728: 6e211ce2     	eor	v2.16b, v7.16b, v1.16b
    272c: 6e211cc3     	eor	v3.16b, v6.16b, v1.16b
    2730: ad170364     	stp	q4, q0, [x27, #0x2e0]
    2734: 6e211ca4     	eor	v4.16b, v5.16b, v1.16b
    2738: ad180360     	stp	q0, q0, [x27, #0x300]
    273c: ad000f62     	stp	q2, q3, [x27]
    2740: ad010764     	stp	q4, q1, [x27, #0x20]
    2744: ad190360     	stp	q0, q0, [x27, #0x320]
    2748: ad400102     	ldp	q2, q0, [x8]
    274c: ad0c03e2     	stp	q2, q0, [sp, #0x180]
    2750: ad0f0362     	stp	q2, q0, [x27, #0x1e0]
    2754: ad420500     	ldp	q0, q1, [x8, #0x40]
    2758: ad0b07e0     	stp	q0, q1, [sp, #0x160]
    275c: ad110760     	stp	q0, q1, [x27, #0x220]
    2760: ad410901     	ldp	q1, q2, [x8, #0x20]
    2764: ad0a0be1     	stp	q1, q2, [sp, #0x140]
    2768: ad100b61     	stp	q1, q2, [x27, #0x200]
    276c: ad440102     	ldp	q2, q0, [x8, #0x80]
    2770: ad0903e2     	stp	q2, q0, [sp, #0x120]
    2774: ad130362     	stp	q2, q0, [x27, #0x260]
    2778: ad430500     	ldp	q0, q1, [x8, #0x60]
    277c: ad0807e0     	stp	q0, q1, [sp, #0x100]
    2780: ad120760     	stp	q0, q1, [x27, #0x240]
    2784: ad460901     	ldp	q1, q2, [x8, #0xc0]
    2788: ad070be1     	stp	q1, q2, [sp, #0xe0]
    278c: ad150b61     	stp	q1, q2, [x27, #0x2a0]
    2790: ad450102     	ldp	q2, q0, [x8, #0xa0]
    2794: ad0603e2     	stp	q2, q0, [sp, #0xc0]
    2798: ad140362     	stp	q2, q0, [x27, #0x280]
    279c: 940001fe     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    27a0: a95e2768     	ldp	x8, x9, [x27, #0x1e0]
    27a4: b102010a     	adds	x10, x8, #0x80
    27a8: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    27ac: 9a893529     	cinc	x9, x9, hs
    27b0: f100bebf     	cmp	x21, #0x2f
    27b4: a91e276a     	stp	x10, x9, [x27, #0x1e0]
    27b8: 540021e9     	b.ls	 <L25>
    27bc: 34001fa8     	cbz	w8,  <L22>
    27c0: 7101411f     	cmp	w8, #0x50
    27c4: 54001f63     	b.lo	 <L22>
    27c8: 52801009     	mov	w9, #0x80               // =128
    27cc: 911483ea     	add	x10, sp, #0x520
    27d0: f9405fe1     	ldr	x1, [sp, #0xb8]
    27d4: cb080136     	sub	x22, x9, x8
    27d8: 91014158     	add	x24, x10, #0x50
    27dc: 8b080300     	add	x0, x24, x8
    27e0: aa1603e2     	mov	x2, x22
<L1>:
    27e4: 94000000     	bl	 <L1>
		00000000000027e4:  R_AARCH64_CALL26	memcpy
    27e8: 911483e0     	add	x0, sp, #0x520
    27ec: aa1803e1     	mov	x1, x24
    27f0: 940001e9     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    27f4: 2a1f03e8     	mov	w8, wzr
    27f8: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    27fc: 140000ee     	b	 <L23>
<L2>:
    2800: 4f02e783     	movi	v3.16b, #0x5c
    2804: 4f01e6c4     	movi	v4.16b, #0x36
    2808: d2401a89     	eor	x9, x20, #0x7f
    280c: f9001fe9     	str	x9, [sp, #0x38]
    2810: 9106c3e9     	add	x9, sp, #0x1b0
    2814: aa1f03fc     	mov	x28, xzr
    2818: 91014377     	add	x23, x27, #0x50
    281c: 91014138     	add	x24, x9, #0x50
    2820: 52800039     	mov	w25, #0x1               // =1
    2824: 52800033     	mov	w19, #0x1               // =1
    2828: f90057f5     	str	x21, [sp, #0xa8]
    282c: 6e231c46     	eor	v6.16b, v2.16b, v3.16b
    2830: 6e231c25     	eor	v5.16b, v1.16b, v3.16b
    2834: 6e231c03     	eor	v3.16b, v0.16b, v3.16b
    2838: 6e241c21     	eor	v1.16b, v1.16b, v4.16b
    283c: 6e241c00     	eor	v0.16b, v0.16b, v4.16b
    2840: 6e241c42     	eor	v2.16b, v2.16b, v4.16b
    2844: ad041be5     	stp	q5, q6, [sp, #0x80]
    2848: ad0207e0     	stp	q0, q1, [sp, #0x40]
    284c: ad400101     	ldp	q1, q0, [x8]
    2850: ad030fe2     	stp	q2, q3, [sp, #0x60]
    2854: ad0c07e0     	stp	q0, q1, [sp, #0x180]
    2858: ad410101     	ldp	q1, q0, [x8, #0x20]
    285c: ad0b07e0     	stp	q0, q1, [sp, #0x160]
    2860: ad420101     	ldp	q1, q0, [x8, #0x40]
    2864: ad0a07e0     	stp	q0, q1, [sp, #0x140]
    2868: ad430101     	ldp	q1, q0, [x8, #0x60]
    286c: ad0907e0     	stp	q0, q1, [sp, #0x120]
    2870: ad440101     	ldp	q1, q0, [x8, #0x80]
    2874: ad0807e0     	stp	q0, q1, [sp, #0x100]
    2878: ad450101     	ldp	q1, q0, [x8, #0xa0]
    287c: ad0707e0     	stp	q0, q1, [sp, #0xe0]
    2880: ad460101     	ldp	q1, q0, [x8, #0xc0]
    2884: 52800608     	mov	w8, #0x30               // =48
    2888: f9001be8     	str	x8, [sp, #0x30]
    288c: ad0607e0     	stp	q0, q1, [sp, #0xc0]
    2890: 1400001a     	b	 <L6>
<L3>:
    2894: aa1f03f9     	mov	x25, xzr
<L4>:
    2898: 8b2842e0     	add	x0, x23, w8, uxtw
    289c: 52800608     	mov	w8, #0x30               // =48
    28a0: cb19011a     	sub	x26, x8, x25
    28a4: 911283e8     	add	x8, sp, #0x4a0
    28a8: 8b190101     	add	x1, x8, x25
    28ac: aa1a03e2     	mov	x2, x26
<L5>:
    28b0: 94000000     	bl	 <L5>
		00000000000028b0:  R_AARCH64_CALL26	memcpy
    28b4: 395043e8     	ldrb	w8, [sp, #0x410]
    28b8: b100c2c9     	adds	x9, x22, #0x30
    28bc: 910d03e0     	add	x0, sp, #0x340
    28c0: 9a9536aa     	cinc	x10, x21, hs
    28c4: 0b1a0108     	add	w8, w8, w26
    28c8: a9002b69     	stp	x9, x10, [x27]
    28cc: 391043e8     	strb	w8, [sp, #0x410]
    28d0: f9405fe8     	ldr	x8, [sp, #0xb8]
    28d4: 8b1c0101     	add	x1, x8, x28
    28d8: 94000152     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    28dc: f94057f5     	ldr	x21, [sp, #0xa8]
    28e0: 2a1f03f9     	mov	w25, wzr
    28e4: 11000673     	add	w19, w19, #0x1
    28e8: 5280061c     	mov	w28, #0x30              // =48
    28ec: 3906b3f3     	strb	w19, [sp, #0x1ac]
    28f0: f10182bf     	cmp	x21, #0x60
    28f4: 54ffef83     	b.lo	 <L0>
<L6>:
    28f8: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    28fc: 910d03e0     	add	x0, sp, #0x340
    2900: 911283e1     	add	x1, sp, #0x4a0
    2904: ad070361     	stp	q1, q0, [x27, #0xe0]
    2908: 4f02e780     	movi	v0.16b, #0x5c
    290c: 3dc01fe1     	ldr	q1, [sp, #0x70]
    2910: ad080361     	stp	q1, q0, [x27, #0x100]
    2914: ad090360     	stp	q0, q0, [x27, #0x120]
    2918: ad0a0360     	stp	q0, q0, [x27, #0x140]
    291c: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    2920: ad0b0361     	stp	q1, q0, [x27, #0x160]
    2924: 4f01e6c0     	movi	v0.16b, #0x36
    2928: 3dc013e1     	ldr	q1, [sp, #0x40]
    292c: ad0c0361     	stp	q1, q0, [x27, #0x180]
    2930: ad0d0360     	stp	q0, q0, [x27, #0x1a0]
    2934: ad0e0360     	stp	q0, q0, [x27, #0x1c0]
    2938: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    293c: ad000361     	stp	q1, q0, [x27]
    2940: ad4a03e1     	ldp	q1, q0, [sp, #0x140]
    2944: ad020760     	stp	q0, q1, [x27, #0x40]
    2948: ad4b03e1     	ldp	q1, q0, [sp, #0x160]
    294c: ad010760     	stp	q0, q1, [x27, #0x20]
    2950: ad4803e1     	ldp	q1, q0, [sp, #0x100]
    2954: ad040760     	stp	q0, q1, [x27, #0x80]
    2958: ad4903e1     	ldp	q1, q0, [sp, #0x120]
    295c: ad030760     	stp	q0, q1, [x27, #0x60]
    2960: ad4603e1     	ldp	q1, q0, [sp, #0xc0]
    2964: ad060760     	stp	q0, q1, [x27, #0xc0]
    2968: ad4703e1     	ldp	q1, q0, [sp, #0xe0]
    296c: ad050760     	stp	q0, q1, [x27, #0xa0]
    2970: 94000189     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2974: a9402768     	ldp	x8, x9, [x27]
    2978: 9106c3e0     	add	x0, sp, #0x1b0
    297c: 910d03e1     	add	x1, sp, #0x340
    2980: 52802c02     	mov	w2, #0x160              // =352
    2984: b1020108     	adds	x8, x8, #0x80
    2988: 9a893529     	cinc	x9, x9, hs
    298c: a9002768     	stp	x8, x9, [x27]
<L7>:
    2990: 94000000     	bl	 <L7>
		0000000000002990:  R_AARCH64_CALL26	memcpy
    2994: 394a03e8     	ldrb	w8, [sp, #0x280]
    2998: 370003f9     	tbnz	w25, #0x0,  <L12>
    299c: 340001e8     	cbz	w8,  <L9>
    29a0: 7101411f     	cmp	w8, #0x50
    29a4: 540001a3     	b.lo	 <L9>
    29a8: 52801009     	mov	w9, #0x80               // =128
    29ac: f9405fe1     	ldr	x1, [sp, #0xb8]
    29b0: 8b080300     	add	x0, x24, x8
    29b4: cb080139     	sub	x25, x9, x8
    29b8: aa1903e2     	mov	x2, x25
<L8>:
    29bc: 94000000     	bl	 <L8>
		00000000000029bc:  R_AARCH64_CALL26	memcpy
    29c0: 9106c3e0     	add	x0, sp, #0x1b0
    29c4: aa1803e1     	mov	x1, x24
    29c8: 94000173     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    29cc: 2a1f03e8     	mov	w8, wzr
    29d0: 390a03ff     	strb	wzr, [sp, #0x280]
    29d4: 14000002     	b	 <L10>
<L9>:
    29d8: aa1f03f9     	mov	x25, xzr
<L10>:
    29dc: 8b284300     	add	x0, x24, w8, uxtw
    29e0: 52800608     	mov	w8, #0x30               // =48
    29e4: cb19011a     	sub	x26, x8, x25
    29e8: f9405fe8     	ldr	x8, [sp, #0xb8]
    29ec: aa1a03e2     	mov	x2, x26
    29f0: 8b190101     	add	x1, x8, x25
<L11>:
    29f4: 94000000     	bl	 <L11>
		00000000000029f4:  R_AARCH64_CALL26	memcpy
    29f8: a95b2be9     	ldp	x9, x10, [sp, #0x1b0]
    29fc: 394a03e8     	ldrb	w8, [sp, #0x280]
    2a00: 0b1a0108     	add	w8, w8, w26
    2a04: b100c129     	adds	x9, x9, #0x30
    2a08: 390a03e8     	strb	w8, [sp, #0x280]
    2a0c: 9a8a354a     	cinc	x10, x10, hs
    2a10: a91b2be9     	stp	x9, x10, [sp, #0x1b0]
<L12>:
    2a14: 34000228     	cbz	w8,  <L14>
    2a18: f9401fea     	ldr	x10, [sp, #0x38]
    2a1c: 2a0803e9     	mov	w9, w8
    2a20: eb09015f     	cmp	x10, x9
    2a24: 540001a2     	b.hs	 <L14>
    2a28: 5280100a     	mov	w10, #0x80              // =128
    2a2c: f9405be1     	ldr	x1, [sp, #0xb0]
    2a30: 8b090300     	add	x0, x24, x9
    2a34: 4b080159     	sub	w25, w10, w8
    2a38: aa1903e2     	mov	x2, x25
<L13>:
    2a3c: 94000000     	bl	 <L13>
		0000000000002a3c:  R_AARCH64_CALL26	memcpy
    2a40: 9106c3e0     	add	x0, sp, #0x1b0
    2a44: aa1803e1     	mov	x1, x24
    2a48: 94000153     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2a4c: 2a1f03e8     	mov	w8, wzr
    2a50: 390a03ff     	strb	wzr, [sp, #0x280]
    2a54: 14000002     	b	 <L15>
<L14>:
    2a58: aa1f03f9     	mov	x25, xzr
<L15>:
    2a5c: 8b284300     	add	x0, x24, w8, uxtw
    2a60: f9405be8     	ldr	x8, [sp, #0xb0]
    2a64: cb19029a     	sub	x26, x20, x25
    2a68: aa1a03e2     	mov	x2, x26
    2a6c: 8b190101     	add	x1, x8, x25
<L16>:
    2a70: 94000000     	bl	 <L16>
		0000000000002a70:  R_AARCH64_CALL26	memcpy
    2a74: a95b2be9     	ldp	x9, x10, [sp, #0x1b0]
    2a78: 394a03e8     	ldrb	w8, [sp, #0x280]
    2a7c: 0b1a0108     	add	w8, w8, w26
    2a80: ab140136     	adds	x22, x9, x20
    2a84: 390a03e8     	strb	w8, [sp, #0x280]
    2a88: 9a8a3555     	cinc	x21, x10, hs
    2a8c: a91b57f6     	stp	x22, x21, [sp, #0x1b0]
    2a90: 34000208     	cbz	w8,  <L18>
    2a94: 7101fd1f     	cmp	w8, #0x7f
    2a98: 540001c3     	b.lo	 <L18>
    2a9c: 52801009     	mov	w9, #0x80               // =128
    2aa0: 8b284300     	add	x0, x24, w8, uxtw
    2aa4: 9106b3e1     	add	x1, sp, #0x1ac
    2aa8: 4b080139     	sub	w25, w9, w8
    2aac: aa1903e2     	mov	x2, x25
<L17>:
    2ab0: 94000000     	bl	 <L17>
		0000000000002ab0:  R_AARCH64_CALL26	memcpy
    2ab4: 9106c3e0     	add	x0, sp, #0x1b0
    2ab8: aa1803e1     	mov	x1, x24
    2abc: 94000136     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2ac0: a95b57f6     	ldp	x22, x21, [sp, #0x1b0]
    2ac4: 2a1f03e8     	mov	w8, wzr
    2ac8: 390a03ff     	strb	wzr, [sp, #0x280]
    2acc: 14000002     	b	 <L19>
<L18>:
    2ad0: aa1f03f9     	mov	x25, xzr
<L19>:
    2ad4: 8b284300     	add	x0, x24, w8, uxtw
    2ad8: 52800028     	mov	w8, #0x1                // =1
    2adc: cb19011a     	sub	x26, x8, x25
    2ae0: 9106b3e8     	add	x8, sp, #0x1ac
    2ae4: 8b190101     	add	x1, x8, x25
    2ae8: aa1a03e2     	mov	x2, x26
<L20>:
    2aec: 94000000     	bl	 <L20>
		0000000000002aec:  R_AARCH64_CALL26	memcpy
    2af0: 394a03e8     	ldrb	w8, [sp, #0x280]
    2af4: b10006c9     	adds	x9, x22, #0x1
    2af8: 9106c3e0     	add	x0, sp, #0x1b0
    2afc: 9a9536aa     	cinc	x10, x21, hs
    2b00: 911283e1     	add	x1, sp, #0x4a0
    2b04: 0b1a0108     	add	w8, w8, w26
    2b08: a91b2be9     	stp	x9, x10, [sp, #0x1b0]
    2b0c: 390a03e8     	strb	w8, [sp, #0x280]
    2b10: 940000c4     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2b14: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    2b18: 9106c3e8     	add	x8, sp, #0x1b0
    2b1c: 910d03e0     	add	x0, sp, #0x340
    2b20: 91038101     	add	x1, x8, #0xe0
    2b24: ad050361     	stp	q1, q0, [x27, #0xa0]
    2b28: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    2b2c: ad060361     	stp	q1, q0, [x27, #0xc0]
    2b30: ad4907e0     	ldp	q0, q1, [sp, #0x120]
    2b34: ad030361     	stp	q1, q0, [x27, #0x60]
    2b38: ad4807e0     	ldp	q0, q1, [sp, #0x100]
    2b3c: ad040361     	stp	q1, q0, [x27, #0x80]
    2b40: ad4b07e0     	ldp	q0, q1, [sp, #0x160]
    2b44: ad010361     	stp	q1, q0, [x27, #0x20]
    2b48: ad4a07e0     	ldp	q0, q1, [sp, #0x140]
    2b4c: ad020361     	stp	q1, q0, [x27, #0x40]
    2b50: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    2b54: ad000361     	stp	q1, q0, [x27]
    2b58: 9400010f     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2b5c: a9402b69     	ldp	x9, x10, [x27]
    2b60: 395043e8     	ldrb	w8, [sp, #0x410]
    2b64: b1020136     	adds	x22, x9, #0x80
    2b68: 9a8a3555     	cinc	x21, x10, hs
    2b6c: a9005776     	stp	x22, x21, [x27]
    2b70: 34ffe928     	cbz	w8,  <L3>
    2b74: 7101411f     	cmp	w8, #0x50
    2b78: 54ffe8e3     	b.lo	 <L3>
    2b7c: 52801009     	mov	w9, #0x80               // =128
    2b80: 8b0802e0     	add	x0, x23, x8
    2b84: 911283e1     	add	x1, sp, #0x4a0
    2b88: cb080139     	sub	x25, x9, x8
    2b8c: aa1903e2     	mov	x2, x25
<L21>:
    2b90: 94000000     	bl	 <L21>
		0000000000002b90:  R_AARCH64_CALL26	memcpy
    2b94: 910d03e0     	add	x0, sp, #0x340
    2b98: aa1703e1     	mov	x1, x23
    2b9c: 940000fe     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2ba0: a9405776     	ldp	x22, x21, [x27]
    2ba4: 2a1f03e8     	mov	w8, wzr
    2ba8: 391043ff     	strb	wzr, [sp, #0x410]
    2bac: 17ffff3b     	b	 <L4>
<L22>:
    2bb0: aa1f03f6     	mov	x22, xzr
<L23>:
    2bb4: 911483e9     	add	x9, sp, #0x520
    2bb8: 5280060a     	mov	w10, #0x30              // =48
    2bbc: 8b284128     	add	x8, x9, w8, uxtw
    2bc0: cb160158     	sub	x24, x10, x22
    2bc4: aa1803e2     	mov	x2, x24
    2bc8: 91014100     	add	x0, x8, #0x50
    2bcc: f9405fe8     	ldr	x8, [sp, #0xb8]
    2bd0: 8b160101     	add	x1, x8, x22
<L24>:
    2bd4: 94000000     	bl	 <L24>
		0000000000002bd4:  R_AARCH64_CALL26	memcpy
    2bd8: a95e2b69     	ldp	x9, x10, [x27, #0x1e0]
    2bdc: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    2be0: 0b180108     	add	w8, w8, w24
    2be4: b100c129     	adds	x9, x9, #0x30
    2be8: 3917c3e8     	strb	w8, [sp, #0x5f0]
    2bec: 9a8a354a     	cinc	x10, x10, hs
    2bf0: a91e2b69     	stp	x9, x10, [x27, #0x1e0]
<L25>:
    2bf4: 34000268     	cbz	w8,  <L27>
    2bf8: 2a0803e9     	mov	w9, w8
    2bfc: 8b09028a     	add	x10, x20, x9
    2c00: f102015f     	cmp	x10, #0x80
    2c04: 540001e3     	b.lo	 <L27>
    2c08: 5280100a     	mov	w10, #0x80              // =128
    2c0c: 911483eb     	add	x11, sp, #0x520
    2c10: f9405be1     	ldr	x1, [sp, #0xb0]
    2c14: 4b080158     	sub	w24, w10, w8
    2c18: 91014176     	add	x22, x11, #0x50
    2c1c: 8b0902c0     	add	x0, x22, x9
    2c20: aa1803e2     	mov	x2, x24
<L26>:
    2c24: 94000000     	bl	 <L26>
		0000000000002c24:  R_AARCH64_CALL26	memcpy
    2c28: 911483e0     	add	x0, sp, #0x520
    2c2c: aa1603e1     	mov	x1, x22
    2c30: 940000d9     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2c34: 2a1f03e8     	mov	w8, wzr
    2c38: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    2c3c: 14000002     	b	 <L28>
<L27>:
    2c40: aa1f03f8     	mov	x24, xzr
<L28>:
    2c44: 911483f3     	add	x19, sp, #0x520
    2c48: cb180299     	sub	x25, x20, x24
    2c4c: 91014276     	add	x22, x19, #0x50
    2c50: aa1903e2     	mov	x2, x25
    2c54: 8b2842c0     	add	x0, x22, w8, uxtw
    2c58: f9405be8     	ldr	x8, [sp, #0xb0]
    2c5c: 8b180101     	add	x1, x8, x24
<L29>:
    2c60: 94000000     	bl	 <L29>
		0000000000002c60:  R_AARCH64_CALL26	memcpy
    2c64: a95e2b69     	ldp	x9, x10, [x27, #0x1e0]
    2c68: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    2c6c: 0b190108     	add	w8, w8, w25
    2c70: ab140139     	adds	x25, x9, x20
    2c74: 3917c3e8     	strb	w8, [sp, #0x5f0]
    2c78: 9a8a3558     	cinc	x24, x10, hs
    2c7c: a91e6379     	stp	x25, x24, [x27, #0x1e0]
    2c80: 34000208     	cbz	w8,  <L31>
    2c84: 7101fd1f     	cmp	w8, #0x7f
    2c88: 540001c3     	b.lo	 <L31>
    2c8c: 52801009     	mov	w9, #0x80               // =128
    2c90: 8b2842c0     	add	x0, x22, w8, uxtw
    2c94: 9106b3e1     	add	x1, sp, #0x1ac
    2c98: 4b080134     	sub	w20, w9, w8
    2c9c: aa1403e2     	mov	x2, x20
<L30>:
    2ca0: 94000000     	bl	 <L30>
		0000000000002ca0:  R_AARCH64_CALL26	memcpy
    2ca4: 911483e0     	add	x0, sp, #0x520
    2ca8: aa1603e1     	mov	x1, x22
    2cac: 940000ba     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2cb0: a95e6379     	ldp	x25, x24, [x27, #0x1e0]
    2cb4: 2a1f03e8     	mov	w8, wzr
    2cb8: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    2cbc: 14000002     	b	 <L32>
<L31>:
    2cc0: aa1f03f4     	mov	x20, xzr
<L32>:
    2cc4: 52800029     	mov	w9, #0x1                // =1
    2cc8: 8b2842c0     	add	x0, x22, w8, uxtw
    2ccc: 9106b3e8     	add	x8, sp, #0x1ac
    2cd0: cb140135     	sub	x21, x9, x20
    2cd4: 8b140101     	add	x1, x8, x20
    2cd8: aa1503e2     	mov	x2, x21
<L33>:
    2cdc: 94000000     	bl	 <L33>
		0000000000002cdc:  R_AARCH64_CALL26	memcpy
    2ce0: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    2ce4: b1000729     	adds	x9, x25, #0x1
    2ce8: 911483e0     	add	x0, sp, #0x520
    2cec: 9a98370a     	cinc	x10, x24, hs
    2cf0: 911283e1     	add	x1, sp, #0x4a0
    2cf4: 911283f6     	add	x22, sp, #0x4a0
    2cf8: 0b150108     	add	w8, w8, w21
    2cfc: a91e2b69     	stp	x9, x10, [x27, #0x1e0]
    2d00: 3917c3e8     	strb	w8, [sp, #0x5f0]
    2d04: 94000047     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2d08: ad4603e1     	ldp	q1, q0, [sp, #0xc0]
    2d0c: 910d03e8     	add	x8, sp, #0x340
    2d10: 910d03e0     	add	x0, sp, #0x340
    2d14: 91038261     	add	x1, x19, #0xe0
    2d18: 91014114     	add	x20, x8, #0x50
    2d1c: ad050361     	stp	q1, q0, [x27, #0xa0]
    2d20: ad4703e1     	ldp	q1, q0, [sp, #0xe0]
    2d24: ad060361     	stp	q1, q0, [x27, #0xc0]
    2d28: ad4803e1     	ldp	q1, q0, [sp, #0x100]
    2d2c: ad030361     	stp	q1, q0, [x27, #0x60]
    2d30: ad4903e1     	ldp	q1, q0, [sp, #0x120]
    2d34: ad040361     	stp	q1, q0, [x27, #0x80]
    2d38: ad4a03e1     	ldp	q1, q0, [sp, #0x140]
    2d3c: ad010361     	stp	q1, q0, [x27, #0x20]
    2d40: ad4b03e1     	ldp	q1, q0, [sp, #0x160]
    2d44: ad020361     	stp	q1, q0, [x27, #0x40]
    2d48: ad4c03e1     	ldp	q1, q0, [sp, #0x180]
    2d4c: ad000361     	stp	q1, q0, [x27]
    2d50: 94000091     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2d54: a9402b69     	ldp	x9, x10, [x27]
    2d58: 395043e8     	ldrb	w8, [sp, #0x410]
    2d5c: b1020138     	adds	x24, x9, #0x80
    2d60: 9a8a3553     	cinc	x19, x10, hs
    2d64: a9004f78     	stp	x24, x19, [x27]
    2d68: 34000208     	cbz	w8,  <L35>
    2d6c: 7101411f     	cmp	w8, #0x50
    2d70: 540001c3     	b.lo	 <L35>
    2d74: 52801009     	mov	w9, #0x80               // =128
    2d78: 8b080280     	add	x0, x20, x8
    2d7c: 911283e1     	add	x1, sp, #0x4a0
    2d80: cb080135     	sub	x21, x9, x8
    2d84: aa1503e2     	mov	x2, x21
<L34>:
    2d88: 94000000     	bl	 <L34>
		0000000000002d88:  R_AARCH64_CALL26	memcpy
    2d8c: 910d03e0     	add	x0, sp, #0x340
    2d90: aa1403e1     	mov	x1, x20
    2d94: 94000080     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2d98: a9404f78     	ldp	x24, x19, [x27]
    2d9c: 2a1f03e8     	mov	w8, wzr
    2da0: 391043ff     	strb	wzr, [sp, #0x410]
    2da4: 14000002     	b	 <L36>
<L35>:
    2da8: aa1f03f5     	mov	x21, xzr
<L36>:
    2dac: 52800609     	mov	w9, #0x30               // =48
    2db0: 8b284280     	add	x0, x20, w8, uxtw
    2db4: 8b1502c1     	add	x1, x22, x21
    2db8: cb150134     	sub	x20, x9, x21
    2dbc: aa1403e2     	mov	x2, x20
<L37>:
    2dc0: 94000000     	bl	 <L37>
		0000000000002dc0:  R_AARCH64_CALL26	memcpy
    2dc4: 395043e8     	ldrb	w8, [sp, #0x410]
    2dc8: b100c309     	adds	x9, x24, #0x30
    2dcc: 910d03e0     	add	x0, sp, #0x340
    2dd0: 9a93366a     	cinc	x10, x19, hs
    2dd4: 910c43e1     	add	x1, sp, #0x310
    2dd8: 0b140108     	add	w8, w8, w20
    2ddc: a9002b69     	stp	x9, x10, [x27]
    2de0: 391043e8     	strb	w8, [sp, #0x410]
    2de4: 9400000f     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2de8: f9405fe8     	ldr	x8, [sp, #0xb8]
    2dec: f9401be9     	ldr	x9, [sp, #0x30]
    2df0: 910c43e1     	add	x1, sp, #0x310
    2df4: aa1703e2     	mov	x2, x23
    2df8: 8b090100     	add	x0, x8, x9
<L38>:
    2dfc: 94000000     	bl	 <L38>
		0000000000002dfc:  R_AARCH64_CALL26	memcpy
<L39>:
    2e00: 911a43ff     	add	sp, sp, #0x690
    2e04: a9454ff4     	ldp	x20, x19, [sp, #0x50]
    2e08: a94457f6     	ldp	x22, x21, [sp, #0x40]
    2e0c: a9435ff8     	ldp	x24, x23, [sp, #0x30]
    2e10: a94267fa     	ldp	x26, x25, [sp, #0x20]
    2e14: a9416ffc     	ldp	x28, x27, [sp, #0x10]
    2e18: a8c67bfd     	ldp	x29, x30, [sp], #0x60
    2e1c: d65f03c0     	ret

0000000000002e20 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    2e20: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    2e24: a90157f6     	stp	x22, x21, [sp, #0x10]
    2e28: a9024ff4     	stp	x20, x19, [sp, #0x20]
    2e2c: 910003fd     	mov	x29, sp
    2e30: 39434008     	ldrb	w8, [x0, #0xd0]
    2e34: 52801016     	mov	w22, #0x80              // =128
    2e38: 91014015     	add	x21, x0, #0x50
    2e3c: aa0103f3     	mov	x19, x1
    2e40: aa0003f4     	mov	x20, x0
    2e44: 2a1f03e1     	mov	w1, wzr
    2e48: cb0802c2     	sub	x2, x22, x8
    2e4c: 8b0802a0     	add	x0, x21, x8
<L0>:
    2e50: 94000000     	bl	 <L0>
		0000000000002e50:  R_AARCH64_CALL26	memset
    2e54: 39434288     	ldrb	w8, [x20, #0xd0]
    2e58: 38286ab6     	strb	w22, [x21, x8]
    2e5c: 39434288     	ldrb	w8, [x20, #0xd0]
    2e60: 11000509     	add	w9, w8, #0x1
    2e64: 7101bd1f     	cmp	w8, #0x6f
    2e68: 39034289     	strb	w9, [x20, #0xd0]
    2e6c: 54000129     	b.ls	 <L1>
    2e70: aa1403e0     	mov	x0, x20
    2e74: aa1503e1     	mov	x1, x21
    2e78: 94000047     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2e7c: 6f00e400     	movi	v0.2d, #0000000000000000
    2e80: ad0082a0     	stp	q0, q0, [x21, #0x10]
    2e84: ad0182a0     	stp	q0, q0, [x21, #0x30]
    2e88: ad0282a0     	stp	q0, q0, [x21, #0x50]
    2e8c: 3d8002a0     	str	q0, [x21]
<L1>:
    2e90: f9400688     	ldr	x8, [x20, #0x8]
    2e94: aa1403e0     	mov	x0, x20
    2e98: aa1503e1     	mov	x1, x21
    2e9c: d375fd09     	lsr	x9, x8, #53
    2ea0: d36dfd0a     	lsr	x10, x8, #45
    2ea4: d34dfd0b     	lsr	x11, x8, #13
    2ea8: 1e270120     	fmov	s0, w9
    2eac: d365fd09     	lsr	x9, x8, #37
    2eb0: 4e031d40     	mov	v0.b[1], w10
    2eb4: f940028a     	ldr	x10, [x20]
    2eb8: 93ca950c     	extr	x12, x8, x10, #0x25
    2ebc: 93cab50e     	extr	x14, x8, x10, #0x2d
    2ec0: 93cad50d     	extr	x13, x8, x10, #0x35
    2ec4: 4e051d20     	mov	v0.b[2], w9
    2ec8: d35dfd09     	lsr	x9, x8, #29
    2ecc: 4e071d20     	mov	v0.b[3], w9
    2ed0: d355fd09     	lsr	x9, x8, #21
    2ed4: 4e091d20     	mov	v0.b[4], w9
    2ed8: 93ca7509     	extr	x9, x8, x10, #0x1d
    2edc: 9e670124     	fmov	d4, x9
    2ee0: 90000009     	adrp	x9, 0x2000 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round+0x179c>
		0000000000002ee0:  R_AARCH64_ADR_PREL_PG_HI21	.rodata.cst16
    2ee4: 9e670183     	fmov	d3, x12
    2ee8: 3dc00125     	ldr	q5, [x9]
		0000000000002ee8:  R_AARCH64_LDST128_ABS_LO12_NC	.rodata.cst16
    2eec: d345fd09     	lsr	x9, x8, #5
    2ef0: 4e0b1d60     	mov	v0.b[5], w11
    2ef4: 9e6701c2     	fmov	d2, x14
    2ef8: 93caf508     	extr	x8, x8, x10, #0x3d
    2efc: 9e6701a1     	fmov	d1, x13
    2f00: 53057d4b     	lsr	w11, w10, #5
    2f04: 39033a8b     	strb	w11, [x20, #0xce]
    2f08: 4e056021     	tbl	v1.16b, { v1.16b, v2.16b, v3.16b, v4.16b }, v5.16b
    2f0c: 4e0d1d20     	mov	v0.b[6], w9
    2f10: 531d7149     	lsl	w9, w10, #3
    2f14: 39033e89     	strb	w9, [x20, #0xcf]
    2f18: 530d7d49     	lsr	w9, w10, #13
    2f1c: 53157d4a     	lsr	w10, w10, #21
    2f20: 0e212821     	xtn	v1.8b, v1.8h
    2f24: 4e0f1d00     	mov	v0.b[7], w8
    2f28: 39033689     	strb	w9, [x20, #0xcd]
    2f2c: 3903328a     	strb	w10, [x20, #0xcc]
    2f30: bd00ca81     	str	s1, [x20, #0xc8]
    2f34: fd006280     	str	d0, [x20, #0xc0]
    2f38: 94000017     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2f3c: f9400a88     	ldr	x8, [x20, #0x10]
    2f40: dac00d08     	rev	x8, x8
    2f44: f9000268     	str	x8, [x19]
    2f48: f9400e88     	ldr	x8, [x20, #0x18]
    2f4c: dac00d08     	rev	x8, x8
    2f50: f9000668     	str	x8, [x19, #0x8]
    2f54: f9401288     	ldr	x8, [x20, #0x20]
    2f58: dac00d08     	rev	x8, x8
    2f5c: f9000a68     	str	x8, [x19, #0x10]
    2f60: f9401688     	ldr	x8, [x20, #0x28]
    2f64: dac00d08     	rev	x8, x8
    2f68: f9000e68     	str	x8, [x19, #0x18]
    2f6c: f9401a88     	ldr	x8, [x20, #0x30]
    2f70: dac00d08     	rev	x8, x8
    2f74: f9001268     	str	x8, [x19, #0x20]
    2f78: f9401e88     	ldr	x8, [x20, #0x38]
    2f7c: dac00d08     	rev	x8, x8
    2f80: f9001668     	str	x8, [x19, #0x28]
    2f84: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    2f88: a94157f6     	ldp	x22, x21, [sp, #0x10]
    2f8c: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    2f90: d65f03c0     	ret

0000000000002f94 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    2f94: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
    2f98: f9000bf5     	str	x21, [sp, #0x10]
    2f9c: a9024ff4     	stp	x20, x19, [sp, #0x20]
    2fa0: 910003fd     	mov	x29, sp
    2fa4: d10a03ff     	sub	sp, sp, #0x280
    2fa8: ad400420     	ldp	q0, q1, [x1]
    2fac: 910003e8     	mov	x8, sp
    2fb0: ad410c22     	ldp	q2, q3, [x1, #0x20]
    2fb4: 91020108     	add	x8, x8, #0x80
    2fb8: ad421424     	ldp	q4, q5, [x1, #0x40]
    2fbc: 5280080a     	mov	w10, #0x40              // =64
    2fc0: 4e200800     	rev64	v0.16b, v0.16b
    2fc4: 4e200821     	rev64	v1.16b, v1.16b
    2fc8: 4e200842     	rev64	v2.16b, v2.16b
    2fcc: 4e200863     	rev64	v3.16b, v3.16b
    2fd0: 4e200884     	rev64	v4.16b, v4.16b
    2fd4: 4e2008a5     	rev64	v5.16b, v5.16b
    2fd8: ad0007e0     	stp	q0, q1, [sp]
    2fdc: ad430426     	ldp	q6, q1, [x1, #0x60]
    2fe0: 9e660009     	fmov	x9, d0
    2fe4: ad010fe2     	stp	q2, q3, [sp, #0x20]
    2fe8: ad0217e4     	stp	q4, q5, [sp, #0x40]
    2fec: 4e2008c6     	rev64	v6.16b, v6.16b
    2ff0: 4e200821     	rev64	v1.16b, v1.16b
    2ff4: aa0903eb     	mov	x11, x9
    2ff8: ad0307e6     	stp	q6, q1, [sp, #0x60]
<L0>:
    2ffc: f85c810c     	ldur	x12, [x8, #-0x38]
    3000: f85f010d     	ldur	x13, [x8, #-0x10]
    3004: f100054a     	subs	x10, x10, #0x1
    3008: 8b0b018c     	add	x12, x12, x11
    300c: f858810b     	ldur	x11, [x8, #-0x78]
    3010: 93cd4daf     	ror	x15, x13, #0x13
    3014: 93cb056e     	ror	x14, x11, #0x1
    3018: cacdf5ef     	eor	x15, x15, x13, ror #61
    301c: cacb21ce     	eor	x14, x14, x11, ror #8
    3020: ca4d19ed     	eor	x13, x15, x13, lsr #6
    3024: ca4b1dce     	eor	x14, x14, x11, lsr #7
    3028: 8b0e018c     	add	x12, x12, x14
    302c: 8b0d018c     	add	x12, x12, x13
    3030: f800850c     	str	x12, [x8], #0x8
    3034: 54fffe41     	b.ne	 <L0>
    3038: a943a812     	ldp	x18, x10, [x0, #0x38]
    303c: d29b7794     	mov	x20, #0xdbbc            // =56252
    3040: a942a00e     	ldp	x14, x8, [x0, #0x28]
    3044: f2b03134     	movk	x20, #0x8189, lsl #16
    3048: a9410c0d     	ldp	x13, x3, [x0, #0x10]
    304c: f2db74b4     	movk	x20, #0xdba5, lsl #32
    3050: f2fd36b4     	movk	x20, #0xe9b5, lsl #48
    3054: a9432c0f     	ldp	x15, x11, [x0, #0x30]
    3058: 8a28014c     	bic	x12, x10, x8
    305c: 8a080250     	and	x16, x18, x8
    3060: 93c83901     	ror	x1, x8, #0xe
    3064: aa0c0210     	orr	x16, x16, x12
    3068: a944440c     	ldp	x12, x17, [x0, #0x40]
    306c: cac84821     	eor	x1, x1, x8, ror #18
    3070: 8b090229     	add	x9, x17, x9
    3074: 93cd71b1     	ror	x17, x13, #0x1c
    3078: cac8a421     	eor	x1, x1, x8, ror #41
    307c: 8b100129     	add	x9, x9, x16
    3080: d295c450     	mov	x16, #0xae22            // =44578
    3084: f2bae510     	movk	x16, #0xd728, lsl #16
    3088: cacd8a31     	eor	x17, x17, x13, ror #34
    308c: f2c5f310     	movk	x16, #0x2f98, lsl #32
    3090: f2e85150     	movk	x16, #0x428a, lsl #48
    3094: cacd9e31     	eor	x17, x17, x13, ror #39
    3098: 8b100130     	add	x16, x9, x16
    309c: a9419009     	ldp	x9, x4, [x0, #0x18]
    30a0: 8b100021     	add	x1, x1, x16
    30a4: a9421810     	ldp	x16, x6, [x0, #0x20]
    30a8: aa030082     	orr	x2, x4, x3
    30ac: 8a030085     	and	x5, x4, x3
    30b0: 8a0d0042     	and	x2, x2, x13
    30b4: aa050045     	orr	x5, x2, x5
    30b8: 8b060022     	add	x2, x1, x6
    30bc: 8b1100b1     	add	x17, x5, x17
    30c0: f94007e5     	ldr	x5, [sp, #0x8]
    30c4: 8a220246     	bic	x6, x18, x2
    30c8: 8b010231     	add	x17, x17, x1
    30cc: 93c23841     	ror	x1, x2, #0xe
    30d0: 8a020107     	and	x7, x8, x2
    30d4: 8b05014a     	add	x10, x10, x5
    30d8: d28cb9a5     	mov	x5, #0x65cd             // =26061
    30dc: 93d17233     	ror	x19, x17, #0x1c
    30e0: f2a47de5     	movk	x5, #0x23ef, lsl #16
    30e4: cac24821     	eor	x1, x1, x2, ror #18
    30e8: aa0600e6     	orr	x6, x7, x6
    30ec: f2c89225     	movk	x5, #0x4491, lsl #32
    30f0: 8b06014a     	add	x10, x10, x6
    30f4: cad18a66     	eor	x6, x19, x17, ror #34
    30f8: f2ee26e5     	movk	x5, #0x7137, lsl #48
    30fc: cac2a421     	eor	x1, x1, x2, ror #41
    3100: 8a0d0067     	and	x7, x3, x13
    3104: 8b05014a     	add	x10, x10, x5
    3108: aa0d0065     	orr	x5, x3, x13
    310c: cad19cc6     	eor	x6, x6, x17, ror #39
    3110: 8a050225     	and	x5, x17, x5
    3114: 8b01014a     	add	x10, x10, x1
    3118: aa0700a5     	orr	x5, x5, x7
    311c: 8b040141     	add	x1, x10, x4
    3120: 8b0500c4     	add	x4, x6, x5
    3124: f9400be5     	ldr	x5, [sp, #0x10]
    3128: 8a210106     	bic	x6, x8, x1
    312c: 8b0a008a     	add	x10, x4, x10
    3130: 93c13824     	ror	x4, x1, #0xe
    3134: 8a010047     	and	x7, x2, x1
    3138: 8b050252     	add	x18, x18, x5
    313c: d28765e5     	mov	x5, #0x3b2f             // =15151
    3140: 93ca7153     	ror	x19, x10, #0x1c
    3144: f2bd89a5     	movk	x5, #0xec4d, lsl #16
    3148: cac14884     	eor	x4, x4, x1, ror #18
    314c: aa0600e6     	orr	x6, x7, x6
    3150: f2df79e5     	movk	x5, #0xfbcf, lsl #32
    3154: 8b060252     	add	x18, x18, x6
    3158: caca8a66     	eor	x6, x19, x10, ror #34
    315c: f2f6b805     	movk	x5, #0xb5c0, lsl #48
    3160: cac1a484     	eor	x4, x4, x1, ror #41
    3164: 8a0d0227     	and	x7, x17, x13
    3168: 8b050252     	add	x18, x18, x5
    316c: aa0d0225     	orr	x5, x17, x13
    3170: caca9cc6     	eor	x6, x6, x10, ror #39
    3174: 8a050145     	and	x5, x10, x5
    3178: 8b040252     	add	x18, x18, x4
    317c: aa0700a4     	orr	x4, x5, x7
    3180: 8b030243     	add	x3, x18, x3
    3184: 8b0400c4     	add	x4, x6, x4
    3188: a9419be5     	ldp	x5, x6, [sp, #0x18]
    318c: 8b120092     	add	x18, x4, x18
    3190: 93c33864     	ror	x4, x3, #0xe
    3194: 8a030033     	and	x19, x1, x3
    3198: 93d27247     	ror	x7, x18, #0x1c
    319c: aa0a0255     	orr	x21, x18, x10
    31a0: 8b050108     	add	x8, x8, x5
    31a4: 8a230045     	bic	x5, x2, x3
    31a8: cac34884     	eor	x4, x4, x3, ror #18
    31ac: cad288e7     	eor	x7, x7, x18, ror #34
    31b0: aa050265     	orr	x5, x19, x5
    31b4: aa110153     	orr	x19, x10, x17
    31b8: 8b050108     	add	x8, x8, x5
    31bc: cac3a484     	eor	x4, x4, x3, ror #41
    31c0: 8a130245     	and	x5, x18, x19
    31c4: cad29ce7     	eor	x7, x7, x18, ror #39
    31c8: 8a110153     	and	x19, x10, x17
    31cc: 8b140108     	add	x8, x8, x20
    31d0: aa1300a5     	orr	x5, x5, x19
    31d4: 8b040108     	add	x8, x8, x4
    31d8: 8b0200c2     	add	x2, x6, x2
    31dc: 8b0500e5     	add	x5, x7, x5
    31e0: 8b0d0104     	add	x4, x8, x13
    31e4: d296a707     	mov	x7, #0xb538             // =46392
    31e8: 8b0800a8     	add	x8, x5, x8
    31ec: 93c43885     	ror	x5, x4, #0xe
    31f0: f2be6907     	movk	x7, #0xf348, lsl #16
    31f4: 93c87106     	ror	x6, x8, #0x1c
    31f8: 8a240033     	bic	x19, x1, x4
    31fc: 8a040074     	and	x20, x3, x4
    3200: cac448a5     	eor	x5, x5, x4, ror #18
    3204: f2d84b67     	movk	x7, #0xc25b, lsl #32
    3208: aa130293     	orr	x19, x20, x19
    320c: cac888c6     	eor	x6, x6, x8, ror #34
    3210: f2e72ac7     	movk	x7, #0x3956, lsl #48
    3214: 8a0a0254     	and	x20, x18, x10
    3218: 8b130042     	add	x2, x2, x19
    321c: cac4a4a5     	eor	x5, x5, x4, ror #41
    3220: 8a150113     	and	x19, x8, x21
    3224: cac89cc6     	eor	x6, x6, x8, ror #39
    3228: 8b070042     	add	x2, x2, x7
    322c: aa140267     	orr	x7, x19, x20
    3230: 8b050045     	add	x5, x2, x5
    3234: d29a0333     	mov	x19, #0xd019            // =53273
    3238: 8b0700c6     	add	x6, x6, x7
    323c: 8b1100a2     	add	x2, x5, x17
    3240: f2b6c0b3     	movk	x19, #0xb605, lsl #16
    3244: 8b0500d1     	add	x17, x6, x5
    3248: a9429be7     	ldp	x7, x6, [sp, #0x28]
    324c: 93c23845     	ror	x5, x2, #0xe
    3250: 8a220074     	bic	x20, x3, x2
    3254: 8a020095     	and	x21, x4, x2
    3258: f2c23e33     	movk	x19, #0x11f1, lsl #32
    325c: aa1402b4     	orr	x20, x21, x20
    3260: aa120115     	orr	x21, x8, x18
    3264: 8b0100e1     	add	x1, x7, x1
    3268: 93d17227     	ror	x7, x17, #0x1c
    326c: cac248a5     	eor	x5, x5, x2, ror #18
    3270: f2eb3e33     	movk	x19, #0x59f1, lsl #48
    3274: 8b140021     	add	x1, x1, x20
    3278: 8a120114     	and	x20, x8, x18
    327c: cad188e7     	eor	x7, x7, x17, ror #34
    3280: cac2a4a5     	eor	x5, x5, x2, ror #41
    3284: 8a150235     	and	x21, x17, x21
    3288: 8b130021     	add	x1, x1, x19
    328c: aa1402b3     	orr	x19, x21, x20
    3290: 8b0300c3     	add	x3, x6, x3
    3294: cad19ce7     	eor	x7, x7, x17, ror #39
    3298: 8b050025     	add	x5, x1, x5
    329c: aa080235     	orr	x21, x17, x8
    32a0: 8b0a00a1     	add	x1, x5, x10
    32a4: 8b1300e7     	add	x7, x7, x19
    32a8: 8a210093     	bic	x19, x4, x1
    32ac: 8a010054     	and	x20, x2, x1
    32b0: 8b0500ea     	add	x10, x7, x5
    32b4: 93c13825     	ror	x5, x1, #0xe
    32b8: d289f367     	mov	x7, #0x4f9b             // =20379
    32bc: 93ca7146     	ror	x6, x10, #0x1c
    32c0: f2b5e327     	movk	x7, #0xaf19, lsl #16
    32c4: aa130293     	orr	x19, x20, x19
    32c8: cac148a5     	eor	x5, x5, x1, ror #18
    32cc: f2d05487     	movk	x7, #0x82a4, lsl #32
    32d0: 8a080234     	and	x20, x17, x8
    32d4: caca88c6     	eor	x6, x6, x10, ror #34
    32d8: f2f247e7     	movk	x7, #0x923f, lsl #48
    32dc: 8b130063     	add	x3, x3, x19
    32e0: cac1a4a5     	eor	x5, x5, x1, ror #41
    32e4: 8a150153     	and	x19, x10, x21
    32e8: 8b070063     	add	x3, x3, x7
    32ec: caca9cc6     	eor	x6, x6, x10, ror #39
    32f0: aa140267     	orr	x7, x19, x20
    32f4: d2902313     	mov	x19, #0x8118            // =33048
    32f8: 8b050065     	add	x5, x3, x5
    32fc: f2bb4db3     	movk	x19, #0xda6d, lsl #16
    3300: 8b0700c6     	add	x6, x6, x7
    3304: 8b1200a3     	add	x3, x5, x18
    3308: f2cbdab3     	movk	x19, #0x5ed5, lsl #32
    330c: 8b0500d2     	add	x18, x6, x5
    3310: a9439be7     	ldp	x7, x6, [sp, #0x38]
    3314: 93c33865     	ror	x5, x3, #0xe
    3318: 8a230054     	bic	x20, x2, x3
    331c: 8a030035     	and	x21, x1, x3
    3320: aa1402b4     	orr	x20, x21, x20
    3324: aa110155     	orr	x21, x10, x17
    3328: f2f56393     	movk	x19, #0xab1c, lsl #48
    332c: 8b0400e4     	add	x4, x7, x4
    3330: 93d27247     	ror	x7, x18, #0x1c
    3334: cac348a5     	eor	x5, x5, x3, ror #18
    3338: 8b140084     	add	x4, x4, x20
    333c: 8a110154     	and	x20, x10, x17
    3340: 8a150255     	and	x21, x18, x21
    3344: cad288e7     	eor	x7, x7, x18, ror #34
    3348: cac3a4a5     	eor	x5, x5, x3, ror #41
    334c: 8b130084     	add	x4, x4, x19
    3350: aa1402b3     	orr	x19, x21, x20
    3354: 8b0200c2     	add	x2, x6, x2
    3358: aa0a0255     	orr	x21, x18, x10
    335c: cad29ce7     	eor	x7, x7, x18, ror #39
    3360: 8b050085     	add	x5, x4, x5
    3364: 8b0800a4     	add	x4, x5, x8
    3368: 8b1300e7     	add	x7, x7, x19
    336c: 8a240033     	bic	x19, x1, x4
    3370: 8a040074     	and	x20, x3, x4
    3374: 8b0500e8     	add	x8, x7, x5
    3378: 93c43885     	ror	x5, x4, #0xe
    337c: d2804847     	mov	x7, #0x242              // =578
    3380: 93c87106     	ror	x6, x8, #0x1c
    3384: f2b46067     	movk	x7, #0xa303, lsl #16
    3388: aa130293     	orr	x19, x20, x19
    338c: cac448a5     	eor	x5, x5, x4, ror #18
    3390: f2d55307     	movk	x7, #0xaa98, lsl #32
    3394: 8a0a0254     	and	x20, x18, x10
    3398: cac888c6     	eor	x6, x6, x8, ror #34
    339c: f2fb00e7     	movk	x7, #0xd807, lsl #48
    33a0: 8b130042     	add	x2, x2, x19
    33a4: cac4a4a5     	eor	x5, x5, x4, ror #41
    33a8: 8a150113     	and	x19, x8, x21
    33ac: 8b070042     	add	x2, x2, x7
    33b0: cac89cc6     	eor	x6, x6, x8, ror #39
    33b4: aa140267     	orr	x7, x19, x20
    33b8: d28df7d3     	mov	x19, #0x6fbe            // =28606
    33bc: 8b050045     	add	x5, x2, x5
    33c0: f2a8ae13     	movk	x19, #0x4570, lsl #16
    33c4: 8b0700c6     	add	x6, x6, x7
    33c8: 8b1100a2     	add	x2, x5, x17
    33cc: f2cb6033     	movk	x19, #0x5b01, lsl #32
    33d0: 8b0500d1     	add	x17, x6, x5
    33d4: a9449be7     	ldp	x7, x6, [sp, #0x48]
    33d8: 93c23845     	ror	x5, x2, #0xe
    33dc: 8a220074     	bic	x20, x3, x2
    33e0: 8a020095     	and	x21, x4, x2
    33e4: aa1402b4     	orr	x20, x21, x20
    33e8: aa120115     	orr	x21, x8, x18
    33ec: f2e25073     	movk	x19, #0x1283, lsl #48
    33f0: 8b0100e1     	add	x1, x7, x1
    33f4: 93d17227     	ror	x7, x17, #0x1c
    33f8: cac248a5     	eor	x5, x5, x2, ror #18
    33fc: 8b140021     	add	x1, x1, x20
    3400: 8a120114     	and	x20, x8, x18
    3404: 8a150235     	and	x21, x17, x21
    3408: cad188e7     	eor	x7, x7, x17, ror #34
    340c: cac2a4a5     	eor	x5, x5, x2, ror #41
    3410: 8b130021     	add	x1, x1, x19
    3414: aa1402b3     	orr	x19, x21, x20
    3418: 8b0300c3     	add	x3, x6, x3
    341c: aa080235     	orr	x21, x17, x8
    3420: cad19ce7     	eor	x7, x7, x17, ror #39
    3424: 8b050025     	add	x5, x1, x5
    3428: 8b0a00a1     	add	x1, x5, x10
    342c: 8b1300e7     	add	x7, x7, x19
    3430: 8a210093     	bic	x19, x4, x1
    3434: 8a010054     	and	x20, x2, x1
    3438: 8b0500ea     	add	x10, x7, x5
    343c: 93c13825     	ror	x5, x1, #0xe
    3440: d2965187     	mov	x7, #0xb28c             // =45708
    3444: 93ca7146     	ror	x6, x10, #0x1c
    3448: f2a9dc87     	movk	x7, #0x4ee4, lsl #16
    344c: aa130293     	orr	x19, x20, x19
    3450: cac148a5     	eor	x5, x5, x1, ror #18
    3454: f2d0b7c7     	movk	x7, #0x85be, lsl #32
    3458: 8a080234     	and	x20, x17, x8
    345c: caca88c6     	eor	x6, x6, x10, ror #34
    3460: f2e48627     	movk	x7, #0x2431, lsl #48
    3464: 8b130063     	add	x3, x3, x19
    3468: cac1a4a5     	eor	x5, x5, x1, ror #41
    346c: 8a150153     	and	x19, x10, x21
    3470: 8b070063     	add	x3, x3, x7
    3474: caca9cc6     	eor	x6, x6, x10, ror #39
    3478: aa140267     	orr	x7, x19, x20
    347c: d2969c53     	mov	x19, #0xb4e2            // =46306
    3480: 8b050065     	add	x5, x3, x5
    3484: f2babff3     	movk	x19, #0xd5ff, lsl #16
    3488: 8b0700c6     	add	x6, x6, x7
    348c: 8b1200a3     	add	x3, x5, x18
    3490: f2cfb873     	movk	x19, #0x7dc3, lsl #32
    3494: 8b0500d2     	add	x18, x6, x5
    3498: a9459be7     	ldp	x7, x6, [sp, #0x58]
    349c: 93c33865     	ror	x5, x3, #0xe
    34a0: 8a230054     	bic	x20, x2, x3
    34a4: 8a030035     	and	x21, x1, x3
    34a8: aa1402b4     	orr	x20, x21, x20
    34ac: aa110155     	orr	x21, x10, x17
    34b0: f2eaa193     	movk	x19, #0x550c, lsl #48
    34b4: 8b0400e4     	add	x4, x7, x4
    34b8: 93d27247     	ror	x7, x18, #0x1c
    34bc: cac348a5     	eor	x5, x5, x3, ror #18
    34c0: 8b140084     	add	x4, x4, x20
    34c4: 8a110154     	and	x20, x10, x17
    34c8: 8a150255     	and	x21, x18, x21
    34cc: cad288e7     	eor	x7, x7, x18, ror #34
    34d0: cac3a4a5     	eor	x5, x5, x3, ror #41
    34d4: 8b130084     	add	x4, x4, x19
    34d8: aa1402b3     	orr	x19, x21, x20
    34dc: 8b0200c2     	add	x2, x6, x2
    34e0: aa0a0255     	orr	x21, x18, x10
    34e4: cad29ce7     	eor	x7, x7, x18, ror #39
    34e8: 8b050085     	add	x5, x4, x5
    34ec: 8b0800a4     	add	x4, x5, x8
    34f0: 8b1300e7     	add	x7, x7, x19
    34f4: 8a240033     	bic	x19, x1, x4
    34f8: 8a040074     	and	x20, x3, x4
    34fc: 8b0500e8     	add	x8, x7, x5
    3500: 93c43885     	ror	x5, x4, #0xe
    3504: d2912de7     	mov	x7, #0x896f             // =35183
    3508: 93c87106     	ror	x6, x8, #0x1c
    350c: f2be4f67     	movk	x7, #0xf27b, lsl #16
    3510: aa130293     	orr	x19, x20, x19
    3514: cac448a5     	eor	x5, x5, x4, ror #18
    3518: f2cbae87     	movk	x7, #0x5d74, lsl #32
    351c: 8a0a0254     	and	x20, x18, x10
    3520: cac888c6     	eor	x6, x6, x8, ror #34
    3524: f2ee57c7     	movk	x7, #0x72be, lsl #48
    3528: 8b130042     	add	x2, x2, x19
    352c: cac4a4a5     	eor	x5, x5, x4, ror #41
    3530: 8a150113     	and	x19, x8, x21
    3534: 8b070042     	add	x2, x2, x7
    3538: cac89cc6     	eor	x6, x6, x8, ror #39
    353c: aa140267     	orr	x7, x19, x20
    3540: d292d633     	mov	x19, #0x96b1            // =38577
    3544: 8b050045     	add	x5, x2, x5
    3548: f2a762d3     	movk	x19, #0x3b16, lsl #16
    354c: 8b0700c6     	add	x6, x6, x7
    3550: 8b1100a2     	add	x2, x5, x17
    3554: f2d63fd3     	movk	x19, #0xb1fe, lsl #32
    3558: 8b0500d1     	add	x17, x6, x5
    355c: a9469be7     	ldp	x7, x6, [sp, #0x68]
    3560: 93c23845     	ror	x5, x2, #0xe
    3564: 8a220074     	bic	x20, x3, x2
    3568: 8a020095     	and	x21, x4, x2
    356c: aa1402b4     	orr	x20, x21, x20
    3570: aa120115     	orr	x21, x8, x18
    3574: f2f01bd3     	movk	x19, #0x80de, lsl #48
    3578: 8b0100e1     	add	x1, x7, x1
    357c: 93d17227     	ror	x7, x17, #0x1c
    3580: cac248a5     	eor	x5, x5, x2, ror #18
    3584: 8b140021     	add	x1, x1, x20
    3588: 8a120114     	and	x20, x8, x18
    358c: 8a150235     	and	x21, x17, x21
    3590: cad188e7     	eor	x7, x7, x17, ror #34
    3594: cac2a4a5     	eor	x5, x5, x2, ror #41
    3598: 8b130021     	add	x1, x1, x19
    359c: aa1402b3     	orr	x19, x21, x20
    35a0: 8b0300c3     	add	x3, x6, x3
    35a4: aa080235     	orr	x21, x17, x8
    35a8: cad19ce7     	eor	x7, x7, x17, ror #39
    35ac: 8b050025     	add	x5, x1, x5
    35b0: 8b0a00a1     	add	x1, x5, x10
    35b4: 8b1300e7     	add	x7, x7, x19
    35b8: 8a210093     	bic	x19, x4, x1
    35bc: 8a010054     	and	x20, x2, x1
    35c0: 8b0500ea     	add	x10, x7, x5
    35c4: 93c13825     	ror	x5, x1, #0xe
    35c8: d28246a7     	mov	x7, #0x1235             // =4661
    35cc: 93ca7146     	ror	x6, x10, #0x1c
    35d0: f2a4b8e7     	movk	x7, #0x25c7, lsl #16
    35d4: aa130293     	orr	x19, x20, x19
    35d8: cac148a5     	eor	x5, x5, x1, ror #18
    35dc: f2c0d4e7     	movk	x7, #0x6a7, lsl #32
    35e0: 8a080234     	and	x20, x17, x8
    35e4: caca88c6     	eor	x6, x6, x10, ror #34
    35e8: f2f37b87     	movk	x7, #0x9bdc, lsl #48
    35ec: 8b130063     	add	x3, x3, x19
    35f0: cac1a4a5     	eor	x5, x5, x1, ror #41
    35f4: 8a150153     	and	x19, x10, x21
    35f8: 8b070063     	add	x3, x3, x7
    35fc: caca9cc6     	eor	x6, x6, x10, ror #39
    3600: aa140267     	orr	x7, x19, x20
    3604: d284d293     	mov	x19, #0x2694            // =9876
    3608: 8b050065     	add	x5, x3, x5
    360c: f2b9ed33     	movk	x19, #0xcf69, lsl #16
    3610: 8b0700c6     	add	x6, x6, x7
    3614: 8b1200a3     	add	x3, x5, x18
    3618: f2de2e93     	movk	x19, #0xf174, lsl #32
    361c: 8b0500d2     	add	x18, x6, x5
    3620: a9479be7     	ldp	x7, x6, [sp, #0x78]
    3624: 93c33865     	ror	x5, x3, #0xe
    3628: 8a230054     	bic	x20, x2, x3
    362c: 8a030035     	and	x21, x1, x3
    3630: aa1402b4     	orr	x20, x21, x20
    3634: aa110155     	orr	x21, x10, x17
    3638: f2f83373     	movk	x19, #0xc19b, lsl #48
    363c: 8b0400e4     	add	x4, x7, x4
    3640: 93d27247     	ror	x7, x18, #0x1c
    3644: cac348a5     	eor	x5, x5, x3, ror #18
    3648: 8b140084     	add	x4, x4, x20
    364c: 8a110154     	and	x20, x10, x17
    3650: 8a150255     	and	x21, x18, x21
    3654: cad288e7     	eor	x7, x7, x18, ror #34
    3658: cac3a4a5     	eor	x5, x5, x3, ror #41
    365c: 8b130084     	add	x4, x4, x19
    3660: aa1402b3     	orr	x19, x21, x20
    3664: 8b0200c2     	add	x2, x6, x2
    3668: aa0a0255     	orr	x21, x18, x10
    366c: cad29ce7     	eor	x7, x7, x18, ror #39
    3670: 8b050085     	add	x5, x4, x5
    3674: 8b0800a4     	add	x4, x5, x8
    3678: 8b1300e7     	add	x7, x7, x19
    367c: 8a240033     	bic	x19, x1, x4
    3680: 8a040074     	and	x20, x3, x4
    3684: 8b0500e8     	add	x8, x7, x5
    3688: 93c43885     	ror	x5, x4, #0xe
    368c: d2895a47     	mov	x7, #0x4ad2             // =19154
    3690: 93c87106     	ror	x6, x8, #0x1c
    3694: f2b3de27     	movk	x7, #0x9ef1, lsl #16
    3698: aa130293     	orr	x19, x20, x19
    369c: cac448a5     	eor	x5, x5, x4, ror #18
    36a0: f2cd3827     	movk	x7, #0x69c1, lsl #32
    36a4: 8a0a0254     	and	x20, x18, x10
    36a8: cac888c6     	eor	x6, x6, x8, ror #34
    36ac: f2fc9367     	movk	x7, #0xe49b, lsl #48
    36b0: 8b130042     	add	x2, x2, x19
    36b4: cac4a4a5     	eor	x5, x5, x4, ror #41
    36b8: 8a150113     	and	x19, x8, x21
    36bc: 8b070042     	add	x2, x2, x7
    36c0: cac89cc6     	eor	x6, x6, x8, ror #39
    36c4: aa140267     	orr	x7, x19, x20
    36c8: d284bc73     	mov	x19, #0x25e3            // =9699
    36cc: 8b050045     	add	x5, x2, x5
    36d0: f2a709f3     	movk	x19, #0x384f, lsl #16
    36d4: 8b0700c6     	add	x6, x6, x7
    36d8: 8b1100a2     	add	x2, x5, x17
    36dc: f2c8f0d3     	movk	x19, #0x4786, lsl #32
    36e0: 8b0500d1     	add	x17, x6, x5
    36e4: a9489be7     	ldp	x7, x6, [sp, #0x88]
    36e8: 93c23845     	ror	x5, x2, #0xe
    36ec: 8a220074     	bic	x20, x3, x2
    36f0: 8a020095     	and	x21, x4, x2
    36f4: aa1402b4     	orr	x20, x21, x20
    36f8: aa120115     	orr	x21, x8, x18
    36fc: f2fdf7d3     	movk	x19, #0xefbe, lsl #48
    3700: 8b0100e1     	add	x1, x7, x1
    3704: 93d17227     	ror	x7, x17, #0x1c
    3708: cac248a5     	eor	x5, x5, x2, ror #18
    370c: 8b140021     	add	x1, x1, x20
    3710: 8a120114     	and	x20, x8, x18
    3714: 8a150235     	and	x21, x17, x21
    3718: cad188e7     	eor	x7, x7, x17, ror #34
    371c: cac2a4a5     	eor	x5, x5, x2, ror #41
    3720: 8b130021     	add	x1, x1, x19
    3724: aa1402b3     	orr	x19, x21, x20
    3728: 8b0300c3     	add	x3, x6, x3
    372c: aa080235     	orr	x21, x17, x8
    3730: cad19ce7     	eor	x7, x7, x17, ror #39
    3734: 8b050025     	add	x5, x1, x5
    3738: 8b0a00a1     	add	x1, x5, x10
    373c: 8b1300e7     	add	x7, x7, x19
    3740: 8a210093     	bic	x19, x4, x1
    3744: 8a010054     	and	x20, x2, x1
    3748: 8b0500ea     	add	x10, x7, x5
    374c: 93c13825     	ror	x5, x1, #0xe
    3750: d29ab6a7     	mov	x7, #0xd5b5             // =54709
    3754: 93ca7146     	ror	x6, x10, #0x1c
    3758: f2b17187     	movk	x7, #0x8b8c, lsl #16
    375c: aa130293     	orr	x19, x20, x19
    3760: cac148a5     	eor	x5, x5, x1, ror #18
    3764: f2d3b8c7     	movk	x7, #0x9dc6, lsl #32
    3768: 8a080234     	and	x20, x17, x8
    376c: caca88c6     	eor	x6, x6, x10, ror #34
    3770: f2e1f827     	movk	x7, #0xfc1, lsl #48
    3774: 8b130063     	add	x3, x3, x19
    3778: cac1a4a5     	eor	x5, x5, x1, ror #41
    377c: 8a150153     	and	x19, x10, x21
    3780: 8b070063     	add	x3, x3, x7
    3784: caca9cc6     	eor	x6, x6, x10, ror #39
    3788: aa140267     	orr	x7, x19, x20
    378c: d2938cb3     	mov	x19, #0x9c65            // =40037
    3790: 8b050065     	add	x5, x3, x5
    3794: f2aef593     	movk	x19, #0x77ac, lsl #16
    3798: 8b0700c6     	add	x6, x6, x7
    379c: 8b1200a3     	add	x3, x5, x18
    37a0: f2d43993     	movk	x19, #0xa1cc, lsl #32
    37a4: 8b0500d2     	add	x18, x6, x5
    37a8: a9499be7     	ldp	x7, x6, [sp, #0x98]
    37ac: 93c33865     	ror	x5, x3, #0xe
    37b0: 8a230054     	bic	x20, x2, x3
    37b4: 8a030035     	and	x21, x1, x3
    37b8: aa1402b4     	orr	x20, x21, x20
    37bc: aa110155     	orr	x21, x10, x17
    37c0: f2e48193     	movk	x19, #0x240c, lsl #48
    37c4: 8b0400e4     	add	x4, x7, x4
    37c8: 93d27247     	ror	x7, x18, #0x1c
    37cc: cac348a5     	eor	x5, x5, x3, ror #18
    37d0: 8b140084     	add	x4, x4, x20
    37d4: 8a110154     	and	x20, x10, x17
    37d8: 8a150255     	and	x21, x18, x21
    37dc: cad288e7     	eor	x7, x7, x18, ror #34
    37e0: cac3a4a5     	eor	x5, x5, x3, ror #41
    37e4: 8b130084     	add	x4, x4, x19
    37e8: aa1402b3     	orr	x19, x21, x20
    37ec: 8b0200c2     	add	x2, x6, x2
    37f0: aa0a0255     	orr	x21, x18, x10
    37f4: cad29ce7     	eor	x7, x7, x18, ror #39
    37f8: 8b050085     	add	x5, x4, x5
    37fc: 8b0800a4     	add	x4, x5, x8
    3800: 8b1300e7     	add	x7, x7, x19
    3804: 8a240033     	bic	x19, x1, x4
    3808: 8a040074     	and	x20, x3, x4
    380c: 8b0500e8     	add	x8, x7, x5
    3810: 93c43885     	ror	x5, x4, #0xe
    3814: d2804ea7     	mov	x7, #0x275              // =629
    3818: 93c87106     	ror	x6, x8, #0x1c
    381c: f2ab2567     	movk	x7, #0x592b, lsl #16
    3820: aa130293     	orr	x19, x20, x19
    3824: cac448a5     	eor	x5, x5, x4, ror #18
    3828: f2c58de7     	movk	x7, #0x2c6f, lsl #32
    382c: 8a0a0254     	and	x20, x18, x10
    3830: cac888c6     	eor	x6, x6, x8, ror #34
    3834: f2e5bd27     	movk	x7, #0x2de9, lsl #48
    3838: 8b130042     	add	x2, x2, x19
    383c: cac4a4a5     	eor	x5, x5, x4, ror #41
    3840: 8a150113     	and	x19, x8, x21
    3844: 8b070042     	add	x2, x2, x7
    3848: cac89cc6     	eor	x6, x6, x8, ror #39
    384c: aa140267     	orr	x7, x19, x20
    3850: d29c9073     	mov	x19, #0xe483            // =58499
    3854: 8b050045     	add	x5, x2, x5
    3858: f2add4d3     	movk	x19, #0x6ea6, lsl #16
    385c: 8b0700c6     	add	x6, x6, x7
    3860: 8b1100a2     	add	x2, x5, x17
    3864: f2d09553     	movk	x19, #0x84aa, lsl #32
    3868: 8b0500d1     	add	x17, x6, x5
    386c: a94a9be7     	ldp	x7, x6, [sp, #0xa8]
    3870: 93c23845     	ror	x5, x2, #0xe
    3874: 8a220074     	bic	x20, x3, x2
    3878: 8a020095     	and	x21, x4, x2
    387c: aa1402b4     	orr	x20, x21, x20
    3880: aa120115     	orr	x21, x8, x18
    3884: f2e94e93     	movk	x19, #0x4a74, lsl #48
    3888: 8b0100e1     	add	x1, x7, x1
    388c: 93d17227     	ror	x7, x17, #0x1c
    3890: cac248a5     	eor	x5, x5, x2, ror #18
    3894: 8b140021     	add	x1, x1, x20
    3898: 8a120114     	and	x20, x8, x18
    389c: 8a150235     	and	x21, x17, x21
    38a0: cad188e7     	eor	x7, x7, x17, ror #34
    38a4: cac2a4a5     	eor	x5, x5, x2, ror #41
    38a8: 8b130021     	add	x1, x1, x19
    38ac: aa1402b3     	orr	x19, x21, x20
    38b0: 8b0300c3     	add	x3, x6, x3
    38b4: aa080235     	orr	x21, x17, x8
    38b8: cad19ce7     	eor	x7, x7, x17, ror #39
    38bc: 8b050025     	add	x5, x1, x5
    38c0: 8b0a00a1     	add	x1, x5, x10
    38c4: 8b1300e7     	add	x7, x7, x19
    38c8: 8a210093     	bic	x19, x4, x1
    38cc: 8a010054     	and	x20, x2, x1
    38d0: 8b0500ea     	add	x10, x7, x5
    38d4: 93c13825     	ror	x5, x1, #0xe
    38d8: d29f7a87     	mov	x7, #0xfbd4             // =64468
    38dc: 93ca7146     	ror	x6, x10, #0x1c
    38e0: f2b7a827     	movk	x7, #0xbd41, lsl #16
    38e4: aa130293     	orr	x19, x20, x19
    38e8: cac148a5     	eor	x5, x5, x1, ror #18
    38ec: f2d53b87     	movk	x7, #0xa9dc, lsl #32
    38f0: 8a080234     	and	x20, x17, x8
    38f4: caca88c6     	eor	x6, x6, x10, ror #34
    38f8: f2eb9607     	movk	x7, #0x5cb0, lsl #48
    38fc: 8b130063     	add	x3, x3, x19
    3900: cac1a4a5     	eor	x5, x5, x1, ror #41
    3904: 8a150153     	and	x19, x10, x21
    3908: 8b070063     	add	x3, x3, x7
    390c: caca9cc6     	eor	x6, x6, x10, ror #39
    3910: aa140267     	orr	x7, x19, x20
    3914: d28a76b3     	mov	x19, #0x53b5            // =21429
    3918: 8b050065     	add	x5, x3, x5
    391c: f2b06233     	movk	x19, #0x8311, lsl #16
    3920: 8b0700c6     	add	x6, x6, x7
    3924: 8b1200a3     	add	x3, x5, x18
    3928: f2d11b53     	movk	x19, #0x88da, lsl #32
    392c: 8b0500d2     	add	x18, x6, x5
    3930: a94b9be7     	ldp	x7, x6, [sp, #0xb8]
    3934: 93c33865     	ror	x5, x3, #0xe
    3938: 8a230054     	bic	x20, x2, x3
    393c: 8a030035     	and	x21, x1, x3
    3940: aa1402b4     	orr	x20, x21, x20
    3944: aa110155     	orr	x21, x10, x17
    3948: f2eedf33     	movk	x19, #0x76f9, lsl #48
    394c: 8b0400e4     	add	x4, x7, x4
    3950: 93d27247     	ror	x7, x18, #0x1c
    3954: cac348a5     	eor	x5, x5, x3, ror #18
    3958: 8b140084     	add	x4, x4, x20
    395c: 8a110154     	and	x20, x10, x17
    3960: 8a150255     	and	x21, x18, x21
    3964: cad288e7     	eor	x7, x7, x18, ror #34
    3968: cac3a4a5     	eor	x5, x5, x3, ror #41
    396c: 8b130084     	add	x4, x4, x19
    3970: aa1402b3     	orr	x19, x21, x20
    3974: 8b0200c2     	add	x2, x6, x2
    3978: aa0a0255     	orr	x21, x18, x10
    397c: cad29ce7     	eor	x7, x7, x18, ror #39
    3980: 8b050085     	add	x5, x4, x5
    3984: 8b0800a4     	add	x4, x5, x8
    3988: 8b1300e7     	add	x7, x7, x19
    398c: 8a240033     	bic	x19, x1, x4
    3990: 8a040074     	and	x20, x3, x4
    3994: 8b0500e8     	add	x8, x7, x5
    3998: 93c43885     	ror	x5, x4, #0xe
    399c: d29bf567     	mov	x7, #0xdfab             // =57259
    39a0: 93c87106     	ror	x6, x8, #0x1c
    39a4: f2bdccc7     	movk	x7, #0xee66, lsl #16
    39a8: aa130293     	orr	x19, x20, x19
    39ac: cac448a5     	eor	x5, x5, x4, ror #18
    39b0: f2ca2a47     	movk	x7, #0x5152, lsl #32
    39b4: 8a0a0254     	and	x20, x18, x10
    39b8: cac888c6     	eor	x6, x6, x8, ror #34
    39bc: f2f307c7     	movk	x7, #0x983e, lsl #48
    39c0: 8b130042     	add	x2, x2, x19
    39c4: cac4a4a5     	eor	x5, x5, x4, ror #41
    39c8: 8a150113     	and	x19, x8, x21
    39cc: 8b070042     	add	x2, x2, x7
    39d0: cac89cc6     	eor	x6, x6, x8, ror #39
    39d4: aa140267     	orr	x7, x19, x20
    39d8: d2864213     	mov	x19, #0x3210            // =12816
    39dc: 8b050045     	add	x5, x2, x5
    39e0: f2a5b693     	movk	x19, #0x2db4, lsl #16
    39e4: 8b0700c6     	add	x6, x6, x7
    39e8: 8b1100a2     	add	x2, x5, x17
    39ec: f2d8cdb3     	movk	x19, #0xc66d, lsl #32
    39f0: 8b0500d1     	add	x17, x6, x5
    39f4: a94c9be7     	ldp	x7, x6, [sp, #0xc8]
    39f8: 93c23845     	ror	x5, x2, #0xe
    39fc: 8a220074     	bic	x20, x3, x2
    3a00: 8a020095     	and	x21, x4, x2
    3a04: aa1402b4     	orr	x20, x21, x20
    3a08: aa120115     	orr	x21, x8, x18
    3a0c: f2f50633     	movk	x19, #0xa831, lsl #48
    3a10: 8b0100e1     	add	x1, x7, x1
    3a14: 93d17227     	ror	x7, x17, #0x1c
    3a18: cac248a5     	eor	x5, x5, x2, ror #18
    3a1c: 8b140021     	add	x1, x1, x20
    3a20: 8a120114     	and	x20, x8, x18
    3a24: 8a150235     	and	x21, x17, x21
    3a28: cad188e7     	eor	x7, x7, x17, ror #34
    3a2c: cac2a4a5     	eor	x5, x5, x2, ror #41
    3a30: 8b130021     	add	x1, x1, x19
    3a34: aa1402b3     	orr	x19, x21, x20
    3a38: 8b0300c3     	add	x3, x6, x3
    3a3c: aa080235     	orr	x21, x17, x8
    3a40: cad19ce7     	eor	x7, x7, x17, ror #39
    3a44: 8b050025     	add	x5, x1, x5
    3a48: 8b0a00a1     	add	x1, x5, x10
    3a4c: 8b1300e7     	add	x7, x7, x19
    3a50: 8a210093     	bic	x19, x4, x1
    3a54: 8a010054     	and	x20, x2, x1
    3a58: 8b0500ea     	add	x10, x7, x5
    3a5c: 93c13825     	ror	x5, x1, #0xe
    3a60: d28427e7     	mov	x7, #0x213f             // =8511
    3a64: 93ca7146     	ror	x6, x10, #0x1c
    3a68: f2b31f67     	movk	x7, #0x98fb, lsl #16
    3a6c: aa130293     	orr	x19, x20, x19
    3a70: cac148a5     	eor	x5, x5, x1, ror #18
    3a74: f2c4f907     	movk	x7, #0x27c8, lsl #32
    3a78: 8a080234     	and	x20, x17, x8
    3a7c: caca88c6     	eor	x6, x6, x10, ror #34
    3a80: f2f60067     	movk	x7, #0xb003, lsl #48
    3a84: 8b130063     	add	x3, x3, x19
    3a88: cac1a4a5     	eor	x5, x5, x1, ror #41
    3a8c: 8a150153     	and	x19, x10, x21
    3a90: 8b070063     	add	x3, x3, x7
    3a94: caca9cc6     	eor	x6, x6, x10, ror #39
    3a98: aa140267     	orr	x7, x19, x20
    3a9c: d281dc93     	mov	x19, #0xee4             // =3812
    3aa0: 8b050065     	add	x5, x3, x5
    3aa4: f2b7ddf3     	movk	x19, #0xbeef, lsl #16
    3aa8: 8b0700c6     	add	x6, x6, x7
    3aac: 8b1200a3     	add	x3, x5, x18
    3ab0: f2cff8f3     	movk	x19, #0x7fc7, lsl #32
    3ab4: 8b0500d2     	add	x18, x6, x5
    3ab8: a94d9be7     	ldp	x7, x6, [sp, #0xd8]
    3abc: 93c33865     	ror	x5, x3, #0xe
    3ac0: 8a230054     	bic	x20, x2, x3
    3ac4: 8a030035     	and	x21, x1, x3
    3ac8: aa1402b4     	orr	x20, x21, x20
    3acc: aa110155     	orr	x21, x10, x17
    3ad0: f2f7eb33     	movk	x19, #0xbf59, lsl #48
    3ad4: 8b0400e4     	add	x4, x7, x4
    3ad8: 93d27247     	ror	x7, x18, #0x1c
    3adc: cac348a5     	eor	x5, x5, x3, ror #18
    3ae0: 8b140084     	add	x4, x4, x20
    3ae4: 8a110154     	and	x20, x10, x17
    3ae8: 8a150255     	and	x21, x18, x21
    3aec: cad288e7     	eor	x7, x7, x18, ror #34
    3af0: cac3a4a5     	eor	x5, x5, x3, ror #41
    3af4: 8b130084     	add	x4, x4, x19
    3af8: aa1402b3     	orr	x19, x21, x20
    3afc: 8b0200c2     	add	x2, x6, x2
    3b00: aa0a0255     	orr	x21, x18, x10
    3b04: cad29ce7     	eor	x7, x7, x18, ror #39
    3b08: 8b050085     	add	x5, x4, x5
    3b0c: 8b0800a4     	add	x4, x5, x8
    3b10: 8b1300e7     	add	x7, x7, x19
    3b14: 8a240033     	bic	x19, x1, x4
    3b18: 8a040074     	and	x20, x3, x4
    3b1c: 8b0500e8     	add	x8, x7, x5
    3b20: 93c43885     	ror	x5, x4, #0xe
    3b24: d291f847     	mov	x7, #0x8fc2             // =36802
    3b28: 93c87106     	ror	x6, x8, #0x1c
    3b2c: f2a7b507     	movk	x7, #0x3da8, lsl #16
    3b30: aa130293     	orr	x19, x20, x19
    3b34: cac448a5     	eor	x5, x5, x4, ror #18
    3b38: f2c17e67     	movk	x7, #0xbf3, lsl #32
    3b3c: 8a0a0254     	and	x20, x18, x10
    3b40: cac888c6     	eor	x6, x6, x8, ror #34
    3b44: f2f8dc07     	movk	x7, #0xc6e0, lsl #48
    3b48: 8b130042     	add	x2, x2, x19
    3b4c: cac4a4a5     	eor	x5, x5, x4, ror #41
    3b50: 8a150113     	and	x19, x8, x21
    3b54: 8b070042     	add	x2, x2, x7
    3b58: cac89cc6     	eor	x6, x6, x8, ror #39
    3b5c: aa140267     	orr	x7, x19, x20
    3b60: d294e4b3     	mov	x19, #0xa725            // =42789
    3b64: 8b050045     	add	x5, x2, x5
    3b68: f2b26153     	movk	x19, #0x930a, lsl #16
    3b6c: 8b0700c6     	add	x6, x6, x7
    3b70: 8b1100a2     	add	x2, x5, x17
    3b74: f2d228f3     	movk	x19, #0x9147, lsl #32
    3b78: 8b0500d1     	add	x17, x6, x5
    3b7c: a94e9be7     	ldp	x7, x6, [sp, #0xe8]
    3b80: 93c23845     	ror	x5, x2, #0xe
    3b84: 8a220074     	bic	x20, x3, x2
    3b88: 8a020095     	and	x21, x4, x2
    3b8c: aa1402b4     	orr	x20, x21, x20
    3b90: aa120115     	orr	x21, x8, x18
    3b94: f2fab4f3     	movk	x19, #0xd5a7, lsl #48
    3b98: 8b0100e1     	add	x1, x7, x1
    3b9c: 93d17227     	ror	x7, x17, #0x1c
    3ba0: cac248a5     	eor	x5, x5, x2, ror #18
    3ba4: 8b140021     	add	x1, x1, x20
    3ba8: 8a120114     	and	x20, x8, x18
    3bac: 8a150235     	and	x21, x17, x21
    3bb0: cad188e7     	eor	x7, x7, x17, ror #34
    3bb4: cac2a4a5     	eor	x5, x5, x2, ror #41
    3bb8: 8b130021     	add	x1, x1, x19
    3bbc: aa1402b3     	orr	x19, x21, x20
    3bc0: 8b0300c3     	add	x3, x6, x3
    3bc4: aa080235     	orr	x21, x17, x8
    3bc8: cad19ce7     	eor	x7, x7, x17, ror #39
    3bcc: 8b050025     	add	x5, x1, x5
    3bd0: 8b0a00a1     	add	x1, x5, x10
    3bd4: 8b1300e7     	add	x7, x7, x19
    3bd8: 8a210093     	bic	x19, x4, x1
    3bdc: 8a010054     	and	x20, x2, x1
    3be0: 8b0500ea     	add	x10, x7, x5
    3be4: 93c13825     	ror	x5, x1, #0xe
    3be8: d2904de7     	mov	x7, #0x826f             // =33391
    3bec: 93ca7146     	ror	x6, x10, #0x1c
    3bf0: f2bc0067     	movk	x7, #0xe003, lsl #16
    3bf4: aa130293     	orr	x19, x20, x19
    3bf8: cac148a5     	eor	x5, x5, x1, ror #18
    3bfc: f2cc6a27     	movk	x7, #0x6351, lsl #32
    3c00: 8a080234     	and	x20, x17, x8
    3c04: caca88c6     	eor	x6, x6, x10, ror #34
    3c08: f2e0d947     	movk	x7, #0x6ca, lsl #48
    3c0c: 8b130063     	add	x3, x3, x19
    3c10: cac1a4a5     	eor	x5, x5, x1, ror #41
    3c14: 8a150153     	and	x19, x10, x21
    3c18: 8b070063     	add	x3, x3, x7
    3c1c: caca9cc6     	eor	x6, x6, x10, ror #39
    3c20: aa140267     	orr	x7, x19, x20
    3c24: d28dce13     	mov	x19, #0x6e70            // =28272
    3c28: 8b050065     	add	x5, x3, x5
    3c2c: f2a141d3     	movk	x19, #0xa0e, lsl #16
    3c30: 8b0700c6     	add	x6, x6, x7
    3c34: 8b1200a3     	add	x3, x5, x18
    3c38: f2c52cf3     	movk	x19, #0x2967, lsl #32
    3c3c: 8b0500d2     	add	x18, x6, x5
    3c40: a94f9be7     	ldp	x7, x6, [sp, #0xf8]
    3c44: 93c33865     	ror	x5, x3, #0xe
    3c48: 8a230054     	bic	x20, x2, x3
    3c4c: 8a030035     	and	x21, x1, x3
    3c50: aa1402b4     	orr	x20, x21, x20
    3c54: aa110155     	orr	x21, x10, x17
    3c58: f2e28533     	movk	x19, #0x1429, lsl #48
    3c5c: 8b0400e4     	add	x4, x7, x4
    3c60: 93d27247     	ror	x7, x18, #0x1c
    3c64: cac348a5     	eor	x5, x5, x3, ror #18
    3c68: 8b140084     	add	x4, x4, x20
    3c6c: 8a110154     	and	x20, x10, x17
    3c70: 8a150255     	and	x21, x18, x21
    3c74: cad288e7     	eor	x7, x7, x18, ror #34
    3c78: cac3a4a5     	eor	x5, x5, x3, ror #41
    3c7c: 8b130084     	add	x4, x4, x19
    3c80: aa1402b3     	orr	x19, x21, x20
    3c84: 8b0200c2     	add	x2, x6, x2
    3c88: aa0a0255     	orr	x21, x18, x10
    3c8c: cad29ce7     	eor	x7, x7, x18, ror #39
    3c90: 8b050085     	add	x5, x4, x5
    3c94: 8b0800a4     	add	x4, x5, x8
    3c98: 8b1300e7     	add	x7, x7, x19
    3c9c: 8a240033     	bic	x19, x1, x4
    3ca0: 8a040074     	and	x20, x3, x4
    3ca4: 8b0500e8     	add	x8, x7, x5
    3ca8: 93c43885     	ror	x5, x4, #0xe
    3cac: d285ff87     	mov	x7, #0x2ffc             // =12284
    3cb0: 93c87106     	ror	x6, x8, #0x1c
    3cb4: f2a8da47     	movk	x7, #0x46d2, lsl #16
    3cb8: aa130293     	orr	x19, x20, x19
    3cbc: cac448a5     	eor	x5, x5, x4, ror #18
    3cc0: f2c150a7     	movk	x7, #0xa85, lsl #32
    3cc4: 8a0a0254     	and	x20, x18, x10
    3cc8: cac888c6     	eor	x6, x6, x8, ror #34
    3ccc: f2e4f6e7     	movk	x7, #0x27b7, lsl #48
    3cd0: 8b130042     	add	x2, x2, x19
    3cd4: cac4a4a5     	eor	x5, x5, x4, ror #41
    3cd8: 8a150113     	and	x19, x8, x21
    3cdc: 8b070042     	add	x2, x2, x7
    3ce0: cac89cc6     	eor	x6, x6, x8, ror #39
    3ce4: aa140267     	orr	x7, x19, x20
    3ce8: d29924d3     	mov	x19, #0xc926            // =51494
    3cec: 8b050045     	add	x5, x2, x5
    3cf0: f2ab84d3     	movk	x19, #0x5c26, lsl #16
    3cf4: 8b0700c6     	add	x6, x6, x7
    3cf8: 8b1100a2     	add	x2, x5, x17
    3cfc: f2c42713     	movk	x19, #0x2138, lsl #32
    3d00: 8b0500d1     	add	x17, x6, x5
    3d04: a9509be7     	ldp	x7, x6, [sp, #0x108]
    3d08: 93c23845     	ror	x5, x2, #0xe
    3d0c: 8a220074     	bic	x20, x3, x2
    3d10: 8a020095     	and	x21, x4, x2
    3d14: aa1402b4     	orr	x20, x21, x20
    3d18: aa120115     	orr	x21, x8, x18
    3d1c: f2e5c373     	movk	x19, #0x2e1b, lsl #48
    3d20: 8b0100e1     	add	x1, x7, x1
    3d24: 93d17227     	ror	x7, x17, #0x1c
    3d28: cac248a5     	eor	x5, x5, x2, ror #18
    3d2c: 8b140021     	add	x1, x1, x20
    3d30: 8a120114     	and	x20, x8, x18
    3d34: 8a150235     	and	x21, x17, x21
    3d38: cad188e7     	eor	x7, x7, x17, ror #34
    3d3c: cac2a4a5     	eor	x5, x5, x2, ror #41
    3d40: 8b130021     	add	x1, x1, x19
    3d44: aa1402b3     	orr	x19, x21, x20
    3d48: 8b0300c3     	add	x3, x6, x3
    3d4c: aa080235     	orr	x21, x17, x8
    3d50: cad19ce7     	eor	x7, x7, x17, ror #39
    3d54: 8b050025     	add	x5, x1, x5
    3d58: 8b0a00a1     	add	x1, x5, x10
    3d5c: 8b1300e7     	add	x7, x7, x19
    3d60: 8a210093     	bic	x19, x4, x1
    3d64: 8a010054     	and	x20, x2, x1
    3d68: 8b0500ea     	add	x10, x7, x5
    3d6c: 93c13825     	ror	x5, x1, #0xe
    3d70: d2855da7     	mov	x7, #0x2aed             // =10989
    3d74: 93ca7146     	ror	x6, x10, #0x1c
    3d78: f2ab5887     	movk	x7, #0x5ac4, lsl #16
    3d7c: aa130293     	orr	x19, x20, x19
    3d80: cac148a5     	eor	x5, x5, x1, ror #18
    3d84: f2cdbf87     	movk	x7, #0x6dfc, lsl #32
    3d88: 8a080234     	and	x20, x17, x8
    3d8c: caca88c6     	eor	x6, x6, x10, ror #34
    3d90: f2e9a587     	movk	x7, #0x4d2c, lsl #48
    3d94: 8b130063     	add	x3, x3, x19
    3d98: cac1a4a5     	eor	x5, x5, x1, ror #41
    3d9c: 8a150153     	and	x19, x10, x21
    3da0: 8b070063     	add	x3, x3, x7
    3da4: caca9cc6     	eor	x6, x6, x10, ror #39
    3da8: aa140267     	orr	x7, x19, x20
    3dac: d2967bf3     	mov	x19, #0xb3df            // =46047
    3db0: 8b050065     	add	x5, x3, x5
    3db4: f2b3b2b3     	movk	x19, #0x9d95, lsl #16
    3db8: 8b0700c6     	add	x6, x6, x7
    3dbc: 8b1200a3     	add	x3, x5, x18
    3dc0: f2c1a273     	movk	x19, #0xd13, lsl #32
    3dc4: 8b0500d2     	add	x18, x6, x5
    3dc8: a9519be7     	ldp	x7, x6, [sp, #0x118]
    3dcc: 93c33865     	ror	x5, x3, #0xe
    3dd0: 8a230054     	bic	x20, x2, x3
    3dd4: 8a030035     	and	x21, x1, x3
    3dd8: aa1402b4     	orr	x20, x21, x20
    3ddc: aa110155     	orr	x21, x10, x17
    3de0: f2ea6713     	movk	x19, #0x5338, lsl #48
    3de4: 8b0400e4     	add	x4, x7, x4
    3de8: 93d27247     	ror	x7, x18, #0x1c
    3dec: cac348a5     	eor	x5, x5, x3, ror #18
    3df0: 8b140084     	add	x4, x4, x20
    3df4: 8a110154     	and	x20, x10, x17
    3df8: 8a150255     	and	x21, x18, x21
    3dfc: cad288e7     	eor	x7, x7, x18, ror #34
    3e00: cac3a4a5     	eor	x5, x5, x3, ror #41
    3e04: 8b130084     	add	x4, x4, x19
    3e08: aa1402b3     	orr	x19, x21, x20
    3e0c: 8b0200c2     	add	x2, x6, x2
    3e10: aa0a0255     	orr	x21, x18, x10
    3e14: cad29ce7     	eor	x7, x7, x18, ror #39
    3e18: 8b050085     	add	x5, x4, x5
    3e1c: 8b0800a4     	add	x4, x5, x8
    3e20: 8b1300e7     	add	x7, x7, x19
    3e24: 8a240033     	bic	x19, x1, x4
    3e28: 8a040074     	and	x20, x3, x4
    3e2c: 8b0500e8     	add	x8, x7, x5
    3e30: 93c43885     	ror	x5, x4, #0xe
    3e34: d28c7bc7     	mov	x7, #0x63de             // =25566
    3e38: 93c87106     	ror	x6, x8, #0x1c
    3e3c: f2b175e7     	movk	x7, #0x8baf, lsl #16
    3e40: aa130293     	orr	x19, x20, x19
    3e44: cac448a5     	eor	x5, x5, x4, ror #18
    3e48: f2ce6a87     	movk	x7, #0x7354, lsl #32
    3e4c: 8a0a0254     	and	x20, x18, x10
    3e50: cac888c6     	eor	x6, x6, x8, ror #34
    3e54: f2eca147     	movk	x7, #0x650a, lsl #48
    3e58: 8b130042     	add	x2, x2, x19
    3e5c: cac4a4a5     	eor	x5, x5, x4, ror #41
    3e60: 8a150113     	and	x19, x8, x21
    3e64: 8b070042     	add	x2, x2, x7
    3e68: cac89cc6     	eor	x6, x6, x8, ror #39
    3e6c: aa140267     	orr	x7, x19, x20
    3e70: d2965513     	mov	x19, #0xb2a8            // =45736
    3e74: 8b050045     	add	x5, x2, x5
    3e78: f2a78ef3     	movk	x19, #0x3c77, lsl #16
    3e7c: 8b0700c6     	add	x6, x6, x7
    3e80: 8b1100a2     	add	x2, x5, x17
    3e84: f2c15773     	movk	x19, #0xabb, lsl #32
    3e88: 8b0500d1     	add	x17, x6, x5
    3e8c: a9529be7     	ldp	x7, x6, [sp, #0x128]
    3e90: 93c23845     	ror	x5, x2, #0xe
    3e94: 8a220074     	bic	x20, x3, x2
    3e98: 8a020095     	and	x21, x4, x2
    3e9c: aa1402b4     	orr	x20, x21, x20
    3ea0: aa120115     	orr	x21, x8, x18
    3ea4: f2eecd53     	movk	x19, #0x766a, lsl #48
    3ea8: 8b0100e1     	add	x1, x7, x1
    3eac: 93d17227     	ror	x7, x17, #0x1c
    3eb0: cac248a5     	eor	x5, x5, x2, ror #18
    3eb4: 8b140021     	add	x1, x1, x20
    3eb8: 8a120114     	and	x20, x8, x18
    3ebc: 8a150235     	and	x21, x17, x21
    3ec0: cad188e7     	eor	x7, x7, x17, ror #34
    3ec4: cac2a4a5     	eor	x5, x5, x2, ror #41
    3ec8: 8b130021     	add	x1, x1, x19
    3ecc: aa1402b3     	orr	x19, x21, x20
    3ed0: 8b0300c3     	add	x3, x6, x3
    3ed4: aa080235     	orr	x21, x17, x8
    3ed8: cad19ce7     	eor	x7, x7, x17, ror #39
    3edc: 8b050025     	add	x5, x1, x5
    3ee0: 8b0a00a1     	add	x1, x5, x10
    3ee4: 8b1300e7     	add	x7, x7, x19
    3ee8: 8a210093     	bic	x19, x4, x1
    3eec: 8a010054     	and	x20, x2, x1
    3ef0: 8b0500ea     	add	x10, x7, x5
    3ef4: 93c13825     	ror	x5, x1, #0xe
    3ef8: d295dcc7     	mov	x7, #0xaee6             // =44774
    3efc: 93ca7146     	ror	x6, x10, #0x1c
    3f00: f2a8fda7     	movk	x7, #0x47ed, lsl #16
    3f04: aa130293     	orr	x19, x20, x19
    3f08: cac148a5     	eor	x5, x5, x1, ror #18
    3f0c: f2d925c7     	movk	x7, #0xc92e, lsl #32
    3f10: 8a080234     	and	x20, x17, x8
    3f14: caca88c6     	eor	x6, x6, x10, ror #34
    3f18: f2f03847     	movk	x7, #0x81c2, lsl #48
    3f1c: 8b130063     	add	x3, x3, x19
    3f20: cac1a4a5     	eor	x5, x5, x1, ror #41
    3f24: 8a150153     	and	x19, x10, x21
    3f28: 8b070063     	add	x3, x3, x7
    3f2c: caca9cc6     	eor	x6, x6, x10, ror #39
    3f30: aa140267     	orr	x7, x19, x20
    3f34: d286a773     	mov	x19, #0x353b            // =13627
    3f38: 8b050065     	add	x5, x3, x5
    3f3c: f2a29053     	movk	x19, #0x1482, lsl #16
    3f40: 8b0700c6     	add	x6, x6, x7
    3f44: 8b1200a3     	add	x3, x5, x18
    3f48: f2c590b3     	movk	x19, #0x2c85, lsl #32
    3f4c: 8b0500d2     	add	x18, x6, x5
    3f50: a9539be7     	ldp	x7, x6, [sp, #0x138]
    3f54: 93c33865     	ror	x5, x3, #0xe
    3f58: 8a230054     	bic	x20, x2, x3
    3f5c: 8a030035     	and	x21, x1, x3
    3f60: aa1402b4     	orr	x20, x21, x20
    3f64: aa110155     	orr	x21, x10, x17
    3f68: f2f24e53     	movk	x19, #0x9272, lsl #48
    3f6c: 8b0400e4     	add	x4, x7, x4
    3f70: 93d27247     	ror	x7, x18, #0x1c
    3f74: cac348a5     	eor	x5, x5, x3, ror #18
    3f78: 8b140084     	add	x4, x4, x20
    3f7c: 8a110154     	and	x20, x10, x17
    3f80: 8a150255     	and	x21, x18, x21
    3f84: cad288e7     	eor	x7, x7, x18, ror #34
    3f88: cac3a4a5     	eor	x5, x5, x3, ror #41
    3f8c: 8b130084     	add	x4, x4, x19
    3f90: aa1402b3     	orr	x19, x21, x20
    3f94: 8b0200c2     	add	x2, x6, x2
    3f98: aa0a0255     	orr	x21, x18, x10
    3f9c: cad29ce7     	eor	x7, x7, x18, ror #39
    3fa0: 8b050085     	add	x5, x4, x5
    3fa4: 8b0800a4     	add	x4, x5, x8
    3fa8: 8b1300e7     	add	x7, x7, x19
    3fac: 8a240033     	bic	x19, x1, x4
    3fb0: 8a040074     	and	x20, x3, x4
    3fb4: 8b0500e8     	add	x8, x7, x5
    3fb8: 93c43885     	ror	x5, x4, #0xe
    3fbc: d2806c87     	mov	x7, #0x364              // =868
    3fc0: 93c87106     	ror	x6, x8, #0x1c
    3fc4: f2a99e27     	movk	x7, #0x4cf1, lsl #16
    3fc8: aa130293     	orr	x19, x20, x19
    3fcc: cac448a5     	eor	x5, x5, x4, ror #18
    3fd0: f2dd1427     	movk	x7, #0xe8a1, lsl #32
    3fd4: 8a0a0254     	and	x20, x18, x10
    3fd8: cac888c6     	eor	x6, x6, x8, ror #34
    3fdc: f2f457e7     	movk	x7, #0xa2bf, lsl #48
    3fe0: 8b130042     	add	x2, x2, x19
    3fe4: cac4a4a5     	eor	x5, x5, x4, ror #41
    3fe8: 8a150113     	and	x19, x8, x21
    3fec: 8b070042     	add	x2, x2, x7
    3ff0: cac89cc6     	eor	x6, x6, x8, ror #39
    3ff4: aa140267     	orr	x7, x19, x20
    3ff8: d2860033     	mov	x19, #0x3001            // =12289
    3ffc: 8b050045     	add	x5, x2, x5
    4000: f2b78853     	movk	x19, #0xbc42, lsl #16
    4004: 8b0700c6     	add	x6, x6, x7
    4008: 8b1100a2     	add	x2, x5, x17
    400c: f2ccc973     	movk	x19, #0x664b, lsl #32
    4010: 8b0500d1     	add	x17, x6, x5
    4014: a9549be7     	ldp	x7, x6, [sp, #0x148]
    4018: 93c23845     	ror	x5, x2, #0xe
    401c: 8a220074     	bic	x20, x3, x2
    4020: 8a020095     	and	x21, x4, x2
    4024: aa1402b4     	orr	x20, x21, x20
    4028: aa120115     	orr	x21, x8, x18
    402c: f2f50353     	movk	x19, #0xa81a, lsl #48
    4030: 8b0100e1     	add	x1, x7, x1
    4034: 93d17227     	ror	x7, x17, #0x1c
    4038: cac248a5     	eor	x5, x5, x2, ror #18
    403c: 8b140021     	add	x1, x1, x20
    4040: 8a120114     	and	x20, x8, x18
    4044: 8a150235     	and	x21, x17, x21
    4048: cad188e7     	eor	x7, x7, x17, ror #34
    404c: cac2a4a5     	eor	x5, x5, x2, ror #41
    4050: 8b130021     	add	x1, x1, x19
    4054: aa1402b3     	orr	x19, x21, x20
    4058: 8b0300c3     	add	x3, x6, x3
    405c: aa080235     	orr	x21, x17, x8
    4060: cad19ce7     	eor	x7, x7, x17, ror #39
    4064: 8b050025     	add	x5, x1, x5
    4068: 8b0a00a1     	add	x1, x5, x10
    406c: 8b1300e7     	add	x7, x7, x19
    4070: 8a210093     	bic	x19, x4, x1
    4074: 8a010054     	and	x20, x2, x1
    4078: 8b0500ea     	add	x10, x7, x5
    407c: 93c13825     	ror	x5, x1, #0xe
    4080: d292f227     	mov	x7, #0x9791             // =38801
    4084: 93ca7146     	ror	x6, x10, #0x1c
    4088: f2ba1f07     	movk	x7, #0xd0f8, lsl #16
    408c: aa130293     	orr	x19, x20, x19
    4090: cac148a5     	eor	x5, x5, x1, ror #18
    4094: f2d16e07     	movk	x7, #0x8b70, lsl #32
    4098: 8a080234     	and	x20, x17, x8
    409c: caca88c6     	eor	x6, x6, x10, ror #34
    40a0: f2f84967     	movk	x7, #0xc24b, lsl #48
    40a4: 8b130063     	add	x3, x3, x19
    40a8: cac1a4a5     	eor	x5, x5, x1, ror #41
    40ac: 8a150153     	and	x19, x10, x21
    40b0: 8b070063     	add	x3, x3, x7
    40b4: caca9cc6     	eor	x6, x6, x10, ror #39
    40b8: aa140267     	orr	x7, x19, x20
    40bc: d297c613     	mov	x19, #0xbe30            // =48688
    40c0: 8b050065     	add	x5, x3, x5
    40c4: f2a0ca93     	movk	x19, #0x654, lsl #16
    40c8: 8b0700c6     	add	x6, x6, x7
    40cc: 8b1200a3     	add	x3, x5, x18
    40d0: f2ca3473     	movk	x19, #0x51a3, lsl #32
    40d4: 8b0500d2     	add	x18, x6, x5
    40d8: a9559be7     	ldp	x7, x6, [sp, #0x158]
    40dc: 93c33865     	ror	x5, x3, #0xe
    40e0: 8a230054     	bic	x20, x2, x3
    40e4: 8a030035     	and	x21, x1, x3
    40e8: aa1402b4     	orr	x20, x21, x20
    40ec: aa110155     	orr	x21, x10, x17
    40f0: f2f8ed93     	movk	x19, #0xc76c, lsl #48
    40f4: 8b0400e4     	add	x4, x7, x4
    40f8: 93d27247     	ror	x7, x18, #0x1c
    40fc: cac348a5     	eor	x5, x5, x3, ror #18
    4100: 8b140084     	add	x4, x4, x20
    4104: 8a110154     	and	x20, x10, x17
    4108: 8a150255     	and	x21, x18, x21
    410c: cad288e7     	eor	x7, x7, x18, ror #34
    4110: cac3a4a5     	eor	x5, x5, x3, ror #41
    4114: 8b130084     	add	x4, x4, x19
    4118: aa1402b3     	orr	x19, x21, x20
    411c: 8b0200c2     	add	x2, x6, x2
    4120: aa0a0255     	orr	x21, x18, x10
    4124: cad29ce7     	eor	x7, x7, x18, ror #39
    4128: 8b050085     	add	x5, x4, x5
    412c: 8b0800a4     	add	x4, x5, x8
    4130: 8b1300e7     	add	x7, x7, x19
    4134: 8a240033     	bic	x19, x1, x4
    4138: 8a040074     	and	x20, x3, x4
    413c: 8b0500e8     	add	x8, x7, x5
    4140: 93c43885     	ror	x5, x4, #0xe
    4144: d28a4307     	mov	x7, #0x5218             // =21016
    4148: 93c87106     	ror	x6, x8, #0x1c
    414c: f2badde7     	movk	x7, #0xd6ef, lsl #16
    4150: aa130293     	orr	x19, x20, x19
    4154: cac448a5     	eor	x5, x5, x4, ror #18
    4158: f2dd0327     	movk	x7, #0xe819, lsl #32
    415c: 8a0a0254     	and	x20, x18, x10
    4160: cac888c6     	eor	x6, x6, x8, ror #34
    4164: f2fa3247     	movk	x7, #0xd192, lsl #48
    4168: 8b130042     	add	x2, x2, x19
    416c: cac4a4a5     	eor	x5, x5, x4, ror #41
    4170: 8a150113     	and	x19, x8, x21
    4174: 8b070042     	add	x2, x2, x7
    4178: cac89cc6     	eor	x6, x6, x8, ror #39
    417c: aa140267     	orr	x7, x19, x20
    4180: d2952213     	mov	x19, #0xa910            // =43280
    4184: 8b050045     	add	x5, x2, x5
    4188: f2aaacb3     	movk	x19, #0x5565, lsl #16
    418c: 8b0700c6     	add	x6, x6, x7
    4190: 8b1100a2     	add	x2, x5, x17
    4194: f2c0c493     	movk	x19, #0x624, lsl #32
    4198: 8b0500d1     	add	x17, x6, x5
    419c: a9569be7     	ldp	x7, x6, [sp, #0x168]
    41a0: 93c23845     	ror	x5, x2, #0xe
    41a4: 8a220074     	bic	x20, x3, x2
    41a8: 8a020095     	and	x21, x4, x2
    41ac: aa1402b4     	orr	x20, x21, x20
    41b0: aa120115     	orr	x21, x8, x18
    41b4: f2fad333     	movk	x19, #0xd699, lsl #48
    41b8: 8b0100e1     	add	x1, x7, x1
    41bc: 93d17227     	ror	x7, x17, #0x1c
    41c0: cac248a5     	eor	x5, x5, x2, ror #18
    41c4: 8b140021     	add	x1, x1, x20
    41c8: 8a120114     	and	x20, x8, x18
    41cc: 8a150235     	and	x21, x17, x21
    41d0: cad188e7     	eor	x7, x7, x17, ror #34
    41d4: cac2a4a5     	eor	x5, x5, x2, ror #41
    41d8: 8b130021     	add	x1, x1, x19
    41dc: aa1402b3     	orr	x19, x21, x20
    41e0: 8b0300c3     	add	x3, x6, x3
    41e4: aa080235     	orr	x21, x17, x8
    41e8: cad19ce7     	eor	x7, x7, x17, ror #39
    41ec: 8b050025     	add	x5, x1, x5
    41f0: 8b0a00a1     	add	x1, x5, x10
    41f4: 8b1300e7     	add	x7, x7, x19
    41f8: 8a210093     	bic	x19, x4, x1
    41fc: 8a010054     	and	x20, x2, x1
    4200: 8b0500ea     	add	x10, x7, x5
    4204: 93c13825     	ror	x5, x1, #0xe
    4208: d2840547     	mov	x7, #0x202a             // =8234
    420c: 93ca7146     	ror	x6, x10, #0x1c
    4210: f2aaee27     	movk	x7, #0x5771, lsl #16
    4214: aa130293     	orr	x19, x20, x19
    4218: cac148a5     	eor	x5, x5, x1, ror #18
    421c: f2c6b0a7     	movk	x7, #0x3585, lsl #32
    4220: 8a080234     	and	x20, x17, x8
    4224: caca88c6     	eor	x6, x6, x10, ror #34
    4228: f2fe81c7     	movk	x7, #0xf40e, lsl #48
    422c: 8b130063     	add	x3, x3, x19
    4230: cac1a4a5     	eor	x5, x5, x1, ror #41
    4234: 8a150153     	and	x19, x10, x21
    4238: 8b070063     	add	x3, x3, x7
    423c: caca9cc6     	eor	x6, x6, x10, ror #39
    4240: aa140267     	orr	x7, x19, x20
    4244: d29a3713     	mov	x19, #0xd1b8            // =53688
    4248: 8b050065     	add	x5, x3, x5
    424c: f2a65773     	movk	x19, #0x32bb, lsl #16
    4250: 8b0700c6     	add	x6, x6, x7
    4254: 8b1200a3     	add	x3, x5, x18
    4258: f2d40e13     	movk	x19, #0xa070, lsl #32
    425c: 8b0500d2     	add	x18, x6, x5
    4260: a9579be7     	ldp	x7, x6, [sp, #0x178]
    4264: 93c33865     	ror	x5, x3, #0xe
    4268: 8a230054     	bic	x20, x2, x3
    426c: 8a030035     	and	x21, x1, x3
    4270: aa1402b4     	orr	x20, x21, x20
    4274: aa110155     	orr	x21, x10, x17
    4278: f2e20d53     	movk	x19, #0x106a, lsl #48
    427c: 8b0400e4     	add	x4, x7, x4
    4280: 93d27247     	ror	x7, x18, #0x1c
    4284: cac348a5     	eor	x5, x5, x3, ror #18
    4288: 8b140084     	add	x4, x4, x20
    428c: 8a110154     	and	x20, x10, x17
    4290: 8a150255     	and	x21, x18, x21
    4294: cad288e7     	eor	x7, x7, x18, ror #34
    4298: cac3a4a5     	eor	x5, x5, x3, ror #41
    429c: 8b130084     	add	x4, x4, x19
    42a0: aa1402b3     	orr	x19, x21, x20
    42a4: 8b0200c2     	add	x2, x6, x2
    42a8: aa0a0255     	orr	x21, x18, x10
    42ac: cad29ce7     	eor	x7, x7, x18, ror #39
    42b0: 8b050085     	add	x5, x4, x5
    42b4: 8b0800a4     	add	x4, x5, x8
    42b8: 8b1300e7     	add	x7, x7, x19
    42bc: 8a240033     	bic	x19, x1, x4
    42c0: 8a040074     	and	x20, x3, x4
    42c4: 8b0500e8     	add	x8, x7, x5
    42c8: 93c43885     	ror	x5, x4, #0xe
    42cc: d29a1907     	mov	x7, #0xd0c8             // =53448
    42d0: 93c87106     	ror	x6, x8, #0x1c
    42d4: f2b71a47     	movk	x7, #0xb8d2, lsl #16
    42d8: aa130293     	orr	x19, x20, x19
    42dc: cac448a5     	eor	x5, x5, x4, ror #18
    42e0: f2d822c7     	movk	x7, #0xc116, lsl #32
    42e4: 8a0a0254     	and	x20, x18, x10
    42e8: cac888c6     	eor	x6, x6, x8, ror #34
    42ec: f2e33487     	movk	x7, #0x19a4, lsl #48
    42f0: 8b130042     	add	x2, x2, x19
    42f4: cac4a4a5     	eor	x5, x5, x4, ror #41
    42f8: 8a150113     	and	x19, x8, x21
    42fc: 8b070042     	add	x2, x2, x7
    4300: cac89cc6     	eor	x6, x6, x8, ror #39
    4304: aa140267     	orr	x7, x19, x20
    4308: d2956a73     	mov	x19, #0xab53            // =43859
    430c: 8b050045     	add	x5, x2, x5
    4310: f2aa2833     	movk	x19, #0x5141, lsl #16
    4314: 8b0700c6     	add	x6, x6, x7
    4318: 8b1100a2     	add	x2, x5, x17
    431c: f2cd8113     	movk	x19, #0x6c08, lsl #32
    4320: 8b0500d1     	add	x17, x6, x5
    4324: a9589be7     	ldp	x7, x6, [sp, #0x188]
    4328: 93c23845     	ror	x5, x2, #0xe
    432c: 8a220074     	bic	x20, x3, x2
    4330: 8a020095     	and	x21, x4, x2
    4334: aa1402b4     	orr	x20, x21, x20
    4338: aa120115     	orr	x21, x8, x18
    433c: f2e3c6f3     	movk	x19, #0x1e37, lsl #48
    4340: 8b0100e1     	add	x1, x7, x1
    4344: 93d17227     	ror	x7, x17, #0x1c
    4348: cac248a5     	eor	x5, x5, x2, ror #18
    434c: 8b140021     	add	x1, x1, x20
    4350: 8a120114     	and	x20, x8, x18
    4354: 8a150235     	and	x21, x17, x21
    4358: cad188e7     	eor	x7, x7, x17, ror #34
    435c: cac2a4a5     	eor	x5, x5, x2, ror #41
    4360: 8b130021     	add	x1, x1, x19
    4364: aa1402b3     	orr	x19, x21, x20
    4368: 8b0300c3     	add	x3, x6, x3
    436c: aa080235     	orr	x21, x17, x8
    4370: cad19ce7     	eor	x7, x7, x17, ror #39
    4374: 8b050025     	add	x5, x1, x5
    4378: 8b0a00a1     	add	x1, x5, x10
    437c: 8b1300e7     	add	x7, x7, x19
    4380: 8a210093     	bic	x19, x4, x1
    4384: 8a010054     	and	x20, x2, x1
    4388: 8b0500ea     	add	x10, x7, x5
    438c: 93c13825     	ror	x5, x1, #0xe
    4390: d29d7327     	mov	x7, #0xeb99             // =60313
    4394: 93ca7146     	ror	x6, x10, #0x1c
    4398: f2bbf1c7     	movk	x7, #0xdf8e, lsl #16
    439c: aa130293     	orr	x19, x20, x19
    43a0: cac148a5     	eor	x5, x5, x1, ror #18
    43a4: f2cee987     	movk	x7, #0x774c, lsl #32
    43a8: 8a080234     	and	x20, x17, x8
    43ac: caca88c6     	eor	x6, x6, x10, ror #34
    43b0: f2e4e907     	movk	x7, #0x2748, lsl #48
    43b4: 8b130063     	add	x3, x3, x19
    43b8: cac1a4a5     	eor	x5, x5, x1, ror #41
    43bc: 8a150153     	and	x19, x10, x21
    43c0: 8b070063     	add	x3, x3, x7
    43c4: caca9cc6     	eor	x6, x6, x10, ror #39
    43c8: aa140267     	orr	x7, x19, x20
    43cc: d2891513     	mov	x19, #0x48a8            // =18600
    43d0: 8b050065     	add	x5, x3, x5
    43d4: f2bc3373     	movk	x19, #0xe19b, lsl #16
    43d8: 8b0700c6     	add	x6, x6, x7
    43dc: 8b1200a3     	add	x3, x5, x18
    43e0: f2d796b3     	movk	x19, #0xbcb5, lsl #32
    43e4: 8b0500d2     	add	x18, x6, x5
    43e8: a9599be7     	ldp	x7, x6, [sp, #0x198]
    43ec: 93c33865     	ror	x5, x3, #0xe
    43f0: 8a230054     	bic	x20, x2, x3
    43f4: 8a030035     	and	x21, x1, x3
    43f8: aa1402b4     	orr	x20, x21, x20
    43fc: aa110155     	orr	x21, x10, x17
    4400: f2e69613     	movk	x19, #0x34b0, lsl #48
    4404: 8b0400e4     	add	x4, x7, x4
    4408: 93d27247     	ror	x7, x18, #0x1c
    440c: cac348a5     	eor	x5, x5, x3, ror #18
    4410: 8b140084     	add	x4, x4, x20
    4414: 8a110154     	and	x20, x10, x17
    4418: 8a150255     	and	x21, x18, x21
    441c: cad288e7     	eor	x7, x7, x18, ror #34
    4420: cac3a4a5     	eor	x5, x5, x3, ror #41
    4424: 8b130084     	add	x4, x4, x19
    4428: aa1402b3     	orr	x19, x21, x20
    442c: 8b0200c2     	add	x2, x6, x2
    4430: aa0a0255     	orr	x21, x18, x10
    4434: cad29ce7     	eor	x7, x7, x18, ror #39
    4438: 8b050085     	add	x5, x4, x5
    443c: 8b0800a4     	add	x4, x5, x8
    4440: 8b1300e7     	add	x7, x7, x19
    4444: 8a240033     	bic	x19, x1, x4
    4448: 8a040074     	and	x20, x3, x4
    444c: 8b0500e8     	add	x8, x7, x5
    4450: 93c43885     	ror	x5, x4, #0xe
    4454: d28b4c67     	mov	x7, #0x5a63             // =23139
    4458: 93c87106     	ror	x6, x8, #0x1c
    445c: f2b8b927     	movk	x7, #0xc5c9, lsl #16
    4460: aa130293     	orr	x19, x20, x19
    4464: cac448a5     	eor	x5, x5, x4, ror #18
    4468: f2c19667     	movk	x7, #0xcb3, lsl #32
    446c: 8a0a0254     	and	x20, x18, x10
    4470: cac888c6     	eor	x6, x6, x8, ror #34
    4474: f2e72387     	movk	x7, #0x391c, lsl #48
    4478: 8b130042     	add	x2, x2, x19
    447c: cac4a4a5     	eor	x5, x5, x4, ror #41
    4480: 8a150113     	and	x19, x8, x21
    4484: 8b070042     	add	x2, x2, x7
    4488: cac89cc6     	eor	x6, x6, x8, ror #39
    448c: aa140267     	orr	x7, x19, x20
    4490: d2915973     	mov	x19, #0x8acb            // =35531
    4494: 8b050045     	add	x5, x2, x5
    4498: f2bc6833     	movk	x19, #0xe341, lsl #16
    449c: 8b0700c6     	add	x6, x6, x7
    44a0: 8b1100a2     	add	x2, x5, x17
    44a4: f2d54953     	movk	x19, #0xaa4a, lsl #32
    44a8: 8b0500d1     	add	x17, x6, x5
    44ac: a95a9be7     	ldp	x7, x6, [sp, #0x1a8]
    44b0: 93c23845     	ror	x5, x2, #0xe
    44b4: 8a220074     	bic	x20, x3, x2
    44b8: 8a020095     	and	x21, x4, x2
    44bc: aa1402b4     	orr	x20, x21, x20
    44c0: aa120115     	orr	x21, x8, x18
    44c4: f2e9db13     	movk	x19, #0x4ed8, lsl #48
    44c8: 8b0100e1     	add	x1, x7, x1
    44cc: 93d17227     	ror	x7, x17, #0x1c
    44d0: cac248a5     	eor	x5, x5, x2, ror #18
    44d4: 8b140021     	add	x1, x1, x20
    44d8: 8a120114     	and	x20, x8, x18
    44dc: 8a150235     	and	x21, x17, x21
    44e0: cad188e7     	eor	x7, x7, x17, ror #34
    44e4: cac2a4a5     	eor	x5, x5, x2, ror #41
    44e8: 8b130021     	add	x1, x1, x19
    44ec: aa1402b3     	orr	x19, x21, x20
    44f0: 8b0300c3     	add	x3, x6, x3
    44f4: aa080235     	orr	x21, x17, x8
    44f8: cad19ce7     	eor	x7, x7, x17, ror #39
    44fc: 8b050025     	add	x5, x1, x5
    4500: 8b0a00a1     	add	x1, x5, x10
    4504: 8b1300e7     	add	x7, x7, x19
    4508: 8a210093     	bic	x19, x4, x1
    450c: 8a010054     	and	x20, x2, x1
    4510: 8b0500ea     	add	x10, x7, x5
    4514: 93c13825     	ror	x5, x1, #0xe
    4518: d29c6e67     	mov	x7, #0xe373             // =58227
    451c: 93ca7146     	ror	x6, x10, #0x1c
    4520: f2aeec67     	movk	x7, #0x7763, lsl #16
    4524: aa130293     	orr	x19, x20, x19
    4528: cac148a5     	eor	x5, x5, x1, ror #18
    452c: f2d949e7     	movk	x7, #0xca4f, lsl #32
    4530: 8a080234     	and	x20, x17, x8
    4534: caca88c6     	eor	x6, x6, x10, ror #34
    4538: f2eb7387     	movk	x7, #0x5b9c, lsl #48
    453c: 8b130063     	add	x3, x3, x19
    4540: cac1a4a5     	eor	x5, x5, x1, ror #41
    4544: 8a150153     	and	x19, x10, x21
    4548: 8b070063     	add	x3, x3, x7
    454c: caca9cc6     	eor	x6, x6, x10, ror #39
    4550: aa140267     	orr	x7, x19, x20
    4554: d2971473     	mov	x19, #0xb8a3            // =47267
    4558: 8b050065     	add	x5, x3, x5
    455c: f2bad653     	movk	x19, #0xd6b2, lsl #16
    4560: 8b0700c6     	add	x6, x6, x7
    4564: 8b1200a3     	add	x3, x5, x18
    4568: f2cdfe73     	movk	x19, #0x6ff3, lsl #32
    456c: 8b0500d2     	add	x18, x6, x5
    4570: a95b9be7     	ldp	x7, x6, [sp, #0x1b8]
    4574: 93c33865     	ror	x5, x3, #0xe
    4578: 8a230054     	bic	x20, x2, x3
    457c: 8a030035     	and	x21, x1, x3
    4580: aa1402b4     	orr	x20, x21, x20
    4584: aa110155     	orr	x21, x10, x17
    4588: f2ed05d3     	movk	x19, #0x682e, lsl #48
    458c: 8b0400e4     	add	x4, x7, x4
    4590: 93d27247     	ror	x7, x18, #0x1c
    4594: cac348a5     	eor	x5, x5, x3, ror #18
    4598: 8b140084     	add	x4, x4, x20
    459c: 8a110154     	and	x20, x10, x17
    45a0: 8a150255     	and	x21, x18, x21
    45a4: cad288e7     	eor	x7, x7, x18, ror #34
    45a8: cac3a4a5     	eor	x5, x5, x3, ror #41
    45ac: 8b130084     	add	x4, x4, x19
    45b0: aa1402b3     	orr	x19, x21, x20
    45b4: 8b0200c2     	add	x2, x6, x2
    45b8: aa0a0255     	orr	x21, x18, x10
    45bc: cad29ce7     	eor	x7, x7, x18, ror #39
    45c0: 8b050085     	add	x5, x4, x5
    45c4: 8b0800a4     	add	x4, x5, x8
    45c8: 8b1300e7     	add	x7, x7, x19
    45cc: 8a240033     	bic	x19, x1, x4
    45d0: 8a040074     	and	x20, x3, x4
    45d4: 8b0500e8     	add	x8, x7, x5
    45d8: 93c43885     	ror	x5, x4, #0xe
    45dc: d2965f87     	mov	x7, #0xb2fc             // =45820
    45e0: 93c87106     	ror	x6, x8, #0x1c
    45e4: f2abbde7     	movk	x7, #0x5def, lsl #16
    45e8: aa130293     	orr	x19, x20, x19
    45ec: cac448a5     	eor	x5, x5, x4, ror #18
    45f0: f2d05dc7     	movk	x7, #0x82ee, lsl #32
    45f4: 8a0a0254     	and	x20, x18, x10
    45f8: cac888c6     	eor	x6, x6, x8, ror #34
    45fc: f2ee91e7     	movk	x7, #0x748f, lsl #48
    4600: 8b130042     	add	x2, x2, x19
    4604: cac4a4a5     	eor	x5, x5, x4, ror #41
    4608: 8a150113     	and	x19, x8, x21
    460c: 8b070042     	add	x2, x2, x7
    4610: cac89cc6     	eor	x6, x6, x8, ror #39
    4614: aa140267     	orr	x7, x19, x20
    4618: d285ec13     	mov	x19, #0x2f60            // =12128
    461c: 8b050045     	add	x5, x2, x5
    4620: f2a862f3     	movk	x19, #0x4317, lsl #16
    4624: 8b0700c6     	add	x6, x6, x7
    4628: 8b1100a2     	add	x2, x5, x17
    462c: f2cc6df3     	movk	x19, #0x636f, lsl #32
    4630: 8b0500d1     	add	x17, x6, x5
    4634: a95c9be7     	ldp	x7, x6, [sp, #0x1c8]
    4638: 93c23845     	ror	x5, x2, #0xe
    463c: 8a220074     	bic	x20, x3, x2
    4640: 8a020095     	and	x21, x4, x2
    4644: aa1402b4     	orr	x20, x21, x20
    4648: aa120115     	orr	x21, x8, x18
    464c: f2ef14b3     	movk	x19, #0x78a5, lsl #48
    4650: 8b0100e1     	add	x1, x7, x1
    4654: 93d17227     	ror	x7, x17, #0x1c
    4658: cac248a5     	eor	x5, x5, x2, ror #18
    465c: 8b140021     	add	x1, x1, x20
    4660: 8a120114     	and	x20, x8, x18
    4664: 8a150235     	and	x21, x17, x21
    4668: cad188e7     	eor	x7, x7, x17, ror #34
    466c: cac2a4a5     	eor	x5, x5, x2, ror #41
    4670: 8b130021     	add	x1, x1, x19
    4674: aa1402b3     	orr	x19, x21, x20
    4678: 8b0300c3     	add	x3, x6, x3
    467c: aa080235     	orr	x21, x17, x8
    4680: cad19ce7     	eor	x7, x7, x17, ror #39
    4684: 8b050021     	add	x1, x1, x5
    4688: 8b0a0025     	add	x5, x1, x10
    468c: 8b1300e7     	add	x7, x7, x19
    4690: 8a250093     	bic	x19, x4, x5
    4694: 8a050054     	and	x20, x2, x5
    4698: 8b0100ea     	add	x10, x7, x1
    469c: 93c538a1     	ror	x1, x5, #0xe
    46a0: d2956e47     	mov	x7, #0xab72             // =43890
    46a4: 93ca7146     	ror	x6, x10, #0x1c
    46a8: f2b43e07     	movk	x7, #0xa1f0, lsl #16
    46ac: aa130293     	orr	x19, x20, x19
    46b0: cac54821     	eor	x1, x1, x5, ror #18
    46b4: f2cf0287     	movk	x7, #0x7814, lsl #32
    46b8: 8a080234     	and	x20, x17, x8
    46bc: caca88c6     	eor	x6, x6, x10, ror #34
    46c0: f2f09907     	movk	x7, #0x84c8, lsl #48
    46c4: 8b130063     	add	x3, x3, x19
    46c8: cac5a421     	eor	x1, x1, x5, ror #41
    46cc: 8a150153     	and	x19, x10, x21
    46d0: 8b070063     	add	x3, x3, x7
    46d4: caca9cc6     	eor	x6, x6, x10, ror #39
    46d8: aa140267     	orr	x7, x19, x20
    46dc: d2873d93     	mov	x19, #0x39ec            // =14828
    46e0: 8b010061     	add	x1, x3, x1
    46e4: f2a34c93     	movk	x19, #0x1a64, lsl #16
    46e8: 8b0700c6     	add	x6, x6, x7
    46ec: 8b120023     	add	x3, x1, x18
    46f0: f2c04113     	movk	x19, #0x208, lsl #32
    46f4: 8b0100d2     	add	x18, x6, x1
    46f8: a95d9be7     	ldp	x7, x6, [sp, #0x1d8]
    46fc: 93c33861     	ror	x1, x3, #0xe
    4700: 8a230054     	bic	x20, x2, x3
    4704: 8a0300b5     	and	x21, x5, x3
    4708: aa1402b4     	orr	x20, x21, x20
    470c: aa110155     	orr	x21, x10, x17
    4710: f2f198f3     	movk	x19, #0x8cc7, lsl #48
    4714: 8b0400e4     	add	x4, x7, x4
    4718: 93d27247     	ror	x7, x18, #0x1c
    471c: cac34821     	eor	x1, x1, x3, ror #18
    4720: 8b140084     	add	x4, x4, x20
    4724: 8a110154     	and	x20, x10, x17
    4728: 8a150255     	and	x21, x18, x21
    472c: cad288e7     	eor	x7, x7, x18, ror #34
    4730: cac3a421     	eor	x1, x1, x3, ror #41
    4734: 8b130084     	add	x4, x4, x19
    4738: aa1402b3     	orr	x19, x21, x20
    473c: 8b0200c2     	add	x2, x6, x2
    4740: aa0a0255     	orr	x21, x18, x10
    4744: cad29ce7     	eor	x7, x7, x18, ror #39
    4748: 8b010084     	add	x4, x4, x1
    474c: 8b080081     	add	x1, x4, x8
    4750: 8b1300e7     	add	x7, x7, x19
    4754: 8a2100b3     	bic	x19, x5, x1
    4758: 8a010074     	and	x20, x3, x1
    475c: 8b0400e8     	add	x8, x7, x4
    4760: 93c13824     	ror	x4, x1, #0xe
    4764: d283c507     	mov	x7, #0x1e28             // =7720
    4768: 93c87106     	ror	x6, x8, #0x1c
    476c: f2a46c67     	movk	x7, #0x2363, lsl #16
    4770: aa130293     	orr	x19, x20, x19
    4774: cac14884     	eor	x4, x4, x1, ror #18
    4778: f2dfff47     	movk	x7, #0xfffa, lsl #32
    477c: 8a0a0254     	and	x20, x18, x10
    4780: cac888c6     	eor	x6, x6, x8, ror #34
    4784: f2f217c7     	movk	x7, #0x90be, lsl #48
    4788: 8b130042     	add	x2, x2, x19
    478c: cac1a484     	eor	x4, x4, x1, ror #41
    4790: 8a150113     	and	x19, x8, x21
    4794: 8b070042     	add	x2, x2, x7
    4798: cac89cc6     	eor	x6, x6, x8, ror #39
    479c: aa140267     	orr	x7, x19, x20
    47a0: d297bd33     	mov	x19, #0xbde9            // =48617
    47a4: 8b040044     	add	x4, x2, x4
    47a8: f2bbd053     	movk	x19, #0xde82, lsl #16
    47ac: 8b0700c6     	add	x6, x6, x7
    47b0: 8b110082     	add	x2, x4, x17
    47b4: f2cd9d73     	movk	x19, #0x6ceb, lsl #32
    47b8: 8b0400d1     	add	x17, x6, x4
    47bc: a95e9be7     	ldp	x7, x6, [sp, #0x1e8]
    47c0: 93c23844     	ror	x4, x2, #0xe
    47c4: 8a220074     	bic	x20, x3, x2
    47c8: 8a020035     	and	x21, x1, x2
    47cc: aa1402b4     	orr	x20, x21, x20
    47d0: aa120115     	orr	x21, x8, x18
    47d4: f2f48a13     	movk	x19, #0xa450, lsl #48
    47d8: 8b0500e5     	add	x5, x7, x5
    47dc: 93d17227     	ror	x7, x17, #0x1c
    47e0: cac24884     	eor	x4, x4, x2, ror #18
    47e4: 8b1400a5     	add	x5, x5, x20
    47e8: 8a120114     	and	x20, x8, x18
    47ec: 8a150235     	and	x21, x17, x21
    47f0: cad188e7     	eor	x7, x7, x17, ror #34
    47f4: cac2a484     	eor	x4, x4, x2, ror #41
    47f8: 8b1300a5     	add	x5, x5, x19
    47fc: aa1402b3     	orr	x19, x21, x20
    4800: 8b0300c3     	add	x3, x6, x3
    4804: aa080235     	orr	x21, x17, x8
    4808: cad19ce7     	eor	x7, x7, x17, ror #39
    480c: 8b0400a5     	add	x5, x5, x4
    4810: 8b0a00a4     	add	x4, x5, x10
    4814: 8b1300e7     	add	x7, x7, x19
    4818: 8a240033     	bic	x19, x1, x4
    481c: 8a040054     	and	x20, x2, x4
    4820: 8b0500ea     	add	x10, x7, x5
    4824: 93c43885     	ror	x5, x4, #0xe
    4828: d28f22a7     	mov	x7, #0x7915             // =30997
    482c: 93ca7146     	ror	x6, x10, #0x1c
    4830: f2b658c7     	movk	x7, #0xb2c6, lsl #16
    4834: aa130293     	orr	x19, x20, x19
    4838: cac448a5     	eor	x5, x5, x4, ror #18
    483c: f2d47ee7     	movk	x7, #0xa3f7, lsl #32
    4840: 8a080234     	and	x20, x17, x8
    4844: caca88c6     	eor	x6, x6, x10, ror #34
    4848: f2f7df27     	movk	x7, #0xbef9, lsl #48
    484c: 8b130063     	add	x3, x3, x19
    4850: cac4a4a5     	eor	x5, x5, x4, ror #41
    4854: 8a150153     	and	x19, x10, x21
    4858: 8b070063     	add	x3, x3, x7
    485c: caca9cc6     	eor	x6, x6, x10, ror #39
    4860: aa140267     	orr	x7, x19, x20
    4864: 8b050065     	add	x5, x3, x5
    4868: 8b0700c6     	add	x6, x6, x7
    486c: a95fcfe7     	ldp	x7, x19, [sp, #0x1f8]
    4870: 8b1200a3     	add	x3, x5, x18
    4874: 8b0500d2     	add	x18, x6, x5
    4878: 93c33865     	ror	x5, x3, #0xe
    487c: 8a230046     	bic	x6, x2, x3
    4880: 8a030094     	and	x20, x4, x3
    4884: 93d27255     	ror	x21, x18, #0x1c
    4888: 8b0100e1     	add	x1, x7, x1
    488c: d28a6567     	mov	x7, #0x532b             // =21291
    4890: aa060286     	orr	x6, x20, x6
    4894: cac348a5     	eor	x5, x5, x3, ror #18
    4898: f2bc6e47     	movk	x7, #0xe372, lsl #16
    489c: f2cf1e47     	movk	x7, #0x78f2, lsl #32
    48a0: 8b060021     	add	x1, x1, x6
    48a4: cad28aa6     	eor	x6, x21, x18, ror #34
    48a8: f2f8ce27     	movk	x7, #0xc671, lsl #48
    48ac: aa110154     	orr	x20, x10, x17
    48b0: cac3a4a5     	eor	x5, x5, x3, ror #41
    48b4: 8b070021     	add	x1, x1, x7
    48b8: 8a110147     	and	x7, x10, x17
    48bc: 8a140254     	and	x20, x18, x20
    48c0: cad29cc6     	eor	x6, x6, x18, ror #39
    48c4: aa070287     	orr	x7, x20, x7
    48c8: 8b050025     	add	x5, x1, x5
    48cc: 8b0800a1     	add	x1, x5, x8
    48d0: 8b020262     	add	x2, x19, x2
    48d4: 8b0700c6     	add	x6, x6, x7
    48d8: 8a210093     	bic	x19, x4, x1
    48dc: 8a010074     	and	x20, x3, x1
    48e0: 8b0500c8     	add	x8, x6, x5
    48e4: 93c13825     	ror	x5, x1, #0xe
    48e8: d28c3386     	mov	x6, #0x619c             // =24988
    48ec: 93c87107     	ror	x7, x8, #0x1c
    48f0: f2bd44c6     	movk	x6, #0xea26, lsl #16
    48f4: aa130293     	orr	x19, x20, x19
    48f8: cac148a5     	eor	x5, x5, x1, ror #18
    48fc: f2c7d9c6     	movk	x6, #0x3ece, lsl #32
    4900: aa0a0254     	orr	x20, x18, x10
    4904: cac888e7     	eor	x7, x7, x8, ror #34
    4908: f2f944e6     	movk	x6, #0xca27, lsl #48
    490c: 8b130042     	add	x2, x2, x19
    4910: cac1a4a5     	eor	x5, x5, x1, ror #41
    4914: 8a0a0253     	and	x19, x18, x10
    4918: 8a140114     	and	x20, x8, x20
    491c: 8b060042     	add	x2, x2, x6
    4920: cac89ce6     	eor	x6, x7, x8, ror #39
    4924: aa130287     	orr	x7, x20, x19
    4928: 8b050045     	add	x5, x2, x5
    492c: f94107f3     	ldr	x19, [sp, #0x208]
    4930: 8b0700c6     	add	x6, x6, x7
    4934: 8b1100a2     	add	x2, x5, x17
    4938: 8b0500d1     	add	x17, x6, x5
    493c: 93c23845     	ror	x5, x2, #0xe
    4940: d29840e6     	mov	x6, #0xc207             // =49671
    4944: 93d17227     	ror	x7, x17, #0x1c
    4948: f2a43806     	movk	x6, #0x21c0, lsl #16
    494c: 8b040264     	add	x4, x19, x4
    4950: 8a220073     	bic	x19, x3, x2
    4954: 8a020034     	and	x20, x1, x2
    4958: cac248a5     	eor	x5, x5, x2, ror #18
    495c: f2d718e6     	movk	x6, #0xb8c7, lsl #32
    4960: aa130293     	orr	x19, x20, x19
    4964: cad188e7     	eor	x7, x7, x17, ror #34
    4968: f2fa30c6     	movk	x6, #0xd186, lsl #48
    496c: aa120114     	orr	x20, x8, x18
    4970: 8b130084     	add	x4, x4, x19
    4974: cac2a4a5     	eor	x5, x5, x2, ror #41
    4978: 8a120113     	and	x19, x8, x18
    497c: 8a140234     	and	x20, x17, x20
    4980: 8b060084     	add	x4, x4, x6
    4984: cad19ce6     	eor	x6, x7, x17, ror #39
    4988: aa130287     	orr	x7, x20, x19
    498c: 8b050085     	add	x5, x4, x5
    4990: f9410bf3     	ldr	x19, [sp, #0x210]
    4994: 8b0700c6     	add	x6, x6, x7
    4998: 8b0a00a4     	add	x4, x5, x10
    499c: 8b0500ca     	add	x10, x6, x5
    49a0: 93c43885     	ror	x5, x4, #0xe
    49a4: d29d63c6     	mov	x6, #0xeb1e             // =60190
    49a8: 93ca7147     	ror	x7, x10, #0x1c
    49ac: f2b9bc06     	movk	x6, #0xcde0, lsl #16
    49b0: 8b030263     	add	x3, x19, x3
    49b4: 8a240033     	bic	x19, x1, x4
    49b8: 8a040054     	and	x20, x2, x4
    49bc: cac448a5     	eor	x5, x5, x4, ror #18
    49c0: f2cfbac6     	movk	x6, #0x7dd6, lsl #32
    49c4: aa130293     	orr	x19, x20, x19
    49c8: caca88e7     	eor	x7, x7, x10, ror #34
    49cc: f2fd5b46     	movk	x6, #0xeada, lsl #48
    49d0: aa080234     	orr	x20, x17, x8
    49d4: 8b130063     	add	x3, x3, x19
    49d8: cac4a4a5     	eor	x5, x5, x4, ror #41
    49dc: 8a080233     	and	x19, x17, x8
    49e0: 8a140154     	and	x20, x10, x20
    49e4: 8b060063     	add	x3, x3, x6
    49e8: caca9ce6     	eor	x6, x7, x10, ror #39
    49ec: aa130287     	orr	x7, x20, x19
    49f0: 8b050065     	add	x5, x3, x5
    49f4: f9410ff3     	ldr	x19, [sp, #0x218]
    49f8: 8b0700c6     	add	x6, x6, x7
    49fc: 8b1200a3     	add	x3, x5, x18
    4a00: 8b0500d2     	add	x18, x6, x5
    4a04: 93c33865     	ror	x5, x3, #0xe
    4a08: d29a2f06     	mov	x6, #0xd178             // =53624
    4a0c: 93d27247     	ror	x7, x18, #0x1c
    4a10: f2bdcdc6     	movk	x6, #0xee6e, lsl #16
    4a14: 8b010261     	add	x1, x19, x1
    4a18: 8a230053     	bic	x19, x2, x3
    4a1c: 8a030094     	and	x20, x4, x3
    4a20: cac348a5     	eor	x5, x5, x3, ror #18
    4a24: f2c9efe6     	movk	x6, #0x4f7f, lsl #32
    4a28: aa130293     	orr	x19, x20, x19
    4a2c: cad288e7     	eor	x7, x7, x18, ror #34
    4a30: f2feafa6     	movk	x6, #0xf57d, lsl #48
    4a34: aa110154     	orr	x20, x10, x17
    4a38: 8b130021     	add	x1, x1, x19
    4a3c: cac3a4a5     	eor	x5, x5, x3, ror #41
    4a40: 8a110153     	and	x19, x10, x17
    4a44: 8a140254     	and	x20, x18, x20
    4a48: 8b060021     	add	x1, x1, x6
    4a4c: cad29ce6     	eor	x6, x7, x18, ror #39
    4a50: aa130287     	orr	x7, x20, x19
    4a54: 8b050025     	add	x5, x1, x5
    4a58: f94113f3     	ldr	x19, [sp, #0x220]
    4a5c: 8b0700c6     	add	x6, x6, x7
    4a60: 8b0800a1     	add	x1, x5, x8
    4a64: 8b0500c8     	add	x8, x6, x5
    4a68: 93c13825     	ror	x5, x1, #0xe
    4a6c: d28df746     	mov	x6, #0x6fba             // =28602
    4a70: 93c87107     	ror	x7, x8, #0x1c
    4a74: f2ae42e6     	movk	x6, #0x7217, lsl #16
    4a78: 8b020262     	add	x2, x19, x2
    4a7c: 8a210093     	bic	x19, x4, x1
    4a80: 8a010074     	and	x20, x3, x1
    4a84: cac148a5     	eor	x5, x5, x1, ror #18
    4a88: f2ccf546     	movk	x6, #0x67aa, lsl #32
    4a8c: aa130293     	orr	x19, x20, x19
    4a90: cac888e7     	eor	x7, x7, x8, ror #34
    4a94: f2e0de06     	movk	x6, #0x6f0, lsl #48
    4a98: aa0a0254     	orr	x20, x18, x10
    4a9c: 8b130042     	add	x2, x2, x19
    4aa0: cac1a4a5     	eor	x5, x5, x1, ror #41
    4aa4: 8a0a0253     	and	x19, x18, x10
    4aa8: 8a140114     	and	x20, x8, x20
    4aac: 8b060042     	add	x2, x2, x6
    4ab0: cac89ce6     	eor	x6, x7, x8, ror #39
    4ab4: aa130287     	orr	x7, x20, x19
    4ab8: 8b050045     	add	x5, x2, x5
    4abc: f94117f3     	ldr	x19, [sp, #0x228]
    4ac0: 8b0700c6     	add	x6, x6, x7
    4ac4: 8b1100a2     	add	x2, x5, x17
    4ac8: 8b0500d1     	add	x17, x6, x5
    4acc: 93c23845     	ror	x5, x2, #0xe
    4ad0: d29314c6     	mov	x6, #0x98a6             // =39078
    4ad4: 93d17227     	ror	x7, x17, #0x1c
    4ad8: f2b45906     	movk	x6, #0xa2c8, lsl #16
    4adc: 8b040264     	add	x4, x19, x4
    4ae0: 8a220073     	bic	x19, x3, x2
    4ae4: 8a020034     	and	x20, x1, x2
    4ae8: cac248a5     	eor	x5, x5, x2, ror #18
    4aec: f2cfb8a6     	movk	x6, #0x7dc5, lsl #32
    4af0: aa130293     	orr	x19, x20, x19
    4af4: cad188e7     	eor	x7, x7, x17, ror #34
    4af8: f2e14c66     	movk	x6, #0xa63, lsl #48
    4afc: aa120114     	orr	x20, x8, x18
    4b00: 8b130084     	add	x4, x4, x19
    4b04: cac2a4a5     	eor	x5, x5, x2, ror #41
    4b08: 8a120113     	and	x19, x8, x18
    4b0c: 8a140234     	and	x20, x17, x20
    4b10: 8b060084     	add	x4, x4, x6
    4b14: cad19ce6     	eor	x6, x7, x17, ror #39
    4b18: aa130287     	orr	x7, x20, x19
    4b1c: 8b050085     	add	x5, x4, x5
    4b20: f9411bf3     	ldr	x19, [sp, #0x230]
    4b24: 8b0700c6     	add	x6, x6, x7
    4b28: 8b0a00a4     	add	x4, x5, x10
    4b2c: 8b0500ca     	add	x10, x6, x5
    4b30: 93c43885     	ror	x5, x4, #0xe
    4b34: d281b5c6     	mov	x6, #0xdae              // =3502
    4b38: 93ca7147     	ror	x7, x10, #0x1c
    4b3c: f2b7df26     	movk	x6, #0xbef9, lsl #16
    4b40: 8b030263     	add	x3, x19, x3
    4b44: 8a240033     	bic	x19, x1, x4
    4b48: 8a040054     	and	x20, x2, x4
    4b4c: cac448a5     	eor	x5, x5, x4, ror #18
    4b50: f2d30086     	movk	x6, #0x9804, lsl #32
    4b54: aa130293     	orr	x19, x20, x19
    4b58: caca88e7     	eor	x7, x7, x10, ror #34
    4b5c: f2e227e6     	movk	x6, #0x113f, lsl #48
    4b60: aa080234     	orr	x20, x17, x8
    4b64: 8b130063     	add	x3, x3, x19
    4b68: cac4a4a5     	eor	x5, x5, x4, ror #41
    4b6c: 8a080233     	and	x19, x17, x8
    4b70: 8a140154     	and	x20, x10, x20
    4b74: 8b060063     	add	x3, x3, x6
    4b78: caca9ce6     	eor	x6, x7, x10, ror #39
    4b7c: aa130287     	orr	x7, x20, x19
    4b80: 8b050065     	add	x5, x3, x5
    4b84: f9411ff3     	ldr	x19, [sp, #0x238]
    4b88: 8b0700c6     	add	x6, x6, x7
    4b8c: 8b1200a3     	add	x3, x5, x18
    4b90: 8b0500d2     	add	x18, x6, x5
    4b94: 93c33865     	ror	x5, x3, #0xe
    4b98: d288e366     	mov	x6, #0x471b             // =18203
    4b9c: 93d27247     	ror	x7, x18, #0x1c
    4ba0: f2a26386     	movk	x6, #0x131c, lsl #16
    4ba4: 8b010261     	add	x1, x19, x1
    4ba8: 8a230053     	bic	x19, x2, x3
    4bac: 8a030094     	and	x20, x4, x3
    4bb0: cac348a5     	eor	x5, x5, x3, ror #18
    4bb4: f2c166a6     	movk	x6, #0xb35, lsl #32
    4bb8: aa130293     	orr	x19, x20, x19
    4bbc: cad288e7     	eor	x7, x7, x18, ror #34
    4bc0: f2e36e26     	movk	x6, #0x1b71, lsl #48
    4bc4: aa110154     	orr	x20, x10, x17
    4bc8: 8b130021     	add	x1, x1, x19
    4bcc: cac3a4a5     	eor	x5, x5, x3, ror #41
    4bd0: 8a110153     	and	x19, x10, x17
    4bd4: 8a140254     	and	x20, x18, x20
    4bd8: 8b060021     	add	x1, x1, x6
    4bdc: cad29ce6     	eor	x6, x7, x18, ror #39
    4be0: aa130287     	orr	x7, x20, x19
    4be4: 8b050021     	add	x1, x1, x5
    4be8: f94123f3     	ldr	x19, [sp, #0x240]
    4bec: 8b0700c6     	add	x6, x6, x7
    4bf0: 8b080025     	add	x5, x1, x8
    4bf4: 8b0100c1     	add	x1, x6, x1
    4bf8: 93c538a8     	ror	x8, x5, #0xe
    4bfc: d28fb086     	mov	x6, #0x7d84             // =32132
    4c00: 93c17027     	ror	x7, x1, #0x1c
    4c04: f2a46086     	movk	x6, #0x2304, lsl #16
    4c08: 8b020262     	add	x2, x19, x2
    4c0c: 8a250093     	bic	x19, x4, x5
    4c10: 8a050074     	and	x20, x3, x5
    4c14: cac54908     	eor	x8, x8, x5, ror #18
    4c18: f2cefea6     	movk	x6, #0x77f5, lsl #32
    4c1c: aa130293     	orr	x19, x20, x19
    4c20: cac188e7     	eor	x7, x7, x1, ror #34
    4c24: f2e51b66     	movk	x6, #0x28db, lsl #48
    4c28: aa0a0254     	orr	x20, x18, x10
    4c2c: 8b130042     	add	x2, x2, x19
    4c30: cac5a508     	eor	x8, x8, x5, ror #41
    4c34: 8a0a0253     	and	x19, x18, x10
    4c38: 8a140034     	and	x20, x1, x20
    4c3c: 8b060042     	add	x2, x2, x6
    4c40: cac19ce6     	eor	x6, x7, x1, ror #39
    4c44: aa130287     	orr	x7, x20, x19
    4c48: 8b080048     	add	x8, x2, x8
    4c4c: f94127f3     	ldr	x19, [sp, #0x248]
    4c50: 8b0700c6     	add	x6, x6, x7
    4c54: 8b110102     	add	x2, x8, x17
    4c58: 8b0800d1     	add	x17, x6, x8
    4c5c: 93c23848     	ror	x8, x2, #0xe
    4c60: d2849266     	mov	x6, #0x2493             // =9363
    4c64: 93d17227     	ror	x7, x17, #0x1c
    4c68: f2a818e6     	movk	x6, #0x40c7, lsl #16
    4c6c: 8b040264     	add	x4, x19, x4
    4c70: 8a220073     	bic	x19, x3, x2
    4c74: 8a0200b4     	and	x20, x5, x2
    4c78: cac24908     	eor	x8, x8, x2, ror #18
    4c7c: f2d56f66     	movk	x6, #0xab7b, lsl #32
    4c80: aa130293     	orr	x19, x20, x19
    4c84: cad188e7     	eor	x7, x7, x17, ror #34
    4c88: f2e65946     	movk	x6, #0x32ca, lsl #48
    4c8c: aa120034     	orr	x20, x1, x18
    4c90: 8b130084     	add	x4, x4, x19
    4c94: cac2a508     	eor	x8, x8, x2, ror #41
    4c98: 8a120033     	and	x19, x1, x18
    4c9c: 8a140234     	and	x20, x17, x20
    4ca0: 8b060084     	add	x4, x4, x6
    4ca4: cad19ce6     	eor	x6, x7, x17, ror #39
    4ca8: aa130287     	orr	x7, x20, x19
    4cac: 8b080088     	add	x8, x4, x8
    4cb0: f9412bf3     	ldr	x19, [sp, #0x250]
    4cb4: 8b0700c6     	add	x6, x6, x7
    4cb8: 8b0a0104     	add	x4, x8, x10
    4cbc: 8b0800ca     	add	x10, x6, x8
    4cc0: 93c43888     	ror	x8, x4, #0xe
    4cc4: d297d786     	mov	x6, #0xbebc             // =48828
    4cc8: 93ca7147     	ror	x7, x10, #0x1c
    4ccc: f2a2b926     	movk	x6, #0x15c9, lsl #16
    4cd0: 8b030263     	add	x3, x19, x3
    4cd4: 8a2400b3     	bic	x19, x5, x4
    4cd8: 8a040054     	and	x20, x2, x4
    4cdc: cac44908     	eor	x8, x8, x4, ror #18
    4ce0: f2d7c146     	movk	x6, #0xbe0a, lsl #32
    4ce4: aa130293     	orr	x19, x20, x19
    4ce8: caca88e7     	eor	x7, x7, x10, ror #34
    4cec: f2e793c6     	movk	x6, #0x3c9e, lsl #48
    4cf0: aa010234     	orr	x20, x17, x1
    4cf4: 8b130063     	add	x3, x3, x19
    4cf8: cac4a508     	eor	x8, x8, x4, ror #41
    4cfc: 8a010233     	and	x19, x17, x1
    4d00: 8a140154     	and	x20, x10, x20
    4d04: 8b060063     	add	x3, x3, x6
    4d08: caca9ce6     	eor	x6, x7, x10, ror #39
    4d0c: aa130287     	orr	x7, x20, x19
    4d10: 8b080068     	add	x8, x3, x8
    4d14: f9412fe3     	ldr	x3, [sp, #0x258]
    4d18: 8b0700c6     	add	x6, x6, x7
    4d1c: 8b120112     	add	x18, x8, x18
    4d20: d281a987     	mov	x7, #0xd4c              // =3404
    4d24: 8b0800c8     	add	x8, x6, x8
    4d28: 93d23a46     	ror	x6, x18, #0xe
    4d2c: 8b050063     	add	x3, x3, x5
    4d30: 93c87105     	ror	x5, x8, #0x1c
    4d34: f2b38207     	movk	x7, #0x9c10, lsl #16
    4d38: 8a320053     	bic	x19, x2, x18
    4d3c: 8a120094     	and	x20, x4, x18
    4d40: cad248c6     	eor	x6, x6, x18, ror #18
    4d44: f2ccf887     	movk	x7, #0x67c4, lsl #32
    4d48: aa130293     	orr	x19, x20, x19
    4d4c: cac888a5     	eor	x5, x5, x8, ror #34
    4d50: f2e863a7     	movk	x7, #0x431d, lsl #48
    4d54: aa110154     	orr	x20, x10, x17
    4d58: 8b130063     	add	x3, x3, x19
    4d5c: cad2a4c6     	eor	x6, x6, x18, ror #41
    4d60: 8a110153     	and	x19, x10, x17
    4d64: 8a140114     	and	x20, x8, x20
    4d68: 8b070063     	add	x3, x3, x7
    4d6c: cac89ca5     	eor	x5, x5, x8, ror #39
    4d70: aa130287     	orr	x7, x20, x19
    4d74: 8b060066     	add	x6, x3, x6
    4d78: 8b0100c3     	add	x3, x6, x1
    4d7c: f94133f3     	ldr	x19, [sp, #0x260]
    4d80: 8b0700a5     	add	x5, x5, x7
    4d84: 8a030254     	and	x20, x18, x3
    4d88: 8b0600a1     	add	x1, x5, x6
    4d8c: 93c33865     	ror	x5, x3, #0xe
    4d90: d28856c6     	mov	x6, #0x42b6             // =17078
    4d94: 93c17027     	ror	x7, x1, #0x1c
    4d98: f2b967c6     	movk	x6, #0xcb3e, lsl #16
    4d9c: 8b020262     	add	x2, x19, x2
    4da0: 8a230093     	bic	x19, x4, x3
    4da4: cac348a5     	eor	x5, x5, x3, ror #18
    4da8: f2da97c6     	movk	x6, #0xd4be, lsl #32
    4dac: aa130293     	orr	x19, x20, x19
    4db0: cac188e7     	eor	x7, x7, x1, ror #34
    4db4: f2e998a6     	movk	x6, #0x4cc5, lsl #48
    4db8: aa0a0114     	orr	x20, x8, x10
    4dbc: 8b130042     	add	x2, x2, x19
    4dc0: cac3a4a5     	eor	x5, x5, x3, ror #41
    4dc4: 8a0a0113     	and	x19, x8, x10
    4dc8: 8a140034     	and	x20, x1, x20
    4dcc: 8b060042     	add	x2, x2, x6
    4dd0: cac19ce6     	eor	x6, x7, x1, ror #39
    4dd4: aa130287     	orr	x7, x20, x19
    4dd8: 8b050042     	add	x2, x2, x5
    4ddc: f94137e5     	ldr	x5, [sp, #0x268]
    4de0: 8b110051     	add	x17, x2, x17
    4de4: 8b0101ef     	add	x15, x15, x1
    4de8: 8b0700c6     	add	x6, x6, x7
    4dec: d28fc547     	mov	x7, #0x7e2a             // =32298
    4df0: 8a310253     	bic	x19, x18, x17
    4df4: 8b0200c2     	add	x2, x6, x2
    4df8: 93d13a26     	ror	x6, x17, #0xe
    4dfc: 8b0400a4     	add	x4, x5, x4
    4e00: 93c27045     	ror	x5, x2, #0x1c
    4e04: f2bf8ca7     	movk	x7, #0xfc65, lsl #16
    4e08: 8a110074     	and	x20, x3, x17
    4e0c: cad148c6     	eor	x6, x6, x17, ror #18
    4e10: f2c53387     	movk	x7, #0x299c, lsl #32
    4e14: aa130293     	orr	x19, x20, x19
    4e18: cac288a5     	eor	x5, x5, x2, ror #34
    4e1c: f2eb2fe7     	movk	x7, #0x597f, lsl #48
    4e20: aa080034     	orr	x20, x1, x8
    4e24: 8b130084     	add	x4, x4, x19
    4e28: cad1a4c6     	eor	x6, x6, x17, ror #41
    4e2c: 8a080033     	and	x19, x1, x8
    4e30: 8a140054     	and	x20, x2, x20
    4e34: 8b070084     	add	x4, x4, x7
    4e38: cac29ca5     	eor	x5, x5, x2, ror #39
    4e3c: aa130293     	orr	x19, x20, x19
    4e40: 8b060084     	add	x4, x4, x6
    4e44: f9413be7     	ldr	x7, [sp, #0x270]
    4e48: 8b1300a5     	add	x5, x5, x19
    4e4c: 8b0a008a     	add	x10, x4, x10
    4e50: d29f5d94     	mov	x20, #0xfaec            // =64236
    4e54: 8b0400a4     	add	x4, x5, x4
    4e58: 93ca3945     	ror	x5, x10, #0xe
    4e5c: 8b1200f2     	add	x18, x7, x18
    4e60: 8a2a0066     	bic	x6, x3, x10
    4e64: 8a0a0227     	and	x7, x17, x10
    4e68: 93c47093     	ror	x19, x4, #0x1c
    4e6c: f2a75ad4     	movk	x20, #0x3ad6, lsl #16
    4e70: caca48a5     	eor	x5, x5, x10, ror #18
    4e74: aa0600e6     	orr	x6, x7, x6
    4e78: f2cdf574     	movk	x20, #0x6fab, lsl #32
    4e7c: 8b060252     	add	x18, x18, x6
    4e80: cac48a66     	eor	x6, x19, x4, ror #34
    4e84: f2ebf974     	movk	x20, #0x5fcb, lsl #48
    4e88: cacaa4a5     	eor	x5, x5, x10, ror #41
    4e8c: f9413fe7     	ldr	x7, [sp, #0x278]
    4e90: aa010053     	orr	x19, x2, x1
    4e94: 8b140252     	add	x18, x18, x20
    4e98: 8a010054     	and	x20, x2, x1
    4e9c: 8a130093     	and	x19, x4, x19
    4ea0: cac49cc6     	eor	x6, x6, x4, ror #39
    4ea4: 8b050252     	add	x18, x18, x5
    4ea8: 8b0300e3     	add	x3, x7, x3
    4eac: aa140267     	orr	x7, x19, x20
    4eb0: 8b080248     	add	x8, x18, x8
    4eb4: 8b0700c1     	add	x1, x6, x7
    4eb8: 8a280227     	bic	x7, x17, x8
    4ebc: 8a080153     	and	x19, x10, x8
    4ec0: 8b0201ce     	add	x14, x14, x2
    4ec4: 8b120032     	add	x18, x1, x18
    4ec8: 93c83901     	ror	x1, x8, #0xe
    4ecc: aa020085     	orr	x5, x4, x2
    4ed0: 8a020082     	and	x2, x4, x2
    4ed4: 8b040210     	add	x16, x16, x4
    4ed8: aa070264     	orr	x4, x19, x7
    4edc: 93d27246     	ror	x6, x18, #0x1c
    4ee0: cac84821     	eor	x1, x1, x8, ror #18
    4ee4: 8b040063     	add	x3, x3, x4
    4ee8: d28b02e4     	mov	x4, #0x5817             // =22551
    4eec: a9023810     	stp	x16, x14, [x0, #0x20]
    4ef0: f2a948e4     	movk	x4, #0x4a47, lsl #16
    4ef4: cad288c6     	eor	x6, x6, x18, ror #34
    4ef8: cac8a421     	eor	x1, x1, x8, ror #41
    4efc: f2c33184     	movk	x4, #0x198c, lsl #32
    4f00: 8b080168     	add	x8, x11, x8
    4f04: 8b120129     	add	x9, x9, x18
    4f08: f2ed8884     	movk	x4, #0x6c44, lsl #48
    4f0c: 8b0a018a     	add	x10, x12, x10
    4f10: 8b040063     	add	x3, x3, x4
    4f14: 8a050244     	and	x4, x18, x5
    4f18: cad29cc5     	eor	x5, x6, x18, ror #39
    4f1c: 8b010061     	add	x1, x3, x1
    4f20: aa020082     	orr	x2, x4, x2
    4f24: 8b0101ef     	add	x15, x15, x1
    4f28: 8b0200ae     	add	x14, x5, x2
    4f2c: a903200f     	stp	x15, x8, [x0, #0x30]
    4f30: f9402408     	ldr	x8, [x0, #0x48]
    4f34: 8b0101cb     	add	x11, x14, x1
    4f38: 8b0b01ab     	add	x11, x13, x11
    4f3c: 8b110108     	add	x8, x8, x17
    4f40: a901240b     	stp	x11, x9, [x0, #0x10]
    4f44: a904200a     	stp	x10, x8, [x0, #0x40]
    4f48: 910a03ff     	add	sp, sp, #0x280
    4f4c: a9424ff4     	ldp	x20, x19, [sp, #0x20]
    4f50: f9400bf5     	ldr	x21, [sp, #0x10]
    4f54: a8c37bfd     	ldp	x29, x30, [sp], #0x30
    4f58: d65f03c0     	ret

0000000000004f5c <audit_master384>:
    4f5c: d10643ff     	sub	sp, sp, #0x190
    4f60: a9177bfd     	stp	x29, x30, [sp, #0x170]
    4f64: a9184ffc     	stp	x28, x19, [sp, #0x180]
    4f68: 9105c3fd     	add	x29, sp, #0x170
    4f6c: 90000009     	adrp	x9, 0x4000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x106c>
		0000000000004f6c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x70
    4f70: 91000129     	add	x9, x9, #0x0
		0000000000004f70:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x70
    4f74: 52860008     	mov	w8, #0x3000             // =12288
    4f78: ad400520     	ldp	q0, q1, [x9]
    4f7c: 7900c3e8     	strh	w8, [sp, #0x60]
    4f80: 528001a8     	mov	w8, #0xd                // =13
    4f84: 9000000a     	adrp	x10, 0x4000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x106c>
		0000000000004f84:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0xa0
    4f88: 9100014a     	add	x10, x10, #0x0
		0000000000004f88:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0xa0
    4f8c: f940014b     	ldr	x11, [x10]
    4f90: 39018be8     	strb	w8, [sp, #0x62]
    4f94: f8405148     	ldur	x8, [x10, #0x5]
    4f98: 3c8713e0     	stur	q0, [sp, #0x71]
    4f9c: 3dc00920     	ldr	q0, [x9, #0x20]
    4fa0: aa0103f3     	mov	x19, x1
    4fa4: aa0003e4     	mov	x4, x0
    4fa8: f80633eb     	stur	x11, [sp, #0x63]
    4fac: 910183ea     	add	x10, sp, #0x60
    4fb0: f90037e8     	str	x8, [sp, #0x68]
    4fb4: 52800608     	mov	w8, #0x30               // =48
    4fb8: 9100c3e0     	add	x0, sp, #0x30
    4fbc: 910183e2     	add	x2, sp, #0x60
    4fc0: 52800601     	mov	w1, #0x30               // =48
    4fc4: 52800823     	mov	w3, #0x41               // =65
    4fc8: 3c821141     	stur	q1, [x10, #0x21]
    4fcc: 3901c3e8     	strb	w8, [sp, #0x70]
    4fd0: 3c831140     	stur	q0, [x10, #0x31]
    4fd4: 97fff5ad     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    4fd8: 90000002     	adrp	x2, 0x4000 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x106c>
		0000000000004fd8:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x190
    4fdc: 91000042     	add	x2, x2, #0x0
		0000000000004fdc:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x190
    4fe0: 910003e0     	mov	x0, sp
    4fe4: 9100c3e1     	add	x1, sp, #0x30
    4fe8: 97fff504     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    4fec: ad4007e0     	ldp	q0, q1, [sp]
    4ff0: 3dc00be2     	ldr	q2, [sp, #0x20]
    4ff4: ad000660     	stp	q0, q1, [x19]
    4ff8: 3d800a62     	str	q2, [x19, #0x20]
    4ffc: a9584ffc     	ldp	x28, x19, [sp, #0x180]
    5000: a9577bfd     	ldp	x29, x30, [sp, #0x170]
    5004: 910643ff     	add	sp, sp, #0x190
    5008: d65f03c0     	ret

000000000000500c <audit_key384>:
    500c: d104c3ff     	sub	sp, sp, #0x130
    5010: a9117bfd     	stp	x29, x30, [sp, #0x110]
    5014: f90093fc     	str	x28, [sp, #0x120]
    5018: 910443fd     	add	x29, sp, #0x110
    501c: 52800129     	mov	w9, #0x9                // =9
    5020: 52840008     	mov	w8, #0x2000             // =8192
    5024: aa0003e4     	mov	x4, x0
    5028: 39001be9     	strb	w9, [sp, #0x6]
    502c: 90000009     	adrp	x9, 0x5000 <audit_master384+0xa4>
		000000000000502c:  R_AARCH64_ADR_PREL_PG_HI21	.rodata+0x1c0
    5030: 91000129     	add	x9, x9, #0x0
		0000000000005030:  R_AARCH64_ADD_ABS_LO12_NC	.rodata+0x1c0
    5034: f9400129     	ldr	x9, [x9]
    5038: 79000be8     	strh	w8, [sp, #0x4]
    503c: 52800f28     	mov	w8, #0x79               // =121
    5040: 910013e2     	add	x2, sp, #0x4
    5044: aa0103e0     	mov	x0, x1
    5048: 52800401     	mov	w1, #0x20               // =32
    504c: 528001a3     	mov	w3, #0xd                // =13
    5050: 7800f3e8     	sturh	w8, [sp, #0xf]
    5054: f80073e9     	stur	x9, [sp, #0x7]
    5058: 97fff58c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    505c: a9517bfd     	ldp	x29, x30, [sp, #0x110]
    5060: f94093fc     	ldr	x28, [sp, #0x120]
    5064: 9104c3ff     	add	sp, sp, #0x130
    5068: d65f03c0     	ret
