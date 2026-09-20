
/tmp/ztls-signoff-20260919/125-before-6d73a0a/016-x86_64-linux-gnu.o:	file format elf64-x86-64

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
    3344: 66 c7 85 b0 fe ff ff 00 30   	movw	$0x3000, -0x150(%rbp)   # imm = 0x3000
    334d: c6 85 b2 fe ff ff 0d         	movb	$0xd, -0x14e(%rbp)
    3354: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    335e: 48 89 85 b3 fe ff ff         	movq	%rax, -0x14d(%rbp)
    3365: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    336f: 48 89 85 b8 fe ff ff         	movq	%rax, -0x148(%rbp)
    3376: c6 85 c0 fe ff ff 30         	movb	$0x30, -0x140(%rbp)
    337d: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x54>
		0000000000003380:  R_X86_64_PC32	.rodata+0x129
    3384: 0f 11 85 c1 fe ff ff         	movups	%xmm0, -0x13f(%rbp)
    338b: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x62>
		000000000000338e:  R_X86_64_PC32	.rodata+0x139
    3392: 0f 11 85 d1 fe ff ff         	movups	%xmm0, -0x12f(%rbp)
    3399: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master384+0x70>
		000000000000339c:  R_X86_64_PC32	.rodata+0x149
    33a0: 0f 11 85 e1 fe ff ff         	movups	%xmm0, -0x11f(%rbp)
    33a7: 4c 8d b5 80 fe ff ff         	leaq	-0x180(%rbp), %r14
    33ae: 48 8d 95 b0 fe ff ff         	leaq	-0x150(%rbp), %rdx
    33b5: be 30 00 00 00               	movl	$0x30, %esi
    33ba: b9 41 00 00 00               	movl	$0x41, %ecx
    33bf: 4c 89 f7                     	movq	%r14, %rdi
    33c2: e8 b9 cc ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    33c7: 48 8d 7d c0                  	leaq	-0x40(%rbp), %rdi
    33cb: ba 00 00 00 00               	movl	$0x0, %edx
		00000000000033cc:  R_X86_64_32	.rodata+0xfd
    33d0: 4c 89 f6                     	movq	%r14, %rsi
    33d3: e8 28 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    33d8: 0f 10 45 c0                  	movups	-0x40(%rbp), %xmm0
    33dc: 0f 10 4d d0                  	movups	-0x30(%rbp), %xmm1
    33e0: 0f 10 55 e0                  	movups	-0x20(%rbp), %xmm2
    33e4: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    33e8: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    33ec: 0f 11 03                     	movups	%xmm0, (%rbx)
    33ef: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            # imm = 0x170
    33f6: 5b                           	popq	%rbx
    33f7: 41 5e                        	popq	%r14
    33f9: 5d                           	popq	%rbp
    33fa: c3                           	retq
    33fb: 0f 1f 44 00 00               	nopl	(%rax,%rax)

0000000000003400 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    3400: 55                           	pushq	%rbp
    3401: 48 89 e5                     	movq	%rsp, %rbp
    3404: 41 57                        	pushq	%r15
    3406: 41 56                        	pushq	%r14
    3408: 41 55                        	pushq	%r13
    340a: 41 54                        	pushq	%r12
    340c: 53                           	pushq	%rbx
    340d: 48 81 ec f8 02 00 00         	subq	$0x2f8, %rsp            # imm = 0x2F8
    3414: 49 89 d6                     	movq	%rdx, %r14
    3417: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    341b: 0f 10 06                     	movups	(%rsi), %xmm0
    341e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    3422: 0f 10 56 20                  	movups	0x20(%rsi), %xmm2
    3426: 0f 29 95 70 ff ff ff         	movaps	%xmm2, -0x90(%rbp)
    342d: 0f 29 8d 60 ff ff ff         	movaps	%xmm1, -0xa0(%rbp)
    3434: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    343b: 0f 57 c0                     	xorps	%xmm0, %xmm0
    343e: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3442: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    3446: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
    344a: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    344e: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    3452: 31 c0                        	xorl	%eax, %eax
    3454: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    345e: 66 90                        	nop
<L0>:
    3460: 0f b6 8c 05 50 ff ff ff      	movzbl	-0xb0(%rbp,%rax), %ecx
    3468: 0f b6 94 05 51 ff ff ff      	movzbl	-0xaf(%rbp,%rax), %edx
    3470: 80 f1 5c                     	xorb	$0x5c, %cl
    3473: 88 8c 05 c0 fd ff ff         	movb	%cl, -0x240(%rbp,%rax)
    347a: 80 f2 5c                     	xorb	$0x5c, %dl
    347d: 88 94 05 c1 fd ff ff         	movb	%dl, -0x23f(%rbp,%rax)
    3484: 0f b6 8c 05 52 ff ff ff      	movzbl	-0xae(%rbp,%rax), %ecx
    348c: 80 f1 5c                     	xorb	$0x5c, %cl
    348f: 88 8c 05 c2 fd ff ff         	movb	%cl, -0x23e(%rbp,%rax)
    3496: 0f b6 8c 05 53 ff ff ff      	movzbl	-0xad(%rbp,%rax), %ecx
    349e: 80 f1 5c                     	xorb	$0x5c, %cl
    34a1: 88 8c 05 c3 fd ff ff         	movb	%cl, -0x23d(%rbp,%rax)
    34a8: 48 83 c0 04                  	addq	$0x4, %rax
    34ac: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
    34b2: 75 ac                        	jne	 <L0>
    34b4: b8 03 00 00 00               	movl	$0x3, %eax
    34b9: 0f 1f 80 00 00 00 00         	nopl	(%rax)
<L1>:
    34c0: 0f b6 8c 05 4d ff ff ff      	movzbl	-0xb3(%rbp,%rax), %ecx
    34c8: 0f b6 94 05 4e ff ff ff      	movzbl	-0xb2(%rbp,%rax), %edx
    34d0: 80 f1 36                     	xorb	$0x36, %cl
    34d3: 88 8c 05 6d fe ff ff         	movb	%cl, -0x193(%rbp,%rax)
    34da: 80 f2 36                     	xorb	$0x36, %dl
    34dd: 88 94 05 6e fe ff ff         	movb	%dl, -0x192(%rbp,%rax)
    34e4: 0f b6 8c 05 4f ff ff ff      	movzbl	-0xb1(%rbp,%rax), %ecx
    34ec: 80 f1 36                     	xorb	$0x36, %cl
    34ef: 88 8c 05 6f fe ff ff         	movb	%cl, -0x191(%rbp,%rax)
    34f6: 0f b6 8c 05 50 ff ff ff      	movzbl	-0xb0(%rbp,%rax), %ecx
    34fe: 80 f1 36                     	xorb	$0x36, %cl
    3501: 88 8c 05 70 fe ff ff         	movb	%cl, -0x190(%rbp,%rax)
    3508: 48 83 c0 04                  	addq	$0x4, %rax
    350c: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
    3512: 75 ac                        	jne	 <L1>
    3514: 4c 8d a5 e0 fc ff ff         	leaq	-0x320(%rbp), %r12
    351b: be 00 00 00 00               	movl	$0x0, %esi
		000000000000351c:  R_X86_64_32	.rodata+0x10
    3520: ba e0 00 00 00               	movl	$0xe0, %edx
    3525: 4c 89 e7                     	movq	%r12, %rdi
    3528: e8 00 00 00 00               	callq	 <L2>
		0000000000003529:  R_X86_64_PLT32	memcpy-0x4
<L2>:
    352d: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
    3534: 4c 89 e7                     	movq	%r12, %rdi
    3537: e8 04 d5 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    353c: 4c 8b a5 e8 fc ff ff         	movq	-0x318(%rbp), %r12
    3543: bb 80 00 00 00               	movl	$0x80, %ebx
    3548: 4c 8b bd e0 fc ff ff         	movq	-0x320(%rbp), %r15
    354f: 49 01 df                     	addq	%rbx, %r15
    3552: 49 83 d4 00                  	adcq	$0x0, %r12
    3556: 4c 89 bd e0 fc ff ff         	movq	%r15, -0x320(%rbp)
    355d: 4c 89 a5 e8 fc ff ff         	movq	%r12, -0x318(%rbp)
    3564: 0f b6 85 b0 fd ff ff         	movzbl	-0x250(%rbp), %eax
    356b: 48 85 c0                     	testq	%rax, %rax
    356e: 74 52                        	je	 <L4>
    3570: 3c 50                        	cmpb	$0x50, %al
    3572: 72 50                        	jb	 <L5>
    3574: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    357a: 49 29 c5                     	subq	%rax, %r13
    357d: 4c 8d a5 30 fd ff ff         	leaq	-0x2d0(%rbp), %r12
    3584: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3588: 48 81 c7 30 fd ff ff         	addq	$-0x2d0, %rdi           # imm = 0xFD30
    358f: 4c 89 f6                     	movq	%r14, %rsi
    3592: 4c 89 ea                     	movq	%r13, %rdx
    3595: e8 00 00 00 00               	callq	 <L3>
		0000000000003596:  R_X86_64_PLT32	memcpy-0x4
<L3>:
    359a: 48 8d bd e0 fc ff ff         	leaq	-0x320(%rbp), %rdi
    35a1: 4c 89 e6                     	movq	%r12, %rsi
    35a4: e8 97 d4 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    35a9: c6 85 b0 fd ff ff 00         	movb	$0x0, -0x250(%rbp)
    35b0: 31 c0                        	xorl	%eax, %eax
    35b2: 4c 8b bd e0 fc ff ff         	movq	-0x320(%rbp), %r15
    35b9: 4c 8b a5 e8 fc ff ff         	movq	-0x318(%rbp), %r12
    35c0: eb 05                        	jmp	 <L6>
<L4>:
    35c2: 31 c0                        	xorl	%eax, %eax
<L5>:
    35c4: 45 31 ed                     	xorl	%r13d, %r13d
<L6>:
    35c7: 4d 01 ee                     	addq	%r13, %r14
    35ca: 4c 89 f6                     	movq	%r14, %rsi
    35cd: 41 be 30 00 00 00            	movl	$0x30, %r14d
    35d3: 4d 29 ee                     	subq	%r13, %r14
    35d6: 0f b6 c0                     	movzbl	%al, %eax
    35d9: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    35dd: 48 81 c7 30 fd ff ff         	addq	$-0x2d0, %rdi           # imm = 0xFD30
    35e4: 4c 89 f2                     	movq	%r14, %rdx
    35e7: e8 00 00 00 00               	callq	 <L7>
		00000000000035e8:  R_X86_64_PLT32	memcpy-0x4
<L7>:
    35ec: 44 00 b5 b0 fd ff ff         	addb	%r14b, -0x250(%rbp)
    35f3: 49 83 c7 30                  	addq	$0x30, %r15
    35f7: 49 83 d4 00                  	adcq	$0x0, %r12
    35fb: 4c 89 a5 e8 fc ff ff         	movq	%r12, -0x318(%rbp)
    3602: 4c 89 bd e0 fc ff ff         	movq	%r15, -0x320(%rbp)
    3609: 48 8d bd e0 fc ff ff         	leaq	-0x320(%rbp), %rdi
    3610: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
    3617: e8 f4 fa ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    361c: 4c 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %r14
    3623: be 00 00 00 00               	movl	$0x0, %esi
		0000000000003624:  R_X86_64_32	.rodata+0x10
    3628: ba e0 00 00 00               	movl	$0xe0, %edx
    362d: 4c 89 f7                     	movq	%r14, %rdi
    3630: e8 00 00 00 00               	callq	 <L8>
		0000000000003631:  R_X86_64_PLT32	memcpy-0x4
<L8>:
    3635: 4c 89 f7                     	movq	%r14, %rdi
    3638: 48 8d b5 c0 fd ff ff         	leaq	-0x240(%rbp), %rsi
    363f: e8 fc d3 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    3644: 0f b6 bd 40 ff ff ff         	movzbl	-0xc0(%rbp), %edi
    364b: 4c 8b a5 78 fe ff ff         	movq	-0x188(%rbp), %r12
    3652: 48 03 9d 70 fe ff ff         	addq	-0x190(%rbp), %rbx
    3659: 49 83 d4 00                  	adcq	$0x0, %r12
    365d: 4c 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %r14
    3664: 48 89 9d 70 fe ff ff         	movq	%rbx, -0x190(%rbp)
    366b: 4c 89 a5 78 fe ff ff         	movq	%r12, -0x188(%rbp)
    3672: 48 85 ff                     	testq	%rdi, %rdi
    3675: 74 49                        	je	 <L10>
    3677: 40 80 ff 50                  	cmpb	$0x50, %dil
    367b: 72 45                        	jb	 <L11>
    367d: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    3683: 49 29 ff                     	subq	%rdi, %r15
    3686: 4c 01 f7                     	addq	%r14, %rdi
    3689: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
    3690: 4c 89 fa                     	movq	%r15, %rdx
    3693: e8 00 00 00 00               	callq	 <L9>
		0000000000003694:  R_X86_64_PLT32	memcpy-0x4
<L9>:
    3698: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    369f: 4c 89 f6                     	movq	%r14, %rsi
    36a2: e8 99 d3 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>
    36a7: c6 85 40 ff ff ff 00         	movb	$0x0, -0xc0(%rbp)
    36ae: 31 ff                        	xorl	%edi, %edi
    36b0: 48 8b 9d 70 fe ff ff         	movq	-0x190(%rbp), %rbx
    36b7: 4c 8b a5 78 fe ff ff         	movq	-0x188(%rbp), %r12
    36be: eb 05                        	jmp	 <L12>
<L10>:
    36c0: 31 ff                        	xorl	%edi, %edi
<L11>:
    36c2: 45 31 ff                     	xorl	%r15d, %r15d
<L12>:
    36c5: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    36c9: 48 81 c6 50 ff ff ff         	addq	$-0xb0, %rsi
    36d0: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    36d6: 4d 29 fd                     	subq	%r15, %r13
    36d9: 40 0f b6 c7                  	movzbl	%dil, %eax
    36dd: 49 01 c6                     	addq	%rax, %r14
    36e0: 4c 89 f7                     	movq	%r14, %rdi
    36e3: 4c 89 ea                     	movq	%r13, %rdx
    36e6: e8 00 00 00 00               	callq	 <L13>
		00000000000036e7:  R_X86_64_PLT32	memcpy-0x4
<L13>:
    36eb: 44 00 ad 40 ff ff ff         	addb	%r13b, -0xc0(%rbp)
    36f2: 48 83 c3 30                  	addq	$0x30, %rbx
    36f6: 49 83 d4 00                  	adcq	$0x0, %r12
    36fa: 4c 89 a5 78 fe ff ff         	movq	%r12, -0x188(%rbp)
    3701: 48 89 9d 70 fe ff ff         	movq	%rbx, -0x190(%rbp)
    3708: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    370f: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    3716: e8 f5 f9 ff ff               	callq	 <crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>
    371b: 0f 10 85 40 fe ff ff         	movups	-0x1c0(%rbp), %xmm0
    3722: 0f 10 8d 50 fe ff ff         	movups	-0x1b0(%rbp), %xmm1
    3729: 0f 10 95 60 fe ff ff         	movups	-0x1a0(%rbp), %xmm2
    3730: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    3734: 0f 11 50 20                  	movups	%xmm2, 0x20(%rax)
    3738: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
    373c: 0f 11 00                     	movups	%xmm0, (%rax)
    373f: 48 81 c4 f8 02 00 00         	addq	$0x2f8, %rsp            # imm = 0x2F8
    3746: 5b                           	popq	%rbx
    3747: 41 5c                        	popq	%r12
    3749: 41 5d                        	popq	%r13
    374b: 41 5e                        	popq	%r14
    374d: 41 5f                        	popq	%r15
    374f: 5d                           	popq	%rbp
    3750: c3                           	retq
    3751: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    375b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

0000000000003760 <audit_handshake384>:
    3760: 55                           	pushq	%rbp
    3761: 48 89 e5                     	movq	%rsp, %rbp
    3764: 41 57                        	pushq	%r15
    3766: 41 56                        	pushq	%r14
    3768: 53                           	pushq	%rbx
    3769: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            # imm = 0x178
    3770: 48 89 d3                     	movq	%rdx, %rbx
    3773: 49 89 f6                     	movq	%rsi, %r14
    3776: 49 89 f8                     	movq	%rdi, %r8
    3779: 66 c7 85 a8 fe ff ff 00 30   	movw	$0x3000, -0x158(%rbp)   # imm = 0x3000
    3782: c6 85 aa fe ff ff 0d         	movb	$0xd, -0x156(%rbp)
    3789: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    3793: 48 89 85 ab fe ff ff         	movq	%rax, -0x155(%rbp)
    379a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    37a4: 48 89 85 b0 fe ff ff         	movq	%rax, -0x150(%rbp)
    37ab: c6 85 b8 fe ff ff 30         	movb	$0x30, -0x148(%rbp)
    37b2: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x59>
		00000000000037b5:  R_X86_64_PC32	.rodata+0x129
    37b9: 0f 11 85 b9 fe ff ff         	movups	%xmm0, -0x147(%rbp)
    37c0: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x67>
		00000000000037c3:  R_X86_64_PC32	.rodata+0x139
    37c7: 0f 11 85 c9 fe ff ff         	movups	%xmm0, -0x137(%rbp)
    37ce: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake384+0x75>
		00000000000037d1:  R_X86_64_PC32	.rodata+0x149
    37d5: 0f 11 85 d9 fe ff ff         	movups	%xmm0, -0x127(%rbp)
    37dc: 4c 8d bd 78 fe ff ff         	leaq	-0x188(%rbp), %r15
    37e3: 48 8d 95 a8 fe ff ff         	leaq	-0x158(%rbp), %rdx
    37ea: be 30 00 00 00               	movl	$0x30, %esi
    37ef: b9 41 00 00 00               	movl	$0x41, %ecx
    37f4: 4c 89 ff                     	movq	%r15, %rdi
    37f7: e8 84 c8 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>
    37fc: 48 8d 7d b8                  	leaq	-0x48(%rbp), %rdi
    3800: 4c 89 fe                     	movq	%r15, %rsi
    3803: 4c 89 f2                     	movq	%r14, %rdx
    3806: e8 f5 fb ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>
    380b: 0f 10 45 b8                  	movups	-0x48(%rbp), %xmm0
    380f: 0f 10 4d c8                  	movups	-0x38(%rbp), %xmm1
    3813: 0f 10 55 d8                  	movups	-0x28(%rbp), %xmm2
    3817: 0f 11 53 20                  	movups	%xmm2, 0x20(%rbx)
    381b: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    381f: 0f 11 03                     	movups	%xmm0, (%rbx)
    3822: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            # imm = 0x178
    3829: 5b                           	popq	%rbx
    382a: 41 5e                        	popq	%r14
    382c: 41 5f                        	popq	%r15
    382e: 5d                           	popq	%rbp
    382f: c3                           	retq

0000000000003830 <audit_key256>:
    3830: 55                           	pushq	%rbp
    3831: 48 89 e5                     	movq	%rsp, %rbp
    3834: 48 81 ec 30 01 00 00         	subq	$0x130, %rsp            # imm = 0x130
    383b: 48 89 f0                     	movq	%rsi, %rax
    383e: 0f 10 07                     	movups	(%rdi), %xmm0
    3841: 0f 10 4f 10                  	movups	0x10(%rdi), %xmm1
    3845: 0f 29 4d f0                  	movaps	%xmm1, -0x10(%rbp)
    3849: 0f 29 45 e0                  	movaps	%xmm0, -0x20(%rbp)
    384d: 66 c7 85 d4 fe ff ff 00 10   	movw	$0x1000, -0x12c(%rbp)   # imm = 0x1000
    3856: c6 85 d6 fe ff ff 09         	movb	$0x9, -0x12a(%rbp)
    385d: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx # imm = 0x656B203331736C74
    3867: 48 89 8d d7 fe ff ff         	movq	%rcx, -0x129(%rbp)
    386e: 66 c7 85 df fe ff ff 79 00   	movw	$0x79, -0x121(%rbp)
    3877: 48 8d 95 d4 fe ff ff         	leaq	-0x12c(%rbp), %rdx
    387e: 4c 8d 45 e0                  	leaq	-0x20(%rbp), %r8
    3882: be 10 00 00 00               	movl	$0x10, %esi
    3887: b9 0d 00 00 00               	movl	$0xd, %ecx
    388c: 48 89 c7                     	movq	%rax, %rdi
    388f: e8 0c 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    3894: 48 81 c4 30 01 00 00         	addq	$0x130, %rsp            # imm = 0x130
    389b: 5d                           	popq	%rbp
    389c: c3                           	retq
    389d: 0f 1f 00                     	nopl	(%rax)

00000000000038a0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
    38a0: 55                           	pushq	%rbp
    38a1: 48 89 e5                     	movq	%rsp, %rbp
    38a4: 41 57                        	pushq	%r15
    38a6: 41 56                        	pushq	%r14
    38a8: 41 55                        	pushq	%r13
    38aa: 41 54                        	pushq	%r12
    38ac: 53                           	pushq	%rbx
    38ad: 48 81 ec 48 02 00 00         	subq	$0x248, %rsp            # imm = 0x248
    38b4: 49 89 cf                     	movq	%rcx, %r15
    38b7: 49 89 d4                     	movq	%rdx, %r12
    38ba: 48 89 bd 18 ff ff ff         	movq	%rdi, -0xe8(%rbp)
    38c1: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    38c5: 48 83 fe 20                  	cmpq	$0x20, %rsi
    38c9: 0f 83 a4 01 00 00            	jae	 <L3>
    38cf: 41 0f 10 00                  	movups	(%r8), %xmm0
    38d3: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
    38d8: 0f 29 4d a0                  	movaps	%xmm1, -0x60(%rbp)
    38dc: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    38e0: 0f 57 c0                     	xorps	%xmm0, %xmm0
    38e3: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    38e7: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    38eb: 31 c0                        	xorl	%eax, %eax
    38ed: 0f 1f 00                     	nopl	(%rax)
<L0>:
    38f0: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    38f5: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    38fa: 80 f1 5c                     	xorb	$0x5c, %cl
    38fd: 88 8c 05 d0 fe ff ff         	movb	%cl, -0x130(%rbp,%rax)
    3904: 80 f2 5c                     	xorb	$0x5c, %dl
    3907: 88 94 05 d1 fe ff ff         	movb	%dl, -0x12f(%rbp,%rax)
    390e: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    3913: 80 f1 5c                     	xorb	$0x5c, %cl
    3916: 88 8c 05 d2 fe ff ff         	movb	%cl, -0x12e(%rbp,%rax)
    391d: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    3922: 80 f1 5c                     	xorb	$0x5c, %cl
    3925: 88 8c 05 d3 fe ff ff         	movb	%cl, -0x12d(%rbp,%rax)
    392c: 48 83 c0 04                  	addq	$0x4, %rax
    3930: 48 83 f8 40                  	cmpq	$0x40, %rax
    3934: 75 ba                        	jne	 <L0>
    3936: 48 89 b5 10 ff ff ff         	movq	%rsi, -0xf0(%rbp)
    393d: b8 03 00 00 00               	movl	$0x3, %eax
    3942: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    394c: 0f 1f 40 00                  	nopl	(%rax)
<L1>:
    3950: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    3955: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    395a: 80 f1 36                     	xorb	$0x36, %cl
    395d: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    3964: 80 f2 36                     	xorb	$0x36, %dl
    3967: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    396e: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    3973: 80 f1 36                     	xorb	$0x36, %cl
    3976: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    397d: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3982: 80 f1 36                     	xorb	$0x36, %cl
    3985: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    398c: 48 83 c0 04                  	addq	$0x4, %rax
    3990: 48 83 f8 43                  	cmpq	$0x43, %rax
    3994: 75 ba                        	jne	 <L1>
    3996: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xfd>
		0000000000003999:  R_X86_64_PC32	.rodata+0x1bc
    399d: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    39a4: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x10b>
		00000000000039a7:  R_X86_64_PC32	.rodata+0x1ac
    39ab: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
    39b2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x119>
		00000000000039b5:  R_X86_64_PC32	.rodata+0x19c
    39b9: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    39c0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x127>
		00000000000039c3:  R_X86_64_PC32	.rodata+0x18c
    39c7: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    39ce: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x135>
		00000000000039d1:  R_X86_64_PC32	.rodata+0x17c
    39d5: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    39dc: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x143>
		00000000000039df:  R_X86_64_PC32	.rodata+0x16c
    39e3: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    39ea: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x151>
		00000000000039ed:  R_X86_64_PC32	.rodata+0x15c
    39f1: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    39f8: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    39ff: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3a06: e8 55 07 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3a0b: 48 83 85 80 fe ff ff 40      	addq	$0x40, -0x180(%rbp)
    3a13: 0f b6 85 c8 fe ff ff         	movzbl	-0x138(%rbp), %eax
    3a1a: 48 85 c0                     	testq	%rax, %rax
    3a1d: 0f 84 dc 01 00 00            	je	 <L7>
    3a23: 49 8d 0c 07                  	leaq	(%r15,%rax), %rcx
    3a27: 48 83 f9 40                  	cmpq	$0x40, %rcx
    3a2b: 0f 82 d0 01 00 00            	jb	 <L8>
    3a31: bb 40 00 00 00               	movl	$0x40, %ebx
    3a36: 48 29 c3                     	subq	%rax, %rbx
    3a39: 4c 8d b5 88 fe ff ff         	leaq	-0x178(%rbp), %r14
    3a40: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3a44: 48 81 c7 88 fe ff ff         	addq	$-0x178, %rdi           # imm = 0xFE88
    3a4b: 4c 89 e6                     	movq	%r12, %rsi
    3a4e: 48 89 da                     	movq	%rbx, %rdx
    3a51: e8 00 00 00 00               	callq	 <L2>
		0000000000003a52:  R_X86_64_PLT32	memcpy-0x4
<L2>:
    3a56: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3a5d: 4c 89 f6                     	movq	%r14, %rsi
    3a60: e8 fb 06 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3a65: c6 85 c8 fe ff ff 00         	movb	$0x0, -0x138(%rbp)
    3a6c: 31 c0                        	xorl	%eax, %eax
    3a6e: e9 90 01 00 00               	jmp	 <L9>
<L3>:
    3a73: 4c 89 fb                     	movq	%r15, %rbx
    3a76: 48 83 f3 3f                  	xorq	$0x3f, %rbx
    3a7a: 4c 8d ad d8 fd ff ff         	leaq	-0x228(%rbp), %r13
    3a81: 41 0f 10 00                  	movups	(%r8), %xmm0
    3a85: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
    3a8a: 0f 29 4d a0                  	movaps	%xmm1, -0x60(%rbp)
    3a8e: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    3a92: 0f 57 c0                     	xorps	%xmm0, %xmm0
    3a95: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    3a99: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    3a9d: 31 c0                        	xorl	%eax, %eax
    3a9f: 90                           	nop
