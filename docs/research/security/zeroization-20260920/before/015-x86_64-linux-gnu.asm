
/tmp/ztls-signoff-20260919/125-before-6d73a0a/015-x86_64-linux-gnu.o:	file format elf64-x86-64

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
      19: 66 c7 85 98 fe ff ff 00 20   	movw	$0x2000, -0x168(%rbp)   # imm = 0x2000
      22: c6 85 9a fe ff ff 0d         	movb	$0xd, -0x166(%rbp)
      29: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
      33: 48 89 85 9b fe ff ff         	movq	%rax, -0x165(%rbp)
      3a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
      44: 48 89 85 a0 fe ff ff         	movq	%rax, -0x160(%rbp)
      4b: c6 85 a8 fe ff ff 20         	movb	$0x20, -0x158(%rbp)
      52: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x59>
		0000000000000055:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
      59: 0f 11 85 a9 fe ff ff         	movups	%xmm0, -0x157(%rbp)
      60: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x67>
		0000000000000063:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
      67: 0f 11 85 b9 fe ff ff         	movups	%xmm0, -0x147(%rbp)
      6e: 4c 8d 7d a8                  	leaq	-0x58(%rbp), %r15
      72: 48 8d 95 98 fe ff ff         	leaq	-0x168(%rbp), %rdx
      79: be 20 00 00 00               	movl	$0x20, %esi
      7e: b9 31 00 00 00               	movl	$0x31, %ecx
      83: 4c 89 ff                     	movq	%r15, %rdi
      86: e8 15 03 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
      8b: 48 8d 7d c8                  	leaq	-0x38(%rbp), %rdi
      8f: 4c 89 fe                     	movq	%r15, %rsi
      92: 4c 89 f2                     	movq	%r14, %rdx
      95: e8 26 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
      9a: 0f 10 45 c8                  	movups	-0x38(%rbp), %xmm0
      9e: 0f 10 4d d8                  	movups	-0x28(%rbp), %xmm1
      a2: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
      a6: 0f 11 03                     	movups	%xmm0, (%rbx)
      a9: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            # imm = 0x158
      b0: 5b                           	popq	%rbx
      b1: 41 5e                        	popq	%r14
      b3: 41 5f                        	popq	%r15
      b5: 5d                           	popq	%rbp
      b6: c3                           	retq
      b7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)

00000000000000c0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
      c0: 55                           	pushq	%rbp
      c1: 48 89 e5                     	movq	%rsp, %rbp
      c4: 41 57                        	pushq	%r15
      c6: 41 56                        	pushq	%r14
      c8: 41 55                        	pushq	%r13
      ca: 41 54                        	pushq	%r12
      cc: 53                           	pushq	%rbx
      cd: 48 81 ec 68 01 00 00         	subq	$0x168, %rsp            # imm = 0x168
      d4: 49 89 d7                     	movq	%rdx, %r15
      d7: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
      db: 0f 10 06                     	movups	(%rsi), %xmm0
      de: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
      e2: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x29>
		00000000000000e5:  R_X86_64_PC32	.LCPI1_0-0x4
      e9: 0f 28 d8                     	movaps	%xmm0, %xmm3
      ec: 0f 57 da                     	xorps	%xmm2, %xmm3
      ef: 0f 28 e1                     	movaps	%xmm1, %xmm4
      f2: 0f 57 e2                     	xorps	%xmm2, %xmm4
      f5: 0f 29 9d 20 ff ff ff         	movaps	%xmm3, -0xe0(%rbp)
      fc: 0f 29 a5 30 ff ff ff         	movaps	%xmm4, -0xd0(%rbp)
     103: 0f 29 95 40 ff ff ff         	movaps	%xmm2, -0xc0(%rbp)
     10a: 0f 29 95 50 ff ff ff         	movaps	%xmm2, -0xb0(%rbp)
     111: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x58>
		0000000000000114:  R_X86_64_PC32	.LCPI1_1-0x4
     118: 0f 57 c2                     	xorps	%xmm2, %xmm0
     11b: 0f 57 ca                     	xorps	%xmm2, %xmm1
     11e: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     125: 0f 29 8d 70 ff ff ff         	movaps	%xmm1, -0x90(%rbp)
     12c: 0f 29 55 80                  	movaps	%xmm2, -0x80(%rbp)
     130: 0f 29 55 90                  	movaps	%xmm2, -0x70(%rbp)
     134: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x7b>
		0000000000000137:  R_X86_64_PC32	.rodata-0x4
     13b: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
     142: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x89>
		0000000000000145:  R_X86_64_PC32	.rodata+0xc
     149: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
     150: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x97>
		0000000000000153:  R_X86_64_PC32	.rodata+0x1c
     157: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
     15e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xa5>
		0000000000000161:  R_X86_64_PC32	.rodata+0x2c
     165: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
     16c: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xb3>
		000000000000016f:  R_X86_64_PC32	.rodata+0x3c
     173: 0f 29 85 f0 fe ff ff         	movaps	%xmm0, -0x110(%rbp)
     17a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xc1>
		000000000000017d:  R_X86_64_PC32	.rodata+0x4c
     181: 0f 29 85 00 ff ff ff         	movaps	%xmm0, -0x100(%rbp)
     188: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xcf>
		000000000000018b:  R_X86_64_PC32	.rodata+0x5c
     18f: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     196: 48 8d bd b0 fe ff ff         	leaq	-0x150(%rbp), %rdi
     19d: 48 8d b5 60 ff ff ff         	leaq	-0xa0(%rbp), %rsi
     1a4: e8 e7 0a 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     1a9: 48 8b 9d d0 fe ff ff         	movq	-0x130(%rbp), %rbx
     1b0: 48 83 c3 40                  	addq	$0x40, %rbx
     1b4: 48 89 9d d0 fe ff ff         	movq	%rbx, -0x130(%rbp)
     1bb: 0f b6 85 18 ff ff ff         	movzbl	-0xe8(%rbp), %eax
     1c2: 48 85 c0                     	testq	%rax, %rax
     1c5: 74 4b                        	je	 <L1>
     1c7: 3c 20                        	cmpb	$0x20, %al
     1c9: 72 49                        	jb	 <L2>
     1cb: 41 bd 40 00 00 00            	movl	$0x40, %r13d
     1d1: 49 29 c5                     	subq	%rax, %r13
     1d4: 4c 8d a5 d8 fe ff ff         	leaq	-0x128(%rbp), %r12
     1db: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     1df: 48 81 c7 d8 fe ff ff         	addq	$-0x128, %rdi           # imm = 0xFED8
     1e6: 4c 89 fe                     	movq	%r15, %rsi
     1e9: 4c 89 ea                     	movq	%r13, %rdx
     1ec: e8 00 00 00 00               	callq	 <L0>
		00000000000001ed:  R_X86_64_PLT32	memcpy-0x4
<L0>:
     1f1: 48 8d bd b0 fe ff ff         	leaq	-0x150(%rbp), %rdi
     1f8: 4c 89 e6                     	movq	%r12, %rsi
     1fb: e8 90 0a 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     200: c6 85 18 ff ff ff 00         	movb	$0x0, -0xe8(%rbp)
     207: 31 c0                        	xorl	%eax, %eax
     209: 48 8b 9d d0 fe ff ff         	movq	-0x130(%rbp), %rbx
     210: eb 05                        	jmp	 <L3>
<L1>:
     212: 31 c0                        	xorl	%eax, %eax
<L2>:
     214: 45 31 ed                     	xorl	%r13d, %r13d
<L3>:
     217: 4d 01 ef                     	addq	%r13, %r15
     21a: 41 bc 20 00 00 00            	movl	$0x20, %r12d
     220: 41 be 20 00 00 00            	movl	$0x20, %r14d
     226: 4d 29 ee                     	subq	%r13, %r14
     229: 0f b6 c0                     	movzbl	%al, %eax
     22c: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     230: 48 81 c7 d8 fe ff ff         	addq	$-0x128, %rdi           # imm = 0xFED8
     237: 4c 89 fe                     	movq	%r15, %rsi
     23a: 4c 89 f2                     	movq	%r14, %rdx
     23d: e8 00 00 00 00               	callq	 <L4>
		000000000000023e:  R_X86_64_PLT32	memcpy-0x4
<L4>:
     242: 44 00 b5 18 ff ff ff         	addb	%r14b, -0xe8(%rbp)
     249: 48 83 c3 20                  	addq	$0x20, %rbx
     24d: 48 89 9d d0 fe ff ff         	movq	%rbx, -0x130(%rbp)
     254: 48 8d bd b0 fe ff ff         	leaq	-0x150(%rbp), %rdi
     25b: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
     262: e8 09 09 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     267: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1ae>
		000000000000026a:  R_X86_64_PC32	.rodata+0x5c
     26e: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
     272: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1b9>
		0000000000000275:  R_X86_64_PC32	.rodata+0x4c
     279: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     27d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1c4>
		0000000000000280:  R_X86_64_PC32	.rodata+0x3c
     284: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     288: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1cf>
		000000000000028b:  R_X86_64_PC32	.rodata+0x2c
     28f: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     293: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1da>
		0000000000000296:  R_X86_64_PC32	.rodata+0x1c
     29a: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     29e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1e5>
		00000000000002a1:  R_X86_64_PC32	.rodata+0xc
     2a5: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     2ac: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1f3>
		00000000000002af:  R_X86_64_PC32	.rodata-0x4
     2b3: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     2ba: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     2c1: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
     2c8: e8 c3 09 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     2cd: 0f b6 7d c8                  	movzbl	-0x38(%rbp), %edi
     2d1: 48 8b 5d 80                  	movq	-0x80(%rbp), %rbx
     2d5: 48 83 c3 40                  	addq	$0x40, %rbx
     2d9: 4c 8d 75 88                  	leaq	-0x78(%rbp), %r14
     2dd: 48 89 5d 80                  	movq	%rbx, -0x80(%rbp)
     2e1: 48 85 ff                     	testq	%rdi, %rdi
     2e4: 74 3c                        	je	 <L6>
     2e6: 40 80 ff 20                  	cmpb	$0x20, %dil
     2ea: 72 38                        	jb	 <L7>
     2ec: 41 bf 40 00 00 00            	movl	$0x40, %r15d
     2f2: 49 29 ff                     	subq	%rdi, %r15
     2f5: 4c 01 f7                     	addq	%r14, %rdi
     2f8: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
     2ff: 4c 89 fa                     	movq	%r15, %rdx
     302: e8 00 00 00 00               	callq	 <L5>
		0000000000000303:  R_X86_64_PLT32	memcpy-0x4
<L5>:
     307: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     30e: 4c 89 f6                     	movq	%r14, %rsi
     311: e8 7a 09 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     316: c6 45 c8 00                  	movb	$0x0, -0x38(%rbp)
     31a: 31 ff                        	xorl	%edi, %edi
     31c: 48 8b 5d 80                  	movq	-0x80(%rbp), %rbx
     320: eb 05                        	jmp	 <L8>
<L6>:
     322: 31 ff                        	xorl	%edi, %edi
<L7>:
     324: 45 31 ff                     	xorl	%r15d, %r15d
<L8>:
     327: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     32b: 48 81 c6 70 fe ff ff         	addq	$-0x190, %rsi           # imm = 0xFE70
     332: 4d 29 fc                     	subq	%r15, %r12
     335: 40 0f b6 c7                  	movzbl	%dil, %eax
     339: 49 01 c6                     	addq	%rax, %r14
     33c: 4c 89 f7                     	movq	%r14, %rdi
     33f: 4c 89 e2                     	movq	%r12, %rdx
     342: e8 00 00 00 00               	callq	 <L9>
		0000000000000343:  R_X86_64_PLT32	memcpy-0x4
<L9>:
     347: 44 00 65 c8                  	addb	%r12b, -0x38(%rbp)
     34b: 48 83 c3 20                  	addq	$0x20, %rbx
     34f: 48 89 5d 80                  	movq	%rbx, -0x80(%rbp)
     353: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     35a: 48 8d b5 90 fe ff ff         	leaq	-0x170(%rbp), %rsi
     361: e8 0a 08 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     366: 0f 10 85 90 fe ff ff         	movups	-0x170(%rbp), %xmm0
     36d: 0f 10 8d a0 fe ff ff         	movups	-0x160(%rbp), %xmm1
     374: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
     378: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
     37c: 0f 11 00                     	movups	%xmm0, (%rax)
     37f: 48 81 c4 68 01 00 00         	addq	$0x168, %rsp            # imm = 0x168
     386: 5b                           	popq	%rbx
     387: 41 5c                        	popq	%r12
     389: 41 5d                        	popq	%r13
     38b: 41 5e                        	popq	%r14
     38d: 41 5f                        	popq	%r15
     38f: 5d                           	popq	%rbp
     390: c3                           	retq
     391: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     39b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

00000000000003a0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     3a0: 55                           	pushq	%rbp
     3a1: 48 89 e5                     	movq	%rsp, %rbp
     3a4: 41 57                        	pushq	%r15
     3a6: 41 56                        	pushq	%r14
     3a8: 41 55                        	pushq	%r13
     3aa: 41 54                        	pushq	%r12
     3ac: 53                           	pushq	%rbx
     3ad: 48 81 ec 68 02 00 00         	subq	$0x268, %rsp            # imm = 0x268
     3b4: 49 89 cd                     	movq	%rcx, %r13
     3b7: 49 89 d4                     	movq	%rdx, %r12
     3ba: 48 89 f3                     	movq	%rsi, %rbx
     3bd: 49 89 fe                     	movq	%rdi, %r14
     3c0: 41 0f 10 18                  	movups	(%r8), %xmm3
     3c4: 41 0f 10 60 10               	movups	0x10(%r8), %xmm4
     3c9: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
     3cd: 48 83 fe 20                  	cmpq	$0x20, %rsi
     3d1: 73 1d                        	jae	 <L0>
     3d3: 48 c7 85 40 ff ff ff 00 00 00 00     	movq	$0x0, -0xc0(%rbp)
     3de: 48 89 d8                     	movq	%rbx, %rax
     3e1: 48 83 e0 1f                  	andq	$0x1f, %rax
     3e5: 0f 85 8e 03 00 00            	jne	 <L16>
     3eb: e9 61 07 00 00               	jmp	 <L39>
<L0>:
     3f0: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
     3f7: 0f 29 9d 90 fd ff ff         	movaps	%xmm3, -0x270(%rbp)
     3fe: 4c 89 65 c8                  	movq	%r12, -0x38(%rbp)
     402: 4c 8d a5 d8 fd ff ff         	leaq	-0x228(%rbp), %r12
     409: 41 0f 10 00                  	movups	(%r8), %xmm0
     40d: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
     412: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x79>
		0000000000000415:  R_X86_64_PC32	.LCPI2_0-0x4
     419: 0f 28 d8                     	movaps	%xmm0, %xmm3
     41c: 0f 57 da                     	xorps	%xmm2, %xmm3
     41f: 0f 28 e1                     	movaps	%xmm1, %xmm4
     422: 0f 57 e2                     	xorps	%xmm2, %xmm4
     425: 0f 29 9d 20 fe ff ff         	movaps	%xmm3, -0x1e0(%rbp)
     42c: 0f 29 a5 30 fe ff ff         	movaps	%xmm4, -0x1d0(%rbp)
     433: 0f 29 95 40 fe ff ff         	movaps	%xmm2, -0x1c0(%rbp)
     43a: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
     441: 0f 28 15 00 00 00 00         	movaps	, %xmm2 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xa8>
		0000000000000444:  R_X86_64_PC32	.LCPI2_1-0x4
     448: 0f 57 c2                     	xorps	%xmm2, %xmm0
     44b: 0f 57 ca                     	xorps	%xmm2, %xmm1
     44e: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     455: 0f 29 8d 60 ff ff ff         	movaps	%xmm1, -0xa0(%rbp)
     45c: 0f 29 95 70 ff ff ff         	movaps	%xmm2, -0x90(%rbp)
     463: 0f 29 55 80                  	movaps	%xmm2, -0x80(%rbp)
     467: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xce>
		000000000000046a:  R_X86_64_PC32	.rodata-0x4
     46e: 0f 29 85 b0 fd ff ff         	movaps	%xmm0, -0x250(%rbp)
     475: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xdc>
		0000000000000478:  R_X86_64_PC32	.rodata+0xc
     47c: 0f 29 85 c0 fd ff ff         	movaps	%xmm0, -0x240(%rbp)
     483: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xea>
		0000000000000486:  R_X86_64_PC32	.rodata+0x1c
     48a: 0f 29 85 d0 fd ff ff         	movaps	%xmm0, -0x230(%rbp)
     491: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xf8>
		0000000000000494:  R_X86_64_PC32	.rodata+0x2c
     498: 0f 29 85 e0 fd ff ff         	movaps	%xmm0, -0x220(%rbp)
     49f: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x106>
		00000000000004a2:  R_X86_64_PC32	.rodata+0x3c
     4a6: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
     4ad: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x114>
		00000000000004b0:  R_X86_64_PC32	.rodata+0x4c
     4b4: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
     4bb: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x122>
		00000000000004be:  R_X86_64_PC32	.rodata+0x5c
     4c2: 0f 29 85 10 fe ff ff         	movaps	%xmm0, -0x1f0(%rbp)
     4c9: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     4d0: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
     4d7: e8 b4 07 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     4dc: 48 83 85 d0 fd ff ff 40      	addq	$0x40, -0x230(%rbp)
     4e4: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
     4eb: 48 85 ff                     	testq	%rdi, %rdi
     4ee: 4c 89 b5 48 ff ff ff         	movq	%r14, -0xb8(%rbp)
     4f5: 48 89 9d 38 ff ff ff         	movq	%rbx, -0xc8(%rbp)
     4fc: 74 3d                        	je	 <L2>
     4fe: 4c 89 e8                     	movq	%r13, %rax
     501: 48 83 f0 3f                  	xorq	$0x3f, %rax
     505: 48 39 f8                     	cmpq	%rdi, %rax
     508: 73 33                        	jae	 <L3>
     50a: bb 40 00 00 00               	movl	$0x40, %ebx
     50f: 48 29 fb                     	subq	%rdi, %rbx
     512: 4c 01 e7                     	addq	%r12, %rdi
     515: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     519: 48 89 da                     	movq	%rbx, %rdx
     51c: e8 00 00 00 00               	callq	 <L1>
		000000000000051d:  R_X86_64_PLT32	memcpy-0x4
<L1>:
     521: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     528: 4c 89 e6                     	movq	%r12, %rsi
     52b: e8 60 07 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     530: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
     537: 31 ff                        	xorl	%edi, %edi
     539: eb 04                        	jmp	 <L4>
<L2>:
     53b: 31 ff                        	xorl	%edi, %edi
<L3>:
     53d: 31 db                        	xorl	%ebx, %ebx
<L4>:
     53f: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
     543: 48 8d 34 18                  	leaq	(%rax,%rbx), %rsi
     547: 4d 89 ef                     	movq	%r13, %r15
     54a: 49 29 df                     	subq	%rbx, %r15
     54d: 40 0f b6 ff                  	movzbl	%dil, %edi
     551: 4c 01 e7                     	addq	%r12, %rdi
     554: 4c 89 fa                     	movq	%r15, %rdx
     557: e8 00 00 00 00               	callq	 <L5>
		0000000000000558:  R_X86_64_PLT32	memcpy-0x4
<L5>:
     55c: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
     563: 4c 01 ff                     	addq	%r15, %rdi
     566: 40 88 bd 18 fe ff ff         	movb	%dil, -0x1e8(%rbp)
     56d: 4c 8b b5 d0 fd ff ff         	movq	-0x230(%rbp), %r14
     574: 4d 01 ee                     	addq	%r13, %r14
     577: 4c 89 b5 d0 fd ff ff         	movq	%r14, -0x230(%rbp)
     57e: 40 84 ff                     	testb	%dil, %dil
     581: 4c 89 ad 30 ff ff ff         	movq	%r13, -0xd0(%rbp)
     588: 74 3f                        	je	 <L7>
     58a: 40 80 ff 3f                  	cmpb	$0x3f, %dil
     58e: 72 3b                        	jb	 <L8>
     590: b0 40                        	movb	$0x40, %al
     592: 40 28 f8                     	subb	%dil, %al
     595: 44 0f b6 f8                  	movzbl	%al, %r15d
     599: 4c 01 e7                     	addq	%r12, %rdi
     59c: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     5a0: 4c 89 fa                     	movq	%r15, %rdx
     5a3: e8 00 00 00 00               	callq	 <L6>
		00000000000005a4:  R_X86_64_PLT32	memcpy-0x4
<L6>:
     5a8: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     5af: 4c 89 e6                     	movq	%r12, %rsi
     5b2: e8 d9 06 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     5b7: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
     5be: 31 ff                        	xorl	%edi, %edi
     5c0: 4c 8b b5 d0 fd ff ff         	movq	-0x230(%rbp), %r14
     5c7: eb 05                        	jmp	 <L9>
<L7>:
     5c9: 31 ff                        	xorl	%edi, %edi
<L8>:
     5cb: 45 31 ff                     	xorl	%r15d, %r15d
<L9>:
     5ce: 48 8d 9d 78 ff ff ff         	leaq	-0x88(%rbp), %rbx
     5d5: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     5d9: 48 83 c6 d7                  	addq	$-0x29, %rsi
     5dd: 41 bd 01 00 00 00            	movl	$0x1, %r13d
     5e3: 4d 29 fd                     	subq	%r15, %r13
     5e6: 40 0f b6 c7                  	movzbl	%dil, %eax
     5ea: 49 01 c4                     	addq	%rax, %r12
     5ed: 4c 89 e7                     	movq	%r12, %rdi
     5f0: 4c 89 ea                     	movq	%r13, %rdx
     5f3: e8 00 00 00 00               	callq	 <L10>
		00000000000005f4:  R_X86_64_PLT32	memcpy-0x4
<L10>:
     5f8: 44 00 ad 18 fe ff ff         	addb	%r13b, -0x1e8(%rbp)
     5ff: 49 83 c6 01                  	addq	$0x1, %r14
     603: 4c 89 b5 d0 fd ff ff         	movq	%r14, -0x230(%rbp)
     60a: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     611: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     618: e8 53 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     61d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x284>
		0000000000000620:  R_X86_64_PC32	.rodata+0x5c
     624: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     628: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x28f>
		000000000000062b:  R_X86_64_PC32	.rodata+0x4c
     62f: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     633: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x29a>
		0000000000000636:  R_X86_64_PC32	.rodata+0x3c
     63a: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     63e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2a5>
		0000000000000641:  R_X86_64_PC32	.rodata+0x2c
     645: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     649: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2b0>
		000000000000064c:  R_X86_64_PC32	.rodata+0x1c
     650: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     657: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2be>
		000000000000065a:  R_X86_64_PC32	.rodata+0xc
     65e: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     665: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2cc>
		0000000000000668:  R_X86_64_PC32	.rodata-0x4
     66c: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     673: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     67a: 48 8d b5 20 fe ff ff         	leaq	-0x1e0(%rbp), %rsi
     681: e8 0a 06 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     686: 0f b6 7d b8                  	movzbl	-0x48(%rbp), %edi
     68a: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     691: 49 83 c5 40                  	addq	$0x40, %r13
     695: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     69c: 48 85 ff                     	testq	%rdi, %rdi
     69f: 74 46                        	je	 <L12>
     6a1: 40 80 ff 20                  	cmpb	$0x20, %dil
     6a5: 4c 8b b5 48 ff ff ff         	movq	-0xb8(%rbp), %r14
     6ac: 72 47                        	jb	 <L13>
     6ae: 41 bf 40 00 00 00            	movl	$0x40, %r15d
     6b4: 49 29 ff                     	subq	%rdi, %r15
     6b7: 48 01 df                     	addq	%rbx, %rdi
     6ba: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     6c1: 4c 89 fa                     	movq	%r15, %rdx
     6c4: e8 00 00 00 00               	callq	 <L11>
		00000000000006c5:  R_X86_64_PLT32	memcpy-0x4
<L11>:
     6c9: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     6d0: 48 89 de                     	movq	%rbx, %rsi
     6d3: e8 b8 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     6d8: c6 45 b8 00                  	movb	$0x0, -0x48(%rbp)
     6dc: 31 ff                        	xorl	%edi, %edi
     6de: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     6e5: eb 11                        	jmp	 <L14>
<L12>:
     6e7: 31 ff                        	xorl	%edi, %edi
     6e9: 45 31 ff                     	xorl	%r15d, %r15d
     6ec: 4c 8b b5 48 ff ff ff         	movq	-0xb8(%rbp), %r14
     6f3: eb 03                        	jmp	 <L14>
<L13>:
     6f5: 45 31 ff                     	xorl	%r15d, %r15d
<L14>:
     6f8: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     6fc: 48 81 c6 60 fe ff ff         	addq	$-0x1a0, %rsi           # imm = 0xFE60
     703: b8 20 00 00 00               	movl	$0x20, %eax
     708: 48 89 85 40 ff ff ff         	movq	%rax, -0xc0(%rbp)
     70f: 41 bc 20 00 00 00            	movl	$0x20, %r12d
     715: 4d 29 fc                     	subq	%r15, %r12
     718: 40 0f b6 c7                  	movzbl	%dil, %eax
     71c: 48 01 c3                     	addq	%rax, %rbx
     71f: 48 89 df                     	movq	%rbx, %rdi
     722: 4c 89 e2                     	movq	%r12, %rdx
     725: e8 00 00 00 00               	callq	 <L15>
		0000000000000726:  R_X86_64_PLT32	memcpy-0x4
<L15>:
     72a: 44 00 65 b8                  	addb	%r12b, -0x48(%rbp)
     72e: 49 83 c5 20                  	addq	$0x20, %r13
     732: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     739: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     740: 4c 89 f6                     	movq	%r14, %rsi
     743: e8 28 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     748: c6 45 d7 02                  	movb	$0x2, -0x29(%rbp)
     74c: 4c 8b ad 30 ff ff ff         	movq	-0xd0(%rbp), %r13
     753: 4c 8b 65 c8                  	movq	-0x38(%rbp), %r12
     757: 48 8b 9d 38 ff ff ff         	movq	-0xc8(%rbp), %rbx
     75e: 0f 28 9d 90 fd ff ff         	movaps	-0x270(%rbp), %xmm3
     765: 0f 28 a5 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm4
     76c: 48 89 d8                     	movq	%rbx, %rax
     76f: 48 83 e0 1f                  	andq	$0x1f, %rax
     773: 0f 84 d8 03 00 00            	je	 <L39>
<L16>:
     779: 48 89 45 c8                  	movq	%rax, -0x38(%rbp)
     77d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x3e4>
		0000000000000780:  R_X86_64_PC32	.LCPI2_0-0x4
     784: 0f 28 cb                     	movaps	%xmm3, %xmm1
     787: 0f 57 c8                     	xorps	%xmm0, %xmm1
     78a: 0f 28 d4                     	movaps	%xmm4, %xmm2
     78d: 0f 57 d0                     	xorps	%xmm0, %xmm2
     790: 0f 29 8d f0 fe ff ff         	movaps	%xmm1, -0x110(%rbp)
     797: 0f 29 95 00 ff ff ff         	movaps	%xmm2, -0x100(%rbp)
     79e: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     7a5: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
     7ac: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x413>
		00000000000007af:  R_X86_64_PC32	.LCPI2_1-0x4
     7b3: 0f 57 d8                     	xorps	%xmm0, %xmm3
     7b6: 0f 57 e0                     	xorps	%xmm0, %xmm4
     7b9: 0f 29 9d 50 ff ff ff         	movaps	%xmm3, -0xb0(%rbp)
     7c0: 0f 29 a5 60 ff ff ff         	movaps	%xmm4, -0xa0(%rbp)
     7c7: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     7ce: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     7d2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x439>
		00000000000007d5:  R_X86_64_PC32	.rodata-0x4
     7d9: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
     7e0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x447>
		00000000000007e3:  R_X86_64_PC32	.rodata+0xc
     7e7: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
     7ee: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x455>
		00000000000007f1:  R_X86_64_PC32	.rodata+0x1c
     7f5: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
     7fc: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x463>
		00000000000007ff:  R_X86_64_PC32	.rodata+0x2c
     803: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
     80a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x471>
		000000000000080d:  R_X86_64_PC32	.rodata+0x3c
     811: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
     818: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x47f>
		000000000000081b:  R_X86_64_PC32	.rodata+0x4c
     81f: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
     826: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x48d>
		0000000000000829:  R_X86_64_PC32	.rodata+0x5c
     82d: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
     834: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     83b: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
     842: e8 49 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     847: 48 83 85 a0 fe ff ff 40      	addq	$0x40, -0x160(%rbp)
     84f: 0f b6 85 e8 fe ff ff         	movzbl	-0x118(%rbp), %eax
     856: 48 83 fb 1f                  	cmpq	$0x1f, %rbx
     85a: 0f 86 8a 00 00 00            	jbe	 <L22>
     860: 84 c0                        	testb	%al, %al
     862: 74 46                        	je	 <L18>
     864: 3c 20                        	cmpb	$0x20, %al
     866: 72 44                        	jb	 <L19>
     868: 0f b6 c0                     	movzbl	%al, %eax
     86b: bb 40 00 00 00               	movl	$0x40, %ebx
     870: 48 29 c3                     	subq	%rax, %rbx
     873: 4c 8d bd a8 fe ff ff         	leaq	-0x158(%rbp), %r15
     87a: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     87e: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     885: 4c 89 f6                     	movq	%r14, %rsi
     888: 48 89 da                     	movq	%rbx, %rdx
     88b: e8 00 00 00 00               	callq	 <L17>
		000000000000088c:  R_X86_64_PLT32	memcpy-0x4
<L17>:
     890: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     897: 4c 89 fe                     	movq	%r15, %rsi
     89a: e8 f1 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     89f: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     8a6: 31 c0                        	xorl	%eax, %eax
     8a8: eb 04                        	jmp	 <L20>
<L18>:
     8aa: 31 c0                        	xorl	%eax, %eax
<L19>:
     8ac: 31 db                        	xorl	%ebx, %ebx
<L20>:
     8ae: 49 8d 34 1e                  	leaq	(%r14,%rbx), %rsi
     8b2: 41 bf 20 00 00 00            	movl	$0x20, %r15d
     8b8: 49 29 df                     	subq	%rbx, %r15
     8bb: 0f b6 c0                     	movzbl	%al, %eax
     8be: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     8c2: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     8c9: 4c 89 fa                     	movq	%r15, %rdx
     8cc: e8 00 00 00 00               	callq	 <L21>
		00000000000008cd:  R_X86_64_PLT32	memcpy-0x4
<L21>:
     8d1: 44 02 bd e8 fe ff ff         	addb	-0x118(%rbp), %r15b
     8d8: 44 88 bd e8 fe ff ff         	movb	%r15b, -0x118(%rbp)
     8df: 48 83 85 a0 fe ff ff 20      	addq	$0x20, -0x160(%rbp)
     8e7: 44 89 f8                     	movl	%r15d, %eax
<L22>:
     8ea: 84 c0                        	testb	%al, %al
     8ec: 74 4b                        	je	 <L24>
     8ee: 0f b6 c8                     	movzbl	%al, %ecx
     8f1: 4a 8d 14 29                  	leaq	(%rcx,%r13), %rdx
     8f5: 48 83 fa 40                  	cmpq	$0x40, %rdx
     8f9: 72 40                        	jb	 <L25>
     8fb: b2 40                        	movb	$0x40, %dl
     8fd: 28 c2                        	subb	%al, %dl
     8ff: 0f b6 da                     	movzbl	%dl, %ebx
     902: 4c 8d bd a8 fe ff ff         	leaq	-0x158(%rbp), %r15
     909: 48 8d 3c 29                  	leaq	(%rcx,%rbp), %rdi
     90d: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     914: 4c 89 e6                     	movq	%r12, %rsi
     917: 48 89 da                     	movq	%rbx, %rdx
     91a: e8 00 00 00 00               	callq	 <L23>
		000000000000091b:  R_X86_64_PLT32	memcpy-0x4
<L23>:
     91f: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     926: 4c 89 fe                     	movq	%r15, %rsi
     929: e8 62 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     92e: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     935: 31 c0                        	xorl	%eax, %eax
     937: eb 04                        	jmp	 <L26>
<L24>:
     939: 31 c0                        	xorl	%eax, %eax
<L25>:
     93b: 31 db                        	xorl	%ebx, %ebx
<L26>:
     93d: 49 01 dc                     	addq	%rbx, %r12
     940: 4d 89 ef                     	movq	%r13, %r15
     943: 49 29 df                     	subq	%rbx, %r15
     946: 48 8d 9d a8 fe ff ff         	leaq	-0x158(%rbp), %rbx
     94d: 0f b6 c0                     	movzbl	%al, %eax
     950: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     954: 48 81 c7 a8 fe ff ff         	addq	$-0x158, %rdi           # imm = 0xFEA8
     95b: 4c 89 e6                     	movq	%r12, %rsi
     95e: 4c 89 fa                     	movq	%r15, %rdx
     961: e8 00 00 00 00               	callq	 <L27>
		0000000000000962:  R_X86_64_PLT32	memcpy-0x4
<L27>:
     966: 0f b6 bd e8 fe ff ff         	movzbl	-0x118(%rbp), %edi
     96d: 4c 01 ff                     	addq	%r15, %rdi
     970: 40 88 bd e8 fe ff ff         	movb	%dil, -0x118(%rbp)
     977: 4c 03 ad a0 fe ff ff         	addq	-0x160(%rbp), %r13
     97e: 4c 89 ad a0 fe ff ff         	movq	%r13, -0x160(%rbp)
     985: 40 84 ff                     	testb	%dil, %dil
     988: 74 3f                        	je	 <L29>
     98a: 40 80 ff 3f                  	cmpb	$0x3f, %dil
     98e: 72 40                        	jb	 <L30>
     990: b0 40                        	movb	$0x40, %al
     992: 40 28 f8                     	subb	%dil, %al
     995: 44 0f b6 f8                  	movzbl	%al, %r15d
     999: 48 01 df                     	addq	%rbx, %rdi
     99c: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     9a0: 4c 89 fa                     	movq	%r15, %rdx
     9a3: e8 00 00 00 00               	callq	 <L28>
		00000000000009a4:  R_X86_64_PLT32	memcpy-0x4
<L28>:
     9a8: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     9af: 48 89 de                     	movq	%rbx, %rsi
     9b2: e8 d9 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     9b7: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     9be: 31 ff                        	xorl	%edi, %edi
     9c0: 4c 8b a5 a0 fe ff ff         	movq	-0x160(%rbp), %r12
     9c7: eb 0d                        	jmp	 <L32>
<L29>:
     9c9: 4d 89 ec                     	movq	%r13, %r12
     9cc: 31 ff                        	xorl	%edi, %edi
     9ce: eb 03                        	jmp	 <L31>
<L30>:
     9d0: 4d 89 ec                     	movq	%r13, %r12
<L31>:
     9d3: 45 31 ff                     	xorl	%r15d, %r15d
<L32>:
     9d6: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     9da: 48 83 c6 d7                  	addq	$-0x29, %rsi
     9de: 41 bd 01 00 00 00            	movl	$0x1, %r13d
     9e4: 4d 29 fd                     	subq	%r15, %r13
     9e7: 40 0f b6 c7                  	movzbl	%dil, %eax
     9eb: 48 01 c3                     	addq	%rax, %rbx
     9ee: 48 89 df                     	movq	%rbx, %rdi
     9f1: 4c 89 ea                     	movq	%r13, %rdx
     9f4: e8 00 00 00 00               	callq	 <L33>
		00000000000009f5:  R_X86_64_PLT32	memcpy-0x4
<L33>:
     9f9: 44 00 ad e8 fe ff ff         	addb	%r13b, -0x118(%rbp)
     a00: 49 83 c4 01                  	addq	$0x1, %r12
     a04: 4c 89 a5 a0 fe ff ff         	movq	%r12, -0x160(%rbp)
     a0b: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     a12: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     a19: e8 52 01 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     a1e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x685>
		0000000000000a21:  R_X86_64_PC32	.rodata+0x5c
     a25: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     a29: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x690>
		0000000000000a2c:  R_X86_64_PC32	.rodata+0x4c
     a30: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     a34: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x69b>
		0000000000000a37:  R_X86_64_PC32	.rodata+0x3c
     a3b: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     a3f: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6a6>
		0000000000000a42:  R_X86_64_PC32	.rodata+0x2c
     a46: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     a4a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6b1>
		0000000000000a4d:  R_X86_64_PC32	.rodata+0x1c
     a51: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     a58: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6bf>
		0000000000000a5b:  R_X86_64_PC32	.rodata+0xc
     a5f: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     a66: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6cd>
		0000000000000a69:  R_X86_64_PC32	.rodata-0x4
     a6d: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     a74: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     a7b: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     a82: e8 09 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     a87: 0f b6 7d b8                  	movzbl	-0x48(%rbp), %edi
     a8b: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     a92: 49 83 c5 40                  	addq	$0x40, %r13
     a96: 48 8d 9d 78 ff ff ff         	leaq	-0x88(%rbp), %rbx
     a9d: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     aa4: 4d 89 f4                     	movq	%r14, %r12
     aa7: 48 85 ff                     	testq	%rdi, %rdi
     aaa: 74 3f                        	je	 <L35>
     aac: 40 80 ff 20                  	cmpb	$0x20, %dil
     ab0: 72 3b                        	jb	 <L36>
     ab2: 41 be 40 00 00 00            	movl	$0x40, %r14d
     ab8: 49 29 fe                     	subq	%rdi, %r14
     abb: 48 01 df                     	addq	%rbx, %rdi
     abe: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     ac5: 4c 89 f2                     	movq	%r14, %rdx
     ac8: e8 00 00 00 00               	callq	 <L34>
		0000000000000ac9:  R_X86_64_PLT32	memcpy-0x4
<L34>:
     acd: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     ad4: 48 89 de                     	movq	%rbx, %rsi
     ad7: e8 b4 01 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     adc: c6 45 b8 00                  	movb	$0x0, -0x48(%rbp)
     ae0: 31 ff                        	xorl	%edi, %edi
     ae2: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     ae9: eb 05                        	jmp	 <L37>
<L35>:
     aeb: 31 ff                        	xorl	%edi, %edi
<L36>:
     aed: 45 31 f6                     	xorl	%r14d, %r14d
<L37>:
     af0: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
     af4: 48 81 c6 60 fe ff ff         	addq	$-0x1a0, %rsi           # imm = 0xFE60
     afb: 41 bf 20 00 00 00            	movl	$0x20, %r15d
     b01: 4d 29 f7                     	subq	%r14, %r15
     b04: 40 0f b6 c7                  	movzbl	%dil, %eax
     b08: 48 01 c3                     	addq	%rax, %rbx
     b0b: 48 89 df                     	movq	%rbx, %rdi
     b0e: 4c 89 fa                     	movq	%r15, %rdx
     b11: e8 00 00 00 00               	callq	 <L38>
		0000000000000b12:  R_X86_64_PLT32	memcpy-0x4
<L38>:
     b16: 44 00 7d b8                  	addb	%r15b, -0x48(%rbp)
     b1a: 49 83 c5 20                  	addq	$0x20, %r13
     b1e: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     b25: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     b2c: 48 8d 9d 70 fd ff ff         	leaq	-0x290(%rbp), %rbx
     b33: 48 89 de                     	movq	%rbx, %rsi
     b36: e8 35 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
     b3b: 4c 03 a5 40 ff ff ff         	addq	-0xc0(%rbp), %r12
     b42: 4c 89 e7                     	movq	%r12, %rdi
     b45: 48 89 de                     	movq	%rbx, %rsi
     b48: 48 8b 55 c8                  	movq	-0x38(%rbp), %rdx
     b4c: e8 00 00 00 00               	callq	 <L39>
		0000000000000b4d:  R_X86_64_PLT32	memcpy-0x4
<L39>:
     b51: 48 81 c4 68 02 00 00         	addq	$0x268, %rsp            # imm = 0x268
     b58: 5b                           	popq	%rbx
     b59: 41 5c                        	popq	%r12
     b5b: 41 5d                        	popq	%r13
     b5d: 41 5e                        	popq	%r14
     b5f: 41 5f                        	popq	%r15
     b61: 5d                           	popq	%rbp
     b62: c3                           	retq
     b63: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     b6d: 0f 1f 00                     	nopl	(%rax)

0000000000000b70 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     b70: 55                           	pushq	%rbp
     b71: 48 89 e5                     	movq	%rsp, %rbp
     b74: 41 57                        	pushq	%r15
     b76: 41 56                        	pushq	%r14
     b78: 53                           	pushq	%rbx
     b79: 50                           	pushq	%rax
     b7a: 48 89 f3                     	movq	%rsi, %rbx
     b7d: 49 89 fe                     	movq	%rdi, %r14
     b80: 4c 8d 7f 28                  	leaq	0x28(%rdi), %r15
     b84: 0f b6 47 68                  	movzbl	0x68(%rdi), %eax
     b88: 48 01 c7                     	addq	%rax, %rdi
     b8b: 48 83 c7 28                  	addq	$0x28, %rdi
     b8f: ba 40 00 00 00               	movl	$0x40, %edx
     b94: 48 29 c2                     	subq	%rax, %rdx
     b97: 31 f6                        	xorl	%esi, %esi
     b99: e8 00 00 00 00               	callq	 <L0>
		0000000000000b9a:  R_X86_64_PLT32	memset-0x4
<L0>:
     b9e: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
     ba3: 41 c6 44 06 28 80            	movb	$-0x80, 0x28(%r14,%rax)
     ba9: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
     bae: 8d 48 01                     	leal	0x1(%rax), %ecx
     bb1: 41 88 4e 68                  	movb	%cl, 0x68(%r14)
     bb5: 3c 37                        	cmpb	$0x37, %al
     bb7: 76 24                        	jbe	 <L1>
     bb9: 4c 89 f7                     	movq	%r14, %rdi
     bbc: 4c 89 fe                     	movq	%r15, %rsi
     bbf: e8 cc 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     bc4: 0f 57 c0                     	xorps	%xmm0, %xmm0
     bc7: 41 0f 11 47 20               	movups	%xmm0, 0x20(%r15)
     bcc: 41 0f 11 47 10               	movups	%xmm0, 0x10(%r15)
     bd1: 41 0f 11 07                  	movups	%xmm0, (%r15)
     bd5: 49 c7 47 30 00 00 00 00      	movq	$0x0, 0x30(%r15)
<L1>:
     bdd: 49 8b 46 20                  	movq	0x20(%r14), %rax
     be1: 89 c1                        	movl	%eax, %ecx
     be3: c1 e9 05                     	shrl	$0x5, %ecx
     be6: 8d 14 c5 00 00 00 00         	leal	(,%rax,8), %edx
     bed: 41 88 56 67                  	movb	%dl, 0x67(%r14)
     bf1: 41 88 4e 66                  	movb	%cl, 0x66(%r14)
     bf5: 89 c1                        	movl	%eax, %ecx
     bf7: c1 e9 0d                     	shrl	$0xd, %ecx
     bfa: 41 88 4e 65                  	movb	%cl, 0x65(%r14)
     bfe: 89 c1                        	movl	%eax, %ecx
     c00: c1 e9 15                     	shrl	$0x15, %ecx
     c03: 41 88 4e 64                  	movb	%cl, 0x64(%r14)
     c07: 48 89 c1                     	movq	%rax, %rcx
     c0a: 48 c1 e9 1d                  	shrq	$0x1d, %rcx
     c0e: 41 88 4e 63                  	movb	%cl, 0x63(%r14)
     c12: 48 89 c1                     	movq	%rax, %rcx
     c15: 48 c1 e9 25                  	shrq	$0x25, %rcx
     c19: 41 88 4e 62                  	movb	%cl, 0x62(%r14)
     c1d: 48 89 c1                     	movq	%rax, %rcx
     c20: 48 c1 e9 2d                  	shrq	$0x2d, %rcx
     c24: 41 88 4e 61                  	movb	%cl, 0x61(%r14)
     c28: 48 c1 e8 35                  	shrq	$0x35, %rax
     c2c: 41 88 46 60                  	movb	%al, 0x60(%r14)
     c30: 4c 89 f7                     	movq	%r14, %rdi
     c33: 4c 89 fe                     	movq	%r15, %rsi
     c36: e8 55 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
     c3b: 41 8b 06                     	movl	(%r14), %eax
     c3e: 0f c8                        	bswapl	%eax
     c40: 89 03                        	movl	%eax, (%rbx)
     c42: 41 8b 46 04                  	movl	0x4(%r14), %eax
     c46: 0f c8                        	bswapl	%eax
     c48: 89 43 04                     	movl	%eax, 0x4(%rbx)
     c4b: 41 8b 46 08                  	movl	0x8(%r14), %eax
     c4f: 0f c8                        	bswapl	%eax
     c51: 89 43 08                     	movl	%eax, 0x8(%rbx)
     c54: 41 8b 46 0c                  	movl	0xc(%r14), %eax
     c58: 0f c8                        	bswapl	%eax
     c5a: 89 43 0c                     	movl	%eax, 0xc(%rbx)
     c5d: 41 8b 46 10                  	movl	0x10(%r14), %eax
     c61: 0f c8                        	bswapl	%eax
     c63: 89 43 10                     	movl	%eax, 0x10(%rbx)
     c66: 41 8b 46 14                  	movl	0x14(%r14), %eax
     c6a: 0f c8                        	bswapl	%eax
     c6c: 89 43 14                     	movl	%eax, 0x14(%rbx)
     c6f: 41 8b 46 18                  	movl	0x18(%r14), %eax
     c73: 0f c8                        	bswapl	%eax
     c75: 89 43 18                     	movl	%eax, 0x18(%rbx)
     c78: 41 8b 46 1c                  	movl	0x1c(%r14), %eax
     c7c: 0f c8                        	bswapl	%eax
     c7e: 89 43 1c                     	movl	%eax, 0x1c(%rbx)
     c81: 48 83 c4 08                  	addq	$0x8, %rsp
     c85: 5b                           	popq	%rbx
     c86: 41 5e                        	popq	%r14
     c88: 41 5f                        	popq	%r15
     c8a: 5d                           	popq	%rbp
     c8b: c3                           	retq
     c8c: 0f 1f 40 00                  	nopl	(%rax)

0000000000000c90 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     c90: 55                           	pushq	%rbp
     c91: 48 89 e5                     	movq	%rsp, %rbp
     c94: 41 57                        	pushq	%r15
     c96: 41 56                        	pushq	%r14
     c98: 41 55                        	pushq	%r13
     c9a: 41 54                        	pushq	%r12
     c9c: 53                           	pushq	%rbx
     c9d: 48 81 ec 28 09 00 00         	subq	$0x928, %rsp            # imm = 0x928
     ca4: 48 89 bd c8 fe ff ff         	movq	%rdi, -0x138(%rbp)
     cab: 4c 8d a5 d0 fe ff ff         	leaq	-0x130(%rbp), %r12
     cb2: f3 0f 6f 0e                  	movdqu	(%rsi), %xmm1
     cb6: 66 0f ef c0                  	pxor	%xmm0, %xmm0
     cba: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     cbe: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     cc2: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     cc7: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     ccc: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     cd0: f2 0f 70 c9 1b               	pshuflw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[3,2,1,0,4,5,6,7]
     cd5: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
     cda: 66 0f 67 ca                  	packuswb	%xmm2, %xmm1
     cde: 66 0f 7f 8d b0 fe ff ff      	movdqa	%xmm1, -0x150(%rbp)
     ce6: 66 0f 7f 8d d0 fe ff ff      	movdqa	%xmm1, -0x130(%rbp)
     cee: f3 0f 6f 4e 10               	movdqu	0x10(%rsi), %xmm1
     cf3: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     cf7: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     cfb: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     d00: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     d05: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     d09: f2 0f 70 c9 1b               	pshuflw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[3,2,1,0,4,5,6,7]
     d0e: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
     d13: 66 0f 67 ca                  	packuswb	%xmm2, %xmm1
     d17: 66 0f 7f 8d e0 fe ff ff      	movdqa	%xmm1, -0x120(%rbp)
     d1f: f3 0f 6f 4e 20               	movdqu	0x20(%rsi), %xmm1
     d24: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     d28: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     d2c: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     d31: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     d36: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     d3a: f2 0f 70 c9 1b               	pshuflw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[3,2,1,0,4,5,6,7]
     d3f: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
     d44: 66 0f 67 ca                  	packuswb	%xmm2, %xmm1
     d48: 66 0f 7f 8d f0 fe ff ff      	movdqa	%xmm1, -0x110(%rbp)
     d50: f3 0f 6f 4e 30               	movdqu	0x30(%rsi), %xmm1
     d55: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
     d59: 66 0f 68 d0                  	punpckhbw	%xmm0, %xmm2    # xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
     d5d: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
     d62: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
     d67: 66 0f 60 c8                  	punpcklbw	%xmm0, %xmm1    # xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
     d6b: f2 0f 70 c1 1b               	pshuflw	$0x1b, %xmm1, %xmm0     # xmm0 = xmm1[3,2,1,0,4,5,6,7]
     d70: f3 0f 70 c0 1b               	pshufhw	$0x1b, %xmm0, %xmm0     # xmm0 = xmm0[0,1,2,3,7,6,5,4]
     d75: 66 0f 67 c2                  	packuswb	%xmm2, %xmm0
     d79: 66 0f 7f 85 00 ff ff ff      	movdqa	%xmm0, -0x100(%rbp)
     d81: 31 db                        	xorl	%ebx, %ebx
     d83: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     d8d: 0f 1f 00                     	nopl	(%rax)
<L0>:
     d90: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     d95: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     d9c: 4c 89 e6                     	movq	%r12, %rsi
     d9f: e8 00 00 00 00               	callq	 <L1>
		0000000000000da0:  R_X86_64_PLT32	memcpy-0x4
<L1>:
     da4: 44 8b b4 1d b0 fd ff ff      	movl	-0x250(%rbp,%rbx), %r14d
     dac: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     db1: 48 8d bd b0 fc ff ff         	leaq	-0x350(%rbp), %rdi
     db8: 4c 89 e6                     	movq	%r12, %rsi
     dbb: e8 00 00 00 00               	callq	 <L2>
		0000000000000dbc:  R_X86_64_PLT32	memcpy-0x4
<L2>:
     dc0: 44 03 b4 1d d4 fc ff ff      	addl	-0x32c(%rbp,%rbx), %r14d
     dc8: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     dcd: 48 8d bd b0 fb ff ff         	leaq	-0x450(%rbp), %rdi
     dd4: 4c 89 e6                     	movq	%r12, %rsi
     dd7: e8 00 00 00 00               	callq	 <L3>
		0000000000000dd8:  R_X86_64_PLT32	memcpy-0x4
<L3>:
     ddc: 44 8b bc 1d b4 fb ff ff      	movl	-0x44c(%rbp,%rbx), %r15d
     de4: 41 c1 c7 19                  	roll	$0x19, %r15d
     de8: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     ded: 48 8d bd b0 fa ff ff         	leaq	-0x550(%rbp), %rdi
     df4: 4c 89 e6                     	movq	%r12, %rsi
     df7: e8 00 00 00 00               	callq	 <L4>
		0000000000000df8:  R_X86_64_PLT32	memcpy-0x4
<L4>:
     dfc: 44 8b ac 1d b4 fa ff ff      	movl	-0x54c(%rbp,%rbx), %r13d
     e04: 41 c1 c5 0e                  	roll	$0xe, %r13d
     e08: 45 31 fd                     	xorl	%r15d, %r13d
     e0b: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e10: 48 8d bd b0 f9 ff ff         	leaq	-0x650(%rbp), %rdi
     e17: 4c 89 e6                     	movq	%r12, %rsi
     e1a: e8 00 00 00 00               	callq	 <L5>
		0000000000000e1b:  R_X86_64_PLT32	memcpy-0x4
<L5>:
     e1f: 44 8b bc 1d b4 f9 ff ff      	movl	-0x64c(%rbp,%rbx), %r15d
     e27: 41 c1 ef 03                  	shrl	$0x3, %r15d
     e2b: 45 31 ef                     	xorl	%r13d, %r15d
     e2e: 45 01 f7                     	addl	%r14d, %r15d
     e31: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e36: 48 8d bd b0 f8 ff ff         	leaq	-0x750(%rbp), %rdi
     e3d: 4c 89 e6                     	movq	%r12, %rsi
     e40: e8 00 00 00 00               	callq	 <L6>
		0000000000000e41:  R_X86_64_PLT32	memcpy-0x4
<L6>:
     e45: 44 8b b4 1d e8 f8 ff ff      	movl	-0x718(%rbp,%rbx), %r14d
     e4d: 41 c1 c6 0f                  	roll	$0xf, %r14d
     e51: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e56: 48 8d bd b0 f7 ff ff         	leaq	-0x850(%rbp), %rdi
     e5d: 4c 89 e6                     	movq	%r12, %rsi
     e60: e8 00 00 00 00               	callq	 <L7>
		0000000000000e61:  R_X86_64_PLT32	memcpy-0x4
<L7>:
     e65: 44 8b ac 1d e8 f7 ff ff      	movl	-0x818(%rbp,%rbx), %r13d
     e6d: 41 c1 c5 0d                  	roll	$0xd, %r13d
     e71: 45 31 f5                     	xorl	%r14d, %r13d
     e74: ba 00 01 00 00               	movl	$0x100, %edx            # imm = 0x100
     e79: 48 8d bd b0 f6 ff ff         	leaq	-0x950(%rbp), %rdi
     e80: 4c 89 e6                     	movq	%r12, %rsi
     e83: e8 00 00 00 00               	callq	 <L8>
		0000000000000e84:  R_X86_64_PLT32	memcpy-0x4
<L8>:
     e88: 8b 84 1d e8 f6 ff ff         	movl	-0x918(%rbp,%rbx), %eax
     e8f: c1 e8 0a                     	shrl	$0xa, %eax
     e92: 44 31 e8                     	xorl	%r13d, %eax
     e95: 44 01 f8                     	addl	%r15d, %eax
     e98: 89 84 1d 10 ff ff ff         	movl	%eax, -0xf0(%rbp,%rbx)
     e9f: 48 83 c3 04                  	addq	$0x4, %rbx
     ea3: 48 81 fb c0 00 00 00         	cmpq	$0xc0, %rbx
     eaa: 0f 85 e0 fe ff ff            	jne	 <L0>
     eb0: 4c 8b ad c8 fe ff ff         	movq	-0x138(%rbp), %r13
     eb7: 41 8b 7d 00                  	movl	(%r13), %edi
     ebb: 45 8b 5d 04                  	movl	0x4(%r13), %r11d
     ebf: 45 8b 4d 08                  	movl	0x8(%r13), %r9d
     ec3: 45 8b 55 10                  	movl	0x10(%r13), %r10d
     ec7: 41 8b 4d 14                  	movl	0x14(%r13), %ecx
     ecb: 41 8b 75 18                  	movl	0x18(%r13), %esi
     ecf: 44 89 d0                     	movl	%r10d, %eax
     ed2: c1 c0 1a                     	roll	$0x1a, %eax
     ed5: 44 89 d2                     	movl	%r10d, %edx
     ed8: c1 c2 15                     	roll	$0x15, %edx
     edb: 31 c2                        	xorl	%eax, %edx
     edd: 44 89 d0                     	movl	%r10d, %eax
     ee0: c1 c0 07                     	roll	$0x7, %eax
     ee3: 31 d0                        	xorl	%edx, %eax
     ee5: 89 f2                        	movl	%esi, %edx
     ee7: 31 ca                        	xorl	%ecx, %edx
     ee9: 44 21 d2                     	andl	%r10d, %edx
     eec: 41 03 45 1c                  	addl	0x1c(%r13), %eax
     ef0: 31 f2                        	xorl	%esi, %edx
     ef2: 66 0f 6f 85 b0 fe ff ff      	movdqa	-0x150(%rbp), %xmm0
     efa: 66 41 0f 7e c0               	movd	%xmm0, %r8d
     eff: 41 01 c0                     	addl	%eax, %r8d
     f02: 42 8d 1c 02                  	leal	(%rdx,%r8), %ebx
     f06: 81 c3 98 2f 8a 42            	addl	$0x428a2f98, %ebx       # imm = 0x428A2F98
     f0c: 41 8b 55 0c                  	movl	0xc(%r13), %edx
     f10: 89 f8                        	movl	%edi, %eax
     f12: c1 c0 1e                     	roll	$0x1e, %eax
     f15: 01 da                        	addl	%ebx, %edx
     f17: 41 89 f8                     	movl	%edi, %r8d
     f1a: 41 c1 c0 13                  	roll	$0x13, %r8d
     f1e: 41 31 c0                     	xorl	%eax, %r8d
     f21: 41 89 fe                     	movl	%edi, %r14d
     f24: 41 c1 c6 0a                  	roll	$0xa, %r14d
     f28: 45 31 c6                     	xorl	%r8d, %r14d
     f2b: 41 89 d0                     	movl	%edx, %r8d
     f2e: 41 c1 c0 1a                  	roll	$0x1a, %r8d
     f32: 44 89 c8                     	movl	%r9d, %eax
     f35: 41 89 d4                     	movl	%edx, %r12d
     f38: 41 c1 c4 15                  	roll	$0x15, %r12d
     f3c: 45 31 c4                     	xorl	%r8d, %r12d
     f3f: 41 89 d7                     	movl	%edx, %r15d
     f42: 41 c1 c7 07                  	roll	$0x7, %r15d
     f46: 45 31 e7                     	xorl	%r12d, %r15d
     f49: 41 89 c8                     	movl	%ecx, %r8d
     f4c: 45 31 d0                     	xorl	%r10d, %r8d
     f4f: 41 21 d0                     	andl	%edx, %r8d
     f52: 41 31 c8                     	xorl	%ecx, %r8d
     f55: 03 b5 d4 fe ff ff            	addl	-0x12c(%rbp), %esi
     f5b: 44 01 c6                     	addl	%r8d, %esi
     f5e: 46 8d 04 3e                  	leal	(%rsi,%r15), %r8d
     f62: 45 01 c8                     	addl	%r9d, %r8d
     f65: 41 81 c0 91 44 37 71         	addl	$0x71374491, %r8d       # imm = 0x71374491
     f6c: 45 09 d9                     	orl	%r11d, %r9d
     f6f: 41 21 f9                     	andl	%edi, %r9d
     f72: 44 21 d8                     	andl	%r11d, %eax
     f75: 44 09 c8                     	orl	%r9d, %eax
     f78: 44 01 f0                     	addl	%r14d, %eax
     f7b: 01 d8                        	addl	%ebx, %eax
     f7d: 41 89 c1                     	movl	%eax, %r9d
     f80: 41 c1 c1 1e                  	roll	$0x1e, %r9d
     f84: 41 8d 1c 37                  	leal	(%r15,%rsi), %ebx
     f88: 81 c3 91 44 37 71            	addl	$0x71374491, %ebx       # imm = 0x71374491
     f8e: 89 c6                        	movl	%eax, %esi
     f90: c1 c6 13                     	roll	$0x13, %esi
     f93: 44 31 ce                     	xorl	%r9d, %esi
     f96: 41 89 c6                     	movl	%eax, %r14d
     f99: 41 c1 c6 0a                  	roll	$0xa, %r14d
     f9d: 41 31 f6                     	xorl	%esi, %r14d
     fa0: 45 89 c1                     	movl	%r8d, %r9d
     fa3: 41 c1 c1 1a                  	roll	$0x1a, %r9d
     fa7: 44 89 de                     	movl	%r11d, %esi
     faa: 45 89 c4                     	movl	%r8d, %r12d
     fad: 41 c1 c4 15                  	roll	$0x15, %r12d
     fb1: 45 31 cc                     	xorl	%r9d, %r12d
     fb4: 45 89 c7                     	movl	%r8d, %r15d
     fb7: 41 c1 c7 07                  	roll	$0x7, %r15d
     fbb: 45 31 e7                     	xorl	%r12d, %r15d
     fbe: 41 89 d1                     	movl	%edx, %r9d
     fc1: 45 31 d1                     	xorl	%r10d, %r9d
     fc4: 45 21 c1                     	andl	%r8d, %r9d
     fc7: 45 31 d1                     	xorl	%r10d, %r9d
     fca: 03 8d d8 fe ff ff            	addl	-0x128(%rbp), %ecx
     fd0: 44 01 c9                     	addl	%r9d, %ecx
     fd3: 46 8d 0c 39                  	leal	(%rcx,%r15), %r9d
     fd7: 45 01 d9                     	addl	%r11d, %r9d
     fda: 41 81 c1 cf fb c0 b5         	addl	$0xb5c0fbcf, %r9d       # imm = 0xB5C0FBCF
     fe1: 41 09 fb                     	orl	%edi, %r11d
     fe4: 41 21 c3                     	andl	%eax, %r11d
     fe7: 21 fe                        	andl	%edi, %esi
     fe9: 44 09 de                     	orl	%r11d, %esi
     fec: 44 01 f6                     	addl	%r14d, %esi
     fef: 01 de                        	addl	%ebx, %esi
     ff1: 41 89 f3                     	movl	%esi, %r11d
     ff4: 41 c1 c3 1e                  	roll	$0x1e, %r11d
     ff8: 41 8d 1c 0f                  	leal	(%r15,%rcx), %ebx
     ffc: 81 c3 cf fb c0 b5            	addl	$0xb5c0fbcf, %ebx       # imm = 0xB5C0FBCF
    1002: 89 f1                        	movl	%esi, %ecx
    1004: c1 c1 13                     	roll	$0x13, %ecx
    1007: 44 31 d9                     	xorl	%r11d, %ecx
    100a: 41 89 f3                     	movl	%esi, %r11d
    100d: 41 c1 c3 0a                  	roll	$0xa, %r11d
    1011: 41 31 cb                     	xorl	%ecx, %r11d
    1014: 41 89 c6                     	movl	%eax, %r14d
    1017: 41 09 fe                     	orl	%edi, %r14d
    101a: 41 21 f6                     	andl	%esi, %r14d
    101d: 89 c1                        	movl	%eax, %ecx
    101f: 21 f9                        	andl	%edi, %ecx
    1021: 44 09 f1                     	orl	%r14d, %ecx
    1024: 44 01 d9                     	addl	%r11d, %ecx
    1027: 01 d9                        	addl	%ebx, %ecx
    1029: 45 89 cb                     	movl	%r9d, %r11d
    102c: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1030: 44 89 cb                     	movl	%r9d, %ebx
    1033: c1 c3 15                     	roll	$0x15, %ebx
    1036: 44 31 db                     	xorl	%r11d, %ebx
    1039: 45 89 cb                     	movl	%r9d, %r11d
    103c: 41 c1 c3 07                  	roll	$0x7, %r11d
    1040: 41 31 db                     	xorl	%ebx, %r11d
    1043: 44 89 c3                     	movl	%r8d, %ebx
    1046: 31 d3                        	xorl	%edx, %ebx
    1048: 44 21 cb                     	andl	%r9d, %ebx
    104b: 31 d3                        	xorl	%edx, %ebx
    104d: 44 03 95 dc fe ff ff         	addl	-0x124(%rbp), %r10d
    1054: 41 01 da                     	addl	%ebx, %r10d
    1057: 43 8d 1c 1a                  	leal	(%r10,%r11), %ebx
    105b: 47 8d 34 13                  	leal	(%r11,%r10), %r14d
    105f: 41 81 c6 a5 db b5 e9         	addl	$0xe9b5dba5, %r14d      # imm = 0xE9B5DBA5
    1066: 41 89 ca                     	movl	%ecx, %r10d
    1069: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    106d: 44 8d 1c 1f                  	leal	(%rdi,%rbx), %r11d
    1071: 41 81 c3 a5 db b5 e9         	addl	$0xe9b5dba5, %r11d      # imm = 0xE9B5DBA5
    1078: 89 cf                        	movl	%ecx, %edi
    107a: c1 c7 13                     	roll	$0x13, %edi
    107d: 44 31 d7                     	xorl	%r10d, %edi
    1080: 89 cb                        	movl	%ecx, %ebx
    1082: c1 c3 0a                     	roll	$0xa, %ebx
    1085: 31 fb                        	xorl	%edi, %ebx
    1087: 89 f7                        	movl	%esi, %edi
    1089: 09 c7                        	orl	%eax, %edi
    108b: 21 cf                        	andl	%ecx, %edi
    108d: 41 89 f2                     	movl	%esi, %r10d
    1090: 41 21 c2                     	andl	%eax, %r10d
    1093: 41 09 fa                     	orl	%edi, %r10d
    1096: 41 01 da                     	addl	%ebx, %r10d
    1099: 45 01 f2                     	addl	%r14d, %r10d
    109c: 44 89 df                     	movl	%r11d, %edi
    109f: c1 c7 1a                     	roll	$0x1a, %edi
    10a2: 44 89 db                     	movl	%r11d, %ebx
    10a5: c1 c3 15                     	roll	$0x15, %ebx
    10a8: 31 fb                        	xorl	%edi, %ebx
    10aa: 44 89 df                     	movl	%r11d, %edi
    10ad: c1 c7 07                     	roll	$0x7, %edi
    10b0: 31 df                        	xorl	%ebx, %edi
    10b2: 44 89 cb                     	movl	%r9d, %ebx
    10b5: 44 31 c3                     	xorl	%r8d, %ebx
    10b8: 44 21 db                     	andl	%r11d, %ebx
    10bb: 44 31 c3                     	xorl	%r8d, %ebx
    10be: 03 95 e0 fe ff ff            	addl	-0x120(%rbp), %edx
    10c4: 01 da                        	addl	%ebx, %edx
    10c6: 01 fa                        	addl	%edi, %edx
    10c8: 81 c2 5b c2 56 39            	addl	$0x3956c25b, %edx       # imm = 0x3956C25B
    10ce: 01 d0                        	addl	%edx, %eax
    10d0: 44 89 d7                     	movl	%r10d, %edi
    10d3: c1 c7 1e                     	roll	$0x1e, %edi
    10d6: 44 89 d3                     	movl	%r10d, %ebx
    10d9: c1 c3 13                     	roll	$0x13, %ebx
    10dc: 31 fb                        	xorl	%edi, %ebx
    10de: 45 89 d6                     	movl	%r10d, %r14d
    10e1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    10e5: 41 31 de                     	xorl	%ebx, %r14d
    10e8: 89 cb                        	movl	%ecx, %ebx
    10ea: 09 f3                        	orl	%esi, %ebx
    10ec: 44 21 d3                     	andl	%r10d, %ebx
    10ef: 89 cf                        	movl	%ecx, %edi
    10f1: 21 f7                        	andl	%esi, %edi
    10f3: 09 df                        	orl	%ebx, %edi
    10f5: 44 01 f7                     	addl	%r14d, %edi
    10f8: 01 d7                        	addl	%edx, %edi
    10fa: 89 c2                        	movl	%eax, %edx
    10fc: c1 c2 1a                     	roll	$0x1a, %edx
    10ff: 89 c3                        	movl	%eax, %ebx
    1101: c1 c3 15                     	roll	$0x15, %ebx
    1104: 31 d3                        	xorl	%edx, %ebx
    1106: 89 c2                        	movl	%eax, %edx
    1108: c1 c2 07                     	roll	$0x7, %edx
    110b: 31 da                        	xorl	%ebx, %edx
    110d: 44 89 db                     	movl	%r11d, %ebx
    1110: 44 31 cb                     	xorl	%r9d, %ebx
    1113: 21 c3                        	andl	%eax, %ebx
    1115: 44 03 85 e4 fe ff ff         	addl	-0x11c(%rbp), %r8d
    111c: 44 31 cb                     	xorl	%r9d, %ebx
    111f: 41 01 d8                     	addl	%ebx, %r8d
    1122: 44 01 c2                     	addl	%r8d, %edx
    1125: 81 c2 f1 11 f1 59            	addl	$0x59f111f1, %edx       # imm = 0x59F111F1
    112b: 01 d6                        	addl	%edx, %esi
    112d: 41 89 f8                     	movl	%edi, %r8d
    1130: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1134: 89 fb                        	movl	%edi, %ebx
    1136: c1 c3 13                     	roll	$0x13, %ebx
    1139: 44 31 c3                     	xorl	%r8d, %ebx
    113c: 41 89 fe                     	movl	%edi, %r14d
    113f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1143: 41 31 de                     	xorl	%ebx, %r14d
    1146: 44 89 d3                     	movl	%r10d, %ebx
    1149: 09 cb                        	orl	%ecx, %ebx
    114b: 21 fb                        	andl	%edi, %ebx
    114d: 45 89 d0                     	movl	%r10d, %r8d
    1150: 41 21 c8                     	andl	%ecx, %r8d
    1153: 41 09 d8                     	orl	%ebx, %r8d
    1156: 89 f3                        	movl	%esi, %ebx
    1158: c1 c3 1a                     	roll	$0x1a, %ebx
    115b: 45 01 f0                     	addl	%r14d, %r8d
    115e: 41 89 f6                     	movl	%esi, %r14d
    1161: 41 c1 c6 15                  	roll	$0x15, %r14d
    1165: 41 01 d0                     	addl	%edx, %r8d
    1168: 89 f2                        	movl	%esi, %edx
    116a: c1 c2 07                     	roll	$0x7, %edx
    116d: 41 31 de                     	xorl	%ebx, %r14d
    1170: 44 31 f2                     	xorl	%r14d, %edx
    1173: 89 c3                        	movl	%eax, %ebx
    1175: 44 31 db                     	xorl	%r11d, %ebx
    1178: 21 f3                        	andl	%esi, %ebx
    117a: 44 31 db                     	xorl	%r11d, %ebx
    117d: 44 03 8d e8 fe ff ff         	addl	-0x118(%rbp), %r9d
    1184: 41 01 d9                     	addl	%ebx, %r9d
    1187: 44 89 c3                     	movl	%r8d, %ebx
    118a: c1 c3 1e                     	roll	$0x1e, %ebx
    118d: 41 01 d1                     	addl	%edx, %r9d
    1190: 41 81 c1 a4 82 3f 92         	addl	$0x923f82a4, %r9d       # imm = 0x923F82A4
    1197: 44 89 c2                     	movl	%r8d, %edx
    119a: c1 c2 13                     	roll	$0x13, %edx
    119d: 44 01 c9                     	addl	%r9d, %ecx
    11a0: 45 89 c6                     	movl	%r8d, %r14d
    11a3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    11a7: 31 da                        	xorl	%ebx, %edx
    11a9: 41 31 d6                     	xorl	%edx, %r14d
    11ac: 89 fb                        	movl	%edi, %ebx
    11ae: 44 09 d3                     	orl	%r10d, %ebx
    11b1: 44 21 c3                     	andl	%r8d, %ebx
    11b4: 89 fa                        	movl	%edi, %edx
    11b6: 44 21 d2                     	andl	%r10d, %edx
    11b9: 09 da                        	orl	%ebx, %edx
    11bb: 44 01 f2                     	addl	%r14d, %edx
    11be: 89 cb                        	movl	%ecx, %ebx
    11c0: c1 c3 1a                     	roll	$0x1a, %ebx
    11c3: 44 01 ca                     	addl	%r9d, %edx
    11c6: 41 89 c9                     	movl	%ecx, %r9d
    11c9: 41 c1 c1 15                  	roll	$0x15, %r9d
    11cd: 41 31 d9                     	xorl	%ebx, %r9d
    11d0: 89 cb                        	movl	%ecx, %ebx
    11d2: c1 c3 07                     	roll	$0x7, %ebx
    11d5: 44 31 cb                     	xorl	%r9d, %ebx
    11d8: 41 89 f1                     	movl	%esi, %r9d
    11db: 41 31 c1                     	xorl	%eax, %r9d
    11de: 41 21 c9                     	andl	%ecx, %r9d
    11e1: 41 31 c1                     	xorl	%eax, %r9d
    11e4: 44 03 9d ec fe ff ff         	addl	-0x114(%rbp), %r11d
    11eb: 45 01 cb                     	addl	%r9d, %r11d
    11ee: 46 8d 0c 1b                  	leal	(%rbx,%r11), %r9d
    11f2: 41 81 c1 d5 5e 1c ab         	addl	$0xab1c5ed5, %r9d       # imm = 0xAB1C5ED5
    11f9: 41 89 d3                     	movl	%edx, %r11d
    11fc: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    1200: 45 01 ca                     	addl	%r9d, %r10d
    1203: 89 d3                        	movl	%edx, %ebx
    1205: c1 c3 13                     	roll	$0x13, %ebx
    1208: 44 31 db                     	xorl	%r11d, %ebx
    120b: 41 89 d6                     	movl	%edx, %r14d
    120e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1212: 41 31 de                     	xorl	%ebx, %r14d
    1215: 44 89 c3                     	movl	%r8d, %ebx
    1218: 09 fb                        	orl	%edi, %ebx
    121a: 21 d3                        	andl	%edx, %ebx
    121c: 45 89 c3                     	movl	%r8d, %r11d
    121f: 41 21 fb                     	andl	%edi, %r11d
    1222: 41 09 db                     	orl	%ebx, %r11d
    1225: 45 01 f3                     	addl	%r14d, %r11d
    1228: 45 01 cb                     	addl	%r9d, %r11d
    122b: 45 89 d1                     	movl	%r10d, %r9d
    122e: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    1232: 44 89 d3                     	movl	%r10d, %ebx
    1235: c1 c3 15                     	roll	$0x15, %ebx
    1238: 44 31 cb                     	xorl	%r9d, %ebx
    123b: 45 89 d1                     	movl	%r10d, %r9d
    123e: 41 c1 c1 07                  	roll	$0x7, %r9d
    1242: 41 31 d9                     	xorl	%ebx, %r9d
    1245: 89 cb                        	movl	%ecx, %ebx
    1247: 31 f3                        	xorl	%esi, %ebx
    1249: 44 21 d3                     	andl	%r10d, %ebx
    124c: 31 f3                        	xorl	%esi, %ebx
    124e: 03 85 f0 fe ff ff            	addl	-0x110(%rbp), %eax
    1254: 01 d8                        	addl	%ebx, %eax
    1256: 44 01 c8                     	addl	%r9d, %eax
    1259: 05 98 aa 07 d8               	addl	$0xd807aa98, %eax       # imm = 0xD807AA98
    125e: 01 c7                        	addl	%eax, %edi
    1260: 45 89 d9                     	movl	%r11d, %r9d
    1263: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1267: 44 89 db                     	movl	%r11d, %ebx
    126a: c1 c3 13                     	roll	$0x13, %ebx
    126d: 44 31 cb                     	xorl	%r9d, %ebx
    1270: 45 89 de                     	movl	%r11d, %r14d
    1273: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1277: 41 31 de                     	xorl	%ebx, %r14d
    127a: 89 d3                        	movl	%edx, %ebx
    127c: 44 09 c3                     	orl	%r8d, %ebx
    127f: 44 21 db                     	andl	%r11d, %ebx
    1282: 41 89 d1                     	movl	%edx, %r9d
    1285: 45 21 c1                     	andl	%r8d, %r9d
    1288: 41 09 d9                     	orl	%ebx, %r9d
    128b: 45 01 f1                     	addl	%r14d, %r9d
    128e: 41 01 c1                     	addl	%eax, %r9d
    1291: 89 f8                        	movl	%edi, %eax
    1293: c1 c0 1a                     	roll	$0x1a, %eax
    1296: 89 fb                        	movl	%edi, %ebx
    1298: c1 c3 15                     	roll	$0x15, %ebx
    129b: 31 c3                        	xorl	%eax, %ebx
    129d: 89 f8                        	movl	%edi, %eax
    129f: c1 c0 07                     	roll	$0x7, %eax
    12a2: 31 d8                        	xorl	%ebx, %eax
    12a4: 44 89 d3                     	movl	%r10d, %ebx
    12a7: 31 cb                        	xorl	%ecx, %ebx
    12a9: 21 fb                        	andl	%edi, %ebx
    12ab: 03 b5 f4 fe ff ff            	addl	-0x10c(%rbp), %esi
    12b1: 31 cb                        	xorl	%ecx, %ebx
    12b3: 01 de                        	addl	%ebx, %esi
    12b5: 01 f0                        	addl	%esi, %eax
    12b7: 05 01 5b 83 12               	addl	$0x12835b01, %eax       # imm = 0x12835B01
    12bc: 41 01 c0                     	addl	%eax, %r8d
    12bf: 44 89 ce                     	movl	%r9d, %esi
    12c2: c1 c6 1e                     	roll	$0x1e, %esi
    12c5: 44 89 cb                     	movl	%r9d, %ebx
    12c8: c1 c3 13                     	roll	$0x13, %ebx
    12cb: 31 f3                        	xorl	%esi, %ebx
    12cd: 45 89 ce                     	movl	%r9d, %r14d
    12d0: 41 c1 c6 0a                  	roll	$0xa, %r14d
    12d4: 41 31 de                     	xorl	%ebx, %r14d
    12d7: 44 89 db                     	movl	%r11d, %ebx
    12da: 09 d3                        	orl	%edx, %ebx
    12dc: 44 21 cb                     	andl	%r9d, %ebx
    12df: 44 89 de                     	movl	%r11d, %esi
    12e2: 21 d6                        	andl	%edx, %esi
    12e4: 09 de                        	orl	%ebx, %esi
    12e6: 44 89 c3                     	movl	%r8d, %ebx
    12e9: c1 c3 1a                     	roll	$0x1a, %ebx
    12ec: 44 01 f6                     	addl	%r14d, %esi
    12ef: 45 89 c6                     	movl	%r8d, %r14d
    12f2: 41 c1 c6 15                  	roll	$0x15, %r14d
    12f6: 01 c6                        	addl	%eax, %esi
    12f8: 44 89 c0                     	movl	%r8d, %eax
    12fb: c1 c0 07                     	roll	$0x7, %eax
    12fe: 41 31 de                     	xorl	%ebx, %r14d
    1301: 44 31 f0                     	xorl	%r14d, %eax
    1304: 89 fb                        	movl	%edi, %ebx
    1306: 44 31 d3                     	xorl	%r10d, %ebx
    1309: 44 21 c3                     	andl	%r8d, %ebx
    130c: 44 31 d3                     	xorl	%r10d, %ebx
    130f: 03 8d f8 fe ff ff            	addl	-0x108(%rbp), %ecx
    1315: 01 d9                        	addl	%ebx, %ecx
    1317: 89 f3                        	movl	%esi, %ebx
    1319: c1 c3 1e                     	roll	$0x1e, %ebx
    131c: 01 c1                        	addl	%eax, %ecx
    131e: 81 c1 be 85 31 24            	addl	$0x243185be, %ecx       # imm = 0x243185BE
    1324: 89 f0                        	movl	%esi, %eax
    1326: c1 c0 13                     	roll	$0x13, %eax
    1329: 01 ca                        	addl	%ecx, %edx
    132b: 41 89 f6                     	movl	%esi, %r14d
    132e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1332: 31 d8                        	xorl	%ebx, %eax
    1334: 41 31 c6                     	xorl	%eax, %r14d
    1337: 44 89 cb                     	movl	%r9d, %ebx
    133a: 44 09 db                     	orl	%r11d, %ebx
    133d: 21 f3                        	andl	%esi, %ebx
    133f: 44 89 c8                     	movl	%r9d, %eax
    1342: 44 21 d8                     	andl	%r11d, %eax
    1345: 09 d8                        	orl	%ebx, %eax
    1347: 44 01 f0                     	addl	%r14d, %eax
    134a: 89 d3                        	movl	%edx, %ebx
    134c: c1 c3 1a                     	roll	$0x1a, %ebx
    134f: 01 c8                        	addl	%ecx, %eax
    1351: 89 d1                        	movl	%edx, %ecx
    1353: c1 c1 15                     	roll	$0x15, %ecx
    1356: 31 d9                        	xorl	%ebx, %ecx
    1358: 89 d3                        	movl	%edx, %ebx
    135a: c1 c3 07                     	roll	$0x7, %ebx
    135d: 31 cb                        	xorl	%ecx, %ebx
    135f: 44 89 c1                     	movl	%r8d, %ecx
    1362: 31 f9                        	xorl	%edi, %ecx
    1364: 21 d1                        	andl	%edx, %ecx
    1366: 31 f9                        	xorl	%edi, %ecx
    1368: 44 03 95 fc fe ff ff         	addl	-0x104(%rbp), %r10d
    136f: 41 01 ca                     	addl	%ecx, %r10d
    1372: 42 8d 0c 13                  	leal	(%rbx,%r10), %ecx
    1376: 81 c1 c3 7d 0c 55            	addl	$0x550c7dc3, %ecx       # imm = 0x550C7DC3
    137c: 41 89 c2                     	movl	%eax, %r10d
    137f: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1383: 41 01 cb                     	addl	%ecx, %r11d
    1386: 89 c3                        	movl	%eax, %ebx
    1388: c1 c3 13                     	roll	$0x13, %ebx
    138b: 44 31 d3                     	xorl	%r10d, %ebx
    138e: 41 89 c6                     	movl	%eax, %r14d
    1391: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1395: 41 31 de                     	xorl	%ebx, %r14d
    1398: 89 f3                        	movl	%esi, %ebx
    139a: 44 09 cb                     	orl	%r9d, %ebx
    139d: 21 c3                        	andl	%eax, %ebx
    139f: 41 89 f2                     	movl	%esi, %r10d
    13a2: 45 21 ca                     	andl	%r9d, %r10d
    13a5: 41 09 da                     	orl	%ebx, %r10d
    13a8: 45 01 f2                     	addl	%r14d, %r10d
    13ab: 41 01 ca                     	addl	%ecx, %r10d
    13ae: 44 89 d9                     	movl	%r11d, %ecx
    13b1: c1 c1 1a                     	roll	$0x1a, %ecx
    13b4: 44 89 db                     	movl	%r11d, %ebx
    13b7: c1 c3 15                     	roll	$0x15, %ebx
    13ba: 31 cb                        	xorl	%ecx, %ebx
    13bc: 44 89 d9                     	movl	%r11d, %ecx
    13bf: c1 c1 07                     	roll	$0x7, %ecx
    13c2: 31 d9                        	xorl	%ebx, %ecx
    13c4: 89 d3                        	movl	%edx, %ebx
    13c6: 44 31 c3                     	xorl	%r8d, %ebx
    13c9: 44 21 db                     	andl	%r11d, %ebx
    13cc: 44 31 c3                     	xorl	%r8d, %ebx
    13cf: 03 bd 00 ff ff ff            	addl	-0x100(%rbp), %edi
    13d5: 01 df                        	addl	%ebx, %edi
    13d7: 01 f9                        	addl	%edi, %ecx
    13d9: 81 c1 74 5d be 72            	addl	$0x72be5d74, %ecx       # imm = 0x72BE5D74
    13df: 41 01 c9                     	addl	%ecx, %r9d
    13e2: 44 89 d7                     	movl	%r10d, %edi
    13e5: c1 c7 1e                     	roll	$0x1e, %edi
    13e8: 44 89 d3                     	movl	%r10d, %ebx
    13eb: c1 c3 13                     	roll	$0x13, %ebx
    13ee: 31 fb                        	xorl	%edi, %ebx
    13f0: 45 89 d6                     	movl	%r10d, %r14d
    13f3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    13f7: 41 31 de                     	xorl	%ebx, %r14d
    13fa: 89 c3                        	movl	%eax, %ebx
    13fc: 09 f3                        	orl	%esi, %ebx
    13fe: 44 21 d3                     	andl	%r10d, %ebx
    1401: 89 c7                        	movl	%eax, %edi
    1403: 21 f7                        	andl	%esi, %edi
    1405: 09 df                        	orl	%ebx, %edi
    1407: 44 01 f7                     	addl	%r14d, %edi
    140a: 01 cf                        	addl	%ecx, %edi
    140c: 44 89 c9                     	movl	%r9d, %ecx
    140f: c1 c1 1a                     	roll	$0x1a, %ecx
    1412: 44 89 cb                     	movl	%r9d, %ebx
    1415: c1 c3 15                     	roll	$0x15, %ebx
    1418: 31 cb                        	xorl	%ecx, %ebx
    141a: 44 89 c9                     	movl	%r9d, %ecx
    141d: c1 c1 07                     	roll	$0x7, %ecx
    1420: 31 d9                        	xorl	%ebx, %ecx
    1422: 44 89 db                     	movl	%r11d, %ebx
    1425: 31 d3                        	xorl	%edx, %ebx
    1427: 44 21 cb                     	andl	%r9d, %ebx
    142a: 44 03 85 04 ff ff ff         	addl	-0xfc(%rbp), %r8d
    1431: 31 d3                        	xorl	%edx, %ebx
    1433: 41 01 d8                     	addl	%ebx, %r8d
    1436: 44 01 c1                     	addl	%r8d, %ecx
    1439: 81 c1 fe b1 de 80            	addl	$0x80deb1fe, %ecx       # imm = 0x80DEB1FE
    143f: 01 ce                        	addl	%ecx, %esi
    1441: 41 89 f8                     	movl	%edi, %r8d
    1444: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1448: 89 fb                        	movl	%edi, %ebx
    144a: c1 c3 13                     	roll	$0x13, %ebx
    144d: 44 31 c3                     	xorl	%r8d, %ebx
    1450: 41 89 fe                     	movl	%edi, %r14d
    1453: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1457: 41 31 de                     	xorl	%ebx, %r14d
    145a: 44 89 d3                     	movl	%r10d, %ebx
    145d: 09 c3                        	orl	%eax, %ebx
    145f: 21 fb                        	andl	%edi, %ebx
    1461: 45 89 d0                     	movl	%r10d, %r8d
    1464: 41 21 c0                     	andl	%eax, %r8d
    1467: 41 09 d8                     	orl	%ebx, %r8d
    146a: 89 f3                        	movl	%esi, %ebx
    146c: c1 c3 1a                     	roll	$0x1a, %ebx
    146f: 45 01 f0                     	addl	%r14d, %r8d
    1472: 41 89 f6                     	movl	%esi, %r14d
    1475: 41 c1 c6 15                  	roll	$0x15, %r14d
    1479: 41 01 c8                     	addl	%ecx, %r8d
    147c: 89 f1                        	movl	%esi, %ecx
    147e: c1 c1 07                     	roll	$0x7, %ecx
    1481: 41 31 de                     	xorl	%ebx, %r14d
    1484: 44 31 f1                     	xorl	%r14d, %ecx
    1487: 44 89 cb                     	movl	%r9d, %ebx
    148a: 44 31 db                     	xorl	%r11d, %ebx
    148d: 21 f3                        	andl	%esi, %ebx
    148f: 44 31 db                     	xorl	%r11d, %ebx
    1492: 03 95 08 ff ff ff            	addl	-0xf8(%rbp), %edx
    1498: 01 da                        	addl	%ebx, %edx
    149a: 44 89 c3                     	movl	%r8d, %ebx
    149d: c1 c3 1e                     	roll	$0x1e, %ebx
    14a0: 01 ca                        	addl	%ecx, %edx
    14a2: 81 c2 a7 06 dc 9b            	addl	$0x9bdc06a7, %edx       # imm = 0x9BDC06A7
    14a8: 44 89 c1                     	movl	%r8d, %ecx
    14ab: c1 c1 13                     	roll	$0x13, %ecx
    14ae: 01 d0                        	addl	%edx, %eax
    14b0: 45 89 c6                     	movl	%r8d, %r14d
    14b3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    14b7: 31 d9                        	xorl	%ebx, %ecx
    14b9: 41 31 ce                     	xorl	%ecx, %r14d
    14bc: 89 fb                        	movl	%edi, %ebx
    14be: 44 09 d3                     	orl	%r10d, %ebx
    14c1: 44 21 c3                     	andl	%r8d, %ebx
    14c4: 89 f9                        	movl	%edi, %ecx
    14c6: 44 21 d1                     	andl	%r10d, %ecx
    14c9: 09 d9                        	orl	%ebx, %ecx
    14cb: 44 01 f1                     	addl	%r14d, %ecx
    14ce: 89 c3                        	movl	%eax, %ebx
    14d0: c1 c3 1a                     	roll	$0x1a, %ebx
    14d3: 01 d1                        	addl	%edx, %ecx
    14d5: 89 c2                        	movl	%eax, %edx
    14d7: c1 c2 15                     	roll	$0x15, %edx
    14da: 31 da                        	xorl	%ebx, %edx
    14dc: 89 c3                        	movl	%eax, %ebx
    14de: c1 c3 07                     	roll	$0x7, %ebx
    14e1: 31 d3                        	xorl	%edx, %ebx
    14e3: 89 f2                        	movl	%esi, %edx
    14e5: 44 31 ca                     	xorl	%r9d, %edx
    14e8: 21 c2                        	andl	%eax, %edx
    14ea: 44 31 ca                     	xorl	%r9d, %edx
    14ed: 44 03 9d 0c ff ff ff         	addl	-0xf4(%rbp), %r11d
    14f4: 41 01 d3                     	addl	%edx, %r11d
    14f7: 42 8d 14 1b                  	leal	(%rbx,%r11), %edx
    14fb: 81 c2 74 f1 9b c1            	addl	$0xc19bf174, %edx       # imm = 0xC19BF174
    1501: 41 89 cb                     	movl	%ecx, %r11d
    1504: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    1508: 41 01 d2                     	addl	%edx, %r10d
    150b: 89 cb                        	movl	%ecx, %ebx
    150d: c1 c3 13                     	roll	$0x13, %ebx
    1510: 44 31 db                     	xorl	%r11d, %ebx
    1513: 41 89 ce                     	movl	%ecx, %r14d
    1516: 41 c1 c6 0a                  	roll	$0xa, %r14d
    151a: 41 31 de                     	xorl	%ebx, %r14d
    151d: 44 89 c3                     	movl	%r8d, %ebx
    1520: 09 fb                        	orl	%edi, %ebx
    1522: 21 cb                        	andl	%ecx, %ebx
    1524: 45 89 c3                     	movl	%r8d, %r11d
    1527: 41 21 fb                     	andl	%edi, %r11d
    152a: 41 09 db                     	orl	%ebx, %r11d
    152d: 45 01 f3                     	addl	%r14d, %r11d
    1530: 41 01 d3                     	addl	%edx, %r11d
    1533: 44 89 d2                     	movl	%r10d, %edx
    1536: c1 c2 1a                     	roll	$0x1a, %edx
    1539: 44 89 d3                     	movl	%r10d, %ebx
    153c: c1 c3 15                     	roll	$0x15, %ebx
    153f: 31 d3                        	xorl	%edx, %ebx
    1541: 44 89 d2                     	movl	%r10d, %edx
    1544: c1 c2 07                     	roll	$0x7, %edx
    1547: 31 da                        	xorl	%ebx, %edx
    1549: 89 c3                        	movl	%eax, %ebx
    154b: 31 f3                        	xorl	%esi, %ebx
    154d: 44 21 d3                     	andl	%r10d, %ebx
    1550: 31 f3                        	xorl	%esi, %ebx
    1552: 44 03 8d 10 ff ff ff         	addl	-0xf0(%rbp), %r9d
    1559: 41 01 d9                     	addl	%ebx, %r9d
    155c: 41 01 d1                     	addl	%edx, %r9d
    155f: 41 81 c1 c1 69 9b e4         	addl	$0xe49b69c1, %r9d       # imm = 0xE49B69C1
    1566: 44 01 cf                     	addl	%r9d, %edi
    1569: 44 89 da                     	movl	%r11d, %edx
    156c: c1 c2 1e                     	roll	$0x1e, %edx
    156f: 44 89 db                     	movl	%r11d, %ebx
    1572: c1 c3 13                     	roll	$0x13, %ebx
    1575: 31 d3                        	xorl	%edx, %ebx
    1577: 45 89 de                     	movl	%r11d, %r14d
    157a: 41 c1 c6 0a                  	roll	$0xa, %r14d
    157e: 41 31 de                     	xorl	%ebx, %r14d
    1581: 89 cb                        	movl	%ecx, %ebx
    1583: 44 09 c3                     	orl	%r8d, %ebx
    1586: 44 21 db                     	andl	%r11d, %ebx
    1589: 89 ca                        	movl	%ecx, %edx
    158b: 44 21 c2                     	andl	%r8d, %edx
    158e: 09 da                        	orl	%ebx, %edx
    1590: 44 01 f2                     	addl	%r14d, %edx
    1593: 44 01 ca                     	addl	%r9d, %edx
    1596: 41 89 f9                     	movl	%edi, %r9d
    1599: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    159d: 89 fb                        	movl	%edi, %ebx
    159f: c1 c3 15                     	roll	$0x15, %ebx
    15a2: 44 31 cb                     	xorl	%r9d, %ebx
    15a5: 41 89 f9                     	movl	%edi, %r9d
    15a8: 41 c1 c1 07                  	roll	$0x7, %r9d
    15ac: 41 31 d9                     	xorl	%ebx, %r9d
    15af: 44 89 d3                     	movl	%r10d, %ebx
    15b2: 31 c3                        	xorl	%eax, %ebx
    15b4: 21 fb                        	andl	%edi, %ebx
    15b6: 03 b5 14 ff ff ff            	addl	-0xec(%rbp), %esi
    15bc: 31 c3                        	xorl	%eax, %ebx
    15be: 01 de                        	addl	%ebx, %esi
    15c0: 41 01 f1                     	addl	%esi, %r9d
    15c3: 41 81 c1 86 47 be ef         	addl	$0xefbe4786, %r9d       # imm = 0xEFBE4786
    15ca: 45 01 c8                     	addl	%r9d, %r8d
    15cd: 89 d6                        	movl	%edx, %esi
    15cf: c1 c6 1e                     	roll	$0x1e, %esi
    15d2: 89 d3                        	movl	%edx, %ebx
    15d4: c1 c3 13                     	roll	$0x13, %ebx
    15d7: 31 f3                        	xorl	%esi, %ebx
    15d9: 41 89 d6                     	movl	%edx, %r14d
    15dc: 41 c1 c6 0a                  	roll	$0xa, %r14d
    15e0: 41 31 de                     	xorl	%ebx, %r14d
    15e3: 44 89 db                     	movl	%r11d, %ebx
    15e6: 09 cb                        	orl	%ecx, %ebx
    15e8: 21 d3                        	andl	%edx, %ebx
    15ea: 44 89 de                     	movl	%r11d, %esi
    15ed: 21 ce                        	andl	%ecx, %esi
    15ef: 09 de                        	orl	%ebx, %esi
    15f1: 44 89 c3                     	movl	%r8d, %ebx
    15f4: c1 c3 1a                     	roll	$0x1a, %ebx
    15f7: 44 01 f6                     	addl	%r14d, %esi
    15fa: 45 89 c6                     	movl	%r8d, %r14d
    15fd: 41 c1 c6 15                  	roll	$0x15, %r14d
    1601: 44 01 ce                     	addl	%r9d, %esi
    1604: 45 89 c1                     	movl	%r8d, %r9d
    1607: 41 c1 c1 07                  	roll	$0x7, %r9d
    160b: 41 31 de                     	xorl	%ebx, %r14d
    160e: 45 31 f1                     	xorl	%r14d, %r9d
    1611: 89 fb                        	movl	%edi, %ebx
    1613: 44 31 d3                     	xorl	%r10d, %ebx
    1616: 44 21 c3                     	andl	%r8d, %ebx
    1619: 44 31 d3                     	xorl	%r10d, %ebx
    161c: 03 85 18 ff ff ff            	addl	-0xe8(%rbp), %eax
    1622: 01 d8                        	addl	%ebx, %eax
    1624: 89 f3                        	movl	%esi, %ebx
    1626: c1 c3 1e                     	roll	$0x1e, %ebx
    1629: 41 01 c1                     	addl	%eax, %r9d
    162c: 41 81 c1 c6 9d c1 0f         	addl	$0xfc19dc6, %r9d        # imm = 0xFC19DC6
    1633: 89 f0                        	movl	%esi, %eax
    1635: c1 c0 13                     	roll	$0x13, %eax
    1638: 44 01 c9                     	addl	%r9d, %ecx
    163b: 41 89 f6                     	movl	%esi, %r14d
    163e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1642: 31 d8                        	xorl	%ebx, %eax
    1644: 41 31 c6                     	xorl	%eax, %r14d
    1647: 89 d3                        	movl	%edx, %ebx
    1649: 44 09 db                     	orl	%r11d, %ebx
    164c: 21 f3                        	andl	%esi, %ebx
    164e: 89 d0                        	movl	%edx, %eax
    1650: 44 21 d8                     	andl	%r11d, %eax
    1653: 09 d8                        	orl	%ebx, %eax
    1655: 44 01 f0                     	addl	%r14d, %eax
    1658: 89 cb                        	movl	%ecx, %ebx
    165a: c1 c3 1a                     	roll	$0x1a, %ebx
    165d: 44 01 c8                     	addl	%r9d, %eax
    1660: 41 89 c9                     	movl	%ecx, %r9d
    1663: 41 c1 c1 15                  	roll	$0x15, %r9d
    1667: 41 31 d9                     	xorl	%ebx, %r9d
    166a: 89 cb                        	movl	%ecx, %ebx
    166c: c1 c3 07                     	roll	$0x7, %ebx
    166f: 44 31 cb                     	xorl	%r9d, %ebx
    1672: 45 89 c1                     	movl	%r8d, %r9d
    1675: 41 31 f9                     	xorl	%edi, %r9d
    1678: 41 21 c9                     	andl	%ecx, %r9d
    167b: 41 31 f9                     	xorl	%edi, %r9d
    167e: 44 03 95 1c ff ff ff         	addl	-0xe4(%rbp), %r10d
    1685: 45 01 ca                     	addl	%r9d, %r10d
    1688: 41 01 da                     	addl	%ebx, %r10d
    168b: 41 81 c2 cc a1 0c 24         	addl	$0x240ca1cc, %r10d      # imm = 0x240CA1CC
    1692: 41 89 c1                     	movl	%eax, %r9d
    1695: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1699: 45 01 d3                     	addl	%r10d, %r11d
    169c: 89 c3                        	movl	%eax, %ebx
    169e: c1 c3 13                     	roll	$0x13, %ebx
    16a1: 44 31 cb                     	xorl	%r9d, %ebx
    16a4: 41 89 c6                     	movl	%eax, %r14d
    16a7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    16ab: 41 31 de                     	xorl	%ebx, %r14d
    16ae: 89 f3                        	movl	%esi, %ebx
    16b0: 09 d3                        	orl	%edx, %ebx
    16b2: 21 c3                        	andl	%eax, %ebx
    16b4: 41 89 f1                     	movl	%esi, %r9d
    16b7: 41 21 d1                     	andl	%edx, %r9d
    16ba: 41 09 d9                     	orl	%ebx, %r9d
    16bd: 45 01 f1                     	addl	%r14d, %r9d
    16c0: 45 01 d1                     	addl	%r10d, %r9d
    16c3: 45 89 da                     	movl	%r11d, %r10d
    16c6: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    16ca: 44 89 db                     	movl	%r11d, %ebx
    16cd: c1 c3 15                     	roll	$0x15, %ebx
    16d0: 44 31 d3                     	xorl	%r10d, %ebx
    16d3: 45 89 da                     	movl	%r11d, %r10d
    16d6: 41 c1 c2 07                  	roll	$0x7, %r10d
    16da: 41 31 da                     	xorl	%ebx, %r10d
    16dd: 89 cb                        	movl	%ecx, %ebx
    16df: 44 31 c3                     	xorl	%r8d, %ebx
    16e2: 44 21 db                     	andl	%r11d, %ebx
    16e5: 44 31 c3                     	xorl	%r8d, %ebx
    16e8: 03 bd 20 ff ff ff            	addl	-0xe0(%rbp), %edi
    16ee: 01 df                        	addl	%ebx, %edi
    16f0: 41 01 fa                     	addl	%edi, %r10d
    16f3: 41 81 c2 6f 2c e9 2d         	addl	$0x2de92c6f, %r10d      # imm = 0x2DE92C6F
    16fa: 44 01 d2                     	addl	%r10d, %edx
    16fd: 44 89 cf                     	movl	%r9d, %edi
    1700: c1 c7 1e                     	roll	$0x1e, %edi
    1703: 44 89 cb                     	movl	%r9d, %ebx
    1706: c1 c3 13                     	roll	$0x13, %ebx
    1709: 31 fb                        	xorl	%edi, %ebx
    170b: 45 89 ce                     	movl	%r9d, %r14d
    170e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1712: 41 31 de                     	xorl	%ebx, %r14d
    1715: 89 c3                        	movl	%eax, %ebx
    1717: 09 f3                        	orl	%esi, %ebx
    1719: 44 21 cb                     	andl	%r9d, %ebx
    171c: 89 c7                        	movl	%eax, %edi
    171e: 21 f7                        	andl	%esi, %edi
    1720: 09 df                        	orl	%ebx, %edi
    1722: 44 01 f7                     	addl	%r14d, %edi
    1725: 44 01 d7                     	addl	%r10d, %edi
    1728: 41 89 d2                     	movl	%edx, %r10d
    172b: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    172f: 89 d3                        	movl	%edx, %ebx
    1731: c1 c3 15                     	roll	$0x15, %ebx
    1734: 44 31 d3                     	xorl	%r10d, %ebx
    1737: 41 89 d2                     	movl	%edx, %r10d
    173a: 41 c1 c2 07                  	roll	$0x7, %r10d
    173e: 41 31 da                     	xorl	%ebx, %r10d
    1741: 44 89 db                     	movl	%r11d, %ebx
    1744: 31 cb                        	xorl	%ecx, %ebx
    1746: 21 d3                        	andl	%edx, %ebx
    1748: 44 03 85 24 ff ff ff         	addl	-0xdc(%rbp), %r8d
    174f: 31 cb                        	xorl	%ecx, %ebx
    1751: 41 01 d8                     	addl	%ebx, %r8d
    1754: 45 01 c2                     	addl	%r8d, %r10d
    1757: 41 81 c2 aa 84 74 4a         	addl	$0x4a7484aa, %r10d      # imm = 0x4A7484AA
    175e: 44 01 d6                     	addl	%r10d, %esi
    1761: 41 89 f8                     	movl	%edi, %r8d
    1764: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1768: 89 fb                        	movl	%edi, %ebx
    176a: c1 c3 13                     	roll	$0x13, %ebx
    176d: 44 31 c3                     	xorl	%r8d, %ebx
    1770: 41 89 fe                     	movl	%edi, %r14d
    1773: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1777: 41 31 de                     	xorl	%ebx, %r14d
    177a: 44 89 cb                     	movl	%r9d, %ebx
    177d: 09 c3                        	orl	%eax, %ebx
    177f: 21 fb                        	andl	%edi, %ebx
    1781: 45 89 c8                     	movl	%r9d, %r8d
    1784: 41 21 c0                     	andl	%eax, %r8d
    1787: 41 09 d8                     	orl	%ebx, %r8d
    178a: 89 f3                        	movl	%esi, %ebx
    178c: c1 c3 1a                     	roll	$0x1a, %ebx
    178f: 45 01 f0                     	addl	%r14d, %r8d
    1792: 41 89 f6                     	movl	%esi, %r14d
    1795: 41 c1 c6 15                  	roll	$0x15, %r14d
    1799: 45 01 d0                     	addl	%r10d, %r8d
    179c: 41 89 f2                     	movl	%esi, %r10d
    179f: 41 c1 c2 07                  	roll	$0x7, %r10d
    17a3: 41 31 de                     	xorl	%ebx, %r14d
    17a6: 45 31 f2                     	xorl	%r14d, %r10d
    17a9: 89 d3                        	movl	%edx, %ebx
    17ab: 44 31 db                     	xorl	%r11d, %ebx
    17ae: 21 f3                        	andl	%esi, %ebx
    17b0: 44 31 db                     	xorl	%r11d, %ebx
    17b3: 03 8d 28 ff ff ff            	addl	-0xd8(%rbp), %ecx
    17b9: 01 d9                        	addl	%ebx, %ecx
    17bb: 44 89 c3                     	movl	%r8d, %ebx
    17be: c1 c3 1e                     	roll	$0x1e, %ebx
    17c1: 41 01 ca                     	addl	%ecx, %r10d
    17c4: 41 81 c2 dc a9 b0 5c         	addl	$0x5cb0a9dc, %r10d      # imm = 0x5CB0A9DC
    17cb: 44 89 c1                     	movl	%r8d, %ecx
    17ce: c1 c1 13                     	roll	$0x13, %ecx
    17d1: 44 01 d0                     	addl	%r10d, %eax
    17d4: 45 89 c6                     	movl	%r8d, %r14d
    17d7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    17db: 31 d9                        	xorl	%ebx, %ecx
    17dd: 41 31 ce                     	xorl	%ecx, %r14d
    17e0: 89 fb                        	movl	%edi, %ebx
    17e2: 44 09 cb                     	orl	%r9d, %ebx
    17e5: 44 21 c3                     	andl	%r8d, %ebx
    17e8: 89 f9                        	movl	%edi, %ecx
    17ea: 44 21 c9                     	andl	%r9d, %ecx
    17ed: 09 d9                        	orl	%ebx, %ecx
    17ef: 44 01 f1                     	addl	%r14d, %ecx
    17f2: 89 c3                        	movl	%eax, %ebx
    17f4: c1 c3 1a                     	roll	$0x1a, %ebx
    17f7: 44 01 d1                     	addl	%r10d, %ecx
    17fa: 41 89 c2                     	movl	%eax, %r10d
    17fd: 41 c1 c2 15                  	roll	$0x15, %r10d
    1801: 41 31 da                     	xorl	%ebx, %r10d
    1804: 89 c3                        	movl	%eax, %ebx
    1806: c1 c3 07                     	roll	$0x7, %ebx
    1809: 44 31 d3                     	xorl	%r10d, %ebx
    180c: 41 89 f2                     	movl	%esi, %r10d
    180f: 41 31 d2                     	xorl	%edx, %r10d
    1812: 41 21 c2                     	andl	%eax, %r10d
    1815: 41 31 d2                     	xorl	%edx, %r10d
    1818: 44 03 9d 2c ff ff ff         	addl	-0xd4(%rbp), %r11d
    181f: 45 01 d3                     	addl	%r10d, %r11d
    1822: 41 01 db                     	addl	%ebx, %r11d
    1825: 41 81 c3 da 88 f9 76         	addl	$0x76f988da, %r11d      # imm = 0x76F988DA
    182c: 41 89 ca                     	movl	%ecx, %r10d
    182f: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1833: 45 01 d9                     	addl	%r11d, %r9d
    1836: 89 cb                        	movl	%ecx, %ebx
    1838: c1 c3 13                     	roll	$0x13, %ebx
    183b: 44 31 d3                     	xorl	%r10d, %ebx
    183e: 41 89 ce                     	movl	%ecx, %r14d
    1841: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1845: 41 31 de                     	xorl	%ebx, %r14d
    1848: 44 89 c3                     	movl	%r8d, %ebx
    184b: 09 fb                        	orl	%edi, %ebx
    184d: 21 cb                        	andl	%ecx, %ebx
    184f: 45 89 c2                     	movl	%r8d, %r10d
    1852: 41 21 fa                     	andl	%edi, %r10d
    1855: 41 09 da                     	orl	%ebx, %r10d
    1858: 45 01 f2                     	addl	%r14d, %r10d
    185b: 45 01 da                     	addl	%r11d, %r10d
    185e: 45 89 cb                     	movl	%r9d, %r11d
    1861: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1865: 44 89 cb                     	movl	%r9d, %ebx
    1868: c1 c3 15                     	roll	$0x15, %ebx
    186b: 44 31 db                     	xorl	%r11d, %ebx
    186e: 45 89 cb                     	movl	%r9d, %r11d
    1871: 41 c1 c3 07                  	roll	$0x7, %r11d
    1875: 41 31 db                     	xorl	%ebx, %r11d
    1878: 89 c3                        	movl	%eax, %ebx
    187a: 31 f3                        	xorl	%esi, %ebx
    187c: 44 21 cb                     	andl	%r9d, %ebx
    187f: 31 f3                        	xorl	%esi, %ebx
    1881: 03 95 30 ff ff ff            	addl	-0xd0(%rbp), %edx
    1887: 01 da                        	addl	%ebx, %edx
    1889: 41 01 d3                     	addl	%edx, %r11d
    188c: 41 81 c3 52 51 3e 98         	addl	$0x983e5152, %r11d      # imm = 0x983E5152
    1893: 44 01 df                     	addl	%r11d, %edi
    1896: 44 89 d2                     	movl	%r10d, %edx
    1899: c1 c2 1e                     	roll	$0x1e, %edx
    189c: 44 89 d3                     	movl	%r10d, %ebx
    189f: c1 c3 13                     	roll	$0x13, %ebx
    18a2: 31 d3                        	xorl	%edx, %ebx
    18a4: 45 89 d6                     	movl	%r10d, %r14d
    18a7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    18ab: 41 31 de                     	xorl	%ebx, %r14d
    18ae: 89 cb                        	movl	%ecx, %ebx
    18b0: 44 09 c3                     	orl	%r8d, %ebx
    18b3: 44 21 d3                     	andl	%r10d, %ebx
    18b6: 89 ca                        	movl	%ecx, %edx
    18b8: 44 21 c2                     	andl	%r8d, %edx
    18bb: 09 da                        	orl	%ebx, %edx
    18bd: 44 01 f2                     	addl	%r14d, %edx
    18c0: 44 01 da                     	addl	%r11d, %edx
    18c3: 41 89 fb                     	movl	%edi, %r11d
    18c6: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    18ca: 89 fb                        	movl	%edi, %ebx
    18cc: c1 c3 15                     	roll	$0x15, %ebx
    18cf: 44 31 db                     	xorl	%r11d, %ebx
    18d2: 41 89 fb                     	movl	%edi, %r11d
    18d5: 41 c1 c3 07                  	roll	$0x7, %r11d
    18d9: 41 31 db                     	xorl	%ebx, %r11d
    18dc: 44 89 cb                     	movl	%r9d, %ebx
    18df: 31 c3                        	xorl	%eax, %ebx
    18e1: 21 fb                        	andl	%edi, %ebx
    18e3: 03 b5 34 ff ff ff            	addl	-0xcc(%rbp), %esi
    18e9: 31 c3                        	xorl	%eax, %ebx
    18eb: 01 de                        	addl	%ebx, %esi
    18ed: 41 01 f3                     	addl	%esi, %r11d
    18f0: 41 81 c3 6d c6 31 a8         	addl	$0xa831c66d, %r11d      # imm = 0xA831C66D
    18f7: 45 01 d8                     	addl	%r11d, %r8d
    18fa: 89 d6                        	movl	%edx, %esi
    18fc: c1 c6 1e                     	roll	$0x1e, %esi
    18ff: 89 d3                        	movl	%edx, %ebx
    1901: c1 c3 13                     	roll	$0x13, %ebx
    1904: 31 f3                        	xorl	%esi, %ebx
    1906: 41 89 d6                     	movl	%edx, %r14d
    1909: 41 c1 c6 0a                  	roll	$0xa, %r14d
    190d: 41 31 de                     	xorl	%ebx, %r14d
    1910: 44 89 d3                     	movl	%r10d, %ebx
    1913: 09 cb                        	orl	%ecx, %ebx
    1915: 21 d3                        	andl	%edx, %ebx
    1917: 44 89 d6                     	movl	%r10d, %esi
    191a: 21 ce                        	andl	%ecx, %esi
    191c: 09 de                        	orl	%ebx, %esi
    191e: 44 89 c3                     	movl	%r8d, %ebx
    1921: c1 c3 1a                     	roll	$0x1a, %ebx
    1924: 44 01 f6                     	addl	%r14d, %esi
    1927: 45 89 c6                     	movl	%r8d, %r14d
    192a: 41 c1 c6 15                  	roll	$0x15, %r14d
    192e: 44 01 de                     	addl	%r11d, %esi
    1931: 45 89 c3                     	movl	%r8d, %r11d
    1934: 41 c1 c3 07                  	roll	$0x7, %r11d
    1938: 41 31 de                     	xorl	%ebx, %r14d
    193b: 45 31 f3                     	xorl	%r14d, %r11d
    193e: 89 fb                        	movl	%edi, %ebx
    1940: 44 31 cb                     	xorl	%r9d, %ebx
    1943: 44 21 c3                     	andl	%r8d, %ebx
    1946: 44 31 cb                     	xorl	%r9d, %ebx
    1949: 03 85 38 ff ff ff            	addl	-0xc8(%rbp), %eax
    194f: 01 d8                        	addl	%ebx, %eax
    1951: 89 f3                        	movl	%esi, %ebx
    1953: c1 c3 1e                     	roll	$0x1e, %ebx
    1956: 41 01 c3                     	addl	%eax, %r11d
    1959: 41 81 c3 c8 27 03 b0         	addl	$0xb00327c8, %r11d      # imm = 0xB00327C8
    1960: 89 f0                        	movl	%esi, %eax
    1962: c1 c0 13                     	roll	$0x13, %eax
    1965: 44 01 d9                     	addl	%r11d, %ecx
    1968: 41 89 f6                     	movl	%esi, %r14d
    196b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    196f: 31 d8                        	xorl	%ebx, %eax
    1971: 41 31 c6                     	xorl	%eax, %r14d
    1974: 89 d3                        	movl	%edx, %ebx
    1976: 44 09 d3                     	orl	%r10d, %ebx
    1979: 21 f3                        	andl	%esi, %ebx
    197b: 89 d0                        	movl	%edx, %eax
    197d: 44 21 d0                     	andl	%r10d, %eax
    1980: 09 d8                        	orl	%ebx, %eax
    1982: 44 01 f0                     	addl	%r14d, %eax
    1985: 89 cb                        	movl	%ecx, %ebx
    1987: c1 c3 1a                     	roll	$0x1a, %ebx
    198a: 44 01 d8                     	addl	%r11d, %eax
    198d: 41 89 cb                     	movl	%ecx, %r11d
    1990: 41 c1 c3 15                  	roll	$0x15, %r11d
    1994: 41 31 db                     	xorl	%ebx, %r11d
    1997: 89 cb                        	movl	%ecx, %ebx
    1999: c1 c3 07                     	roll	$0x7, %ebx
    199c: 44 31 db                     	xorl	%r11d, %ebx
    199f: 45 89 c3                     	movl	%r8d, %r11d
    19a2: 41 31 fb                     	xorl	%edi, %r11d
    19a5: 41 21 cb                     	andl	%ecx, %r11d
    19a8: 41 31 fb                     	xorl	%edi, %r11d
    19ab: 44 03 8d 3c ff ff ff         	addl	-0xc4(%rbp), %r9d
    19b2: 45 01 d9                     	addl	%r11d, %r9d
    19b5: 46 8d 1c 0b                  	leal	(%rbx,%r9), %r11d
    19b9: 41 81 c3 c7 7f 59 bf         	addl	$0xbf597fc7, %r11d      # imm = 0xBF597FC7
    19c0: 41 89 c1                     	movl	%eax, %r9d
    19c3: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    19c7: 45 01 da                     	addl	%r11d, %r10d
    19ca: 89 c3                        	movl	%eax, %ebx
    19cc: c1 c3 13                     	roll	$0x13, %ebx
    19cf: 44 31 cb                     	xorl	%r9d, %ebx
    19d2: 41 89 c6                     	movl	%eax, %r14d
    19d5: 41 c1 c6 0a                  	roll	$0xa, %r14d
    19d9: 41 31 de                     	xorl	%ebx, %r14d
    19dc: 89 f3                        	movl	%esi, %ebx
    19de: 09 d3                        	orl	%edx, %ebx
    19e0: 21 c3                        	andl	%eax, %ebx
    19e2: 41 89 f1                     	movl	%esi, %r9d
    19e5: 41 21 d1                     	andl	%edx, %r9d
    19e8: 41 09 d9                     	orl	%ebx, %r9d
    19eb: 45 01 f1                     	addl	%r14d, %r9d
    19ee: 45 01 d9                     	addl	%r11d, %r9d
    19f1: 45 89 d3                     	movl	%r10d, %r11d
    19f4: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    19f8: 44 89 d3                     	movl	%r10d, %ebx
    19fb: c1 c3 15                     	roll	$0x15, %ebx
    19fe: 44 31 db                     	xorl	%r11d, %ebx
    1a01: 45 89 d3                     	movl	%r10d, %r11d
    1a04: 41 c1 c3 07                  	roll	$0x7, %r11d
    1a08: 41 31 db                     	xorl	%ebx, %r11d
    1a0b: 89 cb                        	movl	%ecx, %ebx
    1a0d: 44 31 c3                     	xorl	%r8d, %ebx
    1a10: 44 21 d3                     	andl	%r10d, %ebx
    1a13: 44 31 c3                     	xorl	%r8d, %ebx
    1a16: 03 bd 40 ff ff ff            	addl	-0xc0(%rbp), %edi
    1a1c: 01 df                        	addl	%ebx, %edi
    1a1e: 41 01 fb                     	addl	%edi, %r11d
    1a21: 41 81 c3 f3 0b e0 c6         	addl	$0xc6e00bf3, %r11d      # imm = 0xC6E00BF3
    1a28: 44 01 da                     	addl	%r11d, %edx
    1a2b: 44 89 cf                     	movl	%r9d, %edi
    1a2e: c1 c7 1e                     	roll	$0x1e, %edi
    1a31: 44 89 cb                     	movl	%r9d, %ebx
    1a34: c1 c3 13                     	roll	$0x13, %ebx
    1a37: 31 fb                        	xorl	%edi, %ebx
    1a39: 45 89 ce                     	movl	%r9d, %r14d
    1a3c: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1a40: 41 31 de                     	xorl	%ebx, %r14d
    1a43: 89 c3                        	movl	%eax, %ebx
    1a45: 09 f3                        	orl	%esi, %ebx
    1a47: 44 21 cb                     	andl	%r9d, %ebx
    1a4a: 89 c7                        	movl	%eax, %edi
    1a4c: 21 f7                        	andl	%esi, %edi
    1a4e: 09 df                        	orl	%ebx, %edi
    1a50: 44 01 f7                     	addl	%r14d, %edi
    1a53: 44 01 df                     	addl	%r11d, %edi
    1a56: 41 89 d3                     	movl	%edx, %r11d
    1a59: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1a5d: 89 d3                        	movl	%edx, %ebx
    1a5f: c1 c3 15                     	roll	$0x15, %ebx
    1a62: 44 31 db                     	xorl	%r11d, %ebx
    1a65: 41 89 d3                     	movl	%edx, %r11d
    1a68: 41 c1 c3 07                  	roll	$0x7, %r11d
    1a6c: 41 31 db                     	xorl	%ebx, %r11d
    1a6f: 44 89 d3                     	movl	%r10d, %ebx
    1a72: 31 cb                        	xorl	%ecx, %ebx
    1a74: 21 d3                        	andl	%edx, %ebx
    1a76: 44 03 85 44 ff ff ff         	addl	-0xbc(%rbp), %r8d
    1a7d: 31 cb                        	xorl	%ecx, %ebx
    1a7f: 41 01 d8                     	addl	%ebx, %r8d
    1a82: 45 01 c3                     	addl	%r8d, %r11d
    1a85: 41 81 c3 47 91 a7 d5         	addl	$0xd5a79147, %r11d      # imm = 0xD5A79147
    1a8c: 44 01 de                     	addl	%r11d, %esi
    1a8f: 41 89 f8                     	movl	%edi, %r8d
    1a92: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1a96: 89 fb                        	movl	%edi, %ebx
    1a98: c1 c3 13                     	roll	$0x13, %ebx
    1a9b: 44 31 c3                     	xorl	%r8d, %ebx
    1a9e: 41 89 fe                     	movl	%edi, %r14d
    1aa1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1aa5: 41 31 de                     	xorl	%ebx, %r14d
    1aa8: 44 89 cb                     	movl	%r9d, %ebx
    1aab: 09 c3                        	orl	%eax, %ebx
    1aad: 21 fb                        	andl	%edi, %ebx
    1aaf: 45 89 c8                     	movl	%r9d, %r8d
    1ab2: 41 21 c0                     	andl	%eax, %r8d
    1ab5: 41 09 d8                     	orl	%ebx, %r8d
    1ab8: 89 f3                        	movl	%esi, %ebx
    1aba: c1 c3 1a                     	roll	$0x1a, %ebx
    1abd: 45 01 f0                     	addl	%r14d, %r8d
    1ac0: 41 89 f6                     	movl	%esi, %r14d
    1ac3: 41 c1 c6 15                  	roll	$0x15, %r14d
    1ac7: 45 01 d8                     	addl	%r11d, %r8d
    1aca: 41 89 f3                     	movl	%esi, %r11d
    1acd: 41 c1 c3 07                  	roll	$0x7, %r11d
    1ad1: 41 31 de                     	xorl	%ebx, %r14d
    1ad4: 45 31 f3                     	xorl	%r14d, %r11d
    1ad7: 89 d3                        	movl	%edx, %ebx
    1ad9: 44 31 d3                     	xorl	%r10d, %ebx
    1adc: 21 f3                        	andl	%esi, %ebx
    1ade: 44 31 d3                     	xorl	%r10d, %ebx
    1ae1: 03 8d 48 ff ff ff            	addl	-0xb8(%rbp), %ecx
    1ae7: 01 d9                        	addl	%ebx, %ecx
    1ae9: 44 89 c3                     	movl	%r8d, %ebx
    1aec: c1 c3 1e                     	roll	$0x1e, %ebx
    1aef: 41 01 cb                     	addl	%ecx, %r11d
    1af2: 41 81 c3 51 63 ca 06         	addl	$0x6ca6351, %r11d       # imm = 0x6CA6351
    1af9: 44 89 c1                     	movl	%r8d, %ecx
    1afc: c1 c1 13                     	roll	$0x13, %ecx
    1aff: 44 01 d8                     	addl	%r11d, %eax
    1b02: 45 89 c6                     	movl	%r8d, %r14d
    1b05: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1b09: 31 d9                        	xorl	%ebx, %ecx
    1b0b: 41 31 ce                     	xorl	%ecx, %r14d
    1b0e: 89 fb                        	movl	%edi, %ebx
    1b10: 44 09 cb                     	orl	%r9d, %ebx
    1b13: 44 21 c3                     	andl	%r8d, %ebx
    1b16: 89 f9                        	movl	%edi, %ecx
    1b18: 44 21 c9                     	andl	%r9d, %ecx
    1b1b: 09 d9                        	orl	%ebx, %ecx
    1b1d: 44 01 f1                     	addl	%r14d, %ecx
    1b20: 89 c3                        	movl	%eax, %ebx
    1b22: c1 c3 1a                     	roll	$0x1a, %ebx
    1b25: 44 01 d9                     	addl	%r11d, %ecx
    1b28: 41 89 c3                     	movl	%eax, %r11d
    1b2b: 41 c1 c3 15                  	roll	$0x15, %r11d
    1b2f: 41 31 db                     	xorl	%ebx, %r11d
    1b32: 89 c3                        	movl	%eax, %ebx
    1b34: c1 c3 07                     	roll	$0x7, %ebx
    1b37: 44 31 db                     	xorl	%r11d, %ebx
    1b3a: 41 89 f3                     	movl	%esi, %r11d
    1b3d: 41 31 d3                     	xorl	%edx, %r11d
    1b40: 41 21 c3                     	andl	%eax, %r11d
    1b43: 41 31 d3                     	xorl	%edx, %r11d
    1b46: 44 03 95 4c ff ff ff         	addl	-0xb4(%rbp), %r10d
    1b4d: 45 01 da                     	addl	%r11d, %r10d
    1b50: 46 8d 1c 13                  	leal	(%rbx,%r10), %r11d
    1b54: 41 81 c3 67 29 29 14         	addl	$0x14292967, %r11d      # imm = 0x14292967
    1b5b: 41 89 ca                     	movl	%ecx, %r10d
    1b5e: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1b62: 45 01 d9                     	addl	%r11d, %r9d
    1b65: 89 cb                        	movl	%ecx, %ebx
    1b67: c1 c3 13                     	roll	$0x13, %ebx
    1b6a: 44 31 d3                     	xorl	%r10d, %ebx
    1b6d: 41 89 ce                     	movl	%ecx, %r14d
    1b70: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1b74: 41 31 de                     	xorl	%ebx, %r14d
    1b77: 44 89 c3                     	movl	%r8d, %ebx
    1b7a: 09 fb                        	orl	%edi, %ebx
    1b7c: 21 cb                        	andl	%ecx, %ebx
    1b7e: 45 89 c2                     	movl	%r8d, %r10d
    1b81: 41 21 fa                     	andl	%edi, %r10d
    1b84: 41 09 da                     	orl	%ebx, %r10d
    1b87: 45 01 f2                     	addl	%r14d, %r10d
    1b8a: 45 01 da                     	addl	%r11d, %r10d
    1b8d: 45 89 cb                     	movl	%r9d, %r11d
    1b90: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1b94: 44 89 cb                     	movl	%r9d, %ebx
    1b97: c1 c3 15                     	roll	$0x15, %ebx
    1b9a: 44 31 db                     	xorl	%r11d, %ebx
    1b9d: 45 89 cb                     	movl	%r9d, %r11d
    1ba0: 41 c1 c3 07                  	roll	$0x7, %r11d
    1ba4: 41 31 db                     	xorl	%ebx, %r11d
    1ba7: 89 c3                        	movl	%eax, %ebx
    1ba9: 31 f3                        	xorl	%esi, %ebx
    1bab: 44 21 cb                     	andl	%r9d, %ebx
    1bae: 31 f3                        	xorl	%esi, %ebx
    1bb0: 03 95 50 ff ff ff            	addl	-0xb0(%rbp), %edx
    1bb6: 01 da                        	addl	%ebx, %edx
    1bb8: 41 01 d3                     	addl	%edx, %r11d
    1bbb: 41 81 c3 85 0a b7 27         	addl	$0x27b70a85, %r11d      # imm = 0x27B70A85
    1bc2: 44 01 df                     	addl	%r11d, %edi
    1bc5: 44 89 d2                     	movl	%r10d, %edx
    1bc8: c1 c2 1e                     	roll	$0x1e, %edx
    1bcb: 44 89 d3                     	movl	%r10d, %ebx
    1bce: c1 c3 13                     	roll	$0x13, %ebx
    1bd1: 31 d3                        	xorl	%edx, %ebx
    1bd3: 45 89 d6                     	movl	%r10d, %r14d
    1bd6: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1bda: 41 31 de                     	xorl	%ebx, %r14d
    1bdd: 89 cb                        	movl	%ecx, %ebx
    1bdf: 44 09 c3                     	orl	%r8d, %ebx
    1be2: 44 21 d3                     	andl	%r10d, %ebx
    1be5: 89 ca                        	movl	%ecx, %edx
    1be7: 44 21 c2                     	andl	%r8d, %edx
    1bea: 09 da                        	orl	%ebx, %edx
    1bec: 44 01 f2                     	addl	%r14d, %edx
    1bef: 44 01 da                     	addl	%r11d, %edx
    1bf2: 41 89 fb                     	movl	%edi, %r11d
    1bf5: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1bf9: 89 fb                        	movl	%edi, %ebx
    1bfb: c1 c3 15                     	roll	$0x15, %ebx
    1bfe: 44 31 db                     	xorl	%r11d, %ebx
    1c01: 41 89 fb                     	movl	%edi, %r11d
    1c04: 41 c1 c3 07                  	roll	$0x7, %r11d
    1c08: 41 31 db                     	xorl	%ebx, %r11d
    1c0b: 44 89 cb                     	movl	%r9d, %ebx
    1c0e: 31 c3                        	xorl	%eax, %ebx
    1c10: 21 fb                        	andl	%edi, %ebx
    1c12: 03 b5 54 ff ff ff            	addl	-0xac(%rbp), %esi
    1c18: 31 c3                        	xorl	%eax, %ebx
    1c1a: 01 de                        	addl	%ebx, %esi
    1c1c: 41 01 f3                     	addl	%esi, %r11d
    1c1f: 41 81 c3 38 21 1b 2e         	addl	$0x2e1b2138, %r11d      # imm = 0x2E1B2138
    1c26: 45 01 d8                     	addl	%r11d, %r8d
    1c29: 89 d6                        	movl	%edx, %esi
    1c2b: c1 c6 1e                     	roll	$0x1e, %esi
    1c2e: 89 d3                        	movl	%edx, %ebx
    1c30: c1 c3 13                     	roll	$0x13, %ebx
    1c33: 31 f3                        	xorl	%esi, %ebx
    1c35: 41 89 d6                     	movl	%edx, %r14d
    1c38: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1c3c: 41 31 de                     	xorl	%ebx, %r14d
    1c3f: 44 89 d3                     	movl	%r10d, %ebx
    1c42: 09 cb                        	orl	%ecx, %ebx
    1c44: 21 d3                        	andl	%edx, %ebx
    1c46: 44 89 d6                     	movl	%r10d, %esi
    1c49: 21 ce                        	andl	%ecx, %esi
    1c4b: 09 de                        	orl	%ebx, %esi
    1c4d: 44 89 c3                     	movl	%r8d, %ebx
    1c50: c1 c3 1a                     	roll	$0x1a, %ebx
    1c53: 44 01 f6                     	addl	%r14d, %esi
    1c56: 45 89 c6                     	movl	%r8d, %r14d
    1c59: 41 c1 c6 15                  	roll	$0x15, %r14d
    1c5d: 44 01 de                     	addl	%r11d, %esi
    1c60: 45 89 c3                     	movl	%r8d, %r11d
    1c63: 41 c1 c3 07                  	roll	$0x7, %r11d
    1c67: 41 31 de                     	xorl	%ebx, %r14d
    1c6a: 45 31 f3                     	xorl	%r14d, %r11d
    1c6d: 89 fb                        	movl	%edi, %ebx
    1c6f: 44 31 cb                     	xorl	%r9d, %ebx
    1c72: 44 21 c3                     	andl	%r8d, %ebx
    1c75: 44 31 cb                     	xorl	%r9d, %ebx
    1c78: 03 85 58 ff ff ff            	addl	-0xa8(%rbp), %eax
    1c7e: 01 d8                        	addl	%ebx, %eax
    1c80: 89 f3                        	movl	%esi, %ebx
    1c82: c1 c3 1e                     	roll	$0x1e, %ebx
    1c85: 41 01 c3                     	addl	%eax, %r11d
    1c88: 41 81 c3 fc 6d 2c 4d         	addl	$0x4d2c6dfc, %r11d      # imm = 0x4D2C6DFC
    1c8f: 89 f0                        	movl	%esi, %eax
    1c91: c1 c0 13                     	roll	$0x13, %eax
    1c94: 44 01 d9                     	addl	%r11d, %ecx
    1c97: 41 89 f6                     	movl	%esi, %r14d
    1c9a: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1c9e: 31 d8                        	xorl	%ebx, %eax
    1ca0: 41 31 c6                     	xorl	%eax, %r14d
    1ca3: 89 d3                        	movl	%edx, %ebx
    1ca5: 44 09 d3                     	orl	%r10d, %ebx
    1ca8: 21 f3                        	andl	%esi, %ebx
    1caa: 89 d0                        	movl	%edx, %eax
    1cac: 44 21 d0                     	andl	%r10d, %eax
    1caf: 09 d8                        	orl	%ebx, %eax
    1cb1: 44 01 f0                     	addl	%r14d, %eax
    1cb4: 89 cb                        	movl	%ecx, %ebx
    1cb6: c1 c3 1a                     	roll	$0x1a, %ebx
    1cb9: 44 01 d8                     	addl	%r11d, %eax
    1cbc: 41 89 cb                     	movl	%ecx, %r11d
    1cbf: 41 c1 c3 15                  	roll	$0x15, %r11d
    1cc3: 41 31 db                     	xorl	%ebx, %r11d
    1cc6: 89 cb                        	movl	%ecx, %ebx
    1cc8: c1 c3 07                     	roll	$0x7, %ebx
    1ccb: 44 31 db                     	xorl	%r11d, %ebx
    1cce: 45 89 c3                     	movl	%r8d, %r11d
    1cd1: 41 31 fb                     	xorl	%edi, %r11d
    1cd4: 41 21 cb                     	andl	%ecx, %r11d
    1cd7: 41 31 fb                     	xorl	%edi, %r11d
    1cda: 44 03 8d 5c ff ff ff         	addl	-0xa4(%rbp), %r9d
    1ce1: 45 01 d9                     	addl	%r11d, %r9d
    1ce4: 46 8d 1c 0b                  	leal	(%rbx,%r9), %r11d
    1ce8: 41 81 c3 13 0d 38 53         	addl	$0x53380d13, %r11d      # imm = 0x53380D13
    1cef: 41 89 c1                     	movl	%eax, %r9d
    1cf2: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1cf6: 45 01 da                     	addl	%r11d, %r10d
    1cf9: 89 c3                        	movl	%eax, %ebx
    1cfb: c1 c3 13                     	roll	$0x13, %ebx
    1cfe: 44 31 cb                     	xorl	%r9d, %ebx
    1d01: 41 89 c6                     	movl	%eax, %r14d
    1d04: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1d08: 41 31 de                     	xorl	%ebx, %r14d
    1d0b: 89 f3                        	movl	%esi, %ebx
    1d0d: 09 d3                        	orl	%edx, %ebx
    1d0f: 21 c3                        	andl	%eax, %ebx
    1d11: 41 89 f1                     	movl	%esi, %r9d
    1d14: 41 21 d1                     	andl	%edx, %r9d
    1d17: 41 09 d9                     	orl	%ebx, %r9d
    1d1a: 45 01 f1                     	addl	%r14d, %r9d
    1d1d: 45 01 d9                     	addl	%r11d, %r9d
    1d20: 45 89 d3                     	movl	%r10d, %r11d
    1d23: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1d27: 44 89 d3                     	movl	%r10d, %ebx
    1d2a: c1 c3 15                     	roll	$0x15, %ebx
    1d2d: 44 31 db                     	xorl	%r11d, %ebx
    1d30: 45 89 d3                     	movl	%r10d, %r11d
    1d33: 41 c1 c3 07                  	roll	$0x7, %r11d
    1d37: 41 31 db                     	xorl	%ebx, %r11d
    1d3a: 89 cb                        	movl	%ecx, %ebx
    1d3c: 44 31 c3                     	xorl	%r8d, %ebx
    1d3f: 44 21 d3                     	andl	%r10d, %ebx
    1d42: 44 31 c3                     	xorl	%r8d, %ebx
    1d45: 03 bd 60 ff ff ff            	addl	-0xa0(%rbp), %edi
    1d4b: 01 df                        	addl	%ebx, %edi
    1d4d: 41 01 fb                     	addl	%edi, %r11d
    1d50: 41 81 c3 54 73 0a 65         	addl	$0x650a7354, %r11d      # imm = 0x650A7354
    1d57: 44 01 da                     	addl	%r11d, %edx
    1d5a: 44 89 cf                     	movl	%r9d, %edi
    1d5d: c1 c7 1e                     	roll	$0x1e, %edi
    1d60: 44 89 cb                     	movl	%r9d, %ebx
    1d63: c1 c3 13                     	roll	$0x13, %ebx
    1d66: 31 fb                        	xorl	%edi, %ebx
    1d68: 45 89 ce                     	movl	%r9d, %r14d
    1d6b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1d6f: 41 31 de                     	xorl	%ebx, %r14d
    1d72: 89 c3                        	movl	%eax, %ebx
    1d74: 09 f3                        	orl	%esi, %ebx
    1d76: 44 21 cb                     	andl	%r9d, %ebx
    1d79: 89 c7                        	movl	%eax, %edi
    1d7b: 21 f7                        	andl	%esi, %edi
    1d7d: 09 df                        	orl	%ebx, %edi
    1d7f: 44 01 f7                     	addl	%r14d, %edi
    1d82: 44 01 df                     	addl	%r11d, %edi
    1d85: 41 89 d3                     	movl	%edx, %r11d
    1d88: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1d8c: 89 d3                        	movl	%edx, %ebx
    1d8e: c1 c3 15                     	roll	$0x15, %ebx
    1d91: 44 31 db                     	xorl	%r11d, %ebx
    1d94: 41 89 d3                     	movl	%edx, %r11d
    1d97: 41 c1 c3 07                  	roll	$0x7, %r11d
    1d9b: 41 31 db                     	xorl	%ebx, %r11d
    1d9e: 44 89 d3                     	movl	%r10d, %ebx
    1da1: 31 cb                        	xorl	%ecx, %ebx
    1da3: 21 d3                        	andl	%edx, %ebx
    1da5: 44 03 85 64 ff ff ff         	addl	-0x9c(%rbp), %r8d
    1dac: 31 cb                        	xorl	%ecx, %ebx
    1dae: 41 01 d8                     	addl	%ebx, %r8d
    1db1: 45 01 c3                     	addl	%r8d, %r11d
    1db4: 41 81 c3 bb 0a 6a 76         	addl	$0x766a0abb, %r11d      # imm = 0x766A0ABB
    1dbb: 44 01 de                     	addl	%r11d, %esi
    1dbe: 41 89 f8                     	movl	%edi, %r8d
    1dc1: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1dc5: 89 fb                        	movl	%edi, %ebx
    1dc7: c1 c3 13                     	roll	$0x13, %ebx
    1dca: 44 31 c3                     	xorl	%r8d, %ebx
    1dcd: 41 89 fe                     	movl	%edi, %r14d
    1dd0: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1dd4: 41 31 de                     	xorl	%ebx, %r14d
    1dd7: 44 89 cb                     	movl	%r9d, %ebx
    1dda: 09 c3                        	orl	%eax, %ebx
    1ddc: 21 fb                        	andl	%edi, %ebx
    1dde: 45 89 c8                     	movl	%r9d, %r8d
    1de1: 41 21 c0                     	andl	%eax, %r8d
    1de4: 41 09 d8                     	orl	%ebx, %r8d
    1de7: 89 f3                        	movl	%esi, %ebx
    1de9: c1 c3 1a                     	roll	$0x1a, %ebx
    1dec: 45 01 f0                     	addl	%r14d, %r8d
    1def: 41 89 f6                     	movl	%esi, %r14d
    1df2: 41 c1 c6 15                  	roll	$0x15, %r14d
    1df6: 45 01 d8                     	addl	%r11d, %r8d
    1df9: 41 89 f3                     	movl	%esi, %r11d
    1dfc: 41 c1 c3 07                  	roll	$0x7, %r11d
    1e00: 41 31 de                     	xorl	%ebx, %r14d
    1e03: 45 31 f3                     	xorl	%r14d, %r11d
    1e06: 89 d3                        	movl	%edx, %ebx
    1e08: 44 31 d3                     	xorl	%r10d, %ebx
    1e0b: 21 f3                        	andl	%esi, %ebx
    1e0d: 44 31 d3                     	xorl	%r10d, %ebx
    1e10: 03 8d 68 ff ff ff            	addl	-0x98(%rbp), %ecx
    1e16: 01 d9                        	addl	%ebx, %ecx
    1e18: 44 89 c3                     	movl	%r8d, %ebx
    1e1b: c1 c3 1e                     	roll	$0x1e, %ebx
    1e1e: 41 01 cb                     	addl	%ecx, %r11d
    1e21: 41 81 c3 2e c9 c2 81         	addl	$0x81c2c92e, %r11d      # imm = 0x81C2C92E
    1e28: 44 89 c1                     	movl	%r8d, %ecx
    1e2b: c1 c1 13                     	roll	$0x13, %ecx
    1e2e: 44 01 d8                     	addl	%r11d, %eax
    1e31: 45 89 c6                     	movl	%r8d, %r14d
    1e34: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1e38: 31 d9                        	xorl	%ebx, %ecx
    1e3a: 41 31 ce                     	xorl	%ecx, %r14d
    1e3d: 89 fb                        	movl	%edi, %ebx
    1e3f: 44 09 cb                     	orl	%r9d, %ebx
    1e42: 44 21 c3                     	andl	%r8d, %ebx
    1e45: 89 f9                        	movl	%edi, %ecx
    1e47: 44 21 c9                     	andl	%r9d, %ecx
    1e4a: 09 d9                        	orl	%ebx, %ecx
    1e4c: 44 01 f1                     	addl	%r14d, %ecx
    1e4f: 89 c3                        	movl	%eax, %ebx
    1e51: c1 c3 1a                     	roll	$0x1a, %ebx
    1e54: 44 01 d9                     	addl	%r11d, %ecx
    1e57: 41 89 c3                     	movl	%eax, %r11d
    1e5a: 41 c1 c3 15                  	roll	$0x15, %r11d
    1e5e: 41 31 db                     	xorl	%ebx, %r11d
    1e61: 89 c3                        	movl	%eax, %ebx
    1e63: c1 c3 07                     	roll	$0x7, %ebx
    1e66: 44 31 db                     	xorl	%r11d, %ebx
    1e69: 41 89 f3                     	movl	%esi, %r11d
    1e6c: 41 31 d3                     	xorl	%edx, %r11d
    1e6f: 41 21 c3                     	andl	%eax, %r11d
    1e72: 41 31 d3                     	xorl	%edx, %r11d
    1e75: 44 03 95 6c ff ff ff         	addl	-0x94(%rbp), %r10d
    1e7c: 45 01 da                     	addl	%r11d, %r10d
    1e7f: 46 8d 1c 13                  	leal	(%rbx,%r10), %r11d
    1e83: 41 81 c3 85 2c 72 92         	addl	$0x92722c85, %r11d      # imm = 0x92722C85
    1e8a: 41 89 ca                     	movl	%ecx, %r10d
    1e8d: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1e91: 45 01 d9                     	addl	%r11d, %r9d
    1e94: 89 cb                        	movl	%ecx, %ebx
    1e96: c1 c3 13                     	roll	$0x13, %ebx
    1e99: 44 31 d3                     	xorl	%r10d, %ebx
    1e9c: 41 89 ce                     	movl	%ecx, %r14d
    1e9f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1ea3: 41 31 de                     	xorl	%ebx, %r14d
    1ea6: 44 89 c3                     	movl	%r8d, %ebx
    1ea9: 09 fb                        	orl	%edi, %ebx
    1eab: 21 cb                        	andl	%ecx, %ebx
    1ead: 45 89 c2                     	movl	%r8d, %r10d
    1eb0: 41 21 fa                     	andl	%edi, %r10d
    1eb3: 41 09 da                     	orl	%ebx, %r10d
    1eb6: 45 01 f2                     	addl	%r14d, %r10d
    1eb9: 45 01 da                     	addl	%r11d, %r10d
    1ebc: 45 89 cb                     	movl	%r9d, %r11d
    1ebf: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1ec3: 44 89 cb                     	movl	%r9d, %ebx
    1ec6: c1 c3 15                     	roll	$0x15, %ebx
    1ec9: 44 31 db                     	xorl	%r11d, %ebx
    1ecc: 45 89 cb                     	movl	%r9d, %r11d
    1ecf: 41 c1 c3 07                  	roll	$0x7, %r11d
    1ed3: 41 31 db                     	xorl	%ebx, %r11d
    1ed6: 89 c3                        	movl	%eax, %ebx
    1ed8: 31 f3                        	xorl	%esi, %ebx
    1eda: 44 21 cb                     	andl	%r9d, %ebx
    1edd: 31 f3                        	xorl	%esi, %ebx
    1edf: 03 95 70 ff ff ff            	addl	-0x90(%rbp), %edx
    1ee5: 01 da                        	addl	%ebx, %edx
    1ee7: 41 01 d3                     	addl	%edx, %r11d
    1eea: 41 81 c3 a1 e8 bf a2         	addl	$0xa2bfe8a1, %r11d      # imm = 0xA2BFE8A1
    1ef1: 44 01 df                     	addl	%r11d, %edi
    1ef4: 44 89 d2                     	movl	%r10d, %edx
    1ef7: c1 c2 1e                     	roll	$0x1e, %edx
    1efa: 44 89 d3                     	movl	%r10d, %ebx
    1efd: c1 c3 13                     	roll	$0x13, %ebx
    1f00: 31 d3                        	xorl	%edx, %ebx
    1f02: 45 89 d6                     	movl	%r10d, %r14d
    1f05: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1f09: 41 31 de                     	xorl	%ebx, %r14d
    1f0c: 89 cb                        	movl	%ecx, %ebx
    1f0e: 44 09 c3                     	orl	%r8d, %ebx
    1f11: 44 21 d3                     	andl	%r10d, %ebx
    1f14: 89 ca                        	movl	%ecx, %edx
    1f16: 44 21 c2                     	andl	%r8d, %edx
    1f19: 09 da                        	orl	%ebx, %edx
    1f1b: 44 01 f2                     	addl	%r14d, %edx
    1f1e: 44 01 da                     	addl	%r11d, %edx
    1f21: 41 89 fb                     	movl	%edi, %r11d
    1f24: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1f28: 89 fb                        	movl	%edi, %ebx
    1f2a: c1 c3 15                     	roll	$0x15, %ebx
    1f2d: 44 31 db                     	xorl	%r11d, %ebx
    1f30: 41 89 fb                     	movl	%edi, %r11d
    1f33: 41 c1 c3 07                  	roll	$0x7, %r11d
    1f37: 41 31 db                     	xorl	%ebx, %r11d
    1f3a: 44 89 cb                     	movl	%r9d, %ebx
    1f3d: 31 c3                        	xorl	%eax, %ebx
    1f3f: 21 fb                        	andl	%edi, %ebx
    1f41: 03 b5 74 ff ff ff            	addl	-0x8c(%rbp), %esi
    1f47: 31 c3                        	xorl	%eax, %ebx
    1f49: 01 de                        	addl	%ebx, %esi
    1f4b: 41 01 f3                     	addl	%esi, %r11d
    1f4e: 41 81 c3 4b 66 1a a8         	addl	$0xa81a664b, %r11d      # imm = 0xA81A664B
    1f55: 45 01 d8                     	addl	%r11d, %r8d
    1f58: 89 d6                        	movl	%edx, %esi
    1f5a: c1 c6 1e                     	roll	$0x1e, %esi
    1f5d: 89 d3                        	movl	%edx, %ebx
    1f5f: c1 c3 13                     	roll	$0x13, %ebx
    1f62: 31 f3                        	xorl	%esi, %ebx
    1f64: 41 89 d6                     	movl	%edx, %r14d
    1f67: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1f6b: 41 31 de                     	xorl	%ebx, %r14d
    1f6e: 44 89 d3                     	movl	%r10d, %ebx
    1f71: 09 cb                        	orl	%ecx, %ebx
    1f73: 21 d3                        	andl	%edx, %ebx
    1f75: 44 89 d6                     	movl	%r10d, %esi
    1f78: 21 ce                        	andl	%ecx, %esi
    1f7a: 09 de                        	orl	%ebx, %esi
    1f7c: 44 89 c3                     	movl	%r8d, %ebx
    1f7f: c1 c3 1a                     	roll	$0x1a, %ebx
    1f82: 44 01 f6                     	addl	%r14d, %esi
    1f85: 45 89 c6                     	movl	%r8d, %r14d
    1f88: 41 c1 c6 15                  	roll	$0x15, %r14d
    1f8c: 44 01 de                     	addl	%r11d, %esi
    1f8f: 45 89 c3                     	movl	%r8d, %r11d
    1f92: 41 c1 c3 07                  	roll	$0x7, %r11d
    1f96: 41 31 de                     	xorl	%ebx, %r14d
    1f99: 45 31 f3                     	xorl	%r14d, %r11d
    1f9c: 89 fb                        	movl	%edi, %ebx
    1f9e: 44 31 cb                     	xorl	%r9d, %ebx
    1fa1: 44 21 c3                     	andl	%r8d, %ebx
    1fa4: 44 31 cb                     	xorl	%r9d, %ebx
    1fa7: 03 85 78 ff ff ff            	addl	-0x88(%rbp), %eax
    1fad: 01 d8                        	addl	%ebx, %eax
    1faf: 89 f3                        	movl	%esi, %ebx
    1fb1: c1 c3 1e                     	roll	$0x1e, %ebx
    1fb4: 41 01 c3                     	addl	%eax, %r11d
    1fb7: 41 81 c3 70 8b 4b c2         	addl	$0xc24b8b70, %r11d      # imm = 0xC24B8B70
    1fbe: 89 f0                        	movl	%esi, %eax
    1fc0: c1 c0 13                     	roll	$0x13, %eax
    1fc3: 44 01 d9                     	addl	%r11d, %ecx
    1fc6: 41 89 f6                     	movl	%esi, %r14d
    1fc9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1fcd: 31 d8                        	xorl	%ebx, %eax
    1fcf: 41 31 c6                     	xorl	%eax, %r14d
    1fd2: 89 d3                        	movl	%edx, %ebx
    1fd4: 44 09 d3                     	orl	%r10d, %ebx
    1fd7: 21 f3                        	andl	%esi, %ebx
    1fd9: 89 d0                        	movl	%edx, %eax
    1fdb: 44 21 d0                     	andl	%r10d, %eax
    1fde: 09 d8                        	orl	%ebx, %eax
    1fe0: 44 01 f0                     	addl	%r14d, %eax
    1fe3: 89 cb                        	movl	%ecx, %ebx
    1fe5: c1 c3 1a                     	roll	$0x1a, %ebx
    1fe8: 44 01 d8                     	addl	%r11d, %eax
    1feb: 41 89 cb                     	movl	%ecx, %r11d
    1fee: 41 c1 c3 15                  	roll	$0x15, %r11d
    1ff2: 41 31 db                     	xorl	%ebx, %r11d
    1ff5: 89 cb                        	movl	%ecx, %ebx
    1ff7: c1 c3 07                     	roll	$0x7, %ebx
    1ffa: 44 31 db                     	xorl	%r11d, %ebx
    1ffd: 45 89 c3                     	movl	%r8d, %r11d
    2000: 41 31 fb                     	xorl	%edi, %r11d
    2003: 41 21 cb                     	andl	%ecx, %r11d
    2006: 41 31 fb                     	xorl	%edi, %r11d
    2009: 44 03 8d 7c ff ff ff         	addl	-0x84(%rbp), %r9d
    2010: 45 01 d9                     	addl	%r11d, %r9d
    2013: 41 01 d9                     	addl	%ebx, %r9d
    2016: 41 81 c1 a3 51 6c c7         	addl	$0xc76c51a3, %r9d       # imm = 0xC76C51A3
    201d: 41 89 c3                     	movl	%eax, %r11d
    2020: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    2024: 45 01 ca                     	addl	%r9d, %r10d
    2027: 89 c3                        	movl	%eax, %ebx
    2029: c1 c3 13                     	roll	$0x13, %ebx
    202c: 44 31 db                     	xorl	%r11d, %ebx
    202f: 41 89 c6                     	movl	%eax, %r14d
    2032: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2036: 41 31 de                     	xorl	%ebx, %r14d
    2039: 89 f3                        	movl	%esi, %ebx
    203b: 09 d3                        	orl	%edx, %ebx
    203d: 21 c3                        	andl	%eax, %ebx
    203f: 41 89 f3                     	movl	%esi, %r11d
    2042: 41 21 d3                     	andl	%edx, %r11d
    2045: 41 09 db                     	orl	%ebx, %r11d
    2048: 45 01 f3                     	addl	%r14d, %r11d
    204b: 45 01 cb                     	addl	%r9d, %r11d
    204e: 45 89 d1                     	movl	%r10d, %r9d
    2051: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    2055: 44 89 d3                     	movl	%r10d, %ebx
    2058: c1 c3 15                     	roll	$0x15, %ebx
    205b: 44 31 cb                     	xorl	%r9d, %ebx
    205e: 45 89 d1                     	movl	%r10d, %r9d
    2061: 41 c1 c1 07                  	roll	$0x7, %r9d
    2065: 41 31 d9                     	xorl	%ebx, %r9d
    2068: 89 cb                        	movl	%ecx, %ebx
    206a: 44 31 c3                     	xorl	%r8d, %ebx
    206d: 44 21 d3                     	andl	%r10d, %ebx
    2070: 44 31 c3                     	xorl	%r8d, %ebx
    2073: 03 7d 80                     	addl	-0x80(%rbp), %edi
    2076: 01 df                        	addl	%ebx, %edi
    2078: 41 01 f9                     	addl	%edi, %r9d
    207b: 41 81 c1 19 e8 92 d1         	addl	$0xd192e819, %r9d       # imm = 0xD192E819
    2082: 44 01 ca                     	addl	%r9d, %edx
    2085: 44 89 df                     	movl	%r11d, %edi
    2088: c1 c7 1e                     	roll	$0x1e, %edi
    208b: 44 89 db                     	movl	%r11d, %ebx
    208e: c1 c3 13                     	roll	$0x13, %ebx
    2091: 31 fb                        	xorl	%edi, %ebx
    2093: 45 89 de                     	movl	%r11d, %r14d
    2096: 41 c1 c6 0a                  	roll	$0xa, %r14d
    209a: 41 31 de                     	xorl	%ebx, %r14d
    209d: 89 c3                        	movl	%eax, %ebx
    209f: 09 f3                        	orl	%esi, %ebx
    20a1: 44 21 db                     	andl	%r11d, %ebx
    20a4: 89 c7                        	movl	%eax, %edi
    20a6: 21 f7                        	andl	%esi, %edi
    20a8: 09 df                        	orl	%ebx, %edi
    20aa: 44 01 f7                     	addl	%r14d, %edi
    20ad: 44 01 cf                     	addl	%r9d, %edi
    20b0: 41 89 d1                     	movl	%edx, %r9d
    20b3: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    20b7: 89 d3                        	movl	%edx, %ebx
    20b9: c1 c3 15                     	roll	$0x15, %ebx
    20bc: 44 31 cb                     	xorl	%r9d, %ebx
    20bf: 41 89 d1                     	movl	%edx, %r9d
    20c2: 41 c1 c1 07                  	roll	$0x7, %r9d
    20c6: 41 31 d9                     	xorl	%ebx, %r9d
    20c9: 44 89 d3                     	movl	%r10d, %ebx
    20cc: 31 cb                        	xorl	%ecx, %ebx
    20ce: 21 d3                        	andl	%edx, %ebx
    20d0: 44 03 45 84                  	addl	-0x7c(%rbp), %r8d
    20d4: 31 cb                        	xorl	%ecx, %ebx
    20d6: 41 01 d8                     	addl	%ebx, %r8d
    20d9: 45 01 c1                     	addl	%r8d, %r9d
    20dc: 41 81 c1 24 06 99 d6         	addl	$0xd6990624, %r9d       # imm = 0xD6990624
    20e3: 44 01 ce                     	addl	%r9d, %esi
    20e6: 41 89 f8                     	movl	%edi, %r8d
    20e9: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    20ed: 89 fb                        	movl	%edi, %ebx
    20ef: c1 c3 13                     	roll	$0x13, %ebx
    20f2: 44 31 c3                     	xorl	%r8d, %ebx
    20f5: 41 89 fe                     	movl	%edi, %r14d
    20f8: 41 c1 c6 0a                  	roll	$0xa, %r14d
    20fc: 41 31 de                     	xorl	%ebx, %r14d
    20ff: 44 89 db                     	movl	%r11d, %ebx
    2102: 09 c3                        	orl	%eax, %ebx
    2104: 21 fb                        	andl	%edi, %ebx
    2106: 45 89 d8                     	movl	%r11d, %r8d
    2109: 41 21 c0                     	andl	%eax, %r8d
    210c: 41 09 d8                     	orl	%ebx, %r8d
    210f: 89 f3                        	movl	%esi, %ebx
    2111: c1 c3 1a                     	roll	$0x1a, %ebx
    2114: 45 01 f0                     	addl	%r14d, %r8d
    2117: 41 89 f6                     	movl	%esi, %r14d
    211a: 41 c1 c6 15                  	roll	$0x15, %r14d
    211e: 45 01 c8                     	addl	%r9d, %r8d
    2121: 41 89 f1                     	movl	%esi, %r9d
    2124: 41 c1 c1 07                  	roll	$0x7, %r9d
    2128: 41 31 de                     	xorl	%ebx, %r14d
    212b: 45 31 f1                     	xorl	%r14d, %r9d
    212e: 89 d3                        	movl	%edx, %ebx
    2130: 44 31 d3                     	xorl	%r10d, %ebx
    2133: 21 f3                        	andl	%esi, %ebx
    2135: 44 31 d3                     	xorl	%r10d, %ebx
    2138: 03 4d 88                     	addl	-0x78(%rbp), %ecx
    213b: 01 d9                        	addl	%ebx, %ecx
    213d: 44 89 c3                     	movl	%r8d, %ebx
    2140: c1 c3 1e                     	roll	$0x1e, %ebx
    2143: 41 01 c9                     	addl	%ecx, %r9d
    2146: 41 81 c1 85 35 0e f4         	addl	$0xf40e3585, %r9d       # imm = 0xF40E3585
    214d: 44 89 c1                     	movl	%r8d, %ecx
    2150: c1 c1 13                     	roll	$0x13, %ecx
    2153: 44 01 c8                     	addl	%r9d, %eax
    2156: 45 89 c6                     	movl	%r8d, %r14d
    2159: 41 c1 c6 0a                  	roll	$0xa, %r14d
    215d: 31 d9                        	xorl	%ebx, %ecx
    215f: 41 31 ce                     	xorl	%ecx, %r14d
    2162: 89 fb                        	movl	%edi, %ebx
    2164: 44 09 db                     	orl	%r11d, %ebx
    2167: 44 21 c3                     	andl	%r8d, %ebx
    216a: 89 f9                        	movl	%edi, %ecx
    216c: 44 21 d9                     	andl	%r11d, %ecx
    216f: 09 d9                        	orl	%ebx, %ecx
    2171: 44 01 f1                     	addl	%r14d, %ecx
    2174: 89 c3                        	movl	%eax, %ebx
    2176: c1 c3 1a                     	roll	$0x1a, %ebx
    2179: 44 01 c9                     	addl	%r9d, %ecx
    217c: 41 89 c1                     	movl	%eax, %r9d
    217f: 41 c1 c1 15                  	roll	$0x15, %r9d
    2183: 41 31 d9                     	xorl	%ebx, %r9d
    2186: 89 c3                        	movl	%eax, %ebx
    2188: c1 c3 07                     	roll	$0x7, %ebx
    218b: 44 31 cb                     	xorl	%r9d, %ebx
    218e: 41 89 f1                     	movl	%esi, %r9d
    2191: 41 31 d1                     	xorl	%edx, %r9d
    2194: 41 21 c1                     	andl	%eax, %r9d
    2197: 41 31 d1                     	xorl	%edx, %r9d
    219a: 44 03 55 8c                  	addl	-0x74(%rbp), %r10d
    219e: 45 01 ca                     	addl	%r9d, %r10d
    21a1: 46 8d 0c 13                  	leal	(%rbx,%r10), %r9d
    21a5: 41 81 c1 70 a0 6a 10         	addl	$0x106aa070, %r9d       # imm = 0x106AA070
    21ac: 41 89 ca                     	movl	%ecx, %r10d
    21af: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    21b3: 45 01 cb                     	addl	%r9d, %r11d
    21b6: 89 cb                        	movl	%ecx, %ebx
    21b8: c1 c3 13                     	roll	$0x13, %ebx
    21bb: 44 31 d3                     	xorl	%r10d, %ebx
    21be: 41 89 ce                     	movl	%ecx, %r14d
    21c1: 41 c1 c6 0a                  	roll	$0xa, %r14d
    21c5: 41 31 de                     	xorl	%ebx, %r14d
    21c8: 44 89 c3                     	movl	%r8d, %ebx
    21cb: 09 fb                        	orl	%edi, %ebx
    21cd: 21 cb                        	andl	%ecx, %ebx
    21cf: 45 89 c2                     	movl	%r8d, %r10d
    21d2: 41 21 fa                     	andl	%edi, %r10d
    21d5: 41 09 da                     	orl	%ebx, %r10d
    21d8: 45 01 f2                     	addl	%r14d, %r10d
    21db: 45 01 ca                     	addl	%r9d, %r10d
    21de: 45 89 d9                     	movl	%r11d, %r9d
    21e1: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    21e5: 44 89 db                     	movl	%r11d, %ebx
    21e8: c1 c3 15                     	roll	$0x15, %ebx
    21eb: 44 31 cb                     	xorl	%r9d, %ebx
    21ee: 45 89 d9                     	movl	%r11d, %r9d
    21f1: 41 c1 c1 07                  	roll	$0x7, %r9d
    21f5: 41 31 d9                     	xorl	%ebx, %r9d
    21f8: 89 c3                        	movl	%eax, %ebx
    21fa: 31 f3                        	xorl	%esi, %ebx
    21fc: 44 21 db                     	andl	%r11d, %ebx
    21ff: 31 f3                        	xorl	%esi, %ebx
    2201: 03 55 90                     	addl	-0x70(%rbp), %edx
    2204: 01 da                        	addl	%ebx, %edx
    2206: 44 01 ca                     	addl	%r9d, %edx
    2209: 81 c2 16 c1 a4 19            	addl	$0x19a4c116, %edx       # imm = 0x19A4C116
    220f: 01 d7                        	addl	%edx, %edi
    2211: 45 89 d1                     	movl	%r10d, %r9d
    2214: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    2218: 44 89 d3                     	movl	%r10d, %ebx
    221b: c1 c3 13                     	roll	$0x13, %ebx
    221e: 44 31 cb                     	xorl	%r9d, %ebx
    2221: 45 89 d6                     	movl	%r10d, %r14d
    2224: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2228: 41 31 de                     	xorl	%ebx, %r14d
    222b: 89 cb                        	movl	%ecx, %ebx
    222d: 44 09 c3                     	orl	%r8d, %ebx
    2230: 44 21 d3                     	andl	%r10d, %ebx
    2233: 41 89 c9                     	movl	%ecx, %r9d
    2236: 45 21 c1                     	andl	%r8d, %r9d
    2239: 41 09 d9                     	orl	%ebx, %r9d
    223c: 45 01 f1                     	addl	%r14d, %r9d
    223f: 41 01 d1                     	addl	%edx, %r9d
    2242: 89 fa                        	movl	%edi, %edx
    2244: c1 c2 1a                     	roll	$0x1a, %edx
    2247: 89 fb                        	movl	%edi, %ebx
    2249: c1 c3 15                     	roll	$0x15, %ebx
    224c: 31 d3                        	xorl	%edx, %ebx
    224e: 89 fa                        	movl	%edi, %edx
    2250: c1 c2 07                     	roll	$0x7, %edx
    2253: 31 da                        	xorl	%ebx, %edx
    2255: 44 89 db                     	movl	%r11d, %ebx
    2258: 31 c3                        	xorl	%eax, %ebx
    225a: 21 fb                        	andl	%edi, %ebx
    225c: 03 75 94                     	addl	-0x6c(%rbp), %esi
    225f: 31 c3                        	xorl	%eax, %ebx
    2261: 01 de                        	addl	%ebx, %esi
    2263: 01 f2                        	addl	%esi, %edx
    2265: 81 c2 08 6c 37 1e            	addl	$0x1e376c08, %edx       # imm = 0x1E376C08
    226b: 41 01 d0                     	addl	%edx, %r8d
    226e: 44 89 ce                     	movl	%r9d, %esi
    2271: c1 c6 1e                     	roll	$0x1e, %esi
    2274: 44 89 cb                     	movl	%r9d, %ebx
    2277: c1 c3 13                     	roll	$0x13, %ebx
    227a: 31 f3                        	xorl	%esi, %ebx
    227c: 45 89 ce                     	movl	%r9d, %r14d
    227f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2283: 41 31 de                     	xorl	%ebx, %r14d
    2286: 44 89 d3                     	movl	%r10d, %ebx
    2289: 09 cb                        	orl	%ecx, %ebx
    228b: 44 21 cb                     	andl	%r9d, %ebx
    228e: 44 89 d6                     	movl	%r10d, %esi
    2291: 21 ce                        	andl	%ecx, %esi
    2293: 09 de                        	orl	%ebx, %esi
    2295: 44 89 c3                     	movl	%r8d, %ebx
    2298: c1 c3 1a                     	roll	$0x1a, %ebx
    229b: 44 01 f6                     	addl	%r14d, %esi
    229e: 45 89 c6                     	movl	%r8d, %r14d
    22a1: 41 c1 c6 15                  	roll	$0x15, %r14d
    22a5: 01 d6                        	addl	%edx, %esi
    22a7: 44 89 c2                     	movl	%r8d, %edx
    22aa: c1 c2 07                     	roll	$0x7, %edx
    22ad: 41 31 de                     	xorl	%ebx, %r14d
    22b0: 44 31 f2                     	xorl	%r14d, %edx
    22b3: 89 fb                        	movl	%edi, %ebx
    22b5: 44 31 db                     	xorl	%r11d, %ebx
    22b8: 44 21 c3                     	andl	%r8d, %ebx
    22bb: 44 31 db                     	xorl	%r11d, %ebx
    22be: 03 45 98                     	addl	-0x68(%rbp), %eax
    22c1: 01 d8                        	addl	%ebx, %eax
    22c3: 89 f3                        	movl	%esi, %ebx
    22c5: c1 c3 1e                     	roll	$0x1e, %ebx
    22c8: 01 d0                        	addl	%edx, %eax
    22ca: 05 4c 77 48 27               	addl	$0x2748774c, %eax       # imm = 0x2748774C
    22cf: 89 f2                        	movl	%esi, %edx
    22d1: c1 c2 13                     	roll	$0x13, %edx
    22d4: 01 c1                        	addl	%eax, %ecx
    22d6: 41 89 f6                     	movl	%esi, %r14d
    22d9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    22dd: 31 da                        	xorl	%ebx, %edx
    22df: 41 31 d6                     	xorl	%edx, %r14d
    22e2: 44 89 cb                     	movl	%r9d, %ebx
    22e5: 44 09 d3                     	orl	%r10d, %ebx
    22e8: 21 f3                        	andl	%esi, %ebx
    22ea: 44 89 ca                     	movl	%r9d, %edx
    22ed: 44 21 d2                     	andl	%r10d, %edx
    22f0: 09 da                        	orl	%ebx, %edx
    22f2: 44 01 f2                     	addl	%r14d, %edx
    22f5: 89 cb                        	movl	%ecx, %ebx
    22f7: c1 c3 1a                     	roll	$0x1a, %ebx
    22fa: 01 c2                        	addl	%eax, %edx
    22fc: 89 c8                        	movl	%ecx, %eax
    22fe: c1 c0 15                     	roll	$0x15, %eax
    2301: 31 d8                        	xorl	%ebx, %eax
    2303: 89 cb                        	movl	%ecx, %ebx
    2305: c1 c3 07                     	roll	$0x7, %ebx
    2308: 31 c3                        	xorl	%eax, %ebx
    230a: 44 89 c0                     	movl	%r8d, %eax
    230d: 31 f8                        	xorl	%edi, %eax
    230f: 21 c8                        	andl	%ecx, %eax
    2311: 31 f8                        	xorl	%edi, %eax
    2313: 44 03 5d 9c                  	addl	-0x64(%rbp), %r11d
    2317: 41 01 c3                     	addl	%eax, %r11d
    231a: 42 8d 04 1b                  	leal	(%rbx,%r11), %eax
    231e: 05 b5 bc b0 34               	addl	$0x34b0bcb5, %eax       # imm = 0x34B0BCB5
    2323: 41 89 d3                     	movl	%edx, %r11d
    2326: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    232a: 41 01 c2                     	addl	%eax, %r10d
    232d: 89 d3                        	movl	%edx, %ebx
    232f: c1 c3 13                     	roll	$0x13, %ebx
    2332: 44 31 db                     	xorl	%r11d, %ebx
    2335: 41 89 d6                     	movl	%edx, %r14d
    2338: 41 c1 c6 0a                  	roll	$0xa, %r14d
    233c: 41 31 de                     	xorl	%ebx, %r14d
    233f: 89 f3                        	movl	%esi, %ebx
    2341: 44 09 cb                     	orl	%r9d, %ebx
    2344: 21 d3                        	andl	%edx, %ebx
    2346: 41 89 f3                     	movl	%esi, %r11d
    2349: 45 21 cb                     	andl	%r9d, %r11d
    234c: 41 09 db                     	orl	%ebx, %r11d
    234f: 45 01 f3                     	addl	%r14d, %r11d
    2352: 41 01 c3                     	addl	%eax, %r11d
    2355: 44 89 d0                     	movl	%r10d, %eax
    2358: c1 c0 1a                     	roll	$0x1a, %eax
    235b: 44 89 d3                     	movl	%r10d, %ebx
    235e: c1 c3 15                     	roll	$0x15, %ebx
    2361: 31 c3                        	xorl	%eax, %ebx
    2363: 44 89 d0                     	movl	%r10d, %eax
    2366: c1 c0 07                     	roll	$0x7, %eax
    2369: 31 d8                        	xorl	%ebx, %eax
    236b: 89 cb                        	movl	%ecx, %ebx
    236d: 44 31 c3                     	xorl	%r8d, %ebx
    2370: 44 21 d3                     	andl	%r10d, %ebx
    2373: 44 31 c3                     	xorl	%r8d, %ebx
    2376: 03 7d a0                     	addl	-0x60(%rbp), %edi
    2379: 01 df                        	addl	%ebx, %edi
    237b: 01 f8                        	addl	%edi, %eax
    237d: 05 b3 0c 1c 39               	addl	$0x391c0cb3, %eax       # imm = 0x391C0CB3
    2382: 41 01 c1                     	addl	%eax, %r9d
    2385: 44 89 df                     	movl	%r11d, %edi
    2388: c1 c7 1e                     	roll	$0x1e, %edi
    238b: 44 89 db                     	movl	%r11d, %ebx
    238e: c1 c3 13                     	roll	$0x13, %ebx
    2391: 31 fb                        	xorl	%edi, %ebx
    2393: 45 89 de                     	movl	%r11d, %r14d
    2396: 41 c1 c6 0a                  	roll	$0xa, %r14d
    239a: 41 31 de                     	xorl	%ebx, %r14d
    239d: 89 d3                        	movl	%edx, %ebx
    239f: 09 f3                        	orl	%esi, %ebx
    23a1: 44 21 db                     	andl	%r11d, %ebx
    23a4: 89 d7                        	movl	%edx, %edi
    23a6: 21 f7                        	andl	%esi, %edi
    23a8: 09 df                        	orl	%ebx, %edi
    23aa: 44 01 f7                     	addl	%r14d, %edi
    23ad: 01 c7                        	addl	%eax, %edi
    23af: 44 89 c8                     	movl	%r9d, %eax
    23b2: c1 c0 1a                     	roll	$0x1a, %eax
    23b5: 44 89 cb                     	movl	%r9d, %ebx
    23b8: c1 c3 15                     	roll	$0x15, %ebx
    23bb: 31 c3                        	xorl	%eax, %ebx
    23bd: 44 89 c8                     	movl	%r9d, %eax
    23c0: c1 c0 07                     	roll	$0x7, %eax
    23c3: 31 d8                        	xorl	%ebx, %eax
    23c5: 44 89 d3                     	movl	%r10d, %ebx
    23c8: 31 cb                        	xorl	%ecx, %ebx
    23ca: 44 21 cb                     	andl	%r9d, %ebx
    23cd: 44 03 45 a4                  	addl	-0x5c(%rbp), %r8d
    23d1: 31 cb                        	xorl	%ecx, %ebx
    23d3: 41 01 d8                     	addl	%ebx, %r8d
    23d6: 44 01 c0                     	addl	%r8d, %eax
    23d9: 05 4a aa d8 4e               	addl	$0x4ed8aa4a, %eax       # imm = 0x4ED8AA4A
    23de: 01 c6                        	addl	%eax, %esi
    23e0: 41 89 f8                     	movl	%edi, %r8d
    23e3: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    23e7: 89 fb                        	movl	%edi, %ebx
    23e9: c1 c3 13                     	roll	$0x13, %ebx
    23ec: 44 31 c3                     	xorl	%r8d, %ebx
    23ef: 41 89 fe                     	movl	%edi, %r14d
    23f2: 41 c1 c6 0a                  	roll	$0xa, %r14d
    23f6: 41 31 de                     	xorl	%ebx, %r14d
    23f9: 44 89 db                     	movl	%r11d, %ebx
    23fc: 09 d3                        	orl	%edx, %ebx
    23fe: 21 fb                        	andl	%edi, %ebx
    2400: 45 89 d8                     	movl	%r11d, %r8d
    2403: 41 21 d0                     	andl	%edx, %r8d
    2406: 41 09 d8                     	orl	%ebx, %r8d
    2409: 89 f3                        	movl	%esi, %ebx
    240b: c1 c3 1a                     	roll	$0x1a, %ebx
    240e: 45 01 f0                     	addl	%r14d, %r8d
    2411: 41 89 f6                     	movl	%esi, %r14d
    2414: 41 c1 c6 15                  	roll	$0x15, %r14d
    2418: 41 01 c0                     	addl	%eax, %r8d
    241b: 89 f0                        	movl	%esi, %eax
    241d: c1 c0 07                     	roll	$0x7, %eax
    2420: 41 31 de                     	xorl	%ebx, %r14d
    2423: 44 31 f0                     	xorl	%r14d, %eax
    2426: 44 89 cb                     	movl	%r9d, %ebx
    2429: 44 31 d3                     	xorl	%r10d, %ebx
    242c: 21 f3                        	andl	%esi, %ebx
    242e: 44 31 d3                     	xorl	%r10d, %ebx
    2431: 03 4d a8                     	addl	-0x58(%rbp), %ecx
    2434: 01 d9                        	addl	%ebx, %ecx
    2436: 44 89 c3                     	movl	%r8d, %ebx
    2439: c1 c3 1e                     	roll	$0x1e, %ebx
    243c: 01 c8                        	addl	%ecx, %eax
    243e: 05 4f ca 9c 5b               	addl	$0x5b9cca4f, %eax       # imm = 0x5B9CCA4F
    2443: 44 89 c1                     	movl	%r8d, %ecx
    2446: c1 c1 13                     	roll	$0x13, %ecx
    2449: 01 c2                        	addl	%eax, %edx
    244b: 45 89 c6                     	movl	%r8d, %r14d
    244e: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2452: 31 d9                        	xorl	%ebx, %ecx
    2454: 41 31 ce                     	xorl	%ecx, %r14d
    2457: 89 f9                        	movl	%edi, %ecx
    2459: 44 09 d9                     	orl	%r11d, %ecx
    245c: 44 21 c1                     	andl	%r8d, %ecx
    245f: 89 fb                        	movl	%edi, %ebx
    2461: 44 21 db                     	andl	%r11d, %ebx
    2464: 09 cb                        	orl	%ecx, %ebx
    2466: 44 01 f3                     	addl	%r14d, %ebx
    2469: 89 d1                        	movl	%edx, %ecx
    246b: c1 c1 1a                     	roll	$0x1a, %ecx
    246e: 01 c3                        	addl	%eax, %ebx
    2470: 89 d0                        	movl	%edx, %eax
    2472: c1 c0 15                     	roll	$0x15, %eax
    2475: 31 c8                        	xorl	%ecx, %eax
    2477: 89 d1                        	movl	%edx, %ecx
    2479: c1 c1 07                     	roll	$0x7, %ecx
    247c: 31 c1                        	xorl	%eax, %ecx
    247e: 89 f0                        	movl	%esi, %eax
    2480: 44 31 c8                     	xorl	%r9d, %eax
    2483: 21 d0                        	andl	%edx, %eax
    2485: 44 31 c8                     	xorl	%r9d, %eax
    2488: 44 03 55 ac                  	addl	-0x54(%rbp), %r10d
    248c: 41 01 c2                     	addl	%eax, %r10d
    248f: 42 8d 04 11                  	leal	(%rcx,%r10), %eax
    2493: 05 f3 6f 2e 68               	addl	$0x682e6ff3, %eax       # imm = 0x682E6FF3
    2498: 89 d9                        	movl	%ebx, %ecx
    249a: c1 c1 1e                     	roll	$0x1e, %ecx
    249d: 41 01 c3                     	addl	%eax, %r11d
    24a0: 41 89 da                     	movl	%ebx, %r10d
    24a3: 41 c1 c2 13                  	roll	$0x13, %r10d
    24a7: 41 31 ca                     	xorl	%ecx, %r10d
    24aa: 41 89 de                     	movl	%ebx, %r14d
    24ad: 41 c1 c6 0a                  	roll	$0xa, %r14d
    24b1: 45 31 d6                     	xorl	%r10d, %r14d
    24b4: 45 89 c2                     	movl	%r8d, %r10d
    24b7: 41 09 fa                     	orl	%edi, %r10d
    24ba: 41 21 da                     	andl	%ebx, %r10d
    24bd: 44 89 c1                     	movl	%r8d, %ecx
    24c0: 21 f9                        	andl	%edi, %ecx
    24c2: 44 09 d1                     	orl	%r10d, %ecx
    24c5: 44 01 f1                     	addl	%r14d, %ecx
    24c8: 01 c1                        	addl	%eax, %ecx
    24ca: 44 89 d8                     	movl	%r11d, %eax
    24cd: c1 c0 1a                     	roll	$0x1a, %eax
    24d0: 45 89 da                     	movl	%r11d, %r10d
    24d3: 41 c1 c2 15                  	roll	$0x15, %r10d
    24d7: 41 31 c2                     	xorl	%eax, %r10d
    24da: 44 89 d8                     	movl	%r11d, %eax
    24dd: c1 c0 07                     	roll	$0x7, %eax
    24e0: 44 31 d0                     	xorl	%r10d, %eax
    24e3: 41 89 d2                     	movl	%edx, %r10d
    24e6: 41 31 f2                     	xorl	%esi, %r10d
    24e9: 45 21 da                     	andl	%r11d, %r10d
    24ec: 41 31 f2                     	xorl	%esi, %r10d
    24ef: 44 03 4d b0                  	addl	-0x50(%rbp), %r9d
    24f3: 45 01 d1                     	addl	%r10d, %r9d
    24f6: 41 01 c1                     	addl	%eax, %r9d
    24f9: 41 81 c1 ee 82 8f 74         	addl	$0x748f82ee, %r9d       # imm = 0x748F82EE
    2500: 44 01 cf                     	addl	%r9d, %edi
    2503: 89 c8                        	movl	%ecx, %eax
    2505: c1 c0 1e                     	roll	$0x1e, %eax
    2508: 41 89 ca                     	movl	%ecx, %r10d
    250b: 41 c1 c2 13                  	roll	$0x13, %r10d
    250f: 41 31 c2                     	xorl	%eax, %r10d
    2512: 41 89 ce                     	movl	%ecx, %r14d
    2515: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2519: 45 31 d6                     	xorl	%r10d, %r14d
    251c: 41 89 da                     	movl	%ebx, %r10d
    251f: 45 09 c2                     	orl	%r8d, %r10d
    2522: 41 21 ca                     	andl	%ecx, %r10d
    2525: 89 d8                        	movl	%ebx, %eax
    2527: 44 21 c0                     	andl	%r8d, %eax
    252a: 44 09 d0                     	orl	%r10d, %eax
    252d: 44 01 f0                     	addl	%r14d, %eax
    2530: 44 01 c8                     	addl	%r9d, %eax
    2533: 41 89 f9                     	movl	%edi, %r9d
    2536: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    253a: 41 89 fa                     	movl	%edi, %r10d
    253d: 41 c1 c2 15                  	roll	$0x15, %r10d
    2541: 45 31 ca                     	xorl	%r9d, %r10d
    2544: 41 89 f9                     	movl	%edi, %r9d
    2547: 41 c1 c1 07                  	roll	$0x7, %r9d
    254b: 45 31 d1                     	xorl	%r10d, %r9d
    254e: 45 89 da                     	movl	%r11d, %r10d
    2551: 41 31 d2                     	xorl	%edx, %r10d
    2554: 41 21 fa                     	andl	%edi, %r10d
    2557: 03 75 b4                     	addl	-0x4c(%rbp), %esi
    255a: 41 31 d2                     	xorl	%edx, %r10d
    255d: 44 01 d6                     	addl	%r10d, %esi
    2560: 41 01 f1                     	addl	%esi, %r9d
    2563: 41 81 c1 6f 63 a5 78         	addl	$0x78a5636f, %r9d       # imm = 0x78A5636F
    256a: 45 01 c8                     	addl	%r9d, %r8d
    256d: 89 c6                        	movl	%eax, %esi
    256f: c1 c6 1e                     	roll	$0x1e, %esi
    2572: 41 89 c2                     	movl	%eax, %r10d
    2575: 41 c1 c2 13                  	roll	$0x13, %r10d
    2579: 41 31 f2                     	xorl	%esi, %r10d
    257c: 41 89 c6                     	movl	%eax, %r14d
    257f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2583: 45 31 d6                     	xorl	%r10d, %r14d
    2586: 41 89 ca                     	movl	%ecx, %r10d
    2589: 41 09 da                     	orl	%ebx, %r10d
    258c: 41 21 c2                     	andl	%eax, %r10d
    258f: 89 ce                        	movl	%ecx, %esi
    2591: 21 de                        	andl	%ebx, %esi
    2593: 44 09 d6                     	orl	%r10d, %esi
    2596: 45 89 c2                     	movl	%r8d, %r10d
    2599: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    259d: 44 01 f6                     	addl	%r14d, %esi
    25a0: 45 89 c6                     	movl	%r8d, %r14d
    25a3: 41 c1 c6 15                  	roll	$0x15, %r14d
    25a7: 44 01 ce                     	addl	%r9d, %esi
    25aa: 45 89 c1                     	movl	%r8d, %r9d
    25ad: 41 c1 c1 07                  	roll	$0x7, %r9d
    25b1: 45 31 d6                     	xorl	%r10d, %r14d
    25b4: 45 31 f1                     	xorl	%r14d, %r9d
    25b7: 41 89 fa                     	movl	%edi, %r10d
    25ba: 45 31 da                     	xorl	%r11d, %r10d
    25bd: 45 21 c2                     	andl	%r8d, %r10d
    25c0: 45 31 da                     	xorl	%r11d, %r10d
    25c3: 03 55 b8                     	addl	-0x48(%rbp), %edx
    25c6: 44 01 d2                     	addl	%r10d, %edx
    25c9: 41 89 f2                     	movl	%esi, %r10d
    25cc: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    25d0: 41 01 d1                     	addl	%edx, %r9d
    25d3: 41 81 c1 14 78 c8 84         	addl	$0x84c87814, %r9d       # imm = 0x84C87814
    25da: 89 f2                        	movl	%esi, %edx
    25dc: c1 c2 13                     	roll	$0x13, %edx
    25df: 44 01 cb                     	addl	%r9d, %ebx
    25e2: 41 89 f6                     	movl	%esi, %r14d
    25e5: 41 c1 c6 0a                  	roll	$0xa, %r14d
    25e9: 44 31 d2                     	xorl	%r10d, %edx
    25ec: 41 31 d6                     	xorl	%edx, %r14d
    25ef: 41 89 c2                     	movl	%eax, %r10d
    25f2: 41 09 ca                     	orl	%ecx, %r10d
    25f5: 41 21 f2                     	andl	%esi, %r10d
    25f8: 89 c2                        	movl	%eax, %edx
    25fa: 21 ca                        	andl	%ecx, %edx
    25fc: 44 09 d2                     	orl	%r10d, %edx
    25ff: 44 01 f2                     	addl	%r14d, %edx
    2602: 41 89 da                     	movl	%ebx, %r10d
    2605: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    2609: 44 01 ca                     	addl	%r9d, %edx
    260c: 41 89 d9                     	movl	%ebx, %r9d
    260f: 41 c1 c1 15                  	roll	$0x15, %r9d
    2613: 45 31 d1                     	xorl	%r10d, %r9d
    2616: 41 89 da                     	movl	%ebx, %r10d
    2619: 41 c1 c2 07                  	roll	$0x7, %r10d
    261d: 45 31 ca                     	xorl	%r9d, %r10d
    2620: 45 89 c1                     	movl	%r8d, %r9d
    2623: 41 31 f9                     	xorl	%edi, %r9d
    2626: 41 21 d9                     	andl	%ebx, %r9d
    2629: 41 31 f9                     	xorl	%edi, %r9d
    262c: 44 03 5d bc                  	addl	-0x44(%rbp), %r11d
    2630: 45 01 cb                     	addl	%r9d, %r11d
    2633: 45 01 da                     	addl	%r11d, %r10d
    2636: 41 81 c2 08 02 c7 8c         	addl	$0x8cc70208, %r10d      # imm = 0x8CC70208
    263d: 41 89 d1                     	movl	%edx, %r9d
    2640: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    2644: 44 01 d1                     	addl	%r10d, %ecx
    2647: 41 89 d3                     	movl	%edx, %r11d
    264a: 41 c1 c3 13                  	roll	$0x13, %r11d
    264e: 45 31 cb                     	xorl	%r9d, %r11d
    2651: 41 89 d6                     	movl	%edx, %r14d
    2654: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2658: 45 31 de                     	xorl	%r11d, %r14d
    265b: 41 89 f3                     	movl	%esi, %r11d
    265e: 41 09 c3                     	orl	%eax, %r11d
    2661: 41 21 d3                     	andl	%edx, %r11d
    2664: 41 89 f1                     	movl	%esi, %r9d
    2667: 41 21 c1                     	andl	%eax, %r9d
    266a: 45 09 d9                     	orl	%r11d, %r9d
    266d: 45 01 f1                     	addl	%r14d, %r9d
    2670: 45 01 d1                     	addl	%r10d, %r9d
    2673: 41 89 ca                     	movl	%ecx, %r10d
    2676: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    267a: 41 89 cb                     	movl	%ecx, %r11d
    267d: 41 c1 c3 15                  	roll	$0x15, %r11d
    2681: 45 31 d3                     	xorl	%r10d, %r11d
    2684: 41 89 ca                     	movl	%ecx, %r10d
    2687: 41 c1 c2 07                  	roll	$0x7, %r10d
    268b: 45 31 da                     	xorl	%r11d, %r10d
    268e: 41 89 db                     	movl	%ebx, %r11d
    2691: 45 31 c3                     	xorl	%r8d, %r11d
    2694: 41 21 cb                     	andl	%ecx, %r11d
    2697: 45 31 c3                     	xorl	%r8d, %r11d
    269a: 03 7d c0                     	addl	-0x40(%rbp), %edi
    269d: 44 01 df                     	addl	%r11d, %edi
    26a0: 41 01 fa                     	addl	%edi, %r10d
    26a3: 41 81 c2 fa ff be 90         	addl	$0x90befffa, %r10d      # imm = 0x90BEFFFA
    26aa: 44 89 cf                     	movl	%r9d, %edi
    26ad: c1 c7 1e                     	roll	$0x1e, %edi
    26b0: 45 89 cb                     	movl	%r9d, %r11d
    26b3: 41 c1 c3 13                  	roll	$0x13, %r11d
    26b7: 41 31 fb                     	xorl	%edi, %r11d
    26ba: 45 89 ce                     	movl	%r9d, %r14d
    26bd: 41 c1 c6 0a                  	roll	$0xa, %r14d
    26c1: 45 31 de                     	xorl	%r11d, %r14d
    26c4: 41 89 d3                     	movl	%edx, %r11d
    26c7: 41 09 f3                     	orl	%esi, %r11d
    26ca: 45 21 cb                     	andl	%r9d, %r11d
    26cd: 89 d7                        	movl	%edx, %edi
    26cf: 21 f7                        	andl	%esi, %edi
    26d1: 44 09 df                     	orl	%r11d, %edi
    26d4: 44 01 f7                     	addl	%r14d, %edi
    26d7: 41 89 cb                     	movl	%ecx, %r11d
    26da: 41 31 db                     	xorl	%ebx, %r11d
    26dd: 44 03 45 c4                  	addl	-0x3c(%rbp), %r8d
    26e1: 44 01 d0                     	addl	%r10d, %eax
    26e4: 41 21 c3                     	andl	%eax, %r11d
    26e7: 41 31 db                     	xorl	%ebx, %r11d
    26ea: 45 01 c3                     	addl	%r8d, %r11d
    26ed: 03 5d c8                     	addl	-0x38(%rbp), %ebx
    26f0: 41 89 c0                     	movl	%eax, %r8d
    26f3: 41 c1 c0 1a                  	roll	$0x1a, %r8d
    26f7: 41 89 c6                     	movl	%eax, %r14d
    26fa: 41 c1 c6 15                  	roll	$0x15, %r14d
    26fe: 45 31 c6                     	xorl	%r8d, %r14d
    2701: 41 89 c0                     	movl	%eax, %r8d
    2704: 41 c1 c0 07                  	roll	$0x7, %r8d
    2708: 45 31 f0                     	xorl	%r14d, %r8d
    270b: 45 01 d8                     	addl	%r11d, %r8d
    270e: 41 81 c0 eb 6c 50 a4         	addl	$0xa4506ceb, %r8d       # imm = 0xA4506CEB
    2715: 44 01 c6                     	addl	%r8d, %esi
    2718: 41 89 c3                     	movl	%eax, %r11d
    271b: 41 31 cb                     	xorl	%ecx, %r11d
    271e: 41 21 f3                     	andl	%esi, %r11d
    2721: 41 31 cb                     	xorl	%ecx, %r11d
    2724: 41 01 db                     	addl	%ebx, %r11d
    2727: 89 f3                        	movl	%esi, %ebx
    2729: 41 89 f6                     	movl	%esi, %r14d
    272c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    2730: c1 c3 15                     	roll	$0x15, %ebx
    2733: 44 31 f3                     	xorl	%r14d, %ebx
    2736: 41 89 f6                     	movl	%esi, %r14d
    2739: 66 0f 6e c6                  	movd	%esi, %xmm0
    273d: 41 89 f7                     	movl	%esi, %r15d
    2740: 41 c1 c6 07                  	roll	$0x7, %r14d
    2744: 41 31 de                     	xorl	%ebx, %r14d
    2747: 44 89 ce                     	movl	%r9d, %esi
    274a: 09 d6                        	orl	%edx, %esi
    274c: 45 01 f3                     	addl	%r14d, %r11d
    274f: 41 81 c3 f7 a3 f9 be         	addl	$0xbef9a3f7, %r11d      # imm = 0xBEF9A3F7
    2756: 44 89 cb                     	movl	%r9d, %ebx
    2759: 21 d3                        	andl	%edx, %ebx
    275b: 03 4d cc                     	addl	-0x34(%rbp), %ecx
    275e: 44 01 da                     	addl	%r11d, %edx
    2761: 41 31 c7                     	xorl	%eax, %r15d
    2764: 41 21 d7                     	andl	%edx, %r15d
    2767: 41 31 c7                     	xorl	%eax, %r15d
    276a: 41 01 cf                     	addl	%ecx, %r15d
    276d: 44 01 d7                     	addl	%r10d, %edi
    2770: 89 f9                        	movl	%edi, %ecx
    2772: c1 c1 1e                     	roll	$0x1e, %ecx
    2775: 41 89 fa                     	movl	%edi, %r10d
    2778: 41 c1 c2 13                  	roll	$0x13, %r10d
    277c: 41 31 ca                     	xorl	%ecx, %r10d
    277f: 89 f9                        	movl	%edi, %ecx
    2781: c1 c1 0a                     	roll	$0xa, %ecx
    2784: 44 31 d1                     	xorl	%r10d, %ecx
    2787: 21 fe                        	andl	%edi, %esi
    2789: 09 de                        	orl	%ebx, %esi
    278b: 01 ce                        	addl	%ecx, %esi
    278d: 89 d1                        	movl	%edx, %ecx
    278f: 41 89 d2                     	movl	%edx, %r10d
    2792: 66 0f 6e ca                  	movd	%edx, %xmm1
    2796: c1 c2 1a                     	roll	$0x1a, %edx
    2799: c1 c1 15                     	roll	$0x15, %ecx
    279c: 41 c1 c2 07                  	roll	$0x7, %r10d
    27a0: 31 d1                        	xorl	%edx, %ecx
    27a2: 41 31 ca                     	xorl	%ecx, %r10d
    27a5: 89 fa                        	movl	%edi, %edx
    27a7: 44 09 ca                     	orl	%r9d, %edx
    27aa: 44 01 c6                     	addl	%r8d, %esi
    27ad: 41 89 f0                     	movl	%esi, %r8d
    27b0: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    27b4: 43 8d 0c 3a                  	leal	(%r10,%r15), %ecx
    27b8: 81 c1 f2 78 71 c6            	addl	$0xc67178f2, %ecx       # imm = 0xC67178F2
    27be: 41 89 f2                     	movl	%esi, %r10d
    27c1: 41 c1 c2 13                  	roll	$0x13, %r10d
    27c5: 45 31 c2                     	xorl	%r8d, %r10d
    27c8: 41 89 f0                     	movl	%esi, %r8d
    27cb: 41 c1 c0 0a                  	roll	$0xa, %r8d
    27cf: 45 31 d0                     	xorl	%r10d, %r8d
    27d2: 21 f2                        	andl	%esi, %edx
    27d4: 41 89 f2                     	movl	%esi, %r10d
    27d7: 41 09 fa                     	orl	%edi, %r10d
    27da: 66 0f 6e d6                  	movd	%esi, %xmm2
    27de: 21 fe                        	andl	%edi, %esi
    27e0: 66 0f 6e df                  	movd	%edi, %xmm3
    27e4: 44 21 cf                     	andl	%r9d, %edi
    27e7: 09 fa                        	orl	%edi, %edx
    27e9: 44 01 c2                     	addl	%r8d, %edx
    27ec: 44 01 da                     	addl	%r11d, %edx
    27ef: 89 d7                        	movl	%edx, %edi
    27f1: 41 89 d0                     	movl	%edx, %r8d
    27f4: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    27f8: c1 c7 13                     	roll	$0x13, %edi
    27fb: 44 31 c7                     	xorl	%r8d, %edi
    27fe: 41 21 d2                     	andl	%edx, %r10d
    2801: 66 0f 6e e2                  	movd	%edx, %xmm4
    2805: c1 c2 0a                     	roll	$0xa, %edx
    2808: 31 fa                        	xorl	%edi, %edx
    280a: 44 09 d6                     	orl	%r10d, %esi
    280d: 01 d6                        	addl	%edx, %esi
    280f: 41 01 c9                     	addl	%ecx, %r9d
    2812: 01 ce                        	addl	%ecx, %esi
    2814: 66 0f 6e ee                  	movd	%esi, %xmm5
    2818: 66 41 0f 6e f1               	movd	%r9d, %xmm6
    281d: 66 0f 62 ec                  	punpckldq	%xmm4, %xmm5    # xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
    2821: 66 0f 62 d3                  	punpckldq	%xmm3, %xmm2    # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
    2825: 66 0f 6c ea                  	punpcklqdq	%xmm2, %xmm5    # xmm5 = xmm5[0],xmm2[0]
    2829: 66 41 0f fe 6d 00            	paddd	(%r13), %xmm5
    282f: 66 0f 6e d0                  	movd	%eax, %xmm2
    2833: 66 41 0f 7f 6d 00            	movdqa	%xmm5, (%r13)
    2839: 66 0f 62 f1                  	punpckldq	%xmm1, %xmm6    # xmm6 = xmm6[0],xmm1[0],xmm6[1],xmm1[1]
    283d: 66 0f 62 c2                  	punpckldq	%xmm2, %xmm0    # xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
    2841: 66 0f 6c f0                  	punpcklqdq	%xmm0, %xmm6    # xmm6 = xmm6[0],xmm0[0]
    2845: 66 41 0f fe 75 10            	paddd	0x10(%r13), %xmm6
    284b: 66 41 0f 7f 75 10            	movdqa	%xmm6, 0x10(%r13)
    2851: 48 81 c4 28 09 00 00         	addq	$0x928, %rsp            # imm = 0x928
    2858: 5b                           	popq	%rbx
    2859: 41 5c                        	popq	%r12
    285b: 41 5d                        	popq	%r13
    285d: 41 5e                        	popq	%r14
    285f: 41 5f                        	popq	%r15
    2861: 5d                           	popq	%rbp
    2862: c3                           	retq
    2863: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    286d: 0f 1f 00                     	nopl	(%rax)

0000000000002870 <audit_master256>:
    2870: 55                           	pushq	%rbp
    2871: 48 89 e5                     	movq	%rsp, %rbp
    2874: 41 56                        	pushq	%r14
    2876: 53                           	pushq	%rbx
    2877: 48 81 ec 50 01 00 00         	subq	$0x150, %rsp            # imm = 0x150
    287e: 48 89 f3                     	movq	%rsi, %rbx
    2881: 49 89 f8                     	movq	%rdi, %r8
    2884: 66 c7 85 a0 fe ff ff 00 20   	movw	$0x2000, -0x160(%rbp)   # imm = 0x2000
    288d: c6 85 a2 fe ff ff 0d         	movb	$0xd, -0x15e(%rbp)
    2894: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    289e: 48 89 85 a3 fe ff ff         	movq	%rax, -0x15d(%rbp)
    28a5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    28af: 48 89 85 a8 fe ff ff         	movq	%rax, -0x158(%rbp)
    28b6: c6 85 b0 fe ff ff 20         	movb	$0x20, -0x150(%rbp)
    28bd: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x54>
		00000000000028c0:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
    28c4: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    28cb: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x62>
		00000000000028ce:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
    28d2: 0f 11 85 c1 fe ff ff         	movups	%xmm0, -0x13f(%rbp)
    28d9: 4c 8d 75 b0                  	leaq	-0x50(%rbp), %r14
    28dd: 48 8d 95 a0 fe ff ff         	leaq	-0x160(%rbp), %rdx
    28e4: be 20 00 00 00               	movl	$0x20, %esi
    28e9: b9 31 00 00 00               	movl	$0x31, %ecx
    28ee: 4c 89 f7                     	movq	%r14, %rdi
    28f1: e8 aa da ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    28f6: 48 8d 7d d0                  	leaq	-0x30(%rbp), %rdi
    28fa: ba 00 00 00 00               	movl	$0x0, %edx
		00000000000028fb:  R_X86_64_32	.rodata.cst32
    28ff: 4c 89 f6                     	movq	%r14, %rsi
    2902: e8 b9 d7 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    2907: 0f 10 45 d0                  	movups	-0x30(%rbp), %xmm0
    290b: 0f 10 4d e0                  	movups	-0x20(%rbp), %xmm1
    290f: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    2913: 0f 11 03                     	movups	%xmm0, (%rbx)
    2916: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            # imm = 0x150
    291d: 5b                           	popq	%rbx
    291e: 41 5e                        	popq	%r14
    2920: 5d                           	popq	%rbp
    2921: c3                           	retq
    2922: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    292c: 0f 1f 40 00                  	nopl	(%rax)

0000000000002930 <audit_key256>:
    2930: 55                           	pushq	%rbp
    2931: 48 89 e5                     	movq	%rsp, %rbp
    2934: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            # imm = 0x110
    293b: 48 89 f0                     	movq	%rsi, %rax
    293e: 49 89 f8                     	movq	%rdi, %r8
    2941: 66 c7 85 f4 fe ff ff 00 10   	movw	$0x1000, -0x10c(%rbp)   # imm = 0x1000
    294a: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    2951: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
    295b: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    2962: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    296b: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    2972: be 10 00 00 00               	movl	$0x10, %esi
    2977: b9 0d 00 00 00               	movl	$0xd, %ecx
    297c: 48 89 c7                     	movq	%rax, %rdi
    297f: e8 1c da ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    2984: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            # imm = 0x110
    298b: 5d                           	popq	%rbp
    298c: c3                           	retq
    298d: 0f 1f 00                     	nopl	(%rax)

0000000000002990 <audit_handshake384>:
    2990: 55                           	pushq	%rbp
    2991: 48 89 e5                     	movq	%rsp, %rbp
    2994: 41 57                        	pushq	%r15
    2996: 41 56                        	pushq	%r14
    2998: 53                           	pushq	%rbx
    2999: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            # imm = 0x178
    29a0: 48 89 d3                     	movq	%rdx, %rbx
    29a3: 49 89 f6                     	movq	%rsi, %r14
    29a6: 49 89 f8                     	movq	%rdi, %r8
    29a9: 66 c7 85 a8 fe ff ff 00 30   	movw	$0x3000, -0x158(%rbp)   # imm = 0x3000
    29b2: c6 85 aa fe ff ff 0d         	movb	$0xd, -0x156(%rbp)
    29b9: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    29c3: 48 89 85 ab fe ff ff         	movq	%rax, -0x155(%rbp)
    29ca: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    29d4: 48 89 85 b0 fe ff ff         	movq	%rax, -0x150(%rbp)
    29db: c6 85 b8 fe ff ff 30         	movb	$0x30, -0x148(%rbp)
    29e2: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x59>
		00000000000029e5:  R_X86_64_PC32	.rodata+0x6c
    29e9: 0f 11 85 b9 fe ff ff         	movups	%xmm0, -0x147(%rbp)
    29f0: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x67>
		00000000000029f3:  R_X86_64_PC32	.rodata+0x7c
    29f7: 0f 11 85 c9 fe ff ff         	movups	%xmm0, -0x137(%rbp)
    29fe: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x75>
		0000000000002a01:  R_X86_64_PC32	.rodata+0x8c
    2a05: 0f 11 85 d9 fe ff ff         	movups	%xmm0, -0x127(%rbp)
    2a0c: 4c 8d bd 78 fe ff ff         	leaq	-0x188(%rbp), %r15
    2a13: 48 8d 95 a8 fe ff ff         	leaq	-0x158(%rbp), %rdx
    2a1a: be 30 00 00 00               	movl	$0x30, %esi
    2a1f: b9 41 00 00 00               	movl	$0x41, %ecx
    2a24: 4c 89 ff                     	movq	%r15, %rdi
    2a27: e8 34 03 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    2a2c: 48 8d 7d b8                  	leaq	-0x48(%rbp), %rdi
    2a30: 4c 89 fe                     	movq	%r15, %rsi
    2a33: 4c 89 f2                     	movq	%r14, %rdx
    2a36: e8 25 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    2a3b: 0f 10 45 b8                  	movups	-0x48(%rbp), %xmm0
    2a3f: 0f 10 4d c8                  	movups	-0x38(%rbp), %xmm1
    2a43: 0f 10 55 d8                  	movups	-0x28(%rbp), %xmm2
    2a47: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    2a4b: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    2a4f: 0f 11 03                     	movups	%xmm0, (%rbx)
    2a52: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            # imm = 0x178
    2a59: 5b                           	popq	%rbx
    2a5a: 41 5e                        	popq	%r14
    2a5c: 41 5f                        	popq	%r15
    2a5e: 5d                           	popq	%rbp
    2a5f: c3                           	retq

0000000000002a60 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2a60: 55                           	pushq	%rbp
    2a61: 48 89 e5                     	movq	%rsp, %rbp
    2a64: 41 57                        	pushq	%r15
    2a66: 41 56                        	pushq	%r14
    2a68: 41 55                        	pushq	%r13
    2a6a: 41 54                        	pushq	%r12
    2a6c: 53                           	pushq	%rbx
    2a6d: 48 81 ec a8 02 00 00         	subq	$0x2a8, %rsp            # imm = 0x2A8
    2a74: 49 89 d6                     	movq	%rdx, %r14
    2a77: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    2a7b: 0f 10 06                     	movups	(%rsi), %xmm0
    2a7e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    2a82: 0f 10 56 20                  	movups	0x20(%rsi), %xmm2
    2a86: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x2d>
		0000000000002a89:  R_X86_64_PC32	.LCPI8_0-0x4
    2a8d: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2a90: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2a93: 0f 28 e9                     	movaps	%xmm1, %xmm5
    2a96: 0f 57 eb                     	xorps	%xmm3, %xmm5
    2a99: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2aa0: 0f 29 ad 50 fe ff ff         	movaps	%xmm5, -0x1b0(%rbp)
    2aa7: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2aaa: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2aad: 0f 29 a5 60 fe ff ff         	movaps	%xmm4, -0x1a0(%rbp)
    2ab4: 0f 29 9d 70 fe ff ff         	movaps	%xmm3, -0x190(%rbp)
    2abb: 0f 29 9d 80 fe ff ff         	movaps	%xmm3, -0x180(%rbp)
    2ac2: 0f 29 9d 90 fe ff ff         	movaps	%xmm3, -0x170(%rbp)
    2ac9: 0f 29 9d a0 fe ff ff         	movaps	%xmm3, -0x160(%rbp)
    2ad0: 0f 29 9d b0 fe ff ff         	movaps	%xmm3, -0x150(%rbp)
    2ad7: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x7e>
		0000000000002ada:  R_X86_64_PC32	.LCPI8_1-0x4
    2ade: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2ae1: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2ae4: 0f 29 85 f0 fe ff ff         	movaps	%xmm0, -0x110(%rbp)
    2aeb: 0f 29 8d 00 ff ff ff         	movaps	%xmm1, -0x100(%rbp)
    2af2: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2af5: 0f 29 95 10 ff ff ff         	movaps	%xmm2, -0xf0(%rbp)
    2afc: 0f 29 9d 20 ff ff ff         	movaps	%xmm3, -0xe0(%rbp)
    2b03: 0f 29 9d 30 ff ff ff         	movaps	%xmm3, -0xd0(%rbp)
    2b0a: 0f 29 9d 40 ff ff ff         	movaps	%xmm3, -0xc0(%rbp)
    2b11: 0f 29 9d 50 ff ff ff         	movaps	%xmm3, -0xb0(%rbp)
    2b18: 0f 29 9d 60 ff ff ff         	movaps	%xmm3, -0xa0(%rbp)
    2b1f: 4c 8d a5 60 fd ff ff         	leaq	-0x2a0(%rbp), %r12
    2b26: be 00 00 00 00               	movl	$0x0, %esi
		0000000000002b27:  R_X86_64_32	.rodata+0xb0
    2b2b: ba e0 00 00 00               	movl	$0xe0, %edx
    2b30: 4c 89 e7                     	movq	%r12, %rdi
    2b33: e8 00 00 00 00               	callq	 <L0>
		0000000000002b34:  R_X86_64_PLT32	memcpy-0x4
<L0>:
    2b38: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
    2b3f: 4c 89 e7                     	movq	%r12, %rdi
    2b42: e8 a9 0d 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2b47: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2b4e: bb 80 00 00 00               	movl	$0x80, %ebx
    2b53: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2b5a: 49 01 df                     	addq	%rbx, %r15
    2b5d: 49 83 d4 00                  	adcq	$0x0, %r12
    2b61: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2b68: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2b6f: 0f b6 85 30 fe ff ff         	movzbl	-0x1d0(%rbp), %eax
    2b76: 48 85 c0                     	testq	%rax, %rax
    2b79: 74 52                        	je	 <L2>
    2b7b: 3c 50                        	cmpb	$0x50, %al
    2b7d: 72 50                        	jb	 <L3>
    2b7f: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    2b85: 49 29 c5                     	subq	%rax, %r13
    2b88: 4c 8d a5 b0 fd ff ff         	leaq	-0x250(%rbp), %r12
    2b8f: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    2b93: 48 81 c7 b0 fd ff ff         	addq	$-0x250, %rdi           # imm = 0xFDB0
    2b9a: 4c 89 f6                     	movq	%r14, %rsi
    2b9d: 4c 89 ea                     	movq	%r13, %rdx
    2ba0: e8 00 00 00 00               	callq	 <L1>
		0000000000002ba1:  R_X86_64_PLT32	memcpy-0x4
<L1>:
    2ba5: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2bac: 4c 89 e6                     	movq	%r12, %rsi
    2baf: e8 3c 0d 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2bb4: c6 85 30 fe ff ff 00         	movb	$0x0, -0x1d0(%rbp)
    2bbb: 31 c0                        	xorl	%eax, %eax
    2bbd: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2bc4: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2bcb: eb 05                        	jmp	 <L4>
<L2>:
    2bcd: 31 c0                        	xorl	%eax, %eax
<L3>:
    2bcf: 45 31 ed                     	xorl	%r13d, %r13d
<L4>:
    2bd2: 4d 01 ee                     	addq	%r13, %r14
    2bd5: 4c 89 f6                     	movq	%r14, %rsi
    2bd8: 41 be 30 00 00 00            	movl	$0x30, %r14d
    2bde: 4d 29 ee                     	subq	%r13, %r14
    2be1: 0f b6 c0                     	movzbl	%al, %eax
    2be4: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    2be8: 48 81 c7 b0 fd ff ff         	addq	$-0x250, %rdi           # imm = 0xFDB0
    2bef: 4c 89 f2                     	movq	%r14, %rdx
    2bf2: e8 00 00 00 00               	callq	 <L5>
		0000000000002bf3:  R_X86_64_PLT32	memcpy-0x4
<L5>:
    2bf7: 44 00 b5 30 fe ff ff         	addb	%r14b, -0x1d0(%rbp)
    2bfe: 49 83 c7 30                  	addq	$0x30, %r15
    2c02: 49 83 d4 00                  	adcq	$0x0, %r12
    2c06: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2c0d: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2c14: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2c1b: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2c22: e8 a9 0a 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2c27: 4c 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %r14
    2c2e: be 00 00 00 00               	movl	$0x0, %esi
		0000000000002c2f:  R_X86_64_32	.rodata+0xb0
    2c33: ba e0 00 00 00               	movl	$0xe0, %edx
    2c38: 4c 89 f7                     	movq	%r14, %rdi
    2c3b: e8 00 00 00 00               	callq	 <L6>
		0000000000002c3c:  R_X86_64_PLT32	memcpy-0x4
<L6>:
    2c40: 4c 89 f7                     	movq	%r14, %rdi
    2c43: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    2c4a: e8 a1 0c 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2c4f: 0f b6 7d c0                  	movzbl	-0x40(%rbp), %edi
    2c53: 4c 8b a5 f8 fe ff ff         	movq	-0x108(%rbp), %r12
    2c5a: 48 03 9d f0 fe ff ff         	addq	-0x110(%rbp), %rbx
    2c61: 49 83 d4 00                  	adcq	$0x0, %r12
    2c65: 4c 8d b5 40 ff ff ff         	leaq	-0xc0(%rbp), %r14
    2c6c: 48 89 9d f0 fe ff ff         	movq	%rbx, -0x110(%rbp)
    2c73: 4c 89 a5 f8 fe ff ff         	movq	%r12, -0x108(%rbp)
    2c7a: 48 85 ff                     	testq	%rdi, %rdi
    2c7d: 74 46                        	je	 <L8>
    2c7f: 40 80 ff 50                  	cmpb	$0x50, %dil
    2c83: 72 42                        	jb	 <L9>
    2c85: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    2c8b: 49 29 ff                     	subq	%rdi, %r15
    2c8e: 4c 01 f7                     	addq	%r14, %rdi
    2c91: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2c98: 4c 89 fa                     	movq	%r15, %rdx
    2c9b: e8 00 00 00 00               	callq	 <L7>
		0000000000002c9c:  R_X86_64_PLT32	memcpy-0x4
<L7>:
    2ca0: 48 8d bd f0 fe ff ff         	leaq	-0x110(%rbp), %rdi
    2ca7: 4c 89 f6                     	movq	%r14, %rsi
    2caa: e8 41 0c 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2caf: c6 45 c0 00                  	movb	$0x0, -0x40(%rbp)
    2cb3: 31 ff                        	xorl	%edi, %edi
    2cb5: 48 8b 9d f0 fe ff ff         	movq	-0x110(%rbp), %rbx
    2cbc: 4c 8b a5 f8 fe ff ff         	movq	-0x108(%rbp), %r12
    2cc3: eb 05                        	jmp	 <L10>
<L8>:
    2cc5: 31 ff                        	xorl	%edi, %edi
<L9>:
    2cc7: 45 31 ff                     	xorl	%r15d, %r15d
<L10>:
    2cca: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    2cce: 48 81 c6 30 fd ff ff         	addq	$-0x2d0, %rsi           # imm = 0xFD30
    2cd5: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    2cdb: 4d 29 fd                     	subq	%r15, %r13
    2cde: 40 0f b6 c7                  	movzbl	%dil, %eax
    2ce2: 49 01 c6                     	addq	%rax, %r14
    2ce5: 4c 89 f7                     	movq	%r14, %rdi
    2ce8: 4c 89 ea                     	movq	%r13, %rdx
    2ceb: e8 00 00 00 00               	callq	 <L11>
		0000000000002cec:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    2cf0: 44 00 6d c0                  	addb	%r13b, -0x40(%rbp)
    2cf4: 48 83 c3 30                  	addq	$0x30, %rbx
    2cf8: 49 83 d4 00                  	adcq	$0x0, %r12
    2cfc: 4c 89 a5 f8 fe ff ff         	movq	%r12, -0x108(%rbp)
    2d03: 48 89 9d f0 fe ff ff         	movq	%rbx, -0x110(%rbp)
    2d0a: 48 8d bd f0 fe ff ff         	leaq	-0x110(%rbp), %rdi
    2d11: 48 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %rsi
    2d18: e8 b3 09 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    2d1d: 0f 10 85 c0 fe ff ff         	movups	-0x140(%rbp), %xmm0
    2d24: 0f 10 8d d0 fe ff ff         	movups	-0x130(%rbp), %xmm1
    2d2b: 0f 10 95 e0 fe ff ff         	movups	-0x120(%rbp), %xmm2
    2d32: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    2d36: 0f 11 50 20                  	movups	%xmm2, 0x20(%rax)
    2d3a: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
    2d3e: 0f 11 00                     	movups	%xmm0, (%rax)
    2d41: 48 81 c4 a8 02 00 00         	addq	$0x2a8, %rsp            # imm = 0x2A8
    2d48: 5b                           	popq	%rbx
    2d49: 41 5c                        	popq	%r12
    2d4b: 41 5d                        	popq	%r13
    2d4d: 41 5e                        	popq	%r14
    2d4f: 41 5f                        	popq	%r15
    2d51: 5d                           	popq	%rbp
    2d52: c3                           	retq
    2d53: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2d5d: 0f 1f 00                     	nopl	(%rax)

0000000000002d60 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
    2d60: 55                           	pushq	%rbp
    2d61: 48 89 e5                     	movq	%rsp, %rbp
    2d64: 41 57                        	pushq	%r15
    2d66: 41 56                        	pushq	%r14
    2d68: 41 55                        	pushq	%r13
    2d6a: 41 54                        	pushq	%r12
    2d6c: 53                           	pushq	%rbx
    2d6d: 48 81 ec a8 05 00 00         	subq	$0x5a8, %rsp            # imm = 0x5A8
    2d74: 48 89 55 c0                  	movq	%rdx, -0x40(%rbp)
    2d78: 49 89 f7                     	movq	%rsi, %r15
    2d7b: 48 89 7d c8                  	movq	%rdi, -0x38(%rbp)
    2d7f: 41 0f 10 08                  	movups	(%r8), %xmm1
    2d83: 41 0f 10 50 10               	movups	0x10(%r8), %xmm2
    2d88: 41 0f 10 40 20               	movups	0x20(%r8), %xmm0
    2d8d: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    2d91: 48 83 fe 30                  	cmpq	$0x30, %rsi
    2d95: 48 89 4d b0                  	movq	%rcx, -0x50(%rbp)
    2d99: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    2da0: 0f 29 8d 10 fe ff ff         	movaps	%xmm1, -0x1f0(%rbp)
    2da7: 0f 29 95 20 fe ff ff         	movaps	%xmm2, -0x1e0(%rbp)
    2dae: 0f 83 7c 01 00 00            	jae	 <L4>
    2db4: 48 c7 45 b8 00 00 00 00      	movq	$0x0, -0x48(%rbp)
<L0>:
    2dbc: 4c 89 f8                     	movq	%r15, %rax
    2dbf: 48 83 e8 30                  	subq	$0x30, %rax
    2dc3: 49 0f 42 c7                  	cmovbq	%r15, %rax
    2dc7: 48 85 c0                     	testq	%rax, %rax
    2dca: 0f 84 ec 08 00 00            	je	 <L52>
    2dd0: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    2dd4: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x7b>
		0000000000002dd7:  R_X86_64_PC32	.LCPI9_0-0x4
    2ddb: 0f 28 9d 10 fe ff ff         	movaps	-0x1f0(%rbp), %xmm3
    2de2: 0f 28 cb                     	movaps	%xmm3, %xmm1
    2de5: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2de8: 0f 28 a5 20 fe ff ff         	movaps	-0x1e0(%rbp), %xmm4
    2def: 0f 28 d4                     	movaps	%xmm4, %xmm2
    2df2: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2df5: 0f 29 8d 20 fd ff ff         	movaps	%xmm1, -0x2e0(%rbp)
    2dfc: 0f 29 95 30 fd ff ff         	movaps	%xmm2, -0x2d0(%rbp)
    2e03: 0f 28 95 00 fe ff ff         	movaps	-0x200(%rbp), %xmm2
    2e0a: 0f 28 ca                     	movaps	%xmm2, %xmm1
    2e0d: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2e10: 0f 29 8d 40 fd ff ff         	movaps	%xmm1, -0x2c0(%rbp)
    2e17: 0f 29 85 50 fd ff ff         	movaps	%xmm0, -0x2b0(%rbp)
    2e1e: 0f 29 85 60 fd ff ff         	movaps	%xmm0, -0x2a0(%rbp)
    2e25: 0f 29 85 70 fd ff ff         	movaps	%xmm0, -0x290(%rbp)
    2e2c: 0f 29 85 80 fd ff ff         	movaps	%xmm0, -0x280(%rbp)
    2e33: 0f 29 85 90 fd ff ff         	movaps	%xmm0, -0x270(%rbp)
    2e3a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0xe1>
		0000000000002e3d:  R_X86_64_PC32	.LCPI9_1-0x4
    2e41: 0f 57 d8                     	xorps	%xmm0, %xmm3
    2e44: 0f 57 e0                     	xorps	%xmm0, %xmm4
    2e47: 0f 29 9d 30 fe ff ff         	movaps	%xmm3, -0x1d0(%rbp)
    2e4e: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2e55: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2e58: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
    2e5f: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    2e66: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    2e6d: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    2e74: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    2e7b: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    2e82: 48 8d 9d 40 fc ff ff         	leaq	-0x3c0(%rbp), %rbx
    2e89: be 00 00 00 00               	movl	$0x0, %esi
		0000000000002e8a:  R_X86_64_32	.rodata+0xb0
    2e8e: ba e0 00 00 00               	movl	$0xe0, %edx
    2e93: 48 89 df                     	movq	%rbx, %rdi
    2e96: e8 00 00 00 00               	callq	 <L1>
		0000000000002e97:  R_X86_64_PLT32	memcpy-0x4
<L1>:
    2e9b: 48 8d b5 30 fe ff ff         	leaq	-0x1d0(%rbp), %rsi
    2ea2: 48 89 df                     	movq	%rbx, %rdi
    2ea5: e8 46 0a 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2eaa: 48 81 85 40 fc ff ff 80 00 00 00     	addq	$0x80, -0x3c0(%rbp)
    2eb5: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    2ebd: 0f b6 85 10 fd ff ff         	movzbl	-0x2f0(%rbp), %eax
    2ec4: 49 83 ff 2f                  	cmpq	$0x2f, %r15
    2ec8: 0f 87 25 05 00 00            	ja	 <L30>
    2ece: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
    2ed2: 84 c0                        	testb	%al, %al
    2ed4: 0f 84 bc 05 00 00            	je	 <L36>
<L2>:
    2eda: 0f b6 c8                     	movzbl	%al, %ecx
    2edd: 49 8d 14 0f                  	leaq	(%r15,%rcx), %rdx
    2ee1: 48 81 fa 80 00 00 00         	cmpq	$0x80, %rdx
    2ee8: 0f 82 aa 05 00 00            	jb	 <L37>
    2eee: b2 80                        	movb	$-0x80, %dl
    2ef0: 28 c2                        	subb	%al, %dl
    2ef2: 0f b6 da                     	movzbl	%dl, %ebx
    2ef5: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    2efc: 48 8d 3c 29                  	leaq	(%rcx,%rbp), %rdi
    2f00: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    2f07: 48 8b 75 c0                  	movq	-0x40(%rbp), %rsi
    2f0b: 48 89 da                     	movq	%rbx, %rdx
    2f0e: e8 00 00 00 00               	callq	 <L3>
		0000000000002f0f:  R_X86_64_PLT32	memcpy-0x4
<L3>:
    2f13: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    2f1a: 4c 89 f6                     	movq	%r14, %rsi
    2f1d: e8 ce 09 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    2f22: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    2f29: 31 c0                        	xorl	%eax, %eax
    2f2b: e9 6a 05 00 00               	jmp	 <L38>
<L4>:
    2f30: 48 83 f1 7f                  	xorq	$0x7f, %rcx
    2f34: 48 89 4d a0                  	movq	%rcx, -0x60(%rbp)
    2f38: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x1df>
		0000000000002f3b:  R_X86_64_PC32	.LCPI9_0-0x4
    2f3f: 0f 28 e1                     	movaps	%xmm1, %xmm4
    2f42: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f45: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
    2f4c: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2f4f: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f52: 0f 29 a5 b0 fd ff ff         	movaps	%xmm4, -0x250(%rbp)
    2f59: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2f5c: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f5f: 0f 29 a5 c0 fd ff ff         	movaps	%xmm4, -0x240(%rbp)
    2f66: 0f 28 1d 00 00 00 00         	movaps	, %xmm3 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x20d>
		0000000000002f69:  R_X86_64_PC32	.LCPI9_1-0x4
    2f6d: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2f70: 0f 29 8d d0 fd ff ff         	movaps	%xmm1, -0x230(%rbp)
    2f77: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2f7a: 0f 29 95 e0 fd ff ff         	movaps	%xmm2, -0x220(%rbp)
    2f81: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2f84: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    2f8b: 41 b6 01                     	movb	$0x1, %r14b
    2f8e: b0 02                        	movb	$0x2, %al
    2f90: 31 c9                        	xorl	%ecx, %ecx
    2f92: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    2f99: 4c 89 7d 98                  	movq	%r15, -0x68(%rbp)
    2f9d: e9 9d 00 00 00               	jmp	 <L9>
    2fa2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2fac: 0f 1f 40 00                  	nopl	(%rax)
<L5>:
    2fb0: 31 ff                        	xorl	%edi, %edi
<L6>:
    2fb2: 45 31 f6                     	xorl	%r14d, %r14d
<L7>:
    2fb5: 4c 8b 7d b8                  	movq	-0x48(%rbp), %r15
    2fb9: 4c 03 7d c8                  	addq	-0x38(%rbp), %r15
    2fbd: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    2fc1: 48 81 c6 c0 fb ff ff         	addq	$-0x440, %rsi           # imm = 0xFBC0
    2fc8: b8 30 00 00 00               	movl	$0x30, %eax
    2fcd: 48 89 45 b8                  	movq	%rax, -0x48(%rbp)
    2fd1: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    2fd7: 4d 29 f4                     	subq	%r14, %r12
    2fda: 40 0f b6 ff                  	movzbl	%dil, %edi
    2fde: 48 8d 85 80 fe ff ff         	leaq	-0x180(%rbp), %rax
    2fe5: 48 01 c7                     	addq	%rax, %rdi
    2fe8: 4c 89 e2                     	movq	%r12, %rdx
    2feb: e8 00 00 00 00               	callq	 <L8>
		0000000000002fec:  R_X86_64_PLT32	memcpy-0x4
<L8>:
    2ff0: 44 00 a5 00 ff ff ff         	addb	%r12b, -0x100(%rbp)
    2ff7: 48 83 c3 30                  	addq	$0x30, %rbx
    2ffb: 49 83 d5 00                  	adcq	$0x0, %r13
    2fff: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    3006: 48 89 9d 30 fe ff ff         	movq	%rbx, -0x1d0(%rbp)
    300d: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    3014: 48 89 df                     	movq	%rbx, %rdi
    3017: 4c 89 fe                     	movq	%r15, %rsi
    301a: e8 b1 06 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    301f: 48 8b 45 a8                  	movq	-0x58(%rbp), %rax
    3023: 88 45 d7                     	movb	%al, -0x29(%rbp)
    3026: 83 c0 01                     	addl	$0x1, %eax
    3029: 45 31 f6                     	xorl	%r14d, %r14d
    302c: b9 30 00 00 00               	movl	$0x30, %ecx
    3031: 4c 8b 7d 98                  	movq	-0x68(%rbp), %r15
    3035: 49 83 ff 60                  	cmpq	$0x60, %r15
    3039: 0f 82 7d fd ff ff            	jb	 <L0>
<L9>:
    303f: 48 89 4d b8                  	movq	%rcx, -0x48(%rbp)
    3043: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    3047: 0f 28 85 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm0
    304e: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
    3055: 0f 28 85 b0 fd ff ff         	movaps	-0x250(%rbp), %xmm0
    305c: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3063: 0f 28 85 c0 fd ff ff         	movaps	-0x240(%rbp), %xmm0
    306a: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3071: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x318>
		0000000000003074:  R_X86_64_PC32	.LCPI9_0-0x4
    3078: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    307f: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3086: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    308d: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3094: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3098: 0f 28 85 d0 fd ff ff         	movaps	-0x230(%rbp), %xmm0
    309f: 0f 29 85 c0 fb ff ff         	movaps	%xmm0, -0x440(%rbp)
    30a6: 0f 28 85 e0 fd ff ff         	movaps	-0x220(%rbp), %xmm0
    30ad: 0f 29 85 d0 fb ff ff         	movaps	%xmm0, -0x430(%rbp)
    30b4: 0f 28 85 f0 fd ff ff         	movaps	-0x210(%rbp), %xmm0
    30bb: 0f 29 85 e0 fb ff ff         	movaps	%xmm0, -0x420(%rbp)
    30c2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x369>
		00000000000030c5:  R_X86_64_PC32	.LCPI9_1-0x4
    30c9: 0f 29 85 f0 fb ff ff         	movaps	%xmm0, -0x410(%rbp)
    30d0: 0f 29 85 00 fc ff ff         	movaps	%xmm0, -0x400(%rbp)
    30d7: 0f 29 85 10 fc ff ff         	movaps	%xmm0, -0x3f0(%rbp)
    30de: 0f 29 85 20 fc ff ff         	movaps	%xmm0, -0x3e0(%rbp)
    30e5: 0f 29 85 30 fc ff ff         	movaps	%xmm0, -0x3d0(%rbp)
    30ec: be 00 00 00 00               	movl	$0x0, %esi
		00000000000030ed:  R_X86_64_32	.rodata+0xb0
    30f1: ba e0 00 00 00               	movl	$0xe0, %edx
    30f6: 48 89 df                     	movq	%rbx, %rdi
    30f9: e8 00 00 00 00               	callq	 <L10>
		00000000000030fa:  R_X86_64_PLT32	memcpy-0x4
<L10>:
    30fe: 48 89 df                     	movq	%rbx, %rdi
    3101: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    3108: e8 e3 07 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    310d: 48 81 85 30 fe ff ff 80 00 00 00     	addq	$0x80, -0x1d0(%rbp)
    3118: 48 83 95 38 fe ff ff 00      	adcq	$0x0, -0x1c8(%rbp)
    3120: ba 60 01 00 00               	movl	$0x160, %edx            # imm = 0x160
    3125: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    312c: 48 89 de                     	movq	%rbx, %rsi
    312f: e8 00 00 00 00               	callq	 <L11>
		0000000000003130:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    3134: 0f b6 85 30 fb ff ff         	movzbl	-0x4d0(%rbp), %eax
    313b: 41 f6 c6 01                  	testb	$0x1, %r14b
    313f: 0f 85 90 00 00 00            	jne	 <L17>
    3145: 84 c0                        	testb	%al, %al
    3147: 74 40                        	je	 <L13>
    3149: 3c 50                        	cmpb	$0x50, %al
    314b: 72 3e                        	jb	 <L14>
    314d: 0f b6 f8                     	movzbl	%al, %edi
    3150: 41 be 80 00 00 00            	movl	$0x80, %r14d
    3156: 49 29 fe                     	subq	%rdi, %r14
    3159: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    3160: 48 01 df                     	addq	%rbx, %rdi
    3163: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    3167: 4c 89 f2                     	movq	%r14, %rdx
    316a: e8 00 00 00 00               	callq	 <L12>
		000000000000316b:  R_X86_64_PLT32	memcpy-0x4
<L12>:
    316f: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3176: 48 89 de                     	movq	%rbx, %rsi
    3179: e8 72 07 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    317e: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3185: 31 c0                        	xorl	%eax, %eax
    3187: eb 05                        	jmp	 <L15>
<L13>:
    3189: 31 c0                        	xorl	%eax, %eax
<L14>:
    318b: 45 31 f6                     	xorl	%r14d, %r14d
<L15>:
    318e: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    3192: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    3196: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    319c: 4d 29 f4                     	subq	%r14, %r12
    319f: 0f b6 f8                     	movzbl	%al, %edi
    31a2: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    31a9: 48 01 c7                     	addq	%rax, %rdi
    31ac: 4c 89 e2                     	movq	%r12, %rdx
    31af: e8 00 00 00 00               	callq	 <L16>
		00000000000031b0:  R_X86_64_PLT32	memcpy-0x4
<L16>:
    31b4: 44 02 a5 30 fb ff ff         	addb	-0x4d0(%rbp), %r12b
    31bb: 44 88 a5 30 fb ff ff         	movb	%r12b, -0x4d0(%rbp)
    31c2: 48 83 85 60 fa ff ff 30      	addq	$0x30, -0x5a0(%rbp)
    31ca: 48 83 95 68 fa ff ff 00      	adcq	$0x0, -0x598(%rbp)
    31d2: 44 89 e0                     	movl	%r12d, %eax
<L17>:
    31d5: 84 c0                        	testb	%al, %al
    31d7: 74 47                        	je	 <L19>
    31d9: 0f b6 f8                     	movzbl	%al, %edi
    31dc: 48 39 7d a0                  	cmpq	%rdi, -0x60(%rbp)
    31e0: 73 40                        	jae	 <L20>
    31e2: b1 80                        	movb	$-0x80, %cl
    31e4: 28 c1                        	subb	%al, %cl
    31e6: 44 0f b6 f1                  	movzbl	%cl, %r14d
    31ea: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    31f1: 48 01 df                     	addq	%rbx, %rdi
    31f4: 48 8b 75 c0                  	movq	-0x40(%rbp), %rsi
    31f8: 4c 89 f2                     	movq	%r14, %rdx
    31fb: e8 00 00 00 00               	callq	 <L18>
		00000000000031fc:  R_X86_64_PLT32	memcpy-0x4
<L18>:
    3200: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3207: 48 89 de                     	movq	%rbx, %rsi
    320a: e8 e1 06 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    320f: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3216: 31 c0                        	xorl	%eax, %eax
    3218: eb 0b                        	jmp	 <L21>
    321a: 66 0f 1f 44 00 00            	nopw	(%rax,%rax)
<L19>:
    3220: 31 c0                        	xorl	%eax, %eax
<L20>:
    3222: 45 31 f6                     	xorl	%r14d, %r14d
<L21>:
    3225: 48 8b 4d c0                  	movq	-0x40(%rbp), %rcx
    3229: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    322d: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
    3231: 4d 89 fc                     	movq	%r15, %r12
    3234: 4d 29 f4                     	subq	%r14, %r12
    3237: 0f b6 f8                     	movzbl	%al, %edi
    323a: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3241: 48 01 c7                     	addq	%rax, %rdi
    3244: 4c 89 e2                     	movq	%r12, %rdx
    3247: e8 00 00 00 00               	callq	 <L22>
		0000000000003248:  R_X86_64_PLT32	memcpy-0x4
<L22>:
    324c: 0f b6 bd 30 fb ff ff         	movzbl	-0x4d0(%rbp), %edi
    3253: 4c 01 e7                     	addq	%r12, %rdi
    3256: 40 88 bd 30 fb ff ff         	movb	%dil, -0x4d0(%rbp)
    325d: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    3264: 48 8b 9d 60 fa ff ff         	movq	-0x5a0(%rbp), %rbx
    326b: 4c 01 fb                     	addq	%r15, %rbx
    326e: 49 83 d5 00                  	adcq	$0x0, %r13
    3272: 48 89 9d 60 fa ff ff         	movq	%rbx, -0x5a0(%rbp)
    3279: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    3280: 40 84 ff                     	testb	%dil, %dil
    3283: 74 5b                        	je	 <L24>
    3285: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    3289: 72 57                        	jb	 <L25>
    328b: b0 80                        	movb	$-0x80, %al
    328d: 40 28 f8                     	subb	%dil, %al
    3290: 44 0f b6 f0                  	movzbl	%al, %r14d
    3294: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    329b: 48 01 df                     	addq	%rbx, %rdi
    329e: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    32a2: 4c 89 f2                     	movq	%r14, %rdx
    32a5: e8 00 00 00 00               	callq	 <L23>
		00000000000032a6:  R_X86_64_PLT32	memcpy-0x4
<L23>:
    32aa: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    32b1: 48 89 de                     	movq	%rbx, %rsi
    32b4: e8 37 06 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    32b9: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    32c0: 31 ff                        	xorl	%edi, %edi
    32c2: 48 8b 9d 60 fa ff ff         	movq	-0x5a0(%rbp), %rbx
    32c9: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    32d0: eb 13                        	jmp	 <L26>
    32d2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    32dc: 0f 1f 40 00                  	nopl	(%rax)
<L24>:
    32e0: 31 ff                        	xorl	%edi, %edi
<L25>:
    32e2: 45 31 f6                     	xorl	%r14d, %r14d
<L26>:
    32e5: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    32e9: 48 83 c6 d7                  	addq	$-0x29, %rsi
    32ed: 41 bc 01 00 00 00            	movl	$0x1, %r12d
    32f3: 4d 29 f4                     	subq	%r14, %r12
    32f6: 40 0f b6 ff                  	movzbl	%dil, %edi
    32fa: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3301: 48 01 c7                     	addq	%rax, %rdi
    3304: 4c 89 e2                     	movq	%r12, %rdx
    3307: e8 00 00 00 00               	callq	 <L27>
		0000000000003308:  R_X86_64_PLT32	memcpy-0x4
<L27>:
    330c: 44 00 a5 30 fb ff ff         	addb	%r12b, -0x4d0(%rbp)
    3313: 48 83 c3 01                  	addq	$0x1, %rbx
    3317: 49 83 d5 00                  	adcq	$0x0, %r13
    331b: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    3322: 48 89 9d 60 fa ff ff         	movq	%rbx, -0x5a0(%rbp)
    3329: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3330: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    3337: e8 94 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    333c: be 00 00 00 00               	movl	$0x0, %esi
		000000000000333d:  R_X86_64_32	.rodata+0xb0
    3341: ba e0 00 00 00               	movl	$0xe0, %edx
    3346: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    334d: 48 89 df                     	movq	%rbx, %rdi
    3350: e8 00 00 00 00               	callq	 <L28>
		0000000000003351:  R_X86_64_PLT32	memcpy-0x4
<L28>:
    3355: 48 89 df                     	movq	%rbx, %rdi
    3358: 48 8d b5 40 fb ff ff         	leaq	-0x4c0(%rbp), %rsi
    335f: e8 8c 05 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3364: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    336b: 48 8b 9d 30 fe ff ff         	movq	-0x1d0(%rbp), %rbx
    3372: b8 80 00 00 00               	movl	$0x80, %eax
    3377: 48 01 c3                     	addq	%rax, %rbx
    337a: 49 83 d5 00                  	adcq	$0x0, %r13
    337e: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    3385: 48 89 9d 30 fe ff ff         	movq	%rbx, -0x1d0(%rbp)
    338c: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    3393: 48 85 ff                     	testq	%rdi, %rdi
    3396: 0f 84 14 fc ff ff            	je	 <L5>
    339c: 40 80 ff 50                  	cmpb	$0x50, %dil
    33a0: 0f 82 0c fc ff ff            	jb	 <L6>
    33a6: 41 be 80 00 00 00            	movl	$0x80, %r14d
    33ac: 49 29 fe                     	subq	%rdi, %r14
    33af: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    33b6: 48 01 df                     	addq	%rbx, %rdi
    33b9: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    33c0: 4c 89 f2                     	movq	%r14, %rdx
    33c3: e8 00 00 00 00               	callq	 <L29>
		00000000000033c4:  R_X86_64_PLT32	memcpy-0x4
<L29>:
    33c8: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    33cf: 48 89 de                     	movq	%rbx, %rsi
    33d2: e8 19 05 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    33d7: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    33de: 31 ff                        	xorl	%edi, %edi
    33e0: 48 8b 9d 30 fe ff ff         	movq	-0x1d0(%rbp), %rbx
    33e7: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    33ee: e9 c2 fb ff ff               	jmp	 <L7>
<L30>:
    33f3: 84 c0                        	testb	%al, %al
    33f5: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
    33f9: 74 47                        	je	 <L32>
    33fb: 3c 50                        	cmpb	$0x50, %al
    33fd: 72 45                        	jb	 <L33>
    33ff: 0f b6 c0                     	movzbl	%al, %eax
    3402: bb 80 00 00 00               	movl	$0x80, %ebx
    3407: 48 29 c3                     	subq	%rax, %rbx
    340a: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    3411: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3415: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    341c: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    3420: 48 89 da                     	movq	%rbx, %rdx
    3423: e8 00 00 00 00               	callq	 <L31>
		0000000000003424:  R_X86_64_PLT32	memcpy-0x4
<L31>:
    3428: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    342f: 4c 89 f6                     	movq	%r14, %rsi
    3432: e8 b9 04 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3437: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    343e: 31 c0                        	xorl	%eax, %eax
    3440: eb 04                        	jmp	 <L34>
<L32>:
    3442: 31 c0                        	xorl	%eax, %eax
<L33>:
    3444: 31 db                        	xorl	%ebx, %ebx
<L34>:
    3446: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    344a: 48 8d 34 19                  	leaq	(%rcx,%rbx), %rsi
    344e: 41 be 30 00 00 00            	movl	$0x30, %r14d
    3454: 49 29 de                     	subq	%rbx, %r14
    3457: 0f b6 c0                     	movzbl	%al, %eax
    345a: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    345e: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    3465: 4c 89 f2                     	movq	%r14, %rdx
    3468: e8 00 00 00 00               	callq	 <L35>
		0000000000003469:  R_X86_64_PLT32	memcpy-0x4
<L35>:
    346d: 44 02 b5 10 fd ff ff         	addb	-0x2f0(%rbp), %r14b
    3474: 44 88 b5 10 fd ff ff         	movb	%r14b, -0x2f0(%rbp)
    347b: 48 83 85 40 fc ff ff 30      	addq	$0x30, -0x3c0(%rbp)
    3483: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    348b: 44 89 f0                     	movl	%r14d, %eax
    348e: 84 c0                        	testb	%al, %al
    3490: 0f 85 44 fa ff ff            	jne	 <L2>
<L36>:
    3496: 31 c0                        	xorl	%eax, %eax
<L37>:
    3498: 31 db                        	xorl	%ebx, %ebx
<L38>:
    349a: 48 8b 75 c0                  	movq	-0x40(%rbp), %rsi
    349e: 48 01 de                     	addq	%rbx, %rsi
    34a1: 4d 89 fe                     	movq	%r15, %r14
    34a4: 49 29 de                     	subq	%rbx, %r14
    34a7: 48 8d 9d 90 fc ff ff         	leaq	-0x370(%rbp), %rbx
    34ae: 0f b6 c0                     	movzbl	%al, %eax
    34b1: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    34b5: 48 81 c7 90 fc ff ff         	addq	$-0x370, %rdi           # imm = 0xFC90
    34bc: 4c 89 f2                     	movq	%r14, %rdx
    34bf: e8 00 00 00 00               	callq	 <L39>
		00000000000034c0:  R_X86_64_PLT32	memcpy-0x4
<L39>:
    34c4: 0f b6 bd 10 fd ff ff         	movzbl	-0x2f0(%rbp), %edi
    34cb: 4c 01 f7                     	addq	%r14, %rdi
    34ce: 40 88 bd 10 fd ff ff         	movb	%dil, -0x2f0(%rbp)
    34d5: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    34dc: 4c 03 bd 40 fc ff ff         	addq	-0x3c0(%rbp), %r15
    34e3: 49 83 d4 00                  	adcq	$0x0, %r12
    34e7: 4c 89 bd 40 fc ff ff         	movq	%r15, -0x3c0(%rbp)
    34ee: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    34f5: 40 84 ff                     	testb	%dil, %dil
    34f8: 74 46                        	je	 <L41>
    34fa: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    34fe: 72 47                        	jb	 <L42>
    3500: b0 80                        	movb	$-0x80, %al
    3502: 40 28 f8                     	subb	%dil, %al
    3505: 44 0f b6 f8                  	movzbl	%al, %r15d
    3509: 48 01 df                     	addq	%rbx, %rdi
    350c: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3510: 4c 89 fa                     	movq	%r15, %rdx
    3513: e8 00 00 00 00               	callq	 <L40>
		0000000000003514:  R_X86_64_PLT32	memcpy-0x4
<L40>:
    3518: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    351f: 48 89 de                     	movq	%rbx, %rsi
    3522: e8 c9 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3527: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    352e: 31 ff                        	xorl	%edi, %edi
    3530: 4c 8b ad 40 fc ff ff         	movq	-0x3c0(%rbp), %r13
    3537: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    353e: eb 0d                        	jmp	 <L44>
<L41>:
    3540: 4d 89 fd                     	movq	%r15, %r13
    3543: 31 ff                        	xorl	%edi, %edi
    3545: eb 03                        	jmp	 <L43>
<L42>:
    3547: 4d 89 fd                     	movq	%r15, %r13
<L43>:
    354a: 45 31 ff                     	xorl	%r15d, %r15d
<L44>:
    354d: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    3551: 48 83 c6 d7                  	addq	$-0x29, %rsi
    3555: 41 be 01 00 00 00            	movl	$0x1, %r14d
    355b: 4d 29 fe                     	subq	%r15, %r14
    355e: 40 0f b6 c7                  	movzbl	%dil, %eax
    3562: 48 01 c3                     	addq	%rax, %rbx
    3565: 48 89 df                     	movq	%rbx, %rdi
    3568: 4c 89 f2                     	movq	%r14, %rdx
    356b: e8 00 00 00 00               	callq	 <L45>
		000000000000356c:  R_X86_64_PLT32	memcpy-0x4
<L45>:
    3570: 44 00 b5 10 fd ff ff         	addb	%r14b, -0x2f0(%rbp)
    3577: 49 83 c5 01                  	addq	$0x1, %r13
    357b: 49 83 d4 00                  	adcq	$0x0, %r12
    357f: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    3586: 4c 89 ad 40 fc ff ff         	movq	%r13, -0x3c0(%rbp)
    358d: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    3594: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    359b: e8 30 01 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    35a0: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    35a7: be 00 00 00 00               	movl	$0x0, %esi
		00000000000035a8:  R_X86_64_32	.rodata+0xb0
    35ac: ba e0 00 00 00               	movl	$0xe0, %edx
    35b1: 48 89 df                     	movq	%rbx, %rdi
    35b4: e8 00 00 00 00               	callq	 <L46>
		00000000000035b5:  R_X86_64_PLT32	memcpy-0x4
<L46>:
    35b9: 48 8d b5 20 fd ff ff         	leaq	-0x2e0(%rbp), %rsi
    35c0: 48 89 df                     	movq	%rbx, %rdi
    35c3: e8 28 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    35c8: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    35cf: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    35d6: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    35dc: 4c 03 ad 30 fe ff ff         	addq	-0x1d0(%rbp), %r13
    35e3: 49 83 d4 00                  	adcq	$0x0, %r12
    35e7: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    35ee: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    35f5: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    35fc: 48 85 ff                     	testq	%rdi, %rdi
    35ff: 74 49                        	je	 <L48>
    3601: 40 80 ff 50                  	cmpb	$0x50, %dil
    3605: 72 45                        	jb	 <L49>
    3607: 41 be 80 00 00 00            	movl	$0x80, %r14d
    360d: 49 29 fe                     	subq	%rdi, %r14
    3610: 48 01 df                     	addq	%rbx, %rdi
    3613: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    361a: 4c 89 f2                     	movq	%r14, %rdx
    361d: e8 00 00 00 00               	callq	 <L47>
		000000000000361e:  R_X86_64_PLT32	memcpy-0x4
<L47>:
    3622: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    3629: 48 89 de                     	movq	%rbx, %rsi
    362c: e8 bf 02 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3631: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    3638: 31 ff                        	xorl	%edi, %edi
    363a: 4c 8b ad 30 fe ff ff         	movq	-0x1d0(%rbp), %r13
    3641: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    3648: eb 05                        	jmp	 <L50>
<L48>:
    364a: 31 ff                        	xorl	%edi, %edi
<L49>:
    364c: 45 31 f6                     	xorl	%r14d, %r14d
<L50>:
    364f: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    3653: 48 81 c6 c0 fb ff ff         	addq	$-0x440, %rsi           # imm = 0xFBC0
    365a: 41 bf 30 00 00 00            	movl	$0x30, %r15d
    3660: 4d 29 f7                     	subq	%r14, %r15
    3663: 40 0f b6 c7                  	movzbl	%dil, %eax
    3667: 48 01 c3                     	addq	%rax, %rbx
    366a: 48 89 df                     	movq	%rbx, %rdi
    366d: 4c 89 fa                     	movq	%r15, %rdx
    3670: e8 00 00 00 00               	callq	 <L51>
		0000000000003671:  R_X86_64_PLT32	memcpy-0x4
<L51>:
    3675: 44 00 bd 00 ff ff ff         	addb	%r15b, -0x100(%rbp)
    367c: 49 83 c5 30                  	addq	$0x30, %r13
    3680: 49 83 d4 00                  	adcq	$0x0, %r12
    3684: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    368b: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    3692: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    3699: 48 8d 9d 30 fa ff ff         	leaq	-0x5d0(%rbp), %rbx
    36a0: 48 89 de                     	movq	%rbx, %rsi
    36a3: e8 28 00 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    36a8: 48 8b 7d c8                  	movq	-0x38(%rbp), %rdi
    36ac: 48 03 7d b8                  	addq	-0x48(%rbp), %rdi
    36b0: 48 89 de                     	movq	%rbx, %rsi
    36b3: 48 8b 55 a8                  	movq	-0x58(%rbp), %rdx
    36b7: e8 00 00 00 00               	callq	 <L52>
		00000000000036b8:  R_X86_64_PLT32	memcpy-0x4
<L52>:
    36bc: 48 81 c4 a8 05 00 00         	addq	$0x5a8, %rsp            # imm = 0x5A8
    36c3: 5b                           	popq	%rbx
    36c4: 41 5c                        	popq	%r12
    36c6: 41 5d                        	popq	%r13
    36c8: 41 5e                        	popq	%r14
    36ca: 41 5f                        	popq	%r15
    36cc: 5d                           	popq	%rbp
    36cd: c3                           	retq
    36ce: 66 90                        	nop

00000000000036d0 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    36d0: 55                           	pushq	%rbp
    36d1: 48 89 e5                     	movq	%rsp, %rbp
    36d4: 41 57                        	pushq	%r15
    36d6: 41 56                        	pushq	%r14
    36d8: 53                           	pushq	%rbx
    36d9: 50                           	pushq	%rax
    36da: 48 89 f3                     	movq	%rsi, %rbx
    36dd: 49 89 fe                     	movq	%rdi, %r14
    36e0: 4c 8d 7f 50                  	leaq	0x50(%rdi), %r15
    36e4: 0f b6 87 d0 00 00 00         	movzbl	0xd0(%rdi), %eax
    36eb: 48 01 c7                     	addq	%rax, %rdi
    36ee: 48 83 c7 50                  	addq	$0x50, %rdi
    36f2: ba 80 00 00 00               	movl	$0x80, %edx
    36f7: 48 29 c2                     	subq	%rax, %rdx
    36fa: 31 f6                        	xorl	%esi, %esi
    36fc: e8 00 00 00 00               	callq	 <L0>
		00000000000036fd:  R_X86_64_PLT32	memset-0x4
<L0>:
    3701: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    3709: 41 c6 44 06 50 80            	movb	$-0x80, 0x50(%r14,%rax)
    370f: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    3717: 8d 48 01                     	leal	0x1(%rax), %ecx
    371a: 41 88 8e d0 00 00 00         	movb	%cl, 0xd0(%r14)
    3721: 3c 6f                        	cmpb	$0x6f, %al
    3723: 76 30                        	jbe	 <L1>
    3725: 4c 89 f7                     	movq	%r14, %rdi
    3728: 4c 89 fe                     	movq	%r15, %rsi
    372b: e8 c0 01 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3730: 0f 57 c0                     	xorps	%xmm0, %xmm0
    3733: 41 0f 29 47 60               	movaps	%xmm0, 0x60(%r15)
    3738: 41 0f 29 47 50               	movaps	%xmm0, 0x50(%r15)
    373d: 41 0f 29 47 40               	movaps	%xmm0, 0x40(%r15)
    3742: 41 0f 29 47 30               	movaps	%xmm0, 0x30(%r15)
    3747: 41 0f 29 47 20               	movaps	%xmm0, 0x20(%r15)
    374c: 41 0f 29 47 10               	movaps	%xmm0, 0x10(%r15)
    3751: 41 0f 29 07                  	movaps	%xmm0, (%r15)
<L1>:
    3755: 49 8b 06                     	movq	(%r14), %rax
    3758: 49 8b 4e 08                  	movq	0x8(%r14), %rcx
    375c: 89 c2                        	movl	%eax, %edx
    375e: c1 ea 05                     	shrl	$0x5, %edx
    3761: 8d 34 c5 00 00 00 00         	leal	(,%rax,8), %esi
    3768: 41 88 b6 cf 00 00 00         	movb	%sil, 0xcf(%r14)
    376f: 41 88 96 ce 00 00 00         	movb	%dl, 0xce(%r14)
    3776: 89 c2                        	movl	%eax, %edx
    3778: c1 ea 0d                     	shrl	$0xd, %edx
    377b: 41 88 96 cd 00 00 00         	movb	%dl, 0xcd(%r14)
    3782: 89 c2                        	movl	%eax, %edx
    3784: c1 ea 15                     	shrl	$0x15, %edx
    3787: 48 89 ce                     	movq	%rcx, %rsi
    378a: 48 0f a4 c6 1b               	shldq	$0x1b, %rax, %rsi
    378f: 41 88 96 cc 00 00 00         	movb	%dl, 0xcc(%r14)
    3796: 49 89 c8                     	movq	%rcx, %r8
    3799: 49 0f a4 c0 23               	shldq	$0x23, %rax, %r8
    379e: 48 89 ca                     	movq	%rcx, %rdx
    37a1: 49 89 c9                     	movq	%rcx, %r9
    37a4: 49 0f a4 c1 0b               	shldq	$0xb, %rax, %r9
    37a9: 48 89 cf                     	movq	%rcx, %rdi
    37ac: 49 89 ca                     	movq	%rcx, %r10
    37af: 49 0f a4 c2 13               	shldq	$0x13, %rax, %r10
    37b4: 48 0f ac c8 3d               	shrdq	$0x3d, %rcx, %rax
    37b9: 66 48 0f 6e c9               	movq	%rcx, %xmm1
    37be: 48 c1 e9 25                  	shrq	$0x25, %rcx
    37c2: 48 c1 ea 35                  	shrq	$0x35, %rdx
    37c6: 48 c1 ef 2d                  	shrq	$0x2d, %rdi
    37ca: 66 49 0f 6e c2               	movq	%r10, %xmm0
    37cf: 66 49 0f 6e d1               	movq	%r9, %xmm2
    37d4: 66 0f 60 d0                  	punpcklbw	%xmm0, %xmm2    # xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
    37d8: 66 0f 6f 05 00 00 00 00      	movdqa	, %xmm0 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final+0x110>
		00000000000037dc:  R_X86_64_PC32	.LCPI10_0-0x4
    37e0: 66 0f db d0                  	pand	%xmm0, %xmm2
    37e4: 66 49 0f 6e d8               	movq	%r8, %xmm3
    37e9: 66 48 0f 6e e6               	movq	%rsi, %xmm4
    37ee: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    # xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    37f2: 66 0f 72 f4 10               	pslld	$0x10, %xmm4
    37f7: 66 0f 6f d8                  	movdqa	%xmm0, %xmm3
    37fb: 66 0f df dc                  	pandn	%xmm4, %xmm3
    37ff: 66 0f eb da                  	por	%xmm2, %xmm3
    3803: 66 41 0f 7e 9e c8 00 00 00   	movd	%xmm3, 0xc8(%r14)
    380c: 66 0f 6e d7                  	movd	%edi, %xmm2
    3810: 66 0f 6e da                  	movd	%edx, %xmm3
    3814: 66 0f 60 da                  	punpcklbw	%xmm2, %xmm3    # xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
    3818: 66 0f db d8                  	pand	%xmm0, %xmm3
    381c: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
    3820: 66 0f 73 d2 1d               	psrlq	$0x1d, %xmm2
    3825: 66 0f 6e e1                  	movd	%ecx, %xmm4
    3829: 66 0f 60 e2                  	punpcklbw	%xmm2, %xmm4    # xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1],xmm4[2],xmm2[2],xmm4[3],xmm2[3],xmm4[4],xmm2[4],xmm4[5],xmm2[5],xmm4[6],xmm2[6],xmm4[7],xmm2[7]
    382d: 66 0f 72 f4 10               	pslld	$0x10, %xmm4
    3832: 66 0f df c4                  	pandn	%xmm4, %xmm0
    3836: 66 0f eb c3                  	por	%xmm3, %xmm0
    383a: 66 48 0f 6e d0               	movq	%rax, %xmm2
    383f: 66 0f 6f d9                  	movdqa	%xmm1, %xmm3
    3843: 66 0f 73 d3 05               	psrlq	$0x5, %xmm3
    3848: 66 0f 60 da                  	punpcklbw	%xmm2, %xmm3    # xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
    384c: 66 0f 73 f3 30               	psllq	$0x30, %xmm3
    3851: 66 0f 6f 15 00 00 00 00      	movdqa	, %xmm2 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final+0x189>
		0000000000003855:  R_X86_64_PC32	.LCPI10_1-0x4
    3859: 66 0f 6f e1                  	movdqa	%xmm1, %xmm4
    385d: 66 0f 73 d4 0d               	psrlq	$0xd, %xmm4
    3862: 66 0f 73 d1 15               	psrlq	$0x15, %xmm1
    3867: 66 0f 60 cc                  	punpcklbw	%xmm4, %xmm1    # xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1],xmm1[2],xmm4[2],xmm1[3],xmm4[3],xmm1[4],xmm4[4],xmm1[5],xmm4[5],xmm1[6],xmm4[6],xmm1[7],xmm4[7]
    386b: 66 0f 70 c9 50               	pshufd	$0x50, %xmm1, %xmm1     # xmm1 = xmm1[0,0,1,1]
    3870: 66 0f db ca                  	pand	%xmm2, %xmm1
    3874: 66 0f df d3                  	pandn	%xmm3, %xmm2
    3878: 66 0f eb d1                  	por	%xmm1, %xmm2
    387c: 66 0f 70 ca 55               	pshufd	$0x55, %xmm2, %xmm1     # xmm1 = xmm2[1,1,1,1]
    3881: 66 0f 62 c1                  	punpckldq	%xmm1, %xmm0    # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
    3885: 66 41 0f d6 86 c0 00 00 00   	movq	%xmm0, 0xc0(%r14)
    388e: 4c 89 f7                     	movq	%r14, %rdi
    3891: 4c 89 fe                     	movq	%r15, %rsi
    3894: e8 57 00 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3899: 49 8b 46 10                  	movq	0x10(%r14), %rax
    389d: 48 0f c8                     	bswapq	%rax
    38a0: 48 89 03                     	movq	%rax, (%rbx)
    38a3: 49 8b 46 18                  	movq	0x18(%r14), %rax
    38a7: 48 0f c8                     	bswapq	%rax
    38aa: 48 89 43 08                  	movq	%rax, 0x8(%rbx)
    38ae: 49 8b 46 20                  	movq	0x20(%r14), %rax
    38b2: 48 0f c8                     	bswapq	%rax
    38b5: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    38b9: 49 8b 46 28                  	movq	0x28(%r14), %rax
    38bd: 48 0f c8                     	bswapq	%rax
    38c0: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    38c4: 49 8b 46 30                  	movq	0x30(%r14), %rax
    38c8: 48 0f c8                     	bswapq	%rax
    38cb: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    38cf: 49 8b 46 38                  	movq	0x38(%r14), %rax
    38d3: 48 0f c8                     	bswapq	%rax
    38d6: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    38da: 48 83 c4 08                  	addq	$0x8, %rsp
    38de: 5b                           	popq	%rbx
    38df: 41 5e                        	popq	%r14
    38e1: 41 5f                        	popq	%r15
    38e3: 5d                           	popq	%rbp
    38e4: c3                           	retq
    38e5: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    38ef: 90                           	nop

00000000000038f0 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    38f0: 55                           	pushq	%rbp
    38f1: 48 89 e5                     	movq	%rsp, %rbp
    38f4: 41 57                        	pushq	%r15
    38f6: 41 56                        	pushq	%r14
    38f8: 41 55                        	pushq	%r13
    38fa: 41 54                        	pushq	%r12
    38fc: 53                           	pushq	%rbx
    38fd: 48 81 ec 00 02 00 00         	subq	$0x200, %rsp            # imm = 0x200
    3904: 48 8b 16                     	movq	(%rsi), %rdx
    3907: 48 0f ca                     	bswapq	%rdx
    390a: 48 89 95 58 fd ff ff         	movq	%rdx, -0x2a8(%rbp)
    3911: 48 8b 46 08                  	movq	0x8(%rsi), %rax
    3915: 48 0f c8                     	bswapq	%rax
    3918: 48 89 85 60 fd ff ff         	movq	%rax, -0x2a0(%rbp)
    391f: 48 8b 46 10                  	movq	0x10(%rsi), %rax
    3923: 48 0f c8                     	bswapq	%rax
    3926: 48 89 85 68 fd ff ff         	movq	%rax, -0x298(%rbp)
    392d: 48 8b 46 18                  	movq	0x18(%rsi), %rax
    3931: 48 0f c8                     	bswapq	%rax
    3934: 48 89 85 70 fd ff ff         	movq	%rax, -0x290(%rbp)
    393b: 48 8b 46 20                  	movq	0x20(%rsi), %rax
    393f: 48 0f c8                     	bswapq	%rax
    3942: 48 89 85 78 fd ff ff         	movq	%rax, -0x288(%rbp)
    3949: 48 8b 46 28                  	movq	0x28(%rsi), %rax
    394d: 48 0f c8                     	bswapq	%rax
    3950: 48 89 85 80 fd ff ff         	movq	%rax, -0x280(%rbp)
    3957: 48 8b 46 30                  	movq	0x30(%rsi), %rax
    395b: 48 0f c8                     	bswapq	%rax
    395e: 48 89 85 88 fd ff ff         	movq	%rax, -0x278(%rbp)
    3965: 48 8b 46 38                  	movq	0x38(%rsi), %rax
    3969: 48 0f c8                     	bswapq	%rax
    396c: 48 89 85 90 fd ff ff         	movq	%rax, -0x270(%rbp)
    3973: 48 8b 46 40                  	movq	0x40(%rsi), %rax
    3977: 48 0f c8                     	bswapq	%rax
    397a: 48 89 85 98 fd ff ff         	movq	%rax, -0x268(%rbp)
    3981: 48 8b 46 48                  	movq	0x48(%rsi), %rax
    3985: 48 0f c8                     	bswapq	%rax
    3988: 48 89 85 a0 fd ff ff         	movq	%rax, -0x260(%rbp)
    398f: 48 8b 46 50                  	movq	0x50(%rsi), %rax
    3993: 48 0f c8                     	bswapq	%rax
    3996: 48 89 85 a8 fd ff ff         	movq	%rax, -0x258(%rbp)
    399d: 48 8b 46 58                  	movq	0x58(%rsi), %rax
    39a1: 48 0f c8                     	bswapq	%rax
    39a4: 48 89 85 b0 fd ff ff         	movq	%rax, -0x250(%rbp)
    39ab: 48 8b 46 60                  	movq	0x60(%rsi), %rax
    39af: 48 0f c8                     	bswapq	%rax
    39b2: 48 89 85 b8 fd ff ff         	movq	%rax, -0x248(%rbp)
    39b9: 48 8b 46 68                  	movq	0x68(%rsi), %rax
    39bd: 48 0f c8                     	bswapq	%rax
    39c0: 48 89 85 c0 fd ff ff         	movq	%rax, -0x240(%rbp)
    39c7: 48 8b 46 70                  	movq	0x70(%rsi), %rax
    39cb: 48 0f c8                     	bswapq	%rax
    39ce: 48 89 85 c8 fd ff ff         	movq	%rax, -0x238(%rbp)
    39d5: 48 8b 46 78                  	movq	0x78(%rsi), %rax
    39d9: 48 0f c8                     	bswapq	%rax
    39dc: 48 89 85 d0 fd ff ff         	movq	%rax, -0x230(%rbp)
    39e3: 31 c0                        	xorl	%eax, %eax
    39e5: 48 89 d6                     	movq	%rdx, %rsi
    39e8: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L0>:
    39f0: 48 03 b4 c5 a0 fd ff ff      	addq	-0x260(%rbp,%rax,8), %rsi
    39f8: 48 8b 8c c5 60 fd ff ff      	movq	-0x2a0(%rbp,%rax,8), %rcx
    3a00: 49 89 c8                     	movq	%rcx, %r8
    3a03: 49 d1 c8                     	rorq	%r8
    3a06: 49 89 c9                     	movq	%rcx, %r9
    3a09: 49 c1 c1 38                  	rolq	$0x38, %r9
    3a0d: 4c 8b 94 c5 c8 fd ff ff      	movq	-0x238(%rbp,%rax,8), %r10
    3a15: 4d 31 c1                     	xorq	%r8, %r9
    3a18: 49 89 c8                     	movq	%rcx, %r8
    3a1b: 49 c1 e8 07                  	shrq	$0x7, %r8
    3a1f: 4d 31 c8                     	xorq	%r9, %r8
    3a22: 4d 89 d1                     	movq	%r10, %r9
    3a25: 49 c1 c1 2d                  	rolq	$0x2d, %r9
    3a29: 49 01 f0                     	addq	%rsi, %r8
    3a2c: 4c 89 d6                     	movq	%r10, %rsi
    3a2f: 48 c1 c6 03                  	rolq	$0x3, %rsi
    3a33: 4c 31 ce                     	xorq	%r9, %rsi
    3a36: 49 c1 ea 06                  	shrq	$0x6, %r10
    3a3a: 49 31 f2                     	xorq	%rsi, %r10
    3a3d: 4d 01 c2                     	addq	%r8, %r10
    3a40: 4c 89 94 c5 d8 fd ff ff      	movq	%r10, -0x228(%rbp,%rax,8)
    3a48: 48 83 c0 01                  	addq	$0x1, %rax
    3a4c: 48 89 ce                     	movq	%rcx, %rsi
    3a4f: 48 83 f8 40                  	cmpq	$0x40, %rax
    3a53: 75 9b                        	jne	 <L0>
    3a55: 48 8b 47 10                  	movq	0x10(%rdi), %rax
    3a59: 48 8b 77 18                  	movq	0x18(%rdi), %rsi
    3a5d: 4c 8b 47 20                  	movq	0x20(%rdi), %r8
    3a61: 48 8b 4f 30                  	movq	0x30(%rdi), %rcx
    3a65: 49 89 c9                     	movq	%rcx, %r9
    3a68: 49 c1 c1 32                  	rolq	$0x32, %r9
    3a6c: 48 8b 5f 38                  	movq	0x38(%rdi), %rbx
    3a70: 49 89 ca                     	movq	%rcx, %r10
    3a73: 49 c1 c2 2e                  	rolq	$0x2e, %r10
    3a77: 4c 8b 5f 40                  	movq	0x40(%rdi), %r11
    3a7b: 49 89 cf                     	movq	%rcx, %r15
    3a7e: 49 c1 c7 17                  	rolq	$0x17, %r15
    3a82: 4d 31 ca                     	xorq	%r9, %r10
    3a85: 4d 31 d7                     	xorq	%r10, %r15
    3a88: 4d 89 d9                     	movq	%r11, %r9
    3a8b: 49 31 d9                     	xorq	%rbx, %r9
    3a8e: 49 21 c9                     	andq	%rcx, %r9
    3a91: 4d 31 d9                     	xorq	%r11, %r9
    3a94: 4c 03 7f 48                  	addq	0x48(%rdi), %r15
    3a98: 4c 01 ca                     	addq	%r9, %rdx
    3a9b: 49 be 22 ae 28 d7 98 2f 8a 42	movabsq	$0x428a2f98d728ae22, %r14 # imm = 0x428A2F98D728AE22
    3aa5: 49 01 d6                     	addq	%rdx, %r14
    3aa8: 4d 01 fe                     	addq	%r15, %r14
    3aab: 4c 8b 57 28                  	movq	0x28(%rdi), %r10
    3aaf: 48 89 c2                     	movq	%rax, %rdx
    3ab2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3ab6: 4d 01 f2                     	addq	%r14, %r10
    3ab9: 49 89 c1                     	movq	%rax, %r9
    3abc: 49 c1 c1 1e                  	rolq	$0x1e, %r9
    3ac0: 49 31 d1                     	xorq	%rdx, %r9
    3ac3: 48 89 c2                     	movq	%rax, %rdx
    3ac6: 48 c1 c2 19                  	rolq	$0x19, %rdx
    3aca: 4c 31 ca                     	xorq	%r9, %rdx
    3acd: 4d 89 c7                     	movq	%r8, %r15
    3ad0: 49 09 f7                     	orq	%rsi, %r15
    3ad3: 49 21 c7                     	andq	%rax, %r15
    3ad6: 4d 89 c1                     	movq	%r8, %r9
    3ad9: 49 21 f1                     	andq	%rsi, %r9
    3adc: 4d 09 f9                     	orq	%r15, %r9
    3adf: 49 01 d1                     	addq	%rdx, %r9
    3ae2: 4d 01 f1                     	addq	%r14, %r9
    3ae5: 4c 89 d2                     	movq	%r10, %rdx
    3ae8: 48 c1 c2 32                  	rolq	$0x32, %rdx
    3aec: 4d 89 d6                     	movq	%r10, %r14
    3aef: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3af3: 49 31 d6                     	xorq	%rdx, %r14
    3af6: 4d 89 d7                     	movq	%r10, %r15
    3af9: 49 c1 c7 17                  	rolq	$0x17, %r15
    3afd: 4d 31 f7                     	xorq	%r14, %r15
    3b00: 48 89 da                     	movq	%rbx, %rdx
    3b03: 48 31 ca                     	xorq	%rcx, %rdx
    3b06: 4c 21 d2                     	andq	%r10, %rdx
    3b09: 48 31 da                     	xorq	%rbx, %rdx
    3b0c: 4c 03 9d 60 fd ff ff         	addq	-0x2a0(%rbp), %r11
    3b13: 49 01 d3                     	addq	%rdx, %r11
    3b16: 48 ba cd 65 ef 23 91 44 37 71	movabsq	$0x7137449123ef65cd, %rdx # imm = 0x7137449123EF65CD
    3b20: 4c 01 da                     	addq	%r11, %rdx
    3b23: 4d 89 cb                     	movq	%r9, %r11
    3b26: 49 c1 c3 24                  	rolq	$0x24, %r11
    3b2a: 4c 01 fa                     	addq	%r15, %rdx
    3b2d: 4d 89 ce                     	movq	%r9, %r14
    3b30: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3b34: 49 01 d0                     	addq	%rdx, %r8
    3b37: 4d 89 cf                     	movq	%r9, %r15
    3b3a: 49 c1 c7 19                  	rolq	$0x19, %r15
    3b3e: 4d 31 de                     	xorq	%r11, %r14
    3b41: 4d 31 f7                     	xorq	%r14, %r15
    3b44: 49 89 f6                     	movq	%rsi, %r14
    3b47: 49 09 c6                     	orq	%rax, %r14
    3b4a: 4d 21 ce                     	andq	%r9, %r14
    3b4d: 49 89 f3                     	movq	%rsi, %r11
    3b50: 49 21 c3                     	andq	%rax, %r11
    3b53: 4d 09 f3                     	orq	%r14, %r11
    3b56: 4d 01 fb                     	addq	%r15, %r11
    3b59: 4d 89 c6                     	movq	%r8, %r14
    3b5c: 49 c1 c6 32                  	rolq	$0x32, %r14
    3b60: 49 01 d3                     	addq	%rdx, %r11
    3b63: 4c 89 c2                     	movq	%r8, %rdx
    3b66: 48 c1 c2 2e                  	rolq	$0x2e, %rdx
    3b6a: 4c 31 f2                     	xorq	%r14, %rdx
    3b6d: 4d 89 c7                     	movq	%r8, %r15
    3b70: 49 c1 c7 17                  	rolq	$0x17, %r15
    3b74: 49 31 d7                     	xorq	%rdx, %r15
    3b77: 4c 89 d2                     	movq	%r10, %rdx
    3b7a: 48 31 ca                     	xorq	%rcx, %rdx
    3b7d: 4c 21 c2                     	andq	%r8, %rdx
    3b80: 48 31 ca                     	xorq	%rcx, %rdx
    3b83: 48 03 9d 68 fd ff ff         	addq	-0x298(%rbp), %rbx
    3b8a: 48 01 d3                     	addq	%rdx, %rbx
    3b8d: 49 be 2f 3b 4d ec cf fb c0 b5	movabsq	$-0x4a3f043013b2c4d1, %r14 # imm = 0xB5C0FBCFEC4D3B2F
    3b97: 49 01 de                     	addq	%rbx, %r14
    3b9a: 4d 01 fe                     	addq	%r15, %r14
    3b9d: 4c 01 f6                     	addq	%r14, %rsi
    3ba0: 4c 89 da                     	movq	%r11, %rdx
    3ba3: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3ba7: 4c 89 db                     	movq	%r11, %rbx
    3baa: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3bae: 48 31 d3                     	xorq	%rdx, %rbx
    3bb1: 4d 89 df                     	movq	%r11, %r15
    3bb4: 49 c1 c7 19                  	rolq	$0x19, %r15
    3bb8: 49 31 df                     	xorq	%rbx, %r15
    3bbb: 4c 89 cb                     	movq	%r9, %rbx
    3bbe: 48 09 c3                     	orq	%rax, %rbx
    3bc1: 4c 21 db                     	andq	%r11, %rbx
    3bc4: 4c 89 ca                     	movq	%r9, %rdx
    3bc7: 48 21 c2                     	andq	%rax, %rdx
    3bca: 48 09 da                     	orq	%rbx, %rdx
    3bcd: 48 89 f3                     	movq	%rsi, %rbx
    3bd0: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3bd4: 4c 01 fa                     	addq	%r15, %rdx
    3bd7: 49 89 f7                     	movq	%rsi, %r15
    3bda: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3bde: 4c 01 f2                     	addq	%r14, %rdx
    3be1: 49 89 f4                     	movq	%rsi, %r12
    3be4: 49 c1 c4 17                  	rolq	$0x17, %r12
    3be8: 49 31 df                     	xorq	%rbx, %r15
    3beb: 4d 31 fc                     	xorq	%r15, %r12
    3bee: 4c 89 c3                     	movq	%r8, %rbx
    3bf1: 4c 31 d3                     	xorq	%r10, %rbx
    3bf4: 48 21 f3                     	andq	%rsi, %rbx
    3bf7: 4c 31 d3                     	xorq	%r10, %rbx
    3bfa: 48 03 8d 70 fd ff ff         	addq	-0x290(%rbp), %rcx
    3c01: 48 01 d9                     	addq	%rbx, %rcx
    3c04: 49 be bc db 89 81 a5 db b5 e9	movabsq	$-0x164a245a7e762444, %r14 # imm = 0xE9B5DBA58189DBBC
    3c0e: 49 01 ce                     	addq	%rcx, %r14
    3c11: 4d 01 e6                     	addq	%r12, %r14
    3c14: 48 89 d1                     	movq	%rdx, %rcx
    3c17: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3c1b: 48 89 d3                     	movq	%rdx, %rbx
    3c1e: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3c22: 48 31 cb                     	xorq	%rcx, %rbx
    3c25: 49 89 d7                     	movq	%rdx, %r15
    3c28: 49 c1 c7 19                  	rolq	$0x19, %r15
    3c2c: 49 31 df                     	xorq	%rbx, %r15
    3c2f: 4c 89 db                     	movq	%r11, %rbx
    3c32: 4c 09 cb                     	orq	%r9, %rbx
    3c35: 48 21 d3                     	andq	%rdx, %rbx
    3c38: 4c 89 d9                     	movq	%r11, %rcx
    3c3b: 4c 21 c9                     	andq	%r9, %rcx
    3c3e: 48 09 d9                     	orq	%rbx, %rcx
    3c41: 4c 01 f9                     	addq	%r15, %rcx
    3c44: 4c 01 f1                     	addq	%r14, %rcx
    3c47: 49 01 c6                     	addq	%rax, %r14
    3c4a: 4c 89 f3                     	movq	%r14, %rbx
    3c4d: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3c51: 4d 89 f7                     	movq	%r14, %r15
    3c54: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3c58: 49 31 df                     	xorq	%rbx, %r15
    3c5b: 4d 89 f4                     	movq	%r14, %r12
    3c5e: 49 c1 c4 17                  	rolq	$0x17, %r12
    3c62: 4d 31 fc                     	xorq	%r15, %r12
    3c65: 48 89 f3                     	movq	%rsi, %rbx
    3c68: 4c 31 c3                     	xorq	%r8, %rbx
    3c6b: 4c 21 f3                     	andq	%r14, %rbx
    3c6e: 4c 03 95 78 fd ff ff         	addq	-0x288(%rbp), %r10
    3c75: 4c 31 c3                     	xorq	%r8, %rbx
    3c78: 49 01 da                     	addq	%rbx, %r10
    3c7b: 48 bb 38 b5 48 f3 5b c2 56 39	movabsq	$0x3956c25bf348b538, %rbx # imm = 0x3956C25BF348B538
    3c85: 4c 01 d3                     	addq	%r10, %rbx
    3c88: 4c 01 e3                     	addq	%r12, %rbx
    3c8b: 49 89 ca                     	movq	%rcx, %r10
    3c8e: 49 c1 c2 24                  	rolq	$0x24, %r10
    3c92: 49 01 d9                     	addq	%rbx, %r9
    3c95: 49 89 cf                     	movq	%rcx, %r15
    3c98: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3c9c: 4d 31 d7                     	xorq	%r10, %r15
    3c9f: 49 89 cc                     	movq	%rcx, %r12
    3ca2: 49 c1 c4 19                  	rolq	$0x19, %r12
    3ca6: 4d 31 fc                     	xorq	%r15, %r12
    3ca9: 49 89 d7                     	movq	%rdx, %r15
    3cac: 4d 09 df                     	orq	%r11, %r15
    3caf: 49 21 cf                     	andq	%rcx, %r15
    3cb2: 49 89 d2                     	movq	%rdx, %r10
    3cb5: 4d 21 da                     	andq	%r11, %r10
    3cb8: 4d 09 fa                     	orq	%r15, %r10
    3cbb: 4d 01 e2                     	addq	%r12, %r10
    3cbe: 49 01 da                     	addq	%rbx, %r10
    3cc1: 4c 89 cb                     	movq	%r9, %rbx
    3cc4: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3cc8: 4d 89 cf                     	movq	%r9, %r15
    3ccb: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3ccf: 49 31 df                     	xorq	%rbx, %r15
    3cd2: 4c 89 cb                     	movq	%r9, %rbx
    3cd5: 48 c1 c3 17                  	rolq	$0x17, %rbx
    3cd9: 4c 31 fb                     	xorq	%r15, %rbx
    3cdc: 4d 89 f7                     	movq	%r14, %r15
    3cdf: 49 31 f7                     	xorq	%rsi, %r15
    3ce2: 4d 21 cf                     	andq	%r9, %r15
    3ce5: 49 31 f7                     	xorq	%rsi, %r15
    3ce8: 4c 03 85 80 fd ff ff         	addq	-0x280(%rbp), %r8
    3cef: 4d 01 f8                     	addq	%r15, %r8
    3cf2: 49 bf 19 d0 05 b6 f1 11 f1 59	movabsq	$0x59f111f1b605d019, %r15 # imm = 0x59F111F1B605D019
    3cfc: 4d 01 c7                     	addq	%r8, %r15
    3cff: 4d 89 d0                     	movq	%r10, %r8
    3d02: 49 c1 c0 24                  	rolq	$0x24, %r8
    3d06: 49 01 df                     	addq	%rbx, %r15
    3d09: 4c 89 d3                     	movq	%r10, %rbx
    3d0c: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3d10: 4d 01 fb                     	addq	%r15, %r11
    3d13: 4d 89 d4                     	movq	%r10, %r12
    3d16: 49 c1 c4 19                  	rolq	$0x19, %r12
    3d1a: 4c 31 c3                     	xorq	%r8, %rbx
    3d1d: 49 31 dc                     	xorq	%rbx, %r12
    3d20: 49 89 c8                     	movq	%rcx, %r8
    3d23: 49 09 d0                     	orq	%rdx, %r8
    3d26: 4d 21 d0                     	andq	%r10, %r8
    3d29: 48 89 cb                     	movq	%rcx, %rbx
    3d2c: 48 21 d3                     	andq	%rdx, %rbx
    3d2f: 4c 09 c3                     	orq	%r8, %rbx
    3d32: 4c 01 e3                     	addq	%r12, %rbx
    3d35: 4d 89 d8                     	movq	%r11, %r8
    3d38: 49 c1 c0 32                  	rolq	$0x32, %r8
    3d3c: 4c 01 fb                     	addq	%r15, %rbx
    3d3f: 4d 89 df                     	movq	%r11, %r15
    3d42: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3d46: 4d 31 c7                     	xorq	%r8, %r15
    3d49: 4d 89 dc                     	movq	%r11, %r12
    3d4c: 49 c1 c4 17                  	rolq	$0x17, %r12
    3d50: 4d 31 fc                     	xorq	%r15, %r12
    3d53: 4d 89 c8                     	movq	%r9, %r8
    3d56: 4d 31 f0                     	xorq	%r14, %r8
    3d59: 4d 21 d8                     	andq	%r11, %r8
    3d5c: 4d 31 f0                     	xorq	%r14, %r8
    3d5f: 48 03 b5 88 fd ff ff         	addq	-0x278(%rbp), %rsi
    3d66: 4c 01 c6                     	addq	%r8, %rsi
    3d69: 49 b8 9b 4f 19 af a4 82 3f 92	movabsq	$-0x6dc07d5b50e6b065, %r8 # imm = 0x923F82A4AF194F9B
    3d73: 49 01 f0                     	addq	%rsi, %r8
    3d76: 4d 01 e0                     	addq	%r12, %r8
    3d79: 4c 01 c2                     	addq	%r8, %rdx
    3d7c: 48 89 de                     	movq	%rbx, %rsi
    3d7f: 48 c1 c6 24                  	rolq	$0x24, %rsi
    3d83: 49 89 df                     	movq	%rbx, %r15
    3d86: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3d8a: 49 31 f7                     	xorq	%rsi, %r15
    3d8d: 49 89 dc                     	movq	%rbx, %r12
    3d90: 49 c1 c4 19                  	rolq	$0x19, %r12
    3d94: 4d 31 fc                     	xorq	%r15, %r12
    3d97: 4d 89 d7                     	movq	%r10, %r15
    3d9a: 49 09 cf                     	orq	%rcx, %r15
    3d9d: 49 21 df                     	andq	%rbx, %r15
    3da0: 4c 89 d6                     	movq	%r10, %rsi
    3da3: 48 21 ce                     	andq	%rcx, %rsi
    3da6: 4c 09 fe                     	orq	%r15, %rsi
    3da9: 49 89 d7                     	movq	%rdx, %r15
    3dac: 49 c1 c7 32                  	rolq	$0x32, %r15
    3db0: 4c 01 e6                     	addq	%r12, %rsi
    3db3: 49 89 d4                     	movq	%rdx, %r12
    3db6: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3dba: 4c 01 c6                     	addq	%r8, %rsi
    3dbd: 49 89 d0                     	movq	%rdx, %r8
    3dc0: 49 c1 c0 17                  	rolq	$0x17, %r8
    3dc4: 4d 31 fc                     	xorq	%r15, %r12
    3dc7: 4d 31 e0                     	xorq	%r12, %r8
    3dca: 4d 89 df                     	movq	%r11, %r15
    3dcd: 4d 31 cf                     	xorq	%r9, %r15
    3dd0: 49 21 d7                     	andq	%rdx, %r15
    3dd3: 4d 31 cf                     	xorq	%r9, %r15
    3dd6: 4c 03 b5 90 fd ff ff         	addq	-0x270(%rbp), %r14
    3ddd: 4d 01 fe                     	addq	%r15, %r14
    3de0: 49 bf 18 81 6d da d5 5e 1c ab	movabsq	$-0x54e3a12a25927ee8, %r15 # imm = 0xAB1C5ED5DA6D8118
    3dea: 4d 01 f7                     	addq	%r14, %r15
    3ded: 4d 01 c7                     	addq	%r8, %r15
    3df0: 4c 01 f9                     	addq	%r15, %rcx
    3df3: 49 89 f0                     	movq	%rsi, %r8
    3df6: 49 c1 c0 24                  	rolq	$0x24, %r8
    3dfa: 49 89 f6                     	movq	%rsi, %r14
    3dfd: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3e01: 4d 31 c6                     	xorq	%r8, %r14
    3e04: 49 89 f4                     	movq	%rsi, %r12
    3e07: 49 c1 c4 19                  	rolq	$0x19, %r12
    3e0b: 4d 31 f4                     	xorq	%r14, %r12
    3e0e: 49 89 de                     	movq	%rbx, %r14
    3e11: 4d 09 d6                     	orq	%r10, %r14
    3e14: 49 21 f6                     	andq	%rsi, %r14
    3e17: 49 89 d8                     	movq	%rbx, %r8
    3e1a: 4d 21 d0                     	andq	%r10, %r8
    3e1d: 4d 09 f0                     	orq	%r14, %r8
    3e20: 4d 01 e0                     	addq	%r12, %r8
    3e23: 4d 01 f8                     	addq	%r15, %r8
    3e26: 49 89 ce                     	movq	%rcx, %r14
    3e29: 49 c1 c6 32                  	rolq	$0x32, %r14
    3e2d: 49 89 cf                     	movq	%rcx, %r15
    3e30: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3e34: 4d 31 f7                     	xorq	%r14, %r15
    3e37: 49 89 cc                     	movq	%rcx, %r12
    3e3a: 49 c1 c4 17                  	rolq	$0x17, %r12
    3e3e: 4d 31 fc                     	xorq	%r15, %r12
    3e41: 49 89 d6                     	movq	%rdx, %r14
    3e44: 4d 31 de                     	xorq	%r11, %r14
    3e47: 49 21 ce                     	andq	%rcx, %r14
    3e4a: 4c 03 8d 98 fd ff ff         	addq	-0x268(%rbp), %r9
    3e51: 4d 31 de                     	xorq	%r11, %r14
    3e54: 4d 01 f1                     	addq	%r14, %r9
    3e57: 49 be 42 02 03 a3 98 aa 07 d8	movabsq	$-0x27f855675cfcfdbe, %r14 # imm = 0xD807AA98A3030242
    3e61: 4d 01 ce                     	addq	%r9, %r14
    3e64: 4d 01 e6                     	addq	%r12, %r14
    3e67: 4d 89 c1                     	movq	%r8, %r9
    3e6a: 49 c1 c1 24                  	rolq	$0x24, %r9
    3e6e: 4d 01 f2                     	addq	%r14, %r10
    3e71: 4d 89 c7                     	movq	%r8, %r15
    3e74: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3e78: 4d 31 cf                     	xorq	%r9, %r15
    3e7b: 4d 89 c4                     	movq	%r8, %r12
    3e7e: 49 c1 c4 19                  	rolq	$0x19, %r12
    3e82: 4d 31 fc                     	xorq	%r15, %r12
    3e85: 49 89 f7                     	movq	%rsi, %r15
    3e88: 49 09 df                     	orq	%rbx, %r15
    3e8b: 4d 21 c7                     	andq	%r8, %r15
    3e8e: 49 89 f1                     	movq	%rsi, %r9
    3e91: 49 21 d9                     	andq	%rbx, %r9
    3e94: 4d 09 f9                     	orq	%r15, %r9
    3e97: 4d 01 e1                     	addq	%r12, %r9
    3e9a: 4d 01 f1                     	addq	%r14, %r9
    3e9d: 4d 89 d6                     	movq	%r10, %r14
    3ea0: 49 c1 c6 32                  	rolq	$0x32, %r14
    3ea4: 4d 89 d7                     	movq	%r10, %r15
    3ea7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3eab: 4d 31 f7                     	xorq	%r14, %r15
    3eae: 4d 89 d4                     	movq	%r10, %r12
    3eb1: 49 c1 c4 17                  	rolq	$0x17, %r12
    3eb5: 4d 31 fc                     	xorq	%r15, %r12
    3eb8: 49 89 ce                     	movq	%rcx, %r14
    3ebb: 49 31 d6                     	xorq	%rdx, %r14
    3ebe: 4d 21 d6                     	andq	%r10, %r14
    3ec1: 49 31 d6                     	xorq	%rdx, %r14
    3ec4: 4c 03 9d a0 fd ff ff         	addq	-0x260(%rbp), %r11
    3ecb: 4d 01 f3                     	addq	%r14, %r11
    3ece: 49 be be 6f 70 45 01 5b 83 12	movabsq	$0x12835b0145706fbe, %r14 # imm = 0x12835B0145706FBE
    3ed8: 4d 01 de                     	addq	%r11, %r14
    3edb: 4d 89 cb                     	movq	%r9, %r11
    3ede: 49 c1 c3 24                  	rolq	$0x24, %r11
    3ee2: 4d 01 e6                     	addq	%r12, %r14
    3ee5: 4d 89 cf                     	movq	%r9, %r15
    3ee8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3eec: 4c 01 f3                     	addq	%r14, %rbx
    3eef: 4d 89 cc                     	movq	%r9, %r12
    3ef2: 49 c1 c4 19                  	rolq	$0x19, %r12
    3ef6: 4d 31 df                     	xorq	%r11, %r15
    3ef9: 4d 31 fc                     	xorq	%r15, %r12
    3efc: 4d 89 c7                     	movq	%r8, %r15
    3eff: 49 09 f7                     	orq	%rsi, %r15
    3f02: 4d 21 cf                     	andq	%r9, %r15
    3f05: 4d 89 c3                     	movq	%r8, %r11
    3f08: 49 21 f3                     	andq	%rsi, %r11
    3f0b: 4d 09 fb                     	orq	%r15, %r11
    3f0e: 4d 01 e3                     	addq	%r12, %r11
    3f11: 49 89 df                     	movq	%rbx, %r15
    3f14: 49 c1 c7 32                  	rolq	$0x32, %r15
    3f18: 4d 01 f3                     	addq	%r14, %r11
    3f1b: 49 89 de                     	movq	%rbx, %r14
    3f1e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3f22: 4d 31 fe                     	xorq	%r15, %r14
    3f25: 49 89 df                     	movq	%rbx, %r15
    3f28: 49 c1 c7 17                  	rolq	$0x17, %r15
    3f2c: 4d 31 f7                     	xorq	%r14, %r15
    3f2f: 4d 89 d6                     	movq	%r10, %r14
    3f32: 49 31 ce                     	xorq	%rcx, %r14
    3f35: 49 21 de                     	andq	%rbx, %r14
    3f38: 49 31 ce                     	xorq	%rcx, %r14
    3f3b: 48 03 95 a8 fd ff ff         	addq	-0x258(%rbp), %rdx
    3f42: 4c 01 f2                     	addq	%r14, %rdx
    3f45: 49 be 8c b2 e4 4e be 85 31 24	movabsq	$0x243185be4ee4b28c, %r14 # imm = 0x243185BE4EE4B28C
    3f4f: 49 01 d6                     	addq	%rdx, %r14
    3f52: 4d 01 fe                     	addq	%r15, %r14
    3f55: 4c 01 f6                     	addq	%r14, %rsi
    3f58: 4c 89 da                     	movq	%r11, %rdx
    3f5b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3f5f: 4d 89 df                     	movq	%r11, %r15
    3f62: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3f66: 49 31 d7                     	xorq	%rdx, %r15
    3f69: 4d 89 dc                     	movq	%r11, %r12
    3f6c: 49 c1 c4 19                  	rolq	$0x19, %r12
    3f70: 4d 31 fc                     	xorq	%r15, %r12
    3f73: 4d 89 cf                     	movq	%r9, %r15
    3f76: 4d 09 c7                     	orq	%r8, %r15
    3f79: 4d 21 df                     	andq	%r11, %r15
    3f7c: 4c 89 ca                     	movq	%r9, %rdx
    3f7f: 4c 21 c2                     	andq	%r8, %rdx
    3f82: 4c 09 fa                     	orq	%r15, %rdx
    3f85: 49 89 f7                     	movq	%rsi, %r15
    3f88: 49 c1 c7 32                  	rolq	$0x32, %r15
    3f8c: 4c 01 e2                     	addq	%r12, %rdx
    3f8f: 49 89 f4                     	movq	%rsi, %r12
    3f92: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3f96: 4c 01 f2                     	addq	%r14, %rdx
    3f99: 49 89 f6                     	movq	%rsi, %r14
    3f9c: 49 c1 c6 17                  	rolq	$0x17, %r14
    3fa0: 4d 31 fc                     	xorq	%r15, %r12
    3fa3: 4d 31 e6                     	xorq	%r12, %r14
    3fa6: 49 89 df                     	movq	%rbx, %r15
    3fa9: 4d 31 d7                     	xorq	%r10, %r15
    3fac: 49 21 f7                     	andq	%rsi, %r15
    3faf: 4d 31 d7                     	xorq	%r10, %r15
    3fb2: 48 03 8d b0 fd ff ff         	addq	-0x250(%rbp), %rcx
    3fb9: 4c 01 f9                     	addq	%r15, %rcx
    3fbc: 49 bf e2 b4 ff d5 c3 7d 0c 55	movabsq	$0x550c7dc3d5ffb4e2, %r15 # imm = 0x550C7DC3D5FFB4E2
    3fc6: 49 01 cf                     	addq	%rcx, %r15
    3fc9: 4d 01 f7                     	addq	%r14, %r15
    3fcc: 4d 01 f8                     	addq	%r15, %r8
    3fcf: 48 89 d1                     	movq	%rdx, %rcx
    3fd2: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3fd6: 49 89 d6                     	movq	%rdx, %r14
    3fd9: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3fdd: 49 31 ce                     	xorq	%rcx, %r14
    3fe0: 49 89 d4                     	movq	%rdx, %r12
    3fe3: 49 c1 c4 19                  	rolq	$0x19, %r12
    3fe7: 4d 31 f4                     	xorq	%r14, %r12
    3fea: 4d 89 de                     	movq	%r11, %r14
    3fed: 4d 09 ce                     	orq	%r9, %r14
    3ff0: 49 21 d6                     	andq	%rdx, %r14
    3ff3: 4c 89 d9                     	movq	%r11, %rcx
    3ff6: 4c 21 c9                     	andq	%r9, %rcx
    3ff9: 4c 09 f1                     	orq	%r14, %rcx
    3ffc: 4c 01 e1                     	addq	%r12, %rcx
    3fff: 4c 01 f9                     	addq	%r15, %rcx
    4002: 4d 89 c6                     	movq	%r8, %r14
    4005: 49 c1 c6 32                  	rolq	$0x32, %r14
    4009: 4d 89 c7                     	movq	%r8, %r15
    400c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4010: 4d 31 f7                     	xorq	%r14, %r15
    4013: 4d 89 c4                     	movq	%r8, %r12
    4016: 49 c1 c4 17                  	rolq	$0x17, %r12
    401a: 4d 31 fc                     	xorq	%r15, %r12
    401d: 49 89 f6                     	movq	%rsi, %r14
    4020: 49 31 de                     	xorq	%rbx, %r14
    4023: 4d 21 c6                     	andq	%r8, %r14
    4026: 4c 03 95 b8 fd ff ff         	addq	-0x248(%rbp), %r10
    402d: 49 31 de                     	xorq	%rbx, %r14
    4030: 4d 01 f2                     	addq	%r14, %r10
    4033: 49 be 6f 89 7b f2 74 5d be 72	movabsq	$0x72be5d74f27b896f, %r14 # imm = 0x72BE5D74F27B896F
    403d: 4d 01 d6                     	addq	%r10, %r14
    4040: 4d 01 e6                     	addq	%r12, %r14
    4043: 49 89 ca                     	movq	%rcx, %r10
    4046: 49 c1 c2 24                  	rolq	$0x24, %r10
    404a: 4d 01 f1                     	addq	%r14, %r9
    404d: 49 89 cf                     	movq	%rcx, %r15
    4050: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4054: 4d 31 d7                     	xorq	%r10, %r15
    4057: 49 89 cc                     	movq	%rcx, %r12
    405a: 49 c1 c4 19                  	rolq	$0x19, %r12
    405e: 4d 31 fc                     	xorq	%r15, %r12
    4061: 49 89 d7                     	movq	%rdx, %r15
    4064: 4d 09 df                     	orq	%r11, %r15
    4067: 49 21 cf                     	andq	%rcx, %r15
    406a: 49 89 d2                     	movq	%rdx, %r10
    406d: 4d 21 da                     	andq	%r11, %r10
    4070: 4d 09 fa                     	orq	%r15, %r10
    4073: 4d 01 e2                     	addq	%r12, %r10
    4076: 4d 01 f2                     	addq	%r14, %r10
    4079: 4d 89 ce                     	movq	%r9, %r14
    407c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4080: 4d 89 cf                     	movq	%r9, %r15
    4083: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4087: 4d 31 f7                     	xorq	%r14, %r15
    408a: 4d 89 cc                     	movq	%r9, %r12
    408d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4091: 4d 31 fc                     	xorq	%r15, %r12
    4094: 4d 89 c6                     	movq	%r8, %r14
    4097: 49 31 f6                     	xorq	%rsi, %r14
    409a: 4d 21 ce                     	andq	%r9, %r14
    409d: 49 31 f6                     	xorq	%rsi, %r14
    40a0: 48 03 9d c0 fd ff ff         	addq	-0x240(%rbp), %rbx
    40a7: 4c 01 f3                     	addq	%r14, %rbx
    40aa: 49 be b1 96 16 3b fe b1 de 80	movabsq	$-0x7f214e01c4e9694f, %r14 # imm = 0x80DEB1FE3B1696B1
    40b4: 49 01 de                     	addq	%rbx, %r14
    40b7: 4c 89 d3                     	movq	%r10, %rbx
    40ba: 48 c1 c3 24                  	rolq	$0x24, %rbx
    40be: 4d 01 e6                     	addq	%r12, %r14
    40c1: 4d 89 d7                     	movq	%r10, %r15
    40c4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    40c8: 4d 01 f3                     	addq	%r14, %r11
    40cb: 4d 89 d4                     	movq	%r10, %r12
    40ce: 49 c1 c4 19                  	rolq	$0x19, %r12
    40d2: 49 31 df                     	xorq	%rbx, %r15
    40d5: 4d 31 fc                     	xorq	%r15, %r12
    40d8: 49 89 cf                     	movq	%rcx, %r15
    40db: 49 09 d7                     	orq	%rdx, %r15
    40de: 4d 21 d7                     	andq	%r10, %r15
    40e1: 48 89 cb                     	movq	%rcx, %rbx
    40e4: 48 21 d3                     	andq	%rdx, %rbx
    40e7: 4c 09 fb                     	orq	%r15, %rbx
    40ea: 4c 01 e3                     	addq	%r12, %rbx
    40ed: 4d 89 df                     	movq	%r11, %r15
    40f0: 49 c1 c7 32                  	rolq	$0x32, %r15
    40f4: 4c 01 f3                     	addq	%r14, %rbx
    40f7: 4d 89 de                     	movq	%r11, %r14
    40fa: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    40fe: 4d 31 fe                     	xorq	%r15, %r14
    4101: 4d 89 df                     	movq	%r11, %r15
    4104: 49 c1 c7 17                  	rolq	$0x17, %r15
    4108: 4d 31 f7                     	xorq	%r14, %r15
    410b: 4d 89 ce                     	movq	%r9, %r14
    410e: 4d 31 c6                     	xorq	%r8, %r14
    4111: 4d 21 de                     	andq	%r11, %r14
    4114: 4d 31 c6                     	xorq	%r8, %r14
    4117: 48 03 b5 c8 fd ff ff         	addq	-0x238(%rbp), %rsi
    411e: 4c 01 f6                     	addq	%r14, %rsi
    4121: 49 be 35 12 c7 25 a7 06 dc 9b	movabsq	$-0x6423f958da38edcb, %r14 # imm = 0x9BDC06A725C71235
    412b: 49 01 f6                     	addq	%rsi, %r14
    412e: 4d 01 fe                     	addq	%r15, %r14
    4131: 4c 01 f2                     	addq	%r14, %rdx
    4134: 48 89 de                     	movq	%rbx, %rsi
    4137: 48 c1 c6 24                  	rolq	$0x24, %rsi
    413b: 49 89 df                     	movq	%rbx, %r15
    413e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4142: 49 31 f7                     	xorq	%rsi, %r15
    4145: 49 89 dc                     	movq	%rbx, %r12
    4148: 49 c1 c4 19                  	rolq	$0x19, %r12
    414c: 4d 31 fc                     	xorq	%r15, %r12
    414f: 4d 89 d7                     	movq	%r10, %r15
    4152: 49 09 cf                     	orq	%rcx, %r15
    4155: 49 21 df                     	andq	%rbx, %r15
    4158: 4c 89 d6                     	movq	%r10, %rsi
    415b: 48 21 ce                     	andq	%rcx, %rsi
    415e: 4c 09 fe                     	orq	%r15, %rsi
    4161: 49 89 d7                     	movq	%rdx, %r15
    4164: 49 c1 c7 32                  	rolq	$0x32, %r15
    4168: 4c 01 e6                     	addq	%r12, %rsi
    416b: 49 89 d4                     	movq	%rdx, %r12
    416e: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4172: 4c 01 f6                     	addq	%r14, %rsi
    4175: 49 89 d6                     	movq	%rdx, %r14
    4178: 49 c1 c6 17                  	rolq	$0x17, %r14
    417c: 4d 31 fc                     	xorq	%r15, %r12
    417f: 4d 31 e6                     	xorq	%r12, %r14
    4182: 4d 89 df                     	movq	%r11, %r15
    4185: 4d 31 cf                     	xorq	%r9, %r15
    4188: 49 21 d7                     	andq	%rdx, %r15
    418b: 4d 31 cf                     	xorq	%r9, %r15
    418e: 4c 03 85 d0 fd ff ff         	addq	-0x230(%rbp), %r8
    4195: 4d 01 f8                     	addq	%r15, %r8
    4198: 49 bf 94 26 69 cf 74 f1 9b c1	movabsq	$-0x3e640e8b3096d96c, %r15 # imm = 0xC19BF174CF692694
    41a2: 4d 01 c7                     	addq	%r8, %r15
    41a5: 4d 01 f7                     	addq	%r14, %r15
    41a8: 4c 01 f9                     	addq	%r15, %rcx
    41ab: 49 89 f0                     	movq	%rsi, %r8
    41ae: 49 c1 c0 24                  	rolq	$0x24, %r8
    41b2: 49 89 f6                     	movq	%rsi, %r14
    41b5: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    41b9: 4d 31 c6                     	xorq	%r8, %r14
    41bc: 49 89 f4                     	movq	%rsi, %r12
    41bf: 49 c1 c4 19                  	rolq	$0x19, %r12
    41c3: 4d 31 f4                     	xorq	%r14, %r12
    41c6: 49 89 de                     	movq	%rbx, %r14
    41c9: 4d 09 d6                     	orq	%r10, %r14
    41cc: 49 21 f6                     	andq	%rsi, %r14
    41cf: 49 89 d8                     	movq	%rbx, %r8
    41d2: 4d 21 d0                     	andq	%r10, %r8
    41d5: 4d 09 f0                     	orq	%r14, %r8
    41d8: 4d 01 e0                     	addq	%r12, %r8
    41db: 4d 01 f8                     	addq	%r15, %r8
    41de: 49 89 ce                     	movq	%rcx, %r14
    41e1: 49 c1 c6 32                  	rolq	$0x32, %r14
    41e5: 49 89 cf                     	movq	%rcx, %r15
    41e8: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    41ec: 4d 31 f7                     	xorq	%r14, %r15
    41ef: 49 89 cc                     	movq	%rcx, %r12
    41f2: 49 c1 c4 17                  	rolq	$0x17, %r12
    41f6: 4d 31 fc                     	xorq	%r15, %r12
    41f9: 49 89 d6                     	movq	%rdx, %r14
    41fc: 4d 31 de                     	xorq	%r11, %r14
    41ff: 49 21 ce                     	andq	%rcx, %r14
    4202: 4c 03 8d d8 fd ff ff         	addq	-0x228(%rbp), %r9
    4209: 4d 31 de                     	xorq	%r11, %r14
    420c: 4d 01 f1                     	addq	%r14, %r9
    420f: 49 be d2 4a f1 9e c1 69 9b e4	movabsq	$-0x1b64963e610eb52e, %r14 # imm = 0xE49B69C19EF14AD2
    4219: 4d 01 ce                     	addq	%r9, %r14
    421c: 4d 01 e6                     	addq	%r12, %r14
    421f: 4d 89 c1                     	movq	%r8, %r9
    4222: 49 c1 c1 24                  	rolq	$0x24, %r9
    4226: 4d 01 f2                     	addq	%r14, %r10
    4229: 4d 89 c7                     	movq	%r8, %r15
    422c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4230: 4d 31 cf                     	xorq	%r9, %r15
    4233: 4d 89 c4                     	movq	%r8, %r12
    4236: 49 c1 c4 19                  	rolq	$0x19, %r12
    423a: 4d 31 fc                     	xorq	%r15, %r12
    423d: 49 89 f7                     	movq	%rsi, %r15
    4240: 49 09 df                     	orq	%rbx, %r15
    4243: 4d 21 c7                     	andq	%r8, %r15
    4246: 49 89 f1                     	movq	%rsi, %r9
    4249: 49 21 d9                     	andq	%rbx, %r9
    424c: 4d 09 f9                     	orq	%r15, %r9
    424f: 4d 01 e1                     	addq	%r12, %r9
    4252: 4d 01 f1                     	addq	%r14, %r9
    4255: 4d 89 d6                     	movq	%r10, %r14
    4258: 49 c1 c6 32                  	rolq	$0x32, %r14
    425c: 4d 89 d7                     	movq	%r10, %r15
    425f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4263: 4d 31 f7                     	xorq	%r14, %r15
    4266: 4d 89 d4                     	movq	%r10, %r12
    4269: 49 c1 c4 17                  	rolq	$0x17, %r12
    426d: 4d 31 fc                     	xorq	%r15, %r12
    4270: 49 89 ce                     	movq	%rcx, %r14
    4273: 49 31 d6                     	xorq	%rdx, %r14
    4276: 4d 21 d6                     	andq	%r10, %r14
    4279: 49 31 d6                     	xorq	%rdx, %r14
    427c: 4c 03 9d e0 fd ff ff         	addq	-0x220(%rbp), %r11
    4283: 4d 01 f3                     	addq	%r14, %r11
    4286: 49 be e3 25 4f 38 86 47 be ef	movabsq	$-0x1041b879c7b0da1d, %r14 # imm = 0xEFBE4786384F25E3
    4290: 4d 01 de                     	addq	%r11, %r14
    4293: 4d 89 cb                     	movq	%r9, %r11
    4296: 49 c1 c3 24                  	rolq	$0x24, %r11
    429a: 4d 01 e6                     	addq	%r12, %r14
    429d: 4d 89 cf                     	movq	%r9, %r15
    42a0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    42a4: 4c 01 f3                     	addq	%r14, %rbx
    42a7: 4d 89 cc                     	movq	%r9, %r12
    42aa: 49 c1 c4 19                  	rolq	$0x19, %r12
    42ae: 4d 31 df                     	xorq	%r11, %r15
    42b1: 4d 31 fc                     	xorq	%r15, %r12
    42b4: 4d 89 c7                     	movq	%r8, %r15
    42b7: 49 09 f7                     	orq	%rsi, %r15
    42ba: 4d 21 cf                     	andq	%r9, %r15
    42bd: 4d 89 c3                     	movq	%r8, %r11
    42c0: 49 21 f3                     	andq	%rsi, %r11
    42c3: 4d 09 fb                     	orq	%r15, %r11
    42c6: 4d 01 e3                     	addq	%r12, %r11
    42c9: 49 89 df                     	movq	%rbx, %r15
    42cc: 49 c1 c7 32                  	rolq	$0x32, %r15
    42d0: 4d 01 f3                     	addq	%r14, %r11
    42d3: 49 89 de                     	movq	%rbx, %r14
    42d6: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    42da: 4d 31 fe                     	xorq	%r15, %r14
    42dd: 49 89 df                     	movq	%rbx, %r15
    42e0: 49 c1 c7 17                  	rolq	$0x17, %r15
    42e4: 4d 31 f7                     	xorq	%r14, %r15
    42e7: 4d 89 d6                     	movq	%r10, %r14
    42ea: 49 31 ce                     	xorq	%rcx, %r14
    42ed: 49 21 de                     	andq	%rbx, %r14
    42f0: 49 31 ce                     	xorq	%rcx, %r14
    42f3: 48 03 95 e8 fd ff ff         	addq	-0x218(%rbp), %rdx
    42fa: 4c 01 f2                     	addq	%r14, %rdx
    42fd: 49 be b5 d5 8c 8b c6 9d c1 0f	movabsq	$0xfc19dc68b8cd5b5, %r14 # imm = 0xFC19DC68B8CD5B5
    4307: 49 01 d6                     	addq	%rdx, %r14
    430a: 4d 01 fe                     	addq	%r15, %r14
    430d: 4c 01 f6                     	addq	%r14, %rsi
    4310: 4c 89 da                     	movq	%r11, %rdx
    4313: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4317: 4d 89 df                     	movq	%r11, %r15
    431a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    431e: 49 31 d7                     	xorq	%rdx, %r15
    4321: 4d 89 dc                     	movq	%r11, %r12
    4324: 49 c1 c4 19                  	rolq	$0x19, %r12
    4328: 4d 31 fc                     	xorq	%r15, %r12
    432b: 4d 89 cf                     	movq	%r9, %r15
    432e: 4d 09 c7                     	orq	%r8, %r15
    4331: 4d 21 df                     	andq	%r11, %r15
    4334: 4c 89 ca                     	movq	%r9, %rdx
    4337: 4c 21 c2                     	andq	%r8, %rdx
    433a: 4c 09 fa                     	orq	%r15, %rdx
    433d: 49 89 f7                     	movq	%rsi, %r15
    4340: 49 c1 c7 32                  	rolq	$0x32, %r15
    4344: 4c 01 e2                     	addq	%r12, %rdx
    4347: 49 89 f4                     	movq	%rsi, %r12
    434a: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    434e: 4c 01 f2                     	addq	%r14, %rdx
    4351: 49 89 f6                     	movq	%rsi, %r14
    4354: 49 c1 c6 17                  	rolq	$0x17, %r14
    4358: 4d 31 fc                     	xorq	%r15, %r12
    435b: 4d 31 e6                     	xorq	%r12, %r14
    435e: 49 89 df                     	movq	%rbx, %r15
    4361: 4d 31 d7                     	xorq	%r10, %r15
    4364: 49 21 f7                     	andq	%rsi, %r15
    4367: 4d 31 d7                     	xorq	%r10, %r15
    436a: 48 03 8d f0 fd ff ff         	addq	-0x210(%rbp), %rcx
    4371: 4c 01 f9                     	addq	%r15, %rcx
    4374: 49 bf 65 9c ac 77 cc a1 0c 24	movabsq	$0x240ca1cc77ac9c65, %r15 # imm = 0x240CA1CC77AC9C65
    437e: 49 01 cf                     	addq	%rcx, %r15
    4381: 4d 01 f7                     	addq	%r14, %r15
    4384: 4d 01 f8                     	addq	%r15, %r8
    4387: 48 89 d1                     	movq	%rdx, %rcx
    438a: 48 c1 c1 24                  	rolq	$0x24, %rcx
    438e: 49 89 d6                     	movq	%rdx, %r14
    4391: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4395: 49 31 ce                     	xorq	%rcx, %r14
    4398: 49 89 d4                     	movq	%rdx, %r12
    439b: 49 c1 c4 19                  	rolq	$0x19, %r12
    439f: 4d 31 f4                     	xorq	%r14, %r12
    43a2: 4d 89 de                     	movq	%r11, %r14
    43a5: 4d 09 ce                     	orq	%r9, %r14
    43a8: 49 21 d6                     	andq	%rdx, %r14
    43ab: 4c 89 d9                     	movq	%r11, %rcx
    43ae: 4c 21 c9                     	andq	%r9, %rcx
    43b1: 4c 09 f1                     	orq	%r14, %rcx
    43b4: 4c 01 e1                     	addq	%r12, %rcx
    43b7: 4c 01 f9                     	addq	%r15, %rcx
    43ba: 4d 89 c6                     	movq	%r8, %r14
    43bd: 49 c1 c6 32                  	rolq	$0x32, %r14
    43c1: 4d 89 c7                     	movq	%r8, %r15
    43c4: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    43c8: 4d 31 f7                     	xorq	%r14, %r15
    43cb: 4d 89 c4                     	movq	%r8, %r12
    43ce: 49 c1 c4 17                  	rolq	$0x17, %r12
    43d2: 4d 31 fc                     	xorq	%r15, %r12
    43d5: 49 89 f6                     	movq	%rsi, %r14
    43d8: 49 31 de                     	xorq	%rbx, %r14
    43db: 4d 21 c6                     	andq	%r8, %r14
    43de: 4c 03 95 f8 fd ff ff         	addq	-0x208(%rbp), %r10
    43e5: 49 31 de                     	xorq	%rbx, %r14
    43e8: 4d 01 f2                     	addq	%r14, %r10
    43eb: 49 be 75 02 2b 59 6f 2c e9 2d	movabsq	$0x2de92c6f592b0275, %r14 # imm = 0x2DE92C6F592B0275
    43f5: 4d 01 d6                     	addq	%r10, %r14
    43f8: 4d 01 e6                     	addq	%r12, %r14
    43fb: 49 89 ca                     	movq	%rcx, %r10
    43fe: 49 c1 c2 24                  	rolq	$0x24, %r10
    4402: 4d 01 f1                     	addq	%r14, %r9
    4405: 49 89 cf                     	movq	%rcx, %r15
    4408: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    440c: 4d 31 d7                     	xorq	%r10, %r15
    440f: 49 89 cc                     	movq	%rcx, %r12
    4412: 49 c1 c4 19                  	rolq	$0x19, %r12
    4416: 4d 31 fc                     	xorq	%r15, %r12
    4419: 49 89 d7                     	movq	%rdx, %r15
    441c: 4d 09 df                     	orq	%r11, %r15
    441f: 49 21 cf                     	andq	%rcx, %r15
    4422: 49 89 d2                     	movq	%rdx, %r10
    4425: 4d 21 da                     	andq	%r11, %r10
    4428: 4d 09 fa                     	orq	%r15, %r10
    442b: 4d 01 e2                     	addq	%r12, %r10
    442e: 4d 01 f2                     	addq	%r14, %r10
    4431: 4d 89 ce                     	movq	%r9, %r14
    4434: 49 c1 c6 32                  	rolq	$0x32, %r14
    4438: 4d 89 cf                     	movq	%r9, %r15
    443b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    443f: 4d 31 f7                     	xorq	%r14, %r15
    4442: 4d 89 cc                     	movq	%r9, %r12
    4445: 49 c1 c4 17                  	rolq	$0x17, %r12
    4449: 4d 31 fc                     	xorq	%r15, %r12
    444c: 4d 89 c6                     	movq	%r8, %r14
    444f: 49 31 f6                     	xorq	%rsi, %r14
    4452: 4d 21 ce                     	andq	%r9, %r14
    4455: 49 31 f6                     	xorq	%rsi, %r14
    4458: 48 03 9d 00 fe ff ff         	addq	-0x200(%rbp), %rbx
    445f: 4c 01 f3                     	addq	%r14, %rbx
    4462: 49 be 83 e4 a6 6e aa 84 74 4a	movabsq	$0x4a7484aa6ea6e483, %r14 # imm = 0x4A7484AA6EA6E483
    446c: 49 01 de                     	addq	%rbx, %r14
    446f: 4c 89 d3                     	movq	%r10, %rbx
    4472: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4476: 4d 01 e6                     	addq	%r12, %r14
    4479: 4d 89 d7                     	movq	%r10, %r15
    447c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4480: 4d 01 f3                     	addq	%r14, %r11
    4483: 4d 89 d4                     	movq	%r10, %r12
    4486: 49 c1 c4 19                  	rolq	$0x19, %r12
    448a: 49 31 df                     	xorq	%rbx, %r15
    448d: 4d 31 fc                     	xorq	%r15, %r12
    4490: 49 89 cf                     	movq	%rcx, %r15
    4493: 49 09 d7                     	orq	%rdx, %r15
    4496: 4d 21 d7                     	andq	%r10, %r15
    4499: 48 89 cb                     	movq	%rcx, %rbx
    449c: 48 21 d3                     	andq	%rdx, %rbx
    449f: 4c 09 fb                     	orq	%r15, %rbx
    44a2: 4c 01 e3                     	addq	%r12, %rbx
    44a5: 4d 89 df                     	movq	%r11, %r15
    44a8: 49 c1 c7 32                  	rolq	$0x32, %r15
    44ac: 4c 01 f3                     	addq	%r14, %rbx
    44af: 4d 89 de                     	movq	%r11, %r14
    44b2: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    44b6: 4d 31 fe                     	xorq	%r15, %r14
    44b9: 4d 89 df                     	movq	%r11, %r15
    44bc: 49 c1 c7 17                  	rolq	$0x17, %r15
    44c0: 4d 31 f7                     	xorq	%r14, %r15
    44c3: 4d 89 ce                     	movq	%r9, %r14
    44c6: 4d 31 c6                     	xorq	%r8, %r14
    44c9: 4d 21 de                     	andq	%r11, %r14
    44cc: 4d 31 c6                     	xorq	%r8, %r14
    44cf: 48 03 b5 08 fe ff ff         	addq	-0x1f8(%rbp), %rsi
    44d6: 4c 01 f6                     	addq	%r14, %rsi
    44d9: 49 be d4 fb 41 bd dc a9 b0 5c	movabsq	$0x5cb0a9dcbd41fbd4, %r14 # imm = 0x5CB0A9DCBD41FBD4
    44e3: 49 01 f6                     	addq	%rsi, %r14
    44e6: 4d 01 fe                     	addq	%r15, %r14
    44e9: 4c 01 f2                     	addq	%r14, %rdx
    44ec: 48 89 de                     	movq	%rbx, %rsi
    44ef: 48 c1 c6 24                  	rolq	$0x24, %rsi
    44f3: 49 89 df                     	movq	%rbx, %r15
    44f6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    44fa: 49 31 f7                     	xorq	%rsi, %r15
    44fd: 49 89 dc                     	movq	%rbx, %r12
    4500: 49 c1 c4 19                  	rolq	$0x19, %r12
    4504: 4d 31 fc                     	xorq	%r15, %r12
    4507: 4d 89 d7                     	movq	%r10, %r15
    450a: 49 09 cf                     	orq	%rcx, %r15
    450d: 49 21 df                     	andq	%rbx, %r15
    4510: 4c 89 d6                     	movq	%r10, %rsi
    4513: 48 21 ce                     	andq	%rcx, %rsi
    4516: 4c 09 fe                     	orq	%r15, %rsi
    4519: 49 89 d7                     	movq	%rdx, %r15
    451c: 49 c1 c7 32                  	rolq	$0x32, %r15
    4520: 4c 01 e6                     	addq	%r12, %rsi
    4523: 49 89 d4                     	movq	%rdx, %r12
    4526: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    452a: 4c 01 f6                     	addq	%r14, %rsi
    452d: 49 89 d6                     	movq	%rdx, %r14
    4530: 49 c1 c6 17                  	rolq	$0x17, %r14
    4534: 4d 31 fc                     	xorq	%r15, %r12
    4537: 4d 31 e6                     	xorq	%r12, %r14
    453a: 4d 89 df                     	movq	%r11, %r15
    453d: 4d 31 cf                     	xorq	%r9, %r15
    4540: 49 21 d7                     	andq	%rdx, %r15
    4543: 4d 31 cf                     	xorq	%r9, %r15
    4546: 4c 03 85 10 fe ff ff         	addq	-0x1f0(%rbp), %r8
    454d: 4d 01 f8                     	addq	%r15, %r8
    4550: 49 bf b5 53 11 83 da 88 f9 76	movabsq	$0x76f988da831153b5, %r15 # imm = 0x76F988DA831153B5
    455a: 4d 01 c7                     	addq	%r8, %r15
    455d: 4d 01 f7                     	addq	%r14, %r15
    4560: 4c 01 f9                     	addq	%r15, %rcx
    4563: 49 89 f0                     	movq	%rsi, %r8
    4566: 49 c1 c0 24                  	rolq	$0x24, %r8
    456a: 49 89 f6                     	movq	%rsi, %r14
    456d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4571: 4d 31 c6                     	xorq	%r8, %r14
    4574: 49 89 f4                     	movq	%rsi, %r12
    4577: 49 c1 c4 19                  	rolq	$0x19, %r12
    457b: 4d 31 f4                     	xorq	%r14, %r12
    457e: 49 89 de                     	movq	%rbx, %r14
    4581: 4d 09 d6                     	orq	%r10, %r14
    4584: 49 21 f6                     	andq	%rsi, %r14
    4587: 49 89 d8                     	movq	%rbx, %r8
    458a: 4d 21 d0                     	andq	%r10, %r8
    458d: 4d 09 f0                     	orq	%r14, %r8
    4590: 4d 01 e0                     	addq	%r12, %r8
    4593: 4d 01 f8                     	addq	%r15, %r8
    4596: 49 89 ce                     	movq	%rcx, %r14
    4599: 49 c1 c6 32                  	rolq	$0x32, %r14
    459d: 49 89 cf                     	movq	%rcx, %r15
    45a0: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    45a4: 4d 31 f7                     	xorq	%r14, %r15
    45a7: 49 89 cc                     	movq	%rcx, %r12
    45aa: 49 c1 c4 17                  	rolq	$0x17, %r12
    45ae: 4d 31 fc                     	xorq	%r15, %r12
    45b1: 49 89 d6                     	movq	%rdx, %r14
    45b4: 4d 31 de                     	xorq	%r11, %r14
    45b7: 49 21 ce                     	andq	%rcx, %r14
    45ba: 4c 03 8d 18 fe ff ff         	addq	-0x1e8(%rbp), %r9
    45c1: 4d 31 de                     	xorq	%r11, %r14
    45c4: 4d 01 f1                     	addq	%r14, %r9
    45c7: 49 be ab df 66 ee 52 51 3e 98	movabsq	$-0x67c1aead11992055, %r14 # imm = 0x983E5152EE66DFAB
    45d1: 4d 01 ce                     	addq	%r9, %r14
    45d4: 4d 01 e6                     	addq	%r12, %r14
    45d7: 4d 89 c1                     	movq	%r8, %r9
    45da: 49 c1 c1 24                  	rolq	$0x24, %r9
    45de: 4d 01 f2                     	addq	%r14, %r10
    45e1: 4d 89 c7                     	movq	%r8, %r15
    45e4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    45e8: 4d 31 cf                     	xorq	%r9, %r15
    45eb: 4d 89 c4                     	movq	%r8, %r12
    45ee: 49 c1 c4 19                  	rolq	$0x19, %r12
    45f2: 4d 31 fc                     	xorq	%r15, %r12
    45f5: 49 89 f7                     	movq	%rsi, %r15
    45f8: 49 09 df                     	orq	%rbx, %r15
    45fb: 4d 21 c7                     	andq	%r8, %r15
    45fe: 49 89 f1                     	movq	%rsi, %r9
    4601: 49 21 d9                     	andq	%rbx, %r9
    4604: 4d 09 f9                     	orq	%r15, %r9
    4607: 4d 01 e1                     	addq	%r12, %r9
    460a: 4d 01 f1                     	addq	%r14, %r9
    460d: 4d 89 d6                     	movq	%r10, %r14
    4610: 49 c1 c6 32                  	rolq	$0x32, %r14
    4614: 4d 89 d7                     	movq	%r10, %r15
    4617: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    461b: 4d 31 f7                     	xorq	%r14, %r15
    461e: 4d 89 d4                     	movq	%r10, %r12
    4621: 49 c1 c4 17                  	rolq	$0x17, %r12
    4625: 4d 31 fc                     	xorq	%r15, %r12
    4628: 49 89 ce                     	movq	%rcx, %r14
    462b: 49 31 d6                     	xorq	%rdx, %r14
    462e: 4d 21 d6                     	andq	%r10, %r14
    4631: 49 31 d6                     	xorq	%rdx, %r14
    4634: 4c 03 9d 20 fe ff ff         	addq	-0x1e0(%rbp), %r11
    463b: 4d 01 f3                     	addq	%r14, %r11
    463e: 49 be 10 32 b4 2d 6d c6 31 a8	movabsq	$-0x57ce3992d24bcdf0, %r14 # imm = 0xA831C66D2DB43210
    4648: 4d 01 de                     	addq	%r11, %r14
    464b: 4d 89 cb                     	movq	%r9, %r11
    464e: 49 c1 c3 24                  	rolq	$0x24, %r11
    4652: 4d 01 e6                     	addq	%r12, %r14
    4655: 4d 89 cf                     	movq	%r9, %r15
    4658: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    465c: 4c 01 f3                     	addq	%r14, %rbx
    465f: 4d 89 cc                     	movq	%r9, %r12
    4662: 49 c1 c4 19                  	rolq	$0x19, %r12
    4666: 4d 31 df                     	xorq	%r11, %r15
    4669: 4d 31 fc                     	xorq	%r15, %r12
    466c: 4d 89 c7                     	movq	%r8, %r15
    466f: 49 09 f7                     	orq	%rsi, %r15
    4672: 4d 21 cf                     	andq	%r9, %r15
    4675: 4d 89 c3                     	movq	%r8, %r11
    4678: 49 21 f3                     	andq	%rsi, %r11
    467b: 4d 09 fb                     	orq	%r15, %r11
    467e: 4d 01 e3                     	addq	%r12, %r11
    4681: 49 89 df                     	movq	%rbx, %r15
    4684: 49 c1 c7 32                  	rolq	$0x32, %r15
    4688: 4d 01 f3                     	addq	%r14, %r11
    468b: 49 89 de                     	movq	%rbx, %r14
    468e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4692: 4d 31 fe                     	xorq	%r15, %r14
    4695: 49 89 df                     	movq	%rbx, %r15
    4698: 49 c1 c7 17                  	rolq	$0x17, %r15
    469c: 4d 31 f7                     	xorq	%r14, %r15
    469f: 4d 89 d6                     	movq	%r10, %r14
    46a2: 49 31 ce                     	xorq	%rcx, %r14
    46a5: 49 21 de                     	andq	%rbx, %r14
    46a8: 49 31 ce                     	xorq	%rcx, %r14
    46ab: 48 03 95 28 fe ff ff         	addq	-0x1d8(%rbp), %rdx
    46b2: 4c 01 f2                     	addq	%r14, %rdx
    46b5: 49 be 3f 21 fb 98 c8 27 03 b0	movabsq	$-0x4ffcd8376704dec1, %r14 # imm = 0xB00327C898FB213F
    46bf: 49 01 d6                     	addq	%rdx, %r14
    46c2: 4d 01 fe                     	addq	%r15, %r14
    46c5: 4c 01 f6                     	addq	%r14, %rsi
    46c8: 4c 89 da                     	movq	%r11, %rdx
    46cb: 48 c1 c2 24                  	rolq	$0x24, %rdx
    46cf: 4d 89 df                     	movq	%r11, %r15
    46d2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    46d6: 49 31 d7                     	xorq	%rdx, %r15
    46d9: 4d 89 dc                     	movq	%r11, %r12
    46dc: 49 c1 c4 19                  	rolq	$0x19, %r12
    46e0: 4d 31 fc                     	xorq	%r15, %r12
    46e3: 4d 89 cf                     	movq	%r9, %r15
    46e6: 4d 09 c7                     	orq	%r8, %r15
    46e9: 4d 21 df                     	andq	%r11, %r15
    46ec: 4c 89 ca                     	movq	%r9, %rdx
    46ef: 4c 21 c2                     	andq	%r8, %rdx
    46f2: 4c 09 fa                     	orq	%r15, %rdx
    46f5: 49 89 f7                     	movq	%rsi, %r15
    46f8: 49 c1 c7 32                  	rolq	$0x32, %r15
    46fc: 4c 01 e2                     	addq	%r12, %rdx
    46ff: 49 89 f4                     	movq	%rsi, %r12
    4702: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4706: 4c 01 f2                     	addq	%r14, %rdx
    4709: 49 89 f6                     	movq	%rsi, %r14
    470c: 49 c1 c6 17                  	rolq	$0x17, %r14
    4710: 4d 31 fc                     	xorq	%r15, %r12
    4713: 4d 31 e6                     	xorq	%r12, %r14
    4716: 49 89 df                     	movq	%rbx, %r15
    4719: 4d 31 d7                     	xorq	%r10, %r15
    471c: 49 21 f7                     	andq	%rsi, %r15
    471f: 4d 31 d7                     	xorq	%r10, %r15
    4722: 48 03 8d 30 fe ff ff         	addq	-0x1d0(%rbp), %rcx
    4729: 4c 01 f9                     	addq	%r15, %rcx
    472c: 49 bf e4 0e ef be c7 7f 59 bf	movabsq	$-0x40a680384110f11c, %r15 # imm = 0xBF597FC7BEEF0EE4
    4736: 49 01 cf                     	addq	%rcx, %r15
    4739: 4d 01 f7                     	addq	%r14, %r15
    473c: 4d 01 f8                     	addq	%r15, %r8
    473f: 48 89 d1                     	movq	%rdx, %rcx
    4742: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4746: 49 89 d6                     	movq	%rdx, %r14
    4749: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    474d: 49 31 ce                     	xorq	%rcx, %r14
    4750: 49 89 d4                     	movq	%rdx, %r12
    4753: 49 c1 c4 19                  	rolq	$0x19, %r12
    4757: 4d 31 f4                     	xorq	%r14, %r12
    475a: 4d 89 de                     	movq	%r11, %r14
    475d: 4d 09 ce                     	orq	%r9, %r14
    4760: 49 21 d6                     	andq	%rdx, %r14
    4763: 4c 89 d9                     	movq	%r11, %rcx
    4766: 4c 21 c9                     	andq	%r9, %rcx
    4769: 4c 09 f1                     	orq	%r14, %rcx
    476c: 4c 01 e1                     	addq	%r12, %rcx
    476f: 4c 01 f9                     	addq	%r15, %rcx
    4772: 4d 89 c6                     	movq	%r8, %r14
    4775: 49 c1 c6 32                  	rolq	$0x32, %r14
    4779: 4d 89 c7                     	movq	%r8, %r15
    477c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4780: 4d 31 f7                     	xorq	%r14, %r15
    4783: 4d 89 c4                     	movq	%r8, %r12
    4786: 49 c1 c4 17                  	rolq	$0x17, %r12
    478a: 4d 31 fc                     	xorq	%r15, %r12
    478d: 49 89 f6                     	movq	%rsi, %r14
    4790: 49 31 de                     	xorq	%rbx, %r14
    4793: 4d 21 c6                     	andq	%r8, %r14
    4796: 4c 03 95 38 fe ff ff         	addq	-0x1c8(%rbp), %r10
    479d: 49 31 de                     	xorq	%rbx, %r14
    47a0: 4d 01 f2                     	addq	%r14, %r10
    47a3: 49 be c2 8f a8 3d f3 0b e0 c6	movabsq	$-0x391ff40cc257703e, %r14 # imm = 0xC6E00BF33DA88FC2
    47ad: 4d 01 d6                     	addq	%r10, %r14
    47b0: 4d 01 e6                     	addq	%r12, %r14
    47b3: 49 89 ca                     	movq	%rcx, %r10
    47b6: 49 c1 c2 24                  	rolq	$0x24, %r10
    47ba: 4d 01 f1                     	addq	%r14, %r9
    47bd: 49 89 cf                     	movq	%rcx, %r15
    47c0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    47c4: 4d 31 d7                     	xorq	%r10, %r15
    47c7: 49 89 cc                     	movq	%rcx, %r12
    47ca: 49 c1 c4 19                  	rolq	$0x19, %r12
    47ce: 4d 31 fc                     	xorq	%r15, %r12
    47d1: 49 89 d7                     	movq	%rdx, %r15
    47d4: 4d 09 df                     	orq	%r11, %r15
    47d7: 49 21 cf                     	andq	%rcx, %r15
    47da: 49 89 d2                     	movq	%rdx, %r10
    47dd: 4d 21 da                     	andq	%r11, %r10
    47e0: 4d 09 fa                     	orq	%r15, %r10
    47e3: 4d 01 e2                     	addq	%r12, %r10
    47e6: 4d 01 f2                     	addq	%r14, %r10
    47e9: 4d 89 ce                     	movq	%r9, %r14
    47ec: 49 c1 c6 32                  	rolq	$0x32, %r14
    47f0: 4d 89 cf                     	movq	%r9, %r15
    47f3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    47f7: 4d 31 f7                     	xorq	%r14, %r15
    47fa: 4d 89 cc                     	movq	%r9, %r12
    47fd: 49 c1 c4 17                  	rolq	$0x17, %r12
    4801: 4d 31 fc                     	xorq	%r15, %r12
    4804: 4d 89 c6                     	movq	%r8, %r14
    4807: 49 31 f6                     	xorq	%rsi, %r14
    480a: 4d 21 ce                     	andq	%r9, %r14
    480d: 49 31 f6                     	xorq	%rsi, %r14
    4810: 48 03 9d 40 fe ff ff         	addq	-0x1c0(%rbp), %rbx
    4817: 4c 01 f3                     	addq	%r14, %rbx
    481a: 49 be 25 a7 0a 93 47 91 a7 d5	movabsq	$-0x2a586eb86cf558db, %r14 # imm = 0xD5A79147930AA725
    4824: 49 01 de                     	addq	%rbx, %r14
    4827: 4c 89 d3                     	movq	%r10, %rbx
    482a: 48 c1 c3 24                  	rolq	$0x24, %rbx
    482e: 4d 01 e6                     	addq	%r12, %r14
    4831: 4d 89 d7                     	movq	%r10, %r15
    4834: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4838: 4d 01 f3                     	addq	%r14, %r11
    483b: 4d 89 d4                     	movq	%r10, %r12
    483e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4842: 49 31 df                     	xorq	%rbx, %r15
    4845: 4d 31 fc                     	xorq	%r15, %r12
    4848: 49 89 cf                     	movq	%rcx, %r15
    484b: 49 09 d7                     	orq	%rdx, %r15
    484e: 4d 21 d7                     	andq	%r10, %r15
    4851: 48 89 cb                     	movq	%rcx, %rbx
    4854: 48 21 d3                     	andq	%rdx, %rbx
    4857: 4c 09 fb                     	orq	%r15, %rbx
    485a: 4c 01 e3                     	addq	%r12, %rbx
    485d: 4d 89 df                     	movq	%r11, %r15
    4860: 49 c1 c7 32                  	rolq	$0x32, %r15
    4864: 4c 01 f3                     	addq	%r14, %rbx
    4867: 4d 89 de                     	movq	%r11, %r14
    486a: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    486e: 4d 31 fe                     	xorq	%r15, %r14
    4871: 4d 89 df                     	movq	%r11, %r15
    4874: 49 c1 c7 17                  	rolq	$0x17, %r15
    4878: 4d 31 f7                     	xorq	%r14, %r15
    487b: 4d 89 ce                     	movq	%r9, %r14
    487e: 4d 31 c6                     	xorq	%r8, %r14
    4881: 4d 21 de                     	andq	%r11, %r14
    4884: 4d 31 c6                     	xorq	%r8, %r14
    4887: 48 03 b5 48 fe ff ff         	addq	-0x1b8(%rbp), %rsi
    488e: 4c 01 f6                     	addq	%r14, %rsi
    4891: 49 be 6f 82 03 e0 51 63 ca 06	movabsq	$0x6ca6351e003826f, %r14 # imm = 0x6CA6351E003826F
    489b: 49 01 f6                     	addq	%rsi, %r14
    489e: 4d 01 fe                     	addq	%r15, %r14
    48a1: 4c 01 f2                     	addq	%r14, %rdx
    48a4: 48 89 de                     	movq	%rbx, %rsi
    48a7: 48 c1 c6 24                  	rolq	$0x24, %rsi
    48ab: 49 89 df                     	movq	%rbx, %r15
    48ae: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    48b2: 49 31 f7                     	xorq	%rsi, %r15
    48b5: 49 89 dc                     	movq	%rbx, %r12
    48b8: 49 c1 c4 19                  	rolq	$0x19, %r12
    48bc: 4d 31 fc                     	xorq	%r15, %r12
    48bf: 4d 89 d7                     	movq	%r10, %r15
    48c2: 49 09 cf                     	orq	%rcx, %r15
    48c5: 49 21 df                     	andq	%rbx, %r15
    48c8: 4c 89 d6                     	movq	%r10, %rsi
    48cb: 48 21 ce                     	andq	%rcx, %rsi
    48ce: 4c 09 fe                     	orq	%r15, %rsi
    48d1: 49 89 d7                     	movq	%rdx, %r15
    48d4: 49 c1 c7 32                  	rolq	$0x32, %r15
    48d8: 4c 01 e6                     	addq	%r12, %rsi
    48db: 49 89 d4                     	movq	%rdx, %r12
    48de: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    48e2: 4c 01 f6                     	addq	%r14, %rsi
    48e5: 49 89 d6                     	movq	%rdx, %r14
    48e8: 49 c1 c6 17                  	rolq	$0x17, %r14
    48ec: 4d 31 fc                     	xorq	%r15, %r12
    48ef: 4d 31 e6                     	xorq	%r12, %r14
    48f2: 4d 89 df                     	movq	%r11, %r15
    48f5: 4d 31 cf                     	xorq	%r9, %r15
    48f8: 49 21 d7                     	andq	%rdx, %r15
    48fb: 4d 31 cf                     	xorq	%r9, %r15
    48fe: 4c 03 85 50 fe ff ff         	addq	-0x1b0(%rbp), %r8
    4905: 4d 01 f8                     	addq	%r15, %r8
    4908: 49 bf 70 6e 0e 0a 67 29 29 14	movabsq	$0x142929670a0e6e70, %r15 # imm = 0x142929670A0E6E70
    4912: 4d 01 c7                     	addq	%r8, %r15
    4915: 4d 01 f7                     	addq	%r14, %r15
    4918: 4c 01 f9                     	addq	%r15, %rcx
    491b: 49 89 f0                     	movq	%rsi, %r8
    491e: 49 c1 c0 24                  	rolq	$0x24, %r8
    4922: 49 89 f6                     	movq	%rsi, %r14
    4925: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4929: 4d 31 c6                     	xorq	%r8, %r14
    492c: 49 89 f4                     	movq	%rsi, %r12
    492f: 49 c1 c4 19                  	rolq	$0x19, %r12
    4933: 4d 31 f4                     	xorq	%r14, %r12
    4936: 49 89 de                     	movq	%rbx, %r14
    4939: 4d 09 d6                     	orq	%r10, %r14
    493c: 49 21 f6                     	andq	%rsi, %r14
    493f: 49 89 d8                     	movq	%rbx, %r8
    4942: 4d 21 d0                     	andq	%r10, %r8
    4945: 4d 09 f0                     	orq	%r14, %r8
    4948: 4d 01 e0                     	addq	%r12, %r8
    494b: 4d 01 f8                     	addq	%r15, %r8
    494e: 49 89 ce                     	movq	%rcx, %r14
    4951: 49 c1 c6 32                  	rolq	$0x32, %r14
    4955: 49 89 cf                     	movq	%rcx, %r15
    4958: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    495c: 4d 31 f7                     	xorq	%r14, %r15
    495f: 49 89 cc                     	movq	%rcx, %r12
    4962: 49 c1 c4 17                  	rolq	$0x17, %r12
    4966: 4d 31 fc                     	xorq	%r15, %r12
    4969: 49 89 d6                     	movq	%rdx, %r14
    496c: 4d 31 de                     	xorq	%r11, %r14
    496f: 49 21 ce                     	andq	%rcx, %r14
    4972: 4c 03 8d 58 fe ff ff         	addq	-0x1a8(%rbp), %r9
    4979: 4d 31 de                     	xorq	%r11, %r14
    497c: 4d 01 f1                     	addq	%r14, %r9
    497f: 49 be fc 2f d2 46 85 0a b7 27	movabsq	$0x27b70a8546d22ffc, %r14 # imm = 0x27B70A8546D22FFC
    4989: 4d 01 ce                     	addq	%r9, %r14
    498c: 4d 01 e6                     	addq	%r12, %r14
    498f: 4d 89 c1                     	movq	%r8, %r9
    4992: 49 c1 c1 24                  	rolq	$0x24, %r9
    4996: 4d 01 f2                     	addq	%r14, %r10
    4999: 4d 89 c7                     	movq	%r8, %r15
    499c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    49a0: 4d 31 cf                     	xorq	%r9, %r15
    49a3: 4d 89 c4                     	movq	%r8, %r12
    49a6: 49 c1 c4 19                  	rolq	$0x19, %r12
    49aa: 4d 31 fc                     	xorq	%r15, %r12
    49ad: 49 89 f7                     	movq	%rsi, %r15
    49b0: 49 09 df                     	orq	%rbx, %r15
    49b3: 4d 21 c7                     	andq	%r8, %r15
    49b6: 49 89 f1                     	movq	%rsi, %r9
    49b9: 49 21 d9                     	andq	%rbx, %r9
    49bc: 4d 09 f9                     	orq	%r15, %r9
    49bf: 4d 01 e1                     	addq	%r12, %r9
    49c2: 4d 01 f1                     	addq	%r14, %r9
    49c5: 4d 89 d6                     	movq	%r10, %r14
    49c8: 49 c1 c6 32                  	rolq	$0x32, %r14
    49cc: 4d 89 d7                     	movq	%r10, %r15
    49cf: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    49d3: 4d 31 f7                     	xorq	%r14, %r15
    49d6: 4d 89 d4                     	movq	%r10, %r12
    49d9: 49 c1 c4 17                  	rolq	$0x17, %r12
    49dd: 4d 31 fc                     	xorq	%r15, %r12
    49e0: 49 89 ce                     	movq	%rcx, %r14
    49e3: 49 31 d6                     	xorq	%rdx, %r14
    49e6: 4d 21 d6                     	andq	%r10, %r14
    49e9: 49 31 d6                     	xorq	%rdx, %r14
    49ec: 4c 03 9d 60 fe ff ff         	addq	-0x1a0(%rbp), %r11
    49f3: 4d 01 f3                     	addq	%r14, %r11
    49f6: 49 be 26 c9 26 5c 38 21 1b 2e	movabsq	$0x2e1b21385c26c926, %r14 # imm = 0x2E1B21385C26C926
    4a00: 4d 01 de                     	addq	%r11, %r14
    4a03: 4d 89 cb                     	movq	%r9, %r11
    4a06: 49 c1 c3 24                  	rolq	$0x24, %r11
    4a0a: 4d 01 e6                     	addq	%r12, %r14
    4a0d: 4d 89 cf                     	movq	%r9, %r15
    4a10: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4a14: 4c 01 f3                     	addq	%r14, %rbx
    4a17: 4d 89 cc                     	movq	%r9, %r12
    4a1a: 49 c1 c4 19                  	rolq	$0x19, %r12
    4a1e: 4d 31 df                     	xorq	%r11, %r15
    4a21: 4d 31 fc                     	xorq	%r15, %r12
    4a24: 4d 89 c7                     	movq	%r8, %r15
    4a27: 49 09 f7                     	orq	%rsi, %r15
    4a2a: 4d 21 cf                     	andq	%r9, %r15
    4a2d: 4d 89 c3                     	movq	%r8, %r11
    4a30: 49 21 f3                     	andq	%rsi, %r11
    4a33: 4d 09 fb                     	orq	%r15, %r11
    4a36: 4d 01 e3                     	addq	%r12, %r11
    4a39: 49 89 df                     	movq	%rbx, %r15
    4a3c: 49 c1 c7 32                  	rolq	$0x32, %r15
    4a40: 4d 01 f3                     	addq	%r14, %r11
    4a43: 49 89 de                     	movq	%rbx, %r14
    4a46: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4a4a: 4d 31 fe                     	xorq	%r15, %r14
    4a4d: 49 89 df                     	movq	%rbx, %r15
    4a50: 49 c1 c7 17                  	rolq	$0x17, %r15
    4a54: 4d 31 f7                     	xorq	%r14, %r15
    4a57: 4d 89 d6                     	movq	%r10, %r14
    4a5a: 49 31 ce                     	xorq	%rcx, %r14
    4a5d: 49 21 de                     	andq	%rbx, %r14
    4a60: 49 31 ce                     	xorq	%rcx, %r14
    4a63: 48 03 95 68 fe ff ff         	addq	-0x198(%rbp), %rdx
    4a6a: 4c 01 f2                     	addq	%r14, %rdx
    4a6d: 49 be ed 2a c4 5a fc 6d 2c 4d	movabsq	$0x4d2c6dfc5ac42aed, %r14 # imm = 0x4D2C6DFC5AC42AED
    4a77: 49 01 d6                     	addq	%rdx, %r14
    4a7a: 4d 01 fe                     	addq	%r15, %r14
    4a7d: 4c 01 f6                     	addq	%r14, %rsi
    4a80: 4c 89 da                     	movq	%r11, %rdx
    4a83: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4a87: 4d 89 df                     	movq	%r11, %r15
    4a8a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4a8e: 49 31 d7                     	xorq	%rdx, %r15
    4a91: 4d 89 dc                     	movq	%r11, %r12
    4a94: 49 c1 c4 19                  	rolq	$0x19, %r12
    4a98: 4d 31 fc                     	xorq	%r15, %r12
    4a9b: 4d 89 cf                     	movq	%r9, %r15
    4a9e: 4d 09 c7                     	orq	%r8, %r15
    4aa1: 4d 21 df                     	andq	%r11, %r15
    4aa4: 4c 89 ca                     	movq	%r9, %rdx
    4aa7: 4c 21 c2                     	andq	%r8, %rdx
    4aaa: 4c 09 fa                     	orq	%r15, %rdx
    4aad: 49 89 f7                     	movq	%rsi, %r15
    4ab0: 49 c1 c7 32                  	rolq	$0x32, %r15
    4ab4: 4c 01 e2                     	addq	%r12, %rdx
    4ab7: 49 89 f4                     	movq	%rsi, %r12
    4aba: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4abe: 4c 01 f2                     	addq	%r14, %rdx
    4ac1: 49 89 f6                     	movq	%rsi, %r14
    4ac4: 49 c1 c6 17                  	rolq	$0x17, %r14
    4ac8: 4d 31 fc                     	xorq	%r15, %r12
    4acb: 4d 31 e6                     	xorq	%r12, %r14
    4ace: 49 89 df                     	movq	%rbx, %r15
    4ad1: 4d 31 d7                     	xorq	%r10, %r15
    4ad4: 49 21 f7                     	andq	%rsi, %r15
    4ad7: 4d 31 d7                     	xorq	%r10, %r15
    4ada: 48 03 8d 70 fe ff ff         	addq	-0x190(%rbp), %rcx
    4ae1: 4c 01 f9                     	addq	%r15, %rcx
    4ae4: 49 bf df b3 95 9d 13 0d 38 53	movabsq	$0x53380d139d95b3df, %r15 # imm = 0x53380D139D95B3DF
    4aee: 49 01 cf                     	addq	%rcx, %r15
    4af1: 4d 01 f7                     	addq	%r14, %r15
    4af4: 4d 01 f8                     	addq	%r15, %r8
    4af7: 48 89 d1                     	movq	%rdx, %rcx
    4afa: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4afe: 49 89 d6                     	movq	%rdx, %r14
    4b01: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4b05: 49 31 ce                     	xorq	%rcx, %r14
    4b08: 49 89 d4                     	movq	%rdx, %r12
    4b0b: 49 c1 c4 19                  	rolq	$0x19, %r12
    4b0f: 4d 31 f4                     	xorq	%r14, %r12
    4b12: 4d 89 de                     	movq	%r11, %r14
    4b15: 4d 09 ce                     	orq	%r9, %r14
    4b18: 49 21 d6                     	andq	%rdx, %r14
    4b1b: 4c 89 d9                     	movq	%r11, %rcx
    4b1e: 4c 21 c9                     	andq	%r9, %rcx
    4b21: 4c 09 f1                     	orq	%r14, %rcx
    4b24: 4c 01 e1                     	addq	%r12, %rcx
    4b27: 4c 01 f9                     	addq	%r15, %rcx
    4b2a: 4d 89 c6                     	movq	%r8, %r14
    4b2d: 49 c1 c6 32                  	rolq	$0x32, %r14
    4b31: 4d 89 c7                     	movq	%r8, %r15
    4b34: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4b38: 4d 31 f7                     	xorq	%r14, %r15
    4b3b: 4d 89 c4                     	movq	%r8, %r12
    4b3e: 49 c1 c4 17                  	rolq	$0x17, %r12
    4b42: 4d 31 fc                     	xorq	%r15, %r12
    4b45: 49 89 f6                     	movq	%rsi, %r14
    4b48: 49 31 de                     	xorq	%rbx, %r14
    4b4b: 4d 21 c6                     	andq	%r8, %r14
    4b4e: 4c 03 95 78 fe ff ff         	addq	-0x188(%rbp), %r10
    4b55: 49 31 de                     	xorq	%rbx, %r14
    4b58: 4d 01 f2                     	addq	%r14, %r10
    4b5b: 49 be de 63 af 8b 54 73 0a 65	movabsq	$0x650a73548baf63de, %r14 # imm = 0x650A73548BAF63DE
    4b65: 4d 01 d6                     	addq	%r10, %r14
    4b68: 4d 01 e6                     	addq	%r12, %r14
    4b6b: 49 89 ca                     	movq	%rcx, %r10
    4b6e: 49 c1 c2 24                  	rolq	$0x24, %r10
    4b72: 4d 01 f1                     	addq	%r14, %r9
    4b75: 49 89 cf                     	movq	%rcx, %r15
    4b78: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4b7c: 4d 31 d7                     	xorq	%r10, %r15
    4b7f: 49 89 cc                     	movq	%rcx, %r12
    4b82: 49 c1 c4 19                  	rolq	$0x19, %r12
    4b86: 4d 31 fc                     	xorq	%r15, %r12
    4b89: 49 89 d7                     	movq	%rdx, %r15
    4b8c: 4d 09 df                     	orq	%r11, %r15
    4b8f: 49 21 cf                     	andq	%rcx, %r15
    4b92: 49 89 d2                     	movq	%rdx, %r10
    4b95: 4d 21 da                     	andq	%r11, %r10
    4b98: 4d 09 fa                     	orq	%r15, %r10
    4b9b: 4d 01 e2                     	addq	%r12, %r10
    4b9e: 4d 01 f2                     	addq	%r14, %r10
    4ba1: 4d 89 ce                     	movq	%r9, %r14
    4ba4: 49 c1 c6 32                  	rolq	$0x32, %r14
    4ba8: 4d 89 cf                     	movq	%r9, %r15
    4bab: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4baf: 4d 31 f7                     	xorq	%r14, %r15
    4bb2: 4d 89 cc                     	movq	%r9, %r12
    4bb5: 49 c1 c4 17                  	rolq	$0x17, %r12
    4bb9: 4d 31 fc                     	xorq	%r15, %r12
    4bbc: 4d 89 c6                     	movq	%r8, %r14
    4bbf: 49 31 f6                     	xorq	%rsi, %r14
    4bc2: 4d 21 ce                     	andq	%r9, %r14
    4bc5: 49 31 f6                     	xorq	%rsi, %r14
    4bc8: 48 03 9d 80 fe ff ff         	addq	-0x180(%rbp), %rbx
    4bcf: 4c 01 f3                     	addq	%r14, %rbx
    4bd2: 49 be a8 b2 77 3c bb 0a 6a 76	movabsq	$0x766a0abb3c77b2a8, %r14 # imm = 0x766A0ABB3C77B2A8
    4bdc: 49 01 de                     	addq	%rbx, %r14
    4bdf: 4c 89 d3                     	movq	%r10, %rbx
    4be2: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4be6: 4d 01 e6                     	addq	%r12, %r14
    4be9: 4d 89 d7                     	movq	%r10, %r15
    4bec: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4bf0: 4d 01 f3                     	addq	%r14, %r11
    4bf3: 4d 89 d4                     	movq	%r10, %r12
    4bf6: 49 c1 c4 19                  	rolq	$0x19, %r12
    4bfa: 49 31 df                     	xorq	%rbx, %r15
    4bfd: 4d 31 fc                     	xorq	%r15, %r12
    4c00: 49 89 cf                     	movq	%rcx, %r15
    4c03: 49 09 d7                     	orq	%rdx, %r15
    4c06: 4d 21 d7                     	andq	%r10, %r15
    4c09: 48 89 cb                     	movq	%rcx, %rbx
    4c0c: 48 21 d3                     	andq	%rdx, %rbx
    4c0f: 4c 09 fb                     	orq	%r15, %rbx
    4c12: 4c 01 e3                     	addq	%r12, %rbx
    4c15: 4d 89 df                     	movq	%r11, %r15
    4c18: 49 c1 c7 32                  	rolq	$0x32, %r15
    4c1c: 4c 01 f3                     	addq	%r14, %rbx
    4c1f: 4d 89 de                     	movq	%r11, %r14
    4c22: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4c26: 4d 31 fe                     	xorq	%r15, %r14
    4c29: 4d 89 df                     	movq	%r11, %r15
    4c2c: 49 c1 c7 17                  	rolq	$0x17, %r15
    4c30: 4d 31 f7                     	xorq	%r14, %r15
    4c33: 4d 89 ce                     	movq	%r9, %r14
    4c36: 4d 31 c6                     	xorq	%r8, %r14
    4c39: 4d 21 de                     	andq	%r11, %r14
    4c3c: 4d 31 c6                     	xorq	%r8, %r14
    4c3f: 48 03 b5 88 fe ff ff         	addq	-0x178(%rbp), %rsi
    4c46: 4c 01 f6                     	addq	%r14, %rsi
    4c49: 49 be e6 ae ed 47 2e c9 c2 81	movabsq	$-0x7e3d36d1b812511a, %r14 # imm = 0x81C2C92E47EDAEE6
    4c53: 49 01 f6                     	addq	%rsi, %r14
    4c56: 4d 01 fe                     	addq	%r15, %r14
    4c59: 4c 01 f2                     	addq	%r14, %rdx
    4c5c: 48 89 de                     	movq	%rbx, %rsi
    4c5f: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4c63: 49 89 df                     	movq	%rbx, %r15
    4c66: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4c6a: 49 31 f7                     	xorq	%rsi, %r15
    4c6d: 49 89 dc                     	movq	%rbx, %r12
    4c70: 49 c1 c4 19                  	rolq	$0x19, %r12
    4c74: 4d 31 fc                     	xorq	%r15, %r12
    4c77: 4d 89 d7                     	movq	%r10, %r15
    4c7a: 49 09 cf                     	orq	%rcx, %r15
    4c7d: 49 21 df                     	andq	%rbx, %r15
    4c80: 4c 89 d6                     	movq	%r10, %rsi
    4c83: 48 21 ce                     	andq	%rcx, %rsi
    4c86: 4c 09 fe                     	orq	%r15, %rsi
    4c89: 49 89 d7                     	movq	%rdx, %r15
    4c8c: 49 c1 c7 32                  	rolq	$0x32, %r15
    4c90: 4c 01 e6                     	addq	%r12, %rsi
    4c93: 49 89 d4                     	movq	%rdx, %r12
    4c96: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4c9a: 4c 01 f6                     	addq	%r14, %rsi
    4c9d: 49 89 d6                     	movq	%rdx, %r14
    4ca0: 49 c1 c6 17                  	rolq	$0x17, %r14
    4ca4: 4d 31 fc                     	xorq	%r15, %r12
    4ca7: 4d 31 e6                     	xorq	%r12, %r14
    4caa: 4d 89 df                     	movq	%r11, %r15
    4cad: 4d 31 cf                     	xorq	%r9, %r15
    4cb0: 49 21 d7                     	andq	%rdx, %r15
    4cb3: 4d 31 cf                     	xorq	%r9, %r15
    4cb6: 4c 03 85 90 fe ff ff         	addq	-0x170(%rbp), %r8
    4cbd: 4d 01 f8                     	addq	%r15, %r8
    4cc0: 49 bf 3b 35 82 14 85 2c 72 92	movabsq	$-0x6d8dd37aeb7dcac5, %r15 # imm = 0x92722C851482353B
    4cca: 4d 01 c7                     	addq	%r8, %r15
    4ccd: 4d 01 f7                     	addq	%r14, %r15
    4cd0: 4c 01 f9                     	addq	%r15, %rcx
    4cd3: 49 89 f0                     	movq	%rsi, %r8
    4cd6: 49 c1 c0 24                  	rolq	$0x24, %r8
    4cda: 49 89 f6                     	movq	%rsi, %r14
    4cdd: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4ce1: 4d 31 c6                     	xorq	%r8, %r14
    4ce4: 49 89 f4                     	movq	%rsi, %r12
    4ce7: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ceb: 4d 31 f4                     	xorq	%r14, %r12
    4cee: 49 89 de                     	movq	%rbx, %r14
    4cf1: 4d 09 d6                     	orq	%r10, %r14
    4cf4: 49 21 f6                     	andq	%rsi, %r14
    4cf7: 49 89 d8                     	movq	%rbx, %r8
    4cfa: 4d 21 d0                     	andq	%r10, %r8
    4cfd: 4d 09 f0                     	orq	%r14, %r8
    4d00: 4d 01 e0                     	addq	%r12, %r8
    4d03: 4d 01 f8                     	addq	%r15, %r8
    4d06: 49 89 ce                     	movq	%rcx, %r14
    4d09: 49 c1 c6 32                  	rolq	$0x32, %r14
    4d0d: 49 89 cf                     	movq	%rcx, %r15
    4d10: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4d14: 4d 31 f7                     	xorq	%r14, %r15
    4d17: 49 89 cc                     	movq	%rcx, %r12
    4d1a: 49 c1 c4 17                  	rolq	$0x17, %r12
    4d1e: 4d 31 fc                     	xorq	%r15, %r12
    4d21: 49 89 d6                     	movq	%rdx, %r14
    4d24: 4d 31 de                     	xorq	%r11, %r14
    4d27: 49 21 ce                     	andq	%rcx, %r14
    4d2a: 4c 03 8d 98 fe ff ff         	addq	-0x168(%rbp), %r9
    4d31: 4d 31 de                     	xorq	%r11, %r14
    4d34: 4d 01 f1                     	addq	%r14, %r9
    4d37: 49 be 64 03 f1 4c a1 e8 bf a2	movabsq	$-0x5d40175eb30efc9c, %r14 # imm = 0xA2BFE8A14CF10364
    4d41: 4d 01 ce                     	addq	%r9, %r14
    4d44: 4d 01 e6                     	addq	%r12, %r14
    4d47: 4d 89 c1                     	movq	%r8, %r9
    4d4a: 49 c1 c1 24                  	rolq	$0x24, %r9
    4d4e: 4d 01 f2                     	addq	%r14, %r10
    4d51: 4d 89 c7                     	movq	%r8, %r15
    4d54: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4d58: 4d 31 cf                     	xorq	%r9, %r15
    4d5b: 4d 89 c4                     	movq	%r8, %r12
    4d5e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4d62: 4d 31 fc                     	xorq	%r15, %r12
    4d65: 49 89 f7                     	movq	%rsi, %r15
    4d68: 49 09 df                     	orq	%rbx, %r15
    4d6b: 4d 21 c7                     	andq	%r8, %r15
    4d6e: 49 89 f1                     	movq	%rsi, %r9
    4d71: 49 21 d9                     	andq	%rbx, %r9
    4d74: 4d 09 f9                     	orq	%r15, %r9
    4d77: 4d 01 e1                     	addq	%r12, %r9
    4d7a: 4d 01 f1                     	addq	%r14, %r9
    4d7d: 4d 89 d6                     	movq	%r10, %r14
    4d80: 49 c1 c6 32                  	rolq	$0x32, %r14
    4d84: 4d 89 d7                     	movq	%r10, %r15
    4d87: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4d8b: 4d 31 f7                     	xorq	%r14, %r15
    4d8e: 4d 89 d4                     	movq	%r10, %r12
    4d91: 49 c1 c4 17                  	rolq	$0x17, %r12
    4d95: 4d 31 fc                     	xorq	%r15, %r12
    4d98: 49 89 ce                     	movq	%rcx, %r14
    4d9b: 49 31 d6                     	xorq	%rdx, %r14
    4d9e: 4d 21 d6                     	andq	%r10, %r14
    4da1: 49 31 d6                     	xorq	%rdx, %r14
    4da4: 4c 03 9d a0 fe ff ff         	addq	-0x160(%rbp), %r11
    4dab: 4d 01 f3                     	addq	%r14, %r11
    4dae: 49 be 01 30 42 bc 4b 66 1a a8	movabsq	$-0x57e599b443bdcfff, %r14 # imm = 0xA81A664BBC423001
    4db8: 4d 01 de                     	addq	%r11, %r14
    4dbb: 4d 89 cb                     	movq	%r9, %r11
    4dbe: 49 c1 c3 24                  	rolq	$0x24, %r11
    4dc2: 4d 01 e6                     	addq	%r12, %r14
    4dc5: 4d 89 cf                     	movq	%r9, %r15
    4dc8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4dcc: 4c 01 f3                     	addq	%r14, %rbx
    4dcf: 4d 89 cc                     	movq	%r9, %r12
    4dd2: 49 c1 c4 19                  	rolq	$0x19, %r12
    4dd6: 4d 31 df                     	xorq	%r11, %r15
    4dd9: 4d 31 fc                     	xorq	%r15, %r12
    4ddc: 4d 89 c7                     	movq	%r8, %r15
    4ddf: 49 09 f7                     	orq	%rsi, %r15
    4de2: 4d 21 cf                     	andq	%r9, %r15
    4de5: 4d 89 c3                     	movq	%r8, %r11
    4de8: 49 21 f3                     	andq	%rsi, %r11
    4deb: 4d 09 fb                     	orq	%r15, %r11
    4dee: 4d 01 e3                     	addq	%r12, %r11
    4df1: 49 89 df                     	movq	%rbx, %r15
    4df4: 49 c1 c7 32                  	rolq	$0x32, %r15
    4df8: 4d 01 f3                     	addq	%r14, %r11
    4dfb: 49 89 de                     	movq	%rbx, %r14
    4dfe: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4e02: 4d 31 fe                     	xorq	%r15, %r14
    4e05: 49 89 df                     	movq	%rbx, %r15
    4e08: 49 c1 c7 17                  	rolq	$0x17, %r15
    4e0c: 4d 31 f7                     	xorq	%r14, %r15
    4e0f: 4d 89 d6                     	movq	%r10, %r14
    4e12: 49 31 ce                     	xorq	%rcx, %r14
    4e15: 49 21 de                     	andq	%rbx, %r14
    4e18: 49 31 ce                     	xorq	%rcx, %r14
    4e1b: 48 03 95 a8 fe ff ff         	addq	-0x158(%rbp), %rdx
    4e22: 4c 01 f2                     	addq	%r14, %rdx
    4e25: 49 be 91 97 f8 d0 70 8b 4b c2	movabsq	$-0x3db4748f2f07686f, %r14 # imm = 0xC24B8B70D0F89791
    4e2f: 49 01 d6                     	addq	%rdx, %r14
    4e32: 4d 01 fe                     	addq	%r15, %r14
    4e35: 4c 01 f6                     	addq	%r14, %rsi
    4e38: 4c 89 da                     	movq	%r11, %rdx
    4e3b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4e3f: 4d 89 df                     	movq	%r11, %r15
    4e42: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4e46: 49 31 d7                     	xorq	%rdx, %r15
    4e49: 4d 89 dc                     	movq	%r11, %r12
    4e4c: 49 c1 c4 19                  	rolq	$0x19, %r12
    4e50: 4d 31 fc                     	xorq	%r15, %r12
    4e53: 4d 89 cf                     	movq	%r9, %r15
    4e56: 4d 09 c7                     	orq	%r8, %r15
    4e59: 4d 21 df                     	andq	%r11, %r15
    4e5c: 4c 89 ca                     	movq	%r9, %rdx
    4e5f: 4c 21 c2                     	andq	%r8, %rdx
    4e62: 4c 09 fa                     	orq	%r15, %rdx
    4e65: 49 89 f7                     	movq	%rsi, %r15
    4e68: 49 c1 c7 32                  	rolq	$0x32, %r15
    4e6c: 4c 01 e2                     	addq	%r12, %rdx
    4e6f: 49 89 f4                     	movq	%rsi, %r12
    4e72: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4e76: 4c 01 f2                     	addq	%r14, %rdx
    4e79: 49 89 f6                     	movq	%rsi, %r14
    4e7c: 49 c1 c6 17                  	rolq	$0x17, %r14
    4e80: 4d 31 fc                     	xorq	%r15, %r12
    4e83: 4d 31 e6                     	xorq	%r12, %r14
    4e86: 49 89 df                     	movq	%rbx, %r15
    4e89: 4d 31 d7                     	xorq	%r10, %r15
    4e8c: 49 21 f7                     	andq	%rsi, %r15
    4e8f: 4d 31 d7                     	xorq	%r10, %r15
    4e92: 48 03 8d b0 fe ff ff         	addq	-0x150(%rbp), %rcx
    4e99: 4c 01 f9                     	addq	%r15, %rcx
    4e9c: 49 bf 30 be 54 06 a3 51 6c c7	movabsq	$-0x3893ae5cf9ab41d0, %r15 # imm = 0xC76C51A30654BE30
    4ea6: 49 01 cf                     	addq	%rcx, %r15
    4ea9: 4d 01 f7                     	addq	%r14, %r15
    4eac: 4d 01 f8                     	addq	%r15, %r8
    4eaf: 48 89 d1                     	movq	%rdx, %rcx
    4eb2: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4eb6: 49 89 d6                     	movq	%rdx, %r14
    4eb9: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4ebd: 49 31 ce                     	xorq	%rcx, %r14
    4ec0: 49 89 d4                     	movq	%rdx, %r12
    4ec3: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ec7: 4d 31 f4                     	xorq	%r14, %r12
    4eca: 4d 89 de                     	movq	%r11, %r14
    4ecd: 4d 09 ce                     	orq	%r9, %r14
    4ed0: 49 21 d6                     	andq	%rdx, %r14
    4ed3: 4c 89 d9                     	movq	%r11, %rcx
    4ed6: 4c 21 c9                     	andq	%r9, %rcx
    4ed9: 4c 09 f1                     	orq	%r14, %rcx
    4edc: 4c 01 e1                     	addq	%r12, %rcx
    4edf: 4c 01 f9                     	addq	%r15, %rcx
    4ee2: 4d 89 c6                     	movq	%r8, %r14
    4ee5: 49 c1 c6 32                  	rolq	$0x32, %r14
    4ee9: 4d 89 c7                     	movq	%r8, %r15
    4eec: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4ef0: 4d 31 f7                     	xorq	%r14, %r15
    4ef3: 4d 89 c4                     	movq	%r8, %r12
    4ef6: 49 c1 c4 17                  	rolq	$0x17, %r12
    4efa: 4d 31 fc                     	xorq	%r15, %r12
    4efd: 49 89 f6                     	movq	%rsi, %r14
    4f00: 49 31 de                     	xorq	%rbx, %r14
    4f03: 4d 21 c6                     	andq	%r8, %r14
    4f06: 4c 03 95 b8 fe ff ff         	addq	-0x148(%rbp), %r10
    4f0d: 49 31 de                     	xorq	%rbx, %r14
    4f10: 4d 01 f2                     	addq	%r14, %r10
    4f13: 49 be 18 52 ef d6 19 e8 92 d1	movabsq	$-0x2e6d17e62910ade8, %r14 # imm = 0xD192E819D6EF5218
    4f1d: 4d 01 d6                     	addq	%r10, %r14
    4f20: 4d 01 e6                     	addq	%r12, %r14
    4f23: 49 89 ca                     	movq	%rcx, %r10
    4f26: 49 c1 c2 24                  	rolq	$0x24, %r10
    4f2a: 4d 01 f1                     	addq	%r14, %r9
    4f2d: 49 89 cf                     	movq	%rcx, %r15
    4f30: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4f34: 4d 31 d7                     	xorq	%r10, %r15
    4f37: 49 89 cc                     	movq	%rcx, %r12
    4f3a: 49 c1 c4 19                  	rolq	$0x19, %r12
    4f3e: 4d 31 fc                     	xorq	%r15, %r12
    4f41: 49 89 d7                     	movq	%rdx, %r15
    4f44: 4d 09 df                     	orq	%r11, %r15
    4f47: 49 21 cf                     	andq	%rcx, %r15
    4f4a: 49 89 d2                     	movq	%rdx, %r10
    4f4d: 4d 21 da                     	andq	%r11, %r10
    4f50: 4d 09 fa                     	orq	%r15, %r10
    4f53: 4d 01 e2                     	addq	%r12, %r10
    4f56: 4d 01 f2                     	addq	%r14, %r10
    4f59: 4d 89 ce                     	movq	%r9, %r14
    4f5c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4f60: 4d 89 cf                     	movq	%r9, %r15
    4f63: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4f67: 4d 31 f7                     	xorq	%r14, %r15
    4f6a: 4d 89 cc                     	movq	%r9, %r12
    4f6d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4f71: 4d 31 fc                     	xorq	%r15, %r12
    4f74: 4d 89 c6                     	movq	%r8, %r14
    4f77: 49 31 f6                     	xorq	%rsi, %r14
    4f7a: 4d 21 ce                     	andq	%r9, %r14
    4f7d: 49 31 f6                     	xorq	%rsi, %r14
    4f80: 48 03 9d c0 fe ff ff         	addq	-0x140(%rbp), %rbx
    4f87: 4c 01 f3                     	addq	%r14, %rbx
    4f8a: 49 be 10 a9 65 55 24 06 99 d6	movabsq	$-0x2966f9dbaa9a56f0, %r14 # imm = 0xD69906245565A910
    4f94: 49 01 de                     	addq	%rbx, %r14
    4f97: 4c 89 d3                     	movq	%r10, %rbx
    4f9a: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4f9e: 4d 01 e6                     	addq	%r12, %r14
    4fa1: 4d 89 d7                     	movq	%r10, %r15
    4fa4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4fa8: 4d 01 f3                     	addq	%r14, %r11
    4fab: 4d 89 d4                     	movq	%r10, %r12
    4fae: 49 c1 c4 19                  	rolq	$0x19, %r12
    4fb2: 49 31 df                     	xorq	%rbx, %r15
    4fb5: 4d 31 fc                     	xorq	%r15, %r12
    4fb8: 49 89 cf                     	movq	%rcx, %r15
    4fbb: 49 09 d7                     	orq	%rdx, %r15
    4fbe: 4d 21 d7                     	andq	%r10, %r15
    4fc1: 48 89 cb                     	movq	%rcx, %rbx
    4fc4: 48 21 d3                     	andq	%rdx, %rbx
    4fc7: 4c 09 fb                     	orq	%r15, %rbx
    4fca: 4c 01 e3                     	addq	%r12, %rbx
    4fcd: 4d 89 df                     	movq	%r11, %r15
    4fd0: 49 c1 c7 32                  	rolq	$0x32, %r15
    4fd4: 4c 01 f3                     	addq	%r14, %rbx
    4fd7: 4d 89 de                     	movq	%r11, %r14
    4fda: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4fde: 4d 31 fe                     	xorq	%r15, %r14
    4fe1: 4d 89 df                     	movq	%r11, %r15
    4fe4: 49 c1 c7 17                  	rolq	$0x17, %r15
    4fe8: 4d 31 f7                     	xorq	%r14, %r15
    4feb: 4d 89 ce                     	movq	%r9, %r14
    4fee: 4d 31 c6                     	xorq	%r8, %r14
    4ff1: 4d 21 de                     	andq	%r11, %r14
    4ff4: 4d 31 c6                     	xorq	%r8, %r14
    4ff7: 48 03 b5 c8 fe ff ff         	addq	-0x138(%rbp), %rsi
    4ffe: 4c 01 f6                     	addq	%r14, %rsi
    5001: 49 be 2a 20 71 57 85 35 0e f4	movabsq	$-0xbf1ca7aa88edfd6, %r14 # imm = 0xF40E35855771202A
    500b: 49 01 f6                     	addq	%rsi, %r14
    500e: 4d 01 fe                     	addq	%r15, %r14
    5011: 4c 01 f2                     	addq	%r14, %rdx
    5014: 48 89 de                     	movq	%rbx, %rsi
    5017: 48 c1 c6 24                  	rolq	$0x24, %rsi
    501b: 49 89 df                     	movq	%rbx, %r15
    501e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5022: 49 31 f7                     	xorq	%rsi, %r15
    5025: 49 89 dc                     	movq	%rbx, %r12
    5028: 49 c1 c4 19                  	rolq	$0x19, %r12
    502c: 4d 31 fc                     	xorq	%r15, %r12
    502f: 4d 89 d7                     	movq	%r10, %r15
    5032: 49 09 cf                     	orq	%rcx, %r15
    5035: 49 21 df                     	andq	%rbx, %r15
    5038: 4c 89 d6                     	movq	%r10, %rsi
    503b: 48 21 ce                     	andq	%rcx, %rsi
    503e: 4c 09 fe                     	orq	%r15, %rsi
    5041: 49 89 d7                     	movq	%rdx, %r15
    5044: 49 c1 c7 32                  	rolq	$0x32, %r15
    5048: 4c 01 e6                     	addq	%r12, %rsi
    504b: 49 89 d4                     	movq	%rdx, %r12
    504e: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5052: 4c 01 f6                     	addq	%r14, %rsi
    5055: 49 89 d6                     	movq	%rdx, %r14
    5058: 49 c1 c6 17                  	rolq	$0x17, %r14
    505c: 4d 31 fc                     	xorq	%r15, %r12
    505f: 4d 31 e6                     	xorq	%r12, %r14
    5062: 4d 89 df                     	movq	%r11, %r15
    5065: 4d 31 cf                     	xorq	%r9, %r15
    5068: 49 21 d7                     	andq	%rdx, %r15
    506b: 4d 31 cf                     	xorq	%r9, %r15
    506e: 4c 03 85 d0 fe ff ff         	addq	-0x130(%rbp), %r8
    5075: 4d 01 f8                     	addq	%r15, %r8
    5078: 49 bf b8 d1 bb 32 70 a0 6a 10	movabsq	$0x106aa07032bbd1b8, %r15 # imm = 0x106AA07032BBD1B8
    5082: 4d 01 c7                     	addq	%r8, %r15
    5085: 4d 01 f7                     	addq	%r14, %r15
    5088: 4c 01 f9                     	addq	%r15, %rcx
    508b: 49 89 f0                     	movq	%rsi, %r8
    508e: 49 c1 c0 24                  	rolq	$0x24, %r8
    5092: 49 89 f6                     	movq	%rsi, %r14
    5095: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5099: 4d 31 c6                     	xorq	%r8, %r14
    509c: 49 89 f4                     	movq	%rsi, %r12
    509f: 49 c1 c4 19                  	rolq	$0x19, %r12
    50a3: 4d 31 f4                     	xorq	%r14, %r12
    50a6: 49 89 de                     	movq	%rbx, %r14
    50a9: 4d 09 d6                     	orq	%r10, %r14
    50ac: 49 21 f6                     	andq	%rsi, %r14
    50af: 49 89 d8                     	movq	%rbx, %r8
    50b2: 4d 21 d0                     	andq	%r10, %r8
    50b5: 4d 09 f0                     	orq	%r14, %r8
    50b8: 4d 01 e0                     	addq	%r12, %r8
    50bb: 4d 01 f8                     	addq	%r15, %r8
    50be: 49 89 ce                     	movq	%rcx, %r14
    50c1: 49 c1 c6 32                  	rolq	$0x32, %r14
    50c5: 49 89 cf                     	movq	%rcx, %r15
    50c8: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    50cc: 4d 31 f7                     	xorq	%r14, %r15
    50cf: 49 89 cc                     	movq	%rcx, %r12
    50d2: 49 c1 c4 17                  	rolq	$0x17, %r12
    50d6: 4d 31 fc                     	xorq	%r15, %r12
    50d9: 49 89 d6                     	movq	%rdx, %r14
    50dc: 4d 31 de                     	xorq	%r11, %r14
    50df: 49 21 ce                     	andq	%rcx, %r14
    50e2: 4c 03 8d d8 fe ff ff         	addq	-0x128(%rbp), %r9
    50e9: 4d 31 de                     	xorq	%r11, %r14
    50ec: 4d 01 f1                     	addq	%r14, %r9
    50ef: 49 be c8 d0 d2 b8 16 c1 a4 19	movabsq	$0x19a4c116b8d2d0c8, %r14 # imm = 0x19A4C116B8D2D0C8
    50f9: 4d 01 ce                     	addq	%r9, %r14
    50fc: 4d 01 e6                     	addq	%r12, %r14
    50ff: 4d 89 c1                     	movq	%r8, %r9
    5102: 49 c1 c1 24                  	rolq	$0x24, %r9
    5106: 4d 01 f2                     	addq	%r14, %r10
    5109: 4d 89 c7                     	movq	%r8, %r15
    510c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5110: 4d 31 cf                     	xorq	%r9, %r15
    5113: 4d 89 c4                     	movq	%r8, %r12
    5116: 49 c1 c4 19                  	rolq	$0x19, %r12
    511a: 4d 31 fc                     	xorq	%r15, %r12
    511d: 49 89 f7                     	movq	%rsi, %r15
    5120: 49 09 df                     	orq	%rbx, %r15
    5123: 4d 21 c7                     	andq	%r8, %r15
    5126: 49 89 f1                     	movq	%rsi, %r9
    5129: 49 21 d9                     	andq	%rbx, %r9
    512c: 4d 09 f9                     	orq	%r15, %r9
    512f: 4d 01 e1                     	addq	%r12, %r9
    5132: 4d 01 f1                     	addq	%r14, %r9
    5135: 4d 89 d6                     	movq	%r10, %r14
    5138: 49 c1 c6 32                  	rolq	$0x32, %r14
    513c: 4d 89 d7                     	movq	%r10, %r15
    513f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5143: 4d 31 f7                     	xorq	%r14, %r15
    5146: 4d 89 d4                     	movq	%r10, %r12
    5149: 49 c1 c4 17                  	rolq	$0x17, %r12
    514d: 4d 31 fc                     	xorq	%r15, %r12
    5150: 49 89 ce                     	movq	%rcx, %r14
    5153: 49 31 d6                     	xorq	%rdx, %r14
    5156: 4d 21 d6                     	andq	%r10, %r14
    5159: 49 31 d6                     	xorq	%rdx, %r14
    515c: 4c 03 9d e0 fe ff ff         	addq	-0x120(%rbp), %r11
    5163: 4d 01 f3                     	addq	%r14, %r11
    5166: 49 be 53 ab 41 51 08 6c 37 1e	movabsq	$0x1e376c085141ab53, %r14 # imm = 0x1E376C085141AB53
    5170: 4d 01 de                     	addq	%r11, %r14
    5173: 4d 89 cb                     	movq	%r9, %r11
    5176: 49 c1 c3 24                  	rolq	$0x24, %r11
    517a: 4d 01 e6                     	addq	%r12, %r14
    517d: 4d 89 cf                     	movq	%r9, %r15
    5180: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5184: 4c 01 f3                     	addq	%r14, %rbx
    5187: 4d 89 cc                     	movq	%r9, %r12
    518a: 49 c1 c4 19                  	rolq	$0x19, %r12
    518e: 4d 31 df                     	xorq	%r11, %r15
    5191: 4d 31 fc                     	xorq	%r15, %r12
    5194: 4d 89 c7                     	movq	%r8, %r15
    5197: 49 09 f7                     	orq	%rsi, %r15
    519a: 4d 21 cf                     	andq	%r9, %r15
    519d: 4d 89 c3                     	movq	%r8, %r11
    51a0: 49 21 f3                     	andq	%rsi, %r11
    51a3: 4d 09 fb                     	orq	%r15, %r11
    51a6: 4d 01 e3                     	addq	%r12, %r11
    51a9: 49 89 df                     	movq	%rbx, %r15
    51ac: 49 c1 c7 32                  	rolq	$0x32, %r15
    51b0: 4d 01 f3                     	addq	%r14, %r11
    51b3: 49 89 de                     	movq	%rbx, %r14
    51b6: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    51ba: 4d 31 fe                     	xorq	%r15, %r14
    51bd: 49 89 df                     	movq	%rbx, %r15
    51c0: 49 c1 c7 17                  	rolq	$0x17, %r15
    51c4: 4d 31 f7                     	xorq	%r14, %r15
    51c7: 4d 89 d6                     	movq	%r10, %r14
    51ca: 49 31 ce                     	xorq	%rcx, %r14
    51cd: 49 21 de                     	andq	%rbx, %r14
    51d0: 49 31 ce                     	xorq	%rcx, %r14
    51d3: 48 03 95 e8 fe ff ff         	addq	-0x118(%rbp), %rdx
    51da: 4c 01 f2                     	addq	%r14, %rdx
    51dd: 49 be 99 eb 8e df 4c 77 48 27	movabsq	$0x2748774cdf8eeb99, %r14 # imm = 0x2748774CDF8EEB99
    51e7: 49 01 d6                     	addq	%rdx, %r14
    51ea: 4d 01 fe                     	addq	%r15, %r14
    51ed: 4c 01 f6                     	addq	%r14, %rsi
    51f0: 4c 89 da                     	movq	%r11, %rdx
    51f3: 48 c1 c2 24                  	rolq	$0x24, %rdx
    51f7: 4d 89 df                     	movq	%r11, %r15
    51fa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    51fe: 49 31 d7                     	xorq	%rdx, %r15
    5201: 4d 89 dc                     	movq	%r11, %r12
    5204: 49 c1 c4 19                  	rolq	$0x19, %r12
    5208: 4d 31 fc                     	xorq	%r15, %r12
    520b: 4d 89 cf                     	movq	%r9, %r15
    520e: 4d 09 c7                     	orq	%r8, %r15
    5211: 4d 21 df                     	andq	%r11, %r15
    5214: 4c 89 ca                     	movq	%r9, %rdx
    5217: 4c 21 c2                     	andq	%r8, %rdx
    521a: 4c 09 fa                     	orq	%r15, %rdx
    521d: 49 89 f7                     	movq	%rsi, %r15
    5220: 49 c1 c7 32                  	rolq	$0x32, %r15
    5224: 4c 01 e2                     	addq	%r12, %rdx
    5227: 49 89 f4                     	movq	%rsi, %r12
    522a: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    522e: 4c 01 f2                     	addq	%r14, %rdx
    5231: 49 89 f6                     	movq	%rsi, %r14
    5234: 49 c1 c6 17                  	rolq	$0x17, %r14
    5238: 4d 31 fc                     	xorq	%r15, %r12
    523b: 4d 31 e6                     	xorq	%r12, %r14
    523e: 49 89 df                     	movq	%rbx, %r15
    5241: 4d 31 d7                     	xorq	%r10, %r15
    5244: 49 21 f7                     	andq	%rsi, %r15
    5247: 4d 31 d7                     	xorq	%r10, %r15
    524a: 48 03 8d f0 fe ff ff         	addq	-0x110(%rbp), %rcx
    5251: 4c 01 f9                     	addq	%r15, %rcx
    5254: 49 bf a8 48 9b e1 b5 bc b0 34	movabsq	$0x34b0bcb5e19b48a8, %r15 # imm = 0x34B0BCB5E19B48A8
    525e: 49 01 cf                     	addq	%rcx, %r15
    5261: 4d 01 f7                     	addq	%r14, %r15
    5264: 4d 01 f8                     	addq	%r15, %r8
    5267: 48 89 d1                     	movq	%rdx, %rcx
    526a: 48 c1 c1 24                  	rolq	$0x24, %rcx
    526e: 49 89 d6                     	movq	%rdx, %r14
    5271: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5275: 49 31 ce                     	xorq	%rcx, %r14
    5278: 49 89 d4                     	movq	%rdx, %r12
    527b: 49 c1 c4 19                  	rolq	$0x19, %r12
    527f: 4d 31 f4                     	xorq	%r14, %r12
    5282: 4d 89 de                     	movq	%r11, %r14
    5285: 4d 09 ce                     	orq	%r9, %r14
    5288: 49 21 d6                     	andq	%rdx, %r14
    528b: 4c 89 d9                     	movq	%r11, %rcx
    528e: 4c 21 c9                     	andq	%r9, %rcx
    5291: 4c 09 f1                     	orq	%r14, %rcx
    5294: 4c 01 e1                     	addq	%r12, %rcx
    5297: 4c 01 f9                     	addq	%r15, %rcx
    529a: 4d 89 c6                     	movq	%r8, %r14
    529d: 49 c1 c6 32                  	rolq	$0x32, %r14
    52a1: 4d 89 c7                     	movq	%r8, %r15
    52a4: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    52a8: 4d 31 f7                     	xorq	%r14, %r15
    52ab: 4d 89 c4                     	movq	%r8, %r12
    52ae: 49 c1 c4 17                  	rolq	$0x17, %r12
    52b2: 4d 31 fc                     	xorq	%r15, %r12
    52b5: 49 89 f6                     	movq	%rsi, %r14
    52b8: 49 31 de                     	xorq	%rbx, %r14
    52bb: 4d 21 c6                     	andq	%r8, %r14
    52be: 4c 03 95 f8 fe ff ff         	addq	-0x108(%rbp), %r10
    52c5: 49 31 de                     	xorq	%rbx, %r14
    52c8: 4d 01 f2                     	addq	%r14, %r10
    52cb: 49 be 63 5a c9 c5 b3 0c 1c 39	movabsq	$0x391c0cb3c5c95a63, %r14 # imm = 0x391C0CB3C5C95A63
    52d5: 4d 01 d6                     	addq	%r10, %r14
    52d8: 4d 01 e6                     	addq	%r12, %r14
    52db: 49 89 ca                     	movq	%rcx, %r10
    52de: 49 c1 c2 24                  	rolq	$0x24, %r10
    52e2: 4d 01 f1                     	addq	%r14, %r9
    52e5: 49 89 cf                     	movq	%rcx, %r15
    52e8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    52ec: 4d 31 d7                     	xorq	%r10, %r15
    52ef: 49 89 cc                     	movq	%rcx, %r12
    52f2: 49 c1 c4 19                  	rolq	$0x19, %r12
    52f6: 4d 31 fc                     	xorq	%r15, %r12
    52f9: 49 89 d7                     	movq	%rdx, %r15
    52fc: 4d 09 df                     	orq	%r11, %r15
    52ff: 49 21 cf                     	andq	%rcx, %r15
    5302: 49 89 d2                     	movq	%rdx, %r10
    5305: 4d 21 da                     	andq	%r11, %r10
    5308: 4d 09 fa                     	orq	%r15, %r10
    530b: 4d 01 e2                     	addq	%r12, %r10
    530e: 4d 01 f2                     	addq	%r14, %r10
    5311: 4d 89 ce                     	movq	%r9, %r14
    5314: 49 c1 c6 32                  	rolq	$0x32, %r14
    5318: 4d 89 cf                     	movq	%r9, %r15
    531b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    531f: 4d 31 f7                     	xorq	%r14, %r15
    5322: 4d 89 cc                     	movq	%r9, %r12
    5325: 49 c1 c4 17                  	rolq	$0x17, %r12
    5329: 4d 31 fc                     	xorq	%r15, %r12
    532c: 4d 89 c6                     	movq	%r8, %r14
    532f: 49 31 f6                     	xorq	%rsi, %r14
    5332: 4d 21 ce                     	andq	%r9, %r14
    5335: 49 31 f6                     	xorq	%rsi, %r14
    5338: 48 03 9d 00 ff ff ff         	addq	-0x100(%rbp), %rbx
    533f: 4c 01 f3                     	addq	%r14, %rbx
    5342: 49 be cb 8a 41 e3 4a aa d8 4e	movabsq	$0x4ed8aa4ae3418acb, %r14 # imm = 0x4ED8AA4AE3418ACB
    534c: 49 01 de                     	addq	%rbx, %r14
    534f: 4c 89 d3                     	movq	%r10, %rbx
    5352: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5356: 4d 01 e6                     	addq	%r12, %r14
    5359: 4d 89 d7                     	movq	%r10, %r15
    535c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5360: 4d 01 f3                     	addq	%r14, %r11
    5363: 4d 89 d4                     	movq	%r10, %r12
    5366: 49 c1 c4 19                  	rolq	$0x19, %r12
    536a: 49 31 df                     	xorq	%rbx, %r15
    536d: 4d 31 fc                     	xorq	%r15, %r12
    5370: 49 89 cf                     	movq	%rcx, %r15
    5373: 49 09 d7                     	orq	%rdx, %r15
    5376: 4d 21 d7                     	andq	%r10, %r15
    5379: 48 89 cb                     	movq	%rcx, %rbx
    537c: 48 21 d3                     	andq	%rdx, %rbx
    537f: 4c 09 fb                     	orq	%r15, %rbx
    5382: 4c 01 e3                     	addq	%r12, %rbx
    5385: 4d 89 df                     	movq	%r11, %r15
    5388: 49 c1 c7 32                  	rolq	$0x32, %r15
    538c: 4c 01 f3                     	addq	%r14, %rbx
    538f: 4d 89 de                     	movq	%r11, %r14
    5392: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5396: 4d 31 fe                     	xorq	%r15, %r14
    5399: 4d 89 df                     	movq	%r11, %r15
    539c: 49 c1 c7 17                  	rolq	$0x17, %r15
    53a0: 4d 31 f7                     	xorq	%r14, %r15
    53a3: 4d 89 ce                     	movq	%r9, %r14
    53a6: 4d 31 c6                     	xorq	%r8, %r14
    53a9: 4d 21 de                     	andq	%r11, %r14
    53ac: 4d 31 c6                     	xorq	%r8, %r14
    53af: 48 03 b5 08 ff ff ff         	addq	-0xf8(%rbp), %rsi
    53b6: 4c 01 f6                     	addq	%r14, %rsi
    53b9: 49 be 73 e3 63 77 4f ca 9c 5b	movabsq	$0x5b9cca4f7763e373, %r14 # imm = 0x5B9CCA4F7763E373
    53c3: 49 01 f6                     	addq	%rsi, %r14
    53c6: 4d 01 fe                     	addq	%r15, %r14
    53c9: 4c 01 f2                     	addq	%r14, %rdx
    53cc: 48 89 de                     	movq	%rbx, %rsi
    53cf: 48 c1 c6 24                  	rolq	$0x24, %rsi
    53d3: 49 89 df                     	movq	%rbx, %r15
    53d6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    53da: 49 31 f7                     	xorq	%rsi, %r15
    53dd: 49 89 dc                     	movq	%rbx, %r12
    53e0: 49 c1 c4 19                  	rolq	$0x19, %r12
    53e4: 4d 31 fc                     	xorq	%r15, %r12
    53e7: 4d 89 d7                     	movq	%r10, %r15
    53ea: 49 09 cf                     	orq	%rcx, %r15
    53ed: 49 21 df                     	andq	%rbx, %r15
    53f0: 4c 89 d6                     	movq	%r10, %rsi
    53f3: 48 21 ce                     	andq	%rcx, %rsi
    53f6: 4c 09 fe                     	orq	%r15, %rsi
    53f9: 49 89 d7                     	movq	%rdx, %r15
    53fc: 49 c1 c7 32                  	rolq	$0x32, %r15
    5400: 4c 01 e6                     	addq	%r12, %rsi
    5403: 49 89 d4                     	movq	%rdx, %r12
    5406: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    540a: 4c 01 f6                     	addq	%r14, %rsi
    540d: 49 89 d6                     	movq	%rdx, %r14
    5410: 49 c1 c6 17                  	rolq	$0x17, %r14
    5414: 4d 31 fc                     	xorq	%r15, %r12
    5417: 4d 31 e6                     	xorq	%r12, %r14
    541a: 4d 89 df                     	movq	%r11, %r15
    541d: 4d 31 cf                     	xorq	%r9, %r15
    5420: 49 21 d7                     	andq	%rdx, %r15
    5423: 4d 31 cf                     	xorq	%r9, %r15
    5426: 4c 03 85 10 ff ff ff         	addq	-0xf0(%rbp), %r8
    542d: 4d 01 f8                     	addq	%r15, %r8
    5430: 49 bf a3 b8 b2 d6 f3 6f 2e 68	movabsq	$0x682e6ff3d6b2b8a3, %r15 # imm = 0x682E6FF3D6B2B8A3
    543a: 4d 01 c7                     	addq	%r8, %r15
    543d: 4d 01 f7                     	addq	%r14, %r15
    5440: 4c 01 f9                     	addq	%r15, %rcx
    5443: 49 89 f0                     	movq	%rsi, %r8
    5446: 49 c1 c0 24                  	rolq	$0x24, %r8
    544a: 49 89 f6                     	movq	%rsi, %r14
    544d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5451: 4d 31 c6                     	xorq	%r8, %r14
    5454: 49 89 f4                     	movq	%rsi, %r12
    5457: 49 c1 c4 19                  	rolq	$0x19, %r12
    545b: 4d 31 f4                     	xorq	%r14, %r12
    545e: 49 89 de                     	movq	%rbx, %r14
    5461: 4d 09 d6                     	orq	%r10, %r14
    5464: 49 21 f6                     	andq	%rsi, %r14
    5467: 49 89 d8                     	movq	%rbx, %r8
    546a: 4d 21 d0                     	andq	%r10, %r8
    546d: 4d 09 f0                     	orq	%r14, %r8
    5470: 4d 01 e0                     	addq	%r12, %r8
    5473: 4d 01 f8                     	addq	%r15, %r8
    5476: 49 89 ce                     	movq	%rcx, %r14
    5479: 49 c1 c6 32                  	rolq	$0x32, %r14
    547d: 49 89 cf                     	movq	%rcx, %r15
    5480: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5484: 4d 31 f7                     	xorq	%r14, %r15
    5487: 49 89 cc                     	movq	%rcx, %r12
    548a: 49 c1 c4 17                  	rolq	$0x17, %r12
    548e: 4d 31 fc                     	xorq	%r15, %r12
    5491: 49 89 d6                     	movq	%rdx, %r14
    5494: 4d 31 de                     	xorq	%r11, %r14
    5497: 49 21 ce                     	andq	%rcx, %r14
    549a: 4c 03 8d 18 ff ff ff         	addq	-0xe8(%rbp), %r9
    54a1: 4d 31 de                     	xorq	%r11, %r14
    54a4: 4d 01 f1                     	addq	%r14, %r9
    54a7: 49 be fc b2 ef 5d ee 82 8f 74	movabsq	$0x748f82ee5defb2fc, %r14 # imm = 0x748F82EE5DEFB2FC
    54b1: 4d 01 ce                     	addq	%r9, %r14
    54b4: 4d 01 e6                     	addq	%r12, %r14
    54b7: 4d 89 c1                     	movq	%r8, %r9
    54ba: 49 c1 c1 24                  	rolq	$0x24, %r9
    54be: 4d 01 f2                     	addq	%r14, %r10
    54c1: 4d 89 c7                     	movq	%r8, %r15
    54c4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    54c8: 4d 31 cf                     	xorq	%r9, %r15
    54cb: 4d 89 c4                     	movq	%r8, %r12
    54ce: 49 c1 c4 19                  	rolq	$0x19, %r12
    54d2: 4d 31 fc                     	xorq	%r15, %r12
    54d5: 49 89 f7                     	movq	%rsi, %r15
    54d8: 49 09 df                     	orq	%rbx, %r15
    54db: 4d 21 c7                     	andq	%r8, %r15
    54de: 49 89 f1                     	movq	%rsi, %r9
    54e1: 49 21 d9                     	andq	%rbx, %r9
    54e4: 4d 09 f9                     	orq	%r15, %r9
    54e7: 4d 01 e1                     	addq	%r12, %r9
    54ea: 4d 01 f1                     	addq	%r14, %r9
    54ed: 4d 89 d6                     	movq	%r10, %r14
    54f0: 49 c1 c6 32                  	rolq	$0x32, %r14
    54f4: 4d 89 d7                     	movq	%r10, %r15
    54f7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    54fb: 4d 31 f7                     	xorq	%r14, %r15
    54fe: 4d 89 d4                     	movq	%r10, %r12
    5501: 49 c1 c4 17                  	rolq	$0x17, %r12
    5505: 4d 31 fc                     	xorq	%r15, %r12
    5508: 49 89 ce                     	movq	%rcx, %r14
    550b: 49 31 d6                     	xorq	%rdx, %r14
    550e: 4d 21 d6                     	andq	%r10, %r14
    5511: 49 31 d6                     	xorq	%rdx, %r14
    5514: 4c 03 9d 20 ff ff ff         	addq	-0xe0(%rbp), %r11
    551b: 4d 01 f3                     	addq	%r14, %r11
    551e: 49 be 60 2f 17 43 6f 63 a5 78	movabsq	$0x78a5636f43172f60, %r14 # imm = 0x78A5636F43172F60
    5528: 4d 01 de                     	addq	%r11, %r14
    552b: 4d 89 cb                     	movq	%r9, %r11
    552e: 49 c1 c3 24                  	rolq	$0x24, %r11
    5532: 4d 01 e6                     	addq	%r12, %r14
    5535: 4d 89 cf                     	movq	%r9, %r15
    5538: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    553c: 4c 01 f3                     	addq	%r14, %rbx
    553f: 4d 89 cc                     	movq	%r9, %r12
    5542: 49 c1 c4 19                  	rolq	$0x19, %r12
    5546: 4d 31 df                     	xorq	%r11, %r15
    5549: 4d 31 fc                     	xorq	%r15, %r12
    554c: 4d 89 c7                     	movq	%r8, %r15
    554f: 49 09 f7                     	orq	%rsi, %r15
    5552: 4d 21 cf                     	andq	%r9, %r15
    5555: 4d 89 c3                     	movq	%r8, %r11
    5558: 49 21 f3                     	andq	%rsi, %r11
    555b: 4d 09 fb                     	orq	%r15, %r11
    555e: 4d 01 e3                     	addq	%r12, %r11
    5561: 49 89 df                     	movq	%rbx, %r15
    5564: 49 c1 c7 32                  	rolq	$0x32, %r15
    5568: 4d 01 f3                     	addq	%r14, %r11
    556b: 49 89 de                     	movq	%rbx, %r14
    556e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5572: 4d 31 fe                     	xorq	%r15, %r14
    5575: 49 89 df                     	movq	%rbx, %r15
    5578: 49 c1 c7 17                  	rolq	$0x17, %r15
    557c: 4d 31 f7                     	xorq	%r14, %r15
    557f: 4d 89 d6                     	movq	%r10, %r14
    5582: 49 31 ce                     	xorq	%rcx, %r14
    5585: 49 21 de                     	andq	%rbx, %r14
    5588: 49 31 ce                     	xorq	%rcx, %r14
    558b: 48 03 95 28 ff ff ff         	addq	-0xd8(%rbp), %rdx
    5592: 4c 01 f2                     	addq	%r14, %rdx
    5595: 49 be 72 ab f0 a1 14 78 c8 84	movabsq	$-0x7b3787eb5e0f548e, %r14 # imm = 0x84C87814A1F0AB72
    559f: 49 01 d6                     	addq	%rdx, %r14
    55a2: 4d 01 fe                     	addq	%r15, %r14
    55a5: 4c 01 f6                     	addq	%r14, %rsi
    55a8: 4c 89 da                     	movq	%r11, %rdx
    55ab: 48 c1 c2 24                  	rolq	$0x24, %rdx
    55af: 4d 89 df                     	movq	%r11, %r15
    55b2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    55b6: 49 31 d7                     	xorq	%rdx, %r15
    55b9: 4d 89 dc                     	movq	%r11, %r12
    55bc: 49 c1 c4 19                  	rolq	$0x19, %r12
    55c0: 4d 31 fc                     	xorq	%r15, %r12
    55c3: 4d 89 cf                     	movq	%r9, %r15
    55c6: 4d 09 c7                     	orq	%r8, %r15
    55c9: 4d 21 df                     	andq	%r11, %r15
    55cc: 4c 89 ca                     	movq	%r9, %rdx
    55cf: 4c 21 c2                     	andq	%r8, %rdx
    55d2: 4c 09 fa                     	orq	%r15, %rdx
    55d5: 49 89 f7                     	movq	%rsi, %r15
    55d8: 49 c1 c7 32                  	rolq	$0x32, %r15
    55dc: 4c 01 e2                     	addq	%r12, %rdx
    55df: 49 89 f4                     	movq	%rsi, %r12
    55e2: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    55e6: 4c 01 f2                     	addq	%r14, %rdx
    55e9: 49 89 f6                     	movq	%rsi, %r14
    55ec: 49 c1 c6 17                  	rolq	$0x17, %r14
    55f0: 4d 31 fc                     	xorq	%r15, %r12
    55f3: 4d 31 e6                     	xorq	%r12, %r14
    55f6: 49 89 df                     	movq	%rbx, %r15
    55f9: 4d 31 d7                     	xorq	%r10, %r15
    55fc: 49 21 f7                     	andq	%rsi, %r15
    55ff: 4d 31 d7                     	xorq	%r10, %r15
    5602: 48 03 8d 30 ff ff ff         	addq	-0xd0(%rbp), %rcx
    5609: 4c 01 f9                     	addq	%r15, %rcx
    560c: 49 bf ec 39 64 1a 08 02 c7 8c	movabsq	$-0x7338fdf7e59bc614, %r15 # imm = 0x8CC702081A6439EC
    5616: 49 01 cf                     	addq	%rcx, %r15
    5619: 4d 01 f7                     	addq	%r14, %r15
    561c: 4d 01 f8                     	addq	%r15, %r8
    561f: 48 89 d1                     	movq	%rdx, %rcx
    5622: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5626: 49 89 d6                     	movq	%rdx, %r14
    5629: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    562d: 49 31 ce                     	xorq	%rcx, %r14
    5630: 49 89 d4                     	movq	%rdx, %r12
    5633: 49 c1 c4 19                  	rolq	$0x19, %r12
    5637: 4d 31 f4                     	xorq	%r14, %r12
    563a: 4d 89 de                     	movq	%r11, %r14
    563d: 4d 09 ce                     	orq	%r9, %r14
    5640: 49 21 d6                     	andq	%rdx, %r14
    5643: 4c 89 d9                     	movq	%r11, %rcx
    5646: 4c 21 c9                     	andq	%r9, %rcx
    5649: 4c 09 f1                     	orq	%r14, %rcx
    564c: 4c 01 e1                     	addq	%r12, %rcx
    564f: 4c 01 f9                     	addq	%r15, %rcx
    5652: 4d 89 c6                     	movq	%r8, %r14
    5655: 49 c1 c6 32                  	rolq	$0x32, %r14
    5659: 4d 89 c7                     	movq	%r8, %r15
    565c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5660: 4d 31 f7                     	xorq	%r14, %r15
    5663: 4d 89 c4                     	movq	%r8, %r12
    5666: 49 c1 c4 17                  	rolq	$0x17, %r12
    566a: 4d 31 fc                     	xorq	%r15, %r12
    566d: 49 89 f6                     	movq	%rsi, %r14
    5670: 49 31 de                     	xorq	%rbx, %r14
    5673: 4d 21 c6                     	andq	%r8, %r14
    5676: 4c 03 95 38 ff ff ff         	addq	-0xc8(%rbp), %r10
    567d: 49 31 de                     	xorq	%rbx, %r14
    5680: 4d 01 f2                     	addq	%r14, %r10
    5683: 49 be 28 1e 63 23 fa ff be 90	movabsq	$-0x6f410005dc9ce1d8, %r14 # imm = 0x90BEFFFA23631E28
    568d: 4d 01 d6                     	addq	%r10, %r14
    5690: 4d 01 e6                     	addq	%r12, %r14
    5693: 49 89 ca                     	movq	%rcx, %r10
    5696: 49 c1 c2 24                  	rolq	$0x24, %r10
    569a: 4d 01 f1                     	addq	%r14, %r9
    569d: 49 89 cf                     	movq	%rcx, %r15
    56a0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    56a4: 4d 31 d7                     	xorq	%r10, %r15
    56a7: 49 89 cc                     	movq	%rcx, %r12
    56aa: 49 c1 c4 19                  	rolq	$0x19, %r12
    56ae: 4d 31 fc                     	xorq	%r15, %r12
    56b1: 49 89 d7                     	movq	%rdx, %r15
    56b4: 4d 09 df                     	orq	%r11, %r15
    56b7: 49 21 cf                     	andq	%rcx, %r15
    56ba: 49 89 d2                     	movq	%rdx, %r10
    56bd: 4d 21 da                     	andq	%r11, %r10
    56c0: 4d 09 fa                     	orq	%r15, %r10
    56c3: 4d 01 e2                     	addq	%r12, %r10
    56c6: 4d 01 f2                     	addq	%r14, %r10
    56c9: 4d 89 ce                     	movq	%r9, %r14
    56cc: 49 c1 c6 32                  	rolq	$0x32, %r14
    56d0: 4d 89 cf                     	movq	%r9, %r15
    56d3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    56d7: 4d 31 f7                     	xorq	%r14, %r15
    56da: 4d 89 cc                     	movq	%r9, %r12
    56dd: 49 c1 c4 17                  	rolq	$0x17, %r12
    56e1: 4d 31 fc                     	xorq	%r15, %r12
    56e4: 4d 89 c6                     	movq	%r8, %r14
    56e7: 49 31 f6                     	xorq	%rsi, %r14
    56ea: 4d 21 ce                     	andq	%r9, %r14
    56ed: 49 31 f6                     	xorq	%rsi, %r14
    56f0: 48 03 9d 40 ff ff ff         	addq	-0xc0(%rbp), %rbx
    56f7: 4c 01 f3                     	addq	%r14, %rbx
    56fa: 49 be e9 bd 82 de eb 6c 50 a4	movabsq	$-0x5baf9314217d4217, %r14 # imm = 0xA4506CEBDE82BDE9
    5704: 49 01 de                     	addq	%rbx, %r14
    5707: 4c 89 d3                     	movq	%r10, %rbx
    570a: 48 c1 c3 24                  	rolq	$0x24, %rbx
    570e: 4d 01 e6                     	addq	%r12, %r14
    5711: 4d 89 d7                     	movq	%r10, %r15
    5714: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5718: 4d 01 f3                     	addq	%r14, %r11
    571b: 4d 89 d4                     	movq	%r10, %r12
    571e: 49 c1 c4 19                  	rolq	$0x19, %r12
    5722: 49 31 df                     	xorq	%rbx, %r15
    5725: 4d 31 fc                     	xorq	%r15, %r12
    5728: 49 89 cf                     	movq	%rcx, %r15
    572b: 49 09 d7                     	orq	%rdx, %r15
    572e: 4d 21 d7                     	andq	%r10, %r15
    5731: 48 89 cb                     	movq	%rcx, %rbx
    5734: 48 21 d3                     	andq	%rdx, %rbx
    5737: 4c 09 fb                     	orq	%r15, %rbx
    573a: 4c 01 e3                     	addq	%r12, %rbx
    573d: 4d 89 df                     	movq	%r11, %r15
    5740: 49 c1 c7 32                  	rolq	$0x32, %r15
    5744: 4c 01 f3                     	addq	%r14, %rbx
    5747: 4d 89 de                     	movq	%r11, %r14
    574a: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    574e: 4d 31 fe                     	xorq	%r15, %r14
    5751: 4d 89 df                     	movq	%r11, %r15
    5754: 49 c1 c7 17                  	rolq	$0x17, %r15
    5758: 4d 31 f7                     	xorq	%r14, %r15
    575b: 4d 89 ce                     	movq	%r9, %r14
    575e: 4d 31 c6                     	xorq	%r8, %r14
    5761: 4d 21 de                     	andq	%r11, %r14
    5764: 4d 31 c6                     	xorq	%r8, %r14
    5767: 48 03 b5 48 ff ff ff         	addq	-0xb8(%rbp), %rsi
    576e: 4c 01 f6                     	addq	%r14, %rsi
    5771: 49 be 15 79 c6 b2 f7 a3 f9 be	movabsq	$-0x41065c084d3986eb, %r14 # imm = 0xBEF9A3F7B2C67915
    577b: 49 01 f6                     	addq	%rsi, %r14
    577e: 4d 01 fe                     	addq	%r15, %r14
    5781: 4c 01 f2                     	addq	%r14, %rdx
    5784: 48 89 de                     	movq	%rbx, %rsi
    5787: 48 c1 c6 24                  	rolq	$0x24, %rsi
    578b: 49 89 df                     	movq	%rbx, %r15
    578e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5792: 49 31 f7                     	xorq	%rsi, %r15
    5795: 49 89 dc                     	movq	%rbx, %r12
    5798: 49 c1 c4 19                  	rolq	$0x19, %r12
    579c: 4d 31 fc                     	xorq	%r15, %r12
    579f: 4d 89 d7                     	movq	%r10, %r15
    57a2: 49 09 cf                     	orq	%rcx, %r15
    57a5: 49 21 df                     	andq	%rbx, %r15
    57a8: 4c 89 d6                     	movq	%r10, %rsi
    57ab: 48 21 ce                     	andq	%rcx, %rsi
    57ae: 4c 09 fe                     	orq	%r15, %rsi
    57b1: 49 89 d7                     	movq	%rdx, %r15
    57b4: 49 c1 c7 32                  	rolq	$0x32, %r15
    57b8: 4c 01 e6                     	addq	%r12, %rsi
    57bb: 49 89 d4                     	movq	%rdx, %r12
    57be: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    57c2: 4c 01 f6                     	addq	%r14, %rsi
    57c5: 49 89 d6                     	movq	%rdx, %r14
    57c8: 49 c1 c6 17                  	rolq	$0x17, %r14
    57cc: 4d 31 fc                     	xorq	%r15, %r12
    57cf: 4d 31 e6                     	xorq	%r12, %r14
    57d2: 4d 89 df                     	movq	%r11, %r15
    57d5: 4d 31 cf                     	xorq	%r9, %r15
    57d8: 49 21 d7                     	andq	%rdx, %r15
    57db: 4d 31 cf                     	xorq	%r9, %r15
    57de: 4c 03 85 50 ff ff ff         	addq	-0xb0(%rbp), %r8
    57e5: 4d 01 f8                     	addq	%r15, %r8
    57e8: 49 bf 2b 53 72 e3 f2 78 71 c6	movabsq	$-0x398e870d1c8dacd5, %r15 # imm = 0xC67178F2E372532B
    57f2: 4d 01 c7                     	addq	%r8, %r15
    57f5: 4d 01 f7                     	addq	%r14, %r15
    57f8: 4c 01 f9                     	addq	%r15, %rcx
    57fb: 49 89 f0                     	movq	%rsi, %r8
    57fe: 49 c1 c0 24                  	rolq	$0x24, %r8
    5802: 49 89 f6                     	movq	%rsi, %r14
    5805: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5809: 4d 31 c6                     	xorq	%r8, %r14
    580c: 49 89 f4                     	movq	%rsi, %r12
    580f: 49 c1 c4 19                  	rolq	$0x19, %r12
    5813: 4d 31 f4                     	xorq	%r14, %r12
    5816: 49 89 de                     	movq	%rbx, %r14
    5819: 4d 09 d6                     	orq	%r10, %r14
    581c: 49 21 f6                     	andq	%rsi, %r14
    581f: 49 89 d8                     	movq	%rbx, %r8
    5822: 4d 21 d0                     	andq	%r10, %r8
    5825: 4d 09 f0                     	orq	%r14, %r8
    5828: 4d 01 e0                     	addq	%r12, %r8
    582b: 4d 01 f8                     	addq	%r15, %r8
    582e: 49 89 ce                     	movq	%rcx, %r14
    5831: 49 c1 c6 32                  	rolq	$0x32, %r14
    5835: 49 89 cf                     	movq	%rcx, %r15
    5838: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    583c: 4d 31 f7                     	xorq	%r14, %r15
    583f: 49 89 cc                     	movq	%rcx, %r12
    5842: 49 c1 c4 17                  	rolq	$0x17, %r12
    5846: 4d 31 fc                     	xorq	%r15, %r12
    5849: 49 89 d6                     	movq	%rdx, %r14
    584c: 4d 31 de                     	xorq	%r11, %r14
    584f: 49 21 ce                     	andq	%rcx, %r14
    5852: 4c 03 8d 58 ff ff ff         	addq	-0xa8(%rbp), %r9
    5859: 4d 31 de                     	xorq	%r11, %r14
    585c: 4d 01 f1                     	addq	%r14, %r9
    585f: 49 be 9c 61 26 ea ce 3e 27 ca	movabsq	$-0x35d8c13115d99e64, %r14 # imm = 0xCA273ECEEA26619C
    5869: 4d 01 ce                     	addq	%r9, %r14
    586c: 4d 01 e6                     	addq	%r12, %r14
    586f: 4d 89 c1                     	movq	%r8, %r9
    5872: 49 c1 c1 24                  	rolq	$0x24, %r9
    5876: 4d 01 f2                     	addq	%r14, %r10
    5879: 4d 89 c7                     	movq	%r8, %r15
    587c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5880: 4d 31 cf                     	xorq	%r9, %r15
    5883: 4d 89 c4                     	movq	%r8, %r12
    5886: 49 c1 c4 19                  	rolq	$0x19, %r12
    588a: 4d 31 fc                     	xorq	%r15, %r12
    588d: 49 89 f7                     	movq	%rsi, %r15
    5890: 49 09 df                     	orq	%rbx, %r15
    5893: 4d 21 c7                     	andq	%r8, %r15
    5896: 49 89 f1                     	movq	%rsi, %r9
    5899: 49 21 d9                     	andq	%rbx, %r9
    589c: 4d 09 f9                     	orq	%r15, %r9
    589f: 4d 01 e1                     	addq	%r12, %r9
    58a2: 4d 01 f1                     	addq	%r14, %r9
    58a5: 4d 89 d6                     	movq	%r10, %r14
    58a8: 49 c1 c6 32                  	rolq	$0x32, %r14
    58ac: 4d 89 d7                     	movq	%r10, %r15
    58af: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    58b3: 4d 31 f7                     	xorq	%r14, %r15
    58b6: 4d 89 d4                     	movq	%r10, %r12
    58b9: 49 c1 c4 17                  	rolq	$0x17, %r12
    58bd: 4d 31 fc                     	xorq	%r15, %r12
    58c0: 49 89 ce                     	movq	%rcx, %r14
    58c3: 49 31 d6                     	xorq	%rdx, %r14
    58c6: 4d 21 d6                     	andq	%r10, %r14
    58c9: 49 31 d6                     	xorq	%rdx, %r14
    58cc: 4c 03 9d 60 ff ff ff         	addq	-0xa0(%rbp), %r11
    58d3: 4d 01 f3                     	addq	%r14, %r11
    58d6: 49 be 07 c2 c0 21 c7 b8 86 d1	movabsq	$-0x2e794738de3f3df9, %r14 # imm = 0xD186B8C721C0C207
    58e0: 4d 01 de                     	addq	%r11, %r14
    58e3: 4d 89 cb                     	movq	%r9, %r11
    58e6: 49 c1 c3 24                  	rolq	$0x24, %r11
    58ea: 4d 01 e6                     	addq	%r12, %r14
    58ed: 4d 89 cf                     	movq	%r9, %r15
    58f0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    58f4: 4c 01 f3                     	addq	%r14, %rbx
    58f7: 4d 89 cc                     	movq	%r9, %r12
    58fa: 49 c1 c4 19                  	rolq	$0x19, %r12
    58fe: 4d 31 df                     	xorq	%r11, %r15
    5901: 4d 31 fc                     	xorq	%r15, %r12
    5904: 4d 89 c7                     	movq	%r8, %r15
    5907: 49 09 f7                     	orq	%rsi, %r15
    590a: 4d 21 cf                     	andq	%r9, %r15
    590d: 4d 89 c3                     	movq	%r8, %r11
    5910: 49 21 f3                     	andq	%rsi, %r11
    5913: 4d 09 fb                     	orq	%r15, %r11
    5916: 4d 01 e3                     	addq	%r12, %r11
    5919: 49 89 df                     	movq	%rbx, %r15
    591c: 49 c1 c7 32                  	rolq	$0x32, %r15
    5920: 4d 01 f3                     	addq	%r14, %r11
    5923: 49 89 de                     	movq	%rbx, %r14
    5926: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    592a: 4d 31 fe                     	xorq	%r15, %r14
    592d: 49 89 df                     	movq	%rbx, %r15
    5930: 49 c1 c7 17                  	rolq	$0x17, %r15
    5934: 4d 31 f7                     	xorq	%r14, %r15
    5937: 4d 89 d6                     	movq	%r10, %r14
    593a: 49 31 ce                     	xorq	%rcx, %r14
    593d: 49 21 de                     	andq	%rbx, %r14
    5940: 49 31 ce                     	xorq	%rcx, %r14
    5943: 48 03 95 68 ff ff ff         	addq	-0x98(%rbp), %rdx
    594a: 4c 01 f2                     	addq	%r14, %rdx
    594d: 49 be 1e eb e0 cd d6 7d da ea	movabsq	$-0x15258229321f14e2, %r14 # imm = 0xEADA7DD6CDE0EB1E
    5957: 49 01 d6                     	addq	%rdx, %r14
    595a: 4d 01 fe                     	addq	%r15, %r14
    595d: 4c 01 f6                     	addq	%r14, %rsi
    5960: 4c 89 da                     	movq	%r11, %rdx
    5963: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5967: 4d 89 df                     	movq	%r11, %r15
    596a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    596e: 49 31 d7                     	xorq	%rdx, %r15
    5971: 4d 89 dc                     	movq	%r11, %r12
    5974: 49 c1 c4 19                  	rolq	$0x19, %r12
    5978: 4d 31 fc                     	xorq	%r15, %r12
    597b: 4d 89 cf                     	movq	%r9, %r15
    597e: 4d 09 c7                     	orq	%r8, %r15
    5981: 4d 21 df                     	andq	%r11, %r15
    5984: 4c 89 ca                     	movq	%r9, %rdx
    5987: 4c 21 c2                     	andq	%r8, %rdx
    598a: 4c 09 fa                     	orq	%r15, %rdx
    598d: 49 89 f7                     	movq	%rsi, %r15
    5990: 49 c1 c7 32                  	rolq	$0x32, %r15
    5994: 4c 01 e2                     	addq	%r12, %rdx
    5997: 49 89 f4                     	movq	%rsi, %r12
    599a: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    599e: 4c 01 f2                     	addq	%r14, %rdx
    59a1: 49 89 f6                     	movq	%rsi, %r14
    59a4: 49 c1 c6 17                  	rolq	$0x17, %r14
    59a8: 4d 31 fc                     	xorq	%r15, %r12
    59ab: 4d 31 e6                     	xorq	%r12, %r14
    59ae: 49 89 df                     	movq	%rbx, %r15
    59b1: 4d 31 d7                     	xorq	%r10, %r15
    59b4: 49 21 f7                     	andq	%rsi, %r15
    59b7: 4d 31 d7                     	xorq	%r10, %r15
    59ba: 48 03 8d 70 ff ff ff         	addq	-0x90(%rbp), %rcx
    59c1: 4c 01 f9                     	addq	%r15, %rcx
    59c4: 49 bf 78 d1 6e ee 7f 4f 7d f5	movabsq	$-0xa82b08011912e88, %r15 # imm = 0xF57D4F7FEE6ED178
    59ce: 49 01 cf                     	addq	%rcx, %r15
    59d1: 4d 01 f7                     	addq	%r14, %r15
    59d4: 4d 01 f8                     	addq	%r15, %r8
    59d7: 48 89 d1                     	movq	%rdx, %rcx
    59da: 48 c1 c1 24                  	rolq	$0x24, %rcx
    59de: 49 89 d6                     	movq	%rdx, %r14
    59e1: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    59e5: 49 31 ce                     	xorq	%rcx, %r14
    59e8: 49 89 d4                     	movq	%rdx, %r12
    59eb: 49 c1 c4 19                  	rolq	$0x19, %r12
    59ef: 4d 31 f4                     	xorq	%r14, %r12
    59f2: 4d 89 de                     	movq	%r11, %r14
    59f5: 4d 09 ce                     	orq	%r9, %r14
    59f8: 49 21 d6                     	andq	%rdx, %r14
    59fb: 4c 89 d9                     	movq	%r11, %rcx
    59fe: 4c 21 c9                     	andq	%r9, %rcx
    5a01: 4c 09 f1                     	orq	%r14, %rcx
    5a04: 4c 01 e1                     	addq	%r12, %rcx
    5a07: 4c 01 f9                     	addq	%r15, %rcx
    5a0a: 4d 89 c6                     	movq	%r8, %r14
    5a0d: 49 c1 c6 32                  	rolq	$0x32, %r14
    5a11: 4d 89 c7                     	movq	%r8, %r15
    5a14: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5a18: 4d 31 f7                     	xorq	%r14, %r15
    5a1b: 4d 89 c4                     	movq	%r8, %r12
    5a1e: 49 c1 c4 17                  	rolq	$0x17, %r12
    5a22: 4d 31 fc                     	xorq	%r15, %r12
    5a25: 49 89 f6                     	movq	%rsi, %r14
    5a28: 49 31 de                     	xorq	%rbx, %r14
    5a2b: 4d 21 c6                     	andq	%r8, %r14
    5a2e: 4c 03 95 78 ff ff ff         	addq	-0x88(%rbp), %r10
    5a35: 49 31 de                     	xorq	%rbx, %r14
    5a38: 4d 01 f2                     	addq	%r14, %r10
    5a3b: 49 be ba 6f 17 72 aa 67 f0 06	movabsq	$0x6f067aa72176fba, %r14 # imm = 0x6F067AA72176FBA
    5a45: 4d 01 d6                     	addq	%r10, %r14
    5a48: 4d 01 e6                     	addq	%r12, %r14
    5a4b: 49 89 ca                     	movq	%rcx, %r10
    5a4e: 49 c1 c2 24                  	rolq	$0x24, %r10
    5a52: 4d 01 f1                     	addq	%r14, %r9
    5a55: 49 89 cf                     	movq	%rcx, %r15
    5a58: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5a5c: 4d 31 d7                     	xorq	%r10, %r15
    5a5f: 49 89 cc                     	movq	%rcx, %r12
    5a62: 49 c1 c4 19                  	rolq	$0x19, %r12
    5a66: 4d 31 fc                     	xorq	%r15, %r12
    5a69: 49 89 d7                     	movq	%rdx, %r15
    5a6c: 4d 09 df                     	orq	%r11, %r15
    5a6f: 49 21 cf                     	andq	%rcx, %r15
    5a72: 49 89 d2                     	movq	%rdx, %r10
    5a75: 4d 21 da                     	andq	%r11, %r10
    5a78: 4d 09 fa                     	orq	%r15, %r10
    5a7b: 4d 01 e2                     	addq	%r12, %r10
    5a7e: 4d 01 f2                     	addq	%r14, %r10
    5a81: 4d 89 ce                     	movq	%r9, %r14
    5a84: 49 c1 c6 32                  	rolq	$0x32, %r14
    5a88: 4d 89 cf                     	movq	%r9, %r15
    5a8b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5a8f: 4d 31 f7                     	xorq	%r14, %r15
    5a92: 4d 89 cc                     	movq	%r9, %r12
    5a95: 49 c1 c4 17                  	rolq	$0x17, %r12
    5a99: 4d 31 fc                     	xorq	%r15, %r12
    5a9c: 4d 89 c6                     	movq	%r8, %r14
    5a9f: 49 31 f6                     	xorq	%rsi, %r14
    5aa2: 4d 21 ce                     	andq	%r9, %r14
    5aa5: 49 31 f6                     	xorq	%rsi, %r14
    5aa8: 48 03 5d 80                  	addq	-0x80(%rbp), %rbx
    5aac: 4c 01 f3                     	addq	%r14, %rbx
    5aaf: 49 be a6 98 c8 a2 c5 7d 63 0a	movabsq	$0xa637dc5a2c898a6, %r14 # imm = 0xA637DC5A2C898A6
    5ab9: 49 01 de                     	addq	%rbx, %r14
    5abc: 4c 89 d3                     	movq	%r10, %rbx
    5abf: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5ac3: 4d 01 e6                     	addq	%r12, %r14
    5ac6: 4d 89 d7                     	movq	%r10, %r15
    5ac9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5acd: 4d 01 f3                     	addq	%r14, %r11
    5ad0: 4d 89 d4                     	movq	%r10, %r12
    5ad3: 49 c1 c4 19                  	rolq	$0x19, %r12
    5ad7: 49 31 df                     	xorq	%rbx, %r15
    5ada: 4d 31 fc                     	xorq	%r15, %r12
    5add: 49 89 cf                     	movq	%rcx, %r15
    5ae0: 49 09 d7                     	orq	%rdx, %r15
    5ae3: 4d 21 d7                     	andq	%r10, %r15
    5ae6: 48 89 cb                     	movq	%rcx, %rbx
    5ae9: 48 21 d3                     	andq	%rdx, %rbx
    5aec: 4c 09 fb                     	orq	%r15, %rbx
    5aef: 4c 01 e3                     	addq	%r12, %rbx
    5af2: 4d 89 df                     	movq	%r11, %r15
    5af5: 49 c1 c7 32                  	rolq	$0x32, %r15
    5af9: 4c 01 f3                     	addq	%r14, %rbx
    5afc: 4d 89 de                     	movq	%r11, %r14
    5aff: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5b03: 4d 31 fe                     	xorq	%r15, %r14
    5b06: 4d 89 df                     	movq	%r11, %r15
    5b09: 49 c1 c7 17                  	rolq	$0x17, %r15
    5b0d: 4d 31 f7                     	xorq	%r14, %r15
    5b10: 4d 89 ce                     	movq	%r9, %r14
    5b13: 4d 31 c6                     	xorq	%r8, %r14
    5b16: 4d 21 de                     	andq	%r11, %r14
    5b19: 4d 31 c6                     	xorq	%r8, %r14
    5b1c: 48 03 75 88                  	addq	-0x78(%rbp), %rsi
    5b20: 4c 01 f6                     	addq	%r14, %rsi
    5b23: 49 be ae 0d f9 be 04 98 3f 11	movabsq	$0x113f9804bef90dae, %r14 # imm = 0x113F9804BEF90DAE
    5b2d: 49 01 f6                     	addq	%rsi, %r14
    5b30: 4d 01 fe                     	addq	%r15, %r14
    5b33: 4c 01 f2                     	addq	%r14, %rdx
    5b36: 48 89 de                     	movq	%rbx, %rsi
    5b39: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5b3d: 49 89 df                     	movq	%rbx, %r15
    5b40: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5b44: 49 31 f7                     	xorq	%rsi, %r15
    5b47: 49 89 dc                     	movq	%rbx, %r12
    5b4a: 49 c1 c4 19                  	rolq	$0x19, %r12
    5b4e: 4d 31 fc                     	xorq	%r15, %r12
    5b51: 4d 89 d7                     	movq	%r10, %r15
    5b54: 49 09 cf                     	orq	%rcx, %r15
    5b57: 49 21 df                     	andq	%rbx, %r15
    5b5a: 4c 89 d6                     	movq	%r10, %rsi
    5b5d: 48 21 ce                     	andq	%rcx, %rsi
    5b60: 4c 09 fe                     	orq	%r15, %rsi
    5b63: 49 89 d7                     	movq	%rdx, %r15
    5b66: 49 c1 c7 32                  	rolq	$0x32, %r15
    5b6a: 4c 01 e6                     	addq	%r12, %rsi
    5b6d: 49 89 d4                     	movq	%rdx, %r12
    5b70: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5b74: 4c 01 f6                     	addq	%r14, %rsi
    5b77: 49 89 d6                     	movq	%rdx, %r14
    5b7a: 49 c1 c6 17                  	rolq	$0x17, %r14
    5b7e: 4d 31 fc                     	xorq	%r15, %r12
    5b81: 4d 31 e6                     	xorq	%r12, %r14
    5b84: 4d 89 df                     	movq	%r11, %r15
    5b87: 4d 31 cf                     	xorq	%r9, %r15
    5b8a: 49 21 d7                     	andq	%rdx, %r15
    5b8d: 4d 31 cf                     	xorq	%r9, %r15
    5b90: 4c 03 45 90                  	addq	-0x70(%rbp), %r8
    5b94: 4d 01 f8                     	addq	%r15, %r8
    5b97: 49 bf 1b 47 1c 13 35 0b 71 1b	movabsq	$0x1b710b35131c471b, %r15 # imm = 0x1B710B35131C471B
    5ba1: 4d 01 c7                     	addq	%r8, %r15
    5ba4: 4d 01 f7                     	addq	%r14, %r15
    5ba7: 4c 01 f9                     	addq	%r15, %rcx
    5baa: 49 89 f0                     	movq	%rsi, %r8
    5bad: 49 c1 c0 24                  	rolq	$0x24, %r8
    5bb1: 49 89 f6                     	movq	%rsi, %r14
    5bb4: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5bb8: 4d 31 c6                     	xorq	%r8, %r14
    5bbb: 49 89 f4                     	movq	%rsi, %r12
    5bbe: 49 c1 c4 19                  	rolq	$0x19, %r12
    5bc2: 4d 31 f4                     	xorq	%r14, %r12
    5bc5: 49 89 de                     	movq	%rbx, %r14
    5bc8: 4d 09 d6                     	orq	%r10, %r14
    5bcb: 49 21 f6                     	andq	%rsi, %r14
    5bce: 49 89 d8                     	movq	%rbx, %r8
    5bd1: 4d 21 d0                     	andq	%r10, %r8
    5bd4: 4d 09 f0                     	orq	%r14, %r8
    5bd7: 4d 01 e0                     	addq	%r12, %r8
    5bda: 4d 01 f8                     	addq	%r15, %r8
    5bdd: 49 89 ce                     	movq	%rcx, %r14
    5be0: 49 c1 c6 32                  	rolq	$0x32, %r14
    5be4: 49 89 cf                     	movq	%rcx, %r15
    5be7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5beb: 4d 31 f7                     	xorq	%r14, %r15
    5bee: 49 89 cc                     	movq	%rcx, %r12
    5bf1: 49 c1 c4 17                  	rolq	$0x17, %r12
    5bf5: 4d 31 fc                     	xorq	%r15, %r12
    5bf8: 49 89 d6                     	movq	%rdx, %r14
    5bfb: 4d 31 de                     	xorq	%r11, %r14
    5bfe: 49 21 ce                     	andq	%rcx, %r14
    5c01: 4c 03 4d 98                  	addq	-0x68(%rbp), %r9
    5c05: 4d 31 de                     	xorq	%r11, %r14
    5c08: 4d 01 f1                     	addq	%r14, %r9
    5c0b: 49 be 84 7d 04 23 f5 77 db 28	movabsq	$0x28db77f523047d84, %r14 # imm = 0x28DB77F523047D84
    5c15: 4d 01 ce                     	addq	%r9, %r14
    5c18: 4d 01 e6                     	addq	%r12, %r14
    5c1b: 4d 89 c1                     	movq	%r8, %r9
    5c1e: 49 c1 c1 24                  	rolq	$0x24, %r9
    5c22: 4d 01 f2                     	addq	%r14, %r10
    5c25: 4d 89 c7                     	movq	%r8, %r15
    5c28: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5c2c: 4d 31 cf                     	xorq	%r9, %r15
    5c2f: 4d 89 c4                     	movq	%r8, %r12
    5c32: 49 c1 c4 19                  	rolq	$0x19, %r12
    5c36: 4d 31 fc                     	xorq	%r15, %r12
    5c39: 49 89 f7                     	movq	%rsi, %r15
    5c3c: 49 09 df                     	orq	%rbx, %r15
    5c3f: 4d 21 c7                     	andq	%r8, %r15
    5c42: 49 89 f1                     	movq	%rsi, %r9
    5c45: 49 21 d9                     	andq	%rbx, %r9
    5c48: 4d 09 f9                     	orq	%r15, %r9
    5c4b: 4d 01 e1                     	addq	%r12, %r9
    5c4e: 4d 01 f1                     	addq	%r14, %r9
    5c51: 4d 89 d6                     	movq	%r10, %r14
    5c54: 49 c1 c6 32                  	rolq	$0x32, %r14
    5c58: 4d 89 d7                     	movq	%r10, %r15
    5c5b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5c5f: 4d 31 f7                     	xorq	%r14, %r15
    5c62: 4d 89 d4                     	movq	%r10, %r12
    5c65: 49 c1 c4 17                  	rolq	$0x17, %r12
    5c69: 4d 31 fc                     	xorq	%r15, %r12
    5c6c: 49 89 ce                     	movq	%rcx, %r14
    5c6f: 49 31 d6                     	xorq	%rdx, %r14
    5c72: 4d 21 d6                     	andq	%r10, %r14
    5c75: 49 31 d6                     	xorq	%rdx, %r14
    5c78: 4c 03 5d a0                  	addq	-0x60(%rbp), %r11
    5c7c: 4d 01 f3                     	addq	%r14, %r11
    5c7f: 49 be 93 24 c7 40 7b ab ca 32	movabsq	$0x32caab7b40c72493, %r14 # imm = 0x32CAAB7B40C72493
    5c89: 4d 01 de                     	addq	%r11, %r14
    5c8c: 4d 89 cb                     	movq	%r9, %r11
    5c8f: 49 c1 c3 24                  	rolq	$0x24, %r11
    5c93: 4d 01 e6                     	addq	%r12, %r14
    5c96: 4d 89 cf                     	movq	%r9, %r15
    5c99: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5c9d: 4c 01 f3                     	addq	%r14, %rbx
    5ca0: 4d 89 cc                     	movq	%r9, %r12
    5ca3: 49 c1 c4 19                  	rolq	$0x19, %r12
    5ca7: 4d 31 df                     	xorq	%r11, %r15
    5caa: 4d 31 fc                     	xorq	%r15, %r12
    5cad: 4d 89 c7                     	movq	%r8, %r15
    5cb0: 49 09 f7                     	orq	%rsi, %r15
    5cb3: 4d 21 cf                     	andq	%r9, %r15
    5cb6: 4d 89 c3                     	movq	%r8, %r11
    5cb9: 49 21 f3                     	andq	%rsi, %r11
    5cbc: 4d 09 fb                     	orq	%r15, %r11
    5cbf: 4d 01 e3                     	addq	%r12, %r11
    5cc2: 49 89 df                     	movq	%rbx, %r15
    5cc5: 49 c1 c7 32                  	rolq	$0x32, %r15
    5cc9: 4d 01 f3                     	addq	%r14, %r11
    5ccc: 49 89 de                     	movq	%rbx, %r14
    5ccf: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5cd3: 4d 31 fe                     	xorq	%r15, %r14
    5cd6: 49 89 df                     	movq	%rbx, %r15
    5cd9: 49 c1 c7 17                  	rolq	$0x17, %r15
    5cdd: 4d 31 f7                     	xorq	%r14, %r15
    5ce0: 4d 89 d6                     	movq	%r10, %r14
    5ce3: 49 31 ce                     	xorq	%rcx, %r14
    5ce6: 49 21 de                     	andq	%rbx, %r14
    5ce9: 49 31 ce                     	xorq	%rcx, %r14
    5cec: 48 03 55 a8                  	addq	-0x58(%rbp), %rdx
    5cf0: 4c 01 f2                     	addq	%r14, %rdx
    5cf3: 49 be bc be c9 15 0a be 9e 3c	movabsq	$0x3c9ebe0a15c9bebc, %r14 # imm = 0x3C9EBE0A15C9BEBC
    5cfd: 49 01 d6                     	addq	%rdx, %r14
    5d00: 4d 01 fe                     	addq	%r15, %r14
    5d03: 4c 01 f6                     	addq	%r14, %rsi
    5d06: 4c 89 da                     	movq	%r11, %rdx
    5d09: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5d0d: 4d 89 df                     	movq	%r11, %r15
    5d10: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5d14: 49 31 d7                     	xorq	%rdx, %r15
    5d17: 4d 89 dc                     	movq	%r11, %r12
    5d1a: 49 c1 c4 19                  	rolq	$0x19, %r12
    5d1e: 4d 31 fc                     	xorq	%r15, %r12
    5d21: 4d 89 cf                     	movq	%r9, %r15
    5d24: 4d 09 c7                     	orq	%r8, %r15
    5d27: 4d 21 df                     	andq	%r11, %r15
    5d2a: 4c 89 ca                     	movq	%r9, %rdx
    5d2d: 4c 21 c2                     	andq	%r8, %rdx
    5d30: 4c 09 fa                     	orq	%r15, %rdx
    5d33: 49 89 f7                     	movq	%rsi, %r15
    5d36: 49 c1 c7 32                  	rolq	$0x32, %r15
    5d3a: 4c 01 e2                     	addq	%r12, %rdx
    5d3d: 49 89 f4                     	movq	%rsi, %r12
    5d40: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5d44: 4c 01 f2                     	addq	%r14, %rdx
    5d47: 49 89 f6                     	movq	%rsi, %r14
    5d4a: 49 c1 c6 17                  	rolq	$0x17, %r14
    5d4e: 4d 31 fc                     	xorq	%r15, %r12
    5d51: 4d 31 e6                     	xorq	%r12, %r14
    5d54: 49 89 df                     	movq	%rbx, %r15
    5d57: 4d 31 d7                     	xorq	%r10, %r15
    5d5a: 49 21 f7                     	andq	%rsi, %r15
    5d5d: 4d 31 d7                     	xorq	%r10, %r15
    5d60: 48 03 4d b0                  	addq	-0x50(%rbp), %rcx
    5d64: 4c 01 f9                     	addq	%r15, %rcx
    5d67: 49 bf 4c 0d 10 9c c4 67 1d 43	movabsq	$0x431d67c49c100d4c, %r15 # imm = 0x431D67C49C100D4C
    5d71: 49 01 cf                     	addq	%rcx, %r15
    5d74: 4d 01 f7                     	addq	%r14, %r15
    5d77: 4d 01 f8                     	addq	%r15, %r8
    5d7a: 48 89 d1                     	movq	%rdx, %rcx
    5d7d: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5d81: 49 89 d6                     	movq	%rdx, %r14
    5d84: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5d88: 49 31 ce                     	xorq	%rcx, %r14
    5d8b: 49 89 d4                     	movq	%rdx, %r12
    5d8e: 49 c1 c4 19                  	rolq	$0x19, %r12
    5d92: 4d 31 f4                     	xorq	%r14, %r12
    5d95: 4d 89 de                     	movq	%r11, %r14
    5d98: 4d 09 ce                     	orq	%r9, %r14
    5d9b: 49 21 d6                     	andq	%rdx, %r14
    5d9e: 4c 89 d9                     	movq	%r11, %rcx
    5da1: 4c 21 c9                     	andq	%r9, %rcx
    5da4: 4c 09 f1                     	orq	%r14, %rcx
    5da7: 4c 01 e1                     	addq	%r12, %rcx
    5daa: 4c 01 f9                     	addq	%r15, %rcx
    5dad: 4d 89 c6                     	movq	%r8, %r14
    5db0: 49 c1 c6 32                  	rolq	$0x32, %r14
    5db4: 4d 89 c7                     	movq	%r8, %r15
    5db7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5dbb: 4d 31 f7                     	xorq	%r14, %r15
    5dbe: 4d 89 c4                     	movq	%r8, %r12
    5dc1: 49 c1 c4 17                  	rolq	$0x17, %r12
    5dc5: 4d 31 fc                     	xorq	%r15, %r12
    5dc8: 49 89 f6                     	movq	%rsi, %r14
    5dcb: 49 31 de                     	xorq	%rbx, %r14
    5dce: 4d 21 c6                     	andq	%r8, %r14
    5dd1: 4c 03 55 b8                  	addq	-0x48(%rbp), %r10
    5dd5: 49 31 de                     	xorq	%rbx, %r14
    5dd8: 4d 01 f2                     	addq	%r14, %r10
    5ddb: 49 be b6 42 3e cb be d4 c5 4c	movabsq	$0x4cc5d4becb3e42b6, %r14 # imm = 0x4CC5D4BECB3E42B6
    5de5: 4d 01 d6                     	addq	%r10, %r14
    5de8: 4d 01 e6                     	addq	%r12, %r14
    5deb: 49 89 ca                     	movq	%rcx, %r10
    5dee: 49 c1 c2 24                  	rolq	$0x24, %r10
    5df2: 4d 01 f1                     	addq	%r14, %r9
    5df5: 49 89 cf                     	movq	%rcx, %r15
    5df8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5dfc: 4d 31 d7                     	xorq	%r10, %r15
    5dff: 49 89 cc                     	movq	%rcx, %r12
    5e02: 49 c1 c4 19                  	rolq	$0x19, %r12
    5e06: 4d 31 fc                     	xorq	%r15, %r12
    5e09: 49 89 d7                     	movq	%rdx, %r15
    5e0c: 4d 09 df                     	orq	%r11, %r15
    5e0f: 49 21 cf                     	andq	%rcx, %r15
    5e12: 49 89 d2                     	movq	%rdx, %r10
    5e15: 4d 21 da                     	andq	%r11, %r10
    5e18: 4d 09 fa                     	orq	%r15, %r10
    5e1b: 4d 01 e2                     	addq	%r12, %r10
    5e1e: 4d 01 f2                     	addq	%r14, %r10
    5e21: 4d 89 ce                     	movq	%r9, %r14
    5e24: 49 c1 c6 32                  	rolq	$0x32, %r14
    5e28: 4d 89 cf                     	movq	%r9, %r15
    5e2b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5e2f: 4d 31 f7                     	xorq	%r14, %r15
    5e32: 4d 89 cc                     	movq	%r9, %r12
    5e35: 49 c1 c4 17                  	rolq	$0x17, %r12
    5e39: 4d 31 fc                     	xorq	%r15, %r12
    5e3c: 4d 89 c6                     	movq	%r8, %r14
    5e3f: 49 31 f6                     	xorq	%rsi, %r14
    5e42: 4d 21 ce                     	andq	%r9, %r14
    5e45: 49 31 f6                     	xorq	%rsi, %r14
    5e48: 48 03 5d c0                  	addq	-0x40(%rbp), %rbx
    5e4c: 4c 01 f3                     	addq	%r14, %rbx
    5e4f: 49 be 2a 7e 65 fc 9c 29 7f 59	movabsq	$0x597f299cfc657e2a, %r14 # imm = 0x597F299CFC657E2A
    5e59: 49 01 de                     	addq	%rbx, %r14
    5e5c: 4c 89 d3                     	movq	%r10, %rbx
    5e5f: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5e63: 4d 01 e6                     	addq	%r12, %r14
    5e66: 4d 89 d7                     	movq	%r10, %r15
    5e69: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5e6d: 4d 01 f3                     	addq	%r14, %r11
    5e70: 4d 89 d4                     	movq	%r10, %r12
    5e73: 49 c1 c4 19                  	rolq	$0x19, %r12
    5e77: 49 31 df                     	xorq	%rbx, %r15
    5e7a: 4d 31 fc                     	xorq	%r15, %r12
    5e7d: 49 89 cf                     	movq	%rcx, %r15
    5e80: 49 09 d7                     	orq	%rdx, %r15
    5e83: 4d 21 d7                     	andq	%r10, %r15
    5e86: 48 89 cb                     	movq	%rcx, %rbx
    5e89: 48 21 d3                     	andq	%rdx, %rbx
    5e8c: 4c 09 fb                     	orq	%r15, %rbx
    5e8f: 4c 01 e3                     	addq	%r12, %rbx
    5e92: 4d 89 df                     	movq	%r11, %r15
    5e95: 49 c1 c7 32                  	rolq	$0x32, %r15
    5e99: 4c 01 f3                     	addq	%r14, %rbx
    5e9c: 4d 89 de                     	movq	%r11, %r14
    5e9f: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5ea3: 4d 31 fe                     	xorq	%r15, %r14
    5ea6: 4d 89 df                     	movq	%r11, %r15
    5ea9: 49 c1 c7 17                  	rolq	$0x17, %r15
    5ead: 4d 31 f7                     	xorq	%r14, %r15
    5eb0: 4d 89 ce                     	movq	%r9, %r14
    5eb3: 4d 31 c6                     	xorq	%r8, %r14
    5eb6: 4d 21 de                     	andq	%r11, %r14
    5eb9: 4d 31 c6                     	xorq	%r8, %r14
    5ebc: 48 03 75 c8                  	addq	-0x38(%rbp), %rsi
    5ec0: 4c 01 f6                     	addq	%r14, %rsi
    5ec3: 49 be ec fa d6 3a ab 6f cb 5f	movabsq	$0x5fcb6fab3ad6faec, %r14 # imm = 0x5FCB6FAB3AD6FAEC
    5ecd: 49 01 f6                     	addq	%rsi, %r14
    5ed0: 4d 01 fe                     	addq	%r15, %r14
    5ed3: 4c 01 f2                     	addq	%r14, %rdx
    5ed6: 48 89 de                     	movq	%rbx, %rsi
    5ed9: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5edd: 49 89 df                     	movq	%rbx, %r15
    5ee0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5ee4: 49 31 f7                     	xorq	%rsi, %r15
    5ee7: 49 89 dc                     	movq	%rbx, %r12
    5eea: 49 c1 c4 19                  	rolq	$0x19, %r12
    5eee: 4d 31 fc                     	xorq	%r15, %r12
    5ef1: 4d 89 d7                     	movq	%r10, %r15
    5ef4: 49 09 cf                     	orq	%rcx, %r15
    5ef7: 49 21 df                     	andq	%rbx, %r15
    5efa: 4c 89 d6                     	movq	%r10, %rsi
    5efd: 48 21 ce                     	andq	%rcx, %rsi
    5f00: 4c 09 fe                     	orq	%r15, %rsi
    5f03: 49 89 d7                     	movq	%rdx, %r15
    5f06: 49 c1 c7 32                  	rolq	$0x32, %r15
    5f0a: 4c 01 e6                     	addq	%r12, %rsi
    5f0d: 49 89 d4                     	movq	%rdx, %r12
    5f10: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5f14: 4c 01 f6                     	addq	%r14, %rsi
    5f17: 49 89 d5                     	movq	%rdx, %r13
    5f1a: 49 c1 c5 17                  	rolq	$0x17, %r13
    5f1e: 4d 31 fc                     	xorq	%r15, %r12
    5f21: 4d 31 e5                     	xorq	%r12, %r13
    5f24: 4d 89 de                     	movq	%r11, %r14
    5f27: 4d 31 ce                     	xorq	%r9, %r14
    5f2a: 49 21 d6                     	andq	%rdx, %r14
    5f2d: 4d 31 ce                     	xorq	%r9, %r14
    5f30: 4c 03 45 d0                  	addq	-0x30(%rbp), %r8
    5f34: 4d 01 f0                     	addq	%r14, %r8
    5f37: 49 be 17 58 47 4a 8c 19 44 6c	movabsq	$0x6c44198c4a475817, %r14 # imm = 0x6C44198C4A475817
    5f41: 4d 01 c6                     	addq	%r8, %r14
    5f44: 4d 01 ee                     	addq	%r13, %r14
    5f47: 49 89 f0                     	movq	%rsi, %r8
    5f4a: 49 c1 c0 24                  	rolq	$0x24, %r8
    5f4e: 49 89 f7                     	movq	%rsi, %r15
    5f51: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5f55: 4d 31 c7                     	xorq	%r8, %r15
    5f58: 49 89 f0                     	movq	%rsi, %r8
    5f5b: 49 c1 c0 19                  	rolq	$0x19, %r8
    5f5f: 4d 31 f8                     	xorq	%r15, %r8
    5f62: 49 89 df                     	movq	%rbx, %r15
    5f65: 4d 09 d7                     	orq	%r10, %r15
    5f68: 49 21 f7                     	andq	%rsi, %r15
    5f6b: 49 89 dc                     	movq	%rbx, %r12
    5f6e: 4d 21 d4                     	andq	%r10, %r12
    5f71: 4d 09 fc                     	orq	%r15, %r12
    5f74: 4d 01 c4                     	addq	%r8, %r12
    5f77: 4d 01 f4                     	addq	%r14, %r12
    5f7a: 49 01 c4                     	addq	%rax, %r12
    5f7d: 4c 89 67 10                  	movq	%r12, 0x10(%rdi)
    5f81: 48 01 77 18                  	addq	%rsi, 0x18(%rdi)
    5f85: 48 01 5f 20                  	addq	%rbx, 0x20(%rdi)
    5f89: 4c 01 57 28                  	addq	%r10, 0x28(%rdi)
    5f8d: 4c 01 f1                     	addq	%r14, %rcx
    5f90: 48 01 4f 30                  	addq	%rcx, 0x30(%rdi)
    5f94: 48 01 57 38                  	addq	%rdx, 0x38(%rdi)
    5f98: 4c 01 5f 40                  	addq	%r11, 0x40(%rdi)
    5f9c: 4c 01 4f 48                  	addq	%r9, 0x48(%rdi)
    5fa0: 48 81 c4 00 02 00 00         	addq	$0x200, %rsp            # imm = 0x200
    5fa7: 5b                           	popq	%rbx
    5fa8: 41 5c                        	popq	%r12
    5faa: 41 5d                        	popq	%r13
    5fac: 41 5e                        	popq	%r14
    5fae: 41 5f                        	popq	%r15
    5fb0: 5d                           	popq	%rbp
    5fb1: c3                           	retq
    5fb2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    5fbc: 0f 1f 40 00                  	nopl	(%rax)

0000000000005fc0 <audit_master384>:
    5fc0: 55                           	pushq	%rbp
    5fc1: 48 89 e5                     	movq	%rsp, %rbp
    5fc4: 41 56                        	pushq	%r14
    5fc6: 53                           	pushq	%rbx
    5fc7: 48 81 ec 70 01 00 00         	subq	$0x170, %rsp            # imm = 0x170
    5fce: 48 89 f3                     	movq	%rsi, %rbx
    5fd1: 49 89 f8                     	movq	%rdi, %r8
    5fd4: 66 c7 85 b0 fe ff ff 00 30   	movw	$0x3000, -0x150(%rbp)   # imm = 0x3000
    5fdd: c6 85 b2 fe ff ff 0d         	movb	$0xd, -0x14e(%rbp)
    5fe4: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    5fee: 48 89 85 b3 fe ff ff         	movq	%rax, -0x14d(%rbp)
    5ff5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    5fff: 48 89 85 b8 fe ff ff         	movq	%rax, -0x148(%rbp)
    6006: c6 85 c0 fe ff ff 30         	movb	$0x30, -0x140(%rbp)
    600d: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x54>
		0000000000006010:  R_X86_64_PC32	.rodata+0x6c
    6014: 0f 11 85 c1 fe ff ff         	movups	%xmm0, -0x13f(%rbp)
    601b: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x62>
		000000000000601e:  R_X86_64_PC32	.rodata+0x7c
    6022: 0f 11 85 d1 fe ff ff         	movups	%xmm0, -0x12f(%rbp)
    6029: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x70>
		000000000000602c:  R_X86_64_PC32	.rodata+0x8c
    6030: 0f 11 85 e1 fe ff ff         	movups	%xmm0, -0x11f(%rbp)
    6037: 4c 8d b5 80 fe ff ff         	leaq	-0x180(%rbp), %r14
    603e: 48 8d 95 b0 fe ff ff         	leaq	-0x150(%rbp), %rdx
    6045: be 30 00 00 00               	movl	$0x30, %esi
    604a: b9 41 00 00 00               	movl	$0x41, %ecx
    604f: 4c 89 f7                     	movq	%r14, %rdi
    6052: e8 09 cd ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    6057: 48 8d 7d c0                  	leaq	-0x40(%rbp), %rdi
    605b: ba 00 00 00 00               	movl	$0x0, %edx
		000000000000605c:  R_X86_64_32	.rodata+0x190
    6060: 4c 89 f6                     	movq	%r14, %rsi
    6063: e8 f8 c9 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    6068: 0f 10 45 c0                  	movups	-0x40(%rbp), %xmm0
    606c: 0f 10 4d d0                  	movups	-0x30(%rbp), %xmm1
    6070: 0f 10 55 e0                  	movups	-0x20(%rbp), %xmm2
    6074: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    6078: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    607c: 0f 11 03                     	movups	%xmm0, (%rbx)
    607f: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            # imm = 0x170
    6086: 5b                           	popq	%rbx
    6087: 41 5e                        	popq	%r14
    6089: 5d                           	popq	%rbp
    608a: c3                           	retq
    608b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

0000000000006090 <audit_key384>:
    6090: 55                           	pushq	%rbp
    6091: 48 89 e5                     	movq	%rsp, %rbp
    6094: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            # imm = 0x110
    609b: 48 89 f0                     	movq	%rsi, %rax
    609e: 49 89 f8                     	movq	%rdi, %r8
    60a1: 66 c7 85 f4 fe ff ff 00 20   	movw	$0x2000, -0x10c(%rbp)   # imm = 0x2000
    60aa: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    60b1: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
    60bb: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    60c2: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    60cb: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    60d2: be 20 00 00 00               	movl	$0x20, %esi
    60d7: b9 0d 00 00 00               	movl	$0xd, %ecx
    60dc: 48 89 c7                     	movq	%rax, %rdi
    60df: e8 7c cc ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    60e4: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            # imm = 0x110
    60eb: 5d                           	popq	%rbp
    60ec: c3                           	retq
