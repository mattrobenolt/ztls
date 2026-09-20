
/Users/matt/code/ztls/zig-out/memory.HqYLom/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010a5954 <hybrid_kex.deriveClassicalSecret>:
 10a5954: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
 10a5958: f9000bfc     	str	x28, [sp, #0x10]
 10a595c: a9024ff4     	stp	x20, x19, [sp, #0x20]
 10a5960: 910003fd     	mov	x29, sp
 10a5964: d10803ff     	sub	sp, sp, #0x200
 10a5968: 12003c28     	and	w8, w1, #0xffff
 10a596c: 71005d1f     	cmp	w8, #0x17
 10a5970: 54000660     	b.eq	 <L0>
 10a5974: 7100611f     	cmp	w8, #0x18
 10a5978: 54000901     	b.ne	 <L1>
 10a597c: f101849f     	cmp	x4, #0x61
 10a5980: 54000bc1     	b.ne	 <L4>
 10a5984: 39400068     	ldrb	w8, [x3]
 10a5988: 7100111f     	cmp	w8, #0x4
 10a598c: 54000b61     	b.ne	 <L4>
 10a5990: 3ccc1040     	ldur	q0, [x2, #0xc1]
 10a5994: 3ccd1041     	ldur	q1, [x2, #0xd1]
 10a5998: 91028448     	add	x8, x2, #0xa1
 10a599c: 3cce1042     	ldur	q2, [x2, #0xe1]
 10a59a0: 79412109     	ldrh	w9, [x8, #0x90]
 10a59a4: ad0707e0     	stp	q0, q1, [sp, #0xe0]
 10a59a8: 3ccf1040     	ldur	q0, [x2, #0xf1]
 10a59ac: 3cca1041     	ldur	q1, [x2, #0xa1]
 10a59b0: 7902a3e9     	strh	w9, [sp, #0x150]
 10a59b4: ad0803e2     	stp	q2, q0, [sp, #0x100]
 10a59b8: 3ccb1040     	ldur	q0, [x2, #0xb1]
 10a59bc: 3dc02102     	ldr	q2, [x8, #0x80]
 10a59c0: ad0603e1     	stp	q1, q0, [sp, #0xc0]
 10a59c4: ad430500     	ldp	q0, q1, [x8, #0x60]
 10a59c8: 53083d28     	ubfx	w8, w9, #8, #8
 10a59cc: 3d8053e2     	str	q2, [sp, #0x140]
 10a59d0: ad0907e0     	stp	q0, q1, [sp, #0x120]
 10a59d4: 34000a48     	cbz	w8,  <L6>
 10a59d8: ad420460     	ldp	q0, q1, [x3, #0x40]
 10a59dc: aa0003f3     	mov	x19, x0
 10a59e0: 39418068     	ldrb	w8, [x3, #0x60]
 10a59e4: d100d3a0     	sub	x0, x29, #0x34
 10a59e8: 910303e1     	add	x1, sp, #0xc0
 10a59ec: d10283a2     	sub	x2, x29, #0xa0
 10a59f0: aa0503f4     	mov	x20, x5
 10a59f4: ad3d07a0     	stp	q0, q1, [x29, #-0x60]
 10a59f8: ad400460     	ldp	q0, q1, [x3]
 10a59fc: 381c03a8     	sturb	w8, [x29, #-0x40]
 10a5a00: ad3b07a0     	stp	q0, q1, [x29, #-0xa0]
 10a5a04: ad410860     	ldp	q0, q2, [x3, #0x20]
 10a5a08: ad3c0ba0     	stp	q0, q2, [x29, #-0x80]
 10a5a0c: 97ff711c     	bl	 <p384.sharedSecret>
 10a5a10: 785cc3a8     	ldurh	w8, [x29, #-0x34]
 10a5a14: 350008a8     	cbnz	w8,  <L7>
 10a5a18: d100d3a8     	sub	x8, x29, #0x34
 10a5a1c: 3cc02100     	ldur	q0, [x8, #0x2]
 10a5a20: 3cc12101     	ldur	q1, [x8, #0x12]
 10a5a24: 3cc22102     	ldur	q2, [x8, #0x22]
 10a5a28: f0fffae8     	adrp	x8, 0x1004000 <__anon_415846+0x150>
 10a5a2c: 912d8108     	add	x8, x8, #0xb60
 10a5a30: ad000680     	stp	q0, q1, [x20]
 10a5a34: 3d800a82     	str	q2, [x20, #0x20]
 10a5a38: 14000029     	b	 <L3>
<L0>:
 10a5a3c: f101049f     	cmp	x4, #0x41
 10a5a40: 540005c1     	b.ne	 <L4>
 10a5a44: 39400068     	ldrb	w8, [x3]
 10a5a48: 7100111f     	cmp	w8, #0x4
 10a5a4c: 54000561     	b.ne	 <L4>
 10a5a50: ad410460     	ldp	q0, q1, [x3, #0x20]
 10a5a54: aa0003f3     	mov	x19, x0
 10a5a58: 39410068     	ldrb	w8, [x3, #0x40]
 10a5a5c: 910273e0     	add	x0, sp, #0x9c
 10a5a60: 91010041     	add	x1, x2, #0x40
 10a5a64: 910143e2     	add	x2, sp, #0x50
 10a5a68: aa0503f4     	mov	x20, x5
 10a5a6c: ad0387e0     	stp	q0, q1, [sp, #0x70]
 10a5a70: ad400061     	ldp	q1, q0, [x3]
 10a5a74: 390243e8     	strb	w8, [sp, #0x90]
 10a5a78: ad0283e1     	stp	q1, q0, [sp, #0x50]
 10a5a7c: 97ff70b5     	bl	 <p256.sharedSecret>
 10a5a80: 79413be8     	ldrh	w8, [sp, #0x9c]
 10a5a84: 35000528     	cbnz	w8,  <L7>
 10a5a88: 910273e8     	add	x8, sp, #0x9c
 10a5a8c: 3cc02100     	ldur	q0, [x8, #0x2]
 10a5a90: 3cc12101     	ldur	q1, [x8, #0x12]
 10a5a94: 1400000f     	b	 <L2>
<L1>:
 10a5a98: f100809f     	cmp	x4, #0x20
 10a5a9c: 540002e1     	b.ne	 <L4>
 10a5aa0: ad400460     	ldp	q0, q1, [x3]
 10a5aa4: aa0003f3     	mov	x19, x0
 10a5aa8: 9100b3e0     	add	x0, sp, #0x2c
 10a5aac: aa0203e1     	mov	x1, x2
 10a5ab0: 910003e2     	mov	x2, sp
 10a5ab4: aa0503f4     	mov	x20, x5
 10a5ab8: ad0007e0     	stp	q0, q1, [sp]
 10a5abc: 97ff7046     	bl	 <x25519.sharedSecret>
 10a5ac0: 79405be8     	ldrh	w8, [sp, #0x2c]
 10a5ac4: 35000328     	cbnz	w8,  <L7>
 10a5ac8: 3cc2e3e0     	ldur	q0, [sp, #0x2e]
 10a5acc: 3cc3e3e1     	ldur	q1, [sp, #0x3e]
<L2>:
 10a5ad0: ad000680     	stp	q0, q1, [x20]
 10a5ad4: f0fffae8     	adrp	x8, 0x1004000 <__anon_415846+0x150>
 10a5ad8: 91160108     	add	x8, x8, #0x580
<L3>:
 10a5adc: 3dc00100     	ldr	q0, [x8]
 10a5ae0: 3d800260     	str	q0, [x19]
 10a5ae4: 910803ff     	add	sp, sp, #0x200
 10a5ae8: a9424ff4     	ldp	x20, x19, [sp, #0x20]
 10a5aec: f9400bfc     	ldr	x28, [sp, #0x10]
 10a5af0: a8c37bfd     	ldp	x29, x30, [sp], #0x30
 10a5af4: d65f03c0     	ret
<L4>:
 10a5af8: f0fffae8     	adrp	x8, 0x1004000 <__anon_415846+0x150>
 10a5afc: 91190108     	add	x8, x8, #0x640
<L5>:
 10a5b00: 3dc00100     	ldr	q0, [x8]
 10a5b04: 3d800000     	str	q0, [x0]
 10a5b08: 910803ff     	add	sp, sp, #0x200
 10a5b0c: a9424ff4     	ldp	x20, x19, [sp, #0x20]
 10a5b10: f9400bfc     	ldr	x28, [sp, #0x10]
 10a5b14: a8c37bfd     	ldp	x29, x30, [sp], #0x30
 10a5b18: d65f03c0     	ret
<L6>:
 10a5b1c: d0fffae8     	adrp	x8, 0x1003000 <writev+0x1003000>
 10a5b20: 91304108     	add	x8, x8, #0xc10
 10a5b24: 17fffff7     	b	 <L5>
<L7>:
 10a5b28: 79001268     	strh	w8, [x19, #0x8]
 10a5b2c: 910803ff     	add	sp, sp, #0x200
 10a5b30: a9424ff4     	ldp	x20, x19, [sp, #0x20]
 10a5b34: f9400bfc     	ldr	x28, [sp, #0x10]
 10a5b38: a8c37bfd     	ldp	x29, x30, [sp], #0x30
 10a5b3c: d65f03c0     	ret