<L4>:
    3aa0: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3aa5: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    3aaa: 80 f1 5c                     	xorb	$0x5c, %cl
    3aad: 88 8c 05 20 fe ff ff         	movb	%cl, -0x1e0(%rbp,%rax)
    3ab4: 80 f2 5c                     	xorb	$0x5c, %dl
    3ab7: 88 94 05 21 fe ff ff         	movb	%dl, -0x1df(%rbp,%rax)
    3abe: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    3ac3: 80 f1 5c                     	xorb	$0x5c, %cl
    3ac6: 88 8c 05 22 fe ff ff         	movb	%cl, -0x1de(%rbp,%rax)
    3acd: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    3ad2: 80 f1 5c                     	xorb	$0x5c, %cl
    3ad5: 88 8c 05 23 fe ff ff         	movb	%cl, -0x1dd(%rbp,%rax)
    3adc: 48 83 c0 04                  	addq	$0x4, %rax
    3ae0: 48 83 f8 40                  	cmpq	$0x40, %rax
    3ae4: 75 ba                        	jne	 <L4>
    3ae6: b8 03 00 00 00               	movl	$0x3, %eax
    3aeb: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L5>:
    3af0: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    3af5: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    3afa: 80 f1 36                     	xorb	$0x36, %cl
    3afd: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    3b04: 80 f2 36                     	xorb	$0x36, %dl
    3b07: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    3b0e: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    3b13: 80 f1 36                     	xorb	$0x36, %cl
    3b16: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    3b1d: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3b22: 80 f1 36                     	xorb	$0x36, %cl
    3b25: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    3b2c: 48 83 c0 04                  	addq	$0x4, %rax
    3b30: 48 83 f8 43                  	cmpq	$0x43, %rax
    3b34: 75 ba                        	jne	 <L5>
    3b36: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x29d>
		0000000000003b39:  R_X86_64_PC32	.rodata+0x1bc
    3b3d: 0f 29 85 10 fe ff ff         	movaps	%xmm0, -0x1f0(%rbp)
    3b44: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2ab>
		0000000000003b47:  R_X86_64_PC32	.rodata+0x1ac
    3b4b: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    3b52: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2b9>
		0000000000003b55:  R_X86_64_PC32	.rodata+0x19c
    3b59: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    3b60: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2c7>
		0000000000003b63:  R_X86_64_PC32	.rodata+0x18c
    3b67: 0f 29 85 e0 fd ff ff         	movaps	%xmm0, -0x220(%rbp)
    3b6e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2d5>
		0000000000003b71:  R_X86_64_PC32	.rodata+0x17c
    3b75: 0f 29 85 d0 fd ff ff         	movaps	%xmm0, -0x230(%rbp)
    3b7c: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2e3>
		0000000000003b7f:  R_X86_64_PC32	.rodata+0x16c
    3b83: 0f 29 85 c0 fd ff ff         	movaps	%xmm0, -0x240(%rbp)
    3b8a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2f1>
		0000000000003b8d:  R_X86_64_PC32	.rodata+0x15c
    3b91: 0f 29 85 b0 fd ff ff         	movaps	%xmm0, -0x250(%rbp)
    3b98: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3b9f: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3ba6: e8 b5 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3bab: 48 83 85 d0 fd ff ff 40      	addq	$0x40, -0x230(%rbp)
    3bb3: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
    3bba: 48 85 ff                     	testq	%rdi, %rdi
    3bbd: 0f 84 d7 00 00 00            	je	 <L12>
    3bc3: 48 39 fb                     	cmpq	%rdi, %rbx
    3bc6: 0f 83 d0 00 00 00            	jae	 <L13>
    3bcc: bb 40 00 00 00               	movl	$0x40, %ebx
    3bd1: 48 29 fb                     	subq	%rdi, %rbx
    3bd4: 4c 01 ef                     	addq	%r13, %rdi
    3bd7: 4c 89 e6                     	movq	%r12, %rsi
    3bda: 48 89 da                     	movq	%rbx, %rdx
    3bdd: e8 00 00 00 00               	callq	 <L6>
		0000000000003bde:  R_X86_64_PLT32	memcpy-0x4
<L6>:
    3be2: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3be9: 4c 89 ee                     	movq	%r13, %rsi
    3bec: e8 6f 05 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3bf1: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
    3bf8: 31 ff                        	xorl	%edi, %edi
    3bfa: e9 9f 00 00 00               	jmp	 <L14>
<L7>:
    3bff: 31 c0                        	xorl	%eax, %eax
<L8>:
    3c01: 31 db                        	xorl	%ebx, %ebx
<L9>:
    3c03: 49 01 dc                     	addq	%rbx, %r12
    3c06: 4d 89 fe                     	movq	%r15, %r14
    3c09: 49 29 de                     	subq	%rbx, %r14
    3c0c: 4c 8d ad 88 fe ff ff         	leaq	-0x178(%rbp), %r13
    3c13: 0f b6 c0                     	movzbl	%al, %eax
    3c16: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    3c1a: 48 81 c7 88 fe ff ff         	addq	$-0x178, %rdi           # imm = 0xFE88
    3c21: 4c 89 e6                     	movq	%r12, %rsi
    3c24: 4c 89 f2                     	movq	%r14, %rdx
    3c27: e8 00 00 00 00               	callq	 <L10>
		0000000000003c28:  R_X86_64_PLT32	memcpy-0x4
<L10>:
    3c2c: 0f b6 bd c8 fe ff ff         	movzbl	-0x138(%rbp), %edi
    3c33: 4c 01 f7                     	addq	%r14, %rdi
    3c36: 40 88 bd c8 fe ff ff         	movb	%dil, -0x138(%rbp)
    3c3d: 4c 03 bd 80 fe ff ff         	addq	-0x180(%rbp), %r15
    3c44: 4c 89 bd 80 fe ff ff         	movq	%r15, -0x180(%rbp)
    3c4b: 40 84 ff                     	testb	%dil, %dil
    3c4e: 0f 84 d3 00 00 00            	je	 <L17>
    3c54: 40 80 ff 3f                  	cmpb	$0x3f, %dil
    3c58: 0f 82 cb 00 00 00            	jb	 <L18>
    3c5e: b0 40                        	movb	$0x40, %al
    3c60: 40 28 f8                     	subb	%dil, %al
    3c63: 44 0f b6 e0                  	movzbl	%al, %r12d
    3c67: 4c 01 ef                     	addq	%r13, %rdi
    3c6a: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3c6e: 4c 89 e2                     	movq	%r12, %rdx
    3c71: e8 00 00 00 00               	callq	 <L11>
		0000000000003c72:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    3c76: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3c7d: 4c 89 ee                     	movq	%r13, %rsi
    3c80: e8 db 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3c85: c6 85 c8 fe ff ff 00         	movb	$0x0, -0x138(%rbp)
    3c8c: 31 ff                        	xorl	%edi, %edi
    3c8e: 4c 8b bd 80 fe ff ff         	movq	-0x180(%rbp), %r15
    3c95: e9 92 00 00 00               	jmp	 <L19>
<L12>:
    3c9a: 31 ff                        	xorl	%edi, %edi
<L13>:
    3c9c: 31 db                        	xorl	%ebx, %ebx
<L14>:
    3c9e: 49 01 dc                     	addq	%rbx, %r12
    3ca1: 4d 89 fe                     	movq	%r15, %r14
    3ca4: 49 29 de                     	subq	%rbx, %r14
    3ca7: 40 0f b6 ff                  	movzbl	%dil, %edi
    3cab: 4c 01 ef                     	addq	%r13, %rdi
    3cae: 4c 89 e6                     	movq	%r12, %rsi
    3cb1: 4c 89 f2                     	movq	%r14, %rdx
    3cb4: e8 00 00 00 00               	callq	 <L15>
		0000000000003cb5:  R_X86_64_PLT32	memcpy-0x4
<L15>:
    3cb9: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
    3cc0: 4c 01 f7                     	addq	%r14, %rdi
    3cc3: 40 88 bd 18 fe ff ff         	movb	%dil, -0x1e8(%rbp)
    3cca: 4c 03 bd d0 fd ff ff         	addq	-0x230(%rbp), %r15
    3cd1: 4c 89 bd d0 fd ff ff         	movq	%r15, -0x230(%rbp)
    3cd8: 40 84 ff                     	testb	%dil, %dil
    3cdb: 0f 84 69 01 00 00            	je	 <L22>
    3ce1: 40 80 ff 3f                  	cmpb	$0x3f, %dil
    3ce5: 0f 82 61 01 00 00            	jb	 <L23>
    3ceb: b0 40                        	movb	$0x40, %al
    3ced: 40 28 f8                     	subb	%dil, %al
    3cf0: 44 0f b6 e0                  	movzbl	%al, %r12d
    3cf4: 4c 01 ef                     	addq	%r13, %rdi
    3cf7: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3cfb: 4c 89 e2                     	movq	%r12, %rdx
    3cfe: e8 00 00 00 00               	callq	 <L16>
		0000000000003cff:  R_X86_64_PLT32	memcpy-0x4
<L16>:
    3d03: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3d0a: 4c 89 ee                     	movq	%r13, %rsi
    3d0d: e8 4e 04 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3d12: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
    3d19: 31 ff                        	xorl	%edi, %edi
    3d1b: 4c 8b bd d0 fd ff ff         	movq	-0x230(%rbp), %r15
    3d22: e9 28 01 00 00               	jmp	 <L24>
<L17>:
    3d27: 31 ff                        	xorl	%edi, %edi
<L18>:
    3d29: 45 31 e4                     	xorl	%r12d, %r12d
<L19>:
    3d2c: 49 8d 34 2c                  	leaq	(%r12,%rbp), %rsi
    3d30: 48 83 c6 d7                  	addq	$-0x29, %rsi
    3d34: bb 01 00 00 00               	movl	$0x1, %ebx
    3d39: 4c 29 e3                     	subq	%r12, %rbx
    3d3c: 40 0f b6 c7                  	movzbl	%dil, %eax
    3d40: 49 01 c5                     	addq	%rax, %r13
    3d43: 4c 89 ef                     	movq	%r13, %rdi
    3d46: 48 89 da                     	movq	%rbx, %rdx
    3d49: e8 00 00 00 00               	callq	 <L20>
		0000000000003d4a:  R_X86_64_PLT32	memcpy-0x4
<L20>:
    3d4e: 00 9d c8 fe ff ff            	addb	%bl, -0x138(%rbp)
    3d54: 49 83 c7 01                  	addq	$0x1, %r15
    3d58: 4c 89 bd 80 fe ff ff         	movq	%r15, -0x180(%rbp)
    3d5f: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3d66: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3d6a: e8 d1 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3d6f: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4d6>
		0000000000003d72:  R_X86_64_PC32	.rodata+0x1bc
    3d76: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3d7a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4e1>
		0000000000003d7d:  R_X86_64_PC32	.rodata+0x1ac
    3d81: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3d88: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4ef>
		0000000000003d8b:  R_X86_64_PC32	.rodata+0x19c
    3d8f: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3d96: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4fd>
		0000000000003d99:  R_X86_64_PC32	.rodata+0x18c
    3d9d: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3da4: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x50b>
		0000000000003da7:  R_X86_64_PC32	.rodata+0x17c
    3dab: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    3db2: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x519>
		0000000000003db5:  R_X86_64_PC32	.rodata+0x16c
    3db9: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3dc0: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x527>
		0000000000003dc3:  R_X86_64_PC32	.rodata+0x15c
    3dc7: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3dce: 48 8d b5 d0 fe ff ff         	leaq	-0x130(%rbp), %rsi
    3dd5: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3ddc: e8 7f 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3de1: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    3de5: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3dec: 49 83 c7 40                  	addq	$0x40, %r15
    3df0: 4c 8d b5 48 ff ff ff         	leaq	-0xb8(%rbp), %r14
    3df7: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3dfe: 48 85 ff                     	testq	%rdi, %rdi
    3e01: 0f 84 63 01 00 00            	je	 <L27>
    3e07: 40 80 ff 20                  	cmpb	$0x20, %dil
    3e0b: 0f 82 5b 01 00 00            	jb	 <L28>
    3e11: 41 bc 40 00 00 00            	movl	$0x40, %r12d
    3e17: 49 29 fc                     	subq	%rdi, %r12
    3e1a: 4c 01 f7                     	addq	%r14, %rdi
    3e1d: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3e21: 4c 89 e2                     	movq	%r12, %rdx
    3e24: e8 00 00 00 00               	callq	 <L21>
		0000000000003e25:  R_X86_64_PLT32	memcpy-0x4
<L21>:
    3e29: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3e30: 4c 89 f6                     	movq	%r14, %rsi
    3e33: e8 28 03 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3e38: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    3e3c: 31 ff                        	xorl	%edi, %edi
    3e3e: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3e45: e9 25 01 00 00               	jmp	 <L29>
<L22>:
    3e4a: 31 ff                        	xorl	%edi, %edi
<L23>:
    3e4c: 45 31 e4                     	xorl	%r12d, %r12d
<L24>:
    3e4f: 49 8d 34 2c                  	leaq	(%r12,%rbp), %rsi
    3e53: 48 83 c6 d7                  	addq	$-0x29, %rsi
    3e57: bb 01 00 00 00               	movl	$0x1, %ebx
    3e5c: 4c 29 e3                     	subq	%r12, %rbx
    3e5f: 40 0f b6 c7                  	movzbl	%dil, %eax
    3e63: 49 01 c5                     	addq	%rax, %r13
    3e66: 4c 89 ef                     	movq	%r13, %rdi
    3e69: 48 89 da                     	movq	%rbx, %rdx
    3e6c: e8 00 00 00 00               	callq	 <L25>
		0000000000003e6d:  R_X86_64_PLT32	memcpy-0x4
<L25>:
    3e71: 00 9d 18 fe ff ff            	addb	%bl, -0x1e8(%rbp)
    3e77: 49 83 c7 01                  	addq	$0x1, %r15
    3e7b: 4c 89 bd d0 fd ff ff         	movq	%r15, -0x230(%rbp)
    3e82: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3e89: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3e8d: e8 ae 01 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3e92: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x5f9>
		0000000000003e95:  R_X86_64_PC32	.rodata+0x1bc
    3e99: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3e9d: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x604>
		0000000000003ea0:  R_X86_64_PC32	.rodata+0x1ac
    3ea4: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3eab: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x612>
		0000000000003eae:  R_X86_64_PC32	.rodata+0x19c
    3eb2: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3eb9: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x620>
		0000000000003ebc:  R_X86_64_PC32	.rodata+0x18c
    3ec0: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3ec7: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x62e>
		0000000000003eca:  R_X86_64_PC32	.rodata+0x17c
    3ece: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    3ed5: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x63c>
		0000000000003ed8:  R_X86_64_PC32	.rodata+0x16c
    3edc: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3ee3: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x64a>
		0000000000003ee6:  R_X86_64_PC32	.rodata+0x15c
    3eea: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3ef1: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3ef8: 48 8d b5 20 fe ff ff         	leaq	-0x1e0(%rbp), %rsi
    3eff: e8 5c 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3f04: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    3f08: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3f0f: 49 83 c7 40                  	addq	$0x40, %r15
    3f13: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3f1a: 48 85 ff                     	testq	%rdi, %rdi
    3f1d: 0f 84 aa 00 00 00            	je	 <L32>
    3f23: 40 80 ff 20                  	cmpb	$0x20, %dil
    3f27: 4c 8d a5 48 ff ff ff         	leaq	-0xb8(%rbp), %r12
    3f2e: 0f 82 a7 00 00 00            	jb	 <L33>
    3f34: 41 be 40 00 00 00            	movl	$0x40, %r14d
    3f3a: 49 29 fe                     	subq	%rdi, %r14
    3f3d: 4c 01 e7                     	addq	%r12, %rdi
    3f40: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3f44: 4c 89 f2                     	movq	%r14, %rdx
    3f47: e8 00 00 00 00               	callq	 <L26>
		0000000000003f48:  R_X86_64_PLT32	memcpy-0x4
<L26>:
    3f4c: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3f53: 4c 89 e6                     	movq	%r12, %rsi
    3f56: e8 05 02 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    3f5b: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    3f5f: 31 ff                        	xorl	%edi, %edi
    3f61: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3f68: eb 74                        	jmp	 <L34>
<L27>:
    3f6a: 31 ff                        	xorl	%edi, %edi
<L28>:
    3f6c: 45 31 e4                     	xorl	%r12d, %r12d
<L29>:
    3f6f: 49 8d 34 2c                  	leaq	(%r12,%rbp), %rsi
    3f73: 48 83 c6 90                  	addq	$-0x70, %rsi
    3f77: bb 20 00 00 00               	movl	$0x20, %ebx
    3f7c: 4c 29 e3                     	subq	%r12, %rbx
    3f7f: 40 0f b6 c7                  	movzbl	%dil, %eax
    3f83: 49 01 c6                     	addq	%rax, %r14
    3f86: 4c 89 f7                     	movq	%r14, %rdi
    3f89: 48 89 da                     	movq	%rbx, %rdx
    3f8c: e8 00 00 00 00               	callq	 <L30>
		0000000000003f8d:  R_X86_64_PLT32	memcpy-0x4
<L30>:
    3f91: 00 5d 88                     	addb	%bl, -0x78(%rbp)
    3f94: 49 83 c7 20                  	addq	$0x20, %r15
    3f98: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3f9f: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3fa6: 48 8d 9d 90 fd ff ff         	leaq	-0x270(%rbp), %rbx
    3fad: 48 89 de                     	movq	%rbx, %rsi
    3fb0: e8 8b 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    3fb5: 48 8b bd 18 ff ff ff         	movq	-0xe8(%rbp), %rdi
    3fbc: 48 89 de                     	movq	%rbx, %rsi
    3fbf: 48 8b 95 10 ff ff ff         	movq	-0xf0(%rbp), %rdx
    3fc6: e8 00 00 00 00               	callq	 <L31>
		0000000000003fc7:  R_X86_64_PLT32	memcpy-0x4
<L31>:
    3fcb: eb 54                        	jmp	 <L36>
<L32>:
    3fcd: 31 ff                        	xorl	%edi, %edi
    3fcf: 45 31 f6                     	xorl	%r14d, %r14d
    3fd2: 4c 8d a5 48 ff ff ff         	leaq	-0xb8(%rbp), %r12
    3fd9: eb 03                        	jmp	 <L34>
<L33>:
    3fdb: 45 31 f6                     	xorl	%r14d, %r14d
<L34>:
    3fde: 49 8d 34 2e                  	leaq	(%r14,%rbp), %rsi
    3fe2: 48 83 c6 90                  	addq	$-0x70, %rsi
    3fe6: bb 20 00 00 00               	movl	$0x20, %ebx
    3feb: 4c 29 f3                     	subq	%r14, %rbx
    3fee: 40 0f b6 c7                  	movzbl	%dil, %eax
    3ff2: 49 01 c4                     	addq	%rax, %r12
    3ff5: 4c 89 e7                     	movq	%r12, %rdi
    3ff8: 48 89 da                     	movq	%rbx, %rdx
    3ffb: e8 00 00 00 00               	callq	 <L35>
		0000000000003ffc:  R_X86_64_PLT32	memcpy-0x4
<L35>:
    4000: 00 5d 88                     	addb	%bl, -0x78(%rbp)
    4003: 49 83 c7 20                  	addq	$0x20, %r15
    4007: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    400e: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    4015: 48 8b b5 18 ff ff ff         	movq	-0xe8(%rbp), %rsi
    401c: e8 1f 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
<L36>:
    4021: 48 81 c4 48 02 00 00         	addq	$0x248, %rsp            # imm = 0x248
    4028: 5b                           	popq	%rbx
    4029: 41 5c                        	popq	%r12
    402b: 41 5d                        	popq	%r13
    402d: 41 5e                        	popq	%r14
    402f: 41 5f                        	popq	%r15
    4031: 5d                           	popq	%rbp
    4032: c3                           	retq
    4033: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    403d: 0f 1f 00                     	nopl	(%rax)

0000000000004040 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
    4040: 55                           	pushq	%rbp
    4041: 48 89 e5                     	movq	%rsp, %rbp
    4044: 41 57                        	pushq	%r15
    4046: 41 56                        	pushq	%r14
    4048: 53                           	pushq	%rbx
    4049: 50                           	pushq	%rax
    404a: 48 89 f3                     	movq	%rsi, %rbx
    404d: 49 89 fe                     	movq	%rdi, %r14
    4050: 4c 8d 7f 28                  	leaq	0x28(%rdi), %r15
    4054: 0f b6 47 68                  	movzbl	0x68(%rdi), %eax
    4058: 48 01 c7                     	addq	%rax, %rdi
    405b: 48 83 c7 28                  	addq	$0x28, %rdi
    405f: ba 40 00 00 00               	movl	$0x40, %edx
    4064: 48 29 c2                     	subq	%rax, %rdx
    4067: 31 f6                        	xorl	%esi, %esi
    4069: e8 00 00 00 00               	callq	 <L0>
		000000000000406a:  R_X86_64_PLT32	memset-0x4
<L0>:
    406e: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
    4073: 41 c6 44 06 28 80            	movb	$-0x80, 0x28(%r14,%rax)
    4079: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
    407e: 8d 48 01                     	leal	0x1(%rax), %ecx
    4081: 41 88 4e 68                  	movb	%cl, 0x68(%r14)
    4085: 3c 37                        	cmpb	$0x37, %al
    4087: 76 24                        	jbe	 <L1>
    4089: 4c 89 f7                     	movq	%r14, %rdi
    408c: 4c 89 fe                     	movq	%r15, %rsi
    408f: e8 cc 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    4094: 0f 57 c0                     	xorps	%xmm0, %xmm0
    4097: 41 0f 11 47 20               	movups	%xmm0, 0x20(%r15)
    409c: 41 0f 11 47 10               	movups	%xmm0, 0x10(%r15)
    40a1: 41 0f 11 07                  	movups	%xmm0, (%r15)
    40a5: 49 c7 47 30 00 00 00 00      	movq	$0x0, 0x30(%r15)
<L1>:
    40ad: 49 8b 46 20                  	movq	0x20(%r14), %rax
    40b1: 89 c1                        	movl	%eax, %ecx
    40b3: c1 e9 05                     	shrl	$0x5, %ecx
    40b6: 8d 14 c5 00 00 00 00         	leal	(,%rax,8), %edx
    40bd: 41 88 56 67                  	movb	%dl, 0x67(%r14)
    40c1: 41 88 4e 66                  	movb	%cl, 0x66(%r14)
    40c5: 89 c1                        	movl	%eax, %ecx
    40c7: c1 e9 0d                     	shrl	$0xd, %ecx
    40ca: 41 88 4e 65                  	movb	%cl, 0x65(%r14)
    40ce: 89 c1                        	movl	%eax, %ecx
    40d0: c1 e9 15                     	shrl	$0x15, %ecx
    40d3: 41 88 4e 64                  	movb	%cl, 0x64(%r14)
    40d7: 48 89 c1                     	movq	%rax, %rcx
    40da: 48 c1 e9 1d                  	shrq	$0x1d, %rcx
    40de: 41 88 4e 63                  	movb	%cl, 0x63(%r14)
    40e2: 48 89 c1                     	movq	%rax, %rcx
    40e5: 48 c1 e9 25                  	shrq	$0x25, %rcx
    40e9: 41 88 4e 62                  	movb	%cl, 0x62(%r14)
    40ed: 48 89 c1                     	movq	%rax, %rcx
    40f0: 48 c1 e9 2d                  	shrq	$0x2d, %rcx
    40f4: 41 88 4e 61                  	movb	%cl, 0x61(%r14)
    40f8: 48 c1 e8 35                  	shrq	$0x35, %rax
    40fc: 41 88 46 60                  	movb	%al, 0x60(%r14)
    4100: 4c 89 f7                     	movq	%r14, %rdi
    4103: 4c 89 fe                     	movq	%r15, %rsi
    4106: e8 55 00 00 00               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    410b: 41 8b 06                     	movl	(%r14), %eax
    410e: 0f c8                        	bswapl	%eax
    4110: 89 03                        	movl	%eax, (%rbx)
    4112: 41 8b 46 04                  	movl	0x4(%r14), %eax
    4116: 0f c8                        	bswapl	%eax
    4118: 89 43 04                     	movl	%eax, 0x4(%rbx)
    411b: 41 8b 46 08                  	movl	0x8(%r14), %eax
    411f: 0f c8                        	bswapl	%eax
    4121: 89 43 08                     	movl	%eax, 0x8(%rbx)
    4124: 41 8b 46 0c                  	movl	0xc(%r14), %eax
    4128: 0f c8                        	bswapl	%eax
    412a: 89 43 0c                     	movl	%eax, 0xc(%rbx)
    412d: 41 8b 46 10                  	movl	0x10(%r14), %eax
    4131: 0f c8                        	bswapl	%eax
    4133: 89 43 10                     	movl	%eax, 0x10(%rbx)
    4136: 41 8b 46 14                  	movl	0x14(%r14), %eax
    413a: 0f c8                        	bswapl	%eax
    413c: 89 43 14                     	movl	%eax, 0x14(%rbx)
    413f: 41 8b 46 18                  	movl	0x18(%r14), %eax
    4143: 0f c8                        	bswapl	%eax
    4145: 89 43 18                     	movl	%eax, 0x18(%rbx)
    4148: 41 8b 46 1c                  	movl	0x1c(%r14), %eax
    414c: 0f c8                        	bswapl	%eax
    414e: 89 43 1c                     	movl	%eax, 0x1c(%rbx)
    4151: 48 83 c4 08                  	addq	$0x8, %rsp
    4155: 5b                           	popq	%rbx
    4156: 41 5e                        	popq	%r14
    4158: 41 5f                        	popq	%r15
    415a: 5d                           	popq	%rbp
    415b: c3                           	retq
    415c: 0f 1f 40 00                  	nopl	(%rax)

