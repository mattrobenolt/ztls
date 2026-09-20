
/tmp/ztls-signoff-20260919/125-before-6d73a0a/015-x86_64-macos.o:	file format mach-o 64-bit x86-64

Disassembly of section __TEXT,__text:

0000000000000000 <_audit_handshake256>:
       0: 55                           	pushq	%rbp
       1: 48 89 e5                     	movq	%rsp, %rbp
       4: 41 57                        	pushq	%r15
       6: 41 56                        	pushq	%r14
       8: 53                           	pushq	%rbx
       9: 48 81 ec 58 01 00 00         	subq	$0x158, %rsp            ## imm = 0x158
      10: 48 89 d3                     	movq	%rdx, %rbx
      13: 49 89 f6                     	movq	%rsi, %r14
      16: 49 89 f8                     	movq	%rdi, %r8
      19: 66 c7 85 b8 fe ff ff 00 20   	movw	$0x2000, -0x148(%rbp)   ## imm = 0x2000
      22: c6 85 ba fe ff ff 0d         	movb	$0xd, -0x146(%rbp)
      29: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
      33: 48 89 85 bb fe ff ff         	movq	%rax, -0x145(%rbp)
      3a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
      44: 48 89 85 c0 fe ff ff         	movq	%rax, -0x140(%rbp)
      4b: c6 85 c8 fe ff ff 20         	movb	$0x20, -0x138(%rbp)
      52: 48 b8 e3 b0 c4 42 98 fc 1c 14	movabsq	$0x141cfc9842c4b0e3, %rax ## imm = 0x141CFC9842C4B0E3
      5c: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
      63: 48 b8 9a fb f4 c8 99 6f b9 24	movabsq	$0x24b96f99c8f4fb9a, %rax ## imm = 0x24B96F99C8F4FB9A
      6d: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
      74: 48 b8 27 ae 41 e4 64 9b 93 4c	movabsq	$0x4c939b64e441ae27, %rax ## imm = 0x4C939B64E441AE27
      7e: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
      85: 48 b8 a4 95 99 1b 78 52 b8 55	movabsq	$0x55b852781b9995a4, %rax ## imm = 0x55B852781B9995A4
      8f: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
      96: 4c 8d bd 98 fe ff ff         	leaq	-0x168(%rbp), %r15
      9d: 48 8d 95 b8 fe ff ff         	leaq	-0x148(%rbp), %rdx
      a4: be 20 00 00 00               	movl	$0x20, %esi
      a9: b9 31 00 00 00               	movl	$0x31, %ecx
      ae: 4c 89 ff                     	movq	%r15, %rdi
      b1: e8 00 00 00 00               	callq	 <L0>
		00000000000000b2:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
      b6: 48 8d 7d c8                  	leaq	-0x38(%rbp), %rdi
      ba: 4c 89 fe                     	movq	%r15, %rsi
      bd: 4c 89 f2                     	movq	%r14, %rdx
      c0: e8 00 00 00 00               	callq	 <L1>
		00000000000000c1:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
<L1>:
      c5: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
      c9: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
      cd: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
      d1: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
      d5: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
      d9: 48 8b 4d d0                  	movq	-0x30(%rbp), %rcx
      dd: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
      e1: 48 89 03                     	movq	%rax, (%rbx)
      e4: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            ## imm = 0x158
      eb: 5b                           	popq	%rbx
      ec: 41 5e                        	popq	%r14
      ee: 41 5f                        	popq	%r15
      f0: 5d                           	popq	%rbp
      f1: c3                           	retq
      f2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
      fc: 0f 1f 40 00                  	nopl	(%rax)

0000000000000100 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract>:
     100: 55                           	pushq	%rbp
     101: 48 89 e5                     	movq	%rsp, %rbp
     104: 41 57                        	pushq	%r15
     106: 41 56                        	pushq	%r14
     108: 41 55                        	pushq	%r13
     10a: 41 54                        	pushq	%r12
     10c: 53                           	pushq	%rbx
     10d: 48 81 ec 68 01 00 00         	subq	$0x168, %rsp            ## imm = 0x168
     114: 49 89 d7                     	movq	%rdx, %r15
     117: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
     11b: 0f 10 06                     	movups	(%rsi), %xmm0
     11e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
     122: 0f 28 15 77 5f 00 00         	movaps	, %xmm2 <_audit_key384+0x60>
		0000000000000125:  X86_64_RELOC_SIGNED	__literal16
     129: 0f 28 d8                     	movaps	%xmm0, %xmm3
     12c: 0f 57 da                     	xorps	%xmm2, %xmm3
     12f: 0f 28 e1                     	movaps	%xmm1, %xmm4
     132: 0f 57 e2                     	xorps	%xmm2, %xmm4
     135: 0f 29 9d 00 ff ff ff         	movaps	%xmm3, -0x100(%rbp)
     13c: 0f 29 a5 10 ff ff ff         	movaps	%xmm4, -0xf0(%rbp)
     143: 0f 29 95 20 ff ff ff         	movaps	%xmm2, -0xe0(%rbp)
     14a: 0f 29 95 30 ff ff ff         	movaps	%xmm2, -0xd0(%rbp)
     151: 0f 28 15 58 5f 00 00         	movaps	, %xmm2 <_audit_key384+0x70>
		0000000000000154:  X86_64_RELOC_SIGNED	__literal16
     158: 0f 57 c2                     	xorps	%xmm2, %xmm0
     15b: 0f 57 ca                     	xorps	%xmm2, %xmm1
     15e: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     165: 0f 29 8d 70 ff ff ff         	movaps	%xmm1, -0x90(%rbp)
     16c: 0f 29 55 80                  	movaps	%xmm2, -0x80(%rbp)
     170: 0f 29 55 90                  	movaps	%xmm2, -0x70(%rbp)
     174: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x7b>
		0000000000000177:  X86_64_RELOC_SIGNED	l___unnamed_1
     17b: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
     182: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x99>
		0000000000000185:  X86_64_RELOC_SIGNED	l___unnamed_1
     189: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
     190: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xb7>
		0000000000000193:  X86_64_RELOC_SIGNED	l___unnamed_1
     197: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
     19e: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xd5>
		00000000000001a1:  X86_64_RELOC_SIGNED	l___unnamed_1
     1a5: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
     1ac: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0xf3>
		00000000000001af:  X86_64_RELOC_SIGNED	l___unnamed_1
     1b3: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
     1ba: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x111>
		00000000000001bd:  X86_64_RELOC_SIGNED	l___unnamed_1
     1c1: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
     1c8: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x12f>
		00000000000001cb:  X86_64_RELOC_SIGNED	l___unnamed_1
     1cf: 0f 29 85 f0 fe ff ff         	movaps	%xmm0, -0x110(%rbp)
     1d6: 48 8d bd 90 fe ff ff         	leaq	-0x170(%rbp), %rdi
     1dd: 48 8d b5 60 ff ff ff         	leaq	-0xa0(%rbp), %rsi
     1e4: e8 00 00 00 00               	callq	 <L0>
		00000000000001e5:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L0>:
     1e9: 48 8b 9d b0 fe ff ff         	movq	-0x150(%rbp), %rbx
     1f0: 48 83 c3 40                  	addq	$0x40, %rbx
     1f4: 48 89 9d b0 fe ff ff         	movq	%rbx, -0x150(%rbp)
     1fb: 0f b6 85 f8 fe ff ff         	movzbl	-0x108(%rbp), %eax
     202: 48 85 c0                     	testq	%rax, %rax
     205: 74 48                        	je	 <L3>
     207: 3c 20                        	cmpb	$0x20, %al
     209: 72 46                        	jb	 <L4>
     20b: 41 bd 40 00 00 00            	movl	$0x40, %r13d
     211: 49 29 c5                     	subq	%rax, %r13
     214: 4c 8d a5 b8 fe ff ff         	leaq	-0x148(%rbp), %r12
     21b: 48 8d bc 05 b8 fe ff ff      	leaq	-0x148(%rbp,%rax), %rdi
     223: 4c 89 fe                     	movq	%r15, %rsi
     226: 4c 89 ea                     	movq	%r13, %rdx
     229: e8 00 00 00 00               	callq	 <L1>
		000000000000022a:  X86_64_RELOC_BRANCH	_memcpy
<L1>:
     22e: 48 8d bd 90 fe ff ff         	leaq	-0x170(%rbp), %rdi
     235: 4c 89 e6                     	movq	%r12, %rsi
     238: e8 00 00 00 00               	callq	 <L2>
		0000000000000239:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L2>:
     23d: c6 85 f8 fe ff ff 00         	movb	$0x0, -0x108(%rbp)
     244: 31 c0                        	xorl	%eax, %eax
     246: 48 8b 9d b0 fe ff ff         	movq	-0x150(%rbp), %rbx
     24d: eb 05                        	jmp	 <L5>
<L3>:
     24f: 31 c0                        	xorl	%eax, %eax
<L4>:
     251: 45 31 ed                     	xorl	%r13d, %r13d
<L5>:
     254: 4d 01 ef                     	addq	%r13, %r15
     257: 41 bc 20 00 00 00            	movl	$0x20, %r12d
     25d: 41 be 20 00 00 00            	movl	$0x20, %r14d
     263: 4d 29 ee                     	subq	%r13, %r14
     266: 0f b6 c0                     	movzbl	%al, %eax
     269: 48 8d bc 05 b8 fe ff ff      	leaq	-0x148(%rbp,%rax), %rdi
     271: 4c 89 fe                     	movq	%r15, %rsi
     274: 4c 89 f2                     	movq	%r14, %rdx
     277: e8 00 00 00 00               	callq	 <L6>
		0000000000000278:  X86_64_RELOC_BRANCH	_memcpy
<L6>:
     27c: 44 00 b5 f8 fe ff ff         	addb	%r14b, -0x108(%rbp)
     283: 48 83 c3 20                  	addq	$0x20, %rbx
     287: 48 89 9d b0 fe ff ff         	movq	%rbx, -0x150(%rbp)
     28e: 48 8d bd 90 fe ff ff         	leaq	-0x170(%rbp), %rdi
     295: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
     29c: e8 00 00 00 00               	callq	 <L7>
		000000000000029d:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L7>:
     2a1: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x208>
		00000000000002a4:  X86_64_RELOC_SIGNED	l___unnamed_1
     2a8: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
     2ac: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x203>
		00000000000002af:  X86_64_RELOC_SIGNED	l___unnamed_1
     2b3: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     2b7: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1fe>
		00000000000002ba:  X86_64_RELOC_SIGNED	l___unnamed_1
     2be: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     2c2: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1f9>
		00000000000002c5:  X86_64_RELOC_SIGNED	l___unnamed_1
     2c9: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     2cd: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1f4>
		00000000000002d0:  X86_64_RELOC_SIGNED	l___unnamed_1
     2d4: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     2d8: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1ef>
		00000000000002db:  X86_64_RELOC_SIGNED	l___unnamed_1
     2df: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     2e6: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract+0x1ed>
		00000000000002e9:  X86_64_RELOC_SIGNED	l___unnamed_1
     2ed: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     2f4: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     2fb: 48 8d b5 00 ff ff ff         	leaq	-0x100(%rbp), %rsi
     302: e8 00 00 00 00               	callq	 <L8>
		0000000000000303:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L8>:
     307: 0f b6 7d c8                  	movzbl	-0x38(%rbp), %edi
     30b: 48 8b 5d 80                  	movq	-0x80(%rbp), %rbx
     30f: 48 83 c3 40                  	addq	$0x40, %rbx
     313: 4c 8d 75 88                  	leaq	-0x78(%rbp), %r14
     317: 48 89 5d 80                  	movq	%rbx, -0x80(%rbp)
     31b: 48 85 ff                     	testq	%rdi, %rdi
     31e: 74 3c                        	je	 <L11>
     320: 40 80 ff 20                  	cmpb	$0x20, %dil
     324: 72 38                        	jb	 <L12>
     326: 41 bf 40 00 00 00            	movl	$0x40, %r15d
     32c: 49 29 ff                     	subq	%rdi, %r15
     32f: 4c 01 f7                     	addq	%r14, %rdi
     332: 48 8d b5 70 fe ff ff         	leaq	-0x190(%rbp), %rsi
     339: 4c 89 fa                     	movq	%r15, %rdx
     33c: e8 00 00 00 00               	callq	 <L9>
		000000000000033d:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
     341: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     348: 4c 89 f6                     	movq	%r14, %rsi
     34b: e8 00 00 00 00               	callq	 <L10>
		000000000000034c:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L10>:
     350: c6 45 c8 00                  	movb	$0x0, -0x38(%rbp)
     354: 31 ff                        	xorl	%edi, %edi
     356: 48 8b 5d 80                  	movq	-0x80(%rbp), %rbx
     35a: eb 05                        	jmp	 <L13>
<L11>:
     35c: 31 ff                        	xorl	%edi, %edi
<L12>:
     35e: 45 31 ff                     	xorl	%r15d, %r15d
<L13>:
     361: 4a 8d b4 3d 70 fe ff ff      	leaq	-0x190(%rbp,%r15), %rsi
     369: 4d 29 fc                     	subq	%r15, %r12
     36c: 40 0f b6 c7                  	movzbl	%dil, %eax
     370: 49 01 c6                     	addq	%rax, %r14
     373: 4c 89 f7                     	movq	%r14, %rdi
     376: 4c 89 e2                     	movq	%r12, %rdx
     379: e8 00 00 00 00               	callq	 <L14>
		000000000000037a:  X86_64_RELOC_BRANCH	_memcpy
<L14>:
     37e: 44 00 65 c8                  	addb	%r12b, -0x38(%rbp)
     382: 48 83 c3 20                  	addq	$0x20, %rbx
     386: 48 89 5d 80                  	movq	%rbx, -0x80(%rbp)
     38a: 48 8d bd 60 ff ff ff         	leaq	-0xa0(%rbp), %rdi
     391: 48 8d b5 40 ff ff ff         	leaq	-0xc0(%rbp), %rsi
     398: e8 00 00 00 00               	callq	 <L15>
		0000000000000399:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L15>:
     39d: 48 8b 85 58 ff ff ff         	movq	-0xa8(%rbp), %rax
     3a4: 48 8b 55 d0                  	movq	-0x30(%rbp), %rdx
     3a8: 48 89 42 18                  	movq	%rax, 0x18(%rdx)
     3ac: 48 8b 85 50 ff ff ff         	movq	-0xb0(%rbp), %rax
     3b3: 48 89 42 10                  	movq	%rax, 0x10(%rdx)
     3b7: 48 8b 85 40 ff ff ff         	movq	-0xc0(%rbp), %rax
     3be: 48 8b 8d 48 ff ff ff         	movq	-0xb8(%rbp), %rcx
     3c5: 48 89 4a 08                  	movq	%rcx, 0x8(%rdx)
     3c9: 48 89 02                     	movq	%rax, (%rdx)
     3cc: 48 81 c4 68 01 00 00         	addq	$0x168, %rsp            ## imm = 0x168
     3d3: 5b                           	popq	%rbx
     3d4: 41 5c                        	popq	%r12
     3d6: 41 5d                        	popq	%r13
     3d8: 41 5e                        	popq	%r14
     3da: 41 5f                        	popq	%r15
     3dc: 5d                           	popq	%rbp
     3dd: c3                           	retq
     3de: 66 90                        	nop

00000000000003e0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand>:
     3e0: 55                           	pushq	%rbp
     3e1: 48 89 e5                     	movq	%rsp, %rbp
     3e4: 41 57                        	pushq	%r15
     3e6: 41 56                        	pushq	%r14
     3e8: 41 55                        	pushq	%r13
     3ea: 41 54                        	pushq	%r12
     3ec: 53                           	pushq	%rbx
     3ed: 48 81 ec 68 02 00 00         	subq	$0x268, %rsp            ## imm = 0x268
     3f4: 49 89 cd                     	movq	%rcx, %r13
     3f7: 49 89 d4                     	movq	%rdx, %r12
     3fa: 48 89 f3                     	movq	%rsi, %rbx
     3fd: 49 89 fe                     	movq	%rdi, %r14
     400: 41 0f 10 18                  	movups	(%r8), %xmm3
     404: 41 0f 10 60 10               	movups	0x10(%r8), %xmm4
     409: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
     40d: 48 83 fe 20                  	cmpq	$0x20, %rsi
     411: 73 1d                        	jae	 <L0>
     413: 48 c7 85 40 ff ff ff 00 00 00 00     	movq	$0x0, -0xc0(%rbp)
     41e: 48 89 d8                     	movq	%rbx, %rax
     421: 48 83 e0 1f                  	andq	$0x1f, %rax
     425: 0f 85 87 03 00 00            	jne	 <L23>
     42b: e9 48 07 00 00               	jmp	 <L54>
<L0>:
     430: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
     437: 0f 29 9d 90 fd ff ff         	movaps	%xmm3, -0x270(%rbp)
     43e: 4c 89 65 c8                  	movq	%r12, -0x38(%rbp)
     442: 4c 8d a5 d8 fd ff ff         	leaq	-0x228(%rbp), %r12
     449: 41 0f 10 00                  	movups	(%r8), %xmm0
     44d: 41 0f 10 48 10               	movups	0x10(%r8), %xmm1
     452: 0f 28 15 67 5c 00 00         	movaps	, %xmm2 <_audit_key384+0x80>
		0000000000000455:  X86_64_RELOC_SIGNED	__literal16
     459: 0f 28 d8                     	movaps	%xmm0, %xmm3
     45c: 0f 57 da                     	xorps	%xmm2, %xmm3
     45f: 0f 28 e1                     	movaps	%xmm1, %xmm4
     462: 0f 57 e2                     	xorps	%xmm2, %xmm4
     465: 0f 29 9d 20 fe ff ff         	movaps	%xmm3, -0x1e0(%rbp)
     46c: 0f 29 a5 30 fe ff ff         	movaps	%xmm4, -0x1d0(%rbp)
     473: 0f 29 95 40 fe ff ff         	movaps	%xmm2, -0x1c0(%rbp)
     47a: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
     481: 0f 28 15 48 5c 00 00         	movaps	, %xmm2 <_audit_key384+0x90>
		0000000000000484:  X86_64_RELOC_SIGNED	__literal16
     488: 0f 57 c2                     	xorps	%xmm2, %xmm0
     48b: 0f 57 ca                     	xorps	%xmm2, %xmm1
     48e: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     495: 0f 29 8d 60 ff ff ff         	movaps	%xmm1, -0xa0(%rbp)
     49c: 0f 29 95 70 ff ff ff         	movaps	%xmm2, -0x90(%rbp)
     4a3: 0f 29 55 80                  	movaps	%xmm2, -0x80(%rbp)
     4a7: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xce>
		00000000000004aa:  X86_64_RELOC_SIGNED	l___unnamed_1
     4ae: 0f 29 85 b0 fd ff ff         	movaps	%xmm0, -0x250(%rbp)
     4b5: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0xec>
		00000000000004b8:  X86_64_RELOC_SIGNED	l___unnamed_1
     4bc: 0f 29 85 c0 fd ff ff         	movaps	%xmm0, -0x240(%rbp)
     4c3: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x10a>
		00000000000004c6:  X86_64_RELOC_SIGNED	l___unnamed_1
     4ca: 0f 29 85 d0 fd ff ff         	movaps	%xmm0, -0x230(%rbp)
     4d1: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x128>
		00000000000004d4:  X86_64_RELOC_SIGNED	l___unnamed_1
     4d8: 0f 29 85 e0 fd ff ff         	movaps	%xmm0, -0x220(%rbp)
     4df: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x146>
		00000000000004e2:  X86_64_RELOC_SIGNED	l___unnamed_1
     4e6: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
     4ed: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x164>
		00000000000004f0:  X86_64_RELOC_SIGNED	l___unnamed_1
     4f4: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
     4fb: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x182>
		00000000000004fe:  X86_64_RELOC_SIGNED	l___unnamed_1
     502: 0f 29 85 10 fe ff ff         	movaps	%xmm0, -0x1f0(%rbp)
     509: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     510: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
     517: e8 00 00 00 00               	callq	 <L1>
		0000000000000518:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L1>:
     51c: 48 83 85 d0 fd ff ff 40      	addq	$0x40, -0x230(%rbp)
     524: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
     52b: 48 85 ff                     	testq	%rdi, %rdi
     52e: 4c 89 b5 48 ff ff ff         	movq	%r14, -0xb8(%rbp)
     535: 48 89 9d 38 ff ff ff         	movq	%rbx, -0xc8(%rbp)
     53c: 74 3d                        	je	 <L4>
     53e: 4c 89 e8                     	movq	%r13, %rax
     541: 48 83 f0 3f                  	xorq	$0x3f, %rax
     545: 48 39 f8                     	cmpq	%rdi, %rax
     548: 73 33                        	jae	 <L5>
     54a: bb 40 00 00 00               	movl	$0x40, %ebx
     54f: 48 29 fb                     	subq	%rdi, %rbx
     552: 4c 01 e7                     	addq	%r12, %rdi
     555: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
     559: 48 89 da                     	movq	%rbx, %rdx
     55c: e8 00 00 00 00               	callq	 <L2>
		000000000000055d:  X86_64_RELOC_BRANCH	_memcpy
<L2>:
     561: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     568: 4c 89 e6                     	movq	%r12, %rsi
     56b: e8 00 00 00 00               	callq	 <L3>
		000000000000056c:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L3>:
     570: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
     577: 31 ff                        	xorl	%edi, %edi
     579: eb 04                        	jmp	 <L6>
<L4>:
     57b: 31 ff                        	xorl	%edi, %edi
<L5>:
     57d: 31 db                        	xorl	%ebx, %ebx
<L6>:
     57f: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
     583: 48 8d 34 18                  	leaq	(%rax,%rbx), %rsi
     587: 4d 89 ef                     	movq	%r13, %r15
     58a: 49 29 df                     	subq	%rbx, %r15
     58d: 40 0f b6 ff                  	movzbl	%dil, %edi
     591: 4c 01 e7                     	addq	%r12, %rdi
     594: 4c 89 fa                     	movq	%r15, %rdx
     597: e8 00 00 00 00               	callq	 <L7>
		0000000000000598:  X86_64_RELOC_BRANCH	_memcpy
<L7>:
     59c: 0f b6 bd 18 fe ff ff         	movzbl	-0x1e8(%rbp), %edi
     5a3: 4c 01 ff                     	addq	%r15, %rdi
     5a6: 40 88 bd 18 fe ff ff         	movb	%dil, -0x1e8(%rbp)
     5ad: 4c 8b b5 d0 fd ff ff         	movq	-0x230(%rbp), %r14
     5b4: 4d 01 ee                     	addq	%r13, %r14
     5b7: 4c 89 b5 d0 fd ff ff         	movq	%r14, -0x230(%rbp)
     5be: 40 84 ff                     	testb	%dil, %dil
     5c1: 4c 89 ad 30 ff ff ff         	movq	%r13, -0xd0(%rbp)
     5c8: 74 3f                        	je	 <L10>
     5ca: 40 80 ff 3f                  	cmpb	$0x3f, %dil
     5ce: 72 3b                        	jb	 <L11>
     5d0: b0 40                        	movb	$0x40, %al
     5d2: 40 28 f8                     	subb	%dil, %al
     5d5: 44 0f b6 f8                  	movzbl	%al, %r15d
     5d9: 4c 01 e7                     	addq	%r12, %rdi
     5dc: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     5e0: 4c 89 fa                     	movq	%r15, %rdx
     5e3: e8 00 00 00 00               	callq	 <L8>
		00000000000005e4:  X86_64_RELOC_BRANCH	_memcpy
<L8>:
     5e8: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     5ef: 4c 89 e6                     	movq	%r12, %rsi
     5f2: e8 00 00 00 00               	callq	 <L9>
		00000000000005f3:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L9>:
     5f7: c6 85 18 fe ff ff 00         	movb	$0x0, -0x1e8(%rbp)
     5fe: 31 ff                        	xorl	%edi, %edi
     600: 4c 8b b5 d0 fd ff ff         	movq	-0x230(%rbp), %r14
     607: eb 05                        	jmp	 <L12>
<L10>:
     609: 31 ff                        	xorl	%edi, %edi
<L11>:
     60b: 45 31 ff                     	xorl	%r15d, %r15d
<L12>:
     60e: 48 8d 9d 78 ff ff ff         	leaq	-0x88(%rbp), %rbx
     615: 4a 8d 74 3d d7               	leaq	-0x29(%rbp,%r15), %rsi
     61a: 41 bd 01 00 00 00            	movl	$0x1, %r13d
     620: 4d 29 fd                     	subq	%r15, %r13
     623: 40 0f b6 c7                  	movzbl	%dil, %eax
     627: 49 01 c4                     	addq	%rax, %r12
     62a: 4c 89 e7                     	movq	%r12, %rdi
     62d: 4c 89 ea                     	movq	%r13, %rdx
     630: e8 00 00 00 00               	callq	 <L13>
		0000000000000631:  X86_64_RELOC_BRANCH	_memcpy
<L13>:
     635: 44 00 ad 18 fe ff ff         	addb	%r13b, -0x1e8(%rbp)
     63c: 49 ff c6                     	incq	%r14
     63f: 4c 89 b5 d0 fd ff ff         	movq	%r14, -0x230(%rbp)
     646: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     64d: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     654: e8 00 00 00 00               	callq	 <L14>
		0000000000000655:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L14>:
     659: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2e0>
		000000000000065c:  X86_64_RELOC_SIGNED	l___unnamed_1
     660: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     664: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2db>
		0000000000000667:  X86_64_RELOC_SIGNED	l___unnamed_1
     66b: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     66f: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2d6>
		0000000000000672:  X86_64_RELOC_SIGNED	l___unnamed_1
     676: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     67a: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2d1>
		000000000000067d:  X86_64_RELOC_SIGNED	l___unnamed_1
     681: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     685: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2cc>
		0000000000000688:  X86_64_RELOC_SIGNED	l___unnamed_1
     68c: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     693: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2ca>
		0000000000000696:  X86_64_RELOC_SIGNED	l___unnamed_1
     69a: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     6a1: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x2c8>
		00000000000006a4:  X86_64_RELOC_SIGNED	l___unnamed_1
     6a8: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     6af: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     6b6: 48 8d b5 20 fe ff ff         	leaq	-0x1e0(%rbp), %rsi
     6bd: e8 00 00 00 00               	callq	 <L15>
		00000000000006be:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L15>:
     6c2: 0f b6 7d b8                  	movzbl	-0x48(%rbp), %edi
     6c6: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     6cd: 49 83 c5 40                  	addq	$0x40, %r13
     6d1: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     6d8: 48 85 ff                     	testq	%rdi, %rdi
     6db: 74 46                        	je	 <L18>
     6dd: 40 80 ff 20                  	cmpb	$0x20, %dil
     6e1: 4c 8b b5 48 ff ff ff         	movq	-0xb8(%rbp), %r14
     6e8: 72 47                        	jb	 <L19>
     6ea: 41 bf 40 00 00 00            	movl	$0x40, %r15d
     6f0: 49 29 ff                     	subq	%rdi, %r15
     6f3: 48 01 df                     	addq	%rbx, %rdi
     6f6: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     6fd: 4c 89 fa                     	movq	%r15, %rdx
     700: e8 00 00 00 00               	callq	 <L16>
		0000000000000701:  X86_64_RELOC_BRANCH	_memcpy
<L16>:
     705: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     70c: 48 89 de                     	movq	%rbx, %rsi
     70f: e8 00 00 00 00               	callq	 <L17>
		0000000000000710:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L17>:
     714: c6 45 b8 00                  	movb	$0x0, -0x48(%rbp)
     718: 31 ff                        	xorl	%edi, %edi
     71a: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     721: eb 11                        	jmp	 <L20>
<L18>:
     723: 31 ff                        	xorl	%edi, %edi
     725: 45 31 ff                     	xorl	%r15d, %r15d
     728: 4c 8b b5 48 ff ff ff         	movq	-0xb8(%rbp), %r14
     72f: eb 03                        	jmp	 <L20>
<L19>:
     731: 45 31 ff                     	xorl	%r15d, %r15d
<L20>:
     734: 4a 8d b4 3d 60 fe ff ff      	leaq	-0x1a0(%rbp,%r15), %rsi
     73c: b8 20 00 00 00               	movl	$0x20, %eax
     741: 48 89 85 40 ff ff ff         	movq	%rax, -0xc0(%rbp)
     748: 41 bc 20 00 00 00            	movl	$0x20, %r12d
     74e: 4d 29 fc                     	subq	%r15, %r12
     751: 40 0f b6 c7                  	movzbl	%dil, %eax
     755: 48 01 c3                     	addq	%rax, %rbx
     758: 48 89 df                     	movq	%rbx, %rdi
     75b: 4c 89 e2                     	movq	%r12, %rdx
     75e: e8 00 00 00 00               	callq	 <L21>
		000000000000075f:  X86_64_RELOC_BRANCH	_memcpy
<L21>:
     763: 44 00 65 b8                  	addb	%r12b, -0x48(%rbp)
     767: 49 83 c5 20                  	addq	$0x20, %r13
     76b: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     772: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     779: 4c 89 f6                     	movq	%r14, %rsi
     77c: e8 00 00 00 00               	callq	 <L22>
		000000000000077d:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L22>:
     781: c6 45 d7 02                  	movb	$0x2, -0x29(%rbp)
     785: 4c 8b ad 30 ff ff ff         	movq	-0xd0(%rbp), %r13
     78c: 4c 8b 65 c8                  	movq	-0x38(%rbp), %r12
     790: 48 8b 9d 38 ff ff ff         	movq	-0xc8(%rbp), %rbx
     797: 0f 28 9d 90 fd ff ff         	movaps	-0x270(%rbp), %xmm3
     79e: 0f 28 a5 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm4
     7a5: 48 89 d8                     	movq	%rbx, %rax
     7a8: 48 83 e0 1f                  	andq	$0x1f, %rax
     7ac: 0f 84 c6 03 00 00            	je	 <L54>
<L23>:
     7b2: 48 89 45 c8                  	movq	%rax, -0x38(%rbp)
     7b6: 0f 28 05 03 59 00 00         	movaps	, %xmm0 <_audit_key384+0x80>
		00000000000007b9:  X86_64_RELOC_SIGNED	__literal16
     7bd: 0f 28 cb                     	movaps	%xmm3, %xmm1
     7c0: 0f 57 c8                     	xorps	%xmm0, %xmm1
     7c3: 0f 28 d4                     	movaps	%xmm4, %xmm2
     7c6: 0f 57 d0                     	xorps	%xmm0, %xmm2
     7c9: 0f 29 8d f0 fe ff ff         	movaps	%xmm1, -0x110(%rbp)
     7d0: 0f 29 95 00 ff ff ff         	movaps	%xmm2, -0x100(%rbp)
     7d7: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     7de: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
     7e5: 0f 28 05 e4 58 00 00         	movaps	, %xmm0 <_audit_key384+0x90>
		00000000000007e8:  X86_64_RELOC_SIGNED	__literal16
     7ec: 0f 57 d8                     	xorps	%xmm0, %xmm3
     7ef: 0f 57 e0                     	xorps	%xmm0, %xmm4
     7f2: 0f 29 9d 50 ff ff ff         	movaps	%xmm3, -0xb0(%rbp)
     7f9: 0f 29 a5 60 ff ff ff         	movaps	%xmm4, -0xa0(%rbp)
     800: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     807: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     80b: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x432>
		000000000000080e:  X86_64_RELOC_SIGNED	l___unnamed_1
     812: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
     819: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x450>
		000000000000081c:  X86_64_RELOC_SIGNED	l___unnamed_1
     820: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
     827: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x46e>
		000000000000082a:  X86_64_RELOC_SIGNED	l___unnamed_1
     82e: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
     835: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x48c>
		0000000000000838:  X86_64_RELOC_SIGNED	l___unnamed_1
     83c: 0f 29 85 b0 fe ff ff         	movaps	%xmm0, -0x150(%rbp)
     843: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4aa>
		0000000000000846:  X86_64_RELOC_SIGNED	l___unnamed_1
     84a: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
     851: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x4c8>
		0000000000000854:  X86_64_RELOC_SIGNED	l___unnamed_1
     858: 0f 29 85 d0 fe ff ff         	movaps	%xmm0, -0x130(%rbp)
     85f: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <L25>
		0000000000000862:  X86_64_RELOC_SIGNED	l___unnamed_1
     866: 0f 29 85 e0 fe ff ff         	movaps	%xmm0, -0x120(%rbp)
     86d: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     874: 48 8d b5 50 ff ff ff         	leaq	-0xb0(%rbp), %rsi
     87b: e8 00 00 00 00               	callq	 <L24>
		000000000000087c:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L24>:
     880: 48 83 85 a0 fe ff ff 40      	addq	$0x40, -0x160(%rbp)
     888: 0f b6 85 e8 fe ff ff         	movzbl	-0x118(%rbp), %eax
     88f: 48 83 fb 1f                  	cmpq	$0x1f, %rbx
     893: 0f 86 84 00 00 00            	jbe	 <L31>
     899: 84 c0                        	testb	%al, %al
     89b: 74 43                        	je	 <L27>
     89d: 3c 20                        	cmpb	$0x20, %al
     89f: 72 41                        	jb	 <L28>
     8a1: 0f b6 c0                     	movzbl	%al, %eax
     8a4: bb 40 00 00 00               	movl	$0x40, %ebx
     8a9: 48 29 c3                     	subq	%rax, %rbx
     8ac: 4c 8d bd a8 fe ff ff         	leaq	-0x158(%rbp), %r15
     8b3: 48 8d bc 05 a8 fe ff ff      	leaq	-0x158(%rbp,%rax), %rdi
     8bb: 4c 89 f6                     	movq	%r14, %rsi
     8be: 48 89 da                     	movq	%rbx, %rdx
     8c1: e8 00 00 00 00               	callq	 <L25>
		00000000000008c2:  X86_64_RELOC_BRANCH	_memcpy
<L25>:
     8c6: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     8cd: 4c 89 fe                     	movq	%r15, %rsi
     8d0: e8 00 00 00 00               	callq	 <L26>
		00000000000008d1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L26>:
     8d5: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     8dc: 31 c0                        	xorl	%eax, %eax
     8de: eb 04                        	jmp	 <L29>
<L27>:
     8e0: 31 c0                        	xorl	%eax, %eax
<L28>:
     8e2: 31 db                        	xorl	%ebx, %ebx
<L29>:
     8e4: 49 8d 34 1e                  	leaq	(%r14,%rbx), %rsi
     8e8: 41 bf 20 00 00 00            	movl	$0x20, %r15d
     8ee: 49 29 df                     	subq	%rbx, %r15
     8f1: 0f b6 c0                     	movzbl	%al, %eax
     8f4: 48 8d bc 05 a8 fe ff ff      	leaq	-0x158(%rbp,%rax), %rdi
     8fc: 4c 89 fa                     	movq	%r15, %rdx
     8ff: e8 00 00 00 00               	callq	 <L30>
		0000000000000900:  X86_64_RELOC_BRANCH	_memcpy
<L30>:
     904: 44 02 bd e8 fe ff ff         	addb	-0x118(%rbp), %r15b
     90b: 44 88 bd e8 fe ff ff         	movb	%r15b, -0x118(%rbp)
     912: 48 83 85 a0 fe ff ff 20      	addq	$0x20, -0x160(%rbp)
     91a: 44 89 f8                     	movl	%r15d, %eax
<L31>:
     91d: 84 c0                        	testb	%al, %al
     91f: 74 49                        	je	 <L34>
     921: 0f b6 c8                     	movzbl	%al, %ecx
     924: 49 8d 54 0d 00               	leaq	(%r13,%rcx), %rdx
     929: 48 83 fa 40                  	cmpq	$0x40, %rdx
     92d: 72 3d                        	jb	 <L35>
     92f: b2 40                        	movb	$0x40, %dl
     931: 28 c2                        	subb	%al, %dl
     933: 0f b6 da                     	movzbl	%dl, %ebx
     936: 4c 8d bd a8 fe ff ff         	leaq	-0x158(%rbp), %r15
     93d: 48 8d bc 0d a8 fe ff ff      	leaq	-0x158(%rbp,%rcx), %rdi
     945: 4c 89 e6                     	movq	%r12, %rsi
     948: 48 89 da                     	movq	%rbx, %rdx
     94b: e8 00 00 00 00               	callq	 <L32>
		000000000000094c:  X86_64_RELOC_BRANCH	_memcpy
<L32>:
     950: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     957: 4c 89 fe                     	movq	%r15, %rsi
     95a: e8 00 00 00 00               	callq	 <L33>
		000000000000095b:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L33>:
     95f: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     966: 31 c0                        	xorl	%eax, %eax
     968: eb 04                        	jmp	 <L36>
<L34>:
     96a: 31 c0                        	xorl	%eax, %eax
<L35>:
     96c: 31 db                        	xorl	%ebx, %ebx
<L36>:
     96e: 49 01 dc                     	addq	%rbx, %r12
     971: 4d 89 ef                     	movq	%r13, %r15
     974: 49 29 df                     	subq	%rbx, %r15
     977: 48 8d 9d a8 fe ff ff         	leaq	-0x158(%rbp), %rbx
     97e: 0f b6 c0                     	movzbl	%al, %eax
     981: 48 8d bc 05 a8 fe ff ff      	leaq	-0x158(%rbp,%rax), %rdi
     989: 4c 89 e6                     	movq	%r12, %rsi
     98c: 4c 89 fa                     	movq	%r15, %rdx
     98f: e8 00 00 00 00               	callq	 <L37>
		0000000000000990:  X86_64_RELOC_BRANCH	_memcpy
<L37>:
     994: 0f b6 bd e8 fe ff ff         	movzbl	-0x118(%rbp), %edi
     99b: 4c 01 ff                     	addq	%r15, %rdi
     99e: 40 88 bd e8 fe ff ff         	movb	%dil, -0x118(%rbp)
     9a5: 4c 03 ad a0 fe ff ff         	addq	-0x160(%rbp), %r13
     9ac: 4c 89 ad a0 fe ff ff         	movq	%r13, -0x160(%rbp)
     9b3: 40 84 ff                     	testb	%dil, %dil
     9b6: 74 3f                        	je	 <L40>
     9b8: 40 80 ff 3f                  	cmpb	$0x3f, %dil
     9bc: 72 40                        	jb	 <L41>
     9be: b0 40                        	movb	$0x40, %al
     9c0: 40 28 f8                     	subb	%dil, %al
     9c3: 44 0f b6 f8                  	movzbl	%al, %r15d
     9c7: 48 01 df                     	addq	%rbx, %rdi
     9ca: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
     9ce: 4c 89 fa                     	movq	%r15, %rdx
     9d1: e8 00 00 00 00               	callq	 <L38>
		00000000000009d2:  X86_64_RELOC_BRANCH	_memcpy
<L38>:
     9d6: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     9dd: 48 89 de                     	movq	%rbx, %rsi
     9e0: e8 00 00 00 00               	callq	 <L39>
		00000000000009e1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L39>:
     9e5: c6 85 e8 fe ff ff 00         	movb	$0x0, -0x118(%rbp)
     9ec: 31 ff                        	xorl	%edi, %edi
     9ee: 4c 8b a5 a0 fe ff ff         	movq	-0x160(%rbp), %r12
     9f5: eb 0d                        	jmp	 <L43>
<L40>:
     9f7: 4d 89 ec                     	movq	%r13, %r12
     9fa: 31 ff                        	xorl	%edi, %edi
     9fc: eb 03                        	jmp	 <L42>
<L41>:
     9fe: 4d 89 ec                     	movq	%r13, %r12
<L42>:
     a01: 45 31 ff                     	xorl	%r15d, %r15d
<L43>:
     a04: 4a 8d 74 3d d7               	leaq	-0x29(%rbp,%r15), %rsi
     a09: 41 bd 01 00 00 00            	movl	$0x1, %r13d
     a0f: 4d 29 fd                     	subq	%r15, %r13
     a12: 40 0f b6 c7                  	movzbl	%dil, %eax
     a16: 48 01 c3                     	addq	%rax, %rbx
     a19: 48 89 df                     	movq	%rbx, %rdi
     a1c: 4c 89 ea                     	movq	%r13, %rdx
     a1f: e8 00 00 00 00               	callq	 <L44>
		0000000000000a20:  X86_64_RELOC_BRANCH	_memcpy
<L44>:
     a24: 44 00 ad e8 fe ff ff         	addb	%r13b, -0x118(%rbp)
     a2b: 49 ff c4                     	incq	%r12
     a2e: 4c 89 a5 a0 fe ff ff         	movq	%r12, -0x160(%rbp)
     a35: 48 8d bd 80 fe ff ff         	leaq	-0x180(%rbp), %rdi
     a3c: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     a43: e8 00 00 00 00               	callq	 <L45>
		0000000000000a44:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L45>:
     a48: 0f 28 05 60 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6cf>
		0000000000000a4b:  X86_64_RELOC_SIGNED	l___unnamed_1
     a4f: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
     a53: 0f 28 05 50 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6ca>
		0000000000000a56:  X86_64_RELOC_SIGNED	l___unnamed_1
     a5a: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
     a5e: 0f 28 05 40 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6c5>
		0000000000000a61:  X86_64_RELOC_SIGNED	l___unnamed_1
     a65: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
     a69: 0f 28 05 30 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6c0>
		0000000000000a6c:  X86_64_RELOC_SIGNED	l___unnamed_1
     a70: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
     a74: 0f 28 05 20 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6bb>
		0000000000000a77:  X86_64_RELOC_SIGNED	l___unnamed_1
     a7b: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
     a82: 0f 28 05 10 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6b9>
		0000000000000a85:  X86_64_RELOC_SIGNED	l___unnamed_1
     a89: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
     a90: 0f 28 05 00 00 00 00         	movaps	, %xmm0 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand+0x6b7>
		0000000000000a93:  X86_64_RELOC_SIGNED	l___unnamed_1
     a97: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
     a9e: 48 8d b5 f0 fe ff ff         	leaq	-0x110(%rbp), %rsi
     aa5: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     aac: e8 00 00 00 00               	callq	 <L46>
		0000000000000aad:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L46>:
     ab1: 0f b6 7d b8                  	movzbl	-0x48(%rbp), %edi
     ab5: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     abc: 49 83 c5 40                  	addq	$0x40, %r13
     ac0: 48 8d 9d 78 ff ff ff         	leaq	-0x88(%rbp), %rbx
     ac7: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     ace: 4d 89 f4                     	movq	%r14, %r12
     ad1: 48 85 ff                     	testq	%rdi, %rdi
     ad4: 74 3f                        	je	 <L49>
     ad6: 40 80 ff 20                  	cmpb	$0x20, %dil
     ada: 72 3b                        	jb	 <L50>
     adc: 41 be 40 00 00 00            	movl	$0x40, %r14d
     ae2: 49 29 fe                     	subq	%rdi, %r14
     ae5: 48 01 df                     	addq	%rbx, %rdi
     ae8: 48 8d b5 60 fe ff ff         	leaq	-0x1a0(%rbp), %rsi
     aef: 4c 89 f2                     	movq	%r14, %rdx
     af2: e8 00 00 00 00               	callq	 <L47>
		0000000000000af3:  X86_64_RELOC_BRANCH	_memcpy
<L47>:
     af7: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     afe: 48 89 de                     	movq	%rbx, %rsi
     b01: e8 00 00 00 00               	callq	 <L48>
		0000000000000b02:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L48>:
     b06: c6 45 b8 00                  	movb	$0x0, -0x48(%rbp)
     b0a: 31 ff                        	xorl	%edi, %edi
     b0c: 4c 8b ad 70 ff ff ff         	movq	-0x90(%rbp), %r13
     b13: eb 05                        	jmp	 <L51>
<L49>:
     b15: 31 ff                        	xorl	%edi, %edi
<L50>:
     b17: 45 31 f6                     	xorl	%r14d, %r14d
<L51>:
     b1a: 4a 8d b4 35 60 fe ff ff      	leaq	-0x1a0(%rbp,%r14), %rsi
     b22: 41 bf 20 00 00 00            	movl	$0x20, %r15d
     b28: 4d 29 f7                     	subq	%r14, %r15
     b2b: 40 0f b6 c7                  	movzbl	%dil, %eax
     b2f: 48 01 c3                     	addq	%rax, %rbx
     b32: 48 89 df                     	movq	%rbx, %rdi
     b35: 4c 89 fa                     	movq	%r15, %rdx
     b38: e8 00 00 00 00               	callq	 <L52>
		0000000000000b39:  X86_64_RELOC_BRANCH	_memcpy
<L52>:
     b3d: 44 00 7d b8                  	addb	%r15b, -0x48(%rbp)
     b41: 49 83 c5 20                  	addq	$0x20, %r13
     b45: 4c 89 ad 70 ff ff ff         	movq	%r13, -0x90(%rbp)
     b4c: 48 8d bd 50 ff ff ff         	leaq	-0xb0(%rbp), %rdi
     b53: 48 8d 9d 70 fd ff ff         	leaq	-0x290(%rbp), %rbx
     b5a: 48 89 de                     	movq	%rbx, %rsi
     b5d: e8 00 00 00 00               	callq	 <L53>
		0000000000000b5e:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final
<L53>:
     b62: 4c 03 a5 40 ff ff ff         	addq	-0xc0(%rbp), %r12
     b69: 4c 89 e7                     	movq	%r12, %rdi
     b6c: 48 89 de                     	movq	%rbx, %rsi
     b6f: 48 8b 55 c8                  	movq	-0x38(%rbp), %rdx
     b73: e8 00 00 00 00               	callq	 <L54>
		0000000000000b74:  X86_64_RELOC_BRANCH	_memcpy
<L54>:
     b78: 48 81 c4 68 02 00 00         	addq	$0x268, %rsp            ## imm = 0x268
     b7f: 5b                           	popq	%rbx
     b80: 41 5c                        	popq	%r12
     b82: 41 5d                        	popq	%r13
     b84: 41 5e                        	popq	%r14
     b86: 41 5f                        	popq	%r15
     b88: 5d                           	popq	%rbp
     b89: c3                           	retq
     b8a: 66 0f 1f 44 00 00            	nopw	(%rax,%rax)

0000000000000b90 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).final>:
     b90: 55                           	pushq	%rbp
     b91: 48 89 e5                     	movq	%rsp, %rbp
     b94: 41 57                        	pushq	%r15
     b96: 41 56                        	pushq	%r14
     b98: 53                           	pushq	%rbx
     b99: 50                           	pushq	%rax
     b9a: 48 89 f3                     	movq	%rsi, %rbx
     b9d: 49 89 fe                     	movq	%rdi, %r14
     ba0: 4c 8d 7f 28                  	leaq	0x28(%rdi), %r15
     ba4: 0f b6 47 68                  	movzbl	0x68(%rdi), %eax
     ba8: 48 8d 7c 07 28               	leaq	0x28(%rdi,%rax), %rdi
     bad: be 40 00 00 00               	movl	$0x40, %esi
     bb2: 48 29 c6                     	subq	%rax, %rsi
     bb5: e8 00 00 00 00               	callq	 <L0>
		0000000000000bb6:  X86_64_RELOC_BRANCH	___bzero
<L0>:
     bba: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
     bbf: 41 c6 44 06 28 80            	movb	$-0x80, 0x28(%r14,%rax)
     bc5: 41 0f b6 46 68               	movzbl	0x68(%r14), %eax
     bca: 8d 48 01                     	leal	0x1(%rax), %ecx
     bcd: 41 88 4e 68                  	movb	%cl, 0x68(%r14)
     bd1: 3c 37                        	cmpb	$0x37, %al
     bd3: 76 42                        	jbe	 <L2>
     bd5: 4c 89 f7                     	movq	%r14, %rdi
     bd8: 4c 89 fe                     	movq	%r15, %rsi
     bdb: e8 00 00 00 00               	callq	 <L1>
		0000000000000bdc:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L1>:
     be0: 49 c7 47 30 00 00 00 00      	movq	$0x0, 0x30(%r15)
     be8: 49 c7 47 28 00 00 00 00      	movq	$0x0, 0x28(%r15)
     bf0: 49 c7 47 20 00 00 00 00      	movq	$0x0, 0x20(%r15)
     bf8: 49 c7 47 18 00 00 00 00      	movq	$0x0, 0x18(%r15)
     c00: 49 c7 47 10 00 00 00 00      	movq	$0x0, 0x10(%r15)
     c08: 49 c7 47 08 00 00 00 00      	movq	$0x0, 0x8(%r15)
     c10: 49 c7 07 00 00 00 00         	movq	$0x0, (%r15)
<L2>:
     c17: 49 8b 46 20                  	movq	0x20(%r14), %rax
     c1b: 89 c1                        	movl	%eax, %ecx
     c1d: c1 e9 05                     	shrl	$0x5, %ecx
     c20: 8d 14 c5 00 00 00 00         	leal	(,%rax,8), %edx
     c27: 41 88 56 67                  	movb	%dl, 0x67(%r14)
     c2b: 41 88 4e 66                  	movb	%cl, 0x66(%r14)
     c2f: 89 c1                        	movl	%eax, %ecx
     c31: c1 e9 0d                     	shrl	$0xd, %ecx
     c34: 41 88 4e 65                  	movb	%cl, 0x65(%r14)
     c38: 89 c1                        	movl	%eax, %ecx
     c3a: c1 e9 15                     	shrl	$0x15, %ecx
     c3d: 41 88 4e 64                  	movb	%cl, 0x64(%r14)
     c41: 48 89 c1                     	movq	%rax, %rcx
     c44: 48 c1 e9 1d                  	shrq	$0x1d, %rcx
     c48: 41 88 4e 63                  	movb	%cl, 0x63(%r14)
     c4c: 48 89 c1                     	movq	%rax, %rcx
     c4f: 48 c1 e9 25                  	shrq	$0x25, %rcx
     c53: 41 88 4e 62                  	movb	%cl, 0x62(%r14)
     c57: 48 89 c1                     	movq	%rax, %rcx
     c5a: 48 c1 e9 2d                  	shrq	$0x2d, %rcx
     c5e: 41 88 4e 61                  	movb	%cl, 0x61(%r14)
     c62: 48 c1 e8 35                  	shrq	$0x35, %rax
     c66: 41 88 46 60                  	movb	%al, 0x60(%r14)
     c6a: 4c 89 f7                     	movq	%r14, %rdi
     c6d: 4c 89 fe                     	movq	%r15, %rsi
     c70: e8 00 00 00 00               	callq	 <L3>
		0000000000000c71:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round
<L3>:
     c75: 41 8b 06                     	movl	(%r14), %eax
     c78: 0f c8                        	bswapl	%eax
     c7a: 89 03                        	movl	%eax, (%rbx)
     c7c: 41 8b 46 04                  	movl	0x4(%r14), %eax
     c80: 0f c8                        	bswapl	%eax
     c82: 89 43 04                     	movl	%eax, 0x4(%rbx)
     c85: 41 8b 46 08                  	movl	0x8(%r14), %eax
     c89: 0f c8                        	bswapl	%eax
     c8b: 89 43 08                     	movl	%eax, 0x8(%rbx)
     c8e: 41 8b 46 0c                  	movl	0xc(%r14), %eax
     c92: 0f c8                        	bswapl	%eax
     c94: 89 43 0c                     	movl	%eax, 0xc(%rbx)
     c97: 41 8b 46 10                  	movl	0x10(%r14), %eax
     c9b: 0f c8                        	bswapl	%eax
     c9d: 89 43 10                     	movl	%eax, 0x10(%rbx)
     ca0: 41 8b 46 14                  	movl	0x14(%r14), %eax
     ca4: 0f c8                        	bswapl	%eax
     ca6: 89 43 14                     	movl	%eax, 0x14(%rbx)
     ca9: 41 8b 46 18                  	movl	0x18(%r14), %eax
     cad: 0f c8                        	bswapl	%eax
     caf: 89 43 18                     	movl	%eax, 0x18(%rbx)
     cb2: 41 8b 46 1c                  	movl	0x1c(%r14), %eax
     cb6: 0f c8                        	bswapl	%eax
     cb8: 89 43 1c                     	movl	%eax, 0x1c(%rbx)
     cbb: 48 83 c4 08                  	addq	$0x8, %rsp
     cbf: 5b                           	popq	%rbx
     cc0: 41 5e                        	popq	%r14
     cc2: 41 5f                        	popq	%r15
     cc4: 5d                           	popq	%rbp
     cc5: c3                           	retq
     cc6: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)

0000000000000cd0 <_crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256).round>:
     cd0: 55                           	pushq	%rbp
     cd1: 48 89 e5                     	movq	%rsp, %rbp
     cd4: 41 57                        	pushq	%r15
     cd6: 41 56                        	pushq	%r14
     cd8: 41 55                        	pushq	%r13
     cda: 41 54                        	pushq	%r12
     cdc: 53                           	pushq	%rbx
     cdd: 48 81 ec 28 09 00 00         	subq	$0x928, %rsp            ## imm = 0x928
     ce4: 48 89 bd c8 fe ff ff         	movq	%rdi, -0x138(%rbp)
     ceb: 4c 8d a5 d0 fe ff ff         	leaq	-0x130(%rbp), %r12
     cf2: f3 0f 6f 0e                  	movdqu	(%rsi), %xmm1
     cf6: 66 0f 6f 05 e2 53 00 00      	movdqa	, %xmm0 <_audit_key384+0xa0>
		0000000000000cfa:  X86_64_RELOC_SIGNED	__literal16
     cfe: 66 0f 38 00 c8               	pshufb	%xmm0, %xmm1
     d03: 66 0f 7f 8d b0 fe ff ff      	movdqa	%xmm1, -0x150(%rbp)
     d0b: 66 0f 7f 8d d0 fe ff ff      	movdqa	%xmm1, -0x130(%rbp)
     d13: f3 0f 6f 4e 10               	movdqu	0x10(%rsi), %xmm1
     d18: 66 0f 38 00 c8               	pshufb	%xmm0, %xmm1
     d1d: 66 0f 7f 8d e0 fe ff ff      	movdqa	%xmm1, -0x120(%rbp)
     d25: f3 0f 6f 4e 20               	movdqu	0x20(%rsi), %xmm1
     d2a: 66 0f 38 00 c8               	pshufb	%xmm0, %xmm1
     d2f: 66 0f 7f 8d f0 fe ff ff      	movdqa	%xmm1, -0x110(%rbp)
     d37: f3 0f 6f 4e 30               	movdqu	0x30(%rsi), %xmm1
     d3c: 66 0f 38 00 c8               	pshufb	%xmm0, %xmm1
     d41: 66 0f 7f 8d 00 ff ff ff      	movdqa	%xmm1, -0x100(%rbp)
     d49: 31 db                        	xorl	%ebx, %ebx
     d4b: 0f 1f 44 00 00               	nopl	(%rax,%rax)
<L0>:
     d50: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     d55: 48 8d bd b0 fd ff ff         	leaq	-0x250(%rbp), %rdi
     d5c: 4c 89 e6                     	movq	%r12, %rsi
     d5f: e8 00 00 00 00               	callq	 <L1>
		0000000000000d60:  X86_64_RELOC_BRANCH	_memcpy
<L1>:
     d64: 44 8b b4 1d b0 fd ff ff      	movl	-0x250(%rbp,%rbx), %r14d
     d6c: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     d71: 48 8d bd b0 fc ff ff         	leaq	-0x350(%rbp), %rdi
     d78: 4c 89 e6                     	movq	%r12, %rsi
     d7b: e8 00 00 00 00               	callq	 <L2>
		0000000000000d7c:  X86_64_RELOC_BRANCH	_memcpy
<L2>:
     d80: 44 03 b4 1d d4 fc ff ff      	addl	-0x32c(%rbp,%rbx), %r14d
     d88: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     d8d: 48 8d bd b0 fb ff ff         	leaq	-0x450(%rbp), %rdi
     d94: 4c 89 e6                     	movq	%r12, %rsi
     d97: e8 00 00 00 00               	callq	 <L3>
		0000000000000d98:  X86_64_RELOC_BRANCH	_memcpy
<L3>:
     d9c: 44 8b bc 1d b4 fb ff ff      	movl	-0x44c(%rbp,%rbx), %r15d
     da4: 41 c1 c7 19                  	roll	$0x19, %r15d
     da8: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     dad: 48 8d bd b0 fa ff ff         	leaq	-0x550(%rbp), %rdi
     db4: 4c 89 e6                     	movq	%r12, %rsi
     db7: e8 00 00 00 00               	callq	 <L4>
		0000000000000db8:  X86_64_RELOC_BRANCH	_memcpy
<L4>:
     dbc: 44 8b ac 1d b4 fa ff ff      	movl	-0x54c(%rbp,%rbx), %r13d
     dc4: 41 c1 c5 0e                  	roll	$0xe, %r13d
     dc8: 45 31 fd                     	xorl	%r15d, %r13d
     dcb: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     dd0: 48 8d bd b0 f9 ff ff         	leaq	-0x650(%rbp), %rdi
     dd7: 4c 89 e6                     	movq	%r12, %rsi
     dda: e8 00 00 00 00               	callq	 <L5>
		0000000000000ddb:  X86_64_RELOC_BRANCH	_memcpy
<L5>:
     ddf: 44 8b bc 1d b4 f9 ff ff      	movl	-0x64c(%rbp,%rbx), %r15d
     de7: 41 c1 ef 03                  	shrl	$0x3, %r15d
     deb: 45 31 ef                     	xorl	%r13d, %r15d
     dee: 45 01 f7                     	addl	%r14d, %r15d
     df1: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     df6: 48 8d bd b0 f8 ff ff         	leaq	-0x750(%rbp), %rdi
     dfd: 4c 89 e6                     	movq	%r12, %rsi
     e00: e8 00 00 00 00               	callq	 <L6>
		0000000000000e01:  X86_64_RELOC_BRANCH	_memcpy
<L6>:
     e05: 44 8b b4 1d e8 f8 ff ff      	movl	-0x718(%rbp,%rbx), %r14d
     e0d: 41 c1 c6 0f                  	roll	$0xf, %r14d
     e11: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     e16: 48 8d bd b0 f7 ff ff         	leaq	-0x850(%rbp), %rdi
     e1d: 4c 89 e6                     	movq	%r12, %rsi
     e20: e8 00 00 00 00               	callq	 <L7>
		0000000000000e21:  X86_64_RELOC_BRANCH	_memcpy
<L7>:
     e25: 44 8b ac 1d e8 f7 ff ff      	movl	-0x818(%rbp,%rbx), %r13d
     e2d: 41 c1 c5 0d                  	roll	$0xd, %r13d
     e31: 45 31 f5                     	xorl	%r14d, %r13d
     e34: ba 00 01 00 00               	movl	$0x100, %edx            ## imm = 0x100
     e39: 48 8d bd b0 f6 ff ff         	leaq	-0x950(%rbp), %rdi
     e40: 4c 89 e6                     	movq	%r12, %rsi
     e43: e8 00 00 00 00               	callq	 <L8>
		0000000000000e44:  X86_64_RELOC_BRANCH	_memcpy
<L8>:
     e48: 8b 84 1d e8 f6 ff ff         	movl	-0x918(%rbp,%rbx), %eax
     e4f: c1 e8 0a                     	shrl	$0xa, %eax
     e52: 44 31 e8                     	xorl	%r13d, %eax
     e55: 44 01 f8                     	addl	%r15d, %eax
     e58: 89 84 1d 10 ff ff ff         	movl	%eax, -0xf0(%rbp,%rbx)
     e5f: 48 83 c3 04                  	addq	$0x4, %rbx
     e63: 48 81 fb c0 00 00 00         	cmpq	$0xc0, %rbx
     e6a: 0f 85 e0 fe ff ff            	jne	 <L0>
     e70: 4c 8b ad c8 fe ff ff         	movq	-0x138(%rbp), %r13
     e77: 41 8b 7d 00                  	movl	(%r13), %edi
     e7b: 45 8b 5d 04                  	movl	0x4(%r13), %r11d
     e7f: 45 8b 4d 08                  	movl	0x8(%r13), %r9d
     e83: 45 8b 55 10                  	movl	0x10(%r13), %r10d
     e87: 41 8b 4d 14                  	movl	0x14(%r13), %ecx
     e8b: 41 8b 75 18                  	movl	0x18(%r13), %esi
     e8f: 44 89 d0                     	movl	%r10d, %eax
     e92: c1 c0 1a                     	roll	$0x1a, %eax
     e95: 44 89 d2                     	movl	%r10d, %edx
     e98: c1 c2 15                     	roll	$0x15, %edx
     e9b: 31 c2                        	xorl	%eax, %edx
     e9d: 44 89 d0                     	movl	%r10d, %eax
     ea0: c1 c0 07                     	roll	$0x7, %eax
     ea3: 31 d0                        	xorl	%edx, %eax
     ea5: 89 f2                        	movl	%esi, %edx
     ea7: 31 ca                        	xorl	%ecx, %edx
     ea9: 44 21 d2                     	andl	%r10d, %edx
     eac: 41 03 45 1c                  	addl	0x1c(%r13), %eax
     eb0: 31 f2                        	xorl	%esi, %edx
     eb2: 66 0f 6f 85 b0 fe ff ff      	movdqa	-0x150(%rbp), %xmm0
     eba: 66 41 0f 7e c0               	movd	%xmm0, %r8d
     ebf: 41 01 c0                     	addl	%eax, %r8d
     ec2: 42 8d 9c 02 98 2f 8a 42      	leal	0x428a2f98(%rdx,%r8), %ebx
     eca: 41 8b 55 0c                  	movl	0xc(%r13), %edx
     ece: 89 f8                        	movl	%edi, %eax
     ed0: c1 c0 1e                     	roll	$0x1e, %eax
     ed3: 01 da                        	addl	%ebx, %edx
     ed5: 41 89 f8                     	movl	%edi, %r8d
     ed8: 41 c1 c0 13                  	roll	$0x13, %r8d
     edc: 41 31 c0                     	xorl	%eax, %r8d
     edf: 41 89 fe                     	movl	%edi, %r14d
     ee2: 41 c1 c6 0a                  	roll	$0xa, %r14d
     ee6: 45 31 c6                     	xorl	%r8d, %r14d
     ee9: 41 89 d0                     	movl	%edx, %r8d
     eec: 41 c1 c0 1a                  	roll	$0x1a, %r8d
     ef0: 44 89 c8                     	movl	%r9d, %eax
     ef3: 41 89 d4                     	movl	%edx, %r12d
     ef6: 41 c1 c4 15                  	roll	$0x15, %r12d
     efa: 45 31 c4                     	xorl	%r8d, %r12d
     efd: 41 89 d7                     	movl	%edx, %r15d
     f00: 41 c1 c7 07                  	roll	$0x7, %r15d
     f04: 45 31 e7                     	xorl	%r12d, %r15d
     f07: 41 89 c8                     	movl	%ecx, %r8d
     f0a: 45 31 d0                     	xorl	%r10d, %r8d
     f0d: 41 21 d0                     	andl	%edx, %r8d
     f10: 41 31 c8                     	xorl	%ecx, %r8d
     f13: 03 b5 d4 fe ff ff            	addl	-0x12c(%rbp), %esi
     f19: 44 01 c6                     	addl	%r8d, %esi
     f1c: 46 8d 04 3e                  	leal	(%rsi,%r15), %r8d
     f20: 47 8d 84 01 91 44 37 71      	leal	0x71374491(%r9,%r8), %r8d
     f28: 45 09 d9                     	orl	%r11d, %r9d
     f2b: 41 21 f9                     	andl	%edi, %r9d
     f2e: 44 21 d8                     	andl	%r11d, %eax
     f31: 44 09 c8                     	orl	%r9d, %eax
     f34: 44 01 f0                     	addl	%r14d, %eax
     f37: 01 d8                        	addl	%ebx, %eax
     f39: 41 89 c1                     	movl	%eax, %r9d
     f3c: 41 c1 c1 1e                  	roll	$0x1e, %r9d
     f40: 41 8d 9c 37 91 44 37 71      	leal	0x71374491(%r15,%rsi), %ebx
     f48: 89 c6                        	movl	%eax, %esi
     f4a: c1 c6 13                     	roll	$0x13, %esi
     f4d: 44 31 ce                     	xorl	%r9d, %esi
     f50: 41 89 c6                     	movl	%eax, %r14d
     f53: 41 c1 c6 0a                  	roll	$0xa, %r14d
     f57: 41 31 f6                     	xorl	%esi, %r14d
     f5a: 45 89 c1                     	movl	%r8d, %r9d
     f5d: 41 c1 c1 1a                  	roll	$0x1a, %r9d
     f61: 44 89 de                     	movl	%r11d, %esi
     f64: 45 89 c4                     	movl	%r8d, %r12d
     f67: 41 c1 c4 15                  	roll	$0x15, %r12d
     f6b: 45 31 cc                     	xorl	%r9d, %r12d
     f6e: 45 89 c7                     	movl	%r8d, %r15d
     f71: 41 c1 c7 07                  	roll	$0x7, %r15d
     f75: 45 31 e7                     	xorl	%r12d, %r15d
     f78: 41 89 d1                     	movl	%edx, %r9d
     f7b: 45 31 d1                     	xorl	%r10d, %r9d
     f7e: 45 21 c1                     	andl	%r8d, %r9d
     f81: 45 31 d1                     	xorl	%r10d, %r9d
     f84: 03 8d d8 fe ff ff            	addl	-0x128(%rbp), %ecx
     f8a: 44 01 c9                     	addl	%r9d, %ecx
     f8d: 46 8d 0c 39                  	leal	(%rcx,%r15), %r9d
     f91: 47 8d 8c 0b cf fb c0 b5      	leal	-0x4a3f0431(%r11,%r9), %r9d
     f99: 41 09 fb                     	orl	%edi, %r11d
     f9c: 41 21 c3                     	andl	%eax, %r11d
     f9f: 21 fe                        	andl	%edi, %esi
     fa1: 44 09 de                     	orl	%r11d, %esi
     fa4: 44 01 f6                     	addl	%r14d, %esi
     fa7: 01 de                        	addl	%ebx, %esi
     fa9: 41 89 f3                     	movl	%esi, %r11d
     fac: 41 c1 c3 1e                  	roll	$0x1e, %r11d
     fb0: 41 8d 9c 0f cf fb c0 b5      	leal	-0x4a3f0431(%r15,%rcx), %ebx
     fb8: 89 f1                        	movl	%esi, %ecx
     fba: c1 c1 13                     	roll	$0x13, %ecx
     fbd: 44 31 d9                     	xorl	%r11d, %ecx
     fc0: 41 89 f3                     	movl	%esi, %r11d
     fc3: 41 c1 c3 0a                  	roll	$0xa, %r11d
     fc7: 41 31 cb                     	xorl	%ecx, %r11d
     fca: 41 89 c6                     	movl	%eax, %r14d
     fcd: 41 09 fe                     	orl	%edi, %r14d
     fd0: 41 21 f6                     	andl	%esi, %r14d
     fd3: 89 c1                        	movl	%eax, %ecx
     fd5: 21 f9                        	andl	%edi, %ecx
     fd7: 44 09 f1                     	orl	%r14d, %ecx
     fda: 44 01 d9                     	addl	%r11d, %ecx
     fdd: 01 d9                        	addl	%ebx, %ecx
     fdf: 45 89 cb                     	movl	%r9d, %r11d
     fe2: 41 c1 c3 1a                  	roll	$0x1a, %r11d
     fe6: 44 89 cb                     	movl	%r9d, %ebx
     fe9: c1 c3 15                     	roll	$0x15, %ebx
     fec: 44 31 db                     	xorl	%r11d, %ebx
     fef: 45 89 cb                     	movl	%r9d, %r11d
     ff2: 41 c1 c3 07                  	roll	$0x7, %r11d
     ff6: 41 31 db                     	xorl	%ebx, %r11d
     ff9: 44 89 c3                     	movl	%r8d, %ebx
     ffc: 31 d3                        	xorl	%edx, %ebx
     ffe: 44 21 cb                     	andl	%r9d, %ebx
    1001: 31 d3                        	xorl	%edx, %ebx
    1003: 44 03 95 dc fe ff ff         	addl	-0x124(%rbp), %r10d
    100a: 41 01 da                     	addl	%ebx, %r10d
    100d: 43 8d 1c 1a                  	leal	(%r10,%r11), %ebx
    1011: 47 8d b4 13 a5 db b5 e9      	leal	-0x164a245b(%r11,%r10), %r14d
    1019: 41 89 ca                     	movl	%ecx, %r10d
    101c: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1020: 44 8d 9c 1f a5 db b5 e9      	leal	-0x164a245b(%rdi,%rbx), %r11d
    1028: 89 cf                        	movl	%ecx, %edi
    102a: c1 c7 13                     	roll	$0x13, %edi
    102d: 44 31 d7                     	xorl	%r10d, %edi
    1030: 89 cb                        	movl	%ecx, %ebx
    1032: c1 c3 0a                     	roll	$0xa, %ebx
    1035: 31 fb                        	xorl	%edi, %ebx
    1037: 89 f7                        	movl	%esi, %edi
    1039: 09 c7                        	orl	%eax, %edi
    103b: 21 cf                        	andl	%ecx, %edi
    103d: 41 89 f2                     	movl	%esi, %r10d
    1040: 41 21 c2                     	andl	%eax, %r10d
    1043: 41 09 fa                     	orl	%edi, %r10d
    1046: 41 01 da                     	addl	%ebx, %r10d
    1049: 45 01 f2                     	addl	%r14d, %r10d
    104c: 44 89 df                     	movl	%r11d, %edi
    104f: c1 c7 1a                     	roll	$0x1a, %edi
    1052: 44 89 db                     	movl	%r11d, %ebx
    1055: c1 c3 15                     	roll	$0x15, %ebx
    1058: 31 fb                        	xorl	%edi, %ebx
    105a: 44 89 df                     	movl	%r11d, %edi
    105d: c1 c7 07                     	roll	$0x7, %edi
    1060: 31 df                        	xorl	%ebx, %edi
    1062: 44 89 cb                     	movl	%r9d, %ebx
    1065: 44 31 c3                     	xorl	%r8d, %ebx
    1068: 44 21 db                     	andl	%r11d, %ebx
    106b: 44 31 c3                     	xorl	%r8d, %ebx
    106e: 03 95 e0 fe ff ff            	addl	-0x120(%rbp), %edx
    1074: 01 da                        	addl	%ebx, %edx
    1076: 8d 94 17 5b c2 56 39         	leal	0x3956c25b(%rdi,%rdx), %edx
    107d: 01 d0                        	addl	%edx, %eax
    107f: 44 89 d7                     	movl	%r10d, %edi
    1082: c1 c7 1e                     	roll	$0x1e, %edi
    1085: 44 89 d3                     	movl	%r10d, %ebx
    1088: c1 c3 13                     	roll	$0x13, %ebx
    108b: 31 fb                        	xorl	%edi, %ebx
    108d: 45 89 d6                     	movl	%r10d, %r14d
    1090: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1094: 41 31 de                     	xorl	%ebx, %r14d
    1097: 89 cb                        	movl	%ecx, %ebx
    1099: 09 f3                        	orl	%esi, %ebx
    109b: 44 21 d3                     	andl	%r10d, %ebx
    109e: 89 cf                        	movl	%ecx, %edi
    10a0: 21 f7                        	andl	%esi, %edi
    10a2: 09 df                        	orl	%ebx, %edi
    10a4: 44 01 f7                     	addl	%r14d, %edi
    10a7: 01 d7                        	addl	%edx, %edi
    10a9: 89 c2                        	movl	%eax, %edx
    10ab: c1 c2 1a                     	roll	$0x1a, %edx
    10ae: 89 c3                        	movl	%eax, %ebx
    10b0: c1 c3 15                     	roll	$0x15, %ebx
    10b3: 31 d3                        	xorl	%edx, %ebx
    10b5: 89 c2                        	movl	%eax, %edx
    10b7: c1 c2 07                     	roll	$0x7, %edx
    10ba: 31 da                        	xorl	%ebx, %edx
    10bc: 44 89 db                     	movl	%r11d, %ebx
    10bf: 44 31 cb                     	xorl	%r9d, %ebx
    10c2: 21 c3                        	andl	%eax, %ebx
    10c4: 44 03 85 e4 fe ff ff         	addl	-0x11c(%rbp), %r8d
    10cb: 44 31 cb                     	xorl	%r9d, %ebx
    10ce: 41 01 d8                     	addl	%ebx, %r8d
    10d1: 42 8d 94 02 f1 11 f1 59      	leal	0x59f111f1(%rdx,%r8), %edx
    10d9: 01 d6                        	addl	%edx, %esi
    10db: 41 89 f8                     	movl	%edi, %r8d
    10de: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    10e2: 89 fb                        	movl	%edi, %ebx
    10e4: c1 c3 13                     	roll	$0x13, %ebx
    10e7: 44 31 c3                     	xorl	%r8d, %ebx
    10ea: 41 89 fe                     	movl	%edi, %r14d
    10ed: 41 c1 c6 0a                  	roll	$0xa, %r14d
    10f1: 41 31 de                     	xorl	%ebx, %r14d
    10f4: 44 89 d3                     	movl	%r10d, %ebx
    10f7: 09 cb                        	orl	%ecx, %ebx
    10f9: 21 fb                        	andl	%edi, %ebx
    10fb: 45 89 d0                     	movl	%r10d, %r8d
    10fe: 41 21 c8                     	andl	%ecx, %r8d
    1101: 41 09 d8                     	orl	%ebx, %r8d
    1104: 89 f3                        	movl	%esi, %ebx
    1106: c1 c3 1a                     	roll	$0x1a, %ebx
    1109: 45 01 f0                     	addl	%r14d, %r8d
    110c: 41 89 f6                     	movl	%esi, %r14d
    110f: 41 c1 c6 15                  	roll	$0x15, %r14d
    1113: 41 01 d0                     	addl	%edx, %r8d
    1116: 89 f2                        	movl	%esi, %edx
    1118: c1 c2 07                     	roll	$0x7, %edx
    111b: 41 31 de                     	xorl	%ebx, %r14d
    111e: 44 31 f2                     	xorl	%r14d, %edx
    1121: 89 c3                        	movl	%eax, %ebx
    1123: 44 31 db                     	xorl	%r11d, %ebx
    1126: 21 f3                        	andl	%esi, %ebx
    1128: 44 31 db                     	xorl	%r11d, %ebx
    112b: 44 03 8d e8 fe ff ff         	addl	-0x118(%rbp), %r9d
    1132: 41 01 d9                     	addl	%ebx, %r9d
    1135: 44 89 c3                     	movl	%r8d, %ebx
    1138: c1 c3 1e                     	roll	$0x1e, %ebx
    113b: 46 8d 8c 0a a4 82 3f 92      	leal	-0x6dc07d5c(%rdx,%r9), %r9d
    1143: 44 89 c2                     	movl	%r8d, %edx
    1146: c1 c2 13                     	roll	$0x13, %edx
    1149: 44 01 c9                     	addl	%r9d, %ecx
    114c: 45 89 c6                     	movl	%r8d, %r14d
    114f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1153: 31 da                        	xorl	%ebx, %edx
    1155: 41 31 d6                     	xorl	%edx, %r14d
    1158: 89 fb                        	movl	%edi, %ebx
    115a: 44 09 d3                     	orl	%r10d, %ebx
    115d: 44 21 c3                     	andl	%r8d, %ebx
    1160: 89 fa                        	movl	%edi, %edx
    1162: 44 21 d2                     	andl	%r10d, %edx
    1165: 09 da                        	orl	%ebx, %edx
    1167: 44 01 f2                     	addl	%r14d, %edx
    116a: 89 cb                        	movl	%ecx, %ebx
    116c: c1 c3 1a                     	roll	$0x1a, %ebx
    116f: 44 01 ca                     	addl	%r9d, %edx
    1172: 41 89 c9                     	movl	%ecx, %r9d
    1175: 41 c1 c1 15                  	roll	$0x15, %r9d
    1179: 41 31 d9                     	xorl	%ebx, %r9d
    117c: 89 cb                        	movl	%ecx, %ebx
    117e: c1 c3 07                     	roll	$0x7, %ebx
    1181: 44 31 cb                     	xorl	%r9d, %ebx
    1184: 41 89 f1                     	movl	%esi, %r9d
    1187: 41 31 c1                     	xorl	%eax, %r9d
    118a: 41 21 c9                     	andl	%ecx, %r9d
    118d: 41 31 c1                     	xorl	%eax, %r9d
    1190: 44 03 9d ec fe ff ff         	addl	-0x114(%rbp), %r11d
    1197: 45 01 cb                     	addl	%r9d, %r11d
    119a: 46 8d 8c 1b d5 5e 1c ab      	leal	-0x54e3a12b(%rbx,%r11), %r9d
    11a2: 41 89 d3                     	movl	%edx, %r11d
    11a5: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    11a9: 45 01 ca                     	addl	%r9d, %r10d
    11ac: 89 d3                        	movl	%edx, %ebx
    11ae: c1 c3 13                     	roll	$0x13, %ebx
    11b1: 44 31 db                     	xorl	%r11d, %ebx
    11b4: 41 89 d6                     	movl	%edx, %r14d
    11b7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    11bb: 41 31 de                     	xorl	%ebx, %r14d
    11be: 44 89 c3                     	movl	%r8d, %ebx
    11c1: 09 fb                        	orl	%edi, %ebx
    11c3: 21 d3                        	andl	%edx, %ebx
    11c5: 45 89 c3                     	movl	%r8d, %r11d
    11c8: 41 21 fb                     	andl	%edi, %r11d
    11cb: 41 09 db                     	orl	%ebx, %r11d
    11ce: 45 01 f3                     	addl	%r14d, %r11d
    11d1: 45 01 cb                     	addl	%r9d, %r11d
    11d4: 45 89 d1                     	movl	%r10d, %r9d
    11d7: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    11db: 44 89 d3                     	movl	%r10d, %ebx
    11de: c1 c3 15                     	roll	$0x15, %ebx
    11e1: 44 31 cb                     	xorl	%r9d, %ebx
    11e4: 45 89 d1                     	movl	%r10d, %r9d
    11e7: 41 c1 c1 07                  	roll	$0x7, %r9d
    11eb: 41 31 d9                     	xorl	%ebx, %r9d
    11ee: 89 cb                        	movl	%ecx, %ebx
    11f0: 31 f3                        	xorl	%esi, %ebx
    11f2: 44 21 d3                     	andl	%r10d, %ebx
    11f5: 31 f3                        	xorl	%esi, %ebx
    11f7: 03 85 f0 fe ff ff            	addl	-0x110(%rbp), %eax
    11fd: 01 d8                        	addl	%ebx, %eax
    11ff: 41 8d 84 01 98 aa 07 d8      	leal	-0x27f85568(%r9,%rax), %eax
    1207: 01 c7                        	addl	%eax, %edi
    1209: 45 89 d9                     	movl	%r11d, %r9d
    120c: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1210: 44 89 db                     	movl	%r11d, %ebx
    1213: c1 c3 13                     	roll	$0x13, %ebx
    1216: 44 31 cb                     	xorl	%r9d, %ebx
    1219: 45 89 de                     	movl	%r11d, %r14d
    121c: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1220: 41 31 de                     	xorl	%ebx, %r14d
    1223: 89 d3                        	movl	%edx, %ebx
    1225: 44 09 c3                     	orl	%r8d, %ebx
    1228: 44 21 db                     	andl	%r11d, %ebx
    122b: 41 89 d1                     	movl	%edx, %r9d
    122e: 45 21 c1                     	andl	%r8d, %r9d
    1231: 41 09 d9                     	orl	%ebx, %r9d
    1234: 45 01 f1                     	addl	%r14d, %r9d
    1237: 41 01 c1                     	addl	%eax, %r9d
    123a: 89 f8                        	movl	%edi, %eax
    123c: c1 c0 1a                     	roll	$0x1a, %eax
    123f: 89 fb                        	movl	%edi, %ebx
    1241: c1 c3 15                     	roll	$0x15, %ebx
    1244: 31 c3                        	xorl	%eax, %ebx
    1246: 89 f8                        	movl	%edi, %eax
    1248: c1 c0 07                     	roll	$0x7, %eax
    124b: 31 d8                        	xorl	%ebx, %eax
    124d: 44 89 d3                     	movl	%r10d, %ebx
    1250: 31 cb                        	xorl	%ecx, %ebx
    1252: 21 fb                        	andl	%edi, %ebx
    1254: 03 b5 f4 fe ff ff            	addl	-0x10c(%rbp), %esi
    125a: 31 cb                        	xorl	%ecx, %ebx
    125c: 01 de                        	addl	%ebx, %esi
    125e: 8d 84 30 01 5b 83 12         	leal	0x12835b01(%rax,%rsi), %eax
    1265: 41 01 c0                     	addl	%eax, %r8d
    1268: 44 89 ce                     	movl	%r9d, %esi
    126b: c1 c6 1e                     	roll	$0x1e, %esi
    126e: 44 89 cb                     	movl	%r9d, %ebx
    1271: c1 c3 13                     	roll	$0x13, %ebx
    1274: 31 f3                        	xorl	%esi, %ebx
    1276: 45 89 ce                     	movl	%r9d, %r14d
    1279: 41 c1 c6 0a                  	roll	$0xa, %r14d
    127d: 41 31 de                     	xorl	%ebx, %r14d
    1280: 44 89 db                     	movl	%r11d, %ebx
    1283: 09 d3                        	orl	%edx, %ebx
    1285: 44 21 cb                     	andl	%r9d, %ebx
    1288: 44 89 de                     	movl	%r11d, %esi
    128b: 21 d6                        	andl	%edx, %esi
    128d: 09 de                        	orl	%ebx, %esi
    128f: 44 89 c3                     	movl	%r8d, %ebx
    1292: c1 c3 1a                     	roll	$0x1a, %ebx
    1295: 44 01 f6                     	addl	%r14d, %esi
    1298: 45 89 c6                     	movl	%r8d, %r14d
    129b: 41 c1 c6 15                  	roll	$0x15, %r14d
    129f: 01 c6                        	addl	%eax, %esi
    12a1: 44 89 c0                     	movl	%r8d, %eax
    12a4: c1 c0 07                     	roll	$0x7, %eax
    12a7: 41 31 de                     	xorl	%ebx, %r14d
    12aa: 44 31 f0                     	xorl	%r14d, %eax
    12ad: 89 fb                        	movl	%edi, %ebx
    12af: 44 31 d3                     	xorl	%r10d, %ebx
    12b2: 44 21 c3                     	andl	%r8d, %ebx
    12b5: 44 31 d3                     	xorl	%r10d, %ebx
    12b8: 03 8d f8 fe ff ff            	addl	-0x108(%rbp), %ecx
    12be: 01 d9                        	addl	%ebx, %ecx
    12c0: 89 f3                        	movl	%esi, %ebx
    12c2: c1 c3 1e                     	roll	$0x1e, %ebx
    12c5: 8d 8c 08 be 85 31 24         	leal	0x243185be(%rax,%rcx), %ecx
    12cc: 89 f0                        	movl	%esi, %eax
    12ce: c1 c0 13                     	roll	$0x13, %eax
    12d1: 01 ca                        	addl	%ecx, %edx
    12d3: 41 89 f6                     	movl	%esi, %r14d
    12d6: 41 c1 c6 0a                  	roll	$0xa, %r14d
    12da: 31 d8                        	xorl	%ebx, %eax
    12dc: 41 31 c6                     	xorl	%eax, %r14d
    12df: 44 89 cb                     	movl	%r9d, %ebx
    12e2: 44 09 db                     	orl	%r11d, %ebx
    12e5: 21 f3                        	andl	%esi, %ebx
    12e7: 44 89 c8                     	movl	%r9d, %eax
    12ea: 44 21 d8                     	andl	%r11d, %eax
    12ed: 09 d8                        	orl	%ebx, %eax
    12ef: 44 01 f0                     	addl	%r14d, %eax
    12f2: 89 d3                        	movl	%edx, %ebx
    12f4: c1 c3 1a                     	roll	$0x1a, %ebx
    12f7: 01 c8                        	addl	%ecx, %eax
    12f9: 89 d1                        	movl	%edx, %ecx
    12fb: c1 c1 15                     	roll	$0x15, %ecx
    12fe: 31 d9                        	xorl	%ebx, %ecx
    1300: 89 d3                        	movl	%edx, %ebx
    1302: c1 c3 07                     	roll	$0x7, %ebx
    1305: 31 cb                        	xorl	%ecx, %ebx
    1307: 44 89 c1                     	movl	%r8d, %ecx
    130a: 31 f9                        	xorl	%edi, %ecx
    130c: 21 d1                        	andl	%edx, %ecx
    130e: 31 f9                        	xorl	%edi, %ecx
    1310: 44 03 95 fc fe ff ff         	addl	-0x104(%rbp), %r10d
    1317: 41 01 ca                     	addl	%ecx, %r10d
    131a: 42 8d 8c 13 c3 7d 0c 55      	leal	0x550c7dc3(%rbx,%r10), %ecx
    1322: 41 89 c2                     	movl	%eax, %r10d
    1325: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1329: 41 01 cb                     	addl	%ecx, %r11d
    132c: 89 c3                        	movl	%eax, %ebx
    132e: c1 c3 13                     	roll	$0x13, %ebx
    1331: 44 31 d3                     	xorl	%r10d, %ebx
    1334: 41 89 c6                     	movl	%eax, %r14d
    1337: 41 c1 c6 0a                  	roll	$0xa, %r14d
    133b: 41 31 de                     	xorl	%ebx, %r14d
    133e: 89 f3                        	movl	%esi, %ebx
    1340: 44 09 cb                     	orl	%r9d, %ebx
    1343: 21 c3                        	andl	%eax, %ebx
    1345: 41 89 f2                     	movl	%esi, %r10d
    1348: 45 21 ca                     	andl	%r9d, %r10d
    134b: 41 09 da                     	orl	%ebx, %r10d
    134e: 45 01 f2                     	addl	%r14d, %r10d
    1351: 41 01 ca                     	addl	%ecx, %r10d
    1354: 44 89 d9                     	movl	%r11d, %ecx
    1357: c1 c1 1a                     	roll	$0x1a, %ecx
    135a: 44 89 db                     	movl	%r11d, %ebx
    135d: c1 c3 15                     	roll	$0x15, %ebx
    1360: 31 cb                        	xorl	%ecx, %ebx
    1362: 44 89 d9                     	movl	%r11d, %ecx
    1365: c1 c1 07                     	roll	$0x7, %ecx
    1368: 31 d9                        	xorl	%ebx, %ecx
    136a: 89 d3                        	movl	%edx, %ebx
    136c: 44 31 c3                     	xorl	%r8d, %ebx
    136f: 44 21 db                     	andl	%r11d, %ebx
    1372: 44 31 c3                     	xorl	%r8d, %ebx
    1375: 03 bd 00 ff ff ff            	addl	-0x100(%rbp), %edi
    137b: 01 df                        	addl	%ebx, %edi
    137d: 8d 8c 39 74 5d be 72         	leal	0x72be5d74(%rcx,%rdi), %ecx
    1384: 41 01 c9                     	addl	%ecx, %r9d
    1387: 44 89 d7                     	movl	%r10d, %edi
    138a: c1 c7 1e                     	roll	$0x1e, %edi
    138d: 44 89 d3                     	movl	%r10d, %ebx
    1390: c1 c3 13                     	roll	$0x13, %ebx
    1393: 31 fb                        	xorl	%edi, %ebx
    1395: 45 89 d6                     	movl	%r10d, %r14d
    1398: 41 c1 c6 0a                  	roll	$0xa, %r14d
    139c: 41 31 de                     	xorl	%ebx, %r14d
    139f: 89 c3                        	movl	%eax, %ebx
    13a1: 09 f3                        	orl	%esi, %ebx
    13a3: 44 21 d3                     	andl	%r10d, %ebx
    13a6: 89 c7                        	movl	%eax, %edi
    13a8: 21 f7                        	andl	%esi, %edi
    13aa: 09 df                        	orl	%ebx, %edi
    13ac: 44 01 f7                     	addl	%r14d, %edi
    13af: 01 cf                        	addl	%ecx, %edi
    13b1: 44 89 c9                     	movl	%r9d, %ecx
    13b4: c1 c1 1a                     	roll	$0x1a, %ecx
    13b7: 44 89 cb                     	movl	%r9d, %ebx
    13ba: c1 c3 15                     	roll	$0x15, %ebx
    13bd: 31 cb                        	xorl	%ecx, %ebx
    13bf: 44 89 c9                     	movl	%r9d, %ecx
    13c2: c1 c1 07                     	roll	$0x7, %ecx
    13c5: 31 d9                        	xorl	%ebx, %ecx
    13c7: 44 89 db                     	movl	%r11d, %ebx
    13ca: 31 d3                        	xorl	%edx, %ebx
    13cc: 44 21 cb                     	andl	%r9d, %ebx
    13cf: 44 03 85 04 ff ff ff         	addl	-0xfc(%rbp), %r8d
    13d6: 31 d3                        	xorl	%edx, %ebx
    13d8: 41 01 d8                     	addl	%ebx, %r8d
    13db: 42 8d 8c 01 fe b1 de 80      	leal	-0x7f214e02(%rcx,%r8), %ecx
    13e3: 01 ce                        	addl	%ecx, %esi
    13e5: 41 89 f8                     	movl	%edi, %r8d
    13e8: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    13ec: 89 fb                        	movl	%edi, %ebx
    13ee: c1 c3 13                     	roll	$0x13, %ebx
    13f1: 44 31 c3                     	xorl	%r8d, %ebx
    13f4: 41 89 fe                     	movl	%edi, %r14d
    13f7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    13fb: 41 31 de                     	xorl	%ebx, %r14d
    13fe: 44 89 d3                     	movl	%r10d, %ebx
    1401: 09 c3                        	orl	%eax, %ebx
    1403: 21 fb                        	andl	%edi, %ebx
    1405: 45 89 d0                     	movl	%r10d, %r8d
    1408: 41 21 c0                     	andl	%eax, %r8d
    140b: 41 09 d8                     	orl	%ebx, %r8d
    140e: 89 f3                        	movl	%esi, %ebx
    1410: c1 c3 1a                     	roll	$0x1a, %ebx
    1413: 45 01 f0                     	addl	%r14d, %r8d
    1416: 41 89 f6                     	movl	%esi, %r14d
    1419: 41 c1 c6 15                  	roll	$0x15, %r14d
    141d: 41 01 c8                     	addl	%ecx, %r8d
    1420: 89 f1                        	movl	%esi, %ecx
    1422: c1 c1 07                     	roll	$0x7, %ecx
    1425: 41 31 de                     	xorl	%ebx, %r14d
    1428: 44 31 f1                     	xorl	%r14d, %ecx
    142b: 44 89 cb                     	movl	%r9d, %ebx
    142e: 44 31 db                     	xorl	%r11d, %ebx
    1431: 21 f3                        	andl	%esi, %ebx
    1433: 44 31 db                     	xorl	%r11d, %ebx
    1436: 03 95 08 ff ff ff            	addl	-0xf8(%rbp), %edx
    143c: 01 da                        	addl	%ebx, %edx
    143e: 44 89 c3                     	movl	%r8d, %ebx
    1441: c1 c3 1e                     	roll	$0x1e, %ebx
    1444: 8d 94 11 a7 06 dc 9b         	leal	-0x6423f959(%rcx,%rdx), %edx
    144b: 44 89 c1                     	movl	%r8d, %ecx
    144e: c1 c1 13                     	roll	$0x13, %ecx
    1451: 01 d0                        	addl	%edx, %eax
    1453: 45 89 c6                     	movl	%r8d, %r14d
    1456: 41 c1 c6 0a                  	roll	$0xa, %r14d
    145a: 31 d9                        	xorl	%ebx, %ecx
    145c: 41 31 ce                     	xorl	%ecx, %r14d
    145f: 89 fb                        	movl	%edi, %ebx
    1461: 44 09 d3                     	orl	%r10d, %ebx
    1464: 44 21 c3                     	andl	%r8d, %ebx
    1467: 89 f9                        	movl	%edi, %ecx
    1469: 44 21 d1                     	andl	%r10d, %ecx
    146c: 09 d9                        	orl	%ebx, %ecx
    146e: 44 01 f1                     	addl	%r14d, %ecx
    1471: 89 c3                        	movl	%eax, %ebx
    1473: c1 c3 1a                     	roll	$0x1a, %ebx
    1476: 01 d1                        	addl	%edx, %ecx
    1478: 89 c2                        	movl	%eax, %edx
    147a: c1 c2 15                     	roll	$0x15, %edx
    147d: 31 da                        	xorl	%ebx, %edx
    147f: 89 c3                        	movl	%eax, %ebx
    1481: c1 c3 07                     	roll	$0x7, %ebx
    1484: 31 d3                        	xorl	%edx, %ebx
    1486: 89 f2                        	movl	%esi, %edx
    1488: 44 31 ca                     	xorl	%r9d, %edx
    148b: 21 c2                        	andl	%eax, %edx
    148d: 44 31 ca                     	xorl	%r9d, %edx
    1490: 44 03 9d 0c ff ff ff         	addl	-0xf4(%rbp), %r11d
    1497: 41 01 d3                     	addl	%edx, %r11d
    149a: 42 8d 94 1b 74 f1 9b c1      	leal	-0x3e640e8c(%rbx,%r11), %edx
    14a2: 41 89 cb                     	movl	%ecx, %r11d
    14a5: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    14a9: 41 01 d2                     	addl	%edx, %r10d
    14ac: 89 cb                        	movl	%ecx, %ebx
    14ae: c1 c3 13                     	roll	$0x13, %ebx
    14b1: 44 31 db                     	xorl	%r11d, %ebx
    14b4: 41 89 ce                     	movl	%ecx, %r14d
    14b7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    14bb: 41 31 de                     	xorl	%ebx, %r14d
    14be: 44 89 c3                     	movl	%r8d, %ebx
    14c1: 09 fb                        	orl	%edi, %ebx
    14c3: 21 cb                        	andl	%ecx, %ebx
    14c5: 45 89 c3                     	movl	%r8d, %r11d
    14c8: 41 21 fb                     	andl	%edi, %r11d
    14cb: 41 09 db                     	orl	%ebx, %r11d
    14ce: 45 01 f3                     	addl	%r14d, %r11d
    14d1: 41 01 d3                     	addl	%edx, %r11d
    14d4: 44 89 d2                     	movl	%r10d, %edx
    14d7: c1 c2 1a                     	roll	$0x1a, %edx
    14da: 44 89 d3                     	movl	%r10d, %ebx
    14dd: c1 c3 15                     	roll	$0x15, %ebx
    14e0: 31 d3                        	xorl	%edx, %ebx
    14e2: 44 89 d2                     	movl	%r10d, %edx
    14e5: c1 c2 07                     	roll	$0x7, %edx
    14e8: 31 da                        	xorl	%ebx, %edx
    14ea: 89 c3                        	movl	%eax, %ebx
    14ec: 31 f3                        	xorl	%esi, %ebx
    14ee: 44 21 d3                     	andl	%r10d, %ebx
    14f1: 31 f3                        	xorl	%esi, %ebx
    14f3: 44 03 8d 10 ff ff ff         	addl	-0xf0(%rbp), %r9d
    14fa: 41 01 d9                     	addl	%ebx, %r9d
    14fd: 46 8d 8c 0a c1 69 9b e4      	leal	-0x1b64963f(%rdx,%r9), %r9d
    1505: 44 01 cf                     	addl	%r9d, %edi
    1508: 44 89 da                     	movl	%r11d, %edx
    150b: c1 c2 1e                     	roll	$0x1e, %edx
    150e: 44 89 db                     	movl	%r11d, %ebx
    1511: c1 c3 13                     	roll	$0x13, %ebx
    1514: 31 d3                        	xorl	%edx, %ebx
    1516: 45 89 de                     	movl	%r11d, %r14d
    1519: 41 c1 c6 0a                  	roll	$0xa, %r14d
    151d: 41 31 de                     	xorl	%ebx, %r14d
    1520: 89 cb                        	movl	%ecx, %ebx
    1522: 44 09 c3                     	orl	%r8d, %ebx
    1525: 44 21 db                     	andl	%r11d, %ebx
    1528: 89 ca                        	movl	%ecx, %edx
    152a: 44 21 c2                     	andl	%r8d, %edx
    152d: 09 da                        	orl	%ebx, %edx
    152f: 44 01 f2                     	addl	%r14d, %edx
    1532: 44 01 ca                     	addl	%r9d, %edx
    1535: 41 89 f9                     	movl	%edi, %r9d
    1538: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    153c: 89 fb                        	movl	%edi, %ebx
    153e: c1 c3 15                     	roll	$0x15, %ebx
    1541: 44 31 cb                     	xorl	%r9d, %ebx
    1544: 41 89 f9                     	movl	%edi, %r9d
    1547: 41 c1 c1 07                  	roll	$0x7, %r9d
    154b: 41 31 d9                     	xorl	%ebx, %r9d
    154e: 44 89 d3                     	movl	%r10d, %ebx
    1551: 31 c3                        	xorl	%eax, %ebx
    1553: 21 fb                        	andl	%edi, %ebx
    1555: 03 b5 14 ff ff ff            	addl	-0xec(%rbp), %esi
    155b: 31 c3                        	xorl	%eax, %ebx
    155d: 01 de                        	addl	%ebx, %esi
    155f: 45 8d 8c 31 86 47 be ef      	leal	-0x1041b87a(%r9,%rsi), %r9d
    1567: 45 01 c8                     	addl	%r9d, %r8d
    156a: 89 d6                        	movl	%edx, %esi
    156c: c1 c6 1e                     	roll	$0x1e, %esi
    156f: 89 d3                        	movl	%edx, %ebx
    1571: c1 c3 13                     	roll	$0x13, %ebx
    1574: 31 f3                        	xorl	%esi, %ebx
    1576: 41 89 d6                     	movl	%edx, %r14d
    1579: 41 c1 c6 0a                  	roll	$0xa, %r14d
    157d: 41 31 de                     	xorl	%ebx, %r14d
    1580: 44 89 db                     	movl	%r11d, %ebx
    1583: 09 cb                        	orl	%ecx, %ebx
    1585: 21 d3                        	andl	%edx, %ebx
    1587: 44 89 de                     	movl	%r11d, %esi
    158a: 21 ce                        	andl	%ecx, %esi
    158c: 09 de                        	orl	%ebx, %esi
    158e: 44 89 c3                     	movl	%r8d, %ebx
    1591: c1 c3 1a                     	roll	$0x1a, %ebx
    1594: 44 01 f6                     	addl	%r14d, %esi
    1597: 45 89 c6                     	movl	%r8d, %r14d
    159a: 41 c1 c6 15                  	roll	$0x15, %r14d
    159e: 44 01 ce                     	addl	%r9d, %esi
    15a1: 45 89 c1                     	movl	%r8d, %r9d
    15a4: 41 c1 c1 07                  	roll	$0x7, %r9d
    15a8: 41 31 de                     	xorl	%ebx, %r14d
    15ab: 45 31 f1                     	xorl	%r14d, %r9d
    15ae: 89 fb                        	movl	%edi, %ebx
    15b0: 44 31 d3                     	xorl	%r10d, %ebx
    15b3: 44 21 c3                     	andl	%r8d, %ebx
    15b6: 44 31 d3                     	xorl	%r10d, %ebx
    15b9: 03 85 18 ff ff ff            	addl	-0xe8(%rbp), %eax
    15bf: 01 d8                        	addl	%ebx, %eax
    15c1: 89 f3                        	movl	%esi, %ebx
    15c3: c1 c3 1e                     	roll	$0x1e, %ebx
    15c6: 45 8d 8c 01 c6 9d c1 0f      	leal	0xfc19dc6(%r9,%rax), %r9d
    15ce: 89 f0                        	movl	%esi, %eax
    15d0: c1 c0 13                     	roll	$0x13, %eax
    15d3: 44 01 c9                     	addl	%r9d, %ecx
    15d6: 41 89 f6                     	movl	%esi, %r14d
    15d9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    15dd: 31 d8                        	xorl	%ebx, %eax
    15df: 41 31 c6                     	xorl	%eax, %r14d
    15e2: 89 d3                        	movl	%edx, %ebx
    15e4: 44 09 db                     	orl	%r11d, %ebx
    15e7: 21 f3                        	andl	%esi, %ebx
    15e9: 89 d0                        	movl	%edx, %eax
    15eb: 44 21 d8                     	andl	%r11d, %eax
    15ee: 09 d8                        	orl	%ebx, %eax
    15f0: 44 01 f0                     	addl	%r14d, %eax
    15f3: 89 cb                        	movl	%ecx, %ebx
    15f5: c1 c3 1a                     	roll	$0x1a, %ebx
    15f8: 44 01 c8                     	addl	%r9d, %eax
    15fb: 41 89 c9                     	movl	%ecx, %r9d
    15fe: 41 c1 c1 15                  	roll	$0x15, %r9d
    1602: 41 31 d9                     	xorl	%ebx, %r9d
    1605: 89 cb                        	movl	%ecx, %ebx
    1607: c1 c3 07                     	roll	$0x7, %ebx
    160a: 44 31 cb                     	xorl	%r9d, %ebx
    160d: 45 89 c1                     	movl	%r8d, %r9d
    1610: 41 31 f9                     	xorl	%edi, %r9d
    1613: 41 21 c9                     	andl	%ecx, %r9d
    1616: 41 31 f9                     	xorl	%edi, %r9d
    1619: 44 03 95 1c ff ff ff         	addl	-0xe4(%rbp), %r10d
    1620: 45 01 ca                     	addl	%r9d, %r10d
    1623: 46 8d 94 13 cc a1 0c 24      	leal	0x240ca1cc(%rbx,%r10), %r10d
    162b: 41 89 c1                     	movl	%eax, %r9d
    162e: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1632: 45 01 d3                     	addl	%r10d, %r11d
    1635: 89 c3                        	movl	%eax, %ebx
    1637: c1 c3 13                     	roll	$0x13, %ebx
    163a: 44 31 cb                     	xorl	%r9d, %ebx
    163d: 41 89 c6                     	movl	%eax, %r14d
    1640: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1644: 41 31 de                     	xorl	%ebx, %r14d
    1647: 89 f3                        	movl	%esi, %ebx
    1649: 09 d3                        	orl	%edx, %ebx
    164b: 21 c3                        	andl	%eax, %ebx
    164d: 41 89 f1                     	movl	%esi, %r9d
    1650: 41 21 d1                     	andl	%edx, %r9d
    1653: 41 09 d9                     	orl	%ebx, %r9d
    1656: 45 01 f1                     	addl	%r14d, %r9d
    1659: 45 01 d1                     	addl	%r10d, %r9d
    165c: 45 89 da                     	movl	%r11d, %r10d
    165f: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    1663: 44 89 db                     	movl	%r11d, %ebx
    1666: c1 c3 15                     	roll	$0x15, %ebx
    1669: 44 31 d3                     	xorl	%r10d, %ebx
    166c: 45 89 da                     	movl	%r11d, %r10d
    166f: 41 c1 c2 07                  	roll	$0x7, %r10d
    1673: 41 31 da                     	xorl	%ebx, %r10d
    1676: 89 cb                        	movl	%ecx, %ebx
    1678: 44 31 c3                     	xorl	%r8d, %ebx
    167b: 44 21 db                     	andl	%r11d, %ebx
    167e: 44 31 c3                     	xorl	%r8d, %ebx
    1681: 03 bd 20 ff ff ff            	addl	-0xe0(%rbp), %edi
    1687: 01 df                        	addl	%ebx, %edi
    1689: 45 8d 94 3a 6f 2c e9 2d      	leal	0x2de92c6f(%r10,%rdi), %r10d
    1691: 44 01 d2                     	addl	%r10d, %edx
    1694: 44 89 cf                     	movl	%r9d, %edi
    1697: c1 c7 1e                     	roll	$0x1e, %edi
    169a: 44 89 cb                     	movl	%r9d, %ebx
    169d: c1 c3 13                     	roll	$0x13, %ebx
    16a0: 31 fb                        	xorl	%edi, %ebx
    16a2: 45 89 ce                     	movl	%r9d, %r14d
    16a5: 41 c1 c6 0a                  	roll	$0xa, %r14d
    16a9: 41 31 de                     	xorl	%ebx, %r14d
    16ac: 89 c3                        	movl	%eax, %ebx
    16ae: 09 f3                        	orl	%esi, %ebx
    16b0: 44 21 cb                     	andl	%r9d, %ebx
    16b3: 89 c7                        	movl	%eax, %edi
    16b5: 21 f7                        	andl	%esi, %edi
    16b7: 09 df                        	orl	%ebx, %edi
    16b9: 44 01 f7                     	addl	%r14d, %edi
    16bc: 44 01 d7                     	addl	%r10d, %edi
    16bf: 41 89 d2                     	movl	%edx, %r10d
    16c2: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    16c6: 89 d3                        	movl	%edx, %ebx
    16c8: c1 c3 15                     	roll	$0x15, %ebx
    16cb: 44 31 d3                     	xorl	%r10d, %ebx
    16ce: 41 89 d2                     	movl	%edx, %r10d
    16d1: 41 c1 c2 07                  	roll	$0x7, %r10d
    16d5: 41 31 da                     	xorl	%ebx, %r10d
    16d8: 44 89 db                     	movl	%r11d, %ebx
    16db: 31 cb                        	xorl	%ecx, %ebx
    16dd: 21 d3                        	andl	%edx, %ebx
    16df: 44 03 85 24 ff ff ff         	addl	-0xdc(%rbp), %r8d
    16e6: 31 cb                        	xorl	%ecx, %ebx
    16e8: 41 01 d8                     	addl	%ebx, %r8d
    16eb: 47 8d 94 02 aa 84 74 4a      	leal	0x4a7484aa(%r10,%r8), %r10d
    16f3: 44 01 d6                     	addl	%r10d, %esi
    16f6: 41 89 f8                     	movl	%edi, %r8d
    16f9: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    16fd: 89 fb                        	movl	%edi, %ebx
    16ff: c1 c3 13                     	roll	$0x13, %ebx
    1702: 44 31 c3                     	xorl	%r8d, %ebx
    1705: 41 89 fe                     	movl	%edi, %r14d
    1708: 41 c1 c6 0a                  	roll	$0xa, %r14d
    170c: 41 31 de                     	xorl	%ebx, %r14d
    170f: 44 89 cb                     	movl	%r9d, %ebx
    1712: 09 c3                        	orl	%eax, %ebx
    1714: 21 fb                        	andl	%edi, %ebx
    1716: 45 89 c8                     	movl	%r9d, %r8d
    1719: 41 21 c0                     	andl	%eax, %r8d
    171c: 41 09 d8                     	orl	%ebx, %r8d
    171f: 89 f3                        	movl	%esi, %ebx
    1721: c1 c3 1a                     	roll	$0x1a, %ebx
    1724: 45 01 f0                     	addl	%r14d, %r8d
    1727: 41 89 f6                     	movl	%esi, %r14d
    172a: 41 c1 c6 15                  	roll	$0x15, %r14d
    172e: 45 01 d0                     	addl	%r10d, %r8d
    1731: 41 89 f2                     	movl	%esi, %r10d
    1734: 41 c1 c2 07                  	roll	$0x7, %r10d
    1738: 41 31 de                     	xorl	%ebx, %r14d
    173b: 45 31 f2                     	xorl	%r14d, %r10d
    173e: 89 d3                        	movl	%edx, %ebx
    1740: 44 31 db                     	xorl	%r11d, %ebx
    1743: 21 f3                        	andl	%esi, %ebx
    1745: 44 31 db                     	xorl	%r11d, %ebx
    1748: 03 8d 28 ff ff ff            	addl	-0xd8(%rbp), %ecx
    174e: 01 d9                        	addl	%ebx, %ecx
    1750: 44 89 c3                     	movl	%r8d, %ebx
    1753: c1 c3 1e                     	roll	$0x1e, %ebx
    1756: 45 8d 94 0a dc a9 b0 5c      	leal	0x5cb0a9dc(%r10,%rcx), %r10d
    175e: 44 89 c1                     	movl	%r8d, %ecx
    1761: c1 c1 13                     	roll	$0x13, %ecx
    1764: 44 01 d0                     	addl	%r10d, %eax
    1767: 45 89 c6                     	movl	%r8d, %r14d
    176a: 41 c1 c6 0a                  	roll	$0xa, %r14d
    176e: 31 d9                        	xorl	%ebx, %ecx
    1770: 41 31 ce                     	xorl	%ecx, %r14d
    1773: 89 fb                        	movl	%edi, %ebx
    1775: 44 09 cb                     	orl	%r9d, %ebx
    1778: 44 21 c3                     	andl	%r8d, %ebx
    177b: 89 f9                        	movl	%edi, %ecx
    177d: 44 21 c9                     	andl	%r9d, %ecx
    1780: 09 d9                        	orl	%ebx, %ecx
    1782: 44 01 f1                     	addl	%r14d, %ecx
    1785: 89 c3                        	movl	%eax, %ebx
    1787: c1 c3 1a                     	roll	$0x1a, %ebx
    178a: 44 01 d1                     	addl	%r10d, %ecx
    178d: 41 89 c2                     	movl	%eax, %r10d
    1790: 41 c1 c2 15                  	roll	$0x15, %r10d
    1794: 41 31 da                     	xorl	%ebx, %r10d
    1797: 89 c3                        	movl	%eax, %ebx
    1799: c1 c3 07                     	roll	$0x7, %ebx
    179c: 44 31 d3                     	xorl	%r10d, %ebx
    179f: 41 89 f2                     	movl	%esi, %r10d
    17a2: 41 31 d2                     	xorl	%edx, %r10d
    17a5: 41 21 c2                     	andl	%eax, %r10d
    17a8: 41 31 d2                     	xorl	%edx, %r10d
    17ab: 44 03 9d 2c ff ff ff         	addl	-0xd4(%rbp), %r11d
    17b2: 45 01 d3                     	addl	%r10d, %r11d
    17b5: 46 8d 9c 1b da 88 f9 76      	leal	0x76f988da(%rbx,%r11), %r11d
    17bd: 41 89 ca                     	movl	%ecx, %r10d
    17c0: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    17c4: 45 01 d9                     	addl	%r11d, %r9d
    17c7: 89 cb                        	movl	%ecx, %ebx
    17c9: c1 c3 13                     	roll	$0x13, %ebx
    17cc: 44 31 d3                     	xorl	%r10d, %ebx
    17cf: 41 89 ce                     	movl	%ecx, %r14d
    17d2: 41 c1 c6 0a                  	roll	$0xa, %r14d
    17d6: 41 31 de                     	xorl	%ebx, %r14d
    17d9: 44 89 c3                     	movl	%r8d, %ebx
    17dc: 09 fb                        	orl	%edi, %ebx
    17de: 21 cb                        	andl	%ecx, %ebx
    17e0: 45 89 c2                     	movl	%r8d, %r10d
    17e3: 41 21 fa                     	andl	%edi, %r10d
    17e6: 41 09 da                     	orl	%ebx, %r10d
    17e9: 45 01 f2                     	addl	%r14d, %r10d
    17ec: 45 01 da                     	addl	%r11d, %r10d
    17ef: 45 89 cb                     	movl	%r9d, %r11d
    17f2: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    17f6: 44 89 cb                     	movl	%r9d, %ebx
    17f9: c1 c3 15                     	roll	$0x15, %ebx
    17fc: 44 31 db                     	xorl	%r11d, %ebx
    17ff: 45 89 cb                     	movl	%r9d, %r11d
    1802: 41 c1 c3 07                  	roll	$0x7, %r11d
    1806: 41 31 db                     	xorl	%ebx, %r11d
    1809: 89 c3                        	movl	%eax, %ebx
    180b: 31 f3                        	xorl	%esi, %ebx
    180d: 44 21 cb                     	andl	%r9d, %ebx
    1810: 31 f3                        	xorl	%esi, %ebx
    1812: 03 95 30 ff ff ff            	addl	-0xd0(%rbp), %edx
    1818: 01 da                        	addl	%ebx, %edx
    181a: 45 8d 9c 13 52 51 3e 98      	leal	-0x67c1aeae(%r11,%rdx), %r11d
    1822: 44 01 df                     	addl	%r11d, %edi
    1825: 44 89 d2                     	movl	%r10d, %edx
    1828: c1 c2 1e                     	roll	$0x1e, %edx
    182b: 44 89 d3                     	movl	%r10d, %ebx
    182e: c1 c3 13                     	roll	$0x13, %ebx
    1831: 31 d3                        	xorl	%edx, %ebx
    1833: 45 89 d6                     	movl	%r10d, %r14d
    1836: 41 c1 c6 0a                  	roll	$0xa, %r14d
    183a: 41 31 de                     	xorl	%ebx, %r14d
    183d: 89 cb                        	movl	%ecx, %ebx
    183f: 44 09 c3                     	orl	%r8d, %ebx
    1842: 44 21 d3                     	andl	%r10d, %ebx
    1845: 89 ca                        	movl	%ecx, %edx
    1847: 44 21 c2                     	andl	%r8d, %edx
    184a: 09 da                        	orl	%ebx, %edx
    184c: 44 01 f2                     	addl	%r14d, %edx
    184f: 44 01 da                     	addl	%r11d, %edx
    1852: 41 89 fb                     	movl	%edi, %r11d
    1855: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1859: 89 fb                        	movl	%edi, %ebx
    185b: c1 c3 15                     	roll	$0x15, %ebx
    185e: 44 31 db                     	xorl	%r11d, %ebx
    1861: 41 89 fb                     	movl	%edi, %r11d
    1864: 41 c1 c3 07                  	roll	$0x7, %r11d
    1868: 41 31 db                     	xorl	%ebx, %r11d
    186b: 44 89 cb                     	movl	%r9d, %ebx
    186e: 31 c3                        	xorl	%eax, %ebx
    1870: 21 fb                        	andl	%edi, %ebx
    1872: 03 b5 34 ff ff ff            	addl	-0xcc(%rbp), %esi
    1878: 31 c3                        	xorl	%eax, %ebx
    187a: 01 de                        	addl	%ebx, %esi
    187c: 45 8d 9c 33 6d c6 31 a8      	leal	-0x57ce3993(%r11,%rsi), %r11d
    1884: 45 01 d8                     	addl	%r11d, %r8d
    1887: 89 d6                        	movl	%edx, %esi
    1889: c1 c6 1e                     	roll	$0x1e, %esi
    188c: 89 d3                        	movl	%edx, %ebx
    188e: c1 c3 13                     	roll	$0x13, %ebx
    1891: 31 f3                        	xorl	%esi, %ebx
    1893: 41 89 d6                     	movl	%edx, %r14d
    1896: 41 c1 c6 0a                  	roll	$0xa, %r14d
    189a: 41 31 de                     	xorl	%ebx, %r14d
    189d: 44 89 d3                     	movl	%r10d, %ebx
    18a0: 09 cb                        	orl	%ecx, %ebx
    18a2: 21 d3                        	andl	%edx, %ebx
    18a4: 44 89 d6                     	movl	%r10d, %esi
    18a7: 21 ce                        	andl	%ecx, %esi
    18a9: 09 de                        	orl	%ebx, %esi
    18ab: 44 89 c3                     	movl	%r8d, %ebx
    18ae: c1 c3 1a                     	roll	$0x1a, %ebx
    18b1: 44 01 f6                     	addl	%r14d, %esi
    18b4: 45 89 c6                     	movl	%r8d, %r14d
    18b7: 41 c1 c6 15                  	roll	$0x15, %r14d
    18bb: 44 01 de                     	addl	%r11d, %esi
    18be: 45 89 c3                     	movl	%r8d, %r11d
    18c1: 41 c1 c3 07                  	roll	$0x7, %r11d
    18c5: 41 31 de                     	xorl	%ebx, %r14d
    18c8: 45 31 f3                     	xorl	%r14d, %r11d
    18cb: 89 fb                        	movl	%edi, %ebx
    18cd: 44 31 cb                     	xorl	%r9d, %ebx
    18d0: 44 21 c3                     	andl	%r8d, %ebx
    18d3: 44 31 cb                     	xorl	%r9d, %ebx
    18d6: 03 85 38 ff ff ff            	addl	-0xc8(%rbp), %eax
    18dc: 01 d8                        	addl	%ebx, %eax
    18de: 89 f3                        	movl	%esi, %ebx
    18e0: c1 c3 1e                     	roll	$0x1e, %ebx
    18e3: 45 8d 9c 03 c8 27 03 b0      	leal	-0x4ffcd838(%r11,%rax), %r11d
    18eb: 89 f0                        	movl	%esi, %eax
    18ed: c1 c0 13                     	roll	$0x13, %eax
    18f0: 44 01 d9                     	addl	%r11d, %ecx
    18f3: 41 89 f6                     	movl	%esi, %r14d
    18f6: 41 c1 c6 0a                  	roll	$0xa, %r14d
    18fa: 31 d8                        	xorl	%ebx, %eax
    18fc: 41 31 c6                     	xorl	%eax, %r14d
    18ff: 89 d3                        	movl	%edx, %ebx
    1901: 44 09 d3                     	orl	%r10d, %ebx
    1904: 21 f3                        	andl	%esi, %ebx
    1906: 89 d0                        	movl	%edx, %eax
    1908: 44 21 d0                     	andl	%r10d, %eax
    190b: 09 d8                        	orl	%ebx, %eax
    190d: 44 01 f0                     	addl	%r14d, %eax
    1910: 89 cb                        	movl	%ecx, %ebx
    1912: c1 c3 1a                     	roll	$0x1a, %ebx
    1915: 44 01 d8                     	addl	%r11d, %eax
    1918: 41 89 cb                     	movl	%ecx, %r11d
    191b: 41 c1 c3 15                  	roll	$0x15, %r11d
    191f: 41 31 db                     	xorl	%ebx, %r11d
    1922: 89 cb                        	movl	%ecx, %ebx
    1924: c1 c3 07                     	roll	$0x7, %ebx
    1927: 44 31 db                     	xorl	%r11d, %ebx
    192a: 45 89 c3                     	movl	%r8d, %r11d
    192d: 41 31 fb                     	xorl	%edi, %r11d
    1930: 41 21 cb                     	andl	%ecx, %r11d
    1933: 41 31 fb                     	xorl	%edi, %r11d
    1936: 44 03 8d 3c ff ff ff         	addl	-0xc4(%rbp), %r9d
    193d: 45 01 d9                     	addl	%r11d, %r9d
    1940: 46 8d 9c 0b c7 7f 59 bf      	leal	-0x40a68039(%rbx,%r9), %r11d
    1948: 41 89 c1                     	movl	%eax, %r9d
    194b: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    194f: 45 01 da                     	addl	%r11d, %r10d
    1952: 89 c3                        	movl	%eax, %ebx
    1954: c1 c3 13                     	roll	$0x13, %ebx
    1957: 44 31 cb                     	xorl	%r9d, %ebx
    195a: 41 89 c6                     	movl	%eax, %r14d
    195d: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1961: 41 31 de                     	xorl	%ebx, %r14d
    1964: 89 f3                        	movl	%esi, %ebx
    1966: 09 d3                        	orl	%edx, %ebx
    1968: 21 c3                        	andl	%eax, %ebx
    196a: 41 89 f1                     	movl	%esi, %r9d
    196d: 41 21 d1                     	andl	%edx, %r9d
    1970: 41 09 d9                     	orl	%ebx, %r9d
    1973: 45 01 f1                     	addl	%r14d, %r9d
    1976: 45 01 d9                     	addl	%r11d, %r9d
    1979: 45 89 d3                     	movl	%r10d, %r11d
    197c: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1980: 44 89 d3                     	movl	%r10d, %ebx
    1983: c1 c3 15                     	roll	$0x15, %ebx
    1986: 44 31 db                     	xorl	%r11d, %ebx
    1989: 45 89 d3                     	movl	%r10d, %r11d
    198c: 41 c1 c3 07                  	roll	$0x7, %r11d
    1990: 41 31 db                     	xorl	%ebx, %r11d
    1993: 89 cb                        	movl	%ecx, %ebx
    1995: 44 31 c3                     	xorl	%r8d, %ebx
    1998: 44 21 d3                     	andl	%r10d, %ebx
    199b: 44 31 c3                     	xorl	%r8d, %ebx
    199e: 03 bd 40 ff ff ff            	addl	-0xc0(%rbp), %edi
    19a4: 01 df                        	addl	%ebx, %edi
    19a6: 45 8d 9c 3b f3 0b e0 c6      	leal	-0x391ff40d(%r11,%rdi), %r11d
    19ae: 44 01 da                     	addl	%r11d, %edx
    19b1: 44 89 cf                     	movl	%r9d, %edi
    19b4: c1 c7 1e                     	roll	$0x1e, %edi
    19b7: 44 89 cb                     	movl	%r9d, %ebx
    19ba: c1 c3 13                     	roll	$0x13, %ebx
    19bd: 31 fb                        	xorl	%edi, %ebx
    19bf: 45 89 ce                     	movl	%r9d, %r14d
    19c2: 41 c1 c6 0a                  	roll	$0xa, %r14d
    19c6: 41 31 de                     	xorl	%ebx, %r14d
    19c9: 89 c3                        	movl	%eax, %ebx
    19cb: 09 f3                        	orl	%esi, %ebx
    19cd: 44 21 cb                     	andl	%r9d, %ebx
    19d0: 89 c7                        	movl	%eax, %edi
    19d2: 21 f7                        	andl	%esi, %edi
    19d4: 09 df                        	orl	%ebx, %edi
    19d6: 44 01 f7                     	addl	%r14d, %edi
    19d9: 44 01 df                     	addl	%r11d, %edi
    19dc: 41 89 d3                     	movl	%edx, %r11d
    19df: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    19e3: 89 d3                        	movl	%edx, %ebx
    19e5: c1 c3 15                     	roll	$0x15, %ebx
    19e8: 44 31 db                     	xorl	%r11d, %ebx
    19eb: 41 89 d3                     	movl	%edx, %r11d
    19ee: 41 c1 c3 07                  	roll	$0x7, %r11d
    19f2: 41 31 db                     	xorl	%ebx, %r11d
    19f5: 44 89 d3                     	movl	%r10d, %ebx
    19f8: 31 cb                        	xorl	%ecx, %ebx
    19fa: 21 d3                        	andl	%edx, %ebx
    19fc: 44 03 85 44 ff ff ff         	addl	-0xbc(%rbp), %r8d
    1a03: 31 cb                        	xorl	%ecx, %ebx
    1a05: 41 01 d8                     	addl	%ebx, %r8d
    1a08: 47 8d 9c 03 47 91 a7 d5      	leal	-0x2a586eb9(%r11,%r8), %r11d
    1a10: 44 01 de                     	addl	%r11d, %esi
    1a13: 41 89 f8                     	movl	%edi, %r8d
    1a16: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1a1a: 89 fb                        	movl	%edi, %ebx
    1a1c: c1 c3 13                     	roll	$0x13, %ebx
    1a1f: 44 31 c3                     	xorl	%r8d, %ebx
    1a22: 41 89 fe                     	movl	%edi, %r14d
    1a25: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1a29: 41 31 de                     	xorl	%ebx, %r14d
    1a2c: 44 89 cb                     	movl	%r9d, %ebx
    1a2f: 09 c3                        	orl	%eax, %ebx
    1a31: 21 fb                        	andl	%edi, %ebx
    1a33: 45 89 c8                     	movl	%r9d, %r8d
    1a36: 41 21 c0                     	andl	%eax, %r8d
    1a39: 41 09 d8                     	orl	%ebx, %r8d
    1a3c: 89 f3                        	movl	%esi, %ebx
    1a3e: c1 c3 1a                     	roll	$0x1a, %ebx
    1a41: 45 01 f0                     	addl	%r14d, %r8d
    1a44: 41 89 f6                     	movl	%esi, %r14d
    1a47: 41 c1 c6 15                  	roll	$0x15, %r14d
    1a4b: 45 01 d8                     	addl	%r11d, %r8d
    1a4e: 41 89 f3                     	movl	%esi, %r11d
    1a51: 41 c1 c3 07                  	roll	$0x7, %r11d
    1a55: 41 31 de                     	xorl	%ebx, %r14d
    1a58: 45 31 f3                     	xorl	%r14d, %r11d
    1a5b: 89 d3                        	movl	%edx, %ebx
    1a5d: 44 31 d3                     	xorl	%r10d, %ebx
    1a60: 21 f3                        	andl	%esi, %ebx
    1a62: 44 31 d3                     	xorl	%r10d, %ebx
    1a65: 03 8d 48 ff ff ff            	addl	-0xb8(%rbp), %ecx
    1a6b: 01 d9                        	addl	%ebx, %ecx
    1a6d: 44 89 c3                     	movl	%r8d, %ebx
    1a70: c1 c3 1e                     	roll	$0x1e, %ebx
    1a73: 45 8d 9c 0b 51 63 ca 06      	leal	0x6ca6351(%r11,%rcx), %r11d
    1a7b: 44 89 c1                     	movl	%r8d, %ecx
    1a7e: c1 c1 13                     	roll	$0x13, %ecx
    1a81: 44 01 d8                     	addl	%r11d, %eax
    1a84: 45 89 c6                     	movl	%r8d, %r14d
    1a87: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1a8b: 31 d9                        	xorl	%ebx, %ecx
    1a8d: 41 31 ce                     	xorl	%ecx, %r14d
    1a90: 89 fb                        	movl	%edi, %ebx
    1a92: 44 09 cb                     	orl	%r9d, %ebx
    1a95: 44 21 c3                     	andl	%r8d, %ebx
    1a98: 89 f9                        	movl	%edi, %ecx
    1a9a: 44 21 c9                     	andl	%r9d, %ecx
    1a9d: 09 d9                        	orl	%ebx, %ecx
    1a9f: 44 01 f1                     	addl	%r14d, %ecx
    1aa2: 89 c3                        	movl	%eax, %ebx
    1aa4: c1 c3 1a                     	roll	$0x1a, %ebx
    1aa7: 44 01 d9                     	addl	%r11d, %ecx
    1aaa: 41 89 c3                     	movl	%eax, %r11d
    1aad: 41 c1 c3 15                  	roll	$0x15, %r11d
    1ab1: 41 31 db                     	xorl	%ebx, %r11d
    1ab4: 89 c3                        	movl	%eax, %ebx
    1ab6: c1 c3 07                     	roll	$0x7, %ebx
    1ab9: 44 31 db                     	xorl	%r11d, %ebx
    1abc: 41 89 f3                     	movl	%esi, %r11d
    1abf: 41 31 d3                     	xorl	%edx, %r11d
    1ac2: 41 21 c3                     	andl	%eax, %r11d
    1ac5: 41 31 d3                     	xorl	%edx, %r11d
    1ac8: 44 03 95 4c ff ff ff         	addl	-0xb4(%rbp), %r10d
    1acf: 45 01 da                     	addl	%r11d, %r10d
    1ad2: 46 8d 9c 13 67 29 29 14      	leal	0x14292967(%rbx,%r10), %r11d
    1ada: 41 89 ca                     	movl	%ecx, %r10d
    1add: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1ae1: 45 01 d9                     	addl	%r11d, %r9d
    1ae4: 89 cb                        	movl	%ecx, %ebx
    1ae6: c1 c3 13                     	roll	$0x13, %ebx
    1ae9: 44 31 d3                     	xorl	%r10d, %ebx
    1aec: 41 89 ce                     	movl	%ecx, %r14d
    1aef: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1af3: 41 31 de                     	xorl	%ebx, %r14d
    1af6: 44 89 c3                     	movl	%r8d, %ebx
    1af9: 09 fb                        	orl	%edi, %ebx
    1afb: 21 cb                        	andl	%ecx, %ebx
    1afd: 45 89 c2                     	movl	%r8d, %r10d
    1b00: 41 21 fa                     	andl	%edi, %r10d
    1b03: 41 09 da                     	orl	%ebx, %r10d
    1b06: 45 01 f2                     	addl	%r14d, %r10d
    1b09: 45 01 da                     	addl	%r11d, %r10d
    1b0c: 45 89 cb                     	movl	%r9d, %r11d
    1b0f: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1b13: 44 89 cb                     	movl	%r9d, %ebx
    1b16: c1 c3 15                     	roll	$0x15, %ebx
    1b19: 44 31 db                     	xorl	%r11d, %ebx
    1b1c: 45 89 cb                     	movl	%r9d, %r11d
    1b1f: 41 c1 c3 07                  	roll	$0x7, %r11d
    1b23: 41 31 db                     	xorl	%ebx, %r11d
    1b26: 89 c3                        	movl	%eax, %ebx
    1b28: 31 f3                        	xorl	%esi, %ebx
    1b2a: 44 21 cb                     	andl	%r9d, %ebx
    1b2d: 31 f3                        	xorl	%esi, %ebx
    1b2f: 03 95 50 ff ff ff            	addl	-0xb0(%rbp), %edx
    1b35: 01 da                        	addl	%ebx, %edx
    1b37: 45 8d 9c 13 85 0a b7 27      	leal	0x27b70a85(%r11,%rdx), %r11d
    1b3f: 44 01 df                     	addl	%r11d, %edi
    1b42: 44 89 d2                     	movl	%r10d, %edx
    1b45: c1 c2 1e                     	roll	$0x1e, %edx
    1b48: 44 89 d3                     	movl	%r10d, %ebx
    1b4b: c1 c3 13                     	roll	$0x13, %ebx
    1b4e: 31 d3                        	xorl	%edx, %ebx
    1b50: 45 89 d6                     	movl	%r10d, %r14d
    1b53: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1b57: 41 31 de                     	xorl	%ebx, %r14d
    1b5a: 89 cb                        	movl	%ecx, %ebx
    1b5c: 44 09 c3                     	orl	%r8d, %ebx
    1b5f: 44 21 d3                     	andl	%r10d, %ebx
    1b62: 89 ca                        	movl	%ecx, %edx
    1b64: 44 21 c2                     	andl	%r8d, %edx
    1b67: 09 da                        	orl	%ebx, %edx
    1b69: 44 01 f2                     	addl	%r14d, %edx
    1b6c: 44 01 da                     	addl	%r11d, %edx
    1b6f: 41 89 fb                     	movl	%edi, %r11d
    1b72: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1b76: 89 fb                        	movl	%edi, %ebx
    1b78: c1 c3 15                     	roll	$0x15, %ebx
    1b7b: 44 31 db                     	xorl	%r11d, %ebx
    1b7e: 41 89 fb                     	movl	%edi, %r11d
    1b81: 41 c1 c3 07                  	roll	$0x7, %r11d
    1b85: 41 31 db                     	xorl	%ebx, %r11d
    1b88: 44 89 cb                     	movl	%r9d, %ebx
    1b8b: 31 c3                        	xorl	%eax, %ebx
    1b8d: 21 fb                        	andl	%edi, %ebx
    1b8f: 03 b5 54 ff ff ff            	addl	-0xac(%rbp), %esi
    1b95: 31 c3                        	xorl	%eax, %ebx
    1b97: 01 de                        	addl	%ebx, %esi
    1b99: 45 8d 9c 33 38 21 1b 2e      	leal	0x2e1b2138(%r11,%rsi), %r11d
    1ba1: 45 01 d8                     	addl	%r11d, %r8d
    1ba4: 89 d6                        	movl	%edx, %esi
    1ba6: c1 c6 1e                     	roll	$0x1e, %esi
    1ba9: 89 d3                        	movl	%edx, %ebx
    1bab: c1 c3 13                     	roll	$0x13, %ebx
    1bae: 31 f3                        	xorl	%esi, %ebx
    1bb0: 41 89 d6                     	movl	%edx, %r14d
    1bb3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1bb7: 41 31 de                     	xorl	%ebx, %r14d
    1bba: 44 89 d3                     	movl	%r10d, %ebx
    1bbd: 09 cb                        	orl	%ecx, %ebx
    1bbf: 21 d3                        	andl	%edx, %ebx
    1bc1: 44 89 d6                     	movl	%r10d, %esi
    1bc4: 21 ce                        	andl	%ecx, %esi
    1bc6: 09 de                        	orl	%ebx, %esi
    1bc8: 44 89 c3                     	movl	%r8d, %ebx
    1bcb: c1 c3 1a                     	roll	$0x1a, %ebx
    1bce: 44 01 f6                     	addl	%r14d, %esi
    1bd1: 45 89 c6                     	movl	%r8d, %r14d
    1bd4: 41 c1 c6 15                  	roll	$0x15, %r14d
    1bd8: 44 01 de                     	addl	%r11d, %esi
    1bdb: 45 89 c3                     	movl	%r8d, %r11d
    1bde: 41 c1 c3 07                  	roll	$0x7, %r11d
    1be2: 41 31 de                     	xorl	%ebx, %r14d
    1be5: 45 31 f3                     	xorl	%r14d, %r11d
    1be8: 89 fb                        	movl	%edi, %ebx
    1bea: 44 31 cb                     	xorl	%r9d, %ebx
    1bed: 44 21 c3                     	andl	%r8d, %ebx
    1bf0: 44 31 cb                     	xorl	%r9d, %ebx
    1bf3: 03 85 58 ff ff ff            	addl	-0xa8(%rbp), %eax
    1bf9: 01 d8                        	addl	%ebx, %eax
    1bfb: 89 f3                        	movl	%esi, %ebx
    1bfd: c1 c3 1e                     	roll	$0x1e, %ebx
    1c00: 45 8d 9c 03 fc 6d 2c 4d      	leal	0x4d2c6dfc(%r11,%rax), %r11d
    1c08: 89 f0                        	movl	%esi, %eax
    1c0a: c1 c0 13                     	roll	$0x13, %eax
    1c0d: 44 01 d9                     	addl	%r11d, %ecx
    1c10: 41 89 f6                     	movl	%esi, %r14d
    1c13: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1c17: 31 d8                        	xorl	%ebx, %eax
    1c19: 41 31 c6                     	xorl	%eax, %r14d
    1c1c: 89 d3                        	movl	%edx, %ebx
    1c1e: 44 09 d3                     	orl	%r10d, %ebx
    1c21: 21 f3                        	andl	%esi, %ebx
    1c23: 89 d0                        	movl	%edx, %eax
    1c25: 44 21 d0                     	andl	%r10d, %eax
    1c28: 09 d8                        	orl	%ebx, %eax
    1c2a: 44 01 f0                     	addl	%r14d, %eax
    1c2d: 89 cb                        	movl	%ecx, %ebx
    1c2f: c1 c3 1a                     	roll	$0x1a, %ebx
    1c32: 44 01 d8                     	addl	%r11d, %eax
    1c35: 41 89 cb                     	movl	%ecx, %r11d
    1c38: 41 c1 c3 15                  	roll	$0x15, %r11d
    1c3c: 41 31 db                     	xorl	%ebx, %r11d
    1c3f: 89 cb                        	movl	%ecx, %ebx
    1c41: c1 c3 07                     	roll	$0x7, %ebx
    1c44: 44 31 db                     	xorl	%r11d, %ebx
    1c47: 45 89 c3                     	movl	%r8d, %r11d
    1c4a: 41 31 fb                     	xorl	%edi, %r11d
    1c4d: 41 21 cb                     	andl	%ecx, %r11d
    1c50: 41 31 fb                     	xorl	%edi, %r11d
    1c53: 44 03 8d 5c ff ff ff         	addl	-0xa4(%rbp), %r9d
    1c5a: 45 01 d9                     	addl	%r11d, %r9d
    1c5d: 46 8d 9c 0b 13 0d 38 53      	leal	0x53380d13(%rbx,%r9), %r11d
    1c65: 41 89 c1                     	movl	%eax, %r9d
    1c68: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    1c6c: 45 01 da                     	addl	%r11d, %r10d
    1c6f: 89 c3                        	movl	%eax, %ebx
    1c71: c1 c3 13                     	roll	$0x13, %ebx
    1c74: 44 31 cb                     	xorl	%r9d, %ebx
    1c77: 41 89 c6                     	movl	%eax, %r14d
    1c7a: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1c7e: 41 31 de                     	xorl	%ebx, %r14d
    1c81: 89 f3                        	movl	%esi, %ebx
    1c83: 09 d3                        	orl	%edx, %ebx
    1c85: 21 c3                        	andl	%eax, %ebx
    1c87: 41 89 f1                     	movl	%esi, %r9d
    1c8a: 41 21 d1                     	andl	%edx, %r9d
    1c8d: 41 09 d9                     	orl	%ebx, %r9d
    1c90: 45 01 f1                     	addl	%r14d, %r9d
    1c93: 45 01 d9                     	addl	%r11d, %r9d
    1c96: 45 89 d3                     	movl	%r10d, %r11d
    1c99: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1c9d: 44 89 d3                     	movl	%r10d, %ebx
    1ca0: c1 c3 15                     	roll	$0x15, %ebx
    1ca3: 44 31 db                     	xorl	%r11d, %ebx
    1ca6: 45 89 d3                     	movl	%r10d, %r11d
    1ca9: 41 c1 c3 07                  	roll	$0x7, %r11d
    1cad: 41 31 db                     	xorl	%ebx, %r11d
    1cb0: 89 cb                        	movl	%ecx, %ebx
    1cb2: 44 31 c3                     	xorl	%r8d, %ebx
    1cb5: 44 21 d3                     	andl	%r10d, %ebx
    1cb8: 44 31 c3                     	xorl	%r8d, %ebx
    1cbb: 03 bd 60 ff ff ff            	addl	-0xa0(%rbp), %edi
    1cc1: 01 df                        	addl	%ebx, %edi
    1cc3: 45 8d 9c 3b 54 73 0a 65      	leal	0x650a7354(%r11,%rdi), %r11d
    1ccb: 44 01 da                     	addl	%r11d, %edx
    1cce: 44 89 cf                     	movl	%r9d, %edi
    1cd1: c1 c7 1e                     	roll	$0x1e, %edi
    1cd4: 44 89 cb                     	movl	%r9d, %ebx
    1cd7: c1 c3 13                     	roll	$0x13, %ebx
    1cda: 31 fb                        	xorl	%edi, %ebx
    1cdc: 45 89 ce                     	movl	%r9d, %r14d
    1cdf: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1ce3: 41 31 de                     	xorl	%ebx, %r14d
    1ce6: 89 c3                        	movl	%eax, %ebx
    1ce8: 09 f3                        	orl	%esi, %ebx
    1cea: 44 21 cb                     	andl	%r9d, %ebx
    1ced: 89 c7                        	movl	%eax, %edi
    1cef: 21 f7                        	andl	%esi, %edi
    1cf1: 09 df                        	orl	%ebx, %edi
    1cf3: 44 01 f7                     	addl	%r14d, %edi
    1cf6: 44 01 df                     	addl	%r11d, %edi
    1cf9: 41 89 d3                     	movl	%edx, %r11d
    1cfc: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1d00: 89 d3                        	movl	%edx, %ebx
    1d02: c1 c3 15                     	roll	$0x15, %ebx
    1d05: 44 31 db                     	xorl	%r11d, %ebx
    1d08: 41 89 d3                     	movl	%edx, %r11d
    1d0b: 41 c1 c3 07                  	roll	$0x7, %r11d
    1d0f: 41 31 db                     	xorl	%ebx, %r11d
    1d12: 44 89 d3                     	movl	%r10d, %ebx
    1d15: 31 cb                        	xorl	%ecx, %ebx
    1d17: 21 d3                        	andl	%edx, %ebx
    1d19: 44 03 85 64 ff ff ff         	addl	-0x9c(%rbp), %r8d
    1d20: 31 cb                        	xorl	%ecx, %ebx
    1d22: 41 01 d8                     	addl	%ebx, %r8d
    1d25: 47 8d 9c 03 bb 0a 6a 76      	leal	0x766a0abb(%r11,%r8), %r11d
    1d2d: 44 01 de                     	addl	%r11d, %esi
    1d30: 41 89 f8                     	movl	%edi, %r8d
    1d33: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    1d37: 89 fb                        	movl	%edi, %ebx
    1d39: c1 c3 13                     	roll	$0x13, %ebx
    1d3c: 44 31 c3                     	xorl	%r8d, %ebx
    1d3f: 41 89 fe                     	movl	%edi, %r14d
    1d42: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1d46: 41 31 de                     	xorl	%ebx, %r14d
    1d49: 44 89 cb                     	movl	%r9d, %ebx
    1d4c: 09 c3                        	orl	%eax, %ebx
    1d4e: 21 fb                        	andl	%edi, %ebx
    1d50: 45 89 c8                     	movl	%r9d, %r8d
    1d53: 41 21 c0                     	andl	%eax, %r8d
    1d56: 41 09 d8                     	orl	%ebx, %r8d
    1d59: 89 f3                        	movl	%esi, %ebx
    1d5b: c1 c3 1a                     	roll	$0x1a, %ebx
    1d5e: 45 01 f0                     	addl	%r14d, %r8d
    1d61: 41 89 f6                     	movl	%esi, %r14d
    1d64: 41 c1 c6 15                  	roll	$0x15, %r14d
    1d68: 45 01 d8                     	addl	%r11d, %r8d
    1d6b: 41 89 f3                     	movl	%esi, %r11d
    1d6e: 41 c1 c3 07                  	roll	$0x7, %r11d
    1d72: 41 31 de                     	xorl	%ebx, %r14d
    1d75: 45 31 f3                     	xorl	%r14d, %r11d
    1d78: 89 d3                        	movl	%edx, %ebx
    1d7a: 44 31 d3                     	xorl	%r10d, %ebx
    1d7d: 21 f3                        	andl	%esi, %ebx
    1d7f: 44 31 d3                     	xorl	%r10d, %ebx
    1d82: 03 8d 68 ff ff ff            	addl	-0x98(%rbp), %ecx
    1d88: 01 d9                        	addl	%ebx, %ecx
    1d8a: 44 89 c3                     	movl	%r8d, %ebx
    1d8d: c1 c3 1e                     	roll	$0x1e, %ebx
    1d90: 45 8d 9c 0b 2e c9 c2 81      	leal	-0x7e3d36d2(%r11,%rcx), %r11d
    1d98: 44 89 c1                     	movl	%r8d, %ecx
    1d9b: c1 c1 13                     	roll	$0x13, %ecx
    1d9e: 44 01 d8                     	addl	%r11d, %eax
    1da1: 45 89 c6                     	movl	%r8d, %r14d
    1da4: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1da8: 31 d9                        	xorl	%ebx, %ecx
    1daa: 41 31 ce                     	xorl	%ecx, %r14d
    1dad: 89 fb                        	movl	%edi, %ebx
    1daf: 44 09 cb                     	orl	%r9d, %ebx
    1db2: 44 21 c3                     	andl	%r8d, %ebx
    1db5: 89 f9                        	movl	%edi, %ecx
    1db7: 44 21 c9                     	andl	%r9d, %ecx
    1dba: 09 d9                        	orl	%ebx, %ecx
    1dbc: 44 01 f1                     	addl	%r14d, %ecx
    1dbf: 89 c3                        	movl	%eax, %ebx
    1dc1: c1 c3 1a                     	roll	$0x1a, %ebx
    1dc4: 44 01 d9                     	addl	%r11d, %ecx
    1dc7: 41 89 c3                     	movl	%eax, %r11d
    1dca: 41 c1 c3 15                  	roll	$0x15, %r11d
    1dce: 41 31 db                     	xorl	%ebx, %r11d
    1dd1: 89 c3                        	movl	%eax, %ebx
    1dd3: c1 c3 07                     	roll	$0x7, %ebx
    1dd6: 44 31 db                     	xorl	%r11d, %ebx
    1dd9: 41 89 f3                     	movl	%esi, %r11d
    1ddc: 41 31 d3                     	xorl	%edx, %r11d
    1ddf: 41 21 c3                     	andl	%eax, %r11d
    1de2: 41 31 d3                     	xorl	%edx, %r11d
    1de5: 44 03 95 6c ff ff ff         	addl	-0x94(%rbp), %r10d
    1dec: 45 01 da                     	addl	%r11d, %r10d
    1def: 46 8d 9c 13 85 2c 72 92      	leal	-0x6d8dd37b(%rbx,%r10), %r11d
    1df7: 41 89 ca                     	movl	%ecx, %r10d
    1dfa: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    1dfe: 45 01 d9                     	addl	%r11d, %r9d
    1e01: 89 cb                        	movl	%ecx, %ebx
    1e03: c1 c3 13                     	roll	$0x13, %ebx
    1e06: 44 31 d3                     	xorl	%r10d, %ebx
    1e09: 41 89 ce                     	movl	%ecx, %r14d
    1e0c: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1e10: 41 31 de                     	xorl	%ebx, %r14d
    1e13: 44 89 c3                     	movl	%r8d, %ebx
    1e16: 09 fb                        	orl	%edi, %ebx
    1e18: 21 cb                        	andl	%ecx, %ebx
    1e1a: 45 89 c2                     	movl	%r8d, %r10d
    1e1d: 41 21 fa                     	andl	%edi, %r10d
    1e20: 41 09 da                     	orl	%ebx, %r10d
    1e23: 45 01 f2                     	addl	%r14d, %r10d
    1e26: 45 01 da                     	addl	%r11d, %r10d
    1e29: 45 89 cb                     	movl	%r9d, %r11d
    1e2c: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1e30: 44 89 cb                     	movl	%r9d, %ebx
    1e33: c1 c3 15                     	roll	$0x15, %ebx
    1e36: 44 31 db                     	xorl	%r11d, %ebx
    1e39: 45 89 cb                     	movl	%r9d, %r11d
    1e3c: 41 c1 c3 07                  	roll	$0x7, %r11d
    1e40: 41 31 db                     	xorl	%ebx, %r11d
    1e43: 89 c3                        	movl	%eax, %ebx
    1e45: 31 f3                        	xorl	%esi, %ebx
    1e47: 44 21 cb                     	andl	%r9d, %ebx
    1e4a: 31 f3                        	xorl	%esi, %ebx
    1e4c: 03 95 70 ff ff ff            	addl	-0x90(%rbp), %edx
    1e52: 01 da                        	addl	%ebx, %edx
    1e54: 45 8d 9c 13 a1 e8 bf a2      	leal	-0x5d40175f(%r11,%rdx), %r11d
    1e5c: 44 01 df                     	addl	%r11d, %edi
    1e5f: 44 89 d2                     	movl	%r10d, %edx
    1e62: c1 c2 1e                     	roll	$0x1e, %edx
    1e65: 44 89 d3                     	movl	%r10d, %ebx
    1e68: c1 c3 13                     	roll	$0x13, %ebx
    1e6b: 31 d3                        	xorl	%edx, %ebx
    1e6d: 45 89 d6                     	movl	%r10d, %r14d
    1e70: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1e74: 41 31 de                     	xorl	%ebx, %r14d
    1e77: 89 cb                        	movl	%ecx, %ebx
    1e79: 44 09 c3                     	orl	%r8d, %ebx
    1e7c: 44 21 d3                     	andl	%r10d, %ebx
    1e7f: 89 ca                        	movl	%ecx, %edx
    1e81: 44 21 c2                     	andl	%r8d, %edx
    1e84: 09 da                        	orl	%ebx, %edx
    1e86: 44 01 f2                     	addl	%r14d, %edx
    1e89: 44 01 da                     	addl	%r11d, %edx
    1e8c: 41 89 fb                     	movl	%edi, %r11d
    1e8f: 41 c1 c3 1a                  	roll	$0x1a, %r11d
    1e93: 89 fb                        	movl	%edi, %ebx
    1e95: c1 c3 15                     	roll	$0x15, %ebx
    1e98: 44 31 db                     	xorl	%r11d, %ebx
    1e9b: 41 89 fb                     	movl	%edi, %r11d
    1e9e: 41 c1 c3 07                  	roll	$0x7, %r11d
    1ea2: 41 31 db                     	xorl	%ebx, %r11d
    1ea5: 44 89 cb                     	movl	%r9d, %ebx
    1ea8: 31 c3                        	xorl	%eax, %ebx
    1eaa: 21 fb                        	andl	%edi, %ebx
    1eac: 03 b5 74 ff ff ff            	addl	-0x8c(%rbp), %esi
    1eb2: 31 c3                        	xorl	%eax, %ebx
    1eb4: 01 de                        	addl	%ebx, %esi
    1eb6: 45 8d 9c 33 4b 66 1a a8      	leal	-0x57e599b5(%r11,%rsi), %r11d
    1ebe: 45 01 d8                     	addl	%r11d, %r8d
    1ec1: 89 d6                        	movl	%edx, %esi
    1ec3: c1 c6 1e                     	roll	$0x1e, %esi
    1ec6: 89 d3                        	movl	%edx, %ebx
    1ec8: c1 c3 13                     	roll	$0x13, %ebx
    1ecb: 31 f3                        	xorl	%esi, %ebx
    1ecd: 41 89 d6                     	movl	%edx, %r14d
    1ed0: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1ed4: 41 31 de                     	xorl	%ebx, %r14d
    1ed7: 44 89 d3                     	movl	%r10d, %ebx
    1eda: 09 cb                        	orl	%ecx, %ebx
    1edc: 21 d3                        	andl	%edx, %ebx
    1ede: 44 89 d6                     	movl	%r10d, %esi
    1ee1: 21 ce                        	andl	%ecx, %esi
    1ee3: 09 de                        	orl	%ebx, %esi
    1ee5: 44 89 c3                     	movl	%r8d, %ebx
    1ee8: c1 c3 1a                     	roll	$0x1a, %ebx
    1eeb: 44 01 f6                     	addl	%r14d, %esi
    1eee: 45 89 c6                     	movl	%r8d, %r14d
    1ef1: 41 c1 c6 15                  	roll	$0x15, %r14d
    1ef5: 44 01 de                     	addl	%r11d, %esi
    1ef8: 45 89 c3                     	movl	%r8d, %r11d
    1efb: 41 c1 c3 07                  	roll	$0x7, %r11d
    1eff: 41 31 de                     	xorl	%ebx, %r14d
    1f02: 45 31 f3                     	xorl	%r14d, %r11d
    1f05: 89 fb                        	movl	%edi, %ebx
    1f07: 44 31 cb                     	xorl	%r9d, %ebx
    1f0a: 44 21 c3                     	andl	%r8d, %ebx
    1f0d: 44 31 cb                     	xorl	%r9d, %ebx
    1f10: 03 85 78 ff ff ff            	addl	-0x88(%rbp), %eax
    1f16: 01 d8                        	addl	%ebx, %eax
    1f18: 89 f3                        	movl	%esi, %ebx
    1f1a: c1 c3 1e                     	roll	$0x1e, %ebx
    1f1d: 45 8d 9c 03 70 8b 4b c2      	leal	-0x3db47490(%r11,%rax), %r11d
    1f25: 89 f0                        	movl	%esi, %eax
    1f27: c1 c0 13                     	roll	$0x13, %eax
    1f2a: 44 01 d9                     	addl	%r11d, %ecx
    1f2d: 41 89 f6                     	movl	%esi, %r14d
    1f30: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1f34: 31 d8                        	xorl	%ebx, %eax
    1f36: 41 31 c6                     	xorl	%eax, %r14d
    1f39: 89 d3                        	movl	%edx, %ebx
    1f3b: 44 09 d3                     	orl	%r10d, %ebx
    1f3e: 21 f3                        	andl	%esi, %ebx
    1f40: 89 d0                        	movl	%edx, %eax
    1f42: 44 21 d0                     	andl	%r10d, %eax
    1f45: 09 d8                        	orl	%ebx, %eax
    1f47: 44 01 f0                     	addl	%r14d, %eax
    1f4a: 89 cb                        	movl	%ecx, %ebx
    1f4c: c1 c3 1a                     	roll	$0x1a, %ebx
    1f4f: 44 01 d8                     	addl	%r11d, %eax
    1f52: 41 89 cb                     	movl	%ecx, %r11d
    1f55: 41 c1 c3 15                  	roll	$0x15, %r11d
    1f59: 41 31 db                     	xorl	%ebx, %r11d
    1f5c: 89 cb                        	movl	%ecx, %ebx
    1f5e: c1 c3 07                     	roll	$0x7, %ebx
    1f61: 44 31 db                     	xorl	%r11d, %ebx
    1f64: 45 89 c3                     	movl	%r8d, %r11d
    1f67: 41 31 fb                     	xorl	%edi, %r11d
    1f6a: 41 21 cb                     	andl	%ecx, %r11d
    1f6d: 41 31 fb                     	xorl	%edi, %r11d
    1f70: 44 03 8d 7c ff ff ff         	addl	-0x84(%rbp), %r9d
    1f77: 45 01 d9                     	addl	%r11d, %r9d
    1f7a: 46 8d 8c 0b a3 51 6c c7      	leal	-0x3893ae5d(%rbx,%r9), %r9d
    1f82: 41 89 c3                     	movl	%eax, %r11d
    1f85: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    1f89: 45 01 ca                     	addl	%r9d, %r10d
    1f8c: 89 c3                        	movl	%eax, %ebx
    1f8e: c1 c3 13                     	roll	$0x13, %ebx
    1f91: 44 31 db                     	xorl	%r11d, %ebx
    1f94: 41 89 c6                     	movl	%eax, %r14d
    1f97: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1f9b: 41 31 de                     	xorl	%ebx, %r14d
    1f9e: 89 f3                        	movl	%esi, %ebx
    1fa0: 09 d3                        	orl	%edx, %ebx
    1fa2: 21 c3                        	andl	%eax, %ebx
    1fa4: 41 89 f3                     	movl	%esi, %r11d
    1fa7: 41 21 d3                     	andl	%edx, %r11d
    1faa: 41 09 db                     	orl	%ebx, %r11d
    1fad: 45 01 f3                     	addl	%r14d, %r11d
    1fb0: 45 01 cb                     	addl	%r9d, %r11d
    1fb3: 45 89 d1                     	movl	%r10d, %r9d
    1fb6: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    1fba: 44 89 d3                     	movl	%r10d, %ebx
    1fbd: c1 c3 15                     	roll	$0x15, %ebx
    1fc0: 44 31 cb                     	xorl	%r9d, %ebx
    1fc3: 45 89 d1                     	movl	%r10d, %r9d
    1fc6: 41 c1 c1 07                  	roll	$0x7, %r9d
    1fca: 41 31 d9                     	xorl	%ebx, %r9d
    1fcd: 89 cb                        	movl	%ecx, %ebx
    1fcf: 44 31 c3                     	xorl	%r8d, %ebx
    1fd2: 44 21 d3                     	andl	%r10d, %ebx
    1fd5: 44 31 c3                     	xorl	%r8d, %ebx
    1fd8: 03 7d 80                     	addl	-0x80(%rbp), %edi
    1fdb: 01 df                        	addl	%ebx, %edi
    1fdd: 45 8d 8c 39 19 e8 92 d1      	leal	-0x2e6d17e7(%r9,%rdi), %r9d
    1fe5: 44 01 ca                     	addl	%r9d, %edx
    1fe8: 44 89 df                     	movl	%r11d, %edi
    1feb: c1 c7 1e                     	roll	$0x1e, %edi
    1fee: 44 89 db                     	movl	%r11d, %ebx
    1ff1: c1 c3 13                     	roll	$0x13, %ebx
    1ff4: 31 fb                        	xorl	%edi, %ebx
    1ff6: 45 89 de                     	movl	%r11d, %r14d
    1ff9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    1ffd: 41 31 de                     	xorl	%ebx, %r14d
    2000: 89 c3                        	movl	%eax, %ebx
    2002: 09 f3                        	orl	%esi, %ebx
    2004: 44 21 db                     	andl	%r11d, %ebx
    2007: 89 c7                        	movl	%eax, %edi
    2009: 21 f7                        	andl	%esi, %edi
    200b: 09 df                        	orl	%ebx, %edi
    200d: 44 01 f7                     	addl	%r14d, %edi
    2010: 44 01 cf                     	addl	%r9d, %edi
    2013: 41 89 d1                     	movl	%edx, %r9d
    2016: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    201a: 89 d3                        	movl	%edx, %ebx
    201c: c1 c3 15                     	roll	$0x15, %ebx
    201f: 44 31 cb                     	xorl	%r9d, %ebx
    2022: 41 89 d1                     	movl	%edx, %r9d
    2025: 41 c1 c1 07                  	roll	$0x7, %r9d
    2029: 41 31 d9                     	xorl	%ebx, %r9d
    202c: 44 89 d3                     	movl	%r10d, %ebx
    202f: 31 cb                        	xorl	%ecx, %ebx
    2031: 21 d3                        	andl	%edx, %ebx
    2033: 44 03 45 84                  	addl	-0x7c(%rbp), %r8d
    2037: 31 cb                        	xorl	%ecx, %ebx
    2039: 41 01 d8                     	addl	%ebx, %r8d
    203c: 47 8d 8c 01 24 06 99 d6      	leal	-0x2966f9dc(%r9,%r8), %r9d
    2044: 44 01 ce                     	addl	%r9d, %esi
    2047: 41 89 f8                     	movl	%edi, %r8d
    204a: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    204e: 89 fb                        	movl	%edi, %ebx
    2050: c1 c3 13                     	roll	$0x13, %ebx
    2053: 44 31 c3                     	xorl	%r8d, %ebx
    2056: 41 89 fe                     	movl	%edi, %r14d
    2059: 41 c1 c6 0a                  	roll	$0xa, %r14d
    205d: 41 31 de                     	xorl	%ebx, %r14d
    2060: 44 89 db                     	movl	%r11d, %ebx
    2063: 09 c3                        	orl	%eax, %ebx
    2065: 21 fb                        	andl	%edi, %ebx
    2067: 45 89 d8                     	movl	%r11d, %r8d
    206a: 41 21 c0                     	andl	%eax, %r8d
    206d: 41 09 d8                     	orl	%ebx, %r8d
    2070: 89 f3                        	movl	%esi, %ebx
    2072: c1 c3 1a                     	roll	$0x1a, %ebx
    2075: 45 01 f0                     	addl	%r14d, %r8d
    2078: 41 89 f6                     	movl	%esi, %r14d
    207b: 41 c1 c6 15                  	roll	$0x15, %r14d
    207f: 45 01 c8                     	addl	%r9d, %r8d
    2082: 41 89 f1                     	movl	%esi, %r9d
    2085: 41 c1 c1 07                  	roll	$0x7, %r9d
    2089: 41 31 de                     	xorl	%ebx, %r14d
    208c: 45 31 f1                     	xorl	%r14d, %r9d
    208f: 89 d3                        	movl	%edx, %ebx
    2091: 44 31 d3                     	xorl	%r10d, %ebx
    2094: 21 f3                        	andl	%esi, %ebx
    2096: 44 31 d3                     	xorl	%r10d, %ebx
    2099: 03 4d 88                     	addl	-0x78(%rbp), %ecx
    209c: 01 d9                        	addl	%ebx, %ecx
    209e: 44 89 c3                     	movl	%r8d, %ebx
    20a1: c1 c3 1e                     	roll	$0x1e, %ebx
    20a4: 45 8d 8c 09 85 35 0e f4      	leal	-0xbf1ca7b(%r9,%rcx), %r9d
    20ac: 44 89 c1                     	movl	%r8d, %ecx
    20af: c1 c1 13                     	roll	$0x13, %ecx
    20b2: 44 01 c8                     	addl	%r9d, %eax
    20b5: 45 89 c6                     	movl	%r8d, %r14d
    20b8: 41 c1 c6 0a                  	roll	$0xa, %r14d
    20bc: 31 d9                        	xorl	%ebx, %ecx
    20be: 41 31 ce                     	xorl	%ecx, %r14d
    20c1: 89 fb                        	movl	%edi, %ebx
    20c3: 44 09 db                     	orl	%r11d, %ebx
    20c6: 44 21 c3                     	andl	%r8d, %ebx
    20c9: 89 f9                        	movl	%edi, %ecx
    20cb: 44 21 d9                     	andl	%r11d, %ecx
    20ce: 09 d9                        	orl	%ebx, %ecx
    20d0: 44 01 f1                     	addl	%r14d, %ecx
    20d3: 89 c3                        	movl	%eax, %ebx
    20d5: c1 c3 1a                     	roll	$0x1a, %ebx
    20d8: 44 01 c9                     	addl	%r9d, %ecx
    20db: 41 89 c1                     	movl	%eax, %r9d
    20de: 41 c1 c1 15                  	roll	$0x15, %r9d
    20e2: 41 31 d9                     	xorl	%ebx, %r9d
    20e5: 89 c3                        	movl	%eax, %ebx
    20e7: c1 c3 07                     	roll	$0x7, %ebx
    20ea: 44 31 cb                     	xorl	%r9d, %ebx
    20ed: 41 89 f1                     	movl	%esi, %r9d
    20f0: 41 31 d1                     	xorl	%edx, %r9d
    20f3: 41 21 c1                     	andl	%eax, %r9d
    20f6: 41 31 d1                     	xorl	%edx, %r9d
    20f9: 44 03 55 8c                  	addl	-0x74(%rbp), %r10d
    20fd: 45 01 ca                     	addl	%r9d, %r10d
    2100: 46 8d 8c 13 70 a0 6a 10      	leal	0x106aa070(%rbx,%r10), %r9d
    2108: 41 89 ca                     	movl	%ecx, %r10d
    210b: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    210f: 45 01 cb                     	addl	%r9d, %r11d
    2112: 89 cb                        	movl	%ecx, %ebx
    2114: c1 c3 13                     	roll	$0x13, %ebx
    2117: 44 31 d3                     	xorl	%r10d, %ebx
    211a: 41 89 ce                     	movl	%ecx, %r14d
    211d: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2121: 41 31 de                     	xorl	%ebx, %r14d
    2124: 44 89 c3                     	movl	%r8d, %ebx
    2127: 09 fb                        	orl	%edi, %ebx
    2129: 21 cb                        	andl	%ecx, %ebx
    212b: 45 89 c2                     	movl	%r8d, %r10d
    212e: 41 21 fa                     	andl	%edi, %r10d
    2131: 41 09 da                     	orl	%ebx, %r10d
    2134: 45 01 f2                     	addl	%r14d, %r10d
    2137: 45 01 ca                     	addl	%r9d, %r10d
    213a: 45 89 d9                     	movl	%r11d, %r9d
    213d: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    2141: 44 89 db                     	movl	%r11d, %ebx
    2144: c1 c3 15                     	roll	$0x15, %ebx
    2147: 44 31 cb                     	xorl	%r9d, %ebx
    214a: 45 89 d9                     	movl	%r11d, %r9d
    214d: 41 c1 c1 07                  	roll	$0x7, %r9d
    2151: 41 31 d9                     	xorl	%ebx, %r9d
    2154: 89 c3                        	movl	%eax, %ebx
    2156: 31 f3                        	xorl	%esi, %ebx
    2158: 44 21 db                     	andl	%r11d, %ebx
    215b: 31 f3                        	xorl	%esi, %ebx
    215d: 03 55 90                     	addl	-0x70(%rbp), %edx
    2160: 01 da                        	addl	%ebx, %edx
    2162: 41 8d 94 11 16 c1 a4 19      	leal	0x19a4c116(%r9,%rdx), %edx
    216a: 01 d7                        	addl	%edx, %edi
    216c: 45 89 d1                     	movl	%r10d, %r9d
    216f: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    2173: 44 89 d3                     	movl	%r10d, %ebx
    2176: c1 c3 13                     	roll	$0x13, %ebx
    2179: 44 31 cb                     	xorl	%r9d, %ebx
    217c: 45 89 d6                     	movl	%r10d, %r14d
    217f: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2183: 41 31 de                     	xorl	%ebx, %r14d
    2186: 89 cb                        	movl	%ecx, %ebx
    2188: 44 09 c3                     	orl	%r8d, %ebx
    218b: 44 21 d3                     	andl	%r10d, %ebx
    218e: 41 89 c9                     	movl	%ecx, %r9d
    2191: 45 21 c1                     	andl	%r8d, %r9d
    2194: 41 09 d9                     	orl	%ebx, %r9d
    2197: 45 01 f1                     	addl	%r14d, %r9d
    219a: 41 01 d1                     	addl	%edx, %r9d
    219d: 89 fa                        	movl	%edi, %edx
    219f: c1 c2 1a                     	roll	$0x1a, %edx
    21a2: 89 fb                        	movl	%edi, %ebx
    21a4: c1 c3 15                     	roll	$0x15, %ebx
    21a7: 31 d3                        	xorl	%edx, %ebx
    21a9: 89 fa                        	movl	%edi, %edx
    21ab: c1 c2 07                     	roll	$0x7, %edx
    21ae: 31 da                        	xorl	%ebx, %edx
    21b0: 44 89 db                     	movl	%r11d, %ebx
    21b3: 31 c3                        	xorl	%eax, %ebx
    21b5: 21 fb                        	andl	%edi, %ebx
    21b7: 03 75 94                     	addl	-0x6c(%rbp), %esi
    21ba: 31 c3                        	xorl	%eax, %ebx
    21bc: 01 de                        	addl	%ebx, %esi
    21be: 8d 94 32 08 6c 37 1e         	leal	0x1e376c08(%rdx,%rsi), %edx
    21c5: 41 01 d0                     	addl	%edx, %r8d
    21c8: 44 89 ce                     	movl	%r9d, %esi
    21cb: c1 c6 1e                     	roll	$0x1e, %esi
    21ce: 44 89 cb                     	movl	%r9d, %ebx
    21d1: c1 c3 13                     	roll	$0x13, %ebx
    21d4: 31 f3                        	xorl	%esi, %ebx
    21d6: 45 89 ce                     	movl	%r9d, %r14d
    21d9: 41 c1 c6 0a                  	roll	$0xa, %r14d
    21dd: 41 31 de                     	xorl	%ebx, %r14d
    21e0: 44 89 d3                     	movl	%r10d, %ebx
    21e3: 09 cb                        	orl	%ecx, %ebx
    21e5: 44 21 cb                     	andl	%r9d, %ebx
    21e8: 44 89 d6                     	movl	%r10d, %esi
    21eb: 21 ce                        	andl	%ecx, %esi
    21ed: 09 de                        	orl	%ebx, %esi
    21ef: 44 89 c3                     	movl	%r8d, %ebx
    21f2: c1 c3 1a                     	roll	$0x1a, %ebx
    21f5: 44 01 f6                     	addl	%r14d, %esi
    21f8: 45 89 c6                     	movl	%r8d, %r14d
    21fb: 41 c1 c6 15                  	roll	$0x15, %r14d
    21ff: 01 d6                        	addl	%edx, %esi
    2201: 44 89 c2                     	movl	%r8d, %edx
    2204: c1 c2 07                     	roll	$0x7, %edx
    2207: 41 31 de                     	xorl	%ebx, %r14d
    220a: 44 31 f2                     	xorl	%r14d, %edx
    220d: 89 fb                        	movl	%edi, %ebx
    220f: 44 31 db                     	xorl	%r11d, %ebx
    2212: 44 21 c3                     	andl	%r8d, %ebx
    2215: 44 31 db                     	xorl	%r11d, %ebx
    2218: 03 45 98                     	addl	-0x68(%rbp), %eax
    221b: 01 d8                        	addl	%ebx, %eax
    221d: 89 f3                        	movl	%esi, %ebx
    221f: c1 c3 1e                     	roll	$0x1e, %ebx
    2222: 8d 84 02 4c 77 48 27         	leal	0x2748774c(%rdx,%rax), %eax
    2229: 89 f2                        	movl	%esi, %edx
    222b: c1 c2 13                     	roll	$0x13, %edx
    222e: 01 c1                        	addl	%eax, %ecx
    2230: 41 89 f6                     	movl	%esi, %r14d
    2233: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2237: 31 da                        	xorl	%ebx, %edx
    2239: 41 31 d6                     	xorl	%edx, %r14d
    223c: 44 89 cb                     	movl	%r9d, %ebx
    223f: 44 09 d3                     	orl	%r10d, %ebx
    2242: 21 f3                        	andl	%esi, %ebx
    2244: 44 89 ca                     	movl	%r9d, %edx
    2247: 44 21 d2                     	andl	%r10d, %edx
    224a: 09 da                        	orl	%ebx, %edx
    224c: 44 01 f2                     	addl	%r14d, %edx
    224f: 89 cb                        	movl	%ecx, %ebx
    2251: c1 c3 1a                     	roll	$0x1a, %ebx
    2254: 01 c2                        	addl	%eax, %edx
    2256: 89 c8                        	movl	%ecx, %eax
    2258: c1 c0 15                     	roll	$0x15, %eax
    225b: 31 d8                        	xorl	%ebx, %eax
    225d: 89 cb                        	movl	%ecx, %ebx
    225f: c1 c3 07                     	roll	$0x7, %ebx
    2262: 31 c3                        	xorl	%eax, %ebx
    2264: 44 89 c0                     	movl	%r8d, %eax
    2267: 31 f8                        	xorl	%edi, %eax
    2269: 21 c8                        	andl	%ecx, %eax
    226b: 31 f8                        	xorl	%edi, %eax
    226d: 44 03 5d 9c                  	addl	-0x64(%rbp), %r11d
    2271: 41 01 c3                     	addl	%eax, %r11d
    2274: 42 8d 84 1b b5 bc b0 34      	leal	0x34b0bcb5(%rbx,%r11), %eax
    227c: 41 89 d3                     	movl	%edx, %r11d
    227f: 41 c1 c3 1e                  	roll	$0x1e, %r11d
    2283: 41 01 c2                     	addl	%eax, %r10d
    2286: 89 d3                        	movl	%edx, %ebx
    2288: c1 c3 13                     	roll	$0x13, %ebx
    228b: 44 31 db                     	xorl	%r11d, %ebx
    228e: 41 89 d6                     	movl	%edx, %r14d
    2291: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2295: 41 31 de                     	xorl	%ebx, %r14d
    2298: 89 f3                        	movl	%esi, %ebx
    229a: 44 09 cb                     	orl	%r9d, %ebx
    229d: 21 d3                        	andl	%edx, %ebx
    229f: 41 89 f3                     	movl	%esi, %r11d
    22a2: 45 21 cb                     	andl	%r9d, %r11d
    22a5: 41 09 db                     	orl	%ebx, %r11d
    22a8: 45 01 f3                     	addl	%r14d, %r11d
    22ab: 41 01 c3                     	addl	%eax, %r11d
    22ae: 44 89 d0                     	movl	%r10d, %eax
    22b1: c1 c0 1a                     	roll	$0x1a, %eax
    22b4: 44 89 d3                     	movl	%r10d, %ebx
    22b7: c1 c3 15                     	roll	$0x15, %ebx
    22ba: 31 c3                        	xorl	%eax, %ebx
    22bc: 44 89 d0                     	movl	%r10d, %eax
    22bf: c1 c0 07                     	roll	$0x7, %eax
    22c2: 31 d8                        	xorl	%ebx, %eax
    22c4: 89 cb                        	movl	%ecx, %ebx
    22c6: 44 31 c3                     	xorl	%r8d, %ebx
    22c9: 44 21 d3                     	andl	%r10d, %ebx
    22cc: 44 31 c3                     	xorl	%r8d, %ebx
    22cf: 03 7d a0                     	addl	-0x60(%rbp), %edi
    22d2: 01 df                        	addl	%ebx, %edi
    22d4: 8d 84 38 b3 0c 1c 39         	leal	0x391c0cb3(%rax,%rdi), %eax
    22db: 41 01 c1                     	addl	%eax, %r9d
    22de: 44 89 df                     	movl	%r11d, %edi
    22e1: c1 c7 1e                     	roll	$0x1e, %edi
    22e4: 44 89 db                     	movl	%r11d, %ebx
    22e7: c1 c3 13                     	roll	$0x13, %ebx
    22ea: 31 fb                        	xorl	%edi, %ebx
    22ec: 45 89 de                     	movl	%r11d, %r14d
    22ef: 41 c1 c6 0a                  	roll	$0xa, %r14d
    22f3: 41 31 de                     	xorl	%ebx, %r14d
    22f6: 89 d3                        	movl	%edx, %ebx
    22f8: 09 f3                        	orl	%esi, %ebx
    22fa: 44 21 db                     	andl	%r11d, %ebx
    22fd: 89 d7                        	movl	%edx, %edi
    22ff: 21 f7                        	andl	%esi, %edi
    2301: 09 df                        	orl	%ebx, %edi
    2303: 44 01 f7                     	addl	%r14d, %edi
    2306: 01 c7                        	addl	%eax, %edi
    2308: 44 89 c8                     	movl	%r9d, %eax
    230b: c1 c0 1a                     	roll	$0x1a, %eax
    230e: 44 89 cb                     	movl	%r9d, %ebx
    2311: c1 c3 15                     	roll	$0x15, %ebx
    2314: 31 c3                        	xorl	%eax, %ebx
    2316: 44 89 c8                     	movl	%r9d, %eax
    2319: c1 c0 07                     	roll	$0x7, %eax
    231c: 31 d8                        	xorl	%ebx, %eax
    231e: 44 89 d3                     	movl	%r10d, %ebx
    2321: 31 cb                        	xorl	%ecx, %ebx
    2323: 44 21 cb                     	andl	%r9d, %ebx
    2326: 44 03 45 a4                  	addl	-0x5c(%rbp), %r8d
    232a: 31 cb                        	xorl	%ecx, %ebx
    232c: 41 01 d8                     	addl	%ebx, %r8d
    232f: 42 8d 84 00 4a aa d8 4e      	leal	0x4ed8aa4a(%rax,%r8), %eax
    2337: 01 c6                        	addl	%eax, %esi
    2339: 41 89 f8                     	movl	%edi, %r8d
    233c: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    2340: 89 fb                        	movl	%edi, %ebx
    2342: c1 c3 13                     	roll	$0x13, %ebx
    2345: 44 31 c3                     	xorl	%r8d, %ebx
    2348: 41 89 fe                     	movl	%edi, %r14d
    234b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    234f: 41 31 de                     	xorl	%ebx, %r14d
    2352: 44 89 db                     	movl	%r11d, %ebx
    2355: 09 d3                        	orl	%edx, %ebx
    2357: 21 fb                        	andl	%edi, %ebx
    2359: 45 89 d8                     	movl	%r11d, %r8d
    235c: 41 21 d0                     	andl	%edx, %r8d
    235f: 41 09 d8                     	orl	%ebx, %r8d
    2362: 89 f3                        	movl	%esi, %ebx
    2364: c1 c3 1a                     	roll	$0x1a, %ebx
    2367: 45 01 f0                     	addl	%r14d, %r8d
    236a: 41 89 f6                     	movl	%esi, %r14d
    236d: 41 c1 c6 15                  	roll	$0x15, %r14d
    2371: 41 01 c0                     	addl	%eax, %r8d
    2374: 89 f0                        	movl	%esi, %eax
    2376: c1 c0 07                     	roll	$0x7, %eax
    2379: 41 31 de                     	xorl	%ebx, %r14d
    237c: 44 31 f0                     	xorl	%r14d, %eax
    237f: 44 89 cb                     	movl	%r9d, %ebx
    2382: 44 31 d3                     	xorl	%r10d, %ebx
    2385: 21 f3                        	andl	%esi, %ebx
    2387: 44 31 d3                     	xorl	%r10d, %ebx
    238a: 03 4d a8                     	addl	-0x58(%rbp), %ecx
    238d: 01 d9                        	addl	%ebx, %ecx
    238f: 44 89 c3                     	movl	%r8d, %ebx
    2392: c1 c3 1e                     	roll	$0x1e, %ebx
    2395: 8d 84 08 4f ca 9c 5b         	leal	0x5b9cca4f(%rax,%rcx), %eax
    239c: 44 89 c1                     	movl	%r8d, %ecx
    239f: c1 c1 13                     	roll	$0x13, %ecx
    23a2: 01 c2                        	addl	%eax, %edx
    23a4: 45 89 c6                     	movl	%r8d, %r14d
    23a7: 41 c1 c6 0a                  	roll	$0xa, %r14d
    23ab: 31 d9                        	xorl	%ebx, %ecx
    23ad: 41 31 ce                     	xorl	%ecx, %r14d
    23b0: 89 f9                        	movl	%edi, %ecx
    23b2: 44 09 d9                     	orl	%r11d, %ecx
    23b5: 44 21 c1                     	andl	%r8d, %ecx
    23b8: 89 fb                        	movl	%edi, %ebx
    23ba: 44 21 db                     	andl	%r11d, %ebx
    23bd: 09 cb                        	orl	%ecx, %ebx
    23bf: 44 01 f3                     	addl	%r14d, %ebx
    23c2: 89 d1                        	movl	%edx, %ecx
    23c4: c1 c1 1a                     	roll	$0x1a, %ecx
    23c7: 01 c3                        	addl	%eax, %ebx
    23c9: 89 d0                        	movl	%edx, %eax
    23cb: c1 c0 15                     	roll	$0x15, %eax
    23ce: 31 c8                        	xorl	%ecx, %eax
    23d0: 89 d1                        	movl	%edx, %ecx
    23d2: c1 c1 07                     	roll	$0x7, %ecx
    23d5: 31 c1                        	xorl	%eax, %ecx
    23d7: 89 f0                        	movl	%esi, %eax
    23d9: 44 31 c8                     	xorl	%r9d, %eax
    23dc: 21 d0                        	andl	%edx, %eax
    23de: 44 31 c8                     	xorl	%r9d, %eax
    23e1: 44 03 55 ac                  	addl	-0x54(%rbp), %r10d
    23e5: 41 01 c2                     	addl	%eax, %r10d
    23e8: 42 8d 84 11 f3 6f 2e 68      	leal	0x682e6ff3(%rcx,%r10), %eax
    23f0: 89 d9                        	movl	%ebx, %ecx
    23f2: c1 c1 1e                     	roll	$0x1e, %ecx
    23f5: 41 01 c3                     	addl	%eax, %r11d
    23f8: 41 89 da                     	movl	%ebx, %r10d
    23fb: 41 c1 c2 13                  	roll	$0x13, %r10d
    23ff: 41 31 ca                     	xorl	%ecx, %r10d
    2402: 41 89 de                     	movl	%ebx, %r14d
    2405: 41 c1 c6 0a                  	roll	$0xa, %r14d
    2409: 45 31 d6                     	xorl	%r10d, %r14d
    240c: 45 89 c2                     	movl	%r8d, %r10d
    240f: 41 09 fa                     	orl	%edi, %r10d
    2412: 41 21 da                     	andl	%ebx, %r10d
    2415: 44 89 c1                     	movl	%r8d, %ecx
    2418: 21 f9                        	andl	%edi, %ecx
    241a: 44 09 d1                     	orl	%r10d, %ecx
    241d: 44 01 f1                     	addl	%r14d, %ecx
    2420: 01 c1                        	addl	%eax, %ecx
    2422: 44 89 d8                     	movl	%r11d, %eax
    2425: c1 c0 1a                     	roll	$0x1a, %eax
    2428: 45 89 da                     	movl	%r11d, %r10d
    242b: 41 c1 c2 15                  	roll	$0x15, %r10d
    242f: 41 31 c2                     	xorl	%eax, %r10d
    2432: 44 89 d8                     	movl	%r11d, %eax
    2435: c1 c0 07                     	roll	$0x7, %eax
    2438: 44 31 d0                     	xorl	%r10d, %eax
    243b: 41 89 d2                     	movl	%edx, %r10d
    243e: 41 31 f2                     	xorl	%esi, %r10d
    2441: 45 21 da                     	andl	%r11d, %r10d
    2444: 41 31 f2                     	xorl	%esi, %r10d
    2447: 44 03 4d b0                  	addl	-0x50(%rbp), %r9d
    244b: 45 01 d1                     	addl	%r10d, %r9d
    244e: 46 8d 8c 08 ee 82 8f 74      	leal	0x748f82ee(%rax,%r9), %r9d
    2456: 44 01 cf                     	addl	%r9d, %edi
    2459: 89 c8                        	movl	%ecx, %eax
    245b: c1 c0 1e                     	roll	$0x1e, %eax
    245e: 41 89 ca                     	movl	%ecx, %r10d
    2461: 41 c1 c2 13                  	roll	$0x13, %r10d
    2465: 41 31 c2                     	xorl	%eax, %r10d
    2468: 41 89 ce                     	movl	%ecx, %r14d
    246b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    246f: 45 31 d6                     	xorl	%r10d, %r14d
    2472: 41 89 da                     	movl	%ebx, %r10d
    2475: 45 09 c2                     	orl	%r8d, %r10d
    2478: 41 21 ca                     	andl	%ecx, %r10d
    247b: 89 d8                        	movl	%ebx, %eax
    247d: 44 21 c0                     	andl	%r8d, %eax
    2480: 44 09 d0                     	orl	%r10d, %eax
    2483: 44 01 f0                     	addl	%r14d, %eax
    2486: 44 01 c8                     	addl	%r9d, %eax
    2489: 41 89 f9                     	movl	%edi, %r9d
    248c: 41 c1 c1 1a                  	roll	$0x1a, %r9d
    2490: 41 89 fa                     	movl	%edi, %r10d
    2493: 41 c1 c2 15                  	roll	$0x15, %r10d
    2497: 45 31 ca                     	xorl	%r9d, %r10d
    249a: 41 89 f9                     	movl	%edi, %r9d
    249d: 41 c1 c1 07                  	roll	$0x7, %r9d
    24a1: 45 31 d1                     	xorl	%r10d, %r9d
    24a4: 45 89 da                     	movl	%r11d, %r10d
    24a7: 41 31 d2                     	xorl	%edx, %r10d
    24aa: 41 21 fa                     	andl	%edi, %r10d
    24ad: 03 75 b4                     	addl	-0x4c(%rbp), %esi
    24b0: 41 31 d2                     	xorl	%edx, %r10d
    24b3: 44 01 d6                     	addl	%r10d, %esi
    24b6: 45 8d 8c 31 6f 63 a5 78      	leal	0x78a5636f(%r9,%rsi), %r9d
    24be: 45 01 c8                     	addl	%r9d, %r8d
    24c1: 89 c6                        	movl	%eax, %esi
    24c3: c1 c6 1e                     	roll	$0x1e, %esi
    24c6: 41 89 c2                     	movl	%eax, %r10d
    24c9: 41 c1 c2 13                  	roll	$0x13, %r10d
    24cd: 41 31 f2                     	xorl	%esi, %r10d
    24d0: 41 89 c6                     	movl	%eax, %r14d
    24d3: 41 c1 c6 0a                  	roll	$0xa, %r14d
    24d7: 45 31 d6                     	xorl	%r10d, %r14d
    24da: 41 89 ca                     	movl	%ecx, %r10d
    24dd: 41 09 da                     	orl	%ebx, %r10d
    24e0: 41 21 c2                     	andl	%eax, %r10d
    24e3: 89 ce                        	movl	%ecx, %esi
    24e5: 21 de                        	andl	%ebx, %esi
    24e7: 44 09 d6                     	orl	%r10d, %esi
    24ea: 45 89 c2                     	movl	%r8d, %r10d
    24ed: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    24f1: 44 01 f6                     	addl	%r14d, %esi
    24f4: 45 89 c6                     	movl	%r8d, %r14d
    24f7: 41 c1 c6 15                  	roll	$0x15, %r14d
    24fb: 44 01 ce                     	addl	%r9d, %esi
    24fe: 45 89 c1                     	movl	%r8d, %r9d
    2501: 41 c1 c1 07                  	roll	$0x7, %r9d
    2505: 45 31 d6                     	xorl	%r10d, %r14d
    2508: 45 31 f1                     	xorl	%r14d, %r9d
    250b: 41 89 fa                     	movl	%edi, %r10d
    250e: 45 31 da                     	xorl	%r11d, %r10d
    2511: 45 21 c2                     	andl	%r8d, %r10d
    2514: 45 31 da                     	xorl	%r11d, %r10d
    2517: 03 55 b8                     	addl	-0x48(%rbp), %edx
    251a: 44 01 d2                     	addl	%r10d, %edx
    251d: 41 89 f2                     	movl	%esi, %r10d
    2520: 41 c1 c2 1e                  	roll	$0x1e, %r10d
    2524: 45 8d 8c 11 14 78 c8 84      	leal	-0x7b3787ec(%r9,%rdx), %r9d
    252c: 89 f2                        	movl	%esi, %edx
    252e: c1 c2 13                     	roll	$0x13, %edx
    2531: 44 01 cb                     	addl	%r9d, %ebx
    2534: 41 89 f6                     	movl	%esi, %r14d
    2537: 41 c1 c6 0a                  	roll	$0xa, %r14d
    253b: 44 31 d2                     	xorl	%r10d, %edx
    253e: 41 31 d6                     	xorl	%edx, %r14d
    2541: 41 89 c2                     	movl	%eax, %r10d
    2544: 41 09 ca                     	orl	%ecx, %r10d
    2547: 41 21 f2                     	andl	%esi, %r10d
    254a: 89 c2                        	movl	%eax, %edx
    254c: 21 ca                        	andl	%ecx, %edx
    254e: 44 09 d2                     	orl	%r10d, %edx
    2551: 44 01 f2                     	addl	%r14d, %edx
    2554: 41 89 da                     	movl	%ebx, %r10d
    2557: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    255b: 44 01 ca                     	addl	%r9d, %edx
    255e: 41 89 d9                     	movl	%ebx, %r9d
    2561: 41 c1 c1 15                  	roll	$0x15, %r9d
    2565: 45 31 d1                     	xorl	%r10d, %r9d
    2568: 41 89 da                     	movl	%ebx, %r10d
    256b: 41 c1 c2 07                  	roll	$0x7, %r10d
    256f: 45 31 ca                     	xorl	%r9d, %r10d
    2572: 45 89 c1                     	movl	%r8d, %r9d
    2575: 41 31 f9                     	xorl	%edi, %r9d
    2578: 41 21 d9                     	andl	%ebx, %r9d
    257b: 41 31 f9                     	xorl	%edi, %r9d
    257e: 44 03 5d bc                  	addl	-0x44(%rbp), %r11d
    2582: 45 01 cb                     	addl	%r9d, %r11d
    2585: 47 8d 94 1a 08 02 c7 8c      	leal	-0x7338fdf8(%r10,%r11), %r10d
    258d: 41 89 d1                     	movl	%edx, %r9d
    2590: 41 c1 c1 1e                  	roll	$0x1e, %r9d
    2594: 44 01 d1                     	addl	%r10d, %ecx
    2597: 41 89 d3                     	movl	%edx, %r11d
    259a: 41 c1 c3 13                  	roll	$0x13, %r11d
    259e: 45 31 cb                     	xorl	%r9d, %r11d
    25a1: 41 89 d6                     	movl	%edx, %r14d
    25a4: 41 c1 c6 0a                  	roll	$0xa, %r14d
    25a8: 45 31 de                     	xorl	%r11d, %r14d
    25ab: 41 89 f3                     	movl	%esi, %r11d
    25ae: 41 09 c3                     	orl	%eax, %r11d
    25b1: 41 21 d3                     	andl	%edx, %r11d
    25b4: 41 89 f1                     	movl	%esi, %r9d
    25b7: 41 21 c1                     	andl	%eax, %r9d
    25ba: 45 09 d9                     	orl	%r11d, %r9d
    25bd: 45 01 f1                     	addl	%r14d, %r9d
    25c0: 45 01 d1                     	addl	%r10d, %r9d
    25c3: 41 89 ca                     	movl	%ecx, %r10d
    25c6: 41 c1 c2 1a                  	roll	$0x1a, %r10d
    25ca: 41 89 cb                     	movl	%ecx, %r11d
    25cd: 41 c1 c3 15                  	roll	$0x15, %r11d
    25d1: 45 31 d3                     	xorl	%r10d, %r11d
    25d4: 41 89 ca                     	movl	%ecx, %r10d
    25d7: 41 c1 c2 07                  	roll	$0x7, %r10d
    25db: 45 31 da                     	xorl	%r11d, %r10d
    25de: 41 89 db                     	movl	%ebx, %r11d
    25e1: 45 31 c3                     	xorl	%r8d, %r11d
    25e4: 41 21 cb                     	andl	%ecx, %r11d
    25e7: 45 31 c3                     	xorl	%r8d, %r11d
    25ea: 03 7d c0                     	addl	-0x40(%rbp), %edi
    25ed: 44 01 df                     	addl	%r11d, %edi
    25f0: 45 8d 94 3a fa ff be 90      	leal	-0x6f410006(%r10,%rdi), %r10d
    25f8: 44 89 cf                     	movl	%r9d, %edi
    25fb: c1 c7 1e                     	roll	$0x1e, %edi
    25fe: 45 89 cb                     	movl	%r9d, %r11d
    2601: 41 c1 c3 13                  	roll	$0x13, %r11d
    2605: 41 31 fb                     	xorl	%edi, %r11d
    2608: 45 89 ce                     	movl	%r9d, %r14d
    260b: 41 c1 c6 0a                  	roll	$0xa, %r14d
    260f: 45 31 de                     	xorl	%r11d, %r14d
    2612: 41 89 d3                     	movl	%edx, %r11d
    2615: 41 09 f3                     	orl	%esi, %r11d
    2618: 45 21 cb                     	andl	%r9d, %r11d
    261b: 89 d7                        	movl	%edx, %edi
    261d: 21 f7                        	andl	%esi, %edi
    261f: 44 09 df                     	orl	%r11d, %edi
    2622: 44 01 f7                     	addl	%r14d, %edi
    2625: 41 89 cb                     	movl	%ecx, %r11d
    2628: 41 31 db                     	xorl	%ebx, %r11d
    262b: 44 03 45 c4                  	addl	-0x3c(%rbp), %r8d
    262f: 44 01 d0                     	addl	%r10d, %eax
    2632: 41 21 c3                     	andl	%eax, %r11d
    2635: 41 31 db                     	xorl	%ebx, %r11d
    2638: 45 01 c3                     	addl	%r8d, %r11d
    263b: 03 5d c8                     	addl	-0x38(%rbp), %ebx
    263e: 41 89 c0                     	movl	%eax, %r8d
    2641: 41 c1 c0 1a                  	roll	$0x1a, %r8d
    2645: 41 89 c6                     	movl	%eax, %r14d
    2648: 41 c1 c6 15                  	roll	$0x15, %r14d
    264c: 45 31 c6                     	xorl	%r8d, %r14d
    264f: 41 89 c0                     	movl	%eax, %r8d
    2652: 41 c1 c0 07                  	roll	$0x7, %r8d
    2656: 45 31 f0                     	xorl	%r14d, %r8d
    2659: 47 8d 84 18 eb 6c 50 a4      	leal	-0x5baf9315(%r8,%r11), %r8d
    2661: 44 01 c6                     	addl	%r8d, %esi
    2664: 41 89 c3                     	movl	%eax, %r11d
    2667: 41 31 cb                     	xorl	%ecx, %r11d
    266a: 41 21 f3                     	andl	%esi, %r11d
    266d: 41 31 cb                     	xorl	%ecx, %r11d
    2670: 41 01 db                     	addl	%ebx, %r11d
    2673: 89 f3                        	movl	%esi, %ebx
    2675: 41 89 f6                     	movl	%esi, %r14d
    2678: 41 c1 c6 1a                  	roll	$0x1a, %r14d
    267c: c1 c3 15                     	roll	$0x15, %ebx
    267f: 44 31 f3                     	xorl	%r14d, %ebx
    2682: 41 89 f6                     	movl	%esi, %r14d
    2685: 66 0f 6e c6                  	movd	%esi, %xmm0
    2689: 41 89 f7                     	movl	%esi, %r15d
    268c: 41 c1 c6 07                  	roll	$0x7, %r14d
    2690: 41 31 de                     	xorl	%ebx, %r14d
    2693: 44 89 ce                     	movl	%r9d, %esi
    2696: 09 d6                        	orl	%edx, %esi
    2698: 47 8d 9c 1e f7 a3 f9 be      	leal	-0x41065c09(%r14,%r11), %r11d
    26a0: 44 89 cb                     	movl	%r9d, %ebx
    26a3: 21 d3                        	andl	%edx, %ebx
    26a5: 03 4d cc                     	addl	-0x34(%rbp), %ecx
    26a8: 44 01 da                     	addl	%r11d, %edx
    26ab: 41 31 c7                     	xorl	%eax, %r15d
    26ae: 41 21 d7                     	andl	%edx, %r15d
    26b1: 41 31 c7                     	xorl	%eax, %r15d
    26b4: 41 01 cf                     	addl	%ecx, %r15d
    26b7: 44 01 d7                     	addl	%r10d, %edi
    26ba: 89 f9                        	movl	%edi, %ecx
    26bc: c1 c1 1e                     	roll	$0x1e, %ecx
    26bf: 41 89 fa                     	movl	%edi, %r10d
    26c2: 41 c1 c2 13                  	roll	$0x13, %r10d
    26c6: 41 31 ca                     	xorl	%ecx, %r10d
    26c9: 89 f9                        	movl	%edi, %ecx
    26cb: c1 c1 0a                     	roll	$0xa, %ecx
    26ce: 44 31 d1                     	xorl	%r10d, %ecx
    26d1: 21 fe                        	andl	%edi, %esi
    26d3: 09 de                        	orl	%ebx, %esi
    26d5: 01 ce                        	addl	%ecx, %esi
    26d7: 89 d1                        	movl	%edx, %ecx
    26d9: 41 89 d2                     	movl	%edx, %r10d
    26dc: 66 0f 6e ca                  	movd	%edx, %xmm1
    26e0: c1 c2 1a                     	roll	$0x1a, %edx
    26e3: c1 c1 15                     	roll	$0x15, %ecx
    26e6: 41 c1 c2 07                  	roll	$0x7, %r10d
    26ea: 31 d1                        	xorl	%edx, %ecx
    26ec: 41 31 ca                     	xorl	%ecx, %r10d
    26ef: 89 fa                        	movl	%edi, %edx
    26f1: 44 09 ca                     	orl	%r9d, %edx
    26f4: 44 01 c6                     	addl	%r8d, %esi
    26f7: 41 89 f0                     	movl	%esi, %r8d
    26fa: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    26fe: 43 8d 8c 3a f2 78 71 c6      	leal	-0x398e870e(%r10,%r15), %ecx
    2706: 41 89 f2                     	movl	%esi, %r10d
    2709: 41 c1 c2 13                  	roll	$0x13, %r10d
    270d: 45 31 c2                     	xorl	%r8d, %r10d
    2710: 41 89 f0                     	movl	%esi, %r8d
    2713: 41 c1 c0 0a                  	roll	$0xa, %r8d
    2717: 45 31 d0                     	xorl	%r10d, %r8d
    271a: 21 f2                        	andl	%esi, %edx
    271c: 41 89 f2                     	movl	%esi, %r10d
    271f: 41 09 fa                     	orl	%edi, %r10d
    2722: 66 0f 6e d6                  	movd	%esi, %xmm2
    2726: 21 fe                        	andl	%edi, %esi
    2728: 66 0f 6e df                  	movd	%edi, %xmm3
    272c: 44 21 cf                     	andl	%r9d, %edi
    272f: 09 fa                        	orl	%edi, %edx
    2731: 44 01 c2                     	addl	%r8d, %edx
    2734: 44 01 da                     	addl	%r11d, %edx
    2737: 89 d7                        	movl	%edx, %edi
    2739: 41 89 d0                     	movl	%edx, %r8d
    273c: 41 c1 c0 1e                  	roll	$0x1e, %r8d
    2740: c1 c7 13                     	roll	$0x13, %edi
    2743: 44 31 c7                     	xorl	%r8d, %edi
    2746: 41 21 d2                     	andl	%edx, %r10d
    2749: 66 0f 6e e2                  	movd	%edx, %xmm4
    274d: c1 c2 0a                     	roll	$0xa, %edx
    2750: 31 fa                        	xorl	%edi, %edx
    2752: 44 09 d6                     	orl	%r10d, %esi
    2755: 01 d6                        	addl	%edx, %esi
    2757: 41 01 c9                     	addl	%ecx, %r9d
    275a: 01 ce                        	addl	%ecx, %esi
    275c: 66 0f 6e ee                  	movd	%esi, %xmm5
    2760: 66 41 0f 6e f1               	movd	%r9d, %xmm6
    2765: 66 0f 62 ec                  	punpckldq	%xmm4, %xmm5    ## xmm5 = xmm5[0],xmm4[0],xmm5[1],xmm4[1]
    2769: 66 0f 62 d3                  	punpckldq	%xmm3, %xmm2    ## xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
    276d: 66 0f 6c ea                  	punpcklqdq	%xmm2, %xmm5    ## xmm5 = xmm5[0],xmm2[0]
    2771: 66 41 0f fe 6d 00            	paddd	(%r13), %xmm5
    2777: 66 0f 6e d0                  	movd	%eax, %xmm2
    277b: 66 41 0f 7f 6d 00            	movdqa	%xmm5, (%r13)
    2781: 66 0f 62 f1                  	punpckldq	%xmm1, %xmm6    ## xmm6 = xmm6[0],xmm1[0],xmm6[1],xmm1[1]
    2785: 66 0f 62 c2                  	punpckldq	%xmm2, %xmm0    ## xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
    2789: 66 0f 6c f0                  	punpcklqdq	%xmm0, %xmm6    ## xmm6 = xmm6[0],xmm0[0]
    278d: 66 41 0f fe 75 10            	paddd	0x10(%r13), %xmm6
    2793: 66 41 0f 7f 75 10            	movdqa	%xmm6, 0x10(%r13)
    2799: 48 81 c4 28 09 00 00         	addq	$0x928, %rsp            ## imm = 0x928
    27a0: 5b                           	popq	%rbx
    27a1: 41 5c                        	popq	%r12
    27a3: 41 5d                        	popq	%r13
    27a5: 41 5e                        	popq	%r14
    27a7: 41 5f                        	popq	%r15
    27a9: 5d                           	popq	%rbp
    27aa: c3                           	retq
    27ab: 0f 1f 44 00 00               	nopl	(%rax,%rax)

00000000000027b0 <_audit_master256>:
    27b0: 55                           	pushq	%rbp
    27b1: 48 89 e5                     	movq	%rsp, %rbp
    27b4: 41 56                        	pushq	%r14
    27b6: 53                           	pushq	%rbx
    27b7: 48 81 ec 50 01 00 00         	subq	$0x150, %rsp            ## imm = 0x150
    27be: 48 89 f3                     	movq	%rsi, %rbx
    27c1: 49 89 f8                     	movq	%rdi, %r8
    27c4: 66 c7 85 c0 fe ff ff 00 20   	movw	$0x2000, -0x140(%rbp)   ## imm = 0x2000
    27cd: c6 85 c2 fe ff ff 0d         	movb	$0xd, -0x13e(%rbp)
    27d4: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    27de: 48 89 85 c3 fe ff ff         	movq	%rax, -0x13d(%rbp)
    27e5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    27ef: 48 89 85 c8 fe ff ff         	movq	%rax, -0x138(%rbp)
    27f6: c6 85 d0 fe ff ff 20         	movb	$0x20, -0x130(%rbp)
    27fd: 48 b8 e3 b0 c4 42 98 fc 1c 14	movabsq	$0x141cfc9842c4b0e3, %rax ## imm = 0x141CFC9842C4B0E3
    2807: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    280e: 48 b8 9a fb f4 c8 99 6f b9 24	movabsq	$0x24b96f99c8f4fb9a, %rax ## imm = 0x24B96F99C8F4FB9A
    2818: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    281f: 48 b8 27 ae 41 e4 64 9b 93 4c	movabsq	$0x4c939b64e441ae27, %rax ## imm = 0x4C939B64E441AE27
    2829: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    2830: 48 b8 a4 95 99 1b 78 52 b8 55	movabsq	$0x55b852781b9995a4, %rax ## imm = 0x55B852781B9995A4
    283a: 48 89 85 e9 fe ff ff         	movq	%rax, -0x117(%rbp)
    2841: 4c 8d b5 a0 fe ff ff         	leaq	-0x160(%rbp), %r14
    2848: 48 8d 95 c0 fe ff ff         	leaq	-0x140(%rbp), %rdx
    284f: be 20 00 00 00               	movl	$0x20, %esi
    2854: b9 31 00 00 00               	movl	$0x31, %ecx
    2859: 4c 89 f7                     	movq	%r14, %rdi
    285c: e8 00 00 00 00               	callq	 <L0>
		000000000000285d:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    2861: 48 8d 15 00 00 00 00         	leaq	, %rdx <_audit_master256+0xb8>
		0000000000002864:  X86_64_RELOC_SIGNED	_memx.Array(32).zero
    2868: 48 8d 7d d0                  	leaq	-0x30(%rbp), %rdi
    286c: 4c 89 f6                     	movq	%r14, %rsi
    286f: e8 00 00 00 00               	callq	 <L1>
		0000000000002870:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
<L1>:
    2874: 48 8b 45 e8                  	movq	-0x18(%rbp), %rax
    2878: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    287c: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    2880: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    2884: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    2888: 48 8b 4d d8                  	movq	-0x28(%rbp), %rcx
    288c: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    2890: 48 89 03                     	movq	%rax, (%rbx)
    2893: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            ## imm = 0x150
    289a: 5b                           	popq	%rbx
    289b: 41 5e                        	popq	%r14
    289d: 5d                           	popq	%rbp
    289e: c3                           	retq
    289f: 90                           	nop

00000000000028a0 <_audit_key256>:
    28a0: 55                           	pushq	%rbp
    28a1: 48 89 e5                     	movq	%rsp, %rbp
    28a4: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            ## imm = 0x110
    28ab: 48 89 f0                     	movq	%rsi, %rax
    28ae: 49 89 f8                     	movq	%rdi, %r8
    28b1: 66 c7 85 f4 fe ff ff 00 10   	movw	$0x1000, -0x10c(%rbp)   ## imm = 0x1000
    28ba: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    28c1: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx ## imm = 0x656B203331736C74
    28cb: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    28d2: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    28db: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    28e2: be 10 00 00 00               	movl	$0x10, %esi
    28e7: b9 0d 00 00 00               	movl	$0xd, %ecx
    28ec: 48 89 c7                     	movq	%rax, %rdi
    28ef: e8 00 00 00 00               	callq	 <L0>
		00000000000028f0:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    28f4: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            ## imm = 0x110
    28fb: 5d                           	popq	%rbp
    28fc: c3                           	retq
    28fd: 0f 1f 00                     	nopl	(%rax)

0000000000002900 <_audit_handshake384>:
    2900: 55                           	pushq	%rbp
    2901: 48 89 e5                     	movq	%rsp, %rbp
    2904: 41 57                        	pushq	%r15
    2906: 41 56                        	pushq	%r14
    2908: 53                           	pushq	%rbx
    2909: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            ## imm = 0x178
    2910: 48 89 d3                     	movq	%rdx, %rbx
    2913: 49 89 f6                     	movq	%rsi, %r14
    2916: 49 89 f8                     	movq	%rdi, %r8
    2919: 66 c7 85 a8 fe ff ff 00 30   	movw	$0x3000, -0x158(%rbp)   ## imm = 0x3000
    2922: c6 85 aa fe ff ff 0d         	movb	$0xd, -0x156(%rbp)
    2929: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    2933: 48 89 85 ab fe ff ff         	movq	%rax, -0x155(%rbp)
    293a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    2944: 48 89 85 b0 fe ff ff         	movq	%rax, -0x150(%rbp)
    294b: c6 85 b8 fe ff ff 30         	movb	$0x30, -0x148(%rbp)
    2952: 48 b8 38 b0 60 a7 51 ac 96 38	movabsq	$0x3896ac51a760b038, %rax ## imm = 0x3896AC51A760B038
    295c: 48 89 85 b9 fe ff ff         	movq	%rax, -0x147(%rbp)
    2963: 48 b8 4c d9 32 7e b1 b1 e3 6a	movabsq	$0x6ae3b1b17e32d94c, %rax ## imm = 0x6AE3B1B17E32D94C
    296d: 48 89 85 c1 fe ff ff         	movq	%rax, -0x13f(%rbp)
    2974: 48 b8 21 fd b7 11 14 be 07 43	movabsq	$0x4307be1411b7fd21, %rax ## imm = 0x4307BE1411B7FD21
    297e: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
    2985: 48 b8 4c 0c c7 bf 63 f6 e1 da	movabsq	$-0x251e099c4038f3b4, %rax ## imm = 0xDAE1F663BFC70C4C
    298f: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    2996: 48 b8 27 4e de bf e7 6f 65 fb	movabsq	$-0x49a90184021b1d9, %rax ## imm = 0xFB656FE7BFDE4E27
    29a0: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    29a7: 48 b8 d5 1a d2 f1 48 98 b9 5b	movabsq	$0x5bb99848f1d21ad5, %rax ## imm = 0x5BB99848F1D21AD5
    29b1: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    29b8: 4c 8d bd 78 fe ff ff         	leaq	-0x188(%rbp), %r15
    29bf: 48 8d 95 a8 fe ff ff         	leaq	-0x158(%rbp), %rdx
    29c6: be 30 00 00 00               	movl	$0x30, %esi
    29cb: b9 41 00 00 00               	movl	$0x41, %ecx
    29d0: 4c 89 ff                     	movq	%r15, %rdi
    29d3: e8 00 00 00 00               	callq	 <L0>
		00000000000029d4:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    29d8: 48 8d 7d b8                  	leaq	-0x48(%rbp), %rdi
    29dc: 4c 89 fe                     	movq	%r15, %rsi
    29df: 4c 89 f2                     	movq	%r14, %rdx
    29e2: e8 00 00 00 00               	callq	 <L1>
		00000000000029e3:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
<L1>:
    29e7: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    29eb: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    29ef: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    29f3: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    29f7: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    29fb: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    29ff: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
    2a03: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    2a07: 48 8b 45 b8                  	movq	-0x48(%rbp), %rax
    2a0b: 48 8b 4d c0                  	movq	-0x40(%rbp), %rcx
    2a0f: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    2a13: 48 89 03                     	movq	%rax, (%rbx)
    2a16: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            ## imm = 0x178
    2a1d: 5b                           	popq	%rbx
    2a1e: 41 5e                        	popq	%r14
    2a20: 41 5f                        	popq	%r15
    2a22: 5d                           	popq	%rbp
    2a23: c3                           	retq
    2a24: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2a2e: 66 90                        	nop

0000000000002a30 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2a30: 55                           	pushq	%rbp
    2a31: 48 89 e5                     	movq	%rsp, %rbp
    2a34: 41 57                        	pushq	%r15
    2a36: 41 56                        	pushq	%r14
    2a38: 41 55                        	pushq	%r13
    2a3a: 41 54                        	pushq	%r12
    2a3c: 53                           	pushq	%rbx
    2a3d: 48 81 ec a8 02 00 00         	subq	$0x2a8, %rsp            ## imm = 0x2A8
    2a44: 49 89 d6                     	movq	%rdx, %r14
    2a47: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    2a4b: 0f 10 06                     	movups	(%rsi), %xmm0
    2a4e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    2a52: 0f 10 56 20                  	movups	0x20(%rsi), %xmm2
    2a56: 0f 28 1d 93 36 00 00         	movaps	, %xmm3 <_audit_key384+0xb0>
		0000000000002a59:  X86_64_RELOC_SIGNED	__literal16
    2a5d: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2a60: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2a63: 0f 28 e9                     	movaps	%xmm1, %xmm5
    2a66: 0f 57 eb                     	xorps	%xmm3, %xmm5
    2a69: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2a70: 0f 29 ad 50 fe ff ff         	movaps	%xmm5, -0x1b0(%rbp)
    2a77: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2a7a: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2a7d: 0f 29 a5 60 fe ff ff         	movaps	%xmm4, -0x1a0(%rbp)
    2a84: 0f 29 9d 70 fe ff ff         	movaps	%xmm3, -0x190(%rbp)
    2a8b: 0f 29 9d 80 fe ff ff         	movaps	%xmm3, -0x180(%rbp)
    2a92: 0f 29 9d 90 fe ff ff         	movaps	%xmm3, -0x170(%rbp)
    2a99: 0f 29 9d a0 fe ff ff         	movaps	%xmm3, -0x160(%rbp)
    2aa0: 0f 29 9d b0 fe ff ff         	movaps	%xmm3, -0x150(%rbp)
    2aa7: 0f 28 1d 52 36 00 00         	movaps	, %xmm3 <_audit_key384+0xc0>
		0000000000002aaa:  X86_64_RELOC_SIGNED	__literal16
    2aae: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2ab1: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2ab4: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    2abb: 0f 29 8d d0 fe ff ff         	movaps	%xmm1, -0x130(%rbp)
    2ac2: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2ac5: 0f 29 95 e0 fe ff ff         	movaps	%xmm2, -0x120(%rbp)
    2acc: 0f 29 9d f0 fe ff ff         	movaps	%xmm3, -0x110(%rbp)
    2ad3: 0f 29 9d 00 ff ff ff         	movaps	%xmm3, -0x100(%rbp)
    2ada: 0f 29 9d 10 ff ff ff         	movaps	%xmm3, -0xf0(%rbp)
    2ae1: 0f 29 9d 20 ff ff ff         	movaps	%xmm3, -0xe0(%rbp)
    2ae8: 0f 29 9d 30 ff ff ff         	movaps	%xmm3, -0xd0(%rbp)
    2aef: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0xc6>
		0000000000002af2:  X86_64_RELOC_SIGNED	l___unnamed_2
    2af6: 4c 8d a5 60 fd ff ff         	leaq	-0x2a0(%rbp), %r12
    2afd: ba e0 00 00 00               	movl	$0xe0, %edx
    2b02: 4c 89 e7                     	movq	%r12, %rdi
    2b05: e8 00 00 00 00               	callq	 <L0>
		0000000000002b06:  X86_64_RELOC_BRANCH	_memcpy
<L0>:
    2b0a: 48 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %rsi
    2b11: 4c 89 e7                     	movq	%r12, %rdi
    2b14: e8 00 00 00 00               	callq	 <L1>
		0000000000002b15:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L1>:
    2b19: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2b20: bb 80 00 00 00               	movl	$0x80, %ebx
    2b25: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2b2c: 49 01 df                     	addq	%rbx, %r15
    2b2f: 49 83 d4 00                  	adcq	$0x0, %r12
    2b33: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2b3a: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2b41: 0f b6 85 30 fe ff ff         	movzbl	-0x1d0(%rbp), %eax
    2b48: 48 85 c0                     	testq	%rax, %rax
    2b4b: 74 4f                        	je	 <L4>
    2b4d: 3c 50                        	cmpb	$0x50, %al
    2b4f: 72 4d                        	jb	 <L5>
    2b51: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    2b57: 49 29 c5                     	subq	%rax, %r13
    2b5a: 4c 8d a5 b0 fd ff ff         	leaq	-0x250(%rbp), %r12
    2b61: 48 8d bc 05 b0 fd ff ff      	leaq	-0x250(%rbp,%rax), %rdi
    2b69: 4c 89 f6                     	movq	%r14, %rsi
    2b6c: 4c 89 ea                     	movq	%r13, %rdx
    2b6f: e8 00 00 00 00               	callq	 <L2>
		0000000000002b70:  X86_64_RELOC_BRANCH	_memcpy
<L2>:
    2b74: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2b7b: 4c 89 e6                     	movq	%r12, %rsi
    2b7e: e8 00 00 00 00               	callq	 <L3>
		0000000000002b7f:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L3>:
    2b83: c6 85 30 fe ff ff 00         	movb	$0x0, -0x1d0(%rbp)
    2b8a: 31 c0                        	xorl	%eax, %eax
    2b8c: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2b93: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2b9a: eb 05                        	jmp	 <L6>
<L4>:
    2b9c: 31 c0                        	xorl	%eax, %eax
<L5>:
    2b9e: 45 31 ed                     	xorl	%r13d, %r13d
<L6>:
    2ba1: 4d 01 ee                     	addq	%r13, %r14
    2ba4: 4c 89 f6                     	movq	%r14, %rsi
    2ba7: 41 be 30 00 00 00            	movl	$0x30, %r14d
    2bad: 4d 29 ee                     	subq	%r13, %r14
    2bb0: 0f b6 c0                     	movzbl	%al, %eax
    2bb3: 48 8d bc 05 b0 fd ff ff      	leaq	-0x250(%rbp,%rax), %rdi
    2bbb: 4c 89 f2                     	movq	%r14, %rdx
    2bbe: e8 00 00 00 00               	callq	 <L7>
		0000000000002bbf:  X86_64_RELOC_BRANCH	_memcpy
<L7>:
    2bc3: 44 00 b5 30 fe ff ff         	addb	%r14b, -0x1d0(%rbp)
    2bca: 49 83 c7 30                  	addq	$0x30, %r15
    2bce: 49 83 d4 00                  	adcq	$0x0, %r12
    2bd2: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2bd9: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2be0: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2be7: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2bee: e8 00 00 00 00               	callq	 <L8>
		0000000000002bef:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L8>:
    2bf3: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x1ca>
		0000000000002bf6:  X86_64_RELOC_SIGNED	l___unnamed_2
    2bfa: 4c 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %r14
    2c01: ba e0 00 00 00               	movl	$0xe0, %edx
    2c06: 4c 89 f7                     	movq	%r14, %rdi
    2c09: e8 00 00 00 00               	callq	 <L9>
		0000000000002c0a:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
    2c0e: 4c 89 f7                     	movq	%r14, %rdi
    2c11: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    2c18: e8 00 00 00 00               	callq	 <L10>
		0000000000002c19:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L10>:
    2c1d: 0f b6 7d 90                  	movzbl	-0x70(%rbp), %edi
    2c21: 4c 8b a5 c8 fe ff ff         	movq	-0x138(%rbp), %r12
    2c28: 48 03 9d c0 fe ff ff         	addq	-0x140(%rbp), %rbx
    2c2f: 49 83 d4 00                  	adcq	$0x0, %r12
    2c33: 4c 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %r14
    2c3a: 48 89 9d c0 fe ff ff         	movq	%rbx, -0x140(%rbp)
    2c41: 4c 89 a5 c8 fe ff ff         	movq	%r12, -0x138(%rbp)
    2c48: 48 85 ff                     	testq	%rdi, %rdi
    2c4b: 74 46                        	je	 <L13>
    2c4d: 40 80 ff 50                  	cmpb	$0x50, %dil
    2c51: 72 42                        	jb	 <L14>
    2c53: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    2c59: 49 29 ff                     	subq	%rdi, %r15
    2c5c: 4c 01 f7                     	addq	%r14, %rdi
    2c5f: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2c66: 4c 89 fa                     	movq	%r15, %rdx
    2c69: e8 00 00 00 00               	callq	 <L11>
		0000000000002c6a:  X86_64_RELOC_BRANCH	_memcpy
<L11>:
    2c6e: 48 8d bd c0 fe ff ff         	leaq	-0x140(%rbp), %rdi
    2c75: 4c 89 f6                     	movq	%r14, %rsi
    2c78: e8 00 00 00 00               	callq	 <L12>
		0000000000002c79:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L12>:
    2c7d: c6 45 90 00                  	movb	$0x0, -0x70(%rbp)
    2c81: 31 ff                        	xorl	%edi, %edi
    2c83: 48 8b 9d c0 fe ff ff         	movq	-0x140(%rbp), %rbx
    2c8a: 4c 8b a5 c8 fe ff ff         	movq	-0x138(%rbp), %r12
    2c91: eb 05                        	jmp	 <L15>
<L13>:
    2c93: 31 ff                        	xorl	%edi, %edi
<L14>:
    2c95: 45 31 ff                     	xorl	%r15d, %r15d
<L15>:
    2c98: 4a 8d b4 3d 30 fd ff ff      	leaq	-0x2d0(%rbp,%r15), %rsi
    2ca0: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    2ca6: 4d 29 fd                     	subq	%r15, %r13
    2ca9: 40 0f b6 c7                  	movzbl	%dil, %eax
    2cad: 49 01 c6                     	addq	%rax, %r14
    2cb0: 4c 89 f7                     	movq	%r14, %rdi
    2cb3: 4c 89 ea                     	movq	%r13, %rdx
    2cb6: e8 00 00 00 00               	callq	 <L16>
		0000000000002cb7:  X86_64_RELOC_BRANCH	_memcpy
<L16>:
    2cbb: 44 00 6d 90                  	addb	%r13b, -0x70(%rbp)
    2cbf: 48 83 c3 30                  	addq	$0x30, %rbx
    2cc3: 49 83 d4 00                  	adcq	$0x0, %r12
    2cc7: 4c 89 a5 c8 fe ff ff         	movq	%r12, -0x138(%rbp)
    2cce: 48 89 9d c0 fe ff ff         	movq	%rbx, -0x140(%rbp)
    2cd5: 48 8d bd c0 fe ff ff         	leaq	-0x140(%rbp), %rdi
    2cdc: 48 8d 75 a0                  	leaq	-0x60(%rbp), %rsi
    2ce0: e8 00 00 00 00               	callq	 <L17>
		0000000000002ce1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L17>:
    2ce5: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
    2ce9: 48 8b 55 d0                  	movq	-0x30(%rbp), %rdx
    2ced: 48 89 42 28                  	movq	%rax, 0x28(%rdx)
    2cf1: 48 8b 45 c0                  	movq	-0x40(%rbp), %rax
    2cf5: 48 89 42 20                  	movq	%rax, 0x20(%rdx)
    2cf9: 48 8b 45 b8                  	movq	-0x48(%rbp), %rax
    2cfd: 48 89 42 18                  	movq	%rax, 0x18(%rdx)
    2d01: 48 8b 45 b0                  	movq	-0x50(%rbp), %rax
    2d05: 48 89 42 10                  	movq	%rax, 0x10(%rdx)
    2d09: 48 8b 45 a0                  	movq	-0x60(%rbp), %rax
    2d0d: 48 8b 4d a8                  	movq	-0x58(%rbp), %rcx
    2d11: 48 89 4a 08                  	movq	%rcx, 0x8(%rdx)
    2d15: 48 89 02                     	movq	%rax, (%rdx)
    2d18: 48 81 c4 a8 02 00 00         	addq	$0x2a8, %rsp            ## imm = 0x2A8
    2d1f: 5b                           	popq	%rbx
    2d20: 41 5c                        	popq	%r12
    2d22: 41 5d                        	popq	%r13
    2d24: 41 5e                        	popq	%r14
    2d26: 41 5f                        	popq	%r15
    2d28: 5d                           	popq	%rbp
    2d29: c3                           	retq
    2d2a: 66 0f 1f 44 00 00            	nopw	(%rax,%rax)

0000000000002d30 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
    2d30: 55                           	pushq	%rbp
    2d31: 48 89 e5                     	movq	%rsp, %rbp
    2d34: 41 57                        	pushq	%r15
    2d36: 41 56                        	pushq	%r14
    2d38: 41 55                        	pushq	%r13
    2d3a: 41 54                        	pushq	%r12
    2d3c: 53                           	pushq	%rbx
    2d3d: 48 81 ec a8 05 00 00         	subq	$0x5a8, %rsp            ## imm = 0x5A8
    2d44: 48 89 55 b8                  	movq	%rdx, -0x48(%rbp)
    2d48: 49 89 f7                     	movq	%rsi, %r15
    2d4b: 48 89 7d c8                  	movq	%rdi, -0x38(%rbp)
    2d4f: 41 0f 10 08                  	movups	(%r8), %xmm1
    2d53: 41 0f 10 50 10               	movups	0x10(%r8), %xmm2
    2d58: 41 0f 10 40 20               	movups	0x20(%r8), %xmm0
    2d5d: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    2d61: 48 83 fe 30                  	cmpq	$0x30, %rsi
    2d65: 48 89 4d c0                  	movq	%rcx, -0x40(%rbp)
    2d69: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    2d70: 0f 29 8d 10 fe ff ff         	movaps	%xmm1, -0x1f0(%rbp)
    2d77: 0f 29 95 20 fe ff ff         	movaps	%xmm2, -0x1e0(%rbp)
    2d7e: 0f 83 6f 01 00 00            	jae	 <L5>
    2d84: 48 c7 45 b0 00 00 00 00      	movq	$0x0, -0x50(%rbp)
<L0>:
    2d8c: 4c 89 f8                     	movq	%r15, %rax
    2d8f: 48 83 e8 30                  	subq	$0x30, %rax
    2d93: 49 0f 42 c7                  	cmovbq	%r15, %rax
    2d97: 48 85 c0                     	testq	%rax, %rax
    2d9a: 0f 84 cc 08 00 00            	je	 <L66>
    2da0: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    2da4: 0f 28 05 65 33 00 00         	movaps	, %xmm0 <_audit_key384+0xd0>
		0000000000002da7:  X86_64_RELOC_SIGNED	__literal16
    2dab: 0f 28 9d 10 fe ff ff         	movaps	-0x1f0(%rbp), %xmm3
    2db2: 0f 28 cb                     	movaps	%xmm3, %xmm1
    2db5: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2db8: 0f 28 a5 20 fe ff ff         	movaps	-0x1e0(%rbp), %xmm4
    2dbf: 0f 28 d4                     	movaps	%xmm4, %xmm2
    2dc2: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2dc5: 0f 29 8d 20 fd ff ff         	movaps	%xmm1, -0x2e0(%rbp)
    2dcc: 0f 29 95 30 fd ff ff         	movaps	%xmm2, -0x2d0(%rbp)
    2dd3: 0f 28 95 00 fe ff ff         	movaps	-0x200(%rbp), %xmm2
    2dda: 0f 28 ca                     	movaps	%xmm2, %xmm1
    2ddd: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2de0: 0f 29 8d 40 fd ff ff         	movaps	%xmm1, -0x2c0(%rbp)
    2de7: 0f 29 85 50 fd ff ff         	movaps	%xmm0, -0x2b0(%rbp)
    2dee: 0f 29 85 60 fd ff ff         	movaps	%xmm0, -0x2a0(%rbp)
    2df5: 0f 29 85 70 fd ff ff         	movaps	%xmm0, -0x290(%rbp)
    2dfc: 0f 29 85 80 fd ff ff         	movaps	%xmm0, -0x280(%rbp)
    2e03: 0f 29 85 90 fd ff ff         	movaps	%xmm0, -0x270(%rbp)
    2e0a: 0f 28 05 0f 33 00 00         	movaps	, %xmm0 <_audit_key384+0xe0>
		0000000000002e0d:  X86_64_RELOC_SIGNED	__literal16
    2e11: 0f 57 d8                     	xorps	%xmm0, %xmm3
    2e14: 0f 57 e0                     	xorps	%xmm0, %xmm4
    2e17: 0f 29 9d 30 fe ff ff         	movaps	%xmm3, -0x1d0(%rbp)
    2e1e: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2e25: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2e28: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
    2e2f: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    2e36: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    2e3d: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    2e44: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    2e4b: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    2e52: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x129>
		0000000000002e55:  X86_64_RELOC_SIGNED	l___unnamed_2
    2e59: 48 8d 9d 40 fc ff ff         	leaq	-0x3c0(%rbp), %rbx
    2e60: ba e0 00 00 00               	movl	$0xe0, %edx
    2e65: 48 89 df                     	movq	%rbx, %rdi
    2e68: e8 00 00 00 00               	callq	 <L1>
		0000000000002e69:  X86_64_RELOC_BRANCH	_memcpy
<L1>:
    2e6d: 48 8d b5 30 fe ff ff         	leaq	-0x1d0(%rbp), %rsi
    2e74: 48 89 df                     	movq	%rbx, %rdi
    2e77: e8 00 00 00 00               	callq	 <L2>
		0000000000002e78:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L2>:
    2e7c: 48 81 85 40 fc ff ff 80 00 00 00     	addq	$0x80, -0x3c0(%rbp)
    2e87: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    2e8f: 0f b6 85 10 fd ff ff         	movzbl	-0x2f0(%rbp), %eax
    2e96: 49 83 ff 2f                  	cmpq	$0x2f, %r15
    2e9a: 0f 86 5b 05 00 00            	jbe	 <L43>
    2ea0: 84 c0                        	testb	%al, %al
    2ea2: 0f 84 0a 05 00 00            	je	 <L39>
    2ea8: 3c 50                        	cmpb	$0x50, %al
    2eaa: 0f 82 04 05 00 00            	jb	 <L40>
    2eb0: 0f b6 c0                     	movzbl	%al, %eax
    2eb3: bb 80 00 00 00               	movl	$0x80, %ebx
    2eb8: 48 29 c3                     	subq	%rax, %rbx
    2ebb: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    2ec2: 48 8d bc 05 90 fc ff ff      	leaq	-0x370(%rbp,%rax), %rdi
    2eca: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    2ece: 48 89 da                     	movq	%rbx, %rdx
    2ed1: e8 00 00 00 00               	callq	 <L3>
		0000000000002ed2:  X86_64_RELOC_BRANCH	_memcpy
<L3>:
    2ed6: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    2edd: 4c 89 f6                     	movq	%r14, %rsi
    2ee0: e8 00 00 00 00               	callq	 <L4>
		0000000000002ee1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L4>:
    2ee5: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    2eec: 31 c0                        	xorl	%eax, %eax
    2eee: e9 c3 04 00 00               	jmp	 <L41>
<L5>:
    2ef3: 48 83 f1 7f                  	xorq	$0x7f, %rcx
    2ef7: 48 89 4d a0                  	movq	%rcx, -0x60(%rbp)
    2efb: 0f 28 1d 0e 32 00 00         	movaps	, %xmm3 <_audit_key384+0xd0>
		0000000000002efe:  X86_64_RELOC_SIGNED	__literal16
    2f02: 0f 28 e1                     	movaps	%xmm1, %xmm4
    2f05: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f08: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
    2f0f: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2f12: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f15: 0f 29 a5 b0 fd ff ff         	movaps	%xmm4, -0x250(%rbp)
    2f1c: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2f1f: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f22: 0f 29 a5 c0 fd ff ff         	movaps	%xmm4, -0x240(%rbp)
    2f29: 0f 28 1d f0 31 00 00         	movaps	, %xmm3 <_audit_key384+0xe0>
		0000000000002f2c:  X86_64_RELOC_SIGNED	__literal16
    2f30: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2f33: 0f 29 8d d0 fd ff ff         	movaps	%xmm1, -0x230(%rbp)
    2f3a: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2f3d: 0f 29 95 e0 fd ff ff         	movaps	%xmm2, -0x220(%rbp)
    2f44: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2f47: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    2f4e: 41 b6 01                     	movb	$0x1, %r14b
    2f51: b0 02                        	movb	$0x2, %al
    2f53: 31 c9                        	xorl	%ecx, %ecx
    2f55: 4c 8d a5 30 fe ff ff         	leaq	-0x1d0(%rbp), %r12
    2f5c: 4c 89 7d 98                  	movq	%r15, -0x68(%rbp)
    2f60: e9 96 00 00 00               	jmp	 <L11>
    2f65: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2f6f: 90                           	nop
<L6>:
    2f70: 31 ff                        	xorl	%edi, %edi
<L7>:
    2f72: 45 31 f6                     	xorl	%r14d, %r14d
<L8>:
    2f75: 48 8b 5d b0                  	movq	-0x50(%rbp), %rbx
    2f79: 48 03 5d c8                  	addq	-0x38(%rbp), %rbx
    2f7d: 4a 8d b4 35 c0 fb ff ff      	leaq	-0x440(%rbp,%r14), %rsi
    2f85: b8 30 00 00 00               	movl	$0x30, %eax
    2f8a: 48 89 45 b0                  	movq	%rax, -0x50(%rbp)
    2f8e: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    2f94: 4d 29 f4                     	subq	%r14, %r12
    2f97: 40 0f b6 ff                  	movzbl	%dil, %edi
    2f9b: 48 8d 85 80 fe ff ff         	leaq	-0x180(%rbp), %rax
    2fa2: 48 01 c7                     	addq	%rax, %rdi
    2fa5: 4c 89 e2                     	movq	%r12, %rdx
    2fa8: e8 00 00 00 00               	callq	 <L9>
		0000000000002fa9:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
    2fad: 44 00 a5 00 ff ff ff         	addb	%r12b, -0x100(%rbp)
    2fb4: 49 83 c7 30                  	addq	$0x30, %r15
    2fb8: 49 83 d5 00                  	adcq	$0x0, %r13
    2fbc: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    2fc3: 4c 89 bd 30 fe ff ff         	movq	%r15, -0x1d0(%rbp)
    2fca: 4c 8d a5 30 fe ff ff         	leaq	-0x1d0(%rbp), %r12
    2fd1: 4c 89 e7                     	movq	%r12, %rdi
    2fd4: 48 89 de                     	movq	%rbx, %rsi
    2fd7: e8 00 00 00 00               	callq	 <L10>
		0000000000002fd8:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L10>:
    2fdc: 48 8b 45 a8                  	movq	-0x58(%rbp), %rax
    2fe0: 88 45 d7                     	movb	%al, -0x29(%rbp)
    2fe3: ff c0                        	incl	%eax
    2fe5: 45 31 f6                     	xorl	%r14d, %r14d
    2fe8: b9 30 00 00 00               	movl	$0x30, %ecx
    2fed: 4c 8b 7d 98                  	movq	-0x68(%rbp), %r15
    2ff1: 49 83 ff 60                  	cmpq	$0x60, %r15
    2ff5: 0f 82 91 fd ff ff            	jb	 <L0>
<L11>:
    2ffb: 48 89 4d b0                  	movq	%rcx, -0x50(%rbp)
    2fff: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    3003: 0f 28 85 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm0
    300a: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
    3011: 0f 28 85 b0 fd ff ff         	movaps	-0x250(%rbp), %xmm0
    3018: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    301f: 0f 28 85 c0 fd ff ff         	movaps	-0x240(%rbp), %xmm0
    3026: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    302d: 0f 28 05 dc 30 00 00         	movaps	, %xmm0 <_audit_key384+0xd0>
		0000000000003030:  X86_64_RELOC_SIGNED	__literal16
    3034: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    303b: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3042: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3049: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3050: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3054: 0f 28 85 d0 fd ff ff         	movaps	-0x230(%rbp), %xmm0
    305b: 0f 29 85 c0 fb ff ff         	movaps	%xmm0, -0x440(%rbp)
    3062: 0f 28 85 e0 fd ff ff         	movaps	-0x220(%rbp), %xmm0
    3069: 0f 29 85 d0 fb ff ff         	movaps	%xmm0, -0x430(%rbp)
    3070: 0f 28 85 f0 fd ff ff         	movaps	-0x210(%rbp), %xmm0
    3077: 0f 29 85 e0 fb ff ff         	movaps	%xmm0, -0x420(%rbp)
    307e: 0f 28 05 9b 30 00 00         	movaps	, %xmm0 <_audit_key384+0xe0>
		0000000000003081:  X86_64_RELOC_SIGNED	__literal16
    3085: 0f 29 85 f0 fb ff ff         	movaps	%xmm0, -0x410(%rbp)
    308c: 0f 29 85 00 fc ff ff         	movaps	%xmm0, -0x400(%rbp)
    3093: 0f 29 85 10 fc ff ff         	movaps	%xmm0, -0x3f0(%rbp)
    309a: 0f 29 85 20 fc ff ff         	movaps	%xmm0, -0x3e0(%rbp)
    30a1: 0f 29 85 30 fc ff ff         	movaps	%xmm0, -0x3d0(%rbp)
    30a8: ba e0 00 00 00               	movl	$0xe0, %edx
    30ad: 4c 89 e7                     	movq	%r12, %rdi
    30b0: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x387>
		00000000000030b3:  X86_64_RELOC_SIGNED	l___unnamed_2
    30b7: e8 00 00 00 00               	callq	 <L12>
		00000000000030b8:  X86_64_RELOC_BRANCH	_memcpy
<L12>:
    30bc: 4c 89 e7                     	movq	%r12, %rdi
    30bf: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    30c6: e8 00 00 00 00               	callq	 <L13>
		00000000000030c7:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L13>:
    30cb: 48 81 85 30 fe ff ff 80 00 00 00     	addq	$0x80, -0x1d0(%rbp)
    30d6: 48 83 95 38 fe ff ff 00      	adcq	$0x0, -0x1c8(%rbp)
    30de: ba 60 01 00 00               	movl	$0x160, %edx            ## imm = 0x160
    30e3: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    30ea: 4c 89 e6                     	movq	%r12, %rsi
    30ed: e8 00 00 00 00               	callq	 <L14>
		00000000000030ee:  X86_64_RELOC_BRANCH	_memcpy
<L14>:
    30f2: 0f b6 85 30 fb ff ff         	movzbl	-0x4d0(%rbp), %eax
    30f9: 41 f6 c6 01                  	testb	$0x1, %r14b
    30fd: 0f 85 90 00 00 00            	jne	 <L21>
    3103: 84 c0                        	testb	%al, %al
    3105: 74 40                        	je	 <L17>
    3107: 3c 50                        	cmpb	$0x50, %al
    3109: 72 3e                        	jb	 <L18>
    310b: 0f b6 f8                     	movzbl	%al, %edi
    310e: 41 be 80 00 00 00            	movl	$0x80, %r14d
    3114: 49 29 fe                     	subq	%rdi, %r14
    3117: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    311e: 48 01 df                     	addq	%rbx, %rdi
    3121: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    3125: 4c 89 f2                     	movq	%r14, %rdx
    3128: e8 00 00 00 00               	callq	 <L15>
		0000000000003129:  X86_64_RELOC_BRANCH	_memcpy
<L15>:
    312d: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3134: 48 89 de                     	movq	%rbx, %rsi
    3137: e8 00 00 00 00               	callq	 <L16>
		0000000000003138:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L16>:
    313c: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3143: 31 c0                        	xorl	%eax, %eax
    3145: eb 05                        	jmp	 <L19>
<L17>:
    3147: 31 c0                        	xorl	%eax, %eax
<L18>:
    3149: 45 31 f6                     	xorl	%r14d, %r14d
<L19>:
    314c: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    3150: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    3154: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    315a: 4d 29 f4                     	subq	%r14, %r12
    315d: 0f b6 f8                     	movzbl	%al, %edi
    3160: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3167: 48 01 c7                     	addq	%rax, %rdi
    316a: 4c 89 e2                     	movq	%r12, %rdx
    316d: e8 00 00 00 00               	callq	 <L20>
		000000000000316e:  X86_64_RELOC_BRANCH	_memcpy
<L20>:
    3172: 44 02 a5 30 fb ff ff         	addb	-0x4d0(%rbp), %r12b
    3179: 44 88 a5 30 fb ff ff         	movb	%r12b, -0x4d0(%rbp)
    3180: 48 83 85 60 fa ff ff 30      	addq	$0x30, -0x5a0(%rbp)
    3188: 48 83 95 68 fa ff ff 00      	adcq	$0x0, -0x598(%rbp)
    3190: 44 89 e0                     	movl	%r12d, %eax
<L21>:
    3193: 84 c0                        	testb	%al, %al
    3195: 74 49                        	je	 <L24>
    3197: 0f b6 f8                     	movzbl	%al, %edi
    319a: 48 39 7d a0                  	cmpq	%rdi, -0x60(%rbp)
    319e: 73 42                        	jae	 <L25>
    31a0: b1 80                        	movb	$-0x80, %cl
    31a2: 28 c1                        	subb	%al, %cl
    31a4: 44 0f b6 f1                  	movzbl	%cl, %r14d
    31a8: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    31af: 48 01 df                     	addq	%rbx, %rdi
    31b2: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
    31b6: 4c 89 f2                     	movq	%r14, %rdx
    31b9: e8 00 00 00 00               	callq	 <L22>
		00000000000031ba:  X86_64_RELOC_BRANCH	_memcpy
<L22>:
    31be: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    31c5: 48 89 de                     	movq	%rbx, %rsi
    31c8: e8 00 00 00 00               	callq	 <L23>
		00000000000031c9:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L23>:
    31cd: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    31d4: 31 c0                        	xorl	%eax, %eax
    31d6: eb 0d                        	jmp	 <L26>
    31d8: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L24>:
    31e0: 31 c0                        	xorl	%eax, %eax
<L25>:
    31e2: 45 31 f6                     	xorl	%r14d, %r14d
<L26>:
    31e5: 48 8b 4d b8                  	movq	-0x48(%rbp), %rcx
    31e9: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    31ed: 48 8b 5d c0                  	movq	-0x40(%rbp), %rbx
    31f1: 49 89 dc                     	movq	%rbx, %r12
    31f4: 4d 29 f4                     	subq	%r14, %r12
    31f7: 0f b6 f8                     	movzbl	%al, %edi
    31fa: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3201: 48 01 c7                     	addq	%rax, %rdi
    3204: 4c 89 e2                     	movq	%r12, %rdx
    3207: e8 00 00 00 00               	callq	 <L27>
		0000000000003208:  X86_64_RELOC_BRANCH	_memcpy
<L27>:
    320c: 0f b6 bd 30 fb ff ff         	movzbl	-0x4d0(%rbp), %edi
    3213: 4c 01 e7                     	addq	%r12, %rdi
    3216: 40 88 bd 30 fb ff ff         	movb	%dil, -0x4d0(%rbp)
    321d: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    3224: 4c 8b bd 60 fa ff ff         	movq	-0x5a0(%rbp), %r15
    322b: 49 01 df                     	addq	%rbx, %r15
    322e: 49 83 d5 00                  	adcq	$0x0, %r13
    3232: 4c 89 bd 60 fa ff ff         	movq	%r15, -0x5a0(%rbp)
    3239: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    3240: 40 84 ff                     	testb	%dil, %dil
    3243: 74 5b                        	je	 <L30>
    3245: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    3249: 72 57                        	jb	 <L31>
    324b: b0 80                        	movb	$-0x80, %al
    324d: 40 28 f8                     	subb	%dil, %al
    3250: 44 0f b6 f0                  	movzbl	%al, %r14d
    3254: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    325b: 48 01 df                     	addq	%rbx, %rdi
    325e: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3262: 4c 89 f2                     	movq	%r14, %rdx
    3265: e8 00 00 00 00               	callq	 <L28>
		0000000000003266:  X86_64_RELOC_BRANCH	_memcpy
<L28>:
    326a: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3271: 48 89 de                     	movq	%rbx, %rsi
    3274: e8 00 00 00 00               	callq	 <L29>
		0000000000003275:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L29>:
    3279: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3280: 31 ff                        	xorl	%edi, %edi
    3282: 4c 8b bd 60 fa ff ff         	movq	-0x5a0(%rbp), %r15
    3289: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    3290: eb 13                        	jmp	 <L32>
    3292: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    329c: 0f 1f 40 00                  	nopl	(%rax)
<L30>:
    32a0: 31 ff                        	xorl	%edi, %edi
<L31>:
    32a2: 45 31 f6                     	xorl	%r14d, %r14d
<L32>:
    32a5: 4a 8d 74 35 d7               	leaq	-0x29(%rbp,%r14), %rsi
    32aa: 41 bc 01 00 00 00            	movl	$0x1, %r12d
    32b0: 4d 29 f4                     	subq	%r14, %r12
    32b3: 40 0f b6 ff                  	movzbl	%dil, %edi
    32b7: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    32be: 48 01 c7                     	addq	%rax, %rdi
    32c1: 4c 89 e2                     	movq	%r12, %rdx
    32c4: e8 00 00 00 00               	callq	 <L33>
		00000000000032c5:  X86_64_RELOC_BRANCH	_memcpy
<L33>:
    32c9: 44 00 a5 30 fb ff ff         	addb	%r12b, -0x4d0(%rbp)
    32d0: 49 83 c7 01                  	addq	$0x1, %r15
    32d4: 49 83 d5 00                  	adcq	$0x0, %r13
    32d8: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    32df: 4c 89 bd 60 fa ff ff         	movq	%r15, -0x5a0(%rbp)
    32e6: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    32ed: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    32f4: e8 00 00 00 00               	callq	 <L34>
		00000000000032f5:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L34>:
    32f9: ba e0 00 00 00               	movl	$0xe0, %edx
    32fe: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    3305: 48 89 df                     	movq	%rbx, %rdi
    3308: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x5df>
		000000000000330b:  X86_64_RELOC_SIGNED	l___unnamed_2
    330f: e8 00 00 00 00               	callq	 <L35>
		0000000000003310:  X86_64_RELOC_BRANCH	_memcpy
<L35>:
    3314: 48 89 df                     	movq	%rbx, %rdi
    3317: 48 8d b5 40 fb ff ff         	leaq	-0x4c0(%rbp), %rsi
    331e: e8 00 00 00 00               	callq	 <L36>
		000000000000331f:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L36>:
    3323: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    332a: 4c 8b bd 30 fe ff ff         	movq	-0x1d0(%rbp), %r15
    3331: b8 80 00 00 00               	movl	$0x80, %eax
    3336: 49 01 c7                     	addq	%rax, %r15
    3339: 49 83 d5 00                  	adcq	$0x0, %r13
    333d: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    3344: 4c 89 bd 30 fe ff ff         	movq	%r15, -0x1d0(%rbp)
    334b: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    3352: 48 85 ff                     	testq	%rdi, %rdi
    3355: 0f 84 15 fc ff ff            	je	 <L6>
    335b: 40 80 ff 50                  	cmpb	$0x50, %dil
    335f: 0f 82 0d fc ff ff            	jb	 <L7>
    3365: 41 be 80 00 00 00            	movl	$0x80, %r14d
    336b: 49 29 fe                     	subq	%rdi, %r14
    336e: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    3375: 48 01 df                     	addq	%rbx, %rdi
    3378: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    337f: 4c 89 f2                     	movq	%r14, %rdx
    3382: e8 00 00 00 00               	callq	 <L37>
		0000000000003383:  X86_64_RELOC_BRANCH	_memcpy
<L37>:
    3387: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    338e: 48 89 de                     	movq	%rbx, %rsi
    3391: e8 00 00 00 00               	callq	 <L38>
		0000000000003392:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L38>:
    3396: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    339d: 31 ff                        	xorl	%edi, %edi
    339f: 4c 8b bd 30 fe ff ff         	movq	-0x1d0(%rbp), %r15
    33a6: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    33ad: e9 c3 fb ff ff               	jmp	 <L8>
<L39>:
    33b2: 31 c0                        	xorl	%eax, %eax
<L40>:
    33b4: 31 db                        	xorl	%ebx, %ebx
<L41>:
    33b6: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    33ba: 48 8d 34 19                  	leaq	(%rcx,%rbx), %rsi
    33be: 41 be 30 00 00 00            	movl	$0x30, %r14d
    33c4: 49 29 de                     	subq	%rbx, %r14
    33c7: 0f b6 c0                     	movzbl	%al, %eax
    33ca: 48 8d bc 05 90 fc ff ff      	leaq	-0x370(%rbp,%rax), %rdi
    33d2: 4c 89 f2                     	movq	%r14, %rdx
    33d5: e8 00 00 00 00               	callq	 <L42>
		00000000000033d6:  X86_64_RELOC_BRANCH	_memcpy
<L42>:
    33da: 44 02 b5 10 fd ff ff         	addb	-0x2f0(%rbp), %r14b
    33e1: 44 88 b5 10 fd ff ff         	movb	%r14b, -0x2f0(%rbp)
    33e8: 48 83 85 40 fc ff ff 30      	addq	$0x30, -0x3c0(%rbp)
    33f0: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    33f8: 44 89 f0                     	movl	%r14d, %eax
<L43>:
    33fb: 48 8b 55 c0                  	movq	-0x40(%rbp), %rdx
    33ff: 84 c0                        	testb	%al, %al
    3401: 74 4b                        	je	 <L46>
    3403: 0f b6 c8                     	movzbl	%al, %ecx
    3406: 48 01 ca                     	addq	%rcx, %rdx
    3409: 48 81 fa 80 00 00 00         	cmpq	$0x80, %rdx
    3410: 72 3e                        	jb	 <L47>
    3412: b2 80                        	movb	$-0x80, %dl
    3414: 28 c2                        	subb	%al, %dl
    3416: 0f b6 da                     	movzbl	%dl, %ebx
    3419: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    3420: 48 8d bc 0d 90 fc ff ff      	leaq	-0x370(%rbp,%rcx), %rdi
    3428: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
    342c: 48 89 da                     	movq	%rbx, %rdx
    342f: e8 00 00 00 00               	callq	 <L44>
		0000000000003430:  X86_64_RELOC_BRANCH	_memcpy
<L44>:
    3434: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    343b: 4c 89 f6                     	movq	%r14, %rsi
    343e: e8 00 00 00 00               	callq	 <L45>
		000000000000343f:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L45>:
    3443: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    344a: 31 c0                        	xorl	%eax, %eax
    344c: eb 04                        	jmp	 <L48>
<L46>:
    344e: 31 c0                        	xorl	%eax, %eax
<L47>:
    3450: 31 db                        	xorl	%ebx, %ebx
<L48>:
    3452: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
    3456: 48 01 de                     	addq	%rbx, %rsi
    3459: 4c 8b 7d c0                  	movq	-0x40(%rbp), %r15
    345d: 4d 89 fe                     	movq	%r15, %r14
    3460: 49 29 de                     	subq	%rbx, %r14
    3463: 48 8d 9d 90 fc ff ff         	leaq	-0x370(%rbp), %rbx
    346a: 0f b6 c0                     	movzbl	%al, %eax
    346d: 48 8d bc 05 90 fc ff ff      	leaq	-0x370(%rbp,%rax), %rdi
    3475: 4c 89 f2                     	movq	%r14, %rdx
    3478: e8 00 00 00 00               	callq	 <L49>
		0000000000003479:  X86_64_RELOC_BRANCH	_memcpy
<L49>:
    347d: 0f b6 bd 10 fd ff ff         	movzbl	-0x2f0(%rbp), %edi
    3484: 4c 01 f7                     	addq	%r14, %rdi
    3487: 40 88 bd 10 fd ff ff         	movb	%dil, -0x2f0(%rbp)
    348e: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    3495: 4c 03 bd 40 fc ff ff         	addq	-0x3c0(%rbp), %r15
    349c: 49 83 d4 00                  	adcq	$0x0, %r12
    34a0: 4d 89 fd                     	movq	%r15, %r13
    34a3: 4c 89 bd 40 fc ff ff         	movq	%r15, -0x3c0(%rbp)
    34aa: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    34b1: 40 84 ff                     	testb	%dil, %dil
    34b4: 74 46                        	je	 <L52>
    34b6: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    34ba: 72 42                        	jb	 <L53>
    34bc: b0 80                        	movb	$-0x80, %al
    34be: 40 28 f8                     	subb	%dil, %al
    34c1: 44 0f b6 f8                  	movzbl	%al, %r15d
    34c5: 48 01 df                     	addq	%rbx, %rdi
    34c8: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    34cc: 4c 89 fa                     	movq	%r15, %rdx
    34cf: e8 00 00 00 00               	callq	 <L50>
		00000000000034d0:  X86_64_RELOC_BRANCH	_memcpy
<L50>:
    34d4: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    34db: 48 89 de                     	movq	%rbx, %rsi
    34de: e8 00 00 00 00               	callq	 <L51>
		00000000000034df:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L51>:
    34e3: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    34ea: 31 ff                        	xorl	%edi, %edi
    34ec: 4c 8b ad 40 fc ff ff         	movq	-0x3c0(%rbp), %r13
    34f3: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    34fa: eb 05                        	jmp	 <L54>
<L52>:
    34fc: 31 ff                        	xorl	%edi, %edi
<L53>:
    34fe: 45 31 ff                     	xorl	%r15d, %r15d
<L54>:
    3501: 4a 8d 74 3d d7               	leaq	-0x29(%rbp,%r15), %rsi
    3506: 41 be 01 00 00 00            	movl	$0x1, %r14d
    350c: 4d 29 fe                     	subq	%r15, %r14
    350f: 40 0f b6 c7                  	movzbl	%dil, %eax
    3513: 48 01 c3                     	addq	%rax, %rbx
    3516: 48 89 df                     	movq	%rbx, %rdi
    3519: 4c 89 f2                     	movq	%r14, %rdx
    351c: e8 00 00 00 00               	callq	 <L55>
		000000000000351d:  X86_64_RELOC_BRANCH	_memcpy
<L55>:
    3521: 44 00 b5 10 fd ff ff         	addb	%r14b, -0x2f0(%rbp)
    3528: 49 83 c5 01                  	addq	$0x1, %r13
    352c: 49 83 d4 00                  	adcq	$0x0, %r12
    3530: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    3537: 4c 89 ad 40 fc ff ff         	movq	%r13, -0x3c0(%rbp)
    353e: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    3545: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    354c: e8 00 00 00 00               	callq	 <L56>
		000000000000354d:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L56>:
    3551: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x828>
		0000000000003554:  X86_64_RELOC_SIGNED	l___unnamed_2
    3558: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    355f: ba e0 00 00 00               	movl	$0xe0, %edx
    3564: 48 89 df                     	movq	%rbx, %rdi
    3567: e8 00 00 00 00               	callq	 <L57>
		0000000000003568:  X86_64_RELOC_BRANCH	_memcpy
<L57>:
    356c: 48 8d b5 20 fd ff ff         	leaq	-0x2e0(%rbp), %rsi
    3573: 48 89 df                     	movq	%rbx, %rdi
    3576: e8 00 00 00 00               	callq	 <L58>
		0000000000003577:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L58>:
    357b: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    3582: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    3589: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    358f: 4c 03 ad 30 fe ff ff         	addq	-0x1d0(%rbp), %r13
    3596: 49 83 d4 00                  	adcq	$0x0, %r12
    359a: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    35a1: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    35a8: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    35af: 48 85 ff                     	testq	%rdi, %rdi
    35b2: 74 49                        	je	 <L61>
    35b4: 40 80 ff 50                  	cmpb	$0x50, %dil
    35b8: 72 45                        	jb	 <L62>
    35ba: 41 be 80 00 00 00            	movl	$0x80, %r14d
    35c0: 49 29 fe                     	subq	%rdi, %r14
    35c3: 48 01 df                     	addq	%rbx, %rdi
    35c6: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    35cd: 4c 89 f2                     	movq	%r14, %rdx
    35d0: e8 00 00 00 00               	callq	 <L59>
		00000000000035d1:  X86_64_RELOC_BRANCH	_memcpy
<L59>:
    35d5: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    35dc: 48 89 de                     	movq	%rbx, %rsi
    35df: e8 00 00 00 00               	callq	 <L60>
		00000000000035e0:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L60>:
    35e4: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    35eb: 31 ff                        	xorl	%edi, %edi
    35ed: 4c 8b ad 30 fe ff ff         	movq	-0x1d0(%rbp), %r13
    35f4: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    35fb: eb 05                        	jmp	 <L63>
<L61>:
    35fd: 31 ff                        	xorl	%edi, %edi
<L62>:
    35ff: 45 31 f6                     	xorl	%r14d, %r14d
<L63>:
    3602: 4a 8d b4 35 c0 fb ff ff      	leaq	-0x440(%rbp,%r14), %rsi
    360a: 41 bf 30 00 00 00            	movl	$0x30, %r15d
    3610: 4d 29 f7                     	subq	%r14, %r15
    3613: 40 0f b6 c7                  	movzbl	%dil, %eax
    3617: 48 01 c3                     	addq	%rax, %rbx
    361a: 48 89 df                     	movq	%rbx, %rdi
    361d: 4c 89 fa                     	movq	%r15, %rdx
    3620: e8 00 00 00 00               	callq	 <L64>
		0000000000003621:  X86_64_RELOC_BRANCH	_memcpy
<L64>:
    3625: 44 00 bd 00 ff ff ff         	addb	%r15b, -0x100(%rbp)
    362c: 49 83 c5 30                  	addq	$0x30, %r13
    3630: 49 83 d4 00                  	adcq	$0x0, %r12
    3634: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    363b: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    3642: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    3649: 48 8d 9d 30 fa ff ff         	leaq	-0x5d0(%rbp), %rbx
    3650: 48 89 de                     	movq	%rbx, %rsi
    3653: e8 00 00 00 00               	callq	 <L65>
		0000000000003654:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L65>:
    3658: 48 8b 7d c8                  	movq	-0x38(%rbp), %rdi
    365c: 48 03 7d b0                  	addq	-0x50(%rbp), %rdi
    3660: 48 89 de                     	movq	%rbx, %rsi
    3663: 48 8b 55 a8                  	movq	-0x58(%rbp), %rdx
    3667: e8 00 00 00 00               	callq	 <L66>
		0000000000003668:  X86_64_RELOC_BRANCH	_memcpy
<L66>:
    366c: 48 81 c4 a8 05 00 00         	addq	$0x5a8, %rsp            ## imm = 0x5A8
    3673: 5b                           	popq	%rbx
    3674: 41 5c                        	popq	%r12
    3676: 41 5d                        	popq	%r13
    3678: 41 5e                        	popq	%r14
    367a: 41 5f                        	popq	%r15
    367c: 5d                           	popq	%rbp
    367d: c3                           	retq
    367e: 66 90                        	nop

0000000000003680 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    3680: 55                           	pushq	%rbp
    3681: 48 89 e5                     	movq	%rsp, %rbp
    3684: 41 57                        	pushq	%r15
    3686: 41 56                        	pushq	%r14
    3688: 53                           	pushq	%rbx
    3689: 50                           	pushq	%rax
    368a: 48 89 f3                     	movq	%rsi, %rbx
    368d: 49 89 fe                     	movq	%rdi, %r14
    3690: 4c 8d 7f 50                  	leaq	0x50(%rdi), %r15
    3694: 0f b6 87 d0 00 00 00         	movzbl	0xd0(%rdi), %eax
    369b: 48 8d 7c 07 50               	leaq	0x50(%rdi,%rax), %rdi
    36a0: be 80 00 00 00               	movl	$0x80, %esi
    36a5: 48 29 c6                     	subq	%rax, %rsi
    36a8: e8 00 00 00 00               	callq	 <L0>
		00000000000036a9:  X86_64_RELOC_BRANCH	___bzero
<L0>:
    36ad: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    36b5: 41 c6 44 06 50 80            	movb	$-0x80, 0x50(%r14,%rax)
    36bb: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    36c3: 8d 48 01                     	leal	0x1(%rax), %ecx
    36c6: 41 88 8e d0 00 00 00         	movb	%cl, 0xd0(%r14)
    36cd: 3c 6f                        	cmpb	$0x6f, %al
    36cf: 76 30                        	jbe	 <L2>
    36d1: 4c 89 f7                     	movq	%r14, %rdi
    36d4: 4c 89 fe                     	movq	%r15, %rsi
    36d7: e8 00 00 00 00               	callq	 <L1>
		00000000000036d8:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L1>:
    36dc: 0f 57 c0                     	xorps	%xmm0, %xmm0
    36df: 41 0f 29 47 60               	movaps	%xmm0, 0x60(%r15)
    36e4: 41 0f 29 47 50               	movaps	%xmm0, 0x50(%r15)
    36e9: 41 0f 29 47 40               	movaps	%xmm0, 0x40(%r15)
    36ee: 41 0f 29 47 30               	movaps	%xmm0, 0x30(%r15)
    36f3: 41 0f 29 47 20               	movaps	%xmm0, 0x20(%r15)
    36f8: 41 0f 29 47 10               	movaps	%xmm0, 0x10(%r15)
    36fd: 41 0f 29 07                  	movaps	%xmm0, (%r15)
<L2>:
    3701: 49 8b 06                     	movq	(%r14), %rax
    3704: 49 8b 4e 08                  	movq	0x8(%r14), %rcx
    3708: 89 c2                        	movl	%eax, %edx
    370a: c1 ea 05                     	shrl	$0x5, %edx
    370d: 8d 34 c5 00 00 00 00         	leal	(,%rax,8), %esi
    3714: 41 88 b6 cf 00 00 00         	movb	%sil, 0xcf(%r14)
    371b: 41 88 96 ce 00 00 00         	movb	%dl, 0xce(%r14)
    3722: 89 c2                        	movl	%eax, %edx
    3724: c1 ea 0d                     	shrl	$0xd, %edx
    3727: 41 88 96 cd 00 00 00         	movb	%dl, 0xcd(%r14)
    372e: 89 c2                        	movl	%eax, %edx
    3730: c1 ea 15                     	shrl	$0x15, %edx
    3733: 41 88 96 cc 00 00 00         	movb	%dl, 0xcc(%r14)
    373a: 48 89 ca                     	movq	%rcx, %rdx
    373d: 48 89 ce                     	movq	%rcx, %rsi
    3740: 48 89 c7                     	movq	%rax, %rdi
    3743: 49 89 c8                     	movq	%rcx, %r8
    3746: 49 0f a4 c0 0b               	shldq	$0xb, %rax, %r8
    374b: 49 89 c9                     	movq	%rcx, %r9
    374e: 49 0f a4 c1 13               	shldq	$0x13, %rax, %r9
    3753: 66 48 0f 6e c8               	movq	%rax, %xmm1
    3758: 48 0f ac c8 3d               	shrdq	$0x3d, %rcx, %rax
    375d: 66 48 0f 6e c1               	movq	%rcx, %xmm0
    3762: 66 0f 6e d1                  	movd	%ecx, %xmm2
    3766: 48 c1 e9 25                  	shrq	$0x25, %rcx
    376a: 48 c1 ea 35                  	shrq	$0x35, %rdx
    376e: 48 c1 ee 2d                  	shrq	$0x2d, %rsi
    3772: 48 c1 ef 25                  	shrq	$0x25, %rdi
    3776: 66 49 0f 6e d9               	movq	%r9, %xmm3
    377b: 66 49 0f 6e e0               	movq	%r8, %xmm4
    3780: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    ## xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    3784: 66 0f 73 d1 1d               	psrlq	$0x1d, %xmm1
    3789: 66 0f 6e df                  	movd	%edi, %xmm3
    378d: 66 0f 60 d9                  	punpcklbw	%xmm1, %xmm3    ## xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
    3791: 66 0f 6f 0d 97 29 00 00      	movdqa	, %xmm1 <_audit_key384+0xf0>
		0000000000003795:  X86_64_RELOC_SIGNED	__literal16
    3799: 66 0f db e1                  	pand	%xmm1, %xmm4
    379d: 66 0f 72 f3 10               	pslld	$0x10, %xmm3
    37a2: 66 0f eb dc                  	por	%xmm4, %xmm3
    37a6: 66 41 0f 7e 9e c8 00 00 00   	movd	%xmm3, 0xc8(%r14)
    37af: 66 0f 6e de                  	movd	%esi, %xmm3
    37b3: 66 0f 6e e2                  	movd	%edx, %xmm4
    37b7: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    ## xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    37bb: 66 0f db e1                  	pand	%xmm1, %xmm4
    37bf: 66 0f 6f c8                  	movdqa	%xmm0, %xmm1
    37c3: 66 0f 73 d1 1d               	psrlq	$0x1d, %xmm1
    37c8: 66 0f 6e d9                  	movd	%ecx, %xmm3
    37cc: 66 0f 60 d9                  	punpcklbw	%xmm1, %xmm3    ## xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
    37d0: 66 0f 72 f3 10               	pslld	$0x10, %xmm3
    37d5: 66 0f eb dc                  	por	%xmm4, %xmm3
    37d9: 66 0f 6f c8                  	movdqa	%xmm0, %xmm1
    37dd: 66 0f 73 d1 0d               	psrlq	$0xd, %xmm1
    37e2: 66 0f 73 d0 15               	psrlq	$0x15, %xmm0
    37e7: 66 0f 60 c1                  	punpcklbw	%xmm1, %xmm0    ## xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
    37eb: 66 0f 38 00 05 4c 29 00 00   	pshufb	, %xmm0 <_audit_key384+0x100>
		00000000000037f0:  X86_64_RELOC_SIGNED	__literal16
    37f4: 66 48 0f 6e c8               	movq	%rax, %xmm1
    37f9: 66 0f 72 d2 05               	psrld	$0x5, %xmm2
    37fe: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    ## xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    3802: 66 0f 73 f2 30               	psllq	$0x30, %xmm2
    3807: 66 0f eb d0                  	por	%xmm0, %xmm2
    380b: 66 0f 70 c2 55               	pshufd	$0x55, %xmm2, %xmm0     ## xmm0 = xmm2[1,1,1,1]
    3810: 66 0f 62 d8                  	punpckldq	%xmm0, %xmm3    ## xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1]
    3814: 66 41 0f d6 9e c0 00 00 00   	movq	%xmm3, 0xc0(%r14)
    381d: 4c 89 f7                     	movq	%r14, %rdi
    3820: 4c 89 fe                     	movq	%r15, %rsi
    3823: e8 00 00 00 00               	callq	 <L3>
		0000000000003824:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L3>:
    3828: 49 8b 46 10                  	movq	0x10(%r14), %rax
    382c: 48 0f c8                     	bswapq	%rax
    382f: 48 89 03                     	movq	%rax, (%rbx)
    3832: 49 8b 46 18                  	movq	0x18(%r14), %rax
    3836: 48 0f c8                     	bswapq	%rax
    3839: 48 89 43 08                  	movq	%rax, 0x8(%rbx)
    383d: 49 8b 46 20                  	movq	0x20(%r14), %rax
    3841: 48 0f c8                     	bswapq	%rax
    3844: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    3848: 49 8b 46 28                  	movq	0x28(%r14), %rax
    384c: 48 0f c8                     	bswapq	%rax
    384f: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    3853: 49 8b 46 30                  	movq	0x30(%r14), %rax
    3857: 48 0f c8                     	bswapq	%rax
    385a: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    385e: 49 8b 46 38                  	movq	0x38(%r14), %rax
    3862: 48 0f c8                     	bswapq	%rax
    3865: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    3869: 48 83 c4 08                  	addq	$0x8, %rsp
    386d: 5b                           	popq	%rbx
    386e: 41 5e                        	popq	%r14
    3870: 41 5f                        	popq	%r15
    3872: 5d                           	popq	%rbp
    3873: c3                           	retq
    3874: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    387e: 66 90                        	nop

0000000000003880 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    3880: 55                           	pushq	%rbp
    3881: 48 89 e5                     	movq	%rsp, %rbp
    3884: 41 57                        	pushq	%r15
    3886: 41 56                        	pushq	%r14
    3888: 41 55                        	pushq	%r13
    388a: 41 54                        	pushq	%r12
    388c: 53                           	pushq	%rbx
    388d: 48 81 ec 08 02 00 00         	subq	$0x208, %rsp            ## imm = 0x208
    3894: f3 0f 6f 06                  	movdqu	(%rsi), %xmm0
    3898: 66 0f 6f 0d b0 28 00 00      	movdqa	, %xmm1 <_audit_key384+0x110>
		000000000000389c:  X86_64_RELOC_SIGNED	__literal16
    38a0: 66 0f 38 00 c1               	pshufb	%xmm1, %xmm0
    38a5: 66 0f 7f 85 50 fd ff ff      	movdqa	%xmm0, -0x2b0(%rbp)
    38ad: f3 0f 6f 56 10               	movdqu	0x10(%rsi), %xmm2
    38b2: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38b7: 66 0f 7f 95 60 fd ff ff      	movdqa	%xmm2, -0x2a0(%rbp)
    38bf: f3 0f 6f 56 20               	movdqu	0x20(%rsi), %xmm2
    38c4: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38c9: 66 0f 7f 95 70 fd ff ff      	movdqa	%xmm2, -0x290(%rbp)
    38d1: f3 0f 6f 56 30               	movdqu	0x30(%rsi), %xmm2
    38d6: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38db: 66 0f 7f 95 80 fd ff ff      	movdqa	%xmm2, -0x280(%rbp)
    38e3: f3 0f 6f 56 40               	movdqu	0x40(%rsi), %xmm2
    38e8: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38ed: 66 0f 7f 95 90 fd ff ff      	movdqa	%xmm2, -0x270(%rbp)
    38f5: f3 0f 6f 56 50               	movdqu	0x50(%rsi), %xmm2
    38fa: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38ff: 66 0f 7f 95 a0 fd ff ff      	movdqa	%xmm2, -0x260(%rbp)
    3907: f3 0f 6f 56 60               	movdqu	0x60(%rsi), %xmm2
    390c: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    3911: 66 0f 7f 95 b0 fd ff ff      	movdqa	%xmm2, -0x250(%rbp)
    3919: f3 0f 6f 56 70               	movdqu	0x70(%rsi), %xmm2
    391e: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    3923: 66 0f 7f 95 c0 fd ff ff      	movdqa	%xmm2, -0x240(%rbp)
    392b: 66 49 0f 7e c1               	movq	%xmm0, %r9
    3930: 31 c0                        	xorl	%eax, %eax
    3932: 4c 89 ca                     	movq	%r9, %rdx
    3935: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    393f: 90                           	nop
<L0>:
    3940: 48 03 94 c5 98 fd ff ff      	addq	-0x268(%rbp,%rax,8), %rdx
    3948: 48 8b 8c c5 58 fd ff ff      	movq	-0x2a8(%rbp,%rax,8), %rcx
    3950: 48 89 ce                     	movq	%rcx, %rsi
    3953: 48 d1 ce                     	rorq	%rsi
    3956: 49 89 c8                     	movq	%rcx, %r8
    3959: 49 c1 c0 38                  	rolq	$0x38, %r8
    395d: 4c 8b 94 c5 c0 fd ff ff      	movq	-0x240(%rbp,%rax,8), %r10
    3965: 49 31 f0                     	xorq	%rsi, %r8
    3968: 48 89 ce                     	movq	%rcx, %rsi
    396b: 48 c1 ee 07                  	shrq	$0x7, %rsi
    396f: 4c 31 c6                     	xorq	%r8, %rsi
    3972: 4d 89 d0                     	movq	%r10, %r8
    3975: 49 c1 c0 2d                  	rolq	$0x2d, %r8
    3979: 48 01 d6                     	addq	%rdx, %rsi
    397c: 4c 89 d2                     	movq	%r10, %rdx
    397f: 48 c1 c2 03                  	rolq	$0x3, %rdx
    3983: 4c 31 c2                     	xorq	%r8, %rdx
    3986: 49 c1 ea 06                  	shrq	$0x6, %r10
    398a: 49 31 d2                     	xorq	%rdx, %r10
    398d: 49 01 f2                     	addq	%rsi, %r10
    3990: 4c 89 94 c5 d0 fd ff ff      	movq	%r10, -0x230(%rbp,%rax,8)
    3998: 48 ff c0                     	incq	%rax
    399b: 48 89 ca                     	movq	%rcx, %rdx
    399e: 48 83 f8 40                  	cmpq	$0x40, %rax
    39a2: 75 9c                        	jne	 <L0>
    39a4: 48 8b 47 10                  	movq	0x10(%rdi), %rax
    39a8: 48 8b 77 18                  	movq	0x18(%rdi), %rsi
    39ac: 4c 8b 47 20                  	movq	0x20(%rdi), %r8
    39b0: 48 8b 4f 30                  	movq	0x30(%rdi), %rcx
    39b4: 49 89 ca                     	movq	%rcx, %r10
    39b7: 49 c1 c2 32                  	rolq	$0x32, %r10
    39bb: 48 8b 57 38                  	movq	0x38(%rdi), %rdx
    39bf: 48 89 cb                     	movq	%rcx, %rbx
    39c2: 48 c1 c3 2e                  	rolq	$0x2e, %rbx
    39c6: 4c 8b 5f 40                  	movq	0x40(%rdi), %r11
    39ca: 49 89 ce                     	movq	%rcx, %r14
    39cd: 49 c1 c6 17                  	rolq	$0x17, %r14
    39d1: 4c 31 d3                     	xorq	%r10, %rbx
    39d4: 49 31 de                     	xorq	%rbx, %r14
    39d7: 4d 89 da                     	movq	%r11, %r10
    39da: 49 31 d2                     	xorq	%rdx, %r10
    39dd: 49 21 ca                     	andq	%rcx, %r10
    39e0: 4d 31 da                     	xorq	%r11, %r10
    39e3: 4c 03 77 48                  	addq	0x48(%rdi), %r14
    39e7: 4d 01 d1                     	addq	%r10, %r9
    39ea: 48 bb 22 ae 28 d7 98 2f 8a 42	movabsq	$0x428a2f98d728ae22, %rbx ## imm = 0x428A2F98D728AE22
    39f4: 4c 01 cb                     	addq	%r9, %rbx
    39f7: 4c 01 f3                     	addq	%r14, %rbx
    39fa: 4c 8b 57 28                  	movq	0x28(%rdi), %r10
    39fe: 49 89 c1                     	movq	%rax, %r9
    3a01: 49 c1 c1 24                  	rolq	$0x24, %r9
    3a05: 49 01 da                     	addq	%rbx, %r10
    3a08: 49 89 c6                     	movq	%rax, %r14
    3a0b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3a0f: 4d 31 ce                     	xorq	%r9, %r14
    3a12: 49 89 c7                     	movq	%rax, %r15
    3a15: 49 c1 c7 19                  	rolq	$0x19, %r15
    3a19: 4d 31 f7                     	xorq	%r14, %r15
    3a1c: 4d 89 c6                     	movq	%r8, %r14
    3a1f: 49 09 f6                     	orq	%rsi, %r14
    3a22: 49 21 c6                     	andq	%rax, %r14
    3a25: 4d 89 c1                     	movq	%r8, %r9
    3a28: 49 21 f1                     	andq	%rsi, %r9
    3a2b: 4d 09 f1                     	orq	%r14, %r9
    3a2e: 4d 01 f9                     	addq	%r15, %r9
    3a31: 49 01 d9                     	addq	%rbx, %r9
    3a34: 4c 89 d3                     	movq	%r10, %rbx
    3a37: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3a3b: 4d 89 d6                     	movq	%r10, %r14
    3a3e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3a42: 49 31 de                     	xorq	%rbx, %r14
    3a45: 4d 89 d7                     	movq	%r10, %r15
    3a48: 49 c1 c7 17                  	rolq	$0x17, %r15
    3a4c: 4d 31 f7                     	xorq	%r14, %r15
    3a4f: 48 89 d3                     	movq	%rdx, %rbx
    3a52: 48 31 cb                     	xorq	%rcx, %rbx
    3a55: 4c 21 d3                     	andq	%r10, %rbx
    3a58: 48 31 d3                     	xorq	%rdx, %rbx
    3a5b: 4c 03 9d 58 fd ff ff         	addq	-0x2a8(%rbp), %r11
    3a62: 49 01 db                     	addq	%rbx, %r11
    3a65: 48 bb cd 65 ef 23 91 44 37 71	movabsq	$0x7137449123ef65cd, %rbx ## imm = 0x7137449123EF65CD
    3a6f: 4c 01 db                     	addq	%r11, %rbx
    3a72: 4d 89 cb                     	movq	%r9, %r11
    3a75: 49 c1 c3 24                  	rolq	$0x24, %r11
    3a79: 4c 01 fb                     	addq	%r15, %rbx
    3a7c: 4d 89 ce                     	movq	%r9, %r14
    3a7f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3a83: 49 01 d8                     	addq	%rbx, %r8
    3a86: 4d 89 cf                     	movq	%r9, %r15
    3a89: 49 c1 c7 19                  	rolq	$0x19, %r15
    3a8d: 4d 31 de                     	xorq	%r11, %r14
    3a90: 4d 31 f7                     	xorq	%r14, %r15
    3a93: 49 89 f6                     	movq	%rsi, %r14
    3a96: 49 09 c6                     	orq	%rax, %r14
    3a99: 4d 21 ce                     	andq	%r9, %r14
    3a9c: 49 89 f3                     	movq	%rsi, %r11
    3a9f: 49 21 c3                     	andq	%rax, %r11
    3aa2: 4d 09 f3                     	orq	%r14, %r11
    3aa5: 4d 01 fb                     	addq	%r15, %r11
    3aa8: 4d 89 c6                     	movq	%r8, %r14
    3aab: 49 c1 c6 32                  	rolq	$0x32, %r14
    3aaf: 49 01 db                     	addq	%rbx, %r11
    3ab2: 4c 89 c3                     	movq	%r8, %rbx
    3ab5: 48 c1 c3 2e                  	rolq	$0x2e, %rbx
    3ab9: 4c 31 f3                     	xorq	%r14, %rbx
    3abc: 4d 89 c6                     	movq	%r8, %r14
    3abf: 49 c1 c6 17                  	rolq	$0x17, %r14
    3ac3: 49 31 de                     	xorq	%rbx, %r14
    3ac6: 4c 89 d3                     	movq	%r10, %rbx
    3ac9: 48 31 cb                     	xorq	%rcx, %rbx
    3acc: 4c 21 c3                     	andq	%r8, %rbx
    3acf: 48 31 cb                     	xorq	%rcx, %rbx
    3ad2: 48 03 95 60 fd ff ff         	addq	-0x2a0(%rbp), %rdx
    3ad9: 48 01 da                     	addq	%rbx, %rdx
    3adc: 48 bb 2f 3b 4d ec cf fb c0 b5	movabsq	$-0x4a3f043013b2c4d1, %rbx ## imm = 0xB5C0FBCFEC4D3B2F
    3ae6: 48 01 d3                     	addq	%rdx, %rbx
    3ae9: 4c 01 f3                     	addq	%r14, %rbx
    3aec: 48 01 de                     	addq	%rbx, %rsi
    3aef: 4c 89 da                     	movq	%r11, %rdx
    3af2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3af6: 4d 89 de                     	movq	%r11, %r14
    3af9: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3afd: 49 31 d6                     	xorq	%rdx, %r14
    3b00: 4d 89 df                     	movq	%r11, %r15
    3b03: 49 c1 c7 19                  	rolq	$0x19, %r15
    3b07: 4d 31 f7                     	xorq	%r14, %r15
    3b0a: 4d 89 ce                     	movq	%r9, %r14
    3b0d: 49 09 c6                     	orq	%rax, %r14
    3b10: 4d 21 de                     	andq	%r11, %r14
    3b13: 4c 89 ca                     	movq	%r9, %rdx
    3b16: 48 21 c2                     	andq	%rax, %rdx
    3b19: 4c 09 f2                     	orq	%r14, %rdx
    3b1c: 49 89 f6                     	movq	%rsi, %r14
    3b1f: 49 c1 c6 32                  	rolq	$0x32, %r14
    3b23: 4c 01 fa                     	addq	%r15, %rdx
    3b26: 49 89 f7                     	movq	%rsi, %r15
    3b29: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3b2d: 48 01 da                     	addq	%rbx, %rdx
    3b30: 48 89 f3                     	movq	%rsi, %rbx
    3b33: 48 c1 c3 17                  	rolq	$0x17, %rbx
    3b37: 4d 31 f7                     	xorq	%r14, %r15
    3b3a: 4c 31 fb                     	xorq	%r15, %rbx
    3b3d: 4d 89 c6                     	movq	%r8, %r14
    3b40: 4d 31 d6                     	xorq	%r10, %r14
    3b43: 49 21 f6                     	andq	%rsi, %r14
    3b46: 4d 31 d6                     	xorq	%r10, %r14
    3b49: 48 03 8d 68 fd ff ff         	addq	-0x298(%rbp), %rcx
    3b50: 4c 01 f1                     	addq	%r14, %rcx
    3b53: 49 be bc db 89 81 a5 db b5 e9	movabsq	$-0x164a245a7e762444, %r14 ## imm = 0xE9B5DBA58189DBBC
    3b5d: 49 01 ce                     	addq	%rcx, %r14
    3b60: 49 01 de                     	addq	%rbx, %r14
    3b63: 48 89 d1                     	movq	%rdx, %rcx
    3b66: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3b6a: 48 89 d3                     	movq	%rdx, %rbx
    3b6d: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3b71: 48 31 cb                     	xorq	%rcx, %rbx
    3b74: 49 89 d7                     	movq	%rdx, %r15
    3b77: 49 c1 c7 19                  	rolq	$0x19, %r15
    3b7b: 49 31 df                     	xorq	%rbx, %r15
    3b7e: 4c 89 db                     	movq	%r11, %rbx
    3b81: 4c 09 cb                     	orq	%r9, %rbx
    3b84: 48 21 d3                     	andq	%rdx, %rbx
    3b87: 4c 89 d9                     	movq	%r11, %rcx
    3b8a: 4c 21 c9                     	andq	%r9, %rcx
    3b8d: 48 09 d9                     	orq	%rbx, %rcx
    3b90: 4c 01 f9                     	addq	%r15, %rcx
    3b93: 4c 01 f1                     	addq	%r14, %rcx
    3b96: 49 01 c6                     	addq	%rax, %r14
    3b99: 4c 89 f3                     	movq	%r14, %rbx
    3b9c: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3ba0: 4d 89 f7                     	movq	%r14, %r15
    3ba3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3ba7: 49 31 df                     	xorq	%rbx, %r15
    3baa: 4d 89 f4                     	movq	%r14, %r12
    3bad: 49 c1 c4 17                  	rolq	$0x17, %r12
    3bb1: 4d 31 fc                     	xorq	%r15, %r12
    3bb4: 48 89 f3                     	movq	%rsi, %rbx
    3bb7: 4c 31 c3                     	xorq	%r8, %rbx
    3bba: 4c 21 f3                     	andq	%r14, %rbx
    3bbd: 4c 03 95 70 fd ff ff         	addq	-0x290(%rbp), %r10
    3bc4: 4c 31 c3                     	xorq	%r8, %rbx
    3bc7: 49 01 da                     	addq	%rbx, %r10
    3bca: 48 bb 38 b5 48 f3 5b c2 56 39	movabsq	$0x3956c25bf348b538, %rbx ## imm = 0x3956C25BF348B538
    3bd4: 4c 01 d3                     	addq	%r10, %rbx
    3bd7: 4c 01 e3                     	addq	%r12, %rbx
    3bda: 49 89 ca                     	movq	%rcx, %r10
    3bdd: 49 c1 c2 24                  	rolq	$0x24, %r10
    3be1: 49 01 d9                     	addq	%rbx, %r9
    3be4: 49 89 cf                     	movq	%rcx, %r15
    3be7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3beb: 4d 31 d7                     	xorq	%r10, %r15
    3bee: 49 89 cc                     	movq	%rcx, %r12
    3bf1: 49 c1 c4 19                  	rolq	$0x19, %r12
    3bf5: 4d 31 fc                     	xorq	%r15, %r12
    3bf8: 49 89 d7                     	movq	%rdx, %r15
    3bfb: 4d 09 df                     	orq	%r11, %r15
    3bfe: 49 21 cf                     	andq	%rcx, %r15
    3c01: 49 89 d2                     	movq	%rdx, %r10
    3c04: 4d 21 da                     	andq	%r11, %r10
    3c07: 4d 09 fa                     	orq	%r15, %r10
    3c0a: 4d 01 e2                     	addq	%r12, %r10
    3c0d: 49 01 da                     	addq	%rbx, %r10
    3c10: 4c 89 cb                     	movq	%r9, %rbx
    3c13: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3c17: 4d 89 cf                     	movq	%r9, %r15
    3c1a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3c1e: 49 31 df                     	xorq	%rbx, %r15
    3c21: 4c 89 cb                     	movq	%r9, %rbx
    3c24: 48 c1 c3 17                  	rolq	$0x17, %rbx
    3c28: 4c 31 fb                     	xorq	%r15, %rbx
    3c2b: 4d 89 f7                     	movq	%r14, %r15
    3c2e: 49 31 f7                     	xorq	%rsi, %r15
    3c31: 4d 21 cf                     	andq	%r9, %r15
    3c34: 49 31 f7                     	xorq	%rsi, %r15
    3c37: 4c 03 85 78 fd ff ff         	addq	-0x288(%rbp), %r8
    3c3e: 4d 01 f8                     	addq	%r15, %r8
    3c41: 49 bf 19 d0 05 b6 f1 11 f1 59	movabsq	$0x59f111f1b605d019, %r15 ## imm = 0x59F111F1B605D019
    3c4b: 4d 01 c7                     	addq	%r8, %r15
    3c4e: 4d 89 d0                     	movq	%r10, %r8
    3c51: 49 c1 c0 24                  	rolq	$0x24, %r8
    3c55: 49 01 df                     	addq	%rbx, %r15
    3c58: 4c 89 d3                     	movq	%r10, %rbx
    3c5b: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3c5f: 4d 01 fb                     	addq	%r15, %r11
    3c62: 4d 89 d4                     	movq	%r10, %r12
    3c65: 49 c1 c4 19                  	rolq	$0x19, %r12
    3c69: 4c 31 c3                     	xorq	%r8, %rbx
    3c6c: 49 31 dc                     	xorq	%rbx, %r12
    3c6f: 49 89 c8                     	movq	%rcx, %r8
    3c72: 49 09 d0                     	orq	%rdx, %r8
    3c75: 4d 21 d0                     	andq	%r10, %r8
    3c78: 48 89 cb                     	movq	%rcx, %rbx
    3c7b: 48 21 d3                     	andq	%rdx, %rbx
    3c7e: 4c 09 c3                     	orq	%r8, %rbx
    3c81: 4c 01 e3                     	addq	%r12, %rbx
    3c84: 4d 89 d8                     	movq	%r11, %r8
    3c87: 49 c1 c0 32                  	rolq	$0x32, %r8
    3c8b: 4c 01 fb                     	addq	%r15, %rbx
    3c8e: 4d 89 df                     	movq	%r11, %r15
    3c91: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3c95: 4d 31 c7                     	xorq	%r8, %r15
    3c98: 4d 89 dc                     	movq	%r11, %r12
    3c9b: 49 c1 c4 17                  	rolq	$0x17, %r12
    3c9f: 4d 31 fc                     	xorq	%r15, %r12
    3ca2: 4d 89 c8                     	movq	%r9, %r8
    3ca5: 4d 31 f0                     	xorq	%r14, %r8
    3ca8: 4d 21 d8                     	andq	%r11, %r8
    3cab: 4d 31 f0                     	xorq	%r14, %r8
    3cae: 48 03 b5 80 fd ff ff         	addq	-0x280(%rbp), %rsi
    3cb5: 4c 01 c6                     	addq	%r8, %rsi
    3cb8: 49 b8 9b 4f 19 af a4 82 3f 92	movabsq	$-0x6dc07d5b50e6b065, %r8 ## imm = 0x923F82A4AF194F9B
    3cc2: 49 01 f0                     	addq	%rsi, %r8
    3cc5: 4d 01 e0                     	addq	%r12, %r8
    3cc8: 4c 01 c2                     	addq	%r8, %rdx
    3ccb: 48 89 de                     	movq	%rbx, %rsi
    3cce: 48 c1 c6 24                  	rolq	$0x24, %rsi
    3cd2: 49 89 df                     	movq	%rbx, %r15
    3cd5: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3cd9: 49 31 f7                     	xorq	%rsi, %r15
    3cdc: 49 89 dc                     	movq	%rbx, %r12
    3cdf: 49 c1 c4 19                  	rolq	$0x19, %r12
    3ce3: 4d 31 fc                     	xorq	%r15, %r12
    3ce6: 4d 89 d7                     	movq	%r10, %r15
    3ce9: 49 09 cf                     	orq	%rcx, %r15
    3cec: 49 21 df                     	andq	%rbx, %r15
    3cef: 4c 89 d6                     	movq	%r10, %rsi
    3cf2: 48 21 ce                     	andq	%rcx, %rsi
    3cf5: 4c 09 fe                     	orq	%r15, %rsi
    3cf8: 49 89 d7                     	movq	%rdx, %r15
    3cfb: 49 c1 c7 32                  	rolq	$0x32, %r15
    3cff: 4c 01 e6                     	addq	%r12, %rsi
    3d02: 49 89 d4                     	movq	%rdx, %r12
    3d05: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3d09: 4c 01 c6                     	addq	%r8, %rsi
    3d0c: 49 89 d0                     	movq	%rdx, %r8
    3d0f: 49 c1 c0 17                  	rolq	$0x17, %r8
    3d13: 4d 31 fc                     	xorq	%r15, %r12
    3d16: 4d 31 e0                     	xorq	%r12, %r8
    3d19: 4d 89 df                     	movq	%r11, %r15
    3d1c: 4d 31 cf                     	xorq	%r9, %r15
    3d1f: 49 21 d7                     	andq	%rdx, %r15
    3d22: 4d 31 cf                     	xorq	%r9, %r15
    3d25: 4c 03 b5 88 fd ff ff         	addq	-0x278(%rbp), %r14
    3d2c: 4d 01 fe                     	addq	%r15, %r14
    3d2f: 49 bf 18 81 6d da d5 5e 1c ab	movabsq	$-0x54e3a12a25927ee8, %r15 ## imm = 0xAB1C5ED5DA6D8118
    3d39: 4d 01 f7                     	addq	%r14, %r15
    3d3c: 4d 01 c7                     	addq	%r8, %r15
    3d3f: 4c 01 f9                     	addq	%r15, %rcx
    3d42: 49 89 f0                     	movq	%rsi, %r8
    3d45: 49 c1 c0 24                  	rolq	$0x24, %r8
    3d49: 49 89 f6                     	movq	%rsi, %r14
    3d4c: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3d50: 4d 31 c6                     	xorq	%r8, %r14
    3d53: 49 89 f4                     	movq	%rsi, %r12
    3d56: 49 c1 c4 19                  	rolq	$0x19, %r12
    3d5a: 4d 31 f4                     	xorq	%r14, %r12
    3d5d: 49 89 de                     	movq	%rbx, %r14
    3d60: 4d 09 d6                     	orq	%r10, %r14
    3d63: 49 21 f6                     	andq	%rsi, %r14
    3d66: 49 89 d8                     	movq	%rbx, %r8
    3d69: 4d 21 d0                     	andq	%r10, %r8
    3d6c: 4d 09 f0                     	orq	%r14, %r8
    3d6f: 4d 01 e0                     	addq	%r12, %r8
    3d72: 4d 01 f8                     	addq	%r15, %r8
    3d75: 49 89 ce                     	movq	%rcx, %r14
    3d78: 49 c1 c6 32                  	rolq	$0x32, %r14
    3d7c: 49 89 cf                     	movq	%rcx, %r15
    3d7f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3d83: 4d 31 f7                     	xorq	%r14, %r15
    3d86: 49 89 cc                     	movq	%rcx, %r12
    3d89: 49 c1 c4 17                  	rolq	$0x17, %r12
    3d8d: 4d 31 fc                     	xorq	%r15, %r12
    3d90: 49 89 d6                     	movq	%rdx, %r14
    3d93: 4d 31 de                     	xorq	%r11, %r14
    3d96: 49 21 ce                     	andq	%rcx, %r14
    3d99: 4c 03 8d 90 fd ff ff         	addq	-0x270(%rbp), %r9
    3da0: 4d 31 de                     	xorq	%r11, %r14
    3da3: 4d 01 f1                     	addq	%r14, %r9
    3da6: 49 be 42 02 03 a3 98 aa 07 d8	movabsq	$-0x27f855675cfcfdbe, %r14 ## imm = 0xD807AA98A3030242
    3db0: 4d 01 ce                     	addq	%r9, %r14
    3db3: 4d 01 e6                     	addq	%r12, %r14
    3db6: 4d 89 c1                     	movq	%r8, %r9
    3db9: 49 c1 c1 24                  	rolq	$0x24, %r9
    3dbd: 4d 01 f2                     	addq	%r14, %r10
    3dc0: 4d 89 c7                     	movq	%r8, %r15
    3dc3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3dc7: 4d 31 cf                     	xorq	%r9, %r15
    3dca: 4d 89 c4                     	movq	%r8, %r12
    3dcd: 49 c1 c4 19                  	rolq	$0x19, %r12
    3dd1: 4d 31 fc                     	xorq	%r15, %r12
    3dd4: 49 89 f7                     	movq	%rsi, %r15
    3dd7: 49 09 df                     	orq	%rbx, %r15
    3dda: 4d 21 c7                     	andq	%r8, %r15
    3ddd: 49 89 f1                     	movq	%rsi, %r9
    3de0: 49 21 d9                     	andq	%rbx, %r9
    3de3: 4d 09 f9                     	orq	%r15, %r9
    3de6: 4d 01 e1                     	addq	%r12, %r9
    3de9: 4d 01 f1                     	addq	%r14, %r9
    3dec: 4d 89 d6                     	movq	%r10, %r14
    3def: 49 c1 c6 32                  	rolq	$0x32, %r14
    3df3: 4d 89 d7                     	movq	%r10, %r15
    3df6: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3dfa: 4d 31 f7                     	xorq	%r14, %r15
    3dfd: 4d 89 d4                     	movq	%r10, %r12
    3e00: 49 c1 c4 17                  	rolq	$0x17, %r12
    3e04: 4d 31 fc                     	xorq	%r15, %r12
    3e07: 49 89 ce                     	movq	%rcx, %r14
    3e0a: 49 31 d6                     	xorq	%rdx, %r14
    3e0d: 4d 21 d6                     	andq	%r10, %r14
    3e10: 49 31 d6                     	xorq	%rdx, %r14
    3e13: 4c 03 9d 98 fd ff ff         	addq	-0x268(%rbp), %r11
    3e1a: 4d 01 f3                     	addq	%r14, %r11
    3e1d: 49 be be 6f 70 45 01 5b 83 12	movabsq	$0x12835b0145706fbe, %r14 ## imm = 0x12835B0145706FBE
    3e27: 4d 01 de                     	addq	%r11, %r14
    3e2a: 4d 89 cb                     	movq	%r9, %r11
    3e2d: 49 c1 c3 24                  	rolq	$0x24, %r11
    3e31: 4d 01 e6                     	addq	%r12, %r14
    3e34: 4d 89 cf                     	movq	%r9, %r15
    3e37: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3e3b: 4c 01 f3                     	addq	%r14, %rbx
    3e3e: 4d 89 cc                     	movq	%r9, %r12
    3e41: 49 c1 c4 19                  	rolq	$0x19, %r12
    3e45: 4d 31 df                     	xorq	%r11, %r15
    3e48: 4d 31 fc                     	xorq	%r15, %r12
    3e4b: 4d 89 c7                     	movq	%r8, %r15
    3e4e: 49 09 f7                     	orq	%rsi, %r15
    3e51: 4d 21 cf                     	andq	%r9, %r15
    3e54: 4d 89 c3                     	movq	%r8, %r11
    3e57: 49 21 f3                     	andq	%rsi, %r11
    3e5a: 4d 09 fb                     	orq	%r15, %r11
    3e5d: 4d 01 e3                     	addq	%r12, %r11
    3e60: 49 89 df                     	movq	%rbx, %r15
    3e63: 49 c1 c7 32                  	rolq	$0x32, %r15
    3e67: 4d 01 f3                     	addq	%r14, %r11
    3e6a: 49 89 de                     	movq	%rbx, %r14
    3e6d: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3e71: 4d 31 fe                     	xorq	%r15, %r14
    3e74: 49 89 df                     	movq	%rbx, %r15
    3e77: 49 c1 c7 17                  	rolq	$0x17, %r15
    3e7b: 4d 31 f7                     	xorq	%r14, %r15
    3e7e: 4d 89 d6                     	movq	%r10, %r14
    3e81: 49 31 ce                     	xorq	%rcx, %r14
    3e84: 49 21 de                     	andq	%rbx, %r14
    3e87: 49 31 ce                     	xorq	%rcx, %r14
    3e8a: 48 03 95 a0 fd ff ff         	addq	-0x260(%rbp), %rdx
    3e91: 4c 01 f2                     	addq	%r14, %rdx
    3e94: 49 be 8c b2 e4 4e be 85 31 24	movabsq	$0x243185be4ee4b28c, %r14 ## imm = 0x243185BE4EE4B28C
    3e9e: 49 01 d6                     	addq	%rdx, %r14
    3ea1: 4d 01 fe                     	addq	%r15, %r14
    3ea4: 4c 01 f6                     	addq	%r14, %rsi
    3ea7: 4c 89 da                     	movq	%r11, %rdx
    3eaa: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3eae: 4d 89 df                     	movq	%r11, %r15
    3eb1: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3eb5: 49 31 d7                     	xorq	%rdx, %r15
    3eb8: 4d 89 dc                     	movq	%r11, %r12
    3ebb: 49 c1 c4 19                  	rolq	$0x19, %r12
    3ebf: 4d 31 fc                     	xorq	%r15, %r12
    3ec2: 4d 89 cf                     	movq	%r9, %r15
    3ec5: 4d 09 c7                     	orq	%r8, %r15
    3ec8: 4d 21 df                     	andq	%r11, %r15
    3ecb: 4c 89 ca                     	movq	%r9, %rdx
    3ece: 4c 21 c2                     	andq	%r8, %rdx
    3ed1: 4c 09 fa                     	orq	%r15, %rdx
    3ed4: 49 89 f7                     	movq	%rsi, %r15
    3ed7: 49 c1 c7 32                  	rolq	$0x32, %r15
    3edb: 4c 01 e2                     	addq	%r12, %rdx
    3ede: 49 89 f4                     	movq	%rsi, %r12
    3ee1: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3ee5: 4c 01 f2                     	addq	%r14, %rdx
    3ee8: 49 89 f6                     	movq	%rsi, %r14
    3eeb: 49 c1 c6 17                  	rolq	$0x17, %r14
    3eef: 4d 31 fc                     	xorq	%r15, %r12
    3ef2: 4d 31 e6                     	xorq	%r12, %r14
    3ef5: 49 89 df                     	movq	%rbx, %r15
    3ef8: 4d 31 d7                     	xorq	%r10, %r15
    3efb: 49 21 f7                     	andq	%rsi, %r15
    3efe: 4d 31 d7                     	xorq	%r10, %r15
    3f01: 48 03 8d a8 fd ff ff         	addq	-0x258(%rbp), %rcx
    3f08: 4c 01 f9                     	addq	%r15, %rcx
    3f0b: 49 bf e2 b4 ff d5 c3 7d 0c 55	movabsq	$0x550c7dc3d5ffb4e2, %r15 ## imm = 0x550C7DC3D5FFB4E2
    3f15: 49 01 cf                     	addq	%rcx, %r15
    3f18: 4d 01 f7                     	addq	%r14, %r15
    3f1b: 4d 01 f8                     	addq	%r15, %r8
    3f1e: 48 89 d1                     	movq	%rdx, %rcx
    3f21: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3f25: 49 89 d6                     	movq	%rdx, %r14
    3f28: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3f2c: 49 31 ce                     	xorq	%rcx, %r14
    3f2f: 49 89 d4                     	movq	%rdx, %r12
    3f32: 49 c1 c4 19                  	rolq	$0x19, %r12
    3f36: 4d 31 f4                     	xorq	%r14, %r12
    3f39: 4d 89 de                     	movq	%r11, %r14
    3f3c: 4d 09 ce                     	orq	%r9, %r14
    3f3f: 49 21 d6                     	andq	%rdx, %r14
    3f42: 4c 89 d9                     	movq	%r11, %rcx
    3f45: 4c 21 c9                     	andq	%r9, %rcx
    3f48: 4c 09 f1                     	orq	%r14, %rcx
    3f4b: 4c 01 e1                     	addq	%r12, %rcx
    3f4e: 4c 01 f9                     	addq	%r15, %rcx
    3f51: 4d 89 c6                     	movq	%r8, %r14
    3f54: 49 c1 c6 32                  	rolq	$0x32, %r14
    3f58: 4d 89 c7                     	movq	%r8, %r15
    3f5b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3f5f: 4d 31 f7                     	xorq	%r14, %r15
    3f62: 4d 89 c4                     	movq	%r8, %r12
    3f65: 49 c1 c4 17                  	rolq	$0x17, %r12
    3f69: 4d 31 fc                     	xorq	%r15, %r12
    3f6c: 49 89 f6                     	movq	%rsi, %r14
    3f6f: 49 31 de                     	xorq	%rbx, %r14
    3f72: 4d 21 c6                     	andq	%r8, %r14
    3f75: 4c 03 95 b0 fd ff ff         	addq	-0x250(%rbp), %r10
    3f7c: 49 31 de                     	xorq	%rbx, %r14
    3f7f: 4d 01 f2                     	addq	%r14, %r10
    3f82: 49 be 6f 89 7b f2 74 5d be 72	movabsq	$0x72be5d74f27b896f, %r14 ## imm = 0x72BE5D74F27B896F
    3f8c: 4d 01 d6                     	addq	%r10, %r14
    3f8f: 4d 01 e6                     	addq	%r12, %r14
    3f92: 49 89 ca                     	movq	%rcx, %r10
    3f95: 49 c1 c2 24                  	rolq	$0x24, %r10
    3f99: 4d 01 f1                     	addq	%r14, %r9
    3f9c: 49 89 cf                     	movq	%rcx, %r15
    3f9f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3fa3: 4d 31 d7                     	xorq	%r10, %r15
    3fa6: 49 89 cc                     	movq	%rcx, %r12
    3fa9: 49 c1 c4 19                  	rolq	$0x19, %r12
    3fad: 4d 31 fc                     	xorq	%r15, %r12
    3fb0: 49 89 d7                     	movq	%rdx, %r15
    3fb3: 4d 09 df                     	orq	%r11, %r15
    3fb6: 49 21 cf                     	andq	%rcx, %r15
    3fb9: 49 89 d2                     	movq	%rdx, %r10
    3fbc: 4d 21 da                     	andq	%r11, %r10
    3fbf: 4d 09 fa                     	orq	%r15, %r10
    3fc2: 4d 01 e2                     	addq	%r12, %r10
    3fc5: 4d 01 f2                     	addq	%r14, %r10
    3fc8: 4d 89 ce                     	movq	%r9, %r14
    3fcb: 49 c1 c6 32                  	rolq	$0x32, %r14
    3fcf: 4d 89 cf                     	movq	%r9, %r15
    3fd2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3fd6: 4d 31 f7                     	xorq	%r14, %r15
    3fd9: 4d 89 cc                     	movq	%r9, %r12
    3fdc: 49 c1 c4 17                  	rolq	$0x17, %r12
    3fe0: 4d 31 fc                     	xorq	%r15, %r12
    3fe3: 4d 89 c6                     	movq	%r8, %r14
    3fe6: 49 31 f6                     	xorq	%rsi, %r14
    3fe9: 4d 21 ce                     	andq	%r9, %r14
    3fec: 49 31 f6                     	xorq	%rsi, %r14
    3fef: 48 03 9d b8 fd ff ff         	addq	-0x248(%rbp), %rbx
    3ff6: 4c 01 f3                     	addq	%r14, %rbx
    3ff9: 49 be b1 96 16 3b fe b1 de 80	movabsq	$-0x7f214e01c4e9694f, %r14 ## imm = 0x80DEB1FE3B1696B1
    4003: 49 01 de                     	addq	%rbx, %r14
    4006: 4c 89 d3                     	movq	%r10, %rbx
    4009: 48 c1 c3 24                  	rolq	$0x24, %rbx
    400d: 4d 01 e6                     	addq	%r12, %r14
    4010: 4d 89 d7                     	movq	%r10, %r15
    4013: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4017: 4d 01 f3                     	addq	%r14, %r11
    401a: 4d 89 d4                     	movq	%r10, %r12
    401d: 49 c1 c4 19                  	rolq	$0x19, %r12
    4021: 49 31 df                     	xorq	%rbx, %r15
    4024: 4d 31 fc                     	xorq	%r15, %r12
    4027: 49 89 cf                     	movq	%rcx, %r15
    402a: 49 09 d7                     	orq	%rdx, %r15
    402d: 4d 21 d7                     	andq	%r10, %r15
    4030: 48 89 cb                     	movq	%rcx, %rbx
    4033: 48 21 d3                     	andq	%rdx, %rbx
    4036: 4c 09 fb                     	orq	%r15, %rbx
    4039: 4c 01 e3                     	addq	%r12, %rbx
    403c: 4d 89 df                     	movq	%r11, %r15
    403f: 49 c1 c7 32                  	rolq	$0x32, %r15
    4043: 4c 01 f3                     	addq	%r14, %rbx
    4046: 4d 89 de                     	movq	%r11, %r14
    4049: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    404d: 4d 31 fe                     	xorq	%r15, %r14
    4050: 4d 89 df                     	movq	%r11, %r15
    4053: 49 c1 c7 17                  	rolq	$0x17, %r15
    4057: 4d 31 f7                     	xorq	%r14, %r15
    405a: 4d 89 ce                     	movq	%r9, %r14
    405d: 4d 31 c6                     	xorq	%r8, %r14
    4060: 4d 21 de                     	andq	%r11, %r14
    4063: 4d 31 c6                     	xorq	%r8, %r14
    4066: 48 03 b5 c0 fd ff ff         	addq	-0x240(%rbp), %rsi
    406d: 4c 01 f6                     	addq	%r14, %rsi
    4070: 49 be 35 12 c7 25 a7 06 dc 9b	movabsq	$-0x6423f958da38edcb, %r14 ## imm = 0x9BDC06A725C71235
    407a: 49 01 f6                     	addq	%rsi, %r14
    407d: 4d 01 fe                     	addq	%r15, %r14
    4080: 4c 01 f2                     	addq	%r14, %rdx
    4083: 48 89 de                     	movq	%rbx, %rsi
    4086: 48 c1 c6 24                  	rolq	$0x24, %rsi
    408a: 49 89 df                     	movq	%rbx, %r15
    408d: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4091: 49 31 f7                     	xorq	%rsi, %r15
    4094: 49 89 dc                     	movq	%rbx, %r12
    4097: 49 c1 c4 19                  	rolq	$0x19, %r12
    409b: 4d 31 fc                     	xorq	%r15, %r12
    409e: 4d 89 d7                     	movq	%r10, %r15
    40a1: 49 09 cf                     	orq	%rcx, %r15
    40a4: 49 21 df                     	andq	%rbx, %r15
    40a7: 4c 89 d6                     	movq	%r10, %rsi
    40aa: 48 21 ce                     	andq	%rcx, %rsi
    40ad: 4c 09 fe                     	orq	%r15, %rsi
    40b0: 49 89 d7                     	movq	%rdx, %r15
    40b3: 49 c1 c7 32                  	rolq	$0x32, %r15
    40b7: 4c 01 e6                     	addq	%r12, %rsi
    40ba: 49 89 d4                     	movq	%rdx, %r12
    40bd: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    40c1: 4c 01 f6                     	addq	%r14, %rsi
    40c4: 49 89 d6                     	movq	%rdx, %r14
    40c7: 49 c1 c6 17                  	rolq	$0x17, %r14
    40cb: 4d 31 fc                     	xorq	%r15, %r12
    40ce: 4d 31 e6                     	xorq	%r12, %r14
    40d1: 4d 89 df                     	movq	%r11, %r15
    40d4: 4d 31 cf                     	xorq	%r9, %r15
    40d7: 49 21 d7                     	andq	%rdx, %r15
    40da: 4d 31 cf                     	xorq	%r9, %r15
    40dd: 4c 03 85 c8 fd ff ff         	addq	-0x238(%rbp), %r8
    40e4: 4d 01 f8                     	addq	%r15, %r8
    40e7: 49 bf 94 26 69 cf 74 f1 9b c1	movabsq	$-0x3e640e8b3096d96c, %r15 ## imm = 0xC19BF174CF692694
    40f1: 4d 01 c7                     	addq	%r8, %r15
    40f4: 4d 01 f7                     	addq	%r14, %r15
    40f7: 4c 01 f9                     	addq	%r15, %rcx
    40fa: 49 89 f0                     	movq	%rsi, %r8
    40fd: 49 c1 c0 24                  	rolq	$0x24, %r8
    4101: 49 89 f6                     	movq	%rsi, %r14
    4104: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4108: 4d 31 c6                     	xorq	%r8, %r14
    410b: 49 89 f4                     	movq	%rsi, %r12
    410e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4112: 4d 31 f4                     	xorq	%r14, %r12
    4115: 49 89 de                     	movq	%rbx, %r14
    4118: 4d 09 d6                     	orq	%r10, %r14
    411b: 49 21 f6                     	andq	%rsi, %r14
    411e: 49 89 d8                     	movq	%rbx, %r8
    4121: 4d 21 d0                     	andq	%r10, %r8
    4124: 4d 09 f0                     	orq	%r14, %r8
    4127: 4d 01 e0                     	addq	%r12, %r8
    412a: 4d 01 f8                     	addq	%r15, %r8
    412d: 49 89 ce                     	movq	%rcx, %r14
    4130: 49 c1 c6 32                  	rolq	$0x32, %r14
    4134: 49 89 cf                     	movq	%rcx, %r15
    4137: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    413b: 4d 31 f7                     	xorq	%r14, %r15
    413e: 49 89 cc                     	movq	%rcx, %r12
    4141: 49 c1 c4 17                  	rolq	$0x17, %r12
    4145: 4d 31 fc                     	xorq	%r15, %r12
    4148: 49 89 d6                     	movq	%rdx, %r14
    414b: 4d 31 de                     	xorq	%r11, %r14
    414e: 49 21 ce                     	andq	%rcx, %r14
    4151: 4c 03 8d d0 fd ff ff         	addq	-0x230(%rbp), %r9
    4158: 4d 31 de                     	xorq	%r11, %r14
    415b: 4d 01 f1                     	addq	%r14, %r9
    415e: 49 be d2 4a f1 9e c1 69 9b e4	movabsq	$-0x1b64963e610eb52e, %r14 ## imm = 0xE49B69C19EF14AD2
    4168: 4d 01 ce                     	addq	%r9, %r14
    416b: 4d 01 e6                     	addq	%r12, %r14
    416e: 4d 89 c1                     	movq	%r8, %r9
    4171: 49 c1 c1 24                  	rolq	$0x24, %r9
    4175: 4d 01 f2                     	addq	%r14, %r10
    4178: 4d 89 c7                     	movq	%r8, %r15
    417b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    417f: 4d 31 cf                     	xorq	%r9, %r15
    4182: 4d 89 c4                     	movq	%r8, %r12
    4185: 49 c1 c4 19                  	rolq	$0x19, %r12
    4189: 4d 31 fc                     	xorq	%r15, %r12
    418c: 49 89 f7                     	movq	%rsi, %r15
    418f: 49 09 df                     	orq	%rbx, %r15
    4192: 4d 21 c7                     	andq	%r8, %r15
    4195: 49 89 f1                     	movq	%rsi, %r9
    4198: 49 21 d9                     	andq	%rbx, %r9
    419b: 4d 09 f9                     	orq	%r15, %r9
    419e: 4d 01 e1                     	addq	%r12, %r9
    41a1: 4d 01 f1                     	addq	%r14, %r9
    41a4: 4d 89 d6                     	movq	%r10, %r14
    41a7: 49 c1 c6 32                  	rolq	$0x32, %r14
    41ab: 4d 89 d7                     	movq	%r10, %r15
    41ae: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    41b2: 4d 31 f7                     	xorq	%r14, %r15
    41b5: 4d 89 d4                     	movq	%r10, %r12
    41b8: 49 c1 c4 17                  	rolq	$0x17, %r12
    41bc: 4d 31 fc                     	xorq	%r15, %r12
    41bf: 49 89 ce                     	movq	%rcx, %r14
    41c2: 49 31 d6                     	xorq	%rdx, %r14
    41c5: 4d 21 d6                     	andq	%r10, %r14
    41c8: 49 31 d6                     	xorq	%rdx, %r14
    41cb: 4c 03 9d d8 fd ff ff         	addq	-0x228(%rbp), %r11
    41d2: 4d 01 f3                     	addq	%r14, %r11
    41d5: 49 be e3 25 4f 38 86 47 be ef	movabsq	$-0x1041b879c7b0da1d, %r14 ## imm = 0xEFBE4786384F25E3
    41df: 4d 01 de                     	addq	%r11, %r14
    41e2: 4d 89 cb                     	movq	%r9, %r11
    41e5: 49 c1 c3 24                  	rolq	$0x24, %r11
    41e9: 4d 01 e6                     	addq	%r12, %r14
    41ec: 4d 89 cf                     	movq	%r9, %r15
    41ef: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    41f3: 4c 01 f3                     	addq	%r14, %rbx
    41f6: 4d 89 cc                     	movq	%r9, %r12
    41f9: 49 c1 c4 19                  	rolq	$0x19, %r12
    41fd: 4d 31 df                     	xorq	%r11, %r15
    4200: 4d 31 fc                     	xorq	%r15, %r12
    4203: 4d 89 c7                     	movq	%r8, %r15
    4206: 49 09 f7                     	orq	%rsi, %r15
    4209: 4d 21 cf                     	andq	%r9, %r15
    420c: 4d 89 c3                     	movq	%r8, %r11
    420f: 49 21 f3                     	andq	%rsi, %r11
    4212: 4d 09 fb                     	orq	%r15, %r11
    4215: 4d 01 e3                     	addq	%r12, %r11
    4218: 49 89 df                     	movq	%rbx, %r15
    421b: 49 c1 c7 32                  	rolq	$0x32, %r15
    421f: 4d 01 f3                     	addq	%r14, %r11
    4222: 49 89 de                     	movq	%rbx, %r14
    4225: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4229: 4d 31 fe                     	xorq	%r15, %r14
    422c: 49 89 df                     	movq	%rbx, %r15
    422f: 49 c1 c7 17                  	rolq	$0x17, %r15
    4233: 4d 31 f7                     	xorq	%r14, %r15
    4236: 4d 89 d6                     	movq	%r10, %r14
    4239: 49 31 ce                     	xorq	%rcx, %r14
    423c: 49 21 de                     	andq	%rbx, %r14
    423f: 49 31 ce                     	xorq	%rcx, %r14
    4242: 48 03 95 e0 fd ff ff         	addq	-0x220(%rbp), %rdx
    4249: 4c 01 f2                     	addq	%r14, %rdx
    424c: 49 be b5 d5 8c 8b c6 9d c1 0f	movabsq	$0xfc19dc68b8cd5b5, %r14 ## imm = 0xFC19DC68B8CD5B5
    4256: 49 01 d6                     	addq	%rdx, %r14
    4259: 4d 01 fe                     	addq	%r15, %r14
    425c: 4c 01 f6                     	addq	%r14, %rsi
    425f: 4c 89 da                     	movq	%r11, %rdx
    4262: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4266: 4d 89 df                     	movq	%r11, %r15
    4269: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    426d: 49 31 d7                     	xorq	%rdx, %r15
    4270: 4d 89 dc                     	movq	%r11, %r12
    4273: 49 c1 c4 19                  	rolq	$0x19, %r12
    4277: 4d 31 fc                     	xorq	%r15, %r12
    427a: 4d 89 cf                     	movq	%r9, %r15
    427d: 4d 09 c7                     	orq	%r8, %r15
    4280: 4d 21 df                     	andq	%r11, %r15
    4283: 4c 89 ca                     	movq	%r9, %rdx
    4286: 4c 21 c2                     	andq	%r8, %rdx
    4289: 4c 09 fa                     	orq	%r15, %rdx
    428c: 49 89 f7                     	movq	%rsi, %r15
    428f: 49 c1 c7 32                  	rolq	$0x32, %r15
    4293: 4c 01 e2                     	addq	%r12, %rdx
    4296: 49 89 f4                     	movq	%rsi, %r12
    4299: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    429d: 4c 01 f2                     	addq	%r14, %rdx
    42a0: 49 89 f6                     	movq	%rsi, %r14
    42a3: 49 c1 c6 17                  	rolq	$0x17, %r14
    42a7: 4d 31 fc                     	xorq	%r15, %r12
    42aa: 4d 31 e6                     	xorq	%r12, %r14
    42ad: 49 89 df                     	movq	%rbx, %r15
    42b0: 4d 31 d7                     	xorq	%r10, %r15
    42b3: 49 21 f7                     	andq	%rsi, %r15
    42b6: 4d 31 d7                     	xorq	%r10, %r15
    42b9: 48 03 8d e8 fd ff ff         	addq	-0x218(%rbp), %rcx
    42c0: 4c 01 f9                     	addq	%r15, %rcx
    42c3: 49 bf 65 9c ac 77 cc a1 0c 24	movabsq	$0x240ca1cc77ac9c65, %r15 ## imm = 0x240CA1CC77AC9C65
    42cd: 49 01 cf                     	addq	%rcx, %r15
    42d0: 4d 01 f7                     	addq	%r14, %r15
    42d3: 4d 01 f8                     	addq	%r15, %r8
    42d6: 48 89 d1                     	movq	%rdx, %rcx
    42d9: 48 c1 c1 24                  	rolq	$0x24, %rcx
    42dd: 49 89 d6                     	movq	%rdx, %r14
    42e0: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    42e4: 49 31 ce                     	xorq	%rcx, %r14
    42e7: 49 89 d4                     	movq	%rdx, %r12
    42ea: 49 c1 c4 19                  	rolq	$0x19, %r12
    42ee: 4d 31 f4                     	xorq	%r14, %r12
    42f1: 4d 89 de                     	movq	%r11, %r14
    42f4: 4d 09 ce                     	orq	%r9, %r14
    42f7: 49 21 d6                     	andq	%rdx, %r14
    42fa: 4c 89 d9                     	movq	%r11, %rcx
    42fd: 4c 21 c9                     	andq	%r9, %rcx
    4300: 4c 09 f1                     	orq	%r14, %rcx
    4303: 4c 01 e1                     	addq	%r12, %rcx
    4306: 4c 01 f9                     	addq	%r15, %rcx
    4309: 4d 89 c6                     	movq	%r8, %r14
    430c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4310: 4d 89 c7                     	movq	%r8, %r15
    4313: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4317: 4d 31 f7                     	xorq	%r14, %r15
    431a: 4d 89 c4                     	movq	%r8, %r12
    431d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4321: 4d 31 fc                     	xorq	%r15, %r12
    4324: 49 89 f6                     	movq	%rsi, %r14
    4327: 49 31 de                     	xorq	%rbx, %r14
    432a: 4d 21 c6                     	andq	%r8, %r14
    432d: 4c 03 95 f0 fd ff ff         	addq	-0x210(%rbp), %r10
    4334: 49 31 de                     	xorq	%rbx, %r14
    4337: 4d 01 f2                     	addq	%r14, %r10
    433a: 49 be 75 02 2b 59 6f 2c e9 2d	movabsq	$0x2de92c6f592b0275, %r14 ## imm = 0x2DE92C6F592B0275
    4344: 4d 01 d6                     	addq	%r10, %r14
    4347: 4d 01 e6                     	addq	%r12, %r14
    434a: 49 89 ca                     	movq	%rcx, %r10
    434d: 49 c1 c2 24                  	rolq	$0x24, %r10
    4351: 4d 01 f1                     	addq	%r14, %r9
    4354: 49 89 cf                     	movq	%rcx, %r15
    4357: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    435b: 4d 31 d7                     	xorq	%r10, %r15
    435e: 49 89 cc                     	movq	%rcx, %r12
    4361: 49 c1 c4 19                  	rolq	$0x19, %r12
    4365: 4d 31 fc                     	xorq	%r15, %r12
    4368: 49 89 d7                     	movq	%rdx, %r15
    436b: 4d 09 df                     	orq	%r11, %r15
    436e: 49 21 cf                     	andq	%rcx, %r15
    4371: 49 89 d2                     	movq	%rdx, %r10
    4374: 4d 21 da                     	andq	%r11, %r10
    4377: 4d 09 fa                     	orq	%r15, %r10
    437a: 4d 01 e2                     	addq	%r12, %r10
    437d: 4d 01 f2                     	addq	%r14, %r10
    4380: 4d 89 ce                     	movq	%r9, %r14
    4383: 49 c1 c6 32                  	rolq	$0x32, %r14
    4387: 4d 89 cf                     	movq	%r9, %r15
    438a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    438e: 4d 31 f7                     	xorq	%r14, %r15
    4391: 4d 89 cc                     	movq	%r9, %r12
    4394: 49 c1 c4 17                  	rolq	$0x17, %r12
    4398: 4d 31 fc                     	xorq	%r15, %r12
    439b: 4d 89 c6                     	movq	%r8, %r14
    439e: 49 31 f6                     	xorq	%rsi, %r14
    43a1: 4d 21 ce                     	andq	%r9, %r14
    43a4: 49 31 f6                     	xorq	%rsi, %r14
    43a7: 48 03 9d f8 fd ff ff         	addq	-0x208(%rbp), %rbx
    43ae: 4c 01 f3                     	addq	%r14, %rbx
    43b1: 49 be 83 e4 a6 6e aa 84 74 4a	movabsq	$0x4a7484aa6ea6e483, %r14 ## imm = 0x4A7484AA6EA6E483
    43bb: 49 01 de                     	addq	%rbx, %r14
    43be: 4c 89 d3                     	movq	%r10, %rbx
    43c1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    43c5: 4d 01 e6                     	addq	%r12, %r14
    43c8: 4d 89 d7                     	movq	%r10, %r15
    43cb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    43cf: 4d 01 f3                     	addq	%r14, %r11
    43d2: 4d 89 d4                     	movq	%r10, %r12
    43d5: 49 c1 c4 19                  	rolq	$0x19, %r12
    43d9: 49 31 df                     	xorq	%rbx, %r15
    43dc: 4d 31 fc                     	xorq	%r15, %r12
    43df: 49 89 cf                     	movq	%rcx, %r15
    43e2: 49 09 d7                     	orq	%rdx, %r15
    43e5: 4d 21 d7                     	andq	%r10, %r15
    43e8: 48 89 cb                     	movq	%rcx, %rbx
    43eb: 48 21 d3                     	andq	%rdx, %rbx
    43ee: 4c 09 fb                     	orq	%r15, %rbx
    43f1: 4c 01 e3                     	addq	%r12, %rbx
    43f4: 4d 89 df                     	movq	%r11, %r15
    43f7: 49 c1 c7 32                  	rolq	$0x32, %r15
    43fb: 4c 01 f3                     	addq	%r14, %rbx
    43fe: 4d 89 de                     	movq	%r11, %r14
    4401: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4405: 4d 31 fe                     	xorq	%r15, %r14
    4408: 4d 89 df                     	movq	%r11, %r15
    440b: 49 c1 c7 17                  	rolq	$0x17, %r15
    440f: 4d 31 f7                     	xorq	%r14, %r15
    4412: 4d 89 ce                     	movq	%r9, %r14
    4415: 4d 31 c6                     	xorq	%r8, %r14
    4418: 4d 21 de                     	andq	%r11, %r14
    441b: 4d 31 c6                     	xorq	%r8, %r14
    441e: 48 03 b5 00 fe ff ff         	addq	-0x200(%rbp), %rsi
    4425: 4c 01 f6                     	addq	%r14, %rsi
    4428: 49 be d4 fb 41 bd dc a9 b0 5c	movabsq	$0x5cb0a9dcbd41fbd4, %r14 ## imm = 0x5CB0A9DCBD41FBD4
    4432: 49 01 f6                     	addq	%rsi, %r14
    4435: 4d 01 fe                     	addq	%r15, %r14
    4438: 4c 01 f2                     	addq	%r14, %rdx
    443b: 48 89 de                     	movq	%rbx, %rsi
    443e: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4442: 49 89 df                     	movq	%rbx, %r15
    4445: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4449: 49 31 f7                     	xorq	%rsi, %r15
    444c: 49 89 dc                     	movq	%rbx, %r12
    444f: 49 c1 c4 19                  	rolq	$0x19, %r12
    4453: 4d 31 fc                     	xorq	%r15, %r12
    4456: 4d 89 d7                     	movq	%r10, %r15
    4459: 49 09 cf                     	orq	%rcx, %r15
    445c: 49 21 df                     	andq	%rbx, %r15
    445f: 4c 89 d6                     	movq	%r10, %rsi
    4462: 48 21 ce                     	andq	%rcx, %rsi
    4465: 4c 09 fe                     	orq	%r15, %rsi
    4468: 49 89 d7                     	movq	%rdx, %r15
    446b: 49 c1 c7 32                  	rolq	$0x32, %r15
    446f: 4c 01 e6                     	addq	%r12, %rsi
    4472: 49 89 d4                     	movq	%rdx, %r12
    4475: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4479: 4c 01 f6                     	addq	%r14, %rsi
    447c: 49 89 d6                     	movq	%rdx, %r14
    447f: 49 c1 c6 17                  	rolq	$0x17, %r14
    4483: 4d 31 fc                     	xorq	%r15, %r12
    4486: 4d 31 e6                     	xorq	%r12, %r14
    4489: 4d 89 df                     	movq	%r11, %r15
    448c: 4d 31 cf                     	xorq	%r9, %r15
    448f: 49 21 d7                     	andq	%rdx, %r15
    4492: 4d 31 cf                     	xorq	%r9, %r15
    4495: 4c 03 85 08 fe ff ff         	addq	-0x1f8(%rbp), %r8
    449c: 4d 01 f8                     	addq	%r15, %r8
    449f: 49 bf b5 53 11 83 da 88 f9 76	movabsq	$0x76f988da831153b5, %r15 ## imm = 0x76F988DA831153B5
    44a9: 4d 01 c7                     	addq	%r8, %r15
    44ac: 4d 01 f7                     	addq	%r14, %r15
    44af: 4c 01 f9                     	addq	%r15, %rcx
    44b2: 49 89 f0                     	movq	%rsi, %r8
    44b5: 49 c1 c0 24                  	rolq	$0x24, %r8
    44b9: 49 89 f6                     	movq	%rsi, %r14
    44bc: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    44c0: 4d 31 c6                     	xorq	%r8, %r14
    44c3: 49 89 f4                     	movq	%rsi, %r12
    44c6: 49 c1 c4 19                  	rolq	$0x19, %r12
    44ca: 4d 31 f4                     	xorq	%r14, %r12
    44cd: 49 89 de                     	movq	%rbx, %r14
    44d0: 4d 09 d6                     	orq	%r10, %r14
    44d3: 49 21 f6                     	andq	%rsi, %r14
    44d6: 49 89 d8                     	movq	%rbx, %r8
    44d9: 4d 21 d0                     	andq	%r10, %r8
    44dc: 4d 09 f0                     	orq	%r14, %r8
    44df: 4d 01 e0                     	addq	%r12, %r8
    44e2: 4d 01 f8                     	addq	%r15, %r8
    44e5: 49 89 ce                     	movq	%rcx, %r14
    44e8: 49 c1 c6 32                  	rolq	$0x32, %r14
    44ec: 49 89 cf                     	movq	%rcx, %r15
    44ef: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    44f3: 4d 31 f7                     	xorq	%r14, %r15
    44f6: 49 89 cc                     	movq	%rcx, %r12
    44f9: 49 c1 c4 17                  	rolq	$0x17, %r12
    44fd: 4d 31 fc                     	xorq	%r15, %r12
    4500: 49 89 d6                     	movq	%rdx, %r14
    4503: 4d 31 de                     	xorq	%r11, %r14
    4506: 49 21 ce                     	andq	%rcx, %r14
    4509: 4c 03 8d 10 fe ff ff         	addq	-0x1f0(%rbp), %r9
    4510: 4d 31 de                     	xorq	%r11, %r14
    4513: 4d 01 f1                     	addq	%r14, %r9
    4516: 49 be ab df 66 ee 52 51 3e 98	movabsq	$-0x67c1aead11992055, %r14 ## imm = 0x983E5152EE66DFAB
    4520: 4d 01 ce                     	addq	%r9, %r14
    4523: 4d 01 e6                     	addq	%r12, %r14
    4526: 4d 89 c1                     	movq	%r8, %r9
    4529: 49 c1 c1 24                  	rolq	$0x24, %r9
    452d: 4d 01 f2                     	addq	%r14, %r10
    4530: 4d 89 c7                     	movq	%r8, %r15
    4533: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4537: 4d 31 cf                     	xorq	%r9, %r15
    453a: 4d 89 c4                     	movq	%r8, %r12
    453d: 49 c1 c4 19                  	rolq	$0x19, %r12
    4541: 4d 31 fc                     	xorq	%r15, %r12
    4544: 49 89 f7                     	movq	%rsi, %r15
    4547: 49 09 df                     	orq	%rbx, %r15
    454a: 4d 21 c7                     	andq	%r8, %r15
    454d: 49 89 f1                     	movq	%rsi, %r9
    4550: 49 21 d9                     	andq	%rbx, %r9
    4553: 4d 09 f9                     	orq	%r15, %r9
    4556: 4d 01 e1                     	addq	%r12, %r9
    4559: 4d 01 f1                     	addq	%r14, %r9
    455c: 4d 89 d6                     	movq	%r10, %r14
    455f: 49 c1 c6 32                  	rolq	$0x32, %r14
    4563: 4d 89 d7                     	movq	%r10, %r15
    4566: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    456a: 4d 31 f7                     	xorq	%r14, %r15
    456d: 4d 89 d4                     	movq	%r10, %r12
    4570: 49 c1 c4 17                  	rolq	$0x17, %r12
    4574: 4d 31 fc                     	xorq	%r15, %r12
    4577: 49 89 ce                     	movq	%rcx, %r14
    457a: 49 31 d6                     	xorq	%rdx, %r14
    457d: 4d 21 d6                     	andq	%r10, %r14
    4580: 49 31 d6                     	xorq	%rdx, %r14
    4583: 4c 03 9d 18 fe ff ff         	addq	-0x1e8(%rbp), %r11
    458a: 4d 01 f3                     	addq	%r14, %r11
    458d: 49 be 10 32 b4 2d 6d c6 31 a8	movabsq	$-0x57ce3992d24bcdf0, %r14 ## imm = 0xA831C66D2DB43210
    4597: 4d 01 de                     	addq	%r11, %r14
    459a: 4d 89 cb                     	movq	%r9, %r11
    459d: 49 c1 c3 24                  	rolq	$0x24, %r11
    45a1: 4d 01 e6                     	addq	%r12, %r14
    45a4: 4d 89 cf                     	movq	%r9, %r15
    45a7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    45ab: 4c 01 f3                     	addq	%r14, %rbx
    45ae: 4d 89 cc                     	movq	%r9, %r12
    45b1: 49 c1 c4 19                  	rolq	$0x19, %r12
    45b5: 4d 31 df                     	xorq	%r11, %r15
    45b8: 4d 31 fc                     	xorq	%r15, %r12
    45bb: 4d 89 c7                     	movq	%r8, %r15
    45be: 49 09 f7                     	orq	%rsi, %r15
    45c1: 4d 21 cf                     	andq	%r9, %r15
    45c4: 4d 89 c3                     	movq	%r8, %r11
    45c7: 49 21 f3                     	andq	%rsi, %r11
    45ca: 4d 09 fb                     	orq	%r15, %r11
    45cd: 4d 01 e3                     	addq	%r12, %r11
    45d0: 49 89 df                     	movq	%rbx, %r15
    45d3: 49 c1 c7 32                  	rolq	$0x32, %r15
    45d7: 4d 01 f3                     	addq	%r14, %r11
    45da: 49 89 de                     	movq	%rbx, %r14
    45dd: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    45e1: 4d 31 fe                     	xorq	%r15, %r14
    45e4: 49 89 df                     	movq	%rbx, %r15
    45e7: 49 c1 c7 17                  	rolq	$0x17, %r15
    45eb: 4d 31 f7                     	xorq	%r14, %r15
    45ee: 4d 89 d6                     	movq	%r10, %r14
    45f1: 49 31 ce                     	xorq	%rcx, %r14
    45f4: 49 21 de                     	andq	%rbx, %r14
    45f7: 49 31 ce                     	xorq	%rcx, %r14
    45fa: 48 03 95 20 fe ff ff         	addq	-0x1e0(%rbp), %rdx
    4601: 4c 01 f2                     	addq	%r14, %rdx
    4604: 49 be 3f 21 fb 98 c8 27 03 b0	movabsq	$-0x4ffcd8376704dec1, %r14 ## imm = 0xB00327C898FB213F
    460e: 49 01 d6                     	addq	%rdx, %r14
    4611: 4d 01 fe                     	addq	%r15, %r14
    4614: 4c 01 f6                     	addq	%r14, %rsi
    4617: 4c 89 da                     	movq	%r11, %rdx
    461a: 48 c1 c2 24                  	rolq	$0x24, %rdx
    461e: 4d 89 df                     	movq	%r11, %r15
    4621: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4625: 49 31 d7                     	xorq	%rdx, %r15
    4628: 4d 89 dc                     	movq	%r11, %r12
    462b: 49 c1 c4 19                  	rolq	$0x19, %r12
    462f: 4d 31 fc                     	xorq	%r15, %r12
    4632: 4d 89 cf                     	movq	%r9, %r15
    4635: 4d 09 c7                     	orq	%r8, %r15
    4638: 4d 21 df                     	andq	%r11, %r15
    463b: 4c 89 ca                     	movq	%r9, %rdx
    463e: 4c 21 c2                     	andq	%r8, %rdx
    4641: 4c 09 fa                     	orq	%r15, %rdx
    4644: 49 89 f7                     	movq	%rsi, %r15
    4647: 49 c1 c7 32                  	rolq	$0x32, %r15
    464b: 4c 01 e2                     	addq	%r12, %rdx
    464e: 49 89 f4                     	movq	%rsi, %r12
    4651: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4655: 4c 01 f2                     	addq	%r14, %rdx
    4658: 49 89 f6                     	movq	%rsi, %r14
    465b: 49 c1 c6 17                  	rolq	$0x17, %r14
    465f: 4d 31 fc                     	xorq	%r15, %r12
    4662: 4d 31 e6                     	xorq	%r12, %r14
    4665: 49 89 df                     	movq	%rbx, %r15
    4668: 4d 31 d7                     	xorq	%r10, %r15
    466b: 49 21 f7                     	andq	%rsi, %r15
    466e: 4d 31 d7                     	xorq	%r10, %r15
    4671: 48 03 8d 28 fe ff ff         	addq	-0x1d8(%rbp), %rcx
    4678: 4c 01 f9                     	addq	%r15, %rcx
    467b: 49 bf e4 0e ef be c7 7f 59 bf	movabsq	$-0x40a680384110f11c, %r15 ## imm = 0xBF597FC7BEEF0EE4
    4685: 49 01 cf                     	addq	%rcx, %r15
    4688: 4d 01 f7                     	addq	%r14, %r15
    468b: 4d 01 f8                     	addq	%r15, %r8
    468e: 48 89 d1                     	movq	%rdx, %rcx
    4691: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4695: 49 89 d6                     	movq	%rdx, %r14
    4698: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    469c: 49 31 ce                     	xorq	%rcx, %r14
    469f: 49 89 d4                     	movq	%rdx, %r12
    46a2: 49 c1 c4 19                  	rolq	$0x19, %r12
    46a6: 4d 31 f4                     	xorq	%r14, %r12
    46a9: 4d 89 de                     	movq	%r11, %r14
    46ac: 4d 09 ce                     	orq	%r9, %r14
    46af: 49 21 d6                     	andq	%rdx, %r14
    46b2: 4c 89 d9                     	movq	%r11, %rcx
    46b5: 4c 21 c9                     	andq	%r9, %rcx
    46b8: 4c 09 f1                     	orq	%r14, %rcx
    46bb: 4c 01 e1                     	addq	%r12, %rcx
    46be: 4c 01 f9                     	addq	%r15, %rcx
    46c1: 4d 89 c6                     	movq	%r8, %r14
    46c4: 49 c1 c6 32                  	rolq	$0x32, %r14
    46c8: 4d 89 c7                     	movq	%r8, %r15
    46cb: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    46cf: 4d 31 f7                     	xorq	%r14, %r15
    46d2: 4d 89 c4                     	movq	%r8, %r12
    46d5: 49 c1 c4 17                  	rolq	$0x17, %r12
    46d9: 4d 31 fc                     	xorq	%r15, %r12
    46dc: 49 89 f6                     	movq	%rsi, %r14
    46df: 49 31 de                     	xorq	%rbx, %r14
    46e2: 4d 21 c6                     	andq	%r8, %r14
    46e5: 4c 03 95 30 fe ff ff         	addq	-0x1d0(%rbp), %r10
    46ec: 49 31 de                     	xorq	%rbx, %r14
    46ef: 4d 01 f2                     	addq	%r14, %r10
    46f2: 49 be c2 8f a8 3d f3 0b e0 c6	movabsq	$-0x391ff40cc257703e, %r14 ## imm = 0xC6E00BF33DA88FC2
    46fc: 4d 01 d6                     	addq	%r10, %r14
    46ff: 4d 01 e6                     	addq	%r12, %r14
    4702: 49 89 ca                     	movq	%rcx, %r10
    4705: 49 c1 c2 24                  	rolq	$0x24, %r10
    4709: 4d 01 f1                     	addq	%r14, %r9
    470c: 49 89 cf                     	movq	%rcx, %r15
    470f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4713: 4d 31 d7                     	xorq	%r10, %r15
    4716: 49 89 cc                     	movq	%rcx, %r12
    4719: 49 c1 c4 19                  	rolq	$0x19, %r12
    471d: 4d 31 fc                     	xorq	%r15, %r12
    4720: 49 89 d7                     	movq	%rdx, %r15
    4723: 4d 09 df                     	orq	%r11, %r15
    4726: 49 21 cf                     	andq	%rcx, %r15
    4729: 49 89 d2                     	movq	%rdx, %r10
    472c: 4d 21 da                     	andq	%r11, %r10
    472f: 4d 09 fa                     	orq	%r15, %r10
    4732: 4d 01 e2                     	addq	%r12, %r10
    4735: 4d 01 f2                     	addq	%r14, %r10
    4738: 4d 89 ce                     	movq	%r9, %r14
    473b: 49 c1 c6 32                  	rolq	$0x32, %r14
    473f: 4d 89 cf                     	movq	%r9, %r15
    4742: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4746: 4d 31 f7                     	xorq	%r14, %r15
    4749: 4d 89 cc                     	movq	%r9, %r12
    474c: 49 c1 c4 17                  	rolq	$0x17, %r12
    4750: 4d 31 fc                     	xorq	%r15, %r12
    4753: 4d 89 c6                     	movq	%r8, %r14
    4756: 49 31 f6                     	xorq	%rsi, %r14
    4759: 4d 21 ce                     	andq	%r9, %r14
    475c: 49 31 f6                     	xorq	%rsi, %r14
    475f: 48 03 9d 38 fe ff ff         	addq	-0x1c8(%rbp), %rbx
    4766: 4c 01 f3                     	addq	%r14, %rbx
    4769: 49 be 25 a7 0a 93 47 91 a7 d5	movabsq	$-0x2a586eb86cf558db, %r14 ## imm = 0xD5A79147930AA725
    4773: 49 01 de                     	addq	%rbx, %r14
    4776: 4c 89 d3                     	movq	%r10, %rbx
    4779: 48 c1 c3 24                  	rolq	$0x24, %rbx
    477d: 4d 01 e6                     	addq	%r12, %r14
    4780: 4d 89 d7                     	movq	%r10, %r15
    4783: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4787: 4d 01 f3                     	addq	%r14, %r11
    478a: 4d 89 d4                     	movq	%r10, %r12
    478d: 49 c1 c4 19                  	rolq	$0x19, %r12
    4791: 49 31 df                     	xorq	%rbx, %r15
    4794: 4d 31 fc                     	xorq	%r15, %r12
    4797: 49 89 cf                     	movq	%rcx, %r15
    479a: 49 09 d7                     	orq	%rdx, %r15
    479d: 4d 21 d7                     	andq	%r10, %r15
    47a0: 48 89 cb                     	movq	%rcx, %rbx
    47a3: 48 21 d3                     	andq	%rdx, %rbx
    47a6: 4c 09 fb                     	orq	%r15, %rbx
    47a9: 4c 01 e3                     	addq	%r12, %rbx
    47ac: 4d 89 df                     	movq	%r11, %r15
    47af: 49 c1 c7 32                  	rolq	$0x32, %r15
    47b3: 4c 01 f3                     	addq	%r14, %rbx
    47b6: 4d 89 de                     	movq	%r11, %r14
    47b9: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    47bd: 4d 31 fe                     	xorq	%r15, %r14
    47c0: 4d 89 df                     	movq	%r11, %r15
    47c3: 49 c1 c7 17                  	rolq	$0x17, %r15
    47c7: 4d 31 f7                     	xorq	%r14, %r15
    47ca: 4d 89 ce                     	movq	%r9, %r14
    47cd: 4d 31 c6                     	xorq	%r8, %r14
    47d0: 4d 21 de                     	andq	%r11, %r14
    47d3: 4d 31 c6                     	xorq	%r8, %r14
    47d6: 48 03 b5 40 fe ff ff         	addq	-0x1c0(%rbp), %rsi
    47dd: 4c 01 f6                     	addq	%r14, %rsi
    47e0: 49 be 6f 82 03 e0 51 63 ca 06	movabsq	$0x6ca6351e003826f, %r14 ## imm = 0x6CA6351E003826F
    47ea: 49 01 f6                     	addq	%rsi, %r14
    47ed: 4d 01 fe                     	addq	%r15, %r14
    47f0: 4c 01 f2                     	addq	%r14, %rdx
    47f3: 48 89 de                     	movq	%rbx, %rsi
    47f6: 48 c1 c6 24                  	rolq	$0x24, %rsi
    47fa: 49 89 df                     	movq	%rbx, %r15
    47fd: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4801: 49 31 f7                     	xorq	%rsi, %r15
    4804: 49 89 dc                     	movq	%rbx, %r12
    4807: 49 c1 c4 19                  	rolq	$0x19, %r12
    480b: 4d 31 fc                     	xorq	%r15, %r12
    480e: 4d 89 d7                     	movq	%r10, %r15
    4811: 49 09 cf                     	orq	%rcx, %r15
    4814: 49 21 df                     	andq	%rbx, %r15
    4817: 4c 89 d6                     	movq	%r10, %rsi
    481a: 48 21 ce                     	andq	%rcx, %rsi
    481d: 4c 09 fe                     	orq	%r15, %rsi
    4820: 49 89 d7                     	movq	%rdx, %r15
    4823: 49 c1 c7 32                  	rolq	$0x32, %r15
    4827: 4c 01 e6                     	addq	%r12, %rsi
    482a: 49 89 d4                     	movq	%rdx, %r12
    482d: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4831: 4c 01 f6                     	addq	%r14, %rsi
    4834: 49 89 d6                     	movq	%rdx, %r14
    4837: 49 c1 c6 17                  	rolq	$0x17, %r14
    483b: 4d 31 fc                     	xorq	%r15, %r12
    483e: 4d 31 e6                     	xorq	%r12, %r14
    4841: 4d 89 df                     	movq	%r11, %r15
    4844: 4d 31 cf                     	xorq	%r9, %r15
    4847: 49 21 d7                     	andq	%rdx, %r15
    484a: 4d 31 cf                     	xorq	%r9, %r15
    484d: 4c 03 85 48 fe ff ff         	addq	-0x1b8(%rbp), %r8
    4854: 4d 01 f8                     	addq	%r15, %r8
    4857: 49 bf 70 6e 0e 0a 67 29 29 14	movabsq	$0x142929670a0e6e70, %r15 ## imm = 0x142929670A0E6E70
    4861: 4d 01 c7                     	addq	%r8, %r15
    4864: 4d 01 f7                     	addq	%r14, %r15
    4867: 4c 01 f9                     	addq	%r15, %rcx
    486a: 49 89 f0                     	movq	%rsi, %r8
    486d: 49 c1 c0 24                  	rolq	$0x24, %r8
    4871: 49 89 f6                     	movq	%rsi, %r14
    4874: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4878: 4d 31 c6                     	xorq	%r8, %r14
    487b: 49 89 f4                     	movq	%rsi, %r12
    487e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4882: 4d 31 f4                     	xorq	%r14, %r12
    4885: 49 89 de                     	movq	%rbx, %r14
    4888: 4d 09 d6                     	orq	%r10, %r14
    488b: 49 21 f6                     	andq	%rsi, %r14
    488e: 49 89 d8                     	movq	%rbx, %r8
    4891: 4d 21 d0                     	andq	%r10, %r8
    4894: 4d 09 f0                     	orq	%r14, %r8
    4897: 4d 01 e0                     	addq	%r12, %r8
    489a: 4d 01 f8                     	addq	%r15, %r8
    489d: 49 89 ce                     	movq	%rcx, %r14
    48a0: 49 c1 c6 32                  	rolq	$0x32, %r14
    48a4: 49 89 cf                     	movq	%rcx, %r15
    48a7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    48ab: 4d 31 f7                     	xorq	%r14, %r15
    48ae: 49 89 cc                     	movq	%rcx, %r12
    48b1: 49 c1 c4 17                  	rolq	$0x17, %r12
    48b5: 4d 31 fc                     	xorq	%r15, %r12
    48b8: 49 89 d6                     	movq	%rdx, %r14
    48bb: 4d 31 de                     	xorq	%r11, %r14
    48be: 49 21 ce                     	andq	%rcx, %r14
    48c1: 4c 03 8d 50 fe ff ff         	addq	-0x1b0(%rbp), %r9
    48c8: 4d 31 de                     	xorq	%r11, %r14
    48cb: 4d 01 f1                     	addq	%r14, %r9
    48ce: 49 be fc 2f d2 46 85 0a b7 27	movabsq	$0x27b70a8546d22ffc, %r14 ## imm = 0x27B70A8546D22FFC
    48d8: 4d 01 ce                     	addq	%r9, %r14
    48db: 4d 01 e6                     	addq	%r12, %r14
    48de: 4d 89 c1                     	movq	%r8, %r9
    48e1: 49 c1 c1 24                  	rolq	$0x24, %r9
    48e5: 4d 01 f2                     	addq	%r14, %r10
    48e8: 4d 89 c7                     	movq	%r8, %r15
    48eb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    48ef: 4d 31 cf                     	xorq	%r9, %r15
    48f2: 4d 89 c4                     	movq	%r8, %r12
    48f5: 49 c1 c4 19                  	rolq	$0x19, %r12
    48f9: 4d 31 fc                     	xorq	%r15, %r12
    48fc: 49 89 f7                     	movq	%rsi, %r15
    48ff: 49 09 df                     	orq	%rbx, %r15
    4902: 4d 21 c7                     	andq	%r8, %r15
    4905: 49 89 f1                     	movq	%rsi, %r9
    4908: 49 21 d9                     	andq	%rbx, %r9
    490b: 4d 09 f9                     	orq	%r15, %r9
    490e: 4d 01 e1                     	addq	%r12, %r9
    4911: 4d 01 f1                     	addq	%r14, %r9
    4914: 4d 89 d6                     	movq	%r10, %r14
    4917: 49 c1 c6 32                  	rolq	$0x32, %r14
    491b: 4d 89 d7                     	movq	%r10, %r15
    491e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4922: 4d 31 f7                     	xorq	%r14, %r15
    4925: 4d 89 d4                     	movq	%r10, %r12
    4928: 49 c1 c4 17                  	rolq	$0x17, %r12
    492c: 4d 31 fc                     	xorq	%r15, %r12
    492f: 49 89 ce                     	movq	%rcx, %r14
    4932: 49 31 d6                     	xorq	%rdx, %r14
    4935: 4d 21 d6                     	andq	%r10, %r14
    4938: 49 31 d6                     	xorq	%rdx, %r14
    493b: 4c 03 9d 58 fe ff ff         	addq	-0x1a8(%rbp), %r11
    4942: 4d 01 f3                     	addq	%r14, %r11
    4945: 49 be 26 c9 26 5c 38 21 1b 2e	movabsq	$0x2e1b21385c26c926, %r14 ## imm = 0x2E1B21385C26C926
    494f: 4d 01 de                     	addq	%r11, %r14
    4952: 4d 89 cb                     	movq	%r9, %r11
    4955: 49 c1 c3 24                  	rolq	$0x24, %r11
    4959: 4d 01 e6                     	addq	%r12, %r14
    495c: 4d 89 cf                     	movq	%r9, %r15
    495f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4963: 4c 01 f3                     	addq	%r14, %rbx
    4966: 4d 89 cc                     	movq	%r9, %r12
    4969: 49 c1 c4 19                  	rolq	$0x19, %r12
    496d: 4d 31 df                     	xorq	%r11, %r15
    4970: 4d 31 fc                     	xorq	%r15, %r12
    4973: 4d 89 c7                     	movq	%r8, %r15
    4976: 49 09 f7                     	orq	%rsi, %r15
    4979: 4d 21 cf                     	andq	%r9, %r15
    497c: 4d 89 c3                     	movq	%r8, %r11
    497f: 49 21 f3                     	andq	%rsi, %r11
    4982: 4d 09 fb                     	orq	%r15, %r11
    4985: 4d 01 e3                     	addq	%r12, %r11
    4988: 49 89 df                     	movq	%rbx, %r15
    498b: 49 c1 c7 32                  	rolq	$0x32, %r15
    498f: 4d 01 f3                     	addq	%r14, %r11
    4992: 49 89 de                     	movq	%rbx, %r14
    4995: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4999: 4d 31 fe                     	xorq	%r15, %r14
    499c: 49 89 df                     	movq	%rbx, %r15
    499f: 49 c1 c7 17                  	rolq	$0x17, %r15
    49a3: 4d 31 f7                     	xorq	%r14, %r15
    49a6: 4d 89 d6                     	movq	%r10, %r14
    49a9: 49 31 ce                     	xorq	%rcx, %r14
    49ac: 49 21 de                     	andq	%rbx, %r14
    49af: 49 31 ce                     	xorq	%rcx, %r14
    49b2: 48 03 95 60 fe ff ff         	addq	-0x1a0(%rbp), %rdx
    49b9: 4c 01 f2                     	addq	%r14, %rdx
    49bc: 49 be ed 2a c4 5a fc 6d 2c 4d	movabsq	$0x4d2c6dfc5ac42aed, %r14 ## imm = 0x4D2C6DFC5AC42AED
    49c6: 49 01 d6                     	addq	%rdx, %r14
    49c9: 4d 01 fe                     	addq	%r15, %r14
    49cc: 4c 01 f6                     	addq	%r14, %rsi
    49cf: 4c 89 da                     	movq	%r11, %rdx
    49d2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    49d6: 4d 89 df                     	movq	%r11, %r15
    49d9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    49dd: 49 31 d7                     	xorq	%rdx, %r15
    49e0: 4d 89 dc                     	movq	%r11, %r12
    49e3: 49 c1 c4 19                  	rolq	$0x19, %r12
    49e7: 4d 31 fc                     	xorq	%r15, %r12
    49ea: 4d 89 cf                     	movq	%r9, %r15
    49ed: 4d 09 c7                     	orq	%r8, %r15
    49f0: 4d 21 df                     	andq	%r11, %r15
    49f3: 4c 89 ca                     	movq	%r9, %rdx
    49f6: 4c 21 c2                     	andq	%r8, %rdx
    49f9: 4c 09 fa                     	orq	%r15, %rdx
    49fc: 49 89 f7                     	movq	%rsi, %r15
    49ff: 49 c1 c7 32                  	rolq	$0x32, %r15
    4a03: 4c 01 e2                     	addq	%r12, %rdx
    4a06: 49 89 f4                     	movq	%rsi, %r12
    4a09: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4a0d: 4c 01 f2                     	addq	%r14, %rdx
    4a10: 49 89 f6                     	movq	%rsi, %r14
    4a13: 49 c1 c6 17                  	rolq	$0x17, %r14
    4a17: 4d 31 fc                     	xorq	%r15, %r12
    4a1a: 4d 31 e6                     	xorq	%r12, %r14
    4a1d: 49 89 df                     	movq	%rbx, %r15
    4a20: 4d 31 d7                     	xorq	%r10, %r15
    4a23: 49 21 f7                     	andq	%rsi, %r15
    4a26: 4d 31 d7                     	xorq	%r10, %r15
    4a29: 48 03 8d 68 fe ff ff         	addq	-0x198(%rbp), %rcx
    4a30: 4c 01 f9                     	addq	%r15, %rcx
    4a33: 49 bf df b3 95 9d 13 0d 38 53	movabsq	$0x53380d139d95b3df, %r15 ## imm = 0x53380D139D95B3DF
    4a3d: 49 01 cf                     	addq	%rcx, %r15
    4a40: 4d 01 f7                     	addq	%r14, %r15
    4a43: 4d 01 f8                     	addq	%r15, %r8
    4a46: 48 89 d1                     	movq	%rdx, %rcx
    4a49: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4a4d: 49 89 d6                     	movq	%rdx, %r14
    4a50: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4a54: 49 31 ce                     	xorq	%rcx, %r14
    4a57: 49 89 d4                     	movq	%rdx, %r12
    4a5a: 49 c1 c4 19                  	rolq	$0x19, %r12
    4a5e: 4d 31 f4                     	xorq	%r14, %r12
    4a61: 4d 89 de                     	movq	%r11, %r14
    4a64: 4d 09 ce                     	orq	%r9, %r14
    4a67: 49 21 d6                     	andq	%rdx, %r14
    4a6a: 4c 89 d9                     	movq	%r11, %rcx
    4a6d: 4c 21 c9                     	andq	%r9, %rcx
    4a70: 4c 09 f1                     	orq	%r14, %rcx
    4a73: 4c 01 e1                     	addq	%r12, %rcx
    4a76: 4c 01 f9                     	addq	%r15, %rcx
    4a79: 4d 89 c6                     	movq	%r8, %r14
    4a7c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4a80: 4d 89 c7                     	movq	%r8, %r15
    4a83: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4a87: 4d 31 f7                     	xorq	%r14, %r15
    4a8a: 4d 89 c4                     	movq	%r8, %r12
    4a8d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4a91: 4d 31 fc                     	xorq	%r15, %r12
    4a94: 49 89 f6                     	movq	%rsi, %r14
    4a97: 49 31 de                     	xorq	%rbx, %r14
    4a9a: 4d 21 c6                     	andq	%r8, %r14
    4a9d: 4c 03 95 70 fe ff ff         	addq	-0x190(%rbp), %r10
    4aa4: 49 31 de                     	xorq	%rbx, %r14
    4aa7: 4d 01 f2                     	addq	%r14, %r10
    4aaa: 49 be de 63 af 8b 54 73 0a 65	movabsq	$0x650a73548baf63de, %r14 ## imm = 0x650A73548BAF63DE
    4ab4: 4d 01 d6                     	addq	%r10, %r14
    4ab7: 4d 01 e6                     	addq	%r12, %r14
    4aba: 49 89 ca                     	movq	%rcx, %r10
    4abd: 49 c1 c2 24                  	rolq	$0x24, %r10
    4ac1: 4d 01 f1                     	addq	%r14, %r9
    4ac4: 49 89 cf                     	movq	%rcx, %r15
    4ac7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4acb: 4d 31 d7                     	xorq	%r10, %r15
    4ace: 49 89 cc                     	movq	%rcx, %r12
    4ad1: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ad5: 4d 31 fc                     	xorq	%r15, %r12
    4ad8: 49 89 d7                     	movq	%rdx, %r15
    4adb: 4d 09 df                     	orq	%r11, %r15
    4ade: 49 21 cf                     	andq	%rcx, %r15
    4ae1: 49 89 d2                     	movq	%rdx, %r10
    4ae4: 4d 21 da                     	andq	%r11, %r10
    4ae7: 4d 09 fa                     	orq	%r15, %r10
    4aea: 4d 01 e2                     	addq	%r12, %r10
    4aed: 4d 01 f2                     	addq	%r14, %r10
    4af0: 4d 89 ce                     	movq	%r9, %r14
    4af3: 49 c1 c6 32                  	rolq	$0x32, %r14
    4af7: 4d 89 cf                     	movq	%r9, %r15
    4afa: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4afe: 4d 31 f7                     	xorq	%r14, %r15
    4b01: 4d 89 cc                     	movq	%r9, %r12
    4b04: 49 c1 c4 17                  	rolq	$0x17, %r12
    4b08: 4d 31 fc                     	xorq	%r15, %r12
    4b0b: 4d 89 c6                     	movq	%r8, %r14
    4b0e: 49 31 f6                     	xorq	%rsi, %r14
    4b11: 4d 21 ce                     	andq	%r9, %r14
    4b14: 49 31 f6                     	xorq	%rsi, %r14
    4b17: 48 03 9d 78 fe ff ff         	addq	-0x188(%rbp), %rbx
    4b1e: 4c 01 f3                     	addq	%r14, %rbx
    4b21: 49 be a8 b2 77 3c bb 0a 6a 76	movabsq	$0x766a0abb3c77b2a8, %r14 ## imm = 0x766A0ABB3C77B2A8
    4b2b: 49 01 de                     	addq	%rbx, %r14
    4b2e: 4c 89 d3                     	movq	%r10, %rbx
    4b31: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4b35: 4d 01 e6                     	addq	%r12, %r14
    4b38: 4d 89 d7                     	movq	%r10, %r15
    4b3b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4b3f: 4d 01 f3                     	addq	%r14, %r11
    4b42: 4d 89 d4                     	movq	%r10, %r12
    4b45: 49 c1 c4 19                  	rolq	$0x19, %r12
    4b49: 49 31 df                     	xorq	%rbx, %r15
    4b4c: 4d 31 fc                     	xorq	%r15, %r12
    4b4f: 49 89 cf                     	movq	%rcx, %r15
    4b52: 49 09 d7                     	orq	%rdx, %r15
    4b55: 4d 21 d7                     	andq	%r10, %r15
    4b58: 48 89 cb                     	movq	%rcx, %rbx
    4b5b: 48 21 d3                     	andq	%rdx, %rbx
    4b5e: 4c 09 fb                     	orq	%r15, %rbx
    4b61: 4c 01 e3                     	addq	%r12, %rbx
    4b64: 4d 89 df                     	movq	%r11, %r15
    4b67: 49 c1 c7 32                  	rolq	$0x32, %r15
    4b6b: 4c 01 f3                     	addq	%r14, %rbx
    4b6e: 4d 89 de                     	movq	%r11, %r14
    4b71: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4b75: 4d 31 fe                     	xorq	%r15, %r14
    4b78: 4d 89 df                     	movq	%r11, %r15
    4b7b: 49 c1 c7 17                  	rolq	$0x17, %r15
    4b7f: 4d 31 f7                     	xorq	%r14, %r15
    4b82: 4d 89 ce                     	movq	%r9, %r14
    4b85: 4d 31 c6                     	xorq	%r8, %r14
    4b88: 4d 21 de                     	andq	%r11, %r14
    4b8b: 4d 31 c6                     	xorq	%r8, %r14
    4b8e: 48 03 b5 80 fe ff ff         	addq	-0x180(%rbp), %rsi
    4b95: 4c 01 f6                     	addq	%r14, %rsi
    4b98: 49 be e6 ae ed 47 2e c9 c2 81	movabsq	$-0x7e3d36d1b812511a, %r14 ## imm = 0x81C2C92E47EDAEE6
    4ba2: 49 01 f6                     	addq	%rsi, %r14
    4ba5: 4d 01 fe                     	addq	%r15, %r14
    4ba8: 4c 01 f2                     	addq	%r14, %rdx
    4bab: 48 89 de                     	movq	%rbx, %rsi
    4bae: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4bb2: 49 89 df                     	movq	%rbx, %r15
    4bb5: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4bb9: 49 31 f7                     	xorq	%rsi, %r15
    4bbc: 49 89 dc                     	movq	%rbx, %r12
    4bbf: 49 c1 c4 19                  	rolq	$0x19, %r12
    4bc3: 4d 31 fc                     	xorq	%r15, %r12
    4bc6: 4d 89 d7                     	movq	%r10, %r15
    4bc9: 49 09 cf                     	orq	%rcx, %r15
    4bcc: 49 21 df                     	andq	%rbx, %r15
    4bcf: 4c 89 d6                     	movq	%r10, %rsi
    4bd2: 48 21 ce                     	andq	%rcx, %rsi
    4bd5: 4c 09 fe                     	orq	%r15, %rsi
    4bd8: 49 89 d7                     	movq	%rdx, %r15
    4bdb: 49 c1 c7 32                  	rolq	$0x32, %r15
    4bdf: 4c 01 e6                     	addq	%r12, %rsi
    4be2: 49 89 d4                     	movq	%rdx, %r12
    4be5: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4be9: 4c 01 f6                     	addq	%r14, %rsi
    4bec: 49 89 d6                     	movq	%rdx, %r14
    4bef: 49 c1 c6 17                  	rolq	$0x17, %r14
    4bf3: 4d 31 fc                     	xorq	%r15, %r12
    4bf6: 4d 31 e6                     	xorq	%r12, %r14
    4bf9: 4d 89 df                     	movq	%r11, %r15
    4bfc: 4d 31 cf                     	xorq	%r9, %r15
    4bff: 49 21 d7                     	andq	%rdx, %r15
    4c02: 4d 31 cf                     	xorq	%r9, %r15
    4c05: 4c 03 85 88 fe ff ff         	addq	-0x178(%rbp), %r8
    4c0c: 4d 01 f8                     	addq	%r15, %r8
    4c0f: 49 bf 3b 35 82 14 85 2c 72 92	movabsq	$-0x6d8dd37aeb7dcac5, %r15 ## imm = 0x92722C851482353B
    4c19: 4d 01 c7                     	addq	%r8, %r15
    4c1c: 4d 01 f7                     	addq	%r14, %r15
    4c1f: 4c 01 f9                     	addq	%r15, %rcx
    4c22: 49 89 f0                     	movq	%rsi, %r8
    4c25: 49 c1 c0 24                  	rolq	$0x24, %r8
    4c29: 49 89 f6                     	movq	%rsi, %r14
    4c2c: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4c30: 4d 31 c6                     	xorq	%r8, %r14
    4c33: 49 89 f4                     	movq	%rsi, %r12
    4c36: 49 c1 c4 19                  	rolq	$0x19, %r12
    4c3a: 4d 31 f4                     	xorq	%r14, %r12
    4c3d: 49 89 de                     	movq	%rbx, %r14
    4c40: 4d 09 d6                     	orq	%r10, %r14
    4c43: 49 21 f6                     	andq	%rsi, %r14
    4c46: 49 89 d8                     	movq	%rbx, %r8
    4c49: 4d 21 d0                     	andq	%r10, %r8
    4c4c: 4d 09 f0                     	orq	%r14, %r8
    4c4f: 4d 01 e0                     	addq	%r12, %r8
    4c52: 4d 01 f8                     	addq	%r15, %r8
    4c55: 49 89 ce                     	movq	%rcx, %r14
    4c58: 49 c1 c6 32                  	rolq	$0x32, %r14
    4c5c: 49 89 cf                     	movq	%rcx, %r15
    4c5f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4c63: 4d 31 f7                     	xorq	%r14, %r15
    4c66: 49 89 cc                     	movq	%rcx, %r12
    4c69: 49 c1 c4 17                  	rolq	$0x17, %r12
    4c6d: 4d 31 fc                     	xorq	%r15, %r12
    4c70: 49 89 d6                     	movq	%rdx, %r14
    4c73: 4d 31 de                     	xorq	%r11, %r14
    4c76: 49 21 ce                     	andq	%rcx, %r14
    4c79: 4c 03 8d 90 fe ff ff         	addq	-0x170(%rbp), %r9
    4c80: 4d 31 de                     	xorq	%r11, %r14
    4c83: 4d 01 f1                     	addq	%r14, %r9
    4c86: 49 be 64 03 f1 4c a1 e8 bf a2	movabsq	$-0x5d40175eb30efc9c, %r14 ## imm = 0xA2BFE8A14CF10364
    4c90: 4d 01 ce                     	addq	%r9, %r14
    4c93: 4d 01 e6                     	addq	%r12, %r14
    4c96: 4d 89 c1                     	movq	%r8, %r9
    4c99: 49 c1 c1 24                  	rolq	$0x24, %r9
    4c9d: 4d 01 f2                     	addq	%r14, %r10
    4ca0: 4d 89 c7                     	movq	%r8, %r15
    4ca3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4ca7: 4d 31 cf                     	xorq	%r9, %r15
    4caa: 4d 89 c4                     	movq	%r8, %r12
    4cad: 49 c1 c4 19                  	rolq	$0x19, %r12
    4cb1: 4d 31 fc                     	xorq	%r15, %r12
    4cb4: 49 89 f7                     	movq	%rsi, %r15
    4cb7: 49 09 df                     	orq	%rbx, %r15
    4cba: 4d 21 c7                     	andq	%r8, %r15
    4cbd: 49 89 f1                     	movq	%rsi, %r9
    4cc0: 49 21 d9                     	andq	%rbx, %r9
    4cc3: 4d 09 f9                     	orq	%r15, %r9
    4cc6: 4d 01 e1                     	addq	%r12, %r9
    4cc9: 4d 01 f1                     	addq	%r14, %r9
    4ccc: 4d 89 d6                     	movq	%r10, %r14
    4ccf: 49 c1 c6 32                  	rolq	$0x32, %r14
    4cd3: 4d 89 d7                     	movq	%r10, %r15
    4cd6: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4cda: 4d 31 f7                     	xorq	%r14, %r15
    4cdd: 4d 89 d4                     	movq	%r10, %r12
    4ce0: 49 c1 c4 17                  	rolq	$0x17, %r12
    4ce4: 4d 31 fc                     	xorq	%r15, %r12
    4ce7: 49 89 ce                     	movq	%rcx, %r14
    4cea: 49 31 d6                     	xorq	%rdx, %r14
    4ced: 4d 21 d6                     	andq	%r10, %r14
    4cf0: 49 31 d6                     	xorq	%rdx, %r14
    4cf3: 4c 03 9d 98 fe ff ff         	addq	-0x168(%rbp), %r11
    4cfa: 4d 01 f3                     	addq	%r14, %r11
    4cfd: 49 be 01 30 42 bc 4b 66 1a a8	movabsq	$-0x57e599b443bdcfff, %r14 ## imm = 0xA81A664BBC423001
    4d07: 4d 01 de                     	addq	%r11, %r14
    4d0a: 4d 89 cb                     	movq	%r9, %r11
    4d0d: 49 c1 c3 24                  	rolq	$0x24, %r11
    4d11: 4d 01 e6                     	addq	%r12, %r14
    4d14: 4d 89 cf                     	movq	%r9, %r15
    4d17: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4d1b: 4c 01 f3                     	addq	%r14, %rbx
    4d1e: 4d 89 cc                     	movq	%r9, %r12
    4d21: 49 c1 c4 19                  	rolq	$0x19, %r12
    4d25: 4d 31 df                     	xorq	%r11, %r15
    4d28: 4d 31 fc                     	xorq	%r15, %r12
    4d2b: 4d 89 c7                     	movq	%r8, %r15
    4d2e: 49 09 f7                     	orq	%rsi, %r15
    4d31: 4d 21 cf                     	andq	%r9, %r15
    4d34: 4d 89 c3                     	movq	%r8, %r11
    4d37: 49 21 f3                     	andq	%rsi, %r11
    4d3a: 4d 09 fb                     	orq	%r15, %r11
    4d3d: 4d 01 e3                     	addq	%r12, %r11
    4d40: 49 89 df                     	movq	%rbx, %r15
    4d43: 49 c1 c7 32                  	rolq	$0x32, %r15
    4d47: 4d 01 f3                     	addq	%r14, %r11
    4d4a: 49 89 de                     	movq	%rbx, %r14
    4d4d: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4d51: 4d 31 fe                     	xorq	%r15, %r14
    4d54: 49 89 df                     	movq	%rbx, %r15
    4d57: 49 c1 c7 17                  	rolq	$0x17, %r15
    4d5b: 4d 31 f7                     	xorq	%r14, %r15
    4d5e: 4d 89 d6                     	movq	%r10, %r14
    4d61: 49 31 ce                     	xorq	%rcx, %r14
    4d64: 49 21 de                     	andq	%rbx, %r14
    4d67: 49 31 ce                     	xorq	%rcx, %r14
    4d6a: 48 03 95 a0 fe ff ff         	addq	-0x160(%rbp), %rdx
    4d71: 4c 01 f2                     	addq	%r14, %rdx
    4d74: 49 be 91 97 f8 d0 70 8b 4b c2	movabsq	$-0x3db4748f2f07686f, %r14 ## imm = 0xC24B8B70D0F89791
    4d7e: 49 01 d6                     	addq	%rdx, %r14
    4d81: 4d 01 fe                     	addq	%r15, %r14
    4d84: 4c 01 f6                     	addq	%r14, %rsi
    4d87: 4c 89 da                     	movq	%r11, %rdx
    4d8a: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4d8e: 4d 89 df                     	movq	%r11, %r15
    4d91: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4d95: 49 31 d7                     	xorq	%rdx, %r15
    4d98: 4d 89 dc                     	movq	%r11, %r12
    4d9b: 49 c1 c4 19                  	rolq	$0x19, %r12
    4d9f: 4d 31 fc                     	xorq	%r15, %r12
    4da2: 4d 89 cf                     	movq	%r9, %r15
    4da5: 4d 09 c7                     	orq	%r8, %r15
    4da8: 4d 21 df                     	andq	%r11, %r15
    4dab: 4c 89 ca                     	movq	%r9, %rdx
    4dae: 4c 21 c2                     	andq	%r8, %rdx
    4db1: 4c 09 fa                     	orq	%r15, %rdx
    4db4: 49 89 f7                     	movq	%rsi, %r15
    4db7: 49 c1 c7 32                  	rolq	$0x32, %r15
    4dbb: 4c 01 e2                     	addq	%r12, %rdx
    4dbe: 49 89 f4                     	movq	%rsi, %r12
    4dc1: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4dc5: 4c 01 f2                     	addq	%r14, %rdx
    4dc8: 49 89 f6                     	movq	%rsi, %r14
    4dcb: 49 c1 c6 17                  	rolq	$0x17, %r14
    4dcf: 4d 31 fc                     	xorq	%r15, %r12
    4dd2: 4d 31 e6                     	xorq	%r12, %r14
    4dd5: 49 89 df                     	movq	%rbx, %r15
    4dd8: 4d 31 d7                     	xorq	%r10, %r15
    4ddb: 49 21 f7                     	andq	%rsi, %r15
    4dde: 4d 31 d7                     	xorq	%r10, %r15
    4de1: 48 03 8d a8 fe ff ff         	addq	-0x158(%rbp), %rcx
    4de8: 4c 01 f9                     	addq	%r15, %rcx
    4deb: 49 bf 30 be 54 06 a3 51 6c c7	movabsq	$-0x3893ae5cf9ab41d0, %r15 ## imm = 0xC76C51A30654BE30
    4df5: 49 01 cf                     	addq	%rcx, %r15
    4df8: 4d 01 f7                     	addq	%r14, %r15
    4dfb: 4d 01 f8                     	addq	%r15, %r8
    4dfe: 48 89 d1                     	movq	%rdx, %rcx
    4e01: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4e05: 49 89 d6                     	movq	%rdx, %r14
    4e08: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4e0c: 49 31 ce                     	xorq	%rcx, %r14
    4e0f: 49 89 d4                     	movq	%rdx, %r12
    4e12: 49 c1 c4 19                  	rolq	$0x19, %r12
    4e16: 4d 31 f4                     	xorq	%r14, %r12
    4e19: 4d 89 de                     	movq	%r11, %r14
    4e1c: 4d 09 ce                     	orq	%r9, %r14
    4e1f: 49 21 d6                     	andq	%rdx, %r14
    4e22: 4c 89 d9                     	movq	%r11, %rcx
    4e25: 4c 21 c9                     	andq	%r9, %rcx
    4e28: 4c 09 f1                     	orq	%r14, %rcx
    4e2b: 4c 01 e1                     	addq	%r12, %rcx
    4e2e: 4c 01 f9                     	addq	%r15, %rcx
    4e31: 4d 89 c6                     	movq	%r8, %r14
    4e34: 49 c1 c6 32                  	rolq	$0x32, %r14
    4e38: 4d 89 c7                     	movq	%r8, %r15
    4e3b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4e3f: 4d 31 f7                     	xorq	%r14, %r15
    4e42: 4d 89 c4                     	movq	%r8, %r12
    4e45: 49 c1 c4 17                  	rolq	$0x17, %r12
    4e49: 4d 31 fc                     	xorq	%r15, %r12
    4e4c: 49 89 f6                     	movq	%rsi, %r14
    4e4f: 49 31 de                     	xorq	%rbx, %r14
    4e52: 4d 21 c6                     	andq	%r8, %r14
    4e55: 4c 03 95 b0 fe ff ff         	addq	-0x150(%rbp), %r10
    4e5c: 49 31 de                     	xorq	%rbx, %r14
    4e5f: 4d 01 f2                     	addq	%r14, %r10
    4e62: 49 be 18 52 ef d6 19 e8 92 d1	movabsq	$-0x2e6d17e62910ade8, %r14 ## imm = 0xD192E819D6EF5218
    4e6c: 4d 01 d6                     	addq	%r10, %r14
    4e6f: 4d 01 e6                     	addq	%r12, %r14
    4e72: 49 89 ca                     	movq	%rcx, %r10
    4e75: 49 c1 c2 24                  	rolq	$0x24, %r10
    4e79: 4d 01 f1                     	addq	%r14, %r9
    4e7c: 49 89 cf                     	movq	%rcx, %r15
    4e7f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4e83: 4d 31 d7                     	xorq	%r10, %r15
    4e86: 49 89 cc                     	movq	%rcx, %r12
    4e89: 49 c1 c4 19                  	rolq	$0x19, %r12
    4e8d: 4d 31 fc                     	xorq	%r15, %r12
    4e90: 49 89 d7                     	movq	%rdx, %r15
    4e93: 4d 09 df                     	orq	%r11, %r15
    4e96: 49 21 cf                     	andq	%rcx, %r15
    4e99: 49 89 d2                     	movq	%rdx, %r10
    4e9c: 4d 21 da                     	andq	%r11, %r10
    4e9f: 4d 09 fa                     	orq	%r15, %r10
    4ea2: 4d 01 e2                     	addq	%r12, %r10
    4ea5: 4d 01 f2                     	addq	%r14, %r10
    4ea8: 4d 89 ce                     	movq	%r9, %r14
    4eab: 49 c1 c6 32                  	rolq	$0x32, %r14
    4eaf: 4d 89 cf                     	movq	%r9, %r15
    4eb2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4eb6: 4d 31 f7                     	xorq	%r14, %r15
    4eb9: 4d 89 cc                     	movq	%r9, %r12
    4ebc: 49 c1 c4 17                  	rolq	$0x17, %r12
    4ec0: 4d 31 fc                     	xorq	%r15, %r12
    4ec3: 4d 89 c6                     	movq	%r8, %r14
    4ec6: 49 31 f6                     	xorq	%rsi, %r14
    4ec9: 4d 21 ce                     	andq	%r9, %r14
    4ecc: 49 31 f6                     	xorq	%rsi, %r14
    4ecf: 48 03 9d b8 fe ff ff         	addq	-0x148(%rbp), %rbx
    4ed6: 4c 01 f3                     	addq	%r14, %rbx
    4ed9: 49 be 10 a9 65 55 24 06 99 d6	movabsq	$-0x2966f9dbaa9a56f0, %r14 ## imm = 0xD69906245565A910
    4ee3: 49 01 de                     	addq	%rbx, %r14
    4ee6: 4c 89 d3                     	movq	%r10, %rbx
    4ee9: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4eed: 4d 01 e6                     	addq	%r12, %r14
    4ef0: 4d 89 d7                     	movq	%r10, %r15
    4ef3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4ef7: 4d 01 f3                     	addq	%r14, %r11
    4efa: 4d 89 d4                     	movq	%r10, %r12
    4efd: 49 c1 c4 19                  	rolq	$0x19, %r12
    4f01: 49 31 df                     	xorq	%rbx, %r15
    4f04: 4d 31 fc                     	xorq	%r15, %r12
    4f07: 49 89 cf                     	movq	%rcx, %r15
    4f0a: 49 09 d7                     	orq	%rdx, %r15
    4f0d: 4d 21 d7                     	andq	%r10, %r15
    4f10: 48 89 cb                     	movq	%rcx, %rbx
    4f13: 48 21 d3                     	andq	%rdx, %rbx
    4f16: 4c 09 fb                     	orq	%r15, %rbx
    4f19: 4c 01 e3                     	addq	%r12, %rbx
    4f1c: 4d 89 df                     	movq	%r11, %r15
    4f1f: 49 c1 c7 32                  	rolq	$0x32, %r15
    4f23: 4c 01 f3                     	addq	%r14, %rbx
    4f26: 4d 89 de                     	movq	%r11, %r14
    4f29: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4f2d: 4d 31 fe                     	xorq	%r15, %r14
    4f30: 4d 89 df                     	movq	%r11, %r15
    4f33: 49 c1 c7 17                  	rolq	$0x17, %r15
    4f37: 4d 31 f7                     	xorq	%r14, %r15
    4f3a: 4d 89 ce                     	movq	%r9, %r14
    4f3d: 4d 31 c6                     	xorq	%r8, %r14
    4f40: 4d 21 de                     	andq	%r11, %r14
    4f43: 4d 31 c6                     	xorq	%r8, %r14
    4f46: 48 03 b5 c0 fe ff ff         	addq	-0x140(%rbp), %rsi
    4f4d: 4c 01 f6                     	addq	%r14, %rsi
    4f50: 49 be 2a 20 71 57 85 35 0e f4	movabsq	$-0xbf1ca7aa88edfd6, %r14 ## imm = 0xF40E35855771202A
    4f5a: 49 01 f6                     	addq	%rsi, %r14
    4f5d: 4d 01 fe                     	addq	%r15, %r14
    4f60: 4c 01 f2                     	addq	%r14, %rdx
    4f63: 48 89 de                     	movq	%rbx, %rsi
    4f66: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4f6a: 49 89 df                     	movq	%rbx, %r15
    4f6d: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4f71: 49 31 f7                     	xorq	%rsi, %r15
    4f74: 49 89 dc                     	movq	%rbx, %r12
    4f77: 49 c1 c4 19                  	rolq	$0x19, %r12
    4f7b: 4d 31 fc                     	xorq	%r15, %r12
    4f7e: 4d 89 d7                     	movq	%r10, %r15
    4f81: 49 09 cf                     	orq	%rcx, %r15
    4f84: 49 21 df                     	andq	%rbx, %r15
    4f87: 4c 89 d6                     	movq	%r10, %rsi
    4f8a: 48 21 ce                     	andq	%rcx, %rsi
    4f8d: 4c 09 fe                     	orq	%r15, %rsi
    4f90: 49 89 d7                     	movq	%rdx, %r15
    4f93: 49 c1 c7 32                  	rolq	$0x32, %r15
    4f97: 4c 01 e6                     	addq	%r12, %rsi
    4f9a: 49 89 d4                     	movq	%rdx, %r12
    4f9d: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4fa1: 4c 01 f6                     	addq	%r14, %rsi
    4fa4: 49 89 d6                     	movq	%rdx, %r14
    4fa7: 49 c1 c6 17                  	rolq	$0x17, %r14
    4fab: 4d 31 fc                     	xorq	%r15, %r12
    4fae: 4d 31 e6                     	xorq	%r12, %r14
    4fb1: 4d 89 df                     	movq	%r11, %r15
    4fb4: 4d 31 cf                     	xorq	%r9, %r15
    4fb7: 49 21 d7                     	andq	%rdx, %r15
    4fba: 4d 31 cf                     	xorq	%r9, %r15
    4fbd: 4c 03 85 c8 fe ff ff         	addq	-0x138(%rbp), %r8
    4fc4: 4d 01 f8                     	addq	%r15, %r8
    4fc7: 49 bf b8 d1 bb 32 70 a0 6a 10	movabsq	$0x106aa07032bbd1b8, %r15 ## imm = 0x106AA07032BBD1B8
    4fd1: 4d 01 c7                     	addq	%r8, %r15
    4fd4: 4d 01 f7                     	addq	%r14, %r15
    4fd7: 4c 01 f9                     	addq	%r15, %rcx
    4fda: 49 89 f0                     	movq	%rsi, %r8
    4fdd: 49 c1 c0 24                  	rolq	$0x24, %r8
    4fe1: 49 89 f6                     	movq	%rsi, %r14
    4fe4: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4fe8: 4d 31 c6                     	xorq	%r8, %r14
    4feb: 49 89 f4                     	movq	%rsi, %r12
    4fee: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ff2: 4d 31 f4                     	xorq	%r14, %r12
    4ff5: 49 89 de                     	movq	%rbx, %r14
    4ff8: 4d 09 d6                     	orq	%r10, %r14
    4ffb: 49 21 f6                     	andq	%rsi, %r14
    4ffe: 49 89 d8                     	movq	%rbx, %r8
    5001: 4d 21 d0                     	andq	%r10, %r8
    5004: 4d 09 f0                     	orq	%r14, %r8
    5007: 4d 01 e0                     	addq	%r12, %r8
    500a: 4d 01 f8                     	addq	%r15, %r8
    500d: 49 89 ce                     	movq	%rcx, %r14
    5010: 49 c1 c6 32                  	rolq	$0x32, %r14
    5014: 49 89 cf                     	movq	%rcx, %r15
    5017: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    501b: 4d 31 f7                     	xorq	%r14, %r15
    501e: 49 89 cc                     	movq	%rcx, %r12
    5021: 49 c1 c4 17                  	rolq	$0x17, %r12
    5025: 4d 31 fc                     	xorq	%r15, %r12
    5028: 49 89 d6                     	movq	%rdx, %r14
    502b: 4d 31 de                     	xorq	%r11, %r14
    502e: 49 21 ce                     	andq	%rcx, %r14
    5031: 4c 03 8d d0 fe ff ff         	addq	-0x130(%rbp), %r9
    5038: 4d 31 de                     	xorq	%r11, %r14
    503b: 4d 01 f1                     	addq	%r14, %r9
    503e: 49 be c8 d0 d2 b8 16 c1 a4 19	movabsq	$0x19a4c116b8d2d0c8, %r14 ## imm = 0x19A4C116B8D2D0C8
    5048: 4d 01 ce                     	addq	%r9, %r14
    504b: 4d 01 e6                     	addq	%r12, %r14
    504e: 4d 89 c1                     	movq	%r8, %r9
    5051: 49 c1 c1 24                  	rolq	$0x24, %r9
    5055: 4d 01 f2                     	addq	%r14, %r10
    5058: 4d 89 c7                     	movq	%r8, %r15
    505b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    505f: 4d 31 cf                     	xorq	%r9, %r15
    5062: 4d 89 c4                     	movq	%r8, %r12
    5065: 49 c1 c4 19                  	rolq	$0x19, %r12
    5069: 4d 31 fc                     	xorq	%r15, %r12
    506c: 49 89 f7                     	movq	%rsi, %r15
    506f: 49 09 df                     	orq	%rbx, %r15
    5072: 4d 21 c7                     	andq	%r8, %r15
    5075: 49 89 f1                     	movq	%rsi, %r9
    5078: 49 21 d9                     	andq	%rbx, %r9
    507b: 4d 09 f9                     	orq	%r15, %r9
    507e: 4d 01 e1                     	addq	%r12, %r9
    5081: 4d 01 f1                     	addq	%r14, %r9
    5084: 4d 89 d6                     	movq	%r10, %r14
    5087: 49 c1 c6 32                  	rolq	$0x32, %r14
    508b: 4d 89 d7                     	movq	%r10, %r15
    508e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5092: 4d 31 f7                     	xorq	%r14, %r15
    5095: 4d 89 d4                     	movq	%r10, %r12
    5098: 49 c1 c4 17                  	rolq	$0x17, %r12
    509c: 4d 31 fc                     	xorq	%r15, %r12
    509f: 49 89 ce                     	movq	%rcx, %r14
    50a2: 49 31 d6                     	xorq	%rdx, %r14
    50a5: 4d 21 d6                     	andq	%r10, %r14
    50a8: 49 31 d6                     	xorq	%rdx, %r14
    50ab: 4c 03 9d d8 fe ff ff         	addq	-0x128(%rbp), %r11
    50b2: 4d 01 f3                     	addq	%r14, %r11
    50b5: 49 be 53 ab 41 51 08 6c 37 1e	movabsq	$0x1e376c085141ab53, %r14 ## imm = 0x1E376C085141AB53
    50bf: 4d 01 de                     	addq	%r11, %r14
    50c2: 4d 89 cb                     	movq	%r9, %r11
    50c5: 49 c1 c3 24                  	rolq	$0x24, %r11
    50c9: 4d 01 e6                     	addq	%r12, %r14
    50cc: 4d 89 cf                     	movq	%r9, %r15
    50cf: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    50d3: 4c 01 f3                     	addq	%r14, %rbx
    50d6: 4d 89 cc                     	movq	%r9, %r12
    50d9: 49 c1 c4 19                  	rolq	$0x19, %r12
    50dd: 4d 31 df                     	xorq	%r11, %r15
    50e0: 4d 31 fc                     	xorq	%r15, %r12
    50e3: 4d 89 c7                     	movq	%r8, %r15
    50e6: 49 09 f7                     	orq	%rsi, %r15
    50e9: 4d 21 cf                     	andq	%r9, %r15
    50ec: 4d 89 c3                     	movq	%r8, %r11
    50ef: 49 21 f3                     	andq	%rsi, %r11
    50f2: 4d 09 fb                     	orq	%r15, %r11
    50f5: 4d 01 e3                     	addq	%r12, %r11
    50f8: 49 89 df                     	movq	%rbx, %r15
    50fb: 49 c1 c7 32                  	rolq	$0x32, %r15
    50ff: 4d 01 f3                     	addq	%r14, %r11
    5102: 49 89 de                     	movq	%rbx, %r14
    5105: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5109: 4d 31 fe                     	xorq	%r15, %r14
    510c: 49 89 df                     	movq	%rbx, %r15
    510f: 49 c1 c7 17                  	rolq	$0x17, %r15
    5113: 4d 31 f7                     	xorq	%r14, %r15
    5116: 4d 89 d6                     	movq	%r10, %r14
    5119: 49 31 ce                     	xorq	%rcx, %r14
    511c: 49 21 de                     	andq	%rbx, %r14
    511f: 49 31 ce                     	xorq	%rcx, %r14
    5122: 48 03 95 e0 fe ff ff         	addq	-0x120(%rbp), %rdx
    5129: 4c 01 f2                     	addq	%r14, %rdx
    512c: 49 be 99 eb 8e df 4c 77 48 27	movabsq	$0x2748774cdf8eeb99, %r14 ## imm = 0x2748774CDF8EEB99
    5136: 49 01 d6                     	addq	%rdx, %r14
    5139: 4d 01 fe                     	addq	%r15, %r14
    513c: 4c 01 f6                     	addq	%r14, %rsi
    513f: 4c 89 da                     	movq	%r11, %rdx
    5142: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5146: 4d 89 df                     	movq	%r11, %r15
    5149: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    514d: 49 31 d7                     	xorq	%rdx, %r15
    5150: 4d 89 dc                     	movq	%r11, %r12
    5153: 49 c1 c4 19                  	rolq	$0x19, %r12
    5157: 4d 31 fc                     	xorq	%r15, %r12
    515a: 4d 89 cf                     	movq	%r9, %r15
    515d: 4d 09 c7                     	orq	%r8, %r15
    5160: 4d 21 df                     	andq	%r11, %r15
    5163: 4c 89 ca                     	movq	%r9, %rdx
    5166: 4c 21 c2                     	andq	%r8, %rdx
    5169: 4c 09 fa                     	orq	%r15, %rdx
    516c: 49 89 f7                     	movq	%rsi, %r15
    516f: 49 c1 c7 32                  	rolq	$0x32, %r15
    5173: 4c 01 e2                     	addq	%r12, %rdx
    5176: 49 89 f4                     	movq	%rsi, %r12
    5179: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    517d: 4c 01 f2                     	addq	%r14, %rdx
    5180: 49 89 f6                     	movq	%rsi, %r14
    5183: 49 c1 c6 17                  	rolq	$0x17, %r14
    5187: 4d 31 fc                     	xorq	%r15, %r12
    518a: 4d 31 e6                     	xorq	%r12, %r14
    518d: 49 89 df                     	movq	%rbx, %r15
    5190: 4d 31 d7                     	xorq	%r10, %r15
    5193: 49 21 f7                     	andq	%rsi, %r15
    5196: 4d 31 d7                     	xorq	%r10, %r15
    5199: 48 03 8d e8 fe ff ff         	addq	-0x118(%rbp), %rcx
    51a0: 4c 01 f9                     	addq	%r15, %rcx
    51a3: 49 bf a8 48 9b e1 b5 bc b0 34	movabsq	$0x34b0bcb5e19b48a8, %r15 ## imm = 0x34B0BCB5E19B48A8
    51ad: 49 01 cf                     	addq	%rcx, %r15
    51b0: 4d 01 f7                     	addq	%r14, %r15
    51b3: 4d 01 f8                     	addq	%r15, %r8
    51b6: 48 89 d1                     	movq	%rdx, %rcx
    51b9: 48 c1 c1 24                  	rolq	$0x24, %rcx
    51bd: 49 89 d6                     	movq	%rdx, %r14
    51c0: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    51c4: 49 31 ce                     	xorq	%rcx, %r14
    51c7: 49 89 d4                     	movq	%rdx, %r12
    51ca: 49 c1 c4 19                  	rolq	$0x19, %r12
    51ce: 4d 31 f4                     	xorq	%r14, %r12
    51d1: 4d 89 de                     	movq	%r11, %r14
    51d4: 4d 09 ce                     	orq	%r9, %r14
    51d7: 49 21 d6                     	andq	%rdx, %r14
    51da: 4c 89 d9                     	movq	%r11, %rcx
    51dd: 4c 21 c9                     	andq	%r9, %rcx
    51e0: 4c 09 f1                     	orq	%r14, %rcx
    51e3: 4c 01 e1                     	addq	%r12, %rcx
    51e6: 4c 01 f9                     	addq	%r15, %rcx
    51e9: 4d 89 c6                     	movq	%r8, %r14
    51ec: 49 c1 c6 32                  	rolq	$0x32, %r14
    51f0: 4d 89 c7                     	movq	%r8, %r15
    51f3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    51f7: 4d 31 f7                     	xorq	%r14, %r15
    51fa: 4d 89 c4                     	movq	%r8, %r12
    51fd: 49 c1 c4 17                  	rolq	$0x17, %r12
    5201: 4d 31 fc                     	xorq	%r15, %r12
    5204: 49 89 f6                     	movq	%rsi, %r14
    5207: 49 31 de                     	xorq	%rbx, %r14
    520a: 4d 21 c6                     	andq	%r8, %r14
    520d: 4c 03 95 f0 fe ff ff         	addq	-0x110(%rbp), %r10
    5214: 49 31 de                     	xorq	%rbx, %r14
    5217: 4d 01 f2                     	addq	%r14, %r10
    521a: 49 be 63 5a c9 c5 b3 0c 1c 39	movabsq	$0x391c0cb3c5c95a63, %r14 ## imm = 0x391C0CB3C5C95A63
    5224: 4d 01 d6                     	addq	%r10, %r14
    5227: 4d 01 e6                     	addq	%r12, %r14
    522a: 49 89 ca                     	movq	%rcx, %r10
    522d: 49 c1 c2 24                  	rolq	$0x24, %r10
    5231: 4d 01 f1                     	addq	%r14, %r9
    5234: 49 89 cf                     	movq	%rcx, %r15
    5237: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    523b: 4d 31 d7                     	xorq	%r10, %r15
    523e: 49 89 cc                     	movq	%rcx, %r12
    5241: 49 c1 c4 19                  	rolq	$0x19, %r12
    5245: 4d 31 fc                     	xorq	%r15, %r12
    5248: 49 89 d7                     	movq	%rdx, %r15
    524b: 4d 09 df                     	orq	%r11, %r15
    524e: 49 21 cf                     	andq	%rcx, %r15
    5251: 49 89 d2                     	movq	%rdx, %r10
    5254: 4d 21 da                     	andq	%r11, %r10
    5257: 4d 09 fa                     	orq	%r15, %r10
    525a: 4d 01 e2                     	addq	%r12, %r10
    525d: 4d 01 f2                     	addq	%r14, %r10
    5260: 4d 89 ce                     	movq	%r9, %r14
    5263: 49 c1 c6 32                  	rolq	$0x32, %r14
    5267: 4d 89 cf                     	movq	%r9, %r15
    526a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    526e: 4d 31 f7                     	xorq	%r14, %r15
    5271: 4d 89 cc                     	movq	%r9, %r12
    5274: 49 c1 c4 17                  	rolq	$0x17, %r12
    5278: 4d 31 fc                     	xorq	%r15, %r12
    527b: 4d 89 c6                     	movq	%r8, %r14
    527e: 49 31 f6                     	xorq	%rsi, %r14
    5281: 4d 21 ce                     	andq	%r9, %r14
    5284: 49 31 f6                     	xorq	%rsi, %r14
    5287: 48 03 9d f8 fe ff ff         	addq	-0x108(%rbp), %rbx
    528e: 4c 01 f3                     	addq	%r14, %rbx
    5291: 49 be cb 8a 41 e3 4a aa d8 4e	movabsq	$0x4ed8aa4ae3418acb, %r14 ## imm = 0x4ED8AA4AE3418ACB
    529b: 49 01 de                     	addq	%rbx, %r14
    529e: 4c 89 d3                     	movq	%r10, %rbx
    52a1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    52a5: 4d 01 e6                     	addq	%r12, %r14
    52a8: 4d 89 d7                     	movq	%r10, %r15
    52ab: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    52af: 4d 01 f3                     	addq	%r14, %r11
    52b2: 4d 89 d4                     	movq	%r10, %r12
    52b5: 49 c1 c4 19                  	rolq	$0x19, %r12
    52b9: 49 31 df                     	xorq	%rbx, %r15
    52bc: 4d 31 fc                     	xorq	%r15, %r12
    52bf: 49 89 cf                     	movq	%rcx, %r15
    52c2: 49 09 d7                     	orq	%rdx, %r15
    52c5: 4d 21 d7                     	andq	%r10, %r15
    52c8: 48 89 cb                     	movq	%rcx, %rbx
    52cb: 48 21 d3                     	andq	%rdx, %rbx
    52ce: 4c 09 fb                     	orq	%r15, %rbx
    52d1: 4c 01 e3                     	addq	%r12, %rbx
    52d4: 4d 89 df                     	movq	%r11, %r15
    52d7: 49 c1 c7 32                  	rolq	$0x32, %r15
    52db: 4c 01 f3                     	addq	%r14, %rbx
    52de: 4d 89 de                     	movq	%r11, %r14
    52e1: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    52e5: 4d 31 fe                     	xorq	%r15, %r14
    52e8: 4d 89 df                     	movq	%r11, %r15
    52eb: 49 c1 c7 17                  	rolq	$0x17, %r15
    52ef: 4d 31 f7                     	xorq	%r14, %r15
    52f2: 4d 89 ce                     	movq	%r9, %r14
    52f5: 4d 31 c6                     	xorq	%r8, %r14
    52f8: 4d 21 de                     	andq	%r11, %r14
    52fb: 4d 31 c6                     	xorq	%r8, %r14
    52fe: 48 03 b5 00 ff ff ff         	addq	-0x100(%rbp), %rsi
    5305: 4c 01 f6                     	addq	%r14, %rsi
    5308: 49 be 73 e3 63 77 4f ca 9c 5b	movabsq	$0x5b9cca4f7763e373, %r14 ## imm = 0x5B9CCA4F7763E373
    5312: 49 01 f6                     	addq	%rsi, %r14
    5315: 4d 01 fe                     	addq	%r15, %r14
    5318: 4c 01 f2                     	addq	%r14, %rdx
    531b: 48 89 de                     	movq	%rbx, %rsi
    531e: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5322: 49 89 df                     	movq	%rbx, %r15
    5325: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5329: 49 31 f7                     	xorq	%rsi, %r15
    532c: 49 89 dc                     	movq	%rbx, %r12
    532f: 49 c1 c4 19                  	rolq	$0x19, %r12
    5333: 4d 31 fc                     	xorq	%r15, %r12
    5336: 4d 89 d7                     	movq	%r10, %r15
    5339: 49 09 cf                     	orq	%rcx, %r15
    533c: 49 21 df                     	andq	%rbx, %r15
    533f: 4c 89 d6                     	movq	%r10, %rsi
    5342: 48 21 ce                     	andq	%rcx, %rsi
    5345: 4c 09 fe                     	orq	%r15, %rsi
    5348: 49 89 d7                     	movq	%rdx, %r15
    534b: 49 c1 c7 32                  	rolq	$0x32, %r15
    534f: 4c 01 e6                     	addq	%r12, %rsi
    5352: 49 89 d4                     	movq	%rdx, %r12
    5355: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5359: 4c 01 f6                     	addq	%r14, %rsi
    535c: 49 89 d6                     	movq	%rdx, %r14
    535f: 49 c1 c6 17                  	rolq	$0x17, %r14
    5363: 4d 31 fc                     	xorq	%r15, %r12
    5366: 4d 31 e6                     	xorq	%r12, %r14
    5369: 4d 89 df                     	movq	%r11, %r15
    536c: 4d 31 cf                     	xorq	%r9, %r15
    536f: 49 21 d7                     	andq	%rdx, %r15
    5372: 4d 31 cf                     	xorq	%r9, %r15
    5375: 4c 03 85 08 ff ff ff         	addq	-0xf8(%rbp), %r8
    537c: 4d 01 f8                     	addq	%r15, %r8
    537f: 49 bf a3 b8 b2 d6 f3 6f 2e 68	movabsq	$0x682e6ff3d6b2b8a3, %r15 ## imm = 0x682E6FF3D6B2B8A3
    5389: 4d 01 c7                     	addq	%r8, %r15
    538c: 4d 01 f7                     	addq	%r14, %r15
    538f: 4c 01 f9                     	addq	%r15, %rcx
    5392: 49 89 f0                     	movq	%rsi, %r8
    5395: 49 c1 c0 24                  	rolq	$0x24, %r8
    5399: 49 89 f6                     	movq	%rsi, %r14
    539c: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    53a0: 4d 31 c6                     	xorq	%r8, %r14
    53a3: 49 89 f4                     	movq	%rsi, %r12
    53a6: 49 c1 c4 19                  	rolq	$0x19, %r12
    53aa: 4d 31 f4                     	xorq	%r14, %r12
    53ad: 49 89 de                     	movq	%rbx, %r14
    53b0: 4d 09 d6                     	orq	%r10, %r14
    53b3: 49 21 f6                     	andq	%rsi, %r14
    53b6: 49 89 d8                     	movq	%rbx, %r8
    53b9: 4d 21 d0                     	andq	%r10, %r8
    53bc: 4d 09 f0                     	orq	%r14, %r8
    53bf: 4d 01 e0                     	addq	%r12, %r8
    53c2: 4d 01 f8                     	addq	%r15, %r8
    53c5: 49 89 ce                     	movq	%rcx, %r14
    53c8: 49 c1 c6 32                  	rolq	$0x32, %r14
    53cc: 49 89 cf                     	movq	%rcx, %r15
    53cf: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    53d3: 4d 31 f7                     	xorq	%r14, %r15
    53d6: 49 89 cc                     	movq	%rcx, %r12
    53d9: 49 c1 c4 17                  	rolq	$0x17, %r12
    53dd: 4d 31 fc                     	xorq	%r15, %r12
    53e0: 49 89 d6                     	movq	%rdx, %r14
    53e3: 4d 31 de                     	xorq	%r11, %r14
    53e6: 49 21 ce                     	andq	%rcx, %r14
    53e9: 4c 03 8d 10 ff ff ff         	addq	-0xf0(%rbp), %r9
    53f0: 4d 31 de                     	xorq	%r11, %r14
    53f3: 4d 01 f1                     	addq	%r14, %r9
    53f6: 49 be fc b2 ef 5d ee 82 8f 74	movabsq	$0x748f82ee5defb2fc, %r14 ## imm = 0x748F82EE5DEFB2FC
    5400: 4d 01 ce                     	addq	%r9, %r14
    5403: 4d 01 e6                     	addq	%r12, %r14
    5406: 4d 89 c1                     	movq	%r8, %r9
    5409: 49 c1 c1 24                  	rolq	$0x24, %r9
    540d: 4d 01 f2                     	addq	%r14, %r10
    5410: 4d 89 c7                     	movq	%r8, %r15
    5413: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5417: 4d 31 cf                     	xorq	%r9, %r15
    541a: 4d 89 c4                     	movq	%r8, %r12
    541d: 49 c1 c4 19                  	rolq	$0x19, %r12
    5421: 4d 31 fc                     	xorq	%r15, %r12
    5424: 49 89 f7                     	movq	%rsi, %r15
    5427: 49 09 df                     	orq	%rbx, %r15
    542a: 4d 21 c7                     	andq	%r8, %r15
    542d: 49 89 f1                     	movq	%rsi, %r9
    5430: 49 21 d9                     	andq	%rbx, %r9
    5433: 4d 09 f9                     	orq	%r15, %r9
    5436: 4d 01 e1                     	addq	%r12, %r9
    5439: 4d 01 f1                     	addq	%r14, %r9
    543c: 4d 89 d6                     	movq	%r10, %r14
    543f: 49 c1 c6 32                  	rolq	$0x32, %r14
    5443: 4d 89 d7                     	movq	%r10, %r15
    5446: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    544a: 4d 31 f7                     	xorq	%r14, %r15
    544d: 4d 89 d4                     	movq	%r10, %r12
    5450: 49 c1 c4 17                  	rolq	$0x17, %r12
    5454: 4d 31 fc                     	xorq	%r15, %r12
    5457: 49 89 ce                     	movq	%rcx, %r14
    545a: 49 31 d6                     	xorq	%rdx, %r14
    545d: 4d 21 d6                     	andq	%r10, %r14
    5460: 49 31 d6                     	xorq	%rdx, %r14
    5463: 4c 03 9d 18 ff ff ff         	addq	-0xe8(%rbp), %r11
    546a: 4d 01 f3                     	addq	%r14, %r11
    546d: 49 be 60 2f 17 43 6f 63 a5 78	movabsq	$0x78a5636f43172f60, %r14 ## imm = 0x78A5636F43172F60
    5477: 4d 01 de                     	addq	%r11, %r14
    547a: 4d 89 cb                     	movq	%r9, %r11
    547d: 49 c1 c3 24                  	rolq	$0x24, %r11
    5481: 4d 01 e6                     	addq	%r12, %r14
    5484: 4d 89 cf                     	movq	%r9, %r15
    5487: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    548b: 4c 01 f3                     	addq	%r14, %rbx
    548e: 4d 89 cc                     	movq	%r9, %r12
    5491: 49 c1 c4 19                  	rolq	$0x19, %r12
    5495: 4d 31 df                     	xorq	%r11, %r15
    5498: 4d 31 fc                     	xorq	%r15, %r12
    549b: 4d 89 c7                     	movq	%r8, %r15
    549e: 49 09 f7                     	orq	%rsi, %r15
    54a1: 4d 21 cf                     	andq	%r9, %r15
    54a4: 4d 89 c3                     	movq	%r8, %r11
    54a7: 49 21 f3                     	andq	%rsi, %r11
    54aa: 4d 09 fb                     	orq	%r15, %r11
    54ad: 4d 01 e3                     	addq	%r12, %r11
    54b0: 49 89 df                     	movq	%rbx, %r15
    54b3: 49 c1 c7 32                  	rolq	$0x32, %r15
    54b7: 4d 01 f3                     	addq	%r14, %r11
    54ba: 49 89 de                     	movq	%rbx, %r14
    54bd: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    54c1: 4d 31 fe                     	xorq	%r15, %r14
    54c4: 49 89 df                     	movq	%rbx, %r15
    54c7: 49 c1 c7 17                  	rolq	$0x17, %r15
    54cb: 4d 31 f7                     	xorq	%r14, %r15
    54ce: 4d 89 d6                     	movq	%r10, %r14
    54d1: 49 31 ce                     	xorq	%rcx, %r14
    54d4: 49 21 de                     	andq	%rbx, %r14
    54d7: 49 31 ce                     	xorq	%rcx, %r14
    54da: 48 03 95 20 ff ff ff         	addq	-0xe0(%rbp), %rdx
    54e1: 4c 01 f2                     	addq	%r14, %rdx
    54e4: 49 be 72 ab f0 a1 14 78 c8 84	movabsq	$-0x7b3787eb5e0f548e, %r14 ## imm = 0x84C87814A1F0AB72
    54ee: 49 01 d6                     	addq	%rdx, %r14
    54f1: 4d 01 fe                     	addq	%r15, %r14
    54f4: 4c 01 f6                     	addq	%r14, %rsi
    54f7: 4c 89 da                     	movq	%r11, %rdx
    54fa: 48 c1 c2 24                  	rolq	$0x24, %rdx
    54fe: 4d 89 df                     	movq	%r11, %r15
    5501: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5505: 49 31 d7                     	xorq	%rdx, %r15
    5508: 4d 89 dc                     	movq	%r11, %r12
    550b: 49 c1 c4 19                  	rolq	$0x19, %r12
    550f: 4d 31 fc                     	xorq	%r15, %r12
    5512: 4d 89 cf                     	movq	%r9, %r15
    5515: 4d 09 c7                     	orq	%r8, %r15
    5518: 4d 21 df                     	andq	%r11, %r15
    551b: 4c 89 ca                     	movq	%r9, %rdx
    551e: 4c 21 c2                     	andq	%r8, %rdx
    5521: 4c 09 fa                     	orq	%r15, %rdx
    5524: 49 89 f7                     	movq	%rsi, %r15
    5527: 49 c1 c7 32                  	rolq	$0x32, %r15
    552b: 4c 01 e2                     	addq	%r12, %rdx
    552e: 49 89 f4                     	movq	%rsi, %r12
    5531: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5535: 4c 01 f2                     	addq	%r14, %rdx
    5538: 49 89 f6                     	movq	%rsi, %r14
    553b: 49 c1 c6 17                  	rolq	$0x17, %r14
    553f: 4d 31 fc                     	xorq	%r15, %r12
    5542: 4d 31 e6                     	xorq	%r12, %r14
    5545: 49 89 df                     	movq	%rbx, %r15
    5548: 4d 31 d7                     	xorq	%r10, %r15
    554b: 49 21 f7                     	andq	%rsi, %r15
    554e: 4d 31 d7                     	xorq	%r10, %r15
    5551: 48 03 8d 28 ff ff ff         	addq	-0xd8(%rbp), %rcx
    5558: 4c 01 f9                     	addq	%r15, %rcx
    555b: 49 bf ec 39 64 1a 08 02 c7 8c	movabsq	$-0x7338fdf7e59bc614, %r15 ## imm = 0x8CC702081A6439EC
    5565: 49 01 cf                     	addq	%rcx, %r15
    5568: 4d 01 f7                     	addq	%r14, %r15
    556b: 4d 01 f8                     	addq	%r15, %r8
    556e: 48 89 d1                     	movq	%rdx, %rcx
    5571: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5575: 49 89 d6                     	movq	%rdx, %r14
    5578: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    557c: 49 31 ce                     	xorq	%rcx, %r14
    557f: 49 89 d4                     	movq	%rdx, %r12
    5582: 49 c1 c4 19                  	rolq	$0x19, %r12
    5586: 4d 31 f4                     	xorq	%r14, %r12
    5589: 4d 89 de                     	movq	%r11, %r14
    558c: 4d 09 ce                     	orq	%r9, %r14
    558f: 49 21 d6                     	andq	%rdx, %r14
    5592: 4c 89 d9                     	movq	%r11, %rcx
    5595: 4c 21 c9                     	andq	%r9, %rcx
    5598: 4c 09 f1                     	orq	%r14, %rcx
    559b: 4c 01 e1                     	addq	%r12, %rcx
    559e: 4c 01 f9                     	addq	%r15, %rcx
    55a1: 4d 89 c6                     	movq	%r8, %r14
    55a4: 49 c1 c6 32                  	rolq	$0x32, %r14
    55a8: 4d 89 c7                     	movq	%r8, %r15
    55ab: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    55af: 4d 31 f7                     	xorq	%r14, %r15
    55b2: 4d 89 c4                     	movq	%r8, %r12
    55b5: 49 c1 c4 17                  	rolq	$0x17, %r12
    55b9: 4d 31 fc                     	xorq	%r15, %r12
    55bc: 49 89 f6                     	movq	%rsi, %r14
    55bf: 49 31 de                     	xorq	%rbx, %r14
    55c2: 4d 21 c6                     	andq	%r8, %r14
    55c5: 4c 03 95 30 ff ff ff         	addq	-0xd0(%rbp), %r10
    55cc: 49 31 de                     	xorq	%rbx, %r14
    55cf: 4d 01 f2                     	addq	%r14, %r10
    55d2: 49 be 28 1e 63 23 fa ff be 90	movabsq	$-0x6f410005dc9ce1d8, %r14 ## imm = 0x90BEFFFA23631E28
    55dc: 4d 01 d6                     	addq	%r10, %r14
    55df: 4d 01 e6                     	addq	%r12, %r14
    55e2: 49 89 ca                     	movq	%rcx, %r10
    55e5: 49 c1 c2 24                  	rolq	$0x24, %r10
    55e9: 4d 01 f1                     	addq	%r14, %r9
    55ec: 49 89 cf                     	movq	%rcx, %r15
    55ef: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    55f3: 4d 31 d7                     	xorq	%r10, %r15
    55f6: 49 89 cc                     	movq	%rcx, %r12
    55f9: 49 c1 c4 19                  	rolq	$0x19, %r12
    55fd: 4d 31 fc                     	xorq	%r15, %r12
    5600: 49 89 d7                     	movq	%rdx, %r15
    5603: 4d 09 df                     	orq	%r11, %r15
    5606: 49 21 cf                     	andq	%rcx, %r15
    5609: 49 89 d2                     	movq	%rdx, %r10
    560c: 4d 21 da                     	andq	%r11, %r10
    560f: 4d 09 fa                     	orq	%r15, %r10
    5612: 4d 01 e2                     	addq	%r12, %r10
    5615: 4d 01 f2                     	addq	%r14, %r10
    5618: 4d 89 ce                     	movq	%r9, %r14
    561b: 49 c1 c6 32                  	rolq	$0x32, %r14
    561f: 4d 89 cf                     	movq	%r9, %r15
    5622: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5626: 4d 31 f7                     	xorq	%r14, %r15
    5629: 4d 89 cc                     	movq	%r9, %r12
    562c: 49 c1 c4 17                  	rolq	$0x17, %r12
    5630: 4d 31 fc                     	xorq	%r15, %r12
    5633: 4d 89 c6                     	movq	%r8, %r14
    5636: 49 31 f6                     	xorq	%rsi, %r14
    5639: 4d 21 ce                     	andq	%r9, %r14
    563c: 49 31 f6                     	xorq	%rsi, %r14
    563f: 48 03 9d 38 ff ff ff         	addq	-0xc8(%rbp), %rbx
    5646: 4c 01 f3                     	addq	%r14, %rbx
    5649: 49 be e9 bd 82 de eb 6c 50 a4	movabsq	$-0x5baf9314217d4217, %r14 ## imm = 0xA4506CEBDE82BDE9
    5653: 49 01 de                     	addq	%rbx, %r14
    5656: 4c 89 d3                     	movq	%r10, %rbx
    5659: 48 c1 c3 24                  	rolq	$0x24, %rbx
    565d: 4d 01 e6                     	addq	%r12, %r14
    5660: 4d 89 d7                     	movq	%r10, %r15
    5663: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5667: 4d 01 f3                     	addq	%r14, %r11
    566a: 4d 89 d4                     	movq	%r10, %r12
    566d: 49 c1 c4 19                  	rolq	$0x19, %r12
    5671: 49 31 df                     	xorq	%rbx, %r15
    5674: 4d 31 fc                     	xorq	%r15, %r12
    5677: 49 89 cf                     	movq	%rcx, %r15
    567a: 49 09 d7                     	orq	%rdx, %r15
    567d: 4d 21 d7                     	andq	%r10, %r15
    5680: 48 89 cb                     	movq	%rcx, %rbx
    5683: 48 21 d3                     	andq	%rdx, %rbx
    5686: 4c 09 fb                     	orq	%r15, %rbx
    5689: 4c 01 e3                     	addq	%r12, %rbx
    568c: 4d 89 df                     	movq	%r11, %r15
    568f: 49 c1 c7 32                  	rolq	$0x32, %r15
    5693: 4c 01 f3                     	addq	%r14, %rbx
    5696: 4d 89 de                     	movq	%r11, %r14
    5699: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    569d: 4d 31 fe                     	xorq	%r15, %r14
    56a0: 4d 89 df                     	movq	%r11, %r15
    56a3: 49 c1 c7 17                  	rolq	$0x17, %r15
    56a7: 4d 31 f7                     	xorq	%r14, %r15
    56aa: 4d 89 ce                     	movq	%r9, %r14
    56ad: 4d 31 c6                     	xorq	%r8, %r14
    56b0: 4d 21 de                     	andq	%r11, %r14
    56b3: 4d 31 c6                     	xorq	%r8, %r14
    56b6: 48 03 b5 40 ff ff ff         	addq	-0xc0(%rbp), %rsi
    56bd: 4c 01 f6                     	addq	%r14, %rsi
    56c0: 49 be 15 79 c6 b2 f7 a3 f9 be	movabsq	$-0x41065c084d3986eb, %r14 ## imm = 0xBEF9A3F7B2C67915
    56ca: 49 01 f6                     	addq	%rsi, %r14
    56cd: 4d 01 fe                     	addq	%r15, %r14
    56d0: 4c 01 f2                     	addq	%r14, %rdx
    56d3: 48 89 de                     	movq	%rbx, %rsi
    56d6: 48 c1 c6 24                  	rolq	$0x24, %rsi
    56da: 49 89 df                     	movq	%rbx, %r15
    56dd: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    56e1: 49 31 f7                     	xorq	%rsi, %r15
    56e4: 49 89 dc                     	movq	%rbx, %r12
    56e7: 49 c1 c4 19                  	rolq	$0x19, %r12
    56eb: 4d 31 fc                     	xorq	%r15, %r12
    56ee: 4d 89 d7                     	movq	%r10, %r15
    56f1: 49 09 cf                     	orq	%rcx, %r15
    56f4: 49 21 df                     	andq	%rbx, %r15
    56f7: 4c 89 d6                     	movq	%r10, %rsi
    56fa: 48 21 ce                     	andq	%rcx, %rsi
    56fd: 4c 09 fe                     	orq	%r15, %rsi
    5700: 49 89 d7                     	movq	%rdx, %r15
    5703: 49 c1 c7 32                  	rolq	$0x32, %r15
    5707: 4c 01 e6                     	addq	%r12, %rsi
    570a: 49 89 d4                     	movq	%rdx, %r12
    570d: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5711: 4c 01 f6                     	addq	%r14, %rsi
    5714: 49 89 d6                     	movq	%rdx, %r14
    5717: 49 c1 c6 17                  	rolq	$0x17, %r14
    571b: 4d 31 fc                     	xorq	%r15, %r12
    571e: 4d 31 e6                     	xorq	%r12, %r14
    5721: 4d 89 df                     	movq	%r11, %r15
    5724: 4d 31 cf                     	xorq	%r9, %r15
    5727: 49 21 d7                     	andq	%rdx, %r15
    572a: 4d 31 cf                     	xorq	%r9, %r15
    572d: 4c 03 85 48 ff ff ff         	addq	-0xb8(%rbp), %r8
    5734: 4d 01 f8                     	addq	%r15, %r8
    5737: 49 bf 2b 53 72 e3 f2 78 71 c6	movabsq	$-0x398e870d1c8dacd5, %r15 ## imm = 0xC67178F2E372532B
    5741: 4d 01 c7                     	addq	%r8, %r15
    5744: 4d 01 f7                     	addq	%r14, %r15
    5747: 4c 01 f9                     	addq	%r15, %rcx
    574a: 49 89 f0                     	movq	%rsi, %r8
    574d: 49 c1 c0 24                  	rolq	$0x24, %r8
    5751: 49 89 f6                     	movq	%rsi, %r14
    5754: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5758: 4d 31 c6                     	xorq	%r8, %r14
    575b: 49 89 f4                     	movq	%rsi, %r12
    575e: 49 c1 c4 19                  	rolq	$0x19, %r12
    5762: 4d 31 f4                     	xorq	%r14, %r12
    5765: 49 89 de                     	movq	%rbx, %r14
    5768: 4d 09 d6                     	orq	%r10, %r14
    576b: 49 21 f6                     	andq	%rsi, %r14
    576e: 49 89 d8                     	movq	%rbx, %r8
    5771: 4d 21 d0                     	andq	%r10, %r8
    5774: 4d 09 f0                     	orq	%r14, %r8
    5777: 4d 01 e0                     	addq	%r12, %r8
    577a: 4d 01 f8                     	addq	%r15, %r8
    577d: 49 89 ce                     	movq	%rcx, %r14
    5780: 49 c1 c6 32                  	rolq	$0x32, %r14
    5784: 49 89 cf                     	movq	%rcx, %r15
    5787: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    578b: 4d 31 f7                     	xorq	%r14, %r15
    578e: 49 89 cc                     	movq	%rcx, %r12
    5791: 49 c1 c4 17                  	rolq	$0x17, %r12
    5795: 4d 31 fc                     	xorq	%r15, %r12
    5798: 49 89 d6                     	movq	%rdx, %r14
    579b: 4d 31 de                     	xorq	%r11, %r14
    579e: 49 21 ce                     	andq	%rcx, %r14
    57a1: 4c 03 8d 50 ff ff ff         	addq	-0xb0(%rbp), %r9
    57a8: 4d 31 de                     	xorq	%r11, %r14
    57ab: 4d 01 f1                     	addq	%r14, %r9
    57ae: 49 be 9c 61 26 ea ce 3e 27 ca	movabsq	$-0x35d8c13115d99e64, %r14 ## imm = 0xCA273ECEEA26619C
    57b8: 4d 01 ce                     	addq	%r9, %r14
    57bb: 4d 01 e6                     	addq	%r12, %r14
    57be: 4d 89 c1                     	movq	%r8, %r9
    57c1: 49 c1 c1 24                  	rolq	$0x24, %r9
    57c5: 4d 01 f2                     	addq	%r14, %r10
    57c8: 4d 89 c7                     	movq	%r8, %r15
    57cb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    57cf: 4d 31 cf                     	xorq	%r9, %r15
    57d2: 4d 89 c4                     	movq	%r8, %r12
    57d5: 49 c1 c4 19                  	rolq	$0x19, %r12
    57d9: 4d 31 fc                     	xorq	%r15, %r12
    57dc: 49 89 f7                     	movq	%rsi, %r15
    57df: 49 09 df                     	orq	%rbx, %r15
    57e2: 4d 21 c7                     	andq	%r8, %r15
    57e5: 49 89 f1                     	movq	%rsi, %r9
    57e8: 49 21 d9                     	andq	%rbx, %r9
    57eb: 4d 09 f9                     	orq	%r15, %r9
    57ee: 4d 01 e1                     	addq	%r12, %r9
    57f1: 4d 01 f1                     	addq	%r14, %r9
    57f4: 4d 89 d6                     	movq	%r10, %r14
    57f7: 49 c1 c6 32                  	rolq	$0x32, %r14
    57fb: 4d 89 d7                     	movq	%r10, %r15
    57fe: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5802: 4d 31 f7                     	xorq	%r14, %r15
    5805: 4d 89 d4                     	movq	%r10, %r12
    5808: 49 c1 c4 17                  	rolq	$0x17, %r12
    580c: 4d 31 fc                     	xorq	%r15, %r12
    580f: 49 89 ce                     	movq	%rcx, %r14
    5812: 49 31 d6                     	xorq	%rdx, %r14
    5815: 4d 21 d6                     	andq	%r10, %r14
    5818: 49 31 d6                     	xorq	%rdx, %r14
    581b: 4c 03 9d 58 ff ff ff         	addq	-0xa8(%rbp), %r11
    5822: 4d 01 f3                     	addq	%r14, %r11
    5825: 49 be 07 c2 c0 21 c7 b8 86 d1	movabsq	$-0x2e794738de3f3df9, %r14 ## imm = 0xD186B8C721C0C207
    582f: 4d 01 de                     	addq	%r11, %r14
    5832: 4d 89 cb                     	movq	%r9, %r11
    5835: 49 c1 c3 24                  	rolq	$0x24, %r11
    5839: 4d 01 e6                     	addq	%r12, %r14
    583c: 4d 89 cf                     	movq	%r9, %r15
    583f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5843: 4c 01 f3                     	addq	%r14, %rbx
    5846: 4d 89 cc                     	movq	%r9, %r12
    5849: 49 c1 c4 19                  	rolq	$0x19, %r12
    584d: 4d 31 df                     	xorq	%r11, %r15
    5850: 4d 31 fc                     	xorq	%r15, %r12
    5853: 4d 89 c7                     	movq	%r8, %r15
    5856: 49 09 f7                     	orq	%rsi, %r15
    5859: 4d 21 cf                     	andq	%r9, %r15
    585c: 4d 89 c3                     	movq	%r8, %r11
    585f: 49 21 f3                     	andq	%rsi, %r11
    5862: 4d 09 fb                     	orq	%r15, %r11
    5865: 4d 01 e3                     	addq	%r12, %r11
    5868: 49 89 df                     	movq	%rbx, %r15
    586b: 49 c1 c7 32                  	rolq	$0x32, %r15
    586f: 4d 01 f3                     	addq	%r14, %r11
    5872: 49 89 de                     	movq	%rbx, %r14
    5875: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5879: 4d 31 fe                     	xorq	%r15, %r14
    587c: 49 89 df                     	movq	%rbx, %r15
    587f: 49 c1 c7 17                  	rolq	$0x17, %r15
    5883: 4d 31 f7                     	xorq	%r14, %r15
    5886: 4d 89 d6                     	movq	%r10, %r14
    5889: 49 31 ce                     	xorq	%rcx, %r14
    588c: 49 21 de                     	andq	%rbx, %r14
    588f: 49 31 ce                     	xorq	%rcx, %r14
    5892: 48 03 95 60 ff ff ff         	addq	-0xa0(%rbp), %rdx
    5899: 4c 01 f2                     	addq	%r14, %rdx
    589c: 49 be 1e eb e0 cd d6 7d da ea	movabsq	$-0x15258229321f14e2, %r14 ## imm = 0xEADA7DD6CDE0EB1E
    58a6: 49 01 d6                     	addq	%rdx, %r14
    58a9: 4d 01 fe                     	addq	%r15, %r14
    58ac: 4c 01 f6                     	addq	%r14, %rsi
    58af: 4c 89 da                     	movq	%r11, %rdx
    58b2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    58b6: 4d 89 df                     	movq	%r11, %r15
    58b9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    58bd: 49 31 d7                     	xorq	%rdx, %r15
    58c0: 4d 89 dc                     	movq	%r11, %r12
    58c3: 49 c1 c4 19                  	rolq	$0x19, %r12
    58c7: 4d 31 fc                     	xorq	%r15, %r12
    58ca: 4d 89 cf                     	movq	%r9, %r15
    58cd: 4d 09 c7                     	orq	%r8, %r15
    58d0: 4d 21 df                     	andq	%r11, %r15
    58d3: 4c 89 ca                     	movq	%r9, %rdx
    58d6: 4c 21 c2                     	andq	%r8, %rdx
    58d9: 4c 09 fa                     	orq	%r15, %rdx
    58dc: 49 89 f7                     	movq	%rsi, %r15
    58df: 49 c1 c7 32                  	rolq	$0x32, %r15
    58e3: 4c 01 e2                     	addq	%r12, %rdx
    58e6: 49 89 f4                     	movq	%rsi, %r12
    58e9: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    58ed: 4c 01 f2                     	addq	%r14, %rdx
    58f0: 49 89 f6                     	movq	%rsi, %r14
    58f3: 49 c1 c6 17                  	rolq	$0x17, %r14
    58f7: 4d 31 fc                     	xorq	%r15, %r12
    58fa: 4d 31 e6                     	xorq	%r12, %r14
    58fd: 49 89 df                     	movq	%rbx, %r15
    5900: 4d 31 d7                     	xorq	%r10, %r15
    5903: 49 21 f7                     	andq	%rsi, %r15
    5906: 4d 31 d7                     	xorq	%r10, %r15
    5909: 48 03 8d 68 ff ff ff         	addq	-0x98(%rbp), %rcx
    5910: 4c 01 f9                     	addq	%r15, %rcx
    5913: 49 bf 78 d1 6e ee 7f 4f 7d f5	movabsq	$-0xa82b08011912e88, %r15 ## imm = 0xF57D4F7FEE6ED178
    591d: 49 01 cf                     	addq	%rcx, %r15
    5920: 4d 01 f7                     	addq	%r14, %r15
    5923: 4d 01 f8                     	addq	%r15, %r8
    5926: 48 89 d1                     	movq	%rdx, %rcx
    5929: 48 c1 c1 24                  	rolq	$0x24, %rcx
    592d: 49 89 d6                     	movq	%rdx, %r14
    5930: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5934: 49 31 ce                     	xorq	%rcx, %r14
    5937: 49 89 d4                     	movq	%rdx, %r12
    593a: 49 c1 c4 19                  	rolq	$0x19, %r12
    593e: 4d 31 f4                     	xorq	%r14, %r12
    5941: 4d 89 de                     	movq	%r11, %r14
    5944: 4d 09 ce                     	orq	%r9, %r14
    5947: 49 21 d6                     	andq	%rdx, %r14
    594a: 4c 89 d9                     	movq	%r11, %rcx
    594d: 4c 21 c9                     	andq	%r9, %rcx
    5950: 4c 09 f1                     	orq	%r14, %rcx
    5953: 4c 01 e1                     	addq	%r12, %rcx
    5956: 4c 01 f9                     	addq	%r15, %rcx
    5959: 4d 89 c6                     	movq	%r8, %r14
    595c: 49 c1 c6 32                  	rolq	$0x32, %r14
    5960: 4d 89 c7                     	movq	%r8, %r15
    5963: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5967: 4d 31 f7                     	xorq	%r14, %r15
    596a: 4d 89 c4                     	movq	%r8, %r12
    596d: 49 c1 c4 17                  	rolq	$0x17, %r12
    5971: 4d 31 fc                     	xorq	%r15, %r12
    5974: 49 89 f6                     	movq	%rsi, %r14
    5977: 49 31 de                     	xorq	%rbx, %r14
    597a: 4d 21 c6                     	andq	%r8, %r14
    597d: 4c 03 95 70 ff ff ff         	addq	-0x90(%rbp), %r10
    5984: 49 31 de                     	xorq	%rbx, %r14
    5987: 4d 01 f2                     	addq	%r14, %r10
    598a: 49 be ba 6f 17 72 aa 67 f0 06	movabsq	$0x6f067aa72176fba, %r14 ## imm = 0x6F067AA72176FBA
    5994: 4d 01 d6                     	addq	%r10, %r14
    5997: 4d 01 e6                     	addq	%r12, %r14
    599a: 49 89 ca                     	movq	%rcx, %r10
    599d: 49 c1 c2 24                  	rolq	$0x24, %r10
    59a1: 4d 01 f1                     	addq	%r14, %r9
    59a4: 49 89 cf                     	movq	%rcx, %r15
    59a7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    59ab: 4d 31 d7                     	xorq	%r10, %r15
    59ae: 49 89 cc                     	movq	%rcx, %r12
    59b1: 49 c1 c4 19                  	rolq	$0x19, %r12
    59b5: 4d 31 fc                     	xorq	%r15, %r12
    59b8: 49 89 d7                     	movq	%rdx, %r15
    59bb: 4d 09 df                     	orq	%r11, %r15
    59be: 49 21 cf                     	andq	%rcx, %r15
    59c1: 49 89 d2                     	movq	%rdx, %r10
    59c4: 4d 21 da                     	andq	%r11, %r10
    59c7: 4d 09 fa                     	orq	%r15, %r10
    59ca: 4d 01 e2                     	addq	%r12, %r10
    59cd: 4d 01 f2                     	addq	%r14, %r10
    59d0: 4d 89 ce                     	movq	%r9, %r14
    59d3: 49 c1 c6 32                  	rolq	$0x32, %r14
    59d7: 4d 89 cf                     	movq	%r9, %r15
    59da: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    59de: 4d 31 f7                     	xorq	%r14, %r15
    59e1: 4d 89 cc                     	movq	%r9, %r12
    59e4: 49 c1 c4 17                  	rolq	$0x17, %r12
    59e8: 4d 31 fc                     	xorq	%r15, %r12
    59eb: 4d 89 c6                     	movq	%r8, %r14
    59ee: 49 31 f6                     	xorq	%rsi, %r14
    59f1: 4d 21 ce                     	andq	%r9, %r14
    59f4: 49 31 f6                     	xorq	%rsi, %r14
    59f7: 48 03 9d 78 ff ff ff         	addq	-0x88(%rbp), %rbx
    59fe: 4c 01 f3                     	addq	%r14, %rbx
    5a01: 49 be a6 98 c8 a2 c5 7d 63 0a	movabsq	$0xa637dc5a2c898a6, %r14 ## imm = 0xA637DC5A2C898A6
    5a0b: 49 01 de                     	addq	%rbx, %r14
    5a0e: 4c 89 d3                     	movq	%r10, %rbx
    5a11: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5a15: 4d 01 e6                     	addq	%r12, %r14
    5a18: 4d 89 d7                     	movq	%r10, %r15
    5a1b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5a1f: 4d 01 f3                     	addq	%r14, %r11
    5a22: 4d 89 d4                     	movq	%r10, %r12
    5a25: 49 c1 c4 19                  	rolq	$0x19, %r12
    5a29: 49 31 df                     	xorq	%rbx, %r15
    5a2c: 4d 31 fc                     	xorq	%r15, %r12
    5a2f: 49 89 cf                     	movq	%rcx, %r15
    5a32: 49 09 d7                     	orq	%rdx, %r15
    5a35: 4d 21 d7                     	andq	%r10, %r15
    5a38: 48 89 cb                     	movq	%rcx, %rbx
    5a3b: 48 21 d3                     	andq	%rdx, %rbx
    5a3e: 4c 09 fb                     	orq	%r15, %rbx
    5a41: 4c 01 e3                     	addq	%r12, %rbx
    5a44: 4d 89 df                     	movq	%r11, %r15
    5a47: 49 c1 c7 32                  	rolq	$0x32, %r15
    5a4b: 4c 01 f3                     	addq	%r14, %rbx
    5a4e: 4d 89 de                     	movq	%r11, %r14
    5a51: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5a55: 4d 31 fe                     	xorq	%r15, %r14
    5a58: 4d 89 df                     	movq	%r11, %r15
    5a5b: 49 c1 c7 17                  	rolq	$0x17, %r15
    5a5f: 4d 31 f7                     	xorq	%r14, %r15
    5a62: 4d 89 ce                     	movq	%r9, %r14
    5a65: 4d 31 c6                     	xorq	%r8, %r14
    5a68: 4d 21 de                     	andq	%r11, %r14
    5a6b: 4d 31 c6                     	xorq	%r8, %r14
    5a6e: 48 03 75 80                  	addq	-0x80(%rbp), %rsi
    5a72: 4c 01 f6                     	addq	%r14, %rsi
    5a75: 49 be ae 0d f9 be 04 98 3f 11	movabsq	$0x113f9804bef90dae, %r14 ## imm = 0x113F9804BEF90DAE
    5a7f: 49 01 f6                     	addq	%rsi, %r14
    5a82: 4d 01 fe                     	addq	%r15, %r14
    5a85: 4c 01 f2                     	addq	%r14, %rdx
    5a88: 48 89 de                     	movq	%rbx, %rsi
    5a8b: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5a8f: 49 89 df                     	movq	%rbx, %r15
    5a92: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5a96: 49 31 f7                     	xorq	%rsi, %r15
    5a99: 49 89 dc                     	movq	%rbx, %r12
    5a9c: 49 c1 c4 19                  	rolq	$0x19, %r12
    5aa0: 4d 31 fc                     	xorq	%r15, %r12
    5aa3: 4d 89 d7                     	movq	%r10, %r15
    5aa6: 49 09 cf                     	orq	%rcx, %r15
    5aa9: 49 21 df                     	andq	%rbx, %r15
    5aac: 4c 89 d6                     	movq	%r10, %rsi
    5aaf: 48 21 ce                     	andq	%rcx, %rsi
    5ab2: 4c 09 fe                     	orq	%r15, %rsi
    5ab5: 49 89 d7                     	movq	%rdx, %r15
    5ab8: 49 c1 c7 32                  	rolq	$0x32, %r15
    5abc: 4c 01 e6                     	addq	%r12, %rsi
    5abf: 49 89 d4                     	movq	%rdx, %r12
    5ac2: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5ac6: 4c 01 f6                     	addq	%r14, %rsi
    5ac9: 49 89 d6                     	movq	%rdx, %r14
    5acc: 49 c1 c6 17                  	rolq	$0x17, %r14
    5ad0: 4d 31 fc                     	xorq	%r15, %r12
    5ad3: 4d 31 e6                     	xorq	%r12, %r14
    5ad6: 4d 89 df                     	movq	%r11, %r15
    5ad9: 4d 31 cf                     	xorq	%r9, %r15
    5adc: 49 21 d7                     	andq	%rdx, %r15
    5adf: 4d 31 cf                     	xorq	%r9, %r15
    5ae2: 4c 03 45 88                  	addq	-0x78(%rbp), %r8
    5ae6: 4d 01 f8                     	addq	%r15, %r8
    5ae9: 49 bf 1b 47 1c 13 35 0b 71 1b	movabsq	$0x1b710b35131c471b, %r15 ## imm = 0x1B710B35131C471B
    5af3: 4d 01 c7                     	addq	%r8, %r15
    5af6: 4d 01 f7                     	addq	%r14, %r15
    5af9: 4c 01 f9                     	addq	%r15, %rcx
    5afc: 49 89 f0                     	movq	%rsi, %r8
    5aff: 49 c1 c0 24                  	rolq	$0x24, %r8
    5b03: 49 89 f6                     	movq	%rsi, %r14
    5b06: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5b0a: 4d 31 c6                     	xorq	%r8, %r14
    5b0d: 49 89 f4                     	movq	%rsi, %r12
    5b10: 49 c1 c4 19                  	rolq	$0x19, %r12
    5b14: 4d 31 f4                     	xorq	%r14, %r12
    5b17: 49 89 de                     	movq	%rbx, %r14
    5b1a: 4d 09 d6                     	orq	%r10, %r14
    5b1d: 49 21 f6                     	andq	%rsi, %r14
    5b20: 49 89 d8                     	movq	%rbx, %r8
    5b23: 4d 21 d0                     	andq	%r10, %r8
    5b26: 4d 09 f0                     	orq	%r14, %r8
    5b29: 4d 01 e0                     	addq	%r12, %r8
    5b2c: 4d 01 f8                     	addq	%r15, %r8
    5b2f: 49 89 ce                     	movq	%rcx, %r14
    5b32: 49 c1 c6 32                  	rolq	$0x32, %r14
    5b36: 49 89 cf                     	movq	%rcx, %r15
    5b39: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5b3d: 4d 31 f7                     	xorq	%r14, %r15
    5b40: 49 89 cc                     	movq	%rcx, %r12
    5b43: 49 c1 c4 17                  	rolq	$0x17, %r12
    5b47: 4d 31 fc                     	xorq	%r15, %r12
    5b4a: 49 89 d6                     	movq	%rdx, %r14
    5b4d: 4d 31 de                     	xorq	%r11, %r14
    5b50: 49 21 ce                     	andq	%rcx, %r14
    5b53: 4c 03 4d 90                  	addq	-0x70(%rbp), %r9
    5b57: 4d 31 de                     	xorq	%r11, %r14
    5b5a: 4d 01 f1                     	addq	%r14, %r9
    5b5d: 49 be 84 7d 04 23 f5 77 db 28	movabsq	$0x28db77f523047d84, %r14 ## imm = 0x28DB77F523047D84
    5b67: 4d 01 ce                     	addq	%r9, %r14
    5b6a: 4d 01 e6                     	addq	%r12, %r14
    5b6d: 4d 89 c1                     	movq	%r8, %r9
    5b70: 49 c1 c1 24                  	rolq	$0x24, %r9
    5b74: 4d 01 f2                     	addq	%r14, %r10
    5b77: 4d 89 c7                     	movq	%r8, %r15
    5b7a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5b7e: 4d 31 cf                     	xorq	%r9, %r15
    5b81: 4d 89 c4                     	movq	%r8, %r12
    5b84: 49 c1 c4 19                  	rolq	$0x19, %r12
    5b88: 4d 31 fc                     	xorq	%r15, %r12
    5b8b: 49 89 f7                     	movq	%rsi, %r15
    5b8e: 49 09 df                     	orq	%rbx, %r15
    5b91: 4d 21 c7                     	andq	%r8, %r15
    5b94: 49 89 f1                     	movq	%rsi, %r9
    5b97: 49 21 d9                     	andq	%rbx, %r9
    5b9a: 4d 09 f9                     	orq	%r15, %r9
    5b9d: 4d 01 e1                     	addq	%r12, %r9
    5ba0: 4d 01 f1                     	addq	%r14, %r9
    5ba3: 4d 89 d6                     	movq	%r10, %r14
    5ba6: 49 c1 c6 32                  	rolq	$0x32, %r14
    5baa: 4d 89 d7                     	movq	%r10, %r15
    5bad: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5bb1: 4d 31 f7                     	xorq	%r14, %r15
    5bb4: 4d 89 d4                     	movq	%r10, %r12
    5bb7: 49 c1 c4 17                  	rolq	$0x17, %r12
    5bbb: 4d 31 fc                     	xorq	%r15, %r12
    5bbe: 49 89 ce                     	movq	%rcx, %r14
    5bc1: 49 31 d6                     	xorq	%rdx, %r14
    5bc4: 4d 21 d6                     	andq	%r10, %r14
    5bc7: 49 31 d6                     	xorq	%rdx, %r14
    5bca: 4c 03 5d 98                  	addq	-0x68(%rbp), %r11
    5bce: 4d 01 f3                     	addq	%r14, %r11
    5bd1: 49 be 93 24 c7 40 7b ab ca 32	movabsq	$0x32caab7b40c72493, %r14 ## imm = 0x32CAAB7B40C72493
    5bdb: 4d 01 de                     	addq	%r11, %r14
    5bde: 4d 89 cb                     	movq	%r9, %r11
    5be1: 49 c1 c3 24                  	rolq	$0x24, %r11
    5be5: 4d 01 e6                     	addq	%r12, %r14
    5be8: 4d 89 cf                     	movq	%r9, %r15
    5beb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5bef: 4c 01 f3                     	addq	%r14, %rbx
    5bf2: 4d 89 cc                     	movq	%r9, %r12
    5bf5: 49 c1 c4 19                  	rolq	$0x19, %r12
    5bf9: 4d 31 df                     	xorq	%r11, %r15
    5bfc: 4d 31 fc                     	xorq	%r15, %r12
    5bff: 4d 89 c7                     	movq	%r8, %r15
    5c02: 49 09 f7                     	orq	%rsi, %r15
    5c05: 4d 21 cf                     	andq	%r9, %r15
    5c08: 4d 89 c3                     	movq	%r8, %r11
    5c0b: 49 21 f3                     	andq	%rsi, %r11
    5c0e: 4d 09 fb                     	orq	%r15, %r11
    5c11: 4d 01 e3                     	addq	%r12, %r11
    5c14: 49 89 df                     	movq	%rbx, %r15
    5c17: 49 c1 c7 32                  	rolq	$0x32, %r15
    5c1b: 4d 01 f3                     	addq	%r14, %r11
    5c1e: 49 89 de                     	movq	%rbx, %r14
    5c21: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5c25: 4d 31 fe                     	xorq	%r15, %r14
    5c28: 49 89 df                     	movq	%rbx, %r15
    5c2b: 49 c1 c7 17                  	rolq	$0x17, %r15
    5c2f: 4d 31 f7                     	xorq	%r14, %r15
    5c32: 4d 89 d6                     	movq	%r10, %r14
    5c35: 49 31 ce                     	xorq	%rcx, %r14
    5c38: 49 21 de                     	andq	%rbx, %r14
    5c3b: 49 31 ce                     	xorq	%rcx, %r14
    5c3e: 48 03 55 a0                  	addq	-0x60(%rbp), %rdx
    5c42: 4c 01 f2                     	addq	%r14, %rdx
    5c45: 49 be bc be c9 15 0a be 9e 3c	movabsq	$0x3c9ebe0a15c9bebc, %r14 ## imm = 0x3C9EBE0A15C9BEBC
    5c4f: 49 01 d6                     	addq	%rdx, %r14
    5c52: 4d 01 fe                     	addq	%r15, %r14
    5c55: 4c 01 f6                     	addq	%r14, %rsi
    5c58: 4c 89 da                     	movq	%r11, %rdx
    5c5b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5c5f: 4d 89 df                     	movq	%r11, %r15
    5c62: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5c66: 49 31 d7                     	xorq	%rdx, %r15
    5c69: 4d 89 dc                     	movq	%r11, %r12
    5c6c: 49 c1 c4 19                  	rolq	$0x19, %r12
    5c70: 4d 31 fc                     	xorq	%r15, %r12
    5c73: 4d 89 cf                     	movq	%r9, %r15
    5c76: 4d 09 c7                     	orq	%r8, %r15
    5c79: 4d 21 df                     	andq	%r11, %r15
    5c7c: 4c 89 ca                     	movq	%r9, %rdx
    5c7f: 4c 21 c2                     	andq	%r8, %rdx
    5c82: 4c 09 fa                     	orq	%r15, %rdx
    5c85: 49 89 f7                     	movq	%rsi, %r15
    5c88: 49 c1 c7 32                  	rolq	$0x32, %r15
    5c8c: 4c 01 e2                     	addq	%r12, %rdx
    5c8f: 49 89 f4                     	movq	%rsi, %r12
    5c92: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5c96: 4c 01 f2                     	addq	%r14, %rdx
    5c99: 49 89 f6                     	movq	%rsi, %r14
    5c9c: 49 c1 c6 17                  	rolq	$0x17, %r14
    5ca0: 4d 31 fc                     	xorq	%r15, %r12
    5ca3: 4d 31 e6                     	xorq	%r12, %r14
    5ca6: 49 89 df                     	movq	%rbx, %r15
    5ca9: 4d 31 d7                     	xorq	%r10, %r15
    5cac: 49 21 f7                     	andq	%rsi, %r15
    5caf: 4d 31 d7                     	xorq	%r10, %r15
    5cb2: 48 03 4d a8                  	addq	-0x58(%rbp), %rcx
    5cb6: 4c 01 f9                     	addq	%r15, %rcx
    5cb9: 49 bf 4c 0d 10 9c c4 67 1d 43	movabsq	$0x431d67c49c100d4c, %r15 ## imm = 0x431D67C49C100D4C
    5cc3: 49 01 cf                     	addq	%rcx, %r15
    5cc6: 4d 01 f7                     	addq	%r14, %r15
    5cc9: 4d 01 f8                     	addq	%r15, %r8
    5ccc: 48 89 d1                     	movq	%rdx, %rcx
    5ccf: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5cd3: 49 89 d6                     	movq	%rdx, %r14
    5cd6: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5cda: 49 31 ce                     	xorq	%rcx, %r14
    5cdd: 49 89 d4                     	movq	%rdx, %r12
    5ce0: 49 c1 c4 19                  	rolq	$0x19, %r12
    5ce4: 4d 31 f4                     	xorq	%r14, %r12
    5ce7: 4d 89 de                     	movq	%r11, %r14
    5cea: 4d 09 ce                     	orq	%r9, %r14
    5ced: 49 21 d6                     	andq	%rdx, %r14
    5cf0: 4c 89 d9                     	movq	%r11, %rcx
    5cf3: 4c 21 c9                     	andq	%r9, %rcx
    5cf6: 4c 09 f1                     	orq	%r14, %rcx
    5cf9: 4c 01 e1                     	addq	%r12, %rcx
    5cfc: 4c 01 f9                     	addq	%r15, %rcx
    5cff: 4d 89 c6                     	movq	%r8, %r14
    5d02: 49 c1 c6 32                  	rolq	$0x32, %r14
    5d06: 4d 89 c7                     	movq	%r8, %r15
    5d09: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5d0d: 4d 31 f7                     	xorq	%r14, %r15
    5d10: 4d 89 c4                     	movq	%r8, %r12
    5d13: 49 c1 c4 17                  	rolq	$0x17, %r12
    5d17: 4d 31 fc                     	xorq	%r15, %r12
    5d1a: 49 89 f6                     	movq	%rsi, %r14
    5d1d: 49 31 de                     	xorq	%rbx, %r14
    5d20: 4d 21 c6                     	andq	%r8, %r14
    5d23: 4c 03 55 b0                  	addq	-0x50(%rbp), %r10
    5d27: 49 31 de                     	xorq	%rbx, %r14
    5d2a: 4d 01 f2                     	addq	%r14, %r10
    5d2d: 49 be b6 42 3e cb be d4 c5 4c	movabsq	$0x4cc5d4becb3e42b6, %r14 ## imm = 0x4CC5D4BECB3E42B6
    5d37: 4d 01 d6                     	addq	%r10, %r14
    5d3a: 4d 01 e6                     	addq	%r12, %r14
    5d3d: 49 89 ca                     	movq	%rcx, %r10
    5d40: 49 c1 c2 24                  	rolq	$0x24, %r10
    5d44: 4d 01 f1                     	addq	%r14, %r9
    5d47: 49 89 cf                     	movq	%rcx, %r15
    5d4a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5d4e: 4d 31 d7                     	xorq	%r10, %r15
    5d51: 49 89 cc                     	movq	%rcx, %r12
    5d54: 49 c1 c4 19                  	rolq	$0x19, %r12
    5d58: 4d 31 fc                     	xorq	%r15, %r12
    5d5b: 49 89 d7                     	movq	%rdx, %r15
    5d5e: 4d 09 df                     	orq	%r11, %r15
    5d61: 49 21 cf                     	andq	%rcx, %r15
    5d64: 49 89 d2                     	movq	%rdx, %r10
    5d67: 4d 21 da                     	andq	%r11, %r10
    5d6a: 4d 09 fa                     	orq	%r15, %r10
    5d6d: 4d 01 e2                     	addq	%r12, %r10
    5d70: 4d 01 f2                     	addq	%r14, %r10
    5d73: 4d 89 ce                     	movq	%r9, %r14
    5d76: 49 c1 c6 32                  	rolq	$0x32, %r14
    5d7a: 4d 89 cf                     	movq	%r9, %r15
    5d7d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5d81: 4d 31 f7                     	xorq	%r14, %r15
    5d84: 4d 89 cc                     	movq	%r9, %r12
    5d87: 49 c1 c4 17                  	rolq	$0x17, %r12
    5d8b: 4d 31 fc                     	xorq	%r15, %r12
    5d8e: 4d 89 c6                     	movq	%r8, %r14
    5d91: 49 31 f6                     	xorq	%rsi, %r14
    5d94: 4d 21 ce                     	andq	%r9, %r14
    5d97: 49 31 f6                     	xorq	%rsi, %r14
    5d9a: 48 03 5d b8                  	addq	-0x48(%rbp), %rbx
    5d9e: 4c 01 f3                     	addq	%r14, %rbx
    5da1: 49 be 2a 7e 65 fc 9c 29 7f 59	movabsq	$0x597f299cfc657e2a, %r14 ## imm = 0x597F299CFC657E2A
    5dab: 49 01 de                     	addq	%rbx, %r14
    5dae: 4c 89 d3                     	movq	%r10, %rbx
    5db1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5db5: 4d 01 e6                     	addq	%r12, %r14
    5db8: 4d 89 d7                     	movq	%r10, %r15
    5dbb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5dbf: 4d 01 f3                     	addq	%r14, %r11
    5dc2: 4d 89 d4                     	movq	%r10, %r12
    5dc5: 49 c1 c4 19                  	rolq	$0x19, %r12
    5dc9: 49 31 df                     	xorq	%rbx, %r15
    5dcc: 4d 31 fc                     	xorq	%r15, %r12
    5dcf: 49 89 cf                     	movq	%rcx, %r15
    5dd2: 49 09 d7                     	orq	%rdx, %r15
    5dd5: 4d 21 d7                     	andq	%r10, %r15
    5dd8: 48 89 cb                     	movq	%rcx, %rbx
    5ddb: 48 21 d3                     	andq	%rdx, %rbx
    5dde: 4c 09 fb                     	orq	%r15, %rbx
    5de1: 4c 01 e3                     	addq	%r12, %rbx
    5de4: 4d 89 df                     	movq	%r11, %r15
    5de7: 49 c1 c7 32                  	rolq	$0x32, %r15
    5deb: 4c 01 f3                     	addq	%r14, %rbx
    5dee: 4d 89 de                     	movq	%r11, %r14
    5df1: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5df5: 4d 31 fe                     	xorq	%r15, %r14
    5df8: 4d 89 df                     	movq	%r11, %r15
    5dfb: 49 c1 c7 17                  	rolq	$0x17, %r15
    5dff: 4d 31 f7                     	xorq	%r14, %r15
    5e02: 4d 89 ce                     	movq	%r9, %r14
    5e05: 4d 31 c6                     	xorq	%r8, %r14
    5e08: 4d 21 de                     	andq	%r11, %r14
    5e0b: 4d 31 c6                     	xorq	%r8, %r14
    5e0e: 48 03 75 c0                  	addq	-0x40(%rbp), %rsi
    5e12: 4c 01 f6                     	addq	%r14, %rsi
    5e15: 49 be ec fa d6 3a ab 6f cb 5f	movabsq	$0x5fcb6fab3ad6faec, %r14 ## imm = 0x5FCB6FAB3AD6FAEC
    5e1f: 49 01 f6                     	addq	%rsi, %r14
    5e22: 4d 01 fe                     	addq	%r15, %r14
    5e25: 4c 01 f2                     	addq	%r14, %rdx
    5e28: 48 89 de                     	movq	%rbx, %rsi
    5e2b: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5e2f: 49 89 df                     	movq	%rbx, %r15
    5e32: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5e36: 49 31 f7                     	xorq	%rsi, %r15
    5e39: 49 89 dc                     	movq	%rbx, %r12
    5e3c: 49 c1 c4 19                  	rolq	$0x19, %r12
    5e40: 4d 31 fc                     	xorq	%r15, %r12
    5e43: 4d 89 d7                     	movq	%r10, %r15
    5e46: 49 09 cf                     	orq	%rcx, %r15
    5e49: 49 21 df                     	andq	%rbx, %r15
    5e4c: 4c 89 d6                     	movq	%r10, %rsi
    5e4f: 48 21 ce                     	andq	%rcx, %rsi
    5e52: 4c 09 fe                     	orq	%r15, %rsi
    5e55: 49 89 d7                     	movq	%rdx, %r15
    5e58: 49 c1 c7 32                  	rolq	$0x32, %r15
    5e5c: 4c 01 e6                     	addq	%r12, %rsi
    5e5f: 49 89 d4                     	movq	%rdx, %r12
    5e62: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5e66: 4c 01 f6                     	addq	%r14, %rsi
    5e69: 49 89 d5                     	movq	%rdx, %r13
    5e6c: 49 c1 c5 17                  	rolq	$0x17, %r13
    5e70: 4d 31 fc                     	xorq	%r15, %r12
    5e73: 4d 31 e5                     	xorq	%r12, %r13
    5e76: 4d 89 de                     	movq	%r11, %r14
    5e79: 4d 31 ce                     	xorq	%r9, %r14
    5e7c: 49 21 d6                     	andq	%rdx, %r14
    5e7f: 4d 31 ce                     	xorq	%r9, %r14
    5e82: 4c 03 45 c8                  	addq	-0x38(%rbp), %r8
    5e86: 4d 01 f0                     	addq	%r14, %r8
    5e89: 49 be 17 58 47 4a 8c 19 44 6c	movabsq	$0x6c44198c4a475817, %r14 ## imm = 0x6C44198C4A475817
    5e93: 4d 01 c6                     	addq	%r8, %r14
    5e96: 4d 01 ee                     	addq	%r13, %r14
    5e99: 49 89 f0                     	movq	%rsi, %r8
    5e9c: 49 c1 c0 24                  	rolq	$0x24, %r8
    5ea0: 49 89 f7                     	movq	%rsi, %r15
    5ea3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5ea7: 4d 31 c7                     	xorq	%r8, %r15
    5eaa: 49 89 f0                     	movq	%rsi, %r8
    5ead: 49 c1 c0 19                  	rolq	$0x19, %r8
    5eb1: 4d 31 f8                     	xorq	%r15, %r8
    5eb4: 49 89 df                     	movq	%rbx, %r15
    5eb7: 4d 09 d7                     	orq	%r10, %r15
    5eba: 49 21 f7                     	andq	%rsi, %r15
    5ebd: 49 89 dc                     	movq	%rbx, %r12
    5ec0: 4d 21 d4                     	andq	%r10, %r12
    5ec3: 4d 09 fc                     	orq	%r15, %r12
    5ec6: 4d 01 c4                     	addq	%r8, %r12
    5ec9: 4d 01 f4                     	addq	%r14, %r12
    5ecc: 49 01 c4                     	addq	%rax, %r12
    5ecf: 4c 89 67 10                  	movq	%r12, 0x10(%rdi)
    5ed3: 48 01 77 18                  	addq	%rsi, 0x18(%rdi)
    5ed7: 48 01 5f 20                  	addq	%rbx, 0x20(%rdi)
    5edb: 4c 01 57 28                  	addq	%r10, 0x28(%rdi)
    5edf: 4c 01 f1                     	addq	%r14, %rcx
    5ee2: 48 01 4f 30                  	addq	%rcx, 0x30(%rdi)
    5ee6: 48 01 57 38                  	addq	%rdx, 0x38(%rdi)
    5eea: 4c 01 5f 40                  	addq	%r11, 0x40(%rdi)
    5eee: 4c 01 4f 48                  	addq	%r9, 0x48(%rdi)
    5ef2: 48 81 c4 08 02 00 00         	addq	$0x208, %rsp            ## imm = 0x208
    5ef9: 5b                           	popq	%rbx
    5efa: 41 5c                        	popq	%r12
    5efc: 41 5d                        	popq	%r13
    5efe: 41 5e                        	popq	%r14
    5f00: 41 5f                        	popq	%r15
    5f02: 5d                           	popq	%rbp
    5f03: c3                           	retq
    5f04: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    5f0e: 66 90                        	nop

0000000000005f10 <_audit_master384>:
    5f10: 55                           	pushq	%rbp
    5f11: 48 89 e5                     	movq	%rsp, %rbp
    5f14: 41 56                        	pushq	%r14
    5f16: 53                           	pushq	%rbx
    5f17: 48 81 ec 70 01 00 00         	subq	$0x170, %rsp            ## imm = 0x170
    5f1e: 48 89 f3                     	movq	%rsi, %rbx
    5f21: 49 89 f8                     	movq	%rdi, %r8
    5f24: 66 c7 85 b0 fe ff ff 00 30   	movw	$0x3000, -0x150(%rbp)   ## imm = 0x3000
    5f2d: c6 85 b2 fe ff ff 0d         	movb	$0xd, -0x14e(%rbp)
    5f34: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    5f3e: 48 89 85 b3 fe ff ff         	movq	%rax, -0x14d(%rbp)
    5f45: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    5f4f: 48 89 85 b8 fe ff ff         	movq	%rax, -0x148(%rbp)
    5f56: c6 85 c0 fe ff ff 30         	movb	$0x30, -0x140(%rbp)
    5f5d: 48 b8 38 b0 60 a7 51 ac 96 38	movabsq	$0x3896ac51a760b038, %rax ## imm = 0x3896AC51A760B038
    5f67: 48 89 85 c1 fe ff ff         	movq	%rax, -0x13f(%rbp)
    5f6e: 48 b8 4c d9 32 7e b1 b1 e3 6a	movabsq	$0x6ae3b1b17e32d94c, %rax ## imm = 0x6AE3B1B17E32D94C
    5f78: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
    5f7f: 48 b8 21 fd b7 11 14 be 07 43	movabsq	$0x4307be1411b7fd21, %rax ## imm = 0x4307BE1411B7FD21
    5f89: 48 89 85 d1 fe ff ff         	movq	%rax, -0x12f(%rbp)
    5f90: 48 b8 4c 0c c7 bf 63 f6 e1 da	movabsq	$-0x251e099c4038f3b4, %rax ## imm = 0xDAE1F663BFC70C4C
    5f9a: 48 89 85 d9 fe ff ff         	movq	%rax, -0x127(%rbp)
    5fa1: 48 b8 27 4e de bf e7 6f 65 fb	movabsq	$-0x49a90184021b1d9, %rax ## imm = 0xFB656FE7BFDE4E27
    5fab: 48 89 85 e1 fe ff ff         	movq	%rax, -0x11f(%rbp)
    5fb2: 48 b8 d5 1a d2 f1 48 98 b9 5b	movabsq	$0x5bb99848f1d21ad5, %rax ## imm = 0x5BB99848F1D21AD5
    5fbc: 48 89 85 e9 fe ff ff         	movq	%rax, -0x117(%rbp)
    5fc3: 4c 8d b5 80 fe ff ff         	leaq	-0x180(%rbp), %r14
    5fca: 48 8d 95 b0 fe ff ff         	leaq	-0x150(%rbp), %rdx
    5fd1: be 30 00 00 00               	movl	$0x30, %esi
    5fd6: b9 41 00 00 00               	movl	$0x41, %ecx
    5fdb: 4c 89 f7                     	movq	%r14, %rdi
    5fde: e8 00 00 00 00               	callq	 <L0>
		0000000000005fdf:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    5fe3: 48 8d 15 00 00 00 00         	leaq	, %rdx <_audit_master384+0xda>
		0000000000005fe6:  X86_64_RELOC_SIGNED	_memx.Array(48).zero
    5fea: 48 8d 7d c0                  	leaq	-0x40(%rbp), %rdi
    5fee: 4c 89 f6                     	movq	%r14, %rsi
    5ff1: e8 00 00 00 00               	callq	 <L1>
		0000000000005ff2:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
<L1>:
    5ff6: 48 8b 45 e8                  	movq	-0x18(%rbp), %rax
    5ffa: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    5ffe: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    6002: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    6006: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    600a: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    600e: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    6012: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    6016: 48 8b 45 c0                  	movq	-0x40(%rbp), %rax
    601a: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    601e: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    6022: 48 89 03                     	movq	%rax, (%rbx)
    6025: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            ## imm = 0x170
    602c: 5b                           	popq	%rbx
    602d: 41 5e                        	popq	%r14
    602f: 5d                           	popq	%rbp
    6030: c3                           	retq
    6031: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    603b: 0f 1f 44 00 00               	nopl	(%rax,%rax)

0000000000006040 <_audit_key384>:
    6040: 55                           	pushq	%rbp
    6041: 48 89 e5                     	movq	%rsp, %rbp
    6044: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            ## imm = 0x110
    604b: 48 89 f0                     	movq	%rsi, %rax
    604e: 49 89 f8                     	movq	%rdi, %r8
    6051: 66 c7 85 f4 fe ff ff 00 20   	movw	$0x2000, -0x10c(%rbp)   ## imm = 0x2000
    605a: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    6061: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx ## imm = 0x656B203331736C74
    606b: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    6072: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    607b: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    6082: be 20 00 00 00               	movl	$0x20, %esi
    6087: b9 0d 00 00 00               	movl	$0xd, %ecx
    608c: 48 89 c7                     	movq	%rax, %rdi
    608f: e8 00 00 00 00               	callq	 <L0>
		0000000000006090:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    6094: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            ## imm = 0x110
    609b: 5d                           	popq	%rbp
    609c: c3                           	retq
