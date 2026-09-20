
/tmp/ztls-signoff-20260919/125-after-direct-buffers/015-x86_64-linux-gnu.o:	file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <audit_handshake256>:
       0: 55                           	pushq	%rbp
       1: 48 89 e5                     	movq	%rsp, %rbp
       4: 41 57                        	pushq	%r15
       6: 41 56                        	pushq	%r14
       8: 53                           	pushq	%rbx
       9: 48 81 ec 58 01 00 00         	subq	$0x158, %rsp            # imm = 0x158
      10: 48 89 d3                     	movq	%rdx, %rbx
      13: 49 89 f6                     	movq	%rsi, %r14
      16: 49 89 f8                     	movq	%rdi, %r8
      19: 66 c7 85 90 fe ff ff 00 20   	movw	$0x2000, -0x170(%rbp)   # imm = 0x2000
      22: c6 85 92 fe ff ff 0d         	movb	$0xd, -0x16e(%rbp)
      29: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
      33: 48 89 85 93 fe ff ff         	movq	%rax, -0x16d(%rbp)
      3a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
      44: 48 89 85 98 fe ff ff         	movq	%rax, -0x168(%rbp)
      4b: c6 85 a0 fe ff ff 20         	movb	$0x20, -0x160(%rbp)
      52: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x59>
		0000000000000055:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
      59: 0f 11 85 a1 fe ff ff         	movups	%xmm0, -0x15f(%rbp)
      60: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x67>
		0000000000000063:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
      67: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
      6e: 4c 8d 7d c0                  	leaq	-0x40(%rbp), %r15
      72: 48 8d 95 90 fe ff ff         	leaq	-0x170(%rbp), %rdx
      79: be 20 00 00 00               	movl	$0x20, %esi
      7e: b9 31 00 00 00               	movl	$0x31, %ecx
      83: 4c 89 ff                     	movq	%r15, %rdi
      86: e8 25 03 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
      8b: 48 8d 7d a0                  	leaq	-0x60(%rbp), %rdi
      8f: 4c 89 fe                     	movq	%r15, %rsi
      92: 4c 89 f2                     	movq	%r14, %rdx
      95: e8 36 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
      9a: 0f 57 c0                     	xorps	%xmm0, %xmm0
      9d: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
      a1: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
      a5: 0f 10 45 a0                  	movups	-0x60(%rbp), %xmm0
      a9: 0f 10 4d b0                  	movups	-0x50(%rbp), %xmm1
      ad: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
      b1: 0f 11 03                     	movups	%xmm0, (%rbx)
      b4: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            # imm = 0x158
      bb: 5b                           	popq	%rbx
      bc: 41 5e                        	popq	%r14
      be: 41 5f                        	popq	%r15
      c0: 5d                           	popq	%rbp
      c1: c3                           	retq
      c2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
      cc: 0f 1f 40 00                  	nopl	(%rax)

00000000000000d0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
      d0: 55                           	pushq	%rbp
      d1: 48 89 e5                     	movq	%rsp, %rbp
      d4: 41 57                        	pushq	%r15
      d6: 41 56                        	pushq	%r14
      d8: 41 55                        	pushq	%r13
      da: 41 54                        	pushq	%r12
      dc: 53                           	pushq	%rbx
      dd: 48 81 ec 68 01 00 00         	subq	$0x168, %rsp            # imm = 0x168
      e4: 49 89 d7                     	movq	%rdx, %r15
      e7: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
      eb: 0f 10 06                     	movups	(%rsi), %xmm0
      ee: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
      f2: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x29>
		00000000000000f5:  R_X86_64_PC32	.LCPI1_0-0x4
      f9: 0f 28 d8                     	movaps	%xmm0, %xmm3
      fc: 0f 57 da                     	xorps	%xmm2, %xmm3
      ff: 0f 28 e1                     	movaps	%xmm1, %xmm4
     102: 0f 57 e2                     	xorps	%xmm2, %xmm4
     105: 0f 29 9d 20 ff ff ff         	movaps	%xmm3, -0xe0(%rbp)
     10c: 0f 29 a5 30 ff ff ff         	movaps	%xmm4, -0xd0(%rbp)
     113: 0f 29 95 40 ff ff ff         	movaps	%xmm2, -0xc0(%rbp)
     11a: 0f 29 95 50 ff ff ff         	movaps	%xmm2, -0xb0(%rbp)
     121: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x58>
		0000000000000124:  R_X86_64_PC32	.LCPI1_1-0x4
     128: 0f 57 c2                     	xorps	%xmm2, %xmm0
     12b: 0f 57 ca                     	xorps	%xmm2, %xmm1
     12e: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     135: 0f 29 8d 70 ff ff ff         	movaps	%xmm1, -0x90(%rbp)
     13c: 0f 29 55 80                  	movaps	%xmm2, -0x80(%rbp)
     140: 0f 29 55 90                  	movaps	%xmm2, -0x70(%rbp)
     144: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x7b>
		0000000000000147:  R_X86_64_PC32	.rodata-0x4
     14b: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
     152: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x89>
		0000000000000155:  R_X86_64_PC32	.rodata+0xc
     159: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
     160: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x97>
		0000000000000163:  R_X86_64_PC32	.rodata+0x1c
     167: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
     16e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xa5>
		0000000000000171:  R_X86_64_PC32	.rodata+0x2c
     175: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
     17c: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xb3>
		000000000000017f:  R_X86_64_PC32	.rodata+0x3c
     183: 0f 29 85 f0 fe ff ff         	movaps	%xmm0, -0x110(%rbp)
     18a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xc1>
		000000000000018d:  R_X86_64_PC32	.rodata+0x4c
     191: 0f 29 85 00 ff ff ff         	movaps	%xmm0, -0x100(%rbp)
     198: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xcf>
		000000000000019b:  R_X86_64_PC32	.rodata+0x5c
     19f: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     1a6: 48 8d bd b0 fe ff ff         	leaq	-0x150(%rbp), %rdi
     1ad: 48 8d b5 60 ff ff ff         	leaq	-0xa0(%rbp), %rsi
     1b4: e8 e7 0a 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     1b9: 48 8b 9d d0 fe ff ff         	movq	-0x130(%rbp), %rbx
     1c0: 48 83 c3 40                  	addq	$0x40, %rbx
     1c4: 48 89 9d d0 fe ff ff         	movq	%rbx, -0x130(%rbp)
     1cb: 0f b6 85 18 ff ff ff         	movzbl	-0xe8(%rbp), %eax
     1d2: 48 85 c0                     	testq	%rax, %rax
     1d5: 74 4b                        	je	 <L1>
     1d7: 3c 20                        	cmpb	$0x20, %al
     1d9: 72 49                        	jb	 <L2>
     1db: 41 bd 40 00 00 00            	movl	$0x40, %r13d
     1e1: 49 29 c5                     	subq	%rax, %r13
     1e4: 4c 8d a5 d8 fe ff ff         	leaq	-0x128(%rbp), %r12
     1eb: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     1ef: 48 81 c7 d8 fe ff ff         	addq	$-0x128, %rdi           # imm = 0xFED8
     1f6: 4c 89 fe                     	movq	%r15, %rsi
     1f9: 4c 89 ea                     	movq	%r13, %rdx
     1fc: e8 00 00 00 00               	callq	 <L0>
		00000000000001fd:  R_X86_64_PLT32	memcpy-0x4
<L0>:
     201: 48 8d bd b0 fe ff ff         	leaq	-0x150(%rbp), %rdi
     208: 4c 89 e6                     	movq	%r12, %rsi
     20b: e8 90 0a 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     210: c6 85 18 ff ff ff 00         	movb	$0x0, -0xe8(%rbp)
     217: 31 c0                        	xorl	%eax, %eax
     219: 48 8b 9d d0 fe ff ff         	movq	-0x130(%rbp), %rbx
     220: eb 05                        	jmp	 <L3>
<L1>:
     222: 31 c0                        	xorl	%eax, %eax
<L2>:
     224: 45 31 ed                     	xorl	%r13d, %r13d
<L3>:
     227: 4d 01 ef                     	addq	%r13, %r15
     22a: 41 bc 20 00 00 00            	movl	$0x20, %r12d
     230: 41 be 20 00 00 00            	movl	$0x20, %r14d
     236: 4d 29 ee                     	subq	%r13, %r14
     239: 0f b6 c0                     	movzbl	%al, %eax
     23c: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     240: 48 81 c7 d8 fe ff ff         	addq	$-0x128, %rdi           # imm = 0xFED8
     247: 4c 89 fe                     	movq	%r15, %rsi
     24a: 4c 89 f2                     	movq	%r14, %rdx
     24d: e8 00 00 00 00               	callq	 <L4>
		000000000000024e:  R_X86_64_PLT32	memcpy-0x4
<L4>:
     252: 44 00 b5 18 ff ff ff         	addb	%r14b, -0xe8(%rbp)
     259: 48 83 c3 20                  	addq	$0x20, %rbx
     25d: 48 89 9d d0 fe ff ff         	movq	%rbx, -0x130(%rbp)
     264: 48 8d bd b0 fe ff ff         	leaq	-0x150(%rbp), %rdi
     26b: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
     272: e8 09 09 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     277: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1ae>
		000000000000027a:  R_X86_64_PC32	.rodata+0x5c
     27e: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
     282: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1b9>
		0000000000000285:  R_X86_64_PC32	.rodata+0x4c
     289: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     28d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1c4>
		0000000000000290:  R_X86_64_PC32	.rodata+0x3c
     294: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     298: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1cf>
		000000000000029b:  R_X86_64_PC32	.rodata+0x2c
     29f: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     2a3: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1da>
		00000000000002a6:  R_X86_64_PC32	.rodata+0x1c
     2aa: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     2ae: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1e5>
		00000000000002b1:  R_X86_64_PC32	.rodata+0xc
     2b5: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     2bc: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1f3>
		00000000000002bf:  R_X86_64_PC32	.rodata-0x4
     2c3: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     2ca: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     2d1: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
     2d8: e8 c3 09 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     2dd: 0f b6 7d c8                  	movzbl	-0x38(%rbp), %edi
     2e1: 48 8b 5d 80                  	movq	-0x80(%rbp), %rbx
     2e5: 48 83 c3 40                  	addq	$0x40, %rbx
     2e9: 4c 8d 75 88                  	leaq	-0x78(%rbp), %r14
     2ed: 48 89 5d 80                  	movq	%rbx, -0x80(%rbp)
     2f1: 48 85 ff                     	testq	%rdi, %rdi
     2f4: 74 3c                        	je	 <L6>
     2f6: 40 80 ff 20                  	cmpb	$0x20, %dil
     2fa: 72 38                        	jb	 <L7>
     2fc: 41 bf 40 00 00 00            	movl	$0x40, %r15d
     302: 49 29 ff                     	subq	%rdi, %r15
     305: 4c 01 f7                     	addq	%r14, %rdi
     308: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
     30f: 4c 89 fa                     	movq	%r15, %rdx
     312: e8 00 00 00 00               	callq	 <L5>
		0000000000000313:  R_X86_64_PLT32	memcpy-0x4
<L5>:
     317: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     31e: 4c 89 f6                     	movq	%r14, %rsi
     321: e8 7a 09 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     326: c6 45 c8 00                  	movb	$0x0, -0x38(%rbp)
     32a: 31 ff                        	xorl	%edi, %edi
     32c: 48 8b 5d 80                  	movq	-0x80(%rbp), %rbx
     330: eb 05                        	jmp	 <L8>
<L6>:
     332: 31 ff                        	xorl	%edi, %edi
<L7>:
     334: 45 31 ff                     	xorl	%r15d, %r15d
<L8>:
     337: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     33b: 48 81 c6 70 fe ff ff         	addq	$-0x190, %rsi           # imm = 0xFE70
     342: 4d 29 fc                     	subq	%r15, %r12
     345: 40 0f b6 c7                  	movzbl	%dil, %eax
     349: 49 01 c6                     	addq	%rax, %r14
     34c: 4c 89 f7                     	movq	%r14, %rdi
     34f: 4c 89 e2                     	movq	%r12, %rdx
     352: e8 00 00 00 00               	callq	 <L9>
		0000000000000353:  R_X86_64_PLT32	memcpy-0x4
<L9>:
     357: 44 00 65 c8                  	addb	%r12b, -0x38(%rbp)
     35b: 48 83 c3 20                  	addq	$0x20, %rbx
     35f: 48 89 5d 80                  	movq	%rbx, -0x80(%rbp)
     363: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     36a: 48 8d b5 90 fe ff ff         	leaq	-0x170(%rbp), %rsi
     371: e8 0a 08 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     376: 0f 10 85 90 fe ff ff         	movups	-0x170(%rbp), %xmm0
     37d: 0f 10 8d a0 fe ff ff         	movups	-0x160(%rbp), %xmm1
     384: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
     388: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
     38c: 0f 11 00                     	movups	%xmm0, (%rax)
     38f: 48 81 c4 68 01 00 00         	addq	$0x168, %rsp            # imm = 0x168
     396: 5b                           	popq	%rbx
     397: 41 5c                        	popq	%r12
     399: 41 5d                        	popq	%r13
     39b: 41 5e                        	popq	%r14
     39d: 41 5f                        	popq	%r15
     39f: 5d                           	popq	%rbp
     3a0: c3                           	retq
     3a1: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     3ab: 0f 1f 44 00 00               	nopl	(%rax,%rax)

00000000000003b0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     3b0: 55                           	pushq	%rbp
     3b1: 48 89 e5                     	movq	%rsp, %rbp
     3b4: 41 57                        	pushq	%r15
     3b6: 41 56                        	pushq	%r14
     3b8: 41 55                        	pushq	%r13
     3ba: 41 54                        	pushq	%r12
     3bc: 53                           	pushq	%rbx
     3bd: 48 81 ec 68 02 00 00         	subq	$0x268, %rsp            # imm = 0x268
     3c4: 49 89 cd                     	movq	%rcx, %r13
     3c7: 49 89 d4                     	movq	%rdx, %r12
     3ca: 48 89 f3                     	movq	%rsi, %rbx
     3cd: 49 89 fe                     	movq	%rdi, %r14
     3d0: 41 0f 10 18                  	movups	(%r8), %xmm3
     3d4: 41 0f 10 60 10               	movups	0x10(%r8), %xmm4
     3d9: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
     3dd: 48 83 fe 20                  	cmpq	$0x20, %rsi
     3e1: 73 1d                        	jae	 <L0>
     3e3: 48 c7 85 40 ff ff ff 00 00 00 00     	movq	$0x0, -0xc0(%rbp)
     3ee: 48 89 d8                     	movq	%rbx, %rax
     3f1: 48 83 e0 1f                  	andq	$0x1f, %rax
     3f5: 0f 85 8e 03 00 00            	jne	 <L16>
     3fb: e9 61 07 00 00               	jmp	 <L39>
<L0>:
     400: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
     407: 0f 29 9d 90 fd ff ff         	movaps	%xmm3, -0x270(%rbp)
     40e: 4c 89 65 c8                  	movq	%r12, -0x38(%rbp)
     412: 4c 8d a5 d8 fd ff ff         	leaq	-0x228(%rbp), %r12
     419: 41 0f 10 00                  	movups	(%r8), %xmm0
     41d: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
     422: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x79>
		0000000000000425:  R_X86_64_PC32	.LCPI2_0-0x4
     429: 0f 28 d8                     	movaps	%xmm0, %xmm3
     42c: 0f 57 da                     	xorps	%xmm2, %xmm3
     42f: 0f 28 e1                     	movaps	%xmm1, %xmm4
     432: 0f 57 e2                     	xorps	%xmm2, %xmm4
     435: 0f 29 9d 20 fe ff ff         	movaps	%xmm3, -0x1e0(%rbp)
     43c: 0f 29 a5 30 fe ff ff         	movaps	%xmm4, -0x1d0(%rbp)
     443: 0f 29 95 40 fe ff ff         	movaps	%xmm2, -0x1c0(%rbp)
     44a: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
     451: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xa8>
		0000000000000454:  R_X86_64_PC32	.LCPI2_1-0x4
     458: 0f 57 c2                     	xorps	%xmm2, %xmm0
     45b: 0f 57 ca                     	xorps	%xmm2, %xmm1
     45e: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     465: 0f 29 8d 60 ff ff ff         	movaps	%xmm1, -0xa0(%rbp)
     46c: 0f 29 95 70 ff ff ff         	movaps	%xmm2, -0x90(%rbp)
     473: 0f 29 55 80                  	movaps	%xmm2, -0x80(%rbp)
     477: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xce>
		000000000000047a:  R_X86_64_PC32	.rodata-0x4
     47e: 0f 29 85 b0 fd ff ff         	movaps	%xmm0, -0x250(%rbp)
     485: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xdc>
		0000000000000488:  R_X86_64_PC32	.rodata+0xc
     48c: 0f 29 85 c0 fd ff ff         	movaps	%xmm0, -0x240(%rbp)
     493: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xea>
		0000000000000496:  R_X86_64_PC32	.rodata+0x1c
     49a: 0f 29 85 d0 fd ff ff         	movaps	%xmm0, -0x230(%rbp)
     4a1: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xf8>
		00000000000004a4:  R_X86_64_PC32	.rodata+0x2c
     4a8: 0f 29 85 e0 fd ff ff         	movaps	%xmm0, -0x220(%rbp)
     4af: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x106>
		00000000000004b2:  R_X86_64_PC32	.rodata+0x3c
     4b6: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
     4bd: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x114>
		00000000000004c0:  R_X86_64_PC32	.rodata+0x4c
     4c4: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
     4cb: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x122>
		00000000000004ce:  R_X86_64_PC32	.rodata+0x5c
     4d2: 0f 29 85 10 fe ff ff         	movaps	%xmm0, -0x1f0(%rbp)
     4d9: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     4e0: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
     4e7: e8 b4 07 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     4ec: 48 83 85 d0 fd ff ff 40      	addq	$0x40, -0x230(%rbp)
     4f4: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
     4fb: 48 85 ff                     	testq	%rdi, %rdi
     4fe: 4c 89 b5 48 ff ff ff         	movq	%r14, -0xb8(%rbp)
     505: 48 89 9d 38 ff ff ff         	movq	%rbx, -0xc8(%rbp)
     50c: 74 3d                        	je	 <L2>
     50e: 4c 89 e8                     	movq	%r13, %rax
     511: 48 83 f0 3f                  	xorq	$0x3f, %rax
     515: 48 39 f8                     	cmpq	%rdi, %rax
     518: 73 33                        	jae	 <L3>
     51a: bb 40 00 00 00               	movl	$0x40, %ebx
     51f: 48 29 fb                     	subq	%rdi, %rbx
     522: 4c 01 e7                     	addq	%r12, %rdi
     525: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     529: 48 89 da                     	movq	%rbx, %rdx
     52c: e8 00 00 00 00               	callq	 <L1>
		000000000000052d:  R_X86_64_PLT32	memcpy-0x4
<L1>:
     531: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     538: 4c 89 e6                     	movq	%r12, %rsi
     53b: e8 60 07 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     540: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
     547: 31 ff                        	xorl	%edi, %edi
     549: eb 04                        	jmp	 <L4>
<L2>:
     54b: 31 ff                        	xorl	%edi, %edi
<L3>:
     54d: 31 db                        	xorl	%ebx, %ebx
<L4>:
     54f: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
     553: 48 8d 34 18                  	leaq	(%rax,%rbx), %rsi
     557: 4d 89 ef                     	movq	%r13, %r15
     55a: 49 29 df                     	subq	%rbx, %r15
     55d: 40 0f b6 ff                  	movzbl	%dil, %edi
     561: 4c 01 e7                     	addq	%r12, %rdi
     564: 4c 89 fa                     	movq	%r15, %rdx
     567: e8 00 00 00 00               	callq	 <L5>
		0000000000000568:  R_X86_64_PLT32	memcpy-0x4
<L5>:
     56c: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
     573: 4c 01 ff                     	addq	%r15, %rdi
     576: 40 88 bd 18 fe ff ff         	movb	%dil, -0x1e8(%rbp)
     57d: 4c 8b b5 d0 fd ff ff         	movq	-0x230(%rbp), %r14
     584: 4d 01 ee                     	addq	%r13, %r14
     587: 4c 89 b5 d0 fd ff ff         	movq	%r14, -0x230(%rbp)
     58e: 40 84 ff                     	testb	%dil, %dil
     591: 4c 89 ad 30 ff ff ff         	movq	%r13, -0xd0(%rbp)
     598: 74 3f                        	je	 <L7>
     59a: 40 80 ff 3f                  	cmpb	$0x3f, %dil
     59e: 72 3b                        	jb	 <L8>
     5a0: b0 40                        	movb	$0x40, %al
     5a2: 40 28 f8                     	subb	%dil, %al
     5a5: 44 0f b6 f8                  	movzbl	%al, %r15d
     5a9: 4c 01 e7                     	addq	%r12, %rdi
     5ac: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     5b0: 4c 89 fa                     	movq	%r15, %rdx
     5b3: e8 00 00 00 00               	callq	 <L6>
		00000000000005b4:  R_X86_64_PLT32	memcpy-0x4
<L6>:
     5b8: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     5bf: 4c 89 e6                     	movq	%r12, %rsi
     5c2: e8 d9 06 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     5c7: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
     5ce: 31 ff                        	xorl	%edi, %edi
     5d0: 4c 8b b5 d0 fd ff ff         	movq	-0x230(%rbp), %r14
     5d7: eb 05                        	jmp	 <L9>
<L7>:
     5d9: 31 ff                        	xorl	%edi, %edi
<L8>:
     5db: 45 31 ff                     	xorl	%r15d, %r15d
<L9>:
     5de: 48 8d 9d 78 ff ff ff         	leaq	-0x88(%rbp), %rbx
     5e5: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     5e9: 48 83 c6 d7                  	addq	$-0x29, %rsi
     5ed: 41 bd 01 00 00 00            	movl	$0x1, %r13d
     5f3: 4d 29 fd                     	subq	%r15, %r13
     5f6: 40 0f b6 c7                  	movzbl	%dil, %eax
     5fa: 49 01 c4                     	addq	%rax, %r12
     5fd: 4c 89 e7                     	movq	%r12, %rdi
     600: 4c 89 ea                     	movq	%r13, %rdx
     603: e8 00 00 00 00               	callq	 <L10>
		0000000000000604:  R_X86_64_PLT32	memcpy-0x4
<L10>:
     608: 44 00 ad 18 fe ff ff         	addb	%r13b, -0x1e8(%rbp)
     60f: 49 83 c6 01                  	addq	$0x1, %r14
     613: 4c 89 b5 d0 fd ff ff         	movq	%r14, -0x230(%rbp)
     61a: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     621: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     628: e8 53 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     62d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x284>
		0000000000000630:  R_X86_64_PC32	.rodata+0x5c
     634: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     638: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x28f>
		000000000000063b:  R_X86_64_PC32	.rodata+0x4c
     63f: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     643: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x29a>
		0000000000000646:  R_X86_64_PC32	.rodata+0x3c
     64a: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     64e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2a5>
		0000000000000651:  R_X86_64_PC32	.rodata+0x2c
     655: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     659: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2b0>
		000000000000065c:  R_X86_64_PC32	.rodata+0x1c
     660: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     667: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2be>
		000000000000066a:  R_X86_64_PC32	.rodata+0xc
     66e: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     675: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2cc>
		0000000000000678:  R_X86_64_PC32	.rodata-0x4
     67c: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     683: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     68a: 48 8d b5 20 fe ff ff         	leaq	-0x1e0(%rbp), %rsi
     691: e8 0a 06 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     696: 0f b6 7d b8                  	movzbl	-0x48(%rbp), %edi
     69a: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     6a1: 49 83 c5 40                  	addq	$0x40, %r13
     6a5: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     6ac: 48 85 ff                     	testq	%rdi, %rdi
     6af: 74 46                        	je	 <L12>
     6b1: 40 80 ff 20                  	cmpb	$0x20, %dil
     6b5: 4c 8b b5 48 ff ff ff         	movq	-0xb8(%rbp), %r14
     6bc: 72 47                        	jb	 <L13>
     6be: 41 bf 40 00 00 00            	movl	$0x40, %r15d
     6c4: 49 29 ff                     	subq	%rdi, %r15
     6c7: 48 01 df                     	addq	%rbx, %rdi
     6ca: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     6d1: 4c 89 fa                     	movq	%r15, %rdx
     6d4: e8 00 00 00 00               	callq	 <L11>
		00000000000006d5:  R_X86_64_PLT32	memcpy-0x4
<L11>:
     6d9: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     6e0: 48 89 de                     	movq	%rbx, %rsi
     6e3: e8 b8 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     6e8: c6 45 b8 00                  	movb	$0x0, -0x48(%rbp)
     6ec: 31 ff                        	xorl	%edi, %edi
     6ee: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     6f5: eb 11                        	jmp	 <L14>
<L12>:
     6f7: 31 ff                        	xorl	%edi, %edi
     6f9: 45 31 ff                     	xorl	%r15d, %r15d
     6fc: 4c 8b b5 48 ff ff ff         	movq	-0xb8(%rbp), %r14
     703: eb 03                        	jmp	 <L14>
<L13>:
     705: 45 31 ff                     	xorl	%r15d, %r15d
<L14>:
     708: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     70c: 48 81 c6 60 fe ff ff         	addq	$-0x1a0, %rsi           # imm = 0xFE60
     713: b8 20 00 00 00               	movl	$0x20, %eax
     718: 48 89 85 40 ff ff ff         	movq	%rax, -0xc0(%rbp)
     71f: 41 bc 20 00 00 00            	movl	$0x20, %r12d
     725: 4d 29 fc                     	subq	%r15, %r12
     728: 40 0f b6 c7                  	movzbl	%dil, %eax
     72c: 48 01 c3                     	addq	%rax, %rbx
     72f: 48 89 df                     	movq	%rbx, %rdi
     732: 4c 89 e2                     	movq	%r12, %rdx
     735: e8 00 00 00 00               	callq	 <L15>
		0000000000000736:  R_X86_64_PLT32	memcpy-0x4
<L15>:
     73a: 44 00 65 b8                  	addb	%r12b, -0x48(%rbp)
     73e: 49 83 c5 20                  	addq	$0x20, %r13
     742: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     749: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     750: 4c 89 f6                     	movq	%r14, %rsi
     753: e8 28 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     758: c6 45 d7 02                  	movb	$0x2, -0x29(%rbp)
     75c: 4c 8b ad 30 ff ff ff         	movq	-0xd0(%rbp), %r13
     763: 4c 8b 65 c8                  	movq	-0x38(%rbp), %r12
     767: 48 8b 9d 38 ff ff ff         	movq	-0xc8(%rbp), %rbx
     76e: 0f 28 9d 90 fd ff ff         	movaps	-0x270(%rbp), %xmm3
     775: 0f 28 a5 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm4
     77c: 48 89 d8                     	movq	%rbx, %rax
     77f: 48 83 e0 1f                  	andq	$0x1f, %rax
     783: 0f 84 d8 03 00 00            	je	 <L39>
<L16>:
     789: 48 89 45 c8                  	movq	%rax, -0x38(%rbp)
     78d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x3e4>
		0000000000000790:  R_X86_64_PC32	.LCPI2_0-0x4
     794: 0f 28 cb                     	movaps	%xmm3, %xmm1
     797: 0f 57 c8                     	xorps	%xmm0, %xmm1
     79a: 0f 28 d4                     	movaps	%xmm4, %xmm2
     79d: 0f 57 d0                     	xorps	%xmm0, %xmm2
     7a0: 0f 29 8d f0 fe ff ff         	movaps	%xmm1, -0x110(%rbp)
     7a7: 0f 29 95 00 ff ff ff         	movaps	%xmm2, -0x100(%rbp)
     7ae: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     7b5: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
     7bc: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x413>
		00000000000007bf:  R_X86_64_PC32	.LCPI2_1-0x4
     7c3: 0f 57 d8                     	xorps	%xmm0, %xmm3
     7c6: 0f 57 e0                     	xorps	%xmm0, %xmm4
     7c9: 0f 29 9d 50 ff ff ff         	movaps	%xmm3, -0xb0(%rbp)
     7d0: 0f 29 a5 60 ff ff ff         	movaps	%xmm4, -0xa0(%rbp)
     7d7: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     7de: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     7e2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x439>
		00000000000007e5:  R_X86_64_PC32	.rodata-0x4
     7e9: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
     7f0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x447>
		00000000000007f3:  R_X86_64_PC32	.rodata+0xc
     7f7: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
     7fe: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x455>
		0000000000000801:  R_X86_64_PC32	.rodata+0x1c
     805: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
     80c: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x463>
		000000000000080f:  R_X86_64_PC32	.rodata+0x2c
     813: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
     81a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x471>
		000000000000081d:  R_X86_64_PC32	.rodata+0x3c
     821: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
     828: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x47f>
		000000000000082b:  R_X86_64_PC32	.rodata+0x4c
     82f: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
     836: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x48d>
		0000000000000839:  R_X86_64_PC32	.rodata+0x5c
     83d: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
     844: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     84b: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
     852: e8 49 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     857: 48 83 85 a0 fe ff ff 40      	addq	$0x40, -0x160(%rbp)
     85f: 0f b6 85 e8 fe ff ff         	movzbl	-0x118(%rbp), %eax
     866: 48 83 fb 1f                  	cmpq	$0x1f, %rbx
     86a: 0f 86 8a 00 00 00            	jbe	 <L22>
     870: 84 c0                        	testb	%al, %al
     872: 74 46                        	je	 <L18>
     874: 3c 20                        	cmpb	$0x20, %al
     876: 72 44                        	jb	 <L19>
     878: 0f b6 c0                     	movzbl	%al, %eax
     87b: bb 40 00 00 00               	movl	$0x40, %ebx
     880: 48 29 c3                     	subq	%rax, %rbx
     883: 4c 8d bd a8 fe ff ff         	leaq	-0x158(%rbp), %r15
     88a: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     88e: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     895: 4c 89 f6                     	movq	%r14, %rsi
     898: 48 89 da                     	movq	%rbx, %rdx
     89b: e8 00 00 00 00               	callq	 <L17>
		000000000000089c:  R_X86_64_PLT32	memcpy-0x4
<L17>:
     8a0: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     8a7: 4c 89 fe                     	movq	%r15, %rsi
     8aa: e8 f1 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     8af: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     8b6: 31 c0                        	xorl	%eax, %eax
     8b8: eb 04                        	jmp	 <L20>
<L18>:
     8ba: 31 c0                        	xorl	%eax, %eax
<L19>:
     8bc: 31 db                        	xorl	%ebx, %ebx
<L20>:
     8be: 49 8d 34 1e                  	leaq	(%r14,%rbx), %rsi
     8c2: 41 bf 20 00 00 00            	movl	$0x20, %r15d
     8c8: 49 29 df                     	subq	%rbx, %r15
     8cb: 0f b6 c0                     	movzbl	%al, %eax
     8ce: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     8d2: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     8d9: 4c 89 fa                     	movq	%r15, %rdx
     8dc: e8 00 00 00 00               	callq	 <L21>
		00000000000008dd:  R_X86_64_PLT32	memcpy-0x4
<L21>:
     8e1: 44 02 bd e8 fe ff ff         	addb	-0x118(%rbp), %r15b
     8e8: 44 88 bd e8 fe ff ff         	movb	%r15b, -0x118(%rbp)
     8ef: 48 83 85 a0 fe ff ff 20      	addq	$0x20, -0x160(%rbp)
     8f7: 44 89 f8                     	movl	%r15d, %eax
<L22>:
     8fa: 84 c0                        	testb	%al, %al
     8fc: 74 4b                        	je	 <L24>
     8fe: 0f b6 c8                     	movzbl	%al, %ecx
     901: 4a 8d 14 29                  	leaq	(%rcx,%r13), %rdx
     905: 48 83 fa 40                  	cmpq	$0x40, %rdx
     909: 72 40                        	jb	 <L25>
     90b: b2 40                        	movb	$0x40, %dl
     90d: 28 c2                        	subb	%al, %dl
     90f: 0f b6 da                     	movzbl	%dl, %ebx
     912: 4c 8d bd a8 fe ff ff         	leaq	-0x158(%rbp), %r15
     919: 48 8d 3c 29                  	leaq	(%rcx,%rbp), %rdi
     91d: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     924: 4c 89 e6                     	movq	%r12, %rsi
     927: 48 89 da                     	movq	%rbx, %rdx
     92a: e8 00 00 00 00               	callq	 <L23>
		000000000000092b:  R_X86_64_PLT32	memcpy-0x4
<L23>:
     92f: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     936: 4c 89 fe                     	movq	%r15, %rsi
     939: e8 62 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     93e: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     945: 31 c0                        	xorl	%eax, %eax
     947: eb 04                        	jmp	 <L26>
<L24>:
     949: 31 c0                        	xorl	%eax, %eax
<L25>:
     94b: 31 db                        	xorl	%ebx, %ebx
<L26>:
     94d: 49 01 dc                     	addq	%rbx, %r12
     950: 4d 89 ef                     	movq	%r13, %r15
     953: 49 29 df                     	subq	%rbx, %r15
     956: 48 8d 9d a8 fe ff ff         	leaq	-0x158(%rbp), %rbx
     95d: 0f b6 c0                     	movzbl	%al, %eax
     960: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     964: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     96b: 4c 89 e6                     	movq	%r12, %rsi
     96e: 4c 89 fa                     	movq	%r15, %rdx
     971: e8 00 00 00 00               	callq	 <L27>
		0000000000000972:  R_X86_64_PLT32	memcpy-0x4
<L27>:
     976: 0f b6 bd e8 fe ff ff         	movzbl	-0x118(%rbp), %edi
     97d: 4c 01 ff                     	addq	%r15, %rdi
     980: 40 88 bd e8 fe ff ff         	movb	%dil, -0x118(%rbp)
     987: 4c 03 ad a0 fe ff ff         	addq	-0x160(%rbp), %r13
     98e: 4c 89 ad a0 fe ff ff         	movq	%r13, -0x160(%rbp)
     995: 40 84 ff                     	testb	%dil, %dil
     998: 74 3f                        	je	 <L29>
     99a: 40 80 ff 3f                  	cmpb	$0x3f, %dil
     99e: 72 40                        	jb	 <L30>
     9a0: b0 40                        	movb	$0x40, %al
     9a2: 40 28 f8                     	subb	%dil, %al
     9a5: 44 0f b6 f8                  	movzbl	%al, %r15d
     9a9: 48 01 df                     	addq	%rbx, %rdi
     9ac: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     9b0: 4c 89 fa                     	movq	%r15, %rdx
     9b3: e8 00 00 00 00               	callq	 <L28>
		00000000000009b4:  R_X86_64_PLT32	memcpy-0x4
<L28>:
     9b8: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     9bf: 48 89 de                     	movq	%rbx, %rsi
     9c2: e8 d9 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     9c7: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     9ce: 31 ff                        	xorl	%edi, %edi
     9d0: 4c 8b a5 a0 fe ff ff         	movq	-0x160(%rbp), %r12
     9d7: eb 0d                        	jmp	 <L32>
<L29>:
     9d9: 4d 89 ec                     	movq	%r13, %r12
     9dc: 31 ff                        	xorl	%edi, %edi
     9de: eb 03                        	jmp	 <L31>
<L30>:
     9e0: 4d 89 ec                     	movq	%r13, %r12
<L31>:
     9e3: 45 31 ff                     	xorl	%r15d, %r15d
<L32>:
     9e6: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     9ea: 48 83 c6 d7                  	addq	$-0x29, %rsi
     9ee: 41 bd 01 00 00 00            	movl	$0x1, %r13d
     9f4: 4d 29 fd                     	subq	%r15, %r13
     9f7: 40 0f b6 c7                  	movzbl	%dil, %eax
     9fb: 48 01 c3                     	addq	%rax, %rbx
     9fe: 48 89 df                     	movq	%rbx, %rdi
     a01: 4c 89 ea                     	movq	%r13, %rdx
     a04: e8 00 00 00 00               	callq	 <L33>
		0000000000000a05:  R_X86_64_PLT32	memcpy-0x4
<L33>:
     a09: 44 00 ad e8 fe ff ff         	addb	%r13b, -0x118(%rbp)
     a10: 49 83 c4 01                  	addq	$0x1, %r12
     a14: 4c 89 a5 a0 fe ff ff         	movq	%r12, -0x160(%rbp)
     a1b: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     a22: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     a29: e8 52 01 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     a2e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x685>
		0000000000000a31:  R_X86_64_PC32	.rodata+0x5c
     a35: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     a39: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x690>
		0000000000000a3c:  R_X86_64_PC32	.rodata+0x4c
     a40: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     a44: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x69b>
		0000000000000a47:  R_X86_64_PC32	.rodata+0x3c
     a4b: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     a4f: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6a6>
		0000000000000a52:  R_X86_64_PC32	.rodata+0x2c
     a56: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     a5a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6b1>
		0000000000000a5d:  R_X86_64_PC32	.rodata+0x1c
     a61: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     a68: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6bf>
		0000000000000a6b:  R_X86_64_PC32	.rodata+0xc
     a6f: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     a76: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6cd>
		0000000000000a79:  R_X86_64_PC32	.rodata-0x4
     a7d: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     a84: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     a8b: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     a92: e8 09 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     a97: 0f b6 7d b8                  	movzbl	-0x48(%rbp), %edi
     a9b: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     aa2: 49 83 c5 40                  	addq	$0x40, %r13
     aa6: 48 8d 9d 78 ff ff ff         	leaq	-0x88(%rbp), %rbx
     aad: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     ab4: 4d 89 f4                     	movq	%r14, %r12
     ab7: 48 85 ff                     	testq	%rdi, %rdi
     aba: 74 3f                        	je	 <L35>
     abc: 40 80 ff 20                  	cmpb	$0x20, %dil
     ac0: 72 3b                        	jb	 <L36>
     ac2: 41 be 40 00 00 00            	movl	$0x40, %r14d
     ac8: 49 29 fe                     	subq	%rdi, %r14
     acb: 48 01 df                     	addq	%rbx, %rdi
     ace: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     ad5: 4c 89 f2                     	movq	%r14, %rdx
     ad8: e8 00 00 00 00               	callq	 <L34>
		0000000000000ad9:  R_X86_64_PLT32	memcpy-0x4
<L34>:
     add: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     ae4: 48 89 de                     	movq	%rbx, %rsi
     ae7: e8 b4 01 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     aec: c6 45 b8 00                  	movb	$0x0, -0x48(%rbp)
     af0: 31 ff                        	xorl	%edi, %edi
     af2: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     af9: eb 05                        	jmp	 <L37>
<L35>:
     afb: 31 ff                        	xorl	%edi, %edi
<L36>:
     afd: 45 31 f6                     	xorl	%r14d, %r14d
<L37>:
     b00: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
     b04: 48 81 c6 60 fe ff ff         	addq	$-0x1a0, %rsi           # imm = 0xFE60
     b0b: 41 bf 20 00 00 00            	movl	$0x20, %r15d
     b11: 4d 29 f7                     	subq	%r14, %r15
     b14: 40 0f b6 c7                  	movzbl	%dil, %eax
     b18: 48 01 c3                     	addq	%rax, %rbx
     b1b: 48 89 df                     	movq	%rbx, %rdi
     b1e: 4c 89 fa                     	movq	%r15, %rdx
     b21: e8 00 00 00 00               	callq	 <L38>
		0000000000000b22:  R_X86_64_PLT32	memcpy-0x4
<L38>:
     b26: 44 00 7d b8                  	addb	%r15b, -0x48(%rbp)
     b2a: 49 83 c5 20                  	addq	$0x20, %r13
     b2e: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     b35: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     b3c: 48 8d 9d 70 fd ff ff         	leaq	-0x290(%rbp), %rbx
     b43: 48 89 de                     	movq	%rbx, %rsi
     b46: e8 35 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     b4b: 4c 03 a5 40 ff ff ff         	addq	-0xc0(%rbp), %r12
     b52: 4c 89 e7                     	movq	%r12, %rdi
     b55: 48 89 de                     	movq	%rbx, %rsi
     b58: 48 8b 55 c8                  	movq	-0x38(%rbp), %rdx
     b5c: e8 00 00 00 00               	callq	 <L39>
		0000000000000b5d:  R_X86_64_PLT32	memcpy-0x4
<L39>:
     b61: 48 81 c4 68 02 00 00         	addq	$0x268, %rsp            # imm = 0x268
     b68: 5b                           	popq	%rbx
     b69: 41 5c                        	popq	%r12
     b6b: 41 5d                        	popq	%r13
     b6d: 41 5e                        	popq	%r14
     b6f: 41 5f                        	popq	%r15
     b71: 5d                           	popq	%rbp
     b72: c3                           	retq
     b73: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     b7d: 0f 1f 00                     	nopl	(%rax)

0000000000000b80 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     b80: 55                           	pushq	%rbp
     b81: 48 89 e5                     	movq	%rsp, %rbp
     b84: 41 57                        	pushq	%r15
     b86: 41 56                        	pushq	%r14
     b88: 53                           	pushq	%rbx
     b89: 50                           	pushq	%rax
     b8a: 48 89 f3                     	movq	%rsi, %rbx
     b8d: 49 89 fe                     	movq	%rdi, %r14
     b90: 4c 8d 7f 28                  	leaq	0x28(%rdi), %r15
     b94: 0f b6 47 68                  	movzbl	0x68(%rdi), %eax
     b98: 48 01 c7                     	addq	%rax, %rdi
     b9b: 48 83 c7 28                  	addq	$0x28, %rdi
     b9f: ba 40 00 00 00               	movl	$0x40, %edx
     ba4: 48 29 c2                     	subq	%rax, %rdx
     ba7: 31 f6                        	xorl	%esi, %esi
     ba9: e8 00 00 00 00               	callq	 <L0>
		0000000000000baa:  R_X86_64_PLT32	memset-0x4
<L0>:
     bae: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
     bb3: 41 c6 44 06 28 80            	movb	$-0x80, 0x28(%r14,%rax)
     bb9: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
     bbe: 8d 48 01                     	leal	0x1(%rax), %ecx
     bc1: 41 88 4e 68                  	movb	%cl, 0x68(%r14)
     bc5: 3c 37                        	cmpb	$0x37, %al
     bc7: 76 24                        	jbe	 <L1>
     bc9: 4c 89 f7                     	movq	%r14, %rdi
     bcc: 4c 89 fe                     	movq	%r15, %rsi
     bcf: e8 cc 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     bd4: 0f 57 c0                     	xorps	%xmm0, %xmm0
     bd7: 41 0f 11 47 20               	movups	%xmm0, 0x20(%r15)
     bdc: 41 0f 11 47 10               	movups	%xmm0, 0x10(%r15)
     be1: 41 0f 11 07                  	movups	%xmm0, (%r15)
     be5: 49 c7 47 30 00 00 00 00      	movq	$0x0, 0x30(%r15)
<L1>:
     bed: 49 8b 46 20                  	movq	0x20(%r14), %rax
     bf1: 89 c1                        	movl	%eax, %ecx
     bf3: c1 e9 05                     	shrl	$0x5, %ecx
     bf6: 8d 14 c5 00 00 00 00         	leal	(,%rax,8), %edx
     bfd: 41 88 56 67                  	movb	%dl, 0x67(%r14)
     c01: 41 88 4e 66                  	movb	%cl, 0x66(%r14)
     c05: 89 c1                        	movl	%eax, %ecx
     c07: c1 e9 0d                     	shrl	$0xd, %ecx
     c0a: 41 88 4e 65                  	movb	%cl, 0x65(%r14)
     c0e: 89 c1                        	movl	%eax, %ecx
     c10: c1 e9 15                     	shrl	$0x15, %ecx
     c13: 41 88 4e 64                  	movb	%cl, 0x64(%r14)
     c17: 48 89 c1                     	movq	%rax, %rcx
     c1a: 48 c1 e9 1d                  	shrq	$0x1d, %rcx
     c1e: 41 88 4e 63                  	movb	%cl, 0x63(%r14)
     c22: 48 89 c1                     	movq	%rax, %rcx
     c25: 48 c1 e9 25                  	shrq	$0x25, %rcx
     c29: 41 88 4e 62                  	movb	%cl, 0x62(%r14)
     c2d: 48 89 c1                     	movq	%rax, %rcx
     c30: 48 c1 e9 2d                  	shrq	$0x2d, %rcx
     c34: 41 88 4e 61                  	movb	%cl, 0x61(%r14)
     c38: 48 c1 e8 35                  	shrq	$0x35, %rax
     c3c: 41 88 46 60                  	movb	%al, 0x60(%r14)
     c40: 4c 89 f7                     	movq	%r14, %rdi
     c43: 4c 89 fe                     	movq	%r15, %rsi
     c46: e8 55 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     c4b: 41 8b 06                     	movl	(%r14), %eax
     c4e: 0f c8                        	bswapl	%eax
     c50: 89 03                        	movl	%eax, (%rbx)
     c52: 41 8b 46 04                  	movl	0x4(%r14), %eax
     c56: 0f c8                        	bswapl	%eax
     c58: 89 43 04                     	movl	%eax, 0x4(%rbx)
     c5b: 41 8b 46 08                  	movl	0x8(%r14), %eax
     c5f: 0f c8                        	bswapl	%eax
     c61: 89 43 08                     	movl	%eax, 0x8(%rbx)
     c64: 41 8b 46 0c                  	movl	0xc(%r14), %eax
     c68: 0f c8                        	bswapl	%eax
     c6a: 89 43 0c                     	movl	%eax, 0xc(%rbx)
     c6d: 41 8b 46 10                  	movl	0x10(%r14), %eax
     c71: 0f c8                        	bswapl	%eax
     c73: 89 43 10                     	movl	%eax, 0x10(%rbx)
     c76: 41 8b 46 14                  	movl	0x14(%r14), %eax
     c7a: 0f c8                        	bswapl	%eax
     c7c: 89 43 14                     	movl	%eax, 0x14(%rbx)
     c7f: 41 8b 46 18                  	movl	0x18(%r14), %eax
     c83: 0f c8                        	bswapl	%eax
     c85: 89 43 18                     	movl	%eax, 0x18(%rbx)
     c88: 41 8b 46 1c                  	movl	0x1c(%r14), %eax
     c8c: 0f c8                        	bswapl	%eax
     c8e: 89 43 1c                     	movl	%eax, 0x1c(%rbx)
     c91: 48 83 c4 08                  	addq	$0x8, %rsp
     c95: 5b                           	popq	%rbx
     c96: 41 5e                        	popq	%r14
     c98: 41 5f                        	popq	%r15
     c9a: 5d                           	popq	%rbp
     c9b: c3                           	retq
     c9c: 0f 1f 40 00                  	nopl	(%rax)

0000000000000ca0 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     ca0: 55                           	pushq	%rbp
     ca1: 48 89 e5                     	movq	%rsp, %rbp
     ca4: 41 57                        	pushq	%r15
     ca6: 41 56                        	pushq	%r14
     ca8: 41 55                        	pushq	%r13
     caa: 41 54                        	pushq	%r12
     cac: 53                           	pushq	%rbx
     cad: 48 81 ec 28 09 00 00         	subq	$0x928, %rsp            # imm = 0x928
     cb4: 48 89 bd c8 fe ff ff         	movq	%rdi, -0x138(%rbp)
     cbb: 4c 8d a5 d0 fe ff ff         	leaq	-0x130(%rbp), %r12
     cc2: f3 0f 6f 0e                  	movdqu	(%rsi), %xmm1
     cc6: 66 0f ef c0                  	pxor	%xmm0, %xmm0
     cca: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     cce: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     cd2: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     cd7: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     cdc: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     ce0: f2 0f 70 c9 1b               	pshuflw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[3,2,1,0,4,5,6,7]
     ce5: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
     cea: 66 0f 67 ca                  	packuswb	%xmm2, %xmm1
     cee: 66 0f 7f 8d b0 fe ff ff      	movdqa	%xmm1, -0x150(%rbp)
     cf6: 66 0f 7f 8d d0 fe ff ff      	movdqa	%xmm1, -0x130(%rbp)
     cfe: f3 0f 6f 4e 10               	movdqu	0x10(%rsi), %xmm1
     d03: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     d07: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     d0b: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     d10: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     d15: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     d19: f2 0f 70 c9 1b               	pshuflw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[3,2,1,0,4,5,6,7]
     d1e: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
     d23: 66 0f 67 ca                  	packuswb	%xmm2, %xmm1
     d27: 66 0f 7f 8d e0 fe ff ff      	movdqa	%xmm1, -0x120(%rbp)
     d2f: f3 0f 6f 4e 20               	movdqu	0x20(%rsi), %xmm1
     d34: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     d38: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     d3c: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     d41: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     d46: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     d4a: f2 0f 70 c9 1b               	pshuflw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[3,2,1,0,4,5,6,7]
     d4f: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
     d54: 66 0f 67 ca                  	packuswb	%xmm2, %xmm1
     d58: 66 0f 7f 8d f0 fe ff ff      	movdqa	%xmm1, -0x110(%rbp)
     d60: f3 0f 6f 4e 30               	movdqu	0x30(%rsi), %xmm1
     d65: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     d69: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     d6d: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     d72: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     d77: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     d7b: f2 0f 70 c1 1b               	pshuflw	$0x1b, %xmm1, %xmm0     # xmm0 = xmm1[3,2,1,0,4,5,6,7]
     d80: f3 0f 70 c0 1b               	pshufhw	$0x1b, %xmm0, %xmm0     # xmm0 = xmm0[0,1,2,3,7,6,5,4]
     d85: 66 0f 67 c2                  	packuswb	%xmm2, %xmm0
     d89: 66 0f 7f 85 00 ff ff ff      	movdqa	%xmm0, -0x100(%rbp)
     d91: 31 db                        	xorl	%ebx, %ebx
     d93: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     d9d: 0f 1f 00                     	nopl	(%rax)
<L0>:
     da0: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     da5: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     dac: 4c 89 e6                     	movq	%r12, %rsi
     daf: e8 00 00 00 00               	callq	 <L1>
		0000000000000db0:  R_X86_64_PLT32	memcpy-0x4
<L1>:
     db4: 44 8b b4 1d b0 fd ff ff      	movl	-0x250(%rbp,%rbx), %r14d
     dbc: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     dc1: 48 8d bd b0 fc ff ff         	leaq	-0x350(%rbp), %rdi
     dc8: 4c 89 e6                     	movq	%r12, %rsi
     dcb: e8 00 00 00 00               	callq	 <L2>
		0000000000000dcc:  R_X86_64_PLT32	memcpy-0x4
<L2>:
     dd0: 44 03 b4 1d d4 fc ff ff      	addl	-0x32c(%rbp,%rbx), %r14d
     dd8: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     ddd: 48 8d bd b0 fb ff ff         	leaq	-0x450(%rbp), %rdi
     de4: 4c 89 e6                     	movq	%r12, %rsi
     de7: e8 00 00 00 00               	callq	 <L3>
		0000000000000de8:  R_X86_64_PLT32	memcpy-0x4
<L3>:
     dec: 44 8b bc 1d b4 fb ff ff      	movl	-0x44c(%rbp,%rbx), %r15d
     df4: 41 c1 c7 19                  	roll	$0x19, %r15d
     df8: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     dfd: 48 8d bd b0 fa ff ff         	leaq	-0x550(%rbp), %rdi
     e04: 4c 89 e6                     	movq	%r12, %rsi
     e07: e8 00 00 00 00               	callq	 <L4>
		0000000000000e08:  R_X86_64_PLT32	memcpy-0x4
<L4>:
     e0c: 44 8b ac 1d b4 fa ff ff      	movl	-0x54c(%rbp,%rbx), %r13d
     e14: 41 c1 c5 0e                  	roll	$0xe, %r13d
     e18: 45 31 fd                     	xorl	%r15d, %r13d
     e1b: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e20: 48 8d bd b0 f9 ff ff         	leaq	-0x650(%rbp), %rdi
     e27: 4c 89 e6                     	movq	%r12, %rsi
     e2a: e8 00 00 00 00               	callq	 <L5>
		0000000000000e2b:  R_X86_64_PLT32	memcpy-0x4
<L5>:
     e2f: 44 8b bc 1d b4 f9 ff ff      	movl	-0x64c(%rbp,%rbx), %r15d
     e37: 41 c1 ef 03                  	shrl	$0x3, %r15d
     e3b: 45 31 ef                     	xorl	%r13d, %r15d
     e3e: 45 01 f7                     	addl	%r14d, %r15d
     e41: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e46: 48 8d bd b0 f8 ff ff         	leaq	-0x750(%rbp), %rdi
     e4d: 4c 89 e6                     	movq	%r12, %rsi
     e50: e8 00 00 00 00               	callq	 <L6>
		0000000000000e51:  R_X86_64_PLT32	memcpy-0x4
<L6>:
     e55: 44 8b b4 1d e8 f8 ff ff      	movl	-0x718(%rbp,%rbx), %r14d
     e5d: 41 c1 c6 0f                  	roll	$0xf, %r14d
     e61: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e66: 48 8d bd b0 f7 ff ff         	leaq	-0x850(%rbp), %rdi
     e6d: 4c 89 e6                     	movq	%r12, %rsi
     e70: e8 00 00 00 00               	callq	 <L7>
		0000000000000e71:  R_X86_64_PLT32	memcpy-0x4
<L7>:
     e75: 44 8b ac 1d e8 f7 ff ff      	movl	-0x818(%rbp,%rbx), %r13d
     e7d: 41 c1 c5 0d                  	roll	$0xd, %r13d
     e81: 45 31 f5                     	xorl	%r14d, %r13d
     e84: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e89: 48 8d bd b0 f6 ff ff         	leaq	-0x950(%rbp), %rdi
     e90: 4c 89 e6                     	movq	%r12, %rsi
     e93: e8 00 00 00 00               	callq	 <L8>
		0000000000000e94:  R_X86_64_PLT32	memcpy-0x4
<L8>:
     e98: 8b 84 1d e8 f6 ff ff         	movl	-0x918(%rbp,%rbx), %eax
     e9f: c1 e8 0a                     	shrl	$0xa, %eax
     ea2: 44 31 e8                     	xorl	%r13d, %eax
     ea5: 44 01 f8                     	addl	%r15d, %eax
     ea8: 89 84 1d 10 ff ff ff         	movl	%eax, -0xf0(%rbp,%rbx)
     eaf: 48 83 c3 04                  	addq	$0x4, %rbx
     eb3: 48 81 fb c0 00 00 00         	cmpq	$0xc0, %rbx
     eba: 0f 85 e0 fe ff ff            	jne	 <L0>
     ec0: 4c 8b ad c8 fe ff ff         	movq	-0x138(%rbp), %r13
     ec7: 41 8b 7d 00                  	movl	(%r13), %edi
     ecb: 45 8b 5d 04                  	movl	0x4(%r13), %r11d
     ecf: 45 8b 4d 08                  	movl	0x8(%r13), %r9d
     ed3: 45 8b 55 10                  	movl	0x10(%r13), %r10d
     ed7: 41 8b 4d 14                  	movl	0x14(%r13), %ecx
     edb: 41 8b 75 18                  	movl	0x18(%r13), %esi
     edf: 44 89 d0                     	movl	%r10d, %eax
     ee2: c1 c0 1a                     	roll	$0x1a, %eax
     ee5: 44 89 d2                     	movl	%r10d, %edx
     ee8: c1 c2 15                     	roll	$0x15, %edx
     eeb: 31 c2                        	xorl	%eax, %edx
     eed: 44 89 d0                     	movl	%r10d, %eax
     ef0: c1 c0 07                     	roll	$0x7, %eax
     ef3: 31 d0                        	xorl	%edx, %eax
     ef5: 89 f2                        	movl	%esi, %edx
     ef7: 31 ca                        	xorl	%ecx, %edx
     ef9: 44 21 d2                     	andl	%r10d, %edx
     efc: 41 03 45 1c                  	addl	0x1c(%r13), %eax
     f00: 31 f2                        	xorl	%esi, %edx
     f02: 66 0f 6f 85 b0 fe ff ff      	movdqa	-0x150(%rbp), %xmm0
     f0a: 66 41 0f 7e c0               	movd	%xmm0, %r8d
     f0f: 41 01 c0                     	addl	%eax, %r8d
     f12: 42 8d 1c 02                  	leal	(%rdx,%r8), %ebx
     f16: 81 c3 98 2f 8a 42            	addl	$0x428a2f98, %ebx       # imm = 0x428A2F98
     f1c: 41 8b 55 0c                  	movl	0xc(%r13), %edx
     f20: 89 f8                        	movl	%edi, %eax
     f22: c1 c0 1e                     	roll	$0x1e, %eax
     f25: 01 da                        	addl	%ebx, %edx
     f27: 41 89 f8                     	movl	%edi, %r8d
     f2a: 41 c1 c0 13                  	roll	$0x13, %r8d
     f2e: 41 31 c0                     	xorl	%eax, %r8d
     f31: 41 89 fe                     	movl	%edi, %r14d
     f34: 41 c1 c6 0a                  	roll	$0xa, %r14d
     f38: 45 31 c6                     	xorl	%r8d, %r14d
     f3b: 41 89 d0                     	movl	%edx, %r8d
     f3e: 41 c1 c0 1a                  	roll	$0x1a, %r8d
     f42: 44 89 c8                     	movl	%r9d, %eax
     f45: 41 89 d4                     	movl	%edx, %r12d
     f48: 41 c1 c4 15                  	roll	$0x15, %r12d
     f4c: 45 31 c4                     	xorl	%r8d, %r12d
     f4f: 41 89 d7                     	movl	%edx, %r15d
     f52: 41 c1 c7 07                  	roll	$0x7, %r15d
     f56: 45 31 e7                     	xorl	%r12d, %r15d
     f59: 41 89 c8                     	movl	%ecx, %r8d
     f5c: 45 31 d0                     	xorl	%r10d, %r8d
     f5f: 41 21 d0                     	andl	%edx, %r8d
     f62: 41 31 c8                     	xorl	%ecx, %r8d
     f65: 03 b5 d4 fe ff ff            	addl	-0x12c(%rbp), %esi
     f6b: 44 01 c6                     	addl	%r8d, %esi
     f6e: 46 8d 04 3e                  	leal	(%rsi,%r15), %r8d
     f72: 45 01 c8                     	addl	%r9d, %r8d
     f75: 41 81 c0 91 44 37 71         	addl	$0x71374491, %r8d       # imm = 0x71374491
     f7c: 45 09 d9                     	orl	%r11d, %r9d
     f7f: 41 21 f9                     	andl	%edi, %r9d
     f82: 44 21 d8                     	andl	%r11d, %eax
     f85: 44 09 c8                     	orl	%r9d, %eax
     f88: 44 01 f0                     	addl	%r14d, %eax
     f8b: 01 d8                        	addl	%ebx, %eax
     f8d: 41 89 c1                     	movl	%eax, %r9d
     f90: 41 c1 c1 1e                  	roll	$0x1e, %r9d
     f94: 41 8d 1c 37                  	leal	(%r15,%rsi), %ebx
     f98: 81 c3 91 44 37 71            	addl	$0x71374491, %ebx       # imm = 0x71374491
     f9e: 89 c6                        	movl	%eax, %esi
     fa0: c1 c6 13                     	roll	$0x13, %esi
     fa3: 44 31 ce                     	xorl	%r9d, %esi
     fa6: 41 89 c6                     	movl	%eax, %r14d
     fa9: 41 c1 c6 0a                  	roll	$0xa, %r14d
     fad: 41 31 f6                     	xorl	%esi, %r14d
     fb0: 45 89 c1                     	movl	%r8d, %r9d
     fb3: 41 c1 c1 1a                  	roll	$0x1a, %r9d
     fb7: 44 89 de                     	movl	%r11d, %esi
     fba: 45 89 c4                     	movl	%r8d, %r12d
     fbd: 41 c1 c4 15                  	roll	$0x15, %r12d
     fc1: 45 31 cc                     	xorl	%r9d, %r12d
     fc4: 45 89 c7                     	movl	%r8d, %r15d
     fc7: 41 c1 c7 07                  	roll	$0x7, %r15d
     fcb: 45 31 e7                     	xorl	%r12d, %r15d
     fce: 41 89 d1                     	movl	%edx, %r9d
     fd1: 45 31 d1                     	xorl	%r10d, %r9d
     fd4: 45 21 c1                     	andl	%r8d, %r9d
     fd7: 45 31 d1                     	xorl	%r10d, %r9d
     fda: 03 8d d8 fe ff ff            	addl	-0x128(%rbp), %ecx
     fe0: 44 01 c9                     	addl	%r9d, %ecx
     fe3: 46 8d 0c 39                  	leal	(%rcx,%r15), %r9d
     fe7: 45 01 d9                     	addl	%r11d, %r9d
     fea: 41 81 c1 cf fb c0 b5         	addl	$0xb5c0fbcf, %r9d       # imm = 0xB5C0FBCF
     ff1: 41 09 fb                     	orl	%edi, %r11d
     ff4: 41 21 c3                     	andl	%eax, %r11d
     ff7: 21 fe                        	andl	%edi, %esi
     ff9: 44 09 de                     	orl	%r11d, %esi
     ffc: 44 01 f6                     	addl	%r14d, %esi
     fff: 01 de                        	addl	%ebx, %esi
    1001: 41 89 f3                     	movl	%esi, %r11d
    1004: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    1008: 41 8d 1c 0f                  	leal	(%r15,%rcx), %ebx
    100c: 81 c3 cf fb c0 b5            	addl	$0xb5c0fbcf, %ebx       # imm = 0xB5C0FBCF
    1012: 89 f1                        	movl	%esi, %ecx
    1014: c1 c1 13                     	roll	$0x13, %ecx
    1017: 44 31 d9                     	xorl	%r11d, %ecx
    101a: 41 89 f3                     	movl	%esi, %r11d
    101d: 41 c1 c3 0a                  	roll	$0xa, %r11d
    1021: 41 31 cb                     	xorl	%ecx, %r11d
    1024: 41 89 c6                     	movl	%eax, %r14d
    1027: 41 09 fe                     	orl	%edi, %r14d
    102a: 41 21 f6                     	andl	%esi, %r14d
    102d: 89 c1                        	movl	%eax, %ecx
    102f: 21 f9                        	andl	%edi, %ecx
    1031: 44 09 f1                     	orl	%r14d, %ecx
    1034: 44 01 d9                     	addl	%r11d, %ecx
    1037: 01 d9                        	addl	%ebx, %ecx
    1039: 45 89 cb                     	movl	%r9d, %r11d
    103c: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1040: 44 89 cb                     	movl	%r9d, %ebx
    1043: c1 c3 15                     	roll	$0x15, %ebx
    1046: 44 31 db                     	xorl	%r11d, %ebx
    1049: 45 89 cb                     	movl	%r9d, %r11d
    104c: 41 c1 c3 07                  	roll	$0x7, %r11d
    1050: 41 31 db                     	xorl	%ebx, %r11d
    1053: 44 89 c3                     	movl	%r8d, %ebx
    1056: 31 d3                        	xorl	%edx, %ebx
    1058: 44 21 cb                     	andl	%r9d, %ebx
    105b: 31 d3                        	xorl	%edx, %ebx
    105d: 44 03 95 dc fe ff ff         	addl	-0x124(%rbp), %r10d
    1064: 41 01 da                     	addl	%ebx, %r10d
    1067: 43 8d 1c 1a                  	leal	(%r10,%r11), %ebx
    106b: 47 8d 34 13                  	leal	(%r11,%r10), %r14d
    106f: 41 81 c6 a5 db b5 e9         	addl	$0xe9b5dba5, %r14d      # imm = 0xE9B5DBA5
    1076: 41 89 ca                     	movl	%ecx, %r10d
    1079: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    107d: 44 8d 1c 1f                  	leal	(%rdi,%rbx), %r11d
    1081: 41 81 c3 a5 db b5 e9         	addl	$0xe9b5dba5, %r11d      # imm = 0xE9B5DBA5
    1088: 89 cf                        	movl	%ecx, %edi
    108a: c1 c7 13                     	roll	$0x13, %edi
    108d: 44 31 d7                     	xorl	%r10d, %edi
    1090: 89 cb                        	movl	%ecx, %ebx
    1092: c1 c3 0a                     	roll	$0xa, %ebx
    1095: 31 fb                        	xorl	%edi, %ebx
    1097: 89 f7                        	movl	%esi, %edi
    1099: 09 c7                        	orl	%eax, %edi
    109b: 21 cf                        	andl	%ecx, %edi
    109d: 41 89 f2                     	movl	%esi, %r10d
    10a0: 41 21 c2                     	andl	%eax, %r10d
    10a3: 41 09 fa                     	orl	%edi, %r10d
    10a6: 41 01 da                     	addl	%ebx, %r10d
    10a9: 45 01 f2                     	addl	%r14d, %r10d
    10ac: 44 89 df                     	movl	%r11d, %edi
    10af: c1 c7 1a                     	roll	$0x1a, %edi
    10b2: 44 89 db                     	movl	%r11d, %ebx
    10b5: c1 c3 15                     	roll	$0x15, %ebx
    10b8: 31 fb                        	xorl	%edi, %ebx
    10ba: 44 89 df                     	movl	%r11d, %edi
    10bd: c1 c7 07                     	roll	$0x7, %edi
    10c0: 31 df                        	xorl	%ebx, %edi
    10c2: 44 89 cb                     	movl	%r9d, %ebx
    10c5: 44 31 c3                     	xorl	%r8d, %ebx
    10c8: 44 21 db                     	andl	%r11d, %ebx
    10cb: 44 31 c3                     	xorl	%r8d, %ebx
    10ce: 03 95 e0 fe ff ff            	addl	-0x120(%rbp), %edx
    10d4: 01 da                        	addl	%ebx, %edx
    10d6: 01 fa                        	addl	%edi, %edx
    10d8: 81 c2 5b c2 56 39            	addl	$0x3956c25b, %edx       # imm = 0x3956C25B
    10de: 01 d0                        	addl	%edx, %eax
    10e0: 44 89 d7                     	movl	%r10d, %edi
    10e3: c1 c7 1e                     	roll	$0x1e, %edi
    10e6: 44 89 d3                     	movl	%r10d, %ebx
    10e9: c1 c3 13                     	roll	$0x13, %ebx
    10ec: 31 fb                        	xorl	%edi, %ebx
    10ee: 45 89 d6                     	movl	%r10d, %r14d
    10f1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    10f5: 41 31 de                     	xorl	%ebx, %r14d
    10f8: 89 cb                        	movl	%ecx, %ebx
    10fa: 09 f3                        	orl	%esi, %ebx
    10fc: 44 21 d3                     	andl	%r10d, %ebx
    10ff: 89 cf                        	movl	%ecx, %edi
    1101: 21 f7                        	andl	%esi, %edi
    1103: 09 df                        	orl	%ebx, %edi
    1105: 44 01 f7                     	addl	%r14d, %edi
    1108: 01 d7                        	addl	%edx, %edi
    110a: 89 c2                        	movl	%eax, %edx
    110c: c1 c2 1a                     	roll	$0x1a, %edx
    110f: 89 c3                        	movl	%eax, %ebx
    1111: c1 c3 15                     	roll	$0x15, %ebx
    1114: 31 d3                        	xorl	%edx, %ebx
    1116: 89 c2                        	movl	%eax, %edx
    1118: c1 c2 07                     	roll	$0x7, %edx
    111b: 31 da                        	xorl	%ebx, %edx
    111d: 44 89 db                     	movl	%r11d, %ebx
    1120: 44 31 cb                     	xorl	%r9d, %ebx
    1123: 21 c3                        	andl	%eax, %ebx
    1125: 44 03 85 e4 fe ff ff         	addl	-0x11c(%rbp), %r8d
    112c: 44 31 cb                     	xorl	%r9d, %ebx
    112f: 41 01 d8                     	addl	%ebx, %r8d
    1132: 44 01 c2                     	addl	%r8d, %edx
    1135: 81 c2 f1 11 f1 59            	addl	$0x59f111f1, %edx       # imm = 0x59F111F1
    113b: 01 d6                        	addl	%edx, %esi
    113d: 41 89 f8                     	movl	%edi, %r8d
    1140: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1144: 89 fb                        	movl	%edi, %ebx
    1146: c1 c3 13                     	roll	$0x13, %ebx
    1149: 44 31 c3                     	xorl	%r8d, %ebx
    114c: 41 89 fe                     	movl	%edi, %r14d
    114f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1153: 41 31 de                     	xorl	%ebx, %r14d
    1156: 44 89 d3                     	movl	%r10d, %ebx
    1159: 09 cb                        	orl	%ecx, %ebx
    115b: 21 fb                        	andl	%edi, %ebx
    115d: 45 89 d0                     	movl	%r10d, %r8d
    1160: 41 21 c8                     	andl	%ecx, %r8d
    1163: 41 09 d8                     	orl	%ebx, %r8d
    1166: 89 f3                        	movl	%esi, %ebx
    1168: c1 c3 1a                     	roll	$0x1a, %ebx
    116b: 45 01 f0                     	addl	%r14d, %r8d
    116e: 41 89 f6                     	movl	%esi, %r14d
    1171: 41 c1 c6 15                  	roll	$0x15, %r14d
    1175: 41 01 d0                     	addl	%edx, %r8d
    1178: 89 f2                        	movl	%esi, %edx
    117a: c1 c2 07                     	roll	$0x7, %edx
    117d: 41 31 de                     	xorl	%ebx, %r14d
    1180: 44 31 f2                     	xorl	%r14d, %edx
    1183: 89 c3                        	movl	%eax, %ebx
    1185: 44 31 db                     	xorl	%r11d, %ebx
    1188: 21 f3                        	andl	%esi, %ebx
    118a: 44 31 db                     	xorl	%r11d, %ebx
    118d: 44 03 8d e8 fe ff ff         	addl	-0x118(%rbp), %r9d
    1194: 41 01 d9                     	addl	%ebx, %r9d
    1197: 44 89 c3                     	movl	%r8d, %ebx
    119a: c1 c3 1e                     	roll	$0x1e, %ebx
    119d: 41 01 d1                     	addl	%edx, %r9d
    11a0: 41 81 c1 a4 82 3f 92         	addl	$0x923f82a4, %r9d       # imm = 0x923F82A4
    11a7: 44 89 c2                     	movl	%r8d, %edx
    11aa: c1 c2 13                     	roll	$0x13, %edx
    11ad: 44 01 c9                     	addl	%r9d, %ecx
    11b0: 45 89 c6                     	movl	%r8d, %r14d
    11b3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    11b7: 31 da                        	xorl	%ebx, %edx
    11b9: 41 31 d6                     	xorl	%edx, %r14d
    11bc: 89 fb                        	movl	%edi, %ebx
    11be: 44 09 d3                     	orl	%r10d, %ebx
    11c1: 44 21 c3                     	andl	%r8d, %ebx
    11c4: 89 fa                        	movl	%edi, %edx
    11c6: 44 21 d2                     	andl	%r10d, %edx
    11c9: 09 da                        	orl	%ebx, %edx
    11cb: 44 01 f2                     	addl	%r14d, %edx
    11ce: 89 cb                        	movl	%ecx, %ebx
    11d0: c1 c3 1a                     	roll	$0x1a, %ebx
    11d3: 44 01 ca                     	addl	%r9d, %edx
    11d6: 41 89 c9                     	movl	%ecx, %r9d
    11d9: 41 c1 c1 15                  	roll	$0x15, %r9d
    11dd: 41 31 d9                     	xorl	%ebx, %r9d
    11e0: 89 cb                        	movl	%ecx, %ebx
    11e2: c1 c3 07                     	roll	$0x7, %ebx
    11e5: 44 31 cb                     	xorl	%r9d, %ebx
    11e8: 41 89 f1                     	movl	%esi, %r9d
    11eb: 41 31 c1                     	xorl	%eax, %r9d
    11ee: 41 21 c9                     	andl	%ecx, %r9d
    11f1: 41 31 c1                     	xorl	%eax, %r9d
    11f4: 44 03 9d ec fe ff ff         	addl	-0x114(%rbp), %r11d
    11fb: 45 01 cb                     	addl	%r9d, %r11d
    11fe: 46 8d 0c 1b                  	leal	(%rbx,%r11), %r9d
    1202: 41 81 c1 d5 5e 1c ab         	addl	$0xab1c5ed5, %r9d       # imm = 0xAB1C5ED5
    1209: 41 89 d3                     	movl	%edx, %r11d
    120c: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    1210: 45 01 ca                     	addl	%r9d, %r10d
    1213: 89 d3                        	movl	%edx, %ebx
    1215: c1 c3 13                     	roll	$0x13, %ebx
    1218: 44 31 db                     	xorl	%r11d, %ebx
    121b: 41 89 d6                     	movl	%edx, %r14d
    121e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1222: 41 31 de                     	xorl	%ebx, %r14d
    1225: 44 89 c3                     	movl	%r8d, %ebx
    1228: 09 fb                        	orl	%edi, %ebx
    122a: 21 d3                        	andl	%edx, %ebx
    122c: 45 89 c3                     	movl	%r8d, %r11d
    122f: 41 21 fb                     	andl	%edi, %r11d
    1232: 41 09 db                     	orl	%ebx, %r11d
    1235: 45 01 f3                     	addl	%r14d, %r11d
    1238: 45 01 cb                     	addl	%r9d, %r11d
    123b: 45 89 d1                     	movl	%r10d, %r9d
    123e: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    1242: 44 89 d3                     	movl	%r10d, %ebx
    1245: c1 c3 15                     	roll	$0x15, %ebx
    1248: 44 31 cb                     	xorl	%r9d, %ebx
    124b: 45 89 d1                     	movl	%r10d, %r9d
    124e: 41 c1 c1 07                  	roll	$0x7, %r9d
    1252: 41 31 d9                     	xorl	%ebx, %r9d
    1255: 89 cb                        	movl	%ecx, %ebx
    1257: 31 f3                        	xorl	%esi, %ebx
    1259: 44 21 d3                     	andl	%r10d, %ebx
    125c: 31 f3                        	xorl	%esi, %ebx
    125e: 03 85 f0 fe ff ff            	addl	-0x110(%rbp), %eax
    1264: 01 d8                        	addl	%ebx, %eax
    1266: 44 01 c8                     	addl	%r9d, %eax
    1269: 05 98 aa 07 d8               	addl	$0xd807aa98, %eax       # imm = 0xD807AA98
    126e: 01 c7                        	addl	%eax, %edi
    1270: 45 89 d9                     	movl	%r11d, %r9d
    1273: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1277: 44 89 db                     	movl	%r11d, %ebx
    127a: c1 c3 13                     	roll	$0x13, %ebx
    127d: 44 31 cb                     	xorl	%r9d, %ebx
    1280: 45 89 de                     	movl	%r11d, %r14d
    1283: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1287: 41 31 de                     	xorl	%ebx, %r14d
    128a: 89 d3                        	movl	%edx, %ebx
    128c: 44 09 c3                     	orl	%r8d, %ebx
    128f: 44 21 db                     	andl	%r11d, %ebx
    1292: 41 89 d1                     	movl	%edx, %r9d
    1295: 45 21 c1                     	andl	%r8d, %r9d
    1298: 41 09 d9                     	orl	%ebx, %r9d
    129b: 45 01 f1                     	addl	%r14d, %r9d
    129e: 41 01 c1                     	addl	%eax, %r9d
    12a1: 89 f8                        	movl	%edi, %eax
    12a3: c1 c0 1a                     	roll	$0x1a, %eax
    12a6: 89 fb                        	movl	%edi, %ebx
    12a8: c1 c3 15                     	roll	$0x15, %ebx
    12ab: 31 c3                        	xorl	%eax, %ebx
    12ad: 89 f8                        	movl	%edi, %eax
    12af: c1 c0 07                     	roll	$0x7, %eax
    12b2: 31 d8                        	xorl	%ebx, %eax
    12b4: 44 89 d3                     	movl	%r10d, %ebx
    12b7: 31 cb                        	xorl	%ecx, %ebx
    12b9: 21 fb                        	andl	%edi, %ebx
    12bb: 03 b5 f4 fe ff ff            	addl	-0x10c(%rbp), %esi
    12c1: 31 cb                        	xorl	%ecx, %ebx
    12c3: 01 de                        	addl	%ebx, %esi
    12c5: 01 f0                        	addl	%esi, %eax
    12c7: 05 01 5b 83 12               	addl	$0x12835b01, %eax       # imm = 0x12835B01
    12cc: 41 01 c0                     	addl	%eax, %r8d
    12cf: 44 89 ce                     	movl	%r9d, %esi
    12d2: c1 c6 1e                     	roll	$0x1e, %esi
    12d5: 44 89 cb                     	movl	%r9d, %ebx
    12d8: c1 c3 13                     	roll	$0x13, %ebx
    12db: 31 f3                        	xorl	%esi, %ebx
    12dd: 45 89 ce                     	movl	%r9d, %r14d
    12e0: 41 c1 c6 0a                  	roll	$0xa, %r14d
    12e4: 41 31 de                     	xorl	%ebx, %r14d
    12e7: 44 89 db                     	movl	%r11d, %ebx
    12ea: 09 d3                        	orl	%edx, %ebx
    12ec: 44 21 cb                     	andl	%r9d, %ebx
    12ef: 44 89 de                     	movl	%r11d, %esi
    12f2: 21 d6                        	andl	%edx, %esi
    12f4: 09 de                        	orl	%ebx, %esi
    12f6: 44 89 c3                     	movl	%r8d, %ebx
    12f9: c1 c3 1a                     	roll	$0x1a, %ebx
    12fc: 44 01 f6                     	addl	%r14d, %esi
    12ff: 45 89 c6                     	movl	%r8d, %r14d
    1302: 41 c1 c6 15                  	roll	$0x15, %r14d
    1306: 01 c6                        	addl	%eax, %esi
    1308: 44 89 c0                     	movl	%r8d, %eax
    130b: c1 c0 07                     	roll	$0x7, %eax
    130e: 41 31 de                     	xorl	%ebx, %r14d
    1311: 44 31 f0                     	xorl	%r14d, %eax
    1314: 89 fb                        	movl	%edi, %ebx
    1316: 44 31 d3                     	xorl	%r10d, %ebx
    1319: 44 21 c3                     	andl	%r8d, %ebx
    131c: 44 31 d3                     	xorl	%r10d, %ebx
    131f: 03 8d f8 fe ff ff            	addl	-0x108(%rbp), %ecx
    1325: 01 d9                        	addl	%ebx, %ecx
    1327: 89 f3                        	movl	%esi, %ebx
    1329: c1 c3 1e                     	roll	$0x1e, %ebx
    132c: 01 c1                        	addl	%eax, %ecx
    132e: 81 c1 be 85 31 24            	addl	$0x243185be, %ecx       # imm = 0x243185BE
    1334: 89 f0                        	movl	%esi, %eax
    1336: c1 c0 13                     	roll	$0x13, %eax
    1339: 01 ca                        	addl	%ecx, %edx
    133b: 41 89 f6                     	movl	%esi, %r14d
    133e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1342: 31 d8                        	xorl	%ebx, %eax
    1344: 41 31 c6                     	xorl	%eax, %r14d
    1347: 44 89 cb                     	movl	%r9d, %ebx
    134a: 44 09 db                     	orl	%r11d, %ebx
    134d: 21 f3                        	andl	%esi, %ebx
    134f: 44 89 c8                     	movl	%r9d, %eax
    1352: 44 21 d8                     	andl	%r11d, %eax
    1355: 09 d8                        	orl	%ebx, %eax
    1357: 44 01 f0                     	addl	%r14d, %eax
    135a: 89 d3                        	movl	%edx, %ebx
    135c: c1 c3 1a                     	roll	$0x1a, %ebx
    135f: 01 c8                        	addl	%ecx, %eax
    1361: 89 d1                        	movl	%edx, %ecx
    1363: c1 c1 15                     	roll	$0x15, %ecx
    1366: 31 d9                        	xorl	%ebx, %ecx
    1368: 89 d3                        	movl	%edx, %ebx
    136a: c1 c3 07                     	roll	$0x7, %ebx
    136d: 31 cb                        	xorl	%ecx, %ebx
    136f: 44 89 c1                     	movl	%r8d, %ecx
    1372: 31 f9                        	xorl	%edi, %ecx
    1374: 21 d1                        	andl	%edx, %ecx
    1376: 31 f9                        	xorl	%edi, %ecx
    1378: 44 03 95 fc fe ff ff         	addl	-0x104(%rbp), %r10d
    137f: 41 01 ca                     	addl	%ecx, %r10d
    1382: 42 8d 0c 13                  	leal	(%rbx,%r10), %ecx
    1386: 81 c1 c3 7d 0c 55            	addl	$0x550c7dc3, %ecx       # imm = 0x550C7DC3
    138c: 41 89 c2                     	movl	%eax, %r10d
    138f: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1393: 41 01 cb                     	addl	%ecx, %r11d
    1396: 89 c3                        	movl	%eax, %ebx
    1398: c1 c3 13                     	roll	$0x13, %ebx
    139b: 44 31 d3                     	xorl	%r10d, %ebx
    139e: 41 89 c6                     	movl	%eax, %r14d
    13a1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    13a5: 41 31 de                     	xorl	%ebx, %r14d
    13a8: 89 f3                        	movl	%esi, %ebx
    13aa: 44 09 cb                     	orl	%r9d, %ebx
    13ad: 21 c3                        	andl	%eax, %ebx
    13af: 41 89 f2                     	movl	%esi, %r10d
    13b2: 45 21 ca                     	andl	%r9d, %r10d
    13b5: 41 09 da                     	orl	%ebx, %r10d
    13b8: 45 01 f2                     	addl	%r14d, %r10d
    13bb: 41 01 ca                     	addl	%ecx, %r10d
    13be: 44 89 d9                     	movl	%r11d, %ecx
    13c1: c1 c1 1a                     	roll	$0x1a, %ecx
    13c4: 44 89 db                     	movl	%r11d, %ebx
    13c7: c1 c3 15                     	roll	$0x15, %ebx
    13ca: 31 cb                        	xorl	%ecx, %ebx
    13cc: 44 89 d9                     	movl	%r11d, %ecx
    13cf: c1 c1 07                     	roll	$0x7, %ecx
    13d2: 31 d9                        	xorl	%ebx, %ecx
    13d4: 89 d3                        	movl	%edx, %ebx
    13d6: 44 31 c3                     	xorl	%r8d, %ebx
    13d9: 44 21 db                     	andl	%r11d, %ebx
    13dc: 44 31 c3                     	xorl	%r8d, %ebx
    13df: 03 bd 00 ff ff ff            	addl	-0x100(%rbp), %edi
    13e5: 01 df                        	addl	%ebx, %edi
    13e7: 01 f9                        	addl	%edi, %ecx
    13e9: 81 c1 74 5d be 72            	addl	$0x72be5d74, %ecx       # imm = 0x72BE5D74
    13ef: 41 01 c9                     	addl	%ecx, %r9d
    13f2: 44 89 d7                     	movl	%r10d, %edi
    13f5: c1 c7 1e                     	roll	$0x1e, %edi
    13f8: 44 89 d3                     	movl	%r10d, %ebx
    13fb: c1 c3 13                     	roll	$0x13, %ebx
    13fe: 31 fb                        	xorl	%edi, %ebx
    1400: 45 89 d6                     	movl	%r10d, %r14d
    1403: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1407: 41 31 de                     	xorl	%ebx, %r14d
    140a: 89 c3                        	movl	%eax, %ebx
    140c: 09 f3                        	orl	%esi, %ebx
    140e: 44 21 d3                     	andl	%r10d, %ebx
    1411: 89 c7                        	movl	%eax, %edi
    1413: 21 f7                        	andl	%esi, %edi
    1415: 09 df                        	orl	%ebx, %edi
    1417: 44 01 f7                     	addl	%r14d, %edi
    141a: 01 cf                        	addl	%ecx, %edi
    141c: 44 89 c9                     	movl	%r9d, %ecx
    141f: c1 c1 1a                     	roll	$0x1a, %ecx
    1422: 44 89 cb                     	movl	%r9d, %ebx
    1425: c1 c3 15                     	roll	$0x15, %ebx
    1428: 31 cb                        	xorl	%ecx, %ebx
    142a: 44 89 c9                     	movl	%r9d, %ecx
    142d: c1 c1 07                     	roll	$0x7, %ecx
    1430: 31 d9                        	xorl	%ebx, %ecx
    1432: 44 89 db                     	movl	%r11d, %ebx
    1435: 31 d3                        	xorl	%edx, %ebx
    1437: 44 21 cb                     	andl	%r9d, %ebx
    143a: 44 03 85 04 ff ff ff         	addl	-0xfc(%rbp), %r8d
    1441: 31 d3                        	xorl	%edx, %ebx
    1443: 41 01 d8                     	addl	%ebx, %r8d
    1446: 44 01 c1                     	addl	%r8d, %ecx
    1449: 81 c1 fe b1 de 80            	addl	$0x80deb1fe, %ecx       # imm = 0x80DEB1FE
    144f: 01 ce                        	addl	%ecx, %esi
    1451: 41 89 f8                     	movl	%edi, %r8d
    1454: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1458: 89 fb                        	movl	%edi, %ebx
    145a: c1 c3 13                     	roll	$0x13, %ebx
    145d: 44 31 c3                     	xorl	%r8d, %ebx
    1460: 41 89 fe                     	movl	%edi, %r14d
    1463: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1467: 41 31 de                     	xorl	%ebx, %r14d
    146a: 44 89 d3                     	movl	%r10d, %ebx
    146d: 09 c3                        	orl	%eax, %ebx
    146f: 21 fb                        	andl	%edi, %ebx
    1471: 45 89 d0                     	movl	%r10d, %r8d
    1474: 41 21 c0                     	andl	%eax, %r8d
    1477: 41 09 d8                     	orl	%ebx, %r8d
    147a: 89 f3                        	movl	%esi, %ebx
    147c: c1 c3 1a                     	roll	$0x1a, %ebx
    147f: 45 01 f0                     	addl	%r14d, %r8d
    1482: 41 89 f6                     	movl	%esi, %r14d
    1485: 41 c1 c6 15                  	roll	$0x15, %r14d
    1489: 41 01 c8                     	addl	%ecx, %r8d
    148c: 89 f1                        	movl	%esi, %ecx
    148e: c1 c1 07                     	roll	$0x7, %ecx
    1491: 41 31 de                     	xorl	%ebx, %r14d
    1494: 44 31 f1                     	xorl	%r14d, %ecx
    1497: 44 89 cb                     	movl	%r9d, %ebx
    149a: 44 31 db                     	xorl	%r11d, %ebx
    149d: 21 f3                        	andl	%esi, %ebx
    149f: 44 31 db                     	xorl	%r11d, %ebx
    14a2: 03 95 08 ff ff ff            	addl	-0xf8(%rbp), %edx
    14a8: 01 da                        	addl	%ebx, %edx
    14aa: 44 89 c3                     	movl	%r8d, %ebx
    14ad: c1 c3 1e                     	roll	$0x1e, %ebx
    14b0: 01 ca                        	addl	%ecx, %edx
    14b2: 81 c2 a7 06 dc 9b            	addl	$0x9bdc06a7, %edx       # imm = 0x9BDC06A7
    14b8: 44 89 c1                     	movl	%r8d, %ecx
    14bb: c1 c1 13                     	roll	$0x13, %ecx
    14be: 01 d0                        	addl	%edx, %eax
    14c0: 45 89 c6                     	movl	%r8d, %r14d
    14c3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    14c7: 31 d9                        	xorl	%ebx, %ecx
    14c9: 41 31 ce                     	xorl	%ecx, %r14d
    14cc: 89 fb                        	movl	%edi, %ebx
    14ce: 44 09 d3                     	orl	%r10d, %ebx
    14d1: 44 21 c3                     	andl	%r8d, %ebx
    14d4: 89 f9                        	movl	%edi, %ecx
    14d6: 44 21 d1                     	andl	%r10d, %ecx
    14d9: 09 d9                        	orl	%ebx, %ecx
    14db: 44 01 f1                     	addl	%r14d, %ecx
    14de: 89 c3                        	movl	%eax, %ebx
    14e0: c1 c3 1a                     	roll	$0x1a, %ebx
    14e3: 01 d1                        	addl	%edx, %ecx
    14e5: 89 c2                        	movl	%eax, %edx
    14e7: c1 c2 15                     	roll	$0x15, %edx
    14ea: 31 da                        	xorl	%ebx, %edx
    14ec: 89 c3                        	movl	%eax, %ebx
    14ee: c1 c3 07                     	roll	$0x7, %ebx
    14f1: 31 d3                        	xorl	%edx, %ebx
    14f3: 89 f2                        	movl	%esi, %edx
    14f5: 44 31 ca                     	xorl	%r9d, %edx
    14f8: 21 c2                        	andl	%eax, %edx
    14fa: 44 31 ca                     	xorl	%r9d, %edx
    14fd: 44 03 9d 0c ff ff ff         	addl	-0xf4(%rbp), %r11d
    1504: 41 01 d3                     	addl	%edx, %r11d
    1507: 42 8d 14 1b                  	leal	(%rbx,%r11), %edx
    150b: 81 c2 74 f1 9b c1            	addl	$0xc19bf174, %edx       # imm = 0xC19BF174
    1511: 41 89 cb                     	movl	%ecx, %r11d
    1514: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    1518: 41 01 d2                     	addl	%edx, %r10d
    151b: 89 cb                        	movl	%ecx, %ebx
    151d: c1 c3 13                     	roll	$0x13, %ebx
    1520: 44 31 db                     	xorl	%r11d, %ebx
    1523: 41 89 ce                     	movl	%ecx, %r14d
    1526: 41 c1 c6 0a                  	roll	$0xa, %r14d
    152a: 41 31 de                     	xorl	%ebx, %r14d
    152d: 44 89 c3                     	movl	%r8d, %ebx
    1530: 09 fb                        	orl	%edi, %ebx
    1532: 21 cb                        	andl	%ecx, %ebx
    1534: 45 89 c3                     	movl	%r8d, %r11d
    1537: 41 21 fb                     	andl	%edi, %r11d
    153a: 41 09 db                     	orl	%ebx, %r11d
    153d: 45 01 f3                     	addl	%r14d, %r11d
    1540: 41 01 d3                     	addl	%edx, %r11d
    1543: 44 89 d2                     	movl	%r10d, %edx
    1546: c1 c2 1a                     	roll	$0x1a, %edx
    1549: 44 89 d3                     	movl	%r10d, %ebx
    154c: c1 c3 15                     	roll	$0x15, %ebx
    154f: 31 d3                        	xorl	%edx, %ebx
    1551: 44 89 d2                     	movl	%r10d, %edx
    1554: c1 c2 07                     	roll	$0x7, %edx
    1557: 31 da                        	xorl	%ebx, %edx
    1559: 89 c3                        	movl	%eax, %ebx
    155b: 31 f3                        	xorl	%esi, %ebx
    155d: 44 21 d3                     	andl	%r10d, %ebx
    1560: 31 f3                        	xorl	%esi, %ebx
    1562: 44 03 8d 10 ff ff ff         	addl	-0xf0(%rbp), %r9d
    1569: 41 01 d9                     	addl	%ebx, %r9d
    156c: 41 01 d1                     	addl	%edx, %r9d
    156f: 41 81 c1 c1 69 9b e4         	addl	$0xe49b69c1, %r9d       # imm = 0xE49B69C1
    1576: 44 01 cf                     	addl	%r9d, %edi
    1579: 44 89 da                     	movl	%r11d, %edx
    157c: c1 c2 1e                     	roll	$0x1e, %edx
    157f: 44 89 db                     	movl	%r11d, %ebx
    1582: c1 c3 13                     	roll	$0x13, %ebx
    1585: 31 d3                        	xorl	%edx, %ebx
    1587: 45 89 de                     	movl	%r11d, %r14d
    158a: 41 c1 c6 0a                  	roll	$0xa, %r14d
    158e: 41 31 de                     	xorl	%ebx, %r14d
    1591: 89 cb                        	movl	%ecx, %ebx
    1593: 44 09 c3                     	orl	%r8d, %ebx
    1596: 44 21 db                     	andl	%r11d, %ebx
    1599: 89 ca                        	movl	%ecx, %edx
    159b: 44 21 c2                     	andl	%r8d, %edx
    159e: 09 da                        	orl	%ebx, %edx
    15a0: 44 01 f2                     	addl	%r14d, %edx
    15a3: 44 01 ca                     	addl	%r9d, %edx
    15a6: 41 89 f9                     	movl	%edi, %r9d
    15a9: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    15ad: 89 fb                        	movl	%edi, %ebx
    15af: c1 c3 15                     	roll	$0x15, %ebx
    15b2: 44 31 cb                     	xorl	%r9d, %ebx
    15b5: 41 89 f9                     	movl	%edi, %r9d
    15b8: 41 c1 c1 07                  	roll	$0x7, %r9d
    15bc: 41 31 d9                     	xorl	%ebx, %r9d
    15bf: 44 89 d3                     	movl	%r10d, %ebx
    15c2: 31 c3                        	xorl	%eax, %ebx
    15c4: 21 fb                        	andl	%edi, %ebx
    15c6: 03 b5 14 ff ff ff            	addl	-0xec(%rbp), %esi
    15cc: 31 c3                        	xorl	%eax, %ebx
    15ce: 01 de                        	addl	%ebx, %esi
    15d0: 41 01 f1                     	addl	%esi, %r9d
    15d3: 41 81 c1 86 47 be ef         	addl	$0xefbe4786, %r9d       # imm = 0xEFBE4786
    15da: 45 01 c8                     	addl	%r9d, %r8d
    15dd: 89 d6                        	movl	%edx, %esi
    15df: c1 c6 1e                     	roll	$0x1e, %esi
    15e2: 89 d3                        	movl	%edx, %ebx
    15e4: c1 c3 13                     	roll	$0x13, %ebx
    15e7: 31 f3                        	xorl	%esi, %ebx
    15e9: 41 89 d6                     	movl	%edx, %r14d
    15ec: 41 c1 c6 0a                  	roll	$0xa, %r14d
    15f0: 41 31 de                     	xorl	%ebx, %r14d
    15f3: 44 89 db                     	movl	%r11d, %ebx
    15f6: 09 cb                        	orl	%ecx, %ebx
    15f8: 21 d3                        	andl	%edx, %ebx
    15fa: 44 89 de                     	movl	%r11d, %esi
    15fd: 21 ce                        	andl	%ecx, %esi
    15ff: 09 de                        	orl	%ebx, %esi
    1601: 44 89 c3                     	movl	%r8d, %ebx
    1604: c1 c3 1a                     	roll	$0x1a, %ebx
    1607: 44 01 f6                     	addl	%r14d, %esi
    160a: 45 89 c6                     	movl	%r8d, %r14d
    160d: 41 c1 c6 15                  	roll	$0x15, %r14d
    1611: 44 01 ce                     	addl	%r9d, %esi
    1614: 45 89 c1                     	movl	%r8d, %r9d
    1617: 41 c1 c1 07                  	roll	$0x7, %r9d
    161b: 41 31 de                     	xorl	%ebx, %r14d
    161e: 45 31 f1                     	xorl	%r14d, %r9d
    1621: 89 fb                        	movl	%edi, %ebx
    1623: 44 31 d3                     	xorl	%r10d, %ebx
    1626: 44 21 c3                     	andl	%r8d, %ebx
    1629: 44 31 d3                     	xorl	%r10d, %ebx
    162c: 03 85 18 ff ff ff            	addl	-0xe8(%rbp), %eax
    1632: 01 d8                        	addl	%ebx, %eax
    1634: 89 f3                        	movl	%esi, %ebx
    1636: c1 c3 1e                     	roll	$0x1e, %ebx
    1639: 41 01 c1                     	addl	%eax, %r9d
    163c: 41 81 c1 c6 9d c1 0f         	addl	$0xfc19dc6, %r9d        # imm = 0xFC19DC6
    1643: 89 f0                        	movl	%esi, %eax
    1645: c1 c0 13                     	roll	$0x13, %eax
    1648: 44 01 c9                     	addl	%r9d, %ecx
    164b: 41 89 f6                     	movl	%esi, %r14d
    164e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1652: 31 d8                        	xorl	%ebx, %eax
    1654: 41 31 c6                     	xorl	%eax, %r14d
    1657: 89 d3                        	movl	%edx, %ebx
    1659: 44 09 db                     	orl	%r11d, %ebx
    165c: 21 f3                        	andl	%esi, %ebx
    165e: 89 d0                        	movl	%edx, %eax
    1660: 44 21 d8                     	andl	%r11d, %eax
    1663: 09 d8                        	orl	%ebx, %eax
    1665: 44 01 f0                     	addl	%r14d, %eax
    1668: 89 cb                        	movl	%ecx, %ebx
    166a: c1 c3 1a                     	roll	$0x1a, %ebx
    166d: 44 01 c8                     	addl	%r9d, %eax
    1670: 41 89 c9                     	movl	%ecx, %r9d
    1673: 41 c1 c1 15                  	roll	$0x15, %r9d
    1677: 41 31 d9                     	xorl	%ebx, %r9d
    167a: 89 cb                        	movl	%ecx, %ebx
    167c: c1 c3 07                     	roll	$0x7, %ebx
    167f: 44 31 cb                     	xorl	%r9d, %ebx
    1682: 45 89 c1                     	movl	%r8d, %r9d
    1685: 41 31 f9                     	xorl	%edi, %r9d
    1688: 41 21 c9                     	andl	%ecx, %r9d
    168b: 41 31 f9                     	xorl	%edi, %r9d
    168e: 44 03 95 1c ff ff ff         	addl	-0xe4(%rbp), %r10d
    1695: 45 01 ca                     	addl	%r9d, %r10d
    1698: 41 01 da                     	addl	%ebx, %r10d
    169b: 41 81 c2 cc a1 0c 24         	addl	$0x240ca1cc, %r10d      # imm = 0x240CA1CC
    16a2: 41 89 c1                     	movl	%eax, %r9d
    16a5: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    16a9: 45 01 d3                     	addl	%r10d, %r11d
    16ac: 89 c3                        	movl	%eax, %ebx
    16ae: c1 c3 13                     	roll	$0x13, %ebx
    16b1: 44 31 cb                     	xorl	%r9d, %ebx
    16b4: 41 89 c6                     	movl	%eax, %r14d
    16b7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    16bb: 41 31 de                     	xorl	%ebx, %r14d
    16be: 89 f3                        	movl	%esi, %ebx
    16c0: 09 d3                        	orl	%edx, %ebx
    16c2: 21 c3                        	andl	%eax, %ebx
    16c4: 41 89 f1                     	movl	%esi, %r9d
    16c7: 41 21 d1                     	andl	%edx, %r9d
    16ca: 41 09 d9                     	orl	%ebx, %r9d
    16cd: 45 01 f1                     	addl	%r14d, %r9d
    16d0: 45 01 d1                     	addl	%r10d, %r9d
    16d3: 45 89 da                     	movl	%r11d, %r10d
    16d6: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    16da: 44 89 db                     	movl	%r11d, %ebx
    16dd: c1 c3 15                     	roll	$0x15, %ebx
    16e0: 44 31 d3                     	xorl	%r10d, %ebx
    16e3: 45 89 da                     	movl	%r11d, %r10d
    16e6: 41 c1 c2 07                  	roll	$0x7, %r10d
    16ea: 41 31 da                     	xorl	%ebx, %r10d
    16ed: 89 cb                        	movl	%ecx, %ebx
    16ef: 44 31 c3                     	xorl	%r8d, %ebx
    16f2: 44 21 db                     	andl	%r11d, %ebx
    16f5: 44 31 c3                     	xorl	%r8d, %ebx
    16f8: 03 bd 20 ff ff ff            	addl	-0xe0(%rbp), %edi
    16fe: 01 df                        	addl	%ebx, %edi
    1700: 41 01 fa                     	addl	%edi, %r10d
    1703: 41 81 c2 6f 2c e9 2d         	addl	$0x2de92c6f, %r10d      # imm = 0x2DE92C6F
    170a: 44 01 d2                     	addl	%r10d, %edx
    170d: 44 89 cf                     	movl	%r9d, %edi
    1710: c1 c7 1e                     	roll	$0x1e, %edi
    1713: 44 89 cb                     	movl	%r9d, %ebx
    1716: c1 c3 13                     	roll	$0x13, %ebx
    1719: 31 fb                        	xorl	%edi, %ebx
    171b: 45 89 ce                     	movl	%r9d, %r14d
    171e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1722: 41 31 de                     	xorl	%ebx, %r14d
    1725: 89 c3                        	movl	%eax, %ebx
    1727: 09 f3                        	orl	%esi, %ebx
    1729: 44 21 cb                     	andl	%r9d, %ebx
    172c: 89 c7                        	movl	%eax, %edi
    172e: 21 f7                        	andl	%esi, %edi
    1730: 09 df                        	orl	%ebx, %edi
    1732: 44 01 f7                     	addl	%r14d, %edi
    1735: 44 01 d7                     	addl	%r10d, %edi
    1738: 41 89 d2                     	movl	%edx, %r10d
    173b: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    173f: 89 d3                        	movl	%edx, %ebx
    1741: c1 c3 15                     	roll	$0x15, %ebx
    1744: 44 31 d3                     	xorl	%r10d, %ebx
    1747: 41 89 d2                     	movl	%edx, %r10d
    174a: 41 c1 c2 07                  	roll	$0x7, %r10d
    174e: 41 31 da                     	xorl	%ebx, %r10d
    1751: 44 89 db                     	movl	%r11d, %ebx
    1754: 31 cb                        	xorl	%ecx, %ebx
    1756: 21 d3                        	andl	%edx, %ebx
    1758: 44 03 85 24 ff ff ff         	addl	-0xdc(%rbp), %r8d
    175f: 31 cb                        	xorl	%ecx, %ebx
    1761: 41 01 d8                     	addl	%ebx, %r8d
    1764: 45 01 c2                     	addl	%r8d, %r10d
    1767: 41 81 c2 aa 84 74 4a         	addl	$0x4a7484aa, %r10d      # imm = 0x4A7484AA
    176e: 44 01 d6                     	addl	%r10d, %esi
    1771: 41 89 f8                     	movl	%edi, %r8d
    1774: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1778: 89 fb                        	movl	%edi, %ebx
    177a: c1 c3 13                     	roll	$0x13, %ebx
    177d: 44 31 c3                     	xorl	%r8d, %ebx
    1780: 41 89 fe                     	movl	%edi, %r14d
    1783: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1787: 41 31 de                     	xorl	%ebx, %r14d
    178a: 44 89 cb                     	movl	%r9d, %ebx
    178d: 09 c3                        	orl	%eax, %ebx
    178f: 21 fb                        	andl	%edi, %ebx
    1791: 45 89 c8                     	movl	%r9d, %r8d
    1794: 41 21 c0                     	andl	%eax, %r8d
    1797: 41 09 d8                     	orl	%ebx, %r8d
    179a: 89 f3                        	movl	%esi, %ebx
    179c: c1 c3 1a                     	roll	$0x1a, %ebx
    179f: 45 01 f0                     	addl	%r14d, %r8d
    17a2: 41 89 f6                     	movl	%esi, %r14d
    17a5: 41 c1 c6 15                  	roll	$0x15, %r14d
    17a9: 45 01 d0                     	addl	%r10d, %r8d
    17ac: 41 89 f2                     	movl	%esi, %r10d
    17af: 41 c1 c2 07                  	roll	$0x7, %r10d
    17b3: 41 31 de                     	xorl	%ebx, %r14d
    17b6: 45 31 f2                     	xorl	%r14d, %r10d
    17b9: 89 d3                        	movl	%edx, %ebx
    17bb: 44 31 db                     	xorl	%r11d, %ebx
    17be: 21 f3                        	andl	%esi, %ebx
    17c0: 44 31 db                     	xorl	%r11d, %ebx
    17c3: 03 8d 28 ff ff ff            	addl	-0xd8(%rbp), %ecx
    17c9: 01 d9                        	addl	%ebx, %ecx
    17cb: 44 89 c3                     	movl	%r8d, %ebx
    17ce: c1 c3 1e                     	roll	$0x1e, %ebx
    17d1: 41 01 ca                     	addl	%ecx, %r10d
    17d4: 41 81 c2 dc a9 b0 5c         	addl	$0x5cb0a9dc, %r10d      # imm = 0x5CB0A9DC
    17db: 44 89 c1                     	movl	%r8d, %ecx
    17de: c1 c1 13                     	roll	$0x13, %ecx
    17e1: 44 01 d0                     	addl	%r10d, %eax
    17e4: 45 89 c6                     	movl	%r8d, %r14d
    17e7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    17eb: 31 d9                        	xorl	%ebx, %ecx
    17ed: 41 31 ce                     	xorl	%ecx, %r14d
    17f0: 89 fb                        	movl	%edi, %ebx
    17f2: 44 09 cb                     	orl	%r9d, %ebx
    17f5: 44 21 c3                     	andl	%r8d, %ebx
    17f8: 89 f9                        	movl	%edi, %ecx
    17fa: 44 21 c9                     	andl	%r9d, %ecx
    17fd: 09 d9                        	orl	%ebx, %ecx
    17ff: 44 01 f1                     	addl	%r14d, %ecx
    1802: 89 c3                        	movl	%eax, %ebx
    1804: c1 c3 1a                     	roll	$0x1a, %ebx
    1807: 44 01 d1                     	addl	%r10d, %ecx
    180a: 41 89 c2                     	movl	%eax, %r10d
    180d: 41 c1 c2 15                  	roll	$0x15, %r10d
    1811: 41 31 da                     	xorl	%ebx, %r10d
    1814: 89 c3                        	movl	%eax, %ebx
    1816: c1 c3 07                     	roll	$0x7, %ebx
    1819: 44 31 d3                     	xorl	%r10d, %ebx
    181c: 41 89 f2                     	movl	%esi, %r10d
    181f: 41 31 d2                     	xorl	%edx, %r10d
    1822: 41 21 c2                     	andl	%eax, %r10d
    1825: 41 31 d2                     	xorl	%edx, %r10d
    1828: 44 03 9d 2c ff ff ff         	addl	-0xd4(%rbp), %r11d
    182f: 45 01 d3                     	addl	%r10d, %r11d
    1832: 41 01 db                     	addl	%ebx, %r11d
    1835: 41 81 c3 da 88 f9 76         	addl	$0x76f988da, %r11d      # imm = 0x76F988DA
    183c: 41 89 ca                     	movl	%ecx, %r10d
    183f: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1843: 45 01 d9                     	addl	%r11d, %r9d
    1846: 89 cb                        	movl	%ecx, %ebx
    1848: c1 c3 13                     	roll	$0x13, %ebx
    184b: 44 31 d3                     	xorl	%r10d, %ebx
    184e: 41 89 ce                     	movl	%ecx, %r14d
    1851: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1855: 41 31 de                     	xorl	%ebx, %r14d
    1858: 44 89 c3                     	movl	%r8d, %ebx
    185b: 09 fb                        	orl	%edi, %ebx
    185d: 21 cb                        	andl	%ecx, %ebx
    185f: 45 89 c2                     	movl	%r8d, %r10d
    1862: 41 21 fa                     	andl	%edi, %r10d
    1865: 41 09 da                     	orl	%ebx, %r10d
    1868: 45 01 f2                     	addl	%r14d, %r10d
    186b: 45 01 da                     	addl	%r11d, %r10d
    186e: 45 89 cb                     	movl	%r9d, %r11d
    1871: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1875: 44 89 cb                     	movl	%r9d, %ebx
    1878: c1 c3 15                     	roll	$0x15, %ebx
    187b: 44 31 db                     	xorl	%r11d, %ebx
    187e: 45 89 cb                     	movl	%r9d, %r11d
    1881: 41 c1 c3 07                  	roll	$0x7, %r11d
    1885: 41 31 db                     	xorl	%ebx, %r11d
    1888: 89 c3                        	movl	%eax, %ebx
    188a: 31 f3                        	xorl	%esi, %ebx
    188c: 44 21 cb                     	andl	%r9d, %ebx
    188f: 31 f3                        	xorl	%esi, %ebx
    1891: 03 95 30 ff ff ff            	addl	-0xd0(%rbp), %edx
    1897: 01 da                        	addl	%ebx, %edx
    1899: 41 01 d3                     	addl	%edx, %r11d
    189c: 41 81 c3 52 51 3e 98         	addl	$0x983e5152, %r11d      # imm = 0x983E5152
    18a3: 44 01 df                     	addl	%r11d, %edi
    18a6: 44 89 d2                     	movl	%r10d, %edx
    18a9: c1 c2 1e                     	roll	$0x1e, %edx
    18ac: 44 89 d3                     	movl	%r10d, %ebx
    18af: c1 c3 13                     	roll	$0x13, %ebx
    18b2: 31 d3                        	xorl	%edx, %ebx
    18b4: 45 89 d6                     	movl	%r10d, %r14d
    18b7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    18bb: 41 31 de                     	xorl	%ebx, %r14d
    18be: 89 cb                        	movl	%ecx, %ebx
    18c0: 44 09 c3                     	orl	%r8d, %ebx
    18c3: 44 21 d3                     	andl	%r10d, %ebx
    18c6: 89 ca                        	movl	%ecx, %edx
    18c8: 44 21 c2                     	andl	%r8d, %edx
    18cb: 09 da                        	orl	%ebx, %edx
    18cd: 44 01 f2                     	addl	%r14d, %edx
    18d0: 44 01 da                     	addl	%r11d, %edx
    18d3: 41 89 fb                     	movl	%edi, %r11d
    18d6: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    18da: 89 fb                        	movl	%edi, %ebx
    18dc: c1 c3 15                     	roll	$0x15, %ebx
    18df: 44 31 db                     	xorl	%r11d, %ebx
    18e2: 41 89 fb                     	movl	%edi, %r11d
    18e5: 41 c1 c3 07                  	roll	$0x7, %r11d
    18e9: 41 31 db                     	xorl	%ebx, %r11d
    18ec: 44 89 cb                     	movl	%r9d, %ebx
    18ef: 31 c3                        	xorl	%eax, %ebx
    18f1: 21 fb                        	andl	%edi, %ebx
    18f3: 03 b5 34 ff ff ff            	addl	-0xcc(%rbp), %esi
    18f9: 31 c3                        	xorl	%eax, %ebx
    18fb: 01 de                        	addl	%ebx, %esi
    18fd: 41 01 f3                     	addl	%esi, %r11d
    1900: 41 81 c3 6d c6 31 a8         	addl	$0xa831c66d, %r11d      # imm = 0xA831C66D
    1907: 45 01 d8                     	addl	%r11d, %r8d
    190a: 89 d6                        	movl	%edx, %esi
    190c: c1 c6 1e                     	roll	$0x1e, %esi
    190f: 89 d3                        	movl	%edx, %ebx
    1911: c1 c3 13                     	roll	$0x13, %ebx
    1914: 31 f3                        	xorl	%esi, %ebx
    1916: 41 89 d6                     	movl	%edx, %r14d
    1919: 41 c1 c6 0a                  	roll	$0xa, %r14d
    191d: 41 31 de                     	xorl	%ebx, %r14d
    1920: 44 89 d3                     	movl	%r10d, %ebx
    1923: 09 cb                        	orl	%ecx, %ebx
    1925: 21 d3                        	andl	%edx, %ebx
    1927: 44 89 d6                     	movl	%r10d, %esi
    192a: 21 ce                        	andl	%ecx, %esi
    192c: 09 de                        	orl	%ebx, %esi
    192e: 44 89 c3                     	movl	%r8d, %ebx
    1931: c1 c3 1a                     	roll	$0x1a, %ebx
    1934: 44 01 f6                     	addl	%r14d, %esi
    1937: 45 89 c6                     	movl	%r8d, %r14d
    193a: 41 c1 c6 15                  	roll	$0x15, %r14d
    193e: 44 01 de                     	addl	%r11d, %esi
    1941: 45 89 c3                     	movl	%r8d, %r11d
    1944: 41 c1 c3 07                  	roll	$0x7, %r11d
    1948: 41 31 de                     	xorl	%ebx, %r14d
    194b: 45 31 f3                     	xorl	%r14d, %r11d
    194e: 89 fb                        	movl	%edi, %ebx
    1950: 44 31 cb                     	xorl	%r9d, %ebx
    1953: 44 21 c3                     	andl	%r8d, %ebx
    1956: 44 31 cb                     	xorl	%r9d, %ebx
    1959: 03 85 38 ff ff ff            	addl	-0xc8(%rbp), %eax
    195f: 01 d8                        	addl	%ebx, %eax
    1961: 89 f3                        	movl	%esi, %ebx
    1963: c1 c3 1e                     	roll	$0x1e, %ebx
    1966: 41 01 c3                     	addl	%eax, %r11d
    1969: 41 81 c3 c8 27 03 b0         	addl	$0xb00327c8, %r11d      # imm = 0xB00327C8
    1970: 89 f0                        	movl	%esi, %eax
    1972: c1 c0 13                     	roll	$0x13, %eax
    1975: 44 01 d9                     	addl	%r11d, %ecx
    1978: 41 89 f6                     	movl	%esi, %r14d
    197b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    197f: 31 d8                        	xorl	%ebx, %eax
    1981: 41 31 c6                     	xorl	%eax, %r14d
    1984: 89 d3                        	movl	%edx, %ebx
    1986: 44 09 d3                     	orl	%r10d, %ebx
    1989: 21 f3                        	andl	%esi, %ebx
    198b: 89 d0                        	movl	%edx, %eax
    198d: 44 21 d0                     	andl	%r10d, %eax
    1990: 09 d8                        	orl	%ebx, %eax
    1992: 44 01 f0                     	addl	%r14d, %eax
    1995: 89 cb                        	movl	%ecx, %ebx
    1997: c1 c3 1a                     	roll	$0x1a, %ebx
    199a: 44 01 d8                     	addl	%r11d, %eax
    199d: 41 89 cb                     	movl	%ecx, %r11d
    19a0: 41 c1 c3 15                  	roll	$0x15, %r11d
    19a4: 41 31 db                     	xorl	%ebx, %r11d
    19a7: 89 cb                        	movl	%ecx, %ebx
    19a9: c1 c3 07                     	roll	$0x7, %ebx
    19ac: 44 31 db                     	xorl	%r11d, %ebx
    19af: 45 89 c3                     	movl	%r8d, %r11d
    19b2: 41 31 fb                     	xorl	%edi, %r11d
    19b5: 41 21 cb                     	andl	%ecx, %r11d
    19b8: 41 31 fb                     	xorl	%edi, %r11d
    19bb: 44 03 8d 3c ff ff ff         	addl	-0xc4(%rbp), %r9d
    19c2: 45 01 d9                     	addl	%r11d, %r9d
    19c5: 46 8d 1c 0b                  	leal	(%rbx,%r9), %r11d
    19c9: 41 81 c3 c7 7f 59 bf         	addl	$0xbf597fc7, %r11d      # imm = 0xBF597FC7
    19d0: 41 89 c1                     	movl	%eax, %r9d
    19d3: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    19d7: 45 01 da                     	addl	%r11d, %r10d
    19da: 89 c3                        	movl	%eax, %ebx
    19dc: c1 c3 13                     	roll	$0x13, %ebx
    19df: 44 31 cb                     	xorl	%r9d, %ebx
    19e2: 41 89 c6                     	movl	%eax, %r14d
    19e5: 41 c1 c6 0a                  	roll	$0xa, %r14d
    19e9: 41 31 de                     	xorl	%ebx, %r14d
    19ec: 89 f3                        	movl	%esi, %ebx
    19ee: 09 d3                        	orl	%edx, %ebx
    19f0: 21 c3                        	andl	%eax, %ebx
    19f2: 41 89 f1                     	movl	%esi, %r9d
    19f5: 41 21 d1                     	andl	%edx, %r9d
    19f8: 41 09 d9                     	orl	%ebx, %r9d
    19fb: 45 01 f1                     	addl	%r14d, %r9d
    19fe: 45 01 d9                     	addl	%r11d, %r9d
    1a01: 45 89 d3                     	movl	%r10d, %r11d
    1a04: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1a08: 44 89 d3                     	movl	%r10d, %ebx
    1a0b: c1 c3 15                     	roll	$0x15, %ebx
    1a0e: 44 31 db                     	xorl	%r11d, %ebx
    1a11: 45 89 d3                     	movl	%r10d, %r11d
    1a14: 41 c1 c3 07                  	roll	$0x7, %r11d
    1a18: 41 31 db                     	xorl	%ebx, %r11d
    1a1b: 89 cb                        	movl	%ecx, %ebx
    1a1d: 44 31 c3                     	xorl	%r8d, %ebx
    1a20: 44 21 d3                     	andl	%r10d, %ebx
    1a23: 44 31 c3                     	xorl	%r8d, %ebx
    1a26: 03 bd 40 ff ff ff            	addl	-0xc0(%rbp), %edi
    1a2c: 01 df                        	addl	%ebx, %edi
    1a2e: 41 01 fb                     	addl	%edi, %r11d
    1a31: 41 81 c3 f3 0b e0 c6         	addl	$0xc6e00bf3, %r11d      # imm = 0xC6E00BF3
    1a38: 44 01 da                     	addl	%r11d, %edx
    1a3b: 44 89 cf                     	movl	%r9d, %edi
    1a3e: c1 c7 1e                     	roll	$0x1e, %edi
    1a41: 44 89 cb                     	movl	%r9d, %ebx
    1a44: c1 c3 13                     	roll	$0x13, %ebx
    1a47: 31 fb                        	xorl	%edi, %ebx
    1a49: 45 89 ce                     	movl	%r9d, %r14d
    1a4c: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1a50: 41 31 de                     	xorl	%ebx, %r14d
    1a53: 89 c3                        	movl	%eax, %ebx
    1a55: 09 f3                        	orl	%esi, %ebx
    1a57: 44 21 cb                     	andl	%r9d, %ebx
    1a5a: 89 c7                        	movl	%eax, %edi
    1a5c: 21 f7                        	andl	%esi, %edi
    1a5e: 09 df                        	orl	%ebx, %edi
    1a60: 44 01 f7                     	addl	%r14d, %edi
    1a63: 44 01 df                     	addl	%r11d, %edi
    1a66: 41 89 d3                     	movl	%edx, %r11d
    1a69: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1a6d: 89 d3                        	movl	%edx, %ebx
    1a6f: c1 c3 15                     	roll	$0x15, %ebx
    1a72: 44 31 db                     	xorl	%r11d, %ebx
    1a75: 41 89 d3                     	movl	%edx, %r11d
    1a78: 41 c1 c3 07                  	roll	$0x7, %r11d
    1a7c: 41 31 db                     	xorl	%ebx, %r11d
    1a7f: 44 89 d3                     	movl	%r10d, %ebx
    1a82: 31 cb                        	xorl	%ecx, %ebx
    1a84: 21 d3                        	andl	%edx, %ebx
    1a86: 44 03 85 44 ff ff ff         	addl	-0xbc(%rbp), %r8d
    1a8d: 31 cb                        	xorl	%ecx, %ebx
    1a8f: 41 01 d8                     	addl	%ebx, %r8d
    1a92: 45 01 c3                     	addl	%r8d, %r11d
    1a95: 41 81 c3 47 91 a7 d5         	addl	$0xd5a79147, %r11d      # imm = 0xD5A79147
    1a9c: 44 01 de                     	addl	%r11d, %esi
    1a9f: 41 89 f8                     	movl	%edi, %r8d
    1aa2: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1aa6: 89 fb                        	movl	%edi, %ebx
    1aa8: c1 c3 13                     	roll	$0x13, %ebx
    1aab: 44 31 c3                     	xorl	%r8d, %ebx
    1aae: 41 89 fe                     	movl	%edi, %r14d
    1ab1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1ab5: 41 31 de                     	xorl	%ebx, %r14d
    1ab8: 44 89 cb                     	movl	%r9d, %ebx
    1abb: 09 c3                        	orl	%eax, %ebx
    1abd: 21 fb                        	andl	%edi, %ebx
    1abf: 45 89 c8                     	movl	%r9d, %r8d
    1ac2: 41 21 c0                     	andl	%eax, %r8d
    1ac5: 41 09 d8                     	orl	%ebx, %r8d
    1ac8: 89 f3                        	movl	%esi, %ebx
    1aca: c1 c3 1a                     	roll	$0x1a, %ebx
    1acd: 45 01 f0                     	addl	%r14d, %r8d
    1ad0: 41 89 f6                     	movl	%esi, %r14d
    1ad3: 41 c1 c6 15                  	roll	$0x15, %r14d
    1ad7: 45 01 d8                     	addl	%r11d, %r8d
    1ada: 41 89 f3                     	movl	%esi, %r11d
    1add: 41 c1 c3 07                  	roll	$0x7, %r11d
    1ae1: 41 31 de                     	xorl	%ebx, %r14d
    1ae4: 45 31 f3                     	xorl	%r14d, %r11d
    1ae7: 89 d3                        	movl	%edx, %ebx
    1ae9: 44 31 d3                     	xorl	%r10d, %ebx
    1aec: 21 f3                        	andl	%esi, %ebx
    1aee: 44 31 d3                     	xorl	%r10d, %ebx
    1af1: 03 8d 48 ff ff ff            	addl	-0xb8(%rbp), %ecx
    1af7: 01 d9                        	addl	%ebx, %ecx
    1af9: 44 89 c3                     	movl	%r8d, %ebx
    1afc: c1 c3 1e                     	roll	$0x1e, %ebx
    1aff: 41 01 cb                     	addl	%ecx, %r11d
    1b02: 41 81 c3 51 63 ca 06         	addl	$0x6ca6351, %r11d       # imm = 0x6CA6351
    1b09: 44 89 c1                     	movl	%r8d, %ecx
    1b0c: c1 c1 13                     	roll	$0x13, %ecx
    1b0f: 44 01 d8                     	addl	%r11d, %eax
    1b12: 45 89 c6                     	movl	%r8d, %r14d
    1b15: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1b19: 31 d9                        	xorl	%ebx, %ecx
    1b1b: 41 31 ce                     	xorl	%ecx, %r14d
    1b1e: 89 fb                        	movl	%edi, %ebx
    1b20: 44 09 cb                     	orl	%r9d, %ebx
    1b23: 44 21 c3                     	andl	%r8d, %ebx
    1b26: 89 f9                        	movl	%edi, %ecx
    1b28: 44 21 c9                     	andl	%r9d, %ecx
    1b2b: 09 d9                        	orl	%ebx, %ecx
    1b2d: 44 01 f1                     	addl	%r14d, %ecx
    1b30: 89 c3                        	movl	%eax, %ebx
    1b32: c1 c3 1a                     	roll	$0x1a, %ebx
    1b35: 44 01 d9                     	addl	%r11d, %ecx
    1b38: 41 89 c3                     	movl	%eax, %r11d
    1b3b: 41 c1 c3 15                  	roll	$0x15, %r11d
    1b3f: 41 31 db                     	xorl	%ebx, %r11d
    1b42: 89 c3                        	movl	%eax, %ebx
    1b44: c1 c3 07                     	roll	$0x7, %ebx
    1b47: 44 31 db                     	xorl	%r11d, %ebx
    1b4a: 41 89 f3                     	movl	%esi, %r11d
    1b4d: 41 31 d3                     	xorl	%edx, %r11d
    1b50: 41 21 c3                     	andl	%eax, %r11d
    1b53: 41 31 d3                     	xorl	%edx, %r11d
    1b56: 44 03 95 4c ff ff ff         	addl	-0xb4(%rbp), %r10d
    1b5d: 45 01 da                     	addl	%r11d, %r10d
    1b60: 46 8d 1c 13                  	leal	(%rbx,%r10), %r11d
    1b64: 41 81 c3 67 29 29 14         	addl	$0x14292967, %r11d      # imm = 0x14292967
    1b6b: 41 89 ca                     	movl	%ecx, %r10d
    1b6e: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1b72: 45 01 d9                     	addl	%r11d, %r9d
    1b75: 89 cb                        	movl	%ecx, %ebx
    1b77: c1 c3 13                     	roll	$0x13, %ebx
    1b7a: 44 31 d3                     	xorl	%r10d, %ebx
    1b7d: 41 89 ce                     	movl	%ecx, %r14d
    1b80: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1b84: 41 31 de                     	xorl	%ebx, %r14d
    1b87: 44 89 c3                     	movl	%r8d, %ebx
    1b8a: 09 fb                        	orl	%edi, %ebx
    1b8c: 21 cb                        	andl	%ecx, %ebx
    1b8e: 45 89 c2                     	movl	%r8d, %r10d
    1b91: 41 21 fa                     	andl	%edi, %r10d
    1b94: 41 09 da                     	orl	%ebx, %r10d
    1b97: 45 01 f2                     	addl	%r14d, %r10d
    1b9a: 45 01 da                     	addl	%r11d, %r10d
    1b9d: 45 89 cb                     	movl	%r9d, %r11d
    1ba0: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1ba4: 44 89 cb                     	movl	%r9d, %ebx
    1ba7: c1 c3 15                     	roll	$0x15, %ebx
    1baa: 44 31 db                     	xorl	%r11d, %ebx
    1bad: 45 89 cb                     	movl	%r9d, %r11d
    1bb0: 41 c1 c3 07                  	roll	$0x7, %r11d
    1bb4: 41 31 db                     	xorl	%ebx, %r11d
    1bb7: 89 c3                        	movl	%eax, %ebx
    1bb9: 31 f3                        	xorl	%esi, %ebx
    1bbb: 44 21 cb                     	andl	%r9d, %ebx
    1bbe: 31 f3                        	xorl	%esi, %ebx
    1bc0: 03 95 50 ff ff ff            	addl	-0xb0(%rbp), %edx
    1bc6: 01 da                        	addl	%ebx, %edx
    1bc8: 41 01 d3                     	addl	%edx, %r11d
    1bcb: 41 81 c3 85 0a b7 27         	addl	$0x27b70a85, %r11d      # imm = 0x27B70A85
    1bd2: 44 01 df                     	addl	%r11d, %edi
    1bd5: 44 89 d2                     	movl	%r10d, %edx
    1bd8: c1 c2 1e                     	roll	$0x1e, %edx
    1bdb: 44 89 d3                     	movl	%r10d, %ebx
    1bde: c1 c3 13                     	roll	$0x13, %ebx
    1be1: 31 d3                        	xorl	%edx, %ebx
    1be3: 45 89 d6                     	movl	%r10d, %r14d
    1be6: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1bea: 41 31 de                     	xorl	%ebx, %r14d
    1bed: 89 cb                        	movl	%ecx, %ebx
    1bef: 44 09 c3                     	orl	%r8d, %ebx
    1bf2: 44 21 d3                     	andl	%r10d, %ebx
    1bf5: 89 ca                        	movl	%ecx, %edx
    1bf7: 44 21 c2                     	andl	%r8d, %edx
    1bfa: 09 da                        	orl	%ebx, %edx
    1bfc: 44 01 f2                     	addl	%r14d, %edx
    1bff: 44 01 da                     	addl	%r11d, %edx
    1c02: 41 89 fb                     	movl	%edi, %r11d
    1c05: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1c09: 89 fb                        	movl	%edi, %ebx
    1c0b: c1 c3 15                     	roll	$0x15, %ebx
    1c0e: 44 31 db                     	xorl	%r11d, %ebx
    1c11: 41 89 fb                     	movl	%edi, %r11d
    1c14: 41 c1 c3 07                  	roll	$0x7, %r11d
    1c18: 41 31 db                     	xorl	%ebx, %r11d
    1c1b: 44 89 cb                     	movl	%r9d, %ebx
    1c1e: 31 c3                        	xorl	%eax, %ebx
    1c20: 21 fb                        	andl	%edi, %ebx
    1c22: 03 b5 54 ff ff ff            	addl	-0xac(%rbp), %esi
    1c28: 31 c3                        	xorl	%eax, %ebx
    1c2a: 01 de                        	addl	%ebx, %esi
    1c2c: 41 01 f3                     	addl	%esi, %r11d
    1c2f: 41 81 c3 38 21 1b 2e         	addl	$0x2e1b2138, %r11d      # imm = 0x2E1B2138
    1c36: 45 01 d8                     	addl	%r11d, %r8d
    1c39: 89 d6                        	movl	%edx, %esi
    1c3b: c1 c6 1e                     	roll	$0x1e, %esi
    1c3e: 89 d3                        	movl	%edx, %ebx
    1c40: c1 c3 13                     	roll	$0x13, %ebx
    1c43: 31 f3                        	xorl	%esi, %ebx
    1c45: 41 89 d6                     	movl	%edx, %r14d
    1c48: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1c4c: 41 31 de                     	xorl	%ebx, %r14d
    1c4f: 44 89 d3                     	movl	%r10d, %ebx
    1c52: 09 cb                        	orl	%ecx, %ebx
    1c54: 21 d3                        	andl	%edx, %ebx
    1c56: 44 89 d6                     	movl	%r10d, %esi
    1c59: 21 ce                        	andl	%ecx, %esi
    1c5b: 09 de                        	orl	%ebx, %esi
    1c5d: 44 89 c3                     	movl	%r8d, %ebx
    1c60: c1 c3 1a                     	roll	$0x1a, %ebx
    1c63: 44 01 f6                     	addl	%r14d, %esi
    1c66: 45 89 c6                     	movl	%r8d, %r14d
    1c69: 41 c1 c6 15                  	roll	$0x15, %r14d
    1c6d: 44 01 de                     	addl	%r11d, %esi
    1c70: 45 89 c3                     	movl	%r8d, %r11d
    1c73: 41 c1 c3 07                  	roll	$0x7, %r11d
    1c77: 41 31 de                     	xorl	%ebx, %r14d
    1c7a: 45 31 f3                     	xorl	%r14d, %r11d
    1c7d: 89 fb                        	movl	%edi, %ebx
    1c7f: 44 31 cb                     	xorl	%r9d, %ebx
    1c82: 44 21 c3                     	andl	%r8d, %ebx
    1c85: 44 31 cb                     	xorl	%r9d, %ebx
    1c88: 03 85 58 ff ff ff            	addl	-0xa8(%rbp), %eax
    1c8e: 01 d8                        	addl	%ebx, %eax
    1c90: 89 f3                        	movl	%esi, %ebx
    1c92: c1 c3 1e                     	roll	$0x1e, %ebx
    1c95: 41 01 c3                     	addl	%eax, %r11d
    1c98: 41 81 c3 fc 6d 2c 4d         	addl	$0x4d2c6dfc, %r11d      # imm = 0x4D2C6DFC
    1c9f: 89 f0                        	movl	%esi, %eax
    1ca1: c1 c0 13                     	roll	$0x13, %eax
    1ca4: 44 01 d9                     	addl	%r11d, %ecx
    1ca7: 41 89 f6                     	movl	%esi, %r14d
    1caa: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1cae: 31 d8                        	xorl	%ebx, %eax
    1cb0: 41 31 c6                     	xorl	%eax, %r14d
    1cb3: 89 d3                        	movl	%edx, %ebx
    1cb5: 44 09 d3                     	orl	%r10d, %ebx
    1cb8: 21 f3                        	andl	%esi, %ebx
    1cba: 89 d0                        	movl	%edx, %eax
    1cbc: 44 21 d0                     	andl	%r10d, %eax
    1cbf: 09 d8                        	orl	%ebx, %eax
    1cc1: 44 01 f0                     	addl	%r14d, %eax
    1cc4: 89 cb                        	movl	%ecx, %ebx
    1cc6: c1 c3 1a                     	roll	$0x1a, %ebx
    1cc9: 44 01 d8                     	addl	%r11d, %eax
    1ccc: 41 89 cb                     	movl	%ecx, %r11d
    1ccf: 41 c1 c3 15                  	roll	$0x15, %r11d
    1cd3: 41 31 db                     	xorl	%ebx, %r11d
    1cd6: 89 cb                        	movl	%ecx, %ebx
    1cd8: c1 c3 07                     	roll	$0x7, %ebx
    1cdb: 44 31 db                     	xorl	%r11d, %ebx
    1cde: 45 89 c3                     	movl	%r8d, %r11d
    1ce1: 41 31 fb                     	xorl	%edi, %r11d
    1ce4: 41 21 cb                     	andl	%ecx, %r11d
    1ce7: 41 31 fb                     	xorl	%edi, %r11d
    1cea: 44 03 8d 5c ff ff ff         	addl	-0xa4(%rbp), %r9d
    1cf1: 45 01 d9                     	addl	%r11d, %r9d
    1cf4: 46 8d 1c 0b                  	leal	(%rbx,%r9), %r11d
    1cf8: 41 81 c3 13 0d 38 53         	addl	$0x53380d13, %r11d      # imm = 0x53380D13
    1cff: 41 89 c1                     	movl	%eax, %r9d
    1d02: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1d06: 45 01 da                     	addl	%r11d, %r10d
    1d09: 89 c3                        	movl	%eax, %ebx
    1d0b: c1 c3 13                     	roll	$0x13, %ebx
    1d0e: 44 31 cb                     	xorl	%r9d, %ebx
    1d11: 41 89 c6                     	movl	%eax, %r14d
    1d14: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1d18: 41 31 de                     	xorl	%ebx, %r14d
    1d1b: 89 f3                        	movl	%esi, %ebx
    1d1d: 09 d3                        	orl	%edx, %ebx
    1d1f: 21 c3                        	andl	%eax, %ebx
    1d21: 41 89 f1                     	movl	%esi, %r9d
    1d24: 41 21 d1                     	andl	%edx, %r9d
    1d27: 41 09 d9                     	orl	%ebx, %r9d
    1d2a: 45 01 f1                     	addl	%r14d, %r9d
    1d2d: 45 01 d9                     	addl	%r11d, %r9d
    1d30: 45 89 d3                     	movl	%r10d, %r11d
    1d33: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1d37: 44 89 d3                     	movl	%r10d, %ebx
    1d3a: c1 c3 15                     	roll	$0x15, %ebx
    1d3d: 44 31 db                     	xorl	%r11d, %ebx
    1d40: 45 89 d3                     	movl	%r10d, %r11d
    1d43: 41 c1 c3 07                  	roll	$0x7, %r11d
    1d47: 41 31 db                     	xorl	%ebx, %r11d
    1d4a: 89 cb                        	movl	%ecx, %ebx
    1d4c: 44 31 c3                     	xorl	%r8d, %ebx
    1d4f: 44 21 d3                     	andl	%r10d, %ebx
    1d52: 44 31 c3                     	xorl	%r8d, %ebx
    1d55: 03 bd 60 ff ff ff            	addl	-0xa0(%rbp), %edi
    1d5b: 01 df                        	addl	%ebx, %edi
    1d5d: 41 01 fb                     	addl	%edi, %r11d
    1d60: 41 81 c3 54 73 0a 65         	addl	$0x650a7354, %r11d      # imm = 0x650A7354
    1d67: 44 01 da                     	addl	%r11d, %edx
    1d6a: 44 89 cf                     	movl	%r9d, %edi
    1d6d: c1 c7 1e                     	roll	$0x1e, %edi
    1d70: 44 89 cb                     	movl	%r9d, %ebx
    1d73: c1 c3 13                     	roll	$0x13, %ebx
    1d76: 31 fb                        	xorl	%edi, %ebx
    1d78: 45 89 ce                     	movl	%r9d, %r14d
    1d7b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1d7f: 41 31 de                     	xorl	%ebx, %r14d
    1d82: 89 c3                        	movl	%eax, %ebx
    1d84: 09 f3                        	orl	%esi, %ebx
    1d86: 44 21 cb                     	andl	%r9d, %ebx
    1d89: 89 c7                        	movl	%eax, %edi
    1d8b: 21 f7                        	andl	%esi, %edi
    1d8d: 09 df                        	orl	%ebx, %edi
    1d8f: 44 01 f7                     	addl	%r14d, %edi
    1d92: 44 01 df                     	addl	%r11d, %edi
    1d95: 41 89 d3                     	movl	%edx, %r11d
    1d98: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1d9c: 89 d3                        	movl	%edx, %ebx
    1d9e: c1 c3 15                     	roll	$0x15, %ebx
    1da1: 44 31 db                     	xorl	%r11d, %ebx
    1da4: 41 89 d3                     	movl	%edx, %r11d
    1da7: 41 c1 c3 07                  	roll	$0x7, %r11d
    1dab: 41 31 db                     	xorl	%ebx, %r11d
    1dae: 44 89 d3                     	movl	%r10d, %ebx
    1db1: 31 cb                        	xorl	%ecx, %ebx
    1db3: 21 d3                        	andl	%edx, %ebx
    1db5: 44 03 85 64 ff ff ff         	addl	-0x9c(%rbp), %r8d
    1dbc: 31 cb                        	xorl	%ecx, %ebx
    1dbe: 41 01 d8                     	addl	%ebx, %r8d
    1dc1: 45 01 c3                     	addl	%r8d, %r11d
    1dc4: 41 81 c3 bb 0a 6a 76         	addl	$0x766a0abb, %r11d      # imm = 0x766A0ABB
    1dcb: 44 01 de                     	addl	%r11d, %esi
    1dce: 41 89 f8                     	movl	%edi, %r8d
    1dd1: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1dd5: 89 fb                        	movl	%edi, %ebx
    1dd7: c1 c3 13                     	roll	$0x13, %ebx
    1dda: 44 31 c3                     	xorl	%r8d, %ebx
    1ddd: 41 89 fe                     	movl	%edi, %r14d
    1de0: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1de4: 41 31 de                     	xorl	%ebx, %r14d
    1de7: 44 89 cb                     	movl	%r9d, %ebx
    1dea: 09 c3                        	orl	%eax, %ebx
    1dec: 21 fb                        	andl	%edi, %ebx
    1dee: 45 89 c8                     	movl	%r9d, %r8d
    1df1: 41 21 c0                     	andl	%eax, %r8d
    1df4: 41 09 d8                     	orl	%ebx, %r8d
    1df7: 89 f3                        	movl	%esi, %ebx
    1df9: c1 c3 1a                     	roll	$0x1a, %ebx
    1dfc: 45 01 f0                     	addl	%r14d, %r8d
    1dff: 41 89 f6                     	movl	%esi, %r14d
    1e02: 41 c1 c6 15                  	roll	$0x15, %r14d
    1e06: 45 01 d8                     	addl	%r11d, %r8d
    1e09: 41 89 f3                     	movl	%esi, %r11d
    1e0c: 41 c1 c3 07                  	roll	$0x7, %r11d
    1e10: 41 31 de                     	xorl	%ebx, %r14d
    1e13: 45 31 f3                     	xorl	%r14d, %r11d
    1e16: 89 d3                        	movl	%edx, %ebx
    1e18: 44 31 d3                     	xorl	%r10d, %ebx
    1e1b: 21 f3                        	andl	%esi, %ebx
    1e1d: 44 31 d3                     	xorl	%r10d, %ebx
    1e20: 03 8d 68 ff ff ff            	addl	-0x98(%rbp), %ecx
    1e26: 01 d9                        	addl	%ebx, %ecx
    1e28: 44 89 c3                     	movl	%r8d, %ebx
    1e2b: c1 c3 1e                     	roll	$0x1e, %ebx
    1e2e: 41 01 cb                     	addl	%ecx, %r11d
    1e31: 41 81 c3 2e c9 c2 81         	addl	$0x81c2c92e, %r11d      # imm = 0x81C2C92E
    1e38: 44 89 c1                     	movl	%r8d, %ecx
    1e3b: c1 c1 13                     	roll	$0x13, %ecx
    1e3e: 44 01 d8                     	addl	%r11d, %eax
    1e41: 45 89 c6                     	movl	%r8d, %r14d
    1e44: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1e48: 31 d9                        	xorl	%ebx, %ecx
    1e4a: 41 31 ce                     	xorl	%ecx, %r14d
    1e4d: 89 fb                        	movl	%edi, %ebx
    1e4f: 44 09 cb                     	orl	%r9d, %ebx
    1e52: 44 21 c3                     	andl	%r8d, %ebx
    1e55: 89 f9                        	movl	%edi, %ecx
    1e57: 44 21 c9                     	andl	%r9d, %ecx
    1e5a: 09 d9                        	orl	%ebx, %ecx
    1e5c: 44 01 f1                     	addl	%r14d, %ecx
    1e5f: 89 c3                        	movl	%eax, %ebx
    1e61: c1 c3 1a                     	roll	$0x1a, %ebx
    1e64: 44 01 d9                     	addl	%r11d, %ecx
    1e67: 41 89 c3                     	movl	%eax, %r11d
    1e6a: 41 c1 c3 15                  	roll	$0x15, %r11d
    1e6e: 41 31 db                     	xorl	%ebx, %r11d
    1e71: 89 c3                        	movl	%eax, %ebx
    1e73: c1 c3 07                     	roll	$0x7, %ebx
    1e76: 44 31 db                     	xorl	%r11d, %ebx
    1e79: 41 89 f3                     	movl	%esi, %r11d
    1e7c: 41 31 d3                     	xorl	%edx, %r11d
    1e7f: 41 21 c3                     	andl	%eax, %r11d
    1e82: 41 31 d3                     	xorl	%edx, %r11d
    1e85: 44 03 95 6c ff ff ff         	addl	-0x94(%rbp), %r10d
    1e8c: 45 01 da                     	addl	%r11d, %r10d
    1e8f: 46 8d 1c 13                  	leal	(%rbx,%r10), %r11d
    1e93: 41 81 c3 85 2c 72 92         	addl	$0x92722c85, %r11d      # imm = 0x92722C85
    1e9a: 41 89 ca                     	movl	%ecx, %r10d
    1e9d: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1ea1: 45 01 d9                     	addl	%r11d, %r9d
    1ea4: 89 cb                        	movl	%ecx, %ebx
    1ea6: c1 c3 13                     	roll	$0x13, %ebx
    1ea9: 44 31 d3                     	xorl	%r10d, %ebx
    1eac: 41 89 ce                     	movl	%ecx, %r14d
    1eaf: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1eb3: 41 31 de                     	xorl	%ebx, %r14d
    1eb6: 44 89 c3                     	movl	%r8d, %ebx
    1eb9: 09 fb                        	orl	%edi, %ebx
    1ebb: 21 cb                        	andl	%ecx, %ebx
    1ebd: 45 89 c2                     	movl	%r8d, %r10d
    1ec0: 41 21 fa                     	andl	%edi, %r10d
    1ec3: 41 09 da                     	orl	%ebx, %r10d
    1ec6: 45 01 f2                     	addl	%r14d, %r10d
    1ec9: 45 01 da                     	addl	%r11d, %r10d
    1ecc: 45 89 cb                     	movl	%r9d, %r11d
    1ecf: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1ed3: 44 89 cb                     	movl	%r9d, %ebx
    1ed6: c1 c3 15                     	roll	$0x15, %ebx
    1ed9: 44 31 db                     	xorl	%r11d, %ebx
    1edc: 45 89 cb                     	movl	%r9d, %r11d
    1edf: 41 c1 c3 07                  	roll	$0x7, %r11d
    1ee3: 41 31 db                     	xorl	%ebx, %r11d
    1ee6: 89 c3                        	movl	%eax, %ebx
    1ee8: 31 f3                        	xorl	%esi, %ebx
    1eea: 44 21 cb                     	andl	%r9d, %ebx
    1eed: 31 f3                        	xorl	%esi, %ebx
    1eef: 03 95 70 ff ff ff            	addl	-0x90(%rbp), %edx
    1ef5: 01 da                        	addl	%ebx, %edx
    1ef7: 41 01 d3                     	addl	%edx, %r11d
    1efa: 41 81 c3 a1 e8 bf a2         	addl	$0xa2bfe8a1, %r11d      # imm = 0xA2BFE8A1
    1f01: 44 01 df                     	addl	%r11d, %edi
    1f04: 44 89 d2                     	movl	%r10d, %edx
    1f07: c1 c2 1e                     	roll	$0x1e, %edx
    1f0a: 44 89 d3                     	movl	%r10d, %ebx
    1f0d: c1 c3 13                     	roll	$0x13, %ebx
    1f10: 31 d3                        	xorl	%edx, %ebx
    1f12: 45 89 d6                     	movl	%r10d, %r14d
    1f15: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1f19: 41 31 de                     	xorl	%ebx, %r14d
    1f1c: 89 cb                        	movl	%ecx, %ebx
    1f1e: 44 09 c3                     	orl	%r8d, %ebx
    1f21: 44 21 d3                     	andl	%r10d, %ebx
    1f24: 89 ca                        	movl	%ecx, %edx
    1f26: 44 21 c2                     	andl	%r8d, %edx
    1f29: 09 da                        	orl	%ebx, %edx
    1f2b: 44 01 f2                     	addl	%r14d, %edx
    1f2e: 44 01 da                     	addl	%r11d, %edx
    1f31: 41 89 fb                     	movl	%edi, %r11d
    1f34: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1f38: 89 fb                        	movl	%edi, %ebx
    1f3a: c1 c3 15                     	roll	$0x15, %ebx
    1f3d: 44 31 db                     	xorl	%r11d, %ebx
    1f40: 41 89 fb                     	movl	%edi, %r11d
    1f43: 41 c1 c3 07                  	roll	$0x7, %r11d
    1f47: 41 31 db                     	xorl	%ebx, %r11d
    1f4a: 44 89 cb                     	movl	%r9d, %ebx
    1f4d: 31 c3                        	xorl	%eax, %ebx
    1f4f: 21 fb                        	andl	%edi, %ebx
    1f51: 03 b5 74 ff ff ff            	addl	-0x8c(%rbp), %esi
    1f57: 31 c3                        	xorl	%eax, %ebx
    1f59: 01 de                        	addl	%ebx, %esi
    1f5b: 41 01 f3                     	addl	%esi, %r11d
    1f5e: 41 81 c3 4b 66 1a a8         	addl	$0xa81a664b, %r11d      # imm = 0xA81A664B
    1f65: 45 01 d8                     	addl	%r11d, %r8d
    1f68: 89 d6                        	movl	%edx, %esi
    1f6a: c1 c6 1e                     	roll	$0x1e, %esi
    1f6d: 89 d3                        	movl	%edx, %ebx
    1f6f: c1 c3 13                     	roll	$0x13, %ebx
    1f72: 31 f3                        	xorl	%esi, %ebx
    1f74: 41 89 d6                     	movl	%edx, %r14d
    1f77: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1f7b: 41 31 de                     	xorl	%ebx, %r14d
    1f7e: 44 89 d3                     	movl	%r10d, %ebx
    1f81: 09 cb                        	orl	%ecx, %ebx
    1f83: 21 d3                        	andl	%edx, %ebx
    1f85: 44 89 d6                     	movl	%r10d, %esi
    1f88: 21 ce                        	andl	%ecx, %esi
    1f8a: 09 de                        	orl	%ebx, %esi
    1f8c: 44 89 c3                     	movl	%r8d, %ebx
    1f8f: c1 c3 1a                     	roll	$0x1a, %ebx
    1f92: 44 01 f6                     	addl	%r14d, %esi
    1f95: 45 89 c6                     	movl	%r8d, %r14d
    1f98: 41 c1 c6 15                  	roll	$0x15, %r14d
    1f9c: 44 01 de                     	addl	%r11d, %esi
    1f9f: 45 89 c3                     	movl	%r8d, %r11d
    1fa2: 41 c1 c3 07                  	roll	$0x7, %r11d
    1fa6: 41 31 de                     	xorl	%ebx, %r14d
    1fa9: 45 31 f3                     	xorl	%r14d, %r11d
    1fac: 89 fb                        	movl	%edi, %ebx
    1fae: 44 31 cb                     	xorl	%r9d, %ebx
    1fb1: 44 21 c3                     	andl	%r8d, %ebx
    1fb4: 44 31 cb                     	xorl	%r9d, %ebx
    1fb7: 03 85 78 ff ff ff            	addl	-0x88(%rbp), %eax
    1fbd: 01 d8                        	addl	%ebx, %eax
    1fbf: 89 f3                        	movl	%esi, %ebx
    1fc1: c1 c3 1e                     	roll	$0x1e, %ebx
    1fc4: 41 01 c3                     	addl	%eax, %r11d
    1fc7: 41 81 c3 70 8b 4b c2         	addl	$0xc24b8b70, %r11d      # imm = 0xC24B8B70
    1fce: 89 f0                        	movl	%esi, %eax
    1fd0: c1 c0 13                     	roll	$0x13, %eax
    1fd3: 44 01 d9                     	addl	%r11d, %ecx
    1fd6: 41 89 f6                     	movl	%esi, %r14d
    1fd9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1fdd: 31 d8                        	xorl	%ebx, %eax
    1fdf: 41 31 c6                     	xorl	%eax, %r14d
    1fe2: 89 d3                        	movl	%edx, %ebx
    1fe4: 44 09 d3                     	orl	%r10d, %ebx
    1fe7: 21 f3                        	andl	%esi, %ebx
    1fe9: 89 d0                        	movl	%edx, %eax
    1feb: 44 21 d0                     	andl	%r10d, %eax
    1fee: 09 d8                        	orl	%ebx, %eax
    1ff0: 44 01 f0                     	addl	%r14d, %eax
    1ff3: 89 cb                        	movl	%ecx, %ebx
    1ff5: c1 c3 1a                     	roll	$0x1a, %ebx
    1ff8: 44 01 d8                     	addl	%r11d, %eax
    1ffb: 41 89 cb                     	movl	%ecx, %r11d
    1ffe: 41 c1 c3 15                  	roll	$0x15, %r11d
    2002: 41 31 db                     	xorl	%ebx, %r11d
    2005: 89 cb                        	movl	%ecx, %ebx
    2007: c1 c3 07                     	roll	$0x7, %ebx
    200a: 44 31 db                     	xorl	%r11d, %ebx
    200d: 45 89 c3                     	movl	%r8d, %r11d
    2010: 41 31 fb                     	xorl	%edi, %r11d
    2013: 41 21 cb                     	andl	%ecx, %r11d
    2016: 41 31 fb                     	xorl	%edi, %r11d
    2019: 44 03 8d 7c ff ff ff         	addl	-0x84(%rbp), %r9d
    2020: 45 01 d9                     	addl	%r11d, %r9d
    2023: 41 01 d9                     	addl	%ebx, %r9d
    2026: 41 81 c1 a3 51 6c c7         	addl	$0xc76c51a3, %r9d       # imm = 0xC76C51A3
    202d: 41 89 c3                     	movl	%eax, %r11d
    2030: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    2034: 45 01 ca                     	addl	%r9d, %r10d
    2037: 89 c3                        	movl	%eax, %ebx
    2039: c1 c3 13                     	roll	$0x13, %ebx
    203c: 44 31 db                     	xorl	%r11d, %ebx
    203f: 41 89 c6                     	movl	%eax, %r14d
    2042: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2046: 41 31 de                     	xorl	%ebx, %r14d
    2049: 89 f3                        	movl	%esi, %ebx
    204b: 09 d3                        	orl	%edx, %ebx
    204d: 21 c3                        	andl	%eax, %ebx
    204f: 41 89 f3                     	movl	%esi, %r11d
    2052: 41 21 d3                     	andl	%edx, %r11d
    2055: 41 09 db                     	orl	%ebx, %r11d
    2058: 45 01 f3                     	addl	%r14d, %r11d
    205b: 45 01 cb                     	addl	%r9d, %r11d
    205e: 45 89 d1                     	movl	%r10d, %r9d
    2061: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    2065: 44 89 d3                     	movl	%r10d, %ebx
    2068: c1 c3 15                     	roll	$0x15, %ebx
    206b: 44 31 cb                     	xorl	%r9d, %ebx
    206e: 45 89 d1                     	movl	%r10d, %r9d
    2071: 41 c1 c1 07                  	roll	$0x7, %r9d
    2075: 41 31 d9                     	xorl	%ebx, %r9d
    2078: 89 cb                        	movl	%ecx, %ebx
    207a: 44 31 c3                     	xorl	%r8d, %ebx
    207d: 44 21 d3                     	andl	%r10d, %ebx
    2080: 44 31 c3                     	xorl	%r8d, %ebx
    2083: 03 7d 80                     	addl	-0x80(%rbp), %edi
    2086: 01 df                        	addl	%ebx, %edi
    2088: 41 01 f9                     	addl	%edi, %r9d
    208b: 41 81 c1 19 e8 92 d1         	addl	$0xd192e819, %r9d       # imm = 0xD192E819
    2092: 44 01 ca                     	addl	%r9d, %edx
    2095: 44 89 df                     	movl	%r11d, %edi
    2098: c1 c7 1e                     	roll	$0x1e, %edi
    209b: 44 89 db                     	movl	%r11d, %ebx
    209e: c1 c3 13                     	roll	$0x13, %ebx
    20a1: 31 fb                        	xorl	%edi, %ebx
    20a3: 45 89 de                     	movl	%r11d, %r14d
    20a6: 41 c1 c6 0a                  	roll	$0xa, %r14d
    20aa: 41 31 de                     	xorl	%ebx, %r14d
    20ad: 89 c3                        	movl	%eax, %ebx
    20af: 09 f3                        	orl	%esi, %ebx
    20b1: 44 21 db                     	andl	%r11d, %ebx
    20b4: 89 c7                        	movl	%eax, %edi
    20b6: 21 f7                        	andl	%esi, %edi
    20b8: 09 df                        	orl	%ebx, %edi
    20ba: 44 01 f7                     	addl	%r14d, %edi
    20bd: 44 01 cf                     	addl	%r9d, %edi
    20c0: 41 89 d1                     	movl	%edx, %r9d
    20c3: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    20c7: 89 d3                        	movl	%edx, %ebx
    20c9: c1 c3 15                     	roll	$0x15, %ebx
    20cc: 44 31 cb                     	xorl	%r9d, %ebx
    20cf: 41 89 d1                     	movl	%edx, %r9d
    20d2: 41 c1 c1 07                  	roll	$0x7, %r9d
    20d6: 41 31 d9                     	xorl	%ebx, %r9d
    20d9: 44 89 d3                     	movl	%r10d, %ebx
    20dc: 31 cb                        	xorl	%ecx, %ebx
    20de: 21 d3                        	andl	%edx, %ebx
    20e0: 44 03 45 84                  	addl	-0x7c(%rbp), %r8d
    20e4: 31 cb                        	xorl	%ecx, %ebx
    20e6: 41 01 d8                     	addl	%ebx, %r8d
    20e9: 45 01 c1                     	addl	%r8d, %r9d
    20ec: 41 81 c1 24 06 99 d6         	addl	$0xd6990624, %r9d       # imm = 0xD6990624
    20f3: 44 01 ce                     	addl	%r9d, %esi
    20f6: 41 89 f8                     	movl	%edi, %r8d
    20f9: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    20fd: 89 fb                        	movl	%edi, %ebx
    20ff: c1 c3 13                     	roll	$0x13, %ebx
    2102: 44 31 c3                     	xorl	%r8d, %ebx
    2105: 41 89 fe                     	movl	%edi, %r14d
    2108: 41 c1 c6 0a                  	roll	$0xa, %r14d
    210c: 41 31 de                     	xorl	%ebx, %r14d
    210f: 44 89 db                     	movl	%r11d, %ebx
    2112: 09 c3                        	orl	%eax, %ebx
    2114: 21 fb                        	andl	%edi, %ebx
    2116: 45 89 d8                     	movl	%r11d, %r8d
    2119: 41 21 c0                     	andl	%eax, %r8d
    211c: 41 09 d8                     	orl	%ebx, %r8d
    211f: 89 f3                        	movl	%esi, %ebx
    2121: c1 c3 1a                     	roll	$0x1a, %ebx
    2124: 45 01 f0                     	addl	%r14d, %r8d
    2127: 41 89 f6                     	movl	%esi, %r14d
    212a: 41 c1 c6 15                  	roll	$0x15, %r14d
    212e: 45 01 c8                     	addl	%r9d, %r8d
    2131: 41 89 f1                     	movl	%esi, %r9d
    2134: 41 c1 c1 07                  	roll	$0x7, %r9d
    2138: 41 31 de                     	xorl	%ebx, %r14d
    213b: 45 31 f1                     	xorl	%r14d, %r9d
    213e: 89 d3                        	movl	%edx, %ebx
    2140: 44 31 d3                     	xorl	%r10d, %ebx
    2143: 21 f3                        	andl	%esi, %ebx
    2145: 44 31 d3                     	xorl	%r10d, %ebx
    2148: 03 4d 88                     	addl	-0x78(%rbp), %ecx
    214b: 01 d9                        	addl	%ebx, %ecx
    214d: 44 89 c3                     	movl	%r8d, %ebx
    2150: c1 c3 1e                     	roll	$0x1e, %ebx
    2153: 41 01 c9                     	addl	%ecx, %r9d
    2156: 41 81 c1 85 35 0e f4         	addl	$0xf40e3585, %r9d       # imm = 0xF40E3585
    215d: 44 89 c1                     	movl	%r8d, %ecx
    2160: c1 c1 13                     	roll	$0x13, %ecx
    2163: 44 01 c8                     	addl	%r9d, %eax
    2166: 45 89 c6                     	movl	%r8d, %r14d
    2169: 41 c1 c6 0a                  	roll	$0xa, %r14d
    216d: 31 d9                        	xorl	%ebx, %ecx
    216f: 41 31 ce                     	xorl	%ecx, %r14d
    2172: 89 fb                        	movl	%edi, %ebx
    2174: 44 09 db                     	orl	%r11d, %ebx
    2177: 44 21 c3                     	andl	%r8d, %ebx
    217a: 89 f9                        	movl	%edi, %ecx
    217c: 44 21 d9                     	andl	%r11d, %ecx
    217f: 09 d9                        	orl	%ebx, %ecx
    2181: 44 01 f1                     	addl	%r14d, %ecx
    2184: 89 c3                        	movl	%eax, %ebx
    2186: c1 c3 1a                     	roll	$0x1a, %ebx
    2189: 44 01 c9                     	addl	%r9d, %ecx
    218c: 41 89 c1                     	movl	%eax, %r9d
    218f: 41 c1 c1 15                  	roll	$0x15, %r9d
    2193: 41 31 d9                     	xorl	%ebx, %r9d
    2196: 89 c3                        	movl	%eax, %ebx
    2198: c1 c3 07                     	roll	$0x7, %ebx
    219b: 44 31 cb                     	xorl	%r9d, %ebx
    219e: 41 89 f1                     	movl	%esi, %r9d
    21a1: 41 31 d1                     	xorl	%edx, %r9d
    21a4: 41 21 c1                     	andl	%eax, %r9d
    21a7: 41 31 d1                     	xorl	%edx, %r9d
    21aa: 44 03 55 8c                  	addl	-0x74(%rbp), %r10d
    21ae: 45 01 ca                     	addl	%r9d, %r10d
    21b1: 46 8d 0c 13                  	leal	(%rbx,%r10), %r9d
    21b5: 41 81 c1 70 a0 6a 10         	addl	$0x106aa070, %r9d       # imm = 0x106AA070
    21bc: 41 89 ca                     	movl	%ecx, %r10d
    21bf: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    21c3: 45 01 cb                     	addl	%r9d, %r11d
    21c6: 89 cb                        	movl	%ecx, %ebx
    21c8: c1 c3 13                     	roll	$0x13, %ebx
    21cb: 44 31 d3                     	xorl	%r10d, %ebx
    21ce: 41 89 ce                     	movl	%ecx, %r14d
    21d1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    21d5: 41 31 de                     	xorl	%ebx, %r14d
    21d8: 44 89 c3                     	movl	%r8d, %ebx
    21db: 09 fb                        	orl	%edi, %ebx
    21dd: 21 cb                        	andl	%ecx, %ebx
    21df: 45 89 c2                     	movl	%r8d, %r10d
    21e2: 41 21 fa                     	andl	%edi, %r10d
    21e5: 41 09 da                     	orl	%ebx, %r10d
    21e8: 45 01 f2                     	addl	%r14d, %r10d
    21eb: 45 01 ca                     	addl	%r9d, %r10d
    21ee: 45 89 d9                     	movl	%r11d, %r9d
    21f1: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    21f5: 44 89 db                     	movl	%r11d, %ebx
    21f8: c1 c3 15                     	roll	$0x15, %ebx
    21fb: 44 31 cb                     	xorl	%r9d, %ebx
    21fe: 45 89 d9                     	movl	%r11d, %r9d
    2201: 41 c1 c1 07                  	roll	$0x7, %r9d
    2205: 41 31 d9                     	xorl	%ebx, %r9d
    2208: 89 c3                        	movl	%eax, %ebx
    220a: 31 f3                        	xorl	%esi, %ebx
    220c: 44 21 db                     	andl	%r11d, %ebx
    220f: 31 f3                        	xorl	%esi, %ebx
    2211: 03 55 90                     	addl	-0x70(%rbp), %edx
    2214: 01 da                        	addl	%ebx, %edx
    2216: 44 01 ca                     	addl	%r9d, %edx
    2219: 81 c2 16 c1 a4 19            	addl	$0x19a4c116, %edx       # imm = 0x19A4C116
    221f: 01 d7                        	addl	%edx, %edi
    2221: 45 89 d1                     	movl	%r10d, %r9d
    2224: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    2228: 44 89 d3                     	movl	%r10d, %ebx
    222b: c1 c3 13                     	roll	$0x13, %ebx
    222e: 44 31 cb                     	xorl	%r9d, %ebx
    2231: 45 89 d6                     	movl	%r10d, %r14d
    2234: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2238: 41 31 de                     	xorl	%ebx, %r14d
    223b: 89 cb                        	movl	%ecx, %ebx
    223d: 44 09 c3                     	orl	%r8d, %ebx
    2240: 44 21 d3                     	andl	%r10d, %ebx
    2243: 41 89 c9                     	movl	%ecx, %r9d
    2246: 45 21 c1                     	andl	%r8d, %r9d
    2249: 41 09 d9                     	orl	%ebx, %r9d
    224c: 45 01 f1                     	addl	%r14d, %r9d
    224f: 41 01 d1                     	addl	%edx, %r9d
    2252: 89 fa                        	movl	%edi, %edx
    2254: c1 c2 1a                     	roll	$0x1a, %edx
    2257: 89 fb                        	movl	%edi, %ebx
    2259: c1 c3 15                     	roll	$0x15, %ebx
    225c: 31 d3                        	xorl	%edx, %ebx
    225e: 89 fa                        	movl	%edi, %edx
    2260: c1 c2 07                     	roll	$0x7, %edx
    2263: 31 da                        	xorl	%ebx, %edx
    2265: 44 89 db                     	movl	%r11d, %ebx
    2268: 31 c3                        	xorl	%eax, %ebx
    226a: 21 fb                        	andl	%edi, %ebx
    226c: 03 75 94                     	addl	-0x6c(%rbp), %esi
    226f: 31 c3                        	xorl	%eax, %ebx
    2271: 01 de                        	addl	%ebx, %esi
    2273: 01 f2                        	addl	%esi, %edx
    2275: 81 c2 08 6c 37 1e            	addl	$0x1e376c08, %edx       # imm = 0x1E376C08
    227b: 41 01 d0                     	addl	%edx, %r8d
    227e: 44 89 ce                     	movl	%r9d, %esi
    2281: c1 c6 1e                     	roll	$0x1e, %esi
    2284: 44 89 cb                     	movl	%r9d, %ebx
    2287: c1 c3 13                     	roll	$0x13, %ebx
    228a: 31 f3                        	xorl	%esi, %ebx
    228c: 45 89 ce                     	movl	%r9d, %r14d
    228f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2293: 41 31 de                     	xorl	%ebx, %r14d
    2296: 44 89 d3                     	movl	%r10d, %ebx
    2299: 09 cb                        	orl	%ecx, %ebx
    229b: 44 21 cb                     	andl	%r9d, %ebx
    229e: 44 89 d6                     	movl	%r10d, %esi
    22a1: 21 ce                        	andl	%ecx, %esi
    22a3: 09 de                        	orl	%ebx, %esi
    22a5: 44 89 c3                     	movl	%r8d, %ebx
    22a8: c1 c3 1a                     	roll	$0x1a, %ebx
    22ab: 44 01 f6                     	addl	%r14d, %esi
    22ae: 45 89 c6                     	movl	%r8d, %r14d
    22b1: 41 c1 c6 15                  	roll	$0x15, %r14d
    22b5: 01 d6                        	addl	%edx, %esi
    22b7: 44 89 c2                     	movl	%r8d, %edx
    22ba: c1 c2 07                     	roll	$0x7, %edx
    22bd: 41 31 de                     	xorl	%ebx, %r14d
    22c0: 44 31 f2                     	xorl	%r14d, %edx
    22c3: 89 fb                        	movl	%edi, %ebx
    22c5: 44 31 db                     	xorl	%r11d, %ebx
    22c8: 44 21 c3                     	andl	%r8d, %ebx
    22cb: 44 31 db                     	xorl	%r11d, %ebx
    22ce: 03 45 98                     	addl	-0x68(%rbp), %eax
    22d1: 01 d8                        	addl	%ebx, %eax
    22d3: 89 f3                        	movl	%esi, %ebx
    22d5: c1 c3 1e                     	roll	$0x1e, %ebx
    22d8: 01 d0                        	addl	%edx, %eax
    22da: 05 4c 77 48 27               	addl	$0x2748774c, %eax       # imm = 0x2748774C
    22df: 89 f2                        	movl	%esi, %edx
    22e1: c1 c2 13                     	roll	$0x13, %edx
    22e4: 01 c1                        	addl	%eax, %ecx
    22e6: 41 89 f6                     	movl	%esi, %r14d
    22e9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    22ed: 31 da                        	xorl	%ebx, %edx
    22ef: 41 31 d6                     	xorl	%edx, %r14d
    22f2: 44 89 cb                     	movl	%r9d, %ebx
    22f5: 44 09 d3                     	orl	%r10d, %ebx
    22f8: 21 f3                        	andl	%esi, %ebx
    22fa: 44 89 ca                     	movl	%r9d, %edx
    22fd: 44 21 d2                     	andl	%r10d, %edx
    2300: 09 da                        	orl	%ebx, %edx
    2302: 44 01 f2                     	addl	%r14d, %edx
    2305: 89 cb                        	movl	%ecx, %ebx
    2307: c1 c3 1a                     	roll	$0x1a, %ebx
    230a: 01 c2                        	addl	%eax, %edx
    230c: 89 c8                        	movl	%ecx, %eax
    230e: c1 c0 15                     	roll	$0x15, %eax
    2311: 31 d8                        	xorl	%ebx, %eax
    2313: 89 cb                        	movl	%ecx, %ebx
    2315: c1 c3 07                     	roll	$0x7, %ebx
    2318: 31 c3                        	xorl	%eax, %ebx
    231a: 44 89 c0                     	movl	%r8d, %eax
    231d: 31 f8                        	xorl	%edi, %eax
    231f: 21 c8                        	andl	%ecx, %eax
    2321: 31 f8                        	xorl	%edi, %eax
    2323: 44 03 5d 9c                  	addl	-0x64(%rbp), %r11d
    2327: 41 01 c3                     	addl	%eax, %r11d
    232a: 42 8d 04 1b                  	leal	(%rbx,%r11), %eax
    232e: 05 b5 bc b0 34               	addl	$0x34b0bcb5, %eax       # imm = 0x34B0BCB5
    2333: 41 89 d3                     	movl	%edx, %r11d
    2336: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    233a: 41 01 c2                     	addl	%eax, %r10d
    233d: 89 d3                        	movl	%edx, %ebx
    233f: c1 c3 13                     	roll	$0x13, %ebx
    2342: 44 31 db                     	xorl	%r11d, %ebx
    2345: 41 89 d6                     	movl	%edx, %r14d
    2348: 41 c1 c6 0a                  	roll	$0xa, %r14d
    234c: 41 31 de                     	xorl	%ebx, %r14d
    234f: 89 f3                        	movl	%esi, %ebx
    2351: 44 09 cb                     	orl	%r9d, %ebx
    2354: 21 d3                        	andl	%edx, %ebx
    2356: 41 89 f3                     	movl	%esi, %r11d
    2359: 45 21 cb                     	andl	%r9d, %r11d
    235c: 41 09 db                     	orl	%ebx, %r11d
    235f: 45 01 f3                     	addl	%r14d, %r11d
    2362: 41 01 c3                     	addl	%eax, %r11d
    2365: 44 89 d0                     	movl	%r10d, %eax
    2368: c1 c0 1a                     	roll	$0x1a, %eax
    236b: 44 89 d3                     	movl	%r10d, %ebx
    236e: c1 c3 15                     	roll	$0x15, %ebx
    2371: 31 c3                        	xorl	%eax, %ebx
    2373: 44 89 d0                     	movl	%r10d, %eax
    2376: c1 c0 07                     	roll	$0x7, %eax
    2379: 31 d8                        	xorl	%ebx, %eax
    237b: 89 cb                        	movl	%ecx, %ebx
    237d: 44 31 c3                     	xorl	%r8d, %ebx
    2380: 44 21 d3                     	andl	%r10d, %ebx
    2383: 44 31 c3                     	xorl	%r8d, %ebx
    2386: 03 7d a0                     	addl	-0x60(%rbp), %edi
    2389: 01 df                        	addl	%ebx, %edi
    238b: 01 f8                        	addl	%edi, %eax
    238d: 05 b3 0c 1c 39               	addl	$0x391c0cb3, %eax       # imm = 0x391C0CB3
    2392: 41 01 c1                     	addl	%eax, %r9d
    2395: 44 89 df                     	movl	%r11d, %edi
    2398: c1 c7 1e                     	roll	$0x1e, %edi
    239b: 44 89 db                     	movl	%r11d, %ebx
    239e: c1 c3 13                     	roll	$0x13, %ebx
    23a1: 31 fb                        	xorl	%edi, %ebx
    23a3: 45 89 de                     	movl	%r11d, %r14d
    23a6: 41 c1 c6 0a                  	roll	$0xa, %r14d
    23aa: 41 31 de                     	xorl	%ebx, %r14d
    23ad: 89 d3                        	movl	%edx, %ebx
    23af: 09 f3                        	orl	%esi, %ebx
    23b1: 44 21 db                     	andl	%r11d, %ebx
    23b4: 89 d7                        	movl	%edx, %edi
    23b6: 21 f7                        	andl	%esi, %edi
    23b8: 09 df                        	orl	%ebx, %edi
    23ba: 44 01 f7                     	addl	%r14d, %edi
    23bd: 01 c7                        	addl	%eax, %edi
    23bf: 44 89 c8                     	movl	%r9d, %eax
    23c2: c1 c0 1a                     	roll	$0x1a, %eax
    23c5: 44 89 cb                     	movl	%r9d, %ebx
    23c8: c1 c3 15                     	roll	$0x15, %ebx
    23cb: 31 c3                        	xorl	%eax, %ebx
    23cd: 44 89 c8                     	movl	%r9d, %eax
    23d0: c1 c0 07                     	roll	$0x7, %eax
    23d3: 31 d8                        	xorl	%ebx, %eax
    23d5: 44 89 d3                     	movl	%r10d, %ebx
    23d8: 31 cb                        	xorl	%ecx, %ebx
    23da: 44 21 cb                     	andl	%r9d, %ebx
    23dd: 44 03 45 a4                  	addl	-0x5c(%rbp), %r8d
    23e1: 31 cb                        	xorl	%ecx, %ebx
    23e3: 41 01 d8                     	addl	%ebx, %r8d
    23e6: 44 01 c0                     	addl	%r8d, %eax
    23e9: 05 4a aa d8 4e               	addl	$0x4ed8aa4a, %eax       # imm = 0x4ED8AA4A
    23ee: 01 c6                        	addl	%eax, %esi
    23f0: 41 89 f8                     	movl	%edi, %r8d
    23f3: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    23f7: 89 fb                        	movl	%edi, %ebx
    23f9: c1 c3 13                     	roll	$0x13, %ebx
    23fc: 44 31 c3                     	xorl	%r8d, %ebx
    23ff: 41 89 fe                     	movl	%edi, %r14d
    2402: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2406: 41 31 de                     	xorl	%ebx, %r14d
    2409: 44 89 db                     	movl	%r11d, %ebx
    240c: 09 d3                        	orl	%edx, %ebx
    240e: 21 fb                        	andl	%edi, %ebx
    2410: 45 89 d8                     	movl	%r11d, %r8d
    2413: 41 21 d0                     	andl	%edx, %r8d
    2416: 41 09 d8                     	orl	%ebx, %r8d
    2419: 89 f3                        	movl	%esi, %ebx
    241b: c1 c3 1a                     	roll	$0x1a, %ebx
    241e: 45 01 f0                     	addl	%r14d, %r8d
    2421: 41 89 f6                     	movl	%esi, %r14d
    2424: 41 c1 c6 15                  	roll	$0x15, %r14d
    2428: 41 01 c0                     	addl	%eax, %r8d
    242b: 89 f0                        	movl	%esi, %eax
    242d: c1 c0 07                     	roll	$0x7, %eax
    2430: 41 31 de                     	xorl	%ebx, %r14d
    2433: 44 31 f0                     	xorl	%r14d, %eax
    2436: 44 89 cb                     	movl	%r9d, %ebx
    2439: 44 31 d3                     	xorl	%r10d, %ebx
    243c: 21 f3                        	andl	%esi, %ebx
    243e: 44 31 d3                     	xorl	%r10d, %ebx
    2441: 03 4d a8                     	addl	-0x58(%rbp), %ecx
    2444: 01 d9                        	addl	%ebx, %ecx
    2446: 44 89 c3                     	movl	%r8d, %ebx
    2449: c1 c3 1e                     	roll	$0x1e, %ebx
    244c: 01 c8                        	addl	%ecx, %eax
    244e: 05 4f ca 9c 5b               	addl	$0x5b9cca4f, %eax       # imm = 0x5B9CCA4F
    2453: 44 89 c1                     	movl	%r8d, %ecx
    2456: c1 c1 13                     	roll	$0x13, %ecx
    2459: 01 c2                        	addl	%eax, %edx
    245b: 45 89 c6                     	movl	%r8d, %r14d
    245e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2462: 31 d9                        	xorl	%ebx, %ecx
    2464: 41 31 ce                     	xorl	%ecx, %r14d
    2467: 89 f9                        	movl	%edi, %ecx
    2469: 44 09 d9                     	orl	%r11d, %ecx
    246c: 44 21 c1                     	andl	%r8d, %ecx
    246f: 89 fb                        	movl	%edi, %ebx
    2471: 44 21 db                     	andl	%r11d, %ebx
    2474: 09 cb                        	orl	%ecx, %ebx
    2476: 44 01 f3                     	addl	%r14d, %ebx
    2479: 89 d1                        	movl	%edx, %ecx
    247b: c1 c1 1a                     	roll	$0x1a, %ecx
    247e: 01 c3                        	addl	%eax, %ebx
    2480: 89 d0                        	movl	%edx, %eax
    2482: c1 c0 15                     	roll	$0x15, %eax
    2485: 31 c8                        	xorl	%ecx, %eax
    2487: 89 d1                        	movl	%edx, %ecx
    2489: c1 c1 07                     	roll	$0x7, %ecx
    248c: 31 c1                        	xorl	%eax, %ecx
    248e: 89 f0                        	movl	%esi, %eax
    2490: 44 31 c8                     	xorl	%r9d, %eax
    2493: 21 d0                        	andl	%edx, %eax
    2495: 44 31 c8                     	xorl	%r9d, %eax
    2498: 44 03 55 ac                  	addl	-0x54(%rbp), %r10d
    249c: 41 01 c2                     	addl	%eax, %r10d
    249f: 42 8d 04 11                  	leal	(%rcx,%r10), %eax
    24a3: 05 f3 6f 2e 68               	addl	$0x682e6ff3, %eax       # imm = 0x682E6FF3
    24a8: 89 d9                        	movl	%ebx, %ecx
    24aa: c1 c1 1e                     	roll	$0x1e, %ecx
    24ad: 41 01 c3                     	addl	%eax, %r11d
    24b0: 41 89 da                     	movl	%ebx, %r10d
    24b3: 41 c1 c2 13                  	roll	$0x13, %r10d
    24b7: 41 31 ca                     	xorl	%ecx, %r10d
    24ba: 41 89 de                     	movl	%ebx, %r14d
    24bd: 41 c1 c6 0a                  	roll	$0xa, %r14d
    24c1: 45 31 d6                     	xorl	%r10d, %r14d
    24c4: 45 89 c2                     	movl	%r8d, %r10d
    24c7: 41 09 fa                     	orl	%edi, %r10d
    24ca: 41 21 da                     	andl	%ebx, %r10d
    24cd: 44 89 c1                     	movl	%r8d, %ecx
    24d0: 21 f9                        	andl	%edi, %ecx
    24d2: 44 09 d1                     	orl	%r10d, %ecx
    24d5: 44 01 f1                     	addl	%r14d, %ecx
    24d8: 01 c1                        	addl	%eax, %ecx
    24da: 44 89 d8                     	movl	%r11d, %eax
    24dd: c1 c0 1a                     	roll	$0x1a, %eax
    24e0: 45 89 da                     	movl	%r11d, %r10d
    24e3: 41 c1 c2 15                  	roll	$0x15, %r10d
    24e7: 41 31 c2                     	xorl	%eax, %r10d
    24ea: 44 89 d8                     	movl	%r11d, %eax
    24ed: c1 c0 07                     	roll	$0x7, %eax
    24f0: 44 31 d0                     	xorl	%r10d, %eax
    24f3: 41 89 d2                     	movl	%edx, %r10d
    24f6: 41 31 f2                     	xorl	%esi, %r10d
    24f9: 45 21 da                     	andl	%r11d, %r10d
    24fc: 41 31 f2                     	xorl	%esi, %r10d
    24ff: 44 03 4d b0                  	addl	-0x50(%rbp), %r9d
    2503: 45 01 d1                     	addl	%r10d, %r9d
    2506: 41 01 c1                     	addl	%eax, %r9d
    2509: 41 81 c1 ee 82 8f 74         	addl	$0x748f82ee, %r9d       # imm = 0x748F82EE
    2510: 44 01 cf                     	addl	%r9d, %edi
    2513: 89 c8                        	movl	%ecx, %eax
    2515: c1 c0 1e                     	roll	$0x1e, %eax
    2518: 41 89 ca                     	movl	%ecx, %r10d
    251b: 41 c1 c2 13                  	roll	$0x13, %r10d
    251f: 41 31 c2                     	xorl	%eax, %r10d
    2522: 41 89 ce                     	movl	%ecx, %r14d
    2525: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2529: 45 31 d6                     	xorl	%r10d, %r14d
    252c: 41 89 da                     	movl	%ebx, %r10d
    252f: 45 09 c2                     	orl	%r8d, %r10d
    2532: 41 21 ca                     	andl	%ecx, %r10d
    2535: 89 d8                        	movl	%ebx, %eax
    2537: 44 21 c0                     	andl	%r8d, %eax
    253a: 44 09 d0                     	orl	%r10d, %eax
    253d: 44 01 f0                     	addl	%r14d, %eax
    2540: 44 01 c8                     	addl	%r9d, %eax
    2543: 41 89 f9                     	movl	%edi, %r9d
    2546: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    254a: 41 89 fa                     	movl	%edi, %r10d
    254d: 41 c1 c2 15                  	roll	$0x15, %r10d
    2551: 45 31 ca                     	xorl	%r9d, %r10d
    2554: 41 89 f9                     	movl	%edi, %r9d
    2557: 41 c1 c1 07                  	roll	$0x7, %r9d
    255b: 45 31 d1                     	xorl	%r10d, %r9d
    255e: 45 89 da                     	movl	%r11d, %r10d
    2561: 41 31 d2                     	xorl	%edx, %r10d
    2564: 41 21 fa                     	andl	%edi, %r10d
    2567: 03 75 b4                     	addl	-0x4c(%rbp), %esi
    256a: 41 31 d2                     	xorl	%edx, %r10d
    256d: 44 01 d6                     	addl	%r10d, %esi
    2570: 41 01 f1                     	addl	%esi, %r9d
    2573: 41 81 c1 6f 63 a5 78         	addl	$0x78a5636f, %r9d       # imm = 0x78A5636F
    257a: 45 01 c8                     	addl	%r9d, %r8d
    257d: 89 c6                        	movl	%eax, %esi
    257f: c1 c6 1e                     	roll	$0x1e, %esi
    2582: 41 89 c2                     	movl	%eax, %r10d
    2585: 41 c1 c2 13                  	roll	$0x13, %r10d
    2589: 41 31 f2                     	xorl	%esi, %r10d
    258c: 41 89 c6                     	movl	%eax, %r14d
    258f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2593: 45 31 d6                     	xorl	%r10d, %r14d
    2596: 41 89 ca                     	movl	%ecx, %r10d
    2599: 41 09 da                     	orl	%ebx, %r10d
    259c: 41 21 c2                     	andl	%eax, %r10d
    259f: 89 ce                        	movl	%ecx, %esi
    25a1: 21 de                        	andl	%ebx, %esi
    25a3: 44 09 d6                     	orl	%r10d, %esi
    25a6: 45 89 c2                     	movl	%r8d, %r10d
    25a9: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    25ad: 44 01 f6                     	addl	%r14d, %esi
    25b0: 45 89 c6                     	movl	%r8d, %r14d
    25b3: 41 c1 c6 15                  	roll	$0x15, %r14d
    25b7: 44 01 ce                     	addl	%r9d, %esi
    25ba: 45 89 c1                     	movl	%r8d, %r9d
    25bd: 41 c1 c1 07                  	roll	$0x7, %r9d
    25c1: 45 31 d6                     	xorl	%r10d, %r14d
    25c4: 45 31 f1                     	xorl	%r14d, %r9d
    25c7: 41 89 fa                     	movl	%edi, %r10d
    25ca: 45 31 da                     	xorl	%r11d, %r10d
    25cd: 45 21 c2                     	andl	%r8d, %r10d
    25d0: 45 31 da                     	xorl	%r11d, %r10d
    25d3: 03 55 b8                     	addl	-0x48(%rbp), %edx
    25d6: 44 01 d2                     	addl	%r10d, %edx
    25d9: 41 89 f2                     	movl	%esi, %r10d
    25dc: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    25e0: 41 01 d1                     	addl	%edx, %r9d
    25e3: 41 81 c1 14 78 c8 84         	addl	$0x84c87814, %r9d       # imm = 0x84C87814
    25ea: 89 f2                        	movl	%esi, %edx
    25ec: c1 c2 13                     	roll	$0x13, %edx
    25ef: 44 01 cb                     	addl	%r9d, %ebx
    25f2: 41 89 f6                     	movl	%esi, %r14d
    25f5: 41 c1 c6 0a                  	roll	$0xa, %r14d
    25f9: 44 31 d2                     	xorl	%r10d, %edx
    25fc: 41 31 d6                     	xorl	%edx, %r14d
    25ff: 41 89 c2                     	movl	%eax, %r10d
    2602: 41 09 ca                     	orl	%ecx, %r10d
    2605: 41 21 f2                     	andl	%esi, %r10d
    2608: 89 c2                        	movl	%eax, %edx
    260a: 21 ca                        	andl	%ecx, %edx
    260c: 44 09 d2                     	orl	%r10d, %edx
    260f: 44 01 f2                     	addl	%r14d, %edx
    2612: 41 89 da                     	movl	%ebx, %r10d
    2615: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    2619: 44 01 ca                     	addl	%r9d, %edx
    261c: 41 89 d9                     	movl	%ebx, %r9d
    261f: 41 c1 c1 15                  	roll	$0x15, %r9d
    2623: 45 31 d1                     	xorl	%r10d, %r9d
    2626: 41 89 da                     	movl	%ebx, %r10d
    2629: 41 c1 c2 07                  	roll	$0x7, %r10d
    262d: 45 31 ca                     	xorl	%r9d, %r10d
    2630: 45 89 c1                     	movl	%r8d, %r9d
    2633: 41 31 f9                     	xorl	%edi, %r9d
    2636: 41 21 d9                     	andl	%ebx, %r9d
    2639: 41 31 f9                     	xorl	%edi, %r9d
    263c: 44 03 5d bc                  	addl	-0x44(%rbp), %r11d
    2640: 45 01 cb                     	addl	%r9d, %r11d
    2643: 45 01 da                     	addl	%r11d, %r10d
    2646: 41 81 c2 08 02 c7 8c         	addl	$0x8cc70208, %r10d      # imm = 0x8CC70208
    264d: 41 89 d1                     	movl	%edx, %r9d
    2650: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    2654: 44 01 d1                     	addl	%r10d, %ecx
    2657: 41 89 d3                     	movl	%edx, %r11d
    265a: 41 c1 c3 13                  	roll	$0x13, %r11d
    265e: 45 31 cb                     	xorl	%r9d, %r11d
    2661: 41 89 d6                     	movl	%edx, %r14d
    2664: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2668: 45 31 de                     	xorl	%r11d, %r14d
    266b: 41 89 f3                     	movl	%esi, %r11d
    266e: 41 09 c3                     	orl	%eax, %r11d
    2671: 41 21 d3                     	andl	%edx, %r11d
    2674: 41 89 f1                     	movl	%esi, %r9d
    2677: 41 21 c1                     	andl	%eax, %r9d
    267a: 45 09 d9                     	orl	%r11d, %r9d
    267d: 45 01 f1                     	addl	%r14d, %r9d
    2680: 45 01 d1                     	addl	%r10d, %r9d
    2683: 41 89 ca                     	movl	%ecx, %r10d
    2686: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    268a: 41 89 cb                     	movl	%ecx, %r11d
    268d: 41 c1 c3 15                  	roll	$0x15, %r11d
    2691: 45 31 d3                     	xorl	%r10d, %r11d
    2694: 41 89 ca                     	movl	%ecx, %r10d
    2697: 41 c1 c2 07                  	roll	$0x7, %r10d
    269b: 45 31 da                     	xorl	%r11d, %r10d
    269e: 41 89 db                     	movl	%ebx, %r11d
    26a1: 45 31 c3                     	xorl	%r8d, %r11d
    26a4: 41 21 cb                     	andl	%ecx, %r11d
    26a7: 45 31 c3                     	xorl	%r8d, %r11d
    26aa: 03 7d c0                     	addl	-0x40(%rbp), %edi
    26ad: 44 01 df                     	addl	%r11d, %edi
    26b0: 41 01 fa                     	addl	%edi, %r10d
    26b3: 41 81 c2 fa ff be 90         	addl	$0x90befffa, %r10d      # imm = 0x90BEFFFA
    26ba: 44 89 cf                     	movl	%r9d, %edi
    26bd: c1 c7 1e                     	roll	$0x1e, %edi
    26c0: 45 89 cb                     	movl	%r9d, %r11d
    26c3: 41 c1 c3 13                  	roll	$0x13, %r11d
    26c7: 41 31 fb                     	xorl	%edi, %r11d
    26ca: 45 89 ce                     	movl	%r9d, %r14d
    26cd: 41 c1 c6 0a                  	roll	$0xa, %r14d
    26d1: 45 31 de                     	xorl	%r11d, %r14d
    26d4: 41 89 d3                     	movl	%edx, %r11d
    26d7: 41 09 f3                     	orl	%esi, %r11d
    26da: 45 21 cb                     	andl	%r9d, %r11d
    26dd: 89 d7                        	movl	%edx, %edi
    26df: 21 f7                        	andl	%esi, %edi
    26e1: 44 09 df                     	orl	%r11d, %edi
    26e4: 44 01 f7                     	addl	%r14d, %edi
    26e7: 41 89 cb                     	movl	%ecx, %r11d
    26ea: 41 31 db                     	xorl	%ebx, %r11d
    26ed: 44 03 45 c4                  	addl	-0x3c(%rbp), %r8d
    26f1: 44 01 d0                     	addl	%r10d, %eax
    26f4: 41 21 c3                     	andl	%eax, %r11d
    26f7: 41 31 db                     	xorl	%ebx, %r11d
    26fa: 45 01 c3                     	addl	%r8d, %r11d
    26fd: 03 5d c8                     	addl	-0x38(%rbp), %ebx
    2700: 41 89 c0                     	movl	%eax, %r8d
    2703: 41 c1 c0 1a                  	roll	$0x1a, %r8d
    2707: 41 89 c6                     	movl	%eax, %r14d
    270a: 41 c1 c6 15                  	roll	$0x15, %r14d
    270e: 45 31 c6                     	xorl	%r8d, %r14d
    2711: 41 89 c0                     	movl	%eax, %r8d
    2714: 41 c1 c0 07                  	roll	$0x7, %r8d
    2718: 45 31 f0                     	xorl	%r14d, %r8d
    271b: 45 01 d8                     	addl	%r11d, %r8d
    271e: 41 81 c0 eb 6c 50 a4         	addl	$0xa4506ceb, %r8d       # imm = 0xA4506CEB
    2725: 44 01 c6                     	addl	%r8d, %esi
    2728: 41 89 c3                     	movl	%eax, %r11d
    272b: 41 31 cb                     	xorl	%ecx, %r11d
    272e: 41 21 f3                     	andl	%esi, %r11d
    2731: 41 31 cb                     	xorl	%ecx, %r11d
    2734: 41 01 db                     	addl	%ebx, %r11d
    2737: 89 f3                        	movl	%esi, %ebx
    2739: 41 89 f6                     	movl	%esi, %r14d
    273c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    2740: c1 c3 15                     	roll	$0x15, %ebx
    2743: 44 31 f3                     	xorl	%r14d, %ebx
    2746: 41 89 f6                     	movl	%esi, %r14d
    2749: 66 0f 6e c6                  	movd	%esi, %xmm0
    274d: 41 89 f7                     	movl	%esi, %r15d
    2750: 41 c1 c6 07                  	roll	$0x7, %r14d
    2754: 41 31 de                     	xorl	%ebx, %r14d
    2757: 44 89 ce                     	movl	%r9d, %esi
    275a: 09 d6                        	orl	%edx, %esi
    275c: 45 01 f3                     	addl	%r14d, %r11d
    275f: 41 81 c3 f7 a3 f9 be         	addl	$0xbef9a3f7, %r11d      # imm = 0xBEF9A3F7
    2766: 44 89 cb                     	movl	%r9d, %ebx
    2769: 21 d3                        	andl	%edx, %ebx
    276b: 03 4d cc                     	addl	-0x34(%rbp), %ecx
    276e: 44 01 da                     	addl	%r11d, %edx
    2771: 41 31 c7                     	xorl	%eax, %r15d
    2774: 41 21 d7                     	andl	%edx, %r15d
    2777: 41 31 c7                     	xorl	%eax, %r15d
    277a: 41 01 cf                     	addl	%ecx, %r15d
    277d: 44 01 d7                     	addl	%r10d, %edi
    2780: 89 f9                        	movl	%edi, %ecx
    2782: c1 c1 1e                     	roll	$0x1e, %ecx
    2785: 41 89 fa                     	movl	%edi, %r10d
    2788: 41 c1 c2 13                  	roll	$0x13, %r10d
    278c: 41 31 ca                     	xorl	%ecx, %r10d
    278f: 89 f9                        	movl	%edi, %ecx
    2791: c1 c1 0a                     	roll	$0xa, %ecx
    2794: 44 31 d1                     	xorl	%r10d, %ecx
    2797: 21 fe                        	andl	%edi, %esi
    2799: 09 de                        	orl	%ebx, %esi
    279b: 01 ce                        	addl	%ecx, %esi
    279d: 89 d1                        	movl	%edx, %ecx
    279f: 41 89 d2                     	movl	%edx, %r10d
    27a2: 66 0f 6e ca                  	movd	%edx, %xmm1
    27a6: c1 c2 1a                     	roll	$0x1a, %edx
    27a9: c1 c1 15                     	roll	$0x15, %ecx
    27ac: 41 c1 c2 07                  	roll	$0x7, %r10d
    27b0: 31 d1                        	xorl	%edx, %ecx
    27b2: 41 31 ca                     	xorl	%ecx, %r10d
    27b5: 89 fa                        	movl	%edi, %edx
    27b7: 44 09 ca                     	orl	%r9d, %edx
    27ba: 44 01 c6                     	addl	%r8d, %esi
    27bd: 41 89 f0                     	movl	%esi, %r8d
    27c0: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    27c4: 43 8d 0c 3a                  	leal	(%r10,%r15), %ecx
    27c8: 81 c1 f2 78 71 c6            	addl	$0xc67178f2, %ecx       # imm = 0xC67178F2
    27ce: 41 89 f2                     	movl	%esi, %r10d
    27d1: 41 c1 c2 13                  	roll	$0x13, %r10d
    27d5: 45 31 c2                     	xorl	%r8d, %r10d
    27d8: 41 89 f0                     	movl	%esi, %r8d
    27db: 41 c1 c0 0a                  	roll	$0xa, %r8d
    27df: 45 31 d0                     	xorl	%r10d, %r8d
    27e2: 21 f2                        	andl	%esi, %edx
    27e4: 41 89 f2                     	movl	%esi, %r10d
    27e7: 41 09 fa                     	orl	%edi, %r10d
    27ea: 66 0f 6e d6                  	movd	%esi, %xmm2
    27ee: 21 fe                        	andl	%edi, %esi
    27f0: 66 0f 6e df                  	movd	%edi, %xmm3
    27f4: 44 21 cf                     	andl	%r9d, %edi
    27f7: 09 fa                        	orl	%edi, %edx
    27f9: 44 01 c2                     	addl	%r8d, %edx
    27fc: 44 01 da                     	addl	%r11d, %edx
    27ff: 89 d7                        	movl	%edx, %edi
    2801: 41 89 d0                     	movl	%edx, %r8d
    2804: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    2808: c1 c7 13                     	roll	$0x13, %edi
    280b: 44 31 c7                     	xorl	%r8d, %edi
    280e: 41 21 d2                     	andl	%edx, %r10d
    2811: 66 0f 6e e2                  	movd	%edx, %xmm4
    2815: c1 c2 0a                     	roll	$0xa, %edx
    2818: 31 fa                        	xorl	%edi, %edx
    281a: 44 09 d6                     	orl	%r10d, %esi
    281d: 01 d6                        	addl	%edx, %esi
    281f: 41 01 c9                     	addl	%ecx, %r9d
    2822: 01 ce                        	addl	%ecx, %esi
    2824: 66 0f 6e ee                  	movd	%esi, %xmm5
    2828: 66 41 0f 6e f1               	movd	%r9d, %xmm6
    282d: 66 0f 62 ec                  	punpckldq	%xmm4, %xmm5    # xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
    2831: 66 0f 62 d3                  	punpckldq	%xmm3, %xmm2    # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
    2835: 66 0f 6c ea                  	punpcklqdq	%xmm2, %xmm5    # xmm5 = xmm5[0],xmm2[0]
    2839: 66 41 0f fe 6d 00            	paddd	(%r13), %xmm5
    283f: 66 0f 6e d0                  	movd	%eax, %xmm2
    2843: 66 41 0f 7f 6d 00            	movdqa	%xmm5, (%r13)
    2849: 66 0f 62 f1                  	punpckldq	%xmm1, %xmm6    # xmm6 = xmm6[0],xmm1[0],xmm6[1],xmm1[1]
    284d: 66 0f 62 c2                  	punpckldq	%xmm2, %xmm0    # xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
    2851: 66 0f 6c f0                  	punpcklqdq	%xmm0, %xmm6    # xmm6 = xmm6[0],xmm0[0]
    2855: 66 41 0f fe 75 10            	paddd	0x10(%r13), %xmm6
    285b: 66 41 0f 7f 75 10            	movdqa	%xmm6, 0x10(%r13)
    2861: 48 81 c4 28 09 00 00         	addq	$0x928, %rsp            # imm = 0x928
    2868: 5b                           	popq	%rbx
    2869: 41 5c                        	popq	%r12
    286b: 41 5d                        	popq	%r13
    286d: 41 5e                        	popq	%r14
    286f: 41 5f                        	popq	%r15
    2871: 5d                           	popq	%rbp
    2872: c3                           	retq
    2873: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    287d: 0f 1f 00                     	nopl	(%rax)

0000000000002880 <audit_master256>:
    2880: 55                           	pushq	%rbp
    2881: 48 89 e5                     	movq	%rsp, %rbp
    2884: 41 56                        	pushq	%r14
    2886: 53                           	pushq	%rbx
    2887: 48 81 ec 50 01 00 00         	subq	$0x150, %rsp            # imm = 0x150
    288e: 48 89 f3                     	movq	%rsi, %rbx
    2891: 49 89 f8                     	movq	%rdi, %r8
    2894: 66 c7 85 a0 fe ff ff 00 20   	movw	$0x2000, -0x160(%rbp)   # imm = 0x2000
    289d: c6 85 a2 fe ff ff 0d         	movb	$0xd, -0x15e(%rbp)
    28a4: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    28ae: 48 89 85 a3 fe ff ff         	movq	%rax, -0x15d(%rbp)
    28b5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    28bf: 48 89 85 a8 fe ff ff         	movq	%rax, -0x158(%rbp)
    28c6: c6 85 b0 fe ff ff 20         	movb	$0x20, -0x150(%rbp)
    28cd: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x54>
		00000000000028d0:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
    28d4: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    28db: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x62>
		00000000000028de:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
    28e2: 0f 11 85 c1 fe ff ff         	movups	%xmm0, -0x13f(%rbp)
    28e9: 4c 8d 75 d0                  	leaq	-0x30(%rbp), %r14
    28ed: 48 8d 95 a0 fe ff ff         	leaq	-0x160(%rbp), %rdx
    28f4: be 20 00 00 00               	movl	$0x20, %esi
    28f9: b9 31 00 00 00               	movl	$0x31, %ecx
    28fe: 4c 89 f7                     	movq	%r14, %rdi
    2901: e8 aa da ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    2906: 48 8d 7d b0                  	leaq	-0x50(%rbp), %rdi
    290a: ba 00 00 00 00               	movl	$0x0, %edx
		000000000000290b:  R_X86_64_32	.rodata.cst32
    290f: 4c 89 f6                     	movq	%r14, %rsi
    2912: e8 b9 d7 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    2917: 0f 57 c0                     	xorps	%xmm0, %xmm0
    291a: 0f 29 45 e0                  	movaps	%xmm0, -0x20(%rbp)
    291e: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    2922: 0f 10 45 b0                  	movups	-0x50(%rbp), %xmm0
    2926: 0f 10 4d c0                  	movups	-0x40(%rbp), %xmm1
    292a: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    292e: 0f 11 03                     	movups	%xmm0, (%rbx)
    2931: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            # imm = 0x150
    2938: 5b                           	popq	%rbx
    2939: 41 5e                        	popq	%r14
    293b: 5d                           	popq	%rbp
    293c: c3                           	retq
    293d: 0f 1f 00                     	nopl	(%rax)

0000000000002940 <audit_key256>:
    2940: 55                           	pushq	%rbp
    2941: 48 89 e5                     	movq	%rsp, %rbp
    2944: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            # imm = 0x110
    294b: 48 89 f0                     	movq	%rsi, %rax
    294e: 49 89 f8                     	movq	%rdi, %r8
    2951: 66 c7 85 f4 fe ff ff 00 10   	movw	$0x1000, -0x10c(%rbp)   # imm = 0x1000
    295a: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    2961: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
    296b: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    2972: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    297b: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    2982: be 10 00 00 00               	movl	$0x10, %esi
    2987: b9 0d 00 00 00               	movl	$0xd, %ecx
    298c: 48 89 c7                     	movq	%rax, %rdi
    298f: e8 1c da ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    2994: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            # imm = 0x110
    299b: 5d                           	popq	%rbp
    299c: c3                           	retq
    299d: 0f 1f 00                     	nopl	(%rax)

00000000000029a0 <audit_handshake384>:
    29a0: 55                           	pushq	%rbp
    29a1: 48 89 e5                     	movq	%rsp, %rbp
    29a4: 41 57                        	pushq	%r15
    29a6: 41 56                        	pushq	%r14
    29a8: 53                           	pushq	%rbx
    29a9: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            # imm = 0x178
    29b0: 48 89 d3                     	movq	%rdx, %rbx
    29b3: 49 89 f6                     	movq	%rsi, %r14
    29b6: 49 89 f8                     	movq	%rdi, %r8
    29b9: 66 c7 85 70 fe ff ff 00 30   	movw	$0x3000, -0x190(%rbp)   # imm = 0x3000
    29c2: c6 85 72 fe ff ff 0d         	movb	$0xd, -0x18e(%rbp)
    29c9: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    29d3: 48 89 85 73 fe ff ff         	movq	%rax, -0x18d(%rbp)
    29da: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    29e4: 48 89 85 78 fe ff ff         	movq	%rax, -0x188(%rbp)
    29eb: c6 85 80 fe ff ff 30         	movb	$0x30, -0x180(%rbp)
    29f2: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x59>
		00000000000029f5:  R_X86_64_PC32	.rodata+0x6c
    29f9: 0f 11 85 81 fe ff ff         	movups	%xmm0, -0x17f(%rbp)
    2a00: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x67>
		0000000000002a03:  R_X86_64_PC32	.rodata+0x7c
    2a07: 0f 11 85 91 fe ff ff         	movups	%xmm0, -0x16f(%rbp)
    2a0e: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x75>
		0000000000002a11:  R_X86_64_PC32	.rodata+0x8c
    2a15: 0f 11 85 a1 fe ff ff         	movups	%xmm0, -0x15f(%rbp)
    2a1c: 4c 8d 7d b0                  	leaq	-0x50(%rbp), %r15
    2a20: 48 8d 95 70 fe ff ff         	leaq	-0x190(%rbp), %rdx
    2a27: be 30 00 00 00               	movl	$0x30, %esi
    2a2c: b9 41 00 00 00               	movl	$0x41, %ecx
    2a31: 4c 89 ff                     	movq	%r15, %rdi
    2a34: e8 47 03 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    2a39: 48 8d 7d 80                  	leaq	-0x80(%rbp), %rdi
    2a3d: 4c 89 fe                     	movq	%r15, %rsi
    2a40: 4c 89 f2                     	movq	%r14, %rdx
    2a43: e8 38 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    2a48: 0f 57 c0                     	xorps	%xmm0, %xmm0
    2a4b: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    2a4f: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    2a53: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    2a57: 0f 10 45 80                  	movups	-0x80(%rbp), %xmm0
    2a5b: 0f 10 4d 90                  	movups	-0x70(%rbp), %xmm1
    2a5f: 0f 10 55 a0                  	movups	-0x60(%rbp), %xmm2
    2a63: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    2a67: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    2a6b: 0f 11 03                     	movups	%xmm0, (%rbx)
    2a6e: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            # imm = 0x178
    2a75: 5b                           	popq	%rbx
    2a76: 41 5e                        	popq	%r14
    2a78: 41 5f                        	popq	%r15
    2a7a: 5d                           	popq	%rbp
    2a7b: c3                           	retq
    2a7c: 0f 1f 40 00                  	nopl	(%rax)

0000000000002a80 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2a80: 55                           	pushq	%rbp
    2a81: 48 89 e5                     	movq	%rsp, %rbp
    2a84: 41 57                        	pushq	%r15
    2a86: 41 56                        	pushq	%r14
    2a88: 41 55                        	pushq	%r13
    2a8a: 41 54                        	pushq	%r12
    2a8c: 53                           	pushq	%rbx
    2a8d: 48 81 ec a8 02 00 00         	subq	$0x2a8, %rsp            # imm = 0x2A8
    2a94: 49 89 d6                     	movq	%rdx, %r14
    2a97: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    2a9b: 0f 10 06                     	movups	(%rsi), %xmm0
    2a9e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    2aa2: 0f 10 56 20                  	movups	0x20(%rsi), %xmm2
    2aa6: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x2d>
		0000000000002aa9:  R_X86_64_PC32	.LCPI8_0-0x4
    2aad: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2ab0: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2ab3: 0f 28 e9                     	movaps	%xmm1, %xmm5
    2ab6: 0f 57 eb                     	xorps	%xmm3, %xmm5
    2ab9: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2ac0: 0f 29 ad 50 fe ff ff         	movaps	%xmm5, -0x1b0(%rbp)
    2ac7: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2aca: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2acd: 0f 29 a5 60 fe ff ff         	movaps	%xmm4, -0x1a0(%rbp)
    2ad4: 0f 29 9d 70 fe ff ff         	movaps	%xmm3, -0x190(%rbp)
    2adb: 0f 29 9d 80 fe ff ff         	movaps	%xmm3, -0x180(%rbp)
    2ae2: 0f 29 9d 90 fe ff ff         	movaps	%xmm3, -0x170(%rbp)
    2ae9: 0f 29 9d a0 fe ff ff         	movaps	%xmm3, -0x160(%rbp)
    2af0: 0f 29 9d b0 fe ff ff         	movaps	%xmm3, -0x150(%rbp)
    2af7: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x7e>
		0000000000002afa:  R_X86_64_PC32	.LCPI8_1-0x4
    2afe: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2b01: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2b04: 0f 29 85 f0 fe ff ff         	movaps	%xmm0, -0x110(%rbp)
    2b0b: 0f 29 8d 00 ff ff ff         	movaps	%xmm1, -0x100(%rbp)
    2b12: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2b15: 0f 29 95 10 ff ff ff         	movaps	%xmm2, -0xf0(%rbp)
    2b1c: 0f 29 9d 20 ff ff ff         	movaps	%xmm3, -0xe0(%rbp)
    2b23: 0f 29 9d 30 ff ff ff         	movaps	%xmm3, -0xd0(%rbp)
    2b2a: 0f 29 9d 40 ff ff ff         	movaps	%xmm3, -0xc0(%rbp)
    2b31: 0f 29 9d 50 ff ff ff         	movaps	%xmm3, -0xb0(%rbp)
    2b38: 0f 29 9d 60 ff ff ff         	movaps	%xmm3, -0xa0(%rbp)
    2b3f: 4c 8d a5 60 fd ff ff         	leaq	-0x2a0(%rbp), %r12
    2b46: be 00 00 00 00               	movl	$0x0, %esi
		0000000000002b47:  R_X86_64_32	.rodata+0xb0
    2b4b: ba e0 00 00 00               	movl	$0xe0, %edx
    2b50: 4c 89 e7                     	movq	%r12, %rdi
    2b53: e8 00 00 00 00               	callq	 <L0>
		0000000000002b54:  R_X86_64_PLT32	memcpy-0x4
<L0>:
    2b58: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
    2b5f: 4c 89 e7                     	movq	%r12, %rdi
    2b62: e8 a9 0d 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2b67: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2b6e: bb 80 00 00 00               	movl	$0x80, %ebx
    2b73: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2b7a: 49 01 df                     	addq	%rbx, %r15
    2b7d: 49 83 d4 00                  	adcq	$0x0, %r12
    2b81: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2b88: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2b8f: 0f b6 85 30 fe ff ff         	movzbl	-0x1d0(%rbp), %eax
    2b96: 48 85 c0                     	testq	%rax, %rax
    2b99: 74 52                        	je	 <L2>
    2b9b: 3c 50                        	cmpb	$0x50, %al
    2b9d: 72 50                        	jb	 <L3>
    2b9f: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    2ba5: 49 29 c5                     	subq	%rax, %r13
    2ba8: 4c 8d a5 b0 fd ff ff         	leaq	-0x250(%rbp), %r12
    2baf: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    2bb3: 48 81 c7 b0 fd ff ff         	addq	$-0x250, %rdi           # imm = 0xFDB0
    2bba: 4c 89 f6                     	movq	%r14, %rsi
    2bbd: 4c 89 ea                     	movq	%r13, %rdx
    2bc0: e8 00 00 00 00               	callq	 <L1>
		0000000000002bc1:  R_X86_64_PLT32	memcpy-0x4
<L1>:
    2bc5: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2bcc: 4c 89 e6                     	movq	%r12, %rsi
    2bcf: e8 3c 0d 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2bd4: c6 85 30 fe ff ff 00         	movb	$0x0, -0x1d0(%rbp)
    2bdb: 31 c0                        	xorl	%eax, %eax
    2bdd: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2be4: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2beb: eb 05                        	jmp	 <L4>
<L2>:
    2bed: 31 c0                        	xorl	%eax, %eax
<L3>:
    2bef: 45 31 ed                     	xorl	%r13d, %r13d
<L4>:
    2bf2: 4d 01 ee                     	addq	%r13, %r14
    2bf5: 4c 89 f6                     	movq	%r14, %rsi
    2bf8: 41 be 30 00 00 00            	movl	$0x30, %r14d
    2bfe: 4d 29 ee                     	subq	%r13, %r14
    2c01: 0f b6 c0                     	movzbl	%al, %eax
    2c04: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    2c08: 48 81 c7 b0 fd ff ff         	addq	$-0x250, %rdi           # imm = 0xFDB0
    2c0f: 4c 89 f2                     	movq	%r14, %rdx
    2c12: e8 00 00 00 00               	callq	 <L5>
		0000000000002c13:  R_X86_64_PLT32	memcpy-0x4
<L5>:
    2c17: 44 00 b5 30 fe ff ff         	addb	%r14b, -0x1d0(%rbp)
    2c1e: 49 83 c7 30                  	addq	$0x30, %r15
    2c22: 49 83 d4 00                  	adcq	$0x0, %r12
    2c26: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2c2d: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2c34: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2c3b: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2c42: e8 a9 0a 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2c47: 4c 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %r14
    2c4e: be 00 00 00 00               	movl	$0x0, %esi
		0000000000002c4f:  R_X86_64_32	.rodata+0xb0
    2c53: ba e0 00 00 00               	movl	$0xe0, %edx
    2c58: 4c 89 f7                     	movq	%r14, %rdi
    2c5b: e8 00 00 00 00               	callq	 <L6>
		0000000000002c5c:  R_X86_64_PLT32	memcpy-0x4
<L6>:
    2c60: 4c 89 f7                     	movq	%r14, %rdi
    2c63: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    2c6a: e8 a1 0c 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2c6f: 0f b6 7d c0                  	movzbl	-0x40(%rbp), %edi
    2c73: 4c 8b a5 f8 fe ff ff         	movq	-0x108(%rbp), %r12
    2c7a: 48 03 9d f0 fe ff ff         	addq	-0x110(%rbp), %rbx
    2c81: 49 83 d4 00                  	adcq	$0x0, %r12
    2c85: 4c 8d b5 40 ff ff ff         	leaq	-0xc0(%rbp), %r14
    2c8c: 48 89 9d f0 fe ff ff         	movq	%rbx, -0x110(%rbp)
    2c93: 4c 89 a5 f8 fe ff ff         	movq	%r12, -0x108(%rbp)
    2c9a: 48 85 ff                     	testq	%rdi, %rdi
    2c9d: 74 46                        	je	 <L8>
    2c9f: 40 80 ff 50                  	cmpb	$0x50, %dil
    2ca3: 72 42                        	jb	 <L9>
    2ca5: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    2cab: 49 29 ff                     	subq	%rdi, %r15
    2cae: 4c 01 f7                     	addq	%r14, %rdi
    2cb1: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2cb8: 4c 89 fa                     	movq	%r15, %rdx
    2cbb: e8 00 00 00 00               	callq	 <L7>
		0000000000002cbc:  R_X86_64_PLT32	memcpy-0x4
<L7>:
    2cc0: 48 8d bd f0 fe ff ff         	leaq	-0x110(%rbp), %rdi
    2cc7: 4c 89 f6                     	movq	%r14, %rsi
    2cca: e8 41 0c 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2ccf: c6 45 c0 00                  	movb	$0x0, -0x40(%rbp)
    2cd3: 31 ff                        	xorl	%edi, %edi
    2cd5: 48 8b 9d f0 fe ff ff         	movq	-0x110(%rbp), %rbx
    2cdc: 4c 8b a5 f8 fe ff ff         	movq	-0x108(%rbp), %r12
    2ce3: eb 05                        	jmp	 <L10>
<L8>:
    2ce5: 31 ff                        	xorl	%edi, %edi
<L9>:
    2ce7: 45 31 ff                     	xorl	%r15d, %r15d
<L10>:
    2cea: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    2cee: 48 81 c6 30 fd ff ff         	addq	$-0x2d0, %rsi           # imm = 0xFD30
    2cf5: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    2cfb: 4d 29 fd                     	subq	%r15, %r13
    2cfe: 40 0f b6 c7                  	movzbl	%dil, %eax
    2d02: 49 01 c6                     	addq	%rax, %r14
    2d05: 4c 89 f7                     	movq	%r14, %rdi
    2d08: 4c 89 ea                     	movq	%r13, %rdx
    2d0b: e8 00 00 00 00               	callq	 <L11>
		0000000000002d0c:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    2d10: 44 00 6d c0                  	addb	%r13b, -0x40(%rbp)
    2d14: 48 83 c3 30                  	addq	$0x30, %rbx
    2d18: 49 83 d4 00                  	adcq	$0x0, %r12
    2d1c: 4c 89 a5 f8 fe ff ff         	movq	%r12, -0x108(%rbp)
    2d23: 48 89 9d f0 fe ff ff         	movq	%rbx, -0x110(%rbp)
    2d2a: 48 8d bd f0 fe ff ff         	leaq	-0x110(%rbp), %rdi
    2d31: 48 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %rsi
    2d38: e8 b3 09 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2d3d: 0f 10 85 c0 fe ff ff         	movups	-0x140(%rbp), %xmm0
    2d44: 0f 10 8d d0 fe ff ff         	movups	-0x130(%rbp), %xmm1
    2d4b: 0f 10 95 e0 fe ff ff         	movups	-0x120(%rbp), %xmm2
    2d52: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    2d56: 0f 11 50 20                  	movups	%xmm2, 0x20(%rax)
    2d5a: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
    2d5e: 0f 11 00                     	movups	%xmm0, (%rax)
    2d61: 48 81 c4 a8 02 00 00         	addq	$0x2a8, %rsp            # imm = 0x2A8
    2d68: 5b                           	popq	%rbx
    2d69: 41 5c                        	popq	%r12
    2d6b: 41 5d                        	popq	%r13
    2d6d: 41 5e                        	popq	%r14
    2d6f: 41 5f                        	popq	%r15
    2d71: 5d                           	popq	%rbp
    2d72: c3                           	retq
    2d73: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2d7d: 0f 1f 00                     	nopl	(%rax)

0000000000002d80 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
    2d80: 55                           	pushq	%rbp
    2d81: 48 89 e5                     	movq	%rsp, %rbp
    2d84: 41 57                        	pushq	%r15
    2d86: 41 56                        	pushq	%r14
    2d88: 41 55                        	pushq	%r13
    2d8a: 41 54                        	pushq	%r12
    2d8c: 53                           	pushq	%rbx
    2d8d: 48 81 ec a8 05 00 00         	subq	$0x5a8, %rsp            # imm = 0x5A8
    2d94: 48 89 55 c0                  	movq	%rdx, -0x40(%rbp)
    2d98: 49 89 f7                     	movq	%rsi, %r15
    2d9b: 48 89 7d c8                  	movq	%rdi, -0x38(%rbp)
    2d9f: 41 0f 10 08                  	movups	(%r8), %xmm1
    2da3: 41 0f 10 50 10               	movups	0x10(%r8), %xmm2
    2da8: 41 0f 10 40 20               	movups	0x20(%r8), %xmm0
    2dad: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    2db1: 48 83 fe 30                  	cmpq	$0x30, %rsi
    2db5: 48 89 4d b0                  	movq	%rcx, -0x50(%rbp)
    2db9: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    2dc0: 0f 29 8d 10 fe ff ff         	movaps	%xmm1, -0x1f0(%rbp)
    2dc7: 0f 29 95 20 fe ff ff         	movaps	%xmm2, -0x1e0(%rbp)
    2dce: 0f 83 7c 01 00 00            	jae	 <L4>
    2dd4: 48 c7 45 b8 00 00 00 00      	movq	$0x0, -0x48(%rbp)
<L0>:
    2ddc: 4c 89 f8                     	movq	%r15, %rax
    2ddf: 48 83 e8 30                  	subq	$0x30, %rax
    2de3: 49 0f 42 c7                  	cmovbq	%r15, %rax
    2de7: 48 85 c0                     	testq	%rax, %rax
    2dea: 0f 84 ec 08 00 00            	je	 <L52>
    2df0: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    2df4: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x7b>
		0000000000002df7:  R_X86_64_PC32	.LCPI9_0-0x4
    2dfb: 0f 28 9d 10 fe ff ff         	movaps	-0x1f0(%rbp), %xmm3
    2e02: 0f 28 cb                     	movaps	%xmm3, %xmm1
    2e05: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2e08: 0f 28 a5 20 fe ff ff         	movaps	-0x1e0(%rbp), %xmm4
    2e0f: 0f 28 d4                     	movaps	%xmm4, %xmm2
    2e12: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2e15: 0f 29 8d 20 fd ff ff         	movaps	%xmm1, -0x2e0(%rbp)
    2e1c: 0f 29 95 30 fd ff ff         	movaps	%xmm2, -0x2d0(%rbp)
    2e23: 0f 28 95 00 fe ff ff         	movaps	-0x200(%rbp), %xmm2
    2e2a: 0f 28 ca                     	movaps	%xmm2, %xmm1
    2e2d: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2e30: 0f 29 8d 40 fd ff ff         	movaps	%xmm1, -0x2c0(%rbp)
    2e37: 0f 29 85 50 fd ff ff         	movaps	%xmm0, -0x2b0(%rbp)
    2e3e: 0f 29 85 60 fd ff ff         	movaps	%xmm0, -0x2a0(%rbp)
    2e45: 0f 29 85 70 fd ff ff         	movaps	%xmm0, -0x290(%rbp)
    2e4c: 0f 29 85 80 fd ff ff         	movaps	%xmm0, -0x280(%rbp)
    2e53: 0f 29 85 90 fd ff ff         	movaps	%xmm0, -0x270(%rbp)
    2e5a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0xe1>
		0000000000002e5d:  R_X86_64_PC32	.LCPI9_1-0x4
    2e61: 0f 57 d8                     	xorps	%xmm0, %xmm3
    2e64: 0f 57 e0                     	xorps	%xmm0, %xmm4
    2e67: 0f 29 9d 30 fe ff ff         	movaps	%xmm3, -0x1d0(%rbp)
    2e6e: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2e75: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2e78: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
    2e7f: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    2e86: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    2e8d: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    2e94: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    2e9b: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    2ea2: 48 8d 9d 40 fc ff ff         	leaq	-0x3c0(%rbp), %rbx
    2ea9: be 00 00 00 00               	movl	$0x0, %esi
		0000000000002eaa:  R_X86_64_32	.rodata+0xb0
    2eae: ba e0 00 00 00               	movl	$0xe0, %edx
    2eb3: 48 89 df                     	movq	%rbx, %rdi
    2eb6: e8 00 00 00 00               	callq	 <L1>
		0000000000002eb7:  R_X86_64_PLT32	memcpy-0x4
<L1>:
    2ebb: 48 8d b5 30 fe ff ff         	leaq	-0x1d0(%rbp), %rsi
    2ec2: 48 89 df                     	movq	%rbx, %rdi
    2ec5: e8 46 0a 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2eca: 48 81 85 40 fc ff ff 80 00 00 00     	addq	$0x80, -0x3c0(%rbp)
    2ed5: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    2edd: 0f b6 85 10 fd ff ff         	movzbl	-0x2f0(%rbp), %eax
    2ee4: 49 83 ff 2f                  	cmpq	$0x2f, %r15
    2ee8: 0f 87 25 05 00 00            	ja	 <L30>
    2eee: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
    2ef2: 84 c0                        	testb	%al, %al
    2ef4: 0f 84 bc 05 00 00            	je	 <L36>
<L2>:
    2efa: 0f b6 c8                     	movzbl	%al, %ecx
    2efd: 49 8d 14 0f                  	leaq	(%r15,%rcx), %rdx
    2f01: 48 81 fa 80 00 00 00         	cmpq	$0x80, %rdx
    2f08: 0f 82 aa 05 00 00            	jb	 <L37>
    2f0e: b2 80                        	movb	$-0x80, %dl
    2f10: 28 c2                        	subb	%al, %dl
    2f12: 0f b6 da                     	movzbl	%dl, %ebx
    2f15: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    2f1c: 48 8d 3c 29                  	leaq	(%rcx,%rbp), %rdi
    2f20: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    2f27: 48 8b 75 c0                  	movq	-0x40(%rbp), %rsi
    2f2b: 48 89 da                     	movq	%rbx, %rdx
    2f2e: e8 00 00 00 00               	callq	 <L3>
		0000000000002f2f:  R_X86_64_PLT32	memcpy-0x4
<L3>:
    2f33: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    2f3a: 4c 89 f6                     	movq	%r14, %rsi
    2f3d: e8 ce 09 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2f42: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    2f49: 31 c0                        	xorl	%eax, %eax
    2f4b: e9 6a 05 00 00               	jmp	 <L38>
<L4>:
    2f50: 48 83 f1 7f                  	xorq	$0x7f, %rcx
    2f54: 48 89 4d a0                  	movq	%rcx, -0x60(%rbp)
    2f58: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x1df>
		0000000000002f5b:  R_X86_64_PC32	.LCPI9_0-0x4
    2f5f: 0f 28 e1                     	movaps	%xmm1, %xmm4
    2f62: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f65: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
    2f6c: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2f6f: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f72: 0f 29 a5 b0 fd ff ff         	movaps	%xmm4, -0x250(%rbp)
    2f79: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2f7c: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f7f: 0f 29 a5 c0 fd ff ff         	movaps	%xmm4, -0x240(%rbp)
    2f86: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x20d>
		0000000000002f89:  R_X86_64_PC32	.LCPI9_1-0x4
    2f8d: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2f90: 0f 29 8d d0 fd ff ff         	movaps	%xmm1, -0x230(%rbp)
    2f97: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2f9a: 0f 29 95 e0 fd ff ff         	movaps	%xmm2, -0x220(%rbp)
    2fa1: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2fa4: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    2fab: 41 b6 01                     	movb	$0x1, %r14b
    2fae: b0 02                        	movb	$0x2, %al
    2fb0: 31 c9                        	xorl	%ecx, %ecx
    2fb2: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    2fb9: 4c 89 7d 98                  	movq	%r15, -0x68(%rbp)
    2fbd: e9 9d 00 00 00               	jmp	 <L9>
    2fc2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2fcc: 0f 1f 40 00                  	nopl	(%rax)
<L5>:
    2fd0: 31 ff                        	xorl	%edi, %edi
<L6>:
    2fd2: 45 31 f6                     	xorl	%r14d, %r14d
<L7>:
    2fd5: 4c 8b 7d b8                  	movq	-0x48(%rbp), %r15
    2fd9: 4c 03 7d c8                  	addq	-0x38(%rbp), %r15
    2fdd: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    2fe1: 48 81 c6 c0 fb ff ff         	addq	$-0x440, %rsi           # imm = 0xFBC0
    2fe8: b8 30 00 00 00               	movl	$0x30, %eax
    2fed: 48 89 45 b8                  	movq	%rax, -0x48(%rbp)
    2ff1: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    2ff7: 4d 29 f4                     	subq	%r14, %r12
    2ffa: 40 0f b6 ff                  	movzbl	%dil, %edi
    2ffe: 48 8d 85 80 fe ff ff         	leaq	-0x180(%rbp), %rax
    3005: 48 01 c7                     	addq	%rax, %rdi
    3008: 4c 89 e2                     	movq	%r12, %rdx
    300b: e8 00 00 00 00               	callq	 <L8>
		000000000000300c:  R_X86_64_PLT32	memcpy-0x4
<L8>:
    3010: 44 00 a5 00 ff ff ff         	addb	%r12b, -0x100(%rbp)
    3017: 48 83 c3 30                  	addq	$0x30, %rbx
    301b: 49 83 d5 00                  	adcq	$0x0, %r13
    301f: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    3026: 48 89 9d 30 fe ff ff         	movq	%rbx, -0x1d0(%rbp)
    302d: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    3034: 48 89 df                     	movq	%rbx, %rdi
    3037: 4c 89 fe                     	movq	%r15, %rsi
    303a: e8 b1 06 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    303f: 48 8b 45 a8                  	movq	-0x58(%rbp), %rax
    3043: 88 45 d7                     	movb	%al, -0x29(%rbp)
    3046: 83 c0 01                     	addl	$0x1, %eax
    3049: 45 31 f6                     	xorl	%r14d, %r14d
    304c: b9 30 00 00 00               	movl	$0x30, %ecx
    3051: 4c 8b 7d 98                  	movq	-0x68(%rbp), %r15
    3055: 49 83 ff 60                  	cmpq	$0x60, %r15
    3059: 0f 82 7d fd ff ff            	jb	 <L0>
<L9>:
    305f: 48 89 4d b8                  	movq	%rcx, -0x48(%rbp)
    3063: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    3067: 0f 28 85 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm0
    306e: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
    3075: 0f 28 85 b0 fd ff ff         	movaps	-0x250(%rbp), %xmm0
    307c: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3083: 0f 28 85 c0 fd ff ff         	movaps	-0x240(%rbp), %xmm0
    308a: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3091: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x318>
		0000000000003094:  R_X86_64_PC32	.LCPI9_0-0x4
    3098: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    309f: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    30a6: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    30ad: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    30b4: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    30b8: 0f 28 85 d0 fd ff ff         	movaps	-0x230(%rbp), %xmm0
    30bf: 0f 29 85 c0 fb ff ff         	movaps	%xmm0, -0x440(%rbp)
    30c6: 0f 28 85 e0 fd ff ff         	movaps	-0x220(%rbp), %xmm0
    30cd: 0f 29 85 d0 fb ff ff         	movaps	%xmm0, -0x430(%rbp)
    30d4: 0f 28 85 f0 fd ff ff         	movaps	-0x210(%rbp), %xmm0
    30db: 0f 29 85 e0 fb ff ff         	movaps	%xmm0, -0x420(%rbp)
    30e2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x369>
		00000000000030e5:  R_X86_64_PC32	.LCPI9_1-0x4
    30e9: 0f 29 85 f0 fb ff ff         	movaps	%xmm0, -0x410(%rbp)
    30f0: 0f 29 85 00 fc ff ff         	movaps	%xmm0, -0x400(%rbp)
    30f7: 0f 29 85 10 fc ff ff         	movaps	%xmm0, -0x3f0(%rbp)
    30fe: 0f 29 85 20 fc ff ff         	movaps	%xmm0, -0x3e0(%rbp)
    3105: 0f 29 85 30 fc ff ff         	movaps	%xmm0, -0x3d0(%rbp)
    310c: be 00 00 00 00               	movl	$0x0, %esi
		000000000000310d:  R_X86_64_32	.rodata+0xb0
    3111: ba e0 00 00 00               	movl	$0xe0, %edx
    3116: 48 89 df                     	movq	%rbx, %rdi
    3119: e8 00 00 00 00               	callq	 <L10>
		000000000000311a:  R_X86_64_PLT32	memcpy-0x4
<L10>:
    311e: 48 89 df                     	movq	%rbx, %rdi
    3121: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    3128: e8 e3 07 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    312d: 48 81 85 30 fe ff ff 80 00 00 00     	addq	$0x80, -0x1d0(%rbp)
    3138: 48 83 95 38 fe ff ff 00      	adcq	$0x0, -0x1c8(%rbp)
    3140: ba 60 01 00 00               	movl	$0x160, %edx            # imm = 0x160
    3145: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    314c: 48 89 de                     	movq	%rbx, %rsi
    314f: e8 00 00 00 00               	callq	 <L11>
		0000000000003150:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    3154: 0f b6 85 30 fb ff ff         	movzbl	-0x4d0(%rbp), %eax
    315b: 41 f6 c6 01                  	testb	$0x1, %r14b
    315f: 0f 85 90 00 00 00            	jne	 <L17>
    3165: 84 c0                        	testb	%al, %al
    3167: 74 40                        	je	 <L13>
    3169: 3c 50                        	cmpb	$0x50, %al
    316b: 72 3e                        	jb	 <L14>
    316d: 0f b6 f8                     	movzbl	%al, %edi
    3170: 41 be 80 00 00 00            	movl	$0x80, %r14d
    3176: 49 29 fe                     	subq	%rdi, %r14
    3179: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    3180: 48 01 df                     	addq	%rbx, %rdi
    3183: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    3187: 4c 89 f2                     	movq	%r14, %rdx
    318a: e8 00 00 00 00               	callq	 <L12>
		000000000000318b:  R_X86_64_PLT32	memcpy-0x4
<L12>:
    318f: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3196: 48 89 de                     	movq	%rbx, %rsi
    3199: e8 72 07 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    319e: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    31a5: 31 c0                        	xorl	%eax, %eax
    31a7: eb 05                        	jmp	 <L15>
<L13>:
    31a9: 31 c0                        	xorl	%eax, %eax
<L14>:
    31ab: 45 31 f6                     	xorl	%r14d, %r14d
<L15>:
    31ae: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    31b2: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    31b6: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    31bc: 4d 29 f4                     	subq	%r14, %r12
    31bf: 0f b6 f8                     	movzbl	%al, %edi
    31c2: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    31c9: 48 01 c7                     	addq	%rax, %rdi
    31cc: 4c 89 e2                     	movq	%r12, %rdx
    31cf: e8 00 00 00 00               	callq	 <L16>
		00000000000031d0:  R_X86_64_PLT32	memcpy-0x4
<L16>:
    31d4: 44 02 a5 30 fb ff ff         	addb	-0x4d0(%rbp), %r12b
    31db: 44 88 a5 30 fb ff ff         	movb	%r12b, -0x4d0(%rbp)
    31e2: 48 83 85 60 fa ff ff 30      	addq	$0x30, -0x5a0(%rbp)
    31ea: 48 83 95 68 fa ff ff 00      	adcq	$0x0, -0x598(%rbp)
    31f2: 44 89 e0                     	movl	%r12d, %eax
<L17>:
    31f5: 84 c0                        	testb	%al, %al
    31f7: 74 47                        	je	 <L19>
    31f9: 0f b6 f8                     	movzbl	%al, %edi
    31fc: 48 39 7d a0                  	cmpq	%rdi, -0x60(%rbp)
    3200: 73 40                        	jae	 <L20>
    3202: b1 80                        	movb	$-0x80, %cl
    3204: 28 c1                        	subb	%al, %cl
    3206: 44 0f b6 f1                  	movzbl	%cl, %r14d
    320a: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    3211: 48 01 df                     	addq	%rbx, %rdi
    3214: 48 8b 75 c0                  	movq	-0x40(%rbp), %rsi
    3218: 4c 89 f2                     	movq	%r14, %rdx
    321b: e8 00 00 00 00               	callq	 <L18>
		000000000000321c:  R_X86_64_PLT32	memcpy-0x4
<L18>:
    3220: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3227: 48 89 de                     	movq	%rbx, %rsi
    322a: e8 e1 06 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    322f: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3236: 31 c0                        	xorl	%eax, %eax
    3238: eb 0b                        	jmp	 <L21>
    323a: 66 0f 1f 44 00 00            	nopw	(%rax,%rax)
<L19>:
    3240: 31 c0                        	xorl	%eax, %eax
<L20>:
    3242: 45 31 f6                     	xorl	%r14d, %r14d
<L21>:
    3245: 48 8b 4d c0                  	movq	-0x40(%rbp), %rcx
    3249: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    324d: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
    3251: 4d 89 fc                     	movq	%r15, %r12
    3254: 4d 29 f4                     	subq	%r14, %r12
    3257: 0f b6 f8                     	movzbl	%al, %edi
    325a: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3261: 48 01 c7                     	addq	%rax, %rdi
    3264: 4c 89 e2                     	movq	%r12, %rdx
    3267: e8 00 00 00 00               	callq	 <L22>
		0000000000003268:  R_X86_64_PLT32	memcpy-0x4
<L22>:
    326c: 0f b6 bd 30 fb ff ff         	movzbl	-0x4d0(%rbp), %edi
    3273: 4c 01 e7                     	addq	%r12, %rdi
    3276: 40 88 bd 30 fb ff ff         	movb	%dil, -0x4d0(%rbp)
    327d: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    3284: 48 8b 9d 60 fa ff ff         	movq	-0x5a0(%rbp), %rbx
    328b: 4c 01 fb                     	addq	%r15, %rbx
    328e: 49 83 d5 00                  	adcq	$0x0, %r13
    3292: 48 89 9d 60 fa ff ff         	movq	%rbx, -0x5a0(%rbp)
    3299: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    32a0: 40 84 ff                     	testb	%dil, %dil
    32a3: 74 5b                        	je	 <L24>
    32a5: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    32a9: 72 57                        	jb	 <L25>
    32ab: b0 80                        	movb	$-0x80, %al
    32ad: 40 28 f8                     	subb	%dil, %al
    32b0: 44 0f b6 f0                  	movzbl	%al, %r14d
    32b4: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    32bb: 48 01 df                     	addq	%rbx, %rdi
    32be: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    32c2: 4c 89 f2                     	movq	%r14, %rdx
    32c5: e8 00 00 00 00               	callq	 <L23>
		00000000000032c6:  R_X86_64_PLT32	memcpy-0x4
<L23>:
    32ca: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    32d1: 48 89 de                     	movq	%rbx, %rsi
    32d4: e8 37 06 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    32d9: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    32e0: 31 ff                        	xorl	%edi, %edi
    32e2: 48 8b 9d 60 fa ff ff         	movq	-0x5a0(%rbp), %rbx
    32e9: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    32f0: eb 13                        	jmp	 <L26>
    32f2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    32fc: 0f 1f 40 00                  	nopl	(%rax)
<L24>:
    3300: 31 ff                        	xorl	%edi, %edi
<L25>:
    3302: 45 31 f6                     	xorl	%r14d, %r14d
<L26>:
    3305: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    3309: 48 83 c6 d7                  	addq	$-0x29, %rsi
    330d: 41 bc 01 00 00 00            	movl	$0x1, %r12d
    3313: 4d 29 f4                     	subq	%r14, %r12
    3316: 40 0f b6 ff                  	movzbl	%dil, %edi
    331a: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3321: 48 01 c7                     	addq	%rax, %rdi
    3324: 4c 89 e2                     	movq	%r12, %rdx
    3327: e8 00 00 00 00               	callq	 <L27>
		0000000000003328:  R_X86_64_PLT32	memcpy-0x4
<L27>:
    332c: 44 00 a5 30 fb ff ff         	addb	%r12b, -0x4d0(%rbp)
    3333: 48 83 c3 01                  	addq	$0x1, %rbx
    3337: 49 83 d5 00                  	adcq	$0x0, %r13
    333b: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    3342: 48 89 9d 60 fa ff ff         	movq	%rbx, -0x5a0(%rbp)
    3349: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3350: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    3357: e8 94 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    335c: be 00 00 00 00               	movl	$0x0, %esi
		000000000000335d:  R_X86_64_32	.rodata+0xb0
    3361: ba e0 00 00 00               	movl	$0xe0, %edx
    3366: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    336d: 48 89 df                     	movq	%rbx, %rdi
    3370: e8 00 00 00 00               	callq	 <L28>
		0000000000003371:  R_X86_64_PLT32	memcpy-0x4
<L28>:
    3375: 48 89 df                     	movq	%rbx, %rdi
    3378: 48 8d b5 40 fb ff ff         	leaq	-0x4c0(%rbp), %rsi
    337f: e8 8c 05 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3384: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    338b: 48 8b 9d 30 fe ff ff         	movq	-0x1d0(%rbp), %rbx
    3392: b8 80 00 00 00               	movl	$0x80, %eax
    3397: 48 01 c3                     	addq	%rax, %rbx
    339a: 49 83 d5 00                  	adcq	$0x0, %r13
    339e: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    33a5: 48 89 9d 30 fe ff ff         	movq	%rbx, -0x1d0(%rbp)
    33ac: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    33b3: 48 85 ff                     	testq	%rdi, %rdi
    33b6: 0f 84 14 fc ff ff            	je	 <L5>
    33bc: 40 80 ff 50                  	cmpb	$0x50, %dil
    33c0: 0f 82 0c fc ff ff            	jb	 <L6>
    33c6: 41 be 80 00 00 00            	movl	$0x80, %r14d
    33cc: 49 29 fe                     	subq	%rdi, %r14
    33cf: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    33d6: 48 01 df                     	addq	%rbx, %rdi
    33d9: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    33e0: 4c 89 f2                     	movq	%r14, %rdx
    33e3: e8 00 00 00 00               	callq	 <L29>
		00000000000033e4:  R_X86_64_PLT32	memcpy-0x4
<L29>:
    33e8: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    33ef: 48 89 de                     	movq	%rbx, %rsi
    33f2: e8 19 05 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    33f7: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    33fe: 31 ff                        	xorl	%edi, %edi
    3400: 48 8b 9d 30 fe ff ff         	movq	-0x1d0(%rbp), %rbx
    3407: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    340e: e9 c2 fb ff ff               	jmp	 <L7>
<L30>:
    3413: 84 c0                        	testb	%al, %al
    3415: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
    3419: 74 47                        	je	 <L32>
    341b: 3c 50                        	cmpb	$0x50, %al
    341d: 72 45                        	jb	 <L33>
    341f: 0f b6 c0                     	movzbl	%al, %eax
    3422: bb 80 00 00 00               	movl	$0x80, %ebx
    3427: 48 29 c3                     	subq	%rax, %rbx
    342a: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    3431: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3435: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    343c: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    3440: 48 89 da                     	movq	%rbx, %rdx
    3443: e8 00 00 00 00               	callq	 <L31>
		0000000000003444:  R_X86_64_PLT32	memcpy-0x4
<L31>:
    3448: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    344f: 4c 89 f6                     	movq	%r14, %rsi
    3452: e8 b9 04 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3457: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    345e: 31 c0                        	xorl	%eax, %eax
    3460: eb 04                        	jmp	 <L34>
<L32>:
    3462: 31 c0                        	xorl	%eax, %eax
<L33>:
    3464: 31 db                        	xorl	%ebx, %ebx
<L34>:
    3466: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    346a: 48 8d 34 19                  	leaq	(%rcx,%rbx), %rsi
    346e: 41 be 30 00 00 00            	movl	$0x30, %r14d
    3474: 49 29 de                     	subq	%rbx, %r14
    3477: 0f b6 c0                     	movzbl	%al, %eax
    347a: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    347e: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    3485: 4c 89 f2                     	movq	%r14, %rdx
    3488: e8 00 00 00 00               	callq	 <L35>
		0000000000003489:  R_X86_64_PLT32	memcpy-0x4
<L35>:
    348d: 44 02 b5 10 fd ff ff         	addb	-0x2f0(%rbp), %r14b
    3494: 44 88 b5 10 fd ff ff         	movb	%r14b, -0x2f0(%rbp)
    349b: 48 83 85 40 fc ff ff 30      	addq	$0x30, -0x3c0(%rbp)
    34a3: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    34ab: 44 89 f0                     	movl	%r14d, %eax
    34ae: 84 c0                        	testb	%al, %al
    34b0: 0f 85 44 fa ff ff            	jne	 <L2>
<L36>:
    34b6: 31 c0                        	xorl	%eax, %eax
<L37>:
    34b8: 31 db                        	xorl	%ebx, %ebx
<L38>:
    34ba: 48 8b 75 c0                  	movq	-0x40(%rbp), %rsi
    34be: 48 01 de                     	addq	%rbx, %rsi
    34c1: 4d 89 fe                     	movq	%r15, %r14
    34c4: 49 29 de                     	subq	%rbx, %r14
    34c7: 48 8d 9d 90 fc ff ff         	leaq	-0x370(%rbp), %rbx
    34ce: 0f b6 c0                     	movzbl	%al, %eax
    34d1: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    34d5: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    34dc: 4c 89 f2                     	movq	%r14, %rdx
    34df: e8 00 00 00 00               	callq	 <L39>
		00000000000034e0:  R_X86_64_PLT32	memcpy-0x4
<L39>:
    34e4: 0f b6 bd 10 fd ff ff         	movzbl	-0x2f0(%rbp), %edi
    34eb: 4c 01 f7                     	addq	%r14, %rdi
    34ee: 40 88 bd 10 fd ff ff         	movb	%dil, -0x2f0(%rbp)
    34f5: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    34fc: 4c 03 bd 40 fc ff ff         	addq	-0x3c0(%rbp), %r15
    3503: 49 83 d4 00                  	adcq	$0x0, %r12
    3507: 4c 89 bd 40 fc ff ff         	movq	%r15, -0x3c0(%rbp)
    350e: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    3515: 40 84 ff                     	testb	%dil, %dil
    3518: 74 46                        	je	 <L41>
    351a: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    351e: 72 47                        	jb	 <L42>
    3520: b0 80                        	movb	$-0x80, %al
    3522: 40 28 f8                     	subb	%dil, %al
    3525: 44 0f b6 f8                  	movzbl	%al, %r15d
    3529: 48 01 df                     	addq	%rbx, %rdi
    352c: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3530: 4c 89 fa                     	movq	%r15, %rdx
    3533: e8 00 00 00 00               	callq	 <L40>
		0000000000003534:  R_X86_64_PLT32	memcpy-0x4
<L40>:
    3538: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    353f: 48 89 de                     	movq	%rbx, %rsi
    3542: e8 c9 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3547: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    354e: 31 ff                        	xorl	%edi, %edi
    3550: 4c 8b ad 40 fc ff ff         	movq	-0x3c0(%rbp), %r13
    3557: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    355e: eb 0d                        	jmp	 <L44>
<L41>:
    3560: 4d 89 fd                     	movq	%r15, %r13
    3563: 31 ff                        	xorl	%edi, %edi
    3565: eb 03                        	jmp	 <L43>
<L42>:
    3567: 4d 89 fd                     	movq	%r15, %r13
<L43>:
    356a: 45 31 ff                     	xorl	%r15d, %r15d
<L44>:
    356d: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    3571: 48 83 c6 d7                  	addq	$-0x29, %rsi
    3575: 41 be 01 00 00 00            	movl	$0x1, %r14d
    357b: 4d 29 fe                     	subq	%r15, %r14
    357e: 40 0f b6 c7                  	movzbl	%dil, %eax
    3582: 48 01 c3                     	addq	%rax, %rbx
    3585: 48 89 df                     	movq	%rbx, %rdi
    3588: 4c 89 f2                     	movq	%r14, %rdx
    358b: e8 00 00 00 00               	callq	 <L45>
		000000000000358c:  R_X86_64_PLT32	memcpy-0x4
<L45>:
    3590: 44 00 b5 10 fd ff ff         	addb	%r14b, -0x2f0(%rbp)
    3597: 49 83 c5 01                  	addq	$0x1, %r13
    359b: 49 83 d4 00                  	adcq	$0x0, %r12
    359f: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    35a6: 4c 89 ad 40 fc ff ff         	movq	%r13, -0x3c0(%rbp)
    35ad: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    35b4: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    35bb: e8 30 01 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    35c0: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    35c7: be 00 00 00 00               	movl	$0x0, %esi
		00000000000035c8:  R_X86_64_32	.rodata+0xb0
    35cc: ba e0 00 00 00               	movl	$0xe0, %edx
    35d1: 48 89 df                     	movq	%rbx, %rdi
    35d4: e8 00 00 00 00               	callq	 <L46>
		00000000000035d5:  R_X86_64_PLT32	memcpy-0x4
<L46>:
    35d9: 48 8d b5 20 fd ff ff         	leaq	-0x2e0(%rbp), %rsi
    35e0: 48 89 df                     	movq	%rbx, %rdi
    35e3: e8 28 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    35e8: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    35ef: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    35f6: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    35fc: 4c 03 ad 30 fe ff ff         	addq	-0x1d0(%rbp), %r13
    3603: 49 83 d4 00                  	adcq	$0x0, %r12
    3607: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    360e: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    3615: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    361c: 48 85 ff                     	testq	%rdi, %rdi
    361f: 74 49                        	je	 <L48>
    3621: 40 80 ff 50                  	cmpb	$0x50, %dil
    3625: 72 45                        	jb	 <L49>
    3627: 41 be 80 00 00 00            	movl	$0x80, %r14d
    362d: 49 29 fe                     	subq	%rdi, %r14
    3630: 48 01 df                     	addq	%rbx, %rdi
    3633: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    363a: 4c 89 f2                     	movq	%r14, %rdx
    363d: e8 00 00 00 00               	callq	 <L47>
		000000000000363e:  R_X86_64_PLT32	memcpy-0x4
<L47>:
    3642: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    3649: 48 89 de                     	movq	%rbx, %rsi
    364c: e8 bf 02 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3651: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    3658: 31 ff                        	xorl	%edi, %edi
    365a: 4c 8b ad 30 fe ff ff         	movq	-0x1d0(%rbp), %r13
    3661: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    3668: eb 05                        	jmp	 <L50>
<L48>:
    366a: 31 ff                        	xorl	%edi, %edi
<L49>:
    366c: 45 31 f6                     	xorl	%r14d, %r14d
<L50>:
    366f: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    3673: 48 81 c6 c0 fb ff ff         	addq	$-0x440, %rsi           # imm = 0xFBC0
    367a: 41 bf 30 00 00 00            	movl	$0x30, %r15d
    3680: 4d 29 f7                     	subq	%r14, %r15
    3683: 40 0f b6 c7                  	movzbl	%dil, %eax
    3687: 48 01 c3                     	addq	%rax, %rbx
    368a: 48 89 df                     	movq	%rbx, %rdi
    368d: 4c 89 fa                     	movq	%r15, %rdx
    3690: e8 00 00 00 00               	callq	 <L51>
		0000000000003691:  R_X86_64_PLT32	memcpy-0x4
<L51>:
    3695: 44 00 bd 00 ff ff ff         	addb	%r15b, -0x100(%rbp)
    369c: 49 83 c5 30                  	addq	$0x30, %r13
    36a0: 49 83 d4 00                  	adcq	$0x0, %r12
    36a4: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    36ab: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    36b2: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    36b9: 48 8d 9d 30 fa ff ff         	leaq	-0x5d0(%rbp), %rbx
    36c0: 48 89 de                     	movq	%rbx, %rsi
    36c3: e8 28 00 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    36c8: 48 8b 7d c8                  	movq	-0x38(%rbp), %rdi
    36cc: 48 03 7d b8                  	addq	-0x48(%rbp), %rdi
    36d0: 48 89 de                     	movq	%rbx, %rsi
    36d3: 48 8b 55 a8                  	movq	-0x58(%rbp), %rdx
    36d7: e8 00 00 00 00               	callq	 <L52>
		00000000000036d8:  R_X86_64_PLT32	memcpy-0x4
<L52>:
    36dc: 48 81 c4 a8 05 00 00         	addq	$0x5a8, %rsp            # imm = 0x5A8
    36e3: 5b                           	popq	%rbx
    36e4: 41 5c                        	popq	%r12
    36e6: 41 5d                        	popq	%r13
    36e8: 41 5e                        	popq	%r14
    36ea: 41 5f                        	popq	%r15
    36ec: 5d                           	popq	%rbp
    36ed: c3                           	retq
    36ee: 66 90                        	nop

00000000000036f0 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    36f0: 55                           	pushq	%rbp
    36f1: 48 89 e5                     	movq	%rsp, %rbp
    36f4: 41 57                        	pushq	%r15
    36f6: 41 56                        	pushq	%r14
    36f8: 53                           	pushq	%rbx
    36f9: 50                           	pushq	%rax
    36fa: 48 89 f3                     	movq	%rsi, %rbx
    36fd: 49 89 fe                     	movq	%rdi, %r14
    3700: 4c 8d 7f 50                  	leaq	0x50(%rdi), %r15
    3704: 0f b6 87 d0 00 00 00         	movzbl	0xd0(%rdi), %eax
    370b: 48 01 c7                     	addq	%rax, %rdi
    370e: 48 83 c7 50                  	addq	$0x50, %rdi
    3712: ba 80 00 00 00               	movl	$0x80, %edx
    3717: 48 29 c2                     	subq	%rax, %rdx
    371a: 31 f6                        	xorl	%esi, %esi
    371c: e8 00 00 00 00               	callq	 <L0>
		000000000000371d:  R_X86_64_PLT32	memset-0x4
<L0>:
    3721: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    3729: 41 c6 44 06 50 80            	movb	$-0x80, 0x50(%r14,%rax)
    372f: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    3737: 8d 48 01                     	leal	0x1(%rax), %ecx
    373a: 41 88 8e d0 00 00 00         	movb	%cl, 0xd0(%r14)
    3741: 3c 6f                        	cmpb	$0x6f, %al
    3743: 76 30                        	jbe	 <L1>
    3745: 4c 89 f7                     	movq	%r14, %rdi
    3748: 4c 89 fe                     	movq	%r15, %rsi
    374b: e8 c0 01 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3750: 0f 57 c0                     	xorps	%xmm0, %xmm0
    3753: 41 0f 29 47 60               	movaps	%xmm0, 0x60(%r15)
    3758: 41 0f 29 47 50               	movaps	%xmm0, 0x50(%r15)
    375d: 41 0f 29 47 40               	movaps	%xmm0, 0x40(%r15)
    3762: 41 0f 29 47 30               	movaps	%xmm0, 0x30(%r15)
    3767: 41 0f 29 47 20               	movaps	%xmm0, 0x20(%r15)
    376c: 41 0f 29 47 10               	movaps	%xmm0, 0x10(%r15)
    3771: 41 0f 29 07                  	movaps	%xmm0, (%r15)
<L1>:
    3775: 49 8b 06                     	movq	(%r14), %rax
    3778: 49 8b 4e 08                  	movq	0x8(%r14), %rcx
    377c: 89 c2                        	movl	%eax, %edx
    377e: c1 ea 05                     	shrl	$0x5, %edx
    3781: 8d 34 c5 00 00 00 00         	leal	(,%rax,8), %esi
    3788: 41 88 b6 cf 00 00 00         	movb	%sil, 0xcf(%r14)
    378f: 41 88 96 ce 00 00 00         	movb	%dl, 0xce(%r14)
    3796: 89 c2                        	movl	%eax, %edx
    3798: c1 ea 0d                     	shrl	$0xd, %edx
    379b: 41 88 96 cd 00 00 00         	movb	%dl, 0xcd(%r14)
    37a2: 89 c2                        	movl	%eax, %edx
    37a4: c1 ea 15                     	shrl	$0x15, %edx
    37a7: 48 89 ce                     	movq	%rcx, %rsi
    37aa: 48 0f a4 c6 1b               	shldq	$0x1b, %rax, %rsi
    37af: 41 88 96 cc 00 00 00         	movb	%dl, 0xcc(%r14)
    37b6: 49 89 c8                     	movq	%rcx, %r8
    37b9: 49 0f a4 c0 23               	shldq	$0x23, %rax, %r8
    37be: 48 89 ca                     	movq	%rcx, %rdx
    37c1: 49 89 c9                     	movq	%rcx, %r9
    37c4: 49 0f a4 c1 0b               	shldq	$0xb, %rax, %r9
    37c9: 48 89 cf                     	movq	%rcx, %rdi
    37cc: 49 89 ca                     	movq	%rcx, %r10
    37cf: 49 0f a4 c2 13               	shldq	$0x13, %rax, %r10
    37d4: 48 0f ac c8 3d               	shrdq	$0x3d, %rcx, %rax
    37d9: 66 48 0f 6e c9               	movq	%rcx, %xmm1
    37de: 48 c1 e9 25                  	shrq	$0x25, %rcx
    37e2: 48 c1 ea 35                  	shrq	$0x35, %rdx
    37e6: 48 c1 ef 2d                  	shrq	$0x2d, %rdi
    37ea: 66 49 0f 6e c2               	movq	%r10, %xmm0
    37ef: 66 49 0f 6e d1               	movq	%r9, %xmm2
    37f4: 66 0f 60 d0                  	punpcklbw	%xmm0, %xmm2    # xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
    37f8: 66 0f 6f 05 00 00 00 00      	movdqa	, %xmm0 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final+0x110>
		00000000000037fc:  R_X86_64_PC32	.LCPI10_0-0x4
    3800: 66 0f db d0                  	pand	%xmm0, %xmm2
    3804: 66 49 0f 6e d8               	movq	%r8, %xmm3
    3809: 66 48 0f 6e e6               	movq	%rsi, %xmm4
    380e: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    # xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    3812: 66 0f 72 f4 10               	pslld	$0x10, %xmm4
    3817: 66 0f 6f d8                  	movdqa	%xmm0, %xmm3
    381b: 66 0f df dc                  	pandn	%xmm4, %xmm3
    381f: 66 0f eb da                  	por	%xmm2, %xmm3
    3823: 66 41 0f 7e 9e c8 00 00 00   	movd	%xmm3, 0xc8(%r14)
    382c: 66 0f 6e d7                  	movd	%edi, %xmm2
    3830: 66 0f 6e da                  	movd	%edx, %xmm3
    3834: 66 0f 60 da                  	punpcklbw	%xmm2, %xmm3    # xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
    3838: 66 0f db d8                  	pand	%xmm0, %xmm3
    383c: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
    3840: 66 0f 73 d2 1d               	psrlq	$0x1d, %xmm2
    3845: 66 0f 6e e1                  	movd	%ecx, %xmm4
    3849: 66 0f 60 e2                  	punpcklbw	%xmm2, %xmm4    # xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1],xmm4[2],xmm2[2],xmm4[3],xmm2[3],xmm4[4],xmm2[4],xmm4[5],xmm2[5],xmm4[6],xmm2[6],xmm4[7],xmm2[7]
    384d: 66 0f 72 f4 10               	pslld	$0x10, %xmm4
    3852: 66 0f df c4                  	pandn	%xmm4, %xmm0
    3856: 66 0f eb c3                  	por	%xmm3, %xmm0
    385a: 66 48 0f 6e d0               	movq	%rax, %xmm2
    385f: 66 0f 6f d9                  	movdqa	%xmm1, %xmm3
    3863: 66 0f 73 d3 05               	psrlq	$0x5, %xmm3
    3868: 66 0f 60 da                  	punpcklbw	%xmm2, %xmm3    # xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
    386c: 66 0f 73 f3 30               	psllq	$0x30, %xmm3
    3871: 66 0f 6f 15 00 00 00 00      	movdqa	, %xmm2 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final+0x189>
		0000000000003875:  R_X86_64_PC32	.LCPI10_1-0x4
    3879: 66 0f 6f e1                  	movdqa	%xmm1, %xmm4
    387d: 66 0f 73 d4 0d               	psrlq	$0xd, %xmm4
    3882: 66 0f 73 d1 15               	psrlq	$0x15, %xmm1
    3887: 66 0f 60 cc                  	punpcklbw	%xmm4, %xmm1    # xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1],xmm1[2],xmm4[2],xmm1[3],xmm4[3],xmm1[4],xmm4[4],xmm1[5],xmm4[5],xmm1[6],xmm4[6],xmm1[7],xmm4[7]
    388b: 66 0f 70 c9 50               	pshufd	$0x50, %xmm1, %xmm1     # xmm1 = xmm1[0,0,1,1]
    3890: 66 0f db ca                  	pand	%xmm2, %xmm1
    3894: 66 0f df d3                  	pandn	%xmm3, %xmm2
    3898: 66 0f eb d1                  	por	%xmm1, %xmm2
    389c: 66 0f 70 ca 55               	pshufd	$0x55, %xmm2, %xmm1     # xmm1 = xmm2[1,1,1,1]
    38a1: 66 0f 62 c1                  	punpckldq	%xmm1, %xmm0    # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
    38a5: 66 41 0f d6 86 c0 00 00 00   	movq	%xmm0, 0xc0(%r14)
    38ae: 4c 89 f7                     	movq	%r14, %rdi
    38b1: 4c 89 fe                     	movq	%r15, %rsi
    38b4: e8 57 00 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    38b9: 49 8b 46 10                  	movq	0x10(%r14), %rax
    38bd: 48 0f c8                     	bswapq	%rax
    38c0: 48 89 03                     	movq	%rax, (%rbx)
    38c3: 49 8b 46 18                  	movq	0x18(%r14), %rax
    38c7: 48 0f c8                     	bswapq	%rax
    38ca: 48 89 43 08                  	movq	%rax, 0x8(%rbx)
    38ce: 49 8b 46 20                  	movq	0x20(%r14), %rax
    38d2: 48 0f c8                     	bswapq	%rax
    38d5: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    38d9: 49 8b 46 28                  	movq	0x28(%r14), %rax
    38dd: 48 0f c8                     	bswapq	%rax
    38e0: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    38e4: 49 8b 46 30                  	movq	0x30(%r14), %rax
    38e8: 48 0f c8                     	bswapq	%rax
    38eb: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    38ef: 49 8b 46 38                  	movq	0x38(%r14), %rax
    38f3: 48 0f c8                     	bswapq	%rax
    38f6: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    38fa: 48 83 c4 08                  	addq	$0x8, %rsp
    38fe: 5b                           	popq	%rbx
    38ff: 41 5e                        	popq	%r14
    3901: 41 5f                        	popq	%r15
    3903: 5d                           	popq	%rbp
    3904: c3                           	retq
    3905: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    390f: 90                           	nop

0000000000003910 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    3910: 55                           	pushq	%rbp
    3911: 48 89 e5                     	movq	%rsp, %rbp
    3914: 41 57                        	pushq	%r15
    3916: 41 56                        	pushq	%r14
    3918: 41 55                        	pushq	%r13
    391a: 41 54                        	pushq	%r12
    391c: 53                           	pushq	%rbx
    391d: 48 81 ec 00 02 00 00         	subq	$0x200, %rsp            # imm = 0x200
    3924: 48 8b 16                     	movq	(%rsi), %rdx
    3927: 48 0f ca                     	bswapq	%rdx
    392a: 48 89 95 58 fd ff ff         	movq	%rdx, -0x2a8(%rbp)
    3931: 48 8b 46 08                  	movq	0x8(%rsi), %rax
    3935: 48 0f c8                     	bswapq	%rax
    3938: 48 89 85 60 fd ff ff         	movq	%rax, -0x2a0(%rbp)
    393f: 48 8b 46 10                  	movq	0x10(%rsi), %rax
    3943: 48 0f c8                     	bswapq	%rax
    3946: 48 89 85 68 fd ff ff         	movq	%rax, -0x298(%rbp)
    394d: 48 8b 46 18                  	movq	0x18(%rsi), %rax
    3951: 48 0f c8                     	bswapq	%rax
    3954: 48 89 85 70 fd ff ff         	movq	%rax, -0x290(%rbp)
    395b: 48 8b 46 20                  	movq	0x20(%rsi), %rax
    395f: 48 0f c8                     	bswapq	%rax
    3962: 48 89 85 78 fd ff ff         	movq	%rax, -0x288(%rbp)
    3969: 48 8b 46 28                  	movq	0x28(%rsi), %rax
    396d: 48 0f c8                     	bswapq	%rax
    3970: 48 89 85 80 fd ff ff         	movq	%rax, -0x280(%rbp)
    3977: 48 8b 46 30                  	movq	0x30(%rsi), %rax
    397b: 48 0f c8                     	bswapq	%rax
    397e: 48 89 85 88 fd ff ff         	movq	%rax, -0x278(%rbp)
    3985: 48 8b 46 38                  	movq	0x38(%rsi), %rax
    3989: 48 0f c8                     	bswapq	%rax
    398c: 48 89 85 90 fd ff ff         	movq	%rax, -0x270(%rbp)
    3993: 48 8b 46 40                  	movq	0x40(%rsi), %rax
    3997: 48 0f c8                     	bswapq	%rax
    399a: 48 89 85 98 fd ff ff         	movq	%rax, -0x268(%rbp)
    39a1: 48 8b 46 48                  	movq	0x48(%rsi), %rax
    39a5: 48 0f c8                     	bswapq	%rax
    39a8: 48 89 85 a0 fd ff ff         	movq	%rax, -0x260(%rbp)
    39af: 48 8b 46 50                  	movq	0x50(%rsi), %rax
    39b3: 48 0f c8                     	bswapq	%rax
    39b6: 48 89 85 a8 fd ff ff         	movq	%rax, -0x258(%rbp)
    39bd: 48 8b 46 58                  	movq	0x58(%rsi), %rax
    39c1: 48 0f c8                     	bswapq	%rax
    39c4: 48 89 85 b0 fd ff ff         	movq	%rax, -0x250(%rbp)
    39cb: 48 8b 46 60                  	movq	0x60(%rsi), %rax
    39cf: 48 0f c8                     	bswapq	%rax
    39d2: 48 89 85 b8 fd ff ff         	movq	%rax, -0x248(%rbp)
    39d9: 48 8b 46 68                  	movq	0x68(%rsi), %rax
    39dd: 48 0f c8                     	bswapq	%rax
    39e0: 48 89 85 c0 fd ff ff         	movq	%rax, -0x240(%rbp)
    39e7: 48 8b 46 70                  	movq	0x70(%rsi), %rax
    39eb: 48 0f c8                     	bswapq	%rax
    39ee: 48 89 85 c8 fd ff ff         	movq	%rax, -0x238(%rbp)
    39f5: 48 8b 46 78                  	movq	0x78(%rsi), %rax
    39f9: 48 0f c8                     	bswapq	%rax
    39fc: 48 89 85 d0 fd ff ff         	movq	%rax, -0x230(%rbp)
    3a03: 31 c0                        	xorl	%eax, %eax
    3a05: 48 89 d6                     	movq	%rdx, %rsi
    3a08: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L0>:
    3a10: 48 03 b4 c5 a0 fd ff ff      	addq	-0x260(%rbp,%rax,8), %rsi
    3a18: 48 8b 8c c5 60 fd ff ff      	movq	-0x2a0(%rbp,%rax,8), %rcx
    3a20: 49 89 c8                     	movq	%rcx, %r8
    3a23: 49 d1 c8                     	rorq	%r8
    3a26: 49 89 c9                     	movq	%rcx, %r9
    3a29: 49 c1 c1 38                  	rolq	$0x38, %r9
    3a2d: 4c 8b 94 c5 c8 fd ff ff      	movq	-0x238(%rbp,%rax,8), %r10
    3a35: 4d 31 c1                     	xorq	%r8, %r9
    3a38: 49 89 c8                     	movq	%rcx, %r8
    3a3b: 49 c1 e8 07                  	shrq	$0x7, %r8
    3a3f: 4d 31 c8                     	xorq	%r9, %r8
    3a42: 4d 89 d1                     	movq	%r10, %r9
    3a45: 49 c1 c1 2d                  	rolq	$0x2d, %r9
    3a49: 49 01 f0                     	addq	%rsi, %r8
    3a4c: 4c 89 d6                     	movq	%r10, %rsi
    3a4f: 48 c1 c6 03                  	rolq	$0x3, %rsi
    3a53: 4c 31 ce                     	xorq	%r9, %rsi
    3a56: 49 c1 ea 06                  	shrq	$0x6, %r10
    3a5a: 49 31 f2                     	xorq	%rsi, %r10
    3a5d: 4d 01 c2                     	addq	%r8, %r10
    3a60: 4c 89 94 c5 d8 fd ff ff      	movq	%r10, -0x228(%rbp,%rax,8)
    3a68: 48 83 c0 01                  	addq	$0x1, %rax
    3a6c: 48 89 ce                     	movq	%rcx, %rsi
    3a6f: 48 83 f8 40                  	cmpq	$0x40, %rax
    3a73: 75 9b                        	jne	 <L0>
    3a75: 48 8b 47 10                  	movq	0x10(%rdi), %rax
    3a79: 48 8b 77 18                  	movq	0x18(%rdi), %rsi
    3a7d: 4c 8b 47 20                  	movq	0x20(%rdi), %r8
    3a81: 48 8b 4f 30                  	movq	0x30(%rdi), %rcx
    3a85: 49 89 c9                     	movq	%rcx, %r9
    3a88: 49 c1 c1 32                  	rolq	$0x32, %r9
    3a8c: 48 8b 5f 38                  	movq	0x38(%rdi), %rbx
    3a90: 49 89 ca                     	movq	%rcx, %r10
    3a93: 49 c1 c2 2e                  	rolq	$0x2e, %r10
    3a97: 4c 8b 5f 40                  	movq	0x40(%rdi), %r11
    3a9b: 49 89 cf                     	movq	%rcx, %r15
    3a9e: 49 c1 c7 17                  	rolq	$0x17, %r15
    3aa2: 4d 31 ca                     	xorq	%r9, %r10
    3aa5: 4d 31 d7                     	xorq	%r10, %r15
    3aa8: 4d 89 d9                     	movq	%r11, %r9
    3aab: 49 31 d9                     	xorq	%rbx, %r9
    3aae: 49 21 c9                     	andq	%rcx, %r9
    3ab1: 4d 31 d9                     	xorq	%r11, %r9
    3ab4: 4c 03 7f 48                  	addq	0x48(%rdi), %r15
    3ab8: 4c 01 ca                     	addq	%r9, %rdx
    3abb: 49 be 22 ae 28 d7 98 2f 8a 42	movabsq	$0x428a2f98d728ae22, %r14 # imm = 0x428A2F98D728AE22
    3ac5: 49 01 d6                     	addq	%rdx, %r14
    3ac8: 4d 01 fe                     	addq	%r15, %r14
    3acb: 4c 8b 57 28                  	movq	0x28(%rdi), %r10
    3acf: 48 89 c2                     	movq	%rax, %rdx
    3ad2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3ad6: 4d 01 f2                     	addq	%r14, %r10
    3ad9: 49 89 c1                     	movq	%rax, %r9
    3adc: 49 c1 c1 1e                  	rolq	$0x1e, %r9
    3ae0: 49 31 d1                     	xorq	%rdx, %r9
    3ae3: 48 89 c2                     	movq	%rax, %rdx
    3ae6: 48 c1 c2 19                  	rolq	$0x19, %rdx
    3aea: 4c 31 ca                     	xorq	%r9, %rdx
    3aed: 4d 89 c7                     	movq	%r8, %r15
    3af0: 49 09 f7                     	orq	%rsi, %r15
    3af3: 49 21 c7                     	andq	%rax, %r15
    3af6: 4d 89 c1                     	movq	%r8, %r9
    3af9: 49 21 f1                     	andq	%rsi, %r9
    3afc: 4d 09 f9                     	orq	%r15, %r9
    3aff: 49 01 d1                     	addq	%rdx, %r9
    3b02: 4d 01 f1                     	addq	%r14, %r9
    3b05: 4c 89 d2                     	movq	%r10, %rdx
    3b08: 48 c1 c2 32                  	rolq	$0x32, %rdx
    3b0c: 4d 89 d6                     	movq	%r10, %r14
    3b0f: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3b13: 49 31 d6                     	xorq	%rdx, %r14
    3b16: 4d 89 d7                     	movq	%r10, %r15
    3b19: 49 c1 c7 17                  	rolq	$0x17, %r15
    3b1d: 4d 31 f7                     	xorq	%r14, %r15
    3b20: 48 89 da                     	movq	%rbx, %rdx
    3b23: 48 31 ca                     	xorq	%rcx, %rdx
    3b26: 4c 21 d2                     	andq	%r10, %rdx
    3b29: 48 31 da                     	xorq	%rbx, %rdx
    3b2c: 4c 03 9d 60 fd ff ff         	addq	-0x2a0(%rbp), %r11
    3b33: 49 01 d3                     	addq	%rdx, %r11
    3b36: 48 ba cd 65 ef 23 91 44 37 71	movabsq	$0x7137449123ef65cd, %rdx # imm = 0x7137449123EF65CD
    3b40: 4c 01 da                     	addq	%r11, %rdx
    3b43: 4d 89 cb                     	movq	%r9, %r11
    3b46: 49 c1 c3 24                  	rolq	$0x24, %r11
    3b4a: 4c 01 fa                     	addq	%r15, %rdx
    3b4d: 4d 89 ce                     	movq	%r9, %r14
    3b50: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3b54: 49 01 d0                     	addq	%rdx, %r8
    3b57: 4d 89 cf                     	movq	%r9, %r15
    3b5a: 49 c1 c7 19                  	rolq	$0x19, %r15
    3b5e: 4d 31 de                     	xorq	%r11, %r14
    3b61: 4d 31 f7                     	xorq	%r14, %r15
    3b64: 49 89 f6                     	movq	%rsi, %r14
    3b67: 49 09 c6                     	orq	%rax, %r14
    3b6a: 4d 21 ce                     	andq	%r9, %r14
    3b6d: 49 89 f3                     	movq	%rsi, %r11
    3b70: 49 21 c3                     	andq	%rax, %r11
    3b73: 4d 09 f3                     	orq	%r14, %r11
    3b76: 4d 01 fb                     	addq	%r15, %r11
    3b79: 4d 89 c6                     	movq	%r8, %r14
    3b7c: 49 c1 c6 32                  	rolq	$0x32, %r14
    3b80: 49 01 d3                     	addq	%rdx, %r11
    3b83: 4c 89 c2                     	movq	%r8, %rdx
    3b86: 48 c1 c2 2e                  	rolq	$0x2e, %rdx
    3b8a: 4c 31 f2                     	xorq	%r14, %rdx
    3b8d: 4d 89 c7                     	movq	%r8, %r15
    3b90: 49 c1 c7 17                  	rolq	$0x17, %r15
    3b94: 49 31 d7                     	xorq	%rdx, %r15
    3b97: 4c 89 d2                     	movq	%r10, %rdx
    3b9a: 48 31 ca                     	xorq	%rcx, %rdx
    3b9d: 4c 21 c2                     	andq	%r8, %rdx
    3ba0: 48 31 ca                     	xorq	%rcx, %rdx
    3ba3: 48 03 9d 68 fd ff ff         	addq	-0x298(%rbp), %rbx
    3baa: 48 01 d3                     	addq	%rdx, %rbx
    3bad: 49 be 2f 3b 4d ec cf fb c0 b5	movabsq	$-0x4a3f043013b2c4d1, %r14 # imm = 0xB5C0FBCFEC4D3B2F
    3bb7: 49 01 de                     	addq	%rbx, %r14
    3bba: 4d 01 fe                     	addq	%r15, %r14
    3bbd: 4c 01 f6                     	addq	%r14, %rsi
    3bc0: 4c 89 da                     	movq	%r11, %rdx
    3bc3: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3bc7: 4c 89 db                     	movq	%r11, %rbx
    3bca: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3bce: 48 31 d3                     	xorq	%rdx, %rbx
    3bd1: 4d 89 df                     	movq	%r11, %r15
    3bd4: 49 c1 c7 19                  	rolq	$0x19, %r15
    3bd8: 49 31 df                     	xorq	%rbx, %r15
    3bdb: 4c 89 cb                     	movq	%r9, %rbx
    3bde: 48 09 c3                     	orq	%rax, %rbx
    3be1: 4c 21 db                     	andq	%r11, %rbx
    3be4: 4c 89 ca                     	movq	%r9, %rdx
    3be7: 48 21 c2                     	andq	%rax, %rdx
    3bea: 48 09 da                     	orq	%rbx, %rdx
    3bed: 48 89 f3                     	movq	%rsi, %rbx
    3bf0: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3bf4: 4c 01 fa                     	addq	%r15, %rdx
    3bf7: 49 89 f7                     	movq	%rsi, %r15
    3bfa: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3bfe: 4c 01 f2                     	addq	%r14, %rdx
    3c01: 49 89 f4                     	movq	%rsi, %r12
    3c04: 49 c1 c4 17                  	rolq	$0x17, %r12
    3c08: 49 31 df                     	xorq	%rbx, %r15
    3c0b: 4d 31 fc                     	xorq	%r15, %r12
    3c0e: 4c 89 c3                     	movq	%r8, %rbx
    3c11: 4c 31 d3                     	xorq	%r10, %rbx
    3c14: 48 21 f3                     	andq	%rsi, %rbx
    3c17: 4c 31 d3                     	xorq	%r10, %rbx
    3c1a: 48 03 8d 70 fd ff ff         	addq	-0x290(%rbp), %rcx
    3c21: 48 01 d9                     	addq	%rbx, %rcx
    3c24: 49 be bc db 89 81 a5 db b5 e9	movabsq	$-0x164a245a7e762444, %r14 # imm = 0xE9B5DBA58189DBBC
    3c2e: 49 01 ce                     	addq	%rcx, %r14
    3c31: 4d 01 e6                     	addq	%r12, %r14
    3c34: 48 89 d1                     	movq	%rdx, %rcx
    3c37: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3c3b: 48 89 d3                     	movq	%rdx, %rbx
    3c3e: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3c42: 48 31 cb                     	xorq	%rcx, %rbx
    3c45: 49 89 d7                     	movq	%rdx, %r15
    3c48: 49 c1 c7 19                  	rolq	$0x19, %r15
    3c4c: 49 31 df                     	xorq	%rbx, %r15
    3c4f: 4c 89 db                     	movq	%r11, %rbx
    3c52: 4c 09 cb                     	orq	%r9, %rbx
    3c55: 48 21 d3                     	andq	%rdx, %rbx
    3c58: 4c 89 d9                     	movq	%r11, %rcx
    3c5b: 4c 21 c9                     	andq	%r9, %rcx
    3c5e: 48 09 d9                     	orq	%rbx, %rcx
    3c61: 4c 01 f9                     	addq	%r15, %rcx
    3c64: 4c 01 f1                     	addq	%r14, %rcx
    3c67: 49 01 c6                     	addq	%rax, %r14
    3c6a: 4c 89 f3                     	movq	%r14, %rbx
    3c6d: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3c71: 4d 89 f7                     	movq	%r14, %r15
    3c74: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3c78: 49 31 df                     	xorq	%rbx, %r15
    3c7b: 4d 89 f4                     	movq	%r14, %r12
    3c7e: 49 c1 c4 17                  	rolq	$0x17, %r12
    3c82: 4d 31 fc                     	xorq	%r15, %r12
    3c85: 48 89 f3                     	movq	%rsi, %rbx
    3c88: 4c 31 c3                     	xorq	%r8, %rbx
    3c8b: 4c 21 f3                     	andq	%r14, %rbx
    3c8e: 4c 03 95 78 fd ff ff         	addq	-0x288(%rbp), %r10
    3c95: 4c 31 c3                     	xorq	%r8, %rbx
    3c98: 49 01 da                     	addq	%rbx, %r10
    3c9b: 48 bb 38 b5 48 f3 5b c2 56 39	movabsq	$0x3956c25bf348b538, %rbx # imm = 0x3956C25BF348B538
    3ca5: 4c 01 d3                     	addq	%r10, %rbx
    3ca8: 4c 01 e3                     	addq	%r12, %rbx
    3cab: 49 89 ca                     	movq	%rcx, %r10
    3cae: 49 c1 c2 24                  	rolq	$0x24, %r10
    3cb2: 49 01 d9                     	addq	%rbx, %r9
    3cb5: 49 89 cf                     	movq	%rcx, %r15
    3cb8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3cbc: 4d 31 d7                     	xorq	%r10, %r15
    3cbf: 49 89 cc                     	movq	%rcx, %r12
    3cc2: 49 c1 c4 19                  	rolq	$0x19, %r12
    3cc6: 4d 31 fc                     	xorq	%r15, %r12
    3cc9: 49 89 d7                     	movq	%rdx, %r15
    3ccc: 4d 09 df                     	orq	%r11, %r15
    3ccf: 49 21 cf                     	andq	%rcx, %r15
    3cd2: 49 89 d2                     	movq	%rdx, %r10
    3cd5: 4d 21 da                     	andq	%r11, %r10
    3cd8: 4d 09 fa                     	orq	%r15, %r10
    3cdb: 4d 01 e2                     	addq	%r12, %r10
    3cde: 49 01 da                     	addq	%rbx, %r10
    3ce1: 4c 89 cb                     	movq	%r9, %rbx
    3ce4: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3ce8: 4d 89 cf                     	movq	%r9, %r15
    3ceb: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3cef: 49 31 df                     	xorq	%rbx, %r15
    3cf2: 4c 89 cb                     	movq	%r9, %rbx
    3cf5: 48 c1 c3 17                  	rolq	$0x17, %rbx
    3cf9: 4c 31 fb                     	xorq	%r15, %rbx
    3cfc: 4d 89 f7                     	movq	%r14, %r15
    3cff: 49 31 f7                     	xorq	%rsi, %r15
    3d02: 4d 21 cf                     	andq	%r9, %r15
    3d05: 49 31 f7                     	xorq	%rsi, %r15
    3d08: 4c 03 85 80 fd ff ff         	addq	-0x280(%rbp), %r8
    3d0f: 4d 01 f8                     	addq	%r15, %r8
    3d12: 49 bf 19 d0 05 b6 f1 11 f1 59	movabsq	$0x59f111f1b605d019, %r15 # imm = 0x59F111F1B605D019
    3d1c: 4d 01 c7                     	addq	%r8, %r15
    3d1f: 4d 89 d0                     	movq	%r10, %r8
    3d22: 49 c1 c0 24                  	rolq	$0x24, %r8
    3d26: 49 01 df                     	addq	%rbx, %r15
    3d29: 4c 89 d3                     	movq	%r10, %rbx
    3d2c: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3d30: 4d 01 fb                     	addq	%r15, %r11
    3d33: 4d 89 d4                     	movq	%r10, %r12
    3d36: 49 c1 c4 19                  	rolq	$0x19, %r12
    3d3a: 4c 31 c3                     	xorq	%r8, %rbx
    3d3d: 49 31 dc                     	xorq	%rbx, %r12
    3d40: 49 89 c8                     	movq	%rcx, %r8
    3d43: 49 09 d0                     	orq	%rdx, %r8
    3d46: 4d 21 d0                     	andq	%r10, %r8
    3d49: 48 89 cb                     	movq	%rcx, %rbx
    3d4c: 48 21 d3                     	andq	%rdx, %rbx
    3d4f: 4c 09 c3                     	orq	%r8, %rbx
    3d52: 4c 01 e3                     	addq	%r12, %rbx
    3d55: 4d 89 d8                     	movq	%r11, %r8
    3d58: 49 c1 c0 32                  	rolq	$0x32, %r8
    3d5c: 4c 01 fb                     	addq	%r15, %rbx
    3d5f: 4d 89 df                     	movq	%r11, %r15
    3d62: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3d66: 4d 31 c7                     	xorq	%r8, %r15
    3d69: 4d 89 dc                     	movq	%r11, %r12
    3d6c: 49 c1 c4 17                  	rolq	$0x17, %r12
    3d70: 4d 31 fc                     	xorq	%r15, %r12
    3d73: 4d 89 c8                     	movq	%r9, %r8
    3d76: 4d 31 f0                     	xorq	%r14, %r8
    3d79: 4d 21 d8                     	andq	%r11, %r8
    3d7c: 4d 31 f0                     	xorq	%r14, %r8
    3d7f: 48 03 b5 88 fd ff ff         	addq	-0x278(%rbp), %rsi
    3d86: 4c 01 c6                     	addq	%r8, %rsi
    3d89: 49 b8 9b 4f 19 af a4 82 3f 92	movabsq	$-0x6dc07d5b50e6b065, %r8 # imm = 0x923F82A4AF194F9B
    3d93: 49 01 f0                     	addq	%rsi, %r8
    3d96: 4d 01 e0                     	addq	%r12, %r8
    3d99: 4c 01 c2                     	addq	%r8, %rdx
    3d9c: 48 89 de                     	movq	%rbx, %rsi
    3d9f: 48 c1 c6 24                  	rolq	$0x24, %rsi
    3da3: 49 89 df                     	movq	%rbx, %r15
    3da6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3daa: 49 31 f7                     	xorq	%rsi, %r15
    3dad: 49 89 dc                     	movq	%rbx, %r12
    3db0: 49 c1 c4 19                  	rolq	$0x19, %r12
    3db4: 4d 31 fc                     	xorq	%r15, %r12
    3db7: 4d 89 d7                     	movq	%r10, %r15
    3dba: 49 09 cf                     	orq	%rcx, %r15
    3dbd: 49 21 df                     	andq	%rbx, %r15
    3dc0: 4c 89 d6                     	movq	%r10, %rsi
    3dc3: 48 21 ce                     	andq	%rcx, %rsi
    3dc6: 4c 09 fe                     	orq	%r15, %rsi
    3dc9: 49 89 d7                     	movq	%rdx, %r15
    3dcc: 49 c1 c7 32                  	rolq	$0x32, %r15
    3dd0: 4c 01 e6                     	addq	%r12, %rsi
    3dd3: 49 89 d4                     	movq	%rdx, %r12
    3dd6: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3dda: 4c 01 c6                     	addq	%r8, %rsi
    3ddd: 49 89 d0                     	movq	%rdx, %r8
    3de0: 49 c1 c0 17                  	rolq	$0x17, %r8
    3de4: 4d 31 fc                     	xorq	%r15, %r12
    3de7: 4d 31 e0                     	xorq	%r12, %r8
    3dea: 4d 89 df                     	movq	%r11, %r15
    3ded: 4d 31 cf                     	xorq	%r9, %r15
    3df0: 49 21 d7                     	andq	%rdx, %r15
    3df3: 4d 31 cf                     	xorq	%r9, %r15
    3df6: 4c 03 b5 90 fd ff ff         	addq	-0x270(%rbp), %r14
    3dfd: 4d 01 fe                     	addq	%r15, %r14
    3e00: 49 bf 18 81 6d da d5 5e 1c ab	movabsq	$-0x54e3a12a25927ee8, %r15 # imm = 0xAB1C5ED5DA6D8118
    3e0a: 4d 01 f7                     	addq	%r14, %r15
    3e0d: 4d 01 c7                     	addq	%r8, %r15
    3e10: 4c 01 f9                     	addq	%r15, %rcx
    3e13: 49 89 f0                     	movq	%rsi, %r8
    3e16: 49 c1 c0 24                  	rolq	$0x24, %r8
    3e1a: 49 89 f6                     	movq	%rsi, %r14
    3e1d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3e21: 4d 31 c6                     	xorq	%r8, %r14
    3e24: 49 89 f4                     	movq	%rsi, %r12
    3e27: 49 c1 c4 19                  	rolq	$0x19, %r12
    3e2b: 4d 31 f4                     	xorq	%r14, %r12
    3e2e: 49 89 de                     	movq	%rbx, %r14
    3e31: 4d 09 d6                     	orq	%r10, %r14
    3e34: 49 21 f6                     	andq	%rsi, %r14
    3e37: 49 89 d8                     	movq	%rbx, %r8
    3e3a: 4d 21 d0                     	andq	%r10, %r8
    3e3d: 4d 09 f0                     	orq	%r14, %r8
    3e40: 4d 01 e0                     	addq	%r12, %r8
    3e43: 4d 01 f8                     	addq	%r15, %r8
    3e46: 49 89 ce                     	movq	%rcx, %r14
    3e49: 49 c1 c6 32                  	rolq	$0x32, %r14
    3e4d: 49 89 cf                     	movq	%rcx, %r15
    3e50: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3e54: 4d 31 f7                     	xorq	%r14, %r15
    3e57: 49 89 cc                     	movq	%rcx, %r12
    3e5a: 49 c1 c4 17                  	rolq	$0x17, %r12
    3e5e: 4d 31 fc                     	xorq	%r15, %r12
    3e61: 49 89 d6                     	movq	%rdx, %r14
    3e64: 4d 31 de                     	xorq	%r11, %r14
    3e67: 49 21 ce                     	andq	%rcx, %r14
    3e6a: 4c 03 8d 98 fd ff ff         	addq	-0x268(%rbp), %r9
    3e71: 4d 31 de                     	xorq	%r11, %r14
    3e74: 4d 01 f1                     	addq	%r14, %r9
    3e77: 49 be 42 02 03 a3 98 aa 07 d8	movabsq	$-0x27f855675cfcfdbe, %r14 # imm = 0xD807AA98A3030242
    3e81: 4d 01 ce                     	addq	%r9, %r14
    3e84: 4d 01 e6                     	addq	%r12, %r14
    3e87: 4d 89 c1                     	movq	%r8, %r9
    3e8a: 49 c1 c1 24                  	rolq	$0x24, %r9
    3e8e: 4d 01 f2                     	addq	%r14, %r10
    3e91: 4d 89 c7                     	movq	%r8, %r15
    3e94: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3e98: 4d 31 cf                     	xorq	%r9, %r15
    3e9b: 4d 89 c4                     	movq	%r8, %r12
    3e9e: 49 c1 c4 19                  	rolq	$0x19, %r12
    3ea2: 4d 31 fc                     	xorq	%r15, %r12
    3ea5: 49 89 f7                     	movq	%rsi, %r15
    3ea8: 49 09 df                     	orq	%rbx, %r15
    3eab: 4d 21 c7                     	andq	%r8, %r15
    3eae: 49 89 f1                     	movq	%rsi, %r9
    3eb1: 49 21 d9                     	andq	%rbx, %r9
    3eb4: 4d 09 f9                     	orq	%r15, %r9
    3eb7: 4d 01 e1                     	addq	%r12, %r9
    3eba: 4d 01 f1                     	addq	%r14, %r9
    3ebd: 4d 89 d6                     	movq	%r10, %r14
    3ec0: 49 c1 c6 32                  	rolq	$0x32, %r14
    3ec4: 4d 89 d7                     	movq	%r10, %r15
    3ec7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3ecb: 4d 31 f7                     	xorq	%r14, %r15
    3ece: 4d 89 d4                     	movq	%r10, %r12
    3ed1: 49 c1 c4 17                  	rolq	$0x17, %r12
    3ed5: 4d 31 fc                     	xorq	%r15, %r12
    3ed8: 49 89 ce                     	movq	%rcx, %r14
    3edb: 49 31 d6                     	xorq	%rdx, %r14
    3ede: 4d 21 d6                     	andq	%r10, %r14
    3ee1: 49 31 d6                     	xorq	%rdx, %r14
    3ee4: 4c 03 9d a0 fd ff ff         	addq	-0x260(%rbp), %r11
    3eeb: 4d 01 f3                     	addq	%r14, %r11
    3eee: 49 be be 6f 70 45 01 5b 83 12	movabsq	$0x12835b0145706fbe, %r14 # imm = 0x12835B0145706FBE
    3ef8: 4d 01 de                     	addq	%r11, %r14
    3efb: 4d 89 cb                     	movq	%r9, %r11
    3efe: 49 c1 c3 24                  	rolq	$0x24, %r11
    3f02: 4d 01 e6                     	addq	%r12, %r14
    3f05: 4d 89 cf                     	movq	%r9, %r15
    3f08: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3f0c: 4c 01 f3                     	addq	%r14, %rbx
    3f0f: 4d 89 cc                     	movq	%r9, %r12
    3f12: 49 c1 c4 19                  	rolq	$0x19, %r12
    3f16: 4d 31 df                     	xorq	%r11, %r15
    3f19: 4d 31 fc                     	xorq	%r15, %r12
    3f1c: 4d 89 c7                     	movq	%r8, %r15
    3f1f: 49 09 f7                     	orq	%rsi, %r15
    3f22: 4d 21 cf                     	andq	%r9, %r15
    3f25: 4d 89 c3                     	movq	%r8, %r11
    3f28: 49 21 f3                     	andq	%rsi, %r11
    3f2b: 4d 09 fb                     	orq	%r15, %r11
    3f2e: 4d 01 e3                     	addq	%r12, %r11
    3f31: 49 89 df                     	movq	%rbx, %r15
    3f34: 49 c1 c7 32                  	rolq	$0x32, %r15
    3f38: 4d 01 f3                     	addq	%r14, %r11
    3f3b: 49 89 de                     	movq	%rbx, %r14
    3f3e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3f42: 4d 31 fe                     	xorq	%r15, %r14
    3f45: 49 89 df                     	movq	%rbx, %r15
    3f48: 49 c1 c7 17                  	rolq	$0x17, %r15
    3f4c: 4d 31 f7                     	xorq	%r14, %r15
    3f4f: 4d 89 d6                     	movq	%r10, %r14
    3f52: 49 31 ce                     	xorq	%rcx, %r14
    3f55: 49 21 de                     	andq	%rbx, %r14
    3f58: 49 31 ce                     	xorq	%rcx, %r14
    3f5b: 48 03 95 a8 fd ff ff         	addq	-0x258(%rbp), %rdx
    3f62: 4c 01 f2                     	addq	%r14, %rdx
    3f65: 49 be 8c b2 e4 4e be 85 31 24	movabsq	$0x243185be4ee4b28c, %r14 # imm = 0x243185BE4EE4B28C
    3f6f: 49 01 d6                     	addq	%rdx, %r14
    3f72: 4d 01 fe                     	addq	%r15, %r14
    3f75: 4c 01 f6                     	addq	%r14, %rsi
    3f78: 4c 89 da                     	movq	%r11, %rdx
    3f7b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3f7f: 4d 89 df                     	movq	%r11, %r15
    3f82: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3f86: 49 31 d7                     	xorq	%rdx, %r15
    3f89: 4d 89 dc                     	movq	%r11, %r12
    3f8c: 49 c1 c4 19                  	rolq	$0x19, %r12
    3f90: 4d 31 fc                     	xorq	%r15, %r12
    3f93: 4d 89 cf                     	movq	%r9, %r15
    3f96: 4d 09 c7                     	orq	%r8, %r15
    3f99: 4d 21 df                     	andq	%r11, %r15
    3f9c: 4c 89 ca                     	movq	%r9, %rdx
    3f9f: 4c 21 c2                     	andq	%r8, %rdx
    3fa2: 4c 09 fa                     	orq	%r15, %rdx
    3fa5: 49 89 f7                     	movq	%rsi, %r15
    3fa8: 49 c1 c7 32                  	rolq	$0x32, %r15
    3fac: 4c 01 e2                     	addq	%r12, %rdx
    3faf: 49 89 f4                     	movq	%rsi, %r12
    3fb2: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3fb6: 4c 01 f2                     	addq	%r14, %rdx
    3fb9: 49 89 f6                     	movq	%rsi, %r14
    3fbc: 49 c1 c6 17                  	rolq	$0x17, %r14
    3fc0: 4d 31 fc                     	xorq	%r15, %r12
    3fc3: 4d 31 e6                     	xorq	%r12, %r14
    3fc6: 49 89 df                     	movq	%rbx, %r15
    3fc9: 4d 31 d7                     	xorq	%r10, %r15
    3fcc: 49 21 f7                     	andq	%rsi, %r15
    3fcf: 4d 31 d7                     	xorq	%r10, %r15
    3fd2: 48 03 8d b0 fd ff ff         	addq	-0x250(%rbp), %rcx
    3fd9: 4c 01 f9                     	addq	%r15, %rcx
    3fdc: 49 bf e2 b4 ff d5 c3 7d 0c 55	movabsq	$0x550c7dc3d5ffb4e2, %r15 # imm = 0x550C7DC3D5FFB4E2
    3fe6: 49 01 cf                     	addq	%rcx, %r15
    3fe9: 4d 01 f7                     	addq	%r14, %r15
    3fec: 4d 01 f8                     	addq	%r15, %r8
    3fef: 48 89 d1                     	movq	%rdx, %rcx
    3ff2: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3ff6: 49 89 d6                     	movq	%rdx, %r14
    3ff9: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3ffd: 49 31 ce                     	xorq	%rcx, %r14
    4000: 49 89 d4                     	movq	%rdx, %r12
    4003: 49 c1 c4 19                  	rolq	$0x19, %r12
    4007: 4d 31 f4                     	xorq	%r14, %r12
    400a: 4d 89 de                     	movq	%r11, %r14
    400d: 4d 09 ce                     	orq	%r9, %r14
    4010: 49 21 d6                     	andq	%rdx, %r14
    4013: 4c 89 d9                     	movq	%r11, %rcx
    4016: 4c 21 c9                     	andq	%r9, %rcx
    4019: 4c 09 f1                     	orq	%r14, %rcx
    401c: 4c 01 e1                     	addq	%r12, %rcx
    401f: 4c 01 f9                     	addq	%r15, %rcx
    4022: 4d 89 c6                     	movq	%r8, %r14
    4025: 49 c1 c6 32                  	rolq	$0x32, %r14
    4029: 4d 89 c7                     	movq	%r8, %r15
    402c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4030: 4d 31 f7                     	xorq	%r14, %r15
    4033: 4d 89 c4                     	movq	%r8, %r12
    4036: 49 c1 c4 17                  	rolq	$0x17, %r12
    403a: 4d 31 fc                     	xorq	%r15, %r12
    403d: 49 89 f6                     	movq	%rsi, %r14
    4040: 49 31 de                     	xorq	%rbx, %r14
    4043: 4d 21 c6                     	andq	%r8, %r14
    4046: 4c 03 95 b8 fd ff ff         	addq	-0x248(%rbp), %r10
    404d: 49 31 de                     	xorq	%rbx, %r14
    4050: 4d 01 f2                     	addq	%r14, %r10
    4053: 49 be 6f 89 7b f2 74 5d be 72	movabsq	$0x72be5d74f27b896f, %r14 # imm = 0x72BE5D74F27B896F
    405d: 4d 01 d6                     	addq	%r10, %r14
    4060: 4d 01 e6                     	addq	%r12, %r14
    4063: 49 89 ca                     	movq	%rcx, %r10
    4066: 49 c1 c2 24                  	rolq	$0x24, %r10
    406a: 4d 01 f1                     	addq	%r14, %r9
    406d: 49 89 cf                     	movq	%rcx, %r15
    4070: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4074: 4d 31 d7                     	xorq	%r10, %r15
    4077: 49 89 cc                     	movq	%rcx, %r12
    407a: 49 c1 c4 19                  	rolq	$0x19, %r12
    407e: 4d 31 fc                     	xorq	%r15, %r12
    4081: 49 89 d7                     	movq	%rdx, %r15
    4084: 4d 09 df                     	orq	%r11, %r15
    4087: 49 21 cf                     	andq	%rcx, %r15
    408a: 49 89 d2                     	movq	%rdx, %r10
    408d: 4d 21 da                     	andq	%r11, %r10
    4090: 4d 09 fa                     	orq	%r15, %r10
    4093: 4d 01 e2                     	addq	%r12, %r10
    4096: 4d 01 f2                     	addq	%r14, %r10
    4099: 4d 89 ce                     	movq	%r9, %r14
    409c: 49 c1 c6 32                  	rolq	$0x32, %r14
    40a0: 4d 89 cf                     	movq	%r9, %r15
    40a3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    40a7: 4d 31 f7                     	xorq	%r14, %r15
    40aa: 4d 89 cc                     	movq	%r9, %r12
    40ad: 49 c1 c4 17                  	rolq	$0x17, %r12
    40b1: 4d 31 fc                     	xorq	%r15, %r12
    40b4: 4d 89 c6                     	movq	%r8, %r14
    40b7: 49 31 f6                     	xorq	%rsi, %r14
    40ba: 4d 21 ce                     	andq	%r9, %r14
    40bd: 49 31 f6                     	xorq	%rsi, %r14
    40c0: 48 03 9d c0 fd ff ff         	addq	-0x240(%rbp), %rbx
    40c7: 4c 01 f3                     	addq	%r14, %rbx
    40ca: 49 be b1 96 16 3b fe b1 de 80	movabsq	$-0x7f214e01c4e9694f, %r14 # imm = 0x80DEB1FE3B1696B1
    40d4: 49 01 de                     	addq	%rbx, %r14
    40d7: 4c 89 d3                     	movq	%r10, %rbx
    40da: 48 c1 c3 24                  	rolq	$0x24, %rbx
    40de: 4d 01 e6                     	addq	%r12, %r14
    40e1: 4d 89 d7                     	movq	%r10, %r15
    40e4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    40e8: 4d 01 f3                     	addq	%r14, %r11
    40eb: 4d 89 d4                     	movq	%r10, %r12
    40ee: 49 c1 c4 19                  	rolq	$0x19, %r12
    40f2: 49 31 df                     	xorq	%rbx, %r15
    40f5: 4d 31 fc                     	xorq	%r15, %r12
    40f8: 49 89 cf                     	movq	%rcx, %r15
    40fb: 49 09 d7                     	orq	%rdx, %r15
    40fe: 4d 21 d7                     	andq	%r10, %r15
    4101: 48 89 cb                     	movq	%rcx, %rbx
    4104: 48 21 d3                     	andq	%rdx, %rbx
    4107: 4c 09 fb                     	orq	%r15, %rbx
    410a: 4c 01 e3                     	addq	%r12, %rbx
    410d: 4d 89 df                     	movq	%r11, %r15
    4110: 49 c1 c7 32                  	rolq	$0x32, %r15
    4114: 4c 01 f3                     	addq	%r14, %rbx
    4117: 4d 89 de                     	movq	%r11, %r14
    411a: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    411e: 4d 31 fe                     	xorq	%r15, %r14
    4121: 4d 89 df                     	movq	%r11, %r15
    4124: 49 c1 c7 17                  	rolq	$0x17, %r15
    4128: 4d 31 f7                     	xorq	%r14, %r15
    412b: 4d 89 ce                     	movq	%r9, %r14
    412e: 4d 31 c6                     	xorq	%r8, %r14
    4131: 4d 21 de                     	andq	%r11, %r14
    4134: 4d 31 c6                     	xorq	%r8, %r14
    4137: 48 03 b5 c8 fd ff ff         	addq	-0x238(%rbp), %rsi
    413e: 4c 01 f6                     	addq	%r14, %rsi
    4141: 49 be 35 12 c7 25 a7 06 dc 9b	movabsq	$-0x6423f958da38edcb, %r14 # imm = 0x9BDC06A725C71235
    414b: 49 01 f6                     	addq	%rsi, %r14
    414e: 4d 01 fe                     	addq	%r15, %r14
    4151: 4c 01 f2                     	addq	%r14, %rdx
    4154: 48 89 de                     	movq	%rbx, %rsi
    4157: 48 c1 c6 24                  	rolq	$0x24, %rsi
    415b: 49 89 df                     	movq	%rbx, %r15
    415e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4162: 49 31 f7                     	xorq	%rsi, %r15
    4165: 49 89 dc                     	movq	%rbx, %r12
    4168: 49 c1 c4 19                  	rolq	$0x19, %r12
    416c: 4d 31 fc                     	xorq	%r15, %r12
    416f: 4d 89 d7                     	movq	%r10, %r15
    4172: 49 09 cf                     	orq	%rcx, %r15
    4175: 49 21 df                     	andq	%rbx, %r15
    4178: 4c 89 d6                     	movq	%r10, %rsi
    417b: 48 21 ce                     	andq	%rcx, %rsi
    417e: 4c 09 fe                     	orq	%r15, %rsi
    4181: 49 89 d7                     	movq	%rdx, %r15
    4184: 49 c1 c7 32                  	rolq	$0x32, %r15
    4188: 4c 01 e6                     	addq	%r12, %rsi
    418b: 49 89 d4                     	movq	%rdx, %r12
    418e: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4192: 4c 01 f6                     	addq	%r14, %rsi
    4195: 49 89 d6                     	movq	%rdx, %r14
    4198: 49 c1 c6 17                  	rolq	$0x17, %r14
    419c: 4d 31 fc                     	xorq	%r15, %r12
    419f: 4d 31 e6                     	xorq	%r12, %r14
    41a2: 4d 89 df                     	movq	%r11, %r15
    41a5: 4d 31 cf                     	xorq	%r9, %r15
    41a8: 49 21 d7                     	andq	%rdx, %r15
    41ab: 4d 31 cf                     	xorq	%r9, %r15
    41ae: 4c 03 85 d0 fd ff ff         	addq	-0x230(%rbp), %r8
    41b5: 4d 01 f8                     	addq	%r15, %r8
    41b8: 49 bf 94 26 69 cf 74 f1 9b c1	movabsq	$-0x3e640e8b3096d96c, %r15 # imm = 0xC19BF174CF692694
    41c2: 4d 01 c7                     	addq	%r8, %r15
    41c5: 4d 01 f7                     	addq	%r14, %r15
    41c8: 4c 01 f9                     	addq	%r15, %rcx
    41cb: 49 89 f0                     	movq	%rsi, %r8
    41ce: 49 c1 c0 24                  	rolq	$0x24, %r8
    41d2: 49 89 f6                     	movq	%rsi, %r14
    41d5: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    41d9: 4d 31 c6                     	xorq	%r8, %r14
    41dc: 49 89 f4                     	movq	%rsi, %r12
    41df: 49 c1 c4 19                  	rolq	$0x19, %r12
    41e3: 4d 31 f4                     	xorq	%r14, %r12
    41e6: 49 89 de                     	movq	%rbx, %r14
    41e9: 4d 09 d6                     	orq	%r10, %r14
    41ec: 49 21 f6                     	andq	%rsi, %r14
    41ef: 49 89 d8                     	movq	%rbx, %r8
    41f2: 4d 21 d0                     	andq	%r10, %r8
    41f5: 4d 09 f0                     	orq	%r14, %r8
    41f8: 4d 01 e0                     	addq	%r12, %r8
    41fb: 4d 01 f8                     	addq	%r15, %r8
    41fe: 49 89 ce                     	movq	%rcx, %r14
    4201: 49 c1 c6 32                  	rolq	$0x32, %r14
    4205: 49 89 cf                     	movq	%rcx, %r15
    4208: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    420c: 4d 31 f7                     	xorq	%r14, %r15
    420f: 49 89 cc                     	movq	%rcx, %r12
    4212: 49 c1 c4 17                  	rolq	$0x17, %r12
    4216: 4d 31 fc                     	xorq	%r15, %r12
    4219: 49 89 d6                     	movq	%rdx, %r14
    421c: 4d 31 de                     	xorq	%r11, %r14
    421f: 49 21 ce                     	andq	%rcx, %r14
    4222: 4c 03 8d d8 fd ff ff         	addq	-0x228(%rbp), %r9
    4229: 4d 31 de                     	xorq	%r11, %r14
    422c: 4d 01 f1                     	addq	%r14, %r9
    422f: 49 be d2 4a f1 9e c1 69 9b e4	movabsq	$-0x1b64963e610eb52e, %r14 # imm = 0xE49B69C19EF14AD2
    4239: 4d 01 ce                     	addq	%r9, %r14
    423c: 4d 01 e6                     	addq	%r12, %r14
    423f: 4d 89 c1                     	movq	%r8, %r9
    4242: 49 c1 c1 24                  	rolq	$0x24, %r9
    4246: 4d 01 f2                     	addq	%r14, %r10
    4249: 4d 89 c7                     	movq	%r8, %r15
    424c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4250: 4d 31 cf                     	xorq	%r9, %r15
    4253: 4d 89 c4                     	movq	%r8, %r12
    4256: 49 c1 c4 19                  	rolq	$0x19, %r12
    425a: 4d 31 fc                     	xorq	%r15, %r12
    425d: 49 89 f7                     	movq	%rsi, %r15
    4260: 49 09 df                     	orq	%rbx, %r15
    4263: 4d 21 c7                     	andq	%r8, %r15
    4266: 49 89 f1                     	movq	%rsi, %r9
    4269: 49 21 d9                     	andq	%rbx, %r9
    426c: 4d 09 f9                     	orq	%r15, %r9
    426f: 4d 01 e1                     	addq	%r12, %r9
    4272: 4d 01 f1                     	addq	%r14, %r9
    4275: 4d 89 d6                     	movq	%r10, %r14
    4278: 49 c1 c6 32                  	rolq	$0x32, %r14
    427c: 4d 89 d7                     	movq	%r10, %r15
    427f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4283: 4d 31 f7                     	xorq	%r14, %r15
    4286: 4d 89 d4                     	movq	%r10, %r12
    4289: 49 c1 c4 17                  	rolq	$0x17, %r12
    428d: 4d 31 fc                     	xorq	%r15, %r12
    4290: 49 89 ce                     	movq	%rcx, %r14
    4293: 49 31 d6                     	xorq	%rdx, %r14
    4296: 4d 21 d6                     	andq	%r10, %r14
    4299: 49 31 d6                     	xorq	%rdx, %r14
    429c: 4c 03 9d e0 fd ff ff         	addq	-0x220(%rbp), %r11
    42a3: 4d 01 f3                     	addq	%r14, %r11
    42a6: 49 be e3 25 4f 38 86 47 be ef	movabsq	$-0x1041b879c7b0da1d, %r14 # imm = 0xEFBE4786384F25E3
    42b0: 4d 01 de                     	addq	%r11, %r14
    42b3: 4d 89 cb                     	movq	%r9, %r11
    42b6: 49 c1 c3 24                  	rolq	$0x24, %r11
    42ba: 4d 01 e6                     	addq	%r12, %r14
    42bd: 4d 89 cf                     	movq	%r9, %r15
    42c0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    42c4: 4c 01 f3                     	addq	%r14, %rbx
    42c7: 4d 89 cc                     	movq	%r9, %r12
    42ca: 49 c1 c4 19                  	rolq	$0x19, %r12
    42ce: 4d 31 df                     	xorq	%r11, %r15
    42d1: 4d 31 fc                     	xorq	%r15, %r12
    42d4: 4d 89 c7                     	movq	%r8, %r15
    42d7: 49 09 f7                     	orq	%rsi, %r15
    42da: 4d 21 cf                     	andq	%r9, %r15
    42dd: 4d 89 c3                     	movq	%r8, %r11
    42e0: 49 21 f3                     	andq	%rsi, %r11
    42e3: 4d 09 fb                     	orq	%r15, %r11
    42e6: 4d 01 e3                     	addq	%r12, %r11
    42e9: 49 89 df                     	movq	%rbx, %r15
    42ec: 49 c1 c7 32                  	rolq	$0x32, %r15
    42f0: 4d 01 f3                     	addq	%r14, %r11
    42f3: 49 89 de                     	movq	%rbx, %r14
    42f6: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    42fa: 4d 31 fe                     	xorq	%r15, %r14
    42fd: 49 89 df                     	movq	%rbx, %r15
    4300: 49 c1 c7 17                  	rolq	$0x17, %r15
    4304: 4d 31 f7                     	xorq	%r14, %r15
    4307: 4d 89 d6                     	movq	%r10, %r14
    430a: 49 31 ce                     	xorq	%rcx, %r14
    430d: 49 21 de                     	andq	%rbx, %r14
    4310: 49 31 ce                     	xorq	%rcx, %r14
    4313: 48 03 95 e8 fd ff ff         	addq	-0x218(%rbp), %rdx
    431a: 4c 01 f2                     	addq	%r14, %rdx
    431d: 49 be b5 d5 8c 8b c6 9d c1 0f	movabsq	$0xfc19dc68b8cd5b5, %r14 # imm = 0xFC19DC68B8CD5B5
    4327: 49 01 d6                     	addq	%rdx, %r14
    432a: 4d 01 fe                     	addq	%r15, %r14
    432d: 4c 01 f6                     	addq	%r14, %rsi
    4330: 4c 89 da                     	movq	%r11, %rdx
    4333: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4337: 4d 89 df                     	movq	%r11, %r15
    433a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    433e: 49 31 d7                     	xorq	%rdx, %r15
    4341: 4d 89 dc                     	movq	%r11, %r12
    4344: 49 c1 c4 19                  	rolq	$0x19, %r12
    4348: 4d 31 fc                     	xorq	%r15, %r12
    434b: 4d 89 cf                     	movq	%r9, %r15
    434e: 4d 09 c7                     	orq	%r8, %r15
    4351: 4d 21 df                     	andq	%r11, %r15
    4354: 4c 89 ca                     	movq	%r9, %rdx
    4357: 4c 21 c2                     	andq	%r8, %rdx
    435a: 4c 09 fa                     	orq	%r15, %rdx
    435d: 49 89 f7                     	movq	%rsi, %r15
    4360: 49 c1 c7 32                  	rolq	$0x32, %r15
    4364: 4c 01 e2                     	addq	%r12, %rdx
    4367: 49 89 f4                     	movq	%rsi, %r12
    436a: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    436e: 4c 01 f2                     	addq	%r14, %rdx
    4371: 49 89 f6                     	movq	%rsi, %r14
    4374: 49 c1 c6 17                  	rolq	$0x17, %r14
    4378: 4d 31 fc                     	xorq	%r15, %r12
    437b: 4d 31 e6                     	xorq	%r12, %r14
    437e: 49 89 df                     	movq	%rbx, %r15
    4381: 4d 31 d7                     	xorq	%r10, %r15
    4384: 49 21 f7                     	andq	%rsi, %r15
    4387: 4d 31 d7                     	xorq	%r10, %r15
    438a: 48 03 8d f0 fd ff ff         	addq	-0x210(%rbp), %rcx
    4391: 4c 01 f9                     	addq	%r15, %rcx
    4394: 49 bf 65 9c ac 77 cc a1 0c 24	movabsq	$0x240ca1cc77ac9c65, %r15 # imm = 0x240CA1CC77AC9C65
    439e: 49 01 cf                     	addq	%rcx, %r15
    43a1: 4d 01 f7                     	addq	%r14, %r15
    43a4: 4d 01 f8                     	addq	%r15, %r8
    43a7: 48 89 d1                     	movq	%rdx, %rcx
    43aa: 48 c1 c1 24                  	rolq	$0x24, %rcx
    43ae: 49 89 d6                     	movq	%rdx, %r14
    43b1: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    43b5: 49 31 ce                     	xorq	%rcx, %r14
    43b8: 49 89 d4                     	movq	%rdx, %r12
    43bb: 49 c1 c4 19                  	rolq	$0x19, %r12
    43bf: 4d 31 f4                     	xorq	%r14, %r12
    43c2: 4d 89 de                     	movq	%r11, %r14
    43c5: 4d 09 ce                     	orq	%r9, %r14
    43c8: 49 21 d6                     	andq	%rdx, %r14
    43cb: 4c 89 d9                     	movq	%r11, %rcx
    43ce: 4c 21 c9                     	andq	%r9, %rcx
    43d1: 4c 09 f1                     	orq	%r14, %rcx
    43d4: 4c 01 e1                     	addq	%r12, %rcx
    43d7: 4c 01 f9                     	addq	%r15, %rcx
    43da: 4d 89 c6                     	movq	%r8, %r14
    43dd: 49 c1 c6 32                  	rolq	$0x32, %r14
    43e1: 4d 89 c7                     	movq	%r8, %r15
    43e4: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    43e8: 4d 31 f7                     	xorq	%r14, %r15
    43eb: 4d 89 c4                     	movq	%r8, %r12
    43ee: 49 c1 c4 17                  	rolq	$0x17, %r12
    43f2: 4d 31 fc                     	xorq	%r15, %r12
    43f5: 49 89 f6                     	movq	%rsi, %r14
    43f8: 49 31 de                     	xorq	%rbx, %r14
    43fb: 4d 21 c6                     	andq	%r8, %r14
    43fe: 4c 03 95 f8 fd ff ff         	addq	-0x208(%rbp), %r10
    4405: 49 31 de                     	xorq	%rbx, %r14
    4408: 4d 01 f2                     	addq	%r14, %r10
    440b: 49 be 75 02 2b 59 6f 2c e9 2d	movabsq	$0x2de92c6f592b0275, %r14 # imm = 0x2DE92C6F592B0275
    4415: 4d 01 d6                     	addq	%r10, %r14
    4418: 4d 01 e6                     	addq	%r12, %r14
    441b: 49 89 ca                     	movq	%rcx, %r10
    441e: 49 c1 c2 24                  	rolq	$0x24, %r10
    4422: 4d 01 f1                     	addq	%r14, %r9
    4425: 49 89 cf                     	movq	%rcx, %r15
    4428: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    442c: 4d 31 d7                     	xorq	%r10, %r15
    442f: 49 89 cc                     	movq	%rcx, %r12
    4432: 49 c1 c4 19                  	rolq	$0x19, %r12
    4436: 4d 31 fc                     	xorq	%r15, %r12
    4439: 49 89 d7                     	movq	%rdx, %r15
    443c: 4d 09 df                     	orq	%r11, %r15
    443f: 49 21 cf                     	andq	%rcx, %r15
    4442: 49 89 d2                     	movq	%rdx, %r10
    4445: 4d 21 da                     	andq	%r11, %r10
    4448: 4d 09 fa                     	orq	%r15, %r10
    444b: 4d 01 e2                     	addq	%r12, %r10
    444e: 4d 01 f2                     	addq	%r14, %r10
    4451: 4d 89 ce                     	movq	%r9, %r14
    4454: 49 c1 c6 32                  	rolq	$0x32, %r14
    4458: 4d 89 cf                     	movq	%r9, %r15
    445b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    445f: 4d 31 f7                     	xorq	%r14, %r15
    4462: 4d 89 cc                     	movq	%r9, %r12
    4465: 49 c1 c4 17                  	rolq	$0x17, %r12
    4469: 4d 31 fc                     	xorq	%r15, %r12
    446c: 4d 89 c6                     	movq	%r8, %r14
    446f: 49 31 f6                     	xorq	%rsi, %r14
    4472: 4d 21 ce                     	andq	%r9, %r14
    4475: 49 31 f6                     	xorq	%rsi, %r14
    4478: 48 03 9d 00 fe ff ff         	addq	-0x200(%rbp), %rbx
    447f: 4c 01 f3                     	addq	%r14, %rbx
    4482: 49 be 83 e4 a6 6e aa 84 74 4a	movabsq	$0x4a7484aa6ea6e483, %r14 # imm = 0x4A7484AA6EA6E483
    448c: 49 01 de                     	addq	%rbx, %r14
    448f: 4c 89 d3                     	movq	%r10, %rbx
    4492: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4496: 4d 01 e6                     	addq	%r12, %r14
    4499: 4d 89 d7                     	movq	%r10, %r15
    449c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    44a0: 4d 01 f3                     	addq	%r14, %r11
    44a3: 4d 89 d4                     	movq	%r10, %r12
    44a6: 49 c1 c4 19                  	rolq	$0x19, %r12
    44aa: 49 31 df                     	xorq	%rbx, %r15
    44ad: 4d 31 fc                     	xorq	%r15, %r12
    44b0: 49 89 cf                     	movq	%rcx, %r15
    44b3: 49 09 d7                     	orq	%rdx, %r15
    44b6: 4d 21 d7                     	andq	%r10, %r15
    44b9: 48 89 cb                     	movq	%rcx, %rbx
    44bc: 48 21 d3                     	andq	%rdx, %rbx
    44bf: 4c 09 fb                     	orq	%r15, %rbx
    44c2: 4c 01 e3                     	addq	%r12, %rbx
    44c5: 4d 89 df                     	movq	%r11, %r15
    44c8: 49 c1 c7 32                  	rolq	$0x32, %r15
    44cc: 4c 01 f3                     	addq	%r14, %rbx
    44cf: 4d 89 de                     	movq	%r11, %r14
    44d2: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    44d6: 4d 31 fe                     	xorq	%r15, %r14
    44d9: 4d 89 df                     	movq	%r11, %r15
    44dc: 49 c1 c7 17                  	rolq	$0x17, %r15
    44e0: 4d 31 f7                     	xorq	%r14, %r15
    44e3: 4d 89 ce                     	movq	%r9, %r14
    44e6: 4d 31 c6                     	xorq	%r8, %r14
    44e9: 4d 21 de                     	andq	%r11, %r14
    44ec: 4d 31 c6                     	xorq	%r8, %r14
    44ef: 48 03 b5 08 fe ff ff         	addq	-0x1f8(%rbp), %rsi
    44f6: 4c 01 f6                     	addq	%r14, %rsi
    44f9: 49 be d4 fb 41 bd dc a9 b0 5c	movabsq	$0x5cb0a9dcbd41fbd4, %r14 # imm = 0x5CB0A9DCBD41FBD4
    4503: 49 01 f6                     	addq	%rsi, %r14
    4506: 4d 01 fe                     	addq	%r15, %r14
    4509: 4c 01 f2                     	addq	%r14, %rdx
    450c: 48 89 de                     	movq	%rbx, %rsi
    450f: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4513: 49 89 df                     	movq	%rbx, %r15
    4516: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    451a: 49 31 f7                     	xorq	%rsi, %r15
    451d: 49 89 dc                     	movq	%rbx, %r12
    4520: 49 c1 c4 19                  	rolq	$0x19, %r12
    4524: 4d 31 fc                     	xorq	%r15, %r12
    4527: 4d 89 d7                     	movq	%r10, %r15
    452a: 49 09 cf                     	orq	%rcx, %r15
    452d: 49 21 df                     	andq	%rbx, %r15
    4530: 4c 89 d6                     	movq	%r10, %rsi
    4533: 48 21 ce                     	andq	%rcx, %rsi
    4536: 4c 09 fe                     	orq	%r15, %rsi
    4539: 49 89 d7                     	movq	%rdx, %r15
    453c: 49 c1 c7 32                  	rolq	$0x32, %r15
    4540: 4c 01 e6                     	addq	%r12, %rsi
    4543: 49 89 d4                     	movq	%rdx, %r12
    4546: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    454a: 4c 01 f6                     	addq	%r14, %rsi
    454d: 49 89 d6                     	movq	%rdx, %r14
    4550: 49 c1 c6 17                  	rolq	$0x17, %r14
    4554: 4d 31 fc                     	xorq	%r15, %r12
    4557: 4d 31 e6                     	xorq	%r12, %r14
    455a: 4d 89 df                     	movq	%r11, %r15
    455d: 4d 31 cf                     	xorq	%r9, %r15
    4560: 49 21 d7                     	andq	%rdx, %r15
    4563: 4d 31 cf                     	xorq	%r9, %r15
    4566: 4c 03 85 10 fe ff ff         	addq	-0x1f0(%rbp), %r8
    456d: 4d 01 f8                     	addq	%r15, %r8
    4570: 49 bf b5 53 11 83 da 88 f9 76	movabsq	$0x76f988da831153b5, %r15 # imm = 0x76F988DA831153B5
    457a: 4d 01 c7                     	addq	%r8, %r15
    457d: 4d 01 f7                     	addq	%r14, %r15
    4580: 4c 01 f9                     	addq	%r15, %rcx
    4583: 49 89 f0                     	movq	%rsi, %r8
    4586: 49 c1 c0 24                  	rolq	$0x24, %r8
    458a: 49 89 f6                     	movq	%rsi, %r14
    458d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4591: 4d 31 c6                     	xorq	%r8, %r14
    4594: 49 89 f4                     	movq	%rsi, %r12
    4597: 49 c1 c4 19                  	rolq	$0x19, %r12
    459b: 4d 31 f4                     	xorq	%r14, %r12
    459e: 49 89 de                     	movq	%rbx, %r14
    45a1: 4d 09 d6                     	orq	%r10, %r14
    45a4: 49 21 f6                     	andq	%rsi, %r14
    45a7: 49 89 d8                     	movq	%rbx, %r8
    45aa: 4d 21 d0                     	andq	%r10, %r8
    45ad: 4d 09 f0                     	orq	%r14, %r8
    45b0: 4d 01 e0                     	addq	%r12, %r8
    45b3: 4d 01 f8                     	addq	%r15, %r8
    45b6: 49 89 ce                     	movq	%rcx, %r14
    45b9: 49 c1 c6 32                  	rolq	$0x32, %r14
    45bd: 49 89 cf                     	movq	%rcx, %r15
    45c0: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    45c4: 4d 31 f7                     	xorq	%r14, %r15
    45c7: 49 89 cc                     	movq	%rcx, %r12
    45ca: 49 c1 c4 17                  	rolq	$0x17, %r12
    45ce: 4d 31 fc                     	xorq	%r15, %r12
    45d1: 49 89 d6                     	movq	%rdx, %r14
    45d4: 4d 31 de                     	xorq	%r11, %r14
    45d7: 49 21 ce                     	andq	%rcx, %r14
    45da: 4c 03 8d 18 fe ff ff         	addq	-0x1e8(%rbp), %r9
    45e1: 4d 31 de                     	xorq	%r11, %r14
    45e4: 4d 01 f1                     	addq	%r14, %r9
    45e7: 49 be ab df 66 ee 52 51 3e 98	movabsq	$-0x67c1aead11992055, %r14 # imm = 0x983E5152EE66DFAB
    45f1: 4d 01 ce                     	addq	%r9, %r14
    45f4: 4d 01 e6                     	addq	%r12, %r14
    45f7: 4d 89 c1                     	movq	%r8, %r9
    45fa: 49 c1 c1 24                  	rolq	$0x24, %r9
    45fe: 4d 01 f2                     	addq	%r14, %r10
    4601: 4d 89 c7                     	movq	%r8, %r15
    4604: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4608: 4d 31 cf                     	xorq	%r9, %r15
    460b: 4d 89 c4                     	movq	%r8, %r12
    460e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4612: 4d 31 fc                     	xorq	%r15, %r12
    4615: 49 89 f7                     	movq	%rsi, %r15
    4618: 49 09 df                     	orq	%rbx, %r15
    461b: 4d 21 c7                     	andq	%r8, %r15
    461e: 49 89 f1                     	movq	%rsi, %r9
    4621: 49 21 d9                     	andq	%rbx, %r9
    4624: 4d 09 f9                     	orq	%r15, %r9
    4627: 4d 01 e1                     	addq	%r12, %r9
    462a: 4d 01 f1                     	addq	%r14, %r9
    462d: 4d 89 d6                     	movq	%r10, %r14
    4630: 49 c1 c6 32                  	rolq	$0x32, %r14
    4634: 4d 89 d7                     	movq	%r10, %r15
    4637: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    463b: 4d 31 f7                     	xorq	%r14, %r15
    463e: 4d 89 d4                     	movq	%r10, %r12
    4641: 49 c1 c4 17                  	rolq	$0x17, %r12
    4645: 4d 31 fc                     	xorq	%r15, %r12
    4648: 49 89 ce                     	movq	%rcx, %r14
    464b: 49 31 d6                     	xorq	%rdx, %r14
    464e: 4d 21 d6                     	andq	%r10, %r14
    4651: 49 31 d6                     	xorq	%rdx, %r14
    4654: 4c 03 9d 20 fe ff ff         	addq	-0x1e0(%rbp), %r11
    465b: 4d 01 f3                     	addq	%r14, %r11
    465e: 49 be 10 32 b4 2d 6d c6 31 a8	movabsq	$-0x57ce3992d24bcdf0, %r14 # imm = 0xA831C66D2DB43210
    4668: 4d 01 de                     	addq	%r11, %r14
    466b: 4d 89 cb                     	movq	%r9, %r11
    466e: 49 c1 c3 24                  	rolq	$0x24, %r11
    4672: 4d 01 e6                     	addq	%r12, %r14
    4675: 4d 89 cf                     	movq	%r9, %r15
    4678: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    467c: 4c 01 f3                     	addq	%r14, %rbx
    467f: 4d 89 cc                     	movq	%r9, %r12
    4682: 49 c1 c4 19                  	rolq	$0x19, %r12
    4686: 4d 31 df                     	xorq	%r11, %r15
    4689: 4d 31 fc                     	xorq	%r15, %r12
    468c: 4d 89 c7                     	movq	%r8, %r15
    468f: 49 09 f7                     	orq	%rsi, %r15
    4692: 4d 21 cf                     	andq	%r9, %r15
    4695: 4d 89 c3                     	movq	%r8, %r11
    4698: 49 21 f3                     	andq	%rsi, %r11
    469b: 4d 09 fb                     	orq	%r15, %r11
    469e: 4d 01 e3                     	addq	%r12, %r11
    46a1: 49 89 df                     	movq	%rbx, %r15
    46a4: 49 c1 c7 32                  	rolq	$0x32, %r15
    46a8: 4d 01 f3                     	addq	%r14, %r11
    46ab: 49 89 de                     	movq	%rbx, %r14
    46ae: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    46b2: 4d 31 fe                     	xorq	%r15, %r14
    46b5: 49 89 df                     	movq	%rbx, %r15
    46b8: 49 c1 c7 17                  	rolq	$0x17, %r15
    46bc: 4d 31 f7                     	xorq	%r14, %r15
    46bf: 4d 89 d6                     	movq	%r10, %r14
    46c2: 49 31 ce                     	xorq	%rcx, %r14
    46c5: 49 21 de                     	andq	%rbx, %r14
    46c8: 49 31 ce                     	xorq	%rcx, %r14
    46cb: 48 03 95 28 fe ff ff         	addq	-0x1d8(%rbp), %rdx
    46d2: 4c 01 f2                     	addq	%r14, %rdx
    46d5: 49 be 3f 21 fb 98 c8 27 03 b0	movabsq	$-0x4ffcd8376704dec1, %r14 # imm = 0xB00327C898FB213F
    46df: 49 01 d6                     	addq	%rdx, %r14
    46e2: 4d 01 fe                     	addq	%r15, %r14
    46e5: 4c 01 f6                     	addq	%r14, %rsi
    46e8: 4c 89 da                     	movq	%r11, %rdx
    46eb: 48 c1 c2 24                  	rolq	$0x24, %rdx
    46ef: 4d 89 df                     	movq	%r11, %r15
    46f2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    46f6: 49 31 d7                     	xorq	%rdx, %r15
    46f9: 4d 89 dc                     	movq	%r11, %r12
    46fc: 49 c1 c4 19                  	rolq	$0x19, %r12
    4700: 4d 31 fc                     	xorq	%r15, %r12
    4703: 4d 89 cf                     	movq	%r9, %r15
    4706: 4d 09 c7                     	orq	%r8, %r15
    4709: 4d 21 df                     	andq	%r11, %r15
    470c: 4c 89 ca                     	movq	%r9, %rdx
    470f: 4c 21 c2                     	andq	%r8, %rdx
    4712: 4c 09 fa                     	orq	%r15, %rdx
    4715: 49 89 f7                     	movq	%rsi, %r15
    4718: 49 c1 c7 32                  	rolq	$0x32, %r15
    471c: 4c 01 e2                     	addq	%r12, %rdx
    471f: 49 89 f4                     	movq	%rsi, %r12
    4722: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4726: 4c 01 f2                     	addq	%r14, %rdx
    4729: 49 89 f6                     	movq	%rsi, %r14
    472c: 49 c1 c6 17                  	rolq	$0x17, %r14
    4730: 4d 31 fc                     	xorq	%r15, %r12
    4733: 4d 31 e6                     	xorq	%r12, %r14
    4736: 49 89 df                     	movq	%rbx, %r15
    4739: 4d 31 d7                     	xorq	%r10, %r15
    473c: 49 21 f7                     	andq	%rsi, %r15
    473f: 4d 31 d7                     	xorq	%r10, %r15
    4742: 48 03 8d 30 fe ff ff         	addq	-0x1d0(%rbp), %rcx
    4749: 4c 01 f9                     	addq	%r15, %rcx
    474c: 49 bf e4 0e ef be c7 7f 59 bf	movabsq	$-0x40a680384110f11c, %r15 # imm = 0xBF597FC7BEEF0EE4
    4756: 49 01 cf                     	addq	%rcx, %r15
    4759: 4d 01 f7                     	addq	%r14, %r15
    475c: 4d 01 f8                     	addq	%r15, %r8
    475f: 48 89 d1                     	movq	%rdx, %rcx
    4762: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4766: 49 89 d6                     	movq	%rdx, %r14
    4769: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    476d: 49 31 ce                     	xorq	%rcx, %r14
    4770: 49 89 d4                     	movq	%rdx, %r12
    4773: 49 c1 c4 19                  	rolq	$0x19, %r12
    4777: 4d 31 f4                     	xorq	%r14, %r12
    477a: 4d 89 de                     	movq	%r11, %r14
    477d: 4d 09 ce                     	orq	%r9, %r14
    4780: 49 21 d6                     	andq	%rdx, %r14
    4783: 4c 89 d9                     	movq	%r11, %rcx
    4786: 4c 21 c9                     	andq	%r9, %rcx
    4789: 4c 09 f1                     	orq	%r14, %rcx
    478c: 4c 01 e1                     	addq	%r12, %rcx
    478f: 4c 01 f9                     	addq	%r15, %rcx
    4792: 4d 89 c6                     	movq	%r8, %r14
    4795: 49 c1 c6 32                  	rolq	$0x32, %r14
    4799: 4d 89 c7                     	movq	%r8, %r15
    479c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    47a0: 4d 31 f7                     	xorq	%r14, %r15
    47a3: 4d 89 c4                     	movq	%r8, %r12
    47a6: 49 c1 c4 17                  	rolq	$0x17, %r12
    47aa: 4d 31 fc                     	xorq	%r15, %r12
    47ad: 49 89 f6                     	movq	%rsi, %r14
    47b0: 49 31 de                     	xorq	%rbx, %r14
    47b3: 4d 21 c6                     	andq	%r8, %r14
    47b6: 4c 03 95 38 fe ff ff         	addq	-0x1c8(%rbp), %r10
    47bd: 49 31 de                     	xorq	%rbx, %r14
    47c0: 4d 01 f2                     	addq	%r14, %r10
    47c3: 49 be c2 8f a8 3d f3 0b e0 c6	movabsq	$-0x391ff40cc257703e, %r14 # imm = 0xC6E00BF33DA88FC2
    47cd: 4d 01 d6                     	addq	%r10, %r14
    47d0: 4d 01 e6                     	addq	%r12, %r14
    47d3: 49 89 ca                     	movq	%rcx, %r10
    47d6: 49 c1 c2 24                  	rolq	$0x24, %r10
    47da: 4d 01 f1                     	addq	%r14, %r9
    47dd: 49 89 cf                     	movq	%rcx, %r15
    47e0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    47e4: 4d 31 d7                     	xorq	%r10, %r15
    47e7: 49 89 cc                     	movq	%rcx, %r12
    47ea: 49 c1 c4 19                  	rolq	$0x19, %r12
    47ee: 4d 31 fc                     	xorq	%r15, %r12
    47f1: 49 89 d7                     	movq	%rdx, %r15
    47f4: 4d 09 df                     	orq	%r11, %r15
    47f7: 49 21 cf                     	andq	%rcx, %r15
    47fa: 49 89 d2                     	movq	%rdx, %r10
    47fd: 4d 21 da                     	andq	%r11, %r10
    4800: 4d 09 fa                     	orq	%r15, %r10
    4803: 4d 01 e2                     	addq	%r12, %r10
    4806: 4d 01 f2                     	addq	%r14, %r10
    4809: 4d 89 ce                     	movq	%r9, %r14
    480c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4810: 4d 89 cf                     	movq	%r9, %r15
    4813: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4817: 4d 31 f7                     	xorq	%r14, %r15
    481a: 4d 89 cc                     	movq	%r9, %r12
    481d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4821: 4d 31 fc                     	xorq	%r15, %r12
    4824: 4d 89 c6                     	movq	%r8, %r14
    4827: 49 31 f6                     	xorq	%rsi, %r14
    482a: 4d 21 ce                     	andq	%r9, %r14
    482d: 49 31 f6                     	xorq	%rsi, %r14
    4830: 48 03 9d 40 fe ff ff         	addq	-0x1c0(%rbp), %rbx
    4837: 4c 01 f3                     	addq	%r14, %rbx
    483a: 49 be 25 a7 0a 93 47 91 a7 d5	movabsq	$-0x2a586eb86cf558db, %r14 # imm = 0xD5A79147930AA725
    4844: 49 01 de                     	addq	%rbx, %r14
    4847: 4c 89 d3                     	movq	%r10, %rbx
    484a: 48 c1 c3 24                  	rolq	$0x24, %rbx
    484e: 4d 01 e6                     	addq	%r12, %r14
    4851: 4d 89 d7                     	movq	%r10, %r15
    4854: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4858: 4d 01 f3                     	addq	%r14, %r11
    485b: 4d 89 d4                     	movq	%r10, %r12
    485e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4862: 49 31 df                     	xorq	%rbx, %r15
    4865: 4d 31 fc                     	xorq	%r15, %r12
    4868: 49 89 cf                     	movq	%rcx, %r15
    486b: 49 09 d7                     	orq	%rdx, %r15
    486e: 4d 21 d7                     	andq	%r10, %r15
    4871: 48 89 cb                     	movq	%rcx, %rbx
    4874: 48 21 d3                     	andq	%rdx, %rbx
    4877: 4c 09 fb                     	orq	%r15, %rbx
    487a: 4c 01 e3                     	addq	%r12, %rbx
    487d: 4d 89 df                     	movq	%r11, %r15
    4880: 49 c1 c7 32                  	rolq	$0x32, %r15
    4884: 4c 01 f3                     	addq	%r14, %rbx
    4887: 4d 89 de                     	movq	%r11, %r14
    488a: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    488e: 4d 31 fe                     	xorq	%r15, %r14
    4891: 4d 89 df                     	movq	%r11, %r15
    4894: 49 c1 c7 17                  	rolq	$0x17, %r15
    4898: 4d 31 f7                     	xorq	%r14, %r15
    489b: 4d 89 ce                     	movq	%r9, %r14
    489e: 4d 31 c6                     	xorq	%r8, %r14
    48a1: 4d 21 de                     	andq	%r11, %r14
    48a4: 4d 31 c6                     	xorq	%r8, %r14
    48a7: 48 03 b5 48 fe ff ff         	addq	-0x1b8(%rbp), %rsi
    48ae: 4c 01 f6                     	addq	%r14, %rsi
    48b1: 49 be 6f 82 03 e0 51 63 ca 06	movabsq	$0x6ca6351e003826f, %r14 # imm = 0x6CA6351E003826F
    48bb: 49 01 f6                     	addq	%rsi, %r14
    48be: 4d 01 fe                     	addq	%r15, %r14
    48c1: 4c 01 f2                     	addq	%r14, %rdx
    48c4: 48 89 de                     	movq	%rbx, %rsi
    48c7: 48 c1 c6 24                  	rolq	$0x24, %rsi
    48cb: 49 89 df                     	movq	%rbx, %r15
    48ce: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    48d2: 49 31 f7                     	xorq	%rsi, %r15
    48d5: 49 89 dc                     	movq	%rbx, %r12
    48d8: 49 c1 c4 19                  	rolq	$0x19, %r12
    48dc: 4d 31 fc                     	xorq	%r15, %r12
    48df: 4d 89 d7                     	movq	%r10, %r15
    48e2: 49 09 cf                     	orq	%rcx, %r15
    48e5: 49 21 df                     	andq	%rbx, %r15
    48e8: 4c 89 d6                     	movq	%r10, %rsi
    48eb: 48 21 ce                     	andq	%rcx, %rsi
    48ee: 4c 09 fe                     	orq	%r15, %rsi
    48f1: 49 89 d7                     	movq	%rdx, %r15
    48f4: 49 c1 c7 32                  	rolq	$0x32, %r15
    48f8: 4c 01 e6                     	addq	%r12, %rsi
    48fb: 49 89 d4                     	movq	%rdx, %r12
    48fe: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4902: 4c 01 f6                     	addq	%r14, %rsi
    4905: 49 89 d6                     	movq	%rdx, %r14
    4908: 49 c1 c6 17                  	rolq	$0x17, %r14
    490c: 4d 31 fc                     	xorq	%r15, %r12
    490f: 4d 31 e6                     	xorq	%r12, %r14
    4912: 4d 89 df                     	movq	%r11, %r15
    4915: 4d 31 cf                     	xorq	%r9, %r15
    4918: 49 21 d7                     	andq	%rdx, %r15
    491b: 4d 31 cf                     	xorq	%r9, %r15
    491e: 4c 03 85 50 fe ff ff         	addq	-0x1b0(%rbp), %r8
    4925: 4d 01 f8                     	addq	%r15, %r8
    4928: 49 bf 70 6e 0e 0a 67 29 29 14	movabsq	$0x142929670a0e6e70, %r15 # imm = 0x142929670A0E6E70
    4932: 4d 01 c7                     	addq	%r8, %r15
    4935: 4d 01 f7                     	addq	%r14, %r15
    4938: 4c 01 f9                     	addq	%r15, %rcx
    493b: 49 89 f0                     	movq	%rsi, %r8
    493e: 49 c1 c0 24                  	rolq	$0x24, %r8
    4942: 49 89 f6                     	movq	%rsi, %r14
    4945: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4949: 4d 31 c6                     	xorq	%r8, %r14
    494c: 49 89 f4                     	movq	%rsi, %r12
    494f: 49 c1 c4 19                  	rolq	$0x19, %r12
    4953: 4d 31 f4                     	xorq	%r14, %r12
    4956: 49 89 de                     	movq	%rbx, %r14
    4959: 4d 09 d6                     	orq	%r10, %r14
    495c: 49 21 f6                     	andq	%rsi, %r14
    495f: 49 89 d8                     	movq	%rbx, %r8
    4962: 4d 21 d0                     	andq	%r10, %r8
    4965: 4d 09 f0                     	orq	%r14, %r8
    4968: 4d 01 e0                     	addq	%r12, %r8
    496b: 4d 01 f8                     	addq	%r15, %r8
    496e: 49 89 ce                     	movq	%rcx, %r14
    4971: 49 c1 c6 32                  	rolq	$0x32, %r14
    4975: 49 89 cf                     	movq	%rcx, %r15
    4978: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    497c: 4d 31 f7                     	xorq	%r14, %r15
    497f: 49 89 cc                     	movq	%rcx, %r12
    4982: 49 c1 c4 17                  	rolq	$0x17, %r12
    4986: 4d 31 fc                     	xorq	%r15, %r12
    4989: 49 89 d6                     	movq	%rdx, %r14
    498c: 4d 31 de                     	xorq	%r11, %r14
    498f: 49 21 ce                     	andq	%rcx, %r14
    4992: 4c 03 8d 58 fe ff ff         	addq	-0x1a8(%rbp), %r9
    4999: 4d 31 de                     	xorq	%r11, %r14
    499c: 4d 01 f1                     	addq	%r14, %r9
    499f: 49 be fc 2f d2 46 85 0a b7 27	movabsq	$0x27b70a8546d22ffc, %r14 # imm = 0x27B70A8546D22FFC
    49a9: 4d 01 ce                     	addq	%r9, %r14
    49ac: 4d 01 e6                     	addq	%r12, %r14
    49af: 4d 89 c1                     	movq	%r8, %r9
    49b2: 49 c1 c1 24                  	rolq	$0x24, %r9
    49b6: 4d 01 f2                     	addq	%r14, %r10
    49b9: 4d 89 c7                     	movq	%r8, %r15
    49bc: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    49c0: 4d 31 cf                     	xorq	%r9, %r15
    49c3: 4d 89 c4                     	movq	%r8, %r12
    49c6: 49 c1 c4 19                  	rolq	$0x19, %r12
    49ca: 4d 31 fc                     	xorq	%r15, %r12
    49cd: 49 89 f7                     	movq	%rsi, %r15
    49d0: 49 09 df                     	orq	%rbx, %r15
    49d3: 4d 21 c7                     	andq	%r8, %r15
    49d6: 49 89 f1                     	movq	%rsi, %r9
    49d9: 49 21 d9                     	andq	%rbx, %r9
    49dc: 4d 09 f9                     	orq	%r15, %r9
    49df: 4d 01 e1                     	addq	%r12, %r9
    49e2: 4d 01 f1                     	addq	%r14, %r9
    49e5: 4d 89 d6                     	movq	%r10, %r14
    49e8: 49 c1 c6 32                  	rolq	$0x32, %r14
    49ec: 4d 89 d7                     	movq	%r10, %r15
    49ef: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    49f3: 4d 31 f7                     	xorq	%r14, %r15
    49f6: 4d 89 d4                     	movq	%r10, %r12
    49f9: 49 c1 c4 17                  	rolq	$0x17, %r12
    49fd: 4d 31 fc                     	xorq	%r15, %r12
    4a00: 49 89 ce                     	movq	%rcx, %r14
    4a03: 49 31 d6                     	xorq	%rdx, %r14
    4a06: 4d 21 d6                     	andq	%r10, %r14
    4a09: 49 31 d6                     	xorq	%rdx, %r14
    4a0c: 4c 03 9d 60 fe ff ff         	addq	-0x1a0(%rbp), %r11
    4a13: 4d 01 f3                     	addq	%r14, %r11
    4a16: 49 be 26 c9 26 5c 38 21 1b 2e	movabsq	$0x2e1b21385c26c926, %r14 # imm = 0x2E1B21385C26C926
    4a20: 4d 01 de                     	addq	%r11, %r14
    4a23: 4d 89 cb                     	movq	%r9, %r11
    4a26: 49 c1 c3 24                  	rolq	$0x24, %r11
    4a2a: 4d 01 e6                     	addq	%r12, %r14
    4a2d: 4d 89 cf                     	movq	%r9, %r15
    4a30: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4a34: 4c 01 f3                     	addq	%r14, %rbx
    4a37: 4d 89 cc                     	movq	%r9, %r12
    4a3a: 49 c1 c4 19                  	rolq	$0x19, %r12
    4a3e: 4d 31 df                     	xorq	%r11, %r15
    4a41: 4d 31 fc                     	xorq	%r15, %r12
    4a44: 4d 89 c7                     	movq	%r8, %r15
    4a47: 49 09 f7                     	orq	%rsi, %r15
    4a4a: 4d 21 cf                     	andq	%r9, %r15
    4a4d: 4d 89 c3                     	movq	%r8, %r11
    4a50: 49 21 f3                     	andq	%rsi, %r11
    4a53: 4d 09 fb                     	orq	%r15, %r11
    4a56: 4d 01 e3                     	addq	%r12, %r11
    4a59: 49 89 df                     	movq	%rbx, %r15
    4a5c: 49 c1 c7 32                  	rolq	$0x32, %r15
    4a60: 4d 01 f3                     	addq	%r14, %r11
    4a63: 49 89 de                     	movq	%rbx, %r14
    4a66: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4a6a: 4d 31 fe                     	xorq	%r15, %r14
    4a6d: 49 89 df                     	movq	%rbx, %r15
    4a70: 49 c1 c7 17                  	rolq	$0x17, %r15
    4a74: 4d 31 f7                     	xorq	%r14, %r15
    4a77: 4d 89 d6                     	movq	%r10, %r14
    4a7a: 49 31 ce                     	xorq	%rcx, %r14
    4a7d: 49 21 de                     	andq	%rbx, %r14
    4a80: 49 31 ce                     	xorq	%rcx, %r14
    4a83: 48 03 95 68 fe ff ff         	addq	-0x198(%rbp), %rdx
    4a8a: 4c 01 f2                     	addq	%r14, %rdx
    4a8d: 49 be ed 2a c4 5a fc 6d 2c 4d	movabsq	$0x4d2c6dfc5ac42aed, %r14 # imm = 0x4D2C6DFC5AC42AED
    4a97: 49 01 d6                     	addq	%rdx, %r14
    4a9a: 4d 01 fe                     	addq	%r15, %r14
    4a9d: 4c 01 f6                     	addq	%r14, %rsi
    4aa0: 4c 89 da                     	movq	%r11, %rdx
    4aa3: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4aa7: 4d 89 df                     	movq	%r11, %r15
    4aaa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4aae: 49 31 d7                     	xorq	%rdx, %r15
    4ab1: 4d 89 dc                     	movq	%r11, %r12
    4ab4: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ab8: 4d 31 fc                     	xorq	%r15, %r12
    4abb: 4d 89 cf                     	movq	%r9, %r15
    4abe: 4d 09 c7                     	orq	%r8, %r15
    4ac1: 4d 21 df                     	andq	%r11, %r15
    4ac4: 4c 89 ca                     	movq	%r9, %rdx
    4ac7: 4c 21 c2                     	andq	%r8, %rdx
    4aca: 4c 09 fa                     	orq	%r15, %rdx
    4acd: 49 89 f7                     	movq	%rsi, %r15
    4ad0: 49 c1 c7 32                  	rolq	$0x32, %r15
    4ad4: 4c 01 e2                     	addq	%r12, %rdx
    4ad7: 49 89 f4                     	movq	%rsi, %r12
    4ada: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4ade: 4c 01 f2                     	addq	%r14, %rdx
    4ae1: 49 89 f6                     	movq	%rsi, %r14
    4ae4: 49 c1 c6 17                  	rolq	$0x17, %r14
    4ae8: 4d 31 fc                     	xorq	%r15, %r12
    4aeb: 4d 31 e6                     	xorq	%r12, %r14
    4aee: 49 89 df                     	movq	%rbx, %r15
    4af1: 4d 31 d7                     	xorq	%r10, %r15
    4af4: 49 21 f7                     	andq	%rsi, %r15
    4af7: 4d 31 d7                     	xorq	%r10, %r15
    4afa: 48 03 8d 70 fe ff ff         	addq	-0x190(%rbp), %rcx
    4b01: 4c 01 f9                     	addq	%r15, %rcx
    4b04: 49 bf df b3 95 9d 13 0d 38 53	movabsq	$0x53380d139d95b3df, %r15 # imm = 0x53380D139D95B3DF
    4b0e: 49 01 cf                     	addq	%rcx, %r15
    4b11: 4d 01 f7                     	addq	%r14, %r15
    4b14: 4d 01 f8                     	addq	%r15, %r8
    4b17: 48 89 d1                     	movq	%rdx, %rcx
    4b1a: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4b1e: 49 89 d6                     	movq	%rdx, %r14
    4b21: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4b25: 49 31 ce                     	xorq	%rcx, %r14
    4b28: 49 89 d4                     	movq	%rdx, %r12
    4b2b: 49 c1 c4 19                  	rolq	$0x19, %r12
    4b2f: 4d 31 f4                     	xorq	%r14, %r12
    4b32: 4d 89 de                     	movq	%r11, %r14
    4b35: 4d 09 ce                     	orq	%r9, %r14
    4b38: 49 21 d6                     	andq	%rdx, %r14
    4b3b: 4c 89 d9                     	movq	%r11, %rcx
    4b3e: 4c 21 c9                     	andq	%r9, %rcx
    4b41: 4c 09 f1                     	orq	%r14, %rcx
    4b44: 4c 01 e1                     	addq	%r12, %rcx
    4b47: 4c 01 f9                     	addq	%r15, %rcx
    4b4a: 4d 89 c6                     	movq	%r8, %r14
    4b4d: 49 c1 c6 32                  	rolq	$0x32, %r14
    4b51: 4d 89 c7                     	movq	%r8, %r15
    4b54: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4b58: 4d 31 f7                     	xorq	%r14, %r15
    4b5b: 4d 89 c4                     	movq	%r8, %r12
    4b5e: 49 c1 c4 17                  	rolq	$0x17, %r12
    4b62: 4d 31 fc                     	xorq	%r15, %r12
    4b65: 49 89 f6                     	movq	%rsi, %r14
    4b68: 49 31 de                     	xorq	%rbx, %r14
    4b6b: 4d 21 c6                     	andq	%r8, %r14
    4b6e: 4c 03 95 78 fe ff ff         	addq	-0x188(%rbp), %r10
    4b75: 49 31 de                     	xorq	%rbx, %r14
    4b78: 4d 01 f2                     	addq	%r14, %r10
    4b7b: 49 be de 63 af 8b 54 73 0a 65	movabsq	$0x650a73548baf63de, %r14 # imm = 0x650A73548BAF63DE
    4b85: 4d 01 d6                     	addq	%r10, %r14
    4b88: 4d 01 e6                     	addq	%r12, %r14
    4b8b: 49 89 ca                     	movq	%rcx, %r10
    4b8e: 49 c1 c2 24                  	rolq	$0x24, %r10
    4b92: 4d 01 f1                     	addq	%r14, %r9
    4b95: 49 89 cf                     	movq	%rcx, %r15
    4b98: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4b9c: 4d 31 d7                     	xorq	%r10, %r15
    4b9f: 49 89 cc                     	movq	%rcx, %r12
    4ba2: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ba6: 4d 31 fc                     	xorq	%r15, %r12
    4ba9: 49 89 d7                     	movq	%rdx, %r15
    4bac: 4d 09 df                     	orq	%r11, %r15
    4baf: 49 21 cf                     	andq	%rcx, %r15
    4bb2: 49 89 d2                     	movq	%rdx, %r10
    4bb5: 4d 21 da                     	andq	%r11, %r10
    4bb8: 4d 09 fa                     	orq	%r15, %r10
    4bbb: 4d 01 e2                     	addq	%r12, %r10
    4bbe: 4d 01 f2                     	addq	%r14, %r10
    4bc1: 4d 89 ce                     	movq	%r9, %r14
    4bc4: 49 c1 c6 32                  	rolq	$0x32, %r14
    4bc8: 4d 89 cf                     	movq	%r9, %r15
    4bcb: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4bcf: 4d 31 f7                     	xorq	%r14, %r15
    4bd2: 4d 89 cc                     	movq	%r9, %r12
    4bd5: 49 c1 c4 17                  	rolq	$0x17, %r12
    4bd9: 4d 31 fc                     	xorq	%r15, %r12
    4bdc: 4d 89 c6                     	movq	%r8, %r14
    4bdf: 49 31 f6                     	xorq	%rsi, %r14
    4be2: 4d 21 ce                     	andq	%r9, %r14
    4be5: 49 31 f6                     	xorq	%rsi, %r14
    4be8: 48 03 9d 80 fe ff ff         	addq	-0x180(%rbp), %rbx
    4bef: 4c 01 f3                     	addq	%r14, %rbx
    4bf2: 49 be a8 b2 77 3c bb 0a 6a 76	movabsq	$0x766a0abb3c77b2a8, %r14 # imm = 0x766A0ABB3C77B2A8
    4bfc: 49 01 de                     	addq	%rbx, %r14
    4bff: 4c 89 d3                     	movq	%r10, %rbx
    4c02: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4c06: 4d 01 e6                     	addq	%r12, %r14
    4c09: 4d 89 d7                     	movq	%r10, %r15
    4c0c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4c10: 4d 01 f3                     	addq	%r14, %r11
    4c13: 4d 89 d4                     	movq	%r10, %r12
    4c16: 49 c1 c4 19                  	rolq	$0x19, %r12
    4c1a: 49 31 df                     	xorq	%rbx, %r15
    4c1d: 4d 31 fc                     	xorq	%r15, %r12
    4c20: 49 89 cf                     	movq	%rcx, %r15
    4c23: 49 09 d7                     	orq	%rdx, %r15
    4c26: 4d 21 d7                     	andq	%r10, %r15
    4c29: 48 89 cb                     	movq	%rcx, %rbx
    4c2c: 48 21 d3                     	andq	%rdx, %rbx
    4c2f: 4c 09 fb                     	orq	%r15, %rbx
    4c32: 4c 01 e3                     	addq	%r12, %rbx
    4c35: 4d 89 df                     	movq	%r11, %r15
    4c38: 49 c1 c7 32                  	rolq	$0x32, %r15
    4c3c: 4c 01 f3                     	addq	%r14, %rbx
    4c3f: 4d 89 de                     	movq	%r11, %r14
    4c42: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4c46: 4d 31 fe                     	xorq	%r15, %r14
    4c49: 4d 89 df                     	movq	%r11, %r15
    4c4c: 49 c1 c7 17                  	rolq	$0x17, %r15
    4c50: 4d 31 f7                     	xorq	%r14, %r15
    4c53: 4d 89 ce                     	movq	%r9, %r14
    4c56: 4d 31 c6                     	xorq	%r8, %r14
    4c59: 4d 21 de                     	andq	%r11, %r14
    4c5c: 4d 31 c6                     	xorq	%r8, %r14
    4c5f: 48 03 b5 88 fe ff ff         	addq	-0x178(%rbp), %rsi
    4c66: 4c 01 f6                     	addq	%r14, %rsi
    4c69: 49 be e6 ae ed 47 2e c9 c2 81	movabsq	$-0x7e3d36d1b812511a, %r14 # imm = 0x81C2C92E47EDAEE6
    4c73: 49 01 f6                     	addq	%rsi, %r14
    4c76: 4d 01 fe                     	addq	%r15, %r14
    4c79: 4c 01 f2                     	addq	%r14, %rdx
    4c7c: 48 89 de                     	movq	%rbx, %rsi
    4c7f: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4c83: 49 89 df                     	movq	%rbx, %r15
    4c86: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4c8a: 49 31 f7                     	xorq	%rsi, %r15
    4c8d: 49 89 dc                     	movq	%rbx, %r12
    4c90: 49 c1 c4 19                  	rolq	$0x19, %r12
    4c94: 4d 31 fc                     	xorq	%r15, %r12
    4c97: 4d 89 d7                     	movq	%r10, %r15
    4c9a: 49 09 cf                     	orq	%rcx, %r15
    4c9d: 49 21 df                     	andq	%rbx, %r15
    4ca0: 4c 89 d6                     	movq	%r10, %rsi
    4ca3: 48 21 ce                     	andq	%rcx, %rsi
    4ca6: 4c 09 fe                     	orq	%r15, %rsi
    4ca9: 49 89 d7                     	movq	%rdx, %r15
    4cac: 49 c1 c7 32                  	rolq	$0x32, %r15
    4cb0: 4c 01 e6                     	addq	%r12, %rsi
    4cb3: 49 89 d4                     	movq	%rdx, %r12
    4cb6: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4cba: 4c 01 f6                     	addq	%r14, %rsi
    4cbd: 49 89 d6                     	movq	%rdx, %r14
    4cc0: 49 c1 c6 17                  	rolq	$0x17, %r14
    4cc4: 4d 31 fc                     	xorq	%r15, %r12
    4cc7: 4d 31 e6                     	xorq	%r12, %r14
    4cca: 4d 89 df                     	movq	%r11, %r15
    4ccd: 4d 31 cf                     	xorq	%r9, %r15
    4cd0: 49 21 d7                     	andq	%rdx, %r15
    4cd3: 4d 31 cf                     	xorq	%r9, %r15
    4cd6: 4c 03 85 90 fe ff ff         	addq	-0x170(%rbp), %r8
    4cdd: 4d 01 f8                     	addq	%r15, %r8
    4ce0: 49 bf 3b 35 82 14 85 2c 72 92	movabsq	$-0x6d8dd37aeb7dcac5, %r15 # imm = 0x92722C851482353B
    4cea: 4d 01 c7                     	addq	%r8, %r15
    4ced: 4d 01 f7                     	addq	%r14, %r15
    4cf0: 4c 01 f9                     	addq	%r15, %rcx
    4cf3: 49 89 f0                     	movq	%rsi, %r8
    4cf6: 49 c1 c0 24                  	rolq	$0x24, %r8
    4cfa: 49 89 f6                     	movq	%rsi, %r14
    4cfd: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4d01: 4d 31 c6                     	xorq	%r8, %r14
    4d04: 49 89 f4                     	movq	%rsi, %r12
    4d07: 49 c1 c4 19                  	rolq	$0x19, %r12
    4d0b: 4d 31 f4                     	xorq	%r14, %r12
    4d0e: 49 89 de                     	movq	%rbx, %r14
    4d11: 4d 09 d6                     	orq	%r10, %r14
    4d14: 49 21 f6                     	andq	%rsi, %r14
    4d17: 49 89 d8                     	movq	%rbx, %r8
    4d1a: 4d 21 d0                     	andq	%r10, %r8
    4d1d: 4d 09 f0                     	orq	%r14, %r8
    4d20: 4d 01 e0                     	addq	%r12, %r8
    4d23: 4d 01 f8                     	addq	%r15, %r8
    4d26: 49 89 ce                     	movq	%rcx, %r14
    4d29: 49 c1 c6 32                  	rolq	$0x32, %r14
    4d2d: 49 89 cf                     	movq	%rcx, %r15
    4d30: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4d34: 4d 31 f7                     	xorq	%r14, %r15
    4d37: 49 89 cc                     	movq	%rcx, %r12
    4d3a: 49 c1 c4 17                  	rolq	$0x17, %r12
    4d3e: 4d 31 fc                     	xorq	%r15, %r12
    4d41: 49 89 d6                     	movq	%rdx, %r14
    4d44: 4d 31 de                     	xorq	%r11, %r14
    4d47: 49 21 ce                     	andq	%rcx, %r14
    4d4a: 4c 03 8d 98 fe ff ff         	addq	-0x168(%rbp), %r9
    4d51: 4d 31 de                     	xorq	%r11, %r14
    4d54: 4d 01 f1                     	addq	%r14, %r9
    4d57: 49 be 64 03 f1 4c a1 e8 bf a2	movabsq	$-0x5d40175eb30efc9c, %r14 # imm = 0xA2BFE8A14CF10364
    4d61: 4d 01 ce                     	addq	%r9, %r14
    4d64: 4d 01 e6                     	addq	%r12, %r14
    4d67: 4d 89 c1                     	movq	%r8, %r9
    4d6a: 49 c1 c1 24                  	rolq	$0x24, %r9
    4d6e: 4d 01 f2                     	addq	%r14, %r10
    4d71: 4d 89 c7                     	movq	%r8, %r15
    4d74: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4d78: 4d 31 cf                     	xorq	%r9, %r15
    4d7b: 4d 89 c4                     	movq	%r8, %r12
    4d7e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4d82: 4d 31 fc                     	xorq	%r15, %r12
    4d85: 49 89 f7                     	movq	%rsi, %r15
    4d88: 49 09 df                     	orq	%rbx, %r15
    4d8b: 4d 21 c7                     	andq	%r8, %r15
    4d8e: 49 89 f1                     	movq	%rsi, %r9
    4d91: 49 21 d9                     	andq	%rbx, %r9
    4d94: 4d 09 f9                     	orq	%r15, %r9
    4d97: 4d 01 e1                     	addq	%r12, %r9
    4d9a: 4d 01 f1                     	addq	%r14, %r9
    4d9d: 4d 89 d6                     	movq	%r10, %r14
    4da0: 49 c1 c6 32                  	rolq	$0x32, %r14
    4da4: 4d 89 d7                     	movq	%r10, %r15
    4da7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4dab: 4d 31 f7                     	xorq	%r14, %r15
    4dae: 4d 89 d4                     	movq	%r10, %r12
    4db1: 49 c1 c4 17                  	rolq	$0x17, %r12
    4db5: 4d 31 fc                     	xorq	%r15, %r12
    4db8: 49 89 ce                     	movq	%rcx, %r14
    4dbb: 49 31 d6                     	xorq	%rdx, %r14
    4dbe: 4d 21 d6                     	andq	%r10, %r14
    4dc1: 49 31 d6                     	xorq	%rdx, %r14
    4dc4: 4c 03 9d a0 fe ff ff         	addq	-0x160(%rbp), %r11
    4dcb: 4d 01 f3                     	addq	%r14, %r11
    4dce: 49 be 01 30 42 bc 4b 66 1a a8	movabsq	$-0x57e599b443bdcfff, %r14 # imm = 0xA81A664BBC423001
    4dd8: 4d 01 de                     	addq	%r11, %r14
    4ddb: 4d 89 cb                     	movq	%r9, %r11
    4dde: 49 c1 c3 24                  	rolq	$0x24, %r11
    4de2: 4d 01 e6                     	addq	%r12, %r14
    4de5: 4d 89 cf                     	movq	%r9, %r15
    4de8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4dec: 4c 01 f3                     	addq	%r14, %rbx
    4def: 4d 89 cc                     	movq	%r9, %r12
    4df2: 49 c1 c4 19                  	rolq	$0x19, %r12
    4df6: 4d 31 df                     	xorq	%r11, %r15
    4df9: 4d 31 fc                     	xorq	%r15, %r12
    4dfc: 4d 89 c7                     	movq	%r8, %r15
    4dff: 49 09 f7                     	orq	%rsi, %r15
    4e02: 4d 21 cf                     	andq	%r9, %r15
    4e05: 4d 89 c3                     	movq	%r8, %r11
    4e08: 49 21 f3                     	andq	%rsi, %r11
    4e0b: 4d 09 fb                     	orq	%r15, %r11
    4e0e: 4d 01 e3                     	addq	%r12, %r11
    4e11: 49 89 df                     	movq	%rbx, %r15
    4e14: 49 c1 c7 32                  	rolq	$0x32, %r15
    4e18: 4d 01 f3                     	addq	%r14, %r11
    4e1b: 49 89 de                     	movq	%rbx, %r14
    4e1e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4e22: 4d 31 fe                     	xorq	%r15, %r14
    4e25: 49 89 df                     	movq	%rbx, %r15
    4e28: 49 c1 c7 17                  	rolq	$0x17, %r15
    4e2c: 4d 31 f7                     	xorq	%r14, %r15
    4e2f: 4d 89 d6                     	movq	%r10, %r14
    4e32: 49 31 ce                     	xorq	%rcx, %r14
    4e35: 49 21 de                     	andq	%rbx, %r14
    4e38: 49 31 ce                     	xorq	%rcx, %r14
    4e3b: 48 03 95 a8 fe ff ff         	addq	-0x158(%rbp), %rdx
    4e42: 4c 01 f2                     	addq	%r14, %rdx
    4e45: 49 be 91 97 f8 d0 70 8b 4b c2	movabsq	$-0x3db4748f2f07686f, %r14 # imm = 0xC24B8B70D0F89791
    4e4f: 49 01 d6                     	addq	%rdx, %r14
    4e52: 4d 01 fe                     	addq	%r15, %r14
    4e55: 4c 01 f6                     	addq	%r14, %rsi
    4e58: 4c 89 da                     	movq	%r11, %rdx
    4e5b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4e5f: 4d 89 df                     	movq	%r11, %r15
    4e62: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4e66: 49 31 d7                     	xorq	%rdx, %r15
    4e69: 4d 89 dc                     	movq	%r11, %r12
    4e6c: 49 c1 c4 19                  	rolq	$0x19, %r12
    4e70: 4d 31 fc                     	xorq	%r15, %r12
    4e73: 4d 89 cf                     	movq	%r9, %r15
    4e76: 4d 09 c7                     	orq	%r8, %r15
    4e79: 4d 21 df                     	andq	%r11, %r15
    4e7c: 4c 89 ca                     	movq	%r9, %rdx
    4e7f: 4c 21 c2                     	andq	%r8, %rdx
    4e82: 4c 09 fa                     	orq	%r15, %rdx
    4e85: 49 89 f7                     	movq	%rsi, %r15
    4e88: 49 c1 c7 32                  	rolq	$0x32, %r15
    4e8c: 4c 01 e2                     	addq	%r12, %rdx
    4e8f: 49 89 f4                     	movq	%rsi, %r12
    4e92: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4e96: 4c 01 f2                     	addq	%r14, %rdx
    4e99: 49 89 f6                     	movq	%rsi, %r14
    4e9c: 49 c1 c6 17                  	rolq	$0x17, %r14
    4ea0: 4d 31 fc                     	xorq	%r15, %r12
    4ea3: 4d 31 e6                     	xorq	%r12, %r14
    4ea6: 49 89 df                     	movq	%rbx, %r15
    4ea9: 4d 31 d7                     	xorq	%r10, %r15
    4eac: 49 21 f7                     	andq	%rsi, %r15
    4eaf: 4d 31 d7                     	xorq	%r10, %r15
    4eb2: 48 03 8d b0 fe ff ff         	addq	-0x150(%rbp), %rcx
    4eb9: 4c 01 f9                     	addq	%r15, %rcx
    4ebc: 49 bf 30 be 54 06 a3 51 6c c7	movabsq	$-0x3893ae5cf9ab41d0, %r15 # imm = 0xC76C51A30654BE30
    4ec6: 49 01 cf                     	addq	%rcx, %r15
    4ec9: 4d 01 f7                     	addq	%r14, %r15
    4ecc: 4d 01 f8                     	addq	%r15, %r8
    4ecf: 48 89 d1                     	movq	%rdx, %rcx
    4ed2: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4ed6: 49 89 d6                     	movq	%rdx, %r14
    4ed9: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4edd: 49 31 ce                     	xorq	%rcx, %r14
    4ee0: 49 89 d4                     	movq	%rdx, %r12
    4ee3: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ee7: 4d 31 f4                     	xorq	%r14, %r12
    4eea: 4d 89 de                     	movq	%r11, %r14
    4eed: 4d 09 ce                     	orq	%r9, %r14
    4ef0: 49 21 d6                     	andq	%rdx, %r14
    4ef3: 4c 89 d9                     	movq	%r11, %rcx
    4ef6: 4c 21 c9                     	andq	%r9, %rcx
    4ef9: 4c 09 f1                     	orq	%r14, %rcx
    4efc: 4c 01 e1                     	addq	%r12, %rcx
    4eff: 4c 01 f9                     	addq	%r15, %rcx
    4f02: 4d 89 c6                     	movq	%r8, %r14
    4f05: 49 c1 c6 32                  	rolq	$0x32, %r14
    4f09: 4d 89 c7                     	movq	%r8, %r15
    4f0c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4f10: 4d 31 f7                     	xorq	%r14, %r15
    4f13: 4d 89 c4                     	movq	%r8, %r12
    4f16: 49 c1 c4 17                  	rolq	$0x17, %r12
    4f1a: 4d 31 fc                     	xorq	%r15, %r12
    4f1d: 49 89 f6                     	movq	%rsi, %r14
    4f20: 49 31 de                     	xorq	%rbx, %r14
    4f23: 4d 21 c6                     	andq	%r8, %r14
    4f26: 4c 03 95 b8 fe ff ff         	addq	-0x148(%rbp), %r10
    4f2d: 49 31 de                     	xorq	%rbx, %r14
    4f30: 4d 01 f2                     	addq	%r14, %r10
    4f33: 49 be 18 52 ef d6 19 e8 92 d1	movabsq	$-0x2e6d17e62910ade8, %r14 # imm = 0xD192E819D6EF5218
    4f3d: 4d 01 d6                     	addq	%r10, %r14
    4f40: 4d 01 e6                     	addq	%r12, %r14
    4f43: 49 89 ca                     	movq	%rcx, %r10
    4f46: 49 c1 c2 24                  	rolq	$0x24, %r10
    4f4a: 4d 01 f1                     	addq	%r14, %r9
    4f4d: 49 89 cf                     	movq	%rcx, %r15
    4f50: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4f54: 4d 31 d7                     	xorq	%r10, %r15
    4f57: 49 89 cc                     	movq	%rcx, %r12
    4f5a: 49 c1 c4 19                  	rolq	$0x19, %r12
    4f5e: 4d 31 fc                     	xorq	%r15, %r12
    4f61: 49 89 d7                     	movq	%rdx, %r15
    4f64: 4d 09 df                     	orq	%r11, %r15
    4f67: 49 21 cf                     	andq	%rcx, %r15
    4f6a: 49 89 d2                     	movq	%rdx, %r10
    4f6d: 4d 21 da                     	andq	%r11, %r10
    4f70: 4d 09 fa                     	orq	%r15, %r10
    4f73: 4d 01 e2                     	addq	%r12, %r10
    4f76: 4d 01 f2                     	addq	%r14, %r10
    4f79: 4d 89 ce                     	movq	%r9, %r14
    4f7c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4f80: 4d 89 cf                     	movq	%r9, %r15
    4f83: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4f87: 4d 31 f7                     	xorq	%r14, %r15
    4f8a: 4d 89 cc                     	movq	%r9, %r12
    4f8d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4f91: 4d 31 fc                     	xorq	%r15, %r12
    4f94: 4d 89 c6                     	movq	%r8, %r14
    4f97: 49 31 f6                     	xorq	%rsi, %r14
    4f9a: 4d 21 ce                     	andq	%r9, %r14
    4f9d: 49 31 f6                     	xorq	%rsi, %r14
    4fa0: 48 03 9d c0 fe ff ff         	addq	-0x140(%rbp), %rbx
    4fa7: 4c 01 f3                     	addq	%r14, %rbx
    4faa: 49 be 10 a9 65 55 24 06 99 d6	movabsq	$-0x2966f9dbaa9a56f0, %r14 # imm = 0xD69906245565A910
    4fb4: 49 01 de                     	addq	%rbx, %r14
    4fb7: 4c 89 d3                     	movq	%r10, %rbx
    4fba: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4fbe: 4d 01 e6                     	addq	%r12, %r14
    4fc1: 4d 89 d7                     	movq	%r10, %r15
    4fc4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4fc8: 4d 01 f3                     	addq	%r14, %r11
    4fcb: 4d 89 d4                     	movq	%r10, %r12
    4fce: 49 c1 c4 19                  	rolq	$0x19, %r12
    4fd2: 49 31 df                     	xorq	%rbx, %r15
    4fd5: 4d 31 fc                     	xorq	%r15, %r12
    4fd8: 49 89 cf                     	movq	%rcx, %r15
    4fdb: 49 09 d7                     	orq	%rdx, %r15
    4fde: 4d 21 d7                     	andq	%r10, %r15
    4fe1: 48 89 cb                     	movq	%rcx, %rbx
    4fe4: 48 21 d3                     	andq	%rdx, %rbx
    4fe7: 4c 09 fb                     	orq	%r15, %rbx
    4fea: 4c 01 e3                     	addq	%r12, %rbx
    4fed: 4d 89 df                     	movq	%r11, %r15
    4ff0: 49 c1 c7 32                  	rolq	$0x32, %r15
    4ff4: 4c 01 f3                     	addq	%r14, %rbx
    4ff7: 4d 89 de                     	movq	%r11, %r14
    4ffa: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4ffe: 4d 31 fe                     	xorq	%r15, %r14
    5001: 4d 89 df                     	movq	%r11, %r15
    5004: 49 c1 c7 17                  	rolq	$0x17, %r15
    5008: 4d 31 f7                     	xorq	%r14, %r15
    500b: 4d 89 ce                     	movq	%r9, %r14
    500e: 4d 31 c6                     	xorq	%r8, %r14
    5011: 4d 21 de                     	andq	%r11, %r14
    5014: 4d 31 c6                     	xorq	%r8, %r14
    5017: 48 03 b5 c8 fe ff ff         	addq	-0x138(%rbp), %rsi
    501e: 4c 01 f6                     	addq	%r14, %rsi
    5021: 49 be 2a 20 71 57 85 35 0e f4	movabsq	$-0xbf1ca7aa88edfd6, %r14 # imm = 0xF40E35855771202A
    502b: 49 01 f6                     	addq	%rsi, %r14
    502e: 4d 01 fe                     	addq	%r15, %r14
    5031: 4c 01 f2                     	addq	%r14, %rdx
    5034: 48 89 de                     	movq	%rbx, %rsi
    5037: 48 c1 c6 24                  	rolq	$0x24, %rsi
    503b: 49 89 df                     	movq	%rbx, %r15
    503e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5042: 49 31 f7                     	xorq	%rsi, %r15
    5045: 49 89 dc                     	movq	%rbx, %r12
    5048: 49 c1 c4 19                  	rolq	$0x19, %r12
    504c: 4d 31 fc                     	xorq	%r15, %r12
    504f: 4d 89 d7                     	movq	%r10, %r15
    5052: 49 09 cf                     	orq	%rcx, %r15
    5055: 49 21 df                     	andq	%rbx, %r15
    5058: 4c 89 d6                     	movq	%r10, %rsi
    505b: 48 21 ce                     	andq	%rcx, %rsi
    505e: 4c 09 fe                     	orq	%r15, %rsi
    5061: 49 89 d7                     	movq	%rdx, %r15
    5064: 49 c1 c7 32                  	rolq	$0x32, %r15
    5068: 4c 01 e6                     	addq	%r12, %rsi
    506b: 49 89 d4                     	movq	%rdx, %r12
    506e: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5072: 4c 01 f6                     	addq	%r14, %rsi
    5075: 49 89 d6                     	movq	%rdx, %r14
    5078: 49 c1 c6 17                  	rolq	$0x17, %r14
    507c: 4d 31 fc                     	xorq	%r15, %r12
    507f: 4d 31 e6                     	xorq	%r12, %r14
    5082: 4d 89 df                     	movq	%r11, %r15
    5085: 4d 31 cf                     	xorq	%r9, %r15
    5088: 49 21 d7                     	andq	%rdx, %r15
    508b: 4d 31 cf                     	xorq	%r9, %r15
    508e: 4c 03 85 d0 fe ff ff         	addq	-0x130(%rbp), %r8
    5095: 4d 01 f8                     	addq	%r15, %r8
    5098: 49 bf b8 d1 bb 32 70 a0 6a 10	movabsq	$0x106aa07032bbd1b8, %r15 # imm = 0x106AA07032BBD1B8
    50a2: 4d 01 c7                     	addq	%r8, %r15
    50a5: 4d 01 f7                     	addq	%r14, %r15
    50a8: 4c 01 f9                     	addq	%r15, %rcx
    50ab: 49 89 f0                     	movq	%rsi, %r8
    50ae: 49 c1 c0 24                  	rolq	$0x24, %r8
    50b2: 49 89 f6                     	movq	%rsi, %r14
    50b5: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    50b9: 4d 31 c6                     	xorq	%r8, %r14
    50bc: 49 89 f4                     	movq	%rsi, %r12
    50bf: 49 c1 c4 19                  	rolq	$0x19, %r12
    50c3: 4d 31 f4                     	xorq	%r14, %r12
    50c6: 49 89 de                     	movq	%rbx, %r14
    50c9: 4d 09 d6                     	orq	%r10, %r14
    50cc: 49 21 f6                     	andq	%rsi, %r14
    50cf: 49 89 d8                     	movq	%rbx, %r8
    50d2: 4d 21 d0                     	andq	%r10, %r8
    50d5: 4d 09 f0                     	orq	%r14, %r8
    50d8: 4d 01 e0                     	addq	%r12, %r8
    50db: 4d 01 f8                     	addq	%r15, %r8
    50de: 49 89 ce                     	movq	%rcx, %r14
    50e1: 49 c1 c6 32                  	rolq	$0x32, %r14
    50e5: 49 89 cf                     	movq	%rcx, %r15
    50e8: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    50ec: 4d 31 f7                     	xorq	%r14, %r15
    50ef: 49 89 cc                     	movq	%rcx, %r12
    50f2: 49 c1 c4 17                  	rolq	$0x17, %r12
    50f6: 4d 31 fc                     	xorq	%r15, %r12
    50f9: 49 89 d6                     	movq	%rdx, %r14
    50fc: 4d 31 de                     	xorq	%r11, %r14
    50ff: 49 21 ce                     	andq	%rcx, %r14
    5102: 4c 03 8d d8 fe ff ff         	addq	-0x128(%rbp), %r9
    5109: 4d 31 de                     	xorq	%r11, %r14
    510c: 4d 01 f1                     	addq	%r14, %r9
    510f: 49 be c8 d0 d2 b8 16 c1 a4 19	movabsq	$0x19a4c116b8d2d0c8, %r14 # imm = 0x19A4C116B8D2D0C8
    5119: 4d 01 ce                     	addq	%r9, %r14
    511c: 4d 01 e6                     	addq	%r12, %r14
    511f: 4d 89 c1                     	movq	%r8, %r9
    5122: 49 c1 c1 24                  	rolq	$0x24, %r9
    5126: 4d 01 f2                     	addq	%r14, %r10
    5129: 4d 89 c7                     	movq	%r8, %r15
    512c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5130: 4d 31 cf                     	xorq	%r9, %r15
    5133: 4d 89 c4                     	movq	%r8, %r12
    5136: 49 c1 c4 19                  	rolq	$0x19, %r12
    513a: 4d 31 fc                     	xorq	%r15, %r12
    513d: 49 89 f7                     	movq	%rsi, %r15
    5140: 49 09 df                     	orq	%rbx, %r15
    5143: 4d 21 c7                     	andq	%r8, %r15
    5146: 49 89 f1                     	movq	%rsi, %r9
    5149: 49 21 d9                     	andq	%rbx, %r9
    514c: 4d 09 f9                     	orq	%r15, %r9
    514f: 4d 01 e1                     	addq	%r12, %r9
    5152: 4d 01 f1                     	addq	%r14, %r9
    5155: 4d 89 d6                     	movq	%r10, %r14
    5158: 49 c1 c6 32                  	rolq	$0x32, %r14
    515c: 4d 89 d7                     	movq	%r10, %r15
    515f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5163: 4d 31 f7                     	xorq	%r14, %r15
    5166: 4d 89 d4                     	movq	%r10, %r12
    5169: 49 c1 c4 17                  	rolq	$0x17, %r12
    516d: 4d 31 fc                     	xorq	%r15, %r12
    5170: 49 89 ce                     	movq	%rcx, %r14
    5173: 49 31 d6                     	xorq	%rdx, %r14
    5176: 4d 21 d6                     	andq	%r10, %r14
    5179: 49 31 d6                     	xorq	%rdx, %r14
    517c: 4c 03 9d e0 fe ff ff         	addq	-0x120(%rbp), %r11
    5183: 4d 01 f3                     	addq	%r14, %r11
    5186: 49 be 53 ab 41 51 08 6c 37 1e	movabsq	$0x1e376c085141ab53, %r14 # imm = 0x1E376C085141AB53
    5190: 4d 01 de                     	addq	%r11, %r14
    5193: 4d 89 cb                     	movq	%r9, %r11
    5196: 49 c1 c3 24                  	rolq	$0x24, %r11
    519a: 4d 01 e6                     	addq	%r12, %r14
    519d: 4d 89 cf                     	movq	%r9, %r15
    51a0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    51a4: 4c 01 f3                     	addq	%r14, %rbx
    51a7: 4d 89 cc                     	movq	%r9, %r12
    51aa: 49 c1 c4 19                  	rolq	$0x19, %r12
    51ae: 4d 31 df                     	xorq	%r11, %r15
    51b1: 4d 31 fc                     	xorq	%r15, %r12
    51b4: 4d 89 c7                     	movq	%r8, %r15
    51b7: 49 09 f7                     	orq	%rsi, %r15
    51ba: 4d 21 cf                     	andq	%r9, %r15
    51bd: 4d 89 c3                     	movq	%r8, %r11
    51c0: 49 21 f3                     	andq	%rsi, %r11
    51c3: 4d 09 fb                     	orq	%r15, %r11
    51c6: 4d 01 e3                     	addq	%r12, %r11
    51c9: 49 89 df                     	movq	%rbx, %r15
    51cc: 49 c1 c7 32                  	rolq	$0x32, %r15
    51d0: 4d 01 f3                     	addq	%r14, %r11
    51d3: 49 89 de                     	movq	%rbx, %r14
    51d6: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    51da: 4d 31 fe                     	xorq	%r15, %r14
    51dd: 49 89 df                     	movq	%rbx, %r15
    51e0: 49 c1 c7 17                  	rolq	$0x17, %r15
    51e4: 4d 31 f7                     	xorq	%r14, %r15
    51e7: 4d 89 d6                     	movq	%r10, %r14
    51ea: 49 31 ce                     	xorq	%rcx, %r14
    51ed: 49 21 de                     	andq	%rbx, %r14
    51f0: 49 31 ce                     	xorq	%rcx, %r14
    51f3: 48 03 95 e8 fe ff ff         	addq	-0x118(%rbp), %rdx
    51fa: 4c 01 f2                     	addq	%r14, %rdx
    51fd: 49 be 99 eb 8e df 4c 77 48 27	movabsq	$0x2748774cdf8eeb99, %r14 # imm = 0x2748774CDF8EEB99
    5207: 49 01 d6                     	addq	%rdx, %r14
    520a: 4d 01 fe                     	addq	%r15, %r14
    520d: 4c 01 f6                     	addq	%r14, %rsi
    5210: 4c 89 da                     	movq	%r11, %rdx
    5213: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5217: 4d 89 df                     	movq	%r11, %r15
    521a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    521e: 49 31 d7                     	xorq	%rdx, %r15
    5221: 4d 89 dc                     	movq	%r11, %r12
    5224: 49 c1 c4 19                  	rolq	$0x19, %r12
    5228: 4d 31 fc                     	xorq	%r15, %r12
    522b: 4d 89 cf                     	movq	%r9, %r15
    522e: 4d 09 c7                     	orq	%r8, %r15
    5231: 4d 21 df                     	andq	%r11, %r15
    5234: 4c 89 ca                     	movq	%r9, %rdx
    5237: 4c 21 c2                     	andq	%r8, %rdx
    523a: 4c 09 fa                     	orq	%r15, %rdx
    523d: 49 89 f7                     	movq	%rsi, %r15
    5240: 49 c1 c7 32                  	rolq	$0x32, %r15
    5244: 4c 01 e2                     	addq	%r12, %rdx
    5247: 49 89 f4                     	movq	%rsi, %r12
    524a: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    524e: 4c 01 f2                     	addq	%r14, %rdx
    5251: 49 89 f6                     	movq	%rsi, %r14
    5254: 49 c1 c6 17                  	rolq	$0x17, %r14
    5258: 4d 31 fc                     	xorq	%r15, %r12
    525b: 4d 31 e6                     	xorq	%r12, %r14
    525e: 49 89 df                     	movq	%rbx, %r15
    5261: 4d 31 d7                     	xorq	%r10, %r15
    5264: 49 21 f7                     	andq	%rsi, %r15
    5267: 4d 31 d7                     	xorq	%r10, %r15
    526a: 48 03 8d f0 fe ff ff         	addq	-0x110(%rbp), %rcx
    5271: 4c 01 f9                     	addq	%r15, %rcx
    5274: 49 bf a8 48 9b e1 b5 bc b0 34	movabsq	$0x34b0bcb5e19b48a8, %r15 # imm = 0x34B0BCB5E19B48A8
    527e: 49 01 cf                     	addq	%rcx, %r15
    5281: 4d 01 f7                     	addq	%r14, %r15
    5284: 4d 01 f8                     	addq	%r15, %r8
    5287: 48 89 d1                     	movq	%rdx, %rcx
    528a: 48 c1 c1 24                  	rolq	$0x24, %rcx
    528e: 49 89 d6                     	movq	%rdx, %r14
    5291: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5295: 49 31 ce                     	xorq	%rcx, %r14
    5298: 49 89 d4                     	movq	%rdx, %r12
    529b: 49 c1 c4 19                  	rolq	$0x19, %r12
    529f: 4d 31 f4                     	xorq	%r14, %r12
    52a2: 4d 89 de                     	movq	%r11, %r14
    52a5: 4d 09 ce                     	orq	%r9, %r14
    52a8: 49 21 d6                     	andq	%rdx, %r14
    52ab: 4c 89 d9                     	movq	%r11, %rcx
    52ae: 4c 21 c9                     	andq	%r9, %rcx
    52b1: 4c 09 f1                     	orq	%r14, %rcx
    52b4: 4c 01 e1                     	addq	%r12, %rcx
    52b7: 4c 01 f9                     	addq	%r15, %rcx
    52ba: 4d 89 c6                     	movq	%r8, %r14
    52bd: 49 c1 c6 32                  	rolq	$0x32, %r14
    52c1: 4d 89 c7                     	movq	%r8, %r15
    52c4: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    52c8: 4d 31 f7                     	xorq	%r14, %r15
    52cb: 4d 89 c4                     	movq	%r8, %r12
    52ce: 49 c1 c4 17                  	rolq	$0x17, %r12
    52d2: 4d 31 fc                     	xorq	%r15, %r12
    52d5: 49 89 f6                     	movq	%rsi, %r14
    52d8: 49 31 de                     	xorq	%rbx, %r14
    52db: 4d 21 c6                     	andq	%r8, %r14
    52de: 4c 03 95 f8 fe ff ff         	addq	-0x108(%rbp), %r10
    52e5: 49 31 de                     	xorq	%rbx, %r14
    52e8: 4d 01 f2                     	addq	%r14, %r10
    52eb: 49 be 63 5a c9 c5 b3 0c 1c 39	movabsq	$0x391c0cb3c5c95a63, %r14 # imm = 0x391C0CB3C5C95A63
    52f5: 4d 01 d6                     	addq	%r10, %r14
    52f8: 4d 01 e6                     	addq	%r12, %r14
    52fb: 49 89 ca                     	movq	%rcx, %r10
    52fe: 49 c1 c2 24                  	rolq	$0x24, %r10
    5302: 4d 01 f1                     	addq	%r14, %r9
    5305: 49 89 cf                     	movq	%rcx, %r15
    5308: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    530c: 4d 31 d7                     	xorq	%r10, %r15
    530f: 49 89 cc                     	movq	%rcx, %r12
    5312: 49 c1 c4 19                  	rolq	$0x19, %r12
    5316: 4d 31 fc                     	xorq	%r15, %r12
    5319: 49 89 d7                     	movq	%rdx, %r15
    531c: 4d 09 df                     	orq	%r11, %r15
    531f: 49 21 cf                     	andq	%rcx, %r15
    5322: 49 89 d2                     	movq	%rdx, %r10
    5325: 4d 21 da                     	andq	%r11, %r10
    5328: 4d 09 fa                     	orq	%r15, %r10
    532b: 4d 01 e2                     	addq	%r12, %r10
    532e: 4d 01 f2                     	addq	%r14, %r10
    5331: 4d 89 ce                     	movq	%r9, %r14
    5334: 49 c1 c6 32                  	rolq	$0x32, %r14
    5338: 4d 89 cf                     	movq	%r9, %r15
    533b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    533f: 4d 31 f7                     	xorq	%r14, %r15
    5342: 4d 89 cc                     	movq	%r9, %r12
    5345: 49 c1 c4 17                  	rolq	$0x17, %r12
    5349: 4d 31 fc                     	xorq	%r15, %r12
    534c: 4d 89 c6                     	movq	%r8, %r14
    534f: 49 31 f6                     	xorq	%rsi, %r14
    5352: 4d 21 ce                     	andq	%r9, %r14
    5355: 49 31 f6                     	xorq	%rsi, %r14
    5358: 48 03 9d 00 ff ff ff         	addq	-0x100(%rbp), %rbx
    535f: 4c 01 f3                     	addq	%r14, %rbx
    5362: 49 be cb 8a 41 e3 4a aa d8 4e	movabsq	$0x4ed8aa4ae3418acb, %r14 # imm = 0x4ED8AA4AE3418ACB
    536c: 49 01 de                     	addq	%rbx, %r14
    536f: 4c 89 d3                     	movq	%r10, %rbx
    5372: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5376: 4d 01 e6                     	addq	%r12, %r14
    5379: 4d 89 d7                     	movq	%r10, %r15
    537c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5380: 4d 01 f3                     	addq	%r14, %r11
    5383: 4d 89 d4                     	movq	%r10, %r12
    5386: 49 c1 c4 19                  	rolq	$0x19, %r12
    538a: 49 31 df                     	xorq	%rbx, %r15
    538d: 4d 31 fc                     	xorq	%r15, %r12
    5390: 49 89 cf                     	movq	%rcx, %r15
    5393: 49 09 d7                     	orq	%rdx, %r15
    5396: 4d 21 d7                     	andq	%r10, %r15
    5399: 48 89 cb                     	movq	%rcx, %rbx
    539c: 48 21 d3                     	andq	%rdx, %rbx
    539f: 4c 09 fb                     	orq	%r15, %rbx
    53a2: 4c 01 e3                     	addq	%r12, %rbx
    53a5: 4d 89 df                     	movq	%r11, %r15
    53a8: 49 c1 c7 32                  	rolq	$0x32, %r15
    53ac: 4c 01 f3                     	addq	%r14, %rbx
    53af: 4d 89 de                     	movq	%r11, %r14
    53b2: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    53b6: 4d 31 fe                     	xorq	%r15, %r14
    53b9: 4d 89 df                     	movq	%r11, %r15
    53bc: 49 c1 c7 17                  	rolq	$0x17, %r15
    53c0: 4d 31 f7                     	xorq	%r14, %r15
    53c3: 4d 89 ce                     	movq	%r9, %r14
    53c6: 4d 31 c6                     	xorq	%r8, %r14
    53c9: 4d 21 de                     	andq	%r11, %r14
    53cc: 4d 31 c6                     	xorq	%r8, %r14
    53cf: 48 03 b5 08 ff ff ff         	addq	-0xf8(%rbp), %rsi
    53d6: 4c 01 f6                     	addq	%r14, %rsi
    53d9: 49 be 73 e3 63 77 4f ca 9c 5b	movabsq	$0x5b9cca4f7763e373, %r14 # imm = 0x5B9CCA4F7763E373
    53e3: 49 01 f6                     	addq	%rsi, %r14
    53e6: 4d 01 fe                     	addq	%r15, %r14
    53e9: 4c 01 f2                     	addq	%r14, %rdx
    53ec: 48 89 de                     	movq	%rbx, %rsi
    53ef: 48 c1 c6 24                  	rolq	$0x24, %rsi
    53f3: 49 89 df                     	movq	%rbx, %r15
    53f6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    53fa: 49 31 f7                     	xorq	%rsi, %r15
    53fd: 49 89 dc                     	movq	%rbx, %r12
    5400: 49 c1 c4 19                  	rolq	$0x19, %r12
    5404: 4d 31 fc                     	xorq	%r15, %r12
    5407: 4d 89 d7                     	movq	%r10, %r15
    540a: 49 09 cf                     	orq	%rcx, %r15
    540d: 49 21 df                     	andq	%rbx, %r15
    5410: 4c 89 d6                     	movq	%r10, %rsi
    5413: 48 21 ce                     	andq	%rcx, %rsi
    5416: 4c 09 fe                     	orq	%r15, %rsi
    5419: 49 89 d7                     	movq	%rdx, %r15
    541c: 49 c1 c7 32                  	rolq	$0x32, %r15
    5420: 4c 01 e6                     	addq	%r12, %rsi
    5423: 49 89 d4                     	movq	%rdx, %r12
    5426: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    542a: 4c 01 f6                     	addq	%r14, %rsi
    542d: 49 89 d6                     	movq	%rdx, %r14
    5430: 49 c1 c6 17                  	rolq	$0x17, %r14
    5434: 4d 31 fc                     	xorq	%r15, %r12
    5437: 4d 31 e6                     	xorq	%r12, %r14
    543a: 4d 89 df                     	movq	%r11, %r15
    543d: 4d 31 cf                     	xorq	%r9, %r15
    5440: 49 21 d7                     	andq	%rdx, %r15
    5443: 4d 31 cf                     	xorq	%r9, %r15
    5446: 4c 03 85 10 ff ff ff         	addq	-0xf0(%rbp), %r8
    544d: 4d 01 f8                     	addq	%r15, %r8
    5450: 49 bf a3 b8 b2 d6 f3 6f 2e 68	movabsq	$0x682e6ff3d6b2b8a3, %r15 # imm = 0x682E6FF3D6B2B8A3
    545a: 4d 01 c7                     	addq	%r8, %r15
    545d: 4d 01 f7                     	addq	%r14, %r15
    5460: 4c 01 f9                     	addq	%r15, %rcx
    5463: 49 89 f0                     	movq	%rsi, %r8
    5466: 49 c1 c0 24                  	rolq	$0x24, %r8
    546a: 49 89 f6                     	movq	%rsi, %r14
    546d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5471: 4d 31 c6                     	xorq	%r8, %r14
    5474: 49 89 f4                     	movq	%rsi, %r12
    5477: 49 c1 c4 19                  	rolq	$0x19, %r12
    547b: 4d 31 f4                     	xorq	%r14, %r12
    547e: 49 89 de                     	movq	%rbx, %r14
    5481: 4d 09 d6                     	orq	%r10, %r14
    5484: 49 21 f6                     	andq	%rsi, %r14
    5487: 49 89 d8                     	movq	%rbx, %r8
    548a: 4d 21 d0                     	andq	%r10, %r8
    548d: 4d 09 f0                     	orq	%r14, %r8
    5490: 4d 01 e0                     	addq	%r12, %r8
    5493: 4d 01 f8                     	addq	%r15, %r8
    5496: 49 89 ce                     	movq	%rcx, %r14
    5499: 49 c1 c6 32                  	rolq	$0x32, %r14
    549d: 49 89 cf                     	movq	%rcx, %r15
    54a0: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    54a4: 4d 31 f7                     	xorq	%r14, %r15
    54a7: 49 89 cc                     	movq	%rcx, %r12
    54aa: 49 c1 c4 17                  	rolq	$0x17, %r12
    54ae: 4d 31 fc                     	xorq	%r15, %r12
    54b1: 49 89 d6                     	movq	%rdx, %r14
    54b4: 4d 31 de                     	xorq	%r11, %r14
    54b7: 49 21 ce                     	andq	%rcx, %r14
    54ba: 4c 03 8d 18 ff ff ff         	addq	-0xe8(%rbp), %r9
    54c1: 4d 31 de                     	xorq	%r11, %r14
    54c4: 4d 01 f1                     	addq	%r14, %r9
    54c7: 49 be fc b2 ef 5d ee 82 8f 74	movabsq	$0x748f82ee5defb2fc, %r14 # imm = 0x748F82EE5DEFB2FC
    54d1: 4d 01 ce                     	addq	%r9, %r14
    54d4: 4d 01 e6                     	addq	%r12, %r14
    54d7: 4d 89 c1                     	movq	%r8, %r9
    54da: 49 c1 c1 24                  	rolq	$0x24, %r9
    54de: 4d 01 f2                     	addq	%r14, %r10
    54e1: 4d 89 c7                     	movq	%r8, %r15
    54e4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    54e8: 4d 31 cf                     	xorq	%r9, %r15
    54eb: 4d 89 c4                     	movq	%r8, %r12
    54ee: 49 c1 c4 19                  	rolq	$0x19, %r12
    54f2: 4d 31 fc                     	xorq	%r15, %r12
    54f5: 49 89 f7                     	movq	%rsi, %r15
    54f8: 49 09 df                     	orq	%rbx, %r15
    54fb: 4d 21 c7                     	andq	%r8, %r15
    54fe: 49 89 f1                     	movq	%rsi, %r9
    5501: 49 21 d9                     	andq	%rbx, %r9
    5504: 4d 09 f9                     	orq	%r15, %r9
    5507: 4d 01 e1                     	addq	%r12, %r9
    550a: 4d 01 f1                     	addq	%r14, %r9
    550d: 4d 89 d6                     	movq	%r10, %r14
    5510: 49 c1 c6 32                  	rolq	$0x32, %r14
    5514: 4d 89 d7                     	movq	%r10, %r15
    5517: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    551b: 4d 31 f7                     	xorq	%r14, %r15
    551e: 4d 89 d4                     	movq	%r10, %r12
    5521: 49 c1 c4 17                  	rolq	$0x17, %r12
    5525: 4d 31 fc                     	xorq	%r15, %r12
    5528: 49 89 ce                     	movq	%rcx, %r14
    552b: 49 31 d6                     	xorq	%rdx, %r14
    552e: 4d 21 d6                     	andq	%r10, %r14
    5531: 49 31 d6                     	xorq	%rdx, %r14
    5534: 4c 03 9d 20 ff ff ff         	addq	-0xe0(%rbp), %r11
    553b: 4d 01 f3                     	addq	%r14, %r11
    553e: 49 be 60 2f 17 43 6f 63 a5 78	movabsq	$0x78a5636f43172f60, %r14 # imm = 0x78A5636F43172F60
    5548: 4d 01 de                     	addq	%r11, %r14
    554b: 4d 89 cb                     	movq	%r9, %r11
    554e: 49 c1 c3 24                  	rolq	$0x24, %r11
    5552: 4d 01 e6                     	addq	%r12, %r14
    5555: 4d 89 cf                     	movq	%r9, %r15
    5558: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    555c: 4c 01 f3                     	addq	%r14, %rbx
    555f: 4d 89 cc                     	movq	%r9, %r12
    5562: 49 c1 c4 19                  	rolq	$0x19, %r12
    5566: 4d 31 df                     	xorq	%r11, %r15
    5569: 4d 31 fc                     	xorq	%r15, %r12
    556c: 4d 89 c7                     	movq	%r8, %r15
    556f: 49 09 f7                     	orq	%rsi, %r15
    5572: 4d 21 cf                     	andq	%r9, %r15
    5575: 4d 89 c3                     	movq	%r8, %r11
    5578: 49 21 f3                     	andq	%rsi, %r11
    557b: 4d 09 fb                     	orq	%r15, %r11
    557e: 4d 01 e3                     	addq	%r12, %r11
    5581: 49 89 df                     	movq	%rbx, %r15
    5584: 49 c1 c7 32                  	rolq	$0x32, %r15
    5588: 4d 01 f3                     	addq	%r14, %r11
    558b: 49 89 de                     	movq	%rbx, %r14
    558e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5592: 4d 31 fe                     	xorq	%r15, %r14
    5595: 49 89 df                     	movq	%rbx, %r15
    5598: 49 c1 c7 17                  	rolq	$0x17, %r15
    559c: 4d 31 f7                     	xorq	%r14, %r15
    559f: 4d 89 d6                     	movq	%r10, %r14
    55a2: 49 31 ce                     	xorq	%rcx, %r14
    55a5: 49 21 de                     	andq	%rbx, %r14
    55a8: 49 31 ce                     	xorq	%rcx, %r14
    55ab: 48 03 95 28 ff ff ff         	addq	-0xd8(%rbp), %rdx
    55b2: 4c 01 f2                     	addq	%r14, %rdx
    55b5: 49 be 72 ab f0 a1 14 78 c8 84	movabsq	$-0x7b3787eb5e0f548e, %r14 # imm = 0x84C87814A1F0AB72
    55bf: 49 01 d6                     	addq	%rdx, %r14
    55c2: 4d 01 fe                     	addq	%r15, %r14
    55c5: 4c 01 f6                     	addq	%r14, %rsi
    55c8: 4c 89 da                     	movq	%r11, %rdx
    55cb: 48 c1 c2 24                  	rolq	$0x24, %rdx
    55cf: 4d 89 df                     	movq	%r11, %r15
    55d2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    55d6: 49 31 d7                     	xorq	%rdx, %r15
    55d9: 4d 89 dc                     	movq	%r11, %r12
    55dc: 49 c1 c4 19                  	rolq	$0x19, %r12
    55e0: 4d 31 fc                     	xorq	%r15, %r12
    55e3: 4d 89 cf                     	movq	%r9, %r15
    55e6: 4d 09 c7                     	orq	%r8, %r15
    55e9: 4d 21 df                     	andq	%r11, %r15
    55ec: 4c 89 ca                     	movq	%r9, %rdx
    55ef: 4c 21 c2                     	andq	%r8, %rdx
    55f2: 4c 09 fa                     	orq	%r15, %rdx
    55f5: 49 89 f7                     	movq	%rsi, %r15
    55f8: 49 c1 c7 32                  	rolq	$0x32, %r15
    55fc: 4c 01 e2                     	addq	%r12, %rdx
    55ff: 49 89 f4                     	movq	%rsi, %r12
    5602: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5606: 4c 01 f2                     	addq	%r14, %rdx
    5609: 49 89 f6                     	movq	%rsi, %r14
    560c: 49 c1 c6 17                  	rolq	$0x17, %r14
    5610: 4d 31 fc                     	xorq	%r15, %r12
    5613: 4d 31 e6                     	xorq	%r12, %r14
    5616: 49 89 df                     	movq	%rbx, %r15
    5619: 4d 31 d7                     	xorq	%r10, %r15
    561c: 49 21 f7                     	andq	%rsi, %r15
    561f: 4d 31 d7                     	xorq	%r10, %r15
    5622: 48 03 8d 30 ff ff ff         	addq	-0xd0(%rbp), %rcx
    5629: 4c 01 f9                     	addq	%r15, %rcx
    562c: 49 bf ec 39 64 1a 08 02 c7 8c	movabsq	$-0x7338fdf7e59bc614, %r15 # imm = 0x8CC702081A6439EC
    5636: 49 01 cf                     	addq	%rcx, %r15
    5639: 4d 01 f7                     	addq	%r14, %r15
    563c: 4d 01 f8                     	addq	%r15, %r8
    563f: 48 89 d1                     	movq	%rdx, %rcx
    5642: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5646: 49 89 d6                     	movq	%rdx, %r14
    5649: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    564d: 49 31 ce                     	xorq	%rcx, %r14
    5650: 49 89 d4                     	movq	%rdx, %r12
    5653: 49 c1 c4 19                  	rolq	$0x19, %r12
    5657: 4d 31 f4                     	xorq	%r14, %r12
    565a: 4d 89 de                     	movq	%r11, %r14
    565d: 4d 09 ce                     	orq	%r9, %r14
    5660: 49 21 d6                     	andq	%rdx, %r14
    5663: 4c 89 d9                     	movq	%r11, %rcx
    5666: 4c 21 c9                     	andq	%r9, %rcx
    5669: 4c 09 f1                     	orq	%r14, %rcx
    566c: 4c 01 e1                     	addq	%r12, %rcx
    566f: 4c 01 f9                     	addq	%r15, %rcx
    5672: 4d 89 c6                     	movq	%r8, %r14
    5675: 49 c1 c6 32                  	rolq	$0x32, %r14
    5679: 4d 89 c7                     	movq	%r8, %r15
    567c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5680: 4d 31 f7                     	xorq	%r14, %r15
    5683: 4d 89 c4                     	movq	%r8, %r12
    5686: 49 c1 c4 17                  	rolq	$0x17, %r12
    568a: 4d 31 fc                     	xorq	%r15, %r12
    568d: 49 89 f6                     	movq	%rsi, %r14
    5690: 49 31 de                     	xorq	%rbx, %r14
    5693: 4d 21 c6                     	andq	%r8, %r14
    5696: 4c 03 95 38 ff ff ff         	addq	-0xc8(%rbp), %r10
    569d: 49 31 de                     	xorq	%rbx, %r14
    56a0: 4d 01 f2                     	addq	%r14, %r10
    56a3: 49 be 28 1e 63 23 fa ff be 90	movabsq	$-0x6f410005dc9ce1d8, %r14 # imm = 0x90BEFFFA23631E28
    56ad: 4d 01 d6                     	addq	%r10, %r14
    56b0: 4d 01 e6                     	addq	%r12, %r14
    56b3: 49 89 ca                     	movq	%rcx, %r10
    56b6: 49 c1 c2 24                  	rolq	$0x24, %r10
    56ba: 4d 01 f1                     	addq	%r14, %r9
    56bd: 49 89 cf                     	movq	%rcx, %r15
    56c0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    56c4: 4d 31 d7                     	xorq	%r10, %r15
    56c7: 49 89 cc                     	movq	%rcx, %r12
    56ca: 49 c1 c4 19                  	rolq	$0x19, %r12
    56ce: 4d 31 fc                     	xorq	%r15, %r12
    56d1: 49 89 d7                     	movq	%rdx, %r15
    56d4: 4d 09 df                     	orq	%r11, %r15
    56d7: 49 21 cf                     	andq	%rcx, %r15
    56da: 49 89 d2                     	movq	%rdx, %r10
    56dd: 4d 21 da                     	andq	%r11, %r10
    56e0: 4d 09 fa                     	orq	%r15, %r10
    56e3: 4d 01 e2                     	addq	%r12, %r10
    56e6: 4d 01 f2                     	addq	%r14, %r10
    56e9: 4d 89 ce                     	movq	%r9, %r14
    56ec: 49 c1 c6 32                  	rolq	$0x32, %r14
    56f0: 4d 89 cf                     	movq	%r9, %r15
    56f3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    56f7: 4d 31 f7                     	xorq	%r14, %r15
    56fa: 4d 89 cc                     	movq	%r9, %r12
    56fd: 49 c1 c4 17                  	rolq	$0x17, %r12
    5701: 4d 31 fc                     	xorq	%r15, %r12
    5704: 4d 89 c6                     	movq	%r8, %r14
    5707: 49 31 f6                     	xorq	%rsi, %r14
    570a: 4d 21 ce                     	andq	%r9, %r14
    570d: 49 31 f6                     	xorq	%rsi, %r14
    5710: 48 03 9d 40 ff ff ff         	addq	-0xc0(%rbp), %rbx
    5717: 4c 01 f3                     	addq	%r14, %rbx
    571a: 49 be e9 bd 82 de eb 6c 50 a4	movabsq	$-0x5baf9314217d4217, %r14 # imm = 0xA4506CEBDE82BDE9
    5724: 49 01 de                     	addq	%rbx, %r14
    5727: 4c 89 d3                     	movq	%r10, %rbx
    572a: 48 c1 c3 24                  	rolq	$0x24, %rbx
    572e: 4d 01 e6                     	addq	%r12, %r14
    5731: 4d 89 d7                     	movq	%r10, %r15
    5734: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5738: 4d 01 f3                     	addq	%r14, %r11
    573b: 4d 89 d4                     	movq	%r10, %r12
    573e: 49 c1 c4 19                  	rolq	$0x19, %r12
    5742: 49 31 df                     	xorq	%rbx, %r15
    5745: 4d 31 fc                     	xorq	%r15, %r12
    5748: 49 89 cf                     	movq	%rcx, %r15
    574b: 49 09 d7                     	orq	%rdx, %r15
    574e: 4d 21 d7                     	andq	%r10, %r15
    5751: 48 89 cb                     	movq	%rcx, %rbx
    5754: 48 21 d3                     	andq	%rdx, %rbx
    5757: 4c 09 fb                     	orq	%r15, %rbx
    575a: 4c 01 e3                     	addq	%r12, %rbx
    575d: 4d 89 df                     	movq	%r11, %r15
    5760: 49 c1 c7 32                  	rolq	$0x32, %r15
    5764: 4c 01 f3                     	addq	%r14, %rbx
    5767: 4d 89 de                     	movq	%r11, %r14
    576a: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    576e: 4d 31 fe                     	xorq	%r15, %r14
    5771: 4d 89 df                     	movq	%r11, %r15
    5774: 49 c1 c7 17                  	rolq	$0x17, %r15
    5778: 4d 31 f7                     	xorq	%r14, %r15
    577b: 4d 89 ce                     	movq	%r9, %r14
    577e: 4d 31 c6                     	xorq	%r8, %r14
    5781: 4d 21 de                     	andq	%r11, %r14
    5784: 4d 31 c6                     	xorq	%r8, %r14
    5787: 48 03 b5 48 ff ff ff         	addq	-0xb8(%rbp), %rsi
    578e: 4c 01 f6                     	addq	%r14, %rsi
    5791: 49 be 15 79 c6 b2 f7 a3 f9 be	movabsq	$-0x41065c084d3986eb, %r14 # imm = 0xBEF9A3F7B2C67915
    579b: 49 01 f6                     	addq	%rsi, %r14
    579e: 4d 01 fe                     	addq	%r15, %r14
    57a1: 4c 01 f2                     	addq	%r14, %rdx
    57a4: 48 89 de                     	movq	%rbx, %rsi
    57a7: 48 c1 c6 24                  	rolq	$0x24, %rsi
    57ab: 49 89 df                     	movq	%rbx, %r15
    57ae: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    57b2: 49 31 f7                     	xorq	%rsi, %r15
    57b5: 49 89 dc                     	movq	%rbx, %r12
    57b8: 49 c1 c4 19                  	rolq	$0x19, %r12
    57bc: 4d 31 fc                     	xorq	%r15, %r12
    57bf: 4d 89 d7                     	movq	%r10, %r15
    57c2: 49 09 cf                     	orq	%rcx, %r15
    57c5: 49 21 df                     	andq	%rbx, %r15
    57c8: 4c 89 d6                     	movq	%r10, %rsi
    57cb: 48 21 ce                     	andq	%rcx, %rsi
    57ce: 4c 09 fe                     	orq	%r15, %rsi
    57d1: 49 89 d7                     	movq	%rdx, %r15
    57d4: 49 c1 c7 32                  	rolq	$0x32, %r15
    57d8: 4c 01 e6                     	addq	%r12, %rsi
    57db: 49 89 d4                     	movq	%rdx, %r12
    57de: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    57e2: 4c 01 f6                     	addq	%r14, %rsi
    57e5: 49 89 d6                     	movq	%rdx, %r14
    57e8: 49 c1 c6 17                  	rolq	$0x17, %r14
    57ec: 4d 31 fc                     	xorq	%r15, %r12
    57ef: 4d 31 e6                     	xorq	%r12, %r14
    57f2: 4d 89 df                     	movq	%r11, %r15
    57f5: 4d 31 cf                     	xorq	%r9, %r15
    57f8: 49 21 d7                     	andq	%rdx, %r15
    57fb: 4d 31 cf                     	xorq	%r9, %r15
    57fe: 4c 03 85 50 ff ff ff         	addq	-0xb0(%rbp), %r8
    5805: 4d 01 f8                     	addq	%r15, %r8
    5808: 49 bf 2b 53 72 e3 f2 78 71 c6	movabsq	$-0x398e870d1c8dacd5, %r15 # imm = 0xC67178F2E372532B
    5812: 4d 01 c7                     	addq	%r8, %r15
    5815: 4d 01 f7                     	addq	%r14, %r15
    5818: 4c 01 f9                     	addq	%r15, %rcx
    581b: 49 89 f0                     	movq	%rsi, %r8
    581e: 49 c1 c0 24                  	rolq	$0x24, %r8
    5822: 49 89 f6                     	movq	%rsi, %r14
    5825: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5829: 4d 31 c6                     	xorq	%r8, %r14
    582c: 49 89 f4                     	movq	%rsi, %r12
    582f: 49 c1 c4 19                  	rolq	$0x19, %r12
    5833: 4d 31 f4                     	xorq	%r14, %r12
    5836: 49 89 de                     	movq	%rbx, %r14
    5839: 4d 09 d6                     	orq	%r10, %r14
    583c: 49 21 f6                     	andq	%rsi, %r14
    583f: 49 89 d8                     	movq	%rbx, %r8
    5842: 4d 21 d0                     	andq	%r10, %r8
    5845: 4d 09 f0                     	orq	%r14, %r8
    5848: 4d 01 e0                     	addq	%r12, %r8
    584b: 4d 01 f8                     	addq	%r15, %r8
    584e: 49 89 ce                     	movq	%rcx, %r14
    5851: 49 c1 c6 32                  	rolq	$0x32, %r14
    5855: 49 89 cf                     	movq	%rcx, %r15
    5858: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    585c: 4d 31 f7                     	xorq	%r14, %r15
    585f: 49 89 cc                     	movq	%rcx, %r12
    5862: 49 c1 c4 17                  	rolq	$0x17, %r12
    5866: 4d 31 fc                     	xorq	%r15, %r12
    5869: 49 89 d6                     	movq	%rdx, %r14
    586c: 4d 31 de                     	xorq	%r11, %r14
    586f: 49 21 ce                     	andq	%rcx, %r14
    5872: 4c 03 8d 58 ff ff ff         	addq	-0xa8(%rbp), %r9
    5879: 4d 31 de                     	xorq	%r11, %r14
    587c: 4d 01 f1                     	addq	%r14, %r9
    587f: 49 be 9c 61 26 ea ce 3e 27 ca	movabsq	$-0x35d8c13115d99e64, %r14 # imm = 0xCA273ECEEA26619C
    5889: 4d 01 ce                     	addq	%r9, %r14
    588c: 4d 01 e6                     	addq	%r12, %r14
    588f: 4d 89 c1                     	movq	%r8, %r9
    5892: 49 c1 c1 24                  	rolq	$0x24, %r9
    5896: 4d 01 f2                     	addq	%r14, %r10
    5899: 4d 89 c7                     	movq	%r8, %r15
    589c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    58a0: 4d 31 cf                     	xorq	%r9, %r15
    58a3: 4d 89 c4                     	movq	%r8, %r12
    58a6: 49 c1 c4 19                  	rolq	$0x19, %r12
    58aa: 4d 31 fc                     	xorq	%r15, %r12
    58ad: 49 89 f7                     	movq	%rsi, %r15
    58b0: 49 09 df                     	orq	%rbx, %r15
    58b3: 4d 21 c7                     	andq	%r8, %r15
    58b6: 49 89 f1                     	movq	%rsi, %r9
    58b9: 49 21 d9                     	andq	%rbx, %r9
    58bc: 4d 09 f9                     	orq	%r15, %r9
    58bf: 4d 01 e1                     	addq	%r12, %r9
    58c2: 4d 01 f1                     	addq	%r14, %r9
    58c5: 4d 89 d6                     	movq	%r10, %r14
    58c8: 49 c1 c6 32                  	rolq	$0x32, %r14
    58cc: 4d 89 d7                     	movq	%r10, %r15
    58cf: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    58d3: 4d 31 f7                     	xorq	%r14, %r15
    58d6: 4d 89 d4                     	movq	%r10, %r12
    58d9: 49 c1 c4 17                  	rolq	$0x17, %r12
    58dd: 4d 31 fc                     	xorq	%r15, %r12
    58e0: 49 89 ce                     	movq	%rcx, %r14
    58e3: 49 31 d6                     	xorq	%rdx, %r14
    58e6: 4d 21 d6                     	andq	%r10, %r14
    58e9: 49 31 d6                     	xorq	%rdx, %r14
    58ec: 4c 03 9d 60 ff ff ff         	addq	-0xa0(%rbp), %r11
    58f3: 4d 01 f3                     	addq	%r14, %r11
    58f6: 49 be 07 c2 c0 21 c7 b8 86 d1	movabsq	$-0x2e794738de3f3df9, %r14 # imm = 0xD186B8C721C0C207
    5900: 4d 01 de                     	addq	%r11, %r14
    5903: 4d 89 cb                     	movq	%r9, %r11
    5906: 49 c1 c3 24                  	rolq	$0x24, %r11
    590a: 4d 01 e6                     	addq	%r12, %r14
    590d: 4d 89 cf                     	movq	%r9, %r15
    5910: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5914: 4c 01 f3                     	addq	%r14, %rbx
    5917: 4d 89 cc                     	movq	%r9, %r12
    591a: 49 c1 c4 19                  	rolq	$0x19, %r12
    591e: 4d 31 df                     	xorq	%r11, %r15
    5921: 4d 31 fc                     	xorq	%r15, %r12
    5924: 4d 89 c7                     	movq	%r8, %r15
    5927: 49 09 f7                     	orq	%rsi, %r15
    592a: 4d 21 cf                     	andq	%r9, %r15
    592d: 4d 89 c3                     	movq	%r8, %r11
    5930: 49 21 f3                     	andq	%rsi, %r11
    5933: 4d 09 fb                     	orq	%r15, %r11
    5936: 4d 01 e3                     	addq	%r12, %r11
    5939: 49 89 df                     	movq	%rbx, %r15
    593c: 49 c1 c7 32                  	rolq	$0x32, %r15
    5940: 4d 01 f3                     	addq	%r14, %r11
    5943: 49 89 de                     	movq	%rbx, %r14
    5946: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    594a: 4d 31 fe                     	xorq	%r15, %r14
    594d: 49 89 df                     	movq	%rbx, %r15
    5950: 49 c1 c7 17                  	rolq	$0x17, %r15
    5954: 4d 31 f7                     	xorq	%r14, %r15
    5957: 4d 89 d6                     	movq	%r10, %r14
    595a: 49 31 ce                     	xorq	%rcx, %r14
    595d: 49 21 de                     	andq	%rbx, %r14
    5960: 49 31 ce                     	xorq	%rcx, %r14
    5963: 48 03 95 68 ff ff ff         	addq	-0x98(%rbp), %rdx
    596a: 4c 01 f2                     	addq	%r14, %rdx
    596d: 49 be 1e eb e0 cd d6 7d da ea	movabsq	$-0x15258229321f14e2, %r14 # imm = 0xEADA7DD6CDE0EB1E
    5977: 49 01 d6                     	addq	%rdx, %r14
    597a: 4d 01 fe                     	addq	%r15, %r14
    597d: 4c 01 f6                     	addq	%r14, %rsi
    5980: 4c 89 da                     	movq	%r11, %rdx
    5983: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5987: 4d 89 df                     	movq	%r11, %r15
    598a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    598e: 49 31 d7                     	xorq	%rdx, %r15
    5991: 4d 89 dc                     	movq	%r11, %r12
    5994: 49 c1 c4 19                  	rolq	$0x19, %r12
    5998: 4d 31 fc                     	xorq	%r15, %r12
    599b: 4d 89 cf                     	movq	%r9, %r15
    599e: 4d 09 c7                     	orq	%r8, %r15
    59a1: 4d 21 df                     	andq	%r11, %r15
    59a4: 4c 89 ca                     	movq	%r9, %rdx
    59a7: 4c 21 c2                     	andq	%r8, %rdx
    59aa: 4c 09 fa                     	orq	%r15, %rdx
    59ad: 49 89 f7                     	movq	%rsi, %r15
    59b0: 49 c1 c7 32                  	rolq	$0x32, %r15
    59b4: 4c 01 e2                     	addq	%r12, %rdx
    59b7: 49 89 f4                     	movq	%rsi, %r12
    59ba: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    59be: 4c 01 f2                     	addq	%r14, %rdx
    59c1: 49 89 f6                     	movq	%rsi, %r14
    59c4: 49 c1 c6 17                  	rolq	$0x17, %r14
    59c8: 4d 31 fc                     	xorq	%r15, %r12
    59cb: 4d 31 e6                     	xorq	%r12, %r14
    59ce: 49 89 df                     	movq	%rbx, %r15
    59d1: 4d 31 d7                     	xorq	%r10, %r15
    59d4: 49 21 f7                     	andq	%rsi, %r15
    59d7: 4d 31 d7                     	xorq	%r10, %r15
    59da: 48 03 8d 70 ff ff ff         	addq	-0x90(%rbp), %rcx
    59e1: 4c 01 f9                     	addq	%r15, %rcx
    59e4: 49 bf 78 d1 6e ee 7f 4f 7d f5	movabsq	$-0xa82b08011912e88, %r15 # imm = 0xF57D4F7FEE6ED178
    59ee: 49 01 cf                     	addq	%rcx, %r15
    59f1: 4d 01 f7                     	addq	%r14, %r15
    59f4: 4d 01 f8                     	addq	%r15, %r8
    59f7: 48 89 d1                     	movq	%rdx, %rcx
    59fa: 48 c1 c1 24                  	rolq	$0x24, %rcx
    59fe: 49 89 d6                     	movq	%rdx, %r14
    5a01: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5a05: 49 31 ce                     	xorq	%rcx, %r14
    5a08: 49 89 d4                     	movq	%rdx, %r12
    5a0b: 49 c1 c4 19                  	rolq	$0x19, %r12
    5a0f: 4d 31 f4                     	xorq	%r14, %r12
    5a12: 4d 89 de                     	movq	%r11, %r14
    5a15: 4d 09 ce                     	orq	%r9, %r14
    5a18: 49 21 d6                     	andq	%rdx, %r14
    5a1b: 4c 89 d9                     	movq	%r11, %rcx
    5a1e: 4c 21 c9                     	andq	%r9, %rcx
    5a21: 4c 09 f1                     	orq	%r14, %rcx
    5a24: 4c 01 e1                     	addq	%r12, %rcx
    5a27: 4c 01 f9                     	addq	%r15, %rcx
    5a2a: 4d 89 c6                     	movq	%r8, %r14
    5a2d: 49 c1 c6 32                  	rolq	$0x32, %r14
    5a31: 4d 89 c7                     	movq	%r8, %r15
    5a34: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5a38: 4d 31 f7                     	xorq	%r14, %r15
    5a3b: 4d 89 c4                     	movq	%r8, %r12
    5a3e: 49 c1 c4 17                  	rolq	$0x17, %r12
    5a42: 4d 31 fc                     	xorq	%r15, %r12
    5a45: 49 89 f6                     	movq	%rsi, %r14
    5a48: 49 31 de                     	xorq	%rbx, %r14
    5a4b: 4d 21 c6                     	andq	%r8, %r14
    5a4e: 4c 03 95 78 ff ff ff         	addq	-0x88(%rbp), %r10
    5a55: 49 31 de                     	xorq	%rbx, %r14
    5a58: 4d 01 f2                     	addq	%r14, %r10
    5a5b: 49 be ba 6f 17 72 aa 67 f0 06	movabsq	$0x6f067aa72176fba, %r14 # imm = 0x6F067AA72176FBA
    5a65: 4d 01 d6                     	addq	%r10, %r14
    5a68: 4d 01 e6                     	addq	%r12, %r14
    5a6b: 49 89 ca                     	movq	%rcx, %r10
    5a6e: 49 c1 c2 24                  	rolq	$0x24, %r10
    5a72: 4d 01 f1                     	addq	%r14, %r9
    5a75: 49 89 cf                     	movq	%rcx, %r15
    5a78: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5a7c: 4d 31 d7                     	xorq	%r10, %r15
    5a7f: 49 89 cc                     	movq	%rcx, %r12
    5a82: 49 c1 c4 19                  	rolq	$0x19, %r12
    5a86: 4d 31 fc                     	xorq	%r15, %r12
    5a89: 49 89 d7                     	movq	%rdx, %r15
    5a8c: 4d 09 df                     	orq	%r11, %r15
    5a8f: 49 21 cf                     	andq	%rcx, %r15
    5a92: 49 89 d2                     	movq	%rdx, %r10
    5a95: 4d 21 da                     	andq	%r11, %r10
    5a98: 4d 09 fa                     	orq	%r15, %r10
    5a9b: 4d 01 e2                     	addq	%r12, %r10
    5a9e: 4d 01 f2                     	addq	%r14, %r10
    5aa1: 4d 89 ce                     	movq	%r9, %r14
    5aa4: 49 c1 c6 32                  	rolq	$0x32, %r14
    5aa8: 4d 89 cf                     	movq	%r9, %r15
    5aab: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5aaf: 4d 31 f7                     	xorq	%r14, %r15
    5ab2: 4d 89 cc                     	movq	%r9, %r12
    5ab5: 49 c1 c4 17                  	rolq	$0x17, %r12
    5ab9: 4d 31 fc                     	xorq	%r15, %r12
    5abc: 4d 89 c6                     	movq	%r8, %r14
    5abf: 49 31 f6                     	xorq	%rsi, %r14
    5ac2: 4d 21 ce                     	andq	%r9, %r14
    5ac5: 49 31 f6                     	xorq	%rsi, %r14
    5ac8: 48 03 5d 80                  	addq	-0x80(%rbp), %rbx
    5acc: 4c 01 f3                     	addq	%r14, %rbx
    5acf: 49 be a6 98 c8 a2 c5 7d 63 0a	movabsq	$0xa637dc5a2c898a6, %r14 # imm = 0xA637DC5A2C898A6
    5ad9: 49 01 de                     	addq	%rbx, %r14
    5adc: 4c 89 d3                     	movq	%r10, %rbx
    5adf: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5ae3: 4d 01 e6                     	addq	%r12, %r14
    5ae6: 4d 89 d7                     	movq	%r10, %r15
    5ae9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5aed: 4d 01 f3                     	addq	%r14, %r11
    5af0: 4d 89 d4                     	movq	%r10, %r12
    5af3: 49 c1 c4 19                  	rolq	$0x19, %r12
    5af7: 49 31 df                     	xorq	%rbx, %r15
    5afa: 4d 31 fc                     	xorq	%r15, %r12
    5afd: 49 89 cf                     	movq	%rcx, %r15
    5b00: 49 09 d7                     	orq	%rdx, %r15
    5b03: 4d 21 d7                     	andq	%r10, %r15
    5b06: 48 89 cb                     	movq	%rcx, %rbx
    5b09: 48 21 d3                     	andq	%rdx, %rbx
    5b0c: 4c 09 fb                     	orq	%r15, %rbx
    5b0f: 4c 01 e3                     	addq	%r12, %rbx
    5b12: 4d 89 df                     	movq	%r11, %r15
    5b15: 49 c1 c7 32                  	rolq	$0x32, %r15
    5b19: 4c 01 f3                     	addq	%r14, %rbx
    5b1c: 4d 89 de                     	movq	%r11, %r14
    5b1f: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5b23: 4d 31 fe                     	xorq	%r15, %r14
    5b26: 4d 89 df                     	movq	%r11, %r15
    5b29: 49 c1 c7 17                  	rolq	$0x17, %r15
    5b2d: 4d 31 f7                     	xorq	%r14, %r15
    5b30: 4d 89 ce                     	movq	%r9, %r14
    5b33: 4d 31 c6                     	xorq	%r8, %r14
    5b36: 4d 21 de                     	andq	%r11, %r14
    5b39: 4d 31 c6                     	xorq	%r8, %r14
    5b3c: 48 03 75 88                  	addq	-0x78(%rbp), %rsi
    5b40: 4c 01 f6                     	addq	%r14, %rsi
    5b43: 49 be ae 0d f9 be 04 98 3f 11	movabsq	$0x113f9804bef90dae, %r14 # imm = 0x113F9804BEF90DAE
    5b4d: 49 01 f6                     	addq	%rsi, %r14
    5b50: 4d 01 fe                     	addq	%r15, %r14
    5b53: 4c 01 f2                     	addq	%r14, %rdx
    5b56: 48 89 de                     	movq	%rbx, %rsi
    5b59: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5b5d: 49 89 df                     	movq	%rbx, %r15
    5b60: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5b64: 49 31 f7                     	xorq	%rsi, %r15
    5b67: 49 89 dc                     	movq	%rbx, %r12
    5b6a: 49 c1 c4 19                  	rolq	$0x19, %r12
    5b6e: 4d 31 fc                     	xorq	%r15, %r12
    5b71: 4d 89 d7                     	movq	%r10, %r15
    5b74: 49 09 cf                     	orq	%rcx, %r15
    5b77: 49 21 df                     	andq	%rbx, %r15
    5b7a: 4c 89 d6                     	movq	%r10, %rsi
    5b7d: 48 21 ce                     	andq	%rcx, %rsi
    5b80: 4c 09 fe                     	orq	%r15, %rsi
    5b83: 49 89 d7                     	movq	%rdx, %r15
    5b86: 49 c1 c7 32                  	rolq	$0x32, %r15
    5b8a: 4c 01 e6                     	addq	%r12, %rsi
    5b8d: 49 89 d4                     	movq	%rdx, %r12
    5b90: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5b94: 4c 01 f6                     	addq	%r14, %rsi
    5b97: 49 89 d6                     	movq	%rdx, %r14
    5b9a: 49 c1 c6 17                  	rolq	$0x17, %r14
    5b9e: 4d 31 fc                     	xorq	%r15, %r12
    5ba1: 4d 31 e6                     	xorq	%r12, %r14
    5ba4: 4d 89 df                     	movq	%r11, %r15
    5ba7: 4d 31 cf                     	xorq	%r9, %r15
    5baa: 49 21 d7                     	andq	%rdx, %r15
    5bad: 4d 31 cf                     	xorq	%r9, %r15
    5bb0: 4c 03 45 90                  	addq	-0x70(%rbp), %r8
    5bb4: 4d 01 f8                     	addq	%r15, %r8
    5bb7: 49 bf 1b 47 1c 13 35 0b 71 1b	movabsq	$0x1b710b35131c471b, %r15 # imm = 0x1B710B35131C471B
    5bc1: 4d 01 c7                     	addq	%r8, %r15
    5bc4: 4d 01 f7                     	addq	%r14, %r15
    5bc7: 4c 01 f9                     	addq	%r15, %rcx
    5bca: 49 89 f0                     	movq	%rsi, %r8
    5bcd: 49 c1 c0 24                  	rolq	$0x24, %r8
    5bd1: 49 89 f6                     	movq	%rsi, %r14
    5bd4: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5bd8: 4d 31 c6                     	xorq	%r8, %r14
    5bdb: 49 89 f4                     	movq	%rsi, %r12
    5bde: 49 c1 c4 19                  	rolq	$0x19, %r12
    5be2: 4d 31 f4                     	xorq	%r14, %r12
    5be5: 49 89 de                     	movq	%rbx, %r14
    5be8: 4d 09 d6                     	orq	%r10, %r14
    5beb: 49 21 f6                     	andq	%rsi, %r14
    5bee: 49 89 d8                     	movq	%rbx, %r8
    5bf1: 4d 21 d0                     	andq	%r10, %r8
    5bf4: 4d 09 f0                     	orq	%r14, %r8
    5bf7: 4d 01 e0                     	addq	%r12, %r8
    5bfa: 4d 01 f8                     	addq	%r15, %r8
    5bfd: 49 89 ce                     	movq	%rcx, %r14
    5c00: 49 c1 c6 32                  	rolq	$0x32, %r14
    5c04: 49 89 cf                     	movq	%rcx, %r15
    5c07: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5c0b: 4d 31 f7                     	xorq	%r14, %r15
    5c0e: 49 89 cc                     	movq	%rcx, %r12
    5c11: 49 c1 c4 17                  	rolq	$0x17, %r12
    5c15: 4d 31 fc                     	xorq	%r15, %r12
    5c18: 49 89 d6                     	movq	%rdx, %r14
    5c1b: 4d 31 de                     	xorq	%r11, %r14
    5c1e: 49 21 ce                     	andq	%rcx, %r14
    5c21: 4c 03 4d 98                  	addq	-0x68(%rbp), %r9
    5c25: 4d 31 de                     	xorq	%r11, %r14
    5c28: 4d 01 f1                     	addq	%r14, %r9
    5c2b: 49 be 84 7d 04 23 f5 77 db 28	movabsq	$0x28db77f523047d84, %r14 # imm = 0x28DB77F523047D84
    5c35: 4d 01 ce                     	addq	%r9, %r14
    5c38: 4d 01 e6                     	addq	%r12, %r14
    5c3b: 4d 89 c1                     	movq	%r8, %r9
    5c3e: 49 c1 c1 24                  	rolq	$0x24, %r9
    5c42: 4d 01 f2                     	addq	%r14, %r10
    5c45: 4d 89 c7                     	movq	%r8, %r15
    5c48: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5c4c: 4d 31 cf                     	xorq	%r9, %r15
    5c4f: 4d 89 c4                     	movq	%r8, %r12
    5c52: 49 c1 c4 19                  	rolq	$0x19, %r12
    5c56: 4d 31 fc                     	xorq	%r15, %r12
    5c59: 49 89 f7                     	movq	%rsi, %r15
    5c5c: 49 09 df                     	orq	%rbx, %r15
    5c5f: 4d 21 c7                     	andq	%r8, %r15
    5c62: 49 89 f1                     	movq	%rsi, %r9
    5c65: 49 21 d9                     	andq	%rbx, %r9
    5c68: 4d 09 f9                     	orq	%r15, %r9
    5c6b: 4d 01 e1                     	addq	%r12, %r9
    5c6e: 4d 01 f1                     	addq	%r14, %r9
    5c71: 4d 89 d6                     	movq	%r10, %r14
    5c74: 49 c1 c6 32                  	rolq	$0x32, %r14
    5c78: 4d 89 d7                     	movq	%r10, %r15
    5c7b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5c7f: 4d 31 f7                     	xorq	%r14, %r15
    5c82: 4d 89 d4                     	movq	%r10, %r12
    5c85: 49 c1 c4 17                  	rolq	$0x17, %r12
    5c89: 4d 31 fc                     	xorq	%r15, %r12
    5c8c: 49 89 ce                     	movq	%rcx, %r14
    5c8f: 49 31 d6                     	xorq	%rdx, %r14
    5c92: 4d 21 d6                     	andq	%r10, %r14
    5c95: 49 31 d6                     	xorq	%rdx, %r14
    5c98: 4c 03 5d a0                  	addq	-0x60(%rbp), %r11
    5c9c: 4d 01 f3                     	addq	%r14, %r11
    5c9f: 49 be 93 24 c7 40 7b ab ca 32	movabsq	$0x32caab7b40c72493, %r14 # imm = 0x32CAAB7B40C72493
    5ca9: 4d 01 de                     	addq	%r11, %r14
    5cac: 4d 89 cb                     	movq	%r9, %r11
    5caf: 49 c1 c3 24                  	rolq	$0x24, %r11
    5cb3: 4d 01 e6                     	addq	%r12, %r14
    5cb6: 4d 89 cf                     	movq	%r9, %r15
    5cb9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5cbd: 4c 01 f3                     	addq	%r14, %rbx
    5cc0: 4d 89 cc                     	movq	%r9, %r12
    5cc3: 49 c1 c4 19                  	rolq	$0x19, %r12
    5cc7: 4d 31 df                     	xorq	%r11, %r15
    5cca: 4d 31 fc                     	xorq	%r15, %r12
    5ccd: 4d 89 c7                     	movq	%r8, %r15
    5cd0: 49 09 f7                     	orq	%rsi, %r15
    5cd3: 4d 21 cf                     	andq	%r9, %r15
    5cd6: 4d 89 c3                     	movq	%r8, %r11
    5cd9: 49 21 f3                     	andq	%rsi, %r11
    5cdc: 4d 09 fb                     	orq	%r15, %r11
    5cdf: 4d 01 e3                     	addq	%r12, %r11
    5ce2: 49 89 df                     	movq	%rbx, %r15
    5ce5: 49 c1 c7 32                  	rolq	$0x32, %r15
    5ce9: 4d 01 f3                     	addq	%r14, %r11
    5cec: 49 89 de                     	movq	%rbx, %r14
    5cef: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5cf3: 4d 31 fe                     	xorq	%r15, %r14
    5cf6: 49 89 df                     	movq	%rbx, %r15
    5cf9: 49 c1 c7 17                  	rolq	$0x17, %r15
    5cfd: 4d 31 f7                     	xorq	%r14, %r15
    5d00: 4d 89 d6                     	movq	%r10, %r14
    5d03: 49 31 ce                     	xorq	%rcx, %r14
    5d06: 49 21 de                     	andq	%rbx, %r14
    5d09: 49 31 ce                     	xorq	%rcx, %r14
    5d0c: 48 03 55 a8                  	addq	-0x58(%rbp), %rdx
    5d10: 4c 01 f2                     	addq	%r14, %rdx
    5d13: 49 be bc be c9 15 0a be 9e 3c	movabsq	$0x3c9ebe0a15c9bebc, %r14 # imm = 0x3C9EBE0A15C9BEBC
    5d1d: 49 01 d6                     	addq	%rdx, %r14
    5d20: 4d 01 fe                     	addq	%r15, %r14
    5d23: 4c 01 f6                     	addq	%r14, %rsi
    5d26: 4c 89 da                     	movq	%r11, %rdx
    5d29: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5d2d: 4d 89 df                     	movq	%r11, %r15
    5d30: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5d34: 49 31 d7                     	xorq	%rdx, %r15
    5d37: 4d 89 dc                     	movq	%r11, %r12
    5d3a: 49 c1 c4 19                  	rolq	$0x19, %r12
    5d3e: 4d 31 fc                     	xorq	%r15, %r12
    5d41: 4d 89 cf                     	movq	%r9, %r15
    5d44: 4d 09 c7                     	orq	%r8, %r15
    5d47: 4d 21 df                     	andq	%r11, %r15
    5d4a: 4c 89 ca                     	movq	%r9, %rdx
    5d4d: 4c 21 c2                     	andq	%r8, %rdx
    5d50: 4c 09 fa                     	orq	%r15, %rdx
    5d53: 49 89 f7                     	movq	%rsi, %r15
    5d56: 49 c1 c7 32                  	rolq	$0x32, %r15
    5d5a: 4c 01 e2                     	addq	%r12, %rdx
    5d5d: 49 89 f4                     	movq	%rsi, %r12
    5d60: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5d64: 4c 01 f2                     	addq	%r14, %rdx
    5d67: 49 89 f6                     	movq	%rsi, %r14
    5d6a: 49 c1 c6 17                  	rolq	$0x17, %r14
    5d6e: 4d 31 fc                     	xorq	%r15, %r12
    5d71: 4d 31 e6                     	xorq	%r12, %r14
    5d74: 49 89 df                     	movq	%rbx, %r15
    5d77: 4d 31 d7                     	xorq	%r10, %r15
    5d7a: 49 21 f7                     	andq	%rsi, %r15
    5d7d: 4d 31 d7                     	xorq	%r10, %r15
    5d80: 48 03 4d b0                  	addq	-0x50(%rbp), %rcx
    5d84: 4c 01 f9                     	addq	%r15, %rcx
    5d87: 49 bf 4c 0d 10 9c c4 67 1d 43	movabsq	$0x431d67c49c100d4c, %r15 # imm = 0x431D67C49C100D4C
    5d91: 49 01 cf                     	addq	%rcx, %r15
    5d94: 4d 01 f7                     	addq	%r14, %r15
    5d97: 4d 01 f8                     	addq	%r15, %r8
    5d9a: 48 89 d1                     	movq	%rdx, %rcx
    5d9d: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5da1: 49 89 d6                     	movq	%rdx, %r14
    5da4: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5da8: 49 31 ce                     	xorq	%rcx, %r14
    5dab: 49 89 d4                     	movq	%rdx, %r12
    5dae: 49 c1 c4 19                  	rolq	$0x19, %r12
    5db2: 4d 31 f4                     	xorq	%r14, %r12
    5db5: 4d 89 de                     	movq	%r11, %r14
    5db8: 4d 09 ce                     	orq	%r9, %r14
    5dbb: 49 21 d6                     	andq	%rdx, %r14
    5dbe: 4c 89 d9                     	movq	%r11, %rcx
    5dc1: 4c 21 c9                     	andq	%r9, %rcx
    5dc4: 4c 09 f1                     	orq	%r14, %rcx
    5dc7: 4c 01 e1                     	addq	%r12, %rcx
    5dca: 4c 01 f9                     	addq	%r15, %rcx
    5dcd: 4d 89 c6                     	movq	%r8, %r14
    5dd0: 49 c1 c6 32                  	rolq	$0x32, %r14
    5dd4: 4d 89 c7                     	movq	%r8, %r15
    5dd7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5ddb: 4d 31 f7                     	xorq	%r14, %r15
    5dde: 4d 89 c4                     	movq	%r8, %r12
    5de1: 49 c1 c4 17                  	rolq	$0x17, %r12
    5de5: 4d 31 fc                     	xorq	%r15, %r12
    5de8: 49 89 f6                     	movq	%rsi, %r14
    5deb: 49 31 de                     	xorq	%rbx, %r14
    5dee: 4d 21 c6                     	andq	%r8, %r14
    5df1: 4c 03 55 b8                  	addq	-0x48(%rbp), %r10
    5df5: 49 31 de                     	xorq	%rbx, %r14
    5df8: 4d 01 f2                     	addq	%r14, %r10
    5dfb: 49 be b6 42 3e cb be d4 c5 4c	movabsq	$0x4cc5d4becb3e42b6, %r14 # imm = 0x4CC5D4BECB3E42B6
    5e05: 4d 01 d6                     	addq	%r10, %r14
    5e08: 4d 01 e6                     	addq	%r12, %r14
    5e0b: 49 89 ca                     	movq	%rcx, %r10
    5e0e: 49 c1 c2 24                  	rolq	$0x24, %r10
    5e12: 4d 01 f1                     	addq	%r14, %r9
    5e15: 49 89 cf                     	movq	%rcx, %r15
    5e18: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5e1c: 4d 31 d7                     	xorq	%r10, %r15
    5e1f: 49 89 cc                     	movq	%rcx, %r12
    5e22: 49 c1 c4 19                  	rolq	$0x19, %r12
    5e26: 4d 31 fc                     	xorq	%r15, %r12
    5e29: 49 89 d7                     	movq	%rdx, %r15
    5e2c: 4d 09 df                     	orq	%r11, %r15
    5e2f: 49 21 cf                     	andq	%rcx, %r15
    5e32: 49 89 d2                     	movq	%rdx, %r10
    5e35: 4d 21 da                     	andq	%r11, %r10
    5e38: 4d 09 fa                     	orq	%r15, %r10
    5e3b: 4d 01 e2                     	addq	%r12, %r10
    5e3e: 4d 01 f2                     	addq	%r14, %r10
    5e41: 4d 89 ce                     	movq	%r9, %r14
    5e44: 49 c1 c6 32                  	rolq	$0x32, %r14
    5e48: 4d 89 cf                     	movq	%r9, %r15
    5e4b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5e4f: 4d 31 f7                     	xorq	%r14, %r15
    5e52: 4d 89 cc                     	movq	%r9, %r12
    5e55: 49 c1 c4 17                  	rolq	$0x17, %r12
    5e59: 4d 31 fc                     	xorq	%r15, %r12
    5e5c: 4d 89 c6                     	movq	%r8, %r14
    5e5f: 49 31 f6                     	xorq	%rsi, %r14
    5e62: 4d 21 ce                     	andq	%r9, %r14
    5e65: 49 31 f6                     	xorq	%rsi, %r14
    5e68: 48 03 5d c0                  	addq	-0x40(%rbp), %rbx
    5e6c: 4c 01 f3                     	addq	%r14, %rbx
    5e6f: 49 be 2a 7e 65 fc 9c 29 7f 59	movabsq	$0x597f299cfc657e2a, %r14 # imm = 0x597F299CFC657E2A
    5e79: 49 01 de                     	addq	%rbx, %r14
    5e7c: 4c 89 d3                     	movq	%r10, %rbx
    5e7f: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5e83: 4d 01 e6                     	addq	%r12, %r14
    5e86: 4d 89 d7                     	movq	%r10, %r15
    5e89: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5e8d: 4d 01 f3                     	addq	%r14, %r11
    5e90: 4d 89 d4                     	movq	%r10, %r12
    5e93: 49 c1 c4 19                  	rolq	$0x19, %r12
    5e97: 49 31 df                     	xorq	%rbx, %r15
    5e9a: 4d 31 fc                     	xorq	%r15, %r12
    5e9d: 49 89 cf                     	movq	%rcx, %r15
    5ea0: 49 09 d7                     	orq	%rdx, %r15
    5ea3: 4d 21 d7                     	andq	%r10, %r15
    5ea6: 48 89 cb                     	movq	%rcx, %rbx
    5ea9: 48 21 d3                     	andq	%rdx, %rbx
    5eac: 4c 09 fb                     	orq	%r15, %rbx
    5eaf: 4c 01 e3                     	addq	%r12, %rbx
    5eb2: 4d 89 df                     	movq	%r11, %r15
    5eb5: 49 c1 c7 32                  	rolq	$0x32, %r15
    5eb9: 4c 01 f3                     	addq	%r14, %rbx
    5ebc: 4d 89 de                     	movq	%r11, %r14
    5ebf: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5ec3: 4d 31 fe                     	xorq	%r15, %r14
    5ec6: 4d 89 df                     	movq	%r11, %r15
    5ec9: 49 c1 c7 17                  	rolq	$0x17, %r15
    5ecd: 4d 31 f7                     	xorq	%r14, %r15
    5ed0: 4d 89 ce                     	movq	%r9, %r14
    5ed3: 4d 31 c6                     	xorq	%r8, %r14
    5ed6: 4d 21 de                     	andq	%r11, %r14
    5ed9: 4d 31 c6                     	xorq	%r8, %r14
    5edc: 48 03 75 c8                  	addq	-0x38(%rbp), %rsi
    5ee0: 4c 01 f6                     	addq	%r14, %rsi
    5ee3: 49 be ec fa d6 3a ab 6f cb 5f	movabsq	$0x5fcb6fab3ad6faec, %r14 # imm = 0x5FCB6FAB3AD6FAEC
    5eed: 49 01 f6                     	addq	%rsi, %r14
    5ef0: 4d 01 fe                     	addq	%r15, %r14
    5ef3: 4c 01 f2                     	addq	%r14, %rdx
    5ef6: 48 89 de                     	movq	%rbx, %rsi
    5ef9: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5efd: 49 89 df                     	movq	%rbx, %r15
    5f00: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5f04: 49 31 f7                     	xorq	%rsi, %r15
    5f07: 49 89 dc                     	movq	%rbx, %r12
    5f0a: 49 c1 c4 19                  	rolq	$0x19, %r12
    5f0e: 4d 31 fc                     	xorq	%r15, %r12
    5f11: 4d 89 d7                     	movq	%r10, %r15
    5f14: 49 09 cf                     	orq	%rcx, %r15
    5f17: 49 21 df                     	andq	%rbx, %r15
    5f1a: 4c 89 d6                     	movq	%r10, %rsi
    5f1d: 48 21 ce                     	andq	%rcx, %rsi
    5f20: 4c 09 fe                     	orq	%r15, %rsi
    5f23: 49 89 d7                     	movq	%rdx, %r15
    5f26: 49 c1 c7 32                  	rolq	$0x32, %r15
    5f2a: 4c 01 e6                     	addq	%r12, %rsi
    5f2d: 49 89 d4                     	movq	%rdx, %r12
    5f30: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5f34: 4c 01 f6                     	addq	%r14, %rsi
    5f37: 49 89 d5                     	movq	%rdx, %r13
    5f3a: 49 c1 c5 17                  	rolq	$0x17, %r13
    5f3e: 4d 31 fc                     	xorq	%r15, %r12
    5f41: 4d 31 e5                     	xorq	%r12, %r13
    5f44: 4d 89 de                     	movq	%r11, %r14
    5f47: 4d 31 ce                     	xorq	%r9, %r14
    5f4a: 49 21 d6                     	andq	%rdx, %r14
    5f4d: 4d 31 ce                     	xorq	%r9, %r14
    5f50: 4c 03 45 d0                  	addq	-0x30(%rbp), %r8
    5f54: 4d 01 f0                     	addq	%r14, %r8
    5f57: 49 be 17 58 47 4a 8c 19 44 6c	movabsq	$0x6c44198c4a475817, %r14 # imm = 0x6C44198C4A475817
    5f61: 4d 01 c6                     	addq	%r8, %r14
    5f64: 4d 01 ee                     	addq	%r13, %r14
    5f67: 49 89 f0                     	movq	%rsi, %r8
    5f6a: 49 c1 c0 24                  	rolq	$0x24, %r8
    5f6e: 49 89 f7                     	movq	%rsi, %r15
    5f71: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5f75: 4d 31 c7                     	xorq	%r8, %r15
    5f78: 49 89 f0                     	movq	%rsi, %r8
    5f7b: 49 c1 c0 19                  	rolq	$0x19, %r8
    5f7f: 4d 31 f8                     	xorq	%r15, %r8
    5f82: 49 89 df                     	movq	%rbx, %r15
    5f85: 4d 09 d7                     	orq	%r10, %r15
    5f88: 49 21 f7                     	andq	%rsi, %r15
    5f8b: 49 89 dc                     	movq	%rbx, %r12
    5f8e: 4d 21 d4                     	andq	%r10, %r12
    5f91: 4d 09 fc                     	orq	%r15, %r12
    5f94: 4d 01 c4                     	addq	%r8, %r12
    5f97: 4d 01 f4                     	addq	%r14, %r12
    5f9a: 49 01 c4                     	addq	%rax, %r12
    5f9d: 4c 89 67 10                  	movq	%r12, 0x10(%rdi)
    5fa1: 48 01 77 18                  	addq	%rsi, 0x18(%rdi)
    5fa5: 48 01 5f 20                  	addq	%rbx, 0x20(%rdi)
    5fa9: 4c 01 57 28                  	addq	%r10, 0x28(%rdi)
    5fad: 4c 01 f1                     	addq	%r14, %rcx
    5fb0: 48 01 4f 30                  	addq	%rcx, 0x30(%rdi)
    5fb4: 48 01 57 38                  	addq	%rdx, 0x38(%rdi)
    5fb8: 4c 01 5f 40                  	addq	%r11, 0x40(%rdi)
    5fbc: 4c 01 4f 48                  	addq	%r9, 0x48(%rdi)
    5fc0: 48 81 c4 00 02 00 00         	addq	$0x200, %rsp            # imm = 0x200
    5fc7: 5b                           	popq	%rbx
    5fc8: 41 5c                        	popq	%r12
    5fca: 41 5d                        	popq	%r13
    5fcc: 41 5e                        	popq	%r14
    5fce: 41 5f                        	popq	%r15
    5fd0: 5d                           	popq	%rbp
    5fd1: c3                           	retq
    5fd2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    5fdc: 0f 1f 40 00                  	nopl	(%rax)

0000000000005fe0 <audit_master384>:
    5fe0: 55                           	pushq	%rbp
    5fe1: 48 89 e5                     	movq	%rsp, %rbp
    5fe4: 41 56                        	pushq	%r14
    5fe6: 53                           	pushq	%rbx
    5fe7: 48 81 ec 70 01 00 00         	subq	$0x170, %rsp            # imm = 0x170
    5fee: 48 89 f3                     	movq	%rsi, %rbx
    5ff1: 49 89 f8                     	movq	%rdi, %r8
    5ff4: 66 c7 85 80 fe ff ff 00 30   	movw	$0x3000, -0x180(%rbp)   # imm = 0x3000
    5ffd: c6 85 82 fe ff ff 0d         	movb	$0xd, -0x17e(%rbp)
    6004: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    600e: 48 89 85 83 fe ff ff         	movq	%rax, -0x17d(%rbp)
    6015: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    601f: 48 89 85 88 fe ff ff         	movq	%rax, -0x178(%rbp)
    6026: c6 85 90 fe ff ff 30         	movb	$0x30, -0x170(%rbp)
    602d: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x54>
		0000000000006030:  R_X86_64_PC32	.rodata+0x6c
    6034: 0f 11 85 91 fe ff ff         	movups	%xmm0, -0x16f(%rbp)
    603b: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x62>
		000000000000603e:  R_X86_64_PC32	.rodata+0x7c
    6042: 0f 11 85 a1 fe ff ff         	movups	%xmm0, -0x15f(%rbp)
    6049: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x70>
		000000000000604c:  R_X86_64_PC32	.rodata+0x8c
    6050: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    6057: 4c 8d 75 c0                  	leaq	-0x40(%rbp), %r14
    605b: 48 8d 95 80 fe ff ff         	leaq	-0x180(%rbp), %rdx
    6062: be 30 00 00 00               	movl	$0x30, %esi
    6067: b9 41 00 00 00               	movl	$0x41, %ecx
    606c: 4c 89 f7                     	movq	%r14, %rdi
    606f: e8 0c cd ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    6074: 48 8d 7d 90                  	leaq	-0x70(%rbp), %rdi
    6078: ba 00 00 00 00               	movl	$0x0, %edx
		0000000000006079:  R_X86_64_32	.rodata+0x190
    607d: 4c 89 f6                     	movq	%r14, %rsi
    6080: e8 fb c9 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    6085: 0f 57 c0                     	xorps	%xmm0, %xmm0
    6088: 0f 29 45 e0                  	movaps	%xmm0, -0x20(%rbp)
    608c: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    6090: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    6094: 0f 10 45 90                  	movups	-0x70(%rbp), %xmm0
    6098: 0f 10 4d a0                  	movups	-0x60(%rbp), %xmm1
    609c: 0f 10 55 b0                  	movups	-0x50(%rbp), %xmm2
    60a0: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    60a4: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    60a8: 0f 11 03                     	movups	%xmm0, (%rbx)
    60ab: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            # imm = 0x170
    60b2: 5b                           	popq	%rbx
    60b3: 41 5e                        	popq	%r14
    60b5: 5d                           	popq	%rbp
    60b6: c3                           	retq
    60b7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)

00000000000060c0 <audit_key384>:
    60c0: 55                           	pushq	%rbp
    60c1: 48 89 e5                     	movq	%rsp, %rbp
    60c4: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            # imm = 0x110
    60cb: 48 89 f0                     	movq	%rsi, %rax
    60ce: 49 89 f8                     	movq	%rdi, %r8
    60d1: 66 c7 85 f4 fe ff ff 00 20   	movw	$0x2000, -0x10c(%rbp)   # imm = 0x2000
    60da: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    60e1: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
    60eb: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    60f2: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    60fb: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    6102: be 20 00 00 00               	movl	$0x20, %esi
    6107: b9 0d 00 00 00               	movl	$0xd, %ecx
    610c: 48 89 c7                     	movq	%rax, %rdi
    610f: e8 6c cc ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    6114: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            # imm = 0x110
    611b: 5d                           	popq	%rbp
    611c: c3                           	retq