0000000000004160 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
    4160: 55                           	pushq	%rbp
    4161: 48 89 e5                     	movq	%rsp, %rbp
    4164: 41 57                        	pushq	%r15
    4166: 41 56                        	pushq	%r14
    4168: 41 55                        	pushq	%r13
    416a: 41 54                        	pushq	%r12
    416c: 53                           	pushq	%rbx
    416d: 48 81 ec 88 00 00 00         	subq	$0x88, %rsp
    4174: f3 0f 6f 06                  	movdqu	(%rsi), %xmm0
    4178: 66 0f ef c9                  	pxor	%xmm1, %xmm1
    417c: 66 0f 6f d0                  	movdqa	%xmm0, %xmm2
    4180: 66 0f 68 d1                  	punpckhbw	%xmm1, %xmm2    # xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
    4184: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
    4189: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
    418e: 66 0f 60 c1                  	punpcklbw	%xmm1, %xmm0    # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
    4192: f2 0f 70 c0 1b               	pshuflw	$0x1b, %xmm0, %xmm0     # xmm0 = xmm0[3,2,1,0,4,5,6,7]
    4197: f3 0f 70 c0 1b               	pshufhw	$0x1b, %xmm0, %xmm0     # xmm0 = xmm0[0,1,2,3,7,6,5,4]
    419c: 66 0f 67 c2                  	packuswb	%xmm2, %xmm0
    41a0: 66 0f 7f 85 d0 fe ff ff      	movdqa	%xmm0, -0x130(%rbp)
    41a8: f3 0f 6f 56 10               	movdqu	0x10(%rsi), %xmm2
    41ad: 66 0f 6f da                  	movdqa	%xmm2, %xmm3
    41b1: 66 0f 68 d9                  	punpckhbw	%xmm1, %xmm3    # xmm3 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
    41b5: f2 0f 70 db 1b               	pshuflw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[3,2,1,0,4,5,6,7]
    41ba: f3 0f 70 db 1b               	pshufhw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[0,1,2,3,7,6,5,4]
    41bf: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    # xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    41c3: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
    41c8: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
    41cd: 66 0f 67 d3                  	packuswb	%xmm3, %xmm2
    41d1: 66 0f 7f 95 e0 fe ff ff      	movdqa	%xmm2, -0x120(%rbp)
    41d9: f3 0f 6f 56 20               	movdqu	0x20(%rsi), %xmm2
    41de: 66 0f 6f da                  	movdqa	%xmm2, %xmm3
    41e2: 66 0f 68 d9                  	punpckhbw	%xmm1, %xmm3    # xmm3 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
    41e6: f2 0f 70 db 1b               	pshuflw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[3,2,1,0,4,5,6,7]
    41eb: f3 0f 70 db 1b               	pshufhw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[0,1,2,3,7,6,5,4]
    41f0: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    # xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    41f4: f2 0f 70 d2 1b               	pshuflw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[3,2,1,0,4,5,6,7]
    41f9: f3 0f 70 d2 1b               	pshufhw	$0x1b, %xmm2, %xmm2     # xmm2 = xmm2[0,1,2,3,7,6,5,4]
    41fe: 66 0f 67 d3                  	packuswb	%xmm3, %xmm2
    4202: 66 0f 7f 95 f0 fe ff ff      	movdqa	%xmm2, -0x110(%rbp)
    420a: f3 0f 6f 56 30               	movdqu	0x30(%rsi), %xmm2
    420f: 66 0f 6f da                  	movdqa	%xmm2, %xmm3
    4213: 66 0f 68 d9                  	punpckhbw	%xmm1, %xmm3    # xmm3 = xmm3[8],xmm1[8],xmm3[9],xmm1[9],xmm3[10],xmm1[10],xmm3[11],xmm1[11],xmm3[12],xmm1[12],xmm3[13],xmm1[13],xmm3[14],xmm1[14],xmm3[15],xmm1[15]
    4217: f2 0f 70 db 1b               	pshuflw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[3,2,1,0,4,5,6,7]
    421c: f3 0f 70 db 1b               	pshufhw	$0x1b, %xmm3, %xmm3     # xmm3 = xmm3[0,1,2,3,7,6,5,4]
    4221: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    # xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    4225: f2 0f 70 ca 1b               	pshuflw	$0x1b, %xmm2, %xmm1     # xmm1 = xmm2[3,2,1,0,4,5,6,7]
    422a: f3 0f 70 c9 1b               	pshufhw	$0x1b, %xmm1, %xmm1     # xmm1 = xmm1[0,1,2,3,7,6,5,4]
    422f: 66 0f 67 cb                  	packuswb	%xmm3, %xmm1
    4233: 66 0f 7f 8d 00 ff ff ff      	movdqa	%xmm1, -0x100(%rbp)
    423b: b8 10 00 00 00               	movl	$0x10, %eax
