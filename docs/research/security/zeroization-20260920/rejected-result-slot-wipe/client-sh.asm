
zig-out/memory.1sKeBu/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081038 <ClientHandshake.processServerHello>:
 1081038: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 108103c: a90167fc     	stp	x28, x25, [sp, #0x10]
 1081040: a9025ff8     	stp	x24, x23, [sp, #0x20]
 1081044: a90357f6     	stp	x22, x21, [sp, #0x30]
 1081048: a9044ff4     	stp	x20, x19, [sp, #0x40]
 108104c: 910003fd     	mov	x29, sp
 1081050: d12783ff     	sub	sp, sp, #0x9e0
 1081054: 3974e408     	ldrb	w8, [x0, #0xd39]
 1081058: aa0203f4     	mov	x20, x2
 108105c: aa0003f3     	mov	x19, x0
 1081060: aa0103f5     	mov	x21, x1
 1081064: 91346402     	add	x2, x0, #0xd19
 1081068: 910003e4     	mov	x4, sp
 108106c: 92401503     	and	x3, x8, #0x3f
 1081070: aa0103e0     	mov	x0, x1
 1081074: aa1403e1     	mov	x1, x20
 1081078: 94000166     	bl	 <server_hello.parseWithSessionIdEcho>
 108107c: 72003c1f     	tst	w0, #0xffff
 1081080: 54000861     	b.ne	 <L10>
 1081084: 39557268     	ldrb	w8, [x19, #0x55c]
 1081088: 92400d08     	and	x8, x8, #0xf
 108108c: 34000168     	cbz	w8,  <L1>
 1081090: 794003f7     	ldrh	w23, [sp]
 1081094: d102e3b6     	sub	x22, x29, #0xb8
 1081098: 911c33f8     	add	x24, sp, #0x70c
 108109c: 5280a989     	mov	w9, #0x54c              // =1356
<L0>:
 10810a0: 78696a6a     	ldrh	w10, [x19, x9]
 10810a4: 6b17015f     	cmp	w10, w23
 10810a8: 540000c0     	b.eq	 <L2>
 10810ac: f1000508     	subs	x8, x8, #0x1
 10810b0: 91000929     	add	x9, x9, #0x2
 10810b4: 54ffff61     	b.ne	 <L0>
<L1>:
 10810b8: 52800ac0     	mov	w0, #0x56               // =86
 10810bc: 14000034     	b	 <L10>
<L2>:
 10810c0: 395a23e8     	ldrb	w8, [sp, #0x688]
 10810c4: 7100051f     	cmp	w8, #0x1
 10810c8: 540000ac     	b.gt	 <L4>
 10810cc: 35000288     	cbnz	w8,  <L7>
<L3>:
 10810d0: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 10810d4: 913ba129     	add	x9, x9, #0xee8
 10810d8: 14000013     	b	 <L8>
<L4>:
 10810dc: 7100091f     	cmp	w8, #0x2
 10810e0: 54000081     	b.ne	 <L6>
<L5>:
 10810e4: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 10810e8: 913bc129     	add	x9, x9, #0xef0
 10810ec: 1400000e     	b	 <L8>
<L6>:
 10810f0: 794007e9     	ldrh	w9, [sp, #0x2]
 10810f4: 52823d4a     	mov	w10, #0x11ea            // =4586
 10810f8: 6b0a013f     	cmp	w9, w10
 10810fc: 5400056c     	b.gt	 <L11>
 1081100: 71005d3f     	cmp	w9, #0x17
 1081104: 540000c0     	b.eq	 <L7>
 1081108: 7100613f     	cmp	w9, #0x18
 108110c: 54fffec0     	b.eq	 <L5>
 1081110: 7100753f     	cmp	w9, #0x1d
 1081114: 54fffde0     	b.eq	 <L3>
 1081118: 14000057     	b	 <L17>
<L7>:
 108111c: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 1081120: 913bb129     	add	x9, x9, #0xeec
<L8>:
 1081124: 79400129     	ldrh	w9, [x9]
 1081128: 7104013f     	cmp	w9, #0x100
 108112c: 540002e3     	b.lo	 <L9>
 1081130: 39758a6a     	ldrb	w10, [x19, #0xd62]
 1081134: 92400929     	and	x9, x9, #0x7
 1081138: 1200154a     	and	w10, w10, #0x3f
 108113c: 1ac92549     	lsr	w9, w10, w9
 1081140: 36000249     	tbz	w9, #0x0,  <L9>
 1081144: 39552a69     	ldrb	w9, [x19, #0x54a]
 1081148: 34000489     	cbz	w9,  <L12>
 108114c: 39484269     	ldrb	w9, [x19, #0x210]
 1081150: 9101c26a     	add	x10, x19, #0x70
 1081154: 9103826b     	add	x11, x19, #0xe0
 1081158: 12000529     	and	w9, w9, #0x3
 108115c: 7100053f     	cmp	w9, #0x1
 1081160: 9a8b0149     	csel	x9, x10, x11, eq
 1081164: 79400129     	ldrh	w9, [x9]
 1081168: 6b0902ff     	cmp	w23, w9
 108116c: 54000c41     	b.ne	 <L23>
 1081170: 794a9269     	ldrh	w9, [x19, #0x548]
 1081174: 7100051f     	cmp	w8, #0x1
 1081178: 5400070c     	b.gt	 <L15>
 108117c: 35000888     	cbnz	w8,  <L19>
 1081180: 528003a8     	mov	w8, #0x1d               // =29
 1081184: 14000045     	b	 <L21>
<L9>:
 1081188: 52800aa0     	mov	w0, #0x55               // =85
<L10>:
 108118c: 912783ff     	add	sp, sp, #0x9e0
 1081190: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 1081194: a94357f6     	ldp	x22, x21, [sp, #0x30]
 1081198: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 108119c: a94167fc     	ldp	x28, x25, [sp, #0x10]
 10811a0: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 10811a4: d65f03c0     	ret
<L11>:
 10811a8: 52823d6a     	mov	w10, #0x11eb            // =4587
 10811ac: 6b0a013f     	cmp	w9, w10
 10811b0: 540005c0     	b.eq	 <L16>
 10811b4: 52823d8a     	mov	w10, #0x11ec            // =4588
 10811b8: 6b0a013f     	cmp	w9, w10
 10811bc: 54000620     	b.eq	 <L18>
 10811c0: 52823daa     	mov	w10, #0x11ed            // =4589
 10811c4: 6b0a013f     	cmp	w9, w10
 10811c8: 54000561     	b.ne	 <L17>
 10811cc: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 10811d0: 913bf129     	add	x9, x9, #0xefc
 10811d4: 17ffffd4     	b	 <L8>
<L12>:
 10811d8: 52826048     	mov	w8, #0x1302             // =4866
 10811dc: 6b0802ff     	cmp	w23, w8
 10811e0: 540002c1     	b.ne	 <L13>
 10811e4: ad478a61     	ldp	q1, q2, [x19, #0xf0]
 10811e8: 52800048     	mov	w8, #0x2                // =2
 10811ec: ad440e60     	ldp	q0, q3, [x19, #0x80]
 10811f0: 52826049     	mov	w9, #0x1302             // =4866
 10811f4: ad464266     	ldp	q6, q16, [x19, #0xc0]
 10811f8: 52801c0a     	mov	w10, #0xe0              // =224
 10811fc: ad040a61     	stp	q1, q2, [x19, #0x80]
 1081200: ad488665     	ldp	q5, q1, [x19, #0x110]
 1081204: ad450a64     	ldp	q4, q2, [x19, #0xa0]
 1081208: 39084268     	strb	w8, [x19, #0x210]
 108120c: 52804048     	mov	w8, #0x202              // =514
 1081210: ad050665     	stp	q5, q1, [x19, #0xa0]
 1081214: 3dc01e65     	ldr	q5, [x19, #0x70]
 1081218: ad498667     	ldp	q7, q1, [x19, #0x130]
 108121c: ad011263     	stp	q3, q4, [x19, #0x20]
 1081220: ad000265     	stp	q5, q0, [x19]
 1081224: 3dc03a60     	ldr	q0, [x19, #0xe0]
 1081228: ad021a62     	stp	q2, q6, [x19, #0x40]
 108122c: ad030270     	stp	q16, q0, [x19, #0x60]
 1081230: ad060667     	stp	q7, q1, [x19, #0xc0]
 1081234: 14000006     	b	 <L14>
<L13>:
 1081238: 52800028     	mov	w8, #0x1                // =1
 108123c: 52800e0a     	mov	w10, #0x70              // =112
 1081240: 2a1703e9     	mov	w9, w23
 1081244: 39084268     	strb	w8, [x19, #0x210]
 1081248: 52802648     	mov	w8, #0x132              // =306
<L14>:
 108124c: 782a6a69     	strh	w9, [x19, x10]
 1081250: 38286a7f     	strb	wzr, [x19, x8]
 1081254: 14000013     	b	 <L22>
<L15>:
 1081258: 7100091f     	cmp	w8, #0x2
 108125c: 540001c1     	b.ne	 <L20>
 1081260: 52800308     	mov	w8, #0x18               // =24
 1081264: 1400000d     	b	 <L21>
<L16>:
 1081268: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 108126c: 913bd129     	add	x9, x9, #0xef4
 1081270: 17ffffad     	b	 <L8>
<L17>:
 1081274: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 1081278: 913bf929     	add	x9, x9, #0xefe
 108127c: 17ffffaa     	b	 <L8>
<L18>:
 1081280: 90fffc49     	adrp	x9, 0x1009000 <__anon_51080+0x980>
 1081284: 913be129     	add	x9, x9, #0xef8
 1081288: 17ffffa7     	b	 <L8>
<L19>:
 108128c: 528002e8     	mov	w8, #0x17               // =23
 1081290: 14000002     	b	 <L21>
<L20>:
 1081294: 794007e8     	ldrh	w8, [sp, #0x2]
<L21>:
 1081298: 6b09011f     	cmp	w8, w9
 108129c: 540002c1     	b.ne	 <L23>
<L22>:
 10812a0: aa1303e0     	mov	x0, x19
 10812a4: aa1503e1     	mov	x1, x21
 10812a8: aa1403e2     	mov	x2, x20
 10812ac: 910003f9     	mov	x25, sp
 10812b0: 97fff6d0     	bl	 <ClientHandshake.Suite.update>
 10812b4: 395a23e8     	ldrb	w8, [sp, #0x688]
 10812b8: 12000508     	and	w8, w8, #0x3
 10812bc: 7100051f     	cmp	w8, #0x1
 10812c0: 540001ec     	b.gt	 <L24>
 10812c4: 35000388     	cbnz	w8,  <L25>
 10812c8: 911c33e0     	add	x0, sp, #0x70c
 10812cc: 91278e61     	add	x1, x19, #0x9e3
 10812d0: b27f0322     	orr	x2, x25, #0x2
 10812d4: 94000264     	bl	 <x25519.sharedSecret>
 10812d8: 794e1be0     	ldrh	w0, [sp, #0x70c]
 10812dc: 34000800     	cbz	w0,  <L28>
 10812e0: 6f00e400     	movi	v0.2d, #0000000000000000
 10812e4: 790e13ff     	strh	wzr, [sp, #0x708]
 10812e8: 3d81bfe0     	str	q0, [sp, #0x6f0]
 10812ec: 3d81bbe0     	str	q0, [sp, #0x6e0]
 10812f0: 17ffffa7     	b	 <L10>
<L23>:
 10812f4: 52800940     	mov	w0, #0x4a               // =74
 10812f8: 17ffffa5     	b	 <L10>
<L24>:
 10812fc: 7100091f     	cmp	w8, #0x2
 1081300: 54000301     	b.ne	 <L26>
 1081304: 911ef3e0     	add	x0, sp, #0x7bc
 1081308: 912a1261     	add	x1, x19, #0xa84
 108130c: b27f0322     	orr	x2, x25, #0x2
 1081310: 940002ff     	bl	 <p384.sharedSecret>
 1081314: 794f7be0     	ldrh	w0, [sp, #0x7bc]
 1081318: 34000740     	cbz	w0,  <L29>
 108131c: 6f00e400     	movi	v0.2d, #0000000000000000
 1081320: 790f73ff     	strh	wzr, [sp, #0x7b8]
 1081324: 3d81ebe0     	str	q0, [sp, #0x7a0]
 1081328: 3d81e7e0     	str	q0, [sp, #0x790]
 108132c: 3d81e3e0     	str	q0, [sp, #0x780]
 1081330: 17ffff97     	b	 <L10>
<L25>:
 1081334: 911d73e0     	add	x0, sp, #0x75c
 1081338: 91288e61     	add	x1, x19, #0xa23
 108133c: b27f0322     	orr	x2, x25, #0x2
 1081340: 940002a8     	bl	 <p256.sharedSecret>
 1081344: 794ebbe0     	ldrh	w0, [sp, #0x75c]
 1081348: 34000760     	cbz	w0,  <L30>
 108134c: 6f00e400     	movi	v0.2d, #0000000000000000
 1081350: 790eb3ff     	strh	wzr, [sp, #0x758]
 1081354: 3d81d3e0     	str	q0, [sp, #0x740]
 1081358: 3d81cfe0     	str	q0, [sp, #0x730]
 108135c: 17ffff8c     	b	 <L10>
<L26>:
 1081360: 39496268     	ldrb	w8, [x19, #0x258]
 1081364: 34000388     	cbz	w8,  <L27>
 1081368: 7944a268     	ldrh	w8, [x19, #0x250]
 108136c: 794007e9     	ldrh	w9, [sp, #0x2]
 1081370: 6b09011f     	cmp	w8, w9
 1081374: 54000301     	b.ne	 <L27>
 1081378: 79400be8     	ldrh	w8, [sp, #0x4]
 108137c: 910003e9     	mov	x9, sp
 1081380: 912123e0     	add	x0, sp, #0x848
 1081384: 91090261     	add	x1, x19, #0x240
 1081388: 91001922     	add	x2, x9, #0x6
 108138c: 91278e64     	add	x4, x19, #0x9e3
 1081390: 92402903     	and	x3, x8, #0x7ff
 1081394: 911fc3e5     	add	x5, sp, #0x7f0
 1081398: 94000333     	bl	 <hybrid_kex.decapsulate>
 108139c: 7950b3e0     	ldrh	w0, [sp, #0x858]
 10813a0: 350012a0     	cbnz	w0,  <L39>
 10813a4: f9442bf4     	ldr	x20, [sp, #0x850]
 10813a8: f94427e1     	ldr	x1, [sp, #0x848]
 10813ac: 911a43e0     	add	x0, sp, #0x690
 10813b0: aa1403e2     	mov	x2, x20
 10813b4: 9405713d     	bl	 <memcpy>
 10813b8: 6f00e400     	movi	v0.2d, #0000000000000000
 10813bc: 3d81ffe0     	str	q0, [sp, #0x7f0]
 10813c0: 3d8203e0     	str	q0, [sp, #0x800]
 10813c4: 3d8207e0     	str	q0, [sp, #0x810]
 10813c8: 3d820be0     	str	q0, [sp, #0x820]
 10813cc: 3d820fe0     	str	q0, [sp, #0x830]
 10813d0: 14000022     	b	 <L32>
<L27>:
 10813d4: 52800ae0     	mov	w0, #0x57               // =87
 10813d8: 17ffff6d     	b	 <L10>
<L28>:
 10813dc: 6f00e402     	movi	v2.2d, #0000000000000000
 10813e0: 3cc02300     	ldur	q0, [x24, #0x2]
 10813e4: 3cc12301     	ldur	q1, [x24, #0x12]
 10813e8: 3d81a7e0     	str	q0, [sp, #0x690]
 10813ec: 3d81abe1     	str	q1, [sp, #0x6a0]
 10813f0: 790e13ff     	strh	wzr, [sp, #0x708]
 10813f4: 3d81bfe2     	str	q2, [sp, #0x6f0]
 10813f8: 3d81bbe2     	str	q2, [sp, #0x6e0]
 10813fc: 14000016     	b	 <L31>
<L29>:
 1081400: 6f00e403     	movi	v3.2d, #0000000000000000
 1081404: 3ccb2300     	ldur	q0, [x24, #0xb2]
 1081408: 3ccc2301     	ldur	q1, [x24, #0xc2]
 108140c: 3ccd2302     	ldur	q2, [x24, #0xd2]
 1081410: 52800614     	mov	w20, #0x30              // =48
 1081414: 3d81a7e0     	str	q0, [sp, #0x690]
 1081418: 3d81abe1     	str	q1, [sp, #0x6a0]
 108141c: 3d81afe2     	str	q2, [sp, #0x6b0]
 1081420: 790f73ff     	strh	wzr, [sp, #0x7b8]
 1081424: 3d81ebe3     	str	q3, [sp, #0x7a0]
 1081428: 3d81e7e3     	str	q3, [sp, #0x790]
 108142c: 3d81e3e3     	str	q3, [sp, #0x780]
 1081430: 1400000a     	b	 <L32>
<L30>:
 1081434: 6f00e402     	movi	v2.2d, #0000000000000000
 1081438: 3cc52300     	ldur	q0, [x24, #0x52]
 108143c: 3cc62301     	ldur	q1, [x24, #0x62]
 1081440: 3d81a7e0     	str	q0, [sp, #0x690]
 1081444: 3d81abe1     	str	q1, [sp, #0x6a0]
 1081448: 790eb3ff     	strh	wzr, [sp, #0x758]
 108144c: 3d81d3e2     	str	q2, [sp, #0x740]
 1081450: 3d81cfe2     	str	q2, [sp, #0x730]
<L31>:
 1081454: 52800414     	mov	w20, #0x20              // =32
<L32>:
 1081458: 395a33e8     	ldrb	w8, [sp, #0x68c]
 108145c: 34000128     	cbz	w8,  <L34>
 1081460: 794d17e8     	ldrh	w8, [sp, #0x68a]
 1081464: 340004c8     	cbz	w8,  <L36>
<L33>:
 1081468: 911a43e0     	add	x0, sp, #0x690
 108146c: 2a1f03e1     	mov	w1, wzr
 1081470: aa1403e2     	mov	x2, x20
 1081474: 9405714b     	bl	 <memset>
 1081478: 52800940     	mov	w0, #0x4a               // =74
 108147c: 17ffff44     	b	 <L10>
<L34>:
 1081480: aa1f03e4     	mov	x4, xzr
 1081484: aa1f03e5     	mov	x5, xzr
<L35>:
 1081488: d102e3a0     	sub	x0, x29, #0xb8
 108148c: 911a43e2     	add	x2, sp, #0x690
 1081490: aa1303e1     	mov	x1, x19
 1081494: aa1403e3     	mov	x3, x20
 1081498: 94000379     	bl	 <ClientHandshake.Suite.deriveHandshakeKeys>
 108149c: 785f83a8     	ldurh	w8, [x29, #-0x8]
 10814a0: 340004a8     	cbz	w8,  <L37>
 10814a4: 6f00e400     	movi	v0.2d, #0000000000000000
 10814a8: 911a43e0     	add	x0, sp, #0x690
 10814ac: 2a1f03e1     	mov	w1, wzr
 10814b0: aa1403e2     	mov	x2, x20
 10814b4: 2a0803f3     	mov	w19, w8
 10814b8: 3d8247e0     	str	q0, [sp, #0x910]
 10814bc: 3d8243e0     	str	q0, [sp, #0x900]
 10814c0: 3d823fe0     	str	q0, [sp, #0x8f0]
 10814c4: 3d823be0     	str	q0, [sp, #0x8e0]
 10814c8: 3d8237e0     	str	q0, [sp, #0x8d0]
 10814cc: 3d8233e0     	str	q0, [sp, #0x8c0]
 10814d0: 3d822fe0     	str	q0, [sp, #0x8b0]
 10814d4: 3d822be0     	str	q0, [sp, #0x8a0]
 10814d8: 3d8227e0     	str	q0, [sp, #0x890]
 10814dc: 3d8223e0     	str	q0, [sp, #0x880]
 10814e0: 3d821fe0     	str	q0, [sp, #0x870]
 10814e4: 7910d3ff     	strh	wzr, [sp, #0x868]
 10814e8: 7910cbff     	strh	wzr, [sp, #0x864]
 10814ec: b90863ff     	str	wzr, [sp, #0x860]
 10814f0: 9405712c     	bl	 <memset>
 10814f4: 2a1303e0     	mov	w0, w19
 10814f8: 17ffff25     	b	 <L10>
<L36>:
 10814fc: f9411a64     	ldr	x4, [x19, #0x230]
 1081500: b40006e4     	cbz	x4,  <L38>
 1081504: 79498a68     	ldrh	w8, [x19, #0x4c4]
 1081508: 52826049     	mov	w9, #0x1302             // =4866
 108150c: 6b09011f     	cmp	w8, w9
 1081510: 1a9f17e8     	cset	w8, eq
 1081514: 6b0902ff     	cmp	w23, w9
 1081518: 1a9f17e9     	cset	w9, eq
 108151c: 6b09011f     	cmp	w8, w9
 1081520: 54fffa41     	b.ne	 <L33>
 1081524: f9411e65     	ldr	x5, [x19, #0x238]
 1081528: 52800028     	mov	w8, #0x1                // =1
 108152c: 3934ea68     	strb	w8, [x19, #0xd3a]
 1081530: 17ffffd6     	b	 <L35>
<L37>:
 1081534: ad4106c0     	ldp	q0, q1, [x22, #0x20]
 1081538: 910ae268     	add	x8, x19, #0x2b8
 108153c: 3dc012c2     	ldr	q2, [x22, #0x40]
 1081540: f85983a9     	ldur	x9, [x29, #-0x68]
 1081544: 911a43e0     	add	x0, sp, #0x690
 1081548: 2a1f03e1     	mov	w1, wzr
 108154c: aa1403e2     	mov	x2, x20
 1081550: ad140660     	stp	q0, q1, [x19, #0x280]
 1081554: ad4006c0     	ldp	q0, q1, [x22]
 1081558: 3d80aa62     	str	q2, [x19, #0x2a0]
 108155c: 3cc782c2     	ldur	q2, [x22, #0x78]
 1081560: f9015a69     	str	x9, [x19, #0x2b0]
 1081564: 52800049     	mov	w9, #0x2                // =2
 1081568: ad130660     	stp	q0, q1, [x19, #0x260]
 108156c: 3cc882c0     	ldur	q0, [x22, #0x88]
 1081570: 3cc982c1     	ldur	q1, [x22, #0x98]
 1081574: 3934f269     	strb	w9, [x19, #0xd3c]
 1081578: ad010102     	stp	q2, q0, [x8, #0x20]
 108157c: 3cc582c0     	ldur	q0, [x22, #0x58]
 1081580: 3d801101     	str	q1, [x8, #0x40]
 1081584: 3cc682c1     	ldur	q1, [x22, #0x68]
 1081588: ad000500     	stp	q0, q1, [x8]
 108158c: 6f00e400     	movi	v0.2d, #0000000000000000
 1081590: f85f03a8     	ldur	x8, [x29, #-0x10]
 1081594: f9018668     	str	x8, [x19, #0x308]
 1081598: 3d821fe0     	str	q0, [sp, #0x870]
 108159c: 3d8223e0     	str	q0, [sp, #0x880]
 10815a0: 3d8227e0     	str	q0, [sp, #0x890]
 10815a4: 3d822be0     	str	q0, [sp, #0x8a0]
 10815a8: 3d822fe0     	str	q0, [sp, #0x8b0]
 10815ac: 3d8233e0     	str	q0, [sp, #0x8c0]
 10815b0: 3d8237e0     	str	q0, [sp, #0x8d0]
 10815b4: 3d823be0     	str	q0, [sp, #0x8e0]
 10815b8: 3d823fe0     	str	q0, [sp, #0x8f0]
 10815bc: 3d8243e0     	str	q0, [sp, #0x900]
 10815c0: 3d8247e0     	str	q0, [sp, #0x910]
 10815c4: 7910d3ff     	strh	wzr, [sp, #0x868]
 10815c8: 7910cbff     	strh	wzr, [sp, #0x864]
 10815cc: b90863ff     	str	wzr, [sp, #0x860]
 10815d0: 940570f4     	bl	 <memset>
 10815d4: 2a1f03e0     	mov	w0, wzr
 10815d8: 17fffeed     	b	 <L10>
<L38>:
 10815dc: 911a43e0     	add	x0, sp, #0x690
 10815e0: 2a1f03e1     	mov	w1, wzr
 10815e4: aa1403e2     	mov	x2, x20
 10815e8: 940570ee     	bl	 <memset>
 10815ec: 528003c0     	mov	w0, #0x1e               // =30
 10815f0: 17fffee7     	b	 <L10>
<L39>:
 10815f4: 6f00e400     	movi	v0.2d, #0000000000000000
 10815f8: 3d820fe0     	str	q0, [sp, #0x830]
 10815fc: 3d820be0     	str	q0, [sp, #0x820]
 1081600: 3d8207e0     	str	q0, [sp, #0x810]
 1081604: 3d8203e0     	str	q0, [sp, #0x800]
 1081608: 3d81ffe0     	str	q0, [sp, #0x7f0]
 108160c: 17fffee0     	b	 <L10>
