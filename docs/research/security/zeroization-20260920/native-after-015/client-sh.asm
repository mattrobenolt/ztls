
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081060 <ClientHandshake.processServerHello>:
 1081060: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 1081064: a90167fc     	stp	x28, x25, [sp, #0x10]
 1081068: a9025ff8     	stp	x24, x23, [sp, #0x20]
 108106c: a90357f6     	stp	x22, x21, [sp, #0x30]
 1081070: a9044ff4     	stp	x20, x19, [sp, #0x40]
 1081074: 910003fd     	mov	x29, sp
 1081078: d12043ff     	sub	sp, sp, #0x810
 108107c: 3974e408     	ldrb	w8, [x0, #0xd39]
 1081080: aa0203f4     	mov	x20, x2
 1081084: aa0003f3     	mov	x19, x0
 1081088: aa0103f5     	mov	x21, x1
 108108c: 91346402     	add	x2, x0, #0xd19
 1081090: 910033e4     	add	x4, sp, #0xc
 1081094: 92401503     	and	x3, x8, #0x3f
 1081098: aa0103e0     	mov	x0, x1
 108109c: aa1403e1     	mov	x1, x20
 10810a0: 94000121     	bl	 <server_hello.parseWithSessionIdEcho>
 10810a4: 72003c1f     	tst	w0, #0xffff
 10810a8: 54000861     	b.ne	 <L10>
 10810ac: 39557268     	ldrb	w8, [x19, #0x55c]
 10810b0: 92400d08     	and	x8, x8, #0xf
 10810b4: 34000168     	cbz	w8,  <L1>
 10810b8: 79401bf8     	ldrh	w24, [sp, #0xc]
 10810bc: d102e3b6     	sub	x22, x29, #0xb8
 10810c0: 911bc3f7     	add	x23, sp, #0x6f0
 10810c4: 5280a989     	mov	w9, #0x54c              // =1356
<L0>:
 10810c8: 78696a6a     	ldrh	w10, [x19, x9]
 10810cc: 6b18015f     	cmp	w10, w24
 10810d0: 540000c0     	b.eq	 <L2>
 10810d4: f1000508     	subs	x8, x8, #0x1
 10810d8: 91000929     	add	x9, x9, #0x2
 10810dc: 54ffff61     	b.ne	 <L0>
<L1>:
 10810e0: 52800ac0     	mov	w0, #0x56               // =86
 10810e4: 14000034     	b	 <L10>
<L2>:
 10810e8: 395a53e8     	ldrb	w8, [sp, #0x694]
 10810ec: 7100051f     	cmp	w8, #0x1
 10810f0: 540000ac     	b.gt	 <L4>
 10810f4: 35000288     	cbnz	w8,  <L7>
<L3>:
 10810f8: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10810fc: 913d2129     	add	x9, x9, #0xf48
 1081100: 14000013     	b	 <L8>
<L4>:
 1081104: 7100091f     	cmp	w8, #0x2
 1081108: 54000081     	b.ne	 <L6>
<L5>:
 108110c: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1081110: 913d4129     	add	x9, x9, #0xf50
 1081114: 1400000e     	b	 <L8>
<L6>:
 1081118: 79401fe9     	ldrh	w9, [sp, #0xe]
 108111c: 52823d4a     	mov	w10, #0x11ea            // =4586
 1081120: 6b0a013f     	cmp	w9, w10
 1081124: 5400056c     	b.gt	 <L11>
 1081128: 71005d3f     	cmp	w9, #0x17
 108112c: 540000c0     	b.eq	 <L7>
 1081130: 7100613f     	cmp	w9, #0x18
 1081134: 54fffec0     	b.eq	 <L5>
 1081138: 7100753f     	cmp	w9, #0x1d
 108113c: 54fffde0     	b.eq	 <L3>
 1081140: 14000057     	b	 <L17>
<L7>:
 1081144: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1081148: 913d3129     	add	x9, x9, #0xf4c
<L8>:
 108114c: 79400129     	ldrh	w9, [x9]
 1081150: 7104013f     	cmp	w9, #0x100
 1081154: 540002e3     	b.lo	 <L9>
 1081158: 39758a6a     	ldrb	w10, [x19, #0xd62]
 108115c: 92400929     	and	x9, x9, #0x7
 1081160: 1200154a     	and	w10, w10, #0x3f
 1081164: 1ac92549     	lsr	w9, w10, w9
 1081168: 36000249     	tbz	w9, #0x0,  <L9>
 108116c: 39552a69     	ldrb	w9, [x19, #0x54a]
 1081170: 34000489     	cbz	w9,  <L12>
 1081174: 39484269     	ldrb	w9, [x19, #0x210]
 1081178: 9101c26a     	add	x10, x19, #0x70
 108117c: 9103826b     	add	x11, x19, #0xe0
 1081180: 12000529     	and	w9, w9, #0x3
 1081184: 7100053f     	cmp	w9, #0x1
 1081188: 9a8b0149     	csel	x9, x10, x11, eq
 108118c: 79400129     	ldrh	w9, [x9]
 1081190: 6b09031f     	cmp	w24, w9
 1081194: 54000be1     	b.ne	 <L23>
 1081198: 794a9269     	ldrh	w9, [x19, #0x548]
 108119c: 7100051f     	cmp	w8, #0x1
 10811a0: 5400070c     	b.gt	 <L15>
 10811a4: 35000888     	cbnz	w8,  <L19>
 10811a8: 528003a8     	mov	w8, #0x1d               // =29
 10811ac: 14000045     	b	 <L21>
<L9>:
 10811b0: 52800aa0     	mov	w0, #0x55               // =85
<L10>:
 10811b4: 912043ff     	add	sp, sp, #0x810
 10811b8: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 10811bc: a94357f6     	ldp	x22, x21, [sp, #0x30]
 10811c0: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 10811c4: a94167fc     	ldp	x28, x25, [sp, #0x10]
 10811c8: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 10811cc: d65f03c0     	ret
<L11>:
 10811d0: 52823d6a     	mov	w10, #0x11eb            // =4587
 10811d4: 6b0a013f     	cmp	w9, w10
 10811d8: 540005c0     	b.eq	 <L16>
 10811dc: 52823d8a     	mov	w10, #0x11ec            // =4588
 10811e0: 6b0a013f     	cmp	w9, w10
 10811e4: 54000620     	b.eq	 <L18>
 10811e8: 52823daa     	mov	w10, #0x11ed            // =4589
 10811ec: 6b0a013f     	cmp	w9, w10
 10811f0: 54000561     	b.ne	 <L17>
 10811f4: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10811f8: 913d7129     	add	x9, x9, #0xf5c
 10811fc: 17ffffd4     	b	 <L8>
<L12>:
 1081200: 52826048     	mov	w8, #0x1302             // =4866
 1081204: 6b08031f     	cmp	w24, w8
 1081208: 540002c1     	b.ne	 <L13>
 108120c: ad478a61     	ldp	q1, q2, [x19, #0xf0]
 1081210: 52800048     	mov	w8, #0x2                // =2
 1081214: ad440e60     	ldp	q0, q3, [x19, #0x80]
 1081218: 52826049     	mov	w9, #0x1302             // =4866
 108121c: ad464266     	ldp	q6, q16, [x19, #0xc0]
 1081220: 52801c0a     	mov	w10, #0xe0              // =224
 1081224: ad040a61     	stp	q1, q2, [x19, #0x80]
 1081228: ad488665     	ldp	q5, q1, [x19, #0x110]
 108122c: ad450a64     	ldp	q4, q2, [x19, #0xa0]
 1081230: 39084268     	strb	w8, [x19, #0x210]
 1081234: 52804048     	mov	w8, #0x202              // =514
 1081238: ad050665     	stp	q5, q1, [x19, #0xa0]
 108123c: 3dc01e65     	ldr	q5, [x19, #0x70]
 1081240: ad498667     	ldp	q7, q1, [x19, #0x130]
 1081244: ad011263     	stp	q3, q4, [x19, #0x20]
 1081248: ad000265     	stp	q5, q0, [x19]
 108124c: 3dc03a60     	ldr	q0, [x19, #0xe0]
 1081250: ad021a62     	stp	q2, q6, [x19, #0x40]
 1081254: ad030270     	stp	q16, q0, [x19, #0x60]
 1081258: ad060667     	stp	q7, q1, [x19, #0xc0]
 108125c: 14000006     	b	 <L14>
<L13>:
 1081260: 52800028     	mov	w8, #0x1                // =1
 1081264: 52800e0a     	mov	w10, #0x70              // =112
 1081268: 2a1803e9     	mov	w9, w24
 108126c: 39084268     	strb	w8, [x19, #0x210]
 1081270: 52802648     	mov	w8, #0x132              // =306
<L14>:
 1081274: 782a6a69     	strh	w9, [x19, x10]
 1081278: 38286a7f     	strb	wzr, [x19, x8]
 108127c: 14000013     	b	 <L22>
<L15>:
 1081280: 7100091f     	cmp	w8, #0x2
 1081284: 540001c1     	b.ne	 <L20>
 1081288: 52800308     	mov	w8, #0x18               // =24
 108128c: 1400000d     	b	 <L21>
<L16>:
 1081290: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1081294: 913d5129     	add	x9, x9, #0xf54
 1081298: 17ffffad     	b	 <L8>
<L17>:
 108129c: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10812a0: 913d7929     	add	x9, x9, #0xf5e
 10812a4: 17ffffaa     	b	 <L8>
<L18>:
 10812a8: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10812ac: 913d6129     	add	x9, x9, #0xf58
 10812b0: 17ffffa7     	b	 <L8>
<L19>:
 10812b4: 528002e8     	mov	w8, #0x17               // =23
 10812b8: 14000002     	b	 <L21>
<L20>:
 10812bc: 79401fe8     	ldrh	w8, [sp, #0xe]
<L21>:
 10812c0: 6b09011f     	cmp	w8, w9
 10812c4: 54000261     	b.ne	 <L23>
<L22>:
 10812c8: aa1303e0     	mov	x0, x19
 10812cc: aa1503e1     	mov	x1, x21
 10812d0: aa1403e2     	mov	x2, x20
 10812d4: 910033f9     	add	x25, sp, #0xc
 10812d8: 97fff6d0     	bl	 <ClientHandshake.Suite.update>
 10812dc: 395a53e9     	ldrb	w9, [sp, #0x694]
 10812e0: 12000528     	and	w8, w9, #0x3
 10812e4: 391bb3e9     	strb	w9, [sp, #0x6ec]
 10812e8: 7100051f     	cmp	w8, #0x1
 10812ec: 5400016c     	b.gt	 <L24>
 10812f0: 350002c8     	cbnz	w8,  <L25>
 10812f4: 91278e60     	add	x0, x19, #0x9e3
 10812f8: b27f0321     	orr	x1, x25, #0x2
 10812fc: 911a73e2     	add	x2, sp, #0x69c
 1081300: 9400021e     	bl	 <x25519.sharedSecret>
 1081304: 72003c1f     	tst	w0, #0xffff
 1081308: 540002c0     	b.eq	 <L26>
 108130c: 17ffffaa     	b	 <L10>
<L23>:
 1081310: 52800940     	mov	w0, #0x4a               // =74
 1081314: 17ffffa8     	b	 <L10>
<L24>:
 1081318: 7100091f     	cmp	w8, #0x2
 108131c: 54000381     	b.ne	 <L29>
 1081320: 912a1260     	add	x0, x19, #0xa84
 1081324: b27f0321     	orr	x1, x25, #0x2
 1081328: 911a73e2     	add	x2, sp, #0x69c
 108132c: 940002a9     	bl	 <p384.sharedSecret>
 1081330: 72003c1f     	tst	w0, #0xffff
 1081334: 54fff401     	b.ne	 <L10>
 1081338: 52800614     	mov	w20, #0x30              // =48
 108133c: 395a63e8     	ldrb	w8, [sp, #0x698]
 1081340: 35000168     	cbnz	w8,  <L27>
 1081344: 1400002f     	b	 <L30>
<L25>:
 1081348: 91288e60     	add	x0, x19, #0xa23
 108134c: b27f0321     	orr	x1, x25, #0x2
 1081350: 911a73e2     	add	x2, sp, #0x69c
 1081354: 94000260     	bl	 <p256.sharedSecret>
 1081358: 72003c1f     	tst	w0, #0xffff
 108135c: 54fff2c1     	b.ne	 <L10>
<L26>:
 1081360: 52800414     	mov	w20, #0x20              // =32
 1081364: 395a63e8     	ldrb	w8, [sp, #0x698]
 1081368: 340004c8     	cbz	w8,  <L30>
<L27>:
 108136c: 794d2fe8     	ldrh	w8, [sp, #0x696]
 1081370: 34000928     	cbz	w8,  <L32>
<L28>:
 1081374: 911a73e0     	add	x0, sp, #0x69c
 1081378: 2a1f03e1     	mov	w1, wzr
 108137c: aa1403e2     	mov	x2, x20
 1081380: 94056de8     	bl	 <memset>
 1081384: 52800940     	mov	w0, #0x4a               // =74
 1081388: 17ffff8b     	b	 <L10>
<L29>:
 108138c: 39496268     	ldrb	w8, [x19, #0x258]
 1081390: 340009e8     	cbz	w8,  <L33>
 1081394: 7944a268     	ldrh	w8, [x19, #0x250]
 1081398: 79401fe9     	ldrh	w9, [sp, #0xe]
 108139c: 6b09011f     	cmp	w8, w9
 10813a0: 54000961     	b.ne	 <L33>
 10813a4: 794023e8     	ldrh	w8, [sp, #0x10]
 10813a8: 910033e9     	add	x9, sp, #0xc
 10813ac: d10343a0     	sub	x0, x29, #0xd0
 10813b0: 91090261     	add	x1, x19, #0x240
 10813b4: 91001922     	add	x2, x9, #0x6
 10813b8: 91278e64     	add	x4, x19, #0x9e3
 10813bc: 92402903     	and	x3, x8, #0x7ff
 10813c0: 911bc3e5     	add	x5, sp, #0x6f0
 10813c4: 940002c5     	bl	 <hybrid_kex.decapsulate>
 10813c8: 785403a0     	ldurh	w0, [x29, #-0xc0]
 10813cc: 350009e0     	cbnz	w0,  <L36>
 10813d0: a94552e1     	ldp	x1, x20, [x23, #0x50]
 10813d4: 911a73e0     	add	x0, sp, #0x69c
 10813d8: aa1403e2     	mov	x2, x20
 10813dc: 94056d93     	bl	 <memcpy>
 10813e0: 6f00e400     	movi	v0.2d, #0000000000000000
 10813e4: 3d8002e0     	str	q0, [x23]
 10813e8: 3d8006e0     	str	q0, [x23, #0x10]
 10813ec: 3d800ae0     	str	q0, [x23, #0x20]
 10813f0: 3d800ee0     	str	q0, [x23, #0x30]
 10813f4: 3d8012e0     	str	q0, [x23, #0x40]
 10813f8: 395a63e8     	ldrb	w8, [sp, #0x698]
 10813fc: 35fffb88     	cbnz	w8,  <L27>
<L30>:
 1081400: aa1f03e4     	mov	x4, xzr
 1081404: aa1f03e5     	mov	x5, xzr
<L31>:
 1081408: d102e3a0     	sub	x0, x29, #0xb8
 108140c: 911a73e2     	add	x2, sp, #0x69c
 1081410: aa1303e1     	mov	x1, x19
 1081414: aa1403e3     	mov	x3, x20
 1081418: 94000336     	bl	 <ClientHandshake.Suite.deriveHandshakeKeys>
 108141c: 785f83a8     	ldurh	w8, [x29, #-0x8]
 1081420: 35000668     	cbnz	w8,  <L35>
 1081424: 3cc882e0     	ldur	q0, [x23, #0x88]
 1081428: 3cc982e1     	ldur	q1, [x23, #0x98]
 108142c: 910ae269     	add	x9, x19, #0x2b8
 1081430: f9405ee8     	ldr	x8, [x23, #0xb8]
 1081434: 3cca82e2     	ldur	q2, [x23, #0xa8]
 1081438: 911a73e0     	add	x0, sp, #0x69c
 108143c: ad140660     	stp	q0, q1, [x19, #0x280]
 1081440: 3cc682e0     	ldur	q0, [x23, #0x68]
 1081444: 2a1f03e1     	mov	w1, wzr
 1081448: 3cc782e1     	ldur	q1, [x23, #0x78]
 108144c: f9015a68     	str	x8, [x19, #0x2b0]
 1081450: aa1403e2     	mov	x2, x20
 1081454: f9408ae8     	ldr	x8, [x23, #0x110]
 1081458: 3d80aa62     	str	q2, [x19, #0x2a0]
 108145c: 3cc982c2     	ldur	q2, [x22, #0x98]
 1081460: ad130660     	stp	q0, q1, [x19, #0x260]
 1081464: ad4706e0     	ldp	q0, q1, [x23, #0xe0]
 1081468: f9018668     	str	x8, [x19, #0x308]
 108146c: 52800048     	mov	w8, #0x2                // =2
 1081470: 3d801122     	str	q2, [x9, #0x40]
 1081474: ad010520     	stp	q0, q1, [x9, #0x20]
 1081478: 3cc582c0     	ldur	q0, [x22, #0x58]
 108147c: 3cc682c1     	ldur	q1, [x22, #0x68]
 1081480: 3934f268     	strb	w8, [x19, #0xd3c]
 1081484: ad000520     	stp	q0, q1, [x9]
 1081488: 94056da6     	bl	 <memset>
 108148c: 2a1f03e0     	mov	w0, wzr
 1081490: 17ffff49     	b	 <L10>
<L32>:
 1081494: f9411a64     	ldr	x4, [x19, #0x230]
 1081498: b40001e4     	cbz	x4,  <L34>
 108149c: 79498a68     	ldrh	w8, [x19, #0x4c4]
 10814a0: 52826049     	mov	w9, #0x1302             // =4866
 10814a4: 6b09011f     	cmp	w8, w9
 10814a8: 1a9f17e8     	cset	w8, eq
 10814ac: 6b09031f     	cmp	w24, w9
 10814b0: 1a9f17e9     	cset	w9, eq
 10814b4: 6b09011f     	cmp	w8, w9
 10814b8: 54fff5e1     	b.ne	 <L28>
 10814bc: f9411e65     	ldr	x5, [x19, #0x238]
 10814c0: 52800028     	mov	w8, #0x1                // =1
 10814c4: 3934ea68     	strb	w8, [x19, #0xd3a]
 10814c8: 17ffffd0     	b	 <L31>
<L33>:
 10814cc: 52800ae0     	mov	w0, #0x57               // =87
 10814d0: 17ffff39     	b	 <L10>
<L34>:
 10814d4: 911a73e0     	add	x0, sp, #0x69c
 10814d8: 2a1f03e1     	mov	w1, wzr
 10814dc: aa1403e2     	mov	x2, x20
 10814e0: 94056d90     	bl	 <memset>
 10814e4: 528003c0     	mov	w0, #0x1e               // =30
 10814e8: 17ffff33     	b	 <L10>
<L35>:
 10814ec: 911a73e0     	add	x0, sp, #0x69c
 10814f0: 2a1f03e1     	mov	w1, wzr
 10814f4: aa1403e2     	mov	x2, x20
 10814f8: 2a0803f3     	mov	w19, w8
 10814fc: 94056d89     	bl	 <memset>
 1081500: 2a1303e0     	mov	w0, w19
 1081504: 17ffff2c     	b	 <L10>
<L36>:
 1081508: 6f00e400     	movi	v0.2d, #0000000000000000
 108150c: 3d8012e0     	str	q0, [x23, #0x40]
 1081510: 3d800ee0     	str	q0, [x23, #0x30]
 1081514: 3d800ae0     	str	q0, [x23, #0x20]
 1081518: 3d8006e0     	str	q0, [x23, #0x10]
 108151c: 3d8002e0     	str	q0, [x23]
 1081520: 17ffff25     	b	 <L10>
