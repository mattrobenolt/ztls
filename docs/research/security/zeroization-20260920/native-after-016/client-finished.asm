
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010e2fc8 <ClientHandshake.clientFinished>:
 10e2fc8: a9ba7bfd     	stp	x29, x30, [sp, #-0x60]!
 10e2fcc: a9016ffc     	stp	x28, x27, [sp, #0x10]
 10e2fd0: a90267fa     	stp	x26, x25, [sp, #0x20]
 10e2fd4: a9035ff8     	stp	x24, x23, [sp, #0x30]
 10e2fd8: a90457f6     	stp	x22, x21, [sp, #0x40]
 10e2fdc: a9054ff4     	stp	x20, x19, [sp, #0x50]
 10e2fe0: 910003fd     	mov	x29, sp
 10e2fe4: d14013ff     	sub	sp, sp, #0x4, lsl #12   // =0x4000
 10e2fe8: d12c83ff     	sub	sp, sp, #0xb20
 10e2fec: 39746028     	ldrb	w8, [x1, #0xd18]
 10e2ff0: 52800069     	mov	w9, #0x3                // =3
 10e2ff4: 6a28013f     	bics	wzr, w9, w8
 10e2ff8: 54000200     	b.eq	 <L2>
<L0>:
 10e2ffc: f0fff948     	adrp	x8, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10e3000: 913d2108     	add	x8, x8, #0xf48
 10e3004: 3dc00100     	ldr	q0, [x8]
 10e3008: 52800b88     	mov	w8, #0x5c               // =92
 10e300c: f9000808     	str	x8, [x0, #0x10]
 10e3010: 3d800000     	str	q0, [x0]
<L1>:
 10e3014: 914013ff     	add	sp, sp, #0x4, lsl #12   // =0x4000
 10e3018: 912c83ff     	add	sp, sp, #0xb20
 10e301c: a9454ff4     	ldp	x20, x19, [sp, #0x50]
 10e3020: a94457f6     	ldp	x22, x21, [sp, #0x40]
 10e3024: a9435ff8     	ldp	x24, x23, [sp, #0x30]
 10e3028: a94267fa     	ldp	x26, x25, [sp, #0x20]
 10e302c: a9416ffc     	ldp	x28, x27, [sp, #0x10]
 10e3030: a8c67bfd     	ldp	x29, x30, [sp], #0x60
 10e3034: d65f03c0     	ret
<L2>:
 10e3038: 39765028     	ldrb	w8, [x1, #0xd94]
 10e303c: aa0103f3     	mov	x19, x1
 10e3040: 34fffde8     	cbz	w8,  <L0>
 10e3044: 39758668     	ldrb	w8, [x19, #0xd61]
 10e3048: 914013fb     	add	x27, sp, #0x4, lsl #12  // =0x4000
 10e304c: a9028fe2     	stp	x2, x3, [sp, #0x28]
 10e3050: 9111c37b     	add	x27, x27, #0x470
 10e3054: f9001fe0     	str	x0, [sp, #0x38]
 10e3058: 36000448     	tbz	w8, #0x0,  <L4>
 10e305c: 394ee268     	ldrb	w8, [x19, #0x3b8]
 10e3060: 340006c8     	cbz	w8,  <L7>
 10e3064: 90fffb61     	adrp	x1, 0x104f000 <__anon_394452+0x10>
 10e3068: 910dc021     	add	x1, x1, #0x370
 10e306c: aa1303e0     	mov	x0, x19
 10e3070: 52800082     	mov	w2, #0x4                // =4
 10e3074: 94000b6a     	bl	 <ClientHandshake.Suite.update>
 10e3078: f941b268     	ldr	x8, [x19, #0x360]
 10e307c: b100051f     	cmn	x8, #0x1
 10e3080: 54000260     	b.eq	 <L3>
 10e3084: f941b669     	ldr	x9, [x19, #0x368]
 10e3088: eb09011f     	cmp	x8, x9
 10e308c: 54000202     	b.hs	 <L3>
 10e3090: f9401be8     	ldr	x8, [sp, #0x30]
 10e3094: f100651f     	cmp	x8, #0x19
 10e3098: 540001a9     	b.ls	 <L3>
 10e309c: a94297e4     	ldp	x4, x5, [sp, #0x28]
 10e30a0: 910d8275     	add	x21, x19, #0x360
 10e30a4: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e30a8: 528000a8     	mov	w8, #0x5                // =5
 10e30ac: aa1503e1     	mov	x1, x21
 10e30b0: 9127c000     	add	x0, x0, #0x9f0
 10e30b4: 528002c2     	mov	w2, #0x16               // =22
 10e30b8: 52800083     	mov	w3, #0x4                // =4
 10e30bc: b8005088     	stur	w8, [x4, #0x5]
 10e30c0: 97fedfc3     	bl	 <RecordLayer.encryptPrepared>
 10e30c4: 794b2368     	ldrh	w8, [x27, #0x590]
 10e30c8: 34006888     	cbz	w8,  <L29>
<L3>:
 10e30cc: f0fff948     	adrp	x8, 0x100e000 <__anon_394607>
 10e30d0: 910e4108     	add	x8, x8, #0x390
 10e30d4: 3dc00100     	ldr	q0, [x8]
 10e30d8: 528000a8     	mov	w8, #0x5                // =5
 10e30dc: 1400012c     	b	 <L14>
<L4>:
 10e30e0: 394ee268     	ldrb	w8, [x19, #0x3b8]
 10e30e4: 340002a8     	cbz	w8,  <L7>
 10e30e8: aa1f03fa     	mov	x26, xzr
 10e30ec: 910d8275     	add	x21, x19, #0x360
<L5>:
 10e30f0: f941ba60     	ldr	x0, [x19, #0x370]
 10e30f4: 940407b3     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e30f8: f941be60     	ldr	x0, [x19, #0x378]
 10e30fc: 940407b1     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e3100: 6f00e400     	movi	v0.2d, #0000000000000000
 10e3104: 3d8002a0     	str	q0, [x21]
 10e3108: 3d8006a0     	str	q0, [x21, #0x10]
 10e310c: 3d800aa0     	str	q0, [x21, #0x20]
 10e3110: 3d800ea0     	str	q0, [x21, #0x30]
 10e3114: 3d8012a0     	str	q0, [x21, #0x40]
 10e3118: f9002abf     	str	xzr, [x21, #0x50]
 10e311c: ad0002a0     	stp	q0, q0, [x21]
 10e3120: ad0102a0     	stp	q0, q0, [x21, #0x20]
 10e3124: ad0202a0     	stp	q0, q0, [x21, #0x40]
 10e3128: 39765668     	ldrb	w8, [x19, #0xd95]
 10e312c: 370000c8     	tbnz	w8, #0x0,  <L8>
<L6>:
 10e3130: aa1f03f5     	mov	x21, xzr
 10e3134: 1400004f     	b	 <L10>
<L7>:
 10e3138: aa1f03fa     	mov	x26, xzr
 10e313c: 39765668     	ldrb	w8, [x19, #0xd95]
 10e3140: 3607ff88     	tbz	w8, #0x0,  <L6>
<L8>:
 10e3144: 3952a268     	ldrb	w8, [x19, #0x4a8]
 10e3148: 39745e79     	ldrb	w25, [x19, #0xd17]
 10e314c: 34000668     	cbz	w8,  <L9>
 10e3150: f9423e78     	ldr	x24, [x19, #0x478]
 10e3154: f9424277     	ldr	x23, [x19, #0x480]
 10e3158: aa1a03f5     	mov	x21, x26
 10e315c: 39522268     	ldrb	w8, [x19, #0x488]
 10e3160: f9424a6c     	ldr	x12, [x19, #0x490]
 10e3164: f9424e6b     	ldr	x11, [x19, #0x498]
 10e3168: 7949427c     	ldrh	w28, [x19, #0x4a0]
 10e316c: 36003068     	tbz	w8, #0x0,  <L16>
 10e3170: 910016fa     	add	x26, x23, #0x5
 10e3174: 91002334     	add	x20, x25, #0x8
 10e3178: 8b1a0296     	add	x22, x20, x26
 10e317c: f14012df     	cmp	x22, #0x4, lsl #12      // =0x4000
 10e3180: 54006148     	b.hi	 <L26>
 10e3184: 321e57e8     	mov	w8, #0xfffffc           // =16777212
 10e3188: 52800169     	mov	w9, #0xb                // =11
 10e318c: 910103fb     	add	x27, sp, #0x40
 10e3190: 8b0802c8     	add	x8, x22, x8
 10e3194: 390103e9     	strb	w9, [sp, #0x40]
 10e3198: 91001760     	add	x0, x27, #0x5
 10e319c: d350fd09     	lsr	x9, x8, #16
 10e31a0: d348fd0a     	lsr	x10, x8, #8
 10e31a4: 91306261     	add	x1, x19, #0xc18
 10e31a8: aa1903e2     	mov	x2, x25
 10e31ac: a900afec     	stp	x12, x11, [sp, #0x8]
 10e31b0: 39010fe8     	strb	w8, [sp, #0x43]
 10e31b4: 390107e9     	strb	w9, [sp, #0x41]
 10e31b8: 39010bea     	strb	w10, [sp, #0x42]
 10e31bc: 390113f9     	strb	w25, [sp, #0x44]
 10e31c0: 940405f5     	bl	 <memcpy>
 10e31c4: d348ff49     	lsr	x9, x26, #8
 10e31c8: d350feea     	lsr	x10, x23, #16
 10e31cc: d348feeb     	lsr	x11, x23, #8
 10e31d0: 8b140374     	add	x20, x27, x20
 10e31d4: 8b190368     	add	x8, x27, x25
 10e31d8: 914013fb     	add	x27, sp, #0x4, lsl #12  // =0x4000
 10e31dc: 91000e80     	add	x0, x20, #0x3
 10e31e0: aa1803e1     	mov	x1, x24
 10e31e4: aa1703e2     	mov	x2, x23
 10e31e8: 3900151f     	strb	wzr, [x8, #0x5]
 10e31ec: 9111c37b     	add	x27, x27, #0x470
 10e31f0: 39001d1a     	strb	w26, [x8, #0x7]
 10e31f4: 39001909     	strb	w9, [x8, #0x6]
 10e31f8: 3900028a     	strb	w10, [x20]
 10e31fc: 3900068b     	strb	w11, [x20, #0x1]
 10e3200: 39000a97     	strb	w23, [x20, #0x2]
 10e3204: 940405e4     	bl	 <memcpy>
 10e3208: 8b170288     	add	x8, x20, x23
 10e320c: aa1503fa     	mov	x26, x21
 10e3210: 7800311f     	sturh	wzr, [x8, #0x3]
 10e3214: 1400031b     	b	 <L32>
<L9>:
 10e3218: 52800088     	mov	w8, #0x4                // =4
 10e321c: 52800169     	mov	w9, #0xb                // =11
 10e3220: 910103f4     	add	x20, sp, #0x40
 10e3224: 72a02008     	movk	w8, #0x100, lsl #16
 10e3228: 790083e9     	strh	w9, [sp, #0x40]
 10e322c: 91001680     	add	x0, x20, #0x5
 10e3230: 8b080328     	add	x8, x25, x8
 10e3234: 91306261     	add	x1, x19, #0xc18
 10e3238: aa1903e2     	mov	x2, x25
 10e323c: d348fd09     	lsr	x9, x8, #8
 10e3240: 39010fe8     	strb	w8, [sp, #0x43]
 10e3244: 91002335     	add	x21, x25, #0x8
 10e3248: 390113f9     	strb	w25, [sp, #0x44]
 10e324c: 39010be9     	strb	w9, [sp, #0x42]
 10e3250: 940405d1     	bl	 <memcpy>
 10e3254: 8b190288     	add	x8, x20, x25
 10e3258: 910103e1     	add	x1, sp, #0x40
 10e325c: aa1303e0     	mov	x0, x19
 10e3260: aa1503e2     	mov	x2, x21
 10e3264: 7800511f     	sturh	wzr, [x8, #0x5]
 10e3268: 39001d1f     	strb	wzr, [x8, #0x7]
 10e326c: 94000aec     	bl	 <ClientHandshake.Suite.update>
<L10>:
 10e3270: 39484268     	ldrb	w8, [x19, #0x210]
 10e3274: 910103e9     	add	x9, sp, #0x40
 10e3278: 914013fc     	add	x28, sp, #0x4, lsl #12  // =0x4000
 10e327c: 9127c39c     	add	x28, x28, #0x9f0
 10e3280: 8b150136     	add	x22, x9, x21
 10e3284: 91359277     	add	x23, x19, #0xd64
 10e3288: 12000508     	and	w8, w8, #0x3
 10e328c: 7100091f     	cmp	w8, #0x2
 10e3290: 54001481     	b.ne	 <L11>
 10e3294: ad450660     	ldp	q0, q1, [x19, #0xa0]
 10e3298: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e329c: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e32a0: 9127c000     	add	x0, x0, #0x9f0
 10e32a4: 911bc021     	add	x1, x1, #0x6f0
 10e32a8: 3d92a7e0     	str	q0, [sp, #0x4a90]
 10e32ac: ad460a60     	ldp	q0, q2, [x19, #0xc0]
 10e32b0: 3d92abe1     	str	q1, [sp, #0x4aa0]
 10e32b4: 3d92afe0     	str	q0, [sp, #0x4ab0]
 10e32b8: ad430261     	ldp	q1, q0, [x19, #0x60]
 10e32bc: 3d92b3e2     	str	q2, [sp, #0x4ac0]
 10e32c0: 3d929be0     	str	q0, [sp, #0x4a60]
 10e32c4: ad440262     	ldp	q2, q0, [x19, #0x80]
 10e32c8: 3d9297e1     	str	q1, [sp, #0x4a50]
 10e32cc: 3d92a3e0     	str	q0, [sp, #0x4a80]
 10e32d0: ad410261     	ldp	q1, q0, [x19, #0x20]
 10e32d4: 3d929fe2     	str	q2, [sp, #0x4a70]
 10e32d8: 3d928be0     	str	q0, [sp, #0x4a20]
 10e32dc: ad420262     	ldp	q2, q0, [x19, #0x40]
 10e32e0: 3d9287e1     	str	q1, [sp, #0x4a10]
 10e32e4: 3d9293e0     	str	q0, [sp, #0x4a40]
 10e32e8: ad400261     	ldp	q1, q0, [x19]
 10e32ec: 3d928fe2     	str	q2, [sp, #0x4a30]
 10e32f0: 3d927fe1     	str	q1, [sp, #0x49f0]
 10e32f4: 3d9283e0     	str	q0, [sp, #0x4a00]
 10e32f8: 97fef4f0     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 10e32fc: 5287f988     	mov	w8, #0x3fcc             // =16332
 10e3300: eb0802bf     	cmp	x21, x8
 10e3304: 54001348     	b.hi	 <L12>
 10e3308: b0fff908     	adrp	x8, 0x1004000 <__anon_17159+0x20>
 10e330c: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e3310: aa1603e0     	mov	x0, x22
 10e3314: fd446d00     	ldr	d0, [x8, #0x8d8]
 10e3318: 911bc021     	add	x1, x1, #0x6f0
 10e331c: 91044a63     	add	x3, x19, #0x112
 10e3320: 52800602     	mov	w2, #0x30               // =48
 10e3324: a900d7fa     	stp	x26, x21, [sp, #0x8]
 10e3328: 52800618     	mov	w24, #0x30              // =48
 10e332c: 0d9f8000     	st1	{ v0.s }[0], [x0], #4
 10e3330: 97ff10f8     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 10e3334: 3cce2260     	ldur	q0, [x19, #0xe2]
 10e3338: 3ccf2261     	ldur	q1, [x19, #0xf2]
 10e333c: f0fff988     	adrp	x8, 0x1016000 <__anon_413583>
 10e3340: 9114d108     	add	x8, x8, #0x534
 10e3344: 91038a79     	add	x25, x19, #0xe2
 10e3348: 528001a9     	mov	w9, #0xd                // =13
 10e334c: 3d9273e0     	str	q0, [sp, #0x49c0]
 10e3350: 90fff92a     	adrp	x10, 0x1007000 <__anon_13230+0x8>
 10e3354: 912e294a     	add	x10, x10, #0xb8a
 10e3358: 3d9277e1     	str	q1, [sp, #0x49d0]
 10e335c: ad400500     	ldp	q0, q1, [x8]
 10e3360: 3dc00b22     	ldr	q2, [x25, #0x20]
 10e3364: f940014b     	ldr	x11, [x10]
 10e3368: 39000b89     	strb	w9, [x28, #0x2]
 10e336c: f8405149     	ldur	x9, [x10, #0x5]
 10e3370: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3374: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e3378: 3c811380     	stur	q0, [x28, #0x11]
 10e337c: 3dc00900     	ldr	q0, [x8, #0x20]
 10e3380: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e3384: 52860014     	mov	w20, #0x3000            // =12288
 10e3388: 91264000     	add	x0, x0, #0x990
 10e338c: 9127c042     	add	x2, x2, #0x9f0
 10e3390: 91270084     	add	x4, x4, #0x9c0
 10e3394: 52800601     	mov	w1, #0x30               // =48
 10e3398: 52800823     	mov	w3, #0x41               // =65
 10e339c: 3d927be2     	str	q2, [sp, #0x49e0]
 10e33a0: 5280061b     	mov	w27, #0x30              // =48
 10e33a4: f800338b     	stur	x11, [x28, #0x3]
 10e33a8: 79000394     	strh	w20, [x28]
 10e33ac: f924ffe9     	str	x9, [sp, #0x49f8]
 10e33b0: 3c821381     	stur	q1, [x28, #0x21]
 10e33b4: 39004398     	strb	w24, [x28, #0x10]
 10e33b8: 3c831380     	stur	q0, [x28, #0x31]
 10e33bc: 97feea4e     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10e33c0: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e33c4: 914013e3     	add	x3, sp, #0x4, lsl #12   // =0x4000
 10e33c8: 90fff921     	adrp	x1, 0x1007000 <__anon_13230+0x8>
 10e33cc: 912be021     	add	x1, x1, #0xaf8
 10e33d0: 911c8000     	add	x0, x0, #0x720
 10e33d4: 91264063     	add	x3, x3, #0x990
 10e33d8: 52800602     	mov	w2, #0x30               // =48
 10e33dc: 97ff10cd     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384)).create>
 10e33e0: 6f00e400     	movi	v0.2d, #0000000000000000
 10e33e4: d0fff928     	adrp	x8, 0x1009000 <__anon_59474+0xa8>
 10e33e8: 910ba108     	add	x8, x8, #0x2e8
 10e33ec: 3dc00101     	ldr	q1, [x8]
 10e33f0: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e33f4: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e33f8: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e33fc: 52800258     	mov	w24, #0x12              // =18
 10e3400: 528c6d3a     	mov	w26, #0x6369            // =25449
 10e3404: 911d4000     	add	x0, x0, #0x750
 10e3408: 9127c042     	add	x2, x2, #0x9f0
 10e340c: 911c8084     	add	x4, x4, #0x720
 10e3410: 3d926fe0     	str	q0, [sp, #0x49b0]
 10e3414: 52800601     	mov	w1, #0x30               // =48
 10e3418: 528008c3     	mov	w3, #0x46               // =70
 10e341c: 3d926be0     	str	q0, [sp, #0x49a0]
 10e3420: 52800615     	mov	w21, #0x30              // =48
 10e3424: 3d9267e0     	str	q0, [sp, #0x4990]
 10e3428: 3c803381     	stur	q1, [x28, #0x3]
 10e342c: ad4006e0     	ldp	q0, q1, [x23]
 10e3430: 79000394     	strh	w20, [x28]
 10e3434: 39000b98     	strb	w24, [x28, #0x2]
 10e3438: 3c816380     	stur	q0, [x28, #0x16]
 10e343c: 3dc00ae0     	ldr	q0, [x23, #0x20]
 10e3440: 7801339a     	sturh	w26, [x28, #0x13]
 10e3444: 3c826381     	stur	q1, [x28, #0x26]
 10e3448: 3900579b     	strb	w27, [x28, #0x15]
 10e344c: 9105ca7b     	add	x27, x19, #0x172
 10e3450: 3c836380     	stur	q0, [x28, #0x36]
 10e3454: 97feea28     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10e3458: 3dd1d7e0     	ldr	q0, [sp, #0x4750]
 10e345c: 3dd1dbe1     	ldr	q1, [sp, #0x4760]
 10e3460: d0fff948     	adrp	x8, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10e3464: 911d0d08     	add	x8, x8, #0x743
 10e3468: 3dd1dfe2     	ldr	q2, [sp, #0x4770]
 10e346c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3470: ad000760     	stp	q0, q1, [x27]
 10e3474: 3dc00100     	ldr	q0, [x8]
 10e3478: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e347c: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e3480: 911e0000     	add	x0, x0, #0x780
 10e3484: 9127c042     	add	x2, x2, #0x9f0
 10e3488: 3c803380     	stur	q0, [x28, #0x3]
 10e348c: ad4002e1     	ldp	q1, q0, [x23]
 10e3490: 911c8084     	add	x4, x4, #0x720
 10e3494: 52800601     	mov	w1, #0x30               // =48
 10e3498: 528008c3     	mov	w3, #0x46               // =70
 10e349c: 3d800b62     	str	q2, [x27, #0x20]
 10e34a0: 3c826380     	stur	q0, [x28, #0x26]
 10e34a4: 3dc00ae0     	ldr	q0, [x23, #0x20]
 10e34a8: 3c816381     	stur	q1, [x28, #0x16]
 10e34ac: 79000394     	strh	w20, [x28]
 10e34b0: 39000b98     	strb	w24, [x28, #0x2]
 10e34b4: 7801339a     	sturh	w26, [x28, #0x13]
 10e34b8: 91068a7a     	add	x26, x19, #0x1a2
 10e34bc: 39005795     	strb	w21, [x28, #0x15]
 10e34c0: 3c836380     	stur	q0, [x28, #0x36]
 10e34c4: 97feea0c     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10e34c8: 3dd1e3e0     	ldr	q0, [sp, #0x4780]
 10e34cc: 3dd1e7e1     	ldr	q1, [sp, #0x4790]
 10e34d0: 3dd1ebe2     	ldr	q2, [sp, #0x47a0]
 10e34d4: 39434268     	ldrb	w8, [x19, #0xd0]
 10e34d8: ad000740     	stp	q0, q1, [x26]
 10e34dc: 3d800b42     	str	q2, [x26, #0x20]
 10e34e0: 34001b88     	cbz	w8,  <L20>
 10e34e4: 7101311f     	cmp	w8, #0x4c
 10e34e8: 54001b43     	b.lo	 <L20>
 10e34ec: 52801009     	mov	w9, #0x80               // =128
 10e34f0: 91014278     	add	x24, x19, #0x50
 10e34f4: aa1603e1     	mov	x1, x22
 10e34f8: cb080137     	sub	x23, x9, x8
 10e34fc: 8b080300     	add	x0, x24, x8
 10e3500: aa1703e2     	mov	x2, x23
 10e3504: 94040524     	bl	 <memcpy>
 10e3508: aa1303e0     	mov	x0, x19
 10e350c: aa1803e1     	mov	x1, x24
 10e3510: 97feec79     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
 10e3514: 2a1f03e8     	mov	w8, wzr
 10e3518: 3903427f     	strb	wzr, [x19, #0xd0]
 10e351c: 140000ce     	b	 <L21>
<L11>:
 10e3520: ad420660     	ldp	q0, q1, [x19, #0x40]
 10e3524: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3528: 3dc01a62     	ldr	q2, [x19, #0x60]
 10e352c: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e3530: 9127c000     	add	x0, x0, #0x9f0
 10e3534: 91134021     	add	x1, x1, #0x4d0
 10e3538: 3d928fe0     	str	q0, [sp, #0x4a30]
 10e353c: 3d9293e1     	str	q1, [sp, #0x4a40]
 10e3540: ad400660     	ldp	q0, q1, [x19]
 10e3544: 3d9297e2     	str	q2, [sp, #0x4a50]
 10e3548: 3d927fe0     	str	q0, [sp, #0x49f0]
 10e354c: ad410a60     	ldp	q0, q2, [x19, #0x20]
 10e3550: 3d9283e1     	str	q1, [sp, #0x4a00]
 10e3554: 3d928be2     	str	q2, [sp, #0x4a20]
 10e3558: 3d9287e0     	str	q0, [sp, #0x4a10]
 10e355c: 97fee931     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10e3560: 5287fb88     	mov	w8, #0x3fdc             // =16348
 10e3564: eb0802bf     	cmp	x21, x8
 10e3568: 540001a9     	b.ls	 <L15>
<L12>:
 10e356c: f0fff953     	adrp	x19, 0x100e000 <__anon_394607>
 10e3570: 910e4273     	add	x19, x19, #0x390
<L13>:
 10e3574: 910103e0     	add	x0, sp, #0x40
 10e3578: 2a1f03e1     	mov	w1, wzr
 10e357c: 52880002     	mov	w2, #0x4000             // =16384
 10e3580: 9404049c     	bl	 <memset>
 10e3584: 3dc00260     	ldr	q0, [x19]
 10e3588: f9400a68     	ldr	x8, [x19, #0x10]
<L14>:
 10e358c: f9401fe9     	ldr	x9, [sp, #0x38]
 10e3590: 3d800120     	str	q0, [x9]
 10e3594: f9000928     	str	x8, [x9, #0x10]
 10e3598: 17fffe9f     	b	 <L1>
<L15>:
 10e359c: b0fff908     	adrp	x8, 0x1004000 <__anon_17159+0x20>
 10e35a0: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e35a4: aa1603e0     	mov	x0, x22
 10e35a8: fd437900     	ldr	d0, [x8, #0x6f0]
 10e35ac: 91134021     	add	x1, x1, #0x4d0
 10e35b0: 91024a63     	add	x3, x19, #0x92
 10e35b4: 52800402     	mov	w2, #0x20               // =32
 10e35b8: f90007fa     	str	x26, [sp, #0x8]
 10e35bc: 52800414     	mov	w20, #0x20              // =32
 10e35c0: 0d9f8000     	st1	{ v0.s }[0], [x0], #4
 10e35c4: 97ff0e22     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10e35c8: 3cc72260     	ldur	q0, [x19, #0x72]
 10e35cc: 90fffb68     	adrp	x8, 0x104f000 <__anon_394452+0x10>
 10e35d0: 91054108     	add	x8, x8, #0x150
 10e35d4: 3cc82261     	ldur	q1, [x19, #0x82]
 10e35d8: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e35dc: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e35e0: 3d9273e0     	str	q0, [sp, #0x49c0]
 10e35e4: ad400102     	ldp	q2, q0, [x8]
 10e35e8: 528001a8     	mov	w8, #0xd                // =13
 10e35ec: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e35f0: 52840019     	mov	w25, #0x2000            // =8192
 10e35f4: 39160b68     	strb	w8, [x27, #0x582]
 10e35f8: 90fff928     	adrp	x8, 0x1007000 <__anon_13230+0x8>
 10e35fc: 912e2908     	add	x8, x8, #0xb8a
 10e3600: f9400109     	ldr	x9, [x8]
 10e3604: f8405108     	ldur	x8, [x8, #0x5]
 10e3608: 91264000     	add	x0, x0, #0x990
 10e360c: 9127c042     	add	x2, x2, #0x9f0
 10e3610: 91270084     	add	x4, x4, #0x9c0
 10e3614: 52800401     	mov	w1, #0x20               // =32
 10e3618: 52800623     	mov	w3, #0x31               // =49
 10e361c: 3d9277e1     	str	q1, [sp, #0x49d0]
 10e3620: 3c811382     	stur	q2, [x28, #0x11]
 10e3624: 790b0379     	strh	w25, [x27, #0x580]
 10e3628: f8003389     	stur	x9, [x28, #0x3]
 10e362c: f924ffe8     	str	x8, [sp, #0x49f8]
 10e3630: 39004394     	strb	w20, [x28, #0x10]
 10e3634: 3c821380     	stur	q0, [x28, #0x21]
 10e3638: 97fee1a4     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10e363c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3640: 914013e3     	add	x3, sp, #0x4, lsl #12   // =0x4000
 10e3644: f0fffb41     	adrp	x1, 0x104e000 <__anon_429238+0xb615>
 10e3648: 91364021     	add	x1, x1, #0xd90
 10e364c: 9113c000     	add	x0, x0, #0x4f0
 10e3650: 91264063     	add	x3, x3, #0x990
 10e3654: 52800402     	mov	w2, #0x20               // =32
 10e3658: 97ff0dfd     	bl	 <crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256)).create>
 10e365c: 6f00e400     	movi	v0.2d, #0000000000000000
 10e3660: d0fff928     	adrp	x8, 0x1009000 <__anon_59474+0xa8>
 10e3664: 910ba108     	add	x8, x8, #0x2e8
 10e3668: 3dc00101     	ldr	q1, [x8]
 10e366c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3670: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e3674: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e3678: 52800258     	mov	w24, #0x12              // =18
 10e367c: 528c6d3a     	mov	w26, #0x6369            // =25449
 10e3680: 91144000     	add	x0, x0, #0x510
 10e3684: 9127c042     	add	x2, x2, #0x9f0
 10e3688: 9113c084     	add	x4, x4, #0x4f0
 10e368c: 3d926be0     	str	q0, [sp, #0x49a0]
 10e3690: 52800401     	mov	w1, #0x20               // =32
 10e3694: 528006c3     	mov	w3, #0x36               // =54
 10e3698: 3d9267e0     	str	q0, [sp, #0x4990]
 10e369c: 3c803381     	stur	q1, [x28, #0x3]
 10e36a0: ad4006e0     	ldp	q0, q1, [x23]
 10e36a4: 79000399     	strh	w25, [x28]
 10e36a8: 39000b98     	strb	w24, [x28, #0x2]
 10e36ac: 3c816380     	stur	q0, [x28, #0x16]
 10e36b0: 7801339a     	sturh	w26, [x28, #0x13]
 10e36b4: 39005794     	strb	w20, [x28, #0x15]
 10e36b8: 3c826381     	stur	q1, [x28, #0x26]
 10e36bc: 97fee183     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10e36c0: 3dd147e0     	ldr	q0, [sp, #0x4510]
 10e36c4: d0fff948     	adrp	x8, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10e36c8: 911d0d08     	add	x8, x8, #0x743
 10e36cc: 3dd14be1     	ldr	q1, [sp, #0x4520]
 10e36d0: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e36d4: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e36d8: 3c8d2260     	stur	q0, [x19, #0xd2]
 10e36dc: 3dc00100     	ldr	q0, [x8]
 10e36e0: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e36e4: 3c8e2261     	stur	q1, [x19, #0xe2]
 10e36e8: 9114c000     	add	x0, x0, #0x530
 10e36ec: 9127c042     	add	x2, x2, #0x9f0
 10e36f0: 3c803380     	stur	q0, [x28, #0x3]
 10e36f4: ad4002e1     	ldp	q1, q0, [x23]
 10e36f8: 9113c084     	add	x4, x4, #0x4f0
 10e36fc: 52800401     	mov	w1, #0x20               // =32
 10e3700: 528006c3     	mov	w3, #0x36               // =54
 10e3704: 79000399     	strh	w25, [x28]
 10e3708: 3c816381     	stur	q1, [x28, #0x16]
 10e370c: 39000b98     	strb	w24, [x28, #0x2]
 10e3710: 7801339a     	sturh	w26, [x28, #0x13]
 10e3714: 9103ca7a     	add	x26, x19, #0xf2
 10e3718: 39005794     	strb	w20, [x28, #0x15]
 10e371c: 3c826380     	stur	q0, [x28, #0x26]
 10e3720: 97fee16a     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10e3724: 3dd14fe0     	ldr	q0, [sp, #0x4530]
 10e3728: 3dd153e1     	ldr	q1, [sp, #0x4540]
 10e372c: 3941a268     	ldrb	w8, [x19, #0x68]
 10e3730: 3c8f2260     	stur	q0, [x19, #0xf2]
 10e3734: 3d800741     	str	q1, [x26, #0x10]
 10e3738: 34001a68     	cbz	w8,  <L22>
 10e373c: 7100711f     	cmp	w8, #0x1c
 10e3740: 54001a23     	b.lo	 <L22>
 10e3744: 52800809     	mov	w9, #0x40               // =64
 10e3748: 9100a278     	add	x24, x19, #0x28
 10e374c: aa1603e1     	mov	x1, x22
 10e3750: cb080137     	sub	x23, x9, x8
 10e3754: 8b080300     	add	x0, x24, x8
 10e3758: aa1703e2     	mov	x2, x23
 10e375c: 9404048e     	bl	 <memcpy>
 10e3760: aa1303e0     	mov	x0, x19
 10e3764: aa1803e1     	mov	x1, x24
 10e3768: 97fee2dc     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
 10e376c: 2a1f03e8     	mov	w8, wzr
 10e3770: 3901a27f     	strb	wzr, [x19, #0x68]
 10e3774: 140000c5     	b	 <L23>
<L16>:
 10e3778: aa1f03fa     	mov	x26, xzr
 10e377c: b4000117     	cbz	x23,  <L18>
 10e3780: 91002308     	add	x8, x24, #0x8
 10e3784: aa1703e9     	mov	x9, x23
<L17>:
 10e3788: f841050a     	ldr	x10, [x8], #0x10
 10e378c: f1000529     	subs	x9, x9, #0x1
 10e3790: 8b0a034a     	add	x10, x26, x10
 10e3794: 9100155a     	add	x26, x10, #0x5
 10e3798: 54ffff81     	b.ne	 <L17>
<L18>:
 10e379c: 91002336     	add	x22, x25, #0x8
 10e37a0: 8b160348     	add	x8, x26, x22
 10e37a4: f140111f     	cmp	x8, #0x4, lsl #12       // =0x4000
 10e37a8: 54003008     	b.hi	 <L26>
 10e37ac: 321e57e9     	mov	w9, #0xfffffc           // =16777212
 10e37b0: 5280016a     	mov	w10, #0xb               // =11
 10e37b4: 910103f4     	add	x20, sp, #0x40
 10e37b8: 8b090108     	add	x8, x8, x9
 10e37bc: 390103ea     	strb	w10, [sp, #0x40]
 10e37c0: 91001680     	add	x0, x20, #0x5
 10e37c4: d350fd09     	lsr	x9, x8, #16
 10e37c8: d348fd0a     	lsr	x10, x8, #8
 10e37cc: 91306261     	add	x1, x19, #0xc18
 10e37d0: aa1903e2     	mov	x2, x25
 10e37d4: a900afec     	stp	x12, x11, [sp, #0x8]
 10e37d8: 39010fe8     	strb	w8, [sp, #0x43]
 10e37dc: 390107e9     	strb	w9, [sp, #0x41]
 10e37e0: 39010bea     	strb	w10, [sp, #0x42]
 10e37e4: 390113f9     	strb	w25, [sp, #0x44]
 10e37e8: 9404046b     	bl	 <memcpy>
 10e37ec: d348ff49     	lsr	x9, x26, #8
 10e37f0: 8b190288     	add	x8, x20, x25
 10e37f4: 3900151f     	strb	wzr, [x8, #0x5]
 10e37f8: 39001909     	strb	w9, [x8, #0x6]
 10e37fc: 39001d1a     	strb	w26, [x8, #0x7]
 10e3800: b40033f7     	cbz	x23,  <L31>
 10e3804: 91002318     	add	x24, x24, #0x8
 10e3808: aa1503fa     	mov	x26, x21
<L19>:
 10e380c: a97f8b01     	ldp	x1, x2, [x24, #-0x8]
 10e3810: 8b160289     	add	x9, x20, x22
 10e3814: d350fc48     	lsr	x8, x2, #16
 10e3818: d348fc4a     	lsr	x10, x2, #8
 10e381c: 39000922     	strb	w2, [x9, #0x2]
 10e3820: 39000128     	strb	w8, [x9]
 10e3824: 91000ec8     	add	x8, x22, #0x3
 10e3828: 8b080280     	add	x0, x20, x8
 10e382c: 3900052a     	strb	w10, [x9, #0x1]
 10e3830: 8b080059     	add	x25, x2, x8
 10e3834: 94040458     	bl	 <memcpy>
 10e3838: f10006f7     	subs	x23, x23, #0x1
 10e383c: 91000b36     	add	x22, x25, #0x2
 10e3840: 91004318     	add	x24, x24, #0x10
 10e3844: 78396a9f     	strh	wzr, [x20, x25]
 10e3848: 54fffe21     	b.ne	 <L19>
 10e384c: 1400018d     	b	 <L32>
<L20>:
 10e3850: aa1f03f7     	mov	x23, xzr
<L21>:
 10e3854: 91014269     	add	x9, x19, #0x50
 10e3858: 5280068a     	mov	w10, #0x34              // =52
 10e385c: f9400bf5     	ldr	x21, [sp, #0x10]
 10e3860: 8b284120     	add	x0, x9, w8, uxtw
 10e3864: cb170158     	sub	x24, x10, x23
 10e3868: 8b1702c1     	add	x1, x22, x23
 10e386c: aa1803e2     	mov	x2, x24
 10e3870: 94040449     	bl	 <memcpy>
 10e3874: 39434268     	ldrb	w8, [x19, #0xd0]
 10e3878: ad450660     	ldp	q0, q1, [x19, #0xa0]
 10e387c: a9402a69     	ldp	x9, x10, [x19]
 10e3880: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3884: 0b180108     	add	w8, w8, w24
 10e3888: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e388c: 9127c000     	add	x0, x0, #0x9f0
 10e3890: 39034268     	strb	w8, [x19, #0xd0]
 10e3894: 911ec021     	add	x1, x1, #0x7b0
 10e3898: 3d92a7e0     	str	q0, [sp, #0x4a90]
 10e389c: ad460262     	ldp	q2, q0, [x19, #0xc0]
 10e38a0: 3d92abe1     	str	q1, [sp, #0x4aa0]
 10e38a4: b100d128     	adds	x8, x9, #0x34
 10e38a8: 9a8a3549     	cinc	x9, x10, hs
 10e38ac: 3d92b3e0     	str	q0, [sp, #0x4ac0]
 10e38b0: ad430261     	ldp	q1, q0, [x19, #0x60]
 10e38b4: 3d92afe2     	str	q2, [sp, #0x4ab0]
 10e38b8: a9002668     	stp	x8, x9, [x19]
 10e38bc: 3d929be0     	str	q0, [sp, #0x4a60]
 10e38c0: ad440262     	ldp	q2, q0, [x19, #0x80]
 10e38c4: 3d9297e1     	str	q1, [sp, #0x4a50]
 10e38c8: 3d92a3e0     	str	q0, [sp, #0x4a80]
 10e38cc: ad410261     	ldp	q1, q0, [x19, #0x20]
 10e38d0: 3d929fe2     	str	q2, [sp, #0x4a70]
 10e38d4: 3d928be0     	str	q0, [sp, #0x4a20]
 10e38d8: ad420262     	ldp	q2, q0, [x19, #0x40]
 10e38dc: 3d9287e1     	str	q1, [sp, #0x4a10]
 10e38e0: 3d9293e0     	str	q0, [sp, #0x4a40]
 10e38e4: ad400261     	ldp	q1, q0, [x19]
 10e38e8: 3d928fe2     	str	q2, [sp, #0x4a30]
 10e38ec: 3d927fe1     	str	q1, [sp, #0x49f0]
 10e38f0: 3d9283e0     	str	q0, [sp, #0x4a00]
 10e38f4: 97fef371     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 10e38f8: 90fff909     	adrp	x9, 0x1003000 <writev+0x1003000>
 10e38fc: 91358129     	add	x9, x9, #0xd60
 10e3900: 3dd1efe1     	ldr	q1, [sp, #0x47b0]
 10e3904: 3dc00120     	ldr	q0, [x9]
 10e3908: 52800208     	mov	w8, #0x10               // =16
 10e390c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3910: 3c814381     	stur	q1, [x28, #0x14]
 10e3914: 3dd1f7e1     	ldr	q1, [sp, #0x47d0]
 10e3918: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e391c: 3c803380     	stur	q0, [x28, #0x3]
 10e3920: 3dd1f3e0     	ldr	q0, [sp, #0x47c0]
 10e3924: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e3928: 39000b88     	strb	w8, [x28, #0x2]
 10e392c: 52800608     	mov	w8, #0x30               // =48
 10e3930: 911f8000     	add	x0, x0, #0x7e0
 10e3934: 9127c042     	add	x2, x2, #0x9f0
 10e3938: 911c8084     	add	x4, x4, #0x720
 10e393c: 52800601     	mov	w1, #0x30               // =48
 10e3940: 52800883     	mov	w3, #0x44               // =68
 10e3944: 79000394     	strh	w20, [x28]
 10e3948: 91074a74     	add	x20, x19, #0x1d2
 10e394c: 39004f88     	strb	w8, [x28, #0x13]
 10e3950: 3c824380     	stur	q0, [x28, #0x24]
 10e3954: 3c834381     	stur	q1, [x28, #0x34]
 10e3958: 97fee8e7     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
 10e395c: 3dd1fbe0     	ldr	q0, [sp, #0x47e0]
 10e3960: 3dd1ffe1     	ldr	q1, [sp, #0x47f0]
 10e3964: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3968: 3dd203e2     	ldr	q2, [sp, #0x4800]
 10e396c: 7941c261     	ldrh	w1, [x19, #0xe0]
 10e3970: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e3974: ad000680     	stp	q0, q1, [x20]
 10e3978: ad400760     	ldp	q0, q1, [x27]
 10e397c: 3d800a82     	str	q2, [x20, #0x20]
 10e3980: 52800028     	mov	w8, #0x1                // =1
 10e3984: 91228000     	add	x0, x0, #0x8a0
 10e3988: 3dc00b62     	ldr	q2, [x27, #0x20]
 10e398c: 9121c042     	add	x2, x2, #0x870
 10e3990: 39080a68     	strb	w8, [x19, #0x202]
 10e3994: 3d921fe0     	str	q0, [sp, #0x4870]
 10e3998: 3d9223e1     	str	q1, [sp, #0x4880]
 10e399c: 3d9227e2     	str	q2, [sp, #0x4890]
 10e39a0: 97fedfc6     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 10e39a4: 914013fb     	add	x27, sp, #0x4, lsl #12  // =0x4000
 10e39a8: 9111c37b     	add	x27, x27, #0x470
 10e39ac: 79491374     	ldrh	w20, [x27, #0x488]
 10e39b0: 35003934     	cbnz	w20,  <L41>
 10e39b4: ad400740     	ldp	q0, q1, [x26]
 10e39b8: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e39bc: 3dc00b42     	ldr	q2, [x26, #0x20]
 10e39c0: 7941c261     	ldrh	w1, [x19, #0xe0]
 10e39c4: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e39c8: f9645bf7     	ldr	x23, [sp, #0x48b0]
 10e39cc: f9645ff6     	ldr	x22, [sp, #0x48b8]
 10e39d0: 9124c000     	add	x0, x0, #0x930
 10e39d4: 91240042     	add	x2, x2, #0x900
 10e39d8: 3d9243e0     	str	q0, [sp, #0x4900]
 10e39dc: 3d9247e1     	str	q1, [sp, #0x4910]
 10e39e0: 3d924be2     	str	q2, [sp, #0x4920]
 10e39e4: 97fedfb5     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).makeRecordLayer>
 10e39e8: 794a3374     	ldrh	w20, [x27, #0x518]
 10e39ec: 35003854     	cbnz	w20,  <L43>
 10e39f0: 6f00e400     	movi	v0.2d, #0000000000000000
 10e39f4: 3d802320     	str	q0, [x25, #0x80]
 10e39f8: 3d801f20     	str	q0, [x25, #0x70]
 10e39fc: 3d801b20     	str	q0, [x25, #0x60]
 10e3a00: 3d801720     	str	q0, [x25, #0x50]
 10e3a04: 3d801320     	str	q0, [x25, #0x40]
 10e3a08: 3d800f20     	str	q0, [x25, #0x30]
 10e3a0c: 3d800b20     	str	q0, [x25, #0x20]
 10e3a10: 3d800720     	str	q0, [x25, #0x10]
 10e3a14: 3d800320     	str	q0, [x25]
 10e3a18: 3dd22be1     	ldr	q1, [sp, #0x48a0]
 10e3a1c: 3dd233e2     	ldr	q2, [sp, #0x48c0]
 10e3a20: f9647be8     	ldr	x8, [sp, #0x48f0]
 10e3a24: 3dd23be3     	ldr	q3, [sp, #0x48e0]
 10e3a28: 3d9107e1     	str	q1, [sp, #0x4410]
 10e3a2c: 3dd237e1     	ldr	q1, [sp, #0x48d0]
 10e3a30: 3d90f7e2     	str	q2, [sp, #0x43d0]
 10e3a34: 3dd253e2     	ldr	q2, [sp, #0x4940]
 10e3a38: 3d90fbe1     	str	q1, [sp, #0x43e0]
 10e3a3c: 3dd24fe1     	ldr	q1, [sp, #0x4930]
 10e3a40: f92203e8     	str	x8, [sp, #0x4400]
 10e3a44: f964c3e8     	ldr	x8, [sp, #0x4980]
 10e3a48: 3d911be1     	str	q1, [sp, #0x4460]
 10e3a4c: 3dd25fe1     	ldr	q1, [sp, #0x4970]
 10e3a50: 3d8007e2     	str	q2, [sp, #0x10]
 10e3a54: 3dd25be2     	ldr	q2, [sp, #0x4960]
 10e3a58: 3d9113e1     	str	q1, [sp, #0x4440]
 10e3a5c: 3dd257e1     	ldr	q1, [sp, #0x4950]
 10e3a60: f9222be8     	str	x8, [sp, #0x4450]
 10e3a64: 52800688     	mov	w8, #0x34               // =52
 10e3a68: 3d90ffe3     	str	q3, [sp, #0x43f0]
 10e3a6c: 3d910fe2     	str	q2, [sp, #0x4430]
 10e3a70: 3d910be1     	str	q1, [sp, #0x4420]
 10e3a74: 3d91cbe0     	str	q0, [sp, #0x4720]
 10e3a78: 3d91cfe0     	str	q0, [sp, #0x4730]
 10e3a7c: 3d91d3e0     	str	q0, [sp, #0x4740]
 10e3a80: 14000073     	b	 <L24>
<L22>:
 10e3a84: aa1f03f7     	mov	x23, xzr
<L23>:
 10e3a88: 52800489     	mov	w9, #0x24               // =36
 10e3a8c: 8b284268     	add	x8, x19, w8, uxtw
 10e3a90: 8b1702c1     	add	x1, x22, x23
 10e3a94: cb170138     	sub	x24, x9, x23
 10e3a98: 9100a100     	add	x0, x8, #0x28
 10e3a9c: aa1803e2     	mov	x2, x24
 10e3aa0: 940403bd     	bl	 <memcpy>
 10e3aa4: 3941a268     	ldrb	w8, [x19, #0x68]
 10e3aa8: ad420660     	ldp	q0, q1, [x19, #0x40]
 10e3aac: f9401269     	ldr	x9, [x19, #0x20]
 10e3ab0: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3ab4: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e3ab8: 0b180108     	add	w8, w8, w24
 10e3abc: 9127c000     	add	x0, x0, #0x9f0
 10e3ac0: 91154021     	add	x1, x1, #0x550
 10e3ac4: 3901a268     	strb	w8, [x19, #0x68]
 10e3ac8: 91009128     	add	x8, x9, #0x24
 10e3acc: 3d9293e1     	str	q1, [sp, #0x4a40]
 10e3ad0: ad400a61     	ldp	q1, q2, [x19]
 10e3ad4: 3d928fe0     	str	q0, [sp, #0x4a30]
 10e3ad8: 3dc01a60     	ldr	q0, [x19, #0x60]
 10e3adc: f9001268     	str	x8, [x19, #0x20]
 10e3ae0: 3d9297e0     	str	q0, [sp, #0x4a50]
 10e3ae4: 3d927fe1     	str	q1, [sp, #0x49f0]
 10e3ae8: ad410261     	ldp	q1, q0, [x19, #0x20]
 10e3aec: 3d9283e2     	str	q2, [sp, #0x4a00]
 10e3af0: 3d928be0     	str	q0, [sp, #0x4a20]
 10e3af4: 3d9287e1     	str	q1, [sp, #0x4a10]
 10e3af8: 97fee7ca     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10e3afc: 90fff909     	adrp	x9, 0x1003000 <writev+0x1003000>
 10e3b00: 91358129     	add	x9, x9, #0xd60
 10e3b04: 3dd157e1     	ldr	q1, [sp, #0x4550]
 10e3b08: 3dc00120     	ldr	q0, [x9]
 10e3b0c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3b10: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e3b14: 914013e4     	add	x4, sp, #0x4, lsl #12   // =0x4000
 10e3b18: 52800208     	mov	w8, #0x10               // =16
 10e3b1c: 9115c000     	add	x0, x0, #0x570
 10e3b20: 3c803380     	stur	q0, [x28, #0x3]
 10e3b24: 3dd15be0     	ldr	q0, [sp, #0x4560]
 10e3b28: 9127c042     	add	x2, x2, #0x9f0
 10e3b2c: 9113c084     	add	x4, x4, #0x4f0
 10e3b30: 52800401     	mov	w1, #0x20               // =32
 10e3b34: 52800683     	mov	w3, #0x34               // =52
 10e3b38: 79000399     	strh	w25, [x28]
 10e3b3c: 39000b88     	strb	w8, [x28, #0x2]
 10e3b40: 39004f94     	strb	w20, [x28, #0x13]
 10e3b44: 91044a74     	add	x20, x19, #0x112
 10e3b48: 3c814381     	stur	q1, [x28, #0x14]
 10e3b4c: 3c824380     	stur	q0, [x28, #0x24]
 10e3b50: 97fee05e     	bl	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
 10e3b54: 3dd15fe0     	ldr	q0, [sp, #0x4570]
 10e3b58: 3dd163e1     	ldr	q1, [sp, #0x4580]
 10e3b5c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3b60: 3ccd2262     	ldur	q2, [x19, #0xd2]
 10e3b64: 7940e261     	ldrh	w1, [x19, #0x70]
 10e3b68: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e3b6c: ad000680     	stp	q0, q1, [x20]
 10e3b70: 3cce2260     	ldur	q0, [x19, #0xe2]
 10e3b74: 52800028     	mov	w8, #0x1                // =1
 10e3b78: 91184000     	add	x0, x0, #0x610
 10e3b7c: 9117c042     	add	x2, x2, #0x5f0
 10e3b80: 3904ca68     	strb	w8, [x19, #0x132]
 10e3b84: 3d917fe2     	str	q2, [sp, #0x45f0]
 10e3b88: 3d9183e0     	str	q0, [sp, #0x4600]
 10e3b8c: 97fedfcf     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10e3b90: 7943f374     	ldrh	w20, [x27, #0x1f8]
 10e3b94: 35002a94     	cbnz	w20,  <L42>
 10e3b98: ad400740     	ldp	q0, q1, [x26]
 10e3b9c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3ba0: 7940e261     	ldrh	w1, [x19, #0x70]
 10e3ba4: 914013e2     	add	x2, sp, #0x4, lsl #12   // =0x4000
 10e3ba8: f96313f7     	ldr	x23, [sp, #0x4620]
 10e3bac: f96317f6     	ldr	x22, [sp, #0x4628]
 10e3bb0: 911a4000     	add	x0, x0, #0x690
 10e3bb4: 9119c042     	add	x2, x2, #0x670
 10e3bb8: 3d919fe0     	str	q0, [sp, #0x4670]
 10e3bbc: 3d91a3e1     	str	q1, [sp, #0x4680]
 10e3bc0: 97fedfc2     	bl	 <hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).makeRecordLayer>
 10e3bc4: 7944f374     	ldrh	w20, [x27, #0x278]
 10e3bc8: 35002bd4     	cbnz	w20,  <L45>
 10e3bcc: 6f00e400     	movi	v0.2d, #0000000000000000
 10e3bd0: 3c8c2260     	stur	q0, [x19, #0xc2]
 10e3bd4: 3c8b2260     	stur	q0, [x19, #0xb2]
 10e3bd8: 3c8a2260     	stur	q0, [x19, #0xa2]
 10e3bdc: 3c892260     	stur	q0, [x19, #0x92]
 10e3be0: 3c882260     	stur	q0, [x19, #0x82]
 10e3be4: 3c872260     	stur	q0, [x19, #0x72]
 10e3be8: 3dd187e1     	ldr	q1, [sp, #0x4610]
 10e3bec: 3dd18fe2     	ldr	q2, [sp, #0x4630]
 10e3bf0: f96333e8     	ldr	x8, [sp, #0x4660]
 10e3bf4: 3dd197e3     	ldr	q3, [sp, #0x4650]
 10e3bf8: 3d9107e1     	str	q1, [sp, #0x4410]
 10e3bfc: 3dd193e1     	ldr	q1, [sp, #0x4640]
 10e3c00: 3d90f7e2     	str	q2, [sp, #0x43d0]
 10e3c04: 3dd1abe2     	ldr	q2, [sp, #0x46a0]
 10e3c08: 3d90fbe1     	str	q1, [sp, #0x43e0]
 10e3c0c: 3dd1a7e1     	ldr	q1, [sp, #0x4690]
 10e3c10: f92203e8     	str	x8, [sp, #0x4400]
 10e3c14: f96373e8     	ldr	x8, [sp, #0x46e0]
 10e3c18: 3d911be1     	str	q1, [sp, #0x4460]
 10e3c1c: 3dd1b7e1     	ldr	q1, [sp, #0x46d0]
 10e3c20: 3d8007e2     	str	q2, [sp, #0x10]
 10e3c24: 3dd1b3e2     	ldr	q2, [sp, #0x46c0]
 10e3c28: 3d9113e1     	str	q1, [sp, #0x4440]
 10e3c2c: 3dd1afe1     	ldr	q1, [sp, #0x46b0]
 10e3c30: 3d90ffe3     	str	q3, [sp, #0x43f0]
 10e3c34: f9222be8     	str	x8, [sp, #0x4450]
 10e3c38: 52800488     	mov	w8, #0x24               // =36
 10e3c3c: 3d910fe2     	str	q2, [sp, #0x4430]
 10e3c40: 3d910be1     	str	q1, [sp, #0x4420]
 10e3c44: 3d913fe0     	str	q0, [sp, #0x44f0]
 10e3c48: 3d9143e0     	str	q0, [sp, #0x4500]
<L24>:
 10e3c4c: 3dd113e0     	ldr	q0, [sp, #0x4440]
 10e3c50: 3dd107e1     	ldr	q1, [sp, #0x4410]
 10e3c54: f9622beb     	ldr	x11, [sp, #0x4450]
 10e3c58: 3dd10be2     	ldr	q2, [sp, #0x4420]
 10e3c5c: f94007fa     	ldr	x26, [sp, #0x8]
 10e3c60: 3d9127e0     	str	q0, [sp, #0x4490]
 10e3c64: 3dd10fe0     	ldr	q0, [sp, #0x4430]
 10e3c68: 3c838361     	stur	q1, [x27, #0x38]
 10e3c6c: 3dd127e1     	ldr	q1, [sp, #0x4490]
 10e3c70: f92253eb     	str	x11, [sp, #0x44a0]
 10e3c74: f9625beb     	ldr	x11, [sp, #0x44b0]
 10e3c78: 3d9123e0     	str	q0, [sp, #0x4480]
 10e3c7c: 3dd12be0     	ldr	q0, [sp, #0x44a0]
 10e3c80: 3d911fe2     	str	q2, [sp, #0x4470]
 10e3c84: 3dd123e2     	ldr	q2, [sp, #0x4480]
 10e3c88: f921d3eb     	str	x11, [sp, #0x43a0]
 10e3c8c: f96203eb     	ldr	x11, [sp, #0x4400]
 10e3c90: 3d90e7e0     	str	q0, [sp, #0x4390]
 10e3c94: 3dd11fe0     	ldr	q0, [sp, #0x4470]
 10e3c98: a942abe9     	ldp	x9, x10, [sp, #0x28]
 10e3c9c: f921a3eb     	str	x11, [sp, #0x4340]
 10e3ca0: f9415e6b     	ldr	x11, [x19, #0x2b8]
 10e3ca4: 3d90e3e1     	str	q1, [sp, #0x4380]
 10e3ca8: 3dd0fbe1     	ldr	q1, [sp, #0x43e0]
 10e3cac: 3d90dbe0     	str	q0, [sp, #0x4360]
 10e3cb0: 3dd0ffe0     	ldr	q0, [sp, #0x43f0]
 10e3cb4: b100057f     	cmn	x11, #0x1
 10e3cb8: 3d90dfe2     	str	q2, [sp, #0x4370]
 10e3cbc: 3dd0f7e2     	ldr	q2, [sp, #0x43d0]
 10e3cc0: 3d90cfe0     	str	q0, [sp, #0x4330]
 10e3cc4: 3d90cbe1     	str	q1, [sp, #0x4320]
 10e3cc8: 3d90c7e2     	str	q2, [sp, #0x4310]
 10e3ccc: 54000360     	b.eq	 <L25>
 10e3cd0: f941626c     	ldr	x12, [x19, #0x2c0]
 10e3cd4: eb0c017f     	cmp	x11, x12
 10e3cd8: 54000302     	b.hs	 <L25>
 10e3cdc: 8b150115     	add	x21, x8, x21
 10e3ce0: f14012bf     	cmp	x21, #0x4, lsl #12      // =0x4000
 10e3ce4: 540002a8     	b.hi	 <L25>
 10e3ce8: cb1a0158     	sub	x24, x10, x26
 10e3cec: 91005aa8     	add	x8, x21, #0x16
 10e3cf0: eb08031f     	cmp	x24, x8
 10e3cf4: 54000223     	b.lo	 <L25>
 10e3cf8: 8b1a0139     	add	x25, x9, x26
 10e3cfc: 910103e1     	add	x1, sp, #0x40
 10e3d00: aa1503e2     	mov	x2, x21
 10e3d04: 91001720     	add	x0, x25, #0x5
 10e3d08: 910ae274     	add	x20, x19, #0x2b8
 10e3d0c: 94040322     	bl	 <memcpy>
 10e3d10: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3d14: aa1403e1     	mov	x1, x20
 10e3d18: 528002c2     	mov	w2, #0x16               // =22
 10e3d1c: 9127c000     	add	x0, x0, #0x9f0
 10e3d20: aa1503e3     	mov	x3, x21
 10e3d24: aa1903e4     	mov	x4, x25
 10e3d28: aa1803e5     	mov	x5, x24
 10e3d2c: 97fedca8     	bl	 <RecordLayer.encryptPrepared>
 10e3d30: 79402388     	ldrh	w8, [x28, #0x10]
 10e3d34: 34000568     	cbz	w8,  <L30>
<L25>:
 10e3d38: aa1703e0     	mov	x0, x23
 10e3d3c: 940404a1     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e3d40: aa1603e0     	mov	x0, x22
 10e3d44: 9404049f     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e3d48: 6f00e400     	movi	v0.2d, #0000000000000000
 10e3d4c: f921d3ff     	str	xzr, [sp, #0x43a0]
 10e3d50: f921cfff     	str	xzr, [sp, #0x4398]
 10e3d54: f921afff     	str	xzr, [sp, #0x4358]
 10e3d58: f921abff     	str	xzr, [sp, #0x4350]
 10e3d5c: f921a3ff     	str	xzr, [sp, #0x4340]
 10e3d60: 3d90cfe0     	str	q0, [sp, #0x4330]
 10e3d64: 3d90cbe0     	str	q0, [sp, #0x4320]
 10e3d68: 3dc007e1     	ldr	q1, [sp, #0x10]
 10e3d6c: 3d90c7e0     	str	q0, [sp, #0x4310]
 10e3d70: 9e660020     	fmov	x0, d1
 10e3d74: 94040493     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e3d78: 3dc007e0     	ldr	q0, [sp, #0x10]
 10e3d7c: 4e183c00     	mov	x0, v0.d[1]
 10e3d80: 94040490     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e3d84: 6f00e400     	movi	v0.2d, #0000000000000000
 10e3d88: f921e7ff     	str	xzr, [sp, #0x43c8]
 10e3d8c: f921e3ff     	str	xzr, [sp, #0x43c0]
 10e3d90: f921dfff     	str	xzr, [sp, #0x43b8]
 10e3d94: f921dbff     	str	xzr, [sp, #0x43b0]
 10e3d98: f921cbff     	str	xzr, [sp, #0x4390]
 10e3d9c: 3d90e3e0     	str	q0, [sp, #0x4380]
 10e3da0: 3d90dfe0     	str	q0, [sp, #0x4370]
 10e3da4: 3d90dbe0     	str	q0, [sp, #0x4360]
<L26>:
 10e3da8: 910103e0     	add	x0, sp, #0x40
 10e3dac: 2a1f03e1     	mov	w1, wzr
 10e3db0: 52880002     	mov	w2, #0x4000             // =16384
 10e3db4: 9404028f     	bl	 <memset>
 10e3db8: 528000a8     	mov	w8, #0x5                // =5
 10e3dbc: f0fff949     	adrp	x9, 0x100e000 <__anon_394607>
 10e3dc0: 910e4129     	add	x9, x9, #0x390
<L27>:
 10e3dc4: 3dc00120     	ldr	q0, [x9]
<L28>:
 10e3dc8: f9401fe9     	ldr	x9, [sp, #0x38]
 10e3dcc: f9000928     	str	x8, [x9, #0x10]
 10e3dd0: 3d800120     	str	q0, [x9]
 10e3dd4: 17fffc90     	b	 <L1>
<L29>:
 10e3dd8: f964fffa     	ldr	x26, [sp, #0x49f8]
 10e3ddc: 17fffcc5     	b	 <L5>
<L30>:
 10e3de0: f964fff5     	ldr	x21, [sp, #0x49f8]
 10e3de4: aa1403e0     	mov	x0, x20
 10e3de8: 97fede4d     	bl	 <RecordLayer.deinit>
 10e3dec: 91098260     	add	x0, x19, #0x260
 10e3df0: 97fede4b     	bl	 <RecordLayer.deinit>
 10e3df4: 3dd107e0     	ldr	q0, [sp, #0x4410]
 10e3df8: 3dd0f7e1     	ldr	q1, [sp, #0x43d0]
 10e3dfc: 910b6268     	add	x8, x19, #0x2d8
 10e3e00: 3dd0fbe2     	ldr	q2, [sp, #0x43e0]
 10e3e04: f96203e9     	ldr	x9, [sp, #0x4400]
 10e3e08: 910103e0     	add	x0, sp, #0x40
 10e3e0c: 3d800280     	str	q0, [x20]
 10e3e10: 3dd0ffe0     	ldr	q0, [sp, #0x43f0]
 10e3e14: 2a1f03e1     	mov	w1, wzr
 10e3e18: ad000901     	stp	q1, q2, [x8]
 10e3e1c: 3dd11be1     	ldr	q1, [sp, #0x4460]
 10e3e20: 52880002     	mov	w2, #0x4000             // =16384
 10e3e24: 3d800900     	str	q0, [x8, #0x20]
 10e3e28: 3dc007e0     	ldr	q0, [sp, #0x10]
 10e3e2c: 8b1a02b4     	add	x20, x21, x26
 10e3e30: f9622be8     	ldr	x8, [sp, #0x4450]
 10e3e34: 3dd10be2     	ldr	q2, [sp, #0x4420]
 10e3e38: f9016677     	str	x23, [x19, #0x2c8]
 10e3e3c: ad130261     	stp	q1, q0, [x19, #0x260]
 10e3e40: 3dd113e0     	ldr	q0, [sp, #0x4440]
 10e3e44: 3dd10fe1     	ldr	q1, [sp, #0x4430]
 10e3e48: f9015a68     	str	x8, [x19, #0x2b0]
 10e3e4c: 52800108     	mov	w8, #0x8                // =8
 10e3e50: f9016a76     	str	x22, [x19, #0x2d0]
 10e3e54: f9018669     	str	x9, [x19, #0x308]
 10e3e58: ad148261     	stp	q1, q0, [x19, #0x290]
 10e3e5c: 3d80a262     	str	q2, [x19, #0x280]
 10e3e60: 3934f268     	strb	w8, [x19, #0xd3c]
 10e3e64: 94040263     	bl	 <memset>
 10e3e68: f9401fe9     	ldr	x9, [sp, #0x38]
 10e3e6c: f94017e8     	ldr	x8, [sp, #0x28]
 10e3e70: 7900213f     	strh	wzr, [x9, #0x10]
 10e3e74: a9005128     	stp	x8, x20, [x9]
 10e3e78: 17fffc67     	b	 <L1>
<L31>:
 10e3e7c: aa1503fa     	mov	x26, x21
<L32>:
 10e3e80: 910103e1     	add	x1, sp, #0x40
 10e3e84: aa1303e0     	mov	x0, x19
 10e3e88: aa1603e2     	mov	x2, x22
 10e3e8c: 940007e4     	bl	 <ClientHandshake.Suite.update>
 10e3e90: 39551a68     	ldrb	w8, [x19, #0x546]
 10e3e94: 92401908     	and	x8, x8, #0x7f
 10e3e98: 34000148     	cbz	w8,  <L34>
 10e3e9c: 914013f4     	add	x20, sp, #0x4, lsl #12  // =0x4000
 10e3ea0: 528098c9     	mov	w9, #0x4c6              // =1222
 10e3ea4: 91010294     	add	x20, x20, #0x40
<L33>:
 10e3ea8: 78696a6a     	ldrh	w10, [x19, x9]
 10e3eac: 6b1c015f     	cmp	w10, w28
 10e3eb0: 54000180     	b.eq	 <L35>
 10e3eb4: f1000508     	subs	x8, x8, #0x1
 10e3eb8: 91000929     	add	x9, x9, #0x2
 10e3ebc: 54ffff61     	b.ne	 <L33>
<L34>:
 10e3ec0: 910103e0     	add	x0, sp, #0x40
 10e3ec4: 2a1f03e1     	mov	w1, wzr
 10e3ec8: 52880002     	mov	w2, #0x4000             // =16384
 10e3ecc: 94040249     	bl	 <memset>
 10e3ed0: 52801f68     	mov	w8, #0xfb               // =251
 10e3ed4: d0fff949     	adrp	x9, 0x100d000 <crypto.25519.edwards25519.Edwards25519.basePointPc+0x928>
 10e3ed8: 91348129     	add	x9, x9, #0xd20
 10e3edc: 17ffffba     	b	 <L27>
<L35>:
 10e3ee0: 90fffaa8     	adrp	x8, 0x1037000 <__anon_1052134+0x3>
 10e3ee4: 911d3108     	add	x8, x8, #0x74c
 10e3ee8: 39484269     	ldrb	w9, [x19, #0x210]
 10e3eec: ad410500     	ldp	q0, q1, [x8, #0x20]
 10e3ef0: 12000529     	and	w9, w9, #0x3
 10e3ef4: 7100093f     	cmp	w9, #0x2
 10e3ef8: 3d901be0     	str	q0, [sp, #0x4060]
 10e3efc: ad420900     	ldp	q0, q2, [x8, #0x40]
 10e3f00: 3d901fe1     	str	q1, [sp, #0x4070]
 10e3f04: 3d9023e0     	str	q0, [sp, #0x4080]
 10e3f08: ad400101     	ldp	q1, q0, [x8]
 10e3f0c: 52800f28     	mov	w8, #0x79               // =121
 10e3f10: 3d9027e2     	str	q2, [sp, #0x4090]
 10e3f14: 7900c288     	strh	w8, [x20, #0x60]
 10e3f18: 914013e8     	add	x8, sp, #0x4, lsl #12   // =0x4000
 10e3f1c: 91010108     	add	x8, x8, #0x40
 10e3f20: 3d9013e1     	str	q1, [sp, #0x4040]
 10e3f24: 3d9017e0     	str	q0, [sp, #0x4050]
 10e3f28: 54000381     	b.ne	 <L36>
 10e3f2c: ad450660     	ldp	q0, q1, [x19, #0xa0]
 10e3f30: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3f34: 9127c000     	add	x0, x0, #0x9f0
 10e3f38: 91018901     	add	x1, x8, #0x62
 10e3f3c: 3d92a7e0     	str	q0, [sp, #0x4a90]
 10e3f40: ad460a60     	ldp	q0, q2, [x19, #0xc0]
 10e3f44: 3d92abe1     	str	q1, [sp, #0x4aa0]
 10e3f48: 3d92afe0     	str	q0, [sp, #0x4ab0]
 10e3f4c: ad430261     	ldp	q1, q0, [x19, #0x60]
 10e3f50: 3d92b3e2     	str	q2, [sp, #0x4ac0]
 10e3f54: 3d929be0     	str	q0, [sp, #0x4a60]
 10e3f58: ad440262     	ldp	q2, q0, [x19, #0x80]
 10e3f5c: 3d9297e1     	str	q1, [sp, #0x4a50]
 10e3f60: 3d92a3e0     	str	q0, [sp, #0x4a80]
 10e3f64: ad410261     	ldp	q1, q0, [x19, #0x20]
 10e3f68: 3d929fe2     	str	q2, [sp, #0x4a70]
 10e3f6c: 3d928be0     	str	q0, [sp, #0x4a20]
 10e3f70: ad420262     	ldp	q2, q0, [x19, #0x40]
 10e3f74: 3d9287e1     	str	q1, [sp, #0x4a10]
 10e3f78: 3d9293e0     	str	q0, [sp, #0x4a40]
 10e3f7c: ad400261     	ldp	q1, q0, [x19]
 10e3f80: 3d928fe2     	str	q2, [sp, #0x4a30]
 10e3f84: 3d927fe1     	str	q1, [sp, #0x49f0]
 10e3f88: 3d9283e0     	str	q0, [sp, #0x4a00]
 10e3f8c: 97fef1cb     	bl	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
 10e3f90: 52801242     	mov	w2, #0x92               // =146
 10e3f94: 14000011     	b	 <L37>
<L36>:
 10e3f98: ad420660     	ldp	q0, q1, [x19, #0x40]
 10e3f9c: 914013e0     	add	x0, sp, #0x4, lsl #12   // =0x4000
 10e3fa0: 3dc01a62     	ldr	q2, [x19, #0x60]
 10e3fa4: 9127c000     	add	x0, x0, #0x9f0
 10e3fa8: 91018901     	add	x1, x8, #0x62
 10e3fac: 3d928fe0     	str	q0, [sp, #0x4a30]
 10e3fb0: 3d9293e1     	str	q1, [sp, #0x4a40]
 10e3fb4: ad400660     	ldp	q0, q1, [x19]
 10e3fb8: 3d9297e2     	str	q2, [sp, #0x4a50]
 10e3fbc: 3d927fe0     	str	q0, [sp, #0x49f0]
 10e3fc0: ad410a60     	ldp	q0, q2, [x19, #0x20]
 10e3fc4: 3d9283e1     	str	q1, [sp, #0x4a00]
 10e3fc8: 3d928be2     	str	q2, [sp, #0x4a20]
 10e3fcc: 3d9287e0     	str	q0, [sp, #0x4a10]
 10e3fd0: 97fee694     	bl	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
 10e3fd4: 52801042     	mov	w2, #0x82               // =130
<L37>:
 10e3fd8: a940a7e0     	ldp	x0, x9, [sp, #0x8]
 10e3fdc: 914013e8     	add	x8, sp, #0x4, lsl #12   // =0x4000
 10e3fe0: 914013e1     	add	x1, sp, #0x4, lsl #12   // =0x4000
 10e3fe4: 914013e3     	add	x3, sp, #0x4, lsl #12   // =0x4000
 10e3fe8: 910b8108     	add	x8, x8, #0x2e0
 10e3fec: 91010021     	add	x1, x1, #0x40
 10e3ff0: 91038063     	add	x3, x3, #0xe0
 10e3ff4: 52804004     	mov	w4, #0x200              // =512
 10e3ff8: d63f0120     	blr	x9
 10e3ffc: 79456288     	ldrh	w8, [x20, #0x2b0]
 10e4000: d0fff957     	adrp	x23, 0x100e000 <__anon_394607>
 10e4004: 910e42f7     	add	x23, x23, #0x390
 10e4008: 340001a8     	cbz	w8,  <L39>
 10e400c: 7100151f     	cmp	w8, #0x5
 10e4010: 54000080     	b.eq	 <L38>
 10e4014: 914013f7     	add	x23, sp, #0x4, lsl #12  // =0x4000
 10e4018: 79059288     	strh	w8, [x20, #0x2c8]
 10e401c: 910be2f7     	add	x23, x23, #0x2f8
<L38>:
 10e4020: 910103e0     	add	x0, sp, #0x40
 10e4024: 2a1f03e1     	mov	w1, wzr
 10e4028: 52880002     	mov	w2, #0x4000             // =16384
 10e402c: 940401f1     	bl	 <memset>
 10e4030: 3dc002e0     	ldr	q0, [x23]
 10e4034: f9400ae8     	ldr	x8, [x23, #0x10]
 10e4038: 17fffd55     	b	 <L14>
<L39>:
 10e403c: f96177e2     	ldr	x2, [sp, #0x42e8]
 10e4040: 52880008     	mov	w8, #0x4000             // =16384
 10e4044: cb160108     	sub	x8, x8, x22
 10e4048: 91002055     	add	x21, x2, #0x8
 10e404c: eb15011f     	cmp	x8, x21
 10e4050: 54000102     	b.hs	 <L40>
 10e4054: 910103e0     	add	x0, sp, #0x40
 10e4058: 2a1f03e1     	mov	w1, wzr
 10e405c: 52880002     	mov	w2, #0x4000             // =16384
 10e4060: 940401e4     	bl	 <memset>
 10e4064: 3dc002e0     	ldr	q0, [x23]
 10e4068: 528000a8     	mov	w8, #0x5                // =5
 10e406c: 17ffff57     	b	 <L28>
<L40>:
 10e4070: 910103e8     	add	x8, sp, #0x40
 10e4074: 9100104a     	add	x10, x2, #0x4
 10e4078: 528001e9     	mov	w9, #0xf                // =15
 10e407c: 8b160117     	add	x23, x8, x22
 10e4080: d350fd48     	lsr	x8, x10, #16
 10e4084: f96173e1     	ldr	x1, [sp, #0x42e0]
 10e4088: 390002e9     	strb	w9, [x23]
 10e408c: d348fd49     	lsr	x9, x10, #8
 10e4090: 910022e0     	add	x0, x23, #0x8
 10e4094: 39000eea     	strb	w10, [x23, #0x3]
 10e4098: 53087f8a     	lsr	w10, w28, #8
 10e409c: 390006e8     	strb	w8, [x23, #0x1]
 10e40a0: d348fc48     	lsr	x8, x2, #8
 10e40a4: 39000ae9     	strb	w9, [x23, #0x2]
 10e40a8: 390012ea     	strb	w10, [x23, #0x4]
 10e40ac: 390016fc     	strb	w28, [x23, #0x5]
 10e40b0: 39001ae8     	strb	w8, [x23, #0x6]
 10e40b4: 39001ee2     	strb	w2, [x23, #0x7]
 10e40b8: 94040237     	bl	 <memcpy>
 10e40bc: aa1303e0     	mov	x0, x19
 10e40c0: aa1703e1     	mov	x1, x23
 10e40c4: aa1503e2     	mov	x2, x21
 10e40c8: 94000755     	bl	 <ClientHandshake.Suite.update>
 10e40cc: 8b1602b5     	add	x21, x21, x22
 10e40d0: 17fffc68     	b	 <L10>
<L41>:
 10e40d4: 6f00e400     	movi	v0.2d, #0000000000000000
 10e40d8: 914013f3     	add	x19, sp, #0x4, lsl #12  // =0x4000
 10e40dc: 9111c273     	add	x19, x19, #0x470
 10e40e0: 14000014     	b	 <L44>
<L42>:
 10e40e4: 6f00e400     	movi	v0.2d, #0000000000000000
 10e40e8: 914013f3     	add	x19, sp, #0x4, lsl #12  // =0x4000
 10e40ec: 9111c273     	add	x19, x19, #0x470
 10e40f0: 14000023     	b	 <L46>
<L43>:
 10e40f4: 914013f3     	add	x19, sp, #0x4, lsl #12  // =0x4000
 10e40f8: aa1703e0     	mov	x0, x23
 10e40fc: 9111c273     	add	x19, x19, #0x470
 10e4100: 940403b0     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e4104: aa1603e0     	mov	x0, x22
 10e4108: 940403ae     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e410c: 6f00e400     	movi	v0.2d, #0000000000000000
 10e4110: f92437ff     	str	xzr, [sp, #0x4868]
 10e4114: f92433ff     	str	xzr, [sp, #0x4860]
 10e4118: f9242fff     	str	xzr, [sp, #0x4858]
 10e411c: f9242bff     	str	xzr, [sp, #0x4850]
 10e4120: f92423ff     	str	xzr, [sp, #0x4840]
 10e4124: 3d920fe0     	str	q0, [sp, #0x4830]
 10e4128: 3d920be0     	str	q0, [sp, #0x4820]
 10e412c: 3d9207e0     	str	q0, [sp, #0x4810]
<L44>:
 10e4130: 3d91d3e0     	str	q0, [sp, #0x4740]
 10e4134: 3d91cfe0     	str	q0, [sp, #0x4730]
 10e4138: 3d91cbe0     	str	q0, [sp, #0x4720]
 10e413c: 14000012     	b	 <L47>
<L45>:
 10e4140: 914013f3     	add	x19, sp, #0x4, lsl #12  // =0x4000
 10e4144: aa1703e0     	mov	x0, x23
 10e4148: 9111c273     	add	x19, x19, #0x470
 10e414c: 9404039d     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e4150: aa1603e0     	mov	x0, x22
 10e4154: 9404039b     	bl	 <EVP_CIPHER_CTX_free@plt>
 10e4158: 6f00e400     	movi	v0.2d, #0000000000000000
 10e415c: f922f7ff     	str	xzr, [sp, #0x45e8]
 10e4160: f922f3ff     	str	xzr, [sp, #0x45e0]
 10e4164: f922efff     	str	xzr, [sp, #0x45d8]
 10e4168: f922ebff     	str	xzr, [sp, #0x45d0]
 10e416c: f922e3ff     	str	xzr, [sp, #0x45c0]
 10e4170: 3d916fe0     	str	q0, [sp, #0x45b0]
 10e4174: 3d916be0     	str	q0, [sp, #0x45a0]
 10e4178: 3d9167e0     	str	q0, [sp, #0x4590]
<L46>:
 10e417c: 3d9143e0     	str	q0, [sp, #0x4500]
 10e4180: 3d913fe0     	str	q0, [sp, #0x44f0]
<L47>:
 10e4184: 7100169f     	cmp	w20, #0x5
 10e4188: 54ff9f20     	b.eq	 <L12>
 10e418c: 7900b274     	strh	w20, [x19, #0x58]
 10e4190: 914013f3     	add	x19, sp, #0x4, lsl #12  // =0x4000
 10e4194: 9112e273     	add	x19, x19, #0x4b8
 10e4198: 17fffcf7     	b	 <L13>