<L0>:
    4240: 8b 8c 85 94 fe ff ff         	movl	-0x16c(%rbp,%rax,4), %ecx
    4247: 8b 94 85 b4 fe ff ff         	movl	-0x14c(%rbp,%rax,4), %edx
    424e: 03 94 85 90 fe ff ff         	addl	-0x170(%rbp,%rax,4), %edx
    4255: 89 ce                        	movl	%ecx, %esi
    4257: c1 c6 19                     	roll	$0x19, %esi
    425a: 41 89 c8                     	movl	%ecx, %r8d
    425d: 41 c1 c0 0e                  	roll	$0xe, %r8d
    4261: 41 31 f0                     	xorl	%esi, %r8d
    4264: c1 e9 03                     	shrl	$0x3, %ecx
    4267: 8b b4 85 c8 fe ff ff         	movl	-0x138(%rbp,%rax,4), %esi
    426e: 41 89 f1                     	movl	%esi, %r9d
    4271: 41 c1 c1 0f                  	roll	$0xf, %r9d
    4275: 44 31 c1                     	xorl	%r8d, %ecx
    4278: 41 89 f0                     	movl	%esi, %r8d
    427b: 41 c1 c0 0d                  	roll	$0xd, %r8d
    427f: 01 d1                        	addl	%edx, %ecx
    4281: 45 31 c8                     	xorl	%r9d, %r8d
    4284: c1 ee 0a                     	shrl	$0xa, %esi
    4287: 44 31 c6                     	xorl	%r8d, %esi
    428a: 01 ce                        	addl	%ecx, %esi
    428c: 89 b4 85 d0 fe ff ff         	movl	%esi, -0x130(%rbp,%rax,4)
    4293: 48 83 c0 01                  	addq	$0x1, %rax
    4297: 48 83 f8 40                  	cmpq	$0x40, %rax
    429b: 75 a3                        	jne	 <L0>
    429d: 44 8b 07                     	movl	(%rdi), %r8d
    42a0: 8b 5f 04                     	movl	0x4(%rdi), %ebx
    42a3: 44 8b 57 08                  	movl	0x8(%rdi), %r10d
    42a7: 44 8b 5f 10                  	movl	0x10(%rdi), %r11d
    42ab: 8b 4f 14                     	movl	0x14(%rdi), %ecx
    42ae: 8b 77 18                     	movl	0x18(%rdi), %esi
    42b1: 44 89 d8                     	movl	%r11d, %eax
    42b4: c1 c0 1a                     	roll	$0x1a, %eax
    42b7: 44 89 da                     	movl	%r11d, %edx
    42ba: c1 c2 15                     	roll	$0x15, %edx
    42bd: 31 c2                        	xorl	%eax, %edx
    42bf: 44 89 d8                     	movl	%r11d, %eax
    42c2: c1 c0 07                     	roll	$0x7, %eax
    42c5: 31 d0                        	xorl	%edx, %eax
    42c7: 89 f2                        	movl	%esi, %edx
    42c9: 31 ca                        	xorl	%ecx, %edx
    42cb: 44 21 da                     	andl	%r11d, %edx
    42ce: 03 47 1c                     	addl	0x1c(%rdi), %eax
    42d1: 31 f2                        	xorl	%esi, %edx
    42d3: 66 41 0f 7e c1               	movd	%xmm0, %r9d
    42d8: 41 01 c1                     	addl	%eax, %r9d
    42db: 46 8d 34 0a                  	leal	(%rdx,%r9), %r14d
    42df: 41 81 c6 98 2f 8a 42         	addl	$0x428a2f98, %r14d      # imm = 0x428A2F98
    42e6: 8b 57 0c                     	movl	0xc(%rdi), %edx
    42e9: 44 89 c0                     	movl	%r8d, %eax
    42ec: c1 c0 1e                     	roll	$0x1e, %eax
    42ef: 44 01 f2                     	addl	%r14d, %edx
    42f2: 45 89 c1                     	movl	%r8d, %r9d
    42f5: 41 c1 c1 13                  	roll	$0x13, %r9d
    42f9: 41 31 c1                     	xorl	%eax, %r9d
    42fc: 45 89 c7                     	movl	%r8d, %r15d
    42ff: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4303: 45 31 cf                     	xorl	%r9d, %r15d
    4306: 41 89 d1                     	movl	%edx, %r9d
    4309: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    430d: 44 89 d0                     	movl	%r10d, %eax
    4310: 41 89 d5                     	movl	%edx, %r13d
    4313: 41 c1 c5 15                  	roll	$0x15, %r13d
    4317: 45 31 cd                     	xorl	%r9d, %r13d
    431a: 41 89 d4                     	movl	%edx, %r12d
    431d: 41 c1 c4 07                  	roll	$0x7, %r12d
    4321: 45 31 ec                     	xorl	%r13d, %r12d
    4324: 41 89 c9                     	movl	%ecx, %r9d
    4327: 45 31 d9                     	xorl	%r11d, %r9d
    432a: 41 21 d1                     	andl	%edx, %r9d
    432d: 41 31 c9                     	xorl	%ecx, %r9d
    4330: 03 b5 d4 fe ff ff            	addl	-0x12c(%rbp), %esi
    4336: 44 01 ce                     	addl	%r9d, %esi
    4339: 46 8d 0c 26                  	leal	(%rsi,%r12), %r9d
    433d: 45 01 d1                     	addl	%r10d, %r9d
    4340: 41 81 c1 91 44 37 71         	addl	$0x71374491, %r9d       # imm = 0x71374491
    4347: 41 09 da                     	orl	%ebx, %r10d
    434a: 45 21 c2                     	andl	%r8d, %r10d
    434d: 21 d8                        	andl	%ebx, %eax
    434f: 44 09 d0                     	orl	%r10d, %eax
    4352: 44 01 f8                     	addl	%r15d, %eax
    4355: 44 01 f0                     	addl	%r14d, %eax
    4358: 41 89 c2                     	movl	%eax, %r10d
    435b: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    435f: 45 8d 34 34                  	leal	(%r12,%rsi), %r14d
    4363: 41 81 c6 91 44 37 71         	addl	$0x71374491, %r14d      # imm = 0x71374491
    436a: 89 c6                        	movl	%eax, %esi
    436c: c1 c6 13                     	roll	$0x13, %esi
    436f: 44 31 d6                     	xorl	%r10d, %esi
    4372: 41 89 c7                     	movl	%eax, %r15d
    4375: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4379: 41 31 f7                     	xorl	%esi, %r15d
    437c: 45 89 ca                     	movl	%r9d, %r10d
    437f: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    4383: 89 de                        	movl	%ebx, %esi
    4385: 45 89 cd                     	movl	%r9d, %r13d
    4388: 41 c1 c5 15                  	roll	$0x15, %r13d
    438c: 45 31 d5                     	xorl	%r10d, %r13d
    438f: 45 89 cc                     	movl	%r9d, %r12d
    4392: 41 c1 c4 07                  	roll	$0x7, %r12d
    4396: 45 31 ec                     	xorl	%r13d, %r12d
    4399: 41 89 d2                     	movl	%edx, %r10d
    439c: 45 31 da                     	xorl	%r11d, %r10d
    439f: 45 21 ca                     	andl	%r9d, %r10d
    43a2: 45 31 da                     	xorl	%r11d, %r10d
    43a5: 03 8d d8 fe ff ff            	addl	-0x128(%rbp), %ecx
    43ab: 44 01 d1                     	addl	%r10d, %ecx
    43ae: 46 8d 14 21                  	leal	(%rcx,%r12), %r10d
    43b2: 41 01 da                     	addl	%ebx, %r10d
    43b5: 41 81 c2 cf fb c0 b5         	addl	$0xb5c0fbcf, %r10d      # imm = 0xB5C0FBCF
    43bc: 44 09 c3                     	orl	%r8d, %ebx
    43bf: 21 c3                        	andl	%eax, %ebx
    43c1: 44 21 c6                     	andl	%r8d, %esi
    43c4: 09 de                        	orl	%ebx, %esi
    43c6: 44 01 fe                     	addl	%r15d, %esi
    43c9: 44 01 f6                     	addl	%r14d, %esi
    43cc: 89 f3                        	movl	%esi, %ebx
    43ce: c1 c3 1e                     	roll	$0x1e, %ebx
    43d1: 45 8d 34 0c                  	leal	(%r12,%rcx), %r14d
    43d5: 41 81 c6 cf fb c0 b5         	addl	$0xb5c0fbcf, %r14d      # imm = 0xB5C0FBCF
    43dc: 89 f1                        	movl	%esi, %ecx
    43de: c1 c1 13                     	roll	$0x13, %ecx
    43e1: 31 d9                        	xorl	%ebx, %ecx
    43e3: 89 f3                        	movl	%esi, %ebx
    43e5: c1 c3 0a                     	roll	$0xa, %ebx
    43e8: 31 cb                        	xorl	%ecx, %ebx
    43ea: 41 89 c7                     	movl	%eax, %r15d
    43ed: 45 09 c7                     	orl	%r8d, %r15d
    43f0: 41 21 f7                     	andl	%esi, %r15d
    43f3: 89 c1                        	movl	%eax, %ecx
    43f5: 44 21 c1                     	andl	%r8d, %ecx
    43f8: 44 09 f9                     	orl	%r15d, %ecx
    43fb: 01 d9                        	addl	%ebx, %ecx
    43fd: 44 01 f1                     	addl	%r14d, %ecx
    4400: 44 89 d3                     	movl	%r10d, %ebx
    4403: c1 c3 1a                     	roll	$0x1a, %ebx
    4406: 45 89 d6                     	movl	%r10d, %r14d
    4409: 41 c1 c6 15                  	roll	$0x15, %r14d
    440d: 41 31 de                     	xorl	%ebx, %r14d
    4410: 44 89 d3                     	movl	%r10d, %ebx
    4413: c1 c3 07                     	roll	$0x7, %ebx
    4416: 44 31 f3                     	xorl	%r14d, %ebx
    4419: 45 89 ce                     	movl	%r9d, %r14d
    441c: 41 31 d6                     	xorl	%edx, %r14d
    441f: 45 21 d6                     	andl	%r10d, %r14d
    4422: 41 31 d6                     	xorl	%edx, %r14d
    4425: 44 03 9d dc fe ff ff         	addl	-0x124(%rbp), %r11d
    442c: 45 01 f3                     	addl	%r14d, %r11d
    442f: 45 8d 34 1b                  	leal	(%r11,%rbx), %r14d
    4433: 46 8d 3c 1b                  	leal	(%rbx,%r11), %r15d
    4437: 41 81 c7 a5 db b5 e9         	addl	$0xe9b5dba5, %r15d      # imm = 0xE9B5DBA5
    443e: 41 89 cb                     	movl	%ecx, %r11d
    4441: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    4445: 43 8d 1c 30                  	leal	(%r8,%r14), %ebx
    4449: 81 c3 a5 db b5 e9            	addl	$0xe9b5dba5, %ebx       # imm = 0xE9B5DBA5
    444f: 41 89 c8                     	movl	%ecx, %r8d
    4452: 41 c1 c0 13                  	roll	$0x13, %r8d
    4456: 45 31 d8                     	xorl	%r11d, %r8d
    4459: 41 89 ce                     	movl	%ecx, %r14d
    445c: 41 c1 c6 0a                  	roll	$0xa, %r14d
    4460: 45 31 c6                     	xorl	%r8d, %r14d
    4463: 41 89 f0                     	movl	%esi, %r8d
    4466: 41 09 c0                     	orl	%eax, %r8d
    4469: 41 21 c8                     	andl	%ecx, %r8d
    446c: 41 89 f3                     	movl	%esi, %r11d
    446f: 41 21 c3                     	andl	%eax, %r11d
    4472: 45 09 c3                     	orl	%r8d, %r11d
    4475: 45 01 f3                     	addl	%r14d, %r11d
    4478: 45 01 fb                     	addl	%r15d, %r11d
    447b: 41 89 d8                     	movl	%ebx, %r8d
    447e: 41 c1 c0 1a                  	roll	$0x1a, %r8d
    4482: 41 89 de                     	movl	%ebx, %r14d
    4485: 41 c1 c6 15                  	roll	$0x15, %r14d
    4489: 45 31 c6                     	xorl	%r8d, %r14d
    448c: 41 89 d8                     	movl	%ebx, %r8d
    448f: 41 c1 c0 07                  	roll	$0x7, %r8d
    4493: 45 31 f0                     	xorl	%r14d, %r8d
    4496: 45 89 d6                     	movl	%r10d, %r14d
    4499: 45 31 ce                     	xorl	%r9d, %r14d
    449c: 41 21 de                     	andl	%ebx, %r14d
    449f: 45 31 ce                     	xorl	%r9d, %r14d
    44a2: 03 95 e0 fe ff ff            	addl	-0x120(%rbp), %edx
    44a8: 44 01 f2                     	addl	%r14d, %edx
    44ab: 44 01 c2                     	addl	%r8d, %edx
    44ae: 81 c2 5b c2 56 39            	addl	$0x3956c25b, %edx       # imm = 0x3956C25B
    44b4: 01 d0                        	addl	%edx, %eax
    44b6: 45 89 d8                     	movl	%r11d, %r8d
    44b9: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    44bd: 45 89 de                     	movl	%r11d, %r14d
    44c0: 41 c1 c6 13                  	roll	$0x13, %r14d
    44c4: 45 31 c6                     	xorl	%r8d, %r14d
    44c7: 45 89 df                     	movl	%r11d, %r15d
    44ca: 41 c1 c7 0a                  	roll	$0xa, %r15d
    44ce: 45 31 f7                     	xorl	%r14d, %r15d
    44d1: 41 89 ce                     	movl	%ecx, %r14d
    44d4: 41 09 f6                     	orl	%esi, %r14d
    44d7: 45 21 de                     	andl	%r11d, %r14d
    44da: 41 89 c8                     	movl	%ecx, %r8d
    44dd: 41 21 f0                     	andl	%esi, %r8d
    44e0: 45 09 f0                     	orl	%r14d, %r8d
    44e3: 45 01 f8                     	addl	%r15d, %r8d
    44e6: 41 01 d0                     	addl	%edx, %r8d
    44e9: 89 c2                        	movl	%eax, %edx
    44eb: c1 c2 1a                     	roll	$0x1a, %edx
    44ee: 41 89 c6                     	movl	%eax, %r14d
    44f1: 41 c1 c6 15                  	roll	$0x15, %r14d
    44f5: 41 31 d6                     	xorl	%edx, %r14d
    44f8: 89 c2                        	movl	%eax, %edx
    44fa: c1 c2 07                     	roll	$0x7, %edx
    44fd: 44 31 f2                     	xorl	%r14d, %edx
    4500: 41 89 de                     	movl	%ebx, %r14d
    4503: 45 31 d6                     	xorl	%r10d, %r14d
    4506: 41 21 c6                     	andl	%eax, %r14d
    4509: 44 03 8d e4 fe ff ff         	addl	-0x11c(%rbp), %r9d
    4510: 45 31 d6                     	xorl	%r10d, %r14d
    4513: 45 01 f1                     	addl	%r14d, %r9d
    4516: 44 01 ca                     	addl	%r9d, %edx
    4519: 81 c2 f1 11 f1 59            	addl	$0x59f111f1, %edx       # imm = 0x59F111F1
    451f: 01 d6                        	addl	%edx, %esi
    4521: 45 89 c1                     	movl	%r8d, %r9d
    4524: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4528: 45 89 c6                     	movl	%r8d, %r14d
    452b: 41 c1 c6 13                  	roll	$0x13, %r14d
    452f: 45 31 ce                     	xorl	%r9d, %r14d
    4532: 45 89 c7                     	movl	%r8d, %r15d
    4535: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4539: 45 31 f7                     	xorl	%r14d, %r15d
    453c: 45 89 de                     	movl	%r11d, %r14d
    453f: 41 09 ce                     	orl	%ecx, %r14d
    4542: 45 21 c6                     	andl	%r8d, %r14d
    4545: 45 89 d9                     	movl	%r11d, %r9d
    4548: 41 21 c9                     	andl	%ecx, %r9d
    454b: 45 09 f1                     	orl	%r14d, %r9d
    454e: 41 89 f6                     	movl	%esi, %r14d
    4551: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4555: 45 01 f9                     	addl	%r15d, %r9d
    4558: 41 89 f7                     	movl	%esi, %r15d
    455b: 41 c1 c7 15                  	roll	$0x15, %r15d
    455f: 41 01 d1                     	addl	%edx, %r9d
    4562: 89 f2                        	movl	%esi, %edx
    4564: c1 c2 07                     	roll	$0x7, %edx
    4567: 45 31 f7                     	xorl	%r14d, %r15d
    456a: 44 31 fa                     	xorl	%r15d, %edx
    456d: 41 89 c6                     	movl	%eax, %r14d
    4570: 41 31 de                     	xorl	%ebx, %r14d
    4573: 41 21 f6                     	andl	%esi, %r14d
    4576: 41 31 de                     	xorl	%ebx, %r14d
    4579: 44 03 95 e8 fe ff ff         	addl	-0x118(%rbp), %r10d
    4580: 45 01 f2                     	addl	%r14d, %r10d
    4583: 45 89 ce                     	movl	%r9d, %r14d
    4586: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    458a: 41 01 d2                     	addl	%edx, %r10d
    458d: 41 81 c2 a4 82 3f 92         	addl	$0x923f82a4, %r10d      # imm = 0x923F82A4
    4594: 44 89 ca                     	movl	%r9d, %edx
    4597: c1 c2 13                     	roll	$0x13, %edx
    459a: 44 01 d1                     	addl	%r10d, %ecx
    459d: 45 89 cf                     	movl	%r9d, %r15d
    45a0: 41 c1 c7 0a                  	roll	$0xa, %r15d
    45a4: 44 31 f2                     	xorl	%r14d, %edx
    45a7: 41 31 d7                     	xorl	%edx, %r15d
    45aa: 45 89 c6                     	movl	%r8d, %r14d
    45ad: 45 09 de                     	orl	%r11d, %r14d
    45b0: 45 21 ce                     	andl	%r9d, %r14d
    45b3: 44 89 c2                     	movl	%r8d, %edx
    45b6: 44 21 da                     	andl	%r11d, %edx
    45b9: 44 09 f2                     	orl	%r14d, %edx
    45bc: 44 01 fa                     	addl	%r15d, %edx
    45bf: 41 89 ce                     	movl	%ecx, %r14d
    45c2: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    45c6: 44 01 d2                     	addl	%r10d, %edx
    45c9: 41 89 ca                     	movl	%ecx, %r10d
    45cc: 41 c1 c2 15                  	roll	$0x15, %r10d
    45d0: 45 31 f2                     	xorl	%r14d, %r10d
    45d3: 41 89 ce                     	movl	%ecx, %r14d
    45d6: 41 c1 c6 07                  	roll	$0x7, %r14d
    45da: 45 31 d6                     	xorl	%r10d, %r14d
    45dd: 41 89 f2                     	movl	%esi, %r10d
    45e0: 41 31 c2                     	xorl	%eax, %r10d
    45e3: 41 21 ca                     	andl	%ecx, %r10d
    45e6: 41 31 c2                     	xorl	%eax, %r10d
    45e9: 03 9d ec fe ff ff            	addl	-0x114(%rbp), %ebx
    45ef: 44 01 d3                     	addl	%r10d, %ebx
    45f2: 45 8d 14 1e                  	leal	(%r14,%rbx), %r10d
    45f6: 41 81 c2 d5 5e 1c ab         	addl	$0xab1c5ed5, %r10d      # imm = 0xAB1C5ED5
    45fd: 89 d3                        	movl	%edx, %ebx
    45ff: c1 c3 1e                     	roll	$0x1e, %ebx
    4602: 45 01 d3                     	addl	%r10d, %r11d
    4605: 41 89 d6                     	movl	%edx, %r14d
    4608: 41 c1 c6 13                  	roll	$0x13, %r14d
    460c: 41 31 de                     	xorl	%ebx, %r14d
    460f: 41 89 d7                     	movl	%edx, %r15d
    4612: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4616: 45 31 f7                     	xorl	%r14d, %r15d
    4619: 45 89 ce                     	movl	%r9d, %r14d
    461c: 45 09 c6                     	orl	%r8d, %r14d
    461f: 41 21 d6                     	andl	%edx, %r14d
    4622: 44 89 cb                     	movl	%r9d, %ebx
    4625: 44 21 c3                     	andl	%r8d, %ebx
    4628: 44 09 f3                     	orl	%r14d, %ebx
    462b: 44 01 fb                     	addl	%r15d, %ebx
    462e: 44 01 d3                     	addl	%r10d, %ebx
    4631: 45 89 da                     	movl	%r11d, %r10d
    4634: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    4638: 45 89 de                     	movl	%r11d, %r14d
    463b: 41 c1 c6 15                  	roll	$0x15, %r14d
    463f: 45 31 d6                     	xorl	%r10d, %r14d
    4642: 45 89 da                     	movl	%r11d, %r10d
    4645: 41 c1 c2 07                  	roll	$0x7, %r10d
    4649: 45 31 f2                     	xorl	%r14d, %r10d
    464c: 41 89 ce                     	movl	%ecx, %r14d
    464f: 41 31 f6                     	xorl	%esi, %r14d
    4652: 45 21 de                     	andl	%r11d, %r14d
    4655: 41 31 f6                     	xorl	%esi, %r14d
    4658: 03 85 f0 fe ff ff            	addl	-0x110(%rbp), %eax
    465e: 44 01 f0                     	addl	%r14d, %eax
    4661: 44 01 d0                     	addl	%r10d, %eax
    4664: 05 98 aa 07 d8               	addl	$0xd807aa98, %eax       # imm = 0xD807AA98
    4669: 41 01 c0                     	addl	%eax, %r8d
    466c: 41 89 da                     	movl	%ebx, %r10d
    466f: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4673: 41 89 de                     	movl	%ebx, %r14d
    4676: 41 c1 c6 13                  	roll	$0x13, %r14d
    467a: 45 31 d6                     	xorl	%r10d, %r14d
    467d: 41 89 df                     	movl	%ebx, %r15d
    4680: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4684: 45 31 f7                     	xorl	%r14d, %r15d
    4687: 41 89 d6                     	movl	%edx, %r14d
    468a: 45 09 ce                     	orl	%r9d, %r14d
    468d: 41 21 de                     	andl	%ebx, %r14d
    4690: 41 89 d2                     	movl	%edx, %r10d
    4693: 45 21 ca                     	andl	%r9d, %r10d
    4696: 45 09 f2                     	orl	%r14d, %r10d
    4699: 45 01 fa                     	addl	%r15d, %r10d
    469c: 41 01 c2                     	addl	%eax, %r10d
    469f: 44 89 c0                     	movl	%r8d, %eax
    46a2: c1 c0 1a                     	roll	$0x1a, %eax
    46a5: 45 89 c6                     	movl	%r8d, %r14d
    46a8: 41 c1 c6 15                  	roll	$0x15, %r14d
    46ac: 41 31 c6                     	xorl	%eax, %r14d
    46af: 44 89 c0                     	movl	%r8d, %eax
    46b2: c1 c0 07                     	roll	$0x7, %eax
    46b5: 44 31 f0                     	xorl	%r14d, %eax
    46b8: 45 89 de                     	movl	%r11d, %r14d
    46bb: 41 31 ce                     	xorl	%ecx, %r14d
    46be: 45 21 c6                     	andl	%r8d, %r14d
    46c1: 03 b5 f4 fe ff ff            	addl	-0x10c(%rbp), %esi
    46c7: 41 31 ce                     	xorl	%ecx, %r14d
    46ca: 44 01 f6                     	addl	%r14d, %esi
    46cd: 01 f0                        	addl	%esi, %eax
    46cf: 05 01 5b 83 12               	addl	$0x12835b01, %eax       # imm = 0x12835B01
    46d4: 41 01 c1                     	addl	%eax, %r9d
    46d7: 44 89 d6                     	movl	%r10d, %esi
    46da: c1 c6 1e                     	roll	$0x1e, %esi
    46dd: 45 89 d6                     	movl	%r10d, %r14d
    46e0: 41 c1 c6 13                  	roll	$0x13, %r14d
    46e4: 41 31 f6                     	xorl	%esi, %r14d
    46e7: 45 89 d7                     	movl	%r10d, %r15d
    46ea: 41 c1 c7 0a                  	roll	$0xa, %r15d
    46ee: 45 31 f7                     	xorl	%r14d, %r15d
    46f1: 41 89 de                     	movl	%ebx, %r14d
    46f4: 41 09 d6                     	orl	%edx, %r14d
    46f7: 45 21 d6                     	andl	%r10d, %r14d
    46fa: 89 de                        	movl	%ebx, %esi
    46fc: 21 d6                        	andl	%edx, %esi
    46fe: 44 09 f6                     	orl	%r14d, %esi
    4701: 45 89 ce                     	movl	%r9d, %r14d
    4704: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4708: 44 01 fe                     	addl	%r15d, %esi
    470b: 45 89 cf                     	movl	%r9d, %r15d
    470e: 41 c1 c7 15                  	roll	$0x15, %r15d
    4712: 01 c6                        	addl	%eax, %esi
    4714: 44 89 c8                     	movl	%r9d, %eax
    4717: c1 c0 07                     	roll	$0x7, %eax
    471a: 45 31 f7                     	xorl	%r14d, %r15d
    471d: 44 31 f8                     	xorl	%r15d, %eax
    4720: 45 89 c6                     	movl	%r8d, %r14d
    4723: 45 31 de                     	xorl	%r11d, %r14d
    4726: 45 21 ce                     	andl	%r9d, %r14d
    4729: 45 31 de                     	xorl	%r11d, %r14d
    472c: 03 8d f8 fe ff ff            	addl	-0x108(%rbp), %ecx
    4732: 44 01 f1                     	addl	%r14d, %ecx
    4735: 41 89 f6                     	movl	%esi, %r14d
    4738: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    473c: 01 c1                        	addl	%eax, %ecx
    473e: 81 c1 be 85 31 24            	addl	$0x243185be, %ecx       # imm = 0x243185BE
    4744: 89 f0                        	movl	%esi, %eax
    4746: c1 c0 13                     	roll	$0x13, %eax
    4749: 01 ca                        	addl	%ecx, %edx
    474b: 41 89 f7                     	movl	%esi, %r15d
    474e: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4752: 44 31 f0                     	xorl	%r14d, %eax
    4755: 41 31 c7                     	xorl	%eax, %r15d
    4758: 45 89 d6                     	movl	%r10d, %r14d
    475b: 41 09 de                     	orl	%ebx, %r14d
    475e: 41 21 f6                     	andl	%esi, %r14d
    4761: 44 89 d0                     	movl	%r10d, %eax
    4764: 21 d8                        	andl	%ebx, %eax
    4766: 44 09 f0                     	orl	%r14d, %eax
    4769: 44 01 f8                     	addl	%r15d, %eax
    476c: 41 89 d6                     	movl	%edx, %r14d
    476f: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4773: 01 c8                        	addl	%ecx, %eax
    4775: 89 d1                        	movl	%edx, %ecx
    4777: c1 c1 15                     	roll	$0x15, %ecx
    477a: 44 31 f1                     	xorl	%r14d, %ecx
    477d: 41 89 d6                     	movl	%edx, %r14d
    4780: 41 c1 c6 07                  	roll	$0x7, %r14d
    4784: 41 31 ce                     	xorl	%ecx, %r14d
    4787: 44 89 c9                     	movl	%r9d, %ecx
    478a: 44 31 c1                     	xorl	%r8d, %ecx
    478d: 21 d1                        	andl	%edx, %ecx
    478f: 44 31 c1                     	xorl	%r8d, %ecx
    4792: 44 03 9d fc fe ff ff         	addl	-0x104(%rbp), %r11d
    4799: 41 01 cb                     	addl	%ecx, %r11d
    479c: 43 8d 0c 1e                  	leal	(%r14,%r11), %ecx
    47a0: 81 c1 c3 7d 0c 55            	addl	$0x550c7dc3, %ecx       # imm = 0x550C7DC3
    47a6: 41 89 c3                     	movl	%eax, %r11d
    47a9: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    47ad: 01 cb                        	addl	%ecx, %ebx
    47af: 41 89 c6                     	movl	%eax, %r14d
    47b2: 41 c1 c6 13                  	roll	$0x13, %r14d
    47b6: 45 31 de                     	xorl	%r11d, %r14d
    47b9: 41 89 c7                     	movl	%eax, %r15d
    47bc: 41 c1 c7 0a                  	roll	$0xa, %r15d
    47c0: 45 31 f7                     	xorl	%r14d, %r15d
    47c3: 41 89 f6                     	movl	%esi, %r14d
    47c6: 45 09 d6                     	orl	%r10d, %r14d
    47c9: 41 21 c6                     	andl	%eax, %r14d
    47cc: 41 89 f3                     	movl	%esi, %r11d
    47cf: 45 21 d3                     	andl	%r10d, %r11d
    47d2: 45 09 f3                     	orl	%r14d, %r11d
    47d5: 45 01 fb                     	addl	%r15d, %r11d
    47d8: 41 01 cb                     	addl	%ecx, %r11d
    47db: 89 d9                        	movl	%ebx, %ecx
    47dd: c1 c1 1a                     	roll	$0x1a, %ecx
    47e0: 41 89 de                     	movl	%ebx, %r14d
    47e3: 41 c1 c6 15                  	roll	$0x15, %r14d
    47e7: 41 31 ce                     	xorl	%ecx, %r14d
    47ea: 89 d9                        	movl	%ebx, %ecx
    47ec: c1 c1 07                     	roll	$0x7, %ecx
    47ef: 44 31 f1                     	xorl	%r14d, %ecx
    47f2: 41 89 d6                     	movl	%edx, %r14d
    47f5: 45 31 ce                     	xorl	%r9d, %r14d
    47f8: 41 21 de                     	andl	%ebx, %r14d
    47fb: 45 31 ce                     	xorl	%r9d, %r14d
    47fe: 44 03 85 00 ff ff ff         	addl	-0x100(%rbp), %r8d
    4805: 45 01 f0                     	addl	%r14d, %r8d
    4808: 44 01 c1                     	addl	%r8d, %ecx
    480b: 81 c1 74 5d be 72            	addl	$0x72be5d74, %ecx       # imm = 0x72BE5D74
    4811: 41 01 ca                     	addl	%ecx, %r10d
    4814: 45 89 d8                     	movl	%r11d, %r8d
    4817: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    481b: 45 89 de                     	movl	%r11d, %r14d
    481e: 41 c1 c6 13                  	roll	$0x13, %r14d
    4822: 45 31 c6                     	xorl	%r8d, %r14d
    4825: 45 89 df                     	movl	%r11d, %r15d
    4828: 41 c1 c7 0a                  	roll	$0xa, %r15d
    482c: 45 31 f7                     	xorl	%r14d, %r15d
    482f: 41 89 c6                     	movl	%eax, %r14d
    4832: 41 09 f6                     	orl	%esi, %r14d
    4835: 45 21 de                     	andl	%r11d, %r14d
    4838: 41 89 c0                     	movl	%eax, %r8d
    483b: 41 21 f0                     	andl	%esi, %r8d
    483e: 45 09 f0                     	orl	%r14d, %r8d
    4841: 45 01 f8                     	addl	%r15d, %r8d
    4844: 41 01 c8                     	addl	%ecx, %r8d
    4847: 44 89 d1                     	movl	%r10d, %ecx
    484a: c1 c1 1a                     	roll	$0x1a, %ecx
    484d: 45 89 d6                     	movl	%r10d, %r14d
    4850: 41 c1 c6 15                  	roll	$0x15, %r14d
    4854: 41 31 ce                     	xorl	%ecx, %r14d
    4857: 44 89 d1                     	movl	%r10d, %ecx
    485a: c1 c1 07                     	roll	$0x7, %ecx
    485d: 44 31 f1                     	xorl	%r14d, %ecx
    4860: 41 89 de                     	movl	%ebx, %r14d
    4863: 41 31 d6                     	xorl	%edx, %r14d
    4866: 45 21 d6                     	andl	%r10d, %r14d
    4869: 44 03 8d 04 ff ff ff         	addl	-0xfc(%rbp), %r9d
    4870: 41 31 d6                     	xorl	%edx, %r14d
    4873: 45 01 f1                     	addl	%r14d, %r9d
    4876: 44 01 c9                     	addl	%r9d, %ecx
    4879: 81 c1 fe b1 de 80            	addl	$0x80deb1fe, %ecx       # imm = 0x80DEB1FE
    487f: 01 ce                        	addl	%ecx, %esi
    4881: 45 89 c1                     	movl	%r8d, %r9d
    4884: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4888: 45 89 c6                     	movl	%r8d, %r14d
    488b: 41 c1 c6 13                  	roll	$0x13, %r14d
    488f: 45 31 ce                     	xorl	%r9d, %r14d
    4892: 45 89 c7                     	movl	%r8d, %r15d
    4895: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4899: 45 31 f7                     	xorl	%r14d, %r15d
    489c: 45 89 de                     	movl	%r11d, %r14d
    489f: 41 09 c6                     	orl	%eax, %r14d
    48a2: 45 21 c6                     	andl	%r8d, %r14d
    48a5: 45 89 d9                     	movl	%r11d, %r9d
    48a8: 41 21 c1                     	andl	%eax, %r9d
    48ab: 45 09 f1                     	orl	%r14d, %r9d
    48ae: 41 89 f6                     	movl	%esi, %r14d
    48b1: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    48b5: 45 01 f9                     	addl	%r15d, %r9d
    48b8: 41 89 f7                     	movl	%esi, %r15d
    48bb: 41 c1 c7 15                  	roll	$0x15, %r15d
    48bf: 41 01 c9                     	addl	%ecx, %r9d
    48c2: 89 f1                        	movl	%esi, %ecx
    48c4: c1 c1 07                     	roll	$0x7, %ecx
    48c7: 45 31 f7                     	xorl	%r14d, %r15d
    48ca: 44 31 f9                     	xorl	%r15d, %ecx
    48cd: 45 89 d6                     	movl	%r10d, %r14d
    48d0: 41 31 de                     	xorl	%ebx, %r14d
    48d3: 41 21 f6                     	andl	%esi, %r14d
    48d6: 41 31 de                     	xorl	%ebx, %r14d
    48d9: 03 95 08 ff ff ff            	addl	-0xf8(%rbp), %edx
    48df: 44 01 f2                     	addl	%r14d, %edx
    48e2: 45 89 ce                     	movl	%r9d, %r14d
    48e5: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    48e9: 01 ca                        	addl	%ecx, %edx
    48eb: 81 c2 a7 06 dc 9b            	addl	$0x9bdc06a7, %edx       # imm = 0x9BDC06A7
    48f1: 44 89 c9                     	movl	%r9d, %ecx
    48f4: c1 c1 13                     	roll	$0x13, %ecx
    48f7: 01 d0                        	addl	%edx, %eax
    48f9: 45 89 cf                     	movl	%r9d, %r15d
    48fc: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4900: 44 31 f1                     	xorl	%r14d, %ecx
    4903: 41 31 cf                     	xorl	%ecx, %r15d
    4906: 45 89 c6                     	movl	%r8d, %r14d
    4909: 45 09 de                     	orl	%r11d, %r14d
    490c: 45 21 ce                     	andl	%r9d, %r14d
    490f: 44 89 c1                     	movl	%r8d, %ecx
    4912: 44 21 d9                     	andl	%r11d, %ecx
    4915: 44 09 f1                     	orl	%r14d, %ecx
    4918: 44 01 f9                     	addl	%r15d, %ecx
    491b: 41 89 c6                     	movl	%eax, %r14d
    491e: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4922: 01 d1                        	addl	%edx, %ecx
    4924: 89 c2                        	movl	%eax, %edx
    4926: c1 c2 15                     	roll	$0x15, %edx
    4929: 44 31 f2                     	xorl	%r14d, %edx
    492c: 41 89 c6                     	movl	%eax, %r14d
    492f: 41 c1 c6 07                  	roll	$0x7, %r14d
    4933: 41 31 d6                     	xorl	%edx, %r14d
    4936: 89 f2                        	movl	%esi, %edx
    4938: 44 31 d2                     	xorl	%r10d, %edx
    493b: 21 c2                        	andl	%eax, %edx
    493d: 44 31 d2                     	xorl	%r10d, %edx
    4940: 03 9d 0c ff ff ff            	addl	-0xf4(%rbp), %ebx
    4946: 01 d3                        	addl	%edx, %ebx
    4948: 41 8d 14 1e                  	leal	(%r14,%rbx), %edx
    494c: 81 c2 74 f1 9b c1            	addl	$0xc19bf174, %edx       # imm = 0xC19BF174
    4952: 89 cb                        	movl	%ecx, %ebx
    4954: c1 c3 1e                     	roll	$0x1e, %ebx
    4957: 41 01 d3                     	addl	%edx, %r11d
    495a: 41 89 ce                     	movl	%ecx, %r14d
    495d: 41 c1 c6 13                  	roll	$0x13, %r14d
    4961: 41 31 de                     	xorl	%ebx, %r14d
    4964: 41 89 cf                     	movl	%ecx, %r15d
    4967: 41 c1 c7 0a                  	roll	$0xa, %r15d
    496b: 45 31 f7                     	xorl	%r14d, %r15d
    496e: 45 89 ce                     	movl	%r9d, %r14d
    4971: 45 09 c6                     	orl	%r8d, %r14d
    4974: 41 21 ce                     	andl	%ecx, %r14d
    4977: 44 89 cb                     	movl	%r9d, %ebx
    497a: 44 21 c3                     	andl	%r8d, %ebx
    497d: 44 09 f3                     	orl	%r14d, %ebx
    4980: 44 01 fb                     	addl	%r15d, %ebx
    4983: 01 d3                        	addl	%edx, %ebx
    4985: 44 89 da                     	movl	%r11d, %edx
    4988: c1 c2 1a                     	roll	$0x1a, %edx
    498b: 45 89 de                     	movl	%r11d, %r14d
    498e: 41 c1 c6 15                  	roll	$0x15, %r14d
    4992: 41 31 d6                     	xorl	%edx, %r14d
    4995: 44 89 da                     	movl	%r11d, %edx
    4998: c1 c2 07                     	roll	$0x7, %edx
    499b: 44 31 f2                     	xorl	%r14d, %edx
    499e: 41 89 c6                     	movl	%eax, %r14d
    49a1: 41 31 f6                     	xorl	%esi, %r14d
    49a4: 45 21 de                     	andl	%r11d, %r14d
    49a7: 41 31 f6                     	xorl	%esi, %r14d
    49aa: 44 03 95 10 ff ff ff         	addl	-0xf0(%rbp), %r10d
    49b1: 45 01 f2                     	addl	%r14d, %r10d
    49b4: 41 01 d2                     	addl	%edx, %r10d
    49b7: 41 81 c2 c1 69 9b e4         	addl	$0xe49b69c1, %r10d      # imm = 0xE49B69C1
    49be: 45 01 d0                     	addl	%r10d, %r8d
    49c1: 89 da                        	movl	%ebx, %edx
    49c3: c1 c2 1e                     	roll	$0x1e, %edx
    49c6: 41 89 de                     	movl	%ebx, %r14d
    49c9: 41 c1 c6 13                  	roll	$0x13, %r14d
    49cd: 41 31 d6                     	xorl	%edx, %r14d
    49d0: 41 89 df                     	movl	%ebx, %r15d
    49d3: 41 c1 c7 0a                  	roll	$0xa, %r15d
    49d7: 45 31 f7                     	xorl	%r14d, %r15d
    49da: 41 89 ce                     	movl	%ecx, %r14d
    49dd: 45 09 ce                     	orl	%r9d, %r14d
    49e0: 41 21 de                     	andl	%ebx, %r14d
    49e3: 89 ca                        	movl	%ecx, %edx
    49e5: 44 21 ca                     	andl	%r9d, %edx
    49e8: 44 09 f2                     	orl	%r14d, %edx
    49eb: 44 01 fa                     	addl	%r15d, %edx
    49ee: 44 01 d2                     	addl	%r10d, %edx
    49f1: 45 89 c2                     	movl	%r8d, %r10d
    49f4: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    49f8: 45 89 c6                     	movl	%r8d, %r14d
    49fb: 41 c1 c6 15                  	roll	$0x15, %r14d
    49ff: 45 31 d6                     	xorl	%r10d, %r14d
    4a02: 45 89 c2                     	movl	%r8d, %r10d
    4a05: 41 c1 c2 07                  	roll	$0x7, %r10d
    4a09: 45 31 f2                     	xorl	%r14d, %r10d
    4a0c: 45 89 de                     	movl	%r11d, %r14d
    4a0f: 41 31 c6                     	xorl	%eax, %r14d
    4a12: 45 21 c6                     	andl	%r8d, %r14d
    4a15: 03 b5 14 ff ff ff            	addl	-0xec(%rbp), %esi
    4a1b: 41 31 c6                     	xorl	%eax, %r14d
    4a1e: 44 01 f6                     	addl	%r14d, %esi
    4a21: 41 01 f2                     	addl	%esi, %r10d
    4a24: 41 81 c2 86 47 be ef         	addl	$0xefbe4786, %r10d      # imm = 0xEFBE4786
    4a2b: 45 01 d1                     	addl	%r10d, %r9d
    4a2e: 89 d6                        	movl	%edx, %esi
    4a30: c1 c6 1e                     	roll	$0x1e, %esi
    4a33: 41 89 d6                     	movl	%edx, %r14d
    4a36: 41 c1 c6 13                  	roll	$0x13, %r14d
    4a3a: 41 31 f6                     	xorl	%esi, %r14d
    4a3d: 41 89 d7                     	movl	%edx, %r15d
    4a40: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4a44: 45 31 f7                     	xorl	%r14d, %r15d
    4a47: 41 89 de                     	movl	%ebx, %r14d
    4a4a: 41 09 ce                     	orl	%ecx, %r14d
    4a4d: 41 21 d6                     	andl	%edx, %r14d
    4a50: 89 de                        	movl	%ebx, %esi
    4a52: 21 ce                        	andl	%ecx, %esi
    4a54: 44 09 f6                     	orl	%r14d, %esi
    4a57: 45 89 ce                     	movl	%r9d, %r14d
    4a5a: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4a5e: 44 01 fe                     	addl	%r15d, %esi
    4a61: 45 89 cf                     	movl	%r9d, %r15d
    4a64: 41 c1 c7 15                  	roll	$0x15, %r15d
    4a68: 44 01 d6                     	addl	%r10d, %esi
    4a6b: 45 89 ca                     	movl	%r9d, %r10d
    4a6e: 41 c1 c2 07                  	roll	$0x7, %r10d
    4a72: 45 31 f7                     	xorl	%r14d, %r15d
    4a75: 45 31 fa                     	xorl	%r15d, %r10d
    4a78: 45 89 c6                     	movl	%r8d, %r14d
    4a7b: 45 31 de                     	xorl	%r11d, %r14d
    4a7e: 45 21 ce                     	andl	%r9d, %r14d
    4a81: 45 31 de                     	xorl	%r11d, %r14d
    4a84: 03 85 18 ff ff ff            	addl	-0xe8(%rbp), %eax
    4a8a: 44 01 f0                     	addl	%r14d, %eax
    4a8d: 41 89 f6                     	movl	%esi, %r14d
    4a90: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4a94: 41 01 c2                     	addl	%eax, %r10d
    4a97: 41 81 c2 c6 9d c1 0f         	addl	$0xfc19dc6, %r10d       # imm = 0xFC19DC6
    4a9e: 89 f0                        	movl	%esi, %eax
    4aa0: c1 c0 13                     	roll	$0x13, %eax
    4aa3: 44 01 d1                     	addl	%r10d, %ecx
    4aa6: 41 89 f7                     	movl	%esi, %r15d
    4aa9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4aad: 44 31 f0                     	xorl	%r14d, %eax
    4ab0: 41 31 c7                     	xorl	%eax, %r15d
    4ab3: 41 89 d6                     	movl	%edx, %r14d
    4ab6: 41 09 de                     	orl	%ebx, %r14d
    4ab9: 41 21 f6                     	andl	%esi, %r14d
    4abc: 89 d0                        	movl	%edx, %eax
    4abe: 21 d8                        	andl	%ebx, %eax
    4ac0: 44 09 f0                     	orl	%r14d, %eax
    4ac3: 44 01 f8                     	addl	%r15d, %eax
    4ac6: 41 89 ce                     	movl	%ecx, %r14d
    4ac9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4acd: 44 01 d0                     	addl	%r10d, %eax
    4ad0: 41 89 ca                     	movl	%ecx, %r10d
    4ad3: 41 c1 c2 15                  	roll	$0x15, %r10d
    4ad7: 45 31 f2                     	xorl	%r14d, %r10d
    4ada: 41 89 ce                     	movl	%ecx, %r14d
    4add: 41 c1 c6 07                  	roll	$0x7, %r14d
    4ae1: 45 31 d6                     	xorl	%r10d, %r14d
    4ae4: 45 89 ca                     	movl	%r9d, %r10d
    4ae7: 45 31 c2                     	xorl	%r8d, %r10d
    4aea: 41 21 ca                     	andl	%ecx, %r10d
    4aed: 45 31 c2                     	xorl	%r8d, %r10d
    4af0: 44 03 9d 1c ff ff ff         	addl	-0xe4(%rbp), %r11d
    4af7: 45 01 d3                     	addl	%r10d, %r11d
    4afa: 45 01 f3                     	addl	%r14d, %r11d
    4afd: 41 81 c3 cc a1 0c 24         	addl	$0x240ca1cc, %r11d      # imm = 0x240CA1CC
    4b04: 41 89 c2                     	movl	%eax, %r10d
    4b07: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4b0b: 44 01 db                     	addl	%r11d, %ebx
    4b0e: 41 89 c6                     	movl	%eax, %r14d
    4b11: 41 c1 c6 13                  	roll	$0x13, %r14d
    4b15: 45 31 d6                     	xorl	%r10d, %r14d
    4b18: 41 89 c7                     	movl	%eax, %r15d
    4b1b: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4b1f: 45 31 f7                     	xorl	%r14d, %r15d
    4b22: 41 89 f6                     	movl	%esi, %r14d
    4b25: 41 09 d6                     	orl	%edx, %r14d
    4b28: 41 21 c6                     	andl	%eax, %r14d
    4b2b: 41 89 f2                     	movl	%esi, %r10d
    4b2e: 41 21 d2                     	andl	%edx, %r10d
    4b31: 45 09 f2                     	orl	%r14d, %r10d
    4b34: 45 01 fa                     	addl	%r15d, %r10d
    4b37: 45 01 da                     	addl	%r11d, %r10d
    4b3a: 41 89 db                     	movl	%ebx, %r11d
    4b3d: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    4b41: 41 89 de                     	movl	%ebx, %r14d
    4b44: 41 c1 c6 15                  	roll	$0x15, %r14d
    4b48: 45 31 de                     	xorl	%r11d, %r14d
    4b4b: 41 89 db                     	movl	%ebx, %r11d
    4b4e: 41 c1 c3 07                  	roll	$0x7, %r11d
    4b52: 45 31 f3                     	xorl	%r14d, %r11d
    4b55: 41 89 ce                     	movl	%ecx, %r14d
    4b58: 45 31 ce                     	xorl	%r9d, %r14d
    4b5b: 41 21 de                     	andl	%ebx, %r14d
    4b5e: 45 31 ce                     	xorl	%r9d, %r14d
    4b61: 44 03 85 20 ff ff ff         	addl	-0xe0(%rbp), %r8d
    4b68: 45 01 f0                     	addl	%r14d, %r8d
    4b6b: 45 01 c3                     	addl	%r8d, %r11d
    4b6e: 41 81 c3 6f 2c e9 2d         	addl	$0x2de92c6f, %r11d      # imm = 0x2DE92C6F
    4b75: 44 01 da                     	addl	%r11d, %edx
    4b78: 45 89 d0                     	movl	%r10d, %r8d
    4b7b: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    4b7f: 45 89 d6                     	movl	%r10d, %r14d
    4b82: 41 c1 c6 13                  	roll	$0x13, %r14d
    4b86: 45 31 c6                     	xorl	%r8d, %r14d
    4b89: 45 89 d7                     	movl	%r10d, %r15d
    4b8c: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4b90: 45 31 f7                     	xorl	%r14d, %r15d
    4b93: 41 89 c6                     	movl	%eax, %r14d
    4b96: 41 09 f6                     	orl	%esi, %r14d
    4b99: 45 21 d6                     	andl	%r10d, %r14d
    4b9c: 41 89 c0                     	movl	%eax, %r8d
    4b9f: 41 21 f0                     	andl	%esi, %r8d
    4ba2: 45 09 f0                     	orl	%r14d, %r8d
    4ba5: 45 01 f8                     	addl	%r15d, %r8d
    4ba8: 45 01 d8                     	addl	%r11d, %r8d
    4bab: 41 89 d3                     	movl	%edx, %r11d
    4bae: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    4bb2: 41 89 d6                     	movl	%edx, %r14d
    4bb5: 41 c1 c6 15                  	roll	$0x15, %r14d
    4bb9: 45 31 de                     	xorl	%r11d, %r14d
    4bbc: 41 89 d3                     	movl	%edx, %r11d
    4bbf: 41 c1 c3 07                  	roll	$0x7, %r11d
    4bc3: 45 31 f3                     	xorl	%r14d, %r11d
    4bc6: 41 89 de                     	movl	%ebx, %r14d
    4bc9: 41 31 ce                     	xorl	%ecx, %r14d
    4bcc: 41 21 d6                     	andl	%edx, %r14d
    4bcf: 44 03 8d 24 ff ff ff         	addl	-0xdc(%rbp), %r9d
    4bd6: 41 31 ce                     	xorl	%ecx, %r14d
    4bd9: 45 01 f1                     	addl	%r14d, %r9d
    4bdc: 45 01 cb                     	addl	%r9d, %r11d
    4bdf: 41 81 c3 aa 84 74 4a         	addl	$0x4a7484aa, %r11d      # imm = 0x4A7484AA
    4be6: 44 01 de                     	addl	%r11d, %esi
    4be9: 45 89 c1                     	movl	%r8d, %r9d
    4bec: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4bf0: 45 89 c6                     	movl	%r8d, %r14d
    4bf3: 41 c1 c6 13                  	roll	$0x13, %r14d
    4bf7: 45 31 ce                     	xorl	%r9d, %r14d
    4bfa: 45 89 c7                     	movl	%r8d, %r15d
    4bfd: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4c01: 45 31 f7                     	xorl	%r14d, %r15d
    4c04: 45 89 d6                     	movl	%r10d, %r14d
    4c07: 41 09 c6                     	orl	%eax, %r14d
    4c0a: 45 21 c6                     	andl	%r8d, %r14d
    4c0d: 45 89 d1                     	movl	%r10d, %r9d
    4c10: 41 21 c1                     	andl	%eax, %r9d
    4c13: 45 09 f1                     	orl	%r14d, %r9d
    4c16: 41 89 f6                     	movl	%esi, %r14d
    4c19: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4c1d: 45 01 f9                     	addl	%r15d, %r9d
    4c20: 41 89 f7                     	movl	%esi, %r15d
    4c23: 41 c1 c7 15                  	roll	$0x15, %r15d
    4c27: 45 01 d9                     	addl	%r11d, %r9d
    4c2a: 41 89 f3                     	movl	%esi, %r11d
    4c2d: 41 c1 c3 07                  	roll	$0x7, %r11d
    4c31: 45 31 f7                     	xorl	%r14d, %r15d
    4c34: 45 31 fb                     	xorl	%r15d, %r11d
    4c37: 41 89 d6                     	movl	%edx, %r14d
    4c3a: 41 31 de                     	xorl	%ebx, %r14d
    4c3d: 41 21 f6                     	andl	%esi, %r14d
    4c40: 41 31 de                     	xorl	%ebx, %r14d
    4c43: 03 8d 28 ff ff ff            	addl	-0xd8(%rbp), %ecx
    4c49: 44 01 f1                     	addl	%r14d, %ecx
    4c4c: 45 89 ce                     	movl	%r9d, %r14d
    4c4f: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4c53: 41 01 cb                     	addl	%ecx, %r11d
    4c56: 41 81 c3 dc a9 b0 5c         	addl	$0x5cb0a9dc, %r11d      # imm = 0x5CB0A9DC
    4c5d: 44 89 c9                     	movl	%r9d, %ecx
    4c60: c1 c1 13                     	roll	$0x13, %ecx
    4c63: 44 01 d8                     	addl	%r11d, %eax
    4c66: 45 89 cf                     	movl	%r9d, %r15d
    4c69: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4c6d: 44 31 f1                     	xorl	%r14d, %ecx
    4c70: 41 31 cf                     	xorl	%ecx, %r15d
    4c73: 45 89 c6                     	movl	%r8d, %r14d
    4c76: 45 09 d6                     	orl	%r10d, %r14d
    4c79: 45 21 ce                     	andl	%r9d, %r14d
    4c7c: 44 89 c1                     	movl	%r8d, %ecx
    4c7f: 44 21 d1                     	andl	%r10d, %ecx
    4c82: 44 09 f1                     	orl	%r14d, %ecx
    4c85: 44 01 f9                     	addl	%r15d, %ecx
    4c88: 41 89 c6                     	movl	%eax, %r14d
    4c8b: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4c8f: 44 01 d9                     	addl	%r11d, %ecx
    4c92: 41 89 c3                     	movl	%eax, %r11d
    4c95: 41 c1 c3 15                  	roll	$0x15, %r11d
    4c99: 45 31 f3                     	xorl	%r14d, %r11d
    4c9c: 41 89 c6                     	movl	%eax, %r14d
    4c9f: 41 c1 c6 07                  	roll	$0x7, %r14d
    4ca3: 45 31 de                     	xorl	%r11d, %r14d
    4ca6: 41 89 f3                     	movl	%esi, %r11d
    4ca9: 41 31 d3                     	xorl	%edx, %r11d
    4cac: 41 21 c3                     	andl	%eax, %r11d
    4caf: 41 31 d3                     	xorl	%edx, %r11d
    4cb2: 03 9d 2c ff ff ff            	addl	-0xd4(%rbp), %ebx
    4cb8: 44 01 db                     	addl	%r11d, %ebx
    4cbb: 44 01 f3                     	addl	%r14d, %ebx
    4cbe: 81 c3 da 88 f9 76            	addl	$0x76f988da, %ebx       # imm = 0x76F988DA
    4cc4: 41 89 cb                     	movl	%ecx, %r11d
    4cc7: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    4ccb: 41 01 da                     	addl	%ebx, %r10d
    4cce: 41 89 ce                     	movl	%ecx, %r14d
    4cd1: 41 c1 c6 13                  	roll	$0x13, %r14d
    4cd5: 45 31 de                     	xorl	%r11d, %r14d
    4cd8: 41 89 cf                     	movl	%ecx, %r15d
    4cdb: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4cdf: 45 31 f7                     	xorl	%r14d, %r15d
    4ce2: 45 89 ce                     	movl	%r9d, %r14d
    4ce5: 45 09 c6                     	orl	%r8d, %r14d
    4ce8: 41 21 ce                     	andl	%ecx, %r14d
    4ceb: 45 89 cb                     	movl	%r9d, %r11d
    4cee: 45 21 c3                     	andl	%r8d, %r11d
    4cf1: 45 09 f3                     	orl	%r14d, %r11d
    4cf4: 45 01 fb                     	addl	%r15d, %r11d
    4cf7: 41 01 db                     	addl	%ebx, %r11d
    4cfa: 44 89 d3                     	movl	%r10d, %ebx
    4cfd: c1 c3 1a                     	roll	$0x1a, %ebx
    4d00: 45 89 d6                     	movl	%r10d, %r14d
    4d03: 41 c1 c6 15                  	roll	$0x15, %r14d
    4d07: 41 31 de                     	xorl	%ebx, %r14d
    4d0a: 44 89 d3                     	movl	%r10d, %ebx
    4d0d: c1 c3 07                     	roll	$0x7, %ebx
    4d10: 44 31 f3                     	xorl	%r14d, %ebx
    4d13: 41 89 c6                     	movl	%eax, %r14d
    4d16: 41 31 f6                     	xorl	%esi, %r14d
    4d19: 45 21 d6                     	andl	%r10d, %r14d
    4d1c: 41 31 f6                     	xorl	%esi, %r14d
    4d1f: 03 95 30 ff ff ff            	addl	-0xd0(%rbp), %edx
    4d25: 44 01 f2                     	addl	%r14d, %edx
    4d28: 01 d3                        	addl	%edx, %ebx
    4d2a: 81 c3 52 51 3e 98            	addl	$0x983e5152, %ebx       # imm = 0x983E5152
    4d30: 41 01 d8                     	addl	%ebx, %r8d
    4d33: 44 89 da                     	movl	%r11d, %edx
    4d36: c1 c2 1e                     	roll	$0x1e, %edx
    4d39: 45 89 de                     	movl	%r11d, %r14d
    4d3c: 41 c1 c6 13                  	roll	$0x13, %r14d
    4d40: 41 31 d6                     	xorl	%edx, %r14d
    4d43: 45 89 df                     	movl	%r11d, %r15d
    4d46: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4d4a: 45 31 f7                     	xorl	%r14d, %r15d
    4d4d: 41 89 ce                     	movl	%ecx, %r14d
    4d50: 45 09 ce                     	orl	%r9d, %r14d
    4d53: 45 21 de                     	andl	%r11d, %r14d
    4d56: 89 ca                        	movl	%ecx, %edx
    4d58: 44 21 ca                     	andl	%r9d, %edx
    4d5b: 44 09 f2                     	orl	%r14d, %edx
    4d5e: 44 01 fa                     	addl	%r15d, %edx
    4d61: 01 da                        	addl	%ebx, %edx
    4d63: 44 89 c3                     	movl	%r8d, %ebx
    4d66: c1 c3 1a                     	roll	$0x1a, %ebx
    4d69: 45 89 c6                     	movl	%r8d, %r14d
    4d6c: 41 c1 c6 15                  	roll	$0x15, %r14d
    4d70: 41 31 de                     	xorl	%ebx, %r14d
    4d73: 44 89 c3                     	movl	%r8d, %ebx
    4d76: c1 c3 07                     	roll	$0x7, %ebx
    4d79: 44 31 f3                     	xorl	%r14d, %ebx
    4d7c: 45 89 d6                     	movl	%r10d, %r14d
    4d7f: 41 31 c6                     	xorl	%eax, %r14d
    4d82: 45 21 c6                     	andl	%r8d, %r14d
    4d85: 03 b5 34 ff ff ff            	addl	-0xcc(%rbp), %esi
    4d8b: 41 31 c6                     	xorl	%eax, %r14d
    4d8e: 44 01 f6                     	addl	%r14d, %esi
    4d91: 01 f3                        	addl	%esi, %ebx
    4d93: 81 c3 6d c6 31 a8            	addl	$0xa831c66d, %ebx       # imm = 0xA831C66D
    4d99: 41 01 d9                     	addl	%ebx, %r9d
    4d9c: 89 d6                        	movl	%edx, %esi
    4d9e: c1 c6 1e                     	roll	$0x1e, %esi
    4da1: 41 89 d6                     	movl	%edx, %r14d
    4da4: 41 c1 c6 13                  	roll	$0x13, %r14d
    4da8: 41 31 f6                     	xorl	%esi, %r14d
    4dab: 41 89 d7                     	movl	%edx, %r15d
    4dae: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4db2: 45 31 f7                     	xorl	%r14d, %r15d
    4db5: 45 89 de                     	movl	%r11d, %r14d
    4db8: 41 09 ce                     	orl	%ecx, %r14d
    4dbb: 41 21 d6                     	andl	%edx, %r14d
    4dbe: 44 89 de                     	movl	%r11d, %esi
    4dc1: 21 ce                        	andl	%ecx, %esi
    4dc3: 44 09 f6                     	orl	%r14d, %esi
    4dc6: 45 89 ce                     	movl	%r9d, %r14d
    4dc9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4dcd: 44 01 fe                     	addl	%r15d, %esi
    4dd0: 45 89 cf                     	movl	%r9d, %r15d
    4dd3: 41 c1 c7 15                  	roll	$0x15, %r15d
    4dd7: 01 de                        	addl	%ebx, %esi
    4dd9: 44 89 cb                     	movl	%r9d, %ebx
    4ddc: c1 c3 07                     	roll	$0x7, %ebx
    4ddf: 45 31 f7                     	xorl	%r14d, %r15d
    4de2: 44 31 fb                     	xorl	%r15d, %ebx
    4de5: 45 89 c6                     	movl	%r8d, %r14d
    4de8: 45 31 d6                     	xorl	%r10d, %r14d
    4deb: 45 21 ce                     	andl	%r9d, %r14d
    4dee: 45 31 d6                     	xorl	%r10d, %r14d
    4df1: 03 85 38 ff ff ff            	addl	-0xc8(%rbp), %eax
    4df7: 44 01 f0                     	addl	%r14d, %eax
    4dfa: 41 89 f6                     	movl	%esi, %r14d
    4dfd: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4e01: 01 c3                        	addl	%eax, %ebx
    4e03: 81 c3 c8 27 03 b0            	addl	$0xb00327c8, %ebx       # imm = 0xB00327C8
    4e09: 89 f0                        	movl	%esi, %eax
    4e0b: c1 c0 13                     	roll	$0x13, %eax
    4e0e: 01 d9                        	addl	%ebx, %ecx
    4e10: 41 89 f7                     	movl	%esi, %r15d
    4e13: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4e17: 44 31 f0                     	xorl	%r14d, %eax
    4e1a: 41 31 c7                     	xorl	%eax, %r15d
    4e1d: 41 89 d6                     	movl	%edx, %r14d
    4e20: 45 09 de                     	orl	%r11d, %r14d
    4e23: 41 21 f6                     	andl	%esi, %r14d
    4e26: 89 d0                        	movl	%edx, %eax
    4e28: 44 21 d8                     	andl	%r11d, %eax
    4e2b: 44 09 f0                     	orl	%r14d, %eax
    4e2e: 44 01 f8                     	addl	%r15d, %eax
    4e31: 41 89 ce                     	movl	%ecx, %r14d
    4e34: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4e38: 01 d8                        	addl	%ebx, %eax
    4e3a: 89 cb                        	movl	%ecx, %ebx
    4e3c: c1 c3 15                     	roll	$0x15, %ebx
    4e3f: 44 31 f3                     	xorl	%r14d, %ebx
    4e42: 41 89 ce                     	movl	%ecx, %r14d
    4e45: 41 c1 c6 07                  	roll	$0x7, %r14d
    4e49: 41 31 de                     	xorl	%ebx, %r14d
    4e4c: 44 89 cb                     	movl	%r9d, %ebx
    4e4f: 44 31 c3                     	xorl	%r8d, %ebx
    4e52: 21 cb                        	andl	%ecx, %ebx
    4e54: 44 31 c3                     	xorl	%r8d, %ebx
    4e57: 44 03 95 3c ff ff ff         	addl	-0xc4(%rbp), %r10d
    4e5e: 41 01 da                     	addl	%ebx, %r10d
    4e61: 43 8d 1c 16                  	leal	(%r14,%r10), %ebx
    4e65: 81 c3 c7 7f 59 bf            	addl	$0xbf597fc7, %ebx       # imm = 0xBF597FC7
    4e6b: 41 89 c2                     	movl	%eax, %r10d
    4e6e: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4e72: 41 01 db                     	addl	%ebx, %r11d
    4e75: 41 89 c6                     	movl	%eax, %r14d
    4e78: 41 c1 c6 13                  	roll	$0x13, %r14d
    4e7c: 45 31 d6                     	xorl	%r10d, %r14d
    4e7f: 41 89 c7                     	movl	%eax, %r15d
    4e82: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4e86: 45 31 f7                     	xorl	%r14d, %r15d
    4e89: 41 89 f6                     	movl	%esi, %r14d
    4e8c: 41 09 d6                     	orl	%edx, %r14d
    4e8f: 41 21 c6                     	andl	%eax, %r14d
    4e92: 41 89 f2                     	movl	%esi, %r10d
    4e95: 41 21 d2                     	andl	%edx, %r10d
    4e98: 45 09 f2                     	orl	%r14d, %r10d
    4e9b: 45 01 fa                     	addl	%r15d, %r10d
    4e9e: 41 01 da                     	addl	%ebx, %r10d
    4ea1: 44 89 db                     	movl	%r11d, %ebx
    4ea4: c1 c3 1a                     	roll	$0x1a, %ebx
    4ea7: 45 89 de                     	movl	%r11d, %r14d
    4eaa: 41 c1 c6 15                  	roll	$0x15, %r14d
    4eae: 41 31 de                     	xorl	%ebx, %r14d
    4eb1: 44 89 db                     	movl	%r11d, %ebx
    4eb4: c1 c3 07                     	roll	$0x7, %ebx
    4eb7: 44 31 f3                     	xorl	%r14d, %ebx
    4eba: 41 89 ce                     	movl	%ecx, %r14d
    4ebd: 45 31 ce                     	xorl	%r9d, %r14d
    4ec0: 45 21 de                     	andl	%r11d, %r14d
    4ec3: 45 31 ce                     	xorl	%r9d, %r14d
    4ec6: 44 03 85 40 ff ff ff         	addl	-0xc0(%rbp), %r8d
    4ecd: 45 01 f0                     	addl	%r14d, %r8d
    4ed0: 44 01 c3                     	addl	%r8d, %ebx
    4ed3: 81 c3 f3 0b e0 c6            	addl	$0xc6e00bf3, %ebx       # imm = 0xC6E00BF3
    4ed9: 01 da                        	addl	%ebx, %edx
    4edb: 45 89 d0                     	movl	%r10d, %r8d
    4ede: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    4ee2: 45 89 d6                     	movl	%r10d, %r14d
    4ee5: 41 c1 c6 13                  	roll	$0x13, %r14d
    4ee9: 45 31 c6                     	xorl	%r8d, %r14d
    4eec: 45 89 d7                     	movl	%r10d, %r15d
    4eef: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4ef3: 45 31 f7                     	xorl	%r14d, %r15d
    4ef6: 41 89 c6                     	movl	%eax, %r14d
    4ef9: 41 09 f6                     	orl	%esi, %r14d
    4efc: 45 21 d6                     	andl	%r10d, %r14d
    4eff: 41 89 c0                     	movl	%eax, %r8d
    4f02: 41 21 f0                     	andl	%esi, %r8d
    4f05: 45 09 f0                     	orl	%r14d, %r8d
    4f08: 45 01 f8                     	addl	%r15d, %r8d
    4f0b: 41 01 d8                     	addl	%ebx, %r8d
    4f0e: 89 d3                        	movl	%edx, %ebx
    4f10: c1 c3 1a                     	roll	$0x1a, %ebx
    4f13: 41 89 d6                     	movl	%edx, %r14d
    4f16: 41 c1 c6 15                  	roll	$0x15, %r14d
    4f1a: 41 31 de                     	xorl	%ebx, %r14d
    4f1d: 89 d3                        	movl	%edx, %ebx
    4f1f: c1 c3 07                     	roll	$0x7, %ebx
    4f22: 44 31 f3                     	xorl	%r14d, %ebx
    4f25: 45 89 de                     	movl	%r11d, %r14d
    4f28: 41 31 ce                     	xorl	%ecx, %r14d
    4f2b: 41 21 d6                     	andl	%edx, %r14d
    4f2e: 44 03 8d 44 ff ff ff         	addl	-0xbc(%rbp), %r9d
    4f35: 41 31 ce                     	xorl	%ecx, %r14d
    4f38: 45 01 f1                     	addl	%r14d, %r9d
    4f3b: 44 01 cb                     	addl	%r9d, %ebx
    4f3e: 81 c3 47 91 a7 d5            	addl	$0xd5a79147, %ebx       # imm = 0xD5A79147
    4f44: 01 de                        	addl	%ebx, %esi
    4f46: 45 89 c1                     	movl	%r8d, %r9d
    4f49: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4f4d: 45 89 c6                     	movl	%r8d, %r14d
    4f50: 41 c1 c6 13                  	roll	$0x13, %r14d
    4f54: 45 31 ce                     	xorl	%r9d, %r14d
    4f57: 45 89 c7                     	movl	%r8d, %r15d
    4f5a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4f5e: 45 31 f7                     	xorl	%r14d, %r15d
    4f61: 45 89 d6                     	movl	%r10d, %r14d
    4f64: 41 09 c6                     	orl	%eax, %r14d
    4f67: 45 21 c6                     	andl	%r8d, %r14d
    4f6a: 45 89 d1                     	movl	%r10d, %r9d
    4f6d: 41 21 c1                     	andl	%eax, %r9d
    4f70: 45 09 f1                     	orl	%r14d, %r9d
    4f73: 41 89 f6                     	movl	%esi, %r14d
    4f76: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4f7a: 45 01 f9                     	addl	%r15d, %r9d
    4f7d: 41 89 f7                     	movl	%esi, %r15d
    4f80: 41 c1 c7 15                  	roll	$0x15, %r15d
    4f84: 41 01 d9                     	addl	%ebx, %r9d
    4f87: 89 f3                        	movl	%esi, %ebx
    4f89: c1 c3 07                     	roll	$0x7, %ebx
    4f8c: 45 31 f7                     	xorl	%r14d, %r15d
    4f8f: 44 31 fb                     	xorl	%r15d, %ebx
    4f92: 41 89 d6                     	movl	%edx, %r14d
    4f95: 45 31 de                     	xorl	%r11d, %r14d
    4f98: 41 21 f6                     	andl	%esi, %r14d
    4f9b: 45 31 de                     	xorl	%r11d, %r14d
    4f9e: 03 8d 48 ff ff ff            	addl	-0xb8(%rbp), %ecx
    4fa4: 44 01 f1                     	addl	%r14d, %ecx
    4fa7: 45 89 ce                     	movl	%r9d, %r14d
    4faa: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4fae: 01 cb                        	addl	%ecx, %ebx
    4fb0: 81 c3 51 63 ca 06            	addl	$0x6ca6351, %ebx        # imm = 0x6CA6351
    4fb6: 44 89 c9                     	movl	%r9d, %ecx
    4fb9: c1 c1 13                     	roll	$0x13, %ecx
    4fbc: 01 d8                        	addl	%ebx, %eax
    4fbe: 45 89 cf                     	movl	%r9d, %r15d
    4fc1: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4fc5: 44 31 f1                     	xorl	%r14d, %ecx
    4fc8: 41 31 cf                     	xorl	%ecx, %r15d
    4fcb: 45 89 c6                     	movl	%r8d, %r14d
    4fce: 45 09 d6                     	orl	%r10d, %r14d
    4fd1: 45 21 ce                     	andl	%r9d, %r14d
    4fd4: 44 89 c1                     	movl	%r8d, %ecx
    4fd7: 44 21 d1                     	andl	%r10d, %ecx
    4fda: 44 09 f1                     	orl	%r14d, %ecx
    4fdd: 44 01 f9                     	addl	%r15d, %ecx
    4fe0: 41 89 c6                     	movl	%eax, %r14d
    4fe3: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4fe7: 01 d9                        	addl	%ebx, %ecx
    4fe9: 89 c3                        	movl	%eax, %ebx
    4feb: c1 c3 15                     	roll	$0x15, %ebx
    4fee: 44 31 f3                     	xorl	%r14d, %ebx
    4ff1: 41 89 c6                     	movl	%eax, %r14d
    4ff4: 41 c1 c6 07                  	roll	$0x7, %r14d
    4ff8: 41 31 de                     	xorl	%ebx, %r14d
    4ffb: 89 f3                        	movl	%esi, %ebx
    4ffd: 31 d3                        	xorl	%edx, %ebx
    4fff: 21 c3                        	andl	%eax, %ebx
    5001: 31 d3                        	xorl	%edx, %ebx
    5003: 44 03 9d 4c ff ff ff         	addl	-0xb4(%rbp), %r11d
    500a: 41 01 db                     	addl	%ebx, %r11d
    500d: 43 8d 1c 1e                  	leal	(%r14,%r11), %ebx
    5011: 81 c3 67 29 29 14            	addl	$0x14292967, %ebx       # imm = 0x14292967
    5017: 41 89 cb                     	movl	%ecx, %r11d
    501a: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    501e: 41 01 da                     	addl	%ebx, %r10d
    5021: 41 89 ce                     	movl	%ecx, %r14d
    5024: 41 c1 c6 13                  	roll	$0x13, %r14d
    5028: 45 31 de                     	xorl	%r11d, %r14d
    502b: 41 89 cf                     	movl	%ecx, %r15d
    502e: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5032: 45 31 f7                     	xorl	%r14d, %r15d
    5035: 45 89 ce                     	movl	%r9d, %r14d
    5038: 45 09 c6                     	orl	%r8d, %r14d
    503b: 41 21 ce                     	andl	%ecx, %r14d
    503e: 45 89 cb                     	movl	%r9d, %r11d
    5041: 45 21 c3                     	andl	%r8d, %r11d
    5044: 45 09 f3                     	orl	%r14d, %r11d
    5047: 45 01 fb                     	addl	%r15d, %r11d
    504a: 41 01 db                     	addl	%ebx, %r11d
    504d: 44 89 d3                     	movl	%r10d, %ebx
    5050: c1 c3 1a                     	roll	$0x1a, %ebx
    5053: 45 89 d6                     	movl	%r10d, %r14d
    5056: 41 c1 c6 15                  	roll	$0x15, %r14d
    505a: 41 31 de                     	xorl	%ebx, %r14d
    505d: 44 89 d3                     	movl	%r10d, %ebx
    5060: c1 c3 07                     	roll	$0x7, %ebx
    5063: 44 31 f3                     	xorl	%r14d, %ebx
    5066: 41 89 c6                     	movl	%eax, %r14d
    5069: 41 31 f6                     	xorl	%esi, %r14d
    506c: 45 21 d6                     	andl	%r10d, %r14d
    506f: 41 31 f6                     	xorl	%esi, %r14d
    5072: 03 95 50 ff ff ff            	addl	-0xb0(%rbp), %edx
    5078: 44 01 f2                     	addl	%r14d, %edx
    507b: 01 d3                        	addl	%edx, %ebx
    507d: 81 c3 85 0a b7 27            	addl	$0x27b70a85, %ebx       # imm = 0x27B70A85
    5083: 41 01 d8                     	addl	%ebx, %r8d
    5086: 44 89 da                     	movl	%r11d, %edx
    5089: c1 c2 1e                     	roll	$0x1e, %edx
    508c: 45 89 de                     	movl	%r11d, %r14d
    508f: 41 c1 c6 13                  	roll	$0x13, %r14d
    5093: 41 31 d6                     	xorl	%edx, %r14d
    5096: 45 89 df                     	movl	%r11d, %r15d
    5099: 41 c1 c7 0a                  	roll	$0xa, %r15d
    509d: 45 31 f7                     	xorl	%r14d, %r15d
    50a0: 41 89 ce                     	movl	%ecx, %r14d
    50a3: 45 09 ce                     	orl	%r9d, %r14d
    50a6: 45 21 de                     	andl	%r11d, %r14d
    50a9: 89 ca                        	movl	%ecx, %edx
    50ab: 44 21 ca                     	andl	%r9d, %edx
    50ae: 44 09 f2                     	orl	%r14d, %edx
    50b1: 44 01 fa                     	addl	%r15d, %edx
    50b4: 01 da                        	addl	%ebx, %edx
    50b6: 44 89 c3                     	movl	%r8d, %ebx
    50b9: c1 c3 1a                     	roll	$0x1a, %ebx
    50bc: 45 89 c6                     	movl	%r8d, %r14d
    50bf: 41 c1 c6 15                  	roll	$0x15, %r14d
    50c3: 41 31 de                     	xorl	%ebx, %r14d
    50c6: 44 89 c3                     	movl	%r8d, %ebx
    50c9: c1 c3 07                     	roll	$0x7, %ebx
    50cc: 44 31 f3                     	xorl	%r14d, %ebx
    50cf: 45 89 d6                     	movl	%r10d, %r14d
    50d2: 41 31 c6                     	xorl	%eax, %r14d
    50d5: 45 21 c6                     	andl	%r8d, %r14d
    50d8: 03 b5 54 ff ff ff            	addl	-0xac(%rbp), %esi
    50de: 41 31 c6                     	xorl	%eax, %r14d
    50e1: 44 01 f6                     	addl	%r14d, %esi
    50e4: 01 f3                        	addl	%esi, %ebx
    50e6: 81 c3 38 21 1b 2e            	addl	$0x2e1b2138, %ebx       # imm = 0x2E1B2138
    50ec: 41 01 d9                     	addl	%ebx, %r9d
    50ef: 89 d6                        	movl	%edx, %esi
    50f1: c1 c6 1e                     	roll	$0x1e, %esi
    50f4: 41 89 d6                     	movl	%edx, %r14d
    50f7: 41 c1 c6 13                  	roll	$0x13, %r14d
    50fb: 41 31 f6                     	xorl	%esi, %r14d
    50fe: 41 89 d7                     	movl	%edx, %r15d
    5101: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5105: 45 31 f7                     	xorl	%r14d, %r15d
    5108: 45 89 de                     	movl	%r11d, %r14d
    510b: 41 09 ce                     	orl	%ecx, %r14d
    510e: 41 21 d6                     	andl	%edx, %r14d
    5111: 44 89 de                     	movl	%r11d, %esi
    5114: 21 ce                        	andl	%ecx, %esi
    5116: 44 09 f6                     	orl	%r14d, %esi
    5119: 45 89 ce                     	movl	%r9d, %r14d
    511c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5120: 44 01 fe                     	addl	%r15d, %esi
    5123: 45 89 cf                     	movl	%r9d, %r15d
    5126: 41 c1 c7 15                  	roll	$0x15, %r15d
    512a: 01 de                        	addl	%ebx, %esi
    512c: 44 89 cb                     	movl	%r9d, %ebx
    512f: c1 c3 07                     	roll	$0x7, %ebx
    5132: 45 31 f7                     	xorl	%r14d, %r15d
    5135: 44 31 fb                     	xorl	%r15d, %ebx
    5138: 45 89 c6                     	movl	%r8d, %r14d
    513b: 45 31 d6                     	xorl	%r10d, %r14d
    513e: 45 21 ce                     	andl	%r9d, %r14d
    5141: 45 31 d6                     	xorl	%r10d, %r14d
    5144: 03 85 58 ff ff ff            	addl	-0xa8(%rbp), %eax
    514a: 44 01 f0                     	addl	%r14d, %eax
    514d: 41 89 f6                     	movl	%esi, %r14d
    5150: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5154: 01 c3                        	addl	%eax, %ebx
    5156: 81 c3 fc 6d 2c 4d            	addl	$0x4d2c6dfc, %ebx       # imm = 0x4D2C6DFC
    515c: 89 f0                        	movl	%esi, %eax
    515e: c1 c0 13                     	roll	$0x13, %eax
    5161: 01 d9                        	addl	%ebx, %ecx
    5163: 41 89 f7                     	movl	%esi, %r15d
    5166: 41 c1 c7 0a                  	roll	$0xa, %r15d
    516a: 44 31 f0                     	xorl	%r14d, %eax
    516d: 41 31 c7                     	xorl	%eax, %r15d
    5170: 41 89 d6                     	movl	%edx, %r14d
    5173: 45 09 de                     	orl	%r11d, %r14d
    5176: 41 21 f6                     	andl	%esi, %r14d
    5179: 89 d0                        	movl	%edx, %eax
    517b: 44 21 d8                     	andl	%r11d, %eax
    517e: 44 09 f0                     	orl	%r14d, %eax
    5181: 44 01 f8                     	addl	%r15d, %eax
    5184: 41 89 ce                     	movl	%ecx, %r14d
    5187: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    518b: 01 d8                        	addl	%ebx, %eax
    518d: 89 cb                        	movl	%ecx, %ebx
    518f: c1 c3 15                     	roll	$0x15, %ebx
    5192: 44 31 f3                     	xorl	%r14d, %ebx
    5195: 41 89 ce                     	movl	%ecx, %r14d
    5198: 41 c1 c6 07                  	roll	$0x7, %r14d
    519c: 41 31 de                     	xorl	%ebx, %r14d
    519f: 44 89 cb                     	movl	%r9d, %ebx
    51a2: 44 31 c3                     	xorl	%r8d, %ebx
    51a5: 21 cb                        	andl	%ecx, %ebx
    51a7: 44 31 c3                     	xorl	%r8d, %ebx
    51aa: 44 03 95 5c ff ff ff         	addl	-0xa4(%rbp), %r10d
    51b1: 41 01 da                     	addl	%ebx, %r10d
    51b4: 43 8d 1c 16                  	leal	(%r14,%r10), %ebx
    51b8: 81 c3 13 0d 38 53            	addl	$0x53380d13, %ebx       # imm = 0x53380D13
    51be: 41 89 c2                     	movl	%eax, %r10d
    51c1: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    51c5: 41 01 db                     	addl	%ebx, %r11d
    51c8: 41 89 c6                     	movl	%eax, %r14d
    51cb: 41 c1 c6 13                  	roll	$0x13, %r14d
    51cf: 45 31 d6                     	xorl	%r10d, %r14d
    51d2: 41 89 c7                     	movl	%eax, %r15d
    51d5: 41 c1 c7 0a                  	roll	$0xa, %r15d
    51d9: 45 31 f7                     	xorl	%r14d, %r15d
    51dc: 41 89 f6                     	movl	%esi, %r14d
    51df: 41 09 d6                     	orl	%edx, %r14d
    51e2: 41 21 c6                     	andl	%eax, %r14d
    51e5: 41 89 f2                     	movl	%esi, %r10d
    51e8: 41 21 d2                     	andl	%edx, %r10d
    51eb: 45 09 f2                     	orl	%r14d, %r10d
    51ee: 45 01 fa                     	addl	%r15d, %r10d
    51f1: 41 01 da                     	addl	%ebx, %r10d
    51f4: 44 89 db                     	movl	%r11d, %ebx
    51f7: c1 c3 1a                     	roll	$0x1a, %ebx
    51fa: 45 89 de                     	movl	%r11d, %r14d
    51fd: 41 c1 c6 15                  	roll	$0x15, %r14d
    5201: 41 31 de                     	xorl	%ebx, %r14d
    5204: 44 89 db                     	movl	%r11d, %ebx
    5207: c1 c3 07                     	roll	$0x7, %ebx
    520a: 44 31 f3                     	xorl	%r14d, %ebx
    520d: 41 89 ce                     	movl	%ecx, %r14d
    5210: 45 31 ce                     	xorl	%r9d, %r14d
    5213: 45 21 de                     	andl	%r11d, %r14d
    5216: 45 31 ce                     	xorl	%r9d, %r14d
    5219: 44 03 85 60 ff ff ff         	addl	-0xa0(%rbp), %r8d
    5220: 45 01 f0                     	addl	%r14d, %r8d
    5223: 44 01 c3                     	addl	%r8d, %ebx
    5226: 81 c3 54 73 0a 65            	addl	$0x650a7354, %ebx       # imm = 0x650A7354
    522c: 01 da                        	addl	%ebx, %edx
    522e: 45 89 d0                     	movl	%r10d, %r8d
    5231: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5235: 45 89 d6                     	movl	%r10d, %r14d
    5238: 41 c1 c6 13                  	roll	$0x13, %r14d
    523c: 45 31 c6                     	xorl	%r8d, %r14d
    523f: 45 89 d7                     	movl	%r10d, %r15d
    5242: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5246: 45 31 f7                     	xorl	%r14d, %r15d
    5249: 41 89 c6                     	movl	%eax, %r14d
    524c: 41 09 f6                     	orl	%esi, %r14d
    524f: 45 21 d6                     	andl	%r10d, %r14d
    5252: 41 89 c0                     	movl	%eax, %r8d
    5255: 41 21 f0                     	andl	%esi, %r8d
    5258: 45 09 f0                     	orl	%r14d, %r8d
    525b: 45 01 f8                     	addl	%r15d, %r8d
    525e: 41 01 d8                     	addl	%ebx, %r8d
    5261: 89 d3                        	movl	%edx, %ebx
    5263: c1 c3 1a                     	roll	$0x1a, %ebx
    5266: 41 89 d6                     	movl	%edx, %r14d
    5269: 41 c1 c6 15                  	roll	$0x15, %r14d
    526d: 41 31 de                     	xorl	%ebx, %r14d
    5270: 89 d3                        	movl	%edx, %ebx
    5272: c1 c3 07                     	roll	$0x7, %ebx
    5275: 44 31 f3                     	xorl	%r14d, %ebx
    5278: 45 89 de                     	movl	%r11d, %r14d
    527b: 41 31 ce                     	xorl	%ecx, %r14d
    527e: 41 21 d6                     	andl	%edx, %r14d
    5281: 44 03 8d 64 ff ff ff         	addl	-0x9c(%rbp), %r9d
    5288: 41 31 ce                     	xorl	%ecx, %r14d
    528b: 45 01 f1                     	addl	%r14d, %r9d
    528e: 44 01 cb                     	addl	%r9d, %ebx
    5291: 81 c3 bb 0a 6a 76            	addl	$0x766a0abb, %ebx       # imm = 0x766A0ABB
    5297: 01 de                        	addl	%ebx, %esi
    5299: 45 89 c1                     	movl	%r8d, %r9d
    529c: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    52a0: 45 89 c6                     	movl	%r8d, %r14d
    52a3: 41 c1 c6 13                  	roll	$0x13, %r14d
    52a7: 45 31 ce                     	xorl	%r9d, %r14d
    52aa: 45 89 c7                     	movl	%r8d, %r15d
    52ad: 41 c1 c7 0a                  	roll	$0xa, %r15d
    52b1: 45 31 f7                     	xorl	%r14d, %r15d
    52b4: 45 89 d6                     	movl	%r10d, %r14d
    52b7: 41 09 c6                     	orl	%eax, %r14d
    52ba: 45 21 c6                     	andl	%r8d, %r14d
    52bd: 45 89 d1                     	movl	%r10d, %r9d
    52c0: 41 21 c1                     	andl	%eax, %r9d
    52c3: 45 09 f1                     	orl	%r14d, %r9d
    52c6: 41 89 f6                     	movl	%esi, %r14d
    52c9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    52cd: 45 01 f9                     	addl	%r15d, %r9d
    52d0: 41 89 f7                     	movl	%esi, %r15d
    52d3: 41 c1 c7 15                  	roll	$0x15, %r15d
    52d7: 41 01 d9                     	addl	%ebx, %r9d
    52da: 89 f3                        	movl	%esi, %ebx
    52dc: c1 c3 07                     	roll	$0x7, %ebx
    52df: 45 31 f7                     	xorl	%r14d, %r15d
    52e2: 44 31 fb                     	xorl	%r15d, %ebx
    52e5: 41 89 d6                     	movl	%edx, %r14d
    52e8: 45 31 de                     	xorl	%r11d, %r14d
    52eb: 41 21 f6                     	andl	%esi, %r14d
    52ee: 45 31 de                     	xorl	%r11d, %r14d
    52f1: 03 8d 68 ff ff ff            	addl	-0x98(%rbp), %ecx
    52f7: 44 01 f1                     	addl	%r14d, %ecx
    52fa: 45 89 ce                     	movl	%r9d, %r14d
    52fd: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5301: 01 cb                        	addl	%ecx, %ebx
    5303: 81 c3 2e c9 c2 81            	addl	$0x81c2c92e, %ebx       # imm = 0x81C2C92E
    5309: 44 89 c9                     	movl	%r9d, %ecx
    530c: c1 c1 13                     	roll	$0x13, %ecx
    530f: 01 d8                        	addl	%ebx, %eax
    5311: 45 89 cf                     	movl	%r9d, %r15d
    5314: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5318: 44 31 f1                     	xorl	%r14d, %ecx
    531b: 41 31 cf                     	xorl	%ecx, %r15d
    531e: 45 89 c6                     	movl	%r8d, %r14d
    5321: 45 09 d6                     	orl	%r10d, %r14d
    5324: 45 21 ce                     	andl	%r9d, %r14d
    5327: 44 89 c1                     	movl	%r8d, %ecx
    532a: 44 21 d1                     	andl	%r10d, %ecx
    532d: 44 09 f1                     	orl	%r14d, %ecx
    5330: 44 01 f9                     	addl	%r15d, %ecx
    5333: 41 89 c6                     	movl	%eax, %r14d
    5336: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    533a: 01 d9                        	addl	%ebx, %ecx
    533c: 89 c3                        	movl	%eax, %ebx
    533e: c1 c3 15                     	roll	$0x15, %ebx
    5341: 44 31 f3                     	xorl	%r14d, %ebx
    5344: 41 89 c6                     	movl	%eax, %r14d
    5347: 41 c1 c6 07                  	roll	$0x7, %r14d
    534b: 41 31 de                     	xorl	%ebx, %r14d
    534e: 89 f3                        	movl	%esi, %ebx
    5350: 31 d3                        	xorl	%edx, %ebx
    5352: 21 c3                        	andl	%eax, %ebx
    5354: 31 d3                        	xorl	%edx, %ebx
    5356: 44 03 9d 6c ff ff ff         	addl	-0x94(%rbp), %r11d
    535d: 41 01 db                     	addl	%ebx, %r11d
    5360: 43 8d 1c 1e                  	leal	(%r14,%r11), %ebx
    5364: 81 c3 85 2c 72 92            	addl	$0x92722c85, %ebx       # imm = 0x92722C85
    536a: 41 89 cb                     	movl	%ecx, %r11d
    536d: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    5371: 41 01 da                     	addl	%ebx, %r10d
    5374: 41 89 ce                     	movl	%ecx, %r14d
    5377: 41 c1 c6 13                  	roll	$0x13, %r14d
    537b: 45 31 de                     	xorl	%r11d, %r14d
    537e: 41 89 cf                     	movl	%ecx, %r15d
    5381: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5385: 45 31 f7                     	xorl	%r14d, %r15d
    5388: 45 89 ce                     	movl	%r9d, %r14d
    538b: 45 09 c6                     	orl	%r8d, %r14d
    538e: 41 21 ce                     	andl	%ecx, %r14d
    5391: 45 89 cb                     	movl	%r9d, %r11d
    5394: 45 21 c3                     	andl	%r8d, %r11d
    5397: 45 09 f3                     	orl	%r14d, %r11d
    539a: 45 01 fb                     	addl	%r15d, %r11d
    539d: 41 01 db                     	addl	%ebx, %r11d
    53a0: 44 89 d3                     	movl	%r10d, %ebx
    53a3: c1 c3 1a                     	roll	$0x1a, %ebx
    53a6: 45 89 d6                     	movl	%r10d, %r14d
    53a9: 41 c1 c6 15                  	roll	$0x15, %r14d
    53ad: 41 31 de                     	xorl	%ebx, %r14d
    53b0: 44 89 d3                     	movl	%r10d, %ebx
    53b3: c1 c3 07                     	roll	$0x7, %ebx
    53b6: 44 31 f3                     	xorl	%r14d, %ebx
    53b9: 41 89 c6                     	movl	%eax, %r14d
    53bc: 41 31 f6                     	xorl	%esi, %r14d
    53bf: 45 21 d6                     	andl	%r10d, %r14d
    53c2: 41 31 f6                     	xorl	%esi, %r14d
    53c5: 03 95 70 ff ff ff            	addl	-0x90(%rbp), %edx
    53cb: 44 01 f2                     	addl	%r14d, %edx
    53ce: 01 d3                        	addl	%edx, %ebx
    53d0: 81 c3 a1 e8 bf a2            	addl	$0xa2bfe8a1, %ebx       # imm = 0xA2BFE8A1
    53d6: 41 01 d8                     	addl	%ebx, %r8d
    53d9: 44 89 da                     	movl	%r11d, %edx
    53dc: c1 c2 1e                     	roll	$0x1e, %edx
    53df: 45 89 de                     	movl	%r11d, %r14d
    53e2: 41 c1 c6 13                  	roll	$0x13, %r14d
    53e6: 41 31 d6                     	xorl	%edx, %r14d
    53e9: 45 89 df                     	movl	%r11d, %r15d
    53ec: 41 c1 c7 0a                  	roll	$0xa, %r15d
    53f0: 45 31 f7                     	xorl	%r14d, %r15d
    53f3: 41 89 ce                     	movl	%ecx, %r14d
    53f6: 45 09 ce                     	orl	%r9d, %r14d
    53f9: 45 21 de                     	andl	%r11d, %r14d
    53fc: 89 ca                        	movl	%ecx, %edx
    53fe: 44 21 ca                     	andl	%r9d, %edx
    5401: 44 09 f2                     	orl	%r14d, %edx
    5404: 44 01 fa                     	addl	%r15d, %edx
    5407: 01 da                        	addl	%ebx, %edx
    5409: 44 89 c3                     	movl	%r8d, %ebx
    540c: c1 c3 1a                     	roll	$0x1a, %ebx
    540f: 45 89 c6                     	movl	%r8d, %r14d
    5412: 41 c1 c6 15                  	roll	$0x15, %r14d
    5416: 41 31 de                     	xorl	%ebx, %r14d
    5419: 44 89 c3                     	movl	%r8d, %ebx
    541c: c1 c3 07                     	roll	$0x7, %ebx
    541f: 44 31 f3                     	xorl	%r14d, %ebx
    5422: 45 89 d6                     	movl	%r10d, %r14d
    5425: 41 31 c6                     	xorl	%eax, %r14d
    5428: 45 21 c6                     	andl	%r8d, %r14d
    542b: 03 b5 74 ff ff ff            	addl	-0x8c(%rbp), %esi
    5431: 41 31 c6                     	xorl	%eax, %r14d
    5434: 44 01 f6                     	addl	%r14d, %esi
    5437: 01 f3                        	addl	%esi, %ebx
    5439: 81 c3 4b 66 1a a8            	addl	$0xa81a664b, %ebx       # imm = 0xA81A664B
    543f: 41 01 d9                     	addl	%ebx, %r9d
    5442: 89 d6                        	movl	%edx, %esi
    5444: c1 c6 1e                     	roll	$0x1e, %esi
    5447: 41 89 d6                     	movl	%edx, %r14d
    544a: 41 c1 c6 13                  	roll	$0x13, %r14d
    544e: 41 31 f6                     	xorl	%esi, %r14d
    5451: 41 89 d7                     	movl	%edx, %r15d
    5454: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5458: 45 31 f7                     	xorl	%r14d, %r15d
    545b: 45 89 de                     	movl	%r11d, %r14d
    545e: 41 09 ce                     	orl	%ecx, %r14d
    5461: 41 21 d6                     	andl	%edx, %r14d
    5464: 44 89 de                     	movl	%r11d, %esi
    5467: 21 ce                        	andl	%ecx, %esi
    5469: 44 09 f6                     	orl	%r14d, %esi
    546c: 45 89 ce                     	movl	%r9d, %r14d
    546f: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5473: 44 01 fe                     	addl	%r15d, %esi
    5476: 45 89 cf                     	movl	%r9d, %r15d
    5479: 41 c1 c7 15                  	roll	$0x15, %r15d
    547d: 01 de                        	addl	%ebx, %esi
    547f: 44 89 cb                     	movl	%r9d, %ebx
    5482: c1 c3 07                     	roll	$0x7, %ebx
    5485: 45 31 f7                     	xorl	%r14d, %r15d
    5488: 44 31 fb                     	xorl	%r15d, %ebx
    548b: 45 89 c6                     	movl	%r8d, %r14d
    548e: 45 31 d6                     	xorl	%r10d, %r14d
    5491: 45 21 ce                     	andl	%r9d, %r14d
    5494: 45 31 d6                     	xorl	%r10d, %r14d
    5497: 03 85 78 ff ff ff            	addl	-0x88(%rbp), %eax
    549d: 44 01 f0                     	addl	%r14d, %eax
    54a0: 41 89 f6                     	movl	%esi, %r14d
    54a3: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    54a7: 01 c3                        	addl	%eax, %ebx
    54a9: 81 c3 70 8b 4b c2            	addl	$0xc24b8b70, %ebx       # imm = 0xC24B8B70
    54af: 89 f0                        	movl	%esi, %eax
    54b1: c1 c0 13                     	roll	$0x13, %eax
    54b4: 01 d9                        	addl	%ebx, %ecx
    54b6: 41 89 f7                     	movl	%esi, %r15d
    54b9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    54bd: 44 31 f0                     	xorl	%r14d, %eax
    54c0: 41 31 c7                     	xorl	%eax, %r15d
    54c3: 41 89 d6                     	movl	%edx, %r14d
    54c6: 45 09 de                     	orl	%r11d, %r14d
    54c9: 41 21 f6                     	andl	%esi, %r14d
    54cc: 89 d0                        	movl	%edx, %eax
    54ce: 44 21 d8                     	andl	%r11d, %eax
    54d1: 44 09 f0                     	orl	%r14d, %eax
    54d4: 44 01 f8                     	addl	%r15d, %eax
    54d7: 41 89 ce                     	movl	%ecx, %r14d
    54da: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    54de: 01 d8                        	addl	%ebx, %eax
    54e0: 89 cb                        	movl	%ecx, %ebx
    54e2: c1 c3 15                     	roll	$0x15, %ebx
    54e5: 44 31 f3                     	xorl	%r14d, %ebx
    54e8: 41 89 ce                     	movl	%ecx, %r14d
    54eb: 41 c1 c6 07                  	roll	$0x7, %r14d
    54ef: 41 31 de                     	xorl	%ebx, %r14d
    54f2: 44 89 cb                     	movl	%r9d, %ebx
    54f5: 44 31 c3                     	xorl	%r8d, %ebx
    54f8: 21 cb                        	andl	%ecx, %ebx
    54fa: 44 31 c3                     	xorl	%r8d, %ebx
    54fd: 44 03 95 7c ff ff ff         	addl	-0x84(%rbp), %r10d
    5504: 41 01 da                     	addl	%ebx, %r10d
    5507: 45 01 f2                     	addl	%r14d, %r10d
    550a: 41 81 c2 a3 51 6c c7         	addl	$0xc76c51a3, %r10d      # imm = 0xC76C51A3
    5511: 89 c3                        	movl	%eax, %ebx
    5513: c1 c3 1e                     	roll	$0x1e, %ebx
    5516: 45 01 d3                     	addl	%r10d, %r11d
    5519: 41 89 c6                     	movl	%eax, %r14d
    551c: 41 c1 c6 13                  	roll	$0x13, %r14d
    5520: 41 31 de                     	xorl	%ebx, %r14d
    5523: 41 89 c7                     	movl	%eax, %r15d
    5526: 41 c1 c7 0a                  	roll	$0xa, %r15d
    552a: 45 31 f7                     	xorl	%r14d, %r15d
    552d: 41 89 f6                     	movl	%esi, %r14d
    5530: 41 09 d6                     	orl	%edx, %r14d
    5533: 41 21 c6                     	andl	%eax, %r14d
    5536: 89 f3                        	movl	%esi, %ebx
    5538: 21 d3                        	andl	%edx, %ebx
    553a: 44 09 f3                     	orl	%r14d, %ebx
    553d: 44 01 fb                     	addl	%r15d, %ebx
    5540: 44 01 d3                     	addl	%r10d, %ebx
    5543: 45 89 da                     	movl	%r11d, %r10d
    5546: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    554a: 45 89 de                     	movl	%r11d, %r14d
    554d: 41 c1 c6 15                  	roll	$0x15, %r14d
    5551: 45 31 d6                     	xorl	%r10d, %r14d
    5554: 45 89 da                     	movl	%r11d, %r10d
    5557: 41 c1 c2 07                  	roll	$0x7, %r10d
    555b: 45 31 f2                     	xorl	%r14d, %r10d
    555e: 41 89 ce                     	movl	%ecx, %r14d
    5561: 45 31 ce                     	xorl	%r9d, %r14d
    5564: 45 21 de                     	andl	%r11d, %r14d
    5567: 45 31 ce                     	xorl	%r9d, %r14d
    556a: 44 03 45 80                  	addl	-0x80(%rbp), %r8d
    556e: 45 01 f0                     	addl	%r14d, %r8d
    5571: 45 01 c2                     	addl	%r8d, %r10d
    5574: 41 81 c2 19 e8 92 d1         	addl	$0xd192e819, %r10d      # imm = 0xD192E819
    557b: 44 01 d2                     	addl	%r10d, %edx
    557e: 41 89 d8                     	movl	%ebx, %r8d
    5581: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5585: 41 89 de                     	movl	%ebx, %r14d
    5588: 41 c1 c6 13                  	roll	$0x13, %r14d
    558c: 45 31 c6                     	xorl	%r8d, %r14d
    558f: 41 89 df                     	movl	%ebx, %r15d
    5592: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5596: 45 31 f7                     	xorl	%r14d, %r15d
    5599: 41 89 c6                     	movl	%eax, %r14d
    559c: 41 09 f6                     	orl	%esi, %r14d
    559f: 41 21 de                     	andl	%ebx, %r14d
    55a2: 41 89 c0                     	movl	%eax, %r8d
    55a5: 41 21 f0                     	andl	%esi, %r8d
    55a8: 45 09 f0                     	orl	%r14d, %r8d
    55ab: 45 01 f8                     	addl	%r15d, %r8d
    55ae: 45 01 d0                     	addl	%r10d, %r8d
    55b1: 41 89 d2                     	movl	%edx, %r10d
    55b4: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    55b8: 41 89 d6                     	movl	%edx, %r14d
    55bb: 41 c1 c6 15                  	roll	$0x15, %r14d
    55bf: 45 31 d6                     	xorl	%r10d, %r14d
    55c2: 41 89 d2                     	movl	%edx, %r10d
    55c5: 41 c1 c2 07                  	roll	$0x7, %r10d
    55c9: 45 31 f2                     	xorl	%r14d, %r10d
    55cc: 45 89 de                     	movl	%r11d, %r14d
    55cf: 41 31 ce                     	xorl	%ecx, %r14d
    55d2: 41 21 d6                     	andl	%edx, %r14d
    55d5: 44 03 4d 84                  	addl	-0x7c(%rbp), %r9d
    55d9: 41 31 ce                     	xorl	%ecx, %r14d
    55dc: 45 01 f1                     	addl	%r14d, %r9d
    55df: 45 01 ca                     	addl	%r9d, %r10d
    55e2: 41 81 c2 24 06 99 d6         	addl	$0xd6990624, %r10d      # imm = 0xD6990624
    55e9: 44 01 d6                     	addl	%r10d, %esi
    55ec: 45 89 c1                     	movl	%r8d, %r9d
    55ef: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    55f3: 45 89 c6                     	movl	%r8d, %r14d
    55f6: 41 c1 c6 13                  	roll	$0x13, %r14d
    55fa: 45 31 ce                     	xorl	%r9d, %r14d
    55fd: 45 89 c7                     	movl	%r8d, %r15d
    5600: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5604: 45 31 f7                     	xorl	%r14d, %r15d
    5607: 41 89 de                     	movl	%ebx, %r14d
    560a: 41 09 c6                     	orl	%eax, %r14d
    560d: 45 21 c6                     	andl	%r8d, %r14d
    5610: 41 89 d9                     	movl	%ebx, %r9d
    5613: 41 21 c1                     	andl	%eax, %r9d
    5616: 45 09 f1                     	orl	%r14d, %r9d
    5619: 41 89 f6                     	movl	%esi, %r14d
    561c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5620: 45 01 f9                     	addl	%r15d, %r9d
    5623: 41 89 f7                     	movl	%esi, %r15d
    5626: 41 c1 c7 15                  	roll	$0x15, %r15d
    562a: 45 01 d1                     	addl	%r10d, %r9d
    562d: 41 89 f2                     	movl	%esi, %r10d
    5630: 41 c1 c2 07                  	roll	$0x7, %r10d
    5634: 45 31 f7                     	xorl	%r14d, %r15d
    5637: 45 31 fa                     	xorl	%r15d, %r10d
    563a: 41 89 d6                     	movl	%edx, %r14d
    563d: 45 31 de                     	xorl	%r11d, %r14d
    5640: 41 21 f6                     	andl	%esi, %r14d
    5643: 45 31 de                     	xorl	%r11d, %r14d
    5646: 03 4d 88                     	addl	-0x78(%rbp), %ecx
    5649: 44 01 f1                     	addl	%r14d, %ecx
    564c: 45 89 ce                     	movl	%r9d, %r14d
    564f: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5653: 41 01 ca                     	addl	%ecx, %r10d
    5656: 41 81 c2 85 35 0e f4         	addl	$0xf40e3585, %r10d      # imm = 0xF40E3585
    565d: 44 89 c9                     	movl	%r9d, %ecx
    5660: c1 c1 13                     	roll	$0x13, %ecx
    5663: 44 01 d0                     	addl	%r10d, %eax
    5666: 45 89 cf                     	movl	%r9d, %r15d
    5669: 41 c1 c7 0a                  	roll	$0xa, %r15d
    566d: 44 31 f1                     	xorl	%r14d, %ecx
    5670: 41 31 cf                     	xorl	%ecx, %r15d
    5673: 45 89 c6                     	movl	%r8d, %r14d
    5676: 41 09 de                     	orl	%ebx, %r14d
    5679: 45 21 ce                     	andl	%r9d, %r14d
    567c: 44 89 c1                     	movl	%r8d, %ecx
    567f: 21 d9                        	andl	%ebx, %ecx
    5681: 44 09 f1                     	orl	%r14d, %ecx
    5684: 44 01 f9                     	addl	%r15d, %ecx
    5687: 41 89 c6                     	movl	%eax, %r14d
    568a: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    568e: 44 01 d1                     	addl	%r10d, %ecx
    5691: 41 89 c2                     	movl	%eax, %r10d
    5694: 41 c1 c2 15                  	roll	$0x15, %r10d
    5698: 45 31 f2                     	xorl	%r14d, %r10d
    569b: 41 89 c6                     	movl	%eax, %r14d
    569e: 41 c1 c6 07                  	roll	$0x7, %r14d
    56a2: 45 31 d6                     	xorl	%r10d, %r14d
    56a5: 41 89 f2                     	movl	%esi, %r10d
    56a8: 41 31 d2                     	xorl	%edx, %r10d
    56ab: 41 21 c2                     	andl	%eax, %r10d
    56ae: 41 31 d2                     	xorl	%edx, %r10d
    56b1: 44 03 5d 8c                  	addl	-0x74(%rbp), %r11d
    56b5: 45 01 d3                     	addl	%r10d, %r11d
    56b8: 47 8d 14 1e                  	leal	(%r14,%r11), %r10d
    56bc: 41 81 c2 70 a0 6a 10         	addl	$0x106aa070, %r10d      # imm = 0x106AA070
    56c3: 41 89 cb                     	movl	%ecx, %r11d
    56c6: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    56ca: 44 01 d3                     	addl	%r10d, %ebx
    56cd: 41 89 ce                     	movl	%ecx, %r14d
    56d0: 41 c1 c6 13                  	roll	$0x13, %r14d
    56d4: 45 31 de                     	xorl	%r11d, %r14d
    56d7: 41 89 cf                     	movl	%ecx, %r15d
    56da: 41 c1 c7 0a                  	roll	$0xa, %r15d
    56de: 45 31 f7                     	xorl	%r14d, %r15d
    56e1: 45 89 ce                     	movl	%r9d, %r14d
    56e4: 45 09 c6                     	orl	%r8d, %r14d
    56e7: 41 21 ce                     	andl	%ecx, %r14d
    56ea: 45 89 cb                     	movl	%r9d, %r11d
    56ed: 45 21 c3                     	andl	%r8d, %r11d
    56f0: 45 09 f3                     	orl	%r14d, %r11d
    56f3: 45 01 fb                     	addl	%r15d, %r11d
    56f6: 45 01 d3                     	addl	%r10d, %r11d
    56f9: 41 89 da                     	movl	%ebx, %r10d
    56fc: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    5700: 41 89 de                     	movl	%ebx, %r14d
    5703: 41 c1 c6 15                  	roll	$0x15, %r14d
    5707: 45 31 d6                     	xorl	%r10d, %r14d
    570a: 41 89 da                     	movl	%ebx, %r10d
    570d: 41 c1 c2 07                  	roll	$0x7, %r10d
    5711: 45 31 f2                     	xorl	%r14d, %r10d
    5714: 41 89 c6                     	movl	%eax, %r14d
    5717: 41 31 f6                     	xorl	%esi, %r14d
    571a: 41 21 de                     	andl	%ebx, %r14d
    571d: 41 31 f6                     	xorl	%esi, %r14d
    5720: 03 55 90                     	addl	-0x70(%rbp), %edx
    5723: 44 01 f2                     	addl	%r14d, %edx
    5726: 44 01 d2                     	addl	%r10d, %edx
    5729: 81 c2 16 c1 a4 19            	addl	$0x19a4c116, %edx       # imm = 0x19A4C116
    572f: 41 01 d0                     	addl	%edx, %r8d
    5732: 45 89 da                     	movl	%r11d, %r10d
    5735: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5739: 45 89 de                     	movl	%r11d, %r14d
    573c: 41 c1 c6 13                  	roll	$0x13, %r14d
    5740: 45 31 d6                     	xorl	%r10d, %r14d
    5743: 45 89 df                     	movl	%r11d, %r15d
    5746: 41 c1 c7 0a                  	roll	$0xa, %r15d
    574a: 45 31 f7                     	xorl	%r14d, %r15d
    574d: 41 89 ce                     	movl	%ecx, %r14d
    5750: 45 09 ce                     	orl	%r9d, %r14d
    5753: 45 21 de                     	andl	%r11d, %r14d
    5756: 41 89 ca                     	movl	%ecx, %r10d
    5759: 45 21 ca                     	andl	%r9d, %r10d
    575c: 45 09 f2                     	orl	%r14d, %r10d
    575f: 45 01 fa                     	addl	%r15d, %r10d
    5762: 41 01 d2                     	addl	%edx, %r10d
    5765: 44 89 c2                     	movl	%r8d, %edx
    5768: c1 c2 1a                     	roll	$0x1a, %edx
    576b: 45 89 c6                     	movl	%r8d, %r14d
    576e: 41 c1 c6 15                  	roll	$0x15, %r14d
    5772: 41 31 d6                     	xorl	%edx, %r14d
    5775: 44 89 c2                     	movl	%r8d, %edx
    5778: c1 c2 07                     	roll	$0x7, %edx
    577b: 44 31 f2                     	xorl	%r14d, %edx
    577e: 41 89 de                     	movl	%ebx, %r14d
    5781: 41 31 c6                     	xorl	%eax, %r14d
    5784: 45 21 c6                     	andl	%r8d, %r14d
    5787: 03 75 94                     	addl	-0x6c(%rbp), %esi
    578a: 41 31 c6                     	xorl	%eax, %r14d
    578d: 44 01 f6                     	addl	%r14d, %esi
    5790: 01 f2                        	addl	%esi, %edx
    5792: 81 c2 08 6c 37 1e            	addl	$0x1e376c08, %edx       # imm = 0x1E376C08
    5798: 41 01 d1                     	addl	%edx, %r9d
    579b: 44 89 d6                     	movl	%r10d, %esi
    579e: c1 c6 1e                     	roll	$0x1e, %esi
    57a1: 45 89 d6                     	movl	%r10d, %r14d
    57a4: 41 c1 c6 13                  	roll	$0x13, %r14d
    57a8: 41 31 f6                     	xorl	%esi, %r14d
    57ab: 45 89 d7                     	movl	%r10d, %r15d
    57ae: 41 c1 c7 0a                  	roll	$0xa, %r15d
    57b2: 45 31 f7                     	xorl	%r14d, %r15d
    57b5: 45 89 de                     	movl	%r11d, %r14d
    57b8: 41 09 ce                     	orl	%ecx, %r14d
    57bb: 45 21 d6                     	andl	%r10d, %r14d
    57be: 44 89 de                     	movl	%r11d, %esi
    57c1: 21 ce                        	andl	%ecx, %esi
    57c3: 44 09 f6                     	orl	%r14d, %esi
    57c6: 45 89 ce                     	movl	%r9d, %r14d
    57c9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    57cd: 44 01 fe                     	addl	%r15d, %esi
    57d0: 45 89 cf                     	movl	%r9d, %r15d
    57d3: 41 c1 c7 15                  	roll	$0x15, %r15d
    57d7: 01 d6                        	addl	%edx, %esi
    57d9: 44 89 ca                     	movl	%r9d, %edx
    57dc: c1 c2 07                     	roll	$0x7, %edx
    57df: 45 31 f7                     	xorl	%r14d, %r15d
    57e2: 44 31 fa                     	xorl	%r15d, %edx
    57e5: 45 89 c6                     	movl	%r8d, %r14d
    57e8: 41 31 de                     	xorl	%ebx, %r14d
    57eb: 45 21 ce                     	andl	%r9d, %r14d
    57ee: 41 31 de                     	xorl	%ebx, %r14d
    57f1: 03 45 98                     	addl	-0x68(%rbp), %eax
    57f4: 44 01 f0                     	addl	%r14d, %eax
    57f7: 41 89 f6                     	movl	%esi, %r14d
    57fa: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    57fe: 01 d0                        	addl	%edx, %eax
    5800: 05 4c 77 48 27               	addl	$0x2748774c, %eax       # imm = 0x2748774C
    5805: 89 f2                        	movl	%esi, %edx
    5807: c1 c2 13                     	roll	$0x13, %edx
    580a: 01 c1                        	addl	%eax, %ecx
    580c: 41 89 f7                     	movl	%esi, %r15d
    580f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5813: 44 31 f2                     	xorl	%r14d, %edx
    5816: 41 31 d7                     	xorl	%edx, %r15d
    5819: 45 89 d6                     	movl	%r10d, %r14d
    581c: 45 09 de                     	orl	%r11d, %r14d
    581f: 41 21 f6                     	andl	%esi, %r14d
    5822: 44 89 d2                     	movl	%r10d, %edx
    5825: 44 21 da                     	andl	%r11d, %edx
    5828: 44 09 f2                     	orl	%r14d, %edx
    582b: 44 01 fa                     	addl	%r15d, %edx
    582e: 41 89 ce                     	movl	%ecx, %r14d
    5831: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5835: 01 c2                        	addl	%eax, %edx
    5837: 89 c8                        	movl	%ecx, %eax
    5839: c1 c0 15                     	roll	$0x15, %eax
    583c: 44 31 f0                     	xorl	%r14d, %eax
    583f: 41 89 ce                     	movl	%ecx, %r14d
    5842: 41 c1 c6 07                  	roll	$0x7, %r14d
    5846: 41 31 c6                     	xorl	%eax, %r14d
    5849: 44 89 c8                     	movl	%r9d, %eax
    584c: 44 31 c0                     	xorl	%r8d, %eax
    584f: 21 c8                        	andl	%ecx, %eax
    5851: 44 31 c0                     	xorl	%r8d, %eax
    5854: 03 5d 9c                     	addl	-0x64(%rbp), %ebx
    5857: 01 c3                        	addl	%eax, %ebx
    5859: 41 8d 04 1e                  	leal	(%r14,%rbx), %eax
    585d: 05 b5 bc b0 34               	addl	$0x34b0bcb5, %eax       # imm = 0x34B0BCB5
    5862: 89 d3                        	movl	%edx, %ebx
    5864: c1 c3 1e                     	roll	$0x1e, %ebx
    5867: 41 01 c3                     	addl	%eax, %r11d
    586a: 41 89 d6                     	movl	%edx, %r14d
    586d: 41 c1 c6 13                  	roll	$0x13, %r14d
    5871: 41 31 de                     	xorl	%ebx, %r14d
    5874: 41 89 d7                     	movl	%edx, %r15d
    5877: 41 c1 c7 0a                  	roll	$0xa, %r15d
    587b: 45 31 f7                     	xorl	%r14d, %r15d
    587e: 41 89 f6                     	movl	%esi, %r14d
    5881: 45 09 d6                     	orl	%r10d, %r14d
    5884: 41 21 d6                     	andl	%edx, %r14d
    5887: 89 f3                        	movl	%esi, %ebx
    5889: 44 21 d3                     	andl	%r10d, %ebx
    588c: 44 09 f3                     	orl	%r14d, %ebx
    588f: 44 01 fb                     	addl	%r15d, %ebx
    5892: 01 c3                        	addl	%eax, %ebx
    5894: 44 89 d8                     	movl	%r11d, %eax
    5897: c1 c0 1a                     	roll	$0x1a, %eax
    589a: 45 89 de                     	movl	%r11d, %r14d
    589d: 41 c1 c6 15                  	roll	$0x15, %r14d
    58a1: 41 31 c6                     	xorl	%eax, %r14d
    58a4: 44 89 d8                     	movl	%r11d, %eax
    58a7: c1 c0 07                     	roll	$0x7, %eax
    58aa: 44 31 f0                     	xorl	%r14d, %eax
    58ad: 41 89 ce                     	movl	%ecx, %r14d
    58b0: 45 31 ce                     	xorl	%r9d, %r14d
    58b3: 45 21 de                     	andl	%r11d, %r14d
    58b6: 45 31 ce                     	xorl	%r9d, %r14d
    58b9: 44 03 45 a0                  	addl	-0x60(%rbp), %r8d
    58bd: 45 01 f0                     	addl	%r14d, %r8d
    58c0: 44 01 c0                     	addl	%r8d, %eax
    58c3: 05 b3 0c 1c 39               	addl	$0x391c0cb3, %eax       # imm = 0x391C0CB3
    58c8: 41 01 c2                     	addl	%eax, %r10d
    58cb: 41 89 d8                     	movl	%ebx, %r8d
    58ce: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    58d2: 41 89 de                     	movl	%ebx, %r14d
    58d5: 41 c1 c6 13                  	roll	$0x13, %r14d
    58d9: 45 31 c6                     	xorl	%r8d, %r14d
    58dc: 41 89 df                     	movl	%ebx, %r15d
    58df: 41 c1 c7 0a                  	roll	$0xa, %r15d
    58e3: 45 31 f7                     	xorl	%r14d, %r15d
    58e6: 41 89 d6                     	movl	%edx, %r14d
    58e9: 41 09 f6                     	orl	%esi, %r14d
    58ec: 41 21 de                     	andl	%ebx, %r14d
    58ef: 41 89 d0                     	movl	%edx, %r8d
    58f2: 41 21 f0                     	andl	%esi, %r8d
    58f5: 45 09 f0                     	orl	%r14d, %r8d
    58f8: 45 01 f8                     	addl	%r15d, %r8d
    58fb: 41 01 c0                     	addl	%eax, %r8d
    58fe: 44 89 d0                     	movl	%r10d, %eax
    5901: c1 c0 1a                     	roll	$0x1a, %eax
    5904: 45 89 d6                     	movl	%r10d, %r14d
    5907: 41 c1 c6 15                  	roll	$0x15, %r14d
    590b: 41 31 c6                     	xorl	%eax, %r14d
    590e: 44 89 d0                     	movl	%r10d, %eax
    5911: c1 c0 07                     	roll	$0x7, %eax
    5914: 44 31 f0                     	xorl	%r14d, %eax
    5917: 45 89 de                     	movl	%r11d, %r14d
    591a: 41 31 ce                     	xorl	%ecx, %r14d
    591d: 45 21 d6                     	andl	%r10d, %r14d
    5920: 44 03 4d a4                  	addl	-0x5c(%rbp), %r9d
    5924: 41 31 ce                     	xorl	%ecx, %r14d
    5927: 45 01 f1                     	addl	%r14d, %r9d
    592a: 44 01 c8                     	addl	%r9d, %eax
    592d: 05 4a aa d8 4e               	addl	$0x4ed8aa4a, %eax       # imm = 0x4ED8AA4A
    5932: 01 c6                        	addl	%eax, %esi
    5934: 45 89 c1                     	movl	%r8d, %r9d
    5937: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    593b: 45 89 c6                     	movl	%r8d, %r14d
    593e: 41 c1 c6 13                  	roll	$0x13, %r14d
    5942: 45 31 ce                     	xorl	%r9d, %r14d
    5945: 45 89 c7                     	movl	%r8d, %r15d
    5948: 41 c1 c7 0a                  	roll	$0xa, %r15d
    594c: 45 31 f7                     	xorl	%r14d, %r15d
    594f: 41 89 de                     	movl	%ebx, %r14d
    5952: 41 09 d6                     	orl	%edx, %r14d
    5955: 45 21 c6                     	andl	%r8d, %r14d
    5958: 41 89 d9                     	movl	%ebx, %r9d
    595b: 41 21 d1                     	andl	%edx, %r9d
    595e: 45 09 f1                     	orl	%r14d, %r9d
    5961: 41 89 f6                     	movl	%esi, %r14d
    5964: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5968: 45 01 f9                     	addl	%r15d, %r9d
    596b: 41 89 f7                     	movl	%esi, %r15d
    596e: 41 c1 c7 15                  	roll	$0x15, %r15d
    5972: 41 01 c1                     	addl	%eax, %r9d
    5975: 89 f0                        	movl	%esi, %eax
    5977: c1 c0 07                     	roll	$0x7, %eax
    597a: 45 31 f7                     	xorl	%r14d, %r15d
    597d: 44 31 f8                     	xorl	%r15d, %eax
    5980: 45 89 d6                     	movl	%r10d, %r14d
    5983: 45 31 de                     	xorl	%r11d, %r14d
    5986: 41 21 f6                     	andl	%esi, %r14d
    5989: 45 31 de                     	xorl	%r11d, %r14d
    598c: 03 4d a8                     	addl	-0x58(%rbp), %ecx
    598f: 44 01 f1                     	addl	%r14d, %ecx
    5992: 45 89 ce                     	movl	%r9d, %r14d
    5995: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5999: 01 c8                        	addl	%ecx, %eax
    599b: 05 4f ca 9c 5b               	addl	$0x5b9cca4f, %eax       # imm = 0x5B9CCA4F
    59a0: 44 89 c9                     	movl	%r9d, %ecx
    59a3: c1 c1 13                     	roll	$0x13, %ecx
    59a6: 01 c2                        	addl	%eax, %edx
    59a8: 45 89 cf                     	movl	%r9d, %r15d
    59ab: 41 c1 c7 0a                  	roll	$0xa, %r15d
    59af: 44 31 f1                     	xorl	%r14d, %ecx
    59b2: 41 31 cf                     	xorl	%ecx, %r15d
    59b5: 44 89 c1                     	movl	%r8d, %ecx
    59b8: 09 d9                        	orl	%ebx, %ecx
    59ba: 44 21 c9                     	andl	%r9d, %ecx
    59bd: 45 89 c6                     	movl	%r8d, %r14d
    59c0: 41 21 de                     	andl	%ebx, %r14d
    59c3: 41 09 ce                     	orl	%ecx, %r14d
    59c6: 45 01 fe                     	addl	%r15d, %r14d
    59c9: 89 d1                        	movl	%edx, %ecx
    59cb: c1 c1 1a                     	roll	$0x1a, %ecx
    59ce: 41 01 c6                     	addl	%eax, %r14d
    59d1: 89 d0                        	movl	%edx, %eax
    59d3: c1 c0 15                     	roll	$0x15, %eax
    59d6: 31 c8                        	xorl	%ecx, %eax
    59d8: 89 d1                        	movl	%edx, %ecx
    59da: c1 c1 07                     	roll	$0x7, %ecx
    59dd: 31 c1                        	xorl	%eax, %ecx
    59df: 89 f0                        	movl	%esi, %eax
    59e1: 44 31 d0                     	xorl	%r10d, %eax
    59e4: 21 d0                        	andl	%edx, %eax
    59e6: 44 31 d0                     	xorl	%r10d, %eax
    59e9: 44 03 5d ac                  	addl	-0x54(%rbp), %r11d
    59ed: 41 01 c3                     	addl	%eax, %r11d
    59f0: 42 8d 04 19                  	leal	(%rcx,%r11), %eax
    59f4: 05 f3 6f 2e 68               	addl	$0x682e6ff3, %eax       # imm = 0x682E6FF3
    59f9: 44 89 f1                     	movl	%r14d, %ecx
    59fc: c1 c1 1e                     	roll	$0x1e, %ecx
    59ff: 01 c3                        	addl	%eax, %ebx
    5a01: 45 89 f3                     	movl	%r14d, %r11d
    5a04: 41 c1 c3 13                  	roll	$0x13, %r11d
    5a08: 41 31 cb                     	xorl	%ecx, %r11d
    5a0b: 45 89 f7                     	movl	%r14d, %r15d
    5a0e: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5a12: 45 31 df                     	xorl	%r11d, %r15d
    5a15: 45 89 cb                     	movl	%r9d, %r11d
    5a18: 45 09 c3                     	orl	%r8d, %r11d
    5a1b: 45 21 f3                     	andl	%r14d, %r11d
    5a1e: 44 89 c9                     	movl	%r9d, %ecx
    5a21: 44 21 c1                     	andl	%r8d, %ecx
    5a24: 44 09 d9                     	orl	%r11d, %ecx
    5a27: 44 01 f9                     	addl	%r15d, %ecx
    5a2a: 01 c1                        	addl	%eax, %ecx
    5a2c: 89 d8                        	movl	%ebx, %eax
    5a2e: c1 c0 1a                     	roll	$0x1a, %eax
    5a31: 41 89 db                     	movl	%ebx, %r11d
    5a34: 41 c1 c3 15                  	roll	$0x15, %r11d
    5a38: 41 31 c3                     	xorl	%eax, %r11d
    5a3b: 89 d8                        	movl	%ebx, %eax
    5a3d: c1 c0 07                     	roll	$0x7, %eax
    5a40: 44 31 d8                     	xorl	%r11d, %eax
    5a43: 41 89 d3                     	movl	%edx, %r11d
    5a46: 41 31 f3                     	xorl	%esi, %r11d
    5a49: 41 21 db                     	andl	%ebx, %r11d
    5a4c: 41 31 f3                     	xorl	%esi, %r11d
    5a4f: 44 03 55 b0                  	addl	-0x50(%rbp), %r10d
    5a53: 45 01 da                     	addl	%r11d, %r10d
    5a56: 41 01 c2                     	addl	%eax, %r10d
    5a59: 41 81 c2 ee 82 8f 74         	addl	$0x748f82ee, %r10d      # imm = 0x748F82EE
    5a60: 45 01 d0                     	addl	%r10d, %r8d
    5a63: 89 c8                        	movl	%ecx, %eax
    5a65: c1 c0 1e                     	roll	$0x1e, %eax
    5a68: 41 89 cb                     	movl	%ecx, %r11d
    5a6b: 41 c1 c3 13                  	roll	$0x13, %r11d
    5a6f: 41 31 c3                     	xorl	%eax, %r11d
    5a72: 41 89 cf                     	movl	%ecx, %r15d
    5a75: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5a79: 45 31 df                     	xorl	%r11d, %r15d
    5a7c: 45 89 f3                     	movl	%r14d, %r11d
    5a7f: 45 09 cb                     	orl	%r9d, %r11d
    5a82: 41 21 cb                     	andl	%ecx, %r11d
    5a85: 44 89 f0                     	movl	%r14d, %eax
    5a88: 44 21 c8                     	andl	%r9d, %eax
    5a8b: 44 09 d8                     	orl	%r11d, %eax
    5a8e: 44 01 f8                     	addl	%r15d, %eax
    5a91: 44 01 d0                     	addl	%r10d, %eax
    5a94: 45 89 c2                     	movl	%r8d, %r10d
    5a97: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    5a9b: 45 89 c3                     	movl	%r8d, %r11d
    5a9e: 41 c1 c3 15                  	roll	$0x15, %r11d
    5aa2: 45 31 d3                     	xorl	%r10d, %r11d
    5aa5: 45 89 c2                     	movl	%r8d, %r10d
    5aa8: 41 c1 c2 07                  	roll	$0x7, %r10d
    5aac: 45 31 da                     	xorl	%r11d, %r10d
    5aaf: 41 89 db                     	movl	%ebx, %r11d
    5ab2: 41 31 d3                     	xorl	%edx, %r11d
    5ab5: 45 21 c3                     	andl	%r8d, %r11d
    5ab8: 03 75 b4                     	addl	-0x4c(%rbp), %esi
    5abb: 41 31 d3                     	xorl	%edx, %r11d
    5abe: 44 01 de                     	addl	%r11d, %esi
    5ac1: 41 01 f2                     	addl	%esi, %r10d
    5ac4: 41 81 c2 6f 63 a5 78         	addl	$0x78a5636f, %r10d      # imm = 0x78A5636F
    5acb: 45 01 d1                     	addl	%r10d, %r9d
    5ace: 89 c6                        	movl	%eax, %esi
    5ad0: c1 c6 1e                     	roll	$0x1e, %esi
    5ad3: 41 89 c3                     	movl	%eax, %r11d
    5ad6: 41 c1 c3 13                  	roll	$0x13, %r11d
    5ada: 41 31 f3                     	xorl	%esi, %r11d
    5add: 41 89 c7                     	movl	%eax, %r15d
    5ae0: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5ae4: 45 31 df                     	xorl	%r11d, %r15d
    5ae7: 41 89 cb                     	movl	%ecx, %r11d
    5aea: 45 09 f3                     	orl	%r14d, %r11d
    5aed: 41 21 c3                     	andl	%eax, %r11d
    5af0: 89 ce                        	movl	%ecx, %esi
    5af2: 44 21 f6                     	andl	%r14d, %esi
    5af5: 44 09 de                     	orl	%r11d, %esi
    5af8: 45 89 cb                     	movl	%r9d, %r11d
    5afb: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5aff: 44 01 fe                     	addl	%r15d, %esi
    5b02: 45 89 cf                     	movl	%r9d, %r15d
    5b05: 41 c1 c7 15                  	roll	$0x15, %r15d
    5b09: 44 01 d6                     	addl	%r10d, %esi
    5b0c: 45 89 ca                     	movl	%r9d, %r10d
    5b0f: 41 c1 c2 07                  	roll	$0x7, %r10d
    5b13: 45 31 df                     	xorl	%r11d, %r15d
    5b16: 45 31 fa                     	xorl	%r15d, %r10d
    5b19: 45 89 c3                     	movl	%r8d, %r11d
    5b1c: 41 31 db                     	xorl	%ebx, %r11d
    5b1f: 45 21 cb                     	andl	%r9d, %r11d
    5b22: 41 31 db                     	xorl	%ebx, %r11d
    5b25: 03 55 b8                     	addl	-0x48(%rbp), %edx
    5b28: 44 01 da                     	addl	%r11d, %edx
    5b2b: 41 89 f3                     	movl	%esi, %r11d
    5b2e: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    5b32: 41 01 d2                     	addl	%edx, %r10d
    5b35: 41 81 c2 14 78 c8 84         	addl	$0x84c87814, %r10d      # imm = 0x84C87814
    5b3c: 89 f2                        	movl	%esi, %edx
    5b3e: c1 c2 13                     	roll	$0x13, %edx
    5b41: 45 01 d6                     	addl	%r10d, %r14d
    5b44: 41 89 f7                     	movl	%esi, %r15d
    5b47: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5b4b: 44 31 da                     	xorl	%r11d, %edx
    5b4e: 41 31 d7                     	xorl	%edx, %r15d
    5b51: 41 89 c3                     	movl	%eax, %r11d
    5b54: 41 09 cb                     	orl	%ecx, %r11d
    5b57: 41 21 f3                     	andl	%esi, %r11d
    5b5a: 89 c2                        	movl	%eax, %edx
    5b5c: 21 ca                        	andl	%ecx, %edx
    5b5e: 44 09 da                     	orl	%r11d, %edx
    5b61: 44 01 fa                     	addl	%r15d, %edx
    5b64: 45 89 f3                     	movl	%r14d, %r11d
    5b67: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5b6b: 44 01 d2                     	addl	%r10d, %edx
    5b6e: 45 89 f2                     	movl	%r14d, %r10d
    5b71: 41 c1 c2 15                  	roll	$0x15, %r10d
    5b75: 45 31 da                     	xorl	%r11d, %r10d
    5b78: 45 89 f3                     	movl	%r14d, %r11d
    5b7b: 41 c1 c3 07                  	roll	$0x7, %r11d
    5b7f: 45 31 d3                     	xorl	%r10d, %r11d
    5b82: 45 89 ca                     	movl	%r9d, %r10d
    5b85: 45 31 c2                     	xorl	%r8d, %r10d
    5b88: 45 21 f2                     	andl	%r14d, %r10d
    5b8b: 45 31 c2                     	xorl	%r8d, %r10d
    5b8e: 03 5d bc                     	addl	-0x44(%rbp), %ebx
    5b91: 44 01 d3                     	addl	%r10d, %ebx
    5b94: 41 01 db                     	addl	%ebx, %r11d
    5b97: 41 81 c3 08 02 c7 8c         	addl	$0x8cc70208, %r11d      # imm = 0x8CC70208
    5b9e: 41 89 d2                     	movl	%edx, %r10d
    5ba1: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5ba5: 44 01 d9                     	addl	%r11d, %ecx
    5ba8: 89 d3                        	movl	%edx, %ebx
    5baa: c1 c3 13                     	roll	$0x13, %ebx
    5bad: 44 31 d3                     	xorl	%r10d, %ebx
    5bb0: 41 89 d7                     	movl	%edx, %r15d
    5bb3: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5bb7: 41 31 df                     	xorl	%ebx, %r15d
    5bba: 89 f3                        	movl	%esi, %ebx
    5bbc: 09 c3                        	orl	%eax, %ebx
    5bbe: 21 d3                        	andl	%edx, %ebx
    5bc0: 41 89 f2                     	movl	%esi, %r10d
    5bc3: 41 21 c2                     	andl	%eax, %r10d
    5bc6: 41 09 da                     	orl	%ebx, %r10d
    5bc9: 45 01 fa                     	addl	%r15d, %r10d
    5bcc: 45 01 da                     	addl	%r11d, %r10d
    5bcf: 41 89 cb                     	movl	%ecx, %r11d
    5bd2: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5bd6: 89 cb                        	movl	%ecx, %ebx
    5bd8: c1 c3 15                     	roll	$0x15, %ebx
    5bdb: 44 31 db                     	xorl	%r11d, %ebx
    5bde: 41 89 cb                     	movl	%ecx, %r11d
    5be1: 41 c1 c3 07                  	roll	$0x7, %r11d
    5be5: 41 31 db                     	xorl	%ebx, %r11d
    5be8: 44 89 f3                     	movl	%r14d, %ebx
    5beb: 44 31 cb                     	xorl	%r9d, %ebx
    5bee: 21 cb                        	andl	%ecx, %ebx
    5bf0: 44 31 cb                     	xorl	%r9d, %ebx
    5bf3: 44 03 45 c0                  	addl	-0x40(%rbp), %r8d
    5bf7: 41 01 d8                     	addl	%ebx, %r8d
    5bfa: 45 01 c3                     	addl	%r8d, %r11d
    5bfd: 41 81 c3 fa ff be 90         	addl	$0x90befffa, %r11d      # imm = 0x90BEFFFA
    5c04: 45 89 d0                     	movl	%r10d, %r8d
    5c07: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5c0b: 44 89 d3                     	movl	%r10d, %ebx
    5c0e: c1 c3 13                     	roll	$0x13, %ebx
    5c11: 44 31 c3                     	xorl	%r8d, %ebx
    5c14: 45 89 d7                     	movl	%r10d, %r15d
    5c17: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5c1b: 41 31 df                     	xorl	%ebx, %r15d
    5c1e: 89 d3                        	movl	%edx, %ebx
    5c20: 09 f3                        	orl	%esi, %ebx
    5c22: 44 21 d3                     	andl	%r10d, %ebx
    5c25: 41 89 d0                     	movl	%edx, %r8d
    5c28: 41 21 f0                     	andl	%esi, %r8d
    5c2b: 41 09 d8                     	orl	%ebx, %r8d
    5c2e: 45 01 f8                     	addl	%r15d, %r8d
    5c31: 89 cb                        	movl	%ecx, %ebx
    5c33: 44 31 f3                     	xorl	%r14d, %ebx
    5c36: 44 03 4d c4                  	addl	-0x3c(%rbp), %r9d
    5c3a: 44 01 d8                     	addl	%r11d, %eax
    5c3d: 21 c3                        	andl	%eax, %ebx
    5c3f: 44 31 f3                     	xorl	%r14d, %ebx
    5c42: 44 01 cb                     	addl	%r9d, %ebx
    5c45: 44 03 75 c8                  	addl	-0x38(%rbp), %r14d
    5c49: 41 89 c1                     	movl	%eax, %r9d
    5c4c: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    5c50: 41 89 c7                     	movl	%eax, %r15d
    5c53: 41 c1 c7 15                  	roll	$0x15, %r15d
    5c57: 45 31 cf                     	xorl	%r9d, %r15d
    5c5a: 41 89 c1                     	movl	%eax, %r9d
    5c5d: 41 c1 c1 07                  	roll	$0x7, %r9d
    5c61: 45 31 f9                     	xorl	%r15d, %r9d
    5c64: 41 01 d9                     	addl	%ebx, %r9d
    5c67: 41 81 c1 eb 6c 50 a4         	addl	$0xa4506ceb, %r9d       # imm = 0xA4506CEB
    5c6e: 44 01 ce                     	addl	%r9d, %esi
    5c71: 89 c3                        	movl	%eax, %ebx
    5c73: 31 cb                        	xorl	%ecx, %ebx
    5c75: 21 f3                        	andl	%esi, %ebx
    5c77: 31 cb                        	xorl	%ecx, %ebx
    5c79: 44 01 f3                     	addl	%r14d, %ebx
    5c7c: 41 89 f6                     	movl	%esi, %r14d
    5c7f: 41 89 f7                     	movl	%esi, %r15d
    5c82: 41 c1 c7 1a                  	roll	$0x1a, %r15d
    5c86: 41 c1 c6 15                  	roll	$0x15, %r14d
    5c8a: 45 31 fe                     	xorl	%r15d, %r14d
    5c8d: 41 89 f7                     	movl	%esi, %r15d
    5c90: 66 0f 6e c6                  	movd	%esi, %xmm0
    5c94: 41 89 f4                     	movl	%esi, %r12d
    5c97: 41 c1 c7 07                  	roll	$0x7, %r15d
    5c9b: 45 31 f7                     	xorl	%r14d, %r15d
    5c9e: 44 89 d6                     	movl	%r10d, %esi
    5ca1: 09 d6                        	orl	%edx, %esi
    5ca3: 44 01 fb                     	addl	%r15d, %ebx
    5ca6: 81 c3 f7 a3 f9 be            	addl	$0xbef9a3f7, %ebx       # imm = 0xBEF9A3F7
    5cac: 45 89 d6                     	movl	%r10d, %r14d
    5caf: 41 21 d6                     	andl	%edx, %r14d
    5cb2: 03 4d cc                     	addl	-0x34(%rbp), %ecx
    5cb5: 01 da                        	addl	%ebx, %edx
    5cb7: 41 31 c4                     	xorl	%eax, %r12d
    5cba: 41 21 d4                     	andl	%edx, %r12d
    5cbd: 41 31 c4                     	xorl	%eax, %r12d
    5cc0: 41 01 cc                     	addl	%ecx, %r12d
    5cc3: 45 01 d8                     	addl	%r11d, %r8d
    5cc6: 44 89 c1                     	movl	%r8d, %ecx
    5cc9: c1 c1 1e                     	roll	$0x1e, %ecx
    5ccc: 45 89 c3                     	movl	%r8d, %r11d
    5ccf: 41 c1 c3 13                  	roll	$0x13, %r11d
    5cd3: 41 31 cb                     	xorl	%ecx, %r11d
    5cd6: 44 89 c1                     	movl	%r8d, %ecx
    5cd9: c1 c1 0a                     	roll	$0xa, %ecx
    5cdc: 44 31 d9                     	xorl	%r11d, %ecx
    5cdf: 44 21 c6                     	andl	%r8d, %esi
    5ce2: 44 09 f6                     	orl	%r14d, %esi
    5ce5: 01 ce                        	addl	%ecx, %esi
    5ce7: 89 d1                        	movl	%edx, %ecx
    5ce9: 41 89 d3                     	movl	%edx, %r11d
    5cec: 66 0f 6e ca                  	movd	%edx, %xmm1
    5cf0: c1 c2 1a                     	roll	$0x1a, %edx
    5cf3: c1 c1 15                     	roll	$0x15, %ecx
    5cf6: 41 c1 c3 07                  	roll	$0x7, %r11d
    5cfa: 31 d1                        	xorl	%edx, %ecx
    5cfc: 41 31 cb                     	xorl	%ecx, %r11d
    5cff: 44 89 c2                     	movl	%r8d, %edx
    5d02: 44 09 d2                     	orl	%r10d, %edx
    5d05: 44 01 ce                     	addl	%r9d, %esi
    5d08: 41 89 f1                     	movl	%esi, %r9d
    5d0b: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5d0f: 43 8d 0c 23                  	leal	(%r11,%r12), %ecx
    5d13: 81 c1 f2 78 71 c6            	addl	$0xc67178f2, %ecx       # imm = 0xC67178F2
    5d19: 41 89 f3                     	movl	%esi, %r11d
    5d1c: 41 c1 c3 13                  	roll	$0x13, %r11d
    5d20: 45 31 cb                     	xorl	%r9d, %r11d
    5d23: 41 89 f1                     	movl	%esi, %r9d
    5d26: 41 c1 c1 0a                  	roll	$0xa, %r9d
    5d2a: 45 31 d9                     	xorl	%r11d, %r9d
    5d2d: 21 f2                        	andl	%esi, %edx
    5d2f: 41 89 f3                     	movl	%esi, %r11d
    5d32: 45 09 c3                     	orl	%r8d, %r11d
    5d35: 66 0f 6e d6                  	movd	%esi, %xmm2
    5d39: 44 21 c6                     	andl	%r8d, %esi
    5d3c: 66 41 0f 6e d8               	movd	%r8d, %xmm3
    5d41: 45 21 d0                     	andl	%r10d, %r8d
    5d44: 44 09 c2                     	orl	%r8d, %edx
    5d47: 44 01 ca                     	addl	%r9d, %edx
    5d4a: 01 da                        	addl	%ebx, %edx
    5d4c: 41 89 d0                     	movl	%edx, %r8d
    5d4f: 41 89 d1                     	movl	%edx, %r9d
    5d52: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5d56: 41 c1 c0 13                  	roll	$0x13, %r8d
    5d5a: 45 31 c8                     	xorl	%r9d, %r8d
    5d5d: 41 21 d3                     	andl	%edx, %r11d
    5d60: 66 0f 6e e2                  	movd	%edx, %xmm4
    5d64: c1 c2 0a                     	roll	$0xa, %edx
    5d67: 44 31 c2                     	xorl	%r8d, %edx
    5d6a: 44 09 de                     	orl	%r11d, %esi
    5d6d: 01 d6                        	addl	%edx, %esi
    5d6f: 41 01 ca                     	addl	%ecx, %r10d
    5d72: 01 ce                        	addl	%ecx, %esi
    5d74: 66 0f 6e ee                  	movd	%esi, %xmm5
    5d78: 66 41 0f 6e f2               	movd	%r10d, %xmm6
    5d7d: 66 0f 62 ec                  	punpckldq	%xmm4, %xmm5    # xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
    5d81: 66 0f 62 d3                  	punpckldq	%xmm3, %xmm2    # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
    5d85: 66 0f 6c ea                  	punpcklqdq	%xmm2, %xmm5    # xmm5 = xmm5[0],xmm2[0]
    5d89: 66 0f fe 2f                  	paddd	(%rdi), %xmm5
    5d8d: 66 0f 6e d0                  	movd	%eax, %xmm2
    5d91: 66 0f 7f 2f                  	movdqa	%xmm5, (%rdi)
    5d95: 66 0f 62 f1                  	punpckldq	%xmm1, %xmm6    # xmm6 = xmm6[0],xmm1[0],xmm6[1],xmm1[1]
    5d99: 66 0f 62 c2                  	punpckldq	%xmm2, %xmm0    # xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
    5d9d: 66 0f 6c f0                  	punpcklqdq	%xmm0, %xmm6    # xmm6 = xmm6[0],xmm0[0]
    5da1: 66 0f fe 77 10               	paddd	0x10(%rdi), %xmm6
    5da6: 66 0f 7f 77 10               	movdqa	%xmm6, 0x10(%rdi)
    5dab: 48 81 c4 88 00 00 00         	addq	$0x88, %rsp
    5db2: 5b                           	popq	%rbx
    5db3: 41 5c                        	popq	%r12
    5db5: 41 5d                        	popq	%r13
    5db7: 41 5e                        	popq	%r14
    5db9: 41 5f                        	popq	%r15
    5dbb: 5d                           	popq	%rbp
    5dbc: c3                           	retq
    5dbd: 0f 1f 00                     	nopl	(%rax)

