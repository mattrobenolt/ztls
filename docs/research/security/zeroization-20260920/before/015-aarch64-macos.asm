
/tmp/ztls-signoff-20260919/125-before-6d73a0a/015-aarch64-macos.o:	file format mach-o arm64

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
      88: ad4007e0     	ldp	q0, q1, [sp]
      8c: ad000660     	stp	q0, q1, [x19]
      90: a9577bfd     	ldp	x29, x30, [sp, #0x170]
      94: a9564ff4     	ldp	x20, x19, [sp, #0x160]
      98: a9556ffc     	ldp	x28, x27, [sp, #0x150]
      9c: 910603ff     	add	sp, sp, #0x180
      a0: d65f03c0     	ret

00000000000000a4 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
      a4: d106c3ff     	sub	sp, sp, #0x1b0
      a8: a9166ffc     	stp	x28, x27, [sp, #0x160]
      ac: a9175ff8     	stp	x24, x23, [sp, #0x170]
      b0: a91857f6     	stp	x22, x21, [sp, #0x180]
      b4: a9194ff4     	stp	x20, x19, [sp, #0x190]
      b8: a91a7bfd     	stp	x29, x30, [sp, #0x1a0]
      bc: 910683fd     	add	x29, sp, #0x1a0
      c0: aa0203f4     	mov	x20, x2
      c4: aa0003f3     	mov	x19, x0
      c8: 910083f7     	add	x23, sp, #0x20
      cc: 910083e0     	add	x0, sp, #0x20
<L0>:
      d0: 94000000     	bl	 <L0>
		00000000000000d0:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
      d4: 394223e8     	ldrb	w8, [sp, #0x88]
      d8: 34000228     	cbz	w8,  <L3>
      dc: 7100811f     	cmp	w8, #0x20
      e0: 540001e3     	b.lo	 <L3>
      e4: 52800809     	mov	w9, #0x40               ; =64
      e8: cb080135     	sub	x21, x9, x8
      ec: 910083e9     	add	x9, sp, #0x20
      f0: 9100a136     	add	x22, x9, #0x28
      f4: 8b0802c0     	add	x0, x22, x8
      f8: aa1403e1     	mov	x1, x20
      fc: aa1503e2     	mov	x2, x21
<L1>:
     100: 94000000     	bl	 <L1>
		0000000000000100:  ARM64_RELOC_BRANCH26	_memcpy
     104: 910083e0     	add	x0, sp, #0x20
     108: aa1603e1     	mov	x1, x22
<L2>:
     10c: 94000000     	bl	 <L2>
		000000000000010c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     110: 52800008     	mov	w8, #0x0                ; =0
     114: 390223ff     	strb	wzr, [sp, #0x88]
     118: 14000002     	b	 <L4>
<L3>:
     11c: d2800015     	mov	x21, #0x0               ; =0
<L4>:
     120: 52800409     	mov	w9, #0x20               ; =32
     124: cb150136     	sub	x22, x9, x21
     128: 8b2842e8     	add	x8, x23, w8, uxtw
     12c: 9100a100     	add	x0, x8, #0x28
     130: 8b150281     	add	x1, x20, x21
     134: aa1603e2     	mov	x2, x22
<L5>:
     138: 94000000     	bl	 <L5>
		0000000000000138:  ARM64_RELOC_BRANCH26	_memcpy
     13c: 394223e8     	ldrb	w8, [sp, #0x88]
     140: 0b160108     	add	w8, w8, w22
     144: 390223e8     	strb	w8, [sp, #0x88]
     148: f94023e8     	ldr	x8, [sp, #0x40]
     14c: 91008108     	add	x8, x8, #0x20
     150: f90023e8     	str	x8, [sp, #0x40]
     154: 910343f8     	add	x24, sp, #0xd0
     158: 910083e0     	add	x0, sp, #0x20
     15c: 910343e1     	add	x1, sp, #0xd0
<L6>:
     160: 94000000     	bl	 <L6>
		0000000000000160:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     164: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000164:  ARM64_RELOC_PAGE21	l___unnamed_2
     168: 91000108     	add	x8, x8, #0x0
		0000000000000168:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     16c: ad420500     	ldp	q0, q1, [x8, #0x40]
     170: ad3c87a0     	stp	q0, q1, [x29, #-0x70]
     174: 3dc01900     	ldr	q0, [x8, #0x60]
     178: 3c9b03a0     	stur	q0, [x29, #-0x50]
     17c: ad400500     	ldp	q0, q1, [x8]
     180: ad3a87a0     	stp	q0, q1, [x29, #-0xb0]
     184: ad410101     	ldp	q1, q0, [x8, #0x20]
     188: ad3b83a1     	stp	q1, q0, [x29, #-0x90]
     18c: d102c3b4     	sub	x20, x29, #0xb0
     190: d102c3a0     	sub	x0, x29, #0xb0
     194: 9101c2e1     	add	x1, x23, #0x70
<L7>:
     198: 94000000     	bl	 <L7>
		0000000000000198:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     19c: 385b83a8     	ldurb	w8, [x29, #-0x48]
     1a0: f85703a9     	ldur	x9, [x29, #-0x90]
     1a4: 9100a294     	add	x20, x20, #0x28
     1a8: 91010137     	add	x23, x9, #0x40
     1ac: f81703b7     	stur	x23, [x29, #-0x90]
     1b0: 34000208     	cbz	w8,  <L10>
     1b4: 7100811f     	cmp	w8, #0x20
     1b8: 540001c3     	b.lo	 <L10>
     1bc: 52800809     	mov	w9, #0x40               ; =64
     1c0: cb080135     	sub	x21, x9, x8
     1c4: 8b080280     	add	x0, x20, x8
     1c8: 910343e1     	add	x1, sp, #0xd0
     1cc: aa1503e2     	mov	x2, x21
<L8>:
     1d0: 94000000     	bl	 <L8>
		00000000000001d0:  ARM64_RELOC_BRANCH26	_memcpy
     1d4: d102c3a0     	sub	x0, x29, #0xb0
     1d8: aa1403e1     	mov	x1, x20
<L9>:
     1dc: 94000000     	bl	 <L9>
		00000000000001dc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     1e0: 52800008     	mov	w8, #0x0                ; =0
     1e4: 381b83bf     	sturb	wzr, [x29, #-0x48]
     1e8: f85703b7     	ldur	x23, [x29, #-0x90]
     1ec: 14000002     	b	 <L11>
<L10>:
     1f0: d2800015     	mov	x21, #0x0               ; =0
<L11>:
     1f4: 52800409     	mov	w9, #0x20               ; =32
     1f8: cb150136     	sub	x22, x9, x21
     1fc: 8b284280     	add	x0, x20, w8, uxtw
     200: 8b150301     	add	x1, x24, x21
     204: aa1603e2     	mov	x2, x22
<L12>:
     208: 94000000     	bl	 <L12>
		0000000000000208:  ARM64_RELOC_BRANCH26	_memcpy
     20c: 385b83a8     	ldurb	w8, [x29, #-0x48]
     210: 0b160108     	add	w8, w8, w22
     214: 381b83a8     	sturb	w8, [x29, #-0x48]
     218: 910082e8     	add	x8, x23, #0x20
     21c: f81703a8     	stur	x8, [x29, #-0x90]
     220: d102c3a0     	sub	x0, x29, #0xb0
     224: 910003e1     	mov	x1, sp
<L13>:
     228: 94000000     	bl	 <L13>
		0000000000000228:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     22c: ad4007e0     	ldp	q0, q1, [sp]
     230: ad000660     	stp	q0, q1, [x19]
     234: a95a7bfd     	ldp	x29, x30, [sp, #0x1a0]
     238: a9594ff4     	ldp	x20, x19, [sp, #0x190]
     23c: a95857f6     	ldp	x22, x21, [sp, #0x180]
     240: a9575ff8     	ldp	x24, x23, [sp, #0x170]
     244: a9566ffc     	ldp	x28, x27, [sp, #0x160]
     248: 9106c3ff     	add	sp, sp, #0x1b0
     24c: d65f03c0     	ret

0000000000000250 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     250: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
     254: a90167fa     	stp	x26, x25, [sp, #0x10]
     258: a9025ff8     	stp	x24, x23, [sp, #0x20]
     25c: a90357f6     	stp	x22, x21, [sp, #0x30]
     260: a9044ff4     	stp	x20, x19, [sp, #0x40]
     264: a9057bfd     	stp	x29, x30, [sp, #0x50]
     268: 910143fd     	add	x29, sp, #0x50
     26c: d10903ff     	sub	sp, sp, #0x240
     270: aa0303f5     	mov	x21, x3
     274: aa0203f6     	mov	x22, x2
     278: aa0003f3     	mov	x19, x0
     27c: ad400480     	ldp	q0, q1, [x4]
     280: ad0007e0     	stp	q0, q1, [sp]
     284: 52800028     	mov	w8, #0x1                ; =1
     288: 3900bfe8     	strb	w8, [sp, #0x2f]
     28c: f100803f     	cmp	x1, #0x20
     290: 54000322     	b.hs	 <L3>
     294: aa0103f4     	mov	x20, x1
     298: 910383fa     	add	x26, sp, #0xe0
     29c: 910383e0     	add	x0, sp, #0xe0
     2a0: 910003e1     	mov	x1, sp
<L0>:
     2a4: 94000000     	bl	 <L0>
		00000000000002a4:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
     2a8: 394523e8     	ldrb	w8, [sp, #0x148]
     2ac: 34000508     	cbz	w8,  <L7>
     2b0: 8b0802a9     	add	x9, x21, x8
     2b4: f101013f     	cmp	x9, #0x40
     2b8: 540004a3     	b.lo	 <L7>
     2bc: 52800809     	mov	w9, #0x40               ; =64
     2c0: cb080138     	sub	x24, x9, x8
     2c4: 910383e9     	add	x9, sp, #0xe0
     2c8: 9100a137     	add	x23, x9, #0x28
     2cc: 8b0802e0     	add	x0, x23, x8
     2d0: aa1603e1     	mov	x1, x22
     2d4: aa1803e2     	mov	x2, x24
<L1>:
     2d8: 94000000     	bl	 <L1>
		00000000000002d8:  ARM64_RELOC_BRANCH26	_memcpy
     2dc: 910383e0     	add	x0, sp, #0xe0
     2e0: aa1703e1     	mov	x1, x23
<L2>:
     2e4: 94000000     	bl	 <L2>
		00000000000002e4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     2e8: 52800008     	mov	w8, #0x0                ; =0
     2ec: 390523ff     	strb	wzr, [sp, #0x148]
     2f0: 14000018     	b	 <L8>
<L3>:
     2f4: 9100c3f9     	add	x25, sp, #0x30
     2f8: 9100a334     	add	x20, x25, #0x28
     2fc: 9100c3e0     	add	x0, sp, #0x30
     300: 910003e1     	mov	x1, sp
<L4>:
     304: 94000000     	bl	 <L4>
		0000000000000304:  ARM64_RELOC_BRANCH26	_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init
     308: 394263e8     	ldrb	w8, [sp, #0x98]
     30c: 340005a8     	cbz	w8,  <L12>
     310: d24016a9     	eor	x9, x21, #0x3f
     314: eb08013f     	cmp	x9, x8
     318: 54000542     	b.hs	 <L12>
     31c: 52800809     	mov	w9, #0x40               ; =64
     320: cb080137     	sub	x23, x9, x8
     324: 8b080280     	add	x0, x20, x8
     328: aa1603e1     	mov	x1, x22
     32c: aa1703e2     	mov	x2, x23
<L5>:
     330: 94000000     	bl	 <L5>
		0000000000000330:  ARM64_RELOC_BRANCH26	_memcpy
     334: 9100c3e0     	add	x0, sp, #0x30
     338: aa1403e1     	mov	x1, x20
<L6>:
     33c: 94000000     	bl	 <L6>
		000000000000033c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     340: 52800008     	mov	w8, #0x0                ; =0
     344: 390263ff     	strb	wzr, [sp, #0x98]
     348: 1400001f     	b	 <L13>
<L7>:
     34c: d2800018     	mov	x24, #0x0               ; =0
<L8>:
     350: cb1802b9     	sub	x25, x21, x24
     354: 9100a357     	add	x23, x26, #0x28
     358: 8b2842e0     	add	x0, x23, w8, uxtw
     35c: 8b1802c1     	add	x1, x22, x24
     360: aa1903e2     	mov	x2, x25
<L9>:
     364: 94000000     	bl	 <L9>
		0000000000000364:  ARM64_RELOC_BRANCH26	_memcpy
     368: 394523e8     	ldrb	w8, [sp, #0x148]
     36c: f94083e9     	ldr	x9, [sp, #0x100]
     370: 8b150138     	add	x24, x9, x21
     374: f90083f8     	str	x24, [sp, #0x100]
     378: 2b190108     	adds	w8, w8, w25
     37c: 390523e8     	strb	w8, [sp, #0x148]
     380: 540005a0     	b.eq	 <L17>
     384: 7100fd1f     	cmp	w8, #0x3f
     388: 54000563     	b.lo	 <L17>
     38c: 52800809     	mov	w9, #0x40               ; =64
     390: 4b080135     	sub	w21, w9, w8
     394: 8b2842e0     	add	x0, x23, w8, uxtw
     398: 9100bfe1     	add	x1, sp, #0x2f
     39c: aa1503e2     	mov	x2, x21
<L10>:
     3a0: 94000000     	bl	 <L10>
		00000000000003a0:  ARM64_RELOC_BRANCH26	_memcpy
     3a4: 910383e0     	add	x0, sp, #0xe0
     3a8: aa1703e1     	mov	x1, x23
<L11>:
     3ac: 94000000     	bl	 <L11>
		00000000000003ac:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     3b0: 52800008     	mov	w8, #0x0                ; =0
     3b4: 390523ff     	strb	wzr, [sp, #0x148]
     3b8: f94083f8     	ldr	x24, [sp, #0x100]
     3bc: 1400001f     	b	 <L18>
<L12>:
     3c0: d2800017     	mov	x23, #0x0               ; =0
<L13>:
     3c4: d10303ba     	sub	x26, x29, #0xc0
     3c8: cb1702b8     	sub	x24, x21, x23
     3cc: 8b284280     	add	x0, x20, w8, uxtw
     3d0: 8b1702c1     	add	x1, x22, x23
     3d4: aa1803e2     	mov	x2, x24
<L14>:
     3d8: 94000000     	bl	 <L14>
		00000000000003d8:  ARM64_RELOC_BRANCH26	_memcpy
     3dc: 394263e8     	ldrb	w8, [sp, #0x98]
     3e0: f9402be9     	ldr	x9, [sp, #0x50]
     3e4: 8b15013b     	add	x27, x9, x21
     3e8: f9002bfb     	str	x27, [sp, #0x50]
     3ec: 2b180108     	adds	w8, w8, w24
     3f0: 390263e8     	strb	w8, [sp, #0x98]
     3f4: 540008a0     	b.eq	 <L24>
     3f8: 7100fd1f     	cmp	w8, #0x3f
     3fc: 54000863     	b.lo	 <L24>
     400: 52800809     	mov	w9, #0x40               ; =64
     404: 4b080136     	sub	w22, w9, w8
     408: 8b284280     	add	x0, x20, w8, uxtw
     40c: 9100bfe1     	add	x1, sp, #0x2f
     410: aa1603e2     	mov	x2, x22
<L15>:
     414: 94000000     	bl	 <L15>
		0000000000000414:  ARM64_RELOC_BRANCH26	_memcpy
     418: 9100c3e0     	add	x0, sp, #0x30
     41c: aa1403e1     	mov	x1, x20
<L16>:
     420: 94000000     	bl	 <L16>
		0000000000000420:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     424: 52800008     	mov	w8, #0x0                ; =0
     428: 390263ff     	strb	wzr, [sp, #0x98]
     42c: f9402bfb     	ldr	x27, [sp, #0x50]
     430: 14000037     	b	 <L25>
<L17>:
     434: d2800015     	mov	x21, #0x0               ; =0
<L18>:
     438: 9100bfe9     	add	x9, sp, #0x2f
     43c: 5280002a     	mov	w10, #0x1               ; =1
     440: cb150156     	sub	x22, x10, x21
     444: 8b2842e0     	add	x0, x23, w8, uxtw
     448: 8b150121     	add	x1, x9, x21
     44c: aa1603e2     	mov	x2, x22
<L19>:
     450: 94000000     	bl	 <L19>
		0000000000000450:  ARM64_RELOC_BRANCH26	_memcpy
     454: 394523e8     	ldrb	w8, [sp, #0x148]
     458: 0b160108     	add	w8, w8, w22
     45c: 390523e8     	strb	w8, [sp, #0x148]
     460: 91000708     	add	x8, x24, #0x1
     464: f90083e8     	str	x8, [sp, #0x100]
     468: 910383f5     	add	x21, sp, #0xe0
     46c: d10383b8     	sub	x24, x29, #0xe0
     470: 910383e0     	add	x0, sp, #0xe0
     474: d10383a1     	sub	x1, x29, #0xe0
<L20>:
     478: 94000000     	bl	 <L20>
		0000000000000478:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     47c: 90000008     	adrp	x8, 0x0 <ltmp0>
		000000000000047c:  ARM64_RELOC_PAGE21	l___unnamed_2
     480: 91000108     	add	x8, x8, #0x0
		0000000000000480:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     484: ad420500     	ldp	q0, q1, [x8, #0x40]
     488: ad3c07a0     	stp	q0, q1, [x29, #-0x80]
     48c: 3dc01900     	ldr	q0, [x8, #0x60]
     490: 3c9a03a0     	stur	q0, [x29, #-0x60]
     494: ad400500     	ldp	q0, q1, [x8]
     498: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
     49c: ad410101     	ldp	q1, q0, [x8, #0x20]
     4a0: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
     4a4: d10303b6     	sub	x22, x29, #0xc0
     4a8: d10303a0     	sub	x0, x29, #0xc0
     4ac: 9101c2a1     	add	x1, x21, #0x70
<L21>:
     4b0: 94000000     	bl	 <L21>
		00000000000004b0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     4b4: 385a83a8     	ldurb	w8, [x29, #-0x58]
     4b8: f85603a9     	ldur	x9, [x29, #-0xa0]
     4bc: 9100a2d5     	add	x21, x22, #0x28
     4c0: 91010139     	add	x25, x9, #0x40
     4c4: f81603b9     	stur	x25, [x29, #-0xa0]
     4c8: 34000868     	cbz	w8,  <L31>
     4cc: 7100811f     	cmp	w8, #0x20
     4d0: 54000823     	b.lo	 <L31>
     4d4: 52800809     	mov	w9, #0x40               ; =64
     4d8: cb080136     	sub	x22, x9, x8
     4dc: 8b0802a0     	add	x0, x21, x8
     4e0: d10383a1     	sub	x1, x29, #0xe0
     4e4: aa1603e2     	mov	x2, x22
<L22>:
     4e8: 94000000     	bl	 <L22>
		00000000000004e8:  ARM64_RELOC_BRANCH26	_memcpy
     4ec: d10303a0     	sub	x0, x29, #0xc0
     4f0: aa1503e1     	mov	x1, x21
<L23>:
     4f4: 94000000     	bl	 <L23>
		00000000000004f4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     4f8: 52800008     	mov	w8, #0x0                ; =0
     4fc: 381a83bf     	sturb	wzr, [x29, #-0x58]
     500: f85603b9     	ldur	x25, [x29, #-0xa0]
     504: 14000035     	b	 <L32>
<L24>:
     508: d2800016     	mov	x22, #0x0               ; =0
<L25>:
     50c: 9100a355     	add	x21, x26, #0x28
     510: 9100bfe9     	add	x9, sp, #0x2f
     514: 5280002a     	mov	w10, #0x1               ; =1
     518: cb160157     	sub	x23, x10, x22
     51c: 8b284280     	add	x0, x20, w8, uxtw
     520: 8b160121     	add	x1, x9, x22
     524: aa1703e2     	mov	x2, x23
<L26>:
     528: 94000000     	bl	 <L26>
		0000000000000528:  ARM64_RELOC_BRANCH26	_memcpy
     52c: 394263e8     	ldrb	w8, [sp, #0x98]
     530: 0b170108     	add	w8, w8, w23
     534: 390263e8     	strb	w8, [sp, #0x98]
     538: 91000768     	add	x8, x27, #0x1
     53c: f9002be8     	str	x8, [sp, #0x50]
     540: d10383b7     	sub	x23, x29, #0xe0
     544: 9100c3e0     	add	x0, sp, #0x30
     548: d10383a1     	sub	x1, x29, #0xe0
<L27>:
     54c: 94000000     	bl	 <L27>
		000000000000054c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     550: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000550:  ARM64_RELOC_PAGE21	l___unnamed_2
     554: 91000108     	add	x8, x8, #0x0
		0000000000000554:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     558: ad420500     	ldp	q0, q1, [x8, #0x40]
     55c: ad3c07a0     	stp	q0, q1, [x29, #-0x80]
     560: 3dc01900     	ldr	q0, [x8, #0x60]
     564: 3c9a03a0     	stur	q0, [x29, #-0x60]
     568: ad400500     	ldp	q0, q1, [x8]
     56c: ad3a07a0     	stp	q0, q1, [x29, #-0xc0]
     570: ad410101     	ldp	q1, q0, [x8, #0x20]
     574: ad3b03a1     	stp	q1, q0, [x29, #-0xa0]
     578: d10303a0     	sub	x0, x29, #0xc0
     57c: 9101c321     	add	x1, x25, #0x70
<L28>:
     580: 94000000     	bl	 <L28>
		0000000000000580:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     584: 385a83a8     	ldurb	w8, [x29, #-0x58]
     588: f85603a9     	ldur	x9, [x29, #-0xa0]
     58c: 91010138     	add	x24, x9, #0x40
     590: f81603b8     	stur	x24, [x29, #-0xa0]
     594: 34000488     	cbz	w8,  <L36>
     598: 7100811f     	cmp	w8, #0x20
     59c: 54000443     	b.lo	 <L36>
     5a0: 52800809     	mov	w9, #0x40               ; =64
     5a4: cb080134     	sub	x20, x9, x8
     5a8: 8b0802a0     	add	x0, x21, x8
     5ac: d10383a1     	sub	x1, x29, #0xe0
     5b0: aa1403e2     	mov	x2, x20
<L29>:
     5b4: 94000000     	bl	 <L29>
		00000000000005b4:  ARM64_RELOC_BRANCH26	_memcpy
     5b8: d10303a0     	sub	x0, x29, #0xc0
     5bc: aa1503e1     	mov	x1, x21
<L30>:
     5c0: 94000000     	bl	 <L30>
		00000000000005c0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     5c4: 52800008     	mov	w8, #0x0                ; =0
     5c8: 381a83bf     	sturb	wzr, [x29, #-0x58]
     5cc: f85603b8     	ldur	x24, [x29, #-0xa0]
     5d0: 14000016     	b	 <L37>
<L31>:
     5d4: d2800016     	mov	x22, #0x0               ; =0
<L32>:
     5d8: 52800409     	mov	w9, #0x20               ; =32
     5dc: cb160137     	sub	x23, x9, x22
     5e0: 8b2842a0     	add	x0, x21, w8, uxtw
     5e4: 8b160301     	add	x1, x24, x22
     5e8: aa1703e2     	mov	x2, x23
<L33>:
     5ec: 94000000     	bl	 <L33>
		00000000000005ec:  ARM64_RELOC_BRANCH26	_memcpy
     5f0: 385a83a8     	ldurb	w8, [x29, #-0x58]
     5f4: 0b170108     	add	w8, w8, w23
     5f8: 381a83a8     	sturb	w8, [x29, #-0x58]
     5fc: 91008328     	add	x8, x25, #0x20
     600: f81603a8     	stur	x8, [x29, #-0xa0]
     604: d10303a0     	sub	x0, x29, #0xc0
     608: d10403a1     	sub	x1, x29, #0x100
<L34>:
     60c: 94000000     	bl	 <L34>
		000000000000060c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
     610: d10403a1     	sub	x1, x29, #0x100
     614: aa1303e0     	mov	x0, x19
     618: aa1403e2     	mov	x2, x20
<L35>:
     61c: 94000000     	bl	 <L35>
		000000000000061c:  ARM64_RELOC_BRANCH26	_memcpy
     620: 14000010     	b	 <L40>
<L36>:
     624: d2800014     	mov	x20, #0x0               ; =0
<L37>:
     628: 52800409     	mov	w9, #0x20               ; =32
     62c: cb140136     	sub	x22, x9, x20
     630: 8b2842a0     	add	x0, x21, w8, uxtw
     634: 8b1402e1     	add	x1, x23, x20
     638: aa1603e2     	mov	x2, x22
<L38>:
     63c: 94000000     	bl	 <L38>
		000000000000063c:  ARM64_RELOC_BRANCH26	_memcpy
     640: 385a83a8     	ldurb	w8, [x29, #-0x58]
     644: 0b160108     	add	w8, w8, w22
     648: 381a83a8     	sturb	w8, [x29, #-0x58]
     64c: 91008308     	add	x8, x24, #0x20
     650: f81603a8     	stur	x8, [x29, #-0xa0]
     654: d10303a0     	sub	x0, x29, #0xc0
     658: aa1303e1     	mov	x1, x19
<L39>:
     65c: 94000000     	bl	 <L39>
		000000000000065c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L40>:
     660: 910903ff     	add	sp, sp, #0x240
     664: a9457bfd     	ldp	x29, x30, [sp, #0x50]
     668: a9444ff4     	ldp	x20, x19, [sp, #0x40]
     66c: a94357f6     	ldp	x22, x21, [sp, #0x30]
     670: a9425ff8     	ldp	x24, x23, [sp, #0x20]
     674: a94167fa     	ldp	x26, x25, [sp, #0x10]
     678: a8c66ffc     	ldp	x28, x27, [sp], #0x60
     67c: d65f03c0     	ret

0000000000000680 <_crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).init>:
     680: d10443ff     	sub	sp, sp, #0x110
     684: a90f4ff4     	stp	x20, x19, [sp, #0xf0]
     688: a9107bfd     	stp	x29, x30, [sp, #0x100]
     68c: 910403fd     	add	x29, sp, #0x100
     690: aa0003f3     	mov	x19, x0
     694: 4f02e780     	movi.16b	v0, #0x5c
     698: ad400821     	ldp	q1, q2, [x1]
     69c: 6e201c23     	eor.16b	v3, v1, v0
     6a0: 6e201c44     	eor.16b	v4, v2, v0
     6a4: ad0403e4     	stp	q4, q0, [sp, #0x80]
     6a8: 3d802be0     	str	q0, [sp, #0xa0]
     6ac: 4f01e6c0     	movi.16b	v0, #0x36
     6b0: 6e201c21     	eor.16b	v1, v1, v0
     6b4: 6e201c42     	eor.16b	v2, v2, v0
     6b8: ad3d8ba1     	stp	q1, q2, [x29, #-0x50]
     6bc: ad3e83a0     	stp	q0, q0, [x29, #-0x30]
     6c0: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000006c0:  ARM64_RELOC_PAGE21	l___unnamed_2
     6c4: 91000108     	add	x8, x8, #0x0
		00000000000006c4:  ARM64_RELOC_PAGEOFF12	l___unnamed_2
     6c8: ad420500     	ldp	q0, q1, [x8, #0x40]
     6cc: ad0207e0     	stp	q0, q1, [sp, #0x40]
     6d0: 3dc01900     	ldr	q0, [x8, #0x60]
     6d4: ad030fe0     	stp	q0, q3, [sp, #0x60]
     6d8: ad400500     	ldp	q0, q1, [x8]
     6dc: ad0007e0     	stp	q0, q1, [sp]
     6e0: ad410101     	ldp	q1, q0, [x8, #0x20]
     6e4: ad0103e1     	stp	q1, q0, [sp, #0x20]
     6e8: 910003e0     	mov	x0, sp
     6ec: d10143a1     	sub	x1, x29, #0x50
<L0>:
     6f0: 94000000     	bl	 <L0>
		00000000000006f0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     6f4: f94013e8     	ldr	x8, [sp, #0x20]
     6f8: 91010108     	add	x8, x8, #0x40
     6fc: f90013e8     	str	x8, [sp, #0x20]
     700: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     704: ad040660     	stp	q0, q1, [x19, #0x80]
     708: 3dc02be0     	ldr	q0, [sp, #0xa0]
     70c: 3d802a60     	str	q0, [x19, #0xa0]
     710: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     714: ad020660     	stp	q0, q1, [x19, #0x40]
     718: ad4303e1     	ldp	q1, q0, [sp, #0x60]
     71c: ad030261     	stp	q1, q0, [x19, #0x60]
     720: ad4007e0     	ldp	q0, q1, [sp]
     724: ad000660     	stp	q0, q1, [x19]
     728: ad4103e1     	ldp	q1, q0, [sp, #0x20]
     72c: ad010261     	stp	q1, q0, [x19, #0x20]
     730: a9507bfd     	ldp	x29, x30, [sp, #0x100]
     734: a94f4ff4     	ldp	x20, x19, [sp, #0xf0]
     738: 910443ff     	add	sp, sp, #0x110
     73c: d65f03c0     	ret

0000000000000740 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     740: a9bd57f6     	stp	x22, x21, [sp, #-0x30]!
     744: a9014ff4     	stp	x20, x19, [sp, #0x10]
     748: a9027bfd     	stp	x29, x30, [sp, #0x20]
     74c: 910083fd     	add	x29, sp, #0x20
     750: aa0103f3     	mov	x19, x1
     754: aa0003f4     	mov	x20, x0
     758: 9100a015     	add	x21, x0, #0x28
     75c: 3941a008     	ldrb	w8, [x0, #0x68]
     760: 52800809     	mov	w9, #0x40               ; =64
     764: cb080121     	sub	x1, x9, x8
     768: 8b0802a0     	add	x0, x21, x8
<L0>:
     76c: 94000000     	bl	 <L0>
		000000000000076c:  ARM64_RELOC_BRANCH26	_bzero
     770: 3941a288     	ldrb	w8, [x20, #0x68]
     774: 52801009     	mov	w9, #0x80               ; =128
     778: 38286aa9     	strb	w9, [x21, x8]
     77c: 3941a288     	ldrb	w8, [x20, #0x68]
     780: 11000509     	add	w9, w8, #0x1
     784: 3901a289     	strb	w9, [x20, #0x68]
     788: 7100dd1f     	cmp	w8, #0x37
     78c: 54000109     	b.ls	 <L2>
     790: aa1403e0     	mov	x0, x20
     794: aa1503e1     	mov	x1, x21
<L1>:
     798: 94000000     	bl	 <L1>
		0000000000000798:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     79c: f9001abf     	str	xzr, [x21, #0x30]
     7a0: 6f00e400     	movi.2d	v0, #0000000000000000
     7a4: ad0082a0     	stp	q0, q0, [x21, #0x10]
     7a8: 3d8002a0     	str	q0, [x21]
<L2>:
     7ac: f9401288     	ldr	x8, [x20, #0x20]
     7b0: 531d7109     	lsl	w9, w8, #3
     7b4: 39019e89     	strb	w9, [x20, #0x67]
     7b8: d345fd09     	lsr	x9, x8, #5
     7bc: 39019a89     	strb	w9, [x20, #0x66]
     7c0: d34dfd09     	lsr	x9, x8, #13
     7c4: 39019689     	strb	w9, [x20, #0x65]
     7c8: d355fd09     	lsr	x9, x8, #21
     7cc: 39019289     	strb	w9, [x20, #0x64]
     7d0: d35dfd09     	lsr	x9, x8, #29
     7d4: 39018e89     	strb	w9, [x20, #0x63]
     7d8: d365fd09     	lsr	x9, x8, #37
     7dc: 39018a89     	strb	w9, [x20, #0x62]
     7e0: d36dfd09     	lsr	x9, x8, #45
     7e4: 39018689     	strb	w9, [x20, #0x61]
     7e8: d375fd08     	lsr	x8, x8, #53
     7ec: 39018288     	strb	w8, [x20, #0x60]
     7f0: aa1403e0     	mov	x0, x20
     7f4: aa1503e1     	mov	x1, x21
<L3>:
     7f8: 94000000     	bl	 <L3>
		00000000000007f8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
     7fc: b9400288     	ldr	w8, [x20]
     800: 5ac00908     	rev	w8, w8
     804: b9000268     	str	w8, [x19]
     808: b9400688     	ldr	w8, [x20, #0x4]
     80c: 5ac00908     	rev	w8, w8
     810: b9000668     	str	w8, [x19, #0x4]
     814: b9400a88     	ldr	w8, [x20, #0x8]
     818: 5ac00908     	rev	w8, w8
     81c: b9000a68     	str	w8, [x19, #0x8]
     820: b9400e88     	ldr	w8, [x20, #0xc]
     824: 5ac00908     	rev	w8, w8
     828: b9000e68     	str	w8, [x19, #0xc]
     82c: b9401288     	ldr	w8, [x20, #0x10]
     830: 5ac00908     	rev	w8, w8
     834: b9001268     	str	w8, [x19, #0x10]
     838: b9401688     	ldr	w8, [x20, #0x14]
     83c: 5ac00908     	rev	w8, w8
     840: b9001668     	str	w8, [x19, #0x14]
     844: b9401a88     	ldr	w8, [x20, #0x18]
     848: 5ac00908     	rev	w8, w8
     84c: b9001a68     	str	w8, [x19, #0x18]
     850: b9401e88     	ldr	w8, [x20, #0x1c]
     854: 5ac00908     	rev	w8, w8
     858: b9001e68     	str	w8, [x19, #0x1c]
     85c: a9427bfd     	ldp	x29, x30, [sp, #0x20]
     860: a9414ff4     	ldp	x20, x19, [sp, #0x10]
     864: a8c357f6     	ldp	x22, x21, [sp], #0x30
     868: d65f03c0     	ret

000000000000086c <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     86c: a9bf7bfd     	stp	x29, x30, [sp, #-0x10]!
     870: 910003fd     	mov	x29, sp
     874: ad400420     	ldp	q0, q1, [x1]
     878: 6e200803     	rev32.16b	v3, v0
     87c: 6e200824     	rev32.16b	v4, v1
     880: ad410420     	ldp	q0, q1, [x1, #0x20]
     884: 6e200806     	rev32.16b	v6, v0
     888: 6e200825     	rev32.16b	v5, v1
     88c: 90000008     	adrp	x8, 0x0 <ltmp0>
		000000000000088c:  ARM64_RELOC_PAGE21	lCPI5_0
     890: 3dc00100     	ldr	q0, [x8]
		0000000000000890:  ARM64_RELOC_PAGEOFF12	lCPI5_0
     894: 4ea08467     	add.4s	v7, v3, v0
     898: ad400402     	ldp	q2, q1, [x0]
     89c: 4ea21c40     	mov.16b	v0, v2
     8a0: 5e074022     	sha256h.4s	q2, q1, v7
     8a4: 5e075001     	sha256h2.4s	q1, q0, v7
     8a8: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008a8:  ARM64_RELOC_PAGE21	lCPI5_1
     8ac: 3dc00100     	ldr	q0, [x8]
		00000000000008ac:  ARM64_RELOC_PAGEOFF12	lCPI5_1
     8b0: 4ea08487     	add.4s	v7, v4, v0
     8b4: 4ea21c40     	mov.16b	v0, v2
     8b8: 5e074022     	sha256h.4s	q2, q1, v7
     8bc: 5e075001     	sha256h2.4s	q1, q0, v7
     8c0: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008c0:  ARM64_RELOC_PAGE21	lCPI5_2
     8c4: 3dc00100     	ldr	q0, [x8]
		00000000000008c4:  ARM64_RELOC_PAGEOFF12	lCPI5_2
     8c8: 4ea084c7     	add.4s	v7, v6, v0
     8cc: 4ea21c40     	mov.16b	v0, v2
     8d0: 5e074022     	sha256h.4s	q2, q1, v7
     8d4: 5e075001     	sha256h2.4s	q1, q0, v7
     8d8: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008d8:  ARM64_RELOC_PAGE21	lCPI5_3
     8dc: 3dc00100     	ldr	q0, [x8]
		00000000000008dc:  ARM64_RELOC_PAGEOFF12	lCPI5_3
     8e0: 4ea084a7     	add.4s	v7, v5, v0
     8e4: 4ea21c40     	mov.16b	v0, v2
     8e8: 5e074022     	sha256h.4s	q2, q1, v7
     8ec: 5e075001     	sha256h2.4s	q1, q0, v7
     8f0: 5e282883     	sha256su0.4s	v3, v4
     8f4: 5e0560c3     	sha256su1.4s	v3, v6, v5
     8f8: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000008f8:  ARM64_RELOC_PAGE21	lCPI5_4
     8fc: 3dc00100     	ldr	q0, [x8]
		00000000000008fc:  ARM64_RELOC_PAGEOFF12	lCPI5_4
     900: 4ea08467     	add.4s	v7, v3, v0
     904: 4ea21c40     	mov.16b	v0, v2
     908: 5e074022     	sha256h.4s	q2, q1, v7
     90c: 5e075001     	sha256h2.4s	q1, q0, v7
     910: 5e2828c4     	sha256su0.4s	v4, v6
     914: 5e0360a4     	sha256su1.4s	v4, v5, v3
     918: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000918:  ARM64_RELOC_PAGE21	lCPI5_5
     91c: 3dc00100     	ldr	q0, [x8]
		000000000000091c:  ARM64_RELOC_PAGEOFF12	lCPI5_5
     920: 4ea08487     	add.4s	v7, v4, v0
     924: 4ea21c40     	mov.16b	v0, v2
     928: 5e074022     	sha256h.4s	q2, q1, v7
     92c: 5e075001     	sha256h2.4s	q1, q0, v7
     930: 5e2828a6     	sha256su0.4s	v6, v5
     934: 5e046066     	sha256su1.4s	v6, v3, v4
     938: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000938:  ARM64_RELOC_PAGE21	lCPI5_6
     93c: 3dc00100     	ldr	q0, [x8]
		000000000000093c:  ARM64_RELOC_PAGEOFF12	lCPI5_6
     940: 4ea084c7     	add.4s	v7, v6, v0
     944: 4ea21c40     	mov.16b	v0, v2
     948: 5e074022     	sha256h.4s	q2, q1, v7
     94c: 5e075001     	sha256h2.4s	q1, q0, v7
     950: 5e282865     	sha256su0.4s	v5, v3
     954: 5e066085     	sha256su1.4s	v5, v4, v6
     958: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000958:  ARM64_RELOC_PAGE21	lCPI5_7
     95c: 3dc00100     	ldr	q0, [x8]
		000000000000095c:  ARM64_RELOC_PAGEOFF12	lCPI5_7
     960: 4ea084a7     	add.4s	v7, v5, v0
     964: 4ea21c40     	mov.16b	v0, v2
     968: 5e074022     	sha256h.4s	q2, q1, v7
     96c: 5e075001     	sha256h2.4s	q1, q0, v7
     970: 5e282883     	sha256su0.4s	v3, v4
     974: 5e0560c3     	sha256su1.4s	v3, v6, v5
     978: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000978:  ARM64_RELOC_PAGE21	lCPI5_8
     97c: 3dc00100     	ldr	q0, [x8]
		000000000000097c:  ARM64_RELOC_PAGEOFF12	lCPI5_8
     980: 4ea08467     	add.4s	v7, v3, v0
     984: 4ea21c40     	mov.16b	v0, v2
     988: 5e074022     	sha256h.4s	q2, q1, v7
     98c: 5e075001     	sha256h2.4s	q1, q0, v7
     990: 5e2828c4     	sha256su0.4s	v4, v6
     994: 5e0360a4     	sha256su1.4s	v4, v5, v3
     998: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000998:  ARM64_RELOC_PAGE21	lCPI5_9
     99c: 3dc00100     	ldr	q0, [x8]
		000000000000099c:  ARM64_RELOC_PAGEOFF12	lCPI5_9
     9a0: 4ea08487     	add.4s	v7, v4, v0
     9a4: 4ea21c40     	mov.16b	v0, v2
     9a8: 5e074022     	sha256h.4s	q2, q1, v7
     9ac: 5e075001     	sha256h2.4s	q1, q0, v7
     9b0: 5e2828a6     	sha256su0.4s	v6, v5
     9b4: 5e046066     	sha256su1.4s	v6, v3, v4
     9b8: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000009b8:  ARM64_RELOC_PAGE21	lCPI5_10
     9bc: 3dc00100     	ldr	q0, [x8]
		00000000000009bc:  ARM64_RELOC_PAGEOFF12	lCPI5_10
     9c0: 4ea084c7     	add.4s	v7, v6, v0
     9c4: 4ea21c40     	mov.16b	v0, v2
     9c8: 5e074022     	sha256h.4s	q2, q1, v7
     9cc: 5e075001     	sha256h2.4s	q1, q0, v7
     9d0: 5e282865     	sha256su0.4s	v5, v3
     9d4: 5e066085     	sha256su1.4s	v5, v4, v6
     9d8: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000009d8:  ARM64_RELOC_PAGE21	lCPI5_11
     9dc: 3dc00100     	ldr	q0, [x8]
		00000000000009dc:  ARM64_RELOC_PAGEOFF12	lCPI5_11
     9e0: 4ea084a7     	add.4s	v7, v5, v0
     9e4: 4ea21c40     	mov.16b	v0, v2
     9e8: 5e074022     	sha256h.4s	q2, q1, v7
     9ec: 5e075001     	sha256h2.4s	q1, q0, v7
     9f0: 5e282883     	sha256su0.4s	v3, v4
     9f4: 5e0560c3     	sha256su1.4s	v3, v6, v5
     9f8: 90000008     	adrp	x8, 0x0 <ltmp0>
		00000000000009f8:  ARM64_RELOC_PAGE21	lCPI5_12
     9fc: 3dc00100     	ldr	q0, [x8]
		00000000000009fc:  ARM64_RELOC_PAGEOFF12	lCPI5_12
     a00: 4ea08467     	add.4s	v7, v3, v0
     a04: 4ea21c40     	mov.16b	v0, v2
     a08: 5e074022     	sha256h.4s	q2, q1, v7
     a0c: 5e075001     	sha256h2.4s	q1, q0, v7
     a10: 5e2828c4     	sha256su0.4s	v4, v6
     a14: 5e0360a4     	sha256su1.4s	v4, v5, v3
     a18: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a18:  ARM64_RELOC_PAGE21	lCPI5_13
     a1c: 3dc00100     	ldr	q0, [x8]
		0000000000000a1c:  ARM64_RELOC_PAGEOFF12	lCPI5_13
     a20: 4ea08487     	add.4s	v7, v4, v0
     a24: 4ea21c40     	mov.16b	v0, v2
     a28: 5e074022     	sha256h.4s	q2, q1, v7
     a2c: 5e075001     	sha256h2.4s	q1, q0, v7
     a30: 5e2828a6     	sha256su0.4s	v6, v5
     a34: 5e046066     	sha256su1.4s	v6, v3, v4
     a38: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a38:  ARM64_RELOC_PAGE21	lCPI5_14
     a3c: 3dc00100     	ldr	q0, [x8]
		0000000000000a3c:  ARM64_RELOC_PAGEOFF12	lCPI5_14
     a40: 4ea084c7     	add.4s	v7, v6, v0
     a44: 4ea21c40     	mov.16b	v0, v2
     a48: 5e074022     	sha256h.4s	q2, q1, v7
     a4c: 5e075001     	sha256h2.4s	q1, q0, v7
     a50: 5e282865     	sha256su0.4s	v5, v3
     a54: 5e066085     	sha256su1.4s	v5, v4, v6
     a58: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000a58:  ARM64_RELOC_PAGE21	lCPI5_15
     a5c: 3dc00100     	ldr	q0, [x8]
		0000000000000a5c:  ARM64_RELOC_PAGEOFF12	lCPI5_15
     a60: 4ea084a3     	add.4s	v3, v5, v0
     a64: 4ea21c40     	mov.16b	v0, v2
     a68: 5e034022     	sha256h.4s	q2, q1, v3
     a6c: 5e035001     	sha256h2.4s	q1, q0, v3
     a70: ad400c00     	ldp	q0, q3, [x0]
     a74: 4ea08440     	add.4s	v0, v2, v0
     a78: 4ea18461     	add.4s	v1, v3, v1
     a7c: ad000400     	stp	q0, q1, [x0]
     a80: a8c17bfd     	ldp	x29, x30, [sp], #0x10
     a84: d65f03c0     	ret

0000000000000a88 <_audit_master256>:
     a88: d105c3ff     	sub	sp, sp, #0x170
     a8c: a9154ff4     	stp	x20, x19, [sp, #0x150]
     a90: a9167bfd     	stp	x29, x30, [sp, #0x160]
     a94: 910583fd     	add	x29, sp, #0x160
     a98: aa0103f3     	mov	x19, x1
     a9c: aa0003e4     	mov	x4, x0
     aa0: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000aa0:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
     aa4: 91000108     	add	x8, x8, #0x0
		0000000000000aa4:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash
     aa8: ad400500     	ldp	q0, q1, [x8]
     aac: 3c8513e0     	stur	q0, [sp, #0x51]
     ab0: 52840008     	mov	w8, #0x2000             ; =8192
     ab4: 790083e8     	strh	w8, [sp, #0x40]
     ab8: 528001a8     	mov	w8, #0xd                ; =13
     abc: 39010be8     	strb	w8, [sp, #0x42]
     ac0: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000ac0:  ARM64_RELOC_PAGE21	l___unnamed_1
     ac4: 91000108     	add	x8, x8, #0x0
		0000000000000ac4:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
     ac8: f9400109     	ldr	x9, [x8]
     acc: f80433e9     	stur	x9, [sp, #0x43]
     ad0: f8405108     	ldur	x8, [x8, #0x5]
     ad4: f90027e8     	str	x8, [sp, #0x48]
     ad8: 52800408     	mov	w8, #0x20               ; =32
     adc: 390143e8     	strb	w8, [sp, #0x50]
     ae0: 3c8613e1     	stur	q1, [sp, #0x61]
     ae4: 910083e0     	add	x0, sp, #0x20
     ae8: 910103e2     	add	x2, sp, #0x40
     aec: 52800401     	mov	w1, #0x20               ; =32
     af0: 52800623     	mov	w3, #0x31               ; =49
<L0>:
     af4: 94000000     	bl	 <L0>
		0000000000000af4:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
     af8: 90000002     	adrp	x2, 0x0 <ltmp0>
		0000000000000af8:  ARM64_RELOC_PAGE21	_memx.Array(32).zero
     afc: 91000042     	add	x2, x2, #0x0
		0000000000000afc:  ARM64_RELOC_PAGEOFF12	_memx.Array(32).zero
     b00: 910003e0     	mov	x0, sp
     b04: 910083e1     	add	x1, sp, #0x20
<L1>:
     b08: 94000000     	bl	 <L1>
		0000000000000b08:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
     b0c: ad4007e0     	ldp	q0, q1, [sp]
     b10: ad000660     	stp	q0, q1, [x19]
     b14: a9567bfd     	ldp	x29, x30, [sp, #0x160]
     b18: a9554ff4     	ldp	x20, x19, [sp, #0x150]
     b1c: 9105c3ff     	add	sp, sp, #0x170
     b20: d65f03c0     	ret

0000000000000b24 <_audit_key256>:
     b24: d104c3ff     	sub	sp, sp, #0x130
     b28: a9116ffc     	stp	x28, x27, [sp, #0x110]
     b2c: a9127bfd     	stp	x29, x30, [sp, #0x120]
     b30: 910483fd     	add	x29, sp, #0x120
     b34: aa0003e4     	mov	x4, x0
     b38: 52820008     	mov	w8, #0x1000             ; =4096
     b3c: 79000be8     	strh	w8, [sp, #0x4]
     b40: 52800128     	mov	w8, #0x9                ; =9
     b44: 39001be8     	strb	w8, [sp, #0x6]
     b48: 52800f28     	mov	w8, #0x79               ; =121
     b4c: 7800f3e8     	sturh	w8, [sp, #0xf]
     b50: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000b50:  ARM64_RELOC_PAGE21	l___unnamed_3
     b54: 91000108     	add	x8, x8, #0x0
		0000000000000b54:  ARM64_RELOC_PAGEOFF12	l___unnamed_3
     b58: f9400108     	ldr	x8, [x8]
     b5c: f80073e8     	stur	x8, [sp, #0x7]
     b60: 910013e2     	add	x2, sp, #0x4
     b64: aa0103e0     	mov	x0, x1
     b68: 52800201     	mov	w1, #0x10               ; =16
     b6c: 528001a3     	mov	w3, #0xd                ; =13
<L0>:
     b70: 94000000     	bl	 <L0>
		0000000000000b70:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
     b74: a9527bfd     	ldp	x29, x30, [sp, #0x120]
     b78: a9516ffc     	ldp	x28, x27, [sp, #0x110]
     b7c: 9104c3ff     	add	sp, sp, #0x130
     b80: d65f03c0     	ret

0000000000000b84 <_audit_handshake384>:
     b84: d10683ff     	sub	sp, sp, #0x1a0
     b88: a9176ffc     	stp	x28, x27, [sp, #0x170]
     b8c: a9184ff4     	stp	x20, x19, [sp, #0x180]
     b90: a9197bfd     	stp	x29, x30, [sp, #0x190]
     b94: 910643fd     	add	x29, sp, #0x190
     b98: aa0203f3     	mov	x19, x2
     b9c: aa0103f4     	mov	x20, x1
     ba0: aa0003e4     	mov	x4, x0
     ba4: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000ba4:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
     ba8: 91000108     	add	x8, x8, #0x0
		0000000000000ba8:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
     bac: ad400500     	ldp	q0, q1, [x8]
     bb0: 3c8713e0     	stur	q0, [sp, #0x71]
     bb4: 52860009     	mov	w9, #0x3000             ; =12288
     bb8: 7900c3e9     	strh	w9, [sp, #0x60]
     bbc: 528001a9     	mov	w9, #0xd                ; =13
     bc0: 39018be9     	strb	w9, [sp, #0x62]
     bc4: 90000009     	adrp	x9, 0x0 <ltmp0>
		0000000000000bc4:  ARM64_RELOC_PAGE21	l___unnamed_1
     bc8: 91000129     	add	x9, x9, #0x0
		0000000000000bc8:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
     bcc: f940012a     	ldr	x10, [x9]
     bd0: f80633ea     	stur	x10, [sp, #0x63]
     bd4: 910183ea     	add	x10, sp, #0x60
     bd8: f8405129     	ldur	x9, [x9, #0x5]
     bdc: f90037e9     	str	x9, [sp, #0x68]
     be0: 52800609     	mov	w9, #0x30               ; =48
     be4: 3901c3e9     	strb	w9, [sp, #0x70]
     be8: 3c821141     	stur	q1, [x10, #0x21]
     bec: 3dc00900     	ldr	q0, [x8, #0x20]
     bf0: 3c831140     	stur	q0, [x10, #0x31]
     bf4: 9100c3e0     	add	x0, sp, #0x30
     bf8: 910183e2     	add	x2, sp, #0x60
     bfc: 52800601     	mov	w1, #0x30               ; =48
     c00: 52800823     	mov	w3, #0x41               ; =65
<L0>:
     c04: 94000000     	bl	 <L0>
		0000000000000c04:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
     c08: 910003e0     	mov	x0, sp
     c0c: 9100c3e1     	add	x1, sp, #0x30
     c10: aa1403e2     	mov	x2, x20
<L1>:
     c14: 94000000     	bl	 <L1>
		0000000000000c14:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
     c18: ad4007e0     	ldp	q0, q1, [sp]
     c1c: ad000660     	stp	q0, q1, [x19]
     c20: 3dc00be0     	ldr	q0, [sp, #0x20]
     c24: 3d800a60     	str	q0, [x19, #0x20]
     c28: a9597bfd     	ldp	x29, x30, [sp, #0x190]
     c2c: a9584ff4     	ldp	x20, x19, [sp, #0x180]
     c30: a9576ffc     	ldp	x28, x27, [sp, #0x170]
     c34: 910683ff     	add	sp, sp, #0x1a0
     c38: d65f03c0     	ret

0000000000000c3c <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
     c3c: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
     c40: a90167fa     	stp	x26, x25, [sp, #0x10]
     c44: a9025ff8     	stp	x24, x23, [sp, #0x20]
     c48: a90357f6     	stp	x22, x21, [sp, #0x30]
     c4c: a9044ff4     	stp	x20, x19, [sp, #0x40]
     c50: a9057bfd     	stp	x29, x30, [sp, #0x50]
     c54: 910143fd     	add	x29, sp, #0x50
     c58: d10e03ff     	sub	sp, sp, #0x380
     c5c: aa0203f4     	mov	x20, x2
     c60: aa0003f3     	mov	x19, x0
     c64: ad400420     	ldp	q0, q1, [x1]
     c68: 3dc00822     	ldr	q2, [x1, #0x20]
     c6c: 910443f7     	add	x23, sp, #0x110
     c70: 4f02e783     	movi.16b	v3, #0x5c
     c74: 6e231c04     	eor.16b	v4, v0, v3
     c78: 6e231c25     	eor.16b	v5, v1, v3
     c7c: 6e231c46     	eor.16b	v6, v2, v3
     c80: ad0f97e4     	stp	q4, q5, [sp, #0x1f0]
     c84: ad108fe6     	stp	q6, q3, [sp, #0x210]
     c88: ad118fe3     	stp	q3, q3, [sp, #0x230]
     c8c: ad128fe3     	stp	q3, q3, [sp, #0x250]
     c90: 4f01e6c3     	movi.16b	v3, #0x36
     c94: 6e231c00     	eor.16b	v0, v0, v3
     c98: 6e231c21     	eor.16b	v1, v1, v3
     c9c: 6e231c42     	eor.16b	v2, v2, v3
     ca0: ad1507e0     	stp	q0, q1, [sp, #0x2a0]
     ca4: ad160fe2     	stp	q2, q3, [sp, #0x2c0]
     ca8: ad170fe3     	stp	q3, q3, [sp, #0x2e0]
     cac: ad180fe3     	stp	q3, q3, [sp, #0x300]
     cb0: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000cb0:  ARM64_RELOC_PAGE21	l___unnamed_4
     cb4: 91000108     	add	x8, x8, #0x0
		0000000000000cb4:  ARM64_RELOC_PAGEOFF12	l___unnamed_4
     cb8: ad450500     	ldp	q0, q1, [x8, #0xa0]
     cbc: ad0603e1     	stp	q1, q0, [sp, #0xc0]
     cc0: ad0d87e0     	stp	q0, q1, [sp, #0x1b0]
     cc4: ad460500     	ldp	q0, q1, [x8, #0xc0]
     cc8: ad0503e1     	stp	q1, q0, [sp, #0xa0]
     ccc: ad0e87e0     	stp	q0, q1, [sp, #0x1d0]
     cd0: ad430500     	ldp	q0, q1, [x8, #0x60]
     cd4: ad0403e1     	stp	q1, q0, [sp, #0x80]
     cd8: ad0b87e0     	stp	q0, q1, [sp, #0x170]
     cdc: ad440500     	ldp	q0, q1, [x8, #0x80]
     ce0: ad0303e1     	stp	q1, q0, [sp, #0x60]
     ce4: ad0c87e0     	stp	q0, q1, [sp, #0x190]
     ce8: ad410500     	ldp	q0, q1, [x8, #0x20]
     cec: ad0203e1     	stp	q1, q0, [sp, #0x40]
     cf0: ad0987e0     	stp	q0, q1, [sp, #0x130]
     cf4: ad420500     	ldp	q0, q1, [x8, #0x40]
     cf8: 3d800fe0     	str	q0, [sp, #0x30]
     cfc: ad0a87e0     	stp	q0, q1, [sp, #0x150]
     d00: 3d8007e1     	str	q1, [sp, #0x10]
     d04: ad400500     	ldp	q0, q1, [x8]
     d08: 3d800be0     	str	q0, [sp, #0x20]
     d0c: ad0887e0     	stp	q0, q1, [sp, #0x110]
     d10: 3d8003e1     	str	q1, [sp]
     d14: 910a83f8     	add	x24, sp, #0x2a0
     d18: 910443e0     	add	x0, sp, #0x110
     d1c: 910a83e1     	add	x1, sp, #0x2a0
<L0>:
     d20: 94000000     	bl	 <L0>
		0000000000000d20:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     d24: a95123e9     	ldp	x9, x8, [sp, #0x110]
     d28: b102013a     	adds	x26, x9, #0x80
     d2c: 9a883519     	cinc	x25, x8, hs
     d30: a91167fa     	stp	x26, x25, [sp, #0x110]
     d34: 394783e8     	ldrb	w8, [sp, #0x1e0]
     d38: 34000248     	cbz	w8,  <L3>
     d3c: 7101411f     	cmp	w8, #0x50
     d40: 54000203     	b.lo	 <L3>
     d44: 52801009     	mov	w9, #0x80               ; =128
     d48: cb080135     	sub	x21, x9, x8
     d4c: 910443e9     	add	x9, sp, #0x110
     d50: 91014136     	add	x22, x9, #0x50
     d54: 8b0802c0     	add	x0, x22, x8
     d58: aa1403e1     	mov	x1, x20
     d5c: aa1503e2     	mov	x2, x21
<L1>:
     d60: 94000000     	bl	 <L1>
		0000000000000d60:  ARM64_RELOC_BRANCH26	_memcpy
     d64: 910443e0     	add	x0, sp, #0x110
     d68: aa1603e1     	mov	x1, x22
<L2>:
     d6c: 94000000     	bl	 <L2>
		0000000000000d6c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     d70: 52800008     	mov	w8, #0x0                ; =0
     d74: 390783ff     	strb	wzr, [sp, #0x1e0]
     d78: a95167fa     	ldp	x26, x25, [sp, #0x110]
     d7c: 14000002     	b	 <L4>
<L3>:
     d80: d2800015     	mov	x21, #0x0               ; =0
<L4>:
     d84: 52800609     	mov	w9, #0x30               ; =48
     d88: cb150136     	sub	x22, x9, x21
     d8c: 8b2842e8     	add	x8, x23, w8, uxtw
     d90: 91014100     	add	x0, x8, #0x50
     d94: 8b150281     	add	x1, x20, x21
     d98: aa1603e2     	mov	x2, x22
<L5>:
     d9c: 94000000     	bl	 <L5>
		0000000000000d9c:  ARM64_RELOC_BRANCH26	_memcpy
     da0: 394783e8     	ldrb	w8, [sp, #0x1e0]
     da4: 0b160108     	add	w8, w8, w22
     da8: 390783e8     	strb	w8, [sp, #0x1e0]
     dac: b100c348     	adds	x8, x26, #0x30
     db0: 9a993729     	cinc	x9, x25, hs
     db4: a91127e8     	stp	x8, x9, [sp, #0x110]
     db8: 9109c3f9     	add	x25, sp, #0x270
     dbc: 910443e0     	add	x0, sp, #0x110
     dc0: 9109c3e1     	add	x1, sp, #0x270
<L6>:
     dc4: 94000000     	bl	 <L6>
		0000000000000dc4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     dc8: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
     dcc: ad1a03e1     	stp	q1, q0, [sp, #0x340]
     dd0: ad4507e0     	ldp	q0, q1, [sp, #0xa0]
     dd4: ad1b03e1     	stp	q1, q0, [sp, #0x360]
     dd8: ad4407e0     	ldp	q0, q1, [sp, #0x80]
     ddc: ad1803e1     	stp	q1, q0, [sp, #0x300]
     de0: ad4307e0     	ldp	q0, q1, [sp, #0x60]
     de4: ad1903e1     	stp	q1, q0, [sp, #0x320]
     de8: ad4207e0     	ldp	q0, q1, [sp, #0x40]
     dec: ad1603e1     	stp	q1, q0, [sp, #0x2c0]
     df0: 3dc00fe1     	ldr	q1, [sp, #0x30]
     df4: ad408fe2     	ldp	q2, q3, [sp, #0x10]
     df8: ad170be1     	stp	q1, q2, [sp, #0x2e0]
     dfc: 91014314     	add	x20, x24, #0x50
     e00: 3dc003e0     	ldr	q0, [sp]
     e04: ad1503e3     	stp	q3, q0, [sp, #0x2a0]
     e08: 910a83e0     	add	x0, sp, #0x2a0
     e0c: 910382e1     	add	x1, x23, #0xe0
<L7>:
     e10: 94000000     	bl	 <L7>
		0000000000000e10:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     e14: 394dc3e8     	ldrb	w8, [sp, #0x370]
     e18: f94157e9     	ldr	x9, [sp, #0x2a8]
     e1c: f94153ea     	ldr	x10, [sp, #0x2a0]
     e20: b1020158     	adds	x24, x10, #0x80
     e24: 9a893537     	cinc	x23, x9, hs
     e28: f90153f8     	str	x24, [sp, #0x2a0]
     e2c: f90157f7     	str	x23, [sp, #0x2a8]
     e30: 34000228     	cbz	w8,  <L10>
     e34: 7101411f     	cmp	w8, #0x50
     e38: 540001e3     	b.lo	 <L10>
     e3c: 52801009     	mov	w9, #0x80               ; =128
     e40: cb080135     	sub	x21, x9, x8
     e44: 8b080280     	add	x0, x20, x8
     e48: 9109c3e1     	add	x1, sp, #0x270
     e4c: aa1503e2     	mov	x2, x21
<L8>:
     e50: 94000000     	bl	 <L8>
		0000000000000e50:  ARM64_RELOC_BRANCH26	_memcpy
     e54: 910a83e0     	add	x0, sp, #0x2a0
     e58: aa1403e1     	mov	x1, x20
<L9>:
     e5c: 94000000     	bl	 <L9>
		0000000000000e5c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
     e60: 52800008     	mov	w8, #0x0                ; =0
     e64: 390dc3ff     	strb	wzr, [sp, #0x370]
     e68: f94157f7     	ldr	x23, [sp, #0x2a8]
     e6c: f94153f8     	ldr	x24, [sp, #0x2a0]
     e70: 14000002     	b	 <L11>
<L10>:
     e74: d2800015     	mov	x21, #0x0               ; =0
<L11>:
     e78: 52800609     	mov	w9, #0x30               ; =48
     e7c: cb150136     	sub	x22, x9, x21
     e80: 8b284280     	add	x0, x20, w8, uxtw
     e84: 8b150321     	add	x1, x25, x21
     e88: aa1603e2     	mov	x2, x22
<L12>:
     e8c: 94000000     	bl	 <L12>
		0000000000000e8c:  ARM64_RELOC_BRANCH26	_memcpy
     e90: 394dc3e8     	ldrb	w8, [sp, #0x370]
     e94: 0b160108     	add	w8, w8, w22
     e98: 390dc3e8     	strb	w8, [sp, #0x370]
     e9c: b100c308     	adds	x8, x24, #0x30
     ea0: 9a9736e9     	cinc	x9, x23, hs
     ea4: f90157e9     	str	x9, [sp, #0x2a8]
     ea8: f90153e8     	str	x8, [sp, #0x2a0]
     eac: 910a83e0     	add	x0, sp, #0x2a0
     eb0: 910383e1     	add	x1, sp, #0xe0
<L13>:
     eb4: 94000000     	bl	 <L13>
		0000000000000eb4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
     eb8: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
     ebc: ad000660     	stp	q0, q1, [x19]
     ec0: 3dc043e0     	ldr	q0, [sp, #0x100]
     ec4: 3d800a60     	str	q0, [x19, #0x20]
     ec8: 910e03ff     	add	sp, sp, #0x380
     ecc: a9457bfd     	ldp	x29, x30, [sp, #0x50]
     ed0: a9444ff4     	ldp	x20, x19, [sp, #0x40]
     ed4: a94357f6     	ldp	x22, x21, [sp, #0x30]
     ed8: a9425ff8     	ldp	x24, x23, [sp, #0x20]
     edc: a94167fa     	ldp	x26, x25, [sp, #0x10]
     ee0: a8c66ffc     	ldp	x28, x27, [sp], #0x60
     ee4: d65f03c0     	ret

0000000000000ee8 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
     ee8: a9ba6ffc     	stp	x28, x27, [sp, #-0x60]!
     eec: a90167fa     	stp	x26, x25, [sp, #0x10]
     ef0: a9025ff8     	stp	x24, x23, [sp, #0x20]
     ef4: a90357f6     	stp	x22, x21, [sp, #0x30]
     ef8: a9044ff4     	stp	x20, x19, [sp, #0x40]
     efc: a9057bfd     	stp	x29, x30, [sp, #0x50]
     f00: 910143fd     	add	x29, sp, #0x50
     f04: d11a43ff     	sub	sp, sp, #0x690
     f08: aa0303f4     	mov	x20, x3
     f0c: a90b03e2     	stp	x2, x0, [sp, #0xb0]
     f10: aa0103f5     	mov	x21, x1
     f14: 910d03fb     	add	x27, sp, #0x340
     f18: ad400480     	ldp	q0, q1, [x4]
     f1c: 3dc00882     	ldr	q2, [x4, #0x20]
     f20: 52800028     	mov	w8, #0x1                ; =1
     f24: 3906bfe8     	strb	w8, [sp, #0x1af]
     f28: 90000009     	adrp	x9, 0x0 <ltmp0>
		0000000000000f28:  ARM64_RELOC_PAGE21	l___unnamed_4
     f2c: 91000129     	add	x9, x9, #0x0
		0000000000000f2c:  ARM64_RELOC_PAGEOFF12	l___unnamed_4
     f30: f100c03f     	cmp	x1, #0x30
     f34: ad0083e1     	stp	q1, q0, [sp, #0x10]
     f38: 3d8003e2     	str	q2, [sp]
     f3c: 54000922     	b.hs	 <L4>
     f40: f9001bff     	str	xzr, [sp, #0x30]
<L0>:
     f44: f100c2a8     	subs	x8, x21, #0x30
     f48: 9a8832b7     	csel	x23, x21, x8, lo
     f4c: b40038b7     	cbz	x23,  <L55>
     f50: 4f02e780     	movi.16b	v0, #0x5c
     f54: ad408fe4     	ldp	q4, q3, [sp, #0x10]
     f58: 6e201c61     	eor.16b	v1, v3, v0
     f5c: 6e201c82     	eor.16b	v2, v4, v0
     f60: ad160b61     	stp	q1, q2, [x27, #0x2c0]
     f64: 3dc003e5     	ldr	q5, [sp]
     f68: 6e201ca1     	eor.16b	v1, v5, v0
     f6c: ad170361     	stp	q1, q0, [x27, #0x2e0]
     f70: ad180360     	stp	q0, q0, [x27, #0x300]
     f74: ad190360     	stp	q0, q0, [x27, #0x320]
     f78: 4f01e6c0     	movi.16b	v0, #0x36
     f7c: 6e201c61     	eor.16b	v1, v3, v0
     f80: 6e201c82     	eor.16b	v2, v4, v0
     f84: 6e201ca3     	eor.16b	v3, v5, v0
     f88: ad000b61     	stp	q1, q2, [x27]
     f8c: ad010363     	stp	q3, q0, [x27, #0x20]
     f90: ad020360     	stp	q0, q0, [x27, #0x40]
     f94: ad030360     	stp	q0, q0, [x27, #0x60]
     f98: 90000008     	adrp	x8, 0x0 <ltmp0>
		0000000000000f98:  ARM64_RELOC_PAGE21	l___unnamed_4
     f9c: 91000108     	add	x8, x8, #0x0
		0000000000000f9c:  ARM64_RELOC_PAGEOFF12	l___unnamed_4
     fa0: ad400500     	ldp	q0, q1, [x8]
     fa4: ad0c03e1     	stp	q1, q0, [sp, #0x180]
     fa8: ad0f0760     	stp	q0, q1, [x27, #0x1e0]
     fac: ad410500     	ldp	q0, q1, [x8, #0x20]
     fb0: ad420d02     	ldp	q2, q3, [x8, #0x40]
     fb4: ad0a0be3     	stp	q3, q2, [sp, #0x140]
     fb8: ad110f62     	stp	q2, q3, [x27, #0x220]
     fbc: ad0b03e1     	stp	q1, q0, [sp, #0x160]
     fc0: ad100760     	stp	q0, q1, [x27, #0x200]
     fc4: ad430500     	ldp	q0, q1, [x8, #0x60]
     fc8: ad440d02     	ldp	q2, q3, [x8, #0x80]
     fcc: ad080be3     	stp	q3, q2, [sp, #0x100]
     fd0: ad130f62     	stp	q2, q3, [x27, #0x260]
     fd4: ad0903e1     	stp	q1, q0, [sp, #0x120]
     fd8: ad120760     	stp	q0, q1, [x27, #0x240]
     fdc: ad450500     	ldp	q0, q1, [x8, #0xa0]
     fe0: ad460d02     	ldp	q2, q3, [x8, #0xc0]
     fe4: ad060be3     	stp	q3, q2, [sp, #0xc0]
     fe8: ad150f62     	stp	q2, q3, [x27, #0x2a0]
     fec: ad0703e1     	stp	q1, q0, [sp, #0xe0]
     ff0: ad140760     	stp	q0, q1, [x27, #0x280]
     ff4: 911483e0     	add	x0, sp, #0x520
     ff8: 910d03e1     	add	x1, sp, #0x340
<L1>:
     ffc: 94000000     	bl	 <L1>
		0000000000000ffc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1000: a95e2369     	ldp	x9, x8, [x27, #0x1e0]
    1004: b1020129     	adds	x9, x9, #0x80
    1008: 9a883508     	cinc	x8, x8, hs
    100c: a91e2369     	stp	x9, x8, [x27, #0x1e0]
    1010: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    1014: f100bebf     	cmp	x21, #0x2f
    1018: 540021e9     	b.ls	 <L35>
    101c: 34001fa8     	cbz	w8,  <L32>
    1020: 7101411f     	cmp	w8, #0x50
    1024: 54001f63     	b.lo	 <L32>
    1028: 52801009     	mov	w9, #0x80               ; =128
    102c: cb080136     	sub	x22, x9, x8
    1030: 911483e9     	add	x9, sp, #0x520
    1034: 91014138     	add	x24, x9, #0x50
    1038: 8b080300     	add	x0, x24, x8
    103c: f9405fe1     	ldr	x1, [sp, #0xb8]
    1040: aa1603e2     	mov	x2, x22
<L2>:
    1044: 94000000     	bl	 <L2>
		0000000000001044:  ARM64_RELOC_BRANCH26	_memcpy
    1048: 911483e0     	add	x0, sp, #0x520
    104c: aa1803e1     	mov	x1, x24
<L3>:
    1050: 94000000     	bl	 <L3>
		0000000000001050:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1054: 52800008     	mov	w8, #0x0                ; =0
    1058: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    105c: 140000ee     	b	 <L33>
<L4>:
    1060: d280001c     	mov	x28, #0x0               ; =0
    1064: d2401a88     	eor	x8, x20, #0x7f
    1068: f9001fe8     	str	x8, [sp, #0x38]
    106c: 9106c3e8     	add	x8, sp, #0x1b0
    1070: ad400d24     	ldp	q4, q3, [x9]
    1074: ad0c13e3     	stp	q3, q4, [sp, #0x180]
    1078: 91014117     	add	x23, x8, #0x50
    107c: 91014378     	add	x24, x27, #0x50
    1080: 4f02e783     	movi.16b	v3, #0x5c
    1084: 6e231c05     	eor.16b	v5, v0, v3
    1088: ad411126     	ldp	q6, q4, [x9, #0x20]
    108c: ad0b1be4     	stp	q4, q6, [sp, #0x160]
    1090: 6e231c24     	eor.16b	v4, v1, v3
    1094: ad0417e4     	stp	q4, q5, [sp, #0x80]
    1098: 6e231c44     	eor.16b	v4, v2, v3
    109c: 4f01e6c3     	movi.16b	v3, #0x36
    10a0: 6e231c00     	eor.16b	v0, v0, v3
    10a4: ad0313e0     	stp	q0, q4, [sp, #0x60]
    10a8: ad420124     	ldp	q4, q0, [x9, #0x40]
    10ac: ad0a13e0     	stp	q0, q4, [sp, #0x140]
    10b0: 6e231c24     	eor.16b	v4, v1, v3
    10b4: 6e231c40     	eor.16b	v0, v2, v3
    10b8: ad0213e0     	stp	q0, q4, [sp, #0x40]
    10bc: ad430121     	ldp	q1, q0, [x9, #0x60]
    10c0: ad0907e0     	stp	q0, q1, [sp, #0x120]
    10c4: ad440121     	ldp	q1, q0, [x9, #0x80]
    10c8: ad0807e0     	stp	q0, q1, [sp, #0x100]
    10cc: ad450121     	ldp	q1, q0, [x9, #0xa0]
    10d0: ad0707e0     	stp	q0, q1, [sp, #0xe0]
    10d4: 52800608     	mov	w8, #0x30               ; =48
    10d8: f9001be8     	str	x8, [sp, #0x30]
    10dc: 52800039     	mov	w25, #0x1               ; =1
    10e0: 52800033     	mov	w19, #0x1               ; =1
    10e4: ad460121     	ldp	q1, q0, [x9, #0xc0]
    10e8: ad0607e0     	stp	q0, q1, [sp, #0xc0]
    10ec: f90057f5     	str	x21, [sp, #0xa8]
    10f0: 1400001a     	b	 <L9>
<L5>:
    10f4: d2800019     	mov	x25, #0x0               ; =0
<L6>:
    10f8: 52800609     	mov	w9, #0x30               ; =48
    10fc: cb19013a     	sub	x26, x9, x25
    1100: 8b284300     	add	x0, x24, w8, uxtw
    1104: 911283e8     	add	x8, sp, #0x4a0
    1108: 8b190101     	add	x1, x8, x25
    110c: aa1a03e2     	mov	x2, x26
<L7>:
    1110: 94000000     	bl	 <L7>
		0000000000001110:  ARM64_RELOC_BRANCH26	_memcpy
    1114: 395043e8     	ldrb	w8, [sp, #0x410]
    1118: 0b1a0108     	add	w8, w8, w26
    111c: 391043e8     	strb	w8, [sp, #0x410]
    1120: b100c2c8     	adds	x8, x22, #0x30
    1124: 9a9536a9     	cinc	x9, x21, hs
    1128: a9002768     	stp	x8, x9, [x27]
    112c: 910d03e0     	add	x0, sp, #0x340
    1130: f9405fe8     	ldr	x8, [sp, #0xb8]
    1134: 8b1c0101     	add	x1, x8, x28
<L8>:
    1138: 94000000     	bl	 <L8>
		0000000000001138:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    113c: 52800019     	mov	w25, #0x0               ; =0
    1140: 11000673     	add	w19, w19, #0x1
    1144: 3906bff3     	strb	w19, [sp, #0x1af]
    1148: 5280061c     	mov	w28, #0x30              ; =48
    114c: f94057f5     	ldr	x21, [sp, #0xa8]
    1150: f10182bf     	cmp	x21, #0x60
    1154: 54ffef83     	b.lo	 <L0>
<L9>:
    1158: ad4407e0     	ldp	q0, q1, [sp, #0x80]
    115c: ad070361     	stp	q1, q0, [x27, #0xe0]
    1160: 3dc01fe1     	ldr	q1, [sp, #0x70]
    1164: 4f02e780     	movi.16b	v0, #0x5c
    1168: ad080361     	stp	q1, q0, [x27, #0x100]
    116c: ad090360     	stp	q0, q0, [x27, #0x120]
    1170: ad0a0360     	stp	q0, q0, [x27, #0x140]
    1174: ad4287e0     	ldp	q0, q1, [sp, #0x50]
    1178: ad0b0361     	stp	q1, q0, [x27, #0x160]
    117c: 3dc013e1     	ldr	q1, [sp, #0x40]
    1180: 4f01e6c0     	movi.16b	v0, #0x36
    1184: ad0c0361     	stp	q1, q0, [x27, #0x180]
    1188: ad0d0360     	stp	q0, q0, [x27, #0x1a0]
    118c: ad0e0360     	stp	q0, q0, [x27, #0x1c0]
    1190: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    1194: ad000361     	stp	q1, q0, [x27]
    1198: ad4a03e1     	ldp	q1, q0, [sp, #0x140]
    119c: ad020760     	stp	q0, q1, [x27, #0x40]
    11a0: ad4b03e1     	ldp	q1, q0, [sp, #0x160]
    11a4: ad010760     	stp	q0, q1, [x27, #0x20]
    11a8: ad4803e1     	ldp	q1, q0, [sp, #0x100]
    11ac: ad040760     	stp	q0, q1, [x27, #0x80]
    11b0: ad4903e1     	ldp	q1, q0, [sp, #0x120]
    11b4: ad030760     	stp	q0, q1, [x27, #0x60]
    11b8: ad4603e1     	ldp	q1, q0, [sp, #0xc0]
    11bc: ad060760     	stp	q0, q1, [x27, #0xc0]
    11c0: ad4703e1     	ldp	q1, q0, [sp, #0xe0]
    11c4: ad050760     	stp	q0, q1, [x27, #0xa0]
    11c8: 910d03e0     	add	x0, sp, #0x340
    11cc: 911283e1     	add	x1, sp, #0x4a0
<L10>:
    11d0: 94000000     	bl	 <L10>
		00000000000011d0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    11d4: a9402369     	ldp	x9, x8, [x27]
    11d8: b1020129     	adds	x9, x9, #0x80
    11dc: 9a883508     	cinc	x8, x8, hs
    11e0: a9002369     	stp	x9, x8, [x27]
    11e4: 9106c3e0     	add	x0, sp, #0x1b0
    11e8: 910d03e1     	add	x1, sp, #0x340
    11ec: 52802c02     	mov	w2, #0x160              ; =352
<L11>:
    11f0: 94000000     	bl	 <L11>
		00000000000011f0:  ARM64_RELOC_BRANCH26	_memcpy
    11f4: 394a03e8     	ldrb	w8, [sp, #0x280]
    11f8: 370003f9     	tbnz	w25, #0x0,  <L17>
    11fc: 340001e8     	cbz	w8,  <L14>
    1200: 7101411f     	cmp	w8, #0x50
    1204: 540001a3     	b.lo	 <L14>
    1208: 52801009     	mov	w9, #0x80               ; =128
    120c: cb080139     	sub	x25, x9, x8
    1210: 8b0802e0     	add	x0, x23, x8
    1214: f9405fe1     	ldr	x1, [sp, #0xb8]
    1218: aa1903e2     	mov	x2, x25
<L12>:
    121c: 94000000     	bl	 <L12>
		000000000000121c:  ARM64_RELOC_BRANCH26	_memcpy
    1220: 9106c3e0     	add	x0, sp, #0x1b0
    1224: aa1703e1     	mov	x1, x23
<L13>:
    1228: 94000000     	bl	 <L13>
		0000000000001228:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    122c: 52800008     	mov	w8, #0x0                ; =0
    1230: 390a03ff     	strb	wzr, [sp, #0x280]
    1234: 14000002     	b	 <L15>
<L14>:
    1238: d2800019     	mov	x25, #0x0               ; =0
<L15>:
    123c: 52800609     	mov	w9, #0x30               ; =48
    1240: cb19013a     	sub	x26, x9, x25
    1244: 8b2842e0     	add	x0, x23, w8, uxtw
    1248: f9405fe8     	ldr	x8, [sp, #0xb8]
    124c: 8b190101     	add	x1, x8, x25
    1250: aa1a03e2     	mov	x2, x26
<L16>:
    1254: 94000000     	bl	 <L16>
		0000000000001254:  ARM64_RELOC_BRANCH26	_memcpy
    1258: 394a03e8     	ldrb	w8, [sp, #0x280]
    125c: 0b1a0108     	add	w8, w8, w26
    1260: 390a03e8     	strb	w8, [sp, #0x280]
    1264: a95b27ea     	ldp	x10, x9, [sp, #0x1b0]
    1268: b100c14a     	adds	x10, x10, #0x30
    126c: 9a893529     	cinc	x9, x9, hs
    1270: a91b27ea     	stp	x10, x9, [sp, #0x1b0]
<L17>:
    1274: 34000228     	cbz	w8,  <L20>
    1278: 2a0803e9     	mov	w9, w8
    127c: f9401fea     	ldr	x10, [sp, #0x38]
    1280: eb09015f     	cmp	x10, x9
    1284: 540001a2     	b.hs	 <L20>
    1288: 5280100a     	mov	w10, #0x80              ; =128
    128c: 4b080159     	sub	w25, w10, w8
    1290: 8b0902e0     	add	x0, x23, x9
    1294: f9405be1     	ldr	x1, [sp, #0xb0]
    1298: aa1903e2     	mov	x2, x25
<L18>:
    129c: 94000000     	bl	 <L18>
		000000000000129c:  ARM64_RELOC_BRANCH26	_memcpy
    12a0: 9106c3e0     	add	x0, sp, #0x1b0
    12a4: aa1703e1     	mov	x1, x23
<L19>:
    12a8: 94000000     	bl	 <L19>
		00000000000012a8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    12ac: 52800008     	mov	w8, #0x0                ; =0
    12b0: 390a03ff     	strb	wzr, [sp, #0x280]
    12b4: 14000002     	b	 <L21>
<L20>:
    12b8: d2800019     	mov	x25, #0x0               ; =0
<L21>:
    12bc: cb19029a     	sub	x26, x20, x25
    12c0: 8b2842e0     	add	x0, x23, w8, uxtw
    12c4: f9405be8     	ldr	x8, [sp, #0xb0]
    12c8: 8b190101     	add	x1, x8, x25
    12cc: aa1a03e2     	mov	x2, x26
<L22>:
    12d0: 94000000     	bl	 <L22>
		00000000000012d0:  ARM64_RELOC_BRANCH26	_memcpy
    12d4: 394a03e8     	ldrb	w8, [sp, #0x280]
    12d8: a95b27ea     	ldp	x10, x9, [sp, #0x1b0]
    12dc: ab140156     	adds	x22, x10, x20
    12e0: 9a893535     	cinc	x21, x9, hs
    12e4: a91b57f6     	stp	x22, x21, [sp, #0x1b0]
    12e8: 0b1a0108     	add	w8, w8, w26
    12ec: 390a03e8     	strb	w8, [sp, #0x280]
    12f0: 34000208     	cbz	w8,  <L25>
    12f4: 7101fd1f     	cmp	w8, #0x7f
    12f8: 540001c3     	b.lo	 <L25>
    12fc: 52801009     	mov	w9, #0x80               ; =128
    1300: 4b080139     	sub	w25, w9, w8
    1304: 8b2842e0     	add	x0, x23, w8, uxtw
    1308: 9106bfe1     	add	x1, sp, #0x1af
    130c: aa1903e2     	mov	x2, x25
<L23>:
    1310: 94000000     	bl	 <L23>
		0000000000001310:  ARM64_RELOC_BRANCH26	_memcpy
    1314: 9106c3e0     	add	x0, sp, #0x1b0
    1318: aa1703e1     	mov	x1, x23
<L24>:
    131c: 94000000     	bl	 <L24>
		000000000000131c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1320: 52800008     	mov	w8, #0x0                ; =0
    1324: 390a03ff     	strb	wzr, [sp, #0x280]
    1328: a95b57f6     	ldp	x22, x21, [sp, #0x1b0]
    132c: 14000002     	b	 <L26>
<L25>:
    1330: d2800019     	mov	x25, #0x0               ; =0
<L26>:
    1334: 52800029     	mov	w9, #0x1                ; =1
    1338: cb19013a     	sub	x26, x9, x25
    133c: 8b2842e0     	add	x0, x23, w8, uxtw
    1340: 9106bfe8     	add	x8, sp, #0x1af
    1344: 8b190101     	add	x1, x8, x25
    1348: aa1a03e2     	mov	x2, x26
<L27>:
    134c: 94000000     	bl	 <L27>
		000000000000134c:  ARM64_RELOC_BRANCH26	_memcpy
    1350: 394a03e8     	ldrb	w8, [sp, #0x280]
    1354: 0b1a0108     	add	w8, w8, w26
    1358: 390a03e8     	strb	w8, [sp, #0x280]
    135c: b10006c8     	adds	x8, x22, #0x1
    1360: 9a9536a9     	cinc	x9, x21, hs
    1364: a91b27e8     	stp	x8, x9, [sp, #0x1b0]
    1368: 9106c3e0     	add	x0, sp, #0x1b0
    136c: 911283e1     	add	x1, sp, #0x4a0
<L28>:
    1370: 94000000     	bl	 <L28>
		0000000000001370:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    1374: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    1378: ad050361     	stp	q1, q0, [x27, #0xa0]
    137c: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    1380: ad060361     	stp	q1, q0, [x27, #0xc0]
    1384: ad4907e0     	ldp	q0, q1, [sp, #0x120]
    1388: ad030361     	stp	q1, q0, [x27, #0x60]
    138c: ad4807e0     	ldp	q0, q1, [sp, #0x100]
    1390: ad040361     	stp	q1, q0, [x27, #0x80]
    1394: ad4b07e0     	ldp	q0, q1, [sp, #0x160]
    1398: ad010361     	stp	q1, q0, [x27, #0x20]
    139c: ad4a07e0     	ldp	q0, q1, [sp, #0x140]
    13a0: ad020361     	stp	q1, q0, [x27, #0x40]
    13a4: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    13a8: ad000361     	stp	q1, q0, [x27]
    13ac: 910d03e0     	add	x0, sp, #0x340
    13b0: 9106c3e8     	add	x8, sp, #0x1b0
    13b4: 91038101     	add	x1, x8, #0xe0
<L29>:
    13b8: 94000000     	bl	 <L29>
		00000000000013b8:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    13bc: 395043e8     	ldrb	w8, [sp, #0x410]
    13c0: a940276a     	ldp	x10, x9, [x27]
    13c4: b1020156     	adds	x22, x10, #0x80
    13c8: 9a893535     	cinc	x21, x9, hs
    13cc: a9005776     	stp	x22, x21, [x27]
    13d0: 34ffe928     	cbz	w8,  <L5>
    13d4: 7101411f     	cmp	w8, #0x50
    13d8: 54ffe8e3     	b.lo	 <L5>
    13dc: 52801009     	mov	w9, #0x80               ; =128
    13e0: cb080139     	sub	x25, x9, x8
    13e4: 8b080300     	add	x0, x24, x8
    13e8: 911283e1     	add	x1, sp, #0x4a0
    13ec: aa1903e2     	mov	x2, x25
<L30>:
    13f0: 94000000     	bl	 <L30>
		00000000000013f0:  ARM64_RELOC_BRANCH26	_memcpy
    13f4: 910d03e0     	add	x0, sp, #0x340
    13f8: aa1803e1     	mov	x1, x24
<L31>:
    13fc: 94000000     	bl	 <L31>
		00000000000013fc:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1400: 52800008     	mov	w8, #0x0                ; =0
    1404: 391043ff     	strb	wzr, [sp, #0x410]
    1408: a9405776     	ldp	x22, x21, [x27]
    140c: 17ffff3b     	b	 <L6>
<L32>:
    1410: d2800016     	mov	x22, #0x0               ; =0
<L33>:
    1414: 52800609     	mov	w9, #0x30               ; =48
    1418: cb160138     	sub	x24, x9, x22
    141c: 911483e9     	add	x9, sp, #0x520
    1420: 8b284128     	add	x8, x9, w8, uxtw
    1424: 91014100     	add	x0, x8, #0x50
    1428: f9405fe8     	ldr	x8, [sp, #0xb8]
    142c: 8b160101     	add	x1, x8, x22
    1430: aa1803e2     	mov	x2, x24
<L34>:
    1434: 94000000     	bl	 <L34>
		0000000000001434:  ARM64_RELOC_BRANCH26	_memcpy
    1438: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    143c: 0b180108     	add	w8, w8, w24
    1440: 3917c3e8     	strb	w8, [sp, #0x5f0]
    1444: a95e276a     	ldp	x10, x9, [x27, #0x1e0]
    1448: b100c14a     	adds	x10, x10, #0x30
    144c: 9a893529     	cinc	x9, x9, hs
    1450: a91e276a     	stp	x10, x9, [x27, #0x1e0]
<L35>:
    1454: 34000268     	cbz	w8,  <L38>
    1458: 2a0803e9     	mov	w9, w8
    145c: 8b09028a     	add	x10, x20, x9
    1460: f102015f     	cmp	x10, #0x80
    1464: 540001e3     	b.lo	 <L38>
    1468: 5280100a     	mov	w10, #0x80              ; =128
    146c: 4b080158     	sub	w24, w10, w8
    1470: 911483e8     	add	x8, sp, #0x520
    1474: 91014116     	add	x22, x8, #0x50
    1478: 8b0902c0     	add	x0, x22, x9
    147c: f9405be1     	ldr	x1, [sp, #0xb0]
    1480: aa1803e2     	mov	x2, x24
<L36>:
    1484: 94000000     	bl	 <L36>
		0000000000001484:  ARM64_RELOC_BRANCH26	_memcpy
    1488: 911483e0     	add	x0, sp, #0x520
    148c: aa1603e1     	mov	x1, x22
<L37>:
    1490: 94000000     	bl	 <L37>
		0000000000001490:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1494: 52800008     	mov	w8, #0x0                ; =0
    1498: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    149c: 14000002     	b	 <L39>
<L38>:
    14a0: d2800018     	mov	x24, #0x0               ; =0
<L39>:
    14a4: cb180299     	sub	x25, x20, x24
    14a8: 911483f3     	add	x19, sp, #0x520
    14ac: 91014276     	add	x22, x19, #0x50
    14b0: 8b2842c0     	add	x0, x22, w8, uxtw
    14b4: f9405be8     	ldr	x8, [sp, #0xb0]
    14b8: 8b180101     	add	x1, x8, x24
    14bc: aa1903e2     	mov	x2, x25
<L40>:
    14c0: 94000000     	bl	 <L40>
		00000000000014c0:  ARM64_RELOC_BRANCH26	_memcpy
    14c4: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    14c8: a95e276a     	ldp	x10, x9, [x27, #0x1e0]
    14cc: ab14015a     	adds	x26, x10, x20
    14d0: 9a893538     	cinc	x24, x9, hs
    14d4: a91e637a     	stp	x26, x24, [x27, #0x1e0]
    14d8: 0b190108     	add	w8, w8, w25
    14dc: 3917c3e8     	strb	w8, [sp, #0x5f0]
    14e0: 34000208     	cbz	w8,  <L43>
    14e4: 7101fd1f     	cmp	w8, #0x7f
    14e8: 540001c3     	b.lo	 <L43>
    14ec: 52801009     	mov	w9, #0x80               ; =128
    14f0: 4b080134     	sub	w20, w9, w8
    14f4: 8b2842c0     	add	x0, x22, w8, uxtw
    14f8: 9106bfe1     	add	x1, sp, #0x1af
    14fc: aa1403e2     	mov	x2, x20
<L41>:
    1500: 94000000     	bl	 <L41>
		0000000000001500:  ARM64_RELOC_BRANCH26	_memcpy
    1504: 911483e0     	add	x0, sp, #0x520
    1508: aa1603e1     	mov	x1, x22
<L42>:
    150c: 94000000     	bl	 <L42>
		000000000000150c:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1510: 52800008     	mov	w8, #0x0                ; =0
    1514: 3917c3ff     	strb	wzr, [sp, #0x5f0]
    1518: a95e637a     	ldp	x26, x24, [x27, #0x1e0]
    151c: 14000002     	b	 <L44>
<L43>:
    1520: d2800014     	mov	x20, #0x0               ; =0
<L44>:
    1524: 9106bfe9     	add	x9, sp, #0x1af
    1528: 5280002a     	mov	w10, #0x1               ; =1
    152c: cb140155     	sub	x21, x10, x20
    1530: 8b2842c0     	add	x0, x22, w8, uxtw
    1534: 8b140121     	add	x1, x9, x20
    1538: aa1503e2     	mov	x2, x21
<L45>:
    153c: 94000000     	bl	 <L45>
		000000000000153c:  ARM64_RELOC_BRANCH26	_memcpy
    1540: 3957c3e8     	ldrb	w8, [sp, #0x5f0]
    1544: 0b150108     	add	w8, w8, w21
    1548: 3917c3e8     	strb	w8, [sp, #0x5f0]
    154c: b1000748     	adds	x8, x26, #0x1
    1550: 9a983709     	cinc	x9, x24, hs
    1554: a91e2768     	stp	x8, x9, [x27, #0x1e0]
    1558: 911283f8     	add	x24, sp, #0x4a0
    155c: 911483e0     	add	x0, sp, #0x520
    1560: 911283e1     	add	x1, sp, #0x4a0
<L46>:
    1564: 94000000     	bl	 <L46>
		0000000000001564:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    1568: ad4707e0     	ldp	q0, q1, [sp, #0xe0]
    156c: ad050361     	stp	q1, q0, [x27, #0xa0]
    1570: ad4607e0     	ldp	q0, q1, [sp, #0xc0]
    1574: ad060361     	stp	q1, q0, [x27, #0xc0]
    1578: ad4907e0     	ldp	q0, q1, [sp, #0x120]
    157c: ad030361     	stp	q1, q0, [x27, #0x60]
    1580: ad4807e0     	ldp	q0, q1, [sp, #0x100]
    1584: ad040361     	stp	q1, q0, [x27, #0x80]
    1588: ad4b07e0     	ldp	q0, q1, [sp, #0x160]
    158c: ad010361     	stp	q1, q0, [x27, #0x20]
    1590: ad4a07e0     	ldp	q0, q1, [sp, #0x140]
    1594: ad020361     	stp	q1, q0, [x27, #0x40]
    1598: 910d03e8     	add	x8, sp, #0x340
    159c: 91014114     	add	x20, x8, #0x50
    15a0: ad4c07e0     	ldp	q0, q1, [sp, #0x180]
    15a4: ad000361     	stp	q1, q0, [x27]
    15a8: 910d03e0     	add	x0, sp, #0x340
    15ac: 91038261     	add	x1, x19, #0xe0
<L47>:
    15b0: 94000000     	bl	 <L47>
		00000000000015b0:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    15b4: 395043e8     	ldrb	w8, [sp, #0x410]
    15b8: a940276a     	ldp	x10, x9, [x27]
    15bc: b1020159     	adds	x25, x10, #0x80
    15c0: 9a893533     	cinc	x19, x9, hs
    15c4: a9004f79     	stp	x25, x19, [x27]
    15c8: 34000208     	cbz	w8,  <L50>
    15cc: 7101411f     	cmp	w8, #0x50
    15d0: 540001c3     	b.lo	 <L50>
    15d4: 52801009     	mov	w9, #0x80               ; =128
    15d8: cb080135     	sub	x21, x9, x8
    15dc: 8b080280     	add	x0, x20, x8
    15e0: 911283e1     	add	x1, sp, #0x4a0
    15e4: aa1503e2     	mov	x2, x21
<L48>:
    15e8: 94000000     	bl	 <L48>
		00000000000015e8:  ARM64_RELOC_BRANCH26	_memcpy
    15ec: 910d03e0     	add	x0, sp, #0x340
    15f0: aa1403e1     	mov	x1, x20
<L49>:
    15f4: 94000000     	bl	 <L49>
		00000000000015f4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    15f8: 52800008     	mov	w8, #0x0                ; =0
    15fc: 391043ff     	strb	wzr, [sp, #0x410]
    1600: a9404f79     	ldp	x25, x19, [x27]
    1604: 14000002     	b	 <L51>
<L50>:
    1608: d2800015     	mov	x21, #0x0               ; =0
<L51>:
    160c: 52800609     	mov	w9, #0x30               ; =48
    1610: cb150136     	sub	x22, x9, x21
    1614: 8b284280     	add	x0, x20, w8, uxtw
    1618: 8b150301     	add	x1, x24, x21
    161c: aa1603e2     	mov	x2, x22
<L52>:
    1620: 94000000     	bl	 <L52>
		0000000000001620:  ARM64_RELOC_BRANCH26	_memcpy
    1624: 395043e8     	ldrb	w8, [sp, #0x410]
    1628: 0b160108     	add	w8, w8, w22
    162c: 391043e8     	strb	w8, [sp, #0x410]
    1630: b100c328     	adds	x8, x25, #0x30
    1634: 9a933669     	cinc	x9, x19, hs
    1638: a9002768     	stp	x8, x9, [x27]
    163c: 910d03e0     	add	x0, sp, #0x340
    1640: 910c43e1     	add	x1, sp, #0x310
<L53>:
    1644: 94000000     	bl	 <L53>
		0000000000001644:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
    1648: f9405fe8     	ldr	x8, [sp, #0xb8]
    164c: f9401be9     	ldr	x9, [sp, #0x30]
    1650: 8b090100     	add	x0, x8, x9
    1654: 910c43e1     	add	x1, sp, #0x310
    1658: aa1703e2     	mov	x2, x23
<L54>:
    165c: 94000000     	bl	 <L54>
		000000000000165c:  ARM64_RELOC_BRANCH26	_memcpy
<L55>:
    1660: 911a43ff     	add	sp, sp, #0x690
    1664: a9457bfd     	ldp	x29, x30, [sp, #0x50]
    1668: a9444ff4     	ldp	x20, x19, [sp, #0x40]
    166c: a94357f6     	ldp	x22, x21, [sp, #0x30]
    1670: a9425ff8     	ldp	x24, x23, [sp, #0x20]
    1674: a94167fa     	ldp	x26, x25, [sp, #0x10]
    1678: a8c66ffc     	ldp	x28, x27, [sp], #0x60
    167c: d65f03c0     	ret

0000000000001680 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    1680: a9bd57f6     	stp	x22, x21, [sp, #-0x30]!
    1684: a9014ff4     	stp	x20, x19, [sp, #0x10]
    1688: a9027bfd     	stp	x29, x30, [sp, #0x20]
    168c: 910083fd     	add	x29, sp, #0x20
    1690: aa0103f3     	mov	x19, x1
    1694: aa0003f4     	mov	x20, x0
    1698: 91014015     	add	x21, x0, #0x50
    169c: 39434008     	ldrb	w8, [x0, #0xd0]
    16a0: 52801016     	mov	w22, #0x80              ; =128
    16a4: cb0802c1     	sub	x1, x22, x8
    16a8: 8b0802a0     	add	x0, x21, x8
<L0>:
    16ac: 94000000     	bl	 <L0>
		00000000000016ac:  ARM64_RELOC_BRANCH26	_bzero
    16b0: 39434288     	ldrb	w8, [x20, #0xd0]
    16b4: 38286ab6     	strb	w22, [x21, x8]
    16b8: 39434288     	ldrb	w8, [x20, #0xd0]
    16bc: 11000509     	add	w9, w8, #0x1
    16c0: 39034289     	strb	w9, [x20, #0xd0]
    16c4: 7101bd1f     	cmp	w8, #0x6f
    16c8: 54000129     	b.ls	 <L2>
    16cc: aa1403e0     	mov	x0, x20
    16d0: aa1503e1     	mov	x1, x21
<L1>:
    16d4: 94000000     	bl	 <L1>
		00000000000016d4:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    16d8: 6f00e400     	movi.2d	v0, #0000000000000000
    16dc: ad0282a0     	stp	q0, q0, [x21, #0x50]
    16e0: ad0182a0     	stp	q0, q0, [x21, #0x30]
    16e4: ad0082a0     	stp	q0, q0, [x21, #0x10]
    16e8: 3d8002a0     	str	q0, [x21]
<L2>:
    16ec: a9402e8a     	ldp	x10, x11, [x20]
    16f0: d345fd68     	lsr	x8, x11, #5
    16f4: 531d7149     	lsl	w9, w10, #3
    16f8: 39033e89     	strb	w9, [x20, #0xcf]
    16fc: 53057d49     	lsr	w9, w10, #5
    1700: 39033a89     	strb	w9, [x20, #0xce]
    1704: d34dfd69     	lsr	x9, x11, #13
    1708: 530d7d4c     	lsr	w12, w10, #13
    170c: 3903368c     	strb	w12, [x20, #0xcd]
    1710: d355fd6c     	lsr	x12, x11, #21
    1714: 53157d4d     	lsr	w13, w10, #21
    1718: 93cad56e     	extr	x14, x11, x10, #0x35
    171c: 93cab56f     	extr	x15, x11, x10, #0x2d
    1720: 3903328d     	strb	w13, [x20, #0xcc]
    1724: 93ca956d     	extr	x13, x11, x10, #0x25
    1728: 93ca7570     	extr	x16, x11, x10, #0x1d
    172c: d35dfd71     	lsr	x17, x11, #29
    1730: d365fd60     	lsr	x0, x11, #37
    1734: d36dfd61     	lsr	x1, x11, #45
    1738: d375fd62     	lsr	x2, x11, #53
    173c: 9e670203     	fmov	d3, x16
    1740: 9e6701a2     	fmov	d2, x13
    1744: 9e6701e1     	fmov	d1, x15
    1748: 9e6701c0     	fmov	d0, x14
    174c: 9000000d     	adrp	x13, 0x1000 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x118>
		000000000000174c:  ARM64_RELOC_PAGE21	lCPI11_0
    1750: 3dc001a4     	ldr	q4, [x13]
		0000000000001750:  ARM64_RELOC_PAGEOFF12	lCPI11_0
    1754: 4e046000     	tbl.16b	v0, { v0, v1, v2, v3 }, v4
    1758: 93caf56a     	extr	x10, x11, x10, #0x3d
    175c: 0e212800     	xtn.8b	v0, v0
    1760: 1e270041     	fmov	s1, w2
    1764: 4e031c21     	mov.b	v1[1], w1
    1768: 4e051c01     	mov.b	v1[2], w0
    176c: 4e071e21     	mov.b	v1[3], w17
    1770: 4e091d81     	mov.b	v1[4], w12
    1774: 4e0b1d21     	mov.b	v1[5], w9
    1778: bd00ca80     	str	s0, [x20, #0xc8]
    177c: 4e0d1d01     	mov.b	v1[6], w8
    1780: 4e0f1d41     	mov.b	v1[7], w10
    1784: fd006281     	str	d1, [x20, #0xc0]
    1788: aa1403e0     	mov	x0, x20
    178c: aa1503e1     	mov	x1, x21
<L3>:
    1790: 94000000     	bl	 <L3>
		0000000000001790:  ARM64_RELOC_BRANCH26	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
    1794: f9400a88     	ldr	x8, [x20, #0x10]
    1798: dac00d08     	rev	x8, x8
    179c: f9000268     	str	x8, [x19]
    17a0: f9400e88     	ldr	x8, [x20, #0x18]
    17a4: dac00d08     	rev	x8, x8
    17a8: f9000668     	str	x8, [x19, #0x8]
    17ac: f9401288     	ldr	x8, [x20, #0x20]
    17b0: dac00d08     	rev	x8, x8
    17b4: f9000a68     	str	x8, [x19, #0x10]
    17b8: f9401688     	ldr	x8, [x20, #0x28]
    17bc: dac00d08     	rev	x8, x8
    17c0: f9000e68     	str	x8, [x19, #0x18]
    17c4: f9401a88     	ldr	x8, [x20, #0x30]
    17c8: dac00d08     	rev	x8, x8
    17cc: f9001268     	str	x8, [x19, #0x20]
    17d0: f9401e88     	ldr	x8, [x20, #0x38]
    17d4: dac00d08     	rev	x8, x8
    17d8: f9001668     	str	x8, [x19, #0x28]
    17dc: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    17e0: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    17e4: a8c357f6     	ldp	x22, x21, [sp], #0x30
    17e8: d65f03c0     	ret

00000000000017ec <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    17ec: a9bd6ffc     	stp	x28, x27, [sp, #-0x30]!
    17f0: a9014ff4     	stp	x20, x19, [sp, #0x10]
    17f4: a9027bfd     	stp	x29, x30, [sp, #0x20]
    17f8: 910083fd     	add	x29, sp, #0x20
    17fc: d10a03ff     	sub	sp, sp, #0x280
    1800: ad400420     	ldp	q0, q1, [x1]
    1804: 4e200800     	rev64.16b	v0, v0
    1808: 4e200821     	rev64.16b	v1, v1
    180c: ad0007e0     	stp	q0, q1, [sp]
    1810: ad410821     	ldp	q1, q2, [x1, #0x20]
    1814: 4e200821     	rev64.16b	v1, v1
    1818: 4e200842     	rev64.16b	v2, v2
    181c: ad010be1     	stp	q1, q2, [sp, #0x20]
    1820: ad420821     	ldp	q1, q2, [x1, #0x40]
    1824: 4e200821     	rev64.16b	v1, v1
    1828: 4e200842     	rev64.16b	v2, v2
    182c: ad020be1     	stp	q1, q2, [sp, #0x40]
    1830: ad430821     	ldp	q1, q2, [x1, #0x60]
    1834: 4e200821     	rev64.16b	v1, v1
    1838: 4e200842     	rev64.16b	v2, v2
    183c: ad030be1     	stp	q1, q2, [sp, #0x60]
    1840: 9e66000c     	fmov	x12, d0
    1844: 910003e8     	mov	x8, sp
    1848: 91020108     	add	x8, x8, #0x80
    184c: 52800809     	mov	w9, #0x40               ; =64
    1850: aa0c03ea     	mov	x10, x12
<L0>:
    1854: f85c810b     	ldur	x11, [x8, #-0x38]
    1858: 8b0a016b     	add	x11, x11, x10
    185c: f858810a     	ldur	x10, [x8, #-0x78]
    1860: 93ca054d     	ror	x13, x10, #0x1
    1864: caca21ad     	eor	x13, x13, x10, ror #8
    1868: ca4a1dad     	eor	x13, x13, x10, lsr #7
    186c: 8b0d016b     	add	x11, x11, x13
    1870: f85f010d     	ldur	x13, [x8, #-0x10]
    1874: 93cd4dae     	ror	x14, x13, #0x13
    1878: cacdf5ce     	eor	x14, x14, x13, ror #61
    187c: ca4d19cd     	eor	x13, x14, x13, lsr #6
    1880: 8b0d016b     	add	x11, x11, x13
    1884: f800850b     	str	x11, [x8], #0x8
    1888: f1000529     	subs	x9, x9, #0x1
    188c: 54fffe41     	b.ne	 <L0>
    1890: a940afed     	ldp	x13, x11, [sp, #0x8]
    1894: a9412808     	ldp	x8, x10, [x0, #0x10]
    1898: a942a40e     	ldp	x14, x9, [x0, #0x28]
    189c: 93c9392f     	ror	x15, x9, #0xe
    18a0: cac949ef     	eor	x15, x15, x9, ror #18
    18a4: cac9a5e1     	eor	x1, x15, x9, ror #41
    18a8: a9438c0f     	ldp	x15, x3, [x0, #0x38]
    18ac: 8a290071     	bic	x17, x3, x9
    18b0: a9431010     	ldp	x16, x4, [x0, #0x30]
    18b4: 8a090082     	and	x2, x4, x9
    18b8: aa110042     	orr	x2, x2, x17
    18bc: a9441411     	ldp	x17, x5, [x0, #0x40]
    18c0: 8b0c00ac     	add	x12, x5, x12
    18c4: 8b02018c     	add	x12, x12, x2
    18c8: d295c442     	mov	x2, #0xae22             ; =44578
    18cc: f2bae502     	movk	x2, #0xd728, lsl #16
    18d0: f2c5f302     	movk	x2, #0x2f98, lsl #32
    18d4: f2e85142     	movk	x2, #0x428a, lsl #48
    18d8: 8b02018c     	add	x12, x12, x2
    18dc: 8b0c0025     	add	x5, x1, x12
    18e0: 93c8710c     	ror	x12, x8, #0x1c
    18e4: cac8898c     	eor	x12, x12, x8, ror #34
    18e8: cac89d81     	eor	x1, x12, x8, ror #39
    18ec: a9419c0c     	ldp	x12, x7, [x0, #0x18]
    18f0: aa0a00e2     	orr	x2, x7, x10
    18f4: 8a080042     	and	x2, x2, x8
    18f8: 8a0a00e6     	and	x6, x7, x10
    18fc: aa060042     	orr	x2, x2, x6
    1900: 8b010041     	add	x1, x2, x1
    1904: 8b050022     	add	x2, x1, x5
    1908: a9421801     	ldp	x1, x6, [x0, #0x20]
    190c: 8b0600a6     	add	x6, x5, x6
    1910: 8a260085     	bic	x5, x4, x6
    1914: 93c638d3     	ror	x19, x6, #0xe
    1918: cac64a73     	eor	x19, x19, x6, ror #18
    191c: cac6a673     	eor	x19, x19, x6, ror #41
    1920: 8a060134     	and	x20, x9, x6
    1924: aa050285     	orr	x5, x20, x5
    1928: 8b0d006d     	add	x13, x3, x13
    192c: 8b0501ad     	add	x13, x13, x5
    1930: d28cb9a3     	mov	x3, #0x65cd             ; =26061
    1934: f2a47de3     	movk	x3, #0x23ef, lsl #16
    1938: f2c89223     	movk	x3, #0x4491, lsl #32
    193c: f2ee26e3     	movk	x3, #0x7137, lsl #48
    1940: 8b0301ad     	add	x13, x13, x3
    1944: 8b1301a3     	add	x3, x13, x19
    1948: 93c2704d     	ror	x13, x2, #0x1c
    194c: cac289ad     	eor	x13, x13, x2, ror #34
    1950: cac29dad     	eor	x13, x13, x2, ror #39
    1954: aa080145     	orr	x5, x10, x8
    1958: 8a050045     	and	x5, x2, x5
    195c: 8a080153     	and	x19, x10, x8
    1960: aa1300a5     	orr	x5, x5, x19
    1964: 8b0501ad     	add	x13, x13, x5
    1968: 8b0301ad     	add	x13, x13, x3
    196c: 8b070063     	add	x3, x3, x7
    1970: 8a230125     	bic	x5, x9, x3
    1974: 93c33867     	ror	x7, x3, #0xe
    1978: cac348e7     	eor	x7, x7, x3, ror #18
    197c: cac3a4e7     	eor	x7, x7, x3, ror #41
    1980: 8a0300d3     	and	x19, x6, x3
    1984: aa050265     	orr	x5, x19, x5
    1988: 8b0b008b     	add	x11, x4, x11
    198c: 8b05016b     	add	x11, x11, x5
    1990: d28765e4     	mov	x4, #0x3b2f             ; =15151
    1994: f2bd89a4     	movk	x4, #0xec4d, lsl #16
    1998: f2df79e4     	movk	x4, #0xfbcf, lsl #32
    199c: f2f6b804     	movk	x4, #0xb5c0, lsl #48
    19a0: 8b04016b     	add	x11, x11, x4
    19a4: 8b070164     	add	x4, x11, x7
    19a8: 93cd71ab     	ror	x11, x13, #0x1c
    19ac: cacd896b     	eor	x11, x11, x13, ror #34
    19b0: cacd9d6b     	eor	x11, x11, x13, ror #39
    19b4: aa080045     	orr	x5, x2, x8
    19b8: 8a0501a5     	and	x5, x13, x5
    19bc: 8a080047     	and	x7, x2, x8
    19c0: aa0700a5     	orr	x5, x5, x7
    19c4: 8b05016b     	add	x11, x11, x5
    19c8: 8b04016b     	add	x11, x11, x4
    19cc: 8b0a0084     	add	x4, x4, x10
    19d0: 8a2400ca     	bic	x10, x6, x4
    19d4: 93c43885     	ror	x5, x4, #0xe
    19d8: cac448a5     	eor	x5, x5, x4, ror #18
    19dc: cac4a4a5     	eor	x5, x5, x4, ror #41
    19e0: 8a040067     	and	x7, x3, x4
    19e4: aa0a00ea     	orr	x10, x7, x10
    19e8: a941cfe7     	ldp	x7, x19, [sp, #0x18]
    19ec: 8b070129     	add	x9, x9, x7
    19f0: 8b0a0129     	add	x9, x9, x10
    19f4: d29b778a     	mov	x10, #0xdbbc            ; =56252
    19f8: f2b0312a     	movk	x10, #0x8189, lsl #16
    19fc: f2db74aa     	movk	x10, #0xdba5, lsl #32
    1a00: f2fd36aa     	movk	x10, #0xe9b5, lsl #48
    1a04: 8b0a0129     	add	x9, x9, x10
    1a08: 8b05012a     	add	x10, x9, x5
    1a0c: 93cb7169     	ror	x9, x11, #0x1c
    1a10: cacb8929     	eor	x9, x9, x11, ror #34
    1a14: cacb9d29     	eor	x9, x9, x11, ror #39
    1a18: aa0201a5     	orr	x5, x13, x2
    1a1c: 8a050165     	and	x5, x11, x5
    1a20: 8a0201a7     	and	x7, x13, x2
    1a24: aa0700a5     	orr	x5, x5, x7
    1a28: 8b050129     	add	x9, x9, x5
    1a2c: 8b0a0129     	add	x9, x9, x10
    1a30: 8b080145     	add	x5, x10, x8
    1a34: 8a25006a     	bic	x10, x3, x5
    1a38: 93c538a7     	ror	x7, x5, #0xe
    1a3c: cac548e7     	eor	x7, x7, x5, ror #18
    1a40: cac5a4e7     	eor	x7, x7, x5, ror #41
    1a44: 8a050094     	and	x20, x4, x5
    1a48: aa0a028a     	orr	x10, x20, x10
    1a4c: 8b060266     	add	x6, x19, x6
    1a50: 8b0a00ca     	add	x10, x6, x10
    1a54: d296a706     	mov	x6, #0xb538             ; =46392
    1a58: f2be6906     	movk	x6, #0xf348, lsl #16
    1a5c: f2d84b66     	movk	x6, #0xc25b, lsl #32
    1a60: f2e72ac6     	movk	x6, #0x3956, lsl #48
    1a64: 8b06014a     	add	x10, x10, x6
    1a68: 8b070146     	add	x6, x10, x7
    1a6c: 93c9712a     	ror	x10, x9, #0x1c
    1a70: cac9894a     	eor	x10, x10, x9, ror #34
    1a74: cac99d4a     	eor	x10, x10, x9, ror #39
    1a78: aa0d0167     	orr	x7, x11, x13
    1a7c: 8a070127     	and	x7, x9, x7
    1a80: 8a0d0173     	and	x19, x11, x13
    1a84: aa1300e7     	orr	x7, x7, x19
    1a88: 8b07014a     	add	x10, x10, x7
    1a8c: 8b06014a     	add	x10, x10, x6
    1a90: 8b0200c6     	add	x6, x6, x2
    1a94: 8a260082     	bic	x2, x4, x6
    1a98: 93c638c7     	ror	x7, x6, #0xe
    1a9c: cac648e7     	eor	x7, x7, x6, ror #18
    1aa0: cac6a4e7     	eor	x7, x7, x6, ror #41
    1aa4: 8a0600b3     	and	x19, x5, x6
    1aa8: aa020262     	orr	x2, x19, x2
    1aac: a942d3f3     	ldp	x19, x20, [sp, #0x28]
    1ab0: 8b030263     	add	x3, x19, x3
    1ab4: 8b020062     	add	x2, x3, x2
    1ab8: d29a0323     	mov	x3, #0xd019             ; =53273
    1abc: f2b6c0a3     	movk	x3, #0xb605, lsl #16
    1ac0: f2c23e23     	movk	x3, #0x11f1, lsl #32
    1ac4: f2eb3e23     	movk	x3, #0x59f1, lsl #48
    1ac8: 8b030042     	add	x2, x2, x3
    1acc: 8b070043     	add	x3, x2, x7
    1ad0: 93ca7142     	ror	x2, x10, #0x1c
    1ad4: caca8842     	eor	x2, x2, x10, ror #34
    1ad8: caca9c42     	eor	x2, x2, x10, ror #39
    1adc: aa0b0127     	orr	x7, x9, x11
    1ae0: 8a070147     	and	x7, x10, x7
    1ae4: 8a0b0133     	and	x19, x9, x11
    1ae8: aa1300e7     	orr	x7, x7, x19
    1aec: 8b070042     	add	x2, x2, x7
    1af0: 8b030042     	add	x2, x2, x3
    1af4: 8b0d0063     	add	x3, x3, x13
    1af8: 8a2300ad     	bic	x13, x5, x3
    1afc: 93c33867     	ror	x7, x3, #0xe
    1b00: cac348e7     	eor	x7, x7, x3, ror #18
    1b04: cac3a4e7     	eor	x7, x7, x3, ror #41
    1b08: 8a0300d3     	and	x19, x6, x3
    1b0c: aa0d026d     	orr	x13, x19, x13
    1b10: 8b040284     	add	x4, x20, x4
    1b14: 8b0d008d     	add	x13, x4, x13
    1b18: d289f364     	mov	x4, #0x4f9b             ; =20379
    1b1c: f2b5e324     	movk	x4, #0xaf19, lsl #16
    1b20: f2d05484     	movk	x4, #0x82a4, lsl #32
    1b24: f2f247e4     	movk	x4, #0x923f, lsl #48
    1b28: 8b0401ad     	add	x13, x13, x4
    1b2c: 8b0701a4     	add	x4, x13, x7
    1b30: 93c2704d     	ror	x13, x2, #0x1c
    1b34: cac289ad     	eor	x13, x13, x2, ror #34
    1b38: cac29dad     	eor	x13, x13, x2, ror #39
    1b3c: aa090147     	orr	x7, x10, x9
    1b40: 8a070047     	and	x7, x2, x7
    1b44: 8a090153     	and	x19, x10, x9
    1b48: aa1300e7     	orr	x7, x7, x19
    1b4c: 8b0701ad     	add	x13, x13, x7
    1b50: 8b0401ad     	add	x13, x13, x4
    1b54: 8b0b0084     	add	x4, x4, x11
    1b58: 8a2400cb     	bic	x11, x6, x4
    1b5c: 93c43887     	ror	x7, x4, #0xe
    1b60: cac448e7     	eor	x7, x7, x4, ror #18
    1b64: cac4a4e7     	eor	x7, x7, x4, ror #41
    1b68: 8a040073     	and	x19, x3, x4
    1b6c: aa0b026b     	orr	x11, x19, x11
    1b70: a943d3f3     	ldp	x19, x20, [sp, #0x38]
    1b74: 8b050265     	add	x5, x19, x5
    1b78: 8b0b00ab     	add	x11, x5, x11
    1b7c: d2902305     	mov	x5, #0x8118             ; =33048
    1b80: f2bb4da5     	movk	x5, #0xda6d, lsl #16
    1b84: f2cbdaa5     	movk	x5, #0x5ed5, lsl #32
    1b88: f2f56385     	movk	x5, #0xab1c, lsl #48
    1b8c: 8b05016b     	add	x11, x11, x5
    1b90: 8b070165     	add	x5, x11, x7
    1b94: 93cd71ab     	ror	x11, x13, #0x1c
    1b98: cacd896b     	eor	x11, x11, x13, ror #34
    1b9c: cacd9d6b     	eor	x11, x11, x13, ror #39
    1ba0: aa0a0047     	orr	x7, x2, x10
    1ba4: 8a0701a7     	and	x7, x13, x7
    1ba8: 8a0a0053     	and	x19, x2, x10
    1bac: aa1300e7     	orr	x7, x7, x19
    1bb0: 8b07016b     	add	x11, x11, x7
    1bb4: 8b05016b     	add	x11, x11, x5
    1bb8: 8b0900a5     	add	x5, x5, x9
    1bbc: 8a250069     	bic	x9, x3, x5
    1bc0: 93c538a7     	ror	x7, x5, #0xe
    1bc4: cac548e7     	eor	x7, x7, x5, ror #18
    1bc8: cac5a4e7     	eor	x7, x7, x5, ror #41
    1bcc: 8a050093     	and	x19, x4, x5
    1bd0: aa090269     	orr	x9, x19, x9
    1bd4: 8b060286     	add	x6, x20, x6
    1bd8: 8b0900c9     	add	x9, x6, x9
    1bdc: d2804846     	mov	x6, #0x242              ; =578
    1be0: f2b46066     	movk	x6, #0xa303, lsl #16
    1be4: f2d55306     	movk	x6, #0xaa98, lsl #32
    1be8: f2fb00e6     	movk	x6, #0xd807, lsl #48
    1bec: 8b060129     	add	x9, x9, x6
    1bf0: 8b070126     	add	x6, x9, x7
    1bf4: 93cb7169     	ror	x9, x11, #0x1c
    1bf8: cacb8929     	eor	x9, x9, x11, ror #34
    1bfc: cacb9d29     	eor	x9, x9, x11, ror #39
    1c00: aa0201a7     	orr	x7, x13, x2
    1c04: 8a070167     	and	x7, x11, x7
    1c08: 8a0201b3     	and	x19, x13, x2
    1c0c: aa1300e7     	orr	x7, x7, x19
    1c10: 8b070129     	add	x9, x9, x7
    1c14: 8b060129     	add	x9, x9, x6
    1c18: 8b0a00c6     	add	x6, x6, x10
    1c1c: 8a26008a     	bic	x10, x4, x6
    1c20: 93c638c7     	ror	x7, x6, #0xe
    1c24: cac648e7     	eor	x7, x7, x6, ror #18
    1c28: cac6a4e7     	eor	x7, x7, x6, ror #41
    1c2c: 8a0600b3     	and	x19, x5, x6
    1c30: aa0a026a     	orr	x10, x19, x10
    1c34: a944d3f3     	ldp	x19, x20, [sp, #0x48]
    1c38: 8b030263     	add	x3, x19, x3
    1c3c: 8b0a006a     	add	x10, x3, x10
    1c40: d28df7c3     	mov	x3, #0x6fbe             ; =28606
    1c44: f2a8ae03     	movk	x3, #0x4570, lsl #16
    1c48: f2cb6023     	movk	x3, #0x5b01, lsl #32
    1c4c: f2e25063     	movk	x3, #0x1283, lsl #48
    1c50: 8b03014a     	add	x10, x10, x3
    1c54: 8b070143     	add	x3, x10, x7
    1c58: 93c9712a     	ror	x10, x9, #0x1c
    1c5c: cac9894a     	eor	x10, x10, x9, ror #34
    1c60: cac99d4a     	eor	x10, x10, x9, ror #39
    1c64: aa0d0167     	orr	x7, x11, x13
    1c68: 8a070127     	and	x7, x9, x7
    1c6c: 8a0d0173     	and	x19, x11, x13
    1c70: aa1300e7     	orr	x7, x7, x19
    1c74: 8b07014a     	add	x10, x10, x7
    1c78: 8b03014a     	add	x10, x10, x3
    1c7c: 8b020063     	add	x3, x3, x2
    1c80: 8a2300a2     	bic	x2, x5, x3
    1c84: 93c33867     	ror	x7, x3, #0xe
    1c88: cac348e7     	eor	x7, x7, x3, ror #18
    1c8c: cac3a4e7     	eor	x7, x7, x3, ror #41
    1c90: 8a0300d3     	and	x19, x6, x3
    1c94: aa020262     	orr	x2, x19, x2
    1c98: 8b040284     	add	x4, x20, x4
    1c9c: 8b020082     	add	x2, x4, x2
    1ca0: d2965184     	mov	x4, #0xb28c             ; =45708
    1ca4: f2a9dc84     	movk	x4, #0x4ee4, lsl #16
    1ca8: f2d0b7c4     	movk	x4, #0x85be, lsl #32
    1cac: f2e48624     	movk	x4, #0x2431, lsl #48
    1cb0: 8b040042     	add	x2, x2, x4
    1cb4: 8b070044     	add	x4, x2, x7
    1cb8: 93ca7142     	ror	x2, x10, #0x1c
    1cbc: caca8842     	eor	x2, x2, x10, ror #34
    1cc0: caca9c42     	eor	x2, x2, x10, ror #39
    1cc4: aa0b0127     	orr	x7, x9, x11
    1cc8: 8a070147     	and	x7, x10, x7
    1ccc: 8a0b0133     	and	x19, x9, x11
    1cd0: aa1300e7     	orr	x7, x7, x19
    1cd4: 8b070042     	add	x2, x2, x7
    1cd8: 8b040042     	add	x2, x2, x4
    1cdc: 8b0d0084     	add	x4, x4, x13
    1ce0: 8a2400cd     	bic	x13, x6, x4
    1ce4: 93c43887     	ror	x7, x4, #0xe
    1ce8: cac448e7     	eor	x7, x7, x4, ror #18
    1cec: cac4a4e7     	eor	x7, x7, x4, ror #41
    1cf0: 8a040073     	and	x19, x3, x4
    1cf4: aa0d026d     	orr	x13, x19, x13
    1cf8: a945d3f3     	ldp	x19, x20, [sp, #0x58]
    1cfc: 8b050265     	add	x5, x19, x5
    1d00: 8b0d00ad     	add	x13, x5, x13
    1d04: d2969c45     	mov	x5, #0xb4e2             ; =46306
    1d08: f2babfe5     	movk	x5, #0xd5ff, lsl #16
    1d0c: f2cfb865     	movk	x5, #0x7dc3, lsl #32
    1d10: f2eaa185     	movk	x5, #0x550c, lsl #48
    1d14: 8b0501ad     	add	x13, x13, x5
    1d18: 8b0701a5     	add	x5, x13, x7
    1d1c: 93c2704d     	ror	x13, x2, #0x1c
    1d20: cac289ad     	eor	x13, x13, x2, ror #34
    1d24: cac29dad     	eor	x13, x13, x2, ror #39
    1d28: aa090147     	orr	x7, x10, x9
    1d2c: 8a070047     	and	x7, x2, x7
    1d30: 8a090153     	and	x19, x10, x9
    1d34: aa1300e7     	orr	x7, x7, x19
    1d38: 8b0701ad     	add	x13, x13, x7
    1d3c: 8b0501ad     	add	x13, x13, x5
    1d40: 8b0b00a5     	add	x5, x5, x11
    1d44: 8a25006b     	bic	x11, x3, x5
    1d48: 93c538a7     	ror	x7, x5, #0xe
    1d4c: cac548e7     	eor	x7, x7, x5, ror #18
    1d50: cac5a4e7     	eor	x7, x7, x5, ror #41
    1d54: 8a050093     	and	x19, x4, x5
    1d58: aa0b026b     	orr	x11, x19, x11
    1d5c: 8b060286     	add	x6, x20, x6
    1d60: 8b0b00cb     	add	x11, x6, x11
    1d64: d2912de6     	mov	x6, #0x896f             ; =35183
    1d68: f2be4f66     	movk	x6, #0xf27b, lsl #16
    1d6c: f2cbae86     	movk	x6, #0x5d74, lsl #32
    1d70: f2ee57c6     	movk	x6, #0x72be, lsl #48
    1d74: 8b06016b     	add	x11, x11, x6
    1d78: 8b070166     	add	x6, x11, x7
    1d7c: 93cd71ab     	ror	x11, x13, #0x1c
    1d80: cacd896b     	eor	x11, x11, x13, ror #34
    1d84: cacd9d6b     	eor	x11, x11, x13, ror #39
    1d88: aa0a0047     	orr	x7, x2, x10
    1d8c: 8a0701a7     	and	x7, x13, x7
    1d90: 8a0a0053     	and	x19, x2, x10
    1d94: aa1300e7     	orr	x7, x7, x19
    1d98: 8b07016b     	add	x11, x11, x7
    1d9c: 8b06016b     	add	x11, x11, x6
    1da0: 8b0900c6     	add	x6, x6, x9
    1da4: 8a260089     	bic	x9, x4, x6
    1da8: 93c638c7     	ror	x7, x6, #0xe
    1dac: cac648e7     	eor	x7, x7, x6, ror #18
    1db0: cac6a4e7     	eor	x7, x7, x6, ror #41
    1db4: 8a0600b3     	and	x19, x5, x6
    1db8: aa090269     	orr	x9, x19, x9
    1dbc: a946d3f3     	ldp	x19, x20, [sp, #0x68]
    1dc0: 8b030263     	add	x3, x19, x3
    1dc4: 8b090069     	add	x9, x3, x9
    1dc8: d292d623     	mov	x3, #0x96b1             ; =38577
    1dcc: f2a762c3     	movk	x3, #0x3b16, lsl #16
    1dd0: f2d63fc3     	movk	x3, #0xb1fe, lsl #32
    1dd4: f2f01bc3     	movk	x3, #0x80de, lsl #48
    1dd8: 8b030129     	add	x9, x9, x3
    1ddc: 8b070123     	add	x3, x9, x7
    1de0: 93cb7169     	ror	x9, x11, #0x1c
    1de4: cacb8929     	eor	x9, x9, x11, ror #34
    1de8: cacb9d29     	eor	x9, x9, x11, ror #39
    1dec: aa0201a7     	orr	x7, x13, x2
    1df0: 8a070167     	and	x7, x11, x7
    1df4: 8a0201b3     	and	x19, x13, x2
    1df8: aa1300e7     	orr	x7, x7, x19
    1dfc: 8b070129     	add	x9, x9, x7
    1e00: 8b030129     	add	x9, x9, x3
    1e04: 8b0a0063     	add	x3, x3, x10
    1e08: 8a2300aa     	bic	x10, x5, x3
    1e0c: 93c33867     	ror	x7, x3, #0xe
    1e10: cac348e7     	eor	x7, x7, x3, ror #18
    1e14: cac3a4e7     	eor	x7, x7, x3, ror #41
    1e18: 8a0300d3     	and	x19, x6, x3
    1e1c: aa0a026a     	orr	x10, x19, x10
    1e20: 8b040284     	add	x4, x20, x4
    1e24: 8b0a008a     	add	x10, x4, x10
    1e28: d28246a4     	mov	x4, #0x1235             ; =4661
    1e2c: f2a4b8e4     	movk	x4, #0x25c7, lsl #16
    1e30: f2c0d4e4     	movk	x4, #0x6a7, lsl #32
    1e34: f2f37b84     	movk	x4, #0x9bdc, lsl #48
    1e38: 8b04014a     	add	x10, x10, x4
    1e3c: 8b070144     	add	x4, x10, x7
    1e40: 93c9712a     	ror	x10, x9, #0x1c
    1e44: cac9894a     	eor	x10, x10, x9, ror #34
    1e48: cac99d4a     	eor	x10, x10, x9, ror #39
    1e4c: aa0d0167     	orr	x7, x11, x13
    1e50: 8a070127     	and	x7, x9, x7
    1e54: 8a0d0173     	and	x19, x11, x13
    1e58: aa1300e7     	orr	x7, x7, x19
    1e5c: 8b07014a     	add	x10, x10, x7
    1e60: 8b04014a     	add	x10, x10, x4
    1e64: 8b020084     	add	x4, x4, x2
    1e68: 8a2400c2     	bic	x2, x6, x4
    1e6c: 93c43887     	ror	x7, x4, #0xe
    1e70: cac448e7     	eor	x7, x7, x4, ror #18
    1e74: cac4a4e7     	eor	x7, x7, x4, ror #41
    1e78: 8a040073     	and	x19, x3, x4
    1e7c: aa020262     	orr	x2, x19, x2
    1e80: a947d3f3     	ldp	x19, x20, [sp, #0x78]
    1e84: 8b050265     	add	x5, x19, x5
    1e88: 8b0200a2     	add	x2, x5, x2
    1e8c: d284d285     	mov	x5, #0x2694             ; =9876
    1e90: f2b9ed25     	movk	x5, #0xcf69, lsl #16
    1e94: f2de2e85     	movk	x5, #0xf174, lsl #32
    1e98: f2f83365     	movk	x5, #0xc19b, lsl #48
    1e9c: 8b050042     	add	x2, x2, x5
    1ea0: 8b070045     	add	x5, x2, x7
    1ea4: 93ca7142     	ror	x2, x10, #0x1c
    1ea8: caca8842     	eor	x2, x2, x10, ror #34
    1eac: caca9c42     	eor	x2, x2, x10, ror #39
    1eb0: aa0b0127     	orr	x7, x9, x11
    1eb4: 8a070147     	and	x7, x10, x7
    1eb8: 8a0b0133     	and	x19, x9, x11
    1ebc: aa1300e7     	orr	x7, x7, x19
    1ec0: 8b070042     	add	x2, x2, x7
    1ec4: 8b050042     	add	x2, x2, x5
    1ec8: 8b0d00a5     	add	x5, x5, x13
    1ecc: 8a25006d     	bic	x13, x3, x5
    1ed0: 93c538a7     	ror	x7, x5, #0xe
    1ed4: cac548e7     	eor	x7, x7, x5, ror #18
    1ed8: cac5a4e7     	eor	x7, x7, x5, ror #41
    1edc: 8a050093     	and	x19, x4, x5
    1ee0: aa0d026d     	orr	x13, x19, x13
    1ee4: 8b060286     	add	x6, x20, x6
    1ee8: 8b0d00cd     	add	x13, x6, x13
    1eec: d2895a46     	mov	x6, #0x4ad2             ; =19154
    1ef0: f2b3de26     	movk	x6, #0x9ef1, lsl #16
    1ef4: f2cd3826     	movk	x6, #0x69c1, lsl #32
    1ef8: f2fc9366     	movk	x6, #0xe49b, lsl #48
    1efc: 8b0601ad     	add	x13, x13, x6
    1f00: 8b0701a6     	add	x6, x13, x7
    1f04: 93c2704d     	ror	x13, x2, #0x1c
    1f08: cac289ad     	eor	x13, x13, x2, ror #34
    1f0c: cac29dad     	eor	x13, x13, x2, ror #39
    1f10: aa090147     	orr	x7, x10, x9
    1f14: 8a070047     	and	x7, x2, x7
    1f18: 8a090153     	and	x19, x10, x9
    1f1c: aa1300e7     	orr	x7, x7, x19
    1f20: 8b0701ad     	add	x13, x13, x7
    1f24: 8b0601ad     	add	x13, x13, x6
    1f28: 8b0b00c6     	add	x6, x6, x11
    1f2c: 8a26008b     	bic	x11, x4, x6
    1f30: 93c638c7     	ror	x7, x6, #0xe
    1f34: cac648e7     	eor	x7, x7, x6, ror #18
    1f38: cac6a4e7     	eor	x7, x7, x6, ror #41
    1f3c: 8a0600b3     	and	x19, x5, x6
    1f40: aa0b026b     	orr	x11, x19, x11
    1f44: a948d3f3     	ldp	x19, x20, [sp, #0x88]
    1f48: 8b030263     	add	x3, x19, x3
    1f4c: 8b0b006b     	add	x11, x3, x11
    1f50: d284bc63     	mov	x3, #0x25e3             ; =9699
    1f54: f2a709e3     	movk	x3, #0x384f, lsl #16
    1f58: f2c8f0c3     	movk	x3, #0x4786, lsl #32
    1f5c: f2fdf7c3     	movk	x3, #0xefbe, lsl #48
    1f60: 8b03016b     	add	x11, x11, x3
    1f64: 8b070163     	add	x3, x11, x7
    1f68: 93cd71ab     	ror	x11, x13, #0x1c
    1f6c: cacd896b     	eor	x11, x11, x13, ror #34
    1f70: cacd9d6b     	eor	x11, x11, x13, ror #39
    1f74: aa0a0047     	orr	x7, x2, x10
    1f78: 8a0701a7     	and	x7, x13, x7
    1f7c: 8a0a0053     	and	x19, x2, x10
    1f80: aa1300e7     	orr	x7, x7, x19
    1f84: 8b07016b     	add	x11, x11, x7
    1f88: 8b03016b     	add	x11, x11, x3
    1f8c: 8b090063     	add	x3, x3, x9
    1f90: 8a2300a9     	bic	x9, x5, x3
    1f94: 93c33867     	ror	x7, x3, #0xe
    1f98: cac348e7     	eor	x7, x7, x3, ror #18
    1f9c: cac3a4e7     	eor	x7, x7, x3, ror #41
    1fa0: 8a0300d3     	and	x19, x6, x3
    1fa4: aa090269     	orr	x9, x19, x9
    1fa8: 8b040284     	add	x4, x20, x4
    1fac: 8b090089     	add	x9, x4, x9
    1fb0: d29ab6a4     	mov	x4, #0xd5b5             ; =54709
    1fb4: f2b17184     	movk	x4, #0x8b8c, lsl #16
    1fb8: f2d3b8c4     	movk	x4, #0x9dc6, lsl #32
    1fbc: f2e1f824     	movk	x4, #0xfc1, lsl #48
    1fc0: 8b040129     	add	x9, x9, x4
    1fc4: 8b070124     	add	x4, x9, x7
    1fc8: 93cb7169     	ror	x9, x11, #0x1c
    1fcc: cacb8929     	eor	x9, x9, x11, ror #34
    1fd0: cacb9d29     	eor	x9, x9, x11, ror #39
    1fd4: aa0201a7     	orr	x7, x13, x2
    1fd8: 8a070167     	and	x7, x11, x7
    1fdc: 8a0201b3     	and	x19, x13, x2
    1fe0: aa1300e7     	orr	x7, x7, x19
    1fe4: 8b070129     	add	x9, x9, x7
    1fe8: 8b040129     	add	x9, x9, x4
    1fec: 8b0a0084     	add	x4, x4, x10
    1ff0: 8a2400ca     	bic	x10, x6, x4
    1ff4: 93c43887     	ror	x7, x4, #0xe
    1ff8: cac448e7     	eor	x7, x7, x4, ror #18
    1ffc: cac4a4e7     	eor	x7, x7, x4, ror #41
    2000: 8a040073     	and	x19, x3, x4
    2004: aa0a026a     	orr	x10, x19, x10
    2008: a949d3f3     	ldp	x19, x20, [sp, #0x98]
    200c: 8b050265     	add	x5, x19, x5
    2010: 8b0a00aa     	add	x10, x5, x10
    2014: d2938ca5     	mov	x5, #0x9c65             ; =40037
    2018: f2aef585     	movk	x5, #0x77ac, lsl #16
    201c: f2d43985     	movk	x5, #0xa1cc, lsl #32
    2020: f2e48185     	movk	x5, #0x240c, lsl #48
    2024: 8b05014a     	add	x10, x10, x5
    2028: 8b070145     	add	x5, x10, x7
    202c: 93c9712a     	ror	x10, x9, #0x1c
    2030: cac9894a     	eor	x10, x10, x9, ror #34
    2034: cac99d4a     	eor	x10, x10, x9, ror #39
    2038: aa0d0167     	orr	x7, x11, x13
    203c: 8a070127     	and	x7, x9, x7
    2040: 8a0d0173     	and	x19, x11, x13
    2044: aa1300e7     	orr	x7, x7, x19
    2048: 8b07014a     	add	x10, x10, x7
    204c: 8b05014a     	add	x10, x10, x5
    2050: 8b0200a5     	add	x5, x5, x2
    2054: 8a250062     	bic	x2, x3, x5
    2058: 93c538a7     	ror	x7, x5, #0xe
    205c: cac548e7     	eor	x7, x7, x5, ror #18
    2060: cac5a4e7     	eor	x7, x7, x5, ror #41
    2064: 8a050093     	and	x19, x4, x5
    2068: aa020262     	orr	x2, x19, x2
    206c: 8b060286     	add	x6, x20, x6
    2070: 8b0200c2     	add	x2, x6, x2
    2074: d2804ea6     	mov	x6, #0x275              ; =629
    2078: f2ab2566     	movk	x6, #0x592b, lsl #16
    207c: f2c58de6     	movk	x6, #0x2c6f, lsl #32
    2080: f2e5bd26     	movk	x6, #0x2de9, lsl #48
    2084: 8b060042     	add	x2, x2, x6
    2088: 8b070046     	add	x6, x2, x7
    208c: 93ca7142     	ror	x2, x10, #0x1c
    2090: caca8842     	eor	x2, x2, x10, ror #34
    2094: caca9c42     	eor	x2, x2, x10, ror #39
    2098: aa0b0127     	orr	x7, x9, x11
    209c: 8a070147     	and	x7, x10, x7
    20a0: 8a0b0133     	and	x19, x9, x11
    20a4: aa1300e7     	orr	x7, x7, x19
    20a8: 8b070042     	add	x2, x2, x7
    20ac: 8b060042     	add	x2, x2, x6
    20b0: 8b0d00c6     	add	x6, x6, x13
    20b4: 8a26008d     	bic	x13, x4, x6
    20b8: 93c638c7     	ror	x7, x6, #0xe
    20bc: cac648e7     	eor	x7, x7, x6, ror #18
    20c0: cac6a4e7     	eor	x7, x7, x6, ror #41
    20c4: 8a0600b3     	and	x19, x5, x6
    20c8: aa0d026d     	orr	x13, x19, x13
    20cc: a94ad3f3     	ldp	x19, x20, [sp, #0xa8]
    20d0: 8b030263     	add	x3, x19, x3
    20d4: 8b0d006d     	add	x13, x3, x13
    20d8: d29c9063     	mov	x3, #0xe483             ; =58499
    20dc: f2add4c3     	movk	x3, #0x6ea6, lsl #16
    20e0: f2d09543     	movk	x3, #0x84aa, lsl #32
    20e4: f2e94e83     	movk	x3, #0x4a74, lsl #48
    20e8: 8b0301ad     	add	x13, x13, x3
    20ec: 8b0701a3     	add	x3, x13, x7
    20f0: 93c2704d     	ror	x13, x2, #0x1c
    20f4: cac289ad     	eor	x13, x13, x2, ror #34
    20f8: cac29dad     	eor	x13, x13, x2, ror #39
    20fc: aa090147     	orr	x7, x10, x9
    2100: 8a070047     	and	x7, x2, x7
    2104: 8a090153     	and	x19, x10, x9
    2108: aa1300e7     	orr	x7, x7, x19
    210c: 8b0701ad     	add	x13, x13, x7
    2110: 8b0301ad     	add	x13, x13, x3
    2114: 8b0b0063     	add	x3, x3, x11
    2118: 8a2300ab     	bic	x11, x5, x3
    211c: 93c33867     	ror	x7, x3, #0xe
    2120: cac348e7     	eor	x7, x7, x3, ror #18
    2124: cac3a4e7     	eor	x7, x7, x3, ror #41
    2128: 8a0300d3     	and	x19, x6, x3
    212c: aa0b026b     	orr	x11, x19, x11
    2130: 8b040284     	add	x4, x20, x4
    2134: 8b0b008b     	add	x11, x4, x11
    2138: d29f7a84     	mov	x4, #0xfbd4             ; =64468
    213c: f2b7a824     	movk	x4, #0xbd41, lsl #16
    2140: f2d53b84     	movk	x4, #0xa9dc, lsl #32
    2144: f2eb9604     	movk	x4, #0x5cb0, lsl #48
    2148: 8b04016b     	add	x11, x11, x4
    214c: 8b070164     	add	x4, x11, x7
    2150: 93cd71ab     	ror	x11, x13, #0x1c
    2154: cacd896b     	eor	x11, x11, x13, ror #34
    2158: cacd9d6b     	eor	x11, x11, x13, ror #39
    215c: aa0a0047     	orr	x7, x2, x10
    2160: 8a0701a7     	and	x7, x13, x7
    2164: 8a0a0053     	and	x19, x2, x10
    2168: aa1300e7     	orr	x7, x7, x19
    216c: 8b07016b     	add	x11, x11, x7
    2170: 8b04016b     	add	x11, x11, x4
    2174: 8b090084     	add	x4, x4, x9
    2178: 8a2400c9     	bic	x9, x6, x4
    217c: 93c43887     	ror	x7, x4, #0xe
    2180: cac448e7     	eor	x7, x7, x4, ror #18
    2184: cac4a4e7     	eor	x7, x7, x4, ror #41
    2188: 8a040073     	and	x19, x3, x4
    218c: aa090269     	orr	x9, x19, x9
    2190: a94bd3f3     	ldp	x19, x20, [sp, #0xb8]
    2194: 8b050265     	add	x5, x19, x5
    2198: 8b0900a9     	add	x9, x5, x9
    219c: d28a76a5     	mov	x5, #0x53b5             ; =21429
    21a0: f2b06225     	movk	x5, #0x8311, lsl #16
    21a4: f2d11b45     	movk	x5, #0x88da, lsl #32
    21a8: f2eedf25     	movk	x5, #0x76f9, lsl #48
    21ac: 8b050129     	add	x9, x9, x5
    21b0: 8b070125     	add	x5, x9, x7
    21b4: 93cb7169     	ror	x9, x11, #0x1c
    21b8: cacb8929     	eor	x9, x9, x11, ror #34
    21bc: cacb9d29     	eor	x9, x9, x11, ror #39
    21c0: aa0201a7     	orr	x7, x13, x2
    21c4: 8a070167     	and	x7, x11, x7
    21c8: 8a0201b3     	and	x19, x13, x2
    21cc: aa1300e7     	orr	x7, x7, x19
    21d0: 8b070129     	add	x9, x9, x7
    21d4: 8b050129     	add	x9, x9, x5
    21d8: 8b0a00a5     	add	x5, x5, x10
    21dc: 8a25006a     	bic	x10, x3, x5
    21e0: 93c538a7     	ror	x7, x5, #0xe
    21e4: cac548e7     	eor	x7, x7, x5, ror #18
    21e8: cac5a4e7     	eor	x7, x7, x5, ror #41
    21ec: 8a050093     	and	x19, x4, x5
    21f0: aa0a026a     	orr	x10, x19, x10
    21f4: 8b060286     	add	x6, x20, x6
    21f8: 8b0a00ca     	add	x10, x6, x10
    21fc: d29bf566     	mov	x6, #0xdfab             ; =57259
    2200: f2bdccc6     	movk	x6, #0xee66, lsl #16
    2204: f2ca2a46     	movk	x6, #0x5152, lsl #32
    2208: f2f307c6     	movk	x6, #0x983e, lsl #48
    220c: 8b06014a     	add	x10, x10, x6
    2210: 8b070146     	add	x6, x10, x7
    2214: 93c9712a     	ror	x10, x9, #0x1c
    2218: cac9894a     	eor	x10, x10, x9, ror #34
    221c: cac99d4a     	eor	x10, x10, x9, ror #39
    2220: aa0d0167     	orr	x7, x11, x13
    2224: 8a070127     	and	x7, x9, x7
    2228: 8a0d0173     	and	x19, x11, x13
    222c: aa1300e7     	orr	x7, x7, x19
    2230: 8b07014a     	add	x10, x10, x7
    2234: 8b06014a     	add	x10, x10, x6
    2238: 8b0200c6     	add	x6, x6, x2
    223c: 8a260082     	bic	x2, x4, x6
    2240: 93c638c7     	ror	x7, x6, #0xe
    2244: cac648e7     	eor	x7, x7, x6, ror #18
    2248: cac6a4e7     	eor	x7, x7, x6, ror #41
    224c: 8a0600b3     	and	x19, x5, x6
    2250: aa020262     	orr	x2, x19, x2
    2254: a94cd3f3     	ldp	x19, x20, [sp, #0xc8]
    2258: 8b030263     	add	x3, x19, x3
    225c: 8b020062     	add	x2, x3, x2
    2260: d2864203     	mov	x3, #0x3210             ; =12816
    2264: f2a5b683     	movk	x3, #0x2db4, lsl #16
    2268: f2d8cda3     	movk	x3, #0xc66d, lsl #32
    226c: f2f50623     	movk	x3, #0xa831, lsl #48
    2270: 8b030042     	add	x2, x2, x3
    2274: 8b070043     	add	x3, x2, x7
    2278: 93ca7142     	ror	x2, x10, #0x1c
    227c: caca8842     	eor	x2, x2, x10, ror #34
    2280: caca9c42     	eor	x2, x2, x10, ror #39
    2284: aa0b0127     	orr	x7, x9, x11
    2288: 8a070147     	and	x7, x10, x7
    228c: 8a0b0133     	and	x19, x9, x11
    2290: aa1300e7     	orr	x7, x7, x19
    2294: 8b070042     	add	x2, x2, x7
    2298: 8b030042     	add	x2, x2, x3
    229c: 8b0d0063     	add	x3, x3, x13
    22a0: 8a2300ad     	bic	x13, x5, x3
    22a4: 93c33867     	ror	x7, x3, #0xe
    22a8: cac348e7     	eor	x7, x7, x3, ror #18
    22ac: cac3a4e7     	eor	x7, x7, x3, ror #41
    22b0: 8a0300d3     	and	x19, x6, x3
    22b4: aa0d026d     	orr	x13, x19, x13
    22b8: 8b040284     	add	x4, x20, x4
    22bc: 8b0d008d     	add	x13, x4, x13
    22c0: d28427e4     	mov	x4, #0x213f             ; =8511
    22c4: f2b31f64     	movk	x4, #0x98fb, lsl #16
    22c8: f2c4f904     	movk	x4, #0x27c8, lsl #32
    22cc: f2f60064     	movk	x4, #0xb003, lsl #48
    22d0: 8b0401ad     	add	x13, x13, x4
    22d4: 8b0701a4     	add	x4, x13, x7
    22d8: 93c2704d     	ror	x13, x2, #0x1c
    22dc: cac289ad     	eor	x13, x13, x2, ror #34
    22e0: cac29dad     	eor	x13, x13, x2, ror #39
    22e4: aa090147     	orr	x7, x10, x9
    22e8: 8a070047     	and	x7, x2, x7
    22ec: 8a090153     	and	x19, x10, x9
    22f0: aa1300e7     	orr	x7, x7, x19
    22f4: 8b0701ad     	add	x13, x13, x7
    22f8: 8b0401ad     	add	x13, x13, x4
    22fc: 8b0b0084     	add	x4, x4, x11
    2300: 8a2400cb     	bic	x11, x6, x4
    2304: 93c43887     	ror	x7, x4, #0xe
    2308: cac448e7     	eor	x7, x7, x4, ror #18
    230c: cac4a4e7     	eor	x7, x7, x4, ror #41
    2310: 8a040073     	and	x19, x3, x4
    2314: aa0b026b     	orr	x11, x19, x11
    2318: a94dd3f3     	ldp	x19, x20, [sp, #0xd8]
    231c: 8b050265     	add	x5, x19, x5
    2320: 8b0b00ab     	add	x11, x5, x11
    2324: d281dc85     	mov	x5, #0xee4              ; =3812
    2328: f2b7dde5     	movk	x5, #0xbeef, lsl #16
    232c: f2cff8e5     	movk	x5, #0x7fc7, lsl #32
    2330: f2f7eb25     	movk	x5, #0xbf59, lsl #48
    2334: 8b05016b     	add	x11, x11, x5
    2338: 8b070165     	add	x5, x11, x7
    233c: 93cd71ab     	ror	x11, x13, #0x1c
    2340: cacd896b     	eor	x11, x11, x13, ror #34
    2344: cacd9d6b     	eor	x11, x11, x13, ror #39
    2348: aa0a0047     	orr	x7, x2, x10
    234c: 8a0701a7     	and	x7, x13, x7
    2350: 8a0a0053     	and	x19, x2, x10
    2354: aa1300e7     	orr	x7, x7, x19
    2358: 8b07016b     	add	x11, x11, x7
    235c: 8b05016b     	add	x11, x11, x5
    2360: 8b0900a5     	add	x5, x5, x9
    2364: 8a250069     	bic	x9, x3, x5
    2368: 93c538a7     	ror	x7, x5, #0xe
    236c: cac548e7     	eor	x7, x7, x5, ror #18
    2370: cac5a4e7     	eor	x7, x7, x5, ror #41
    2374: 8a050093     	and	x19, x4, x5
    2378: aa090269     	orr	x9, x19, x9
    237c: 8b060286     	add	x6, x20, x6
    2380: 8b0900c9     	add	x9, x6, x9
    2384: d291f846     	mov	x6, #0x8fc2             ; =36802
    2388: f2a7b506     	movk	x6, #0x3da8, lsl #16
    238c: f2c17e66     	movk	x6, #0xbf3, lsl #32
    2390: f2f8dc06     	movk	x6, #0xc6e0, lsl #48
    2394: 8b060129     	add	x9, x9, x6
    2398: 8b070126     	add	x6, x9, x7
    239c: 93cb7169     	ror	x9, x11, #0x1c
    23a0: cacb8929     	eor	x9, x9, x11, ror #34
    23a4: cacb9d29     	eor	x9, x9, x11, ror #39
    23a8: aa0201a7     	orr	x7, x13, x2
    23ac: 8a070167     	and	x7, x11, x7
    23b0: 8a0201b3     	and	x19, x13, x2
    23b4: aa1300e7     	orr	x7, x7, x19
    23b8: 8b070129     	add	x9, x9, x7
    23bc: 8b060129     	add	x9, x9, x6
    23c0: 8b0a00c6     	add	x6, x6, x10
    23c4: 8a26008a     	bic	x10, x4, x6
    23c8: 93c638c7     	ror	x7, x6, #0xe
    23cc: cac648e7     	eor	x7, x7, x6, ror #18
    23d0: cac6a4e7     	eor	x7, x7, x6, ror #41
    23d4: 8a0600b3     	and	x19, x5, x6
    23d8: aa0a026a     	orr	x10, x19, x10
    23dc: a94ed3f3     	ldp	x19, x20, [sp, #0xe8]
    23e0: 8b030263     	add	x3, x19, x3
    23e4: 8b0a006a     	add	x10, x3, x10
    23e8: d294e4a3     	mov	x3, #0xa725             ; =42789
    23ec: f2b26143     	movk	x3, #0x930a, lsl #16
    23f0: f2d228e3     	movk	x3, #0x9147, lsl #32
    23f4: f2fab4e3     	movk	x3, #0xd5a7, lsl #48
    23f8: 8b03014a     	add	x10, x10, x3
    23fc: 8b070143     	add	x3, x10, x7
    2400: 93c9712a     	ror	x10, x9, #0x1c
    2404: cac9894a     	eor	x10, x10, x9, ror #34
    2408: cac99d4a     	eor	x10, x10, x9, ror #39
    240c: aa0d0167     	orr	x7, x11, x13
    2410: 8a070127     	and	x7, x9, x7
    2414: 8a0d0173     	and	x19, x11, x13
    2418: aa1300e7     	orr	x7, x7, x19
    241c: 8b07014a     	add	x10, x10, x7
    2420: 8b03014a     	add	x10, x10, x3
    2424: 8b020063     	add	x3, x3, x2
    2428: 8a2300a2     	bic	x2, x5, x3
    242c: 93c33867     	ror	x7, x3, #0xe
    2430: cac348e7     	eor	x7, x7, x3, ror #18
    2434: cac3a4e7     	eor	x7, x7, x3, ror #41
    2438: 8a0300d3     	and	x19, x6, x3
    243c: aa020262     	orr	x2, x19, x2
    2440: 8b040284     	add	x4, x20, x4
    2444: 8b020082     	add	x2, x4, x2
    2448: d2904de4     	mov	x4, #0x826f             ; =33391
    244c: f2bc0064     	movk	x4, #0xe003, lsl #16
    2450: f2cc6a24     	movk	x4, #0x6351, lsl #32
    2454: f2e0d944     	movk	x4, #0x6ca, lsl #48
    2458: 8b040042     	add	x2, x2, x4
    245c: 8b070044     	add	x4, x2, x7
    2460: 93ca7142     	ror	x2, x10, #0x1c
    2464: caca8842     	eor	x2, x2, x10, ror #34
    2468: caca9c42     	eor	x2, x2, x10, ror #39
    246c: aa0b0127     	orr	x7, x9, x11
    2470: 8a070147     	and	x7, x10, x7
    2474: 8a0b0133     	and	x19, x9, x11
    2478: aa1300e7     	orr	x7, x7, x19
    247c: 8b070042     	add	x2, x2, x7
    2480: 8b040042     	add	x2, x2, x4
    2484: 8b0d0084     	add	x4, x4, x13
    2488: 8a2400cd     	bic	x13, x6, x4
    248c: 93c43887     	ror	x7, x4, #0xe
    2490: cac448e7     	eor	x7, x7, x4, ror #18
    2494: cac4a4e7     	eor	x7, x7, x4, ror #41
    2498: 8a040073     	and	x19, x3, x4
    249c: aa0d026d     	orr	x13, x19, x13
    24a0: a94fd3f3     	ldp	x19, x20, [sp, #0xf8]
    24a4: 8b050265     	add	x5, x19, x5
    24a8: 8b0d00ad     	add	x13, x5, x13
    24ac: d28dce05     	mov	x5, #0x6e70             ; =28272
    24b0: f2a141c5     	movk	x5, #0xa0e, lsl #16
    24b4: f2c52ce5     	movk	x5, #0x2967, lsl #32
    24b8: f2e28525     	movk	x5, #0x1429, lsl #48
    24bc: 8b0501ad     	add	x13, x13, x5
    24c0: 8b0701a5     	add	x5, x13, x7
    24c4: 93c2704d     	ror	x13, x2, #0x1c
    24c8: cac289ad     	eor	x13, x13, x2, ror #34
    24cc: cac29dad     	eor	x13, x13, x2, ror #39
    24d0: aa090147     	orr	x7, x10, x9
    24d4: 8a070047     	and	x7, x2, x7
    24d8: 8a090153     	and	x19, x10, x9
    24dc: aa1300e7     	orr	x7, x7, x19
    24e0: 8b0701ad     	add	x13, x13, x7
    24e4: 8b0501ad     	add	x13, x13, x5
    24e8: 8b0b00a5     	add	x5, x5, x11
    24ec: 8a25006b     	bic	x11, x3, x5
    24f0: 93c538a7     	ror	x7, x5, #0xe
    24f4: cac548e7     	eor	x7, x7, x5, ror #18
    24f8: cac5a4e7     	eor	x7, x7, x5, ror #41
    24fc: 8a050093     	and	x19, x4, x5
    2500: aa0b026b     	orr	x11, x19, x11
    2504: 8b060286     	add	x6, x20, x6
    2508: 8b0b00cb     	add	x11, x6, x11
    250c: d285ff86     	mov	x6, #0x2ffc             ; =12284
    2510: f2a8da46     	movk	x6, #0x46d2, lsl #16
    2514: f2c150a6     	movk	x6, #0xa85, lsl #32
    2518: f2e4f6e6     	movk	x6, #0x27b7, lsl #48
    251c: 8b06016b     	add	x11, x11, x6
    2520: 8b070166     	add	x6, x11, x7
    2524: 93cd71ab     	ror	x11, x13, #0x1c
    2528: cacd896b     	eor	x11, x11, x13, ror #34
    252c: cacd9d6b     	eor	x11, x11, x13, ror #39
    2530: aa0a0047     	orr	x7, x2, x10
    2534: 8a0701a7     	and	x7, x13, x7
    2538: 8a0a0053     	and	x19, x2, x10
    253c: aa1300e7     	orr	x7, x7, x19
    2540: 8b07016b     	add	x11, x11, x7
    2544: 8b06016b     	add	x11, x11, x6
    2548: 8b0900c6     	add	x6, x6, x9
    254c: 8a260089     	bic	x9, x4, x6
    2550: 93c638c7     	ror	x7, x6, #0xe
    2554: cac648e7     	eor	x7, x7, x6, ror #18
    2558: cac6a4e7     	eor	x7, x7, x6, ror #41
    255c: 8a0600b3     	and	x19, x5, x6
    2560: aa090269     	orr	x9, x19, x9
    2564: a950d3f3     	ldp	x19, x20, [sp, #0x108]
    2568: 8b030263     	add	x3, x19, x3
    256c: 8b090069     	add	x9, x3, x9
    2570: d29924c3     	mov	x3, #0xc926             ; =51494
    2574: f2ab84c3     	movk	x3, #0x5c26, lsl #16
    2578: f2c42703     	movk	x3, #0x2138, lsl #32
    257c: f2e5c363     	movk	x3, #0x2e1b, lsl #48
    2580: 8b030129     	add	x9, x9, x3
    2584: 8b070123     	add	x3, x9, x7
    2588: 93cb7169     	ror	x9, x11, #0x1c
    258c: cacb8929     	eor	x9, x9, x11, ror #34
    2590: cacb9d29     	eor	x9, x9, x11, ror #39
    2594: aa0201a7     	orr	x7, x13, x2
    2598: 8a070167     	and	x7, x11, x7
    259c: 8a0201b3     	and	x19, x13, x2
    25a0: aa1300e7     	orr	x7, x7, x19
    25a4: 8b070129     	add	x9, x9, x7
    25a8: 8b030129     	add	x9, x9, x3
    25ac: 8b0a0063     	add	x3, x3, x10
    25b0: 8a2300aa     	bic	x10, x5, x3
    25b4: 93c33867     	ror	x7, x3, #0xe
    25b8: cac348e7     	eor	x7, x7, x3, ror #18
    25bc: cac3a4e7     	eor	x7, x7, x3, ror #41
    25c0: 8a0300d3     	and	x19, x6, x3
    25c4: aa0a026a     	orr	x10, x19, x10
    25c8: 8b040284     	add	x4, x20, x4
    25cc: 8b0a008a     	add	x10, x4, x10
    25d0: d2855da4     	mov	x4, #0x2aed             ; =10989
    25d4: f2ab5884     	movk	x4, #0x5ac4, lsl #16
    25d8: f2cdbf84     	movk	x4, #0x6dfc, lsl #32
    25dc: f2e9a584     	movk	x4, #0x4d2c, lsl #48
    25e0: 8b04014a     	add	x10, x10, x4
    25e4: 8b070144     	add	x4, x10, x7
    25e8: 93c9712a     	ror	x10, x9, #0x1c
    25ec: cac9894a     	eor	x10, x10, x9, ror #34
    25f0: cac99d4a     	eor	x10, x10, x9, ror #39
    25f4: aa0d0167     	orr	x7, x11, x13
    25f8: 8a070127     	and	x7, x9, x7
    25fc: 8a0d0173     	and	x19, x11, x13
    2600: aa1300e7     	orr	x7, x7, x19
    2604: 8b07014a     	add	x10, x10, x7
    2608: 8b04014a     	add	x10, x10, x4
    260c: 8b020084     	add	x4, x4, x2
    2610: 8a2400c2     	bic	x2, x6, x4
    2614: 93c43887     	ror	x7, x4, #0xe
    2618: cac448e7     	eor	x7, x7, x4, ror #18
    261c: cac4a4e7     	eor	x7, x7, x4, ror #41
    2620: 8a040073     	and	x19, x3, x4
    2624: aa020262     	orr	x2, x19, x2
    2628: a951d3f3     	ldp	x19, x20, [sp, #0x118]
    262c: 8b050265     	add	x5, x19, x5
    2630: 8b0200a2     	add	x2, x5, x2
    2634: d2967be5     	mov	x5, #0xb3df             ; =46047
    2638: f2b3b2a5     	movk	x5, #0x9d95, lsl #16
    263c: f2c1a265     	movk	x5, #0xd13, lsl #32
    2640: f2ea6705     	movk	x5, #0x5338, lsl #48
    2644: 8b050042     	add	x2, x2, x5
    2648: 8b070045     	add	x5, x2, x7
    264c: 93ca7142     	ror	x2, x10, #0x1c
    2650: caca8842     	eor	x2, x2, x10, ror #34
    2654: caca9c42     	eor	x2, x2, x10, ror #39
    2658: aa0b0127     	orr	x7, x9, x11
    265c: 8a070147     	and	x7, x10, x7
    2660: 8a0b0133     	and	x19, x9, x11
    2664: aa1300e7     	orr	x7, x7, x19
    2668: 8b070042     	add	x2, x2, x7
    266c: 8b050042     	add	x2, x2, x5
    2670: 8b0d00a5     	add	x5, x5, x13
    2674: 8a25006d     	bic	x13, x3, x5
    2678: 93c538a7     	ror	x7, x5, #0xe
    267c: cac548e7     	eor	x7, x7, x5, ror #18
    2680: cac5a4e7     	eor	x7, x7, x5, ror #41
    2684: 8a050093     	and	x19, x4, x5
    2688: aa0d026d     	orr	x13, x19, x13
    268c: 8b060286     	add	x6, x20, x6
    2690: 8b0d00cd     	add	x13, x6, x13
    2694: d28c7bc6     	mov	x6, #0x63de             ; =25566
    2698: f2b175e6     	movk	x6, #0x8baf, lsl #16
    269c: f2ce6a86     	movk	x6, #0x7354, lsl #32
    26a0: f2eca146     	movk	x6, #0x650a, lsl #48
    26a4: 8b0601ad     	add	x13, x13, x6
    26a8: 8b0701a6     	add	x6, x13, x7
    26ac: 93c2704d     	ror	x13, x2, #0x1c
    26b0: cac289ad     	eor	x13, x13, x2, ror #34
    26b4: cac29dad     	eor	x13, x13, x2, ror #39
    26b8: aa090147     	orr	x7, x10, x9
    26bc: 8a070047     	and	x7, x2, x7
    26c0: 8a090153     	and	x19, x10, x9
    26c4: aa1300e7     	orr	x7, x7, x19
    26c8: 8b0701ad     	add	x13, x13, x7
    26cc: 8b0601ad     	add	x13, x13, x6
    26d0: 8b0b00c6     	add	x6, x6, x11
    26d4: 8a26008b     	bic	x11, x4, x6
    26d8: 93c638c7     	ror	x7, x6, #0xe
    26dc: cac648e7     	eor	x7, x7, x6, ror #18
    26e0: cac6a4e7     	eor	x7, x7, x6, ror #41
    26e4: 8a0600b3     	and	x19, x5, x6
    26e8: aa0b026b     	orr	x11, x19, x11
    26ec: a952d3f3     	ldp	x19, x20, [sp, #0x128]
    26f0: 8b030263     	add	x3, x19, x3
    26f4: 8b0b006b     	add	x11, x3, x11
    26f8: d2965503     	mov	x3, #0xb2a8             ; =45736
    26fc: f2a78ee3     	movk	x3, #0x3c77, lsl #16
    2700: f2c15763     	movk	x3, #0xabb, lsl #32
    2704: f2eecd43     	movk	x3, #0x766a, lsl #48
    2708: 8b03016b     	add	x11, x11, x3
    270c: 8b070163     	add	x3, x11, x7
    2710: 93cd71ab     	ror	x11, x13, #0x1c
    2714: cacd896b     	eor	x11, x11, x13, ror #34
    2718: cacd9d6b     	eor	x11, x11, x13, ror #39
    271c: aa0a0047     	orr	x7, x2, x10
    2720: 8a0701a7     	and	x7, x13, x7
    2724: 8a0a0053     	and	x19, x2, x10
    2728: aa1300e7     	orr	x7, x7, x19
    272c: 8b07016b     	add	x11, x11, x7
    2730: 8b03016b     	add	x11, x11, x3
    2734: 8b090063     	add	x3, x3, x9
    2738: 8a2300a9     	bic	x9, x5, x3
    273c: 93c33867     	ror	x7, x3, #0xe
    2740: cac348e7     	eor	x7, x7, x3, ror #18
    2744: cac3a4e7     	eor	x7, x7, x3, ror #41
    2748: 8a0300d3     	and	x19, x6, x3
    274c: aa090269     	orr	x9, x19, x9
    2750: 8b040284     	add	x4, x20, x4
    2754: 8b090089     	add	x9, x4, x9
    2758: d295dcc4     	mov	x4, #0xaee6             ; =44774
    275c: f2a8fda4     	movk	x4, #0x47ed, lsl #16
    2760: f2d925c4     	movk	x4, #0xc92e, lsl #32
    2764: f2f03844     	movk	x4, #0x81c2, lsl #48
    2768: 8b040129     	add	x9, x9, x4
    276c: 8b070124     	add	x4, x9, x7
    2770: 93cb7169     	ror	x9, x11, #0x1c
    2774: cacb8929     	eor	x9, x9, x11, ror #34
    2778: cacb9d29     	eor	x9, x9, x11, ror #39
    277c: aa0201a7     	orr	x7, x13, x2
    2780: 8a070167     	and	x7, x11, x7
    2784: 8a0201b3     	and	x19, x13, x2
    2788: aa1300e7     	orr	x7, x7, x19
    278c: 8b070129     	add	x9, x9, x7
    2790: 8b040129     	add	x9, x9, x4
    2794: 8b0a0084     	add	x4, x4, x10
    2798: 8a2400ca     	bic	x10, x6, x4
    279c: 93c43887     	ror	x7, x4, #0xe
    27a0: cac448e7     	eor	x7, x7, x4, ror #18
    27a4: cac4a4e7     	eor	x7, x7, x4, ror #41
    27a8: 8a040073     	and	x19, x3, x4
    27ac: aa0a026a     	orr	x10, x19, x10
    27b0: a953d3f3     	ldp	x19, x20, [sp, #0x138]
    27b4: 8b050265     	add	x5, x19, x5
    27b8: 8b0a00aa     	add	x10, x5, x10
    27bc: d286a765     	mov	x5, #0x353b             ; =13627
    27c0: f2a29045     	movk	x5, #0x1482, lsl #16
    27c4: f2c590a5     	movk	x5, #0x2c85, lsl #32
    27c8: f2f24e45     	movk	x5, #0x9272, lsl #48
    27cc: 8b05014a     	add	x10, x10, x5
    27d0: 8b070145     	add	x5, x10, x7
    27d4: 93c9712a     	ror	x10, x9, #0x1c
    27d8: cac9894a     	eor	x10, x10, x9, ror #34
    27dc: cac99d4a     	eor	x10, x10, x9, ror #39
    27e0: aa0d0167     	orr	x7, x11, x13
    27e4: 8a070127     	and	x7, x9, x7
    27e8: 8a0d0173     	and	x19, x11, x13
    27ec: aa1300e7     	orr	x7, x7, x19
    27f0: 8b07014a     	add	x10, x10, x7
    27f4: 8b05014a     	add	x10, x10, x5
    27f8: 8b0200a5     	add	x5, x5, x2
    27fc: 8a250062     	bic	x2, x3, x5
    2800: 93c538a7     	ror	x7, x5, #0xe
    2804: cac548e7     	eor	x7, x7, x5, ror #18
    2808: cac5a4e7     	eor	x7, x7, x5, ror #41
    280c: 8a050093     	and	x19, x4, x5
    2810: aa020262     	orr	x2, x19, x2
    2814: 8b060286     	add	x6, x20, x6
    2818: 8b0200c2     	add	x2, x6, x2
    281c: d2806c86     	mov	x6, #0x364              ; =868
    2820: f2a99e26     	movk	x6, #0x4cf1, lsl #16
    2824: f2dd1426     	movk	x6, #0xe8a1, lsl #32
    2828: f2f457e6     	movk	x6, #0xa2bf, lsl #48
    282c: 8b060042     	add	x2, x2, x6
    2830: 8b070046     	add	x6, x2, x7
    2834: 93ca7142     	ror	x2, x10, #0x1c
    2838: caca8842     	eor	x2, x2, x10, ror #34
    283c: caca9c42     	eor	x2, x2, x10, ror #39
    2840: aa0b0127     	orr	x7, x9, x11
    2844: 8a070147     	and	x7, x10, x7
    2848: 8a0b0133     	and	x19, x9, x11
    284c: aa1300e7     	orr	x7, x7, x19
    2850: 8b070042     	add	x2, x2, x7
    2854: 8b060042     	add	x2, x2, x6
    2858: 8b0d00c6     	add	x6, x6, x13
    285c: 8a26008d     	bic	x13, x4, x6
    2860: 93c638c7     	ror	x7, x6, #0xe
    2864: cac648e7     	eor	x7, x7, x6, ror #18
    2868: cac6a4e7     	eor	x7, x7, x6, ror #41
    286c: 8a0600b3     	and	x19, x5, x6
    2870: aa0d026d     	orr	x13, x19, x13
    2874: a954d3f3     	ldp	x19, x20, [sp, #0x148]
    2878: 8b030263     	add	x3, x19, x3
    287c: 8b0d006d     	add	x13, x3, x13
    2880: d2860023     	mov	x3, #0x3001             ; =12289
    2884: f2b78843     	movk	x3, #0xbc42, lsl #16
    2888: f2ccc963     	movk	x3, #0x664b, lsl #32
    288c: f2f50343     	movk	x3, #0xa81a, lsl #48
    2890: 8b0301ad     	add	x13, x13, x3
    2894: 8b0701a3     	add	x3, x13, x7
    2898: 93c2704d     	ror	x13, x2, #0x1c
    289c: cac289ad     	eor	x13, x13, x2, ror #34
    28a0: cac29dad     	eor	x13, x13, x2, ror #39
    28a4: aa090147     	orr	x7, x10, x9
    28a8: 8a070047     	and	x7, x2, x7
    28ac: 8a090153     	and	x19, x10, x9
    28b0: aa1300e7     	orr	x7, x7, x19
    28b4: 8b0701ad     	add	x13, x13, x7
    28b8: 8b0301ad     	add	x13, x13, x3
    28bc: 8b0b0063     	add	x3, x3, x11
    28c0: 8a2300ab     	bic	x11, x5, x3
    28c4: 93c33867     	ror	x7, x3, #0xe
    28c8: cac348e7     	eor	x7, x7, x3, ror #18
    28cc: cac3a4e7     	eor	x7, x7, x3, ror #41
    28d0: 8a0300d3     	and	x19, x6, x3
    28d4: aa0b026b     	orr	x11, x19, x11
    28d8: 8b040284     	add	x4, x20, x4
    28dc: 8b0b008b     	add	x11, x4, x11
    28e0: d292f224     	mov	x4, #0x9791             ; =38801
    28e4: f2ba1f04     	movk	x4, #0xd0f8, lsl #16
    28e8: f2d16e04     	movk	x4, #0x8b70, lsl #32
    28ec: f2f84964     	movk	x4, #0xc24b, lsl #48
    28f0: 8b04016b     	add	x11, x11, x4
    28f4: 8b070164     	add	x4, x11, x7
    28f8: 93cd71ab     	ror	x11, x13, #0x1c
    28fc: cacd896b     	eor	x11, x11, x13, ror #34
    2900: cacd9d6b     	eor	x11, x11, x13, ror #39
    2904: aa0a0047     	orr	x7, x2, x10
    2908: 8a0701a7     	and	x7, x13, x7
    290c: 8a0a0053     	and	x19, x2, x10
    2910: aa1300e7     	orr	x7, x7, x19
    2914: 8b07016b     	add	x11, x11, x7
    2918: 8b04016b     	add	x11, x11, x4
    291c: 8b090084     	add	x4, x4, x9
    2920: 8a2400c9     	bic	x9, x6, x4
    2924: 93c43887     	ror	x7, x4, #0xe
    2928: cac448e7     	eor	x7, x7, x4, ror #18
    292c: cac4a4e7     	eor	x7, x7, x4, ror #41
    2930: 8a040073     	and	x19, x3, x4
    2934: aa090269     	orr	x9, x19, x9
    2938: a955d3f3     	ldp	x19, x20, [sp, #0x158]
    293c: 8b050265     	add	x5, x19, x5
    2940: 8b0900a9     	add	x9, x5, x9
    2944: d297c605     	mov	x5, #0xbe30             ; =48688
    2948: f2a0ca85     	movk	x5, #0x654, lsl #16
    294c: f2ca3465     	movk	x5, #0x51a3, lsl #32
    2950: f2f8ed85     	movk	x5, #0xc76c, lsl #48
    2954: 8b050129     	add	x9, x9, x5
    2958: 8b070125     	add	x5, x9, x7
    295c: 93cb7169     	ror	x9, x11, #0x1c
    2960: cacb8929     	eor	x9, x9, x11, ror #34
    2964: cacb9d29     	eor	x9, x9, x11, ror #39
    2968: aa0201a7     	orr	x7, x13, x2
    296c: 8a070167     	and	x7, x11, x7
    2970: 8a0201b3     	and	x19, x13, x2
    2974: aa1300e7     	orr	x7, x7, x19
    2978: 8b070129     	add	x9, x9, x7
    297c: 8b050129     	add	x9, x9, x5
    2980: 8b0a00a5     	add	x5, x5, x10
    2984: 8a25006a     	bic	x10, x3, x5
    2988: 93c538a7     	ror	x7, x5, #0xe
    298c: cac548e7     	eor	x7, x7, x5, ror #18
    2990: cac5a4e7     	eor	x7, x7, x5, ror #41
    2994: 8a050093     	and	x19, x4, x5
    2998: aa0a026a     	orr	x10, x19, x10
    299c: 8b060286     	add	x6, x20, x6
    29a0: 8b0a00ca     	add	x10, x6, x10
    29a4: d28a4306     	mov	x6, #0x5218             ; =21016
    29a8: f2badde6     	movk	x6, #0xd6ef, lsl #16
    29ac: f2dd0326     	movk	x6, #0xe819, lsl #32
    29b0: f2fa3246     	movk	x6, #0xd192, lsl #48
    29b4: 8b06014a     	add	x10, x10, x6
    29b8: 8b070146     	add	x6, x10, x7
    29bc: 93c9712a     	ror	x10, x9, #0x1c
    29c0: cac9894a     	eor	x10, x10, x9, ror #34
    29c4: cac99d4a     	eor	x10, x10, x9, ror #39
    29c8: aa0d0167     	orr	x7, x11, x13
    29cc: 8a070127     	and	x7, x9, x7
    29d0: 8a0d0173     	and	x19, x11, x13
    29d4: aa1300e7     	orr	x7, x7, x19
    29d8: 8b07014a     	add	x10, x10, x7
    29dc: 8b06014a     	add	x10, x10, x6
    29e0: 8b0200c6     	add	x6, x6, x2
    29e4: 8a260082     	bic	x2, x4, x6
    29e8: 93c638c7     	ror	x7, x6, #0xe
    29ec: cac648e7     	eor	x7, x7, x6, ror #18
    29f0: cac6a4e7     	eor	x7, x7, x6, ror #41
    29f4: 8a0600b3     	and	x19, x5, x6
    29f8: aa020262     	orr	x2, x19, x2
    29fc: a956d3f3     	ldp	x19, x20, [sp, #0x168]
    2a00: 8b030263     	add	x3, x19, x3
    2a04: 8b020062     	add	x2, x3, x2
    2a08: d2952203     	mov	x3, #0xa910             ; =43280
    2a0c: f2aaaca3     	movk	x3, #0x5565, lsl #16
    2a10: f2c0c483     	movk	x3, #0x624, lsl #32
    2a14: f2fad323     	movk	x3, #0xd699, lsl #48
    2a18: 8b030042     	add	x2, x2, x3
    2a1c: 8b070043     	add	x3, x2, x7
    2a20: 93ca7142     	ror	x2, x10, #0x1c
    2a24: caca8842     	eor	x2, x2, x10, ror #34
    2a28: caca9c42     	eor	x2, x2, x10, ror #39
    2a2c: aa0b0127     	orr	x7, x9, x11
    2a30: 8a070147     	and	x7, x10, x7
    2a34: 8a0b0133     	and	x19, x9, x11
    2a38: aa1300e7     	orr	x7, x7, x19
    2a3c: 8b070042     	add	x2, x2, x7
    2a40: 8b030042     	add	x2, x2, x3
    2a44: 8b0d0063     	add	x3, x3, x13
    2a48: 8a2300ad     	bic	x13, x5, x3
    2a4c: 93c33867     	ror	x7, x3, #0xe
    2a50: cac348e7     	eor	x7, x7, x3, ror #18
    2a54: cac3a4e7     	eor	x7, x7, x3, ror #41
    2a58: 8a0300d3     	and	x19, x6, x3
    2a5c: aa0d026d     	orr	x13, x19, x13
    2a60: 8b040284     	add	x4, x20, x4
    2a64: 8b0d008d     	add	x13, x4, x13
    2a68: d2840544     	mov	x4, #0x202a             ; =8234
    2a6c: f2aaee24     	movk	x4, #0x5771, lsl #16
    2a70: f2c6b0a4     	movk	x4, #0x3585, lsl #32
    2a74: f2fe81c4     	movk	x4, #0xf40e, lsl #48
    2a78: 8b0401ad     	add	x13, x13, x4
    2a7c: 8b0701a4     	add	x4, x13, x7
    2a80: 93c2704d     	ror	x13, x2, #0x1c
    2a84: cac289ad     	eor	x13, x13, x2, ror #34
    2a88: cac29dad     	eor	x13, x13, x2, ror #39
    2a8c: aa090147     	orr	x7, x10, x9
    2a90: 8a070047     	and	x7, x2, x7
    2a94: 8a090153     	and	x19, x10, x9
    2a98: aa1300e7     	orr	x7, x7, x19
    2a9c: 8b0701ad     	add	x13, x13, x7
    2aa0: 8b0401ad     	add	x13, x13, x4
    2aa4: 8b0b0084     	add	x4, x4, x11
    2aa8: 8a2400cb     	bic	x11, x6, x4
    2aac: 93c43887     	ror	x7, x4, #0xe
    2ab0: cac448e7     	eor	x7, x7, x4, ror #18
    2ab4: cac4a4e7     	eor	x7, x7, x4, ror #41
    2ab8: 8a040073     	and	x19, x3, x4
    2abc: aa0b026b     	orr	x11, x19, x11
    2ac0: a957d3f3     	ldp	x19, x20, [sp, #0x178]
    2ac4: 8b050265     	add	x5, x19, x5
    2ac8: 8b0b00ab     	add	x11, x5, x11
    2acc: d29a3705     	mov	x5, #0xd1b8             ; =53688
    2ad0: f2a65765     	movk	x5, #0x32bb, lsl #16
    2ad4: f2d40e05     	movk	x5, #0xa070, lsl #32
    2ad8: f2e20d45     	movk	x5, #0x106a, lsl #48
    2adc: 8b05016b     	add	x11, x11, x5
    2ae0: 8b070165     	add	x5, x11, x7
    2ae4: 93cd71ab     	ror	x11, x13, #0x1c
    2ae8: cacd896b     	eor	x11, x11, x13, ror #34
    2aec: cacd9d6b     	eor	x11, x11, x13, ror #39
    2af0: aa0a0047     	orr	x7, x2, x10
    2af4: 8a0701a7     	and	x7, x13, x7
    2af8: 8a0a0053     	and	x19, x2, x10
    2afc: aa1300e7     	orr	x7, x7, x19
    2b00: 8b07016b     	add	x11, x11, x7
    2b04: 8b05016b     	add	x11, x11, x5
    2b08: 8b0900a5     	add	x5, x5, x9
    2b0c: 8a250069     	bic	x9, x3, x5
    2b10: 93c538a7     	ror	x7, x5, #0xe
    2b14: cac548e7     	eor	x7, x7, x5, ror #18
    2b18: cac5a4e7     	eor	x7, x7, x5, ror #41
    2b1c: 8a050093     	and	x19, x4, x5
    2b20: aa090269     	orr	x9, x19, x9
    2b24: 8b060286     	add	x6, x20, x6
    2b28: 8b0900c9     	add	x9, x6, x9
    2b2c: d29a1906     	mov	x6, #0xd0c8             ; =53448
    2b30: f2b71a46     	movk	x6, #0xb8d2, lsl #16
    2b34: f2d822c6     	movk	x6, #0xc116, lsl #32
    2b38: f2e33486     	movk	x6, #0x19a4, lsl #48
    2b3c: 8b060129     	add	x9, x9, x6
    2b40: 8b070126     	add	x6, x9, x7
    2b44: 93cb7169     	ror	x9, x11, #0x1c
    2b48: cacb8929     	eor	x9, x9, x11, ror #34
    2b4c: cacb9d29     	eor	x9, x9, x11, ror #39
    2b50: aa0201a7     	orr	x7, x13, x2
    2b54: 8a070167     	and	x7, x11, x7
    2b58: 8a0201b3     	and	x19, x13, x2
    2b5c: aa1300e7     	orr	x7, x7, x19
    2b60: 8b070129     	add	x9, x9, x7
    2b64: 8b060129     	add	x9, x9, x6
    2b68: 8b0a00c6     	add	x6, x6, x10
    2b6c: 8a26008a     	bic	x10, x4, x6
    2b70: 93c638c7     	ror	x7, x6, #0xe
    2b74: cac648e7     	eor	x7, x7, x6, ror #18
    2b78: cac6a4e7     	eor	x7, x7, x6, ror #41
    2b7c: 8a0600b3     	and	x19, x5, x6
    2b80: aa0a026a     	orr	x10, x19, x10
    2b84: a958d3f3     	ldp	x19, x20, [sp, #0x188]
    2b88: 8b030263     	add	x3, x19, x3
    2b8c: 8b0a006a     	add	x10, x3, x10
    2b90: d2956a63     	mov	x3, #0xab53             ; =43859
    2b94: f2aa2823     	movk	x3, #0x5141, lsl #16
    2b98: f2cd8103     	movk	x3, #0x6c08, lsl #32
    2b9c: f2e3c6e3     	movk	x3, #0x1e37, lsl #48
    2ba0: 8b03014a     	add	x10, x10, x3
    2ba4: 8b070143     	add	x3, x10, x7
    2ba8: 93c9712a     	ror	x10, x9, #0x1c
    2bac: cac9894a     	eor	x10, x10, x9, ror #34
    2bb0: cac99d4a     	eor	x10, x10, x9, ror #39
    2bb4: aa0d0167     	orr	x7, x11, x13
    2bb8: 8a070127     	and	x7, x9, x7
    2bbc: 8a0d0173     	and	x19, x11, x13
    2bc0: aa1300e7     	orr	x7, x7, x19
    2bc4: 8b07014a     	add	x10, x10, x7
    2bc8: 8b03014a     	add	x10, x10, x3
    2bcc: 8b020063     	add	x3, x3, x2
    2bd0: 8a2300a2     	bic	x2, x5, x3
    2bd4: 93c33867     	ror	x7, x3, #0xe
    2bd8: cac348e7     	eor	x7, x7, x3, ror #18
    2bdc: cac3a4e7     	eor	x7, x7, x3, ror #41
    2be0: 8a0300d3     	and	x19, x6, x3
    2be4: aa020262     	orr	x2, x19, x2
    2be8: 8b040284     	add	x4, x20, x4
    2bec: 8b020082     	add	x2, x4, x2
    2bf0: d29d7324     	mov	x4, #0xeb99             ; =60313
    2bf4: f2bbf1c4     	movk	x4, #0xdf8e, lsl #16
    2bf8: f2cee984     	movk	x4, #0x774c, lsl #32
    2bfc: f2e4e904     	movk	x4, #0x2748, lsl #48
    2c00: 8b040042     	add	x2, x2, x4
    2c04: 8b070044     	add	x4, x2, x7
    2c08: 93ca7142     	ror	x2, x10, #0x1c
    2c0c: caca8842     	eor	x2, x2, x10, ror #34
    2c10: caca9c42     	eor	x2, x2, x10, ror #39
    2c14: aa0b0127     	orr	x7, x9, x11
    2c18: 8a070147     	and	x7, x10, x7
    2c1c: 8a0b0133     	and	x19, x9, x11
    2c20: aa1300e7     	orr	x7, x7, x19
    2c24: 8b070042     	add	x2, x2, x7
    2c28: 8b040042     	add	x2, x2, x4
    2c2c: 8b0d0084     	add	x4, x4, x13
    2c30: 8a2400cd     	bic	x13, x6, x4
    2c34: 93c43887     	ror	x7, x4, #0xe
    2c38: cac448e7     	eor	x7, x7, x4, ror #18
    2c3c: cac4a4e7     	eor	x7, x7, x4, ror #41
    2c40: 8a040073     	and	x19, x3, x4
    2c44: aa0d026d     	orr	x13, x19, x13
    2c48: a959d3f3     	ldp	x19, x20, [sp, #0x198]
    2c4c: 8b050265     	add	x5, x19, x5
    2c50: 8b0d00ad     	add	x13, x5, x13
    2c54: d2891505     	mov	x5, #0x48a8             ; =18600
    2c58: f2bc3365     	movk	x5, #0xe19b, lsl #16
    2c5c: f2d796a5     	movk	x5, #0xbcb5, lsl #32
    2c60: f2e69605     	movk	x5, #0x34b0, lsl #48
    2c64: 8b0501ad     	add	x13, x13, x5
    2c68: 8b0701a5     	add	x5, x13, x7
    2c6c: 93c2704d     	ror	x13, x2, #0x1c
    2c70: cac289ad     	eor	x13, x13, x2, ror #34
    2c74: cac29dad     	eor	x13, x13, x2, ror #39
    2c78: aa090147     	orr	x7, x10, x9
    2c7c: 8a070047     	and	x7, x2, x7
    2c80: 8a090153     	and	x19, x10, x9
    2c84: aa1300e7     	orr	x7, x7, x19
    2c88: 8b0701ad     	add	x13, x13, x7
    2c8c: 8b0501ad     	add	x13, x13, x5
    2c90: 8b0b00a5     	add	x5, x5, x11
    2c94: 8a25006b     	bic	x11, x3, x5
    2c98: 93c538a7     	ror	x7, x5, #0xe
    2c9c: cac548e7     	eor	x7, x7, x5, ror #18
    2ca0: cac5a4e7     	eor	x7, x7, x5, ror #41
    2ca4: 8a050093     	and	x19, x4, x5
    2ca8: aa0b026b     	orr	x11, x19, x11
    2cac: 8b060286     	add	x6, x20, x6
    2cb0: 8b0b00cb     	add	x11, x6, x11
    2cb4: d28b4c66     	mov	x6, #0x5a63             ; =23139
    2cb8: f2b8b926     	movk	x6, #0xc5c9, lsl #16
    2cbc: f2c19666     	movk	x6, #0xcb3, lsl #32
    2cc0: f2e72386     	movk	x6, #0x391c, lsl #48
    2cc4: 8b06016b     	add	x11, x11, x6
    2cc8: 8b070166     	add	x6, x11, x7
    2ccc: 93cd71ab     	ror	x11, x13, #0x1c
    2cd0: cacd896b     	eor	x11, x11, x13, ror #34
    2cd4: cacd9d6b     	eor	x11, x11, x13, ror #39
    2cd8: aa0a0047     	orr	x7, x2, x10
    2cdc: 8a0701a7     	and	x7, x13, x7
    2ce0: 8a0a0053     	and	x19, x2, x10
    2ce4: aa1300e7     	orr	x7, x7, x19
    2ce8: 8b07016b     	add	x11, x11, x7
    2cec: 8b06016b     	add	x11, x11, x6
    2cf0: 8b0900c6     	add	x6, x6, x9
    2cf4: 8a260089     	bic	x9, x4, x6
    2cf8: 93c638c7     	ror	x7, x6, #0xe
    2cfc: cac648e7     	eor	x7, x7, x6, ror #18
    2d00: cac6a4e7     	eor	x7, x7, x6, ror #41
    2d04: 8a0600b3     	and	x19, x5, x6
    2d08: aa090269     	orr	x9, x19, x9
    2d0c: a95ad3f3     	ldp	x19, x20, [sp, #0x1a8]
    2d10: 8b030263     	add	x3, x19, x3
    2d14: 8b090069     	add	x9, x3, x9
    2d18: d2915963     	mov	x3, #0x8acb             ; =35531
    2d1c: f2bc6823     	movk	x3, #0xe341, lsl #16
    2d20: f2d54943     	movk	x3, #0xaa4a, lsl #32
    2d24: f2e9db03     	movk	x3, #0x4ed8, lsl #48
    2d28: 8b030129     	add	x9, x9, x3
    2d2c: 8b070123     	add	x3, x9, x7
    2d30: 93cb7169     	ror	x9, x11, #0x1c
    2d34: cacb8929     	eor	x9, x9, x11, ror #34
    2d38: cacb9d29     	eor	x9, x9, x11, ror #39
    2d3c: aa0201a7     	orr	x7, x13, x2
    2d40: 8a070167     	and	x7, x11, x7
    2d44: 8a0201b3     	and	x19, x13, x2
    2d48: aa1300e7     	orr	x7, x7, x19
    2d4c: 8b070129     	add	x9, x9, x7
    2d50: 8b030129     	add	x9, x9, x3
    2d54: 8b0a0063     	add	x3, x3, x10
    2d58: 8a2300aa     	bic	x10, x5, x3
    2d5c: 93c33867     	ror	x7, x3, #0xe
    2d60: cac348e7     	eor	x7, x7, x3, ror #18
    2d64: cac3a4e7     	eor	x7, x7, x3, ror #41
    2d68: 8a0300d3     	and	x19, x6, x3
    2d6c: aa0a026a     	orr	x10, x19, x10
    2d70: 8b040284     	add	x4, x20, x4
    2d74: 8b0a008a     	add	x10, x4, x10
    2d78: d29c6e64     	mov	x4, #0xe373             ; =58227
    2d7c: f2aeec64     	movk	x4, #0x7763, lsl #16
    2d80: f2d949e4     	movk	x4, #0xca4f, lsl #32
    2d84: f2eb7384     	movk	x4, #0x5b9c, lsl #48
    2d88: 8b04014a     	add	x10, x10, x4
    2d8c: 8b070144     	add	x4, x10, x7
    2d90: 93c9712a     	ror	x10, x9, #0x1c
    2d94: cac9894a     	eor	x10, x10, x9, ror #34
    2d98: cac99d4a     	eor	x10, x10, x9, ror #39
    2d9c: aa0d0167     	orr	x7, x11, x13
    2da0: 8a070127     	and	x7, x9, x7
    2da4: 8a0d0173     	and	x19, x11, x13
    2da8: aa1300e7     	orr	x7, x7, x19
    2dac: 8b07014a     	add	x10, x10, x7
    2db0: 8b04014a     	add	x10, x10, x4
    2db4: 8b020084     	add	x4, x4, x2
    2db8: 8a2400c2     	bic	x2, x6, x4
    2dbc: 93c43887     	ror	x7, x4, #0xe
    2dc0: cac448e7     	eor	x7, x7, x4, ror #18
    2dc4: cac4a4e7     	eor	x7, x7, x4, ror #41
    2dc8: 8a040073     	and	x19, x3, x4
    2dcc: aa020262     	orr	x2, x19, x2
    2dd0: a95bd3f3     	ldp	x19, x20, [sp, #0x1b8]
    2dd4: 8b050265     	add	x5, x19, x5
    2dd8: 8b0200a2     	add	x2, x5, x2
    2ddc: d2971465     	mov	x5, #0xb8a3             ; =47267
    2de0: f2bad645     	movk	x5, #0xd6b2, lsl #16
    2de4: f2cdfe65     	movk	x5, #0x6ff3, lsl #32
    2de8: f2ed05c5     	movk	x5, #0x682e, lsl #48
    2dec: 8b050042     	add	x2, x2, x5
    2df0: 8b070045     	add	x5, x2, x7
    2df4: 93ca7142     	ror	x2, x10, #0x1c
    2df8: caca8842     	eor	x2, x2, x10, ror #34
    2dfc: caca9c42     	eor	x2, x2, x10, ror #39
    2e00: aa0b0127     	orr	x7, x9, x11
    2e04: 8a070147     	and	x7, x10, x7
    2e08: 8a0b0133     	and	x19, x9, x11
    2e0c: aa1300e7     	orr	x7, x7, x19
    2e10: 8b070042     	add	x2, x2, x7
    2e14: 8b050042     	add	x2, x2, x5
    2e18: 8b0d00a5     	add	x5, x5, x13
    2e1c: 8a25006d     	bic	x13, x3, x5
    2e20: 93c538a7     	ror	x7, x5, #0xe
    2e24: cac548e7     	eor	x7, x7, x5, ror #18
    2e28: cac5a4e7     	eor	x7, x7, x5, ror #41
    2e2c: 8a050093     	and	x19, x4, x5
    2e30: aa0d026d     	orr	x13, x19, x13
    2e34: 8b060286     	add	x6, x20, x6
    2e38: 8b0d00cd     	add	x13, x6, x13
    2e3c: d2965f86     	mov	x6, #0xb2fc             ; =45820
    2e40: f2abbde6     	movk	x6, #0x5def, lsl #16
    2e44: f2d05dc6     	movk	x6, #0x82ee, lsl #32
    2e48: f2ee91e6     	movk	x6, #0x748f, lsl #48
    2e4c: 8b0601ad     	add	x13, x13, x6
    2e50: 8b0701a6     	add	x6, x13, x7
    2e54: 93c2704d     	ror	x13, x2, #0x1c
    2e58: cac289ad     	eor	x13, x13, x2, ror #34
    2e5c: cac29dad     	eor	x13, x13, x2, ror #39
    2e60: aa090147     	orr	x7, x10, x9
    2e64: 8a070047     	and	x7, x2, x7
    2e68: 8a090153     	and	x19, x10, x9
    2e6c: aa1300e7     	orr	x7, x7, x19
    2e70: 8b0701ad     	add	x13, x13, x7
    2e74: 8b0601ad     	add	x13, x13, x6
    2e78: 8b0b00c6     	add	x6, x6, x11
    2e7c: 8a26008b     	bic	x11, x4, x6
    2e80: 93c638c7     	ror	x7, x6, #0xe
    2e84: cac648e7     	eor	x7, x7, x6, ror #18
    2e88: cac6a4e7     	eor	x7, x7, x6, ror #41
    2e8c: 8a0600b3     	and	x19, x5, x6
    2e90: aa0b026b     	orr	x11, x19, x11
    2e94: a95cd3f3     	ldp	x19, x20, [sp, #0x1c8]
    2e98: 8b030263     	add	x3, x19, x3
    2e9c: 8b0b006b     	add	x11, x3, x11
    2ea0: d285ec03     	mov	x3, #0x2f60             ; =12128
    2ea4: f2a862e3     	movk	x3, #0x4317, lsl #16
    2ea8: f2cc6de3     	movk	x3, #0x636f, lsl #32
    2eac: f2ef14a3     	movk	x3, #0x78a5, lsl #48
    2eb0: 8b03016b     	add	x11, x11, x3
    2eb4: 8b070163     	add	x3, x11, x7
    2eb8: 93cd71ab     	ror	x11, x13, #0x1c
    2ebc: cacd896b     	eor	x11, x11, x13, ror #34
    2ec0: cacd9d6b     	eor	x11, x11, x13, ror #39
    2ec4: aa0a0047     	orr	x7, x2, x10
    2ec8: 8a0701a7     	and	x7, x13, x7
    2ecc: 8a0a0053     	and	x19, x2, x10
    2ed0: aa1300e7     	orr	x7, x7, x19
    2ed4: 8b07016b     	add	x11, x11, x7
    2ed8: 8b03016b     	add	x11, x11, x3
    2edc: 8b090063     	add	x3, x3, x9
    2ee0: 8a2300a9     	bic	x9, x5, x3
    2ee4: 93c33867     	ror	x7, x3, #0xe
    2ee8: cac348e7     	eor	x7, x7, x3, ror #18
    2eec: cac3a4e7     	eor	x7, x7, x3, ror #41
    2ef0: 8a0300d3     	and	x19, x6, x3
    2ef4: aa090269     	orr	x9, x19, x9
    2ef8: 8b040284     	add	x4, x20, x4
    2efc: 8b090089     	add	x9, x4, x9
    2f00: d2956e44     	mov	x4, #0xab72             ; =43890
    2f04: f2b43e04     	movk	x4, #0xa1f0, lsl #16
    2f08: f2cf0284     	movk	x4, #0x7814, lsl #32
    2f0c: f2f09904     	movk	x4, #0x84c8, lsl #48
    2f10: 8b040129     	add	x9, x9, x4
    2f14: 8b070124     	add	x4, x9, x7
    2f18: 93cb7169     	ror	x9, x11, #0x1c
    2f1c: cacb8929     	eor	x9, x9, x11, ror #34
    2f20: cacb9d29     	eor	x9, x9, x11, ror #39
    2f24: aa0201a7     	orr	x7, x13, x2
    2f28: 8a070167     	and	x7, x11, x7
    2f2c: 8a0201b3     	and	x19, x13, x2
    2f30: aa1300e7     	orr	x7, x7, x19
    2f34: 8b070129     	add	x9, x9, x7
    2f38: 8b040129     	add	x9, x9, x4
    2f3c: 8b0a0084     	add	x4, x4, x10
    2f40: 8a2400ca     	bic	x10, x6, x4
    2f44: 93c43887     	ror	x7, x4, #0xe
    2f48: cac448e7     	eor	x7, x7, x4, ror #18
    2f4c: cac4a4e7     	eor	x7, x7, x4, ror #41
    2f50: 8a040073     	and	x19, x3, x4
    2f54: aa0a026a     	orr	x10, x19, x10
    2f58: a95dd3f3     	ldp	x19, x20, [sp, #0x1d8]
    2f5c: 8b050265     	add	x5, x19, x5
    2f60: 8b0a00aa     	add	x10, x5, x10
    2f64: d2873d85     	mov	x5, #0x39ec             ; =14828
    2f68: f2a34c85     	movk	x5, #0x1a64, lsl #16
    2f6c: f2c04105     	movk	x5, #0x208, lsl #32
    2f70: f2f198e5     	movk	x5, #0x8cc7, lsl #48
    2f74: 8b05014a     	add	x10, x10, x5
    2f78: 8b070145     	add	x5, x10, x7
    2f7c: 93c9712a     	ror	x10, x9, #0x1c
    2f80: cac9894a     	eor	x10, x10, x9, ror #34
    2f84: cac99d4a     	eor	x10, x10, x9, ror #39
    2f88: aa0d0167     	orr	x7, x11, x13
    2f8c: 8a070127     	and	x7, x9, x7
    2f90: 8a0d0173     	and	x19, x11, x13
    2f94: aa1300e7     	orr	x7, x7, x19
    2f98: 8b07014a     	add	x10, x10, x7
    2f9c: 8b05014a     	add	x10, x10, x5
    2fa0: 8b0200a5     	add	x5, x5, x2
    2fa4: 8a250062     	bic	x2, x3, x5
    2fa8: 93c538a7     	ror	x7, x5, #0xe
    2fac: cac548e7     	eor	x7, x7, x5, ror #18
    2fb0: cac5a4e7     	eor	x7, x7, x5, ror #41
    2fb4: 8a050093     	and	x19, x4, x5
    2fb8: aa020262     	orr	x2, x19, x2
    2fbc: 8b060286     	add	x6, x20, x6
    2fc0: 8b0200c2     	add	x2, x6, x2
    2fc4: d283c506     	mov	x6, #0x1e28             ; =7720
    2fc8: f2a46c66     	movk	x6, #0x2363, lsl #16
    2fcc: f2dfff46     	movk	x6, #0xfffa, lsl #32
    2fd0: f2f217c6     	movk	x6, #0x90be, lsl #48
    2fd4: 8b060042     	add	x2, x2, x6
    2fd8: 8b070046     	add	x6, x2, x7
    2fdc: 93ca7142     	ror	x2, x10, #0x1c
    2fe0: caca8842     	eor	x2, x2, x10, ror #34
    2fe4: caca9c42     	eor	x2, x2, x10, ror #39
    2fe8: aa0b0127     	orr	x7, x9, x11
    2fec: 8a070147     	and	x7, x10, x7
    2ff0: 8a0b0133     	and	x19, x9, x11
    2ff4: aa1300e7     	orr	x7, x7, x19
    2ff8: 8b070042     	add	x2, x2, x7
    2ffc: 8b060042     	add	x2, x2, x6
    3000: 8b0d00c6     	add	x6, x6, x13
    3004: 8a26008d     	bic	x13, x4, x6
    3008: 93c638c7     	ror	x7, x6, #0xe
    300c: cac648e7     	eor	x7, x7, x6, ror #18
    3010: cac6a4e7     	eor	x7, x7, x6, ror #41
    3014: 8a0600b3     	and	x19, x5, x6
    3018: aa0d026d     	orr	x13, x19, x13
    301c: a95ed3f3     	ldp	x19, x20, [sp, #0x1e8]
    3020: 8b030263     	add	x3, x19, x3
    3024: 8b0d006d     	add	x13, x3, x13
    3028: d297bd23     	mov	x3, #0xbde9             ; =48617
    302c: f2bbd043     	movk	x3, #0xde82, lsl #16
    3030: f2cd9d63     	movk	x3, #0x6ceb, lsl #32
    3034: f2f48a03     	movk	x3, #0xa450, lsl #48
    3038: 8b0301ad     	add	x13, x13, x3
    303c: 8b0701a3     	add	x3, x13, x7
    3040: 93c2704d     	ror	x13, x2, #0x1c
    3044: cac289ad     	eor	x13, x13, x2, ror #34
    3048: cac29dad     	eor	x13, x13, x2, ror #39
    304c: aa090147     	orr	x7, x10, x9
    3050: 8a070047     	and	x7, x2, x7
    3054: 8a090153     	and	x19, x10, x9
    3058: aa1300e7     	orr	x7, x7, x19
    305c: 8b0701ad     	add	x13, x13, x7
    3060: 8b0301ad     	add	x13, x13, x3
    3064: 8b0b0067     	add	x7, x3, x11
    3068: 8a2700ab     	bic	x11, x5, x7
    306c: 93c738e3     	ror	x3, x7, #0xe
    3070: cac74863     	eor	x3, x3, x7, ror #18
    3074: cac7a463     	eor	x3, x3, x7, ror #41
    3078: 8a0700d3     	and	x19, x6, x7
    307c: aa0b026b     	orr	x11, x19, x11
    3080: 8b040284     	add	x4, x20, x4
    3084: 8b0b008b     	add	x11, x4, x11
    3088: d28f22a4     	mov	x4, #0x7915             ; =30997
    308c: f2b658c4     	movk	x4, #0xb2c6, lsl #16
    3090: f2d47ee4     	movk	x4, #0xa3f7, lsl #32
    3094: f2f7df24     	movk	x4, #0xbef9, lsl #48
    3098: 8b04016b     	add	x11, x11, x4
    309c: 8b030163     	add	x3, x11, x3
    30a0: 93cd71ab     	ror	x11, x13, #0x1c
    30a4: cacd896b     	eor	x11, x11, x13, ror #34
    30a8: cacd9d6b     	eor	x11, x11, x13, ror #39
    30ac: aa0a0044     	orr	x4, x2, x10
    30b0: 8a0401a4     	and	x4, x13, x4
    30b4: 8a0a0053     	and	x19, x2, x10
    30b8: aa130084     	orr	x4, x4, x19
    30bc: 8b04016b     	add	x11, x11, x4
    30c0: 8b03016b     	add	x11, x11, x3
    30c4: 8b090064     	add	x4, x3, x9
    30c8: 8a2400c9     	bic	x9, x6, x4
    30cc: 93c43883     	ror	x3, x4, #0xe
    30d0: cac44863     	eor	x3, x3, x4, ror #18
    30d4: cac4a463     	eor	x3, x3, x4, ror #41
    30d8: 8a0400f3     	and	x19, x7, x4
    30dc: aa090269     	orr	x9, x19, x9
    30e0: a95fd3f3     	ldp	x19, x20, [sp, #0x1f8]
    30e4: 8b050265     	add	x5, x19, x5
    30e8: 8b0900a9     	add	x9, x5, x9
    30ec: d28a6565     	mov	x5, #0x532b             ; =21291
    30f0: f2bc6e45     	movk	x5, #0xe372, lsl #16
    30f4: f2cf1e45     	movk	x5, #0x78f2, lsl #32
    30f8: f2f8ce25     	movk	x5, #0xc671, lsl #48
    30fc: 8b050129     	add	x9, x9, x5
    3100: 8b030129     	add	x9, x9, x3
    3104: 93cb7163     	ror	x3, x11, #0x1c
    3108: cacb8863     	eor	x3, x3, x11, ror #34
    310c: cacb9c63     	eor	x3, x3, x11, ror #39
    3110: aa0201a5     	orr	x5, x13, x2
    3114: 8a050165     	and	x5, x11, x5
    3118: 8a0201b3     	and	x19, x13, x2
    311c: aa1300a5     	orr	x5, x5, x19
    3120: 8b050063     	add	x3, x3, x5
    3124: 8b090063     	add	x3, x3, x9
    3128: 8b0a0133     	add	x19, x9, x10
    312c: 8a3300e9     	bic	x9, x7, x19
    3130: 93d33a6a     	ror	x10, x19, #0xe
    3134: 8a130085     	and	x5, x4, x19
    3138: aa0900a9     	orr	x9, x5, x9
    313c: cad3494a     	eor	x10, x10, x19, ror #18
    3140: cad3a54a     	eor	x10, x10, x19, ror #41
    3144: 8b060285     	add	x5, x20, x6
    3148: 8b0900a9     	add	x9, x5, x9
    314c: d28c3385     	mov	x5, #0x619c             ; =24988
    3150: f2bd44c5     	movk	x5, #0xea26, lsl #16
    3154: f2c7d9c5     	movk	x5, #0x3ece, lsl #32
    3158: f2f944e5     	movk	x5, #0xca27, lsl #48
    315c: 8b050129     	add	x9, x9, x5
    3160: 8b0a012a     	add	x10, x9, x10
    3164: 93c37069     	ror	x9, x3, #0x1c
    3168: cac38929     	eor	x9, x9, x3, ror #34
    316c: cac39d29     	eor	x9, x9, x3, ror #39
    3170: aa0d0165     	orr	x5, x11, x13
    3174: 8a050065     	and	x5, x3, x5
    3178: 8a0d0166     	and	x6, x11, x13
    317c: aa0600a5     	orr	x5, x5, x6
    3180: 8b050129     	add	x9, x9, x5
    3184: 8b0a0129     	add	x9, x9, x10
    3188: 8b020142     	add	x2, x10, x2
    318c: 8a22008a     	bic	x10, x4, x2
    3190: 93c23845     	ror	x5, x2, #0xe
    3194: cac248a5     	eor	x5, x5, x2, ror #18
    3198: cac2a4a5     	eor	x5, x5, x2, ror #41
    319c: 8a020266     	and	x6, x19, x2
    31a0: aa0a00ca     	orr	x10, x6, x10
    31a4: f94107e6     	ldr	x6, [sp, #0x208]
    31a8: 8b0700c6     	add	x6, x6, x7
    31ac: 8b0a00ca     	add	x10, x6, x10
    31b0: d29840e6     	mov	x6, #0xc207             ; =49671
    31b4: f2a43806     	movk	x6, #0x21c0, lsl #16
    31b8: f2d718e6     	movk	x6, #0xb8c7, lsl #32
    31bc: f2fa30c6     	movk	x6, #0xd186, lsl #48
    31c0: 8b06014a     	add	x10, x10, x6
    31c4: 8b050145     	add	x5, x10, x5
    31c8: 93c9712a     	ror	x10, x9, #0x1c
    31cc: cac9894a     	eor	x10, x10, x9, ror #34
    31d0: cac99d4a     	eor	x10, x10, x9, ror #39
    31d4: aa0b0066     	orr	x6, x3, x11
    31d8: 8a060126     	and	x6, x9, x6
    31dc: 8a0b0067     	and	x7, x3, x11
    31e0: aa0700c6     	orr	x6, x6, x7
    31e4: 8b06014a     	add	x10, x10, x6
    31e8: 8b05014a     	add	x10, x10, x5
    31ec: 8b0d00a5     	add	x5, x5, x13
    31f0: 8a25026d     	bic	x13, x19, x5
    31f4: 93c538a6     	ror	x6, x5, #0xe
    31f8: cac548c6     	eor	x6, x6, x5, ror #18
    31fc: cac5a4c6     	eor	x6, x6, x5, ror #41
    3200: 8a050047     	and	x7, x2, x5
    3204: aa0d00ed     	orr	x13, x7, x13
    3208: f9410be7     	ldr	x7, [sp, #0x210]
    320c: 8b0400e4     	add	x4, x7, x4
    3210: 8b0d008d     	add	x13, x4, x13
    3214: d29d63c4     	mov	x4, #0xeb1e             ; =60190
    3218: f2b9bc04     	movk	x4, #0xcde0, lsl #16
    321c: f2cfbac4     	movk	x4, #0x7dd6, lsl #32
    3220: f2fd5b44     	movk	x4, #0xeada, lsl #48
    3224: 8b0401ad     	add	x13, x13, x4
    3228: 8b0601a4     	add	x4, x13, x6
    322c: 93ca714d     	ror	x13, x10, #0x1c
    3230: caca89ad     	eor	x13, x13, x10, ror #34
    3234: caca9dad     	eor	x13, x13, x10, ror #39
    3238: aa030126     	orr	x6, x9, x3
    323c: 8a060146     	and	x6, x10, x6
    3240: 8a030127     	and	x7, x9, x3
    3244: aa0700c6     	orr	x6, x6, x7
    3248: 8b0601ad     	add	x13, x13, x6
    324c: 8b0401ad     	add	x13, x13, x4
    3250: 8b0b0084     	add	x4, x4, x11
    3254: 8a24004b     	bic	x11, x2, x4
    3258: 93c43886     	ror	x6, x4, #0xe
    325c: cac448c6     	eor	x6, x6, x4, ror #18
    3260: cac4a4c6     	eor	x6, x6, x4, ror #41
    3264: 8a0400a7     	and	x7, x5, x4
    3268: aa0b00eb     	orr	x11, x7, x11
    326c: f9410fe7     	ldr	x7, [sp, #0x218]
    3270: 8b1300e7     	add	x7, x7, x19
    3274: 8b0b00eb     	add	x11, x7, x11
    3278: d29a2f07     	mov	x7, #0xd178             ; =53624
    327c: f2bdcdc7     	movk	x7, #0xee6e, lsl #16
    3280: f2c9efe7     	movk	x7, #0x4f7f, lsl #32
    3284: f2feafa7     	movk	x7, #0xf57d, lsl #48
    3288: 8b07016b     	add	x11, x11, x7
    328c: 8b060166     	add	x6, x11, x6
    3290: 93cd71ab     	ror	x11, x13, #0x1c
    3294: cacd896b     	eor	x11, x11, x13, ror #34
    3298: cacd9d6b     	eor	x11, x11, x13, ror #39
    329c: aa090147     	orr	x7, x10, x9
    32a0: 8a0701a7     	and	x7, x13, x7
    32a4: 8a090153     	and	x19, x10, x9
    32a8: aa1300e7     	orr	x7, x7, x19
    32ac: 8b07016b     	add	x11, x11, x7
    32b0: 8b06016b     	add	x11, x11, x6
    32b4: 8b0300c3     	add	x3, x6, x3
    32b8: 8a2300a6     	bic	x6, x5, x3
    32bc: 93c33867     	ror	x7, x3, #0xe
    32c0: cac348e7     	eor	x7, x7, x3, ror #18
    32c4: cac3a4e7     	eor	x7, x7, x3, ror #41
    32c8: 8a030093     	and	x19, x4, x3
    32cc: aa060266     	orr	x6, x19, x6
    32d0: f94113f3     	ldr	x19, [sp, #0x220]
    32d4: 8b020262     	add	x2, x19, x2
    32d8: 8b060042     	add	x2, x2, x6
    32dc: d28df746     	mov	x6, #0x6fba             ; =28602
    32e0: f2ae42e6     	movk	x6, #0x7217, lsl #16
    32e4: f2ccf546     	movk	x6, #0x67aa, lsl #32
    32e8: f2e0de06     	movk	x6, #0x6f0, lsl #48
    32ec: 8b060042     	add	x2, x2, x6
    32f0: 8b070046     	add	x6, x2, x7
    32f4: 93cb7162     	ror	x2, x11, #0x1c
    32f8: cacb8842     	eor	x2, x2, x11, ror #34
    32fc: cacb9c42     	eor	x2, x2, x11, ror #39
    3300: aa0a01a7     	orr	x7, x13, x10
    3304: 8a070167     	and	x7, x11, x7
    3308: 8a0a01b3     	and	x19, x13, x10
    330c: aa1300e7     	orr	x7, x7, x19
    3310: 8b070042     	add	x2, x2, x7
    3314: 8b060042     	add	x2, x2, x6
    3318: 8b0900c6     	add	x6, x6, x9
    331c: 8a260089     	bic	x9, x4, x6
    3320: 93c638c7     	ror	x7, x6, #0xe
    3324: cac648e7     	eor	x7, x7, x6, ror #18
    3328: cac6a4e7     	eor	x7, x7, x6, ror #41
    332c: 8a060073     	and	x19, x3, x6
    3330: aa090269     	orr	x9, x19, x9
    3334: f94117f3     	ldr	x19, [sp, #0x228]
    3338: 8b050265     	add	x5, x19, x5
    333c: 8b0900a9     	add	x9, x5, x9
    3340: d29314c5     	mov	x5, #0x98a6             ; =39078
    3344: f2b45905     	movk	x5, #0xa2c8, lsl #16
    3348: f2cfb8a5     	movk	x5, #0x7dc5, lsl #32
    334c: f2e14c65     	movk	x5, #0xa63, lsl #48
    3350: 8b050129     	add	x9, x9, x5
    3354: 8b070125     	add	x5, x9, x7
    3358: 93c27049     	ror	x9, x2, #0x1c
    335c: cac28929     	eor	x9, x9, x2, ror #34
    3360: cac29d29     	eor	x9, x9, x2, ror #39
    3364: aa0d0167     	orr	x7, x11, x13
    3368: 8a070047     	and	x7, x2, x7
    336c: 8a0d0173     	and	x19, x11, x13
    3370: aa1300e7     	orr	x7, x7, x19
    3374: 8b070129     	add	x9, x9, x7
    3378: 8b050129     	add	x9, x9, x5
    337c: 8b0a00a5     	add	x5, x5, x10
    3380: 8a25006a     	bic	x10, x3, x5
    3384: 93c538a7     	ror	x7, x5, #0xe
    3388: cac548e7     	eor	x7, x7, x5, ror #18
    338c: cac5a4e7     	eor	x7, x7, x5, ror #41
    3390: 8a0500d3     	and	x19, x6, x5
    3394: aa0a026a     	orr	x10, x19, x10
    3398: f9411bf3     	ldr	x19, [sp, #0x230]
    339c: 8b040264     	add	x4, x19, x4
    33a0: 8b0a008a     	add	x10, x4, x10
    33a4: d281b5c4     	mov	x4, #0xdae              ; =3502
    33a8: f2b7df24     	movk	x4, #0xbef9, lsl #16
    33ac: f2d30084     	movk	x4, #0x9804, lsl #32
    33b0: f2e227e4     	movk	x4, #0x113f, lsl #48
    33b4: 8b04014a     	add	x10, x10, x4
    33b8: 8b070144     	add	x4, x10, x7
    33bc: 93c9712a     	ror	x10, x9, #0x1c
    33c0: cac9894a     	eor	x10, x10, x9, ror #34
    33c4: cac99d4a     	eor	x10, x10, x9, ror #39
    33c8: aa0b0047     	orr	x7, x2, x11
    33cc: 8a070127     	and	x7, x9, x7
    33d0: 8a0b0053     	and	x19, x2, x11
    33d4: aa1300e7     	orr	x7, x7, x19
    33d8: 8b07014a     	add	x10, x10, x7
    33dc: 8b04014a     	add	x10, x10, x4
    33e0: 8b0d0084     	add	x4, x4, x13
    33e4: 8a2400cd     	bic	x13, x6, x4
    33e8: 93c43887     	ror	x7, x4, #0xe
    33ec: cac448e7     	eor	x7, x7, x4, ror #18
    33f0: cac4a4e7     	eor	x7, x7, x4, ror #41
    33f4: 8a0400b3     	and	x19, x5, x4
    33f8: aa0d026d     	orr	x13, x19, x13
    33fc: f9411ff3     	ldr	x19, [sp, #0x238]
    3400: 8b030263     	add	x3, x19, x3
    3404: 8b0d006d     	add	x13, x3, x13
    3408: d288e363     	mov	x3, #0x471b             ; =18203
    340c: f2a26383     	movk	x3, #0x131c, lsl #16
    3410: f2c166a3     	movk	x3, #0xb35, lsl #32
    3414: f2e36e23     	movk	x3, #0x1b71, lsl #48
    3418: 8b0301ad     	add	x13, x13, x3
    341c: 8b0701a3     	add	x3, x13, x7
    3420: 93ca714d     	ror	x13, x10, #0x1c
    3424: caca89ad     	eor	x13, x13, x10, ror #34
    3428: caca9dad     	eor	x13, x13, x10, ror #39
    342c: aa020127     	orr	x7, x9, x2
    3430: 8a070147     	and	x7, x10, x7
    3434: 8a020133     	and	x19, x9, x2
    3438: aa1300e7     	orr	x7, x7, x19
    343c: 8b0701ad     	add	x13, x13, x7
    3440: 8b0301ad     	add	x13, x13, x3
    3444: 8b0b0067     	add	x7, x3, x11
    3448: 8a2700ab     	bic	x11, x5, x7
    344c: 93c738e3     	ror	x3, x7, #0xe
    3450: cac74863     	eor	x3, x3, x7, ror #18
    3454: cac7a463     	eor	x3, x3, x7, ror #41
    3458: 8a070093     	and	x19, x4, x7
    345c: aa0b026b     	orr	x11, x19, x11
    3460: f94123f3     	ldr	x19, [sp, #0x240]
    3464: 8b060266     	add	x6, x19, x6
    3468: 8b0b00cb     	add	x11, x6, x11
    346c: d28fb086     	mov	x6, #0x7d84             ; =32132
    3470: f2a46086     	movk	x6, #0x2304, lsl #16
    3474: f2cefea6     	movk	x6, #0x77f5, lsl #32
    3478: f2e51b66     	movk	x6, #0x28db, lsl #48
    347c: 8b06016b     	add	x11, x11, x6
    3480: 8b030163     	add	x3, x11, x3
    3484: 93cd71ab     	ror	x11, x13, #0x1c
    3488: cacd896b     	eor	x11, x11, x13, ror #34
    348c: cacd9d6b     	eor	x11, x11, x13, ror #39
    3490: aa090146     	orr	x6, x10, x9
    3494: 8a0601a6     	and	x6, x13, x6
    3498: 8a090153     	and	x19, x10, x9
    349c: aa1300c6     	orr	x6, x6, x19
    34a0: 8b06016b     	add	x11, x11, x6
    34a4: 8b03016b     	add	x11, x11, x3
    34a8: 8b020066     	add	x6, x3, x2
    34ac: 8a260082     	bic	x2, x4, x6
    34b0: 93c638c3     	ror	x3, x6, #0xe
    34b4: cac64863     	eor	x3, x3, x6, ror #18
    34b8: cac6a463     	eor	x3, x3, x6, ror #41
    34bc: 8a0600f3     	and	x19, x7, x6
    34c0: aa020262     	orr	x2, x19, x2
    34c4: f94127f3     	ldr	x19, [sp, #0x248]
    34c8: 8b050265     	add	x5, x19, x5
    34cc: 8b0200a2     	add	x2, x5, x2
    34d0: d2849265     	mov	x5, #0x2493             ; =9363
    34d4: f2a818e5     	movk	x5, #0x40c7, lsl #16
    34d8: f2d56f65     	movk	x5, #0xab7b, lsl #32
    34dc: f2e65945     	movk	x5, #0x32ca, lsl #48
    34e0: 8b050042     	add	x2, x2, x5
    34e4: 8b030043     	add	x3, x2, x3
    34e8: 93cb7162     	ror	x2, x11, #0x1c
    34ec: cacb8842     	eor	x2, x2, x11, ror #34
    34f0: cacb9c42     	eor	x2, x2, x11, ror #39
    34f4: aa0a01a5     	orr	x5, x13, x10
    34f8: 8a050165     	and	x5, x11, x5
    34fc: 8a0a01b3     	and	x19, x13, x10
    3500: aa1300a5     	orr	x5, x5, x19
    3504: 8b050042     	add	x2, x2, x5
    3508: 8b030042     	add	x2, x2, x3
    350c: 8b090065     	add	x5, x3, x9
    3510: 8a2500e9     	bic	x9, x7, x5
    3514: 93c538a3     	ror	x3, x5, #0xe
    3518: cac54863     	eor	x3, x3, x5, ror #18
    351c: cac5a463     	eor	x3, x3, x5, ror #41
    3520: 8a0500d3     	and	x19, x6, x5
    3524: aa090269     	orr	x9, x19, x9
    3528: f9412bf3     	ldr	x19, [sp, #0x250]
    352c: 8b040264     	add	x4, x19, x4
    3530: 8b090089     	add	x9, x4, x9
    3534: d297d784     	mov	x4, #0xbebc             ; =48828
    3538: f2a2b924     	movk	x4, #0x15c9, lsl #16
    353c: f2d7c144     	movk	x4, #0xbe0a, lsl #32
    3540: f2e793c4     	movk	x4, #0x3c9e, lsl #48
    3544: 8b040129     	add	x9, x9, x4
    3548: 8b030129     	add	x9, x9, x3
    354c: 93c27043     	ror	x3, x2, #0x1c
    3550: cac28863     	eor	x3, x3, x2, ror #34
    3554: cac29c63     	eor	x3, x3, x2, ror #39
    3558: aa0d0164     	orr	x4, x11, x13
    355c: 8a040044     	and	x4, x2, x4
    3560: 8a0d0173     	and	x19, x11, x13
    3564: aa130084     	orr	x4, x4, x19
    3568: 8b040063     	add	x3, x3, x4
    356c: 8b090063     	add	x3, x3, x9
    3570: 8b0a0124     	add	x4, x9, x10
    3574: 8a2400c9     	bic	x9, x6, x4
    3578: 93c4388a     	ror	x10, x4, #0xe
    357c: cac4494a     	eor	x10, x10, x4, ror #18
    3580: cac4a54a     	eor	x10, x10, x4, ror #41
    3584: 8a0400b3     	and	x19, x5, x4
    3588: aa090269     	orr	x9, x19, x9
    358c: f9412ff3     	ldr	x19, [sp, #0x258]
    3590: 8b070267     	add	x7, x19, x7
    3594: 8b0900e9     	add	x9, x7, x9
    3598: d281a987     	mov	x7, #0xd4c              ; =3404
    359c: f2b38207     	movk	x7, #0x9c10, lsl #16
    35a0: f2ccf887     	movk	x7, #0x67c4, lsl #32
    35a4: f2e863a7     	movk	x7, #0x431d, lsl #48
    35a8: 8b070129     	add	x9, x9, x7
    35ac: 8b0a012a     	add	x10, x9, x10
    35b0: 93c37069     	ror	x9, x3, #0x1c
    35b4: cac38929     	eor	x9, x9, x3, ror #34
    35b8: cac39d29     	eor	x9, x9, x3, ror #39
    35bc: aa0b0047     	orr	x7, x2, x11
    35c0: 8a070067     	and	x7, x3, x7
    35c4: 8a0b0053     	and	x19, x2, x11
    35c8: aa1300e7     	orr	x7, x7, x19
    35cc: 8b070129     	add	x9, x9, x7
    35d0: 8b0a0129     	add	x9, x9, x10
    35d4: 8b0d014d     	add	x13, x10, x13
    35d8: 8a2d00aa     	bic	x10, x5, x13
    35dc: 93cd39a7     	ror	x7, x13, #0xe
    35e0: cacd48e7     	eor	x7, x7, x13, ror #18
    35e4: cacda4e7     	eor	x7, x7, x13, ror #41
    35e8: 8a0d0093     	and	x19, x4, x13
    35ec: aa0a026a     	orr	x10, x19, x10
    35f0: f94133f3     	ldr	x19, [sp, #0x260]
    35f4: 8b060266     	add	x6, x19, x6
    35f8: 8b0a00ca     	add	x10, x6, x10
    35fc: d28856c6     	mov	x6, #0x42b6             ; =17078
    3600: f2b967c6     	movk	x6, #0xcb3e, lsl #16
    3604: f2da97c6     	movk	x6, #0xd4be, lsl #32
    3608: f2e998a6     	movk	x6, #0x4cc5, lsl #48
    360c: 8b06014a     	add	x10, x10, x6
    3610: 8b07014a     	add	x10, x10, x7
    3614: 93c97126     	ror	x6, x9, #0x1c
    3618: cac988c6     	eor	x6, x6, x9, ror #34
    361c: cac99cc6     	eor	x6, x6, x9, ror #39
    3620: aa020067     	orr	x7, x3, x2
    3624: 8a070127     	and	x7, x9, x7
    3628: 8a020073     	and	x19, x3, x2
    362c: aa1300e7     	orr	x7, x7, x19
    3630: 8b0700c6     	add	x6, x6, x7
    3634: 8b0a00c6     	add	x6, x6, x10
    3638: 8b0b014a     	add	x10, x10, x11
    363c: 8a2a008b     	bic	x11, x4, x10
    3640: 93ca3947     	ror	x7, x10, #0xe
    3644: caca48e7     	eor	x7, x7, x10, ror #18
    3648: cacaa4e7     	eor	x7, x7, x10, ror #41
    364c: 8a0a01b3     	and	x19, x13, x10
    3650: aa0b026b     	orr	x11, x19, x11
    3654: f94137f3     	ldr	x19, [sp, #0x268]
    3658: 8b050265     	add	x5, x19, x5
    365c: 8b0b00ab     	add	x11, x5, x11
    3660: d28fc545     	mov	x5, #0x7e2a             ; =32298
    3664: f2bf8ca5     	movk	x5, #0xfc65, lsl #16
    3668: f2c53385     	movk	x5, #0x299c, lsl #32
    366c: f2eb2fe5     	movk	x5, #0x597f, lsl #48
    3670: 8b05016b     	add	x11, x11, x5
    3674: 8b07016b     	add	x11, x11, x7
    3678: 93c670c5     	ror	x5, x6, #0x1c
    367c: cac688a5     	eor	x5, x5, x6, ror #34
    3680: cac69ca5     	eor	x5, x5, x6, ror #39
    3684: aa030127     	orr	x7, x9, x3
    3688: 8a0700c7     	and	x7, x6, x7
    368c: 8a030133     	and	x19, x9, x3
    3690: aa1300e7     	orr	x7, x7, x19
    3694: 8b0700a5     	add	x5, x5, x7
    3698: 8b0b00a5     	add	x5, x5, x11
    369c: 8b02016b     	add	x11, x11, x2
    36a0: 8a2b01a2     	bic	x2, x13, x11
    36a4: 93cb3967     	ror	x7, x11, #0xe
    36a8: cacb48e7     	eor	x7, x7, x11, ror #18
    36ac: cacba4e7     	eor	x7, x7, x11, ror #41
    36b0: 8a0b0153     	and	x19, x10, x11
    36b4: aa020262     	orr	x2, x19, x2
    36b8: f9413bf3     	ldr	x19, [sp, #0x270]
    36bc: 8b040264     	add	x4, x19, x4
    36c0: 8b020082     	add	x2, x4, x2
    36c4: d29f5d84     	mov	x4, #0xfaec             ; =64236
    36c8: f2a75ac4     	movk	x4, #0x3ad6, lsl #16
    36cc: f2cdf564     	movk	x4, #0x6fab, lsl #32
    36d0: f2ebf964     	movk	x4, #0x5fcb, lsl #48
    36d4: 8b040042     	add	x2, x2, x4
    36d8: 8b070042     	add	x2, x2, x7
    36dc: 93c570a4     	ror	x4, x5, #0x1c
    36e0: cac58884     	eor	x4, x4, x5, ror #34
    36e4: cac59c84     	eor	x4, x4, x5, ror #39
    36e8: aa0900c7     	orr	x7, x6, x9
    36ec: 8a0700a7     	and	x7, x5, x7
    36f0: 8a0900d3     	and	x19, x6, x9
    36f4: aa1300e7     	orr	x7, x7, x19
    36f8: 8b070084     	add	x4, x4, x7
    36fc: 8b020084     	add	x4, x4, x2
    3700: 8b030042     	add	x2, x2, x3
    3704: 8a220143     	bic	x3, x10, x2
    3708: 93c23847     	ror	x7, x2, #0xe
    370c: cac248e7     	eor	x7, x7, x2, ror #18
    3710: cac2a4e7     	eor	x7, x7, x2, ror #41
    3714: 8a020173     	and	x19, x11, x2
    3718: aa030263     	orr	x3, x19, x3
    371c: f9413ff3     	ldr	x19, [sp, #0x278]
    3720: 8b0d026d     	add	x13, x19, x13
    3724: 8b0301ad     	add	x13, x13, x3
    3728: d28b02e3     	mov	x3, #0x5817             ; =22551
    372c: f2a948e3     	movk	x3, #0x4a47, lsl #16
    3730: f2c33183     	movk	x3, #0x198c, lsl #32
    3734: f2ed8883     	movk	x3, #0x6c44, lsl #48
    3738: 8b0301ad     	add	x13, x13, x3
    373c: 8b0701ad     	add	x13, x13, x7
    3740: aa0600a3     	orr	x3, x5, x6
    3744: 8a030083     	and	x3, x4, x3
    3748: 8a0600a7     	and	x7, x5, x6
    374c: aa070063     	orr	x3, x3, x7
    3750: 93c47087     	ror	x7, x4, #0x1c
    3754: cac488e7     	eor	x7, x7, x4, ror #34
    3758: cac49ce7     	eor	x7, x7, x4, ror #39
    375c: 8b0300e3     	add	x3, x7, x3
    3760: 8b0d0063     	add	x3, x3, x13
    3764: 8b030108     	add	x8, x8, x3
    3768: 8b04018c     	add	x12, x12, x4
    376c: a9013008     	stp	x8, x12, [x0, #0x10]
    3770: 8b050028     	add	x8, x1, x5
    3774: 8b0601cc     	add	x12, x14, x6
    3778: a9023008     	stp	x8, x12, [x0, #0x20]
    377c: 8b090208     	add	x8, x16, x9
    3780: 8b0d0108     	add	x8, x8, x13
    3784: 8b0201e9     	add	x9, x15, x2
    3788: a9032408     	stp	x8, x9, [x0, #0x30]
    378c: 8b0b0228     	add	x8, x17, x11
    3790: f9402409     	ldr	x9, [x0, #0x48]
    3794: 8b0a0129     	add	x9, x9, x10
    3798: a9042408     	stp	x8, x9, [x0, #0x40]
    379c: 910a03ff     	add	sp, sp, #0x280
    37a0: a9427bfd     	ldp	x29, x30, [sp, #0x20]
    37a4: a9414ff4     	ldp	x20, x19, [sp, #0x10]
    37a8: a8c36ffc     	ldp	x28, x27, [sp], #0x30
    37ac: d65f03c0     	ret

00000000000037b0 <_audit_master384>:
    37b0: d10643ff     	sub	sp, sp, #0x190
    37b4: a9174ff4     	stp	x20, x19, [sp, #0x170]
    37b8: a9187bfd     	stp	x29, x30, [sp, #0x180]
    37bc: 910603fd     	add	x29, sp, #0x180
    37c0: aa0103f3     	mov	x19, x1
    37c4: aa0003e4     	mov	x4, x0
    37c8: 90000008     	adrp	x8, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1814>
		00000000000037c8:  ARM64_RELOC_PAGE21	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    37cc: 91000108     	add	x8, x8, #0x0
		00000000000037cc:  ARM64_RELOC_PAGEOFF12	_hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).empty_hash
    37d0: ad400500     	ldp	q0, q1, [x8]
    37d4: 3c8713e0     	stur	q0, [sp, #0x71]
    37d8: 52860009     	mov	w9, #0x3000             ; =12288
    37dc: 7900c3e9     	strh	w9, [sp, #0x60]
    37e0: 528001a9     	mov	w9, #0xd                ; =13
    37e4: 39018be9     	strb	w9, [sp, #0x62]
    37e8: 90000009     	adrp	x9, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1814>
		00000000000037e8:  ARM64_RELOC_PAGE21	l___unnamed_1
    37ec: 91000129     	add	x9, x9, #0x0
		00000000000037ec:  ARM64_RELOC_PAGEOFF12	l___unnamed_1
    37f0: f940012a     	ldr	x10, [x9]
    37f4: f80633ea     	stur	x10, [sp, #0x63]
    37f8: 910183ea     	add	x10, sp, #0x60
    37fc: f8405129     	ldur	x9, [x9, #0x5]
    3800: f90037e9     	str	x9, [sp, #0x68]
    3804: 52800609     	mov	w9, #0x30               ; =48
    3808: 3901c3e9     	strb	w9, [sp, #0x70]
    380c: 3c821141     	stur	q1, [x10, #0x21]
    3810: 3dc00900     	ldr	q0, [x8, #0x20]
    3814: 3c831140     	stur	q0, [x10, #0x31]
    3818: 9100c3e0     	add	x0, sp, #0x30
    381c: 910183e2     	add	x2, sp, #0x60
    3820: 52800601     	mov	w1, #0x30               ; =48
    3824: 52800823     	mov	w3, #0x41               ; =65
<L0>:
    3828: 94000000     	bl	 <L0>
		0000000000003828:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
    382c: 90000002     	adrp	x2, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1814>
		000000000000382c:  ARM64_RELOC_PAGE21	_memx.Array(48).zero
    3830: 91000042     	add	x2, x2, #0x0
		0000000000003830:  ARM64_RELOC_PAGEOFF12	_memx.Array(48).zero
    3834: 910003e0     	mov	x0, sp
    3838: 9100c3e1     	add	x1, sp, #0x30
<L1>:
    383c: 94000000     	bl	 <L1>
		000000000000383c:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
    3840: ad4007e0     	ldp	q0, q1, [sp]
    3844: ad000660     	stp	q0, q1, [x19]
    3848: 3dc00be0     	ldr	q0, [sp, #0x20]
    384c: 3d800a60     	str	q0, [x19, #0x20]
    3850: a9587bfd     	ldp	x29, x30, [sp, #0x180]
    3854: a9574ff4     	ldp	x20, x19, [sp, #0x170]
    3858: 910643ff     	add	sp, sp, #0x190
    385c: d65f03c0     	ret

0000000000003860 <_audit_key384>:
    3860: d104c3ff     	sub	sp, sp, #0x130
    3864: a9116ffc     	stp	x28, x27, [sp, #0x110]
    3868: a9127bfd     	stp	x29, x30, [sp, #0x120]
    386c: 910483fd     	add	x29, sp, #0x120
    3870: aa0003e4     	mov	x4, x0
    3874: 52840008     	mov	w8, #0x2000             ; =8192
    3878: 79000be8     	strh	w8, [sp, #0x4]
    387c: 52800128     	mov	w8, #0x9                ; =9
    3880: 39001be8     	strb	w8, [sp, #0x6]
    3884: 52800f28     	mov	w8, #0x79               ; =121
    3888: 7800f3e8     	sturh	w8, [sp, #0xf]
    388c: 90000008     	adrp	x8, 0x3000 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round+0x1814>
		000000000000388c:  ARM64_RELOC_PAGE21	l___unnamed_3
    3890: 91000108     	add	x8, x8, #0x0
		0000000000003890:  ARM64_RELOC_PAGEOFF12	l___unnamed_3
    3894: f9400108     	ldr	x8, [x8]
    3898: f80073e8     	stur	x8, [sp, #0x7]
    389c: 910013e2     	add	x2, sp, #0x4
    38a0: aa0103e0     	mov	x0, x1
    38a4: 52800401     	mov	w1, #0x20               ; =32
    38a8: 528001a3     	mov	w3, #0xd                ; =13
<L0>:
    38ac: 94000000     	bl	 <L0>
		00000000000038ac:  ARM64_RELOC_BRANCH26	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
    38b0: a9527bfd     	ldp	x29, x30, [sp, #0x120]
    38b4: a9516ffc     	ldp	x28, x27, [sp, #0x110]
    38b8: 9104c3ff     	add	sp, sp, #0x130
    38bc: d65f03c0     	ret
