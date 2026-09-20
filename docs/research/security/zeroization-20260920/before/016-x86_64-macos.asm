
/tmp/ztls-signoff-20260919/125-before-6d73a0a/016-x86_64-macos.o:	file format mach-o 64-bit x86-64

Disassembly of section __TEXT,__text:

0000000000000000 <_audit_key384>:
       0: 55                           	pushq	%rbp
       1: 48 89 e5                     	movq	%rsp, %rbp
       4: 48 81 ec 40 01 00 00         	subq	$0x140, %rsp            ## imm = 0x140
       b: 48 89 f0                     	movq	%rsi, %rax
       e: 48 8b 4f 28                  	movq	0x28(%rdi), %rcx
      12: 48 89 4d f8                  	movq	%rcx, -0x8(%rbp)
      16: 48 8b 4f 20                  	movq	0x20(%rdi), %rcx
      1a: 48 89 4d f0                  	movq	%rcx, -0x10(%rbp)
      1e: 48 8b 4f 18                  	movq	0x18(%rdi), %rcx
      22: 48 89 4d e8                  	movq	%rcx, -0x18(%rbp)
      26: 48 8b 4f 10                  	movq	0x10(%rdi), %rcx
      2a: 48 89 4d e0                  	movq	%rcx, -0x20(%rbp)
      2e: 48 8b 0f                     	movq	(%rdi), %rcx
      31: 48 8b 57 08                  	movq	0x8(%rdi), %rdx
      35: 48 89 55 d8                  	movq	%rdx, -0x28(%rbp)
      39: 48 89 4d d0                  	movq	%rcx, -0x30(%rbp)
      3d: 66 c7 85 c4 fe ff ff 00 20   	movw	$0x2000, -0x13c(%rbp)   ## imm = 0x2000
      46: c6 85 c6 fe ff ff 09         	movb	$0x9, -0x13a(%rbp)
      4d: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx ## imm = 0x656B203331736C74
      57: 48 89 8d c7 fe ff ff         	movq	%rcx, -0x139(%rbp)
      5e: 66 c7 85 cf fe ff ff 79 00   	movw	$0x79, -0x131(%rbp)
      67: 48 8d 95 c4 fe ff ff         	leaq	-0x13c(%rbp), %rdx
      6e: 4c 8d 45 d0                  	leaq	-0x30(%rbp), %r8
      72: be 20 00 00 00               	movl	$0x20, %esi
      77: b9 0d 00 00 00               	movl	$0xd, %ecx
      7c: 48 89 c7                     	movq	%rax, %rdi
      7f: e8 00 00 00 00               	callq	 <L0>
		0000000000000080:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
      84: 48 81 c4 40 01 00 00         	addq	$0x140, %rsp            ## imm = 0x140
      8b: 5d                           	popq	%rbp
      8c: c3                           	retq
      8d: 0f 1f 00                     	nopl	(%rax)

0000000000000090 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
      90: 55                           	pushq	%rbp
      91: 48 89 e5                     	movq	%rsp, %rbp
      94: 41 57                        	pushq	%r15
      96: 41 56                        	pushq	%r14
      98: 41 55                        	pushq	%r13
      9a: 41 54                        	pushq	%r12
      9c: 53                           	pushq	%rbx
      9d: 48 81 ec c8 05 00 00         	subq	$0x5c8, %rsp            ## imm = 0x5C8
      a4: 48 89 55 a8                  	movq	%rdx, -0x58(%rbp)
      a8: 48 89 7d c8                  	movq	%rdi, -0x38(%rbp)
      ac: 49 8b 40 28                  	movq	0x28(%r8), %rax
      b0: 48 89 45 98                  	movq	%rax, -0x68(%rbp)
      b4: 49 8b 40 20                  	movq	0x20(%r8), %rax
      b8: 48 89 45 90                  	movq	%rax, -0x70(%rbp)
      bc: 49 8b 40 18                  	movq	0x18(%r8), %rax
      c0: 48 89 45 88                  	movq	%rax, -0x78(%rbp)
      c4: 49 8b 40 10                  	movq	0x10(%r8), %rax
      c8: 48 89 45 80                  	movq	%rax, -0x80(%rbp)
      cc: 49 8b 00                     	movq	(%r8), %rax
      cf: 49 8b 50 08                  	movq	0x8(%r8), %rdx
      d3: 48 89 95 78 ff ff ff         	movq	%rdx, -0x88(%rbp)
      da: 48 89 85 70 ff ff ff         	movq	%rax, -0x90(%rbp)
      e1: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
      e5: 48 89 75 a0                  	movq	%rsi, -0x60(%rbp)
      e9: 48 83 fe 30                  	cmpq	$0x30, %rsi
      ed: 48 89 4d b0                  	movq	%rcx, -0x50(%rbp)
      f1: 0f 83 40 02 00 00            	jae	 <L7>
      f7: 48 c7 45 c0 00 00 00 00      	movq	$0x0, -0x40(%rbp)
<L0>:
      ff: 4c 8b 65 c0                  	movq	-0x40(%rbp), %r12
     103: 48 8b 45 a0                  	movq	-0x60(%rbp), %rax
     107: 48 89 c1                     	movq	%rax, %rcx
     10a: 48 83 e9 30                  	subq	$0x30, %rcx
     10e: 48 0f 42 c8                  	cmovbq	%rax, %rcx
     112: 48 85 c9                     	testq	%rcx, %rcx
     115: 0f 84 e4 09 00 00            	je	 <L70>
     11b: 48 89 4d b8                  	movq	%rcx, -0x48(%rbp)
     11f: 48 8b 45 98                  	movq	-0x68(%rbp), %rax
     123: 48 89 85 18 ff ff ff         	movq	%rax, -0xe8(%rbp)
     12a: 48 8b 45 90                  	movq	-0x70(%rbp), %rax
     12e: 48 89 85 10 ff ff ff         	movq	%rax, -0xf0(%rbp)
     135: 48 8b 45 88                  	movq	-0x78(%rbp), %rax
     139: 48 89 85 08 ff ff ff         	movq	%rax, -0xf8(%rbp)
     140: 48 8b 45 80                  	movq	-0x80(%rbp), %rax
     144: 48 89 85 00 ff ff ff         	movq	%rax, -0x100(%rbp)
     14b: 48 8b 85 70 ff ff ff         	movq	-0x90(%rbp), %rax
     152: 48 8b 8d 78 ff ff ff         	movq	-0x88(%rbp), %rcx
     159: 48 89 8d f8 fe ff ff         	movq	%rcx, -0x108(%rbp)
     160: 48 89 85 f0 fe ff ff         	movq	%rax, -0x110(%rbp)
     167: 48 c7 85 20 ff ff ff 00 00 00 00     	movq	$0x0, -0xe0(%rbp)
     172: 48 c7 85 28 ff ff ff 00 00 00 00     	movq	$0x0, -0xd8(%rbp)
     17d: 48 c7 85 30 ff ff ff 00 00 00 00     	movq	$0x0, -0xd0(%rbp)
     188: 48 c7 85 38 ff ff ff 00 00 00 00     	movq	$0x0, -0xc8(%rbp)
     193: 48 c7 85 40 ff ff ff 00 00 00 00     	movq	$0x0, -0xc0(%rbp)
     19e: 48 c7 85 48 ff ff ff 00 00 00 00     	movq	$0x0, -0xb8(%rbp)
     1a9: 48 c7 85 50 ff ff ff 00 00 00 00     	movq	$0x0, -0xb0(%rbp)
     1b4: 48 c7 85 58 ff ff ff 00 00 00 00     	movq	$0x0, -0xa8(%rbp)
     1bf: 48 c7 85 60 ff ff ff 00 00 00 00     	movq	$0x0, -0xa0(%rbp)
     1ca: 48 c7 85 68 ff ff ff 00 00 00 00     	movq	$0x0, -0x98(%rbp)
     1d5: 31 c0                        	xorl	%eax, %eax
     1d7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)
<L1>:
     1e0: 0f b6 8c 05 f0 fe ff ff      	movzbl	-0x110(%rbp,%rax), %ecx
     1e8: 0f b6 94 05 f1 fe ff ff      	movzbl	-0x10f(%rbp,%rax), %edx
     1f0: 80 f1 5c                     	xorb	$0x5c, %cl
     1f3: 88 8c 05 80 fc ff ff         	movb	%cl, -0x380(%rbp,%rax)
     1fa: 80 f2 5c                     	xorb	$0x5c, %dl
     1fd: 88 94 05 81 fc ff ff         	movb	%dl, -0x37f(%rbp,%rax)
     204: 0f b6 8c 05 f2 fe ff ff      	movzbl	-0x10e(%rbp,%rax), %ecx
     20c: 80 f1 5c                     	xorb	$0x5c, %cl
     20f: 88 8c 05 82 fc ff ff         	movb	%cl, -0x37e(%rbp,%rax)
     216: 0f b6 8c 05 f3 fe ff ff      	movzbl	-0x10d(%rbp,%rax), %ecx
     21e: 80 f1 5c                     	xorb	$0x5c, %cl
     221: 88 8c 05 83 fc ff ff         	movb	%cl, -0x37d(%rbp,%rax)
     228: 48 83 c0 04                  	addq	$0x4, %rax
     22c: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
     232: 75 ac                        	jne	 <L1>
     234: b8 03 00 00 00               	movl	$0x3, %eax
     239: 48 8b 5d b0                  	movq	-0x50(%rbp), %rbx
     23d: 0f 1f 00                     	nopl	(%rax)
<L2>:
     240: 0f b6 8c 05 ed fe ff ff      	movzbl	-0x113(%rbp,%rax), %ecx
     248: 0f b6 94 05 ee fe ff ff      	movzbl	-0x112(%rbp,%rax), %edx
     250: 80 f1 36                     	xorb	$0x36, %cl
     253: 88 8c 05 7d fd ff ff         	movb	%cl, -0x283(%rbp,%rax)
     25a: 80 f2 36                     	xorb	$0x36, %dl
     25d: 88 94 05 7e fd ff ff         	movb	%dl, -0x282(%rbp,%rax)
     264: 0f b6 8c 05 ef fe ff ff      	movzbl	-0x111(%rbp,%rax), %ecx
     26c: 80 f1 36                     	xorb	$0x36, %cl
     26f: 88 8c 05 7f fd ff ff         	movb	%cl, -0x281(%rbp,%rax)
     276: 0f b6 8c 05 f0 fe ff ff      	movzbl	-0x110(%rbp,%rax), %ecx
     27e: 80 f1 36                     	xorb	$0x36, %cl
     281: 88 8c 05 80 fd ff ff         	movb	%cl, -0x280(%rbp,%rax)
     288: 48 83 c0 04                  	addq	$0x4, %rax
     28c: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
     292: 75 ac                        	jne	 <L2>
     294: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x20b>
		0000000000000297:  X86_64_RELOC_SIGNED	___anon_817
     29b: 4c 8d b5 a0 fb ff ff         	leaq	-0x460(%rbp), %r14
     2a2: ba e0 00 00 00               	movl	$0xe0, %edx
     2a7: 4c 89 f7                     	movq	%r14, %rdi
     2aa: e8 00 00 00 00               	callq	 <L3>
		00000000000002ab:  X86_64_RELOC_BRANCH	_memcpy
<L3>:
     2af: 48 8d b5 80 fd ff ff         	leaq	-0x280(%rbp), %rsi
     2b6: 4c 89 f7                     	movq	%r14, %rdi
     2b9: e8 00 00 00 00               	callq	 <L4>
		00000000000002ba:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L4>:
     2be: 48 81 85 a0 fb ff ff 80 00 00 00     	addq	$0x80, -0x460(%rbp)
     2c9: 48 83 95 a8 fb ff ff 00      	adcq	$0x0, -0x458(%rbp)
     2d1: 0f b6 85 70 fc ff ff         	movzbl	-0x390(%rbp), %eax
     2d8: 48 83 7d a0 2f               	cmpq	$0x2f, -0x60(%rbp)
     2dd: 0f 86 aa 05 00 00            	jbe	 <L47>
     2e3: 84 c0                        	testb	%al, %al
     2e5: 0f 84 58 05 00 00            	je	 <L43>
     2eb: 3c 50                        	cmpb	$0x50, %al
     2ed: 0f 82 52 05 00 00            	jb	 <L44>
     2f3: 0f b6 c0                     	movzbl	%al, %eax
     2f6: 41 be 80 00 00 00            	movl	$0x80, %r14d
     2fc: 49 29 c6                     	subq	%rax, %r14
     2ff: 4c 8d bd f0 fb ff ff         	leaq	-0x410(%rbp), %r15
     306: 48 8d bc 05 f0 fb ff ff      	leaq	-0x410(%rbp,%rax), %rdi
     30e: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     312: 4c 89 f2                     	movq	%r14, %rdx
     315: e8 00 00 00 00               	callq	 <L5>
		0000000000000316:  X86_64_RELOC_BRANCH	_memcpy
<L5>:
     31a: 48 8d bd a0 fb ff ff         	leaq	-0x460(%rbp), %rdi
     321: 4c 89 fe                     	movq	%r15, %rsi
     324: e8 00 00 00 00               	callq	 <L6>
		0000000000000325:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L6>:
     329: c6 85 70 fc ff ff 00         	movb	$0x0, -0x390(%rbp)
     330: 31 c0                        	xorl	%eax, %eax
     332: e9 11 05 00 00               	jmp	 <L45>
<L7>:
     337: 48 83 f1 7f                  	xorq	$0x7f, %rcx
     33b: 48 89 8d e8 fe ff ff         	movq	%rcx, -0x118(%rbp)
     342: b3 01                        	movb	$0x1, %bl
     344: 31 f6                        	xorl	%esi, %esi
     346: 41 b6 01                     	movb	$0x1, %r14b
     349: e9 86 00 00 00               	jmp	 <L13>
     34e: 66 90                        	nop
<L8>:
     350: 31 ff                        	xorl	%edi, %edi
<L9>:
     352: 31 c9                        	xorl	%ecx, %ecx
<L10>:
     354: 44 0f b6 75 b8               	movzbl	-0x48(%rbp), %r14d
     359: 4c 8b 65 c0                  	movq	-0x40(%rbp), %r12
     35d: 4c 03 65 c8                  	addq	-0x38(%rbp), %r12
     361: 48 8d b4 0d f0 fe ff ff      	leaq	-0x110(%rbp,%rcx), %rsi
     369: b8 30 00 00 00               	movl	$0x30, %eax
     36e: 48 89 45 c0                  	movq	%rax, -0x40(%rbp)
     372: bb 30 00 00 00               	movl	$0x30, %ebx
     377: 48 29 cb                     	subq	%rcx, %rbx
     37a: 40 0f b6 ff                  	movzbl	%dil, %edi
     37e: 48 8d 85 d0 fd ff ff         	leaq	-0x230(%rbp), %rax
     385: 48 01 c7                     	addq	%rax, %rdi
     388: 48 89 da                     	movq	%rbx, %rdx
     38b: e8 00 00 00 00               	callq	 <L11>
		000000000000038c:  X86_64_RELOC_BRANCH	_memcpy
<L11>:
     390: 00 9d 50 fe ff ff            	addb	%bl, -0x1b0(%rbp)
     396: 49 83 c5 30                  	addq	$0x30, %r13
     39a: 49 83 d7 00                  	adcq	$0x0, %r15
     39e: 4c 89 bd 88 fd ff ff         	movq	%r15, -0x278(%rbp)
     3a5: 4c 89 ad 80 fd ff ff         	movq	%r13, -0x280(%rbp)
     3ac: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     3b3: 4c 89 e6                     	movq	%r12, %rsi
     3b6: e8 00 00 00 00               	callq	 <L12>
		00000000000003b7:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L12>:
     3bb: 41 fe c6                     	incb	%r14b
     3be: 31 db                        	xorl	%ebx, %ebx
     3c0: 44 88 75 d7                  	movb	%r14b, -0x29(%rbp)
     3c4: be 30 00 00 00               	movl	$0x30, %esi
     3c9: 48 83 7d a0 60               	cmpq	$0x60, -0x60(%rbp)
     3ce: 0f 82 2b fd ff ff            	jb	 <L0>
<L13>:
     3d4: 44 88 75 b8                  	movb	%r14b, -0x48(%rbp)
     3d8: 48 8b 85 70 ff ff ff         	movq	-0x90(%rbp), %rax
     3df: 48 8b 8d 78 ff ff ff         	movq	-0x88(%rbp), %rcx
     3e6: 48 89 85 00 fd ff ff         	movq	%rax, -0x300(%rbp)
     3ed: 48 89 8d 08 fd ff ff         	movq	%rcx, -0x2f8(%rbp)
     3f4: 48 8b 45 80                  	movq	-0x80(%rbp), %rax
     3f8: 48 89 85 10 fd ff ff         	movq	%rax, -0x2f0(%rbp)
     3ff: 48 8b 45 88                  	movq	-0x78(%rbp), %rax
     403: 48 89 85 18 fd ff ff         	movq	%rax, -0x2e8(%rbp)
     40a: 48 8b 45 90                  	movq	-0x70(%rbp), %rax
     40e: 48 89 85 20 fd ff ff         	movq	%rax, -0x2e0(%rbp)
     415: 48 8b 45 98                  	movq	-0x68(%rbp), %rax
     419: 48 89 85 28 fd ff ff         	movq	%rax, -0x2d8(%rbp)
     420: 48 8d 85 30 fd ff ff         	leaq	-0x2d0(%rbp), %rax
     427: 48 c7 40 48 00 00 00 00      	movq	$0x0, 0x48(%rax)
     42f: 48 c7 40 40 00 00 00 00      	movq	$0x0, 0x40(%rax)
     437: 48 c7 40 38 00 00 00 00      	movq	$0x0, 0x38(%rax)
     43f: 48 c7 40 30 00 00 00 00      	movq	$0x0, 0x30(%rax)
     447: 48 c7 40 28 00 00 00 00      	movq	$0x0, 0x28(%rax)
     44f: 48 c7 40 20 00 00 00 00      	movq	$0x0, 0x20(%rax)
     457: 48 c7 40 18 00 00 00 00      	movq	$0x0, 0x18(%rax)
     45f: 48 c7 40 10 00 00 00 00      	movq	$0x0, 0x10(%rax)
     467: 48 c7 40 08 00 00 00 00      	movq	$0x0, 0x8(%rax)
     46f: 48 c7 00 00 00 00 00         	movq	$0x0, (%rax)
     476: 31 c0                        	xorl	%eax, %eax
     478: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L14>:
     480: 0f b6 8c 05 00 fd ff ff      	movzbl	-0x300(%rbp,%rax), %ecx
     488: 0f b6 94 05 01 fd ff ff      	movzbl	-0x2ff(%rbp,%rax), %edx
     490: 80 f1 5c                     	xorb	$0x5c, %cl
     493: 88 8c 05 60 fe ff ff         	movb	%cl, -0x1a0(%rbp,%rax)
     49a: 80 f2 5c                     	xorb	$0x5c, %dl
     49d: 88 94 05 61 fe ff ff         	movb	%dl, -0x19f(%rbp,%rax)
     4a4: 0f b6 8c 05 02 fd ff ff      	movzbl	-0x2fe(%rbp,%rax), %ecx
     4ac: 80 f1 5c                     	xorb	$0x5c, %cl
     4af: 88 8c 05 62 fe ff ff         	movb	%cl, -0x19e(%rbp,%rax)
     4b6: 0f b6 8c 05 03 fd ff ff      	movzbl	-0x2fd(%rbp,%rax), %ecx
     4be: 80 f1 5c                     	xorb	$0x5c, %cl
     4c1: 88 8c 05 63 fe ff ff         	movb	%cl, -0x19d(%rbp,%rax)
     4c8: 48 83 c0 04                  	addq	$0x4, %rax
     4cc: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
     4d2: 75 ac                        	jne	 <L14>
     4d4: 48 89 75 c0                  	movq	%rsi, -0x40(%rbp)
     4d8: b8 03 00 00 00               	movl	$0x3, %eax
     4dd: 0f 1f 00                     	nopl	(%rax)
<L15>:
     4e0: 0f b6 8c 05 fd fc ff ff      	movzbl	-0x303(%rbp,%rax), %ecx
     4e8: 0f b6 94 05 fe fc ff ff      	movzbl	-0x302(%rbp,%rax), %edx
     4f0: 80 f1 36                     	xorb	$0x36, %cl
     4f3: 88 8c 05 ed fe ff ff         	movb	%cl, -0x113(%rbp,%rax)
     4fa: 80 f2 36                     	xorb	$0x36, %dl
     4fd: 88 94 05 ee fe ff ff         	movb	%dl, -0x112(%rbp,%rax)
     504: 0f b6 8c 05 ff fc ff ff      	movzbl	-0x301(%rbp,%rax), %ecx
     50c: 80 f1 36                     	xorb	$0x36, %cl
     50f: 88 8c 05 ef fe ff ff         	movb	%cl, -0x111(%rbp,%rax)
     516: 0f b6 8c 05 00 fd ff ff      	movzbl	-0x300(%rbp,%rax), %ecx
     51e: 80 f1 36                     	xorb	$0x36, %cl
     521: 88 8c 05 f0 fe ff ff         	movb	%cl, -0x110(%rbp,%rax)
     528: 48 83 c0 04                  	addq	$0x4, %rax
     52c: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
     532: 75 ac                        	jne	 <L15>
     534: ba e0 00 00 00               	movl	$0xe0, %edx
     539: 4c 8d b5 80 fd ff ff         	leaq	-0x280(%rbp), %r14
     540: 4c 89 f7                     	movq	%r14, %rdi
     543: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x4ba>
		0000000000000546:  X86_64_RELOC_SIGNED	___anon_817
     54a: e8 00 00 00 00               	callq	 <L16>
		000000000000054b:  X86_64_RELOC_BRANCH	_memcpy
<L16>:
     54f: 4c 89 f7                     	movq	%r14, %rdi
     552: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     559: e8 00 00 00 00               	callq	 <L17>
		000000000000055a:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L17>:
     55e: 48 81 85 80 fd ff ff 80 00 00 00     	addq	$0x80, -0x280(%rbp)
     569: 48 83 95 88 fd ff ff 00      	adcq	$0x0, -0x278(%rbp)
     571: ba 60 01 00 00               	movl	$0x160, %edx            ## imm = 0x160
     576: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     57d: 4c 89 f6                     	movq	%r14, %rsi
     580: e8 00 00 00 00               	callq	 <L18>
		0000000000000581:  X86_64_RELOC_BRANCH	_memcpy
<L18>:
     585: 0f b6 85 10 fb ff ff         	movzbl	-0x4f0(%rbp), %eax
     58c: f6 c3 01                     	testb	$0x1, %bl
     58f: 0f 85 8c 00 00 00            	jne	 <L25>
     595: 84 c0                        	testb	%al, %al
     597: 74 40                        	je	 <L21>
     599: 3c 50                        	cmpb	$0x50, %al
     59b: 72 3e                        	jb	 <L22>
     59d: 0f b6 f8                     	movzbl	%al, %edi
     5a0: 41 be 80 00 00 00            	movl	$0x80, %r14d
     5a6: 49 29 fe                     	subq	%rdi, %r14
     5a9: 48 8d 9d 90 fa ff ff         	leaq	-0x570(%rbp), %rbx
     5b0: 48 01 df                     	addq	%rbx, %rdi
     5b3: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     5b7: 4c 89 f2                     	movq	%r14, %rdx
     5ba: e8 00 00 00 00               	callq	 <L19>
		00000000000005bb:  X86_64_RELOC_BRANCH	_memcpy
<L19>:
     5bf: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     5c6: 48 89 de                     	movq	%rbx, %rsi
     5c9: e8 00 00 00 00               	callq	 <L20>
		00000000000005ca:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L20>:
     5ce: c6 85 10 fb ff ff 00         	movb	$0x0, -0x4f0(%rbp)
     5d5: 31 c0                        	xorl	%eax, %eax
     5d7: eb 05                        	jmp	 <L23>
<L21>:
     5d9: 31 c0                        	xorl	%eax, %eax
<L22>:
     5db: 45 31 f6                     	xorl	%r14d, %r14d
<L23>:
     5de: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
     5e2: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
     5e6: bb 30 00 00 00               	movl	$0x30, %ebx
     5eb: 4c 29 f3                     	subq	%r14, %rbx
     5ee: 0f b6 f8                     	movzbl	%al, %edi
     5f1: 48 8d 85 90 fa ff ff         	leaq	-0x570(%rbp), %rax
     5f8: 48 01 c7                     	addq	%rax, %rdi
     5fb: 48 89 da                     	movq	%rbx, %rdx
     5fe: e8 00 00 00 00               	callq	 <L24>
		00000000000005ff:  X86_64_RELOC_BRANCH	_memcpy
<L24>:
     603: 02 9d 10 fb ff ff            	addb	-0x4f0(%rbp), %bl
     609: 88 9d 10 fb ff ff            	movb	%bl, -0x4f0(%rbp)
     60f: 48 83 85 40 fa ff ff 30      	addq	$0x30, -0x5c0(%rbp)
     617: 48 83 95 48 fa ff ff 00      	adcq	$0x0, -0x5b8(%rbp)
     61f: 89 d8                        	movl	%ebx, %eax
<L25>:
     621: 84 c0                        	testb	%al, %al
     623: 74 4b                        	je	 <L28>
     625: 0f b6 f8                     	movzbl	%al, %edi
     628: 48 39 bd e8 fe ff ff         	cmpq	%rdi, -0x118(%rbp)
     62f: 73 41                        	jae	 <L29>
     631: b1 80                        	movb	$-0x80, %cl
     633: 28 c1                        	subb	%al, %cl
     635: 44 0f b6 f1                  	movzbl	%cl, %r14d
     639: 48 8d 9d 90 fa ff ff         	leaq	-0x570(%rbp), %rbx
     640: 48 01 df                     	addq	%rbx, %rdi
     643: 48 8b 75 a8                  	movq	-0x58(%rbp), %rsi
     647: 4c 89 f2                     	movq	%r14, %rdx
     64a: e8 00 00 00 00               	callq	 <L26>
		000000000000064b:  X86_64_RELOC_BRANCH	_memcpy
<L26>:
     64f: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     656: 48 89 de                     	movq	%rbx, %rsi
     659: e8 00 00 00 00               	callq	 <L27>
		000000000000065a:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L27>:
     65e: c6 85 10 fb ff ff 00         	movb	$0x0, -0x4f0(%rbp)
     665: 31 c0                        	xorl	%eax, %eax
     667: eb 0c                        	jmp	 <L30>
     669: 0f 1f 80 00 00 00 00         	nopl	(%rax)
<L28>:
     670: 31 c0                        	xorl	%eax, %eax
<L29>:
     672: 45 31 f6                     	xorl	%r14d, %r14d
<L30>:
     675: 48 8b 4d a8                  	movq	-0x58(%rbp), %rcx
     679: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
     67d: 4c 8b 65 b0                  	movq	-0x50(%rbp), %r12
     681: 4c 89 e3                     	movq	%r12, %rbx
     684: 4c 29 f3                     	subq	%r14, %rbx
     687: 0f b6 f8                     	movzbl	%al, %edi
     68a: 48 8d 85 90 fa ff ff         	leaq	-0x570(%rbp), %rax
     691: 48 01 c7                     	addq	%rax, %rdi
     694: 48 89 da                     	movq	%rbx, %rdx
     697: e8 00 00 00 00               	callq	 <L31>
		0000000000000698:  X86_64_RELOC_BRANCH	_memcpy
<L31>:
     69c: 0f b6 bd 10 fb ff ff         	movzbl	-0x4f0(%rbp), %edi
     6a3: 48 01 df                     	addq	%rbx, %rdi
     6a6: 40 88 bd 10 fb ff ff         	movb	%dil, -0x4f0(%rbp)
     6ad: 4c 8b ad 48 fa ff ff         	movq	-0x5b8(%rbp), %r13
     6b4: 4c 8b bd 40 fa ff ff         	movq	-0x5c0(%rbp), %r15
     6bb: 4d 01 e7                     	addq	%r12, %r15
     6be: 49 83 d5 00                  	adcq	$0x0, %r13
     6c2: 4c 89 bd 40 fa ff ff         	movq	%r15, -0x5c0(%rbp)
     6c9: 4c 89 ad 48 fa ff ff         	movq	%r13, -0x5b8(%rbp)
     6d0: 40 84 ff                     	testb	%dil, %dil
     6d3: 74 5b                        	je	 <L34>
     6d5: 40 80 ff 7f                  	cmpb	$0x7f, %dil
     6d9: 72 57                        	jb	 <L35>
     6db: b0 80                        	movb	$-0x80, %al
     6dd: 40 28 f8                     	subb	%dil, %al
     6e0: 44 0f b6 f0                  	movzbl	%al, %r14d
     6e4: 48 8d 9d 90 fa ff ff         	leaq	-0x570(%rbp), %rbx
     6eb: 48 01 df                     	addq	%rbx, %rdi
     6ee: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     6f2: 4c 89 f2                     	movq	%r14, %rdx
     6f5: e8 00 00 00 00               	callq	 <L32>
		00000000000006f6:  X86_64_RELOC_BRANCH	_memcpy
<L32>:
     6fa: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     701: 48 89 de                     	movq	%rbx, %rsi
     704: e8 00 00 00 00               	callq	 <L33>
		0000000000000705:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L33>:
     709: c6 85 10 fb ff ff 00         	movb	$0x0, -0x4f0(%rbp)
     710: 31 ff                        	xorl	%edi, %edi
     712: 4c 8b bd 40 fa ff ff         	movq	-0x5c0(%rbp), %r15
     719: 4c 8b ad 48 fa ff ff         	movq	-0x5b8(%rbp), %r13
     720: eb 13                        	jmp	 <L36>
     722: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     72c: 0f 1f 40 00                  	nopl	(%rax)
<L34>:
     730: 31 ff                        	xorl	%edi, %edi
<L35>:
     732: 45 31 f6                     	xorl	%r14d, %r14d
<L36>:
     735: 4a 8d 74 35 d7               	leaq	-0x29(%rbp,%r14), %rsi
     73a: bb 01 00 00 00               	movl	$0x1, %ebx
     73f: 4c 29 f3                     	subq	%r14, %rbx
     742: 40 0f b6 ff                  	movzbl	%dil, %edi
     746: 48 8d 85 90 fa ff ff         	leaq	-0x570(%rbp), %rax
     74d: 48 01 c7                     	addq	%rax, %rdi
     750: 48 89 da                     	movq	%rbx, %rdx
     753: e8 00 00 00 00               	callq	 <L37>
		0000000000000754:  X86_64_RELOC_BRANCH	_memcpy
<L37>:
     758: 00 9d 10 fb ff ff            	addb	%bl, -0x4f0(%rbp)
     75e: 49 83 c7 01                  	addq	$0x1, %r15
     762: 49 83 d5 00                  	adcq	$0x0, %r13
     766: 4c 89 ad 48 fa ff ff         	movq	%r13, -0x5b8(%rbp)
     76d: 4c 89 bd 40 fa ff ff         	movq	%r15, -0x5c0(%rbp)
     774: 48 8d bd 40 fa ff ff         	leaq	-0x5c0(%rbp), %rdi
     77b: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     782: e8 00 00 00 00               	callq	 <L38>
		0000000000000783:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L38>:
     787: ba e0 00 00 00               	movl	$0xe0, %edx
     78c: 48 8d 9d 80 fd ff ff         	leaq	-0x280(%rbp), %rbx
     793: 48 89 df                     	movq	%rbx, %rdi
     796: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x70d>
		0000000000000799:  X86_64_RELOC_SIGNED	___anon_817
     79d: e8 00 00 00 00               	callq	 <L39>
		000000000000079e:  X86_64_RELOC_BRANCH	_memcpy
<L39>:
     7a2: 48 89 df                     	movq	%rbx, %rdi
     7a5: 48 8d b5 20 fb ff ff         	leaq	-0x4e0(%rbp), %rsi
     7ac: e8 00 00 00 00               	callq	 <L40>
		00000000000007ad:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L40>:
     7b1: 4c 8b bd 88 fd ff ff         	movq	-0x278(%rbp), %r15
     7b8: 4c 8b ad 80 fd ff ff         	movq	-0x280(%rbp), %r13
     7bf: b8 80 00 00 00               	movl	$0x80, %eax
     7c4: 49 01 c5                     	addq	%rax, %r13
     7c7: 49 83 d7 00                  	adcq	$0x0, %r15
     7cb: 0f b6 bd 50 fe ff ff         	movzbl	-0x1b0(%rbp), %edi
     7d2: 4c 89 ad 80 fd ff ff         	movq	%r13, -0x280(%rbp)
     7d9: 4c 89 bd 88 fd ff ff         	movq	%r15, -0x278(%rbp)
     7e0: 48 85 ff                     	testq	%rdi, %rdi
     7e3: 0f 84 67 fb ff ff            	je	 <L8>
     7e9: 40 80 ff 50                  	cmpb	$0x50, %dil
     7ed: 0f 82 5f fb ff ff            	jb	 <L9>
     7f3: 41 be 80 00 00 00            	movl	$0x80, %r14d
     7f9: 49 29 fe                     	subq	%rdi, %r14
     7fc: 48 8d 9d d0 fd ff ff         	leaq	-0x230(%rbp), %rbx
     803: 48 01 df                     	addq	%rbx, %rdi
     806: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     80d: 4c 89 f2                     	movq	%r14, %rdx
     810: e8 00 00 00 00               	callq	 <L41>
		0000000000000811:  X86_64_RELOC_BRANCH	_memcpy
<L41>:
     815: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     81c: 48 89 de                     	movq	%rbx, %rsi
     81f: e8 00 00 00 00               	callq	 <L42>
		0000000000000820:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L42>:
     824: 4c 89 f1                     	movq	%r14, %rcx
     827: c6 85 50 fe ff ff 00         	movb	$0x0, -0x1b0(%rbp)
     82e: 31 ff                        	xorl	%edi, %edi
     830: 4c 8b ad 80 fd ff ff         	movq	-0x280(%rbp), %r13
     837: 4c 8b bd 88 fd ff ff         	movq	-0x278(%rbp), %r15
     83e: e9 11 fb ff ff               	jmp	 <L10>
<L43>:
     843: 31 c0                        	xorl	%eax, %eax
<L44>:
     845: 45 31 f6                     	xorl	%r14d, %r14d
<L45>:
     848: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
     84c: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
     850: 41 bf 30 00 00 00            	movl	$0x30, %r15d
     856: 4d 29 f7                     	subq	%r14, %r15
     859: 0f b6 c0                     	movzbl	%al, %eax
     85c: 48 8d bc 05 f0 fb ff ff      	leaq	-0x410(%rbp,%rax), %rdi
     864: 4c 89 fa                     	movq	%r15, %rdx
     867: e8 00 00 00 00               	callq	 <L46>
		0000000000000868:  X86_64_RELOC_BRANCH	_memcpy
<L46>:
     86c: 44 02 bd 70 fc ff ff         	addb	-0x390(%rbp), %r15b
     873: 44 88 bd 70 fc ff ff         	movb	%r15b, -0x390(%rbp)
     87a: 48 83 85 a0 fb ff ff 30      	addq	$0x30, -0x460(%rbp)
     882: 48 83 95 a8 fb ff ff 00      	adcq	$0x0, -0x458(%rbp)
     88a: 44 89 f8                     	movl	%r15d, %eax
<L47>:
     88d: 84 c0                        	testb	%al, %al
     88f: 4c 89 65 c0                  	movq	%r12, -0x40(%rbp)
     893: 74 4d                        	je	 <L50>
     895: 0f b6 c8                     	movzbl	%al, %ecx
     898: 48 8d 14 0b                  	leaq	(%rbx,%rcx), %rdx
     89c: 48 81 fa 80 00 00 00         	cmpq	$0x80, %rdx
     8a3: 72 3f                        	jb	 <L51>
     8a5: b2 80                        	movb	$-0x80, %dl
     8a7: 28 c2                        	subb	%al, %dl
     8a9: 44 0f b6 f2                  	movzbl	%dl, %r14d
     8ad: 4c 8d bd f0 fb ff ff         	leaq	-0x410(%rbp), %r15
     8b4: 48 8d bc 0d f0 fb ff ff      	leaq	-0x410(%rbp,%rcx), %rdi
     8bc: 48 8b 75 a8                  	movq	-0x58(%rbp), %rsi
     8c0: 4c 89 f2                     	movq	%r14, %rdx
     8c3: e8 00 00 00 00               	callq	 <L48>
		00000000000008c4:  X86_64_RELOC_BRANCH	_memcpy
<L48>:
     8c8: 48 8d bd a0 fb ff ff         	leaq	-0x460(%rbp), %rdi
     8cf: 4c 89 fe                     	movq	%r15, %rsi
     8d2: e8 00 00 00 00               	callq	 <L49>
		00000000000008d3:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L49>:
     8d7: c6 85 70 fc ff ff 00         	movb	$0x0, -0x390(%rbp)
     8de: 31 c0                        	xorl	%eax, %eax
     8e0: eb 05                        	jmp	 <L52>
<L50>:
     8e2: 31 c0                        	xorl	%eax, %eax
<L51>:
     8e4: 45 31 f6                     	xorl	%r14d, %r14d
<L52>:
     8e7: 48 8b 75 a8                  	movq	-0x58(%rbp), %rsi
     8eb: 4c 01 f6                     	addq	%r14, %rsi
     8ee: 4c 8b 65 b0                  	movq	-0x50(%rbp), %r12
     8f2: 4d 29 f4                     	subq	%r14, %r12
     8f5: 4c 8d bd f0 fb ff ff         	leaq	-0x410(%rbp), %r15
     8fc: 0f b6 c0                     	movzbl	%al, %eax
     8ff: 48 8d bc 05 f0 fb ff ff      	leaq	-0x410(%rbp,%rax), %rdi
     907: 4c 89 e2                     	movq	%r12, %rdx
     90a: e8 00 00 00 00               	callq	 <L53>
		000000000000090b:  X86_64_RELOC_BRANCH	_memcpy
<L53>:
     90f: 0f b6 bd 70 fc ff ff         	movzbl	-0x390(%rbp), %edi
     916: 4c 01 e7                     	addq	%r12, %rdi
     919: 4c 8b 6d b0                  	movq	-0x50(%rbp), %r13
     91d: 40 88 bd 70 fc ff ff         	movb	%dil, -0x390(%rbp)
     924: 48 8b 9d a8 fb ff ff         	movq	-0x458(%rbp), %rbx
     92b: 4c 03 ad a0 fb ff ff         	addq	-0x460(%rbp), %r13
     932: 48 83 d3 00                  	adcq	$0x0, %rbx
     936: 4c 89 ad a0 fb ff ff         	movq	%r13, -0x460(%rbp)
     93d: 48 89 9d a8 fb ff ff         	movq	%rbx, -0x458(%rbp)
     944: 40 84 ff                     	testb	%dil, %dil
     947: 74 46                        	je	 <L56>
     949: 40 80 ff 7f                  	cmpb	$0x7f, %dil
     94d: 72 42                        	jb	 <L57>
     94f: b0 80                        	movb	$-0x80, %al
     951: 40 28 f8                     	subb	%dil, %al
     954: 44 0f b6 e0                  	movzbl	%al, %r12d
     958: 4c 01 ff                     	addq	%r15, %rdi
     95b: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     95f: 4c 89 e2                     	movq	%r12, %rdx
     962: e8 00 00 00 00               	callq	 <L54>
		0000000000000963:  X86_64_RELOC_BRANCH	_memcpy
<L54>:
     967: 48 8d bd a0 fb ff ff         	leaq	-0x460(%rbp), %rdi
     96e: 4c 89 fe                     	movq	%r15, %rsi
     971: e8 00 00 00 00               	callq	 <L55>
		0000000000000972:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L55>:
     976: c6 85 70 fc ff ff 00         	movb	$0x0, -0x390(%rbp)
     97d: 31 ff                        	xorl	%edi, %edi
     97f: 4c 8b ad a0 fb ff ff         	movq	-0x460(%rbp), %r13
     986: 48 8b 9d a8 fb ff ff         	movq	-0x458(%rbp), %rbx
     98d: eb 05                        	jmp	 <L58>
<L56>:
     98f: 31 ff                        	xorl	%edi, %edi
<L57>:
     991: 45 31 e4                     	xorl	%r12d, %r12d
<L58>:
     994: 4a 8d 74 25 d7               	leaq	-0x29(%rbp,%r12), %rsi
     999: 41 be 01 00 00 00            	movl	$0x1, %r14d
     99f: 4d 29 e6                     	subq	%r12, %r14
     9a2: 40 0f b6 c7                  	movzbl	%dil, %eax
     9a6: 49 01 c7                     	addq	%rax, %r15
     9a9: 4c 89 ff                     	movq	%r15, %rdi
     9ac: 4c 89 f2                     	movq	%r14, %rdx
     9af: e8 00 00 00 00               	callq	 <L59>
		00000000000009b0:  X86_64_RELOC_BRANCH	_memcpy
<L59>:
     9b4: 44 00 b5 70 fc ff ff         	addb	%r14b, -0x390(%rbp)
     9bb: 49 83 c5 01                  	addq	$0x1, %r13
     9bf: 48 83 d3 00                  	adcq	$0x0, %rbx
     9c3: 48 89 9d a8 fb ff ff         	movq	%rbx, -0x458(%rbp)
     9ca: 4c 89 ad a0 fb ff ff         	movq	%r13, -0x460(%rbp)
     9d1: 48 8d bd a0 fb ff ff         	leaq	-0x460(%rbp), %rdi
     9d8: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     9df: e8 00 00 00 00               	callq	 <L60>
		00000000000009e0:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L60>:
     9e4: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x95b>
		00000000000009e7:  X86_64_RELOC_SIGNED	___anon_817
     9eb: 4c 8d b5 80 fd ff ff         	leaq	-0x280(%rbp), %r14
     9f2: ba e0 00 00 00               	movl	$0xe0, %edx
     9f7: 4c 89 f7                     	movq	%r14, %rdi
     9fa: e8 00 00 00 00               	callq	 <L61>
		00000000000009fb:  X86_64_RELOC_BRANCH	_memcpy
<L61>:
     9ff: 48 8d b5 80 fc ff ff         	leaq	-0x380(%rbp), %rsi
     a06: 4c 89 f7                     	movq	%r14, %rdi
     a09: e8 00 00 00 00               	callq	 <L62>
		0000000000000a0a:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L62>:
     a0e: 0f b6 bd 50 fe ff ff         	movzbl	-0x1b0(%rbp), %edi
     a15: 48 8b 9d 88 fd ff ff         	movq	-0x278(%rbp), %rbx
     a1c: 41 bd 80 00 00 00            	movl	$0x80, %r13d
     a22: 4c 03 ad 80 fd ff ff         	addq	-0x280(%rbp), %r13
     a29: 48 83 d3 00                  	adcq	$0x0, %rbx
     a2d: 4c 8d b5 d0 fd ff ff         	leaq	-0x230(%rbp), %r14
     a34: 4c 89 ad 80 fd ff ff         	movq	%r13, -0x280(%rbp)
     a3b: 48 89 9d 88 fd ff ff         	movq	%rbx, -0x278(%rbp)
     a42: 48 85 ff                     	testq	%rdi, %rdi
     a45: 74 49                        	je	 <L65>
     a47: 40 80 ff 50                  	cmpb	$0x50, %dil
     a4b: 72 45                        	jb	 <L66>
     a4d: 41 bf 80 00 00 00            	movl	$0x80, %r15d
     a53: 49 29 ff                     	subq	%rdi, %r15
     a56: 4c 01 f7                     	addq	%r14, %rdi
     a59: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     a60: 4c 89 fa                     	movq	%r15, %rdx
     a63: e8 00 00 00 00               	callq	 <L63>
		0000000000000a64:  X86_64_RELOC_BRANCH	_memcpy
<L63>:
     a68: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     a6f: 4c 89 f6                     	movq	%r14, %rsi
     a72: e8 00 00 00 00               	callq	 <L64>
		0000000000000a73:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L64>:
     a77: c6 85 50 fe ff ff 00         	movb	$0x0, -0x1b0(%rbp)
     a7e: 31 ff                        	xorl	%edi, %edi
     a80: 4c 8b ad 80 fd ff ff         	movq	-0x280(%rbp), %r13
     a87: 48 8b 9d 88 fd ff ff         	movq	-0x278(%rbp), %rbx
     a8e: eb 05                        	jmp	 <L67>
<L65>:
     a90: 31 ff                        	xorl	%edi, %edi
<L66>:
     a92: 45 31 ff                     	xorl	%r15d, %r15d
<L67>:
     a95: 4a 8d b4 3d f0 fe ff ff      	leaq	-0x110(%rbp,%r15), %rsi
     a9d: 41 bc 30 00 00 00            	movl	$0x30, %r12d
     aa3: 4d 29 fc                     	subq	%r15, %r12
     aa6: 40 0f b6 c7                  	movzbl	%dil, %eax
     aaa: 49 01 c6                     	addq	%rax, %r14
     aad: 4c 89 f7                     	movq	%r14, %rdi
     ab0: 4c 89 e2                     	movq	%r12, %rdx
     ab3: e8 00 00 00 00               	callq	 <L68>
		0000000000000ab4:  X86_64_RELOC_BRANCH	_memcpy
<L68>:
     ab8: 44 00 a5 50 fe ff ff         	addb	%r12b, -0x1b0(%rbp)
     abf: 49 83 c5 30                  	addq	$0x30, %r13
     ac3: 48 83 d3 00                  	adcq	$0x0, %rbx
     ac7: 48 89 9d 88 fd ff ff         	movq	%rbx, -0x278(%rbp)
     ace: 4c 89 ad 80 fd ff ff         	movq	%r13, -0x280(%rbp)
     ad5: 48 8d bd 80 fd ff ff         	leaq	-0x280(%rbp), %rdi
     adc: 4c 8d b5 10 fa ff ff         	leaq	-0x5f0(%rbp), %r14
     ae3: 4c 89 f6                     	movq	%r14, %rsi
     ae6: e8 00 00 00 00               	callq	 <L69>
		0000000000000ae7:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L69>:
     aeb: 48 8b 7d c8                  	movq	-0x38(%rbp), %rdi
     aef: 48 03 7d c0                  	addq	-0x40(%rbp), %rdi
     af3: 4c 89 f6                     	movq	%r14, %rsi
     af6: 48 8b 55 b8                  	movq	-0x48(%rbp), %rdx
     afa: e8 00 00 00 00               	callq	 <L70>
		0000000000000afb:  X86_64_RELOC_BRANCH	_memcpy
<L70>:
     aff: 48 81 c4 c8 05 00 00         	addq	$0x5c8, %rsp            ## imm = 0x5C8
     b06: 5b                           	popq	%rbx
     b07: 41 5c                        	popq	%r12
     b09: 41 5d                        	popq	%r13
     b0b: 41 5e                        	popq	%r14
     b0d: 41 5f                        	popq	%r15
     b0f: 5d                           	popq	%rbp
     b10: c3                           	retq
     b11: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
     b1b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

0000000000000b20 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
     b20: 55                           	pushq	%rbp
     b21: 48 89 e5                     	movq	%rsp, %rbp
     b24: 41 57                        	pushq	%r15
     b26: 41 56                        	pushq	%r14
     b28: 41 55                        	pushq	%r13
     b2a: 41 54                        	pushq	%r12
     b2c: 53                           	pushq	%rbx
     b2d: 48 81 ec 08 02 00 00         	subq	$0x208, %rsp            ## imm = 0x208
     b34: f3 0f 6f 06                  	movdqu	(%rsi), %xmm0
     b38: 66 0f 6f 0d 10 59 00 00      	movdqa	, %xmm1 <_audit_handshake256+0x100>
		0000000000000b3c:  X86_64_RELOC_SIGNED	__literal16
     b40: 66 0f 38 00 c1               	pshufb	%xmm1, %xmm0
     b45: 66 0f 7f 85 50 fd ff ff      	movdqa	%xmm0, -0x2b0(%rbp)
     b4d: f3 0f 6f 56 10               	movdqu	0x10(%rsi), %xmm2
     b52: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     b57: 66 0f 7f 95 60 fd ff ff      	movdqa	%xmm2, -0x2a0(%rbp)
     b5f: f3 0f 6f 56 20               	movdqu	0x20(%rsi), %xmm2
     b64: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     b69: 66 0f 7f 95 70 fd ff ff      	movdqa	%xmm2, -0x290(%rbp)
     b71: f3 0f 6f 56 30               	movdqu	0x30(%rsi), %xmm2
     b76: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     b7b: 66 0f 7f 95 80 fd ff ff      	movdqa	%xmm2, -0x280(%rbp)
     b83: f3 0f 6f 56 40               	movdqu	0x40(%rsi), %xmm2
     b88: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     b8d: 66 0f 7f 95 90 fd ff ff      	movdqa	%xmm2, -0x270(%rbp)
     b95: f3 0f 6f 56 50               	movdqu	0x50(%rsi), %xmm2
     b9a: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     b9f: 66 0f 7f 95 a0 fd ff ff      	movdqa	%xmm2, -0x260(%rbp)
     ba7: f3 0f 6f 56 60               	movdqu	0x60(%rsi), %xmm2
     bac: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     bb1: 66 0f 7f 95 b0 fd ff ff      	movdqa	%xmm2, -0x250(%rbp)
     bb9: f3 0f 6f 56 70               	movdqu	0x70(%rsi), %xmm2
     bbe: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
     bc3: 66 0f 7f 95 c0 fd ff ff      	movdqa	%xmm2, -0x240(%rbp)
     bcb: 31 c0                        	xorl	%eax, %eax
     bcd: 0f 1f 00                     	nopl	(%rax)
<L0>:
     bd0: 48 8b 8c c5 58 fd ff ff      	movq	-0x2a8(%rbp,%rax,8), %rcx
     bd8: 48 8b 94 c5 98 fd ff ff      	movq	-0x268(%rbp,%rax,8), %rdx
     be0: 48 03 94 c5 50 fd ff ff      	addq	-0x2b0(%rbp,%rax,8), %rdx
     be8: 48 89 ce                     	movq	%rcx, %rsi
     beb: 48 d1 ce                     	rorq	%rsi
     bee: 49 89 c8                     	movq	%rcx, %r8
     bf1: 49 c1 c0 38                  	rolq	$0x38, %r8
     bf5: 49 31 f0                     	xorq	%rsi, %r8
     bf8: 48 c1 e9 07                  	shrq	$0x7, %rcx
     bfc: 48 8b b4 c5 c0 fd ff ff      	movq	-0x240(%rbp,%rax,8), %rsi
     c04: 49 89 f1                     	movq	%rsi, %r9
     c07: 49 c1 c1 2d                  	rolq	$0x2d, %r9
     c0b: 4c 31 c1                     	xorq	%r8, %rcx
     c0e: 49 89 f0                     	movq	%rsi, %r8
     c11: 49 c1 c0 03                  	rolq	$0x3, %r8
     c15: 48 01 d1                     	addq	%rdx, %rcx
     c18: 4d 31 c8                     	xorq	%r9, %r8
     c1b: 48 c1 ee 06                  	shrq	$0x6, %rsi
     c1f: 4c 31 c6                     	xorq	%r8, %rsi
     c22: 48 01 ce                     	addq	%rcx, %rsi
     c25: 48 89 b4 c5 d0 fd ff ff      	movq	%rsi, -0x230(%rbp,%rax,8)
     c2d: 48 ff c0                     	incq	%rax
     c30: 48 83 f8 40                  	cmpq	$0x40, %rax
     c34: 75 9a                        	jne	 <L0>
     c36: 48 8b 47 10                  	movq	0x10(%rdi), %rax
     c3a: 48 8b 77 18                  	movq	0x18(%rdi), %rsi
     c3e: 4c 8b 47 20                  	movq	0x20(%rdi), %r8
     c42: 48 8b 4f 30                  	movq	0x30(%rdi), %rcx
     c46: 48 8b 57 38                  	movq	0x38(%rdi), %rdx
     c4a: 49 89 c9                     	movq	%rcx, %r9
     c4d: 49 c1 c1 32                  	rolq	$0x32, %r9
     c51: 4c 8b 5f 40                  	movq	0x40(%rdi), %r11
     c55: 49 89 ca                     	movq	%rcx, %r10
     c58: 49 c1 c2 2e                  	rolq	$0x2e, %r10
     c5c: 4d 31 ca                     	xorq	%r9, %r10
     c5f: 49 89 c9                     	movq	%rcx, %r9
     c62: 49 c1 c1 17                  	rolq	$0x17, %r9
     c66: 4d 31 d1                     	xorq	%r10, %r9
     c69: 4d 89 da                     	movq	%r11, %r10
     c6c: 49 31 d2                     	xorq	%rdx, %r10
     c6f: 49 21 ca                     	andq	%rcx, %r10
     c72: 4d 31 da                     	xorq	%r11, %r10
     c75: 4c 03 4f 48                  	addq	0x48(%rdi), %r9
     c79: 66 49 0f 7e c6               	movq	%xmm0, %r14
     c7e: 4d 01 d6                     	addq	%r10, %r14
     c81: 48 bb 22 ae 28 d7 98 2f 8a 42	movabsq	$0x428a2f98d728ae22, %rbx ## imm = 0x428A2F98D728AE22
     c8b: 4c 01 f3                     	addq	%r14, %rbx
     c8e: 4c 01 cb                     	addq	%r9, %rbx
     c91: 4c 8b 57 28                  	movq	0x28(%rdi), %r10
     c95: 49 89 c1                     	movq	%rax, %r9
     c98: 49 c1 c1 24                  	rolq	$0x24, %r9
     c9c: 49 01 da                     	addq	%rbx, %r10
     c9f: 49 89 c6                     	movq	%rax, %r14
     ca2: 49 c1 c6 1e                  	rolq	$0x1e, %r14
     ca6: 4d 31 ce                     	xorq	%r9, %r14
     ca9: 49 89 c7                     	movq	%rax, %r15
     cac: 49 c1 c7 19                  	rolq	$0x19, %r15
     cb0: 4d 31 f7                     	xorq	%r14, %r15
     cb3: 4d 89 c6                     	movq	%r8, %r14
     cb6: 49 09 f6                     	orq	%rsi, %r14
     cb9: 49 21 c6                     	andq	%rax, %r14
     cbc: 4d 89 c1                     	movq	%r8, %r9
     cbf: 49 21 f1                     	andq	%rsi, %r9
     cc2: 4d 09 f1                     	orq	%r14, %r9
     cc5: 4d 01 f9                     	addq	%r15, %r9
     cc8: 49 01 d9                     	addq	%rbx, %r9
     ccb: 4c 89 d3                     	movq	%r10, %rbx
     cce: 48 c1 c3 32                  	rolq	$0x32, %rbx
     cd2: 4d 89 d6                     	movq	%r10, %r14
     cd5: 49 c1 c6 2e                  	rolq	$0x2e, %r14
     cd9: 49 31 de                     	xorq	%rbx, %r14
     cdc: 4d 89 d7                     	movq	%r10, %r15
     cdf: 49 c1 c7 17                  	rolq	$0x17, %r15
     ce3: 4d 31 f7                     	xorq	%r14, %r15
     ce6: 48 89 d3                     	movq	%rdx, %rbx
     ce9: 48 31 cb                     	xorq	%rcx, %rbx
     cec: 4c 21 d3                     	andq	%r10, %rbx
     cef: 48 31 d3                     	xorq	%rdx, %rbx
     cf2: 4c 03 9d 58 fd ff ff         	addq	-0x2a8(%rbp), %r11
     cf9: 49 01 db                     	addq	%rbx, %r11
     cfc: 48 bb cd 65 ef 23 91 44 37 71	movabsq	$0x7137449123ef65cd, %rbx ## imm = 0x7137449123EF65CD
     d06: 4c 01 db                     	addq	%r11, %rbx
     d09: 4d 89 cb                     	movq	%r9, %r11
     d0c: 49 c1 c3 24                  	rolq	$0x24, %r11
     d10: 4c 01 fb                     	addq	%r15, %rbx
     d13: 4d 89 ce                     	movq	%r9, %r14
     d16: 49 c1 c6 1e                  	rolq	$0x1e, %r14
     d1a: 49 01 d8                     	addq	%rbx, %r8
     d1d: 4d 89 cf                     	movq	%r9, %r15
     d20: 49 c1 c7 19                  	rolq	$0x19, %r15
     d24: 4d 31 de                     	xorq	%r11, %r14
     d27: 4d 31 f7                     	xorq	%r14, %r15
     d2a: 49 89 f6                     	movq	%rsi, %r14
     d2d: 49 09 c6                     	orq	%rax, %r14
     d30: 4d 21 ce                     	andq	%r9, %r14
     d33: 49 89 f3                     	movq	%rsi, %r11
     d36: 49 21 c3                     	andq	%rax, %r11
     d39: 4d 09 f3                     	orq	%r14, %r11
     d3c: 4d 01 fb                     	addq	%r15, %r11
     d3f: 4d 89 c6                     	movq	%r8, %r14
     d42: 49 c1 c6 32                  	rolq	$0x32, %r14
     d46: 49 01 db                     	addq	%rbx, %r11
     d49: 4c 89 c3                     	movq	%r8, %rbx
     d4c: 48 c1 c3 2e                  	rolq	$0x2e, %rbx
     d50: 4c 31 f3                     	xorq	%r14, %rbx
     d53: 4d 89 c6                     	movq	%r8, %r14
     d56: 49 c1 c6 17                  	rolq	$0x17, %r14
     d5a: 49 31 de                     	xorq	%rbx, %r14
     d5d: 4c 89 d3                     	movq	%r10, %rbx
     d60: 48 31 cb                     	xorq	%rcx, %rbx
     d63: 4c 21 c3                     	andq	%r8, %rbx
     d66: 48 31 cb                     	xorq	%rcx, %rbx
     d69: 48 03 95 60 fd ff ff         	addq	-0x2a0(%rbp), %rdx
     d70: 48 01 da                     	addq	%rbx, %rdx
     d73: 48 bb 2f 3b 4d ec cf fb c0 b5	movabsq	$-0x4a3f043013b2c4d1, %rbx ## imm = 0xB5C0FBCFEC4D3B2F
     d7d: 48 01 d3                     	addq	%rdx, %rbx
     d80: 4c 01 f3                     	addq	%r14, %rbx
     d83: 48 01 de                     	addq	%rbx, %rsi
     d86: 4c 89 da                     	movq	%r11, %rdx
     d89: 48 c1 c2 24                  	rolq	$0x24, %rdx
     d8d: 4d 89 de                     	movq	%r11, %r14
     d90: 49 c1 c6 1e                  	rolq	$0x1e, %r14
     d94: 49 31 d6                     	xorq	%rdx, %r14
     d97: 4d 89 df                     	movq	%r11, %r15
     d9a: 49 c1 c7 19                  	rolq	$0x19, %r15
     d9e: 4d 31 f7                     	xorq	%r14, %r15
     da1: 4d 89 ce                     	movq	%r9, %r14
     da4: 49 09 c6                     	orq	%rax, %r14
     da7: 4d 21 de                     	andq	%r11, %r14
     daa: 4c 89 ca                     	movq	%r9, %rdx
     dad: 48 21 c2                     	andq	%rax, %rdx
     db0: 4c 09 f2                     	orq	%r14, %rdx
     db3: 49 89 f6                     	movq	%rsi, %r14
     db6: 49 c1 c6 32                  	rolq	$0x32, %r14
     dba: 4c 01 fa                     	addq	%r15, %rdx
     dbd: 49 89 f7                     	movq	%rsi, %r15
     dc0: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     dc4: 48 01 da                     	addq	%rbx, %rdx
     dc7: 48 89 f3                     	movq	%rsi, %rbx
     dca: 48 c1 c3 17                  	rolq	$0x17, %rbx
     dce: 4d 31 f7                     	xorq	%r14, %r15
     dd1: 4c 31 fb                     	xorq	%r15, %rbx
     dd4: 4d 89 c6                     	movq	%r8, %r14
     dd7: 4d 31 d6                     	xorq	%r10, %r14
     dda: 49 21 f6                     	andq	%rsi, %r14
     ddd: 4d 31 d6                     	xorq	%r10, %r14
     de0: 48 03 8d 68 fd ff ff         	addq	-0x298(%rbp), %rcx
     de7: 4c 01 f1                     	addq	%r14, %rcx
     dea: 49 be bc db 89 81 a5 db b5 e9	movabsq	$-0x164a245a7e762444, %r14 ## imm = 0xE9B5DBA58189DBBC
     df4: 49 01 ce                     	addq	%rcx, %r14
     df7: 49 01 de                     	addq	%rbx, %r14
     dfa: 48 89 d1                     	movq	%rdx, %rcx
     dfd: 48 c1 c1 24                  	rolq	$0x24, %rcx
     e01: 48 89 d3                     	movq	%rdx, %rbx
     e04: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
     e08: 48 31 cb                     	xorq	%rcx, %rbx
     e0b: 49 89 d7                     	movq	%rdx, %r15
     e0e: 49 c1 c7 19                  	rolq	$0x19, %r15
     e12: 49 31 df                     	xorq	%rbx, %r15
     e15: 4c 89 db                     	movq	%r11, %rbx
     e18: 4c 09 cb                     	orq	%r9, %rbx
     e1b: 48 21 d3                     	andq	%rdx, %rbx
     e1e: 4c 89 d9                     	movq	%r11, %rcx
     e21: 4c 21 c9                     	andq	%r9, %rcx
     e24: 48 09 d9                     	orq	%rbx, %rcx
     e27: 4c 01 f9                     	addq	%r15, %rcx
     e2a: 4c 01 f1                     	addq	%r14, %rcx
     e2d: 49 01 c6                     	addq	%rax, %r14
     e30: 4c 89 f3                     	movq	%r14, %rbx
     e33: 48 c1 c3 32                  	rolq	$0x32, %rbx
     e37: 4d 89 f7                     	movq	%r14, %r15
     e3a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     e3e: 49 31 df                     	xorq	%rbx, %r15
     e41: 4d 89 f4                     	movq	%r14, %r12
     e44: 49 c1 c4 17                  	rolq	$0x17, %r12
     e48: 4d 31 fc                     	xorq	%r15, %r12
     e4b: 48 89 f3                     	movq	%rsi, %rbx
     e4e: 4c 31 c3                     	xorq	%r8, %rbx
     e51: 4c 21 f3                     	andq	%r14, %rbx
     e54: 4c 03 95 70 fd ff ff         	addq	-0x290(%rbp), %r10
     e5b: 4c 31 c3                     	xorq	%r8, %rbx
     e5e: 49 01 da                     	addq	%rbx, %r10
     e61: 48 bb 38 b5 48 f3 5b c2 56 39	movabsq	$0x3956c25bf348b538, %rbx ## imm = 0x3956C25BF348B538
     e6b: 4c 01 d3                     	addq	%r10, %rbx
     e6e: 4c 01 e3                     	addq	%r12, %rbx
     e71: 49 89 ca                     	movq	%rcx, %r10
     e74: 49 c1 c2 24                  	rolq	$0x24, %r10
     e78: 49 01 d9                     	addq	%rbx, %r9
     e7b: 49 89 cf                     	movq	%rcx, %r15
     e7e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
     e82: 4d 31 d7                     	xorq	%r10, %r15
     e85: 49 89 cc                     	movq	%rcx, %r12
     e88: 49 c1 c4 19                  	rolq	$0x19, %r12
     e8c: 4d 31 fc                     	xorq	%r15, %r12
     e8f: 49 89 d7                     	movq	%rdx, %r15
     e92: 4d 09 df                     	orq	%r11, %r15
     e95: 49 21 cf                     	andq	%rcx, %r15
     e98: 49 89 d2                     	movq	%rdx, %r10
     e9b: 4d 21 da                     	andq	%r11, %r10
     e9e: 4d 09 fa                     	orq	%r15, %r10
     ea1: 4d 01 e2                     	addq	%r12, %r10
     ea4: 49 01 da                     	addq	%rbx, %r10
     ea7: 4c 89 cb                     	movq	%r9, %rbx
     eaa: 48 c1 c3 32                  	rolq	$0x32, %rbx
     eae: 4d 89 cf                     	movq	%r9, %r15
     eb1: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     eb5: 49 31 df                     	xorq	%rbx, %r15
     eb8: 4c 89 cb                     	movq	%r9, %rbx
     ebb: 48 c1 c3 17                  	rolq	$0x17, %rbx
     ebf: 4c 31 fb                     	xorq	%r15, %rbx
     ec2: 4d 89 f7                     	movq	%r14, %r15
     ec5: 49 31 f7                     	xorq	%rsi, %r15
     ec8: 4d 21 cf                     	andq	%r9, %r15
     ecb: 49 31 f7                     	xorq	%rsi, %r15
     ece: 4c 03 85 78 fd ff ff         	addq	-0x288(%rbp), %r8
     ed5: 4d 01 f8                     	addq	%r15, %r8
     ed8: 49 bf 19 d0 05 b6 f1 11 f1 59	movabsq	$0x59f111f1b605d019, %r15 ## imm = 0x59F111F1B605D019
     ee2: 4d 01 c7                     	addq	%r8, %r15
     ee5: 4d 89 d0                     	movq	%r10, %r8
     ee8: 49 c1 c0 24                  	rolq	$0x24, %r8
     eec: 49 01 df                     	addq	%rbx, %r15
     eef: 4c 89 d3                     	movq	%r10, %rbx
     ef2: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
     ef6: 4d 01 fb                     	addq	%r15, %r11
     ef9: 4d 89 d4                     	movq	%r10, %r12
     efc: 49 c1 c4 19                  	rolq	$0x19, %r12
     f00: 4c 31 c3                     	xorq	%r8, %rbx
     f03: 49 31 dc                     	xorq	%rbx, %r12
     f06: 49 89 c8                     	movq	%rcx, %r8
     f09: 49 09 d0                     	orq	%rdx, %r8
     f0c: 4d 21 d0                     	andq	%r10, %r8
     f0f: 48 89 cb                     	movq	%rcx, %rbx
     f12: 48 21 d3                     	andq	%rdx, %rbx
     f15: 4c 09 c3                     	orq	%r8, %rbx
     f18: 4c 01 e3                     	addq	%r12, %rbx
     f1b: 4d 89 d8                     	movq	%r11, %r8
     f1e: 49 c1 c0 32                  	rolq	$0x32, %r8
     f22: 4c 01 fb                     	addq	%r15, %rbx
     f25: 4d 89 df                     	movq	%r11, %r15
     f28: 49 c1 c7 2e                  	rolq	$0x2e, %r15
     f2c: 4d 31 c7                     	xorq	%r8, %r15
     f2f: 4d 89 dc                     	movq	%r11, %r12
     f32: 49 c1 c4 17                  	rolq	$0x17, %r12
     f36: 4d 31 fc                     	xorq	%r15, %r12
     f39: 4d 89 c8                     	movq	%r9, %r8
     f3c: 4d 31 f0                     	xorq	%r14, %r8
     f3f: 4d 21 d8                     	andq	%r11, %r8
     f42: 4d 31 f0                     	xorq	%r14, %r8
     f45: 48 03 b5 80 fd ff ff         	addq	-0x280(%rbp), %rsi
     f4c: 4c 01 c6                     	addq	%r8, %rsi
     f4f: 49 b8 9b 4f 19 af a4 82 3f 92	movabsq	$-0x6dc07d5b50e6b065, %r8 ## imm = 0x923F82A4AF194F9B
     f59: 49 01 f0                     	addq	%rsi, %r8
     f5c: 4d 01 e0                     	addq	%r12, %r8
     f5f: 4c 01 c2                     	addq	%r8, %rdx
     f62: 48 89 de                     	movq	%rbx, %rsi
     f65: 48 c1 c6 24                  	rolq	$0x24, %rsi
     f69: 49 89 df                     	movq	%rbx, %r15
     f6c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
     f70: 49 31 f7                     	xorq	%rsi, %r15
     f73: 49 89 dc                     	movq	%rbx, %r12
     f76: 49 c1 c4 19                  	rolq	$0x19, %r12
     f7a: 4d 31 fc                     	xorq	%r15, %r12
     f7d: 4d 89 d7                     	movq	%r10, %r15
     f80: 49 09 cf                     	orq	%rcx, %r15
     f83: 49 21 df                     	andq	%rbx, %r15
     f86: 4c 89 d6                     	movq	%r10, %rsi
     f89: 48 21 ce                     	andq	%rcx, %rsi
     f8c: 4c 09 fe                     	orq	%r15, %rsi
     f8f: 49 89 d7                     	movq	%rdx, %r15
     f92: 49 c1 c7 32                  	rolq	$0x32, %r15
     f96: 4c 01 e6                     	addq	%r12, %rsi
     f99: 49 89 d4                     	movq	%rdx, %r12
     f9c: 49 c1 c4 2e                  	rolq	$0x2e, %r12
     fa0: 4c 01 c6                     	addq	%r8, %rsi
     fa3: 49 89 d0                     	movq	%rdx, %r8
     fa6: 49 c1 c0 17                  	rolq	$0x17, %r8
     faa: 4d 31 fc                     	xorq	%r15, %r12
     fad: 4d 31 e0                     	xorq	%r12, %r8
     fb0: 4d 89 df                     	movq	%r11, %r15
     fb3: 4d 31 cf                     	xorq	%r9, %r15
     fb6: 49 21 d7                     	andq	%rdx, %r15
     fb9: 4d 31 cf                     	xorq	%r9, %r15
     fbc: 4c 03 b5 88 fd ff ff         	addq	-0x278(%rbp), %r14
     fc3: 4d 01 fe                     	addq	%r15, %r14
     fc6: 49 bf 18 81 6d da d5 5e 1c ab	movabsq	$-0x54e3a12a25927ee8, %r15 ## imm = 0xAB1C5ED5DA6D8118
     fd0: 4d 01 f7                     	addq	%r14, %r15
     fd3: 4d 01 c7                     	addq	%r8, %r15
     fd6: 4c 01 f9                     	addq	%r15, %rcx
     fd9: 49 89 f0                     	movq	%rsi, %r8
     fdc: 49 c1 c0 24                  	rolq	$0x24, %r8
     fe0: 49 89 f6                     	movq	%rsi, %r14
     fe3: 49 c1 c6 1e                  	rolq	$0x1e, %r14
     fe7: 4d 31 c6                     	xorq	%r8, %r14
     fea: 49 89 f4                     	movq	%rsi, %r12
     fed: 49 c1 c4 19                  	rolq	$0x19, %r12
     ff1: 4d 31 f4                     	xorq	%r14, %r12
     ff4: 49 89 de                     	movq	%rbx, %r14
     ff7: 4d 09 d6                     	orq	%r10, %r14
     ffa: 49 21 f6                     	andq	%rsi, %r14
     ffd: 49 89 d8                     	movq	%rbx, %r8
    1000: 4d 21 d0                     	andq	%r10, %r8
    1003: 4d 09 f0                     	orq	%r14, %r8
    1006: 4d 01 e0                     	addq	%r12, %r8
    1009: 4d 01 f8                     	addq	%r15, %r8
    100c: 49 89 ce                     	movq	%rcx, %r14
    100f: 49 c1 c6 32                  	rolq	$0x32, %r14
    1013: 49 89 cf                     	movq	%rcx, %r15
    1016: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    101a: 4d 31 f7                     	xorq	%r14, %r15
    101d: 49 89 cc                     	movq	%rcx, %r12
    1020: 49 c1 c4 17                  	rolq	$0x17, %r12
    1024: 4d 31 fc                     	xorq	%r15, %r12
    1027: 49 89 d6                     	movq	%rdx, %r14
    102a: 4d 31 de                     	xorq	%r11, %r14
    102d: 49 21 ce                     	andq	%rcx, %r14
    1030: 4c 03 8d 90 fd ff ff         	addq	-0x270(%rbp), %r9
    1037: 4d 31 de                     	xorq	%r11, %r14
    103a: 4d 01 f1                     	addq	%r14, %r9
    103d: 49 be 42 02 03 a3 98 aa 07 d8	movabsq	$-0x27f855675cfcfdbe, %r14 ## imm = 0xD807AA98A3030242
    1047: 4d 01 ce                     	addq	%r9, %r14
    104a: 4d 01 e6                     	addq	%r12, %r14
    104d: 4d 89 c1                     	movq	%r8, %r9
    1050: 49 c1 c1 24                  	rolq	$0x24, %r9
    1054: 4d 01 f2                     	addq	%r14, %r10
    1057: 4d 89 c7                     	movq	%r8, %r15
    105a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    105e: 4d 31 cf                     	xorq	%r9, %r15
    1061: 4d 89 c4                     	movq	%r8, %r12
    1064: 49 c1 c4 19                  	rolq	$0x19, %r12
    1068: 4d 31 fc                     	xorq	%r15, %r12
    106b: 49 89 f7                     	movq	%rsi, %r15
    106e: 49 09 df                     	orq	%rbx, %r15
    1071: 4d 21 c7                     	andq	%r8, %r15
    1074: 49 89 f1                     	movq	%rsi, %r9
    1077: 49 21 d9                     	andq	%rbx, %r9
    107a: 4d 09 f9                     	orq	%r15, %r9
    107d: 4d 01 e1                     	addq	%r12, %r9
    1080: 4d 01 f1                     	addq	%r14, %r9
    1083: 4d 89 d6                     	movq	%r10, %r14
    1086: 49 c1 c6 32                  	rolq	$0x32, %r14
    108a: 4d 89 d7                     	movq	%r10, %r15
    108d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1091: 4d 31 f7                     	xorq	%r14, %r15
    1094: 4d 89 d4                     	movq	%r10, %r12
    1097: 49 c1 c4 17                  	rolq	$0x17, %r12
    109b: 4d 31 fc                     	xorq	%r15, %r12
    109e: 49 89 ce                     	movq	%rcx, %r14
    10a1: 49 31 d6                     	xorq	%rdx, %r14
    10a4: 4d 21 d6                     	andq	%r10, %r14
    10a7: 49 31 d6                     	xorq	%rdx, %r14
    10aa: 4c 03 9d 98 fd ff ff         	addq	-0x268(%rbp), %r11
    10b1: 4d 01 f3                     	addq	%r14, %r11
    10b4: 49 be be 6f 70 45 01 5b 83 12	movabsq	$0x12835b0145706fbe, %r14 ## imm = 0x12835B0145706FBE
    10be: 4d 01 de                     	addq	%r11, %r14
    10c1: 4d 89 cb                     	movq	%r9, %r11
    10c4: 49 c1 c3 24                  	rolq	$0x24, %r11
    10c8: 4d 01 e6                     	addq	%r12, %r14
    10cb: 4d 89 cf                     	movq	%r9, %r15
    10ce: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    10d2: 4c 01 f3                     	addq	%r14, %rbx
    10d5: 4d 89 cc                     	movq	%r9, %r12
    10d8: 49 c1 c4 19                  	rolq	$0x19, %r12
    10dc: 4d 31 df                     	xorq	%r11, %r15
    10df: 4d 31 fc                     	xorq	%r15, %r12
    10e2: 4d 89 c7                     	movq	%r8, %r15
    10e5: 49 09 f7                     	orq	%rsi, %r15
    10e8: 4d 21 cf                     	andq	%r9, %r15
    10eb: 4d 89 c3                     	movq	%r8, %r11
    10ee: 49 21 f3                     	andq	%rsi, %r11
    10f1: 4d 09 fb                     	orq	%r15, %r11
    10f4: 4d 01 e3                     	addq	%r12, %r11
    10f7: 49 89 df                     	movq	%rbx, %r15
    10fa: 49 c1 c7 32                  	rolq	$0x32, %r15
    10fe: 4d 01 f3                     	addq	%r14, %r11
    1101: 49 89 de                     	movq	%rbx, %r14
    1104: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1108: 4d 31 fe                     	xorq	%r15, %r14
    110b: 49 89 df                     	movq	%rbx, %r15
    110e: 49 c1 c7 17                  	rolq	$0x17, %r15
    1112: 4d 31 f7                     	xorq	%r14, %r15
    1115: 4d 89 d6                     	movq	%r10, %r14
    1118: 49 31 ce                     	xorq	%rcx, %r14
    111b: 49 21 de                     	andq	%rbx, %r14
    111e: 49 31 ce                     	xorq	%rcx, %r14
    1121: 48 03 95 a0 fd ff ff         	addq	-0x260(%rbp), %rdx
    1128: 4c 01 f2                     	addq	%r14, %rdx
    112b: 49 be 8c b2 e4 4e be 85 31 24	movabsq	$0x243185be4ee4b28c, %r14 ## imm = 0x243185BE4EE4B28C
    1135: 49 01 d6                     	addq	%rdx, %r14
    1138: 4d 01 fe                     	addq	%r15, %r14
    113b: 4c 01 f6                     	addq	%r14, %rsi
    113e: 4c 89 da                     	movq	%r11, %rdx
    1141: 48 c1 c2 24                  	rolq	$0x24, %rdx
    1145: 4d 89 df                     	movq	%r11, %r15
    1148: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    114c: 49 31 d7                     	xorq	%rdx, %r15
    114f: 4d 89 dc                     	movq	%r11, %r12
    1152: 49 c1 c4 19                  	rolq	$0x19, %r12
    1156: 4d 31 fc                     	xorq	%r15, %r12
    1159: 4d 89 cf                     	movq	%r9, %r15
    115c: 4d 09 c7                     	orq	%r8, %r15
    115f: 4d 21 df                     	andq	%r11, %r15
    1162: 4c 89 ca                     	movq	%r9, %rdx
    1165: 4c 21 c2                     	andq	%r8, %rdx
    1168: 4c 09 fa                     	orq	%r15, %rdx
    116b: 49 89 f7                     	movq	%rsi, %r15
    116e: 49 c1 c7 32                  	rolq	$0x32, %r15
    1172: 4c 01 e2                     	addq	%r12, %rdx
    1175: 49 89 f4                     	movq	%rsi, %r12
    1178: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    117c: 4c 01 f2                     	addq	%r14, %rdx
    117f: 49 89 f6                     	movq	%rsi, %r14
    1182: 49 c1 c6 17                  	rolq	$0x17, %r14
    1186: 4d 31 fc                     	xorq	%r15, %r12
    1189: 4d 31 e6                     	xorq	%r12, %r14
    118c: 49 89 df                     	movq	%rbx, %r15
    118f: 4d 31 d7                     	xorq	%r10, %r15
    1192: 49 21 f7                     	andq	%rsi, %r15
    1195: 4d 31 d7                     	xorq	%r10, %r15
    1198: 48 03 8d a8 fd ff ff         	addq	-0x258(%rbp), %rcx
    119f: 4c 01 f9                     	addq	%r15, %rcx
    11a2: 49 bf e2 b4 ff d5 c3 7d 0c 55	movabsq	$0x550c7dc3d5ffb4e2, %r15 ## imm = 0x550C7DC3D5FFB4E2
    11ac: 49 01 cf                     	addq	%rcx, %r15
    11af: 4d 01 f7                     	addq	%r14, %r15
    11b2: 4d 01 f8                     	addq	%r15, %r8
    11b5: 48 89 d1                     	movq	%rdx, %rcx
    11b8: 48 c1 c1 24                  	rolq	$0x24, %rcx
    11bc: 49 89 d6                     	movq	%rdx, %r14
    11bf: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    11c3: 49 31 ce                     	xorq	%rcx, %r14
    11c6: 49 89 d4                     	movq	%rdx, %r12
    11c9: 49 c1 c4 19                  	rolq	$0x19, %r12
    11cd: 4d 31 f4                     	xorq	%r14, %r12
    11d0: 4d 89 de                     	movq	%r11, %r14
    11d3: 4d 09 ce                     	orq	%r9, %r14
    11d6: 49 21 d6                     	andq	%rdx, %r14
    11d9: 4c 89 d9                     	movq	%r11, %rcx
    11dc: 4c 21 c9                     	andq	%r9, %rcx
    11df: 4c 09 f1                     	orq	%r14, %rcx
    11e2: 4c 01 e1                     	addq	%r12, %rcx
    11e5: 4c 01 f9                     	addq	%r15, %rcx
    11e8: 4d 89 c6                     	movq	%r8, %r14
    11eb: 49 c1 c6 32                  	rolq	$0x32, %r14
    11ef: 4d 89 c7                     	movq	%r8, %r15
    11f2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    11f6: 4d 31 f7                     	xorq	%r14, %r15
    11f9: 4d 89 c4                     	movq	%r8, %r12
    11fc: 49 c1 c4 17                  	rolq	$0x17, %r12
    1200: 4d 31 fc                     	xorq	%r15, %r12
    1203: 49 89 f6                     	movq	%rsi, %r14
    1206: 49 31 de                     	xorq	%rbx, %r14
    1209: 4d 21 c6                     	andq	%r8, %r14
    120c: 4c 03 95 b0 fd ff ff         	addq	-0x250(%rbp), %r10
    1213: 49 31 de                     	xorq	%rbx, %r14
    1216: 4d 01 f2                     	addq	%r14, %r10
    1219: 49 be 6f 89 7b f2 74 5d be 72	movabsq	$0x72be5d74f27b896f, %r14 ## imm = 0x72BE5D74F27B896F
    1223: 4d 01 d6                     	addq	%r10, %r14
    1226: 4d 01 e6                     	addq	%r12, %r14
    1229: 49 89 ca                     	movq	%rcx, %r10
    122c: 49 c1 c2 24                  	rolq	$0x24, %r10
    1230: 4d 01 f1                     	addq	%r14, %r9
    1233: 49 89 cf                     	movq	%rcx, %r15
    1236: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    123a: 4d 31 d7                     	xorq	%r10, %r15
    123d: 49 89 cc                     	movq	%rcx, %r12
    1240: 49 c1 c4 19                  	rolq	$0x19, %r12
    1244: 4d 31 fc                     	xorq	%r15, %r12
    1247: 49 89 d7                     	movq	%rdx, %r15
    124a: 4d 09 df                     	orq	%r11, %r15
    124d: 49 21 cf                     	andq	%rcx, %r15
    1250: 49 89 d2                     	movq	%rdx, %r10
    1253: 4d 21 da                     	andq	%r11, %r10
    1256: 4d 09 fa                     	orq	%r15, %r10
    1259: 4d 01 e2                     	addq	%r12, %r10
    125c: 4d 01 f2                     	addq	%r14, %r10
    125f: 4d 89 ce                     	movq	%r9, %r14
    1262: 49 c1 c6 32                  	rolq	$0x32, %r14
    1266: 4d 89 cf                     	movq	%r9, %r15
    1269: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    126d: 4d 31 f7                     	xorq	%r14, %r15
    1270: 4d 89 cc                     	movq	%r9, %r12
    1273: 49 c1 c4 17                  	rolq	$0x17, %r12
    1277: 4d 31 fc                     	xorq	%r15, %r12
    127a: 4d 89 c6                     	movq	%r8, %r14
    127d: 49 31 f6                     	xorq	%rsi, %r14
    1280: 4d 21 ce                     	andq	%r9, %r14
    1283: 49 31 f6                     	xorq	%rsi, %r14
    1286: 48 03 9d b8 fd ff ff         	addq	-0x248(%rbp), %rbx
    128d: 4c 01 f3                     	addq	%r14, %rbx
    1290: 49 be b1 96 16 3b fe b1 de 80	movabsq	$-0x7f214e01c4e9694f, %r14 ## imm = 0x80DEB1FE3B1696B1
    129a: 49 01 de                     	addq	%rbx, %r14
    129d: 4c 89 d3                     	movq	%r10, %rbx
    12a0: 48 c1 c3 24                  	rolq	$0x24, %rbx
    12a4: 4d 01 e6                     	addq	%r12, %r14
    12a7: 4d 89 d7                     	movq	%r10, %r15
    12aa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    12ae: 4d 01 f3                     	addq	%r14, %r11
    12b1: 4d 89 d4                     	movq	%r10, %r12
    12b4: 49 c1 c4 19                  	rolq	$0x19, %r12
    12b8: 49 31 df                     	xorq	%rbx, %r15
    12bb: 4d 31 fc                     	xorq	%r15, %r12
    12be: 49 89 cf                     	movq	%rcx, %r15
    12c1: 49 09 d7                     	orq	%rdx, %r15
    12c4: 4d 21 d7                     	andq	%r10, %r15
    12c7: 48 89 cb                     	movq	%rcx, %rbx
    12ca: 48 21 d3                     	andq	%rdx, %rbx
    12cd: 4c 09 fb                     	orq	%r15, %rbx
    12d0: 4c 01 e3                     	addq	%r12, %rbx
    12d3: 4d 89 df                     	movq	%r11, %r15
    12d6: 49 c1 c7 32                  	rolq	$0x32, %r15
    12da: 4c 01 f3                     	addq	%r14, %rbx
    12dd: 4d 89 de                     	movq	%r11, %r14
    12e0: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    12e4: 4d 31 fe                     	xorq	%r15, %r14
    12e7: 4d 89 df                     	movq	%r11, %r15
    12ea: 49 c1 c7 17                  	rolq	$0x17, %r15
    12ee: 4d 31 f7                     	xorq	%r14, %r15
    12f1: 4d 89 ce                     	movq	%r9, %r14
    12f4: 4d 31 c6                     	xorq	%r8, %r14
    12f7: 4d 21 de                     	andq	%r11, %r14
    12fa: 4d 31 c6                     	xorq	%r8, %r14
    12fd: 48 03 b5 c0 fd ff ff         	addq	-0x240(%rbp), %rsi
    1304: 4c 01 f6                     	addq	%r14, %rsi
    1307: 49 be 35 12 c7 25 a7 06 dc 9b	movabsq	$-0x6423f958da38edcb, %r14 ## imm = 0x9BDC06A725C71235
    1311: 49 01 f6                     	addq	%rsi, %r14
    1314: 4d 01 fe                     	addq	%r15, %r14
    1317: 4c 01 f2                     	addq	%r14, %rdx
    131a: 48 89 de                     	movq	%rbx, %rsi
    131d: 48 c1 c6 24                  	rolq	$0x24, %rsi
    1321: 49 89 df                     	movq	%rbx, %r15
    1324: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1328: 49 31 f7                     	xorq	%rsi, %r15
    132b: 49 89 dc                     	movq	%rbx, %r12
    132e: 49 c1 c4 19                  	rolq	$0x19, %r12
    1332: 4d 31 fc                     	xorq	%r15, %r12
    1335: 4d 89 d7                     	movq	%r10, %r15
    1338: 49 09 cf                     	orq	%rcx, %r15
    133b: 49 21 df                     	andq	%rbx, %r15
    133e: 4c 89 d6                     	movq	%r10, %rsi
    1341: 48 21 ce                     	andq	%rcx, %rsi
    1344: 4c 09 fe                     	orq	%r15, %rsi
    1347: 49 89 d7                     	movq	%rdx, %r15
    134a: 49 c1 c7 32                  	rolq	$0x32, %r15
    134e: 4c 01 e6                     	addq	%r12, %rsi
    1351: 49 89 d4                     	movq	%rdx, %r12
    1354: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1358: 4c 01 f6                     	addq	%r14, %rsi
    135b: 49 89 d6                     	movq	%rdx, %r14
    135e: 49 c1 c6 17                  	rolq	$0x17, %r14
    1362: 4d 31 fc                     	xorq	%r15, %r12
    1365: 4d 31 e6                     	xorq	%r12, %r14
    1368: 4d 89 df                     	movq	%r11, %r15
    136b: 4d 31 cf                     	xorq	%r9, %r15
    136e: 49 21 d7                     	andq	%rdx, %r15
    1371: 4d 31 cf                     	xorq	%r9, %r15
    1374: 4c 03 85 c8 fd ff ff         	addq	-0x238(%rbp), %r8
    137b: 4d 01 f8                     	addq	%r15, %r8
    137e: 49 bf 94 26 69 cf 74 f1 9b c1	movabsq	$-0x3e640e8b3096d96c, %r15 ## imm = 0xC19BF174CF692694
    1388: 4d 01 c7                     	addq	%r8, %r15
    138b: 4d 01 f7                     	addq	%r14, %r15
    138e: 4c 01 f9                     	addq	%r15, %rcx
    1391: 49 89 f0                     	movq	%rsi, %r8
    1394: 49 c1 c0 24                  	rolq	$0x24, %r8
    1398: 49 89 f6                     	movq	%rsi, %r14
    139b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    139f: 4d 31 c6                     	xorq	%r8, %r14
    13a2: 49 89 f4                     	movq	%rsi, %r12
    13a5: 49 c1 c4 19                  	rolq	$0x19, %r12
    13a9: 4d 31 f4                     	xorq	%r14, %r12
    13ac: 49 89 de                     	movq	%rbx, %r14
    13af: 4d 09 d6                     	orq	%r10, %r14
    13b2: 49 21 f6                     	andq	%rsi, %r14
    13b5: 49 89 d8                     	movq	%rbx, %r8
    13b8: 4d 21 d0                     	andq	%r10, %r8
    13bb: 4d 09 f0                     	orq	%r14, %r8
    13be: 4d 01 e0                     	addq	%r12, %r8
    13c1: 4d 01 f8                     	addq	%r15, %r8
    13c4: 49 89 ce                     	movq	%rcx, %r14
    13c7: 49 c1 c6 32                  	rolq	$0x32, %r14
    13cb: 49 89 cf                     	movq	%rcx, %r15
    13ce: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    13d2: 4d 31 f7                     	xorq	%r14, %r15
    13d5: 49 89 cc                     	movq	%rcx, %r12
    13d8: 49 c1 c4 17                  	rolq	$0x17, %r12
    13dc: 4d 31 fc                     	xorq	%r15, %r12
    13df: 49 89 d6                     	movq	%rdx, %r14
    13e2: 4d 31 de                     	xorq	%r11, %r14
    13e5: 49 21 ce                     	andq	%rcx, %r14
    13e8: 4c 03 8d d0 fd ff ff         	addq	-0x230(%rbp), %r9
    13ef: 4d 31 de                     	xorq	%r11, %r14
    13f2: 4d 01 f1                     	addq	%r14, %r9
    13f5: 49 be d2 4a f1 9e c1 69 9b e4	movabsq	$-0x1b64963e610eb52e, %r14 ## imm = 0xE49B69C19EF14AD2
    13ff: 4d 01 ce                     	addq	%r9, %r14
    1402: 4d 01 e6                     	addq	%r12, %r14
    1405: 4d 89 c1                     	movq	%r8, %r9
    1408: 49 c1 c1 24                  	rolq	$0x24, %r9
    140c: 4d 01 f2                     	addq	%r14, %r10
    140f: 4d 89 c7                     	movq	%r8, %r15
    1412: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1416: 4d 31 cf                     	xorq	%r9, %r15
    1419: 4d 89 c4                     	movq	%r8, %r12
    141c: 49 c1 c4 19                  	rolq	$0x19, %r12
    1420: 4d 31 fc                     	xorq	%r15, %r12
    1423: 49 89 f7                     	movq	%rsi, %r15
    1426: 49 09 df                     	orq	%rbx, %r15
    1429: 4d 21 c7                     	andq	%r8, %r15
    142c: 49 89 f1                     	movq	%rsi, %r9
    142f: 49 21 d9                     	andq	%rbx, %r9
    1432: 4d 09 f9                     	orq	%r15, %r9
    1435: 4d 01 e1                     	addq	%r12, %r9
    1438: 4d 01 f1                     	addq	%r14, %r9
    143b: 4d 89 d6                     	movq	%r10, %r14
    143e: 49 c1 c6 32                  	rolq	$0x32, %r14
    1442: 4d 89 d7                     	movq	%r10, %r15
    1445: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1449: 4d 31 f7                     	xorq	%r14, %r15
    144c: 4d 89 d4                     	movq	%r10, %r12
    144f: 49 c1 c4 17                  	rolq	$0x17, %r12
    1453: 4d 31 fc                     	xorq	%r15, %r12
    1456: 49 89 ce                     	movq	%rcx, %r14
    1459: 49 31 d6                     	xorq	%rdx, %r14
    145c: 4d 21 d6                     	andq	%r10, %r14
    145f: 49 31 d6                     	xorq	%rdx, %r14
    1462: 4c 03 9d d8 fd ff ff         	addq	-0x228(%rbp), %r11
    1469: 4d 01 f3                     	addq	%r14, %r11
    146c: 49 be e3 25 4f 38 86 47 be ef	movabsq	$-0x1041b879c7b0da1d, %r14 ## imm = 0xEFBE4786384F25E3
    1476: 4d 01 de                     	addq	%r11, %r14
    1479: 4d 89 cb                     	movq	%r9, %r11
    147c: 49 c1 c3 24                  	rolq	$0x24, %r11
    1480: 4d 01 e6                     	addq	%r12, %r14
    1483: 4d 89 cf                     	movq	%r9, %r15
    1486: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    148a: 4c 01 f3                     	addq	%r14, %rbx
    148d: 4d 89 cc                     	movq	%r9, %r12
    1490: 49 c1 c4 19                  	rolq	$0x19, %r12
    1494: 4d 31 df                     	xorq	%r11, %r15
    1497: 4d 31 fc                     	xorq	%r15, %r12
    149a: 4d 89 c7                     	movq	%r8, %r15
    149d: 49 09 f7                     	orq	%rsi, %r15
    14a0: 4d 21 cf                     	andq	%r9, %r15
    14a3: 4d 89 c3                     	movq	%r8, %r11
    14a6: 49 21 f3                     	andq	%rsi, %r11
    14a9: 4d 09 fb                     	orq	%r15, %r11
    14ac: 4d 01 e3                     	addq	%r12, %r11
    14af: 49 89 df                     	movq	%rbx, %r15
    14b2: 49 c1 c7 32                  	rolq	$0x32, %r15
    14b6: 4d 01 f3                     	addq	%r14, %r11
    14b9: 49 89 de                     	movq	%rbx, %r14
    14bc: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    14c0: 4d 31 fe                     	xorq	%r15, %r14
    14c3: 49 89 df                     	movq	%rbx, %r15
    14c6: 49 c1 c7 17                  	rolq	$0x17, %r15
    14ca: 4d 31 f7                     	xorq	%r14, %r15
    14cd: 4d 89 d6                     	movq	%r10, %r14
    14d0: 49 31 ce                     	xorq	%rcx, %r14
    14d3: 49 21 de                     	andq	%rbx, %r14
    14d6: 49 31 ce                     	xorq	%rcx, %r14
    14d9: 48 03 95 e0 fd ff ff         	addq	-0x220(%rbp), %rdx
    14e0: 4c 01 f2                     	addq	%r14, %rdx
    14e3: 49 be b5 d5 8c 8b c6 9d c1 0f	movabsq	$0xfc19dc68b8cd5b5, %r14 ## imm = 0xFC19DC68B8CD5B5
    14ed: 49 01 d6                     	addq	%rdx, %r14
    14f0: 4d 01 fe                     	addq	%r15, %r14
    14f3: 4c 01 f6                     	addq	%r14, %rsi
    14f6: 4c 89 da                     	movq	%r11, %rdx
    14f9: 48 c1 c2 24                  	rolq	$0x24, %rdx
    14fd: 4d 89 df                     	movq	%r11, %r15
    1500: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1504: 49 31 d7                     	xorq	%rdx, %r15
    1507: 4d 89 dc                     	movq	%r11, %r12
    150a: 49 c1 c4 19                  	rolq	$0x19, %r12
    150e: 4d 31 fc                     	xorq	%r15, %r12
    1511: 4d 89 cf                     	movq	%r9, %r15
    1514: 4d 09 c7                     	orq	%r8, %r15
    1517: 4d 21 df                     	andq	%r11, %r15
    151a: 4c 89 ca                     	movq	%r9, %rdx
    151d: 4c 21 c2                     	andq	%r8, %rdx
    1520: 4c 09 fa                     	orq	%r15, %rdx
    1523: 49 89 f7                     	movq	%rsi, %r15
    1526: 49 c1 c7 32                  	rolq	$0x32, %r15
    152a: 4c 01 e2                     	addq	%r12, %rdx
    152d: 49 89 f4                     	movq	%rsi, %r12
    1530: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1534: 4c 01 f2                     	addq	%r14, %rdx
    1537: 49 89 f6                     	movq	%rsi, %r14
    153a: 49 c1 c6 17                  	rolq	$0x17, %r14
    153e: 4d 31 fc                     	xorq	%r15, %r12
    1541: 4d 31 e6                     	xorq	%r12, %r14
    1544: 49 89 df                     	movq	%rbx, %r15
    1547: 4d 31 d7                     	xorq	%r10, %r15
    154a: 49 21 f7                     	andq	%rsi, %r15
    154d: 4d 31 d7                     	xorq	%r10, %r15
    1550: 48 03 8d e8 fd ff ff         	addq	-0x218(%rbp), %rcx
    1557: 4c 01 f9                     	addq	%r15, %rcx
    155a: 49 bf 65 9c ac 77 cc a1 0c 24	movabsq	$0x240ca1cc77ac9c65, %r15 ## imm = 0x240CA1CC77AC9C65
    1564: 49 01 cf                     	addq	%rcx, %r15
    1567: 4d 01 f7                     	addq	%r14, %r15
    156a: 4d 01 f8                     	addq	%r15, %r8
    156d: 48 89 d1                     	movq	%rdx, %rcx
    1570: 48 c1 c1 24                  	rolq	$0x24, %rcx
    1574: 49 89 d6                     	movq	%rdx, %r14
    1577: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    157b: 49 31 ce                     	xorq	%rcx, %r14
    157e: 49 89 d4                     	movq	%rdx, %r12
    1581: 49 c1 c4 19                  	rolq	$0x19, %r12
    1585: 4d 31 f4                     	xorq	%r14, %r12
    1588: 4d 89 de                     	movq	%r11, %r14
    158b: 4d 09 ce                     	orq	%r9, %r14
    158e: 49 21 d6                     	andq	%rdx, %r14
    1591: 4c 89 d9                     	movq	%r11, %rcx
    1594: 4c 21 c9                     	andq	%r9, %rcx
    1597: 4c 09 f1                     	orq	%r14, %rcx
    159a: 4c 01 e1                     	addq	%r12, %rcx
    159d: 4c 01 f9                     	addq	%r15, %rcx
    15a0: 4d 89 c6                     	movq	%r8, %r14
    15a3: 49 c1 c6 32                  	rolq	$0x32, %r14
    15a7: 4d 89 c7                     	movq	%r8, %r15
    15aa: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    15ae: 4d 31 f7                     	xorq	%r14, %r15
    15b1: 4d 89 c4                     	movq	%r8, %r12
    15b4: 49 c1 c4 17                  	rolq	$0x17, %r12
    15b8: 4d 31 fc                     	xorq	%r15, %r12
    15bb: 49 89 f6                     	movq	%rsi, %r14
    15be: 49 31 de                     	xorq	%rbx, %r14
    15c1: 4d 21 c6                     	andq	%r8, %r14
    15c4: 4c 03 95 f0 fd ff ff         	addq	-0x210(%rbp), %r10
    15cb: 49 31 de                     	xorq	%rbx, %r14
    15ce: 4d 01 f2                     	addq	%r14, %r10
    15d1: 49 be 75 02 2b 59 6f 2c e9 2d	movabsq	$0x2de92c6f592b0275, %r14 ## imm = 0x2DE92C6F592B0275
    15db: 4d 01 d6                     	addq	%r10, %r14
    15de: 4d 01 e6                     	addq	%r12, %r14
    15e1: 49 89 ca                     	movq	%rcx, %r10
    15e4: 49 c1 c2 24                  	rolq	$0x24, %r10
    15e8: 4d 01 f1                     	addq	%r14, %r9
    15eb: 49 89 cf                     	movq	%rcx, %r15
    15ee: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    15f2: 4d 31 d7                     	xorq	%r10, %r15
    15f5: 49 89 cc                     	movq	%rcx, %r12
    15f8: 49 c1 c4 19                  	rolq	$0x19, %r12
    15fc: 4d 31 fc                     	xorq	%r15, %r12
    15ff: 49 89 d7                     	movq	%rdx, %r15
    1602: 4d 09 df                     	orq	%r11, %r15
    1605: 49 21 cf                     	andq	%rcx, %r15
    1608: 49 89 d2                     	movq	%rdx, %r10
    160b: 4d 21 da                     	andq	%r11, %r10
    160e: 4d 09 fa                     	orq	%r15, %r10
    1611: 4d 01 e2                     	addq	%r12, %r10
    1614: 4d 01 f2                     	addq	%r14, %r10
    1617: 4d 89 ce                     	movq	%r9, %r14
    161a: 49 c1 c6 32                  	rolq	$0x32, %r14
    161e: 4d 89 cf                     	movq	%r9, %r15
    1621: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1625: 4d 31 f7                     	xorq	%r14, %r15
    1628: 4d 89 cc                     	movq	%r9, %r12
    162b: 49 c1 c4 17                  	rolq	$0x17, %r12
    162f: 4d 31 fc                     	xorq	%r15, %r12
    1632: 4d 89 c6                     	movq	%r8, %r14
    1635: 49 31 f6                     	xorq	%rsi, %r14
    1638: 4d 21 ce                     	andq	%r9, %r14
    163b: 49 31 f6                     	xorq	%rsi, %r14
    163e: 48 03 9d f8 fd ff ff         	addq	-0x208(%rbp), %rbx
    1645: 4c 01 f3                     	addq	%r14, %rbx
    1648: 49 be 83 e4 a6 6e aa 84 74 4a	movabsq	$0x4a7484aa6ea6e483, %r14 ## imm = 0x4A7484AA6EA6E483
    1652: 49 01 de                     	addq	%rbx, %r14
    1655: 4c 89 d3                     	movq	%r10, %rbx
    1658: 48 c1 c3 24                  	rolq	$0x24, %rbx
    165c: 4d 01 e6                     	addq	%r12, %r14
    165f: 4d 89 d7                     	movq	%r10, %r15
    1662: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1666: 4d 01 f3                     	addq	%r14, %r11
    1669: 4d 89 d4                     	movq	%r10, %r12
    166c: 49 c1 c4 19                  	rolq	$0x19, %r12
    1670: 49 31 df                     	xorq	%rbx, %r15
    1673: 4d 31 fc                     	xorq	%r15, %r12
    1676: 49 89 cf                     	movq	%rcx, %r15
    1679: 49 09 d7                     	orq	%rdx, %r15
    167c: 4d 21 d7                     	andq	%r10, %r15
    167f: 48 89 cb                     	movq	%rcx, %rbx
    1682: 48 21 d3                     	andq	%rdx, %rbx
    1685: 4c 09 fb                     	orq	%r15, %rbx
    1688: 4c 01 e3                     	addq	%r12, %rbx
    168b: 4d 89 df                     	movq	%r11, %r15
    168e: 49 c1 c7 32                  	rolq	$0x32, %r15
    1692: 4c 01 f3                     	addq	%r14, %rbx
    1695: 4d 89 de                     	movq	%r11, %r14
    1698: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    169c: 4d 31 fe                     	xorq	%r15, %r14
    169f: 4d 89 df                     	movq	%r11, %r15
    16a2: 49 c1 c7 17                  	rolq	$0x17, %r15
    16a6: 4d 31 f7                     	xorq	%r14, %r15
    16a9: 4d 89 ce                     	movq	%r9, %r14
    16ac: 4d 31 c6                     	xorq	%r8, %r14
    16af: 4d 21 de                     	andq	%r11, %r14
    16b2: 4d 31 c6                     	xorq	%r8, %r14
    16b5: 48 03 b5 00 fe ff ff         	addq	-0x200(%rbp), %rsi
    16bc: 4c 01 f6                     	addq	%r14, %rsi
    16bf: 49 be d4 fb 41 bd dc a9 b0 5c	movabsq	$0x5cb0a9dcbd41fbd4, %r14 ## imm = 0x5CB0A9DCBD41FBD4
    16c9: 49 01 f6                     	addq	%rsi, %r14
    16cc: 4d 01 fe                     	addq	%r15, %r14
    16cf: 4c 01 f2                     	addq	%r14, %rdx
    16d2: 48 89 de                     	movq	%rbx, %rsi
    16d5: 48 c1 c6 24                  	rolq	$0x24, %rsi
    16d9: 49 89 df                     	movq	%rbx, %r15
    16dc: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    16e0: 49 31 f7                     	xorq	%rsi, %r15
    16e3: 49 89 dc                     	movq	%rbx, %r12
    16e6: 49 c1 c4 19                  	rolq	$0x19, %r12
    16ea: 4d 31 fc                     	xorq	%r15, %r12
    16ed: 4d 89 d7                     	movq	%r10, %r15
    16f0: 49 09 cf                     	orq	%rcx, %r15
    16f3: 49 21 df                     	andq	%rbx, %r15
    16f6: 4c 89 d6                     	movq	%r10, %rsi
    16f9: 48 21 ce                     	andq	%rcx, %rsi
    16fc: 4c 09 fe                     	orq	%r15, %rsi
    16ff: 49 89 d7                     	movq	%rdx, %r15
    1702: 49 c1 c7 32                  	rolq	$0x32, %r15
    1706: 4c 01 e6                     	addq	%r12, %rsi
    1709: 49 89 d4                     	movq	%rdx, %r12
    170c: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1710: 4c 01 f6                     	addq	%r14, %rsi
    1713: 49 89 d6                     	movq	%rdx, %r14
    1716: 49 c1 c6 17                  	rolq	$0x17, %r14
    171a: 4d 31 fc                     	xorq	%r15, %r12
    171d: 4d 31 e6                     	xorq	%r12, %r14
    1720: 4d 89 df                     	movq	%r11, %r15
    1723: 4d 31 cf                     	xorq	%r9, %r15
    1726: 49 21 d7                     	andq	%rdx, %r15
    1729: 4d 31 cf                     	xorq	%r9, %r15
    172c: 4c 03 85 08 fe ff ff         	addq	-0x1f8(%rbp), %r8
    1733: 4d 01 f8                     	addq	%r15, %r8
    1736: 49 bf b5 53 11 83 da 88 f9 76	movabsq	$0x76f988da831153b5, %r15 ## imm = 0x76F988DA831153B5
    1740: 4d 01 c7                     	addq	%r8, %r15
    1743: 4d 01 f7                     	addq	%r14, %r15
    1746: 4c 01 f9                     	addq	%r15, %rcx
    1749: 49 89 f0                     	movq	%rsi, %r8
    174c: 49 c1 c0 24                  	rolq	$0x24, %r8
    1750: 49 89 f6                     	movq	%rsi, %r14
    1753: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1757: 4d 31 c6                     	xorq	%r8, %r14
    175a: 49 89 f4                     	movq	%rsi, %r12
    175d: 49 c1 c4 19                  	rolq	$0x19, %r12
    1761: 4d 31 f4                     	xorq	%r14, %r12
    1764: 49 89 de                     	movq	%rbx, %r14
    1767: 4d 09 d6                     	orq	%r10, %r14
    176a: 49 21 f6                     	andq	%rsi, %r14
    176d: 49 89 d8                     	movq	%rbx, %r8
    1770: 4d 21 d0                     	andq	%r10, %r8
    1773: 4d 09 f0                     	orq	%r14, %r8
    1776: 4d 01 e0                     	addq	%r12, %r8
    1779: 4d 01 f8                     	addq	%r15, %r8
    177c: 49 89 ce                     	movq	%rcx, %r14
    177f: 49 c1 c6 32                  	rolq	$0x32, %r14
    1783: 49 89 cf                     	movq	%rcx, %r15
    1786: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    178a: 4d 31 f7                     	xorq	%r14, %r15
    178d: 49 89 cc                     	movq	%rcx, %r12
    1790: 49 c1 c4 17                  	rolq	$0x17, %r12
    1794: 4d 31 fc                     	xorq	%r15, %r12
    1797: 49 89 d6                     	movq	%rdx, %r14
    179a: 4d 31 de                     	xorq	%r11, %r14
    179d: 49 21 ce                     	andq	%rcx, %r14
    17a0: 4c 03 8d 10 fe ff ff         	addq	-0x1f0(%rbp), %r9
    17a7: 4d 31 de                     	xorq	%r11, %r14
    17aa: 4d 01 f1                     	addq	%r14, %r9
    17ad: 49 be ab df 66 ee 52 51 3e 98	movabsq	$-0x67c1aead11992055, %r14 ## imm = 0x983E5152EE66DFAB
    17b7: 4d 01 ce                     	addq	%r9, %r14
    17ba: 4d 01 e6                     	addq	%r12, %r14
    17bd: 4d 89 c1                     	movq	%r8, %r9
    17c0: 49 c1 c1 24                  	rolq	$0x24, %r9
    17c4: 4d 01 f2                     	addq	%r14, %r10
    17c7: 4d 89 c7                     	movq	%r8, %r15
    17ca: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    17ce: 4d 31 cf                     	xorq	%r9, %r15
    17d1: 4d 89 c4                     	movq	%r8, %r12
    17d4: 49 c1 c4 19                  	rolq	$0x19, %r12
    17d8: 4d 31 fc                     	xorq	%r15, %r12
    17db: 49 89 f7                     	movq	%rsi, %r15
    17de: 49 09 df                     	orq	%rbx, %r15
    17e1: 4d 21 c7                     	andq	%r8, %r15
    17e4: 49 89 f1                     	movq	%rsi, %r9
    17e7: 49 21 d9                     	andq	%rbx, %r9
    17ea: 4d 09 f9                     	orq	%r15, %r9
    17ed: 4d 01 e1                     	addq	%r12, %r9
    17f0: 4d 01 f1                     	addq	%r14, %r9
    17f3: 4d 89 d6                     	movq	%r10, %r14
    17f6: 49 c1 c6 32                  	rolq	$0x32, %r14
    17fa: 4d 89 d7                     	movq	%r10, %r15
    17fd: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1801: 4d 31 f7                     	xorq	%r14, %r15
    1804: 4d 89 d4                     	movq	%r10, %r12
    1807: 49 c1 c4 17                  	rolq	$0x17, %r12
    180b: 4d 31 fc                     	xorq	%r15, %r12
    180e: 49 89 ce                     	movq	%rcx, %r14
    1811: 49 31 d6                     	xorq	%rdx, %r14
    1814: 4d 21 d6                     	andq	%r10, %r14
    1817: 49 31 d6                     	xorq	%rdx, %r14
    181a: 4c 03 9d 18 fe ff ff         	addq	-0x1e8(%rbp), %r11
    1821: 4d 01 f3                     	addq	%r14, %r11
    1824: 49 be 10 32 b4 2d 6d c6 31 a8	movabsq	$-0x57ce3992d24bcdf0, %r14 ## imm = 0xA831C66D2DB43210
    182e: 4d 01 de                     	addq	%r11, %r14
    1831: 4d 89 cb                     	movq	%r9, %r11
    1834: 49 c1 c3 24                  	rolq	$0x24, %r11
    1838: 4d 01 e6                     	addq	%r12, %r14
    183b: 4d 89 cf                     	movq	%r9, %r15
    183e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1842: 4c 01 f3                     	addq	%r14, %rbx
    1845: 4d 89 cc                     	movq	%r9, %r12
    1848: 49 c1 c4 19                  	rolq	$0x19, %r12
    184c: 4d 31 df                     	xorq	%r11, %r15
    184f: 4d 31 fc                     	xorq	%r15, %r12
    1852: 4d 89 c7                     	movq	%r8, %r15
    1855: 49 09 f7                     	orq	%rsi, %r15
    1858: 4d 21 cf                     	andq	%r9, %r15
    185b: 4d 89 c3                     	movq	%r8, %r11
    185e: 49 21 f3                     	andq	%rsi, %r11
    1861: 4d 09 fb                     	orq	%r15, %r11
    1864: 4d 01 e3                     	addq	%r12, %r11
    1867: 49 89 df                     	movq	%rbx, %r15
    186a: 49 c1 c7 32                  	rolq	$0x32, %r15
    186e: 4d 01 f3                     	addq	%r14, %r11
    1871: 49 89 de                     	movq	%rbx, %r14
    1874: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1878: 4d 31 fe                     	xorq	%r15, %r14
    187b: 49 89 df                     	movq	%rbx, %r15
    187e: 49 c1 c7 17                  	rolq	$0x17, %r15
    1882: 4d 31 f7                     	xorq	%r14, %r15
    1885: 4d 89 d6                     	movq	%r10, %r14
    1888: 49 31 ce                     	xorq	%rcx, %r14
    188b: 49 21 de                     	andq	%rbx, %r14
    188e: 49 31 ce                     	xorq	%rcx, %r14
    1891: 48 03 95 20 fe ff ff         	addq	-0x1e0(%rbp), %rdx
    1898: 4c 01 f2                     	addq	%r14, %rdx
    189b: 49 be 3f 21 fb 98 c8 27 03 b0	movabsq	$-0x4ffcd8376704dec1, %r14 ## imm = 0xB00327C898FB213F
    18a5: 49 01 d6                     	addq	%rdx, %r14
    18a8: 4d 01 fe                     	addq	%r15, %r14
    18ab: 4c 01 f6                     	addq	%r14, %rsi
    18ae: 4c 89 da                     	movq	%r11, %rdx
    18b1: 48 c1 c2 24                  	rolq	$0x24, %rdx
    18b5: 4d 89 df                     	movq	%r11, %r15
    18b8: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    18bc: 49 31 d7                     	xorq	%rdx, %r15
    18bf: 4d 89 dc                     	movq	%r11, %r12
    18c2: 49 c1 c4 19                  	rolq	$0x19, %r12
    18c6: 4d 31 fc                     	xorq	%r15, %r12
    18c9: 4d 89 cf                     	movq	%r9, %r15
    18cc: 4d 09 c7                     	orq	%r8, %r15
    18cf: 4d 21 df                     	andq	%r11, %r15
    18d2: 4c 89 ca                     	movq	%r9, %rdx
    18d5: 4c 21 c2                     	andq	%r8, %rdx
    18d8: 4c 09 fa                     	orq	%r15, %rdx
    18db: 49 89 f7                     	movq	%rsi, %r15
    18de: 49 c1 c7 32                  	rolq	$0x32, %r15
    18e2: 4c 01 e2                     	addq	%r12, %rdx
    18e5: 49 89 f4                     	movq	%rsi, %r12
    18e8: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    18ec: 4c 01 f2                     	addq	%r14, %rdx
    18ef: 49 89 f6                     	movq	%rsi, %r14
    18f2: 49 c1 c6 17                  	rolq	$0x17, %r14
    18f6: 4d 31 fc                     	xorq	%r15, %r12
    18f9: 4d 31 e6                     	xorq	%r12, %r14
    18fc: 49 89 df                     	movq	%rbx, %r15
    18ff: 4d 31 d7                     	xorq	%r10, %r15
    1902: 49 21 f7                     	andq	%rsi, %r15
    1905: 4d 31 d7                     	xorq	%r10, %r15
    1908: 48 03 8d 28 fe ff ff         	addq	-0x1d8(%rbp), %rcx
    190f: 4c 01 f9                     	addq	%r15, %rcx
    1912: 49 bf e4 0e ef be c7 7f 59 bf	movabsq	$-0x40a680384110f11c, %r15 ## imm = 0xBF597FC7BEEF0EE4
    191c: 49 01 cf                     	addq	%rcx, %r15
    191f: 4d 01 f7                     	addq	%r14, %r15
    1922: 4d 01 f8                     	addq	%r15, %r8
    1925: 48 89 d1                     	movq	%rdx, %rcx
    1928: 48 c1 c1 24                  	rolq	$0x24, %rcx
    192c: 49 89 d6                     	movq	%rdx, %r14
    192f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1933: 49 31 ce                     	xorq	%rcx, %r14
    1936: 49 89 d4                     	movq	%rdx, %r12
    1939: 49 c1 c4 19                  	rolq	$0x19, %r12
    193d: 4d 31 f4                     	xorq	%r14, %r12
    1940: 4d 89 de                     	movq	%r11, %r14
    1943: 4d 09 ce                     	orq	%r9, %r14
    1946: 49 21 d6                     	andq	%rdx, %r14
    1949: 4c 89 d9                     	movq	%r11, %rcx
    194c: 4c 21 c9                     	andq	%r9, %rcx
    194f: 4c 09 f1                     	orq	%r14, %rcx
    1952: 4c 01 e1                     	addq	%r12, %rcx
    1955: 4c 01 f9                     	addq	%r15, %rcx
    1958: 4d 89 c6                     	movq	%r8, %r14
    195b: 49 c1 c6 32                  	rolq	$0x32, %r14
    195f: 4d 89 c7                     	movq	%r8, %r15
    1962: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1966: 4d 31 f7                     	xorq	%r14, %r15
    1969: 4d 89 c4                     	movq	%r8, %r12
    196c: 49 c1 c4 17                  	rolq	$0x17, %r12
    1970: 4d 31 fc                     	xorq	%r15, %r12
    1973: 49 89 f6                     	movq	%rsi, %r14
    1976: 49 31 de                     	xorq	%rbx, %r14
    1979: 4d 21 c6                     	andq	%r8, %r14
    197c: 4c 03 95 30 fe ff ff         	addq	-0x1d0(%rbp), %r10
    1983: 49 31 de                     	xorq	%rbx, %r14
    1986: 4d 01 f2                     	addq	%r14, %r10
    1989: 49 be c2 8f a8 3d f3 0b e0 c6	movabsq	$-0x391ff40cc257703e, %r14 ## imm = 0xC6E00BF33DA88FC2
    1993: 4d 01 d6                     	addq	%r10, %r14
    1996: 4d 01 e6                     	addq	%r12, %r14
    1999: 49 89 ca                     	movq	%rcx, %r10
    199c: 49 c1 c2 24                  	rolq	$0x24, %r10
    19a0: 4d 01 f1                     	addq	%r14, %r9
    19a3: 49 89 cf                     	movq	%rcx, %r15
    19a6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    19aa: 4d 31 d7                     	xorq	%r10, %r15
    19ad: 49 89 cc                     	movq	%rcx, %r12
    19b0: 49 c1 c4 19                  	rolq	$0x19, %r12
    19b4: 4d 31 fc                     	xorq	%r15, %r12
    19b7: 49 89 d7                     	movq	%rdx, %r15
    19ba: 4d 09 df                     	orq	%r11, %r15
    19bd: 49 21 cf                     	andq	%rcx, %r15
    19c0: 49 89 d2                     	movq	%rdx, %r10
    19c3: 4d 21 da                     	andq	%r11, %r10
    19c6: 4d 09 fa                     	orq	%r15, %r10
    19c9: 4d 01 e2                     	addq	%r12, %r10
    19cc: 4d 01 f2                     	addq	%r14, %r10
    19cf: 4d 89 ce                     	movq	%r9, %r14
    19d2: 49 c1 c6 32                  	rolq	$0x32, %r14
    19d6: 4d 89 cf                     	movq	%r9, %r15
    19d9: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    19dd: 4d 31 f7                     	xorq	%r14, %r15
    19e0: 4d 89 cc                     	movq	%r9, %r12
    19e3: 49 c1 c4 17                  	rolq	$0x17, %r12
    19e7: 4d 31 fc                     	xorq	%r15, %r12
    19ea: 4d 89 c6                     	movq	%r8, %r14
    19ed: 49 31 f6                     	xorq	%rsi, %r14
    19f0: 4d 21 ce                     	andq	%r9, %r14
    19f3: 49 31 f6                     	xorq	%rsi, %r14
    19f6: 48 03 9d 38 fe ff ff         	addq	-0x1c8(%rbp), %rbx
    19fd: 4c 01 f3                     	addq	%r14, %rbx
    1a00: 49 be 25 a7 0a 93 47 91 a7 d5	movabsq	$-0x2a586eb86cf558db, %r14 ## imm = 0xD5A79147930AA725
    1a0a: 49 01 de                     	addq	%rbx, %r14
    1a0d: 4c 89 d3                     	movq	%r10, %rbx
    1a10: 48 c1 c3 24                  	rolq	$0x24, %rbx
    1a14: 4d 01 e6                     	addq	%r12, %r14
    1a17: 4d 89 d7                     	movq	%r10, %r15
    1a1a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1a1e: 4d 01 f3                     	addq	%r14, %r11
    1a21: 4d 89 d4                     	movq	%r10, %r12
    1a24: 49 c1 c4 19                  	rolq	$0x19, %r12
    1a28: 49 31 df                     	xorq	%rbx, %r15
    1a2b: 4d 31 fc                     	xorq	%r15, %r12
    1a2e: 49 89 cf                     	movq	%rcx, %r15
    1a31: 49 09 d7                     	orq	%rdx, %r15
    1a34: 4d 21 d7                     	andq	%r10, %r15
    1a37: 48 89 cb                     	movq	%rcx, %rbx
    1a3a: 48 21 d3                     	andq	%rdx, %rbx
    1a3d: 4c 09 fb                     	orq	%r15, %rbx
    1a40: 4c 01 e3                     	addq	%r12, %rbx
    1a43: 4d 89 df                     	movq	%r11, %r15
    1a46: 49 c1 c7 32                  	rolq	$0x32, %r15
    1a4a: 4c 01 f3                     	addq	%r14, %rbx
    1a4d: 4d 89 de                     	movq	%r11, %r14
    1a50: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1a54: 4d 31 fe                     	xorq	%r15, %r14
    1a57: 4d 89 df                     	movq	%r11, %r15
    1a5a: 49 c1 c7 17                  	rolq	$0x17, %r15
    1a5e: 4d 31 f7                     	xorq	%r14, %r15
    1a61: 4d 89 ce                     	movq	%r9, %r14
    1a64: 4d 31 c6                     	xorq	%r8, %r14
    1a67: 4d 21 de                     	andq	%r11, %r14
    1a6a: 4d 31 c6                     	xorq	%r8, %r14
    1a6d: 48 03 b5 40 fe ff ff         	addq	-0x1c0(%rbp), %rsi
    1a74: 4c 01 f6                     	addq	%r14, %rsi
    1a77: 49 be 6f 82 03 e0 51 63 ca 06	movabsq	$0x6ca6351e003826f, %r14 ## imm = 0x6CA6351E003826F
    1a81: 49 01 f6                     	addq	%rsi, %r14
    1a84: 4d 01 fe                     	addq	%r15, %r14
    1a87: 4c 01 f2                     	addq	%r14, %rdx
    1a8a: 48 89 de                     	movq	%rbx, %rsi
    1a8d: 48 c1 c6 24                  	rolq	$0x24, %rsi
    1a91: 49 89 df                     	movq	%rbx, %r15
    1a94: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1a98: 49 31 f7                     	xorq	%rsi, %r15
    1a9b: 49 89 dc                     	movq	%rbx, %r12
    1a9e: 49 c1 c4 19                  	rolq	$0x19, %r12
    1aa2: 4d 31 fc                     	xorq	%r15, %r12
    1aa5: 4d 89 d7                     	movq	%r10, %r15
    1aa8: 49 09 cf                     	orq	%rcx, %r15
    1aab: 49 21 df                     	andq	%rbx, %r15
    1aae: 4c 89 d6                     	movq	%r10, %rsi
    1ab1: 48 21 ce                     	andq	%rcx, %rsi
    1ab4: 4c 09 fe                     	orq	%r15, %rsi
    1ab7: 49 89 d7                     	movq	%rdx, %r15
    1aba: 49 c1 c7 32                  	rolq	$0x32, %r15
    1abe: 4c 01 e6                     	addq	%r12, %rsi
    1ac1: 49 89 d4                     	movq	%rdx, %r12
    1ac4: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1ac8: 4c 01 f6                     	addq	%r14, %rsi
    1acb: 49 89 d6                     	movq	%rdx, %r14
    1ace: 49 c1 c6 17                  	rolq	$0x17, %r14
    1ad2: 4d 31 fc                     	xorq	%r15, %r12
    1ad5: 4d 31 e6                     	xorq	%r12, %r14
    1ad8: 4d 89 df                     	movq	%r11, %r15
    1adb: 4d 31 cf                     	xorq	%r9, %r15
    1ade: 49 21 d7                     	andq	%rdx, %r15
    1ae1: 4d 31 cf                     	xorq	%r9, %r15
    1ae4: 4c 03 85 48 fe ff ff         	addq	-0x1b8(%rbp), %r8
    1aeb: 4d 01 f8                     	addq	%r15, %r8
    1aee: 49 bf 70 6e 0e 0a 67 29 29 14	movabsq	$0x142929670a0e6e70, %r15 ## imm = 0x142929670A0E6E70
    1af8: 4d 01 c7                     	addq	%r8, %r15
    1afb: 4d 01 f7                     	addq	%r14, %r15
    1afe: 4c 01 f9                     	addq	%r15, %rcx
    1b01: 49 89 f0                     	movq	%rsi, %r8
    1b04: 49 c1 c0 24                  	rolq	$0x24, %r8
    1b08: 49 89 f6                     	movq	%rsi, %r14
    1b0b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1b0f: 4d 31 c6                     	xorq	%r8, %r14
    1b12: 49 89 f4                     	movq	%rsi, %r12
    1b15: 49 c1 c4 19                  	rolq	$0x19, %r12
    1b19: 4d 31 f4                     	xorq	%r14, %r12
    1b1c: 49 89 de                     	movq	%rbx, %r14
    1b1f: 4d 09 d6                     	orq	%r10, %r14
    1b22: 49 21 f6                     	andq	%rsi, %r14
    1b25: 49 89 d8                     	movq	%rbx, %r8
    1b28: 4d 21 d0                     	andq	%r10, %r8
    1b2b: 4d 09 f0                     	orq	%r14, %r8
    1b2e: 4d 01 e0                     	addq	%r12, %r8
    1b31: 4d 01 f8                     	addq	%r15, %r8
    1b34: 49 89 ce                     	movq	%rcx, %r14
    1b37: 49 c1 c6 32                  	rolq	$0x32, %r14
    1b3b: 49 89 cf                     	movq	%rcx, %r15
    1b3e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1b42: 4d 31 f7                     	xorq	%r14, %r15
    1b45: 49 89 cc                     	movq	%rcx, %r12
    1b48: 49 c1 c4 17                  	rolq	$0x17, %r12
    1b4c: 4d 31 fc                     	xorq	%r15, %r12
    1b4f: 49 89 d6                     	movq	%rdx, %r14
    1b52: 4d 31 de                     	xorq	%r11, %r14
    1b55: 49 21 ce                     	andq	%rcx, %r14
    1b58: 4c 03 8d 50 fe ff ff         	addq	-0x1b0(%rbp), %r9
    1b5f: 4d 31 de                     	xorq	%r11, %r14
    1b62: 4d 01 f1                     	addq	%r14, %r9
    1b65: 49 be fc 2f d2 46 85 0a b7 27	movabsq	$0x27b70a8546d22ffc, %r14 ## imm = 0x27B70A8546D22FFC
    1b6f: 4d 01 ce                     	addq	%r9, %r14
    1b72: 4d 01 e6                     	addq	%r12, %r14
    1b75: 4d 89 c1                     	movq	%r8, %r9
    1b78: 49 c1 c1 24                  	rolq	$0x24, %r9
    1b7c: 4d 01 f2                     	addq	%r14, %r10
    1b7f: 4d 89 c7                     	movq	%r8, %r15
    1b82: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1b86: 4d 31 cf                     	xorq	%r9, %r15
    1b89: 4d 89 c4                     	movq	%r8, %r12
    1b8c: 49 c1 c4 19                  	rolq	$0x19, %r12
    1b90: 4d 31 fc                     	xorq	%r15, %r12
    1b93: 49 89 f7                     	movq	%rsi, %r15
    1b96: 49 09 df                     	orq	%rbx, %r15
    1b99: 4d 21 c7                     	andq	%r8, %r15
    1b9c: 49 89 f1                     	movq	%rsi, %r9
    1b9f: 49 21 d9                     	andq	%rbx, %r9
    1ba2: 4d 09 f9                     	orq	%r15, %r9
    1ba5: 4d 01 e1                     	addq	%r12, %r9
    1ba8: 4d 01 f1                     	addq	%r14, %r9
    1bab: 4d 89 d6                     	movq	%r10, %r14
    1bae: 49 c1 c6 32                  	rolq	$0x32, %r14
    1bb2: 4d 89 d7                     	movq	%r10, %r15
    1bb5: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1bb9: 4d 31 f7                     	xorq	%r14, %r15
    1bbc: 4d 89 d4                     	movq	%r10, %r12
    1bbf: 49 c1 c4 17                  	rolq	$0x17, %r12
    1bc3: 4d 31 fc                     	xorq	%r15, %r12
    1bc6: 49 89 ce                     	movq	%rcx, %r14
    1bc9: 49 31 d6                     	xorq	%rdx, %r14
    1bcc: 4d 21 d6                     	andq	%r10, %r14
    1bcf: 49 31 d6                     	xorq	%rdx, %r14
    1bd2: 4c 03 9d 58 fe ff ff         	addq	-0x1a8(%rbp), %r11
    1bd9: 4d 01 f3                     	addq	%r14, %r11
    1bdc: 49 be 26 c9 26 5c 38 21 1b 2e	movabsq	$0x2e1b21385c26c926, %r14 ## imm = 0x2E1B21385C26C926
    1be6: 4d 01 de                     	addq	%r11, %r14
    1be9: 4d 89 cb                     	movq	%r9, %r11
    1bec: 49 c1 c3 24                  	rolq	$0x24, %r11
    1bf0: 4d 01 e6                     	addq	%r12, %r14
    1bf3: 4d 89 cf                     	movq	%r9, %r15
    1bf6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1bfa: 4c 01 f3                     	addq	%r14, %rbx
    1bfd: 4d 89 cc                     	movq	%r9, %r12
    1c00: 49 c1 c4 19                  	rolq	$0x19, %r12
    1c04: 4d 31 df                     	xorq	%r11, %r15
    1c07: 4d 31 fc                     	xorq	%r15, %r12
    1c0a: 4d 89 c7                     	movq	%r8, %r15
    1c0d: 49 09 f7                     	orq	%rsi, %r15
    1c10: 4d 21 cf                     	andq	%r9, %r15
    1c13: 4d 89 c3                     	movq	%r8, %r11
    1c16: 49 21 f3                     	andq	%rsi, %r11
    1c19: 4d 09 fb                     	orq	%r15, %r11
    1c1c: 4d 01 e3                     	addq	%r12, %r11
    1c1f: 49 89 df                     	movq	%rbx, %r15
    1c22: 49 c1 c7 32                  	rolq	$0x32, %r15
    1c26: 4d 01 f3                     	addq	%r14, %r11
    1c29: 49 89 de                     	movq	%rbx, %r14
    1c2c: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1c30: 4d 31 fe                     	xorq	%r15, %r14
    1c33: 49 89 df                     	movq	%rbx, %r15
    1c36: 49 c1 c7 17                  	rolq	$0x17, %r15
    1c3a: 4d 31 f7                     	xorq	%r14, %r15
    1c3d: 4d 89 d6                     	movq	%r10, %r14
    1c40: 49 31 ce                     	xorq	%rcx, %r14
    1c43: 49 21 de                     	andq	%rbx, %r14
    1c46: 49 31 ce                     	xorq	%rcx, %r14
    1c49: 48 03 95 60 fe ff ff         	addq	-0x1a0(%rbp), %rdx
    1c50: 4c 01 f2                     	addq	%r14, %rdx
    1c53: 49 be ed 2a c4 5a fc 6d 2c 4d	movabsq	$0x4d2c6dfc5ac42aed, %r14 ## imm = 0x4D2C6DFC5AC42AED
    1c5d: 49 01 d6                     	addq	%rdx, %r14
    1c60: 4d 01 fe                     	addq	%r15, %r14
    1c63: 4c 01 f6                     	addq	%r14, %rsi
    1c66: 4c 89 da                     	movq	%r11, %rdx
    1c69: 48 c1 c2 24                  	rolq	$0x24, %rdx
    1c6d: 4d 89 df                     	movq	%r11, %r15
    1c70: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1c74: 49 31 d7                     	xorq	%rdx, %r15
    1c77: 4d 89 dc                     	movq	%r11, %r12
    1c7a: 49 c1 c4 19                  	rolq	$0x19, %r12
    1c7e: 4d 31 fc                     	xorq	%r15, %r12
    1c81: 4d 89 cf                     	movq	%r9, %r15
    1c84: 4d 09 c7                     	orq	%r8, %r15
    1c87: 4d 21 df                     	andq	%r11, %r15
    1c8a: 4c 89 ca                     	movq	%r9, %rdx
    1c8d: 4c 21 c2                     	andq	%r8, %rdx
    1c90: 4c 09 fa                     	orq	%r15, %rdx
    1c93: 49 89 f7                     	movq	%rsi, %r15
    1c96: 49 c1 c7 32                  	rolq	$0x32, %r15
    1c9a: 4c 01 e2                     	addq	%r12, %rdx
    1c9d: 49 89 f4                     	movq	%rsi, %r12
    1ca0: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1ca4: 4c 01 f2                     	addq	%r14, %rdx
    1ca7: 49 89 f6                     	movq	%rsi, %r14
    1caa: 49 c1 c6 17                  	rolq	$0x17, %r14
    1cae: 4d 31 fc                     	xorq	%r15, %r12
    1cb1: 4d 31 e6                     	xorq	%r12, %r14
    1cb4: 49 89 df                     	movq	%rbx, %r15
    1cb7: 4d 31 d7                     	xorq	%r10, %r15
    1cba: 49 21 f7                     	andq	%rsi, %r15
    1cbd: 4d 31 d7                     	xorq	%r10, %r15
    1cc0: 48 03 8d 68 fe ff ff         	addq	-0x198(%rbp), %rcx
    1cc7: 4c 01 f9                     	addq	%r15, %rcx
    1cca: 49 bf df b3 95 9d 13 0d 38 53	movabsq	$0x53380d139d95b3df, %r15 ## imm = 0x53380D139D95B3DF
    1cd4: 49 01 cf                     	addq	%rcx, %r15
    1cd7: 4d 01 f7                     	addq	%r14, %r15
    1cda: 4d 01 f8                     	addq	%r15, %r8
    1cdd: 48 89 d1                     	movq	%rdx, %rcx
    1ce0: 48 c1 c1 24                  	rolq	$0x24, %rcx
    1ce4: 49 89 d6                     	movq	%rdx, %r14
    1ce7: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1ceb: 49 31 ce                     	xorq	%rcx, %r14
    1cee: 49 89 d4                     	movq	%rdx, %r12
    1cf1: 49 c1 c4 19                  	rolq	$0x19, %r12
    1cf5: 4d 31 f4                     	xorq	%r14, %r12
    1cf8: 4d 89 de                     	movq	%r11, %r14
    1cfb: 4d 09 ce                     	orq	%r9, %r14
    1cfe: 49 21 d6                     	andq	%rdx, %r14
    1d01: 4c 89 d9                     	movq	%r11, %rcx
    1d04: 4c 21 c9                     	andq	%r9, %rcx
    1d07: 4c 09 f1                     	orq	%r14, %rcx
    1d0a: 4c 01 e1                     	addq	%r12, %rcx
    1d0d: 4c 01 f9                     	addq	%r15, %rcx
    1d10: 4d 89 c6                     	movq	%r8, %r14
    1d13: 49 c1 c6 32                  	rolq	$0x32, %r14
    1d17: 4d 89 c7                     	movq	%r8, %r15
    1d1a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1d1e: 4d 31 f7                     	xorq	%r14, %r15
    1d21: 4d 89 c4                     	movq	%r8, %r12
    1d24: 49 c1 c4 17                  	rolq	$0x17, %r12
    1d28: 4d 31 fc                     	xorq	%r15, %r12
    1d2b: 49 89 f6                     	movq	%rsi, %r14
    1d2e: 49 31 de                     	xorq	%rbx, %r14
    1d31: 4d 21 c6                     	andq	%r8, %r14
    1d34: 4c 03 95 70 fe ff ff         	addq	-0x190(%rbp), %r10
    1d3b: 49 31 de                     	xorq	%rbx, %r14
    1d3e: 4d 01 f2                     	addq	%r14, %r10
    1d41: 49 be de 63 af 8b 54 73 0a 65	movabsq	$0x650a73548baf63de, %r14 ## imm = 0x650A73548BAF63DE
    1d4b: 4d 01 d6                     	addq	%r10, %r14
    1d4e: 4d 01 e6                     	addq	%r12, %r14
    1d51: 49 89 ca                     	movq	%rcx, %r10
    1d54: 49 c1 c2 24                  	rolq	$0x24, %r10
    1d58: 4d 01 f1                     	addq	%r14, %r9
    1d5b: 49 89 cf                     	movq	%rcx, %r15
    1d5e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1d62: 4d 31 d7                     	xorq	%r10, %r15
    1d65: 49 89 cc                     	movq	%rcx, %r12
    1d68: 49 c1 c4 19                  	rolq	$0x19, %r12
    1d6c: 4d 31 fc                     	xorq	%r15, %r12
    1d6f: 49 89 d7                     	movq	%rdx, %r15
    1d72: 4d 09 df                     	orq	%r11, %r15
    1d75: 49 21 cf                     	andq	%rcx, %r15
    1d78: 49 89 d2                     	movq	%rdx, %r10
    1d7b: 4d 21 da                     	andq	%r11, %r10
    1d7e: 4d 09 fa                     	orq	%r15, %r10
    1d81: 4d 01 e2                     	addq	%r12, %r10
    1d84: 4d 01 f2                     	addq	%r14, %r10
    1d87: 4d 89 ce                     	movq	%r9, %r14
    1d8a: 49 c1 c6 32                  	rolq	$0x32, %r14
    1d8e: 4d 89 cf                     	movq	%r9, %r15
    1d91: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1d95: 4d 31 f7                     	xorq	%r14, %r15
    1d98: 4d 89 cc                     	movq	%r9, %r12
    1d9b: 49 c1 c4 17                  	rolq	$0x17, %r12
    1d9f: 4d 31 fc                     	xorq	%r15, %r12
    1da2: 4d 89 c6                     	movq	%r8, %r14
    1da5: 49 31 f6                     	xorq	%rsi, %r14
    1da8: 4d 21 ce                     	andq	%r9, %r14
    1dab: 49 31 f6                     	xorq	%rsi, %r14
    1dae: 48 03 9d 78 fe ff ff         	addq	-0x188(%rbp), %rbx
    1db5: 4c 01 f3                     	addq	%r14, %rbx
    1db8: 49 be a8 b2 77 3c bb 0a 6a 76	movabsq	$0x766a0abb3c77b2a8, %r14 ## imm = 0x766A0ABB3C77B2A8
    1dc2: 49 01 de                     	addq	%rbx, %r14
    1dc5: 4c 89 d3                     	movq	%r10, %rbx
    1dc8: 48 c1 c3 24                  	rolq	$0x24, %rbx
    1dcc: 4d 01 e6                     	addq	%r12, %r14
    1dcf: 4d 89 d7                     	movq	%r10, %r15
    1dd2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1dd6: 4d 01 f3                     	addq	%r14, %r11
    1dd9: 4d 89 d4                     	movq	%r10, %r12
    1ddc: 49 c1 c4 19                  	rolq	$0x19, %r12
    1de0: 49 31 df                     	xorq	%rbx, %r15
    1de3: 4d 31 fc                     	xorq	%r15, %r12
    1de6: 49 89 cf                     	movq	%rcx, %r15
    1de9: 49 09 d7                     	orq	%rdx, %r15
    1dec: 4d 21 d7                     	andq	%r10, %r15
    1def: 48 89 cb                     	movq	%rcx, %rbx
    1df2: 48 21 d3                     	andq	%rdx, %rbx
    1df5: 4c 09 fb                     	orq	%r15, %rbx
    1df8: 4c 01 e3                     	addq	%r12, %rbx
    1dfb: 4d 89 df                     	movq	%r11, %r15
    1dfe: 49 c1 c7 32                  	rolq	$0x32, %r15
    1e02: 4c 01 f3                     	addq	%r14, %rbx
    1e05: 4d 89 de                     	movq	%r11, %r14
    1e08: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1e0c: 4d 31 fe                     	xorq	%r15, %r14
    1e0f: 4d 89 df                     	movq	%r11, %r15
    1e12: 49 c1 c7 17                  	rolq	$0x17, %r15
    1e16: 4d 31 f7                     	xorq	%r14, %r15
    1e19: 4d 89 ce                     	movq	%r9, %r14
    1e1c: 4d 31 c6                     	xorq	%r8, %r14
    1e1f: 4d 21 de                     	andq	%r11, %r14
    1e22: 4d 31 c6                     	xorq	%r8, %r14
    1e25: 48 03 b5 80 fe ff ff         	addq	-0x180(%rbp), %rsi
    1e2c: 4c 01 f6                     	addq	%r14, %rsi
    1e2f: 49 be e6 ae ed 47 2e c9 c2 81	movabsq	$-0x7e3d36d1b812511a, %r14 ## imm = 0x81C2C92E47EDAEE6
    1e39: 49 01 f6                     	addq	%rsi, %r14
    1e3c: 4d 01 fe                     	addq	%r15, %r14
    1e3f: 4c 01 f2                     	addq	%r14, %rdx
    1e42: 48 89 de                     	movq	%rbx, %rsi
    1e45: 48 c1 c6 24                  	rolq	$0x24, %rsi
    1e49: 49 89 df                     	movq	%rbx, %r15
    1e4c: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1e50: 49 31 f7                     	xorq	%rsi, %r15
    1e53: 49 89 dc                     	movq	%rbx, %r12
    1e56: 49 c1 c4 19                  	rolq	$0x19, %r12
    1e5a: 4d 31 fc                     	xorq	%r15, %r12
    1e5d: 4d 89 d7                     	movq	%r10, %r15
    1e60: 49 09 cf                     	orq	%rcx, %r15
    1e63: 49 21 df                     	andq	%rbx, %r15
    1e66: 4c 89 d6                     	movq	%r10, %rsi
    1e69: 48 21 ce                     	andq	%rcx, %rsi
    1e6c: 4c 09 fe                     	orq	%r15, %rsi
    1e6f: 49 89 d7                     	movq	%rdx, %r15
    1e72: 49 c1 c7 32                  	rolq	$0x32, %r15
    1e76: 4c 01 e6                     	addq	%r12, %rsi
    1e79: 49 89 d4                     	movq	%rdx, %r12
    1e7c: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    1e80: 4c 01 f6                     	addq	%r14, %rsi
    1e83: 49 89 d6                     	movq	%rdx, %r14
    1e86: 49 c1 c6 17                  	rolq	$0x17, %r14
    1e8a: 4d 31 fc                     	xorq	%r15, %r12
    1e8d: 4d 31 e6                     	xorq	%r12, %r14
    1e90: 4d 89 df                     	movq	%r11, %r15
    1e93: 4d 31 cf                     	xorq	%r9, %r15
    1e96: 49 21 d7                     	andq	%rdx, %r15
    1e99: 4d 31 cf                     	xorq	%r9, %r15
    1e9c: 4c 03 85 88 fe ff ff         	addq	-0x178(%rbp), %r8
    1ea3: 4d 01 f8                     	addq	%r15, %r8
    1ea6: 49 bf 3b 35 82 14 85 2c 72 92	movabsq	$-0x6d8dd37aeb7dcac5, %r15 ## imm = 0x92722C851482353B
    1eb0: 4d 01 c7                     	addq	%r8, %r15
    1eb3: 4d 01 f7                     	addq	%r14, %r15
    1eb6: 4c 01 f9                     	addq	%r15, %rcx
    1eb9: 49 89 f0                     	movq	%rsi, %r8
    1ebc: 49 c1 c0 24                  	rolq	$0x24, %r8
    1ec0: 49 89 f6                     	movq	%rsi, %r14
    1ec3: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    1ec7: 4d 31 c6                     	xorq	%r8, %r14
    1eca: 49 89 f4                     	movq	%rsi, %r12
    1ecd: 49 c1 c4 19                  	rolq	$0x19, %r12
    1ed1: 4d 31 f4                     	xorq	%r14, %r12
    1ed4: 49 89 de                     	movq	%rbx, %r14
    1ed7: 4d 09 d6                     	orq	%r10, %r14
    1eda: 49 21 f6                     	andq	%rsi, %r14
    1edd: 49 89 d8                     	movq	%rbx, %r8
    1ee0: 4d 21 d0                     	andq	%r10, %r8
    1ee3: 4d 09 f0                     	orq	%r14, %r8
    1ee6: 4d 01 e0                     	addq	%r12, %r8
    1ee9: 4d 01 f8                     	addq	%r15, %r8
    1eec: 49 89 ce                     	movq	%rcx, %r14
    1eef: 49 c1 c6 32                  	rolq	$0x32, %r14
    1ef3: 49 89 cf                     	movq	%rcx, %r15
    1ef6: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1efa: 4d 31 f7                     	xorq	%r14, %r15
    1efd: 49 89 cc                     	movq	%rcx, %r12
    1f00: 49 c1 c4 17                  	rolq	$0x17, %r12
    1f04: 4d 31 fc                     	xorq	%r15, %r12
    1f07: 49 89 d6                     	movq	%rdx, %r14
    1f0a: 4d 31 de                     	xorq	%r11, %r14
    1f0d: 49 21 ce                     	andq	%rcx, %r14
    1f10: 4c 03 8d 90 fe ff ff         	addq	-0x170(%rbp), %r9
    1f17: 4d 31 de                     	xorq	%r11, %r14
    1f1a: 4d 01 f1                     	addq	%r14, %r9
    1f1d: 49 be 64 03 f1 4c a1 e8 bf a2	movabsq	$-0x5d40175eb30efc9c, %r14 ## imm = 0xA2BFE8A14CF10364
    1f27: 4d 01 ce                     	addq	%r9, %r14
    1f2a: 4d 01 e6                     	addq	%r12, %r14
    1f2d: 4d 89 c1                     	movq	%r8, %r9
    1f30: 49 c1 c1 24                  	rolq	$0x24, %r9
    1f34: 4d 01 f2                     	addq	%r14, %r10
    1f37: 4d 89 c7                     	movq	%r8, %r15
    1f3a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1f3e: 4d 31 cf                     	xorq	%r9, %r15
    1f41: 4d 89 c4                     	movq	%r8, %r12
    1f44: 49 c1 c4 19                  	rolq	$0x19, %r12
    1f48: 4d 31 fc                     	xorq	%r15, %r12
    1f4b: 49 89 f7                     	movq	%rsi, %r15
    1f4e: 49 09 df                     	orq	%rbx, %r15
    1f51: 4d 21 c7                     	andq	%r8, %r15
    1f54: 49 89 f1                     	movq	%rsi, %r9
    1f57: 49 21 d9                     	andq	%rbx, %r9
    1f5a: 4d 09 f9                     	orq	%r15, %r9
    1f5d: 4d 01 e1                     	addq	%r12, %r9
    1f60: 4d 01 f1                     	addq	%r14, %r9
    1f63: 4d 89 d6                     	movq	%r10, %r14
    1f66: 49 c1 c6 32                  	rolq	$0x32, %r14
    1f6a: 4d 89 d7                     	movq	%r10, %r15
    1f6d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    1f71: 4d 31 f7                     	xorq	%r14, %r15
    1f74: 4d 89 d4                     	movq	%r10, %r12
    1f77: 49 c1 c4 17                  	rolq	$0x17, %r12
    1f7b: 4d 31 fc                     	xorq	%r15, %r12
    1f7e: 49 89 ce                     	movq	%rcx, %r14
    1f81: 49 31 d6                     	xorq	%rdx, %r14
    1f84: 4d 21 d6                     	andq	%r10, %r14
    1f87: 49 31 d6                     	xorq	%rdx, %r14
    1f8a: 4c 03 9d 98 fe ff ff         	addq	-0x168(%rbp), %r11
    1f91: 4d 01 f3                     	addq	%r14, %r11
    1f94: 49 be 01 30 42 bc 4b 66 1a a8	movabsq	$-0x57e599b443bdcfff, %r14 ## imm = 0xA81A664BBC423001
    1f9e: 4d 01 de                     	addq	%r11, %r14
    1fa1: 4d 89 cb                     	movq	%r9, %r11
    1fa4: 49 c1 c3 24                  	rolq	$0x24, %r11
    1fa8: 4d 01 e6                     	addq	%r12, %r14
    1fab: 4d 89 cf                     	movq	%r9, %r15
    1fae: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    1fb2: 4c 01 f3                     	addq	%r14, %rbx
    1fb5: 4d 89 cc                     	movq	%r9, %r12
    1fb8: 49 c1 c4 19                  	rolq	$0x19, %r12
    1fbc: 4d 31 df                     	xorq	%r11, %r15
    1fbf: 4d 31 fc                     	xorq	%r15, %r12
    1fc2: 4d 89 c7                     	movq	%r8, %r15
    1fc5: 49 09 f7                     	orq	%rsi, %r15
    1fc8: 4d 21 cf                     	andq	%r9, %r15
    1fcb: 4d 89 c3                     	movq	%r8, %r11
    1fce: 49 21 f3                     	andq	%rsi, %r11
    1fd1: 4d 09 fb                     	orq	%r15, %r11
    1fd4: 4d 01 e3                     	addq	%r12, %r11
    1fd7: 49 89 df                     	movq	%rbx, %r15
    1fda: 49 c1 c7 32                  	rolq	$0x32, %r15
    1fde: 4d 01 f3                     	addq	%r14, %r11
    1fe1: 49 89 de                     	movq	%rbx, %r14
    1fe4: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    1fe8: 4d 31 fe                     	xorq	%r15, %r14
    1feb: 49 89 df                     	movq	%rbx, %r15
    1fee: 49 c1 c7 17                  	rolq	$0x17, %r15
    1ff2: 4d 31 f7                     	xorq	%r14, %r15
    1ff5: 4d 89 d6                     	movq	%r10, %r14
    1ff8: 49 31 ce                     	xorq	%rcx, %r14
    1ffb: 49 21 de                     	andq	%rbx, %r14
    1ffe: 49 31 ce                     	xorq	%rcx, %r14
    2001: 48 03 95 a0 fe ff ff         	addq	-0x160(%rbp), %rdx
    2008: 4c 01 f2                     	addq	%r14, %rdx
    200b: 49 be 91 97 f8 d0 70 8b 4b c2	movabsq	$-0x3db4748f2f07686f, %r14 ## imm = 0xC24B8B70D0F89791
    2015: 49 01 d6                     	addq	%rdx, %r14
    2018: 4d 01 fe                     	addq	%r15, %r14
    201b: 4c 01 f6                     	addq	%r14, %rsi
    201e: 4c 89 da                     	movq	%r11, %rdx
    2021: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2025: 4d 89 df                     	movq	%r11, %r15
    2028: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    202c: 49 31 d7                     	xorq	%rdx, %r15
    202f: 4d 89 dc                     	movq	%r11, %r12
    2032: 49 c1 c4 19                  	rolq	$0x19, %r12
    2036: 4d 31 fc                     	xorq	%r15, %r12
    2039: 4d 89 cf                     	movq	%r9, %r15
    203c: 4d 09 c7                     	orq	%r8, %r15
    203f: 4d 21 df                     	andq	%r11, %r15
    2042: 4c 89 ca                     	movq	%r9, %rdx
    2045: 4c 21 c2                     	andq	%r8, %rdx
    2048: 4c 09 fa                     	orq	%r15, %rdx
    204b: 49 89 f7                     	movq	%rsi, %r15
    204e: 49 c1 c7 32                  	rolq	$0x32, %r15
    2052: 4c 01 e2                     	addq	%r12, %rdx
    2055: 49 89 f4                     	movq	%rsi, %r12
    2058: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    205c: 4c 01 f2                     	addq	%r14, %rdx
    205f: 49 89 f6                     	movq	%rsi, %r14
    2062: 49 c1 c6 17                  	rolq	$0x17, %r14
    2066: 4d 31 fc                     	xorq	%r15, %r12
    2069: 4d 31 e6                     	xorq	%r12, %r14
    206c: 49 89 df                     	movq	%rbx, %r15
    206f: 4d 31 d7                     	xorq	%r10, %r15
    2072: 49 21 f7                     	andq	%rsi, %r15
    2075: 4d 31 d7                     	xorq	%r10, %r15
    2078: 48 03 8d a8 fe ff ff         	addq	-0x158(%rbp), %rcx
    207f: 4c 01 f9                     	addq	%r15, %rcx
    2082: 49 bf 30 be 54 06 a3 51 6c c7	movabsq	$-0x3893ae5cf9ab41d0, %r15 ## imm = 0xC76C51A30654BE30
    208c: 49 01 cf                     	addq	%rcx, %r15
    208f: 4d 01 f7                     	addq	%r14, %r15
    2092: 4d 01 f8                     	addq	%r15, %r8
    2095: 48 89 d1                     	movq	%rdx, %rcx
    2098: 48 c1 c1 24                  	rolq	$0x24, %rcx
    209c: 49 89 d6                     	movq	%rdx, %r14
    209f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    20a3: 49 31 ce                     	xorq	%rcx, %r14
    20a6: 49 89 d4                     	movq	%rdx, %r12
    20a9: 49 c1 c4 19                  	rolq	$0x19, %r12
    20ad: 4d 31 f4                     	xorq	%r14, %r12
    20b0: 4d 89 de                     	movq	%r11, %r14
    20b3: 4d 09 ce                     	orq	%r9, %r14
    20b6: 49 21 d6                     	andq	%rdx, %r14
    20b9: 4c 89 d9                     	movq	%r11, %rcx
    20bc: 4c 21 c9                     	andq	%r9, %rcx
    20bf: 4c 09 f1                     	orq	%r14, %rcx
    20c2: 4c 01 e1                     	addq	%r12, %rcx
    20c5: 4c 01 f9                     	addq	%r15, %rcx
    20c8: 4d 89 c6                     	movq	%r8, %r14
    20cb: 49 c1 c6 32                  	rolq	$0x32, %r14
    20cf: 4d 89 c7                     	movq	%r8, %r15
    20d2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    20d6: 4d 31 f7                     	xorq	%r14, %r15
    20d9: 4d 89 c4                     	movq	%r8, %r12
    20dc: 49 c1 c4 17                  	rolq	$0x17, %r12
    20e0: 4d 31 fc                     	xorq	%r15, %r12
    20e3: 49 89 f6                     	movq	%rsi, %r14
    20e6: 49 31 de                     	xorq	%rbx, %r14
    20e9: 4d 21 c6                     	andq	%r8, %r14
    20ec: 4c 03 95 b0 fe ff ff         	addq	-0x150(%rbp), %r10
    20f3: 49 31 de                     	xorq	%rbx, %r14
    20f6: 4d 01 f2                     	addq	%r14, %r10
    20f9: 49 be 18 52 ef d6 19 e8 92 d1	movabsq	$-0x2e6d17e62910ade8, %r14 ## imm = 0xD192E819D6EF5218
    2103: 4d 01 d6                     	addq	%r10, %r14
    2106: 4d 01 e6                     	addq	%r12, %r14
    2109: 49 89 ca                     	movq	%rcx, %r10
    210c: 49 c1 c2 24                  	rolq	$0x24, %r10
    2110: 4d 01 f1                     	addq	%r14, %r9
    2113: 49 89 cf                     	movq	%rcx, %r15
    2116: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    211a: 4d 31 d7                     	xorq	%r10, %r15
    211d: 49 89 cc                     	movq	%rcx, %r12
    2120: 49 c1 c4 19                  	rolq	$0x19, %r12
    2124: 4d 31 fc                     	xorq	%r15, %r12
    2127: 49 89 d7                     	movq	%rdx, %r15
    212a: 4d 09 df                     	orq	%r11, %r15
    212d: 49 21 cf                     	andq	%rcx, %r15
    2130: 49 89 d2                     	movq	%rdx, %r10
    2133: 4d 21 da                     	andq	%r11, %r10
    2136: 4d 09 fa                     	orq	%r15, %r10
    2139: 4d 01 e2                     	addq	%r12, %r10
    213c: 4d 01 f2                     	addq	%r14, %r10
    213f: 4d 89 ce                     	movq	%r9, %r14
    2142: 49 c1 c6 32                  	rolq	$0x32, %r14
    2146: 4d 89 cf                     	movq	%r9, %r15
    2149: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    214d: 4d 31 f7                     	xorq	%r14, %r15
    2150: 4d 89 cc                     	movq	%r9, %r12
    2153: 49 c1 c4 17                  	rolq	$0x17, %r12
    2157: 4d 31 fc                     	xorq	%r15, %r12
    215a: 4d 89 c6                     	movq	%r8, %r14
    215d: 49 31 f6                     	xorq	%rsi, %r14
    2160: 4d 21 ce                     	andq	%r9, %r14
    2163: 49 31 f6                     	xorq	%rsi, %r14
    2166: 48 03 9d b8 fe ff ff         	addq	-0x148(%rbp), %rbx
    216d: 4c 01 f3                     	addq	%r14, %rbx
    2170: 49 be 10 a9 65 55 24 06 99 d6	movabsq	$-0x2966f9dbaa9a56f0, %r14 ## imm = 0xD69906245565A910
    217a: 49 01 de                     	addq	%rbx, %r14
    217d: 4c 89 d3                     	movq	%r10, %rbx
    2180: 48 c1 c3 24                  	rolq	$0x24, %rbx
    2184: 4d 01 e6                     	addq	%r12, %r14
    2187: 4d 89 d7                     	movq	%r10, %r15
    218a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    218e: 4d 01 f3                     	addq	%r14, %r11
    2191: 4d 89 d4                     	movq	%r10, %r12
    2194: 49 c1 c4 19                  	rolq	$0x19, %r12
    2198: 49 31 df                     	xorq	%rbx, %r15
    219b: 4d 31 fc                     	xorq	%r15, %r12
    219e: 49 89 cf                     	movq	%rcx, %r15
    21a1: 49 09 d7                     	orq	%rdx, %r15
    21a4: 4d 21 d7                     	andq	%r10, %r15
    21a7: 48 89 cb                     	movq	%rcx, %rbx
    21aa: 48 21 d3                     	andq	%rdx, %rbx
    21ad: 4c 09 fb                     	orq	%r15, %rbx
    21b0: 4c 01 e3                     	addq	%r12, %rbx
    21b3: 4d 89 df                     	movq	%r11, %r15
    21b6: 49 c1 c7 32                  	rolq	$0x32, %r15
    21ba: 4c 01 f3                     	addq	%r14, %rbx
    21bd: 4d 89 de                     	movq	%r11, %r14
    21c0: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    21c4: 4d 31 fe                     	xorq	%r15, %r14
    21c7: 4d 89 df                     	movq	%r11, %r15
    21ca: 49 c1 c7 17                  	rolq	$0x17, %r15
    21ce: 4d 31 f7                     	xorq	%r14, %r15
    21d1: 4d 89 ce                     	movq	%r9, %r14
    21d4: 4d 31 c6                     	xorq	%r8, %r14
    21d7: 4d 21 de                     	andq	%r11, %r14
    21da: 4d 31 c6                     	xorq	%r8, %r14
    21dd: 48 03 b5 c0 fe ff ff         	addq	-0x140(%rbp), %rsi
    21e4: 4c 01 f6                     	addq	%r14, %rsi
    21e7: 49 be 2a 20 71 57 85 35 0e f4	movabsq	$-0xbf1ca7aa88edfd6, %r14 ## imm = 0xF40E35855771202A
    21f1: 49 01 f6                     	addq	%rsi, %r14
    21f4: 4d 01 fe                     	addq	%r15, %r14
    21f7: 4c 01 f2                     	addq	%r14, %rdx
    21fa: 48 89 de                     	movq	%rbx, %rsi
    21fd: 48 c1 c6 24                  	rolq	$0x24, %rsi
    2201: 49 89 df                     	movq	%rbx, %r15
    2204: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2208: 49 31 f7                     	xorq	%rsi, %r15
    220b: 49 89 dc                     	movq	%rbx, %r12
    220e: 49 c1 c4 19                  	rolq	$0x19, %r12
    2212: 4d 31 fc                     	xorq	%r15, %r12
    2215: 4d 89 d7                     	movq	%r10, %r15
    2218: 49 09 cf                     	orq	%rcx, %r15
    221b: 49 21 df                     	andq	%rbx, %r15
    221e: 4c 89 d6                     	movq	%r10, %rsi
    2221: 48 21 ce                     	andq	%rcx, %rsi
    2224: 4c 09 fe                     	orq	%r15, %rsi
    2227: 49 89 d7                     	movq	%rdx, %r15
    222a: 49 c1 c7 32                  	rolq	$0x32, %r15
    222e: 4c 01 e6                     	addq	%r12, %rsi
    2231: 49 89 d4                     	movq	%rdx, %r12
    2234: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2238: 4c 01 f6                     	addq	%r14, %rsi
    223b: 49 89 d6                     	movq	%rdx, %r14
    223e: 49 c1 c6 17                  	rolq	$0x17, %r14
    2242: 4d 31 fc                     	xorq	%r15, %r12
    2245: 4d 31 e6                     	xorq	%r12, %r14
    2248: 4d 89 df                     	movq	%r11, %r15
    224b: 4d 31 cf                     	xorq	%r9, %r15
    224e: 49 21 d7                     	andq	%rdx, %r15
    2251: 4d 31 cf                     	xorq	%r9, %r15
    2254: 4c 03 85 c8 fe ff ff         	addq	-0x138(%rbp), %r8
    225b: 4d 01 f8                     	addq	%r15, %r8
    225e: 49 bf b8 d1 bb 32 70 a0 6a 10	movabsq	$0x106aa07032bbd1b8, %r15 ## imm = 0x106AA07032BBD1B8
    2268: 4d 01 c7                     	addq	%r8, %r15
    226b: 4d 01 f7                     	addq	%r14, %r15
    226e: 4c 01 f9                     	addq	%r15, %rcx
    2271: 49 89 f0                     	movq	%rsi, %r8
    2274: 49 c1 c0 24                  	rolq	$0x24, %r8
    2278: 49 89 f6                     	movq	%rsi, %r14
    227b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    227f: 4d 31 c6                     	xorq	%r8, %r14
    2282: 49 89 f4                     	movq	%rsi, %r12
    2285: 49 c1 c4 19                  	rolq	$0x19, %r12
    2289: 4d 31 f4                     	xorq	%r14, %r12
    228c: 49 89 de                     	movq	%rbx, %r14
    228f: 4d 09 d6                     	orq	%r10, %r14
    2292: 49 21 f6                     	andq	%rsi, %r14
    2295: 49 89 d8                     	movq	%rbx, %r8
    2298: 4d 21 d0                     	andq	%r10, %r8
    229b: 4d 09 f0                     	orq	%r14, %r8
    229e: 4d 01 e0                     	addq	%r12, %r8
    22a1: 4d 01 f8                     	addq	%r15, %r8
    22a4: 49 89 ce                     	movq	%rcx, %r14
    22a7: 49 c1 c6 32                  	rolq	$0x32, %r14
    22ab: 49 89 cf                     	movq	%rcx, %r15
    22ae: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    22b2: 4d 31 f7                     	xorq	%r14, %r15
    22b5: 49 89 cc                     	movq	%rcx, %r12
    22b8: 49 c1 c4 17                  	rolq	$0x17, %r12
    22bc: 4d 31 fc                     	xorq	%r15, %r12
    22bf: 49 89 d6                     	movq	%rdx, %r14
    22c2: 4d 31 de                     	xorq	%r11, %r14
    22c5: 49 21 ce                     	andq	%rcx, %r14
    22c8: 4c 03 8d d0 fe ff ff         	addq	-0x130(%rbp), %r9
    22cf: 4d 31 de                     	xorq	%r11, %r14
    22d2: 4d 01 f1                     	addq	%r14, %r9
    22d5: 49 be c8 d0 d2 b8 16 c1 a4 19	movabsq	$0x19a4c116b8d2d0c8, %r14 ## imm = 0x19A4C116B8D2D0C8
    22df: 4d 01 ce                     	addq	%r9, %r14
    22e2: 4d 01 e6                     	addq	%r12, %r14
    22e5: 4d 89 c1                     	movq	%r8, %r9
    22e8: 49 c1 c1 24                  	rolq	$0x24, %r9
    22ec: 4d 01 f2                     	addq	%r14, %r10
    22ef: 4d 89 c7                     	movq	%r8, %r15
    22f2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    22f6: 4d 31 cf                     	xorq	%r9, %r15
    22f9: 4d 89 c4                     	movq	%r8, %r12
    22fc: 49 c1 c4 19                  	rolq	$0x19, %r12
    2300: 4d 31 fc                     	xorq	%r15, %r12
    2303: 49 89 f7                     	movq	%rsi, %r15
    2306: 49 09 df                     	orq	%rbx, %r15
    2309: 4d 21 c7                     	andq	%r8, %r15
    230c: 49 89 f1                     	movq	%rsi, %r9
    230f: 49 21 d9                     	andq	%rbx, %r9
    2312: 4d 09 f9                     	orq	%r15, %r9
    2315: 4d 01 e1                     	addq	%r12, %r9
    2318: 4d 01 f1                     	addq	%r14, %r9
    231b: 4d 89 d6                     	movq	%r10, %r14
    231e: 49 c1 c6 32                  	rolq	$0x32, %r14
    2322: 4d 89 d7                     	movq	%r10, %r15
    2325: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2329: 4d 31 f7                     	xorq	%r14, %r15
    232c: 4d 89 d4                     	movq	%r10, %r12
    232f: 49 c1 c4 17                  	rolq	$0x17, %r12
    2333: 4d 31 fc                     	xorq	%r15, %r12
    2336: 49 89 ce                     	movq	%rcx, %r14
    2339: 49 31 d6                     	xorq	%rdx, %r14
    233c: 4d 21 d6                     	andq	%r10, %r14
    233f: 49 31 d6                     	xorq	%rdx, %r14
    2342: 4c 03 9d d8 fe ff ff         	addq	-0x128(%rbp), %r11
    2349: 4d 01 f3                     	addq	%r14, %r11
    234c: 49 be 53 ab 41 51 08 6c 37 1e	movabsq	$0x1e376c085141ab53, %r14 ## imm = 0x1E376C085141AB53
    2356: 4d 01 de                     	addq	%r11, %r14
    2359: 4d 89 cb                     	movq	%r9, %r11
    235c: 49 c1 c3 24                  	rolq	$0x24, %r11
    2360: 4d 01 e6                     	addq	%r12, %r14
    2363: 4d 89 cf                     	movq	%r9, %r15
    2366: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    236a: 4c 01 f3                     	addq	%r14, %rbx
    236d: 4d 89 cc                     	movq	%r9, %r12
    2370: 49 c1 c4 19                  	rolq	$0x19, %r12
    2374: 4d 31 df                     	xorq	%r11, %r15
    2377: 4d 31 fc                     	xorq	%r15, %r12
    237a: 4d 89 c7                     	movq	%r8, %r15
    237d: 49 09 f7                     	orq	%rsi, %r15
    2380: 4d 21 cf                     	andq	%r9, %r15
    2383: 4d 89 c3                     	movq	%r8, %r11
    2386: 49 21 f3                     	andq	%rsi, %r11
    2389: 4d 09 fb                     	orq	%r15, %r11
    238c: 4d 01 e3                     	addq	%r12, %r11
    238f: 49 89 df                     	movq	%rbx, %r15
    2392: 49 c1 c7 32                  	rolq	$0x32, %r15
    2396: 4d 01 f3                     	addq	%r14, %r11
    2399: 49 89 de                     	movq	%rbx, %r14
    239c: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    23a0: 4d 31 fe                     	xorq	%r15, %r14
    23a3: 49 89 df                     	movq	%rbx, %r15
    23a6: 49 c1 c7 17                  	rolq	$0x17, %r15
    23aa: 4d 31 f7                     	xorq	%r14, %r15
    23ad: 4d 89 d6                     	movq	%r10, %r14
    23b0: 49 31 ce                     	xorq	%rcx, %r14
    23b3: 49 21 de                     	andq	%rbx, %r14
    23b6: 49 31 ce                     	xorq	%rcx, %r14
    23b9: 48 03 95 e0 fe ff ff         	addq	-0x120(%rbp), %rdx
    23c0: 4c 01 f2                     	addq	%r14, %rdx
    23c3: 49 be 99 eb 8e df 4c 77 48 27	movabsq	$0x2748774cdf8eeb99, %r14 ## imm = 0x2748774CDF8EEB99
    23cd: 49 01 d6                     	addq	%rdx, %r14
    23d0: 4d 01 fe                     	addq	%r15, %r14
    23d3: 4c 01 f6                     	addq	%r14, %rsi
    23d6: 4c 89 da                     	movq	%r11, %rdx
    23d9: 48 c1 c2 24                  	rolq	$0x24, %rdx
    23dd: 4d 89 df                     	movq	%r11, %r15
    23e0: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    23e4: 49 31 d7                     	xorq	%rdx, %r15
    23e7: 4d 89 dc                     	movq	%r11, %r12
    23ea: 49 c1 c4 19                  	rolq	$0x19, %r12
    23ee: 4d 31 fc                     	xorq	%r15, %r12
    23f1: 4d 89 cf                     	movq	%r9, %r15
    23f4: 4d 09 c7                     	orq	%r8, %r15
    23f7: 4d 21 df                     	andq	%r11, %r15
    23fa: 4c 89 ca                     	movq	%r9, %rdx
    23fd: 4c 21 c2                     	andq	%r8, %rdx
    2400: 4c 09 fa                     	orq	%r15, %rdx
    2403: 49 89 f7                     	movq	%rsi, %r15
    2406: 49 c1 c7 32                  	rolq	$0x32, %r15
    240a: 4c 01 e2                     	addq	%r12, %rdx
    240d: 49 89 f4                     	movq	%rsi, %r12
    2410: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2414: 4c 01 f2                     	addq	%r14, %rdx
    2417: 49 89 f6                     	movq	%rsi, %r14
    241a: 49 c1 c6 17                  	rolq	$0x17, %r14
    241e: 4d 31 fc                     	xorq	%r15, %r12
    2421: 4d 31 e6                     	xorq	%r12, %r14
    2424: 49 89 df                     	movq	%rbx, %r15
    2427: 4d 31 d7                     	xorq	%r10, %r15
    242a: 49 21 f7                     	andq	%rsi, %r15
    242d: 4d 31 d7                     	xorq	%r10, %r15
    2430: 48 03 8d e8 fe ff ff         	addq	-0x118(%rbp), %rcx
    2437: 4c 01 f9                     	addq	%r15, %rcx
    243a: 49 bf a8 48 9b e1 b5 bc b0 34	movabsq	$0x34b0bcb5e19b48a8, %r15 ## imm = 0x34B0BCB5E19B48A8
    2444: 49 01 cf                     	addq	%rcx, %r15
    2447: 4d 01 f7                     	addq	%r14, %r15
    244a: 4d 01 f8                     	addq	%r15, %r8
    244d: 48 89 d1                     	movq	%rdx, %rcx
    2450: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2454: 49 89 d6                     	movq	%rdx, %r14
    2457: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    245b: 49 31 ce                     	xorq	%rcx, %r14
    245e: 49 89 d4                     	movq	%rdx, %r12
    2461: 49 c1 c4 19                  	rolq	$0x19, %r12
    2465: 4d 31 f4                     	xorq	%r14, %r12
    2468: 4d 89 de                     	movq	%r11, %r14
    246b: 4d 09 ce                     	orq	%r9, %r14
    246e: 49 21 d6                     	andq	%rdx, %r14
    2471: 4c 89 d9                     	movq	%r11, %rcx
    2474: 4c 21 c9                     	andq	%r9, %rcx
    2477: 4c 09 f1                     	orq	%r14, %rcx
    247a: 4c 01 e1                     	addq	%r12, %rcx
    247d: 4c 01 f9                     	addq	%r15, %rcx
    2480: 4d 89 c6                     	movq	%r8, %r14
    2483: 49 c1 c6 32                  	rolq	$0x32, %r14
    2487: 4d 89 c7                     	movq	%r8, %r15
    248a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    248e: 4d 31 f7                     	xorq	%r14, %r15
    2491: 4d 89 c4                     	movq	%r8, %r12
    2494: 49 c1 c4 17                  	rolq	$0x17, %r12
    2498: 4d 31 fc                     	xorq	%r15, %r12
    249b: 49 89 f6                     	movq	%rsi, %r14
    249e: 49 31 de                     	xorq	%rbx, %r14
    24a1: 4d 21 c6                     	andq	%r8, %r14
    24a4: 4c 03 95 f0 fe ff ff         	addq	-0x110(%rbp), %r10
    24ab: 49 31 de                     	xorq	%rbx, %r14
    24ae: 4d 01 f2                     	addq	%r14, %r10
    24b1: 49 be 63 5a c9 c5 b3 0c 1c 39	movabsq	$0x391c0cb3c5c95a63, %r14 ## imm = 0x391C0CB3C5C95A63
    24bb: 4d 01 d6                     	addq	%r10, %r14
    24be: 4d 01 e6                     	addq	%r12, %r14
    24c1: 49 89 ca                     	movq	%rcx, %r10
    24c4: 49 c1 c2 24                  	rolq	$0x24, %r10
    24c8: 4d 01 f1                     	addq	%r14, %r9
    24cb: 49 89 cf                     	movq	%rcx, %r15
    24ce: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    24d2: 4d 31 d7                     	xorq	%r10, %r15
    24d5: 49 89 cc                     	movq	%rcx, %r12
    24d8: 49 c1 c4 19                  	rolq	$0x19, %r12
    24dc: 4d 31 fc                     	xorq	%r15, %r12
    24df: 49 89 d7                     	movq	%rdx, %r15
    24e2: 4d 09 df                     	orq	%r11, %r15
    24e5: 49 21 cf                     	andq	%rcx, %r15
    24e8: 49 89 d2                     	movq	%rdx, %r10
    24eb: 4d 21 da                     	andq	%r11, %r10
    24ee: 4d 09 fa                     	orq	%r15, %r10
    24f1: 4d 01 e2                     	addq	%r12, %r10
    24f4: 4d 01 f2                     	addq	%r14, %r10
    24f7: 4d 89 ce                     	movq	%r9, %r14
    24fa: 49 c1 c6 32                  	rolq	$0x32, %r14
    24fe: 4d 89 cf                     	movq	%r9, %r15
    2501: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2505: 4d 31 f7                     	xorq	%r14, %r15
    2508: 4d 89 cc                     	movq	%r9, %r12
    250b: 49 c1 c4 17                  	rolq	$0x17, %r12
    250f: 4d 31 fc                     	xorq	%r15, %r12
    2512: 4d 89 c6                     	movq	%r8, %r14
    2515: 49 31 f6                     	xorq	%rsi, %r14
    2518: 4d 21 ce                     	andq	%r9, %r14
    251b: 49 31 f6                     	xorq	%rsi, %r14
    251e: 48 03 9d f8 fe ff ff         	addq	-0x108(%rbp), %rbx
    2525: 4c 01 f3                     	addq	%r14, %rbx
    2528: 49 be cb 8a 41 e3 4a aa d8 4e	movabsq	$0x4ed8aa4ae3418acb, %r14 ## imm = 0x4ED8AA4AE3418ACB
    2532: 49 01 de                     	addq	%rbx, %r14
    2535: 4c 89 d3                     	movq	%r10, %rbx
    2538: 48 c1 c3 24                  	rolq	$0x24, %rbx
    253c: 4d 01 e6                     	addq	%r12, %r14
    253f: 4d 89 d7                     	movq	%r10, %r15
    2542: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2546: 4d 01 f3                     	addq	%r14, %r11
    2549: 4d 89 d4                     	movq	%r10, %r12
    254c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2550: 49 31 df                     	xorq	%rbx, %r15
    2553: 4d 31 fc                     	xorq	%r15, %r12
    2556: 49 89 cf                     	movq	%rcx, %r15
    2559: 49 09 d7                     	orq	%rdx, %r15
    255c: 4d 21 d7                     	andq	%r10, %r15
    255f: 48 89 cb                     	movq	%rcx, %rbx
    2562: 48 21 d3                     	andq	%rdx, %rbx
    2565: 4c 09 fb                     	orq	%r15, %rbx
    2568: 4c 01 e3                     	addq	%r12, %rbx
    256b: 4d 89 df                     	movq	%r11, %r15
    256e: 49 c1 c7 32                  	rolq	$0x32, %r15
    2572: 4c 01 f3                     	addq	%r14, %rbx
    2575: 4d 89 de                     	movq	%r11, %r14
    2578: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    257c: 4d 31 fe                     	xorq	%r15, %r14
    257f: 4d 89 df                     	movq	%r11, %r15
    2582: 49 c1 c7 17                  	rolq	$0x17, %r15
    2586: 4d 31 f7                     	xorq	%r14, %r15
    2589: 4d 89 ce                     	movq	%r9, %r14
    258c: 4d 31 c6                     	xorq	%r8, %r14
    258f: 4d 21 de                     	andq	%r11, %r14
    2592: 4d 31 c6                     	xorq	%r8, %r14
    2595: 48 03 b5 00 ff ff ff         	addq	-0x100(%rbp), %rsi
    259c: 4c 01 f6                     	addq	%r14, %rsi
    259f: 49 be 73 e3 63 77 4f ca 9c 5b	movabsq	$0x5b9cca4f7763e373, %r14 ## imm = 0x5B9CCA4F7763E373
    25a9: 49 01 f6                     	addq	%rsi, %r14
    25ac: 4d 01 fe                     	addq	%r15, %r14
    25af: 4c 01 f2                     	addq	%r14, %rdx
    25b2: 48 89 de                     	movq	%rbx, %rsi
    25b5: 48 c1 c6 24                  	rolq	$0x24, %rsi
    25b9: 49 89 df                     	movq	%rbx, %r15
    25bc: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    25c0: 49 31 f7                     	xorq	%rsi, %r15
    25c3: 49 89 dc                     	movq	%rbx, %r12
    25c6: 49 c1 c4 19                  	rolq	$0x19, %r12
    25ca: 4d 31 fc                     	xorq	%r15, %r12
    25cd: 4d 89 d7                     	movq	%r10, %r15
    25d0: 49 09 cf                     	orq	%rcx, %r15
    25d3: 49 21 df                     	andq	%rbx, %r15
    25d6: 4c 89 d6                     	movq	%r10, %rsi
    25d9: 48 21 ce                     	andq	%rcx, %rsi
    25dc: 4c 09 fe                     	orq	%r15, %rsi
    25df: 49 89 d7                     	movq	%rdx, %r15
    25e2: 49 c1 c7 32                  	rolq	$0x32, %r15
    25e6: 4c 01 e6                     	addq	%r12, %rsi
    25e9: 49 89 d4                     	movq	%rdx, %r12
    25ec: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    25f0: 4c 01 f6                     	addq	%r14, %rsi
    25f3: 49 89 d6                     	movq	%rdx, %r14
    25f6: 49 c1 c6 17                  	rolq	$0x17, %r14
    25fa: 4d 31 fc                     	xorq	%r15, %r12
    25fd: 4d 31 e6                     	xorq	%r12, %r14
    2600: 4d 89 df                     	movq	%r11, %r15
    2603: 4d 31 cf                     	xorq	%r9, %r15
    2606: 49 21 d7                     	andq	%rdx, %r15
    2609: 4d 31 cf                     	xorq	%r9, %r15
    260c: 4c 03 85 08 ff ff ff         	addq	-0xf8(%rbp), %r8
    2613: 4d 01 f8                     	addq	%r15, %r8
    2616: 49 bf a3 b8 b2 d6 f3 6f 2e 68	movabsq	$0x682e6ff3d6b2b8a3, %r15 ## imm = 0x682E6FF3D6B2B8A3
    2620: 4d 01 c7                     	addq	%r8, %r15
    2623: 4d 01 f7                     	addq	%r14, %r15
    2626: 4c 01 f9                     	addq	%r15, %rcx
    2629: 49 89 f0                     	movq	%rsi, %r8
    262c: 49 c1 c0 24                  	rolq	$0x24, %r8
    2630: 49 89 f6                     	movq	%rsi, %r14
    2633: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2637: 4d 31 c6                     	xorq	%r8, %r14
    263a: 49 89 f4                     	movq	%rsi, %r12
    263d: 49 c1 c4 19                  	rolq	$0x19, %r12
    2641: 4d 31 f4                     	xorq	%r14, %r12
    2644: 49 89 de                     	movq	%rbx, %r14
    2647: 4d 09 d6                     	orq	%r10, %r14
    264a: 49 21 f6                     	andq	%rsi, %r14
    264d: 49 89 d8                     	movq	%rbx, %r8
    2650: 4d 21 d0                     	andq	%r10, %r8
    2653: 4d 09 f0                     	orq	%r14, %r8
    2656: 4d 01 e0                     	addq	%r12, %r8
    2659: 4d 01 f8                     	addq	%r15, %r8
    265c: 49 89 ce                     	movq	%rcx, %r14
    265f: 49 c1 c6 32                  	rolq	$0x32, %r14
    2663: 49 89 cf                     	movq	%rcx, %r15
    2666: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    266a: 4d 31 f7                     	xorq	%r14, %r15
    266d: 49 89 cc                     	movq	%rcx, %r12
    2670: 49 c1 c4 17                  	rolq	$0x17, %r12
    2674: 4d 31 fc                     	xorq	%r15, %r12
    2677: 49 89 d6                     	movq	%rdx, %r14
    267a: 4d 31 de                     	xorq	%r11, %r14
    267d: 49 21 ce                     	andq	%rcx, %r14
    2680: 4c 03 8d 10 ff ff ff         	addq	-0xf0(%rbp), %r9
    2687: 4d 31 de                     	xorq	%r11, %r14
    268a: 4d 01 f1                     	addq	%r14, %r9
    268d: 49 be fc b2 ef 5d ee 82 8f 74	movabsq	$0x748f82ee5defb2fc, %r14 ## imm = 0x748F82EE5DEFB2FC
    2697: 4d 01 ce                     	addq	%r9, %r14
    269a: 4d 01 e6                     	addq	%r12, %r14
    269d: 4d 89 c1                     	movq	%r8, %r9
    26a0: 49 c1 c1 24                  	rolq	$0x24, %r9
    26a4: 4d 01 f2                     	addq	%r14, %r10
    26a7: 4d 89 c7                     	movq	%r8, %r15
    26aa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    26ae: 4d 31 cf                     	xorq	%r9, %r15
    26b1: 4d 89 c4                     	movq	%r8, %r12
    26b4: 49 c1 c4 19                  	rolq	$0x19, %r12
    26b8: 4d 31 fc                     	xorq	%r15, %r12
    26bb: 49 89 f7                     	movq	%rsi, %r15
    26be: 49 09 df                     	orq	%rbx, %r15
    26c1: 4d 21 c7                     	andq	%r8, %r15
    26c4: 49 89 f1                     	movq	%rsi, %r9
    26c7: 49 21 d9                     	andq	%rbx, %r9
    26ca: 4d 09 f9                     	orq	%r15, %r9
    26cd: 4d 01 e1                     	addq	%r12, %r9
    26d0: 4d 01 f1                     	addq	%r14, %r9
    26d3: 4d 89 d6                     	movq	%r10, %r14
    26d6: 49 c1 c6 32                  	rolq	$0x32, %r14
    26da: 4d 89 d7                     	movq	%r10, %r15
    26dd: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    26e1: 4d 31 f7                     	xorq	%r14, %r15
    26e4: 4d 89 d4                     	movq	%r10, %r12
    26e7: 49 c1 c4 17                  	rolq	$0x17, %r12
    26eb: 4d 31 fc                     	xorq	%r15, %r12
    26ee: 49 89 ce                     	movq	%rcx, %r14
    26f1: 49 31 d6                     	xorq	%rdx, %r14
    26f4: 4d 21 d6                     	andq	%r10, %r14
    26f7: 49 31 d6                     	xorq	%rdx, %r14
    26fa: 4c 03 9d 18 ff ff ff         	addq	-0xe8(%rbp), %r11
    2701: 4d 01 f3                     	addq	%r14, %r11
    2704: 49 be 60 2f 17 43 6f 63 a5 78	movabsq	$0x78a5636f43172f60, %r14 ## imm = 0x78A5636F43172F60
    270e: 4d 01 de                     	addq	%r11, %r14
    2711: 4d 89 cb                     	movq	%r9, %r11
    2714: 49 c1 c3 24                  	rolq	$0x24, %r11
    2718: 4d 01 e6                     	addq	%r12, %r14
    271b: 4d 89 cf                     	movq	%r9, %r15
    271e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2722: 4c 01 f3                     	addq	%r14, %rbx
    2725: 4d 89 cc                     	movq	%r9, %r12
    2728: 49 c1 c4 19                  	rolq	$0x19, %r12
    272c: 4d 31 df                     	xorq	%r11, %r15
    272f: 4d 31 fc                     	xorq	%r15, %r12
    2732: 4d 89 c7                     	movq	%r8, %r15
    2735: 49 09 f7                     	orq	%rsi, %r15
    2738: 4d 21 cf                     	andq	%r9, %r15
    273b: 4d 89 c3                     	movq	%r8, %r11
    273e: 49 21 f3                     	andq	%rsi, %r11
    2741: 4d 09 fb                     	orq	%r15, %r11
    2744: 4d 01 e3                     	addq	%r12, %r11
    2747: 49 89 df                     	movq	%rbx, %r15
    274a: 49 c1 c7 32                  	rolq	$0x32, %r15
    274e: 4d 01 f3                     	addq	%r14, %r11
    2751: 49 89 de                     	movq	%rbx, %r14
    2754: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2758: 4d 31 fe                     	xorq	%r15, %r14
    275b: 49 89 df                     	movq	%rbx, %r15
    275e: 49 c1 c7 17                  	rolq	$0x17, %r15
    2762: 4d 31 f7                     	xorq	%r14, %r15
    2765: 4d 89 d6                     	movq	%r10, %r14
    2768: 49 31 ce                     	xorq	%rcx, %r14
    276b: 49 21 de                     	andq	%rbx, %r14
    276e: 49 31 ce                     	xorq	%rcx, %r14
    2771: 48 03 95 20 ff ff ff         	addq	-0xe0(%rbp), %rdx
    2778: 4c 01 f2                     	addq	%r14, %rdx
    277b: 49 be 72 ab f0 a1 14 78 c8 84	movabsq	$-0x7b3787eb5e0f548e, %r14 ## imm = 0x84C87814A1F0AB72
    2785: 49 01 d6                     	addq	%rdx, %r14
    2788: 4d 01 fe                     	addq	%r15, %r14
    278b: 4c 01 f6                     	addq	%r14, %rsi
    278e: 4c 89 da                     	movq	%r11, %rdx
    2791: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2795: 4d 89 df                     	movq	%r11, %r15
    2798: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    279c: 49 31 d7                     	xorq	%rdx, %r15
    279f: 4d 89 dc                     	movq	%r11, %r12
    27a2: 49 c1 c4 19                  	rolq	$0x19, %r12
    27a6: 4d 31 fc                     	xorq	%r15, %r12
    27a9: 4d 89 cf                     	movq	%r9, %r15
    27ac: 4d 09 c7                     	orq	%r8, %r15
    27af: 4d 21 df                     	andq	%r11, %r15
    27b2: 4c 89 ca                     	movq	%r9, %rdx
    27b5: 4c 21 c2                     	andq	%r8, %rdx
    27b8: 4c 09 fa                     	orq	%r15, %rdx
    27bb: 49 89 f7                     	movq	%rsi, %r15
    27be: 49 c1 c7 32                  	rolq	$0x32, %r15
    27c2: 4c 01 e2                     	addq	%r12, %rdx
    27c5: 49 89 f4                     	movq	%rsi, %r12
    27c8: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    27cc: 4c 01 f2                     	addq	%r14, %rdx
    27cf: 49 89 f6                     	movq	%rsi, %r14
    27d2: 49 c1 c6 17                  	rolq	$0x17, %r14
    27d6: 4d 31 fc                     	xorq	%r15, %r12
    27d9: 4d 31 e6                     	xorq	%r12, %r14
    27dc: 49 89 df                     	movq	%rbx, %r15
    27df: 4d 31 d7                     	xorq	%r10, %r15
    27e2: 49 21 f7                     	andq	%rsi, %r15
    27e5: 4d 31 d7                     	xorq	%r10, %r15
    27e8: 48 03 8d 28 ff ff ff         	addq	-0xd8(%rbp), %rcx
    27ef: 4c 01 f9                     	addq	%r15, %rcx
    27f2: 49 bf ec 39 64 1a 08 02 c7 8c	movabsq	$-0x7338fdf7e59bc614, %r15 ## imm = 0x8CC702081A6439EC
    27fc: 49 01 cf                     	addq	%rcx, %r15
    27ff: 4d 01 f7                     	addq	%r14, %r15
    2802: 4d 01 f8                     	addq	%r15, %r8
    2805: 48 89 d1                     	movq	%rdx, %rcx
    2808: 48 c1 c1 24                  	rolq	$0x24, %rcx
    280c: 49 89 d6                     	movq	%rdx, %r14
    280f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2813: 49 31 ce                     	xorq	%rcx, %r14
    2816: 49 89 d4                     	movq	%rdx, %r12
    2819: 49 c1 c4 19                  	rolq	$0x19, %r12
    281d: 4d 31 f4                     	xorq	%r14, %r12
    2820: 4d 89 de                     	movq	%r11, %r14
    2823: 4d 09 ce                     	orq	%r9, %r14
    2826: 49 21 d6                     	andq	%rdx, %r14
    2829: 4c 89 d9                     	movq	%r11, %rcx
    282c: 4c 21 c9                     	andq	%r9, %rcx
    282f: 4c 09 f1                     	orq	%r14, %rcx
    2832: 4c 01 e1                     	addq	%r12, %rcx
    2835: 4c 01 f9                     	addq	%r15, %rcx
    2838: 4d 89 c6                     	movq	%r8, %r14
    283b: 49 c1 c6 32                  	rolq	$0x32, %r14
    283f: 4d 89 c7                     	movq	%r8, %r15
    2842: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2846: 4d 31 f7                     	xorq	%r14, %r15
    2849: 4d 89 c4                     	movq	%r8, %r12
    284c: 49 c1 c4 17                  	rolq	$0x17, %r12
    2850: 4d 31 fc                     	xorq	%r15, %r12
    2853: 49 89 f6                     	movq	%rsi, %r14
    2856: 49 31 de                     	xorq	%rbx, %r14
    2859: 4d 21 c6                     	andq	%r8, %r14
    285c: 4c 03 95 30 ff ff ff         	addq	-0xd0(%rbp), %r10
    2863: 49 31 de                     	xorq	%rbx, %r14
    2866: 4d 01 f2                     	addq	%r14, %r10
    2869: 49 be 28 1e 63 23 fa ff be 90	movabsq	$-0x6f410005dc9ce1d8, %r14 ## imm = 0x90BEFFFA23631E28
    2873: 4d 01 d6                     	addq	%r10, %r14
    2876: 4d 01 e6                     	addq	%r12, %r14
    2879: 49 89 ca                     	movq	%rcx, %r10
    287c: 49 c1 c2 24                  	rolq	$0x24, %r10
    2880: 4d 01 f1                     	addq	%r14, %r9
    2883: 49 89 cf                     	movq	%rcx, %r15
    2886: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    288a: 4d 31 d7                     	xorq	%r10, %r15
    288d: 49 89 cc                     	movq	%rcx, %r12
    2890: 49 c1 c4 19                  	rolq	$0x19, %r12
    2894: 4d 31 fc                     	xorq	%r15, %r12
    2897: 49 89 d7                     	movq	%rdx, %r15
    289a: 4d 09 df                     	orq	%r11, %r15
    289d: 49 21 cf                     	andq	%rcx, %r15
    28a0: 49 89 d2                     	movq	%rdx, %r10
    28a3: 4d 21 da                     	andq	%r11, %r10
    28a6: 4d 09 fa                     	orq	%r15, %r10
    28a9: 4d 01 e2                     	addq	%r12, %r10
    28ac: 4d 01 f2                     	addq	%r14, %r10
    28af: 4d 89 ce                     	movq	%r9, %r14
    28b2: 49 c1 c6 32                  	rolq	$0x32, %r14
    28b6: 4d 89 cf                     	movq	%r9, %r15
    28b9: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    28bd: 4d 31 f7                     	xorq	%r14, %r15
    28c0: 4d 89 cc                     	movq	%r9, %r12
    28c3: 49 c1 c4 17                  	rolq	$0x17, %r12
    28c7: 4d 31 fc                     	xorq	%r15, %r12
    28ca: 4d 89 c6                     	movq	%r8, %r14
    28cd: 49 31 f6                     	xorq	%rsi, %r14
    28d0: 4d 21 ce                     	andq	%r9, %r14
    28d3: 49 31 f6                     	xorq	%rsi, %r14
    28d6: 48 03 9d 38 ff ff ff         	addq	-0xc8(%rbp), %rbx
    28dd: 4c 01 f3                     	addq	%r14, %rbx
    28e0: 49 be e9 bd 82 de eb 6c 50 a4	movabsq	$-0x5baf9314217d4217, %r14 ## imm = 0xA4506CEBDE82BDE9
    28ea: 49 01 de                     	addq	%rbx, %r14
    28ed: 4c 89 d3                     	movq	%r10, %rbx
    28f0: 48 c1 c3 24                  	rolq	$0x24, %rbx
    28f4: 4d 01 e6                     	addq	%r12, %r14
    28f7: 4d 89 d7                     	movq	%r10, %r15
    28fa: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    28fe: 4d 01 f3                     	addq	%r14, %r11
    2901: 4d 89 d4                     	movq	%r10, %r12
    2904: 49 c1 c4 19                  	rolq	$0x19, %r12
    2908: 49 31 df                     	xorq	%rbx, %r15
    290b: 4d 31 fc                     	xorq	%r15, %r12
    290e: 49 89 cf                     	movq	%rcx, %r15
    2911: 49 09 d7                     	orq	%rdx, %r15
    2914: 4d 21 d7                     	andq	%r10, %r15
    2917: 48 89 cb                     	movq	%rcx, %rbx
    291a: 48 21 d3                     	andq	%rdx, %rbx
    291d: 4c 09 fb                     	orq	%r15, %rbx
    2920: 4c 01 e3                     	addq	%r12, %rbx
    2923: 4d 89 df                     	movq	%r11, %r15
    2926: 49 c1 c7 32                  	rolq	$0x32, %r15
    292a: 4c 01 f3                     	addq	%r14, %rbx
    292d: 4d 89 de                     	movq	%r11, %r14
    2930: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2934: 4d 31 fe                     	xorq	%r15, %r14
    2937: 4d 89 df                     	movq	%r11, %r15
    293a: 49 c1 c7 17                  	rolq	$0x17, %r15
    293e: 4d 31 f7                     	xorq	%r14, %r15
    2941: 4d 89 ce                     	movq	%r9, %r14
    2944: 4d 31 c6                     	xorq	%r8, %r14
    2947: 4d 21 de                     	andq	%r11, %r14
    294a: 4d 31 c6                     	xorq	%r8, %r14
    294d: 48 03 b5 40 ff ff ff         	addq	-0xc0(%rbp), %rsi
    2954: 4c 01 f6                     	addq	%r14, %rsi
    2957: 49 be 15 79 c6 b2 f7 a3 f9 be	movabsq	$-0x41065c084d3986eb, %r14 ## imm = 0xBEF9A3F7B2C67915
    2961: 49 01 f6                     	addq	%rsi, %r14
    2964: 4d 01 fe                     	addq	%r15, %r14
    2967: 4c 01 f2                     	addq	%r14, %rdx
    296a: 48 89 de                     	movq	%rbx, %rsi
    296d: 48 c1 c6 24                  	rolq	$0x24, %rsi
    2971: 49 89 df                     	movq	%rbx, %r15
    2974: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2978: 49 31 f7                     	xorq	%rsi, %r15
    297b: 49 89 dc                     	movq	%rbx, %r12
    297e: 49 c1 c4 19                  	rolq	$0x19, %r12
    2982: 4d 31 fc                     	xorq	%r15, %r12
    2985: 4d 89 d7                     	movq	%r10, %r15
    2988: 49 09 cf                     	orq	%rcx, %r15
    298b: 49 21 df                     	andq	%rbx, %r15
    298e: 4c 89 d6                     	movq	%r10, %rsi
    2991: 48 21 ce                     	andq	%rcx, %rsi
    2994: 4c 09 fe                     	orq	%r15, %rsi
    2997: 49 89 d7                     	movq	%rdx, %r15
    299a: 49 c1 c7 32                  	rolq	$0x32, %r15
    299e: 4c 01 e6                     	addq	%r12, %rsi
    29a1: 49 89 d4                     	movq	%rdx, %r12
    29a4: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    29a8: 4c 01 f6                     	addq	%r14, %rsi
    29ab: 49 89 d6                     	movq	%rdx, %r14
    29ae: 49 c1 c6 17                  	rolq	$0x17, %r14
    29b2: 4d 31 fc                     	xorq	%r15, %r12
    29b5: 4d 31 e6                     	xorq	%r12, %r14
    29b8: 4d 89 df                     	movq	%r11, %r15
    29bb: 4d 31 cf                     	xorq	%r9, %r15
    29be: 49 21 d7                     	andq	%rdx, %r15
    29c1: 4d 31 cf                     	xorq	%r9, %r15
    29c4: 4c 03 85 48 ff ff ff         	addq	-0xb8(%rbp), %r8
    29cb: 4d 01 f8                     	addq	%r15, %r8
    29ce: 49 bf 2b 53 72 e3 f2 78 71 c6	movabsq	$-0x398e870d1c8dacd5, %r15 ## imm = 0xC67178F2E372532B
    29d8: 4d 01 c7                     	addq	%r8, %r15
    29db: 4d 01 f7                     	addq	%r14, %r15
    29de: 4c 01 f9                     	addq	%r15, %rcx
    29e1: 49 89 f0                     	movq	%rsi, %r8
    29e4: 49 c1 c0 24                  	rolq	$0x24, %r8
    29e8: 49 89 f6                     	movq	%rsi, %r14
    29eb: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    29ef: 4d 31 c6                     	xorq	%r8, %r14
    29f2: 49 89 f4                     	movq	%rsi, %r12
    29f5: 49 c1 c4 19                  	rolq	$0x19, %r12
    29f9: 4d 31 f4                     	xorq	%r14, %r12
    29fc: 49 89 de                     	movq	%rbx, %r14
    29ff: 4d 09 d6                     	orq	%r10, %r14
    2a02: 49 21 f6                     	andq	%rsi, %r14
    2a05: 49 89 d8                     	movq	%rbx, %r8
    2a08: 4d 21 d0                     	andq	%r10, %r8
    2a0b: 4d 09 f0                     	orq	%r14, %r8
    2a0e: 4d 01 e0                     	addq	%r12, %r8
    2a11: 4d 01 f8                     	addq	%r15, %r8
    2a14: 49 89 ce                     	movq	%rcx, %r14
    2a17: 49 c1 c6 32                  	rolq	$0x32, %r14
    2a1b: 49 89 cf                     	movq	%rcx, %r15
    2a1e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2a22: 4d 31 f7                     	xorq	%r14, %r15
    2a25: 49 89 cc                     	movq	%rcx, %r12
    2a28: 49 c1 c4 17                  	rolq	$0x17, %r12
    2a2c: 4d 31 fc                     	xorq	%r15, %r12
    2a2f: 49 89 d6                     	movq	%rdx, %r14
    2a32: 4d 31 de                     	xorq	%r11, %r14
    2a35: 49 21 ce                     	andq	%rcx, %r14
    2a38: 4c 03 8d 50 ff ff ff         	addq	-0xb0(%rbp), %r9
    2a3f: 4d 31 de                     	xorq	%r11, %r14
    2a42: 4d 01 f1                     	addq	%r14, %r9
    2a45: 49 be 9c 61 26 ea ce 3e 27 ca	movabsq	$-0x35d8c13115d99e64, %r14 ## imm = 0xCA273ECEEA26619C
    2a4f: 4d 01 ce                     	addq	%r9, %r14
    2a52: 4d 01 e6                     	addq	%r12, %r14
    2a55: 4d 89 c1                     	movq	%r8, %r9
    2a58: 49 c1 c1 24                  	rolq	$0x24, %r9
    2a5c: 4d 01 f2                     	addq	%r14, %r10
    2a5f: 4d 89 c7                     	movq	%r8, %r15
    2a62: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2a66: 4d 31 cf                     	xorq	%r9, %r15
    2a69: 4d 89 c4                     	movq	%r8, %r12
    2a6c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2a70: 4d 31 fc                     	xorq	%r15, %r12
    2a73: 49 89 f7                     	movq	%rsi, %r15
    2a76: 49 09 df                     	orq	%rbx, %r15
    2a79: 4d 21 c7                     	andq	%r8, %r15
    2a7c: 49 89 f1                     	movq	%rsi, %r9
    2a7f: 49 21 d9                     	andq	%rbx, %r9
    2a82: 4d 09 f9                     	orq	%r15, %r9
    2a85: 4d 01 e1                     	addq	%r12, %r9
    2a88: 4d 01 f1                     	addq	%r14, %r9
    2a8b: 4d 89 d6                     	movq	%r10, %r14
    2a8e: 49 c1 c6 32                  	rolq	$0x32, %r14
    2a92: 4d 89 d7                     	movq	%r10, %r15
    2a95: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2a99: 4d 31 f7                     	xorq	%r14, %r15
    2a9c: 4d 89 d4                     	movq	%r10, %r12
    2a9f: 49 c1 c4 17                  	rolq	$0x17, %r12
    2aa3: 4d 31 fc                     	xorq	%r15, %r12
    2aa6: 49 89 ce                     	movq	%rcx, %r14
    2aa9: 49 31 d6                     	xorq	%rdx, %r14
    2aac: 4d 21 d6                     	andq	%r10, %r14
    2aaf: 49 31 d6                     	xorq	%rdx, %r14
    2ab2: 4c 03 9d 58 ff ff ff         	addq	-0xa8(%rbp), %r11
    2ab9: 4d 01 f3                     	addq	%r14, %r11
    2abc: 49 be 07 c2 c0 21 c7 b8 86 d1	movabsq	$-0x2e794738de3f3df9, %r14 ## imm = 0xD186B8C721C0C207
    2ac6: 4d 01 de                     	addq	%r11, %r14
    2ac9: 4d 89 cb                     	movq	%r9, %r11
    2acc: 49 c1 c3 24                  	rolq	$0x24, %r11
    2ad0: 4d 01 e6                     	addq	%r12, %r14
    2ad3: 4d 89 cf                     	movq	%r9, %r15
    2ad6: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2ada: 4c 01 f3                     	addq	%r14, %rbx
    2add: 4d 89 cc                     	movq	%r9, %r12
    2ae0: 49 c1 c4 19                  	rolq	$0x19, %r12
    2ae4: 4d 31 df                     	xorq	%r11, %r15
    2ae7: 4d 31 fc                     	xorq	%r15, %r12
    2aea: 4d 89 c7                     	movq	%r8, %r15
    2aed: 49 09 f7                     	orq	%rsi, %r15
    2af0: 4d 21 cf                     	andq	%r9, %r15
    2af3: 4d 89 c3                     	movq	%r8, %r11
    2af6: 49 21 f3                     	andq	%rsi, %r11
    2af9: 4d 09 fb                     	orq	%r15, %r11
    2afc: 4d 01 e3                     	addq	%r12, %r11
    2aff: 49 89 df                     	movq	%rbx, %r15
    2b02: 49 c1 c7 32                  	rolq	$0x32, %r15
    2b06: 4d 01 f3                     	addq	%r14, %r11
    2b09: 49 89 de                     	movq	%rbx, %r14
    2b0c: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2b10: 4d 31 fe                     	xorq	%r15, %r14
    2b13: 49 89 df                     	movq	%rbx, %r15
    2b16: 49 c1 c7 17                  	rolq	$0x17, %r15
    2b1a: 4d 31 f7                     	xorq	%r14, %r15
    2b1d: 4d 89 d6                     	movq	%r10, %r14
    2b20: 49 31 ce                     	xorq	%rcx, %r14
    2b23: 49 21 de                     	andq	%rbx, %r14
    2b26: 49 31 ce                     	xorq	%rcx, %r14
    2b29: 48 03 95 60 ff ff ff         	addq	-0xa0(%rbp), %rdx
    2b30: 4c 01 f2                     	addq	%r14, %rdx
    2b33: 49 be 1e eb e0 cd d6 7d da ea	movabsq	$-0x15258229321f14e2, %r14 ## imm = 0xEADA7DD6CDE0EB1E
    2b3d: 49 01 d6                     	addq	%rdx, %r14
    2b40: 4d 01 fe                     	addq	%r15, %r14
    2b43: 4c 01 f6                     	addq	%r14, %rsi
    2b46: 4c 89 da                     	movq	%r11, %rdx
    2b49: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2b4d: 4d 89 df                     	movq	%r11, %r15
    2b50: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2b54: 49 31 d7                     	xorq	%rdx, %r15
    2b57: 4d 89 dc                     	movq	%r11, %r12
    2b5a: 49 c1 c4 19                  	rolq	$0x19, %r12
    2b5e: 4d 31 fc                     	xorq	%r15, %r12
    2b61: 4d 89 cf                     	movq	%r9, %r15
    2b64: 4d 09 c7                     	orq	%r8, %r15
    2b67: 4d 21 df                     	andq	%r11, %r15
    2b6a: 4c 89 ca                     	movq	%r9, %rdx
    2b6d: 4c 21 c2                     	andq	%r8, %rdx
    2b70: 4c 09 fa                     	orq	%r15, %rdx
    2b73: 49 89 f7                     	movq	%rsi, %r15
    2b76: 49 c1 c7 32                  	rolq	$0x32, %r15
    2b7a: 4c 01 e2                     	addq	%r12, %rdx
    2b7d: 49 89 f4                     	movq	%rsi, %r12
    2b80: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2b84: 4c 01 f2                     	addq	%r14, %rdx
    2b87: 49 89 f6                     	movq	%rsi, %r14
    2b8a: 49 c1 c6 17                  	rolq	$0x17, %r14
    2b8e: 4d 31 fc                     	xorq	%r15, %r12
    2b91: 4d 31 e6                     	xorq	%r12, %r14
    2b94: 49 89 df                     	movq	%rbx, %r15
    2b97: 4d 31 d7                     	xorq	%r10, %r15
    2b9a: 49 21 f7                     	andq	%rsi, %r15
    2b9d: 4d 31 d7                     	xorq	%r10, %r15
    2ba0: 48 03 8d 68 ff ff ff         	addq	-0x98(%rbp), %rcx
    2ba7: 4c 01 f9                     	addq	%r15, %rcx
    2baa: 49 bf 78 d1 6e ee 7f 4f 7d f5	movabsq	$-0xa82b08011912e88, %r15 ## imm = 0xF57D4F7FEE6ED178
    2bb4: 49 01 cf                     	addq	%rcx, %r15
    2bb7: 4d 01 f7                     	addq	%r14, %r15
    2bba: 4d 01 f8                     	addq	%r15, %r8
    2bbd: 48 89 d1                     	movq	%rdx, %rcx
    2bc0: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2bc4: 49 89 d6                     	movq	%rdx, %r14
    2bc7: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2bcb: 49 31 ce                     	xorq	%rcx, %r14
    2bce: 49 89 d4                     	movq	%rdx, %r12
    2bd1: 49 c1 c4 19                  	rolq	$0x19, %r12
    2bd5: 4d 31 f4                     	xorq	%r14, %r12
    2bd8: 4d 89 de                     	movq	%r11, %r14
    2bdb: 4d 09 ce                     	orq	%r9, %r14
    2bde: 49 21 d6                     	andq	%rdx, %r14
    2be1: 4c 89 d9                     	movq	%r11, %rcx
    2be4: 4c 21 c9                     	andq	%r9, %rcx
    2be7: 4c 09 f1                     	orq	%r14, %rcx
    2bea: 4c 01 e1                     	addq	%r12, %rcx
    2bed: 4c 01 f9                     	addq	%r15, %rcx
    2bf0: 4d 89 c6                     	movq	%r8, %r14
    2bf3: 49 c1 c6 32                  	rolq	$0x32, %r14
    2bf7: 4d 89 c7                     	movq	%r8, %r15
    2bfa: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2bfe: 4d 31 f7                     	xorq	%r14, %r15
    2c01: 4d 89 c4                     	movq	%r8, %r12
    2c04: 49 c1 c4 17                  	rolq	$0x17, %r12
    2c08: 4d 31 fc                     	xorq	%r15, %r12
    2c0b: 49 89 f6                     	movq	%rsi, %r14
    2c0e: 49 31 de                     	xorq	%rbx, %r14
    2c11: 4d 21 c6                     	andq	%r8, %r14
    2c14: 4c 03 95 70 ff ff ff         	addq	-0x90(%rbp), %r10
    2c1b: 49 31 de                     	xorq	%rbx, %r14
    2c1e: 4d 01 f2                     	addq	%r14, %r10
    2c21: 49 be ba 6f 17 72 aa 67 f0 06	movabsq	$0x6f067aa72176fba, %r14 ## imm = 0x6F067AA72176FBA
    2c2b: 4d 01 d6                     	addq	%r10, %r14
    2c2e: 4d 01 e6                     	addq	%r12, %r14
    2c31: 49 89 ca                     	movq	%rcx, %r10
    2c34: 49 c1 c2 24                  	rolq	$0x24, %r10
    2c38: 4d 01 f1                     	addq	%r14, %r9
    2c3b: 49 89 cf                     	movq	%rcx, %r15
    2c3e: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2c42: 4d 31 d7                     	xorq	%r10, %r15
    2c45: 49 89 cc                     	movq	%rcx, %r12
    2c48: 49 c1 c4 19                  	rolq	$0x19, %r12
    2c4c: 4d 31 fc                     	xorq	%r15, %r12
    2c4f: 49 89 d7                     	movq	%rdx, %r15
    2c52: 4d 09 df                     	orq	%r11, %r15
    2c55: 49 21 cf                     	andq	%rcx, %r15
    2c58: 49 89 d2                     	movq	%rdx, %r10
    2c5b: 4d 21 da                     	andq	%r11, %r10
    2c5e: 4d 09 fa                     	orq	%r15, %r10
    2c61: 4d 01 e2                     	addq	%r12, %r10
    2c64: 4d 01 f2                     	addq	%r14, %r10
    2c67: 4d 89 ce                     	movq	%r9, %r14
    2c6a: 49 c1 c6 32                  	rolq	$0x32, %r14
    2c6e: 4d 89 cf                     	movq	%r9, %r15
    2c71: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2c75: 4d 31 f7                     	xorq	%r14, %r15
    2c78: 4d 89 cc                     	movq	%r9, %r12
    2c7b: 49 c1 c4 17                  	rolq	$0x17, %r12
    2c7f: 4d 31 fc                     	xorq	%r15, %r12
    2c82: 4d 89 c6                     	movq	%r8, %r14
    2c85: 49 31 f6                     	xorq	%rsi, %r14
    2c88: 4d 21 ce                     	andq	%r9, %r14
    2c8b: 49 31 f6                     	xorq	%rsi, %r14
    2c8e: 48 03 9d 78 ff ff ff         	addq	-0x88(%rbp), %rbx
    2c95: 4c 01 f3                     	addq	%r14, %rbx
    2c98: 49 be a6 98 c8 a2 c5 7d 63 0a	movabsq	$0xa637dc5a2c898a6, %r14 ## imm = 0xA637DC5A2C898A6
    2ca2: 49 01 de                     	addq	%rbx, %r14
    2ca5: 4c 89 d3                     	movq	%r10, %rbx
    2ca8: 48 c1 c3 24                  	rolq	$0x24, %rbx
    2cac: 4d 01 e6                     	addq	%r12, %r14
    2caf: 4d 89 d7                     	movq	%r10, %r15
    2cb2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2cb6: 4d 01 f3                     	addq	%r14, %r11
    2cb9: 4d 89 d4                     	movq	%r10, %r12
    2cbc: 49 c1 c4 19                  	rolq	$0x19, %r12
    2cc0: 49 31 df                     	xorq	%rbx, %r15
    2cc3: 4d 31 fc                     	xorq	%r15, %r12
    2cc6: 49 89 cf                     	movq	%rcx, %r15
    2cc9: 49 09 d7                     	orq	%rdx, %r15
    2ccc: 4d 21 d7                     	andq	%r10, %r15
    2ccf: 48 89 cb                     	movq	%rcx, %rbx
    2cd2: 48 21 d3                     	andq	%rdx, %rbx
    2cd5: 4c 09 fb                     	orq	%r15, %rbx
    2cd8: 4c 01 e3                     	addq	%r12, %rbx
    2cdb: 4d 89 df                     	movq	%r11, %r15
    2cde: 49 c1 c7 32                  	rolq	$0x32, %r15
    2ce2: 4c 01 f3                     	addq	%r14, %rbx
    2ce5: 4d 89 de                     	movq	%r11, %r14
    2ce8: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2cec: 4d 31 fe                     	xorq	%r15, %r14
    2cef: 4d 89 df                     	movq	%r11, %r15
    2cf2: 49 c1 c7 17                  	rolq	$0x17, %r15
    2cf6: 4d 31 f7                     	xorq	%r14, %r15
    2cf9: 4d 89 ce                     	movq	%r9, %r14
    2cfc: 4d 31 c6                     	xorq	%r8, %r14
    2cff: 4d 21 de                     	andq	%r11, %r14
    2d02: 4d 31 c6                     	xorq	%r8, %r14
    2d05: 48 03 75 80                  	addq	-0x80(%rbp), %rsi
    2d09: 4c 01 f6                     	addq	%r14, %rsi
    2d0c: 49 be ae 0d f9 be 04 98 3f 11	movabsq	$0x113f9804bef90dae, %r14 ## imm = 0x113F9804BEF90DAE
    2d16: 49 01 f6                     	addq	%rsi, %r14
    2d19: 4d 01 fe                     	addq	%r15, %r14
    2d1c: 4c 01 f2                     	addq	%r14, %rdx
    2d1f: 48 89 de                     	movq	%rbx, %rsi
    2d22: 48 c1 c6 24                  	rolq	$0x24, %rsi
    2d26: 49 89 df                     	movq	%rbx, %r15
    2d29: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2d2d: 49 31 f7                     	xorq	%rsi, %r15
    2d30: 49 89 dc                     	movq	%rbx, %r12
    2d33: 49 c1 c4 19                  	rolq	$0x19, %r12
    2d37: 4d 31 fc                     	xorq	%r15, %r12
    2d3a: 4d 89 d7                     	movq	%r10, %r15
    2d3d: 49 09 cf                     	orq	%rcx, %r15
    2d40: 49 21 df                     	andq	%rbx, %r15
    2d43: 4c 89 d6                     	movq	%r10, %rsi
    2d46: 48 21 ce                     	andq	%rcx, %rsi
    2d49: 4c 09 fe                     	orq	%r15, %rsi
    2d4c: 49 89 d7                     	movq	%rdx, %r15
    2d4f: 49 c1 c7 32                  	rolq	$0x32, %r15
    2d53: 4c 01 e6                     	addq	%r12, %rsi
    2d56: 49 89 d4                     	movq	%rdx, %r12
    2d59: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2d5d: 4c 01 f6                     	addq	%r14, %rsi
    2d60: 49 89 d6                     	movq	%rdx, %r14
    2d63: 49 c1 c6 17                  	rolq	$0x17, %r14
    2d67: 4d 31 fc                     	xorq	%r15, %r12
    2d6a: 4d 31 e6                     	xorq	%r12, %r14
    2d6d: 4d 89 df                     	movq	%r11, %r15
    2d70: 4d 31 cf                     	xorq	%r9, %r15
    2d73: 49 21 d7                     	andq	%rdx, %r15
    2d76: 4d 31 cf                     	xorq	%r9, %r15
    2d79: 4c 03 45 88                  	addq	-0x78(%rbp), %r8
    2d7d: 4d 01 f8                     	addq	%r15, %r8
    2d80: 49 bf 1b 47 1c 13 35 0b 71 1b	movabsq	$0x1b710b35131c471b, %r15 ## imm = 0x1B710B35131C471B
    2d8a: 4d 01 c7                     	addq	%r8, %r15
    2d8d: 4d 01 f7                     	addq	%r14, %r15
    2d90: 4c 01 f9                     	addq	%r15, %rcx
    2d93: 49 89 f0                     	movq	%rsi, %r8
    2d96: 49 c1 c0 24                  	rolq	$0x24, %r8
    2d9a: 49 89 f6                     	movq	%rsi, %r14
    2d9d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2da1: 4d 31 c6                     	xorq	%r8, %r14
    2da4: 49 89 f4                     	movq	%rsi, %r12
    2da7: 49 c1 c4 19                  	rolq	$0x19, %r12
    2dab: 4d 31 f4                     	xorq	%r14, %r12
    2dae: 49 89 de                     	movq	%rbx, %r14
    2db1: 4d 09 d6                     	orq	%r10, %r14
    2db4: 49 21 f6                     	andq	%rsi, %r14
    2db7: 49 89 d8                     	movq	%rbx, %r8
    2dba: 4d 21 d0                     	andq	%r10, %r8
    2dbd: 4d 09 f0                     	orq	%r14, %r8
    2dc0: 4d 01 e0                     	addq	%r12, %r8
    2dc3: 4d 01 f8                     	addq	%r15, %r8
    2dc6: 49 89 ce                     	movq	%rcx, %r14
    2dc9: 49 c1 c6 32                  	rolq	$0x32, %r14
    2dcd: 49 89 cf                     	movq	%rcx, %r15
    2dd0: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2dd4: 4d 31 f7                     	xorq	%r14, %r15
    2dd7: 49 89 cc                     	movq	%rcx, %r12
    2dda: 49 c1 c4 17                  	rolq	$0x17, %r12
    2dde: 4d 31 fc                     	xorq	%r15, %r12
    2de1: 49 89 d6                     	movq	%rdx, %r14
    2de4: 4d 31 de                     	xorq	%r11, %r14
    2de7: 49 21 ce                     	andq	%rcx, %r14
    2dea: 4c 03 4d 90                  	addq	-0x70(%rbp), %r9
    2dee: 4d 31 de                     	xorq	%r11, %r14
    2df1: 4d 01 f1                     	addq	%r14, %r9
    2df4: 49 be 84 7d 04 23 f5 77 db 28	movabsq	$0x28db77f523047d84, %r14 ## imm = 0x28DB77F523047D84
    2dfe: 4d 01 ce                     	addq	%r9, %r14
    2e01: 4d 01 e6                     	addq	%r12, %r14
    2e04: 4d 89 c1                     	movq	%r8, %r9
    2e07: 49 c1 c1 24                  	rolq	$0x24, %r9
    2e0b: 4d 01 f2                     	addq	%r14, %r10
    2e0e: 4d 89 c7                     	movq	%r8, %r15
    2e11: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2e15: 4d 31 cf                     	xorq	%r9, %r15
    2e18: 4d 89 c4                     	movq	%r8, %r12
    2e1b: 49 c1 c4 19                  	rolq	$0x19, %r12
    2e1f: 4d 31 fc                     	xorq	%r15, %r12
    2e22: 49 89 f7                     	movq	%rsi, %r15
    2e25: 49 09 df                     	orq	%rbx, %r15
    2e28: 4d 21 c7                     	andq	%r8, %r15
    2e2b: 49 89 f1                     	movq	%rsi, %r9
    2e2e: 49 21 d9                     	andq	%rbx, %r9
    2e31: 4d 09 f9                     	orq	%r15, %r9
    2e34: 4d 01 e1                     	addq	%r12, %r9
    2e37: 4d 01 f1                     	addq	%r14, %r9
    2e3a: 4d 89 d6                     	movq	%r10, %r14
    2e3d: 49 c1 c6 32                  	rolq	$0x32, %r14
    2e41: 4d 89 d7                     	movq	%r10, %r15
    2e44: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2e48: 4d 31 f7                     	xorq	%r14, %r15
    2e4b: 4d 89 d4                     	movq	%r10, %r12
    2e4e: 49 c1 c4 17                  	rolq	$0x17, %r12
    2e52: 4d 31 fc                     	xorq	%r15, %r12
    2e55: 49 89 ce                     	movq	%rcx, %r14
    2e58: 49 31 d6                     	xorq	%rdx, %r14
    2e5b: 4d 21 d6                     	andq	%r10, %r14
    2e5e: 49 31 d6                     	xorq	%rdx, %r14
    2e61: 4c 03 5d 98                  	addq	-0x68(%rbp), %r11
    2e65: 4d 01 f3                     	addq	%r14, %r11
    2e68: 49 be 93 24 c7 40 7b ab ca 32	movabsq	$0x32caab7b40c72493, %r14 ## imm = 0x32CAAB7B40C72493
    2e72: 4d 01 de                     	addq	%r11, %r14
    2e75: 4d 89 cb                     	movq	%r9, %r11
    2e78: 49 c1 c3 24                  	rolq	$0x24, %r11
    2e7c: 4d 01 e6                     	addq	%r12, %r14
    2e7f: 4d 89 cf                     	movq	%r9, %r15
    2e82: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2e86: 4c 01 f3                     	addq	%r14, %rbx
    2e89: 4d 89 cc                     	movq	%r9, %r12
    2e8c: 49 c1 c4 19                  	rolq	$0x19, %r12
    2e90: 4d 31 df                     	xorq	%r11, %r15
    2e93: 4d 31 fc                     	xorq	%r15, %r12
    2e96: 4d 89 c7                     	movq	%r8, %r15
    2e99: 49 09 f7                     	orq	%rsi, %r15
    2e9c: 4d 21 cf                     	andq	%r9, %r15
    2e9f: 4d 89 c3                     	movq	%r8, %r11
    2ea2: 49 21 f3                     	andq	%rsi, %r11
    2ea5: 4d 09 fb                     	orq	%r15, %r11
    2ea8: 4d 01 e3                     	addq	%r12, %r11
    2eab: 49 89 df                     	movq	%rbx, %r15
    2eae: 49 c1 c7 32                  	rolq	$0x32, %r15
    2eb2: 4d 01 f3                     	addq	%r14, %r11
    2eb5: 49 89 de                     	movq	%rbx, %r14
    2eb8: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    2ebc: 4d 31 fe                     	xorq	%r15, %r14
    2ebf: 49 89 df                     	movq	%rbx, %r15
    2ec2: 49 c1 c7 17                  	rolq	$0x17, %r15
    2ec6: 4d 31 f7                     	xorq	%r14, %r15
    2ec9: 4d 89 d6                     	movq	%r10, %r14
    2ecc: 49 31 ce                     	xorq	%rcx, %r14
    2ecf: 49 21 de                     	andq	%rbx, %r14
    2ed2: 49 31 ce                     	xorq	%rcx, %r14
    2ed5: 48 03 55 a0                  	addq	-0x60(%rbp), %rdx
    2ed9: 4c 01 f2                     	addq	%r14, %rdx
    2edc: 49 be bc be c9 15 0a be 9e 3c	movabsq	$0x3c9ebe0a15c9bebc, %r14 ## imm = 0x3C9EBE0A15C9BEBC
    2ee6: 49 01 d6                     	addq	%rdx, %r14
    2ee9: 4d 01 fe                     	addq	%r15, %r14
    2eec: 4c 01 f6                     	addq	%r14, %rsi
    2eef: 4c 89 da                     	movq	%r11, %rdx
    2ef2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    2ef6: 4d 89 df                     	movq	%r11, %r15
    2ef9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2efd: 49 31 d7                     	xorq	%rdx, %r15
    2f00: 4d 89 dc                     	movq	%r11, %r12
    2f03: 49 c1 c4 19                  	rolq	$0x19, %r12
    2f07: 4d 31 fc                     	xorq	%r15, %r12
    2f0a: 4d 89 cf                     	movq	%r9, %r15
    2f0d: 4d 09 c7                     	orq	%r8, %r15
    2f10: 4d 21 df                     	andq	%r11, %r15
    2f13: 4c 89 ca                     	movq	%r9, %rdx
    2f16: 4c 21 c2                     	andq	%r8, %rdx
    2f19: 4c 09 fa                     	orq	%r15, %rdx
    2f1c: 49 89 f7                     	movq	%rsi, %r15
    2f1f: 49 c1 c7 32                  	rolq	$0x32, %r15
    2f23: 4c 01 e2                     	addq	%r12, %rdx
    2f26: 49 89 f4                     	movq	%rsi, %r12
    2f29: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    2f2d: 4c 01 f2                     	addq	%r14, %rdx
    2f30: 49 89 f6                     	movq	%rsi, %r14
    2f33: 49 c1 c6 17                  	rolq	$0x17, %r14
    2f37: 4d 31 fc                     	xorq	%r15, %r12
    2f3a: 4d 31 e6                     	xorq	%r12, %r14
    2f3d: 49 89 df                     	movq	%rbx, %r15
    2f40: 4d 31 d7                     	xorq	%r10, %r15
    2f43: 49 21 f7                     	andq	%rsi, %r15
    2f46: 4d 31 d7                     	xorq	%r10, %r15
    2f49: 48 03 4d a8                  	addq	-0x58(%rbp), %rcx
    2f4d: 4c 01 f9                     	addq	%r15, %rcx
    2f50: 49 bf 4c 0d 10 9c c4 67 1d 43	movabsq	$0x431d67c49c100d4c, %r15 ## imm = 0x431D67C49C100D4C
    2f5a: 49 01 cf                     	addq	%rcx, %r15
    2f5d: 4d 01 f7                     	addq	%r14, %r15
    2f60: 4d 01 f8                     	addq	%r15, %r8
    2f63: 48 89 d1                     	movq	%rdx, %rcx
    2f66: 48 c1 c1 24                  	rolq	$0x24, %rcx
    2f6a: 49 89 d6                     	movq	%rdx, %r14
    2f6d: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    2f71: 49 31 ce                     	xorq	%rcx, %r14
    2f74: 49 89 d4                     	movq	%rdx, %r12
    2f77: 49 c1 c4 19                  	rolq	$0x19, %r12
    2f7b: 4d 31 f4                     	xorq	%r14, %r12
    2f7e: 4d 89 de                     	movq	%r11, %r14
    2f81: 4d 09 ce                     	orq	%r9, %r14
    2f84: 49 21 d6                     	andq	%rdx, %r14
    2f87: 4c 89 d9                     	movq	%r11, %rcx
    2f8a: 4c 21 c9                     	andq	%r9, %rcx
    2f8d: 4c 09 f1                     	orq	%r14, %rcx
    2f90: 4c 01 e1                     	addq	%r12, %rcx
    2f93: 4c 01 f9                     	addq	%r15, %rcx
    2f96: 4d 89 c6                     	movq	%r8, %r14
    2f99: 49 c1 c6 32                  	rolq	$0x32, %r14
    2f9d: 4d 89 c7                     	movq	%r8, %r15
    2fa0: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    2fa4: 4d 31 f7                     	xorq	%r14, %r15
    2fa7: 4d 89 c4                     	movq	%r8, %r12
    2faa: 49 c1 c4 17                  	rolq	$0x17, %r12
    2fae: 4d 31 fc                     	xorq	%r15, %r12
    2fb1: 49 89 f6                     	movq	%rsi, %r14
    2fb4: 49 31 de                     	xorq	%rbx, %r14
    2fb7: 4d 21 c6                     	andq	%r8, %r14
    2fba: 4c 03 55 b0                  	addq	-0x50(%rbp), %r10
    2fbe: 49 31 de                     	xorq	%rbx, %r14
    2fc1: 4d 01 f2                     	addq	%r14, %r10
    2fc4: 49 be b6 42 3e cb be d4 c5 4c	movabsq	$0x4cc5d4becb3e42b6, %r14 ## imm = 0x4CC5D4BECB3E42B6
    2fce: 4d 01 d6                     	addq	%r10, %r14
    2fd1: 4d 01 e6                     	addq	%r12, %r14
    2fd4: 49 89 ca                     	movq	%rcx, %r10
    2fd7: 49 c1 c2 24                  	rolq	$0x24, %r10
    2fdb: 4d 01 f1                     	addq	%r14, %r9
    2fde: 49 89 cf                     	movq	%rcx, %r15
    2fe1: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    2fe5: 4d 31 d7                     	xorq	%r10, %r15
    2fe8: 49 89 cc                     	movq	%rcx, %r12
    2feb: 49 c1 c4 19                  	rolq	$0x19, %r12
    2fef: 4d 31 fc                     	xorq	%r15, %r12
    2ff2: 49 89 d7                     	movq	%rdx, %r15
    2ff5: 4d 09 df                     	orq	%r11, %r15
    2ff8: 49 21 cf                     	andq	%rcx, %r15
    2ffb: 49 89 d2                     	movq	%rdx, %r10
    2ffe: 4d 21 da                     	andq	%r11, %r10
    3001: 4d 09 fa                     	orq	%r15, %r10
    3004: 4d 01 e2                     	addq	%r12, %r10
    3007: 4d 01 f2                     	addq	%r14, %r10
    300a: 4d 89 ce                     	movq	%r9, %r14
    300d: 49 c1 c6 32                  	rolq	$0x32, %r14
    3011: 4d 89 cf                     	movq	%r9, %r15
    3014: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3018: 4d 31 f7                     	xorq	%r14, %r15
    301b: 4d 89 cc                     	movq	%r9, %r12
    301e: 49 c1 c4 17                  	rolq	$0x17, %r12
    3022: 4d 31 fc                     	xorq	%r15, %r12
    3025: 4d 89 c6                     	movq	%r8, %r14
    3028: 49 31 f6                     	xorq	%rsi, %r14
    302b: 4d 21 ce                     	andq	%r9, %r14
    302e: 49 31 f6                     	xorq	%rsi, %r14
    3031: 48 03 5d b8                  	addq	-0x48(%rbp), %rbx
    3035: 4c 01 f3                     	addq	%r14, %rbx
    3038: 49 be 2a 7e 65 fc 9c 29 7f 59	movabsq	$0x597f299cfc657e2a, %r14 ## imm = 0x597F299CFC657E2A
    3042: 49 01 de                     	addq	%rbx, %r14
    3045: 4c 89 d3                     	movq	%r10, %rbx
    3048: 48 c1 c3 24                  	rolq	$0x24, %rbx
    304c: 4d 01 e6                     	addq	%r12, %r14
    304f: 4d 89 d7                     	movq	%r10, %r15
    3052: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3056: 4d 01 f3                     	addq	%r14, %r11
    3059: 4d 89 d4                     	movq	%r10, %r12
    305c: 49 c1 c4 19                  	rolq	$0x19, %r12
    3060: 49 31 df                     	xorq	%rbx, %r15
    3063: 4d 31 fc                     	xorq	%r15, %r12
    3066: 49 89 cf                     	movq	%rcx, %r15
    3069: 49 09 d7                     	orq	%rdx, %r15
    306c: 4d 21 d7                     	andq	%r10, %r15
    306f: 48 89 cb                     	movq	%rcx, %rbx
    3072: 48 21 d3                     	andq	%rdx, %rbx
    3075: 4c 09 fb                     	orq	%r15, %rbx
    3078: 4c 01 e3                     	addq	%r12, %rbx
    307b: 4d 89 df                     	movq	%r11, %r15
    307e: 49 c1 c7 32                  	rolq	$0x32, %r15
    3082: 4c 01 f3                     	addq	%r14, %rbx
    3085: 4d 89 de                     	movq	%r11, %r14
    3088: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    308c: 4d 31 fe                     	xorq	%r15, %r14
    308f: 4d 89 df                     	movq	%r11, %r15
    3092: 49 c1 c7 17                  	rolq	$0x17, %r15
    3096: 4d 31 f7                     	xorq	%r14, %r15
    3099: 4d 89 ce                     	movq	%r9, %r14
    309c: 4d 31 c6                     	xorq	%r8, %r14
    309f: 4d 21 de                     	andq	%r11, %r14
    30a2: 4d 31 c6                     	xorq	%r8, %r14
    30a5: 48 03 75 c0                  	addq	-0x40(%rbp), %rsi
    30a9: 4c 01 f6                     	addq	%r14, %rsi
    30ac: 49 be ec fa d6 3a ab 6f cb 5f	movabsq	$0x5fcb6fab3ad6faec, %r14 ## imm = 0x5FCB6FAB3AD6FAEC
    30b6: 49 01 f6                     	addq	%rsi, %r14
    30b9: 4d 01 fe                     	addq	%r15, %r14
    30bc: 4c 01 f2                     	addq	%r14, %rdx
    30bf: 48 89 de                     	movq	%rbx, %rsi
    30c2: 48 c1 c6 24                  	rolq	$0x24, %rsi
    30c6: 49 89 df                     	movq	%rbx, %r15
    30c9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    30cd: 49 31 f7                     	xorq	%rsi, %r15
    30d0: 49 89 dc                     	movq	%rbx, %r12
    30d3: 49 c1 c4 19                  	rolq	$0x19, %r12
    30d7: 4d 31 fc                     	xorq	%r15, %r12
    30da: 4d 89 d7                     	movq	%r10, %r15
    30dd: 49 09 cf                     	orq	%rcx, %r15
    30e0: 49 21 df                     	andq	%rbx, %r15
    30e3: 4c 89 d6                     	movq	%r10, %rsi
    30e6: 48 21 ce                     	andq	%rcx, %rsi
    30e9: 4c 09 fe                     	orq	%r15, %rsi
    30ec: 49 89 d7                     	movq	%rdx, %r15
    30ef: 49 c1 c7 32                  	rolq	$0x32, %r15
    30f3: 4c 01 e6                     	addq	%r12, %rsi
    30f6: 49 89 d4                     	movq	%rdx, %r12
    30f9: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    30fd: 4c 01 f6                     	addq	%r14, %rsi
    3100: 49 89 d5                     	movq	%rdx, %r13
    3103: 49 c1 c5 17                  	rolq	$0x17, %r13
    3107: 4d 31 fc                     	xorq	%r15, %r12
    310a: 4d 31 e5                     	xorq	%r12, %r13
    310d: 4d 89 de                     	movq	%r11, %r14
    3110: 4d 31 ce                     	xorq	%r9, %r14
    3113: 49 21 d6                     	andq	%rdx, %r14
    3116: 4d 31 ce                     	xorq	%r9, %r14
    3119: 4c 03 45 c8                  	addq	-0x38(%rbp), %r8
    311d: 4d 01 f0                     	addq	%r14, %r8
    3120: 49 be 17 58 47 4a 8c 19 44 6c	movabsq	$0x6c44198c4a475817, %r14 ## imm = 0x6C44198C4A475817
    312a: 4d 01 c6                     	addq	%r8, %r14
    312d: 4d 01 ee                     	addq	%r13, %r14
    3130: 49 89 f0                     	movq	%rsi, %r8
    3133: 49 c1 c0 24                  	rolq	$0x24, %r8
    3137: 49 89 f7                     	movq	%rsi, %r15
    313a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    313e: 4d 31 c7                     	xorq	%r8, %r15
    3141: 49 89 f0                     	movq	%rsi, %r8
    3144: 49 c1 c0 19                  	rolq	$0x19, %r8
    3148: 4d 31 f8                     	xorq	%r15, %r8
    314b: 49 89 df                     	movq	%rbx, %r15
    314e: 4d 09 d7                     	orq	%r10, %r15
    3151: 49 21 f7                     	andq	%rsi, %r15
    3154: 49 89 dc                     	movq	%rbx, %r12
    3157: 4d 21 d4                     	andq	%r10, %r12
    315a: 4d 09 fc                     	orq	%r15, %r12
    315d: 4d 01 c4                     	addq	%r8, %r12
    3160: 4d 01 f4                     	addq	%r14, %r12
    3163: 49 01 c4                     	addq	%rax, %r12
    3166: 4c 89 67 10                  	movq	%r12, 0x10(%rdi)
    316a: 48 01 77 18                  	addq	%rsi, 0x18(%rdi)
    316e: 48 01 5f 20                  	addq	%rbx, 0x20(%rdi)
    3172: 4c 01 57 28                  	addq	%r10, 0x28(%rdi)
    3176: 4c 01 f1                     	addq	%r14, %rcx
    3179: 48 01 4f 30                  	addq	%rcx, 0x30(%rdi)
    317d: 48 01 57 38                  	addq	%rdx, 0x38(%rdi)
    3181: 4c 01 5f 40                  	addq	%r11, 0x40(%rdi)
    3185: 4c 01 4f 48                  	addq	%r9, 0x48(%rdi)
    3189: 48 81 c4 08 02 00 00         	addq	$0x208, %rsp            ## imm = 0x208
    3190: 5b                           	popq	%rbx
    3191: 41 5c                        	popq	%r12
    3193: 41 5d                        	popq	%r13
    3195: 41 5e                        	popq	%r14
    3197: 41 5f                        	popq	%r15
    3199: 5d                           	popq	%rbp
    319a: c3                           	retq
    319b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

00000000000031a0 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    31a0: 55                           	pushq	%rbp
    31a1: 48 89 e5                     	movq	%rsp, %rbp
    31a4: 41 57                        	pushq	%r15
    31a6: 41 56                        	pushq	%r14
    31a8: 53                           	pushq	%rbx
    31a9: 50                           	pushq	%rax
    31aa: 48 89 f3                     	movq	%rsi, %rbx
    31ad: 49 89 fe                     	movq	%rdi, %r14
    31b0: 4c 8d 7f 50                  	leaq	0x50(%rdi), %r15
    31b4: 0f b6 87 d0 00 00 00         	movzbl	0xd0(%rdi), %eax
    31bb: 48 8d 7c 07 50               	leaq	0x50(%rdi,%rax), %rdi
    31c0: be 80 00 00 00               	movl	$0x80, %esi
    31c5: 48 29 c6                     	subq	%rax, %rsi
    31c8: e8 00 00 00 00               	callq	 <L0>
		00000000000031c9:  X86_64_RELOC_BRANCH	___bzero
<L0>:
    31cd: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    31d5: 41 c6 44 06 50 80            	movb	$-0x80, 0x50(%r14,%rax)
    31db: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    31e3: 8d 48 01                     	leal	0x1(%rax), %ecx
    31e6: 41 88 8e d0 00 00 00         	movb	%cl, 0xd0(%r14)
    31ed: 3c 6f                        	cmpb	$0x6f, %al
    31ef: 76 30                        	jbe	 <L2>
    31f1: 4c 89 f7                     	movq	%r14, %rdi
    31f4: 4c 89 fe                     	movq	%r15, %rsi
    31f7: e8 00 00 00 00               	callq	 <L1>
		00000000000031f8:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L1>:
    31fc: 0f 57 c0                     	xorps	%xmm0, %xmm0
    31ff: 41 0f 29 47 60               	movaps	%xmm0, 0x60(%r15)
    3204: 41 0f 29 47 50               	movaps	%xmm0, 0x50(%r15)
    3209: 41 0f 29 47 40               	movaps	%xmm0, 0x40(%r15)
    320e: 41 0f 29 47 30               	movaps	%xmm0, 0x30(%r15)
    3213: 41 0f 29 47 20               	movaps	%xmm0, 0x20(%r15)
    3218: 41 0f 29 47 10               	movaps	%xmm0, 0x10(%r15)
    321d: 41 0f 29 07                  	movaps	%xmm0, (%r15)
<L2>:
    3221: 49 8b 06                     	movq	(%r14), %rax
    3224: 49 8b 4e 08                  	movq	0x8(%r14), %rcx
    3228: 89 c2                        	movl	%eax, %edx
    322a: c1 ea 05                     	shrl	$0x5, %edx
    322d: 8d 34 c5 00 00 00 00         	leal	(,%rax,8), %esi
    3234: 41 88 b6 cf 00 00 00         	movb	%sil, 0xcf(%r14)
    323b: 41 88 96 ce 00 00 00         	movb	%dl, 0xce(%r14)
    3242: 89 c2                        	movl	%eax, %edx
    3244: c1 ea 0d                     	shrl	$0xd, %edx
    3247: 41 88 96 cd 00 00 00         	movb	%dl, 0xcd(%r14)
    324e: 89 c2                        	movl	%eax, %edx
    3250: c1 ea 15                     	shrl	$0x15, %edx
    3253: 41 88 96 cc 00 00 00         	movb	%dl, 0xcc(%r14)
    325a: 48 89 ca                     	movq	%rcx, %rdx
    325d: 48 89 ce                     	movq	%rcx, %rsi
    3260: 48 89 c7                     	movq	%rax, %rdi
    3263: 49 89 c8                     	movq	%rcx, %r8
    3266: 49 0f a4 c0 0b               	shldq	$0xb, %rax, %r8
    326b: 49 89 c9                     	movq	%rcx, %r9
    326e: 49 0f a4 c1 13               	shldq	$0x13, %rax, %r9
    3273: 66 48 0f 6e c8               	movq	%rax, %xmm1
    3278: 48 0f ac c8 3d               	shrdq	$0x3d, %rcx, %rax
    327d: 66 48 0f 6e c1               	movq	%rcx, %xmm0
    3282: 66 0f 6e d1                  	movd	%ecx, %xmm2
    3286: 48 c1 e9 25                  	shrq	$0x25, %rcx
    328a: 48 c1 ea 35                  	shrq	$0x35, %rdx
    328e: 48 c1 ee 2d                  	shrq	$0x2d, %rsi
    3292: 48 c1 ef 25                  	shrq	$0x25, %rdi
    3296: 66 49 0f 6e d9               	movq	%r9, %xmm3
    329b: 66 49 0f 6e e0               	movq	%r8, %xmm4
    32a0: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    ## xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    32a4: 66 0f 73 d1 1d               	psrlq	$0x1d, %xmm1
    32a9: 66 0f 6e df                  	movd	%edi, %xmm3
    32ad: 66 0f 60 d9                  	punpcklbw	%xmm1, %xmm3    ## xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
    32b1: 66 0f 6f 0d a7 31 00 00      	movdqa	, %xmm1 <_audit_handshake256+0x110>
		00000000000032b5:  X86_64_RELOC_SIGNED	__literal16
    32b9: 66 0f db e1                  	pand	%xmm1, %xmm4
    32bd: 66 0f 72 f3 10               	pslld	$0x10, %xmm3
    32c2: 66 0f eb dc                  	por	%xmm4, %xmm3
    32c6: 66 41 0f 7e 9e c8 00 00 00   	movd	%xmm3, 0xc8(%r14)
    32cf: 66 0f 6e de                  	movd	%esi, %xmm3
    32d3: 66 0f 6e e2                  	movd	%edx, %xmm4
    32d7: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    ## xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    32db: 66 0f db e1                  	pand	%xmm1, %xmm4
    32df: 66 0f 6f c8                  	movdqa	%xmm0, %xmm1
    32e3: 66 0f 73 d1 1d               	psrlq	$0x1d, %xmm1
    32e8: 66 0f 6e d9                  	movd	%ecx, %xmm3
    32ec: 66 0f 60 d9                  	punpcklbw	%xmm1, %xmm3    ## xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
    32f0: 66 0f 72 f3 10               	pslld	$0x10, %xmm3
    32f5: 66 0f eb dc                  	por	%xmm4, %xmm3
    32f9: 66 0f 6f c8                  	movdqa	%xmm0, %xmm1
    32fd: 66 0f 73 d1 0d               	psrlq	$0xd, %xmm1
    3302: 66 0f 73 d0 15               	psrlq	$0x15, %xmm0
    3307: 66 0f 60 c1                  	punpcklbw	%xmm1, %xmm0    ## xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
    330b: 66 0f 38 00 05 5c 31 00 00   	pshufb	, %xmm0 <_audit_handshake256+0x120>
		0000000000003310:  X86_64_RELOC_SIGNED	__literal16
    3314: 66 48 0f 6e c8               	movq	%rax, %xmm1
    3319: 66 0f 72 d2 05               	psrld	$0x5, %xmm2
    331e: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    ## xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    3322: 66 0f 73 f2 30               	psllq	$0x30, %xmm2
    3327: 66 0f eb d0                  	por	%xmm0, %xmm2
    332b: 66 0f 70 c2 55               	pshufd	$0x55, %xmm2, %xmm0     ## xmm0 = xmm2[1,1,1,1]
    3330: 66 0f 62 d8                  	punpckldq	%xmm0, %xmm3    ## xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1]
    3334: 66 41 0f d6 9e c0 00 00 00   	movq	%xmm3, 0xc0(%r14)
    333d: 4c 89 f7                     	movq	%r14, %rdi
    3340: 4c 89 fe                     	movq	%r15, %rsi
    3343: e8 00 00 00 00               	callq	 <L3>
		0000000000003344:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L3>:
    3348: 49 8b 46 10                  	movq	0x10(%r14), %rax
    334c: 48 0f c8                     	bswapq	%rax
    334f: 48 89 03                     	movq	%rax, (%rbx)
    3352: 49 8b 46 18                  	movq	0x18(%r14), %rax
    3356: 48 0f c8                     	bswapq	%rax
    3359: 48 89 43 08                  	movq	%rax, 0x8(%rbx)
    335d: 49 8b 46 20                  	movq	0x20(%r14), %rax
    3361: 48 0f c8                     	bswapq	%rax
    3364: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    3368: 49 8b 46 28                  	movq	0x28(%r14), %rax
    336c: 48 0f c8                     	bswapq	%rax
    336f: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    3373: 49 8b 46 30                  	movq	0x30(%r14), %rax
    3377: 48 0f c8                     	bswapq	%rax
    337a: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    337e: 49 8b 46 38                  	movq	0x38(%r14), %rax
    3382: 48 0f c8                     	bswapq	%rax
    3385: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    3389: 48 83 c4 08                  	addq	$0x8, %rsp
    338d: 5b                           	popq	%rbx
    338e: 41 5e                        	popq	%r14
    3390: 41 5f                        	popq	%r15
    3392: 5d                           	popq	%rbp
    3393: c3                           	retq
    3394: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    339e: 66 90                        	nop

00000000000033a0 <_audit_master384>:
    33a0: 55                           	pushq	%rbp
    33a1: 48 89 e5                     	movq	%rsp, %rbp
    33a4: 41 56                        	pushq	%r14
    33a6: 53                           	pushq	%rbx
    33a7: 48 81 ec 70 01 00 00         	subq	$0x170, %rsp            ## imm = 0x170
    33ae: 48 89 f3                     	movq	%rsi, %rbx
    33b1: 49 89 f8                     	movq	%rdi, %r8
    33b4: 66 c7 85 b0 fe ff ff 00 30   	movw	$0x3000, -0x150(%rbp)   ## imm = 0x3000
    33bd: c6 85 b2 fe ff ff 0d         	movb	$0xd, -0x14e(%rbp)
    33c4: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    33ce: 48 89 85 b3 fe ff ff         	movq	%rax, -0x14d(%rbp)
    33d5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    33df: 48 89 85 b8 fe ff ff         	movq	%rax, -0x148(%rbp)
    33e6: c6 85 c0 fe ff ff 30         	movb	$0x30, -0x140(%rbp)
    33ed: 48 b8 38 b0 60 a7 51 ac 96 38	movabsq	$0x3896ac51a760b038, %rax ## imm = 0x3896AC51A760B038
    33f7: 48 89 85 c1 fe ff ff         	movq	%rax, -0x13f(%rbp)
    33fe: 48 b8 4c d9 32 7e b1 b1 e3 6a	movabsq	$0x6ae3b1b17e32d94c, %rax ## imm = 0x6AE3B1B17E32D94C
    3408: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
    340f: 48 b8 21 fd b7 11 14 be 07 43	movabsq	$0x4307be1411b7fd21, %rax ## imm = 0x4307BE1411B7FD21
    3419: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    3420: 48 b8 4c 0c c7 bf 63 f6 e1 da	movabsq	$-0x251e099c4038f3b4, %rax ## imm = 0xDAE1F663BFC70C4C
    342a: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    3431: 48 b8 27 4e de bf e7 6f 65 fb	movabsq	$-0x49a90184021b1d9, %rax ## imm = 0xFB656FE7BFDE4E27
    343b: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    3442: 48 b8 d5 1a d2 f1 48 98 b9 5b	movabsq	$0x5bb99848f1d21ad5, %rax ## imm = 0x5BB99848F1D21AD5
    344c: 48 89 85 e9 fe ff ff         	movq	%rax, -0x117(%rbp)
    3453: 4c 8d b5 80 fe ff ff         	leaq	-0x180(%rbp), %r14
    345a: 48 8d 95 b0 fe ff ff         	leaq	-0x150(%rbp), %rdx
    3461: be 30 00 00 00               	movl	$0x30, %esi
    3466: b9 41 00 00 00               	movl	$0x41, %ecx
    346b: 4c 89 f7                     	movq	%r14, %rdi
    346e: e8 00 00 00 00               	callq	 <L0>
		000000000000346f:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    3473: 48 8d 15 00 00 00 00         	leaq	, %rdx <_audit_master384+0xda>
		0000000000003476:  X86_64_RELOC_SIGNED	_memx.Array(48).zero
    347a: 48 8d 7d c0                  	leaq	-0x40(%rbp), %rdi
    347e: 4c 89 f6                     	movq	%r14, %rsi
    3481: e8 00 00 00 00               	callq	 <L1>
		0000000000003482:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
<L1>:
    3486: 48 8b 45 e8                  	movq	-0x18(%rbp), %rax
    348a: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    348e: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    3492: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    3496: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    349a: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    349e: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    34a2: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    34a6: 48 8b 45 c0                  	movq	-0x40(%rbp), %rax
    34aa: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    34ae: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    34b2: 48 89 03                     	movq	%rax, (%rbx)
    34b5: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            ## imm = 0x170
    34bc: 5b                           	popq	%rbx
    34bd: 41 5e                        	popq	%r14
    34bf: 5d                           	popq	%rbp
    34c0: c3                           	retq
    34c1: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    34cb: 0f 1f 44 00 00               	nopl	(%rax,%rax)

00000000000034d0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    34d0: 55                           	pushq	%rbp
    34d1: 48 89 e5                     	movq	%rsp, %rbp
    34d4: 41 57                        	pushq	%r15
    34d6: 41 56                        	pushq	%r14
    34d8: 41 55                        	pushq	%r13
    34da: 41 54                        	pushq	%r12
    34dc: 53                           	pushq	%rbx
    34dd: 48 81 ec f8 02 00 00         	subq	$0x2f8, %rsp            ## imm = 0x2F8
    34e4: 49 89 d6                     	movq	%rdx, %r14
    34e7: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    34eb: 48 8b 46 28                  	movq	0x28(%rsi), %rax
    34ef: 48 89 85 78 ff ff ff         	movq	%rax, -0x88(%rbp)
    34f6: 48 8b 46 20                  	movq	0x20(%rsi), %rax
    34fa: 48 89 85 70 ff ff ff         	movq	%rax, -0x90(%rbp)
    3501: 48 8b 46 18                  	movq	0x18(%rsi), %rax
    3505: 48 89 85 68 ff ff ff         	movq	%rax, -0x98(%rbp)
    350c: 48 8b 46 10                  	movq	0x10(%rsi), %rax
    3510: 48 89 85 60 ff ff ff         	movq	%rax, -0xa0(%rbp)
    3517: 48 8b 06                     	movq	(%rsi), %rax
    351a: 48 8b 4e 08                  	movq	0x8(%rsi), %rcx
    351e: 48 89 8d 58 ff ff ff         	movq	%rcx, -0xa8(%rbp)
    3525: 48 89 85 50 ff ff ff         	movq	%rax, -0xb0(%rbp)
    352c: 48 c7 45 80 00 00 00 00      	movq	$0x0, -0x80(%rbp)
    3534: 48 c7 45 88 00 00 00 00      	movq	$0x0, -0x78(%rbp)
    353c: 48 c7 45 90 00 00 00 00      	movq	$0x0, -0x70(%rbp)
    3544: 48 c7 45 98 00 00 00 00      	movq	$0x0, -0x68(%rbp)
    354c: 48 c7 45 a0 00 00 00 00      	movq	$0x0, -0x60(%rbp)
    3554: 48 c7 45 a8 00 00 00 00      	movq	$0x0, -0x58(%rbp)
    355c: 48 c7 45 b0 00 00 00 00      	movq	$0x0, -0x50(%rbp)
    3564: 48 c7 45 b8 00 00 00 00      	movq	$0x0, -0x48(%rbp)
    356c: 48 c7 45 c0 00 00 00 00      	movq	$0x0, -0x40(%rbp)
    3574: 48 c7 45 c8 00 00 00 00      	movq	$0x0, -0x38(%rbp)
    357c: 31 c0                        	xorl	%eax, %eax
    357e: 66 90                        	nop
<L0>:
    3580: 0f b6 8c 05 50 ff ff ff      	movzbl	-0xb0(%rbp,%rax), %ecx
    3588: 0f b6 94 05 51 ff ff ff      	movzbl	-0xaf(%rbp,%rax), %edx
    3590: 80 f1 5c                     	xorb	$0x5c, %cl
    3593: 88 8c 05 c0 fd ff ff         	movb	%cl, -0x240(%rbp,%rax)
    359a: 80 f2 5c                     	xorb	$0x5c, %dl
    359d: 88 94 05 c1 fd ff ff         	movb	%dl, -0x23f(%rbp,%rax)
    35a4: 0f b6 8c 05 52 ff ff ff      	movzbl	-0xae(%rbp,%rax), %ecx
    35ac: 80 f1 5c                     	xorb	$0x5c, %cl
    35af: 88 8c 05 c2 fd ff ff         	movb	%cl, -0x23e(%rbp,%rax)
    35b6: 0f b6 8c 05 53 ff ff ff      	movzbl	-0xad(%rbp,%rax), %ecx
    35be: 80 f1 5c                     	xorb	$0x5c, %cl
    35c1: 88 8c 05 c3 fd ff ff         	movb	%cl, -0x23d(%rbp,%rax)
    35c8: 48 83 c0 04                  	addq	$0x4, %rax
    35cc: 48 3d 80 00 00 00            	cmpq	$0x80, %rax
    35d2: 75 ac                        	jne	 <L0>
    35d4: b8 03 00 00 00               	movl	$0x3, %eax
    35d9: 0f 1f 80 00 00 00 00         	nopl	(%rax)
<L1>:
    35e0: 0f b6 8c 05 4d ff ff ff      	movzbl	-0xb3(%rbp,%rax), %ecx
    35e8: 0f b6 94 05 4e ff ff ff      	movzbl	-0xb2(%rbp,%rax), %edx
    35f0: 80 f1 36                     	xorb	$0x36, %cl
    35f3: 88 8c 05 3d fe ff ff         	movb	%cl, -0x1c3(%rbp,%rax)
    35fa: 80 f2 36                     	xorb	$0x36, %dl
    35fd: 88 94 05 3e fe ff ff         	movb	%dl, -0x1c2(%rbp,%rax)
    3604: 0f b6 8c 05 4f ff ff ff      	movzbl	-0xb1(%rbp,%rax), %ecx
    360c: 80 f1 36                     	xorb	$0x36, %cl
    360f: 88 8c 05 3f fe ff ff         	movb	%cl, -0x1c1(%rbp,%rax)
    3616: 0f b6 8c 05 50 ff ff ff      	movzbl	-0xb0(%rbp,%rax), %ecx
    361e: 80 f1 36                     	xorb	$0x36, %cl
    3621: 88 8c 05 40 fe ff ff         	movb	%cl, -0x1c0(%rbp,%rax)
    3628: 48 83 c0 04                  	addq	$0x4, %rax
    362c: 48 3d 83 00 00 00            	cmpq	$0x83, %rax
    3632: 75 ac                        	jne	 <L1>
    3634: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x16b>
		0000000000003637:  X86_64_RELOC_SIGNED	___anon_817
    363b: 4c 8d a5 e0 fc ff ff         	leaq	-0x320(%rbp), %r12
    3642: ba e0 00 00 00               	movl	$0xe0, %edx
    3647: 4c 89 e7                     	movq	%r12, %rdi
    364a: e8 00 00 00 00               	callq	 <L2>
		000000000000364b:  X86_64_RELOC_BRANCH	_memcpy
<L2>:
    364f: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    3656: 4c 89 e7                     	movq	%r12, %rdi
    3659: e8 00 00 00 00               	callq	 <L3>
		000000000000365a:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L3>:
    365e: 4c 8b a5 e8 fc ff ff         	movq	-0x318(%rbp), %r12
    3665: bb 80 00 00 00               	movl	$0x80, %ebx
    366a: 4c 8b bd e0 fc ff ff         	movq	-0x320(%rbp), %r15
    3671: 49 01 df                     	addq	%rbx, %r15
    3674: 49 83 d4 00                  	adcq	$0x0, %r12
    3678: 4c 89 bd e0 fc ff ff         	movq	%r15, -0x320(%rbp)
    367f: 4c 89 a5 e8 fc ff ff         	movq	%r12, -0x318(%rbp)
    3686: 0f b6 85 b0 fd ff ff         	movzbl	-0x250(%rbp), %eax
    368d: 48 85 c0                     	testq	%rax, %rax
    3690: 74 4f                        	je	 <L6>
    3692: 3c 50                        	cmpb	$0x50, %al
    3694: 72 4d                        	jb	 <L7>
    3696: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    369c: 49 29 c5                     	subq	%rax, %r13
    369f: 4c 8d a5 30 fd ff ff         	leaq	-0x2d0(%rbp), %r12
    36a6: 48 8d bc 05 30 fd ff ff      	leaq	-0x2d0(%rbp,%rax), %rdi
    36ae: 4c 89 f6                     	movq	%r14, %rsi
    36b1: 4c 89 ea                     	movq	%r13, %rdx
    36b4: e8 00 00 00 00               	callq	 <L4>
		00000000000036b5:  X86_64_RELOC_BRANCH	_memcpy
<L4>:
    36b9: 48 8d bd e0 fc ff ff         	leaq	-0x320(%rbp), %rdi
    36c0: 4c 89 e6                     	movq	%r12, %rsi
    36c3: e8 00 00 00 00               	callq	 <L5>
		00000000000036c4:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L5>:
    36c8: c6 85 b0 fd ff ff 00         	movb	$0x0, -0x250(%rbp)
    36cf: 31 c0                        	xorl	%eax, %eax
    36d1: 4c 8b bd e0 fc ff ff         	movq	-0x320(%rbp), %r15
    36d8: 4c 8b a5 e8 fc ff ff         	movq	-0x318(%rbp), %r12
    36df: eb 05                        	jmp	 <L8>
<L6>:
    36e1: 31 c0                        	xorl	%eax, %eax
<L7>:
    36e3: 45 31 ed                     	xorl	%r13d, %r13d
<L8>:
    36e6: 4d 01 ee                     	addq	%r13, %r14
    36e9: 4c 89 f6                     	movq	%r14, %rsi
    36ec: 41 be 30 00 00 00            	movl	$0x30, %r14d
    36f2: 4d 29 ee                     	subq	%r13, %r14
    36f5: 0f b6 c0                     	movzbl	%al, %eax
    36f8: 48 8d bc 05 30 fd ff ff      	leaq	-0x2d0(%rbp,%rax), %rdi
    3700: 4c 89 f2                     	movq	%r14, %rdx
    3703: e8 00 00 00 00               	callq	 <L9>
		0000000000003704:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
    3708: 44 00 b5 b0 fd ff ff         	addb	%r14b, -0x250(%rbp)
    370f: 49 83 c7 30                  	addq	$0x30, %r15
    3713: 49 83 d4 00                  	adcq	$0x0, %r12
    3717: 4c 89 a5 e8 fc ff ff         	movq	%r12, -0x318(%rbp)
    371e: 4c 89 bd e0 fc ff ff         	movq	%r15, -0x320(%rbp)
    3725: 48 8d bd e0 fc ff ff         	leaq	-0x320(%rbp), %rdi
    372c: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
    3733: e8 00 00 00 00               	callq	 <L10>
		0000000000003734:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L10>:
    3738: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x26f>
		000000000000373b:  X86_64_RELOC_SIGNED	___anon_817
    373f: 4c 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %r14
    3746: ba e0 00 00 00               	movl	$0xe0, %edx
    374b: 4c 89 f7                     	movq	%r14, %rdi
    374e: e8 00 00 00 00               	callq	 <L11>
		000000000000374f:  X86_64_RELOC_BRANCH	_memcpy
<L11>:
    3753: 4c 89 f7                     	movq	%r14, %rdi
    3756: 48 8d b5 c0 fd ff ff         	leaq	-0x240(%rbp), %rsi
    375d: e8 00 00 00 00               	callq	 <L12>
		000000000000375e:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L12>:
    3762: 0f b6 bd 10 ff ff ff         	movzbl	-0xf0(%rbp), %edi
    3769: 4c 8b a5 48 fe ff ff         	movq	-0x1b8(%rbp), %r12
    3770: 48 03 9d 40 fe ff ff         	addq	-0x1c0(%rbp), %rbx
    3777: 49 83 d4 00                  	adcq	$0x0, %r12
    377b: 4c 8d b5 90 fe ff ff         	leaq	-0x170(%rbp), %r14
    3782: 48 89 9d 40 fe ff ff         	movq	%rbx, -0x1c0(%rbp)
    3789: 4c 89 a5 48 fe ff ff         	movq	%r12, -0x1b8(%rbp)
    3790: 48 85 ff                     	testq	%rdi, %rdi
    3793: 74 49                        	je	 <L15>
    3795: 40 80 ff 50                  	cmpb	$0x50, %dil
    3799: 72 45                        	jb	 <L16>
    379b: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    37a1: 49 29 ff                     	subq	%rdi, %r15
    37a4: 4c 01 f7                     	addq	%r14, %rdi
    37a7: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
    37ae: 4c 89 fa                     	movq	%r15, %rdx
    37b1: e8 00 00 00 00               	callq	 <L13>
		00000000000037b2:  X86_64_RELOC_BRANCH	_memcpy
<L13>:
    37b6: 48 8d bd 40 fe ff ff         	leaq	-0x1c0(%rbp), %rdi
    37bd: 4c 89 f6                     	movq	%r14, %rsi
    37c0: e8 00 00 00 00               	callq	 <L14>
		00000000000037c1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L14>:
    37c5: c6 85 10 ff ff ff 00         	movb	$0x0, -0xf0(%rbp)
    37cc: 31 ff                        	xorl	%edi, %edi
    37ce: 48 8b 9d 40 fe ff ff         	movq	-0x1c0(%rbp), %rbx
    37d5: 4c 8b a5 48 fe ff ff         	movq	-0x1b8(%rbp), %r12
    37dc: eb 05                        	jmp	 <L17>
<L15>:
    37de: 31 ff                        	xorl	%edi, %edi
<L16>:
    37e0: 45 31 ff                     	xorl	%r15d, %r15d
<L17>:
    37e3: 4a 8d b4 3d 50 ff ff ff      	leaq	-0xb0(%rbp,%r15), %rsi
    37eb: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    37f1: 4d 29 fd                     	subq	%r15, %r13
    37f4: 40 0f b6 c7                  	movzbl	%dil, %eax
    37f8: 49 01 c6                     	addq	%rax, %r14
    37fb: 4c 89 f7                     	movq	%r14, %rdi
    37fe: 4c 89 ea                     	movq	%r13, %rdx
    3801: e8 00 00 00 00               	callq	 <L18>
		0000000000003802:  X86_64_RELOC_BRANCH	_memcpy
<L18>:
    3806: 44 00 ad 10 ff ff ff         	addb	%r13b, -0xf0(%rbp)
    380d: 48 83 c3 30                  	addq	$0x30, %rbx
    3811: 49 83 d4 00                  	adcq	$0x0, %r12
    3815: 4c 89 a5 48 fe ff ff         	movq	%r12, -0x1b8(%rbp)
    381c: 48 89 9d 40 fe ff ff         	movq	%rbx, -0x1c0(%rbp)
    3823: 48 8d bd 40 fe ff ff         	leaq	-0x1c0(%rbp), %rdi
    382a: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3831: e8 00 00 00 00               	callq	 <L19>
		0000000000003832:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L19>:
    3836: 48 8b 85 48 ff ff ff         	movq	-0xb8(%rbp), %rax
    383d: 48 8b 55 d0                  	movq	-0x30(%rbp), %rdx
    3841: 48 89 42 28                  	movq	%rax, 0x28(%rdx)
    3845: 48 8b 85 40 ff ff ff         	movq	-0xc0(%rbp), %rax
    384c: 48 89 42 20                  	movq	%rax, 0x20(%rdx)
    3850: 48 8b 85 38 ff ff ff         	movq	-0xc8(%rbp), %rax
    3857: 48 89 42 18                  	movq	%rax, 0x18(%rdx)
    385b: 48 8b 85 30 ff ff ff         	movq	-0xd0(%rbp), %rax
    3862: 48 89 42 10                  	movq	%rax, 0x10(%rdx)
    3866: 48 8b 85 20 ff ff ff         	movq	-0xe0(%rbp), %rax
    386d: 48 8b 8d 28 ff ff ff         	movq	-0xd8(%rbp), %rcx
    3874: 48 89 4a 08                  	movq	%rcx, 0x8(%rdx)
    3878: 48 89 02                     	movq	%rax, (%rdx)
    387b: 48 81 c4 f8 02 00 00         	addq	$0x2f8, %rsp            ## imm = 0x2F8
    3882: 5b                           	popq	%rbx
    3883: 41 5c                        	popq	%r12
    3885: 41 5d                        	popq	%r13
    3887: 41 5e                        	popq	%r14
    3889: 41 5f                        	popq	%r15
    388b: 5d                           	popq	%rbp
    388c: c3                           	retq
    388d: 0f 1f 00                     	nopl	(%rax)

0000000000003890 <_audit_handshake384>:
    3890: 55                           	pushq	%rbp
    3891: 48 89 e5                     	movq	%rsp, %rbp
    3894: 41 57                        	pushq	%r15
    3896: 41 56                        	pushq	%r14
    3898: 53                           	pushq	%rbx
    3899: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            ## imm = 0x178
    38a0: 48 89 d3                     	movq	%rdx, %rbx
    38a3: 49 89 f6                     	movq	%rsi, %r14
    38a6: 49 89 f8                     	movq	%rdi, %r8
    38a9: 66 c7 85 a8 fe ff ff 00 30   	movw	$0x3000, -0x158(%rbp)   ## imm = 0x3000
    38b2: c6 85 aa fe ff ff 0d         	movb	$0xd, -0x156(%rbp)
    38b9: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    38c3: 48 89 85 ab fe ff ff         	movq	%rax, -0x155(%rbp)
    38ca: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    38d4: 48 89 85 b0 fe ff ff         	movq	%rax, -0x150(%rbp)
    38db: c6 85 b8 fe ff ff 30         	movb	$0x30, -0x148(%rbp)
    38e2: 48 b8 38 b0 60 a7 51 ac 96 38	movabsq	$0x3896ac51a760b038, %rax ## imm = 0x3896AC51A760B038
    38ec: 48 89 85 b9 fe ff ff         	movq	%rax, -0x147(%rbp)
    38f3: 48 b8 4c d9 32 7e b1 b1 e3 6a	movabsq	$0x6ae3b1b17e32d94c, %rax ## imm = 0x6AE3B1B17E32D94C
    38fd: 48 89 85 c1 fe ff ff         	movq	%rax, -0x13f(%rbp)
    3904: 48 b8 21 fd b7 11 14 be 07 43	movabsq	$0x4307be1411b7fd21, %rax ## imm = 0x4307BE1411B7FD21
    390e: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
    3915: 48 b8 4c 0c c7 bf 63 f6 e1 da	movabsq	$-0x251e099c4038f3b4, %rax ## imm = 0xDAE1F663BFC70C4C
    391f: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    3926: 48 b8 27 4e de bf e7 6f 65 fb	movabsq	$-0x49a90184021b1d9, %rax ## imm = 0xFB656FE7BFDE4E27
    3930: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    3937: 48 b8 d5 1a d2 f1 48 98 b9 5b	movabsq	$0x5bb99848f1d21ad5, %rax ## imm = 0x5BB99848F1D21AD5
    3941: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    3948: 4c 8d bd 78 fe ff ff         	leaq	-0x188(%rbp), %r15
    394f: 48 8d 95 a8 fe ff ff         	leaq	-0x158(%rbp), %rdx
    3956: be 30 00 00 00               	movl	$0x30, %esi
    395b: b9 41 00 00 00               	movl	$0x41, %ecx
    3960: 4c 89 ff                     	movq	%r15, %rdi
    3963: e8 00 00 00 00               	callq	 <L0>
		0000000000003964:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    3968: 48 8d 7d b8                  	leaq	-0x48(%rbp), %rdi
    396c: 4c 89 fe                     	movq	%r15, %rsi
    396f: 4c 89 f2                     	movq	%r14, %rdx
    3972: e8 00 00 00 00               	callq	 <L1>
		0000000000003973:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
<L1>:
    3977: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    397b: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    397f: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    3983: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    3987: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    398b: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    398f: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
    3993: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    3997: 48 8b 45 b8                  	movq	-0x48(%rbp), %rax
    399b: 48 8b 4d c0                  	movq	-0x40(%rbp), %rcx
    399f: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    39a3: 48 89 03                     	movq	%rax, (%rbx)
    39a6: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            ## imm = 0x178
    39ad: 5b                           	popq	%rbx
    39ae: 41 5e                        	popq	%r14
    39b0: 41 5f                        	popq	%r15
    39b2: 5d                           	popq	%rbp
    39b3: c3                           	retq
    39b4: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    39be: 66 90                        	nop

00000000000039c0 <_audit_key256>:
    39c0: 55                           	pushq	%rbp
    39c1: 48 89 e5                     	movq	%rsp, %rbp
    39c4: 48 81 ec 30 01 00 00         	subq	$0x130, %rsp            ## imm = 0x130
    39cb: 48 89 f0                     	movq	%rsi, %rax
    39ce: 48 8b 4f 18                  	movq	0x18(%rdi), %rcx
    39d2: 48 89 4d f8                  	movq	%rcx, -0x8(%rbp)
    39d6: 48 8b 4f 10                  	movq	0x10(%rdi), %rcx
    39da: 48 89 4d f0                  	movq	%rcx, -0x10(%rbp)
    39de: 48 8b 0f                     	movq	(%rdi), %rcx
    39e1: 48 8b 57 08                  	movq	0x8(%rdi), %rdx
    39e5: 48 89 55 e8                  	movq	%rdx, -0x18(%rbp)
    39e9: 48 89 4d e0                  	movq	%rcx, -0x20(%rbp)
    39ed: 66 c7 85 d4 fe ff ff 00 10   	movw	$0x1000, -0x12c(%rbp)   ## imm = 0x1000
    39f6: c6 85 d6 fe ff ff 09         	movb	$0x9, -0x12a(%rbp)
    39fd: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx ## imm = 0x656B203331736C74
    3a07: 48 89 8d d7 fe ff ff         	movq	%rcx, -0x129(%rbp)
    3a0e: 66 c7 85 df fe ff ff 79 00   	movw	$0x79, -0x121(%rbp)
    3a17: 48 8d 95 d4 fe ff ff         	leaq	-0x12c(%rbp), %rdx
    3a1e: 4c 8d 45 e0                  	leaq	-0x20(%rbp), %r8
    3a22: be 10 00 00 00               	movl	$0x10, %esi
    3a27: b9 0d 00 00 00               	movl	$0xd, %ecx
    3a2c: 48 89 c7                     	movq	%rax, %rdi
    3a2f: e8 00 00 00 00               	callq	 <L0>
		0000000000003a30:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    3a34: 48 81 c4 30 01 00 00         	addq	$0x130, %rsp            ## imm = 0x130
    3a3b: 5d                           	popq	%rbp
    3a3c: c3                           	retq
    3a3d: 0f 1f 00                     	nopl	(%rax)

0000000000003a40 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
    3a40: 55                           	pushq	%rbp
    3a41: 48 89 e5                     	movq	%rsp, %rbp
    3a44: 41 57                        	pushq	%r15
    3a46: 41 56                        	pushq	%r14
    3a48: 41 55                        	pushq	%r13
    3a4a: 41 54                        	pushq	%r12
    3a4c: 53                           	pushq	%rbx
    3a4d: 48 81 ec 48 02 00 00         	subq	$0x248, %rsp            ## imm = 0x248
    3a54: 49 89 cf                     	movq	%rcx, %r15
    3a57: 49 89 d4                     	movq	%rdx, %r12
    3a5a: 48 89 bd 18 ff ff ff         	movq	%rdi, -0xe8(%rbp)
    3a61: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    3a65: 48 83 fe 20                  	cmpq	$0x20, %rsi
    3a69: 0f 83 c1 01 00 00            	jae	 <L5>
    3a6f: 49 8b 40 18                  	movq	0x18(%r8), %rax
    3a73: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    3a77: 49 8b 40 10                  	movq	0x10(%r8), %rax
    3a7b: 48 89 45 a0                  	movq	%rax, -0x60(%rbp)
    3a7f: 49 8b 00                     	movq	(%r8), %rax
    3a82: 49 8b 48 08                  	movq	0x8(%r8), %rcx
    3a86: 48 89 4d 98                  	movq	%rcx, -0x68(%rbp)
    3a8a: 48 89 45 90                  	movq	%rax, -0x70(%rbp)
    3a8e: 48 c7 45 b0 00 00 00 00      	movq	$0x0, -0x50(%rbp)
    3a96: 48 c7 45 b8 00 00 00 00      	movq	$0x0, -0x48(%rbp)
    3a9e: 48 c7 45 c0 00 00 00 00      	movq	$0x0, -0x40(%rbp)
    3aa6: 48 c7 45 c8 00 00 00 00      	movq	$0x0, -0x38(%rbp)
    3aae: 31 c0                        	xorl	%eax, %eax
<L0>:
    3ab0: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3ab5: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    3aba: 80 f1 5c                     	xorb	$0x5c, %cl
    3abd: 88 8c 05 d0 fe ff ff         	movb	%cl, -0x130(%rbp,%rax)
    3ac4: 80 f2 5c                     	xorb	$0x5c, %dl
    3ac7: 88 94 05 d1 fe ff ff         	movb	%dl, -0x12f(%rbp,%rax)
    3ace: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    3ad3: 80 f1 5c                     	xorb	$0x5c, %cl
    3ad6: 88 8c 05 d2 fe ff ff         	movb	%cl, -0x12e(%rbp,%rax)
    3add: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    3ae2: 80 f1 5c                     	xorb	$0x5c, %cl
    3ae5: 88 8c 05 d3 fe ff ff         	movb	%cl, -0x12d(%rbp,%rax)
    3aec: 48 83 c0 04                  	addq	$0x4, %rax
    3af0: 48 83 f8 40                  	cmpq	$0x40, %rax
    3af4: 75 ba                        	jne	 <L0>
    3af6: 48 89 b5 10 ff ff ff         	movq	%rsi, -0xf0(%rbp)
    3afd: b8 03 00 00 00               	movl	$0x3, %eax
    3b02: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    3b0c: 0f 1f 40 00                  	nopl	(%rax)
<L1>:
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
    3b54: 75 ba                        	jne	 <L1>
    3b56: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x17d>
		0000000000003b59:  X86_64_RELOC_SIGNED	___anon_7525
    3b5d: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    3b64: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x17b>
		0000000000003b67:  X86_64_RELOC_SIGNED	___anon_7525
    3b6b: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
    3b72: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x179>
		0000000000003b75:  X86_64_RELOC_SIGNED	___anon_7525
    3b79: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    3b80: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x177>
		0000000000003b83:  X86_64_RELOC_SIGNED	___anon_7525
    3b87: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    3b8e: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x175>
		0000000000003b91:  X86_64_RELOC_SIGNED	___anon_7525
    3b95: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    3b9c: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x173>
		0000000000003b9f:  X86_64_RELOC_SIGNED	___anon_7525
    3ba3: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    3baa: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x171>
		0000000000003bad:  X86_64_RELOC_SIGNED	___anon_7525
    3bb1: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    3bb8: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3bbf: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3bc6: e8 00 00 00 00               	callq	 <L2>
		0000000000003bc7:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L2>:
    3bcb: 48 83 85 80 fe ff ff 40      	addq	$0x40, -0x180(%rbp)
    3bd3: 0f b6 85 c8 fe ff ff         	movzbl	-0x138(%rbp), %eax
    3bda: 48 85 c0                     	testq	%rax, %rax
    3bdd: 0f 84 fc 01 00 00            	je	 <L11>
    3be3: 49 8d 0c 07                  	leaq	(%r15,%rax), %rcx
    3be7: 48 83 f9 40                  	cmpq	$0x40, %rcx
    3beb: 0f 82 f0 01 00 00            	jb	 <L12>
    3bf1: bb 40 00 00 00               	movl	$0x40, %ebx
    3bf6: 48 29 c3                     	subq	%rax, %rbx
    3bf9: 4c 8d b5 88 fe ff ff         	leaq	-0x178(%rbp), %r14
    3c00: 48 8d bc 05 88 fe ff ff      	leaq	-0x178(%rbp,%rax), %rdi
    3c08: 4c 89 e6                     	movq	%r12, %rsi
    3c0b: 48 89 da                     	movq	%rbx, %rdx
    3c0e: e8 00 00 00 00               	callq	 <L3>
		0000000000003c0f:  X86_64_RELOC_BRANCH	_memcpy
<L3>:
    3c13: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3c1a: 4c 89 f6                     	movq	%r14, %rsi
    3c1d: e8 00 00 00 00               	callq	 <L4>
		0000000000003c1e:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L4>:
    3c22: c6 85 c8 fe ff ff 00         	movb	$0x0, -0x138(%rbp)
    3c29: 31 c0                        	xorl	%eax, %eax
    3c2b: e9 b3 01 00 00               	jmp	 <L13>
<L5>:
    3c30: 4c 89 fb                     	movq	%r15, %rbx
    3c33: 48 83 f3 3f                  	xorq	$0x3f, %rbx
    3c37: 4c 8d ad d8 fd ff ff         	leaq	-0x228(%rbp), %r13
    3c3e: 49 8b 40 18                  	movq	0x18(%r8), %rax
    3c42: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    3c46: 49 8b 40 10                  	movq	0x10(%r8), %rax
    3c4a: 48 89 45 a0                  	movq	%rax, -0x60(%rbp)
    3c4e: 49 8b 00                     	movq	(%r8), %rax
    3c51: 49 8b 48 08                  	movq	0x8(%r8), %rcx
    3c55: 48 89 4d 98                  	movq	%rcx, -0x68(%rbp)
    3c59: 48 89 45 90                  	movq	%rax, -0x70(%rbp)
    3c5d: 48 c7 45 b0 00 00 00 00      	movq	$0x0, -0x50(%rbp)
    3c65: 48 c7 45 b8 00 00 00 00      	movq	$0x0, -0x48(%rbp)
    3c6d: 48 c7 45 c0 00 00 00 00      	movq	$0x0, -0x40(%rbp)
    3c75: 48 c7 45 c8 00 00 00 00      	movq	$0x0, -0x38(%rbp)
    3c7d: 31 c0                        	xorl	%eax, %eax
    3c7f: 90                           	nop
<L6>:
    3c80: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3c85: 0f b6 54 05 91               	movzbl	-0x6f(%rbp,%rax), %edx
    3c8a: 80 f1 5c                     	xorb	$0x5c, %cl
    3c8d: 88 8c 05 20 fe ff ff         	movb	%cl, -0x1e0(%rbp,%rax)
    3c94: 80 f2 5c                     	xorb	$0x5c, %dl
    3c97: 88 94 05 21 fe ff ff         	movb	%dl, -0x1df(%rbp,%rax)
    3c9e: 0f b6 4c 05 92               	movzbl	-0x6e(%rbp,%rax), %ecx
    3ca3: 80 f1 5c                     	xorb	$0x5c, %cl
    3ca6: 88 8c 05 22 fe ff ff         	movb	%cl, -0x1de(%rbp,%rax)
    3cad: 0f b6 4c 05 93               	movzbl	-0x6d(%rbp,%rax), %ecx
    3cb2: 80 f1 5c                     	xorb	$0x5c, %cl
    3cb5: 88 8c 05 23 fe ff ff         	movb	%cl, -0x1dd(%rbp,%rax)
    3cbc: 48 83 c0 04                  	addq	$0x4, %rax
    3cc0: 48 83 f8 40                  	cmpq	$0x40, %rax
    3cc4: 75 ba                        	jne	 <L6>
    3cc6: b8 03 00 00 00               	movl	$0x3, %eax
    3ccb: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L7>:
    3cd0: 0f b6 4c 05 8d               	movzbl	-0x73(%rbp,%rax), %ecx
    3cd5: 0f b6 54 05 8e               	movzbl	-0x72(%rbp,%rax), %edx
    3cda: 80 f1 36                     	xorb	$0x36, %cl
    3cdd: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    3ce4: 80 f2 36                     	xorb	$0x36, %dl
    3ce7: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    3cee: 0f b6 4c 05 8f               	movzbl	-0x71(%rbp,%rax), %ecx
    3cf3: 80 f1 36                     	xorb	$0x36, %cl
    3cf6: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    3cfd: 0f b6 4c 05 90               	movzbl	-0x70(%rbp,%rax), %ecx
    3d02: 80 f1 36                     	xorb	$0x36, %cl
    3d05: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    3d0c: 48 83 c0 04                  	addq	$0x4, %rax
    3d10: 48 83 f8 43                  	cmpq	$0x43, %rax
    3d14: 75 ba                        	jne	 <L7>
    3d16: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x33d>
		0000000000003d19:  X86_64_RELOC_SIGNED	___anon_7525
    3d1d: 0f 29 85 10 fe ff ff         	movaps	%xmm0, -0x1f0(%rbp)
    3d24: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x33b>
		0000000000003d27:  X86_64_RELOC_SIGNED	___anon_7525
    3d2b: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    3d32: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x339>
		0000000000003d35:  X86_64_RELOC_SIGNED	___anon_7525
    3d39: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    3d40: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x337>
		0000000000003d43:  X86_64_RELOC_SIGNED	___anon_7525
    3d47: 0f 29 85 e0 fd ff ff         	movaps	%xmm0, -0x220(%rbp)
    3d4e: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x335>
		0000000000003d51:  X86_64_RELOC_SIGNED	___anon_7525
    3d55: 0f 29 85 d0 fd ff ff         	movaps	%xmm0, -0x230(%rbp)
    3d5c: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x333>
		0000000000003d5f:  X86_64_RELOC_SIGNED	___anon_7525
    3d63: 0f 29 85 c0 fd ff ff         	movaps	%xmm0, -0x240(%rbp)
    3d6a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x331>
		0000000000003d6d:  X86_64_RELOC_SIGNED	___anon_7525
    3d71: 0f 29 85 b0 fd ff ff         	movaps	%xmm0, -0x250(%rbp)
    3d78: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3d7f: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    3d86: e8 00 00 00 00               	callq	 <L8>
		0000000000003d87:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L8>:
    3d8b: 48 83 85 d0 fd ff ff 40      	addq	$0x40, -0x230(%rbp)
    3d93: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
    3d9a: 48 85 ff                     	testq	%rdi, %rdi
    3d9d: 0f 84 d4 00 00 00            	je	 <L17>
    3da3: 48 39 fb                     	cmpq	%rdi, %rbx
    3da6: 0f 83 cd 00 00 00            	jae	 <L18>
    3dac: bb 40 00 00 00               	movl	$0x40, %ebx
    3db1: 48 29 fb                     	subq	%rdi, %rbx
    3db4: 4c 01 ef                     	addq	%r13, %rdi
    3db7: 4c 89 e6                     	movq	%r12, %rsi
    3dba: 48 89 da                     	movq	%rbx, %rdx
    3dbd: e8 00 00 00 00               	callq	 <L9>
		0000000000003dbe:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
    3dc2: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3dc9: 4c 89 ee                     	movq	%r13, %rsi
    3dcc: e8 00 00 00 00               	callq	 <L10>
		0000000000003dcd:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L10>:
    3dd1: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
    3dd8: 31 ff                        	xorl	%edi, %edi
    3dda: e9 9c 00 00 00               	jmp	 <L19>
<L11>:
    3ddf: 31 c0                        	xorl	%eax, %eax
<L12>:
    3de1: 31 db                        	xorl	%ebx, %ebx
<L13>:
    3de3: 49 01 dc                     	addq	%rbx, %r12
    3de6: 4d 89 fe                     	movq	%r15, %r14
    3de9: 49 29 de                     	subq	%rbx, %r14
    3dec: 4c 8d ad 88 fe ff ff         	leaq	-0x178(%rbp), %r13
    3df3: 0f b6 c0                     	movzbl	%al, %eax
    3df6: 48 8d bc 05 88 fe ff ff      	leaq	-0x178(%rbp,%rax), %rdi
    3dfe: 4c 89 e6                     	movq	%r12, %rsi
    3e01: 4c 89 f2                     	movq	%r14, %rdx
    3e04: e8 00 00 00 00               	callq	 <L14>
		0000000000003e05:  X86_64_RELOC_BRANCH	_memcpy
<L14>:
    3e09: 0f b6 bd c8 fe ff ff         	movzbl	-0x138(%rbp), %edi
    3e10: 4c 01 f7                     	addq	%r14, %rdi
    3e13: 40 88 bd c8 fe ff ff         	movb	%dil, -0x138(%rbp)
    3e1a: 4c 03 bd 80 fe ff ff         	addq	-0x180(%rbp), %r15
    3e21: 4c 89 bd 80 fe ff ff         	movq	%r15, -0x180(%rbp)
    3e28: 40 84 ff                     	testb	%dil, %dil
    3e2b: 0f 84 d3 00 00 00            	je	 <L23>
    3e31: 40 80 ff 3f                  	cmpb	$0x3f, %dil
    3e35: 0f 82 cb 00 00 00            	jb	 <L24>
    3e3b: b0 40                        	movb	$0x40, %al
    3e3d: 40 28 f8                     	subb	%dil, %al
    3e40: 44 0f b6 e0                  	movzbl	%al, %r12d
    3e44: 4c 01 ef                     	addq	%r13, %rdi
    3e47: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3e4b: 4c 89 e2                     	movq	%r12, %rdx
    3e4e: e8 00 00 00 00               	callq	 <L15>
		0000000000003e4f:  X86_64_RELOC_BRANCH	_memcpy
<L15>:
    3e53: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3e5a: 4c 89 ee                     	movq	%r13, %rsi
    3e5d: e8 00 00 00 00               	callq	 <L16>
		0000000000003e5e:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L16>:
    3e62: c6 85 c8 fe ff ff 00         	movb	$0x0, -0x138(%rbp)
    3e69: 31 ff                        	xorl	%edi, %edi
    3e6b: 4c 8b bd 80 fe ff ff         	movq	-0x180(%rbp), %r15
    3e72: e9 92 00 00 00               	jmp	 <L25>
<L17>:
    3e77: 31 ff                        	xorl	%edi, %edi
<L18>:
    3e79: 31 db                        	xorl	%ebx, %ebx
<L19>:
    3e7b: 49 01 dc                     	addq	%rbx, %r12
    3e7e: 4d 89 fe                     	movq	%r15, %r14
    3e81: 49 29 de                     	subq	%rbx, %r14
    3e84: 40 0f b6 ff                  	movzbl	%dil, %edi
    3e88: 4c 01 ef                     	addq	%r13, %rdi
    3e8b: 4c 89 e6                     	movq	%r12, %rsi
    3e8e: 4c 89 f2                     	movq	%r14, %rdx
    3e91: e8 00 00 00 00               	callq	 <L20>
		0000000000003e92:  X86_64_RELOC_BRANCH	_memcpy
<L20>:
    3e96: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
    3e9d: 4c 01 f7                     	addq	%r14, %rdi
    3ea0: 40 88 bd 18 fe ff ff         	movb	%dil, -0x1e8(%rbp)
    3ea7: 4c 03 bd d0 fd ff ff         	addq	-0x230(%rbp), %r15
    3eae: 4c 89 bd d0 fd ff ff         	movq	%r15, -0x230(%rbp)
    3eb5: 40 84 ff                     	testb	%dil, %dil
    3eb8: 0f 84 65 01 00 00            	je	 <L31>
    3ebe: 40 80 ff 3f                  	cmpb	$0x3f, %dil
    3ec2: 0f 82 5d 01 00 00            	jb	 <L32>
    3ec8: b0 40                        	movb	$0x40, %al
    3eca: 40 28 f8                     	subb	%dil, %al
    3ecd: 44 0f b6 e0                  	movzbl	%al, %r12d
    3ed1: 4c 01 ef                     	addq	%r13, %rdi
    3ed4: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3ed8: 4c 89 e2                     	movq	%r12, %rdx
    3edb: e8 00 00 00 00               	callq	 <L21>
		0000000000003edc:  X86_64_RELOC_BRANCH	_memcpy
<L21>:
    3ee0: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    3ee7: 4c 89 ee                     	movq	%r13, %rsi
    3eea: e8 00 00 00 00               	callq	 <L22>
		0000000000003eeb:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L22>:
    3eef: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
    3ef6: 31 ff                        	xorl	%edi, %edi
    3ef8: 4c 8b bd d0 fd ff ff         	movq	-0x230(%rbp), %r15
    3eff: e9 24 01 00 00               	jmp	 <L33>
<L23>:
    3f04: 31 ff                        	xorl	%edi, %edi
<L24>:
    3f06: 45 31 e4                     	xorl	%r12d, %r12d
<L25>:
    3f09: 4a 8d 74 25 d7               	leaq	-0x29(%rbp,%r12), %rsi
    3f0e: bb 01 00 00 00               	movl	$0x1, %ebx
    3f13: 4c 29 e3                     	subq	%r12, %rbx
    3f16: 40 0f b6 c7                  	movzbl	%dil, %eax
    3f1a: 49 01 c5                     	addq	%rax, %r13
    3f1d: 4c 89 ef                     	movq	%r13, %rdi
    3f20: 48 89 da                     	movq	%rbx, %rdx
    3f23: e8 00 00 00 00               	callq	 <L26>
		0000000000003f24:  X86_64_RELOC_BRANCH	_memcpy
<L26>:
    3f28: 00 9d c8 fe ff ff            	addb	%bl, -0x138(%rbp)
    3f2e: 49 ff c7                     	incq	%r15
    3f31: 4c 89 bd 80 fe ff ff         	movq	%r15, -0x180(%rbp)
    3f38: 48 8d bd 60 fe ff ff         	leaq	-0x1a0(%rbp), %rdi
    3f3f: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3f43: e8 00 00 00 00               	callq	 <L27>
		0000000000003f44:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L27>:
    3f48: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x56f>
		0000000000003f4b:  X86_64_RELOC_SIGNED	___anon_7525
    3f4f: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3f53: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x56a>
		0000000000003f56:  X86_64_RELOC_SIGNED	___anon_7525
    3f5a: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3f61: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x568>
		0000000000003f64:  X86_64_RELOC_SIGNED	___anon_7525
    3f68: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3f6f: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x566>
		0000000000003f72:  X86_64_RELOC_SIGNED	___anon_7525
    3f76: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3f7d: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x564>
		0000000000003f80:  X86_64_RELOC_SIGNED	___anon_7525
    3f84: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    3f8b: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x562>
		0000000000003f8e:  X86_64_RELOC_SIGNED	___anon_7525
    3f92: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    3f99: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x560>
		0000000000003f9c:  X86_64_RELOC_SIGNED	___anon_7525
    3fa0: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    3fa7: 48 8d b5 d0 fe ff ff         	leaq	-0x130(%rbp), %rsi
    3fae: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    3fb5: e8 00 00 00 00               	callq	 <L28>
		0000000000003fb6:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L28>:
    3fba: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    3fbe: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    3fc5: 49 83 c7 40                  	addq	$0x40, %r15
    3fc9: 4c 8d b5 48 ff ff ff         	leaq	-0xb8(%rbp), %r14
    3fd0: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    3fd7: 48 85 ff                     	testq	%rdi, %rdi
    3fda: 0f 84 5f 01 00 00            	je	 <L39>
    3fe0: 40 80 ff 20                  	cmpb	$0x20, %dil
    3fe4: 0f 82 57 01 00 00            	jb	 <L40>
    3fea: 41 bc 40 00 00 00            	movl	$0x40, %r12d
    3ff0: 49 29 fc                     	subq	%rdi, %r12
    3ff3: 4c 01 f7                     	addq	%r14, %rdi
    3ff6: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    3ffa: 4c 89 e2                     	movq	%r12, %rdx
    3ffd: e8 00 00 00 00               	callq	 <L29>
		0000000000003ffe:  X86_64_RELOC_BRANCH	_memcpy
<L29>:
    4002: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    4009: 4c 89 f6                     	movq	%r14, %rsi
    400c: e8 00 00 00 00               	callq	 <L30>
		000000000000400d:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L30>:
    4011: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    4015: 31 ff                        	xorl	%edi, %edi
    4017: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    401e: e9 21 01 00 00               	jmp	 <L41>
<L31>:
    4023: 31 ff                        	xorl	%edi, %edi
<L32>:
    4025: 45 31 e4                     	xorl	%r12d, %r12d
<L33>:
    4028: 4a 8d 74 25 d7               	leaq	-0x29(%rbp,%r12), %rsi
    402d: bb 01 00 00 00               	movl	$0x1, %ebx
    4032: 4c 29 e3                     	subq	%r12, %rbx
    4035: 40 0f b6 c7                  	movzbl	%dil, %eax
    4039: 49 01 c5                     	addq	%rax, %r13
    403c: 4c 89 ef                     	movq	%r13, %rdi
    403f: 48 89 da                     	movq	%rbx, %rdx
    4042: e8 00 00 00 00               	callq	 <L34>
		0000000000004043:  X86_64_RELOC_BRANCH	_memcpy
<L34>:
    4047: 00 9d 18 fe ff ff            	addb	%bl, -0x1e8(%rbp)
    404d: 49 ff c7                     	incq	%r15
    4050: 4c 89 bd d0 fd ff ff         	movq	%r15, -0x230(%rbp)
    4057: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
    405e: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    4062: e8 00 00 00 00               	callq	 <L35>
		0000000000004063:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L35>:
    4067: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x68e>
		000000000000406a:  X86_64_RELOC_SIGNED	___anon_7525
    406e: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    4072: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x689>
		0000000000004075:  X86_64_RELOC_SIGNED	___anon_7525
    4079: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    4080: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x687>
		0000000000004083:  X86_64_RELOC_SIGNED	___anon_7525
    4087: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    408e: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x685>
		0000000000004091:  X86_64_RELOC_SIGNED	___anon_7525
    4095: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    409c: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x683>
		000000000000409f:  X86_64_RELOC_SIGNED	___anon_7525
    40a3: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    40aa: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x681>
		00000000000040ad:  X86_64_RELOC_SIGNED	___anon_7525
    40b1: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    40b8: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x67f>
		00000000000040bb:  X86_64_RELOC_SIGNED	___anon_7525
    40bf: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    40c6: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    40cd: 48 8d b5 20 fe ff ff         	leaq	-0x1e0(%rbp), %rsi
    40d4: e8 00 00 00 00               	callq	 <L36>
		00000000000040d5:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L36>:
    40d9: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    40dd: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    40e4: 49 83 c7 40                  	addq	$0x40, %r15
    40e8: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    40ef: 48 85 ff                     	testq	%rdi, %rdi
    40f2: 0f 84 a7 00 00 00            	je	 <L45>
    40f8: 40 80 ff 20                  	cmpb	$0x20, %dil
    40fc: 4c 8d a5 48 ff ff ff         	leaq	-0xb8(%rbp), %r12
    4103: 0f 82 a4 00 00 00            	jb	 <L46>
    4109: 41 be 40 00 00 00            	movl	$0x40, %r14d
    410f: 49 29 fe                     	subq	%rdi, %r14
    4112: 4c 01 e7                     	addq	%r12, %rdi
    4115: 48 8d 75 90                  	leaq	-0x70(%rbp), %rsi
    4119: 4c 89 f2                     	movq	%r14, %rdx
    411c: e8 00 00 00 00               	callq	 <L37>
		000000000000411d:  X86_64_RELOC_BRANCH	_memcpy
<L37>:
    4121: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    4128: 4c 89 e6                     	movq	%r12, %rsi
    412b: e8 00 00 00 00               	callq	 <L38>
		000000000000412c:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L38>:
    4130: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    4134: 31 ff                        	xorl	%edi, %edi
    4136: 4c 8b bd 40 ff ff ff         	movq	-0xc0(%rbp), %r15
    413d: eb 71                        	jmp	 <L47>
<L39>:
    413f: 31 ff                        	xorl	%edi, %edi
<L40>:
    4141: 45 31 e4                     	xorl	%r12d, %r12d
<L41>:
    4144: 4a 8d 74 25 90               	leaq	-0x70(%rbp,%r12), %rsi
    4149: bb 20 00 00 00               	movl	$0x20, %ebx
    414e: 4c 29 e3                     	subq	%r12, %rbx
    4151: 40 0f b6 c7                  	movzbl	%dil, %eax
    4155: 49 01 c6                     	addq	%rax, %r14
    4158: 4c 89 f7                     	movq	%r14, %rdi
    415b: 48 89 da                     	movq	%rbx, %rdx
    415e: e8 00 00 00 00               	callq	 <L42>
		000000000000415f:  X86_64_RELOC_BRANCH	_memcpy
<L42>:
    4163: 00 5d 88                     	addb	%bl, -0x78(%rbp)
    4166: 49 83 c7 20                  	addq	$0x20, %r15
    416a: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    4171: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    4178: 48 8d 9d 90 fd ff ff         	leaq	-0x270(%rbp), %rbx
    417f: 48 89 de                     	movq	%rbx, %rsi
    4182: e8 00 00 00 00               	callq	 <L43>
		0000000000004183:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L43>:
    4187: 48 8b bd 18 ff ff ff         	movq	-0xe8(%rbp), %rdi
    418e: 48 89 de                     	movq	%rbx, %rsi
    4191: 48 8b 95 10 ff ff ff         	movq	-0xf0(%rbp), %rdx
    4198: e8 00 00 00 00               	callq	 <L44>
		0000000000004199:  X86_64_RELOC_BRANCH	_memcpy
<L44>:
    419d: eb 51                        	jmp	 <L49>
<L45>:
    419f: 31 ff                        	xorl	%edi, %edi
    41a1: 45 31 f6                     	xorl	%r14d, %r14d
    41a4: 4c 8d a5 48 ff ff ff         	leaq	-0xb8(%rbp), %r12
    41ab: eb 03                        	jmp	 <L47>
<L46>:
    41ad: 45 31 f6                     	xorl	%r14d, %r14d
<L47>:
    41b0: 4a 8d 74 35 90               	leaq	-0x70(%rbp,%r14), %rsi
    41b5: bb 20 00 00 00               	movl	$0x20, %ebx
    41ba: 4c 29 f3                     	subq	%r14, %rbx
    41bd: 40 0f b6 c7                  	movzbl	%dil, %eax
    41c1: 49 01 c4                     	addq	%rax, %r12
    41c4: 4c 89 e7                     	movq	%r12, %rdi
    41c7: 48 89 da                     	movq	%rbx, %rdx
    41ca: e8 00 00 00 00               	callq	 <L48>
		00000000000041cb:  X86_64_RELOC_BRANCH	_memcpy
<L48>:
    41cf: 00 5d 88                     	addb	%bl, -0x78(%rbp)
    41d2: 49 83 c7 20                  	addq	$0x20, %r15
    41d6: 4c 89 bd 40 ff ff ff         	movq	%r15, -0xc0(%rbp)
    41dd: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    41e4: 48 8b b5 18 ff ff ff         	movq	-0xe8(%rbp), %rsi
    41eb: e8 00 00 00 00               	callq	 <L49>
		00000000000041ec:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L49>:
    41f0: 48 81 c4 48 02 00 00         	addq	$0x248, %rsp            ## imm = 0x248
    41f7: 5b                           	popq	%rbx
    41f8: 41 5c                        	popq	%r12
    41fa: 41 5d                        	popq	%r13
    41fc: 41 5e                        	popq	%r14
    41fe: 41 5f                        	popq	%r15
    4200: 5d                           	popq	%rbp
    4201: c3                           	retq
    4202: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    420c: 0f 1f 40 00                  	nopl	(%rax)

0000000000004210 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
    4210: 55                           	pushq	%rbp
    4211: 48 89 e5                     	movq	%rsp, %rbp
    4214: 41 57                        	pushq	%r15
    4216: 41 56                        	pushq	%r14
    4218: 53                           	pushq	%rbx
    4219: 50                           	pushq	%rax
    421a: 48 89 f3                     	movq	%rsi, %rbx
    421d: 49 89 fe                     	movq	%rdi, %r14
    4220: 4c 8d 7f 28                  	leaq	0x28(%rdi), %r15
    4224: 0f b6 47 68                  	movzbl	0x68(%rdi), %eax
    4228: 48 8d 7c 07 28               	leaq	0x28(%rdi,%rax), %rdi
    422d: be 40 00 00 00               	movl	$0x40, %esi
    4232: 48 29 c6                     	subq	%rax, %rsi
    4235: e8 00 00 00 00               	callq	 <L0>
		0000000000004236:  X86_64_RELOC_BRANCH	___bzero
<L0>:
    423a: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
    423f: 41 c6 44 06 28 80            	movb	$-0x80, 0x28(%r14,%rax)
    4245: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
    424a: 8d 48 01                     	leal	0x1(%rax), %ecx
    424d: 41 88 4e 68                  	movb	%cl, 0x68(%r14)
    4251: 3c 37                        	cmpb	$0x37, %al
    4253: 76 42                        	jbe	 <L2>
    4255: 4c 89 f7                     	movq	%r14, %rdi
    4258: 4c 89 fe                     	movq	%r15, %rsi
    425b: e8 00 00 00 00               	callq	 <L1>
		000000000000425c:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L1>:
    4260: 49 c7 47 30 00 00 00 00      	movq	$0x0, 0x30(%r15)
    4268: 49 c7 47 28 00 00 00 00      	movq	$0x0, 0x28(%r15)
    4270: 49 c7 47 20 00 00 00 00      	movq	$0x0, 0x20(%r15)
    4278: 49 c7 47 18 00 00 00 00      	movq	$0x0, 0x18(%r15)
    4280: 49 c7 47 10 00 00 00 00      	movq	$0x0, 0x10(%r15)
    4288: 49 c7 47 08 00 00 00 00      	movq	$0x0, 0x8(%r15)
    4290: 49 c7 07 00 00 00 00         	movq	$0x0, (%r15)
<L2>:
    4297: 49 8b 46 20                  	movq	0x20(%r14), %rax
    429b: 89 c1                        	movl	%eax, %ecx
    429d: c1 e9 05                     	shrl	$0x5, %ecx
    42a0: 8d 14 c5 00 00 00 00         	leal	(,%rax,8), %edx
    42a7: 41 88 56 67                  	movb	%dl, 0x67(%r14)
    42ab: 41 88 4e 66                  	movb	%cl, 0x66(%r14)
    42af: 89 c1                        	movl	%eax, %ecx
    42b1: c1 e9 0d                     	shrl	$0xd, %ecx
    42b4: 41 88 4e 65                  	movb	%cl, 0x65(%r14)
    42b8: 89 c1                        	movl	%eax, %ecx
    42ba: c1 e9 15                     	shrl	$0x15, %ecx
    42bd: 41 88 4e 64                  	movb	%cl, 0x64(%r14)
    42c1: 48 89 c1                     	movq	%rax, %rcx
    42c4: 48 c1 e9 1d                  	shrq	$0x1d, %rcx
    42c8: 41 88 4e 63                  	movb	%cl, 0x63(%r14)
    42cc: 48 89 c1                     	movq	%rax, %rcx
    42cf: 48 c1 e9 25                  	shrq	$0x25, %rcx
    42d3: 41 88 4e 62                  	movb	%cl, 0x62(%r14)
    42d7: 48 89 c1                     	movq	%rax, %rcx
    42da: 48 c1 e9 2d                  	shrq	$0x2d, %rcx
    42de: 41 88 4e 61                  	movb	%cl, 0x61(%r14)
    42e2: 48 c1 e8 35                  	shrq	$0x35, %rax
    42e6: 41 88 46 60                  	movb	%al, 0x60(%r14)
    42ea: 4c 89 f7                     	movq	%r14, %rdi
    42ed: 4c 89 fe                     	movq	%r15, %rsi
    42f0: e8 00 00 00 00               	callq	 <L3>
		00000000000042f1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L3>:
    42f5: 41 8b 06                     	movl	(%r14), %eax
    42f8: 0f c8                        	bswapl	%eax
    42fa: 89 03                        	movl	%eax, (%rbx)
    42fc: 41 8b 46 04                  	movl	0x4(%r14), %eax
    4300: 0f c8                        	bswapl	%eax
    4302: 89 43 04                     	movl	%eax, 0x4(%rbx)
    4305: 41 8b 46 08                  	movl	0x8(%r14), %eax
    4309: 0f c8                        	bswapl	%eax
    430b: 89 43 08                     	movl	%eax, 0x8(%rbx)
    430e: 41 8b 46 0c                  	movl	0xc(%r14), %eax
    4312: 0f c8                        	bswapl	%eax
    4314: 89 43 0c                     	movl	%eax, 0xc(%rbx)
    4317: 41 8b 46 10                  	movl	0x10(%r14), %eax
    431b: 0f c8                        	bswapl	%eax
    431d: 89 43 10                     	movl	%eax, 0x10(%rbx)
    4320: 41 8b 46 14                  	movl	0x14(%r14), %eax
    4324: 0f c8                        	bswapl	%eax
    4326: 89 43 14                     	movl	%eax, 0x14(%rbx)
    4329: 41 8b 46 18                  	movl	0x18(%r14), %eax
    432d: 0f c8                        	bswapl	%eax
    432f: 89 43 18                     	movl	%eax, 0x18(%rbx)
    4332: 41 8b 46 1c                  	movl	0x1c(%r14), %eax
    4336: 0f c8                        	bswapl	%eax
    4338: 89 43 1c                     	movl	%eax, 0x1c(%rbx)
    433b: 48 83 c4 08                  	addq	$0x8, %rsp
    433f: 5b                           	popq	%rbx
    4340: 41 5e                        	popq	%r14
    4342: 41 5f                        	popq	%r15
    4344: 5d                           	popq	%rbp
    4345: c3                           	retq
    4346: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)

0000000000004350 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
    4350: 55                           	pushq	%rbp
    4351: 48 89 e5                     	movq	%rsp, %rbp
    4354: 41 57                        	pushq	%r15
    4356: 41 56                        	pushq	%r14
    4358: 41 55                        	pushq	%r13
    435a: 41 54                        	pushq	%r12
    435c: 53                           	pushq	%rbx
    435d: 48 81 ec 88 00 00 00         	subq	$0x88, %rsp
    4364: f3 0f 6f 06                  	movdqu	(%rsi), %xmm0
    4368: 66 0f 6f 0d 10 21 00 00      	movdqa	, %xmm1 <_audit_handshake256+0x130>
		000000000000436c:  X86_64_RELOC_SIGNED	__literal16
    4370: 66 0f 38 00 c1               	pshufb	%xmm1, %xmm0
    4375: 66 0f 7f 85 d0 fe ff ff      	movdqa	%xmm0, -0x130(%rbp)
    437d: f3 0f 6f 56 10               	movdqu	0x10(%rsi), %xmm2
    4382: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    4387: 66 0f 7f 95 e0 fe ff ff      	movdqa	%xmm2, -0x120(%rbp)
    438f: f3 0f 6f 56 20               	movdqu	0x20(%rsi), %xmm2
    4394: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    4399: 66 0f 7f 95 f0 fe ff ff      	movdqa	%xmm2, -0x110(%rbp)
    43a1: f3 0f 6f 56 30               	movdqu	0x30(%rsi), %xmm2
    43a6: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    43ab: 66 0f 7f 95 00 ff ff ff      	movdqa	%xmm2, -0x100(%rbp)
    43b3: b8 10 00 00 00               	movl	$0x10, %eax
    43b8: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L0>:
    43c0: 8b 8c 85 94 fe ff ff         	movl	-0x16c(%rbp,%rax,4), %ecx
    43c7: 8b 94 85 b4 fe ff ff         	movl	-0x14c(%rbp,%rax,4), %edx
    43ce: 03 94 85 90 fe ff ff         	addl	-0x170(%rbp,%rax,4), %edx
    43d5: 89 ce                        	movl	%ecx, %esi
    43d7: c1 c6 19                     	roll	$0x19, %esi
    43da: 41 89 c8                     	movl	%ecx, %r8d
    43dd: 41 c1 c0 0e                  	roll	$0xe, %r8d
    43e1: 41 31 f0                     	xorl	%esi, %r8d
    43e4: c1 e9 03                     	shrl	$0x3, %ecx
    43e7: 8b b4 85 c8 fe ff ff         	movl	-0x138(%rbp,%rax,4), %esi
    43ee: 41 89 f1                     	movl	%esi, %r9d
    43f1: 41 c1 c1 0f                  	roll	$0xf, %r9d
    43f5: 44 31 c1                     	xorl	%r8d, %ecx
    43f8: 41 89 f0                     	movl	%esi, %r8d
    43fb: 41 c1 c0 0d                  	roll	$0xd, %r8d
    43ff: 01 d1                        	addl	%edx, %ecx
    4401: 45 31 c8                     	xorl	%r9d, %r8d
    4404: c1 ee 0a                     	shrl	$0xa, %esi
    4407: 44 31 c6                     	xorl	%r8d, %esi
    440a: 01 ce                        	addl	%ecx, %esi
    440c: 89 b4 85 d0 fe ff ff         	movl	%esi, -0x130(%rbp,%rax,4)
    4413: 48 ff c0                     	incq	%rax
    4416: 48 83 f8 40                  	cmpq	$0x40, %rax
    441a: 75 a4                        	jne	 <L0>
    441c: 44 8b 07                     	movl	(%rdi), %r8d
    441f: 8b 5f 04                     	movl	0x4(%rdi), %ebx
    4422: 44 8b 57 08                  	movl	0x8(%rdi), %r10d
    4426: 44 8b 5f 10                  	movl	0x10(%rdi), %r11d
    442a: 8b 4f 14                     	movl	0x14(%rdi), %ecx
    442d: 8b 77 18                     	movl	0x18(%rdi), %esi
    4430: 44 89 d8                     	movl	%r11d, %eax
    4433: c1 c0 1a                     	roll	$0x1a, %eax
    4436: 44 89 da                     	movl	%r11d, %edx
    4439: c1 c2 15                     	roll	$0x15, %edx
    443c: 31 c2                        	xorl	%eax, %edx
    443e: 44 89 d8                     	movl	%r11d, %eax
    4441: c1 c0 07                     	roll	$0x7, %eax
    4444: 31 d0                        	xorl	%edx, %eax
    4446: 89 f2                        	movl	%esi, %edx
    4448: 31 ca                        	xorl	%ecx, %edx
    444a: 44 21 da                     	andl	%r11d, %edx
    444d: 03 47 1c                     	addl	0x1c(%rdi), %eax
    4450: 31 f2                        	xorl	%esi, %edx
    4452: 66 41 0f 7e c1               	movd	%xmm0, %r9d
    4457: 41 01 c1                     	addl	%eax, %r9d
    445a: 46 8d b4 0a 98 2f 8a 42      	leal	0x428a2f98(%rdx,%r9), %r14d
    4462: 8b 57 0c                     	movl	0xc(%rdi), %edx
    4465: 44 89 c0                     	movl	%r8d, %eax
    4468: c1 c0 1e                     	roll	$0x1e, %eax
    446b: 44 01 f2                     	addl	%r14d, %edx
    446e: 45 89 c1                     	movl	%r8d, %r9d
    4471: 41 c1 c1 13                  	roll	$0x13, %r9d
    4475: 41 31 c1                     	xorl	%eax, %r9d
    4478: 45 89 c7                     	movl	%r8d, %r15d
    447b: 41 c1 c7 0a                  	roll	$0xa, %r15d
    447f: 45 31 cf                     	xorl	%r9d, %r15d
    4482: 41 89 d1                     	movl	%edx, %r9d
    4485: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    4489: 44 89 d0                     	movl	%r10d, %eax
    448c: 41 89 d5                     	movl	%edx, %r13d
    448f: 41 c1 c5 15                  	roll	$0x15, %r13d
    4493: 45 31 cd                     	xorl	%r9d, %r13d
    4496: 41 89 d4                     	movl	%edx, %r12d
    4499: 41 c1 c4 07                  	roll	$0x7, %r12d
    449d: 45 31 ec                     	xorl	%r13d, %r12d
    44a0: 41 89 c9                     	movl	%ecx, %r9d
    44a3: 45 31 d9                     	xorl	%r11d, %r9d
    44a6: 41 21 d1                     	andl	%edx, %r9d
    44a9: 41 31 c9                     	xorl	%ecx, %r9d
    44ac: 03 b5 d4 fe ff ff            	addl	-0x12c(%rbp), %esi
    44b2: 44 01 ce                     	addl	%r9d, %esi
    44b5: 46 8d 0c 26                  	leal	(%rsi,%r12), %r9d
    44b9: 47 8d 8c 0a 91 44 37 71      	leal	0x71374491(%r10,%r9), %r9d
    44c1: 41 09 da                     	orl	%ebx, %r10d
    44c4: 45 21 c2                     	andl	%r8d, %r10d
    44c7: 21 d8                        	andl	%ebx, %eax
    44c9: 44 09 d0                     	orl	%r10d, %eax
    44cc: 44 01 f8                     	addl	%r15d, %eax
    44cf: 44 01 f0                     	addl	%r14d, %eax
    44d2: 41 89 c2                     	movl	%eax, %r10d
    44d5: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    44d9: 45 8d b4 34 91 44 37 71      	leal	0x71374491(%r12,%rsi), %r14d
    44e1: 89 c6                        	movl	%eax, %esi
    44e3: c1 c6 13                     	roll	$0x13, %esi
    44e6: 44 31 d6                     	xorl	%r10d, %esi
    44e9: 41 89 c7                     	movl	%eax, %r15d
    44ec: 41 c1 c7 0a                  	roll	$0xa, %r15d
    44f0: 41 31 f7                     	xorl	%esi, %r15d
    44f3: 45 89 ca                     	movl	%r9d, %r10d
    44f6: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    44fa: 89 de                        	movl	%ebx, %esi
    44fc: 45 89 cd                     	movl	%r9d, %r13d
    44ff: 41 c1 c5 15                  	roll	$0x15, %r13d
    4503: 45 31 d5                     	xorl	%r10d, %r13d
    4506: 45 89 cc                     	movl	%r9d, %r12d
    4509: 41 c1 c4 07                  	roll	$0x7, %r12d
    450d: 45 31 ec                     	xorl	%r13d, %r12d
    4510: 41 89 d2                     	movl	%edx, %r10d
    4513: 45 31 da                     	xorl	%r11d, %r10d
    4516: 45 21 ca                     	andl	%r9d, %r10d
    4519: 45 31 da                     	xorl	%r11d, %r10d
    451c: 03 8d d8 fe ff ff            	addl	-0x128(%rbp), %ecx
    4522: 44 01 d1                     	addl	%r10d, %ecx
    4525: 46 8d 14 21                  	leal	(%rcx,%r12), %r10d
    4529: 46 8d 94 13 cf fb c0 b5      	leal	-0x4a3f0431(%rbx,%r10), %r10d
    4531: 44 09 c3                     	orl	%r8d, %ebx
    4534: 21 c3                        	andl	%eax, %ebx
    4536: 44 21 c6                     	andl	%r8d, %esi
    4539: 09 de                        	orl	%ebx, %esi
    453b: 44 01 fe                     	addl	%r15d, %esi
    453e: 44 01 f6                     	addl	%r14d, %esi
    4541: 89 f3                        	movl	%esi, %ebx
    4543: c1 c3 1e                     	roll	$0x1e, %ebx
    4546: 45 8d b4 0c cf fb c0 b5      	leal	-0x4a3f0431(%r12,%rcx), %r14d
    454e: 89 f1                        	movl	%esi, %ecx
    4550: c1 c1 13                     	roll	$0x13, %ecx
    4553: 31 d9                        	xorl	%ebx, %ecx
    4555: 89 f3                        	movl	%esi, %ebx
    4557: c1 c3 0a                     	roll	$0xa, %ebx
    455a: 31 cb                        	xorl	%ecx, %ebx
    455c: 41 89 c7                     	movl	%eax, %r15d
    455f: 45 09 c7                     	orl	%r8d, %r15d
    4562: 41 21 f7                     	andl	%esi, %r15d
    4565: 89 c1                        	movl	%eax, %ecx
    4567: 44 21 c1                     	andl	%r8d, %ecx
    456a: 44 09 f9                     	orl	%r15d, %ecx
    456d: 01 d9                        	addl	%ebx, %ecx
    456f: 44 01 f1                     	addl	%r14d, %ecx
    4572: 44 89 d3                     	movl	%r10d, %ebx
    4575: c1 c3 1a                     	roll	$0x1a, %ebx
    4578: 45 89 d6                     	movl	%r10d, %r14d
    457b: 41 c1 c6 15                  	roll	$0x15, %r14d
    457f: 41 31 de                     	xorl	%ebx, %r14d
    4582: 44 89 d3                     	movl	%r10d, %ebx
    4585: c1 c3 07                     	roll	$0x7, %ebx
    4588: 44 31 f3                     	xorl	%r14d, %ebx
    458b: 45 89 ce                     	movl	%r9d, %r14d
    458e: 41 31 d6                     	xorl	%edx, %r14d
    4591: 45 21 d6                     	andl	%r10d, %r14d
    4594: 41 31 d6                     	xorl	%edx, %r14d
    4597: 44 03 9d dc fe ff ff         	addl	-0x124(%rbp), %r11d
    459e: 45 01 f3                     	addl	%r14d, %r11d
    45a1: 45 8d 34 1b                  	leal	(%r11,%rbx), %r14d
    45a5: 46 8d bc 1b a5 db b5 e9      	leal	-0x164a245b(%rbx,%r11), %r15d
    45ad: 41 89 cb                     	movl	%ecx, %r11d
    45b0: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    45b4: 43 8d 9c 30 a5 db b5 e9      	leal	-0x164a245b(%r8,%r14), %ebx
    45bc: 41 89 c8                     	movl	%ecx, %r8d
    45bf: 41 c1 c0 13                  	roll	$0x13, %r8d
    45c3: 45 31 d8                     	xorl	%r11d, %r8d
    45c6: 41 89 ce                     	movl	%ecx, %r14d
    45c9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    45cd: 45 31 c6                     	xorl	%r8d, %r14d
    45d0: 41 89 f0                     	movl	%esi, %r8d
    45d3: 41 09 c0                     	orl	%eax, %r8d
    45d6: 41 21 c8                     	andl	%ecx, %r8d
    45d9: 41 89 f3                     	movl	%esi, %r11d
    45dc: 41 21 c3                     	andl	%eax, %r11d
    45df: 45 09 c3                     	orl	%r8d, %r11d
    45e2: 45 01 f3                     	addl	%r14d, %r11d
    45e5: 45 01 fb                     	addl	%r15d, %r11d
    45e8: 41 89 d8                     	movl	%ebx, %r8d
    45eb: 41 c1 c0 1a                  	roll	$0x1a, %r8d
    45ef: 41 89 de                     	movl	%ebx, %r14d
    45f2: 41 c1 c6 15                  	roll	$0x15, %r14d
    45f6: 45 31 c6                     	xorl	%r8d, %r14d
    45f9: 41 89 d8                     	movl	%ebx, %r8d
    45fc: 41 c1 c0 07                  	roll	$0x7, %r8d
    4600: 45 31 f0                     	xorl	%r14d, %r8d
    4603: 45 89 d6                     	movl	%r10d, %r14d
    4606: 45 31 ce                     	xorl	%r9d, %r14d
    4609: 41 21 de                     	andl	%ebx, %r14d
    460c: 45 31 ce                     	xorl	%r9d, %r14d
    460f: 03 95 e0 fe ff ff            	addl	-0x120(%rbp), %edx
    4615: 44 01 f2                     	addl	%r14d, %edx
    4618: 41 8d 94 10 5b c2 56 39      	leal	0x3956c25b(%r8,%rdx), %edx
    4620: 01 d0                        	addl	%edx, %eax
    4622: 45 89 d8                     	movl	%r11d, %r8d
    4625: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    4629: 45 89 de                     	movl	%r11d, %r14d
    462c: 41 c1 c6 13                  	roll	$0x13, %r14d
    4630: 45 31 c6                     	xorl	%r8d, %r14d
    4633: 45 89 df                     	movl	%r11d, %r15d
    4636: 41 c1 c7 0a                  	roll	$0xa, %r15d
    463a: 45 31 f7                     	xorl	%r14d, %r15d
    463d: 41 89 ce                     	movl	%ecx, %r14d
    4640: 41 09 f6                     	orl	%esi, %r14d
    4643: 45 21 de                     	andl	%r11d, %r14d
    4646: 41 89 c8                     	movl	%ecx, %r8d
    4649: 41 21 f0                     	andl	%esi, %r8d
    464c: 45 09 f0                     	orl	%r14d, %r8d
    464f: 45 01 f8                     	addl	%r15d, %r8d
    4652: 41 01 d0                     	addl	%edx, %r8d
    4655: 89 c2                        	movl	%eax, %edx
    4657: c1 c2 1a                     	roll	$0x1a, %edx
    465a: 41 89 c6                     	movl	%eax, %r14d
    465d: 41 c1 c6 15                  	roll	$0x15, %r14d
    4661: 41 31 d6                     	xorl	%edx, %r14d
    4664: 89 c2                        	movl	%eax, %edx
    4666: c1 c2 07                     	roll	$0x7, %edx
    4669: 44 31 f2                     	xorl	%r14d, %edx
    466c: 41 89 de                     	movl	%ebx, %r14d
    466f: 45 31 d6                     	xorl	%r10d, %r14d
    4672: 41 21 c6                     	andl	%eax, %r14d
    4675: 44 03 8d e4 fe ff ff         	addl	-0x11c(%rbp), %r9d
    467c: 45 31 d6                     	xorl	%r10d, %r14d
    467f: 45 01 f1                     	addl	%r14d, %r9d
    4682: 42 8d 94 0a f1 11 f1 59      	leal	0x59f111f1(%rdx,%r9), %edx
    468a: 01 d6                        	addl	%edx, %esi
    468c: 45 89 c1                     	movl	%r8d, %r9d
    468f: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4693: 45 89 c6                     	movl	%r8d, %r14d
    4696: 41 c1 c6 13                  	roll	$0x13, %r14d
    469a: 45 31 ce                     	xorl	%r9d, %r14d
    469d: 45 89 c7                     	movl	%r8d, %r15d
    46a0: 41 c1 c7 0a                  	roll	$0xa, %r15d
    46a4: 45 31 f7                     	xorl	%r14d, %r15d
    46a7: 45 89 de                     	movl	%r11d, %r14d
    46aa: 41 09 ce                     	orl	%ecx, %r14d
    46ad: 45 21 c6                     	andl	%r8d, %r14d
    46b0: 45 89 d9                     	movl	%r11d, %r9d
    46b3: 41 21 c9                     	andl	%ecx, %r9d
    46b6: 45 09 f1                     	orl	%r14d, %r9d
    46b9: 41 89 f6                     	movl	%esi, %r14d
    46bc: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    46c0: 45 01 f9                     	addl	%r15d, %r9d
    46c3: 41 89 f7                     	movl	%esi, %r15d
    46c6: 41 c1 c7 15                  	roll	$0x15, %r15d
    46ca: 41 01 d1                     	addl	%edx, %r9d
    46cd: 89 f2                        	movl	%esi, %edx
    46cf: c1 c2 07                     	roll	$0x7, %edx
    46d2: 45 31 f7                     	xorl	%r14d, %r15d
    46d5: 44 31 fa                     	xorl	%r15d, %edx
    46d8: 41 89 c6                     	movl	%eax, %r14d
    46db: 41 31 de                     	xorl	%ebx, %r14d
    46de: 41 21 f6                     	andl	%esi, %r14d
    46e1: 41 31 de                     	xorl	%ebx, %r14d
    46e4: 44 03 95 e8 fe ff ff         	addl	-0x118(%rbp), %r10d
    46eb: 45 01 f2                     	addl	%r14d, %r10d
    46ee: 45 89 ce                     	movl	%r9d, %r14d
    46f1: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    46f5: 46 8d 94 12 a4 82 3f 92      	leal	-0x6dc07d5c(%rdx,%r10), %r10d
    46fd: 44 89 ca                     	movl	%r9d, %edx
    4700: c1 c2 13                     	roll	$0x13, %edx
    4703: 44 01 d1                     	addl	%r10d, %ecx
    4706: 45 89 cf                     	movl	%r9d, %r15d
    4709: 41 c1 c7 0a                  	roll	$0xa, %r15d
    470d: 44 31 f2                     	xorl	%r14d, %edx
    4710: 41 31 d7                     	xorl	%edx, %r15d
    4713: 45 89 c6                     	movl	%r8d, %r14d
    4716: 45 09 de                     	orl	%r11d, %r14d
    4719: 45 21 ce                     	andl	%r9d, %r14d
    471c: 44 89 c2                     	movl	%r8d, %edx
    471f: 44 21 da                     	andl	%r11d, %edx
    4722: 44 09 f2                     	orl	%r14d, %edx
    4725: 44 01 fa                     	addl	%r15d, %edx
    4728: 41 89 ce                     	movl	%ecx, %r14d
    472b: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    472f: 44 01 d2                     	addl	%r10d, %edx
    4732: 41 89 ca                     	movl	%ecx, %r10d
    4735: 41 c1 c2 15                  	roll	$0x15, %r10d
    4739: 45 31 f2                     	xorl	%r14d, %r10d
    473c: 41 89 ce                     	movl	%ecx, %r14d
    473f: 41 c1 c6 07                  	roll	$0x7, %r14d
    4743: 45 31 d6                     	xorl	%r10d, %r14d
    4746: 41 89 f2                     	movl	%esi, %r10d
    4749: 41 31 c2                     	xorl	%eax, %r10d
    474c: 41 21 ca                     	andl	%ecx, %r10d
    474f: 41 31 c2                     	xorl	%eax, %r10d
    4752: 03 9d ec fe ff ff            	addl	-0x114(%rbp), %ebx
    4758: 44 01 d3                     	addl	%r10d, %ebx
    475b: 45 8d 94 1e d5 5e 1c ab      	leal	-0x54e3a12b(%r14,%rbx), %r10d
    4763: 89 d3                        	movl	%edx, %ebx
    4765: c1 c3 1e                     	roll	$0x1e, %ebx
    4768: 45 01 d3                     	addl	%r10d, %r11d
    476b: 41 89 d6                     	movl	%edx, %r14d
    476e: 41 c1 c6 13                  	roll	$0x13, %r14d
    4772: 41 31 de                     	xorl	%ebx, %r14d
    4775: 41 89 d7                     	movl	%edx, %r15d
    4778: 41 c1 c7 0a                  	roll	$0xa, %r15d
    477c: 45 31 f7                     	xorl	%r14d, %r15d
    477f: 45 89 ce                     	movl	%r9d, %r14d
    4782: 45 09 c6                     	orl	%r8d, %r14d
    4785: 41 21 d6                     	andl	%edx, %r14d
    4788: 44 89 cb                     	movl	%r9d, %ebx
    478b: 44 21 c3                     	andl	%r8d, %ebx
    478e: 44 09 f3                     	orl	%r14d, %ebx
    4791: 44 01 fb                     	addl	%r15d, %ebx
    4794: 44 01 d3                     	addl	%r10d, %ebx
    4797: 45 89 da                     	movl	%r11d, %r10d
    479a: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    479e: 45 89 de                     	movl	%r11d, %r14d
    47a1: 41 c1 c6 15                  	roll	$0x15, %r14d
    47a5: 45 31 d6                     	xorl	%r10d, %r14d
    47a8: 45 89 da                     	movl	%r11d, %r10d
    47ab: 41 c1 c2 07                  	roll	$0x7, %r10d
    47af: 45 31 f2                     	xorl	%r14d, %r10d
    47b2: 41 89 ce                     	movl	%ecx, %r14d
    47b5: 41 31 f6                     	xorl	%esi, %r14d
    47b8: 45 21 de                     	andl	%r11d, %r14d
    47bb: 41 31 f6                     	xorl	%esi, %r14d
    47be: 03 85 f0 fe ff ff            	addl	-0x110(%rbp), %eax
    47c4: 44 01 f0                     	addl	%r14d, %eax
    47c7: 41 8d 84 02 98 aa 07 d8      	leal	-0x27f85568(%r10,%rax), %eax
    47cf: 41 01 c0                     	addl	%eax, %r8d
    47d2: 41 89 da                     	movl	%ebx, %r10d
    47d5: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    47d9: 41 89 de                     	movl	%ebx, %r14d
    47dc: 41 c1 c6 13                  	roll	$0x13, %r14d
    47e0: 45 31 d6                     	xorl	%r10d, %r14d
    47e3: 41 89 df                     	movl	%ebx, %r15d
    47e6: 41 c1 c7 0a                  	roll	$0xa, %r15d
    47ea: 45 31 f7                     	xorl	%r14d, %r15d
    47ed: 41 89 d6                     	movl	%edx, %r14d
    47f0: 45 09 ce                     	orl	%r9d, %r14d
    47f3: 41 21 de                     	andl	%ebx, %r14d
    47f6: 41 89 d2                     	movl	%edx, %r10d
    47f9: 45 21 ca                     	andl	%r9d, %r10d
    47fc: 45 09 f2                     	orl	%r14d, %r10d
    47ff: 45 01 fa                     	addl	%r15d, %r10d
    4802: 41 01 c2                     	addl	%eax, %r10d
    4805: 44 89 c0                     	movl	%r8d, %eax
    4808: c1 c0 1a                     	roll	$0x1a, %eax
    480b: 45 89 c6                     	movl	%r8d, %r14d
    480e: 41 c1 c6 15                  	roll	$0x15, %r14d
    4812: 41 31 c6                     	xorl	%eax, %r14d
    4815: 44 89 c0                     	movl	%r8d, %eax
    4818: c1 c0 07                     	roll	$0x7, %eax
    481b: 44 31 f0                     	xorl	%r14d, %eax
    481e: 45 89 de                     	movl	%r11d, %r14d
    4821: 41 31 ce                     	xorl	%ecx, %r14d
    4824: 45 21 c6                     	andl	%r8d, %r14d
    4827: 03 b5 f4 fe ff ff            	addl	-0x10c(%rbp), %esi
    482d: 41 31 ce                     	xorl	%ecx, %r14d
    4830: 44 01 f6                     	addl	%r14d, %esi
    4833: 8d 84 30 01 5b 83 12         	leal	0x12835b01(%rax,%rsi), %eax
    483a: 41 01 c1                     	addl	%eax, %r9d
    483d: 44 89 d6                     	movl	%r10d, %esi
    4840: c1 c6 1e                     	roll	$0x1e, %esi
    4843: 45 89 d6                     	movl	%r10d, %r14d
    4846: 41 c1 c6 13                  	roll	$0x13, %r14d
    484a: 41 31 f6                     	xorl	%esi, %r14d
    484d: 45 89 d7                     	movl	%r10d, %r15d
    4850: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4854: 45 31 f7                     	xorl	%r14d, %r15d
    4857: 41 89 de                     	movl	%ebx, %r14d
    485a: 41 09 d6                     	orl	%edx, %r14d
    485d: 45 21 d6                     	andl	%r10d, %r14d
    4860: 89 de                        	movl	%ebx, %esi
    4862: 21 d6                        	andl	%edx, %esi
    4864: 44 09 f6                     	orl	%r14d, %esi
    4867: 45 89 ce                     	movl	%r9d, %r14d
    486a: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    486e: 44 01 fe                     	addl	%r15d, %esi
    4871: 45 89 cf                     	movl	%r9d, %r15d
    4874: 41 c1 c7 15                  	roll	$0x15, %r15d
    4878: 01 c6                        	addl	%eax, %esi
    487a: 44 89 c8                     	movl	%r9d, %eax
    487d: c1 c0 07                     	roll	$0x7, %eax
    4880: 45 31 f7                     	xorl	%r14d, %r15d
    4883: 44 31 f8                     	xorl	%r15d, %eax
    4886: 45 89 c6                     	movl	%r8d, %r14d
    4889: 45 31 de                     	xorl	%r11d, %r14d
    488c: 45 21 ce                     	andl	%r9d, %r14d
    488f: 45 31 de                     	xorl	%r11d, %r14d
    4892: 03 8d f8 fe ff ff            	addl	-0x108(%rbp), %ecx
    4898: 44 01 f1                     	addl	%r14d, %ecx
    489b: 41 89 f6                     	movl	%esi, %r14d
    489e: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    48a2: 8d 8c 08 be 85 31 24         	leal	0x243185be(%rax,%rcx), %ecx
    48a9: 89 f0                        	movl	%esi, %eax
    48ab: c1 c0 13                     	roll	$0x13, %eax
    48ae: 01 ca                        	addl	%ecx, %edx
    48b0: 41 89 f7                     	movl	%esi, %r15d
    48b3: 41 c1 c7 0a                  	roll	$0xa, %r15d
    48b7: 44 31 f0                     	xorl	%r14d, %eax
    48ba: 41 31 c7                     	xorl	%eax, %r15d
    48bd: 45 89 d6                     	movl	%r10d, %r14d
    48c0: 41 09 de                     	orl	%ebx, %r14d
    48c3: 41 21 f6                     	andl	%esi, %r14d
    48c6: 44 89 d0                     	movl	%r10d, %eax
    48c9: 21 d8                        	andl	%ebx, %eax
    48cb: 44 09 f0                     	orl	%r14d, %eax
    48ce: 44 01 f8                     	addl	%r15d, %eax
    48d1: 41 89 d6                     	movl	%edx, %r14d
    48d4: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    48d8: 01 c8                        	addl	%ecx, %eax
    48da: 89 d1                        	movl	%edx, %ecx
    48dc: c1 c1 15                     	roll	$0x15, %ecx
    48df: 44 31 f1                     	xorl	%r14d, %ecx
    48e2: 41 89 d6                     	movl	%edx, %r14d
    48e5: 41 c1 c6 07                  	roll	$0x7, %r14d
    48e9: 41 31 ce                     	xorl	%ecx, %r14d
    48ec: 44 89 c9                     	movl	%r9d, %ecx
    48ef: 44 31 c1                     	xorl	%r8d, %ecx
    48f2: 21 d1                        	andl	%edx, %ecx
    48f4: 44 31 c1                     	xorl	%r8d, %ecx
    48f7: 44 03 9d fc fe ff ff         	addl	-0x104(%rbp), %r11d
    48fe: 41 01 cb                     	addl	%ecx, %r11d
    4901: 43 8d 8c 1e c3 7d 0c 55      	leal	0x550c7dc3(%r14,%r11), %ecx
    4909: 41 89 c3                     	movl	%eax, %r11d
    490c: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    4910: 01 cb                        	addl	%ecx, %ebx
    4912: 41 89 c6                     	movl	%eax, %r14d
    4915: 41 c1 c6 13                  	roll	$0x13, %r14d
    4919: 45 31 de                     	xorl	%r11d, %r14d
    491c: 41 89 c7                     	movl	%eax, %r15d
    491f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4923: 45 31 f7                     	xorl	%r14d, %r15d
    4926: 41 89 f6                     	movl	%esi, %r14d
    4929: 45 09 d6                     	orl	%r10d, %r14d
    492c: 41 21 c6                     	andl	%eax, %r14d
    492f: 41 89 f3                     	movl	%esi, %r11d
    4932: 45 21 d3                     	andl	%r10d, %r11d
    4935: 45 09 f3                     	orl	%r14d, %r11d
    4938: 45 01 fb                     	addl	%r15d, %r11d
    493b: 41 01 cb                     	addl	%ecx, %r11d
    493e: 89 d9                        	movl	%ebx, %ecx
    4940: c1 c1 1a                     	roll	$0x1a, %ecx
    4943: 41 89 de                     	movl	%ebx, %r14d
    4946: 41 c1 c6 15                  	roll	$0x15, %r14d
    494a: 41 31 ce                     	xorl	%ecx, %r14d
    494d: 89 d9                        	movl	%ebx, %ecx
    494f: c1 c1 07                     	roll	$0x7, %ecx
    4952: 44 31 f1                     	xorl	%r14d, %ecx
    4955: 41 89 d6                     	movl	%edx, %r14d
    4958: 45 31 ce                     	xorl	%r9d, %r14d
    495b: 41 21 de                     	andl	%ebx, %r14d
    495e: 45 31 ce                     	xorl	%r9d, %r14d
    4961: 44 03 85 00 ff ff ff         	addl	-0x100(%rbp), %r8d
    4968: 45 01 f0                     	addl	%r14d, %r8d
    496b: 42 8d 8c 01 74 5d be 72      	leal	0x72be5d74(%rcx,%r8), %ecx
    4973: 41 01 ca                     	addl	%ecx, %r10d
    4976: 45 89 d8                     	movl	%r11d, %r8d
    4979: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    497d: 45 89 de                     	movl	%r11d, %r14d
    4980: 41 c1 c6 13                  	roll	$0x13, %r14d
    4984: 45 31 c6                     	xorl	%r8d, %r14d
    4987: 45 89 df                     	movl	%r11d, %r15d
    498a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    498e: 45 31 f7                     	xorl	%r14d, %r15d
    4991: 41 89 c6                     	movl	%eax, %r14d
    4994: 41 09 f6                     	orl	%esi, %r14d
    4997: 45 21 de                     	andl	%r11d, %r14d
    499a: 41 89 c0                     	movl	%eax, %r8d
    499d: 41 21 f0                     	andl	%esi, %r8d
    49a0: 45 09 f0                     	orl	%r14d, %r8d
    49a3: 45 01 f8                     	addl	%r15d, %r8d
    49a6: 41 01 c8                     	addl	%ecx, %r8d
    49a9: 44 89 d1                     	movl	%r10d, %ecx
    49ac: c1 c1 1a                     	roll	$0x1a, %ecx
    49af: 45 89 d6                     	movl	%r10d, %r14d
    49b2: 41 c1 c6 15                  	roll	$0x15, %r14d
    49b6: 41 31 ce                     	xorl	%ecx, %r14d
    49b9: 44 89 d1                     	movl	%r10d, %ecx
    49bc: c1 c1 07                     	roll	$0x7, %ecx
    49bf: 44 31 f1                     	xorl	%r14d, %ecx
    49c2: 41 89 de                     	movl	%ebx, %r14d
    49c5: 41 31 d6                     	xorl	%edx, %r14d
    49c8: 45 21 d6                     	andl	%r10d, %r14d
    49cb: 44 03 8d 04 ff ff ff         	addl	-0xfc(%rbp), %r9d
    49d2: 41 31 d6                     	xorl	%edx, %r14d
    49d5: 45 01 f1                     	addl	%r14d, %r9d
    49d8: 42 8d 8c 09 fe b1 de 80      	leal	-0x7f214e02(%rcx,%r9), %ecx
    49e0: 01 ce                        	addl	%ecx, %esi
    49e2: 45 89 c1                     	movl	%r8d, %r9d
    49e5: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    49e9: 45 89 c6                     	movl	%r8d, %r14d
    49ec: 41 c1 c6 13                  	roll	$0x13, %r14d
    49f0: 45 31 ce                     	xorl	%r9d, %r14d
    49f3: 45 89 c7                     	movl	%r8d, %r15d
    49f6: 41 c1 c7 0a                  	roll	$0xa, %r15d
    49fa: 45 31 f7                     	xorl	%r14d, %r15d
    49fd: 45 89 de                     	movl	%r11d, %r14d
    4a00: 41 09 c6                     	orl	%eax, %r14d
    4a03: 45 21 c6                     	andl	%r8d, %r14d
    4a06: 45 89 d9                     	movl	%r11d, %r9d
    4a09: 41 21 c1                     	andl	%eax, %r9d
    4a0c: 45 09 f1                     	orl	%r14d, %r9d
    4a0f: 41 89 f6                     	movl	%esi, %r14d
    4a12: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4a16: 45 01 f9                     	addl	%r15d, %r9d
    4a19: 41 89 f7                     	movl	%esi, %r15d
    4a1c: 41 c1 c7 15                  	roll	$0x15, %r15d
    4a20: 41 01 c9                     	addl	%ecx, %r9d
    4a23: 89 f1                        	movl	%esi, %ecx
    4a25: c1 c1 07                     	roll	$0x7, %ecx
    4a28: 45 31 f7                     	xorl	%r14d, %r15d
    4a2b: 44 31 f9                     	xorl	%r15d, %ecx
    4a2e: 45 89 d6                     	movl	%r10d, %r14d
    4a31: 41 31 de                     	xorl	%ebx, %r14d
    4a34: 41 21 f6                     	andl	%esi, %r14d
    4a37: 41 31 de                     	xorl	%ebx, %r14d
    4a3a: 03 95 08 ff ff ff            	addl	-0xf8(%rbp), %edx
    4a40: 44 01 f2                     	addl	%r14d, %edx
    4a43: 45 89 ce                     	movl	%r9d, %r14d
    4a46: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4a4a: 8d 94 11 a7 06 dc 9b         	leal	-0x6423f959(%rcx,%rdx), %edx
    4a51: 44 89 c9                     	movl	%r9d, %ecx
    4a54: c1 c1 13                     	roll	$0x13, %ecx
    4a57: 01 d0                        	addl	%edx, %eax
    4a59: 45 89 cf                     	movl	%r9d, %r15d
    4a5c: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4a60: 44 31 f1                     	xorl	%r14d, %ecx
    4a63: 41 31 cf                     	xorl	%ecx, %r15d
    4a66: 45 89 c6                     	movl	%r8d, %r14d
    4a69: 45 09 de                     	orl	%r11d, %r14d
    4a6c: 45 21 ce                     	andl	%r9d, %r14d
    4a6f: 44 89 c1                     	movl	%r8d, %ecx
    4a72: 44 21 d9                     	andl	%r11d, %ecx
    4a75: 44 09 f1                     	orl	%r14d, %ecx
    4a78: 44 01 f9                     	addl	%r15d, %ecx
    4a7b: 41 89 c6                     	movl	%eax, %r14d
    4a7e: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4a82: 01 d1                        	addl	%edx, %ecx
    4a84: 89 c2                        	movl	%eax, %edx
    4a86: c1 c2 15                     	roll	$0x15, %edx
    4a89: 44 31 f2                     	xorl	%r14d, %edx
    4a8c: 41 89 c6                     	movl	%eax, %r14d
    4a8f: 41 c1 c6 07                  	roll	$0x7, %r14d
    4a93: 41 31 d6                     	xorl	%edx, %r14d
    4a96: 89 f2                        	movl	%esi, %edx
    4a98: 44 31 d2                     	xorl	%r10d, %edx
    4a9b: 21 c2                        	andl	%eax, %edx
    4a9d: 44 31 d2                     	xorl	%r10d, %edx
    4aa0: 03 9d 0c ff ff ff            	addl	-0xf4(%rbp), %ebx
    4aa6: 01 d3                        	addl	%edx, %ebx
    4aa8: 41 8d 94 1e 74 f1 9b c1      	leal	-0x3e640e8c(%r14,%rbx), %edx
    4ab0: 89 cb                        	movl	%ecx, %ebx
    4ab2: c1 c3 1e                     	roll	$0x1e, %ebx
    4ab5: 41 01 d3                     	addl	%edx, %r11d
    4ab8: 41 89 ce                     	movl	%ecx, %r14d
    4abb: 41 c1 c6 13                  	roll	$0x13, %r14d
    4abf: 41 31 de                     	xorl	%ebx, %r14d
    4ac2: 41 89 cf                     	movl	%ecx, %r15d
    4ac5: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4ac9: 45 31 f7                     	xorl	%r14d, %r15d
    4acc: 45 89 ce                     	movl	%r9d, %r14d
    4acf: 45 09 c6                     	orl	%r8d, %r14d
    4ad2: 41 21 ce                     	andl	%ecx, %r14d
    4ad5: 44 89 cb                     	movl	%r9d, %ebx
    4ad8: 44 21 c3                     	andl	%r8d, %ebx
    4adb: 44 09 f3                     	orl	%r14d, %ebx
    4ade: 44 01 fb                     	addl	%r15d, %ebx
    4ae1: 01 d3                        	addl	%edx, %ebx
    4ae3: 44 89 da                     	movl	%r11d, %edx
    4ae6: c1 c2 1a                     	roll	$0x1a, %edx
    4ae9: 45 89 de                     	movl	%r11d, %r14d
    4aec: 41 c1 c6 15                  	roll	$0x15, %r14d
    4af0: 41 31 d6                     	xorl	%edx, %r14d
    4af3: 44 89 da                     	movl	%r11d, %edx
    4af6: c1 c2 07                     	roll	$0x7, %edx
    4af9: 44 31 f2                     	xorl	%r14d, %edx
    4afc: 41 89 c6                     	movl	%eax, %r14d
    4aff: 41 31 f6                     	xorl	%esi, %r14d
    4b02: 45 21 de                     	andl	%r11d, %r14d
    4b05: 41 31 f6                     	xorl	%esi, %r14d
    4b08: 44 03 95 10 ff ff ff         	addl	-0xf0(%rbp), %r10d
    4b0f: 45 01 f2                     	addl	%r14d, %r10d
    4b12: 46 8d 94 12 c1 69 9b e4      	leal	-0x1b64963f(%rdx,%r10), %r10d
    4b1a: 45 01 d0                     	addl	%r10d, %r8d
    4b1d: 89 da                        	movl	%ebx, %edx
    4b1f: c1 c2 1e                     	roll	$0x1e, %edx
    4b22: 41 89 de                     	movl	%ebx, %r14d
    4b25: 41 c1 c6 13                  	roll	$0x13, %r14d
    4b29: 41 31 d6                     	xorl	%edx, %r14d
    4b2c: 41 89 df                     	movl	%ebx, %r15d
    4b2f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4b33: 45 31 f7                     	xorl	%r14d, %r15d
    4b36: 41 89 ce                     	movl	%ecx, %r14d
    4b39: 45 09 ce                     	orl	%r9d, %r14d
    4b3c: 41 21 de                     	andl	%ebx, %r14d
    4b3f: 89 ca                        	movl	%ecx, %edx
    4b41: 44 21 ca                     	andl	%r9d, %edx
    4b44: 44 09 f2                     	orl	%r14d, %edx
    4b47: 44 01 fa                     	addl	%r15d, %edx
    4b4a: 44 01 d2                     	addl	%r10d, %edx
    4b4d: 45 89 c2                     	movl	%r8d, %r10d
    4b50: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    4b54: 45 89 c6                     	movl	%r8d, %r14d
    4b57: 41 c1 c6 15                  	roll	$0x15, %r14d
    4b5b: 45 31 d6                     	xorl	%r10d, %r14d
    4b5e: 45 89 c2                     	movl	%r8d, %r10d
    4b61: 41 c1 c2 07                  	roll	$0x7, %r10d
    4b65: 45 31 f2                     	xorl	%r14d, %r10d
    4b68: 45 89 de                     	movl	%r11d, %r14d
    4b6b: 41 31 c6                     	xorl	%eax, %r14d
    4b6e: 45 21 c6                     	andl	%r8d, %r14d
    4b71: 03 b5 14 ff ff ff            	addl	-0xec(%rbp), %esi
    4b77: 41 31 c6                     	xorl	%eax, %r14d
    4b7a: 44 01 f6                     	addl	%r14d, %esi
    4b7d: 45 8d 94 32 86 47 be ef      	leal	-0x1041b87a(%r10,%rsi), %r10d
    4b85: 45 01 d1                     	addl	%r10d, %r9d
    4b88: 89 d6                        	movl	%edx, %esi
    4b8a: c1 c6 1e                     	roll	$0x1e, %esi
    4b8d: 41 89 d6                     	movl	%edx, %r14d
    4b90: 41 c1 c6 13                  	roll	$0x13, %r14d
    4b94: 41 31 f6                     	xorl	%esi, %r14d
    4b97: 41 89 d7                     	movl	%edx, %r15d
    4b9a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4b9e: 45 31 f7                     	xorl	%r14d, %r15d
    4ba1: 41 89 de                     	movl	%ebx, %r14d
    4ba4: 41 09 ce                     	orl	%ecx, %r14d
    4ba7: 41 21 d6                     	andl	%edx, %r14d
    4baa: 89 de                        	movl	%ebx, %esi
    4bac: 21 ce                        	andl	%ecx, %esi
    4bae: 44 09 f6                     	orl	%r14d, %esi
    4bb1: 45 89 ce                     	movl	%r9d, %r14d
    4bb4: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4bb8: 44 01 fe                     	addl	%r15d, %esi
    4bbb: 45 89 cf                     	movl	%r9d, %r15d
    4bbe: 41 c1 c7 15                  	roll	$0x15, %r15d
    4bc2: 44 01 d6                     	addl	%r10d, %esi
    4bc5: 45 89 ca                     	movl	%r9d, %r10d
    4bc8: 41 c1 c2 07                  	roll	$0x7, %r10d
    4bcc: 45 31 f7                     	xorl	%r14d, %r15d
    4bcf: 45 31 fa                     	xorl	%r15d, %r10d
    4bd2: 45 89 c6                     	movl	%r8d, %r14d
    4bd5: 45 31 de                     	xorl	%r11d, %r14d
    4bd8: 45 21 ce                     	andl	%r9d, %r14d
    4bdb: 45 31 de                     	xorl	%r11d, %r14d
    4bde: 03 85 18 ff ff ff            	addl	-0xe8(%rbp), %eax
    4be4: 44 01 f0                     	addl	%r14d, %eax
    4be7: 41 89 f6                     	movl	%esi, %r14d
    4bea: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4bee: 45 8d 94 02 c6 9d c1 0f      	leal	0xfc19dc6(%r10,%rax), %r10d
    4bf6: 89 f0                        	movl	%esi, %eax
    4bf8: c1 c0 13                     	roll	$0x13, %eax
    4bfb: 44 01 d1                     	addl	%r10d, %ecx
    4bfe: 41 89 f7                     	movl	%esi, %r15d
    4c01: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4c05: 44 31 f0                     	xorl	%r14d, %eax
    4c08: 41 31 c7                     	xorl	%eax, %r15d
    4c0b: 41 89 d6                     	movl	%edx, %r14d
    4c0e: 41 09 de                     	orl	%ebx, %r14d
    4c11: 41 21 f6                     	andl	%esi, %r14d
    4c14: 89 d0                        	movl	%edx, %eax
    4c16: 21 d8                        	andl	%ebx, %eax
    4c18: 44 09 f0                     	orl	%r14d, %eax
    4c1b: 44 01 f8                     	addl	%r15d, %eax
    4c1e: 41 89 ce                     	movl	%ecx, %r14d
    4c21: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4c25: 44 01 d0                     	addl	%r10d, %eax
    4c28: 41 89 ca                     	movl	%ecx, %r10d
    4c2b: 41 c1 c2 15                  	roll	$0x15, %r10d
    4c2f: 45 31 f2                     	xorl	%r14d, %r10d
    4c32: 41 89 ce                     	movl	%ecx, %r14d
    4c35: 41 c1 c6 07                  	roll	$0x7, %r14d
    4c39: 45 31 d6                     	xorl	%r10d, %r14d
    4c3c: 45 89 ca                     	movl	%r9d, %r10d
    4c3f: 45 31 c2                     	xorl	%r8d, %r10d
    4c42: 41 21 ca                     	andl	%ecx, %r10d
    4c45: 45 31 c2                     	xorl	%r8d, %r10d
    4c48: 44 03 9d 1c ff ff ff         	addl	-0xe4(%rbp), %r11d
    4c4f: 45 01 d3                     	addl	%r10d, %r11d
    4c52: 47 8d 9c 1e cc a1 0c 24      	leal	0x240ca1cc(%r14,%r11), %r11d
    4c5a: 41 89 c2                     	movl	%eax, %r10d
    4c5d: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4c61: 44 01 db                     	addl	%r11d, %ebx
    4c64: 41 89 c6                     	movl	%eax, %r14d
    4c67: 41 c1 c6 13                  	roll	$0x13, %r14d
    4c6b: 45 31 d6                     	xorl	%r10d, %r14d
    4c6e: 41 89 c7                     	movl	%eax, %r15d
    4c71: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4c75: 45 31 f7                     	xorl	%r14d, %r15d
    4c78: 41 89 f6                     	movl	%esi, %r14d
    4c7b: 41 09 d6                     	orl	%edx, %r14d
    4c7e: 41 21 c6                     	andl	%eax, %r14d
    4c81: 41 89 f2                     	movl	%esi, %r10d
    4c84: 41 21 d2                     	andl	%edx, %r10d
    4c87: 45 09 f2                     	orl	%r14d, %r10d
    4c8a: 45 01 fa                     	addl	%r15d, %r10d
    4c8d: 45 01 da                     	addl	%r11d, %r10d
    4c90: 41 89 db                     	movl	%ebx, %r11d
    4c93: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    4c97: 41 89 de                     	movl	%ebx, %r14d
    4c9a: 41 c1 c6 15                  	roll	$0x15, %r14d
    4c9e: 45 31 de                     	xorl	%r11d, %r14d
    4ca1: 41 89 db                     	movl	%ebx, %r11d
    4ca4: 41 c1 c3 07                  	roll	$0x7, %r11d
    4ca8: 45 31 f3                     	xorl	%r14d, %r11d
    4cab: 41 89 ce                     	movl	%ecx, %r14d
    4cae: 45 31 ce                     	xorl	%r9d, %r14d
    4cb1: 41 21 de                     	andl	%ebx, %r14d
    4cb4: 45 31 ce                     	xorl	%r9d, %r14d
    4cb7: 44 03 85 20 ff ff ff         	addl	-0xe0(%rbp), %r8d
    4cbe: 45 01 f0                     	addl	%r14d, %r8d
    4cc1: 47 8d 9c 03 6f 2c e9 2d      	leal	0x2de92c6f(%r11,%r8), %r11d
    4cc9: 44 01 da                     	addl	%r11d, %edx
    4ccc: 45 89 d0                     	movl	%r10d, %r8d
    4ccf: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    4cd3: 45 89 d6                     	movl	%r10d, %r14d
    4cd6: 41 c1 c6 13                  	roll	$0x13, %r14d
    4cda: 45 31 c6                     	xorl	%r8d, %r14d
    4cdd: 45 89 d7                     	movl	%r10d, %r15d
    4ce0: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4ce4: 45 31 f7                     	xorl	%r14d, %r15d
    4ce7: 41 89 c6                     	movl	%eax, %r14d
    4cea: 41 09 f6                     	orl	%esi, %r14d
    4ced: 45 21 d6                     	andl	%r10d, %r14d
    4cf0: 41 89 c0                     	movl	%eax, %r8d
    4cf3: 41 21 f0                     	andl	%esi, %r8d
    4cf6: 45 09 f0                     	orl	%r14d, %r8d
    4cf9: 45 01 f8                     	addl	%r15d, %r8d
    4cfc: 45 01 d8                     	addl	%r11d, %r8d
    4cff: 41 89 d3                     	movl	%edx, %r11d
    4d02: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    4d06: 41 89 d6                     	movl	%edx, %r14d
    4d09: 41 c1 c6 15                  	roll	$0x15, %r14d
    4d0d: 45 31 de                     	xorl	%r11d, %r14d
    4d10: 41 89 d3                     	movl	%edx, %r11d
    4d13: 41 c1 c3 07                  	roll	$0x7, %r11d
    4d17: 45 31 f3                     	xorl	%r14d, %r11d
    4d1a: 41 89 de                     	movl	%ebx, %r14d
    4d1d: 41 31 ce                     	xorl	%ecx, %r14d
    4d20: 41 21 d6                     	andl	%edx, %r14d
    4d23: 44 03 8d 24 ff ff ff         	addl	-0xdc(%rbp), %r9d
    4d2a: 41 31 ce                     	xorl	%ecx, %r14d
    4d2d: 45 01 f1                     	addl	%r14d, %r9d
    4d30: 47 8d 9c 0b aa 84 74 4a      	leal	0x4a7484aa(%r11,%r9), %r11d
    4d38: 44 01 de                     	addl	%r11d, %esi
    4d3b: 45 89 c1                     	movl	%r8d, %r9d
    4d3e: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    4d42: 45 89 c6                     	movl	%r8d, %r14d
    4d45: 41 c1 c6 13                  	roll	$0x13, %r14d
    4d49: 45 31 ce                     	xorl	%r9d, %r14d
    4d4c: 45 89 c7                     	movl	%r8d, %r15d
    4d4f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4d53: 45 31 f7                     	xorl	%r14d, %r15d
    4d56: 45 89 d6                     	movl	%r10d, %r14d
    4d59: 41 09 c6                     	orl	%eax, %r14d
    4d5c: 45 21 c6                     	andl	%r8d, %r14d
    4d5f: 45 89 d1                     	movl	%r10d, %r9d
    4d62: 41 21 c1                     	andl	%eax, %r9d
    4d65: 45 09 f1                     	orl	%r14d, %r9d
    4d68: 41 89 f6                     	movl	%esi, %r14d
    4d6b: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4d6f: 45 01 f9                     	addl	%r15d, %r9d
    4d72: 41 89 f7                     	movl	%esi, %r15d
    4d75: 41 c1 c7 15                  	roll	$0x15, %r15d
    4d79: 45 01 d9                     	addl	%r11d, %r9d
    4d7c: 41 89 f3                     	movl	%esi, %r11d
    4d7f: 41 c1 c3 07                  	roll	$0x7, %r11d
    4d83: 45 31 f7                     	xorl	%r14d, %r15d
    4d86: 45 31 fb                     	xorl	%r15d, %r11d
    4d89: 41 89 d6                     	movl	%edx, %r14d
    4d8c: 41 31 de                     	xorl	%ebx, %r14d
    4d8f: 41 21 f6                     	andl	%esi, %r14d
    4d92: 41 31 de                     	xorl	%ebx, %r14d
    4d95: 03 8d 28 ff ff ff            	addl	-0xd8(%rbp), %ecx
    4d9b: 44 01 f1                     	addl	%r14d, %ecx
    4d9e: 45 89 ce                     	movl	%r9d, %r14d
    4da1: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4da5: 45 8d 9c 0b dc a9 b0 5c      	leal	0x5cb0a9dc(%r11,%rcx), %r11d
    4dad: 44 89 c9                     	movl	%r9d, %ecx
    4db0: c1 c1 13                     	roll	$0x13, %ecx
    4db3: 44 01 d8                     	addl	%r11d, %eax
    4db6: 45 89 cf                     	movl	%r9d, %r15d
    4db9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4dbd: 44 31 f1                     	xorl	%r14d, %ecx
    4dc0: 41 31 cf                     	xorl	%ecx, %r15d
    4dc3: 45 89 c6                     	movl	%r8d, %r14d
    4dc6: 45 09 d6                     	orl	%r10d, %r14d
    4dc9: 45 21 ce                     	andl	%r9d, %r14d
    4dcc: 44 89 c1                     	movl	%r8d, %ecx
    4dcf: 44 21 d1                     	andl	%r10d, %ecx
    4dd2: 44 09 f1                     	orl	%r14d, %ecx
    4dd5: 44 01 f9                     	addl	%r15d, %ecx
    4dd8: 41 89 c6                     	movl	%eax, %r14d
    4ddb: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4ddf: 44 01 d9                     	addl	%r11d, %ecx
    4de2: 41 89 c3                     	movl	%eax, %r11d
    4de5: 41 c1 c3 15                  	roll	$0x15, %r11d
    4de9: 45 31 f3                     	xorl	%r14d, %r11d
    4dec: 41 89 c6                     	movl	%eax, %r14d
    4def: 41 c1 c6 07                  	roll	$0x7, %r14d
    4df3: 45 31 de                     	xorl	%r11d, %r14d
    4df6: 41 89 f3                     	movl	%esi, %r11d
    4df9: 41 31 d3                     	xorl	%edx, %r11d
    4dfc: 41 21 c3                     	andl	%eax, %r11d
    4dff: 41 31 d3                     	xorl	%edx, %r11d
    4e02: 03 9d 2c ff ff ff            	addl	-0xd4(%rbp), %ebx
    4e08: 44 01 db                     	addl	%r11d, %ebx
    4e0b: 41 8d 9c 1e da 88 f9 76      	leal	0x76f988da(%r14,%rbx), %ebx
    4e13: 41 89 cb                     	movl	%ecx, %r11d
    4e16: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    4e1a: 41 01 da                     	addl	%ebx, %r10d
    4e1d: 41 89 ce                     	movl	%ecx, %r14d
    4e20: 41 c1 c6 13                  	roll	$0x13, %r14d
    4e24: 45 31 de                     	xorl	%r11d, %r14d
    4e27: 41 89 cf                     	movl	%ecx, %r15d
    4e2a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4e2e: 45 31 f7                     	xorl	%r14d, %r15d
    4e31: 45 89 ce                     	movl	%r9d, %r14d
    4e34: 45 09 c6                     	orl	%r8d, %r14d
    4e37: 41 21 ce                     	andl	%ecx, %r14d
    4e3a: 45 89 cb                     	movl	%r9d, %r11d
    4e3d: 45 21 c3                     	andl	%r8d, %r11d
    4e40: 45 09 f3                     	orl	%r14d, %r11d
    4e43: 45 01 fb                     	addl	%r15d, %r11d
    4e46: 41 01 db                     	addl	%ebx, %r11d
    4e49: 44 89 d3                     	movl	%r10d, %ebx
    4e4c: c1 c3 1a                     	roll	$0x1a, %ebx
    4e4f: 45 89 d6                     	movl	%r10d, %r14d
    4e52: 41 c1 c6 15                  	roll	$0x15, %r14d
    4e56: 41 31 de                     	xorl	%ebx, %r14d
    4e59: 44 89 d3                     	movl	%r10d, %ebx
    4e5c: c1 c3 07                     	roll	$0x7, %ebx
    4e5f: 44 31 f3                     	xorl	%r14d, %ebx
    4e62: 41 89 c6                     	movl	%eax, %r14d
    4e65: 41 31 f6                     	xorl	%esi, %r14d
    4e68: 45 21 d6                     	andl	%r10d, %r14d
    4e6b: 41 31 f6                     	xorl	%esi, %r14d
    4e6e: 03 95 30 ff ff ff            	addl	-0xd0(%rbp), %edx
    4e74: 44 01 f2                     	addl	%r14d, %edx
    4e77: 8d 9c 13 52 51 3e 98         	leal	-0x67c1aeae(%rbx,%rdx), %ebx
    4e7e: 41 01 d8                     	addl	%ebx, %r8d
    4e81: 44 89 da                     	movl	%r11d, %edx
    4e84: c1 c2 1e                     	roll	$0x1e, %edx
    4e87: 45 89 de                     	movl	%r11d, %r14d
    4e8a: 41 c1 c6 13                  	roll	$0x13, %r14d
    4e8e: 41 31 d6                     	xorl	%edx, %r14d
    4e91: 45 89 df                     	movl	%r11d, %r15d
    4e94: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4e98: 45 31 f7                     	xorl	%r14d, %r15d
    4e9b: 41 89 ce                     	movl	%ecx, %r14d
    4e9e: 45 09 ce                     	orl	%r9d, %r14d
    4ea1: 45 21 de                     	andl	%r11d, %r14d
    4ea4: 89 ca                        	movl	%ecx, %edx
    4ea6: 44 21 ca                     	andl	%r9d, %edx
    4ea9: 44 09 f2                     	orl	%r14d, %edx
    4eac: 44 01 fa                     	addl	%r15d, %edx
    4eaf: 01 da                        	addl	%ebx, %edx
    4eb1: 44 89 c3                     	movl	%r8d, %ebx
    4eb4: c1 c3 1a                     	roll	$0x1a, %ebx
    4eb7: 45 89 c6                     	movl	%r8d, %r14d
    4eba: 41 c1 c6 15                  	roll	$0x15, %r14d
    4ebe: 41 31 de                     	xorl	%ebx, %r14d
    4ec1: 44 89 c3                     	movl	%r8d, %ebx
    4ec4: c1 c3 07                     	roll	$0x7, %ebx
    4ec7: 44 31 f3                     	xorl	%r14d, %ebx
    4eca: 45 89 d6                     	movl	%r10d, %r14d
    4ecd: 41 31 c6                     	xorl	%eax, %r14d
    4ed0: 45 21 c6                     	andl	%r8d, %r14d
    4ed3: 03 b5 34 ff ff ff            	addl	-0xcc(%rbp), %esi
    4ed9: 41 31 c6                     	xorl	%eax, %r14d
    4edc: 44 01 f6                     	addl	%r14d, %esi
    4edf: 8d 9c 33 6d c6 31 a8         	leal	-0x57ce3993(%rbx,%rsi), %ebx
    4ee6: 41 01 d9                     	addl	%ebx, %r9d
    4ee9: 89 d6                        	movl	%edx, %esi
    4eeb: c1 c6 1e                     	roll	$0x1e, %esi
    4eee: 41 89 d6                     	movl	%edx, %r14d
    4ef1: 41 c1 c6 13                  	roll	$0x13, %r14d
    4ef5: 41 31 f6                     	xorl	%esi, %r14d
    4ef8: 41 89 d7                     	movl	%edx, %r15d
    4efb: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4eff: 45 31 f7                     	xorl	%r14d, %r15d
    4f02: 45 89 de                     	movl	%r11d, %r14d
    4f05: 41 09 ce                     	orl	%ecx, %r14d
    4f08: 41 21 d6                     	andl	%edx, %r14d
    4f0b: 44 89 de                     	movl	%r11d, %esi
    4f0e: 21 ce                        	andl	%ecx, %esi
    4f10: 44 09 f6                     	orl	%r14d, %esi
    4f13: 45 89 ce                     	movl	%r9d, %r14d
    4f16: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4f1a: 44 01 fe                     	addl	%r15d, %esi
    4f1d: 45 89 cf                     	movl	%r9d, %r15d
    4f20: 41 c1 c7 15                  	roll	$0x15, %r15d
    4f24: 01 de                        	addl	%ebx, %esi
    4f26: 44 89 cb                     	movl	%r9d, %ebx
    4f29: c1 c3 07                     	roll	$0x7, %ebx
    4f2c: 45 31 f7                     	xorl	%r14d, %r15d
    4f2f: 44 31 fb                     	xorl	%r15d, %ebx
    4f32: 45 89 c6                     	movl	%r8d, %r14d
    4f35: 45 31 d6                     	xorl	%r10d, %r14d
    4f38: 45 21 ce                     	andl	%r9d, %r14d
    4f3b: 45 31 d6                     	xorl	%r10d, %r14d
    4f3e: 03 85 38 ff ff ff            	addl	-0xc8(%rbp), %eax
    4f44: 44 01 f0                     	addl	%r14d, %eax
    4f47: 41 89 f6                     	movl	%esi, %r14d
    4f4a: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    4f4e: 8d 9c 03 c8 27 03 b0         	leal	-0x4ffcd838(%rbx,%rax), %ebx
    4f55: 89 f0                        	movl	%esi, %eax
    4f57: c1 c0 13                     	roll	$0x13, %eax
    4f5a: 01 d9                        	addl	%ebx, %ecx
    4f5c: 41 89 f7                     	movl	%esi, %r15d
    4f5f: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4f63: 44 31 f0                     	xorl	%r14d, %eax
    4f66: 41 31 c7                     	xorl	%eax, %r15d
    4f69: 41 89 d6                     	movl	%edx, %r14d
    4f6c: 45 09 de                     	orl	%r11d, %r14d
    4f6f: 41 21 f6                     	andl	%esi, %r14d
    4f72: 89 d0                        	movl	%edx, %eax
    4f74: 44 21 d8                     	andl	%r11d, %eax
    4f77: 44 09 f0                     	orl	%r14d, %eax
    4f7a: 44 01 f8                     	addl	%r15d, %eax
    4f7d: 41 89 ce                     	movl	%ecx, %r14d
    4f80: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    4f84: 01 d8                        	addl	%ebx, %eax
    4f86: 89 cb                        	movl	%ecx, %ebx
    4f88: c1 c3 15                     	roll	$0x15, %ebx
    4f8b: 44 31 f3                     	xorl	%r14d, %ebx
    4f8e: 41 89 ce                     	movl	%ecx, %r14d
    4f91: 41 c1 c6 07                  	roll	$0x7, %r14d
    4f95: 41 31 de                     	xorl	%ebx, %r14d
    4f98: 44 89 cb                     	movl	%r9d, %ebx
    4f9b: 44 31 c3                     	xorl	%r8d, %ebx
    4f9e: 21 cb                        	andl	%ecx, %ebx
    4fa0: 44 31 c3                     	xorl	%r8d, %ebx
    4fa3: 44 03 95 3c ff ff ff         	addl	-0xc4(%rbp), %r10d
    4faa: 41 01 da                     	addl	%ebx, %r10d
    4fad: 43 8d 9c 16 c7 7f 59 bf      	leal	-0x40a68039(%r14,%r10), %ebx
    4fb5: 41 89 c2                     	movl	%eax, %r10d
    4fb8: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    4fbc: 41 01 db                     	addl	%ebx, %r11d
    4fbf: 41 89 c6                     	movl	%eax, %r14d
    4fc2: 41 c1 c6 13                  	roll	$0x13, %r14d
    4fc6: 45 31 d6                     	xorl	%r10d, %r14d
    4fc9: 41 89 c7                     	movl	%eax, %r15d
    4fcc: 41 c1 c7 0a                  	roll	$0xa, %r15d
    4fd0: 45 31 f7                     	xorl	%r14d, %r15d
    4fd3: 41 89 f6                     	movl	%esi, %r14d
    4fd6: 41 09 d6                     	orl	%edx, %r14d
    4fd9: 41 21 c6                     	andl	%eax, %r14d
    4fdc: 41 89 f2                     	movl	%esi, %r10d
    4fdf: 41 21 d2                     	andl	%edx, %r10d
    4fe2: 45 09 f2                     	orl	%r14d, %r10d
    4fe5: 45 01 fa                     	addl	%r15d, %r10d
    4fe8: 41 01 da                     	addl	%ebx, %r10d
    4feb: 44 89 db                     	movl	%r11d, %ebx
    4fee: c1 c3 1a                     	roll	$0x1a, %ebx
    4ff1: 45 89 de                     	movl	%r11d, %r14d
    4ff4: 41 c1 c6 15                  	roll	$0x15, %r14d
    4ff8: 41 31 de                     	xorl	%ebx, %r14d
    4ffb: 44 89 db                     	movl	%r11d, %ebx
    4ffe: c1 c3 07                     	roll	$0x7, %ebx
    5001: 44 31 f3                     	xorl	%r14d, %ebx
    5004: 41 89 ce                     	movl	%ecx, %r14d
    5007: 45 31 ce                     	xorl	%r9d, %r14d
    500a: 45 21 de                     	andl	%r11d, %r14d
    500d: 45 31 ce                     	xorl	%r9d, %r14d
    5010: 44 03 85 40 ff ff ff         	addl	-0xc0(%rbp), %r8d
    5017: 45 01 f0                     	addl	%r14d, %r8d
    501a: 42 8d 9c 03 f3 0b e0 c6      	leal	-0x391ff40d(%rbx,%r8), %ebx
    5022: 01 da                        	addl	%ebx, %edx
    5024: 45 89 d0                     	movl	%r10d, %r8d
    5027: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    502b: 45 89 d6                     	movl	%r10d, %r14d
    502e: 41 c1 c6 13                  	roll	$0x13, %r14d
    5032: 45 31 c6                     	xorl	%r8d, %r14d
    5035: 45 89 d7                     	movl	%r10d, %r15d
    5038: 41 c1 c7 0a                  	roll	$0xa, %r15d
    503c: 45 31 f7                     	xorl	%r14d, %r15d
    503f: 41 89 c6                     	movl	%eax, %r14d
    5042: 41 09 f6                     	orl	%esi, %r14d
    5045: 45 21 d6                     	andl	%r10d, %r14d
    5048: 41 89 c0                     	movl	%eax, %r8d
    504b: 41 21 f0                     	andl	%esi, %r8d
    504e: 45 09 f0                     	orl	%r14d, %r8d
    5051: 45 01 f8                     	addl	%r15d, %r8d
    5054: 41 01 d8                     	addl	%ebx, %r8d
    5057: 89 d3                        	movl	%edx, %ebx
    5059: c1 c3 1a                     	roll	$0x1a, %ebx
    505c: 41 89 d6                     	movl	%edx, %r14d
    505f: 41 c1 c6 15                  	roll	$0x15, %r14d
    5063: 41 31 de                     	xorl	%ebx, %r14d
    5066: 89 d3                        	movl	%edx, %ebx
    5068: c1 c3 07                     	roll	$0x7, %ebx
    506b: 44 31 f3                     	xorl	%r14d, %ebx
    506e: 45 89 de                     	movl	%r11d, %r14d
    5071: 41 31 ce                     	xorl	%ecx, %r14d
    5074: 41 21 d6                     	andl	%edx, %r14d
    5077: 44 03 8d 44 ff ff ff         	addl	-0xbc(%rbp), %r9d
    507e: 41 31 ce                     	xorl	%ecx, %r14d
    5081: 45 01 f1                     	addl	%r14d, %r9d
    5084: 42 8d 9c 0b 47 91 a7 d5      	leal	-0x2a586eb9(%rbx,%r9), %ebx
    508c: 01 de                        	addl	%ebx, %esi
    508e: 45 89 c1                     	movl	%r8d, %r9d
    5091: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5095: 45 89 c6                     	movl	%r8d, %r14d
    5098: 41 c1 c6 13                  	roll	$0x13, %r14d
    509c: 45 31 ce                     	xorl	%r9d, %r14d
    509f: 45 89 c7                     	movl	%r8d, %r15d
    50a2: 41 c1 c7 0a                  	roll	$0xa, %r15d
    50a6: 45 31 f7                     	xorl	%r14d, %r15d
    50a9: 45 89 d6                     	movl	%r10d, %r14d
    50ac: 41 09 c6                     	orl	%eax, %r14d
    50af: 45 21 c6                     	andl	%r8d, %r14d
    50b2: 45 89 d1                     	movl	%r10d, %r9d
    50b5: 41 21 c1                     	andl	%eax, %r9d
    50b8: 45 09 f1                     	orl	%r14d, %r9d
    50bb: 41 89 f6                     	movl	%esi, %r14d
    50be: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    50c2: 45 01 f9                     	addl	%r15d, %r9d
    50c5: 41 89 f7                     	movl	%esi, %r15d
    50c8: 41 c1 c7 15                  	roll	$0x15, %r15d
    50cc: 41 01 d9                     	addl	%ebx, %r9d
    50cf: 89 f3                        	movl	%esi, %ebx
    50d1: c1 c3 07                     	roll	$0x7, %ebx
    50d4: 45 31 f7                     	xorl	%r14d, %r15d
    50d7: 44 31 fb                     	xorl	%r15d, %ebx
    50da: 41 89 d6                     	movl	%edx, %r14d
    50dd: 45 31 de                     	xorl	%r11d, %r14d
    50e0: 41 21 f6                     	andl	%esi, %r14d
    50e3: 45 31 de                     	xorl	%r11d, %r14d
    50e6: 03 8d 48 ff ff ff            	addl	-0xb8(%rbp), %ecx
    50ec: 44 01 f1                     	addl	%r14d, %ecx
    50ef: 45 89 ce                     	movl	%r9d, %r14d
    50f2: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    50f6: 8d 9c 0b 51 63 ca 06         	leal	0x6ca6351(%rbx,%rcx), %ebx
    50fd: 44 89 c9                     	movl	%r9d, %ecx
    5100: c1 c1 13                     	roll	$0x13, %ecx
    5103: 01 d8                        	addl	%ebx, %eax
    5105: 45 89 cf                     	movl	%r9d, %r15d
    5108: 41 c1 c7 0a                  	roll	$0xa, %r15d
    510c: 44 31 f1                     	xorl	%r14d, %ecx
    510f: 41 31 cf                     	xorl	%ecx, %r15d
    5112: 45 89 c6                     	movl	%r8d, %r14d
    5115: 45 09 d6                     	orl	%r10d, %r14d
    5118: 45 21 ce                     	andl	%r9d, %r14d
    511b: 44 89 c1                     	movl	%r8d, %ecx
    511e: 44 21 d1                     	andl	%r10d, %ecx
    5121: 44 09 f1                     	orl	%r14d, %ecx
    5124: 44 01 f9                     	addl	%r15d, %ecx
    5127: 41 89 c6                     	movl	%eax, %r14d
    512a: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    512e: 01 d9                        	addl	%ebx, %ecx
    5130: 89 c3                        	movl	%eax, %ebx
    5132: c1 c3 15                     	roll	$0x15, %ebx
    5135: 44 31 f3                     	xorl	%r14d, %ebx
    5138: 41 89 c6                     	movl	%eax, %r14d
    513b: 41 c1 c6 07                  	roll	$0x7, %r14d
    513f: 41 31 de                     	xorl	%ebx, %r14d
    5142: 89 f3                        	movl	%esi, %ebx
    5144: 31 d3                        	xorl	%edx, %ebx
    5146: 21 c3                        	andl	%eax, %ebx
    5148: 31 d3                        	xorl	%edx, %ebx
    514a: 44 03 9d 4c ff ff ff         	addl	-0xb4(%rbp), %r11d
    5151: 41 01 db                     	addl	%ebx, %r11d
    5154: 43 8d 9c 1e 67 29 29 14      	leal	0x14292967(%r14,%r11), %ebx
    515c: 41 89 cb                     	movl	%ecx, %r11d
    515f: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    5163: 41 01 da                     	addl	%ebx, %r10d
    5166: 41 89 ce                     	movl	%ecx, %r14d
    5169: 41 c1 c6 13                  	roll	$0x13, %r14d
    516d: 45 31 de                     	xorl	%r11d, %r14d
    5170: 41 89 cf                     	movl	%ecx, %r15d
    5173: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5177: 45 31 f7                     	xorl	%r14d, %r15d
    517a: 45 89 ce                     	movl	%r9d, %r14d
    517d: 45 09 c6                     	orl	%r8d, %r14d
    5180: 41 21 ce                     	andl	%ecx, %r14d
    5183: 45 89 cb                     	movl	%r9d, %r11d
    5186: 45 21 c3                     	andl	%r8d, %r11d
    5189: 45 09 f3                     	orl	%r14d, %r11d
    518c: 45 01 fb                     	addl	%r15d, %r11d
    518f: 41 01 db                     	addl	%ebx, %r11d
    5192: 44 89 d3                     	movl	%r10d, %ebx
    5195: c1 c3 1a                     	roll	$0x1a, %ebx
    5198: 45 89 d6                     	movl	%r10d, %r14d
    519b: 41 c1 c6 15                  	roll	$0x15, %r14d
    519f: 41 31 de                     	xorl	%ebx, %r14d
    51a2: 44 89 d3                     	movl	%r10d, %ebx
    51a5: c1 c3 07                     	roll	$0x7, %ebx
    51a8: 44 31 f3                     	xorl	%r14d, %ebx
    51ab: 41 89 c6                     	movl	%eax, %r14d
    51ae: 41 31 f6                     	xorl	%esi, %r14d
    51b1: 45 21 d6                     	andl	%r10d, %r14d
    51b4: 41 31 f6                     	xorl	%esi, %r14d
    51b7: 03 95 50 ff ff ff            	addl	-0xb0(%rbp), %edx
    51bd: 44 01 f2                     	addl	%r14d, %edx
    51c0: 8d 9c 13 85 0a b7 27         	leal	0x27b70a85(%rbx,%rdx), %ebx
    51c7: 41 01 d8                     	addl	%ebx, %r8d
    51ca: 44 89 da                     	movl	%r11d, %edx
    51cd: c1 c2 1e                     	roll	$0x1e, %edx
    51d0: 45 89 de                     	movl	%r11d, %r14d
    51d3: 41 c1 c6 13                  	roll	$0x13, %r14d
    51d7: 41 31 d6                     	xorl	%edx, %r14d
    51da: 45 89 df                     	movl	%r11d, %r15d
    51dd: 41 c1 c7 0a                  	roll	$0xa, %r15d
    51e1: 45 31 f7                     	xorl	%r14d, %r15d
    51e4: 41 89 ce                     	movl	%ecx, %r14d
    51e7: 45 09 ce                     	orl	%r9d, %r14d
    51ea: 45 21 de                     	andl	%r11d, %r14d
    51ed: 89 ca                        	movl	%ecx, %edx
    51ef: 44 21 ca                     	andl	%r9d, %edx
    51f2: 44 09 f2                     	orl	%r14d, %edx
    51f5: 44 01 fa                     	addl	%r15d, %edx
    51f8: 01 da                        	addl	%ebx, %edx
    51fa: 44 89 c3                     	movl	%r8d, %ebx
    51fd: c1 c3 1a                     	roll	$0x1a, %ebx
    5200: 45 89 c6                     	movl	%r8d, %r14d
    5203: 41 c1 c6 15                  	roll	$0x15, %r14d
    5207: 41 31 de                     	xorl	%ebx, %r14d
    520a: 44 89 c3                     	movl	%r8d, %ebx
    520d: c1 c3 07                     	roll	$0x7, %ebx
    5210: 44 31 f3                     	xorl	%r14d, %ebx
    5213: 45 89 d6                     	movl	%r10d, %r14d
    5216: 41 31 c6                     	xorl	%eax, %r14d
    5219: 45 21 c6                     	andl	%r8d, %r14d
    521c: 03 b5 54 ff ff ff            	addl	-0xac(%rbp), %esi
    5222: 41 31 c6                     	xorl	%eax, %r14d
    5225: 44 01 f6                     	addl	%r14d, %esi
    5228: 8d 9c 33 38 21 1b 2e         	leal	0x2e1b2138(%rbx,%rsi), %ebx
    522f: 41 01 d9                     	addl	%ebx, %r9d
    5232: 89 d6                        	movl	%edx, %esi
    5234: c1 c6 1e                     	roll	$0x1e, %esi
    5237: 41 89 d6                     	movl	%edx, %r14d
    523a: 41 c1 c6 13                  	roll	$0x13, %r14d
    523e: 41 31 f6                     	xorl	%esi, %r14d
    5241: 41 89 d7                     	movl	%edx, %r15d
    5244: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5248: 45 31 f7                     	xorl	%r14d, %r15d
    524b: 45 89 de                     	movl	%r11d, %r14d
    524e: 41 09 ce                     	orl	%ecx, %r14d
    5251: 41 21 d6                     	andl	%edx, %r14d
    5254: 44 89 de                     	movl	%r11d, %esi
    5257: 21 ce                        	andl	%ecx, %esi
    5259: 44 09 f6                     	orl	%r14d, %esi
    525c: 45 89 ce                     	movl	%r9d, %r14d
    525f: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5263: 44 01 fe                     	addl	%r15d, %esi
    5266: 45 89 cf                     	movl	%r9d, %r15d
    5269: 41 c1 c7 15                  	roll	$0x15, %r15d
    526d: 01 de                        	addl	%ebx, %esi
    526f: 44 89 cb                     	movl	%r9d, %ebx
    5272: c1 c3 07                     	roll	$0x7, %ebx
    5275: 45 31 f7                     	xorl	%r14d, %r15d
    5278: 44 31 fb                     	xorl	%r15d, %ebx
    527b: 45 89 c6                     	movl	%r8d, %r14d
    527e: 45 31 d6                     	xorl	%r10d, %r14d
    5281: 45 21 ce                     	andl	%r9d, %r14d
    5284: 45 31 d6                     	xorl	%r10d, %r14d
    5287: 03 85 58 ff ff ff            	addl	-0xa8(%rbp), %eax
    528d: 44 01 f0                     	addl	%r14d, %eax
    5290: 41 89 f6                     	movl	%esi, %r14d
    5293: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5297: 8d 9c 03 fc 6d 2c 4d         	leal	0x4d2c6dfc(%rbx,%rax), %ebx
    529e: 89 f0                        	movl	%esi, %eax
    52a0: c1 c0 13                     	roll	$0x13, %eax
    52a3: 01 d9                        	addl	%ebx, %ecx
    52a5: 41 89 f7                     	movl	%esi, %r15d
    52a8: 41 c1 c7 0a                  	roll	$0xa, %r15d
    52ac: 44 31 f0                     	xorl	%r14d, %eax
    52af: 41 31 c7                     	xorl	%eax, %r15d
    52b2: 41 89 d6                     	movl	%edx, %r14d
    52b5: 45 09 de                     	orl	%r11d, %r14d
    52b8: 41 21 f6                     	andl	%esi, %r14d
    52bb: 89 d0                        	movl	%edx, %eax
    52bd: 44 21 d8                     	andl	%r11d, %eax
    52c0: 44 09 f0                     	orl	%r14d, %eax
    52c3: 44 01 f8                     	addl	%r15d, %eax
    52c6: 41 89 ce                     	movl	%ecx, %r14d
    52c9: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    52cd: 01 d8                        	addl	%ebx, %eax
    52cf: 89 cb                        	movl	%ecx, %ebx
    52d1: c1 c3 15                     	roll	$0x15, %ebx
    52d4: 44 31 f3                     	xorl	%r14d, %ebx
    52d7: 41 89 ce                     	movl	%ecx, %r14d
    52da: 41 c1 c6 07                  	roll	$0x7, %r14d
    52de: 41 31 de                     	xorl	%ebx, %r14d
    52e1: 44 89 cb                     	movl	%r9d, %ebx
    52e4: 44 31 c3                     	xorl	%r8d, %ebx
    52e7: 21 cb                        	andl	%ecx, %ebx
    52e9: 44 31 c3                     	xorl	%r8d, %ebx
    52ec: 44 03 95 5c ff ff ff         	addl	-0xa4(%rbp), %r10d
    52f3: 41 01 da                     	addl	%ebx, %r10d
    52f6: 43 8d 9c 16 13 0d 38 53      	leal	0x53380d13(%r14,%r10), %ebx
    52fe: 41 89 c2                     	movl	%eax, %r10d
    5301: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5305: 41 01 db                     	addl	%ebx, %r11d
    5308: 41 89 c6                     	movl	%eax, %r14d
    530b: 41 c1 c6 13                  	roll	$0x13, %r14d
    530f: 45 31 d6                     	xorl	%r10d, %r14d
    5312: 41 89 c7                     	movl	%eax, %r15d
    5315: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5319: 45 31 f7                     	xorl	%r14d, %r15d
    531c: 41 89 f6                     	movl	%esi, %r14d
    531f: 41 09 d6                     	orl	%edx, %r14d
    5322: 41 21 c6                     	andl	%eax, %r14d
    5325: 41 89 f2                     	movl	%esi, %r10d
    5328: 41 21 d2                     	andl	%edx, %r10d
    532b: 45 09 f2                     	orl	%r14d, %r10d
    532e: 45 01 fa                     	addl	%r15d, %r10d
    5331: 41 01 da                     	addl	%ebx, %r10d
    5334: 44 89 db                     	movl	%r11d, %ebx
    5337: c1 c3 1a                     	roll	$0x1a, %ebx
    533a: 45 89 de                     	movl	%r11d, %r14d
    533d: 41 c1 c6 15                  	roll	$0x15, %r14d
    5341: 41 31 de                     	xorl	%ebx, %r14d
    5344: 44 89 db                     	movl	%r11d, %ebx
    5347: c1 c3 07                     	roll	$0x7, %ebx
    534a: 44 31 f3                     	xorl	%r14d, %ebx
    534d: 41 89 ce                     	movl	%ecx, %r14d
    5350: 45 31 ce                     	xorl	%r9d, %r14d
    5353: 45 21 de                     	andl	%r11d, %r14d
    5356: 45 31 ce                     	xorl	%r9d, %r14d
    5359: 44 03 85 60 ff ff ff         	addl	-0xa0(%rbp), %r8d
    5360: 45 01 f0                     	addl	%r14d, %r8d
    5363: 42 8d 9c 03 54 73 0a 65      	leal	0x650a7354(%rbx,%r8), %ebx
    536b: 01 da                        	addl	%ebx, %edx
    536d: 45 89 d0                     	movl	%r10d, %r8d
    5370: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5374: 45 89 d6                     	movl	%r10d, %r14d
    5377: 41 c1 c6 13                  	roll	$0x13, %r14d
    537b: 45 31 c6                     	xorl	%r8d, %r14d
    537e: 45 89 d7                     	movl	%r10d, %r15d
    5381: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5385: 45 31 f7                     	xorl	%r14d, %r15d
    5388: 41 89 c6                     	movl	%eax, %r14d
    538b: 41 09 f6                     	orl	%esi, %r14d
    538e: 45 21 d6                     	andl	%r10d, %r14d
    5391: 41 89 c0                     	movl	%eax, %r8d
    5394: 41 21 f0                     	andl	%esi, %r8d
    5397: 45 09 f0                     	orl	%r14d, %r8d
    539a: 45 01 f8                     	addl	%r15d, %r8d
    539d: 41 01 d8                     	addl	%ebx, %r8d
    53a0: 89 d3                        	movl	%edx, %ebx
    53a2: c1 c3 1a                     	roll	$0x1a, %ebx
    53a5: 41 89 d6                     	movl	%edx, %r14d
    53a8: 41 c1 c6 15                  	roll	$0x15, %r14d
    53ac: 41 31 de                     	xorl	%ebx, %r14d
    53af: 89 d3                        	movl	%edx, %ebx
    53b1: c1 c3 07                     	roll	$0x7, %ebx
    53b4: 44 31 f3                     	xorl	%r14d, %ebx
    53b7: 45 89 de                     	movl	%r11d, %r14d
    53ba: 41 31 ce                     	xorl	%ecx, %r14d
    53bd: 41 21 d6                     	andl	%edx, %r14d
    53c0: 44 03 8d 64 ff ff ff         	addl	-0x9c(%rbp), %r9d
    53c7: 41 31 ce                     	xorl	%ecx, %r14d
    53ca: 45 01 f1                     	addl	%r14d, %r9d
    53cd: 42 8d 9c 0b bb 0a 6a 76      	leal	0x766a0abb(%rbx,%r9), %ebx
    53d5: 01 de                        	addl	%ebx, %esi
    53d7: 45 89 c1                     	movl	%r8d, %r9d
    53da: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    53de: 45 89 c6                     	movl	%r8d, %r14d
    53e1: 41 c1 c6 13                  	roll	$0x13, %r14d
    53e5: 45 31 ce                     	xorl	%r9d, %r14d
    53e8: 45 89 c7                     	movl	%r8d, %r15d
    53eb: 41 c1 c7 0a                  	roll	$0xa, %r15d
    53ef: 45 31 f7                     	xorl	%r14d, %r15d
    53f2: 45 89 d6                     	movl	%r10d, %r14d
    53f5: 41 09 c6                     	orl	%eax, %r14d
    53f8: 45 21 c6                     	andl	%r8d, %r14d
    53fb: 45 89 d1                     	movl	%r10d, %r9d
    53fe: 41 21 c1                     	andl	%eax, %r9d
    5401: 45 09 f1                     	orl	%r14d, %r9d
    5404: 41 89 f6                     	movl	%esi, %r14d
    5407: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    540b: 45 01 f9                     	addl	%r15d, %r9d
    540e: 41 89 f7                     	movl	%esi, %r15d
    5411: 41 c1 c7 15                  	roll	$0x15, %r15d
    5415: 41 01 d9                     	addl	%ebx, %r9d
    5418: 89 f3                        	movl	%esi, %ebx
    541a: c1 c3 07                     	roll	$0x7, %ebx
    541d: 45 31 f7                     	xorl	%r14d, %r15d
    5420: 44 31 fb                     	xorl	%r15d, %ebx
    5423: 41 89 d6                     	movl	%edx, %r14d
    5426: 45 31 de                     	xorl	%r11d, %r14d
    5429: 41 21 f6                     	andl	%esi, %r14d
    542c: 45 31 de                     	xorl	%r11d, %r14d
    542f: 03 8d 68 ff ff ff            	addl	-0x98(%rbp), %ecx
    5435: 44 01 f1                     	addl	%r14d, %ecx
    5438: 45 89 ce                     	movl	%r9d, %r14d
    543b: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    543f: 8d 9c 0b 2e c9 c2 81         	leal	-0x7e3d36d2(%rbx,%rcx), %ebx
    5446: 44 89 c9                     	movl	%r9d, %ecx
    5449: c1 c1 13                     	roll	$0x13, %ecx
    544c: 01 d8                        	addl	%ebx, %eax
    544e: 45 89 cf                     	movl	%r9d, %r15d
    5451: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5455: 44 31 f1                     	xorl	%r14d, %ecx
    5458: 41 31 cf                     	xorl	%ecx, %r15d
    545b: 45 89 c6                     	movl	%r8d, %r14d
    545e: 45 09 d6                     	orl	%r10d, %r14d
    5461: 45 21 ce                     	andl	%r9d, %r14d
    5464: 44 89 c1                     	movl	%r8d, %ecx
    5467: 44 21 d1                     	andl	%r10d, %ecx
    546a: 44 09 f1                     	orl	%r14d, %ecx
    546d: 44 01 f9                     	addl	%r15d, %ecx
    5470: 41 89 c6                     	movl	%eax, %r14d
    5473: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5477: 01 d9                        	addl	%ebx, %ecx
    5479: 89 c3                        	movl	%eax, %ebx
    547b: c1 c3 15                     	roll	$0x15, %ebx
    547e: 44 31 f3                     	xorl	%r14d, %ebx
    5481: 41 89 c6                     	movl	%eax, %r14d
    5484: 41 c1 c6 07                  	roll	$0x7, %r14d
    5488: 41 31 de                     	xorl	%ebx, %r14d
    548b: 89 f3                        	movl	%esi, %ebx
    548d: 31 d3                        	xorl	%edx, %ebx
    548f: 21 c3                        	andl	%eax, %ebx
    5491: 31 d3                        	xorl	%edx, %ebx
    5493: 44 03 9d 6c ff ff ff         	addl	-0x94(%rbp), %r11d
    549a: 41 01 db                     	addl	%ebx, %r11d
    549d: 43 8d 9c 1e 85 2c 72 92      	leal	-0x6d8dd37b(%r14,%r11), %ebx
    54a5: 41 89 cb                     	movl	%ecx, %r11d
    54a8: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    54ac: 41 01 da                     	addl	%ebx, %r10d
    54af: 41 89 ce                     	movl	%ecx, %r14d
    54b2: 41 c1 c6 13                  	roll	$0x13, %r14d
    54b6: 45 31 de                     	xorl	%r11d, %r14d
    54b9: 41 89 cf                     	movl	%ecx, %r15d
    54bc: 41 c1 c7 0a                  	roll	$0xa, %r15d
    54c0: 45 31 f7                     	xorl	%r14d, %r15d
    54c3: 45 89 ce                     	movl	%r9d, %r14d
    54c6: 45 09 c6                     	orl	%r8d, %r14d
    54c9: 41 21 ce                     	andl	%ecx, %r14d
    54cc: 45 89 cb                     	movl	%r9d, %r11d
    54cf: 45 21 c3                     	andl	%r8d, %r11d
    54d2: 45 09 f3                     	orl	%r14d, %r11d
    54d5: 45 01 fb                     	addl	%r15d, %r11d
    54d8: 41 01 db                     	addl	%ebx, %r11d
    54db: 44 89 d3                     	movl	%r10d, %ebx
    54de: c1 c3 1a                     	roll	$0x1a, %ebx
    54e1: 45 89 d6                     	movl	%r10d, %r14d
    54e4: 41 c1 c6 15                  	roll	$0x15, %r14d
    54e8: 41 31 de                     	xorl	%ebx, %r14d
    54eb: 44 89 d3                     	movl	%r10d, %ebx
    54ee: c1 c3 07                     	roll	$0x7, %ebx
    54f1: 44 31 f3                     	xorl	%r14d, %ebx
    54f4: 41 89 c6                     	movl	%eax, %r14d
    54f7: 41 31 f6                     	xorl	%esi, %r14d
    54fa: 45 21 d6                     	andl	%r10d, %r14d
    54fd: 41 31 f6                     	xorl	%esi, %r14d
    5500: 03 95 70 ff ff ff            	addl	-0x90(%rbp), %edx
    5506: 44 01 f2                     	addl	%r14d, %edx
    5509: 8d 9c 13 a1 e8 bf a2         	leal	-0x5d40175f(%rbx,%rdx), %ebx
    5510: 41 01 d8                     	addl	%ebx, %r8d
    5513: 44 89 da                     	movl	%r11d, %edx
    5516: c1 c2 1e                     	roll	$0x1e, %edx
    5519: 45 89 de                     	movl	%r11d, %r14d
    551c: 41 c1 c6 13                  	roll	$0x13, %r14d
    5520: 41 31 d6                     	xorl	%edx, %r14d
    5523: 45 89 df                     	movl	%r11d, %r15d
    5526: 41 c1 c7 0a                  	roll	$0xa, %r15d
    552a: 45 31 f7                     	xorl	%r14d, %r15d
    552d: 41 89 ce                     	movl	%ecx, %r14d
    5530: 45 09 ce                     	orl	%r9d, %r14d
    5533: 45 21 de                     	andl	%r11d, %r14d
    5536: 89 ca                        	movl	%ecx, %edx
    5538: 44 21 ca                     	andl	%r9d, %edx
    553b: 44 09 f2                     	orl	%r14d, %edx
    553e: 44 01 fa                     	addl	%r15d, %edx
    5541: 01 da                        	addl	%ebx, %edx
    5543: 44 89 c3                     	movl	%r8d, %ebx
    5546: c1 c3 1a                     	roll	$0x1a, %ebx
    5549: 45 89 c6                     	movl	%r8d, %r14d
    554c: 41 c1 c6 15                  	roll	$0x15, %r14d
    5550: 41 31 de                     	xorl	%ebx, %r14d
    5553: 44 89 c3                     	movl	%r8d, %ebx
    5556: c1 c3 07                     	roll	$0x7, %ebx
    5559: 44 31 f3                     	xorl	%r14d, %ebx
    555c: 45 89 d6                     	movl	%r10d, %r14d
    555f: 41 31 c6                     	xorl	%eax, %r14d
    5562: 45 21 c6                     	andl	%r8d, %r14d
    5565: 03 b5 74 ff ff ff            	addl	-0x8c(%rbp), %esi
    556b: 41 31 c6                     	xorl	%eax, %r14d
    556e: 44 01 f6                     	addl	%r14d, %esi
    5571: 8d 9c 33 4b 66 1a a8         	leal	-0x57e599b5(%rbx,%rsi), %ebx
    5578: 41 01 d9                     	addl	%ebx, %r9d
    557b: 89 d6                        	movl	%edx, %esi
    557d: c1 c6 1e                     	roll	$0x1e, %esi
    5580: 41 89 d6                     	movl	%edx, %r14d
    5583: 41 c1 c6 13                  	roll	$0x13, %r14d
    5587: 41 31 f6                     	xorl	%esi, %r14d
    558a: 41 89 d7                     	movl	%edx, %r15d
    558d: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5591: 45 31 f7                     	xorl	%r14d, %r15d
    5594: 45 89 de                     	movl	%r11d, %r14d
    5597: 41 09 ce                     	orl	%ecx, %r14d
    559a: 41 21 d6                     	andl	%edx, %r14d
    559d: 44 89 de                     	movl	%r11d, %esi
    55a0: 21 ce                        	andl	%ecx, %esi
    55a2: 44 09 f6                     	orl	%r14d, %esi
    55a5: 45 89 ce                     	movl	%r9d, %r14d
    55a8: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    55ac: 44 01 fe                     	addl	%r15d, %esi
    55af: 45 89 cf                     	movl	%r9d, %r15d
    55b2: 41 c1 c7 15                  	roll	$0x15, %r15d
    55b6: 01 de                        	addl	%ebx, %esi
    55b8: 44 89 cb                     	movl	%r9d, %ebx
    55bb: c1 c3 07                     	roll	$0x7, %ebx
    55be: 45 31 f7                     	xorl	%r14d, %r15d
    55c1: 44 31 fb                     	xorl	%r15d, %ebx
    55c4: 45 89 c6                     	movl	%r8d, %r14d
    55c7: 45 31 d6                     	xorl	%r10d, %r14d
    55ca: 45 21 ce                     	andl	%r9d, %r14d
    55cd: 45 31 d6                     	xorl	%r10d, %r14d
    55d0: 03 85 78 ff ff ff            	addl	-0x88(%rbp), %eax
    55d6: 44 01 f0                     	addl	%r14d, %eax
    55d9: 41 89 f6                     	movl	%esi, %r14d
    55dc: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    55e0: 8d 9c 03 70 8b 4b c2         	leal	-0x3db47490(%rbx,%rax), %ebx
    55e7: 89 f0                        	movl	%esi, %eax
    55e9: c1 c0 13                     	roll	$0x13, %eax
    55ec: 01 d9                        	addl	%ebx, %ecx
    55ee: 41 89 f7                     	movl	%esi, %r15d
    55f1: 41 c1 c7 0a                  	roll	$0xa, %r15d
    55f5: 44 31 f0                     	xorl	%r14d, %eax
    55f8: 41 31 c7                     	xorl	%eax, %r15d
    55fb: 41 89 d6                     	movl	%edx, %r14d
    55fe: 45 09 de                     	orl	%r11d, %r14d
    5601: 41 21 f6                     	andl	%esi, %r14d
    5604: 89 d0                        	movl	%edx, %eax
    5606: 44 21 d8                     	andl	%r11d, %eax
    5609: 44 09 f0                     	orl	%r14d, %eax
    560c: 44 01 f8                     	addl	%r15d, %eax
    560f: 41 89 ce                     	movl	%ecx, %r14d
    5612: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5616: 01 d8                        	addl	%ebx, %eax
    5618: 89 cb                        	movl	%ecx, %ebx
    561a: c1 c3 15                     	roll	$0x15, %ebx
    561d: 44 31 f3                     	xorl	%r14d, %ebx
    5620: 41 89 ce                     	movl	%ecx, %r14d
    5623: 41 c1 c6 07                  	roll	$0x7, %r14d
    5627: 41 31 de                     	xorl	%ebx, %r14d
    562a: 44 89 cb                     	movl	%r9d, %ebx
    562d: 44 31 c3                     	xorl	%r8d, %ebx
    5630: 21 cb                        	andl	%ecx, %ebx
    5632: 44 31 c3                     	xorl	%r8d, %ebx
    5635: 44 03 95 7c ff ff ff         	addl	-0x84(%rbp), %r10d
    563c: 41 01 da                     	addl	%ebx, %r10d
    563f: 47 8d 94 16 a3 51 6c c7      	leal	-0x3893ae5d(%r14,%r10), %r10d
    5647: 89 c3                        	movl	%eax, %ebx
    5649: c1 c3 1e                     	roll	$0x1e, %ebx
    564c: 45 01 d3                     	addl	%r10d, %r11d
    564f: 41 89 c6                     	movl	%eax, %r14d
    5652: 41 c1 c6 13                  	roll	$0x13, %r14d
    5656: 41 31 de                     	xorl	%ebx, %r14d
    5659: 41 89 c7                     	movl	%eax, %r15d
    565c: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5660: 45 31 f7                     	xorl	%r14d, %r15d
    5663: 41 89 f6                     	movl	%esi, %r14d
    5666: 41 09 d6                     	orl	%edx, %r14d
    5669: 41 21 c6                     	andl	%eax, %r14d
    566c: 89 f3                        	movl	%esi, %ebx
    566e: 21 d3                        	andl	%edx, %ebx
    5670: 44 09 f3                     	orl	%r14d, %ebx
    5673: 44 01 fb                     	addl	%r15d, %ebx
    5676: 44 01 d3                     	addl	%r10d, %ebx
    5679: 45 89 da                     	movl	%r11d, %r10d
    567c: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    5680: 45 89 de                     	movl	%r11d, %r14d
    5683: 41 c1 c6 15                  	roll	$0x15, %r14d
    5687: 45 31 d6                     	xorl	%r10d, %r14d
    568a: 45 89 da                     	movl	%r11d, %r10d
    568d: 41 c1 c2 07                  	roll	$0x7, %r10d
    5691: 45 31 f2                     	xorl	%r14d, %r10d
    5694: 41 89 ce                     	movl	%ecx, %r14d
    5697: 45 31 ce                     	xorl	%r9d, %r14d
    569a: 45 21 de                     	andl	%r11d, %r14d
    569d: 45 31 ce                     	xorl	%r9d, %r14d
    56a0: 44 03 45 80                  	addl	-0x80(%rbp), %r8d
    56a4: 45 01 f0                     	addl	%r14d, %r8d
    56a7: 47 8d 94 02 19 e8 92 d1      	leal	-0x2e6d17e7(%r10,%r8), %r10d
    56af: 44 01 d2                     	addl	%r10d, %edx
    56b2: 41 89 d8                     	movl	%ebx, %r8d
    56b5: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    56b9: 41 89 de                     	movl	%ebx, %r14d
    56bc: 41 c1 c6 13                  	roll	$0x13, %r14d
    56c0: 45 31 c6                     	xorl	%r8d, %r14d
    56c3: 41 89 df                     	movl	%ebx, %r15d
    56c6: 41 c1 c7 0a                  	roll	$0xa, %r15d
    56ca: 45 31 f7                     	xorl	%r14d, %r15d
    56cd: 41 89 c6                     	movl	%eax, %r14d
    56d0: 41 09 f6                     	orl	%esi, %r14d
    56d3: 41 21 de                     	andl	%ebx, %r14d
    56d6: 41 89 c0                     	movl	%eax, %r8d
    56d9: 41 21 f0                     	andl	%esi, %r8d
    56dc: 45 09 f0                     	orl	%r14d, %r8d
    56df: 45 01 f8                     	addl	%r15d, %r8d
    56e2: 45 01 d0                     	addl	%r10d, %r8d
    56e5: 41 89 d2                     	movl	%edx, %r10d
    56e8: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    56ec: 41 89 d6                     	movl	%edx, %r14d
    56ef: 41 c1 c6 15                  	roll	$0x15, %r14d
    56f3: 45 31 d6                     	xorl	%r10d, %r14d
    56f6: 41 89 d2                     	movl	%edx, %r10d
    56f9: 41 c1 c2 07                  	roll	$0x7, %r10d
    56fd: 45 31 f2                     	xorl	%r14d, %r10d
    5700: 45 89 de                     	movl	%r11d, %r14d
    5703: 41 31 ce                     	xorl	%ecx, %r14d
    5706: 41 21 d6                     	andl	%edx, %r14d
    5709: 44 03 4d 84                  	addl	-0x7c(%rbp), %r9d
    570d: 41 31 ce                     	xorl	%ecx, %r14d
    5710: 45 01 f1                     	addl	%r14d, %r9d
    5713: 47 8d 94 0a 24 06 99 d6      	leal	-0x2966f9dc(%r10,%r9), %r10d
    571b: 44 01 d6                     	addl	%r10d, %esi
    571e: 45 89 c1                     	movl	%r8d, %r9d
    5721: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5725: 45 89 c6                     	movl	%r8d, %r14d
    5728: 41 c1 c6 13                  	roll	$0x13, %r14d
    572c: 45 31 ce                     	xorl	%r9d, %r14d
    572f: 45 89 c7                     	movl	%r8d, %r15d
    5732: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5736: 45 31 f7                     	xorl	%r14d, %r15d
    5739: 41 89 de                     	movl	%ebx, %r14d
    573c: 41 09 c6                     	orl	%eax, %r14d
    573f: 45 21 c6                     	andl	%r8d, %r14d
    5742: 41 89 d9                     	movl	%ebx, %r9d
    5745: 41 21 c1                     	andl	%eax, %r9d
    5748: 45 09 f1                     	orl	%r14d, %r9d
    574b: 41 89 f6                     	movl	%esi, %r14d
    574e: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5752: 45 01 f9                     	addl	%r15d, %r9d
    5755: 41 89 f7                     	movl	%esi, %r15d
    5758: 41 c1 c7 15                  	roll	$0x15, %r15d
    575c: 45 01 d1                     	addl	%r10d, %r9d
    575f: 41 89 f2                     	movl	%esi, %r10d
    5762: 41 c1 c2 07                  	roll	$0x7, %r10d
    5766: 45 31 f7                     	xorl	%r14d, %r15d
    5769: 45 31 fa                     	xorl	%r15d, %r10d
    576c: 41 89 d6                     	movl	%edx, %r14d
    576f: 45 31 de                     	xorl	%r11d, %r14d
    5772: 41 21 f6                     	andl	%esi, %r14d
    5775: 45 31 de                     	xorl	%r11d, %r14d
    5778: 03 4d 88                     	addl	-0x78(%rbp), %ecx
    577b: 44 01 f1                     	addl	%r14d, %ecx
    577e: 45 89 ce                     	movl	%r9d, %r14d
    5781: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5785: 45 8d 94 0a 85 35 0e f4      	leal	-0xbf1ca7b(%r10,%rcx), %r10d
    578d: 44 89 c9                     	movl	%r9d, %ecx
    5790: c1 c1 13                     	roll	$0x13, %ecx
    5793: 44 01 d0                     	addl	%r10d, %eax
    5796: 45 89 cf                     	movl	%r9d, %r15d
    5799: 41 c1 c7 0a                  	roll	$0xa, %r15d
    579d: 44 31 f1                     	xorl	%r14d, %ecx
    57a0: 41 31 cf                     	xorl	%ecx, %r15d
    57a3: 45 89 c6                     	movl	%r8d, %r14d
    57a6: 41 09 de                     	orl	%ebx, %r14d
    57a9: 45 21 ce                     	andl	%r9d, %r14d
    57ac: 44 89 c1                     	movl	%r8d, %ecx
    57af: 21 d9                        	andl	%ebx, %ecx
    57b1: 44 09 f1                     	orl	%r14d, %ecx
    57b4: 44 01 f9                     	addl	%r15d, %ecx
    57b7: 41 89 c6                     	movl	%eax, %r14d
    57ba: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    57be: 44 01 d1                     	addl	%r10d, %ecx
    57c1: 41 89 c2                     	movl	%eax, %r10d
    57c4: 41 c1 c2 15                  	roll	$0x15, %r10d
    57c8: 45 31 f2                     	xorl	%r14d, %r10d
    57cb: 41 89 c6                     	movl	%eax, %r14d
    57ce: 41 c1 c6 07                  	roll	$0x7, %r14d
    57d2: 45 31 d6                     	xorl	%r10d, %r14d
    57d5: 41 89 f2                     	movl	%esi, %r10d
    57d8: 41 31 d2                     	xorl	%edx, %r10d
    57db: 41 21 c2                     	andl	%eax, %r10d
    57de: 41 31 d2                     	xorl	%edx, %r10d
    57e1: 44 03 5d 8c                  	addl	-0x74(%rbp), %r11d
    57e5: 45 01 d3                     	addl	%r10d, %r11d
    57e8: 47 8d 94 1e 70 a0 6a 10      	leal	0x106aa070(%r14,%r11), %r10d
    57f0: 41 89 cb                     	movl	%ecx, %r11d
    57f3: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    57f7: 44 01 d3                     	addl	%r10d, %ebx
    57fa: 41 89 ce                     	movl	%ecx, %r14d
    57fd: 41 c1 c6 13                  	roll	$0x13, %r14d
    5801: 45 31 de                     	xorl	%r11d, %r14d
    5804: 41 89 cf                     	movl	%ecx, %r15d
    5807: 41 c1 c7 0a                  	roll	$0xa, %r15d
    580b: 45 31 f7                     	xorl	%r14d, %r15d
    580e: 45 89 ce                     	movl	%r9d, %r14d
    5811: 45 09 c6                     	orl	%r8d, %r14d
    5814: 41 21 ce                     	andl	%ecx, %r14d
    5817: 45 89 cb                     	movl	%r9d, %r11d
    581a: 45 21 c3                     	andl	%r8d, %r11d
    581d: 45 09 f3                     	orl	%r14d, %r11d
    5820: 45 01 fb                     	addl	%r15d, %r11d
    5823: 45 01 d3                     	addl	%r10d, %r11d
    5826: 41 89 da                     	movl	%ebx, %r10d
    5829: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    582d: 41 89 de                     	movl	%ebx, %r14d
    5830: 41 c1 c6 15                  	roll	$0x15, %r14d
    5834: 45 31 d6                     	xorl	%r10d, %r14d
    5837: 41 89 da                     	movl	%ebx, %r10d
    583a: 41 c1 c2 07                  	roll	$0x7, %r10d
    583e: 45 31 f2                     	xorl	%r14d, %r10d
    5841: 41 89 c6                     	movl	%eax, %r14d
    5844: 41 31 f6                     	xorl	%esi, %r14d
    5847: 41 21 de                     	andl	%ebx, %r14d
    584a: 41 31 f6                     	xorl	%esi, %r14d
    584d: 03 55 90                     	addl	-0x70(%rbp), %edx
    5850: 44 01 f2                     	addl	%r14d, %edx
    5853: 41 8d 94 12 16 c1 a4 19      	leal	0x19a4c116(%r10,%rdx), %edx
    585b: 41 01 d0                     	addl	%edx, %r8d
    585e: 45 89 da                     	movl	%r11d, %r10d
    5861: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5865: 45 89 de                     	movl	%r11d, %r14d
    5868: 41 c1 c6 13                  	roll	$0x13, %r14d
    586c: 45 31 d6                     	xorl	%r10d, %r14d
    586f: 45 89 df                     	movl	%r11d, %r15d
    5872: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5876: 45 31 f7                     	xorl	%r14d, %r15d
    5879: 41 89 ce                     	movl	%ecx, %r14d
    587c: 45 09 ce                     	orl	%r9d, %r14d
    587f: 45 21 de                     	andl	%r11d, %r14d
    5882: 41 89 ca                     	movl	%ecx, %r10d
    5885: 45 21 ca                     	andl	%r9d, %r10d
    5888: 45 09 f2                     	orl	%r14d, %r10d
    588b: 45 01 fa                     	addl	%r15d, %r10d
    588e: 41 01 d2                     	addl	%edx, %r10d
    5891: 44 89 c2                     	movl	%r8d, %edx
    5894: c1 c2 1a                     	roll	$0x1a, %edx
    5897: 45 89 c6                     	movl	%r8d, %r14d
    589a: 41 c1 c6 15                  	roll	$0x15, %r14d
    589e: 41 31 d6                     	xorl	%edx, %r14d
    58a1: 44 89 c2                     	movl	%r8d, %edx
    58a4: c1 c2 07                     	roll	$0x7, %edx
    58a7: 44 31 f2                     	xorl	%r14d, %edx
    58aa: 41 89 de                     	movl	%ebx, %r14d
    58ad: 41 31 c6                     	xorl	%eax, %r14d
    58b0: 45 21 c6                     	andl	%r8d, %r14d
    58b3: 03 75 94                     	addl	-0x6c(%rbp), %esi
    58b6: 41 31 c6                     	xorl	%eax, %r14d
    58b9: 44 01 f6                     	addl	%r14d, %esi
    58bc: 8d 94 32 08 6c 37 1e         	leal	0x1e376c08(%rdx,%rsi), %edx
    58c3: 41 01 d1                     	addl	%edx, %r9d
    58c6: 44 89 d6                     	movl	%r10d, %esi
    58c9: c1 c6 1e                     	roll	$0x1e, %esi
    58cc: 45 89 d6                     	movl	%r10d, %r14d
    58cf: 41 c1 c6 13                  	roll	$0x13, %r14d
    58d3: 41 31 f6                     	xorl	%esi, %r14d
    58d6: 45 89 d7                     	movl	%r10d, %r15d
    58d9: 41 c1 c7 0a                  	roll	$0xa, %r15d
    58dd: 45 31 f7                     	xorl	%r14d, %r15d
    58e0: 45 89 de                     	movl	%r11d, %r14d
    58e3: 41 09 ce                     	orl	%ecx, %r14d
    58e6: 45 21 d6                     	andl	%r10d, %r14d
    58e9: 44 89 de                     	movl	%r11d, %esi
    58ec: 21 ce                        	andl	%ecx, %esi
    58ee: 44 09 f6                     	orl	%r14d, %esi
    58f1: 45 89 ce                     	movl	%r9d, %r14d
    58f4: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    58f8: 44 01 fe                     	addl	%r15d, %esi
    58fb: 45 89 cf                     	movl	%r9d, %r15d
    58fe: 41 c1 c7 15                  	roll	$0x15, %r15d
    5902: 01 d6                        	addl	%edx, %esi
    5904: 44 89 ca                     	movl	%r9d, %edx
    5907: c1 c2 07                     	roll	$0x7, %edx
    590a: 45 31 f7                     	xorl	%r14d, %r15d
    590d: 44 31 fa                     	xorl	%r15d, %edx
    5910: 45 89 c6                     	movl	%r8d, %r14d
    5913: 41 31 de                     	xorl	%ebx, %r14d
    5916: 45 21 ce                     	andl	%r9d, %r14d
    5919: 41 31 de                     	xorl	%ebx, %r14d
    591c: 03 45 98                     	addl	-0x68(%rbp), %eax
    591f: 44 01 f0                     	addl	%r14d, %eax
    5922: 41 89 f6                     	movl	%esi, %r14d
    5925: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5929: 8d 84 02 4c 77 48 27         	leal	0x2748774c(%rdx,%rax), %eax
    5930: 89 f2                        	movl	%esi, %edx
    5932: c1 c2 13                     	roll	$0x13, %edx
    5935: 01 c1                        	addl	%eax, %ecx
    5937: 41 89 f7                     	movl	%esi, %r15d
    593a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    593e: 44 31 f2                     	xorl	%r14d, %edx
    5941: 41 31 d7                     	xorl	%edx, %r15d
    5944: 45 89 d6                     	movl	%r10d, %r14d
    5947: 45 09 de                     	orl	%r11d, %r14d
    594a: 41 21 f6                     	andl	%esi, %r14d
    594d: 44 89 d2                     	movl	%r10d, %edx
    5950: 44 21 da                     	andl	%r11d, %edx
    5953: 44 09 f2                     	orl	%r14d, %edx
    5956: 44 01 fa                     	addl	%r15d, %edx
    5959: 41 89 ce                     	movl	%ecx, %r14d
    595c: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5960: 01 c2                        	addl	%eax, %edx
    5962: 89 c8                        	movl	%ecx, %eax
    5964: c1 c0 15                     	roll	$0x15, %eax
    5967: 44 31 f0                     	xorl	%r14d, %eax
    596a: 41 89 ce                     	movl	%ecx, %r14d
    596d: 41 c1 c6 07                  	roll	$0x7, %r14d
    5971: 41 31 c6                     	xorl	%eax, %r14d
    5974: 44 89 c8                     	movl	%r9d, %eax
    5977: 44 31 c0                     	xorl	%r8d, %eax
    597a: 21 c8                        	andl	%ecx, %eax
    597c: 44 31 c0                     	xorl	%r8d, %eax
    597f: 03 5d 9c                     	addl	-0x64(%rbp), %ebx
    5982: 01 c3                        	addl	%eax, %ebx
    5984: 41 8d 84 1e b5 bc b0 34      	leal	0x34b0bcb5(%r14,%rbx), %eax
    598c: 89 d3                        	movl	%edx, %ebx
    598e: c1 c3 1e                     	roll	$0x1e, %ebx
    5991: 41 01 c3                     	addl	%eax, %r11d
    5994: 41 89 d6                     	movl	%edx, %r14d
    5997: 41 c1 c6 13                  	roll	$0x13, %r14d
    599b: 41 31 de                     	xorl	%ebx, %r14d
    599e: 41 89 d7                     	movl	%edx, %r15d
    59a1: 41 c1 c7 0a                  	roll	$0xa, %r15d
    59a5: 45 31 f7                     	xorl	%r14d, %r15d
    59a8: 41 89 f6                     	movl	%esi, %r14d
    59ab: 45 09 d6                     	orl	%r10d, %r14d
    59ae: 41 21 d6                     	andl	%edx, %r14d
    59b1: 89 f3                        	movl	%esi, %ebx
    59b3: 44 21 d3                     	andl	%r10d, %ebx
    59b6: 44 09 f3                     	orl	%r14d, %ebx
    59b9: 44 01 fb                     	addl	%r15d, %ebx
    59bc: 01 c3                        	addl	%eax, %ebx
    59be: 44 89 d8                     	movl	%r11d, %eax
    59c1: c1 c0 1a                     	roll	$0x1a, %eax
    59c4: 45 89 de                     	movl	%r11d, %r14d
    59c7: 41 c1 c6 15                  	roll	$0x15, %r14d
    59cb: 41 31 c6                     	xorl	%eax, %r14d
    59ce: 44 89 d8                     	movl	%r11d, %eax
    59d1: c1 c0 07                     	roll	$0x7, %eax
    59d4: 44 31 f0                     	xorl	%r14d, %eax
    59d7: 41 89 ce                     	movl	%ecx, %r14d
    59da: 45 31 ce                     	xorl	%r9d, %r14d
    59dd: 45 21 de                     	andl	%r11d, %r14d
    59e0: 45 31 ce                     	xorl	%r9d, %r14d
    59e3: 44 03 45 a0                  	addl	-0x60(%rbp), %r8d
    59e7: 45 01 f0                     	addl	%r14d, %r8d
    59ea: 42 8d 84 00 b3 0c 1c 39      	leal	0x391c0cb3(%rax,%r8), %eax
    59f2: 41 01 c2                     	addl	%eax, %r10d
    59f5: 41 89 d8                     	movl	%ebx, %r8d
    59f8: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    59fc: 41 89 de                     	movl	%ebx, %r14d
    59ff: 41 c1 c6 13                  	roll	$0x13, %r14d
    5a03: 45 31 c6                     	xorl	%r8d, %r14d
    5a06: 41 89 df                     	movl	%ebx, %r15d
    5a09: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5a0d: 45 31 f7                     	xorl	%r14d, %r15d
    5a10: 41 89 d6                     	movl	%edx, %r14d
    5a13: 41 09 f6                     	orl	%esi, %r14d
    5a16: 41 21 de                     	andl	%ebx, %r14d
    5a19: 41 89 d0                     	movl	%edx, %r8d
    5a1c: 41 21 f0                     	andl	%esi, %r8d
    5a1f: 45 09 f0                     	orl	%r14d, %r8d
    5a22: 45 01 f8                     	addl	%r15d, %r8d
    5a25: 41 01 c0                     	addl	%eax, %r8d
    5a28: 44 89 d0                     	movl	%r10d, %eax
    5a2b: c1 c0 1a                     	roll	$0x1a, %eax
    5a2e: 45 89 d6                     	movl	%r10d, %r14d
    5a31: 41 c1 c6 15                  	roll	$0x15, %r14d
    5a35: 41 31 c6                     	xorl	%eax, %r14d
    5a38: 44 89 d0                     	movl	%r10d, %eax
    5a3b: c1 c0 07                     	roll	$0x7, %eax
    5a3e: 44 31 f0                     	xorl	%r14d, %eax
    5a41: 45 89 de                     	movl	%r11d, %r14d
    5a44: 41 31 ce                     	xorl	%ecx, %r14d
    5a47: 45 21 d6                     	andl	%r10d, %r14d
    5a4a: 44 03 4d a4                  	addl	-0x5c(%rbp), %r9d
    5a4e: 41 31 ce                     	xorl	%ecx, %r14d
    5a51: 45 01 f1                     	addl	%r14d, %r9d
    5a54: 42 8d 84 08 4a aa d8 4e      	leal	0x4ed8aa4a(%rax,%r9), %eax
    5a5c: 01 c6                        	addl	%eax, %esi
    5a5e: 45 89 c1                     	movl	%r8d, %r9d
    5a61: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5a65: 45 89 c6                     	movl	%r8d, %r14d
    5a68: 41 c1 c6 13                  	roll	$0x13, %r14d
    5a6c: 45 31 ce                     	xorl	%r9d, %r14d
    5a6f: 45 89 c7                     	movl	%r8d, %r15d
    5a72: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5a76: 45 31 f7                     	xorl	%r14d, %r15d
    5a79: 41 89 de                     	movl	%ebx, %r14d
    5a7c: 41 09 d6                     	orl	%edx, %r14d
    5a7f: 45 21 c6                     	andl	%r8d, %r14d
    5a82: 41 89 d9                     	movl	%ebx, %r9d
    5a85: 41 21 d1                     	andl	%edx, %r9d
    5a88: 45 09 f1                     	orl	%r14d, %r9d
    5a8b: 41 89 f6                     	movl	%esi, %r14d
    5a8e: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    5a92: 45 01 f9                     	addl	%r15d, %r9d
    5a95: 41 89 f7                     	movl	%esi, %r15d
    5a98: 41 c1 c7 15                  	roll	$0x15, %r15d
    5a9c: 41 01 c1                     	addl	%eax, %r9d
    5a9f: 89 f0                        	movl	%esi, %eax
    5aa1: c1 c0 07                     	roll	$0x7, %eax
    5aa4: 45 31 f7                     	xorl	%r14d, %r15d
    5aa7: 44 31 f8                     	xorl	%r15d, %eax
    5aaa: 45 89 d6                     	movl	%r10d, %r14d
    5aad: 45 31 de                     	xorl	%r11d, %r14d
    5ab0: 41 21 f6                     	andl	%esi, %r14d
    5ab3: 45 31 de                     	xorl	%r11d, %r14d
    5ab6: 03 4d a8                     	addl	-0x58(%rbp), %ecx
    5ab9: 44 01 f1                     	addl	%r14d, %ecx
    5abc: 45 89 ce                     	movl	%r9d, %r14d
    5abf: 41 c1 c6 1e                  	roll	$0x1e, %r14d
    5ac3: 8d 84 08 4f ca 9c 5b         	leal	0x5b9cca4f(%rax,%rcx), %eax
    5aca: 44 89 c9                     	movl	%r9d, %ecx
    5acd: c1 c1 13                     	roll	$0x13, %ecx
    5ad0: 01 c2                        	addl	%eax, %edx
    5ad2: 45 89 cf                     	movl	%r9d, %r15d
    5ad5: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5ad9: 44 31 f1                     	xorl	%r14d, %ecx
    5adc: 41 31 cf                     	xorl	%ecx, %r15d
    5adf: 44 89 c1                     	movl	%r8d, %ecx
    5ae2: 09 d9                        	orl	%ebx, %ecx
    5ae4: 44 21 c9                     	andl	%r9d, %ecx
    5ae7: 45 89 c6                     	movl	%r8d, %r14d
    5aea: 41 21 de                     	andl	%ebx, %r14d
    5aed: 41 09 ce                     	orl	%ecx, %r14d
    5af0: 45 01 fe                     	addl	%r15d, %r14d
    5af3: 89 d1                        	movl	%edx, %ecx
    5af5: c1 c1 1a                     	roll	$0x1a, %ecx
    5af8: 41 01 c6                     	addl	%eax, %r14d
    5afb: 89 d0                        	movl	%edx, %eax
    5afd: c1 c0 15                     	roll	$0x15, %eax
    5b00: 31 c8                        	xorl	%ecx, %eax
    5b02: 89 d1                        	movl	%edx, %ecx
    5b04: c1 c1 07                     	roll	$0x7, %ecx
    5b07: 31 c1                        	xorl	%eax, %ecx
    5b09: 89 f0                        	movl	%esi, %eax
    5b0b: 44 31 d0                     	xorl	%r10d, %eax
    5b0e: 21 d0                        	andl	%edx, %eax
    5b10: 44 31 d0                     	xorl	%r10d, %eax
    5b13: 44 03 5d ac                  	addl	-0x54(%rbp), %r11d
    5b17: 41 01 c3                     	addl	%eax, %r11d
    5b1a: 42 8d 84 19 f3 6f 2e 68      	leal	0x682e6ff3(%rcx,%r11), %eax
    5b22: 44 89 f1                     	movl	%r14d, %ecx
    5b25: c1 c1 1e                     	roll	$0x1e, %ecx
    5b28: 01 c3                        	addl	%eax, %ebx
    5b2a: 45 89 f3                     	movl	%r14d, %r11d
    5b2d: 41 c1 c3 13                  	roll	$0x13, %r11d
    5b31: 41 31 cb                     	xorl	%ecx, %r11d
    5b34: 45 89 f7                     	movl	%r14d, %r15d
    5b37: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5b3b: 45 31 df                     	xorl	%r11d, %r15d
    5b3e: 45 89 cb                     	movl	%r9d, %r11d
    5b41: 45 09 c3                     	orl	%r8d, %r11d
    5b44: 45 21 f3                     	andl	%r14d, %r11d
    5b47: 44 89 c9                     	movl	%r9d, %ecx
    5b4a: 44 21 c1                     	andl	%r8d, %ecx
    5b4d: 44 09 d9                     	orl	%r11d, %ecx
    5b50: 44 01 f9                     	addl	%r15d, %ecx
    5b53: 01 c1                        	addl	%eax, %ecx
    5b55: 89 d8                        	movl	%ebx, %eax
    5b57: c1 c0 1a                     	roll	$0x1a, %eax
    5b5a: 41 89 db                     	movl	%ebx, %r11d
    5b5d: 41 c1 c3 15                  	roll	$0x15, %r11d
    5b61: 41 31 c3                     	xorl	%eax, %r11d
    5b64: 89 d8                        	movl	%ebx, %eax
    5b66: c1 c0 07                     	roll	$0x7, %eax
    5b69: 44 31 d8                     	xorl	%r11d, %eax
    5b6c: 41 89 d3                     	movl	%edx, %r11d
    5b6f: 41 31 f3                     	xorl	%esi, %r11d
    5b72: 41 21 db                     	andl	%ebx, %r11d
    5b75: 41 31 f3                     	xorl	%esi, %r11d
    5b78: 44 03 55 b0                  	addl	-0x50(%rbp), %r10d
    5b7c: 45 01 da                     	addl	%r11d, %r10d
    5b7f: 46 8d 94 10 ee 82 8f 74      	leal	0x748f82ee(%rax,%r10), %r10d
    5b87: 45 01 d0                     	addl	%r10d, %r8d
    5b8a: 89 c8                        	movl	%ecx, %eax
    5b8c: c1 c0 1e                     	roll	$0x1e, %eax
    5b8f: 41 89 cb                     	movl	%ecx, %r11d
    5b92: 41 c1 c3 13                  	roll	$0x13, %r11d
    5b96: 41 31 c3                     	xorl	%eax, %r11d
    5b99: 41 89 cf                     	movl	%ecx, %r15d
    5b9c: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5ba0: 45 31 df                     	xorl	%r11d, %r15d
    5ba3: 45 89 f3                     	movl	%r14d, %r11d
    5ba6: 45 09 cb                     	orl	%r9d, %r11d
    5ba9: 41 21 cb                     	andl	%ecx, %r11d
    5bac: 44 89 f0                     	movl	%r14d, %eax
    5baf: 44 21 c8                     	andl	%r9d, %eax
    5bb2: 44 09 d8                     	orl	%r11d, %eax
    5bb5: 44 01 f8                     	addl	%r15d, %eax
    5bb8: 44 01 d0                     	addl	%r10d, %eax
    5bbb: 45 89 c2                     	movl	%r8d, %r10d
    5bbe: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    5bc2: 45 89 c3                     	movl	%r8d, %r11d
    5bc5: 41 c1 c3 15                  	roll	$0x15, %r11d
    5bc9: 45 31 d3                     	xorl	%r10d, %r11d
    5bcc: 45 89 c2                     	movl	%r8d, %r10d
    5bcf: 41 c1 c2 07                  	roll	$0x7, %r10d
    5bd3: 45 31 da                     	xorl	%r11d, %r10d
    5bd6: 41 89 db                     	movl	%ebx, %r11d
    5bd9: 41 31 d3                     	xorl	%edx, %r11d
    5bdc: 45 21 c3                     	andl	%r8d, %r11d
    5bdf: 03 75 b4                     	addl	-0x4c(%rbp), %esi
    5be2: 41 31 d3                     	xorl	%edx, %r11d
    5be5: 44 01 de                     	addl	%r11d, %esi
    5be8: 45 8d 94 32 6f 63 a5 78      	leal	0x78a5636f(%r10,%rsi), %r10d
    5bf0: 45 01 d1                     	addl	%r10d, %r9d
    5bf3: 89 c6                        	movl	%eax, %esi
    5bf5: c1 c6 1e                     	roll	$0x1e, %esi
    5bf8: 41 89 c3                     	movl	%eax, %r11d
    5bfb: 41 c1 c3 13                  	roll	$0x13, %r11d
    5bff: 41 31 f3                     	xorl	%esi, %r11d
    5c02: 41 89 c7                     	movl	%eax, %r15d
    5c05: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5c09: 45 31 df                     	xorl	%r11d, %r15d
    5c0c: 41 89 cb                     	movl	%ecx, %r11d
    5c0f: 45 09 f3                     	orl	%r14d, %r11d
    5c12: 41 21 c3                     	andl	%eax, %r11d
    5c15: 89 ce                        	movl	%ecx, %esi
    5c17: 44 21 f6                     	andl	%r14d, %esi
    5c1a: 44 09 de                     	orl	%r11d, %esi
    5c1d: 45 89 cb                     	movl	%r9d, %r11d
    5c20: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5c24: 44 01 fe                     	addl	%r15d, %esi
    5c27: 45 89 cf                     	movl	%r9d, %r15d
    5c2a: 41 c1 c7 15                  	roll	$0x15, %r15d
    5c2e: 44 01 d6                     	addl	%r10d, %esi
    5c31: 45 89 ca                     	movl	%r9d, %r10d
    5c34: 41 c1 c2 07                  	roll	$0x7, %r10d
    5c38: 45 31 df                     	xorl	%r11d, %r15d
    5c3b: 45 31 fa                     	xorl	%r15d, %r10d
    5c3e: 45 89 c3                     	movl	%r8d, %r11d
    5c41: 41 31 db                     	xorl	%ebx, %r11d
    5c44: 45 21 cb                     	andl	%r9d, %r11d
    5c47: 41 31 db                     	xorl	%ebx, %r11d
    5c4a: 03 55 b8                     	addl	-0x48(%rbp), %edx
    5c4d: 44 01 da                     	addl	%r11d, %edx
    5c50: 41 89 f3                     	movl	%esi, %r11d
    5c53: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    5c57: 45 8d 94 12 14 78 c8 84      	leal	-0x7b3787ec(%r10,%rdx), %r10d
    5c5f: 89 f2                        	movl	%esi, %edx
    5c61: c1 c2 13                     	roll	$0x13, %edx
    5c64: 45 01 d6                     	addl	%r10d, %r14d
    5c67: 41 89 f7                     	movl	%esi, %r15d
    5c6a: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5c6e: 44 31 da                     	xorl	%r11d, %edx
    5c71: 41 31 d7                     	xorl	%edx, %r15d
    5c74: 41 89 c3                     	movl	%eax, %r11d
    5c77: 41 09 cb                     	orl	%ecx, %r11d
    5c7a: 41 21 f3                     	andl	%esi, %r11d
    5c7d: 89 c2                        	movl	%eax, %edx
    5c7f: 21 ca                        	andl	%ecx, %edx
    5c81: 44 09 da                     	orl	%r11d, %edx
    5c84: 44 01 fa                     	addl	%r15d, %edx
    5c87: 45 89 f3                     	movl	%r14d, %r11d
    5c8a: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5c8e: 44 01 d2                     	addl	%r10d, %edx
    5c91: 45 89 f2                     	movl	%r14d, %r10d
    5c94: 41 c1 c2 15                  	roll	$0x15, %r10d
    5c98: 45 31 da                     	xorl	%r11d, %r10d
    5c9b: 45 89 f3                     	movl	%r14d, %r11d
    5c9e: 41 c1 c3 07                  	roll	$0x7, %r11d
    5ca2: 45 31 d3                     	xorl	%r10d, %r11d
    5ca5: 45 89 ca                     	movl	%r9d, %r10d
    5ca8: 45 31 c2                     	xorl	%r8d, %r10d
    5cab: 45 21 f2                     	andl	%r14d, %r10d
    5cae: 45 31 c2                     	xorl	%r8d, %r10d
    5cb1: 03 5d bc                     	addl	-0x44(%rbp), %ebx
    5cb4: 44 01 d3                     	addl	%r10d, %ebx
    5cb7: 45 8d 9c 1b 08 02 c7 8c      	leal	-0x7338fdf8(%r11,%rbx), %r11d
    5cbf: 41 89 d2                     	movl	%edx, %r10d
    5cc2: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    5cc6: 44 01 d9                     	addl	%r11d, %ecx
    5cc9: 89 d3                        	movl	%edx, %ebx
    5ccb: c1 c3 13                     	roll	$0x13, %ebx
    5cce: 44 31 d3                     	xorl	%r10d, %ebx
    5cd1: 41 89 d7                     	movl	%edx, %r15d
    5cd4: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5cd8: 41 31 df                     	xorl	%ebx, %r15d
    5cdb: 89 f3                        	movl	%esi, %ebx
    5cdd: 09 c3                        	orl	%eax, %ebx
    5cdf: 21 d3                        	andl	%edx, %ebx
    5ce1: 41 89 f2                     	movl	%esi, %r10d
    5ce4: 41 21 c2                     	andl	%eax, %r10d
    5ce7: 41 09 da                     	orl	%ebx, %r10d
    5cea: 45 01 fa                     	addl	%r15d, %r10d
    5ced: 45 01 da                     	addl	%r11d, %r10d
    5cf0: 41 89 cb                     	movl	%ecx, %r11d
    5cf3: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    5cf7: 89 cb                        	movl	%ecx, %ebx
    5cf9: c1 c3 15                     	roll	$0x15, %ebx
    5cfc: 44 31 db                     	xorl	%r11d, %ebx
    5cff: 41 89 cb                     	movl	%ecx, %r11d
    5d02: 41 c1 c3 07                  	roll	$0x7, %r11d
    5d06: 41 31 db                     	xorl	%ebx, %r11d
    5d09: 44 89 f3                     	movl	%r14d, %ebx
    5d0c: 44 31 cb                     	xorl	%r9d, %ebx
    5d0f: 21 cb                        	andl	%ecx, %ebx
    5d11: 44 31 cb                     	xorl	%r9d, %ebx
    5d14: 44 03 45 c0                  	addl	-0x40(%rbp), %r8d
    5d18: 41 01 d8                     	addl	%ebx, %r8d
    5d1b: 47 8d 9c 03 fa ff be 90      	leal	-0x6f410006(%r11,%r8), %r11d
    5d23: 45 89 d0                     	movl	%r10d, %r8d
    5d26: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    5d2a: 44 89 d3                     	movl	%r10d, %ebx
    5d2d: c1 c3 13                     	roll	$0x13, %ebx
    5d30: 44 31 c3                     	xorl	%r8d, %ebx
    5d33: 45 89 d7                     	movl	%r10d, %r15d
    5d36: 41 c1 c7 0a                  	roll	$0xa, %r15d
    5d3a: 41 31 df                     	xorl	%ebx, %r15d
    5d3d: 89 d3                        	movl	%edx, %ebx
    5d3f: 09 f3                        	orl	%esi, %ebx
    5d41: 44 21 d3                     	andl	%r10d, %ebx
    5d44: 41 89 d0                     	movl	%edx, %r8d
    5d47: 41 21 f0                     	andl	%esi, %r8d
    5d4a: 41 09 d8                     	orl	%ebx, %r8d
    5d4d: 45 01 f8                     	addl	%r15d, %r8d
    5d50: 89 cb                        	movl	%ecx, %ebx
    5d52: 44 31 f3                     	xorl	%r14d, %ebx
    5d55: 44 03 4d c4                  	addl	-0x3c(%rbp), %r9d
    5d59: 44 01 d8                     	addl	%r11d, %eax
    5d5c: 21 c3                        	andl	%eax, %ebx
    5d5e: 44 31 f3                     	xorl	%r14d, %ebx
    5d61: 44 01 cb                     	addl	%r9d, %ebx
    5d64: 44 03 75 c8                  	addl	-0x38(%rbp), %r14d
    5d68: 41 89 c1                     	movl	%eax, %r9d
    5d6b: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    5d6f: 41 89 c7                     	movl	%eax, %r15d
    5d72: 41 c1 c7 15                  	roll	$0x15, %r15d
    5d76: 45 31 cf                     	xorl	%r9d, %r15d
    5d79: 41 89 c1                     	movl	%eax, %r9d
    5d7c: 41 c1 c1 07                  	roll	$0x7, %r9d
    5d80: 45 31 f9                     	xorl	%r15d, %r9d
    5d83: 45 8d 8c 19 eb 6c 50 a4      	leal	-0x5baf9315(%r9,%rbx), %r9d
    5d8b: 44 01 ce                     	addl	%r9d, %esi
    5d8e: 89 c3                        	movl	%eax, %ebx
    5d90: 31 cb                        	xorl	%ecx, %ebx
    5d92: 21 f3                        	andl	%esi, %ebx
    5d94: 31 cb                        	xorl	%ecx, %ebx
    5d96: 44 01 f3                     	addl	%r14d, %ebx
    5d99: 41 89 f6                     	movl	%esi, %r14d
    5d9c: 41 89 f7                     	movl	%esi, %r15d
    5d9f: 41 c1 c7 1a                  	roll	$0x1a, %r15d
    5da3: 41 c1 c6 15                  	roll	$0x15, %r14d
    5da7: 45 31 fe                     	xorl	%r15d, %r14d
    5daa: 41 89 f7                     	movl	%esi, %r15d
    5dad: 66 0f 6e c6                  	movd	%esi, %xmm0
    5db1: 41 89 f4                     	movl	%esi, %r12d
    5db4: 41 c1 c7 07                  	roll	$0x7, %r15d
    5db8: 45 31 f7                     	xorl	%r14d, %r15d
    5dbb: 44 89 d6                     	movl	%r10d, %esi
    5dbe: 09 d6                        	orl	%edx, %esi
    5dc0: 41 8d 9c 1f f7 a3 f9 be      	leal	-0x41065c09(%r15,%rbx), %ebx
    5dc8: 45 89 d6                     	movl	%r10d, %r14d
    5dcb: 41 21 d6                     	andl	%edx, %r14d
    5dce: 03 4d cc                     	addl	-0x34(%rbp), %ecx
    5dd1: 01 da                        	addl	%ebx, %edx
    5dd3: 41 31 c4                     	xorl	%eax, %r12d
    5dd6: 41 21 d4                     	andl	%edx, %r12d
    5dd9: 41 31 c4                     	xorl	%eax, %r12d
    5ddc: 41 01 cc                     	addl	%ecx, %r12d
    5ddf: 45 01 d8                     	addl	%r11d, %r8d
    5de2: 44 89 c1                     	movl	%r8d, %ecx
    5de5: c1 c1 1e                     	roll	$0x1e, %ecx
    5de8: 45 89 c3                     	movl	%r8d, %r11d
    5deb: 41 c1 c3 13                  	roll	$0x13, %r11d
    5def: 41 31 cb                     	xorl	%ecx, %r11d
    5df2: 44 89 c1                     	movl	%r8d, %ecx
    5df5: c1 c1 0a                     	roll	$0xa, %ecx
    5df8: 44 31 d9                     	xorl	%r11d, %ecx
    5dfb: 44 21 c6                     	andl	%r8d, %esi
    5dfe: 44 09 f6                     	orl	%r14d, %esi
    5e01: 01 ce                        	addl	%ecx, %esi
    5e03: 89 d1                        	movl	%edx, %ecx
    5e05: 41 89 d3                     	movl	%edx, %r11d
    5e08: 66 0f 6e ca                  	movd	%edx, %xmm1
    5e0c: c1 c2 1a                     	roll	$0x1a, %edx
    5e0f: c1 c1 15                     	roll	$0x15, %ecx
    5e12: 41 c1 c3 07                  	roll	$0x7, %r11d
    5e16: 31 d1                        	xorl	%edx, %ecx
    5e18: 41 31 cb                     	xorl	%ecx, %r11d
    5e1b: 44 89 c2                     	movl	%r8d, %edx
    5e1e: 44 09 d2                     	orl	%r10d, %edx
    5e21: 44 01 ce                     	addl	%r9d, %esi
    5e24: 41 89 f1                     	movl	%esi, %r9d
    5e27: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5e2b: 43 8d 8c 23 f2 78 71 c6      	leal	-0x398e870e(%r11,%r12), %ecx
    5e33: 41 89 f3                     	movl	%esi, %r11d
    5e36: 41 c1 c3 13                  	roll	$0x13, %r11d
    5e3a: 45 31 cb                     	xorl	%r9d, %r11d
    5e3d: 41 89 f1                     	movl	%esi, %r9d
    5e40: 41 c1 c1 0a                  	roll	$0xa, %r9d
    5e44: 45 31 d9                     	xorl	%r11d, %r9d
    5e47: 21 f2                        	andl	%esi, %edx
    5e49: 41 89 f3                     	movl	%esi, %r11d
    5e4c: 45 09 c3                     	orl	%r8d, %r11d
    5e4f: 66 0f 6e d6                  	movd	%esi, %xmm2
    5e53: 44 21 c6                     	andl	%r8d, %esi
    5e56: 66 41 0f 6e d8               	movd	%r8d, %xmm3
    5e5b: 45 21 d0                     	andl	%r10d, %r8d
    5e5e: 44 09 c2                     	orl	%r8d, %edx
    5e61: 44 01 ca                     	addl	%r9d, %edx
    5e64: 01 da                        	addl	%ebx, %edx
    5e66: 41 89 d0                     	movl	%edx, %r8d
    5e69: 41 89 d1                     	movl	%edx, %r9d
    5e6c: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    5e70: 41 c1 c0 13                  	roll	$0x13, %r8d
    5e74: 45 31 c8                     	xorl	%r9d, %r8d
    5e77: 41 21 d3                     	andl	%edx, %r11d
    5e7a: 66 0f 6e e2                  	movd	%edx, %xmm4
    5e7e: c1 c2 0a                     	roll	$0xa, %edx
    5e81: 44 31 c2                     	xorl	%r8d, %edx
    5e84: 44 09 de                     	orl	%r11d, %esi
    5e87: 01 d6                        	addl	%edx, %esi
    5e89: 41 01 ca                     	addl	%ecx, %r10d
    5e8c: 01 ce                        	addl	%ecx, %esi
    5e8e: 66 0f 6e ee                  	movd	%esi, %xmm5
    5e92: 66 41 0f 6e f2               	movd	%r10d, %xmm6
    5e97: 66 0f 62 ec                  	punpckldq	%xmm4, %xmm5    ## xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
    5e9b: 66 0f 62 d3                  	punpckldq	%xmm3, %xmm2    ## xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
    5e9f: 66 0f 6c ea                  	punpcklqdq	%xmm2, %xmm5    ## xmm5 = xmm5[0],xmm2[0]
    5ea3: 66 0f fe 2f                  	paddd	(%rdi), %xmm5
    5ea7: 66 0f 6e d0                  	movd	%eax, %xmm2
    5eab: 66 0f 7f 2f                  	movdqa	%xmm5, (%rdi)
    5eaf: 66 0f 62 f1                  	punpckldq	%xmm1, %xmm6    ## xmm6 = xmm6[0],xmm1[0],xmm6[1],xmm1[1]
    5eb3: 66 0f 62 c2                  	punpckldq	%xmm2, %xmm0    ## xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
    5eb7: 66 0f 6c f0                  	punpcklqdq	%xmm0, %xmm6    ## xmm6 = xmm6[0],xmm0[0]
    5ebb: 66 0f fe 77 10               	paddd	0x10(%rdi), %xmm6
    5ec0: 66 0f 7f 77 10               	movdqa	%xmm6, 0x10(%rdi)
    5ec5: 48 81 c4 88 00 00 00         	addq	$0x88, %rsp
    5ecc: 5b                           	popq	%rbx
    5ecd: 41 5c                        	popq	%r12
    5ecf: 41 5d                        	popq	%r13
    5ed1: 41 5e                        	popq	%r14
    5ed3: 41 5f                        	popq	%r15
    5ed5: 5d                           	popq	%rbp
    5ed6: c3                           	retq
    5ed7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)

0000000000005ee0 <_audit_master256>:
    5ee0: 55                           	pushq	%rbp
    5ee1: 48 89 e5                     	movq	%rsp, %rbp
    5ee4: 41 56                        	pushq	%r14
    5ee6: 53                           	pushq	%rbx
    5ee7: 48 81 ec 50 01 00 00         	subq	$0x150, %rsp            ## imm = 0x150
    5eee: 48 89 f3                     	movq	%rsi, %rbx
    5ef1: 49 89 f8                     	movq	%rdi, %r8
    5ef4: 66 c7 85 c0 fe ff ff 00 20   	movw	$0x2000, -0x140(%rbp)   ## imm = 0x2000
    5efd: c6 85 c2 fe ff ff 0d         	movb	$0xd, -0x13e(%rbp)
    5f04: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    5f0e: 48 89 85 c3 fe ff ff         	movq	%rax, -0x13d(%rbp)
    5f15: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    5f1f: 48 89 85 c8 fe ff ff         	movq	%rax, -0x138(%rbp)
    5f26: c6 85 d0 fe ff ff 20         	movb	$0x20, -0x130(%rbp)
    5f2d: 48 b8 e3 b0 c4 42 98 fc 1c 14	movabsq	$0x141cfc9842c4b0e3, %rax ## imm = 0x141CFC9842C4B0E3
    5f37: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    5f3e: 48 b8 9a fb f4 c8 99 6f b9 24	movabsq	$0x24b96f99c8f4fb9a, %rax ## imm = 0x24B96F99C8F4FB9A
    5f48: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    5f4f: 48 b8 27 ae 41 e4 64 9b 93 4c	movabsq	$0x4c939b64e441ae27, %rax ## imm = 0x4C939B64E441AE27
    5f59: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    5f60: 48 b8 a4 95 99 1b 78 52 b8 55	movabsq	$0x55b852781b9995a4, %rax ## imm = 0x55B852781B9995A4
    5f6a: 48 89 85 e9 fe ff ff         	movq	%rax, -0x117(%rbp)
    5f71: 4c 8d b5 a0 fe ff ff         	leaq	-0x160(%rbp), %r14
    5f78: 48 8d 95 c0 fe ff ff         	leaq	-0x140(%rbp), %rdx
    5f7f: be 20 00 00 00               	movl	$0x20, %esi
    5f84: b9 31 00 00 00               	movl	$0x31, %ecx
    5f89: 4c 89 f7                     	movq	%r14, %rdi
    5f8c: e8 00 00 00 00               	callq	 <L0>
		0000000000005f8d:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    5f91: 48 8d 15 00 00 00 00         	leaq	, %rdx <_audit_master256+0xb8>
		0000000000005f94:  X86_64_RELOC_SIGNED	_memx.Array(32).zero
    5f98: 48 8d 7d d0                  	leaq	-0x30(%rbp), %rdi
    5f9c: 4c 89 f6                     	movq	%r14, %rsi
    5f9f: e8 00 00 00 00               	callq	 <L1>
		0000000000005fa0:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
<L1>:
    5fa4: 48 8b 45 e8                  	movq	-0x18(%rbp), %rax
    5fa8: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    5fac: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    5fb0: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    5fb4: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    5fb8: 48 8b 4d d8                  	movq	-0x28(%rbp), %rcx
    5fbc: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    5fc0: 48 89 03                     	movq	%rax, (%rbx)
    5fc3: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            ## imm = 0x150
    5fca: 5b                           	popq	%rbx
    5fcb: 41 5e                        	popq	%r14
    5fcd: 5d                           	popq	%rbp
    5fce: c3                           	retq
    5fcf: 90                           	nop

0000000000005fd0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
    5fd0: 55                           	pushq	%rbp
    5fd1: 48 89 e5                     	movq	%rsp, %rbp
    5fd4: 41 57                        	pushq	%r15
    5fd6: 41 56                        	pushq	%r14
    5fd8: 41 55                        	pushq	%r13
    5fda: 41 54                        	pushq	%r12
    5fdc: 53                           	pushq	%rbx
    5fdd: 48 81 ec 88 01 00 00         	subq	$0x188, %rsp            ## imm = 0x188
    5fe4: 49 89 d7                     	movq	%rdx, %r15
    5fe7: 48 89 7d 90                  	movq	%rdi, -0x70(%rbp)
    5feb: 48 8b 46 18                  	movq	0x18(%rsi), %rax
    5fef: 48 89 45 b0                  	movq	%rax, -0x50(%rbp)
    5ff3: 48 8b 46 10                  	movq	0x10(%rsi), %rax
    5ff7: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    5ffb: 48 8b 06                     	movq	(%rsi), %rax
    5ffe: 48 8b 4e 08                  	movq	0x8(%rsi), %rcx
    6002: 48 89 4d a0                  	movq	%rcx, -0x60(%rbp)
    6006: 48 89 45 98                  	movq	%rax, -0x68(%rbp)
    600a: 48 c7 45 b8 00 00 00 00      	movq	$0x0, -0x48(%rbp)
    6012: 48 c7 45 c0 00 00 00 00      	movq	$0x0, -0x40(%rbp)
    601a: 48 c7 45 c8 00 00 00 00      	movq	$0x0, -0x38(%rbp)
    6022: 48 c7 45 d0 00 00 00 00      	movq	$0x0, -0x30(%rbp)
    602a: 31 c0                        	xorl	%eax, %eax
    602c: 0f 1f 40 00                  	nopl	(%rax)
<L0>:
    6030: 0f b6 4c 05 98               	movzbl	-0x68(%rbp,%rax), %ecx
    6035: 0f b6 54 05 99               	movzbl	-0x67(%rbp,%rax), %edx
    603a: 80 f1 5c                     	xorb	$0x5c, %cl
    603d: 88 8c 05 c0 fe ff ff         	movb	%cl, -0x140(%rbp,%rax)
    6044: 80 f2 5c                     	xorb	$0x5c, %dl
    6047: 88 94 05 c1 fe ff ff         	movb	%dl, -0x13f(%rbp,%rax)
    604e: 0f b6 4c 05 9a               	movzbl	-0x66(%rbp,%rax), %ecx
    6053: 80 f1 5c                     	xorb	$0x5c, %cl
    6056: 88 8c 05 c2 fe ff ff         	movb	%cl, -0x13e(%rbp,%rax)
    605d: 0f b6 4c 05 9b               	movzbl	-0x65(%rbp,%rax), %ecx
    6062: 80 f1 5c                     	xorb	$0x5c, %cl
    6065: 88 8c 05 c3 fe ff ff         	movb	%cl, -0x13d(%rbp,%rax)
    606c: 48 83 c0 04                  	addq	$0x4, %rax
    6070: 48 83 f8 40                  	cmpq	$0x40, %rax
    6074: 75 ba                        	jne	 <L0>
    6076: b8 03 00 00 00               	movl	$0x3, %eax
    607b: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L1>:
    6080: 0f b6 4c 05 95               	movzbl	-0x6b(%rbp,%rax), %ecx
    6085: 0f b6 54 05 96               	movzbl	-0x6a(%rbp,%rax), %edx
    608a: 80 f1 36                     	xorb	$0x36, %cl
    608d: 88 8c 05 1d ff ff ff         	movb	%cl, -0xe3(%rbp,%rax)
    6094: 80 f2 36                     	xorb	$0x36, %dl
    6097: 88 94 05 1e ff ff ff         	movb	%dl, -0xe2(%rbp,%rax)
    609e: 0f b6 4c 05 97               	movzbl	-0x69(%rbp,%rax), %ecx
    60a3: 80 f1 36                     	xorb	$0x36, %cl
    60a6: 88 8c 05 1f ff ff ff         	movb	%cl, -0xe1(%rbp,%rax)
    60ad: 0f b6 4c 05 98               	movzbl	-0x68(%rbp,%rax), %ecx
    60b2: 80 f1 36                     	xorb	$0x36, %cl
    60b5: 88 8c 05 20 ff ff ff         	movb	%cl, -0xe0(%rbp,%rax)
    60bc: 48 83 c0 04                  	addq	$0x4, %rax
    60c0: 48 83 f8 43                  	cmpq	$0x43, %rax
    60c4: 75 ba                        	jne	 <L1>
    60c6: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x15d>
		00000000000060c9:  X86_64_RELOC_SIGNED	___anon_7525
    60cd: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
    60d4: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x15b>
		00000000000060d7:  X86_64_RELOC_SIGNED	___anon_7525
    60db: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    60e2: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x159>
		00000000000060e5:  X86_64_RELOC_SIGNED	___anon_7525
    60e9: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    60f0: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x157>
		00000000000060f3:  X86_64_RELOC_SIGNED	___anon_7525
    60f7: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    60fe: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x155>
		0000000000006101:  X86_64_RELOC_SIGNED	___anon_7525
    6105: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    610c: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x153>
		000000000000610f:  X86_64_RELOC_SIGNED	___anon_7525
    6113: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    611a: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x151>
		000000000000611d:  X86_64_RELOC_SIGNED	___anon_7525
    6121: 0f 29 85 50 fe ff ff         	movaps	%xmm0, -0x1b0(%rbp)
    6128: 48 8d bd 50 fe ff ff         	leaq	-0x1b0(%rbp), %rdi
    612f: 48 8d b5 20 ff ff ff         	leaq	-0xe0(%rbp), %rsi
    6136: e8 00 00 00 00               	callq	 <L2>
		0000000000006137:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L2>:
    613b: 48 8b 9d 70 fe ff ff         	movq	-0x190(%rbp), %rbx
    6142: 48 83 c3 40                  	addq	$0x40, %rbx
    6146: 48 89 9d 70 fe ff ff         	movq	%rbx, -0x190(%rbp)
    614d: 0f b6 85 b8 fe ff ff         	movzbl	-0x148(%rbp), %eax
    6154: 48 85 c0                     	testq	%rax, %rax
    6157: 74 48                        	je	 <L5>
    6159: 3c 20                        	cmpb	$0x20, %al
    615b: 72 46                        	jb	 <L6>
    615d: 41 bd 40 00 00 00            	movl	$0x40, %r13d
    6163: 49 29 c5                     	subq	%rax, %r13
    6166: 4c 8d a5 78 fe ff ff         	leaq	-0x188(%rbp), %r12
    616d: 48 8d bc 05 78 fe ff ff      	leaq	-0x188(%rbp,%rax), %rdi
    6175: 4c 89 fe                     	movq	%r15, %rsi
    6178: 4c 89 ea                     	movq	%r13, %rdx
    617b: e8 00 00 00 00               	callq	 <L3>
		000000000000617c:  X86_64_RELOC_BRANCH	_memcpy
<L3>:
    6180: 48 8d bd 50 fe ff ff         	leaq	-0x1b0(%rbp), %rdi
    6187: 4c 89 e6                     	movq	%r12, %rsi
    618a: e8 00 00 00 00               	callq	 <L4>
		000000000000618b:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L4>:
    618f: c6 85 b8 fe ff ff 00         	movb	$0x0, -0x148(%rbp)
    6196: 31 c0                        	xorl	%eax, %eax
    6198: 48 8b 9d 70 fe ff ff         	movq	-0x190(%rbp), %rbx
    619f: eb 05                        	jmp	 <L7>
<L5>:
    61a1: 31 c0                        	xorl	%eax, %eax
<L6>:
    61a3: 45 31 ed                     	xorl	%r13d, %r13d
<L7>:
    61a6: 4d 01 ef                     	addq	%r13, %r15
    61a9: 41 bc 20 00 00 00            	movl	$0x20, %r12d
    61af: 41 be 20 00 00 00            	movl	$0x20, %r14d
    61b5: 4d 29 ee                     	subq	%r13, %r14
    61b8: 0f b6 c0                     	movzbl	%al, %eax
    61bb: 48 8d bc 05 78 fe ff ff      	leaq	-0x188(%rbp,%rax), %rdi
    61c3: 4c 89 fe                     	movq	%r15, %rsi
    61c6: 4c 89 f2                     	movq	%r14, %rdx
    61c9: e8 00 00 00 00               	callq	 <L8>
		00000000000061ca:  X86_64_RELOC_BRANCH	_memcpy
<L8>:
    61ce: 44 00 b5 b8 fe ff ff         	addb	%r14b, -0x148(%rbp)
    61d5: 48 83 c3 20                  	addq	$0x20, %rbx
    61d9: 48 89 9d 70 fe ff ff         	movq	%rbx, -0x190(%rbp)
    61e0: 48 8d bd 50 fe ff ff         	leaq	-0x1b0(%rbp), %rdi
    61e7: 48 8d 75 98                  	leaq	-0x68(%rbp), %rsi
    61eb: e8 00 00 00 00               	callq	 <L9>
		00000000000061ec:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L9>:
    61f0: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x287>
		00000000000061f3:  X86_64_RELOC_SIGNED	___anon_7525
    61f7: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    61fb: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x282>
		00000000000061fe:  X86_64_RELOC_SIGNED	___anon_7525
    6202: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    6209: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x280>
		000000000000620c:  X86_64_RELOC_SIGNED	___anon_7525
    6210: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    6217: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x27e>
		000000000000621a:  X86_64_RELOC_SIGNED	___anon_7525
    621e: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    6225: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x27c>
		0000000000006228:  X86_64_RELOC_SIGNED	___anon_7525
    622c: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    6233: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x27a>
		0000000000006236:  X86_64_RELOC_SIGNED	___anon_7525
    623a: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    6241: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x278>
		0000000000006244:  X86_64_RELOC_SIGNED	___anon_7525
    6248: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    624f: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    6256: 48 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %rsi
    625d: e8 00 00 00 00               	callq	 <L10>
		000000000000625e:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L10>:
    6262: 0f b6 7d 88                  	movzbl	-0x78(%rbp), %edi
    6266: 48 8b 9d 40 ff ff ff         	movq	-0xc0(%rbp), %rbx
    626d: 48 83 c3 40                  	addq	$0x40, %rbx
    6271: 4c 8d b5 48 ff ff ff         	leaq	-0xb8(%rbp), %r14
    6278: 48 89 9d 40 ff ff ff         	movq	%rbx, -0xc0(%rbp)
    627f: 48 85 ff                     	testq	%rdi, %rdi
    6282: 74 3c                        	je	 <L13>
    6284: 40 80 ff 20                  	cmpb	$0x20, %dil
    6288: 72 38                        	jb	 <L14>
    628a: 41 bf 40 00 00 00            	movl	$0x40, %r15d
    6290: 49 29 ff                     	subq	%rdi, %r15
    6293: 4c 01 f7                     	addq	%r14, %rdi
    6296: 48 8d 75 98                  	leaq	-0x68(%rbp), %rsi
    629a: 4c 89 fa                     	movq	%r15, %rdx
    629d: e8 00 00 00 00               	callq	 <L11>
		000000000000629e:  X86_64_RELOC_BRANCH	_memcpy
<L11>:
    62a2: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    62a9: 4c 89 f6                     	movq	%r14, %rsi
    62ac: e8 00 00 00 00               	callq	 <L12>
		00000000000062ad:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L12>:
    62b1: c6 45 88 00                  	movb	$0x0, -0x78(%rbp)
    62b5: 31 ff                        	xorl	%edi, %edi
    62b7: 48 8b 9d 40 ff ff ff         	movq	-0xc0(%rbp), %rbx
    62be: eb 05                        	jmp	 <L15>
<L13>:
    62c0: 31 ff                        	xorl	%edi, %edi
<L14>:
    62c2: 45 31 ff                     	xorl	%r15d, %r15d
<L15>:
    62c5: 4a 8d 74 3d 98               	leaq	-0x68(%rbp,%r15), %rsi
    62ca: 4d 29 fc                     	subq	%r15, %r12
    62cd: 40 0f b6 c7                  	movzbl	%dil, %eax
    62d1: 49 01 c6                     	addq	%rax, %r14
    62d4: 4c 89 f7                     	movq	%r14, %rdi
    62d7: 4c 89 e2                     	movq	%r12, %rdx
    62da: e8 00 00 00 00               	callq	 <L16>
		00000000000062db:  X86_64_RELOC_BRANCH	_memcpy
<L16>:
    62df: 44 00 65 88                  	addb	%r12b, -0x78(%rbp)
    62e3: 48 83 c3 20                  	addq	$0x20, %rbx
    62e7: 48 89 9d 40 ff ff ff         	movq	%rbx, -0xc0(%rbp)
    62ee: 48 8d bd 20 ff ff ff         	leaq	-0xe0(%rbp), %rdi
    62f5: 48 8d b5 00 ff ff ff         	leaq	-0x100(%rbp), %rsi
    62fc: e8 00 00 00 00               	callq	 <L17>
		00000000000062fd:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L17>:
    6301: 48 8b 85 18 ff ff ff         	movq	-0xe8(%rbp), %rax
    6308: 48 8b 55 90                  	movq	-0x70(%rbp), %rdx
    630c: 48 89 42 18                  	movq	%rax, 0x18(%rdx)
    6310: 48 8b 85 10 ff ff ff         	movq	-0xf0(%rbp), %rax
    6317: 48 89 42 10                  	movq	%rax, 0x10(%rdx)
    631b: 48 8b 85 00 ff ff ff         	movq	-0x100(%rbp), %rax
    6322: 48 8b 8d 08 ff ff ff         	movq	-0xf8(%rbp), %rcx
    6329: 48 89 4a 08                  	movq	%rcx, 0x8(%rdx)
    632d: 48 89 02                     	movq	%rax, (%rdx)
    6330: 48 81 c4 88 01 00 00         	addq	$0x188, %rsp            ## imm = 0x188
    6337: 5b                           	popq	%rbx
    6338: 41 5c                        	popq	%r12
    633a: 41 5d                        	popq	%r13
    633c: 41 5e                        	popq	%r14
    633e: 41 5f                        	popq	%r15
    6340: 5d                           	popq	%rbp
    6341: c3                           	retq
    6342: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    634c: 0f 1f 40 00                  	nopl	(%rax)

0000000000006350 <_audit_handshake256>:
    6350: 55                           	pushq	%rbp
    6351: 48 89 e5                     	movq	%rsp, %rbp
    6354: 41 57                        	pushq	%r15
    6356: 41 56                        	pushq	%r14
    6358: 53                           	pushq	%rbx
    6359: 48 81 ec 58 01 00 00         	subq	$0x158, %rsp            ## imm = 0x158
    6360: 48 89 d3                     	movq	%rdx, %rbx
    6363: 49 89 f6                     	movq	%rsi, %r14
    6366: 49 89 f8                     	movq	%rdi, %r8
    6369: 66 c7 85 b8 fe ff ff 00 20   	movw	$0x2000, -0x148(%rbp)   ## imm = 0x2000
    6372: c6 85 ba fe ff ff 0d         	movb	$0xd, -0x146(%rbp)
    6379: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    6383: 48 89 85 bb fe ff ff         	movq	%rax, -0x145(%rbp)
    638a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    6394: 48 89 85 c0 fe ff ff         	movq	%rax, -0x140(%rbp)
    639b: c6 85 c8 fe ff ff 20         	movb	$0x20, -0x138(%rbp)
    63a2: 48 b8 e3 b0 c4 42 98 fc 1c 14	movabsq	$0x141cfc9842c4b0e3, %rax ## imm = 0x141CFC9842C4B0E3
    63ac: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
    63b3: 48 b8 9a fb f4 c8 99 6f b9 24	movabsq	$0x24b96f99c8f4fb9a, %rax ## imm = 0x24B96F99C8F4FB9A
    63bd: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    63c4: 48 b8 27 ae 41 e4 64 9b 93 4c	movabsq	$0x4c939b64e441ae27, %rax ## imm = 0x4C939B64E441AE27
    63ce: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    63d5: 48 b8 a4 95 99 1b 78 52 b8 55	movabsq	$0x55b852781b9995a4, %rax ## imm = 0x55B852781B9995A4
    63df: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    63e6: 4c 8d bd 98 fe ff ff         	leaq	-0x168(%rbp), %r15
    63ed: 48 8d 95 b8 fe ff ff         	leaq	-0x148(%rbp), %rdx
    63f4: be 20 00 00 00               	movl	$0x20, %esi
    63f9: b9 31 00 00 00               	movl	$0x31, %ecx
    63fe: 4c 89 ff                     	movq	%r15, %rdi
    6401: e8 00 00 00 00               	callq	 <L0>
		0000000000006402:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    6406: 48 8d 7d c8                  	leaq	-0x38(%rbp), %rdi
    640a: 4c 89 fe                     	movq	%r15, %rsi
    640d: 4c 89 f2                     	movq	%r14, %rdx
    6410: e8 00 00 00 00               	callq	 <L1>
		0000000000006411:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
<L1>:
    6415: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    6419: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    641d: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    6421: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    6425: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
    6429: 48 8b 4d d0                  	movq	-0x30(%rbp), %rcx
    642d: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    6431: 48 89 03                     	movq	%rax, (%rbx)
    6434: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            ## imm = 0x158
    643b: 5b                           	popq	%rbx
    643c: 41 5e                        	popq	%r14
    643e: 41 5f                        	popq	%r15
    6440: 5d                           	popq	%rbp
    6441: c3                           	retq