0000000000005dc0 <audit_master256>:
    5dc0: 55                           	pushq	%rbp
    5dc1: 48 89 e5                     	movq	%rsp, %rbp
    5dc4: 41 56                        	pushq	%r14
    5dc6: 53                           	pushq	%rbx
    5dc7: 48 81 ec 50 01 00 00         	subq	$0x150, %rsp            # imm = 0x150
    5dce: 48 89 f3                     	movq	%rsi, %rbx
    5dd1: 49 89 f8                     	movq	%rdi, %r8
    5dd4: 66 c7 85 a0 fe ff ff 00 20   	movw	$0x2000, -0x160(%rbp)   # imm = 0x2000
    5ddd: c6 85 a2 fe ff ff 0d         	movb	$0xd, -0x15e(%rbp)
    5de4: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    5dee: 48 89 85 a3 fe ff ff         	movq	%rax, -0x15d(%rbp)
    5df5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    5dff: 48 89 85 a8 fe ff ff         	movq	%rax, -0x158(%rbp)
    5e06: c6 85 b0 fe ff ff 20         	movb	$0x20, -0x150(%rbp)
    5e0d: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x54>
		0000000000005e10:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
    5e14: 0f 11 85 b1 fe ff ff         	movups	%xmm0, -0x14f(%rbp)
    5e1b: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_master256+0x62>
		0000000000005e1e:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
    5e22: 0f 11 85 c1 fe ff ff         	movups	%xmm0, -0x13f(%rbp)
    5e29: 4c 8d 75 b0                  	leaq	-0x50(%rbp), %r14
    5e2d: 48 8d 95 a0 fe ff ff         	leaq	-0x160(%rbp), %rdx
    5e34: be 20 00 00 00               	movl	$0x20, %esi
    5e39: b9 31 00 00 00               	movl	$0x31, %ecx
    5e3e: 4c 89 f7                     	movq	%r14, %rdi
    5e41: e8 5a da ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    5e46: 48 8d 7d d0                  	leaq	-0x30(%rbp), %rdi
    5e4a: ba 00 00 00 00               	movl	$0x0, %edx
		0000000000005e4b:  R_X86_64_32	.rodata.cst32
    5e4f: 4c 89 f6                     	movq	%r14, %rsi
    5e52: e8 29 00 00 00               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    5e57: 0f 10 45 d0                  	movups	-0x30(%rbp), %xmm0
    5e5b: 0f 10 4d e0                  	movups	-0x20(%rbp), %xmm1
    5e5f: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    5e63: 0f 11 03                     	movups	%xmm0, (%rbx)
    5e66: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            # imm = 0x150
    5e6d: 5b                           	popq	%rbx
    5e6e: 41 5e                        	popq	%r14
    5e70: 5d                           	popq	%rbp
    5e71: c3                           	retq
    5e72: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    5e7c: 0f 1f 40 00                  	nopl	(%rax)

