
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001081028 <ClientHandshake.processServerHello>:
 1081028: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
 108102c: f9000bfc     	str	x28, [sp, #0x10]
 1081030: a90267fa     	stp	x26, x25, [sp, #0x20]
 1081034: a9035ff8     	stp	x24, x23, [sp, #0x30]
 1081038: a90457f6     	stp	x22, x21, [sp, #0x40]
 108103c: a9054ff4     	stp	x20, x19, [sp, #0x50]
 1081040: 910003fd     	mov	x29, sp
 1081044: d12483ff     	sub	sp, sp, #0x920
 1081048: 3974e408     	ldrb	w8, [x0, #0xd39]
 108104c: aa0203f4     	mov	x20, x2
 1081050: aa0003f3     	mov	x19, x0
 1081054: aa0103f5     	mov	x21, x1
 1081058: 91346402     	add	x2, x0, #0xd19
 108105c: 910003e4     	mov	x4, sp
 1081060: 92401503     	and	x3, x8, #0x3f
 1081064: aa0103e0     	mov	x0, x1
 1081068: aa1403e1     	mov	x1, x20
 108106c: 94000145     	bl	 <server_hello.parseWithSessionIdEcho>
 1081070: 72003c1f     	tst	w0, #0xffff
 1081074: 54000881     	b.ne	 <L10>
 1081078: 39557268     	ldrb	w8, [x19, #0x55c]
 108107c: 92400d08     	and	x8, x8, #0xf
 1081080: 34000188     	cbz	w8,  <L1>
 1081084: 794003f8     	ldrh	w24, [sp]
 1081088: d102e3b6     	sub	x22, x29, #0xb8
 108108c: 911f33f7     	add	x23, sp, #0x7cc
 1081090: 911ba3f9     	add	x25, sp, #0x6e8
 1081094: 5280a989     	mov	w9, #0x54c              // =1356
<L0>:
 1081098: 78696a6a     	ldrh	w10, [x19, x9]
 108109c: 6b18015f     	cmp	w10, w24
 10810a0: 540000c0     	b.eq	 <L2>
 10810a4: f1000508     	subs	x8, x8, #0x1
 10810a8: 91000929     	add	x9, x9, #0x2
 10810ac: 54ffff61     	b.ne	 <L0>
<L1>:
 10810b0: 52800ac0     	mov	w0, #0x56               // =86
 10810b4: 14000034     	b	 <L10>
<L2>:
 10810b8: 395a23e8     	ldrb	w8, [sp, #0x688]
 10810bc: 7100051f     	cmp	w8, #0x1
 10810c0: 540000ac     	b.gt	 <L4>
 10810c4: 35000288     	cbnz	w8,  <L7>
<L3>:
 10810c8: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 10810cc: 913aa129     	add	x9, x9, #0xea8
 10810d0: 14000013     	b	 <L8>
<L4>:
 10810d4: 7100091f     	cmp	w8, #0x2
 10810d8: 54000081     	b.ne	 <L6>
<L5>:
 10810dc: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 10810e0: 913ac129     	add	x9, x9, #0xeb0
 10810e4: 1400000e     	b	 <L8>
<L6>:
 10810e8: 794007e9     	ldrh	w9, [sp, #0x2]
 10810ec: 52823d4a     	mov	w10, #0x11ea            // =4586
 10810f0: 6b0a013f     	cmp	w9, w10
 10810f4: 5400058c     	b.gt	 <L11>
 10810f8: 71005d3f     	cmp	w9, #0x17
 10810fc: 540000c0     	b.eq	 <L7>
 1081100: 7100613f     	cmp	w9, #0x18
 1081104: 54fffec0     	b.eq	 <L5>
 1081108: 7100753f     	cmp	w9, #0x1d
 108110c: 54fffde0     	b.eq	 <L3>
 1081110: 14000058     	b	 <L17>
<L7>:
 1081114: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1081118: 913ab129     	add	x9, x9, #0xeac
<L8>:
 108111c: 79400129     	ldrh	w9, [x9]
 1081120: 7104013f     	cmp	w9, #0x100
 1081124: 540002e3     	b.lo	 <L9>
 1081128: 39758a6a     	ldrb	w10, [x19, #0xd62]
 108112c: 92400929     	and	x9, x9, #0x7
 1081130: 1200154a     	and	w10, w10, #0x3f
 1081134: 1ac92549     	lsr	w9, w10, w9
 1081138: 36000249     	tbz	w9, #0x0,  <L9>
 108113c: 39552a69     	ldrb	w9, [x19, #0x54a]
 1081140: 340004a9     	cbz	w9,  <L12>
 1081144: 39484269     	ldrb	w9, [x19, #0x210]
 1081148: 9101c26a     	add	x10, x19, #0x70
 108114c: 9103826b     	add	x11, x19, #0xe0
 1081150: 12000529     	and	w9, w9, #0x3
 1081154: 7100053f     	cmp	w9, #0x1
 1081158: 9a8b0149     	csel	x9, x10, x11, eq
 108115c: 79400129     	ldrh	w9, [x9]
 1081160: 6b09031f     	cmp	w24, w9
 1081164: 54000da1     	b.ne	 <L25>
 1081168: 794a9269     	ldrh	w9, [x19, #0x548]
 108116c: 7100051f     	cmp	w8, #0x1
 1081170: 5400072c     	b.gt	 <L15>
 1081174: 350008a8     	cbnz	w8,  <L19>
 1081178: 528003a8     	mov	w8, #0x1d               // =29
 108117c: 14000046     	b	 <L21>
<L9>:
 1081180: 52800aa0     	mov	w0, #0x55               // =85
<L10>:
 1081184: 912483ff     	add	sp, sp, #0x920
 1081188: a9454ff4     	ldp	x20, x19, [sp, #0x50]
 108118c: f9400bfc     	ldr	x28, [sp, #0x10]
 1081190: a94457f6     	ldp	x22, x21, [sp, #0x40]
 1081194: a9435ff8     	ldp	x24, x23, [sp, #0x30]
 1081198: a94267fa     	ldp	x26, x25, [sp, #0x20]
 108119c: a8c67bfd     	ldp	x29, x30, [sp], #0x60
 10811a0: d65f03c0     	ret
<L11>:
 10811a4: 52823d6a     	mov	w10, #0x11eb            // =4587
 10811a8: 6b0a013f     	cmp	w9, w10
 10811ac: 540005c0     	b.eq	 <L16>
 10811b0: 52823d8a     	mov	w10, #0x11ec            // =4588
 10811b4: 6b0a013f     	cmp	w9, w10
 10811b8: 54000620     	b.eq	 <L18>
 10811bc: 52823daa     	mov	w10, #0x11ed            // =4589
 10811c0: 6b0a013f     	cmp	w9, w10
 10811c4: 54000561     	b.ne	 <L17>
 10811c8: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 10811cc: 913af129     	add	x9, x9, #0xebc
 10811d0: 17ffffd3     	b	 <L8>
<L12>:
 10811d4: 52826048     	mov	w8, #0x1302             // =4866
 10811d8: 6b08031f     	cmp	w24, w8
 10811dc: 540002c1     	b.ne	 <L13>
 10811e0: ad478a61     	ldp	q1, q2, [x19, #0xf0]
 10811e4: 52800048     	mov	w8, #0x2                // =2
 10811e8: ad440e60     	ldp	q0, q3, [x19, #0x80]
 10811ec: 52826049     	mov	w9, #0x1302             // =4866
 10811f0: ad464266     	ldp	q6, q16, [x19, #0xc0]
 10811f4: 52801c0a     	mov	w10, #0xe0              // =224
 10811f8: ad040a61     	stp	q1, q2, [x19, #0x80]
 10811fc: ad488665     	ldp	q5, q1, [x19, #0x110]
 1081200: ad450a64     	ldp	q4, q2, [x19, #0xa0]
 1081204: 39084268     	strb	w8, [x19, #0x210]
 1081208: 52804048     	mov	w8, #0x202              // =514
 108120c: ad050665     	stp	q5, q1, [x19, #0xa0]
 1081210: 3dc01e65     	ldr	q5, [x19, #0x70]
 1081214: ad498667     	ldp	q7, q1, [x19, #0x130]
 1081218: ad011263     	stp	q3, q4, [x19, #0x20]
 108121c: ad000265     	stp	q5, q0, [x19]
 1081220: 3dc03a60     	ldr	q0, [x19, #0xe0]
 1081224: ad021a62     	stp	q2, q6, [x19, #0x40]
 1081228: ad030270     	stp	q16, q0, [x19, #0x60]
 108122c: ad060667     	stp	q7, q1, [x19, #0xc0]
 1081230: 14000006     	b	 <L14>
<L13>:
 1081234: 52800028     	mov	w8, #0x1                // =1
 1081238: 52800e0a     	mov	w10, #0x70              // =112
 108123c: 2a1803e9     	mov	w9, w24
 1081240: 39084268     	strb	w8, [x19, #0x210]
 1081244: 52802648     	mov	w8, #0x132              // =306
<L14>:
 1081248: 782a6a69     	strh	w9, [x19, x10]
 108124c: 38286a7f     	strb	wzr, [x19, x8]
 1081250: 14000013     	b	 <L22>
<L15>:
 1081254: 7100091f     	cmp	w8, #0x2
 1081258: 540001c1     	b.ne	 <L20>
 108125c: 52800308     	mov	w8, #0x18               // =24
 1081260: 1400000d     	b	 <L21>
<L16>:
 1081264: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1081268: 913ad129     	add	x9, x9, #0xeb4
 108126c: 17ffffac     	b	 <L8>
<L17>:
 1081270: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1081274: 913af929     	add	x9, x9, #0xebe
 1081278: 17ffffa9     	b	 <L8>
<L18>:
 108127c: 90fffc49     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1081280: 913ae129     	add	x9, x9, #0xeb8
 1081284: 17ffffa6     	b	 <L8>
<L19>:
 1081288: 528002e8     	mov	w8, #0x17               // =23
 108128c: 14000002     	b	 <L21>
<L20>:
 1081290: 794007e8     	ldrh	w8, [sp, #0x2]
<L21>:
 1081294: 6b09011f     	cmp	w8, w9
 1081298: 54000401     	b.ne	 <L25>
<L22>:
 108129c: aa1303e0     	mov	x0, x19
 10812a0: aa1503e1     	mov	x1, x21
 10812a4: aa1403e2     	mov	x2, x20
 10812a8: 910003fa     	mov	x26, sp
 10812ac: 97fff6cd     	bl	 <ClientHandshake.Suite.update>
 10812b0: 395a23e8     	ldrb	w8, [sp, #0x688]
 10812b4: 12000508     	and	w8, w8, #0x3
 10812b8: 7100051f     	cmp	w8, #0x1
 10812bc: 5400032c     	b.gt	 <L26>
 10812c0: 35000c08     	cbnz	w8,  <L29>
 10812c4: 911ba3e0     	add	x0, sp, #0x6e8
 10812c8: 91278e61     	add	x1, x19, #0x9e3
 10812cc: b27f0342     	orr	x2, x26, #0x2
 10812d0: 94000241     	bl	 <x25519.sharedSecret>
 10812d4: 794dd3e0     	ldrh	w0, [sp, #0x6e8]
 10812d8: 35fff560     	cbnz	w0,  <L10>
 10812dc: 3cc02320     	ldur	q0, [x25, #0x2]
 10812e0: 3cc12321     	ldur	q1, [x25, #0x12]
 10812e4: 3d81a7e0     	str	q0, [sp, #0x690]
 10812e8: 52800414     	mov	w20, #0x20              // =32
 10812ec: 3d81abe1     	str	q1, [sp, #0x6a0]
 10812f0: 395a33e8     	ldrb	w8, [sp, #0x68c]
 10812f4: 340005a8     	cbz	w8,  <L27>
<L23>:
 10812f8: 794d17e8     	ldrh	w8, [sp, #0x68a]
 10812fc: 34000fa8     	cbz	w8,  <L31>
<L24>:
 1081300: 911a43e0     	add	x0, sp, #0x690
 1081304: 2a1f03e1     	mov	w1, wzr
 1081308: aa1403e2     	mov	x2, x20
 108130c: 94056f2d     	bl	 <memset>
 1081310: 52800940     	mov	w0, #0x4a               // =74
 1081314: 17ffff9c     	b	 <L10>
<L25>:
 1081318: 52800940     	mov	w0, #0x4a               // =74
 108131c: 17ffff9a     	b	 <L10>
<L26>:
 1081320: 7100091f     	cmp	w8, #0x2
 1081324: 54000aa1     	b.ne	 <L30>
 1081328: 912a1268     	add	x8, x19, #0xa84
 108132c: 79562a69     	ldrh	w9, [x19, #0xb14]
 1081330: 911f33e0     	add	x0, sp, #0x7cc
 1081334: ad430500     	ldp	q0, q1, [x8, #0x60]
 1081338: 3dc02102     	ldr	q2, [x8, #0x80]
 108133c: 911cc3e1     	add	x1, sp, #0x730
 1081340: b27f0342     	orr	x2, x26, #0x2
 1081344: 790f83e9     	strh	w9, [sp, #0x7c0]
 1081348: 3d81efe2     	str	q2, [sp, #0x7b0]
 108134c: 3d81e7e0     	str	q0, [sp, #0x790]
 1081350: 3d81ebe1     	str	q1, [sp, #0x7a0]
 1081354: ad410500     	ldp	q0, q1, [x8, #0x20]
 1081358: 3d81d7e0     	str	q0, [sp, #0x750]
 108135c: ad420102     	ldp	q2, q0, [x8, #0x40]
 1081360: 3d81dbe1     	str	q1, [sp, #0x760]
 1081364: 3d81e3e0     	str	q0, [sp, #0x780]
 1081368: ad400101     	ldp	q1, q0, [x8]
 108136c: 3d81dfe2     	str	q2, [sp, #0x770]
 1081370: 3d81cfe1     	str	q1, [sp, #0x730]
 1081374: 3d81d3e0     	str	q0, [sp, #0x740]
 1081378: 940002c1     	bl	 <p384.sharedSecret>
 108137c: 794f9be0     	ldrh	w0, [sp, #0x7cc]
 1081380: 35fff020     	cbnz	w0,  <L10>
 1081384: 3cce6320     	ldur	q0, [x25, #0xe6]
 1081388: 3ccf6321     	ldur	q1, [x25, #0xf6]
 108138c: 52800614     	mov	w20, #0x30              // =48
 1081390: 3cc222e2     	ldur	q2, [x23, #0x22]
 1081394: 3d81a7e0     	str	q0, [sp, #0x690]
 1081398: 3d81abe1     	str	q1, [sp, #0x6a0]
 108139c: 3d81afe2     	str	q2, [sp, #0x6b0]
 10813a0: 395a33e8     	ldrb	w8, [sp, #0x68c]
 10813a4: 35fffaa8     	cbnz	w8,  <L23>
<L27>:
 10813a8: aa1f03e4     	mov	x4, xzr
 10813ac: aa1f03e5     	mov	x5, xzr
<L28>:
 10813b0: d102e3a0     	sub	x0, x29, #0xb8
 10813b4: 911a43e2     	add	x2, sp, #0x690
 10813b8: aa1303e1     	mov	x1, x19
 10813bc: aa1403e3     	mov	x3, x20
 10813c0: 9400038b     	bl	 <ClientHandshake.Suite.deriveHandshakeKeys>
 10813c4: 785f83a8     	ldurh	w8, [x29, #-0x8]
 10813c8: 35000c08     	cbnz	w8,  <L34>
 10813cc: 3ccbc2e0     	ldur	q0, [x23, #0xbc]
 10813d0: 3cccc2e1     	ldur	q1, [x23, #0xcc]
 10813d4: 911a43e0     	add	x0, sp, #0x690
 10813d8: f85983a8     	ldur	x8, [x29, #-0x68]
 10813dc: 3ccdc2e2     	ldur	q2, [x23, #0xdc]
 10813e0: 2a1f03e1     	mov	w1, wzr
 10813e4: ad140660     	stp	q0, q1, [x19, #0x280]
 10813e8: 3cc9c2e0     	ldur	q0, [x23, #0x9c]
 10813ec: aa1403e2     	mov	x2, x20
 10813f0: 3ccac2e1     	ldur	q1, [x23, #0xac]
 10813f4: f85f03a9     	ldur	x9, [x29, #-0x10]
 10813f8: f9015a68     	str	x8, [x19, #0x2b0]
 10813fc: 910ae268     	add	x8, x19, #0x2b8
 1081400: 3d80aa62     	str	q2, [x19, #0x2a0]
 1081404: 3cc982c2     	ldur	q2, [x22, #0x98]
 1081408: ad130660     	stp	q0, q1, [x19, #0x260]
 108140c: 3cc782c0     	ldur	q0, [x22, #0x78]
 1081410: 3cc882c1     	ldur	q1, [x22, #0x88]
 1081414: f9018669     	str	x9, [x19, #0x308]
 1081418: 52800049     	mov	w9, #0x2                // =2
 108141c: ad010500     	stp	q0, q1, [x8, #0x20]
 1081420: 3cc582c0     	ldur	q0, [x22, #0x58]
 1081424: 3cc682c1     	ldur	q1, [x22, #0x68]
 1081428: 3d801102     	str	q2, [x8, #0x40]
 108142c: ad000500     	stp	q0, q1, [x8]
 1081430: 3934f269     	strb	w9, [x19, #0xd3c]
 1081434: 94056ee3     	bl	 <memset>
 1081438: 2a1f03e0     	mov	w0, wzr
 108143c: 17ffff52     	b	 <L10>
<L29>:
 1081440: 911c33e0     	add	x0, sp, #0x70c
 1081444: 91288e61     	add	x1, x19, #0xa23
 1081448: b27f0342     	orr	x2, x26, #0x2
 108144c: 94000241     	bl	 <p256.sharedSecret>
 1081450: 794e1be0     	ldrh	w0, [sp, #0x70c]
 1081454: 35ffe980     	cbnz	w0,  <L10>
 1081458: 3cc26320     	ldur	q0, [x25, #0x26]
 108145c: 3cc36321     	ldur	q1, [x25, #0x36]
 1081460: 3d81a7e0     	str	q0, [sp, #0x690]
 1081464: 52800414     	mov	w20, #0x20              // =32
 1081468: 3d81abe1     	str	q1, [sp, #0x6a0]
 108146c: 395a33e8     	ldrb	w8, [sp, #0x68c]
 1081470: 35fff448     	cbnz	w8,  <L23>
 1081474: 17ffffcd     	b	 <L27>
<L30>:
 1081478: 39496268     	ldrb	w8, [x19, #0x258]
 108147c: 34000568     	cbz	w8,  <L32>
 1081480: 7944a268     	ldrh	w8, [x19, #0x250]
 1081484: 794007e9     	ldrh	w9, [sp, #0x2]
 1081488: 6b09011f     	cmp	w8, w9
 108148c: 540004e1     	b.ne	 <L32>
 1081490: 79400be8     	ldrh	w8, [sp, #0x4]
 1081494: 910003e9     	mov	x9, sp
 1081498: d10343a0     	sub	x0, x29, #0xd0
 108149c: 91090261     	add	x1, x19, #0x240
 10814a0: 91001922     	add	x2, x9, #0x6
 10814a4: 91278e64     	add	x4, x19, #0x9e3
 10814a8: 92402903     	and	x3, x8, #0x7ff
 10814ac: 912003e5     	add	x5, sp, #0x800
 10814b0: 940002c9     	bl	 <hybrid_kex.decapsulate>
 10814b4: 785403a0     	ldurh	w0, [x29, #-0xc0]
 10814b8: 35000560     	cbnz	w0,  <L35>
 10814bc: a97353a1     	ldp	x1, x20, [x29, #-0xd0]
 10814c0: 911a43e0     	add	x0, sp, #0x690
 10814c4: aa1403e2     	mov	x2, x20
 10814c8: 94056e80     	bl	 <memcpy>
 10814cc: 6f00e400     	movi	v0.2d, #0000000000000000
 10814d0: 3d8203e0     	str	q0, [sp, #0x800]
 10814d4: 3d8207e0     	str	q0, [sp, #0x810]
 10814d8: 3d820be0     	str	q0, [sp, #0x820]
 10814dc: 3d820fe0     	str	q0, [sp, #0x830]
 10814e0: 3d8213e0     	str	q0, [sp, #0x840]
 10814e4: 395a33e8     	ldrb	w8, [sp, #0x68c]
 10814e8: 35fff088     	cbnz	w8,  <L23>
 10814ec: 17ffffaf     	b	 <L27>
<L31>:
 10814f0: f9411a64     	ldr	x4, [x19, #0x230]
 10814f4: b40001e4     	cbz	x4,  <L33>
 10814f8: 79498a68     	ldrh	w8, [x19, #0x4c4]
 10814fc: 52826049     	mov	w9, #0x1302             // =4866
 1081500: 6b09011f     	cmp	w8, w9
 1081504: 1a9f17e8     	cset	w8, eq
 1081508: 6b09031f     	cmp	w24, w9
 108150c: 1a9f17e9     	cset	w9, eq
 1081510: 6b09011f     	cmp	w8, w9
 1081514: 54ffef61     	b.ne	 <L24>
 1081518: f9411e65     	ldr	x5, [x19, #0x238]
 108151c: 52800028     	mov	w8, #0x1                // =1
 1081520: 3934ea68     	strb	w8, [x19, #0xd3a]
 1081524: 17ffffa3     	b	 <L28>
<L32>:
 1081528: 52800ae0     	mov	w0, #0x57               // =87
 108152c: 17ffff16     	b	 <L10>
<L33>:
 1081530: 911a43e0     	add	x0, sp, #0x690
 1081534: 2a1f03e1     	mov	w1, wzr
 1081538: aa1403e2     	mov	x2, x20
 108153c: 94056ea1     	bl	 <memset>
 1081540: 528003c0     	mov	w0, #0x1e               // =30
 1081544: 17ffff10     	b	 <L10>
<L34>:
 1081548: 911a43e0     	add	x0, sp, #0x690
 108154c: 2a1f03e1     	mov	w1, wzr
 1081550: aa1403e2     	mov	x2, x20
 1081554: 2a0803f3     	mov	w19, w8
 1081558: 94056e9a     	bl	 <memset>
 108155c: 2a1303e0     	mov	w0, w19
 1081560: 17ffff09     	b	 <L10>
<L35>:
 1081564: 6f00e400     	movi	v0.2d, #0000000000000000
 1081568: 3d8213e0     	str	q0, [sp, #0x840]
 108156c: 3d820fe0     	str	q0, [sp, #0x830]
 1081570: 3d820be0     	str	q0, [sp, #0x820]
 1081574: 3d8207e0     	str	q0, [sp, #0x810]
 1081578: 3d8203e0     	str	q0, [sp, #0x800]
 108157c: 17ffff02     	b	 <L10>
