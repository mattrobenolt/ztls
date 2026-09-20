
/Users/matt/code/ztls/zig-out/memory.YYkvFg/bin/bin/test:	file format elf64-littleaarch64

Disassembly of section .text:

00000000010a4fec <p256.sharedSecret>:
 10a4fec: d10243ff     	sub	sp, sp, #0x90
 10a4ff0: a9067bfd     	stp	x29, x30, [sp, #0x60]
 10a4ff4: a90757f6     	stp	x22, x21, [sp, #0x70]
 10a4ff8: a9084ff4     	stp	x20, x19, [sp, #0x80]
 10a4ffc: 910183fd     	add	x29, sp, #0x60
 10a5000: ad400400     	ldp	q0, q1, [x0]
 10a5004: aa0203f3     	mov	x19, x2
 10a5008: aa0103f5     	mov	x21, x1
 10a500c: ad0007e0     	stp	q0, q1, [sp]
 10a5010: 9404ffb4     	bl	 <ERR_set_mark@plt>
 10a5014: d10043a0     	sub	x0, x29, #0x10
 10a5018: 910003e1     	mov	x1, sp
 10a501c: 97ff5d81     	bl	 <crypto.backend_openssl.p256PrivateKeyFromSecretImpl>
 10a5020: 9404ffc4     	bl	 <ERR_pop_to_mark@plt>
 10a5024: 785f83b4     	ldurh	w20, [x29, #-0x8]
 10a5028: 35000414     	cbnz	w20,  <L1>
 10a502c: ad4106a0     	ldp	q0, q1, [x21, #0x20]
 10a5030: d10043a0     	sub	x0, x29, #0x10
 10a5034: 394102a8     	ldrb	w8, [x21, #0x40]
 10a5038: 910003e1     	mov	x1, sp
 10a503c: ad0107e0     	stp	q0, q1, [sp, #0x20]
 10a5040: ad4002a1     	ldp	q1, q0, [x21]
 10a5044: f85f03b5     	ldur	x21, [x29, #-0x10]
 10a5048: 390103e8     	strb	w8, [sp, #0x40]
 10a504c: ad0003e1     	stp	q1, q0, [sp]
 10a5050: 9400008f     	bl	 <crypto.backend_openssl.p256PublicKeyFromRaw>
 10a5054: 785f83b4     	ldurh	w20, [x29, #-0x8]
 10a5058: 35000254     	cbnz	w20,  <L0>
 10a505c: f85f03b6     	ldur	x22, [x29, #-0x10]
 10a5060: aa1503e0     	mov	x0, x21
 10a5064: aa1303e2     	mov	x2, x19
 10a5068: aa1603e1     	mov	x1, x22
 10a506c: 94000050     	bl	 <crypto.backend_openssl.p256SharedSecretDerive>
 10a5070: 12003c14     	and	w20, w0, #0xffff
 10a5074: aa1603e0     	mov	x0, x22
 10a5078: 9404ffde     	bl	 <EVP_PKEY_free@plt>
 10a507c: aa1503e0     	mov	x0, x21
 10a5080: 9404ffdc     	bl	 <EVP_PKEY_free@plt>
 10a5084: 35000134     	cbnz	w20,  <L1>
 10a5088: 2a1403e0     	mov	w0, w20
 10a508c: a9484ff4     	ldp	x20, x19, [sp, #0x80]
 10a5090: a94757f6     	ldp	x22, x21, [sp, #0x70]
 10a5094: a9467bfd     	ldp	x29, x30, [sp, #0x60]
 10a5098: 910243ff     	add	sp, sp, #0x90
 10a509c: d65f03c0     	ret
<L0>:
 10a50a0: aa1503e0     	mov	x0, x21
 10a50a4: 9404ffd3     	bl	 <EVP_PKEY_free@plt>
<L1>:
 10a50a8: 6f00e400     	movi	v0.2d, #0000000000000000
 10a50ac: 3d800660     	str	q0, [x19, #0x10]
 10a50b0: 3d800260     	str	q0, [x19]
 10a50b4: 2a1403e0     	mov	w0, w20
 10a50b8: a9484ff4     	ldp	x20, x19, [sp, #0x80]
 10a50bc: a94757f6     	ldp	x22, x21, [sp, #0x70]
 10a50c0: a9467bfd     	ldp	x29, x30, [sp, #0x60]
 10a50c4: 910243ff     	add	sp, sp, #0x90
 10a50c8: d65f03c0     	ret