0000000000005e80 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
    5e80: 55                           	pushq	%rbp
    5e81: 48 89 e5                     	movq	%rsp, %rbp
    5e84: 41 57                        	pushq	%r15
    5e86: 41 56                        	pushq	%r14
    5e88: 41 55                        	pushq	%r13
    5e8a: 41 54                        	pushq	%r12
    5e8c: 53                           	pushq	%rbx
    5e8d: 48 81 ec 88 01 00 00         	subq	$0x188, %rsp            # imm = 0x188
    5e94: 49 89 d7                     	movq	%rdx, %r15
    5e97: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    5e9b: 0f 10 06                     	movups	(%rsi), %xmm0
    5e9e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    5ea2: 0f 29 4d a0                  	movaps	%xmm1, -0x60(%rbp)
    5ea6: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    5eaa: 0f 57 c0                     	xorps	%xmm0, %xmm0
    5ead: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    5eb1: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    5eb5: 31 c0                        	xorl	%eax, %eax
    5eb7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)
<L0>:
    5ec0: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    5ec5: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    5eca: 80 f1 5c                     	xorb	$0x5c, %cl
    5ecd: 88 8c 05 e0 fe ff ff         	movb	%cl, -0x120(%rbp,%rax)
    5ed4: 80 f2 5c                     	xorb	$0x5c, %dl
    5ed7: 88 94 05 e1 fe ff ff         	movb	%dl, -0x11f(%rbp,%rax)
    5ede: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    5ee3: 80 f1 5c                     	xorb	$0x5c, %cl
    5ee6: 88 8c 05 e2 fe ff ff         	movb	%cl, -0x11e(%rbp,%rax)
    5eed: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    5ef2: 80 f1 5c                     	xorb	$0x5c, %cl
    5ef5: 88 8c 05 e3 fe ff ff         	movb	%cl, -0x11d(%rbp,%rax)
    5efc: 48 83 c0 04                  	addq	$0x4, %rax
    5f00: 48 83 f8 40                  	cmpq	$0x40, %rax
    5f04: 75 ba                        	jne	 <L0>
    5f06: b8 03 00 00 00               	movl	$0x3, %eax
    5f0b: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L1>:
    5f10: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    5f15: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    5f1a: 80 f1 36                     	xorb	$0x36, %cl
    5f1d: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    5f24: 80 f2 36                     	xorb	$0x36, %dl
    5f27: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    5f2e: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    5f33: 80 f1 36                     	xorb	$0x36, %cl
    5f36: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    5f3d: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    5f42: 80 f1 36                     	xorb	$0x36, %cl
    5f45: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    5f4c: 48 83 c0 04                  	addq	$0x4, %rax
    5f50: 48 83 f8 43                  	cmpq	$0x43, %rax
    5f54: 75 ba                        	jne	 <L1>
    5f56: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xdd>
		0000000000005f59:  R_X86_64_PC32	.rodata+0x1bc
    5f5d: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
    5f64: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xeb>
		0000000000005f67:  R_X86_64_PC32	.rodata+0x1ac
    5f6b: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    5f72: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xf9>
		0000000000005f75:  R_X86_64_PC32	.rodata+0x19c
    5f79: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
    5f80: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x107>
		0000000000005f83:  R_X86_64_PC32	.rodata+0x18c
    5f87: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    5f8e: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x115>
		0000000000005f91:  R_X86_64_PC32	.rodata+0x17c
    5f95: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    5f9c: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x123>
		0000000000005f9f:  R_X86_64_PC32	.rodata+0x16c
    5fa3: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    5faa: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x131>
		0000000000005fad:  R_X86_64_PC32	.rodata+0x15c
    5fb1: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    5fb8: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    5fbf: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    5fc6: e8 95 e1 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    5fcb: 48 8b 9d 90 fe ff ff         	movq	-0x170(%rbp), %rbx
    5fd2: 48 83 c3 40                  	addq	$0x40, %rbx
    5fd6: 48 89 9d 90 fe ff ff         	movq	%rbx, -0x170(%rbp)
    5fdd: 0f b6 85 d8 fe ff ff         	movzbl	-0x128(%rbp), %eax
    5fe4: 48 85 c0                     	testq	%rax, %rax
    5fe7: 74 4b                        	je	 <L3>
    5fe9: 3c 20                        	cmpb	$0x20, %al
    5feb: 72 49                        	jb	 <L4>
    5fed: 41 bd 40 00 00 00            	movl	$0x40, %r13d
    5ff3: 49 29 c5                     	subq	%rax, %r13
    5ff6: 4c 8d a5 98 fe ff ff         	leaq	-0x168(%rbp), %r12
    5ffd: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    6001: 48 81 c7 98 fe ff ff         	addq	$-0x168, %rdi           # imm = 0xFE98
    6008: 4c 89 fe                     	movq	%r15, %rsi
    600b: 4c 89 ea                     	movq	%r13, %rdx
    600e: e8 00 00 00 00               	callq	 <L2>
		000000000000600f:  R_X86_64_PLT32	memcpy-0x4
