
zig-out/memory.N4aX4N/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081000 <ClientHandshake.processServerHello>:
 1081000: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
 1081004: a90167fc     	stp	x28, x25, [sp, #0x10]
 1081008: a9025ff8     	stp	x24, x23, [sp, #0x20]
 108100c: a90357f6     	stp	x22, x21, [sp, #0x30]
 1081010: a9044ff4     	stp	x20, x19, [sp, #0x40]
 1081014: 910003fd     	mov	x29, sp
 1081018: d12043ff     	sub	sp, sp, #0x810
 108101c: 3974e408     	ldrb	w8, [x0, #0xd39]
 1081020: aa0203f4     	mov	x20, x2
 1081024: aa0003f3     	mov	x19, x0
 1081028: aa0103f5     	mov	x21, x1
 108102c: 91346402     	add	x2, x0, #0xd19
 1081030: 910033e4     	add	x4, sp, #0xc
 1081034: 92401503     	and	x3, x8, #0x3f
 1081038: aa0103e0     	mov	x0, x1
 108103c: aa1403e1     	mov	x1, x20
 1081040: 94000121     	bl	 <server_hello.parseWithSessionIdEcho>
 1081044: 72003c1f     	tst	w0, #0xffff
 1081048: 54000861     	b.ne	 <L10>
 108104c: 39557268     	ldrb	w8, [x19, #0x55c]
 1081050: 92400d08     	and	x8, x8, #0xf
 1081054: 34000168     	cbz	w8,  <L1>
 1081058: 79401bf8     	ldrh	w24, [sp, #0xc]
 108105c: d102e3b6     	sub	x22, x29, #0xb8
 1081060: 911bc3f7     	add	x23, sp, #0x6f0
 1081064: 5280a989     	mov	w9, #0x54c              // =1356
<L0>:
 1081068: 78696a6a     	ldrh	w10, [x19, x9]
 108106c: 6b18015f     	cmp	w10, w24
 1081070: 540000c0     	b.eq	 <L2>
 1081074: f1000508     	subs	x8, x8, #0x1
 1081078: 91000929     	add	x9, x9, #0x2
 108107c: 54ffff61     	b.ne	 <L0>
<L1>:
 1081080: 52800ac0     	mov	w0, #0x56               // =86
 1081084: 14000034     	b	 <L10>
<L2>:
 1081088: 395a53e8     	ldrb	w8, [sp, #0x694]
 108108c: 7100051f     	cmp	w8, #0x1
 1081090: 540000ac     	b.gt	 <L4>
 1081094: 35000288     	cbnz	w8,  <L7>
<L3>:
 1081098: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 108109c: 913ba129     	add	x9, x9, #0xee8
 10810a0: 14000013     	b	 <L8>
<L4>:
 10810a4: 7100091f     	cmp	w8, #0x2
 10810a8: 54000081     	b.ne	 <L6>
<L5>:
 10810ac: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10810b0: 913bc129     	add	x9, x9, #0xef0
 10810b4: 1400000e     	b	 <L8>
<L6>:
 10810b8: 79401fe9     	ldrh	w9, [sp, #0xe]
 10810bc: 52823d4a     	mov	w10, #0x11ea            // =4586
 10810c0: 6b0a013f     	cmp	w9, w10
 10810c4: 5400056c     	b.gt	 <L11>
 10810c8: 71005d3f     	cmp	w9, #0x17
 10810cc: 540000c0     	b.eq	 <L7>
 10810d0: 7100613f     	cmp	w9, #0x18
 10810d4: 54fffec0     	b.eq	 <L5>
 10810d8: 7100753f     	cmp	w9, #0x1d
 10810dc: 54fffde0     	b.eq	 <L3>
 10810e0: 14000057     	b	 <L17>
<L7>:
 10810e4: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10810e8: 913bb129     	add	x9, x9, #0xeec
<L8>:
 10810ec: 79400129     	ldrh	w9, [x9]
 10810f0: 7104013f     	cmp	w9, #0x100
 10810f4: 540002e3     	b.lo	 <L9>
 10810f8: 39758a6a     	ldrb	w10, [x19, #0xd62]
 10810fc: 92400929     	and	x9, x9, #0x7
 1081100: 1200154a     	and	w10, w10, #0x3f
 1081104: 1ac92549     	lsr	w9, w10, w9
 1081108: 36000249     	tbz	w9, #0x0,  <L9>
 108110c: 39552a69     	ldrb	w9, [x19, #0x54a]
 1081110: 34000489     	cbz	w9,  <L12>
 1081114: 39484269     	ldrb	w9, [x19, #0x210]
 1081118: 9101c26a     	add	x10, x19, #0x70
 108111c: 9103826b     	add	x11, x19, #0xe0
 1081120: 12000529     	and	w9, w9, #0x3
 1081124: 7100053f     	cmp	w9, #0x1
 1081128: 9a8b0149     	csel	x9, x10, x11, eq
 108112c: 79400129     	ldrh	w9, [x9]
 1081130: 6b09031f     	cmp	w24, w9
 1081134: 54000be1     	b.ne	 <L23>
 1081138: 794a9269     	ldrh	w9, [x19, #0x548]
 108113c: 7100051f     	cmp	w8, #0x1
 1081140: 5400070c     	b.gt	 <L15>
 1081144: 35000888     	cbnz	w8,  <L19>
 1081148: 528003a8     	mov	w8, #0x1d               // =29
 108114c: 14000045     	b	 <L21>
<L9>:
 1081150: 52800aa0     	mov	w0, #0x55               // =85
<L10>:
 1081154: 912043ff     	add	sp, sp, #0x810
 1081158: a9444ff4     	ldp	x20, x19, [sp, #0x40]
 108115c: a94357f6     	ldp	x22, x21, [sp, #0x30]
 1081160: a9425ff8     	ldp	x24, x23, [sp, #0x20]
 1081164: a94167fc     	ldp	x28, x25, [sp, #0x10]
 1081168: a8c57bfd     	ldp	x29, x30, [sp], #0x50
 108116c: d65f03c0     	ret
<L11>:
 1081170: 52823d6a     	mov	w10, #0x11eb            // =4587
 1081174: 6b0a013f     	cmp	w9, w10
 1081178: 540005c0     	b.eq	 <L16>
 108117c: 52823d8a     	mov	w10, #0x11ec            // =4588
 1081180: 6b0a013f     	cmp	w9, w10
 1081184: 54000620     	b.eq	 <L18>
 1081188: 52823daa     	mov	w10, #0x11ed            // =4589
 108118c: 6b0a013f     	cmp	w9, w10
 1081190: 54000561     	b.ne	 <L17>
 1081194: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1081198: 913bf129     	add	x9, x9, #0xefc
 108119c: 17ffffd4     	b	 <L8>
<L12>:
 10811a0: 52826048     	mov	w8, #0x1302             // =4866
 10811a4: 6b08031f     	cmp	w24, w8
 10811a8: 540002c1     	b.ne	 <L13>
 10811ac: ad478a61     	ldp	q1, q2, [x19, #0xf0]
 10811b0: 52800048     	mov	w8, #0x2                // =2
 10811b4: ad440e60     	ldp	q0, q3, [x19, #0x80]
 10811b8: 52826049     	mov	w9, #0x1302             // =4866
 10811bc: ad464266     	ldp	q6, q16, [x19, #0xc0]
 10811c0: 52801c0a     	mov	w10, #0xe0              // =224
 10811c4: ad040a61     	stp	q1, q2, [x19, #0x80]
 10811c8: ad488665     	ldp	q5, q1, [x19, #0x110]
 10811cc: ad450a64     	ldp	q4, q2, [x19, #0xa0]
 10811d0: 39084268     	strb	w8, [x19, #0x210]
 10811d4: 52804048     	mov	w8, #0x202              // =514
 10811d8: ad050665     	stp	q5, q1, [x19, #0xa0]
 10811dc: 3dc01e65     	ldr	q5, [x19, #0x70]
 10811e0: ad498667     	ldp	q7, q1, [x19, #0x130]
 10811e4: ad011263     	stp	q3, q4, [x19, #0x20]
 10811e8: ad000265     	stp	q5, q0, [x19]
 10811ec: 3dc03a60     	ldr	q0, [x19, #0xe0]
 10811f0: ad021a62     	stp	q2, q6, [x19, #0x40]
 10811f4: ad030270     	stp	q16, q0, [x19, #0x60]
 10811f8: ad060667     	stp	q7, q1, [x19, #0xc0]
 10811fc: 14000006     	b	 <L14>
<L13>:
 1081200: 52800028     	mov	w8, #0x1                // =1
 1081204: 52800e0a     	mov	w10, #0x70              // =112
 1081208: 2a1803e9     	mov	w9, w24
 108120c: 39084268     	strb	w8, [x19, #0x210]
 1081210: 52802648     	mov	w8, #0x132              // =306
<L14>:
 1081214: 782a6a69     	strh	w9, [x19, x10]
 1081218: 38286a7f     	strb	wzr, [x19, x8]
 108121c: 14000013     	b	 <L22>
<L15>:
 1081220: 7100091f     	cmp	w8, #0x2
 1081224: 540001c1     	b.ne	 <L20>
 1081228: 52800308     	mov	w8, #0x18               // =24
 108122c: 1400000d     	b	 <L21>
<L16>:
 1081230: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1081234: 913bd129     	add	x9, x9, #0xef4
 1081238: 17ffffad     	b	 <L8>
<L17>:
 108123c: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1081240: 913bf929     	add	x9, x9, #0xefe
 1081244: 17ffffaa     	b	 <L8>
<L18>:
 1081248: 90fffc49     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 108124c: 913be129     	add	x9, x9, #0xef8
 1081250: 17ffffa7     	b	 <L8>
<L19>:
 1081254: 528002e8     	mov	w8, #0x17               // =23
 1081258: 14000002     	b	 <L21>
<L20>:
 108125c: 79401fe8     	ldrh	w8, [sp, #0xe]
<L21>:
 1081260: 6b09011f     	cmp	w8, w9
 1081264: 54000261     	b.ne	 <L23>
<L22>:
 1081268: aa1303e0     	mov	x0, x19
 108126c: aa1503e1     	mov	x1, x21
 1081270: aa1403e2     	mov	x2, x20
 1081274: 910033f9     	add	x25, sp, #0xc
 1081278: 97fff6d0     	bl	 <ClientHandshake.Suite.update>
 108127c: 395a53e9     	ldrb	w9, [sp, #0x694]
 1081280: 12000528     	and	w8, w9, #0x3
 1081284: 391bb3e9     	strb	w9, [sp, #0x6ec]
 1081288: 7100051f     	cmp	w8, #0x1
 108128c: 5400016c     	b.gt	 <L24>
 1081290: 350002c8     	cbnz	w8,  <L25>
 1081294: 91278e60     	add	x0, x19, #0x9e3
 1081298: b27f0321     	orr	x1, x25, #0x2
 108129c: 911a73e2     	add	x2, sp, #0x69c
 10812a0: 9400021e     	bl	 <x25519.sharedSecret>
 10812a4: 72003c1f     	tst	w0, #0xffff
 10812a8: 540002c0     	b.eq	 <L26>
 10812ac: 17ffffaa     	b	 <L10>
<L23>:
 10812b0: 52800940     	mov	w0, #0x4a               // =74
 10812b4: 17ffffa8     	b	 <L10>
<L24>:
 10812b8: 7100091f     	cmp	w8, #0x2
 10812bc: 54000381     	b.ne	 <L29>
 10812c0: 912a1260     	add	x0, x19, #0xa84
 10812c4: b27f0321     	orr	x1, x25, #0x2
 10812c8: 911a73e2     	add	x2, sp, #0x69c
 10812cc: 940002a9     	bl	 <p384.sharedSecret>
 10812d0: 72003c1f     	tst	w0, #0xffff
 10812d4: 54fff401     	b.ne	 <L10>
 10812d8: 52800614     	mov	w20, #0x30              // =48
 10812dc: 395a63e8     	ldrb	w8, [sp, #0x698]
 10812e0: 35000168     	cbnz	w8,  <L27>
 10812e4: 1400002f     	b	 <L30>
<L25>:
 10812e8: 91288e60     	add	x0, x19, #0xa23
 10812ec: b27f0321     	orr	x1, x25, #0x2
 10812f0: 911a73e2     	add	x2, sp, #0x69c
 10812f4: 94000260     	bl	 <p256.sharedSecret>
 10812f8: 72003c1f     	tst	w0, #0xffff
 10812fc: 54fff2c1     	b.ne	 <L10>
<L26>:
 1081300: 52800414     	mov	w20, #0x20              // =32
 1081304: 395a63e8     	ldrb	w8, [sp, #0x698]
 1081308: 340004c8     	cbz	w8,  <L30>
<L27>:
 108130c: 794d2fe8     	ldrh	w8, [sp, #0x696]
 1081310: 34000928     	cbz	w8,  <L32>
<L28>:
 1081314: 911a73e0     	add	x0, sp, #0x69c
 1081318: 2a1f03e1     	mov	w1, wzr
 108131c: aa1403e2     	mov	x2, x20
 1081320: 94056de8     	bl	 <memset>
 1081324: 52800940     	mov	w0, #0x4a               // =74
 1081328: 17ffff8b     	b	 <L10>
<L29>:
 108132c: 39496268     	ldrb	w8, [x19, #0x258]
 1081330: 340009e8     	cbz	w8,  <L33>
 1081334: 7944a268     	ldrh	w8, [x19, #0x250]
 1081338: 79401fe9     	ldrh	w9, [sp, #0xe]
 108133c: 6b09011f     	cmp	w8, w9
 1081340: 54000961     	b.ne	 <L33>
 1081344: 794023e8     	ldrh	w8, [sp, #0x10]
 1081348: 910033e9     	add	x9, sp, #0xc
 108134c: d10343a0     	sub	x0, x29, #0xd0
 1081350: 91090261     	add	x1, x19, #0x240
 1081354: 91001922     	add	x2, x9, #0x6
 1081358: 91278e64     	add	x4, x19, #0x9e3
 108135c: 92402903     	and	x3, x8, #0x7ff
 1081360: 911bc3e5     	add	x5, sp, #0x6f0
 1081364: 940002c5     	bl	 <hybrid_kex.decapsulate>
 1081368: 785403a0     	ldurh	w0, [x29, #-0xc0]
 108136c: 350009e0     	cbnz	w0,  <L36>
 1081370: a94552e1     	ldp	x1, x20, [x23, #0x50]
 1081374: 911a73e0     	add	x0, sp, #0x69c
 1081378: aa1403e2     	mov	x2, x20
 108137c: 94056d93     	bl	 <memcpy>
 1081380: 6f00e400     	movi	v0.2d, #0000000000000000
 1081384: 3d8002e0     	str	q0, [x23]
 1081388: 3d8006e0     	str	q0, [x23, #0x10]
 108138c: 3d800ae0     	str	q0, [x23, #0x20]
 1081390: 3d800ee0     	str	q0, [x23, #0x30]
 1081394: 3d8012e0     	str	q0, [x23, #0x40]
 1081398: 395a63e8     	ldrb	w8, [sp, #0x698]
 108139c: 35fffb88     	cbnz	w8,  <L27>
<L30>:
 10813a0: aa1f03e4     	mov	x4, xzr
 10813a4: aa1f03e5     	mov	x5, xzr
<L31>:
 10813a8: d102e3a0     	sub	x0, x29, #0xb8
 10813ac: 911a73e2     	add	x2, sp, #0x69c
 10813b0: aa1303e1     	mov	x1, x19
 10813b4: aa1403e3     	mov	x3, x20
 10813b8: 94000336     	bl	 <ClientHandshake.Suite.deriveHandshakeKeys>
 10813bc: 785f83a8     	ldurh	w8, [x29, #-0x8]
 10813c0: 35000668     	cbnz	w8,  <L35>
 10813c4: 3cc882e0     	ldur	q0, [x23, #0x88]
 10813c8: 3cc982e1     	ldur	q1, [x23, #0x98]
 10813cc: 910ae269     	add	x9, x19, #0x2b8
 10813d0: f9405ee8     	ldr	x8, [x23, #0xb8]
 10813d4: 3cca82e2     	ldur	q2, [x23, #0xa8]
 10813d8: 911a73e0     	add	x0, sp, #0x69c
 10813dc: ad140660     	stp	q0, q1, [x19, #0x280]
 10813e0: 3cc682e0     	ldur	q0, [x23, #0x68]
 10813e4: 2a1f03e1     	mov	w1, wzr
 10813e8: 3cc782e1     	ldur	q1, [x23, #0x78]
 10813ec: f9015a68     	str	x8, [x19, #0x2b0]
 10813f0: aa1403e2     	mov	x2, x20
 10813f4: f9408ae8     	ldr	x8, [x23, #0x110]
 10813f8: 3d80aa62     	str	q2, [x19, #0x2a0]
 10813fc: 3cc982c2     	ldur	q2, [x22, #0x98]
 1081400: ad130660     	stp	q0, q1, [x19, #0x260]
 1081404: ad4706e0     	ldp	q0, q1, [x23, #0xe0]
 1081408: f9018668     	str	x8, [x19, #0x308]
 108140c: 52800048     	mov	w8, #0x2                // =2
 1081410: 3d801122     	str	q2, [x9, #0x40]
 1081414: ad010520     	stp	q0, q1, [x9, #0x20]
 1081418: 3cc582c0     	ldur	q0, [x22, #0x58]
 108141c: 3cc682c1     	ldur	q1, [x22, #0x68]
 1081420: 3934f268     	strb	w8, [x19, #0xd3c]
 1081424: ad000520     	stp	q0, q1, [x9]
 1081428: 94056da6     	bl	 <memset>
 108142c: 2a1f03e0     	mov	w0, wzr
 1081430: 17ffff49     	b	 <L10>
<L32>:
 1081434: f9411a64     	ldr	x4, [x19, #0x230]
 1081438: b40001e4     	cbz	x4,  <L34>
 108143c: 79498a68     	ldrh	w8, [x19, #0x4c4]
 1081440: 52826049     	mov	w9, #0x1302             // =4866
 1081444: 6b09011f     	cmp	w8, w9
 1081448: 1a9f17e8     	cset	w8, eq
 108144c: 6b09031f     	cmp	w24, w9
 1081450: 1a9f17e9     	cset	w9, eq
 1081454: 6b09011f     	cmp	w8, w9
 1081458: 54fff5e1     	b.ne	 <L28>
 108145c: f9411e65     	ldr	x5, [x19, #0x238]
 1081460: 52800028     	mov	w8, #0x1                // =1
 1081464: 3934ea68     	strb	w8, [x19, #0xd3a]
 1081468: 17ffffd0     	b	 <L31>
<L33>:
 108146c: 52800ae0     	mov	w0, #0x57               // =87
 1081470: 17ffff39     	b	 <L10>
<L34>:
 1081474: 911a73e0     	add	x0, sp, #0x69c
 1081478: 2a1f03e1     	mov	w1, wzr
 108147c: aa1403e2     	mov	x2, x20
 1081480: 94056d90     	bl	 <memset>
 1081484: 528003c0     	mov	w0, #0x1e               // =30
 1081488: 17ffff33     	b	 <L10>
<L35>:
 108148c: 911a73e0     	add	x0, sp, #0x69c
 1081490: 2a1f03e1     	mov	w1, wzr
 1081494: aa1403e2     	mov	x2, x20
 1081498: 2a0803f3     	mov	w19, w8
 108149c: 94056d89     	bl	 <memset>
 10814a0: 2a1303e0     	mov	w0, w19
 10814a4: 17ffff2c     	b	 <L10>
<L36>:
 10814a8: 6f00e400     	movi	v0.2d, #0000000000000000
 10814ac: 3d8012e0     	str	q0, [x23, #0x40]
 10814b0: 3d800ee0     	str	q0, [x23, #0x30]
 10814b4: 3d800ae0     	str	q0, [x23, #0x20]
 10814b8: 3d8006e0     	str	q0, [x23, #0x10]
 10814bc: 3d8002e0     	str	q0, [x23]
 10814c0: 17ffff25     	b	 <L10>
