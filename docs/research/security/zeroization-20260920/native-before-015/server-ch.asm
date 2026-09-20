
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

0000000001086474 <ServerHandshake.processClientHelloMessage>:
 1086474: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
 1086478: a9016ffc     	stp	x28, x27, [sp, #0x10]
 108647c: a90267fa     	stp	x26, x25, [sp, #0x20]
 1086480: a9035ff8     	stp	x24, x23, [sp, #0x30]
 1086484: a90457f6     	stp	x22, x21, [sp, #0x40]
 1086488: a9054ff4     	stp	x20, x19, [sp, #0x50]
 108648c: 910003fd     	mov	x29, sp
 1086490: d1400bff     	sub	sp, sp, #0x2, lsl #12   // =0x2000
 1086494: d10903ff     	sub	sp, sp, #0x240
 1086498: 9140103c     	add	x28, x1, #0x4, lsl #12  // =0x4000
 108649c: aa0103f3     	mov	x19, x1
 10864a0: 39690b88     	ldrb	w8, [x28, #0xa42]
 10864a4: 12000508     	and	w8, w8, #0x3
 10864a8: 7100091f     	cmp	w8, #0x2
 10864ac: 54000061     	b.ne	 <L0>
 10864b0: 39290b9f     	strb	wzr, [x28, #0xa42]
 10864b4: b905767f     	str	wzr, [x19, #0x574]
<L0>:
 10864b8: f941d668     	ldr	x8, [x19, #0x3a8]
 10864bc: f1000d1f     	cmp	x8, #0x3
 10864c0: 54000468     	b.hi	 <L4>
 10864c4: 3966c794     	ldrb	w20, [x28, #0x9b1]
 10864c8: b4000608     	cbz	x8,  <L9>
 10864cc: f941d269     	ldr	x9, [x19, #0x3a0]
 10864d0: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 10864d4: 7940012a     	ldrh	w10, [x9]
 10864d8: 0b0b014a     	add	w10, w10, w11
 10864dc: 7100095f     	cmp	w10, #0x2
 10864e0: 54000368     	b.hi	 <L4>
 10864e4: f100051f     	cmp	x8, #0x1
 10864e8: aa0903ea     	mov	x10, x9
 10864ec: aa0803eb     	mov	x11, x8
 10864f0: 540001e1     	b.ne	 <L3>
<L1>:
 10864f4: 7840254c     	ldrh	w12, [x10], #0x2
 10864f8: 12823d4d     	mov	w13, #-0x11eb           // =-4587
 10864fc: 0b0d018c     	add	w12, w12, w13
 1086500: 71000d9f     	cmp	w12, #0x3
 1086504: 540003a2     	b.hs	 <L7>
 1086508: f100056b     	subs	x11, x11, #0x1
 108650c: 54ffff41     	b.ne	 <L1>
 1086510: 52823daa     	mov	w10, #0x11ed            // =4589
<L2>:
 1086514: 7840252b     	ldrh	w11, [x9], #0x2
 1086518: 6b0a017f     	cmp	w11, w10
 108651c: 54000320     	b.eq	 <L8>
 1086520: f1000508     	subs	x8, x8, #0x1
 1086524: 54ffff81     	b.ne	 <L2>
 1086528: 14000018     	b	 <L9>
<L3>:
 108652c: 7940052a     	ldrh	w10, [x9, #0x2]
 1086530: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 1086534: 0b0b014b     	add	w11, w10, w11
 1086538: 7100097f     	cmp	w11, #0x2
 108653c: 54000088     	b.hi	 <L4>
 1086540: 7940012b     	ldrh	w11, [x9]
 1086544: 6b0a017f     	cmp	w11, w10
 1086548: 54001721     	b.ne	 <L24>
<L4>:
 108654c: 52800788     	mov	w8, #0x3c               // =60
<L5>:
 1086550: 79002008     	strh	w8, [x0, #0x10]
<L6>:
 1086554: 91400bff     	add	sp, sp, #0x2, lsl #12   // =0x2000
 1086558: 910903ff     	add	sp, sp, #0x240
 108655c: a9454ff4     	ldp	x20, x19, [sp, #0x50]
 1086560: a94457f6     	ldp	x22, x21, [sp, #0x40]
 1086564: a9435ff8     	ldp	x24, x23, [sp, #0x30]
 1086568: a94267fa     	ldp	x26, x25, [sp, #0x20]
 108656c: a9416ffc     	ldp	x28, x27, [sp, #0x10]
 1086570: a8c67bfd     	ldp	x29, x30, [sp], #0x60
 1086574: d65f03c0     	ret
<L7>:
 1086578: 528007a8     	mov	w8, #0x3d               // =61
 108657c: 17fffff5     	b	 <L5>
<L8>:
 1086580: 396f1f88     	ldrb	w8, [x28, #0xbc7]
 1086584: 34002ac8     	cbz	w8,  <L35>
<L9>:
 1086588: f9005be0     	str	x0, [sp, #0xb0]
 108658c: 9102e3e0     	add	x0, sp, #0xb8
 1086590: aa0203f5     	mov	x21, x2
 1086594: aa0203e1     	mov	x1, x2
 1086598: aa0303e2     	mov	x2, x3
 108659c: f90047e5     	str	x5, [sp, #0x88]
 10865a0: a90a0fe4     	stp	x4, x3, [sp, #0xa0]
 10865a4: 97ffd590     	bl	 <client_hello.parse>
 10865a8: 794493e8     	ldrh	w8, [sp, #0x248]
 10865ac: 35012648     	cbnz	w8,  <L174>
 10865b0: 52893148     	mov	w8, #0x498a             // =18826
 10865b4: 52893229     	mov	w9, #0x4991             // =18833
 10865b8: 91400bf9     	add	x25, sp, #0x2, lsl #12  // =0x2000
 10865bc: 914007fb     	add	x27, sp, #0x1, lsl #12  // =0x1000
 10865c0: 910943e0     	add	x0, sp, #0x250
 10865c4: 9102e3e1     	add	x1, sp, #0xb8
 10865c8: 52803202     	mov	w2, #0x190              // =400
 10865cc: 8b08027a     	add	x26, x19, x8
 10865d0: 8b090276     	add	x22, x19, x9
 10865d4: 91044339     	add	x25, x25, #0x110
 10865d8: 9120037b     	add	x27, x27, #0x800
 10865dc: 910f83f8     	add	x24, sp, #0x3e0
 10865e0: 910943f7     	add	x23, sp, #0x250
 10865e4: 94055a39     	bl	 <memcpy>
 10865e8: 910f83e0     	add	x0, sp, #0x3e0
 10865ec: 9102e3e1     	add	x1, sp, #0xb8
 10865f0: 52803202     	mov	w2, #0x190              // =400
 10865f4: 94055a35     	bl	 <memcpy>
 10865f8: 340003d4     	cbz	w20,  <L13>
 10865fc: 3cc17340     	ldur	q0, [x26, #0x17]
 1086600: 9115c3e0     	add	x0, sp, #0x570
 1086604: 9102e3e1     	add	x1, sp, #0xb8
 1086608: 3d801fe0     	str	q0, [sp, #0x70]
 108660c: 3dc002c0     	ldr	q0, [x22]
 1086610: 3d8027e0     	str	q0, [sp, #0x90]
 1086614: 94008222     	bl	 <ServerHandshake.retryClientHelloDigest>
 1086618: 3dc06700     	ldr	q0, [x24, #0x190]
 108661c: 3dc027e1     	ldr	q1, [sp, #0x90]
 1086620: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 1086624: 6e205800     	mvn	v0.16b, v0.16b
 1086628: 6e30a800     	umaxv	b0, v0.16b
 108662c: 1e260008     	fmov	w8, s0
 1086630: 37000108     	tbnz	w8, #0x0,  <L10>
 1086634: 3dc06b00     	ldr	q0, [x24, #0x1a0]
 1086638: 3dc01fe1     	ldr	q1, [sp, #0x70]
 108663c: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 1086640: 6e205800     	mvn	v0.16b, v0.16b
 1086644: 6e30a800     	umaxv	b0, v0.16b
 1086648: 1e260008     	fmov	w8, s0
 108664c: 36000b68     	tbz	w8, #0x0,  <L22>
<L10>:
 1086650: f0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 1086654: 910b8108     	add	x8, x8, #0x2e0
 1086658: 3dc00100     	ldr	q0, [x8]
 108665c: 52800948     	mov	w8, #0x4a               // =74
<L11>:
 1086660: f9405be9     	ldr	x9, [sp, #0xb0]
<L12>:
 1086664: 3d800120     	str	q0, [x9]
 1086668: f9000928     	str	x8, [x9, #0x10]
 108666c: 17ffffba     	b	 <L6>
<L13>:
 1086670: f9405be8     	ldr	x8, [sp, #0xb0]
 1086674: f90037f6     	str	x22, [sp, #0x68]
 1086678: 91063ef2     	add	x18, x23, #0x18f
<L14>:
 108667c: 3943c279     	ldrb	w25, [x19, #0xf0]
 1086680: 34000699     	cbz	w25,  <L18>
 1086684: 79530a74     	ldrh	w20, [x19, #0x984]
<L15>:
 1086688: f9004bf2     	str	x18, [sp, #0x90]
 108668c: f941de77     	ldr	x23, [x19, #0x3b8]
 1086690: f941da62     	ldr	x2, [x19, #0x3b0]
 1086694: f94213e0     	ldr	x0, [sp, #0x420]
 1086698: f94217e1     	ldr	x1, [sp, #0x428]
 108669c: 79130a74     	strh	w20, [x19, #0x984]
 10866a0: aa1703e3     	mov	x3, x23
 10866a4: 94006753     	bl	 <client_hello.Parsed.selectAlpn>
 10866a8: f9414fe8     	ldr	x8, [sp, #0x298]
 10866ac: f9020a60     	str	x0, [x19, #0x410]
 10866b0: f9020e61     	str	x1, [x19, #0x418]
 10866b4: b4000108     	cbz	x8,  <L16>
 10866b8: b40000f7     	cbz	x23,  <L16>
 10866bc: b50000c0     	cbnz	x0,  <L16>
 10866c0: f0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 10866c4: 910c4108     	add	x8, x8, #0x310
 10866c8: 3dc00100     	ldr	q0, [x8]
 10866cc: 52800d68     	mov	w8, #0x6b               // =107
 10866d0: 17ffffe4     	b	 <L11>
<L16>:
 10866d4: f94143e9     	ldr	x9, [sp, #0x280]
 10866d8: f94147ea     	ldr	x10, [sp, #0x288]
 10866dc: 911683f7     	add	x23, sp, #0x5a0
 10866e0: f94187e8     	ldr	x8, [sp, #0x308]
 10866e4: f9021269     	str	x9, [x19, #0x420]
 10866e8: f9405be9     	ldr	x9, [sp, #0xb0]
 10866ec: f902166a     	str	x10, [x19, #0x428]
 10866f0: b4000c28     	cbz	x8,  <L25>
 10866f4: f9418be9     	ldr	x9, [sp, #0x310]
 10866f8: b4003549     	cbz	x9,  <L53>
 10866fc: f100853f     	cmp	x9, #0x21
 1086700: 54000e23     	b.lo	 <L31>
 1086704: 4f00e420     	movi	v0.16b, #0x1
 1086708: aa1f03eb     	mov	x11, xzr
<L17>:
 108670c: 3ceb6901     	ldr	q1, [x8, x11]
 1086710: 6e208c21     	cmeq	v1.16b, v1.16b, v0.16b
 1086714: 6e30a821     	umaxv	b1, v1.16b
 1086718: 1e26002a     	fmov	w10, s1
 108671c: 37000fca     	tbnz	w10, #0x0,  <L34>
 1086720: 8b0b010a     	add	x10, x8, x11
 1086724: 3dc00541     	ldr	q1, [x10, #0x10]
 1086728: 6e208c21     	cmeq	v1.16b, v1.16b, v0.16b
 108672c: 6e30a821     	umaxv	b1, v1.16b
 1086730: 1e26002a     	fmov	w10, s1
 1086734: 37000f0a     	tbnz	w10, #0x0,  <L34>
 1086738: 9101016c     	add	x12, x11, #0x40
 108673c: 9100816a     	add	x10, x11, #0x20
 1086740: eb09019f     	cmp	x12, x9
 1086744: aa0a03eb     	mov	x11, x10
 1086748: 54fffe23     	b.lo	 <L17>
 108674c: 1400005f     	b	 <L32>
<L18>:
 1086750: f941ce69     	ldr	x9, [x19, #0x398]
 1086754: b4000a09     	cbz	x9,  <L26>
 1086758: f9412fea     	ldr	x10, [sp, #0x258]
 108675c: b40009ca     	cbz	x10,  <L26>
 1086760: f941ca6c     	ldr	x12, [x19, #0x390]
 1086764: f9412bed     	ldr	x13, [sp, #0x250]
 1086768: aa1f03eb     	mov	x11, xzr
 108676c: 1282606e     	mov	w14, #-0x1304           // =-4868
 1086770: 529fffaf     	mov	w15, #0xfffd            // =65533
 1086774: 14000004     	b	 <L20>
<L19>:
 1086778: 9100056b     	add	x11, x11, #0x1
 108677c: eb09017f     	cmp	x11, x9
 1086780: 540008a0     	b.eq	 <L26>
<L20>:
 1086784: 786b7994     	ldrh	w20, [x12, x11, lsl #1]
 1086788: 0b0e0290     	add	w16, w20, w14
 108678c: 6b3021ff     	cmp	w15, w16, uxth
 1086790: 54ffff48     	b.hi	 <L19>
 1086794: aa1f03f0     	mov	x16, xzr
<L21>:
 1086798: 787069b1     	ldrh	w17, [x13, x16]
 108679c: 5ac00a31     	rev	w17, w17
 10867a0: 6b51429f     	cmp	w20, w17, lsr #16
 10867a4: 54fff720     	b.eq	 <L15>
 10867a8: 91000a10     	add	x16, x16, #0x2
 10867ac: eb0a021f     	cmp	x16, x10
 10867b0: 54ffff43     	b.lo	 <L21>
 10867b4: 17fffff1     	b	 <L19>
<L22>:
 10867b8: 3940a34a     	ldrb	w10, [x26, #0x28]
 10867bc: f94243e9     	ldr	x9, [sp, #0x480]
 10867c0: aa1603ee     	mov	x14, x22
 10867c4: f9405be8     	ldr	x8, [sp, #0xb0]
 10867c8: 3600074a     	tbz	w10, #0x0,  <L28>
 10867cc: 5289366a     	mov	w10, #0x49b3            // =18867
 10867d0: 8b0a026a     	add	x10, x19, x10
 10867d4: ad428540     	ldp	q0, q1, [x10, #0x50]
 10867d8: 3d825b60     	str	q0, [x27, #0x960]
 10867dc: 3dc01d40     	ldr	q0, [x10, #0x70]
 10867e0: 3d825f61     	str	q1, [x27, #0x970]
 10867e4: 3cc79141     	ldur	q1, [x10, #0x79]
 10867e8: 3d826360     	str	q0, [x27, #0x980]
 10867ec: ad408d40     	ldp	q0, q3, [x10, #0x10]
 10867f0: 3c879321     	stur	q1, [x25, #0x79]
 10867f4: ad418941     	ldp	q1, q2, [x10, #0x30]
 10867f8: 3942232b     	ldrb	w11, [x25, #0x88]
 10867fc: ad010723     	stp	q3, q1, [x25, #0x20]
 1086800: 3dc00141     	ldr	q1, [x10]
 1086804: f94247ea     	ldr	x10, [sp, #0x488]
 1086808: 92400d76     	and	x22, x11, #0xf
 108680c: 3d801322     	str	q2, [x25, #0x40]
 1086810: ad000321     	stp	q1, q0, [x25]
 1086814: b4001689     	cbz	x9,  <L36>
 1086818: f100095f     	cmp	x10, #0x2
 108681c: 54001982     	b.hs	 <L40>
<L23>:
 1086820: 528001e9     	mov	w9, #0xf                // =15
 1086824: 79002109     	strh	w9, [x8, #0x10]
 1086828: 17ffff4b     	b	 <L6>
<L24>:
 108682c: f100091f     	cmp	x8, #0x2
 1086830: aa0903ea     	mov	x10, x9
 1086834: aa0803eb     	mov	x11, x8
 1086838: 54ffe5e0     	b.eq	 <L1>
 108683c: 7940092a     	ldrh	w10, [x9, #0x4]
 1086840: 12823d4b     	mov	w11, #-0x11eb           // =-4587
 1086844: 0b0b014b     	add	w11, w10, w11
 1086848: 7100097f     	cmp	w11, #0x2
 108684c: 54ffe808     	b.hi	 <L4>
 1086850: 7940012b     	ldrh	w11, [x9]
 1086854: 6b0a017f     	cmp	w11, w10
 1086858: 54ffe7a0     	b.eq	 <L4>
 108685c: 7940052b     	ldrh	w11, [x9, #0x2]
 1086860: 6b0a017f     	cmp	w11, w10
 1086864: aa0903ea     	mov	x10, x9
 1086868: aa0803eb     	mov	x11, x8
 108686c: 54ffe441     	b.ne	 <L1>
 1086870: 17ffff37     	b	 <L4>
<L25>:
 1086874: f9417be8     	ldr	x8, [sp, #0x2f0]
 1086878: 39001b5f     	strb	wzr, [x26, #0x6]
 108687c: b4002948     	cbz	x8,  <L54>
 1086880: f0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 1086884: 910ca108     	add	x8, x8, #0x328
 1086888: 3dc00100     	ldr	q0, [x8]
 108688c: 528008c8     	mov	w8, #0x46               // =70
 1086890: 17ffff75     	b	 <L12>
<L26>:
 1086894: f0fffc09     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1086898: 910be129     	add	x9, x9, #0x2f8
 108689c: 3dc00120     	ldr	q0, [x9]
 10868a0: 52800ac9     	mov	w9, #0x56               // =86
<L27>:
 10868a4: 3d800100     	str	q0, [x8]
 10868a8: f9000909     	str	x9, [x8, #0x10]
 10868ac: 17ffff2a     	b	 <L6>
<L28>:
 10868b0: f90033fa     	str	x26, [sp, #0x60]
 10868b4: b4001329     	cbz	x9,  <L39>
<L29>:
 10868b8: 52800949     	mov	w9, #0x4a               // =74
<L30>:
 10868bc: 79002109     	strh	w9, [x8, #0x10]
 10868c0: 17ffff25     	b	 <L6>
<L31>:
 10868c4: aa1f03ea     	mov	x10, xzr
<L32>:
 10868c8: 9100414b     	add	x11, x10, #0x10
 10868cc: eb09017f     	cmp	x11, x9
 10868d0: 54000102     	b.hs	 <L33>
 10868d4: 4f00e420     	movi	v0.16b, #0x1
 10868d8: 3cea6901     	ldr	q1, [x8, x10]
 10868dc: 6e208c20     	cmeq	v0.16b, v1.16b, v0.16b
 10868e0: 6e30a800     	umaxv	b0, v0.16b
 10868e4: 1e26000a     	fmov	w10, s0
 10868e8: 3700016a     	tbnz	w10, #0x0,  <L34>
 10868ec: aa0b03ea     	mov	x10, x11
<L33>:
 10868f0: 9100214b     	add	x11, x10, #0x8
 10868f4: eb09017f     	cmp	x11, x9
 10868f8: 54002442     	b.hs	 <L51>
 10868fc: 0f00e420     	movi	v0.8b, #0x1
 1086900: fc6a6901     	ldr	d1, [x8, x10]
 1086904: 2e208c20     	cmeq	v0.8b, v1.8b, v0.8b
 1086908: 2e30a800     	umaxv	b0, v0.8b
 108690c: 1e26000a     	fmov	w10, s0
 1086910: 3600236a     	tbz	w10, #0x0,  <L50>
<L34>:
 1086914: f9417be8     	ldr	x8, [sp, #0x2f0]
 1086918: 52800029     	mov	w9, #0x1                // =1
 108691c: 39001b49     	strb	w9, [x26, #0x6]
 1086920: b4002428     	cbz	x8,  <L54>
 1086924: 3943a748     	ldrb	w8, [x26, #0xe9]
 1086928: 7200051f     	tst	w8, #0x3
 108692c: 540023c1     	b.ne	 <L54>
 1086930: 394e2268     	ldrb	w8, [x19, #0x388]
 1086934: 34002388     	cbz	w8,  <L54>
 1086938: 910de268     	add	x8, x19, #0x378
 108693c: 7100033f     	cmp	w25, #0x0
 1086940: 911683e0     	add	x0, sp, #0x5a0
 1086944: 3dc00100     	ldr	q0, [x8]
 1086948: 9a9303e5     	csel	x5, xzr, x19, eq
 108694c: 910943e1     	add	x1, sp, #0x250
 1086950: 911643e3     	add	x3, sp, #0x590
 1086954: aa1503e2     	mov	x2, x21
 1086958: 2a1403e4     	mov	w4, w20
 108695c: 3d806f00     	str	q0, [x24, #0x1b0]
 1086960: 911683f9     	add	x25, sp, #0x5a0
 1086964: 97fffcb8     	bl	 <ServerHandshake.selectPskWithTranscript>
 1086968: 794ba3e8     	ldrh	w8, [sp, #0x5d0]
 108696c: 35010848     	cbnz	w8,  <L174>
 1086970: 395723e8     	ldrb	w8, [sp, #0x5c8]
 1086974: 34002188     	cbz	w8,  <L54>
 1086978: 7841532a     	ldurh	w10, [x25, #0x15]
 108697c: 9115566b     	add	x11, x19, #0x555
 1086980: 3841732c     	ldurb	w12, [x25, #0x17]
 1086984: f942d3e1     	ldr	x1, [sp, #0x5a0]
 1086988: f942d7e2     	ldr	x2, [sp, #0x5a8]
 108698c: b945b3e8     	ldr	w8, [sp, #0x5b0]
 1086990: 7900016a     	strh	w10, [x11]
 1086994: 794b7fea     	ldrh	w10, [sp, #0x5be]
 1086998: b841a2eb     	ldur	w11, [x23, #0x1a]
 108699c: 39155e6c     	strb	w12, [x19, #0x557]
 10869a0: 91156a6c     	add	x12, x19, #0x55a
 10869a4: 3956d3e9     	ldrb	w9, [sp, #0x5b4]
 10869a8: 790abe6a     	strh	w10, [x19, #0x55e]
 10869ac: f9404bea     	ldr	x10, [sp, #0x90]
 10869b0: 794b73f7     	ldrh	w23, [sp, #0x5b8]
 10869b4: b900018b     	str	w11, [x12]
 10869b8: 5280002b     	mov	w11, #0x1               // =1
 10869bc: f942e3ec     	ldr	x12, [sp, #0x5c0]
 10869c0: 3940014a     	ldrb	w10, [x10]
 10869c4: f902a261     	str	x1, [x19, #0x540]
 10869c8: f902a662     	str	x2, [x19, #0x548]
 10869cc: 7100055f     	cmp	w10, #0x1
 10869d0: b9055268     	str	w8, [x19, #0x550]
 10869d4: 39155269     	strb	w9, [x19, #0x554]
 10869d8: 790ab277     	strh	w23, [x19, #0x558]
 10869dc: 3915826b     	strb	w11, [x19, #0x560]
 10869e0: 7913066c     	strh	w12, [x19, #0x982]
 10869e4: 54001e01     	b.ne	 <L54>
 10869e8: 34001de9     	cbz	w9,  <L54>
 10869ec: b9056e68     	str	w8, [x19, #0x56c]
 10869f0: 78415328     	ldurh	w8, [x25, #0x15]
 10869f4: 3841732a     	ldurb	w10, [x25, #0x17]
 10869f8: 5282604b     	mov	w11, #0x1302            // =4866
 10869fc: 3915c269     	strb	w9, [x19, #0x570]
 1086a00: 9115c669     	add	x9, x19, #0x571
 1086a04: 6b0b02ff     	cmp	w23, w11
 1086a08: 79000128     	strh	w8, [x9]
 1086a0c: 3915ce6a     	strb	w10, [x19, #0x573]
 1086a10: 54005721     	b.ne	 <L104>
 1086a14: d0fffc03     	adrp	x3, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 1086a18: 910af063     	add	x3, x3, #0x2bc
 1086a1c: 911763e0     	add	x0, sp, #0x5d8
 1086a20: 94006812     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 1086a24: 91400be8     	add	x8, sp, #0x2, lsl #12   // =0x2000
 1086a28: f94057e1     	ldr	x1, [sp, #0xa8]
 1086a2c: aa1503e0     	mov	x0, x21
 1086a30: 91044108     	add	x8, x8, #0x110
 1086a34: 91005502     	add	x2, x8, #0x15
 1086a38: 97ffdf50     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).hash>
 1086a3c: 91400bea     	add	x10, sp, #0x2, lsl #12  // =0x2000
 1086a40: 52800229     	mov	w9, #0x11               // =17
 1086a44: 52860008     	mov	w8, #0x3000             // =12288
 1086a48: 9104414a     	add	x10, x10, #0x110
 1086a4c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1086a50: 911823e0     	add	x0, sp, #0x608
 1086a54: 39000949     	strb	w9, [x10, #0x2]
 1086a58: d0fffc09     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 1086a5c: 913cd929     	add	x9, x9, #0xf36
 1086a60: 3dc00120     	ldr	q0, [x9]
 1086a64: 79000148     	strh	w8, [x10]
 1086a68: 52860c68     	mov	w8, #0x3063             // =12387
 1086a6c: 91044042     	add	x2, x2, #0x110
 1086a70: 911763e4     	add	x4, sp, #0x5d8
 1086a74: 52800601     	mov	w1, #0x30               // =48
 1086a78: 528008a3     	mov	w3, #0x45               // =69
 1086a7c: 78013148     	sturh	w8, [x10, #0x13]
 1086a80: 3c803140     	stur	q0, [x10, #0x3]
 1086a84: 940068a7     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1086a88: 9118e3e0     	add	x0, sp, #0x638
 1086a8c: 911823e2     	add	x2, sp, #0x608
 1086a90: 52826041     	mov	w1, #0x1302             // =4866
 1086a94: 97ffdfb5     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 1086a98: 794d23e8     	ldrh	w8, [sp, #0x690]
 1086a9c: 3500fec8     	cbnz	w8,  <L174>
 1086aa0: 911567e8     	add	x8, sp, #0x559
 1086aa4: 9114e7e9     	add	x9, sp, #0x539
 1086aa8: 3ccff100     	ldur	q0, [x8, #0xff]
 1086aac: 9115a7e8     	add	x8, sp, #0x569
 1086ab0: 3ccff101     	ldur	q1, [x8, #0xff]
 1086ab4: 9115e7e8     	add	x8, sp, #0x579
 1086ab8: 3ccff102     	ldur	q2, [x8, #0xff]
 1086abc: f94347e8     	ldr	x8, [sp, #0x688]
 1086ac0: 3d814260     	str	q0, [x19, #0x500]
 1086ac4: 3ccff120     	ldur	q0, [x9, #0xff]
 1086ac8: 3d814661     	str	q1, [x19, #0x510]
 1086acc: f9029a68     	str	x8, [x19, #0x530]
 1086ad0: 911527e8     	add	x8, sp, #0x549
 1086ad4: 3d814a62     	str	q2, [x19, #0x520]
 1086ad8: 140002b8     	b	 <L105>
<L35>:
 1086adc: 52800968     	mov	w8, #0x4b               // =75
 1086ae0: 17fffe9c     	b	 <L5>
<L36>:
 1086ae4: f90033fa     	str	x26, [sp, #0x60]
 1086ae8: aa1f03fa     	mov	x26, xzr
<L37>:
 1086aec: eb1a02c9     	subs	x9, x22, x26
 1086af0: 54000149     	b.ls	 <L39>
 1086af4: 8b1a134a     	add	x10, x26, x26, lsl #4
 1086af8: 91400beb     	add	x11, sp, #0x2, lsl #12  // =0x2000
 1086afc: 9104416b     	add	x11, x11, #0x110
 1086b00: 8b0b014a     	add	x10, x10, x11
 1086b04: 9100414a     	add	x10, x10, #0x10
<L38>:
 1086b08: 3841154b     	ldrb	w11, [x10], #0x11
 1086b0c: 3607ed6b     	tbz	w11, #0x0,  <L29>
 1086b10: f1000529     	subs	x9, x9, #0x1
 1086b14: 54ffffa1     	b.ne	 <L38>
<L39>:
 1086b18: 3966c789     	ldrb	w9, [x28, #0x9b1]
 1086b1c: 910943ea     	add	x10, sp, #0x250
 1086b20: f90037ee     	str	x14, [sp, #0x68]
 1086b24: 91063d52     	add	x18, x10, #0x18f
 1086b28: 34001269     	cbz	w9,  <L49>
 1086b2c: 394f7fe9     	ldrb	w9, [sp, #0x3df]
 1086b30: f94033fa     	ldr	x26, [sp, #0x60]
 1086b34: 3607da49     	tbz	w9, #0x0,  <L14>
 1086b38: f0fffc09     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1086b3c: 910b8129     	add	x9, x9, #0x2e0
 1086b40: 3dc00120     	ldr	q0, [x9]
 1086b44: 52800949     	mov	w9, #0x4a               // =74
 1086b48: 17ffff57     	b	 <L27>
<L40>:
 1086b4c: 7940012b     	ldrh	w11, [x9]
 1086b50: 5ac0056f     	rev16	w15, w11
 1086b54: 910011eb     	add	x11, x15, #0x4
 1086b58: eb0a017f     	cmp	x11, x10
 1086b5c: 54001068     	b.hi	 <L48>
 1086b60: 910009eb     	add	x11, x15, #0x2
 1086b64: 786b692c     	ldrh	w12, [x9, x11]
 1086b68: cb0b014d     	sub	x13, x10, x11
 1086b6c: 5ac0058c     	rev16	w12, w12
 1086b70: 9100098c     	add	x12, x12, #0x2
 1086b74: eb0d019f     	cmp	x12, x13
 1086b78: 54000f81     	b.ne	 <L48>
 1086b7c: 9100096b     	add	x11, x11, #0x2
 1086b80: f90033fa     	str	x26, [sp, #0x60]
 1086b84: cb0b014d     	sub	x13, x10, x11
 1086b88: 340052af     	cbz	w15,  <L107>
 1086b8c: 91000930     	add	x16, x9, #0x2
 1086b90: 8b0b0129     	add	x9, x9, x11
 1086b94: aa1f03fa     	mov	x26, xzr
 1086b98: a90427ed     	stp	x13, x9, [sp, #0x40]
 1086b9c: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1086ba0: aa1f03ec     	mov	x12, xzr
 1086ba4: 912c0129     	add	x9, x9, #0xb00
 1086ba8: aa1f03ea     	mov	x10, xzr
 1086bac: d10006d1     	sub	x17, x22, #0x1
 1086bb0: 9100a129     	add	x9, x9, #0x28
 1086bb4: f90037ee     	str	x14, [sp, #0x68]
 1086bb8: a902a7ef     	stp	x15, x9, [sp, #0x28]
 1086bbc: 91400be9     	add	x9, sp, #0x2, lsl #12   // =0x2000
 1086bc0: 91044129     	add	x9, x9, #0x110
 1086bc4: f9001ff0     	str	x16, [sp, #0x38]
 1086bc8: 91004129     	add	x9, x9, #0x10
 1086bcc: a901c7e9     	stp	x9, x17, [sp, #0x18]
<L41>:
 1086bd0: 91000989     	add	x9, x12, #0x2
 1086bd4: eb0901eb     	subs	x11, x15, x9
 1086bd8: 54ffe243     	b.lo	 <L23>
 1086bdc: f9003bec     	str	x12, [sp, #0x70]
 1086be0: 786c6a0c     	ldrh	w12, [x16, x12]
 1086be4: 5ac00599     	rev16	w25, w12
 1086be8: 9100132c     	add	x12, x25, #0x4
 1086bec: eb0c017f     	cmp	x11, x12
 1086bf0: 54004fe3     	b.lo	 <L109>
 1086bf4: eb0d015f     	cmp	x10, x13
 1086bf8: 54ffe142     	b.hs	 <L23>
 1086bfc: f94027eb     	ldr	x11, [sp, #0x48]
 1086c00: 9100054c     	add	x12, x10, #0x1
 1086c04: 386a696b     	ldrb	w11, [x11, x10]
 1086c08: cb0c01aa     	sub	x10, x13, x12
 1086c0c: eb0b015f     	cmp	x10, x11
 1086c10: 54004ee3     	b.lo	 <L109>
 1086c14: d0fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 1086c18: 913e4108     	add	x8, x8, #0xf90
 1086c1c: f101033f     	cmp	x25, #0x40
 1086c20: ad420500     	ldp	q0, q1, [x8, #0x40]
 1086c24: 3dc01902     	ldr	q2, [x8, #0x60]
 1086c28: 8b090217     	add	x23, x16, x9
 1086c2c: a9052fec     	stp	x12, x11, [sp, #0x50]
 1086c30: 3d80db62     	str	q2, [x27, #0x360]
 1086c34: ad1a0760     	stp	q0, q1, [x27, #0x340]
 1086c38: ad400500     	ldp	q0, q1, [x8]
 1086c3c: ad180760     	stp	q0, q1, [x27, #0x300]
 1086c40: ad410900     	ldp	q0, q2, [x8, #0x20]
 1086c44: ad190b60     	stp	q0, q2, [x27, #0x320]
 1086c48: 540000a2     	b.hs	 <L42>
 1086c4c: f9004bff     	str	xzr, [sp, #0x90]
 1086c50: aa1f03e9     	mov	x9, xzr
 1086c54: aa1f03e8     	mov	x8, xzr
 1086c58: 1400000e     	b	 <L44>
<L42>:
 1086c5c: aa1f03e8     	mov	x8, xzr
<L43>:
 1086c60: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1086c64: 8b0802e1     	add	x1, x23, x8
 1086c68: aa0803f4     	mov	x20, x8
 1086c6c: 912c0000     	add	x0, x0, #0xb00
 1086c70: 94006ccf     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1086c74: 91020288     	add	x8, x20, #0x80
 1086c78: eb19011f     	cmp	x8, x25
 1086c7c: 91010288     	add	x8, x20, #0x40
 1086c80: 54ffff09     	b.ls	 <L43>
 1086c84: 394da369     	ldrb	w9, [x27, #0x368]
 1086c88: f94d93ea     	ldr	x10, [sp, #0x1b20]
 1086c8c: f9004bea     	str	x10, [sp, #0x90]
<L44>:
 1086c90: f9401bea     	ldr	x10, [sp, #0x30]
 1086c94: cb080334     	sub	x20, x25, x8
 1086c98: 8b0802e1     	add	x1, x23, x8
 1086c9c: aa1403e2     	mov	x2, x20
 1086ca0: 8b090140     	add	x0, x10, x9
 1086ca4: 94055889     	bl	 <memcpy>
 1086ca8: 394da368     	ldrb	w8, [x27, #0x368]
 1086cac: f9404be9     	ldr	x9, [sp, #0x90]
 1086cb0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1086cb4: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1086cb8: 912c0000     	add	x0, x0, #0xb00
 1086cbc: 0b140108     	add	w8, w8, w20
 1086cc0: 8b190129     	add	x9, x9, x25
 1086cc4: 91238021     	add	x1, x1, #0x8e0
 1086cc8: 390da368     	strb	w8, [x27, #0x368]
 1086ccc: f90d93e9     	str	x9, [sp, #0x1b20]
 1086cd0: 94006c6b     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 1086cd4: eb16035f     	cmp	x26, x22
 1086cd8: 540002a2     	b.hs	 <L46>
 1086cdc: a941c7e9     	ldp	x9, x17, [sp, #0x18]
 1086ce0: 8b1a1348     	add	x8, x26, x26, lsl #4
 1086ce4: a943b7f0     	ldp	x16, x13, [sp, #0x38]
 1086ce8: 3dc03b60     	ldr	q0, [x27, #0xe0]
 1086cec: f94037ee     	ldr	x14, [sp, #0x68]
 1086cf0: 8b08012a     	add	x10, x9, x8
 1086cf4: f9405be8     	ldr	x8, [sp, #0xb0]
<L45>:
 1086cf8: 3cdf0141     	ldur	q1, [x10, #-0x10]
 1086cfc: 6ea18c01     	cmeq	v1.4s, v0.4s, v1.4s
 1086d00: 6e205821     	mvn	v1.16b, v1.16b
 1086d04: 6eb0a821     	umaxv	s1, v1.4s
 1086d08: 1e260029     	fmov	w9, s1
 1086d0c: 36000149     	tbz	w9, #0x0,  <L47>
 1086d10: 3841154b     	ldrb	w11, [x10], #0x11
 1086d14: 52800949     	mov	w9, #0x4a               // =74
 1086d18: 3607dd2b     	tbz	w11, #0x0,  <L30>
 1086d1c: eb1a023f     	cmp	x17, x26
 1086d20: 9100075a     	add	x26, x26, #0x1
 1086d24: 54fffea1     	b.ne	 <L45>
 1086d28: 17fffee5     	b	 <L30>
<L46>:
 1086d2c: a943b7f0     	ldp	x16, x13, [sp, #0x38]
 1086d30: f94037ee     	ldr	x14, [sp, #0x68]
<L47>:
 1086d34: eb16035f     	cmp	x26, x22
 1086d38: 5400e180     	b.eq	 <L163>
 1086d3c: f9403be8     	ldr	x8, [sp, #0x70]
 1086d40: f94017ef     	ldr	x15, [sp, #0x28]
 1086d44: 9100075a     	add	x26, x26, #0x1
 1086d48: 8b190108     	add	x8, x8, x25
 1086d4c: 9100190c     	add	x12, x8, #0x6
 1086d50: a94523e9     	ldp	x9, x8, [sp, #0x50]
 1086d54: eb0f019f     	cmp	x12, x15
 1086d58: 8b08012a     	add	x10, x9, x8
 1086d5c: f9405be8     	ldr	x8, [sp, #0xb0]
 1086d60: 54fff383     	b.lo	 <L41>
 1086d64: 14000220     	b	 <L108>
<L48>:
 1086d68: 52800369     	mov	w9, #0x1b               // =27
 1086d6c: 79002109     	strh	w9, [x8, #0x10]
 1086d70: 17fffdf9     	b	 <L6>
<L49>:
 1086d74: f94033fa     	ldr	x26, [sp, #0x60]
 1086d78: 17fffe41     	b	 <L14>
<L50>:
 1086d7c: aa0b03ea     	mov	x10, x11
<L51>:
 1086d80: eb0a0129     	subs	x9, x9, x10
 1086d84: 540000e0     	b.eq	 <L53>
 1086d88: 8b0a0108     	add	x8, x8, x10
<L52>:
 1086d8c: 3840150a     	ldrb	w10, [x8], #0x1
 1086d90: 7100055f     	cmp	w10, #0x1
 1086d94: 54ffdc00     	b.eq	 <L34>
 1086d98: f1000529     	subs	x9, x9, #0x1
 1086d9c: 54ffff81     	b.ne	 <L52>
<L53>:
 1086da0: 39001b5f     	strb	wzr, [x26, #0x6]
<L54>:
 1086da4: 911cf3e0     	add	x0, sp, #0x73c
 1086da8: 2a1f03e1     	mov	w1, wzr
 1086dac: 5280d082     	mov	w2, #0x684              // =1668
 1086db0: 913883f6     	add	x22, sp, #0xe20
 1086db4: 910943f7     	add	x23, sp, #0x250
 1086db8: 94055882     	bl	 <memset>
 1086dbc: 6f00e400     	movi	v0.2d, #0000000000000000
 1086dc0: 39660268     	ldrb	w8, [x19, #0x980]
 1086dc4: 911683e9     	add	x9, sp, #0x5a0
 1086dc8: 393843ff     	strb	wzr, [sp, #0xe10]
 1086dcc: 3d820920     	str	q0, [x9, #0x820]
 1086dd0: 3d820d20     	str	q0, [x9, #0x830]
 1086dd4: 3d821120     	str	q0, [x9, #0x840]
 1086dd8: 3d821520     	str	q0, [x9, #0x850]
 1086ddc: 3d821920     	str	q0, [x9, #0x860]
 1086de0: 34000388     	cbz	w8,  <L55>
 1086de4: 7952fe79     	ldrh	w25, [x19, #0x97e]
 1086de8: 52823d48     	mov	w8, #0x11ea             // =4586
 1086dec: f94047e9     	ldr	x9, [sp, #0x88]
 1086df0: 6b08033f     	cmp	w25, w8
 1086df4: f94053e8     	ldr	x8, [sp, #0xa0]
 1086df8: 54000fcc     	b.gt	 <L69>
 1086dfc: f9405bea     	ldr	x10, [sp, #0xb0]
 1086e00: 71005f3f     	cmp	w25, #0x17
 1086e04: 54001ca0     	b.eq	 <L86>
 1086e08: 7100633f     	cmp	w25, #0x18
 1086e0c: 54001e60     	b.eq	 <L87>
 1086e10: 7100773f     	cmp	w25, #0x1d
 1086e14: 54002941     	b.ne	 <L93>
 1086e18: 394ce7eb     	ldrb	w11, [sp, #0x339]
 1086e1c: 3400290b     	cbz	w11,  <L93>
 1086e20: 394defeb     	ldrb	w11, [sp, #0x37b]
 1086e24: 350028cb     	cbnz	w11,  <L93>
 1086e28: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 1086e2c: 3500288b     	cbnz	w11,  <L93>
 1086e30: 394ba3eb     	ldrb	w11, [sp, #0x2e8]
 1086e34: 7200057f     	tst	w11, #0x3
 1086e38: 54002821     	b.ne	 <L93>
 1086e3c: 910943ea     	add	x10, sp, #0x250
 1086e40: 784d92f9     	ldurh	w25, [x23, #0xd9]
 1086e44: 393873ff     	strb	wzr, [sp, #0xe1c]
 1086e48: 3ccc9140     	ldur	q0, [x10, #0xc9]
 1086e4c: 140000cd     	b	 <L85>
<L55>:
 1086e50: a94aabe3     	ldp	x3, x10, [sp, #0xa8]
 1086e54: aa1a03f7     	mov	x23, x26
 1086e58: f941d666     	ldr	x6, [x19, #0x3a8]
 1086e5c: f94053e8     	ldr	x8, [sp, #0xa0]
 1086e60: aa1503e2     	mov	x2, x21
 1086e64: f94047e9     	ldr	x9, [sp, #0x88]
 1086e68: b40017c6     	cbz	x6,  <L84>
 1086e6c: 3951e3eb     	ldrb	w11, [sp, #0x478]
 1086e70: f941d26c     	ldr	x12, [x19, #0x3a0]
 1086e74: 91400bf9     	add	x25, sp, #0x2, lsl #12  // =0x2000
 1086e78: 91044339     	add	x25, x25, #0x110
 1086e7c: 1200056d     	and	w13, w11, #0x3
 1086e80: 34000ded     	cbz	w13,  <L72>
 1086e84: 910f83eb     	add	x11, sp, #0x3e0
 1086e88: 794883ef     	ldrh	w15, [sp, #0x440]
 1086e8c: 7948b3f0     	ldrh	w16, [sp, #0x458]
 1086e90: 7948e3f1     	ldrh	w17, [sp, #0x470]
 1086e94: aa1703fa     	mov	x26, x23
 1086e98: aa1f03ee     	mov	x14, xzr
 1086e9c: 91014178     	add	x24, x11, #0x50
 1086ea0: 12823d52     	mov	w18, #-0x11eb           // =-4587
 1086ea4: 52823da0     	mov	w0, #0x11ed             // =4589
 1086ea8: 14000004     	b	 <L57>
<L56>:
 1086eac: 910005ce     	add	x14, x14, #0x1
 1086eb0: eb0601df     	cmp	x14, x6
 1086eb4: 54000c40     	b.eq	 <L72>
<L57>:
 1086eb8: 786e7981     	ldrh	w1, [x12, x14, lsl #1]
 1086ebc: 12003c2b     	and	w11, w1, #0xffff
 1086ec0: 0b120164     	add	w4, w11, w18
 1086ec4: 7100089f     	cmp	w4, #0x2
 1086ec8: 54000422     	b.hs	 <L63>
 1086ecc: 6b2121ff     	cmp	w15, w1, uxth
 1086ed0: 54000101     	b.ne	 <L59>
 1086ed4: aa0c03e4     	mov	x4, x12
 1086ed8: aa0603eb     	mov	x11, x6
<L58>:
 1086edc: 78402485     	ldrh	w5, [x4], #0x2
 1086ee0: 6b2120bf     	cmp	w5, w1, uxth
 1086ee4: 54003900     	b.eq	 <L112>
 1086ee8: f100056b     	subs	x11, x11, #0x1
 1086eec: 54ffff81     	b.ne	 <L58>
<L59>:
 1086ef0: 710005bf     	cmp	w13, #0x1
 1086ef4: 54fffdc0     	b.eq	 <L56>
 1086ef8: 6b21221f     	cmp	w16, w1, uxth
 1086efc: 54000101     	b.ne	 <L61>
 1086f00: aa0c03e4     	mov	x4, x12
 1086f04: aa0603e5     	mov	x5, x6
<L60>:
 1086f08: 7840248b     	ldrh	w11, [x4], #0x2
 1086f0c: 6b21217f     	cmp	w11, w1, uxth
 1086f10: 54002500     	b.eq	 <L97>
 1086f14: f10004a5     	subs	x5, x5, #0x1
 1086f18: 54ffff81     	b.ne	 <L60>
<L61>:
 1086f1c: 710009bf     	cmp	w13, #0x2
 1086f20: 54fffc60     	b.eq	 <L56>
 1086f24: 6b21223f     	cmp	w17, w1, uxth
 1086f28: 54fffc21     	b.ne	 <L56>
 1086f2c: aa0c03e4     	mov	x4, x12
 1086f30: aa0603e5     	mov	x5, x6
<L62>:
 1086f34: 7840248b     	ldrh	w11, [x4], #0x2
 1086f38: 6b21217f     	cmp	w11, w1, uxth
 1086f3c: 540026c0     	b.eq	 <L100>
 1086f40: f10004a5     	subs	x5, x5, #0x1
 1086f44: 54ffff81     	b.ne	 <L62>
 1086f48: 17ffffd9     	b	 <L56>
<L63>:
 1086f4c: 6b00017f     	cmp	w11, w0
 1086f50: 54fffae1     	b.ne	 <L56>
 1086f54: 6b0001ff     	cmp	w15, w0
 1086f58: 54000161     	b.ne	 <L65>
 1086f5c: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1086f60: 3400012b     	cbz	w11,  <L65>
 1086f64: aa0c03e4     	mov	x4, x12
 1086f68: aa0603e5     	mov	x5, x6
<L64>:
 1086f6c: 7840248b     	ldrh	w11, [x4], #0x2
 1086f70: 52823da1     	mov	w1, #0x11ed             // =4589
 1086f74: 6b01017f     	cmp	w11, w1
 1086f78: 54003460     	b.eq	 <L112>
 1086f7c: f10004a5     	subs	x5, x5, #0x1
 1086f80: 54ffff61     	b.ne	 <L64>
<L65>:
 1086f84: 710005bf     	cmp	w13, #0x1
 1086f88: 54fff920     	b.eq	 <L56>
 1086f8c: 6b00021f     	cmp	w16, w0
 1086f90: 54000141     	b.ne	 <L67>
 1086f94: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1086f98: 3400010b     	cbz	w11,  <L67>
 1086f9c: aa0c03e1     	mov	x1, x12
 1086fa0: aa0603e4     	mov	x4, x6
<L66>:
 1086fa4: 7840242b     	ldrh	w11, [x1], #0x2
 1086fa8: 6b00017f     	cmp	w11, w0
 1086fac: 54003120     	b.eq	 <L106>
 1086fb0: f1000484     	subs	x4, x4, #0x1
 1086fb4: 54ffff81     	b.ne	 <L66>
<L67>:
 1086fb8: 710009bf     	cmp	w13, #0x2
 1086fbc: 54fff780     	b.eq	 <L56>
 1086fc0: 6b00023f     	cmp	w17, w0
 1086fc4: 54fff741     	b.ne	 <L56>
 1086fc8: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1086fcc: 34fff70b     	cbz	w11,  <L56>
 1086fd0: aa0c03e1     	mov	x1, x12
 1086fd4: aa0603e4     	mov	x4, x6
<L68>:
 1086fd8: 7840242b     	ldrh	w11, [x1], #0x2
 1086fdc: 6b00017f     	cmp	w11, w0
 1086fe0: 540030c0     	b.eq	 <L110>
 1086fe4: f1000484     	subs	x4, x4, #0x1
 1086fe8: 54ffff81     	b.ne	 <L68>
 1086fec: 17ffffb0     	b	 <L56>
<L69>:
 1086ff0: 12823d48     	mov	w8, #-0x11eb            // =-4587
 1086ff4: f9405bea     	ldr	x10, [sp, #0xb0]
 1086ff8: 0b080328     	add	w8, w25, w8
 1086ffc: 7100091f     	cmp	w8, #0x2
 1087000: 540000c3     	b.lo	 <L70>
 1087004: 52823da8     	mov	w8, #0x11ed             // =4589
 1087008: 6b08033f     	cmp	w25, w8
 108700c: 54001981     	b.ne	 <L93>
 1087010: 3948f748     	ldrb	w8, [x26, #0x23d]
 1087014: 34001928     	cbz	w8,  <L92>
<L70>:
 1087018: f941d668     	ldr	x8, [x19, #0x3a8]
 108701c: b40018e8     	cbz	x8,  <L92>
 1087020: f941d269     	ldr	x9, [x19, #0x3a0]
<L71>:
 1087024: 7840252b     	ldrh	w11, [x9], #0x2
 1087028: 6b19017f     	cmp	w11, w25
 108702c: 540014a0     	b.eq	 <L91>
 1087030: f1000508     	subs	x8, x8, #0x1
 1087034: 54ffff81     	b.ne	 <L71>
 1087038: 140000c0     	b	 <L92>
<L72>:
 108703c: 394c63eb     	ldrb	w11, [sp, #0x318]
 1087040: aa1f03ed     	mov	x13, xzr
 1087044: d0fffc0e     	adrp	x14, 0x1009000 <__anon_51029+0x9c0>
 1087048: 913aa1ce     	add	x14, x14, #0xea8
 108704c: 52823d4f     	mov	w15, #0x11ea            // =4586
 1087050: 12823d41     	mov	w1, #-0x11eb            // =-4587
 1087054: 12001560     	and	w0, w11, #0x3f
 1087058: d0fffc04     	adrp	x4, 0x1009000 <__anon_51029+0x9c0>
 108705c: 913af884     	add	x4, x4, #0xebe
 1087060: 52823da5     	mov	w5, #0x11ed             // =4589
 1087064: d0fffc10     	adrp	x16, 0x1009000 <__anon_51029+0x9c0>
 1087068: 913ad210     	add	x16, x16, #0xeb4
 108706c: 52823d67     	mov	w7, #0x11eb             // =4587
 1087070: d0fffc18     	adrp	x24, 0x1009000 <__anon_51029+0x9c0>
 1087074: 913ae318     	add	x24, x24, #0xeb8
 1087078: 52823d99     	mov	w25, #0x11ec            // =4588
 108707c: d0fffc1a     	adrp	x26, 0x1009000 <__anon_51029+0x9c0>
 1087080: 913af35a     	add	x26, x26, #0xebc
 1087084: 14000004     	b	 <L74>
<L73>:
 1087088: 910005ad     	add	x13, x13, #0x1
 108708c: eb0601bf     	cmp	x13, x6
 1087090: 54000680     	b.eq	 <L84>
<L74>:
 1087094: 786d7992     	ldrh	w18, [x12, x13, lsl #1]
 1087098: 6b0f025f     	cmp	w18, w15
 108709c: 5400012c     	b.gt	 <L75>
 10870a0: 71005e5f     	cmp	w18, #0x17
 10870a4: 540001e0     	b.eq	 <L76>
 10870a8: 7100625f     	cmp	w18, #0x18
 10870ac: 54000280     	b.eq	 <L79>
 10870b0: 7100765f     	cmp	w18, #0x1d
 10870b4: aa0e03eb     	mov	x11, x14
 10870b8: 540002a0     	b.eq	 <L81>
 10870bc: 1400000e     	b	 <L78>
<L75>:
 10870c0: 6b07025f     	cmp	w18, w7
 10870c4: 54000140     	b.eq	 <L77>
 10870c8: 6b19025f     	cmp	w18, w25
 10870cc: 540001e0     	b.eq	 <L80>
 10870d0: 6b05025f     	cmp	w18, w5
 10870d4: 54000101     	b.ne	 <L78>
 10870d8: aa1a03eb     	mov	x11, x26
 10870dc: 1400000c     	b	 <L81>
<L76>:
 10870e0: d0fffc0b     	adrp	x11, 0x1009000 <__anon_51029+0x9c0>
 10870e4: 913ab16b     	add	x11, x11, #0xeac
 10870e8: 14000009     	b	 <L81>
<L77>:
 10870ec: aa1003eb     	mov	x11, x16
 10870f0: 14000007     	b	 <L81>
<L78>:
 10870f4: aa0403eb     	mov	x11, x4
 10870f8: 14000005     	b	 <L81>
<L79>:
 10870fc: d0fffc0b     	adrp	x11, 0x1009000 <__anon_51029+0x9c0>
 1087100: 913ac16b     	add	x11, x11, #0xeb0
 1087104: 14000002     	b	 <L81>
<L80>:
 1087108: aa1803eb     	mov	x11, x24
<L81>:
 108710c: 7940016b     	ldrh	w11, [x11]
 1087110: 7104017f     	cmp	w11, #0x100
 1087114: 54fffba3     	b.lo	 <L73>
 1087118: 9240096b     	and	x11, x11, #0x7
 108711c: 1acb240b     	lsr	w11, w0, w11
 1087120: 3607fb4b     	tbz	w11, #0x0,  <L73>
 1087124: 0b01024b     	add	w11, w18, w1
 1087128: 7100097f     	cmp	w11, #0x2
 108712c: 540000a3     	b.lo	 <L82>
 1087130: 6b05025f     	cmp	w18, w5
 1087134: 54fffaa1     	b.ne	 <L73>
 1087138: 3948f6eb     	ldrb	w11, [x23, #0x23d]
 108713c: 34fffa6b     	cbz	w11,  <L73>
<L82>:
 1087140: aa0c03fe     	mov	x30, x12
 1087144: aa0603eb     	mov	x11, x6
<L83>:
 1087148: 784027d1     	ldrh	w17, [x30], #0x2
 108714c: 6b12023f     	cmp	w17, w18
 1087150: 540007e0     	b.eq	 <L88>
 1087154: f100056b     	subs	x11, x11, #0x1
 1087158: 54ffff81     	b.ne	 <L83>
 108715c: 17ffffcb     	b	 <L73>
<L84>:
 1087160: 394ce7eb     	ldrb	w11, [sp, #0x339]
 1087164: 3400106b     	cbz	w11,  <L95>
 1087168: 910943ea     	add	x10, sp, #0x250
 108716c: 393873ff     	strb	wzr, [sp, #0xe1c]
 1087170: aa1703fa     	mov	x26, x23
 1087174: 3ccc9140     	ldur	q0, [x10, #0xc9]
 1087178: 784d9159     	ldurh	w25, [x10, #0xd9]
 108717c: 910943ea     	add	x10, sp, #0x250
<L85>:
 1087180: 3d8016c0     	str	q0, [x22, #0x50]
 1087184: f84dbd4b     	ldr	x11, [x10, #0xdb]!
 1087188: f840614a     	ldur	x10, [x10, #0x6]
 108718c: f90713eb     	str	x11, [sp, #0xe20]
 1087190: f80062ca     	stur	x10, [x22, #0x6]
 1087194: 1400013f     	b	 <L113>
<L86>:
 1087198: 394defeb     	ldrb	w11, [sp, #0x37b]
 108719c: 34000d0b     	cbz	w11,  <L93>
 10871a0: 394ce7eb     	ldrb	w11, [sp, #0x339]
 10871a4: 35000ccb     	cbnz	w11,  <L93>
 10871a8: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 10871ac: 35000c8b     	cbnz	w11,  <L93>
 10871b0: 394ba3eb     	ldrb	w11, [sp, #0x2e8]
 10871b4: 7200057f     	tst	w11, #0x3
 10871b8: 54000c21     	b.ne	 <L93>
 10871bc: 910943ea     	add	x10, sp, #0x250
 10871c0: 794697f9     	ldrh	w25, [sp, #0x34a]
 10871c4: 5280002b     	mov	w11, #0x1               // =1
 10871c8: 3ccea140     	ldur	q0, [x10, #0xea]
 10871cc: 9103f14a     	add	x10, x10, #0xfc
 10871d0: 393873eb     	strb	w11, [sp, #0xe1c]
 10871d4: 14000071     	b	 <L96>
<L87>:
 10871d8: 3948f74b     	ldrb	w11, [x26, #0x23d]
 10871dc: 34000b0b     	cbz	w11,  <L93>
 10871e0: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 10871e4: 34000acb     	cbz	w11,  <L93>
 10871e8: 394ce7eb     	ldrb	w11, [sp, #0x339]
 10871ec: 35000a8b     	cbnz	w11,  <L93>
 10871f0: 394defeb     	ldrb	w11, [sp, #0x37b]
 10871f4: 35000a4b     	cbnz	w11,  <L93>
 10871f8: 394ba3eb     	ldrb	w11, [sp, #0x2e8]
 10871fc: 7200057f     	tst	w11, #0x3
 1087200: 540009e1     	b.ne	 <L93>
 1087204: 910943ea     	add	x10, sp, #0x250
 1087208: 79471bf9     	ldrh	w25, [sp, #0x38c]
 108720c: 9104b14b     	add	x11, x10, #0x12c
 1087210: 9104f94a     	add	x10, x10, #0x13e
 1087214: ad408941     	ldp	q1, q2, [x10, #0x10]
 1087218: 3dc00160     	ldr	q0, [x11]
 108721c: 911683eb     	add	x11, sp, #0x5a0
 1087220: 3d8016c0     	str	q0, [x22, #0x50]
 1087224: 3dc00140     	ldr	q0, [x10]
 1087228: 3d822561     	str	q1, [x11, #0x890]
 108722c: 3dc00d41     	ldr	q1, [x10, #0x30]
 1087230: 3d822962     	str	q2, [x11, #0x8a0]
 1087234: 3cc3f142     	ldur	q2, [x10, #0x3f]
 1087238: 5280004a     	mov	w10, #0x2               // =2
 108723c: 3d822d61     	str	q1, [x11, #0x8b0]
 1087240: 3c83f2c2     	stur	q2, [x22, #0x3f]
 1087244: 393873ea     	strb	w10, [sp, #0xe1c]
 1087248: 14000071     	b	 <L99>
<L88>:
 108724c: f94133e5     	ldr	x5, [sp, #0x260]
 1087250: f94137e6     	ldr	x6, [sp, #0x268]
 1087254: 913a43e0     	add	x0, sp, #0xe90
 1087258: 910f83e4     	add	x4, sp, #0x3e0
 108725c: aa1303e1     	mov	x1, x19
 1087260: 2a1403e7     	mov	w7, w20
 1087264: a900a7e8     	stp	x8, x9, [sp, #0x8]
 1087268: 790003f2     	strh	w18, [sp]
 108726c: 94007fe0     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 1087270: 795d43e8     	ldrh	w8, [sp, #0xea0]
 1087274: 3500b828     	cbnz	w8,  <L164>
 1087278: f9474bf4     	ldr	x20, [sp, #0xe90]
 108727c: f9474ff5     	ldr	x21, [sp, #0xe98]
<L89>:
 1087280: f9404be8     	ldr	x8, [sp, #0x90]
 1087284: aa1303e0     	mov	x0, x19
 1087288: 39400101     	ldrb	w1, [x8]
 108728c: 9400823b     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 1087290: 6f00e400     	movi	v0.2d, #0000000000000000
 1087294: 390002ff     	strb	wzr, [x23]
<L90>:
 1087298: 911683e8     	add	x8, sp, #0x5a0
 108729c: 3d820900     	str	q0, [x8, #0x820]
 10872a0: 3d820d00     	str	q0, [x8, #0x830]
 10872a4: 3d821100     	str	q0, [x8, #0x840]
 10872a8: 3d821500     	str	q0, [x8, #0x850]
 10872ac: 3d821900     	str	q0, [x8, #0x860]
 10872b0: f9405be8     	ldr	x8, [sp, #0xb0]
 10872b4: 7900211f     	strh	wzr, [x8, #0x10]
 10872b8: a9005514     	stp	x20, x21, [x8]
 10872bc: 17fffca6     	b	 <L6>
<L91>:
 10872c0: 394ce7e8     	ldrb	w8, [sp, #0x339]
 10872c4: 350003a8     	cbnz	w8,  <L92>
 10872c8: 394defe8     	ldrb	w8, [sp, #0x37b]
 10872cc: 35000368     	cbnz	w8,  <L92>
 10872d0: 394f77e8     	ldrb	w8, [sp, #0x3dd]
 10872d4: 35000328     	cbnz	w8,  <L92>
 10872d8: 394ba3e8     	ldrb	w8, [sp, #0x2e8]
 10872dc: 12000508     	and	w8, w8, #0x3
 10872e0: 7100051f     	cmp	w8, #0x1
 10872e4: 540002a1     	b.ne	 <L92>
 10872e8: 794883e8     	ldrh	w8, [sp, #0x440]
 10872ec: 6b19011f     	cmp	w8, w25
 10872f0: 54000241     	b.ne	 <L92>
 10872f4: 910f83f7     	add	x23, sp, #0x3e0
 10872f8: 911cf3e2     	add	x2, sp, #0x73c
 10872fc: 913703e3     	add	x3, sp, #0xdc0
 1087300: 910142e1     	add	x1, x23, #0x50
 1087304: aa1303e0     	mov	x0, x19
 1087308: 94007f9b     	bl	 <ServerHandshake.encapsulateHybrid>
 108730c: 72003c1f     	tst	w0, #0xffff
 1087310: 5400bb81     	b.ne	 <L175>
 1087314: 52800068     	mov	w8, #0x3                // =3
 1087318: 3cc502e0     	ldur	q0, [x23, #0x50]
 108731c: b8462309     	ldur	w9, [x24, #0x62]
 1087320: 393873e8     	strb	w8, [sp, #0xe1c]
 1087324: 79488fe8     	ldrh	w8, [sp, #0x446]
 1087328: 3d8016c0     	str	q0, [x22, #0x50]
 108732c: b90e23e9     	str	w9, [sp, #0xe20]
 1087330: 791c4be8     	strh	w8, [sp, #0xe24]
 1087334: 140000fd     	b	 <L117>
<L92>:
 1087338: 6f00e400     	movi	v0.2d, #0000000000000000
<L93>:
 108733c: 911683eb     	add	x11, sp, #0x5a0
 1087340: d0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 1087344: 910b8108     	add	x8, x8, #0x2e0
 1087348: 52800949     	mov	w9, #0x4a               // =74
<L94>:
 108734c: 3d821960     	str	q0, [x11, #0x860]
 1087350: 3d821560     	str	q0, [x11, #0x850]
 1087354: 3d821160     	str	q0, [x11, #0x840]
 1087358: 3d820d60     	str	q0, [x11, #0x830]
 108735c: 3dc00101     	ldr	q1, [x8]
 1087360: 3d820960     	str	q0, [x11, #0x820]
 1087364: f9000949     	str	x9, [x10, #0x10]
 1087368: 3d800141     	str	q1, [x10]
 108736c: 17fffc7a     	b	 <L6>
<L95>:
 1087370: 394defeb     	ldrb	w11, [sp, #0x37b]
 1087374: 3400024b     	cbz	w11,  <L98>
 1087378: 910943eb     	add	x11, sp, #0x250
 108737c: 5280002a     	mov	w10, #0x1               // =1
 1087380: 794697f9     	ldrh	w25, [sp, #0x34a]
 1087384: 3ccea160     	ldur	q0, [x11, #0xea]
 1087388: 393873ea     	strb	w10, [sp, #0xe1c]
 108738c: 910943ea     	add	x10, sp, #0x250
 1087390: 9103f14a     	add	x10, x10, #0xfc
 1087394: aa1703fa     	mov	x26, x23
<L96>:
 1087398: 3d8016c0     	str	q0, [x22, #0x50]
 108739c: ad400540     	ldp	q0, q1, [x10]
 10873a0: 3cc1f142     	ldur	q2, [x10, #0x1f]
 10873a4: ad0006c0     	stp	q0, q1, [x22]
 10873a8: 3c81f2c2     	stur	q2, [x22, #0x1f]
 10873ac: 140000c1     	b	 <L114>
<L97>:
 10873b0: 910f83e8     	add	x8, sp, #0x3e0
 10873b4: 9101a118     	add	x24, x8, #0x68
 10873b8: 14000093     	b	 <L112>
<L98>:
 10873bc: 394f77eb     	ldrb	w11, [sp, #0x3dd]
 10873c0: aa1703fa     	mov	x26, x23
 10873c4: 340002eb     	cbz	w11,  <L101>
 10873c8: 3948f74b     	ldrb	w11, [x26, #0x23d]
 10873cc: 340002ab     	cbz	w11,  <L101>
 10873d0: 910943ea     	add	x10, sp, #0x250
 10873d4: 910943eb     	add	x11, sp, #0x250
 10873d8: 79471bf9     	ldrh	w25, [sp, #0x38c]
 10873dc: 9104b14a     	add	x10, x10, #0x12c
 10873e0: 9104f96b     	add	x11, x11, #0x13e
 10873e4: 3dc00140     	ldr	q0, [x10]
 10873e8: ad410961     	ldp	q1, q2, [x11, #0x20]
 10873ec: 5280004a     	mov	w10, #0x2               // =2
 10873f0: 3d8016c0     	str	q0, [x22, #0x50]
 10873f4: 3cc3f160     	ldur	q0, [x11, #0x3f]
 10873f8: ad010ac1     	stp	q1, q2, [x22, #0x20]
 10873fc: 3c83f2c0     	stur	q0, [x22, #0x3f]
 1087400: ad400560     	ldp	q0, q1, [x11]
 1087404: 393873ea     	strb	w10, [sp, #0xe1c]
 1087408: 3d8006c1     	str	q1, [x22, #0x10]
<L99>:
 108740c: 3d8002c0     	str	q0, [x22]
 1087410: 140000b7     	b	 <L116>
<L100>:
 1087414: 910f83e8     	add	x8, sp, #0x3e0
 1087418: 91020118     	add	x24, x8, #0x80
 108741c: 1400007a     	b	 <L112>
<L101>:
 1087420: d0fffc0b     	adrp	x11, 0x1009000 <__anon_51029+0x9c0>
 1087424: 795d516c     	ldrh	w12, [x11, #0xea8]
 1087428: 3952a3eb     	ldrb	w11, [sp, #0x4a8]
 108742c: 7104019f     	cmp	w12, #0x100
 1087430: 54000283     	b.lo	 <L102>
 1087434: 1200156d     	and	w13, w11, #0x3f
 1087438: 9240098c     	and	x12, x12, #0x7
 108743c: 1acc25ac     	lsr	w12, w13, w12
 1087440: 3600020c     	tbz	w12, #0x0,  <L102>
 1087444: f94133e5     	ldr	x5, [sp, #0x260]
 1087448: f94137e6     	ldr	x6, [sp, #0x268]
 108744c: 528003aa     	mov	w10, #0x1d              // =29
 1087450: 913aa3e0     	add	x0, sp, #0xea8
 1087454: 910f83e4     	add	x4, sp, #0x3e0
 1087458: aa1303e1     	mov	x1, x19
 108745c: 2a1403e7     	mov	w7, w20
 1087460: a900a7e8     	stp	x8, x9, [sp, #0x8]
 1087464: 790003ea     	strh	w10, [sp]
 1087468: 94007f61     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 108746c: 795d73e8     	ldrh	w8, [sp, #0xeb8]
 1087470: 3500a848     	cbnz	w8,  <L164>
 1087474: f94757f4     	ldr	x20, [sp, #0xea8]
 1087478: f9475bf5     	ldr	x21, [sp, #0xeb0]
 108747c: 14000017     	b	 <L103>
<L102>:
 1087480: d0fffc0c     	adrp	x12, 0x1009000 <__anon_51029+0x9c0>
 1087484: 795d598c     	ldrh	w12, [x12, #0xeac]
 1087488: 7104019f     	cmp	w12, #0x100
 108748c: 5400a303     	b.lo	 <L161>
 1087490: 1200156d     	and	w13, w11, #0x3f
 1087494: 9240098c     	and	x12, x12, #0x7
 1087498: 1acc25ac     	lsr	w12, w13, w12
 108749c: 3600a28c     	tbz	w12, #0x0,  <L161>
 10874a0: f94133e5     	ldr	x5, [sp, #0x260]
 10874a4: f94137e6     	ldr	x6, [sp, #0x268]
 10874a8: 528002ea     	mov	w10, #0x17              // =23
 10874ac: 913b03e0     	add	x0, sp, #0xec0
 10874b0: 910f83e4     	add	x4, sp, #0x3e0
 10874b4: aa1303e1     	mov	x1, x19
 10874b8: 2a1403e7     	mov	w7, w20
 10874bc: a900a7e8     	stp	x8, x9, [sp, #0x8]
 10874c0: 790003ea     	strh	w10, [sp]
 10874c4: 94007f4a     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 10874c8: 795da3e8     	ldrh	w8, [sp, #0xed0]
 10874cc: 3500a568     	cbnz	w8,  <L164>
 10874d0: f94763f4     	ldr	x20, [sp, #0xec0]
 10874d4: f94767f5     	ldr	x21, [sp, #0xec8]
<L103>:
 10874d8: f9404be8     	ldr	x8, [sp, #0x90]
 10874dc: aa1303e0     	mov	x0, x19
 10874e0: 39400101     	ldrb	w1, [x8]
 10874e4: 940081a5     	bl	 <ServerHandshake.resetEarlyDataStateForRetry>
 10874e8: 6f00e400     	movi	v0.2d, #0000000000000000
 10874ec: 3900035f     	strb	wzr, [x26]
 10874f0: 17ffff6a     	b	 <L90>
<L104>:
 10874f4: 90fffe23     	adrp	x3, 0x104b000 <__anon_927254+0xd8>
 10874f8: 9109a063     	add	x3, x3, #0x268
 10874fc: 911a63e0     	add	x0, sp, #0x698
 1087500: 94006872     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 1087504: 91400be8     	add	x8, sp, #0x2, lsl #12   // =0x2000
 1087508: f94057e1     	ldr	x1, [sp, #0xa8]
 108750c: aa1503e0     	mov	x0, x21
 1087510: 91044108     	add	x8, x8, #0x110
 1087514: 91005502     	add	x2, x8, #0x15
 1087518: 97ffdcdb     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).hash>
 108751c: 91400bea     	add	x10, sp, #0x2, lsl #12  // =0x2000
 1087520: 52800229     	mov	w9, #0x11               // =17
 1087524: 52840008     	mov	w8, #0x2000             // =8192
 1087528: 9104414a     	add	x10, x10, #0x110
 108752c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1087530: 911ae3e0     	add	x0, sp, #0x6b8
 1087534: 39000949     	strb	w9, [x10, #0x2]
 1087538: b0fffc09     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 108753c: 913cd929     	add	x9, x9, #0xf36
 1087540: 3dc00120     	ldr	q0, [x9]
 1087544: 79000148     	strh	w8, [x10]
 1087548: 52840c68     	mov	w8, #0x2063             // =8291
 108754c: 91044042     	add	x2, x2, #0x110
 1087550: 911a63e4     	add	x4, sp, #0x698
 1087554: 52800401     	mov	w1, #0x20               // =32
 1087558: 528006a3     	mov	w3, #0x35               // =53
 108755c: 78013148     	sturh	w8, [x10, #0x13]
 1087560: 3c803140     	stur	q0, [x10, #0x3]
 1087564: 940068d2     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1087568: 911b63e0     	add	x0, sp, #0x6d8
 108756c: 911ae3e2     	add	x2, sp, #0x6b8
 1087570: 2a1703e1     	mov	w1, w23
 1087574: 97ffdd8c     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 1087578: 794e63e8     	ldrh	w8, [sp, #0x730]
 108757c: 3500a7c8     	cbnz	w8,  <L174>
 1087580: 9117e7e8     	add	x8, sp, #0x5f9
 1087584: 911767e9     	add	x9, sp, #0x5d9
 1087588: 3ccff100     	ldur	q0, [x8, #0xff]
 108758c: 911827e8     	add	x8, sp, #0x609
 1087590: 3ccff101     	ldur	q1, [x8, #0xff]
 1087594: 911867e8     	add	x8, sp, #0x619
 1087598: 3ccff102     	ldur	q2, [x8, #0xff]
 108759c: f94397e8     	ldr	x8, [sp, #0x728]
 10875a0: 3d814260     	str	q0, [x19, #0x500]
 10875a4: 3ccff120     	ldur	q0, [x9, #0xff]
 10875a8: 3d814661     	str	q1, [x19, #0x510]
 10875ac: 3d814a62     	str	q2, [x19, #0x520]
 10875b0: f9029a68     	str	x8, [x19, #0x530]
 10875b4: 9117a7e8     	add	x8, sp, #0x5e9
<L105>:
 10875b8: 3ccff101     	ldur	q1, [x8, #0xff]
 10875bc: 52800028     	mov	w8, #0x1                // =1
 10875c0: 3d813a60     	str	q0, [x19, #0x4e0]
 10875c4: 3914e268     	strb	w8, [x19, #0x538]
 10875c8: 3d813e61     	str	q1, [x19, #0x4f0]
 10875cc: 17fffdf6     	b	 <L54>
<L106>:
 10875d0: 910f83e8     	add	x8, sp, #0x3e0
 10875d4: 9101a118     	add	x24, x8, #0x68
 10875d8: 1400000a     	b	 <L111>
<L107>:
 10875dc: aa1f03ea     	mov	x10, xzr
 10875e0: aa1f03fa     	mov	x26, xzr
<L108>:
 10875e4: eb0d015f     	cmp	x10, x13
 10875e8: 54ffa820     	b.eq	 <L37>
<L109>:
 10875ec: 52800869     	mov	w9, #0x43               // =67
 10875f0: 79002109     	strh	w9, [x8, #0x10]
 10875f4: 17fffbd8     	b	 <L6>
<L110>:
 10875f8: 910f83e8     	add	x8, sp, #0x3e0
 10875fc: 91020118     	add	x24, x8, #0x80
<L111>:
 1087600: 52823da1     	mov	w1, #0x11ed             // =4589
<L112>:
 1087604: a9400f02     	ldp	x2, x3, [x24]
 1087608: 528952a8     	mov	w8, #0x4a95             // =19093
 108760c: 911cf3e9     	add	x9, sp, #0x73c
 1087610: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1087614: 52800a0a     	mov	w10, #0x50              // =80
 1087618: 91044000     	add	x0, x0, #0x110
 108761c: 8b080264     	add	x4, x19, x8
 1087620: b27f0125     	orr	x5, x9, #0x2
 1087624: 913703e7     	add	x7, sp, #0xdc0
 1087628: 5280d026     	mov	w6, #0x681              // =1665
 108762c: f90003ea     	str	x10, [sp]
 1087630: 94009561     	bl	 <hybrid_kex.encapsulate>
 1087634: 79404328     	ldrh	w8, [x25, #0x20]
 1087638: 3500a108     	cbnz	w8,  <L173>
 108763c: b9611be8     	ldr	w8, [sp, #0x2118]
 1087640: b9612be9     	ldr	w9, [sp, #0x2128]
 1087644: 5280006a     	mov	w10, #0x3               // =3
 1087648: 3dc00300     	ldr	q0, [x24]
 108764c: 79402319     	ldrh	w25, [x24, #0x10]
 1087650: 7100055f     	cmp	w10, #0x1
 1087654: 12002908     	and	w8, w8, #0x7ff
 1087658: 12001929     	and	w9, w9, #0x7f
 108765c: 393a33ea     	strb	w10, [sp, #0xe8c]
 1087660: 790e7be8     	strh	w8, [sp, #0x73c]
 1087664: b8412308     	ldur	w8, [x24, #0x12]
 1087668: 393843e9     	strb	w9, [sp, #0xe10]
 108766c: 79402f09     	ldrh	w9, [x24, #0x16]
 1087670: b90e23e8     	str	w8, [sp, #0xe20]
 1087674: f94053e8     	ldr	x8, [sp, #0xa0]
 1087678: 791c4be9     	strh	w9, [sp, #0xe24]
 108767c: f94047e9     	ldr	x9, [sp, #0x88]
 1087680: 3d8016c0     	str	q0, [x22, #0x50]
 1087684: 393873ea     	strb	w10, [sp, #0xe1c]
 1087688: 540002ec     	b.gt	 <L115>
 108768c: 3500012a     	cbnz	w10,  <L114>
<L113>:
 1087690: 528956aa     	mov	w10, #0x4ab5            // =19125
 1087694: 528003ab     	mov	w11, #0x1d              // =29
 1087698: 391d5adf     	strb	wzr, [x22, #0x756]
 108769c: 8b0a026a     	add	x10, x19, x10
 10876a0: 79130e6b     	strh	w11, [x19, #0x986]
 10876a4: ad400540     	ldp	q0, q1, [x10]
 10876a8: ad0686c0     	stp	q0, q1, [x22, #0xd0]
 10876ac: 1400002a     	b	 <L118>
<L114>:
 10876b0: 52895eaa     	mov	w10, #0x4af5            // =19189
 10876b4: 528002eb     	mov	w11, #0x17              // =23
 10876b8: 8b0a026a     	add	x10, x19, x10
 10876bc: 79130e6b     	strh	w11, [x19, #0x986]
 10876c0: 5280002b     	mov	w11, #0x1               // =1
 10876c4: ad410540     	ldp	q0, q1, [x10, #0x20]
 10876c8: 391d5acb     	strb	w11, [x22, #0x756]
 10876cc: 3941014b     	ldrb	w11, [x10, #0x40]
 10876d0: ad0786c0     	stp	q0, q1, [x22, #0xf0]
 10876d4: ad400141     	ldp	q1, q0, [x10]
 10876d8: 393cc3eb     	strb	w11, [sp, #0xf30]
 10876dc: ad0682c1     	stp	q1, q0, [x22, #0xd0]
 10876e0: 1400001d     	b	 <L118>
<L115>:
 10876e4: 7100095f     	cmp	w10, #0x2
 10876e8: 54000201     	b.ne	 <L117>
<L116>:
 10876ec: 52896cca     	mov	w10, #0x4b66            // =19302
 10876f0: 5280030b     	mov	w11, #0x18              // =24
 10876f4: 8b0a026a     	add	x10, x19, x10
 10876f8: 79130e6b     	strh	w11, [x19, #0x986]
 10876fc: 5280004b     	mov	w11, #0x2               // =2
 1087700: ad420540     	ldp	q0, q1, [x10, #0x40]
 1087704: 391d5acb     	strb	w11, [x22, #0x756]
 1087708: 3941814b     	ldrb	w11, [x10, #0x60]
 108770c: ad0886c0     	stp	q0, q1, [x22, #0x110]
 1087710: ad400540     	ldp	q0, q1, [x10]
 1087714: 393d43eb     	strb	w11, [sp, #0xf50]
 1087718: ad0686c0     	stp	q0, q1, [x22, #0xd0]
 108771c: ad410940     	ldp	q0, q2, [x10, #0x20]
 1087720: ad078ac0     	stp	q0, q2, [x22, #0xf0]
 1087724: 1400000c     	b	 <L118>
<L117>:
 1087728: 52800068     	mov	w8, #0x3                // =3
 108772c: 911cf3e1     	add	x1, sp, #0x73c
 1087730: 5280d082     	mov	w2, #0x684              // =1668
 1087734: 391d5ac8     	strb	w8, [x22, #0x756]
 1087738: 913bc3e8     	add	x8, sp, #0xef0
 108773c: b27f0100     	orr	x0, x8, #0x2
 1087740: 79130e79     	strh	w25, [x19, #0x986]
 1087744: 791de3f9     	strh	w25, [sp, #0xef0]
 1087748: 940555e0     	bl	 <memcpy>
 108774c: f94047e9     	ldr	x9, [sp, #0x88]
 1087750: f94053e8     	ldr	x8, [sp, #0xa0]
<L118>:
 1087754: 3955826a     	ldrb	w10, [x19, #0x560]
 1087758: f94133e4     	ldr	x4, [sp, #0x260]
 108775c: d1001522     	sub	x2, x9, #0x5
 1087760: f94137f7     	ldr	x23, [sp, #0x268]
 1087764: 52894ea9     	mov	w9, #0x4a75             // =19061
 1087768: f90033fa     	str	x26, [sp, #0x60]
 108776c: 3400020a     	cbz	w10,  <L119>
 1087770: 7953066a     	ldrh	w10, [x19, #0x982]
 1087774: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087778: 91001501     	add	x1, x8, #0x5
 108777c: 91160000     	add	x0, x0, #0x580
 1087780: 8b090263     	add	x3, x19, x9
 1087784: 913bc3e7     	add	x7, sp, #0xef0
 1087788: aa1703e5     	mov	x5, x23
 108778c: 2a1403e6     	mov	w6, w20
 1087790: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 1087794: 790003ea     	strh	w10, [sp]
 1087798: 91160318     	add	x24, x24, #0x580
 108779c: 97fff7e7     	bl	 <server_hello.encodeWithKeyShareAndPsk>
 10877a0: 796b23e8     	ldrh	w8, [sp, #0x1590]
 10877a4: 340001c8     	cbz	w8,  <L120>
 10877a8: 14000474     	b	 <L164>
<L119>:
 10877ac: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10877b0: 91001501     	add	x1, x8, #0x5
 10877b4: 8b090263     	add	x3, x19, x9
 10877b8: 91166000     	add	x0, x0, #0x598
 10877bc: 913bc3e7     	add	x7, sp, #0xef0
 10877c0: aa1703e5     	mov	x5, x23
 10877c4: 2a1403e6     	mov	w6, w20
 10877c8: 914007f8     	add	x24, sp, #0x1, lsl #12  // =0x1000
 10877cc: 91166318     	add	x24, x24, #0x598
 10877d0: 97fff759     	bl	 <server_hello.encodeWithKeyShare>
 10877d4: 796b53e8     	ldrh	w8, [sp, #0x15a8]
 10877d8: 35008d08     	cbnz	w8,  <L164>
<L120>:
 10877dc: a9406b18     	ldp	x24, x26, [x24]
 10877e0: 528002ca     	mov	w10, #0x16              // =22
 10877e4: f94053e9     	ldr	x9, [sp, #0xa0]
 10877e8: 5ac00b48     	rev	w8, w26
 10877ec: 3900012a     	strb	w10, [x9]
 10877f0: 5280606a     	mov	w10, #0x303             // =771
 10877f4: 53107d08     	lsr	w8, w8, #16
 10877f8: 9100174b     	add	x11, x26, #0x5
 10877fc: 7800112a     	sturh	w10, [x9, #0x1]
 1087800: 78003128     	sturh	w8, [x9, #0x3]
 1087804: f9405be8     	ldr	x8, [sp, #0xb0]
 1087808: b4000357     	cbz	x23,  <L122>
 108780c: 3966026a     	ldrb	w10, [x19, #0x980]
 1087810: 3500030a     	cbnz	w10,  <L122>
 1087814: f94047ea     	ldr	x10, [sp, #0x88]
 1087818: cb0b014a     	sub	x10, x10, x11
 108781c: f100155f     	cmp	x10, #0x5
 1087820: 54000168     	b.hi	 <L121>
 1087824: 6f00e400     	movi	v0.2d, #0000000000000000
 1087828: 911683ea     	add	x10, sp, #0x5a0
 108782c: 528000a9     	mov	w9, #0x5                // =5
 1087830: 3d821940     	str	q0, [x10, #0x860]
 1087834: 3d821540     	str	q0, [x10, #0x850]
 1087838: 3d821140     	str	q0, [x10, #0x840]
 108783c: 3d820d40     	str	q0, [x10, #0x830]
 1087840: 3d820940     	str	q0, [x10, #0x820]
 1087844: 79002109     	strh	w9, [x8, #0x10]
 1087848: 17fffb43     	b	 <L6>
<L121>:
 108784c: 8b0b0129     	add	x9, x9, x11
 1087850: 5280028a     	mov	w10, #0x14              // =20
 1087854: 5280606b     	mov	w11, #0x303             // =771
 1087858: 72a0200b     	movk	w11, #0x100, lsl #16
 108785c: 3900012a     	strb	w10, [x9]
 1087860: 5280002a     	mov	w10, #0x1               // =1
 1087864: b800112b     	stur	w11, [x9, #0x1]
 1087868: 91002f4b     	add	x11, x26, #0xb
 108786c: 3900152a     	strb	w10, [x9, #0x5]
<L122>:
 1087870: 397873e9     	ldrb	w9, [sp, #0xe1c]
 1087874: 914007f7     	add	x23, sp, #0x1, lsl #12  // =0x1000
 1087878: f9003beb     	str	x11, [sp, #0x70]
 108787c: 911802f7     	add	x23, x23, #0x600
 1087880: 12000529     	and	w9, w9, #0x3
 1087884: 7100053f     	cmp	w9, #0x1
 1087888: 540002ac     	b.gt	 <L123>
 108788c: 350008a9     	cbnz	w9,  <L124>
 1087890: f94713e8     	ldr	x8, [sp, #0xe20]
 1087894: 3dc016c0     	ldr	q0, [x22, #0x50]
 1087898: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108789c: f84062c9     	ldur	x9, [x22, #0x6]
 10878a0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10878a4: 9118b000     	add	x0, x0, #0x62c
 10878a8: f80122e8     	stur	x8, [x23, #0x12]
 10878ac: 528952a8     	mov	w8, #0x4a95             // =19093
 10878b0: 91180042     	add	x2, x2, #0x600
 10878b4: 8b080261     	add	x1, x19, x8
 10878b8: 792c23f9     	strh	w25, [sp, #0x1610]
 10878bc: 3d81fac0     	str	q0, [x22, #0x7e0]
 10878c0: f90b0fe9     	str	x9, [sp, #0x1618]
 10878c4: 97ffe8c4     	bl	 <x25519.sharedSecret>
 10878c8: 796c5bf9     	ldrh	w25, [sp, #0x162c]
 10878cc: 35008c39     	cbnz	w25,  <L172>
 10878d0: 3cc2e2e0     	ldur	q0, [x23, #0x2e]
 10878d4: 3cc3e2e1     	ldur	q1, [x23, #0x3e]
 10878d8: 14000045     	b	 <L125>
<L123>:
 10878dc: 7100093f     	cmp	w9, #0x2
 10878e0: 540008e1     	b.ne	 <L126>
 10878e4: ad408ac1     	ldp	q1, q2, [x22, #0x10]
 10878e8: 914007e8     	add	x8, sp, #0x1, lsl #12   // =0x1000
 10878ec: 3dc016c0     	ldr	q0, [x22, #0x50]
 10878f0: 528966c9     	mov	w9, #0x4b36             // =19254
 10878f4: 911b0108     	add	x8, x8, #0x6c0
 10878f8: 8b090269     	add	x9, x19, x9
 10878fc: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087900: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087904: 3d8032e0     	str	q0, [x23, #0xc0]
 1087908: 3dc002c0     	ldr	q0, [x22]
 108790c: 7941212a     	ldrh	w10, [x9, #0x90]
 1087910: 3c8e22e1     	stur	q1, [x23, #0xe2]
 1087914: 3dc00ec1     	ldr	q1, [x22, #0x30]
 1087918: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 108791c: 3c812100     	stur	q0, [x8, #0x12]
 1087920: 911f3000     	add	x0, x0, #0x7cc
 1087924: 911cc021     	add	x1, x1, #0x730
 1087928: 3c842101     	stur	q1, [x8, #0x42]
 108792c: ad400121     	ldp	q1, q0, [x9]
 1087930: 3c8f22e2     	stur	q2, [x23, #0xf2]
 1087934: 3cc3f2c2     	ldur	q2, [x22, #0x3f]
 1087938: 911b0042     	add	x2, x2, #0x6c0
 108793c: 792da3f9     	strh	w25, [sp, #0x16d0]
 1087940: 3c851102     	stur	q2, [x8, #0x51]
 1087944: ad038101     	stp	q1, q0, [x8, #0x70]
 1087948: ad420921     	ldp	q1, q2, [x9, #0x40]
 108794c: 792f83ea     	strh	w10, [sp, #0x17c0]
 1087950: ad058901     	stp	q1, q2, [x8, #0xb0]
 1087954: ad410122     	ldp	q2, q0, [x9, #0x20]
 1087958: ad048102     	stp	q2, q0, [x8, #0x90]
 108795c: ad438121     	ldp	q1, q0, [x9, #0x70]
 1087960: 3dc01922     	ldr	q2, [x9, #0x60]
 1087964: ad070101     	stp	q1, q0, [x8, #0xe0]
 1087968: 3d803502     	str	q2, [x8, #0xd0]
 108796c: 97ffe944     	bl	 <p384.sharedSecret>
 1087970: 796f9bf9     	ldrh	w25, [sp, #0x17cc]
 1087974: 350086f9     	cbnz	w25,  <L172>
 1087978: 914007e8     	add	x8, sp, #0x1, lsl #12   // =0x1000
 108797c: 52800617     	mov	w23, #0x30              // =48
 1087980: 911f3108     	add	x8, x8, #0x7cc
 1087984: 3cc02100     	ldur	q0, [x8, #0x2]
 1087988: 3cc12101     	ldur	q1, [x8, #0x12]
 108798c: 3cc22102     	ldur	q2, [x8, #0x22]
 1087990: 3d81e6c0     	str	q0, [x22, #0x790]
 1087994: 3d81eac1     	str	q1, [x22, #0x7a0]
 1087998: 3d81eec2     	str	q2, [x22, #0x7b0]
 108799c: 14000020     	b	 <L127>
<L124>:
 10879a0: 3dc016c0     	ldr	q0, [x22, #0x50]
 10879a4: ad400ac1     	ldp	q1, q2, [x22]
 10879a8: 52895aa8     	mov	w8, #0x4ad5             // =19157
 10879ac: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10879b0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10879b4: 3d8016e0     	str	q0, [x23, #0x50]
 10879b8: 3cc1f2c0     	ldur	q0, [x22, #0x1f]
 10879bc: 911a7000     	add	x0, x0, #0x69c
 10879c0: 8b080261     	add	x1, x19, x8
 10879c4: 91194042     	add	x2, x2, #0x650
 10879c8: 792cc3f9     	strh	w25, [sp, #0x1660]
 10879cc: 3c8622e1     	stur	q1, [x23, #0x62]
 10879d0: 3c8722e2     	stur	q2, [x23, #0x72]
 10879d4: 3c8812e0     	stur	q0, [x23, #0x81]
 10879d8: 97ffe8de     	bl	 <p256.sharedSecret>
 10879dc: 796d3bf9     	ldrh	w25, [sp, #0x169c]
 10879e0: 35008399     	cbnz	w25,  <L172>
 10879e4: 3cc9e2e0     	ldur	q0, [x23, #0x9e]
 10879e8: 3ccae2e1     	ldur	q1, [x23, #0xae]
<L125>:
 10879ec: 52800417     	mov	w23, #0x20              // =32
 10879f0: 3d81e6c0     	str	q0, [x22, #0x790]
 10879f4: 3d81eac1     	str	q1, [x22, #0x7a0]
 10879f8: 14000009     	b	 <L127>
<L126>:
 10879fc: 397843e9     	ldrb	w9, [sp, #0xe10]
 1087a00: 92401937     	and	x23, x9, #0x7f
 1087a04: 34007617     	cbz	w23,  <L159>
 1087a08: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087a0c: 913703e1     	add	x1, sp, #0xdc0
 1087a10: aa1703e2     	mov	x2, x23
 1087a14: 9116c000     	add	x0, x0, #0x5b0
 1087a18: 9405552c     	bl	 <memcpy>
<L127>:
 1087a1c: f94057e8     	ldr	x8, [sp, #0xa8]
 1087a20: 910c426b     	add	x11, x19, #0x310
 1087a24: 3943c269     	ldrb	w9, [x19, #0xf0]
 1087a28: 5282604a     	mov	w10, #0x1302            // =4866
 1087a2c: aa1503e1     	mov	x1, x21
 1087a30: f90047f7     	str	x23, [sp, #0x88]
 1087a34: 6b0a029f     	cmp	w20, w10
 1087a38: 9119b96a     	add	x10, x11, #0x66e
 1087a3c: a9052beb     	stp	x11, x10, [sp, #0x50]
 1087a40: 540002a1     	b.ne	 <L128>
 1087a44: 34000509     	cbz	w9,  <L129>
 1087a48: ad460660     	ldp	q0, q1, [x19, #0xc0]
 1087a4c: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1087a50: 3dc03a62     	ldr	q2, [x19, #0xe0]
 1087a54: 91238129     	add	x9, x9, #0x8e0
 1087a58: ad0d0760     	stp	q0, q1, [x27, #0x1a0]
 1087a5c: ad440660     	ldp	q0, q1, [x19, #0x80]
 1087a60: 3d807362     	str	q2, [x27, #0x1c0]
 1087a64: ad0b0760     	stp	q0, q1, [x27, #0x160]
 1087a68: ad450a60     	ldp	q0, q2, [x19, #0xa0]
 1087a6c: ad0c0b60     	stp	q0, q2, [x27, #0x180]
 1087a70: ad420261     	ldp	q1, q0, [x19, #0x40]
 1087a74: ad090361     	stp	q1, q0, [x27, #0x120]
 1087a78: ad430a60     	ldp	q0, q2, [x19, #0x60]
 1087a7c: ad0a0b60     	stp	q0, q2, [x27, #0x140]
 1087a80: ad400261     	ldp	q1, q0, [x19]
 1087a84: ad070361     	stp	q1, q0, [x27, #0xe0]
 1087a88: ad410a60     	ldp	q0, q2, [x19, #0x20]
 1087a8c: ad080b60     	stp	q0, q2, [x27, #0x100]
 1087a90: 14000017     	b	 <L130>
<L128>:
 1087a94: 34000e49     	cbz	w9,  <L135>
 1087a98: ad460660     	ldp	q0, q1, [x19, #0xc0]
 1087a9c: 914007e9     	add	x9, sp, #0x1, lsl #12   // =0x1000
 1087aa0: 3dc03a62     	ldr	q2, [x19, #0xe0]
 1087aa4: 912c0129     	add	x9, x9, #0xb00
 1087aa8: ad1e0760     	stp	q0, q1, [x27, #0x3c0]
 1087aac: ad440660     	ldp	q0, q1, [x19, #0x80]
 1087ab0: 3d80fb62     	str	q2, [x27, #0x3e0]
 1087ab4: ad1c0760     	stp	q0, q1, [x27, #0x380]
 1087ab8: ad450a60     	ldp	q0, q2, [x19, #0xa0]
 1087abc: ad1d0b60     	stp	q0, q2, [x27, #0x3a0]
 1087ac0: ad420261     	ldp	q1, q0, [x19, #0x40]
 1087ac4: ad1a0361     	stp	q1, q0, [x27, #0x340]
 1087ac8: ad430a60     	ldp	q0, q2, [x19, #0x60]
 1087acc: ad1b0b60     	stp	q0, q2, [x27, #0x360]
 1087ad0: ad400261     	ldp	q1, q0, [x19]
 1087ad4: ad180361     	stp	q1, q0, [x27, #0x300]
 1087ad8: ad410a60     	ldp	q0, q2, [x19, #0x20]
 1087adc: ad190b60     	stp	q0, q2, [x27, #0x320]
 1087ae0: 14000061     	b	 <L136>
<L129>:
 1087ae4: d0fffc09     	adrp	x9, 0x1009000 <__anon_51029+0x9c0>
 1087ae8: 91000129     	add	x9, x9, #0x0
<L130>:
 1087aec: ad450520     	ldp	q0, q1, [x9, #0xa0]
 1087af0: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087af4: 911f314a     	add	x10, x10, #0x7cc
 1087af8: 3c8d4140     	stur	q0, [x10, #0xd4]
 1087afc: ad460920     	ldp	q0, q2, [x9, #0xc0]
 1087b00: 3c8e4141     	stur	q1, [x10, #0xe4]
 1087b04: 3c8f4140     	stur	q0, [x10, #0xf4]
 1087b08: ad430520     	ldp	q0, q1, [x9, #0x60]
 1087b0c: 3d803762     	str	q2, [x27, #0xd0]
 1087b10: ad030760     	stp	q0, q1, [x27, #0x60]
 1087b14: ad440122     	ldp	q2, q0, [x9, #0x80]
 1087b18: ad040362     	stp	q2, q0, [x27, #0x80]
 1087b1c: ad410121     	ldp	q1, q0, [x9, #0x20]
 1087b20: ad010361     	stp	q1, q0, [x27, #0x20]
 1087b24: ad420122     	ldp	q2, q0, [x9, #0x40]
 1087b28: ad020362     	stp	q2, q0, [x27, #0x40]
 1087b2c: ad400121     	ldp	q1, q0, [x9]
 1087b30: 39434369     	ldrb	w9, [x27, #0xd0]
 1087b34: ad000361     	stp	q1, q0, [x27]
 1087b38: 340002a9     	cbz	w9,  <L131>
 1087b3c: 8b09010a     	add	x10, x8, x9
 1087b40: f102015f     	cmp	x10, #0x80
 1087b44: 54000243     	b.lo	 <L131>
 1087b48: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087b4c: 52801008     	mov	w8, #0x80               // =128
 1087b50: 9120014a     	add	x10, x10, #0x800
 1087b54: cb090119     	sub	x25, x8, x9
 1087b58: 91014154     	add	x20, x10, #0x50
 1087b5c: aa1903e2     	mov	x2, x25
 1087b60: 8b090280     	add	x0, x20, x9
 1087b64: 940554d9     	bl	 <memcpy>
 1087b68: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087b6c: aa1403e1     	mov	x1, x20
 1087b70: 91200000     	add	x0, x0, #0x800
 1087b74: 94006f86     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087b78: f94057e8     	ldr	x8, [sp, #0xa8]
 1087b7c: aa1503e1     	mov	x1, x21
 1087b80: 2a1f03e9     	mov	w9, wzr
 1087b84: 3903437f     	strb	wzr, [x27, #0xd0]
 1087b88: 14000002     	b	 <L132>
<L131>:
 1087b8c: aa1f03f9     	mov	x25, xzr
<L132>:
 1087b90: b279032a     	orr	x10, x25, #0x80
 1087b94: eb08015f     	cmp	x10, x8
 1087b98: 54000188     	b.hi	 <L134>
<L133>:
 1087b9c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087ba0: 8b190021     	add	x1, x1, x25
 1087ba4: 91200000     	add	x0, x0, #0x800
 1087ba8: 94006f79     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087bac: f94057e8     	ldr	x8, [sp, #0xa8]
 1087bb0: 91040329     	add	x9, x25, #0x100
 1087bb4: aa1503e1     	mov	x1, x21
 1087bb8: 91020339     	add	x25, x25, #0x80
 1087bbc: eb08013f     	cmp	x9, x8
 1087bc0: 54fffee9     	b.ls	 <L133>
 1087bc4: 39434369     	ldrb	w9, [x27, #0xd0]
<L134>:
 1087bc8: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087bcc: cb190115     	sub	x21, x8, x25
 1087bd0: 8b190021     	add	x1, x1, x25
 1087bd4: 9120014a     	add	x10, x10, #0x800
 1087bd8: aa1503e2     	mov	x2, x21
 1087bdc: aa0803f6     	mov	x22, x8
 1087be0: 91014154     	add	x20, x10, #0x50
 1087be4: 8b294280     	add	x0, x20, w9, uxtw
 1087be8: 940554b8     	bl	 <memcpy>
 1087bec: f94c03e9     	ldr	x9, [sp, #0x1800]
 1087bf0: 39434368     	ldrb	w8, [x27, #0xd0]
 1087bf4: f94c07ea     	ldr	x10, [sp, #0x1808]
 1087bf8: ab160129     	adds	x9, x9, x22
 1087bfc: 0b150108     	add	w8, w8, w21
 1087c00: 9a8a354a     	cinc	x10, x10, hs
 1087c04: 39034368     	strb	w8, [x27, #0xd0]
 1087c08: f90c03e9     	str	x9, [sp, #0x1800]
 1087c0c: f90c07ea     	str	x10, [sp, #0x1808]
 1087c10: 34000c88     	cbz	w8,  <L141>
 1087c14: 8b080349     	add	x9, x26, x8
 1087c18: 91400bf9     	add	x25, sp, #0x2, lsl #12  // =0x2000
 1087c1c: f102013f     	cmp	x9, #0x80
 1087c20: 91044339     	add	x25, x25, #0x110
 1087c24: 54000ce3     	b.lo	 <L143>
 1087c28: 52801009     	mov	w9, #0x80               // =128
 1087c2c: 8b080280     	add	x0, x20, x8
 1087c30: aa1803e1     	mov	x1, x24
 1087c34: 4b080135     	sub	w21, w9, w8
 1087c38: aa1503e2     	mov	x2, x21
 1087c3c: 940554a3     	bl	 <memcpy>
 1087c40: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087c44: aa1403e1     	mov	x1, x20
 1087c48: 91200000     	add	x0, x0, #0x800
 1087c4c: 94006f50     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087c50: 2a1f03e8     	mov	w8, wzr
 1087c54: 3903437f     	strb	wzr, [x27, #0xd0]
 1087c58: 1400005b     	b	 <L144>
<L135>:
 1087c5c: b0fffc09     	adrp	x9, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 1087c60: 913e4129     	add	x9, x9, #0xf90
<L136>:
 1087c64: ad428122     	ldp	q2, q0, [x9, #0x50]
 1087c68: 3dc01123     	ldr	q3, [x9, #0x40]
 1087c6c: ad170362     	stp	q2, q0, [x27, #0x2e0]
 1087c70: ad400520     	ldp	q0, q1, [x9]
 1087c74: ad148760     	stp	q0, q1, [x27, #0x290]
 1087c78: ad410920     	ldp	q0, q2, [x9, #0x20]
 1087c7c: 394be369     	ldrb	w9, [x27, #0x2f8]
 1087c80: ad160f62     	stp	q2, q3, [x27, #0x2c0]
 1087c84: 3d80af60     	str	q0, [x27, #0x2b0]
 1087c88: 340002a9     	cbz	w9,  <L137>
 1087c8c: 8b09010a     	add	x10, x8, x9
 1087c90: f101015f     	cmp	x10, #0x40
 1087c94: 54000243     	b.lo	 <L137>
 1087c98: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087c9c: 52800808     	mov	w8, #0x40               // =64
 1087ca0: 912a414a     	add	x10, x10, #0xa90
 1087ca4: cb090119     	sub	x25, x8, x9
 1087ca8: 9100a157     	add	x23, x10, #0x28
 1087cac: aa1903e2     	mov	x2, x25
 1087cb0: 8b0902e0     	add	x0, x23, x9
 1087cb4: 94055485     	bl	 <memcpy>
 1087cb8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087cbc: aa1703e1     	mov	x1, x23
 1087cc0: 912a4000     	add	x0, x0, #0xa90
 1087cc4: 940068ba     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1087cc8: f94057e8     	ldr	x8, [sp, #0xa8]
 1087ccc: aa1503e1     	mov	x1, x21
 1087cd0: 2a1f03e9     	mov	w9, wzr
 1087cd4: 390be37f     	strb	wzr, [x27, #0x2f8]
 1087cd8: 14000002     	b	 <L138>
<L137>:
 1087cdc: aa1f03f9     	mov	x25, xzr
<L138>:
 1087ce0: 9101032a     	add	x10, x25, #0x40
 1087ce4: eb08015f     	cmp	x10, x8
 1087ce8: 54000188     	b.hi	 <L140>
<L139>:
 1087cec: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087cf0: 8b190021     	add	x1, x1, x25
 1087cf4: 912a4000     	add	x0, x0, #0xa90
 1087cf8: 940068ad     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1087cfc: f94057e8     	ldr	x8, [sp, #0xa8]
 1087d00: 91020329     	add	x9, x25, #0x80
 1087d04: aa1503e1     	mov	x1, x21
 1087d08: 91010339     	add	x25, x25, #0x40
 1087d0c: eb08013f     	cmp	x9, x8
 1087d10: 54fffee9     	b.ls	 <L139>
 1087d14: 394be369     	ldrb	w9, [x27, #0x2f8]
<L140>:
 1087d18: 914007ea     	add	x10, sp, #0x1, lsl #12  // =0x1000
 1087d1c: cb190116     	sub	x22, x8, x25
 1087d20: 8b190021     	add	x1, x1, x25
 1087d24: 912a414a     	add	x10, x10, #0xa90
 1087d28: aa1603e2     	mov	x2, x22
 1087d2c: aa0803f7     	mov	x23, x8
 1087d30: 9100a155     	add	x21, x10, #0x28
 1087d34: 8b2942a0     	add	x0, x21, w9, uxtw
 1087d38: 94055464     	bl	 <memcpy>
 1087d3c: 394be368     	ldrb	w8, [x27, #0x2f8]
 1087d40: f94d5be9     	ldr	x9, [sp, #0x1ab0]
 1087d44: 2b160108     	adds	w8, w8, w22
 1087d48: 8b170129     	add	x9, x9, x23
 1087d4c: 390be368     	strb	w8, [x27, #0x2f8]
 1087d50: f90d5be9     	str	x9, [sp, #0x1ab0]
 1087d54: 540002e0     	b.eq	 <L142>
 1087d58: 8b080349     	add	x9, x26, x8
 1087d5c: 91400bf9     	add	x25, sp, #0x2, lsl #12  // =0x2000
 1087d60: f101013f     	cmp	x9, #0x40
 1087d64: 91044339     	add	x25, x25, #0x110
 1087d68: 54001fc3     	b.lo	 <L149>
 1087d6c: 52800809     	mov	w9, #0x40               // =64
 1087d70: 8b0802a0     	add	x0, x21, x8
 1087d74: aa1803e1     	mov	x1, x24
 1087d78: 4b080136     	sub	w22, w9, w8
 1087d7c: aa1603e2     	mov	x2, x22
 1087d80: 94055452     	bl	 <memcpy>
 1087d84: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087d88: aa1503e1     	mov	x1, x21
 1087d8c: 912a4000     	add	x0, x0, #0xa90
 1087d90: 94006887     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1087d94: 2a1f03e8     	mov	w8, wzr
 1087d98: 390be37f     	strb	wzr, [x27, #0x2f8]
 1087d9c: 140000f2     	b	 <L150>
<L141>:
 1087da0: 91400bf9     	add	x25, sp, #0x2, lsl #12  // =0x2000
 1087da4: aa1f03f5     	mov	x21, xzr
 1087da8: 91044339     	add	x25, x25, #0x110
 1087dac: 14000006     	b	 <L144>
<L142>:
 1087db0: 91400bf9     	add	x25, sp, #0x2, lsl #12  // =0x2000
 1087db4: aa1f03f6     	mov	x22, xzr
 1087db8: 91044339     	add	x25, x25, #0x110
 1087dbc: 140000ea     	b	 <L150>
<L143>:
 1087dc0: aa1f03f5     	mov	x21, xzr
<L144>:
 1087dc4: b27902a9     	orr	x9, x21, #0x80
 1087dc8: eb1a013f     	cmp	x9, x26
 1087dcc: 54000148     	b.hi	 <L146>
<L145>:
 1087dd0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087dd4: 8b150301     	add	x1, x24, x21
 1087dd8: 91200000     	add	x0, x0, #0x800
 1087ddc: 94006eec     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 1087de0: 910402a8     	add	x8, x21, #0x100
 1087de4: 910202b5     	add	x21, x21, #0x80
 1087de8: eb1a011f     	cmp	x8, x26
 1087dec: 54ffff29     	b.ls	 <L145>
 1087df0: 39434368     	ldrb	w8, [x27, #0xd0]
<L146>:
 1087df4: 8b284280     	add	x0, x20, w8, uxtw
 1087df8: cb150354     	sub	x20, x26, x21
 1087dfc: 8b150301     	add	x1, x24, x21
 1087e00: aa1403e2     	mov	x2, x20
 1087e04: 94055431     	bl	 <memcpy>
 1087e08: f94c03e9     	ldr	x9, [sp, #0x1800]
 1087e0c: 39434368     	ldrb	w8, [x27, #0xd0]
 1087e10: f94c07ea     	ldr	x10, [sp, #0x1808]
 1087e14: ab1a0129     	adds	x9, x9, x26
 1087e18: 0b140108     	add	w8, w8, w20
 1087e1c: 9a8a354a     	cinc	x10, x10, hs
 1087e20: 39034368     	strb	w8, [x27, #0xd0]
 1087e24: 39558268     	ldrb	w8, [x19, #0x560]
 1087e28: f90c07ea     	str	x10, [sp, #0x1808]
 1087e2c: f9402bea     	ldr	x10, [sp, #0x50]
 1087e30: f90c03e9     	str	x9, [sp, #0x1800]
 1087e34: 52800029     	mov	w9, #0x1                // =1
 1087e38: 39000149     	strb	w9, [x10]
 1087e3c: 34000168     	cbz	w8,  <L147>
 1087e40: f942a662     	ldr	x2, [x19, #0x548]
 1087e44: f942a261     	ldr	x1, [x19, #0x540]
 1087e48: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087e4c: b0fffc03     	adrp	x3, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 1087e50: 910af063     	add	x3, x3, #0x2bc
 1087e54: 91274000     	add	x0, x0, #0x9d0
 1087e58: 914007f4     	add	x20, sp, #0x1, lsl #12  // =0x1000
 1087e5c: 91274294     	add	x20, x20, #0x9d0
 1087e60: 94006302     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 1087e64: 14000003     	b	 <L148>
<L147>:
 1087e68: f0fffc14     	adrp	x20, 0x100a000 <server_hello.downgrade_tls11_or_below+0xd30>
 1087e6c: 9101d694     	add	x20, x20, #0x75
<L148>:
 1087e70: ad450760     	ldp	q0, q1, [x27, #0xa0]
 1087e74: b0fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 1087e78: 910bb108     	add	x8, x8, #0x2ec
 1087e7c: 528001a9     	mov	w9, #0xd                // =13
 1087e80: f0fffc0a     	adrp	x10, 0x100a000 <server_hello.downgrade_tls11_or_below+0xd30>
 1087e84: 9101a14a     	add	x10, x10, #0x68
 1087e88: 39000b29     	strb	w9, [x25, #0x2]
 1087e8c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1087e90: 3d823760     	str	q0, [x27, #0x8d0]
 1087e94: f940014b     	ldr	x11, [x10]
 1087e98: f8405149     	ldur	x9, [x10, #0x5]
 1087e9c: 3d823b61     	str	q1, [x27, #0x8e0]
 1087ea0: ad460760     	ldp	q0, q1, [x27, #0xc0]
 1087ea4: 52860015     	mov	w21, #0x3000            // =12288
 1087ea8: 52800616     	mov	w22, #0x30              // =48
 1087eac: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1087eb0: 91044042     	add	x2, x2, #0x110
 1087eb4: 52800601     	mov	w1, #0x30               // =48
 1087eb8: 52800823     	mov	w3, #0x41               // =65
 1087ebc: 3d823f60     	str	q0, [x27, #0x8f0]
 1087ec0: aa1403e4     	mov	x4, x20
 1087ec4: d0fffc1a     	adrp	x26, 0x1009000 <__anon_51029+0x9c0>
 1087ec8: 913b275a     	add	x26, x26, #0xec9
 1087ecc: 3d824361     	str	q1, [x27, #0x900]
 1087ed0: ad430760     	ldp	q0, q1, [x27, #0x60]
 1087ed4: f800332b     	stur	x11, [x25, #0x3]
 1087ed8: 79000335     	strh	w21, [x25]
 1087edc: f9108fe9     	str	x9, [sp, #0x2118]
 1087ee0: 3d822760     	str	q0, [x27, #0x890]
 1087ee4: 3d822b61     	str	q1, [x27, #0x8a0]
 1087ee8: ad440760     	ldp	q0, q1, [x27, #0x80]
 1087eec: 39004336     	strb	w22, [x25, #0x10]
 1087ef0: 3d822f60     	str	q0, [x27, #0x8b0]
 1087ef4: 3d823361     	str	q1, [x27, #0x8c0]
 1087ef8: ad410760     	ldp	q0, q1, [x27, #0x20]
 1087efc: 3d821760     	str	q0, [x27, #0x850]
 1087f00: 3d821b61     	str	q1, [x27, #0x860]
 1087f04: ad420760     	ldp	q0, q1, [x27, #0x40]
 1087f08: 3d821f60     	str	q0, [x27, #0x870]
 1087f0c: 3d822361     	str	q1, [x27, #0x880]
 1087f10: ad400760     	ldp	q0, q1, [x27]
 1087f14: 3d820f60     	str	q0, [x27, #0x830]
 1087f18: 3d821361     	str	q1, [x27, #0x840]
 1087f1c: ad400500     	ldp	q0, q1, [x8]
 1087f20: 3c811320     	stur	q0, [x25, #0x11]
 1087f24: 3dc00900     	ldr	q0, [x8, #0x20]
 1087f28: 3c821321     	stur	q1, [x25, #0x21]
 1087f2c: 3c831320     	stur	q0, [x25, #0x31]
 1087f30: 9400637c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087f34: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1087f38: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087f3c: 91400be3     	add	x3, sp, #0x2, lsl #12   // =0x2000
 1087f40: 913e8000     	add	x0, x0, #0xfa0
 1087f44: 9116c021     	add	x1, x1, #0x5b0
 1087f48: aa1703e2     	mov	x2, x23
 1087f4c: 940062c7     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 1087f50: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1087f54: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 1087f58: 9100c000     	add	x0, x0, #0x30
 1087f5c: 913f4021     	add	x1, x1, #0xfd0
 1087f60: 9400657d     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 1087f64: 3dc00340     	ldr	q0, [x26]
 1087f68: 3dc1fb61     	ldr	q1, [x27, #0x7e0]
 1087f6c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1087f70: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1087f74: 52800254     	mov	w20, #0x12              // =18
 1087f78: 528c6d37     	mov	w23, #0x6369            // =25449
 1087f7c: 3c803320     	stur	q0, [x25, #0x3]
 1087f80: 3dc1f760     	ldr	q0, [x27, #0x7d0]
 1087f84: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1087f88: 91044042     	add	x2, x2, #0x110
 1087f8c: 913e8084     	add	x4, x4, #0xfa0
 1087f90: 52800601     	mov	w1, #0x30               // =48
 1087f94: 3c816320     	stur	q0, [x25, #0x16]
 1087f98: 3dc1ff60     	ldr	q0, [x27, #0x7f0]
 1087f9c: 528008c3     	mov	w3, #0x46               // =70
 1087fa0: 79000335     	strh	w21, [x25]
 1087fa4: 39000b34     	strb	w20, [x25, #0x2]
 1087fa8: 78013337     	sturh	w23, [x25, #0x13]
 1087fac: 39005736     	strb	w22, [x25, #0x15]
 1087fb0: 3c826321     	stur	q1, [x25, #0x26]
 1087fb4: 3c836320     	stur	q0, [x25, #0x36]
 1087fb8: 9400635a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1087fbc: d0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 1087fc0: 913b6d08     	add	x8, x8, #0xedb
 1087fc4: 3dc1fb61     	ldr	q1, [x27, #0x7e0]
 1087fc8: 3dc00100     	ldr	q0, [x8]
 1087fcc: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1087fd0: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1087fd4: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1087fd8: 9100c000     	add	x0, x0, #0x30
 1087fdc: 91044042     	add	x2, x2, #0x110
 1087fe0: 3c803320     	stur	q0, [x25, #0x3]
 1087fe4: 3dc1f760     	ldr	q0, [x27, #0x7d0]
 1087fe8: 913e8084     	add	x4, x4, #0xfa0
 1087fec: 52800601     	mov	w1, #0x30               // =48
 1087ff0: 528008c3     	mov	w3, #0x46               // =70
 1087ff4: 79000335     	strh	w21, [x25]
 1087ff8: 3c816320     	stur	q0, [x25, #0x16]
 1087ffc: 3dc1ff60     	ldr	q0, [x27, #0x7f0]
 1088000: 39000b34     	strb	w20, [x25, #0x2]
 1088004: 78013337     	sturh	w23, [x25, #0x13]
 1088008: 39005736     	strb	w22, [x25, #0x15]
 108800c: 3c826321     	stur	q1, [x25, #0x26]
 1088010: 3c836320     	stur	q0, [x25, #0x36]
 1088014: 94006343     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1088018: 90fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 108801c: 913ca108     	add	x8, x8, #0xf28
 1088020: 3dc1eb60     	ldr	q0, [x27, #0x7a0]
 1088024: 3dc1ef61     	ldr	q1, [x27, #0x7b0]
 1088028: 3dc1f362     	ldr	q2, [x27, #0x7c0]
 108802c: f9400116     	ldr	x22, [x8]
 1088030: f8406117     	ldur	x23, [x8, #0x6]
 1088034: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088038: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 108803c: 528001d4     	mov	w20, #0xe               // =14
 1088040: 9128c000     	add	x0, x0, #0xa30
 1088044: 91044042     	add	x2, x2, #0x110
 1088048: 91400be4     	add	x4, sp, #0x2, lsl #12   // =0x2000
 108804c: 52800601     	mov	w1, #0x30               // =48
 1088050: 52800243     	mov	w3, #0x12               // =18
 1088054: ad130760     	stp	q0, q1, [x27, #0x260]
 1088058: 3d80a362     	str	q2, [x27, #0x280]
 108805c: 79000335     	strh	w21, [x25]
 1088060: 39000b34     	strb	w20, [x25, #0x2]
 1088064: f8003336     	stur	x22, [x25, #0x3]
 1088068: f8009337     	stur	x23, [x25, #0x9]
 108806c: 3900473f     	strb	wzr, [x25, #0x11]
 1088070: 9400632c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1088074: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088078: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 108807c: 91400be4     	add	x4, sp, #0x2, lsl #12   // =0x2000
 1088080: 91280000     	add	x0, x0, #0xa00
 1088084: 91044042     	add	x2, x2, #0x110
 1088088: 9100c084     	add	x4, x4, #0x30
 108808c: 52800601     	mov	w1, #0x30               // =48
 1088090: 52800243     	mov	w3, #0x12               // =18
 1088094: 79000335     	strh	w21, [x25]
 1088098: 39000b34     	strb	w20, [x25, #0x2]
 108809c: f8003336     	stur	x22, [x25, #0x3]
 10880a0: f8009337     	stur	x23, [x25, #0x9]
 10880a4: 3900473f     	strb	wzr, [x25, #0x11]
 10880a8: 9400631e     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10880ac: 6f00e400     	movi	v0.2d, #0000000000000000
 10880b0: 3900033f     	strb	wzr, [x25]
 10880b4: 91078a68     	add	x8, x19, #0x1e2
 10880b8: 52826055     	mov	w21, #0x1302            // =4866
 10880bc: 3d81eb60     	str	q0, [x27, #0x7a0]
 10880c0: 3d81ef60     	str	q0, [x27, #0x7b0]
 10880c4: 3d81f360     	str	q0, [x27, #0x7c0]
 10880c8: 3d820360     	str	q0, [x27, #0x800]
 10880cc: 3d820760     	str	q0, [x27, #0x810]
 10880d0: 3d820b60     	str	q0, [x27, #0x820]
 10880d4: 3d820f60     	str	q0, [x27, #0x830]
 10880d8: 3d821360     	str	q0, [x27, #0x840]
 10880dc: 3d821760     	str	q0, [x27, #0x850]
 10880e0: ad450760     	ldp	q0, q1, [x27, #0xa0]
 10880e4: 7903c275     	strh	w21, [x19, #0x1e0]
 10880e8: 390c0a7f     	strb	wzr, [x19, #0x302]
 10880ec: ad0d0660     	stp	q0, q1, [x19, #0x1a0]
 10880f0: ad460362     	ldp	q2, q0, [x27, #0xc0]
 10880f4: ad0e0262     	stp	q2, q0, [x19, #0x1c0]
 10880f8: ad430361     	ldp	q1, q0, [x27, #0x60]
 10880fc: ad0b0261     	stp	q1, q0, [x19, #0x160]
 1088100: ad440362     	ldp	q2, q0, [x27, #0x80]
 1088104: 7942e274     	ldrh	w20, [x19, #0x170]
 1088108: ad0c0262     	stp	q2, q0, [x19, #0x180]
 108810c: ad410361     	ldp	q1, q0, [x27, #0x20]
 1088110: ad090261     	stp	q1, q0, [x19, #0x120]
 1088114: ad420362     	ldp	q2, q0, [x27, #0x40]
 1088118: ad0a0262     	stp	q2, q0, [x19, #0x140]
 108811c: ad400361     	ldp	q1, q0, [x27]
 1088120: ad080261     	stp	q1, q0, [x19, #0x100]
 1088124: ad530362     	ldp	q2, q0, [x27, #0x260]
 1088128: 3dc0a361     	ldr	q1, [x27, #0x280]
 108812c: ad000102     	stp	q2, q0, [x8]
 1088130: 3dc09762     	ldr	q2, [x27, #0x250]
 1088134: 3d800901     	str	q1, [x8, #0x20]
 1088138: ad518760     	ldp	q0, q1, [x27, #0x230]
 108813c: 91084a68     	add	x8, x19, #0x212
 1088140: 3d800902     	str	q2, [x8, #0x20]
 1088144: ad000500     	stp	q0, q1, [x8]
 1088148: ad508f60     	ldp	q0, q3, [x27, #0x210]
 108814c: 3dc08361     	ldr	q1, [x27, #0x200]
 1088150: 91090a68     	add	x8, x19, #0x242
 1088154: ad008d00     	stp	q0, q3, [x8, #0x10]
 1088158: 3d800101     	str	q1, [x8]
 108815c: 140000c6     	b	 <L155>
<L149>:
 1088160: aa1f03f6     	mov	x22, xzr
<L150>:
 1088164: 910102c9     	add	x9, x22, #0x40
 1088168: eb1a013f     	cmp	x9, x26
 108816c: 54000148     	b.hi	 <L152>
<L151>:
 1088170: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088174: 8b160301     	add	x1, x24, x22
 1088178: 912a4000     	add	x0, x0, #0xa90
 108817c: 9400678c     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 1088180: 910202c8     	add	x8, x22, #0x80
 1088184: 910102d6     	add	x22, x22, #0x40
 1088188: eb1a011f     	cmp	x8, x26
 108818c: 54ffff29     	b.ls	 <L151>
 1088190: 394be368     	ldrb	w8, [x27, #0x2f8]
<L152>:
 1088194: 8b2842a0     	add	x0, x21, w8, uxtw
 1088198: cb160355     	sub	x21, x26, x22
 108819c: 8b160301     	add	x1, x24, x22
 10881a0: aa1503e2     	mov	x2, x21
 10881a4: 94055349     	bl	 <memcpy>
 10881a8: 394be368     	ldrb	w8, [x27, #0x2f8]
 10881ac: f94d5be9     	ldr	x9, [sp, #0x1ab0]
 10881b0: 3955826a     	ldrb	w10, [x19, #0x560]
 10881b4: 0b150108     	add	w8, w8, w21
 10881b8: 8b1a0129     	add	x9, x9, x26
 10881bc: 390be368     	strb	w8, [x27, #0x2f8]
 10881c0: f90d5be9     	str	x9, [sp, #0x1ab0]
 10881c4: 3400016a     	cbz	w10,  <L153>
 10881c8: f942a662     	ldr	x2, [x19, #0x548]
 10881cc: f942a261     	ldr	x1, [x19, #0x540]
 10881d0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10881d4: f0fffe03     	adrp	x3, 0x104b000 <__anon_927254+0xd8>
 10881d8: 9109a063     	add	x3, x3, #0x268
 10881dc: 912fc000     	add	x0, x0, #0xbf0
 10881e0: 914007f5     	add	x21, sp, #0x1, lsl #12  // =0x1000
 10881e4: 912fc2b5     	add	x21, x21, #0xbf0
 10881e8: 94006538     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10881ec: 14000003     	b	 <L154>
<L153>:
 10881f0: f0fffe15     	adrp	x21, 0x104b000 <__anon_927254+0xd8>
 10881f4: 910fa2b5     	add	x21, x21, #0x3e8
<L154>:
 10881f8: ad560760     	ldp	q0, q1, [x27, #0x2c0]
 10881fc: f0fffe08     	adrp	x8, 0x104b000 <__anon_927254+0xd8>
 1088200: 9117a108     	add	x8, x8, #0x5e8
 1088204: f9402be9     	ldr	x9, [sp, #0x50]
 1088208: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 108820c: 52840016     	mov	w22, #0x2000            // =8192
 1088210: 52800417     	mov	w23, #0x20              // =32
 1088214: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1088218: 3d821b60     	str	q0, [x27, #0x860]
 108821c: 91044042     	add	x2, x2, #0x110
 1088220: 52800401     	mov	w1, #0x20               // =32
 1088224: 3d821f61     	str	q1, [x27, #0x870]
 1088228: ad570760     	ldp	q0, q1, [x27, #0x2e0]
 108822c: 3900013f     	strb	wzr, [x9]
 1088230: 52800623     	mov	w3, #0x31               // =49
 1088234: aa1503e4     	mov	x4, x21
 1088238: b0fffc1a     	adrp	x26, 0x1009000 <__anon_51029+0x9c0>
 108823c: 913b275a     	add	x26, x26, #0xec9
 1088240: 79000336     	strh	w22, [x25]
 1088244: 3d822761     	str	q1, [x27, #0x890]
 1088248: ad550b61     	ldp	q1, q2, [x27, #0x2a0]
 108824c: 3d822360     	str	q0, [x27, #0x880]
 1088250: 3dc0a760     	ldr	q0, [x27, #0x290]
 1088254: 39004337     	strb	w23, [x25, #0x10]
 1088258: 3d820f60     	str	q0, [x27, #0x830]
 108825c: 3d821361     	str	q1, [x27, #0x840]
 1088260: ad400500     	ldp	q0, q1, [x8]
 1088264: 528001a8     	mov	w8, #0xd                // =13
 1088268: 3d821762     	str	q2, [x27, #0x850]
 108826c: 39000b28     	strb	w8, [x25, #0x2]
 1088270: d0fffc08     	adrp	x8, 0x100a000 <server_hello.downgrade_tls11_or_below+0xd30>
 1088274: 9101a108     	add	x8, x8, #0x68
 1088278: f9400109     	ldr	x9, [x8]
 108827c: f8405108     	ldur	x8, [x8, #0x5]
 1088280: 3c811320     	stur	q0, [x25, #0x11]
 1088284: 3c821321     	stur	q1, [x25, #0x21]
 1088288: f8003329     	stur	x9, [x25, #0x3]
 108828c: f9108fe8     	str	x8, [sp, #0x2118]
 1088290: 94006587     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088294: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088298: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 108829c: f94047e2     	ldr	x2, [sp, #0x88]
 10882a0: 913e8000     	add	x0, x0, #0xfa0
 10882a4: 9116c021     	add	x1, x1, #0x5b0
 10882a8: 91400be3     	add	x3, sp, #0x2, lsl #12   // =0x2000
 10882ac: 94006507     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10882b0: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 10882b4: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10882b8: 9100c000     	add	x0, x0, #0x30
 10882bc: 913f4021     	add	x1, x1, #0xfd0
 10882c0: 940066ef     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10882c4: 3dc00340     	ldr	q0, [x26]
 10882c8: 3dc1fb61     	ldr	q1, [x27, #0x7e0]
 10882cc: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 10882d0: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 10882d4: 52800255     	mov	w21, #0x12              // =18
 10882d8: 528c6d38     	mov	w24, #0x6369            // =25449
 10882dc: 3c803320     	stur	q0, [x25, #0x3]
 10882e0: 3dc1f760     	ldr	q0, [x27, #0x7d0]
 10882e4: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 10882e8: 91044042     	add	x2, x2, #0x110
 10882ec: 913e8084     	add	x4, x4, #0xfa0
 10882f0: 52800401     	mov	w1, #0x20               // =32
 10882f4: 528006c3     	mov	w3, #0x36               // =54
 10882f8: 79000336     	strh	w22, [x25]
 10882fc: 39000b35     	strb	w21, [x25, #0x2]
 1088300: 78013338     	sturh	w24, [x25, #0x13]
 1088304: 39005737     	strb	w23, [x25, #0x15]
 1088308: 3c816320     	stur	q0, [x25, #0x16]
 108830c: 3c826321     	stur	q1, [x25, #0x26]
 1088310: 94006567     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088314: b0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 1088318: 913b6d08     	add	x8, x8, #0xedb
 108831c: 3dc1fb61     	ldr	q1, [x27, #0x7e0]
 1088320: 3dc00100     	ldr	q0, [x8]
 1088324: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 1088328: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 108832c: 914007e4     	add	x4, sp, #0x1, lsl #12   // =0x1000
 1088330: 9100c000     	add	x0, x0, #0x30
 1088334: 91044042     	add	x2, x2, #0x110
 1088338: 3c803320     	stur	q0, [x25, #0x3]
 108833c: 3dc1f760     	ldr	q0, [x27, #0x7d0]
 1088340: 913e8084     	add	x4, x4, #0xfa0
 1088344: 52800401     	mov	w1, #0x20               // =32
 1088348: 528006c3     	mov	w3, #0x36               // =54
 108834c: 79000336     	strh	w22, [x25]
 1088350: 39000b35     	strb	w21, [x25, #0x2]
 1088354: 78013338     	sturh	w24, [x25, #0x13]
 1088358: 39005737     	strb	w23, [x25, #0x15]
 108835c: 3c816320     	stur	q0, [x25, #0x16]
 1088360: 3c826321     	stur	q1, [x25, #0x26]
 1088364: 94006552     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088368: 90fffc08     	adrp	x8, 0x1008000 <certificate_chain.pem_decoder+0x23f8>
 108836c: 913ca108     	add	x8, x8, #0xf28
 1088370: 3dc1eb60     	ldr	q0, [x27, #0x7a0]
 1088374: 3dc1ef61     	ldr	q1, [x27, #0x7b0]
 1088378: f9400117     	ldr	x23, [x8]
 108837c: f8406118     	ldur	x24, [x8, #0x6]
 1088380: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088384: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1088388: 528001d5     	mov	w21, #0xe               // =14
 108838c: 9130c000     	add	x0, x0, #0xc30
 1088390: 91044042     	add	x2, x2, #0x110
 1088394: 91400be4     	add	x4, sp, #0x2, lsl #12   // =0x2000
 1088398: 52800401     	mov	w1, #0x20               // =32
 108839c: 52800243     	mov	w3, #0x12               // =18
 10883a0: 79000336     	strh	w22, [x25]
 10883a4: 3d811760     	str	q0, [x27, #0x450]
 10883a8: 3d811b61     	str	q1, [x27, #0x460]
 10883ac: 39000b35     	strb	w21, [x25, #0x2]
 10883b0: f8003337     	stur	x23, [x25, #0x3]
 10883b4: f8009338     	stur	x24, [x25, #0x9]
 10883b8: 3900473f     	strb	wzr, [x25, #0x11]
 10883bc: 9400653c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10883c0: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10883c4: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 10883c8: 91400be4     	add	x4, sp, #0x2, lsl #12   // =0x2000
 10883cc: 91304000     	add	x0, x0, #0xc10
 10883d0: 91044042     	add	x2, x2, #0x110
 10883d4: 9100c084     	add	x4, x4, #0x30
 10883d8: 52800401     	mov	w1, #0x20               // =32
 10883dc: 52800243     	mov	w3, #0x12               // =18
 10883e0: 79000336     	strh	w22, [x25]
 10883e4: 39000b35     	strb	w21, [x25, #0x2]
 10883e8: f8003337     	stur	x23, [x25, #0x3]
 10883ec: f8009338     	stur	x24, [x25, #0x9]
 10883f0: 3900473f     	strb	wzr, [x25, #0x11]
 10883f4: 9400652e     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10883f8: 6f00e400     	movi	v0.2d, #0000000000000000
 10883fc: 3900033f     	strb	wzr, [x25]
 1088400: 9105ca68     	add	x8, x19, #0x172
 1088404: 3d81eb60     	str	q0, [x27, #0x7a0]
 1088408: 3d81ef60     	str	q0, [x27, #0x7b0]
 108840c: 3d820760     	str	q0, [x27, #0x810]
 1088410: 3d820360     	str	q0, [x27, #0x800]
 1088414: 3d821360     	str	q0, [x27, #0x840]
 1088418: 3d820f60     	str	q0, [x27, #0x830]
 108841c: ad568760     	ldp	q0, q1, [x27, #0x2d0]
 1088420: 3dc0bf62     	ldr	q2, [x27, #0x2f0]
 1088424: 7943c275     	ldrh	w21, [x19, #0x1e0]
 1088428: 7902e274     	strh	w20, [x19, #0x170]
 108842c: 3d805a62     	str	q2, [x19, #0x160]
 1088430: ad0a0660     	stp	q0, q1, [x19, #0x140]
 1088434: ad548760     	ldp	q0, q1, [x27, #0x290]
 1088438: 3908ca7f     	strb	wzr, [x19, #0x232]
 108843c: ad080660     	stp	q0, q1, [x19, #0x100]
 1088440: ad558b60     	ldp	q0, q2, [x27, #0x2b0]
 1088444: 3dc11b61     	ldr	q1, [x27, #0x460]
 1088448: ad090a60     	stp	q0, q2, [x19, #0x120]
 108844c: 3dc11760     	ldr	q0, [x27, #0x450]
 1088450: 3dc11362     	ldr	q2, [x27, #0x440]
 1088454: ad000500     	stp	q0, q1, [x8]
 1088458: 3dc10f60     	ldr	q0, [x27, #0x430]
 108845c: 91064a68     	add	x8, x19, #0x192
 1088460: 3dc10b61     	ldr	q1, [x27, #0x420]
 1088464: ad000900     	stp	q0, q2, [x8]
 1088468: 3dc10760     	ldr	q0, [x27, #0x410]
 108846c: 9106ca68     	add	x8, x19, #0x1b2
 1088470: ad000500     	stp	q0, q1, [x8]
<L155>:
 1088474: 6f00e400     	movi	v0.2d, #0000000000000000
 1088478: f9402fe8     	ldr	x8, [sp, #0x58]
 108847c: 9105ca76     	add	x22, x19, #0x172
 1088480: b900011f     	str	wzr, [x8]
 1088484: f94037e8     	ldr	x8, [sp, #0x68]
 1088488: ad000100     	stp	q0, q0, [x8]
 108848c: ad010100     	stp	q0, q0, [x8, #0x20]
 1088490: ad020100     	stp	q0, q0, [x8, #0x40]
 1088494: ad030100     	stp	q0, q0, [x8, #0x60]
 1088498: ad040100     	stp	q0, q0, [x8, #0x80]
 108849c: 3c89b100     	stur	q0, [x8, #0x9b]
 10884a0: 394c4268     	ldrb	w8, [x19, #0x310]
 10884a4: ad000260     	stp	q0, q0, [x19]
 10884a8: ad010260     	stp	q0, q0, [x19, #0x20]
 10884ac: ad020260     	stp	q0, q0, [x19, #0x40]
 10884b0: ad030260     	stp	q0, q0, [x19, #0x60]
 10884b4: ad040260     	stp	q0, q0, [x19, #0x80]
 10884b8: ad050260     	stp	q0, q0, [x19, #0xa0]
 10884bc: ad060260     	stp	q0, q0, [x19, #0xc0]
 10884c0: ad070260     	stp	q0, q0, [x19, #0xe0]
 10884c4: 36000f88     	tbz	w8, #0x0,  <L156>
 10884c8: ad4a0660     	ldp	q0, q1, [x19, #0x140]
 10884cc: 91064a68     	add	x8, x19, #0x192
 10884d0: 3dc05a62     	ldr	q2, [x19, #0x160]
 10884d4: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 10884d8: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10884dc: 91044000     	add	x0, x0, #0x110
 10884e0: 9137c021     	add	x1, x1, #0xdf0
 10884e4: 7900e334     	strh	w20, [x25, #0x70]
 10884e8: ad020720     	stp	q0, q1, [x25, #0x40]
 10884ec: ad480660     	ldp	q0, q1, [x19, #0x100]
 10884f0: 3d801b22     	str	q2, [x25, #0x60]
 10884f4: ad000720     	stp	q0, q1, [x25]
 10884f8: ad490a60     	ldp	q0, q2, [x19, #0x120]
 10884fc: ad010b20     	stp	q0, q2, [x25, #0x20]
 1088500: ad4002c1     	ldp	q1, q0, [x22]
 1088504: 3dc00102     	ldr	q2, [x8]
 1088508: 3c872321     	stur	q1, [x25, #0x72]
 108850c: 3c882320     	stur	q0, [x25, #0x82]
 1088510: ad408101     	ldp	q1, q0, [x8, #0x10]
 1088514: 3c892322     	stur	q2, [x25, #0x92]
 1088518: 3c8a2321     	stur	q1, [x25, #0xa2]
 108851c: 3dc00d01     	ldr	q1, [x8, #0x30]
 1088520: 3c8b2320     	stur	q0, [x25, #0xb2]
 1088524: 3dc07660     	ldr	q0, [x19, #0x1d0]
 1088528: 3c8c2321     	stur	q1, [x25, #0xc2]
 108852c: 3d803720     	str	q0, [x25, #0xd0]
 1088530: 94006409     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 1088534: 3dc00340     	ldr	q0, [x26]
 1088538: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108853c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1088540: 52860014     	mov	w20, #0x3000            // =12288
 1088544: 52800256     	mov	w22, #0x12              // =18
 1088548: 528c6d37     	mov	w23, #0x6369            // =25449
 108854c: 3c803320     	stur	q0, [x25, #0x3]
 1088550: 3dc17f60     	ldr	q0, [x27, #0x5f0]
 1088554: 52800618     	mov	w24, #0x30              // =48
 1088558: 91388000     	add	x0, x0, #0xe20
 108855c: 91044042     	add	x2, x2, #0x110
 1088560: 91078a64     	add	x4, x19, #0x1e2
 1088564: 3c816320     	stur	q0, [x25, #0x16]
 1088568: 3dc18360     	ldr	q0, [x27, #0x600]
 108856c: 52800601     	mov	w1, #0x30               // =48
 1088570: 528008c3     	mov	w3, #0x46               // =70
 1088574: 79000334     	strh	w20, [x25]
 1088578: 3c826320     	stur	q0, [x25, #0x26]
 108857c: 3dc18760     	ldr	q0, [x27, #0x610]
 1088580: 39000b36     	strb	w22, [x25, #0x2]
 1088584: 78013337     	sturh	w23, [x25, #0x13]
 1088588: 39005738     	strb	w24, [x25, #0x15]
 108858c: 3c836320     	stur	q0, [x25, #0x36]
 1088590: 940061e4     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 1088594: b0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 1088598: 913b6d08     	add	x8, x8, #0xedb
 108859c: 3dc18361     	ldr	q1, [x27, #0x600]
 10885a0: 3dc00100     	ldr	q0, [x8]
 10885a4: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10885a8: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 10885ac: 91394000     	add	x0, x0, #0xe50
 10885b0: 91044042     	add	x2, x2, #0x110
 10885b4: 91078a64     	add	x4, x19, #0x1e2
 10885b8: 3c803320     	stur	q0, [x25, #0x3]
 10885bc: 3dc17f60     	ldr	q0, [x27, #0x5f0]
 10885c0: 52800601     	mov	w1, #0x30               // =48
 10885c4: 528008c3     	mov	w3, #0x46               // =70
 10885c8: 79000334     	strh	w20, [x25]
 10885cc: 3c816320     	stur	q0, [x25, #0x16]
 10885d0: 3dc18760     	ldr	q0, [x27, #0x610]
 10885d4: 39000b36     	strb	w22, [x25, #0x2]
 10885d8: 78013337     	sturh	w23, [x25, #0x13]
 10885dc: 39005738     	strb	w24, [x25, #0x15]
 10885e0: 3c826321     	stur	q1, [x25, #0x26]
 10885e4: 3c836320     	stur	q0, [x25, #0x36]
 10885e8: 940061ce     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10885ec: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10885f0: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10885f4: 2a1503e1     	mov	w1, w21
 10885f8: 913b8000     	add	x0, x0, #0xee0
 10885fc: 91388042     	add	x2, x2, #0xe20
 1088600: 97ffd8da     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 1088604: 797e73f9     	ldrh	w25, [sp, #0x1f38]
 1088608: 35001c99     	cbnz	w25,  <L165>
 108860c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088610: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 1088614: f94f7bf6     	ldr	x22, [sp, #0x1ef0]
 1088618: f94f7ff4     	ldr	x20, [sp, #0x1ef8]
 108861c: 913d0000     	add	x0, x0, #0xf40
 1088620: 91394042     	add	x2, x2, #0xe50
 1088624: 2a1503e1     	mov	w1, w21
 1088628: 97ffd8d0     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 108862c: 797f33f9     	ldrh	w25, [sp, #0x1f98]
 1088630: f94047e2     	ldr	x2, [sp, #0x88]
 1088634: 35001bb9     	cbnz	w25,  <L167>
 1088638: 3dc1bb60     	ldr	q0, [x27, #0x6e0]
 108863c: 3dc1c361     	ldr	q1, [x27, #0x700]
 1088640: 91122268     	add	x8, x19, #0x488
 1088644: 3dc1c762     	ldr	q2, [x27, #0x710]
 1088648: f94fcbe9     	ldr	x9, [sp, #0x1f90]
 108864c: f9022276     	str	x22, [x19, #0x440]
 1088650: 3d810e60     	str	q0, [x19, #0x430]
 1088654: 3dc1cb60     	ldr	q0, [x27, #0x720]
 1088658: 3d811661     	str	q1, [x19, #0x450]
 108865c: 3dc1db61     	ldr	q1, [x27, #0x760]
 1088660: 3d811e60     	str	q0, [x19, #0x470]
 1088664: 3dc1df60     	ldr	q0, [x27, #0x770]
 1088668: 3d811a62     	str	q2, [x19, #0x460]
 108866c: 3dc1e362     	ldr	q2, [x27, #0x780]
 1088670: ad010101     	stp	q1, q0, [x8, #0x20]
 1088674: 3dc1d360     	ldr	q0, [x27, #0x740]
 1088678: 3dc1d761     	ldr	q1, [x27, #0x750]
 108867c: 3d801102     	str	q2, [x8, #0x40]
 1088680: ad000500     	stp	q0, q1, [x8]
 1088684: 6f00e400     	movi	v0.2d, #0000000000000000
 1088688: f94f9be8     	ldr	x8, [sp, #0x1f30]
 108868c: f9022674     	str	x20, [x19, #0x448]
 1088690: f9024268     	str	x8, [x19, #0x480]
 1088694: f9026e69     	str	x9, [x19, #0x4d8]
 1088698: 3d819f60     	str	q0, [x27, #0x670]
 108869c: 3d819b60     	str	q0, [x27, #0x660]
 10886a0: 3d819760     	str	q0, [x27, #0x650]
 10886a4: 3d819360     	str	q0, [x27, #0x640]
 10886a8: 3d818f60     	str	q0, [x27, #0x630]
 10886ac: 3d818b60     	str	q0, [x27, #0x620]
 10886b0: 14000069     	b	 <L157>
<L156>:
 10886b4: ad4a0660     	ldp	q0, q1, [x19, #0x140]
 10886b8: 91400be0     	add	x0, sp, #0x2, lsl #12   // =0x2000
 10886bc: 3dc05a62     	ldr	q2, [x19, #0x160]
 10886c0: 914007e1     	add	x1, sp, #0x1, lsl #12   // =0x1000
 10886c4: 91044000     	add	x0, x0, #0x110
 10886c8: 9131c021     	add	x1, x1, #0xc70
 10886cc: ad020720     	stp	q0, q1, [x25, #0x40]
 10886d0: ad480660     	ldp	q0, q1, [x19, #0x100]
 10886d4: 3d801b22     	str	q2, [x25, #0x60]
 10886d8: ad000720     	stp	q0, q1, [x25]
 10886dc: ad490a60     	ldp	q0, q2, [x19, #0x120]
 10886e0: ad010b20     	stp	q0, q2, [x25, #0x20]
 10886e4: 940065e6     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10886e8: 3dc00340     	ldr	q0, [x26]
 10886ec: 52840015     	mov	w21, #0x2000            // =8192
 10886f0: 52800257     	mov	w23, #0x12              // =18
 10886f4: 528c6d38     	mov	w24, #0x6369            // =25449
 10886f8: 91400bfa     	add	x26, sp, #0x2, lsl #12  // =0x2000
 10886fc: 3dc12361     	ldr	q1, [x27, #0x480]
 1088700: 3c803320     	stur	q0, [x25, #0x3]
 1088704: 3dc11f60     	ldr	q0, [x27, #0x470]
 1088708: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108870c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1088710: 79000335     	strh	w21, [x25]
 1088714: 9104435a     	add	x26, x26, #0x110
 1088718: 39000b37     	strb	w23, [x25, #0x2]
 108871c: 91324000     	add	x0, x0, #0xc90
 1088720: 91044042     	add	x2, x2, #0x110
 1088724: 78013338     	sturh	w24, [x25, #0x13]
 1088728: 52800419     	mov	w25, #0x20              // =32
 108872c: 52800401     	mov	w1, #0x20               // =32
 1088730: 528006c3     	mov	w3, #0x36               // =54
 1088734: aa1603e4     	mov	x4, x22
 1088738: 39005759     	strb	w25, [x26, #0x15]
 108873c: 3c816340     	stur	q0, [x26, #0x16]
 1088740: 3c826341     	stur	q1, [x26, #0x26]
 1088744: 9400645a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088748: b0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 108874c: 913b6d08     	add	x8, x8, #0xedb
 1088750: 3dc12361     	ldr	q1, [x27, #0x480]
 1088754: 3dc00100     	ldr	q0, [x8]
 1088758: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108875c: 91400be2     	add	x2, sp, #0x2, lsl #12   // =0x2000
 1088760: 9132c000     	add	x0, x0, #0xcb0
 1088764: 91044042     	add	x2, x2, #0x110
 1088768: 52800401     	mov	w1, #0x20               // =32
 108876c: 3c803340     	stur	q0, [x26, #0x3]
 1088770: 3dc11f60     	ldr	q0, [x27, #0x470]
 1088774: 528006c3     	mov	w3, #0x36               // =54
 1088778: aa1603e4     	mov	x4, x22
 108877c: 79000355     	strh	w21, [x26]
 1088780: 39000b57     	strb	w23, [x26, #0x2]
 1088784: 78013358     	sturh	w24, [x26, #0x13]
 1088788: 39005759     	strb	w25, [x26, #0x15]
 108878c: 3c816340     	stur	q0, [x26, #0x16]
 1088790: 3c826341     	stur	q1, [x26, #0x26]
 1088794: 94006446     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 1088798: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 108879c: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10887a0: 2a1403e1     	mov	w1, w20
 10887a4: 9134c000     	add	x0, x0, #0xd30
 10887a8: 91324042     	add	x2, x2, #0xc90
 10887ac: 97ffd8fe     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10887b0: 797b13f9     	ldrh	w25, [sp, #0x1d88]
 10887b4: 35000f79     	cbnz	w25,  <L166>
 10887b8: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 10887bc: 914007e2     	add	x2, sp, #0x1, lsl #12   // =0x1000
 10887c0: f94ea3f6     	ldr	x22, [sp, #0x1d40]
 10887c4: f94ea7f5     	ldr	x21, [sp, #0x1d48]
 10887c8: 91364000     	add	x0, x0, #0xd90
 10887cc: 9132c042     	add	x2, x2, #0xcb0
 10887d0: 2a1403e1     	mov	w1, w20
 10887d4: 97ffd8f4     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10887d8: 797bd3f9     	ldrh	w25, [sp, #0x1de8]
 10887dc: f94047e2     	ldr	x2, [sp, #0x88]
 10887e0: 350010d9     	cbnz	w25,  <L169>
 10887e4: 3dc14f60     	ldr	q0, [x27, #0x530]
 10887e8: 3dc15761     	ldr	q1, [x27, #0x550]
 10887ec: 91122268     	add	x8, x19, #0x488
 10887f0: 3dc15b62     	ldr	q2, [x27, #0x560]
 10887f4: f94ef3e9     	ldr	x9, [sp, #0x1de0]
 10887f8: f9022276     	str	x22, [x19, #0x440]
 10887fc: 3d810e60     	str	q0, [x19, #0x430]
 1088800: 3dc15f60     	ldr	q0, [x27, #0x570]
 1088804: 3d811661     	str	q1, [x19, #0x450]
 1088808: 3dc16f61     	ldr	q1, [x27, #0x5b0]
 108880c: 3d811e60     	str	q0, [x19, #0x470]
 1088810: 3dc17360     	ldr	q0, [x27, #0x5c0]
 1088814: 3d811a62     	str	q2, [x19, #0x460]
 1088818: 3dc17762     	ldr	q2, [x27, #0x5d0]
 108881c: ad010101     	stp	q1, q0, [x8, #0x20]
 1088820: 3dc16760     	ldr	q0, [x27, #0x590]
 1088824: 3dc16b61     	ldr	q1, [x27, #0x5a0]
 1088828: 3d801102     	str	q2, [x8, #0x40]
 108882c: ad000500     	stp	q0, q1, [x8]
 1088830: 6f00e400     	movi	v0.2d, #0000000000000000
 1088834: f94ec3e8     	ldr	x8, [sp, #0x1d80]
 1088838: f9022675     	str	x21, [x19, #0x448]
 108883c: f9024268     	str	x8, [x19, #0x480]
 1088840: f9026e69     	str	x9, [x19, #0x4d8]
 1088844: 3d813360     	str	q0, [x27, #0x4c0]
 1088848: 3d812f60     	str	q0, [x27, #0x4b0]
 108884c: 3d812b60     	str	q0, [x27, #0x4a0]
 1088850: 3d812760     	str	q0, [x27, #0x490]
<L157>:
 1088854: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088858: 2a1f03e1     	mov	w1, wzr
 108885c: 9116c000     	add	x0, x0, #0x5b0
 1088860: 940551d8     	bl	 <memset>
 1088864: f9404be8     	ldr	x8, [sp, #0x90]
 1088868: f9403bea     	ldr	x10, [sp, #0x70]
 108886c: 39400108     	ldrb	w8, [x8]
 1088870: 360000c8     	tbz	w8, #0x0,  <L158>
 1088874: 3954e268     	ldrb	w8, [x19, #0x538]
 1088878: 35000088     	cbnz	w8,  <L158>
 108887c: 52800028     	mov	w8, #0x1                // =1
 1088880: b905767f     	str	wzr, [x19, #0x574]
 1088884: 39290b88     	strb	w8, [x28, #0xa42]
<L158>:
 1088888: 6f00e400     	movi	v0.2d, #0000000000000000
 108888c: f94033e9     	ldr	x9, [sp, #0x60]
 1088890: 52800028     	mov	w8, #0x1                // =1
 1088894: 39000128     	strb	w8, [x9]
 1088898: 911683e8     	add	x8, sp, #0x5a0
 108889c: 3d820900     	str	q0, [x8, #0x820]
 10888a0: 3d820d00     	str	q0, [x8, #0x830]
 10888a4: 3d821100     	str	q0, [x8, #0x840]
 10888a8: 3d821500     	str	q0, [x8, #0x850]
 10888ac: 3d821900     	str	q0, [x8, #0x860]
 10888b0: f9405be9     	ldr	x9, [sp, #0xb0]
 10888b4: f94053e8     	ldr	x8, [sp, #0xa0]
 10888b8: 7900213f     	strh	wzr, [x9, #0x10]
 10888bc: a9002928     	stp	x8, x10, [x9]
 10888c0: 17fff725     	b	 <L6>
<L159>:
 10888c4: 528000f9     	mov	w25, #0x7               // =7
<L160>:
 10888c8: 6f00e400     	movi	v0.2d, #0000000000000000
 10888cc: 911683e9     	add	x9, sp, #0x5a0
 10888d0: 3d821920     	str	q0, [x9, #0x860]
 10888d4: 3d821520     	str	q0, [x9, #0x850]
 10888d8: 3d821120     	str	q0, [x9, #0x840]
 10888dc: 3d820d20     	str	q0, [x9, #0x830]
 10888e0: 3d820920     	str	q0, [x9, #0x820]
 10888e4: 79002119     	strh	w25, [x8, #0x10]
 10888e8: 17fff71b     	b	 <L6>
<L161>:
 10888ec: b0fffc0c     	adrp	x12, 0x1009000 <__anon_51029+0x9c0>
 10888f0: 795d618c     	ldrh	w12, [x12, #0xeb0]
 10888f4: 7104019f     	cmp	w12, #0x100
 10888f8: 540002c3     	b.lo	 <L162>
 10888fc: 1200156b     	and	w11, w11, #0x3f
 1088900: 9240098c     	and	x12, x12, #0x7
 1088904: 1acc256b     	lsr	w11, w11, w12
 1088908: 3600024b     	tbz	w11, #0x0,  <L162>
 108890c: 3948f74b     	ldrb	w11, [x26, #0x23d]
 1088910: 3400020b     	cbz	w11,  <L162>
 1088914: f94133e5     	ldr	x5, [sp, #0x260]
 1088918: f94137e6     	ldr	x6, [sp, #0x268]
 108891c: 5280030a     	mov	w10, #0x18              // =24
 1088920: 913b63e0     	add	x0, sp, #0xed8
 1088924: 910f83e4     	add	x4, sp, #0x3e0
 1088928: aa1303e1     	mov	x1, x19
 108892c: 2a1403e7     	mov	w7, w20
 1088930: a900a7e8     	stp	x8, x9, [sp, #0x8]
 1088934: 790003ea     	strh	w10, [sp]
 1088938: 94007a2d     	bl	 <ServerHandshake.encodeHelloRetryRequest>
 108893c: 795dd3e8     	ldrh	w8, [sp, #0xee8]
 1088940: 350001c8     	cbnz	w8,  <L164>
 1088944: f9476ff4     	ldr	x20, [sp, #0xed8]
 1088948: f94773f5     	ldr	x21, [sp, #0xee0]
 108894c: 17fffa4d     	b	 <L89>
<L162>:
 1088950: 6f00e400     	movi	v0.2d, #0000000000000000
 1088954: 911683eb     	add	x11, sp, #0x5a0
 1088958: b0fffc08     	adrp	x8, 0x1009000 <__anon_51029+0x9c0>
 108895c: 910d0108     	add	x8, x8, #0x340
 1088960: 52800909     	mov	w9, #0x48               // =72
 1088964: 17fffa7a     	b	 <L94>
<L163>:
 1088968: f9405be8     	ldr	x8, [sp, #0xb0]
 108896c: 52800949     	mov	w9, #0x4a               // =74
 1088970: 79002109     	strh	w9, [x8, #0x10]
 1088974: 17fff6f8     	b	 <L6>
<L164>:
 1088978: 6f00e400     	movi	v0.2d, #0000000000000000
 108897c: 911683e9     	add	x9, sp, #0x5a0
 1088980: 3d821920     	str	q0, [x9, #0x860]
 1088984: 3d821520     	str	q0, [x9, #0x850]
 1088988: 3d821120     	str	q0, [x9, #0x840]
 108898c: 3d820d20     	str	q0, [x9, #0x830]
 1088990: 3d820920     	str	q0, [x9, #0x820]
 1088994: 14000038     	b	 <L174>
<L165>:
 1088998: 6f00e400     	movi	v0.2d, #0000000000000000
 108899c: 14000010     	b	 <L168>
<L166>:
 10889a0: 6f00e400     	movi	v0.2d, #0000000000000000
 10889a4: 14000022     	b	 <L170>
<L167>:
 10889a8: aa1603e0     	mov	x0, x22
 10889ac: 94055235     	bl	 <EVP_CIPHER_CTX_free@plt>
 10889b0: aa1403e0     	mov	x0, x20
 10889b4: 94055233     	bl	 <EVP_CIPHER_CTX_free@plt>
 10889b8: 6f00e400     	movi	v0.2d, #0000000000000000
 10889bc: f90f6fff     	str	xzr, [sp, #0x1ed8]
 10889c0: f90f6bff     	str	xzr, [sp, #0x1ed0]
 10889c4: f90f67ff     	str	xzr, [sp, #0x1ec8]
 10889c8: f90f63ff     	str	xzr, [sp, #0x1ec0]
 10889cc: f90f5bff     	str	xzr, [sp, #0x1eb0]
 10889d0: 3d81ab60     	str	q0, [x27, #0x6a0]
 10889d4: 3d81a760     	str	q0, [x27, #0x690]
 10889d8: 3d81a360     	str	q0, [x27, #0x680]
<L168>:
 10889dc: 3d819f60     	str	q0, [x27, #0x670]
 10889e0: 3d819b60     	str	q0, [x27, #0x660]
 10889e4: 3d819760     	str	q0, [x27, #0x650]
 10889e8: 3d819360     	str	q0, [x27, #0x640]
 10889ec: 3d818f60     	str	q0, [x27, #0x630]
 10889f0: 3d818b60     	str	q0, [x27, #0x620]
 10889f4: 14000012     	b	 <L171>
<L169>:
 10889f8: aa1603e0     	mov	x0, x22
 10889fc: 94055221     	bl	 <EVP_CIPHER_CTX_free@plt>
 1088a00: aa1503e0     	mov	x0, x21
 1088a04: 9405521f     	bl	 <EVP_CIPHER_CTX_free@plt>
 1088a08: 6f00e400     	movi	v0.2d, #0000000000000000
 1088a0c: f90e97ff     	str	xzr, [sp, #0x1d28]
 1088a10: f90e93ff     	str	xzr, [sp, #0x1d20]
 1088a14: f90e8fff     	str	xzr, [sp, #0x1d18]
 1088a18: f90e8bff     	str	xzr, [sp, #0x1d10]
 1088a1c: f90e83ff     	str	xzr, [sp, #0x1d00]
 1088a20: 3d813f60     	str	q0, [x27, #0x4f0]
 1088a24: 3d813b60     	str	q0, [x27, #0x4e0]
 1088a28: 3d813760     	str	q0, [x27, #0x4d0]
<L170>:
 1088a2c: 3d813360     	str	q0, [x27, #0x4c0]
 1088a30: 3d812f60     	str	q0, [x27, #0x4b0]
 1088a34: 3d812b60     	str	q0, [x27, #0x4a0]
 1088a38: 3d812760     	str	q0, [x27, #0x490]
<L171>:
 1088a3c: 914007e0     	add	x0, sp, #0x1, lsl #12   // =0x1000
 1088a40: f94047e2     	ldr	x2, [sp, #0x88]
 1088a44: 2a1f03e1     	mov	w1, wzr
 1088a48: 9116c000     	add	x0, x0, #0x5b0
 1088a4c: 9405515d     	bl	 <memset>
<L172>:
 1088a50: f9405be8     	ldr	x8, [sp, #0xb0]
 1088a54: 17ffff9d     	b	 <L160>
<L173>:
 1088a58: 6f00e400     	movi	v0.2d, #0000000000000000
 1088a5c: 911683e9     	add	x9, sp, #0x5a0
 1088a60: 3d820920     	str	q0, [x9, #0x820]
 1088a64: 3d820d20     	str	q0, [x9, #0x830]
 1088a68: 3d821120     	str	q0, [x9, #0x840]
 1088a6c: 3d821520     	str	q0, [x9, #0x850]
 1088a70: 3d821920     	str	q0, [x9, #0x860]
<L174>:
 1088a74: f9405be9     	ldr	x9, [sp, #0xb0]
 1088a78: 79002128     	strh	w8, [x9, #0x10]
 1088a7c: 17fff6b6     	b	 <L6>
<L175>:
 1088a80: 6f00e400     	movi	v0.2d, #0000000000000000
 1088a84: 911683e8     	add	x8, sp, #0x5a0
 1088a88: 3d821900     	str	q0, [x8, #0x860]
 1088a8c: 3d821500     	str	q0, [x8, #0x850]
 1088a90: 3d821100     	str	q0, [x8, #0x840]
 1088a94: 3d820d00     	str	q0, [x8, #0x830]
 1088a98: 3d820900     	str	q0, [x8, #0x820]
 1088a9c: f9405be8     	ldr	x8, [sp, #0xb0]
 1088aa0: 79002100     	strh	w0, [x8, #0x10]
 1088aa4: 17fff6ac     	b	 <L6>