<L2>:
    6013: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    601a: 4c 89 e6                     	movq	%r12, %rsi
    601d: e8 3e e1 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    6022: c6 85 d8 fe ff ff 00         	movb	$0x0, -0x128(%rbp)
    6029: 31 c0                        	xorl	%eax, %eax
    602b: 48 8b 9d 90 fe ff ff         	movq	-0x170(%rbp), %rbx
    6032: eb 05                        	jmp	 <L5>
<L3>:
    6034: 31 c0                        	xorl	%eax, %eax
<L4>:
    6036: 45 31 ed                     	xorl	%r13d, %r13d
<L5>:
    6039: 4d 01 ef                     	addq	%r13, %r15
    603c: 41 bc 20 00 00 00            	movl	$0x20, %r12d
    6042: 41 be 20 00 00 00            	movl	$0x20, %r14d
    6048: 4d 29 ee                     	subq	%r13, %r14
    604b: 0f b6 c0                     	movzbl	%al, %eax
    604e: 48 8d 3c 28                  	leaq	(%rax,%rbp), %rdi
    6052: 48 81 c7 98 fe ff ff         	addq	$-0x168, %rdi           # imm = 0xFE98
    6059: 4c 89 fe                     	movq	%r15, %rsi
    605c: 4c 89 f2                     	movq	%r14, %rdx
    605f: e8 00 00 00 00               	callq	 <L6>
		0000000000006060:  R_X86_64_PLT32	memcpy-0x4
