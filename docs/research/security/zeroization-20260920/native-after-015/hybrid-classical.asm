
/Users/matt/code/ztls/zig-out/memory.nhT2u8/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010a5890 <hybrid_kex.deriveClassicalSecret>:
 10a5890: d10403ff     	sub	sp, sp, #0x100
 10a5894: a90e7bfd     	stp	x29, x30, [sp, #0xe0]
 10a5898: f9007bf3     	str	x19, [sp, #0xf0]
 10a589c: 910383fd     	add	x29, sp, #0xe0
 10a58a0: 12003c28     	and	w8, w1, #0xffff
 10a58a4: 71005d1f     	cmp	w8, #0x17
 10a58a8: 54000420     	b.eq	 <L0>
 10a58ac: 7100611f     	cmp	w8, #0x18
 10a58b0: 54000601     	b.ne	 <L1>
 10a58b4: f101849f     	cmp	x4, #0x61
 10a58b8: 54000821     	b.ne	 <L3>
 10a58bc: 39400068     	ldrb	w8, [x3]
 10a58c0: 7100111f     	cmp	w8, #0x4
 10a58c4: 540007c1     	b.ne	 <L3>
 10a58c8: 3944c848     	ldrb	w8, [x2, #0x132]
 10a58cc: 34000888     	cbz	w8,  <L4>
 10a58d0: ad420460     	ldp	q0, q1, [x3, #0x40]
 10a58d4: aa0003f3     	mov	x19, x0
 10a58d8: 39418068     	ldrb	w8, [x3, #0x60]
 10a58dc: 91028440     	add	x0, x2, #0xa1
 10a58e0: 9101c3e1     	add	x1, sp, #0x70
 10a58e4: aa0503e2     	mov	x2, x5
 10a58e8: ad0587e0     	stp	q0, q1, [sp, #0xb0]
 10a58ec: ad400460     	ldp	q0, q1, [x3]
 10a58f0: 390343e8     	strb	w8, [sp, #0xd0]
 10a58f4: ad0387e0     	stp	q0, q1, [sp, #0x70]
 10a58f8: ad410860     	ldp	q0, q2, [x3, #0x20]
 10a58fc: ad048be0     	stp	q0, q2, [sp, #0x90]
 10a5900: 97ff7134     	bl	 <p384.sharedSecret>
 10a5904: 72003c1f     	tst	w0, #0xffff
 10a5908: 540007a1     	b.ne	 <L5>
 10a590c: f0fffae8     	adrp	x8, 0x1004000 <__anon_415810+0x110>
 10a5910: 912e8108     	add	x8, x8, #0xba0
 10a5914: 3dc00100     	ldr	q0, [x8]
 10a5918: 3d800260     	str	q0, [x19]
 10a591c: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 10a5920: f9407bf3     	ldr	x19, [sp, #0xf0]
 10a5924: 910403ff     	add	sp, sp, #0x100
 10a5928: d65f03c0     	ret
<L0>:
 10a592c: f101049f     	cmp	x4, #0x41
 10a5930: 54000461     	b.ne	 <L3>
 10a5934: 39400068     	ldrb	w8, [x3]
 10a5938: 7100111f     	cmp	w8, #0x4
 10a593c: 54000401     	b.ne	 <L3>
 10a5940: ad410460     	ldp	q0, q1, [x3, #0x20]
 10a5944: aa0003f3     	mov	x19, x0
 10a5948: 39410068     	ldrb	w8, [x3, #0x40]
 10a594c: 91010040     	add	x0, x2, #0x40
 10a5950: 910083e1     	add	x1, sp, #0x20
 10a5954: aa0503e2     	mov	x2, x5
 10a5958: ad0207e0     	stp	q0, q1, [sp, #0x40]
 10a595c: ad400061     	ldp	q1, q0, [x3]
 10a5960: 390183e8     	strb	w8, [sp, #0x60]
 10a5964: ad0103e1     	stp	q1, q0, [sp, #0x20]
 10a5968: 97ff70db     	bl	 <p256.sharedSecret>
 10a596c: 1400000a     	b	 <L2>
<L1>:
 10a5970: f100809f     	cmp	x4, #0x20
 10a5974: 54000241     	b.ne	 <L3>
 10a5978: ad400460     	ldp	q0, q1, [x3]
 10a597c: aa0003f3     	mov	x19, x0
 10a5980: 910003e1     	mov	x1, sp
 10a5984: aa0203e0     	mov	x0, x2
 10a5988: aa0503e2     	mov	x2, x5
 10a598c: ad0007e0     	stp	q0, q1, [sp]
 10a5990: 97ff707a     	bl	 <x25519.sharedSecret>
<L2>:
 10a5994: 72003c1f     	tst	w0, #0xffff
 10a5998: 54000321     	b.ne	 <L5>
 10a599c: f0fffae8     	adrp	x8, 0x1004000 <__anon_415810+0x110>
 10a59a0: 91170108     	add	x8, x8, #0x5c0
 10a59a4: 3dc00100     	ldr	q0, [x8]
 10a59a8: 3d800260     	str	q0, [x19]
 10a59ac: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 10a59b0: f9407bf3     	ldr	x19, [sp, #0xf0]
 10a59b4: 910403ff     	add	sp, sp, #0x100
 10a59b8: d65f03c0     	ret
<L3>:
 10a59bc: f0fffae8     	adrp	x8, 0x1004000 <__anon_415810+0x110>
 10a59c0: 911a0108     	add	x8, x8, #0x680
 10a59c4: 3dc00100     	ldr	q0, [x8]
 10a59c8: 3d800000     	str	q0, [x0]
 10a59cc: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 10a59d0: f9407bf3     	ldr	x19, [sp, #0xf0]
 10a59d4: 910403ff     	add	sp, sp, #0x100
 10a59d8: d65f03c0     	ret
<L4>:
 10a59dc: d0fffae8     	adrp	x8, 0x1003000 <writev+0x1003000>
 10a59e0: 91314108     	add	x8, x8, #0xc50
 10a59e4: 3dc00100     	ldr	q0, [x8]
 10a59e8: 3d800000     	str	q0, [x0]
 10a59ec: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 10a59f0: f9407bf3     	ldr	x19, [sp, #0xf0]
 10a59f4: 910403ff     	add	sp, sp, #0x100
 10a59f8: d65f03c0     	ret
<L5>:
 10a59fc: 79001260     	strh	w0, [x19, #0x8]
 10a5a00: a94e7bfd     	ldp	x29, x30, [sp, #0xe0]
 10a5a04: f9407bf3     	ldr	x19, [sp, #0xf0]
 10a5a08: 910403ff     	add	sp, sp, #0x100
 10a5a0c: d65f03c0     	ret
