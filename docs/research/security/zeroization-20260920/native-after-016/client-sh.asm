
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010e6164 <ClientHandshake.processServerHello>:
 10e6164: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 10e6168: a90167fc     	stp	x28, x25, [sp, #0x10]
 10e616c: a9025ff8     	stp	x24, x23, [sp, #0x20]
 10e6170: a90357f6     	stp	x22, x21, [sp, #0x30]
 10e6174: a9044ff4     	stp	x20, x19, [sp, #0x40]
 10e6178: 910003fd     	mov	x29, sp
 10e617c: d12203ff     	sub	sp, sp, #0x880
 10e6180: 3974e408     	ldrb	w8, [x0, #0xd39]
 10e6184: aa0203f4     	mov	x20, x2
 10e6188: aa0003f3     	mov	x19, x0
 10e618c: aa0103f5     	mov	x21, x1
 10e6190: 91346402     	add	x2, x0, #0xd19
 10e6194: 910003e4     	mov	x4, sp
 10e6198: 92401503     	and	x3, x8, #0x3f
 10e619c: aa0103e0     	mov	x0, x1
 10e61a0: aa1403e1     	mov	x1, x20
 10e61a4: 97ffe4f7     	bl	 <server_hello.parseWithSessionIdEcho>
 10e61a8: 72003c00     	ands	w0, w0, #0xffff
 10e61ac: 54000881     	b.ne	 <L10>
 10e61b0: 39557268     	ldrb	w8, [x19, #0x55c]
 10e61b4: 92400d08     	and	x8, x8, #0xf
 10e61b8: 34000148     	cbz	w8,  <L1>
 10e61bc: 794003f7     	ldrh	w23, [sp]
 10e61c0: d10303b6     	sub	x22, x29, #0xc0
 10e61c4: 5280a989     	mov	w9, #0x54c              // =1356
<L0>:
 10e61c8: 78696a6a     	ldrh	w10, [x19, x9]
 10e61cc: 6b17015f     	cmp	w10, w23
 10e61d0: 540000c0     	b.eq	 <L2>
 10e61d4: f1000508     	subs	x8, x8, #0x1
 10e61d8: 91000929     	add	x9, x9, #0x2
 10e61dc: 54ffff61     	b.ne	 <L0>
<L1>:
 10e61e0: 528005c0     	mov	w0, #0x2e               // =46
 10e61e4: 14000036     	b	 <L10>
<L2>:
 10e61e8: 395a23f8     	ldrb	w24, [sp, #0x688]
 10e61ec: 12000708     	and	w8, w24, #0x3
 10e61f0: 7100051f     	cmp	w8, #0x1
 10e61f4: 540000ac     	b.gt	 <L4>
 10e61f8: 35000288     	cbnz	w8,  <L7>
<L3>:
 10e61fc: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e6200: 912e6108     	add	x8, x8, #0xb98
 10e6204: 14000013     	b	 <L8>
<L4>:
 10e6208: 7100091f     	cmp	w8, #0x2
 10e620c: 54000081     	b.ne	 <L6>
<L5>:
 10e6210: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e6214: 912e8108     	add	x8, x8, #0xba0
 10e6218: 1400000e     	b	 <L8>
<L6>:
 10e621c: 794007e8     	ldrh	w8, [sp, #0x2]
 10e6220: 52823d49     	mov	w9, #0x11ea             // =4586
 10e6224: 6b09011f     	cmp	w8, w9
 10e6228: 5400058c     	b.gt	 <L11>
 10e622c: 71005d1f     	cmp	w8, #0x17
 10e6230: 540000c0     	b.eq	 <L7>
 10e6234: 7100611f     	cmp	w8, #0x18
 10e6238: 54fffec0     	b.eq	 <L5>
 10e623c: 7100751f     	cmp	w8, #0x1d
 10e6240: 54fffde0     	b.eq	 <L3>
 10e6244: 14000059     	b	 <L17>
<L7>:
 10e6248: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e624c: 912e7108     	add	x8, x8, #0xb9c
<L8>:
 10e6250: 79400108     	ldrh	w8, [x8]
 10e6254: 7104011f     	cmp	w8, #0x100
 10e6258: 54000303     	b.lo	 <L9>
 10e625c: 39758a69     	ldrb	w9, [x19, #0xd62]
 10e6260: 92400908     	and	x8, x8, #0x7
 10e6264: 12001529     	and	w9, w9, #0x3f
 10e6268: 1ac82528     	lsr	w8, w9, w8
 10e626c: 36000268     	tbz	w8, #0x0,  <L9>
 10e6270: 39552a68     	ldrb	w8, [x19, #0x54a]
 10e6274: 340004a8     	cbz	w8,  <L12>
 10e6278: 39484268     	ldrb	w8, [x19, #0x210]
 10e627c: 52800e09     	mov	w9, #0x70               // =112
 10e6280: 12000508     	and	w8, w8, #0x3
 10e6284: 7100051f     	cmp	w8, #0x1
 10e6288: 52801c08     	mov	w8, #0xe0               // =224
 10e628c: 9a880128     	csel	x8, x9, x8, eq
 10e6290: 78686a68     	ldrh	w8, [x19, x8]
 10e6294: 6b0802ff     	cmp	w23, w8
 10e6298: 54000c61     	b.ne	 <L23>
 10e629c: 12000709     	and	w9, w24, #0x3
 10e62a0: 794a9268     	ldrh	w8, [x19, #0x548]
 10e62a4: 7100053f     	cmp	w9, #0x1
 10e62a8: 5400072c     	b.gt	 <L15>
 10e62ac: 350008a9     	cbnz	w9,  <L19>
 10e62b0: 528003a9     	mov	w9, #0x1d               // =29
 10e62b4: 14000046     	b	 <L21>
<L9>:
 10e62b8: 52801da0     	mov	w0, #0xed               // =237
<L10>:
 10e62bc: 912203ff     	add	sp, sp, #0x880
 10e62c0: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 10e62c4: a94357f6     	ldp	x22, x21, [sp, #0x30]
 10e62c8: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 10e62cc: a94167fc     	ldp	x28, x25, [sp, #0x10]
 10e62d0: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 10e62d4: d65f03c0     	ret
<L11>:
 10e62d8: 52823d69     	mov	w9, #0x11eb             // =4587
 10e62dc: 6b09011f     	cmp	w8, w9
 10e62e0: 540005e0     	b.eq	 <L16>
 10e62e4: 52823d89     	mov	w9, #0x11ec             // =4588
 10e62e8: 6b09011f     	cmp	w8, w9
 10e62ec: 54000640     	b.eq	 <L18>
 10e62f0: 52823da9     	mov	w9, #0x11ed             // =4589
 10e62f4: 6b09011f     	cmp	w8, w9
 10e62f8: 54000581     	b.ne	 <L17>
 10e62fc: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e6300: 912eb108     	add	x8, x8, #0xbac
 10e6304: 17ffffd3     	b	 <L8>
<L12>:
 10e6308: 52826048     	mov	w8, #0x1302             // =4866
 10e630c: 6b0802ff     	cmp	w23, w8
 10e6310: 540002e1     	b.ne	 <L13>
 10e6314: ad470e60     	ldp	q0, q3, [x19, #0xe0]
 10e6318: 52800048     	mov	w8, #0x2                // =2
 10e631c: ad438a61     	ldp	q1, q2, [x19, #0x70]
 10e6320: 52826049     	mov	w9, #0x1302             // =4866
 10e6324: ad449a65     	ldp	q5, q6, [x19, #0x90]
 10e6328: 52801c0a     	mov	w10, #0xe0              // =224
 10e632c: ad038e60     	stp	q0, q3, [x19, #0x70]
 10e6330: ad481e60     	ldp	q0, q7, [x19, #0x100]
 10e6334: ad461270     	ldp	q16, q4, [x19, #0xc0]
 10e6338: 3dc02e63     	ldr	q3, [x19, #0xb0]
 10e633c: 39084268     	strb	w8, [x19, #0x210]
 10e6340: 52804048     	mov	w8, #0x202              // =514
 10e6344: ad000a61     	stp	q1, q2, [x19]
 10e6348: ad011a65     	stp	q5, q6, [x19, #0x20]
 10e634c: ad024263     	stp	q3, q16, [x19, #0x40]
 10e6350: ad049e60     	stp	q0, q7, [x19, #0x90]
 10e6354: ad494660     	ldp	q0, q17, [x19, #0x120]
 10e6358: 3d801a64     	str	q4, [x19, #0x60]
 10e635c: ad05c660     	stp	q0, q17, [x19, #0xb0]
 10e6360: 3dc05260     	ldr	q0, [x19, #0x140]
 10e6364: 3d803660     	str	q0, [x19, #0xd0]
 10e6368: 14000006     	b	 <L14>
<L13>:
 10e636c: 52800028     	mov	w8, #0x1                // =1
 10e6370: 52800e0a     	mov	w10, #0x70              // =112
 10e6374: 2a1703e9     	mov	w9, w23
 10e6378: 39084268     	strb	w8, [x19, #0x210]
 10e637c: 52802648     	mov	w8, #0x132              // =306
<L14>:
 10e6380: 782a6a69     	strh	w9, [x19, x10]
 10e6384: 38286a7f     	strb	wzr, [x19, x8]
 10e6388: 14000013     	b	 <L22>
<L15>:
 10e638c: 7100093f     	cmp	w9, #0x2
 10e6390: 540001c1     	b.ne	 <L20>
 10e6394: 52800309     	mov	w9, #0x18               // =24
 10e6398: 1400000d     	b	 <L21>
<L16>:
 10e639c: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e63a0: 912e9108     	add	x8, x8, #0xba4
 10e63a4: 17ffffab     	b	 <L8>
<L17>:
 10e63a8: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e63ac: 912eb908     	add	x8, x8, #0xbae
 10e63b0: 17ffffa8     	b	 <L8>
<L18>:
 10e63b4: b0fff908     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e63b8: 912ea108     	add	x8, x8, #0xba8
 10e63bc: 17ffffa5     	b	 <L8>
<L19>:
 10e63c0: 528002e9     	mov	w9, #0x17               // =23
 10e63c4: 14000002     	b	 <L21>
<L20>:
 10e63c8: 794007e9     	ldrh	w9, [sp, #0x2]
<L21>:
 10e63cc: 6b08013f     	cmp	w9, w8
 10e63d0: 540002a1     	b.ne	 <L23>
<L22>:
 10e63d4: aa1303e0     	mov	x0, x19
 10e63d8: aa1503e1     	mov	x1, x21
 10e63dc: aa1403e2     	mov	x2, x20
 10e63e0: 910003f9     	mov	x25, sp
 10e63e4: 97fffe8e     	bl	 <ClientHandshake.Suite.update>
 10e63e8: 12000708     	and	w8, w24, #0x3
 10e63ec: 7100051f     	cmp	w8, #0x1
 10e63f0: 540001ec     	b.gt	 <L24>
 10e63f4: 35000408     	cbnz	w8,  <L25>
 10e63f8: 91278e68     	add	x8, x19, #0x9e3
 10e63fc: 911b83e0     	add	x0, sp, #0x6e0
 10e6400: b27f0321     	orr	x1, x25, #0x2
 10e6404: ad400500     	ldp	q0, q1, [x8]
 10e6408: 911a43e2     	add	x2, sp, #0x690
 10e640c: 3d81bbe0     	str	q0, [sp, #0x6e0]
 10e6410: 3d81bfe1     	str	q1, [sp, #0x6f0]
 10e6414: 97fe5699     	bl	 <x25519.sharedSecret>
 10e6418: 72003c1f     	tst	w0, #0xffff
 10e641c: 54000400     	b.eq	 <L26>
 10e6420: 17ffffa7     	b	 <L10>
<L23>:
 10e6424: 52800540     	mov	w0, #0x2a               // =42
 10e6428: 17ffffa5     	b	 <L10>
<L24>:
 10e642c: 7100091f     	cmp	w8, #0x2
 10e6430: 540004c1     	b.ne	 <L29>
 10e6434: 912a1268     	add	x8, x19, #0xa84
 10e6438: 911c83e0     	add	x0, sp, #0x720
 10e643c: b27f0321     	orr	x1, x25, #0x2
 10e6440: ad400500     	ldp	q0, q1, [x8]
 10e6444: 3dc00902     	ldr	q2, [x8, #0x20]
 10e6448: 911a43e2     	add	x2, sp, #0x690
 10e644c: 3d81d3e2     	str	q2, [sp, #0x740]
 10e6450: 3d81cbe0     	str	q0, [sp, #0x720]
 10e6454: 3d81cfe1     	str	q1, [sp, #0x730]
 10e6458: 97fefaaa     	bl	 <p384.sharedSecret>
 10e645c: 72003c1f     	tst	w0, #0xffff
 10e6460: 54fff2e1     	b.ne	 <L10>
 10e6464: 52800614     	mov	w20, #0x30              // =48
 10e6468: 395a33e8     	ldrb	w8, [sp, #0x68c]
 10e646c: 350001e8     	cbnz	w8,  <L27>
 10e6470: 14000033     	b	 <L30>
<L25>:
 10e6474: 91288e68     	add	x8, x19, #0xa23
 10e6478: 911c03e0     	add	x0, sp, #0x700
 10e647c: b27f0321     	orr	x1, x25, #0x2
 10e6480: ad400500     	ldp	q0, q1, [x8]
 10e6484: 911a43e2     	add	x2, sp, #0x690
 10e6488: 3d81c3e0     	str	q0, [sp, #0x700]
 10e648c: 3d81c7e1     	str	q1, [sp, #0x710]
 10e6490: 97fefad7     	bl	 <p256.sharedSecret>
 10e6494: 72003c1f     	tst	w0, #0xffff
 10e6498: 54fff121     	b.ne	 <L10>
<L26>:
 10e649c: 52800414     	mov	w20, #0x20              // =32
 10e64a0: 395a33e8     	ldrb	w8, [sp, #0x68c]
 10e64a4: 340004c8     	cbz	w8,  <L30>
<L27>:
 10e64a8: 794d17e8     	ldrh	w8, [sp, #0x68a]
 10e64ac: 34000908     	cbz	w8,  <L32>
<L28>:
 10e64b0: 911a43e0     	add	x0, sp, #0x690
 10e64b4: 2a1f03e1     	mov	w1, wzr
 10e64b8: aa1403e2     	mov	x2, x20
 10e64bc: 9403f8cd     	bl	 <memset>
 10e64c0: 52800540     	mov	w0, #0x2a               // =42
 10e64c4: 17ffff7e     	b	 <L10>
<L29>:
 10e64c8: 39496268     	ldrb	w8, [x19, #0x258]
 10e64cc: 340009c8     	cbz	w8,  <L33>
 10e64d0: 7944a268     	ldrh	w8, [x19, #0x250]
 10e64d4: 794007e9     	ldrh	w9, [sp, #0x2]
 10e64d8: 6b09011f     	cmp	w8, w9
 10e64dc: 54000941     	b.ne	 <L33>
 10e64e0: 79400be8     	ldrh	w8, [sp, #0x4]
 10e64e4: 910003e9     	mov	x9, sp
 10e64e8: d10363a0     	sub	x0, x29, #0xd8
 10e64ec: 91090261     	add	x1, x19, #0x240
 10e64f0: 91001922     	add	x2, x9, #0x6
 10e64f4: 91278e64     	add	x4, x19, #0x9e3
 10e64f8: 92402903     	and	x3, x8, #0x7ff
 10e64fc: 911d43e5     	add	x5, sp, #0x750
 10e6500: 9400061d     	bl	 <hybrid_kex.decapsulate>
 10e6504: 785383a0     	ldurh	w0, [x29, #-0xc8]
 10e6508: 350009c0     	cbnz	w0,  <L36>
 10e650c: a972d3a1     	ldp	x1, x20, [x29, #-0xd8]
 10e6510: 911a43e0     	add	x0, sp, #0x690
 10e6514: aa1403e2     	mov	x2, x20
 10e6518: 9403f91f     	bl	 <memcpy>
 10e651c: 6f00e400     	movi	v0.2d, #0000000000000000
 10e6520: 3d81d7e0     	str	q0, [sp, #0x750]
 10e6524: 3d81dbe0     	str	q0, [sp, #0x760]
 10e6528: 3d81dfe0     	str	q0, [sp, #0x770]
 10e652c: 3d81e3e0     	str	q0, [sp, #0x780]
 10e6530: 3d81e7e0     	str	q0, [sp, #0x790]
 10e6534: 395a33e8     	ldrb	w8, [sp, #0x68c]
 10e6538: 35fffb88     	cbnz	w8,  <L27>
<L30>:
 10e653c: aa1f03e4     	mov	x4, xzr
 10e6540: aa1f03e5     	mov	x5, xzr
<L31>:
 10e6544: d10303a0     	sub	x0, x29, #0xc0
 10e6548: 911a43e2     	add	x2, sp, #0x690
 10e654c: aa1303e1     	mov	x1, x19
 10e6550: aa1403e3     	mov	x3, x20
 10e6554: 94000215     	bl	 <ClientHandshake.Suite.deriveHandshakeKeys>
 10e6558: 785f03a8     	ldurh	w8, [x29, #-0x10]
 10e655c: 35000648     	cbnz	w8,  <L35>
 10e6560: ad7b07a0     	ldp	q0, q1, [x29, #-0xa0]
 10e6564: 910ae268     	add	x8, x19, #0x2b8
 10e6568: 3cd803a2     	ldur	q2, [x29, #-0x80]
 10e656c: f85903a9     	ldur	x9, [x29, #-0x70]
 10e6570: 911a43e0     	add	x0, sp, #0x690
 10e6574: f85e83aa     	ldur	x10, [x29, #-0x18]
 10e6578: 2a1f03e1     	mov	w1, wzr
 10e657c: aa1403e2     	mov	x2, x20
 10e6580: ad140660     	stp	q0, q1, [x19, #0x280]
 10e6584: ad7a07a0     	ldp	q0, q1, [x29, #-0xc0]
 10e6588: 3d80aa62     	str	q2, [x19, #0x2a0]
 10e658c: 3cc982c2     	ldur	q2, [x22, #0x98]
 10e6590: f9015a69     	str	x9, [x19, #0x2b0]
 10e6594: 52800049     	mov	w9, #0x2                // =2
 10e6598: ad130660     	stp	q0, q1, [x19, #0x260]
 10e659c: 3cc782c0     	ldur	q0, [x22, #0x78]
 10e65a0: 3cc882c1     	ldur	q1, [x22, #0x88]
 10e65a4: 3d801102     	str	q2, [x8, #0x40]
 10e65a8: ad010500     	stp	q0, q1, [x8, #0x20]
 10e65ac: 3cc582c0     	ldur	q0, [x22, #0x58]
 10e65b0: 3cc682c1     	ldur	q1, [x22, #0x68]
 10e65b4: f901866a     	str	x10, [x19, #0x308]
 10e65b8: ad000500     	stp	q0, q1, [x8]
 10e65bc: 3934f269     	strb	w9, [x19, #0xd3c]
 10e65c0: 9403f88c     	bl	 <memset>
 10e65c4: 2a1f03e0     	mov	w0, wzr
 10e65c8: 17ffff3d     	b	 <L10>
<L32>:
 10e65cc: f9411a64     	ldr	x4, [x19, #0x230]
 10e65d0: b40001e4     	cbz	x4,  <L34>
 10e65d4: 79498a68     	ldrh	w8, [x19, #0x4c4]
 10e65d8: 52826049     	mov	w9, #0x1302             // =4866
 10e65dc: 6b09011f     	cmp	w8, w9
 10e65e0: 1a9f17e8     	cset	w8, eq
 10e65e4: 6b0902ff     	cmp	w23, w9
 10e65e8: 1a9f17e9     	cset	w9, eq
 10e65ec: 6b09011f     	cmp	w8, w9
 10e65f0: 54fff601     	b.ne	 <L28>
 10e65f4: f9411e65     	ldr	x5, [x19, #0x238]
 10e65f8: 52800028     	mov	w8, #0x1                // =1
 10e65fc: 3934ea68     	strb	w8, [x19, #0xd3a]
 10e6600: 17ffffd1     	b	 <L31>
<L33>:
 10e6604: 52800b80     	mov	w0, #0x5c               // =92
 10e6608: 17ffff2d     	b	 <L10>
<L34>:
 10e660c: 911a43e0     	add	x0, sp, #0x690
 10e6610: 2a1f03e1     	mov	w1, wzr
 10e6614: aa1403e2     	mov	x2, x20
 10e6618: 9403f876     	bl	 <memset>
 10e661c: 528007c0     	mov	w0, #0x3e               // =62
 10e6620: 17ffff27     	b	 <L10>
<L35>:
 10e6624: 911a43e0     	add	x0, sp, #0x690
 10e6628: 2a1f03e1     	mov	w1, wzr
 10e662c: aa1403e2     	mov	x2, x20
 10e6630: 2a0803f3     	mov	w19, w8
 10e6634: 9403f86f     	bl	 <memset>
 10e6638: 2a1303e0     	mov	w0, w19
 10e663c: 17ffff20     	b	 <L10>
<L36>:
 10e6640: 6f00e400     	movi	v0.2d, #0000000000000000
 10e6644: 3d81e7e0     	str	q0, [sp, #0x790]
 10e6648: 3d81e3e0     	str	q0, [sp, #0x780]
 10e664c: 3d81dfe0     	str	q0, [sp, #0x770]
 10e6650: 3d81dbe0     	str	q0, [sp, #0x760]
 10e6654: 3d81d7e0     	str	q0, [sp, #0x750]
 10e6658: 17ffff19     	b	 <L10>