<L6>:
    6064: 44 00 b5 d8 fe ff ff         	addb	%r14b, -0x128(%rbp)
    606b: 48 83 c3 20                  	addq	$0x20, %rbx
    606f: 48 89 9d 90 fe ff ff         	movq	%rbx, -0x170(%rbp)
    6076: 48 8d bd 70 fe ff ff         	leaq	-0x190(%rbp), %rdi
    607d: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    6081: e8 ba df ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    6086: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x20d>
		0000000000006089:  R_X86_64_PC32	.rodata+0x1bc
    608d: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    6091: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x218>
		0000000000006094:  R_X86_64_PC32	.rodata+0x1ac
    6098: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    609f: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x226>
		00000000000060a2:  R_X86_64_PC32	.rodata+0x19c
    60a6: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    60ad: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x234>
		00000000000060b0:  R_X86_64_PC32	.rodata+0x18c
    60b4: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    60bb: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x242>
		00000000000060be:  R_X86_64_PC32	.rodata+0x17c
    60c2: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    60c9: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x250>
		00000000000060cc:  R_X86_64_PC32	.rodata+0x16c
    60d0: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    60d7: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x25e>
		00000000000060da:  R_X86_64_PC32	.rodata+0x15c
    60de: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    60e5: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    60ec: 48 8d b5 e0 fe ff ff         	leaq	-0x120(%rbp), %rsi
    60f3: e8 68 e0 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    60f8: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    60fc: 48 8b 9d 40 ff ff ff         	movq	-0xc0(%rbp), %rbx
    6103: 48 83 c3 40                  	addq	$0x40, %rbx
    6107: 4c 8d b5 48 ff ff ff         	leaq	-0xb8(%rbp), %r14
    610e: 48 89 9d 40 ff ff ff         	movq	%rbx, -0xc0(%rbp)
    6115: 48 85 ff                     	testq	%rdi, %rdi
    6118: 74 3c                        	je	 <L8>
    611a: 40 80 ff 20                  	cmpb	$0x20, %dil
    611e: 72 38                        	jb	 <L9>
    6120: 41 bf 40 00 00 00            	movl	$0x40, %r15d
    6126: 49 29 ff                     	subq	%rdi, %r15
    6129: 4c 01 f7                     	addq	%r14, %rdi
    612c: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    6130: 4c 89 fa                     	movq	%r15, %rdx
    6133: e8 00 00 00 00               	callq	 <L7>
		0000000000006134:  R_X86_64_PLT32	memcpy-0x4
<L7>:
    6138: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    613f: 4c 89 f6                     	movq	%r14, %rsi
    6142: e8 19 e0 ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>
    6147: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    614b: 31 ff                        	xorl	%edi, %edi
    614d: 48 8b 9d 40 ff ff ff         	movq	-0xc0(%rbp), %rbx
    6154: eb 05                        	jmp	 <L10>
<L8>:
    6156: 31 ff                        	xorl	%edi, %edi
<L9>:
    6158: 45 31 ff                     	xorl	%r15d, %r15d
<L10>:
    615b: 49 8d 34 2f                  	leaq	(%r15,%rbp), %rsi
    615f: 48 83 c6 90                  	addq	$-0x70, %rsi
    6163: 4d 29 fc                     	subq	%r15, %r12
    6166: 40 0f b6 c7                  	movzbl	%dil, %eax
    616a: 49 01 c6                     	addq	%rax, %r14
    616d: 4c 89 f7                     	movq	%r14, %rdi
    6170: 4c 89 e2                     	movq	%r12, %rdx
    6173: e8 00 00 00 00               	callq	 <L11>
		0000000000006174:  R_X86_64_PLT32	memcpy-0x4
<L11>:
    6178: 44 00 65 88                  	addb	%r12b, -0x78(%rbp)
    617c: 48 83 c3 20                  	addq	$0x20, %rbx
    6180: 48 89 9d 40 ff ff ff         	movq	%rbx, -0xc0(%rbp)
    6187: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    618e: 48 8d b5 50 fe ff ff         	leaq	-0x1b0(%rbp), %rsi
    6195: e8 a6 de ff ff               	callq	 <crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>
    619a: 0f 10 85 50 fe ff ff         	movups	-0x1b0(%rbp), %xmm0
    61a1: 0f 10 8d 60 fe ff ff         	movups	-0x1a0(%rbp), %xmm1
    61a8: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    61ac: 0f 11 48 10                  	movups	%xmm1, 0x10(%rax)
    61b0: 0f 11 00                     	movups	%xmm0, (%rax)
    61b3: 48 81 c4 88 01 00 00         	addq	$0x188, %rsp            # imm = 0x188
    61ba: 5b                           	popq	%rbx
    61bb: 41 5c                        	popq	%r12
    61bd: 41 5d                        	popq	%r13
    61bf: 41 5e                        	popq	%r14
    61c1: 41 5f                        	popq	%r15
    61c3: 5d                           	popq	%rbp
    61c4: c3                           	retq
    61c5: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    61cf: 90                           	nop

00000000000061d0 <audit_handshake256>:
    61d0: 55                           	pushq	%rbp
    61d1: 48 89 e5                     	movq	%rsp, %rbp
    61d4: 41 57                        	pushq	%r15
    61d6: 41 56                        	pushq	%r14
    61d8: 53                           	pushq	%rbx
    61d9: 48 81 ec 58 01 00 00         	subq	$0x158, %rsp            # imm = 0x158
    61e0: 48 89 d3                     	movq	%rdx, %rbx
    61e3: 49 89 f6                     	movq	%rsi, %r14
    61e6: 49 89 f8                     	movq	%rdi, %r8
    61e9: 66 c7 85 98 fe ff ff 00 20   	movw	$0x2000, -0x168(%rbp)   # imm = 0x2000
    61f2: c6 85 9a fe ff ff 0d         	movb	$0xd, -0x166(%rbp)
    61f9: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax # imm = 0x6564203331736C74
    6203: 48 89 85 9b fe ff ff         	movq	%rax, -0x165(%rbp)
    620a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax # imm = 0x6465766972656420
    6214: 48 89 85 a0 fe ff ff         	movq	%rax, -0x160(%rbp)
    621b: c6 85 a8 fe ff ff 20         	movb	$0x20, -0x158(%rbp)
    6222: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x59>
		0000000000006225:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash-0x4
    6229: 0f 11 85 a9 fe ff ff         	movups	%xmm0, -0x157(%rbp)
    6230: 0f 10 05 00 00 00 00         	movups	, %xmm0 <audit_handshake256+0x67>
		0000000000006233:  R_X86_64_PC32	hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).empty_hash+0xc
    6237: 0f 11 85 b9 fe ff ff         	movups	%xmm0, -0x147(%rbp)
    623e: 4c 8d 7d a8                  	leaq	-0x58(%rbp), %r15
    6242: 48 8d 95 98 fe ff ff         	leaq	-0x168(%rbp), %rdx
    6249: be 20 00 00 00               	movl	$0x20, %esi
    624e: b9 31 00 00 00               	movl	$0x31, %ecx
    6253: 4c 89 ff                     	movq	%r15, %rdi
    6256: e8 45 d6 ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>
    625b: 48 8d 7d c8                  	leaq	-0x38(%rbp), %rdi
    625f: 4c 89 fe                     	movq	%r15, %rsi
    6262: 4c 89 f2                     	movq	%r14, %rdx
    6265: e8 16 fc ff ff               	callq	 <crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>
    626a: 0f 10 45 c8                  	movups	-0x38(%rbp), %xmm0
    626e: 0f 10 4d d8                  	movups	-0x28(%rbp), %xmm1
    6272: 0f 11 4b 10                  	movups	%xmm1, 0x10(%rbx)
    6276: 0f 11 03                     	movups	%xmm0, (%rbx)
    6279: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            # imm = 0x158
    6280: 5b                           	popq	%rbx
    6281: 41 5e                        	popq	%r14
    6283: 41 5f                        	popq	%r15
    6285: 5d                           	popq	%rbp
    6286: c3                           	retq
