
/tmp/ztls-signoff-20260919/125-after-direct-buffers/015-aarch64-macos.o:	file format mach-o arm64

Disassembly of section __TEXT,__text:

0000000000000000 <ltmp0>:
<L0>:
       0: d10603ff     	sub	sp, sp, #0x180
       4: a9156ffc     	stp	x28, x27, [sp, #0x150]
       8: a9164ff4     	stp	x20, x19, [sp, #0x160]
       c: a9177bfd     	stp	x29, x30, [sp, #0x170]
      10: 9105c3fd     	add	x29, sp, #0x170
      14: aa0203f3     	mov	x19, x2
      18: aa0103f4     	mov	x20, x1
      1c: aa0003e4     	mov	x4, x0
      20: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000020:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
      24: 91000108     	add	x8, x8, #0x0
		0000000000000024:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
      28: ad400500     	ldp	q0, q1, [x8]
      2c: 3c8513e0     	stur	q0, [sp, #0x51]
      30: 52840008     	mov	w8, #0x2000             ; =8192
      34: 790083e8     	strh	w8, [sp, #0x40]
      38: 528001a8     	mov	w8, #0xd                ; =13
      3c: 39010be8     	strb	w8, [sp, #0x42]
      40: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000040:  ARM64_RELOC_PAGE21	l___unnamed_1
      44: 91000108     	add	x8, x8, #0x0
		0000000000000044:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
      48: f9400109     	ldr	x9, [x8]
      4c: f80433e9     	stur	x9, [sp, #0x43]
      50: f8405108     	ldur	x8, [x8, #0x5]
      54: f90027e8     	str	x8, [sp, #0x48]
      58: 52800408     	mov	w8, #0x20               ; =32
      5c: 390143e8     	strb	w8, [sp, #0x50]
      60: 3c8613e1     	stur	q1, [sp, #0x61]
      64: 910083e0     	add	x0, sp, #0x20
      68: 910103e2     	add	x2, sp, #0x40
      6c: 52800401     	mov	w1, #0x20               ; =32
      70: 52800623     	mov	w3, #0x31               ; =49
<L1>:
      74: 94000000     	bl	 <L1>
		0000000000000074:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
      78: 910003e0     	mov	x0, sp
      7c: 910083e1     	add	x1, sp, #0x20
      80: aa1403e2     	mov	x2, x20
<L2>:
      84: 94000000     	bl	 <L2>
		0000000000000084:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
      88: 6f00e400     	movi.2d	v0, #0000000000000000
      8c: 3d800fe0     	str	q0, [sp, #0x30]
      90: 3d800be0     	str	q0, [sp, #0x20]
      94: ad4007e0     	ldp	q0, q1, [sp]
      98: ad000660     	stp	q0, q1, [x19]
      9c: a9577bfd     	ldp	x29, x30, [sp, #0x170]
      a0: a9564ff4     	ldp	x20, x19, [sp, #0x160]
      a4: a9556ffc     	ldp	x28, x27, [sp, #0x150]
      a8: 910603ff     	add	sp, sp, #0x180
      ac: d65f03c0     	ret

00000000000000b0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
      b0: d106c3ff     	sub	sp, sp, #0x1b0
      b4: a9166ffc     	stp	x28, x27, [sp, #0x160]
      b8: a9175ff8     	stp	x24, x23, [sp, #0x170]
      bc: a91857f6     	stp	x22, x21, [sp, #0x180]
      c0: a9194ff4     	stp	x20, x19, [sp, #0x190]
      c4: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
      c8: 910683fd     	add	x29, sp, #0x1a0
      cc: aa0203f4     	mov	x20, x2
      d0: aa0003f3     	mov	x19, x0
      d4: 910083f7     	add	x23, sp, #0x20
      d8: 910083e0     	add	x0, sp, #0x20
<L0>:
      dc: 94000000     	bl	 <L0>
		00000000000000dc:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
      e0: 394223e8     	ldrb	w8, [sp, #0x88]
      e4: 34000228     	cbz	w8,  <L3>
      e8: 7100811f     	cmp	w8, #0x20
      ec: 540001e3     	b.lo	 <L3>
      f0: 52800809     	mov	w9, #0x40               ; =64
      f4: cb080135     	sub	x21, x9, x8
      f8: 910083e9     	add	x9, sp, #0x20
      fc: 9100a136     	add	x22, x9, #0x28
     100: 8b0802c0     	add	x0, x22, x8
     104: aa1403e1     	mov	x1, x20
     108: aa1503e2     	mov	x2, x21
<L1>:
     10c: 94000000     	bl	 <L1>
		000000000000010c:  ARM64_RELOC_BRANCH26	_memcpy
     110: 910083e0     	add	x0, sp, #0x20
     114: aa1603e1     	mov	x1, x22
<L2>:
     118: 94000000     	bl	 <L2>
		0000000000000118:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     11c: 52800008     	mov	w8, #0x0                ; =0
     120: 390223ff     	strb	wzr, [sp, #0x88]
     124: 14000002     	b	 <L4>
<L3>:
     128: d2800015     	mov	x21, #0x0               ; =0
<L4>:
     12c: 52800409     	mov	w9, #0x20               ; =32
     130: cb150136     	sub	x22, x9, x21
     134: 8b2842e8     	add	x8, x23, w8, uxtw
     138: 9100a100     	add	x0, x8, #0x28
     13c: 8b150281     	add	x1, x20, x21
     140: aa1603e2     	mov	x2, x22
<L5>:
     144: 94000000     	bl	 <L5>
		0000000000000144:  ARM64_RELOC_BRANCH26	_memcpy
     148: 394223e8     	ldrb	w8, [sp, #0x88]
     14c: 0b160108     	add	w8, w8, w22
     150: 390223e8     	strb	w8, [sp, #0x88]
     154: f94023e8     	ldr	x8, [sp, #0x40]
     158: 91008108     	add	x8, x8, #0x20
     15c: f90023e8     	str	x8, [sp, #0x40]
     160: 910343f8     	add	x24, sp, #0xd0
     164: 910083e0     	add	x0, sp, #0x20
     168: 910343e1     	add	x1, sp, #0xd0
<L6>:
     16c: 94000000     	bl	 <L6>
		000000000000016c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     170: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000170:  ARM64_RELOC_PAGE21	l___unnamed_2
     174: 91000108     	add	x8, x8, #0x0
		0000000000000174:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     178: ad420500     	ldp	q0, q1, [x8, #0x40]
     17c: ad3c87a0     	stp	q0, q1, [x29, #-0x70]
     180: 3dc01900     	ldr	q0, [x8, #0x60]
     184: 3c9b03a0     	stur	q0, [x29, #-0x50]
     188: ad400500     	ldp	q0, q1, [x8]
     18c: ad3a87a0     	stp	q0, q1, [x29, #-0xb0]
     190: ad410101     	ldp	q1, q0, [x8, #0x20]
     194: ad3b83a1     	stp	q1, q0, [x29, #-0x90]
     198: d102c3b4     	sub	x20, x29, #0xb0
     19c: d102c3a0     	sub	x0, x29, #0xb0
     1a0: 9101c2e1     	add	x1, x23, #0x70
<L7>:
     1a4: 94000000     	bl	 <L7>
		00000000000001a4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     1a8: 385b83a8     	ldurb	w8, [x29, #-0x48]
     1ac: f85703a9     	ldur	x9, [x29, #-0x90]
     1b0: 9100a294     	add	x20, x20, #0x28
     1b4: 91010137     	add	x23, x9, #0x40
     1b8: f81703b7     	stur	x23, [x29, #-0x90]
     1bc: 34000208     	cbz	w8,  <L10>
     1c0: 7100811f     	cmp	w8, #0x20
     1c4: 540001c3     	b.lo	 <L10>
     1c8: 52800809     	mov	w9, #0x40               ; =64
     1cc: cb080135     	sub	x21, x9, x8
     1d0: 8b080280     	add	x0, x20, x8
     1d4: 910343e1     	add	x1, sp, #0xd0
     1d8: aa1503e2     	mov	x2, x21
<L8>:
     1dc: 94000000     	bl	 <L8>
		00000000000001dc:  ARM64_RELOC_BRANCH26	_memcpy
     1e0: d102c3a0     	sub	x0, x29, #0xb0
     1e4: aa1403e1     	mov	x1, x20
<L9>:
     1e8: 94000000     	bl	 <L9>
		00000000000001e8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     1ec: 52800008     	mov	w8, #0x0                ; =0
     1f0: 381b83bf     	sturb	wzr, [x29, #-0x48]
     1f4: f85703b7     	ldur	x23, [x29, #-0x90]
     1f8: 14000002     	b	 <L11>
<L10>:
     1fc: d2800015     	mov	x21, #0x0               ; =0
<L11>:
     200: 52800409     	mov	w9, #0x20               ; =32
     204: cb150136     	sub	x22, x9, x21
     208: 8b284280     	add	x0, x20, w8, uxtw
     20c: 8b150301     	add	x1, x24, x21
     210: aa1603e2     	mov	x2, x22
<L12>:
     214: 94000000     	bl	 <L12>
		0000000000000214:  ARM64_RELOC_BRANCH26	_memcpy
     218: 385b83a8     	ldurb	w8, [x29, #-0x48]
     21c: 0b160108     	add	w8, w8, w22
     220: 381b83a8     	sturb	w8, [x29, #-0x48]
     224: 910082e8     	add	x8, x23, #0x20
     228: f81703a8     	stur	x8, [x29, #-0x90]
     22c: d102c3a0     	sub	x0, x29, #0xb0
     230: 910003e1     	mov	x1, sp
<L13>:
     234: 94000000     	bl	 <L13>
		0000000000000234:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     238: ad4007e0     	ldp	q0, q1, [sp]
     23c: ad000660     	stp	q0, q1, [x19]
     240: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
     244: a9594ff4     	ldp	x20, x19, [sp, #0x190]
     248: a95857f6     	ldp	x22, x21, [sp, #0x180]
     24c: a9575ff8     	ldp	x24, x23, [sp, #0x170]
     250: a9566ffc     	ldp	x28, x27, [sp, #0x160]
     254: 9106c3ff     	add	sp, sp, #0x1b0
     258: d65f03c0     	ret

000000000000025c <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     25c: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
     260: a90167fa     	stp	x26, x25, [sp, #0x10]
     264: a9025ff8     	stp	x24, x23, [sp, #0x20]
     268: a90357f6     	stp	x22, x21, [sp, #0x30]
     26c: a9044ff4     	stp	x20, x19, [sp, #0x40]
     270: a9057bfd     	stp	x29, x30, [sp, #0x50]
     274: 910143fd     	add	x29, sp, #0x50
     278: d10903ff     	sub	sp, sp, #0x240
     27c: aa0303f5     	mov	x21, x3
     280: aa0203f6     	mov	x22, x2
     284: aa0003f3     	mov	x19, x0
     288: ad400480     	ldp	q0, q1, [x4]
     28c: ad0007e0     	stp	q0, q1, [sp]
     290: 52800028     	mov	w8, #0x1                ; =1
     294: 3900bfe8     	strb	w8, [sp, #0x2f]
     298: f100803f     	cmp	x1, #0x20
     29c: 54000322     	b.hs	 <L3>
     2a0: aa0103f4     	mov	x20, x1
     2a4: 910383fa     	add	x26, sp, #0xe0
     2a8: 910383e0     	add	x0, sp, #0xe0
     2ac: 910003e1     	mov	x1, sp
<L0>:
     2b0: 94000000     	bl	 <L0>
		00000000000002b0:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
     2b4: 394523e8     	ldrb	w8, [sp, #0x148]
     2b8: 34000508     	cbz	w8,  <L7>
     2bc: 8b0802a9     	add	x9, x21, x8
     2c0: f101013f     	cmp	x9, #0x40
     2c4: 540004a3     	b.lo	 <L7>
     2c8: 52800809     	mov	w9, #0x40               ; =64
     2cc: cb080138     	sub	x24, x9, x8
     2d0: 910383e9     	add	x9, sp, #0xe0
     2d4: 9100a137     	add	x23, x9, #0x28
     2d8: 8b0802e0     	add	x0, x23, x8
     2dc: aa1603e1     	mov	x1, x22
     2e0: aa1803e2     	mov	x2, x24
<L1>:
     2e4: 94000000     	bl	 <L1>
		00000000000002e4:  ARM64_RELOC_BRANCH26	_memcpy
     2e8: 910383e0     	add	x0, sp, #0xe0
     2ec: aa1703e1     	mov	x1, x23
<L2>:
     2f0: 94000000     	bl	 <L2>
		00000000000002f0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     2f4: 52800008     	mov	w8, #0x0                ; =0
     2f8: 390523ff     	strb	wzr, [sp, #0x148]
     2fc: 14000018     	b	 <L8>
<L3>:
     300: 9100c3f9     	add	x25, sp, #0x30
     304: 9100a334     	add	x20, x25, #0x28
     308: 9100c3e0     	add	x0, sp, #0x30
     30c: 910003e1     	mov	x1, sp
<L4>:
     310: 94000000     	bl	 <L4>
		0000000000000310:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
     314: 394263e8     	ldrb	w8, [sp, #0x98]
     318: 340005a8     	cbz	w8,  <L12>
     31c: d24016a9     	eor	x9, x21, #0x3f
     320: eb08013f     	cmp	x9, x8
     324: 54000542     	b.hs	 <L12>
     328: 52800809     	mov	w9, #0x40               ; =64
     32c: cb080137     	sub	x23, x9, x8
     330: 8b080280     	add	x0, x20, x8
     334: aa1603e1     	mov	x1, x22
     338: aa1703e2     	mov	x2, x23
<L5>:
     33c: 94000000     	bl	 <L5>
		000000000000033c:  ARM64_RELOC_BRANCH26	_memcpy
     340: 9100c3e0     	add	x0, sp, #0x30
     344: aa1403e1     	mov	x1, x20
<L6>:
     348: 94000000     	bl	 <L6>
		0000000000000348:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     34c: 52800008     	mov	w8, #0x0                ; =0
     350: 390263ff     	strb	wzr, [sp, #0x98]
     354: 1400001f     	b	 <L13>
<L7>:
     358: d2800018     	mov	x24, #0x0               ; =0
<L8>:
     35c: cb1802b9     	sub	x25, x21, x24
     360: 9100a357     	add	x23, x26, #0x28
     364: 8b2842e0     	add	x0, x23, w8, uxtw
     368: 8b1802c1     	add	x1, x22, x24
     36c: aa1903e2     	mov	x2, x25
<L9>:
     370: 94000000     	bl	 <L9>
		0000000000000370:  ARM64_RELOC_BRANCH26	_memcpy
     374: 394523e8     	ldrb	w8, [sp, #0x148]
     378: f94083e9     	ldr	x9, [sp, #0x100]
     37c: 8b150138     	add	x24, x9, x21
     380: f90083f8     	str	x24, [sp, #0x100]
     384: 2b190108     	adds	w8, w8, w25
     388: 390523e8     	strb	w8, [sp, #0x148]
     38c: 540005a0     	b.eq	 <L17>
     390: 7100fd1f     	cmp	w8, #0x3f
     394: 54000563     	b.lo	 <L17>
     398: 52800809     	mov	w9, #0x40               ; =64
     39c: 4b080135     	sub	w21, w9, w8
     3a0: 8b2842e0     	add	x0, x23, w8, uxtw
     3a4: 9100bfe1     	add	x1, sp, #0x2f
     3a8: aa1503e2     	mov	x2, x21
<L10>:
     3ac: 94000000     	bl	 <L10>
		00000000000003ac:  ARM64_RELOC_BRANCH26	_memcpy
     3b0: 910383e0     	add	x0, sp, #0xe0
     3b4: aa1703e1     	mov	x1, x23
<L11>:
     3b8: 94000000     	bl	 <L11>
		00000000000003b8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     3bc: 52800008     	mov	w8, #0x0                ; =0
     3c0: 390523ff     	strb	wzr, [sp, #0x148]
     3c4: f94083f8     	ldr	x24, [sp, #0x100]
     3c8: 1400001f     	b	 <L18>
<L12>:
     3cc: d2800017     	mov	x23, #0x0               ; =0
<L13>:
     3d0: d10303ba     	sub	x26, x29, #0xc0
     3d4: cb1702b8     	sub	x24, x21, x23
     3d8: 8b284280     	add	x0, x20, w8, uxtw
     3dc: 8b1702c1     	add	x1, x22, x23
     3e0: aa1803e2     	mov	x2, x24
<L14>:
     3e4: 94000000     	bl	 <L14>
		00000000000003e4:  ARM64_RELOC_BRANCH26	_memcpy
     3e8: 394263e8     	ldrb	w8, [sp, #0x98]
     3ec: f9402be9     	ldr	x9, [sp, #0x50]
     3f0: 8b15013b     	add	x27, x9, x21
     3f4: f9002bfb     	str	x27, [sp, #0x50]
     3f8: 2b180108     	adds	w8, w8, w24
     3fc: 390263e8     	strb	w8, [sp, #0x98]
     400: 540008a0     	b.eq	 <L24>
     404: 7100fd1f     	cmp	w8, #0x3f
     408: 54000863     	b.lo	 <L24>
     40c: 52800809     	mov	w9, #0x40               ; =64
     410: 4b080136     	sub	w22, w9, w8
     414: 8b284280     	add	x0, x20, w8, uxtw
     418: 9100bfe1     	add	x1, sp, #0x2f
     41c: aa1603e2     	mov	x2, x22
<L15>:
     420: 94000000     	bl	 <L15>
		0000000000000420:  ARM64_RELOC_BRANCH26	_memcpy
     424: 9100c3e0     	add	x0, sp, #0x30
     428: aa1403e1     	mov	x1, x20
<L16>:
     42c: 94000000     	bl	 <L16>
		000000000000042c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     430: 52800008     	mov	w8, #0x0                ; =0
     434: 390263ff     	strb	wzr, [sp, #0x98]
     438: f9402bfb     	ldr	x27, [sp, #0x50]
     43c: 14000037     	b	 <L25>
<L17>:
     440: d2800015     	mov	x21, #0x0               ; =0
<L18>:
     444: 9100bfe9     	add	x9, sp, #0x2f
     448: 5280002a     	mov	w10, #0x1               ; =1
     44c: cb150156     	sub	x22, x10, x21
     450: 8b2842e0     	add	x0, x23, w8, uxtw
     454: 8b150121     	add	x1, x9, x21
     458: aa1603e2     	mov	x2, x22
<L19>:
     45c: 94000000     	bl	 <L19>
		000000000000045c:  ARM64_RELOC_BRANCH26	_memcpy
     460: 394523e8     	ldrb	w8, [sp, #0x148]
     464: 0b160108     	add	w8, w8, w22
     468: 390523e8     	strb	w8, [sp, #0x148]
     46c: 91000708     	add	x8, x24, #0x1
     470: f90083e8     	str	x8, [sp, #0x100]
     474: 910383f5     	add	x21, sp, #0xe0
     478: d10383b8     	sub	x24, x29, #0xe0
     47c: 910383e0     	add	x0, sp, #0xe0
     480: d10383a1     	sub	x1, x29, #0xe0
<L20>:
     484: 94000000     	bl	 <L20>
		0000000000000484:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     488: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000488:  ARM64_RELOC_PAGE21	l___unnamed_2
     48c: 91000108     	add	x8, x8, #0x0
		000000000000048c:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     490: ad420500     	ldp	q0, q1, [x8, #0x40]
     494: ad3c07a0     	stp	q0, q1, [x29, #-0x80]
     498: 3dc01900     	ldr	q0, [x8, #0x60]
     49c: 3c9a03a0     	stur	q0, [x29, #-0x60]
     4a0: ad400500     	ldp	q0, q1, [x8]
     4a4: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
     4a8: ad410101     	ldp	q1, q0, [x8, #0x20]
     4ac: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
     4b0: d10303b6     	sub	x22, x29, #0xc0
     4b4: d10303a0     	sub	x0, x29, #0xc0
     4b8: 9101c2a1     	add	x1, x21, #0x70
<L21>:
     4bc: 94000000     	bl	 <L21>
		00000000000004bc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     4c0: 385a83a8     	ldurb	w8, [x29, #-0x58]
     4c4: f85603a9     	ldur	x9, [x29, #-0xa0]
     4c8: 9100a2d5     	add	x21, x22, #0x28
     4cc: 91010139     	add	x25, x9, #0x40
     4d0: f81603b9     	stur	x25, [x29, #-0xa0]
     4d4: 34000868     	cbz	w8,  <L31>
     4d8: 7100811f     	cmp	w8, #0x20
     4dc: 54000823     	b.lo	 <L31>
     4e0: 52800809     	mov	w9, #0x40               ; =64
     4e4: cb080136     	sub	x22, x9, x8
     4e8: 8b0802a0     	add	x0, x21, x8
     4ec: d10383a1     	sub	x1, x29, #0xe0
     4f0: aa1603e2     	mov	x2, x22
<L22>:
     4f4: 94000000     	bl	 <L22>
		00000000000004f4:  ARM64_RELOC_BRANCH26	_memcpy
     4f8: d10303a0     	sub	x0, x29, #0xc0
     4fc: aa1503e1     	mov	x1, x21
<L23>:
     500: 94000000     	bl	 <L23>
		0000000000000500:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     504: 52800008     	mov	w8, #0x0                ; =0
     508: 381a83bf     	sturb	wzr, [x29, #-0x58]
     50c: f85603b9     	ldur	x25, [x29, #-0xa0]
     510: 14000035     	b	 <L32>
<L24>:
     514: d2800016     	mov	x22, #0x0               ; =0
<L25>:
     518: 9100a355     	add	x21, x26, #0x28
     51c: 9100bfe9     	add	x9, sp, #0x2f
     520: 5280002a     	mov	w10, #0x1               ; =1
     524: cb160157     	sub	x23, x10, x22
     528: 8b284280     	add	x0, x20, w8, uxtw
     52c: 8b160121     	add	x1, x9, x22
     530: aa1703e2     	mov	x2, x23
<L26>:
     534: 94000000     	bl	 <L26>
		0000000000000534:  ARM64_RELOC_BRANCH26	_memcpy
     538: 394263e8     	ldrb	w8, [sp, #0x98]
     53c: 0b170108     	add	w8, w8, w23
     540: 390263e8     	strb	w8, [sp, #0x98]
     544: 91000768     	add	x8, x27, #0x1
     548: f9002be8     	str	x8, [sp, #0x50]
     54c: d10383b7     	sub	x23, x29, #0xe0
     550: 9100c3e0     	add	x0, sp, #0x30
     554: d10383a1     	sub	x1, x29, #0xe0
<L27>:
     558: 94000000     	bl	 <L27>
		0000000000000558:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     55c: 90000008     	adrp	x8, 0x0 <ltmp0>
		000000000000055c:  ARM64_RELOC_PAGE21	l___unnamed_2
     560: 91000108     	add	x8, x8, #0x0
		0000000000000560:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     564: ad420500     	ldp	q0, q1, [x8, #0x40]
     568: ad3c07a0     	stp	q0, q1, [x29, #-0x80]
     56c: 3dc01900     	ldr	q0, [x8, #0x60]
     570: 3c9a03a0     	stur	q0, [x29, #-0x60]
     574: ad400500     	ldp	q0, q1, [x8]
     578: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
     57c: ad410101     	ldp	q1, q0, [x8, #0x20]
     580: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
     584: d10303a0     	sub	x0, x29, #0xc0
     588: 9101c321     	add	x1, x25, #0x70
<L28>:
     58c: 94000000     	bl	 <L28>
		000000000000058c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     590: 385a83a8     	ldurb	w8, [x29, #-0x58]
     594: f85603a9     	ldur	x9, [x29, #-0xa0]
     598: 91010138     	add	x24, x9, #0x40
     59c: f81603b8     	stur	x24, [x29, #-0xa0]
     5a0: 34000488     	cbz	w8,  <L36>
     5a4: 7100811f     	cmp	w8, #0x20
     5a8: 54000443     	b.lo	 <L36>
     5ac: 52800809     	mov	w9, #0x40               ; =64
     5b0: cb080134     	sub	x20, x9, x8
     5b4: 8b0802a0     	add	x0, x21, x8
     5b8: d10383a1     	sub	x1, x29, #0xe0
     5bc: aa1403e2     	mov	x2, x20
<L29>:
     5c0: 94000000     	bl	 <L29>
		00000000000005c0:  ARM64_RELOC_BRANCH26	_memcpy
     5c4: d10303a0     	sub	x0, x29, #0xc0
     5c8: aa1503e1     	mov	x1, x21
<L30>:
     5cc: 94000000     	bl	 <L30>
		00000000000005cc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     5d0: 52800008     	mov	w8, #0x0                ; =0
     5d4: 381a83bf     	sturb	wzr, [x29, #-0x58]
     5d8: f85603b8     	ldur	x24, [x29, #-0xa0]
     5dc: 14000016     	b	 <L37>
<L31>:
     5e0: d2800016     	mov	x22, #0x0               ; =0
<L32>:
     5e4: 52800409     	mov	w9, #0x20               ; =32
     5e8: cb160137     	sub	x23, x9, x22
     5ec: 8b2842a0     	add	x0, x21, w8, uxtw
     5f0: 8b160301     	add	x1, x24, x22
     5f4: aa1703e2     	mov	x2, x23
<L33>:
     5f8: 94000000     	bl	 <L33>
		00000000000005f8:  ARM64_RELOC_BRANCH26	_memcpy
     5fc: 385a83a8     	ldurb	w8, [x29, #-0x58]
     600: 0b170108     	add	w8, w8, w23
     604: 381a83a8     	sturb	w8, [x29, #-0x58]
     608: 91008328     	add	x8, x25, #0x20
     60c: f81603a8     	stur	x8, [x29, #-0xa0]
     610: d10303a0     	sub	x0, x29, #0xc0
     614: d10403a1     	sub	x1, x29, #0x100
<L34>:
     618: 94000000     	bl	 <L34>
		0000000000000618:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     61c: d10403a1     	sub	x1, x29, #0x100
     620: aa1303e0     	mov	x0, x19
     624: aa1403e2     	mov	x2, x20
<L35>:
     628: 94000000     	bl	 <L35>
		0000000000000628:  ARM64_RELOC_BRANCH26	_memcpy
     62c: 14000010     	b	 <L40>
<L36>:
     630: d2800014     	mov	x20, #0x0               ; =0
<L37>:
     634: 52800409     	mov	w9, #0x20               ; =32
     638: cb140136     	sub	x22, x9, x20
     63c: 8b2842a0     	add	x0, x21, w8, uxtw
     640: 8b1402e1     	add	x1, x23, x20
     644: aa1603e2     	mov	x2, x22
<L38>:
     648: 94000000     	bl	 <L38>
		0000000000000648:  ARM64_RELOC_BRANCH26	_memcpy
     64c: 385a83a8     	ldurb	w8, [x29, #-0x58]
     650: 0b160108     	add	w8, w8, w22
     654: 381a83a8     	sturb	w8, [x29, #-0x58]
     658: 91008308     	add	x8, x24, #0x20
     65c: f81603a8     	stur	x8, [x29, #-0xa0]
     660: d10303a0     	sub	x0, x29, #0xc0
     664: aa1303e1     	mov	x1, x19
<L39>:
     668: 94000000     	bl	 <L39>
		0000000000000668:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L40>:
     66c: 910903ff     	add	sp, sp, #0x240
     670: a9457bfd     	ldp	x29, x30, [sp, #0x50]
     674: a9444ff4     	ldp	x20, x19, [sp, #0x40]
     678: a94357f6     	ldp	x22, x21, [sp, #0x30]
     67c: a9425ff8     	ldp	x24, x23, [sp, #0x20]
     680: a94167fa     	ldp	x26, x25, [sp, #0x10]
     684: a8c66ffc     	ldp	x28, x27, [sp], #0x60
     688: d65f03c0     	ret

000000000000068c <_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>:
     68c: d10443ff     	sub	sp, sp, #0x110
     690: a90f4ff4     	stp	x20, x19, [sp, #0xf0]
     694: a9107bfd     	stp	x29, x30, [sp, #0x100]
     698: 910403fd     	add	x29, sp, #0x100
     69c: aa0003f3     	mov	x19, x0
     6a0: 4f02e780     	movi.16b	v0, #0x5c
     6a4: ad400821     	ldp	q1, q2, [x1]
     6a8: 6e201c23     	eor.16b	v3, v1, v0
     6ac: 6e201c44     	eor.16b	v4, v2, v0
     6b0: ad0403e4     	stp	q4, q0, [sp, #0x80]
     6b4: 3d802be0     	str	q0, [sp, #0xa0]
     6b8: 4f01e6c0     	movi.16b	v0, #0x36
     6bc: 6e201c21     	eor.16b	v1, v1, v0
     6c0: 6e201c42     	eor.16b	v2, v2, v0
     6c4: ad3d8ba1     	stp	q1, q2, [x29, #-0x50]
     6c8: ad3e83a0     	stp	q0, q0, [x29, #-0x30]
     6cc: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000006cc:  ARM64_RELOC_PAGE21	l___unnamed_2
     6d0: 91000108     	add	x8, x8, #0x0
		00000000000006d0:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     6d4: ad420500     	ldp	q0, q1, [x8, #0x40]
     6d8: ad0207e0     	stp	q0, q1, [sp, #0x40]
     6dc: 3dc01900     	ldr	q0, [x8, #0x60]
     6e0: ad030fe0     	stp	q0, q3, [sp, #0x60]
     6e4: ad400500     	ldp	q0, q1, [x8]
     6e8: ad0007e0     	stp	q0, q1, [sp]
     6ec: ad410101     	ldp	q1, q0, [x8, #0x20]
     6f0: ad0103e1     	stp	q1, q0, [sp, #0x20]
     6f4: 910003e0     	mov	x0, sp
     6f8: d10143a1     	sub	x1, x29, #0x50
<L0>:
     6fc: 94000000     	bl	 <L0>
		00000000000006fc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     700: f94013e8     	ldr	x8, [sp, #0x20]
     704: 91010108     	add	x8, x8, #0x40
     708: f90013e8     	str	x8, [sp, #0x20]
     70c: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     710: ad040660     	stp	q0, q1, [x19, #0x80]
     714: 3dc02be0     	ldr	q0, [sp, #0xa0]
     718: 3d802a60     	str	q0, [x19, #0xa0]
     71c: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     720: ad020660     	stp	q0, q1, [x19, #0x40]
     724: ad4303e1     	ldp	q1, q0, [sp, #0x60]
     728: ad030261     	stp	q1, q0, [x19, #0x60]
     72c: ad4007e0     	ldp	q0, q1, [sp]
     730: ad000660     	stp	q0, q1, [x19]
     734: ad4103e1     	ldp	q1, q0, [sp, #0x20]
     738: ad010261     	stp	q1, q0, [x19, #0x20]
     73c: a9507bfd     	ldp	x29, x30, [sp, #0x100]
     740: a94f4ff4     	ldp	x20, x19, [sp, #0xf0]
     744: 910443ff     	add	sp, sp, #0x110
     748: d65f03c0     	ret

000000000000074c <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     74c: a9bd57f6     	stp	x22, x21, [sp, #-0x30]!
     750: a9014ff4     	stp	x20, x19, [sp, #0x10]
     754: a9027bfd     	stp	x29, x30, [sp, #0x20]
     758: 910083fd     	add	x29, sp, #0x20
     75c: aa0103f3     	mov	x19, x1
     760: aa0003f4     	mov	x20, x0
     764: 9100a015     	add	x21, x0, #0x28
     768: 3941a008     	ldrb	w8, [x0, #0x68]
     76c: 52800809     	mov	w9, #0x40               ; =64
     770: cb080121     	sub	x1, x9, x8
     774: 8b0802a0     	add	x0, x21, x8
<L0>:
     778: 94000000     	bl	 <L0>
		0000000000000778:  ARM64_RELOC_BRANCH26	_bzero
     77c: 3941a288     	ldrb	w8, [x20, #0x68]
     780: 52801009     	mov	w9, #0x80               ; =128
     784: 38286aa9     	strb	w9, [x21, x8]
     788: 3941a288     	ldrb	w8, [x20, #0x68]
     78c: 11000509     	add	w9, w8, #0x1
     790: 3901a289     	strb	w9, [x20, #0x68]
     794: 7100dd1f     	cmp	w8, #0x37
     798: 54000109     	b.ls	 <L2>
     79c: aa1403e0     	mov	x0, x20
     7a0: aa1503e1     	mov	x1, x21
<L1>:
     7a4: 94000000     	bl	 <L1>
		00000000000007a4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     7a8: f9001abf     	str	xzr, [x21, #0x30]
     7ac: 6f00e400     	movi.2d	v0, #0000000000000000
     7b0: ad0082a0     	stp	q0, q0, [x21, #0x10]
     7b4: 3d8002a0     	str	q0, [x21]
<L2>:
     7b8: f9401288     	ldr	x8, [x20, #0x20]
     7bc: 531d7109     	lsl	w9, w8, #3
     7c0: 39019e89     	strb	w9, [x20, #0x67]
     7c4: d345fd09     	lsr	x9, x8, #5
     7c8: 39019a89     	strb	w9, [x20, #0x66]
     7cc: d34dfd09     	lsr	x9, x8, #13
     7d0: 39019689     	strb	w9, [x20, #0x65]
     7d4: d355fd09     	lsr	x9, x8, #21
     7d8: 39019289     	strb	w9, [x20, #0x64]
     7dc: d35dfd09     	lsr	x9, x8, #29
     7e0: 39018e89     	strb	w9, [x20, #0x63]
     7e4: d365fd09     	lsr	x9, x8, #37
     7e8: 39018a89     	strb	w9, [x20, #0x62]
     7ec: d36dfd09     	lsr	x9, x8, #45
     7f0: 39018689     	strb	w9, [x20, #0x61]
     7f4: d375fd08     	lsr	x8, x8, #53
     7f8: 39018288     	strb	w8, [x20, #0x60]
     7fc: aa1403e0     	mov	x0, x20
     800: aa1503e1     	mov	x1, x21
<L3>:
     804: 94000000     	bl	 <L3>
		0000000000000804:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     808: b9400288     	ldr	w8, [x20]
     80c: 5ac00908     	rev	w8, w8
     810: b9000268     	str	w8, [x19]
     814: b9400688     	ldr	w8, [x20, #0x4]
     818: 5ac00908     	rev	w8, w8
     81c: b9000668     	str	w8, [x19, #0x4]
     820: b9400a88     	ldr	w8, [x20, #0x8]
     824: 5ac00908     	rev	w8, w8
     828: b9000a68     	str	w8, [x19, #0x8]
     82c: b9400e88     	ldr	w8, [x20, #0xc]
     830: 5ac00908     	rev	w8, w8
     834: b9000e68     	str	w8, [x19, #0xc]
     838: b9401288     	ldr	w8, [x20, #0x10]
     83c: 5ac00908     	rev	w8, w8
     840: b9001268     	str	w8, [x19, #0x10]
     844: b9401688     	ldr	w8, [x20, #0x14]
     848: 5ac00908     	rev	w8, w8
     84c: b9001668     	str	w8, [x19, #0x14]
     850: b9401a88     	ldr	w8, [x20, #0x18]
     854: 5ac00908     	rev	w8, w8
     858: b9001a68     	str	w8, [x19, #0x18]
     85c: b9401e88     	ldr	w8, [x20, #0x1c]
     860: 5ac00908     	rev	w8, w8
     864: b9001e68     	str	w8, [x19, #0x1c]
     868: a9427bfd     	ldp	x29, x30, [sp, #0x20]
     86c: a9414ff4     	ldp	x20, x19, [sp, #0x10]
     870: a8c357f6     	ldp	x22, x21, [sp], #0x30
     874: d65f03c0     	ret

0000000000000878 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     878: a9bf7bfd     	stp	x29, x30, [sp, #-0x10]!
     87c: 910003fd     	mov	x29, sp
     880: ad400420     	ldp	q0, q1, [x1]
     884: 6e200803     	rev32.16b	v3, v0
     888: 6e200824     	rev32.16b	v4, v1
     88c: ad410420     	ldp	q0, q1, [x1, #0x20]
     890: 6e200806     	rev32.16b	v6, v0
     894: 6e200825     	rev32.16b	v5, v1
     898: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000898:  ARM64_RELOC_PAGE21	lCPI5_0
     89c: 3dc00100     	ldr	q0, [x8]
		000000000000089c:  ARM64_RELOC_PAGEOFF12	lCPI5_0
     8a0: 4ea08467     	add.4s	v7, v3, v0
     8a4: ad400402     	ldp	q2, q1, [x0]
     8a8: 4ea21c40     	mov.16b	v0, v2
     8ac: 5e074022     	sha256h.4s	q2, q1, v7
     8b0: 5e075001     	sha256h2.4s	q1, q0, v7
     8b4: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008b4:  ARM64_RELOC_PAGE21	lCPI5_1
     8b8: 3dc00100     	ldr	q0, [x8]
		00000000000008b8:  ARM64_RELOC_PAGEOFF12	lCPI5_1
     8bc: 4ea08487     	add.4s	v7, v4, v0
     8c0: 4ea21c40     	mov.16b	v0, v2
     8c4: 5e074022     	sha256h.4s	q2, q1, v7
     8c8: 5e075001     	sha256h2.4s	q1, q0, v7
     8cc: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008cc:  ARM64_RELOC_PAGE21	lCPI5_2
     8d0: 3dc00100     	ldr	q0, [x8]
		00000000000008d0:  ARM64_RELOC_PAGEOFF12	lCPI5_2
     8d4: 4ea084c7     	add.4s	v7, v6, v0
     8d8: 4ea21c40     	mov.16b	v0, v2
     8dc: 5e074022     	sha256h.4s	q2, q1, v7
     8e0: 5e075001     	sha256h2.4s	q1, q0, v7
     8e4: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008e4:  ARM64_RELOC_PAGE21	lCPI5_3
     8e8: 3dc00100     	ldr	q0, [x8]
		00000000000008e8:  ARM64_RELOC_PAGEOFF12	lCPI5_3
     8ec: 4ea084a7     	add.4s	v7, v5, v0
     8f0: 4ea21c40     	mov.16b	v0, v2
     8f4: 5e074022     	sha256h.4s	q2, q1, v7
     8f8: 5e075001     	sha256h2.4s	q1, q0, v7
     8fc: 5e282883     	sha256su0.4s	v3, v4
     900: 5e0560c3     	sha256su1.4s	v3, v6, v5
     904: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000904:  ARM64_RELOC_PAGE21	lCPI5_4
     908: 3dc00100     	ldr	q0, [x8]
		0000000000000908:  ARM64_RELOC_PAGEOFF12	lCPI5_4
     90c: 4ea08467     	add.4s	v7, v3, v0
     910: 4ea21c40     	mov.16b	v0, v2
     914: 5e074022     	sha256h.4s	q2, q1, v7
     918: 5e075001     	sha256h2.4s	q1, q0, v7
     91c: 5e2828c4     	sha256su0.4s	v4, v6
     920: 5e0360a4     	sha256su1.4s	v4, v5, v3
     924: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000924:  ARM64_RELOC_PAGE21	lCPI5_5
     928: 3dc00100     	ldr	q0, [x8]
		0000000000000928:  ARM64_RELOC_PAGEOFF12	lCPI5_5
     92c: 4ea08487     	add.4s	v7, v4, v0
     930: 4ea21c40     	mov.16b	v0, v2
     934: 5e074022     	sha256h.4s	q2, q1, v7
     938: 5e075001     	sha256h2.4s	q1, q0, v7
     93c: 5e2828a6     	sha256su0.4s	v6, v5
     940: 5e046066     	sha256su1.4s	v6, v3, v4
     944: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000944:  ARM64_RELOC_PAGE21	lCPI5_6
     948: 3dc00100     	ldr	q0, [x8]
		0000000000000948:  ARM64_RELOC_PAGEOFF12	lCPI5_6
     94c: 4ea084c7     	add.4s	v7, v6, v0
     950: 4ea21c40     	mov.16b	v0, v2
     954: 5e074022     	sha256h.4s	q2, q1, v7
     958: 5e075001     	sha256h2.4s	q1, q0, v7
     95c: 5e282865     	sha256su0.4s	v5, v3
     960: 5e066085     	sha256su1.4s	v5, v4, v6
     964: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000964:  ARM64_RELOC_PAGE21	lCPI5_7
     968: 3dc00100     	ldr	q0, [x8]
		0000000000000968:  ARM64_RELOC_PAGEOFF12	lCPI5_7
     96c: 4ea084a7     	add.4s	v7, v5, v0
     970: 4ea21c40     	mov.16b	v0, v2
     974: 5e074022     	sha256h.4s	q2, q1, v7
     978: 5e075001     	sha256h2.4s	q1, q0, v7
     97c: 5e282883     	sha256su0.4s	v3, v4
     980: 5e0560c3     	sha256su1.4s	v3, v6, v5
     984: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000984:  ARM64_RELOC_PAGE21	lCPI5_8
     988: 3dc00100     	ldr	q0, [x8]
		0000000000000988:  ARM64_RELOC_PAGEOFF12	lCPI5_8
     98c: 4ea08467     	add.4s	v7, v3, v0
     990: 4ea21c40     	mov.16b	v0, v2
     994: 5e074022     	sha256h.4s	q2, q1, v7
     998: 5e075001     	sha256h2.4s	q1, q0, v7
     99c: 5e2828c4     	sha256su0.4s	v4, v6
     9a0: 5e0360a4     	sha256su1.4s	v4, v5, v3
     9a4: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000009a4:  ARM64_RELOC_PAGE21	lCPI5_9
     9a8: 3dc00100     	ldr	q0, [x8]
		00000000000009a8:  ARM64_RELOC_PAGEOFF12	lCPI5_9
     9ac: 4ea08487     	add.4s	v7, v4, v0
     9b0: 4ea21c40     	mov.16b	v0, v2
     9b4: 5e074022     	sha256h.4s	q2, q1, v7
     9b8: 5e075001     	sha256h2.4s	q1, q0, v7
     9bc: 5e2828a6     	sha256su0.4s	v6, v5
     9c0: 5e046066     	sha256su1.4s	v6, v3, v4
     9c4: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000009c4:  ARM64_RELOC_PAGE21	lCPI5_10
     9c8: 3dc00100     	ldr	q0, [x8]
		00000000000009c8:  ARM64_RELOC_PAGEOFF12	lCPI5_10
     9cc: 4ea084c7     	add.4s	v7, v6, v0
     9d0: 4ea21c40     	mov.16b	v0, v2
     9d4: 5e074022     	sha256h.4s	q2, q1, v7
     9d8: 5e075001     	sha256h2.4s	q1, q0, v7
     9dc: 5e282865     	sha256su0.4s	v5, v3
     9e0: 5e066085     	sha256su1.4s	v5, v4, v6
     9e4: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000009e4:  ARM64_RELOC_PAGE21	lCPI5_11
     9e8: 3dc00100     	ldr	q0, [x8]
		00000000000009e8:  ARM64_RELOC_PAGEOFF12	lCPI5_11
     9ec: 4ea084a7     	add.4s	v7, v5, v0
     9f0: 4ea21c40     	mov.16b	v0, v2
     9f4: 5e074022     	sha256h.4s	q2, q1, v7
     9f8: 5e075001     	sha256h2.4s	q1, q0, v7
     9fc: 5e282883     	sha256su0.4s	v3, v4
     a00: 5e0560c3     	sha256su1.4s	v3, v6, v5
     a04: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a04:  ARM64_RELOC_PAGE21	lCPI5_12
     a08: 3dc00100     	ldr	q0, [x8]
		0000000000000a08:  ARM64_RELOC_PAGEOFF12	lCPI5_12
     a0c: 4ea08467     	add.4s	v7, v3, v0
     a10: 4ea21c40     	mov.16b	v0, v2
     a14: 5e074022     	sha256h.4s	q2, q1, v7
     a18: 5e075001     	sha256h2.4s	q1, q0, v7
     a1c: 5e2828c4     	sha256su0.4s	v4, v6
     a20: 5e0360a4     	sha256su1.4s	v4, v5, v3
     a24: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a24:  ARM64_RELOC_PAGE21	lCPI5_13
     a28: 3dc00100     	ldr	q0, [x8]
		0000000000000a28:  ARM64_RELOC_PAGEOFF12	lCPI5_13
     a2c: 4ea08487     	add.4s	v7, v4, v0
     a30: 4ea21c40     	mov.16b	v0, v2
     a34: 5e074022     	sha256h.4s	q2, q1, v7
     a38: 5e075001     	sha256h2.4s	q1, q0, v7
     a3c: 5e2828a6     	sha256su0.4s	v6, v5
     a40: 5e046066     	sha256su1.4s	v6, v3, v4
     a44: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a44:  ARM64_RELOC_PAGE21	lCPI5_14
     a48: 3dc00100     	ldr	q0, [x8]
		0000000000000a48:  ARM64_RELOC_PAGEOFF12	lCPI5_14
     a4c: 4ea084c7     	add.4s	v7, v6, v0
     a50: 4ea21c40     	mov.16b	v0, v2
     a54: 5e074022     	sha256h.4s	q2, q1, v7
     a58: 5e075001     	sha256h2.4s	q1, q0, v7
     a5c: 5e282865     	sha256su0.4s	v5, v3
     a60: 5e066085     	sha256su1.4s	v5, v4, v6
     a64: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a64:  ARM64_RELOC_PAGE21	lCPI5_15
     a68: 3dc00100     	ldr	q0, [x8]
		0000000000000a68:  ARM64_RELOC_PAGEOFF12	lCPI5_15
     a6c: 4ea084a3     	add.4s	v3, v5, v0
     a70: 4ea21c40     	mov.16b	v0, v2
     a74: 5e034022     	sha256h.4s	q2, q1, v3
     a78: 5e035001     	sha256h2.4s	q1, q0, v3
     a7c: ad400c00     	ldp	q0, q3, [x0]
     a80: 4ea08440     	add.4s	v0, v2, v0
     a84: 4ea18461     	add.4s	v1, v3, v1
     a88: ad000400     	stp	q0, q1, [x0]
     a8c: a8c17bfd     	ldp	x29, x30, [sp], #0x10
     a90: d65f03c0     	ret

0000000000000a94 <_audit_master256>:
     a94: d105c3ff     	sub	sp, sp, #0x170
     a98: a9154ff4     	stp	x20, x19, [sp, #0x150]
     a9c: a9167bfd     	stp	x29, x30, [sp, #0x160]
     aa0: 910583fd     	add	x29, sp, #0x160
     aa4: aa0103f3     	mov	x19, x1
     aa8: aa0003e4     	mov	x4, x0
     aac: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000aac:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
     ab0: 91000108     	add	x8, x8, #0x0
		0000000000000ab0:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
     ab4: ad400500     	ldp	q0, q1, [x8]
     ab8: 3c8513e0     	stur	q0, [sp, #0x51]
     abc: 52840008     	mov	w8, #0x2000             ; =8192
     ac0: 790083e8     	strh	w8, [sp, #0x40]
     ac4: 528001a8     	mov	w8, #0xd                ; =13
     ac8: 39010be8     	strb	w8, [sp, #0x42]
     acc: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000acc:  ARM64_RELOC_PAGE21	l___unnamed_1
     ad0: 91000108     	add	x8, x8, #0x0
		0000000000000ad0:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
     ad4: f9400109     	ldr	x9, [x8]
     ad8: f80433e9     	stur	x9, [sp, #0x43]
     adc: f8405108     	ldur	x8, [x8, #0x5]
     ae0: f90027e8     	str	x8, [sp, #0x48]
     ae4: 52800408     	mov	w8, #0x20               ; =32
     ae8: 390143e8     	strb	w8, [sp, #0x50]
     aec: 3c8613e1     	stur	q1, [sp, #0x61]
     af0: 910083e0     	add	x0, sp, #0x20
     af4: 910103e2     	add	x2, sp, #0x40
     af8: 52800401     	mov	w1, #0x20               ; =32
     afc: 52800623     	mov	w3, #0x31               ; =49
<L0>:
     b00: 94000000     	bl	 <L0>
		0000000000000b00:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
     b04: 90000002     	adrp	x2, 0x0 <ltmp0>
		0000000000000b04:  ARM64_RELOC_PAGE21	_memx.Array(32).zero
     b08: 91000042     	add	x2, x2, #0x0
		0000000000000b08:  ARM64_RELOC_PAGEOFF12	_memx.Array(32).zero
     b0c: 910003e0     	mov	x0, sp
     b10: 910083e1     	add	x1, sp, #0x20
<L1>:
     b14: 94000000     	bl	 <L1>
		0000000000000b14:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
     b18: 6f00e400     	movi.2d	v0, #0000000000000000
     b1c: 3d800fe0     	str	q0, [sp, #0x30]
     b20: 3d800be0     	str	q0, [sp, #0x20]
     b24: ad4007e0     	ldp	q0, q1, [sp]
     b28: ad000660     	stp	q0, q1, [x19]
     b2c: a9567bfd     	ldp	x29, x30, [sp, #0x160]
     b30: a9554ff4     	ldp	x20, x19, [sp, #0x150]
     b34: 9105c3ff     	add	sp, sp, #0x170
     b38: d65f03c0     	ret

0000000000000b3c <_audit_key256>:
     b3c: d104c3ff     	sub	sp, sp, #0x130
     b40: a9116ffc     	stp	x28, x27, [sp, #0x110]
     b44: a9127bfd     	stp	x29, x30, [sp, #0x120]
     b48: 910483fd     	add	x29, sp, #0x120
     b4c: aa0003e4     	mov	x4, x0
     b50: 52820008     	mov	w8, #0x1000             ; =4096
     b54: 79000be8     	strh	w8, [sp, #0x4]
     b58: 52800128     	mov	w8, #0x9                ; =9
     b5c: 39001be8     	strb	w8, [sp, #0x6]
     b60: 52800f28     	mov	w8, #0x79               ; =121
     b64: 7800f3e8     	sturh	w8, [sp, #0xf]
     b68: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000b68:  ARM64_RELOC_PAGE21	l___unnamed_3
     b6c: 91000108     	add	x8, x8, #0x0
		0000000000000b6c:  ARM64_RELOC_PAGEOFF12	l___unnamed_3
     b70: f9400108     	ldr	x8, [x8]
     b74: f80073e8     	stur	x8, [sp, #0x7]
     b78: 910013e2     	add	x2, sp, #0x4
     b7c: aa0103e0     	mov	x0, x1
     b80: 52800201     	mov	w1, #0x10               ; =16
     b84: 528001a3     	mov	w3, #0xd                ; =13
<L0>:
     b88: 94000000     	bl	 <L0>
		0000000000000b88:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
     b8c: a9527bfd     	ldp	x29, x30, [sp, #0x120]
     b90: a9516ffc     	ldp	x28, x27, [sp, #0x110]
     b94: 9104c3ff     	add	sp, sp, #0x130
     b98: d65f03c0     	ret

0000000000000b9c <_audit_handshake384>:
     b9c: d10683ff     	sub	sp, sp, #0x1a0
     ba0: a9176ffc     	stp	x28, x27, [sp, #0x170]
     ba4: a9184ff4     	stp	x20, x19, [sp, #0x180]
     ba8: a9197bfd     	stp	x29, x30, [sp, #0x190]
     bac: 910643fd     	add	x29, sp, #0x190
     bb0: aa0203f3     	mov	x19, x2
     bb4: aa0103f4     	mov	x20, x1
     bb8: aa0003e4     	mov	x4, x0
     bbc: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000bbc:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
     bc0: 91000108     	add	x8, x8, #0x0
		0000000000000bc0:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
     bc4: ad400500     	ldp	q0, q1, [x8]
     bc8: 3c8713e0     	stur	q0, [sp, #0x71]
     bcc: 52860009     	mov	w9, #0x3000             ; =12288
     bd0: 7900c3e9     	strh	w9, [sp, #0x60]
     bd4: 528001a9     	mov	w9, #0xd                ; =13
     bd8: 39018be9     	strb	w9, [sp, #0x62]
     bdc: 90000009     	adrp	x9, 0x0 <ltmp0>
		0000000000000bdc:  ARM64_RELOC_PAGE21	l___unnamed_1
     be0: 91000129     	add	x9, x9, #0x0
		0000000000000be0:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
     be4: f940012a     	ldr	x10, [x9]
     be8: f80633ea     	stur	x10, [sp, #0x63]
     bec: 910183ea     	add	x10, sp, #0x60
     bf0: f8405129     	ldur	x9, [x9, #0x5]
     bf4: f90037e9     	str	x9, [sp, #0x68]
     bf8: 52800609     	mov	w9, #0x30               ; =48
     bfc: 3901c3e9     	strb	w9, [sp, #0x70]
     c00: 3c821141     	stur	q1, [x10, #0x21]
     c04: 3dc00900     	ldr	q0, [x8, #0x20]
     c08: 3c831140     	stur	q0, [x10, #0x31]
     c0c: 9100c3e0     	add	x0, sp, #0x30
     c10: 910183e2     	add	x2, sp, #0x60
     c14: 52800601     	mov	w1, #0x30               ; =48
     c18: 52800823     	mov	w3, #0x41               ; =65
<L0>:
     c1c: 94000000     	bl	 <L0>
		0000000000000c1c:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
     c20: 910003e0     	mov	x0, sp
     c24: 9100c3e1     	add	x1, sp, #0x30
     c28: aa1403e2     	mov	x2, x20
<L1>:
     c2c: 94000000     	bl	 <L1>
		0000000000000c2c:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
     c30: 6f00e400     	movi.2d	v0, #0000000000000000
     c34: 3d8017e0     	str	q0, [sp, #0x50]
     c38: 3d8013e0     	str	q0, [sp, #0x40]
     c3c: 3d800fe0     	str	q0, [sp, #0x30]
     c40: ad4007e0     	ldp	q0, q1, [sp]
     c44: ad000660     	stp	q0, q1, [x19]
     c48: 3dc00be0     	ldr	q0, [sp, #0x20]
     c4c: 3d800a60     	str	q0, [x19, #0x20]
     c50: a9597bfd     	ldp	x29, x30, [sp, #0x190]
     c54: a9584ff4     	ldp	x20, x19, [sp, #0x180]
     c58: a9576ffc     	ldp	x28, x27, [sp, #0x170]
     c5c: 910683ff     	add	sp, sp, #0x1a0
     c60: d65f03c0     	ret

0000000000000c64 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
     c64: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
     c68: a90167fa     	stp	x26, x25, [sp, #0x10]
     c6c: a9025ff8     	stp	x24, x23, [sp, #0x20]
     c70: a90357f6     	stp	x22, x21, [sp, #0x30]
     c74: a9044ff4     	stp	x20, x19, [sp, #0x40]
     c78: a9057bfd     	stp	x29, x30, [sp, #0x50]
     c7c: 910143fd     	add	x29, sp, #0x50
     c80: d10e03ff     	sub	sp, sp, #0x380
     c84: aa0203f4     	mov	x20, x2
     c88: aa0003f3     	mov	x19, x0
     c8c: ad400420     	ldp	q0, q1, [x1]
     c90: 3dc00822     	ldr	q2, [x1, #0x20]
     c94: 910443f7     	add	x23, sp, #0x110
     c98: 4f02e783     	movi.16b	v3, #0x5c
     c9c: 6e231c04     	eor.16b	v4, v0, v3
     ca0: 6e231c25     	eor.16b	v5, v1, v3
     ca4: 6e231c46     	eor.16b	v6, v2, v3
     ca8: ad0f97e4     	stp	q4, q5, [sp, #0x1f0]
     cac: ad108fe6     	stp	q6, q3, [sp, #0x210]
     cb0: ad118fe3     	stp	q3, q3, [sp, #0x230]
     cb4: ad128fe3     	stp	q3, q3, [sp, #0x250]
     cb8: 4f01e6c3     	movi.16b	v3, #0x36
     cbc: 6e231c00     	eor.16b	v0, v0, v3
     cc0: 6e231c21     	eor.16b	v1, v1, v3
     cc4: 6e231c42     	eor.16b	v2, v2, v3
     cc8: ad1507e0     	stp	q0, q1, [sp, #0x2a0]
     ccc: ad160fe2     	stp	q2, q3, [sp, #0x2c0]
     cd0: ad170fe3     	stp	q3, q3, [sp, #0x2e0]
     cd4: ad180fe3     	stp	q3, q3, [sp, #0x300]
     cd8: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000cd8:  ARM64_RELOC_PAGE21	l___unnamed_4
     cdc: 91000108     	add	x8, x8, #0x0
		0000000000000cdc:  ARM64_RELOC_PAGEOFF12	l___unnamed_4
     ce0: ad450500     	ldp	q0, q1, [x8, #0xa0]
     ce4: ad0603e1     	stp	q1, q0, [sp, #0xc0]
     ce8: ad0d87e0     	stp	q0, q1, [sp, #0x1b0]
     cec: ad460500     	ldp	q0, q1, [x8, #0xc0]
     cf0: ad0503e1     	stp	q1, q0, [sp, #0xa0]
     cf4: ad0e87e0     	stp	q0, q1, [sp, #0x1d0]
     cf8: ad430500     	ldp	q0, q1, [x8, #0x60]
     cfc: ad0403e1     	stp	q1, q0, [sp, #0x80]
     d00: ad0b87e0     	stp	q0, q1, [sp, #0x170]
     d04: ad440500     	ldp	q0, q1, [x8, #0x80]
     d08: ad0303e1     	stp	q1, q0, [sp, #0x60]
     d0c: ad0c87e0     	stp	q0, q1, [sp, #0x190]
     d10: ad410500     	ldp	q0, q1, [x8, #0x20]
     d14: ad0203e1     	stp	q1, q0, [sp, #0x40]
     d18: ad0987e0     	stp	q0, q1, [sp, #0x130]
     d1c: ad420500     	ldp	q0, q1, [x8, #0x40]
     d20: 3d800fe0     	str	q0, [sp, #0x30]
     d24: ad0a87e0     	stp	q0, q1, [sp, #0x150]
     d28: 3d8007e1     	str	q1, [sp, #0x10]
     d2c: ad400500     	ldp	q0, q1, [x8]
     d30: 3d800be0     	str	q0, [sp, #0x20]
     d34: ad0887e0     	stp	q0, q1, [sp, #0x110]
     d38: 3d8003e1     	str	q1, [sp]
     d3c: 910a83f8     	add	x24, sp, #0x2a0
     d40: 910443e0     	add	x0, sp, #0x110
     d44: 910a83e1     	add	x1, sp, #0x2a0
<L0>:
     d48: 94000000     	bl	 <L0>
		0000000000000d48:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     d4c: a95123e9     	ldp	x9, x8, [sp, #0x110]
     d50: b102013a     	adds	x26, x9, #0x80
     d54: 9a883519     	cinc	x25, x8, hs
     d58: a91167fa     	stp	x26, x25, [sp, #0x110]
     d5c: 394783e8     	ldrb	w8, [sp, #0x1e0]
     d60: 34000248     	cbz	w8,  <L3>
     d64: 7101411f     	cmp	w8, #0x50
     d68: 54000203     	b.lo	 <L3>
     d6c: 52801009     	mov	w9, #0x80               ; =128
     d70: cb080135     	sub	x21, x9, x8
     d74: 910443e9     	add	x9, sp, #0x110
     d78: 91014136     	add	x22, x9, #0x50
     d7c: 8b0802c0     	add	x0, x22, x8
     d80: aa1403e1     	mov	x1, x20
     d84: aa1503e2     	mov	x2, x21
<L1>:
     d88: 94000000     	bl	 <L1>
		0000000000000d88:  ARM64_RELOC_BRANCH26	_memcpy
     d8c: 910443e0     	add	x0, sp, #0x110
     d90: aa1603e1     	mov	x1, x22
<L2>:
     d94: 94000000     	bl	 <L2>
		0000000000000d94:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     d98: 52800008     	mov	w8, #0x0                ; =0
     d9c: 390783ff     	strb	wzr, [sp, #0x1e0]
     da0: a95167fa     	ldp	x26, x25, [sp, #0x110]
     da4: 14000002     	b	 <L4>
<L3>:
     da8: d2800015     	mov	x21, #0x0               ; =0
<L4>:
     dac: 52800609     	mov	w9, #0x30               ; =48
     db0: cb150136     	sub	x22, x9, x21
     db4: 8b2842e8     	add	x8, x23, w8, uxtw
     db8: 91014100     	add	x0, x8, #0x50
     dbc: 8b150281     	add	x1, x20, x21
     dc0: aa1603e2     	mov	x2, x22
<L5>:
     dc4: 94000000     	bl	 <L5>
		0000000000000dc4:  ARM64_RELOC_BRANCH26	_memcpy
     dc8: 394783e8     	ldrb	w8, [sp, #0x1e0]
     dcc: 0b160108     	add	w8, w8, w22
     dd0: 390783e8     	strb	w8, [sp, #0x1e0]
     dd4: b100c348     	adds	x8, x26, #0x30
     dd8: 9a993729     	cinc	x9, x25, hs
     ddc: a91127e8     	stp	x8, x9, [sp, #0x110]
     de0: 9109c3f9     	add	x25, sp, #0x270
     de4: 910443e0     	add	x0, sp, #0x110
     de8: 9109c3e1     	add	x1, sp, #0x270
<L6>:
     dec: 94000000     	bl	 <L6>
		0000000000000dec:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     df0: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
     df4: ad1a03e1     	stp	q1, q0, [sp, #0x340]
     df8: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
     dfc: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     e00: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     e04: ad1803e1     	stp	q1, q0, [sp, #0x300]
     e08: ad4307e0     	ldp	q0, q1, [sp, #0x60]
     e0c: ad1903e1     	stp	q1, q0, [sp, #0x320]
     e10: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     e14: ad1603e1     	stp	q1, q0, [sp, #0x2c0]
     e18: 3dc00fe1     	ldr	q1, [sp, #0x30]
     e1c: ad408fe2     	ldp	q2, q3, [sp, #0x10]
     e20: ad170be1     	stp	q1, q2, [sp, #0x2e0]
     e24: 91014314     	add	x20, x24, #0x50
     e28: 3dc003e0     	ldr	q0, [sp]
     e2c: ad1503e3     	stp	q3, q0, [sp, #0x2a0]
     e30: 910a83e0     	add	x0, sp, #0x2a0
     e34: 910382e1     	add	x1, x23, #0xe0
<L7>:
     e38: 94000000     	bl	 <L7>
		0000000000000e38:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     e3c: 394dc3e8     	ldrb	w8, [sp, #0x370]
     e40: f94157e9     	ldr	x9, [sp, #0x2a8]
     e44: f94153ea     	ldr	x10, [sp, #0x2a0]
     e48: b1020158     	adds	x24, x10, #0x80
     e4c: 9a893537     	cinc	x23, x9, hs
     e50: f90153f8     	str	x24, [sp, #0x2a0]
     e54: f90157f7     	str	x23, [sp, #0x2a8]
     e58: 34000228     	cbz	w8,  <L10>
     e5c: 7101411f     	cmp	w8, #0x50
     e60: 540001e3     	b.lo	 <L10>
     e64: 52801009     	mov	w9, #0x80               ; =128
     e68: cb080135     	sub	x21, x9, x8
     e6c: 8b080280     	add	x0, x20, x8
     e70: 9109c3e1     	add	x1, sp, #0x270
     e74: aa1503e2     	mov	x2, x21
<L8>:
     e78: 94000000     	bl	 <L8>
		0000000000000e78:  ARM64_RELOC_BRANCH26	_memcpy
     e7c: 910a83e0     	add	x0, sp, #0x2a0
     e80: aa1403e1     	mov	x1, x20
<L9>:
     e84: 94000000     	bl	 <L9>
		0000000000000e84:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     e88: 52800008     	mov	w8, #0x0                ; =0
     e8c: 390dc3ff     	strb	wzr, [sp, #0x370]
     e90: f94157f7     	ldr	x23, [sp, #0x2a8]
     e94: f94153f8     	ldr	x24, [sp, #0x2a0]
     e98: 14000002     	b	 <L11>
<L10>:
     e9c: d2800015     	mov	x21, #0x0               ; =0
<L11>:
     ea0: 52800609     	mov	w9, #0x30               ; =48
     ea4: cb150136     	sub	x22, x9, x21
     ea8: 8b284280     	add	x0, x20, w8, uxtw
     eac: 8b150321     	add	x1, x25, x21
     eb0: aa1603e2     	mov	x2, x22
<L12>:
     eb4: 94000000     	bl	 <L12>
		0000000000000eb4:  ARM64_RELOC_BRANCH26	_memcpy
     eb8: 394dc3e8     	ldrb	w8, [sp, #0x370]
     ebc: 0b160108     	add	w8, w8, w22
     ec0: 390dc3e8     	strb	w8, [sp, #0x370]
     ec4: b100c308     	adds	x8, x24, #0x30
     ec8: 9a9736e9     	cinc	x9, x23, hs
     ecc: f90157e9     	str	x9, [sp, #0x2a8]
     ed0: f90153e8     	str	x8, [sp, #0x2a0]
     ed4: 910a83e0     	add	x0, sp, #0x2a0
     ed8: 910383e1     	add	x1, sp, #0xe0
<L13>:
     edc: 94000000     	bl	 <L13>
		0000000000000edc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     ee0: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
     ee4: ad000660     	stp	q0, q1, [x19]
     ee8: 3dc043e0     	ldr	q0, [sp, #0x100]
     eec: 3d800a60     	str	q0, [x19, #0x20]
     ef0: 910e03ff     	add	sp, sp, #0x380
     ef4: a9457bfd     	ldp	x29, x30, [sp, #0x50]
     ef8: a9444ff4     	ldp	x20, x19, [sp, #0x40]
     efc: a94357f6     	ldp	x22, x21, [sp, #0x30]
     f00: a9425ff8     	ldp	x24, x23, [sp, #0x20]
     f04: a94167fa     	ldp	x26, x25, [sp, #0x10]
     f08: a8c66ffc     	ldp	x28, x27, [sp], #0x60
     f0c: d65f03c0     	ret

0000000000000f10 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
     f10: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
     f14: a90167fa     	stp	x26, x25, [sp, #0x10]
     f18: a9025ff8     	stp	x24, x23, [sp, #0x20]
     f1c: a90357f6     	stp	x22, x21, [sp, #0x30]
     f20: a9044ff4     	stp	x20, x19, [sp, #0x40]
     f24: a9057bfd     	stp	x29, x30, [sp, #0x50]
     f28: 910143fd     	add	x29, sp, #0x50
     f2c: d11a43ff     	sub	sp, sp, #0x690
     f30: aa0303f4     	mov	x20, x3
     f34: a90b03e2     	stp	x2, x0, [sp, #0xb0]
     f38: aa0103f5     	mov	x21, x1
     f3c: 910d03fb     	add	x27, sp, #0x340
     f40: ad400480     	ldp	q0, q1, [x4]
     f44: 3dc00882     	ldr	q2, [x4, #0x20]
     f48: 52800028     	mov	w8, #0x1                ; =1
     f4c: 3906bfe8     	strb	w8, [sp, #0x1af]
     f50: 90000009     	adrp	x9, 0x0 <ltmp0>
		0000000000000f50:  ARM64_RELOC_PAGE21	l___unnamed_4
     f54: 91000129     	add	x9, x9, #0x0
		0000000000000f54:  ARM64_RELOC_PAGEOFF12	l___unnamed_4
     f58: f100c03f     	cmp	x1, #0x30
     f5c: ad0083e1     	stp	q1, q0, [sp, #0x10]
     f60: 3d8003e2     	str	q2, [sp]
     f64: 54000922     	b.hs	 <L4>
     f68: f9001bff     	str	xzr, [sp, #0x30]
<L0>:
     f6c: f100c2a8     	subs	x8, x21, #0x30
     f70: 9a8832b7     	csel	x23, x21, x8, lo
     f74: b40038b7     	cbz	x23,  <L55>
     f78: 4f02e780     	movi.16b	v0, #0x5c
     f7c: ad408fe4     	ldp	q4, q3, [sp, #0x10]
     f80: 6e201c61     	eor.16b	v1, v3, v0
     f84: 6e201c82     	eor.16b	v2, v4, v0
     f88: ad160b61     	stp	q1, q2, [x27, #0x2c0]
     f8c: 3dc003e5     	ldr	q5, [sp]
     f90: 6e201ca1     	eor.16b	v1, v5, v0
     f94: ad170361     	stp	q1, q0, [x27, #0x2e0]
     f98: ad180360     	stp	q0, q0, [x27, #0x300]
     f9c: ad190360     	stp	q0, q0, [x27, #0x320]
     fa0: 4f01e6c0     	movi.16b	v0, #0x36
     fa4: 6e201c61     	eor.16b	v1, v3, v0
     fa8: 6e201c82     	eor.16b	v2, v4, v0
     fac: 6e201ca3     	eor.16b	v3, v5, v0
     fb0: ad000b61     	stp	q1, q2, [x27]
     fb4: ad010363     	stp	q3, q0, [x27, #0x20]
     fb8: ad020360     	stp	q0, q0, [x27, #0x40]
     fbc: ad030360     	stp	q0, q0, [x27, #0x60]
     fc0: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000fc0:  ARM64_RELOC_PAGE21	l___unnamed_4
     fc4: 91000108     	add	x8, x8, #0x0
		0000000000000fc4:  ARM64_RELOC_PAGEOFF12	l___unnamed_4
     fc8: ad400500     	ldp	q0, q1, [x8]
     fcc: ad0c03e1     	stp	q1, q0, [sp, #0x180]
     fd0: ad0f0760     	stp	q0, q1, [x27, #0x1e0]
     fd4: ad410500     	ldp	q0, q1, [x8, #0x20]
     fd8: ad420d02     	ldp	q2, q3, [x8, #0x40]
     fdc: ad0a0be3     	stp	q3, q2, [sp, #0x140]
     fe0: ad110f62     	stp	q2, q3, [x27, #0x220]
     fe4: ad0b03e1     	stp	q1, q0, [sp, #0x160]
     fe8: ad100760     	stp	q0, q1, [x27, #0x200]
     fec: ad430500     	ldp	q0, q1, [x8, #0x60]
     ff0: ad440d02     	ldp	q2, q3, [x8, #0x80]
     ff4: ad080be3     	stp	q3, q2, [sp, #0x100]
     ff8: ad130f62     	stp	q2, q3, [x27, #0x260]
     ffc: ad0903e1     	stp	q1, q0, [sp, #0x120]
    1000: ad120760     	stp	q0, q1, [x27, #0x240]
    1004: ad450500     	ldp	q0, q1, [x8, #0xa0]
    1008: ad460d02     	ldp	q2, q3, [x8, #0xc0]
    100c: ad060be3     	stp	q3, q2, [sp, #0xc0]
    1010: ad150f62     	stp	q2, q3, [x27, #0x2a0]
    1014: ad0703e1     	stp	q1, q0, [sp, #0xe0]
    1018: ad140760     	stp	q0, q1, [x27, #0x280]
    101c: 911483e0     	add	x0, sp, #0x520
    1020: 910d03e1     	add	x1, sp, #0x340
<L1>:
    1024: 94000000     	bl	 <L1>
		0000000000001024:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1028: a95e2369     	ldp	x9, x8, [x27, #0x1e0]
    102c: b1020129     	adds	x9, x9, #0x80
    1030: 9a883508     	cinc	x8, x8, hs
    1034: a91e2369     	stp	x9, x8, [x27, #0x1e0]
    1038: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    103c: f100bebf     	cmp	x21, #0x2f
    1040: 540021e9     	b.ls	 <L35>
    1044: 34001fa8     	cbz	w8,  <L32>
    1048: 7101411f     	cmp	w8, #0x50
    104c: 54001f63     	b.lo	 <L32>
    1050: 52801009     	mov	w9, #0x80               ; =128
    1054: cb080136     	sub	x22, x9, x8
    1058: 911483e9     	add	x9, sp, #0x520
    105c: 91014138     	add	x24, x9, #0x50
    1060: 8b080300     	add	x0, x24, x8
    1064: f9405fe1     	ldr	x1, [sp, #0xb8]
    1068: aa1603e2     	mov	x2, x22
<L2>:
    106c: 94000000     	bl	 <L2>
		000000000000106c:  ARM64_RELOC_BRANCH26	_memcpy
    1070: 911483e0     	add	x0, sp, #0x520
    1074: aa1803e1     	mov	x1, x24
<L3>:
    1078: 94000000     	bl	 <L3>
		0000000000001078:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    107c: 52800008     	mov	w8, #0x0                ; =0
    1080: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    1084: 140000ee     	b	 <L33>
<L4>:
    1088: d280001c     	mov	x28, #0x0               ; =0
    108c: d2401a88     	eor	x8, x20, #0x7f
    1090: f9001fe8     	str	x8, [sp, #0x38]
    1094: 9106c3e8     	add	x8, sp, #0x1b0
    1098: ad400d24     	ldp	q4, q3, [x9]
    109c: ad0c13e3     	stp	q3, q4, [sp, #0x180]
    10a0: 91014117     	add	x23, x8, #0x50
    10a4: 91014378     	add	x24, x27, #0x50
    10a8: 4f02e783     	movi.16b	v3, #0x5c
    10ac: 6e231c05     	eor.16b	v5, v0, v3
    10b0: ad411126     	ldp	q6, q4, [x9, #0x20]
    10b4: ad0b1be4     	stp	q4, q6, [sp, #0x160]
    10b8: 6e231c24     	eor.16b	v4, v1, v3
    10bc: ad0417e4     	stp	q4, q5, [sp, #0x80]
    10c0: 6e231c44     	eor.16b	v4, v2, v3
    10c4: 4f01e6c3     	movi.16b	v3, #0x36
    10c8: 6e231c00     	eor.16b	v0, v0, v3
    10cc: ad0313e0     	stp	q0, q4, [sp, #0x60]
    10d0: ad420124     	ldp	q4, q0, [x9, #0x40]
    10d4: ad0a13e0     	stp	q0, q4, [sp, #0x140]
    10d8: 6e231c24     	eor.16b	v4, v1, v3
    10dc: 6e231c40     	eor.16b	v0, v2, v3
    10e0: ad0213e0     	stp	q0, q4, [sp, #0x40]
    10e4: ad430121     	ldp	q1, q0, [x9, #0x60]
    10e8: ad0907e0     	stp	q0, q1, [sp, #0x120]
    10ec: ad440121     	ldp	q1, q0, [x9, #0x80]
    10f0: ad0807e0     	stp	q0, q1, [sp, #0x100]
    10f4: ad450121     	ldp	q1, q0, [x9, #0xa0]
    10f8: ad0707e0     	stp	q0, q1, [sp, #0xe0]
    10fc: 52800608     	mov	w8, #0x30               ; =48
    1100: f9001be8     	str	x8, [sp, #0x30]
    1104: 52800039     	mov	w25, #0x1               ; =1
    1108: 52800033     	mov	w19, #0x1               ; =1
    110c: ad460121     	ldp	q1, q0, [x9, #0xc0]
    1110: ad0607e0     	stp	q0, q1, [sp, #0xc0]
    1114: f90057f5     	str	x21, [sp, #0xa8]
    1118: 1400001a     	b	 <L9>
<L5>:
    111c: d2800019     	mov	x25, #0x0               ; =0
<L6>:
    1120: 52800609     	mov	w9, #0x30               ; =48
    1124: cb19013a     	sub	x26, x9, x25
    1128: 8b284300     	add	x0, x24, w8, uxtw
    112c: 911283e8     	add	x8, sp, #0x4a0
    1130: 8b190101     	add	x1, x8, x25
    1134: aa1a03e2     	mov	x2, x26
<L7>:
    1138: 94000000     	bl	 <L7>
		0000000000001138:  ARM64_RELOC_BRANCH26	_memcpy
    113c: 395043e8     	ldrb	w8, [sp, #0x410]
    1140: 0b1a0108     	add	w8, w8, w26
    1144: 391043e8     	strb	w8, [sp, #0x410]
    1148: b100c2c8     	adds	x8, x22, #0x30
    114c: 9a9536a9     	cinc	x9, x21, hs
    1150: a9002768     	stp	x8, x9, [x27]
    1154: 910d03e0     	add	x0, sp, #0x340
    1158: f9405fe8     	ldr	x8, [sp, #0xb8]
    115c: 8b1c0101     	add	x1, x8, x28
<L8>:
    1160: 94000000     	bl	 <L8>
		0000000000001160:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    1164: 52800019     	mov	w25, #0x0               ; =0
    1168: 11000673     	add	w19, w19, #0x1
    116c: 3906bff3     	strb	w19, [sp, #0x1af]
    1170: 5280061c     	mov	w28, #0x30              ; =48
    1174: f94057f5     	ldr	x21, [sp, #0xa8]
    1178: f10182bf     	cmp	x21, #0x60
    117c: 54ffef83     	b.lo	 <L0>
<L9>:
    1180: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    1184: ad070361     	stp	q1, q0, [x27, #0xe0]
    1188: 3dc01fe1     	ldr	q1, [sp, #0x70]
    118c: 4f02e780     	movi.16b	v0, #0x5c
    1190: ad080361     	stp	q1, q0, [x27, #0x100]
    1194: ad090360     	stp	q0, q0, [x27, #0x120]
    1198: ad0a0360     	stp	q0, q0, [x27, #0x140]
    119c: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    11a0: ad0b0361     	stp	q1, q0, [x27, #0x160]
    11a4: 3dc013e1     	ldr	q1, [sp, #0x40]
    11a8: 4f01e6c0     	movi.16b	v0, #0x36
    11ac: ad0c0361     	stp	q1, q0, [x27, #0x180]
    11b0: ad0d0360     	stp	q0, q0, [x27, #0x1a0]
    11b4: ad0e0360     	stp	q0, q0, [x27, #0x1c0]
    11b8: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    11bc: ad000361     	stp	q1, q0, [x27]
    11c0: ad4a03e1     	ldp	q1, q0, [sp, #0x140]
    11c4: ad020760     	stp	q0, q1, [x27, #0x40]
    11c8: ad4b03e1     	ldp	q1, q0, [sp, #0x160]
    11cc: ad010760     	stp	q0, q1, [x27, #0x20]
    11d0: ad4803e1     	ldp	q1, q0, [sp, #0x100]
    11d4: ad040760     	stp	q0, q1, [x27, #0x80]
    11d8: ad4903e1     	ldp	q1, q0, [sp, #0x120]
    11dc: ad030760     	stp	q0, q1, [x27, #0x60]
    11e0: ad4603e1     	ldp	q1, q0, [sp, #0xc0]
    11e4: ad060760     	stp	q0, q1, [x27, #0xc0]
    11e8: ad4703e1     	ldp	q1, q0, [sp, #0xe0]
    11ec: ad050760     	stp	q0, q1, [x27, #0xa0]
    11f0: 910d03e0     	add	x0, sp, #0x340
    11f4: 911283e1     	add	x1, sp, #0x4a0
<L10>:
    11f8: 94000000     	bl	 <L10>
		00000000000011f8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    11fc: a9402369     	ldp	x9, x8, [x27]
    1200: b1020129     	adds	x9, x9, #0x80
    1204: 9a883508     	cinc	x8, x8, hs
    1208: a9002369     	stp	x9, x8, [x27]
    120c: 9106c3e0     	add	x0, sp, #0x1b0
    1210: 910d03e1     	add	x1, sp, #0x340
    1214: 52802c02     	mov	w2, #0x160              ; =352
<L11>:
    1218: 94000000     	bl	 <L11>
		0000000000001218:  ARM64_RELOC_BRANCH26	_memcpy
    121c: 394a03e8     	ldrb	w8, [sp, #0x280]
    1220: 370003f9     	tbnz	w25, #0x0,  <L17>
    1224: 340001e8     	cbz	w8,  <L14>
    1228: 7101411f     	cmp	w8, #0x50
    122c: 540001a3     	b.lo	 <L14>
    1230: 52801009     	mov	w9, #0x80               ; =128
    1234: cb080139     	sub	x25, x9, x8
    1238: 8b0802e0     	add	x0, x23, x8
    123c: f9405fe1     	ldr	x1, [sp, #0xb8]
    1240: aa1903e2     	mov	x2, x25
<L12>:
    1244: 94000000     	bl	 <L12>
		0000000000001244:  ARM64_RELOC_BRANCH26	_memcpy
    1248: 9106c3e0     	add	x0, sp, #0x1b0
    124c: aa1703e1     	mov	x1, x23
<L13>:
    1250: 94000000     	bl	 <L13>
		0000000000001250:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1254: 52800008     	mov	w8, #0x0                ; =0
    1258: 390a03ff     	strb	wzr, [sp, #0x280]
    125c: 14000002     	b	 <L15>
<L14>:
    1260: d2800019     	mov	x25, #0x0               ; =0
<L15>:
    1264: 52800609     	mov	w9, #0x30               ; =48
    1268: cb19013a     	sub	x26, x9, x25
    126c: 8b2842e0     	add	x0, x23, w8, uxtw
    1270: f9405fe8     	ldr	x8, [sp, #0xb8]
    1274: 8b190101     	add	x1, x8, x25
    1278: aa1a03e2     	mov	x2, x26
<L16>:
    127c: 94000000     	bl	 <L16>
		000000000000127c:  ARM64_RELOC_BRANCH26	_memcpy
    1280: 394a03e8     	ldrb	w8, [sp, #0x280]
    1284: 0b1a0108     	add	w8, w8, w26
    1288: 390a03e8     	strb	w8, [sp, #0x280]
    128c: a95b27ea     	ldp	x10, x9, [sp, #0x1b0]
    1290: b100c14a     	adds	x10, x10, #0x30
    1294: 9a893529     	cinc	x9, x9, hs
    1298: a91b27ea     	stp	x10, x9, [sp, #0x1b0]
<L17>:
    129c: 34000228     	cbz	w8,  <L20>
    12a0: 2a0803e9     	mov	w9, w8
    12a4: f9401fea     	ldr	x10, [sp, #0x38]
    12a8: eb09015f     	cmp	x10, x9
    12ac: 540001a2     	b.hs	 <L20>
    12b0: 5280100a     	mov	w10, #0x80              ; =128
    12b4: 4b080159     	sub	w25, w10, w8
    12b8: 8b0902e0     	add	x0, x23, x9
    12bc: f9405be1     	ldr	x1, [sp, #0xb0]
    12c0: aa1903e2     	mov	x2, x25
<L18>:
    12c4: 94000000     	bl	 <L18>
		00000000000012c4:  ARM64_RELOC_BRANCH26	_memcpy
    12c8: 9106c3e0     	add	x0, sp, #0x1b0
    12cc: aa1703e1     	mov	x1, x23
<L19>:
    12d0: 94000000     	bl	 <L19>
		00000000000012d0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    12d4: 52800008     	mov	w8, #0x0                ; =0
    12d8: 390a03ff     	strb	wzr, [sp, #0x280]
    12dc: 14000002     	b	 <L21>
<L20>:
    12e0: d2800019     	mov	x25, #0x0               ; =0
<L21>:
    12e4: cb19029a     	sub	x26, x20, x25
    12e8: 8b2842e0     	add	x0, x23, w8, uxtw
    12ec: f9405be8     	ldr	x8, [sp, #0xb0]
    12f0: 8b190101     	add	x1, x8, x25
    12f4: aa1a03e2     	mov	x2, x26
<L22>:
    12f8: 94000000     	bl	 <L22>
		00000000000012f8:  ARM64_RELOC_BRANCH26	_memcpy
    12fc: 394a03e8     	ldrb	w8, [sp, #0x280]
    1300: a95b27ea     	ldp	x10, x9, [sp, #0x1b0]
    1304: ab140156     	adds	x22, x10, x20
    1308: 9a893535     	cinc	x21, x9, hs
    130c: a91b57f6     	stp	x22, x21, [sp, #0x1b0]
    1310: 0b1a0108     	add	w8, w8, w26
    1314: 390a03e8     	strb	w8, [sp, #0x280]
    1318: 34000208     	cbz	w8,  <L25>
    131c: 7101fd1f     	cmp	w8, #0x7f
    1320: 540001c3     	b.lo	 <L25>
    1324: 52801009     	mov	w9, #0x80               ; =128
    1328: 4b080139     	sub	w25, w9, w8
    132c: 8b2842e0     	add	x0, x23, w8, uxtw
    1330: 9106bfe1     	add	x1, sp, #0x1af
    1334: aa1903e2     	mov	x2, x25
<L23>:
    1338: 94000000     	bl	 <L23>
		0000000000001338:  ARM64_RELOC_BRANCH26	_memcpy
    133c: 9106c3e0     	add	x0, sp, #0x1b0
    1340: aa1703e1     	mov	x1, x23
<L24>:
    1344: 94000000     	bl	 <L24>
		0000000000001344:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1348: 52800008     	mov	w8, #0x0                ; =0
    134c: 390a03ff     	strb	wzr, [sp, #0x280]
    1350: a95b57f6     	ldp	x22, x21, [sp, #0x1b0]
    1354: 14000002     	b	 <L26>
<L25>:
    1358: d2800019     	mov	x25, #0x0               ; =0
<L26>:
    135c: 52800029     	mov	w9, #0x1                ; =1
    1360: cb19013a     	sub	x26, x9, x25
    1364: 8b2842e0     	add	x0, x23, w8, uxtw
    1368: 9106bfe8     	add	x8, sp, #0x1af
    136c: 8b190101     	add	x1, x8, x25
    1370: aa1a03e2     	mov	x2, x26
<L27>:
    1374: 94000000     	bl	 <L27>
		0000000000001374:  ARM64_RELOC_BRANCH26	_memcpy
    1378: 394a03e8     	ldrb	w8, [sp, #0x280]
    137c: 0b1a0108     	add	w8, w8, w26
    1380: 390a03e8     	strb	w8, [sp, #0x280]
    1384: b10006c8     	adds	x8, x22, #0x1
    1388: 9a9536a9     	cinc	x9, x21, hs
    138c: a91b27e8     	stp	x8, x9, [sp, #0x1b0]
    1390: 9106c3e0     	add	x0, sp, #0x1b0
    1394: 911283e1     	add	x1, sp, #0x4a0
<L28>:
    1398: 94000000     	bl	 <L28>
		0000000000001398:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    139c: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    13a0: ad050361     	stp	q1, q0, [x27, #0xa0]
    13a4: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    13a8: ad060361     	stp	q1, q0, [x27, #0xc0]
    13ac: ad4907e0     	ldp	q0, q1, [sp, #0x120]
    13b0: ad030361     	stp	q1, q0, [x27, #0x60]
    13b4: ad4807e0     	ldp	q0, q1, [sp, #0x100]
    13b8: ad040361     	stp	q1, q0, [x27, #0x80]
    13bc: ad4b07e0     	ldp	q0, q1, [sp, #0x160]
    13c0: ad010361     	stp	q1, q0, [x27, #0x20]
    13c4: ad4a07e0     	ldp	q0, q1, [sp, #0x140]
    13c8: ad020361     	stp	q1, q0, [x27, #0x40]
    13cc: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    13d0: ad000361     	stp	q1, q0, [x27]
    13d4: 910d03e0     	add	x0, sp, #0x340
    13d8: 9106c3e8     	add	x8, sp, #0x1b0
    13dc: 91038101     	add	x1, x8, #0xe0
<L29>:
    13e0: 94000000     	bl	 <L29>
		00000000000013e0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    13e4: 395043e8     	ldrb	w8, [sp, #0x410]
    13e8: a940276a     	ldp	x10, x9, [x27]
    13ec: b1020156     	adds	x22, x10, #0x80
    13f0: 9a893535     	cinc	x21, x9, hs
    13f4: a9005776     	stp	x22, x21, [x27]
    13f8: 34ffe928     	cbz	w8,  <L5>
    13fc: 7101411f     	cmp	w8, #0x50
    1400: 54ffe8e3     	b.lo	 <L5>
    1404: 52801009     	mov	w9, #0x80               ; =128
    1408: cb080139     	sub	x25, x9, x8
    140c: 8b080300     	add	x0, x24, x8
    1410: 911283e1     	add	x1, sp, #0x4a0
    1414: aa1903e2     	mov	x2, x25
<L30>:
    1418: 94000000     	bl	 <L30>
		0000000000001418:  ARM64_RELOC_BRANCH26	_memcpy
    141c: 910d03e0     	add	x0, sp, #0x340
    1420: aa1803e1     	mov	x1, x24
<L31>:
    1424: 94000000     	bl	 <L31>
		0000000000001424:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1428: 52800008     	mov	w8, #0x0                ; =0
    142c: 391043ff     	strb	wzr, [sp, #0x410]
    1430: a9405776     	ldp	x22, x21, [x27]
    1434: 17ffff3b     	b	 <L6>
<L32>:
    1438: d2800016     	mov	x22, #0x0               ; =0
<L33>:
    143c: 52800609     	mov	w9, #0x30               ; =48
    1440: cb160138     	sub	x24, x9, x22
    1444: 911483e9     	add	x9, sp, #0x520
    1448: 8b284128     	add	x8, x9, w8, uxtw
    144c: 91014100     	add	x0, x8, #0x50
    1450: f9405fe8     	ldr	x8, [sp, #0xb8]
    1454: 8b160101     	add	x1, x8, x22
    1458: aa1803e2     	mov	x2, x24
<L34>:
    145c: 94000000     	bl	 <L34>
		000000000000145c:  ARM64_RELOC_BRANCH26	_memcpy
    1460: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    1464: 0b180108     	add	w8, w8, w24
    1468: 3917c3e8     	strb	w8, [sp, #0x5f0]
    146c: a95e276a     	ldp	x10, x9, [x27, #0x1e0]
    1470: b100c14a     	adds	x10, x10, #0x30
    1474: 9a893529     	cinc	x9, x9, hs
    1478: a91e276a     	stp	x10, x9, [x27, #0x1e0]
<L35>:
    147c: 34000268     	cbz	w8,  <L38>
    1480: 2a0803e9     	mov	w9, w8
    1484: 8b09028a     	add	x10, x20, x9
    1488: f102015f     	cmp	x10, #0x80
    148c: 540001e3     	b.lo	 <L38>
    1490: 5280100a     	mov	w10, #0x80              ; =128
    1494: 4b080158     	sub	w24, w10, w8
    1498: 911483e8     	add	x8, sp, #0x520
    149c: 91014116     	add	x22, x8, #0x50
    14a0: 8b0902c0     	add	x0, x22, x9
    14a4: f9405be1     	ldr	x1, [sp, #0xb0]
    14a8: aa1803e2     	mov	x2, x24
<L36>:
    14ac: 94000000     	bl	 <L36>
		00000000000014ac:  ARM64_RELOC_BRANCH26	_memcpy
    14b0: 911483e0     	add	x0, sp, #0x520
    14b4: aa1603e1     	mov	x1, x22
<L37>:
    14b8: 94000000     	bl	 <L37>
		00000000000014b8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    14bc: 52800008     	mov	w8, #0x0                ; =0
    14c0: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    14c4: 14000002     	b	 <L39>
<L38>:
    14c8: d2800018     	mov	x24, #0x0               ; =0
<L39>:
    14cc: cb180299     	sub	x25, x20, x24
    14d0: 911483f3     	add	x19, sp, #0x520
    14d4: 91014276     	add	x22, x19, #0x50
    14d8: 8b2842c0     	add	x0, x22, w8, uxtw
    14dc: f9405be8     	ldr	x8, [sp, #0xb0]
    14e0: 8b180101     	add	x1, x8, x24
    14e4: aa1903e2     	mov	x2, x25
<L40>:
    14e8: 94000000     	bl	 <L40>
		00000000000014e8:  ARM64_RELOC_BRANCH26	_memcpy
    14ec: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    14f0: a95e276a     	ldp	x10, x9, [x27, #0x1e0]
    14f4: ab14015a     	adds	x26, x10, x20
    14f8: 9a893538     	cinc	x24, x9, hs
    14fc: a91e637a     	stp	x26, x24, [x27, #0x1e0]
    1500: 0b190108     	add	w8, w8, w25
    1504: 3917c3e8     	strb	w8, [sp, #0x5f0]
    1508: 34000208     	cbz	w8,  <L43>
    150c: 7101fd1f     	cmp	w8, #0x7f
    1510: 540001c3     	b.lo	 <L43>
    1514: 52801009     	mov	w9, #0x80               ; =128
    1518: 4b080134     	sub	w20, w9, w8
    151c: 8b2842c0     	add	x0, x22, w8, uxtw
    1520: 9106bfe1     	add	x1, sp, #0x1af
    1524: aa1403e2     	mov	x2, x20
<L41>:
    1528: 94000000     	bl	 <L41>
		0000000000001528:  ARM64_RELOC_BRANCH26	_memcpy
    152c: 911483e0     	add	x0, sp, #0x520
    1530: aa1603e1     	mov	x1, x22
<L42>:
    1534: 94000000     	bl	 <L42>
		0000000000001534:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1538: 52800008     	mov	w8, #0x0                ; =0
    153c: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    1540: a95e637a     	ldp	x26, x24, [x27, #0x1e0]
    1544: 14000002     	b	 <L44>
<L43>:
    1548: d2800014     	mov	x20, #0x0               ; =0
<L44>:
    154c: 9106bfe9     	add	x9, sp, #0x1af
    1550: 5280002a     	mov	w10, #0x1               ; =1
    1554: cb140155     	sub	x21, x10, x20
    1558: 8b2842c0     	add	x0, x22, w8, uxtw
    155c: 8b140121     	add	x1, x9, x20
    1560: aa1503e2     	mov	x2, x21
<L45>:
    1564: 94000000     	bl	 <L45>
		0000000000001564:  ARM64_RELOC_BRANCH26	_memcpy
    1568: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    156c: 0b150108     	add	w8, w8, w21
    1570: 3917c3e8     	strb	w8, [sp, #0x5f0]
    1574: b1000748     	adds	x8, x26, #0x1
    1578: 9a983709     	cinc	x9, x24, hs
    157c: a91e2768     	stp	x8, x9, [x27, #0x1e0]
    1580: 911283f8     	add	x24, sp, #0x4a0
    1584: 911483e0     	add	x0, sp, #0x520
    1588: 911283e1     	add	x1, sp, #0x4a0
<L46>:
    158c: 94000000     	bl	 <L46>
		000000000000158c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    1590: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    1594: ad050361     	stp	q1, q0, [x27, #0xa0]
    1598: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    159c: ad060361     	stp	q1, q0, [x27, #0xc0]
    15a0: ad4907e0     	ldp	q0, q1, [sp, #0x120]
    15a4: ad030361     	stp	q1, q0, [x27, #0x60]
    15a8: ad4807e0     	ldp	q0, q1, [sp, #0x100]
    15ac: ad040361     	stp	q1, q0, [x27, #0x80]
    15b0: ad4b07e0     	ldp	q0, q1, [sp, #0x160]
    15b4: ad010361     	stp	q1, q0, [x27, #0x20]
    15b8: ad4a07e0     	ldp	q0, q1, [sp, #0x140]
    15bc: ad020361     	stp	q1, q0, [x27, #0x40]
    15c0: 910d03e8     	add	x8, sp, #0x340
    15c4: 91014114     	add	x20, x8, #0x50
    15c8: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    15cc: ad000361     	stp	q1, q0, [x27]
    15d0: 910d03e0     	add	x0, sp, #0x340
    15d4: 91038261     	add	x1, x19, #0xe0
<L47>:
    15d8: 94000000     	bl	 <L47>
		00000000000015d8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    15dc: 395043e8     	ldrb	w8, [sp, #0x410]
    15e0: a940276a     	ldp	x10, x9, [x27]
    15e4: b1020159     	adds	x25, x10, #0x80
    15e8: 9a893533     	cinc	x19, x9, hs
    15ec: a9004f79     	stp	x25, x19, [x27]
    15f0: 34000208     	cbz	w8,  <L50>
    15f4: 7101411f     	cmp	w8, #0x50
    15f8: 540001c3     	b.lo	 <L50>
    15fc: 52801009     	mov	w9, #0x80               ; =128
    1600: cb080135     	sub	x21, x9, x8
    1604: 8b080280     	add	x0, x20, x8
    1608: 911283e1     	add	x1, sp, #0x4a0
    160c: aa1503e2     	mov	x2, x21
<L48>:
    1610: 94000000     	bl	 <L48>
		0000000000001610:  ARM64_RELOC_BRANCH26	_memcpy
    1614: 910d03e0     	add	x0, sp, #0x340
    1618: aa1403e1     	mov	x1, x20
<L49>:
    161c: 94000000     	bl	 <L49>
		000000000000161c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1620: 52800008     	mov	w8, #0x0                ; =0
    1624: 391043ff     	strb	wzr, [sp, #0x410]
    1628: a9404f79     	ldp	x25, x19, [x27]
    162c: 14000002     	b	 <L51>
<L50>:
    1630: d2800015     	mov	x21, #0x0               ; =0
<L51>:
    1634: 52800609     	mov	w9, #0x30               ; =48
    1638: cb150136     	sub	x22, x9, x21
    163c: 8b284280     	add	x0, x20, w8, uxtw
    1640: 8b150301     	add	x1, x24, x21
    1644: aa1603e2     	mov	x2, x22
<L52>:
    1648: 94000000     	bl	 <L52>
		0000000000001648:  ARM64_RELOC_BRANCH26	_memcpy
    164c: 395043e8     	ldrb	w8, [sp, #0x410]
    1650: 0b160108     	add	w8, w8, w22
    1654: 391043e8     	strb	w8, [sp, #0x410]
    1658: b100c328     	adds	x8, x25, #0x30
    165c: 9a933669     	cinc	x9, x19, hs
    1660: a9002768     	stp	x8, x9, [x27]
    1664: 910d03e0     	add	x0, sp, #0x340
    1668: 910c43e1     	add	x1, sp, #0x310
<L53>:
    166c: 94000000     	bl	 <L53>
		000000000000166c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    1670: f9405fe8     	ldr	x8, [sp, #0xb8]
    1674: f9401be9     	ldr	x9, [sp, #0x30]
    1678: 8b090100     	add	x0, x8, x9
    167c: 910c43e1     	add	x1, sp, #0x310
    1680: aa1703e2     	mov	x2, x23
<L54>:
    1684: 94000000     	bl	 <L54>
		0000000000001684:  ARM64_RELOC_BRANCH26	_memcpy
<L55>:
    1688: 911a43ff     	add	sp, sp, #0x690
    168c: a9457bfd     	ldp	x29, x30, [sp, #0x50]
    1690: a9444ff4     	ldp	x20, x19, [sp, #0x40]
    1694: a94357f6     	ldp	x22, x21, [sp, #0x30]
    1698: a9425ff8     	ldp	x24, x23, [sp, #0x20]
    169c: a94167fa     	ldp	x26, x25, [sp, #0x10]
    16a0: a8c66ffc     	ldp	x28, x27, [sp], #0x60
    16a4: d65f03c0     	ret

00000000000016a8 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    16a8: a9bd57f6     	stp	x22, x21, [sp, #-0x30]!
    16ac: a9014ff4     	stp	x20, x19, [sp, #0x10]
    16b0: a9027bfd     	stp	x29, x30, [sp, #0x20]
    16b4: 910083fd     	add	x29, sp, #0x20
    16b8: aa0103f3     	mov	x19, x1
    16bc: aa0003f4     	mov	x20, x0
    16c0: 91014015     	add	x21, x0, #0x50
    16c4: 39434008     	ldrb	w8, [x0, #0xd0]
    16c8: 52801016     	mov	w22, #0x80              ; =128
    16cc: cb0802c1     	sub	x1, x22, x8
    16d0: 8b0802a0     	add	x0, x21, x8
<L0>:
    16d4: 94000000     	bl	 <L0>
		00000000000016d4:  ARM64_RELOC_BRANCH26	_bzero
    16d8: 39434288     	ldrb	w8, [x20, #0xd0]
    16dc: 38286ab6     	strb	w22, [x21, x8]
    16e0: 39434288     	ldrb	w8, [x20, #0xd0]
    16e4: 11000509     	add	w9, w8, #0x1
    16e8: 39034289     	strb	w9, [x20, #0xd0]
    16ec: 7101bd1f     	cmp	w8, #0x6f
    16f0: 54000129     	b.ls	 <L2>
    16f4: aa1403e0     	mov	x0, x20
    16f8: aa1503e1     	mov	x1, x21
<L1>:
    16fc: 94000000     	bl	 <L1>
		00000000000016fc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1700: 6f00e400     	movi.2d	v0, #0000000000000000
    1704: ad0282a0     	stp	q0, q0, [x21, #0x50]
    1708: ad0182a0     	stp	q0, q0, [x21, #0x30]
    170c: ad0082a0     	stp	q0, q0, [x21, #0x10]
    1710: 3d8002a0     	str	q0, [x21]
<L2>:
    1714: a9402e8a     	ldp	x10, x11, [x20]
    1718: d345fd68     	lsr	x8, x11, #5
    171c: 531d7149     	lsl	w9, w10, #3
    1720: 39033e89     	strb	w9, [x20, #0xcf]
    1724: 53057d49     	lsr	w9, w10, #5
    1728: 39033a89     	strb	w9, [x20, #0xce]
    172c: d34dfd69     	lsr	x9, x11, #13
    1730: 530d7d4c     	lsr	w12, w10, #13
    1734: 3903368c     	strb	w12, [x20, #0xcd]
    1738: d355fd6c     	lsr	x12, x11, #21
    173c: 53157d4d     	lsr	w13, w10, #21
    1740: 93cad56e     	extr	x14, x11, x10, #0x35
    1744: 93cab56f     	extr	x15, x11, x10, #0x2d
    1748: 3903328d     	strb	w13, [x20, #0xcc]
    174c: 93ca956d     	extr	x13, x11, x10, #0x25
    1750: 93ca7570     	extr	x16, x11, x10, #0x1d
    1754: d35dfd71     	lsr	x17, x11, #29
    1758: d365fd60     	lsr	x0, x11, #37
    175c: d36dfd61     	lsr	x1, x11, #45
    1760: d375fd62     	lsr	x2, x11, #53
    1764: 9e670203     	fmov	d3, x16
    1768: 9e6701a2     	fmov	d2, x13
    176c: 9e6701e1     	fmov	d1, x15
    1770: 9e6701c0     	fmov	d0, x14
    1774: 9000000d     	adrp	x13, 0x1000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0xf0>
		0000000000001774:  ARM64_RELOC_PAGE21	lCPI11_0
    1778: 3dc001a4     	ldr	q4, [x13]
		0000000000001778:  ARM64_RELOC_PAGEOFF12	lCPI11_0
    177c: 4e046000     	tbl.16b	v0, { v0, v1, v2, v3 }, v4
    1780: 93caf56a     	extr	x10, x11, x10, #0x3d
    1784: 0e212800     	xtn.8b	v0, v0
    1788: 1e270041     	fmov	s1, w2
    178c: 4e031c21     	mov.b	v1[1], w1
    1790: 4e051c01     	mov.b	v1[2], w0
    1794: 4e071e21     	mov.b	v1[3], w17
    1798: 4e091d81     	mov.b	v1[4], w12
    179c: 4e0b1d21     	mov.b	v1[5], w9
    17a0: bd00ca80     	str	s0, [x20, #0xc8]
    17a4: 4e0d1d01     	mov.b	v1[6], w8
    17a8: 4e0f1d41     	mov.b	v1[7], w10
    17ac: fd006281     	str	d1, [x20, #0xc0]
    17b0: aa1403e0     	mov	x0, x20
    17b4: aa1503e1     	mov	x1, x21
<L3>:
    17b8: 94000000     	bl	 <L3>
		00000000000017b8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    17bc: f9400a88     	ldr	x8, [x20, #0x10]
    17c0: dac00d08     	rev	x8, x8
    17c4: f9000268     	str	x8, [x19]
    17c8: f9400e88     	ldr	x8, [x20, #0x18]
    17cc: dac00d08     	rev	x8, x8
    17d0: f9000668     	str	x8, [x19, #0x8]
    17d4: f9401288     	ldr	x8, [x20, #0x20]
    17d8: dac00d08     	rev	x8, x8
    17dc: f9000a68     	str	x8, [x19, #0x10]
    17e0: f9401688     	ldr	x8, [x20, #0x28]
    17e4: dac00d08     	rev	x8, x8
    17e8: f9000e68     	str	x8, [x19, #0x18]
    17ec: f9401a88     	ldr	x8, [x20, #0x30]
    17f0: dac00d08     	rev	x8, x8
    17f4: f9001268     	str	x8, [x19, #0x20]
    17f8: f9401e88     	ldr	x8, [x20, #0x38]
    17fc: dac00d08     	rev	x8, x8
    1800: f9001668     	str	x8, [x19, #0x28]
    1804: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    1808: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    180c: a8c357f6     	ldp	x22, x21, [sp], #0x30
    1810: d65f03c0     	ret

0000000000001814 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    1814: a9bd6ffc     	stp	x28, x27, [sp, #-0x30]!
    1818: a9014ff4     	stp	x20, x19, [sp, #0x10]
    181c: a9027bfd     	stp	x29, x30, [sp, #0x20]
    1820: 910083fd     	add	x29, sp, #0x20
    1824: d10a03ff     	sub	sp, sp, #0x280
    1828: ad400420     	ldp	q0, q1, [x1]
    182c: 4e200800     	rev64.16b	v0, v0
    1830: 4e200821     	rev64.16b	v1, v1
    1834: ad0007e0     	stp	q0, q1, [sp]
    1838: ad410821     	ldp	q1, q2, [x1, #0x20]
    183c: 4e200821     	rev64.16b	v1, v1
    1840: 4e200842     	rev64.16b	v2, v2
    1844: ad010be1     	stp	q1, q2, [sp, #0x20]
    1848: ad420821     	ldp	q1, q2, [x1, #0x40]
    184c: 4e200821     	rev64.16b	v1, v1
    1850: 4e200842     	rev64.16b	v2, v2
    1854: ad020be1     	stp	q1, q2, [sp, #0x40]
    1858: ad430821     	ldp	q1, q2, [x1, #0x60]
    185c: 4e200821     	rev64.16b	v1, v1
    1860: 4e200842     	rev64.16b	v2, v2
    1864: ad030be1     	stp	q1, q2, [sp, #0x60]
    1868: 9e66000c     	fmov	x12, d0
    186c: 910003e8     	mov	x8, sp
    1870: 91020108     	add	x8, x8, #0x80
    1874: 52800809     	mov	w9, #0x40               ; =64
    1878: aa0c03ea     	mov	x10, x12
<L0>:
    187c: f85c810b     	ldur	x11, [x8, #-0x38]
    1880: 8b0a016b     	add	x11, x11, x10
    1884: f858810a     	ldur	x10, [x8, #-0x78]
    1888: 93ca054d     	ror	x13, x10, #0x1
    188c: caca21ad     	eor	x13, x13, x10, ror #8
    1890: ca4a1dad     	eor	x13, x13, x10, lsr #7
    1894: 8b0d016b     	add	x11, x11, x13
    1898: f85f010d     	ldur	x13, [x8, #-0x10]
    189c: 93cd4dae     	ror	x14, x13, #0x13
    18a0: cacdf5ce     	eor	x14, x14, x13, ror #61
    18a4: ca4d19cd     	eor	x13, x14, x13, lsr #6
    18a8: 8b0d016b     	add	x11, x11, x13
    18ac: f800850b     	str	x11, [x8], #0x8
    18b0: f1000529     	subs	x9, x9, #0x1
    18b4: 54fffe41     	b.ne	 <L0>
    18b8: a940afed     	ldp	x13, x11, [sp, #0x8]
    18bc: a9412808     	ldp	x8, x10, [x0, #0x10]
    18c0: a942a40e     	ldp	x14, x9, [x0, #0x28]
    18c4: 93c9392f     	ror	x15, x9, #0xe
    18c8: cac949ef     	eor	x15, x15, x9, ror #18
    18cc: cac9a5e1     	eor	x1, x15, x9, ror #41
    18d0: a9438c0f     	ldp	x15, x3, [x0, #0x38]
    18d4: 8a290071     	bic	x17, x3, x9
    18d8: a9431010     	ldp	x16, x4, [x0, #0x30]
    18dc: 8a090082     	and	x2, x4, x9
    18e0: aa110042     	orr	x2, x2, x17
    18e4: a9441411     	ldp	x17, x5, [x0, #0x40]
    18e8: 8b0c00ac     	add	x12, x5, x12
    18ec: 8b02018c     	add	x12, x12, x2
    18f0: d295c442     	mov	x2, #0xae22             ; =44578
    18f4: f2bae502     	movk	x2, #0xd728, lsl #16
    18f8: f2c5f302     	movk	x2, #0x2f98, lsl #32
    18fc: f2e85142     	movk	x2, #0x428a, lsl #48
    1900: 8b02018c     	add	x12, x12, x2
    1904: 8b0c0025     	add	x5, x1, x12
    1908: 93c8710c     	ror	x12, x8, #0x1c
    190c: cac8898c     	eor	x12, x12, x8, ror #34
    1910: cac89d81     	eor	x1, x12, x8, ror #39
    1914: a9419c0c     	ldp	x12, x7, [x0, #0x18]
    1918: aa0a00e2     	orr	x2, x7, x10
    191c: 8a080042     	and	x2, x2, x8
    1920: 8a0a00e6     	and	x6, x7, x10
    1924: aa060042     	orr	x2, x2, x6
    1928: 8b010041     	add	x1, x2, x1
    192c: 8b050022     	add	x2, x1, x5
    1930: a9421801     	ldp	x1, x6, [x0, #0x20]
    1934: 8b0600a6     	add	x6, x5, x6
    1938: 8a260085     	bic	x5, x4, x6
    193c: 93c638d3     	ror	x19, x6, #0xe
    1940: cac64a73     	eor	x19, x19, x6, ror #18
    1944: cac6a673     	eor	x19, x19, x6, ror #41
    1948: 8a060134     	and	x20, x9, x6
    194c: aa050285     	orr	x5, x20, x5
    1950: 8b0d006d     	add	x13, x3, x13
    1954: 8b0501ad     	add	x13, x13, x5
    1958: d28cb9a3     	mov	x3, #0x65cd             ; =26061
    195c: f2a47de3     	movk	x3, #0x23ef, lsl #16
    1960: f2c89223     	movk	x3, #0x4491, lsl #32
    1964: f2ee26e3     	movk	x3, #0x7137, lsl #48
    1968: 8b0301ad     	add	x13, x13, x3
    196c: 8b1301a3     	add	x3, x13, x19
    1970: 93c2704d     	ror	x13, x2, #0x1c
    1974: cac289ad     	eor	x13, x13, x2, ror #34
    1978: cac29dad     	eor	x13, x13, x2, ror #39
    197c: aa080145     	orr	x5, x10, x8
    1980: 8a050045     	and	x5, x2, x5
    1984: 8a080153     	and	x19, x10, x8
    1988: aa1300a5     	orr	x5, x5, x19
    198c: 8b0501ad     	add	x13, x13, x5
    1990: 8b0301ad     	add	x13, x13, x3
    1994: 8b070063     	add	x3, x3, x7
    1998: 8a230125     	bic	x5, x9, x3
    199c: 93c33867     	ror	x7, x3, #0xe
    19a0: cac348e7     	eor	x7, x7, x3, ror #18
    19a4: cac3a4e7     	eor	x7, x7, x3, ror #41
    19a8: 8a0300d3     	and	x19, x6, x3
    19ac: aa050265     	orr	x5, x19, x5
    19b0: 8b0b008b     	add	x11, x4, x11
    19b4: 8b05016b     	add	x11, x11, x5
    19b8: d28765e4     	mov	x4, #0x3b2f             ; =15151
    19bc: f2bd89a4     	movk	x4, #0xec4d, lsl #16
    19c0: f2df79e4     	movk	x4, #0xfbcf, lsl #32
    19c4: f2f6b804     	movk	x4, #0xb5c0, lsl #48
    19c8: 8b04016b     	add	x11, x11, x4
    19cc: 8b070164     	add	x4, x11, x7
    19d0: 93cd71ab     	ror	x11, x13, #0x1c
    19d4: cacd896b     	eor	x11, x11, x13, ror #34
    19d8: cacd9d6b     	eor	x11, x11, x13, ror #39
    19dc: aa080045     	orr	x5, x2, x8
    19e0: 8a0501a5     	and	x5, x13, x5
    19e4: 8a080047     	and	x7, x2, x8
    19e8: aa0700a5     	orr	x5, x5, x7
    19ec: 8b05016b     	add	x11, x11, x5
    19f0: 8b04016b     	add	x11, x11, x4
    19f4: 8b0a0084     	add	x4, x4, x10
    19f8: 8a2400ca     	bic	x10, x6, x4
    19fc: 93c43885     	ror	x5, x4, #0xe
    1a00: cac448a5     	eor	x5, x5, x4, ror #18
    1a04: cac4a4a5     	eor	x5, x5, x4, ror #41
    1a08: 8a040067     	and	x7, x3, x4
    1a0c: aa0a00ea     	orr	x10, x7, x10
    1a10: a941cfe7     	ldp	x7, x19, [sp, #0x18]
    1a14: 8b070129     	add	x9, x9, x7
    1a18: 8b0a0129     	add	x9, x9, x10
    1a1c: d29b778a     	mov	x10, #0xdbbc            ; =56252
    1a20: f2b0312a     	movk	x10, #0x8189, lsl #16
    1a24: f2db74aa     	movk	x10, #0xdba5, lsl #32
    1a28: f2fd36aa     	movk	x10, #0xe9b5, lsl #48
    1a2c: 8b0a0129     	add	x9, x9, x10
    1a30: 8b05012a     	add	x10, x9, x5
    1a34: 93cb7169     	ror	x9, x11, #0x1c
    1a38: cacb8929     	eor	x9, x9, x11, ror #34
    1a3c: cacb9d29     	eor	x9, x9, x11, ror #39
    1a40: aa0201a5     	orr	x5, x13, x2
    1a44: 8a050165     	and	x5, x11, x5
    1a48: 8a0201a7     	and	x7, x13, x2
    1a4c: aa0700a5     	orr	x5, x5, x7
    1a50: 8b050129     	add	x9, x9, x5
    1a54: 8b0a0129     	add	x9, x9, x10
    1a58: 8b080145     	add	x5, x10, x8
    1a5c: 8a25006a     	bic	x10, x3, x5
    1a60: 93c538a7     	ror	x7, x5, #0xe
    1a64: cac548e7     	eor	x7, x7, x5, ror #18
    1a68: cac5a4e7     	eor	x7, x7, x5, ror #41
    1a6c: 8a050094     	and	x20, x4, x5
    1a70: aa0a028a     	orr	x10, x20, x10
    1a74: 8b060266     	add	x6, x19, x6
    1a78: 8b0a00ca     	add	x10, x6, x10
    1a7c: d296a706     	mov	x6, #0xb538             ; =46392
    1a80: f2be6906     	movk	x6, #0xf348, lsl #16
    1a84: f2d84b66     	movk	x6, #0xc25b, lsl #32
    1a88: f2e72ac6     	movk	x6, #0x3956, lsl #48
    1a8c: 8b06014a     	add	x10, x10, x6
    1a90: 8b070146     	add	x6, x10, x7
    1a94: 93c9712a     	ror	x10, x9, #0x1c
    1a98: cac9894a     	eor	x10, x10, x9, ror #34
    1a9c: cac99d4a     	eor	x10, x10, x9, ror #39
    1aa0: aa0d0167     	orr	x7, x11, x13
    1aa4: 8a070127     	and	x7, x9, x7
    1aa8: 8a0d0173     	and	x19, x11, x13
    1aac: aa1300e7     	orr	x7, x7, x19
    1ab0: 8b07014a     	add	x10, x10, x7
    1ab4: 8b06014a     	add	x10, x10, x6
    1ab8: 8b0200c6     	add	x6, x6, x2
    1abc: 8a260082     	bic	x2, x4, x6
    1ac0: 93c638c7     	ror	x7, x6, #0xe
    1ac4: cac648e7     	eor	x7, x7, x6, ror #18
    1ac8: cac6a4e7     	eor	x7, x7, x6, ror #41
    1acc: 8a0600b3     	and	x19, x5, x6
    1ad0: aa020262     	orr	x2, x19, x2
    1ad4: a942d3f3     	ldp	x19, x20, [sp, #0x28]
    1ad8: 8b030263     	add	x3, x19, x3
    1adc: 8b020062     	add	x2, x3, x2
    1ae0: d29a0323     	mov	x3, #0xd019             ; =53273
    1ae4: f2b6c0a3     	movk	x3, #0xb605, lsl #16
    1ae8: f2c23e23     	movk	x3, #0x11f1, lsl #32
    1aec: f2eb3e23     	movk	x3, #0x59f1, lsl #48
    1af0: 8b030042     	add	x2, x2, x3
    1af4: 8b070043     	add	x3, x2, x7
    1af8: 93ca7142     	ror	x2, x10, #0x1c
    1afc: caca8842     	eor	x2, x2, x10, ror #34
    1b00: caca9c42     	eor	x2, x2, x10, ror #39
    1b04: aa0b0127     	orr	x7, x9, x11
    1b08: 8a070147     	and	x7, x10, x7
    1b0c: 8a0b0133     	and	x19, x9, x11
    1b10: aa1300e7     	orr	x7, x7, x19
    1b14: 8b070042     	add	x2, x2, x7
    1b18: 8b030042     	add	x2, x2, x3
    1b1c: 8b0d0063     	add	x3, x3, x13
    1b20: 8a2300ad     	bic	x13, x5, x3
    1b24: 93c33867     	ror	x7, x3, #0xe
    1b28: cac348e7     	eor	x7, x7, x3, ror #18
    1b2c: cac3a4e7     	eor	x7, x7, x3, ror #41
    1b30: 8a0300d3     	and	x19, x6, x3
    1b34: aa0d026d     	orr	x13, x19, x13
    1b38: 8b040284     	add	x4, x20, x4
    1b3c: 8b0d008d     	add	x13, x4, x13
    1b40: d289f364     	mov	x4, #0x4f9b             ; =20379
    1b44: f2b5e324     	movk	x4, #0xaf19, lsl #16
    1b48: f2d05484     	movk	x4, #0x82a4, lsl #32
    1b4c: f2f247e4     	movk	x4, #0x923f, lsl #48
    1b50: 8b0401ad     	add	x13, x13, x4
    1b54: 8b0701a4     	add	x4, x13, x7
    1b58: 93c2704d     	ror	x13, x2, #0x1c
    1b5c: cac289ad     	eor	x13, x13, x2, ror #34
    1b60: cac29dad     	eor	x13, x13, x2, ror #39
    1b64: aa090147     	orr	x7, x10, x9
    1b68: 8a070047     	and	x7, x2, x7
    1b6c: 8a090153     	and	x19, x10, x9
    1b70: aa1300e7     	orr	x7, x7, x19
    1b74: 8b0701ad     	add	x13, x13, x7
    1b78: 8b0401ad     	add	x13, x13, x4
    1b7c: 8b0b0084     	add	x4, x4, x11
    1b80: 8a2400cb     	bic	x11, x6, x4
    1b84: 93c43887     	ror	x7, x4, #0xe
    1b88: cac448e7     	eor	x7, x7, x4, ror #18
    1b8c: cac4a4e7     	eor	x7, x7, x4, ror #41
    1b90: 8a040073     	and	x19, x3, x4
    1b94: aa0b026b     	orr	x11, x19, x11
    1b98: a943d3f3     	ldp	x19, x20, [sp, #0x38]
    1b9c: 8b050265     	add	x5, x19, x5
    1ba0: 8b0b00ab     	add	x11, x5, x11
    1ba4: d2902305     	mov	x5, #0x8118             ; =33048
    1ba8: f2bb4da5     	movk	x5, #0xda6d, lsl #16
    1bac: f2cbdaa5     	movk	x5, #0x5ed5, lsl #32
    1bb0: f2f56385     	movk	x5, #0xab1c, lsl #48
    1bb4: 8b05016b     	add	x11, x11, x5
    1bb8: 8b070165     	add	x5, x11, x7
    1bbc: 93cd71ab     	ror	x11, x13, #0x1c
    1bc0: cacd896b     	eor	x11, x11, x13, ror #34
    1bc4: cacd9d6b     	eor	x11, x11, x13, ror #39
    1bc8: aa0a0047     	orr	x7, x2, x10
    1bcc: 8a0701a7     	and	x7, x13, x7
    1bd0: 8a0a0053     	and	x19, x2, x10
    1bd4: aa1300e7     	orr	x7, x7, x19
    1bd8: 8b07016b     	add	x11, x11, x7
    1bdc: 8b05016b     	add	x11, x11, x5
    1be0: 8b0900a5     	add	x5, x5, x9
    1be4: 8a250069     	bic	x9, x3, x5
    1be8: 93c538a7     	ror	x7, x5, #0xe
    1bec: cac548e7     	eor	x7, x7, x5, ror #18
    1bf0: cac5a4e7     	eor	x7, x7, x5, ror #41
    1bf4: 8a050093     	and	x19, x4, x5
    1bf8: aa090269     	orr	x9, x19, x9
    1bfc: 8b060286     	add	x6, x20, x6
    1c00: 8b0900c9     	add	x9, x6, x9
    1c04: d2804846     	mov	x6, #0x242              ; =578
    1c08: f2b46066     	movk	x6, #0xa303, lsl #16
    1c0c: f2d55306     	movk	x6, #0xaa98, lsl #32
    1c10: f2fb00e6     	movk	x6, #0xd807, lsl #48
    1c14: 8b060129     	add	x9, x9, x6
    1c18: 8b070126     	add	x6, x9, x7
    1c1c: 93cb7169     	ror	x9, x11, #0x1c
    1c20: cacb8929     	eor	x9, x9, x11, ror #34
    1c24: cacb9d29     	eor	x9, x9, x11, ror #39
    1c28: aa0201a7     	orr	x7, x13, x2
    1c2c: 8a070167     	and	x7, x11, x7
    1c30: 8a0201b3     	and	x19, x13, x2
    1c34: aa1300e7     	orr	x7, x7, x19
    1c38: 8b070129     	add	x9, x9, x7
    1c3c: 8b060129     	add	x9, x9, x6
    1c40: 8b0a00c6     	add	x6, x6, x10
    1c44: 8a26008a     	bic	x10, x4, x6
    1c48: 93c638c7     	ror	x7, x6, #0xe
    1c4c: cac648e7     	eor	x7, x7, x6, ror #18
    1c50: cac6a4e7     	eor	x7, x7, x6, ror #41
    1c54: 8a0600b3     	and	x19, x5, x6
    1c58: aa0a026a     	orr	x10, x19, x10
    1c5c: a944d3f3     	ldp	x19, x20, [sp, #0x48]
    1c60: 8b030263     	add	x3, x19, x3
    1c64: 8b0a006a     	add	x10, x3, x10
    1c68: d28df7c3     	mov	x3, #0x6fbe             ; =28606
    1c6c: f2a8ae03     	movk	x3, #0x4570, lsl #16
    1c70: f2cb6023     	movk	x3, #0x5b01, lsl #32
    1c74: f2e25063     	movk	x3, #0x1283, lsl #48
    1c78: 8b03014a     	add	x10, x10, x3
    1c7c: 8b070143     	add	x3, x10, x7
    1c80: 93c9712a     	ror	x10, x9, #0x1c
    1c84: cac9894a     	eor	x10, x10, x9, ror #34
    1c88: cac99d4a     	eor	x10, x10, x9, ror #39
    1c8c: aa0d0167     	orr	x7, x11, x13
    1c90: 8a070127     	and	x7, x9, x7
    1c94: 8a0d0173     	and	x19, x11, x13
    1c98: aa1300e7     	orr	x7, x7, x19
    1c9c: 8b07014a     	add	x10, x10, x7
    1ca0: 8b03014a     	add	x10, x10, x3
    1ca4: 8b020063     	add	x3, x3, x2
    1ca8: 8a2300a2     	bic	x2, x5, x3
    1cac: 93c33867     	ror	x7, x3, #0xe
    1cb0: cac348e7     	eor	x7, x7, x3, ror #18
    1cb4: cac3a4e7     	eor	x7, x7, x3, ror #41
    1cb8: 8a0300d3     	and	x19, x6, x3
    1cbc: aa020262     	orr	x2, x19, x2
    1cc0: 8b040284     	add	x4, x20, x4
    1cc4: 8b020082     	add	x2, x4, x2
    1cc8: d2965184     	mov	x4, #0xb28c             ; =45708
    1ccc: f2a9dc84     	movk	x4, #0x4ee4, lsl #16
    1cd0: f2d0b7c4     	movk	x4, #0x85be, lsl #32
    1cd4: f2e48624     	movk	x4, #0x2431, lsl #48
    1cd8: 8b040042     	add	x2, x2, x4
    1cdc: 8b070044     	add	x4, x2, x7
    1ce0: 93ca7142     	ror	x2, x10, #0x1c
    1ce4: caca8842     	eor	x2, x2, x10, ror #34
    1ce8: caca9c42     	eor	x2, x2, x10, ror #39
    1cec: aa0b0127     	orr	x7, x9, x11
    1cf0: 8a070147     	and	x7, x10, x7
    1cf4: 8a0b0133     	and	x19, x9, x11
    1cf8: aa1300e7     	orr	x7, x7, x19
    1cfc: 8b070042     	add	x2, x2, x7
    1d00: 8b040042     	add	x2, x2, x4
    1d04: 8b0d0084     	add	x4, x4, x13
    1d08: 8a2400cd     	bic	x13, x6, x4
    1d0c: 93c43887     	ror	x7, x4, #0xe
    1d10: cac448e7     	eor	x7, x7, x4, ror #18
    1d14: cac4a4e7     	eor	x7, x7, x4, ror #41
    1d18: 8a040073     	and	x19, x3, x4
    1d1c: aa0d026d     	orr	x13, x19, x13
    1d20: a945d3f3     	ldp	x19, x20, [sp, #0x58]
    1d24: 8b050265     	add	x5, x19, x5
    1d28: 8b0d00ad     	add	x13, x5, x13
    1d2c: d2969c45     	mov	x5, #0xb4e2             ; =46306
    1d30: f2babfe5     	movk	x5, #0xd5ff, lsl #16
    1d34: f2cfb865     	movk	x5, #0x7dc3, lsl #32
    1d38: f2eaa185     	movk	x5, #0x550c, lsl #48
    1d3c: 8b0501ad     	add	x13, x13, x5
    1d40: 8b0701a5     	add	x5, x13, x7
    1d44: 93c2704d     	ror	x13, x2, #0x1c
    1d48: cac289ad     	eor	x13, x13, x2, ror #34
    1d4c: cac29dad     	eor	x13, x13, x2, ror #39
    1d50: aa090147     	orr	x7, x10, x9
    1d54: 8a070047     	and	x7, x2, x7
    1d58: 8a090153     	and	x19, x10, x9
    1d5c: aa1300e7     	orr	x7, x7, x19
    1d60: 8b0701ad     	add	x13, x13, x7
    1d64: 8b0501ad     	add	x13, x13, x5
    1d68: 8b0b00a5     	add	x5, x5, x11
    1d6c: 8a25006b     	bic	x11, x3, x5
    1d70: 93c538a7     	ror	x7, x5, #0xe
    1d74: cac548e7     	eor	x7, x7, x5, ror #18
    1d78: cac5a4e7     	eor	x7, x7, x5, ror #41
    1d7c: 8a050093     	and	x19, x4, x5
    1d80: aa0b026b     	orr	x11, x19, x11
    1d84: 8b060286     	add	x6, x20, x6
    1d88: 8b0b00cb     	add	x11, x6, x11
    1d8c: d2912de6     	mov	x6, #0x896f             ; =35183
    1d90: f2be4f66     	movk	x6, #0xf27b, lsl #16
    1d94: f2cbae86     	movk	x6, #0x5d74, lsl #32
    1d98: f2ee57c6     	movk	x6, #0x72be, lsl #48
    1d9c: 8b06016b     	add	x11, x11, x6
    1da0: 8b070166     	add	x6, x11, x7
    1da4: 93cd71ab     	ror	x11, x13, #0x1c
    1da8: cacd896b     	eor	x11, x11, x13, ror #34
    1dac: cacd9d6b     	eor	x11, x11, x13, ror #39
    1db0: aa0a0047     	orr	x7, x2, x10
    1db4: 8a0701a7     	and	x7, x13, x7
    1db8: 8a0a0053     	and	x19, x2, x10
    1dbc: aa1300e7     	orr	x7, x7, x19
    1dc0: 8b07016b     	add	x11, x11, x7
    1dc4: 8b06016b     	add	x11, x11, x6
    1dc8: 8b0900c6     	add	x6, x6, x9
    1dcc: 8a260089     	bic	x9, x4, x6
    1dd0: 93c638c7     	ror	x7, x6, #0xe
    1dd4: cac648e7     	eor	x7, x7, x6, ror #18
    1dd8: cac6a4e7     	eor	x7, x7, x6, ror #41
    1ddc: 8a0600b3     	and	x19, x5, x6
    1de0: aa090269     	orr	x9, x19, x9
    1de4: a946d3f3     	ldp	x19, x20, [sp, #0x68]
    1de8: 8b030263     	add	x3, x19, x3
    1dec: 8b090069     	add	x9, x3, x9
    1df0: d292d623     	mov	x3, #0x96b1             ; =38577
    1df4: f2a762c3     	movk	x3, #0x3b16, lsl #16
    1df8: f2d63fc3     	movk	x3, #0xb1fe, lsl #32
    1dfc: f2f01bc3     	movk	x3, #0x80de, lsl #48
    1e00: 8b030129     	add	x9, x9, x3
    1e04: 8b070123     	add	x3, x9, x7
    1e08: 93cb7169     	ror	x9, x11, #0x1c
    1e0c: cacb8929     	eor	x9, x9, x11, ror #34
    1e10: cacb9d29     	eor	x9, x9, x11, ror #39
    1e14: aa0201a7     	orr	x7, x13, x2
    1e18: 8a070167     	and	x7, x11, x7
    1e1c: 8a0201b3     	and	x19, x13, x2
    1e20: aa1300e7     	orr	x7, x7, x19
    1e24: 8b070129     	add	x9, x9, x7
    1e28: 8b030129     	add	x9, x9, x3
    1e2c: 8b0a0063     	add	x3, x3, x10
    1e30: 8a2300aa     	bic	x10, x5, x3
    1e34: 93c33867     	ror	x7, x3, #0xe
    1e38: cac348e7     	eor	x7, x7, x3, ror #18
    1e3c: cac3a4e7     	eor	x7, x7, x3, ror #41
    1e40: 8a0300d3     	and	x19, x6, x3
    1e44: aa0a026a     	orr	x10, x19, x10
    1e48: 8b040284     	add	x4, x20, x4
    1e4c: 8b0a008a     	add	x10, x4, x10
    1e50: d28246a4     	mov	x4, #0x1235             ; =4661
    1e54: f2a4b8e4     	movk	x4, #0x25c7, lsl #16
    1e58: f2c0d4e4     	movk	x4, #0x6a7, lsl #32
    1e5c: f2f37b84     	movk	x4, #0x9bdc, lsl #48
    1e60: 8b04014a     	add	x10, x10, x4
    1e64: 8b070144     	add	x4, x10, x7
    1e68: 93c9712a     	ror	x10, x9, #0x1c
    1e6c: cac9894a     	eor	x10, x10, x9, ror #34
    1e70: cac99d4a     	eor	x10, x10, x9, ror #39
    1e74: aa0d0167     	orr	x7, x11, x13
    1e78: 8a070127     	and	x7, x9, x7
    1e7c: 8a0d0173     	and	x19, x11, x13
    1e80: aa1300e7     	orr	x7, x7, x19
    1e84: 8b07014a     	add	x10, x10, x7
    1e88: 8b04014a     	add	x10, x10, x4
    1e8c: 8b020084     	add	x4, x4, x2
    1e90: 8a2400c2     	bic	x2, x6, x4
    1e94: 93c43887     	ror	x7, x4, #0xe
    1e98: cac448e7     	eor	x7, x7, x4, ror #18
    1e9c: cac4a4e7     	eor	x7, x7, x4, ror #41
    1ea0: 8a040073     	and	x19, x3, x4
    1ea4: aa020262     	orr	x2, x19, x2
    1ea8: a947d3f3     	ldp	x19, x20, [sp, #0x78]
    1eac: 8b050265     	add	x5, x19, x5
    1eb0: 8b0200a2     	add	x2, x5, x2
    1eb4: d284d285     	mov	x5, #0x2694             ; =9876
    1eb8: f2b9ed25     	movk	x5, #0xcf69, lsl #16
    1ebc: f2de2e85     	movk	x5, #0xf174, lsl #32
    1ec0: f2f83365     	movk	x5, #0xc19b, lsl #48
    1ec4: 8b050042     	add	x2, x2, x5
    1ec8: 8b070045     	add	x5, x2, x7
    1ecc: 93ca7142     	ror	x2, x10, #0x1c
    1ed0: caca8842     	eor	x2, x2, x10, ror #34
    1ed4: caca9c42     	eor	x2, x2, x10, ror #39
    1ed8: aa0b0127     	orr	x7, x9, x11
    1edc: 8a070147     	and	x7, x10, x7
    1ee0: 8a0b0133     	and	x19, x9, x11
    1ee4: aa1300e7     	orr	x7, x7, x19
    1ee8: 8b070042     	add	x2, x2, x7
    1eec: 8b050042     	add	x2, x2, x5
    1ef0: 8b0d00a5     	add	x5, x5, x13
    1ef4: 8a25006d     	bic	x13, x3, x5
    1ef8: 93c538a7     	ror	x7, x5, #0xe
    1efc: cac548e7     	eor	x7, x7, x5, ror #18
    1f00: cac5a4e7     	eor	x7, x7, x5, ror #41
    1f04: 8a050093     	and	x19, x4, x5
    1f08: aa0d026d     	orr	x13, x19, x13
    1f0c: 8b060286     	add	x6, x20, x6
    1f10: 8b0d00cd     	add	x13, x6, x13
    1f14: d2895a46     	mov	x6, #0x4ad2             ; =19154
    1f18: f2b3de26     	movk	x6, #0x9ef1, lsl #16
    1f1c: f2cd3826     	movk	x6, #0x69c1, lsl #32
    1f20: f2fc9366     	movk	x6, #0xe49b, lsl #48
    1f24: 8b0601ad     	add	x13, x13, x6
    1f28: 8b0701a6     	add	x6, x13, x7
    1f2c: 93c2704d     	ror	x13, x2, #0x1c
    1f30: cac289ad     	eor	x13, x13, x2, ror #34
    1f34: cac29dad     	eor	x13, x13, x2, ror #39
    1f38: aa090147     	orr	x7, x10, x9
    1f3c: 8a070047     	and	x7, x2, x7
    1f40: 8a090153     	and	x19, x10, x9
    1f44: aa1300e7     	orr	x7, x7, x19
    1f48: 8b0701ad     	add	x13, x13, x7
    1f4c: 8b0601ad     	add	x13, x13, x6
    1f50: 8b0b00c6     	add	x6, x6, x11
    1f54: 8a26008b     	bic	x11, x4, x6
    1f58: 93c638c7     	ror	x7, x6, #0xe
    1f5c: cac648e7     	eor	x7, x7, x6, ror #18
    1f60: cac6a4e7     	eor	x7, x7, x6, ror #41
    1f64: 8a0600b3     	and	x19, x5, x6
    1f68: aa0b026b     	orr	x11, x19, x11
    1f6c: a948d3f3     	ldp	x19, x20, [sp, #0x88]
    1f70: 8b030263     	add	x3, x19, x3
    1f74: 8b0b006b     	add	x11, x3, x11
    1f78: d284bc63     	mov	x3, #0x25e3             ; =9699
    1f7c: f2a709e3     	movk	x3, #0x384f, lsl #16
    1f80: f2c8f0c3     	movk	x3, #0x4786, lsl #32
    1f84: f2fdf7c3     	movk	x3, #0xefbe, lsl #48
    1f88: 8b03016b     	add	x11, x11, x3
    1f8c: 8b070163     	add	x3, x11, x7
    1f90: 93cd71ab     	ror	x11, x13, #0x1c
    1f94: cacd896b     	eor	x11, x11, x13, ror #34
    1f98: cacd9d6b     	eor	x11, x11, x13, ror #39
    1f9c: aa0a0047     	orr	x7, x2, x10
    1fa0: 8a0701a7     	and	x7, x13, x7
    1fa4: 8a0a0053     	and	x19, x2, x10
    1fa8: aa1300e7     	orr	x7, x7, x19
    1fac: 8b07016b     	add	x11, x11, x7
    1fb0: 8b03016b     	add	x11, x11, x3
    1fb4: 8b090063     	add	x3, x3, x9
    1fb8: 8a2300a9     	bic	x9, x5, x3
    1fbc: 93c33867     	ror	x7, x3, #0xe
    1fc0: cac348e7     	eor	x7, x7, x3, ror #18
    1fc4: cac3a4e7     	eor	x7, x7, x3, ror #41
    1fc8: 8a0300d3     	and	x19, x6, x3
    1fcc: aa090269     	orr	x9, x19, x9
    1fd0: 8b040284     	add	x4, x20, x4
    1fd4: 8b090089     	add	x9, x4, x9
    1fd8: d29ab6a4     	mov	x4, #0xd5b5             ; =54709
    1fdc: f2b17184     	movk	x4, #0x8b8c, lsl #16
    1fe0: f2d3b8c4     	movk	x4, #0x9dc6, lsl #32
    1fe4: f2e1f824     	movk	x4, #0xfc1, lsl #48
    1fe8: 8b040129     	add	x9, x9, x4
    1fec: 8b070124     	add	x4, x9, x7
    1ff0: 93cb7169     	ror	x9, x11, #0x1c
    1ff4: cacb8929     	eor	x9, x9, x11, ror #34
    1ff8: cacb9d29     	eor	x9, x9, x11, ror #39
    1ffc: aa0201a7     	orr	x7, x13, x2
    2000: 8a070167     	and	x7, x11, x7
    2004: 8a0201b3     	and	x19, x13, x2
    2008: aa1300e7     	orr	x7, x7, x19
    200c: 8b070129     	add	x9, x9, x7
    2010: 8b040129     	add	x9, x9, x4
    2014: 8b0a0084     	add	x4, x4, x10
    2018: 8a2400ca     	bic	x10, x6, x4
    201c: 93c43887     	ror	x7, x4, #0xe
    2020: cac448e7     	eor	x7, x7, x4, ror #18
    2024: cac4a4e7     	eor	x7, x7, x4, ror #41
    2028: 8a040073     	and	x19, x3, x4
    202c: aa0a026a     	orr	x10, x19, x10
    2030: a949d3f3     	ldp	x19, x20, [sp, #0x98]
    2034: 8b050265     	add	x5, x19, x5
    2038: 8b0a00aa     	add	x10, x5, x10
    203c: d2938ca5     	mov	x5, #0x9c65             ; =40037
    2040: f2aef585     	movk	x5, #0x77ac, lsl #16
    2044: f2d43985     	movk	x5, #0xa1cc, lsl #32
    2048: f2e48185     	movk	x5, #0x240c, lsl #48
    204c: 8b05014a     	add	x10, x10, x5
    2050: 8b070145     	add	x5, x10, x7
    2054: 93c9712a     	ror	x10, x9, #0x1c
    2058: cac9894a     	eor	x10, x10, x9, ror #34
    205c: cac99d4a     	eor	x10, x10, x9, ror #39
    2060: aa0d0167     	orr	x7, x11, x13
    2064: 8a070127     	and	x7, x9, x7
    2068: 8a0d0173     	and	x19, x11, x13
    206c: aa1300e7     	orr	x7, x7, x19
    2070: 8b07014a     	add	x10, x10, x7
    2074: 8b05014a     	add	x10, x10, x5
    2078: 8b0200a5     	add	x5, x5, x2
    207c: 8a250062     	bic	x2, x3, x5
    2080: 93c538a7     	ror	x7, x5, #0xe
    2084: cac548e7     	eor	x7, x7, x5, ror #18
    2088: cac5a4e7     	eor	x7, x7, x5, ror #41
    208c: 8a050093     	and	x19, x4, x5
    2090: aa020262     	orr	x2, x19, x2
    2094: 8b060286     	add	x6, x20, x6
    2098: 8b0200c2     	add	x2, x6, x2
    209c: d2804ea6     	mov	x6, #0x275              ; =629
    20a0: f2ab2566     	movk	x6, #0x592b, lsl #16
    20a4: f2c58de6     	movk	x6, #0x2c6f, lsl #32
    20a8: f2e5bd26     	movk	x6, #0x2de9, lsl #48
    20ac: 8b060042     	add	x2, x2, x6
    20b0: 8b070046     	add	x6, x2, x7
    20b4: 93ca7142     	ror	x2, x10, #0x1c
    20b8: caca8842     	eor	x2, x2, x10, ror #34
    20bc: caca9c42     	eor	x2, x2, x10, ror #39
    20c0: aa0b0127     	orr	x7, x9, x11
    20c4: 8a070147     	and	x7, x10, x7
    20c8: 8a0b0133     	and	x19, x9, x11
    20cc: aa1300e7     	orr	x7, x7, x19
    20d0: 8b070042     	add	x2, x2, x7
    20d4: 8b060042     	add	x2, x2, x6
    20d8: 8b0d00c6     	add	x6, x6, x13
    20dc: 8a26008d     	bic	x13, x4, x6
    20e0: 93c638c7     	ror	x7, x6, #0xe
    20e4: cac648e7     	eor	x7, x7, x6, ror #18
    20e8: cac6a4e7     	eor	x7, x7, x6, ror #41
    20ec: 8a0600b3     	and	x19, x5, x6
    20f0: aa0d026d     	orr	x13, x19, x13
    20f4: a94ad3f3     	ldp	x19, x20, [sp, #0xa8]
    20f8: 8b030263     	add	x3, x19, x3
    20fc: 8b0d006d     	add	x13, x3, x13
    2100: d29c9063     	mov	x3, #0xe483             ; =58499
    2104: f2add4c3     	movk	x3, #0x6ea6, lsl #16
    2108: f2d09543     	movk	x3, #0x84aa, lsl #32
    210c: f2e94e83     	movk	x3, #0x4a74, lsl #48
    2110: 8b0301ad     	add	x13, x13, x3
    2114: 8b0701a3     	add	x3, x13, x7
    2118: 93c2704d     	ror	x13, x2, #0x1c
    211c: cac289ad     	eor	x13, x13, x2, ror #34
    2120: cac29dad     	eor	x13, x13, x2, ror #39
    2124: aa090147     	orr	x7, x10, x9
    2128: 8a070047     	and	x7, x2, x7
    212c: 8a090153     	and	x19, x10, x9
    2130: aa1300e7     	orr	x7, x7, x19
    2134: 8b0701ad     	add	x13, x13, x7
    2138: 8b0301ad     	add	x13, x13, x3
    213c: 8b0b0063     	add	x3, x3, x11
    2140: 8a2300ab     	bic	x11, x5, x3
    2144: 93c33867     	ror	x7, x3, #0xe
    2148: cac348e7     	eor	x7, x7, x3, ror #18
    214c: cac3a4e7     	eor	x7, x7, x3, ror #41
    2150: 8a0300d3     	and	x19, x6, x3
    2154: aa0b026b     	orr	x11, x19, x11
    2158: 8b040284     	add	x4, x20, x4
    215c: 8b0b008b     	add	x11, x4, x11
    2160: d29f7a84     	mov	x4, #0xfbd4             ; =64468
    2164: f2b7a824     	movk	x4, #0xbd41, lsl #16
    2168: f2d53b84     	movk	x4, #0xa9dc, lsl #32
    216c: f2eb9604     	movk	x4, #0x5cb0, lsl #48
    2170: 8b04016b     	add	x11, x11, x4
    2174: 8b070164     	add	x4, x11, x7
    2178: 93cd71ab     	ror	x11, x13, #0x1c
    217c: cacd896b     	eor	x11, x11, x13, ror #34
    2180: cacd9d6b     	eor	x11, x11, x13, ror #39
    2184: aa0a0047     	orr	x7, x2, x10
    2188: 8a0701a7     	and	x7, x13, x7
    218c: 8a0a0053     	and	x19, x2, x10
    2190: aa1300e7     	orr	x7, x7, x19
    2194: 8b07016b     	add	x11, x11, x7
    2198: 8b04016b     	add	x11, x11, x4
    219c: 8b090084     	add	x4, x4, x9
    21a0: 8a2400c9     	bic	x9, x6, x4
    21a4: 93c43887     	ror	x7, x4, #0xe
    21a8: cac448e7     	eor	x7, x7, x4, ror #18
    21ac: cac4a4e7     	eor	x7, x7, x4, ror #41
    21b0: 8a040073     	and	x19, x3, x4
    21b4: aa090269     	orr	x9, x19, x9
    21b8: a94bd3f3     	ldp	x19, x20, [sp, #0xb8]
    21bc: 8b050265     	add	x5, x19, x5
    21c0: 8b0900a9     	add	x9, x5, x9
    21c4: d28a76a5     	mov	x5, #0x53b5             ; =21429
    21c8: f2b06225     	movk	x5, #0x8311, lsl #16
    21cc: f2d11b45     	movk	x5, #0x88da, lsl #32
    21d0: f2eedf25     	movk	x5, #0x76f9, lsl #48
    21d4: 8b050129     	add	x9, x9, x5
    21d8: 8b070125     	add	x5, x9, x7
    21dc: 93cb7169     	ror	x9, x11, #0x1c
    21e0: cacb8929     	eor	x9, x9, x11, ror #34
    21e4: cacb9d29     	eor	x9, x9, x11, ror #39
    21e8: aa0201a7     	orr	x7, x13, x2
    21ec: 8a070167     	and	x7, x11, x7
    21f0: 8a0201b3     	and	x19, x13, x2
    21f4: aa1300e7     	orr	x7, x7, x19
    21f8: 8b070129     	add	x9, x9, x7
    21fc: 8b050129     	add	x9, x9, x5
    2200: 8b0a00a5     	add	x5, x5, x10
    2204: 8a25006a     	bic	x10, x3, x5
    2208: 93c538a7     	ror	x7, x5, #0xe
    220c: cac548e7     	eor	x7, x7, x5, ror #18
    2210: cac5a4e7     	eor	x7, x7, x5, ror #41
    2214: 8a050093     	and	x19, x4, x5
    2218: aa0a026a     	orr	x10, x19, x10
    221c: 8b060286     	add	x6, x20, x6
    2220: 8b0a00ca     	add	x10, x6, x10
    2224: d29bf566     	mov	x6, #0xdfab             ; =57259
    2228: f2bdccc6     	movk	x6, #0xee66, lsl #16
    222c: f2ca2a46     	movk	x6, #0x5152, lsl #32
    2230: f2f307c6     	movk	x6, #0x983e, lsl #48
    2234: 8b06014a     	add	x10, x10, x6
    2238: 8b070146     	add	x6, x10, x7
    223c: 93c9712a     	ror	x10, x9, #0x1c
    2240: cac9894a     	eor	x10, x10, x9, ror #34
    2244: cac99d4a     	eor	x10, x10, x9, ror #39
    2248: aa0d0167     	orr	x7, x11, x13
    224c: 8a070127     	and	x7, x9, x7
    2250: 8a0d0173     	and	x19, x11, x13
    2254: aa1300e7     	orr	x7, x7, x19
    2258: 8b07014a     	add	x10, x10, x7
    225c: 8b06014a     	add	x10, x10, x6
    2260: 8b0200c6     	add	x6, x6, x2
    2264: 8a260082     	bic	x2, x4, x6
    2268: 93c638c7     	ror	x7, x6, #0xe
    226c: cac648e7     	eor	x7, x7, x6, ror #18
    2270: cac6a4e7     	eor	x7, x7, x6, ror #41
    2274: 8a0600b3     	and	x19, x5, x6
    2278: aa020262     	orr	x2, x19, x2
    227c: a94cd3f3     	ldp	x19, x20, [sp, #0xc8]
    2280: 8b030263     	add	x3, x19, x3
    2284: 8b020062     	add	x2, x3, x2
    2288: d2864203     	mov	x3, #0x3210             ; =12816
    228c: f2a5b683     	movk	x3, #0x2db4, lsl #16
    2290: f2d8cda3     	movk	x3, #0xc66d, lsl #32
    2294: f2f50623     	movk	x3, #0xa831, lsl #48
    2298: 8b030042     	add	x2, x2, x3
    229c: 8b070043     	add	x3, x2, x7
    22a0: 93ca7142     	ror	x2, x10, #0x1c
    22a4: caca8842     	eor	x2, x2, x10, ror #34
    22a8: caca9c42     	eor	x2, x2, x10, ror #39
    22ac: aa0b0127     	orr	x7, x9, x11
    22b0: 8a070147     	and	x7, x10, x7
    22b4: 8a0b0133     	and	x19, x9, x11
    22b8: aa1300e7     	orr	x7, x7, x19
    22bc: 8b070042     	add	x2, x2, x7
    22c0: 8b030042     	add	x2, x2, x3
    22c4: 8b0d0063     	add	x3, x3, x13
    22c8: 8a2300ad     	bic	x13, x5, x3
    22cc: 93c33867     	ror	x7, x3, #0xe
    22d0: cac348e7     	eor	x7, x7, x3, ror #18
    22d4: cac3a4e7     	eor	x7, x7, x3, ror #41
    22d8: 8a0300d3     	and	x19, x6, x3
    22dc: aa0d026d     	orr	x13, x19, x13
    22e0: 8b040284     	add	x4, x20, x4
    22e4: 8b0d008d     	add	x13, x4, x13
    22e8: d28427e4     	mov	x4, #0x213f             ; =8511
    22ec: f2b31f64     	movk	x4, #0x98fb, lsl #16
    22f0: f2c4f904     	movk	x4, #0x27c8, lsl #32
    22f4: f2f60064     	movk	x4, #0xb003, lsl #48
    22f8: 8b0401ad     	add	x13, x13, x4
    22fc: 8b0701a4     	add	x4, x13, x7
    2300: 93c2704d     	ror	x13, x2, #0x1c
    2304: cac289ad     	eor	x13, x13, x2, ror #34
    2308: cac29dad     	eor	x13, x13, x2, ror #39
    230c: aa090147     	orr	x7, x10, x9
    2310: 8a070047     	and	x7, x2, x7
    2314: 8a090153     	and	x19, x10, x9
    2318: aa1300e7     	orr	x7, x7, x19
    231c: 8b0701ad     	add	x13, x13, x7
    2320: 8b0401ad     	add	x13, x13, x4
    2324: 8b0b0084     	add	x4, x4, x11
    2328: 8a2400cb     	bic	x11, x6, x4
    232c: 93c43887     	ror	x7, x4, #0xe
    2330: cac448e7     	eor	x7, x7, x4, ror #18
    2334: cac4a4e7     	eor	x7, x7, x4, ror #41
    2338: 8a040073     	and	x19, x3, x4
    233c: aa0b026b     	orr	x11, x19, x11
    2340: a94dd3f3     	ldp	x19, x20, [sp, #0xd8]
    2344: 8b050265     	add	x5, x19, x5
    2348: 8b0b00ab     	add	x11, x5, x11
    234c: d281dc85     	mov	x5, #0xee4              ; =3812
    2350: f2b7dde5     	movk	x5, #0xbeef, lsl #16
    2354: f2cff8e5     	movk	x5, #0x7fc7, lsl #32
    2358: f2f7eb25     	movk	x5, #0xbf59, lsl #48
    235c: 8b05016b     	add	x11, x11, x5
    2360: 8b070165     	add	x5, x11, x7
    2364: 93cd71ab     	ror	x11, x13, #0x1c
    2368: cacd896b     	eor	x11, x11, x13, ror #34
    236c: cacd9d6b     	eor	x11, x11, x13, ror #39
    2370: aa0a0047     	orr	x7, x2, x10
    2374: 8a0701a7     	and	x7, x13, x7
    2378: 8a0a0053     	and	x19, x2, x10
    237c: aa1300e7     	orr	x7, x7, x19
    2380: 8b07016b     	add	x11, x11, x7
    2384: 8b05016b     	add	x11, x11, x5
    2388: 8b0900a5     	add	x5, x5, x9
    238c: 8a250069     	bic	x9, x3, x5
    2390: 93c538a7     	ror	x7, x5, #0xe
    2394: cac548e7     	eor	x7, x7, x5, ror #18
    2398: cac5a4e7     	eor	x7, x7, x5, ror #41
    239c: 8a050093     	and	x19, x4, x5
    23a0: aa090269     	orr	x9, x19, x9
    23a4: 8b060286     	add	x6, x20, x6
    23a8: 8b0900c9     	add	x9, x6, x9
    23ac: d291f846     	mov	x6, #0x8fc2             ; =36802
    23b0: f2a7b506     	movk	x6, #0x3da8, lsl #16
    23b4: f2c17e66     	movk	x6, #0xbf3, lsl #32
    23b8: f2f8dc06     	movk	x6, #0xc6e0, lsl #48
    23bc: 8b060129     	add	x9, x9, x6
    23c0: 8b070126     	add	x6, x9, x7
    23c4: 93cb7169     	ror	x9, x11, #0x1c
    23c8: cacb8929     	eor	x9, x9, x11, ror #34
    23cc: cacb9d29     	eor	x9, x9, x11, ror #39
    23d0: aa0201a7     	orr	x7, x13, x2
    23d4: 8a070167     	and	x7, x11, x7
    23d8: 8a0201b3     	and	x19, x13, x2
    23dc: aa1300e7     	orr	x7, x7, x19
    23e0: 8b070129     	add	x9, x9, x7
    23e4: 8b060129     	add	x9, x9, x6
    23e8: 8b0a00c6     	add	x6, x6, x10
    23ec: 8a26008a     	bic	x10, x4, x6
    23f0: 93c638c7     	ror	x7, x6, #0xe
    23f4: cac648e7     	eor	x7, x7, x6, ror #18
    23f8: cac6a4e7     	eor	x7, x7, x6, ror #41
    23fc: 8a0600b3     	and	x19, x5, x6
    2400: aa0a026a     	orr	x10, x19, x10
    2404: a94ed3f3     	ldp	x19, x20, [sp, #0xe8]
    2408: 8b030263     	add	x3, x19, x3
    240c: 8b0a006a     	add	x10, x3, x10
    2410: d294e4a3     	mov	x3, #0xa725             ; =42789
    2414: f2b26143     	movk	x3, #0x930a, lsl #16
    2418: f2d228e3     	movk	x3, #0x9147, lsl #32
    241c: f2fab4e3     	movk	x3, #0xd5a7, lsl #48
    2420: 8b03014a     	add	x10, x10, x3
    2424: 8b070143     	add	x3, x10, x7
    2428: 93c9712a     	ror	x10, x9, #0x1c
    242c: cac9894a     	eor	x10, x10, x9, ror #34
    2430: cac99d4a     	eor	x10, x10, x9, ror #39
    2434: aa0d0167     	orr	x7, x11, x13
    2438: 8a070127     	and	x7, x9, x7
    243c: 8a0d0173     	and	x19, x11, x13
    2440: aa1300e7     	orr	x7, x7, x19
    2444: 8b07014a     	add	x10, x10, x7
    2448: 8b03014a     	add	x10, x10, x3
    244c: 8b020063     	add	x3, x3, x2
    2450: 8a2300a2     	bic	x2, x5, x3
    2454: 93c33867     	ror	x7, x3, #0xe
    2458: cac348e7     	eor	x7, x7, x3, ror #18
    245c: cac3a4e7     	eor	x7, x7, x3, ror #41
    2460: 8a0300d3     	and	x19, x6, x3
    2464: aa020262     	orr	x2, x19, x2
    2468: 8b040284     	add	x4, x20, x4
    246c: 8b020082     	add	x2, x4, x2
    2470: d2904de4     	mov	x4, #0x826f             ; =33391
    2474: f2bc0064     	movk	x4, #0xe003, lsl #16
    2478: f2cc6a24     	movk	x4, #0x6351, lsl #32
    247c: f2e0d944     	movk	x4, #0x6ca, lsl #48
    2480: 8b040042     	add	x2, x2, x4
    2484: 8b070044     	add	x4, x2, x7
    2488: 93ca7142     	ror	x2, x10, #0x1c
    248c: caca8842     	eor	x2, x2, x10, ror #34
    2490: caca9c42     	eor	x2, x2, x10, ror #39
    2494: aa0b0127     	orr	x7, x9, x11
    2498: 8a070147     	and	x7, x10, x7
    249c: 8a0b0133     	and	x19, x9, x11
    24a0: aa1300e7     	orr	x7, x7, x19
    24a4: 8b070042     	add	x2, x2, x7
    24a8: 8b040042     	add	x2, x2, x4
    24ac: 8b0d0084     	add	x4, x4, x13
    24b0: 8a2400cd     	bic	x13, x6, x4
    24b4: 93c43887     	ror	x7, x4, #0xe
    24b8: cac448e7     	eor	x7, x7, x4, ror #18
    24bc: cac4a4e7     	eor	x7, x7, x4, ror #41
    24c0: 8a040073     	and	x19, x3, x4
    24c4: aa0d026d     	orr	x13, x19, x13
    24c8: a94fd3f3     	ldp	x19, x20, [sp, #0xf8]
    24cc: 8b050265     	add	x5, x19, x5
    24d0: 8b0d00ad     	add	x13, x5, x13
    24d4: d28dce05     	mov	x5, #0x6e70             ; =28272
    24d8: f2a141c5     	movk	x5, #0xa0e, lsl #16
    24dc: f2c52ce5     	movk	x5, #0x2967, lsl #32
    24e0: f2e28525     	movk	x5, #0x1429, lsl #48
    24e4: 8b0501ad     	add	x13, x13, x5
    24e8: 8b0701a5     	add	x5, x13, x7
    24ec: 93c2704d     	ror	x13, x2, #0x1c
    24f0: cac289ad     	eor	x13, x13, x2, ror #34
    24f4: cac29dad     	eor	x13, x13, x2, ror #39
    24f8: aa090147     	orr	x7, x10, x9
    24fc: 8a070047     	and	x7, x2, x7
    2500: 8a090153     	and	x19, x10, x9
    2504: aa1300e7     	orr	x7, x7, x19
    2508: 8b0701ad     	add	x13, x13, x7
    250c: 8b0501ad     	add	x13, x13, x5
    2510: 8b0b00a5     	add	x5, x5, x11
    2514: 8a25006b     	bic	x11, x3, x5
    2518: 93c538a7     	ror	x7, x5, #0xe
    251c: cac548e7     	eor	x7, x7, x5, ror #18
    2520: cac5a4e7     	eor	x7, x7, x5, ror #41
    2524: 8a050093     	and	x19, x4, x5
    2528: aa0b026b     	orr	x11, x19, x11
    252c: 8b060286     	add	x6, x20, x6
    2530: 8b0b00cb     	add	x11, x6, x11
    2534: d285ff86     	mov	x6, #0x2ffc             ; =12284
    2538: f2a8da46     	movk	x6, #0x46d2, lsl #16
    253c: f2c150a6     	movk	x6, #0xa85, lsl #32
    2540: f2e4f6e6     	movk	x6, #0x27b7, lsl #48
    2544: 8b06016b     	add	x11, x11, x6
    2548: 8b070166     	add	x6, x11, x7
    254c: 93cd71ab     	ror	x11, x13, #0x1c
    2550: cacd896b     	eor	x11, x11, x13, ror #34
    2554: cacd9d6b     	eor	x11, x11, x13, ror #39
    2558: aa0a0047     	orr	x7, x2, x10
    255c: 8a0701a7     	and	x7, x13, x7
    2560: 8a0a0053     	and	x19, x2, x10
    2564: aa1300e7     	orr	x7, x7, x19
    2568: 8b07016b     	add	x11, x11, x7
    256c: 8b06016b     	add	x11, x11, x6
    2570: 8b0900c6     	add	x6, x6, x9
    2574: 8a260089     	bic	x9, x4, x6
    2578: 93c638c7     	ror	x7, x6, #0xe
    257c: cac648e7     	eor	x7, x7, x6, ror #18
    2580: cac6a4e7     	eor	x7, x7, x6, ror #41
    2584: 8a0600b3     	and	x19, x5, x6
    2588: aa090269     	orr	x9, x19, x9
    258c: a950d3f3     	ldp	x19, x20, [sp, #0x108]
    2590: 8b030263     	add	x3, x19, x3
    2594: 8b090069     	add	x9, x3, x9
    2598: d29924c3     	mov	x3, #0xc926             ; =51494
    259c: f2ab84c3     	movk	x3, #0x5c26, lsl #16
    25a0: f2c42703     	movk	x3, #0x2138, lsl #32
    25a4: f2e5c363     	movk	x3, #0x2e1b, lsl #48
    25a8: 8b030129     	add	x9, x9, x3
    25ac: 8b070123     	add	x3, x9, x7
    25b0: 93cb7169     	ror	x9, x11, #0x1c
    25b4: cacb8929     	eor	x9, x9, x11, ror #34
    25b8: cacb9d29     	eor	x9, x9, x11, ror #39
    25bc: aa0201a7     	orr	x7, x13, x2
    25c0: 8a070167     	and	x7, x11, x7
    25c4: 8a0201b3     	and	x19, x13, x2
    25c8: aa1300e7     	orr	x7, x7, x19
    25cc: 8b070129     	add	x9, x9, x7
    25d0: 8b030129     	add	x9, x9, x3
    25d4: 8b0a0063     	add	x3, x3, x10
    25d8: 8a2300aa     	bic	x10, x5, x3
    25dc: 93c33867     	ror	x7, x3, #0xe
    25e0: cac348e7     	eor	x7, x7, x3, ror #18
    25e4: cac3a4e7     	eor	x7, x7, x3, ror #41
    25e8: 8a0300d3     	and	x19, x6, x3
    25ec: aa0a026a     	orr	x10, x19, x10
    25f0: 8b040284     	add	x4, x20, x4
    25f4: 8b0a008a     	add	x10, x4, x10
    25f8: d2855da4     	mov	x4, #0x2aed             ; =10989
    25fc: f2ab5884     	movk	x4, #0x5ac4, lsl #16
    2600: f2cdbf84     	movk	x4, #0x6dfc, lsl #32
    2604: f2e9a584     	movk	x4, #0x4d2c, lsl #48
    2608: 8b04014a     	add	x10, x10, x4
    260c: 8b070144     	add	x4, x10, x7
    2610: 93c9712a     	ror	x10, x9, #0x1c
    2614: cac9894a     	eor	x10, x10, x9, ror #34
    2618: cac99d4a     	eor	x10, x10, x9, ror #39
    261c: aa0d0167     	orr	x7, x11, x13
    2620: 8a070127     	and	x7, x9, x7
    2624: 8a0d0173     	and	x19, x11, x13
    2628: aa1300e7     	orr	x7, x7, x19
    262c: 8b07014a     	add	x10, x10, x7
    2630: 8b04014a     	add	x10, x10, x4
    2634: 8b020084     	add	x4, x4, x2
    2638: 8a2400c2     	bic	x2, x6, x4
    263c: 93c43887     	ror	x7, x4, #0xe
    2640: cac448e7     	eor	x7, x7, x4, ror #18
    2644: cac4a4e7     	eor	x7, x7, x4, ror #41
    2648: 8a040073     	and	x19, x3, x4
    264c: aa020262     	orr	x2, x19, x2
    2650: a951d3f3     	ldp	x19, x20, [sp, #0x118]
    2654: 8b050265     	add	x5, x19, x5
    2658: 8b0200a2     	add	x2, x5, x2
    265c: d2967be5     	mov	x5, #0xb3df             ; =46047
    2660: f2b3b2a5     	movk	x5, #0x9d95, lsl #16
    2664: f2c1a265     	movk	x5, #0xd13, lsl #32
    2668: f2ea6705     	movk	x5, #0x5338, lsl #48
    266c: 8b050042     	add	x2, x2, x5
    2670: 8b070045     	add	x5, x2, x7
    2674: 93ca7142     	ror	x2, x10, #0x1c
    2678: caca8842     	eor	x2, x2, x10, ror #34
    267c: caca9c42     	eor	x2, x2, x10, ror #39
    2680: aa0b0127     	orr	x7, x9, x11
    2684: 8a070147     	and	x7, x10, x7
    2688: 8a0b0133     	and	x19, x9, x11
    268c: aa1300e7     	orr	x7, x7, x19
    2690: 8b070042     	add	x2, x2, x7
    2694: 8b050042     	add	x2, x2, x5
    2698: 8b0d00a5     	add	x5, x5, x13
    269c: 8a25006d     	bic	x13, x3, x5
    26a0: 93c538a7     	ror	x7, x5, #0xe
    26a4: cac548e7     	eor	x7, x7, x5, ror #18
    26a8: cac5a4e7     	eor	x7, x7, x5, ror #41
    26ac: 8a050093     	and	x19, x4, x5
    26b0: aa0d026d     	orr	x13, x19, x13
    26b4: 8b060286     	add	x6, x20, x6
    26b8: 8b0d00cd     	add	x13, x6, x13
    26bc: d28c7bc6     	mov	x6, #0x63de             ; =25566
    26c0: f2b175e6     	movk	x6, #0x8baf, lsl #16
    26c4: f2ce6a86     	movk	x6, #0x7354, lsl #32
    26c8: f2eca146     	movk	x6, #0x650a, lsl #48
    26cc: 8b0601ad     	add	x13, x13, x6
    26d0: 8b0701a6     	add	x6, x13, x7
    26d4: 93c2704d     	ror	x13, x2, #0x1c
    26d8: cac289ad     	eor	x13, x13, x2, ror #34
    26dc: cac29dad     	eor	x13, x13, x2, ror #39
    26e0: aa090147     	orr	x7, x10, x9
    26e4: 8a070047     	and	x7, x2, x7
    26e8: 8a090153     	and	x19, x10, x9
    26ec: aa1300e7     	orr	x7, x7, x19
    26f0: 8b0701ad     	add	x13, x13, x7
    26f4: 8b0601ad     	add	x13, x13, x6
    26f8: 8b0b00c6     	add	x6, x6, x11
    26fc: 8a26008b     	bic	x11, x4, x6
    2700: 93c638c7     	ror	x7, x6, #0xe
    2704: cac648e7     	eor	x7, x7, x6, ror #18
    2708: cac6a4e7     	eor	x7, x7, x6, ror #41
    270c: 8a0600b3     	and	x19, x5, x6
    2710: aa0b026b     	orr	x11, x19, x11
    2714: a952d3f3     	ldp	x19, x20, [sp, #0x128]
    2718: 8b030263     	add	x3, x19, x3
    271c: 8b0b006b     	add	x11, x3, x11
    2720: d2965503     	mov	x3, #0xb2a8             ; =45736
    2724: f2a78ee3     	movk	x3, #0x3c77, lsl #16
    2728: f2c15763     	movk	x3, #0xabb, lsl #32
    272c: f2eecd43     	movk	x3, #0x766a, lsl #48
    2730: 8b03016b     	add	x11, x11, x3
    2734: 8b070163     	add	x3, x11, x7
    2738: 93cd71ab     	ror	x11, x13, #0x1c
    273c: cacd896b     	eor	x11, x11, x13, ror #34
    2740: cacd9d6b     	eor	x11, x11, x13, ror #39
    2744: aa0a0047     	orr	x7, x2, x10
    2748: 8a0701a7     	and	x7, x13, x7
    274c: 8a0a0053     	and	x19, x2, x10
    2750: aa1300e7     	orr	x7, x7, x19
    2754: 8b07016b     	add	x11, x11, x7
    2758: 8b03016b     	add	x11, x11, x3
    275c: 8b090063     	add	x3, x3, x9
    2760: 8a2300a9     	bic	x9, x5, x3
    2764: 93c33867     	ror	x7, x3, #0xe
    2768: cac348e7     	eor	x7, x7, x3, ror #18
    276c: cac3a4e7     	eor	x7, x7, x3, ror #41
    2770: 8a0300d3     	and	x19, x6, x3
    2774: aa090269     	orr	x9, x19, x9
    2778: 8b040284     	add	x4, x20, x4
    277c: 8b090089     	add	x9, x4, x9
    2780: d295dcc4     	mov	x4, #0xaee6             ; =44774
    2784: f2a8fda4     	movk	x4, #0x47ed, lsl #16
    2788: f2d925c4     	movk	x4, #0xc92e, lsl #32
    278c: f2f03844     	movk	x4, #0x81c2, lsl #48
    2790: 8b040129     	add	x9, x9, x4
    2794: 8b070124     	add	x4, x9, x7
    2798: 93cb7169     	ror	x9, x11, #0x1c
    279c: cacb8929     	eor	x9, x9, x11, ror #34
    27a0: cacb9d29     	eor	x9, x9, x11, ror #39
    27a4: aa0201a7     	orr	x7, x13, x2
    27a8: 8a070167     	and	x7, x11, x7
    27ac: 8a0201b3     	and	x19, x13, x2
    27b0: aa1300e7     	orr	x7, x7, x19
    27b4: 8b070129     	add	x9, x9, x7
    27b8: 8b040129     	add	x9, x9, x4
    27bc: 8b0a0084     	add	x4, x4, x10
    27c0: 8a2400ca     	bic	x10, x6, x4
    27c4: 93c43887     	ror	x7, x4, #0xe
    27c8: cac448e7     	eor	x7, x7, x4, ror #18
    27cc: cac4a4e7     	eor	x7, x7, x4, ror #41
    27d0: 8a040073     	and	x19, x3, x4
    27d4: aa0a026a     	orr	x10, x19, x10
    27d8: a953d3f3     	ldp	x19, x20, [sp, #0x138]
    27dc: 8b050265     	add	x5, x19, x5
    27e0: 8b0a00aa     	add	x10, x5, x10
    27e4: d286a765     	mov	x5, #0x353b             ; =13627
    27e8: f2a29045     	movk	x5, #0x1482, lsl #16
    27ec: f2c590a5     	movk	x5, #0x2c85, lsl #32
    27f0: f2f24e45     	movk	x5, #0x9272, lsl #48
    27f4: 8b05014a     	add	x10, x10, x5
    27f8: 8b070145     	add	x5, x10, x7
    27fc: 93c9712a     	ror	x10, x9, #0x1c
    2800: cac9894a     	eor	x10, x10, x9, ror #34
    2804: cac99d4a     	eor	x10, x10, x9, ror #39
    2808: aa0d0167     	orr	x7, x11, x13
    280c: 8a070127     	and	x7, x9, x7
    2810: 8a0d0173     	and	x19, x11, x13
    2814: aa1300e7     	orr	x7, x7, x19
    2818: 8b07014a     	add	x10, x10, x7
    281c: 8b05014a     	add	x10, x10, x5
    2820: 8b0200a5     	add	x5, x5, x2
    2824: 8a250062     	bic	x2, x3, x5
    2828: 93c538a7     	ror	x7, x5, #0xe
    282c: cac548e7     	eor	x7, x7, x5, ror #18
    2830: cac5a4e7     	eor	x7, x7, x5, ror #41
    2834: 8a050093     	and	x19, x4, x5
    2838: aa020262     	orr	x2, x19, x2
    283c: 8b060286     	add	x6, x20, x6
    2840: 8b0200c2     	add	x2, x6, x2
    2844: d2806c86     	mov	x6, #0x364              ; =868
    2848: f2a99e26     	movk	x6, #0x4cf1, lsl #16
    284c: f2dd1426     	movk	x6, #0xe8a1, lsl #32
    2850: f2f457e6     	movk	x6, #0xa2bf, lsl #48
    2854: 8b060042     	add	x2, x2, x6
    2858: 8b070046     	add	x6, x2, x7
    285c: 93ca7142     	ror	x2, x10, #0x1c
    2860: caca8842     	eor	x2, x2, x10, ror #34
    2864: caca9c42     	eor	x2, x2, x10, ror #39
    2868: aa0b0127     	orr	x7, x9, x11
    286c: 8a070147     	and	x7, x10, x7
    2870: 8a0b0133     	and	x19, x9, x11
    2874: aa1300e7     	orr	x7, x7, x19
    2878: 8b070042     	add	x2, x2, x7
    287c: 8b060042     	add	x2, x2, x6
    2880: 8b0d00c6     	add	x6, x6, x13
    2884: 8a26008d     	bic	x13, x4, x6
    2888: 93c638c7     	ror	x7, x6, #0xe
    288c: cac648e7     	eor	x7, x7, x6, ror #18
    2890: cac6a4e7     	eor	x7, x7, x6, ror #41
    2894: 8a0600b3     	and	x19, x5, x6
    2898: aa0d026d     	orr	x13, x19, x13
    289c: a954d3f3     	ldp	x19, x20, [sp, #0x148]
    28a0: 8b030263     	add	x3, x19, x3
    28a4: 8b0d006d     	add	x13, x3, x13
    28a8: d2860023     	mov	x3, #0x3001             ; =12289
    28ac: f2b78843     	movk	x3, #0xbc42, lsl #16
    28b0: f2ccc963     	movk	x3, #0x664b, lsl #32
    28b4: f2f50343     	movk	x3, #0xa81a, lsl #48
    28b8: 8b0301ad     	add	x13, x13, x3
    28bc: 8b0701a3     	add	x3, x13, x7
    28c0: 93c2704d     	ror	x13, x2, #0x1c
    28c4: cac289ad     	eor	x13, x13, x2, ror #34
    28c8: cac29dad     	eor	x13, x13, x2, ror #39
    28cc: aa090147     	orr	x7, x10, x9
    28d0: 8a070047     	and	x7, x2, x7
    28d4: 8a090153     	and	x19, x10, x9
    28d8: aa1300e7     	orr	x7, x7, x19
    28dc: 8b0701ad     	add	x13, x13, x7
    28e0: 8b0301ad     	add	x13, x13, x3
    28e4: 8b0b0063     	add	x3, x3, x11
    28e8: 8a2300ab     	bic	x11, x5, x3
    28ec: 93c33867     	ror	x7, x3, #0xe
    28f0: cac348e7     	eor	x7, x7, x3, ror #18
    28f4: cac3a4e7     	eor	x7, x7, x3, ror #41
    28f8: 8a0300d3     	and	x19, x6, x3
    28fc: aa0b026b     	orr	x11, x19, x11
    2900: 8b040284     	add	x4, x20, x4
    2904: 8b0b008b     	add	x11, x4, x11
    2908: d292f224     	mov	x4, #0x9791             ; =38801
    290c: f2ba1f04     	movk	x4, #0xd0f8, lsl #16
    2910: f2d16e04     	movk	x4, #0x8b70, lsl #32
    2914: f2f84964     	movk	x4, #0xc24b, lsl #48
    2918: 8b04016b     	add	x11, x11, x4
    291c: 8b070164     	add	x4, x11, x7
    2920: 93cd71ab     	ror	x11, x13, #0x1c
    2924: cacd896b     	eor	x11, x11, x13, ror #34
    2928: cacd9d6b     	eor	x11, x11, x13, ror #39
    292c: aa0a0047     	orr	x7, x2, x10
    2930: 8a0701a7     	and	x7, x13, x7
    2934: 8a0a0053     	and	x19, x2, x10
    2938: aa1300e7     	orr	x7, x7, x19
    293c: 8b07016b     	add	x11, x11, x7
    2940: 8b04016b     	add	x11, x11, x4
    2944: 8b090084     	add	x4, x4, x9
    2948: 8a2400c9     	bic	x9, x6, x4
    294c: 93c43887     	ror	x7, x4, #0xe
    2950: cac448e7     	eor	x7, x7, x4, ror #18
    2954: cac4a4e7     	eor	x7, x7, x4, ror #41
    2958: 8a040073     	and	x19, x3, x4
    295c: aa090269     	orr	x9, x19, x9
    2960: a955d3f3     	ldp	x19, x20, [sp, #0x158]
    2964: 8b050265     	add	x5, x19, x5
    2968: 8b0900a9     	add	x9, x5, x9
    296c: d297c605     	mov	x5, #0xbe30             ; =48688
    2970: f2a0ca85     	movk	x5, #0x654, lsl #16
    2974: f2ca3465     	movk	x5, #0x51a3, lsl #32
    2978: f2f8ed85     	movk	x5, #0xc76c, lsl #48
    297c: 8b050129     	add	x9, x9, x5
    2980: 8b070125     	add	x5, x9, x7
    2984: 93cb7169     	ror	x9, x11, #0x1c
    2988: cacb8929     	eor	x9, x9, x11, ror #34
    298c: cacb9d29     	eor	x9, x9, x11, ror #39
    2990: aa0201a7     	orr	x7, x13, x2
    2994: 8a070167     	and	x7, x11, x7
    2998: 8a0201b3     	and	x19, x13, x2
    299c: aa1300e7     	orr	x7, x7, x19
    29a0: 8b070129     	add	x9, x9, x7
    29a4: 8b050129     	add	x9, x9, x5
    29a8: 8b0a00a5     	add	x5, x5, x10
    29ac: 8a25006a     	bic	x10, x3, x5
    29b0: 93c538a7     	ror	x7, x5, #0xe
    29b4: cac548e7     	eor	x7, x7, x5, ror #18
    29b8: cac5a4e7     	eor	x7, x7, x5, ror #41
    29bc: 8a050093     	and	x19, x4, x5
    29c0: aa0a026a     	orr	x10, x19, x10
    29c4: 8b060286     	add	x6, x20, x6
    29c8: 8b0a00ca     	add	x10, x6, x10
    29cc: d28a4306     	mov	x6, #0x5218             ; =21016
    29d0: f2badde6     	movk	x6, #0xd6ef, lsl #16
    29d4: f2dd0326     	movk	x6, #0xe819, lsl #32
    29d8: f2fa3246     	movk	x6, #0xd192, lsl #48
    29dc: 8b06014a     	add	x10, x10, x6
    29e0: 8b070146     	add	x6, x10, x7
    29e4: 93c9712a     	ror	x10, x9, #0x1c
    29e8: cac9894a     	eor	x10, x10, x9, ror #34
    29ec: cac99d4a     	eor	x10, x10, x9, ror #39
    29f0: aa0d0167     	orr	x7, x11, x13
    29f4: 8a070127     	and	x7, x9, x7
    29f8: 8a0d0173     	and	x19, x11, x13
    29fc: aa1300e7     	orr	x7, x7, x19
    2a00: 8b07014a     	add	x10, x10, x7
    2a04: 8b06014a     	add	x10, x10, x6
    2a08: 8b0200c6     	add	x6, x6, x2
    2a0c: 8a260082     	bic	x2, x4, x6
    2a10: 93c638c7     	ror	x7, x6, #0xe
    2a14: cac648e7     	eor	x7, x7, x6, ror #18
    2a18: cac6a4e7     	eor	x7, x7, x6, ror #41
    2a1c: 8a0600b3     	and	x19, x5, x6
    2a20: aa020262     	orr	x2, x19, x2
    2a24: a956d3f3     	ldp	x19, x20, [sp, #0x168]
    2a28: 8b030263     	add	x3, x19, x3
    2a2c: 8b020062     	add	x2, x3, x2
    2a30: d2952203     	mov	x3, #0xa910             ; =43280
    2a34: f2aaaca3     	movk	x3, #0x5565, lsl #16
    2a38: f2c0c483     	movk	x3, #0x624, lsl #32
    2a3c: f2fad323     	movk	x3, #0xd699, lsl #48
    2a40: 8b030042     	add	x2, x2, x3
    2a44: 8b070043     	add	x3, x2, x7
    2a48: 93ca7142     	ror	x2, x10, #0x1c
    2a4c: caca8842     	eor	x2, x2, x10, ror #34
    2a50: caca9c42     	eor	x2, x2, x10, ror #39
    2a54: aa0b0127     	orr	x7, x9, x11
    2a58: 8a070147     	and	x7, x10, x7
    2a5c: 8a0b0133     	and	x19, x9, x11
    2a60: aa1300e7     	orr	x7, x7, x19
    2a64: 8b070042     	add	x2, x2, x7
    2a68: 8b030042     	add	x2, x2, x3
    2a6c: 8b0d0063     	add	x3, x3, x13
    2a70: 8a2300ad     	bic	x13, x5, x3
    2a74: 93c33867     	ror	x7, x3, #0xe
    2a78: cac348e7     	eor	x7, x7, x3, ror #18
    2a7c: cac3a4e7     	eor	x7, x7, x3, ror #41
    2a80: 8a0300d3     	and	x19, x6, x3
    2a84: aa0d026d     	orr	x13, x19, x13
    2a88: 8b040284     	add	x4, x20, x4
    2a8c: 8b0d008d     	add	x13, x4, x13
    2a90: d2840544     	mov	x4, #0x202a             ; =8234
    2a94: f2aaee24     	movk	x4, #0x5771, lsl #16
    2a98: f2c6b0a4     	movk	x4, #0x3585, lsl #32
    2a9c: f2fe81c4     	movk	x4, #0xf40e, lsl #48
    2aa0: 8b0401ad     	add	x13, x13, x4
    2aa4: 8b0701a4     	add	x4, x13, x7
    2aa8: 93c2704d     	ror	x13, x2, #0x1c
    2aac: cac289ad     	eor	x13, x13, x2, ror #34
    2ab0: cac29dad     	eor	x13, x13, x2, ror #39
    2ab4: aa090147     	orr	x7, x10, x9
    2ab8: 8a070047     	and	x7, x2, x7
    2abc: 8a090153     	and	x19, x10, x9
    2ac0: aa1300e7     	orr	x7, x7, x19
    2ac4: 8b0701ad     	add	x13, x13, x7
    2ac8: 8b0401ad     	add	x13, x13, x4
    2acc: 8b0b0084     	add	x4, x4, x11
    2ad0: 8a2400cb     	bic	x11, x6, x4
    2ad4: 93c43887     	ror	x7, x4, #0xe
    2ad8: cac448e7     	eor	x7, x7, x4, ror #18
    2adc: cac4a4e7     	eor	x7, x7, x4, ror #41
    2ae0: 8a040073     	and	x19, x3, x4
    2ae4: aa0b026b     	orr	x11, x19, x11
    2ae8: a957d3f3     	ldp	x19, x20, [sp, #0x178]
    2aec: 8b050265     	add	x5, x19, x5
    2af0: 8b0b00ab     	add	x11, x5, x11
    2af4: d29a3705     	mov	x5, #0xd1b8             ; =53688
    2af8: f2a65765     	movk	x5, #0x32bb, lsl #16
    2afc: f2d40e05     	movk	x5, #0xa070, lsl #32
    2b00: f2e20d45     	movk	x5, #0x106a, lsl #48
    2b04: 8b05016b     	add	x11, x11, x5
    2b08: 8b070165     	add	x5, x11, x7
    2b0c: 93cd71ab     	ror	x11, x13, #0x1c
    2b10: cacd896b     	eor	x11, x11, x13, ror #34
    2b14: cacd9d6b     	eor	x11, x11, x13, ror #39
    2b18: aa0a0047     	orr	x7, x2, x10
    2b1c: 8a0701a7     	and	x7, x13, x7
    2b20: 8a0a0053     	and	x19, x2, x10
    2b24: aa1300e7     	orr	x7, x7, x19
    2b28: 8b07016b     	add	x11, x11, x7
    2b2c: 8b05016b     	add	x11, x11, x5
    2b30: 8b0900a5     	add	x5, x5, x9
    2b34: 8a250069     	bic	x9, x3, x5
    2b38: 93c538a7     	ror	x7, x5, #0xe
    2b3c: cac548e7     	eor	x7, x7, x5, ror #18
    2b40: cac5a4e7     	eor	x7, x7, x5, ror #41
    2b44: 8a050093     	and	x19, x4, x5
    2b48: aa090269     	orr	x9, x19, x9
    2b4c: 8b060286     	add	x6, x20, x6
    2b50: 8b0900c9     	add	x9, x6, x9
    2b54: d29a1906     	mov	x6, #0xd0c8             ; =53448
    2b58: f2b71a46     	movk	x6, #0xb8d2, lsl #16
    2b5c: f2d822c6     	movk	x6, #0xc116, lsl #32
    2b60: f2e33486     	movk	x6, #0x19a4, lsl #48
    2b64: 8b060129     	add	x9, x9, x6
    2b68: 8b070126     	add	x6, x9, x7
    2b6c: 93cb7169     	ror	x9, x11, #0x1c
    2b70: cacb8929     	eor	x9, x9, x11, ror #34
    2b74: cacb9d29     	eor	x9, x9, x11, ror #39
    2b78: aa0201a7     	orr	x7, x13, x2
    2b7c: 8a070167     	and	x7, x11, x7
    2b80: 8a0201b3     	and	x19, x13, x2
    2b84: aa1300e7     	orr	x7, x7, x19
    2b88: 8b070129     	add	x9, x9, x7
    2b8c: 8b060129     	add	x9, x9, x6
    2b90: 8b0a00c6     	add	x6, x6, x10
    2b94: 8a26008a     	bic	x10, x4, x6
    2b98: 93c638c7     	ror	x7, x6, #0xe
    2b9c: cac648e7     	eor	x7, x7, x6, ror #18
    2ba0: cac6a4e7     	eor	x7, x7, x6, ror #41
    2ba4: 8a0600b3     	and	x19, x5, x6
    2ba8: aa0a026a     	orr	x10, x19, x10
    2bac: a958d3f3     	ldp	x19, x20, [sp, #0x188]
    2bb0: 8b030263     	add	x3, x19, x3
    2bb4: 8b0a006a     	add	x10, x3, x10
    2bb8: d2956a63     	mov	x3, #0xab53             ; =43859
    2bbc: f2aa2823     	movk	x3, #0x5141, lsl #16
    2bc0: f2cd8103     	movk	x3, #0x6c08, lsl #32
    2bc4: f2e3c6e3     	movk	x3, #0x1e37, lsl #48
    2bc8: 8b03014a     	add	x10, x10, x3
    2bcc: 8b070143     	add	x3, x10, x7
    2bd0: 93c9712a     	ror	x10, x9, #0x1c
    2bd4: cac9894a     	eor	x10, x10, x9, ror #34
    2bd8: cac99d4a     	eor	x10, x10, x9, ror #39
    2bdc: aa0d0167     	orr	x7, x11, x13
    2be0: 8a070127     	and	x7, x9, x7
    2be4: 8a0d0173     	and	x19, x11, x13
    2be8: aa1300e7     	orr	x7, x7, x19
    2bec: 8b07014a     	add	x10, x10, x7
    2bf0: 8b03014a     	add	x10, x10, x3
    2bf4: 8b020063     	add	x3, x3, x2
    2bf8: 8a2300a2     	bic	x2, x5, x3
    2bfc: 93c33867     	ror	x7, x3, #0xe
    2c00: cac348e7     	eor	x7, x7, x3, ror #18
    2c04: cac3a4e7     	eor	x7, x7, x3, ror #41
    2c08: 8a0300d3     	and	x19, x6, x3
    2c0c: aa020262     	orr	x2, x19, x2
    2c10: 8b040284     	add	x4, x20, x4
    2c14: 8b020082     	add	x2, x4, x2
    2c18: d29d7324     	mov	x4, #0xeb99             ; =60313
    2c1c: f2bbf1c4     	movk	x4, #0xdf8e, lsl #16
    2c20: f2cee984     	movk	x4, #0x774c, lsl #32
    2c24: f2e4e904     	movk	x4, #0x2748, lsl #48
    2c28: 8b040042     	add	x2, x2, x4
    2c2c: 8b070044     	add	x4, x2, x7
    2c30: 93ca7142     	ror	x2, x10, #0x1c
    2c34: caca8842     	eor	x2, x2, x10, ror #34
    2c38: caca9c42     	eor	x2, x2, x10, ror #39
    2c3c: aa0b0127     	orr	x7, x9, x11
    2c40: 8a070147     	and	x7, x10, x7
    2c44: 8a0b0133     	and	x19, x9, x11
    2c48: aa1300e7     	orr	x7, x7, x19
    2c4c: 8b070042     	add	x2, x2, x7
    2c50: 8b040042     	add	x2, x2, x4
    2c54: 8b0d0084     	add	x4, x4, x13
    2c58: 8a2400cd     	bic	x13, x6, x4
    2c5c: 93c43887     	ror	x7, x4, #0xe
    2c60: cac448e7     	eor	x7, x7, x4, ror #18
    2c64: cac4a4e7     	eor	x7, x7, x4, ror #41
    2c68: 8a040073     	and	x19, x3, x4
    2c6c: aa0d026d     	orr	x13, x19, x13
    2c70: a959d3f3     	ldp	x19, x20, [sp, #0x198]
    2c74: 8b050265     	add	x5, x19, x5
    2c78: 8b0d00ad     	add	x13, x5, x13
    2c7c: d2891505     	mov	x5, #0x48a8             ; =18600
    2c80: f2bc3365     	movk	x5, #0xe19b, lsl #16
    2c84: f2d796a5     	movk	x5, #0xbcb5, lsl #32
    2c88: f2e69605     	movk	x5, #0x34b0, lsl #48
    2c8c: 8b0501ad     	add	x13, x13, x5
    2c90: 8b0701a5     	add	x5, x13, x7
    2c94: 93c2704d     	ror	x13, x2, #0x1c
    2c98: cac289ad     	eor	x13, x13, x2, ror #34
    2c9c: cac29dad     	eor	x13, x13, x2, ror #39
    2ca0: aa090147     	orr	x7, x10, x9
    2ca4: 8a070047     	and	x7, x2, x7
    2ca8: 8a090153     	and	x19, x10, x9
    2cac: aa1300e7     	orr	x7, x7, x19
    2cb0: 8b0701ad     	add	x13, x13, x7
    2cb4: 8b0501ad     	add	x13, x13, x5
    2cb8: 8b0b00a5     	add	x5, x5, x11
    2cbc: 8a25006b     	bic	x11, x3, x5
    2cc0: 93c538a7     	ror	x7, x5, #0xe
    2cc4: cac548e7     	eor	x7, x7, x5, ror #18
    2cc8: cac5a4e7     	eor	x7, x7, x5, ror #41
    2ccc: 8a050093     	and	x19, x4, x5
    2cd0: aa0b026b     	orr	x11, x19, x11
    2cd4: 8b060286     	add	x6, x20, x6
    2cd8: 8b0b00cb     	add	x11, x6, x11
    2cdc: d28b4c66     	mov	x6, #0x5a63             ; =23139
    2ce0: f2b8b926     	movk	x6, #0xc5c9, lsl #16
    2ce4: f2c19666     	movk	x6, #0xcb3, lsl #32
    2ce8: f2e72386     	movk	x6, #0x391c, lsl #48
    2cec: 8b06016b     	add	x11, x11, x6
    2cf0: 8b070166     	add	x6, x11, x7
    2cf4: 93cd71ab     	ror	x11, x13, #0x1c
    2cf8: cacd896b     	eor	x11, x11, x13, ror #34
    2cfc: cacd9d6b     	eor	x11, x11, x13, ror #39
    2d00: aa0a0047     	orr	x7, x2, x10
    2d04: 8a0701a7     	and	x7, x13, x7
    2d08: 8a0a0053     	and	x19, x2, x10
    2d0c: aa1300e7     	orr	x7, x7, x19
    2d10: 8b07016b     	add	x11, x11, x7
    2d14: 8b06016b     	add	x11, x11, x6
    2d18: 8b0900c6     	add	x6, x6, x9
    2d1c: 8a260089     	bic	x9, x4, x6
    2d20: 93c638c7     	ror	x7, x6, #0xe
    2d24: cac648e7     	eor	x7, x7, x6, ror #18
    2d28: cac6a4e7     	eor	x7, x7, x6, ror #41
    2d2c: 8a0600b3     	and	x19, x5, x6
    2d30: aa090269     	orr	x9, x19, x9
    2d34: a95ad3f3     	ldp	x19, x20, [sp, #0x1a8]
    2d38: 8b030263     	add	x3, x19, x3
    2d3c: 8b090069     	add	x9, x3, x9
    2d40: d2915963     	mov	x3, #0x8acb             ; =35531
    2d44: f2bc6823     	movk	x3, #0xe341, lsl #16
    2d48: f2d54943     	movk	x3, #0xaa4a, lsl #32
    2d4c: f2e9db03     	movk	x3, #0x4ed8, lsl #48
    2d50: 8b030129     	add	x9, x9, x3
    2d54: 8b070123     	add	x3, x9, x7
    2d58: 93cb7169     	ror	x9, x11, #0x1c
    2d5c: cacb8929     	eor	x9, x9, x11, ror #34
    2d60: cacb9d29     	eor	x9, x9, x11, ror #39
    2d64: aa0201a7     	orr	x7, x13, x2
    2d68: 8a070167     	and	x7, x11, x7
    2d6c: 8a0201b3     	and	x19, x13, x2
    2d70: aa1300e7     	orr	x7, x7, x19
    2d74: 8b070129     	add	x9, x9, x7
    2d78: 8b030129     	add	x9, x9, x3
    2d7c: 8b0a0063     	add	x3, x3, x10
    2d80: 8a2300aa     	bic	x10, x5, x3
    2d84: 93c33867     	ror	x7, x3, #0xe
    2d88: cac348e7     	eor	x7, x7, x3, ror #18
    2d8c: cac3a4e7     	eor	x7, x7, x3, ror #41
    2d90: 8a0300d3     	and	x19, x6, x3
    2d94: aa0a026a     	orr	x10, x19, x10
    2d98: 8b040284     	add	x4, x20, x4
    2d9c: 8b0a008a     	add	x10, x4, x10
    2da0: d29c6e64     	mov	x4, #0xe373             ; =58227
    2da4: f2aeec64     	movk	x4, #0x7763, lsl #16
    2da8: f2d949e4     	movk	x4, #0xca4f, lsl #32
    2dac: f2eb7384     	movk	x4, #0x5b9c, lsl #48
    2db0: 8b04014a     	add	x10, x10, x4
    2db4: 8b070144     	add	x4, x10, x7
    2db8: 93c9712a     	ror	x10, x9, #0x1c
    2dbc: cac9894a     	eor	x10, x10, x9, ror #34
    2dc0: cac99d4a     	eor	x10, x10, x9, ror #39
    2dc4: aa0d0167     	orr	x7, x11, x13
    2dc8: 8a070127     	and	x7, x9, x7
    2dcc: 8a0d0173     	and	x19, x11, x13
    2dd0: aa1300e7     	orr	x7, x7, x19
    2dd4: 8b07014a     	add	x10, x10, x7
    2dd8: 8b04014a     	add	x10, x10, x4
    2ddc: 8b020084     	add	x4, x4, x2
    2de0: 8a2400c2     	bic	x2, x6, x4
    2de4: 93c43887     	ror	x7, x4, #0xe
    2de8: cac448e7     	eor	x7, x7, x4, ror #18
    2dec: cac4a4e7     	eor	x7, x7, x4, ror #41
    2df0: 8a040073     	and	x19, x3, x4
    2df4: aa020262     	orr	x2, x19, x2
    2df8: a95bd3f3     	ldp	x19, x20, [sp, #0x1b8]
    2dfc: 8b050265     	add	x5, x19, x5
    2e00: 8b0200a2     	add	x2, x5, x2
    2e04: d2971465     	mov	x5, #0xb8a3             ; =47267
    2e08: f2bad645     	movk	x5, #0xd6b2, lsl #16
    2e0c: f2cdfe65     	movk	x5, #0x6ff3, lsl #32
    2e10: f2ed05c5     	movk	x5, #0x682e, lsl #48
    2e14: 8b050042     	add	x2, x2, x5
    2e18: 8b070045     	add	x5, x2, x7
    2e1c: 93ca7142     	ror	x2, x10, #0x1c
    2e20: caca8842     	eor	x2, x2, x10, ror #34
    2e24: caca9c42     	eor	x2, x2, x10, ror #39
    2e28: aa0b0127     	orr	x7, x9, x11
    2e2c: 8a070147     	and	x7, x10, x7
    2e30: 8a0b0133     	and	x19, x9, x11
    2e34: aa1300e7     	orr	x7, x7, x19
    2e38: 8b070042     	add	x2, x2, x7
    2e3c: 8b050042     	add	x2, x2, x5
    2e40: 8b0d00a5     	add	x5, x5, x13
    2e44: 8a25006d     	bic	x13, x3, x5
    2e48: 93c538a7     	ror	x7, x5, #0xe
    2e4c: cac548e7     	eor	x7, x7, x5, ror #18
    2e50: cac5a4e7     	eor	x7, x7, x5, ror #41
    2e54: 8a050093     	and	x19, x4, x5
    2e58: aa0d026d     	orr	x13, x19, x13
    2e5c: 8b060286     	add	x6, x20, x6
    2e60: 8b0d00cd     	add	x13, x6, x13
    2e64: d2965f86     	mov	x6, #0xb2fc             ; =45820
    2e68: f2abbde6     	movk	x6, #0x5def, lsl #16
    2e6c: f2d05dc6     	movk	x6, #0x82ee, lsl #32
    2e70: f2ee91e6     	movk	x6, #0x748f, lsl #48
    2e74: 8b0601ad     	add	x13, x13, x6
    2e78: 8b0701a6     	add	x6, x13, x7
    2e7c: 93c2704d     	ror	x13, x2, #0x1c
    2e80: cac289ad     	eor	x13, x13, x2, ror #34
    2e84: cac29dad     	eor	x13, x13, x2, ror #39
    2e88: aa090147     	orr	x7, x10, x9
    2e8c: 8a070047     	and	x7, x2, x7
    2e90: 8a090153     	and	x19, x10, x9
    2e94: aa1300e7     	orr	x7, x7, x19
    2e98: 8b0701ad     	add	x13, x13, x7
    2e9c: 8b0601ad     	add	x13, x13, x6
    2ea0: 8b0b00c6     	add	x6, x6, x11
    2ea4: 8a26008b     	bic	x11, x4, x6
    2ea8: 93c638c7     	ror	x7, x6, #0xe
    2eac: cac648e7     	eor	x7, x7, x6, ror #18
    2eb0: cac6a4e7     	eor	x7, x7, x6, ror #41
    2eb4: 8a0600b3     	and	x19, x5, x6
    2eb8: aa0b026b     	orr	x11, x19, x11
    2ebc: a95cd3f3     	ldp	x19, x20, [sp, #0x1c8]
    2ec0: 8b030263     	add	x3, x19, x3
    2ec4: 8b0b006b     	add	x11, x3, x11
    2ec8: d285ec03     	mov	x3, #0x2f60             ; =12128
    2ecc: f2a862e3     	movk	x3, #0x4317, lsl #16
    2ed0: f2cc6de3     	movk	x3, #0x636f, lsl #32
    2ed4: f2ef14a3     	movk	x3, #0x78a5, lsl #48
    2ed8: 8b03016b     	add	x11, x11, x3
    2edc: 8b070163     	add	x3, x11, x7
    2ee0: 93cd71ab     	ror	x11, x13, #0x1c
    2ee4: cacd896b     	eor	x11, x11, x13, ror #34
    2ee8: cacd9d6b     	eor	x11, x11, x13, ror #39
    2eec: aa0a0047     	orr	x7, x2, x10
    2ef0: 8a0701a7     	and	x7, x13, x7
    2ef4: 8a0a0053     	and	x19, x2, x10
    2ef8: aa1300e7     	orr	x7, x7, x19
    2efc: 8b07016b     	add	x11, x11, x7
    2f00: 8b03016b     	add	x11, x11, x3
    2f04: 8b090063     	add	x3, x3, x9
    2f08: 8a2300a9     	bic	x9, x5, x3
    2f0c: 93c33867     	ror	x7, x3, #0xe
    2f10: cac348e7     	eor	x7, x7, x3, ror #18
    2f14: cac3a4e7     	eor	x7, x7, x3, ror #41
    2f18: 8a0300d3     	and	x19, x6, x3
    2f1c: aa090269     	orr	x9, x19, x9
    2f20: 8b040284     	add	x4, x20, x4
    2f24: 8b090089     	add	x9, x4, x9
    2f28: d2956e44     	mov	x4, #0xab72             ; =43890
    2f2c: f2b43e04     	movk	x4, #0xa1f0, lsl #16
    2f30: f2cf0284     	movk	x4, #0x7814, lsl #32
    2f34: f2f09904     	movk	x4, #0x84c8, lsl #48
    2f38: 8b040129     	add	x9, x9, x4
    2f3c: 8b070124     	add	x4, x9, x7
    2f40: 93cb7169     	ror	x9, x11, #0x1c
    2f44: cacb8929     	eor	x9, x9, x11, ror #34
    2f48: cacb9d29     	eor	x9, x9, x11, ror #39
    2f4c: aa0201a7     	orr	x7, x13, x2
    2f50: 8a070167     	and	x7, x11, x7
    2f54: 8a0201b3     	and	x19, x13, x2
    2f58: aa1300e7     	orr	x7, x7, x19
    2f5c: 8b070129     	add	x9, x9, x7
    2f60: 8b040129     	add	x9, x9, x4
    2f64: 8b0a0084     	add	x4, x4, x10
    2f68: 8a2400ca     	bic	x10, x6, x4
    2f6c: 93c43887     	ror	x7, x4, #0xe
    2f70: cac448e7     	eor	x7, x7, x4, ror #18
    2f74: cac4a4e7     	eor	x7, x7, x4, ror #41
    2f78: 8a040073     	and	x19, x3, x4
    2f7c: aa0a026a     	orr	x10, x19, x10
    2f80: a95dd3f3     	ldp	x19, x20, [sp, #0x1d8]
    2f84: 8b050265     	add	x5, x19, x5
    2f88: 8b0a00aa     	add	x10, x5, x10
    2f8c: d2873d85     	mov	x5, #0x39ec             ; =14828
    2f90: f2a34c85     	movk	x5, #0x1a64, lsl #16
    2f94: f2c04105     	movk	x5, #0x208, lsl #32
    2f98: f2f198e5     	movk	x5, #0x8cc7, lsl #48
    2f9c: 8b05014a     	add	x10, x10, x5
    2fa0: 8b070145     	add	x5, x10, x7
    2fa4: 93c9712a     	ror	x10, x9, #0x1c
    2fa8: cac9894a     	eor	x10, x10, x9, ror #34
    2fac: cac99d4a     	eor	x10, x10, x9, ror #39
    2fb0: aa0d0167     	orr	x7, x11, x13
    2fb4: 8a070127     	and	x7, x9, x7
    2fb8: 8a0d0173     	and	x19, x11, x13
    2fbc: aa1300e7     	orr	x7, x7, x19
    2fc0: 8b07014a     	add	x10, x10, x7
    2fc4: 8b05014a     	add	x10, x10, x5
    2fc8: 8b0200a5     	add	x5, x5, x2
    2fcc: 8a250062     	bic	x2, x3, x5
    2fd0: 93c538a7     	ror	x7, x5, #0xe
    2fd4: cac548e7     	eor	x7, x7, x5, ror #18
    2fd8: cac5a4e7     	eor	x7, x7, x5, ror #41
    2fdc: 8a050093     	and	x19, x4, x5
    2fe0: aa020262     	orr	x2, x19, x2
    2fe4: 8b060286     	add	x6, x20, x6
    2fe8: 8b0200c2     	add	x2, x6, x2
    2fec: d283c506     	mov	x6, #0x1e28             ; =7720
    2ff0: f2a46c66     	movk	x6, #0x2363, lsl #16
    2ff4: f2dfff46     	movk	x6, #0xfffa, lsl #32
    2ff8: f2f217c6     	movk	x6, #0x90be, lsl #48
    2ffc: 8b060042     	add	x2, x2, x6
    3000: 8b070046     	add	x6, x2, x7
    3004: 93ca7142     	ror	x2, x10, #0x1c
    3008: caca8842     	eor	x2, x2, x10, ror #34
    300c: caca9c42     	eor	x2, x2, x10, ror #39
    3010: aa0b0127     	orr	x7, x9, x11
    3014: 8a070147     	and	x7, x10, x7
    3018: 8a0b0133     	and	x19, x9, x11
    301c: aa1300e7     	orr	x7, x7, x19
    3020: 8b070042     	add	x2, x2, x7
    3024: 8b060042     	add	x2, x2, x6
    3028: 8b0d00c6     	add	x6, x6, x13
    302c: 8a26008d     	bic	x13, x4, x6
    3030: 93c638c7     	ror	x7, x6, #0xe
    3034: cac648e7     	eor	x7, x7, x6, ror #18
    3038: cac6a4e7     	eor	x7, x7, x6, ror #41
    303c: 8a0600b3     	and	x19, x5, x6
    3040: aa0d026d     	orr	x13, x19, x13
    3044: a95ed3f3     	ldp	x19, x20, [sp, #0x1e8]
    3048: 8b030263     	add	x3, x19, x3
    304c: 8b0d006d     	add	x13, x3, x13
    3050: d297bd23     	mov	x3, #0xbde9             ; =48617
    3054: f2bbd043     	movk	x3, #0xde82, lsl #16
    3058: f2cd9d63     	movk	x3, #0x6ceb, lsl #32
    305c: f2f48a03     	movk	x3, #0xa450, lsl #48
    3060: 8b0301ad     	add	x13, x13, x3
    3064: 8b0701a3     	add	x3, x13, x7
    3068: 93c2704d     	ror	x13, x2, #0x1c
    306c: cac289ad     	eor	x13, x13, x2, ror #34
    3070: cac29dad     	eor	x13, x13, x2, ror #39
    3074: aa090147     	orr	x7, x10, x9
    3078: 8a070047     	and	x7, x2, x7
    307c: 8a090153     	and	x19, x10, x9
    3080: aa1300e7     	orr	x7, x7, x19
    3084: 8b0701ad     	add	x13, x13, x7
    3088: 8b0301ad     	add	x13, x13, x3
    308c: 8b0b0067     	add	x7, x3, x11
    3090: 8a2700ab     	bic	x11, x5, x7
    3094: 93c738e3     	ror	x3, x7, #0xe
    3098: cac74863     	eor	x3, x3, x7, ror #18
    309c: cac7a463     	eor	x3, x3, x7, ror #41
    30a0: 8a0700d3     	and	x19, x6, x7
    30a4: aa0b026b     	orr	x11, x19, x11
    30a8: 8b040284     	add	x4, x20, x4
    30ac: 8b0b008b     	add	x11, x4, x11
    30b0: d28f22a4     	mov	x4, #0x7915             ; =30997
    30b4: f2b658c4     	movk	x4, #0xb2c6, lsl #16
    30b8: f2d47ee4     	movk	x4, #0xa3f7, lsl #32
    30bc: f2f7df24     	movk	x4, #0xbef9, lsl #48
    30c0: 8b04016b     	add	x11, x11, x4
    30c4: 8b030163     	add	x3, x11, x3
    30c8: 93cd71ab     	ror	x11, x13, #0x1c
    30cc: cacd896b     	eor	x11, x11, x13, ror #34
    30d0: cacd9d6b     	eor	x11, x11, x13, ror #39
    30d4: aa0a0044     	orr	x4, x2, x10
    30d8: 8a0401a4     	and	x4, x13, x4
    30dc: 8a0a0053     	and	x19, x2, x10
    30e0: aa130084     	orr	x4, x4, x19
    30e4: 8b04016b     	add	x11, x11, x4
    30e8: 8b03016b     	add	x11, x11, x3
    30ec: 8b090064     	add	x4, x3, x9
    30f0: 8a2400c9     	bic	x9, x6, x4
    30f4: 93c43883     	ror	x3, x4, #0xe
    30f8: cac44863     	eor	x3, x3, x4, ror #18
    30fc: cac4a463     	eor	x3, x3, x4, ror #41
    3100: 8a0400f3     	and	x19, x7, x4
    3104: aa090269     	orr	x9, x19, x9
    3108: a95fd3f3     	ldp	x19, x20, [sp, #0x1f8]
    310c: 8b050265     	add	x5, x19, x5
    3110: 8b0900a9     	add	x9, x5, x9
    3114: d28a6565     	mov	x5, #0x532b             ; =21291
    3118: f2bc6e45     	movk	x5, #0xe372, lsl #16
    311c: f2cf1e45     	movk	x5, #0x78f2, lsl #32
    3120: f2f8ce25     	movk	x5, #0xc671, lsl #48
    3124: 8b050129     	add	x9, x9, x5
    3128: 8b030129     	add	x9, x9, x3
    312c: 93cb7163     	ror	x3, x11, #0x1c
    3130: cacb8863     	eor	x3, x3, x11, ror #34
    3134: cacb9c63     	eor	x3, x3, x11, ror #39
    3138: aa0201a5     	orr	x5, x13, x2
    313c: 8a050165     	and	x5, x11, x5
    3140: 8a0201b3     	and	x19, x13, x2
    3144: aa1300a5     	orr	x5, x5, x19
    3148: 8b050063     	add	x3, x3, x5
    314c: 8b090063     	add	x3, x3, x9
    3150: 8b0a0133     	add	x19, x9, x10
    3154: 8a3300e9     	bic	x9, x7, x19
    3158: 93d33a6a     	ror	x10, x19, #0xe
    315c: 8a130085     	and	x5, x4, x19
    3160: aa0900a9     	orr	x9, x5, x9
    3164: cad3494a     	eor	x10, x10, x19, ror #18
    3168: cad3a54a     	eor	x10, x10, x19, ror #41
    316c: 8b060285     	add	x5, x20, x6
    3170: 8b0900a9     	add	x9, x5, x9
    3174: d28c3385     	mov	x5, #0x619c             ; =24988
    3178: f2bd44c5     	movk	x5, #0xea26, lsl #16
    317c: f2c7d9c5     	movk	x5, #0x3ece, lsl #32
    3180: f2f944e5     	movk	x5, #0xca27, lsl #48
    3184: 8b050129     	add	x9, x9, x5
    3188: 8b0a012a     	add	x10, x9, x10
    318c: 93c37069     	ror	x9, x3, #0x1c
    3190: cac38929     	eor	x9, x9, x3, ror #34
    3194: cac39d29     	eor	x9, x9, x3, ror #39
    3198: aa0d0165     	orr	x5, x11, x13
    319c: 8a050065     	and	x5, x3, x5
    31a0: 8a0d0166     	and	x6, x11, x13
    31a4: aa0600a5     	orr	x5, x5, x6
    31a8: 8b050129     	add	x9, x9, x5
    31ac: 8b0a0129     	add	x9, x9, x10
    31b0: 8b020142     	add	x2, x10, x2
    31b4: 8a22008a     	bic	x10, x4, x2
    31b8: 93c23845     	ror	x5, x2, #0xe
    31bc: cac248a5     	eor	x5, x5, x2, ror #18
    31c0: cac2a4a5     	eor	x5, x5, x2, ror #41
    31c4: 8a020266     	and	x6, x19, x2
    31c8: aa0a00ca     	orr	x10, x6, x10
    31cc: f94107e6     	ldr	x6, [sp, #0x208]
    31d0: 8b0700c6     	add	x6, x6, x7
    31d4: 8b0a00ca     	add	x10, x6, x10
    31d8: d29840e6     	mov	x6, #0xc207             ; =49671
    31dc: f2a43806     	movk	x6, #0x21c0, lsl #16
    31e0: f2d718e6     	movk	x6, #0xb8c7, lsl #32
    31e4: f2fa30c6     	movk	x6, #0xd186, lsl #48
    31e8: 8b06014a     	add	x10, x10, x6
    31ec: 8b050145     	add	x5, x10, x5
    31f0: 93c9712a     	ror	x10, x9, #0x1c
    31f4: cac9894a     	eor	x10, x10, x9, ror #34
    31f8: cac99d4a     	eor	x10, x10, x9, ror #39
    31fc: aa0b0066     	orr	x6, x3, x11
    3200: 8a060126     	and	x6, x9, x6
    3204: 8a0b0067     	and	x7, x3, x11
    3208: aa0700c6     	orr	x6, x6, x7
    320c: 8b06014a     	add	x10, x10, x6
    3210: 8b05014a     	add	x10, x10, x5
    3214: 8b0d00a5     	add	x5, x5, x13
    3218: 8a25026d     	bic	x13, x19, x5
    321c: 93c538a6     	ror	x6, x5, #0xe
    3220: cac548c6     	eor	x6, x6, x5, ror #18
    3224: cac5a4c6     	eor	x6, x6, x5, ror #41
    3228: 8a050047     	and	x7, x2, x5
    322c: aa0d00ed     	orr	x13, x7, x13
    3230: f9410be7     	ldr	x7, [sp, #0x210]
    3234: 8b0400e4     	add	x4, x7, x4
    3238: 8b0d008d     	add	x13, x4, x13
    323c: d29d63c4     	mov	x4, #0xeb1e             ; =60190
    3240: f2b9bc04     	movk	x4, #0xcde0, lsl #16
    3244: f2cfbac4     	movk	x4, #0x7dd6, lsl #32
    3248: f2fd5b44     	movk	x4, #0xeada, lsl #48
    324c: 8b0401ad     	add	x13, x13, x4
    3250: 8b0601a4     	add	x4, x13, x6
    3254: 93ca714d     	ror	x13, x10, #0x1c
    3258: caca89ad     	eor	x13, x13, x10, ror #34
    325c: caca9dad     	eor	x13, x13, x10, ror #39
    3260: aa030126     	orr	x6, x9, x3
    3264: 8a060146     	and	x6, x10, x6
    3268: 8a030127     	and	x7, x9, x3
    326c: aa0700c6     	orr	x6, x6, x7
    3270: 8b0601ad     	add	x13, x13, x6
    3274: 8b0401ad     	add	x13, x13, x4
    3278: 8b0b0084     	add	x4, x4, x11
    327c: 8a24004b     	bic	x11, x2, x4
    3280: 93c43886     	ror	x6, x4, #0xe
    3284: cac448c6     	eor	x6, x6, x4, ror #18
    3288: cac4a4c6     	eor	x6, x6, x4, ror #41
    328c: 8a0400a7     	and	x7, x5, x4
    3290: aa0b00eb     	orr	x11, x7, x11
    3294: f9410fe7     	ldr	x7, [sp, #0x218]
    3298: 8b1300e7     	add	x7, x7, x19
    329c: 8b0b00eb     	add	x11, x7, x11
    32a0: d29a2f07     	mov	x7, #0xd178             ; =53624
    32a4: f2bdcdc7     	movk	x7, #0xee6e, lsl #16
    32a8: f2c9efe7     	movk	x7, #0x4f7f, lsl #32
    32ac: f2feafa7     	movk	x7, #0xf57d, lsl #48
    32b0: 8b07016b     	add	x11, x11, x7
    32b4: 8b060166     	add	x6, x11, x6
    32b8: 93cd71ab     	ror	x11, x13, #0x1c
    32bc: cacd896b     	eor	x11, x11, x13, ror #34
    32c0: cacd9d6b     	eor	x11, x11, x13, ror #39
    32c4: aa090147     	orr	x7, x10, x9
    32c8: 8a0701a7     	and	x7, x13, x7
    32cc: 8a090153     	and	x19, x10, x9
    32d0: aa1300e7     	orr	x7, x7, x19
    32d4: 8b07016b     	add	x11, x11, x7
    32d8: 8b06016b     	add	x11, x11, x6
    32dc: 8b0300c3     	add	x3, x6, x3
    32e0: 8a2300a6     	bic	x6, x5, x3
    32e4: 93c33867     	ror	x7, x3, #0xe
    32e8: cac348e7     	eor	x7, x7, x3, ror #18
    32ec: cac3a4e7     	eor	x7, x7, x3, ror #41
    32f0: 8a030093     	and	x19, x4, x3
    32f4: aa060266     	orr	x6, x19, x6
    32f8: f94113f3     	ldr	x19, [sp, #0x220]
    32fc: 8b020262     	add	x2, x19, x2
    3300: 8b060042     	add	x2, x2, x6
    3304: d28df746     	mov	x6, #0x6fba             ; =28602
    3308: f2ae42e6     	movk	x6, #0x7217, lsl #16
    330c: f2ccf546     	movk	x6, #0x67aa, lsl #32
    3310: f2e0de06     	movk	x6, #0x6f0, lsl #48
    3314: 8b060042     	add	x2, x2, x6
    3318: 8b070046     	add	x6, x2, x7
    331c: 93cb7162     	ror	x2, x11, #0x1c
    3320: cacb8842     	eor	x2, x2, x11, ror #34
    3324: cacb9c42     	eor	x2, x2, x11, ror #39
    3328: aa0a01a7     	orr	x7, x13, x10
    332c: 8a070167     	and	x7, x11, x7
    3330: 8a0a01b3     	and	x19, x13, x10
    3334: aa1300e7     	orr	x7, x7, x19
    3338: 8b070042     	add	x2, x2, x7
    333c: 8b060042     	add	x2, x2, x6
    3340: 8b0900c6     	add	x6, x6, x9
    3344: 8a260089     	bic	x9, x4, x6
    3348: 93c638c7     	ror	x7, x6, #0xe
    334c: cac648e7     	eor	x7, x7, x6, ror #18
    3350: cac6a4e7     	eor	x7, x7, x6, ror #41
    3354: 8a060073     	and	x19, x3, x6
    3358: aa090269     	orr	x9, x19, x9
    335c: f94117f3     	ldr	x19, [sp, #0x228]
    3360: 8b050265     	add	x5, x19, x5
    3364: 8b0900a9     	add	x9, x5, x9
    3368: d29314c5     	mov	x5, #0x98a6             ; =39078
    336c: f2b45905     	movk	x5, #0xa2c8, lsl #16
    3370: f2cfb8a5     	movk	x5, #0x7dc5, lsl #32
    3374: f2e14c65     	movk	x5, #0xa63, lsl #48
    3378: 8b050129     	add	x9, x9, x5
    337c: 8b070125     	add	x5, x9, x7
    3380: 93c27049     	ror	x9, x2, #0x1c
    3384: cac28929     	eor	x9, x9, x2, ror #34
    3388: cac29d29     	eor	x9, x9, x2, ror #39
    338c: aa0d0167     	orr	x7, x11, x13
    3390: 8a070047     	and	x7, x2, x7
    3394: 8a0d0173     	and	x19, x11, x13
    3398: aa1300e7     	orr	x7, x7, x19
    339c: 8b070129     	add	x9, x9, x7
    33a0: 8b050129     	add	x9, x9, x5
    33a4: 8b0a00a5     	add	x5, x5, x10
    33a8: 8a25006a     	bic	x10, x3, x5
    33ac: 93c538a7     	ror	x7, x5, #0xe
    33b0: cac548e7     	eor	x7, x7, x5, ror #18
    33b4: cac5a4e7     	eor	x7, x7, x5, ror #41
    33b8: 8a0500d3     	and	x19, x6, x5
    33bc: aa0a026a     	orr	x10, x19, x10
    33c0: f9411bf3     	ldr	x19, [sp, #0x230]
    33c4: 8b040264     	add	x4, x19, x4
    33c8: 8b0a008a     	add	x10, x4, x10
    33cc: d281b5c4     	mov	x4, #0xdae              ; =3502
    33d0: f2b7df24     	movk	x4, #0xbef9, lsl #16
    33d4: f2d30084     	movk	x4, #0x9804, lsl #32
    33d8: f2e227e4     	movk	x4, #0x113f, lsl #48
    33dc: 8b04014a     	add	x10, x10, x4
    33e0: 8b070144     	add	x4, x10, x7
    33e4: 93c9712a     	ror	x10, x9, #0x1c
    33e8: cac9894a     	eor	x10, x10, x9, ror #34
    33ec: cac99d4a     	eor	x10, x10, x9, ror #39
    33f0: aa0b0047     	orr	x7, x2, x11
    33f4: 8a070127     	and	x7, x9, x7
    33f8: 8a0b0053     	and	x19, x2, x11
    33fc: aa1300e7     	orr	x7, x7, x19
    3400: 8b07014a     	add	x10, x10, x7
    3404: 8b04014a     	add	x10, x10, x4
    3408: 8b0d0084     	add	x4, x4, x13
    340c: 8a2400cd     	bic	x13, x6, x4
    3410: 93c43887     	ror	x7, x4, #0xe
    3414: cac448e7     	eor	x7, x7, x4, ror #18
    3418: cac4a4e7     	eor	x7, x7, x4, ror #41
    341c: 8a0400b3     	and	x19, x5, x4
    3420: aa0d026d     	orr	x13, x19, x13
    3424: f9411ff3     	ldr	x19, [sp, #0x238]
    3428: 8b030263     	add	x3, x19, x3
    342c: 8b0d006d     	add	x13, x3, x13
    3430: d288e363     	mov	x3, #0x471b             ; =18203
    3434: f2a26383     	movk	x3, #0x131c, lsl #16
    3438: f2c166a3     	movk	x3, #0xb35, lsl #32
    343c: f2e36e23     	movk	x3, #0x1b71, lsl #48
    3440: 8b0301ad     	add	x13, x13, x3
    3444: 8b0701a3     	add	x3, x13, x7
    3448: 93ca714d     	ror	x13, x10, #0x1c
    344c: caca89ad     	eor	x13, x13, x10, ror #34
    3450: caca9dad     	eor	x13, x13, x10, ror #39
    3454: aa020127     	orr	x7, x9, x2
    3458: 8a070147     	and	x7, x10, x7
    345c: 8a020133     	and	x19, x9, x2
    3460: aa1300e7     	orr	x7, x7, x19
    3464: 8b0701ad     	add	x13, x13, x7
    3468: 8b0301ad     	add	x13, x13, x3
    346c: 8b0b0067     	add	x7, x3, x11
    3470: 8a2700ab     	bic	x11, x5, x7
    3474: 93c738e3     	ror	x3, x7, #0xe
    3478: cac74863     	eor	x3, x3, x7, ror #18
    347c: cac7a463     	eor	x3, x3, x7, ror #41
    3480: 8a070093     	and	x19, x4, x7
    3484: aa0b026b     	orr	x11, x19, x11
    3488: f94123f3     	ldr	x19, [sp, #0x240]
    348c: 8b060266     	add	x6, x19, x6
    3490: 8b0b00cb     	add	x11, x6, x11
    3494: d28fb086     	mov	x6, #0x7d84             ; =32132
    3498: f2a46086     	movk	x6, #0x2304, lsl #16
    349c: f2cefea6     	movk	x6, #0x77f5, lsl #32
    34a0: f2e51b66     	movk	x6, #0x28db, lsl #48
    34a4: 8b06016b     	add	x11, x11, x6
    34a8: 8b030163     	add	x3, x11, x3
    34ac: 93cd71ab     	ror	x11, x13, #0x1c
    34b0: cacd896b     	eor	x11, x11, x13, ror #34
    34b4: cacd9d6b     	eor	x11, x11, x13, ror #39
    34b8: aa090146     	orr	x6, x10, x9
    34bc: 8a0601a6     	and	x6, x13, x6
    34c0: 8a090153     	and	x19, x10, x9
    34c4: aa1300c6     	orr	x6, x6, x19
    34c8: 8b06016b     	add	x11, x11, x6
    34cc: 8b03016b     	add	x11, x11, x3
    34d0: 8b020066     	add	x6, x3, x2
    34d4: 8a260082     	bic	x2, x4, x6
    34d8: 93c638c3     	ror	x3, x6, #0xe
    34dc: cac64863     	eor	x3, x3, x6, ror #18
    34e0: cac6a463     	eor	x3, x3, x6, ror #41
    34e4: 8a0600f3     	and	x19, x7, x6
    34e8: aa020262     	orr	x2, x19, x2
    34ec: f94127f3     	ldr	x19, [sp, #0x248]
    34f0: 8b050265     	add	x5, x19, x5
    34f4: 8b0200a2     	add	x2, x5, x2
    34f8: d2849265     	mov	x5, #0x2493             ; =9363
    34fc: f2a818e5     	movk	x5, #0x40c7, lsl #16
    3500: f2d56f65     	movk	x5, #0xab7b, lsl #32
    3504: f2e65945     	movk	x5, #0x32ca, lsl #48
    3508: 8b050042     	add	x2, x2, x5
    350c: 8b030043     	add	x3, x2, x3
    3510: 93cb7162     	ror	x2, x11, #0x1c
    3514: cacb8842     	eor	x2, x2, x11, ror #34
    3518: cacb9c42     	eor	x2, x2, x11, ror #39
    351c: aa0a01a5     	orr	x5, x13, x10
    3520: 8a050165     	and	x5, x11, x5
    3524: 8a0a01b3     	and	x19, x13, x10
    3528: aa1300a5     	orr	x5, x5, x19
    352c: 8b050042     	add	x2, x2, x5
    3530: 8b030042     	add	x2, x2, x3
    3534: 8b090065     	add	x5, x3, x9
    3538: 8a2500e9     	bic	x9, x7, x5
    353c: 93c538a3     	ror	x3, x5, #0xe
    3540: cac54863     	eor	x3, x3, x5, ror #18
    3544: cac5a463     	eor	x3, x3, x5, ror #41
    3548: 8a0500d3     	and	x19, x6, x5
    354c: aa090269     	orr	x9, x19, x9
    3550: f9412bf3     	ldr	x19, [sp, #0x250]
    3554: 8b040264     	add	x4, x19, x4
    3558: 8b090089     	add	x9, x4, x9
    355c: d297d784     	mov	x4, #0xbebc             ; =48828
    3560: f2a2b924     	movk	x4, #0x15c9, lsl #16
    3564: f2d7c144     	movk	x4, #0xbe0a, lsl #32
    3568: f2e793c4     	movk	x4, #0x3c9e, lsl #48
    356c: 8b040129     	add	x9, x9, x4
    3570: 8b030129     	add	x9, x9, x3
    3574: 93c27043     	ror	x3, x2, #0x1c
    3578: cac28863     	eor	x3, x3, x2, ror #34
    357c: cac29c63     	eor	x3, x3, x2, ror #39
    3580: aa0d0164     	orr	x4, x11, x13
    3584: 8a040044     	and	x4, x2, x4
    3588: 8a0d0173     	and	x19, x11, x13
    358c: aa130084     	orr	x4, x4, x19
    3590: 8b040063     	add	x3, x3, x4
    3594: 8b090063     	add	x3, x3, x9
    3598: 8b0a0124     	add	x4, x9, x10
    359c: 8a2400c9     	bic	x9, x6, x4
    35a0: 93c4388a     	ror	x10, x4, #0xe
    35a4: cac4494a     	eor	x10, x10, x4, ror #18
    35a8: cac4a54a     	eor	x10, x10, x4, ror #41
    35ac: 8a0400b3     	and	x19, x5, x4
    35b0: aa090269     	orr	x9, x19, x9
    35b4: f9412ff3     	ldr	x19, [sp, #0x258]
    35b8: 8b070267     	add	x7, x19, x7
    35bc: 8b0900e9     	add	x9, x7, x9
    35c0: d281a987     	mov	x7, #0xd4c              ; =3404
    35c4: f2b38207     	movk	x7, #0x9c10, lsl #16
    35c8: f2ccf887     	movk	x7, #0x67c4, lsl #32
    35cc: f2e863a7     	movk	x7, #0x431d, lsl #48
    35d0: 8b070129     	add	x9, x9, x7
    35d4: 8b0a012a     	add	x10, x9, x10
    35d8: 93c37069     	ror	x9, x3, #0x1c
    35dc: cac38929     	eor	x9, x9, x3, ror #34
    35e0: cac39d29     	eor	x9, x9, x3, ror #39
    35e4: aa0b0047     	orr	x7, x2, x11
    35e8: 8a070067     	and	x7, x3, x7
    35ec: 8a0b0053     	and	x19, x2, x11
    35f0: aa1300e7     	orr	x7, x7, x19
    35f4: 8b070129     	add	x9, x9, x7
    35f8: 8b0a0129     	add	x9, x9, x10
    35fc: 8b0d014d     	add	x13, x10, x13
    3600: 8a2d00aa     	bic	x10, x5, x13
    3604: 93cd39a7     	ror	x7, x13, #0xe
    3608: cacd48e7     	eor	x7, x7, x13, ror #18
    360c: cacda4e7     	eor	x7, x7, x13, ror #41
    3610: 8a0d0093     	and	x19, x4, x13
    3614: aa0a026a     	orr	x10, x19, x10
    3618: f94133f3     	ldr	x19, [sp, #0x260]
    361c: 8b060266     	add	x6, x19, x6
    3620: 8b0a00ca     	add	x10, x6, x10
    3624: d28856c6     	mov	x6, #0x42b6             ; =17078
    3628: f2b967c6     	movk	x6, #0xcb3e, lsl #16
    362c: f2da97c6     	movk	x6, #0xd4be, lsl #32
    3630: f2e998a6     	movk	x6, #0x4cc5, lsl #48
    3634: 8b06014a     	add	x10, x10, x6
    3638: 8b07014a     	add	x10, x10, x7
    363c: 93c97126     	ror	x6, x9, #0x1c
    3640: cac988c6     	eor	x6, x6, x9, ror #34
    3644: cac99cc6     	eor	x6, x6, x9, ror #39
    3648: aa020067     	orr	x7, x3, x2
    364c: 8a070127     	and	x7, x9, x7
    3650: 8a020073     	and	x19, x3, x2
    3654: aa1300e7     	orr	x7, x7, x19
    3658: 8b0700c6     	add	x6, x6, x7
    365c: 8b0a00c6     	add	x6, x6, x10
    3660: 8b0b014a     	add	x10, x10, x11
    3664: 8a2a008b     	bic	x11, x4, x10
    3668: 93ca3947     	ror	x7, x10, #0xe
    366c: caca48e7     	eor	x7, x7, x10, ror #18
    3670: cacaa4e7     	eor	x7, x7, x10, ror #41
    3674: 8a0a01b3     	and	x19, x13, x10
    3678: aa0b026b     	orr	x11, x19, x11
    367c: f94137f3     	ldr	x19, [sp, #0x268]
    3680: 8b050265     	add	x5, x19, x5
    3684: 8b0b00ab     	add	x11, x5, x11
    3688: d28fc545     	mov	x5, #0x7e2a             ; =32298
    368c: f2bf8ca5     	movk	x5, #0xfc65, lsl #16
    3690: f2c53385     	movk	x5, #0x299c, lsl #32
    3694: f2eb2fe5     	movk	x5, #0x597f, lsl #48
    3698: 8b05016b     	add	x11, x11, x5
    369c: 8b07016b     	add	x11, x11, x7
    36a0: 93c670c5     	ror	x5, x6, #0x1c
    36a4: cac688a5     	eor	x5, x5, x6, ror #34
    36a8: cac69ca5     	eor	x5, x5, x6, ror #39
    36ac: aa030127     	orr	x7, x9, x3
    36b0: 8a0700c7     	and	x7, x6, x7
    36b4: 8a030133     	and	x19, x9, x3
    36b8: aa1300e7     	orr	x7, x7, x19
    36bc: 8b0700a5     	add	x5, x5, x7
    36c0: 8b0b00a5     	add	x5, x5, x11
    36c4: 8b02016b     	add	x11, x11, x2
    36c8: 8a2b01a2     	bic	x2, x13, x11
    36cc: 93cb3967     	ror	x7, x11, #0xe
    36d0: cacb48e7     	eor	x7, x7, x11, ror #18
    36d4: cacba4e7     	eor	x7, x7, x11, ror #41
    36d8: 8a0b0153     	and	x19, x10, x11
    36dc: aa020262     	orr	x2, x19, x2
    36e0: f9413bf3     	ldr	x19, [sp, #0x270]
    36e4: 8b040264     	add	x4, x19, x4
    36e8: 8b020082     	add	x2, x4, x2
    36ec: d29f5d84     	mov	x4, #0xfaec             ; =64236
    36f0: f2a75ac4     	movk	x4, #0x3ad6, lsl #16
    36f4: f2cdf564     	movk	x4, #0x6fab, lsl #32
    36f8: f2ebf964     	movk	x4, #0x5fcb, lsl #48
    36fc: 8b040042     	add	x2, x2, x4
    3700: 8b070042     	add	x2, x2, x7
    3704: 93c570a4     	ror	x4, x5, #0x1c
    3708: cac58884     	eor	x4, x4, x5, ror #34
    370c: cac59c84     	eor	x4, x4, x5, ror #39
    3710: aa0900c7     	orr	x7, x6, x9
    3714: 8a0700a7     	and	x7, x5, x7
    3718: 8a0900d3     	and	x19, x6, x9
    371c: aa1300e7     	orr	x7, x7, x19
    3720: 8b070084     	add	x4, x4, x7
    3724: 8b020084     	add	x4, x4, x2
    3728: 8b030042     	add	x2, x2, x3
    372c: 8a220143     	bic	x3, x10, x2
    3730: 93c23847     	ror	x7, x2, #0xe
    3734: cac248e7     	eor	x7, x7, x2, ror #18
    3738: cac2a4e7     	eor	x7, x7, x2, ror #41
    373c: 8a020173     	and	x19, x11, x2
    3740: aa030263     	orr	x3, x19, x3
    3744: f9413ff3     	ldr	x19, [sp, #0x278]
    3748: 8b0d026d     	add	x13, x19, x13
    374c: 8b0301ad     	add	x13, x13, x3
    3750: d28b02e3     	mov	x3, #0x5817             ; =22551
    3754: f2a948e3     	movk	x3, #0x4a47, lsl #16
    3758: f2c33183     	movk	x3, #0x198c, lsl #32
    375c: f2ed8883     	movk	x3, #0x6c44, lsl #48
    3760: 8b0301ad     	add	x13, x13, x3
    3764: 8b0701ad     	add	x13, x13, x7
    3768: aa0600a3     	orr	x3, x5, x6
    376c: 8a030083     	and	x3, x4, x3
    3770: 8a0600a7     	and	x7, x5, x6
    3774: aa070063     	orr	x3, x3, x7
    3778: 93c47087     	ror	x7, x4, #0x1c
    377c: cac488e7     	eor	x7, x7, x4, ror #34
    3780: cac49ce7     	eor	x7, x7, x4, ror #39
    3784: 8b0300e3     	add	x3, x7, x3
    3788: 8b0d0063     	add	x3, x3, x13
    378c: 8b030108     	add	x8, x8, x3
    3790: 8b04018c     	add	x12, x12, x4
    3794: a9013008     	stp	x8, x12, [x0, #0x10]
    3798: 8b050028     	add	x8, x1, x5
    379c: 8b0601cc     	add	x12, x14, x6
    37a0: a9023008     	stp	x8, x12, [x0, #0x20]
    37a4: 8b090208     	add	x8, x16, x9
    37a8: 8b0d0108     	add	x8, x8, x13
    37ac: 8b0201e9     	add	x9, x15, x2
    37b0: a9032408     	stp	x8, x9, [x0, #0x30]
    37b4: 8b0b0228     	add	x8, x17, x11
    37b8: f9402409     	ldr	x9, [x0, #0x48]
    37bc: 8b0a0129     	add	x9, x9, x10
    37c0: a9042408     	stp	x8, x9, [x0, #0x40]
    37c4: 910a03ff     	add	sp, sp, #0x280
    37c8: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    37cc: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    37d0: a8c36ffc     	ldp	x28, x27, [sp], #0x30
    37d4: d65f03c0     	ret

00000000000037d8 <_audit_master384>:
    37d8: d10643ff     	sub	sp, sp, #0x190
    37dc: a9174ff4     	stp	x20, x19, [sp, #0x170]
    37e0: a9187bfd     	stp	x29, x30, [sp, #0x180]
    37e4: 910603fd     	add	x29, sp, #0x180
    37e8: aa0103f3     	mov	x19, x1
    37ec: aa0003e4     	mov	x4, x0
    37f0: 90000008     	adrp	x8, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x17ec>
		00000000000037f0:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    37f4: 91000108     	add	x8, x8, #0x0
		00000000000037f4:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    37f8: ad400500     	ldp	q0, q1, [x8]
    37fc: 3c8713e0     	stur	q0, [sp, #0x71]
    3800: 52860009     	mov	w9, #0x3000             ; =12288
    3804: 7900c3e9     	strh	w9, [sp, #0x60]
    3808: 528001a9     	mov	w9, #0xd                ; =13
    380c: 39018be9     	strb	w9, [sp, #0x62]
    3810: 90000009     	adrp	x9, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x17ec>
		0000000000003810:  ARM64_RELOC_PAGE21	l___unnamed_1
    3814: 91000129     	add	x9, x9, #0x0
		0000000000003814:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
    3818: f940012a     	ldr	x10, [x9]
    381c: f80633ea     	stur	x10, [sp, #0x63]
    3820: 910183ea     	add	x10, sp, #0x60
    3824: f8405129     	ldur	x9, [x9, #0x5]
    3828: f90037e9     	str	x9, [sp, #0x68]
    382c: 52800609     	mov	w9, #0x30               ; =48
    3830: 3901c3e9     	strb	w9, [sp, #0x70]
    3834: 3c821141     	stur	q1, [x10, #0x21]
    3838: 3dc00900     	ldr	q0, [x8, #0x20]
    383c: 3c831140     	stur	q0, [x10, #0x31]
    3840: 9100c3e0     	add	x0, sp, #0x30
    3844: 910183e2     	add	x2, sp, #0x60
    3848: 52800601     	mov	w1, #0x30               ; =48
    384c: 52800823     	mov	w3, #0x41               ; =65
<L0>:
    3850: 94000000     	bl	 <L0>
		0000000000003850:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
    3854: 90000002     	adrp	x2, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x17ec>
		0000000000003854:  ARM64_RELOC_PAGE21	_memx.Array(48).zero
    3858: 91000042     	add	x2, x2, #0x0
		0000000000003858:  ARM64_RELOC_PAGEOFF12	_memx.Array(48).zero
    385c: 910003e0     	mov	x0, sp
    3860: 9100c3e1     	add	x1, sp, #0x30
<L1>:
    3864: 94000000     	bl	 <L1>
		0000000000003864:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
    3868: 6f00e400     	movi.2d	v0, #0000000000000000
    386c: 3d8017e0     	str	q0, [sp, #0x50]
    3870: 3d8013e0     	str	q0, [sp, #0x40]
    3874: 3d800fe0     	str	q0, [sp, #0x30]
    3878: ad4007e0     	ldp	q0, q1, [sp]
    387c: ad000660     	stp	q0, q1, [x19]
    3880: 3dc00be0     	ldr	q0, [sp, #0x20]
    3884: 3d800a60     	str	q0, [x19, #0x20]
    3888: a9587bfd     	ldp	x29, x30, [sp, #0x180]
    388c: a9574ff4     	ldp	x20, x19, [sp, #0x170]
    3890: 910643ff     	add	sp, sp, #0x190
    3894: d65f03c0     	ret

0000000000003898 <_audit_key384>:
    3898: d104c3ff     	sub	sp, sp, #0x130
    389c: a9116ffc     	stp	x28, x27, [sp, #0x110]
    38a0: a9127bfd     	stp	x29, x30, [sp, #0x120]
    38a4: 910483fd     	add	x29, sp, #0x120
    38a8: aa0003e4     	mov	x4, x0
    38ac: 52840008     	mov	w8, #0x2000             ; =8192
    38b0: 79000be8     	strh	w8, [sp, #0x4]
    38b4: 52800128     	mov	w8, #0x9                ; =9
    38b8: 39001be8     	strb	w8, [sp, #0x6]
    38bc: 52800f28     	mov	w8, #0x79               ; =121
    38c0: 7800f3e8     	sturh	w8, [sp, #0xf]
    38c4: 90000008     	adrp	x8, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x17ec>
		00000000000038c4:  ARM64_RELOC_PAGE21	l___unnamed_3
    38c8: 91000108     	add	x8, x8, #0x0
		00000000000038c8:  ARM64_RELOC_PAGEOFF12	l___unnamed_3
    38cc: f9400108     	ldr	x8, [x8]
    38d0: f80073e8     	stur	x8, [sp, #0x7]
    38d4: 910013e2     	add	x2, sp, #0x4
    38d8: aa0103e0     	mov	x0, x1
    38dc: 52800401     	mov	w1, #0x20               ; =32
    38e0: 528001a3     	mov	w3, #0xd                ; =13
<L0>:
    38e4: 94000000     	bl	 <L0>
		00000000000038e4:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
    38e8: a9527bfd     	ldp	x29, x30, [sp, #0x120]
    38ec: a9516ffc     	ldp	x28, x27, [sp, #0x110]
    38f0: 9104c3ff     	add	sp, sp, #0x130
    38f4: d65f03c0     	ret
