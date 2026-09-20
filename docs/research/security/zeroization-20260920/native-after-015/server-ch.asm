
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010863b0 <ServerHandshake.processClientHelloMessage>:
 10863b0: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
 10863b4: a9016ffc     	stp	x28, x27, [sp, #0x10]
 10863b8: a90267fa     	stp	x26, x25, [sp, #0x20]
 10863bc: a9035ff8     	stp	x24, x23, [sp, #0x30]
 10863c0: a90457f6     	stp	x22, x21, [sp, #0x40]
 10863c4: a9054ff4     	stp	x20, x19, [sp, #0x50]
 10863c8: 910003fd     	mov	x29, sp
 10863cc: d1400bff     	sub	sp, sp, #0x2, lsl #12   // =0x2000
 10863d0: d10483ff     	sub	sp, sp, #0x120
 10863d4: 9140103c     	add	x28, x1, #0x4, lsl #12  // =0x4000
 10863d8: aa0103f3     	mov	x19, x1
 10863dc: 39690b88     	ldrb	w8, [x28, #0xa42]
 10863e0: 12000508     	and	w8, w8, #0x3
 10863e4: 7100091f     	cmp	w8, #0x2
 10863e8: 54000061     	b.ne	 <L0>
 10863ec: 39290b9f     	strb	wzr, [x28, #0xa42]
 10863f0: b905767f     	str	wzr, [x19, #0x574]
<L0>:
 10863f4: f941d668     	ldr	x8, [x19, #0x3a8]
 10863f8: f1000d1f     	cmp	x8, #0x3
 10863fc: 54000468     	b.hi	 <L4>
 1086400: 3966c794     	ldrb	w20, [x28, #0x9b1]
 1086404: b4000608     	cbz	x8,  <L9>
 1086408: f941d269     	ldr	x9, [x19, #0x3a0]
 108640c: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 1086410: 7940012a     	ldrh	w10, [x9]
 1086414: 0b0b014a     	add	w10, w10, w11
 1086418: 7100095f     	cmp	w10, #0x2
 108641c: 54000368     	b.hi	 <L4>
 1086420: f100051f     	cmp	x8, #0x1
 1086424: aa0903ea     	mov	x10, x9
 1086428: aa0803eb     	mov	x11, x8
 108642c: 540001e1     	b.ne	 <L3>
<L1>:
 1086430: 7840254c     	ldrh	w12, [x10], #0x2
 1086434: 12823d4d     	mov	w13, #-0x11eb           // =-4587
 1086438: 0b0d018c     	add	w12, w12, w13
 108643c: 71000d9f     	cmp	w12, #0x3
 1086440: 540003a2     	b.hs	 <L7>
 1086444: f100056b     	subs	x11, x11, #0x1
 1086448: 54ffff41     	b.ne	 <L1>
 108644c: 52823daa     	mov	w10, #0x11ed            // =4589
<L2>:
 1086450: 7840252b     	ldrh	w11, [x9], #0x2
 1086454: 6b0a017f     	cmp	w11, w10
 1086458: 54000320     	b.eq	 <L8>
 108645c: f1000508     	subs	x8, x8, #0x1
 1086460: 54ffff81     	b.ne	 <L2>
 1086464: 14000018     	b	 <L9>
<L3>:
 1086468: 7940052a     	ldrh	w10, [x9, #0x2]
 108646c: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 1086470: 0b0b014b     	add	w11, w10, w11
 1086474: 7100097f     	cmp	w11, #0x2
 1086478: 54000088     	b.hi	 <L4>
 108647c: 7940012b     	ldrh	w11, [x9]
 1086480: 6b0a017f     	cmp	w11, w10
 1086484: 54001721     	b.ne	 <L24>
<L4>:
 1086488: 52800788     	mov	w8, #0x3c               // =60
<L5>:
 108648c: 79002008     	strh	w8, [x0, #0x10]
<L6>:
 1086490: 91400bff     	add	sp, sp, #0x2, lsl #12   // =0x2000
 1086494: 910483ff     	add	sp, sp, #0x120
 1086498: a9454ff4     	ldp	x20, x19, [sp, #0x50]
 108649c: a94457f6     	ldp	x22, x21, [sp, #0x40]
 10864a0: a9435ff8     	ldp	x24, x23, [sp, #0x30]
 10864a4: a94267fa     	ldp	x26, x25, [sp, #0x20]
 10864a8: a9416ffc     	ldp	x28, x27, [sp, #0x10]
 10864ac: a8c67bfd     	ldp	x29, x30, [sp], #0x60
 10864b0: d65f03c0     	ret
<L7>:
 10864b4: 528007a8     	mov	w8, #0x3d               // =61
 10864b8: 17fffff5     	b	 <L5>
<L8>:
 10864bc: 396f1f88     	ldrb	w8, [x28, #0xbc7]
 10864c0: 34002ac8     	cbz	w8,  <L35>
<L9>:
 10864c4: f9005be0     	str	x0, [sp, #0xb0]
 10864c8: 9102e3e0     	add	x0, sp, #0xb8
 10864cc: aa0203f5     	mov	x21, x2
 10864d0: aa0203e1     	mov	x1, x2
 10864d4: aa0303e2     	mov	x2, x3
 10864d8: f90047e5     	str	x5, [sp, #0x88]
 10864dc: a90a0fe4     	stp	x4, x3, [sp, #0xa0]
 10864e0: 97ffd5f1     	bl	 <client_hello.parse>
 10864e4: 794493e8     	ldrh	w8, [sp, #0x248]
 10864e8: 35012528     	cbnz	w8,  <L174>
 10864ec: 52893148     	mov	w8, #0x498a             // =18826
 10864f0: 52893229     	mov	w9, #0x4991             // =18833
 10864f4: 914007f9     	add	x25, sp, #0x1, lsl #12  // =0x1000
 10864f8: 914007fb     	add	x27, sp, #0x1, lsl #12  // =0x1000
 10864fc: 910943e0     	add	x0, sp, #0x250
 1086500: 9102e3e1     	add	x1, sp, #0xb8
 1086504: 52803202     	mov	w2, #0x190              // =400
 1086508: 8b08027a     	add	x26, x19, x8
 108650c: 8b090276     	add	x22, x19, x9
 1086510: 913fc339     	add	x25, x25, #0xff0
 1086514: 9118037b     	add	x27, x27, #0x600
 1086518: 910f83f8     	add	x24, sp, #0x3e0
 108651c: 910943f7     	add	x23, sp, #0x250
 1086520: 94055942     	bl	 <memcpy>
 1086524: 910f83e0     	add	x0, sp, #0x3e0
 1086528: 9102e3e1     	add	x1, sp, #0xb8
 108652c: 52803202     	mov	w2, #0x190              // =400
 1086530: 9405593e     	bl	 <memcpy>
 1086534: 340003d4     	cbz	w20,  <L13>
 1086538: 3cc17340     	ldur	q0, [x26, #0x17]
 108653c: 9115c3e0     	add	x0, sp, #0x570
 1086540: 9102e3e1     	add	x1, sp, #0xb8
 1086544: 3d801fe0     	str	q0, [sp, #0x70]
 1086548: 3dc002c0     	ldr	q0, [x22]
 108654c: 3d8027e0     	str	q0, [sp, #0x90]
 1086550: 94008207     	bl	 <ServerHandshake.retryClientHelloDigest>
 1086554: 3dc06700     	ldr	q0, [x24, #0x190]
 1086558: 3dc027e1     	ldr	q1, [sp, #0x90]
 108655c: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 1086560: 6e205800     	mvn	v0.16b, v0.16b
 1086564: 6e30a800     	umaxv	b0, v0.16b
 1086568: 1e260008     	fmov	w8, s0
 108656c: 37000108     	tbnz	w8, #0x0,  <L10>
 1086570: 3dc06b00     	ldr	q0, [x24, #0x1a0]
 1086574: 3dc01fe1     	ldr	q1, [sp, #0x70]
 1086578: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 108657c: 6e205800     	mvn	v0.16b, v0.16b
 1086580: 6e30a800     	umaxv	b0, v0.16b
 1086584: 1e260008     	fmov	w8, s0
 1086588: 36000b68     	tbz	w8, #0x0,  <L22>
<L10>:
 108658c: f0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1086590: 910e0108     	add	x8, x8, #0x380
 1086594: 3dc00100     	ldr	q0, [x8]
 1086598: 52800948     	mov	w8, #0x4a               // =74
<L11>:
 108659c: f9405be9     	ldr	x9, [sp, #0xb0]
<L12>:
 10865a0: 3d800120     	str	q0, [x9]
 10865a4: f9000928     	str	x8, [x9, #0x10]
 10865a8: 17ffffba     	b	 <L6>
<L13>:
 10865ac: f9405be8     	ldr	x8, [sp, #0xb0]
 10865b0: f90037f6     	str	x22, [sp, #0x68]
 10865b4: 91063ef2     	add	x18, x23, #0x18f
<L14>:
 10865b8: 3943c279     	ldrb	w25, [x19, #0xf0]
 10865bc: 34000699     	cbz	w25,  <L18>
 10865c0: 79530a74     	ldrh	w20, [x19, #0x984]
<L15>:
 10865c4: f9004bf2     	str	x18, [sp, #0x90]
 10865c8: f941de77     	ldr	x23, [x19, #0x3b8]
 10865cc: f941da62     	ldr	x2, [x19, #0x3b0]
 10865d0: f94213e0     	ldr	x0, [sp, #0x420]
 10865d4: f94217e1     	ldr	x1, [sp, #0x428]
 10865d8: 79130a74     	strh	w20, [x19, #0x984]
 10865dc: aa1703e3     	mov	x3, x23
 10865e0: 94006753     	bl	 <client_hello.Parsed.selectAlpn>
 10865e4: f9414fe8     	ldr	x8, [sp, #0x298]
 10865e8: f9020a60     	str	x0, [x19, #0x410]
 10865ec: f9020e61     	str	x1, [x19, #0x418]
 10865f0: b4000108     	cbz	x8,  <L16>
 10865f4: b40000f7     	cbz	x23,  <L16>
 10865f8: b50000c0     	cbnz	x0,  <L16>
 10865fc: f0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1086600: 910ec108     	add	x8, x8, #0x3b0
 1086604: 3dc00100     	ldr	q0, [x8]
 1086608: 52800d68     	mov	w8, #0x6b               // =107
 108660c: 17ffffe4     	b	 <L11>
<L16>:
 1086610: f94143e9     	ldr	x9, [sp, #0x280]
 1086614: f94147ea     	ldr	x10, [sp, #0x288]
 1086618: 911683f7     	add	x23, sp, #0x5a0
 108661c: f94187e8     	ldr	x8, [sp, #0x308]
 1086620: f9021269     	str	x9, [x19, #0x420]
 1086624: f9405be9     	ldr	x9, [sp, #0xb0]
 1086628: f902166a     	str	x10, [x19, #0x428]
 108662c: b4000c28     	cbz	x8,  <L25>
 1086630: f9418be9     	ldr	x9, [sp, #0x310]
 1086634: b4003589     	cbz	x9,  <L53>
 1086638: f100853f     	cmp	x9, #0x21
 108663c: 54000e23     	b.lo	 <L31>
 1086640: 4f00e420     	movi	v0.16b, #0x1
 1086644: aa1f03eb     	mov	x11, xzr
<L17>:
 1086648: 3ceb6901     	ldr	q1, [x8, x11]
 108664c: 6e208c21     	cmeq	v1.16b, v1.16b, v0.16b
 1086650: 6e30a821     	umaxv	b1, v1.16b
 1086654: 1e26002a     	fmov	w10, s1
 1086658: 37000fca     	tbnz	w10, #0x0,  <L34>
 108665c: 8b0b010a     	add	x10, x8, x11
 1086660: 3dc00541     	ldr	q1, [x10, #0x10]
 1086664: 6e208c21     	cmeq	v1.16b, v1.16b, v0.16b
 1086668: 6e30a821     	umaxv	b1, v1.16b
 108666c: 1e26002a     	fmov	w10, s1
 1086670: 37000f0a     	tbnz	w10, #0x0,  <L34>
 1086674: 9101016c     	add	x12, x11, #0x40
 1086678: 9100816a     	add	x10, x11, #0x20
 108667c: eb09019f     	cmp	x12, x9
 1086680: aa0a03eb     	mov	x11, x10
 1086684: 54fffe23     	b.lo	 <L17>
 1086688: 1400005f     	b	 <L32>
<L18>:
 108668c: f941ce69     	ldr	x9, [x19, #0x398]
 1086690: b4000a09     	cbz	x9,  <L26>
 1086694: f9412fea     	ldr	x10, [sp, #0x258]
 1086698: b40009ca     	cbz	x10,  <L26>
 108669c: f941ca6c     	ldr	x12, [x19, #0x390]
 10866a0: f9412bed     	ldr	x13, [sp, #0x250]
 10866a4: aa1f03eb     	mov	x11, xzr
 10866a8: 1282606e     	mov	w14, #-0x1304           // =-4868
 10866ac: 529fffaf     	mov	w15, #0xfffd            // =65533
 10866b0: 14000004     	b	 <L20>
<L19>:
 10866b4: 9100056b     	add	x11, x11, #0x1
 10866b8: eb09017f     	cmp	x11, x9
 10866bc: 540008a0     	b.eq	 <L26>
<L20>:
 10866c0: 786b7994     	ldrh	w20, [x12, x11, lsl #1]
 10866c4: 0b0e0290     	add	w16, w20, w14
 10866c8: 6b3021ff     	cmp	w15, w16, uxth
 10866cc: 54ffff48     	b.hi	 <L19>
 10866d0: aa1f03f0     	mov	x16, xzr
<L21>:
 10866d4: 787069b1     	ldrh	w17, [x13, x16]
 10866d8: 5ac00a31     	rev	w17, w17
 10866dc: 6b51429f     	cmp	w20, w17, lsr #16
 10866e0: 54fff720     	b.eq	 <L15>
 10866e4: 91000a10     	add	x16, x16, #0x2
 10866e8: eb0a021f     	cmp	x16, x10
 10866ec: 54ffff43     	b.lo	 <L21>
 10866f0: 17fffff1     	b	 <L19>
<L22>:
 10866f4: 3940a34a     	ldrb	w10, [x26, #0x28]
 10866f8: f94243e9     	ldr	x9, [sp, #0x480]
 10866fc: aa1603ee     	mov	x14, x22
 1086700: f9405be8     	ldr	x8, [sp, #0xb0]
 1086704: 3600074a     	tbz	w10, #0x0,  <L28>
 1086708: 5289366a     	mov	w10, #0x49b3            // =18867
 108670c: 8b0a026a     	add	x10, x19, x10
 1086710: ad428540     	ldp	q0, q1, [x10, #0x50]
 1086714: 3d829360     	str	q0, [x27, #0xa40]
 1086718: 3dc01d40     	ldr	q0, [x10, #0x70]
 108671c: 3d829761     	str	q1, [x27, #0xa50]
 1086720: 3cc79141     	ldur	q1, [x10, #0x79]
 1086724: 3d829b60     	str	q0, [x27, #0xa60]
 1086728: ad408d40     	ldp	q0, q3, [x10, #0x10]
 108672c: 3c879321     	stur	q1, [x25, #0x79]
 1086730: ad418941     	ldp	q1, q2, [x10, #0x30]
 1086734: 3942232b     	ldrb	w11, [x25, #0x88]
 1086738: ad010723     	stp	q3, q1, [x25, #0x20]
 108673c: 3dc00141     	ldr	q1, [x10]
 1086740: f94247ea     	ldr	x10, [sp, #0x488]
 1086744: 92400d76     	and	x22, x11, #0xf
 1086748: 3d801322     	str	q2, [x25, #0x40]
 108674c: ad000321     	stp	q1, q0, [x25]
 1086750: b4001689     	cbz	x9,  <L36>
 1086754: f100095f     	cmp	x10, #0x2
 1086758: 54001982     	b.hs	 <L40>
<L23>:
 108675c: 528001e9     	mov	w9, #0xf                // =15
 1086760: 79002109     	strh	w9, [x8, #0x10]
 1086764: 17ffff4b     	b	 <L6>
<L24>:
 1086768: f100091f     	cmp	x8, #0x2
 108676c: aa0903ea     	mov	x10, x9
 1086770: aa0803eb     	mov	x11, x8
 1086774: 54ffe5e0     	b.eq	 <L1>
 1086778: 7940092a     	ldrh	w10, [x9, #0x4]
 108677c: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 1086780: 0b0b014b     	add	w11, w10, w11
 1086784: 7100097f     	cmp	w11, #0x2
 1086788: 54ffe808     	b.hi	 <L4>
 108678c: 7940012b     	ldrh	w11, [x9]
 1086790: 6b0a017f     	cmp	w11, w10
 1086794: 54ffe7a0     	b.eq	 <L4>
 1086798: 7940052b     	ldrh	w11, [x9, #0x2]
 108679c: 6b0a017f     	cmp	w11, w10
 10867a0: aa0903ea     	mov	x10, x9
 10867a4: aa0803eb     	mov	x11, x8
 10867a8: 54ffe441     	b.ne	 <L1>
 10867ac: 17ffff37     	b	 <L4>
<L25>:
 10867b0: f9417be8     	ldr	x8, [sp, #0x2f0]
 10867b4: 39001b5f     	strb	wzr, [x26, #0x6]
 10867b8: b4002988     	cbz	x8,  <L54>
 10867bc: f0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 10867c0: 910f2108     	add	x8, x8, #0x3c8
 10867c4: 3dc00100     	ldr	q0, [x8]
 10867c8: 528008c8     	mov	w8, #0x46               // =70
 10867cc: 17ffff75     	b	 <L12>
<L26>:
 10867d0: f0fffc09     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10867d4: 910e6129     	add	x9, x9, #0x398
 10867d8: 3dc00120     	ldr	q0, [x9]
 10867dc: 52800ac9     	mov	w9, #0x56               // =86
<L27>:
 10867e0: 3d800100     	str	q0, [x8]
 10867e4: f9000909     	str	x9, [x8, #0x10]
 10867e8: 17ffff2a     	b	 <L6>
<L28>:
 10867ec: f90033fa     	str	x26, [sp, #0x60]
 10867f0: b4001329     	cbz	x9,  <L39>
<L29>:
 10867f4: 52800949     	mov	w9, #0x4a               // =74
<L30>:
 10867f8: 79002109     	strh	w9, [x8, #0x10]
 10867fc: 17ffff25     	b	 <L6>
<L31>:
 1086800: aa1f03ea     	mov	x10, xzr
<L32>:
 1086804: 9100414b     	add	x11, x10, #0x10
 1086808: eb09017f     	cmp	x11, x9
 108680c: 54000102     	b.hs	 <L33>
 1086810: 4f00e420     	movi	v0.16b, #0x1
 1086814: 3cea6901     	ldr	q1, [x8, x10]
 1086818: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 108681c: 6e30a800     	umaxv	b0, v0.16b
 1086820: 1e26000a     	fmov	w10, s0
 1086824: 3700016a     	tbnz	w10, #0x0,  <L34>
 1086828: aa0b03ea     	mov	x10, x11
<L33>:
 108682c: 9100214b     	add	x11, x10, #0x8
 1086830: eb09017f     	cmp	x11, x9
 1086834: 54002482     	b.hs	 <L51>
 1086838: 0f00e420     	movi	v0.8b, #0x1
 108683c: fc6a6901     	ldr	d1, [x8, x10]
 1086840: 2e208c20     	cmeq	v0.8b, v1.8b, v0.8b
 1086844: 2e30a800     	umaxv	b0, v0.8b
 1086848: 1e26000a     	fmov	w10, s0
 108684c: 360023aa     	tbz	w10, #0x0,  <L50>
<L34>:
 1086850: f9417be8     	ldr	x8, [sp, #0x2f0]
 1086854: 52800029     	mov	w9, #0x1                // =1
 1086858: 39001b49     	strb	w9, [x26, #0x6]
 108685c: b4002468     	cbz	x8,  <L54>
 1086860: 3943a748     	ldrb	w8, [x26, #0xe9]
 1086864: 7200051f     	tst	w8, #0x3
 1086868: 54002401     	b.ne	 <L54>
 108686c: 394e2268     	ldrb	w8, [x19, #0x388]
 1086870: 340023c8     	cbz	w8,  <L54>
 1086874: 910de268     	add	x8, x19, #0x378
 1086878: 7100033f     	cmp	w25, #0x0
 108687c: 911683e0     	add	x0, sp, #0x5a0
 1086880: 3dc00100     	ldr	q0, [x8]
 1086884: 9a9303e5     	csel	x5, xzr, x19, eq
 1086888: 910943e1     	add	x1, sp, #0x250
 108688c: 911643e3     	add	x3, sp, #0x590
 1086890: aa1503e2     	mov	x2, x21
 1086894: 2a1403e4     	mov	w4, w20
 1086898: 3d806f00     	str	q0, [x24, #0x1b0]
 108689c: 911683f9     	add	x25, sp, #0x5a0
 10868a0: 97fffcb8     	bl	 <ServerHandshake.selectPskWithTranscript>
 10868a4: 794ba3e8     	ldrh	w8, [sp, #0x5d0]
 10868a8: 35010728     	cbnz	w8,  <L174>
 10868ac: 395723e8     	ldrb	w8, [sp, #0x5c8]
 10868b0: 340021c8     	cbz	w8,  <L54>
 10868b4: 7841532a     	ldurh	w10, [x25, #0x15]
 10868b8: 9115566b     	add	x11, x19, #0x555
 10868bc: 3841732c     	ldurb	w12, [x25, #0x17]
 10868c0: f942d3e1     	ldr	x1, [sp, #0x5a0]
 10868c4: f942d7e2     	ldr	x2, [sp, #0x5a8]
 10868c8: b945b3e8     	ldr	w8, [sp, #0x5b0]
 10868cc: 7900016a     	strh	w10, [x11]
 10868d0: 794b7fea     	ldrh	w10, [sp, #0x5be]
 10868d4: b841a2eb     	ldur	w11, [x23, #0x1a]
 10868d8: 39155e6c     	strb	w12, [x19, #0x557]
 10868dc: 91156a6c     	add	x12, x19, #0x55a
 10868e0: 3956d3e9     	ldrb	w9, [sp, #0x5b4]
 10868e4: 790abe6a     	strh	w10, [x19, #0x55e]
 10868e8: f9404bea     	ldr	x10, [sp, #0x90]
 10868ec: 794b73f7     	ldrh	w23, [sp, #0x5b8]
 10868f0: b900018b     	str	w11, [x12]
 10868f4: 5280002b     	mov	w11, #0x1               // =1
 10868f8: f942e3ec     	ldr	x12, [sp, #0x5c0]
 10868fc: 3940014a     	ldrb	w10, [x10]
 1086900: f902a261     	str	x1, [x19, #0x540]
 1086904: f902a662     	str	x2, [x19, #0x548]
 1086908: 7100055f     	cmp	w10, #0x1
 108690c: b9055268     	str	w8, [x19, #0x550]
 1086910: 39155269     	strb	w9, [x19, #0x554]
 1086914: 790ab277     	strh	w23, [x19, #0x558]
 1086918: 3915826b     	strb	w11, [x19, #0x560]
 108691c: 7913066c     	strh	w12, [x19, #0x982]
 1086920: 54001e41     	b.ne	 <L54>
 1086924: 34001e29     	cbz	w9,  <L54>
 1086928: b9056e68     	str	w8, [x19, #0x56c]
 108692c: 78415328     	ldurh	w8, [x25, #0x15]
 1086930: 3841732a     	ldurb	w10, [x25, #0x17]
 1086934: 5282604b     	mov	w11, #0x1302            // =4866
 1086938: 3915c269     	strb	w9, [x19, #0x570]
 108693c: 9115c669     	add	x9, x19, #0x571
 1086940: 6b0b02ff     	cmp	w23, w11
 1086944: 79000128     	strh	w8, [x9]
 1086948: 3915ce6a     	strb	w10, [x19, #0x573]
 108694c: 54005721     	b.ne	 <L104>
 1086950: d0fffc03     	adrp	x3, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1086954: 910bf063     	add	x3, x3, #0x2fc
 1086958: 911763e0     	add	x0, sp, #0x5d8
 108695c: 94006812     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 1086960: 914007e8     	add	x8, sp, #0x1, lsl #12   // =0x1000
 1086964: f94057e1     	ldr	x1, [sp, #0xa8]
 1086968: aa1503e0     	mov	x0, x21
 108696c: 913fc108     	add	x8, x8, #0xff0
 1086970: 91005502     	add	x2, x8, #0x15
 1086974: 97ffdfb3     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).hash>
 1086978: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 108697c: 52800229     	mov	w9, #0x11               // =17
 1086980: 52860008     	mov	w8, #0x3000             // =12288
 1086984: 913fc14a     	add	x10, x10, #0xff0
 1086988: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 108698c: 793fe3e8     	strh	w8, [sp, #0x1ff0]
 1086990: 39000949     	strb	w9, [x10, #0x2]
 1086994: d0fffc09     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1086998: 913dd929     	add	x9, x9, #0xf76
 108699c: 3dc00120     	ldr	q0, [x9]
 10869a0: 52860c68     	mov	w8, #0x3063             // =12387
 10869a4: 911823e0     	add	x0, sp, #0x608
 10869a8: 913fc042     	add	x2, x2, #0xff0
 10869ac: 911763e4     	add	x4, sp, #0x5d8
 10869b0: 52800601     	mov	w1, #0x30               // =48
 10869b4: 528008a3     	mov	w3, #0x45               // =69
 10869b8: 78013148     	sturh	w8, [x10, #0x13]
 10869bc: 3c803140     	stur	q0, [x10, #0x3]
 10869c0: 940068a7     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10869c4: 9118e3e0     	add	x0, sp, #0x638
 10869c8: 911823e2     	add	x2, sp, #0x608
 10869cc: 52826041     	mov	w1, #0x1302             // =4866
 10869d0: 97ffe018     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 10869d4: 794d23e8     	ldrh	w8, [sp, #0x690]
 10869d8: 3500fda8     	cbnz	w8,  <L174>
 10869dc: 911567e8     	add	x8, sp, #0x559
 10869e0: 9114e7e9     	add	x9, sp, #0x539
 10869e4: 3ccff100     	ldur	q0, [x8, #0xff]
 10869e8: 9115a7e8     	add	x8, sp, #0x569
 10869ec: 3ccff101     	ldur	q1, [x8, #0xff]
 10869f0: 9115e7e8     	add	x8, sp, #0x579
 10869f4: 3ccff102     	ldur	q2, [x8, #0xff]
 10869f8: f94347e8     	ldr	x8, [sp, #0x688]
 10869fc: 3d814260     	str	q0, [x19, #0x500]
 1086a00: 3ccff120     	ldur	q0, [x9, #0xff]
 1086a04: 3d814661     	str	q1, [x19, #0x510]
 1086a08: f9029a68     	str	x8, [x19, #0x530]
 1086a0c: 911527e8     	add	x8, sp, #0x549
 1086a10: 3d814a62     	str	q2, [x19, #0x520]
 1086a14: 140002b8     	b	 <L105>
<L35>:
 1086a18: 52800968     	mov	w8, #0x4b               // =75
 1086a1c: 17fffe9c     	b	 <L5>
<L36>:
 1086a20: f90033fa     	str	x26, [sp, #0x60]
 1086a24: aa1f03fa     	mov	x26, xzr
<L37>:
 1086a28: eb1a02c9     	subs	x9, x22, x26
 1086a2c: 54000149     	b.ls	 <L39>
 1086a30: 8b1a134a     	add	x10, x26, x26, lsl #4
 1086a34: 914007eb     	add	x11, sp, #0x1, lsl #12  // =0x1000
 1086a38: 913fc16b     	add	x11, x11, #0xff0
 1086a3c: 8b0b014a     	add	x10, x10, x11
 1086a40: 9100414a     	add	x10, x10, #0x10
<L38>:
 1086a44: 3841154b     	ldrb	w11, [x10], #0x11
 1086a48: 3607ed6b     	tbz	w11, #0x0,  <L29>
 1086a4c: f1000529     	subs	x9, x9, #0x1
 1086a50: 54ffffa1     	b.ne	 <L38>
<L39>:
 1086a54: 3966c789     	ldrb	w9, [x28, #0x9b1]
 1086a58: 910943ea     	add	x10, sp, #0x250
 1086a5c: f90037ee     	str	x14, [sp, #0x68]
 1086a60: 91063d52     	add	x18, x10, #0x18f
 1086a64: 340012a9     	cbz	w9,  <L49>
 1086a68: 394f7fe9     	ldrb	w9, [sp, #0x3df]
 1086a6c: f94033fa     	ldr	x26, [sp, #0x60]
 1086a70: 3607da49     	tbz	w9, #0x0,  <L14>
 1086a74: f0fffc09     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1086a78: 910e0129     	add	x9, x9, #0x380
 1086a7c: 3dc00120     	ldr	q0, [x9]
 1086a80: 52800949     	mov	w9, #0x4a               // =74
 1086a84: 17ffff57     	b	 <L27>
<L40>:
 1086a88: 7940012b     	ldrh	w11, [x9]
 1086a8c: 5ac0056f     	rev16	w15, w11
 1086a90: 910011eb     	add	x11, x15, #0x4
 1086a94: eb0a017f     	cmp	x11, x10
 1086a98: 540010a8     	b.hi	 <L48>
 1086a9c: 910009eb     	add	x11, x15, #0x2
 1086aa0: 786b692c     	ldrh	w12, [x9, x11]
 1086aa4: cb0b014d     	sub	x13, x10, x11
 1086aa8: 5ac0058c     	rev16	w12, w12
 1086aac: 9100098c     	add	x12, x12, #0x2
 1086ab0: eb0d019f     	cmp	x12, x13
 1086ab4: 54000fc1     	b.ne	 <L48>
 1086ab8: 9100096b     	add	x11, x11, #0x2
 1086abc: f90033fa     	str	x26, [sp, #0x60]
 1086ac0: cb0b014d     	sub	x13, x10, x11
 1086ac4: 340052af     	cbz	w15,  <L107>
 1086ac8: 91000930     	add	x16, x9, #0x2
 1086acc: 8b0b0129     	add	x9, x9, x11
 1086ad0: aa1f03fa     	mov	x26, xzr
 1086ad4: a90427ed     	stp	x13, x9, [sp, #0x40]
 1086ad8: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1086adc: aa1f03ec     	mov	x12, xzr
 1086ae0: 91278129     	add	x9, x9, #0x9e0
 1086ae4: aa1f03ea     	mov	x10, xzr
 1086ae8: d10006d1     	sub	x17, x22, #0x1
 1086aec: 9100a129     	add	x9, x9, #0x28
 1086af0: f90037ee     	str	x14, [sp, #0x68]
 1086af4: a902a7ef     	stp	x15, x9, [sp, #0x28]
 1086af8: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1086afc: 913fc129     	add	x9, x9, #0xff0
 1086b00: f9001ff0     	str	x16, [sp, #0x38]
 1086b04: 91004129     	add	x9, x9, #0x10
 1086b08: a901c7e9     	stp	x9, x17, [sp, #0x18]
<L41>:
 1086b0c: 91000989     	add	x9, x12, #0x2
 1086b10: eb0901eb     	subs	x11, x15, x9
 1086b14: 54ffe243     	b.lo	 <L23>
 1086b18: f9003bec     	str	x12, [sp, #0x70]
 1086b1c: 786c6a0c     	ldrh	w12, [x16, x12]
 1086b20: 5ac00599     	rev16	w25, w12
 1086b24: 9100132c     	add	x12, x25, #0x4
 1086b28: eb0c017f     	cmp	x11, x12
 1086b2c: 54004fe3     	b.lo	 <L109>
 1086b30: eb0d015f     	cmp	x10, x13
 1086b34: 54ffe142     	b.hs	 <L23>
 1086b38: f94027eb     	ldr	x11, [sp, #0x48]
 1086b3c: 9100054c     	add	x12, x10, #0x1
 1086b40: 386a696b     	ldrb	w11, [x11, x10]
 1086b44: cb0c01aa     	sub	x10, x13, x12
 1086b48: eb0b015f     	cmp	x10, x11
 1086b4c: 54004ee3     	b.lo	 <L109>
 1086b50: f0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1086b54: 9100c108     	add	x8, x8, #0x30
 1086b58: f101033f     	cmp	x25, #0x40
 1086b5c: ad418500     	ldp	q0, q1, [x8, #0x30]
 1086b60: 8b090217     	add	x23, x16, x9
 1086b64: a9052fec     	stp	x12, x11, [sp, #0x50]
 1086b68: 3d810760     	str	q0, [x27, #0x410]
 1086b6c: 3d810b61     	str	q1, [x27, #0x420]
 1086b70: ad428500     	ldp	q0, q1, [x8, #0x50]
 1086b74: 3d811361     	str	q1, [x27, #0x440]
 1086b78: ad408901     	ldp	q1, q2, [x8, #0x10]
 1086b7c: 3d810f60     	str	q0, [x27, #0x430]
 1086b80: 3dc00100     	ldr	q0, [x8]
 1086b84: ad1f0760     	stp	q0, q1, [x27, #0x3e0]
 1086b88: 3d810362     	str	q2, [x27, #0x400]
 1086b8c: 540000a2     	b.hs	 <L42>
 1086b90: f9004bff     	str	xzr, [sp, #0x90]
 1086b94: aa1f03e9     	mov	x9, xzr
 1086b98: aa1f03e8     	mov	x8, xzr
 1086b9c: 1400000e     	b	 <L44>
<L42>:
 1086ba0: aa1f03e8     	mov	x8, xzr
<L43>:
 1086ba4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1086ba8: 8b0802e1     	add	x1, x23, x8
 1086bac: aa0803f4     	mov	x20, x8
 1086bb0: 91278000     	add	x0, x0, #0x9e0
 1086bb4: 94006ccd     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1086bb8: 91020288     	add	x8, x20, #0x80
 1086bbc: eb19011f     	cmp	x8, x25
 1086bc0: 91010288     	add	x8, x20, #0x40
 1086bc4: 54ffff09     	b.ls	 <L43>
 1086bc8: 39512369     	ldrb	w9, [x27, #0x448]
 1086bcc: f94d03ea     	ldr	x10, [sp, #0x1a00]
 1086bd0: f9004bea     	str	x10, [sp, #0x90]
<L44>:
 1086bd4: f9401bea     	ldr	x10, [sp, #0x30]
 1086bd8: cb080334     	sub	x20, x25, x8
 1086bdc: 8b0802e1     	add	x1, x23, x8
 1086be0: aa1403e2     	mov	x2, x20
 1086be4: 8b090140     	add	x0, x10, x9
 1086be8: 94055790     	bl	 <memcpy>
 1086bec: 39512368     	ldrb	w8, [x27, #0x448]
 1086bf0: f9404be9     	ldr	x9, [sp, #0x90]
 1086bf4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1086bf8: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1086bfc: 91278000     	add	x0, x0, #0x9e0
 1086c00: 0b140108     	add	w8, w8, w20
 1086c04: 8b190129     	add	x9, x9, x25
 1086c08: 911f0021     	add	x1, x1, #0x7c0
 1086c0c: 39112368     	strb	w8, [x27, #0x448]
 1086c10: f90d03e9     	str	x9, [sp, #0x1a00]
 1086c14: 94006c69     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 1086c18: eb16035f     	cmp	x26, x22
 1086c1c: 540002a2     	b.hs	 <L46>
 1086c20: a941c7e9     	ldp	x9, x17, [sp, #0x18]
 1086c24: 8b1a1348     	add	x8, x26, x26, lsl #4
 1086c28: a943b7f0     	ldp	x16, x13, [sp, #0x38]
 1086c2c: 3dc07360     	ldr	q0, [x27, #0x1c0]
 1086c30: f94037ee     	ldr	x14, [sp, #0x68]
 1086c34: 8b08012a     	add	x10, x9, x8
 1086c38: f9405be8     	ldr	x8, [sp, #0xb0]
<L45>:
 1086c3c: 3cdf0141     	ldur	q1, [x10, #-0x10]
 1086c40: 6ea18c01     	cmeq	v1.4s, v0.4s, v1.4s
 1086c44: 6e205821     	mvn	v1.16b, v1.16b
 1086c48: 6eb0a821     	umaxv	s1, v1.4s
 1086c4c: 1e260029     	fmov	w9, s1
 1086c50: 36000149     	tbz	w9, #0x0,  <L47>
 1086c54: 3841154b     	ldrb	w11, [x10], #0x11
 1086c58: 52800949     	mov	w9, #0x4a               // =74
 1086c5c: 3607dceb     	tbz	w11, #0x0,  <L30>
 1086c60: eb1a023f     	cmp	x17, x26
 1086c64: 9100075a     	add	x26, x26, #0x1
 1086c68: 54fffea1     	b.ne	 <L45>
 1086c6c: 17fffee3     	b	 <L30>
<L46>:
 1086c70: a943b7f0     	ldp	x16, x13, [sp, #0x38]
 1086c74: f94037ee     	ldr	x14, [sp, #0x68]
<L47>:
 1086c78: eb16035f     	cmp	x26, x22
 1086c7c: 5400df40     	b.eq	 <L163>
 1086c80: f9403be8     	ldr	x8, [sp, #0x70]
 1086c84: f94017ef     	ldr	x15, [sp, #0x28]
 1086c88: 9100075a     	add	x26, x26, #0x1
 1086c8c: 8b190108     	add	x8, x8, x25
 1086c90: 9100190c     	add	x12, x8, #0x6
 1086c94: a94523e9     	ldp	x9, x8, [sp, #0x50]
 1086c98: eb0f019f     	cmp	x12, x15
 1086c9c: 8b08012a     	add	x10, x9, x8
 1086ca0: f9405be8     	ldr	x8, [sp, #0xb0]
 1086ca4: 54fff343     	b.lo	 <L41>
 1086ca8: 1400021e     	b	 <L108>
<L48>:
 1086cac: 52800369     	mov	w9, #0x1b               // =27
 1086cb0: 79002109     	strh	w9, [x8, #0x10]
 1086cb4: 17fffdf7     	b	 <L6>
<L49>:
 1086cb8: f94033fa     	ldr	x26, [sp, #0x60]
 1086cbc: 17fffe3f     	b	 <L14>
<L50>:
 1086cc0: aa0b03ea     	mov	x10, x11
<L51>:
 1086cc4: eb0a0129     	subs	x9, x9, x10
 1086cc8: 540000e0     	b.eq	 <L53>
 1086ccc: 8b0a0108     	add	x8, x8, x10
<L52>:
 1086cd0: 3840150a     	ldrb	w10, [x8], #0x1
 1086cd4: 7100055f     	cmp	w10, #0x1
 1086cd8: 54ffdbc0     	b.eq	 <L34>
 1086cdc: f1000529     	subs	x9, x9, #0x1
 1086ce0: 54ffff81     	b.ne	 <L52>
<L53>:
 1086ce4: 39001b5f     	strb	wzr, [x26, #0x6]
<L54>:
 1086ce8: 911cf3e0     	add	x0, sp, #0x73c
 1086cec: 2a1f03e1     	mov	w1, wzr
 1086cf0: 5280d082     	mov	w2, #0x684              // =1668
 1086cf4: 913883f6     	add	x22, sp, #0xe20
 1086cf8: 910943f7     	add	x23, sp, #0x250
 1086cfc: 94055789     	bl	 <memset>
 1086d00: 6f00e400     	movi	v0.2d, #0000000000000000
 1086d04: 39660268     	ldrb	w8, [x19, #0x980]
 1086d08: 911683e9     	add	x9, sp, #0x5a0
 1086d0c: 393843ff     	strb	wzr, [sp, #0xe10]
 1086d10: 3d820920     	str	q0, [x9, #0x820]
 1086d14: 3d820d20     	str	q0, [x9, #0x830]
 1086d18: 3d821120     	str	q0, [x9, #0x840]
 1086d1c: 3d821520     	str	q0, [x9, #0x850]
 1086d20: 3d821920     	str	q0, [x9, #0x860]
 1086d24: 34000388     	cbz	w8,  <L55>
 1086d28: 7952fe79     	ldrh	w25, [x19, #0x97e]
 1086d2c: 52823d48     	mov	w8, #0x11ea             // =4586
 1086d30: f94047e9     	ldr	x9, [sp, #0x88]
 1086d34: 6b08033f     	cmp	w25, w8
 1086d38: f94053e8     	ldr	x8, [sp, #0xa0]
 1086d3c: 54000f8c     	b.gt	 <L69>
 1086d40: f9405bea     	ldr	x10, [sp, #0xb0]
 1086d44: 71005f3f     	cmp	w25, #0x17
 1086d48: 54001c60     	b.eq	 <L86>
 1086d4c: 7100633f     	cmp	w25, #0x18
 1086d50: 54001e20     	b.eq	 <L87>
 1086d54: 7100773f     	cmp	w25, #0x1d
 1086d58: 54002901     	b.ne	 <L93>
 1086d5c: 394ce7eb     	ldrb	w11, [sp, #0x339]
 1086d60: 340028cb     	cbz	w11,  <L93>
 1086d64: 394defeb     	ldrb	w11, [sp, #0x37b]
 1086d68: 3500288b     	cbnz	w11,  <L93>
 1086d6c: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 1086d70: 3500284b     	cbnz	w11,  <L93>
 1086d74: 394ba3eb     	ldrb	w11, [sp, #0x2e8]
 1086d78: 7200057f     	tst	w11, #0x3
 1086d7c: 540027e1     	b.ne	 <L93>
 1086d80: 910943ea     	add	x10, sp, #0x250
 1086d84: 784d92f9     	ldurh	w25, [x23, #0xd9]
 1086d88: 393873ff     	strb	wzr, [sp, #0xe1c]
 1086d8c: 3ccc9140     	ldur	q0, [x10, #0xc9]
 1086d90: 140000cb     	b	 <L85>
<L55>:
 1086d94: a94aabe3     	ldp	x3, x10, [sp, #0xa8]
 1086d98: aa1a03f7     	mov	x23, x26
 1086d9c: f941d666     	ldr	x6, [x19, #0x3a8]
 1086da0: f94053e8     	ldr	x8, [sp, #0xa0]
 1086da4: aa1503e2     	mov	x2, x21
 1086da8: f94047e9     	ldr	x9, [sp, #0x88]
 1086dac: b4001786     	cbz	x6,  <L84>
 1086db0: 3951e3eb     	ldrb	w11, [sp, #0x478]
 1086db4: f941d26c     	ldr	x12, [x19, #0x3a0]
 1086db8: 1200056d     	and	w13, w11, #0x3
 1086dbc: 34000ded     	cbz	w13,  <L72>
 1086dc0: 910f83eb     	add	x11, sp, #0x3e0
 1086dc4: 794883ef     	ldrh	w15, [sp, #0x440]
 1086dc8: 7948b3f0     	ldrh	w16, [sp, #0x458]
 1086dcc: 7948e3f1     	ldrh	w17, [sp, #0x470]
 1086dd0: aa1703fa     	mov	x26, x23
 1086dd4: aa1f03ee     	mov	x14, xzr
 1086dd8: 91014178     	add	x24, x11, #0x50
 1086ddc: 12823d52     	mov	w18, #-0x11eb           // =-4587
 1086de0: 52823da0     	mov	w0, #0x11ed             // =4589
 1086de4: 14000004     	b	 <L57>
<L56>:
 1086de8: 910005ce     	add	x14, x14, #0x1
 1086dec: eb0601df     	cmp	x14, x6
 1086df0: 54000c40     	b.eq	 <L72>
<L57>:
 1086df4: 786e7981     	ldrh	w1, [x12, x14, lsl #1]
 1086df8: 12003c2b     	and	w11, w1, #0xffff
 1086dfc: 0b120164     	add	w4, w11, w18
 1086e00: 7100089f     	cmp	w4, #0x2
 1086e04: 54000422     	b.hs	 <L63>
 1086e08: 6b2121ff     	cmp	w15, w1, uxth
 1086e0c: 54000101     	b.ne	 <L59>
 1086e10: aa0c03e4     	mov	x4, x12
 1086e14: aa0603eb     	mov	x11, x6
<L58>:
 1086e18: 78402485     	ldrh	w5, [x4], #0x2
 1086e1c: 6b2120bf     	cmp	w5, w1, uxth
 1086e20: 54003900     	b.eq	 <L112>
 1086e24: f100056b     	subs	x11, x11, #0x1
 1086e28: 54ffff81     	b.ne	 <L58>
<L59>:
 1086e2c: 710005bf     	cmp	w13, #0x1
 1086e30: 54fffdc0     	b.eq	 <L56>
 1086e34: 6b21221f     	cmp	w16, w1, uxth
 1086e38: 54000101     	b.ne	 <L61>
 1086e3c: aa0c03e4     	mov	x4, x12
 1086e40: aa0603e5     	mov	x5, x6
<L60>:
 1086e44: 7840248b     	ldrh	w11, [x4], #0x2
 1086e48: 6b21217f     	cmp	w11, w1, uxth
 1086e4c: 54002500     	b.eq	 <L97>
 1086e50: f10004a5     	subs	x5, x5, #0x1
 1086e54: 54ffff81     	b.ne	 <L60>
<L61>:
 1086e58: 710009bf     	cmp	w13, #0x2
 1086e5c: 54fffc60     	b.eq	 <L56>
 1086e60: 6b21223f     	cmp	w17, w1, uxth
 1086e64: 54fffc21     	b.ne	 <L56>
 1086e68: aa0c03e4     	mov	x4, x12
 1086e6c: aa0603e5     	mov	x5, x6
<L62>:
 1086e70: 7840248b     	ldrh	w11, [x4], #0x2
 1086e74: 6b21217f     	cmp	w11, w1, uxth
 1086e78: 540026c0     	b.eq	 <L100>
 1086e7c: f10004a5     	subs	x5, x5, #0x1
 1086e80: 54ffff81     	b.ne	 <L62>
 1086e84: 17ffffd9     	b	 <L56>
<L63>:
 1086e88: 6b00017f     	cmp	w11, w0
 1086e8c: 54fffae1     	b.ne	 <L56>
 1086e90: 6b0001ff     	cmp	w15, w0
 1086e94: 54000161     	b.ne	 <L65>
 1086e98: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1086e9c: 3400012b     	cbz	w11,  <L65>
 1086ea0: aa0c03e4     	mov	x4, x12
 1086ea4: aa0603e5     	mov	x5, x6
<L64>:
 1086ea8: 7840248b     	ldrh	w11, [x4], #0x2
 1086eac: 52823da1     	mov	w1, #0x11ed             // =4589
 1086eb0: 6b01017f     	cmp	w11, w1
 1086eb4: 54003460     	b.eq	 <L112>
 1086eb8: f10004a5     	subs	x5, x5, #0x1
 1086ebc: 54ffff61     	b.ne	 <L64>
<L65>:
 1086ec0: 710005bf     	cmp	w13, #0x1
 1086ec4: 54fff920     	b.eq	 <L56>
 1086ec8: 6b00021f     	cmp	w16, w0
 1086ecc: 54000141     	b.ne	 <L67>
 1086ed0: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1086ed4: 3400010b     	cbz	w11,  <L67>
 1086ed8: aa0c03e1     	mov	x1, x12
 1086edc: aa0603e4     	mov	x4, x6
<L66>:
 1086ee0: 7840242b     	ldrh	w11, [x1], #0x2
 1086ee4: 6b00017f     	cmp	w11, w0
 1086ee8: 54003120     	b.eq	 <L106>
 1086eec: f1000484     	subs	x4, x4, #0x1
 1086ef0: 54ffff81     	b.ne	 <L66>
<L67>:
 1086ef4: 710009bf     	cmp	w13, #0x2
 1086ef8: 54fff780     	b.eq	 <L56>
 1086efc: 6b00023f     	cmp	w17, w0
 1086f00: 54fff741     	b.ne	 <L56>
 1086f04: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1086f08: 34fff70b     	cbz	w11,  <L56>
 1086f0c: aa0c03e1     	mov	x1, x12
 1086f10: aa0603e4     	mov	x4, x6
<L68>:
 1086f14: 7840242b     	ldrh	w11, [x1], #0x2
 1086f18: 6b00017f     	cmp	w11, w0
 1086f1c: 540030c0     	b.eq	 <L110>
 1086f20: f1000484     	subs	x4, x4, #0x1
 1086f24: 54ffff81     	b.ne	 <L68>
 1086f28: 17ffffb0     	b	 <L56>
<L69>:
 1086f2c: 12823d48     	mov	w8, #-0x11eb            // =-4587
 1086f30: f9405bea     	ldr	x10, [sp, #0xb0]
 1086f34: 0b080328     	add	w8, w25, w8
 1086f38: 7100091f     	cmp	w8, #0x2
 1086f3c: 540000c3     	b.lo	 <L70>
 1086f40: 52823da8     	mov	w8, #0x11ed             // =4589
 1086f44: 6b08033f     	cmp	w25, w8
 1086f48: 54001981     	b.ne	 <L93>
 1086f4c: 3948f748     	ldrb	w8, [x26, #0x23d]
 1086f50: 34001928     	cbz	w8,  <L92>
<L70>:
 1086f54: f941d668     	ldr	x8, [x19, #0x3a8]
 1086f58: b40018e8     	cbz	x8,  <L92>
 1086f5c: f941d269     	ldr	x9, [x19, #0x3a0]
<L71>:
 1086f60: 7840252b     	ldrh	w11, [x9], #0x2
 1086f64: 6b19017f     	cmp	w11, w25
 1086f68: 540014a0     	b.eq	 <L91>
 1086f6c: f1000508     	subs	x8, x8, #0x1
 1086f70: 54ffff81     	b.ne	 <L71>
 1086f74: 140000c0     	b	 <L92>
<L72>:
 1086f78: 394c63eb     	ldrb	w11, [sp, #0x318]
 1086f7c: aa1f03ed     	mov	x13, xzr
 1086f80: f0fffc0e     	adrp	x14, 0x1009000 <__anon_51030+0x980>
 1086f84: 913d21ce     	add	x14, x14, #0xf48
 1086f88: 52823d4f     	mov	w15, #0x11ea            // =4586
 1086f8c: 12823d41     	mov	w1, #-0x11eb            // =-4587
 1086f90: 12001560     	and	w0, w11, #0x3f
 1086f94: f0fffc04     	adrp	x4, 0x1009000 <__anon_51030+0x980>
 1086f98: 913d7884     	add	x4, x4, #0xf5e
 1086f9c: 52823da5     	mov	w5, #0x11ed             // =4589
 1086fa0: f0fffc10     	adrp	x16, 0x1009000 <__anon_51030+0x980>
 1086fa4: 913d5210     	add	x16, x16, #0xf54
 1086fa8: 52823d67     	mov	w7, #0x11eb             // =4587
 1086fac: f0fffc18     	adrp	x24, 0x1009000 <__anon_51030+0x980>
 1086fb0: 913d6318     	add	x24, x24, #0xf58
 1086fb4: 52823d99     	mov	w25, #0x11ec            // =4588
 1086fb8: f0fffc1a     	adrp	x26, 0x1009000 <__anon_51030+0x980>
 1086fbc: 913d735a     	add	x26, x26, #0xf5c
 1086fc0: 14000004     	b	 <L74>
<L73>:
 1086fc4: 910005ad     	add	x13, x13, #0x1
 1086fc8: eb0601bf     	cmp	x13, x6
 1086fcc: 54000680     	b.eq	 <L84>
<L74>:
 1086fd0: 786d7992     	ldrh	w18, [x12, x13, lsl #1]
 1086fd4: 6b0f025f     	cmp	w18, w15
 1086fd8: 5400012c     	b.gt	 <L75>
 1086fdc: 71005e5f     	cmp	w18, #0x17
 1086fe0: 540001e0     	b.eq	 <L76>
 1086fe4: 7100625f     	cmp	w18, #0x18
 1086fe8: 54000280     	b.eq	 <L79>
 1086fec: 7100765f     	cmp	w18, #0x1d
 1086ff0: aa0e03eb     	mov	x11, x14
 1086ff4: 540002a0     	b.eq	 <L81>
 1086ff8: 1400000e     	b	 <L78>
<L75>:
 1086ffc: 6b07025f     	cmp	w18, w7
 1087000: 54000140     	b.eq	 <L77>
 1087004: 6b19025f     	cmp	w18, w25
 1087008: 540001e0     	b.eq	 <L80>
 108700c: 6b05025f     	cmp	w18, w5
 1087010: 54000101     	b.ne	 <L78>
 1087014: aa1a03eb     	mov	x11, x26
 1087018: 1400000c     	b	 <L81>
<L76>:
 108701c: d0fffc0b     	adrp	x11, 0x1009000 <__anon_51030+0x980>
 1087020: 913d316b     	add	x11, x11, #0xf4c
 1087024: 14000009     	b	 <L81>
<L77>:
 1087028: aa1003eb     	mov	x11, x16
 108702c: 14000007     	b	 <L81>
<L78>:
 1087030: aa0403eb     	mov	x11, x4
 1087034: 14000005     	b	 <L81>
<L79>:
 1087038: d0fffc0b     	adrp	x11, 0x1009000 <__anon_51030+0x980>
 108703c: 913d416b     	add	x11, x11, #0xf50
 1087040: 14000002     	b	 <L81>
<L80>:
 1087044: aa1803eb     	mov	x11, x24
<L81>:
 1087048: 7940016b     	ldrh	w11, [x11]
 108704c: 7104017f     	cmp	w11, #0x100
 1087050: 54fffba3     	b.lo	 <L73>
 1087054: 9240096b     	and	x11, x11, #0x7
 1087058: 1acb240b     	lsr	w11, w0, w11
 108705c: 3607fb4b     	tbz	w11, #0x0,  <L73>
 1087060: 0b01024b     	add	w11, w18, w1
 1087064: 7100097f     	cmp	w11, #0x2
 1087068: 540000a3     	b.lo	 <L82>
 108706c: 6b05025f     	cmp	w18, w5
 1087070: 54fffaa1     	b.ne	 <L73>
 1087074: 3948f6eb     	ldrb	w11, [x23, #0x23d]
 1087078: 34fffa6b     	cbz	w11,  <L73>
<L82>:
 108707c: aa0c03fe     	mov	x30, x12
 1087080: aa0603eb     	mov	x11, x6
<L83>:
 1087084: 784027d1     	ldrh	w17, [x30], #0x2
 1087088: 6b12023f     	cmp	w17, w18
 108708c: 540007e0     	b.eq	 <L88>
 1087090: f100056b     	subs	x11, x11, #0x1
 1087094: 54ffff81     	b.ne	 <L83>
 1087098: 17ffffcb     	b	 <L73>
<L84>:
 108709c: 394ce7eb     	ldrb	w11, [sp, #0x339]
 10870a0: 3400106b     	cbz	w11,  <L95>
 10870a4: 910943ea     	add	x10, sp, #0x250
 10870a8: 393873ff     	strb	wzr, [sp, #0xe1c]
 10870ac: aa1703fa     	mov	x26, x23
 10870b0: 3ccc9140     	ldur	q0, [x10, #0xc9]
 10870b4: 784d9159     	ldurh	w25, [x10, #0xd9]
 10870b8: 910943ea     	add	x10, sp, #0x250
<L85>:
 10870bc: 3d8016c0     	str	q0, [x22, #0x50]
 10870c0: f84dbd4b     	ldr	x11, [x10, #0xdb]!
 10870c4: f840614a     	ldur	x10, [x10, #0x6]
 10870c8: f90713eb     	str	x11, [sp, #0xe20]
 10870cc: f80062ca     	stur	x10, [x22, #0x6]
 10870d0: 14000140     	b	 <L113>
<L86>:
 10870d4: 394defeb     	ldrb	w11, [sp, #0x37b]
 10870d8: 34000d0b     	cbz	w11,  <L93>
 10870dc: 394ce7eb     	ldrb	w11, [sp, #0x339]
 10870e0: 35000ccb     	cbnz	w11,  <L93>
 10870e4: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 10870e8: 35000c8b     	cbnz	w11,  <L93>
 10870ec: 394ba3eb     	ldrb	w11, [sp, #0x2e8]
 10870f0: 7200057f     	tst	w11, #0x3
 10870f4: 54000c21     	b.ne	 <L93>
 10870f8: 910943ea     	add	x10, sp, #0x250
 10870fc: 794697f9     	ldrh	w25, [sp, #0x34a]
 1087100: 5280002b     	mov	w11, #0x1               // =1
 1087104: 3ccea140     	ldur	q0, [x10, #0xea]
 1087108: 9103f14a     	add	x10, x10, #0xfc
 108710c: 393873eb     	strb	w11, [sp, #0xe1c]
 1087110: 14000071     	b	 <L96>
<L87>:
 1087114: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1087118: 34000b0b     	cbz	w11,  <L93>
 108711c: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 1087120: 34000acb     	cbz	w11,  <L93>
 1087124: 394ce7eb     	ldrb	w11, [sp, #0x339]
 1087128: 35000a8b     	cbnz	w11,  <L93>
 108712c: 394defeb     	ldrb	w11, [sp, #0x37b]
 1087130: 35000a4b     	cbnz	w11,  <L93>
 1087134: 394ba3eb     	ldrb	w11, [sp, #0x2e8]
 1087138: 7200057f     	tst	w11, #0x3
 108713c: 540009e1     	b.ne	 <L93>
 1087140: 910943ea     	add	x10, sp, #0x250
 1087144: 79471bf9     	ldrh	w25, [sp, #0x38c]
 1087148: 9104b14b     	add	x11, x10, #0x12c
 108714c: 9104f94a     	add	x10, x10, #0x13e
 1087150: ad408941     	ldp	q1, q2, [x10, #0x10]
 1087154: 3dc00160     	ldr	q0, [x11]
 1087158: 911683eb     	add	x11, sp, #0x5a0
 108715c: 3d8016c0     	str	q0, [x22, #0x50]
 1087160: 3dc00140     	ldr	q0, [x10]
 1087164: 3d822561     	str	q1, [x11, #0x890]
 1087168: 3dc00d41     	ldr	q1, [x10, #0x30]
 108716c: 3d822962     	str	q2, [x11, #0x8a0]
 1087170: 3cc3f142     	ldur	q2, [x10, #0x3f]
 1087174: 5280004a     	mov	w10, #0x2               // =2
 1087178: 3d822d61     	str	q1, [x11, #0x8b0]
 108717c: 3c83f2c2     	stur	q2, [x22, #0x3f]
 1087180: 393873ea     	strb	w10, [sp, #0xe1c]
 1087184: 14000071     	b	 <L99>
<L88>:
 1087188: f94133e5     	ldr	x5, [sp, #0x260]
 108718c: f94137e6     	ldr	x6, [sp, #0x268]
 1087190: 913a43e0     	add	x0, sp, #0xe90
 1087194: 910f83e4     	add	x4, sp, #0x3e0
 1087198: aa1303e1     	mov	x1, x19
 108719c: 2a1403e7     	mov	w7, w20
 10871a0: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10871a4: 790003f2     	strh	w18, [sp]
 10871a8: 94007fc5     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10871ac: 795d43e8     	ldrh	w8, [sp, #0xea0]
 10871b0: 3500b628     	cbnz	w8,  <L164>
 10871b4: f9474bf4     	ldr	x20, [sp, #0xe90]
 10871b8: f9474ff5     	ldr	x21, [sp, #0xe98]
<L89>:
 10871bc: f9404be8     	ldr	x8, [sp, #0x90]
 10871c0: aa1303e0     	mov	x0, x19
 10871c4: 39400101     	ldrb	w1, [x8]
 10871c8: 94008220     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 10871cc: 6f00e400     	movi	v0.2d, #0000000000000000
 10871d0: 390002ff     	strb	wzr, [x23]
<L90>:
 10871d4: 911683e8     	add	x8, sp, #0x5a0
 10871d8: 3d820900     	str	q0, [x8, #0x820]
 10871dc: 3d820d00     	str	q0, [x8, #0x830]
 10871e0: 3d821100     	str	q0, [x8, #0x840]
 10871e4: 3d821500     	str	q0, [x8, #0x850]
 10871e8: 3d821900     	str	q0, [x8, #0x860]
 10871ec: f9405be8     	ldr	x8, [sp, #0xb0]
 10871f0: 7900211f     	strh	wzr, [x8, #0x10]
 10871f4: a9005514     	stp	x20, x21, [x8]
 10871f8: 17fffca6     	b	 <L6>
<L91>:
 10871fc: 394ce7e8     	ldrb	w8, [sp, #0x339]
 1087200: 350003a8     	cbnz	w8,  <L92>
 1087204: 394defe8     	ldrb	w8, [sp, #0x37b]
 1087208: 35000368     	cbnz	w8,  <L92>
 108720c: 394f77e8     	ldrb	w8, [sp, #0x3dd]
 1087210: 35000328     	cbnz	w8,  <L92>
 1087214: 394ba3e8     	ldrb	w8, [sp, #0x2e8]
 1087218: 12000508     	and	w8, w8, #0x3
 108721c: 7100051f     	cmp	w8, #0x1
 1087220: 540002a1     	b.ne	 <L92>
 1087224: 794883e8     	ldrh	w8, [sp, #0x440]
 1087228: 6b19011f     	cmp	w8, w25
 108722c: 54000241     	b.ne	 <L92>
 1087230: 910f83f7     	add	x23, sp, #0x3e0
 1087234: 911cf3e2     	add	x2, sp, #0x73c
 1087238: 913703e3     	add	x3, sp, #0xdc0
 108723c: 910142e1     	add	x1, x23, #0x50
 1087240: aa1303e0     	mov	x0, x19
 1087244: 94007f80     	bl	 <ServerHandshake.encapsulateHybrid>
 1087248: 72003c1f     	tst	w0, #0xffff
 108724c: 5400ba61     	b.ne	 <L175>
 1087250: 52800068     	mov	w8, #0x3                // =3
 1087254: 3cc502e0     	ldur	q0, [x23, #0x50]
 1087258: b8462309     	ldur	w9, [x24, #0x62]
 108725c: 393873e8     	strb	w8, [sp, #0xe1c]
 1087260: 79488fe8     	ldrh	w8, [sp, #0x446]
 1087264: 3d8016c0     	str	q0, [x22, #0x50]
 1087268: b90e23e9     	str	w9, [sp, #0xe20]
 108726c: 791c4be8     	strh	w8, [sp, #0xe24]
 1087270: 140000fe     	b	 <L117>
<L92>:
 1087274: 6f00e400     	movi	v0.2d, #0000000000000000
<L93>:
 1087278: 911683eb     	add	x11, sp, #0x5a0
 108727c: d0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1087280: 910e0108     	add	x8, x8, #0x380
 1087284: 52800949     	mov	w9, #0x4a               // =74
<L94>:
 1087288: 3d821960     	str	q0, [x11, #0x860]
 108728c: 3d821560     	str	q0, [x11, #0x850]
 1087290: 3d821160     	str	q0, [x11, #0x840]
 1087294: 3d820d60     	str	q0, [x11, #0x830]
 1087298: 3dc00101     	ldr	q1, [x8]
 108729c: 3d820960     	str	q0, [x11, #0x820]
 10872a0: f9000949     	str	x9, [x10, #0x10]
 10872a4: 3d800141     	str	q1, [x10]
 10872a8: 17fffc7a     	b	 <L6>
<L95>:
 10872ac: 394defeb     	ldrb	w11, [sp, #0x37b]
 10872b0: 3400024b     	cbz	w11,  <L98>
 10872b4: 910943eb     	add	x11, sp, #0x250
 10872b8: 5280002a     	mov	w10, #0x1               // =1
 10872bc: 794697f9     	ldrh	w25, [sp, #0x34a]
 10872c0: 3ccea160     	ldur	q0, [x11, #0xea]
 10872c4: 393873ea     	strb	w10, [sp, #0xe1c]
 10872c8: 910943ea     	add	x10, sp, #0x250
 10872cc: 9103f14a     	add	x10, x10, #0xfc
 10872d0: aa1703fa     	mov	x26, x23
<L96>:
 10872d4: 3d8016c0     	str	q0, [x22, #0x50]
 10872d8: ad400540     	ldp	q0, q1, [x10]
 10872dc: 3cc1f142     	ldur	q2, [x10, #0x1f]
 10872e0: ad0006c0     	stp	q0, q1, [x22]
 10872e4: 3c81f2c2     	stur	q2, [x22, #0x1f]
 10872e8: 140000c2     	b	 <L114>
<L97>:
 10872ec: 910f83e8     	add	x8, sp, #0x3e0
 10872f0: 9101a118     	add	x24, x8, #0x68
 10872f4: 14000093     	b	 <L112>
<L98>:
 10872f8: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 10872fc: aa1703fa     	mov	x26, x23
 1087300: 340002eb     	cbz	w11,  <L101>
 1087304: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1087308: 340002ab     	cbz	w11,  <L101>
 108730c: 910943ea     	add	x10, sp, #0x250
 1087310: 910943eb     	add	x11, sp, #0x250
 1087314: 79471bf9     	ldrh	w25, [sp, #0x38c]
 1087318: 9104b14a     	add	x10, x10, #0x12c
 108731c: 9104f96b     	add	x11, x11, #0x13e
 1087320: 3dc00140     	ldr	q0, [x10]
 1087324: ad410961     	ldp	q1, q2, [x11, #0x20]
 1087328: 5280004a     	mov	w10, #0x2               // =2
 108732c: 3d8016c0     	str	q0, [x22, #0x50]
 1087330: 3cc3f160     	ldur	q0, [x11, #0x3f]
 1087334: ad010ac1     	stp	q1, q2, [x22, #0x20]
 1087338: 3c83f2c0     	stur	q0, [x22, #0x3f]
 108733c: ad400560     	ldp	q0, q1, [x11]
 1087340: 393873ea     	strb	w10, [sp, #0xe1c]
 1087344: 3d8006c1     	str	q1, [x22, #0x10]
<L99>:
 1087348: 3d8002c0     	str	q0, [x22]
 108734c: 140000b8     	b	 <L116>
<L100>:
 1087350: 910f83e8     	add	x8, sp, #0x3e0
 1087354: 91020118     	add	x24, x8, #0x80
 1087358: 1400007a     	b	 <L112>
<L101>:
 108735c: d0fffc0b     	adrp	x11, 0x1009000 <__anon_51030+0x980>
 1087360: 795e916c     	ldrh	w12, [x11, #0xf48]
 1087364: 3952a3eb     	ldrb	w11, [sp, #0x4a8]
 1087368: 7104019f     	cmp	w12, #0x100
 108736c: 54000283     	b.lo	 <L102>
 1087370: 1200156d     	and	w13, w11, #0x3f
 1087374: 9240098c     	and	x12, x12, #0x7
 1087378: 1acc25ac     	lsr	w12, w13, w12
 108737c: 3600020c     	tbz	w12, #0x0,  <L102>
 1087380: f94133e5     	ldr	x5, [sp, #0x260]
 1087384: f94137e6     	ldr	x6, [sp, #0x268]
 1087388: 528003aa     	mov	w10, #0x1d              // =29
 108738c: 913aa3e0     	add	x0, sp, #0xea8
 1087390: 910f83e4     	add	x4, sp, #0x3e0
 1087394: aa1303e1     	mov	x1, x19
 1087398: 2a1403e7     	mov	w7, w20
 108739c: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10873a0: 790003ea     	strh	w10, [sp]
 10873a4: 94007f46     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10873a8: 795d73e8     	ldrh	w8, [sp, #0xeb8]
 10873ac: 3500a648     	cbnz	w8,  <L164>
 10873b0: f94757f4     	ldr	x20, [sp, #0xea8]
 10873b4: f9475bf5     	ldr	x21, [sp, #0xeb0]
 10873b8: 14000017     	b	 <L103>
<L102>:
 10873bc: d0fffc0c     	adrp	x12, 0x1009000 <__anon_51030+0x980>
 10873c0: 795e998c     	ldrh	w12, [x12, #0xf4c]
 10873c4: 7104019f     	cmp	w12, #0x100
 10873c8: 5400a103     	b.lo	 <L161>
 10873cc: 1200156d     	and	w13, w11, #0x3f
 10873d0: 9240098c     	and	x12, x12, #0x7
 10873d4: 1acc25ac     	lsr	w12, w13, w12
 10873d8: 3600a08c     	tbz	w12, #0x0,  <L161>
 10873dc: f94133e5     	ldr	x5, [sp, #0x260]
 10873e0: f94137e6     	ldr	x6, [sp, #0x268]
 10873e4: 528002ea     	mov	w10, #0x17              // =23
 10873e8: 913b03e0     	add	x0, sp, #0xec0
 10873ec: 910f83e4     	add	x4, sp, #0x3e0
 10873f0: aa1303e1     	mov	x1, x19
 10873f4: 2a1403e7     	mov	w7, w20
 10873f8: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10873fc: 790003ea     	strh	w10, [sp]
 1087400: 94007f2f     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 1087404: 795da3e8     	ldrh	w8, [sp, #0xed0]
 1087408: 3500a368     	cbnz	w8,  <L164>
 108740c: f94763f4     	ldr	x20, [sp, #0xec0]
 1087410: f94767f5     	ldr	x21, [sp, #0xec8]
<L103>:
 1087414: f9404be8     	ldr	x8, [sp, #0x90]
 1087418: aa1303e0     	mov	x0, x19
 108741c: 39400101     	ldrb	w1, [x8]
 1087420: 9400818a     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 1087424: 6f00e400     	movi	v0.2d, #0000000000000000
 1087428: 3900035f     	strb	wzr, [x26]
 108742c: 17ffff6a     	b	 <L90>
<L104>:
 1087430: 90fffe23     	adrp	x3, 0x104b000 <server_hello.hello_retry_request_random+0x30>
 1087434: 910d4063     	add	x3, x3, #0x350
 1087438: 911a63e0     	add	x0, sp, #0x698
 108743c: 94006872     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 1087440: 914007e8     	add	x8, sp, #0x1, lsl #12   // =0x1000
 1087444: f94057e1     	ldr	x1, [sp, #0xa8]
 1087448: aa1503e0     	mov	x0, x21
 108744c: 913fc108     	add	x8, x8, #0xff0
 1087450: 91005502     	add	x2, x8, #0x15
 1087454: 97ffdd3e     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).hash>
 1087458: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 108745c: 52800229     	mov	w9, #0x11               // =17
 1087460: 52840008     	mov	w8, #0x2000             // =8192
 1087464: 913fc14a     	add	x10, x10, #0xff0
 1087468: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 108746c: 793fe3e8     	strh	w8, [sp, #0x1ff0]
 1087470: 39000949     	strb	w9, [x10, #0x2]
 1087474: b0fffc09     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1087478: 913dd929     	add	x9, x9, #0xf76
 108747c: 3dc00120     	ldr	q0, [x9]
 1087480: 52840c68     	mov	w8, #0x2063             // =8291
 1087484: 911ae3e0     	add	x0, sp, #0x6b8
 1087488: 913fc042     	add	x2, x2, #0xff0
 108748c: 911a63e4     	add	x4, sp, #0x698
 1087490: 52800401     	mov	w1, #0x20               // =32
 1087494: 528006a3     	mov	w3, #0x35               // =53
 1087498: 78013148     	sturh	w8, [x10, #0x13]
 108749c: 3c803140     	stur	q0, [x10, #0x3]
 10874a0: 940068d2     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10874a4: 911b63e0     	add	x0, sp, #0x6d8
 10874a8: 911ae3e2     	add	x2, sp, #0x6b8
 10874ac: 2a1703e1     	mov	w1, w23
 10874b0: 97ffdddd     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10874b4: 794e63e8     	ldrh	w8, [sp, #0x730]
 10874b8: 3500a6a8     	cbnz	w8,  <L174>
 10874bc: 9117e7e8     	add	x8, sp, #0x5f9
 10874c0: 911767e9     	add	x9, sp, #0x5d9
 10874c4: 3ccff100     	ldur	q0, [x8, #0xff]
 10874c8: 911827e8     	add	x8, sp, #0x609
 10874cc: 3ccff101     	ldur	q1, [x8, #0xff]
 10874d0: 911867e8     	add	x8, sp, #0x619
 10874d4: 3ccff102     	ldur	q2, [x8, #0xff]
 10874d8: f94397e8     	ldr	x8, [sp, #0x728]
 10874dc: 3d814260     	str	q0, [x19, #0x500]
 10874e0: 3ccff120     	ldur	q0, [x9, #0xff]
 10874e4: 3d814661     	str	q1, [x19, #0x510]
 10874e8: 3d814a62     	str	q2, [x19, #0x520]
 10874ec: f9029a68     	str	x8, [x19, #0x530]
 10874f0: 9117a7e8     	add	x8, sp, #0x5e9
<L105>:
 10874f4: 3ccff101     	ldur	q1, [x8, #0xff]
 10874f8: 52800028     	mov	w8, #0x1                // =1
 10874fc: 3d813a60     	str	q0, [x19, #0x4e0]
 1087500: 3914e268     	strb	w8, [x19, #0x538]
 1087504: 3d813e61     	str	q1, [x19, #0x4f0]
 1087508: 17fffdf8     	b	 <L54>
<L106>:
 108750c: 910f83e8     	add	x8, sp, #0x3e0
 1087510: 9101a118     	add	x24, x8, #0x68
 1087514: 1400000a     	b	 <L111>
<L107>:
 1087518: aa1f03ea     	mov	x10, xzr
 108751c: aa1f03fa     	mov	x26, xzr
<L108>:
 1087520: eb0d015f     	cmp	x10, x13
 1087524: 54ffa820     	b.eq	 <L37>
<L109>:
 1087528: 52800869     	mov	w9, #0x43               // =67
 108752c: 79002109     	strh	w9, [x8, #0x10]
 1087530: 17fffbd8     	b	 <L6>
<L110>:
 1087534: 910f83e8     	add	x8, sp, #0x3e0
 1087538: 91020118     	add	x24, x8, #0x80
<L111>:
 108753c: 52823da1     	mov	w1, #0x11ed             // =4589
<L112>:
 1087540: a9400f02     	ldp	x2, x3, [x24]
 1087544: 528952a8     	mov	w8, #0x4a95             // =19093
 1087548: 911cf3e9     	add	x9, sp, #0x73c
 108754c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087550: 52800a0a     	mov	w10, #0x50              // =80
 1087554: 913fc000     	add	x0, x0, #0xff0
 1087558: 8b080264     	add	x4, x19, x8
 108755c: b27f0125     	orr	x5, x9, #0x2
 1087560: 913703e7     	add	x7, sp, #0xdc0
 1087564: 5280d026     	mov	w6, #0x681              // =1665
 1087568: f90003ea     	str	x10, [sp]
 108756c: 9400954d     	bl	 <hybrid_kex.encapsulate>
 1087570: 91004be8     	add	x8, sp, #0x12
 1087574: 797ffd08     	ldrh	w8, [x8, #0x1ffe]
 1087578: 35009fc8     	cbnz	w8,  <L173>
 108757c: b95ffbe8     	ldr	w8, [sp, #0x1ff8]
 1087580: b9600be9     	ldr	w9, [sp, #0x2008]
 1087584: 5280006a     	mov	w10, #0x3               // =3
 1087588: 3dc00300     	ldr	q0, [x24]
 108758c: 79402319     	ldrh	w25, [x24, #0x10]
 1087590: 7100055f     	cmp	w10, #0x1
 1087594: 12002908     	and	w8, w8, #0x7ff
 1087598: 12001929     	and	w9, w9, #0x7f
 108759c: 393a33ea     	strb	w10, [sp, #0xe8c]
 10875a0: 790e7be8     	strh	w8, [sp, #0x73c]
 10875a4: b8412308     	ldur	w8, [x24, #0x12]
 10875a8: 393843e9     	strb	w9, [sp, #0xe10]
 10875ac: 79402f09     	ldrh	w9, [x24, #0x16]
 10875b0: b90e23e8     	str	w8, [sp, #0xe20]
 10875b4: f94053e8     	ldr	x8, [sp, #0xa0]
 10875b8: 791c4be9     	strh	w9, [sp, #0xe24]
 10875bc: f94047e9     	ldr	x9, [sp, #0x88]
 10875c0: 3d8016c0     	str	q0, [x22, #0x50]
 10875c4: 393873ea     	strb	w10, [sp, #0xe1c]
 10875c8: 540002ec     	b.gt	 <L115>
 10875cc: 3500012a     	cbnz	w10,  <L114>
<L113>:
 10875d0: 528956aa     	mov	w10, #0x4ab5            // =19125
 10875d4: 528003ab     	mov	w11, #0x1d              // =29
 10875d8: 391d5adf     	strb	wzr, [x22, #0x756]
 10875dc: 8b0a026a     	add	x10, x19, x10
 10875e0: 79130e6b     	strh	w11, [x19, #0x986]
 10875e4: ad400540     	ldp	q0, q1, [x10]
 10875e8: ad0686c0     	stp	q0, q1, [x22, #0xd0]
 10875ec: 1400002a     	b	 <L118>
<L114>:
 10875f0: 52895eaa     	mov	w10, #0x4af5            // =19189
 10875f4: 528002eb     	mov	w11, #0x17              // =23
 10875f8: 8b0a026a     	add	x10, x19, x10
 10875fc: 79130e6b     	strh	w11, [x19, #0x986]
 1087600: 5280002b     	mov	w11, #0x1               // =1
 1087604: ad410540     	ldp	q0, q1, [x10, #0x20]
 1087608: 391d5acb     	strb	w11, [x22, #0x756]
 108760c: 3941014b     	ldrb	w11, [x10, #0x40]
 1087610: ad0786c0     	stp	q0, q1, [x22, #0xf0]
 1087614: ad400141     	ldp	q1, q0, [x10]
 1087618: 393cc3eb     	strb	w11, [sp, #0xf30]
 108761c: ad0682c1     	stp	q1, q0, [x22, #0xd0]
 1087620: 1400001d     	b	 <L118>
<L115>:
 1087624: 7100095f     	cmp	w10, #0x2
 1087628: 54000201     	b.ne	 <L117>
<L116>:
 108762c: 52896cca     	mov	w10, #0x4b66            // =19302
 1087630: 5280030b     	mov	w11, #0x18              // =24
 1087634: 8b0a026a     	add	x10, x19, x10
 1087638: 79130e6b     	strh	w11, [x19, #0x986]
 108763c: 5280004b     	mov	w11, #0x2               // =2
 1087640: ad420540     	ldp	q0, q1, [x10, #0x40]
 1087644: 391d5acb     	strb	w11, [x22, #0x756]
 1087648: 3941814b     	ldrb	w11, [x10, #0x60]
 108764c: ad0886c0     	stp	q0, q1, [x22, #0x110]
 1087650: ad400540     	ldp	q0, q1, [x10]
 1087654: 393d43eb     	strb	w11, [sp, #0xf50]
 1087658: ad0686c0     	stp	q0, q1, [x22, #0xd0]
 108765c: ad410940     	ldp	q0, q2, [x10, #0x20]
 1087660: ad078ac0     	stp	q0, q2, [x22, #0xf0]
 1087664: 1400000c     	b	 <L118>
<L117>:
 1087668: 52800068     	mov	w8, #0x3                // =3
 108766c: 911cf3e1     	add	x1, sp, #0x73c
 1087670: 5280d082     	mov	w2, #0x684              // =1668
 1087674: 391d5ac8     	strb	w8, [x22, #0x756]
 1087678: 913bc3e8     	add	x8, sp, #0xef0
 108767c: b27f0100     	orr	x0, x8, #0x2
 1087680: 79130e79     	strh	w25, [x19, #0x986]
 1087684: 791de3f9     	strh	w25, [sp, #0xef0]
 1087688: 940554e8     	bl	 <memcpy>
 108768c: f94047e9     	ldr	x9, [sp, #0x88]
 1087690: f94053e8     	ldr	x8, [sp, #0xa0]
<L118>:
 1087694: 3955826a     	ldrb	w10, [x19, #0x560]
 1087698: f94133e4     	ldr	x4, [sp, #0x260]
 108769c: d1001522     	sub	x2, x9, #0x5
 10876a0: f94137f7     	ldr	x23, [sp, #0x268]
 10876a4: 52894ea9     	mov	w9, #0x4a75             // =19061
 10876a8: f90033fa     	str	x26, [sp, #0x60]
 10876ac: 3400020a     	cbz	w10,  <L119>
 10876b0: 7953066a     	ldrh	w10, [x19, #0x982]
 10876b4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10876b8: 91001501     	add	x1, x8, #0x5
 10876bc: 91160000     	add	x0, x0, #0x580
 10876c0: 8b090263     	add	x3, x19, x9
 10876c4: 913bc3e7     	add	x7, sp, #0xef0
 10876c8: aa1703e5     	mov	x5, x23
 10876cc: 2a1403e6     	mov	w6, w20
 10876d0: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 10876d4: 790003ea     	strh	w10, [sp]
 10876d8: 91160318     	add	x24, x24, #0x580
 10876dc: 97fff7e6     	bl	 <server_hello.encodeWithKeyShareAndPsk>
 10876e0: 796b23e8     	ldrh	w8, [sp, #0x1590]
 10876e4: 340001c8     	cbz	w8,  <L120>
 10876e8: 14000463     	b	 <L164>
<L119>:
 10876ec: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10876f0: 91001501     	add	x1, x8, #0x5
 10876f4: 8b090263     	add	x3, x19, x9
 10876f8: 91166000     	add	x0, x0, #0x598
 10876fc: 913bc3e7     	add	x7, sp, #0xef0
 1087700: aa1703e5     	mov	x5, x23
 1087704: 2a1403e6     	mov	w6, w20
 1087708: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 108770c: 91166318     	add	x24, x24, #0x598
 1087710: 97fff758     	bl	 <server_hello.encodeWithKeyShare>
 1087714: 796b53e8     	ldrh	w8, [sp, #0x15a8]
 1087718: 35008ae8     	cbnz	w8,  <L164>
<L120>:
 108771c: a9406b18     	ldp	x24, x26, [x24]
 1087720: 528002ca     	mov	w10, #0x16              // =22
 1087724: f94053e9     	ldr	x9, [sp, #0xa0]
 1087728: 5ac00b48     	rev	w8, w26
 108772c: 3900012a     	strb	w10, [x9]
 1087730: 5280606a     	mov	w10, #0x303             // =771
 1087734: 53107d08     	lsr	w8, w8, #16
 1087738: 9100174b     	add	x11, x26, #0x5
 108773c: 7800112a     	sturh	w10, [x9, #0x1]
 1087740: 78003128     	sturh	w8, [x9, #0x3]
 1087744: f9405be8     	ldr	x8, [sp, #0xb0]
 1087748: b4000357     	cbz	x23,  <L122>
 108774c: 3966026a     	ldrb	w10, [x19, #0x980]
 1087750: 3500030a     	cbnz	w10,  <L122>
 1087754: f94047ea     	ldr	x10, [sp, #0x88]
 1087758: cb0b014a     	sub	x10, x10, x11
 108775c: f100155f     	cmp	x10, #0x5
 1087760: 54000168     	b.hi	 <L121>
 1087764: 6f00e400     	movi	v0.2d, #0000000000000000
 1087768: 911683ea     	add	x10, sp, #0x5a0
 108776c: 528000a9     	mov	w9, #0x5                // =5
 1087770: 3d821940     	str	q0, [x10, #0x860]
 1087774: 3d821540     	str	q0, [x10, #0x850]
 1087778: 3d821140     	str	q0, [x10, #0x840]
 108777c: 3d820d40     	str	q0, [x10, #0x830]
 1087780: 3d820940     	str	q0, [x10, #0x820]
 1087784: 79002109     	strh	w9, [x8, #0x10]
 1087788: 17fffb42     	b	 <L6>
<L121>:
 108778c: 8b0b0129     	add	x9, x9, x11
 1087790: 5280028a     	mov	w10, #0x14              // =20
 1087794: 5280606b     	mov	w11, #0x303             // =771
 1087798: 72a0200b     	movk	w11, #0x100, lsl #16
 108779c: 3900012a     	strb	w10, [x9]
 10877a0: 5280002a     	mov	w10, #0x1               // =1
 10877a4: b800112b     	stur	w11, [x9, #0x1]
 10877a8: 91002f4b     	add	x11, x26, #0xb
 10877ac: 3900152a     	strb	w10, [x9, #0x5]
<L122>:
 10877b0: ad408ac1     	ldp	q1, q2, [x22, #0x10]
 10877b4: 3dc016c0     	ldr	q0, [x22, #0x50]
 10877b8: 397873e9     	ldrb	w9, [sp, #0xe1c]
 10877bc: 792c23f9     	strh	w25, [sp, #0x1610]
 10877c0: 3d81fac0     	str	q0, [x22, #0x7e0]
 10877c4: 3dc002c0     	ldr	q0, [x22]
 10877c8: 3c822361     	stur	q1, [x27, #0x22]
 10877cc: 3dc00ec1     	ldr	q1, [x22, #0x30]
 10877d0: 3c832362     	stur	q2, [x27, #0x32]
 10877d4: 3cc3f2c2     	ldur	q2, [x22, #0x3f]
 10877d8: 39018769     	strb	w9, [x27, #0x61]
 10877dc: 12000529     	and	w9, w9, #0x3
 10877e0: 7100053f     	cmp	w9, #0x1
 10877e4: 3c842361     	stur	q1, [x27, #0x42]
 10877e8: 3c851362     	stur	q2, [x27, #0x51]
 10877ec: 3c812360     	stur	q0, [x27, #0x12]
 10877f0: f9003beb     	str	x11, [sp, #0x70]
 10877f4: 5400018c     	b.gt	 <L123>
 10877f8: 35000489     	cbnz	w9,  <L124>
 10877fc: 528952a8     	mov	w8, #0x4a95             // =19093
 1087800: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087804: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087808: 8b080260     	add	x0, x19, x8
 108780c: 91180021     	add	x1, x1, #0x600
 1087810: 9116c042     	add	x2, x2, #0x5b0
 1087814: 97ffe8d9     	bl	 <x25519.sharedSecret>
 1087818: 72003c1f     	tst	w0, #0xffff
 108781c: 54000480     	b.eq	 <L125>
 1087820: 1400041d     	b	 <L165>
<L123>:
 1087824: 7100093f     	cmp	w9, #0x2
 1087828: 54000461     	b.ne	 <L126>
 108782c: ad408ac1     	ldp	q1, q2, [x22, #0x10]
 1087830: 528966c8     	mov	w8, #0x4b36             // =19254
 1087834: 3dc016c0     	ldr	q0, [x22, #0x50]
 1087838: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 108783c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087840: 8b080260     	add	x0, x19, x8
 1087844: 9119c021     	add	x1, x1, #0x670
 1087848: 9116c042     	add	x2, x2, #0x5b0
 108784c: 3d801f60     	str	q0, [x27, #0x70]
 1087850: 3dc002c0     	ldr	q0, [x22]
 1087854: 3c892361     	stur	q1, [x27, #0x92]
 1087858: 3dc00ec1     	ldr	q1, [x22, #0x30]
 108785c: 3c8a2362     	stur	q2, [x27, #0xa2]
 1087860: 3cc3f2c2     	ldur	q2, [x22, #0x3f]
 1087864: 792d03f9     	strh	w25, [sp, #0x1680]
 1087868: 3c8b2361     	stur	q1, [x27, #0xb2]
 108786c: 3c8c1362     	stur	q2, [x27, #0xc1]
 1087870: 3c882360     	stur	q0, [x27, #0x82]
 1087874: 97ffe957     	bl	 <p384.sharedSecret>
 1087878: 72003c1f     	tst	w0, #0xffff
 108787c: 540080c1     	b.ne	 <L165>
 1087880: 52800617     	mov	w23, #0x30              // =48
 1087884: 14000014     	b	 <L127>
<L124>:
 1087888: 52895aa8     	mov	w8, #0x4ad5             // =19157
 108788c: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087890: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087894: 8b080260     	add	x0, x19, x8
 1087898: 91180021     	add	x1, x1, #0x600
 108789c: 9116c042     	add	x2, x2, #0x5b0
 10878a0: 97ffe90d     	bl	 <p256.sharedSecret>
 10878a4: 72003c1f     	tst	w0, #0xffff
 10878a8: 54007f61     	b.ne	 <L165>
<L125>:
 10878ac: 52800417     	mov	w23, #0x20              // =32
 10878b0: 14000009     	b	 <L127>
<L126>:
 10878b4: 397843e9     	ldrb	w9, [sp, #0xe10]
 10878b8: 92401937     	and	x23, x9, #0x7f
 10878bc: 34007837     	cbz	w23,  <L159>
 10878c0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10878c4: 913703e1     	add	x1, sp, #0xdc0
 10878c8: aa1703e2     	mov	x2, x23
 10878cc: 9116c000     	add	x0, x0, #0x5b0
 10878d0: 94055456     	bl	 <memcpy>
<L127>:
 10878d4: f94057e8     	ldr	x8, [sp, #0xa8]
 10878d8: 910c426b     	add	x11, x19, #0x310
 10878dc: 3943c269     	ldrb	w9, [x19, #0xf0]
 10878e0: 5282604a     	mov	w10, #0x1302            // =4866
 10878e4: aa1503e1     	mov	x1, x21
 10878e8: f90047f7     	str	x23, [sp, #0x88]
 10878ec: 6b0a029f     	cmp	w20, w10
 10878f0: 9119b96a     	add	x10, x11, #0x66e
 10878f4: a9052beb     	stp	x11, x10, [sp, #0x50]
 10878f8: 540002a1     	b.ne	 <L128>
 10878fc: 340005c9     	cbz	w9,  <L129>
 1087900: ad460660     	ldp	q0, q1, [x19, #0xc0]
 1087904: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1087908: 3dc03a62     	ldr	q2, [x19, #0xe0]
 108790c: 911f0129     	add	x9, x9, #0x7c0
 1087910: ad140760     	stp	q0, q1, [x27, #0x280]
 1087914: ad440660     	ldp	q0, q1, [x19, #0x80]
 1087918: 3d80ab62     	str	q2, [x27, #0x2a0]
 108791c: ad120760     	stp	q0, q1, [x27, #0x240]
 1087920: ad450a60     	ldp	q0, q2, [x19, #0xa0]
 1087924: ad130b60     	stp	q0, q2, [x27, #0x260]
 1087928: ad420261     	ldp	q1, q0, [x19, #0x40]
 108792c: ad100361     	stp	q1, q0, [x27, #0x200]
 1087930: ad430a60     	ldp	q0, q2, [x19, #0x60]
 1087934: ad110b60     	stp	q0, q2, [x27, #0x220]
 1087938: ad400261     	ldp	q1, q0, [x19]
 108793c: ad0e0361     	stp	q1, q0, [x27, #0x1c0]
 1087940: ad410a60     	ldp	q0, q2, [x19, #0x20]
 1087944: ad0f0b60     	stp	q0, q2, [x27, #0x1e0]
 1087948: 1400001d     	b	 <L130>
<L128>:
 108794c: 34000e89     	cbz	w9,  <L135>
 1087950: ad458660     	ldp	q0, q1, [x19, #0xb0]
 1087954: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1087958: 91278129     	add	x9, x9, #0x9e0
 108795c: 3d812760     	str	q0, [x27, #0x490]
 1087960: ad468262     	ldp	q2, q0, [x19, #0xd0]
 1087964: 3d812b61     	str	q1, [x27, #0x4a0]
 1087968: 3d813360     	str	q0, [x27, #0x4c0]
 108796c: ad438261     	ldp	q1, q0, [x19, #0x70]
 1087970: 3d812f62     	str	q2, [x27, #0x4b0]
 1087974: 3d811761     	str	q1, [x27, #0x450]
 1087978: ad448e61     	ldp	q1, q3, [x19, #0x90]
 108797c: 3d811b60     	str	q0, [x27, #0x460]
 1087980: 3d811f61     	str	q1, [x27, #0x470]
 1087984: ad418660     	ldp	q0, q1, [x19, #0x30]
 1087988: 3d812363     	str	q3, [x27, #0x480]
 108798c: 3d810760     	str	q0, [x27, #0x410]
 1087990: ad428a60     	ldp	q0, q2, [x19, #0x50]
 1087994: 3d810b61     	str	q1, [x27, #0x420]
 1087998: ad408e61     	ldp	q1, q3, [x19, #0x10]
 108799c: 3d810f60     	str	q0, [x27, #0x430]
 10879a0: 3dc00260     	ldr	q0, [x19]
 10879a4: 3d811362     	str	q2, [x27, #0x440]
 10879a8: ad1f0760     	stp	q0, q1, [x27, #0x3e0]
 10879ac: 3d810363     	str	q3, [x27, #0x400]
 10879b0: 1400005d     	b	 <L136>
<L129>:
 10879b4: d0fffc09     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 10879b8: 91028129     	add	x9, x9, #0xa0
<L130>:
 10879bc: ad450520     	ldp	q0, q1, [x9, #0xa0]
 10879c0: ad0c0760     	stp	q0, q1, [x27, #0x180]
 10879c4: ad460920     	ldp	q0, q2, [x9, #0xc0]
 10879c8: ad0d0b60     	stp	q0, q2, [x27, #0x1a0]
 10879cc: ad430121     	ldp	q1, q0, [x9, #0x60]
 10879d0: ad0a0361     	stp	q1, q0, [x27, #0x140]
 10879d4: ad440122     	ldp	q2, q0, [x9, #0x80]
 10879d8: ad0b0362     	stp	q2, q0, [x27, #0x160]
 10879dc: ad410121     	ldp	q1, q0, [x9, #0x20]
 10879e0: ad080361     	stp	q1, q0, [x27, #0x100]
 10879e4: ad420122     	ldp	q2, q0, [x9, #0x40]
 10879e8: ad090362     	stp	q2, q0, [x27, #0x120]
 10879ec: ad400121     	ldp	q1, q0, [x9]
 10879f0: 3946c369     	ldrb	w9, [x27, #0x1b0]
 10879f4: ad070361     	stp	q1, q0, [x27, #0xe0]
 10879f8: 340002a9     	cbz	w9,  <L131>
 10879fc: 8b09010a     	add	x10, x8, x9
 1087a00: f102015f     	cmp	x10, #0x80
 1087a04: 54000243     	b.lo	 <L131>
 1087a08: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087a0c: 52801008     	mov	w8, #0x80               // =128
 1087a10: 911b814a     	add	x10, x10, #0x6e0
 1087a14: cb090119     	sub	x25, x8, x9
 1087a18: 91014154     	add	x20, x10, #0x50
 1087a1c: aa1903e2     	mov	x2, x25
 1087a20: 8b090280     	add	x0, x20, x9
 1087a24: 94055401     	bl	 <memcpy>
 1087a28: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087a2c: aa1403e1     	mov	x1, x20
 1087a30: 911b8000     	add	x0, x0, #0x6e0
 1087a34: 94006fa5     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087a38: f94057e8     	ldr	x8, [sp, #0xa8]
 1087a3c: aa1503e1     	mov	x1, x21
 1087a40: 2a1f03e9     	mov	w9, wzr
 1087a44: 3906c37f     	strb	wzr, [x27, #0x1b0]
 1087a48: 14000002     	b	 <L132>
<L131>:
 1087a4c: aa1f03f9     	mov	x25, xzr
<L132>:
 1087a50: b279032a     	orr	x10, x25, #0x80
 1087a54: eb08015f     	cmp	x10, x8
 1087a58: 54000188     	b.hi	 <L134>
<L133>:
 1087a5c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087a60: 8b190021     	add	x1, x1, x25
 1087a64: 911b8000     	add	x0, x0, #0x6e0
 1087a68: 94006f98     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087a6c: f94057e8     	ldr	x8, [sp, #0xa8]
 1087a70: 91040329     	add	x9, x25, #0x100
 1087a74: aa1503e1     	mov	x1, x21
 1087a78: 91020339     	add	x25, x25, #0x80
 1087a7c: eb08013f     	cmp	x9, x8
 1087a80: 54fffee9     	b.ls	 <L133>
 1087a84: 3946c369     	ldrb	w9, [x27, #0x1b0]
<L134>:
 1087a88: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087a8c: cb190115     	sub	x21, x8, x25
 1087a90: 8b190021     	add	x1, x1, x25
 1087a94: 911b814a     	add	x10, x10, #0x6e0
 1087a98: aa1503e2     	mov	x2, x21
 1087a9c: aa0803f6     	mov	x22, x8
 1087aa0: 91014154     	add	x20, x10, #0x50
 1087aa4: 8b294280     	add	x0, x20, w9, uxtw
 1087aa8: 940553e0     	bl	 <memcpy>
 1087aac: f94b73e9     	ldr	x9, [sp, #0x16e0]
 1087ab0: 3946c368     	ldrb	w8, [x27, #0x1b0]
 1087ab4: f94b77ea     	ldr	x10, [sp, #0x16e8]
 1087ab8: ab160129     	adds	x9, x9, x22
 1087abc: 0b150108     	add	w8, w8, w21
 1087ac0: 9a8a354a     	cinc	x10, x10, hs
 1087ac4: 3906c368     	strb	w8, [x27, #0x1b0]
 1087ac8: f90b73e9     	str	x9, [sp, #0x16e0]
 1087acc: f90b77ea     	str	x10, [sp, #0x16e8]
 1087ad0: 34000c88     	cbz	w8,  <L141>
 1087ad4: 8b080349     	add	x9, x26, x8
 1087ad8: 914007f9     	add	x25, sp, #0x1, lsl #12  // =0x1000
 1087adc: f102013f     	cmp	x9, #0x80
 1087ae0: 913fc339     	add	x25, x25, #0xff0
 1087ae4: 54000ce3     	b.lo	 <L143>
 1087ae8: 52801009     	mov	w9, #0x80               // =128
 1087aec: 8b080280     	add	x0, x20, x8
 1087af0: aa1803e1     	mov	x1, x24
 1087af4: 4b080135     	sub	w21, w9, w8
 1087af8: aa1503e2     	mov	x2, x21
 1087afc: 940553cb     	bl	 <memcpy>
 1087b00: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087b04: aa1403e1     	mov	x1, x20
 1087b08: 911b8000     	add	x0, x0, #0x6e0
 1087b0c: 94006f6f     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087b10: 2a1f03e8     	mov	w8, wzr
 1087b14: 3906c37f     	strb	wzr, [x27, #0x1b0]
 1087b18: 1400005b     	b	 <L144>
<L135>:
 1087b1c: d0fffc09     	adrp	x9, 0x1009000 <__anon_51030+0x980>
 1087b20: 9100c129     	add	x9, x9, #0x30
<L136>:
 1087b24: ad428122     	ldp	q2, q0, [x9, #0x50]
 1087b28: 3dc01123     	ldr	q3, [x9, #0x40]
 1087b2c: ad1e0362     	stp	q2, q0, [x27, #0x3c0]
 1087b30: ad400520     	ldp	q0, q1, [x9]
 1087b34: ad1b8760     	stp	q0, q1, [x27, #0x370]
 1087b38: ad410920     	ldp	q0, q2, [x9, #0x20]
 1087b3c: 394f6369     	ldrb	w9, [x27, #0x3d8]
 1087b40: ad1d0f62     	stp	q2, q3, [x27, #0x3a0]
 1087b44: 3d80e760     	str	q0, [x27, #0x390]
 1087b48: 340002a9     	cbz	w9,  <L137>
 1087b4c: 8b09010a     	add	x10, x8, x9
 1087b50: f101015f     	cmp	x10, #0x40
 1087b54: 54000243     	b.lo	 <L137>
 1087b58: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087b5c: 52800808     	mov	w8, #0x40               // =64
 1087b60: 9125c14a     	add	x10, x10, #0x970
 1087b64: cb090119     	sub	x25, x8, x9
 1087b68: 9100a157     	add	x23, x10, #0x28
 1087b6c: aa1903e2     	mov	x2, x25
 1087b70: 8b0902e0     	add	x0, x23, x9
 1087b74: 940553ad     	bl	 <memcpy>
 1087b78: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087b7c: aa1703e1     	mov	x1, x23
 1087b80: 9125c000     	add	x0, x0, #0x970
 1087b84: 940068d9     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1087b88: f94057e8     	ldr	x8, [sp, #0xa8]
 1087b8c: aa1503e1     	mov	x1, x21
 1087b90: 2a1f03e9     	mov	w9, wzr
 1087b94: 390f637f     	strb	wzr, [x27, #0x3d8]
 1087b98: 14000002     	b	 <L138>
<L137>:
 1087b9c: aa1f03f9     	mov	x25, xzr
<L138>:
 1087ba0: 9101032a     	add	x10, x25, #0x40
 1087ba4: eb08015f     	cmp	x10, x8
 1087ba8: 54000188     	b.hi	 <L140>
<L139>:
 1087bac: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087bb0: 8b190021     	add	x1, x1, x25
 1087bb4: 9125c000     	add	x0, x0, #0x970
 1087bb8: 940068cc     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1087bbc: f94057e8     	ldr	x8, [sp, #0xa8]
 1087bc0: 91020329     	add	x9, x25, #0x80
 1087bc4: aa1503e1     	mov	x1, x21
 1087bc8: 91010339     	add	x25, x25, #0x40
 1087bcc: eb08013f     	cmp	x9, x8
 1087bd0: 54fffee9     	b.ls	 <L139>
 1087bd4: 394f6369     	ldrb	w9, [x27, #0x3d8]
<L140>:
 1087bd8: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087bdc: cb190116     	sub	x22, x8, x25
 1087be0: 8b190021     	add	x1, x1, x25
 1087be4: 9125c14a     	add	x10, x10, #0x970
 1087be8: aa1603e2     	mov	x2, x22
 1087bec: aa0803f7     	mov	x23, x8
 1087bf0: 9100a155     	add	x21, x10, #0x28
 1087bf4: 8b2942a0     	add	x0, x21, w9, uxtw
 1087bf8: 9405538c     	bl	 <memcpy>
 1087bfc: 394f6368     	ldrb	w8, [x27, #0x3d8]
 1087c00: f94ccbe9     	ldr	x9, [sp, #0x1990]
 1087c04: 2b160108     	adds	w8, w8, w22
 1087c08: 8b170129     	add	x9, x9, x23
 1087c0c: 390f6368     	strb	w8, [x27, #0x3d8]
 1087c10: f90ccbe9     	str	x9, [sp, #0x1990]
 1087c14: 540002e0     	b.eq	 <L142>
 1087c18: 8b080349     	add	x9, x26, x8
 1087c1c: 914007f9     	add	x25, sp, #0x1, lsl #12  // =0x1000
 1087c20: f101013f     	cmp	x9, #0x40
 1087c24: 913fc339     	add	x25, x25, #0xff0
 1087c28: 540020c3     	b.lo	 <L149>
 1087c2c: 52800809     	mov	w9, #0x40               // =64
 1087c30: 8b0802a0     	add	x0, x21, x8
 1087c34: aa1803e1     	mov	x1, x24
 1087c38: 4b080136     	sub	w22, w9, w8
 1087c3c: aa1603e2     	mov	x2, x22
 1087c40: 9405537a     	bl	 <memcpy>
 1087c44: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087c48: aa1503e1     	mov	x1, x21
 1087c4c: 9125c000     	add	x0, x0, #0x970
 1087c50: 940068a6     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1087c54: 2a1f03e8     	mov	w8, wzr
 1087c58: 390f637f     	strb	wzr, [x27, #0x3d8]
 1087c5c: 140000fa     	b	 <L150>
<L141>:
 1087c60: 914007f9     	add	x25, sp, #0x1, lsl #12  // =0x1000
 1087c64: aa1f03f5     	mov	x21, xzr
 1087c68: 913fc339     	add	x25, x25, #0xff0
 1087c6c: 14000006     	b	 <L144>
<L142>:
 1087c70: 914007f9     	add	x25, sp, #0x1, lsl #12  // =0x1000
 1087c74: aa1f03f6     	mov	x22, xzr
 1087c78: 913fc339     	add	x25, x25, #0xff0
 1087c7c: 140000f2     	b	 <L150>
<L143>:
 1087c80: aa1f03f5     	mov	x21, xzr
<L144>:
 1087c84: b27902a9     	orr	x9, x21, #0x80
 1087c88: eb1a013f     	cmp	x9, x26
 1087c8c: 54000148     	b.hi	 <L146>
<L145>:
 1087c90: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087c94: 8b150301     	add	x1, x24, x21
 1087c98: 911b8000     	add	x0, x0, #0x6e0
 1087c9c: 94006f0b     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087ca0: 910402a8     	add	x8, x21, #0x100
 1087ca4: 910202b5     	add	x21, x21, #0x80
 1087ca8: eb1a011f     	cmp	x8, x26
 1087cac: 54ffff29     	b.ls	 <L145>
 1087cb0: 3946c368     	ldrb	w8, [x27, #0x1b0]
<L146>:
 1087cb4: 8b284280     	add	x0, x20, w8, uxtw
 1087cb8: cb150354     	sub	x20, x26, x21
 1087cbc: 8b150301     	add	x1, x24, x21
 1087cc0: aa1403e2     	mov	x2, x20
 1087cc4: 94055359     	bl	 <memcpy>
 1087cc8: f94b73e9     	ldr	x9, [sp, #0x16e0]
 1087ccc: 3946c368     	ldrb	w8, [x27, #0x1b0]
 1087cd0: f94b77ea     	ldr	x10, [sp, #0x16e8]
 1087cd4: ab1a0129     	adds	x9, x9, x26
 1087cd8: 0b140108     	add	w8, w8, w20
 1087cdc: 9a8a354a     	cinc	x10, x10, hs
 1087ce0: 3906c368     	strb	w8, [x27, #0x1b0]
 1087ce4: 39558268     	ldrb	w8, [x19, #0x560]
 1087ce8: f90b77ea     	str	x10, [sp, #0x16e8]
 1087cec: f9402bea     	ldr	x10, [sp, #0x50]
 1087cf0: f90b73e9     	str	x9, [sp, #0x16e0]
 1087cf4: 52800029     	mov	w9, #0x1                // =1
 1087cf8: 39000149     	strb	w9, [x10]
 1087cfc: 34000168     	cbz	w8,  <L147>
 1087d00: f942a662     	ldr	x2, [x19, #0x548]
 1087d04: f942a261     	ldr	x1, [x19, #0x540]
 1087d08: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087d0c: b0fffc03     	adrp	x3, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1087d10: 910bf063     	add	x3, x3, #0x2fc
 1087d14: 9122c000     	add	x0, x0, #0x8b0
 1087d18: 914007f4     	add	x20, sp, #0x1, lsl #12  // =0x1000
 1087d1c: 9122c294     	add	x20, x20, #0x8b0
 1087d20: 94006321     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 1087d24: 14000003     	b	 <L148>
<L147>:
 1087d28: f0fffc14     	adrp	x20, 0x100a000 <server_hello.downgrade_tls11_or_below+0xc90>
 1087d2c: 91045694     	add	x20, x20, #0x115
<L148>:
 1087d30: ad4c0760     	ldp	q0, q1, [x27, #0x180]
 1087d34: b0fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1087d38: 910cb108     	add	x8, x8, #0x32c
 1087d3c: 528001a9     	mov	w9, #0xd                // =13
 1087d40: f0fffc0a     	adrp	x10, 0x100a000 <server_hello.downgrade_tls11_or_below+0xc90>
 1087d44: 9104214a     	add	x10, x10, #0x108
 1087d48: 39000b29     	strb	w9, [x25, #0x2]
 1087d4c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087d50: 3d826f60     	str	q0, [x27, #0x9b0]
 1087d54: f940014b     	ldr	x11, [x10]
 1087d58: f8405149     	ldur	x9, [x10, #0x5]
 1087d5c: 3d827361     	str	q1, [x27, #0x9c0]
 1087d60: ad4d0760     	ldp	q0, q1, [x27, #0x1a0]
 1087d64: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087d68: 52860015     	mov	w21, #0x3000            // =12288
 1087d6c: 52800616     	mov	w22, #0x30              // =48
 1087d70: 913b8000     	add	x0, x0, #0xee0
 1087d74: 913fc042     	add	x2, x2, #0xff0
 1087d78: 52800601     	mov	w1, #0x30               // =48
 1087d7c: 3d827760     	str	q0, [x27, #0x9d0]
 1087d80: 52800823     	mov	w3, #0x41               // =65
 1087d84: aa1403e4     	mov	x4, x20
 1087d88: 3d827b61     	str	q1, [x27, #0x9e0]
 1087d8c: ad4a0760     	ldp	q0, q1, [x27, #0x140]
 1087d90: d0fffc1a     	adrp	x26, 0x1009000 <__anon_51030+0x980>
 1087d94: 913da75a     	add	x26, x26, #0xf69
 1087d98: f800332b     	stur	x11, [x25, #0x3]
 1087d9c: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 1087da0: 3d825f60     	str	q0, [x27, #0x970]
 1087da4: 3d826361     	str	q1, [x27, #0x980]
 1087da8: ad4b0760     	ldp	q0, q1, [x27, #0x160]
 1087dac: f90fffe9     	str	x9, [sp, #0x1ff8]
 1087db0: 39004336     	strb	w22, [x25, #0x10]
 1087db4: 3d826760     	str	q0, [x27, #0x990]
 1087db8: 3d826b61     	str	q1, [x27, #0x9a0]
 1087dbc: ad480760     	ldp	q0, q1, [x27, #0x100]
 1087dc0: 3d824f60     	str	q0, [x27, #0x930]
 1087dc4: 3d825361     	str	q1, [x27, #0x940]
 1087dc8: ad490760     	ldp	q0, q1, [x27, #0x120]
 1087dcc: 3d825760     	str	q0, [x27, #0x950]
 1087dd0: 3d825b61     	str	q1, [x27, #0x960]
 1087dd4: ad470760     	ldp	q0, q1, [x27, #0xe0]
 1087dd8: 3d824760     	str	q0, [x27, #0x910]
 1087ddc: 3d824b61     	str	q1, [x27, #0x920]
 1087de0: ad400500     	ldp	q0, q1, [x8]
 1087de4: 3c811320     	stur	q0, [x25, #0x11]
 1087de8: 3dc00900     	ldr	q0, [x8, #0x20]
 1087dec: 3c821321     	stur	q1, [x25, #0x21]
 1087df0: 3c831320     	stur	q0, [x25, #0x31]
 1087df4: 9400639a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087df8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087dfc: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087e00: 914007e3     	add	x3, sp, #0x1, lsl #12   // =0x1000
 1087e04: 913a0000     	add	x0, x0, #0xe80
 1087e08: 9116c021     	add	x1, x1, #0x5b0
 1087e0c: 913b8063     	add	x3, x3, #0xee0
 1087e10: aa1703e2     	mov	x2, x23
 1087e14: 940062e4     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 1087e18: 6f00e400     	movi	v0.2d, #0000000000000000
 1087e1c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087e20: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087e24: 913c4000     	add	x0, x0, #0xf10
 1087e28: 913ac021     	add	x1, x1, #0xeb0
 1087e2c: 3d824360     	str	q0, [x27, #0x900]
 1087e30: 3d823f60     	str	q0, [x27, #0x8f0]
 1087e34: 3d823b60     	str	q0, [x27, #0x8e0]
 1087e38: 94006596     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 1087e3c: 3dc00340     	ldr	q0, [x26]
 1087e40: 3dc23361     	ldr	q1, [x27, #0x8c0]
 1087e44: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087e48: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087e4c: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1087e50: 52800254     	mov	w20, #0x12              // =18
 1087e54: 3c803320     	stur	q0, [x25, #0x3]
 1087e58: 3dc22f60     	ldr	q0, [x27, #0x8b0]
 1087e5c: 528c6d37     	mov	w23, #0x6369            // =25449
 1087e60: 913b8000     	add	x0, x0, #0xee0
 1087e64: 913fc042     	add	x2, x2, #0xff0
 1087e68: 913a0084     	add	x4, x4, #0xe80
 1087e6c: 3c816320     	stur	q0, [x25, #0x16]
 1087e70: 3dc23760     	ldr	q0, [x27, #0x8d0]
 1087e74: 52800601     	mov	w1, #0x30               // =48
 1087e78: 528008c3     	mov	w3, #0x46               // =70
 1087e7c: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 1087e80: 39000b34     	strb	w20, [x25, #0x2]
 1087e84: 78013337     	sturh	w23, [x25, #0x13]
 1087e88: 39005736     	strb	w22, [x25, #0x15]
 1087e8c: 3c826321     	stur	q1, [x25, #0x26]
 1087e90: 3c836320     	stur	q0, [x25, #0x36]
 1087e94: 94006372     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087e98: d0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1087e9c: 913ded08     	add	x8, x8, #0xf7b
 1087ea0: 3dc23361     	ldr	q1, [x27, #0x8c0]
 1087ea4: 3dc00100     	ldr	q0, [x8]
 1087ea8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087eac: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087eb0: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1087eb4: 913c4000     	add	x0, x0, #0xf10
 1087eb8: 913fc042     	add	x2, x2, #0xff0
 1087ebc: 3c803320     	stur	q0, [x25, #0x3]
 1087ec0: 3dc22f60     	ldr	q0, [x27, #0x8b0]
 1087ec4: 913a0084     	add	x4, x4, #0xe80
 1087ec8: 52800601     	mov	w1, #0x30               // =48
 1087ecc: 528008c3     	mov	w3, #0x46               // =70
 1087ed0: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 1087ed4: 3c816320     	stur	q0, [x25, #0x16]
 1087ed8: 3dc23760     	ldr	q0, [x27, #0x8d0]
 1087edc: 39000b34     	strb	w20, [x25, #0x2]
 1087ee0: 78013337     	sturh	w23, [x25, #0x13]
 1087ee4: 39005736     	strb	w22, [x25, #0x15]
 1087ee8: 3c826321     	stur	q1, [x25, #0x26]
 1087eec: 3c836320     	stur	q0, [x25, #0x36]
 1087ef0: 9400635b     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087ef4: b0fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1087ef8: 913da108     	add	x8, x8, #0xf68
 1087efc: 3dc22360     	ldr	q0, [x27, #0x880]
 1087f00: 3dc22761     	ldr	q1, [x27, #0x890]
 1087f04: 3dc22b62     	ldr	q2, [x27, #0x8a0]
 1087f08: f9400116     	ldr	x22, [x8]
 1087f0c: f8406117     	ldur	x23, [x8, #0x6]
 1087f10: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087f14: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087f18: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1087f1c: 528001d4     	mov	w20, #0xe               // =14
 1087f20: 91244000     	add	x0, x0, #0x910
 1087f24: 913fc042     	add	x2, x2, #0xff0
 1087f28: 913b8084     	add	x4, x4, #0xee0
 1087f2c: 52800601     	mov	w1, #0x30               // =48
 1087f30: 52800243     	mov	w3, #0x12               // =18
 1087f34: ad1a0760     	stp	q0, q1, [x27, #0x340]
 1087f38: 3d80db62     	str	q2, [x27, #0x360]
 1087f3c: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 1087f40: 39000b34     	strb	w20, [x25, #0x2]
 1087f44: f8003336     	stur	x22, [x25, #0x3]
 1087f48: f8009337     	stur	x23, [x25, #0x9]
 1087f4c: 3900473f     	strb	wzr, [x25, #0x11]
 1087f50: 94006343     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087f54: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087f58: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1087f5c: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1087f60: 91238000     	add	x0, x0, #0x8e0
 1087f64: 913fc042     	add	x2, x2, #0xff0
 1087f68: 913c4084     	add	x4, x4, #0xf10
 1087f6c: 52800601     	mov	w1, #0x30               // =48
 1087f70: 52800243     	mov	w3, #0x12               // =18
 1087f74: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 1087f78: 39000b34     	strb	w20, [x25, #0x2]
 1087f7c: f8003336     	stur	x22, [x25, #0x3]
 1087f80: f8009337     	stur	x23, [x25, #0x9]
 1087f84: 3900473f     	strb	wzr, [x25, #0x11]
 1087f88: 94006335     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087f8c: 6f00e400     	movi	v0.2d, #0000000000000000
 1087f90: 3900033f     	strb	wzr, [x25]
 1087f94: 91078a68     	add	x8, x19, #0x1e2
 1087f98: 52826055     	mov	w21, #0x1302            // =4866
 1087f9c: 3d822360     	str	q0, [x27, #0x880]
 1087fa0: 3d822760     	str	q0, [x27, #0x890]
 1087fa4: 3d822b60     	str	q0, [x27, #0x8a0]
 1087fa8: 3d823b60     	str	q0, [x27, #0x8e0]
 1087fac: 3d823f60     	str	q0, [x27, #0x8f0]
 1087fb0: 3d824360     	str	q0, [x27, #0x900]
 1087fb4: 3d824760     	str	q0, [x27, #0x910]
 1087fb8: 3d824b60     	str	q0, [x27, #0x920]
 1087fbc: 3d824f60     	str	q0, [x27, #0x930]
 1087fc0: ad4c0760     	ldp	q0, q1, [x27, #0x180]
 1087fc4: 7903c275     	strh	w21, [x19, #0x1e0]
 1087fc8: 390c0a7f     	strb	wzr, [x19, #0x302]
 1087fcc: ad0d0660     	stp	q0, q1, [x19, #0x1a0]
 1087fd0: ad4d0362     	ldp	q2, q0, [x27, #0x1a0]
 1087fd4: ad0e0262     	stp	q2, q0, [x19, #0x1c0]
 1087fd8: ad4a0361     	ldp	q1, q0, [x27, #0x140]
 1087fdc: ad0b0261     	stp	q1, q0, [x19, #0x160]
 1087fe0: ad4b0362     	ldp	q2, q0, [x27, #0x160]
 1087fe4: 7942e274     	ldrh	w20, [x19, #0x170]
 1087fe8: ad0c0262     	stp	q2, q0, [x19, #0x180]
 1087fec: ad480361     	ldp	q1, q0, [x27, #0x100]
 1087ff0: ad090261     	stp	q1, q0, [x19, #0x120]
 1087ff4: ad490362     	ldp	q2, q0, [x27, #0x120]
 1087ff8: ad0a0262     	stp	q2, q0, [x19, #0x140]
 1087ffc: ad470361     	ldp	q1, q0, [x27, #0xe0]
 1088000: ad080261     	stp	q1, q0, [x19, #0x100]
 1088004: ad5a0362     	ldp	q2, q0, [x27, #0x340]
 1088008: 3dc0db61     	ldr	q1, [x27, #0x360]
 108800c: ad000102     	stp	q2, q0, [x8]
 1088010: 3dc0cf62     	ldr	q2, [x27, #0x330]
 1088014: 3d800901     	str	q1, [x8, #0x20]
 1088018: ad588760     	ldp	q0, q1, [x27, #0x310]
 108801c: 91084a68     	add	x8, x19, #0x212
 1088020: 3d800902     	str	q2, [x8, #0x20]
 1088024: ad000500     	stp	q0, q1, [x8]
 1088028: ad578f60     	ldp	q0, q3, [x27, #0x2f0]
 108802c: 3dc0bb61     	ldr	q1, [x27, #0x2e0]
 1088030: 91090a68     	add	x8, x19, #0x242
 1088034: ad008d00     	stp	q0, q3, [x8, #0x10]
 1088038: 3d800101     	str	q1, [x8]
 108803c: 140000cd     	b	 <L155>
<L149>:
 1088040: aa1f03f6     	mov	x22, xzr
<L150>:
 1088044: 910102c9     	add	x9, x22, #0x40
 1088048: eb1a013f     	cmp	x9, x26
 108804c: 54000148     	b.hi	 <L152>
<L151>:
 1088050: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088054: 8b160301     	add	x1, x24, x22
 1088058: 9125c000     	add	x0, x0, #0x970
 108805c: 940067a3     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1088060: 910202c8     	add	x8, x22, #0x80
 1088064: 910102d6     	add	x22, x22, #0x40
 1088068: eb1a011f     	cmp	x8, x26
 108806c: 54ffff29     	b.ls	 <L151>
 1088070: 394f6368     	ldrb	w8, [x27, #0x3d8]
<L152>:
 1088074: 8b2842a0     	add	x0, x21, w8, uxtw
 1088078: cb160355     	sub	x21, x26, x22
 108807c: 8b160301     	add	x1, x24, x22
 1088080: aa1503e2     	mov	x2, x21
 1088084: 94055269     	bl	 <memcpy>
 1088088: 394f6368     	ldrb	w8, [x27, #0x3d8]
 108808c: f94ccbe9     	ldr	x9, [sp, #0x1990]
 1088090: 3955826a     	ldrb	w10, [x19, #0x560]
 1088094: 0b150108     	add	w8, w8, w21
 1088098: 8b1a0129     	add	x9, x9, x26
 108809c: 390f6368     	strb	w8, [x27, #0x3d8]
 10880a0: f90ccbe9     	str	x9, [sp, #0x1990]
 10880a4: 3400016a     	cbz	w10,  <L153>
 10880a8: f942a662     	ldr	x2, [x19, #0x548]
 10880ac: f942a261     	ldr	x1, [x19, #0x540]
 10880b0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10880b4: f0fffe03     	adrp	x3, 0x104b000 <server_hello.hello_retry_request_random+0x30>
 10880b8: 910d4063     	add	x3, x3, #0x350
 10880bc: 912b4000     	add	x0, x0, #0xad0
 10880c0: 914007f5     	add	x21, sp, #0x1, lsl #12  // =0x1000
 10880c4: 912b42b5     	add	x21, x21, #0xad0
 10880c8: 9400654f     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10880cc: 14000003     	b	 <L154>
<L153>:
 10880d0: f0fffe15     	adrp	x21, 0x104b000 <server_hello.hello_retry_request_random+0x30>
 10880d4: 911342b5     	add	x21, x21, #0x4d0
<L154>:
 10880d8: ad5d0760     	ldp	q0, q1, [x27, #0x3a0]
 10880dc: f0fffe08     	adrp	x8, 0x104b000 <server_hello.hello_retry_request_random+0x30>
 10880e0: 911b4108     	add	x8, x8, #0x6d0
 10880e4: f9402be9     	ldr	x9, [sp, #0x50]
 10880e8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10880ec: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10880f0: 52840016     	mov	w22, #0x2000            // =8192
 10880f4: 52800417     	mov	w23, #0x20              // =32
 10880f8: 3d825360     	str	q0, [x27, #0x940]
 10880fc: 913b8000     	add	x0, x0, #0xee0
 1088100: 913fc042     	add	x2, x2, #0xff0
 1088104: 3d825761     	str	q1, [x27, #0x950]
 1088108: ad5e0760     	ldp	q0, q1, [x27, #0x3c0]
 108810c: 3900013f     	strb	wzr, [x9]
 1088110: 52800401     	mov	w1, #0x20               // =32
 1088114: 52800623     	mov	w3, #0x31               // =49
 1088118: aa1503e4     	mov	x4, x21
 108811c: b0fffc1a     	adrp	x26, 0x1009000 <__anon_51030+0x980>
 1088120: 913da75a     	add	x26, x26, #0xf69
 1088124: 3d825f61     	str	q1, [x27, #0x970]
 1088128: ad5c0b61     	ldp	q1, q2, [x27, #0x380]
 108812c: 3d825b60     	str	q0, [x27, #0x960]
 1088130: 3dc0df60     	ldr	q0, [x27, #0x370]
 1088134: 793fe3f6     	strh	w22, [sp, #0x1ff0]
 1088138: 3d824760     	str	q0, [x27, #0x910]
 108813c: 3d824b61     	str	q1, [x27, #0x920]
 1088140: ad400500     	ldp	q0, q1, [x8]
 1088144: 528001a8     	mov	w8, #0xd                // =13
 1088148: 3d824f62     	str	q2, [x27, #0x930]
 108814c: 39000b28     	strb	w8, [x25, #0x2]
 1088150: d0fffc08     	adrp	x8, 0x100a000 <server_hello.downgrade_tls11_or_below+0xc90>
 1088154: 91042108     	add	x8, x8, #0x108
 1088158: f9400109     	ldr	x9, [x8]
 108815c: f8405108     	ldur	x8, [x8, #0x5]
 1088160: 3c811320     	stur	q0, [x25, #0x11]
 1088164: 39004337     	strb	w23, [x25, #0x10]
 1088168: f8003329     	stur	x9, [x25, #0x3]
 108816c: f90fffe8     	str	x8, [sp, #0x1ff8]
 1088170: 3c821321     	stur	q1, [x25, #0x21]
 1088174: 9400659d     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088178: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108817c: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1088180: 914007e3     	add	x3, sp, #0x1, lsl #12   // =0x1000
 1088184: f94047e2     	ldr	x2, [sp, #0x88]
 1088188: 913a0000     	add	x0, x0, #0xe80
 108818c: 9116c021     	add	x1, x1, #0x5b0
 1088190: 913b8063     	add	x3, x3, #0xee0
 1088194: 9400651c     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 1088198: 6f00e400     	movi	v0.2d, #0000000000000000
 108819c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10881a0: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10881a4: 913c4000     	add	x0, x0, #0xf10
 10881a8: 913ac021     	add	x1, x1, #0xeb0
 10881ac: 3d823f60     	str	q0, [x27, #0x8f0]
 10881b0: 3d823b60     	str	q0, [x27, #0x8e0]
 10881b4: 94006701     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10881b8: 3dc00340     	ldr	q0, [x26]
 10881bc: 3dc23361     	ldr	q1, [x27, #0x8c0]
 10881c0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10881c4: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10881c8: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10881cc: 52800255     	mov	w21, #0x12              // =18
 10881d0: 3c803320     	stur	q0, [x25, #0x3]
 10881d4: 3dc22f60     	ldr	q0, [x27, #0x8b0]
 10881d8: 528c6d38     	mov	w24, #0x6369            // =25449
 10881dc: 913b8000     	add	x0, x0, #0xee0
 10881e0: 913fc042     	add	x2, x2, #0xff0
 10881e4: 913a0084     	add	x4, x4, #0xe80
 10881e8: 52800401     	mov	w1, #0x20               // =32
 10881ec: 528006c3     	mov	w3, #0x36               // =54
 10881f0: 793fe3f6     	strh	w22, [sp, #0x1ff0]
 10881f4: 39000b35     	strb	w21, [x25, #0x2]
 10881f8: 78013338     	sturh	w24, [x25, #0x13]
 10881fc: 39005737     	strb	w23, [x25, #0x15]
 1088200: 3c816320     	stur	q0, [x25, #0x16]
 1088204: 3c826321     	stur	q1, [x25, #0x26]
 1088208: 94006578     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 108820c: b0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1088210: 913ded08     	add	x8, x8, #0xf7b
 1088214: 3dc23361     	ldr	q1, [x27, #0x8c0]
 1088218: 3dc00100     	ldr	q0, [x8]
 108821c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088220: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1088224: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1088228: 913c4000     	add	x0, x0, #0xf10
 108822c: 913fc042     	add	x2, x2, #0xff0
 1088230: 3c803320     	stur	q0, [x25, #0x3]
 1088234: 3dc22f60     	ldr	q0, [x27, #0x8b0]
 1088238: 913a0084     	add	x4, x4, #0xe80
 108823c: 52800401     	mov	w1, #0x20               // =32
 1088240: 528006c3     	mov	w3, #0x36               // =54
 1088244: 793fe3f6     	strh	w22, [sp, #0x1ff0]
 1088248: 39000b35     	strb	w21, [x25, #0x2]
 108824c: 78013338     	sturh	w24, [x25, #0x13]
 1088250: 39005737     	strb	w23, [x25, #0x15]
 1088254: 3c816320     	stur	q0, [x25, #0x16]
 1088258: 3c826321     	stur	q1, [x25, #0x26]
 108825c: 94006563     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088260: 90fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23b8>
 1088264: 913da108     	add	x8, x8, #0xf68
 1088268: 3dc22360     	ldr	q0, [x27, #0x880]
 108826c: 3dc22761     	ldr	q1, [x27, #0x890]
 1088270: f9400117     	ldr	x23, [x8]
 1088274: f8406118     	ldur	x24, [x8, #0x6]
 1088278: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108827c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1088280: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1088284: 528001d5     	mov	w21, #0xe               // =14
 1088288: 912c4000     	add	x0, x0, #0xb10
 108828c: 913fc042     	add	x2, x2, #0xff0
 1088290: 913b8084     	add	x4, x4, #0xee0
 1088294: 52800401     	mov	w1, #0x20               // =32
 1088298: 52800243     	mov	w3, #0x12               // =18
 108829c: 793fe3f6     	strh	w22, [sp, #0x1ff0]
 10882a0: 3d814f60     	str	q0, [x27, #0x530]
 10882a4: 3d815361     	str	q1, [x27, #0x540]
 10882a8: 39000b35     	strb	w21, [x25, #0x2]
 10882ac: f8003337     	stur	x23, [x25, #0x3]
 10882b0: f8009338     	stur	x24, [x25, #0x9]
 10882b4: 3900473f     	strb	wzr, [x25, #0x11]
 10882b8: 9400654c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10882bc: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10882c0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10882c4: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10882c8: 912bc000     	add	x0, x0, #0xaf0
 10882cc: 913fc042     	add	x2, x2, #0xff0
 10882d0: 913c4084     	add	x4, x4, #0xf10
 10882d4: 52800401     	mov	w1, #0x20               // =32
 10882d8: 52800243     	mov	w3, #0x12               // =18
 10882dc: 793fe3f6     	strh	w22, [sp, #0x1ff0]
 10882e0: 39000b35     	strb	w21, [x25, #0x2]
 10882e4: f8003337     	stur	x23, [x25, #0x3]
 10882e8: f8009338     	stur	x24, [x25, #0x9]
 10882ec: 3900473f     	strb	wzr, [x25, #0x11]
 10882f0: 9400653e     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10882f4: 6f00e400     	movi	v0.2d, #0000000000000000
 10882f8: 3900033f     	strb	wzr, [x25]
 10882fc: 9105ca68     	add	x8, x19, #0x172
 1088300: 3d822360     	str	q0, [x27, #0x880]
 1088304: 3d822760     	str	q0, [x27, #0x890]
 1088308: 3d823f60     	str	q0, [x27, #0x8f0]
 108830c: 3d823b60     	str	q0, [x27, #0x8e0]
 1088310: 3d824b60     	str	q0, [x27, #0x920]
 1088314: 3d824760     	str	q0, [x27, #0x910]
 1088318: ad5d8760     	ldp	q0, q1, [x27, #0x3b0]
 108831c: 3dc0f762     	ldr	q2, [x27, #0x3d0]
 1088320: 7943c275     	ldrh	w21, [x19, #0x1e0]
 1088324: 7902e274     	strh	w20, [x19, #0x170]
 1088328: 3d805a62     	str	q2, [x19, #0x160]
 108832c: ad0a0660     	stp	q0, q1, [x19, #0x140]
 1088330: ad5b8760     	ldp	q0, q1, [x27, #0x370]
 1088334: 3908ca7f     	strb	wzr, [x19, #0x232]
 1088338: ad080660     	stp	q0, q1, [x19, #0x100]
 108833c: ad5c8b60     	ldp	q0, q2, [x27, #0x390]
 1088340: 3dc15361     	ldr	q1, [x27, #0x540]
 1088344: ad090a60     	stp	q0, q2, [x19, #0x120]
 1088348: 3dc14f60     	ldr	q0, [x27, #0x530]
 108834c: 3dc14b62     	ldr	q2, [x27, #0x520]
 1088350: ad000500     	stp	q0, q1, [x8]
 1088354: 3dc14760     	ldr	q0, [x27, #0x510]
 1088358: 91064a68     	add	x8, x19, #0x192
 108835c: 3dc14361     	ldr	q1, [x27, #0x500]
 1088360: ad000900     	stp	q0, q2, [x8]
 1088364: 3dc13f60     	ldr	q0, [x27, #0x4f0]
 1088368: 9106ca68     	add	x8, x19, #0x1b2
 108836c: ad000500     	stp	q0, q1, [x8]
<L155>:
 1088370: 6f00e400     	movi	v0.2d, #0000000000000000
 1088374: f9402fe8     	ldr	x8, [sp, #0x58]
 1088378: 9105ca76     	add	x22, x19, #0x172
 108837c: b900011f     	str	wzr, [x8]
 1088380: f94037e8     	ldr	x8, [sp, #0x68]
 1088384: ad000100     	stp	q0, q0, [x8]
 1088388: ad010100     	stp	q0, q0, [x8, #0x20]
 108838c: ad020100     	stp	q0, q0, [x8, #0x40]
 1088390: ad030100     	stp	q0, q0, [x8, #0x60]
 1088394: ad040100     	stp	q0, q0, [x8, #0x80]
 1088398: 3c89b100     	stur	q0, [x8, #0x9b]
 108839c: 394c4268     	ldrb	w8, [x19, #0x310]
 10883a0: ad000260     	stp	q0, q0, [x19]
 10883a4: ad010260     	stp	q0, q0, [x19, #0x20]
 10883a8: ad020260     	stp	q0, q0, [x19, #0x40]
 10883ac: ad030260     	stp	q0, q0, [x19, #0x60]
 10883b0: ad040260     	stp	q0, q0, [x19, #0x80]
 10883b4: ad050260     	stp	q0, q0, [x19, #0xa0]
 10883b8: ad060260     	stp	q0, q0, [x19, #0xc0]
 10883bc: ad070260     	stp	q0, q0, [x19, #0xe0]
 10883c0: 36000f88     	tbz	w8, #0x0,  <L156>
 10883c4: ad4a0660     	ldp	q0, q1, [x19, #0x140]
 10883c8: 91064a68     	add	x8, x19, #0x192
 10883cc: 3dc05a62     	ldr	q2, [x19, #0x160]
 10883d0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10883d4: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10883d8: 913fc000     	add	x0, x0, #0xff0
 10883dc: 91334021     	add	x1, x1, #0xcd0
 10883e0: 7900e334     	strh	w20, [x25, #0x70]
 10883e4: ad020720     	stp	q0, q1, [x25, #0x40]
 10883e8: ad480660     	ldp	q0, q1, [x19, #0x100]
 10883ec: 3d801b22     	str	q2, [x25, #0x60]
 10883f0: ad000720     	stp	q0, q1, [x25]
 10883f4: ad490a60     	ldp	q0, q2, [x19, #0x120]
 10883f8: ad010b20     	stp	q0, q2, [x25, #0x20]
 10883fc: ad4002c1     	ldp	q1, q0, [x22]
 1088400: 3dc00102     	ldr	q2, [x8]
 1088404: 3c872321     	stur	q1, [x25, #0x72]
 1088408: 3c882320     	stur	q0, [x25, #0x82]
 108840c: ad408101     	ldp	q1, q0, [x8, #0x10]
 1088410: 3c892322     	stur	q2, [x25, #0x92]
 1088414: 3c8a2321     	stur	q1, [x25, #0xa2]
 1088418: 3dc00d01     	ldr	q1, [x8, #0x30]
 108841c: 3c8b2320     	stur	q0, [x25, #0xb2]
 1088420: 3dc07660     	ldr	q0, [x19, #0x1d0]
 1088424: 3c8c2321     	stur	q1, [x25, #0xc2]
 1088428: 3d803720     	str	q0, [x25, #0xd0]
 108842c: 94006419     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 1088430: 3dc00340     	ldr	q0, [x26]
 1088434: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088438: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 108843c: 52860014     	mov	w20, #0x3000            // =12288
 1088440: 52800256     	mov	w22, #0x12              // =18
 1088444: 528c6d37     	mov	w23, #0x6369            // =25449
 1088448: 3c803320     	stur	q0, [x25, #0x3]
 108844c: 3dc1b760     	ldr	q0, [x27, #0x6d0]
 1088450: 52800618     	mov	w24, #0x30              // =48
 1088454: 91340000     	add	x0, x0, #0xd00
 1088458: 913fc042     	add	x2, x2, #0xff0
 108845c: 91078a64     	add	x4, x19, #0x1e2
 1088460: 3c816320     	stur	q0, [x25, #0x16]
 1088464: 3dc1bb60     	ldr	q0, [x27, #0x6e0]
 1088468: 52800601     	mov	w1, #0x30               // =48
 108846c: 528008c3     	mov	w3, #0x46               // =70
 1088470: 793fe3f4     	strh	w20, [sp, #0x1ff0]
 1088474: 3c826320     	stur	q0, [x25, #0x26]
 1088478: 3dc1bf60     	ldr	q0, [x27, #0x6f0]
 108847c: 39000b36     	strb	w22, [x25, #0x2]
 1088480: 78013337     	sturh	w23, [x25, #0x13]
 1088484: 39005738     	strb	w24, [x25, #0x15]
 1088488: 3c836320     	stur	q0, [x25, #0x36]
 108848c: 940061f4     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1088490: b0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1088494: 913ded08     	add	x8, x8, #0xf7b
 1088498: 3dc1bb61     	ldr	q1, [x27, #0x6e0]
 108849c: 3dc00100     	ldr	q0, [x8]
 10884a0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10884a4: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10884a8: 9134c000     	add	x0, x0, #0xd30
 10884ac: 913fc042     	add	x2, x2, #0xff0
 10884b0: 91078a64     	add	x4, x19, #0x1e2
 10884b4: 3c803320     	stur	q0, [x25, #0x3]
 10884b8: 3dc1b760     	ldr	q0, [x27, #0x6d0]
 10884bc: 52800601     	mov	w1, #0x30               // =48
 10884c0: 528008c3     	mov	w3, #0x46               // =70
 10884c4: 793fe3f4     	strh	w20, [sp, #0x1ff0]
 10884c8: 3c816320     	stur	q0, [x25, #0x16]
 10884cc: 3dc1bf60     	ldr	q0, [x27, #0x6f0]
 10884d0: 39000b36     	strb	w22, [x25, #0x2]
 10884d4: 78013337     	sturh	w23, [x25, #0x13]
 10884d8: 39005738     	strb	w24, [x25, #0x15]
 10884dc: 3c826321     	stur	q1, [x25, #0x26]
 10884e0: 3c836320     	stur	q0, [x25, #0x36]
 10884e4: 940061de     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10884e8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10884ec: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10884f0: 2a1503e1     	mov	w1, w21
 10884f4: 91370000     	add	x0, x0, #0xdc0
 10884f8: 91340042     	add	x2, x2, #0xd00
 10884fc: 97ffd94d     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 1088500: 797c33e8     	ldrh	w8, [sp, #0x1e18]
 1088504: 35001cc8     	cbnz	w8,  <L166>
 1088508: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108850c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1088510: f94eebf6     	ldr	x22, [sp, #0x1dd0]
 1088514: f94eeff4     	ldr	x20, [sp, #0x1dd8]
 1088518: 91388000     	add	x0, x0, #0xe20
 108851c: 9134c042     	add	x2, x2, #0xd30
 1088520: 2a1503e1     	mov	w1, w21
 1088524: 97ffd943     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 1088528: 797cf3e8     	ldrh	w8, [sp, #0x1e78]
 108852c: f94047e2     	ldr	x2, [sp, #0x88]
 1088530: 35001c28     	cbnz	w8,  <L168>
 1088534: 3dc1f360     	ldr	q0, [x27, #0x7c0]
 1088538: 3dc1fb61     	ldr	q1, [x27, #0x7e0]
 108853c: 91122268     	add	x8, x19, #0x488
 1088540: 3dc1ff62     	ldr	q2, [x27, #0x7f0]
 1088544: f94f3be9     	ldr	x9, [sp, #0x1e70]
 1088548: f9022276     	str	x22, [x19, #0x440]
 108854c: 3d810e60     	str	q0, [x19, #0x430]
 1088550: 3dc20360     	ldr	q0, [x27, #0x800]
 1088554: 3d811661     	str	q1, [x19, #0x450]
 1088558: 3dc21361     	ldr	q1, [x27, #0x840]
 108855c: 3d811e60     	str	q0, [x19, #0x470]
 1088560: 3dc21760     	ldr	q0, [x27, #0x850]
 1088564: 3d811a62     	str	q2, [x19, #0x460]
 1088568: 3dc21b62     	ldr	q2, [x27, #0x860]
 108856c: ad010101     	stp	q1, q0, [x8, #0x20]
 1088570: 3dc20b60     	ldr	q0, [x27, #0x820]
 1088574: 3dc20f61     	ldr	q1, [x27, #0x830]
 1088578: 3d801102     	str	q2, [x8, #0x40]
 108857c: ad000500     	stp	q0, q1, [x8]
 1088580: 6f00e400     	movi	v0.2d, #0000000000000000
 1088584: f94f0be8     	ldr	x8, [sp, #0x1e10]
 1088588: f9022674     	str	x20, [x19, #0x448]
 108858c: f9024268     	str	x8, [x19, #0x480]
 1088590: f9026e69     	str	x9, [x19, #0x4d8]
 1088594: 3d81d760     	str	q0, [x27, #0x750]
 1088598: 3d81d360     	str	q0, [x27, #0x740]
 108859c: 3d81cf60     	str	q0, [x27, #0x730]
 10885a0: 3d81cb60     	str	q0, [x27, #0x720]
 10885a4: 3d81c760     	str	q0, [x27, #0x710]
 10885a8: 3d81c360     	str	q0, [x27, #0x700]
 10885ac: 14000069     	b	 <L157>
<L156>:
 10885b0: ad4a0660     	ldp	q0, q1, [x19, #0x140]
 10885b4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10885b8: 3dc05a62     	ldr	q2, [x19, #0x160]
 10885bc: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10885c0: 913fc000     	add	x0, x0, #0xff0
 10885c4: 912d4021     	add	x1, x1, #0xb50
 10885c8: ad020720     	stp	q0, q1, [x25, #0x40]
 10885cc: ad480660     	ldp	q0, q1, [x19, #0x100]
 10885d0: 3d801b22     	str	q2, [x25, #0x60]
 10885d4: ad000720     	stp	q0, q1, [x25]
 10885d8: ad490a60     	ldp	q0, q2, [x19, #0x120]
 10885dc: ad010b20     	stp	q0, q2, [x25, #0x20]
 10885e0: 940065f6     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10885e4: 3dc00340     	ldr	q0, [x26]
 10885e8: 52800257     	mov	w23, #0x12              // =18
 10885ec: 528c6d38     	mov	w24, #0x6369            // =25449
 10885f0: 914007fa     	add	x26, sp, #0x1, lsl #12  // =0x1000
 10885f4: 3dc15b61     	ldr	q1, [x27, #0x560]
 10885f8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10885fc: 3c803320     	stur	q0, [x25, #0x3]
 1088600: 3dc15760     	ldr	q0, [x27, #0x550]
 1088604: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1088608: 52840015     	mov	w21, #0x2000            // =8192
 108860c: 39000b37     	strb	w23, [x25, #0x2]
 1088610: 913fc35a     	add	x26, x26, #0xff0
 1088614: 78013338     	sturh	w24, [x25, #0x13]
 1088618: 52800419     	mov	w25, #0x20              // =32
 108861c: 912dc000     	add	x0, x0, #0xb70
 1088620: 913fc042     	add	x2, x2, #0xff0
 1088624: 52800401     	mov	w1, #0x20               // =32
 1088628: 528006c3     	mov	w3, #0x36               // =54
 108862c: aa1603e4     	mov	x4, x22
 1088630: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 1088634: 39005759     	strb	w25, [x26, #0x15]
 1088638: 3c816340     	stur	q0, [x26, #0x16]
 108863c: 3c826341     	stur	q1, [x26, #0x26]
 1088640: 9400646a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088644: b0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1088648: 913ded08     	add	x8, x8, #0xf7b
 108864c: 3dc15b61     	ldr	q1, [x27, #0x560]
 1088650: 3dc00100     	ldr	q0, [x8]
 1088654: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088658: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 108865c: 912e4000     	add	x0, x0, #0xb90
 1088660: 913fc042     	add	x2, x2, #0xff0
 1088664: 52800401     	mov	w1, #0x20               // =32
 1088668: 3c803340     	stur	q0, [x26, #0x3]
 108866c: 3dc15760     	ldr	q0, [x27, #0x550]
 1088670: 528006c3     	mov	w3, #0x36               // =54
 1088674: aa1603e4     	mov	x4, x22
 1088678: 793fe3f5     	strh	w21, [sp, #0x1ff0]
 108867c: 39000b57     	strb	w23, [x26, #0x2]
 1088680: 78013358     	sturh	w24, [x26, #0x13]
 1088684: 39005759     	strb	w25, [x26, #0x15]
 1088688: 3c816340     	stur	q0, [x26, #0x16]
 108868c: 3c826341     	stur	q1, [x26, #0x26]
 1088690: 94006456     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088694: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088698: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 108869c: 2a1403e1     	mov	w1, w20
 10886a0: 91304000     	add	x0, x0, #0xc10
 10886a4: 912dc042     	add	x2, x2, #0xb70
 10886a8: 97ffd95f     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10886ac: 7978d3e8     	ldrh	w8, [sp, #0x1c68]
 10886b0: 35000fc8     	cbnz	w8,  <L167>
 10886b4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10886b8: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10886bc: f94e13f6     	ldr	x22, [sp, #0x1c20]
 10886c0: f94e17f5     	ldr	x21, [sp, #0x1c28]
 10886c4: 9131c000     	add	x0, x0, #0xc70
 10886c8: 912e4042     	add	x2, x2, #0xb90
 10886cc: 2a1403e1     	mov	w1, w20
 10886d0: 97ffd955     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10886d4: 797993e8     	ldrh	w8, [sp, #0x1cc8]
 10886d8: f94047e2     	ldr	x2, [sp, #0x88]
 10886dc: 35001168     	cbnz	w8,  <L170>
 10886e0: 3dc18760     	ldr	q0, [x27, #0x610]
 10886e4: 3dc18f61     	ldr	q1, [x27, #0x630]
 10886e8: 91122268     	add	x8, x19, #0x488
 10886ec: 3dc19362     	ldr	q2, [x27, #0x640]
 10886f0: f94e63e9     	ldr	x9, [sp, #0x1cc0]
 10886f4: f9022276     	str	x22, [x19, #0x440]
 10886f8: 3d810e60     	str	q0, [x19, #0x430]
 10886fc: 3dc19760     	ldr	q0, [x27, #0x650]
 1088700: 3d811661     	str	q1, [x19, #0x450]
 1088704: 3dc1a761     	ldr	q1, [x27, #0x690]
 1088708: 3d811e60     	str	q0, [x19, #0x470]
 108870c: 3dc1ab60     	ldr	q0, [x27, #0x6a0]
 1088710: 3d811a62     	str	q2, [x19, #0x460]
 1088714: 3dc1af62     	ldr	q2, [x27, #0x6b0]
 1088718: ad010101     	stp	q1, q0, [x8, #0x20]
 108871c: 3dc19f60     	ldr	q0, [x27, #0x670]
 1088720: 3dc1a361     	ldr	q1, [x27, #0x680]
 1088724: 3d801102     	str	q2, [x8, #0x40]
 1088728: ad000500     	stp	q0, q1, [x8]
 108872c: 6f00e400     	movi	v0.2d, #0000000000000000
 1088730: f94e33e8     	ldr	x8, [sp, #0x1c60]
 1088734: f9022675     	str	x21, [x19, #0x448]
 1088738: f9024268     	str	x8, [x19, #0x480]
 108873c: f9026e69     	str	x9, [x19, #0x4d8]
 1088740: 3d816b60     	str	q0, [x27, #0x5a0]
 1088744: 3d816760     	str	q0, [x27, #0x590]
 1088748: 3d816360     	str	q0, [x27, #0x580]
 108874c: 3d815f60     	str	q0, [x27, #0x570]
<L157>:
 1088750: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088754: 2a1f03e1     	mov	w1, wzr
 1088758: 9116c000     	add	x0, x0, #0x5b0
 108875c: 940550f1     	bl	 <memset>
 1088760: f9404be8     	ldr	x8, [sp, #0x90]
 1088764: f9403bea     	ldr	x10, [sp, #0x70]
 1088768: 39400108     	ldrb	w8, [x8]
 108876c: 360000c8     	tbz	w8, #0x0,  <L158>
 1088770: 3954e268     	ldrb	w8, [x19, #0x538]
 1088774: 35000088     	cbnz	w8,  <L158>
 1088778: 52800028     	mov	w8, #0x1                // =1
 108877c: b905767f     	str	wzr, [x19, #0x574]
 1088780: 39290b88     	strb	w8, [x28, #0xa42]
<L158>:
 1088784: 6f00e400     	movi	v0.2d, #0000000000000000
 1088788: f94033e9     	ldr	x9, [sp, #0x60]
 108878c: 52800028     	mov	w8, #0x1                // =1
 1088790: 39000128     	strb	w8, [x9]
 1088794: 911683e8     	add	x8, sp, #0x5a0
 1088798: 3d820900     	str	q0, [x8, #0x820]
 108879c: 3d820d00     	str	q0, [x8, #0x830]
 10887a0: 3d821100     	str	q0, [x8, #0x840]
 10887a4: 3d821500     	str	q0, [x8, #0x850]
 10887a8: 3d821900     	str	q0, [x8, #0x860]
 10887ac: f9405be9     	ldr	x9, [sp, #0xb0]
 10887b0: f94053e8     	ldr	x8, [sp, #0xa0]
 10887b4: 7900213f     	strh	wzr, [x9, #0x10]
 10887b8: a9002928     	stp	x8, x10, [x9]
 10887bc: 17fff735     	b	 <L6>
<L159>:
 10887c0: 528000e0     	mov	w0, #0x7                // =7
<L160>:
 10887c4: 6f00e400     	movi	v0.2d, #0000000000000000
 10887c8: 911683e9     	add	x9, sp, #0x5a0
 10887cc: 3d821920     	str	q0, [x9, #0x860]
 10887d0: 3d821520     	str	q0, [x9, #0x850]
 10887d4: 3d821120     	str	q0, [x9, #0x840]
 10887d8: 3d820d20     	str	q0, [x9, #0x830]
 10887dc: 3d820920     	str	q0, [x9, #0x820]
 10887e0: 79002100     	strh	w0, [x8, #0x10]
 10887e4: 17fff72b     	b	 <L6>
<L161>:
 10887e8: b0fffc0c     	adrp	x12, 0x1009000 <__anon_51030+0x980>
 10887ec: 795ea18c     	ldrh	w12, [x12, #0xf50]
 10887f0: 7104019f     	cmp	w12, #0x100
 10887f4: 540002c3     	b.lo	 <L162>
 10887f8: 1200156b     	and	w11, w11, #0x3f
 10887fc: 9240098c     	and	x12, x12, #0x7
 1088800: 1acc256b     	lsr	w11, w11, w12
 1088804: 3600024b     	tbz	w11, #0x0,  <L162>
 1088808: 3948f74b     	ldrb	w11, [x26, #0x23d]
 108880c: 3400020b     	cbz	w11,  <L162>
 1088810: f94133e5     	ldr	x5, [sp, #0x260]
 1088814: f94137e6     	ldr	x6, [sp, #0x268]
 1088818: 5280030a     	mov	w10, #0x18              // =24
 108881c: 913b63e0     	add	x0, sp, #0xed8
 1088820: 910f83e4     	add	x4, sp, #0x3e0
 1088824: aa1303e1     	mov	x1, x19
 1088828: 2a1403e7     	mov	w7, w20
 108882c: a900a7e8     	stp	x8, x9, [sp, #0x8]
 1088830: 790003ea     	strh	w10, [sp]
 1088834: 94007a22     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 1088838: 795dd3e8     	ldrh	w8, [sp, #0xee8]
 108883c: 350001c8     	cbnz	w8,  <L164>
 1088840: f9476ff4     	ldr	x20, [sp, #0xed8]
 1088844: f94773f5     	ldr	x21, [sp, #0xee0]
 1088848: 17fffa5d     	b	 <L89>
<L162>:
 108884c: 6f00e400     	movi	v0.2d, #0000000000000000
 1088850: 911683eb     	add	x11, sp, #0x5a0
 1088854: b0fffc08     	adrp	x8, 0x1009000 <__anon_51030+0x980>
 1088858: 910f8108     	add	x8, x8, #0x3e0
 108885c: 52800909     	mov	w9, #0x48               // =72
 1088860: 17fffa8a     	b	 <L94>
<L163>:
 1088864: f9405be8     	ldr	x8, [sp, #0xb0]
 1088868: 52800949     	mov	w9, #0x4a               // =74
 108886c: 79002109     	strh	w9, [x8, #0x10]
 1088870: 17fff708     	b	 <L6>
<L164>:
 1088874: 6f00e400     	movi	v0.2d, #0000000000000000
 1088878: 911683e9     	add	x9, sp, #0x5a0
 108887c: 3d821920     	str	q0, [x9, #0x860]
 1088880: 3d821520     	str	q0, [x9, #0x850]
 1088884: 3d821120     	str	q0, [x9, #0x840]
 1088888: 3d820d20     	str	q0, [x9, #0x830]
 108888c: 3d820920     	str	q0, [x9, #0x820]
 1088890: 1400003f     	b	 <L174>
<L165>:
 1088894: f9405be8     	ldr	x8, [sp, #0xb0]
 1088898: 17ffffcb     	b	 <L160>
<L166>:
 108889c: 6f00e400     	movi	v0.2d, #0000000000000000
 10888a0: 2a0803f3     	mov	w19, w8
 10888a4: 14000012     	b	 <L169>
<L167>:
 10888a8: 6f00e400     	movi	v0.2d, #0000000000000000
 10888ac: 2a0803f3     	mov	w19, w8
 10888b0: 14000024     	b	 <L171>
<L168>:
 10888b4: aa1603e0     	mov	x0, x22
 10888b8: 2a0803f3     	mov	w19, w8
 10888bc: 94055149     	bl	 <EVP_CIPHER_CTX_free@plt>
 10888c0: aa1403e0     	mov	x0, x20
 10888c4: 94055147     	bl	 <EVP_CIPHER_CTX_free@plt>
 10888c8: 6f00e400     	movi	v0.2d, #0000000000000000
 10888cc: f90edfff     	str	xzr, [sp, #0x1db8]
 10888d0: f90edbff     	str	xzr, [sp, #0x1db0]
 10888d4: f90ed7ff     	str	xzr, [sp, #0x1da8]
 10888d8: f90ed3ff     	str	xzr, [sp, #0x1da0]
 10888dc: f90ecbff     	str	xzr, [sp, #0x1d90]
 10888e0: 3d81e360     	str	q0, [x27, #0x780]
 10888e4: 3d81df60     	str	q0, [x27, #0x770]
 10888e8: 3d81db60     	str	q0, [x27, #0x760]
<L169>:
 10888ec: 3d81d760     	str	q0, [x27, #0x750]
 10888f0: 3d81d360     	str	q0, [x27, #0x740]
 10888f4: 3d81cf60     	str	q0, [x27, #0x730]
 10888f8: 3d81cb60     	str	q0, [x27, #0x720]
 10888fc: 3d81c760     	str	q0, [x27, #0x710]
 1088900: 3d81c360     	str	q0, [x27, #0x700]
 1088904: 14000013     	b	 <L172>
<L170>:
 1088908: aa1603e0     	mov	x0, x22
 108890c: 2a0803f3     	mov	w19, w8
 1088910: 94055134     	bl	 <EVP_CIPHER_CTX_free@plt>
 1088914: aa1503e0     	mov	x0, x21
 1088918: 94055132     	bl	 <EVP_CIPHER_CTX_free@plt>
 108891c: 6f00e400     	movi	v0.2d, #0000000000000000
 1088920: f90e07ff     	str	xzr, [sp, #0x1c08]
 1088924: f90e03ff     	str	xzr, [sp, #0x1c00]
 1088928: f90dffff     	str	xzr, [sp, #0x1bf8]
 108892c: f90dfbff     	str	xzr, [sp, #0x1bf0]
 1088930: f90df3ff     	str	xzr, [sp, #0x1be0]
 1088934: 3d817760     	str	q0, [x27, #0x5d0]
 1088938: 3d817360     	str	q0, [x27, #0x5c0]
 108893c: 3d816f60     	str	q0, [x27, #0x5b0]
<L171>:
 1088940: 3d816b60     	str	q0, [x27, #0x5a0]
 1088944: 3d816760     	str	q0, [x27, #0x590]
 1088948: 3d816360     	str	q0, [x27, #0x580]
 108894c: 3d815f60     	str	q0, [x27, #0x570]
<L172>:
 1088950: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088954: f94047e2     	ldr	x2, [sp, #0x88]
 1088958: 2a1f03e1     	mov	w1, wzr
 108895c: 9116c000     	add	x0, x0, #0x5b0
 1088960: 94055070     	bl	 <memset>
 1088964: f9405be8     	ldr	x8, [sp, #0xb0]
 1088968: 2a1303e0     	mov	w0, w19
 108896c: 17ffff96     	b	 <L160>
<L173>:
 1088970: 6f00e400     	movi	v0.2d, #0000000000000000
 1088974: 911683e9     	add	x9, sp, #0x5a0
 1088978: 3d820920     	str	q0, [x9, #0x820]
 108897c: 3d820d20     	str	q0, [x9, #0x830]
 1088980: 3d821120     	str	q0, [x9, #0x840]
 1088984: 3d821520     	str	q0, [x9, #0x850]
 1088988: 3d821920     	str	q0, [x9, #0x860]
<L174>:
 108898c: f9405be9     	ldr	x9, [sp, #0xb0]
 1088990: 79002128     	strh	w8, [x9, #0x10]
 1088994: 17fff6bf     	b	 <L6>
<L175>:
 1088998: 6f00e400     	movi	v0.2d, #0000000000000000
 108899c: 911683e8     	add	x8, sp, #0x5a0
 10889a0: 3d821900     	str	q0, [x8, #0x860]
 10889a4: 3d821500     	str	q0, [x8, #0x850]
 10889a8: 3d821100     	str	q0, [x8, #0x840]
 10889ac: 3d820d00     	str	q0, [x8, #0x830]
 10889b0: 3d820900     	str	q0, [x8, #0x820]
 10889b4: f9405be8     	ldr	x8, [sp, #0xb0]
 10889b8: 79002100     	strh	w0, [x8, #0x10]
 10889bc: 17fff6b5     	b	 <L6>
