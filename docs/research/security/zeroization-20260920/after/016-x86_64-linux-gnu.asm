
/tmp/ztls-signoff-20260919/125-after-direct-buffers/016-x86_64-linux-gnu.o:	file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <audit_key384>:
       0: 55                           	pushq	%rbp
       1: 48 89 e5                     	movq	%rsp, %rbp
       4: 48 81 ec 40 01 00 00         	subq	$0x140, %rsp            # imm = 0x140
       b: 48 89 f0                     	movq	%rsi, %rax
       e: 0f 10 07                     	movups	(%rdi), %xmm0
      11: 0f 10 4f 10                  	movups	0x10(%rdi), %xmm1
      15: 0f 10 57 20                  	movups	0x20(%rdi), %xmm2
      19: 0f 29 55 f0                  	movaps	%xmm2, -0x10(%rbp)
      1d: 0f 29 4d e0                  	movaps	%xmm1, -0x20(%rbp)
      21: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
      25: 66 c7 85 c4 fe ff ff 00 20   	movw	$0x2000, -0x13c(%rbp)   # imm = 0x2000
      2e: c6 85 c6 fe ff ff 09         	movb	$0x9, -0x13a(%rbp)
      35: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
      3f: 48 89 8d c7 fe ff ff         	movq	%rcx, -0x139(%rbp)
      46: 66 c7 85 cf fe ff ff 79 00   	movw	$0x79, -0x131(%rbp)
      4f: 48 8d 95 c4 fe ff ff         	leaq	-0x13c(%rbp), %rdx
      56: 4c 8d 45 d0                  	leaq	-0x30(%rbp), %r8
      5a: be 20 00 00 00               	movl	$0x20, %esi
      5f: b9 0d 00 00 00               	movl	$0xd, %ecx
      64: 48 89 c7                     	movq	%rax, %rdi
      67: e8 14 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
      6c: 48 81 c4 40 01 00 00         	addq	$0x140, %rsp            # imm = 0x140
      73: 5d                           	popq	%rbp
      74: c3                           	retq
      75: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
      7f: 90                           	nop

0000000000000080 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
      80: 55                           	pushq	%rbp
      81: 48 89 e5                     	movq	%rsp, %rbp
      84: 41 57                        	pushq	%r15
      86: 41 56                        	pushq	%r14
      88: 41 55                        	pushq	%r13
      8a: 41 54                        	pushq	%r12
      8c: 53                           	pushq	%rbx
      8d: 48 81 ec c8 05 00 00         	subq	$0x5c8, %rsp            # imm = 0x5C8
      94: 48 89 55 b8                  	movq	%rdx, -0x48(%rbp)
      98: 48 89 7d c8                  	movq	%rdi, -0x38(%rbp)
      9c: 41 0f 10 00                  	movups	(%r8), %xmm0
      a0: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
      a5: 41 0f 10 50 20               	movups	0x20(%r8), %xmm2
      aa: 0f 29 95 00 ff ff ff         	movaps	%xmm2, -0x100(%rbp)
      b1: 0f 29 8d f0 fe ff ff         	movaps	%xmm1, -0x110(%rbp)
      b8: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
      bf: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
      c3: 48 89 75 a8                  	movq	%rsi, -0x58(%rbp)
      c7: 48 83 fe 30                  	cmpq	$0x30, %rsi
      cb: 48 89 4d a0                  	movq	%rcx, -0x60(%rbp)
      cf: 0f 83 d2 01 00 00            	jae	 <L5>
      d5: 48 c7 45 b0 00 00 00 00      	movq	$0x0, -0x50(%rbp)
<L0>:
      dd: 48 8b 45 a8                  	movq	-0x58(%rbp), %rax
      e1: 48 89 c1                     	movq	%rax, %rcx
      e4: 48 83 e9 30                  	subq	$0x30, %rcx
      e8: 48 0f 42 c8                  	cmovbq	%rax, %rcx
      ec: 48 85 c9                     	testq	%rcx, %rcx
      ef: 0f 84 36 09 00 00            	je	 <L55>
      f5: 48 89 4d c0                  	movq	%rcx, -0x40(%rbp)
      f9: 0f 28 85 e0 fe ff ff         	movaps	-0x120(%rbp), %xmm0
     100: 0f 28 8d f0 fe ff ff         	movaps	-0x110(%rbp), %xmm1
     107: 0f 28 95 00 ff ff ff         	movaps	-0x100(%rbp), %xmm2
     10e: 0f 29 95 30 ff ff ff         	movaps	%xmm2, -0xd0(%rbp)
     115: 0f 29 8d 20 ff ff ff         	movaps	%xmm1, -0xe0(%rbp)
     11c: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     123: 0f 57 c0                     	xorps	%xmm0, %xmm0
     126: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
     12d: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     134: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     13b: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     142: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     146: 31 c0                        	xorl	%eax, %eax
     148: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L1>:
     150: 0f b6 8c 05 10 ff ff ff      	movzbl	-0xf0(%rbp,%rax), %ecx
     158: 0f b6 94 05 11 ff ff ff      	movzbl	-0xef(%rbp,%rax), %edx
     160: 80 f1 5c                     	xorb	$0x5c, %cl
     163: 88 8c 05 00 fd ff ff         	movb	%cl, -0x300(%rbp,%rax)
     16a: 80 f2 5c                     	xorb	$0x5c, %dl
     16d: 88 94 05 01 fd ff ff         	movb	%dl, -0x2ff(%rbp,%rax)
     174: 0f b6 8c 05 12 ff ff ff      	movzbl	-0xee(%rbp,%rax), %ecx
     17c: 80 f1 5c                     	xorb	$0x5c, %cl
     17f: 88 8c 05 02 fd ff ff         	movb	%cl, -0x2fe(%rbp,%rax)
     186: 0f b6 8c 05 13 ff ff ff      	movzbl	-0xed(%rbp,%rax), %ecx
     18e: 80 f1 5c                     	xorb	$0x5c, %cl
     191: 88 8c 05 03 fd ff ff         	movb	%cl, -0x2fd(%rbp,%rax)
     198: 48 83 c0 04                  	addq	$0x4, %rax
     19c: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
     1a2: 75 ac                        	jne	 <L1>
     1a4: b8 03 00 00 00               	movl	$0x3, %eax
     1a9: 4c 8b 7d a0                  	movq	-0x60(%rbp), %r15
     1ad: 0f 1f 00                     	nopl	(%rax)
<L2>:
     1b0: 0f b6 8c 05 0d ff ff ff      	movzbl	-0xf3(%rbp,%rax), %ecx
     1b8: 0f b6 94 05 0e ff ff ff      	movzbl	-0xf2(%rbp,%rax), %edx
     1c0: 80 f1 36                     	xorb	$0x36, %cl
     1c3: 88 8c 05 7d fd ff ff         	movb	%cl, -0x283(%rbp,%rax)
     1ca: 80 f2 36                     	xorb	$0x36, %dl
     1cd: 88 94 05 7e fd ff ff         	movb	%dl, -0x282(%rbp,%rax)
     1d4: 0f b6 8c 05 0f ff ff ff      	movzbl	-0xf1(%rbp,%rax), %ecx
     1dc: 80 f1 36                     	xorb	$0x36, %cl
     1df: 88 8c 05 7f fd ff ff         	movb	%cl, -0x281(%rbp,%rax)
     1e6: 0f b6 8c 05 10 ff ff ff      	movzbl	-0xf0(%rbp,%rax), %ecx
     1ee: 80 f1 36                     	xorb	$0x36, %cl
     1f1: 88 8c 05 80 fd ff ff         	movb	%cl, -0x280(%rbp,%rax)
     1f8: 48 83 c0 04                  	addq	$0x4, %rax
     1fc: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
     202: 75 ac                        	jne	 <L2>
     204: 48 8d 9d 20 fc ff ff         	leaq	-0x3e0(%rbp), %rbx
     20b: be 00 00 00 00               	movl	$0x0, %esi
		000000000000020c:  R_X86_64_32	.rodata+0x10
     210: ba e0 00 00 00               	movl	$0xe0, %edx
     215: 48 89 df                     	movq	%rbx, %rdi
     218: e8 00 00 00 00               	callq	 <L3>
		0000000000000219:  R_X86_64_PLT32	memcpy-0x4
<L3>:
     21d: 48 8d b5 80 fd ff ff         	leaq	-0x280(%rbp), %rsi
     224: 48 89 df                     	movq	%rbx, %rdi
     227: e8 14 08 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     22c: 48 81 85 20 fc ff ff 80 00 00 00     	addq	$0x80, -0x3e0(%rbp)
     237: 48 83 95 28 fc ff ff 00      	adcq	$0x0, -0x3d8(%rbp)
     23f: 0f b6 85 f0 fc ff ff         	movzbl	-0x310(%rbp), %eax
     246: 48 83 7d a8 2f               	cmpq	$0x2f, -0x58(%rbp)
     24b: 0f 86 61 05 00 00            	jbe	 <L37>
     251: 84 c0                        	testb	%al, %al
     253: 0f 84 0d 05 00 00            	je	 <L33>
     259: 3c 50                        	cmpb	$0x50, %al
     25b: 0f 82 07 05 00 00            	jb	 <L34>
     261: 0f b6 c0                     	movzbl	%al, %eax
     264: bb 80 00 00 00               	movl	$0x80, %ebx
     269: 48 29 c3                     	subq	%rax, %rbx
     26c: 4c 8d b5 70 fc ff ff         	leaq	-0x390(%rbp), %r14
     273: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     277: 48 81 c7 70 fc ff ff         	addq	$-0x390, %rdi           # imm = 0xFC70
     27e: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     282: 48 89 da                     	movq	%rbx, %rdx
     285: e8 00 00 00 00               	callq	 <L4>
		0000000000000286:  R_X86_64_PLT32	memcpy-0x4
<L4>:
     28a: 48 8d bd 20 fc ff ff         	leaq	-0x3e0(%rbp), %rdi
     291: 4c 89 f6                     	movq	%r14, %rsi
     294: e8 a7 07 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     299: c6 85 f0 fc ff ff 00         	movb	$0x0, -0x310(%rbp)
     2a0: 31 c0                        	xorl	%eax, %eax
     2a2: e9 c3 04 00 00               	jmp	 <L35>
<L5>:
     2a7: 48 83 f1 7f                  	xorq	$0x7f, %rcx
     2ab: 48 89 4d 98                  	movq	%rcx, -0x68(%rbp)
     2af: 41 b7 01                     	movb	$0x1, %r15b
     2b2: 31 f6                        	xorl	%esi, %esi
     2b4: 41 b6 01                     	movb	$0x1, %r14b
     2b7: e9 8f 00 00 00               	jmp	 <L10>
     2bc: 0f 1f 40 00                  	nopl	(%rax)
<L6>:
     2c0: 31 ff                        	xorl	%edi, %edi
<L7>:
     2c2: 31 c9                        	xorl	%ecx, %ecx
<L8>:
     2c4: 44 0f b6 75 c0               	movzbl	-0x40(%rbp), %r14d
     2c9: 4c 8b 7d b0                  	movq	-0x50(%rbp), %r15
     2cd: 4c 03 7d c8                  	addq	-0x38(%rbp), %r15
     2d1: 48 8d 34 29                  	leaq	(%rcx,%rbp), %rsi
     2d5: 48 81 c6 10 ff ff ff         	addq	$-0xf0, %rsi
     2dc: b8 30 00 00 00               	movl	$0x30, %eax
     2e1: 48 89 45 b0                  	movq	%rax, -0x50(%rbp)
     2e5: 41 bc 30 00 00 00            	movl	$0x30, %r12d
     2eb: 49 29 cc                     	subq	%rcx, %r12
     2ee: 40 0f b6 ff                  	movzbl	%dil, %edi
     2f2: 48 8d 85 d0 fd ff ff         	leaq	-0x230(%rbp), %rax
     2f9: 48 01 c7                     	addq	%rax, %rdi
     2fc: 4c 89 e2                     	movq	%r12, %rdx
     2ff: e8 00 00 00 00               	callq	 <L9>
		0000000000000300:  R_X86_64_PLT32	memcpy-0x4
<L9>:
     304: 44 00 a5 50 fe ff ff         	addb	%r12b, -0x1b0(%rbp)
     30b: 48 83 c3 30                  	addq	$0x30, %rbx
     30f: 49 83 d5 00                  	adcq	$0x0, %r13
     313: 4c 89 ad 88 fd ff ff         	movq	%r13, -0x278(%rbp)
     31a: 48 89 9d 80 fd ff ff         	movq	%rbx, -0x280(%rbp)
     321: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     328: 4c 89 fe                     	movq	%r15, %rsi
     32b: e8 e0 2d 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     330: 41 80 c6 01                  	addb	$0x1, %r14b
     334: 45 31 ff                     	xorl	%r15d, %r15d
     337: 44 88 75 d7                  	movb	%r14b, -0x29(%rbp)
     33b: be 30 00 00 00               	movl	$0x30, %esi
     340: 48 83 7d a8 60               	cmpq	$0x60, -0x58(%rbp)
     345: 0f 82 92 fd ff ff            	jb	 <L0>
<L10>:
     34b: 44 88 75 c0                  	movb	%r14b, -0x40(%rbp)
     34f: 0f 28 85 e0 fe ff ff         	movaps	-0x120(%rbp), %xmm0
     356: 0f 28 8d f0 fe ff ff         	movaps	-0x110(%rbp), %xmm1
     35d: 0f 28 95 00 ff ff ff         	movaps	-0x100(%rbp), %xmm2
     364: 0f 29 85 a0 fb ff ff         	movaps	%xmm0, -0x460(%rbp)
     36b: 0f 29 8d b0 fb ff ff         	movaps	%xmm1, -0x450(%rbp)
     372: 0f 29 95 c0 fb ff ff         	movaps	%xmm2, -0x440(%rbp)
     379: 48 8d 85 d0 fb ff ff         	leaq	-0x430(%rbp), %rax
     380: 0f 57 c0                     	xorps	%xmm0, %xmm0
     383: 0f 11 40 40                  	movups	%xmm0, 0x40(%rax)
     387: 0f 11 40 30                  	movups	%xmm0, 0x30(%rax)
     38b: 0f 11 40 20                  	movups	%xmm0, 0x20(%rax)
     38f: 0f 11 40 10                  	movups	%xmm0, 0x10(%rax)
     393: 0f 11 00                     	movups	%xmm0, (%rax)
     396: 31 c0                        	xorl	%eax, %eax
     398: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L11>:
     3a0: 0f b6 8c 05 a0 fb ff ff      	movzbl	-0x460(%rbp,%rax), %ecx
     3a8: 0f b6 94 05 a1 fb ff ff      	movzbl	-0x45f(%rbp,%rax), %edx
     3b0: 80 f1 5c                     	xorb	$0x5c, %cl
     3b3: 88 8c 05 60 fe ff ff         	movb	%cl, -0x1a0(%rbp,%rax)
     3ba: 80 f2 5c                     	xorb	$0x5c, %dl
     3bd: 88 94 05 61 fe ff ff         	movb	%dl, -0x19f(%rbp,%rax)
     3c4: 0f b6 8c 05 a2 fb ff ff      	movzbl	-0x45e(%rbp,%rax), %ecx
     3cc: 80 f1 5c                     	xorb	$0x5c, %cl
     3cf: 88 8c 05 62 fe ff ff         	movb	%cl, -0x19e(%rbp,%rax)
     3d6: 0f b6 8c 05 a3 fb ff ff      	movzbl	-0x45d(%rbp,%rax), %ecx
     3de: 80 f1 5c                     	xorb	$0x5c, %cl
     3e1: 88 8c 05 63 fe ff ff         	movb	%cl, -0x19d(%rbp,%rax)
     3e8: 48 83 c0 04                  	addq	$0x4, %rax
     3ec: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
     3f2: 75 ac                        	jne	 <L11>
     3f4: 48 89 75 b0                  	movq	%rsi, -0x50(%rbp)
     3f8: b8 03 00 00 00               	movl	$0x3, %eax
     3fd: 0f 1f 00                     	nopl	(%rax)
<L12>:
     400: 0f b6 8c 05 9d fb ff ff      	movzbl	-0x463(%rbp,%rax), %ecx
     408: 0f b6 94 05 9e fb ff ff      	movzbl	-0x462(%rbp,%rax), %edx
     410: 80 f1 36                     	xorb	$0x36, %cl
     413: 88 8c 05 0d ff ff ff         	movb	%cl, -0xf3(%rbp,%rax)
     41a: 80 f2 36                     	xorb	$0x36, %dl
     41d: 88 94 05 0e ff ff ff         	movb	%dl, -0xf2(%rbp,%rax)
     424: 0f b6 8c 05 9f fb ff ff      	movzbl	-0x461(%rbp,%rax), %ecx
     42c: 80 f1 36                     	xorb	$0x36, %cl
     42f: 88 8c 05 0f ff ff ff         	movb	%cl, -0xf1(%rbp,%rax)
     436: 0f b6 8c 05 a0 fb ff ff      	movzbl	-0x460(%rbp,%rax), %ecx
     43e: 80 f1 36                     	xorb	$0x36, %cl
     441: 88 8c 05 10 ff ff ff         	movb	%cl, -0xf0(%rbp,%rax)
     448: 48 83 c0 04                  	addq	$0x4, %rax
     44c: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
     452: 75 ac                        	jne	 <L12>
     454: be 00 00 00 00               	movl	$0x0, %esi
		0000000000000455:  R_X86_64_32	.rodata+0x10
     459: ba e0 00 00 00               	movl	$0xe0, %edx
     45e: 48 8d 9d 80 fd ff ff         	leaq	-0x280(%rbp), %rbx
     465: 48 89 df                     	movq	%rbx, %rdi
     468: e8 00 00 00 00               	callq	 <L13>
		0000000000000469:  R_X86_64_PLT32	memcpy-0x4
<L13>:
     46d: 48 89 df                     	movq	%rbx, %rdi
     470: 48 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %rsi
     477: e8 c4 05 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     47c: 48 81 85 80 fd ff ff 80 00 00 00     	addq	$0x80, -0x280(%rbp)
     487: 48 83 95 88 fd ff ff 00      	adcq	$0x0, -0x278(%rbp)
     48f: ba 60 01 00 00               	movl	$0x160, %edx            # imm = 0x160
     494: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     49b: 48 89 de                     	movq	%rbx, %rsi
     49e: e8 00 00 00 00               	callq	 <L14>
		000000000000049f:  R_X86_64_PLT32	memcpy-0x4
<L14>:
     4a3: 0f b6 85 10 fb ff ff         	movzbl	-0x4f0(%rbp), %eax
     4aa: 41 f6 c7 01                  	testb	$0x1, %r15b
     4ae: 0f 85 90 00 00 00            	jne	 <L20>
     4b4: 84 c0                        	testb	%al, %al
     4b6: 74 40                        	je	 <L16>
     4b8: 3c 50                        	cmpb	$0x50, %al
     4ba: 72 3e                        	jb	 <L17>
     4bc: 0f b6 f8                     	movzbl	%al, %edi
     4bf: 41 be 80 00 00 00            	movl	$0x80, %r14d
     4c5: 49 29 fe                     	subq	%rdi, %r14
     4c8: 48 8d 9d 90 fa ff ff         	leaq	-0x570(%rbp), %rbx
     4cf: 48 01 df                     	addq	%rbx, %rdi
     4d2: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     4d6: 4c 89 f2                     	movq	%r14, %rdx
     4d9: e8 00 00 00 00               	callq	 <L15>
		00000000000004da:  R_X86_64_PLT32	memcpy-0x4
<L15>:
     4de: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     4e5: 48 89 de                     	movq	%rbx, %rsi
     4e8: e8 53 05 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     4ed: c6 85 10 fb ff ff 00         	movb	$0x0, -0x4f0(%rbp)
     4f4: 31 c0                        	xorl	%eax, %eax
     4f6: eb 05                        	jmp	 <L18>
<L16>:
     4f8: 31 c0                        	xorl	%eax, %eax
<L17>:
     4fa: 45 31 f6                     	xorl	%r14d, %r14d
<L18>:
     4fd: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
     501: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
     505: 41 bc 30 00 00 00            	movl	$0x30, %r12d
     50b: 4d 29 f4                     	subq	%r14, %r12
     50e: 0f b6 f8                     	movzbl	%al, %edi
     511: 48 8d 85 90 fa ff ff         	leaq	-0x570(%rbp), %rax
     518: 48 01 c7                     	addq	%rax, %rdi
     51b: 4c 89 e2                     	movq	%r12, %rdx
     51e: e8 00 00 00 00               	callq	 <L19>
		000000000000051f:  R_X86_64_PLT32	memcpy-0x4
<L19>:
     523: 44 02 a5 10 fb ff ff         	addb	-0x4f0(%rbp), %r12b
     52a: 44 88 a5 10 fb ff ff         	movb	%r12b, -0x4f0(%rbp)
     531: 48 83 85 40 fa ff ff 30      	addq	$0x30, -0x5c0(%rbp)
     539: 48 83 95 48 fa ff ff 00      	adcq	$0x0, -0x5b8(%rbp)
     541: 44 89 e0                     	movl	%r12d, %eax
<L20>:
     544: 84 c0                        	testb	%al, %al
     546: 74 48                        	je	 <L22>
     548: 0f b6 f8                     	movzbl	%al, %edi
     54b: 48 39 7d 98                  	cmpq	%rdi, -0x68(%rbp)
     54f: 73 41                        	jae	 <L23>
     551: b1 80                        	movb	$-0x80, %cl
     553: 28 c1                        	subb	%al, %cl
     555: 44 0f b6 f1                  	movzbl	%cl, %r14d
     559: 48 8d 9d 90 fa ff ff         	leaq	-0x570(%rbp), %rbx
     560: 48 01 df                     	addq	%rbx, %rdi
     563: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
     567: 4c 89 f2                     	movq	%r14, %rdx
     56a: e8 00 00 00 00               	callq	 <L21>
		000000000000056b:  R_X86_64_PLT32	memcpy-0x4
<L21>:
     56f: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     576: 48 89 de                     	movq	%rbx, %rsi
     579: e8 c2 04 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     57e: c6 85 10 fb ff ff 00         	movb	$0x0, -0x4f0(%rbp)
     585: 31 c0                        	xorl	%eax, %eax
     587: eb 0c                        	jmp	 <L24>
     589: 0f 1f 80 00 00 00 00         	nopl	(%rax)
<L22>:
     590: 31 c0                        	xorl	%eax, %eax
<L23>:
     592: 45 31 f6                     	xorl	%r14d, %r14d
<L24>:
     595: 48 8b 4d b8                  	movq	-0x48(%rbp), %rcx
     599: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
     59d: 4c 8b 7d a0                  	movq	-0x60(%rbp), %r15
     5a1: 4d 89 fc                     	movq	%r15, %r12
     5a4: 4d 29 f4                     	subq	%r14, %r12
     5a7: 0f b6 f8                     	movzbl	%al, %edi
     5aa: 48 8d 85 90 fa ff ff         	leaq	-0x570(%rbp), %rax
     5b1: 48 01 c7                     	addq	%rax, %rdi
     5b4: 4c 89 e2                     	movq	%r12, %rdx
     5b7: e8 00 00 00 00               	callq	 <L25>
		00000000000005b8:  R_X86_64_PLT32	memcpy-0x4
<L25>:
     5bc: 0f b6 bd 10 fb ff ff         	movzbl	-0x4f0(%rbp), %edi
     5c3: 4c 01 e7                     	addq	%r12, %rdi
     5c6: 40 88 bd 10 fb ff ff         	movb	%dil, -0x4f0(%rbp)
     5cd: 4c 8b ad 48 fa ff ff         	movq	-0x5b8(%rbp), %r13
     5d4: 48 8b 9d 40 fa ff ff         	movq	-0x5c0(%rbp), %rbx
     5db: 4c 01 fb                     	addq	%r15, %rbx
     5de: 49 83 d5 00                  	adcq	$0x0, %r13
     5e2: 48 89 9d 40 fa ff ff         	movq	%rbx, -0x5c0(%rbp)
     5e9: 4c 89 ad 48 fa ff ff         	movq	%r13, -0x5b8(%rbp)
     5f0: 40 84 ff                     	testb	%dil, %dil
     5f3: 74 5b                        	je	 <L27>
     5f5: 40 80 ff 7f                  	cmpb	$0x7f, %dil
     5f9: 72 57                        	jb	 <L28>
     5fb: b0 80                        	movb	$-0x80, %al
     5fd: 40 28 f8                     	subb	%dil, %al
     600: 44 0f b6 f0                  	movzbl	%al, %r14d
     604: 48 8d 9d 90 fa ff ff         	leaq	-0x570(%rbp), %rbx
     60b: 48 01 df                     	addq	%rbx, %rdi
     60e: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     612: 4c 89 f2                     	movq	%r14, %rdx
     615: e8 00 00 00 00               	callq	 <L26>
		0000000000000616:  R_X86_64_PLT32	memcpy-0x4
<L26>:
     61a: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     621: 48 89 de                     	movq	%rbx, %rsi
     624: e8 17 04 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     629: c6 85 10 fb ff ff 00         	movb	$0x0, -0x4f0(%rbp)
     630: 31 ff                        	xorl	%edi, %edi
     632: 48 8b 9d 40 fa ff ff         	movq	-0x5c0(%rbp), %rbx
     639: 4c 8b ad 48 fa ff ff         	movq	-0x5b8(%rbp), %r13
     640: eb 13                        	jmp	 <L29>
     642: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     64c: 0f 1f 40 00                  	nopl	(%rax)
<L27>:
     650: 31 ff                        	xorl	%edi, %edi
<L28>:
     652: 45 31 f6                     	xorl	%r14d, %r14d
<L29>:
     655: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
     659: 48 83 c6 d7                  	addq	$-0x29, %rsi
     65d: 41 bc 01 00 00 00            	movl	$0x1, %r12d
     663: 4d 29 f4                     	subq	%r14, %r12
     666: 40 0f b6 ff                  	movzbl	%dil, %edi
     66a: 48 8d 85 90 fa ff ff         	leaq	-0x570(%rbp), %rax
     671: 48 01 c7                     	addq	%rax, %rdi
     674: 4c 89 e2                     	movq	%r12, %rdx
     677: e8 00 00 00 00               	callq	 <L30>
		0000000000000678:  R_X86_64_PLT32	memcpy-0x4
<L30>:
     67c: 44 00 a5 10 fb ff ff         	addb	%r12b, -0x4f0(%rbp)
     683: 48 83 c3 01                  	addq	$0x1, %rbx
     687: 49 83 d5 00                  	adcq	$0x0, %r13
     68b: 4c 89 ad 48 fa ff ff         	movq	%r13, -0x5b8(%rbp)
     692: 48 89 9d 40 fa ff ff         	movq	%rbx, -0x5c0(%rbp)
     699: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     6a0: 48 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %rsi
     6a7: e8 64 2a 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     6ac: be 00 00 00 00               	movl	$0x0, %esi
		00000000000006ad:  R_X86_64_32	.rodata+0x10
     6b1: ba e0 00 00 00               	movl	$0xe0, %edx
     6b6: 48 8d 9d 80 fd ff ff         	leaq	-0x280(%rbp), %rbx
     6bd: 48 89 df                     	movq	%rbx, %rdi
     6c0: e8 00 00 00 00               	callq	 <L31>
		00000000000006c1:  R_X86_64_PLT32	memcpy-0x4
<L31>:
     6c5: 48 89 df                     	movq	%rbx, %rdi
     6c8: 48 8d b5 20 fb ff ff         	leaq	-0x4e0(%rbp), %rsi
     6cf: e8 6c 03 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     6d4: 4c 8b ad 88 fd ff ff         	movq	-0x278(%rbp), %r13
     6db: 48 8b 9d 80 fd ff ff         	movq	-0x280(%rbp), %rbx
     6e2: b8 80 00 00 00               	movl	$0x80, %eax
     6e7: 48 01 c3                     	addq	%rax, %rbx
     6ea: 49 83 d5 00                  	adcq	$0x0, %r13
     6ee: 0f b6 bd 50 fe ff ff         	movzbl	-0x1b0(%rbp), %edi
     6f5: 48 89 9d 80 fd ff ff         	movq	%rbx, -0x280(%rbp)
     6fc: 4c 89 ad 88 fd ff ff         	movq	%r13, -0x278(%rbp)
     703: 48 85 ff                     	testq	%rdi, %rdi
     706: 0f 84 b4 fb ff ff            	je	 <L6>
     70c: 40 80 ff 50                  	cmpb	$0x50, %dil
     710: 0f 82 ac fb ff ff            	jb	 <L7>
     716: 41 be 80 00 00 00            	movl	$0x80, %r14d
     71c: 49 29 fe                     	subq	%rdi, %r14
     71f: 48 8d 9d d0 fd ff ff         	leaq	-0x230(%rbp), %rbx
     726: 48 01 df                     	addq	%rbx, %rdi
     729: 48 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %rsi
     730: 4c 89 f2                     	movq	%r14, %rdx
     733: e8 00 00 00 00               	callq	 <L32>
		0000000000000734:  R_X86_64_PLT32	memcpy-0x4
<L32>:
     738: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     73f: 48 89 de                     	movq	%rbx, %rsi
     742: e8 f9 02 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     747: 4c 89 f1                     	movq	%r14, %rcx
     74a: c6 85 50 fe ff ff 00         	movb	$0x0, -0x1b0(%rbp)
     751: 31 ff                        	xorl	%edi, %edi
     753: 48 8b 9d 80 fd ff ff         	movq	-0x280(%rbp), %rbx
     75a: 4c 8b ad 88 fd ff ff         	movq	-0x278(%rbp), %r13
     761: e9 5e fb ff ff               	jmp	 <L8>
<L33>:
     766: 31 c0                        	xorl	%eax, %eax
<L34>:
     768: 31 db                        	xorl	%ebx, %ebx
<L35>:
     76a: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
     76e: 48 8d 34 19                  	leaq	(%rcx,%rbx), %rsi
     772: 41 be 30 00 00 00            	movl	$0x30, %r14d
     778: 49 29 de                     	subq	%rbx, %r14
     77b: 0f b6 c0                     	movzbl	%al, %eax
     77e: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     782: 48 81 c7 70 fc ff ff         	addq	$-0x390, %rdi           # imm = 0xFC70
     789: 4c 89 f2                     	movq	%r14, %rdx
     78c: e8 00 00 00 00               	callq	 <L36>
		000000000000078d:  R_X86_64_PLT32	memcpy-0x4
<L36>:
     791: 44 02 b5 f0 fc ff ff         	addb	-0x310(%rbp), %r14b
     798: 44 88 b5 f0 fc ff ff         	movb	%r14b, -0x310(%rbp)
     79f: 48 83 85 20 fc ff ff 30      	addq	$0x30, -0x3e0(%rbp)
     7a7: 48 83 95 28 fc ff ff 00      	adcq	$0x0, -0x3d8(%rbp)
     7af: 44 89 f0                     	movl	%r14d, %eax
<L37>:
     7b2: 84 c0                        	testb	%al, %al
     7b4: 74 4f                        	je	 <L39>
     7b6: 0f b6 c8                     	movzbl	%al, %ecx
     7b9: 49 8d 14 0f                  	leaq	(%r15,%rcx), %rdx
     7bd: 48 81 fa 80 00 00 00         	cmpq	$0x80, %rdx
     7c4: 72 41                        	jb	 <L40>
     7c6: b2 80                        	movb	$-0x80, %dl
     7c8: 28 c2                        	subb	%al, %dl
     7ca: 0f b6 da                     	movzbl	%dl, %ebx
     7cd: 4c 8d b5 70 fc ff ff         	leaq	-0x390(%rbp), %r14
     7d4: 48 8d 3c 29                  	leaq	(%rcx,%rbp), %rdi
     7d8: 48 81 c7 70 fc ff ff         	addq	$-0x390, %rdi           # imm = 0xFC70
     7df: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
     7e3: 48 89 da                     	movq	%rbx, %rdx
     7e6: e8 00 00 00 00               	callq	 <L38>
		00000000000007e7:  R_X86_64_PLT32	memcpy-0x4
<L38>:
     7eb: 48 8d bd 20 fc ff ff         	leaq	-0x3e0(%rbp), %rdi
     7f2: 4c 89 f6                     	movq	%r14, %rsi
     7f5: e8 46 02 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     7fa: c6 85 f0 fc ff ff 00         	movb	$0x0, -0x310(%rbp)
     801: 31 c0                        	xorl	%eax, %eax
     803: eb 04                        	jmp	 <L41>
<L39>:
     805: 31 c0                        	xorl	%eax, %eax
<L40>:
     807: 31 db                        	xorl	%ebx, %ebx
<L41>:
     809: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
     80d: 48 01 de                     	addq	%rbx, %rsi
     810: 4d 89 fe                     	movq	%r15, %r14
     813: 49 29 de                     	subq	%rbx, %r14
     816: 48 8d 9d 70 fc ff ff         	leaq	-0x390(%rbp), %rbx
     81d: 0f b6 c0                     	movzbl	%al, %eax
     820: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
     824: 48 81 c7 70 fc ff ff         	addq	$-0x390, %rdi           # imm = 0xFC70
     82b: 4c 89 f2                     	movq	%r14, %rdx
     82e: e8 00 00 00 00               	callq	 <L42>
		000000000000082f:  R_X86_64_PLT32	memcpy-0x4
<L42>:
     833: 0f b6 bd f0 fc ff ff         	movzbl	-0x310(%rbp), %edi
     83a: 4c 01 f7                     	addq	%r14, %rdi
     83d: 40 88 bd f0 fc ff ff         	movb	%dil, -0x310(%rbp)
     844: 4c 8b a5 28 fc ff ff         	movq	-0x3d8(%rbp), %r12
     84b: 4c 03 bd 20 fc ff ff         	addq	-0x3e0(%rbp), %r15
     852: 49 83 d4 00                  	adcq	$0x0, %r12
     856: 4c 89 bd 20 fc ff ff         	movq	%r15, -0x3e0(%rbp)
     85d: 4c 89 a5 28 fc ff ff         	movq	%r12, -0x3d8(%rbp)
     864: 40 84 ff                     	testb	%dil, %dil
     867: 74 46                        	je	 <L44>
     869: 40 80 ff 7f                  	cmpb	$0x7f, %dil
     86d: 72 47                        	jb	 <L45>
     86f: b0 80                        	movb	$-0x80, %al
     871: 40 28 f8                     	subb	%dil, %al
     874: 44 0f b6 f8                  	movzbl	%al, %r15d
     878: 48 01 df                     	addq	%rbx, %rdi
     87b: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     87f: 4c 89 fa                     	movq	%r15, %rdx
     882: e8 00 00 00 00               	callq	 <L43>
		0000000000000883:  R_X86_64_PLT32	memcpy-0x4
<L43>:
     887: 48 8d bd 20 fc ff ff         	leaq	-0x3e0(%rbp), %rdi
     88e: 48 89 de                     	movq	%rbx, %rsi
     891: e8 aa 01 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     896: c6 85 f0 fc ff ff 00         	movb	$0x0, -0x310(%rbp)
     89d: 31 ff                        	xorl	%edi, %edi
     89f: 4c 8b ad 20 fc ff ff         	movq	-0x3e0(%rbp), %r13
     8a6: 4c 8b a5 28 fc ff ff         	movq	-0x3d8(%rbp), %r12
     8ad: eb 0d                        	jmp	 <L47>
<L44>:
     8af: 4d 89 fd                     	movq	%r15, %r13
     8b2: 31 ff                        	xorl	%edi, %edi
     8b4: eb 03                        	jmp	 <L46>
<L45>:
     8b6: 4d 89 fd                     	movq	%r15, %r13
<L46>:
     8b9: 45 31 ff                     	xorl	%r15d, %r15d
<L47>:
     8bc: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
     8c0: 48 83 c6 d7                  	addq	$-0x29, %rsi
     8c4: 41 be 01 00 00 00            	movl	$0x1, %r14d
     8ca: 4d 29 fe                     	subq	%r15, %r14
     8cd: 40 0f b6 c7                  	movzbl	%dil, %eax
     8d1: 48 01 c3                     	addq	%rax, %rbx
     8d4: 48 89 df                     	movq	%rbx, %rdi
     8d7: 4c 89 f2                     	movq	%r14, %rdx
     8da: e8 00 00 00 00               	callq	 <L48>
		00000000000008db:  R_X86_64_PLT32	memcpy-0x4
<L48>:
     8df: 44 00 b5 f0 fc ff ff         	addb	%r14b, -0x310(%rbp)
     8e6: 49 83 c5 01                  	addq	$0x1, %r13
     8ea: 49 83 d4 00                  	adcq	$0x0, %r12
     8ee: 4c 89 a5 28 fc ff ff         	movq	%r12, -0x3d8(%rbp)
     8f5: 4c 89 ad 20 fc ff ff         	movq	%r13, -0x3e0(%rbp)
     8fc: 48 8d bd 20 fc ff ff         	leaq	-0x3e0(%rbp), %rdi
     903: 48 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %rsi
     90a: e8 01 28 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     90f: 48 8d 9d 80 fd ff ff         	leaq	-0x280(%rbp), %rbx
     916: be 00 00 00 00               	movl	$0x0, %esi
		0000000000000917:  R_X86_64_32	.rodata+0x10
     91b: ba e0 00 00 00               	movl	$0xe0, %edx
     920: 48 89 df                     	movq	%rbx, %rdi
     923: e8 00 00 00 00               	callq	 <L49>
		0000000000000924:  R_X86_64_PLT32	memcpy-0x4
<L49>:
     928: 48 8d b5 00 fd ff ff         	leaq	-0x300(%rbp), %rsi
     92f: 48 89 df                     	movq	%rbx, %rdi
     932: e8 09 01 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     937: 0f b6 bd 50 fe ff ff         	movzbl	-0x1b0(%rbp), %edi
     93e: 4c 8b a5 88 fd ff ff         	movq	-0x278(%rbp), %r12
     945: 41 bd 80 00 00 00            	movl	$0x80, %r13d
     94b: 4c 03 ad 80 fd ff ff         	addq	-0x280(%rbp), %r13
     952: 49 83 d4 00                  	adcq	$0x0, %r12
     956: 48 8d 9d d0 fd ff ff         	leaq	-0x230(%rbp), %rbx
     95d: 4c 89 ad 80 fd ff ff         	movq	%r13, -0x280(%rbp)
     964: 4c 89 a5 88 fd ff ff         	movq	%r12, -0x278(%rbp)
     96b: 48 85 ff                     	testq	%rdi, %rdi
     96e: 74 49                        	je	 <L51>
     970: 40 80 ff 50                  	cmpb	$0x50, %dil
     974: 72 45                        	jb	 <L52>
     976: 41 be 80 00 00 00            	movl	$0x80, %r14d
     97c: 49 29 fe                     	subq	%rdi, %r14
     97f: 48 01 df                     	addq	%rbx, %rdi
     982: 48 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %rsi
     989: 4c 89 f2                     	movq	%r14, %rdx
     98c: e8 00 00 00 00               	callq	 <L50>
		000000000000098d:  R_X86_64_PLT32	memcpy-0x4
<L50>:
     991: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     998: 48 89 de                     	movq	%rbx, %rsi
     99b: e8 a0 00 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
     9a0: c6 85 50 fe ff ff 00         	movb	$0x0, -0x1b0(%rbp)
     9a7: 31 ff                        	xorl	%edi, %edi
     9a9: 4c 8b ad 80 fd ff ff         	movq	-0x280(%rbp), %r13
     9b0: 4c 8b a5 88 fd ff ff         	movq	-0x278(%rbp), %r12
     9b7: eb 05                        	jmp	 <L53>
<L51>:
     9b9: 31 ff                        	xorl	%edi, %edi
<L52>:
     9bb: 45 31 f6                     	xorl	%r14d, %r14d
<L53>:
     9be: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
     9c2: 48 81 c6 10 ff ff ff         	addq	$-0xf0, %rsi
     9c9: 41 bf 30 00 00 00            	movl	$0x30, %r15d
     9cf: 4d 29 f7                     	subq	%r14, %r15
     9d2: 40 0f b6 c7                  	movzbl	%dil, %eax
     9d6: 48 01 c3                     	addq	%rax, %rbx
     9d9: 48 89 df                     	movq	%rbx, %rdi
     9dc: 4c 89 fa                     	movq	%r15, %rdx
     9df: e8 00 00 00 00               	callq	 <L54>
		00000000000009e0:  R_X86_64_PLT32	memcpy-0x4
<L54>:
     9e4: 44 00 bd 50 fe ff ff         	addb	%r15b, -0x1b0(%rbp)
     9eb: 49 83 c5 30                  	addq	$0x30, %r13
     9ef: 49 83 d4 00                  	adcq	$0x0, %r12
     9f3: 4c 89 a5 88 fd ff ff         	movq	%r12, -0x278(%rbp)
     9fa: 4c 89 ad 80 fd ff ff         	movq	%r13, -0x280(%rbp)
     a01: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     a08: 48 8d 9d 10 fa ff ff         	leaq	-0x5f0(%rbp), %rbx
     a0f: 48 89 de                     	movq	%rbx, %rsi
     a12: e8 f9 26 00 00               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
     a17: 48 8b 7d c8                  	movq	-0x38(%rbp), %rdi
     a1b: 48 03 7d b0                  	addq	-0x50(%rbp), %rdi
     a1f: 48 89 de                     	movq	%rbx, %rsi
     a22: 48 8b 55 c0                  	movq	-0x40(%rbp), %rdx
     a26: e8 00 00 00 00               	callq	 <L55>
		0000000000000a27:  R_X86_64_PLT32	memcpy-0x4
<L55>:
     a2b: 48 81 c4 c8 05 00 00         	addq	$0x5c8, %rsp            # imm = 0x5C8
     a32: 5b                           	popq	%rbx
     a33: 41 5c                        	popq	%r12
     a35: 41 5d                        	popq	%r13
     a37: 41 5e                        	popq	%r14
     a39: 41 5f                        	popq	%r15
     a3b: 5d                           	popq	%rbp
     a3c: c3                           	retq
     a3d: 0f 1f 00                     	nopl	(%rax)

0000000000000a40 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
     a40: 55                           	pushq	%rbp
     a41: 48 89 e5                     	movq	%rsp, %rbp
     a44: 41 57                        	pushq	%r15
     a46: 41 56                        	pushq	%r14
     a48: 41 55                        	pushq	%r13
     a4a: 41 54                        	pushq	%r12
     a4c: 53                           	pushq	%rbx
     a4d: 48 81 ec 00 02 00 00         	subq	$0x200, %rsp            # imm = 0x200
     a54: 48 8b 16                     	movq	(%rsi), %rdx
     a57: 48 0f ca                     	bswapq	%rdx
     a5a: 48 89 95 58 fd ff ff         	movq	%rdx, -0x2a8(%rbp)
     a61: 48 8b 46 08                  	movq	0x8(%rsi), %rax
     a65: 48 0f c8                     	bswapq	%rax
     a68: 48 89 85 60 fd ff ff         	movq	%rax, -0x2a0(%rbp)
     a6f: 48 8b 46 10                  	movq	0x10(%rsi), %rax
     a73: 48 0f c8                     	bswapq	%rax
     a76: 48 89 85 68 fd ff ff         	movq	%rax, -0x298(%rbp)
     a7d: 48 8b 46 18                  	movq	0x18(%rsi), %rax
     a81: 48 0f c8                     	bswapq	%rax
     a84: 48 89 85 70 fd ff ff         	movq	%rax, -0x290(%rbp)
     a8b: 48 8b 46 20                  	movq	0x20(%rsi), %rax
     a8f: 48 0f c8                     	bswapq	%rax
     a92: 48 89 85 78 fd ff ff         	movq	%rax, -0x288(%rbp)
     a99: 48 8b 46 28                  	movq	0x28(%rsi), %rax
     a9d: 48 0f c8                     	bswapq	%rax
     aa0: 48 89 85 80 fd ff ff         	movq	%rax, -0x280(%rbp)
     aa7: 48 8b 46 30                  	movq	0x30(%rsi), %rax
     aab: 48 0f c8                     	bswapq	%rax
     aae: 48 89 85 88 fd ff ff         	movq	%rax, -0x278(%rbp)
     ab5: 48 8b 46 38                  	movq	0x38(%rsi), %rax
     ab9: 48 0f c8                     	bswapq	%rax
     abc: 48 89 85 90 fd ff ff         	movq	%rax, -0x270(%rbp)
     ac3: 48 8b 46 40                  	movq	0x40(%rsi), %rax
     ac7: 48 0f c8                     	bswapq	%rax
     aca: 48 89 85 98 fd ff ff         	movq	%rax, -0x268(%rbp)
     ad1: 48 8b 46 48                  	movq	0x48(%rsi), %rax
     ad5: 48 0f c8                     	bswapq	%rax
     ad8: 48 89 85 a0 fd ff ff         	movq	%rax, -0x260(%rbp)
     adf: 48 8b 46 50                  	movq	0x50(%rsi), %rax
     ae3: 48 0f c8                     	bswapq	%rax
     ae6: 48 89 85 a8 fd ff ff         	movq	%rax, -0x258(%rbp)
     aed: 48 8b 46 58                  	movq	0x58(%rsi), %rax
     af1: 48 0f c8                     	bswapq	%rax
     af4: 48 89 85 b0 fd ff ff         	movq	%rax, -0x250(%rbp)
     afb: 48 8b 46 60                  	movq	0x60(%rsi), %rax
     aff: 48 0f c8                     	bswapq	%rax
     b02: 48 89 85 b8 fd ff ff         	movq	%rax, -0x248(%rbp)
     b09: 48 8b 46 68                  	movq	0x68(%rsi), %rax
     b0d: 48 0f c8                     	bswapq	%rax
     b10: 48 89 85 c0 fd ff ff         	movq	%rax, -0x240(%rbp)
     b17: 48 8b 46 70                  	movq	0x70(%rsi), %rax
     b1b: 48 0f c8                     	bswapq	%rax
     b1e: 48 89 85 c8 fd ff ff         	movq	%rax, -0x238(%rbp)
     b25: 48 8b 46 78                  	movq	0x78(%rsi), %rax
     b29: 48 0f c8                     	bswapq	%rax
     b2c: 48 89 85 d0 fd ff ff         	movq	%rax, -0x230(%rbp)
     b33: 31 c0                        	xorl	%eax, %eax
     b35: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     b3f: 90                           	nop
<L0>:
     b40: 48 8b 8c c5 60 fd ff ff      	movq	-0x2a0(%rbp,%rax,8), %rcx
     b48: 48 8b b4 c5 a0 fd ff ff      	movq	-0x260(%rbp,%rax,8), %rsi
     b50: 48 03 b4 c5 58 fd ff ff      	addq	-0x2a8(%rbp,%rax,8), %rsi
     b58: 49 89 c8                     	movq	%rcx, %r8
     b5b: 49 d1 c8                     	rorq	%r8
     b5e: 49 89 c9                     	movq	%rcx, %r9
     b61: 49 c1 c1 38                  	rolq	$0x38, %r9
     b65: 4d 31 c1                     	xorq	%r8, %r9
     b68: 48 c1 e9 07                  	shrq	$0x7, %rcx
     b6c: 4c 8b 84 c5 c8 fd ff ff      	movq	-0x238(%rbp,%rax,8), %r8
     b74: 4d 89 c2                     	movq	%r8, %r10
     b77: 49 c1 c2 2d                  	rolq	$0x2d, %r10
     b7b: 4c 31 c9                     	xorq	%r9, %rcx
     b7e: 4d 89 c1                     	movq	%r8, %r9
     b81: 49 c1 c1 03                  	rolq	$0x3, %r9
     b85: 48 01 f1                     	addq	%rsi, %rcx
     b88: 4d 31 d1                     	xorq	%r10, %r9
     b8b: 49 c1 e8 06                  	shrq	$0x6, %r8
     b8f: 4d 31 c8                     	xorq	%r9, %r8
     b92: 49 01 c8                     	addq	%rcx, %r8
     b95: 4c 89 84 c5 d8 fd ff ff      	movq	%r8, -0x228(%rbp,%rax,8)
     b9d: 48 83 c0 01                  	addq	$0x1, %rax
     ba1: 48 83 f8 40                  	cmpq	$0x40, %rax
     ba5: 75 99                        	jne	 <L0>
     ba7: 48 8b 47 10                  	movq	0x10(%rdi), %rax
     bab: 48 8b 77 18                  	movq	0x18(%rdi), %rsi
     baf: 4c 8b 47 20                  	movq	0x20(%rdi), %r8
     bb3: 48 8b 4f 30                  	movq	0x30(%rdi), %rcx
     bb7: 49 89 c9                     	movq	%rcx, %r9
     bba: 49 c1 c1 32                  	rolq	$0x32, %r9
     bbe: 48 8b 5f 38                  	movq	0x38(%rdi), %rbx
     bc2: 49 89 ca                     	movq	%rcx, %r10
     bc5: 49 c1 c2 2e                  	rolq	$0x2e, %r10
     bc9: 4c 8b 5f 40                  	movq	0x40(%rdi), %r11
     bcd: 49 89 cf                     	movq	%rcx, %r15
     bd0: 49 c1 c7 17                  	rolq	$0x17, %r15
     bd4: 4d 31 ca                     	xorq	%r9, %r10
     bd7: 4d 31 d7                     	xorq	%r10, %r15
     bda: 4d 89 d9                     	movq	%r11, %r9
     bdd: 49 31 d9                     	xorq	%rbx, %r9
     be0: 49 21 c9                     	andq	%rcx, %r9
     be3: 4d 31 d9                     	xorq	%r11, %r9
     be6: 4c 03 7f 48                  	addq	0x48(%rdi), %r15
     bea: 4c 01 ca                     	addq	%r9, %rdx
     bed: 49 be 22 ae 28 d7 98 2f 8a 42	movabsq	$0x428a2f98d728ae22, %r14 # imm = 0x428A2F98D728AE22
     bf7: 49 01 d6                     	addq	%rdx, %r14
     bfa: 4d 01 fe                     	addq	%r15, %r14
     bfd: 4c 8b 57 28                  	movq	0x28(%rdi), %r10
     c01: 48 89 c2                     	movq	%rax, %rdx
     c04: 48 c1 c2 24                  	rolq	$0x24, %rdx
     c08: 4d 01 f2                     	addq	%r14, %r10
     c0b: 49 89 c1                     	movq	%rax, %r9
     c0e: 49 c1 c1 1e                  	rolq	$0x1e, %r9
     c12: 49 31 d1                     	xorq	%rdx, %r9
     c15: 48 89 c2                     	movq	%rax, %rdx
     c18: 48 c1 c2 19                  	rolq	$0x19, %rdx
     c1c: 4c 31 ca                     	xorq	%r9, %rdx
     c1f: 4d 89 c7                     	movq	%r8, %r15
     c22: 49 09 f7                     	orq	%rsi, %r15
     c25: 49 21 c7                     	andq	%rax, %r15
     c28: 4d 89 c1                     	movq	%r8, %r9
     c2b: 49 21 f1                     	andq	%rsi, %r9
     c2e: 4d 09 f9                     	orq	%r15, %r9
     c31: 49 01 d1                     	addq	%rdx, %r9
     c34: 4d 01 f1                     	addq	%r14, %r9
     c37: 4c 89 d2                     	movq	%r10, %rdx
     c3a: 48 c1 c2 32                  	rolq	$0x32, %rdx
     c3e: 4d 89 d6                     	movq	%r10, %r14
     c41: 49 c1 c6 2e                  	rolq	$0x2e, %r14
     c45: 49 31 d6                     	xorq	%rdx, %r14
     c48: 4d 89 d7                     	movq	%r10, %r15
     c4b: 49 c1 c7 17                  	rolq	$0x17, %r15
     c4f: 4d 31 f7                     	xorq	%r14, %r15
     c52: 48 89 da                     	movq	%rbx, %rdx
     c55: 48 31 ca                     	xorq	%rcx, %rdx
     c58: 4c 21 d2                     	andq	%r10, %rdx
     c5b: 48 31 da                     	xorq	%rbx, %rdx
     c5e: 4c 03 9d 60 fd ff ff         	addq	-0x2a0(%rbp), %r11
     c65: 49 01 d3                     	addq	%rdx, %r11
     c68: 48 ba cd 65 ef 23 91 44 37 71	movabsq	$0x7137449123ef65cd, %rdx # imm = 0x7137449123EF65CD
     c72: 4c 01 da                     	addq	%r11, %rdx
     c75: 4d 89 cb                     	movq	%r9, %r11
     c78: 49 c1 c3 24                  	rolq	$0x24, %r11
     c7c: 4c 01 fa                     	addq	%r15, %rdx
     c7f: 4d 89 ce                     	movq	%r9, %r14
     c82: 49 c1 c6 1e                  	rolq	$0x1e, %r14
     c86: 49 01 d0                     	addq	%rdx, %r8
     c89: 4d 89 cf                     	movq	%r9, %r15
     c8c: 49 c1 c7 19                  	rolq	$0x19, %r15
     c90: 4d 31 de                     	xorq	%r11, %r14
     c93: 4d 31 f7                     	xorq	%r14, %r15
     c96: 49 89 f6                     	movq	%rsi, %r14
     c99: 49 09 c6                     	orq	%rax, %r14
     c9c: 4d 21 ce                     	andq	%r9, %r14
     c9f: 49 89 f3                     	movq	%rsi, %r11
     ca2: 49 21 c3                     	andq	%rax, %r11
     ca5: 4d 09 f3                     	orq	%r14, %r11
     ca8: 4d 01 fb                     	addq	%r15, %r11
     cab: 4d 89 c6                     	movq	%r8, %r14
     cae: 49 c1 c6 32                  	rolq	$0x32, %r14
     cb2: 49 01 d3                     	addq	%rdx, %r11
     cb5: 4c 89 c2                     	movq	%r8, %rdx
     cb8: 48 c1 c2 2e                  	rolq	$0x2e, %rdx
     cbc: 4c 31 f2                     	xorq	%r14, %rdx
     cbf: 4d 89 c7                     	movq	%r8, %r15
     cc2: 49 c1 c7 17                  	rolq	$0x17, %r15
     cc6: 49 31 d7                     	xorq	%rdx, %r15
     cc9: 4c 89 d2                     	movq	%r10, %rdx
     ccc: 48 31 ca                     	xorq	%rcx, %rdx
     ccf: 4c 21 c2                     	andq	%r8, %rdx
     cd2: 48 31 ca                     	xorq	%rcx, %rdx
     cd5: 48 03 9d 68 fd ff ff         	addq	-0x298(%rbp), %rbx
     cdc: 48 01 d3                     	addq	%rdx, %rbx
     cdf: 49 be 2f 3b 4d ec cf fb c0 b5	movabsq	$-0x4a3f043013b2c4d1, %r14 # imm = 0xB5C0FBCFEC4D3B2F
     ce9: 49 01 de                     	addq	%rbx, %r14
     cec: 4d 01 fe                     	addq	%r15, %r14
     cef: 4c 01 f6                     	addq	%r14, %rsi
     cf2: 4c 89 da                     	movq	%r11, %rdx
     cf5: 48 c1 c2 24                  	rolq	$0x24, %rdx
     cf9: 4c 89 db                     	movq	%r11, %rbx
     cfc: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
     d00: 48 31 d3                     	xorq	%rdx, %rbx
     d03: 4d 89 df                     	movq	%r11, %r15
     d06: 49 c1 c7 19                  	rolq	$0x19, %r15
     d0a: 49 31 df                     	xorq	%rbx, %r15
     d0d: 4c 89 cb                     	movq	%r9, %rbx
     d10: 48 09 c3                     	orq	%rax, %rbx
     d13: 4c 21 db                     	andq	%r11, %rbx
     d16: 4c 89 ca                     	movq	%r9, %rdx
     d19: 48 21 c2                     	andq	%rax, %rdx
     d1c: 48 09 da                     	orq	%rbx, %rdx
     d1f: 48 89 f3                     	movq	%rsi, %rbx
     d22: 48 c1 c3 32                  	rolq	$0x32, %rbx
     d26: 4c 01 fa                     	addq	%r15, %rdx
     d29: 49 89 f7                     	movq	%rsi, %r15
     d2c: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     d30: 4c 01 f2                     	addq	%r14, %rdx
     d33: 49 89 f4                     	movq	%rsi, %r12
     d36: 49 c1 c4 17                  	rolq	$0x17, %r12
     d3a: 49 31 df                     	xorq	%rbx, %r15
     d3d: 4d 31 fc                     	xorq	%r15, %r12
     d40: 4c 89 c3                     	movq	%r8, %rbx
     d43: 4c 31 d3                     	xorq	%r10, %rbx
     d46: 48 21 f3                     	andq	%rsi, %rbx
     d49: 4c 31 d3                     	xorq	%r10, %rbx
     d4c: 48 03 8d 70 fd ff ff         	addq	-0x290(%rbp), %rcx
     d53: 48 01 d9                     	addq	%rbx, %rcx
     d56: 49 be bc db 89 81 a5 db b5 e9	movabsq	$-0x164a245a7e762444, %r14 # imm = 0xE9B5DBA58189DBBC
     d60: 49 01 ce                     	addq	%rcx, %r14
     d63: 4d 01 e6                     	addq	%r12, %r14
     d66: 48 89 d1                     	movq	%rdx, %rcx
     d69: 48 c1 c1 24                  	rolq	$0x24, %rcx
     d6d: 48 89 d3                     	movq	%rdx, %rbx
     d70: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
     d74: 48 31 cb                     	xorq	%rcx, %rbx
     d77: 49 89 d7                     	movq	%rdx, %r15
     d7a: 49 c1 c7 19                  	rolq	$0x19, %r15
     d7e: 49 31 df                     	xorq	%rbx, %r15
     d81: 4c 89 db                     	movq	%r11, %rbx
     d84: 4c 09 cb                     	orq	%r9, %rbx
     d87: 48 21 d3                     	andq	%rdx, %rbx
     d8a: 4c 89 d9                     	movq	%r11, %rcx
     d8d: 4c 21 c9                     	andq	%r9, %rcx
     d90: 48 09 d9                     	orq	%rbx, %rcx
     d93: 4c 01 f9                     	addq	%r15, %rcx
     d96: 4c 01 f1                     	addq	%r14, %rcx
     d99: 49 01 c6                     	addq	%rax, %r14
     d9c: 4c 89 f3                     	movq	%r14, %rbx
     d9f: 48 c1 c3 32                  	rolq	$0x32, %rbx
     da3: 4d 89 f7                     	movq	%r14, %r15
     da6: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     daa: 49 31 df                     	xorq	%rbx, %r15
     dad: 4d 89 f4                     	movq	%r14, %r12
     db0: 49 c1 c4 17                  	rolq	$0x17, %r12
     db4: 4d 31 fc                     	xorq	%r15, %r12
     db7: 48 89 f3                     	movq	%rsi, %rbx
     dba: 4c 31 c3                     	xorq	%r8, %rbx
     dbd: 4c 21 f3                     	andq	%r14, %rbx
     dc0: 4c 03 95 78 fd ff ff         	addq	-0x288(%rbp), %r10
     dc7: 4c 31 c3                     	xorq	%r8, %rbx
     dca: 49 01 da                     	addq	%rbx, %r10
     dcd: 48 bb 38 b5 48 f3 5b c2 56 39	movabsq	$0x3956c25bf348b538, %rbx # imm = 0x3956C25BF348B538
     dd7: 4c 01 d3                     	addq	%r10, %rbx
     dda: 4c 01 e3                     	addq	%r12, %rbx
     ddd: 49 89 ca                     	movq	%rcx, %r10
     de0: 49 c1 c2 24                  	rolq	$0x24, %r10
     de4: 49 01 d9                     	addq	%rbx, %r9
     de7: 49 89 cf                     	movq	%rcx, %r15
     dea: 49 c1 c7 1e                  	rolq	$0x1e, %r15
     dee: 4d 31 d7                     	xorq	%r10, %r15
     df1: 49 89 cc                     	movq	%rcx, %r12
     df4: 49 c1 c4 19                  	rolq	$0x19, %r12
     df8: 4d 31 fc                     	xorq	%r15, %r12
     dfb: 49 89 d7                     	movq	%rdx, %r15
     dfe: 4d 09 df                     	orq	%r11, %r15
     e01: 49 21 cf                     	andq	%rcx, %r15
     e04: 49 89 d2                     	movq	%rdx, %r10
     e07: 4d 21 da                     	andq	%r11, %r10
     e0a: 4d 09 fa                     	orq	%r15, %r10
     e0d: 4d 01 e2                     	addq	%r12, %r10
     e10: 49 01 da                     	addq	%rbx, %r10
     e13: 4c 89 cb                     	movq	%r9, %rbx
     e16: 48 c1 c3 32                  	rolq	$0x32, %rbx
     e1a: 4d 89 cf                     	movq	%r9, %r15
     e1d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     e21: 49 31 df                     	xorq	%rbx, %r15
     e24: 4c 89 cb                     	movq	%r9, %rbx
     e27: 48 c1 c3 17                  	rolq	$0x17, %rbx
     e2b: 4c 31 fb                     	xorq	%r15, %rbx
     e2e: 4d 89 f7                     	movq	%r14, %r15
     e31: 49 31 f7                     	xorq	%rsi, %r15
     e34: 4d 21 cf                     	andq	%r9, %r15
     e37: 49 31 f7                     	xorq	%rsi, %r15
     e3a: 4c 03 85 80 fd ff ff         	addq	-0x280(%rbp), %r8
     e41: 4d 01 f8                     	addq	%r15, %r8
     e44: 49 bf 19 d0 05 b6 f1 11 f1 59	movabsq	$0x59f111f1b605d019, %r15 # imm = 0x59F111F1B605D019
     e4e: 4d 01 c7                     	addq	%r8, %r15
     e51: 4d 89 d0                     	movq	%r10, %r8
     e54: 49 c1 c0 24                  	rolq	$0x24, %r8
     e58: 49 01 df                     	addq	%rbx, %r15
     e5b: 4c 89 d3                     	movq	%r10, %rbx
     e5e: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
     e62: 4d 01 fb                     	addq	%r15, %r11
     e65: 4d 89 d4                     	movq	%r10, %r12
     e68: 49 c1 c4 19                  	rolq	$0x19, %r12
     e6c: 4c 31 c3                     	xorq	%r8, %rbx
     e6f: 49 31 dc                     	xorq	%rbx, %r12
     e72: 49 89 c8                     	movq	%rcx, %r8
     e75: 49 09 d0                     	orq	%rdx, %r8
     e78: 4d 21 d0                     	andq	%r10, %r8
     e7b: 48 89 cb                     	movq	%rcx, %rbx
     e7e: 48 21 d3                     	andq	%rdx, %rbx
     e81: 4c 09 c3                     	orq	%r8, %rbx
     e84: 4c 01 e3                     	addq	%r12, %rbx
     e87: 4d 89 d8                     	movq	%r11, %r8
     e8a: 49 c1 c0 32                  	rolq	$0x32, %r8
     e8e: 4c 01 fb                     	addq	%r15, %rbx
     e91: 4d 89 df                     	movq	%r11, %r15
     e94: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     e98: 4d 31 c7                     	xorq	%r8, %r15
     e9b: 4d 89 dc                     	movq	%r11, %r12
     e9e: 49 c1 c4 17                  	rolq	$0x17, %r12
     ea2: 4d 31 fc                     	xorq	%r15, %r12
     ea5: 4d 89 c8                     	movq	%r9, %r8
     ea8: 4d 31 f0                     	xorq	%r14, %r8
     eab: 4d 21 d8                     	andq	%r11, %r8
     eae: 4d 31 f0                     	xorq	%r14, %r8
     eb1: 48 03 b5 88 fd ff ff         	addq	-0x278(%rbp), %rsi
     eb8: 4c 01 c6                     	addq	%r8, %rsi
     ebb: 49 b8 9b 4f 19 af a4 82 3f 92	movabsq	$-0x6dc07d5b50e6b065, %r8 # imm = 0x923F82A4AF194F9B
     ec5: 49 01 f0                     	addq	%rsi, %r8
     ec8: 4d 01 e0                     	addq	%r12, %r8
     ecb: 4c 01 c2                     	addq	%r8, %rdx
     ece: 48 89 de                     	movq	%rbx, %rsi
     ed1: 48 c1 c6 24                  	rolq	$0x24, %rsi
     ed5: 49 89 df                     	movq	%rbx, %r15
     ed8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
     edc: 49 31 f7                     	xorq	%rsi, %r15
     edf: 49 89 dc                     	movq	%rbx, %r12
     ee2: 49 c1 c4 19                  	rolq	$0x19, %r12
     ee6: 4d 31 fc                     	xorq	%r15, %r12
     ee9: 4d 89 d7                     	movq	%r10, %r15
     eec: 49 09 cf                     	orq	%rcx, %r15
     eef: 49 21 df                     	andq	%rbx, %r15
     ef2: 4c 89 d6                     	movq	%r10, %rsi
     ef5: 48 21 ce                     	andq	%rcx, %rsi
     ef8: 4c 09 fe                     	orq	%r15, %rsi
     efb: 49 89 d7                     	movq	%rdx, %r15
     efe: 49 c1 c7 32                  	rolq	$0x32, %r15
     f02: 4c 01 e6                     	addq	%r12, %rsi
     f05: 49 89 d4                     	movq	%rdx, %r12
     f08: 49 c1 c4 2e                  	rolq	$0x2e, %r12
     f0c: 4c 01 c6                     	addq	%r8, %rsi
     f0f: 49 89 d0                     	movq	%rdx, %r8
     f12: 49 c1 c0 17                  	rolq	$0x17, %r8
     f16: 4d 31 fc                     	xorq	%r15, %r12
     f19: 4d 31 e0                     	xorq	%r12, %r8
     f1c: 4d 89 df                     	movq	%r11, %r15
     f1f: 4d 31 cf                     	xorq	%r9, %r15
     f22: 49 21 d7                     	andq	%rdx, %r15
     f25: 4d 31 cf                     	xorq	%r9, %r15
     f28: 4c 03 b5 90 fd ff ff         	addq	-0x270(%rbp), %r14
     f2f: 4d 01 fe                     	addq	%r15, %r14
     f32: 49 bf 18 81 6d da d5 5e 1c ab	movabsq	$-0x54e3a12a25927ee8, %r15 # imm = 0xAB1C5ED5DA6D8118
     f3c: 4d 01 f7                     	addq	%r14, %r15
     f3f: 4d 01 c7                     	addq	%r8, %r15
     f42: 4c 01 f9                     	addq	%r15, %rcx
     f45: 49 89 f0                     	movq	%rsi, %r8
     f48: 49 c1 c0 24                  	rolq	$0x24, %r8
     f4c: 49 89 f6                     	movq	%rsi, %r14
     f4f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
     f53: 4d 31 c6                     	xorq	%r8, %r14
     f56: 49 89 f4                     	movq	%rsi, %r12
     f59: 49 c1 c4 19                  	rolq	$0x19, %r12
     f5d: 4d 31 f4                     	xorq	%r14, %r12
     f60: 49 89 de                     	movq	%rbx, %r14
     f63: 4d 09 d6                     	orq	%r10, %r14
     f66: 49 21 f6                     	andq	%rsi, %r14
     f69: 49 89 d8                     	movq	%rbx, %r8
     f6c: 4d 21 d0                     	andq	%r10, %r8
     f6f: 4d 09 f0                     	orq	%r14, %r8
     f72: 4d 01 e0                     	addq	%r12, %r8
     f75: 4d 01 f8                     	addq	%r15, %r8
     f78: 49 89 ce                     	movq	%rcx, %r14
     f7b: 49 c1 c6 32                  	rolq	$0x32, %r14
     f7f: 49 89 cf                     	movq	%rcx, %r15
     f82: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     f86: 4d 31 f7                     	xorq	%r14, %r15
     f89: 49 89 cc                     	movq	%rcx, %r12
     f8c: 49 c1 c4 17                  	rolq	$0x17, %r12
     f90: 4d 31 fc                     	xorq	%r15, %r12
     f93: 49 89 d6                     	movq	%rdx, %r14
     f96: 4d 31 de                     	xorq	%r11, %r14
     f99: 49 21 ce                     	andq	%rcx, %r14
     f9c: 4c 03 8d 98 fd ff ff         	addq	-0x268(%rbp), %r9
     fa3: 4d 31 de                     	xorq	%r11, %r14
     fa6: 4d 01 f1                     	addq	%r14, %r9
     fa9: 49 be 42 02 03 a3 98 aa 07 d8	movabsq	$-0x27f855675cfcfdbe, %r14 # imm = 0xD807AA98A3030242
     fb3: 4d 01 ce                     	addq	%r9, %r14
     fb6: 4d 01 e6                     	addq	%r12, %r14
     fb9: 4d 89 c1                     	movq	%r8, %r9
     fbc: 49 c1 c1 24                  	rolq	$0x24, %r9
     fc0: 4d 01 f2                     	addq	%r14, %r10
     fc3: 4d 89 c7                     	movq	%r8, %r15
     fc6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
     fca: 4d 31 cf                     	xorq	%r9, %r15
     fcd: 4d 89 c4                     	movq	%r8, %r12
     fd0: 49 c1 c4 19                  	rolq	$0x19, %r12
     fd4: 4d 31 fc                     	xorq	%r15, %r12
     fd7: 49 89 f7                     	movq	%rsi, %r15
     fda: 49 09 df                     	orq	%rbx, %r15
     fdd: 4d 21 c7                     	andq	%r8, %r15
     fe0: 49 89 f1                     	movq	%rsi, %r9
     fe3: 49 21 d9                     	andq	%rbx, %r9
     fe6: 4d 09 f9                     	orq	%r15, %r9
     fe9: 4d 01 e1                     	addq	%r12, %r9
     fec: 4d 01 f1                     	addq	%r14, %r9
     fef: 4d 89 d6                     	movq	%r10, %r14
     ff2: 49 c1 c6 32                  	rolq	$0x32, %r14
     ff6: 4d 89 d7                     	movq	%r10, %r15
     ff9: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     ffd: 4d 31 f7                     	xorq	%r14, %r15
    1000: 4d 89 d4                     	movq	%r10, %r12
    1003: 49 c1 c4 17                  	rolq	$0x17, %r12
    1007: 4d 31 fc                     	xorq	%r15, %r12
    100a: 49 89 ce                     	movq	%rcx, %r14
    100d: 49 31 d6                     	xorq	%rdx, %r14
    1010: 4d 21 d6                     	andq	%r10, %r14
    1013: 49 31 d6                     	xorq	%rdx, %r14
    1016: 4c 03 9d a0 fd ff ff         	addq	-0x260(%rbp), %r11
    101d: 4d 01 f3                     	addq	%r14, %r11
    1020: 49 be be 6f 70 45 01 5b 83 12	movabsq	$0x12835b0145706fbe, %r14 # imm = 0x12835B0145706FBE
    102a: 4d 01 de                     	addq	%r11, %r14
    102d: 4d 89 cb                     	movq	%r9, %r11
    1030: 49 c1 c3 24                  	rolq	$0x24, %r11
    1034: 4d 01 e6                     	addq	%r12, %r14
    1037: 4d 89 cf                     	movq	%r9, %r15
    103a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    103e: 4c 01 f3                     	addq	%r14, %rbx
    1041: 4d 89 cc                     	movq	%r9, %r12
    1044: 49 c1 c4 19                  	rolq	$0x19, %r12
    1048: 4d 31 df                     	xorq	%r11, %r15
    104b: 4d 31 fc                     	xorq	%r15, %r12
    104e: 4d 89 c7                     	movq	%r8, %r15
    1051: 49 09 f7                     	orq	%rsi, %r15
    1054: 4d 21 cf                     	andq	%r9, %r15
    1057: 4d 89 c3                     	movq	%r8, %r11
    105a: 49 21 f3                     	andq	%rsi, %r11
    105d: 4d 09 fb                     	orq	%r15, %r11
    1060: 4d 01 e3                     	addq	%r12, %r11
    1063: 49 89 df                     	movq	%rbx, %r15
    1066: 49 c1 c7 32                  	rolq	$0x32, %r15
    106a: 4d 01 f3                     	addq	%r14, %r11
    106d: 49 89 de                     	movq	%rbx, %r14
    1070: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1074: 4d 31 fe                     	xorq	%r15, %r14
    1077: 49 89 df                     	movq	%rbx, %r15
    107a: 49 c1 c7 17                  	rolq	$0x17, %r15
    107e: 4d 31 f7                     	xorq	%r14, %r15
    1081: 4d 89 d6                     	movq	%r10, %r14
    1084: 49 31 ce                     	xorq	%rcx, %r14
    1087: 49 21 de                     	andq	%rbx, %r14
    108a: 49 31 ce                     	xorq	%rcx, %r14
    108d: 48 03 95 a8 fd ff ff         	addq	-0x258(%rbp), %rdx
    1094: 4c 01 f2                     	addq	%r14, %rdx
    1097: 49 be 8c b2 e4 4e be 85 31 24	movabsq	$0x243185be4ee4b28c, %r14 # imm = 0x243185BE4EE4B28C
    10a1: 49 01 d6                     	addq	%rdx, %r14
    10a4: 4d 01 fe                     	addq	%r15, %r14
    10a7: 4c 01 f6                     	addq	%r14, %rsi
    10aa: 4c 89 da                     	movq	%r11, %rdx
    10ad: 48 c1 c2 24                  	rolq	$0x24, %rdx
    10b1: 4d 89 df                     	movq	%r11, %r15
    10b4: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    10b8: 49 31 d7                     	xorq	%rdx, %r15
    10bb: 4d 89 dc                     	movq	%r11, %r12
    10be: 49 c1 c4 19                  	rolq	$0x19, %r12
    10c2: 4d 31 fc                     	xorq	%r15, %r12
    10c5: 4d 89 cf                     	movq	%r9, %r15
    10c8: 4d 09 c7                     	orq	%r8, %r15
    10cb: 4d 21 df                     	andq	%r11, %r15
    10ce: 4c 89 ca                     	movq	%r9, %rdx
    10d1: 4c 21 c2                     	andq	%r8, %rdx
    10d4: 4c 09 fa                     	orq	%r15, %rdx
    10d7: 49 89 f7                     	movq	%rsi, %r15
    10da: 49 c1 c7 32                  	rolq	$0x32, %r15
    10de: 4c 01 e2                     	addq	%r12, %rdx
    10e1: 49 89 f4                     	movq	%rsi, %r12
    10e4: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    10e8: 4c 01 f2                     	addq	%r14, %rdx
    10eb: 49 89 f6                     	movq	%rsi, %r14
    10ee: 49 c1 c6 17                  	rolq	$0x17, %r14
    10f2: 4d 31 fc                     	xorq	%r15, %r12
    10f5: 4d 31 e6                     	xorq	%r12, %r14
    10f8: 49 89 df                     	movq	%rbx, %r15
    10fb: 4d 31 d7                     	xorq	%r10, %r15
    10fe: 49 21 f7                     	andq	%rsi, %r15
    1101: 4d 31 d7                     	xorq	%r10, %r15
    1104: 48 03 8d b0 fd ff ff         	addq	-0x250(%rbp), %rcx
    110b: 4c 01 f9                     	addq	%r15, %rcx
    110e: 49 bf e2 b4 ff d5 c3 7d 0c 55	movabsq	$0x550c7dc3d5ffb4e2, %r15 # imm = 0x550C7DC3D5FFB4E2
    1118: 49 01 cf                     	addq	%rcx, %r15
    111b: 4d 01 f7                     	addq	%r14, %r15
    111e: 4d 01 f8                     	addq	%r15, %r8
    1121: 48 89 d1                     	movq	%rdx, %rcx
    1124: 48 c1 c1 24                  	rolq	$0x24, %rcx
    1128: 49 89 d6                     	movq	%rdx, %r14
    112b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    112f: 49 31 ce                     	xorq	%rcx, %r14
    1132: 49 89 d4                     	movq	%rdx, %r12
    1135: 49 c1 c4 19                  	rolq	$0x19, %r12
    1139: 4d 31 f4                     	xorq	%r14, %r12
    113c: 4d 89 de                     	movq	%r11, %r14
    113f: 4d 09 ce                     	orq	%r9, %r14
    1142: 49 21 d6                     	andq	%rdx, %r14
    1145: 4c 89 d9                     	movq	%r11, %rcx
    1148: 4c 21 c9                     	andq	%r9, %rcx
    114b: 4c 09 f1                     	orq	%r14, %rcx
    114e: 4c 01 e1                     	addq	%r12, %rcx
    1151: 4c 01 f9                     	addq	%r15, %rcx
    1154: 4d 89 c6                     	movq	%r8, %r14
    1157: 49 c1 c6 32                  	rolq	$0x32, %r14
    115b: 4d 89 c7                     	movq	%r8, %r15
    115e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1162: 4d 31 f7                     	xorq	%r14, %r15
    1165: 4d 89 c4                     	movq	%r8, %r12
    1168: 49 c1 c4 17                  	rolq	$0x17, %r12
    116c: 4d 31 fc                     	xorq	%r15, %r12
    116f: 49 89 f6                     	movq	%rsi, %r14
    1172: 49 31 de                     	xorq	%rbx, %r14
    1175: 4d 21 c6                     	andq	%r8, %r14
    1178: 4c 03 95 b8 fd ff ff         	addq	-0x248(%rbp), %r10
    117f: 49 31 de                     	xorq	%rbx, %r14
    1182: 4d 01 f2                     	addq	%r14, %r10
    1185: 49 be 6f 89 7b f2 74 5d be 72	movabsq	$0x72be5d74f27b896f, %r14 # imm = 0x72BE5D74F27B896F
    118f: 4d 01 d6                     	addq	%r10, %r14
    1192: 4d 01 e6                     	addq	%r12, %r14
    1195: 49 89 ca                     	movq	%rcx, %r10
    1198: 49 c1 c2 24                  	rolq	$0x24, %r10
    119c: 4d 01 f1                     	addq	%r14, %r9
    119f: 49 89 cf                     	movq	%rcx, %r15
    11a2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    11a6: 4d 31 d7                     	xorq	%r10, %r15
    11a9: 49 89 cc                     	movq	%rcx, %r12
    11ac: 49 c1 c4 19                  	rolq	$0x19, %r12
    11b0: 4d 31 fc                     	xorq	%r15, %r12
    11b3: 49 89 d7                     	movq	%rdx, %r15
    11b6: 4d 09 df                     	orq	%r11, %r15
    11b9: 49 21 cf                     	andq	%rcx, %r15
    11bc: 49 89 d2                     	movq	%rdx, %r10
    11bf: 4d 21 da                     	andq	%r11, %r10
    11c2: 4d 09 fa                     	orq	%r15, %r10
    11c5: 4d 01 e2                     	addq	%r12, %r10
    11c8: 4d 01 f2                     	addq	%r14, %r10
    11cb: 4d 89 ce                     	movq	%r9, %r14
    11ce: 49 c1 c6 32                  	rolq	$0x32, %r14
    11d2: 4d 89 cf                     	movq	%r9, %r15
    11d5: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    11d9: 4d 31 f7                     	xorq	%r14, %r15
    11dc: 4d 89 cc                     	movq	%r9, %r12
    11df: 49 c1 c4 17                  	rolq	$0x17, %r12
    11e3: 4d 31 fc                     	xorq	%r15, %r12
    11e6: 4d 89 c6                     	movq	%r8, %r14
    11e9: 49 31 f6                     	xorq	%rsi, %r14
    11ec: 4d 21 ce                     	andq	%r9, %r14
    11ef: 49 31 f6                     	xorq	%rsi, %r14
    11f2: 48 03 9d c0 fd ff ff         	addq	-0x240(%rbp), %rbx
    11f9: 4c 01 f3                     	addq	%r14, %rbx
    11fc: 49 be b1 96 16 3b fe b1 de 80	movabsq	$-0x7f214e01c4e9694f, %r14 # imm = 0x80DEB1FE3B1696B1
    1206: 49 01 de                     	addq	%rbx, %r14
    1209: 4c 89 d3                     	movq	%r10, %rbx
    120c: 48 c1 c3 24                  	rolq	$0x24, %rbx
    1210: 4d 01 e6                     	addq	%r12, %r14
    1213: 4d 89 d7                     	movq	%r10, %r15
    1216: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    121a: 4d 01 f3                     	addq	%r14, %r11
    121d: 4d 89 d4                     	movq	%r10, %r12
    1220: 49 c1 c4 19                  	rolq	$0x19, %r12
    1224: 49 31 df                     	xorq	%rbx, %r15
    1227: 4d 31 fc                     	xorq	%r15, %r12
    122a: 49 89 cf                     	movq	%rcx, %r15
    122d: 49 09 d7                     	orq	%rdx, %r15
    1230: 4d 21 d7                     	andq	%r10, %r15
    1233: 48 89 cb                     	movq	%rcx, %rbx
    1236: 48 21 d3                     	andq	%rdx, %rbx
    1239: 4c 09 fb                     	orq	%r15, %rbx
    123c: 4c 01 e3                     	addq	%r12, %rbx
    123f: 4d 89 df                     	movq	%r11, %r15
    1242: 49 c1 c7 32                  	rolq	$0x32, %r15
    1246: 4c 01 f3                     	addq	%r14, %rbx
    1249: 4d 89 de                     	movq	%r11, %r14
    124c: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1250: 4d 31 fe                     	xorq	%r15, %r14
    1253: 4d 89 df                     	movq	%r11, %r15
    1256: 49 c1 c7 17                  	rolq	$0x17, %r15
    125a: 4d 31 f7                     	xorq	%r14, %r15
    125d: 4d 89 ce                     	movq	%r9, %r14
    1260: 4d 31 c6                     	xorq	%r8, %r14
    1263: 4d 21 de                     	andq	%r11, %r14
    1266: 4d 31 c6                     	xorq	%r8, %r14
    1269: 48 03 b5 c8 fd ff ff         	addq	-0x238(%rbp), %rsi
    1270: 4c 01 f6                     	addq	%r14, %rsi
    1273: 49 be 35 12 c7 25 a7 06 dc 9b	movabsq	$-0x6423f958da38edcb, %r14 # imm = 0x9BDC06A725C71235
    127d: 49 01 f6                     	addq	%rsi, %r14
    1280: 4d 01 fe                     	addq	%r15, %r14
    1283: 4c 01 f2                     	addq	%r14, %rdx
    1286: 48 89 de                     	movq	%rbx, %rsi
    1289: 48 c1 c6 24                  	rolq	$0x24, %rsi
    128d: 49 89 df                     	movq	%rbx, %r15
    1290: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1294: 49 31 f7                     	xorq	%rsi, %r15
    1297: 49 89 dc                     	movq	%rbx, %r12
    129a: 49 c1 c4 19                  	rolq	$0x19, %r12
    129e: 4d 31 fc                     	xorq	%r15, %r12
    12a1: 4d 89 d7                     	movq	%r10, %r15
    12a4: 49 09 cf                     	orq	%rcx, %r15
    12a7: 49 21 df                     	andq	%rbx, %r15
    12aa: 4c 89 d6                     	movq	%r10, %rsi
    12ad: 48 21 ce                     	andq	%rcx, %rsi
    12b0: 4c 09 fe                     	orq	%r15, %rsi
    12b3: 49 89 d7                     	movq	%rdx, %r15
    12b6: 49 c1 c7 32                  	rolq	$0x32, %r15
    12ba: 4c 01 e6                     	addq	%r12, %rsi
    12bd: 49 89 d4                     	movq	%rdx, %r12
    12c0: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    12c4: 4c 01 f6                     	addq	%r14, %rsi
    12c7: 49 89 d6                     	movq	%rdx, %r14
    12ca: 49 c1 c6 17                  	rolq	$0x17, %r14
    12ce: 4d 31 fc                     	xorq	%r15, %r12
    12d1: 4d 31 e6                     	xorq	%r12, %r14
    12d4: 4d 89 df                     	movq	%r11, %r15
    12d7: 4d 31 cf                     	xorq	%r9, %r15
    12da: 49 21 d7                     	andq	%rdx, %r15
    12dd: 4d 31 cf                     	xorq	%r9, %r15
    12e0: 4c 03 85 d0 fd ff ff         	addq	-0x230(%rbp), %r8
    12e7: 4d 01 f8                     	addq	%r15, %r8
    12ea: 49 bf 94 26 69 cf 74 f1 9b c1	movabsq	$-0x3e640e8b3096d96c, %r15 # imm = 0xC19BF174CF692694
    12f4: 4d 01 c7                     	addq	%r8, %r15
    12f7: 4d 01 f7                     	addq	%r14, %r15
    12fa: 4c 01 f9                     	addq	%r15, %rcx
    12fd: 49 89 f0                     	movq	%rsi, %r8
    1300: 49 c1 c0 24                  	rolq	$0x24, %r8
    1304: 49 89 f6                     	movq	%rsi, %r14
    1307: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    130b: 4d 31 c6                     	xorq	%r8, %r14
    130e: 49 89 f4                     	movq	%rsi, %r12
    1311: 49 c1 c4 19                  	rolq	$0x19, %r12
    1315: 4d 31 f4                     	xorq	%r14, %r12
    1318: 49 89 de                     	movq	%rbx, %r14
    131b: 4d 09 d6                     	orq	%r10, %r14
    131e: 49 21 f6                     	andq	%rsi, %r14
    1321: 49 89 d8                     	movq	%rbx, %r8
    1324: 4d 21 d0                     	andq	%r10, %r8
    1327: 4d 09 f0                     	orq	%r14, %r8
    132a: 4d 01 e0                     	addq	%r12, %r8
    132d: 4d 01 f8                     	addq	%r15, %r8
    1330: 49 89 ce                     	movq	%rcx, %r14
    1333: 49 c1 c6 32                  	rolq	$0x32, %r14
    1337: 49 89 cf                     	movq	%rcx, %r15
    133a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    133e: 4d 31 f7                     	xorq	%r14, %r15
    1341: 49 89 cc                     	movq	%rcx, %r12
    1344: 49 c1 c4 17                  	rolq	$0x17, %r12
    1348: 4d 31 fc                     	xorq	%r15, %r12
    134b: 49 89 d6                     	movq	%rdx, %r14
    134e: 4d 31 de                     	xorq	%r11, %r14
    1351: 49 21 ce                     	andq	%rcx, %r14
    1354: 4c 03 8d d8 fd ff ff         	addq	-0x228(%rbp), %r9
    135b: 4d 31 de                     	xorq	%r11, %r14
    135e: 4d 01 f1                     	addq	%r14, %r9
    1361: 49 be d2 4a f1 9e c1 69 9b e4	movabsq	$-0x1b64963e610eb52e, %r14 # imm = 0xE49B69C19EF14AD2
    136b: 4d 01 ce                     	addq	%r9, %r14
    136e: 4d 01 e6                     	addq	%r12, %r14
    1371: 4d 89 c1                     	movq	%r8, %r9
    1374: 49 c1 c1 24                  	rolq	$0x24, %r9
    1378: 4d 01 f2                     	addq	%r14, %r10
    137b: 4d 89 c7                     	movq	%r8, %r15
    137e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1382: 4d 31 cf                     	xorq	%r9, %r15
    1385: 4d 89 c4                     	movq	%r8, %r12
    1388: 49 c1 c4 19                  	rolq	$0x19, %r12
    138c: 4d 31 fc                     	xorq	%r15, %r12
    138f: 49 89 f7                     	movq	%rsi, %r15
    1392: 49 09 df                     	orq	%rbx, %r15
    1395: 4d 21 c7                     	andq	%r8, %r15
    1398: 49 89 f1                     	movq	%rsi, %r9
    139b: 49 21 d9                     	andq	%rbx, %r9
    139e: 4d 09 f9                     	orq	%r15, %r9
    13a1: 4d 01 e1                     	addq	%r12, %r9
    13a4: 4d 01 f1                     	addq	%r14, %r9
    13a7: 4d 89 d6                     	movq	%r10, %r14
    13aa: 49 c1 c6 32                  	rolq	$0x32, %r14
    13ae: 4d 89 d7                     	movq	%r10, %r15
    13b1: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    13b5: 4d 31 f7                     	xorq	%r14, %r15
    13b8: 4d 89 d4                     	movq	%r10, %r12
    13bb: 49 c1 c4 17                  	rolq	$0x17, %r12
    13bf: 4d 31 fc                     	xorq	%r15, %r12
    13c2: 49 89 ce                     	movq	%rcx, %r14
    13c5: 49 31 d6                     	xorq	%rdx, %r14
    13c8: 4d 21 d6                     	andq	%r10, %r14
    13cb: 49 31 d6                     	xorq	%rdx, %r14
    13ce: 4c 03 9d e0 fd ff ff         	addq	-0x220(%rbp), %r11
    13d5: 4d 01 f3                     	addq	%r14, %r11
    13d8: 49 be e3 25 4f 38 86 47 be ef	movabsq	$-0x1041b879c7b0da1d, %r14 # imm = 0xEFBE4786384F25E3
    13e2: 4d 01 de                     	addq	%r11, %r14
    13e5: 4d 89 cb                     	movq	%r9, %r11
    13e8: 49 c1 c3 24                  	rolq	$0x24, %r11
    13ec: 4d 01 e6                     	addq	%r12, %r14
    13ef: 4d 89 cf                     	movq	%r9, %r15
    13f2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    13f6: 4c 01 f3                     	addq	%r14, %rbx
    13f9: 4d 89 cc                     	movq	%r9, %r12
    13fc: 49 c1 c4 19                  	rolq	$0x19, %r12
    1400: 4d 31 df                     	xorq	%r11, %r15
    1403: 4d 31 fc                     	xorq	%r15, %r12
    1406: 4d 89 c7                     	movq	%r8, %r15
    1409: 49 09 f7                     	orq	%rsi, %r15
    140c: 4d 21 cf                     	andq	%r9, %r15
    140f: 4d 89 c3                     	movq	%r8, %r11
    1412: 49 21 f3                     	andq	%rsi, %r11
    1415: 4d 09 fb                     	orq	%r15, %r11
    1418: 4d 01 e3                     	addq	%r12, %r11
    141b: 49 89 df                     	movq	%rbx, %r15
    141e: 49 c1 c7 32                  	rolq	$0x32, %r15
    1422: 4d 01 f3                     	addq	%r14, %r11
    1425: 49 89 de                     	movq	%rbx, %r14
    1428: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    142c: 4d 31 fe                     	xorq	%r15, %r14
    142f: 49 89 df                     	movq	%rbx, %r15
    1432: 49 c1 c7 17                  	rolq	$0x17, %r15
    1436: 4d 31 f7                     	xorq	%r14, %r15
    1439: 4d 89 d6                     	movq	%r10, %r14
    143c: 49 31 ce                     	xorq	%rcx, %r14
    143f: 49 21 de                     	andq	%rbx, %r14
    1442: 49 31 ce                     	xorq	%rcx, %r14
    1445: 48 03 95 e8 fd ff ff         	addq	-0x218(%rbp), %rdx
    144c: 4c 01 f2                     	addq	%r14, %rdx
    144f: 49 be b5 d5 8c 8b c6 9d c1 0f	movabsq	$0xfc19dc68b8cd5b5, %r14 # imm = 0xFC19DC68B8CD5B5
    1459: 49 01 d6                     	addq	%rdx, %r14
    145c: 4d 01 fe                     	addq	%r15, %r14
    145f: 4c 01 f6                     	addq	%r14, %rsi
    1462: 4c 89 da                     	movq	%r11, %rdx
    1465: 48 c1 c2 24                  	rolq	$0x24, %rdx
    1469: 4d 89 df                     	movq	%r11, %r15
    146c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1470: 49 31 d7                     	xorq	%rdx, %r15
    1473: 4d 89 dc                     	movq	%r11, %r12
    1476: 49 c1 c4 19                  	rolq	$0x19, %r12
    147a: 4d 31 fc                     	xorq	%r15, %r12
    147d: 4d 89 cf                     	movq	%r9, %r15
    1480: 4d 09 c7                     	orq	%r8, %r15
    1483: 4d 21 df                     	andq	%r11, %r15
    1486: 4c 89 ca                     	movq	%r9, %rdx
    1489: 4c 21 c2                     	andq	%r8, %rdx
    148c: 4c 09 fa                     	orq	%r15, %rdx
    148f: 49 89 f7                     	movq	%rsi, %r15
    1492: 49 c1 c7 32                  	rolq	$0x32, %r15
    1496: 4c 01 e2                     	addq	%r12, %rdx
    1499: 49 89 f4                     	movq	%rsi, %r12
    149c: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    14a0: 4c 01 f2                     	addq	%r14, %rdx
    14a3: 49 89 f6                     	movq	%rsi, %r14
    14a6: 49 c1 c6 17                  	rolq	$0x17, %r14
    14aa: 4d 31 fc                     	xorq	%r15, %r12
    14ad: 4d 31 e6                     	xorq	%r12, %r14
    14b0: 49 89 df                     	movq	%rbx, %r15
    14b3: 4d 31 d7                     	xorq	%r10, %r15
    14b6: 49 21 f7                     	andq	%rsi, %r15
    14b9: 4d 31 d7                     	xorq	%r10, %r15
    14bc: 48 03 8d f0 fd ff ff         	addq	-0x210(%rbp), %rcx
    14c3: 4c 01 f9                     	addq	%r15, %rcx
    14c6: 49 bf 65 9c ac 77 cc a1 0c 24	movabsq	$0x240ca1cc77ac9c65, %r15 # imm = 0x240CA1CC77AC9C65
    14d0: 49 01 cf                     	addq	%rcx, %r15
    14d3: 4d 01 f7                     	addq	%r14, %r15
    14d6: 4d 01 f8                     	addq	%r15, %r8
    14d9: 48 89 d1                     	movq	%rdx, %rcx
    14dc: 48 c1 c1 24                  	rolq	$0x24, %rcx
    14e0: 49 89 d6                     	movq	%rdx, %r14
    14e3: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    14e7: 49 31 ce                     	xorq	%rcx, %r14
    14ea: 49 89 d4                     	movq	%rdx, %r12
    14ed: 49 c1 c4 19                  	rolq	$0x19, %r12
    14f1: 4d 31 f4                     	xorq	%r14, %r12
    14f4: 4d 89 de                     	movq	%r11, %r14
    14f7: 4d 09 ce                     	orq	%r9, %r14
    14fa: 49 21 d6                     	andq	%rdx, %r14
    14fd: 4c 89 d9                     	movq	%r11, %rcx
    1500: 4c 21 c9                     	andq	%r9, %rcx
    1503: 4c 09 f1                     	orq	%r14, %rcx
    1506: 4c 01 e1                     	addq	%r12, %rcx
    1509: 4c 01 f9                     	addq	%r15, %rcx
    150c: 4d 89 c6                     	movq	%r8, %r14
    150f: 49 c1 c6 32                  	rolq	$0x32, %r14
    1513: 4d 89 c7                     	movq	%r8, %r15
    1516: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    151a: 4d 31 f7                     	xorq	%r14, %r15
    151d: 4d 89 c4                     	movq	%r8, %r12
    1520: 49 c1 c4 17                  	rolq	$0x17, %r12
    1524: 4d 31 fc                     	xorq	%r15, %r12
    1527: 49 89 f6                     	movq	%rsi, %r14
    152a: 49 31 de                     	xorq	%rbx, %r14
    152d: 4d 21 c6                     	andq	%r8, %r14
    1530: 4c 03 95 f8 fd ff ff         	addq	-0x208(%rbp), %r10
    1537: 49 31 de                     	xorq	%rbx, %r14
    153a: 4d 01 f2                     	addq	%r14, %r10
    153d: 49 be 75 02 2b 59 6f 2c e9 2d	movabsq	$0x2de92c6f592b0275, %r14 # imm = 0x2DE92C6F592B0275
    1547: 4d 01 d6                     	addq	%r10, %r14
    154a: 4d 01 e6                     	addq	%r12, %r14
    154d: 49 89 ca                     	movq	%rcx, %r10
    1550: 49 c1 c2 24                  	rolq	$0x24, %r10
    1554: 4d 01 f1                     	addq	%r14, %r9
    1557: 49 89 cf                     	movq	%rcx, %r15
    155a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    155e: 4d 31 d7                     	xorq	%r10, %r15
    1561: 49 89 cc                     	movq	%rcx, %r12
    1564: 49 c1 c4 19                  	rolq	$0x19, %r12
    1568: 4d 31 fc                     	xorq	%r15, %r12
    156b: 49 89 d7                     	movq	%rdx, %r15
    156e: 4d 09 df                     	orq	%r11, %r15
    1571: 49 21 cf                     	andq	%rcx, %r15
    1574: 49 89 d2                     	movq	%rdx, %r10
    1577: 4d 21 da                     	andq	%r11, %r10
    157a: 4d 09 fa                     	orq	%r15, %r10
    157d: 4d 01 e2                     	addq	%r12, %r10
    1580: 4d 01 f2                     	addq	%r14, %r10
    1583: 4d 89 ce                     	movq	%r9, %r14
    1586: 49 c1 c6 32                  	rolq	$0x32, %r14
    158a: 4d 89 cf                     	movq	%r9, %r15
    158d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1591: 4d 31 f7                     	xorq	%r14, %r15
    1594: 4d 89 cc                     	movq	%r9, %r12
    1597: 49 c1 c4 17                  	rolq	$0x17, %r12
    159b: 4d 31 fc                     	xorq	%r15, %r12
    159e: 4d 89 c6                     	movq	%r8, %r14
    15a1: 49 31 f6                     	xorq	%rsi, %r14
    15a4: 4d 21 ce                     	andq	%r9, %r14
    15a7: 49 31 f6                     	xorq	%rsi, %r14
    15aa: 48 03 9d 00 fe ff ff         	addq	-0x200(%rbp), %rbx
    15b1: 4c 01 f3                     	addq	%r14, %rbx
    15b4: 49 be 83 e4 a6 6e aa 84 74 4a	movabsq	$0x4a7484aa6ea6e483, %r14 # imm = 0x4A7484AA6EA6E483
    15be: 49 01 de                     	addq	%rbx, %r14
    15c1: 4c 89 d3                     	movq	%r10, %rbx
    15c4: 48 c1 c3 24                  	rolq	$0x24, %rbx
    15c8: 4d 01 e6                     	addq	%r12, %r14
    15cb: 4d 89 d7                     	movq	%r10, %r15
    15ce: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    15d2: 4d 01 f3                     	addq	%r14, %r11
    15d5: 4d 89 d4                     	movq	%r10, %r12
    15d8: 49 c1 c4 19                  	rolq	$0x19, %r12
    15dc: 49 31 df                     	xorq	%rbx, %r15
    15df: 4d 31 fc                     	xorq	%r15, %r12
    15e2: 49 89 cf                     	movq	%rcx, %r15
    15e5: 49 09 d7                     	orq	%rdx, %r15
    15e8: 4d 21 d7                     	andq	%r10, %r15
    15eb: 48 89 cb                     	movq	%rcx, %rbx
    15ee: 48 21 d3                     	andq	%rdx, %rbx
    15f1: 4c 09 fb                     	orq	%r15, %rbx
    15f4: 4c 01 e3                     	addq	%r12, %rbx
    15f7: 4d 89 df                     	movq	%r11, %r15
    15fa: 49 c1 c7 32                  	rolq	$0x32, %r15
    15fe: 4c 01 f3                     	addq	%r14, %rbx
    1601: 4d 89 de                     	movq	%r11, %r14
    1604: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1608: 4d 31 fe                     	xorq	%r15, %r14
    160b: 4d 89 df                     	movq	%r11, %r15
    160e: 49 c1 c7 17                  	rolq	$0x17, %r15
    1612: 4d 31 f7                     	xorq	%r14, %r15
    1615: 4d 89 ce                     	movq	%r9, %r14
    1618: 4d 31 c6                     	xorq	%r8, %r14
    161b: 4d 21 de                     	andq	%r11, %r14
    161e: 4d 31 c6                     	xorq	%r8, %r14
    1621: 48 03 b5 08 fe ff ff         	addq	-0x1f8(%rbp), %rsi
    1628: 4c 01 f6                     	addq	%r14, %rsi
    162b: 49 be d4 fb 41 bd dc a9 b0 5c	movabsq	$0x5cb0a9dcbd41fbd4, %r14 # imm = 0x5CB0A9DCBD41FBD4
    1635: 49 01 f6                     	addq	%rsi, %r14
    1638: 4d 01 fe                     	addq	%r15, %r14
    163b: 4c 01 f2                     	addq	%r14, %rdx
    163e: 48 89 de                     	movq	%rbx, %rsi
    1641: 48 c1 c6 24                  	rolq	$0x24, %rsi
    1645: 49 89 df                     	movq	%rbx, %r15
    1648: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    164c: 49 31 f7                     	xorq	%rsi, %r15
    164f: 49 89 dc                     	movq	%rbx, %r12
    1652: 49 c1 c4 19                  	rolq	$0x19, %r12
    1656: 4d 31 fc                     	xorq	%r15, %r12
    1659: 4d 89 d7                     	movq	%r10, %r15
    165c: 49 09 cf                     	orq	%rcx, %r15
    165f: 49 21 df                     	andq	%rbx, %r15
    1662: 4c 89 d6                     	movq	%r10, %rsi
    1665: 48 21 ce                     	andq	%rcx, %rsi
    1668: 4c 09 fe                     	orq	%r15, %rsi
    166b: 49 89 d7                     	movq	%rdx, %r15
    166e: 49 c1 c7 32                  	rolq	$0x32, %r15
    1672: 4c 01 e6                     	addq	%r12, %rsi
    1675: 49 89 d4                     	movq	%rdx, %r12
    1678: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    167c: 4c 01 f6                     	addq	%r14, %rsi
    167f: 49 89 d6                     	movq	%rdx, %r14
    1682: 49 c1 c6 17                  	rolq	$0x17, %r14
    1686: 4d 31 fc                     	xorq	%r15, %r12
    1689: 4d 31 e6                     	xorq	%r12, %r14
    168c: 4d 89 df                     	movq	%r11, %r15
    168f: 4d 31 cf                     	xorq	%r9, %r15
    1692: 49 21 d7                     	andq	%rdx, %r15
    1695: 4d 31 cf                     	xorq	%r9, %r15
    1698: 4c 03 85 10 fe ff ff         	addq	-0x1f0(%rbp), %r8
    169f: 4d 01 f8                     	addq	%r15, %r8
    16a2: 49 bf b5 53 11 83 da 88 f9 76	movabsq	$0x76f988da831153b5, %r15 # imm = 0x76F988DA831153B5
    16ac: 4d 01 c7                     	addq	%r8, %r15
    16af: 4d 01 f7                     	addq	%r14, %r15
    16b2: 4c 01 f9                     	addq	%r15, %rcx
    16b5: 49 89 f0                     	movq	%rsi, %r8
    16b8: 49 c1 c0 24                  	rolq	$0x24, %r8
    16bc: 49 89 f6                     	movq	%rsi, %r14
    16bf: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    16c3: 4d 31 c6                     	xorq	%r8, %r14
    16c6: 49 89 f4                     	movq	%rsi, %r12
    16c9: 49 c1 c4 19                  	rolq	$0x19, %r12
    16cd: 4d 31 f4                     	xorq	%r14, %r12
    16d0: 49 89 de                     	movq	%rbx, %r14
    16d3: 4d 09 d6                     	orq	%r10, %r14
    16d6: 49 21 f6                     	andq	%rsi, %r14
    16d9: 49 89 d8                     	movq	%rbx, %r8
    16dc: 4d 21 d0                     	andq	%r10, %r8
    16df: 4d 09 f0                     	orq	%r14, %r8
    16e2: 4d 01 e0                     	addq	%r12, %r8
    16e5: 4d 01 f8                     	addq	%r15, %r8
    16e8: 49 89 ce                     	movq	%rcx, %r14
    16eb: 49 c1 c6 32                  	rolq	$0x32, %r14
    16ef: 49 89 cf                     	movq	%rcx, %r15
    16f2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    16f6: 4d 31 f7                     	xorq	%r14, %r15
    16f9: 49 89 cc                     	movq	%rcx, %r12
    16fc: 49 c1 c4 17                  	rolq	$0x17, %r12
    1700: 4d 31 fc                     	xorq	%r15, %r12
    1703: 49 89 d6                     	movq	%rdx, %r14
    1706: 4d 31 de                     	xorq	%r11, %r14
    1709: 49 21 ce                     	andq	%rcx, %r14
    170c: 4c 03 8d 18 fe ff ff         	addq	-0x1e8(%rbp), %r9
    1713: 4d 31 de                     	xorq	%r11, %r14
    1716: 4d 01 f1                     	addq	%r14, %r9
    1719: 49 be ab df 66 ee 52 51 3e 98	movabsq	$-0x67c1aead11992055, %r14 # imm = 0x983E5152EE66DFAB
    1723: 4d 01 ce                     	addq	%r9, %r14
    1726: 4d 01 e6                     	addq	%r12, %r14
    1729: 4d 89 c1                     	movq	%r8, %r9
    172c: 49 c1 c1 24                  	rolq	$0x24, %r9
    1730: 4d 01 f2                     	addq	%r14, %r10
    1733: 4d 89 c7                     	movq	%r8, %r15
    1736: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    173a: 4d 31 cf                     	xorq	%r9, %r15
    173d: 4d 89 c4                     	movq	%r8, %r12
    1740: 49 c1 c4 19                  	rolq	$0x19, %r12
    1744: 4d 31 fc                     	xorq	%r15, %r12
    1747: 49 89 f7                     	movq	%rsi, %r15
    174a: 49 09 df                     	orq	%rbx, %r15
    174d: 4d 21 c7                     	andq	%r8, %r15
    1750: 49 89 f1                     	movq	%rsi, %r9
    1753: 49 21 d9                     	andq	%rbx, %r9
    1756: 4d 09 f9                     	orq	%r15, %r9
    1759: 4d 01 e1                     	addq	%r12, %r9
    175c: 4d 01 f1                     	addq	%r14, %r9
    175f: 4d 89 d6                     	movq	%r10, %r14
    1762: 49 c1 c6 32                  	rolq	$0x32, %r14
    1766: 4d 89 d7                     	movq	%r10, %r15
    1769: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    176d: 4d 31 f7                     	xorq	%r14, %r15
    1770: 4d 89 d4                     	movq	%r10, %r12
    1773: 49 c1 c4 17                  	rolq	$0x17, %r12
    1777: 4d 31 fc                     	xorq	%r15, %r12
    177a: 49 89 ce                     	movq	%rcx, %r14
    177d: 49 31 d6                     	xorq	%rdx, %r14
    1780: 4d 21 d6                     	andq	%r10, %r14
    1783: 49 31 d6                     	xorq	%rdx, %r14
    1786: 4c 03 9d 20 fe ff ff         	addq	-0x1e0(%rbp), %r11
    178d: 4d 01 f3                     	addq	%r14, %r11
    1790: 49 be 10 32 b4 2d 6d c6 31 a8	movabsq	$-0x57ce3992d24bcdf0, %r14 # imm = 0xA831C66D2DB43210
    179a: 4d 01 de                     	addq	%r11, %r14
    179d: 4d 89 cb                     	movq	%r9, %r11
    17a0: 49 c1 c3 24                  	rolq	$0x24, %r11
    17a4: 4d 01 e6                     	addq	%r12, %r14
    17a7: 4d 89 cf                     	movq	%r9, %r15
    17aa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    17ae: 4c 01 f3                     	addq	%r14, %rbx
    17b1: 4d 89 cc                     	movq	%r9, %r12
    17b4: 49 c1 c4 19                  	rolq	$0x19, %r12
    17b8: 4d 31 df                     	xorq	%r11, %r15
    17bb: 4d 31 fc                     	xorq	%r15, %r12
    17be: 4d 89 c7                     	movq	%r8, %r15
    17c1: 49 09 f7                     	orq	%rsi, %r15
    17c4: 4d 21 cf                     	andq	%r9, %r15
    17c7: 4d 89 c3                     	movq	%r8, %r11
    17ca: 49 21 f3                     	andq	%rsi, %r11
    17cd: 4d 09 fb                     	orq	%r15, %r11
    17d0: 4d 01 e3                     	addq	%r12, %r11
    17d3: 49 89 df                     	movq	%rbx, %r15
    17d6: 49 c1 c7 32                  	rolq	$0x32, %r15
    17da: 4d 01 f3                     	addq	%r14, %r11
    17dd: 49 89 de                     	movq	%rbx, %r14
    17e0: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    17e4: 4d 31 fe                     	xorq	%r15, %r14
    17e7: 49 89 df                     	movq	%rbx, %r15
    17ea: 49 c1 c7 17                  	rolq	$0x17, %r15
    17ee: 4d 31 f7                     	xorq	%r14, %r15
    17f1: 4d 89 d6                     	movq	%r10, %r14
    17f4: 49 31 ce                     	xorq	%rcx, %r14
    17f7: 49 21 de                     	andq	%rbx, %r14
    17fa: 49 31 ce                     	xorq	%rcx, %r14
    17fd: 48 03 95 28 fe ff ff         	addq	-0x1d8(%rbp), %rdx
    1804: 4c 01 f2                     	addq	%r14, %rdx
    1807: 49 be 3f 21 fb 98 c8 27 03 b0	movabsq	$-0x4ffcd8376704dec1, %r14 # imm = 0xB00327C898FB213F
    1811: 49 01 d6                     	addq	%rdx, %r14
    1814: 4d 01 fe                     	addq	%r15, %r14
    1817: 4c 01 f6                     	addq	%r14, %rsi
    181a: 4c 89 da                     	movq	%r11, %rdx
    181d: 48 c1 c2 24                  	rolq	$0x24, %rdx
    1821: 4d 89 df                     	movq	%r11, %r15
    1824: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1828: 49 31 d7                     	xorq	%rdx, %r15
    182b: 4d 89 dc                     	movq	%r11, %r12
    182e: 49 c1 c4 19                  	rolq	$0x19, %r12
    1832: 4d 31 fc                     	xorq	%r15, %r12
    1835: 4d 89 cf                     	movq	%r9, %r15
    1838: 4d 09 c7                     	orq	%r8, %r15
    183b: 4d 21 df                     	andq	%r11, %r15
    183e: 4c 89 ca                     	movq	%r9, %rdx
    1841: 4c 21 c2                     	andq	%r8, %rdx
    1844: 4c 09 fa                     	orq	%r15, %rdx
    1847: 49 89 f7                     	movq	%rsi, %r15
    184a: 49 c1 c7 32                  	rolq	$0x32, %r15
    184e: 4c 01 e2                     	addq	%r12, %rdx
    1851: 49 89 f4                     	movq	%rsi, %r12
    1854: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1858: 4c 01 f2                     	addq	%r14, %rdx
    185b: 49 89 f6                     	movq	%rsi, %r14
    185e: 49 c1 c6 17                  	rolq	$0x17, %r14
    1862: 4d 31 fc                     	xorq	%r15, %r12
    1865: 4d 31 e6                     	xorq	%r12, %r14
    1868: 49 89 df                     	movq	%rbx, %r15
    186b: 4d 31 d7                     	xorq	%r10, %r15
    186e: 49 21 f7                     	andq	%rsi, %r15
    1871: 4d 31 d7                     	xorq	%r10, %r15
    1874: 48 03 8d 30 fe ff ff         	addq	-0x1d0(%rbp), %rcx
    187b: 4c 01 f9                     	addq	%r15, %rcx
    187e: 49 bf e4 0e ef be c7 7f 59 bf	movabsq	$-0x40a680384110f11c, %r15 # imm = 0xBF597FC7BEEF0EE4
    1888: 49 01 cf                     	addq	%rcx, %r15
    188b: 4d 01 f7                     	addq	%r14, %r15
    188e: 4d 01 f8                     	addq	%r15, %r8
    1891: 48 89 d1                     	movq	%rdx, %rcx
    1894: 48 c1 c1 24                  	rolq	$0x24, %rcx
    1898: 49 89 d6                     	movq	%rdx, %r14
    189b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    189f: 49 31 ce                     	xorq	%rcx, %r14
    18a2: 49 89 d4                     	movq	%rdx, %r12
    18a5: 49 c1 c4 19                  	rolq	$0x19, %r12
    18a9: 4d 31 f4                     	xorq	%r14, %r12
    18ac: 4d 89 de                     	movq	%r11, %r14
    18af: 4d 09 ce                     	orq	%r9, %r14
    18b2: 49 21 d6                     	andq	%rdx, %r14
    18b5: 4c 89 d9                     	movq	%r11, %rcx
    18b8: 4c 21 c9                     	andq	%r9, %rcx
    18bb: 4c 09 f1                     	orq	%r14, %rcx
    18be: 4c 01 e1                     	addq	%r12, %rcx
    18c1: 4c 01 f9                     	addq	%r15, %rcx
    18c4: 4d 89 c6                     	movq	%r8, %r14
    18c7: 49 c1 c6 32                  	rolq	$0x32, %r14
    18cb: 4d 89 c7                     	movq	%r8, %r15
    18ce: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    18d2: 4d 31 f7                     	xorq	%r14, %r15
    18d5: 4d 89 c4                     	movq	%r8, %r12
    18d8: 49 c1 c4 17                  	rolq	$0x17, %r12
    18dc: 4d 31 fc                     	xorq	%r15, %r12
    18df: 49 89 f6                     	movq	%rsi, %r14
    18e2: 49 31 de                     	xorq	%rbx, %r14
    18e5: 4d 21 c6                     	andq	%r8, %r14
    18e8: 4c 03 95 38 fe ff ff         	addq	-0x1c8(%rbp), %r10
    18ef: 49 31 de                     	xorq	%rbx, %r14
    18f2: 4d 01 f2                     	addq	%r14, %r10
    18f5: 49 be c2 8f a8 3d f3 0b e0 c6	movabsq	$-0x391ff40cc257703e, %r14 # imm = 0xC6E00BF33DA88FC2
    18ff: 4d 01 d6                     	addq	%r10, %r14
    1902: 4d 01 e6                     	addq	%r12, %r14
    1905: 49 89 ca                     	movq	%rcx, %r10
    1908: 49 c1 c2 24                  	rolq	$0x24, %r10
    190c: 4d 01 f1                     	addq	%r14, %r9
    190f: 49 89 cf                     	movq	%rcx, %r15
    1912: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1916: 4d 31 d7                     	xorq	%r10, %r15
    1919: 49 89 cc                     	movq	%rcx, %r12
    191c: 49 c1 c4 19                  	rolq	$0x19, %r12
    1920: 4d 31 fc                     	xorq	%r15, %r12
    1923: 49 89 d7                     	movq	%rdx, %r15
    1926: 4d 09 df                     	orq	%r11, %r15
    1929: 49 21 cf                     	andq	%rcx, %r15
    192c: 49 89 d2                     	movq	%rdx, %r10
    192f: 4d 21 da                     	andq	%r11, %r10
    1932: 4d 09 fa                     	orq	%r15, %r10
    1935: 4d 01 e2                     	addq	%r12, %r10
    1938: 4d 01 f2                     	addq	%r14, %r10
    193b: 4d 89 ce                     	movq	%r9, %r14
    193e: 49 c1 c6 32                  	rolq	$0x32, %r14
    1942: 4d 89 cf                     	movq	%r9, %r15
    1945: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1949: 4d 31 f7                     	xorq	%r14, %r15
    194c: 4d 89 cc                     	movq	%r9, %r12
    194f: 49 c1 c4 17                  	rolq	$0x17, %r12
    1953: 4d 31 fc                     	xorq	%r15, %r12
    1956: 4d 89 c6                     	movq	%r8, %r14
    1959: 49 31 f6                     	xorq	%rsi, %r14
    195c: 4d 21 ce                     	andq	%r9, %r14
    195f: 49 31 f6                     	xorq	%rsi, %r14
    1962: 48 03 9d 40 fe ff ff         	addq	-0x1c0(%rbp), %rbx
    1969: 4c 01 f3                     	addq	%r14, %rbx
    196c: 49 be 25 a7 0a 93 47 91 a7 d5	movabsq	$-0x2a586eb86cf558db, %r14 # imm = 0xD5A79147930AA725
    1976: 49 01 de                     	addq	%rbx, %r14
    1979: 4c 89 d3                     	movq	%r10, %rbx
    197c: 48 c1 c3 24                  	rolq	$0x24, %rbx
    1980: 4d 01 e6                     	addq	%r12, %r14
    1983: 4d 89 d7                     	movq	%r10, %r15
    1986: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    198a: 4d 01 f3                     	addq	%r14, %r11
    198d: 4d 89 d4                     	movq	%r10, %r12
    1990: 49 c1 c4 19                  	rolq	$0x19, %r12
    1994: 49 31 df                     	xorq	%rbx, %r15
    1997: 4d 31 fc                     	xorq	%r15, %r12
    199a: 49 89 cf                     	movq	%rcx, %r15
    199d: 49 09 d7                     	orq	%rdx, %r15
    19a0: 4d 21 d7                     	andq	%r10, %r15
    19a3: 48 89 cb                     	movq	%rcx, %rbx
    19a6: 48 21 d3                     	andq	%rdx, %rbx
    19a9: 4c 09 fb                     	orq	%r15, %rbx
    19ac: 4c 01 e3                     	addq	%r12, %rbx
    19af: 4d 89 df                     	movq	%r11, %r15
    19b2: 49 c1 c7 32                  	rolq	$0x32, %r15
    19b6: 4c 01 f3                     	addq	%r14, %rbx
    19b9: 4d 89 de                     	movq	%r11, %r14
    19bc: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    19c0: 4d 31 fe                     	xorq	%r15, %r14
    19c3: 4d 89 df                     	movq	%r11, %r15
    19c6: 49 c1 c7 17                  	rolq	$0x17, %r15
    19ca: 4d 31 f7                     	xorq	%r14, %r15
    19cd: 4d 89 ce                     	movq	%r9, %r14
    19d0: 4d 31 c6                     	xorq	%r8, %r14
    19d3: 4d 21 de                     	andq	%r11, %r14
    19d6: 4d 31 c6                     	xorq	%r8, %r14
    19d9: 48 03 b5 48 fe ff ff         	addq	-0x1b8(%rbp), %rsi
    19e0: 4c 01 f6                     	addq	%r14, %rsi
    19e3: 49 be 6f 82 03 e0 51 63 ca 06	movabsq	$0x6ca6351e003826f, %r14 # imm = 0x6CA6351E003826F
    19ed: 49 01 f6                     	addq	%rsi, %r14
    19f0: 4d 01 fe                     	addq	%r15, %r14
    19f3: 4c 01 f2                     	addq	%r14, %rdx
    19f6: 48 89 de                     	movq	%rbx, %rsi
    19f9: 48 c1 c6 24                  	rolq	$0x24, %rsi
    19fd: 49 89 df                     	movq	%rbx, %r15
    1a00: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1a04: 49 31 f7                     	xorq	%rsi, %r15
    1a07: 49 89 dc                     	movq	%rbx, %r12
    1a0a: 49 c1 c4 19                  	rolq	$0x19, %r12
    1a0e: 4d 31 fc                     	xorq	%r15, %r12
    1a11: 4d 89 d7                     	movq	%r10, %r15
    1a14: 49 09 cf                     	orq	%rcx, %r15
    1a17: 49 21 df                     	andq	%rbx, %r15
    1a1a: 4c 89 d6                     	movq	%r10, %rsi
    1a1d: 48 21 ce                     	andq	%rcx, %rsi
    1a20: 4c 09 fe                     	orq	%r15, %rsi
    1a23: 49 89 d7                     	movq	%rdx, %r15
    1a26: 49 c1 c7 32                  	rolq	$0x32, %r15
    1a2a: 4c 01 e6                     	addq	%r12, %rsi
    1a2d: 49 89 d4                     	movq	%rdx, %r12
    1a30: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1a34: 4c 01 f6                     	addq	%r14, %rsi
    1a37: 49 89 d6                     	movq	%rdx, %r14
    1a3a: 49 c1 c6 17                  	rolq	$0x17, %r14
    1a3e: 4d 31 fc                     	xorq	%r15, %r12
    1a41: 4d 31 e6                     	xorq	%r12, %r14
    1a44: 4d 89 df                     	movq	%r11, %r15
    1a47: 4d 31 cf                     	xorq	%r9, %r15
    1a4a: 49 21 d7                     	andq	%rdx, %r15
    1a4d: 4d 31 cf                     	xorq	%r9, %r15
    1a50: 4c 03 85 50 fe ff ff         	addq	-0x1b0(%rbp), %r8
    1a57: 4d 01 f8                     	addq	%r15, %r8
    1a5a: 49 bf 70 6e 0e 0a 67 29 29 14	movabsq	$0x142929670a0e6e70, %r15 # imm = 0x142929670A0E6E70
    1a64: 4d 01 c7                     	addq	%r8, %r15
    1a67: 4d 01 f7                     	addq	%r14, %r15
    1a6a: 4c 01 f9                     	addq	%r15, %rcx
    1a6d: 49 89 f0                     	movq	%rsi, %r8
    1a70: 49 c1 c0 24                  	rolq	$0x24, %r8
    1a74: 49 89 f6                     	movq	%rsi, %r14
    1a77: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1a7b: 4d 31 c6                     	xorq	%r8, %r14
    1a7e: 49 89 f4                     	movq	%rsi, %r12
    1a81: 49 c1 c4 19                  	rolq	$0x19, %r12
    1a85: 4d 31 f4                     	xorq	%r14, %r12
    1a88: 49 89 de                     	movq	%rbx, %r14
    1a8b: 4d 09 d6                     	orq	%r10, %r14
    1a8e: 49 21 f6                     	andq	%rsi, %r14
    1a91: 49 89 d8                     	movq	%rbx, %r8
    1a94: 4d 21 d0                     	andq	%r10, %r8
    1a97: 4d 09 f0                     	orq	%r14, %r8
    1a9a: 4d 01 e0                     	addq	%r12, %r8
    1a9d: 4d 01 f8                     	addq	%r15, %r8
    1aa0: 49 89 ce                     	movq	%rcx, %r14
    1aa3: 49 c1 c6 32                  	rolq	$0x32, %r14
    1aa7: 49 89 cf                     	movq	%rcx, %r15
    1aaa: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1aae: 4d 31 f7                     	xorq	%r14, %r15
    1ab1: 49 89 cc                     	movq	%rcx, %r12
    1ab4: 49 c1 c4 17                  	rolq	$0x17, %r12
    1ab8: 4d 31 fc                     	xorq	%r15, %r12
    1abb: 49 89 d6                     	movq	%rdx, %r14
    1abe: 4d 31 de                     	xorq	%r11, %r14
    1ac1: 49 21 ce                     	andq	%rcx, %r14
    1ac4: 4c 03 8d 58 fe ff ff         	addq	-0x1a8(%rbp), %r9
    1acb: 4d 31 de                     	xorq	%r11, %r14
    1ace: 4d 01 f1                     	addq	%r14, %r9
    1ad1: 49 be fc 2f d2 46 85 0a b7 27	movabsq	$0x27b70a8546d22ffc, %r14 # imm = 0x27B70A8546D22FFC
    1adb: 4d 01 ce                     	addq	%r9, %r14
    1ade: 4d 01 e6                     	addq	%r12, %r14
    1ae1: 4d 89 c1                     	movq	%r8, %r9
    1ae4: 49 c1 c1 24                  	rolq	$0x24, %r9
    1ae8: 4d 01 f2                     	addq	%r14, %r10
    1aeb: 4d 89 c7                     	movq	%r8, %r15
    1aee: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1af2: 4d 31 cf                     	xorq	%r9, %r15
    1af5: 4d 89 c4                     	movq	%r8, %r12
    1af8: 49 c1 c4 19                  	rolq	$0x19, %r12
    1afc: 4d 31 fc                     	xorq	%r15, %r12
    1aff: 49 89 f7                     	movq	%rsi, %r15
    1b02: 49 09 df                     	orq	%rbx, %r15
    1b05: 4d 21 c7                     	andq	%r8, %r15
    1b08: 49 89 f1                     	movq	%rsi, %r9
    1b0b: 49 21 d9                     	andq	%rbx, %r9
    1b0e: 4d 09 f9                     	orq	%r15, %r9
    1b11: 4d 01 e1                     	addq	%r12, %r9
    1b14: 4d 01 f1                     	addq	%r14, %r9
    1b17: 4d 89 d6                     	movq	%r10, %r14
    1b1a: 49 c1 c6 32                  	rolq	$0x32, %r14
    1b1e: 4d 89 d7                     	movq	%r10, %r15
    1b21: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1b25: 4d 31 f7                     	xorq	%r14, %r15
    1b28: 4d 89 d4                     	movq	%r10, %r12
    1b2b: 49 c1 c4 17                  	rolq	$0x17, %r12
    1b2f: 4d 31 fc                     	xorq	%r15, %r12
    1b32: 49 89 ce                     	movq	%rcx, %r14
    1b35: 49 31 d6                     	xorq	%rdx, %r14
    1b38: 4d 21 d6                     	andq	%r10, %r14
    1b3b: 49 31 d6                     	xorq	%rdx, %r14
    1b3e: 4c 03 9d 60 fe ff ff         	addq	-0x1a0(%rbp), %r11
    1b45: 4d 01 f3                     	addq	%r14, %r11
    1b48: 49 be 26 c9 26 5c 38 21 1b 2e	movabsq	$0x2e1b21385c26c926, %r14 # imm = 0x2E1B21385C26C926
    1b52: 4d 01 de                     	addq	%r11, %r14
    1b55: 4d 89 cb                     	movq	%r9, %r11
    1b58: 49 c1 c3 24                  	rolq	$0x24, %r11
    1b5c: 4d 01 e6                     	addq	%r12, %r14
    1b5f: 4d 89 cf                     	movq	%r9, %r15
    1b62: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1b66: 4c 01 f3                     	addq	%r14, %rbx
    1b69: 4d 89 cc                     	movq	%r9, %r12
    1b6c: 49 c1 c4 19                  	rolq	$0x19, %r12
    1b70: 4d 31 df                     	xorq	%r11, %r15
    1b73: 4d 31 fc                     	xorq	%r15, %r12
    1b76: 4d 89 c7                     	movq	%r8, %r15
    1b79: 49 09 f7                     	orq	%rsi, %r15
    1b7c: 4d 21 cf                     	andq	%r9, %r15
    1b7f: 4d 89 c3                     	movq	%r8, %r11
    1b82: 49 21 f3                     	andq	%rsi, %r11
    1b85: 4d 09 fb                     	orq	%r15, %r11
    1b88: 4d 01 e3                     	addq	%r12, %r11
    1b8b: 49 89 df                     	movq	%rbx, %r15
    1b8e: 49 c1 c7 32                  	rolq	$0x32, %r15
    1b92: 4d 01 f3                     	addq	%r14, %r11
    1b95: 49 89 de                     	movq	%rbx, %r14
    1b98: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1b9c: 4d 31 fe                     	xorq	%r15, %r14
    1b9f: 49 89 df                     	movq	%rbx, %r15
    1ba2: 49 c1 c7 17                  	rolq	$0x17, %r15
    1ba6: 4d 31 f7                     	xorq	%r14, %r15
    1ba9: 4d 89 d6                     	movq	%r10, %r14
    1bac: 49 31 ce                     	xorq	%rcx, %r14
    1baf: 49 21 de                     	andq	%rbx, %r14
    1bb2: 49 31 ce                     	xorq	%rcx, %r14
    1bb5: 48 03 95 68 fe ff ff         	addq	-0x198(%rbp), %rdx
    1bbc: 4c 01 f2                     	addq	%r14, %rdx
    1bbf: 49 be ed 2a c4 5a fc 6d 2c 4d	movabsq	$0x4d2c6dfc5ac42aed, %r14 # imm = 0x4D2C6DFC5AC42AED
    1bc9: 49 01 d6                     	addq	%rdx, %r14
    1bcc: 4d 01 fe                     	addq	%r15, %r14
    1bcf: 4c 01 f6                     	addq	%r14, %rsi
    1bd2: 4c 89 da                     	movq	%r11, %rdx
    1bd5: 48 c1 c2 24                  	rolq	$0x24, %rdx
    1bd9: 4d 89 df                     	movq	%r11, %r15
    1bdc: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1be0: 49 31 d7                     	xorq	%rdx, %r15
    1be3: 4d 89 dc                     	movq	%r11, %r12
    1be6: 49 c1 c4 19                  	rolq	$0x19, %r12
    1bea: 4d 31 fc                     	xorq	%r15, %r12
    1bed: 4d 89 cf                     	movq	%r9, %r15
    1bf0: 4d 09 c7                     	orq	%r8, %r15
    1bf3: 4d 21 df                     	andq	%r11, %r15
    1bf6: 4c 89 ca                     	movq	%r9, %rdx
    1bf9: 4c 21 c2                     	andq	%r8, %rdx
    1bfc: 4c 09 fa                     	orq	%r15, %rdx
    1bff: 49 89 f7                     	movq	%rsi, %r15
    1c02: 49 c1 c7 32                  	rolq	$0x32, %r15
    1c06: 4c 01 e2                     	addq	%r12, %rdx
    1c09: 49 89 f4                     	movq	%rsi, %r12
    1c0c: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1c10: 4c 01 f2                     	addq	%r14, %rdx
    1c13: 49 89 f6                     	movq	%rsi, %r14
    1c16: 49 c1 c6 17                  	rolq	$0x17, %r14
    1c1a: 4d 31 fc                     	xorq	%r15, %r12
    1c1d: 4d 31 e6                     	xorq	%r12, %r14
    1c20: 49 89 df                     	movq	%rbx, %r15
    1c23: 4d 31 d7                     	xorq	%r10, %r15
    1c26: 49 21 f7                     	andq	%rsi, %r15
    1c29: 4d 31 d7                     	xorq	%r10, %r15
    1c2c: 48 03 8d 70 fe ff ff         	addq	-0x190(%rbp), %rcx
    1c33: 4c 01 f9                     	addq	%r15, %rcx
    1c36: 49 bf df b3 95 9d 13 0d 38 53	movabsq	$0x53380d139d95b3df, %r15 # imm = 0x53380D139D95B3DF
    1c40: 49 01 cf                     	addq	%rcx, %r15
    1c43: 4d 01 f7                     	addq	%r14, %r15
    1c46: 4d 01 f8                     	addq	%r15, %r8
    1c49: 48 89 d1                     	movq	%rdx, %rcx
    1c4c: 48 c1 c1 24                  	rolq	$0x24, %rcx
    1c50: 49 89 d6                     	movq	%rdx, %r14
    1c53: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1c57: 49 31 ce                     	xorq	%rcx, %r14
    1c5a: 49 89 d4                     	movq	%rdx, %r12
    1c5d: 49 c1 c4 19                  	rolq	$0x19, %r12
    1c61: 4d 31 f4                     	xorq	%r14, %r12
    1c64: 4d 89 de                     	movq	%r11, %r14
    1c67: 4d 09 ce                     	orq	%r9, %r14
    1c6a: 49 21 d6                     	andq	%rdx, %r14
    1c6d: 4c 89 d9                     	movq	%r11, %rcx
    1c70: 4c 21 c9                     	andq	%r9, %rcx
    1c73: 4c 09 f1                     	orq	%r14, %rcx
    1c76: 4c 01 e1                     	addq	%r12, %rcx
    1c79: 4c 01 f9                     	addq	%r15, %rcx
    1c7c: 4d 89 c6                     	movq	%r8, %r14
    1c7f: 49 c1 c6 32                  	rolq	$0x32, %r14
    1c83: 4d 89 c7                     	movq	%r8, %r15
    1c86: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1c8a: 4d 31 f7                     	xorq	%r14, %r15
    1c8d: 4d 89 c4                     	movq	%r8, %r12
    1c90: 49 c1 c4 17                  	rolq	$0x17, %r12
    1c94: 4d 31 fc                     	xorq	%r15, %r12
    1c97: 49 89 f6                     	movq	%rsi, %r14
    1c9a: 49 31 de                     	xorq	%rbx, %r14
    1c9d: 4d 21 c6                     	andq	%r8, %r14
    1ca0: 4c 03 95 78 fe ff ff         	addq	-0x188(%rbp), %r10
    1ca7: 49 31 de                     	xorq	%rbx, %r14
    1caa: 4d 01 f2                     	addq	%r14, %r10
    1cad: 49 be de 63 af 8b 54 73 0a 65	movabsq	$0x650a73548baf63de, %r14 # imm = 0x650A73548BAF63DE
    1cb7: 4d 01 d6                     	addq	%r10, %r14
    1cba: 4d 01 e6                     	addq	%r12, %r14
    1cbd: 49 89 ca                     	movq	%rcx, %r10
    1cc0: 49 c1 c2 24                  	rolq	$0x24, %r10
    1cc4: 4d 01 f1                     	addq	%r14, %r9
    1cc7: 49 89 cf                     	movq	%rcx, %r15
    1cca: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1cce: 4d 31 d7                     	xorq	%r10, %r15
    1cd1: 49 89 cc                     	movq	%rcx, %r12
    1cd4: 49 c1 c4 19                  	rolq	$0x19, %r12
    1cd8: 4d 31 fc                     	xorq	%r15, %r12
    1cdb: 49 89 d7                     	movq	%rdx, %r15
    1cde: 4d 09 df                     	orq	%r11, %r15
    1ce1: 49 21 cf                     	andq	%rcx, %r15
    1ce4: 49 89 d2                     	movq	%rdx, %r10
    1ce7: 4d 21 da                     	andq	%r11, %r10
    1cea: 4d 09 fa                     	orq	%r15, %r10
    1ced: 4d 01 e2                     	addq	%r12, %r10
    1cf0: 4d 01 f2                     	addq	%r14, %r10
    1cf3: 4d 89 ce                     	movq	%r9, %r14
    1cf6: 49 c1 c6 32                  	rolq	$0x32, %r14
    1cfa: 4d 89 cf                     	movq	%r9, %r15
    1cfd: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1d01: 4d 31 f7                     	xorq	%r14, %r15
    1d04: 4d 89 cc                     	movq	%r9, %r12
    1d07: 49 c1 c4 17                  	rolq	$0x17, %r12
    1d0b: 4d 31 fc                     	xorq	%r15, %r12
    1d0e: 4d 89 c6                     	movq	%r8, %r14
    1d11: 49 31 f6                     	xorq	%rsi, %r14
    1d14: 4d 21 ce                     	andq	%r9, %r14
    1d17: 49 31 f6                     	xorq	%rsi, %r14
    1d1a: 48 03 9d 80 fe ff ff         	addq	-0x180(%rbp), %rbx
    1d21: 4c 01 f3                     	addq	%r14, %rbx
    1d24: 49 be a8 b2 77 3c bb 0a 6a 76	movabsq	$0x766a0abb3c77b2a8, %r14 # imm = 0x766A0ABB3C77B2A8
    1d2e: 49 01 de                     	addq	%rbx, %r14
    1d31: 4c 89 d3                     	movq	%r10, %rbx
    1d34: 48 c1 c3 24                  	rolq	$0x24, %rbx
    1d38: 4d 01 e6                     	addq	%r12, %r14
    1d3b: 4d 89 d7                     	movq	%r10, %r15
    1d3e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1d42: 4d 01 f3                     	addq	%r14, %r11
    1d45: 4d 89 d4                     	movq	%r10, %r12
    1d48: 49 c1 c4 19                  	rolq	$0x19, %r12
    1d4c: 49 31 df                     	xorq	%rbx, %r15
    1d4f: 4d 31 fc                     	xorq	%r15, %r12
    1d52: 49 89 cf                     	movq	%rcx, %r15
    1d55: 49 09 d7                     	orq	%rdx, %r15
    1d58: 4d 21 d7                     	andq	%r10, %r15
    1d5b: 48 89 cb                     	movq	%rcx, %rbx
    1d5e: 48 21 d3                     	andq	%rdx, %rbx
    1d61: 4c 09 fb                     	orq	%r15, %rbx
    1d64: 4c 01 e3                     	addq	%r12, %rbx
    1d67: 4d 89 df                     	movq	%r11, %r15
    1d6a: 49 c1 c7 32                  	rolq	$0x32, %r15
    1d6e: 4c 01 f3                     	addq	%r14, %rbx
    1d71: 4d 89 de                     	movq	%r11, %r14
    1d74: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1d78: 4d 31 fe                     	xorq	%r15, %r14
    1d7b: 4d 89 df                     	movq	%r11, %r15
    1d7e: 49 c1 c7 17                  	rolq	$0x17, %r15
    1d82: 4d 31 f7                     	xorq	%r14, %r15
    1d85: 4d 89 ce                     	movq	%r9, %r14
    1d88: 4d 31 c6                     	xorq	%r8, %r14
    1d8b: 4d 21 de                     	andq	%r11, %r14
    1d8e: 4d 31 c6                     	xorq	%r8, %r14
    1d91: 48 03 b5 88 fe ff ff         	addq	-0x178(%rbp), %rsi
    1d98: 4c 01 f6                     	addq	%r14, %rsi
    1d9b: 49 be e6 ae ed 47 2e c9 c2 81	movabsq	$-0x7e3d36d1b812511a, %r14 # imm = 0x81C2C92E47EDAEE6
    1da5: 49 01 f6                     	addq	%rsi, %r14
    1da8: 4d 01 fe                     	addq	%r15, %r14
    1dab: 4c 01 f2                     	addq	%r14, %rdx
    1dae: 48 89 de                     	movq	%rbx, %rsi
    1db1: 48 c1 c6 24                  	rolq	$0x24, %rsi
    1db5: 49 89 df                     	movq	%rbx, %r15
    1db8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1dbc: 49 31 f7                     	xorq	%rsi, %r15
    1dbf: 49 89 dc                     	movq	%rbx, %r12
    1dc2: 49 c1 c4 19                  	rolq	$0x19, %r12
    1dc6: 4d 31 fc                     	xorq	%r15, %r12
    1dc9: 4d 89 d7                     	movq	%r10, %r15
    1dcc: 49 09 cf                     	orq	%rcx, %r15
    1dcf: 49 21 df                     	andq	%rbx, %r15
    1dd2: 4c 89 d6                     	movq	%r10, %rsi
    1dd5: 48 21 ce                     	andq	%rcx, %rsi
    1dd8: 4c 09 fe                     	orq	%r15, %rsi
    1ddb: 49 89 d7                     	movq	%rdx, %r15
    1dde: 49 c1 c7 32                  	rolq	$0x32, %r15
    1de2: 4c 01 e6                     	addq	%r12, %rsi
    1de5: 49 89 d4                     	movq	%rdx, %r12
    1de8: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1dec: 4c 01 f6                     	addq	%r14, %rsi
    1def: 49 89 d6                     	movq	%rdx, %r14
    1df2: 49 c1 c6 17                  	rolq	$0x17, %r14
    1df6: 4d 31 fc                     	xorq	%r15, %r12
    1df9: 4d 31 e6                     	xorq	%r12, %r14
    1dfc: 4d 89 df                     	movq	%r11, %r15
    1dff: 4d 31 cf                     	xorq	%r9, %r15
    1e02: 49 21 d7                     	andq	%rdx, %r15
    1e05: 4d 31 cf                     	xorq	%r9, %r15
    1e08: 4c 03 85 90 fe ff ff         	addq	-0x170(%rbp), %r8
    1e0f: 4d 01 f8                     	addq	%r15, %r8
    1e12: 49 bf 3b 35 82 14 85 2c 72 92	movabsq	$-0x6d8dd37aeb7dcac5, %r15 # imm = 0x92722C851482353B
    1e1c: 4d 01 c7                     	addq	%r8, %r15
    1e1f: 4d 01 f7                     	addq	%r14, %r15
    1e22: 4c 01 f9                     	addq	%r15, %rcx
    1e25: 49 89 f0                     	movq	%rsi, %r8
    1e28: 49 c1 c0 24                  	rolq	$0x24, %r8
    1e2c: 49 89 f6                     	movq	%rsi, %r14
    1e2f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1e33: 4d 31 c6                     	xorq	%r8, %r14
    1e36: 49 89 f4                     	movq	%rsi, %r12
    1e39: 49 c1 c4 19                  	rolq	$0x19, %r12
    1e3d: 4d 31 f4                     	xorq	%r14, %r12
    1e40: 49 89 de                     	movq	%rbx, %r14
    1e43: 4d 09 d6                     	orq	%r10, %r14
    1e46: 49 21 f6                     	andq	%rsi, %r14
    1e49: 49 89 d8                     	movq	%rbx, %r8
    1e4c: 4d 21 d0                     	andq	%r10, %r8
    1e4f: 4d 09 f0                     	orq	%r14, %r8
    1e52: 4d 01 e0                     	addq	%r12, %r8
    1e55: 4d 01 f8                     	addq	%r15, %r8
    1e58: 49 89 ce                     	movq	%rcx, %r14
    1e5b: 49 c1 c6 32                  	rolq	$0x32, %r14
    1e5f: 49 89 cf                     	movq	%rcx, %r15
    1e62: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1e66: 4d 31 f7                     	xorq	%r14, %r15
    1e69: 49 89 cc                     	movq	%rcx, %r12
    1e6c: 49 c1 c4 17                  	rolq	$0x17, %r12
    1e70: 4d 31 fc                     	xorq	%r15, %r12
    1e73: 49 89 d6                     	movq	%rdx, %r14
    1e76: 4d 31 de                     	xorq	%r11, %r14
    1e79: 49 21 ce                     	andq	%rcx, %r14
    1e7c: 4c 03 8d 98 fe ff ff         	addq	-0x168(%rbp), %r9
    1e83: 4d 31 de                     	xorq	%r11, %r14
    1e86: 4d 01 f1                     	addq	%r14, %r9
    1e89: 49 be 64 03 f1 4c a1 e8 bf a2	movabsq	$-0x5d40175eb30efc9c, %r14 # imm = 0xA2BFE8A14CF10364
    1e93: 4d 01 ce                     	addq	%r9, %r14
    1e96: 4d 01 e6                     	addq	%r12, %r14
    1e99: 4d 89 c1                     	movq	%r8, %r9
    1e9c: 49 c1 c1 24                  	rolq	$0x24, %r9
    1ea0: 4d 01 f2                     	addq	%r14, %r10
    1ea3: 4d 89 c7                     	movq	%r8, %r15
    1ea6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1eaa: 4d 31 cf                     	xorq	%r9, %r15
    1ead: 4d 89 c4                     	movq	%r8, %r12
    1eb0: 49 c1 c4 19                  	rolq	$0x19, %r12
    1eb4: 4d 31 fc                     	xorq	%r15, %r12
    1eb7: 49 89 f7                     	movq	%rsi, %r15
    1eba: 49 09 df                     	orq	%rbx, %r15
    1ebd: 4d 21 c7                     	andq	%r8, %r15
    1ec0: 49 89 f1                     	movq	%rsi, %r9
    1ec3: 49 21 d9                     	andq	%rbx, %r9
    1ec6: 4d 09 f9                     	orq	%r15, %r9
    1ec9: 4d 01 e1                     	addq	%r12, %r9
    1ecc: 4d 01 f1                     	addq	%r14, %r9
    1ecf: 4d 89 d6                     	movq	%r10, %r14
    1ed2: 49 c1 c6 32                  	rolq	$0x32, %r14
    1ed6: 4d 89 d7                     	movq	%r10, %r15
    1ed9: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1edd: 4d 31 f7                     	xorq	%r14, %r15
    1ee0: 4d 89 d4                     	movq	%r10, %r12
    1ee3: 49 c1 c4 17                  	rolq	$0x17, %r12
    1ee7: 4d 31 fc                     	xorq	%r15, %r12
    1eea: 49 89 ce                     	movq	%rcx, %r14
    1eed: 49 31 d6                     	xorq	%rdx, %r14
    1ef0: 4d 21 d6                     	andq	%r10, %r14
    1ef3: 49 31 d6                     	xorq	%rdx, %r14
    1ef6: 4c 03 9d a0 fe ff ff         	addq	-0x160(%rbp), %r11
    1efd: 4d 01 f3                     	addq	%r14, %r11
    1f00: 49 be 01 30 42 bc 4b 66 1a a8	movabsq	$-0x57e599b443bdcfff, %r14 # imm = 0xA81A664BBC423001
    1f0a: 4d 01 de                     	addq	%r11, %r14
    1f0d: 4d 89 cb                     	movq	%r9, %r11
    1f10: 49 c1 c3 24                  	rolq	$0x24, %r11
    1f14: 4d 01 e6                     	addq	%r12, %r14
    1f17: 4d 89 cf                     	movq	%r9, %r15
    1f1a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1f1e: 4c 01 f3                     	addq	%r14, %rbx
    1f21: 4d 89 cc                     	movq	%r9, %r12
    1f24: 49 c1 c4 19                  	rolq	$0x19, %r12
    1f28: 4d 31 df                     	xorq	%r11, %r15
    1f2b: 4d 31 fc                     	xorq	%r15, %r12
    1f2e: 4d 89 c7                     	movq	%r8, %r15
    1f31: 49 09 f7                     	orq	%rsi, %r15
    1f34: 4d 21 cf                     	andq	%r9, %r15
    1f37: 4d 89 c3                     	movq	%r8, %r11
    1f3a: 49 21 f3                     	andq	%rsi, %r11
    1f3d: 4d 09 fb                     	orq	%r15, %r11
    1f40: 4d 01 e3                     	addq	%r12, %r11
    1f43: 49 89 df                     	movq	%rbx, %r15
    1f46: 49 c1 c7 32                  	rolq	$0x32, %r15
    1f4a: 4d 01 f3                     	addq	%r14, %r11
    1f4d: 49 89 de                     	movq	%rbx, %r14
    1f50: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1f54: 4d 31 fe                     	xorq	%r15, %r14
    1f57: 49 89 df                     	movq	%rbx, %r15
    1f5a: 49 c1 c7 17                  	rolq	$0x17, %r15
    1f5e: 4d 31 f7                     	xorq	%r14, %r15
    1f61: 4d 89 d6                     	movq	%r10, %r14
    1f64: 49 31 ce                     	xorq	%rcx, %r14
    1f67: 49 21 de                     	andq	%rbx, %r14
    1f6a: 49 31 ce                     	xorq	%rcx, %r14
    1f6d: 48 03 95 a8 fe ff ff         	addq	-0x158(%rbp), %rdx
    1f74: 4c 01 f2                     	addq	%r14, %rdx
    1f77: 49 be 91 97 f8 d0 70 8b 4b c2	movabsq	$-0x3db4748f2f07686f, %r14 # imm = 0xC24B8B70D0F89791
    1f81: 49 01 d6                     	addq	%rdx, %r14
    1f84: 4d 01 fe                     	addq	%r15, %r14
    1f87: 4c 01 f6                     	addq	%r14, %rsi
    1f8a: 4c 89 da                     	movq	%r11, %rdx
    1f8d: 48 c1 c2 24                  	rolq	$0x24, %rdx
    1f91: 4d 89 df                     	movq	%r11, %r15
    1f94: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1f98: 49 31 d7                     	xorq	%rdx, %r15
    1f9b: 4d 89 dc                     	movq	%r11, %r12
    1f9e: 49 c1 c4 19                  	rolq	$0x19, %r12
    1fa2: 4d 31 fc                     	xorq	%r15, %r12
    1fa5: 4d 89 cf                     	movq	%r9, %r15
    1fa8: 4d 09 c7                     	orq	%r8, %r15
    1fab: 4d 21 df                     	andq	%r11, %r15
    1fae: 4c 89 ca                     	movq	%r9, %rdx
    1fb1: 4c 21 c2                     	andq	%r8, %rdx
    1fb4: 4c 09 fa                     	orq	%r15, %rdx
    1fb7: 49 89 f7                     	movq	%rsi, %r15
    1fba: 49 c1 c7 32                  	rolq	$0x32, %r15
    1fbe: 4c 01 e2                     	addq	%r12, %rdx
    1fc1: 49 89 f4                     	movq	%rsi, %r12
    1fc4: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1fc8: 4c 01 f2                     	addq	%r14, %rdx
    1fcb: 49 89 f6                     	movq	%rsi, %r14
    1fce: 49 c1 c6 17                  	rolq	$0x17, %r14
    1fd2: 4d 31 fc                     	xorq	%r15, %r12
    1fd5: 4d 31 e6                     	xorq	%r12, %r14
    1fd8: 49 89 df                     	movq	%rbx, %r15
    1fdb: 4d 31 d7                     	xorq	%r10, %r15
    1fde: 49 21 f7                     	andq	%rsi, %r15
    1fe1: 4d 31 d7                     	xorq	%r10, %r15
    1fe4: 48 03 8d b0 fe ff ff         	addq	-0x150(%rbp), %rcx
    1feb: 4c 01 f9                     	addq	%r15, %rcx
    1fee: 49 bf 30 be 54 06 a3 51 6c c7	movabsq	$-0x3893ae5cf9ab41d0, %r15 # imm = 0xC76C51A30654BE30
    1ff8: 49 01 cf                     	addq	%rcx, %r15
    1ffb: 4d 01 f7                     	addq	%r14, %r15
    1ffe: 4d 01 f8                     	addq	%r15, %r8
    2001: 48 89 d1                     	movq	%rdx, %rcx
    2004: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2008: 49 89 d6                     	movq	%rdx, %r14
    200b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    200f: 49 31 ce                     	xorq	%rcx, %r14
    2012: 49 89 d4                     	movq	%rdx, %r12
    2015: 49 c1 c4 19                  	rolq	$0x19, %r12
    2019: 4d 31 f4                     	xorq	%r14, %r12
    201c: 4d 89 de                     	movq	%r11, %r14
    201f: 4d 09 ce                     	orq	%r9, %r14
    2022: 49 21 d6                     	andq	%rdx, %r14
    2025: 4c 89 d9                     	movq	%r11, %rcx
    2028: 4c 21 c9                     	andq	%r9, %rcx
    202b: 4c 09 f1                     	orq	%r14, %rcx
    202e: 4c 01 e1                     	addq	%r12, %rcx
    2031: 4c 01 f9                     	addq	%r15, %rcx
    2034: 4d 89 c6                     	movq	%r8, %r14
    2037: 49 c1 c6 32                  	rolq	$0x32, %r14
    203b: 4d 89 c7                     	movq	%r8, %r15
    203e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2042: 4d 31 f7                     	xorq	%r14, %r15
    2045: 4d 89 c4                     	movq	%r8, %r12
    2048: 49 c1 c4 17                  	rolq	$0x17, %r12
    204c: 4d 31 fc                     	xorq	%r15, %r12
    204f: 49 89 f6                     	movq	%rsi, %r14
    2052: 49 31 de                     	xorq	%rbx, %r14
    2055: 4d 21 c6                     	andq	%r8, %r14
    2058: 4c 03 95 b8 fe ff ff         	addq	-0x148(%rbp), %r10
    205f: 49 31 de                     	xorq	%rbx, %r14
    2062: 4d 01 f2                     	addq	%r14, %r10
    2065: 49 be 18 52 ef d6 19 e8 92 d1	movabsq	$-0x2e6d17e62910ade8, %r14 # imm = 0xD192E819D6EF5218
    206f: 4d 01 d6                     	addq	%r10, %r14
    2072: 4d 01 e6                     	addq	%r12, %r14
    2075: 49 89 ca                     	movq	%rcx, %r10
    2078: 49 c1 c2 24                  	rolq	$0x24, %r10
    207c: 4d 01 f1                     	addq	%r14, %r9
    207f: 49 89 cf                     	movq	%rcx, %r15
    2082: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2086: 4d 31 d7                     	xorq	%r10, %r15
    2089: 49 89 cc                     	movq	%rcx, %r12
    208c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2090: 4d 31 fc                     	xorq	%r15, %r12
    2093: 49 89 d7                     	movq	%rdx, %r15
    2096: 4d 09 df                     	orq	%r11, %r15
    2099: 49 21 cf                     	andq	%rcx, %r15
    209c: 49 89 d2                     	movq	%rdx, %r10
    209f: 4d 21 da                     	andq	%r11, %r10
    20a2: 4d 09 fa                     	orq	%r15, %r10
    20a5: 4d 01 e2                     	addq	%r12, %r10
    20a8: 4d 01 f2                     	addq	%r14, %r10
    20ab: 4d 89 ce                     	movq	%r9, %r14
    20ae: 49 c1 c6 32                  	rolq	$0x32, %r14
    20b2: 4d 89 cf                     	movq	%r9, %r15
    20b5: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    20b9: 4d 31 f7                     	xorq	%r14, %r15
    20bc: 4d 89 cc                     	movq	%r9, %r12
    20bf: 49 c1 c4 17                  	rolq	$0x17, %r12
    20c3: 4d 31 fc                     	xorq	%r15, %r12
    20c6: 4d 89 c6                     	movq	%r8, %r14
    20c9: 49 31 f6                     	xorq	%rsi, %r14
    20cc: 4d 21 ce                     	andq	%r9, %r14
    20cf: 49 31 f6                     	xorq	%rsi, %r14
    20d2: 48 03 9d c0 fe ff ff         	addq	-0x140(%rbp), %rbx
    20d9: 4c 01 f3                     	addq	%r14, %rbx
    20dc: 49 be 10 a9 65 55 24 06 99 d6	movabsq	$-0x2966f9dbaa9a56f0, %r14 # imm = 0xD69906245565A910
    20e6: 49 01 de                     	addq	%rbx, %r14
    20e9: 4c 89 d3                     	movq	%r10, %rbx
    20ec: 48 c1 c3 24                  	rolq	$0x24, %rbx
    20f0: 4d 01 e6                     	addq	%r12, %r14
    20f3: 4d 89 d7                     	movq	%r10, %r15
    20f6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    20fa: 4d 01 f3                     	addq	%r14, %r11
    20fd: 4d 89 d4                     	movq	%r10, %r12
    2100: 49 c1 c4 19                  	rolq	$0x19, %r12
    2104: 49 31 df                     	xorq	%rbx, %r15
    2107: 4d 31 fc                     	xorq	%r15, %r12
    210a: 49 89 cf                     	movq	%rcx, %r15
    210d: 49 09 d7                     	orq	%rdx, %r15
    2110: 4d 21 d7                     	andq	%r10, %r15
    2113: 48 89 cb                     	movq	%rcx, %rbx
    2116: 48 21 d3                     	andq	%rdx, %rbx
    2119: 4c 09 fb                     	orq	%r15, %rbx
    211c: 4c 01 e3                     	addq	%r12, %rbx
    211f: 4d 89 df                     	movq	%r11, %r15
    2122: 49 c1 c7 32                  	rolq	$0x32, %r15
    2126: 4c 01 f3                     	addq	%r14, %rbx
    2129: 4d 89 de                     	movq	%r11, %r14
    212c: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2130: 4d 31 fe                     	xorq	%r15, %r14
    2133: 4d 89 df                     	movq	%r11, %r15
    2136: 49 c1 c7 17                  	rolq	$0x17, %r15
    213a: 4d 31 f7                     	xorq	%r14, %r15
    213d: 4d 89 ce                     	movq	%r9, %r14
    2140: 4d 31 c6                     	xorq	%r8, %r14
    2143: 4d 21 de                     	andq	%r11, %r14
    2146: 4d 31 c6                     	xorq	%r8, %r14
    2149: 48 03 b5 c8 fe ff ff         	addq	-0x138(%rbp), %rsi
    2150: 4c 01 f6                     	addq	%r14, %rsi
    2153: 49 be 2a 20 71 57 85 35 0e f4	movabsq	$-0xbf1ca7aa88edfd6, %r14 # imm = 0xF40E35855771202A
    215d: 49 01 f6                     	addq	%rsi, %r14
    2160: 4d 01 fe                     	addq	%r15, %r14
    2163: 4c 01 f2                     	addq	%r14, %rdx
    2166: 48 89 de                     	movq	%rbx, %rsi
    2169: 48 c1 c6 24                  	rolq	$0x24, %rsi
    216d: 49 89 df                     	movq	%rbx, %r15
    2170: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2174: 49 31 f7                     	xorq	%rsi, %r15
    2177: 49 89 dc                     	movq	%rbx, %r12
    217a: 49 c1 c4 19                  	rolq	$0x19, %r12
    217e: 4d 31 fc                     	xorq	%r15, %r12
    2181: 4d 89 d7                     	movq	%r10, %r15
    2184: 49 09 cf                     	orq	%rcx, %r15
    2187: 49 21 df                     	andq	%rbx, %r15
    218a: 4c 89 d6                     	movq	%r10, %rsi
    218d: 48 21 ce                     	andq	%rcx, %rsi
    2190: 4c 09 fe                     	orq	%r15, %rsi
    2193: 49 89 d7                     	movq	%rdx, %r15
    2196: 49 c1 c7 32                  	rolq	$0x32, %r15
    219a: 4c 01 e6                     	addq	%r12, %rsi
    219d: 49 89 d4                     	movq	%rdx, %r12
    21a0: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    21a4: 4c 01 f6                     	addq	%r14, %rsi
    21a7: 49 89 d6                     	movq	%rdx, %r14
    21aa: 49 c1 c6 17                  	rolq	$0x17, %r14
    21ae: 4d 31 fc                     	xorq	%r15, %r12
    21b1: 4d 31 e6                     	xorq	%r12, %r14
    21b4: 4d 89 df                     	movq	%r11, %r15
    21b7: 4d 31 cf                     	xorq	%r9, %r15
    21ba: 49 21 d7                     	andq	%rdx, %r15
    21bd: 4d 31 cf                     	xorq	%r9, %r15
    21c0: 4c 03 85 d0 fe ff ff         	addq	-0x130(%rbp), %r8
    21c7: 4d 01 f8                     	addq	%r15, %r8
    21ca: 49 bf b8 d1 bb 32 70 a0 6a 10	movabsq	$0x106aa07032bbd1b8, %r15 # imm = 0x106AA07032BBD1B8
    21d4: 4d 01 c7                     	addq	%r8, %r15
    21d7: 4d 01 f7                     	addq	%r14, %r15
    21da: 4c 01 f9                     	addq	%r15, %rcx
    21dd: 49 89 f0                     	movq	%rsi, %r8
    21e0: 49 c1 c0 24                  	rolq	$0x24, %r8
    21e4: 49 89 f6                     	movq	%rsi, %r14
    21e7: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    21eb: 4d 31 c6                     	xorq	%r8, %r14
    21ee: 49 89 f4                     	movq	%rsi, %r12
    21f1: 49 c1 c4 19                  	rolq	$0x19, %r12
    21f5: 4d 31 f4                     	xorq	%r14, %r12
    21f8: 49 89 de                     	movq	%rbx, %r14
    21fb: 4d 09 d6                     	orq	%r10, %r14
    21fe: 49 21 f6                     	andq	%rsi, %r14
    2201: 49 89 d8                     	movq	%rbx, %r8
    2204: 4d 21 d0                     	andq	%r10, %r8
    2207: 4d 09 f0                     	orq	%r14, %r8
    220a: 4d 01 e0                     	addq	%r12, %r8
    220d: 4d 01 f8                     	addq	%r15, %r8
    2210: 49 89 ce                     	movq	%rcx, %r14
    2213: 49 c1 c6 32                  	rolq	$0x32, %r14
    2217: 49 89 cf                     	movq	%rcx, %r15
    221a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    221e: 4d 31 f7                     	xorq	%r14, %r15
    2221: 49 89 cc                     	movq	%rcx, %r12
    2224: 49 c1 c4 17                  	rolq	$0x17, %r12
    2228: 4d 31 fc                     	xorq	%r15, %r12
    222b: 49 89 d6                     	movq	%rdx, %r14
    222e: 4d 31 de                     	xorq	%r11, %r14
    2231: 49 21 ce                     	andq	%rcx, %r14
    2234: 4c 03 8d d8 fe ff ff         	addq	-0x128(%rbp), %r9
    223b: 4d 31 de                     	xorq	%r11, %r14
    223e: 4d 01 f1                     	addq	%r14, %r9
    2241: 49 be c8 d0 d2 b8 16 c1 a4 19	movabsq	$0x19a4c116b8d2d0c8, %r14 # imm = 0x19A4C116B8D2D0C8
    224b: 4d 01 ce                     	addq	%r9, %r14
    224e: 4d 01 e6                     	addq	%r12, %r14
    2251: 4d 89 c1                     	movq	%r8, %r9
    2254: 49 c1 c1 24                  	rolq	$0x24, %r9
    2258: 4d 01 f2                     	addq	%r14, %r10
    225b: 4d 89 c7                     	movq	%r8, %r15
    225e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2262: 4d 31 cf                     	xorq	%r9, %r15
    2265: 4d 89 c4                     	movq	%r8, %r12
    2268: 49 c1 c4 19                  	rolq	$0x19, %r12
    226c: 4d 31 fc                     	xorq	%r15, %r12
    226f: 49 89 f7                     	movq	%rsi, %r15
    2272: 49 09 df                     	orq	%rbx, %r15
    2275: 4d 21 c7                     	andq	%r8, %r15
    2278: 49 89 f1                     	movq	%rsi, %r9
    227b: 49 21 d9                     	andq	%rbx, %r9
    227e: 4d 09 f9                     	orq	%r15, %r9
    2281: 4d 01 e1                     	addq	%r12, %r9
    2284: 4d 01 f1                     	addq	%r14, %r9
    2287: 4d 89 d6                     	movq	%r10, %r14
    228a: 49 c1 c6 32                  	rolq	$0x32, %r14
    228e: 4d 89 d7                     	movq	%r10, %r15
    2291: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2295: 4d 31 f7                     	xorq	%r14, %r15
    2298: 4d 89 d4                     	movq	%r10, %r12
    229b: 49 c1 c4 17                  	rolq	$0x17, %r12
    229f: 4d 31 fc                     	xorq	%r15, %r12
    22a2: 49 89 ce                     	movq	%rcx, %r14
    22a5: 49 31 d6                     	xorq	%rdx, %r14
    22a8: 4d 21 d6                     	andq	%r10, %r14
    22ab: 49 31 d6                     	xorq	%rdx, %r14
    22ae: 4c 03 9d e0 fe ff ff         	addq	-0x120(%rbp), %r11
    22b5: 4d 01 f3                     	addq	%r14, %r11
    22b8: 49 be 53 ab 41 51 08 6c 37 1e	movabsq	$0x1e376c085141ab53, %r14 # imm = 0x1E376C085141AB53
    22c2: 4d 01 de                     	addq	%r11, %r14
    22c5: 4d 89 cb                     	movq	%r9, %r11
    22c8: 49 c1 c3 24                  	rolq	$0x24, %r11
    22cc: 4d 01 e6                     	addq	%r12, %r14
    22cf: 4d 89 cf                     	movq	%r9, %r15
    22d2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    22d6: 4c 01 f3                     	addq	%r14, %rbx
    22d9: 4d 89 cc                     	movq	%r9, %r12
    22dc: 49 c1 c4 19                  	rolq	$0x19, %r12
    22e0: 4d 31 df                     	xorq	%r11, %r15
    22e3: 4d 31 fc                     	xorq	%r15, %r12
    22e6: 4d 89 c7                     	movq	%r8, %r15
    22e9: 49 09 f7                     	orq	%rsi, %r15
    22ec: 4d 21 cf                     	andq	%r9, %r15
    22ef: 4d 89 c3                     	movq	%r8, %r11
    22f2: 49 21 f3                     	andq	%rsi, %r11
    22f5: 4d 09 fb                     	orq	%r15, %r11
    22f8: 4d 01 e3                     	addq	%r12, %r11
    22fb: 49 89 df                     	movq	%rbx, %r15
    22fe: 49 c1 c7 32                  	rolq	$0x32, %r15
    2302: 4d 01 f3                     	addq	%r14, %r11
    2305: 49 89 de                     	movq	%rbx, %r14
    2308: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    230c: 4d 31 fe                     	xorq	%r15, %r14
    230f: 49 89 df                     	movq	%rbx, %r15
    2312: 49 c1 c7 17                  	rolq	$0x17, %r15
    2316: 4d 31 f7                     	xorq	%r14, %r15
    2319: 4d 89 d6                     	movq	%r10, %r14
    231c: 49 31 ce                     	xorq	%rcx, %r14
    231f: 49 21 de                     	andq	%rbx, %r14
    2322: 49 31 ce                     	xorq	%rcx, %r14
    2325: 48 03 95 e8 fe ff ff         	addq	-0x118(%rbp), %rdx
    232c: 4c 01 f2                     	addq	%r14, %rdx
    232f: 49 be 99 eb 8e df 4c 77 48 27	movabsq	$0x2748774cdf8eeb99, %r14 # imm = 0x2748774CDF8EEB99
    2339: 49 01 d6                     	addq	%rdx, %r14
    233c: 4d 01 fe                     	addq	%r15, %r14
    233f: 4c 01 f6                     	addq	%r14, %rsi
    2342: 4c 89 da                     	movq	%r11, %rdx
    2345: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2349: 4d 89 df                     	movq	%r11, %r15
    234c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2350: 49 31 d7                     	xorq	%rdx, %r15
    2353: 4d 89 dc                     	movq	%r11, %r12
    2356: 49 c1 c4 19                  	rolq	$0x19, %r12
    235a: 4d 31 fc                     	xorq	%r15, %r12
    235d: 4d 89 cf                     	movq	%r9, %r15
    2360: 4d 09 c7                     	orq	%r8, %r15
    2363: 4d 21 df                     	andq	%r11, %r15
    2366: 4c 89 ca                     	movq	%r9, %rdx
    2369: 4c 21 c2                     	andq	%r8, %rdx
    236c: 4c 09 fa                     	orq	%r15, %rdx
    236f: 49 89 f7                     	movq	%rsi, %r15
    2372: 49 c1 c7 32                  	rolq	$0x32, %r15
    2376: 4c 01 e2                     	addq	%r12, %rdx
    2379: 49 89 f4                     	movq	%rsi, %r12
    237c: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2380: 4c 01 f2                     	addq	%r14, %rdx
    2383: 49 89 f6                     	movq	%rsi, %r14
    2386: 49 c1 c6 17                  	rolq	$0x17, %r14
    238a: 4d 31 fc                     	xorq	%r15, %r12
    238d: 4d 31 e6                     	xorq	%r12, %r14
    2390: 49 89 df                     	movq	%rbx, %r15
    2393: 4d 31 d7                     	xorq	%r10, %r15
    2396: 49 21 f7                     	andq	%rsi, %r15
    2399: 4d 31 d7                     	xorq	%r10, %r15
    239c: 48 03 8d f0 fe ff ff         	addq	-0x110(%rbp), %rcx
    23a3: 4c 01 f9                     	addq	%r15, %rcx
    23a6: 49 bf a8 48 9b e1 b5 bc b0 34	movabsq	$0x34b0bcb5e19b48a8, %r15 # imm = 0x34B0BCB5E19B48A8
    23b0: 49 01 cf                     	addq	%rcx, %r15
    23b3: 4d 01 f7                     	addq	%r14, %r15
    23b6: 4d 01 f8                     	addq	%r15, %r8
    23b9: 48 89 d1                     	movq	%rdx, %rcx
    23bc: 48 c1 c1 24                  	rolq	$0x24, %rcx
    23c0: 49 89 d6                     	movq	%rdx, %r14
    23c3: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    23c7: 49 31 ce                     	xorq	%rcx, %r14
    23ca: 49 89 d4                     	movq	%rdx, %r12
    23cd: 49 c1 c4 19                  	rolq	$0x19, %r12
    23d1: 4d 31 f4                     	xorq	%r14, %r12
    23d4: 4d 89 de                     	movq	%r11, %r14
    23d7: 4d 09 ce                     	orq	%r9, %r14
    23da: 49 21 d6                     	andq	%rdx, %r14
    23dd: 4c 89 d9                     	movq	%r11, %rcx
    23e0: 4c 21 c9                     	andq	%r9, %rcx
    23e3: 4c 09 f1                     	orq	%r14, %rcx
    23e6: 4c 01 e1                     	addq	%r12, %rcx
    23e9: 4c 01 f9                     	addq	%r15, %rcx
    23ec: 4d 89 c6                     	movq	%r8, %r14
    23ef: 49 c1 c6 32                  	rolq	$0x32, %r14
    23f3: 4d 89 c7                     	movq	%r8, %r15
    23f6: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    23fa: 4d 31 f7                     	xorq	%r14, %r15
    23fd: 4d 89 c4                     	movq	%r8, %r12
    2400: 49 c1 c4 17                  	rolq	$0x17, %r12
    2404: 4d 31 fc                     	xorq	%r15, %r12
    2407: 49 89 f6                     	movq	%rsi, %r14
    240a: 49 31 de                     	xorq	%rbx, %r14
    240d: 4d 21 c6                     	andq	%r8, %r14
    2410: 4c 03 95 f8 fe ff ff         	addq	-0x108(%rbp), %r10
    2417: 49 31 de                     	xorq	%rbx, %r14
    241a: 4d 01 f2                     	addq	%r14, %r10
    241d: 49 be 63 5a c9 c5 b3 0c 1c 39	movabsq	$0x391c0cb3c5c95a63, %r14 # imm = 0x391C0CB3C5C95A63
    2427: 4d 01 d6                     	addq	%r10, %r14
    242a: 4d 01 e6                     	addq	%r12, %r14
    242d: 49 89 ca                     	movq	%rcx, %r10
    2430: 49 c1 c2 24                  	rolq	$0x24, %r10
    2434: 4d 01 f1                     	addq	%r14, %r9
    2437: 49 89 cf                     	movq	%rcx, %r15
    243a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    243e: 4d 31 d7                     	xorq	%r10, %r15
    2441: 49 89 cc                     	movq	%rcx, %r12
    2444: 49 c1 c4 19                  	rolq	$0x19, %r12
    2448: 4d 31 fc                     	xorq	%r15, %r12
    244b: 49 89 d7                     	movq	%rdx, %r15
    244e: 4d 09 df                     	orq	%r11, %r15
    2451: 49 21 cf                     	andq	%rcx, %r15
    2454: 49 89 d2                     	movq	%rdx, %r10
    2457: 4d 21 da                     	andq	%r11, %r10
    245a: 4d 09 fa                     	orq	%r15, %r10
    245d: 4d 01 e2                     	addq	%r12, %r10
    2460: 4d 01 f2                     	addq	%r14, %r10
    2463: 4d 89 ce                     	movq	%r9, %r14
    2466: 49 c1 c6 32                  	rolq	$0x32, %r14
    246a: 4d 89 cf                     	movq	%r9, %r15
    246d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2471: 4d 31 f7                     	xorq	%r14, %r15
    2474: 4d 89 cc                     	movq	%r9, %r12
    2477: 49 c1 c4 17                  	rolq	$0x17, %r12
    247b: 4d 31 fc                     	xorq	%r15, %r12
    247e: 4d 89 c6                     	movq	%r8, %r14
    2481: 49 31 f6                     	xorq	%rsi, %r14
    2484: 4d 21 ce                     	andq	%r9, %r14
    2487: 49 31 f6                     	xorq	%rsi, %r14
    248a: 48 03 9d 00 ff ff ff         	addq	-0x100(%rbp), %rbx
    2491: 4c 01 f3                     	addq	%r14, %rbx
    2494: 49 be cb 8a 41 e3 4a aa d8 4e	movabsq	$0x4ed8aa4ae3418acb, %r14 # imm = 0x4ED8AA4AE3418ACB
    249e: 49 01 de                     	addq	%rbx, %r14
    24a1: 4c 89 d3                     	movq	%r10, %rbx
    24a4: 48 c1 c3 24                  	rolq	$0x24, %rbx
    24a8: 4d 01 e6                     	addq	%r12, %r14
    24ab: 4d 89 d7                     	movq	%r10, %r15
    24ae: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    24b2: 4d 01 f3                     	addq	%r14, %r11
    24b5: 4d 89 d4                     	movq	%r10, %r12
    24b8: 49 c1 c4 19                  	rolq	$0x19, %r12
    24bc: 49 31 df                     	xorq	%rbx, %r15
    24bf: 4d 31 fc                     	xorq	%r15, %r12
    24c2: 49 89 cf                     	movq	%rcx, %r15
    24c5: 49 09 d7                     	orq	%rdx, %r15
    24c8: 4d 21 d7                     	andq	%r10, %r15
    24cb: 48 89 cb                     	movq	%rcx, %rbx
    24ce: 48 21 d3                     	andq	%rdx, %rbx
    24d1: 4c 09 fb                     	orq	%r15, %rbx
    24d4: 4c 01 e3                     	addq	%r12, %rbx
    24d7: 4d 89 df                     	movq	%r11, %r15
    24da: 49 c1 c7 32                  	rolq	$0x32, %r15
    24de: 4c 01 f3                     	addq	%r14, %rbx
    24e1: 4d 89 de                     	movq	%r11, %r14
    24e4: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    24e8: 4d 31 fe                     	xorq	%r15, %r14
    24eb: 4d 89 df                     	movq	%r11, %r15
    24ee: 49 c1 c7 17                  	rolq	$0x17, %r15
    24f2: 4d 31 f7                     	xorq	%r14, %r15
    24f5: 4d 89 ce                     	movq	%r9, %r14
    24f8: 4d 31 c6                     	xorq	%r8, %r14
    24fb: 4d 21 de                     	andq	%r11, %r14
    24fe: 4d 31 c6                     	xorq	%r8, %r14
    2501: 48 03 b5 08 ff ff ff         	addq	-0xf8(%rbp), %rsi
    2508: 4c 01 f6                     	addq	%r14, %rsi
    250b: 49 be 73 e3 63 77 4f ca 9c 5b	movabsq	$0x5b9cca4f7763e373, %r14 # imm = 0x5B9CCA4F7763E373
    2515: 49 01 f6                     	addq	%rsi, %r14
    2518: 4d 01 fe                     	addq	%r15, %r14
    251b: 4c 01 f2                     	addq	%r14, %rdx
    251e: 48 89 de                     	movq	%rbx, %rsi
    2521: 48 c1 c6 24                  	rolq	$0x24, %rsi
    2525: 49 89 df                     	movq	%rbx, %r15
    2528: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    252c: 49 31 f7                     	xorq	%rsi, %r15
    252f: 49 89 dc                     	movq	%rbx, %r12
    2532: 49 c1 c4 19                  	rolq	$0x19, %r12
    2536: 4d 31 fc                     	xorq	%r15, %r12
    2539: 4d 89 d7                     	movq	%r10, %r15
    253c: 49 09 cf                     	orq	%rcx, %r15
    253f: 49 21 df                     	andq	%rbx, %r15
    2542: 4c 89 d6                     	movq	%r10, %rsi
    2545: 48 21 ce                     	andq	%rcx, %rsi
    2548: 4c 09 fe                     	orq	%r15, %rsi
    254b: 49 89 d7                     	movq	%rdx, %r15
    254e: 49 c1 c7 32                  	rolq	$0x32, %r15
    2552: 4c 01 e6                     	addq	%r12, %rsi
    2555: 49 89 d4                     	movq	%rdx, %r12
    2558: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    255c: 4c 01 f6                     	addq	%r14, %rsi
    255f: 49 89 d6                     	movq	%rdx, %r14
    2562: 49 c1 c6 17                  	rolq	$0x17, %r14
    2566: 4d 31 fc                     	xorq	%r15, %r12
    2569: 4d 31 e6                     	xorq	%r12, %r14
    256c: 4d 89 df                     	movq	%r11, %r15
    256f: 4d 31 cf                     	xorq	%r9, %r15
    2572: 49 21 d7                     	andq	%rdx, %r15
    2575: 4d 31 cf                     	xorq	%r9, %r15
    2578: 4c 03 85 10 ff ff ff         	addq	-0xf0(%rbp), %r8
    257f: 4d 01 f8                     	addq	%r15, %r8
    2582: 49 bf a3 b8 b2 d6 f3 6f 2e 68	movabsq	$0x682e6ff3d6b2b8a3, %r15 # imm = 0x682E6FF3D6B2B8A3
    258c: 4d 01 c7                     	addq	%r8, %r15
    258f: 4d 01 f7                     	addq	%r14, %r15
    2592: 4c 01 f9                     	addq	%r15, %rcx
    2595: 49 89 f0                     	movq	%rsi, %r8
    2598: 49 c1 c0 24                  	rolq	$0x24, %r8
    259c: 49 89 f6                     	movq	%rsi, %r14
    259f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    25a3: 4d 31 c6                     	xorq	%r8, %r14
    25a6: 49 89 f4                     	movq	%rsi, %r12
    25a9: 49 c1 c4 19                  	rolq	$0x19, %r12
    25ad: 4d 31 f4                     	xorq	%r14, %r12
    25b0: 49 89 de                     	movq	%rbx, %r14
    25b3: 4d 09 d6                     	orq	%r10, %r14
    25b6: 49 21 f6                     	andq	%rsi, %r14
    25b9: 49 89 d8                     	movq	%rbx, %r8
    25bc: 4d 21 d0                     	andq	%r10, %r8
    25bf: 4d 09 f0                     	orq	%r14, %r8
    25c2: 4d 01 e0                     	addq	%r12, %r8
    25c5: 4d 01 f8                     	addq	%r15, %r8
    25c8: 49 89 ce                     	movq	%rcx, %r14
    25cb: 49 c1 c6 32                  	rolq	$0x32, %r14
    25cf: 49 89 cf                     	movq	%rcx, %r15
    25d2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    25d6: 4d 31 f7                     	xorq	%r14, %r15
    25d9: 49 89 cc                     	movq	%rcx, %r12
    25dc: 49 c1 c4 17                  	rolq	$0x17, %r12
    25e0: 4d 31 fc                     	xorq	%r15, %r12
    25e3: 49 89 d6                     	movq	%rdx, %r14
    25e6: 4d 31 de                     	xorq	%r11, %r14
    25e9: 49 21 ce                     	andq	%rcx, %r14
    25ec: 4c 03 8d 18 ff ff ff         	addq	-0xe8(%rbp), %r9
    25f3: 4d 31 de                     	xorq	%r11, %r14
    25f6: 4d 01 f1                     	addq	%r14, %r9
    25f9: 49 be fc b2 ef 5d ee 82 8f 74	movabsq	$0x748f82ee5defb2fc, %r14 # imm = 0x748F82EE5DEFB2FC
    2603: 4d 01 ce                     	addq	%r9, %r14
    2606: 4d 01 e6                     	addq	%r12, %r14
    2609: 4d 89 c1                     	movq	%r8, %r9
    260c: 49 c1 c1 24                  	rolq	$0x24, %r9
    2610: 4d 01 f2                     	addq	%r14, %r10
    2613: 4d 89 c7                     	movq	%r8, %r15
    2616: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    261a: 4d 31 cf                     	xorq	%r9, %r15
    261d: 4d 89 c4                     	movq	%r8, %r12
    2620: 49 c1 c4 19                  	rolq	$0x19, %r12
    2624: 4d 31 fc                     	xorq	%r15, %r12
    2627: 49 89 f7                     	movq	%rsi, %r15
    262a: 49 09 df                     	orq	%rbx, %r15
    262d: 4d 21 c7                     	andq	%r8, %r15
    2630: 49 89 f1                     	movq	%rsi, %r9
    2633: 49 21 d9                     	andq	%rbx, %r9
    2636: 4d 09 f9                     	orq	%r15, %r9
    2639: 4d 01 e1                     	addq	%r12, %r9
    263c: 4d 01 f1                     	addq	%r14, %r9
    263f: 4d 89 d6                     	movq	%r10, %r14
    2642: 49 c1 c6 32                  	rolq	$0x32, %r14
    2646: 4d 89 d7                     	movq	%r10, %r15
    2649: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    264d: 4d 31 f7                     	xorq	%r14, %r15
    2650: 4d 89 d4                     	movq	%r10, %r12
    2653: 49 c1 c4 17                  	rolq	$0x17, %r12
    2657: 4d 31 fc                     	xorq	%r15, %r12
    265a: 49 89 ce                     	movq	%rcx, %r14
    265d: 49 31 d6                     	xorq	%rdx, %r14
    2660: 4d 21 d6                     	andq	%r10, %r14
    2663: 49 31 d6                     	xorq	%rdx, %r14
    2666: 4c 03 9d 20 ff ff ff         	addq	-0xe0(%rbp), %r11
    266d: 4d 01 f3                     	addq	%r14, %r11
    2670: 49 be 60 2f 17 43 6f 63 a5 78	movabsq	$0x78a5636f43172f60, %r14 # imm = 0x78A5636F43172F60
    267a: 4d 01 de                     	addq	%r11, %r14
    267d: 4d 89 cb                     	movq	%r9, %r11
    2680: 49 c1 c3 24                  	rolq	$0x24, %r11
    2684: 4d 01 e6                     	addq	%r12, %r14
    2687: 4d 89 cf                     	movq	%r9, %r15
    268a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    268e: 4c 01 f3                     	addq	%r14, %rbx
    2691: 4d 89 cc                     	movq	%r9, %r12
    2694: 49 c1 c4 19                  	rolq	$0x19, %r12
    2698: 4d 31 df                     	xorq	%r11, %r15
    269b: 4d 31 fc                     	xorq	%r15, %r12
    269e: 4d 89 c7                     	movq	%r8, %r15
    26a1: 49 09 f7                     	orq	%rsi, %r15
    26a4: 4d 21 cf                     	andq	%r9, %r15
    26a7: 4d 89 c3                     	movq	%r8, %r11
    26aa: 49 21 f3                     	andq	%rsi, %r11
    26ad: 4d 09 fb                     	orq	%r15, %r11
    26b0: 4d 01 e3                     	addq	%r12, %r11
    26b3: 49 89 df                     	movq	%rbx, %r15
    26b6: 49 c1 c7 32                  	rolq	$0x32, %r15
    26ba: 4d 01 f3                     	addq	%r14, %r11
    26bd: 49 89 de                     	movq	%rbx, %r14
    26c0: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    26c4: 4d 31 fe                     	xorq	%r15, %r14
    26c7: 49 89 df                     	movq	%rbx, %r15
    26ca: 49 c1 c7 17                  	rolq	$0x17, %r15
    26ce: 4d 31 f7                     	xorq	%r14, %r15
    26d1: 4d 89 d6                     	movq	%r10, %r14
    26d4: 49 31 ce                     	xorq	%rcx, %r14
    26d7: 49 21 de                     	andq	%rbx, %r14
    26da: 49 31 ce                     	xorq	%rcx, %r14
    26dd: 48 03 95 28 ff ff ff         	addq	-0xd8(%rbp), %rdx
    26e4: 4c 01 f2                     	addq	%r14, %rdx
    26e7: 49 be 72 ab f0 a1 14 78 c8 84	movabsq	$-0x7b3787eb5e0f548e, %r14 # imm = 0x84C87814A1F0AB72
    26f1: 49 01 d6                     	addq	%rdx, %r14
    26f4: 4d 01 fe                     	addq	%r15, %r14
    26f7: 4c 01 f6                     	addq	%r14, %rsi
    26fa: 4c 89 da                     	movq	%r11, %rdx
    26fd: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2701: 4d 89 df                     	movq	%r11, %r15
    2704: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2708: 49 31 d7                     	xorq	%rdx, %r15
    270b: 4d 89 dc                     	movq	%r11, %r12
    270e: 49 c1 c4 19                  	rolq	$0x19, %r12
    2712: 4d 31 fc                     	xorq	%r15, %r12
    2715: 4d 89 cf                     	movq	%r9, %r15
    2718: 4d 09 c7                     	orq	%r8, %r15
    271b: 4d 21 df                     	andq	%r11, %r15
    271e: 4c 89 ca                     	movq	%r9, %rdx
    2721: 4c 21 c2                     	andq	%r8, %rdx
    2724: 4c 09 fa                     	orq	%r15, %rdx
    2727: 49 89 f7                     	movq	%rsi, %r15
    272a: 49 c1 c7 32                  	rolq	$0x32, %r15
    272e: 4c 01 e2                     	addq	%r12, %rdx
    2731: 49 89 f4                     	movq	%rsi, %r12
    2734: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2738: 4c 01 f2                     	addq	%r14, %rdx
    273b: 49 89 f6                     	movq	%rsi, %r14
    273e: 49 c1 c6 17                  	rolq	$0x17, %r14
    2742: 4d 31 fc                     	xorq	%r15, %r12
    2745: 4d 31 e6                     	xorq	%r12, %r14
    2748: 49 89 df                     	movq	%rbx, %r15
    274b: 4d 31 d7                     	xorq	%r10, %r15
    274e: 49 21 f7                     	andq	%rsi, %r15
    2751: 4d 31 d7                     	xorq	%r10, %r15
    2754: 48 03 8d 30 ff ff ff         	addq	-0xd0(%rbp), %rcx
    275b: 4c 01 f9                     	addq	%r15, %rcx
    275e: 49 bf ec 39 64 1a 08 02 c7 8c	movabsq	$-0x7338fdf7e59bc614, %r15 # imm = 0x8CC702081A6439EC
    2768: 49 01 cf                     	addq	%rcx, %r15
    276b: 4d 01 f7                     	addq	%r14, %r15
    276e: 4d 01 f8                     	addq	%r15, %r8
    2771: 48 89 d1                     	movq	%rdx, %rcx
    2774: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2778: 49 89 d6                     	movq	%rdx, %r14
    277b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    277f: 49 31 ce                     	xorq	%rcx, %r14
    2782: 49 89 d4                     	movq	%rdx, %r12
    2785: 49 c1 c4 19                  	rolq	$0x19, %r12
    2789: 4d 31 f4                     	xorq	%r14, %r12
    278c: 4d 89 de                     	movq	%r11, %r14
    278f: 4d 09 ce                     	orq	%r9, %r14
    2792: 49 21 d6                     	andq	%rdx, %r14
    2795: 4c 89 d9                     	movq	%r11, %rcx
    2798: 4c 21 c9                     	andq	%r9, %rcx
    279b: 4c 09 f1                     	orq	%r14, %rcx
    279e: 4c 01 e1                     	addq	%r12, %rcx
    27a1: 4c 01 f9                     	addq	%r15, %rcx
    27a4: 4d 89 c6                     	movq	%r8, %r14
    27a7: 49 c1 c6 32                  	rolq	$0x32, %r14
    27ab: 4d 89 c7                     	movq	%r8, %r15
    27ae: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    27b2: 4d 31 f7                     	xorq	%r14, %r15
    27b5: 4d 89 c4                     	movq	%r8, %r12
    27b8: 49 c1 c4 17                  	rolq	$0x17, %r12
    27bc: 4d 31 fc                     	xorq	%r15, %r12
    27bf: 49 89 f6                     	movq	%rsi, %r14
    27c2: 49 31 de                     	xorq	%rbx, %r14
    27c5: 4d 21 c6                     	andq	%r8, %r14
    27c8: 4c 03 95 38 ff ff ff         	addq	-0xc8(%rbp), %r10
    27cf: 49 31 de                     	xorq	%rbx, %r14
    27d2: 4d 01 f2                     	addq	%r14, %r10
    27d5: 49 be 28 1e 63 23 fa ff be 90	movabsq	$-0x6f410005dc9ce1d8, %r14 # imm = 0x90BEFFFA23631E28
    27df: 4d 01 d6                     	addq	%r10, %r14
    27e2: 4d 01 e6                     	addq	%r12, %r14
    27e5: 49 89 ca                     	movq	%rcx, %r10
    27e8: 49 c1 c2 24                  	rolq	$0x24, %r10
    27ec: 4d 01 f1                     	addq	%r14, %r9
    27ef: 49 89 cf                     	movq	%rcx, %r15
    27f2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    27f6: 4d 31 d7                     	xorq	%r10, %r15
    27f9: 49 89 cc                     	movq	%rcx, %r12
    27fc: 49 c1 c4 19                  	rolq	$0x19, %r12
    2800: 4d 31 fc                     	xorq	%r15, %r12
    2803: 49 89 d7                     	movq	%rdx, %r15
    2806: 4d 09 df                     	orq	%r11, %r15
    2809: 49 21 cf                     	andq	%rcx, %r15
    280c: 49 89 d2                     	movq	%rdx, %r10
    280f: 4d 21 da                     	andq	%r11, %r10
    2812: 4d 09 fa                     	orq	%r15, %r10
    2815: 4d 01 e2                     	addq	%r12, %r10
    2818: 4d 01 f2                     	addq	%r14, %r10
    281b: 4d 89 ce                     	movq	%r9, %r14
    281e: 49 c1 c6 32                  	rolq	$0x32, %r14
    2822: 4d 89 cf                     	movq	%r9, %r15
    2825: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2829: 4d 31 f7                     	xorq	%r14, %r15
    282c: 4d 89 cc                     	movq	%r9, %r12
    282f: 49 c1 c4 17                  	rolq	$0x17, %r12
    2833: 4d 31 fc                     	xorq	%r15, %r12
    2836: 4d 89 c6                     	movq	%r8, %r14
    2839: 49 31 f6                     	xorq	%rsi, %r14
    283c: 4d 21 ce                     	andq	%r9, %r14
    283f: 49 31 f6                     	xorq	%rsi, %r14
    2842: 48 03 9d 40 ff ff ff         	addq	-0xc0(%rbp), %rbx
    2849: 4c 01 f3                     	addq	%r14, %rbx
    284c: 49 be e9 bd 82 de eb 6c 50 a4	movabsq	$-0x5baf9314217d4217, %r14 # imm = 0xA4506CEBDE82BDE9
    2856: 49 01 de                     	addq	%rbx, %r14
    2859: 4c 89 d3                     	movq	%r10, %rbx
    285c: 48 c1 c3 24                  	rolq	$0x24, %rbx
    2860: 4d 01 e6                     	addq	%r12, %r14
    2863: 4d 89 d7                     	movq	%r10, %r15
    2866: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    286a: 4d 01 f3                     	addq	%r14, %r11
    286d: 4d 89 d4                     	movq	%r10, %r12
    2870: 49 c1 c4 19                  	rolq	$0x19, %r12
    2874: 49 31 df                     	xorq	%rbx, %r15
    2877: 4d 31 fc                     	xorq	%r15, %r12
    287a: 49 89 cf                     	movq	%rcx, %r15
    287d: 49 09 d7                     	orq	%rdx, %r15
    2880: 4d 21 d7                     	andq	%r10, %r15
    2883: 48 89 cb                     	movq	%rcx, %rbx
    2886: 48 21 d3                     	andq	%rdx, %rbx
    2889: 4c 09 fb                     	orq	%r15, %rbx
    288c: 4c 01 e3                     	addq	%r12, %rbx
    288f: 4d 89 df                     	movq	%r11, %r15
    2892: 49 c1 c7 32                  	rolq	$0x32, %r15
    2896: 4c 01 f3                     	addq	%r14, %rbx
    2899: 4d 89 de                     	movq	%r11, %r14
    289c: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    28a0: 4d 31 fe                     	xorq	%r15, %r14
    28a3: 4d 89 df                     	movq	%r11, %r15
    28a6: 49 c1 c7 17                  	rolq	$0x17, %r15
    28aa: 4d 31 f7                     	xorq	%r14, %r15
    28ad: 4d 89 ce                     	movq	%r9, %r14
    28b0: 4d 31 c6                     	xorq	%r8, %r14
    28b3: 4d 21 de                     	andq	%r11, %r14
    28b6: 4d 31 c6                     	xorq	%r8, %r14
    28b9: 48 03 b5 48 ff ff ff         	addq	-0xb8(%rbp), %rsi
    28c0: 4c 01 f6                     	addq	%r14, %rsi
    28c3: 49 be 15 79 c6 b2 f7 a3 f9 be	movabsq	$-0x41065c084d3986eb, %r14 # imm = 0xBEF9A3F7B2C67915
    28cd: 49 01 f6                     	addq	%rsi, %r14
    28d0: 4d 01 fe                     	addq	%r15, %r14
    28d3: 4c 01 f2                     	addq	%r14, %rdx
    28d6: 48 89 de                     	movq	%rbx, %rsi
    28d9: 48 c1 c6 24                  	rolq	$0x24, %rsi
    28dd: 49 89 df                     	movq	%rbx, %r15
    28e0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    28e4: 49 31 f7                     	xorq	%rsi, %r15
    28e7: 49 89 dc                     	movq	%rbx, %r12
    28ea: 49 c1 c4 19                  	rolq	$0x19, %r12
    28ee: 4d 31 fc                     	xorq	%r15, %r12
    28f1: 4d 89 d7                     	movq	%r10, %r15
    28f4: 49 09 cf                     	orq	%rcx, %r15
    28f7: 49 21 df                     	andq	%rbx, %r15
    28fa: 4c 89 d6                     	movq	%r10, %rsi
    28fd: 48 21 ce                     	andq	%rcx, %rsi
    2900: 4c 09 fe                     	orq	%r15, %rsi
    2903: 49 89 d7                     	movq	%rdx, %r15
    2906: 49 c1 c7 32                  	rolq	$0x32, %r15
    290a: 4c 01 e6                     	addq	%r12, %rsi
    290d: 49 89 d4                     	movq	%rdx, %r12
    2910: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2914: 4c 01 f6                     	addq	%r14, %rsi
    2917: 49 89 d6                     	movq	%rdx, %r14
    291a: 49 c1 c6 17                  	rolq	$0x17, %r14
    291e: 4d 31 fc                     	xorq	%r15, %r12
    2921: 4d 31 e6                     	xorq	%r12, %r14
    2924: 4d 89 df                     	movq	%r11, %r15
    2927: 4d 31 cf                     	xorq	%r9, %r15
    292a: 49 21 d7                     	andq	%rdx, %r15
    292d: 4d 31 cf                     	xorq	%r9, %r15
    2930: 4c 03 85 50 ff ff ff         	addq	-0xb0(%rbp), %r8
    2937: 4d 01 f8                     	addq	%r15, %r8
    293a: 49 bf 2b 53 72 e3 f2 78 71 c6	movabsq	$-0x398e870d1c8dacd5, %r15 # imm = 0xC67178F2E372532B
    2944: 4d 01 c7                     	addq	%r8, %r15
    2947: 4d 01 f7                     	addq	%r14, %r15
    294a: 4c 01 f9                     	addq	%r15, %rcx
    294d: 49 89 f0                     	movq	%rsi, %r8
    2950: 49 c1 c0 24                  	rolq	$0x24, %r8
    2954: 49 89 f6                     	movq	%rsi, %r14
    2957: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    295b: 4d 31 c6                     	xorq	%r8, %r14
    295e: 49 89 f4                     	movq	%rsi, %r12
    2961: 49 c1 c4 19                  	rolq	$0x19, %r12
    2965: 4d 31 f4                     	xorq	%r14, %r12
    2968: 49 89 de                     	movq	%rbx, %r14
    296b: 4d 09 d6                     	orq	%r10, %r14
    296e: 49 21 f6                     	andq	%rsi, %r14
    2971: 49 89 d8                     	movq	%rbx, %r8
    2974: 4d 21 d0                     	andq	%r10, %r8
    2977: 4d 09 f0                     	orq	%r14, %r8
    297a: 4d 01 e0                     	addq	%r12, %r8
    297d: 4d 01 f8                     	addq	%r15, %r8
    2980: 49 89 ce                     	movq	%rcx, %r14
    2983: 49 c1 c6 32                  	rolq	$0x32, %r14
    2987: 49 89 cf                     	movq	%rcx, %r15
    298a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    298e: 4d 31 f7                     	xorq	%r14, %r15
    2991: 49 89 cc                     	movq	%rcx, %r12
    2994: 49 c1 c4 17                  	rolq	$0x17, %r12
    2998: 4d 31 fc                     	xorq	%r15, %r12
    299b: 49 89 d6                     	movq	%rdx, %r14
    299e: 4d 31 de                     	xorq	%r11, %r14
    29a1: 49 21 ce                     	andq	%rcx, %r14
    29a4: 4c 03 8d 58 ff ff ff         	addq	-0xa8(%rbp), %r9
    29ab: 4d 31 de                     	xorq	%r11, %r14
    29ae: 4d 01 f1                     	addq	%r14, %r9
    29b1: 49 be 9c 61 26 ea ce 3e 27 ca	movabsq	$-0x35d8c13115d99e64, %r14 # imm = 0xCA273ECEEA26619C
    29bb: 4d 01 ce                     	addq	%r9, %r14
    29be: 4d 01 e6                     	addq	%r12, %r14
    29c1: 4d 89 c1                     	movq	%r8, %r9
    29c4: 49 c1 c1 24                  	rolq	$0x24, %r9
    29c8: 4d 01 f2                     	addq	%r14, %r10
    29cb: 4d 89 c7                     	movq	%r8, %r15
    29ce: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    29d2: 4d 31 cf                     	xorq	%r9, %r15
    29d5: 4d 89 c4                     	movq	%r8, %r12
    29d8: 49 c1 c4 19                  	rolq	$0x19, %r12
    29dc: 4d 31 fc                     	xorq	%r15, %r12
    29df: 49 89 f7                     	movq	%rsi, %r15
    29e2: 49 09 df                     	orq	%rbx, %r15
    29e5: 4d 21 c7                     	andq	%r8, %r15
    29e8: 49 89 f1                     	movq	%rsi, %r9
    29eb: 49 21 d9                     	andq	%rbx, %r9
    29ee: 4d 09 f9                     	orq	%r15, %r9
    29f1: 4d 01 e1                     	addq	%r12, %r9
    29f4: 4d 01 f1                     	addq	%r14, %r9
    29f7: 4d 89 d6                     	movq	%r10, %r14
    29fa: 49 c1 c6 32                  	rolq	$0x32, %r14
    29fe: 4d 89 d7                     	movq	%r10, %r15
    2a01: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2a05: 4d 31 f7                     	xorq	%r14, %r15
    2a08: 4d 89 d4                     	movq	%r10, %r12
    2a0b: 49 c1 c4 17                  	rolq	$0x17, %r12
    2a0f: 4d 31 fc                     	xorq	%r15, %r12
    2a12: 49 89 ce                     	movq	%rcx, %r14
    2a15: 49 31 d6                     	xorq	%rdx, %r14
    2a18: 4d 21 d6                     	andq	%r10, %r14
    2a1b: 49 31 d6                     	xorq	%rdx, %r14
    2a1e: 4c 03 9d 60 ff ff ff         	addq	-0xa0(%rbp), %r11
    2a25: 4d 01 f3                     	addq	%r14, %r11
    2a28: 49 be 07 c2 c0 21 c7 b8 86 d1	movabsq	$-0x2e794738de3f3df9, %r14 # imm = 0xD186B8C721C0C207
    2a32: 4d 01 de                     	addq	%r11, %r14
    2a35: 4d 89 cb                     	movq	%r9, %r11
    2a38: 49 c1 c3 24                  	rolq	$0x24, %r11
    2a3c: 4d 01 e6                     	addq	%r12, %r14
    2a3f: 4d 89 cf                     	movq	%r9, %r15
    2a42: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2a46: 4c 01 f3                     	addq	%r14, %rbx
    2a49: 4d 89 cc                     	movq	%r9, %r12
    2a4c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2a50: 4d 31 df                     	xorq	%r11, %r15
    2a53: 4d 31 fc                     	xorq	%r15, %r12
    2a56: 4d 89 c7                     	movq	%r8, %r15
    2a59: 49 09 f7                     	orq	%rsi, %r15
    2a5c: 4d 21 cf                     	andq	%r9, %r15
    2a5f: 4d 89 c3                     	movq	%r8, %r11
    2a62: 49 21 f3                     	andq	%rsi, %r11
    2a65: 4d 09 fb                     	orq	%r15, %r11
    2a68: 4d 01 e3                     	addq	%r12, %r11
    2a6b: 49 89 df                     	movq	%rbx, %r15
    2a6e: 49 c1 c7 32                  	rolq	$0x32, %r15
    2a72: 4d 01 f3                     	addq	%r14, %r11
    2a75: 49 89 de                     	movq	%rbx, %r14
    2a78: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2a7c: 4d 31 fe                     	xorq	%r15, %r14
    2a7f: 49 89 df                     	movq	%rbx, %r15
    2a82: 49 c1 c7 17                  	rolq	$0x17, %r15
    2a86: 4d 31 f7                     	xorq	%r14, %r15
    2a89: 4d 89 d6                     	movq	%r10, %r14
    2a8c: 49 31 ce                     	xorq	%rcx, %r14
    2a8f: 49 21 de                     	andq	%rbx, %r14
    2a92: 49 31 ce                     	xorq	%rcx, %r14
    2a95: 48 03 95 68 ff ff ff         	addq	-0x98(%rbp), %rdx
    2a9c: 4c 01 f2                     	addq	%r14, %rdx
    2a9f: 49 be 1e eb e0 cd d6 7d da ea	movabsq	$-0x15258229321f14e2, %r14 # imm = 0xEADA7DD6CDE0EB1E
    2aa9: 49 01 d6                     	addq	%rdx, %r14
    2aac: 4d 01 fe                     	addq	%r15, %r14
    2aaf: 4c 01 f6                     	addq	%r14, %rsi
    2ab2: 4c 89 da                     	movq	%r11, %rdx
    2ab5: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2ab9: 4d 89 df                     	movq	%r11, %r15
    2abc: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2ac0: 49 31 d7                     	xorq	%rdx, %r15
    2ac3: 4d 89 dc                     	movq	%r11, %r12
    2ac6: 49 c1 c4 19                  	rolq	$0x19, %r12
    2aca: 4d 31 fc                     	xorq	%r15, %r12
    2acd: 4d 89 cf                     	movq	%r9, %r15
    2ad0: 4d 09 c7                     	orq	%r8, %r15
    2ad3: 4d 21 df                     	andq	%r11, %r15
    2ad6: 4c 89 ca                     	movq	%r9, %rdx
    2ad9: 4c 21 c2                     	andq	%r8, %rdx
    2adc: 4c 09 fa                     	orq	%r15, %rdx
    2adf: 49 89 f7                     	movq	%rsi, %r15
    2ae2: 49 c1 c7 32                  	rolq	$0x32, %r15
    2ae6: 4c 01 e2                     	addq	%r12, %rdx
    2ae9: 49 89 f4                     	movq	%rsi, %r12
    2aec: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2af0: 4c 01 f2                     	addq	%r14, %rdx
    2af3: 49 89 f6                     	movq	%rsi, %r14
    2af6: 49 c1 c6 17                  	rolq	$0x17, %r14
    2afa: 4d 31 fc                     	xorq	%r15, %r12
    2afd: 4d 31 e6                     	xorq	%r12, %r14
    2b00: 49 89 df                     	movq	%rbx, %r15
    2b03: 4d 31 d7                     	xorq	%r10, %r15
    2b06: 49 21 f7                     	andq	%rsi, %r15
    2b09: 4d 31 d7                     	xorq	%r10, %r15
    2b0c: 48 03 8d 70 ff ff ff         	addq	-0x90(%rbp), %rcx
    2b13: 4c 01 f9                     	addq	%r15, %rcx
    2b16: 49 bf 78 d1 6e ee 7f 4f 7d f5	movabsq	$-0xa82b08011912e88, %r15 # imm = 0xF57D4F7FEE6ED178
    2b20: 49 01 cf                     	addq	%rcx, %r15
    2b23: 4d 01 f7                     	addq	%r14, %r15
    2b26: 4d 01 f8                     	addq	%r15, %r8
    2b29: 48 89 d1                     	movq	%rdx, %rcx
    2b2c: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2b30: 49 89 d6                     	movq	%rdx, %r14
    2b33: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2b37: 49 31 ce                     	xorq	%rcx, %r14
    2b3a: 49 89 d4                     	movq	%rdx, %r12
    2b3d: 49 c1 c4 19                  	rolq	$0x19, %r12
    2b41: 4d 31 f4                     	xorq	%r14, %r12
    2b44: 4d 89 de                     	movq	%r11, %r14
    2b47: 4d 09 ce                     	orq	%r9, %r14
    2b4a: 49 21 d6                     	andq	%rdx, %r14
    2b4d: 4c 89 d9                     	movq	%r11, %rcx
    2b50: 4c 21 c9                     	andq	%r9, %rcx
    2b53: 4c 09 f1                     	orq	%r14, %rcx
    2b56: 4c 01 e1                     	addq	%r12, %rcx
    2b59: 4c 01 f9                     	addq	%r15, %rcx
    2b5c: 4d 89 c6                     	movq	%r8, %r14
    2b5f: 49 c1 c6 32                  	rolq	$0x32, %r14
    2b63: 4d 89 c7                     	movq	%r8, %r15
    2b66: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2b6a: 4d 31 f7                     	xorq	%r14, %r15
    2b6d: 4d 89 c4                     	movq	%r8, %r12
    2b70: 49 c1 c4 17                  	rolq	$0x17, %r12
    2b74: 4d 31 fc                     	xorq	%r15, %r12
    2b77: 49 89 f6                     	movq	%rsi, %r14
    2b7a: 49 31 de                     	xorq	%rbx, %r14
    2b7d: 4d 21 c6                     	andq	%r8, %r14
    2b80: 4c 03 95 78 ff ff ff         	addq	-0x88(%rbp), %r10
    2b87: 49 31 de                     	xorq	%rbx, %r14
    2b8a: 4d 01 f2                     	addq	%r14, %r10
    2b8d: 49 be ba 6f 17 72 aa 67 f0 06	movabsq	$0x6f067aa72176fba, %r14 # imm = 0x6F067AA72176FBA
    2b97: 4d 01 d6                     	addq	%r10, %r14
    2b9a: 4d 01 e6                     	addq	%r12, %r14
    2b9d: 49 89 ca                     	movq	%rcx, %r10
    2ba0: 49 c1 c2 24                  	rolq	$0x24, %r10
    2ba4: 4d 01 f1                     	addq	%r14, %r9
    2ba7: 49 89 cf                     	movq	%rcx, %r15
    2baa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2bae: 4d 31 d7                     	xorq	%r10, %r15
    2bb1: 49 89 cc                     	movq	%rcx, %r12
    2bb4: 49 c1 c4 19                  	rolq	$0x19, %r12
    2bb8: 4d 31 fc                     	xorq	%r15, %r12
    2bbb: 49 89 d7                     	movq	%rdx, %r15
    2bbe: 4d 09 df                     	orq	%r11, %r15
    2bc1: 49 21 cf                     	andq	%rcx, %r15
    2bc4: 49 89 d2                     	movq	%rdx, %r10
    2bc7: 4d 21 da                     	andq	%r11, %r10
    2bca: 4d 09 fa                     	orq	%r15, %r10
    2bcd: 4d 01 e2                     	addq	%r12, %r10
    2bd0: 4d 01 f2                     	addq	%r14, %r10
    2bd3: 4d 89 ce                     	movq	%r9, %r14
    2bd6: 49 c1 c6 32                  	rolq	$0x32, %r14
    2bda: 4d 89 cf                     	movq	%r9, %r15
    2bdd: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2be1: 4d 31 f7                     	xorq	%r14, %r15
    2be4: 4d 89 cc                     	movq	%r9, %r12
    2be7: 49 c1 c4 17                  	rolq	$0x17, %r12
    2beb: 4d 31 fc                     	xorq	%r15, %r12
    2bee: 4d 89 c6                     	movq	%r8, %r14
    2bf1: 49 31 f6                     	xorq	%rsi, %r14
    2bf4: 4d 21 ce                     	andq	%r9, %r14
    2bf7: 49 31 f6                     	xorq	%rsi, %r14
    2bfa: 48 03 5d 80                  	addq	-0x80(%rbp), %rbx
    2bfe: 4c 01 f3                     	addq	%r14, %rbx
    2c01: 49 be a6 98 c8 a2 c5 7d 63 0a	movabsq	$0xa637dc5a2c898a6, %r14 # imm = 0xA637DC5A2C898A6
    2c0b: 49 01 de                     	addq	%rbx, %r14
    2c0e: 4c 89 d3                     	movq	%r10, %rbx
    2c11: 48 c1 c3 24                  	rolq	$0x24, %rbx
    2c15: 4d 01 e6                     	addq	%r12, %r14
    2c18: 4d 89 d7                     	movq	%r10, %r15
    2c1b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2c1f: 4d 01 f3                     	addq	%r14, %r11
    2c22: 4d 89 d4                     	movq	%r10, %r12
    2c25: 49 c1 c4 19                  	rolq	$0x19, %r12
    2c29: 49 31 df                     	xorq	%rbx, %r15
    2c2c: 4d 31 fc                     	xorq	%r15, %r12
    2c2f: 49 89 cf                     	movq	%rcx, %r15
    2c32: 49 09 d7                     	orq	%rdx, %r15
    2c35: 4d 21 d7                     	andq	%r10, %r15
    2c38: 48 89 cb                     	movq	%rcx, %rbx
    2c3b: 48 21 d3                     	andq	%rdx, %rbx
    2c3e: 4c 09 fb                     	orq	%r15, %rbx
    2c41: 4c 01 e3                     	addq	%r12, %rbx
    2c44: 4d 89 df                     	movq	%r11, %r15
    2c47: 49 c1 c7 32                  	rolq	$0x32, %r15
    2c4b: 4c 01 f3                     	addq	%r14, %rbx
    2c4e: 4d 89 de                     	movq	%r11, %r14
    2c51: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2c55: 4d 31 fe                     	xorq	%r15, %r14
    2c58: 4d 89 df                     	movq	%r11, %r15
    2c5b: 49 c1 c7 17                  	rolq	$0x17, %r15
    2c5f: 4d 31 f7                     	xorq	%r14, %r15
    2c62: 4d 89 ce                     	movq	%r9, %r14
    2c65: 4d 31 c6                     	xorq	%r8, %r14
    2c68: 4d 21 de                     	andq	%r11, %r14
    2c6b: 4d 31 c6                     	xorq	%r8, %r14
    2c6e: 48 03 75 88                  	addq	-0x78(%rbp), %rsi
    2c72: 4c 01 f6                     	addq	%r14, %rsi
    2c75: 49 be ae 0d f9 be 04 98 3f 11	movabsq	$0x113f9804bef90dae, %r14 # imm = 0x113F9804BEF90DAE
    2c7f: 49 01 f6                     	addq	%rsi, %r14
    2c82: 4d 01 fe                     	addq	%r15, %r14
    2c85: 4c 01 f2                     	addq	%r14, %rdx
    2c88: 48 89 de                     	movq	%rbx, %rsi
    2c8b: 48 c1 c6 24                  	rolq	$0x24, %rsi
    2c8f: 49 89 df                     	movq	%rbx, %r15
    2c92: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2c96: 49 31 f7                     	xorq	%rsi, %r15
    2c99: 49 89 dc                     	movq	%rbx, %r12
    2c9c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2ca0: 4d 31 fc                     	xorq	%r15, %r12
    2ca3: 4d 89 d7                     	movq	%r10, %r15
    2ca6: 49 09 cf                     	orq	%rcx, %r15
    2ca9: 49 21 df                     	andq	%rbx, %r15
    2cac: 4c 89 d6                     	movq	%r10, %rsi
    2caf: 48 21 ce                     	andq	%rcx, %rsi
    2cb2: 4c 09 fe                     	orq	%r15, %rsi
    2cb5: 49 89 d7                     	movq	%rdx, %r15
    2cb8: 49 c1 c7 32                  	rolq	$0x32, %r15
    2cbc: 4c 01 e6                     	addq	%r12, %rsi
    2cbf: 49 89 d4                     	movq	%rdx, %r12
    2cc2: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2cc6: 4c 01 f6                     	addq	%r14, %rsi
    2cc9: 49 89 d6                     	movq	%rdx, %r14
    2ccc: 49 c1 c6 17                  	rolq	$0x17, %r14
    2cd0: 4d 31 fc                     	xorq	%r15, %r12
    2cd3: 4d 31 e6                     	xorq	%r12, %r14
    2cd6: 4d 89 df                     	movq	%r11, %r15
    2cd9: 4d 31 cf                     	xorq	%r9, %r15
    2cdc: 49 21 d7                     	andq	%rdx, %r15
    2cdf: 4d 31 cf                     	xorq	%r9, %r15
    2ce2: 4c 03 45 90                  	addq	-0x70(%rbp), %r8
    2ce6: 4d 01 f8                     	addq	%r15, %r8
    2ce9: 49 bf 1b 47 1c 13 35 0b 71 1b	movabsq	$0x1b710b35131c471b, %r15 # imm = 0x1B710B35131C471B
    2cf3: 4d 01 c7                     	addq	%r8, %r15
    2cf6: 4d 01 f7                     	addq	%r14, %r15
    2cf9: 4c 01 f9                     	addq	%r15, %rcx
    2cfc: 49 89 f0                     	movq	%rsi, %r8
    2cff: 49 c1 c0 24                  	rolq	$0x24, %r8
    2d03: 49 89 f6                     	movq	%rsi, %r14
    2d06: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2d0a: 4d 31 c6                     	xorq	%r8, %r14
    2d0d: 49 89 f4                     	movq	%rsi, %r12
    2d10: 49 c1 c4 19                  	rolq	$0x19, %r12
    2d14: 4d 31 f4                     	xorq	%r14, %r12
    2d17: 49 89 de                     	movq	%rbx, %r14
    2d1a: 4d 09 d6                     	orq	%r10, %r14
    2d1d: 49 21 f6                     	andq	%rsi, %r14
    2d20: 49 89 d8                     	movq	%rbx, %r8
    2d23: 4d 21 d0                     	andq	%r10, %r8
    2d26: 4d 09 f0                     	orq	%r14, %r8
    2d29: 4d 01 e0                     	addq	%r12, %r8
    2d2c: 4d 01 f8                     	addq	%r15, %r8
    2d2f: 49 89 ce                     	movq	%rcx, %r14
    2d32: 49 c1 c6 32                  	rolq	$0x32, %r14
    2d36: 49 89 cf                     	movq	%rcx, %r15
    2d39: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2d3d: 4d 31 f7                     	xorq	%r14, %r15
    2d40: 49 89 cc                     	movq	%rcx, %r12
    2d43: 49 c1 c4 17                  	rolq	$0x17, %r12
    2d47: 4d 31 fc                     	xorq	%r15, %r12
    2d4a: 49 89 d6                     	movq	%rdx, %r14
    2d4d: 4d 31 de                     	xorq	%r11, %r14
    2d50: 49 21 ce                     	andq	%rcx, %r14
    2d53: 4c 03 4d 98                  	addq	-0x68(%rbp), %r9
    2d57: 4d 31 de                     	xorq	%r11, %r14
    2d5a: 4d 01 f1                     	addq	%r14, %r9
    2d5d: 49 be 84 7d 04 23 f5 77 db 28	movabsq	$0x28db77f523047d84, %r14 # imm = 0x28DB77F523047D84
    2d67: 4d 01 ce                     	addq	%r9, %r14
    2d6a: 4d 01 e6                     	addq	%r12, %r14
    2d6d: 4d 89 c1                     	movq	%r8, %r9
    2d70: 49 c1 c1 24                  	rolq	$0x24, %r9
    2d74: 4d 01 f2                     	addq	%r14, %r10
    2d77: 4d 89 c7                     	movq	%r8, %r15
    2d7a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2d7e: 4d 31 cf                     	xorq	%r9, %r15
    2d81: 4d 89 c4                     	movq	%r8, %r12
    2d84: 49 c1 c4 19                  	rolq	$0x19, %r12
    2d88: 4d 31 fc                     	xorq	%r15, %r12
    2d8b: 49 89 f7                     	movq	%rsi, %r15
    2d8e: 49 09 df                     	orq	%rbx, %r15
    2d91: 4d 21 c7                     	andq	%r8, %r15
    2d94: 49 89 f1                     	movq	%rsi, %r9
    2d97: 49 21 d9                     	andq	%rbx, %r9
    2d9a: 4d 09 f9                     	orq	%r15, %r9
    2d9d: 4d 01 e1                     	addq	%r12, %r9
    2da0: 4d 01 f1                     	addq	%r14, %r9
    2da3: 4d 89 d6                     	movq	%r10, %r14
    2da6: 49 c1 c6 32                  	rolq	$0x32, %r14
    2daa: 4d 89 d7                     	movq	%r10, %r15
    2dad: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2db1: 4d 31 f7                     	xorq	%r14, %r15
    2db4: 4d 89 d4                     	movq	%r10, %r12
    2db7: 49 c1 c4 17                  	rolq	$0x17, %r12
    2dbb: 4d 31 fc                     	xorq	%r15, %r12
    2dbe: 49 89 ce                     	movq	%rcx, %r14
    2dc1: 49 31 d6                     	xorq	%rdx, %r14
    2dc4: 4d 21 d6                     	andq	%r10, %r14
    2dc7: 49 31 d6                     	xorq	%rdx, %r14
    2dca: 4c 03 5d a0                  	addq	-0x60(%rbp), %r11
    2dce: 4d 01 f3                     	addq	%r14, %r11
    2dd1: 49 be 93 24 c7 40 7b ab ca 32	movabsq	$0x32caab7b40c72493, %r14 # imm = 0x32CAAB7B40C72493
    2ddb: 4d 01 de                     	addq	%r11, %r14
    2dde: 4d 89 cb                     	movq	%r9, %r11
    2de1: 49 c1 c3 24                  	rolq	$0x24, %r11
    2de5: 4d 01 e6                     	addq	%r12, %r14
    2de8: 4d 89 cf                     	movq	%r9, %r15
    2deb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2def: 4c 01 f3                     	addq	%r14, %rbx
    2df2: 4d 89 cc                     	movq	%r9, %r12
    2df5: 49 c1 c4 19                  	rolq	$0x19, %r12
    2df9: 4d 31 df                     	xorq	%r11, %r15
    2dfc: 4d 31 fc                     	xorq	%r15, %r12
    2dff: 4d 89 c7                     	movq	%r8, %r15
    2e02: 49 09 f7                     	orq	%rsi, %r15
    2e05: 4d 21 cf                     	andq	%r9, %r15
    2e08: 4d 89 c3                     	movq	%r8, %r11
    2e0b: 49 21 f3                     	andq	%rsi, %r11
    2e0e: 4d 09 fb                     	orq	%r15, %r11
    2e11: 4d 01 e3                     	addq	%r12, %r11
    2e14: 49 89 df                     	movq	%rbx, %r15
    2e17: 49 c1 c7 32                  	rolq	$0x32, %r15
    2e1b: 4d 01 f3                     	addq	%r14, %r11
    2e1e: 49 89 de                     	movq	%rbx, %r14
    2e21: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2e25: 4d 31 fe                     	xorq	%r15, %r14
    2e28: 49 89 df                     	movq	%rbx, %r15
    2e2b: 49 c1 c7 17                  	rolq	$0x17, %r15
    2e2f: 4d 31 f7                     	xorq	%r14, %r15
    2e32: 4d 89 d6                     	movq	%r10, %r14
    2e35: 49 31 ce                     	xorq	%rcx, %r14
    2e38: 49 21 de                     	andq	%rbx, %r14
    2e3b: 49 31 ce                     	xorq	%rcx, %r14
    2e3e: 48 03 55 a8                  	addq	-0x58(%rbp), %rdx
    2e42: 4c 01 f2                     	addq	%r14, %rdx
    2e45: 49 be bc be c9 15 0a be 9e 3c	movabsq	$0x3c9ebe0a15c9bebc, %r14 # imm = 0x3C9EBE0A15C9BEBC
    2e4f: 49 01 d6                     	addq	%rdx, %r14
    2e52: 4d 01 fe                     	addq	%r15, %r14
    2e55: 4c 01 f6                     	addq	%r14, %rsi
    2e58: 4c 89 da                     	movq	%r11, %rdx
    2e5b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2e5f: 4d 89 df                     	movq	%r11, %r15
    2e62: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2e66: 49 31 d7                     	xorq	%rdx, %r15
    2e69: 4d 89 dc                     	movq	%r11, %r12
    2e6c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2e70: 4d 31 fc                     	xorq	%r15, %r12
    2e73: 4d 89 cf                     	movq	%r9, %r15
    2e76: 4d 09 c7                     	orq	%r8, %r15
    2e79: 4d 21 df                     	andq	%r11, %r15
    2e7c: 4c 89 ca                     	movq	%r9, %rdx
    2e7f: 4c 21 c2                     	andq	%r8, %rdx
    2e82: 4c 09 fa                     	orq	%r15, %rdx
    2e85: 49 89 f7                     	movq	%rsi, %r15
    2e88: 49 c1 c7 32                  	rolq	$0x32, %r15
    2e8c: 4c 01 e2                     	addq	%r12, %rdx
    2e8f: 49 89 f4                     	movq	%rsi, %r12
    2e92: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2e96: 4c 01 f2                     	addq	%r14, %rdx
    2e99: 49 89 f6                     	movq	%rsi, %r14
    2e9c: 49 c1 c6 17                  	rolq	$0x17, %r14
    2ea0: 4d 31 fc                     	xorq	%r15, %r12
    2ea3: 4d 31 e6                     	xorq	%r12, %r14
    2ea6: 49 89 df                     	movq	%rbx, %r15
    2ea9: 4d 31 d7                     	xorq	%r10, %r15
    2eac: 49 21 f7                     	andq	%rsi, %r15
    2eaf: 4d 31 d7                     	xorq	%r10, %r15
    2eb2: 48 03 4d b0                  	addq	-0x50(%rbp), %rcx
    2eb6: 4c 01 f9                     	addq	%r15, %rcx
    2eb9: 49 bf 4c 0d 10 9c c4 67 1d 43	movabsq	$0x431d67c49c100d4c, %r15 # imm = 0x431D67C49C100D4C
    2ec3: 49 01 cf                     	addq	%rcx, %r15
    2ec6: 4d 01 f7                     	addq	%r14, %r15
    2ec9: 4d 01 f8                     	addq	%r15, %r8
    2ecc: 48 89 d1                     	movq	%rdx, %rcx
    2ecf: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2ed3: 49 89 d6                     	movq	%rdx, %r14
    2ed6: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2eda: 49 31 ce                     	xorq	%rcx, %r14
    2edd: 49 89 d4                     	movq	%rdx, %r12
    2ee0: 49 c1 c4 19                  	rolq	$0x19, %r12
    2ee4: 4d 31 f4                     	xorq	%r14, %r12
    2ee7: 4d 89 de                     	movq	%r11, %r14
    2eea: 4d 09 ce                     	orq	%r9, %r14
    2eed: 49 21 d6                     	andq	%rdx, %r14
    2ef0: 4c 89 d9                     	movq	%r11, %rcx
    2ef3: 4c 21 c9                     	andq	%r9, %rcx
    2ef6: 4c 09 f1                     	orq	%r14, %rcx
    2ef9: 4c 01 e1                     	addq	%r12, %rcx
    2efc: 4c 01 f9                     	addq	%r15, %rcx
    2eff: 4d 89 c6                     	movq	%r8, %r14
    2f02: 49 c1 c6 32                  	rolq	$0x32, %r14
    2f06: 4d 89 c7                     	movq	%r8, %r15
    2f09: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2f0d: 4d 31 f7                     	xorq	%r14, %r15
    2f10: 4d 89 c4                     	movq	%r8, %r12
    2f13: 49 c1 c4 17                  	rolq	$0x17, %r12
    2f17: 4d 31 fc                     	xorq	%r15, %r12
    2f1a: 49 89 f6                     	movq	%rsi, %r14
    2f1d: 49 31 de                     	xorq	%rbx, %r14
    2f20: 4d 21 c6                     	andq	%r8, %r14
    2f23: 4c 03 55 b8                  	addq	-0x48(%rbp), %r10
    2f27: 49 31 de                     	xorq	%rbx, %r14
    2f2a: 4d 01 f2                     	addq	%r14, %r10
    2f2d: 49 be b6 42 3e cb be d4 c5 4c	movabsq	$0x4cc5d4becb3e42b6, %r14 # imm = 0x4CC5D4BECB3E42B6
    2f37: 4d 01 d6                     	addq	%r10, %r14
    2f3a: 4d 01 e6                     	addq	%r12, %r14
    2f3d: 49 89 ca                     	movq	%rcx, %r10
    2f40: 49 c1 c2 24                  	rolq	$0x24, %r10
    2f44: 4d 01 f1                     	addq	%r14, %r9
    2f47: 49 89 cf                     	movq	%rcx, %r15
    2f4a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2f4e: 4d 31 d7                     	xorq	%r10, %r15
    2f51: 49 89 cc                     	movq	%rcx, %r12
    2f54: 49 c1 c4 19                  	rolq	$0x19, %r12
    2f58: 4d 31 fc                     	xorq	%r15, %r12
    2f5b: 49 89 d7                     	movq	%rdx, %r15
    2f5e: 4d 09 df                     	orq	%r11, %r15
    2f61: 49 21 cf                     	andq	%rcx, %r15
    2f64: 49 89 d2                     	movq	%rdx, %r10
    2f67: 4d 21 da                     	andq	%r11, %r10
    2f6a: 4d 09 fa                     	orq	%r15, %r10
    2f6d: 4d 01 e2                     	addq	%r12, %r10
    2f70: 4d 01 f2                     	addq	%r14, %r10
    2f73: 4d 89 ce                     	movq	%r9, %r14
    2f76: 49 c1 c6 32                  	rolq	$0x32, %r14
    2f7a: 4d 89 cf                     	movq	%r9, %r15
    2f7d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2f81: 4d 31 f7                     	xorq	%r14, %r15
    2f84: 4d 89 cc                     	movq	%r9, %r12
    2f87: 49 c1 c4 17                  	rolq	$0x17, %r12
    2f8b: 4d 31 fc                     	xorq	%r15, %r12
    2f8e: 4d 89 c6                     	movq	%r8, %r14
    2f91: 49 31 f6                     	xorq	%rsi, %r14
    2f94: 4d 21 ce                     	andq	%r9, %r14
    2f97: 49 31 f6                     	xorq	%rsi, %r14
    2f9a: 48 03 5d c0                  	addq	-0x40(%rbp), %rbx
    2f9e: 4c 01 f3                     	addq	%r14, %rbx
    2fa1: 49 be 2a 7e 65 fc 9c 29 7f 59	movabsq	$0x597f299cfc657e2a, %r14 # imm = 0x597F299CFC657E2A
    2fab: 49 01 de                     	addq	%rbx, %r14
    2fae: 4c 89 d3                     	movq	%r10, %rbx
    2fb1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    2fb5: 4d 01 e6                     	addq	%r12, %r14
    2fb8: 4d 89 d7                     	movq	%r10, %r15
    2fbb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2fbf: 4d 01 f3                     	addq	%r14, %r11
    2fc2: 4d 89 d4                     	movq	%r10, %r12
    2fc5: 49 c1 c4 19                  	rolq	$0x19, %r12
    2fc9: 49 31 df                     	xorq	%rbx, %r15
    2fcc: 4d 31 fc                     	xorq	%r15, %r12
    2fcf: 49 89 cf                     	movq	%rcx, %r15
    2fd2: 49 09 d7                     	orq	%rdx, %r15
    2fd5: 4d 21 d7                     	andq	%r10, %r15
    2fd8: 48 89 cb                     	movq	%rcx, %rbx
    2fdb: 48 21 d3                     	andq	%rdx, %rbx
    2fde: 4c 09 fb                     	orq	%r15, %rbx
    2fe1: 4c 01 e3                     	addq	%r12, %rbx
    2fe4: 4d 89 df                     	movq	%r11, %r15
    2fe7: 49 c1 c7 32                  	rolq	$0x32, %r15
    2feb: 4c 01 f3                     	addq	%r14, %rbx
    2fee: 4d 89 de                     	movq	%r11, %r14
    2ff1: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2ff5: 4d 31 fe                     	xorq	%r15, %r14
    2ff8: 4d 89 df                     	movq	%r11, %r15
    2ffb: 49 c1 c7 17                  	rolq	$0x17, %r15
    2fff: 4d 31 f7                     	xorq	%r14, %r15
    3002: 4d 89 ce                     	movq	%r9, %r14
    3005: 4d 31 c6                     	xorq	%r8, %r14
    3008: 4d 21 de                     	andq	%r11, %r14
    300b: 4d 31 c6                     	xorq	%r8, %r14
    300e: 48 03 75 c8                  	addq	-0x38(%rbp), %rsi
    3012: 4c 01 f6                     	addq	%r14, %rsi
    3015: 49 be ec fa d6 3a ab 6f cb 5f	movabsq	$0x5fcb6fab3ad6faec, %r14 # imm = 0x5FCB6FAB3AD6FAEC
    301f: 49 01 f6                     	addq	%rsi, %r14
    3022: 4d 01 fe                     	addq	%r15, %r14
    3025: 4c 01 f2                     	addq	%r14, %rdx
    3028: 48 89 de                     	movq	%rbx, %rsi
    302b: 48 c1 c6 24                  	rolq	$0x24, %rsi
    302f: 49 89 df                     	movq	%rbx, %r15
    3032: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3036: 49 31 f7                     	xorq	%rsi, %r15
    3039: 49 89 dc                     	movq	%rbx, %r12
    303c: 49 c1 c4 19                  	rolq	$0x19, %r12
    3040: 4d 31 fc                     	xorq	%r15, %r12
    3043: 4d 89 d7                     	movq	%r10, %r15
    3046: 49 09 cf                     	orq	%rcx, %r15
    3049: 49 21 df                     	andq	%rbx, %r15
    304c: 4c 89 d6                     	movq	%r10, %rsi
    304f: 48 21 ce                     	andq	%rcx, %rsi
    3052: 4c 09 fe                     	orq	%r15, %rsi
    3055: 49 89 d7                     	movq	%rdx, %r15
    3058: 49 c1 c7 32                  	rolq	$0x32, %r15
    305c: 4c 01 e6                     	addq	%r12, %rsi
    305f: 49 89 d4                     	movq	%rdx, %r12
    3062: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3066: 4c 01 f6                     	addq	%r14, %rsi
    3069: 49 89 d5                     	movq	%rdx, %r13
    306c: 49 c1 c5 17                  	rolq	$0x17, %r13
    3070: 4d 31 fc                     	xorq	%r15, %r12
    3073: 4d 31 e5                     	xorq	%r12, %r13
    3076: 4d 89 de                     	movq	%r11, %r14
    3079: 4d 31 ce                     	xorq	%r9, %r14
    307c: 49 21 d6                     	andq	%rdx, %r14
    307f: 4d 31 ce                     	xorq	%r9, %r14
    3082: 4c 03 45 d0                  	addq	-0x30(%rbp), %r8
    3086: 4d 01 f0                     	addq	%r14, %r8
    3089: 49 be 17 58 47 4a 8c 19 44 6c	movabsq	$0x6c44198c4a475817, %r14 # imm = 0x6C44198C4A475817
    3093: 4d 01 c6                     	addq	%r8, %r14
    3096: 4d 01 ee                     	addq	%r13, %r14
    3099: 49 89 f0                     	movq	%rsi, %r8
    309c: 49 c1 c0 24                  	rolq	$0x24, %r8
    30a0: 49 89 f7                     	movq	%rsi, %r15
    30a3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    30a7: 4d 31 c7                     	xorq	%r8, %r15
    30aa: 49 89 f0                     	movq	%rsi, %r8
    30ad: 49 c1 c0 19                  	rolq	$0x19, %r8
    30b1: 4d 31 f8                     	xorq	%r15, %r8
    30b4: 49 89 df                     	movq	%rbx, %r15
    30b7: 4d 09 d7                     	orq	%r10, %r15
    30ba: 49 21 f7                     	andq	%rsi, %r15
    30bd: 49 89 dc                     	movq	%rbx, %r12
    30c0: 4d 21 d4                     	andq	%r10, %r12
    30c3: 4d 09 fc                     	orq	%r15, %r12
    30c6: 4d 01 c4                     	addq	%r8, %r12
    30c9: 4d 01 f4                     	addq	%r14, %r12
    30cc: 49 01 c4                     	addq	%rax, %r12
    30cf: 4c 89 67 10                  	movq	%r12, 0x10(%rdi)
    30d3: 48 01 77 18                  	addq	%rsi, 0x18(%rdi)
    30d7: 48 01 5f 20                  	addq	%rbx, 0x20(%rdi)
    30db: 4c 01 57 28                  	addq	%r10, 0x28(%rdi)
    30df: 4c 01 f1                     	addq	%r14, %rcx
    30e2: 48 01 4f 30                  	addq	%rcx, 0x30(%rdi)
    30e6: 48 01 57 38                  	addq	%rdx, 0x38(%rdi)
    30ea: 4c 01 5f 40                  	addq	%r11, 0x40(%rdi)
    30ee: 4c 01 4f 48                  	addq	%r9, 0x48(%rdi)
    30f2: 48 81 c4 00 02 00 00         	addq	$0x200, %rsp            # imm = 0x200
    30f9: 5b                           	popq	%rbx
    30fa: 41 5c                        	popq	%r12
    30fc: 41 5d                        	popq	%r13
    30fe: 41 5e                        	popq	%r14
    3100: 41 5f                        	popq	%r15
    3102: 5d                           	popq	%rbp
    3103: c3                           	retq
    3104: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    310e: 66 90                        	nop

0000000000003110 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    3110: 55                           	pushq	%rbp
    3111: 48 89 e5                     	movq	%rsp, %rbp
    3114: 41 57                        	pushq	%r15
    3116: 41 56                        	pushq	%r14
    3118: 53                           	pushq	%rbx
    3119: 50                           	pushq	%rax
    311a: 48 89 f3                     	movq	%rsi, %rbx
    311d: 49 89 fe                     	movq	%rdi, %r14
    3120: 4c 8d 7f 50                  	leaq	0x50(%rdi), %r15
    3124: 0f b6 87 d0 00 00 00         	movzbl	0xd0(%rdi), %eax
    312b: 48 01 c7                     	addq	%rax, %rdi
    312e: 48 83 c7 50                  	addq	$0x50, %rdi
    3132: ba 80 00 00 00               	movl	$0x80, %edx
    3137: 48 29 c2                     	subq	%rax, %rdx
    313a: 31 f6                        	xorl	%esi, %esi
    313c: e8 00 00 00 00               	callq	 <L0>
		000000000000313d:  R_X86_64_PLT32	memset-0x4
<L0>:
    3141: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    3149: 41 c6 44 06 50 80            	movb	$-0x80, 0x50(%r14,%rax)
    314f: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    3157: 8d 48 01                     	leal	0x1(%rax), %ecx
    315a: 41 88 8e d0 00 00 00         	movb	%cl, 0xd0(%r14)
    3161: 3c 6f                        	cmpb	$0x6f, %al
    3163: 76 30                        	jbe	 <L1>
    3165: 4c 89 f7                     	movq	%r14, %rdi
    3168: 4c 89 fe                     	movq	%r15, %rsi
    316b: e8 d0 d8 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3170: 0f 57 c0                     	xorps	%xmm0, %xmm0
    3173: 41 0f 29 47 60               	movaps	%xmm0, 0x60(%r15)
    3178: 41 0f 29 47 50               	movaps	%xmm0, 0x50(%r15)
    317d: 41 0f 29 47 40               	movaps	%xmm0, 0x40(%r15)
    3182: 41 0f 29 47 30               	movaps	%xmm0, 0x30(%r15)
    3187: 41 0f 29 47 20               	movaps	%xmm0, 0x20(%r15)
    318c: 41 0f 29 47 10               	movaps	%xmm0, 0x10(%r15)
    3191: 41 0f 29 07                  	movaps	%xmm0, (%r15)
<L1>:
    3195: 49 8b 06                     	movq	(%r14), %rax
    3198: 49 8b 4e 08                  	movq	0x8(%r14), %rcx
    319c: 89 c2                        	movl	%eax, %edx
    319e: c1 ea 05                     	shrl	$0x5, %edx
    31a1: 8d 34 c5 00 00 00 00         	leal	(,%rax,8), %esi
    31a8: 41 88 b6 cf 00 00 00         	movb	%sil, 0xcf(%r14)
    31af: 41 88 96 ce 00 00 00         	movb	%dl, 0xce(%r14)
    31b6: 89 c2                        	movl	%eax, %edx
    31b8: c1 ea 0d                     	shrl	$0xd, %edx
    31bb: 41 88 96 cd 00 00 00         	movb	%dl, 0xcd(%r14)
    31c2: 89 c2                        	movl	%eax, %edx
    31c4: c1 ea 15                     	shrl	$0x15, %edx
    31c7: 48 89 ce                     	movq	%rcx, %rsi
    31ca: 48 0f a4 c6 1b               	shldq	$0x1b, %rax, %rsi
    31cf: 41 88 96 cc 00 00 00         	movb	%dl, 0xcc(%r14)
    31d6: 49 89 c8                     	movq	%rcx, %r8
    31d9: 49 0f a4 c0 23               	shldq	$0x23, %rax, %r8
    31de: 48 89 ca                     	movq	%rcx, %rdx
    31e1: 49 89 c9                     	movq	%rcx, %r9
    31e4: 49 0f a4 c1 0b               	shldq	$0xb, %rax, %r9
    31e9: 48 89 cf                     	movq	%rcx, %rdi
    31ec: 49 89 ca                     	movq	%rcx, %r10
    31ef: 49 0f a4 c2 13               	shldq	$0x13, %rax, %r10
    31f4: 48 0f ac c8 3d               	shrdq	$0x3d, %rcx, %rax
    31f9: 66 48 0f 6e c9               	movq	%rcx, %xmm1
    31fe: 48 c1 e9 25                  	shrq	$0x25, %rcx
    3202: 48 c1 ea 35                  	shrq	$0x35, %rdx
    3206: 48 c1 ef 2d                  	shrq	$0x2d, %rdi
    320a: 66 49 0f 6e c2               	movq	%r10, %xmm0
    320f: 66 49 0f 6e d1               	movq	%r9, %xmm2
    3214: 66 0f 60 d0                  	punpcklbw	%xmm0, %xmm2    # xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
    3218: 66 0f 6f 05 00 00 00 00      	movdqa	, %xmm0 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final+0x110>
		000000000000321c:  R_X86_64_PC32	.LCPI3_0-0x4
    3220: 66 0f db d0                  	pand	%xmm0, %xmm2
    3224: 66 49 0f 6e d8               	movq	%r8, %xmm3
    3229: 66 48 0f 6e e6               	movq	%rsi, %xmm4
    322e: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    # xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    3232: 66 0f 72 f4 10               	pslld	$0x10, %xmm4
    3237: 66 0f 6f d8                  	movdqa	%xmm0, %xmm3
    323b: 66 0f df dc                  	pandn	%xmm4, %xmm3
    323f: 66 0f eb da                  	por	%xmm2, %xmm3
    3243: 66 41 0f 7e 9e c8 00 00 00   	movd	%xmm3, 0xc8(%r14)
    324c: 66 0f 6e d7                  	movd	%edi, %xmm2
    3250: 66 0f 6e da                  	movd	%edx, %xmm3
    3254: 66 0f 60 da                  	punpcklbw	%xmm2, %xmm3    # xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
    3258: 66 0f db d8                  	pand	%xmm0, %xmm3
    325c: 66 0f 6f d1                  	movdqa	%xmm1, %xmm2
    3260: 66 0f 73 d2 1d               	psrlq	$0x1d, %xmm2
    3265: 66 0f 6e e1                  	movd	%ecx, %xmm4
    3269: 66 0f 60 e2                  	punpcklbw	%xmm2, %xmm4    # xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1],xmm4[2],xmm2[2],xmm4[3],xmm2[3],xmm4[4],xmm2[4],xmm4[5],xmm2[5],xmm4[6],xmm2[6],xmm4[7],xmm2[7]
    326d: 66 0f 72 f4 10               	pslld	$0x10, %xmm4
    3272: 66 0f df c4                  	pandn	%xmm4, %xmm0
    3276: 66 0f eb c3                  	por	%xmm3, %xmm0
    327a: 66 48 0f 6e d0               	movq	%rax, %xmm2
    327f: 66 0f 6f d9                  	movdqa	%xmm1, %xmm3
    3283: 66 0f 73 d3 05               	psrlq	$0x5, %xmm3
    3288: 66 0f 60 da                  	punpcklbw	%xmm2, %xmm3    # xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
    328c: 66 0f 73 f3 30               	psllq	$0x30, %xmm3
    3291: 66 0f 6f 15 00 00 00 00      	movdqa	, %xmm2 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final+0x189>
		0000000000003295:  R_X86_64_PC32	.LCPI3_1-0x4
    3299: 66 0f 6f e1                  	movdqa	%xmm1, %xmm4
    329d: 66 0f 73 d4 0d               	psrlq	$0xd, %xmm4
    32a2: 66 0f 73 d1 15               	psrlq	$0x15, %xmm1
    32a7: 66 0f 60 cc                  	punpcklbw	%xmm4, %xmm1    # xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1],xmm1[2],xmm4[2],xmm1[3],xmm4[3],xmm1[4],xmm4[4],xmm1[5],xmm4[5],xmm1[6],xmm4[6],xmm1[7],xmm4[7]
    32ab: 66 0f 70 c9 50               	pshufd	$0x50, %xmm1, %xmm1     # xmm1 = xmm1[0,0,1,1]
    32b0: 66 0f db ca                  	pand	%xmm2, %xmm1
    32b4: 66 0f df d3                  	pandn	%xmm3, %xmm2
    32b8: 66 0f eb d1                  	por	%xmm1, %xmm2
    32bc: 66 0f 70 ca 55               	pshufd	$0x55, %xmm2, %xmm1     # xmm1 = xmm2[1,1,1,1]
    32c1: 66 0f 62 c1                  	punpckldq	%xmm1, %xmm0    # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
    32c5: 66 41 0f d6 86 c0 00 00 00   	movq	%xmm0, 0xc0(%r14)
    32ce: 4c 89 f7                     	movq	%r14, %rdi
    32d1: 4c 89 fe                     	movq	%r15, %rsi
    32d4: e8 67 d7 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    32d9: 49 8b 46 10                  	movq	0x10(%r14), %rax
    32dd: 48 0f c8                     	bswapq	%rax
    32e0: 48 89 03                     	movq	%rax, (%rbx)
    32e3: 49 8b 46 18                  	movq	0x18(%r14), %rax
    32e7: 48 0f c8                     	bswapq	%rax
    32ea: 48 89 43 08                  	movq	%rax, 0x8(%rbx)
    32ee: 49 8b 46 20                  	movq	0x20(%r14), %rax
    32f2: 48 0f c8                     	bswapq	%rax
    32f5: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    32f9: 49 8b 46 28                  	movq	0x28(%r14), %rax
    32fd: 48 0f c8                     	bswapq	%rax
    3300: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    3304: 49 8b 46 30                  	movq	0x30(%r14), %rax
    3308: 48 0f c8                     	bswapq	%rax
    330b: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    330f: 49 8b 46 38                  	movq	0x38(%r14), %rax
    3313: 48 0f c8                     	bswapq	%rax
    3316: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    331a: 48 83 c4 08                  	addq	$0x8, %rsp
    331e: 5b                           	popq	%rbx
    331f: 41 5e                        	popq	%r14
    3321: 41 5f                        	popq	%r15
    3323: 5d                           	popq	%rbp
    3324: c3                           	retq
    3325: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    332f: 90                           	nop

0000000000003330 <audit_master384>:
    3330: 55                           	pushq	%rbp
    3331: 48 89 e5                     	movq	%rsp, %rbp
    3334: 41 56                        	pushq	%r14
    3336: 53                           	pushq	%rbx
    3337: 48 81 ec 70 01 00 00         	subq	$0x170, %rsp            # imm = 0x170
    333e: 48 89 f3                     	movq	%rsi, %rbx
    3341: 49 89 f8                     	movq	%rdi, %r8
    3344: 66 c7 85 80 fe ff ff 00 30   	movw	$0x3000, -0x180(%rbp)   # imm = 0x3000
    334d: c6 85 82 fe ff ff 0d         	movb	$0xd, -0x17e(%rbp)
    3354: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    335e: 48 89 85 83 fe ff ff         	movq	%rax, -0x17d(%rbp)
    3365: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    336f: 48 89 85 88 fe ff ff         	movq	%rax, -0x178(%rbp)
    3376: c6 85 90 fe ff ff 30         	movb	$0x30, -0x170(%rbp)
    337d: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x54>
		0000000000003380:  R_X86_64_PC32	.rodata+0x129
    3384: 0f 11 85 91 fe ff ff         	movups	%xmm0, -0x16f(%rbp)
    338b: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x62>
		000000000000338e:  R_X86_64_PC32	.rodata+0x139
    3392: 0f 11 85 a1 fe ff ff         	movups	%xmm0, -0x15f(%rbp)
    3399: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x70>
		000000000000339c:  R_X86_64_PC32	.rodata+0x149
    33a0: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    33a7: 4c 8d 75 c0                  	leaq	-0x40(%rbp), %r14
    33ab: 48 8d 95 80 fe ff ff         	leaq	-0x180(%rbp), %rdx
    33b2: be 30 00 00 00               	movl	$0x30, %esi
    33b7: b9 41 00 00 00               	movl	$0x41, %ecx
    33bc: 4c 89 f7                     	movq	%r14, %rdi
    33bf: e8 bc cc ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    33c4: 48 8d 7d 90                  	leaq	-0x70(%rbp), %rdi
    33c8: ba 00 00 00 00               	movl	$0x0, %edx
		00000000000033c9:  R_X86_64_32	.rodata+0xfd
    33cd: 4c 89 f6                     	movq	%r14, %rsi
    33d0: e8 3b 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    33d5: 0f 57 c0                     	xorps	%xmm0, %xmm0
    33d8: 0f 29 45 e0                  	movaps	%xmm0, -0x20(%rbp)
    33dc: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    33e0: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    33e4: 0f 10 45 90                  	movups	-0x70(%rbp), %xmm0
    33e8: 0f 10 4d a0                  	movups	-0x60(%rbp), %xmm1
    33ec: 0f 10 55 b0                  	movups	-0x50(%rbp), %xmm2
    33f0: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    33f4: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    33f8: 0f 11 03                     	movups	%xmm0, (%rbx)
    33fb: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            # imm = 0x170
    3402: 5b                           	popq	%rbx
    3403: 41 5e                        	popq	%r14
    3405: 5d                           	popq	%rbp
    3406: c3                           	retq
    3407: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)

0000000000003410 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    3410: 55                           	pushq	%rbp
    3411: 48 89 e5                     	movq	%rsp, %rbp
    3414: 41 57                        	pushq	%r15
    3416: 41 56                        	pushq	%r14
    3418: 41 55                        	pushq	%r13
    341a: 41 54                        	pushq	%r12
    341c: 53                           	pushq	%rbx
    341d: 48 81 ec f8 02 00 00         	subq	$0x2f8, %rsp            # imm = 0x2F8
    3424: 49 89 d6                     	movq	%rdx, %r14
    3427: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    342b: 0f 10 06                     	movups	(%rsi), %xmm0
    342e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    3432: 0f 10 56 20                  	movups	0x20(%rsi), %xmm2
    3436: 0f 29 95 70 ff ff ff         	movaps	%xmm2, -0x90(%rbp)
    343d: 0f 29 8d 60 ff ff ff         	movaps	%xmm1, -0xa0(%rbp)
    3444: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    344b: 0f 57 c0                     	xorps	%xmm0, %xmm0
    344e: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3452: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    3456: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
    345a: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    345e: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    3462: 31 c0                        	xorl	%eax, %eax
    3464: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    346e: 66 90                        	nop
<L0>:
    3470: 0f b6 8c 05 50 ff ff ff      	movzbl	-0xb0(%rbp,%rax), %ecx
    3478: 0f b6 94 05 51 ff ff ff      	movzbl	-0xaf(%rbp,%rax), %edx
    3480: 80 f1 5c                     	xorb	$0x5c, %cl
    3483: 88 8c 05 c0 fd ff ff         	movb	%cl, -0x240(%rbp,%rax)
    348a: 80 f2 5c                     	xorb	$0x5c, %dl
    348d: 88 94 05 c1 fd ff ff         	movb	%dl, -0x23f(%rbp,%rax)
    3494: 0f b6 8c 05 52 ff ff ff      	movzbl	-0xae(%rbp,%rax), %ecx
    349c: 80 f1 5c                     	xorb	$0x5c, %cl
    349f: 88 8c 05 c2 fd ff ff         	movb	%cl, -0x23e(%rbp,%rax)
    34a6: 0f b6 8c 05 53 ff ff ff      	movzbl	-0xad(%rbp,%rax), %ecx
    34ae: 80 f1 5c                     	xorb	$0x5c, %cl
    34b1: 88 8c 05 c3 fd ff ff         	movb	%cl, -0x23d(%rbp,%rax)
    34b8: 48 83 c0 04                  	addq	$0x4, %rax
    34bc: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
    34c2: 75 ac                        	jne	 <L0>
    34c4: b8 03 00 00 00               	movl	$0x3, %eax
    34c9: 0f 1f 80 00 00 00 00         	nopl	(%rax)
<L1>:
    34d0: 0f b6 8c 05 4d ff ff ff      	movzbl	-0xb3(%rbp,%rax), %ecx
    34d8: 0f b6 94 05 4e ff ff ff      	movzbl	-0xb2(%rbp,%rax), %edx
    34e0: 80 f1 36                     	xorb	$0x36, %cl
    34e3: 88 8c 05 6d fe ff ff         	movb	%cl, -0x193(%rbp,%rax)
    34ea: 80 f2 36                     	xorb	$0x36, %dl
    34ed: 88 94 05 6e fe ff ff         	movb	%dl, -0x192(%rbp,%rax)
    34f4: 0f b6 8c 05 4f ff ff ff      	movzbl	-0xb1(%rbp,%rax), %ecx
    34fc: 80 f1 36                     	xorb	$0x36, %cl
    34ff: 88 8c 05 6f fe ff ff         	movb	%cl, -0x191(%rbp,%rax)
    3506: 0f b6 8c 05 50 ff ff ff      	movzbl	-0xb0(%rbp,%rax), %ecx
    350e: 80 f1 36                     	xorb	$0x36, %cl
    3511: 88 8c 05 70 fe ff ff         	movb	%cl, -0x190(%rbp,%rax)
    3518: 48 83 c0 04                  	addq	$0x4, %rax
    351c: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
    3522: 75 ac                        	jne	 <L1>
    3524: 4c 8d a5 e0 fc ff ff         	leaq	-0x320(%rbp), %r12
    352b: be 00 00 00 00               	movl	$0x0, %esi
		000000000000352c:  R_X86_64_32	.rodata+0x10
    3530: ba e0 00 00 00               	movl	$0xe0, %edx
    3535: 4c 89 e7                     	movq	%r12, %rdi
    3538: e8 00 00 00 00               	callq	 <L2>
		0000000000003539:  R_X86_64_PLT32	memcpy-0x4
<L2>:
    353d: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
    3544: 4c 89 e7                     	movq	%r12, %rdi
    3547: e8 f4 d4 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    354c: 4c 8b a5 e8 fc ff ff         	movq	-0x318(%rbp), %r12
    3553: bb 80 00 00 00               	movl	$0x80, %ebx
    3558: 4c 8b bd e0 fc ff ff         	movq	-0x320(%rbp), %r15
    355f: 49 01 df                     	addq	%rbx, %r15
    3562: 49 83 d4 00                  	adcq	$0x0, %r12
    3566: 4c 89 bd e0 fc ff ff         	movq	%r15, -0x320(%rbp)
    356d: 4c 89 a5 e8 fc ff ff         	movq	%r12, -0x318(%rbp)
    3574: 0f b6 85 b0 fd ff ff         	movzbl	-0x250(%rbp), %eax
    357b: 48 85 c0                     	testq	%rax, %rax
    357e: 74 52                        	je	 <L4>
    3580: 3c 50                        	cmpb	$0x50, %al
    3582: 72 50                        	jb	 <L5>
    3584: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    358a: 49 29 c5                     	subq	%rax, %r13
    358d: 4c 8d a5 30 fd ff ff         	leaq	-0x2d0(%rbp), %r12
    3594: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3598: 48 81 c7 30 fd ff ff         	addq	$-0x2d0, %rdi           # imm = 0xFD30
    359f: 4c 89 f6                     	movq	%r14, %rsi
    35a2: 4c 89 ea                     	movq	%r13, %rdx
    35a5: e8 00 00 00 00               	callq	 <L3>
		00000000000035a6:  R_X86_64_PLT32	memcpy-0x4
<L3>:
    35aa: 48 8d bd e0 fc ff ff         	leaq	-0x320(%rbp), %rdi
    35b1: 4c 89 e6                     	movq	%r12, %rsi
    35b4: e8 87 d4 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    35b9: c6 85 b0 fd ff ff 00         	movb	$0x0, -0x250(%rbp)
    35c0: 31 c0                        	xorl	%eax, %eax
    35c2: 4c 8b bd e0 fc ff ff         	movq	-0x320(%rbp), %r15
    35c9: 4c 8b a5 e8 fc ff ff         	movq	-0x318(%rbp), %r12
    35d0: eb 05                        	jmp	 <L6>
<L4>:
    35d2: 31 c0                        	xorl	%eax, %eax
<L5>:
    35d4: 45 31 ed                     	xorl	%r13d, %r13d
<L6>:
    35d7: 4d 01 ee                     	addq	%r13, %r14
    35da: 4c 89 f6                     	movq	%r14, %rsi
    35dd: 41 be 30 00 00 00            	movl	$0x30, %r14d
    35e3: 4d 29 ee                     	subq	%r13, %r14
    35e6: 0f b6 c0                     	movzbl	%al, %eax
    35e9: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    35ed: 48 81 c7 30 fd ff ff         	addq	$-0x2d0, %rdi           # imm = 0xFD30
    35f4: 4c 89 f2                     	movq	%r14, %rdx
    35f7: e8 00 00 00 00               	callq	 <L7>
		00000000000035f8:  R_X86_64_PLT32	memcpy-0x4
<L7>:
    35fc: 44 00 b5 b0 fd ff ff         	addb	%r14b, -0x250(%rbp)
    3603: 49 83 c7 30                  	addq	$0x30, %r15
    3607: 49 83 d4 00                  	adcq	$0x0, %r12
    360b: 4c 89 a5 e8 fc ff ff         	movq	%r12, -0x318(%rbp)
    3612: 4c 89 bd e0 fc ff ff         	movq	%r15, -0x320(%rbp)
    3619: 48 8d bd e0 fc ff ff         	leaq	-0x320(%rbp), %rdi
    3620: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
    3627: e8 e4 fa ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    362c: 4c 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %r14
    3633: be 00 00 00 00               	movl	$0x0, %esi
		0000000000003634:  R_X86_64_32	.rodata+0x10
    3638: ba e0 00 00 00               	movl	$0xe0, %edx
    363d: 4c 89 f7                     	movq	%r14, %rdi
    3640: e8 00 00 00 00               	callq	 <L8>
		0000000000003641:  R_X86_64_PLT32	memcpy-0x4
<L8>:
    3645: 4c 89 f7                     	movq	%r14, %rdi
    3648: 48 8d b5 c0 fd ff ff         	leaq	-0x240(%rbp), %rsi
    364f: e8 ec d3 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3654: 0f b6 bd 40 ff ff ff         	movzbl	-0xc0(%rbp), %edi
    365b: 4c 8b a5 78 fe ff ff         	movq	-0x188(%rbp), %r12
    3662: 48 03 9d 70 fe ff ff         	addq	-0x190(%rbp), %rbx
    3669: 49 83 d4 00                  	adcq	$0x0, %r12
    366d: 4c 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %r14
    3674: 48 89 9d 70 fe ff ff         	movq	%rbx, -0x190(%rbp)
    367b: 4c 89 a5 78 fe ff ff         	movq	%r12, -0x188(%rbp)
    3682: 48 85 ff                     	testq	%rdi, %rdi
    3685: 74 49                        	je	 <L10>
    3687: 40 80 ff 50                  	cmpb	$0x50, %dil
    368b: 72 45                        	jb	 <L11>
    368d: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    3693: 49 29 ff                     	subq	%rdi, %r15
    3696: 4c 01 f7                     	addq	%r14, %rdi
    3699: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
    36a0: 4c 89 fa                     	movq	%r15, %rdx
    36a3: e8 00 00 00 00               	callq	 <L9>
		00000000000036a4:  R_X86_64_PLT32	memcpy-0x4
<L9>:
    36a8: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    36af: 4c 89 f6                     	movq	%r14, %rsi
    36b2: e8 89 d3 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    36b7: c6 85 40 ff ff ff 00         	movb	$0x0, -0xc0(%rbp)
    36be: 31 ff                        	xorl	%edi, %edi
    36c0: 48 8b 9d 70 fe ff ff         	movq	-0x190(%rbp), %rbx
    36c7: 4c 8b a5 78 fe ff ff         	movq	-0x188(%rbp), %r12
    36ce: eb 05                        	jmp	 <L12>
<L10>:
    36d0: 31 ff                        	xorl	%edi, %edi
<L11>:
    36d2: 45 31 ff                     	xorl	%r15d, %r15d
<L12>:
    36d5: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    36d9: 48 81 c6 50 ff ff ff         	addq	$-0xb0, %rsi
    36e0: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    36e6: 4d 29 fd                     	subq	%r15, %r13
    36e9: 40 0f b6 c7                  	movzbl	%dil, %eax
    36ed: 49 01 c6                     	addq	%rax, %r14
    36f0: 4c 89 f7                     	movq	%r14, %rdi
    36f3: 4c 89 ea                     	movq	%r13, %rdx
    36f6: e8 00 00 00 00               	callq	 <L13>
		00000000000036f7:  R_X86_64_PLT32	memcpy-0x4
<L13>:
    36fb: 44 00 ad 40 ff ff ff         	addb	%r13b, -0xc0(%rbp)
    3702: 48 83 c3 30                  	addq	$0x30, %rbx
    3706: 49 83 d4 00                  	adcq	$0x0, %r12
    370a: 4c 89 a5 78 fe ff ff         	movq	%r12, -0x188(%rbp)
    3711: 48 89 9d 70 fe ff ff         	movq	%rbx, -0x190(%rbp)
    3718: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    371f: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    3726: e8 e5 f9 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    372b: 0f 10 85 40 fe ff ff         	movups	-0x1c0(%rbp), %xmm0
    3732: 0f 10 8d 50 fe ff ff         	movups	-0x1b0(%rbp), %xmm1
    3739: 0f 10 95 60 fe ff ff         	movups	-0x1a0(%rbp), %xmm2
    3740: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    3744: 0f 11 50 20                  	movups	%xmm2, 0x20(%rax)
    3748: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
    374c: 0f 11 00                     	movups	%xmm0, (%rax)
    374f: 48 81 c4 f8 02 00 00         	addq	$0x2f8, %rsp            # imm = 0x2F8
    3756: 5b                           	popq	%rbx
    3757: 41 5c                        	popq	%r12
    3759: 41 5d                        	popq	%r13
    375b: 41 5e                        	popq	%r14
    375d: 41 5f                        	popq	%r15
    375f: 5d                           	popq	%rbp
    3760: c3                           	retq
    3761: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    376b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

0000000000003770 <audit_handshake384>:
    3770: 55                           	pushq	%rbp
    3771: 48 89 e5                     	movq	%rsp, %rbp
    3774: 41 57                        	pushq	%r15
    3776: 41 56                        	pushq	%r14
    3778: 53                           	pushq	%rbx
    3779: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            # imm = 0x178
    3780: 48 89 d3                     	movq	%rdx, %rbx
    3783: 49 89 f6                     	movq	%rsi, %r14
    3786: 49 89 f8                     	movq	%rdi, %r8
    3789: 66 c7 85 70 fe ff ff 00 30   	movw	$0x3000, -0x190(%rbp)   # imm = 0x3000
    3792: c6 85 72 fe ff ff 0d         	movb	$0xd, -0x18e(%rbp)
    3799: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    37a3: 48 89 85 73 fe ff ff         	movq	%rax, -0x18d(%rbp)
    37aa: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    37b4: 48 89 85 78 fe ff ff         	movq	%rax, -0x188(%rbp)
    37bb: c6 85 80 fe ff ff 30         	movb	$0x30, -0x180(%rbp)
    37c2: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x59>
		00000000000037c5:  R_X86_64_PC32	.rodata+0x129
    37c9: 0f 11 85 81 fe ff ff         	movups	%xmm0, -0x17f(%rbp)
    37d0: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x67>
		00000000000037d3:  R_X86_64_PC32	.rodata+0x139
    37d7: 0f 11 85 91 fe ff ff         	movups	%xmm0, -0x16f(%rbp)
    37de: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x75>
		00000000000037e1:  R_X86_64_PC32	.rodata+0x149
    37e5: 0f 11 85 a1 fe ff ff         	movups	%xmm0, -0x15f(%rbp)
    37ec: 4c 8d 7d b0                  	leaq	-0x50(%rbp), %r15
    37f0: 48 8d 95 70 fe ff ff         	leaq	-0x190(%rbp), %rdx
    37f7: be 30 00 00 00               	movl	$0x30, %esi
    37fc: b9 41 00 00 00               	movl	$0x41, %ecx
    3801: 4c 89 ff                     	movq	%r15, %rdi
    3804: e8 77 c8 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    3809: 48 8d 7d 80                  	leaq	-0x80(%rbp), %rdi
    380d: 4c 89 fe                     	movq	%r15, %rsi
    3810: 4c 89 f2                     	movq	%r14, %rdx
    3813: e8 f8 fb ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    3818: 0f 57 c0                     	xorps	%xmm0, %xmm0
    381b: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    381f: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    3823: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    3827: 0f 10 45 80                  	movups	-0x80(%rbp), %xmm0
    382b: 0f 10 4d 90                  	movups	-0x70(%rbp), %xmm1
    382f: 0f 10 55 a0                  	movups	-0x60(%rbp), %xmm2
    3833: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    3837: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    383b: 0f 11 03                     	movups	%xmm0, (%rbx)
    383e: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            # imm = 0x178
    3845: 5b                           	popq	%rbx
    3846: 41 5e                        	popq	%r14
    3848: 41 5f                        	popq	%r15
    384a: 5d                           	popq	%rbp
    384b: c3                           	retq
    384c: 0f 1f 40 00                  	nopl	(%rax)

0000000000003850 <audit_key256>:
    3850: 55                           	pushq	%rbp
    3851: 48 89 e5                     	movq	%rsp, %rbp
    3854: 48 81 ec 30 01 00 00         	subq	$0x130, %rsp            # imm = 0x130
    385b: 48 89 f0                     	movq	%rsi, %rax
    385e: 0f 10 07                     	movups	(%rdi), %xmm0
    3861: 0f 10 4f 10                  	movups	0x10(%rdi), %xmm1
    3865: 0f 29 4d f0                  	movaps	%xmm1, -0x10(%rbp)
    3869: 0f 29 45 e0                  	movaps	%xmm0, -0x20(%rbp)
    386d: 66 c7 85 d4 fe ff ff 00 10   	movw	$0x1000, -0x12c(%rbp)   # imm = 0x1000
    3876: c6 85 d6 fe ff ff 09         	movb	$0x9, -0x12a(%rbp)
    387d: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
    3887: 48 89 8d d7 fe ff ff         	movq	%rcx, -0x129(%rbp)
    388e: 66 c7 85 df fe ff ff 79 00   	movw	$0x79, -0x121(%rbp)
    3897: 48 8d 95 d4 fe ff ff         	leaq	-0x12c(%rbp), %rdx
    389e: 4c 8d 45 e0                  	leaq	-0x20(%rbp), %r8
    38a2: be 10 00 00 00               	movl	$0x10, %esi
    38a7: b9 0d 00 00 00               	movl	$0xd, %ecx
    38ac: 48 89 c7                     	movq	%rax, %rdi
    38af: e8 0c 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    38b4: 48 81 c4 30 01 00 00         	addq	$0x130, %rsp            # imm = 0x130
    38bb: 5d                           	popq	%rbp
    38bc: c3                           	retq
    38bd: 0f 1f 00                     	nopl	(%rax)

00000000000038c0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
    38c0: 55                           	pushq	%rbp
    38c1: 48 89 e5                     	movq	%rsp, %rbp
    38c4: 41 57                        	pushq	%r15
    38c6: 41 56                        	pushq	%r14
    38c8: 41 55                        	pushq	%r13
    38ca: 41 54                        	pushq	%r12
    38cc: 53                           	pushq	%rbx
    38cd: 48 81 ec 48 02 00 00         	subq	$0x248, %rsp            # imm = 0x248
    38d4: 49 89 cf                     	movq	%rcx, %r15
    38d7: 49 89 d4                     	movq	%rdx, %r12
    38da: 48 89 bd 18 ff ff ff         	movq	%rdi, -0xe8(%rbp)
    38e1: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    38e5: 48 83 fe 20                  	cmpq	$0x20, %rsi
    38e9: 0f 83 a4 01 00 00            	jae	 <L3>
    38ef: 41 0f 10 00                  	movups	(%r8), %xmm0
    38f3: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
    38f8: 0f 29 4d a0                  	movaps	%xmm1, -0x60(%rbp)
    38fc: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    3900: 0f 57 c0                     	xorps	%xmm0, %xmm0
    3903: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    3907: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    390b: 31 c0                        	xorl	%eax, %eax
    390d: 0f 1f 00                     	nopl	(%rax)
<L0>:
    3910: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3915: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    391a: 80 f1 5c                     	xorb	$0x5c, %cl
    391d: 88 8c 05 d0 fe ff ff         	movb	%cl, -0x130(%rbp,%rax)
    3924: 80 f2 5c                     	xorb	$0x5c, %dl
    3927: 88 94 05 d1 fe ff ff         	movb	%dl, -0x12f(%rbp,%rax)
    392e: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    3933: 80 f1 5c                     	xorb	$0x5c, %cl
    3936: 88 8c 05 d2 fe ff ff         	movb	%cl, -0x12e(%rbp,%rax)
    393d: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    3942: 80 f1 5c                     	xorb	$0x5c, %cl
    3945: 88 8c 05 d3 fe ff ff         	movb	%cl, -0x12d(%rbp,%rax)
    394c: 48 83 c0 04                  	addq	$0x4, %rax
    3950: 48 83 f8 40                  	cmpq	$0x40, %rax
    3954: 75 ba                        	jne	 <L0>
    3956: 48 89 b5 10 ff ff ff         	movq	%rsi, -0xf0(%rbp)
    395d: b8 03 00 00 00               	movl	$0x3, %eax
    3962: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    396c: 0f 1f 40 00                  	nopl	(%rax)
<L1>:
    3970: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    3975: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    397a: 80 f1 36                     	xorb	$0x36, %cl
    397d: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    3984: 80 f2 36                     	xorb	$0x36, %dl
    3987: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    398e: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    3993: 80 f1 36                     	xorb	$0x36, %cl
    3996: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    399d: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    39a2: 80 f1 36                     	xorb	$0x36, %cl
    39a5: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    39ac: 48 83 c0 04                  	addq	$0x4, %rax
    39b0: 48 83 f8 43                  	cmpq	$0x43, %rax
    39b4: 75 ba                        	jne	 <L1>
    39b6: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xfd>
		00000000000039b9:  R_X86_64_PC32	.rodata+0x1bc
    39bd: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    39c4: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x10b>
		00000000000039c7:  R_X86_64_PC32	.rodata+0x1ac
    39cb: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
    39d2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x119>
		00000000000039d5:  R_X86_64_PC32	.rodata+0x19c
    39d9: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    39e0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x127>
		00000000000039e3:  R_X86_64_PC32	.rodata+0x18c
    39e7: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    39ee: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x135>
		00000000000039f1:  R_X86_64_PC32	.rodata+0x17c
    39f5: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    39fc: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x143>
		00000000000039ff:  R_X86_64_PC32	.rodata+0x16c
    3a03: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    3a0a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x151>
		0000000000003a0d:  R_X86_64_PC32	.rodata+0x15c
    3a11: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    3a18: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3a1f: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3a26: e8 55 07 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3a2b: 48 83 85 80 fe ff ff 40      	addq	$0x40, -0x180(%rbp)
    3a33: 0f b6 85 c8 fe ff ff         	movzbl	-0x138(%rbp), %eax
    3a3a: 48 85 c0                     	testq	%rax, %rax
    3a3d: 0f 84 dc 01 00 00            	je	 <L7>
    3a43: 49 8d 0c 07                  	leaq	(%r15,%rax), %rcx
    3a47: 48 83 f9 40                  	cmpq	$0x40, %rcx
    3a4b: 0f 82 d0 01 00 00            	jb	 <L8>
    3a51: bb 40 00 00 00               	movl	$0x40, %ebx
    3a56: 48 29 c3                     	subq	%rax, %rbx
    3a59: 4c 8d b5 88 fe ff ff         	leaq	-0x178(%rbp), %r14
    3a60: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3a64: 48 81 c7 88 fe ff ff         	addq	$-0x178, %rdi           # imm = 0xFE88
    3a6b: 4c 89 e6                     	movq	%r12, %rsi
    3a6e: 48 89 da                     	movq	%rbx, %rdx
    3a71: e8 00 00 00 00               	callq	 <L2>
		0000000000003a72:  R_X86_64_PLT32	memcpy-0x4
<L2>:
    3a76: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3a7d: 4c 89 f6                     	movq	%r14, %rsi
    3a80: e8 fb 06 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3a85: c6 85 c8 fe ff ff 00         	movb	$0x0, -0x138(%rbp)
    3a8c: 31 c0                        	xorl	%eax, %eax
    3a8e: e9 90 01 00 00               	jmp	 <L9>
<L3>:
    3a93: 4c 89 fb                     	movq	%r15, %rbx
    3a96: 48 83 f3 3f                  	xorq	$0x3f, %rbx
    3a9a: 4c 8d ad d8 fd ff ff         	leaq	-0x228(%rbp), %r13
    3aa1: 41 0f 10 00                  	movups	(%r8), %xmm0
    3aa5: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
    3aaa: 0f 29 4d a0                  	movaps	%xmm1, -0x60(%rbp)
    3aae: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    3ab2: 0f 57 c0                     	xorps	%xmm0, %xmm0
    3ab5: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    3ab9: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    3abd: 31 c0                        	xorl	%eax, %eax
    3abf: 90                           	nop
<L4>:
    3ac0: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3ac5: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    3aca: 80 f1 5c                     	xorb	$0x5c, %cl
    3acd: 88 8c 05 20 fe ff ff         	movb	%cl, -0x1e0(%rbp,%rax)
    3ad4: 80 f2 5c                     	xorb	$0x5c, %dl
    3ad7: 88 94 05 21 fe ff ff         	movb	%dl, -0x1df(%rbp,%rax)
    3ade: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    3ae3: 80 f1 5c                     	xorb	$0x5c, %cl
    3ae6: 88 8c 05 22 fe ff ff         	movb	%cl, -0x1de(%rbp,%rax)
    3aed: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    3af2: 80 f1 5c                     	xorb	$0x5c, %cl
    3af5: 88 8c 05 23 fe ff ff         	movb	%cl, -0x1dd(%rbp,%rax)
    3afc: 48 83 c0 04                  	addq	$0x4, %rax
    3b00: 48 83 f8 40                  	cmpq	$0x40, %rax
    3b04: 75 ba                        	jne	 <L4>
    3b06: b8 03 00 00 00               	movl	$0x3, %eax
    3b0b: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L5>:
    3b10: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    3b15: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    3b1a: 80 f1 36                     	xorb	$0x36, %cl
    3b1d: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    3b24: 80 f2 36                     	xorb	$0x36, %dl
    3b27: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    3b2e: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    3b33: 80 f1 36                     	xorb	$0x36, %cl
    3b36: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    3b3d: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3b42: 80 f1 36                     	xorb	$0x36, %cl
    3b45: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    3b4c: 48 83 c0 04                  	addq	$0x4, %rax
    3b50: 48 83 f8 43                  	cmpq	$0x43, %rax
    3b54: 75 ba                        	jne	 <L5>
    3b56: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x29d>
		0000000000003b59:  R_X86_64_PC32	.rodata+0x1bc
    3b5d: 0f 29 85 10 fe ff ff         	movaps	%xmm0, -0x1f0(%rbp)
    3b64: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2ab>
		0000000000003b67:  R_X86_64_PC32	.rodata+0x1ac
    3b6b: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    3b72: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2b9>
		0000000000003b75:  R_X86_64_PC32	.rodata+0x19c
    3b79: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    3b80: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2c7>
		0000000000003b83:  R_X86_64_PC32	.rodata+0x18c
    3b87: 0f 29 85 e0 fd ff ff         	movaps	%xmm0, -0x220(%rbp)
    3b8e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2d5>
		0000000000003b91:  R_X86_64_PC32	.rodata+0x17c
    3b95: 0f 29 85 d0 fd ff ff         	movaps	%xmm0, -0x230(%rbp)
    3b9c: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2e3>
		0000000000003b9f:  R_X86_64_PC32	.rodata+0x16c
    3ba3: 0f 29 85 c0 fd ff ff         	movaps	%xmm0, -0x240(%rbp)
    3baa: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2f1>
		0000000000003bad:  R_X86_64_PC32	.rodata+0x15c
    3bb1: 0f 29 85 b0 fd ff ff         	movaps	%xmm0, -0x250(%rbp)
    3bb8: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3bbf: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3bc6: e8 b5 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3bcb: 48 83 85 d0 fd ff ff 40      	addq	$0x40, -0x230(%rbp)
    3bd3: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
    3bda: 48 85 ff                     	testq	%rdi, %rdi
    3bdd: 0f 84 d7 00 00 00            	je	 <L12>
    3be3: 48 39 fb                     	cmpq	%rdi, %rbx
    3be6: 0f 83 d0 00 00 00            	jae	 <L13>
    3bec: bb 40 00 00 00               	movl	$0x40, %ebx
    3bf1: 48 29 fb                     	subq	%rdi, %rbx
    3bf4: 4c 01 ef                     	addq	%r13, %rdi
    3bf7: 4c 89 e6                     	movq	%r12, %rsi
    3bfa: 48 89 da                     	movq	%rbx, %rdx
    3bfd: e8 00 00 00 00               	callq	 <L6>
		0000000000003bfe:  R_X86_64_PLT32	memcpy-0x4
<L6>:
    3c02: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3c09: 4c 89 ee                     	movq	%r13, %rsi
    3c0c: e8 6f 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3c11: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
    3c18: 31 ff                        	xorl	%edi, %edi
    3c1a: e9 9f 00 00 00               	jmp	 <L14>
<L7>:
    3c1f: 31 c0                        	xorl	%eax, %eax
<L8>:
    3c21: 31 db                        	xorl	%ebx, %ebx
<L9>:
    3c23: 49 01 dc                     	addq	%rbx, %r12
    3c26: 4d 89 fe                     	movq	%r15, %r14
    3c29: 49 29 de                     	subq	%rbx, %r14
    3c2c: 4c 8d ad 88 fe ff ff         	leaq	-0x178(%rbp), %r13
    3c33: 0f b6 c0                     	movzbl	%al, %eax
    3c36: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3c3a: 48 81 c7 88 fe ff ff         	addq	$-0x178, %rdi           # imm = 0xFE88
    3c41: 4c 89 e6                     	movq	%r12, %rsi
    3c44: 4c 89 f2                     	movq	%r14, %rdx
    3c47: e8 00 00 00 00               	callq	 <L10>
		0000000000003c48:  R_X86_64_PLT32	memcpy-0x4
<L10>:
    3c4c: 0f b6 bd c8 fe ff ff         	movzbl	-0x138(%rbp), %edi
    3c53: 4c 01 f7                     	addq	%r14, %rdi
    3c56: 40 88 bd c8 fe ff ff         	movb	%dil, -0x138(%rbp)
    3c5d: 4c 03 bd 80 fe ff ff         	addq	-0x180(%rbp), %r15
    3c64: 4c 89 bd 80 fe ff ff         	movq	%r15, -0x180(%rbp)
    3c6b: 40 84 ff                     	testb	%dil, %dil
    3c6e: 0f 84 d3 00 00 00            	je	 <L17>
    3c74: 40 80 ff 3f                  	cmpb	$0x3f, %dil
    3c78: 0f 82 cb 00 00 00            	jb	 <L18>
    3c7e: b0 40                        	movb	$0x40, %al
    3c80: 40 28 f8                     	subb	%dil, %al
    3c83: 44 0f b6 e0                  	movzbl	%al, %r12d
    3c87: 4c 01 ef                     	addq	%r13, %rdi
    3c8a: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3c8e: 4c 89 e2                     	movq	%r12, %rdx
    3c91: e8 00 00 00 00               	callq	 <L11>
		0000000000003c92:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    3c96: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3c9d: 4c 89 ee                     	movq	%r13, %rsi
    3ca0: e8 db 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3ca5: c6 85 c8 fe ff ff 00         	movb	$0x0, -0x138(%rbp)
    3cac: 31 ff                        	xorl	%edi, %edi
    3cae: 4c 8b bd 80 fe ff ff         	movq	-0x180(%rbp), %r15
    3cb5: e9 92 00 00 00               	jmp	 <L19>
<L12>:
    3cba: 31 ff                        	xorl	%edi, %edi
<L13>:
    3cbc: 31 db                        	xorl	%ebx, %ebx
<L14>:
    3cbe: 49 01 dc                     	addq	%rbx, %r12
    3cc1: 4d 89 fe                     	movq	%r15, %r14
    3cc4: 49 29 de                     	subq	%rbx, %r14
    3cc7: 40 0f b6 ff                  	movzbl	%dil, %edi
    3ccb: 4c 01 ef                     	addq	%r13, %rdi
    3cce: 4c 89 e6                     	movq	%r12, %rsi
    3cd1: 4c 89 f2                     	movq	%r14, %rdx
    3cd4: e8 00 00 00 00               	callq	 <L15>
		0000000000003cd5:  R_X86_64_PLT32	memcpy-0x4
<L15>:
    3cd9: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
    3ce0: 4c 01 f7                     	addq	%r14, %rdi
    3ce3: 40 88 bd 18 fe ff ff         	movb	%dil, -0x1e8(%rbp)
    3cea: 4c 03 bd d0 fd ff ff         	addq	-0x230(%rbp), %r15
    3cf1: 4c 89 bd d0 fd ff ff         	movq	%r15, -0x230(%rbp)
    3cf8: 40 84 ff                     	testb	%dil, %dil
    3cfb: 0f 84 69 01 00 00            	je	 <L22>
    3d01: 40 80 ff 3f                  	cmpb	$0x3f, %dil
    3d05: 0f 82 61 01 00 00            	jb	 <L23>
    3d0b: b0 40                        	movb	$0x40, %al
    3d0d: 40 28 f8                     	subb	%dil, %al
    3d10: 44 0f b6 e0                  	movzbl	%al, %r12d
    3d14: 4c 01 ef                     	addq	%r13, %rdi
    3d17: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3d1b: 4c 89 e2                     	movq	%r12, %rdx
    3d1e: e8 00 00 00 00               	callq	 <L16>
		0000000000003d1f:  R_X86_64_PLT32	memcpy-0x4
<L16>:
    3d23: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3d2a: 4c 89 ee                     	movq	%r13, %rsi
    3d2d: e8 4e 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3d32: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
    3d39: 31 ff                        	xorl	%edi, %edi
    3d3b: 4c 8b bd d0 fd ff ff         	movq	-0x230(%rbp), %r15
    3d42: e9 28 01 00 00               	jmp	 <L24>
<L17>:
    3d47: 31 ff                        	xorl	%edi, %edi
<L18>:
    3d49: 45 31 e4                     	xorl	%r12d, %r12d
<L19>:
    3d4c: 49 8d 34 2c                  	leaq	(%r12,%rbp), %rsi
    3d50: 48 83 c6 d7                  	addq	$-0x29, %rsi
    3d54: bb 01 00 00 00               	movl	$0x1, %ebx
    3d59: 4c 29 e3                     	subq	%r12, %rbx
    3d5c: 40 0f b6 c7                  	movzbl	%dil, %eax
    3d60: 49 01 c5                     	addq	%rax, %r13
    3d63: 4c 89 ef                     	movq	%r13, %rdi
    3d66: 48 89 da                     	movq	%rbx, %rdx
    3d69: e8 00 00 00 00               	callq	 <L20>
		0000000000003d6a:  R_X86_64_PLT32	memcpy-0x4
<L20>:
    3d6e: 00 9d c8 fe ff ff            	addb	%bl, -0x138(%rbp)
    3d74: 49 83 c7 01                  	addq	$0x1, %r15
    3d78: 4c 89 bd 80 fe ff ff         	movq	%r15, -0x180(%rbp)
    3d7f: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3d86: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3d8a: e8 d1 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3d8f: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4d6>
		0000000000003d92:  R_X86_64_PC32	.rodata+0x1bc
    3d96: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3d9a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4e1>
		0000000000003d9d:  R_X86_64_PC32	.rodata+0x1ac
    3da1: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3da8: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4ef>
		0000000000003dab:  R_X86_64_PC32	.rodata+0x19c
    3daf: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3db6: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4fd>
		0000000000003db9:  R_X86_64_PC32	.rodata+0x18c
    3dbd: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3dc4: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x50b>
		0000000000003dc7:  R_X86_64_PC32	.rodata+0x17c
    3dcb: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    3dd2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x519>
		0000000000003dd5:  R_X86_64_PC32	.rodata+0x16c
    3dd9: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3de0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x527>
		0000000000003de3:  R_X86_64_PC32	.rodata+0x15c
    3de7: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3dee: 48 8d b5 d0 fe ff ff         	leaq	-0x130(%rbp), %rsi
    3df5: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3dfc: e8 7f 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3e01: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    3e05: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3e0c: 49 83 c7 40                  	addq	$0x40, %r15
    3e10: 4c 8d b5 48 ff ff ff         	leaq	-0xb8(%rbp), %r14
    3e17: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3e1e: 48 85 ff                     	testq	%rdi, %rdi
    3e21: 0f 84 63 01 00 00            	je	 <L27>
    3e27: 40 80 ff 20                  	cmpb	$0x20, %dil
    3e2b: 0f 82 5b 01 00 00            	jb	 <L28>
    3e31: 41 bc 40 00 00 00            	movl	$0x40, %r12d
    3e37: 49 29 fc                     	subq	%rdi, %r12
    3e3a: 4c 01 f7                     	addq	%r14, %rdi
    3e3d: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3e41: 4c 89 e2                     	movq	%r12, %rdx
    3e44: e8 00 00 00 00               	callq	 <L21>
		0000000000003e45:  R_X86_64_PLT32	memcpy-0x4
<L21>:
    3e49: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3e50: 4c 89 f6                     	movq	%r14, %rsi
    3e53: e8 28 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3e58: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    3e5c: 31 ff                        	xorl	%edi, %edi
    3e5e: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3e65: e9 25 01 00 00               	jmp	 <L29>
<L22>:
    3e6a: 31 ff                        	xorl	%edi, %edi
<L23>:
    3e6c: 45 31 e4                     	xorl	%r12d, %r12d
<L24>:
    3e6f: 49 8d 34 2c                  	leaq	(%r12,%rbp), %rsi
    3e73: 48 83 c6 d7                  	addq	$-0x29, %rsi
    3e77: bb 01 00 00 00               	movl	$0x1, %ebx
    3e7c: 4c 29 e3                     	subq	%r12, %rbx
    3e7f: 40 0f b6 c7                  	movzbl	%dil, %eax
    3e83: 49 01 c5                     	addq	%rax, %r13
    3e86: 4c 89 ef                     	movq	%r13, %rdi
    3e89: 48 89 da                     	movq	%rbx, %rdx
    3e8c: e8 00 00 00 00               	callq	 <L25>
		0000000000003e8d:  R_X86_64_PLT32	memcpy-0x4
<L25>:
    3e91: 00 9d 18 fe ff ff            	addb	%bl, -0x1e8(%rbp)
    3e97: 49 83 c7 01                  	addq	$0x1, %r15
    3e9b: 4c 89 bd d0 fd ff ff         	movq	%r15, -0x230(%rbp)
    3ea2: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3ea9: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3ead: e8 ae 01 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3eb2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x5f9>
		0000000000003eb5:  R_X86_64_PC32	.rodata+0x1bc
    3eb9: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3ebd: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x604>
		0000000000003ec0:  R_X86_64_PC32	.rodata+0x1ac
    3ec4: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3ecb: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x612>
		0000000000003ece:  R_X86_64_PC32	.rodata+0x19c
    3ed2: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3ed9: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x620>
		0000000000003edc:  R_X86_64_PC32	.rodata+0x18c
    3ee0: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3ee7: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x62e>
		0000000000003eea:  R_X86_64_PC32	.rodata+0x17c
    3eee: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    3ef5: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x63c>
		0000000000003ef8:  R_X86_64_PC32	.rodata+0x16c
    3efc: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3f03: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x64a>
		0000000000003f06:  R_X86_64_PC32	.rodata+0x15c
    3f0a: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3f11: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3f18: 48 8d b5 20 fe ff ff         	leaq	-0x1e0(%rbp), %rsi
    3f1f: e8 5c 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3f24: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    3f28: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3f2f: 49 83 c7 40                  	addq	$0x40, %r15
    3f33: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3f3a: 48 85 ff                     	testq	%rdi, %rdi
    3f3d: 0f 84 aa 00 00 00            	je	 <L32>
    3f43: 40 80 ff 20                  	cmpb	$0x20, %dil
    3f47: 4c 8d a5 48 ff ff ff         	leaq	-0xb8(%rbp), %r12
    3f4e: 0f 82 a7 00 00 00            	jb	 <L33>
    3f54: 41 be 40 00 00 00            	movl	$0x40, %r14d
    3f5a: 49 29 fe                     	subq	%rdi, %r14
    3f5d: 4c 01 e7                     	addq	%r12, %rdi
    3f60: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3f64: 4c 89 f2                     	movq	%r14, %rdx
    3f67: e8 00 00 00 00               	callq	 <L26>
		0000000000003f68:  R_X86_64_PLT32	memcpy-0x4
<L26>:
    3f6c: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3f73: 4c 89 e6                     	movq	%r12, %rsi
    3f76: e8 05 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3f7b: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    3f7f: 31 ff                        	xorl	%edi, %edi
    3f81: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3f88: eb 74                        	jmp	 <L34>
<L27>:
    3f8a: 31 ff                        	xorl	%edi, %edi
<L28>:
    3f8c: 45 31 e4                     	xorl	%r12d, %r12d
<L29>:
    3f8f: 49 8d 34 2c                  	leaq	(%r12,%rbp), %rsi
    3f93: 48 83 c6 90                  	addq	$-0x70, %rsi
    3f97: bb 20 00 00 00               	movl	$0x20, %ebx
    3f9c: 4c 29 e3                     	subq	%r12, %rbx
    3f9f: 40 0f b6 c7                  	movzbl	%dil, %eax
    3fa3: 49 01 c6                     	addq	%rax, %r14
    3fa6: 4c 89 f7                     	movq	%r14, %rdi
    3fa9: 48 89 da                     	movq	%rbx, %rdx
    3fac: e8 00 00 00 00               	callq	 <L30>
		0000000000003fad:  R_X86_64_PLT32	memcpy-0x4
<L30>:
    3fb1: 00 5d 88                     	addb	%bl, -0x78(%rbp)
    3fb4: 49 83 c7 20                  	addq	$0x20, %r15
    3fb8: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3fbf: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3fc6: 48 8d 9d 90 fd ff ff         	leaq	-0x270(%rbp), %rbx
    3fcd: 48 89 de                     	movq	%rbx, %rsi
    3fd0: e8 8b 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3fd5: 48 8b bd 18 ff ff ff         	movq	-0xe8(%rbp), %rdi
    3fdc: 48 89 de                     	movq	%rbx, %rsi
    3fdf: 48 8b 95 10 ff ff ff         	movq	-0xf0(%rbp), %rdx
    3fe6: e8 00 00 00 00               	callq	 <L31>
		0000000000003fe7:  R_X86_64_PLT32	memcpy-0x4
<L31>:
    3feb: eb 54                        	jmp	 <L36>
<L32>:
    3fed: 31 ff                        	xorl	%edi, %edi
    3fef: 45 31 f6                     	xorl	%r14d, %r14d
    3ff2: 4c 8d a5 48 ff ff ff         	leaq	-0xb8(%rbp), %r12
    3ff9: eb 03                        	jmp	 <L34>
<L33>:
    3ffb: 45 31 f6                     	xorl	%r14d, %r14d
<L34>:
    3ffe: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    4002: 48 83 c6 90                  	addq	$-0x70, %rsi
    4006: bb 20 00 00 00               	movl	$0x20, %ebx
    400b: 4c 29 f3                     	subq	%r14, %rbx
    400e: 40 0f b6 c7                  	movzbl	%dil, %eax
    4012: 49 01 c4                     	addq	%rax, %r12
    4015: 4c 89 e7                     	movq	%r12, %rdi
    4018: 48 89 da                     	movq	%rbx, %rdx
    401b: e8 00 00 00 00               	callq	 <L35>
		000000000000401c:  R_X86_64_PLT32	memcpy-0x4
<L35>:
    4020: 00 5d 88                     	addb	%bl, -0x78(%rbp)
    4023: 49 83 c7 20                  	addq	$0x20, %r15
    4027: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    402e: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    4035: 48 8b b5 18 ff ff ff         	movq	-0xe8(%rbp), %rsi
    403c: e8 1f 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
<L36>:
    4041: 48 81 c4 48 02 00 00         	addq	$0x248, %rsp            # imm = 0x248
    4048: 5b                           	popq	%rbx
    4049: 41 5c                        	popq	%r12
    404b: 41 5d                        	popq	%r13
    404d: 41 5e                        	popq	%r14
    404f: 41 5f                        	popq	%r15
    4051: 5d                           	popq	%rbp
    4052: c3                           	retq
    4053: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    405d: 0f 1f 00                     	nopl	(%rax)

0000000000004060 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
    4060: 55                           	pushq	%rbp
    4061: 48 89 e5                     	movq	%rsp, %rbp
    4064: 41 57                        	pushq	%r15
    4066: 41 56                        	pushq	%r14
    4068: 53                           	pushq	%rbx
    4069: 50                           	pushq	%rax
    406a: 48 89 f3                     	movq	%rsi, %rbx
    406d: 49 89 fe                     	movq	%rdi, %r14
    4070: 4c 8d 7f 28                  	leaq	0x28(%rdi), %r15
    4074: 0f b6 47 68                  	movzbl	0x68(%rdi), %eax
    4078: 48 01 c7                     	addq	%rax, %rdi
    407b: 48 83 c7 28                  	addq	$0x28, %rdi
    407f: ba 40 00 00 00               	movl	$0x40, %edx
    4084: 48 29 c2                     	subq	%rax, %rdx
    4087: 31 f6                        	xorl	%esi, %esi
    4089: e8 00 00 00 00               	callq	 <L0>
		000000000000408a:  R_X86_64_PLT32	memset-0x4
<L0>:
    408e: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
    4093: 41 c6 44 06 28 80            	movb	$-0x80, 0x28(%r14,%rax)
    4099: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
    409e: 8d 48 01                     	leal	0x1(%rax), %ecx
    40a1: 41 88 4e 68                  	movb	%cl, 0x68(%r14)
    40a5: 3c 37                        	cmpb	$0x37, %al
    40a7: 76 24                        	jbe	 <L1>
    40a9: 4c 89 f7                     	movq	%r14, %rdi
    40ac: 4c 89 fe                     	movq	%r15, %rsi
    40af: e8 cc 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    40b4: 0f 57 c0                     	xorps	%xmm0, %xmm0
    40b7: 41 0f 11 47 20               	movups	%xmm0, 0x20(%r15)
    40bc: 41 0f 11 47 10               	movups	%xmm0, 0x10(%r15)
    40c1: 41 0f 11 07                  	movups	%xmm0, (%r15)
    40c5: 49 c7 47 30 00 00 00 00      	movq	$0x0, 0x30(%r15)
<L1>:
    40cd: 49 8b 46 20                  	movq	0x20(%r14), %rax
    40d1: 89 c1                        	movl	%eax, %ecx
    40d3: c1 e9 05                     	shrl	$0x5, %ecx
    40d6: 8d 14 c5 00 00 00 00         	leal	(,%rax,8), %edx
    40dd: 41 88 56 67                  	movb	%dl, 0x67(%r14)
    40e1: 41 88 4e 66                  	movb	%cl, 0x66(%r14)
    40e5: 89 c1                        	movl	%eax, %ecx
    40e7: c1 e9 0d                     	shrl	$0xd, %ecx
    40ea: 41 88 4e 65                  	movb	%cl, 0x65(%r14)
    40ee: 89 c1                        	movl	%eax, %ecx
    40f0: c1 e9 15                     	shrl	$0x15, %ecx
    40f3: 41 88 4e 64                  	movb	%cl, 0x64(%r14)
    40f7: 48 89 c1                     	movq	%rax, %rcx
    40fa: 48 c1 e9 1d                  	shrq	$0x1d, %rcx
    40fe: 41 88 4e 63                  	movb	%cl, 0x63(%r14)
    4102: 48 89 c1                     	movq	%rax, %rcx
    4105: 48 c1 e9 25                  	shrq	$0x25, %rcx
    4109: 41 88 4e 62                  	movb	%cl, 0x62(%r14)
    410d: 48 89 c1                     	movq	%rax, %rcx
    4110: 48 c1 e9 2d                  	shrq	$0x2d, %rcx
    4114: 41 88 4e 61                  	movb	%cl, 0x61(%r14)
    4118: 48 c1 e8 35                  	shrq	$0x35, %rax
    411c: 41 88 46 60                  	movb	%al, 0x60(%r14)
    4120: 4c 89 f7                     	movq	%r14, %rdi
    4123: 4c 89 fe                     	movq	%r15, %rsi
    4126: e8 55 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    412b: 41 8b 06                     	movl	(%r14), %eax
    412e: 0f c8                        	bswapl	%eax
    4130: 89 03                        	movl	%eax, (%rbx)
    4132: 41 8b 46 04                  	movl	0x4(%r14), %eax
    4136: 0f c8                        	bswapl	%eax
    4138: 89 43 04                     	movl	%eax, 0x4(%rbx)
    413b: 41 8b 46 08                  	movl	0x8(%r14), %eax
    413f: 0f c8                        	bswapl	%eax
    4141: 89 43 08                     	movl	%eax, 0x8(%rbx)
    4144: 41 8b 46 0c                  	movl	0xc(%r14), %eax
    4148: 0f c8                        	bswapl	%eax
    414a: 89 43 0c                     	movl	%eax, 0xc(%rbx)
    414d: 41 8b 46 10                  	movl	0x10(%r14), %eax
    4151: 0f c8                        	bswapl	%eax
    4153: 89 43 10                     	movl	%eax, 0x10(%rbx)
    4156: 41 8b 46 14                  	movl	0x14(%r14), %eax
    415a: 0f c8                        	bswapl	%eax
    415c: 89 43 14                     	movl	%eax, 0x14(%rbx)
    415f: 41 8b 46 18                  	movl	0x18(%r14), %eax
    4163: 0f c8                        	bswapl	%eax
    4165: 89 43 18                     	movl	%eax, 0x18(%rbx)
    4168: 41 8b 46 1c                  	movl	0x1c(%r14), %eax
    416c: 0f c8                        	bswapl	%eax
    416e: 89 43 1c                     	movl	%eax, 0x1c(%rbx)
    4171: 48 83 c4 08                  	addq	$0x8, %rsp
    4175: 5b                           	popq	%rbx
    4176: 41 5e                        	popq	%r14
    4178: 41 5f                        	popq	%r15
    417a: 5d                           	popq	%rbp
    417b: c3                           	retq
    417c: 0f 1f 40 00                  	nopl	(%rax)

0000000000004180 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
    4180: 55                           	pushq	%rbp
    4181: 48 89 e5                     	movq	%rsp, %rbp
    4184: 41 57                        	pushq	%r15
    4186: 41 56                        	pushq	%r14
    4188: 41 55                        	pushq	%r13
    418a: 41 54                        	pushq	%r12
    418c: 53                           	pushq	%rbx
    418d: 48 81 ec 88 00 00 00         	subq	$0x88, %rsp
    4194: f3 0f 6f 06                  	movdqu	(%rsi), %xmm0
    4198: 66 0f ef c9                  	pxor	%xmm1, %xmm1
    419c: 66 0f 6f d0                  	movdqa	%xmm0, %xmm2
    41a0: 66 0f 68 d1                  	punpckhbw	%xmm1, %xmm2    # xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
    41a4: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
    41a9: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
    41ae: 66 0f 60 c1                  	punpcklbw	%xmm1, %xmm0    # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
    41b2: f2 0f 70 c0 1b               	pshuflw	$0x1b, %xmm0, %xmm0     # xmm0 = xmm0[3,2,1,0,4,5,6,7]
    41b7: f3 0f 70 c0 1b               	pshufhw	$0x1b, %xmm0, %xmm0     # xmm0 = xmm0[0,1,2,3,7,6,5,4]
    41bc: 66 0f 67 c2                  	packuswb	%xmm2, %xmm0
    41c0: 66 0f 7f 85 d0 fe ff ff      	movdqa	%xmm0, -0x130(%rbp)
    41c8: f3 0f 6f 56 10               	movdqu	0x10(%rsi), %xmm2
    41cd: 66 0f 6f da                  	movdqa	%xmm2, %xmm3
    41d1: 66 0f 68 d9                  	punpckhbw	%xmm1, %xmm3    # xmm3 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
    41d5: f2 0f 70 db 1b               	pshuflw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[3,2,1,0,4,5,6,7]
    41da: f3 0f 70 db 1b               	pshufhw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[0,1,2,3,7,6,5,4]
    41df: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    # xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    41e3: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
    41e8: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
    41ed: 66 0f 67 d3                  	packuswb	%xmm3, %xmm2
    41f1: 66 0f 7f 95 e0 fe ff ff      	movdqa	%xmm2, -0x120(%rbp)
    41f9: f3 0f 6f 56 20               	movdqu	0x20(%rsi), %xmm2
    41fe: 66 0f 6f da                  	movdqa	%xmm2, %xmm3
    4202: 66 0f 68 d9                  	punpckhbw	%xmm1, %xmm3    # xmm3 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
    4206: f2 0f 70 db 1b               	pshuflw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[3,2,1,0,4,5,6,7]
    420b: f3 0f 70 db 1b               	pshufhw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[0,1,2,3,7,6,5,4]
    4210: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    # xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    4214: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
    4219: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
    421e: 66 0f 67 d3                  	packuswb	%xmm3, %xmm2
    4222: 66 0f 7f 95 f0 fe ff ff      	movdqa	%xmm2, -0x110(%rbp)
    422a: f3 0f 6f 56 30               	movdqu	0x30(%rsi), %xmm2
    422f: 66 0f 6f da                  	movdqa	%xmm2, %xmm3
    4233: 66 0f 68 d9                  	punpckhbw	%xmm1, %xmm3    # xmm3 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
    4237: f2 0f 70 db 1b               	pshuflw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[3,2,1,0,4,5,6,7]
    423c: f3 0f 70 db 1b               	pshufhw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[0,1,2,3,7,6,5,4]
    4241: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    # xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    4245: f2 0f 70 ca 1b               	pshuflw	$0x1b, %xmm2, %xmm1     # xmm1 = xmm2[3,2,1,0,4,5,6,7]
    424a: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
    424f: 66 0f 67 cb                  	packuswb	%xmm3, %xmm1
    4253: 66 0f 7f 8d 00 ff ff ff      	movdqa	%xmm1, -0x100(%rbp)
    425b: b8 10 00 00 00               	movl	$0x10, %eax
<L0>:
    4260: 8b 8c 85 94 fe ff ff         	movl	-0x16c(%rbp,%rax,4), %ecx
    4267: 8b 94 85 b4 fe ff ff         	movl	-0x14c(%rbp,%rax,4), %edx
    426e: 03 94 85 90 fe ff ff         	addl	-0x170(%rbp,%rax,4), %edx
    4275: 89 ce                        	movl	%ecx, %esi
    4277: c1 c6 19                     	roll	$0x19, %esi
    427a: 41 89 c8                     	movl	%ecx, %r8d
    427d: 41 c1 c0 0e                  	roll	$0xe, %r8d
    4281: 41 31 f0                     	xorl	%esi, %r8d
    4284: c1 e9 03                     	shrl	$0x3, %ecx
    4287: 8b b4 85 c8 fe ff ff         	movl	-0x138(%rbp,%rax,4), %esi
    428e: 41 89 f1                     	movl	%esi, %r9d
    4291: 41 c1 c1 0f                  	roll	$0xf, %r9d
    4295: 44 31 c1                     	xorl	%r8d, %ecx
    4298: 41 89 f0                     	movl	%esi, %r8d
    429b: 41 c1 c0 0d                  	roll	$0xd, %r8d
    429f: 01 d1                        	addl	%edx, %ecx
    42a1: 45 31 c8                     	xorl	%r9d, %r8d
    42a4: c1 ee 0a                     	shrl	$0xa, %esi
    42a7: 44 31 c6                     	xorl	%r8d, %esi
    42aa: 01 ce                        	addl	%ecx, %esi
    42ac: 89 b4 85 d0 fe ff ff         	movl	%esi, -0x130(%rbp,%rax,4)
    42b3: 48 83 c0 01                  	addq	$0x1, %rax
    42b7: 48 83 f8 40                  	cmpq	$0x40, %rax
    42bb: 75 a3                        	jne	 <L0>
    42bd: 44 8b 07                     	movl	(%rdi), %r8d
    42c0: 8b 5f 04                     	movl	0x4(%rdi), %ebx
    42c3: 44 8b 57 08                  	movl	0x8(%rdi), %r10d
    42c7: 44 8b 5f 10                  	movl	0x10(%rdi), %r11d
    42cb: 8b 4f 14                     	movl	0x14(%rdi), %ecx
    42ce: 8b 77 18                     	movl	0x18(%rdi), %esi
    42d1: 44 89 d8                     	movl	%r11d, %eax
    42d4: c1 c0 1a                     	roll	$0x1a, %eax
    42d7: 44 89 da                     	movl	%r11d, %edx
    42da: c1 c2 15                     	roll	$0x15, %edx
    42dd: 31 c2                        	xorl	%eax, %edx
    42df: 44 89 d8                     	movl	%r11d, %eax
    42e2: c1 c0 07                     	roll	$0x7, %eax
    42e5: 31 d0                        	xorl	%edx, %eax
    42e7: 89 f2                        	movl	%esi, %edx
    42e9: 31 ca                        	xorl	%ecx, %edx
    42eb: 44 21 da                     	andl	%r11d, %edx
    42ee: 03 47 1c                     	addl	0x1c(%rdi), %eax
    42f1: 31 f2                        	xorl	%esi, %edx
    42f3: 66 41 0f 7e c1               	movd	%xmm0, %r9d
    42f8: 41 01 c1                     	addl	%eax, %r9d
    42fb: 46 8d 34 0a                  	leal	(%rdx,%r9), %r14d
    42ff: 41 81 c6 98 2f 8a 42         	addl	$0x428a2f98, %r14d      # imm = 0x428A2F98
    4306: 8b 57 0c                     	movl	0xc(%rdi), %edx
    4309: 44 89 c0                     	movl	%r8d, %eax
    430c: c1 c0 1e                     	roll	$0x1e, %eax
    430f: 44 01 f2                     	addl	%r14d, %edx
    4312: 45 89 c1                     	movl	%r8d, %r9d
    4315: 41 c1 c1 13                  	roll	$0x13, %r9d
    4319: 41 31 c1                     	xorl	%eax, %r9d
    431c: 45 89 c7                     	movl	%r8d, %r15d
    431f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4323: 45 31 cf                     	xorl	%r9d, %r15d
    4326: 41 89 d1                     	movl	%edx, %r9d
    4329: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    432d: 44 89 d0                     	movl	%r10d, %eax
    4330: 41 89 d5                     	movl	%edx, %r13d
    4333: 41 c1 c5 15                  	roll	$0x15, %r13d
    4337: 45 31 cd                     	xorl	%r9d, %r13d
    433a: 41 89 d4                     	movl	%edx, %r12d
    433d: 41 c1 c4 07                  	roll	$0x7, %r12d
    4341: 45 31 ec                     	xorl	%r13d, %r12d
    4344: 41 89 c9                     	movl	%ecx, %r9d
    4347: 45 31 d9                     	xorl	%r11d, %r9d
    434a: 41 21 d1                     	andl	%edx, %r9d
    434d: 41 31 c9                     	xorl	%ecx, %r9d
    4350: 03 b5 d4 fe ff ff            	addl	-0x12c(%rbp), %esi
    4356: 44 01 ce                     	addl	%r9d, %esi
    4359: 46 8d 0c 26                  	leal	(%rsi,%r12), %r9d
    435d: 45 01 d1                     	addl	%r10d, %r9d
    4360: 41 81 c1 91 44 37 71         	addl	$0x71374491, %r9d       # imm = 0x71374491
    4367: 41 09 da                     	orl	%ebx, %r10d
    436a: 45 21 c2                     	andl	%r8d, %r10d
    436d: 21 d8                        	andl	%ebx, %eax
    436f: 44 09 d0                     	orl	%r10d, %eax
    4372: 44 01 f8                     	addl	%r15d, %eax
    4375: 44 01 f0                     	addl	%r14d, %eax
    4378: 41 89 c2                     	movl	%eax, %r10d
    437b: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    437f: 45 8d 34 34                  	leal	(%r12,%rsi), %r14d
    4383: 41 81 c6 91 44 37 71         	addl	$0x71374491, %r14d      # imm = 0x71374491
    438a: 89 c6                        	movl	%eax, %esi
    438c: c1 c6 13                     	roll	$0x13, %esi
    438f: 44 31 d6                     	xorl	%r10d, %esi
    4392: 41 89 c7                     	movl	%eax, %r15d
    4395: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4399: 41 31 f7                     	xorl	%esi, %r15d
    439c: 45 89 ca                     	movl	%r9d, %r10d
    439f: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    43a3: 89 de                        	movl	%ebx, %esi
    43a5: 45 89 cd                     	movl	%r9d, %r13d
    43a8: 41 c1 c5 15                  	roll	$0x15, %r13d
    43ac: 45 31 d5                     	xorl	%r10d, %r13d
    43af: 45 89 cc                     	movl	%r9d, %r12d
    43b2: 41 c1 c4 07                  	roll	$0x7, %r12d
    43b6: 45 31 ec                     	xorl	%r13d, %r12d
    43b9: 41 89 d2                     	movl	%edx, %r10d
    43bc: 45 31 da                     	xorl	%r11d, %r10d
    43bf: 45 21 ca                     	andl	%r9d, %r10d
    43c2: 45 31 da                     	xorl	%r11d, %r10d
    43c5: 03 8d d8 fe ff ff            	addl	-0x128(%rbp), %ecx
    43cb: 44 01 d1                     	addl	%r10d, %ecx
    43ce: 46 8d 14 21                  	leal	(%rcx,%r12), %r10d
    43d2: 41 01 da                     	addl	%ebx, %r10d
    43d5: 41 81 c2 cf fb c0 b5         	addl	$0xb5c0fbcf, %r10d      # imm = 0xB5C0FBCF
    43dc: 44 09 c3                     	orl	%r8d, %ebx
    43df: 21 c3                        	andl	%eax, %ebx
    43e1: 44 21 c6                     	andl	%r8d, %esi
    43e4: 09 de                        	orl	%ebx, %esi
    43e6: 44 01 fe                     	addl	%r15d, %esi
    43e9: 44 01 f6                     	addl	%r14d, %esi
    43ec: 89 f3                        	movl	%esi, %ebx
    43ee: c1 c3 1e                     	roll	$0x1e, %ebx
    43f1: 45 8d 34 0c                  	leal	(%r12,%rcx), %r14d
    43f5: 41 81 c6 cf fb c0 b5         	addl	$0xb5c0fbcf, %r14d      # imm = 0xB5C0FBCF
    43fc: 89 f1                        	movl	%esi, %ecx
    43fe: c1 c1 13                     	roll	$0x13, %ecx
    4401: 31 d9                        	xorl	%ebx, %ecx
    4403: 89 f3                        	movl	%esi, %ebx
    4405: c1 c3 0a                     	roll	$0xa, %ebx
    4408: 31 cb                        	xorl	%ecx, %ebx
    440a: 41 89 c7                     	movl	%eax, %r15d
    440d: 45 09 c7                     	orl	%r8d, %r15d
    4410: 41 21 f7                     	andl	%esi, %r15d
    4413: 89 c1                        	movl	%eax, %ecx
    4415: 44 21 c1                     	andl	%r8d, %ecx
    4418: 44 09 f9                     	orl	%r15d, %ecx
    441b: 01 d9                        	addl	%ebx, %ecx
    441d: 44 01 f1                     	addl	%r14d, %ecx
    4420: 44 89 d3                     	movl	%r10d, %ebx
    4423: c1 c3 1a                     	roll	$0x1a, %ebx
    4426: 45 89 d6                     	movl	%r10d, %r14d
    4429: 41 c1 c6 15                  	roll	$0x15, %r14d
    442d: 41 31 de                     	xorl	%ebx, %r14d
    4430: 44 89 d3                     	movl	%r10d, %ebx
    4433: c1 c3 07                     	roll	$0x7, %ebx
    4436: 44 31 f3                     	xorl	%r14d, %ebx
    4439: 45 89 ce                     	movl	%r9d, %r14d
    443c: 41 31 d6                     	xorl	%edx, %r14d
    443f: 45 21 d6                     	andl	%r10d, %r14d
    4442: 41 31 d6                     	xorl	%edx, %r14d
    4445: 44 03 9d dc fe ff ff         	addl	-0x124(%rbp), %r11d
    444c: 45 01 f3                     	addl	%r14d, %r11d
    444f: 45 8d 34 1b                  	leal	(%r11,%rbx), %r14d
    4453: 46 8d 3c 1b                  	leal	(%rbx,%r11), %r15d
    4457: 41 81 c7 a5 db b5 e9         	addl	$0xe9b5dba5, %r15d      # imm = 0xE9B5DBA5
    445e: 41 89 cb                     	movl	%ecx, %r11d
    4461: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    4465: 43 8d 1c 30                  	leal	(%r8,%r14), %ebx
    4469: 81 c3 a5 db b5 e9            	addl	$0xe9b5dba5, %ebx       # imm = 0xE9B5DBA5
    446f: 41 89 c8                     	movl	%ecx, %r8d
    4472: 41 c1 c0 13                  	roll	$0x13, %r8d
    4476: 45 31 d8                     	xorl	%r11d, %r8d
    4479: 41 89 ce                     	movl	%ecx, %r14d
    447c: 41 c1 c6 0a                  	roll	$0xa, %r14d
    4480: 45 31 c6                     	xorl	%r8d, %r14d
    4483: 41 89 f0                     	movl	%esi, %r8d
    4486: 41 09 c0                     	orl	%eax, %r8d
    4489: 41 21 c8                     	andl	%ecx, %r8d
    448c: 41 89 f3                     	movl	%esi, %r11d
    448f: 41 21 c3                     	andl	%eax, %r11d
    4492: 45 09 c3                     	orl	%r8d, %r11d
    4495: 45 01 f3                     	addl	%r14d, %r11d
    4498: 45 01 fb                     	addl	%r15d, %r11d
    449b: 41 89 d8                     	movl	%ebx, %r8d
    449e: 41 c1 c0 1a                  	roll	$0x1a, %r8d
    44a2: 41 89 de                     	movl	%ebx, %r14d
    44a5: 41 c1 c6 15                  	roll	$0x15, %r14d
    44a9: 45 31 c6                     	xorl	%r8d, %r14d
    44ac: 41 89 d8                     	movl	%ebx, %r8d
    44af: 41 c1 c0 07                  	roll	$0x7, %r8d
    44b3: 45 31 f0                     	xorl	%r14d, %r8d
    44b6: 45 89 d6                     	movl	%r10d, %r14d
    44b9: 45 31 ce                     	xorl	%r9d, %r14d
    44bc: 41 21 de                     	andl	%ebx, %r14d
    44bf: 45 31 ce                     	xorl	%r9d, %r14d
    44c2: 03 95 e0 fe ff ff            	addl	-0x120(%rbp), %edx
    44c8: 44 01 f2                     	addl	%r14d, %edx
    44cb: 44 01 c2                     	addl	%r8d, %edx
    44ce: 81 c2 5b c2 56 39            	addl	$0x3956c25b, %edx       # imm = 0x3956C25B
    44d4: 01 d0                        	addl	%edx, %eax
    44d6: 45 89 d8                     	movl	%r11d, %r8d
    44d9: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    44dd: 45 89 de                     	movl	%r11d, %r14d
    44e0: 41 c1 c6 13                  	roll	$0x13, %r14d
    44e4: 45 31 c6                     	xorl	%r8d, %r14d
    44e7: 45 89 df                     	movl	%r11d, %r15d
    44ea: 41 c1 c7 0a                  	roll	$0xa, %r15d
    44ee: 45 31 f7                     	xorl	%r14d, %r15d
    44f1: 41 89 ce                     	movl	%ecx, %r14d
    44f4: 41 09 f6                     	orl	%esi, %r14d
    44f7: 45 21 de                     	andl	%r11d, %r14d
    44fa: 41 89 c8                     	movl	%ecx, %r8d
    44fd: 41 21 f0                     	andl	%esi, %r8d
    4500: 45 09 f0                     	orl	%r14d, %r8d
    4503: 45 01 f8                     	addl	%r15d, %r8d
    4506: 41 01 d0                     	addl	%edx, %r8d
    4509: 89 c2                        	movl	%eax, %edx
    450b: c1 c2 1a                     	roll	$0x1a, %edx
    450e: 41 89 c6                     	movl	%eax, %r14d
    4511: 41 c1 c6 15                  	roll	$0x15, %r14d
    4515: 41 31 d6                     	xorl	%edx, %r14d
    4518: 89 c2                        	movl	%eax, %edx
    451a: c1 c2 07                     	roll	$0x7, %edx
    451d: 44 31 f2                     	xorl	%r14d, %edx
    4520: 41 89 de                     	movl	%ebx, %r14d
    4523: 45 31 d6                     	xorl	%r10d, %r14d
    4526: 41 21 c6                     	andl	%eax, %r14d
    4529: 44 03 8d e4 fe ff ff         	addl	-0x11c(%rbp), %r9d
    4530: 45 31 d6                     	xorl	%r10d, %r14d
    4533: 45 01 f1                     	addl	%r14d, %r9d
    4536: 44 01 ca                     	addl	%r9d, %edx
    4539: 81 c2 f1 11 f1 59            	addl	$0x59f111f1, %edx       # imm = 0x59F111F1
    453f: 01 d6                        	addl	%edx, %esi
    4541: 45 89 c1                     	movl	%r8d, %r9d
    4544: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4548: 45 89 c6                     	movl	%r8d, %r14d
    454b: 41 c1 c6 13                  	roll	$0x13, %r14d
    454f: 45 31 ce                     	xorl	%r9d, %r14d
    4552: 45 89 c7                     	movl	%r8d, %r15d
    4555: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4559: 45 31 f7                     	xorl	%r14d, %r15d
    455c: 45 89 de                     	movl	%r11d, %r14d
    455f: 41 09 ce                     	orl	%ecx, %r14d
    4562: 45 21 c6                     	andl	%r8d, %r14d
    4565: 45 89 d9                     	movl	%r11d, %r9d
    4568: 41 21 c9                     	andl	%ecx, %r9d
    456b: 45 09 f1                     	orl	%r14d, %r9d
    456e: 41 89 f6                     	movl	%esi, %r14d
    4571: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4575: 45 01 f9                     	addl	%r15d, %r9d
    4578: 41 89 f7                     	movl	%esi, %r15d
    457b: 41 c1 c7 15                  	roll	$0x15, %r15d
    457f: 41 01 d1                     	addl	%edx, %r9d
    4582: 89 f2                        	movl	%esi, %edx
    4584: c1 c2 07                     	roll	$0x7, %edx
    4587: 45 31 f7                     	xorl	%r14d, %r15d
    458a: 44 31 fa                     	xorl	%r15d, %edx
    458d: 41 89 c6                     	movl	%eax, %r14d
    4590: 41 31 de                     	xorl	%ebx, %r14d
    4593: 41 21 f6                     	andl	%esi, %r14d
    4596: 41 31 de                     	xorl	%ebx, %r14d
    4599: 44 03 95 e8 fe ff ff         	addl	-0x118(%rbp), %r10d
    45a0: 45 01 f2                     	addl	%r14d, %r10d
    45a3: 45 89 ce                     	movl	%r9d, %r14d
    45a6: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    45aa: 41 01 d2                     	addl	%edx, %r10d
    45ad: 41 81 c2 a4 82 3f 92         	addl	$0x923f82a4, %r10d      # imm = 0x923F82A4
    45b4: 44 89 ca                     	movl	%r9d, %edx
    45b7: c1 c2 13                     	roll	$0x13, %edx
    45ba: 44 01 d1                     	addl	%r10d, %ecx
    45bd: 45 89 cf                     	movl	%r9d, %r15d
    45c0: 41 c1 c7 0a                  	roll	$0xa, %r15d
    45c4: 44 31 f2                     	xorl	%r14d, %edx
    45c7: 41 31 d7                     	xorl	%edx, %r15d
    45ca: 45 89 c6                     	movl	%r8d, %r14d
    45cd: 45 09 de                     	orl	%r11d, %r14d
    45d0: 45 21 ce                     	andl	%r9d, %r14d
    45d3: 44 89 c2                     	movl	%r8d, %edx
    45d6: 44 21 da                     	andl	%r11d, %edx
    45d9: 44 09 f2                     	orl	%r14d, %edx
    45dc: 44 01 fa                     	addl	%r15d, %edx
    45df: 41 89 ce                     	movl	%ecx, %r14d
    45e2: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    45e6: 44 01 d2                     	addl	%r10d, %edx
    45e9: 41 89 ca                     	movl	%ecx, %r10d
    45ec: 41 c1 c2 15                  	roll	$0x15, %r10d
    45f0: 45 31 f2                     	xorl	%r14d, %r10d
    45f3: 41 89 ce                     	movl	%ecx, %r14d
    45f6: 41 c1 c6 07                  	roll	$0x7, %r14d
    45fa: 45 31 d6                     	xorl	%r10d, %r14d
    45fd: 41 89 f2                     	movl	%esi, %r10d
    4600: 41 31 c2                     	xorl	%eax, %r10d
    4603: 41 21 ca                     	andl	%ecx, %r10d
    4606: 41 31 c2                     	xorl	%eax, %r10d
    4609: 03 9d ec fe ff ff            	addl	-0x114(%rbp), %ebx
    460f: 44 01 d3                     	addl	%r10d, %ebx
    4612: 45 8d 14 1e                  	leal	(%r14,%rbx), %r10d
    4616: 41 81 c2 d5 5e 1c ab         	addl	$0xab1c5ed5, %r10d      # imm = 0xAB1C5ED5
    461d: 89 d3                        	movl	%edx, %ebx
    461f: c1 c3 1e                     	roll	$0x1e, %ebx
    4622: 45 01 d3                     	addl	%r10d, %r11d
    4625: 41 89 d6                     	movl	%edx, %r14d
    4628: 41 c1 c6 13                  	roll	$0x13, %r14d
    462c: 41 31 de                     	xorl	%ebx, %r14d
    462f: 41 89 d7                     	movl	%edx, %r15d
    4632: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4636: 45 31 f7                     	xorl	%r14d, %r15d
    4639: 45 89 ce                     	movl	%r9d, %r14d
    463c: 45 09 c6                     	orl	%r8d, %r14d
    463f: 41 21 d6                     	andl	%edx, %r14d
    4642: 44 89 cb                     	movl	%r9d, %ebx
    4645: 44 21 c3                     	andl	%r8d, %ebx
    4648: 44 09 f3                     	orl	%r14d, %ebx
    464b: 44 01 fb                     	addl	%r15d, %ebx
    464e: 44 01 d3                     	addl	%r10d, %ebx
    4651: 45 89 da                     	movl	%r11d, %r10d
    4654: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    4658: 45 89 de                     	movl	%r11d, %r14d
    465b: 41 c1 c6 15                  	roll	$0x15, %r14d
    465f: 45 31 d6                     	xorl	%r10d, %r14d
    4662: 45 89 da                     	movl	%r11d, %r10d
    4665: 41 c1 c2 07                  	roll	$0x7, %r10d
    4669: 45 31 f2                     	xorl	%r14d, %r10d
    466c: 41 89 ce                     	movl	%ecx, %r14d
    466f: 41 31 f6                     	xorl	%esi, %r14d
    4672: 45 21 de                     	andl	%r11d, %r14d
    4675: 41 31 f6                     	xorl	%esi, %r14d
    4678: 03 85 f0 fe ff ff            	addl	-0x110(%rbp), %eax
    467e: 44 01 f0                     	addl	%r14d, %eax
    4681: 44 01 d0                     	addl	%r10d, %eax
    4684: 05 98 aa 07 d8               	addl	$0xd807aa98, %eax       # imm = 0xD807AA98
    4689: 41 01 c0                     	addl	%eax, %r8d
    468c: 41 89 da                     	movl	%ebx, %r10d
    468f: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4693: 41 89 de                     	movl	%ebx, %r14d
    4696: 41 c1 c6 13                  	roll	$0x13, %r14d
    469a: 45 31 d6                     	xorl	%r10d, %r14d
    469d: 41 89 df                     	movl	%ebx, %r15d
    46a0: 41 c1 c7 0a                  	roll	$0xa, %r15d
    46a4: 45 31 f7                     	xorl	%r14d, %r15d
    46a7: 41 89 d6                     	movl	%edx, %r14d
    46aa: 45 09 ce                     	orl	%r9d, %r14d
    46ad: 41 21 de                     	andl	%ebx, %r14d
    46b0: 41 89 d2                     	movl	%edx, %r10d
    46b3: 45 21 ca                     	andl	%r9d, %r10d
    46b6: 45 09 f2                     	orl	%r14d, %r10d
    46b9: 45 01 fa                     	addl	%r15d, %r10d
    46bc: 41 01 c2                     	addl	%eax, %r10d
    46bf: 44 89 c0                     	movl	%r8d, %eax
    46c2: c1 c0 1a                     	roll	$0x1a, %eax
    46c5: 45 89 c6                     	movl	%r8d, %r14d
    46c8: 41 c1 c6 15                  	roll	$0x15, %r14d
    46cc: 41 31 c6                     	xorl	%eax, %r14d
    46cf: 44 89 c0                     	movl	%r8d, %eax
    46d2: c1 c0 07                     	roll	$0x7, %eax
    46d5: 44 31 f0                     	xorl	%r14d, %eax
    46d8: 45 89 de                     	movl	%r11d, %r14d
    46db: 41 31 ce                     	xorl	%ecx, %r14d
    46de: 45 21 c6                     	andl	%r8d, %r14d
    46e1: 03 b5 f4 fe ff ff            	addl	-0x10c(%rbp), %esi
    46e7: 41 31 ce                     	xorl	%ecx, %r14d
    46ea: 44 01 f6                     	addl	%r14d, %esi
    46ed: 01 f0                        	addl	%esi, %eax
    46ef: 05 01 5b 83 12               	addl	$0x12835b01, %eax       # imm = 0x12835B01
    46f4: 41 01 c1                     	addl	%eax, %r9d
    46f7: 44 89 d6                     	movl	%r10d, %esi
    46fa: c1 c6 1e                     	roll	$0x1e, %esi
    46fd: 45 89 d6                     	movl	%r10d, %r14d
    4700: 41 c1 c6 13                  	roll	$0x13, %r14d
    4704: 41 31 f6                     	xorl	%esi, %r14d
    4707: 45 89 d7                     	movl	%r10d, %r15d
    470a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    470e: 45 31 f7                     	xorl	%r14d, %r15d
    4711: 41 89 de                     	movl	%ebx, %r14d
    4714: 41 09 d6                     	orl	%edx, %r14d
    4717: 45 21 d6                     	andl	%r10d, %r14d
    471a: 89 de                        	movl	%ebx, %esi
    471c: 21 d6                        	andl	%edx, %esi
    471e: 44 09 f6                     	orl	%r14d, %esi
    4721: 45 89 ce                     	movl	%r9d, %r14d
    4724: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4728: 44 01 fe                     	addl	%r15d, %esi
    472b: 45 89 cf                     	movl	%r9d, %r15d
    472e: 41 c1 c7 15                  	roll	$0x15, %r15d
    4732: 01 c6                        	addl	%eax, %esi
    4734: 44 89 c8                     	movl	%r9d, %eax
    4737: c1 c0 07                     	roll	$0x7, %eax
    473a: 45 31 f7                     	xorl	%r14d, %r15d
    473d: 44 31 f8                     	xorl	%r15d, %eax
    4740: 45 89 c6                     	movl	%r8d, %r14d
    4743: 45 31 de                     	xorl	%r11d, %r14d
    4746: 45 21 ce                     	andl	%r9d, %r14d
    4749: 45 31 de                     	xorl	%r11d, %r14d
    474c: 03 8d f8 fe ff ff            	addl	-0x108(%rbp), %ecx
    4752: 44 01 f1                     	addl	%r14d, %ecx
    4755: 41 89 f6                     	movl	%esi, %r14d
    4758: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    475c: 01 c1                        	addl	%eax, %ecx
    475e: 81 c1 be 85 31 24            	addl	$0x243185be, %ecx       # imm = 0x243185BE
    4764: 89 f0                        	movl	%esi, %eax
    4766: c1 c0 13                     	roll	$0x13, %eax
    4769: 01 ca                        	addl	%ecx, %edx
    476b: 41 89 f7                     	movl	%esi, %r15d
    476e: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4772: 44 31 f0                     	xorl	%r14d, %eax
    4775: 41 31 c7                     	xorl	%eax, %r15d
    4778: 45 89 d6                     	movl	%r10d, %r14d
    477b: 41 09 de                     	orl	%ebx, %r14d
    477e: 41 21 f6                     	andl	%esi, %r14d
    4781: 44 89 d0                     	movl	%r10d, %eax
    4784: 21 d8                        	andl	%ebx, %eax
    4786: 44 09 f0                     	orl	%r14d, %eax
    4789: 44 01 f8                     	addl	%r15d, %eax
    478c: 41 89 d6                     	movl	%edx, %r14d
    478f: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4793: 01 c8                        	addl	%ecx, %eax
    4795: 89 d1                        	movl	%edx, %ecx
    4797: c1 c1 15                     	roll	$0x15, %ecx
    479a: 44 31 f1                     	xorl	%r14d, %ecx
    479d: 41 89 d6                     	movl	%edx, %r14d
    47a0: 41 c1 c6 07                  	roll	$0x7, %r14d
    47a4: 41 31 ce                     	xorl	%ecx, %r14d
    47a7: 44 89 c9                     	movl	%r9d, %ecx
    47aa: 44 31 c1                     	xorl	%r8d, %ecx
    47ad: 21 d1                        	andl	%edx, %ecx
    47af: 44 31 c1                     	xorl	%r8d, %ecx
    47b2: 44 03 9d fc fe ff ff         	addl	-0x104(%rbp), %r11d
    47b9: 41 01 cb                     	addl	%ecx, %r11d
    47bc: 43 8d 0c 1e                  	leal	(%r14,%r11), %ecx
    47c0: 81 c1 c3 7d 0c 55            	addl	$0x550c7dc3, %ecx       # imm = 0x550C7DC3
    47c6: 41 89 c3                     	movl	%eax, %r11d
    47c9: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    47cd: 01 cb                        	addl	%ecx, %ebx
    47cf: 41 89 c6                     	movl	%eax, %r14d
    47d2: 41 c1 c6 13                  	roll	$0x13, %r14d
    47d6: 45 31 de                     	xorl	%r11d, %r14d
    47d9: 41 89 c7                     	movl	%eax, %r15d
    47dc: 41 c1 c7 0a                  	roll	$0xa, %r15d
    47e0: 45 31 f7                     	xorl	%r14d, %r15d
    47e3: 41 89 f6                     	movl	%esi, %r14d
    47e6: 45 09 d6                     	orl	%r10d, %r14d
    47e9: 41 21 c6                     	andl	%eax, %r14d
    47ec: 41 89 f3                     	movl	%esi, %r11d
    47ef: 45 21 d3                     	andl	%r10d, %r11d
    47f2: 45 09 f3                     	orl	%r14d, %r11d
    47f5: 45 01 fb                     	addl	%r15d, %r11d
    47f8: 41 01 cb                     	addl	%ecx, %r11d
    47fb: 89 d9                        	movl	%ebx, %ecx
    47fd: c1 c1 1a                     	roll	$0x1a, %ecx
    4800: 41 89 de                     	movl	%ebx, %r14d
    4803: 41 c1 c6 15                  	roll	$0x15, %r14d
    4807: 41 31 ce                     	xorl	%ecx, %r14d
    480a: 89 d9                        	movl	%ebx, %ecx
    480c: c1 c1 07                     	roll	$0x7, %ecx
    480f: 44 31 f1                     	xorl	%r14d, %ecx
    4812: 41 89 d6                     	movl	%edx, %r14d
    4815: 45 31 ce                     	xorl	%r9d, %r14d
    4818: 41 21 de                     	andl	%ebx, %r14d
    481b: 45 31 ce                     	xorl	%r9d, %r14d
    481e: 44 03 85 00 ff ff ff         	addl	-0x100(%rbp), %r8d
    4825: 45 01 f0                     	addl	%r14d, %r8d
    4828: 44 01 c1                     	addl	%r8d, %ecx
    482b: 81 c1 74 5d be 72            	addl	$0x72be5d74, %ecx       # imm = 0x72BE5D74
    4831: 41 01 ca                     	addl	%ecx, %r10d
    4834: 45 89 d8                     	movl	%r11d, %r8d
    4837: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    483b: 45 89 de                     	movl	%r11d, %r14d
    483e: 41 c1 c6 13                  	roll	$0x13, %r14d
    4842: 45 31 c6                     	xorl	%r8d, %r14d
    4845: 45 89 df                     	movl	%r11d, %r15d
    4848: 41 c1 c7 0a                  	roll	$0xa, %r15d
    484c: 45 31 f7                     	xorl	%r14d, %r15d
    484f: 41 89 c6                     	movl	%eax, %r14d
    4852: 41 09 f6                     	orl	%esi, %r14d
    4855: 45 21 de                     	andl	%r11d, %r14d
    4858: 41 89 c0                     	movl	%eax, %r8d
    485b: 41 21 f0                     	andl	%esi, %r8d
    485e: 45 09 f0                     	orl	%r14d, %r8d
    4861: 45 01 f8                     	addl	%r15d, %r8d
    4864: 41 01 c8                     	addl	%ecx, %r8d
    4867: 44 89 d1                     	movl	%r10d, %ecx
    486a: c1 c1 1a                     	roll	$0x1a, %ecx
    486d: 45 89 d6                     	movl	%r10d, %r14d
    4870: 41 c1 c6 15                  	roll	$0x15, %r14d
    4874: 41 31 ce                     	xorl	%ecx, %r14d
    4877: 44 89 d1                     	movl	%r10d, %ecx
    487a: c1 c1 07                     	roll	$0x7, %ecx
    487d: 44 31 f1                     	xorl	%r14d, %ecx
    4880: 41 89 de                     	movl	%ebx, %r14d
    4883: 41 31 d6                     	xorl	%edx, %r14d
    4886: 45 21 d6                     	andl	%r10d, %r14d
    4889: 44 03 8d 04 ff ff ff         	addl	-0xfc(%rbp), %r9d
    4890: 41 31 d6                     	xorl	%edx, %r14d
    4893: 45 01 f1                     	addl	%r14d, %r9d
    4896: 44 01 c9                     	addl	%r9d, %ecx
    4899: 81 c1 fe b1 de 80            	addl	$0x80deb1fe, %ecx       # imm = 0x80DEB1FE
    489f: 01 ce                        	addl	%ecx, %esi
    48a1: 45 89 c1                     	movl	%r8d, %r9d
    48a4: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    48a8: 45 89 c6                     	movl	%r8d, %r14d
    48ab: 41 c1 c6 13                  	roll	$0x13, %r14d
    48af: 45 31 ce                     	xorl	%r9d, %r14d
    48b2: 45 89 c7                     	movl	%r8d, %r15d
    48b5: 41 c1 c7 0a                  	roll	$0xa, %r15d
    48b9: 45 31 f7                     	xorl	%r14d, %r15d
    48bc: 45 89 de                     	movl	%r11d, %r14d
    48bf: 41 09 c6                     	orl	%eax, %r14d
    48c2: 45 21 c6                     	andl	%r8d, %r14d
    48c5: 45 89 d9                     	movl	%r11d, %r9d
    48c8: 41 21 c1                     	andl	%eax, %r9d
    48cb: 45 09 f1                     	orl	%r14d, %r9d
    48ce: 41 89 f6                     	movl	%esi, %r14d
    48d1: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    48d5: 45 01 f9                     	addl	%r15d, %r9d
    48d8: 41 89 f7                     	movl	%esi, %r15d
    48db: 41 c1 c7 15                  	roll	$0x15, %r15d
    48df: 41 01 c9                     	addl	%ecx, %r9d
    48e2: 89 f1                        	movl	%esi, %ecx
    48e4: c1 c1 07                     	roll	$0x7, %ecx
    48e7: 45 31 f7                     	xorl	%r14d, %r15d
    48ea: 44 31 f9                     	xorl	%r15d, %ecx
    48ed: 45 89 d6                     	movl	%r10d, %r14d
    48f0: 41 31 de                     	xorl	%ebx, %r14d
    48f3: 41 21 f6                     	andl	%esi, %r14d
    48f6: 41 31 de                     	xorl	%ebx, %r14d
    48f9: 03 95 08 ff ff ff            	addl	-0xf8(%rbp), %edx
    48ff: 44 01 f2                     	addl	%r14d, %edx
    4902: 45 89 ce                     	movl	%r9d, %r14d
    4905: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4909: 01 ca                        	addl	%ecx, %edx
    490b: 81 c2 a7 06 dc 9b            	addl	$0x9bdc06a7, %edx       # imm = 0x9BDC06A7
    4911: 44 89 c9                     	movl	%r9d, %ecx
    4914: c1 c1 13                     	roll	$0x13, %ecx
    4917: 01 d0                        	addl	%edx, %eax
    4919: 45 89 cf                     	movl	%r9d, %r15d
    491c: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4920: 44 31 f1                     	xorl	%r14d, %ecx
    4923: 41 31 cf                     	xorl	%ecx, %r15d
    4926: 45 89 c6                     	movl	%r8d, %r14d
    4929: 45 09 de                     	orl	%r11d, %r14d
    492c: 45 21 ce                     	andl	%r9d, %r14d
    492f: 44 89 c1                     	movl	%r8d, %ecx
    4932: 44 21 d9                     	andl	%r11d, %ecx
    4935: 44 09 f1                     	orl	%r14d, %ecx
    4938: 44 01 f9                     	addl	%r15d, %ecx
    493b: 41 89 c6                     	movl	%eax, %r14d
    493e: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4942: 01 d1                        	addl	%edx, %ecx
    4944: 89 c2                        	movl	%eax, %edx
    4946: c1 c2 15                     	roll	$0x15, %edx
    4949: 44 31 f2                     	xorl	%r14d, %edx
    494c: 41 89 c6                     	movl	%eax, %r14d
    494f: 41 c1 c6 07                  	roll	$0x7, %r14d
    4953: 41 31 d6                     	xorl	%edx, %r14d
    4956: 89 f2                        	movl	%esi, %edx
    4958: 44 31 d2                     	xorl	%r10d, %edx
    495b: 21 c2                        	andl	%eax, %edx
    495d: 44 31 d2                     	xorl	%r10d, %edx
    4960: 03 9d 0c ff ff ff            	addl	-0xf4(%rbp), %ebx
    4966: 01 d3                        	addl	%edx, %ebx
    4968: 41 8d 14 1e                  	leal	(%r14,%rbx), %edx
    496c: 81 c2 74 f1 9b c1            	addl	$0xc19bf174, %edx       # imm = 0xC19BF174
    4972: 89 cb                        	movl	%ecx, %ebx
    4974: c1 c3 1e                     	roll	$0x1e, %ebx
    4977: 41 01 d3                     	addl	%edx, %r11d
    497a: 41 89 ce                     	movl	%ecx, %r14d
    497d: 41 c1 c6 13                  	roll	$0x13, %r14d
    4981: 41 31 de                     	xorl	%ebx, %r14d
    4984: 41 89 cf                     	movl	%ecx, %r15d
    4987: 41 c1 c7 0a                  	roll	$0xa, %r15d
    498b: 45 31 f7                     	xorl	%r14d, %r15d
    498e: 45 89 ce                     	movl	%r9d, %r14d
    4991: 45 09 c6                     	orl	%r8d, %r14d
    4994: 41 21 ce                     	andl	%ecx, %r14d
    4997: 44 89 cb                     	movl	%r9d, %ebx
    499a: 44 21 c3                     	andl	%r8d, %ebx
    499d: 44 09 f3                     	orl	%r14d, %ebx
    49a0: 44 01 fb                     	addl	%r15d, %ebx
    49a3: 01 d3                        	addl	%edx, %ebx
    49a5: 44 89 da                     	movl	%r11d, %edx
    49a8: c1 c2 1a                     	roll	$0x1a, %edx
    49ab: 45 89 de                     	movl	%r11d, %r14d
    49ae: 41 c1 c6 15                  	roll	$0x15, %r14d
    49b2: 41 31 d6                     	xorl	%edx, %r14d
    49b5: 44 89 da                     	movl	%r11d, %edx
    49b8: c1 c2 07                     	roll	$0x7, %edx
    49bb: 44 31 f2                     	xorl	%r14d, %edx
    49be: 41 89 c6                     	movl	%eax, %r14d
    49c1: 41 31 f6                     	xorl	%esi, %r14d
    49c4: 45 21 de                     	andl	%r11d, %r14d
    49c7: 41 31 f6                     	xorl	%esi, %r14d
    49ca: 44 03 95 10 ff ff ff         	addl	-0xf0(%rbp), %r10d
    49d1: 45 01 f2                     	addl	%r14d, %r10d
    49d4: 41 01 d2                     	addl	%edx, %r10d
    49d7: 41 81 c2 c1 69 9b e4         	addl	$0xe49b69c1, %r10d      # imm = 0xE49B69C1
    49de: 45 01 d0                     	addl	%r10d, %r8d
    49e1: 89 da                        	movl	%ebx, %edx
    49e3: c1 c2 1e                     	roll	$0x1e, %edx
    49e6: 41 89 de                     	movl	%ebx, %r14d
    49e9: 41 c1 c6 13                  	roll	$0x13, %r14d
    49ed: 41 31 d6                     	xorl	%edx, %r14d
    49f0: 41 89 df                     	movl	%ebx, %r15d
    49f3: 41 c1 c7 0a                  	roll	$0xa, %r15d
    49f7: 45 31 f7                     	xorl	%r14d, %r15d
    49fa: 41 89 ce                     	movl	%ecx, %r14d
    49fd: 45 09 ce                     	orl	%r9d, %r14d
    4a00: 41 21 de                     	andl	%ebx, %r14d
    4a03: 89 ca                        	movl	%ecx, %edx
    4a05: 44 21 ca                     	andl	%r9d, %edx
    4a08: 44 09 f2                     	orl	%r14d, %edx
    4a0b: 44 01 fa                     	addl	%r15d, %edx
    4a0e: 44 01 d2                     	addl	%r10d, %edx
    4a11: 45 89 c2                     	movl	%r8d, %r10d
    4a14: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    4a18: 45 89 c6                     	movl	%r8d, %r14d
    4a1b: 41 c1 c6 15                  	roll	$0x15, %r14d
    4a1f: 45 31 d6                     	xorl	%r10d, %r14d
    4a22: 45 89 c2                     	movl	%r8d, %r10d
    4a25: 41 c1 c2 07                  	roll	$0x7, %r10d
    4a29: 45 31 f2                     	xorl	%r14d, %r10d
    4a2c: 45 89 de                     	movl	%r11d, %r14d
    4a2f: 41 31 c6                     	xorl	%eax, %r14d
    4a32: 45 21 c6                     	andl	%r8d, %r14d
    4a35: 03 b5 14 ff ff ff            	addl	-0xec(%rbp), %esi
    4a3b: 41 31 c6                     	xorl	%eax, %r14d
    4a3e: 44 01 f6                     	addl	%r14d, %esi
    4a41: 41 01 f2                     	addl	%esi, %r10d
    4a44: 41 81 c2 86 47 be ef         	addl	$0xefbe4786, %r10d      # imm = 0xEFBE4786
    4a4b: 45 01 d1                     	addl	%r10d, %r9d
    4a4e: 89 d6                        	movl	%edx, %esi
    4a50: c1 c6 1e                     	roll	$0x1e, %esi
    4a53: 41 89 d6                     	movl	%edx, %r14d
    4a56: 41 c1 c6 13                  	roll	$0x13, %r14d
    4a5a: 41 31 f6                     	xorl	%esi, %r14d
    4a5d: 41 89 d7                     	movl	%edx, %r15d
    4a60: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4a64: 45 31 f7                     	xorl	%r14d, %r15d
    4a67: 41 89 de                     	movl	%ebx, %r14d
    4a6a: 41 09 ce                     	orl	%ecx, %r14d
    4a6d: 41 21 d6                     	andl	%edx, %r14d
    4a70: 89 de                        	movl	%ebx, %esi
    4a72: 21 ce                        	andl	%ecx, %esi
    4a74: 44 09 f6                     	orl	%r14d, %esi
    4a77: 45 89 ce                     	movl	%r9d, %r14d
    4a7a: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4a7e: 44 01 fe                     	addl	%r15d, %esi
    4a81: 45 89 cf                     	movl	%r9d, %r15d
    4a84: 41 c1 c7 15                  	roll	$0x15, %r15d
    4a88: 44 01 d6                     	addl	%r10d, %esi
    4a8b: 45 89 ca                     	movl	%r9d, %r10d
    4a8e: 41 c1 c2 07                  	roll	$0x7, %r10d
    4a92: 45 31 f7                     	xorl	%r14d, %r15d
    4a95: 45 31 fa                     	xorl	%r15d, %r10d
    4a98: 45 89 c6                     	movl	%r8d, %r14d
    4a9b: 45 31 de                     	xorl	%r11d, %r14d
    4a9e: 45 21 ce                     	andl	%r9d, %r14d
    4aa1: 45 31 de                     	xorl	%r11d, %r14d
    4aa4: 03 85 18 ff ff ff            	addl	-0xe8(%rbp), %eax
    4aaa: 44 01 f0                     	addl	%r14d, %eax
    4aad: 41 89 f6                     	movl	%esi, %r14d
    4ab0: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4ab4: 41 01 c2                     	addl	%eax, %r10d
    4ab7: 41 81 c2 c6 9d c1 0f         	addl	$0xfc19dc6, %r10d       # imm = 0xFC19DC6
    4abe: 89 f0                        	movl	%esi, %eax
    4ac0: c1 c0 13                     	roll	$0x13, %eax
    4ac3: 44 01 d1                     	addl	%r10d, %ecx
    4ac6: 41 89 f7                     	movl	%esi, %r15d
    4ac9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4acd: 44 31 f0                     	xorl	%r14d, %eax
    4ad0: 41 31 c7                     	xorl	%eax, %r15d
    4ad3: 41 89 d6                     	movl	%edx, %r14d
    4ad6: 41 09 de                     	orl	%ebx, %r14d
    4ad9: 41 21 f6                     	andl	%esi, %r14d
    4adc: 89 d0                        	movl	%edx, %eax
    4ade: 21 d8                        	andl	%ebx, %eax
    4ae0: 44 09 f0                     	orl	%r14d, %eax
    4ae3: 44 01 f8                     	addl	%r15d, %eax
    4ae6: 41 89 ce                     	movl	%ecx, %r14d
    4ae9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4aed: 44 01 d0                     	addl	%r10d, %eax
    4af0: 41 89 ca                     	movl	%ecx, %r10d
    4af3: 41 c1 c2 15                  	roll	$0x15, %r10d
    4af7: 45 31 f2                     	xorl	%r14d, %r10d
    4afa: 41 89 ce                     	movl	%ecx, %r14d
    4afd: 41 c1 c6 07                  	roll	$0x7, %r14d
    4b01: 45 31 d6                     	xorl	%r10d, %r14d
    4b04: 45 89 ca                     	movl	%r9d, %r10d
    4b07: 45 31 c2                     	xorl	%r8d, %r10d
    4b0a: 41 21 ca                     	andl	%ecx, %r10d
    4b0d: 45 31 c2                     	xorl	%r8d, %r10d
    4b10: 44 03 9d 1c ff ff ff         	addl	-0xe4(%rbp), %r11d
    4b17: 45 01 d3                     	addl	%r10d, %r11d
    4b1a: 45 01 f3                     	addl	%r14d, %r11d
    4b1d: 41 81 c3 cc a1 0c 24         	addl	$0x240ca1cc, %r11d      # imm = 0x240CA1CC
    4b24: 41 89 c2                     	movl	%eax, %r10d
    4b27: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4b2b: 44 01 db                     	addl	%r11d, %ebx
    4b2e: 41 89 c6                     	movl	%eax, %r14d
    4b31: 41 c1 c6 13                  	roll	$0x13, %r14d
    4b35: 45 31 d6                     	xorl	%r10d, %r14d
    4b38: 41 89 c7                     	movl	%eax, %r15d
    4b3b: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4b3f: 45 31 f7                     	xorl	%r14d, %r15d
    4b42: 41 89 f6                     	movl	%esi, %r14d
    4b45: 41 09 d6                     	orl	%edx, %r14d
    4b48: 41 21 c6                     	andl	%eax, %r14d
    4b4b: 41 89 f2                     	movl	%esi, %r10d
    4b4e: 41 21 d2                     	andl	%edx, %r10d
    4b51: 45 09 f2                     	orl	%r14d, %r10d
    4b54: 45 01 fa                     	addl	%r15d, %r10d
    4b57: 45 01 da                     	addl	%r11d, %r10d
    4b5a: 41 89 db                     	movl	%ebx, %r11d
    4b5d: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    4b61: 41 89 de                     	movl	%ebx, %r14d
    4b64: 41 c1 c6 15                  	roll	$0x15, %r14d
    4b68: 45 31 de                     	xorl	%r11d, %r14d
    4b6b: 41 89 db                     	movl	%ebx, %r11d
    4b6e: 41 c1 c3 07                  	roll	$0x7, %r11d
    4b72: 45 31 f3                     	xorl	%r14d, %r11d
    4b75: 41 89 ce                     	movl	%ecx, %r14d
    4b78: 45 31 ce                     	xorl	%r9d, %r14d
    4b7b: 41 21 de                     	andl	%ebx, %r14d
    4b7e: 45 31 ce                     	xorl	%r9d, %r14d
    4b81: 44 03 85 20 ff ff ff         	addl	-0xe0(%rbp), %r8d
    4b88: 45 01 f0                     	addl	%r14d, %r8d
    4b8b: 45 01 c3                     	addl	%r8d, %r11d
    4b8e: 41 81 c3 6f 2c e9 2d         	addl	$0x2de92c6f, %r11d      # imm = 0x2DE92C6F
    4b95: 44 01 da                     	addl	%r11d, %edx
    4b98: 45 89 d0                     	movl	%r10d, %r8d
    4b9b: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    4b9f: 45 89 d6                     	movl	%r10d, %r14d
    4ba2: 41 c1 c6 13                  	roll	$0x13, %r14d
    4ba6: 45 31 c6                     	xorl	%r8d, %r14d
    4ba9: 45 89 d7                     	movl	%r10d, %r15d
    4bac: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4bb0: 45 31 f7                     	xorl	%r14d, %r15d
    4bb3: 41 89 c6                     	movl	%eax, %r14d
    4bb6: 41 09 f6                     	orl	%esi, %r14d
    4bb9: 45 21 d6                     	andl	%r10d, %r14d
    4bbc: 41 89 c0                     	movl	%eax, %r8d
    4bbf: 41 21 f0                     	andl	%esi, %r8d
    4bc2: 45 09 f0                     	orl	%r14d, %r8d
    4bc5: 45 01 f8                     	addl	%r15d, %r8d
    4bc8: 45 01 d8                     	addl	%r11d, %r8d
    4bcb: 41 89 d3                     	movl	%edx, %r11d
    4bce: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    4bd2: 41 89 d6                     	movl	%edx, %r14d
    4bd5: 41 c1 c6 15                  	roll	$0x15, %r14d
    4bd9: 45 31 de                     	xorl	%r11d, %r14d
    4bdc: 41 89 d3                     	movl	%edx, %r11d
    4bdf: 41 c1 c3 07                  	roll	$0x7, %r11d
    4be3: 45 31 f3                     	xorl	%r14d, %r11d
    4be6: 41 89 de                     	movl	%ebx, %r14d
    4be9: 41 31 ce                     	xorl	%ecx, %r14d
    4bec: 41 21 d6                     	andl	%edx, %r14d
    4bef: 44 03 8d 24 ff ff ff         	addl	-0xdc(%rbp), %r9d
    4bf6: 41 31 ce                     	xorl	%ecx, %r14d
    4bf9: 45 01 f1                     	addl	%r14d, %r9d
    4bfc: 45 01 cb                     	addl	%r9d, %r11d
    4bff: 41 81 c3 aa 84 74 4a         	addl	$0x4a7484aa, %r11d      # imm = 0x4A7484AA
    4c06: 44 01 de                     	addl	%r11d, %esi
    4c09: 45 89 c1                     	movl	%r8d, %r9d
    4c0c: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4c10: 45 89 c6                     	movl	%r8d, %r14d
    4c13: 41 c1 c6 13                  	roll	$0x13, %r14d
    4c17: 45 31 ce                     	xorl	%r9d, %r14d
    4c1a: 45 89 c7                     	movl	%r8d, %r15d
    4c1d: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4c21: 45 31 f7                     	xorl	%r14d, %r15d
    4c24: 45 89 d6                     	movl	%r10d, %r14d
    4c27: 41 09 c6                     	orl	%eax, %r14d
    4c2a: 45 21 c6                     	andl	%r8d, %r14d
    4c2d: 45 89 d1                     	movl	%r10d, %r9d
    4c30: 41 21 c1                     	andl	%eax, %r9d
    4c33: 45 09 f1                     	orl	%r14d, %r9d
    4c36: 41 89 f6                     	movl	%esi, %r14d
    4c39: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4c3d: 45 01 f9                     	addl	%r15d, %r9d
    4c40: 41 89 f7                     	movl	%esi, %r15d
    4c43: 41 c1 c7 15                  	roll	$0x15, %r15d
    4c47: 45 01 d9                     	addl	%r11d, %r9d
    4c4a: 41 89 f3                     	movl	%esi, %r11d
    4c4d: 41 c1 c3 07                  	roll	$0x7, %r11d
    4c51: 45 31 f7                     	xorl	%r14d, %r15d
    4c54: 45 31 fb                     	xorl	%r15d, %r11d
    4c57: 41 89 d6                     	movl	%edx, %r14d
    4c5a: 41 31 de                     	xorl	%ebx, %r14d
    4c5d: 41 21 f6                     	andl	%esi, %r14d
    4c60: 41 31 de                     	xorl	%ebx, %r14d
    4c63: 03 8d 28 ff ff ff            	addl	-0xd8(%rbp), %ecx
    4c69: 44 01 f1                     	addl	%r14d, %ecx
    4c6c: 45 89 ce                     	movl	%r9d, %r14d
    4c6f: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4c73: 41 01 cb                     	addl	%ecx, %r11d
    4c76: 41 81 c3 dc a9 b0 5c         	addl	$0x5cb0a9dc, %r11d      # imm = 0x5CB0A9DC
    4c7d: 44 89 c9                     	movl	%r9d, %ecx
    4c80: c1 c1 13                     	roll	$0x13, %ecx
    4c83: 44 01 d8                     	addl	%r11d, %eax
    4c86: 45 89 cf                     	movl	%r9d, %r15d
    4c89: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4c8d: 44 31 f1                     	xorl	%r14d, %ecx
    4c90: 41 31 cf                     	xorl	%ecx, %r15d
    4c93: 45 89 c6                     	movl	%r8d, %r14d
    4c96: 45 09 d6                     	orl	%r10d, %r14d
    4c99: 45 21 ce                     	andl	%r9d, %r14d
    4c9c: 44 89 c1                     	movl	%r8d, %ecx
    4c9f: 44 21 d1                     	andl	%r10d, %ecx
    4ca2: 44 09 f1                     	orl	%r14d, %ecx
    4ca5: 44 01 f9                     	addl	%r15d, %ecx
    4ca8: 41 89 c6                     	movl	%eax, %r14d
    4cab: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4caf: 44 01 d9                     	addl	%r11d, %ecx
    4cb2: 41 89 c3                     	movl	%eax, %r11d
    4cb5: 41 c1 c3 15                  	roll	$0x15, %r11d
    4cb9: 45 31 f3                     	xorl	%r14d, %r11d
    4cbc: 41 89 c6                     	movl	%eax, %r14d
    4cbf: 41 c1 c6 07                  	roll	$0x7, %r14d
    4cc3: 45 31 de                     	xorl	%r11d, %r14d
    4cc6: 41 89 f3                     	movl	%esi, %r11d
    4cc9: 41 31 d3                     	xorl	%edx, %r11d
    4ccc: 41 21 c3                     	andl	%eax, %r11d
    4ccf: 41 31 d3                     	xorl	%edx, %r11d
    4cd2: 03 9d 2c ff ff ff            	addl	-0xd4(%rbp), %ebx
    4cd8: 44 01 db                     	addl	%r11d, %ebx
    4cdb: 44 01 f3                     	addl	%r14d, %ebx
    4cde: 81 c3 da 88 f9 76            	addl	$0x76f988da, %ebx       # imm = 0x76F988DA
    4ce4: 41 89 cb                     	movl	%ecx, %r11d
    4ce7: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    4ceb: 41 01 da                     	addl	%ebx, %r10d
    4cee: 41 89 ce                     	movl	%ecx, %r14d
    4cf1: 41 c1 c6 13                  	roll	$0x13, %r14d
    4cf5: 45 31 de                     	xorl	%r11d, %r14d
    4cf8: 41 89 cf                     	movl	%ecx, %r15d
    4cfb: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4cff: 45 31 f7                     	xorl	%r14d, %r15d
    4d02: 45 89 ce                     	movl	%r9d, %r14d
    4d05: 45 09 c6                     	orl	%r8d, %r14d
    4d08: 41 21 ce                     	andl	%ecx, %r14d
    4d0b: 45 89 cb                     	movl	%r9d, %r11d
    4d0e: 45 21 c3                     	andl	%r8d, %r11d
    4d11: 45 09 f3                     	orl	%r14d, %r11d
    4d14: 45 01 fb                     	addl	%r15d, %r11d
    4d17: 41 01 db                     	addl	%ebx, %r11d
    4d1a: 44 89 d3                     	movl	%r10d, %ebx
    4d1d: c1 c3 1a                     	roll	$0x1a, %ebx
    4d20: 45 89 d6                     	movl	%r10d, %r14d
    4d23: 41 c1 c6 15                  	roll	$0x15, %r14d
    4d27: 41 31 de                     	xorl	%ebx, %r14d
    4d2a: 44 89 d3                     	movl	%r10d, %ebx
    4d2d: c1 c3 07                     	roll	$0x7, %ebx
    4d30: 44 31 f3                     	xorl	%r14d, %ebx
    4d33: 41 89 c6                     	movl	%eax, %r14d
    4d36: 41 31 f6                     	xorl	%esi, %r14d
    4d39: 45 21 d6                     	andl	%r10d, %r14d
    4d3c: 41 31 f6                     	xorl	%esi, %r14d
    4d3f: 03 95 30 ff ff ff            	addl	-0xd0(%rbp), %edx
    4d45: 44 01 f2                     	addl	%r14d, %edx
    4d48: 01 d3                        	addl	%edx, %ebx
    4d4a: 81 c3 52 51 3e 98            	addl	$0x983e5152, %ebx       # imm = 0x983E5152
    4d50: 41 01 d8                     	addl	%ebx, %r8d
    4d53: 44 89 da                     	movl	%r11d, %edx
    4d56: c1 c2 1e                     	roll	$0x1e, %edx
    4d59: 45 89 de                     	movl	%r11d, %r14d
    4d5c: 41 c1 c6 13                  	roll	$0x13, %r14d
    4d60: 41 31 d6                     	xorl	%edx, %r14d
    4d63: 45 89 df                     	movl	%r11d, %r15d
    4d66: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4d6a: 45 31 f7                     	xorl	%r14d, %r15d
    4d6d: 41 89 ce                     	movl	%ecx, %r14d
    4d70: 45 09 ce                     	orl	%r9d, %r14d
    4d73: 45 21 de                     	andl	%r11d, %r14d
    4d76: 89 ca                        	movl	%ecx, %edx
    4d78: 44 21 ca                     	andl	%r9d, %edx
    4d7b: 44 09 f2                     	orl	%r14d, %edx
    4d7e: 44 01 fa                     	addl	%r15d, %edx
    4d81: 01 da                        	addl	%ebx, %edx
    4d83: 44 89 c3                     	movl	%r8d, %ebx
    4d86: c1 c3 1a                     	roll	$0x1a, %ebx
    4d89: 45 89 c6                     	movl	%r8d, %r14d
    4d8c: 41 c1 c6 15                  	roll	$0x15, %r14d
    4d90: 41 31 de                     	xorl	%ebx, %r14d
    4d93: 44 89 c3                     	movl	%r8d, %ebx
    4d96: c1 c3 07                     	roll	$0x7, %ebx
    4d99: 44 31 f3                     	xorl	%r14d, %ebx
    4d9c: 45 89 d6                     	movl	%r10d, %r14d
    4d9f: 41 31 c6                     	xorl	%eax, %r14d
    4da2: 45 21 c6                     	andl	%r8d, %r14d
    4da5: 03 b5 34 ff ff ff            	addl	-0xcc(%rbp), %esi
    4dab: 41 31 c6                     	xorl	%eax, %r14d
    4dae: 44 01 f6                     	addl	%r14d, %esi
    4db1: 01 f3                        	addl	%esi, %ebx
    4db3: 81 c3 6d c6 31 a8            	addl	$0xa831c66d, %ebx       # imm = 0xA831C66D
    4db9: 41 01 d9                     	addl	%ebx, %r9d
    4dbc: 89 d6                        	movl	%edx, %esi
    4dbe: c1 c6 1e                     	roll	$0x1e, %esi
    4dc1: 41 89 d6                     	movl	%edx, %r14d
    4dc4: 41 c1 c6 13                  	roll	$0x13, %r14d
    4dc8: 41 31 f6                     	xorl	%esi, %r14d
    4dcb: 41 89 d7                     	movl	%edx, %r15d
    4dce: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4dd2: 45 31 f7                     	xorl	%r14d, %r15d
    4dd5: 45 89 de                     	movl	%r11d, %r14d
    4dd8: 41 09 ce                     	orl	%ecx, %r14d
    4ddb: 41 21 d6                     	andl	%edx, %r14d
    4dde: 44 89 de                     	movl	%r11d, %esi
    4de1: 21 ce                        	andl	%ecx, %esi
    4de3: 44 09 f6                     	orl	%r14d, %esi
    4de6: 45 89 ce                     	movl	%r9d, %r14d
    4de9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4ded: 44 01 fe                     	addl	%r15d, %esi
    4df0: 45 89 cf                     	movl	%r9d, %r15d
    4df3: 41 c1 c7 15                  	roll	$0x15, %r15d
    4df7: 01 de                        	addl	%ebx, %esi
    4df9: 44 89 cb                     	movl	%r9d, %ebx
    4dfc: c1 c3 07                     	roll	$0x7, %ebx
    4dff: 45 31 f7                     	xorl	%r14d, %r15d
    4e02: 44 31 fb                     	xorl	%r15d, %ebx
    4e05: 45 89 c6                     	movl	%r8d, %r14d
    4e08: 45 31 d6                     	xorl	%r10d, %r14d
    4e0b: 45 21 ce                     	andl	%r9d, %r14d
    4e0e: 45 31 d6                     	xorl	%r10d, %r14d
    4e11: 03 85 38 ff ff ff            	addl	-0xc8(%rbp), %eax
    4e17: 44 01 f0                     	addl	%r14d, %eax
    4e1a: 41 89 f6                     	movl	%esi, %r14d
    4e1d: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4e21: 01 c3                        	addl	%eax, %ebx
    4e23: 81 c3 c8 27 03 b0            	addl	$0xb00327c8, %ebx       # imm = 0xB00327C8
    4e29: 89 f0                        	movl	%esi, %eax
    4e2b: c1 c0 13                     	roll	$0x13, %eax
    4e2e: 01 d9                        	addl	%ebx, %ecx
    4e30: 41 89 f7                     	movl	%esi, %r15d
    4e33: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4e37: 44 31 f0                     	xorl	%r14d, %eax
    4e3a: 41 31 c7                     	xorl	%eax, %r15d
    4e3d: 41 89 d6                     	movl	%edx, %r14d
    4e40: 45 09 de                     	orl	%r11d, %r14d
    4e43: 41 21 f6                     	andl	%esi, %r14d
    4e46: 89 d0                        	movl	%edx, %eax
    4e48: 44 21 d8                     	andl	%r11d, %eax
    4e4b: 44 09 f0                     	orl	%r14d, %eax
    4e4e: 44 01 f8                     	addl	%r15d, %eax
    4e51: 41 89 ce                     	movl	%ecx, %r14d
    4e54: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4e58: 01 d8                        	addl	%ebx, %eax
    4e5a: 89 cb                        	movl	%ecx, %ebx
    4e5c: c1 c3 15                     	roll	$0x15, %ebx
    4e5f: 44 31 f3                     	xorl	%r14d, %ebx
    4e62: 41 89 ce                     	movl	%ecx, %r14d
    4e65: 41 c1 c6 07                  	roll	$0x7, %r14d
    4e69: 41 31 de                     	xorl	%ebx, %r14d
    4e6c: 44 89 cb                     	movl	%r9d, %ebx
    4e6f: 44 31 c3                     	xorl	%r8d, %ebx
    4e72: 21 cb                        	andl	%ecx, %ebx
    4e74: 44 31 c3                     	xorl	%r8d, %ebx
    4e77: 44 03 95 3c ff ff ff         	addl	-0xc4(%rbp), %r10d
    4e7e: 41 01 da                     	addl	%ebx, %r10d
    4e81: 43 8d 1c 16                  	leal	(%r14,%r10), %ebx
    4e85: 81 c3 c7 7f 59 bf            	addl	$0xbf597fc7, %ebx       # imm = 0xBF597FC7
    4e8b: 41 89 c2                     	movl	%eax, %r10d
    4e8e: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4e92: 41 01 db                     	addl	%ebx, %r11d
    4e95: 41 89 c6                     	movl	%eax, %r14d
    4e98: 41 c1 c6 13                  	roll	$0x13, %r14d
    4e9c: 45 31 d6                     	xorl	%r10d, %r14d
    4e9f: 41 89 c7                     	movl	%eax, %r15d
    4ea2: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4ea6: 45 31 f7                     	xorl	%r14d, %r15d
    4ea9: 41 89 f6                     	movl	%esi, %r14d
    4eac: 41 09 d6                     	orl	%edx, %r14d
    4eaf: 41 21 c6                     	andl	%eax, %r14d
    4eb2: 41 89 f2                     	movl	%esi, %r10d
    4eb5: 41 21 d2                     	andl	%edx, %r10d
    4eb8: 45 09 f2                     	orl	%r14d, %r10d
    4ebb: 45 01 fa                     	addl	%r15d, %r10d
    4ebe: 41 01 da                     	addl	%ebx, %r10d
    4ec1: 44 89 db                     	movl	%r11d, %ebx
    4ec4: c1 c3 1a                     	roll	$0x1a, %ebx
    4ec7: 45 89 de                     	movl	%r11d, %r14d
    4eca: 41 c1 c6 15                  	roll	$0x15, %r14d
    4ece: 41 31 de                     	xorl	%ebx, %r14d
    4ed1: 44 89 db                     	movl	%r11d, %ebx
    4ed4: c1 c3 07                     	roll	$0x7, %ebx
    4ed7: 44 31 f3                     	xorl	%r14d, %ebx
    4eda: 41 89 ce                     	movl	%ecx, %r14d
    4edd: 45 31 ce                     	xorl	%r9d, %r14d
    4ee0: 45 21 de                     	andl	%r11d, %r14d
    4ee3: 45 31 ce                     	xorl	%r9d, %r14d
    4ee6: 44 03 85 40 ff ff ff         	addl	-0xc0(%rbp), %r8d
    4eed: 45 01 f0                     	addl	%r14d, %r8d
    4ef0: 44 01 c3                     	addl	%r8d, %ebx
    4ef3: 81 c3 f3 0b e0 c6            	addl	$0xc6e00bf3, %ebx       # imm = 0xC6E00BF3
    4ef9: 01 da                        	addl	%ebx, %edx
    4efb: 45 89 d0                     	movl	%r10d, %r8d
    4efe: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    4f02: 45 89 d6                     	movl	%r10d, %r14d
    4f05: 41 c1 c6 13                  	roll	$0x13, %r14d
    4f09: 45 31 c6                     	xorl	%r8d, %r14d
    4f0c: 45 89 d7                     	movl	%r10d, %r15d
    4f0f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4f13: 45 31 f7                     	xorl	%r14d, %r15d
    4f16: 41 89 c6                     	movl	%eax, %r14d
    4f19: 41 09 f6                     	orl	%esi, %r14d
    4f1c: 45 21 d6                     	andl	%r10d, %r14d
    4f1f: 41 89 c0                     	movl	%eax, %r8d
    4f22: 41 21 f0                     	andl	%esi, %r8d
    4f25: 45 09 f0                     	orl	%r14d, %r8d
    4f28: 45 01 f8                     	addl	%r15d, %r8d
    4f2b: 41 01 d8                     	addl	%ebx, %r8d
    4f2e: 89 d3                        	movl	%edx, %ebx
    4f30: c1 c3 1a                     	roll	$0x1a, %ebx
    4f33: 41 89 d6                     	movl	%edx, %r14d
    4f36: 41 c1 c6 15                  	roll	$0x15, %r14d
    4f3a: 41 31 de                     	xorl	%ebx, %r14d
    4f3d: 89 d3                        	movl	%edx, %ebx
    4f3f: c1 c3 07                     	roll	$0x7, %ebx
    4f42: 44 31 f3                     	xorl	%r14d, %ebx
    4f45: 45 89 de                     	movl	%r11d, %r14d
    4f48: 41 31 ce                     	xorl	%ecx, %r14d
    4f4b: 41 21 d6                     	andl	%edx, %r14d
    4f4e: 44 03 8d 44 ff ff ff         	addl	-0xbc(%rbp), %r9d
    4f55: 41 31 ce                     	xorl	%ecx, %r14d
    4f58: 45 01 f1                     	addl	%r14d, %r9d
    4f5b: 44 01 cb                     	addl	%r9d, %ebx
    4f5e: 81 c3 47 91 a7 d5            	addl	$0xd5a79147, %ebx       # imm = 0xD5A79147
    4f64: 01 de                        	addl	%ebx, %esi
    4f66: 45 89 c1                     	movl	%r8d, %r9d
    4f69: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4f6d: 45 89 c6                     	movl	%r8d, %r14d
    4f70: 41 c1 c6 13                  	roll	$0x13, %r14d
    4f74: 45 31 ce                     	xorl	%r9d, %r14d
    4f77: 45 89 c7                     	movl	%r8d, %r15d
    4f7a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4f7e: 45 31 f7                     	xorl	%r14d, %r15d
    4f81: 45 89 d6                     	movl	%r10d, %r14d
    4f84: 41 09 c6                     	orl	%eax, %r14d
    4f87: 45 21 c6                     	andl	%r8d, %r14d
    4f8a: 45 89 d1                     	movl	%r10d, %r9d
    4f8d: 41 21 c1                     	andl	%eax, %r9d
    4f90: 45 09 f1                     	orl	%r14d, %r9d
    4f93: 41 89 f6                     	movl	%esi, %r14d
    4f96: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4f9a: 45 01 f9                     	addl	%r15d, %r9d
    4f9d: 41 89 f7                     	movl	%esi, %r15d
    4fa0: 41 c1 c7 15                  	roll	$0x15, %r15d
    4fa4: 41 01 d9                     	addl	%ebx, %r9d
    4fa7: 89 f3                        	movl	%esi, %ebx
    4fa9: c1 c3 07                     	roll	$0x7, %ebx
    4fac: 45 31 f7                     	xorl	%r14d, %r15d
    4faf: 44 31 fb                     	xorl	%r15d, %ebx
    4fb2: 41 89 d6                     	movl	%edx, %r14d
    4fb5: 45 31 de                     	xorl	%r11d, %r14d
    4fb8: 41 21 f6                     	andl	%esi, %r14d
    4fbb: 45 31 de                     	xorl	%r11d, %r14d
    4fbe: 03 8d 48 ff ff ff            	addl	-0xb8(%rbp), %ecx
    4fc4: 44 01 f1                     	addl	%r14d, %ecx
    4fc7: 45 89 ce                     	movl	%r9d, %r14d
    4fca: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4fce: 01 cb                        	addl	%ecx, %ebx
    4fd0: 81 c3 51 63 ca 06            	addl	$0x6ca6351, %ebx        # imm = 0x6CA6351
    4fd6: 44 89 c9                     	movl	%r9d, %ecx
    4fd9: c1 c1 13                     	roll	$0x13, %ecx
    4fdc: 01 d8                        	addl	%ebx, %eax
    4fde: 45 89 cf                     	movl	%r9d, %r15d
    4fe1: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4fe5: 44 31 f1                     	xorl	%r14d, %ecx
    4fe8: 41 31 cf                     	xorl	%ecx, %r15d
    4feb: 45 89 c6                     	movl	%r8d, %r14d
    4fee: 45 09 d6                     	orl	%r10d, %r14d
    4ff1: 45 21 ce                     	andl	%r9d, %r14d
    4ff4: 44 89 c1                     	movl	%r8d, %ecx
    4ff7: 44 21 d1                     	andl	%r10d, %ecx
    4ffa: 44 09 f1                     	orl	%r14d, %ecx
    4ffd: 44 01 f9                     	addl	%r15d, %ecx
    5000: 41 89 c6                     	movl	%eax, %r14d
    5003: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5007: 01 d9                        	addl	%ebx, %ecx
    5009: 89 c3                        	movl	%eax, %ebx
    500b: c1 c3 15                     	roll	$0x15, %ebx
    500e: 44 31 f3                     	xorl	%r14d, %ebx
    5011: 41 89 c6                     	movl	%eax, %r14d
    5014: 41 c1 c6 07                  	roll	$0x7, %r14d
    5018: 41 31 de                     	xorl	%ebx, %r14d
    501b: 89 f3                        	movl	%esi, %ebx
    501d: 31 d3                        	xorl	%edx, %ebx
    501f: 21 c3                        	andl	%eax, %ebx
    5021: 31 d3                        	xorl	%edx, %ebx
    5023: 44 03 9d 4c ff ff ff         	addl	-0xb4(%rbp), %r11d
    502a: 41 01 db                     	addl	%ebx, %r11d
    502d: 43 8d 1c 1e                  	leal	(%r14,%r11), %ebx
    5031: 81 c3 67 29 29 14            	addl	$0x14292967, %ebx       # imm = 0x14292967
    5037: 41 89 cb                     	movl	%ecx, %r11d
    503a: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    503e: 41 01 da                     	addl	%ebx, %r10d
    5041: 41 89 ce                     	movl	%ecx, %r14d
    5044: 41 c1 c6 13                  	roll	$0x13, %r14d
    5048: 45 31 de                     	xorl	%r11d, %r14d
    504b: 41 89 cf                     	movl	%ecx, %r15d
    504e: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5052: 45 31 f7                     	xorl	%r14d, %r15d
    5055: 45 89 ce                     	movl	%r9d, %r14d
    5058: 45 09 c6                     	orl	%r8d, %r14d
    505b: 41 21 ce                     	andl	%ecx, %r14d
    505e: 45 89 cb                     	movl	%r9d, %r11d
    5061: 45 21 c3                     	andl	%r8d, %r11d
    5064: 45 09 f3                     	orl	%r14d, %r11d
    5067: 45 01 fb                     	addl	%r15d, %r11d
    506a: 41 01 db                     	addl	%ebx, %r11d
    506d: 44 89 d3                     	movl	%r10d, %ebx
    5070: c1 c3 1a                     	roll	$0x1a, %ebx
    5073: 45 89 d6                     	movl	%r10d, %r14d
    5076: 41 c1 c6 15                  	roll	$0x15, %r14d
    507a: 41 31 de                     	xorl	%ebx, %r14d
    507d: 44 89 d3                     	movl	%r10d, %ebx
    5080: c1 c3 07                     	roll	$0x7, %ebx
    5083: 44 31 f3                     	xorl	%r14d, %ebx
    5086: 41 89 c6                     	movl	%eax, %r14d
    5089: 41 31 f6                     	xorl	%esi, %r14d
    508c: 45 21 d6                     	andl	%r10d, %r14d
    508f: 41 31 f6                     	xorl	%esi, %r14d
    5092: 03 95 50 ff ff ff            	addl	-0xb0(%rbp), %edx
    5098: 44 01 f2                     	addl	%r14d, %edx
    509b: 01 d3                        	addl	%edx, %ebx
    509d: 81 c3 85 0a b7 27            	addl	$0x27b70a85, %ebx       # imm = 0x27B70A85
    50a3: 41 01 d8                     	addl	%ebx, %r8d
    50a6: 44 89 da                     	movl	%r11d, %edx
    50a9: c1 c2 1e                     	roll	$0x1e, %edx
    50ac: 45 89 de                     	movl	%r11d, %r14d
    50af: 41 c1 c6 13                  	roll	$0x13, %r14d
    50b3: 41 31 d6                     	xorl	%edx, %r14d
    50b6: 45 89 df                     	movl	%r11d, %r15d
    50b9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    50bd: 45 31 f7                     	xorl	%r14d, %r15d
    50c0: 41 89 ce                     	movl	%ecx, %r14d
    50c3: 45 09 ce                     	orl	%r9d, %r14d
    50c6: 45 21 de                     	andl	%r11d, %r14d
    50c9: 89 ca                        	movl	%ecx, %edx
    50cb: 44 21 ca                     	andl	%r9d, %edx
    50ce: 44 09 f2                     	orl	%r14d, %edx
    50d1: 44 01 fa                     	addl	%r15d, %edx
    50d4: 01 da                        	addl	%ebx, %edx
    50d6: 44 89 c3                     	movl	%r8d, %ebx
    50d9: c1 c3 1a                     	roll	$0x1a, %ebx
    50dc: 45 89 c6                     	movl	%r8d, %r14d
    50df: 41 c1 c6 15                  	roll	$0x15, %r14d
    50e3: 41 31 de                     	xorl	%ebx, %r14d
    50e6: 44 89 c3                     	movl	%r8d, %ebx
    50e9: c1 c3 07                     	roll	$0x7, %ebx
    50ec: 44 31 f3                     	xorl	%r14d, %ebx
    50ef: 45 89 d6                     	movl	%r10d, %r14d
    50f2: 41 31 c6                     	xorl	%eax, %r14d
    50f5: 45 21 c6                     	andl	%r8d, %r14d
    50f8: 03 b5 54 ff ff ff            	addl	-0xac(%rbp), %esi
    50fe: 41 31 c6                     	xorl	%eax, %r14d
    5101: 44 01 f6                     	addl	%r14d, %esi
    5104: 01 f3                        	addl	%esi, %ebx
    5106: 81 c3 38 21 1b 2e            	addl	$0x2e1b2138, %ebx       # imm = 0x2E1B2138
    510c: 41 01 d9                     	addl	%ebx, %r9d
    510f: 89 d6                        	movl	%edx, %esi
    5111: c1 c6 1e                     	roll	$0x1e, %esi
    5114: 41 89 d6                     	movl	%edx, %r14d
    5117: 41 c1 c6 13                  	roll	$0x13, %r14d
    511b: 41 31 f6                     	xorl	%esi, %r14d
    511e: 41 89 d7                     	movl	%edx, %r15d
    5121: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5125: 45 31 f7                     	xorl	%r14d, %r15d
    5128: 45 89 de                     	movl	%r11d, %r14d
    512b: 41 09 ce                     	orl	%ecx, %r14d
    512e: 41 21 d6                     	andl	%edx, %r14d
    5131: 44 89 de                     	movl	%r11d, %esi
    5134: 21 ce                        	andl	%ecx, %esi
    5136: 44 09 f6                     	orl	%r14d, %esi
    5139: 45 89 ce                     	movl	%r9d, %r14d
    513c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5140: 44 01 fe                     	addl	%r15d, %esi
    5143: 45 89 cf                     	movl	%r9d, %r15d
    5146: 41 c1 c7 15                  	roll	$0x15, %r15d
    514a: 01 de                        	addl	%ebx, %esi
    514c: 44 89 cb                     	movl	%r9d, %ebx
    514f: c1 c3 07                     	roll	$0x7, %ebx
    5152: 45 31 f7                     	xorl	%r14d, %r15d
    5155: 44 31 fb                     	xorl	%r15d, %ebx
    5158: 45 89 c6                     	movl	%r8d, %r14d
    515b: 45 31 d6                     	xorl	%r10d, %r14d
    515e: 45 21 ce                     	andl	%r9d, %r14d
    5161: 45 31 d6                     	xorl	%r10d, %r14d
    5164: 03 85 58 ff ff ff            	addl	-0xa8(%rbp), %eax
    516a: 44 01 f0                     	addl	%r14d, %eax
    516d: 41 89 f6                     	movl	%esi, %r14d
    5170: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5174: 01 c3                        	addl	%eax, %ebx
    5176: 81 c3 fc 6d 2c 4d            	addl	$0x4d2c6dfc, %ebx       # imm = 0x4D2C6DFC
    517c: 89 f0                        	movl	%esi, %eax
    517e: c1 c0 13                     	roll	$0x13, %eax
    5181: 01 d9                        	addl	%ebx, %ecx
    5183: 41 89 f7                     	movl	%esi, %r15d
    5186: 41 c1 c7 0a                  	roll	$0xa, %r15d
    518a: 44 31 f0                     	xorl	%r14d, %eax
    518d: 41 31 c7                     	xorl	%eax, %r15d
    5190: 41 89 d6                     	movl	%edx, %r14d
    5193: 45 09 de                     	orl	%r11d, %r14d
    5196: 41 21 f6                     	andl	%esi, %r14d
    5199: 89 d0                        	movl	%edx, %eax
    519b: 44 21 d8                     	andl	%r11d, %eax
    519e: 44 09 f0                     	orl	%r14d, %eax
    51a1: 44 01 f8                     	addl	%r15d, %eax
    51a4: 41 89 ce                     	movl	%ecx, %r14d
    51a7: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    51ab: 01 d8                        	addl	%ebx, %eax
    51ad: 89 cb                        	movl	%ecx, %ebx
    51af: c1 c3 15                     	roll	$0x15, %ebx
    51b2: 44 31 f3                     	xorl	%r14d, %ebx
    51b5: 41 89 ce                     	movl	%ecx, %r14d
    51b8: 41 c1 c6 07                  	roll	$0x7, %r14d
    51bc: 41 31 de                     	xorl	%ebx, %r14d
    51bf: 44 89 cb                     	movl	%r9d, %ebx
    51c2: 44 31 c3                     	xorl	%r8d, %ebx
    51c5: 21 cb                        	andl	%ecx, %ebx
    51c7: 44 31 c3                     	xorl	%r8d, %ebx
    51ca: 44 03 95 5c ff ff ff         	addl	-0xa4(%rbp), %r10d
    51d1: 41 01 da                     	addl	%ebx, %r10d
    51d4: 43 8d 1c 16                  	leal	(%r14,%r10), %ebx
    51d8: 81 c3 13 0d 38 53            	addl	$0x53380d13, %ebx       # imm = 0x53380D13
    51de: 41 89 c2                     	movl	%eax, %r10d
    51e1: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    51e5: 41 01 db                     	addl	%ebx, %r11d
    51e8: 41 89 c6                     	movl	%eax, %r14d
    51eb: 41 c1 c6 13                  	roll	$0x13, %r14d
    51ef: 45 31 d6                     	xorl	%r10d, %r14d
    51f2: 41 89 c7                     	movl	%eax, %r15d
    51f5: 41 c1 c7 0a                  	roll	$0xa, %r15d
    51f9: 45 31 f7                     	xorl	%r14d, %r15d
    51fc: 41 89 f6                     	movl	%esi, %r14d
    51ff: 41 09 d6                     	orl	%edx, %r14d
    5202: 41 21 c6                     	andl	%eax, %r14d
    5205: 41 89 f2                     	movl	%esi, %r10d
    5208: 41 21 d2                     	andl	%edx, %r10d
    520b: 45 09 f2                     	orl	%r14d, %r10d
    520e: 45 01 fa                     	addl	%r15d, %r10d
    5211: 41 01 da                     	addl	%ebx, %r10d
    5214: 44 89 db                     	movl	%r11d, %ebx
    5217: c1 c3 1a                     	roll	$0x1a, %ebx
    521a: 45 89 de                     	movl	%r11d, %r14d
    521d: 41 c1 c6 15                  	roll	$0x15, %r14d
    5221: 41 31 de                     	xorl	%ebx, %r14d
    5224: 44 89 db                     	movl	%r11d, %ebx
    5227: c1 c3 07                     	roll	$0x7, %ebx
    522a: 44 31 f3                     	xorl	%r14d, %ebx
    522d: 41 89 ce                     	movl	%ecx, %r14d
    5230: 45 31 ce                     	xorl	%r9d, %r14d
    5233: 45 21 de                     	andl	%r11d, %r14d
    5236: 45 31 ce                     	xorl	%r9d, %r14d
    5239: 44 03 85 60 ff ff ff         	addl	-0xa0(%rbp), %r8d
    5240: 45 01 f0                     	addl	%r14d, %r8d
    5243: 44 01 c3                     	addl	%r8d, %ebx
    5246: 81 c3 54 73 0a 65            	addl	$0x650a7354, %ebx       # imm = 0x650A7354
    524c: 01 da                        	addl	%ebx, %edx
    524e: 45 89 d0                     	movl	%r10d, %r8d
    5251: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5255: 45 89 d6                     	movl	%r10d, %r14d
    5258: 41 c1 c6 13                  	roll	$0x13, %r14d
    525c: 45 31 c6                     	xorl	%r8d, %r14d
    525f: 45 89 d7                     	movl	%r10d, %r15d
    5262: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5266: 45 31 f7                     	xorl	%r14d, %r15d
    5269: 41 89 c6                     	movl	%eax, %r14d
    526c: 41 09 f6                     	orl	%esi, %r14d
    526f: 45 21 d6                     	andl	%r10d, %r14d
    5272: 41 89 c0                     	movl	%eax, %r8d
    5275: 41 21 f0                     	andl	%esi, %r8d
    5278: 45 09 f0                     	orl	%r14d, %r8d
    527b: 45 01 f8                     	addl	%r15d, %r8d
    527e: 41 01 d8                     	addl	%ebx, %r8d
    5281: 89 d3                        	movl	%edx, %ebx
    5283: c1 c3 1a                     	roll	$0x1a, %ebx
    5286: 41 89 d6                     	movl	%edx, %r14d
    5289: 41 c1 c6 15                  	roll	$0x15, %r14d
    528d: 41 31 de                     	xorl	%ebx, %r14d
    5290: 89 d3                        	movl	%edx, %ebx
    5292: c1 c3 07                     	roll	$0x7, %ebx
    5295: 44 31 f3                     	xorl	%r14d, %ebx
    5298: 45 89 de                     	movl	%r11d, %r14d
    529b: 41 31 ce                     	xorl	%ecx, %r14d
    529e: 41 21 d6                     	andl	%edx, %r14d
    52a1: 44 03 8d 64 ff ff ff         	addl	-0x9c(%rbp), %r9d
    52a8: 41 31 ce                     	xorl	%ecx, %r14d
    52ab: 45 01 f1                     	addl	%r14d, %r9d
    52ae: 44 01 cb                     	addl	%r9d, %ebx
    52b1: 81 c3 bb 0a 6a 76            	addl	$0x766a0abb, %ebx       # imm = 0x766A0ABB
    52b7: 01 de                        	addl	%ebx, %esi
    52b9: 45 89 c1                     	movl	%r8d, %r9d
    52bc: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    52c0: 45 89 c6                     	movl	%r8d, %r14d
    52c3: 41 c1 c6 13                  	roll	$0x13, %r14d
    52c7: 45 31 ce                     	xorl	%r9d, %r14d
    52ca: 45 89 c7                     	movl	%r8d, %r15d
    52cd: 41 c1 c7 0a                  	roll	$0xa, %r15d
    52d1: 45 31 f7                     	xorl	%r14d, %r15d
    52d4: 45 89 d6                     	movl	%r10d, %r14d
    52d7: 41 09 c6                     	orl	%eax, %r14d
    52da: 45 21 c6                     	andl	%r8d, %r14d
    52dd: 45 89 d1                     	movl	%r10d, %r9d
    52e0: 41 21 c1                     	andl	%eax, %r9d
    52e3: 45 09 f1                     	orl	%r14d, %r9d
    52e6: 41 89 f6                     	movl	%esi, %r14d
    52e9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    52ed: 45 01 f9                     	addl	%r15d, %r9d
    52f0: 41 89 f7                     	movl	%esi, %r15d
    52f3: 41 c1 c7 15                  	roll	$0x15, %r15d
    52f7: 41 01 d9                     	addl	%ebx, %r9d
    52fa: 89 f3                        	movl	%esi, %ebx
    52fc: c1 c3 07                     	roll	$0x7, %ebx
    52ff: 45 31 f7                     	xorl	%r14d, %r15d
    5302: 44 31 fb                     	xorl	%r15d, %ebx
    5305: 41 89 d6                     	movl	%edx, %r14d
    5308: 45 31 de                     	xorl	%r11d, %r14d
    530b: 41 21 f6                     	andl	%esi, %r14d
    530e: 45 31 de                     	xorl	%r11d, %r14d
    5311: 03 8d 68 ff ff ff            	addl	-0x98(%rbp), %ecx
    5317: 44 01 f1                     	addl	%r14d, %ecx
    531a: 45 89 ce                     	movl	%r9d, %r14d
    531d: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5321: 01 cb                        	addl	%ecx, %ebx
    5323: 81 c3 2e c9 c2 81            	addl	$0x81c2c92e, %ebx       # imm = 0x81C2C92E
    5329: 44 89 c9                     	movl	%r9d, %ecx
    532c: c1 c1 13                     	roll	$0x13, %ecx
    532f: 01 d8                        	addl	%ebx, %eax
    5331: 45 89 cf                     	movl	%r9d, %r15d
    5334: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5338: 44 31 f1                     	xorl	%r14d, %ecx
    533b: 41 31 cf                     	xorl	%ecx, %r15d
    533e: 45 89 c6                     	movl	%r8d, %r14d
    5341: 45 09 d6                     	orl	%r10d, %r14d
    5344: 45 21 ce                     	andl	%r9d, %r14d
    5347: 44 89 c1                     	movl	%r8d, %ecx
    534a: 44 21 d1                     	andl	%r10d, %ecx
    534d: 44 09 f1                     	orl	%r14d, %ecx
    5350: 44 01 f9                     	addl	%r15d, %ecx
    5353: 41 89 c6                     	movl	%eax, %r14d
    5356: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    535a: 01 d9                        	addl	%ebx, %ecx
    535c: 89 c3                        	movl	%eax, %ebx
    535e: c1 c3 15                     	roll	$0x15, %ebx
    5361: 44 31 f3                     	xorl	%r14d, %ebx
    5364: 41 89 c6                     	movl	%eax, %r14d
    5367: 41 c1 c6 07                  	roll	$0x7, %r14d
    536b: 41 31 de                     	xorl	%ebx, %r14d
    536e: 89 f3                        	movl	%esi, %ebx
    5370: 31 d3                        	xorl	%edx, %ebx
    5372: 21 c3                        	andl	%eax, %ebx
    5374: 31 d3                        	xorl	%edx, %ebx
    5376: 44 03 9d 6c ff ff ff         	addl	-0x94(%rbp), %r11d
    537d: 41 01 db                     	addl	%ebx, %r11d
    5380: 43 8d 1c 1e                  	leal	(%r14,%r11), %ebx
    5384: 81 c3 85 2c 72 92            	addl	$0x92722c85, %ebx       # imm = 0x92722C85
    538a: 41 89 cb                     	movl	%ecx, %r11d
    538d: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    5391: 41 01 da                     	addl	%ebx, %r10d
    5394: 41 89 ce                     	movl	%ecx, %r14d
    5397: 41 c1 c6 13                  	roll	$0x13, %r14d
    539b: 45 31 de                     	xorl	%r11d, %r14d
    539e: 41 89 cf                     	movl	%ecx, %r15d
    53a1: 41 c1 c7 0a                  	roll	$0xa, %r15d
    53a5: 45 31 f7                     	xorl	%r14d, %r15d
    53a8: 45 89 ce                     	movl	%r9d, %r14d
    53ab: 45 09 c6                     	orl	%r8d, %r14d
    53ae: 41 21 ce                     	andl	%ecx, %r14d
    53b1: 45 89 cb                     	movl	%r9d, %r11d
    53b4: 45 21 c3                     	andl	%r8d, %r11d
    53b7: 45 09 f3                     	orl	%r14d, %r11d
    53ba: 45 01 fb                     	addl	%r15d, %r11d
    53bd: 41 01 db                     	addl	%ebx, %r11d
    53c0: 44 89 d3                     	movl	%r10d, %ebx
    53c3: c1 c3 1a                     	roll	$0x1a, %ebx
    53c6: 45 89 d6                     	movl	%r10d, %r14d
    53c9: 41 c1 c6 15                  	roll	$0x15, %r14d
    53cd: 41 31 de                     	xorl	%ebx, %r14d
    53d0: 44 89 d3                     	movl	%r10d, %ebx
    53d3: c1 c3 07                     	roll	$0x7, %ebx
    53d6: 44 31 f3                     	xorl	%r14d, %ebx
    53d9: 41 89 c6                     	movl	%eax, %r14d
    53dc: 41 31 f6                     	xorl	%esi, %r14d
    53df: 45 21 d6                     	andl	%r10d, %r14d
    53e2: 41 31 f6                     	xorl	%esi, %r14d
    53e5: 03 95 70 ff ff ff            	addl	-0x90(%rbp), %edx
    53eb: 44 01 f2                     	addl	%r14d, %edx
    53ee: 01 d3                        	addl	%edx, %ebx
    53f0: 81 c3 a1 e8 bf a2            	addl	$0xa2bfe8a1, %ebx       # imm = 0xA2BFE8A1
    53f6: 41 01 d8                     	addl	%ebx, %r8d
    53f9: 44 89 da                     	movl	%r11d, %edx
    53fc: c1 c2 1e                     	roll	$0x1e, %edx
    53ff: 45 89 de                     	movl	%r11d, %r14d
    5402: 41 c1 c6 13                  	roll	$0x13, %r14d
    5406: 41 31 d6                     	xorl	%edx, %r14d
    5409: 45 89 df                     	movl	%r11d, %r15d
    540c: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5410: 45 31 f7                     	xorl	%r14d, %r15d
    5413: 41 89 ce                     	movl	%ecx, %r14d
    5416: 45 09 ce                     	orl	%r9d, %r14d
    5419: 45 21 de                     	andl	%r11d, %r14d
    541c: 89 ca                        	movl	%ecx, %edx
    541e: 44 21 ca                     	andl	%r9d, %edx
    5421: 44 09 f2                     	orl	%r14d, %edx
    5424: 44 01 fa                     	addl	%r15d, %edx
    5427: 01 da                        	addl	%ebx, %edx
    5429: 44 89 c3                     	movl	%r8d, %ebx
    542c: c1 c3 1a                     	roll	$0x1a, %ebx
    542f: 45 89 c6                     	movl	%r8d, %r14d
    5432: 41 c1 c6 15                  	roll	$0x15, %r14d
    5436: 41 31 de                     	xorl	%ebx, %r14d
    5439: 44 89 c3                     	movl	%r8d, %ebx
    543c: c1 c3 07                     	roll	$0x7, %ebx
    543f: 44 31 f3                     	xorl	%r14d, %ebx
    5442: 45 89 d6                     	movl	%r10d, %r14d
    5445: 41 31 c6                     	xorl	%eax, %r14d
    5448: 45 21 c6                     	andl	%r8d, %r14d
    544b: 03 b5 74 ff ff ff            	addl	-0x8c(%rbp), %esi
    5451: 41 31 c6                     	xorl	%eax, %r14d
    5454: 44 01 f6                     	addl	%r14d, %esi
    5457: 01 f3                        	addl	%esi, %ebx
    5459: 81 c3 4b 66 1a a8            	addl	$0xa81a664b, %ebx       # imm = 0xA81A664B
    545f: 41 01 d9                     	addl	%ebx, %r9d
    5462: 89 d6                        	movl	%edx, %esi
    5464: c1 c6 1e                     	roll	$0x1e, %esi
    5467: 41 89 d6                     	movl	%edx, %r14d
    546a: 41 c1 c6 13                  	roll	$0x13, %r14d
    546e: 41 31 f6                     	xorl	%esi, %r14d
    5471: 41 89 d7                     	movl	%edx, %r15d
    5474: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5478: 45 31 f7                     	xorl	%r14d, %r15d
    547b: 45 89 de                     	movl	%r11d, %r14d
    547e: 41 09 ce                     	orl	%ecx, %r14d
    5481: 41 21 d6                     	andl	%edx, %r14d
    5484: 44 89 de                     	movl	%r11d, %esi
    5487: 21 ce                        	andl	%ecx, %esi
    5489: 44 09 f6                     	orl	%r14d, %esi
    548c: 45 89 ce                     	movl	%r9d, %r14d
    548f: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5493: 44 01 fe                     	addl	%r15d, %esi
    5496: 45 89 cf                     	movl	%r9d, %r15d
    5499: 41 c1 c7 15                  	roll	$0x15, %r15d
    549d: 01 de                        	addl	%ebx, %esi
    549f: 44 89 cb                     	movl	%r9d, %ebx
    54a2: c1 c3 07                     	roll	$0x7, %ebx
    54a5: 45 31 f7                     	xorl	%r14d, %r15d
    54a8: 44 31 fb                     	xorl	%r15d, %ebx
    54ab: 45 89 c6                     	movl	%r8d, %r14d
    54ae: 45 31 d6                     	xorl	%r10d, %r14d
    54b1: 45 21 ce                     	andl	%r9d, %r14d
    54b4: 45 31 d6                     	xorl	%r10d, %r14d
    54b7: 03 85 78 ff ff ff            	addl	-0x88(%rbp), %eax
    54bd: 44 01 f0                     	addl	%r14d, %eax
    54c0: 41 89 f6                     	movl	%esi, %r14d
    54c3: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    54c7: 01 c3                        	addl	%eax, %ebx
    54c9: 81 c3 70 8b 4b c2            	addl	$0xc24b8b70, %ebx       # imm = 0xC24B8B70
    54cf: 89 f0                        	movl	%esi, %eax
    54d1: c1 c0 13                     	roll	$0x13, %eax
    54d4: 01 d9                        	addl	%ebx, %ecx
    54d6: 41 89 f7                     	movl	%esi, %r15d
    54d9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    54dd: 44 31 f0                     	xorl	%r14d, %eax
    54e0: 41 31 c7                     	xorl	%eax, %r15d
    54e3: 41 89 d6                     	movl	%edx, %r14d
    54e6: 45 09 de                     	orl	%r11d, %r14d
    54e9: 41 21 f6                     	andl	%esi, %r14d
    54ec: 89 d0                        	movl	%edx, %eax
    54ee: 44 21 d8                     	andl	%r11d, %eax
    54f1: 44 09 f0                     	orl	%r14d, %eax
    54f4: 44 01 f8                     	addl	%r15d, %eax
    54f7: 41 89 ce                     	movl	%ecx, %r14d
    54fa: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    54fe: 01 d8                        	addl	%ebx, %eax
    5500: 89 cb                        	movl	%ecx, %ebx
    5502: c1 c3 15                     	roll	$0x15, %ebx
    5505: 44 31 f3                     	xorl	%r14d, %ebx
    5508: 41 89 ce                     	movl	%ecx, %r14d
    550b: 41 c1 c6 07                  	roll	$0x7, %r14d
    550f: 41 31 de                     	xorl	%ebx, %r14d
    5512: 44 89 cb                     	movl	%r9d, %ebx
    5515: 44 31 c3                     	xorl	%r8d, %ebx
    5518: 21 cb                        	andl	%ecx, %ebx
    551a: 44 31 c3                     	xorl	%r8d, %ebx
    551d: 44 03 95 7c ff ff ff         	addl	-0x84(%rbp), %r10d
    5524: 41 01 da                     	addl	%ebx, %r10d
    5527: 45 01 f2                     	addl	%r14d, %r10d
    552a: 41 81 c2 a3 51 6c c7         	addl	$0xc76c51a3, %r10d      # imm = 0xC76C51A3
    5531: 89 c3                        	movl	%eax, %ebx
    5533: c1 c3 1e                     	roll	$0x1e, %ebx
    5536: 45 01 d3                     	addl	%r10d, %r11d
    5539: 41 89 c6                     	movl	%eax, %r14d
    553c: 41 c1 c6 13                  	roll	$0x13, %r14d
    5540: 41 31 de                     	xorl	%ebx, %r14d
    5543: 41 89 c7                     	movl	%eax, %r15d
    5546: 41 c1 c7 0a                  	roll	$0xa, %r15d
    554a: 45 31 f7                     	xorl	%r14d, %r15d
    554d: 41 89 f6                     	movl	%esi, %r14d
    5550: 41 09 d6                     	orl	%edx, %r14d
    5553: 41 21 c6                     	andl	%eax, %r14d
    5556: 89 f3                        	movl	%esi, %ebx
    5558: 21 d3                        	andl	%edx, %ebx
    555a: 44 09 f3                     	orl	%r14d, %ebx
    555d: 44 01 fb                     	addl	%r15d, %ebx
    5560: 44 01 d3                     	addl	%r10d, %ebx
    5563: 45 89 da                     	movl	%r11d, %r10d
    5566: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    556a: 45 89 de                     	movl	%r11d, %r14d
    556d: 41 c1 c6 15                  	roll	$0x15, %r14d
    5571: 45 31 d6                     	xorl	%r10d, %r14d
    5574: 45 89 da                     	movl	%r11d, %r10d
    5577: 41 c1 c2 07                  	roll	$0x7, %r10d
    557b: 45 31 f2                     	xorl	%r14d, %r10d
    557e: 41 89 ce                     	movl	%ecx, %r14d
    5581: 45 31 ce                     	xorl	%r9d, %r14d
    5584: 45 21 de                     	andl	%r11d, %r14d
    5587: 45 31 ce                     	xorl	%r9d, %r14d
    558a: 44 03 45 80                  	addl	-0x80(%rbp), %r8d
    558e: 45 01 f0                     	addl	%r14d, %r8d
    5591: 45 01 c2                     	addl	%r8d, %r10d
    5594: 41 81 c2 19 e8 92 d1         	addl	$0xd192e819, %r10d      # imm = 0xD192E819
    559b: 44 01 d2                     	addl	%r10d, %edx
    559e: 41 89 d8                     	movl	%ebx, %r8d
    55a1: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    55a5: 41 89 de                     	movl	%ebx, %r14d
    55a8: 41 c1 c6 13                  	roll	$0x13, %r14d
    55ac: 45 31 c6                     	xorl	%r8d, %r14d
    55af: 41 89 df                     	movl	%ebx, %r15d
    55b2: 41 c1 c7 0a                  	roll	$0xa, %r15d
    55b6: 45 31 f7                     	xorl	%r14d, %r15d
    55b9: 41 89 c6                     	movl	%eax, %r14d
    55bc: 41 09 f6                     	orl	%esi, %r14d
    55bf: 41 21 de                     	andl	%ebx, %r14d
    55c2: 41 89 c0                     	movl	%eax, %r8d
    55c5: 41 21 f0                     	andl	%esi, %r8d
    55c8: 45 09 f0                     	orl	%r14d, %r8d
    55cb: 45 01 f8                     	addl	%r15d, %r8d
    55ce: 45 01 d0                     	addl	%r10d, %r8d
    55d1: 41 89 d2                     	movl	%edx, %r10d
    55d4: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    55d8: 41 89 d6                     	movl	%edx, %r14d
    55db: 41 c1 c6 15                  	roll	$0x15, %r14d
    55df: 45 31 d6                     	xorl	%r10d, %r14d
    55e2: 41 89 d2                     	movl	%edx, %r10d
    55e5: 41 c1 c2 07                  	roll	$0x7, %r10d
    55e9: 45 31 f2                     	xorl	%r14d, %r10d
    55ec: 45 89 de                     	movl	%r11d, %r14d
    55ef: 41 31 ce                     	xorl	%ecx, %r14d
    55f2: 41 21 d6                     	andl	%edx, %r14d
    55f5: 44 03 4d 84                  	addl	-0x7c(%rbp), %r9d
    55f9: 41 31 ce                     	xorl	%ecx, %r14d
    55fc: 45 01 f1                     	addl	%r14d, %r9d
    55ff: 45 01 ca                     	addl	%r9d, %r10d
    5602: 41 81 c2 24 06 99 d6         	addl	$0xd6990624, %r10d      # imm = 0xD6990624
    5609: 44 01 d6                     	addl	%r10d, %esi
    560c: 45 89 c1                     	movl	%r8d, %r9d
    560f: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5613: 45 89 c6                     	movl	%r8d, %r14d
    5616: 41 c1 c6 13                  	roll	$0x13, %r14d
    561a: 45 31 ce                     	xorl	%r9d, %r14d
    561d: 45 89 c7                     	movl	%r8d, %r15d
    5620: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5624: 45 31 f7                     	xorl	%r14d, %r15d
    5627: 41 89 de                     	movl	%ebx, %r14d
    562a: 41 09 c6                     	orl	%eax, %r14d
    562d: 45 21 c6                     	andl	%r8d, %r14d
    5630: 41 89 d9                     	movl	%ebx, %r9d
    5633: 41 21 c1                     	andl	%eax, %r9d
    5636: 45 09 f1                     	orl	%r14d, %r9d
    5639: 41 89 f6                     	movl	%esi, %r14d
    563c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5640: 45 01 f9                     	addl	%r15d, %r9d
    5643: 41 89 f7                     	movl	%esi, %r15d
    5646: 41 c1 c7 15                  	roll	$0x15, %r15d
    564a: 45 01 d1                     	addl	%r10d, %r9d
    564d: 41 89 f2                     	movl	%esi, %r10d
    5650: 41 c1 c2 07                  	roll	$0x7, %r10d
    5654: 45 31 f7                     	xorl	%r14d, %r15d
    5657: 45 31 fa                     	xorl	%r15d, %r10d
    565a: 41 89 d6                     	movl	%edx, %r14d
    565d: 45 31 de                     	xorl	%r11d, %r14d
    5660: 41 21 f6                     	andl	%esi, %r14d
    5663: 45 31 de                     	xorl	%r11d, %r14d
    5666: 03 4d 88                     	addl	-0x78(%rbp), %ecx
    5669: 44 01 f1                     	addl	%r14d, %ecx
    566c: 45 89 ce                     	movl	%r9d, %r14d
    566f: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5673: 41 01 ca                     	addl	%ecx, %r10d
    5676: 41 81 c2 85 35 0e f4         	addl	$0xf40e3585, %r10d      # imm = 0xF40E3585
    567d: 44 89 c9                     	movl	%r9d, %ecx
    5680: c1 c1 13                     	roll	$0x13, %ecx
    5683: 44 01 d0                     	addl	%r10d, %eax
    5686: 45 89 cf                     	movl	%r9d, %r15d
    5689: 41 c1 c7 0a                  	roll	$0xa, %r15d
    568d: 44 31 f1                     	xorl	%r14d, %ecx
    5690: 41 31 cf                     	xorl	%ecx, %r15d
    5693: 45 89 c6                     	movl	%r8d, %r14d
    5696: 41 09 de                     	orl	%ebx, %r14d
    5699: 45 21 ce                     	andl	%r9d, %r14d
    569c: 44 89 c1                     	movl	%r8d, %ecx
    569f: 21 d9                        	andl	%ebx, %ecx
    56a1: 44 09 f1                     	orl	%r14d, %ecx
    56a4: 44 01 f9                     	addl	%r15d, %ecx
    56a7: 41 89 c6                     	movl	%eax, %r14d
    56aa: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    56ae: 44 01 d1                     	addl	%r10d, %ecx
    56b1: 41 89 c2                     	movl	%eax, %r10d
    56b4: 41 c1 c2 15                  	roll	$0x15, %r10d
    56b8: 45 31 f2                     	xorl	%r14d, %r10d
    56bb: 41 89 c6                     	movl	%eax, %r14d
    56be: 41 c1 c6 07                  	roll	$0x7, %r14d
    56c2: 45 31 d6                     	xorl	%r10d, %r14d
    56c5: 41 89 f2                     	movl	%esi, %r10d
    56c8: 41 31 d2                     	xorl	%edx, %r10d
    56cb: 41 21 c2                     	andl	%eax, %r10d
    56ce: 41 31 d2                     	xorl	%edx, %r10d
    56d1: 44 03 5d 8c                  	addl	-0x74(%rbp), %r11d
    56d5: 45 01 d3                     	addl	%r10d, %r11d
    56d8: 47 8d 14 1e                  	leal	(%r14,%r11), %r10d
    56dc: 41 81 c2 70 a0 6a 10         	addl	$0x106aa070, %r10d      # imm = 0x106AA070
    56e3: 41 89 cb                     	movl	%ecx, %r11d
    56e6: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    56ea: 44 01 d3                     	addl	%r10d, %ebx
    56ed: 41 89 ce                     	movl	%ecx, %r14d
    56f0: 41 c1 c6 13                  	roll	$0x13, %r14d
    56f4: 45 31 de                     	xorl	%r11d, %r14d
    56f7: 41 89 cf                     	movl	%ecx, %r15d
    56fa: 41 c1 c7 0a                  	roll	$0xa, %r15d
    56fe: 45 31 f7                     	xorl	%r14d, %r15d
    5701: 45 89 ce                     	movl	%r9d, %r14d
    5704: 45 09 c6                     	orl	%r8d, %r14d
    5707: 41 21 ce                     	andl	%ecx, %r14d
    570a: 45 89 cb                     	movl	%r9d, %r11d
    570d: 45 21 c3                     	andl	%r8d, %r11d
    5710: 45 09 f3                     	orl	%r14d, %r11d
    5713: 45 01 fb                     	addl	%r15d, %r11d
    5716: 45 01 d3                     	addl	%r10d, %r11d
    5719: 41 89 da                     	movl	%ebx, %r10d
    571c: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    5720: 41 89 de                     	movl	%ebx, %r14d
    5723: 41 c1 c6 15                  	roll	$0x15, %r14d
    5727: 45 31 d6                     	xorl	%r10d, %r14d
    572a: 41 89 da                     	movl	%ebx, %r10d
    572d: 41 c1 c2 07                  	roll	$0x7, %r10d
    5731: 45 31 f2                     	xorl	%r14d, %r10d
    5734: 41 89 c6                     	movl	%eax, %r14d
    5737: 41 31 f6                     	xorl	%esi, %r14d
    573a: 41 21 de                     	andl	%ebx, %r14d
    573d: 41 31 f6                     	xorl	%esi, %r14d
    5740: 03 55 90                     	addl	-0x70(%rbp), %edx
    5743: 44 01 f2                     	addl	%r14d, %edx
    5746: 44 01 d2                     	addl	%r10d, %edx
    5749: 81 c2 16 c1 a4 19            	addl	$0x19a4c116, %edx       # imm = 0x19A4C116
    574f: 41 01 d0                     	addl	%edx, %r8d
    5752: 45 89 da                     	movl	%r11d, %r10d
    5755: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5759: 45 89 de                     	movl	%r11d, %r14d
    575c: 41 c1 c6 13                  	roll	$0x13, %r14d
    5760: 45 31 d6                     	xorl	%r10d, %r14d
    5763: 45 89 df                     	movl	%r11d, %r15d
    5766: 41 c1 c7 0a                  	roll	$0xa, %r15d
    576a: 45 31 f7                     	xorl	%r14d, %r15d
    576d: 41 89 ce                     	movl	%ecx, %r14d
    5770: 45 09 ce                     	orl	%r9d, %r14d
    5773: 45 21 de                     	andl	%r11d, %r14d
    5776: 41 89 ca                     	movl	%ecx, %r10d
    5779: 45 21 ca                     	andl	%r9d, %r10d
    577c: 45 09 f2                     	orl	%r14d, %r10d
    577f: 45 01 fa                     	addl	%r15d, %r10d
    5782: 41 01 d2                     	addl	%edx, %r10d
    5785: 44 89 c2                     	movl	%r8d, %edx
    5788: c1 c2 1a                     	roll	$0x1a, %edx
    578b: 45 89 c6                     	movl	%r8d, %r14d
    578e: 41 c1 c6 15                  	roll	$0x15, %r14d
    5792: 41 31 d6                     	xorl	%edx, %r14d
    5795: 44 89 c2                     	movl	%r8d, %edx
    5798: c1 c2 07                     	roll	$0x7, %edx
    579b: 44 31 f2                     	xorl	%r14d, %edx
    579e: 41 89 de                     	movl	%ebx, %r14d
    57a1: 41 31 c6                     	xorl	%eax, %r14d
    57a4: 45 21 c6                     	andl	%r8d, %r14d
    57a7: 03 75 94                     	addl	-0x6c(%rbp), %esi
    57aa: 41 31 c6                     	xorl	%eax, %r14d
    57ad: 44 01 f6                     	addl	%r14d, %esi
    57b0: 01 f2                        	addl	%esi, %edx
    57b2: 81 c2 08 6c 37 1e            	addl	$0x1e376c08, %edx       # imm = 0x1E376C08
    57b8: 41 01 d1                     	addl	%edx, %r9d
    57bb: 44 89 d6                     	movl	%r10d, %esi
    57be: c1 c6 1e                     	roll	$0x1e, %esi
    57c1: 45 89 d6                     	movl	%r10d, %r14d
    57c4: 41 c1 c6 13                  	roll	$0x13, %r14d
    57c8: 41 31 f6                     	xorl	%esi, %r14d
    57cb: 45 89 d7                     	movl	%r10d, %r15d
    57ce: 41 c1 c7 0a                  	roll	$0xa, %r15d
    57d2: 45 31 f7                     	xorl	%r14d, %r15d
    57d5: 45 89 de                     	movl	%r11d, %r14d
    57d8: 41 09 ce                     	orl	%ecx, %r14d
    57db: 45 21 d6                     	andl	%r10d, %r14d
    57de: 44 89 de                     	movl	%r11d, %esi
    57e1: 21 ce                        	andl	%ecx, %esi
    57e3: 44 09 f6                     	orl	%r14d, %esi
    57e6: 45 89 ce                     	movl	%r9d, %r14d
    57e9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    57ed: 44 01 fe                     	addl	%r15d, %esi
    57f0: 45 89 cf                     	movl	%r9d, %r15d
    57f3: 41 c1 c7 15                  	roll	$0x15, %r15d
    57f7: 01 d6                        	addl	%edx, %esi
    57f9: 44 89 ca                     	movl	%r9d, %edx
    57fc: c1 c2 07                     	roll	$0x7, %edx
    57ff: 45 31 f7                     	xorl	%r14d, %r15d
    5802: 44 31 fa                     	xorl	%r15d, %edx
    5805: 45 89 c6                     	movl	%r8d, %r14d
    5808: 41 31 de                     	xorl	%ebx, %r14d
    580b: 45 21 ce                     	andl	%r9d, %r14d
    580e: 41 31 de                     	xorl	%ebx, %r14d
    5811: 03 45 98                     	addl	-0x68(%rbp), %eax
    5814: 44 01 f0                     	addl	%r14d, %eax
    5817: 41 89 f6                     	movl	%esi, %r14d
    581a: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    581e: 01 d0                        	addl	%edx, %eax
    5820: 05 4c 77 48 27               	addl	$0x2748774c, %eax       # imm = 0x2748774C
    5825: 89 f2                        	movl	%esi, %edx
    5827: c1 c2 13                     	roll	$0x13, %edx
    582a: 01 c1                        	addl	%eax, %ecx
    582c: 41 89 f7                     	movl	%esi, %r15d
    582f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5833: 44 31 f2                     	xorl	%r14d, %edx
    5836: 41 31 d7                     	xorl	%edx, %r15d
    5839: 45 89 d6                     	movl	%r10d, %r14d
    583c: 45 09 de                     	orl	%r11d, %r14d
    583f: 41 21 f6                     	andl	%esi, %r14d
    5842: 44 89 d2                     	movl	%r10d, %edx
    5845: 44 21 da                     	andl	%r11d, %edx
    5848: 44 09 f2                     	orl	%r14d, %edx
    584b: 44 01 fa                     	addl	%r15d, %edx
    584e: 41 89 ce                     	movl	%ecx, %r14d
    5851: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5855: 01 c2                        	addl	%eax, %edx
    5857: 89 c8                        	movl	%ecx, %eax
    5859: c1 c0 15                     	roll	$0x15, %eax
    585c: 44 31 f0                     	xorl	%r14d, %eax
    585f: 41 89 ce                     	movl	%ecx, %r14d
    5862: 41 c1 c6 07                  	roll	$0x7, %r14d
    5866: 41 31 c6                     	xorl	%eax, %r14d
    5869: 44 89 c8                     	movl	%r9d, %eax
    586c: 44 31 c0                     	xorl	%r8d, %eax
    586f: 21 c8                        	andl	%ecx, %eax
    5871: 44 31 c0                     	xorl	%r8d, %eax
    5874: 03 5d 9c                     	addl	-0x64(%rbp), %ebx
    5877: 01 c3                        	addl	%eax, %ebx
    5879: 41 8d 04 1e                  	leal	(%r14,%rbx), %eax
    587d: 05 b5 bc b0 34               	addl	$0x34b0bcb5, %eax       # imm = 0x34B0BCB5
    5882: 89 d3                        	movl	%edx, %ebx
    5884: c1 c3 1e                     	roll	$0x1e, %ebx
    5887: 41 01 c3                     	addl	%eax, %r11d
    588a: 41 89 d6                     	movl	%edx, %r14d
    588d: 41 c1 c6 13                  	roll	$0x13, %r14d
    5891: 41 31 de                     	xorl	%ebx, %r14d
    5894: 41 89 d7                     	movl	%edx, %r15d
    5897: 41 c1 c7 0a                  	roll	$0xa, %r15d
    589b: 45 31 f7                     	xorl	%r14d, %r15d
    589e: 41 89 f6                     	movl	%esi, %r14d
    58a1: 45 09 d6                     	orl	%r10d, %r14d
    58a4: 41 21 d6                     	andl	%edx, %r14d
    58a7: 89 f3                        	movl	%esi, %ebx
    58a9: 44 21 d3                     	andl	%r10d, %ebx
    58ac: 44 09 f3                     	orl	%r14d, %ebx
    58af: 44 01 fb                     	addl	%r15d, %ebx
    58b2: 01 c3                        	addl	%eax, %ebx
    58b4: 44 89 d8                     	movl	%r11d, %eax
    58b7: c1 c0 1a                     	roll	$0x1a, %eax
    58ba: 45 89 de                     	movl	%r11d, %r14d
    58bd: 41 c1 c6 15                  	roll	$0x15, %r14d
    58c1: 41 31 c6                     	xorl	%eax, %r14d
    58c4: 44 89 d8                     	movl	%r11d, %eax
    58c7: c1 c0 07                     	roll	$0x7, %eax
    58ca: 44 31 f0                     	xorl	%r14d, %eax
    58cd: 41 89 ce                     	movl	%ecx, %r14d
    58d0: 45 31 ce                     	xorl	%r9d, %r14d
    58d3: 45 21 de                     	andl	%r11d, %r14d
    58d6: 45 31 ce                     	xorl	%r9d, %r14d
    58d9: 44 03 45 a0                  	addl	-0x60(%rbp), %r8d
    58dd: 45 01 f0                     	addl	%r14d, %r8d
    58e0: 44 01 c0                     	addl	%r8d, %eax
    58e3: 05 b3 0c 1c 39               	addl	$0x391c0cb3, %eax       # imm = 0x391C0CB3
    58e8: 41 01 c2                     	addl	%eax, %r10d
    58eb: 41 89 d8                     	movl	%ebx, %r8d
    58ee: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    58f2: 41 89 de                     	movl	%ebx, %r14d
    58f5: 41 c1 c6 13                  	roll	$0x13, %r14d
    58f9: 45 31 c6                     	xorl	%r8d, %r14d
    58fc: 41 89 df                     	movl	%ebx, %r15d
    58ff: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5903: 45 31 f7                     	xorl	%r14d, %r15d
    5906: 41 89 d6                     	movl	%edx, %r14d
    5909: 41 09 f6                     	orl	%esi, %r14d
    590c: 41 21 de                     	andl	%ebx, %r14d
    590f: 41 89 d0                     	movl	%edx, %r8d
    5912: 41 21 f0                     	andl	%esi, %r8d
    5915: 45 09 f0                     	orl	%r14d, %r8d
    5918: 45 01 f8                     	addl	%r15d, %r8d
    591b: 41 01 c0                     	addl	%eax, %r8d
    591e: 44 89 d0                     	movl	%r10d, %eax
    5921: c1 c0 1a                     	roll	$0x1a, %eax
    5924: 45 89 d6                     	movl	%r10d, %r14d
    5927: 41 c1 c6 15                  	roll	$0x15, %r14d
    592b: 41 31 c6                     	xorl	%eax, %r14d
    592e: 44 89 d0                     	movl	%r10d, %eax
    5931: c1 c0 07                     	roll	$0x7, %eax
    5934: 44 31 f0                     	xorl	%r14d, %eax
    5937: 45 89 de                     	movl	%r11d, %r14d
    593a: 41 31 ce                     	xorl	%ecx, %r14d
    593d: 45 21 d6                     	andl	%r10d, %r14d
    5940: 44 03 4d a4                  	addl	-0x5c(%rbp), %r9d
    5944: 41 31 ce                     	xorl	%ecx, %r14d
    5947: 45 01 f1                     	addl	%r14d, %r9d
    594a: 44 01 c8                     	addl	%r9d, %eax
    594d: 05 4a aa d8 4e               	addl	$0x4ed8aa4a, %eax       # imm = 0x4ED8AA4A
    5952: 01 c6                        	addl	%eax, %esi
    5954: 45 89 c1                     	movl	%r8d, %r9d
    5957: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    595b: 45 89 c6                     	movl	%r8d, %r14d
    595e: 41 c1 c6 13                  	roll	$0x13, %r14d
    5962: 45 31 ce                     	xorl	%r9d, %r14d
    5965: 45 89 c7                     	movl	%r8d, %r15d
    5968: 41 c1 c7 0a                  	roll	$0xa, %r15d
    596c: 45 31 f7                     	xorl	%r14d, %r15d
    596f: 41 89 de                     	movl	%ebx, %r14d
    5972: 41 09 d6                     	orl	%edx, %r14d
    5975: 45 21 c6                     	andl	%r8d, %r14d
    5978: 41 89 d9                     	movl	%ebx, %r9d
    597b: 41 21 d1                     	andl	%edx, %r9d
    597e: 45 09 f1                     	orl	%r14d, %r9d
    5981: 41 89 f6                     	movl	%esi, %r14d
    5984: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5988: 45 01 f9                     	addl	%r15d, %r9d
    598b: 41 89 f7                     	movl	%esi, %r15d
    598e: 41 c1 c7 15                  	roll	$0x15, %r15d
    5992: 41 01 c1                     	addl	%eax, %r9d
    5995: 89 f0                        	movl	%esi, %eax
    5997: c1 c0 07                     	roll	$0x7, %eax
    599a: 45 31 f7                     	xorl	%r14d, %r15d
    599d: 44 31 f8                     	xorl	%r15d, %eax
    59a0: 45 89 d6                     	movl	%r10d, %r14d
    59a3: 45 31 de                     	xorl	%r11d, %r14d
    59a6: 41 21 f6                     	andl	%esi, %r14d
    59a9: 45 31 de                     	xorl	%r11d, %r14d
    59ac: 03 4d a8                     	addl	-0x58(%rbp), %ecx
    59af: 44 01 f1                     	addl	%r14d, %ecx
    59b2: 45 89 ce                     	movl	%r9d, %r14d
    59b5: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    59b9: 01 c8                        	addl	%ecx, %eax
    59bb: 05 4f ca 9c 5b               	addl	$0x5b9cca4f, %eax       # imm = 0x5B9CCA4F
    59c0: 44 89 c9                     	movl	%r9d, %ecx
    59c3: c1 c1 13                     	roll	$0x13, %ecx
    59c6: 01 c2                        	addl	%eax, %edx
    59c8: 45 89 cf                     	movl	%r9d, %r15d
    59cb: 41 c1 c7 0a                  	roll	$0xa, %r15d
    59cf: 44 31 f1                     	xorl	%r14d, %ecx
    59d2: 41 31 cf                     	xorl	%ecx, %r15d
    59d5: 44 89 c1                     	movl	%r8d, %ecx
    59d8: 09 d9                        	orl	%ebx, %ecx
    59da: 44 21 c9                     	andl	%r9d, %ecx
    59dd: 45 89 c6                     	movl	%r8d, %r14d
    59e0: 41 21 de                     	andl	%ebx, %r14d
    59e3: 41 09 ce                     	orl	%ecx, %r14d
    59e6: 45 01 fe                     	addl	%r15d, %r14d
    59e9: 89 d1                        	movl	%edx, %ecx
    59eb: c1 c1 1a                     	roll	$0x1a, %ecx
    59ee: 41 01 c6                     	addl	%eax, %r14d
    59f1: 89 d0                        	movl	%edx, %eax
    59f3: c1 c0 15                     	roll	$0x15, %eax
    59f6: 31 c8                        	xorl	%ecx, %eax
    59f8: 89 d1                        	movl	%edx, %ecx
    59fa: c1 c1 07                     	roll	$0x7, %ecx
    59fd: 31 c1                        	xorl	%eax, %ecx
    59ff: 89 f0                        	movl	%esi, %eax
    5a01: 44 31 d0                     	xorl	%r10d, %eax
    5a04: 21 d0                        	andl	%edx, %eax
    5a06: 44 31 d0                     	xorl	%r10d, %eax
    5a09: 44 03 5d ac                  	addl	-0x54(%rbp), %r11d
    5a0d: 41 01 c3                     	addl	%eax, %r11d
    5a10: 42 8d 04 19                  	leal	(%rcx,%r11), %eax
    5a14: 05 f3 6f 2e 68               	addl	$0x682e6ff3, %eax       # imm = 0x682E6FF3
    5a19: 44 89 f1                     	movl	%r14d, %ecx
    5a1c: c1 c1 1e                     	roll	$0x1e, %ecx
    5a1f: 01 c3                        	addl	%eax, %ebx
    5a21: 45 89 f3                     	movl	%r14d, %r11d
    5a24: 41 c1 c3 13                  	roll	$0x13, %r11d
    5a28: 41 31 cb                     	xorl	%ecx, %r11d
    5a2b: 45 89 f7                     	movl	%r14d, %r15d
    5a2e: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5a32: 45 31 df                     	xorl	%r11d, %r15d
    5a35: 45 89 cb                     	movl	%r9d, %r11d
    5a38: 45 09 c3                     	orl	%r8d, %r11d
    5a3b: 45 21 f3                     	andl	%r14d, %r11d
    5a3e: 44 89 c9                     	movl	%r9d, %ecx
    5a41: 44 21 c1                     	andl	%r8d, %ecx
    5a44: 44 09 d9                     	orl	%r11d, %ecx
    5a47: 44 01 f9                     	addl	%r15d, %ecx
    5a4a: 01 c1                        	addl	%eax, %ecx
    5a4c: 89 d8                        	movl	%ebx, %eax
    5a4e: c1 c0 1a                     	roll	$0x1a, %eax
    5a51: 41 89 db                     	movl	%ebx, %r11d
    5a54: 41 c1 c3 15                  	roll	$0x15, %r11d
    5a58: 41 31 c3                     	xorl	%eax, %r11d
    5a5b: 89 d8                        	movl	%ebx, %eax
    5a5d: c1 c0 07                     	roll	$0x7, %eax
    5a60: 44 31 d8                     	xorl	%r11d, %eax
    5a63: 41 89 d3                     	movl	%edx, %r11d
    5a66: 41 31 f3                     	xorl	%esi, %r11d
    5a69: 41 21 db                     	andl	%ebx, %r11d
    5a6c: 41 31 f3                     	xorl	%esi, %r11d
    5a6f: 44 03 55 b0                  	addl	-0x50(%rbp), %r10d
    5a73: 45 01 da                     	addl	%r11d, %r10d
    5a76: 41 01 c2                     	addl	%eax, %r10d
    5a79: 41 81 c2 ee 82 8f 74         	addl	$0x748f82ee, %r10d      # imm = 0x748F82EE
    5a80: 45 01 d0                     	addl	%r10d, %r8d
    5a83: 89 c8                        	movl	%ecx, %eax
    5a85: c1 c0 1e                     	roll	$0x1e, %eax
    5a88: 41 89 cb                     	movl	%ecx, %r11d
    5a8b: 41 c1 c3 13                  	roll	$0x13, %r11d
    5a8f: 41 31 c3                     	xorl	%eax, %r11d
    5a92: 41 89 cf                     	movl	%ecx, %r15d
    5a95: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5a99: 45 31 df                     	xorl	%r11d, %r15d
    5a9c: 45 89 f3                     	movl	%r14d, %r11d
    5a9f: 45 09 cb                     	orl	%r9d, %r11d
    5aa2: 41 21 cb                     	andl	%ecx, %r11d
    5aa5: 44 89 f0                     	movl	%r14d, %eax
    5aa8: 44 21 c8                     	andl	%r9d, %eax
    5aab: 44 09 d8                     	orl	%r11d, %eax
    5aae: 44 01 f8                     	addl	%r15d, %eax
    5ab1: 44 01 d0                     	addl	%r10d, %eax
    5ab4: 45 89 c2                     	movl	%r8d, %r10d
    5ab7: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    5abb: 45 89 c3                     	movl	%r8d, %r11d
    5abe: 41 c1 c3 15                  	roll	$0x15, %r11d
    5ac2: 45 31 d3                     	xorl	%r10d, %r11d
    5ac5: 45 89 c2                     	movl	%r8d, %r10d
    5ac8: 41 c1 c2 07                  	roll	$0x7, %r10d
    5acc: 45 31 da                     	xorl	%r11d, %r10d
    5acf: 41 89 db                     	movl	%ebx, %r11d
    5ad2: 41 31 d3                     	xorl	%edx, %r11d
    5ad5: 45 21 c3                     	andl	%r8d, %r11d
    5ad8: 03 75 b4                     	addl	-0x4c(%rbp), %esi
    5adb: 41 31 d3                     	xorl	%edx, %r11d
    5ade: 44 01 de                     	addl	%r11d, %esi
    5ae1: 41 01 f2                     	addl	%esi, %r10d
    5ae4: 41 81 c2 6f 63 a5 78         	addl	$0x78a5636f, %r10d      # imm = 0x78A5636F
    5aeb: 45 01 d1                     	addl	%r10d, %r9d
    5aee: 89 c6                        	movl	%eax, %esi
    5af0: c1 c6 1e                     	roll	$0x1e, %esi
    5af3: 41 89 c3                     	movl	%eax, %r11d
    5af6: 41 c1 c3 13                  	roll	$0x13, %r11d
    5afa: 41 31 f3                     	xorl	%esi, %r11d
    5afd: 41 89 c7                     	movl	%eax, %r15d
    5b00: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5b04: 45 31 df                     	xorl	%r11d, %r15d
    5b07: 41 89 cb                     	movl	%ecx, %r11d
    5b0a: 45 09 f3                     	orl	%r14d, %r11d
    5b0d: 41 21 c3                     	andl	%eax, %r11d
    5b10: 89 ce                        	movl	%ecx, %esi
    5b12: 44 21 f6                     	andl	%r14d, %esi
    5b15: 44 09 de                     	orl	%r11d, %esi
    5b18: 45 89 cb                     	movl	%r9d, %r11d
    5b1b: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5b1f: 44 01 fe                     	addl	%r15d, %esi
    5b22: 45 89 cf                     	movl	%r9d, %r15d
    5b25: 41 c1 c7 15                  	roll	$0x15, %r15d
    5b29: 44 01 d6                     	addl	%r10d, %esi
    5b2c: 45 89 ca                     	movl	%r9d, %r10d
    5b2f: 41 c1 c2 07                  	roll	$0x7, %r10d
    5b33: 45 31 df                     	xorl	%r11d, %r15d
    5b36: 45 31 fa                     	xorl	%r15d, %r10d
    5b39: 45 89 c3                     	movl	%r8d, %r11d
    5b3c: 41 31 db                     	xorl	%ebx, %r11d
    5b3f: 45 21 cb                     	andl	%r9d, %r11d
    5b42: 41 31 db                     	xorl	%ebx, %r11d
    5b45: 03 55 b8                     	addl	-0x48(%rbp), %edx
    5b48: 44 01 da                     	addl	%r11d, %edx
    5b4b: 41 89 f3                     	movl	%esi, %r11d
    5b4e: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    5b52: 41 01 d2                     	addl	%edx, %r10d
    5b55: 41 81 c2 14 78 c8 84         	addl	$0x84c87814, %r10d      # imm = 0x84C87814
    5b5c: 89 f2                        	movl	%esi, %edx
    5b5e: c1 c2 13                     	roll	$0x13, %edx
    5b61: 45 01 d6                     	addl	%r10d, %r14d
    5b64: 41 89 f7                     	movl	%esi, %r15d
    5b67: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5b6b: 44 31 da                     	xorl	%r11d, %edx
    5b6e: 41 31 d7                     	xorl	%edx, %r15d
    5b71: 41 89 c3                     	movl	%eax, %r11d
    5b74: 41 09 cb                     	orl	%ecx, %r11d
    5b77: 41 21 f3                     	andl	%esi, %r11d
    5b7a: 89 c2                        	movl	%eax, %edx
    5b7c: 21 ca                        	andl	%ecx, %edx
    5b7e: 44 09 da                     	orl	%r11d, %edx
    5b81: 44 01 fa                     	addl	%r15d, %edx
    5b84: 45 89 f3                     	movl	%r14d, %r11d
    5b87: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5b8b: 44 01 d2                     	addl	%r10d, %edx
    5b8e: 45 89 f2                     	movl	%r14d, %r10d
    5b91: 41 c1 c2 15                  	roll	$0x15, %r10d
    5b95: 45 31 da                     	xorl	%r11d, %r10d
    5b98: 45 89 f3                     	movl	%r14d, %r11d
    5b9b: 41 c1 c3 07                  	roll	$0x7, %r11d
    5b9f: 45 31 d3                     	xorl	%r10d, %r11d
    5ba2: 45 89 ca                     	movl	%r9d, %r10d
    5ba5: 45 31 c2                     	xorl	%r8d, %r10d
    5ba8: 45 21 f2                     	andl	%r14d, %r10d
    5bab: 45 31 c2                     	xorl	%r8d, %r10d
    5bae: 03 5d bc                     	addl	-0x44(%rbp), %ebx
    5bb1: 44 01 d3                     	addl	%r10d, %ebx
    5bb4: 41 01 db                     	addl	%ebx, %r11d
    5bb7: 41 81 c3 08 02 c7 8c         	addl	$0x8cc70208, %r11d      # imm = 0x8CC70208
    5bbe: 41 89 d2                     	movl	%edx, %r10d
    5bc1: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5bc5: 44 01 d9                     	addl	%r11d, %ecx
    5bc8: 89 d3                        	movl	%edx, %ebx
    5bca: c1 c3 13                     	roll	$0x13, %ebx
    5bcd: 44 31 d3                     	xorl	%r10d, %ebx
    5bd0: 41 89 d7                     	movl	%edx, %r15d
    5bd3: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5bd7: 41 31 df                     	xorl	%ebx, %r15d
    5bda: 89 f3                        	movl	%esi, %ebx
    5bdc: 09 c3                        	orl	%eax, %ebx
    5bde: 21 d3                        	andl	%edx, %ebx
    5be0: 41 89 f2                     	movl	%esi, %r10d
    5be3: 41 21 c2                     	andl	%eax, %r10d
    5be6: 41 09 da                     	orl	%ebx, %r10d
    5be9: 45 01 fa                     	addl	%r15d, %r10d
    5bec: 45 01 da                     	addl	%r11d, %r10d
    5bef: 41 89 cb                     	movl	%ecx, %r11d
    5bf2: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5bf6: 89 cb                        	movl	%ecx, %ebx
    5bf8: c1 c3 15                     	roll	$0x15, %ebx
    5bfb: 44 31 db                     	xorl	%r11d, %ebx
    5bfe: 41 89 cb                     	movl	%ecx, %r11d
    5c01: 41 c1 c3 07                  	roll	$0x7, %r11d
    5c05: 41 31 db                     	xorl	%ebx, %r11d
    5c08: 44 89 f3                     	movl	%r14d, %ebx
    5c0b: 44 31 cb                     	xorl	%r9d, %ebx
    5c0e: 21 cb                        	andl	%ecx, %ebx
    5c10: 44 31 cb                     	xorl	%r9d, %ebx
    5c13: 44 03 45 c0                  	addl	-0x40(%rbp), %r8d
    5c17: 41 01 d8                     	addl	%ebx, %r8d
    5c1a: 45 01 c3                     	addl	%r8d, %r11d
    5c1d: 41 81 c3 fa ff be 90         	addl	$0x90befffa, %r11d      # imm = 0x90BEFFFA
    5c24: 45 89 d0                     	movl	%r10d, %r8d
    5c27: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5c2b: 44 89 d3                     	movl	%r10d, %ebx
    5c2e: c1 c3 13                     	roll	$0x13, %ebx
    5c31: 44 31 c3                     	xorl	%r8d, %ebx
    5c34: 45 89 d7                     	movl	%r10d, %r15d
    5c37: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5c3b: 41 31 df                     	xorl	%ebx, %r15d
    5c3e: 89 d3                        	movl	%edx, %ebx
    5c40: 09 f3                        	orl	%esi, %ebx
    5c42: 44 21 d3                     	andl	%r10d, %ebx
    5c45: 41 89 d0                     	movl	%edx, %r8d
    5c48: 41 21 f0                     	andl	%esi, %r8d
    5c4b: 41 09 d8                     	orl	%ebx, %r8d
    5c4e: 45 01 f8                     	addl	%r15d, %r8d
    5c51: 89 cb                        	movl	%ecx, %ebx
    5c53: 44 31 f3                     	xorl	%r14d, %ebx
    5c56: 44 03 4d c4                  	addl	-0x3c(%rbp), %r9d
    5c5a: 44 01 d8                     	addl	%r11d, %eax
    5c5d: 21 c3                        	andl	%eax, %ebx
    5c5f: 44 31 f3                     	xorl	%r14d, %ebx
    5c62: 44 01 cb                     	addl	%r9d, %ebx
    5c65: 44 03 75 c8                  	addl	-0x38(%rbp), %r14d
    5c69: 41 89 c1                     	movl	%eax, %r9d
    5c6c: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    5c70: 41 89 c7                     	movl	%eax, %r15d
    5c73: 41 c1 c7 15                  	roll	$0x15, %r15d
    5c77: 45 31 cf                     	xorl	%r9d, %r15d
    5c7a: 41 89 c1                     	movl	%eax, %r9d
    5c7d: 41 c1 c1 07                  	roll	$0x7, %r9d
    5c81: 45 31 f9                     	xorl	%r15d, %r9d
    5c84: 41 01 d9                     	addl	%ebx, %r9d
    5c87: 41 81 c1 eb 6c 50 a4         	addl	$0xa4506ceb, %r9d       # imm = 0xA4506CEB
    5c8e: 44 01 ce                     	addl	%r9d, %esi
    5c91: 89 c3                        	movl	%eax, %ebx
    5c93: 31 cb                        	xorl	%ecx, %ebx
    5c95: 21 f3                        	andl	%esi, %ebx
    5c97: 31 cb                        	xorl	%ecx, %ebx
    5c99: 44 01 f3                     	addl	%r14d, %ebx
    5c9c: 41 89 f6                     	movl	%esi, %r14d
    5c9f: 41 89 f7                     	movl	%esi, %r15d
    5ca2: 41 c1 c7 1a                  	roll	$0x1a, %r15d
    5ca6: 41 c1 c6 15                  	roll	$0x15, %r14d
    5caa: 45 31 fe                     	xorl	%r15d, %r14d
    5cad: 41 89 f7                     	movl	%esi, %r15d
    5cb0: 66 0f 6e c6                  	movd	%esi, %xmm0
    5cb4: 41 89 f4                     	movl	%esi, %r12d
    5cb7: 41 c1 c7 07                  	roll	$0x7, %r15d
    5cbb: 45 31 f7                     	xorl	%r14d, %r15d
    5cbe: 44 89 d6                     	movl	%r10d, %esi
    5cc1: 09 d6                        	orl	%edx, %esi
    5cc3: 44 01 fb                     	addl	%r15d, %ebx
    5cc6: 81 c3 f7 a3 f9 be            	addl	$0xbef9a3f7, %ebx       # imm = 0xBEF9A3F7
    5ccc: 45 89 d6                     	movl	%r10d, %r14d
    5ccf: 41 21 d6                     	andl	%edx, %r14d
    5cd2: 03 4d cc                     	addl	-0x34(%rbp), %ecx
    5cd5: 01 da                        	addl	%ebx, %edx
    5cd7: 41 31 c4                     	xorl	%eax, %r12d
    5cda: 41 21 d4                     	andl	%edx, %r12d
    5cdd: 41 31 c4                     	xorl	%eax, %r12d
    5ce0: 41 01 cc                     	addl	%ecx, %r12d
    5ce3: 45 01 d8                     	addl	%r11d, %r8d
    5ce6: 44 89 c1                     	movl	%r8d, %ecx
    5ce9: c1 c1 1e                     	roll	$0x1e, %ecx
    5cec: 45 89 c3                     	movl	%r8d, %r11d
    5cef: 41 c1 c3 13                  	roll	$0x13, %r11d
    5cf3: 41 31 cb                     	xorl	%ecx, %r11d
    5cf6: 44 89 c1                     	movl	%r8d, %ecx
    5cf9: c1 c1 0a                     	roll	$0xa, %ecx
    5cfc: 44 31 d9                     	xorl	%r11d, %ecx
    5cff: 44 21 c6                     	andl	%r8d, %esi
    5d02: 44 09 f6                     	orl	%r14d, %esi
    5d05: 01 ce                        	addl	%ecx, %esi
    5d07: 89 d1                        	movl	%edx, %ecx
    5d09: 41 89 d3                     	movl	%edx, %r11d
    5d0c: 66 0f 6e ca                  	movd	%edx, %xmm1
    5d10: c1 c2 1a                     	roll	$0x1a, %edx
    5d13: c1 c1 15                     	roll	$0x15, %ecx
    5d16: 41 c1 c3 07                  	roll	$0x7, %r11d
    5d1a: 31 d1                        	xorl	%edx, %ecx
    5d1c: 41 31 cb                     	xorl	%ecx, %r11d
    5d1f: 44 89 c2                     	movl	%r8d, %edx
    5d22: 44 09 d2                     	orl	%r10d, %edx
    5d25: 44 01 ce                     	addl	%r9d, %esi
    5d28: 41 89 f1                     	movl	%esi, %r9d
    5d2b: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5d2f: 43 8d 0c 23                  	leal	(%r11,%r12), %ecx
    5d33: 81 c1 f2 78 71 c6            	addl	$0xc67178f2, %ecx       # imm = 0xC67178F2
    5d39: 41 89 f3                     	movl	%esi, %r11d
    5d3c: 41 c1 c3 13                  	roll	$0x13, %r11d
    5d40: 45 31 cb                     	xorl	%r9d, %r11d
    5d43: 41 89 f1                     	movl	%esi, %r9d
    5d46: 41 c1 c1 0a                  	roll	$0xa, %r9d
    5d4a: 45 31 d9                     	xorl	%r11d, %r9d
    5d4d: 21 f2                        	andl	%esi, %edx
    5d4f: 41 89 f3                     	movl	%esi, %r11d
    5d52: 45 09 c3                     	orl	%r8d, %r11d
    5d55: 66 0f 6e d6                  	movd	%esi, %xmm2
    5d59: 44 21 c6                     	andl	%r8d, %esi
    5d5c: 66 41 0f 6e d8               	movd	%r8d, %xmm3
    5d61: 45 21 d0                     	andl	%r10d, %r8d
    5d64: 44 09 c2                     	orl	%r8d, %edx
    5d67: 44 01 ca                     	addl	%r9d, %edx
    5d6a: 01 da                        	addl	%ebx, %edx
    5d6c: 41 89 d0                     	movl	%edx, %r8d
    5d6f: 41 89 d1                     	movl	%edx, %r9d
    5d72: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5d76: 41 c1 c0 13                  	roll	$0x13, %r8d
    5d7a: 45 31 c8                     	xorl	%r9d, %r8d
    5d7d: 41 21 d3                     	andl	%edx, %r11d
    5d80: 66 0f 6e e2                  	movd	%edx, %xmm4
    5d84: c1 c2 0a                     	roll	$0xa, %edx
    5d87: 44 31 c2                     	xorl	%r8d, %edx
    5d8a: 44 09 de                     	orl	%r11d, %esi
    5d8d: 01 d6                        	addl	%edx, %esi
    5d8f: 41 01 ca                     	addl	%ecx, %r10d
    5d92: 01 ce                        	addl	%ecx, %esi
    5d94: 66 0f 6e ee                  	movd	%esi, %xmm5
    5d98: 66 41 0f 6e f2               	movd	%r10d, %xmm6
    5d9d: 66 0f 62 ec                  	punpckldq	%xmm4, %xmm5    # xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
    5da1: 66 0f 62 d3                  	punpckldq	%xmm3, %xmm2    # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
    5da5: 66 0f 6c ea                  	punpcklqdq	%xmm2, %xmm5    # xmm5 = xmm5[0],xmm2[0]
    5da9: 66 0f fe 2f                  	paddd	(%rdi), %xmm5
    5dad: 66 0f 6e d0                  	movd	%eax, %xmm2
    5db1: 66 0f 7f 2f                  	movdqa	%xmm5, (%rdi)
    5db5: 66 0f 62 f1                  	punpckldq	%xmm1, %xmm6    # xmm6 = xmm6[0],xmm1[0],xmm6[1],xmm1[1]
    5db9: 66 0f 62 c2                  	punpckldq	%xmm2, %xmm0    # xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
    5dbd: 66 0f 6c f0                  	punpcklqdq	%xmm0, %xmm6    # xmm6 = xmm6[0],xmm0[0]
    5dc1: 66 0f fe 77 10               	paddd	0x10(%rdi), %xmm6
    5dc6: 66 0f 7f 77 10               	movdqa	%xmm6, 0x10(%rdi)
    5dcb: 48 81 c4 88 00 00 00         	addq	$0x88, %rsp
    5dd2: 5b                           	popq	%rbx
    5dd3: 41 5c                        	popq	%r12
    5dd5: 41 5d                        	popq	%r13
    5dd7: 41 5e                        	popq	%r14
    5dd9: 41 5f                        	popq	%r15
    5ddb: 5d                           	popq	%rbp
    5ddc: c3                           	retq
    5ddd: 0f 1f 00                     	nopl	(%rax)

0000000000005de0 <audit_master256>:
    5de0: 55                           	pushq	%rbp
    5de1: 48 89 e5                     	movq	%rsp, %rbp
    5de4: 41 56                        	pushq	%r14
    5de6: 53                           	pushq	%rbx
    5de7: 48 81 ec 50 01 00 00         	subq	$0x150, %rsp            # imm = 0x150
    5dee: 48 89 f3                     	movq	%rsi, %rbx
    5df1: 49 89 f8                     	movq	%rdi, %r8
    5df4: 66 c7 85 a0 fe ff ff 00 20   	movw	$0x2000, -0x160(%rbp)   # imm = 0x2000
    5dfd: c6 85 a2 fe ff ff 0d         	movb	$0xd, -0x15e(%rbp)
    5e04: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    5e0e: 48 89 85 a3 fe ff ff         	movq	%rax, -0x15d(%rbp)
    5e15: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    5e1f: 48 89 85 a8 fe ff ff         	movq	%rax, -0x158(%rbp)
    5e26: c6 85 b0 fe ff ff 20         	movb	$0x20, -0x150(%rbp)
    5e2d: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x54>
		0000000000005e30:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
    5e34: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    5e3b: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x62>
		0000000000005e3e:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
    5e42: 0f 11 85 c1 fe ff ff         	movups	%xmm0, -0x13f(%rbp)
    5e49: 4c 8d 75 d0                  	leaq	-0x30(%rbp), %r14
    5e4d: 48 8d 95 a0 fe ff ff         	leaq	-0x160(%rbp), %rdx
    5e54: be 20 00 00 00               	movl	$0x20, %esi
    5e59: b9 31 00 00 00               	movl	$0x31, %ecx
    5e5e: 4c 89 f7                     	movq	%r14, %rdi
    5e61: e8 5a da ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    5e66: 48 8d 7d b0                  	leaq	-0x50(%rbp), %rdi
    5e6a: ba 00 00 00 00               	movl	$0x0, %edx
		0000000000005e6b:  R_X86_64_32	.rodata.cst32
    5e6f: 4c 89 f6                     	movq	%r14, %rsi
    5e72: e8 29 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    5e77: 0f 57 c0                     	xorps	%xmm0, %xmm0
    5e7a: 0f 29 45 e0                  	movaps	%xmm0, -0x20(%rbp)
    5e7e: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    5e82: 0f 10 45 b0                  	movups	-0x50(%rbp), %xmm0
    5e86: 0f 10 4d c0                  	movups	-0x40(%rbp), %xmm1
    5e8a: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    5e8e: 0f 11 03                     	movups	%xmm0, (%rbx)
    5e91: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            # imm = 0x150
    5e98: 5b                           	popq	%rbx
    5e99: 41 5e                        	popq	%r14
    5e9b: 5d                           	popq	%rbp
    5e9c: c3                           	retq
    5e9d: 0f 1f 00                     	nopl	(%rax)

0000000000005ea0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
    5ea0: 55                           	pushq	%rbp
    5ea1: 48 89 e5                     	movq	%rsp, %rbp
    5ea4: 41 57                        	pushq	%r15
    5ea6: 41 56                        	pushq	%r14
    5ea8: 41 55                        	pushq	%r13
    5eaa: 41 54                        	pushq	%r12
    5eac: 53                           	pushq	%rbx
    5ead: 48 81 ec 88 01 00 00         	subq	$0x188, %rsp            # imm = 0x188
    5eb4: 49 89 d7                     	movq	%rdx, %r15
    5eb7: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    5ebb: 0f 10 06                     	movups	(%rsi), %xmm0
    5ebe: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    5ec2: 0f 29 4d a0                  	movaps	%xmm1, -0x60(%rbp)
    5ec6: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    5eca: 0f 57 c0                     	xorps	%xmm0, %xmm0
    5ecd: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    5ed1: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    5ed5: 31 c0                        	xorl	%eax, %eax
    5ed7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)
<L0>:
    5ee0: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    5ee5: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    5eea: 80 f1 5c                     	xorb	$0x5c, %cl
    5eed: 88 8c 05 e0 fe ff ff         	movb	%cl, -0x120(%rbp,%rax)
    5ef4: 80 f2 5c                     	xorb	$0x5c, %dl
    5ef7: 88 94 05 e1 fe ff ff         	movb	%dl, -0x11f(%rbp,%rax)
    5efe: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    5f03: 80 f1 5c                     	xorb	$0x5c, %cl
    5f06: 88 8c 05 e2 fe ff ff         	movb	%cl, -0x11e(%rbp,%rax)
    5f0d: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    5f12: 80 f1 5c                     	xorb	$0x5c, %cl
    5f15: 88 8c 05 e3 fe ff ff         	movb	%cl, -0x11d(%rbp,%rax)
    5f1c: 48 83 c0 04                  	addq	$0x4, %rax
    5f20: 48 83 f8 40                  	cmpq	$0x40, %rax
    5f24: 75 ba                        	jne	 <L0>
    5f26: b8 03 00 00 00               	movl	$0x3, %eax
    5f2b: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L1>:
    5f30: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    5f35: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    5f3a: 80 f1 36                     	xorb	$0x36, %cl
    5f3d: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    5f44: 80 f2 36                     	xorb	$0x36, %dl
    5f47: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    5f4e: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    5f53: 80 f1 36                     	xorb	$0x36, %cl
    5f56: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    5f5d: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    5f62: 80 f1 36                     	xorb	$0x36, %cl
    5f65: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    5f6c: 48 83 c0 04                  	addq	$0x4, %rax
    5f70: 48 83 f8 43                  	cmpq	$0x43, %rax
    5f74: 75 ba                        	jne	 <L1>
    5f76: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xdd>
		0000000000005f79:  R_X86_64_PC32	.rodata+0x1bc
    5f7d: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
    5f84: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xeb>
		0000000000005f87:  R_X86_64_PC32	.rodata+0x1ac
    5f8b: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    5f92: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xf9>
		0000000000005f95:  R_X86_64_PC32	.rodata+0x19c
    5f99: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
    5fa0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x107>
		0000000000005fa3:  R_X86_64_PC32	.rodata+0x18c
    5fa7: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    5fae: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x115>
		0000000000005fb1:  R_X86_64_PC32	.rodata+0x17c
    5fb5: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    5fbc: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x123>
		0000000000005fbf:  R_X86_64_PC32	.rodata+0x16c
    5fc3: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    5fca: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x131>
		0000000000005fcd:  R_X86_64_PC32	.rodata+0x15c
    5fd1: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    5fd8: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    5fdf: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    5fe6: e8 95 e1 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    5feb: 48 8b 9d 90 fe ff ff         	movq	-0x170(%rbp), %rbx
    5ff2: 48 83 c3 40                  	addq	$0x40, %rbx
    5ff6: 48 89 9d 90 fe ff ff         	movq	%rbx, -0x170(%rbp)
    5ffd: 0f b6 85 d8 fe ff ff         	movzbl	-0x128(%rbp), %eax
    6004: 48 85 c0                     	testq	%rax, %rax
    6007: 74 4b                        	je	 <L3>
    6009: 3c 20                        	cmpb	$0x20, %al
    600b: 72 49                        	jb	 <L4>
    600d: 41 bd 40 00 00 00            	movl	$0x40, %r13d
    6013: 49 29 c5                     	subq	%rax, %r13
    6016: 4c 8d a5 98 fe ff ff         	leaq	-0x168(%rbp), %r12
    601d: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    6021: 48 81 c7 98 fe ff ff         	addq	$-0x168, %rdi           # imm = 0xFE98
    6028: 4c 89 fe                     	movq	%r15, %rsi
    602b: 4c 89 ea                     	movq	%r13, %rdx
    602e: e8 00 00 00 00               	callq	 <L2>
		000000000000602f:  R_X86_64_PLT32	memcpy-0x4
<L2>:
    6033: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    603a: 4c 89 e6                     	movq	%r12, %rsi
    603d: e8 3e e1 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    6042: c6 85 d8 fe ff ff 00         	movb	$0x0, -0x128(%rbp)
    6049: 31 c0                        	xorl	%eax, %eax
    604b: 48 8b 9d 90 fe ff ff         	movq	-0x170(%rbp), %rbx
    6052: eb 05                        	jmp	 <L5>
<L3>:
    6054: 31 c0                        	xorl	%eax, %eax
<L4>:
    6056: 45 31 ed                     	xorl	%r13d, %r13d
<L5>:
    6059: 4d 01 ef                     	addq	%r13, %r15
    605c: 41 bc 20 00 00 00            	movl	$0x20, %r12d
    6062: 41 be 20 00 00 00            	movl	$0x20, %r14d
    6068: 4d 29 ee                     	subq	%r13, %r14
    606b: 0f b6 c0                     	movzbl	%al, %eax
    606e: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    6072: 48 81 c7 98 fe ff ff         	addq	$-0x168, %rdi           # imm = 0xFE98
    6079: 4c 89 fe                     	movq	%r15, %rsi
    607c: 4c 89 f2                     	movq	%r14, %rdx
    607f: e8 00 00 00 00               	callq	 <L6>
		0000000000006080:  R_X86_64_PLT32	memcpy-0x4
<L6>:
    6084: 44 00 b5 d8 fe ff ff         	addb	%r14b, -0x128(%rbp)
    608b: 48 83 c3 20                  	addq	$0x20, %rbx
    608f: 48 89 9d 90 fe ff ff         	movq	%rbx, -0x170(%rbp)
    6096: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    609d: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    60a1: e8 ba df ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    60a6: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x20d>
		00000000000060a9:  R_X86_64_PC32	.rodata+0x1bc
    60ad: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    60b1: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x218>
		00000000000060b4:  R_X86_64_PC32	.rodata+0x1ac
    60b8: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    60bf: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x226>
		00000000000060c2:  R_X86_64_PC32	.rodata+0x19c
    60c6: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    60cd: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x234>
		00000000000060d0:  R_X86_64_PC32	.rodata+0x18c
    60d4: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    60db: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x242>
		00000000000060de:  R_X86_64_PC32	.rodata+0x17c
    60e2: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    60e9: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x250>
		00000000000060ec:  R_X86_64_PC32	.rodata+0x16c
    60f0: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    60f7: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x25e>
		00000000000060fa:  R_X86_64_PC32	.rodata+0x15c
    60fe: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    6105: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    610c: 48 8d b5 e0 fe ff ff         	leaq	-0x120(%rbp), %rsi
    6113: e8 68 e0 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    6118: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    611c: 48 8b 9d 40 ff ff ff         	movq	-0xc0(%rbp), %rbx
    6123: 48 83 c3 40                  	addq	$0x40, %rbx
    6127: 4c 8d b5 48 ff ff ff         	leaq	-0xb8(%rbp), %r14
    612e: 48 89 9d 40 ff ff ff         	movq	%rbx, -0xc0(%rbp)
    6135: 48 85 ff                     	testq	%rdi, %rdi
    6138: 74 3c                        	je	 <L8>
    613a: 40 80 ff 20                  	cmpb	$0x20, %dil
    613e: 72 38                        	jb	 <L9>
    6140: 41 bf 40 00 00 00            	movl	$0x40, %r15d
    6146: 49 29 ff                     	subq	%rdi, %r15
    6149: 4c 01 f7                     	addq	%r14, %rdi
    614c: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    6150: 4c 89 fa                     	movq	%r15, %rdx
    6153: e8 00 00 00 00               	callq	 <L7>
		0000000000006154:  R_X86_64_PLT32	memcpy-0x4
<L7>:
    6158: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    615f: 4c 89 f6                     	movq	%r14, %rsi
    6162: e8 19 e0 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    6167: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    616b: 31 ff                        	xorl	%edi, %edi
    616d: 48 8b 9d 40 ff ff ff         	movq	-0xc0(%rbp), %rbx
    6174: eb 05                        	jmp	 <L10>
<L8>:
    6176: 31 ff                        	xorl	%edi, %edi
<L9>:
    6178: 45 31 ff                     	xorl	%r15d, %r15d
<L10>:
    617b: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    617f: 48 83 c6 90                  	addq	$-0x70, %rsi
    6183: 4d 29 fc                     	subq	%r15, %r12
    6186: 40 0f b6 c7                  	movzbl	%dil, %eax
    618a: 49 01 c6                     	addq	%rax, %r14
    618d: 4c 89 f7                     	movq	%r14, %rdi
    6190: 4c 89 e2                     	movq	%r12, %rdx
    6193: e8 00 00 00 00               	callq	 <L11>
		0000000000006194:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    6198: 44 00 65 88                  	addb	%r12b, -0x78(%rbp)
    619c: 48 83 c3 20                  	addq	$0x20, %rbx
    61a0: 48 89 9d 40 ff ff ff         	movq	%rbx, -0xc0(%rbp)
    61a7: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    61ae: 48 8d b5 50 fe ff ff         	leaq	-0x1b0(%rbp), %rsi
    61b5: e8 a6 de ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    61ba: 0f 10 85 50 fe ff ff         	movups	-0x1b0(%rbp), %xmm0
    61c1: 0f 10 8d 60 fe ff ff         	movups	-0x1a0(%rbp), %xmm1
    61c8: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    61cc: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
    61d0: 0f 11 00                     	movups	%xmm0, (%rax)
    61d3: 48 81 c4 88 01 00 00         	addq	$0x188, %rsp            # imm = 0x188
    61da: 5b                           	popq	%rbx
    61db: 41 5c                        	popq	%r12
    61dd: 41 5d                        	popq	%r13
    61df: 41 5e                        	popq	%r14
    61e1: 41 5f                        	popq	%r15
    61e3: 5d                           	popq	%rbp
    61e4: c3                           	retq
    61e5: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    61ef: 90                           	nop

00000000000061f0 <audit_handshake256>:
    61f0: 55                           	pushq	%rbp
    61f1: 48 89 e5                     	movq	%rsp, %rbp
    61f4: 41 57                        	pushq	%r15
    61f6: 41 56                        	pushq	%r14
    61f8: 53                           	pushq	%rbx
    61f9: 48 81 ec 58 01 00 00         	subq	$0x158, %rsp            # imm = 0x158
    6200: 48 89 d3                     	movq	%rdx, %rbx
    6203: 49 89 f6                     	movq	%rsi, %r14
    6206: 49 89 f8                     	movq	%rdi, %r8
    6209: 66 c7 85 90 fe ff ff 00 20   	movw	$0x2000, -0x170(%rbp)   # imm = 0x2000
    6212: c6 85 92 fe ff ff 0d         	movb	$0xd, -0x16e(%rbp)
    6219: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    6223: 48 89 85 93 fe ff ff         	movq	%rax, -0x16d(%rbp)
    622a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    6234: 48 89 85 98 fe ff ff         	movq	%rax, -0x168(%rbp)
    623b: c6 85 a0 fe ff ff 20         	movb	$0x20, -0x160(%rbp)
    6242: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x59>
		0000000000006245:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
    6249: 0f 11 85 a1 fe ff ff         	movups	%xmm0, -0x15f(%rbp)
    6250: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x67>
		0000000000006253:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
    6257: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    625e: 4c 8d 7d c0                  	leaq	-0x40(%rbp), %r15
    6262: 48 8d 95 90 fe ff ff         	leaq	-0x170(%rbp), %rdx
    6269: be 20 00 00 00               	movl	$0x20, %esi
    626e: b9 31 00 00 00               	movl	$0x31, %ecx
    6273: 4c 89 ff                     	movq	%r15, %rdi
    6276: e8 45 d6 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    627b: 48 8d 7d a0                  	leaq	-0x60(%rbp), %rdi
    627f: 4c 89 fe                     	movq	%r15, %rsi
    6282: 4c 89 f2                     	movq	%r14, %rdx
    6285: e8 16 fc ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    628a: 0f 57 c0                     	xorps	%xmm0, %xmm0
    628d: 0f 29 45 d0                  	movaps	%xmm0, -0x30(%rbp)
    6291: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    6295: 0f 10 45 a0                  	movups	-0x60(%rbp), %xmm0
    6299: 0f 10 4d b0                  	movups	-0x50(%rbp), %xmm1
    629d: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    62a1: 0f 11 03                     	movups	%xmm0, (%rbx)
    62a4: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            # imm = 0x158
    62ab: 5b                           	popq	%rbx
    62ac: 41 5e                        	popq	%r14
    62ae: 41 5f                        	popq	%r15
    62b0: 5d                           	popq	%rbp
    62b1: c3                           	retq
