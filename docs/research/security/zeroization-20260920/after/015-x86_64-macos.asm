
/tmp/ztls-signoff-20260919/125-after-direct-buffers/015-x86_64-macos.o:	file format mach-o 64-bit x86-64

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
      19: 66 c7 85 90 fe ff ff 00 20   	movw	$0x2000, -0x170(%rbp)   ## imm = 0x2000
      22: c6 85 92 fe ff ff 0d         	movb	$0xd, -0x16e(%rbp)
      29: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
      33: 48 89 85 93 fe ff ff         	movq	%rax, -0x16d(%rbp)
      3a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
      44: 48 89 85 98 fe ff ff         	movq	%rax, -0x168(%rbp)
      4b: c6 85 a0 fe ff ff 20         	movb	$0x20, -0x160(%rbp)
      52: 48 b8 e3 b0 c4 42 98 fc 1c 14	movabsq	$0x141cfc9842c4b0e3, %rax ## imm = 0x141CFC9842C4B0E3
      5c: 48 89 85 a1 fe ff ff         	movq	%rax, -0x15f(%rbp)
      63: 48 b8 9a fb f4 c8 99 6f b9 24	movabsq	$0x24b96f99c8f4fb9a, %rax ## imm = 0x24B96F99C8F4FB9A
      6d: 48 89 85 a9 fe ff ff         	movq	%rax, -0x157(%rbp)
      74: 48 b8 27 ae 41 e4 64 9b 93 4c	movabsq	$0x4c939b64e441ae27, %rax ## imm = 0x4C939B64E441AE27
      7e: 48 89 85 b1 fe ff ff         	movq	%rax, -0x14f(%rbp)
      85: 48 b8 a4 95 99 1b 78 52 b8 55	movabsq	$0x55b852781b9995a4, %rax ## imm = 0x55B852781B9995A4
      8f: 48 89 85 b9 fe ff ff         	movq	%rax, -0x147(%rbp)
      96: 4c 8d 7d a0                  	leaq	-0x60(%rbp), %r15
      9a: 48 8d 95 90 fe ff ff         	leaq	-0x170(%rbp), %rdx
      a1: be 20 00 00 00               	movl	$0x20, %esi
      a6: b9 31 00 00 00               	movl	$0x31, %ecx
      ab: 4c 89 ff                     	movq	%r15, %rdi
      ae: e8 00 00 00 00               	callq	 <L0>
		00000000000000af:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
      b3: 48 8d 7d c8                  	leaq	-0x38(%rbp), %rdi
      b7: 4c 89 fe                     	movq	%r15, %rsi
      ba: 4c 89 f2                     	movq	%r14, %rdx
      bd: e8 00 00 00 00               	callq	 <L1>
		00000000000000be:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
<L1>:
      c2: 0f 57 c0                     	xorps	%xmm0, %xmm0
      c5: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
      c9: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
      cd: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
      d1: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
      d5: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
      d9: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
      dd: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
      e1: 48 8b 4d d0                  	movq	-0x30(%rbp), %rcx
      e5: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
      e9: 48 89 03                     	movq	%rax, (%rbx)
      ec: 48 81 c4 58 01 00 00         	addq	$0x158, %rsp            ## imm = 0x158
      f3: 5b                           	popq	%rbx
      f4: 41 5e                        	popq	%r14
      f6: 41 5f                        	popq	%r15
      f8: 5d                           	popq	%rbp
      f9: c3                           	retq
      fa: 66 0f 1f 44 00 00            	nopw	(%rax,%rax)

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
     122: 0f 28 15 87 5f 00 00         	movaps	, %xmm2 <_audit_key384+0x60>
		0000000000000125:  X86_64_RELOC_SIGNED	__literal16
     129: 0f 28 d8                     	movaps	%xmm0, %xmm3
     12c: 0f 57 da                     	xorps	%xmm2, %xmm3
     12f: 0f 28 e1                     	movaps	%xmm1, %xmm4
     132: 0f 57 e2                     	xorps	%xmm2, %xmm4
     135: 0f 29 9d 00 ff ff ff         	movaps	%xmm3, -0x100(%rbp)
     13c: 0f 29 a5 10 ff ff ff         	movaps	%xmm4, -0xf0(%rbp)
     143: 0f 29 95 20 ff ff ff         	movaps	%xmm2, -0xe0(%rbp)
     14a: 0f 29 95 30 ff ff ff         	movaps	%xmm2, -0xd0(%rbp)
     151: 0f 28 15 68 5f 00 00         	movaps	, %xmm2 <_audit_key384+0x70>
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
     452: 0f 28 15 77 5c 00 00         	movaps	, %xmm2 <_audit_key384+0x80>
		0000000000000455:  X86_64_RELOC_SIGNED	__literal16
     459: 0f 28 d8                     	movaps	%xmm0, %xmm3
     45c: 0f 57 da                     	xorps	%xmm2, %xmm3
     45f: 0f 28 e1                     	movaps	%xmm1, %xmm4
     462: 0f 57 e2                     	xorps	%xmm2, %xmm4
     465: 0f 29 9d 20 fe ff ff         	movaps	%xmm3, -0x1e0(%rbp)
     46c: 0f 29 a5 30 fe ff ff         	movaps	%xmm4, -0x1d0(%rbp)
     473: 0f 29 95 40 fe ff ff         	movaps	%xmm2, -0x1c0(%rbp)
     47a: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
     481: 0f 28 15 58 5c 00 00         	movaps	, %xmm2 <_audit_key384+0x90>
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
     7b6: 0f 28 05 13 59 00 00         	movaps	, %xmm0 <_audit_key384+0x80>
		00000000000007b9:  X86_64_RELOC_SIGNED	__literal16
     7bd: 0f 28 cb                     	movaps	%xmm3, %xmm1
     7c0: 0f 57 c8                     	xorps	%xmm0, %xmm1
     7c3: 0f 28 d4                     	movaps	%xmm4, %xmm2
     7c6: 0f 57 d0                     	xorps	%xmm0, %xmm2
     7c9: 0f 29 8d f0 fe ff ff         	movaps	%xmm1, -0x110(%rbp)
     7d0: 0f 29 95 00 ff ff ff         	movaps	%xmm2, -0x100(%rbp)
     7d7: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
     7de: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
     7e5: 0f 28 05 f4 58 00 00         	movaps	, %xmm0 <_audit_key384+0x90>
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
     cf6: 66 0f 6f 05 f2 53 00 00      	movdqa	, %xmm0 <_audit_key384+0xa0>
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
    27c4: 66 c7 85 a0 fe ff ff 00 20   	movw	$0x2000, -0x160(%rbp)   ## imm = 0x2000
    27cd: c6 85 a2 fe ff ff 0d         	movb	$0xd, -0x15e(%rbp)
    27d4: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    27de: 48 89 85 a3 fe ff ff         	movq	%rax, -0x15d(%rbp)
    27e5: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    27ef: 48 89 85 a8 fe ff ff         	movq	%rax, -0x158(%rbp)
    27f6: c6 85 b0 fe ff ff 20         	movb	$0x20, -0x150(%rbp)
    27fd: 48 b8 e3 b0 c4 42 98 fc 1c 14	movabsq	$0x141cfc9842c4b0e3, %rax ## imm = 0x141CFC9842C4B0E3
    2807: 48 89 85 b1 fe ff ff         	movq	%rax, -0x14f(%rbp)
    280e: 48 b8 9a fb f4 c8 99 6f b9 24	movabsq	$0x24b96f99c8f4fb9a, %rax ## imm = 0x24B96F99C8F4FB9A
    2818: 48 89 85 b9 fe ff ff         	movq	%rax, -0x147(%rbp)
    281f: 48 b8 27 ae 41 e4 64 9b 93 4c	movabsq	$0x4c939b64e441ae27, %rax ## imm = 0x4C939B64E441AE27
    2829: 48 89 85 c1 fe ff ff         	movq	%rax, -0x13f(%rbp)
    2830: 48 b8 a4 95 99 1b 78 52 b8 55	movabsq	$0x55b852781b9995a4, %rax ## imm = 0x55B852781B9995A4
    283a: 48 89 85 c9 fe ff ff         	movq	%rax, -0x137(%rbp)
    2841: 4c 8d 75 b0                  	leaq	-0x50(%rbp), %r14
    2845: 48 8d 95 a0 fe ff ff         	leaq	-0x160(%rbp), %rdx
    284c: be 20 00 00 00               	movl	$0x20, %esi
    2851: b9 31 00 00 00               	movl	$0x31, %ecx
    2856: 4c 89 f7                     	movq	%r14, %rdi
    2859: e8 00 00 00 00               	callq	 <L0>
		000000000000285a:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    285e: 48 8d 15 00 00 00 00         	leaq	, %rdx <_audit_master256+0xb5>
		0000000000002861:  X86_64_RELOC_SIGNED	_memx.Array(32).zero
    2865: 48 8d 7d d0                  	leaq	-0x30(%rbp), %rdi
    2869: 4c 89 f6                     	movq	%r14, %rsi
    286c: e8 00 00 00 00               	callq	 <L1>
		000000000000286d:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).extract
<L1>:
    2871: 0f 57 c0                     	xorps	%xmm0, %xmm0
    2874: 0f 29 45 c0                  	movaps	%xmm0, -0x40(%rbp)
    2878: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    287c: 48 8b 45 e8                  	movq	-0x18(%rbp), %rax
    2880: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    2884: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    2888: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    288c: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    2890: 48 8b 4d d8                  	movq	-0x28(%rbp), %rcx
    2894: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    2898: 48 89 03                     	movq	%rax, (%rbx)
    289b: 48 81 c4 50 01 00 00         	addq	$0x150, %rsp            ## imm = 0x150
    28a2: 5b                           	popq	%rbx
    28a3: 41 5e                        	popq	%r14
    28a5: 5d                           	popq	%rbp
    28a6: c3                           	retq
    28a7: 66 0f 1f 84 00 00 00 00 00   	nopw	(%rax,%rax)

00000000000028b0 <_audit_key256>:
    28b0: 55                           	pushq	%rbp
    28b1: 48 89 e5                     	movq	%rsp, %rbp
    28b4: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            ## imm = 0x110
    28bb: 48 89 f0                     	movq	%rsi, %rax
    28be: 49 89 f8                     	movq	%rdi, %r8
    28c1: 66 c7 85 f4 fe ff ff 00 10   	movw	$0x1000, -0x10c(%rbp)   ## imm = 0x1000
    28ca: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    28d1: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx ## imm = 0x656B203331736C74
    28db: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    28e2: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    28eb: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    28f2: be 10 00 00 00               	movl	$0x10, %esi
    28f7: b9 0d 00 00 00               	movl	$0xd, %ecx
    28fc: 48 89 c7                     	movq	%rax, %rdi
    28ff: e8 00 00 00 00               	callq	 <L0>
		0000000000002900:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x32(.{ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 },256))).expand
<L0>:
    2904: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            ## imm = 0x110
    290b: 5d                           	popq	%rbp
    290c: c3                           	retq
    290d: 0f 1f 00                     	nopl	(%rax)

0000000000002910 <_audit_handshake384>:
    2910: 55                           	pushq	%rbp
    2911: 48 89 e5                     	movq	%rsp, %rbp
    2914: 41 57                        	pushq	%r15
    2916: 41 56                        	pushq	%r14
    2918: 53                           	pushq	%rbx
    2919: 48 81 ec 78 01 00 00         	subq	$0x178, %rsp            ## imm = 0x178
    2920: 48 89 d3                     	movq	%rdx, %rbx
    2923: 49 89 f6                     	movq	%rsi, %r14
    2926: 49 89 f8                     	movq	%rdi, %r8
    2929: 66 c7 85 70 fe ff ff 00 30   	movw	$0x3000, -0x190(%rbp)   ## imm = 0x3000
    2932: c6 85 72 fe ff ff 0d         	movb	$0xd, -0x18e(%rbp)
    2939: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    2943: 48 89 85 73 fe ff ff         	movq	%rax, -0x18d(%rbp)
    294a: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    2954: 48 89 85 78 fe ff ff         	movq	%rax, -0x188(%rbp)
    295b: c6 85 80 fe ff ff 30         	movb	$0x30, -0x180(%rbp)
    2962: 48 b8 38 b0 60 a7 51 ac 96 38	movabsq	$0x3896ac51a760b038, %rax ## imm = 0x3896AC51A760B038
    296c: 48 89 85 81 fe ff ff         	movq	%rax, -0x17f(%rbp)
    2973: 48 b8 4c d9 32 7e b1 b1 e3 6a	movabsq	$0x6ae3b1b17e32d94c, %rax ## imm = 0x6AE3B1B17E32D94C
    297d: 48 89 85 89 fe ff ff         	movq	%rax, -0x177(%rbp)
    2984: 48 b8 21 fd b7 11 14 be 07 43	movabsq	$0x4307be1411b7fd21, %rax ## imm = 0x4307BE1411B7FD21
    298e: 48 89 85 91 fe ff ff         	movq	%rax, -0x16f(%rbp)
    2995: 48 b8 4c 0c c7 bf 63 f6 e1 da	movabsq	$-0x251e099c4038f3b4, %rax ## imm = 0xDAE1F663BFC70C4C
    299f: 48 89 85 99 fe ff ff         	movq	%rax, -0x167(%rbp)
    29a6: 48 b8 27 4e de bf e7 6f 65 fb	movabsq	$-0x49a90184021b1d9, %rax ## imm = 0xFB656FE7BFDE4E27
    29b0: 48 89 85 a1 fe ff ff         	movq	%rax, -0x15f(%rbp)
    29b7: 48 b8 d5 1a d2 f1 48 98 b9 5b	movabsq	$0x5bb99848f1d21ad5, %rax ## imm = 0x5BB99848F1D21AD5
    29c1: 48 89 85 a9 fe ff ff         	movq	%rax, -0x157(%rbp)
    29c8: 4c 8d 7d 80                  	leaq	-0x80(%rbp), %r15
    29cc: 48 8d 95 70 fe ff ff         	leaq	-0x190(%rbp), %rdx
    29d3: be 30 00 00 00               	movl	$0x30, %esi
    29d8: b9 41 00 00 00               	movl	$0x41, %ecx
    29dd: 4c 89 ff                     	movq	%r15, %rdi
    29e0: e8 00 00 00 00               	callq	 <L0>
		00000000000029e1:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    29e5: 48 8d 7d b8                  	leaq	-0x48(%rbp), %rdi
    29e9: 4c 89 fe                     	movq	%r15, %rsi
    29ec: 4c 89 f2                     	movq	%r14, %rdx
    29ef: e8 00 00 00 00               	callq	 <L1>
		00000000000029f0:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
<L1>:
    29f4: 0f 57 c0                     	xorps	%xmm0, %xmm0
    29f7: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
    29fb: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    29ff: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    2a03: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    2a07: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    2a0b: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    2a0f: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    2a13: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    2a17: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    2a1b: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
    2a1f: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    2a23: 48 8b 45 b8                  	movq	-0x48(%rbp), %rax
    2a27: 48 8b 4d c0                  	movq	-0x40(%rbp), %rcx
    2a2b: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    2a2f: 48 89 03                     	movq	%rax, (%rbx)
    2a32: 48 81 c4 78 01 00 00         	addq	$0x178, %rsp            ## imm = 0x178
    2a39: 5b                           	popq	%rbx
    2a3a: 41 5e                        	popq	%r14
    2a3c: 41 5f                        	popq	%r15
    2a3e: 5d                           	popq	%rbp
    2a3f: c3                           	retq

0000000000002a40 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract>:
    2a40: 55                           	pushq	%rbp
    2a41: 48 89 e5                     	movq	%rsp, %rbp
    2a44: 41 57                        	pushq	%r15
    2a46: 41 56                        	pushq	%r14
    2a48: 41 55                        	pushq	%r13
    2a4a: 41 54                        	pushq	%r12
    2a4c: 53                           	pushq	%rbx
    2a4d: 48 81 ec a8 02 00 00         	subq	$0x2a8, %rsp            ## imm = 0x2A8
    2a54: 49 89 d6                     	movq	%rdx, %r14
    2a57: 48 89 7d d0                  	movq	%rdi, -0x30(%rbp)
    2a5b: 0f 10 06                     	movups	(%rsi), %xmm0
    2a5e: 0f 10 4e 10                  	movups	0x10(%rsi), %xmm1
    2a62: 0f 10 56 20                  	movups	0x20(%rsi), %xmm2
    2a66: 0f 28 1d 93 36 00 00         	movaps	, %xmm3 <_audit_key384+0xb0>
		0000000000002a69:  X86_64_RELOC_SIGNED	__literal16
    2a6d: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2a70: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2a73: 0f 28 e9                     	movaps	%xmm1, %xmm5
    2a76: 0f 57 eb                     	xorps	%xmm3, %xmm5
    2a79: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2a80: 0f 29 ad 50 fe ff ff         	movaps	%xmm5, -0x1b0(%rbp)
    2a87: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2a8a: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2a8d: 0f 29 a5 60 fe ff ff         	movaps	%xmm4, -0x1a0(%rbp)
    2a94: 0f 29 9d 70 fe ff ff         	movaps	%xmm3, -0x190(%rbp)
    2a9b: 0f 29 9d 80 fe ff ff         	movaps	%xmm3, -0x180(%rbp)
    2aa2: 0f 29 9d 90 fe ff ff         	movaps	%xmm3, -0x170(%rbp)
    2aa9: 0f 29 9d a0 fe ff ff         	movaps	%xmm3, -0x160(%rbp)
    2ab0: 0f 29 9d b0 fe ff ff         	movaps	%xmm3, -0x150(%rbp)
    2ab7: 0f 28 1d 52 36 00 00         	movaps	, %xmm3 <_audit_key384+0xc0>
		0000000000002aba:  X86_64_RELOC_SIGNED	__literal16
    2abe: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2ac1: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2ac4: 0f 29 85 c0 fe ff ff         	movaps	%xmm0, -0x140(%rbp)
    2acb: 0f 29 8d d0 fe ff ff         	movaps	%xmm1, -0x130(%rbp)
    2ad2: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2ad5: 0f 29 95 e0 fe ff ff         	movaps	%xmm2, -0x120(%rbp)
    2adc: 0f 29 9d f0 fe ff ff         	movaps	%xmm3, -0x110(%rbp)
    2ae3: 0f 29 9d 00 ff ff ff         	movaps	%xmm3, -0x100(%rbp)
    2aea: 0f 29 9d 10 ff ff ff         	movaps	%xmm3, -0xf0(%rbp)
    2af1: 0f 29 9d 20 ff ff ff         	movaps	%xmm3, -0xe0(%rbp)
    2af8: 0f 29 9d 30 ff ff ff         	movaps	%xmm3, -0xd0(%rbp)
    2aff: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0xc6>
		0000000000002b02:  X86_64_RELOC_SIGNED	l___unnamed_2
    2b06: 4c 8d a5 60 fd ff ff         	leaq	-0x2a0(%rbp), %r12
    2b0d: ba e0 00 00 00               	movl	$0xe0, %edx
    2b12: 4c 89 e7                     	movq	%r12, %rdi
    2b15: e8 00 00 00 00               	callq	 <L0>
		0000000000002b16:  X86_64_RELOC_BRANCH	_memcpy
<L0>:
    2b1a: 48 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %rsi
    2b21: 4c 89 e7                     	movq	%r12, %rdi
    2b24: e8 00 00 00 00               	callq	 <L1>
		0000000000002b25:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L1>:
    2b29: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2b30: bb 80 00 00 00               	movl	$0x80, %ebx
    2b35: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2b3c: 49 01 df                     	addq	%rbx, %r15
    2b3f: 49 83 d4 00                  	adcq	$0x0, %r12
    2b43: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2b4a: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2b51: 0f b6 85 30 fe ff ff         	movzbl	-0x1d0(%rbp), %eax
    2b58: 48 85 c0                     	testq	%rax, %rax
    2b5b: 74 4f                        	je	 <L4>
    2b5d: 3c 50                        	cmpb	$0x50, %al
    2b5f: 72 4d                        	jb	 <L5>
    2b61: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    2b67: 49 29 c5                     	subq	%rax, %r13
    2b6a: 4c 8d a5 b0 fd ff ff         	leaq	-0x250(%rbp), %r12
    2b71: 48 8d bc 05 b0 fd ff ff      	leaq	-0x250(%rbp,%rax), %rdi
    2b79: 4c 89 f6                     	movq	%r14, %rsi
    2b7c: 4c 89 ea                     	movq	%r13, %rdx
    2b7f: e8 00 00 00 00               	callq	 <L2>
		0000000000002b80:  X86_64_RELOC_BRANCH	_memcpy
<L2>:
    2b84: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2b8b: 4c 89 e6                     	movq	%r12, %rsi
    2b8e: e8 00 00 00 00               	callq	 <L3>
		0000000000002b8f:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L3>:
    2b93: c6 85 30 fe ff ff 00         	movb	$0x0, -0x1d0(%rbp)
    2b9a: 31 c0                        	xorl	%eax, %eax
    2b9c: 4c 8b bd 60 fd ff ff         	movq	-0x2a0(%rbp), %r15
    2ba3: 4c 8b a5 68 fd ff ff         	movq	-0x298(%rbp), %r12
    2baa: eb 05                        	jmp	 <L6>
<L4>:
    2bac: 31 c0                        	xorl	%eax, %eax
<L5>:
    2bae: 45 31 ed                     	xorl	%r13d, %r13d
<L6>:
    2bb1: 4d 01 ee                     	addq	%r13, %r14
    2bb4: 4c 89 f6                     	movq	%r14, %rsi
    2bb7: 41 be 30 00 00 00            	movl	$0x30, %r14d
    2bbd: 4d 29 ee                     	subq	%r13, %r14
    2bc0: 0f b6 c0                     	movzbl	%al, %eax
    2bc3: 48 8d bc 05 b0 fd ff ff      	leaq	-0x250(%rbp,%rax), %rdi
    2bcb: 4c 89 f2                     	movq	%r14, %rdx
    2bce: e8 00 00 00 00               	callq	 <L7>
		0000000000002bcf:  X86_64_RELOC_BRANCH	_memcpy
<L7>:
    2bd3: 44 00 b5 30 fe ff ff         	addb	%r14b, -0x1d0(%rbp)
    2bda: 49 83 c7 30                  	addq	$0x30, %r15
    2bde: 49 83 d4 00                  	adcq	$0x0, %r12
    2be2: 4c 89 a5 68 fd ff ff         	movq	%r12, -0x298(%rbp)
    2be9: 4c 89 bd 60 fd ff ff         	movq	%r15, -0x2a0(%rbp)
    2bf0: 48 8d bd 60 fd ff ff         	leaq	-0x2a0(%rbp), %rdi
    2bf7: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2bfe: e8 00 00 00 00               	callq	 <L8>
		0000000000002bff:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L8>:
    2c03: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract+0x1ca>
		0000000000002c06:  X86_64_RELOC_SIGNED	l___unnamed_2
    2c0a: 4c 8d b5 c0 fe ff ff         	leaq	-0x140(%rbp), %r14
    2c11: ba e0 00 00 00               	movl	$0xe0, %edx
    2c16: 4c 89 f7                     	movq	%r14, %rdi
    2c19: e8 00 00 00 00               	callq	 <L9>
		0000000000002c1a:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
    2c1e: 4c 89 f7                     	movq	%r14, %rdi
    2c21: 48 8d b5 40 fe ff ff         	leaq	-0x1c0(%rbp), %rsi
    2c28: e8 00 00 00 00               	callq	 <L10>
		0000000000002c29:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L10>:
    2c2d: 0f b6 7d 90                  	movzbl	-0x70(%rbp), %edi
    2c31: 4c 8b a5 c8 fe ff ff         	movq	-0x138(%rbp), %r12
    2c38: 48 03 9d c0 fe ff ff         	addq	-0x140(%rbp), %rbx
    2c3f: 49 83 d4 00                  	adcq	$0x0, %r12
    2c43: 4c 8d b5 10 ff ff ff         	leaq	-0xf0(%rbp), %r14
    2c4a: 48 89 9d c0 fe ff ff         	movq	%rbx, -0x140(%rbp)
    2c51: 4c 89 a5 c8 fe ff ff         	movq	%r12, -0x138(%rbp)
    2c58: 48 85 ff                     	testq	%rdi, %rdi
    2c5b: 74 46                        	je	 <L13>
    2c5d: 40 80 ff 50                  	cmpb	$0x50, %dil
    2c61: 72 42                        	jb	 <L14>
    2c63: 41 bf 80 00 00 00            	movl	$0x80, %r15d
    2c69: 49 29 ff                     	subq	%rdi, %r15
    2c6c: 4c 01 f7                     	addq	%r14, %rdi
    2c6f: 48 8d b5 30 fd ff ff         	leaq	-0x2d0(%rbp), %rsi
    2c76: 4c 89 fa                     	movq	%r15, %rdx
    2c79: e8 00 00 00 00               	callq	 <L11>
		0000000000002c7a:  X86_64_RELOC_BRANCH	_memcpy
<L11>:
    2c7e: 48 8d bd c0 fe ff ff         	leaq	-0x140(%rbp), %rdi
    2c85: 4c 89 f6                     	movq	%r14, %rsi
    2c88: e8 00 00 00 00               	callq	 <L12>
		0000000000002c89:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L12>:
    2c8d: c6 45 90 00                  	movb	$0x0, -0x70(%rbp)
    2c91: 31 ff                        	xorl	%edi, %edi
    2c93: 48 8b 9d c0 fe ff ff         	movq	-0x140(%rbp), %rbx
    2c9a: 4c 8b a5 c8 fe ff ff         	movq	-0x138(%rbp), %r12
    2ca1: eb 05                        	jmp	 <L15>
<L13>:
    2ca3: 31 ff                        	xorl	%edi, %edi
<L14>:
    2ca5: 45 31 ff                     	xorl	%r15d, %r15d
<L15>:
    2ca8: 4a 8d b4 3d 30 fd ff ff      	leaq	-0x2d0(%rbp,%r15), %rsi
    2cb0: 41 bd 30 00 00 00            	movl	$0x30, %r13d
    2cb6: 4d 29 fd                     	subq	%r15, %r13
    2cb9: 40 0f b6 c7                  	movzbl	%dil, %eax
    2cbd: 49 01 c6                     	addq	%rax, %r14
    2cc0: 4c 89 f7                     	movq	%r14, %rdi
    2cc3: 4c 89 ea                     	movq	%r13, %rdx
    2cc6: e8 00 00 00 00               	callq	 <L16>
		0000000000002cc7:  X86_64_RELOC_BRANCH	_memcpy
<L16>:
    2ccb: 44 00 6d 90                  	addb	%r13b, -0x70(%rbp)
    2ccf: 48 83 c3 30                  	addq	$0x30, %rbx
    2cd3: 49 83 d4 00                  	adcq	$0x0, %r12
    2cd7: 4c 89 a5 c8 fe ff ff         	movq	%r12, -0x138(%rbp)
    2cde: 48 89 9d c0 fe ff ff         	movq	%rbx, -0x140(%rbp)
    2ce5: 48 8d bd c0 fe ff ff         	leaq	-0x140(%rbp), %rdi
    2cec: 48 8d 75 a0                  	leaq	-0x60(%rbp), %rsi
    2cf0: e8 00 00 00 00               	callq	 <L17>
		0000000000002cf1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L17>:
    2cf5: 48 8b 45 c8                  	movq	-0x38(%rbp), %rax
    2cf9: 48 8b 55 d0                  	movq	-0x30(%rbp), %rdx
    2cfd: 48 89 42 28                  	movq	%rax, 0x28(%rdx)
    2d01: 48 8b 45 c0                  	movq	-0x40(%rbp), %rax
    2d05: 48 89 42 20                  	movq	%rax, 0x20(%rdx)
    2d09: 48 8b 45 b8                  	movq	-0x48(%rbp), %rax
    2d0d: 48 89 42 18                  	movq	%rax, 0x18(%rdx)
    2d11: 48 8b 45 b0                  	movq	-0x50(%rbp), %rax
    2d15: 48 89 42 10                  	movq	%rax, 0x10(%rdx)
    2d19: 48 8b 45 a0                  	movq	-0x60(%rbp), %rax
    2d1d: 48 8b 4d a8                  	movq	-0x58(%rbp), %rcx
    2d21: 48 89 4a 08                  	movq	%rcx, 0x8(%rdx)
    2d25: 48 89 02                     	movq	%rax, (%rdx)
    2d28: 48 81 c4 a8 02 00 00         	addq	$0x2a8, %rsp            ## imm = 0x2A8
    2d2f: 5b                           	popq	%rbx
    2d30: 41 5c                        	popq	%r12
    2d32: 41 5d                        	popq	%r13
    2d34: 41 5e                        	popq	%r14
    2d36: 41 5f                        	popq	%r15
    2d38: 5d                           	popq	%rbp
    2d39: c3                           	retq
    2d3a: 66 0f 1f 44 00 00            	nopw	(%rax,%rax)

0000000000002d40 <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand>:
    2d40: 55                           	pushq	%rbp
    2d41: 48 89 e5                     	movq	%rsp, %rbp
    2d44: 41 57                        	pushq	%r15
    2d46: 41 56                        	pushq	%r14
    2d48: 41 55                        	pushq	%r13
    2d4a: 41 54                        	pushq	%r12
    2d4c: 53                           	pushq	%rbx
    2d4d: 48 81 ec a8 05 00 00         	subq	$0x5a8, %rsp            ## imm = 0x5A8
    2d54: 48 89 55 b8                  	movq	%rdx, -0x48(%rbp)
    2d58: 49 89 f7                     	movq	%rsi, %r15
    2d5b: 48 89 7d c8                  	movq	%rdi, -0x38(%rbp)
    2d5f: 41 0f 10 08                  	movups	(%r8), %xmm1
    2d63: 41 0f 10 50 10               	movups	0x10(%r8), %xmm2
    2d68: 41 0f 10 40 20               	movups	0x20(%r8), %xmm0
    2d6d: c6 45 d7 01                  	movb	$0x1, -0x29(%rbp)
    2d71: 48 83 fe 30                  	cmpq	$0x30, %rsi
    2d75: 48 89 4d c0                  	movq	%rcx, -0x40(%rbp)
    2d79: 0f 29 85 00 fe ff ff         	movaps	%xmm0, -0x200(%rbp)
    2d80: 0f 29 8d 10 fe ff ff         	movaps	%xmm1, -0x1f0(%rbp)
    2d87: 0f 29 95 20 fe ff ff         	movaps	%xmm2, -0x1e0(%rbp)
    2d8e: 0f 83 6f 01 00 00            	jae	 <L5>
    2d94: 48 c7 45 b0 00 00 00 00      	movq	$0x0, -0x50(%rbp)
<L0>:
    2d9c: 4c 89 f8                     	movq	%r15, %rax
    2d9f: 48 83 e8 30                  	subq	$0x30, %rax
    2da3: 49 0f 42 c7                  	cmovbq	%r15, %rax
    2da7: 48 85 c0                     	testq	%rax, %rax
    2daa: 0f 84 cc 08 00 00            	je	 <L66>
    2db0: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    2db4: 0f 28 05 65 33 00 00         	movaps	, %xmm0 <_audit_key384+0xd0>
		0000000000002db7:  X86_64_RELOC_SIGNED	__literal16
    2dbb: 0f 28 9d 10 fe ff ff         	movaps	-0x1f0(%rbp), %xmm3
    2dc2: 0f 28 cb                     	movaps	%xmm3, %xmm1
    2dc5: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2dc8: 0f 28 a5 20 fe ff ff         	movaps	-0x1e0(%rbp), %xmm4
    2dcf: 0f 28 d4                     	movaps	%xmm4, %xmm2
    2dd2: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2dd5: 0f 29 8d 20 fd ff ff         	movaps	%xmm1, -0x2e0(%rbp)
    2ddc: 0f 29 95 30 fd ff ff         	movaps	%xmm2, -0x2d0(%rbp)
    2de3: 0f 28 95 00 fe ff ff         	movaps	-0x200(%rbp), %xmm2
    2dea: 0f 28 ca                     	movaps	%xmm2, %xmm1
    2ded: 0f 57 c8                     	xorps	%xmm0, %xmm1
    2df0: 0f 29 8d 40 fd ff ff         	movaps	%xmm1, -0x2c0(%rbp)
    2df7: 0f 29 85 50 fd ff ff         	movaps	%xmm0, -0x2b0(%rbp)
    2dfe: 0f 29 85 60 fd ff ff         	movaps	%xmm0, -0x2a0(%rbp)
    2e05: 0f 29 85 70 fd ff ff         	movaps	%xmm0, -0x290(%rbp)
    2e0c: 0f 29 85 80 fd ff ff         	movaps	%xmm0, -0x280(%rbp)
    2e13: 0f 29 85 90 fd ff ff         	movaps	%xmm0, -0x270(%rbp)
    2e1a: 0f 28 05 0f 33 00 00         	movaps	, %xmm0 <_audit_key384+0xe0>
		0000000000002e1d:  X86_64_RELOC_SIGNED	__literal16
    2e21: 0f 57 d8                     	xorps	%xmm0, %xmm3
    2e24: 0f 57 e0                     	xorps	%xmm0, %xmm4
    2e27: 0f 29 9d 30 fe ff ff         	movaps	%xmm3, -0x1d0(%rbp)
    2e2e: 0f 29 a5 40 fe ff ff         	movaps	%xmm4, -0x1c0(%rbp)
    2e35: 0f 57 d0                     	xorps	%xmm0, %xmm2
    2e38: 0f 29 95 50 fe ff ff         	movaps	%xmm2, -0x1b0(%rbp)
    2e3f: 0f 29 85 60 fe ff ff         	movaps	%xmm0, -0x1a0(%rbp)
    2e46: 0f 29 85 70 fe ff ff         	movaps	%xmm0, -0x190(%rbp)
    2e4d: 0f 29 85 80 fe ff ff         	movaps	%xmm0, -0x180(%rbp)
    2e54: 0f 29 85 90 fe ff ff         	movaps	%xmm0, -0x170(%rbp)
    2e5b: 0f 29 85 a0 fe ff ff         	movaps	%xmm0, -0x160(%rbp)
    2e62: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x129>
		0000000000002e65:  X86_64_RELOC_SIGNED	l___unnamed_2
    2e69: 48 8d 9d 40 fc ff ff         	leaq	-0x3c0(%rbp), %rbx
    2e70: ba e0 00 00 00               	movl	$0xe0, %edx
    2e75: 48 89 df                     	movq	%rbx, %rdi
    2e78: e8 00 00 00 00               	callq	 <L1>
		0000000000002e79:  X86_64_RELOC_BRANCH	_memcpy
<L1>:
    2e7d: 48 8d b5 30 fe ff ff         	leaq	-0x1d0(%rbp), %rsi
    2e84: 48 89 df                     	movq	%rbx, %rdi
    2e87: e8 00 00 00 00               	callq	 <L2>
		0000000000002e88:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L2>:
    2e8c: 48 81 85 40 fc ff ff 80 00 00 00     	addq	$0x80, -0x3c0(%rbp)
    2e97: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    2e9f: 0f b6 85 10 fd ff ff         	movzbl	-0x2f0(%rbp), %eax
    2ea6: 49 83 ff 2f                  	cmpq	$0x2f, %r15
    2eaa: 0f 86 5b 05 00 00            	jbe	 <L43>
    2eb0: 84 c0                        	testb	%al, %al
    2eb2: 0f 84 0a 05 00 00            	je	 <L39>
    2eb8: 3c 50                        	cmpb	$0x50, %al
    2eba: 0f 82 04 05 00 00            	jb	 <L40>
    2ec0: 0f b6 c0                     	movzbl	%al, %eax
    2ec3: bb 80 00 00 00               	movl	$0x80, %ebx
    2ec8: 48 29 c3                     	subq	%rax, %rbx
    2ecb: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    2ed2: 48 8d bc 05 90 fc ff ff      	leaq	-0x370(%rbp,%rax), %rdi
    2eda: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    2ede: 48 89 da                     	movq	%rbx, %rdx
    2ee1: e8 00 00 00 00               	callq	 <L3>
		0000000000002ee2:  X86_64_RELOC_BRANCH	_memcpy
<L3>:
    2ee6: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    2eed: 4c 89 f6                     	movq	%r14, %rsi
    2ef0: e8 00 00 00 00               	callq	 <L4>
		0000000000002ef1:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L4>:
    2ef5: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    2efc: 31 c0                        	xorl	%eax, %eax
    2efe: e9 c3 04 00 00               	jmp	 <L41>
<L5>:
    2f03: 48 83 f1 7f                  	xorq	$0x7f, %rcx
    2f07: 48 89 4d a0                  	movq	%rcx, -0x60(%rbp)
    2f0b: 0f 28 1d 0e 32 00 00         	movaps	, %xmm3 <_audit_key384+0xd0>
		0000000000002f0e:  X86_64_RELOC_SIGNED	__literal16
    2f12: 0f 28 e1                     	movaps	%xmm1, %xmm4
    2f15: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f18: 0f 29 a5 a0 fd ff ff         	movaps	%xmm4, -0x260(%rbp)
    2f1f: 0f 28 e2                     	movaps	%xmm2, %xmm4
    2f22: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f25: 0f 29 a5 b0 fd ff ff         	movaps	%xmm4, -0x250(%rbp)
    2f2c: 0f 28 e0                     	movaps	%xmm0, %xmm4
    2f2f: 0f 57 e3                     	xorps	%xmm3, %xmm4
    2f32: 0f 29 a5 c0 fd ff ff         	movaps	%xmm4, -0x240(%rbp)
    2f39: 0f 28 1d f0 31 00 00         	movaps	, %xmm3 <_audit_key384+0xe0>
		0000000000002f3c:  X86_64_RELOC_SIGNED	__literal16
    2f40: 0f 57 cb                     	xorps	%xmm3, %xmm1
    2f43: 0f 29 8d d0 fd ff ff         	movaps	%xmm1, -0x230(%rbp)
    2f4a: 0f 57 d3                     	xorps	%xmm3, %xmm2
    2f4d: 0f 29 95 e0 fd ff ff         	movaps	%xmm2, -0x220(%rbp)
    2f54: 0f 57 c3                     	xorps	%xmm3, %xmm0
    2f57: 0f 29 85 f0 fd ff ff         	movaps	%xmm0, -0x210(%rbp)
    2f5e: 41 b6 01                     	movb	$0x1, %r14b
    2f61: b0 02                        	movb	$0x2, %al
    2f63: 31 c9                        	xorl	%ecx, %ecx
    2f65: 4c 8d a5 30 fe ff ff         	leaq	-0x1d0(%rbp), %r12
    2f6c: 4c 89 7d 98                  	movq	%r15, -0x68(%rbp)
    2f70: e9 96 00 00 00               	jmp	 <L11>
    2f75: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    2f7f: 90                           	nop
<L6>:
    2f80: 31 ff                        	xorl	%edi, %edi
<L7>:
    2f82: 45 31 f6                     	xorl	%r14d, %r14d
<L8>:
    2f85: 48 8b 5d b0                  	movq	-0x50(%rbp), %rbx
    2f89: 48 03 5d c8                  	addq	-0x38(%rbp), %rbx
    2f8d: 4a 8d b4 35 c0 fb ff ff      	leaq	-0x440(%rbp,%r14), %rsi
    2f95: b8 30 00 00 00               	movl	$0x30, %eax
    2f9a: 48 89 45 b0                  	movq	%rax, -0x50(%rbp)
    2f9e: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    2fa4: 4d 29 f4                     	subq	%r14, %r12
    2fa7: 40 0f b6 ff                  	movzbl	%dil, %edi
    2fab: 48 8d 85 80 fe ff ff         	leaq	-0x180(%rbp), %rax
    2fb2: 48 01 c7                     	addq	%rax, %rdi
    2fb5: 4c 89 e2                     	movq	%r12, %rdx
    2fb8: e8 00 00 00 00               	callq	 <L9>
		0000000000002fb9:  X86_64_RELOC_BRANCH	_memcpy
<L9>:
    2fbd: 44 00 a5 00 ff ff ff         	addb	%r12b, -0x100(%rbp)
    2fc4: 49 83 c7 30                  	addq	$0x30, %r15
    2fc8: 49 83 d5 00                  	adcq	$0x0, %r13
    2fcc: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    2fd3: 4c 89 bd 30 fe ff ff         	movq	%r15, -0x1d0(%rbp)
    2fda: 4c 8d a5 30 fe ff ff         	leaq	-0x1d0(%rbp), %r12
    2fe1: 4c 89 e7                     	movq	%r12, %rdi
    2fe4: 48 89 de                     	movq	%rbx, %rsi
    2fe7: e8 00 00 00 00               	callq	 <L10>
		0000000000002fe8:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L10>:
    2fec: 48 8b 45 a8                  	movq	-0x58(%rbp), %rax
    2ff0: 88 45 d7                     	movb	%al, -0x29(%rbp)
    2ff3: ff c0                        	incl	%eax
    2ff5: 45 31 f6                     	xorl	%r14d, %r14d
    2ff8: b9 30 00 00 00               	movl	$0x30, %ecx
    2ffd: 4c 8b 7d 98                  	movq	-0x68(%rbp), %r15
    3001: 49 83 ff 60                  	cmpq	$0x60, %r15
    3005: 0f 82 91 fd ff ff            	jb	 <L0>
<L11>:
    300b: 48 89 4d b0                  	movq	%rcx, -0x50(%rbp)
    300f: 48 89 45 a8                  	movq	%rax, -0x58(%rbp)
    3013: 0f 28 85 a0 fd ff ff         	movaps	-0x260(%rbp), %xmm0
    301a: 0f 29 85 10 ff ff ff         	movaps	%xmm0, -0xf0(%rbp)
    3021: 0f 28 85 b0 fd ff ff         	movaps	-0x250(%rbp), %xmm0
    3028: 0f 29 85 20 ff ff ff         	movaps	%xmm0, -0xe0(%rbp)
    302f: 0f 28 85 c0 fd ff ff         	movaps	-0x240(%rbp), %xmm0
    3036: 0f 29 85 30 ff ff ff         	movaps	%xmm0, -0xd0(%rbp)
    303d: 0f 28 05 dc 30 00 00         	movaps	, %xmm0 <_audit_key384+0xd0>
		0000000000003040:  X86_64_RELOC_SIGNED	__literal16
    3044: 0f 29 85 40 ff ff ff         	movaps	%xmm0, -0xc0(%rbp)
    304b: 0f 29 85 50 ff ff ff         	movaps	%xmm0, -0xb0(%rbp)
    3052: 0f 29 85 60 ff ff ff         	movaps	%xmm0, -0xa0(%rbp)
    3059: 0f 29 85 70 ff ff ff         	movaps	%xmm0, -0x90(%rbp)
    3060: 0f 29 45 80                  	movaps	%xmm0, -0x80(%rbp)
    3064: 0f 28 85 d0 fd ff ff         	movaps	-0x230(%rbp), %xmm0
    306b: 0f 29 85 c0 fb ff ff         	movaps	%xmm0, -0x440(%rbp)
    3072: 0f 28 85 e0 fd ff ff         	movaps	-0x220(%rbp), %xmm0
    3079: 0f 29 85 d0 fb ff ff         	movaps	%xmm0, -0x430(%rbp)
    3080: 0f 28 85 f0 fd ff ff         	movaps	-0x210(%rbp), %xmm0
    3087: 0f 29 85 e0 fb ff ff         	movaps	%xmm0, -0x420(%rbp)
    308e: 0f 28 05 9b 30 00 00         	movaps	, %xmm0 <_audit_key384+0xe0>
		0000000000003091:  X86_64_RELOC_SIGNED	__literal16
    3095: 0f 29 85 f0 fb ff ff         	movaps	%xmm0, -0x410(%rbp)
    309c: 0f 29 85 00 fc ff ff         	movaps	%xmm0, -0x400(%rbp)
    30a3: 0f 29 85 10 fc ff ff         	movaps	%xmm0, -0x3f0(%rbp)
    30aa: 0f 29 85 20 fc ff ff         	movaps	%xmm0, -0x3e0(%rbp)
    30b1: 0f 29 85 30 fc ff ff         	movaps	%xmm0, -0x3d0(%rbp)
    30b8: ba e0 00 00 00               	movl	$0xe0, %edx
    30bd: 4c 89 e7                     	movq	%r12, %rdi
    30c0: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x387>
		00000000000030c3:  X86_64_RELOC_SIGNED	l___unnamed_2
    30c7: e8 00 00 00 00               	callq	 <L12>
		00000000000030c8:  X86_64_RELOC_BRANCH	_memcpy
<L12>:
    30cc: 4c 89 e7                     	movq	%r12, %rdi
    30cf: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    30d6: e8 00 00 00 00               	callq	 <L13>
		00000000000030d7:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L13>:
    30db: 48 81 85 30 fe ff ff 80 00 00 00     	addq	$0x80, -0x1d0(%rbp)
    30e6: 48 83 95 38 fe ff ff 00      	adcq	$0x0, -0x1c8(%rbp)
    30ee: ba 60 01 00 00               	movl	$0x160, %edx            ## imm = 0x160
    30f3: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    30fa: 4c 89 e6                     	movq	%r12, %rsi
    30fd: e8 00 00 00 00               	callq	 <L14>
		00000000000030fe:  X86_64_RELOC_BRANCH	_memcpy
<L14>:
    3102: 0f b6 85 30 fb ff ff         	movzbl	-0x4d0(%rbp), %eax
    3109: 41 f6 c6 01                  	testb	$0x1, %r14b
    310d: 0f 85 90 00 00 00            	jne	 <L21>
    3113: 84 c0                        	testb	%al, %al
    3115: 74 40                        	je	 <L17>
    3117: 3c 50                        	cmpb	$0x50, %al
    3119: 72 3e                        	jb	 <L18>
    311b: 0f b6 f8                     	movzbl	%al, %edi
    311e: 41 be 80 00 00 00            	movl	$0x80, %r14d
    3124: 49 29 fe                     	subq	%rdi, %r14
    3127: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    312e: 48 01 df                     	addq	%rbx, %rdi
    3131: 48 8b 75 c8                  	movq	-0x38(%rbp), %rsi
    3135: 4c 89 f2                     	movq	%r14, %rdx
    3138: e8 00 00 00 00               	callq	 <L15>
		0000000000003139:  X86_64_RELOC_BRANCH	_memcpy
<L15>:
    313d: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3144: 48 89 de                     	movq	%rbx, %rsi
    3147: e8 00 00 00 00               	callq	 <L16>
		0000000000003148:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L16>:
    314c: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3153: 31 c0                        	xorl	%eax, %eax
    3155: eb 05                        	jmp	 <L19>
<L17>:
    3157: 31 c0                        	xorl	%eax, %eax
<L18>:
    3159: 45 31 f6                     	xorl	%r14d, %r14d
<L19>:
    315c: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    3160: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    3164: 41 bc 30 00 00 00            	movl	$0x30, %r12d
    316a: 4d 29 f4                     	subq	%r14, %r12
    316d: 0f b6 f8                     	movzbl	%al, %edi
    3170: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3177: 48 01 c7                     	addq	%rax, %rdi
    317a: 4c 89 e2                     	movq	%r12, %rdx
    317d: e8 00 00 00 00               	callq	 <L20>
		000000000000317e:  X86_64_RELOC_BRANCH	_memcpy
<L20>:
    3182: 44 02 a5 30 fb ff ff         	addb	-0x4d0(%rbp), %r12b
    3189: 44 88 a5 30 fb ff ff         	movb	%r12b, -0x4d0(%rbp)
    3190: 48 83 85 60 fa ff ff 30      	addq	$0x30, -0x5a0(%rbp)
    3198: 48 83 95 68 fa ff ff 00      	adcq	$0x0, -0x598(%rbp)
    31a0: 44 89 e0                     	movl	%r12d, %eax
<L21>:
    31a3: 84 c0                        	testb	%al, %al
    31a5: 74 49                        	je	 <L24>
    31a7: 0f b6 f8                     	movzbl	%al, %edi
    31aa: 48 39 7d a0                  	cmpq	%rdi, -0x60(%rbp)
    31ae: 73 42                        	jae	 <L25>
    31b0: b1 80                        	movb	$-0x80, %cl
    31b2: 28 c1                        	subb	%al, %cl
    31b4: 44 0f b6 f1                  	movzbl	%cl, %r14d
    31b8: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    31bf: 48 01 df                     	addq	%rbx, %rdi
    31c2: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
    31c6: 4c 89 f2                     	movq	%r14, %rdx
    31c9: e8 00 00 00 00               	callq	 <L22>
		00000000000031ca:  X86_64_RELOC_BRANCH	_memcpy
<L22>:
    31ce: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    31d5: 48 89 de                     	movq	%rbx, %rsi
    31d8: e8 00 00 00 00               	callq	 <L23>
		00000000000031d9:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L23>:
    31dd: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    31e4: 31 c0                        	xorl	%eax, %eax
    31e6: eb 0d                        	jmp	 <L26>
    31e8: 0f 1f 84 00 00 00 00 00      	nopl	(%rax,%rax)
<L24>:
    31f0: 31 c0                        	xorl	%eax, %eax
<L25>:
    31f2: 45 31 f6                     	xorl	%r14d, %r14d
<L26>:
    31f5: 48 8b 4d b8                  	movq	-0x48(%rbp), %rcx
    31f9: 4a 8d 34 31                  	leaq	(%rcx,%r14), %rsi
    31fd: 48 8b 5d c0                  	movq	-0x40(%rbp), %rbx
    3201: 49 89 dc                     	movq	%rbx, %r12
    3204: 4d 29 f4                     	subq	%r14, %r12
    3207: 0f b6 f8                     	movzbl	%al, %edi
    320a: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    3211: 48 01 c7                     	addq	%rax, %rdi
    3214: 4c 89 e2                     	movq	%r12, %rdx
    3217: e8 00 00 00 00               	callq	 <L27>
		0000000000003218:  X86_64_RELOC_BRANCH	_memcpy
<L27>:
    321c: 0f b6 bd 30 fb ff ff         	movzbl	-0x4d0(%rbp), %edi
    3223: 4c 01 e7                     	addq	%r12, %rdi
    3226: 40 88 bd 30 fb ff ff         	movb	%dil, -0x4d0(%rbp)
    322d: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    3234: 4c 8b bd 60 fa ff ff         	movq	-0x5a0(%rbp), %r15
    323b: 49 01 df                     	addq	%rbx, %r15
    323e: 49 83 d5 00                  	adcq	$0x0, %r13
    3242: 4c 89 bd 60 fa ff ff         	movq	%r15, -0x5a0(%rbp)
    3249: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    3250: 40 84 ff                     	testb	%dil, %dil
    3253: 74 5b                        	je	 <L30>
    3255: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    3259: 72 57                        	jb	 <L31>
    325b: b0 80                        	movb	$-0x80, %al
    325d: 40 28 f8                     	subb	%dil, %al
    3260: 44 0f b6 f0                  	movzbl	%al, %r14d
    3264: 48 8d 9d b0 fa ff ff         	leaq	-0x550(%rbp), %rbx
    326b: 48 01 df                     	addq	%rbx, %rdi
    326e: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    3272: 4c 89 f2                     	movq	%r14, %rdx
    3275: e8 00 00 00 00               	callq	 <L28>
		0000000000003276:  X86_64_RELOC_BRANCH	_memcpy
<L28>:
    327a: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    3281: 48 89 de                     	movq	%rbx, %rsi
    3284: e8 00 00 00 00               	callq	 <L29>
		0000000000003285:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L29>:
    3289: c6 85 30 fb ff ff 00         	movb	$0x0, -0x4d0(%rbp)
    3290: 31 ff                        	xorl	%edi, %edi
    3292: 4c 8b bd 60 fa ff ff         	movq	-0x5a0(%rbp), %r15
    3299: 4c 8b ad 68 fa ff ff         	movq	-0x598(%rbp), %r13
    32a0: eb 13                        	jmp	 <L32>
    32a2: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    32ac: 0f 1f 40 00                  	nopl	(%rax)
<L30>:
    32b0: 31 ff                        	xorl	%edi, %edi
<L31>:
    32b2: 45 31 f6                     	xorl	%r14d, %r14d
<L32>:
    32b5: 4a 8d 74 35 d7               	leaq	-0x29(%rbp,%r14), %rsi
    32ba: 41 bc 01 00 00 00            	movl	$0x1, %r12d
    32c0: 4d 29 f4                     	subq	%r14, %r12
    32c3: 40 0f b6 ff                  	movzbl	%dil, %edi
    32c7: 48 8d 85 b0 fa ff ff         	leaq	-0x550(%rbp), %rax
    32ce: 48 01 c7                     	addq	%rax, %rdi
    32d1: 4c 89 e2                     	movq	%r12, %rdx
    32d4: e8 00 00 00 00               	callq	 <L33>
		00000000000032d5:  X86_64_RELOC_BRANCH	_memcpy
<L33>:
    32d9: 44 00 a5 30 fb ff ff         	addb	%r12b, -0x4d0(%rbp)
    32e0: 49 83 c7 01                  	addq	$0x1, %r15
    32e4: 49 83 d5 00                  	adcq	$0x0, %r13
    32e8: 4c 89 ad 68 fa ff ff         	movq	%r13, -0x598(%rbp)
    32ef: 4c 89 bd 60 fa ff ff         	movq	%r15, -0x5a0(%rbp)
    32f6: 48 8d bd 60 fa ff ff         	leaq	-0x5a0(%rbp), %rdi
    32fd: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    3304: e8 00 00 00 00               	callq	 <L34>
		0000000000003305:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L34>:
    3309: ba e0 00 00 00               	movl	$0xe0, %edx
    330e: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    3315: 48 89 df                     	movq	%rbx, %rdi
    3318: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x5df>
		000000000000331b:  X86_64_RELOC_SIGNED	l___unnamed_2
    331f: e8 00 00 00 00               	callq	 <L35>
		0000000000003320:  X86_64_RELOC_BRANCH	_memcpy
<L35>:
    3324: 48 89 df                     	movq	%rbx, %rdi
    3327: 48 8d b5 40 fb ff ff         	leaq	-0x4c0(%rbp), %rsi
    332e: e8 00 00 00 00               	callq	 <L36>
		000000000000332f:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L36>:
    3333: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    333a: 4c 8b bd 30 fe ff ff         	movq	-0x1d0(%rbp), %r15
    3341: b8 80 00 00 00               	movl	$0x80, %eax
    3346: 49 01 c7                     	addq	%rax, %r15
    3349: 49 83 d5 00                  	adcq	$0x0, %r13
    334d: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    3354: 4c 89 bd 30 fe ff ff         	movq	%r15, -0x1d0(%rbp)
    335b: 4c 89 ad 38 fe ff ff         	movq	%r13, -0x1c8(%rbp)
    3362: 48 85 ff                     	testq	%rdi, %rdi
    3365: 0f 84 15 fc ff ff            	je	 <L6>
    336b: 40 80 ff 50                  	cmpb	$0x50, %dil
    336f: 0f 82 0d fc ff ff            	jb	 <L7>
    3375: 41 be 80 00 00 00            	movl	$0x80, %r14d
    337b: 49 29 fe                     	subq	%rdi, %r14
    337e: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    3385: 48 01 df                     	addq	%rbx, %rdi
    3388: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    338f: 4c 89 f2                     	movq	%r14, %rdx
    3392: e8 00 00 00 00               	callq	 <L37>
		0000000000003393:  X86_64_RELOC_BRANCH	_memcpy
<L37>:
    3397: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    339e: 48 89 de                     	movq	%rbx, %rsi
    33a1: e8 00 00 00 00               	callq	 <L38>
		00000000000033a2:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L38>:
    33a6: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    33ad: 31 ff                        	xorl	%edi, %edi
    33af: 4c 8b bd 30 fe ff ff         	movq	-0x1d0(%rbp), %r15
    33b6: 4c 8b ad 38 fe ff ff         	movq	-0x1c8(%rbp), %r13
    33bd: e9 c3 fb ff ff               	jmp	 <L8>
<L39>:
    33c2: 31 c0                        	xorl	%eax, %eax
<L40>:
    33c4: 31 db                        	xorl	%ebx, %ebx
<L41>:
    33c6: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    33ca: 48 8d 34 19                  	leaq	(%rcx,%rbx), %rsi
    33ce: 41 be 30 00 00 00            	movl	$0x30, %r14d
    33d4: 49 29 de                     	subq	%rbx, %r14
    33d7: 0f b6 c0                     	movzbl	%al, %eax
    33da: 48 8d bc 05 90 fc ff ff      	leaq	-0x370(%rbp,%rax), %rdi
    33e2: 4c 89 f2                     	movq	%r14, %rdx
    33e5: e8 00 00 00 00               	callq	 <L42>
		00000000000033e6:  X86_64_RELOC_BRANCH	_memcpy
<L42>:
    33ea: 44 02 b5 10 fd ff ff         	addb	-0x2f0(%rbp), %r14b
    33f1: 44 88 b5 10 fd ff ff         	movb	%r14b, -0x2f0(%rbp)
    33f8: 48 83 85 40 fc ff ff 30      	addq	$0x30, -0x3c0(%rbp)
    3400: 48 83 95 48 fc ff ff 00      	adcq	$0x0, -0x3b8(%rbp)
    3408: 44 89 f0                     	movl	%r14d, %eax
<L43>:
    340b: 48 8b 55 c0                  	movq	-0x40(%rbp), %rdx
    340f: 84 c0                        	testb	%al, %al
    3411: 74 4b                        	je	 <L46>
    3413: 0f b6 c8                     	movzbl	%al, %ecx
    3416: 48 01 ca                     	addq	%rcx, %rdx
    3419: 48 81 fa 80 00 00 00         	cmpq	$0x80, %rdx
    3420: 72 3e                        	jb	 <L47>
    3422: b2 80                        	movb	$-0x80, %dl
    3424: 28 c2                        	subb	%al, %dl
    3426: 0f b6 da                     	movzbl	%dl, %ebx
    3429: 4c 8d b5 90 fc ff ff         	leaq	-0x370(%rbp), %r14
    3430: 48 8d bc 0d 90 fc ff ff      	leaq	-0x370(%rbp,%rcx), %rdi
    3438: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
    343c: 48 89 da                     	movq	%rbx, %rdx
    343f: e8 00 00 00 00               	callq	 <L44>
		0000000000003440:  X86_64_RELOC_BRANCH	_memcpy
<L44>:
    3444: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    344b: 4c 89 f6                     	movq	%r14, %rsi
    344e: e8 00 00 00 00               	callq	 <L45>
		000000000000344f:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L45>:
    3453: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    345a: 31 c0                        	xorl	%eax, %eax
    345c: eb 04                        	jmp	 <L48>
<L46>:
    345e: 31 c0                        	xorl	%eax, %eax
<L47>:
    3460: 31 db                        	xorl	%ebx, %ebx
<L48>:
    3462: 48 8b 75 b8                  	movq	-0x48(%rbp), %rsi
    3466: 48 01 de                     	addq	%rbx, %rsi
    3469: 4c 8b 7d c0                  	movq	-0x40(%rbp), %r15
    346d: 4d 89 fe                     	movq	%r15, %r14
    3470: 49 29 de                     	subq	%rbx, %r14
    3473: 48 8d 9d 90 fc ff ff         	leaq	-0x370(%rbp), %rbx
    347a: 0f b6 c0                     	movzbl	%al, %eax
    347d: 48 8d bc 05 90 fc ff ff      	leaq	-0x370(%rbp,%rax), %rdi
    3485: 4c 89 f2                     	movq	%r14, %rdx
    3488: e8 00 00 00 00               	callq	 <L49>
		0000000000003489:  X86_64_RELOC_BRANCH	_memcpy
<L49>:
    348d: 0f b6 bd 10 fd ff ff         	movzbl	-0x2f0(%rbp), %edi
    3494: 4c 01 f7                     	addq	%r14, %rdi
    3497: 40 88 bd 10 fd ff ff         	movb	%dil, -0x2f0(%rbp)
    349e: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    34a5: 4c 03 bd 40 fc ff ff         	addq	-0x3c0(%rbp), %r15
    34ac: 49 83 d4 00                  	adcq	$0x0, %r12
    34b0: 4d 89 fd                     	movq	%r15, %r13
    34b3: 4c 89 bd 40 fc ff ff         	movq	%r15, -0x3c0(%rbp)
    34ba: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    34c1: 40 84 ff                     	testb	%dil, %dil
    34c4: 74 46                        	je	 <L52>
    34c6: 40 80 ff 7f                  	cmpb	$0x7f, %dil
    34ca: 72 42                        	jb	 <L53>
    34cc: b0 80                        	movb	$-0x80, %al
    34ce: 40 28 f8                     	subb	%dil, %al
    34d1: 44 0f b6 f8                  	movzbl	%al, %r15d
    34d5: 48 01 df                     	addq	%rbx, %rdi
    34d8: 48 8d 75 d7                  	leaq	-0x29(%rbp), %rsi
    34dc: 4c 89 fa                     	movq	%r15, %rdx
    34df: e8 00 00 00 00               	callq	 <L50>
		00000000000034e0:  X86_64_RELOC_BRANCH	_memcpy
<L50>:
    34e4: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    34eb: 48 89 de                     	movq	%rbx, %rsi
    34ee: e8 00 00 00 00               	callq	 <L51>
		00000000000034ef:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L51>:
    34f3: c6 85 10 fd ff ff 00         	movb	$0x0, -0x2f0(%rbp)
    34fa: 31 ff                        	xorl	%edi, %edi
    34fc: 4c 8b ad 40 fc ff ff         	movq	-0x3c0(%rbp), %r13
    3503: 4c 8b a5 48 fc ff ff         	movq	-0x3b8(%rbp), %r12
    350a: eb 05                        	jmp	 <L54>
<L52>:
    350c: 31 ff                        	xorl	%edi, %edi
<L53>:
    350e: 45 31 ff                     	xorl	%r15d, %r15d
<L54>:
    3511: 4a 8d 74 3d d7               	leaq	-0x29(%rbp,%r15), %rsi
    3516: 41 be 01 00 00 00            	movl	$0x1, %r14d
    351c: 4d 29 fe                     	subq	%r15, %r14
    351f: 40 0f b6 c7                  	movzbl	%dil, %eax
    3523: 48 01 c3                     	addq	%rax, %rbx
    3526: 48 89 df                     	movq	%rbx, %rdi
    3529: 4c 89 f2                     	movq	%r14, %rdx
    352c: e8 00 00 00 00               	callq	 <L55>
		000000000000352d:  X86_64_RELOC_BRANCH	_memcpy
<L55>:
    3531: 44 00 b5 10 fd ff ff         	addb	%r14b, -0x2f0(%rbp)
    3538: 49 83 c5 01                  	addq	$0x1, %r13
    353c: 49 83 d4 00                  	adcq	$0x0, %r12
    3540: 4c 89 a5 48 fc ff ff         	movq	%r12, -0x3b8(%rbp)
    3547: 4c 89 ad 40 fc ff ff         	movq	%r13, -0x3c0(%rbp)
    354e: 48 8d bd 40 fc ff ff         	leaq	-0x3c0(%rbp), %rdi
    3555: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    355c: e8 00 00 00 00               	callq	 <L56>
		000000000000355d:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L56>:
    3561: 48 8d 35 00 00 00 00         	leaq	, %rsi <_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand+0x828>
		0000000000003564:  X86_64_RELOC_SIGNED	l___unnamed_2
    3568: 48 8d 9d 30 fe ff ff         	leaq	-0x1d0(%rbp), %rbx
    356f: ba e0 00 00 00               	movl	$0xe0, %edx
    3574: 48 89 df                     	movq	%rbx, %rdi
    3577: e8 00 00 00 00               	callq	 <L57>
		0000000000003578:  X86_64_RELOC_BRANCH	_memcpy
<L57>:
    357c: 48 8d b5 20 fd ff ff         	leaq	-0x2e0(%rbp), %rsi
    3583: 48 89 df                     	movq	%rbx, %rdi
    3586: e8 00 00 00 00               	callq	 <L58>
		0000000000003587:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L58>:
    358b: 0f b6 bd 00 ff ff ff         	movzbl	-0x100(%rbp), %edi
    3592: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    3599: 41 bd 80 00 00 00            	movl	$0x80, %r13d
    359f: 4c 03 ad 30 fe ff ff         	addq	-0x1d0(%rbp), %r13
    35a6: 49 83 d4 00                  	adcq	$0x0, %r12
    35aa: 48 8d 9d 80 fe ff ff         	leaq	-0x180(%rbp), %rbx
    35b1: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    35b8: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    35bf: 48 85 ff                     	testq	%rdi, %rdi
    35c2: 74 49                        	je	 <L61>
    35c4: 40 80 ff 50                  	cmpb	$0x50, %dil
    35c8: 72 45                        	jb	 <L62>
    35ca: 41 be 80 00 00 00            	movl	$0x80, %r14d
    35d0: 49 29 fe                     	subq	%rdi, %r14
    35d3: 48 01 df                     	addq	%rbx, %rdi
    35d6: 48 8d b5 c0 fb ff ff         	leaq	-0x440(%rbp), %rsi
    35dd: 4c 89 f2                     	movq	%r14, %rdx
    35e0: e8 00 00 00 00               	callq	 <L59>
		00000000000035e1:  X86_64_RELOC_BRANCH	_memcpy
<L59>:
    35e5: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    35ec: 48 89 de                     	movq	%rbx, %rsi
    35ef: e8 00 00 00 00               	callq	 <L60>
		00000000000035f0:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L60>:
    35f4: c6 85 00 ff ff ff 00         	movb	$0x0, -0x100(%rbp)
    35fb: 31 ff                        	xorl	%edi, %edi
    35fd: 4c 8b ad 30 fe ff ff         	movq	-0x1d0(%rbp), %r13
    3604: 4c 8b a5 38 fe ff ff         	movq	-0x1c8(%rbp), %r12
    360b: eb 05                        	jmp	 <L63>
<L61>:
    360d: 31 ff                        	xorl	%edi, %edi
<L62>:
    360f: 45 31 f6                     	xorl	%r14d, %r14d
<L63>:
    3612: 4a 8d b4 35 c0 fb ff ff      	leaq	-0x440(%rbp,%r14), %rsi
    361a: 41 bf 30 00 00 00            	movl	$0x30, %r15d
    3620: 4d 29 f7                     	subq	%r14, %r15
    3623: 40 0f b6 c7                  	movzbl	%dil, %eax
    3627: 48 01 c3                     	addq	%rax, %rbx
    362a: 48 89 df                     	movq	%rbx, %rdi
    362d: 4c 89 fa                     	movq	%r15, %rdx
    3630: e8 00 00 00 00               	callq	 <L64>
		0000000000003631:  X86_64_RELOC_BRANCH	_memcpy
<L64>:
    3635: 44 00 bd 00 ff ff ff         	addb	%r15b, -0x100(%rbp)
    363c: 49 83 c5 30                  	addq	$0x30, %r13
    3640: 49 83 d4 00                  	adcq	$0x0, %r12
    3644: 4c 89 a5 38 fe ff ff         	movq	%r12, -0x1c8(%rbp)
    364b: 4c 89 ad 30 fe ff ff         	movq	%r13, -0x1d0(%rbp)
    3652: 48 8d bd 30 fe ff ff         	leaq	-0x1d0(%rbp), %rdi
    3659: 48 8d 9d 30 fa ff ff         	leaq	-0x5d0(%rbp), %rbx
    3660: 48 89 de                     	movq	%rbx, %rsi
    3663: e8 00 00 00 00               	callq	 <L65>
		0000000000003664:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final
<L65>:
    3668: 48 8b 7d c8                  	movq	-0x38(%rbp), %rdi
    366c: 48 03 7d b0                  	addq	-0x50(%rbp), %rdi
    3670: 48 89 de                     	movq	%rbx, %rsi
    3673: 48 8b 55 a8                  	movq	-0x58(%rbp), %rdx
    3677: e8 00 00 00 00               	callq	 <L66>
		0000000000003678:  X86_64_RELOC_BRANCH	_memcpy
<L66>:
    367c: 48 81 c4 a8 05 00 00         	addq	$0x5a8, %rsp            ## imm = 0x5A8
    3683: 5b                           	popq	%rbx
    3684: 41 5c                        	popq	%r12
    3686: 41 5d                        	popq	%r13
    3688: 41 5e                        	popq	%r14
    368a: 41 5f                        	popq	%r15
    368c: 5d                           	popq	%rbp
    368d: c3                           	retq
    368e: 66 90                        	nop

0000000000003690 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).final>:
    3690: 55                           	pushq	%rbp
    3691: 48 89 e5                     	movq	%rsp, %rbp
    3694: 41 57                        	pushq	%r15
    3696: 41 56                        	pushq	%r14
    3698: 53                           	pushq	%rbx
    3699: 50                           	pushq	%rax
    369a: 48 89 f3                     	movq	%rsi, %rbx
    369d: 49 89 fe                     	movq	%rdi, %r14
    36a0: 4c 8d 7f 50                  	leaq	0x50(%rdi), %r15
    36a4: 0f b6 87 d0 00 00 00         	movzbl	0xd0(%rdi), %eax
    36ab: 48 8d 7c 07 50               	leaq	0x50(%rdi,%rax), %rdi
    36b0: be 80 00 00 00               	movl	$0x80, %esi
    36b5: 48 29 c6                     	subq	%rax, %rsi
    36b8: e8 00 00 00 00               	callq	 <L0>
		00000000000036b9:  X86_64_RELOC_BRANCH	___bzero
<L0>:
    36bd: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    36c5: 41 c6 44 06 50 80            	movb	$-0x80, 0x50(%r14,%rax)
    36cb: 41 0f b6 86 d0 00 00 00      	movzbl	0xd0(%r14), %eax
    36d3: 8d 48 01                     	leal	0x1(%rax), %ecx
    36d6: 41 88 8e d0 00 00 00         	movb	%cl, 0xd0(%r14)
    36dd: 3c 6f                        	cmpb	$0x6f, %al
    36df: 76 30                        	jbe	 <L2>
    36e1: 4c 89 f7                     	movq	%r14, %rdi
    36e4: 4c 89 fe                     	movq	%r15, %rsi
    36e7: e8 00 00 00 00               	callq	 <L1>
		00000000000036e8:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L1>:
    36ec: 0f 57 c0                     	xorps	%xmm0, %xmm0
    36ef: 41 0f 29 47 60               	movaps	%xmm0, 0x60(%r15)
    36f4: 41 0f 29 47 50               	movaps	%xmm0, 0x50(%r15)
    36f9: 41 0f 29 47 40               	movaps	%xmm0, 0x40(%r15)
    36fe: 41 0f 29 47 30               	movaps	%xmm0, 0x30(%r15)
    3703: 41 0f 29 47 20               	movaps	%xmm0, 0x20(%r15)
    3708: 41 0f 29 47 10               	movaps	%xmm0, 0x10(%r15)
    370d: 41 0f 29 07                  	movaps	%xmm0, (%r15)
<L2>:
    3711: 49 8b 06                     	movq	(%r14), %rax
    3714: 49 8b 4e 08                  	movq	0x8(%r14), %rcx
    3718: 89 c2                        	movl	%eax, %edx
    371a: c1 ea 05                     	shrl	$0x5, %edx
    371d: 8d 34 c5 00 00 00 00         	leal	(,%rax,8), %esi
    3724: 41 88 b6 cf 00 00 00         	movb	%sil, 0xcf(%r14)
    372b: 41 88 96 ce 00 00 00         	movb	%dl, 0xce(%r14)
    3732: 89 c2                        	movl	%eax, %edx
    3734: c1 ea 0d                     	shrl	$0xd, %edx
    3737: 41 88 96 cd 00 00 00         	movb	%dl, 0xcd(%r14)
    373e: 89 c2                        	movl	%eax, %edx
    3740: c1 ea 15                     	shrl	$0x15, %edx
    3743: 41 88 96 cc 00 00 00         	movb	%dl, 0xcc(%r14)
    374a: 48 89 ca                     	movq	%rcx, %rdx
    374d: 48 89 ce                     	movq	%rcx, %rsi
    3750: 48 89 c7                     	movq	%rax, %rdi
    3753: 49 89 c8                     	movq	%rcx, %r8
    3756: 49 0f a4 c0 0b               	shldq	$0xb, %rax, %r8
    375b: 49 89 c9                     	movq	%rcx, %r9
    375e: 49 0f a4 c1 13               	shldq	$0x13, %rax, %r9
    3763: 66 48 0f 6e c8               	movq	%rax, %xmm1
    3768: 48 0f ac c8 3d               	shrdq	$0x3d, %rcx, %rax
    376d: 66 48 0f 6e c1               	movq	%rcx, %xmm0
    3772: 66 0f 6e d1                  	movd	%ecx, %xmm2
    3776: 48 c1 e9 25                  	shrq	$0x25, %rcx
    377a: 48 c1 ea 35                  	shrq	$0x35, %rdx
    377e: 48 c1 ee 2d                  	shrq	$0x2d, %rsi
    3782: 48 c1 ef 25                  	shrq	$0x25, %rdi
    3786: 66 49 0f 6e d9               	movq	%r9, %xmm3
    378b: 66 49 0f 6e e0               	movq	%r8, %xmm4
    3790: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    ## xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    3794: 66 0f 73 d1 1d               	psrlq	$0x1d, %xmm1
    3799: 66 0f 6e df                  	movd	%edi, %xmm3
    379d: 66 0f 60 d9                  	punpcklbw	%xmm1, %xmm3    ## xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
    37a1: 66 0f 6f 0d 97 29 00 00      	movdqa	, %xmm1 <_audit_key384+0xf0>
		00000000000037a5:  X86_64_RELOC_SIGNED	__literal16
    37a9: 66 0f db e1                  	pand	%xmm1, %xmm4
    37ad: 66 0f 72 f3 10               	pslld	$0x10, %xmm3
    37b2: 66 0f eb dc                  	por	%xmm4, %xmm3
    37b6: 66 41 0f 7e 9e c8 00 00 00   	movd	%xmm3, 0xc8(%r14)
    37bf: 66 0f 6e de                  	movd	%esi, %xmm3
    37c3: 66 0f 6e e2                  	movd	%edx, %xmm4
    37c7: 66 0f 60 e3                  	punpcklbw	%xmm3, %xmm4    ## xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1],xmm4[2],xmm3[2],xmm4[3],xmm3[3],xmm4[4],xmm3[4],xmm4[5],xmm3[5],xmm4[6],xmm3[6],xmm4[7],xmm3[7]
    37cb: 66 0f db e1                  	pand	%xmm1, %xmm4
    37cf: 66 0f 6f c8                  	movdqa	%xmm0, %xmm1
    37d3: 66 0f 73 d1 1d               	psrlq	$0x1d, %xmm1
    37d8: 66 0f 6e d9                  	movd	%ecx, %xmm3
    37dc: 66 0f 60 d9                  	punpcklbw	%xmm1, %xmm3    ## xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
    37e0: 66 0f 72 f3 10               	pslld	$0x10, %xmm3
    37e5: 66 0f eb dc                  	por	%xmm4, %xmm3
    37e9: 66 0f 6f c8                  	movdqa	%xmm0, %xmm1
    37ed: 66 0f 73 d1 0d               	psrlq	$0xd, %xmm1
    37f2: 66 0f 73 d0 15               	psrlq	$0x15, %xmm0
    37f7: 66 0f 60 c1                  	punpcklbw	%xmm1, %xmm0    ## xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
    37fb: 66 0f 38 00 05 4c 29 00 00   	pshufb	, %xmm0 <_audit_key384+0x100>
		0000000000003800:  X86_64_RELOC_SIGNED	__literal16
    3804: 66 48 0f 6e c8               	movq	%rax, %xmm1
    3809: 66 0f 72 d2 05               	psrld	$0x5, %xmm2
    380e: 66 0f 60 d1                  	punpcklbw	%xmm1, %xmm2    ## xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
    3812: 66 0f 73 f2 30               	psllq	$0x30, %xmm2
    3817: 66 0f eb d0                  	por	%xmm0, %xmm2
    381b: 66 0f 70 c2 55               	pshufd	$0x55, %xmm2, %xmm0     ## xmm0 = xmm2[1,1,1,1]
    3820: 66 0f 62 d8                  	punpckldq	%xmm0, %xmm3    ## xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1]
    3824: 66 41 0f d6 9e c0 00 00 00   	movq	%xmm3, 0xc0(%r14)
    382d: 4c 89 f7                     	movq	%r14, %rdi
    3830: 4c 89 fe                     	movq	%r15, %rsi
    3833: e8 00 00 00 00               	callq	 <L3>
		0000000000003834:  X86_64_RELOC_BRANCH	_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round
<L3>:
    3838: 49 8b 46 10                  	movq	0x10(%r14), %rax
    383c: 48 0f c8                     	bswapq	%rax
    383f: 48 89 03                     	movq	%rax, (%rbx)
    3842: 49 8b 46 18                  	movq	0x18(%r14), %rax
    3846: 48 0f c8                     	bswapq	%rax
    3849: 48 89 43 08                  	movq	%rax, 0x8(%rbx)
    384d: 49 8b 46 20                  	movq	0x20(%r14), %rax
    3851: 48 0f c8                     	bswapq	%rax
    3854: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    3858: 49 8b 46 28                  	movq	0x28(%r14), %rax
    385c: 48 0f c8                     	bswapq	%rax
    385f: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    3863: 49 8b 46 30                  	movq	0x30(%r14), %rax
    3867: 48 0f c8                     	bswapq	%rax
    386a: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    386e: 49 8b 46 38                  	movq	0x38(%r14), %rax
    3872: 48 0f c8                     	bswapq	%rax
    3875: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    3879: 48 83 c4 08                  	addq	$0x8, %rsp
    387d: 5b                           	popq	%rbx
    387e: 41 5e                        	popq	%r14
    3880: 41 5f                        	popq	%r15
    3882: 5d                           	popq	%rbp
    3883: c3                           	retq
    3884: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    388e: 66 90                        	nop

0000000000003890 <_crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384).round>:
    3890: 55                           	pushq	%rbp
    3891: 48 89 e5                     	movq	%rsp, %rbp
    3894: 41 57                        	pushq	%r15
    3896: 41 56                        	pushq	%r14
    3898: 41 55                        	pushq	%r13
    389a: 41 54                        	pushq	%r12
    389c: 53                           	pushq	%rbx
    389d: 48 81 ec 08 02 00 00         	subq	$0x208, %rsp            ## imm = 0x208
    38a4: f3 0f 6f 06                  	movdqu	(%rsi), %xmm0
    38a8: 66 0f 6f 0d b0 28 00 00      	movdqa	, %xmm1 <_audit_key384+0x110>
		00000000000038ac:  X86_64_RELOC_SIGNED	__literal16
    38b0: 66 0f 38 00 c1               	pshufb	%xmm1, %xmm0
    38b5: 66 0f 7f 85 50 fd ff ff      	movdqa	%xmm0, -0x2b0(%rbp)
    38bd: f3 0f 6f 56 10               	movdqu	0x10(%rsi), %xmm2
    38c2: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38c7: 66 0f 7f 95 60 fd ff ff      	movdqa	%xmm2, -0x2a0(%rbp)
    38cf: f3 0f 6f 56 20               	movdqu	0x20(%rsi), %xmm2
    38d4: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38d9: 66 0f 7f 95 70 fd ff ff      	movdqa	%xmm2, -0x290(%rbp)
    38e1: f3 0f 6f 56 30               	movdqu	0x30(%rsi), %xmm2
    38e6: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38eb: 66 0f 7f 95 80 fd ff ff      	movdqa	%xmm2, -0x280(%rbp)
    38f3: f3 0f 6f 56 40               	movdqu	0x40(%rsi), %xmm2
    38f8: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    38fd: 66 0f 7f 95 90 fd ff ff      	movdqa	%xmm2, -0x270(%rbp)
    3905: f3 0f 6f 56 50               	movdqu	0x50(%rsi), %xmm2
    390a: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    390f: 66 0f 7f 95 a0 fd ff ff      	movdqa	%xmm2, -0x260(%rbp)
    3917: f3 0f 6f 56 60               	movdqu	0x60(%rsi), %xmm2
    391c: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    3921: 66 0f 7f 95 b0 fd ff ff      	movdqa	%xmm2, -0x250(%rbp)
    3929: f3 0f 6f 56 70               	movdqu	0x70(%rsi), %xmm2
    392e: 66 0f 38 00 d1               	pshufb	%xmm1, %xmm2
    3933: 66 0f 7f 95 c0 fd ff ff      	movdqa	%xmm2, -0x240(%rbp)
    393b: 66 49 0f 7e c1               	movq	%xmm0, %r9
    3940: 31 c0                        	xorl	%eax, %eax
    3942: 4c 89 ca                     	movq	%r9, %rdx
    3945: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    394f: 90                           	nop
<L0>:
    3950: 48 03 94 c5 98 fd ff ff      	addq	-0x268(%rbp,%rax,8), %rdx
    3958: 48 8b 8c c5 58 fd ff ff      	movq	-0x2a8(%rbp,%rax,8), %rcx
    3960: 48 89 ce                     	movq	%rcx, %rsi
    3963: 48 d1 ce                     	rorq	%rsi
    3966: 49 89 c8                     	movq	%rcx, %r8
    3969: 49 c1 c0 38                  	rolq	$0x38, %r8
    396d: 4c 8b 94 c5 c0 fd ff ff      	movq	-0x240(%rbp,%rax,8), %r10
    3975: 49 31 f0                     	xorq	%rsi, %r8
    3978: 48 89 ce                     	movq	%rcx, %rsi
    397b: 48 c1 ee 07                  	shrq	$0x7, %rsi
    397f: 4c 31 c6                     	xorq	%r8, %rsi
    3982: 4d 89 d0                     	movq	%r10, %r8
    3985: 49 c1 c0 2d                  	rolq	$0x2d, %r8
    3989: 48 01 d6                     	addq	%rdx, %rsi
    398c: 4c 89 d2                     	movq	%r10, %rdx
    398f: 48 c1 c2 03                  	rolq	$0x3, %rdx
    3993: 4c 31 c2                     	xorq	%r8, %rdx
    3996: 49 c1 ea 06                  	shrq	$0x6, %r10
    399a: 49 31 d2                     	xorq	%rdx, %r10
    399d: 49 01 f2                     	addq	%rsi, %r10
    39a0: 4c 89 94 c5 d0 fd ff ff      	movq	%r10, -0x230(%rbp,%rax,8)
    39a8: 48 ff c0                     	incq	%rax
    39ab: 48 89 ca                     	movq	%rcx, %rdx
    39ae: 48 83 f8 40                  	cmpq	$0x40, %rax
    39b2: 75 9c                        	jne	 <L0>
    39b4: 48 8b 47 10                  	movq	0x10(%rdi), %rax
    39b8: 48 8b 77 18                  	movq	0x18(%rdi), %rsi
    39bc: 4c 8b 47 20                  	movq	0x20(%rdi), %r8
    39c0: 48 8b 4f 30                  	movq	0x30(%rdi), %rcx
    39c4: 49 89 ca                     	movq	%rcx, %r10
    39c7: 49 c1 c2 32                  	rolq	$0x32, %r10
    39cb: 48 8b 57 38                  	movq	0x38(%rdi), %rdx
    39cf: 48 89 cb                     	movq	%rcx, %rbx
    39d2: 48 c1 c3 2e                  	rolq	$0x2e, %rbx
    39d6: 4c 8b 5f 40                  	movq	0x40(%rdi), %r11
    39da: 49 89 ce                     	movq	%rcx, %r14
    39dd: 49 c1 c6 17                  	rolq	$0x17, %r14
    39e1: 4c 31 d3                     	xorq	%r10, %rbx
    39e4: 49 31 de                     	xorq	%rbx, %r14
    39e7: 4d 89 da                     	movq	%r11, %r10
    39ea: 49 31 d2                     	xorq	%rdx, %r10
    39ed: 49 21 ca                     	andq	%rcx, %r10
    39f0: 4d 31 da                     	xorq	%r11, %r10
    39f3: 4c 03 77 48                  	addq	0x48(%rdi), %r14
    39f7: 4d 01 d1                     	addq	%r10, %r9
    39fa: 48 bb 22 ae 28 d7 98 2f 8a 42	movabsq	$0x428a2f98d728ae22, %rbx ## imm = 0x428A2F98D728AE22
    3a04: 4c 01 cb                     	addq	%r9, %rbx
    3a07: 4c 01 f3                     	addq	%r14, %rbx
    3a0a: 4c 8b 57 28                  	movq	0x28(%rdi), %r10
    3a0e: 49 89 c1                     	movq	%rax, %r9
    3a11: 49 c1 c1 24                  	rolq	$0x24, %r9
    3a15: 49 01 da                     	addq	%rbx, %r10
    3a18: 49 89 c6                     	movq	%rax, %r14
    3a1b: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3a1f: 4d 31 ce                     	xorq	%r9, %r14
    3a22: 49 89 c7                     	movq	%rax, %r15
    3a25: 49 c1 c7 19                  	rolq	$0x19, %r15
    3a29: 4d 31 f7                     	xorq	%r14, %r15
    3a2c: 4d 89 c6                     	movq	%r8, %r14
    3a2f: 49 09 f6                     	orq	%rsi, %r14
    3a32: 49 21 c6                     	andq	%rax, %r14
    3a35: 4d 89 c1                     	movq	%r8, %r9
    3a38: 49 21 f1                     	andq	%rsi, %r9
    3a3b: 4d 09 f1                     	orq	%r14, %r9
    3a3e: 4d 01 f9                     	addq	%r15, %r9
    3a41: 49 01 d9                     	addq	%rbx, %r9
    3a44: 4c 89 d3                     	movq	%r10, %rbx
    3a47: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3a4b: 4d 89 d6                     	movq	%r10, %r14
    3a4e: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3a52: 49 31 de                     	xorq	%rbx, %r14
    3a55: 4d 89 d7                     	movq	%r10, %r15
    3a58: 49 c1 c7 17                  	rolq	$0x17, %r15
    3a5c: 4d 31 f7                     	xorq	%r14, %r15
    3a5f: 48 89 d3                     	movq	%rdx, %rbx
    3a62: 48 31 cb                     	xorq	%rcx, %rbx
    3a65: 4c 21 d3                     	andq	%r10, %rbx
    3a68: 48 31 d3                     	xorq	%rdx, %rbx
    3a6b: 4c 03 9d 58 fd ff ff         	addq	-0x2a8(%rbp), %r11
    3a72: 49 01 db                     	addq	%rbx, %r11
    3a75: 48 bb cd 65 ef 23 91 44 37 71	movabsq	$0x7137449123ef65cd, %rbx ## imm = 0x7137449123EF65CD
    3a7f: 4c 01 db                     	addq	%r11, %rbx
    3a82: 4d 89 cb                     	movq	%r9, %r11
    3a85: 49 c1 c3 24                  	rolq	$0x24, %r11
    3a89: 4c 01 fb                     	addq	%r15, %rbx
    3a8c: 4d 89 ce                     	movq	%r9, %r14
    3a8f: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3a93: 49 01 d8                     	addq	%rbx, %r8
    3a96: 4d 89 cf                     	movq	%r9, %r15
    3a99: 49 c1 c7 19                  	rolq	$0x19, %r15
    3a9d: 4d 31 de                     	xorq	%r11, %r14
    3aa0: 4d 31 f7                     	xorq	%r14, %r15
    3aa3: 49 89 f6                     	movq	%rsi, %r14
    3aa6: 49 09 c6                     	orq	%rax, %r14
    3aa9: 4d 21 ce                     	andq	%r9, %r14
    3aac: 49 89 f3                     	movq	%rsi, %r11
    3aaf: 49 21 c3                     	andq	%rax, %r11
    3ab2: 4d 09 f3                     	orq	%r14, %r11
    3ab5: 4d 01 fb                     	addq	%r15, %r11
    3ab8: 4d 89 c6                     	movq	%r8, %r14
    3abb: 49 c1 c6 32                  	rolq	$0x32, %r14
    3abf: 49 01 db                     	addq	%rbx, %r11
    3ac2: 4c 89 c3                     	movq	%r8, %rbx
    3ac5: 48 c1 c3 2e                  	rolq	$0x2e, %rbx
    3ac9: 4c 31 f3                     	xorq	%r14, %rbx
    3acc: 4d 89 c6                     	movq	%r8, %r14
    3acf: 49 c1 c6 17                  	rolq	$0x17, %r14
    3ad3: 49 31 de                     	xorq	%rbx, %r14
    3ad6: 4c 89 d3                     	movq	%r10, %rbx
    3ad9: 48 31 cb                     	xorq	%rcx, %rbx
    3adc: 4c 21 c3                     	andq	%r8, %rbx
    3adf: 48 31 cb                     	xorq	%rcx, %rbx
    3ae2: 48 03 95 60 fd ff ff         	addq	-0x2a0(%rbp), %rdx
    3ae9: 48 01 da                     	addq	%rbx, %rdx
    3aec: 48 bb 2f 3b 4d ec cf fb c0 b5	movabsq	$-0x4a3f043013b2c4d1, %rbx ## imm = 0xB5C0FBCFEC4D3B2F
    3af6: 48 01 d3                     	addq	%rdx, %rbx
    3af9: 4c 01 f3                     	addq	%r14, %rbx
    3afc: 48 01 de                     	addq	%rbx, %rsi
    3aff: 4c 89 da                     	movq	%r11, %rdx
    3b02: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3b06: 4d 89 de                     	movq	%r11, %r14
    3b09: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3b0d: 49 31 d6                     	xorq	%rdx, %r14
    3b10: 4d 89 df                     	movq	%r11, %r15
    3b13: 49 c1 c7 19                  	rolq	$0x19, %r15
    3b17: 4d 31 f7                     	xorq	%r14, %r15
    3b1a: 4d 89 ce                     	movq	%r9, %r14
    3b1d: 49 09 c6                     	orq	%rax, %r14
    3b20: 4d 21 de                     	andq	%r11, %r14
    3b23: 4c 89 ca                     	movq	%r9, %rdx
    3b26: 48 21 c2                     	andq	%rax, %rdx
    3b29: 4c 09 f2                     	orq	%r14, %rdx
    3b2c: 49 89 f6                     	movq	%rsi, %r14
    3b2f: 49 c1 c6 32                  	rolq	$0x32, %r14
    3b33: 4c 01 fa                     	addq	%r15, %rdx
    3b36: 49 89 f7                     	movq	%rsi, %r15
    3b39: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3b3d: 48 01 da                     	addq	%rbx, %rdx
    3b40: 48 89 f3                     	movq	%rsi, %rbx
    3b43: 48 c1 c3 17                  	rolq	$0x17, %rbx
    3b47: 4d 31 f7                     	xorq	%r14, %r15
    3b4a: 4c 31 fb                     	xorq	%r15, %rbx
    3b4d: 4d 89 c6                     	movq	%r8, %r14
    3b50: 4d 31 d6                     	xorq	%r10, %r14
    3b53: 49 21 f6                     	andq	%rsi, %r14
    3b56: 4d 31 d6                     	xorq	%r10, %r14
    3b59: 48 03 8d 68 fd ff ff         	addq	-0x298(%rbp), %rcx
    3b60: 4c 01 f1                     	addq	%r14, %rcx
    3b63: 49 be bc db 89 81 a5 db b5 e9	movabsq	$-0x164a245a7e762444, %r14 ## imm = 0xE9B5DBA58189DBBC
    3b6d: 49 01 ce                     	addq	%rcx, %r14
    3b70: 49 01 de                     	addq	%rbx, %r14
    3b73: 48 89 d1                     	movq	%rdx, %rcx
    3b76: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3b7a: 48 89 d3                     	movq	%rdx, %rbx
    3b7d: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3b81: 48 31 cb                     	xorq	%rcx, %rbx
    3b84: 49 89 d7                     	movq	%rdx, %r15
    3b87: 49 c1 c7 19                  	rolq	$0x19, %r15
    3b8b: 49 31 df                     	xorq	%rbx, %r15
    3b8e: 4c 89 db                     	movq	%r11, %rbx
    3b91: 4c 09 cb                     	orq	%r9, %rbx
    3b94: 48 21 d3                     	andq	%rdx, %rbx
    3b97: 4c 89 d9                     	movq	%r11, %rcx
    3b9a: 4c 21 c9                     	andq	%r9, %rcx
    3b9d: 48 09 d9                     	orq	%rbx, %rcx
    3ba0: 4c 01 f9                     	addq	%r15, %rcx
    3ba3: 4c 01 f1                     	addq	%r14, %rcx
    3ba6: 49 01 c6                     	addq	%rax, %r14
    3ba9: 4c 89 f3                     	movq	%r14, %rbx
    3bac: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3bb0: 4d 89 f7                     	movq	%r14, %r15
    3bb3: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3bb7: 49 31 df                     	xorq	%rbx, %r15
    3bba: 4d 89 f4                     	movq	%r14, %r12
    3bbd: 49 c1 c4 17                  	rolq	$0x17, %r12
    3bc1: 4d 31 fc                     	xorq	%r15, %r12
    3bc4: 48 89 f3                     	movq	%rsi, %rbx
    3bc7: 4c 31 c3                     	xorq	%r8, %rbx
    3bca: 4c 21 f3                     	andq	%r14, %rbx
    3bcd: 4c 03 95 70 fd ff ff         	addq	-0x290(%rbp), %r10
    3bd4: 4c 31 c3                     	xorq	%r8, %rbx
    3bd7: 49 01 da                     	addq	%rbx, %r10
    3bda: 48 bb 38 b5 48 f3 5b c2 56 39	movabsq	$0x3956c25bf348b538, %rbx ## imm = 0x3956C25BF348B538
    3be4: 4c 01 d3                     	addq	%r10, %rbx
    3be7: 4c 01 e3                     	addq	%r12, %rbx
    3bea: 49 89 ca                     	movq	%rcx, %r10
    3bed: 49 c1 c2 24                  	rolq	$0x24, %r10
    3bf1: 49 01 d9                     	addq	%rbx, %r9
    3bf4: 49 89 cf                     	movq	%rcx, %r15
    3bf7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3bfb: 4d 31 d7                     	xorq	%r10, %r15
    3bfe: 49 89 cc                     	movq	%rcx, %r12
    3c01: 49 c1 c4 19                  	rolq	$0x19, %r12
    3c05: 4d 31 fc                     	xorq	%r15, %r12
    3c08: 49 89 d7                     	movq	%rdx, %r15
    3c0b: 4d 09 df                     	orq	%r11, %r15
    3c0e: 49 21 cf                     	andq	%rcx, %r15
    3c11: 49 89 d2                     	movq	%rdx, %r10
    3c14: 4d 21 da                     	andq	%r11, %r10
    3c17: 4d 09 fa                     	orq	%r15, %r10
    3c1a: 4d 01 e2                     	addq	%r12, %r10
    3c1d: 49 01 da                     	addq	%rbx, %r10
    3c20: 4c 89 cb                     	movq	%r9, %rbx
    3c23: 48 c1 c3 32                  	rolq	$0x32, %rbx
    3c27: 4d 89 cf                     	movq	%r9, %r15
    3c2a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3c2e: 49 31 df                     	xorq	%rbx, %r15
    3c31: 4c 89 cb                     	movq	%r9, %rbx
    3c34: 48 c1 c3 17                  	rolq	$0x17, %rbx
    3c38: 4c 31 fb                     	xorq	%r15, %rbx
    3c3b: 4d 89 f7                     	movq	%r14, %r15
    3c3e: 49 31 f7                     	xorq	%rsi, %r15
    3c41: 4d 21 cf                     	andq	%r9, %r15
    3c44: 49 31 f7                     	xorq	%rsi, %r15
    3c47: 4c 03 85 78 fd ff ff         	addq	-0x288(%rbp), %r8
    3c4e: 4d 01 f8                     	addq	%r15, %r8
    3c51: 49 bf 19 d0 05 b6 f1 11 f1 59	movabsq	$0x59f111f1b605d019, %r15 ## imm = 0x59F111F1B605D019
    3c5b: 4d 01 c7                     	addq	%r8, %r15
    3c5e: 4d 89 d0                     	movq	%r10, %r8
    3c61: 49 c1 c0 24                  	rolq	$0x24, %r8
    3c65: 49 01 df                     	addq	%rbx, %r15
    3c68: 4c 89 d3                     	movq	%r10, %rbx
    3c6b: 48 c1 c3 1e                  	rolq	$0x1e, %rbx
    3c6f: 4d 01 fb                     	addq	%r15, %r11
    3c72: 4d 89 d4                     	movq	%r10, %r12
    3c75: 49 c1 c4 19                  	rolq	$0x19, %r12
    3c79: 4c 31 c3                     	xorq	%r8, %rbx
    3c7c: 49 31 dc                     	xorq	%rbx, %r12
    3c7f: 49 89 c8                     	movq	%rcx, %r8
    3c82: 49 09 d0                     	orq	%rdx, %r8
    3c85: 4d 21 d0                     	andq	%r10, %r8
    3c88: 48 89 cb                     	movq	%rcx, %rbx
    3c8b: 48 21 d3                     	andq	%rdx, %rbx
    3c8e: 4c 09 c3                     	orq	%r8, %rbx
    3c91: 4c 01 e3                     	addq	%r12, %rbx
    3c94: 4d 89 d8                     	movq	%r11, %r8
    3c97: 49 c1 c0 32                  	rolq	$0x32, %r8
    3c9b: 4c 01 fb                     	addq	%r15, %rbx
    3c9e: 4d 89 df                     	movq	%r11, %r15
    3ca1: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3ca5: 4d 31 c7                     	xorq	%r8, %r15
    3ca8: 4d 89 dc                     	movq	%r11, %r12
    3cab: 49 c1 c4 17                  	rolq	$0x17, %r12
    3caf: 4d 31 fc                     	xorq	%r15, %r12
    3cb2: 4d 89 c8                     	movq	%r9, %r8
    3cb5: 4d 31 f0                     	xorq	%r14, %r8
    3cb8: 4d 21 d8                     	andq	%r11, %r8
    3cbb: 4d 31 f0                     	xorq	%r14, %r8
    3cbe: 48 03 b5 80 fd ff ff         	addq	-0x280(%rbp), %rsi
    3cc5: 4c 01 c6                     	addq	%r8, %rsi
    3cc8: 49 b8 9b 4f 19 af a4 82 3f 92	movabsq	$-0x6dc07d5b50e6b065, %r8 ## imm = 0x923F82A4AF194F9B
    3cd2: 49 01 f0                     	addq	%rsi, %r8
    3cd5: 4d 01 e0                     	addq	%r12, %r8
    3cd8: 4c 01 c2                     	addq	%r8, %rdx
    3cdb: 48 89 de                     	movq	%rbx, %rsi
    3cde: 48 c1 c6 24                  	rolq	$0x24, %rsi
    3ce2: 49 89 df                     	movq	%rbx, %r15
    3ce5: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3ce9: 49 31 f7                     	xorq	%rsi, %r15
    3cec: 49 89 dc                     	movq	%rbx, %r12
    3cef: 49 c1 c4 19                  	rolq	$0x19, %r12
    3cf3: 4d 31 fc                     	xorq	%r15, %r12
    3cf6: 4d 89 d7                     	movq	%r10, %r15
    3cf9: 49 09 cf                     	orq	%rcx, %r15
    3cfc: 49 21 df                     	andq	%rbx, %r15
    3cff: 4c 89 d6                     	movq	%r10, %rsi
    3d02: 48 21 ce                     	andq	%rcx, %rsi
    3d05: 4c 09 fe                     	orq	%r15, %rsi
    3d08: 49 89 d7                     	movq	%rdx, %r15
    3d0b: 49 c1 c7 32                  	rolq	$0x32, %r15
    3d0f: 4c 01 e6                     	addq	%r12, %rsi
    3d12: 49 89 d4                     	movq	%rdx, %r12
    3d15: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3d19: 4c 01 c6                     	addq	%r8, %rsi
    3d1c: 49 89 d0                     	movq	%rdx, %r8
    3d1f: 49 c1 c0 17                  	rolq	$0x17, %r8
    3d23: 4d 31 fc                     	xorq	%r15, %r12
    3d26: 4d 31 e0                     	xorq	%r12, %r8
    3d29: 4d 89 df                     	movq	%r11, %r15
    3d2c: 4d 31 cf                     	xorq	%r9, %r15
    3d2f: 49 21 d7                     	andq	%rdx, %r15
    3d32: 4d 31 cf                     	xorq	%r9, %r15
    3d35: 4c 03 b5 88 fd ff ff         	addq	-0x278(%rbp), %r14
    3d3c: 4d 01 fe                     	addq	%r15, %r14
    3d3f: 49 bf 18 81 6d da d5 5e 1c ab	movabsq	$-0x54e3a12a25927ee8, %r15 ## imm = 0xAB1C5ED5DA6D8118
    3d49: 4d 01 f7                     	addq	%r14, %r15
    3d4c: 4d 01 c7                     	addq	%r8, %r15
    3d4f: 4c 01 f9                     	addq	%r15, %rcx
    3d52: 49 89 f0                     	movq	%rsi, %r8
    3d55: 49 c1 c0 24                  	rolq	$0x24, %r8
    3d59: 49 89 f6                     	movq	%rsi, %r14
    3d5c: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3d60: 4d 31 c6                     	xorq	%r8, %r14
    3d63: 49 89 f4                     	movq	%rsi, %r12
    3d66: 49 c1 c4 19                  	rolq	$0x19, %r12
    3d6a: 4d 31 f4                     	xorq	%r14, %r12
    3d6d: 49 89 de                     	movq	%rbx, %r14
    3d70: 4d 09 d6                     	orq	%r10, %r14
    3d73: 49 21 f6                     	andq	%rsi, %r14
    3d76: 49 89 d8                     	movq	%rbx, %r8
    3d79: 4d 21 d0                     	andq	%r10, %r8
    3d7c: 4d 09 f0                     	orq	%r14, %r8
    3d7f: 4d 01 e0                     	addq	%r12, %r8
    3d82: 4d 01 f8                     	addq	%r15, %r8
    3d85: 49 89 ce                     	movq	%rcx, %r14
    3d88: 49 c1 c6 32                  	rolq	$0x32, %r14
    3d8c: 49 89 cf                     	movq	%rcx, %r15
    3d8f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3d93: 4d 31 f7                     	xorq	%r14, %r15
    3d96: 49 89 cc                     	movq	%rcx, %r12
    3d99: 49 c1 c4 17                  	rolq	$0x17, %r12
    3d9d: 4d 31 fc                     	xorq	%r15, %r12
    3da0: 49 89 d6                     	movq	%rdx, %r14
    3da3: 4d 31 de                     	xorq	%r11, %r14
    3da6: 49 21 ce                     	andq	%rcx, %r14
    3da9: 4c 03 8d 90 fd ff ff         	addq	-0x270(%rbp), %r9
    3db0: 4d 31 de                     	xorq	%r11, %r14
    3db3: 4d 01 f1                     	addq	%r14, %r9
    3db6: 49 be 42 02 03 a3 98 aa 07 d8	movabsq	$-0x27f855675cfcfdbe, %r14 ## imm = 0xD807AA98A3030242
    3dc0: 4d 01 ce                     	addq	%r9, %r14
    3dc3: 4d 01 e6                     	addq	%r12, %r14
    3dc6: 4d 89 c1                     	movq	%r8, %r9
    3dc9: 49 c1 c1 24                  	rolq	$0x24, %r9
    3dcd: 4d 01 f2                     	addq	%r14, %r10
    3dd0: 4d 89 c7                     	movq	%r8, %r15
    3dd3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3dd7: 4d 31 cf                     	xorq	%r9, %r15
    3dda: 4d 89 c4                     	movq	%r8, %r12
    3ddd: 49 c1 c4 19                  	rolq	$0x19, %r12
    3de1: 4d 31 fc                     	xorq	%r15, %r12
    3de4: 49 89 f7                     	movq	%rsi, %r15
    3de7: 49 09 df                     	orq	%rbx, %r15
    3dea: 4d 21 c7                     	andq	%r8, %r15
    3ded: 49 89 f1                     	movq	%rsi, %r9
    3df0: 49 21 d9                     	andq	%rbx, %r9
    3df3: 4d 09 f9                     	orq	%r15, %r9
    3df6: 4d 01 e1                     	addq	%r12, %r9
    3df9: 4d 01 f1                     	addq	%r14, %r9
    3dfc: 4d 89 d6                     	movq	%r10, %r14
    3dff: 49 c1 c6 32                  	rolq	$0x32, %r14
    3e03: 4d 89 d7                     	movq	%r10, %r15
    3e06: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3e0a: 4d 31 f7                     	xorq	%r14, %r15
    3e0d: 4d 89 d4                     	movq	%r10, %r12
    3e10: 49 c1 c4 17                  	rolq	$0x17, %r12
    3e14: 4d 31 fc                     	xorq	%r15, %r12
    3e17: 49 89 ce                     	movq	%rcx, %r14
    3e1a: 49 31 d6                     	xorq	%rdx, %r14
    3e1d: 4d 21 d6                     	andq	%r10, %r14
    3e20: 49 31 d6                     	xorq	%rdx, %r14
    3e23: 4c 03 9d 98 fd ff ff         	addq	-0x268(%rbp), %r11
    3e2a: 4d 01 f3                     	addq	%r14, %r11
    3e2d: 49 be be 6f 70 45 01 5b 83 12	movabsq	$0x12835b0145706fbe, %r14 ## imm = 0x12835B0145706FBE
    3e37: 4d 01 de                     	addq	%r11, %r14
    3e3a: 4d 89 cb                     	movq	%r9, %r11
    3e3d: 49 c1 c3 24                  	rolq	$0x24, %r11
    3e41: 4d 01 e6                     	addq	%r12, %r14
    3e44: 4d 89 cf                     	movq	%r9, %r15
    3e47: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3e4b: 4c 01 f3                     	addq	%r14, %rbx
    3e4e: 4d 89 cc                     	movq	%r9, %r12
    3e51: 49 c1 c4 19                  	rolq	$0x19, %r12
    3e55: 4d 31 df                     	xorq	%r11, %r15
    3e58: 4d 31 fc                     	xorq	%r15, %r12
    3e5b: 4d 89 c7                     	movq	%r8, %r15
    3e5e: 49 09 f7                     	orq	%rsi, %r15
    3e61: 4d 21 cf                     	andq	%r9, %r15
    3e64: 4d 89 c3                     	movq	%r8, %r11
    3e67: 49 21 f3                     	andq	%rsi, %r11
    3e6a: 4d 09 fb                     	orq	%r15, %r11
    3e6d: 4d 01 e3                     	addq	%r12, %r11
    3e70: 49 89 df                     	movq	%rbx, %r15
    3e73: 49 c1 c7 32                  	rolq	$0x32, %r15
    3e77: 4d 01 f3                     	addq	%r14, %r11
    3e7a: 49 89 de                     	movq	%rbx, %r14
    3e7d: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    3e81: 4d 31 fe                     	xorq	%r15, %r14
    3e84: 49 89 df                     	movq	%rbx, %r15
    3e87: 49 c1 c7 17                  	rolq	$0x17, %r15
    3e8b: 4d 31 f7                     	xorq	%r14, %r15
    3e8e: 4d 89 d6                     	movq	%r10, %r14
    3e91: 49 31 ce                     	xorq	%rcx, %r14
    3e94: 49 21 de                     	andq	%rbx, %r14
    3e97: 49 31 ce                     	xorq	%rcx, %r14
    3e9a: 48 03 95 a0 fd ff ff         	addq	-0x260(%rbp), %rdx
    3ea1: 4c 01 f2                     	addq	%r14, %rdx
    3ea4: 49 be 8c b2 e4 4e be 85 31 24	movabsq	$0x243185be4ee4b28c, %r14 ## imm = 0x243185BE4EE4B28C
    3eae: 49 01 d6                     	addq	%rdx, %r14
    3eb1: 4d 01 fe                     	addq	%r15, %r14
    3eb4: 4c 01 f6                     	addq	%r14, %rsi
    3eb7: 4c 89 da                     	movq	%r11, %rdx
    3eba: 48 c1 c2 24                  	rolq	$0x24, %rdx
    3ebe: 4d 89 df                     	movq	%r11, %r15
    3ec1: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3ec5: 49 31 d7                     	xorq	%rdx, %r15
    3ec8: 4d 89 dc                     	movq	%r11, %r12
    3ecb: 49 c1 c4 19                  	rolq	$0x19, %r12
    3ecf: 4d 31 fc                     	xorq	%r15, %r12
    3ed2: 4d 89 cf                     	movq	%r9, %r15
    3ed5: 4d 09 c7                     	orq	%r8, %r15
    3ed8: 4d 21 df                     	andq	%r11, %r15
    3edb: 4c 89 ca                     	movq	%r9, %rdx
    3ede: 4c 21 c2                     	andq	%r8, %rdx
    3ee1: 4c 09 fa                     	orq	%r15, %rdx
    3ee4: 49 89 f7                     	movq	%rsi, %r15
    3ee7: 49 c1 c7 32                  	rolq	$0x32, %r15
    3eeb: 4c 01 e2                     	addq	%r12, %rdx
    3eee: 49 89 f4                     	movq	%rsi, %r12
    3ef1: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    3ef5: 4c 01 f2                     	addq	%r14, %rdx
    3ef8: 49 89 f6                     	movq	%rsi, %r14
    3efb: 49 c1 c6 17                  	rolq	$0x17, %r14
    3eff: 4d 31 fc                     	xorq	%r15, %r12
    3f02: 4d 31 e6                     	xorq	%r12, %r14
    3f05: 49 89 df                     	movq	%rbx, %r15
    3f08: 4d 31 d7                     	xorq	%r10, %r15
    3f0b: 49 21 f7                     	andq	%rsi, %r15
    3f0e: 4d 31 d7                     	xorq	%r10, %r15
    3f11: 48 03 8d a8 fd ff ff         	addq	-0x258(%rbp), %rcx
    3f18: 4c 01 f9                     	addq	%r15, %rcx
    3f1b: 49 bf e2 b4 ff d5 c3 7d 0c 55	movabsq	$0x550c7dc3d5ffb4e2, %r15 ## imm = 0x550C7DC3D5FFB4E2
    3f25: 49 01 cf                     	addq	%rcx, %r15
    3f28: 4d 01 f7                     	addq	%r14, %r15
    3f2b: 4d 01 f8                     	addq	%r15, %r8
    3f2e: 48 89 d1                     	movq	%rdx, %rcx
    3f31: 48 c1 c1 24                  	rolq	$0x24, %rcx
    3f35: 49 89 d6                     	movq	%rdx, %r14
    3f38: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    3f3c: 49 31 ce                     	xorq	%rcx, %r14
    3f3f: 49 89 d4                     	movq	%rdx, %r12
    3f42: 49 c1 c4 19                  	rolq	$0x19, %r12
    3f46: 4d 31 f4                     	xorq	%r14, %r12
    3f49: 4d 89 de                     	movq	%r11, %r14
    3f4c: 4d 09 ce                     	orq	%r9, %r14
    3f4f: 49 21 d6                     	andq	%rdx, %r14
    3f52: 4c 89 d9                     	movq	%r11, %rcx
    3f55: 4c 21 c9                     	andq	%r9, %rcx
    3f58: 4c 09 f1                     	orq	%r14, %rcx
    3f5b: 4c 01 e1                     	addq	%r12, %rcx
    3f5e: 4c 01 f9                     	addq	%r15, %rcx
    3f61: 4d 89 c6                     	movq	%r8, %r14
    3f64: 49 c1 c6 32                  	rolq	$0x32, %r14
    3f68: 4d 89 c7                     	movq	%r8, %r15
    3f6b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3f6f: 4d 31 f7                     	xorq	%r14, %r15
    3f72: 4d 89 c4                     	movq	%r8, %r12
    3f75: 49 c1 c4 17                  	rolq	$0x17, %r12
    3f79: 4d 31 fc                     	xorq	%r15, %r12
    3f7c: 49 89 f6                     	movq	%rsi, %r14
    3f7f: 49 31 de                     	xorq	%rbx, %r14
    3f82: 4d 21 c6                     	andq	%r8, %r14
    3f85: 4c 03 95 b0 fd ff ff         	addq	-0x250(%rbp), %r10
    3f8c: 49 31 de                     	xorq	%rbx, %r14
    3f8f: 4d 01 f2                     	addq	%r14, %r10
    3f92: 49 be 6f 89 7b f2 74 5d be 72	movabsq	$0x72be5d74f27b896f, %r14 ## imm = 0x72BE5D74F27B896F
    3f9c: 4d 01 d6                     	addq	%r10, %r14
    3f9f: 4d 01 e6                     	addq	%r12, %r14
    3fa2: 49 89 ca                     	movq	%rcx, %r10
    3fa5: 49 c1 c2 24                  	rolq	$0x24, %r10
    3fa9: 4d 01 f1                     	addq	%r14, %r9
    3fac: 49 89 cf                     	movq	%rcx, %r15
    3faf: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    3fb3: 4d 31 d7                     	xorq	%r10, %r15
    3fb6: 49 89 cc                     	movq	%rcx, %r12
    3fb9: 49 c1 c4 19                  	rolq	$0x19, %r12
    3fbd: 4d 31 fc                     	xorq	%r15, %r12
    3fc0: 49 89 d7                     	movq	%rdx, %r15
    3fc3: 4d 09 df                     	orq	%r11, %r15
    3fc6: 49 21 cf                     	andq	%rcx, %r15
    3fc9: 49 89 d2                     	movq	%rdx, %r10
    3fcc: 4d 21 da                     	andq	%r11, %r10
    3fcf: 4d 09 fa                     	orq	%r15, %r10
    3fd2: 4d 01 e2                     	addq	%r12, %r10
    3fd5: 4d 01 f2                     	addq	%r14, %r10
    3fd8: 4d 89 ce                     	movq	%r9, %r14
    3fdb: 49 c1 c6 32                  	rolq	$0x32, %r14
    3fdf: 4d 89 cf                     	movq	%r9, %r15
    3fe2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    3fe6: 4d 31 f7                     	xorq	%r14, %r15
    3fe9: 4d 89 cc                     	movq	%r9, %r12
    3fec: 49 c1 c4 17                  	rolq	$0x17, %r12
    3ff0: 4d 31 fc                     	xorq	%r15, %r12
    3ff3: 4d 89 c6                     	movq	%r8, %r14
    3ff6: 49 31 f6                     	xorq	%rsi, %r14
    3ff9: 4d 21 ce                     	andq	%r9, %r14
    3ffc: 49 31 f6                     	xorq	%rsi, %r14
    3fff: 48 03 9d b8 fd ff ff         	addq	-0x248(%rbp), %rbx
    4006: 4c 01 f3                     	addq	%r14, %rbx
    4009: 49 be b1 96 16 3b fe b1 de 80	movabsq	$-0x7f214e01c4e9694f, %r14 ## imm = 0x80DEB1FE3B1696B1
    4013: 49 01 de                     	addq	%rbx, %r14
    4016: 4c 89 d3                     	movq	%r10, %rbx
    4019: 48 c1 c3 24                  	rolq	$0x24, %rbx
    401d: 4d 01 e6                     	addq	%r12, %r14
    4020: 4d 89 d7                     	movq	%r10, %r15
    4023: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4027: 4d 01 f3                     	addq	%r14, %r11
    402a: 4d 89 d4                     	movq	%r10, %r12
    402d: 49 c1 c4 19                  	rolq	$0x19, %r12
    4031: 49 31 df                     	xorq	%rbx, %r15
    4034: 4d 31 fc                     	xorq	%r15, %r12
    4037: 49 89 cf                     	movq	%rcx, %r15
    403a: 49 09 d7                     	orq	%rdx, %r15
    403d: 4d 21 d7                     	andq	%r10, %r15
    4040: 48 89 cb                     	movq	%rcx, %rbx
    4043: 48 21 d3                     	andq	%rdx, %rbx
    4046: 4c 09 fb                     	orq	%r15, %rbx
    4049: 4c 01 e3                     	addq	%r12, %rbx
    404c: 4d 89 df                     	movq	%r11, %r15
    404f: 49 c1 c7 32                  	rolq	$0x32, %r15
    4053: 4c 01 f3                     	addq	%r14, %rbx
    4056: 4d 89 de                     	movq	%r11, %r14
    4059: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    405d: 4d 31 fe                     	xorq	%r15, %r14
    4060: 4d 89 df                     	movq	%r11, %r15
    4063: 49 c1 c7 17                  	rolq	$0x17, %r15
    4067: 4d 31 f7                     	xorq	%r14, %r15
    406a: 4d 89 ce                     	movq	%r9, %r14
    406d: 4d 31 c6                     	xorq	%r8, %r14
    4070: 4d 21 de                     	andq	%r11, %r14
    4073: 4d 31 c6                     	xorq	%r8, %r14
    4076: 48 03 b5 c0 fd ff ff         	addq	-0x240(%rbp), %rsi
    407d: 4c 01 f6                     	addq	%r14, %rsi
    4080: 49 be 35 12 c7 25 a7 06 dc 9b	movabsq	$-0x6423f958da38edcb, %r14 ## imm = 0x9BDC06A725C71235
    408a: 49 01 f6                     	addq	%rsi, %r14
    408d: 4d 01 fe                     	addq	%r15, %r14
    4090: 4c 01 f2                     	addq	%r14, %rdx
    4093: 48 89 de                     	movq	%rbx, %rsi
    4096: 48 c1 c6 24                  	rolq	$0x24, %rsi
    409a: 49 89 df                     	movq	%rbx, %r15
    409d: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    40a1: 49 31 f7                     	xorq	%rsi, %r15
    40a4: 49 89 dc                     	movq	%rbx, %r12
    40a7: 49 c1 c4 19                  	rolq	$0x19, %r12
    40ab: 4d 31 fc                     	xorq	%r15, %r12
    40ae: 4d 89 d7                     	movq	%r10, %r15
    40b1: 49 09 cf                     	orq	%rcx, %r15
    40b4: 49 21 df                     	andq	%rbx, %r15
    40b7: 4c 89 d6                     	movq	%r10, %rsi
    40ba: 48 21 ce                     	andq	%rcx, %rsi
    40bd: 4c 09 fe                     	orq	%r15, %rsi
    40c0: 49 89 d7                     	movq	%rdx, %r15
    40c3: 49 c1 c7 32                  	rolq	$0x32, %r15
    40c7: 4c 01 e6                     	addq	%r12, %rsi
    40ca: 49 89 d4                     	movq	%rdx, %r12
    40cd: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    40d1: 4c 01 f6                     	addq	%r14, %rsi
    40d4: 49 89 d6                     	movq	%rdx, %r14
    40d7: 49 c1 c6 17                  	rolq	$0x17, %r14
    40db: 4d 31 fc                     	xorq	%r15, %r12
    40de: 4d 31 e6                     	xorq	%r12, %r14
    40e1: 4d 89 df                     	movq	%r11, %r15
    40e4: 4d 31 cf                     	xorq	%r9, %r15
    40e7: 49 21 d7                     	andq	%rdx, %r15
    40ea: 4d 31 cf                     	xorq	%r9, %r15
    40ed: 4c 03 85 c8 fd ff ff         	addq	-0x238(%rbp), %r8
    40f4: 4d 01 f8                     	addq	%r15, %r8
    40f7: 49 bf 94 26 69 cf 74 f1 9b c1	movabsq	$-0x3e640e8b3096d96c, %r15 ## imm = 0xC19BF174CF692694
    4101: 4d 01 c7                     	addq	%r8, %r15
    4104: 4d 01 f7                     	addq	%r14, %r15
    4107: 4c 01 f9                     	addq	%r15, %rcx
    410a: 49 89 f0                     	movq	%rsi, %r8
    410d: 49 c1 c0 24                  	rolq	$0x24, %r8
    4111: 49 89 f6                     	movq	%rsi, %r14
    4114: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4118: 4d 31 c6                     	xorq	%r8, %r14
    411b: 49 89 f4                     	movq	%rsi, %r12
    411e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4122: 4d 31 f4                     	xorq	%r14, %r12
    4125: 49 89 de                     	movq	%rbx, %r14
    4128: 4d 09 d6                     	orq	%r10, %r14
    412b: 49 21 f6                     	andq	%rsi, %r14
    412e: 49 89 d8                     	movq	%rbx, %r8
    4131: 4d 21 d0                     	andq	%r10, %r8
    4134: 4d 09 f0                     	orq	%r14, %r8
    4137: 4d 01 e0                     	addq	%r12, %r8
    413a: 4d 01 f8                     	addq	%r15, %r8
    413d: 49 89 ce                     	movq	%rcx, %r14
    4140: 49 c1 c6 32                  	rolq	$0x32, %r14
    4144: 49 89 cf                     	movq	%rcx, %r15
    4147: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    414b: 4d 31 f7                     	xorq	%r14, %r15
    414e: 49 89 cc                     	movq	%rcx, %r12
    4151: 49 c1 c4 17                  	rolq	$0x17, %r12
    4155: 4d 31 fc                     	xorq	%r15, %r12
    4158: 49 89 d6                     	movq	%rdx, %r14
    415b: 4d 31 de                     	xorq	%r11, %r14
    415e: 49 21 ce                     	andq	%rcx, %r14
    4161: 4c 03 8d d0 fd ff ff         	addq	-0x230(%rbp), %r9
    4168: 4d 31 de                     	xorq	%r11, %r14
    416b: 4d 01 f1                     	addq	%r14, %r9
    416e: 49 be d2 4a f1 9e c1 69 9b e4	movabsq	$-0x1b64963e610eb52e, %r14 ## imm = 0xE49B69C19EF14AD2
    4178: 4d 01 ce                     	addq	%r9, %r14
    417b: 4d 01 e6                     	addq	%r12, %r14
    417e: 4d 89 c1                     	movq	%r8, %r9
    4181: 49 c1 c1 24                  	rolq	$0x24, %r9
    4185: 4d 01 f2                     	addq	%r14, %r10
    4188: 4d 89 c7                     	movq	%r8, %r15
    418b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    418f: 4d 31 cf                     	xorq	%r9, %r15
    4192: 4d 89 c4                     	movq	%r8, %r12
    4195: 49 c1 c4 19                  	rolq	$0x19, %r12
    4199: 4d 31 fc                     	xorq	%r15, %r12
    419c: 49 89 f7                     	movq	%rsi, %r15
    419f: 49 09 df                     	orq	%rbx, %r15
    41a2: 4d 21 c7                     	andq	%r8, %r15
    41a5: 49 89 f1                     	movq	%rsi, %r9
    41a8: 49 21 d9                     	andq	%rbx, %r9
    41ab: 4d 09 f9                     	orq	%r15, %r9
    41ae: 4d 01 e1                     	addq	%r12, %r9
    41b1: 4d 01 f1                     	addq	%r14, %r9
    41b4: 4d 89 d6                     	movq	%r10, %r14
    41b7: 49 c1 c6 32                  	rolq	$0x32, %r14
    41bb: 4d 89 d7                     	movq	%r10, %r15
    41be: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    41c2: 4d 31 f7                     	xorq	%r14, %r15
    41c5: 4d 89 d4                     	movq	%r10, %r12
    41c8: 49 c1 c4 17                  	rolq	$0x17, %r12
    41cc: 4d 31 fc                     	xorq	%r15, %r12
    41cf: 49 89 ce                     	movq	%rcx, %r14
    41d2: 49 31 d6                     	xorq	%rdx, %r14
    41d5: 4d 21 d6                     	andq	%r10, %r14
    41d8: 49 31 d6                     	xorq	%rdx, %r14
    41db: 4c 03 9d d8 fd ff ff         	addq	-0x228(%rbp), %r11
    41e2: 4d 01 f3                     	addq	%r14, %r11
    41e5: 49 be e3 25 4f 38 86 47 be ef	movabsq	$-0x1041b879c7b0da1d, %r14 ## imm = 0xEFBE4786384F25E3
    41ef: 4d 01 de                     	addq	%r11, %r14
    41f2: 4d 89 cb                     	movq	%r9, %r11
    41f5: 49 c1 c3 24                  	rolq	$0x24, %r11
    41f9: 4d 01 e6                     	addq	%r12, %r14
    41fc: 4d 89 cf                     	movq	%r9, %r15
    41ff: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4203: 4c 01 f3                     	addq	%r14, %rbx
    4206: 4d 89 cc                     	movq	%r9, %r12
    4209: 49 c1 c4 19                  	rolq	$0x19, %r12
    420d: 4d 31 df                     	xorq	%r11, %r15
    4210: 4d 31 fc                     	xorq	%r15, %r12
    4213: 4d 89 c7                     	movq	%r8, %r15
    4216: 49 09 f7                     	orq	%rsi, %r15
    4219: 4d 21 cf                     	andq	%r9, %r15
    421c: 4d 89 c3                     	movq	%r8, %r11
    421f: 49 21 f3                     	andq	%rsi, %r11
    4222: 4d 09 fb                     	orq	%r15, %r11
    4225: 4d 01 e3                     	addq	%r12, %r11
    4228: 49 89 df                     	movq	%rbx, %r15
    422b: 49 c1 c7 32                  	rolq	$0x32, %r15
    422f: 4d 01 f3                     	addq	%r14, %r11
    4232: 49 89 de                     	movq	%rbx, %r14
    4235: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4239: 4d 31 fe                     	xorq	%r15, %r14
    423c: 49 89 df                     	movq	%rbx, %r15
    423f: 49 c1 c7 17                  	rolq	$0x17, %r15
    4243: 4d 31 f7                     	xorq	%r14, %r15
    4246: 4d 89 d6                     	movq	%r10, %r14
    4249: 49 31 ce                     	xorq	%rcx, %r14
    424c: 49 21 de                     	andq	%rbx, %r14
    424f: 49 31 ce                     	xorq	%rcx, %r14
    4252: 48 03 95 e0 fd ff ff         	addq	-0x220(%rbp), %rdx
    4259: 4c 01 f2                     	addq	%r14, %rdx
    425c: 49 be b5 d5 8c 8b c6 9d c1 0f	movabsq	$0xfc19dc68b8cd5b5, %r14 ## imm = 0xFC19DC68B8CD5B5
    4266: 49 01 d6                     	addq	%rdx, %r14
    4269: 4d 01 fe                     	addq	%r15, %r14
    426c: 4c 01 f6                     	addq	%r14, %rsi
    426f: 4c 89 da                     	movq	%r11, %rdx
    4272: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4276: 4d 89 df                     	movq	%r11, %r15
    4279: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    427d: 49 31 d7                     	xorq	%rdx, %r15
    4280: 4d 89 dc                     	movq	%r11, %r12
    4283: 49 c1 c4 19                  	rolq	$0x19, %r12
    4287: 4d 31 fc                     	xorq	%r15, %r12
    428a: 4d 89 cf                     	movq	%r9, %r15
    428d: 4d 09 c7                     	orq	%r8, %r15
    4290: 4d 21 df                     	andq	%r11, %r15
    4293: 4c 89 ca                     	movq	%r9, %rdx
    4296: 4c 21 c2                     	andq	%r8, %rdx
    4299: 4c 09 fa                     	orq	%r15, %rdx
    429c: 49 89 f7                     	movq	%rsi, %r15
    429f: 49 c1 c7 32                  	rolq	$0x32, %r15
    42a3: 4c 01 e2                     	addq	%r12, %rdx
    42a6: 49 89 f4                     	movq	%rsi, %r12
    42a9: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    42ad: 4c 01 f2                     	addq	%r14, %rdx
    42b0: 49 89 f6                     	movq	%rsi, %r14
    42b3: 49 c1 c6 17                  	rolq	$0x17, %r14
    42b7: 4d 31 fc                     	xorq	%r15, %r12
    42ba: 4d 31 e6                     	xorq	%r12, %r14
    42bd: 49 89 df                     	movq	%rbx, %r15
    42c0: 4d 31 d7                     	xorq	%r10, %r15
    42c3: 49 21 f7                     	andq	%rsi, %r15
    42c6: 4d 31 d7                     	xorq	%r10, %r15
    42c9: 48 03 8d e8 fd ff ff         	addq	-0x218(%rbp), %rcx
    42d0: 4c 01 f9                     	addq	%r15, %rcx
    42d3: 49 bf 65 9c ac 77 cc a1 0c 24	movabsq	$0x240ca1cc77ac9c65, %r15 ## imm = 0x240CA1CC77AC9C65
    42dd: 49 01 cf                     	addq	%rcx, %r15
    42e0: 4d 01 f7                     	addq	%r14, %r15
    42e3: 4d 01 f8                     	addq	%r15, %r8
    42e6: 48 89 d1                     	movq	%rdx, %rcx
    42e9: 48 c1 c1 24                  	rolq	$0x24, %rcx
    42ed: 49 89 d6                     	movq	%rdx, %r14
    42f0: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    42f4: 49 31 ce                     	xorq	%rcx, %r14
    42f7: 49 89 d4                     	movq	%rdx, %r12
    42fa: 49 c1 c4 19                  	rolq	$0x19, %r12
    42fe: 4d 31 f4                     	xorq	%r14, %r12
    4301: 4d 89 de                     	movq	%r11, %r14
    4304: 4d 09 ce                     	orq	%r9, %r14
    4307: 49 21 d6                     	andq	%rdx, %r14
    430a: 4c 89 d9                     	movq	%r11, %rcx
    430d: 4c 21 c9                     	andq	%r9, %rcx
    4310: 4c 09 f1                     	orq	%r14, %rcx
    4313: 4c 01 e1                     	addq	%r12, %rcx
    4316: 4c 01 f9                     	addq	%r15, %rcx
    4319: 4d 89 c6                     	movq	%r8, %r14
    431c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4320: 4d 89 c7                     	movq	%r8, %r15
    4323: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4327: 4d 31 f7                     	xorq	%r14, %r15
    432a: 4d 89 c4                     	movq	%r8, %r12
    432d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4331: 4d 31 fc                     	xorq	%r15, %r12
    4334: 49 89 f6                     	movq	%rsi, %r14
    4337: 49 31 de                     	xorq	%rbx, %r14
    433a: 4d 21 c6                     	andq	%r8, %r14
    433d: 4c 03 95 f0 fd ff ff         	addq	-0x210(%rbp), %r10
    4344: 49 31 de                     	xorq	%rbx, %r14
    4347: 4d 01 f2                     	addq	%r14, %r10
    434a: 49 be 75 02 2b 59 6f 2c e9 2d	movabsq	$0x2de92c6f592b0275, %r14 ## imm = 0x2DE92C6F592B0275
    4354: 4d 01 d6                     	addq	%r10, %r14
    4357: 4d 01 e6                     	addq	%r12, %r14
    435a: 49 89 ca                     	movq	%rcx, %r10
    435d: 49 c1 c2 24                  	rolq	$0x24, %r10
    4361: 4d 01 f1                     	addq	%r14, %r9
    4364: 49 89 cf                     	movq	%rcx, %r15
    4367: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    436b: 4d 31 d7                     	xorq	%r10, %r15
    436e: 49 89 cc                     	movq	%rcx, %r12
    4371: 49 c1 c4 19                  	rolq	$0x19, %r12
    4375: 4d 31 fc                     	xorq	%r15, %r12
    4378: 49 89 d7                     	movq	%rdx, %r15
    437b: 4d 09 df                     	orq	%r11, %r15
    437e: 49 21 cf                     	andq	%rcx, %r15
    4381: 49 89 d2                     	movq	%rdx, %r10
    4384: 4d 21 da                     	andq	%r11, %r10
    4387: 4d 09 fa                     	orq	%r15, %r10
    438a: 4d 01 e2                     	addq	%r12, %r10
    438d: 4d 01 f2                     	addq	%r14, %r10
    4390: 4d 89 ce                     	movq	%r9, %r14
    4393: 49 c1 c6 32                  	rolq	$0x32, %r14
    4397: 4d 89 cf                     	movq	%r9, %r15
    439a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    439e: 4d 31 f7                     	xorq	%r14, %r15
    43a1: 4d 89 cc                     	movq	%r9, %r12
    43a4: 49 c1 c4 17                  	rolq	$0x17, %r12
    43a8: 4d 31 fc                     	xorq	%r15, %r12
    43ab: 4d 89 c6                     	movq	%r8, %r14
    43ae: 49 31 f6                     	xorq	%rsi, %r14
    43b1: 4d 21 ce                     	andq	%r9, %r14
    43b4: 49 31 f6                     	xorq	%rsi, %r14
    43b7: 48 03 9d f8 fd ff ff         	addq	-0x208(%rbp), %rbx
    43be: 4c 01 f3                     	addq	%r14, %rbx
    43c1: 49 be 83 e4 a6 6e aa 84 74 4a	movabsq	$0x4a7484aa6ea6e483, %r14 ## imm = 0x4A7484AA6EA6E483
    43cb: 49 01 de                     	addq	%rbx, %r14
    43ce: 4c 89 d3                     	movq	%r10, %rbx
    43d1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    43d5: 4d 01 e6                     	addq	%r12, %r14
    43d8: 4d 89 d7                     	movq	%r10, %r15
    43db: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    43df: 4d 01 f3                     	addq	%r14, %r11
    43e2: 4d 89 d4                     	movq	%r10, %r12
    43e5: 49 c1 c4 19                  	rolq	$0x19, %r12
    43e9: 49 31 df                     	xorq	%rbx, %r15
    43ec: 4d 31 fc                     	xorq	%r15, %r12
    43ef: 49 89 cf                     	movq	%rcx, %r15
    43f2: 49 09 d7                     	orq	%rdx, %r15
    43f5: 4d 21 d7                     	andq	%r10, %r15
    43f8: 48 89 cb                     	movq	%rcx, %rbx
    43fb: 48 21 d3                     	andq	%rdx, %rbx
    43fe: 4c 09 fb                     	orq	%r15, %rbx
    4401: 4c 01 e3                     	addq	%r12, %rbx
    4404: 4d 89 df                     	movq	%r11, %r15
    4407: 49 c1 c7 32                  	rolq	$0x32, %r15
    440b: 4c 01 f3                     	addq	%r14, %rbx
    440e: 4d 89 de                     	movq	%r11, %r14
    4411: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4415: 4d 31 fe                     	xorq	%r15, %r14
    4418: 4d 89 df                     	movq	%r11, %r15
    441b: 49 c1 c7 17                  	rolq	$0x17, %r15
    441f: 4d 31 f7                     	xorq	%r14, %r15
    4422: 4d 89 ce                     	movq	%r9, %r14
    4425: 4d 31 c6                     	xorq	%r8, %r14
    4428: 4d 21 de                     	andq	%r11, %r14
    442b: 4d 31 c6                     	xorq	%r8, %r14
    442e: 48 03 b5 00 fe ff ff         	addq	-0x200(%rbp), %rsi
    4435: 4c 01 f6                     	addq	%r14, %rsi
    4438: 49 be d4 fb 41 bd dc a9 b0 5c	movabsq	$0x5cb0a9dcbd41fbd4, %r14 ## imm = 0x5CB0A9DCBD41FBD4
    4442: 49 01 f6                     	addq	%rsi, %r14
    4445: 4d 01 fe                     	addq	%r15, %r14
    4448: 4c 01 f2                     	addq	%r14, %rdx
    444b: 48 89 de                     	movq	%rbx, %rsi
    444e: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4452: 49 89 df                     	movq	%rbx, %r15
    4455: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4459: 49 31 f7                     	xorq	%rsi, %r15
    445c: 49 89 dc                     	movq	%rbx, %r12
    445f: 49 c1 c4 19                  	rolq	$0x19, %r12
    4463: 4d 31 fc                     	xorq	%r15, %r12
    4466: 4d 89 d7                     	movq	%r10, %r15
    4469: 49 09 cf                     	orq	%rcx, %r15
    446c: 49 21 df                     	andq	%rbx, %r15
    446f: 4c 89 d6                     	movq	%r10, %rsi
    4472: 48 21 ce                     	andq	%rcx, %rsi
    4475: 4c 09 fe                     	orq	%r15, %rsi
    4478: 49 89 d7                     	movq	%rdx, %r15
    447b: 49 c1 c7 32                  	rolq	$0x32, %r15
    447f: 4c 01 e6                     	addq	%r12, %rsi
    4482: 49 89 d4                     	movq	%rdx, %r12
    4485: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4489: 4c 01 f6                     	addq	%r14, %rsi
    448c: 49 89 d6                     	movq	%rdx, %r14
    448f: 49 c1 c6 17                  	rolq	$0x17, %r14
    4493: 4d 31 fc                     	xorq	%r15, %r12
    4496: 4d 31 e6                     	xorq	%r12, %r14
    4499: 4d 89 df                     	movq	%r11, %r15
    449c: 4d 31 cf                     	xorq	%r9, %r15
    449f: 49 21 d7                     	andq	%rdx, %r15
    44a2: 4d 31 cf                     	xorq	%r9, %r15
    44a5: 4c 03 85 08 fe ff ff         	addq	-0x1f8(%rbp), %r8
    44ac: 4d 01 f8                     	addq	%r15, %r8
    44af: 49 bf b5 53 11 83 da 88 f9 76	movabsq	$0x76f988da831153b5, %r15 ## imm = 0x76F988DA831153B5
    44b9: 4d 01 c7                     	addq	%r8, %r15
    44bc: 4d 01 f7                     	addq	%r14, %r15
    44bf: 4c 01 f9                     	addq	%r15, %rcx
    44c2: 49 89 f0                     	movq	%rsi, %r8
    44c5: 49 c1 c0 24                  	rolq	$0x24, %r8
    44c9: 49 89 f6                     	movq	%rsi, %r14
    44cc: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    44d0: 4d 31 c6                     	xorq	%r8, %r14
    44d3: 49 89 f4                     	movq	%rsi, %r12
    44d6: 49 c1 c4 19                  	rolq	$0x19, %r12
    44da: 4d 31 f4                     	xorq	%r14, %r12
    44dd: 49 89 de                     	movq	%rbx, %r14
    44e0: 4d 09 d6                     	orq	%r10, %r14
    44e3: 49 21 f6                     	andq	%rsi, %r14
    44e6: 49 89 d8                     	movq	%rbx, %r8
    44e9: 4d 21 d0                     	andq	%r10, %r8
    44ec: 4d 09 f0                     	orq	%r14, %r8
    44ef: 4d 01 e0                     	addq	%r12, %r8
    44f2: 4d 01 f8                     	addq	%r15, %r8
    44f5: 49 89 ce                     	movq	%rcx, %r14
    44f8: 49 c1 c6 32                  	rolq	$0x32, %r14
    44fc: 49 89 cf                     	movq	%rcx, %r15
    44ff: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4503: 4d 31 f7                     	xorq	%r14, %r15
    4506: 49 89 cc                     	movq	%rcx, %r12
    4509: 49 c1 c4 17                  	rolq	$0x17, %r12
    450d: 4d 31 fc                     	xorq	%r15, %r12
    4510: 49 89 d6                     	movq	%rdx, %r14
    4513: 4d 31 de                     	xorq	%r11, %r14
    4516: 49 21 ce                     	andq	%rcx, %r14
    4519: 4c 03 8d 10 fe ff ff         	addq	-0x1f0(%rbp), %r9
    4520: 4d 31 de                     	xorq	%r11, %r14
    4523: 4d 01 f1                     	addq	%r14, %r9
    4526: 49 be ab df 66 ee 52 51 3e 98	movabsq	$-0x67c1aead11992055, %r14 ## imm = 0x983E5152EE66DFAB
    4530: 4d 01 ce                     	addq	%r9, %r14
    4533: 4d 01 e6                     	addq	%r12, %r14
    4536: 4d 89 c1                     	movq	%r8, %r9
    4539: 49 c1 c1 24                  	rolq	$0x24, %r9
    453d: 4d 01 f2                     	addq	%r14, %r10
    4540: 4d 89 c7                     	movq	%r8, %r15
    4543: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4547: 4d 31 cf                     	xorq	%r9, %r15
    454a: 4d 89 c4                     	movq	%r8, %r12
    454d: 49 c1 c4 19                  	rolq	$0x19, %r12
    4551: 4d 31 fc                     	xorq	%r15, %r12
    4554: 49 89 f7                     	movq	%rsi, %r15
    4557: 49 09 df                     	orq	%rbx, %r15
    455a: 4d 21 c7                     	andq	%r8, %r15
    455d: 49 89 f1                     	movq	%rsi, %r9
    4560: 49 21 d9                     	andq	%rbx, %r9
    4563: 4d 09 f9                     	orq	%r15, %r9
    4566: 4d 01 e1                     	addq	%r12, %r9
    4569: 4d 01 f1                     	addq	%r14, %r9
    456c: 4d 89 d6                     	movq	%r10, %r14
    456f: 49 c1 c6 32                  	rolq	$0x32, %r14
    4573: 4d 89 d7                     	movq	%r10, %r15
    4576: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    457a: 4d 31 f7                     	xorq	%r14, %r15
    457d: 4d 89 d4                     	movq	%r10, %r12
    4580: 49 c1 c4 17                  	rolq	$0x17, %r12
    4584: 4d 31 fc                     	xorq	%r15, %r12
    4587: 49 89 ce                     	movq	%rcx, %r14
    458a: 49 31 d6                     	xorq	%rdx, %r14
    458d: 4d 21 d6                     	andq	%r10, %r14
    4590: 49 31 d6                     	xorq	%rdx, %r14
    4593: 4c 03 9d 18 fe ff ff         	addq	-0x1e8(%rbp), %r11
    459a: 4d 01 f3                     	addq	%r14, %r11
    459d: 49 be 10 32 b4 2d 6d c6 31 a8	movabsq	$-0x57ce3992d24bcdf0, %r14 ## imm = 0xA831C66D2DB43210
    45a7: 4d 01 de                     	addq	%r11, %r14
    45aa: 4d 89 cb                     	movq	%r9, %r11
    45ad: 49 c1 c3 24                  	rolq	$0x24, %r11
    45b1: 4d 01 e6                     	addq	%r12, %r14
    45b4: 4d 89 cf                     	movq	%r9, %r15
    45b7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    45bb: 4c 01 f3                     	addq	%r14, %rbx
    45be: 4d 89 cc                     	movq	%r9, %r12
    45c1: 49 c1 c4 19                  	rolq	$0x19, %r12
    45c5: 4d 31 df                     	xorq	%r11, %r15
    45c8: 4d 31 fc                     	xorq	%r15, %r12
    45cb: 4d 89 c7                     	movq	%r8, %r15
    45ce: 49 09 f7                     	orq	%rsi, %r15
    45d1: 4d 21 cf                     	andq	%r9, %r15
    45d4: 4d 89 c3                     	movq	%r8, %r11
    45d7: 49 21 f3                     	andq	%rsi, %r11
    45da: 4d 09 fb                     	orq	%r15, %r11
    45dd: 4d 01 e3                     	addq	%r12, %r11
    45e0: 49 89 df                     	movq	%rbx, %r15
    45e3: 49 c1 c7 32                  	rolq	$0x32, %r15
    45e7: 4d 01 f3                     	addq	%r14, %r11
    45ea: 49 89 de                     	movq	%rbx, %r14
    45ed: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    45f1: 4d 31 fe                     	xorq	%r15, %r14
    45f4: 49 89 df                     	movq	%rbx, %r15
    45f7: 49 c1 c7 17                  	rolq	$0x17, %r15
    45fb: 4d 31 f7                     	xorq	%r14, %r15
    45fe: 4d 89 d6                     	movq	%r10, %r14
    4601: 49 31 ce                     	xorq	%rcx, %r14
    4604: 49 21 de                     	andq	%rbx, %r14
    4607: 49 31 ce                     	xorq	%rcx, %r14
    460a: 48 03 95 20 fe ff ff         	addq	-0x1e0(%rbp), %rdx
    4611: 4c 01 f2                     	addq	%r14, %rdx
    4614: 49 be 3f 21 fb 98 c8 27 03 b0	movabsq	$-0x4ffcd8376704dec1, %r14 ## imm = 0xB00327C898FB213F
    461e: 49 01 d6                     	addq	%rdx, %r14
    4621: 4d 01 fe                     	addq	%r15, %r14
    4624: 4c 01 f6                     	addq	%r14, %rsi
    4627: 4c 89 da                     	movq	%r11, %rdx
    462a: 48 c1 c2 24                  	rolq	$0x24, %rdx
    462e: 4d 89 df                     	movq	%r11, %r15
    4631: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4635: 49 31 d7                     	xorq	%rdx, %r15
    4638: 4d 89 dc                     	movq	%r11, %r12
    463b: 49 c1 c4 19                  	rolq	$0x19, %r12
    463f: 4d 31 fc                     	xorq	%r15, %r12
    4642: 4d 89 cf                     	movq	%r9, %r15
    4645: 4d 09 c7                     	orq	%r8, %r15
    4648: 4d 21 df                     	andq	%r11, %r15
    464b: 4c 89 ca                     	movq	%r9, %rdx
    464e: 4c 21 c2                     	andq	%r8, %rdx
    4651: 4c 09 fa                     	orq	%r15, %rdx
    4654: 49 89 f7                     	movq	%rsi, %r15
    4657: 49 c1 c7 32                  	rolq	$0x32, %r15
    465b: 4c 01 e2                     	addq	%r12, %rdx
    465e: 49 89 f4                     	movq	%rsi, %r12
    4661: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4665: 4c 01 f2                     	addq	%r14, %rdx
    4668: 49 89 f6                     	movq	%rsi, %r14
    466b: 49 c1 c6 17                  	rolq	$0x17, %r14
    466f: 4d 31 fc                     	xorq	%r15, %r12
    4672: 4d 31 e6                     	xorq	%r12, %r14
    4675: 49 89 df                     	movq	%rbx, %r15
    4678: 4d 31 d7                     	xorq	%r10, %r15
    467b: 49 21 f7                     	andq	%rsi, %r15
    467e: 4d 31 d7                     	xorq	%r10, %r15
    4681: 48 03 8d 28 fe ff ff         	addq	-0x1d8(%rbp), %rcx
    4688: 4c 01 f9                     	addq	%r15, %rcx
    468b: 49 bf e4 0e ef be c7 7f 59 bf	movabsq	$-0x40a680384110f11c, %r15 ## imm = 0xBF597FC7BEEF0EE4
    4695: 49 01 cf                     	addq	%rcx, %r15
    4698: 4d 01 f7                     	addq	%r14, %r15
    469b: 4d 01 f8                     	addq	%r15, %r8
    469e: 48 89 d1                     	movq	%rdx, %rcx
    46a1: 48 c1 c1 24                  	rolq	$0x24, %rcx
    46a5: 49 89 d6                     	movq	%rdx, %r14
    46a8: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    46ac: 49 31 ce                     	xorq	%rcx, %r14
    46af: 49 89 d4                     	movq	%rdx, %r12
    46b2: 49 c1 c4 19                  	rolq	$0x19, %r12
    46b6: 4d 31 f4                     	xorq	%r14, %r12
    46b9: 4d 89 de                     	movq	%r11, %r14
    46bc: 4d 09 ce                     	orq	%r9, %r14
    46bf: 49 21 d6                     	andq	%rdx, %r14
    46c2: 4c 89 d9                     	movq	%r11, %rcx
    46c5: 4c 21 c9                     	andq	%r9, %rcx
    46c8: 4c 09 f1                     	orq	%r14, %rcx
    46cb: 4c 01 e1                     	addq	%r12, %rcx
    46ce: 4c 01 f9                     	addq	%r15, %rcx
    46d1: 4d 89 c6                     	movq	%r8, %r14
    46d4: 49 c1 c6 32                  	rolq	$0x32, %r14
    46d8: 4d 89 c7                     	movq	%r8, %r15
    46db: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    46df: 4d 31 f7                     	xorq	%r14, %r15
    46e2: 4d 89 c4                     	movq	%r8, %r12
    46e5: 49 c1 c4 17                  	rolq	$0x17, %r12
    46e9: 4d 31 fc                     	xorq	%r15, %r12
    46ec: 49 89 f6                     	movq	%rsi, %r14
    46ef: 49 31 de                     	xorq	%rbx, %r14
    46f2: 4d 21 c6                     	andq	%r8, %r14
    46f5: 4c 03 95 30 fe ff ff         	addq	-0x1d0(%rbp), %r10
    46fc: 49 31 de                     	xorq	%rbx, %r14
    46ff: 4d 01 f2                     	addq	%r14, %r10
    4702: 49 be c2 8f a8 3d f3 0b e0 c6	movabsq	$-0x391ff40cc257703e, %r14 ## imm = 0xC6E00BF33DA88FC2
    470c: 4d 01 d6                     	addq	%r10, %r14
    470f: 4d 01 e6                     	addq	%r12, %r14
    4712: 49 89 ca                     	movq	%rcx, %r10
    4715: 49 c1 c2 24                  	rolq	$0x24, %r10
    4719: 4d 01 f1                     	addq	%r14, %r9
    471c: 49 89 cf                     	movq	%rcx, %r15
    471f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4723: 4d 31 d7                     	xorq	%r10, %r15
    4726: 49 89 cc                     	movq	%rcx, %r12
    4729: 49 c1 c4 19                  	rolq	$0x19, %r12
    472d: 4d 31 fc                     	xorq	%r15, %r12
    4730: 49 89 d7                     	movq	%rdx, %r15
    4733: 4d 09 df                     	orq	%r11, %r15
    4736: 49 21 cf                     	andq	%rcx, %r15
    4739: 49 89 d2                     	movq	%rdx, %r10
    473c: 4d 21 da                     	andq	%r11, %r10
    473f: 4d 09 fa                     	orq	%r15, %r10
    4742: 4d 01 e2                     	addq	%r12, %r10
    4745: 4d 01 f2                     	addq	%r14, %r10
    4748: 4d 89 ce                     	movq	%r9, %r14
    474b: 49 c1 c6 32                  	rolq	$0x32, %r14
    474f: 4d 89 cf                     	movq	%r9, %r15
    4752: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4756: 4d 31 f7                     	xorq	%r14, %r15
    4759: 4d 89 cc                     	movq	%r9, %r12
    475c: 49 c1 c4 17                  	rolq	$0x17, %r12
    4760: 4d 31 fc                     	xorq	%r15, %r12
    4763: 4d 89 c6                     	movq	%r8, %r14
    4766: 49 31 f6                     	xorq	%rsi, %r14
    4769: 4d 21 ce                     	andq	%r9, %r14
    476c: 49 31 f6                     	xorq	%rsi, %r14
    476f: 48 03 9d 38 fe ff ff         	addq	-0x1c8(%rbp), %rbx
    4776: 4c 01 f3                     	addq	%r14, %rbx
    4779: 49 be 25 a7 0a 93 47 91 a7 d5	movabsq	$-0x2a586eb86cf558db, %r14 ## imm = 0xD5A79147930AA725
    4783: 49 01 de                     	addq	%rbx, %r14
    4786: 4c 89 d3                     	movq	%r10, %rbx
    4789: 48 c1 c3 24                  	rolq	$0x24, %rbx
    478d: 4d 01 e6                     	addq	%r12, %r14
    4790: 4d 89 d7                     	movq	%r10, %r15
    4793: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4797: 4d 01 f3                     	addq	%r14, %r11
    479a: 4d 89 d4                     	movq	%r10, %r12
    479d: 49 c1 c4 19                  	rolq	$0x19, %r12
    47a1: 49 31 df                     	xorq	%rbx, %r15
    47a4: 4d 31 fc                     	xorq	%r15, %r12
    47a7: 49 89 cf                     	movq	%rcx, %r15
    47aa: 49 09 d7                     	orq	%rdx, %r15
    47ad: 4d 21 d7                     	andq	%r10, %r15
    47b0: 48 89 cb                     	movq	%rcx, %rbx
    47b3: 48 21 d3                     	andq	%rdx, %rbx
    47b6: 4c 09 fb                     	orq	%r15, %rbx
    47b9: 4c 01 e3                     	addq	%r12, %rbx
    47bc: 4d 89 df                     	movq	%r11, %r15
    47bf: 49 c1 c7 32                  	rolq	$0x32, %r15
    47c3: 4c 01 f3                     	addq	%r14, %rbx
    47c6: 4d 89 de                     	movq	%r11, %r14
    47c9: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    47cd: 4d 31 fe                     	xorq	%r15, %r14
    47d0: 4d 89 df                     	movq	%r11, %r15
    47d3: 49 c1 c7 17                  	rolq	$0x17, %r15
    47d7: 4d 31 f7                     	xorq	%r14, %r15
    47da: 4d 89 ce                     	movq	%r9, %r14
    47dd: 4d 31 c6                     	xorq	%r8, %r14
    47e0: 4d 21 de                     	andq	%r11, %r14
    47e3: 4d 31 c6                     	xorq	%r8, %r14
    47e6: 48 03 b5 40 fe ff ff         	addq	-0x1c0(%rbp), %rsi
    47ed: 4c 01 f6                     	addq	%r14, %rsi
    47f0: 49 be 6f 82 03 e0 51 63 ca 06	movabsq	$0x6ca6351e003826f, %r14 ## imm = 0x6CA6351E003826F
    47fa: 49 01 f6                     	addq	%rsi, %r14
    47fd: 4d 01 fe                     	addq	%r15, %r14
    4800: 4c 01 f2                     	addq	%r14, %rdx
    4803: 48 89 de                     	movq	%rbx, %rsi
    4806: 48 c1 c6 24                  	rolq	$0x24, %rsi
    480a: 49 89 df                     	movq	%rbx, %r15
    480d: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4811: 49 31 f7                     	xorq	%rsi, %r15
    4814: 49 89 dc                     	movq	%rbx, %r12
    4817: 49 c1 c4 19                  	rolq	$0x19, %r12
    481b: 4d 31 fc                     	xorq	%r15, %r12
    481e: 4d 89 d7                     	movq	%r10, %r15
    4821: 49 09 cf                     	orq	%rcx, %r15
    4824: 49 21 df                     	andq	%rbx, %r15
    4827: 4c 89 d6                     	movq	%r10, %rsi
    482a: 48 21 ce                     	andq	%rcx, %rsi
    482d: 4c 09 fe                     	orq	%r15, %rsi
    4830: 49 89 d7                     	movq	%rdx, %r15
    4833: 49 c1 c7 32                  	rolq	$0x32, %r15
    4837: 4c 01 e6                     	addq	%r12, %rsi
    483a: 49 89 d4                     	movq	%rdx, %r12
    483d: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4841: 4c 01 f6                     	addq	%r14, %rsi
    4844: 49 89 d6                     	movq	%rdx, %r14
    4847: 49 c1 c6 17                  	rolq	$0x17, %r14
    484b: 4d 31 fc                     	xorq	%r15, %r12
    484e: 4d 31 e6                     	xorq	%r12, %r14
    4851: 4d 89 df                     	movq	%r11, %r15
    4854: 4d 31 cf                     	xorq	%r9, %r15
    4857: 49 21 d7                     	andq	%rdx, %r15
    485a: 4d 31 cf                     	xorq	%r9, %r15
    485d: 4c 03 85 48 fe ff ff         	addq	-0x1b8(%rbp), %r8
    4864: 4d 01 f8                     	addq	%r15, %r8
    4867: 49 bf 70 6e 0e 0a 67 29 29 14	movabsq	$0x142929670a0e6e70, %r15 ## imm = 0x142929670A0E6E70
    4871: 4d 01 c7                     	addq	%r8, %r15
    4874: 4d 01 f7                     	addq	%r14, %r15
    4877: 4c 01 f9                     	addq	%r15, %rcx
    487a: 49 89 f0                     	movq	%rsi, %r8
    487d: 49 c1 c0 24                  	rolq	$0x24, %r8
    4881: 49 89 f6                     	movq	%rsi, %r14
    4884: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4888: 4d 31 c6                     	xorq	%r8, %r14
    488b: 49 89 f4                     	movq	%rsi, %r12
    488e: 49 c1 c4 19                  	rolq	$0x19, %r12
    4892: 4d 31 f4                     	xorq	%r14, %r12
    4895: 49 89 de                     	movq	%rbx, %r14
    4898: 4d 09 d6                     	orq	%r10, %r14
    489b: 49 21 f6                     	andq	%rsi, %r14
    489e: 49 89 d8                     	movq	%rbx, %r8
    48a1: 4d 21 d0                     	andq	%r10, %r8
    48a4: 4d 09 f0                     	orq	%r14, %r8
    48a7: 4d 01 e0                     	addq	%r12, %r8
    48aa: 4d 01 f8                     	addq	%r15, %r8
    48ad: 49 89 ce                     	movq	%rcx, %r14
    48b0: 49 c1 c6 32                  	rolq	$0x32, %r14
    48b4: 49 89 cf                     	movq	%rcx, %r15
    48b7: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    48bb: 4d 31 f7                     	xorq	%r14, %r15
    48be: 49 89 cc                     	movq	%rcx, %r12
    48c1: 49 c1 c4 17                  	rolq	$0x17, %r12
    48c5: 4d 31 fc                     	xorq	%r15, %r12
    48c8: 49 89 d6                     	movq	%rdx, %r14
    48cb: 4d 31 de                     	xorq	%r11, %r14
    48ce: 49 21 ce                     	andq	%rcx, %r14
    48d1: 4c 03 8d 50 fe ff ff         	addq	-0x1b0(%rbp), %r9
    48d8: 4d 31 de                     	xorq	%r11, %r14
    48db: 4d 01 f1                     	addq	%r14, %r9
    48de: 49 be fc 2f d2 46 85 0a b7 27	movabsq	$0x27b70a8546d22ffc, %r14 ## imm = 0x27B70A8546D22FFC
    48e8: 4d 01 ce                     	addq	%r9, %r14
    48eb: 4d 01 e6                     	addq	%r12, %r14
    48ee: 4d 89 c1                     	movq	%r8, %r9
    48f1: 49 c1 c1 24                  	rolq	$0x24, %r9
    48f5: 4d 01 f2                     	addq	%r14, %r10
    48f8: 4d 89 c7                     	movq	%r8, %r15
    48fb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    48ff: 4d 31 cf                     	xorq	%r9, %r15
    4902: 4d 89 c4                     	movq	%r8, %r12
    4905: 49 c1 c4 19                  	rolq	$0x19, %r12
    4909: 4d 31 fc                     	xorq	%r15, %r12
    490c: 49 89 f7                     	movq	%rsi, %r15
    490f: 49 09 df                     	orq	%rbx, %r15
    4912: 4d 21 c7                     	andq	%r8, %r15
    4915: 49 89 f1                     	movq	%rsi, %r9
    4918: 49 21 d9                     	andq	%rbx, %r9
    491b: 4d 09 f9                     	orq	%r15, %r9
    491e: 4d 01 e1                     	addq	%r12, %r9
    4921: 4d 01 f1                     	addq	%r14, %r9
    4924: 4d 89 d6                     	movq	%r10, %r14
    4927: 49 c1 c6 32                  	rolq	$0x32, %r14
    492b: 4d 89 d7                     	movq	%r10, %r15
    492e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4932: 4d 31 f7                     	xorq	%r14, %r15
    4935: 4d 89 d4                     	movq	%r10, %r12
    4938: 49 c1 c4 17                  	rolq	$0x17, %r12
    493c: 4d 31 fc                     	xorq	%r15, %r12
    493f: 49 89 ce                     	movq	%rcx, %r14
    4942: 49 31 d6                     	xorq	%rdx, %r14
    4945: 4d 21 d6                     	andq	%r10, %r14
    4948: 49 31 d6                     	xorq	%rdx, %r14
    494b: 4c 03 9d 58 fe ff ff         	addq	-0x1a8(%rbp), %r11
    4952: 4d 01 f3                     	addq	%r14, %r11
    4955: 49 be 26 c9 26 5c 38 21 1b 2e	movabsq	$0x2e1b21385c26c926, %r14 ## imm = 0x2E1B21385C26C926
    495f: 4d 01 de                     	addq	%r11, %r14
    4962: 4d 89 cb                     	movq	%r9, %r11
    4965: 49 c1 c3 24                  	rolq	$0x24, %r11
    4969: 4d 01 e6                     	addq	%r12, %r14
    496c: 4d 89 cf                     	movq	%r9, %r15
    496f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4973: 4c 01 f3                     	addq	%r14, %rbx
    4976: 4d 89 cc                     	movq	%r9, %r12
    4979: 49 c1 c4 19                  	rolq	$0x19, %r12
    497d: 4d 31 df                     	xorq	%r11, %r15
    4980: 4d 31 fc                     	xorq	%r15, %r12
    4983: 4d 89 c7                     	movq	%r8, %r15
    4986: 49 09 f7                     	orq	%rsi, %r15
    4989: 4d 21 cf                     	andq	%r9, %r15
    498c: 4d 89 c3                     	movq	%r8, %r11
    498f: 49 21 f3                     	andq	%rsi, %r11
    4992: 4d 09 fb                     	orq	%r15, %r11
    4995: 4d 01 e3                     	addq	%r12, %r11
    4998: 49 89 df                     	movq	%rbx, %r15
    499b: 49 c1 c7 32                  	rolq	$0x32, %r15
    499f: 4d 01 f3                     	addq	%r14, %r11
    49a2: 49 89 de                     	movq	%rbx, %r14
    49a5: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    49a9: 4d 31 fe                     	xorq	%r15, %r14
    49ac: 49 89 df                     	movq	%rbx, %r15
    49af: 49 c1 c7 17                  	rolq	$0x17, %r15
    49b3: 4d 31 f7                     	xorq	%r14, %r15
    49b6: 4d 89 d6                     	movq	%r10, %r14
    49b9: 49 31 ce                     	xorq	%rcx, %r14
    49bc: 49 21 de                     	andq	%rbx, %r14
    49bf: 49 31 ce                     	xorq	%rcx, %r14
    49c2: 48 03 95 60 fe ff ff         	addq	-0x1a0(%rbp), %rdx
    49c9: 4c 01 f2                     	addq	%r14, %rdx
    49cc: 49 be ed 2a c4 5a fc 6d 2c 4d	movabsq	$0x4d2c6dfc5ac42aed, %r14 ## imm = 0x4D2C6DFC5AC42AED
    49d6: 49 01 d6                     	addq	%rdx, %r14
    49d9: 4d 01 fe                     	addq	%r15, %r14
    49dc: 4c 01 f6                     	addq	%r14, %rsi
    49df: 4c 89 da                     	movq	%r11, %rdx
    49e2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    49e6: 4d 89 df                     	movq	%r11, %r15
    49e9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    49ed: 49 31 d7                     	xorq	%rdx, %r15
    49f0: 4d 89 dc                     	movq	%r11, %r12
    49f3: 49 c1 c4 19                  	rolq	$0x19, %r12
    49f7: 4d 31 fc                     	xorq	%r15, %r12
    49fa: 4d 89 cf                     	movq	%r9, %r15
    49fd: 4d 09 c7                     	orq	%r8, %r15
    4a00: 4d 21 df                     	andq	%r11, %r15
    4a03: 4c 89 ca                     	movq	%r9, %rdx
    4a06: 4c 21 c2                     	andq	%r8, %rdx
    4a09: 4c 09 fa                     	orq	%r15, %rdx
    4a0c: 49 89 f7                     	movq	%rsi, %r15
    4a0f: 49 c1 c7 32                  	rolq	$0x32, %r15
    4a13: 4c 01 e2                     	addq	%r12, %rdx
    4a16: 49 89 f4                     	movq	%rsi, %r12
    4a19: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4a1d: 4c 01 f2                     	addq	%r14, %rdx
    4a20: 49 89 f6                     	movq	%rsi, %r14
    4a23: 49 c1 c6 17                  	rolq	$0x17, %r14
    4a27: 4d 31 fc                     	xorq	%r15, %r12
    4a2a: 4d 31 e6                     	xorq	%r12, %r14
    4a2d: 49 89 df                     	movq	%rbx, %r15
    4a30: 4d 31 d7                     	xorq	%r10, %r15
    4a33: 49 21 f7                     	andq	%rsi, %r15
    4a36: 4d 31 d7                     	xorq	%r10, %r15
    4a39: 48 03 8d 68 fe ff ff         	addq	-0x198(%rbp), %rcx
    4a40: 4c 01 f9                     	addq	%r15, %rcx
    4a43: 49 bf df b3 95 9d 13 0d 38 53	movabsq	$0x53380d139d95b3df, %r15 ## imm = 0x53380D139D95B3DF
    4a4d: 49 01 cf                     	addq	%rcx, %r15
    4a50: 4d 01 f7                     	addq	%r14, %r15
    4a53: 4d 01 f8                     	addq	%r15, %r8
    4a56: 48 89 d1                     	movq	%rdx, %rcx
    4a59: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4a5d: 49 89 d6                     	movq	%rdx, %r14
    4a60: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4a64: 49 31 ce                     	xorq	%rcx, %r14
    4a67: 49 89 d4                     	movq	%rdx, %r12
    4a6a: 49 c1 c4 19                  	rolq	$0x19, %r12
    4a6e: 4d 31 f4                     	xorq	%r14, %r12
    4a71: 4d 89 de                     	movq	%r11, %r14
    4a74: 4d 09 ce                     	orq	%r9, %r14
    4a77: 49 21 d6                     	andq	%rdx, %r14
    4a7a: 4c 89 d9                     	movq	%r11, %rcx
    4a7d: 4c 21 c9                     	andq	%r9, %rcx
    4a80: 4c 09 f1                     	orq	%r14, %rcx
    4a83: 4c 01 e1                     	addq	%r12, %rcx
    4a86: 4c 01 f9                     	addq	%r15, %rcx
    4a89: 4d 89 c6                     	movq	%r8, %r14
    4a8c: 49 c1 c6 32                  	rolq	$0x32, %r14
    4a90: 4d 89 c7                     	movq	%r8, %r15
    4a93: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4a97: 4d 31 f7                     	xorq	%r14, %r15
    4a9a: 4d 89 c4                     	movq	%r8, %r12
    4a9d: 49 c1 c4 17                  	rolq	$0x17, %r12
    4aa1: 4d 31 fc                     	xorq	%r15, %r12
    4aa4: 49 89 f6                     	movq	%rsi, %r14
    4aa7: 49 31 de                     	xorq	%rbx, %r14
    4aaa: 4d 21 c6                     	andq	%r8, %r14
    4aad: 4c 03 95 70 fe ff ff         	addq	-0x190(%rbp), %r10
    4ab4: 49 31 de                     	xorq	%rbx, %r14
    4ab7: 4d 01 f2                     	addq	%r14, %r10
    4aba: 49 be de 63 af 8b 54 73 0a 65	movabsq	$0x650a73548baf63de, %r14 ## imm = 0x650A73548BAF63DE
    4ac4: 4d 01 d6                     	addq	%r10, %r14
    4ac7: 4d 01 e6                     	addq	%r12, %r14
    4aca: 49 89 ca                     	movq	%rcx, %r10
    4acd: 49 c1 c2 24                  	rolq	$0x24, %r10
    4ad1: 4d 01 f1                     	addq	%r14, %r9
    4ad4: 49 89 cf                     	movq	%rcx, %r15
    4ad7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4adb: 4d 31 d7                     	xorq	%r10, %r15
    4ade: 49 89 cc                     	movq	%rcx, %r12
    4ae1: 49 c1 c4 19                  	rolq	$0x19, %r12
    4ae5: 4d 31 fc                     	xorq	%r15, %r12
    4ae8: 49 89 d7                     	movq	%rdx, %r15
    4aeb: 4d 09 df                     	orq	%r11, %r15
    4aee: 49 21 cf                     	andq	%rcx, %r15
    4af1: 49 89 d2                     	movq	%rdx, %r10
    4af4: 4d 21 da                     	andq	%r11, %r10
    4af7: 4d 09 fa                     	orq	%r15, %r10
    4afa: 4d 01 e2                     	addq	%r12, %r10
    4afd: 4d 01 f2                     	addq	%r14, %r10
    4b00: 4d 89 ce                     	movq	%r9, %r14
    4b03: 49 c1 c6 32                  	rolq	$0x32, %r14
    4b07: 4d 89 cf                     	movq	%r9, %r15
    4b0a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4b0e: 4d 31 f7                     	xorq	%r14, %r15
    4b11: 4d 89 cc                     	movq	%r9, %r12
    4b14: 49 c1 c4 17                  	rolq	$0x17, %r12
    4b18: 4d 31 fc                     	xorq	%r15, %r12
    4b1b: 4d 89 c6                     	movq	%r8, %r14
    4b1e: 49 31 f6                     	xorq	%rsi, %r14
    4b21: 4d 21 ce                     	andq	%r9, %r14
    4b24: 49 31 f6                     	xorq	%rsi, %r14
    4b27: 48 03 9d 78 fe ff ff         	addq	-0x188(%rbp), %rbx
    4b2e: 4c 01 f3                     	addq	%r14, %rbx
    4b31: 49 be a8 b2 77 3c bb 0a 6a 76	movabsq	$0x766a0abb3c77b2a8, %r14 ## imm = 0x766A0ABB3C77B2A8
    4b3b: 49 01 de                     	addq	%rbx, %r14
    4b3e: 4c 89 d3                     	movq	%r10, %rbx
    4b41: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4b45: 4d 01 e6                     	addq	%r12, %r14
    4b48: 4d 89 d7                     	movq	%r10, %r15
    4b4b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4b4f: 4d 01 f3                     	addq	%r14, %r11
    4b52: 4d 89 d4                     	movq	%r10, %r12
    4b55: 49 c1 c4 19                  	rolq	$0x19, %r12
    4b59: 49 31 df                     	xorq	%rbx, %r15
    4b5c: 4d 31 fc                     	xorq	%r15, %r12
    4b5f: 49 89 cf                     	movq	%rcx, %r15
    4b62: 49 09 d7                     	orq	%rdx, %r15
    4b65: 4d 21 d7                     	andq	%r10, %r15
    4b68: 48 89 cb                     	movq	%rcx, %rbx
    4b6b: 48 21 d3                     	andq	%rdx, %rbx
    4b6e: 4c 09 fb                     	orq	%r15, %rbx
    4b71: 4c 01 e3                     	addq	%r12, %rbx
    4b74: 4d 89 df                     	movq	%r11, %r15
    4b77: 49 c1 c7 32                  	rolq	$0x32, %r15
    4b7b: 4c 01 f3                     	addq	%r14, %rbx
    4b7e: 4d 89 de                     	movq	%r11, %r14
    4b81: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4b85: 4d 31 fe                     	xorq	%r15, %r14
    4b88: 4d 89 df                     	movq	%r11, %r15
    4b8b: 49 c1 c7 17                  	rolq	$0x17, %r15
    4b8f: 4d 31 f7                     	xorq	%r14, %r15
    4b92: 4d 89 ce                     	movq	%r9, %r14
    4b95: 4d 31 c6                     	xorq	%r8, %r14
    4b98: 4d 21 de                     	andq	%r11, %r14
    4b9b: 4d 31 c6                     	xorq	%r8, %r14
    4b9e: 48 03 b5 80 fe ff ff         	addq	-0x180(%rbp), %rsi
    4ba5: 4c 01 f6                     	addq	%r14, %rsi
    4ba8: 49 be e6 ae ed 47 2e c9 c2 81	movabsq	$-0x7e3d36d1b812511a, %r14 ## imm = 0x81C2C92E47EDAEE6
    4bb2: 49 01 f6                     	addq	%rsi, %r14
    4bb5: 4d 01 fe                     	addq	%r15, %r14
    4bb8: 4c 01 f2                     	addq	%r14, %rdx
    4bbb: 48 89 de                     	movq	%rbx, %rsi
    4bbe: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4bc2: 49 89 df                     	movq	%rbx, %r15
    4bc5: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4bc9: 49 31 f7                     	xorq	%rsi, %r15
    4bcc: 49 89 dc                     	movq	%rbx, %r12
    4bcf: 49 c1 c4 19                  	rolq	$0x19, %r12
    4bd3: 4d 31 fc                     	xorq	%r15, %r12
    4bd6: 4d 89 d7                     	movq	%r10, %r15
    4bd9: 49 09 cf                     	orq	%rcx, %r15
    4bdc: 49 21 df                     	andq	%rbx, %r15
    4bdf: 4c 89 d6                     	movq	%r10, %rsi
    4be2: 48 21 ce                     	andq	%rcx, %rsi
    4be5: 4c 09 fe                     	orq	%r15, %rsi
    4be8: 49 89 d7                     	movq	%rdx, %r15
    4beb: 49 c1 c7 32                  	rolq	$0x32, %r15
    4bef: 4c 01 e6                     	addq	%r12, %rsi
    4bf2: 49 89 d4                     	movq	%rdx, %r12
    4bf5: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4bf9: 4c 01 f6                     	addq	%r14, %rsi
    4bfc: 49 89 d6                     	movq	%rdx, %r14
    4bff: 49 c1 c6 17                  	rolq	$0x17, %r14
    4c03: 4d 31 fc                     	xorq	%r15, %r12
    4c06: 4d 31 e6                     	xorq	%r12, %r14
    4c09: 4d 89 df                     	movq	%r11, %r15
    4c0c: 4d 31 cf                     	xorq	%r9, %r15
    4c0f: 49 21 d7                     	andq	%rdx, %r15
    4c12: 4d 31 cf                     	xorq	%r9, %r15
    4c15: 4c 03 85 88 fe ff ff         	addq	-0x178(%rbp), %r8
    4c1c: 4d 01 f8                     	addq	%r15, %r8
    4c1f: 49 bf 3b 35 82 14 85 2c 72 92	movabsq	$-0x6d8dd37aeb7dcac5, %r15 ## imm = 0x92722C851482353B
    4c29: 4d 01 c7                     	addq	%r8, %r15
    4c2c: 4d 01 f7                     	addq	%r14, %r15
    4c2f: 4c 01 f9                     	addq	%r15, %rcx
    4c32: 49 89 f0                     	movq	%rsi, %r8
    4c35: 49 c1 c0 24                  	rolq	$0x24, %r8
    4c39: 49 89 f6                     	movq	%rsi, %r14
    4c3c: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4c40: 4d 31 c6                     	xorq	%r8, %r14
    4c43: 49 89 f4                     	movq	%rsi, %r12
    4c46: 49 c1 c4 19                  	rolq	$0x19, %r12
    4c4a: 4d 31 f4                     	xorq	%r14, %r12
    4c4d: 49 89 de                     	movq	%rbx, %r14
    4c50: 4d 09 d6                     	orq	%r10, %r14
    4c53: 49 21 f6                     	andq	%rsi, %r14
    4c56: 49 89 d8                     	movq	%rbx, %r8
    4c59: 4d 21 d0                     	andq	%r10, %r8
    4c5c: 4d 09 f0                     	orq	%r14, %r8
    4c5f: 4d 01 e0                     	addq	%r12, %r8
    4c62: 4d 01 f8                     	addq	%r15, %r8
    4c65: 49 89 ce                     	movq	%rcx, %r14
    4c68: 49 c1 c6 32                  	rolq	$0x32, %r14
    4c6c: 49 89 cf                     	movq	%rcx, %r15
    4c6f: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4c73: 4d 31 f7                     	xorq	%r14, %r15
    4c76: 49 89 cc                     	movq	%rcx, %r12
    4c79: 49 c1 c4 17                  	rolq	$0x17, %r12
    4c7d: 4d 31 fc                     	xorq	%r15, %r12
    4c80: 49 89 d6                     	movq	%rdx, %r14
    4c83: 4d 31 de                     	xorq	%r11, %r14
    4c86: 49 21 ce                     	andq	%rcx, %r14
    4c89: 4c 03 8d 90 fe ff ff         	addq	-0x170(%rbp), %r9
    4c90: 4d 31 de                     	xorq	%r11, %r14
    4c93: 4d 01 f1                     	addq	%r14, %r9
    4c96: 49 be 64 03 f1 4c a1 e8 bf a2	movabsq	$-0x5d40175eb30efc9c, %r14 ## imm = 0xA2BFE8A14CF10364
    4ca0: 4d 01 ce                     	addq	%r9, %r14
    4ca3: 4d 01 e6                     	addq	%r12, %r14
    4ca6: 4d 89 c1                     	movq	%r8, %r9
    4ca9: 49 c1 c1 24                  	rolq	$0x24, %r9
    4cad: 4d 01 f2                     	addq	%r14, %r10
    4cb0: 4d 89 c7                     	movq	%r8, %r15
    4cb3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4cb7: 4d 31 cf                     	xorq	%r9, %r15
    4cba: 4d 89 c4                     	movq	%r8, %r12
    4cbd: 49 c1 c4 19                  	rolq	$0x19, %r12
    4cc1: 4d 31 fc                     	xorq	%r15, %r12
    4cc4: 49 89 f7                     	movq	%rsi, %r15
    4cc7: 49 09 df                     	orq	%rbx, %r15
    4cca: 4d 21 c7                     	andq	%r8, %r15
    4ccd: 49 89 f1                     	movq	%rsi, %r9
    4cd0: 49 21 d9                     	andq	%rbx, %r9
    4cd3: 4d 09 f9                     	orq	%r15, %r9
    4cd6: 4d 01 e1                     	addq	%r12, %r9
    4cd9: 4d 01 f1                     	addq	%r14, %r9
    4cdc: 4d 89 d6                     	movq	%r10, %r14
    4cdf: 49 c1 c6 32                  	rolq	$0x32, %r14
    4ce3: 4d 89 d7                     	movq	%r10, %r15
    4ce6: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4cea: 4d 31 f7                     	xorq	%r14, %r15
    4ced: 4d 89 d4                     	movq	%r10, %r12
    4cf0: 49 c1 c4 17                  	rolq	$0x17, %r12
    4cf4: 4d 31 fc                     	xorq	%r15, %r12
    4cf7: 49 89 ce                     	movq	%rcx, %r14
    4cfa: 49 31 d6                     	xorq	%rdx, %r14
    4cfd: 4d 21 d6                     	andq	%r10, %r14
    4d00: 49 31 d6                     	xorq	%rdx, %r14
    4d03: 4c 03 9d 98 fe ff ff         	addq	-0x168(%rbp), %r11
    4d0a: 4d 01 f3                     	addq	%r14, %r11
    4d0d: 49 be 01 30 42 bc 4b 66 1a a8	movabsq	$-0x57e599b443bdcfff, %r14 ## imm = 0xA81A664BBC423001
    4d17: 4d 01 de                     	addq	%r11, %r14
    4d1a: 4d 89 cb                     	movq	%r9, %r11
    4d1d: 49 c1 c3 24                  	rolq	$0x24, %r11
    4d21: 4d 01 e6                     	addq	%r12, %r14
    4d24: 4d 89 cf                     	movq	%r9, %r15
    4d27: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4d2b: 4c 01 f3                     	addq	%r14, %rbx
    4d2e: 4d 89 cc                     	movq	%r9, %r12
    4d31: 49 c1 c4 19                  	rolq	$0x19, %r12
    4d35: 4d 31 df                     	xorq	%r11, %r15
    4d38: 4d 31 fc                     	xorq	%r15, %r12
    4d3b: 4d 89 c7                     	movq	%r8, %r15
    4d3e: 49 09 f7                     	orq	%rsi, %r15
    4d41: 4d 21 cf                     	andq	%r9, %r15
    4d44: 4d 89 c3                     	movq	%r8, %r11
    4d47: 49 21 f3                     	andq	%rsi, %r11
    4d4a: 4d 09 fb                     	orq	%r15, %r11
    4d4d: 4d 01 e3                     	addq	%r12, %r11
    4d50: 49 89 df                     	movq	%rbx, %r15
    4d53: 49 c1 c7 32                  	rolq	$0x32, %r15
    4d57: 4d 01 f3                     	addq	%r14, %r11
    4d5a: 49 89 de                     	movq	%rbx, %r14
    4d5d: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4d61: 4d 31 fe                     	xorq	%r15, %r14
    4d64: 49 89 df                     	movq	%rbx, %r15
    4d67: 49 c1 c7 17                  	rolq	$0x17, %r15
    4d6b: 4d 31 f7                     	xorq	%r14, %r15
    4d6e: 4d 89 d6                     	movq	%r10, %r14
    4d71: 49 31 ce                     	xorq	%rcx, %r14
    4d74: 49 21 de                     	andq	%rbx, %r14
    4d77: 49 31 ce                     	xorq	%rcx, %r14
    4d7a: 48 03 95 a0 fe ff ff         	addq	-0x160(%rbp), %rdx
    4d81: 4c 01 f2                     	addq	%r14, %rdx
    4d84: 49 be 91 97 f8 d0 70 8b 4b c2	movabsq	$-0x3db4748f2f07686f, %r14 ## imm = 0xC24B8B70D0F89791
    4d8e: 49 01 d6                     	addq	%rdx, %r14
    4d91: 4d 01 fe                     	addq	%r15, %r14
    4d94: 4c 01 f6                     	addq	%r14, %rsi
    4d97: 4c 89 da                     	movq	%r11, %rdx
    4d9a: 48 c1 c2 24                  	rolq	$0x24, %rdx
    4d9e: 4d 89 df                     	movq	%r11, %r15
    4da1: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4da5: 49 31 d7                     	xorq	%rdx, %r15
    4da8: 4d 89 dc                     	movq	%r11, %r12
    4dab: 49 c1 c4 19                  	rolq	$0x19, %r12
    4daf: 4d 31 fc                     	xorq	%r15, %r12
    4db2: 4d 89 cf                     	movq	%r9, %r15
    4db5: 4d 09 c7                     	orq	%r8, %r15
    4db8: 4d 21 df                     	andq	%r11, %r15
    4dbb: 4c 89 ca                     	movq	%r9, %rdx
    4dbe: 4c 21 c2                     	andq	%r8, %rdx
    4dc1: 4c 09 fa                     	orq	%r15, %rdx
    4dc4: 49 89 f7                     	movq	%rsi, %r15
    4dc7: 49 c1 c7 32                  	rolq	$0x32, %r15
    4dcb: 4c 01 e2                     	addq	%r12, %rdx
    4dce: 49 89 f4                     	movq	%rsi, %r12
    4dd1: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4dd5: 4c 01 f2                     	addq	%r14, %rdx
    4dd8: 49 89 f6                     	movq	%rsi, %r14
    4ddb: 49 c1 c6 17                  	rolq	$0x17, %r14
    4ddf: 4d 31 fc                     	xorq	%r15, %r12
    4de2: 4d 31 e6                     	xorq	%r12, %r14
    4de5: 49 89 df                     	movq	%rbx, %r15
    4de8: 4d 31 d7                     	xorq	%r10, %r15
    4deb: 49 21 f7                     	andq	%rsi, %r15
    4dee: 4d 31 d7                     	xorq	%r10, %r15
    4df1: 48 03 8d a8 fe ff ff         	addq	-0x158(%rbp), %rcx
    4df8: 4c 01 f9                     	addq	%r15, %rcx
    4dfb: 49 bf 30 be 54 06 a3 51 6c c7	movabsq	$-0x3893ae5cf9ab41d0, %r15 ## imm = 0xC76C51A30654BE30
    4e05: 49 01 cf                     	addq	%rcx, %r15
    4e08: 4d 01 f7                     	addq	%r14, %r15
    4e0b: 4d 01 f8                     	addq	%r15, %r8
    4e0e: 48 89 d1                     	movq	%rdx, %rcx
    4e11: 48 c1 c1 24                  	rolq	$0x24, %rcx
    4e15: 49 89 d6                     	movq	%rdx, %r14
    4e18: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4e1c: 49 31 ce                     	xorq	%rcx, %r14
    4e1f: 49 89 d4                     	movq	%rdx, %r12
    4e22: 49 c1 c4 19                  	rolq	$0x19, %r12
    4e26: 4d 31 f4                     	xorq	%r14, %r12
    4e29: 4d 89 de                     	movq	%r11, %r14
    4e2c: 4d 09 ce                     	orq	%r9, %r14
    4e2f: 49 21 d6                     	andq	%rdx, %r14
    4e32: 4c 89 d9                     	movq	%r11, %rcx
    4e35: 4c 21 c9                     	andq	%r9, %rcx
    4e38: 4c 09 f1                     	orq	%r14, %rcx
    4e3b: 4c 01 e1                     	addq	%r12, %rcx
    4e3e: 4c 01 f9                     	addq	%r15, %rcx
    4e41: 4d 89 c6                     	movq	%r8, %r14
    4e44: 49 c1 c6 32                  	rolq	$0x32, %r14
    4e48: 4d 89 c7                     	movq	%r8, %r15
    4e4b: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4e4f: 4d 31 f7                     	xorq	%r14, %r15
    4e52: 4d 89 c4                     	movq	%r8, %r12
    4e55: 49 c1 c4 17                  	rolq	$0x17, %r12
    4e59: 4d 31 fc                     	xorq	%r15, %r12
    4e5c: 49 89 f6                     	movq	%rsi, %r14
    4e5f: 49 31 de                     	xorq	%rbx, %r14
    4e62: 4d 21 c6                     	andq	%r8, %r14
    4e65: 4c 03 95 b0 fe ff ff         	addq	-0x150(%rbp), %r10
    4e6c: 49 31 de                     	xorq	%rbx, %r14
    4e6f: 4d 01 f2                     	addq	%r14, %r10
    4e72: 49 be 18 52 ef d6 19 e8 92 d1	movabsq	$-0x2e6d17e62910ade8, %r14 ## imm = 0xD192E819D6EF5218
    4e7c: 4d 01 d6                     	addq	%r10, %r14
    4e7f: 4d 01 e6                     	addq	%r12, %r14
    4e82: 49 89 ca                     	movq	%rcx, %r10
    4e85: 49 c1 c2 24                  	rolq	$0x24, %r10
    4e89: 4d 01 f1                     	addq	%r14, %r9
    4e8c: 49 89 cf                     	movq	%rcx, %r15
    4e8f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4e93: 4d 31 d7                     	xorq	%r10, %r15
    4e96: 49 89 cc                     	movq	%rcx, %r12
    4e99: 49 c1 c4 19                  	rolq	$0x19, %r12
    4e9d: 4d 31 fc                     	xorq	%r15, %r12
    4ea0: 49 89 d7                     	movq	%rdx, %r15
    4ea3: 4d 09 df                     	orq	%r11, %r15
    4ea6: 49 21 cf                     	andq	%rcx, %r15
    4ea9: 49 89 d2                     	movq	%rdx, %r10
    4eac: 4d 21 da                     	andq	%r11, %r10
    4eaf: 4d 09 fa                     	orq	%r15, %r10
    4eb2: 4d 01 e2                     	addq	%r12, %r10
    4eb5: 4d 01 f2                     	addq	%r14, %r10
    4eb8: 4d 89 ce                     	movq	%r9, %r14
    4ebb: 49 c1 c6 32                  	rolq	$0x32, %r14
    4ebf: 4d 89 cf                     	movq	%r9, %r15
    4ec2: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    4ec6: 4d 31 f7                     	xorq	%r14, %r15
    4ec9: 4d 89 cc                     	movq	%r9, %r12
    4ecc: 49 c1 c4 17                  	rolq	$0x17, %r12
    4ed0: 4d 31 fc                     	xorq	%r15, %r12
    4ed3: 4d 89 c6                     	movq	%r8, %r14
    4ed6: 49 31 f6                     	xorq	%rsi, %r14
    4ed9: 4d 21 ce                     	andq	%r9, %r14
    4edc: 49 31 f6                     	xorq	%rsi, %r14
    4edf: 48 03 9d b8 fe ff ff         	addq	-0x148(%rbp), %rbx
    4ee6: 4c 01 f3                     	addq	%r14, %rbx
    4ee9: 49 be 10 a9 65 55 24 06 99 d6	movabsq	$-0x2966f9dbaa9a56f0, %r14 ## imm = 0xD69906245565A910
    4ef3: 49 01 de                     	addq	%rbx, %r14
    4ef6: 4c 89 d3                     	movq	%r10, %rbx
    4ef9: 48 c1 c3 24                  	rolq	$0x24, %rbx
    4efd: 4d 01 e6                     	addq	%r12, %r14
    4f00: 4d 89 d7                     	movq	%r10, %r15
    4f03: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4f07: 4d 01 f3                     	addq	%r14, %r11
    4f0a: 4d 89 d4                     	movq	%r10, %r12
    4f0d: 49 c1 c4 19                  	rolq	$0x19, %r12
    4f11: 49 31 df                     	xorq	%rbx, %r15
    4f14: 4d 31 fc                     	xorq	%r15, %r12
    4f17: 49 89 cf                     	movq	%rcx, %r15
    4f1a: 49 09 d7                     	orq	%rdx, %r15
    4f1d: 4d 21 d7                     	andq	%r10, %r15
    4f20: 48 89 cb                     	movq	%rcx, %rbx
    4f23: 48 21 d3                     	andq	%rdx, %rbx
    4f26: 4c 09 fb                     	orq	%r15, %rbx
    4f29: 4c 01 e3                     	addq	%r12, %rbx
    4f2c: 4d 89 df                     	movq	%r11, %r15
    4f2f: 49 c1 c7 32                  	rolq	$0x32, %r15
    4f33: 4c 01 f3                     	addq	%r14, %rbx
    4f36: 4d 89 de                     	movq	%r11, %r14
    4f39: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    4f3d: 4d 31 fe                     	xorq	%r15, %r14
    4f40: 4d 89 df                     	movq	%r11, %r15
    4f43: 49 c1 c7 17                  	rolq	$0x17, %r15
    4f47: 4d 31 f7                     	xorq	%r14, %r15
    4f4a: 4d 89 ce                     	movq	%r9, %r14
    4f4d: 4d 31 c6                     	xorq	%r8, %r14
    4f50: 4d 21 de                     	andq	%r11, %r14
    4f53: 4d 31 c6                     	xorq	%r8, %r14
    4f56: 48 03 b5 c0 fe ff ff         	addq	-0x140(%rbp), %rsi
    4f5d: 4c 01 f6                     	addq	%r14, %rsi
    4f60: 49 be 2a 20 71 57 85 35 0e f4	movabsq	$-0xbf1ca7aa88edfd6, %r14 ## imm = 0xF40E35855771202A
    4f6a: 49 01 f6                     	addq	%rsi, %r14
    4f6d: 4d 01 fe                     	addq	%r15, %r14
    4f70: 4c 01 f2                     	addq	%r14, %rdx
    4f73: 48 89 de                     	movq	%rbx, %rsi
    4f76: 48 c1 c6 24                  	rolq	$0x24, %rsi
    4f7a: 49 89 df                     	movq	%rbx, %r15
    4f7d: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    4f81: 49 31 f7                     	xorq	%rsi, %r15
    4f84: 49 89 dc                     	movq	%rbx, %r12
    4f87: 49 c1 c4 19                  	rolq	$0x19, %r12
    4f8b: 4d 31 fc                     	xorq	%r15, %r12
    4f8e: 4d 89 d7                     	movq	%r10, %r15
    4f91: 49 09 cf                     	orq	%rcx, %r15
    4f94: 49 21 df                     	andq	%rbx, %r15
    4f97: 4c 89 d6                     	movq	%r10, %rsi
    4f9a: 48 21 ce                     	andq	%rcx, %rsi
    4f9d: 4c 09 fe                     	orq	%r15, %rsi
    4fa0: 49 89 d7                     	movq	%rdx, %r15
    4fa3: 49 c1 c7 32                  	rolq	$0x32, %r15
    4fa7: 4c 01 e6                     	addq	%r12, %rsi
    4faa: 49 89 d4                     	movq	%rdx, %r12
    4fad: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    4fb1: 4c 01 f6                     	addq	%r14, %rsi
    4fb4: 49 89 d6                     	movq	%rdx, %r14
    4fb7: 49 c1 c6 17                  	rolq	$0x17, %r14
    4fbb: 4d 31 fc                     	xorq	%r15, %r12
    4fbe: 4d 31 e6                     	xorq	%r12, %r14
    4fc1: 4d 89 df                     	movq	%r11, %r15
    4fc4: 4d 31 cf                     	xorq	%r9, %r15
    4fc7: 49 21 d7                     	andq	%rdx, %r15
    4fca: 4d 31 cf                     	xorq	%r9, %r15
    4fcd: 4c 03 85 c8 fe ff ff         	addq	-0x138(%rbp), %r8
    4fd4: 4d 01 f8                     	addq	%r15, %r8
    4fd7: 49 bf b8 d1 bb 32 70 a0 6a 10	movabsq	$0x106aa07032bbd1b8, %r15 ## imm = 0x106AA07032BBD1B8
    4fe1: 4d 01 c7                     	addq	%r8, %r15
    4fe4: 4d 01 f7                     	addq	%r14, %r15
    4fe7: 4c 01 f9                     	addq	%r15, %rcx
    4fea: 49 89 f0                     	movq	%rsi, %r8
    4fed: 49 c1 c0 24                  	rolq	$0x24, %r8
    4ff1: 49 89 f6                     	movq	%rsi, %r14
    4ff4: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    4ff8: 4d 31 c6                     	xorq	%r8, %r14
    4ffb: 49 89 f4                     	movq	%rsi, %r12
    4ffe: 49 c1 c4 19                  	rolq	$0x19, %r12
    5002: 4d 31 f4                     	xorq	%r14, %r12
    5005: 49 89 de                     	movq	%rbx, %r14
    5008: 4d 09 d6                     	orq	%r10, %r14
    500b: 49 21 f6                     	andq	%rsi, %r14
    500e: 49 89 d8                     	movq	%rbx, %r8
    5011: 4d 21 d0                     	andq	%r10, %r8
    5014: 4d 09 f0                     	orq	%r14, %r8
    5017: 4d 01 e0                     	addq	%r12, %r8
    501a: 4d 01 f8                     	addq	%r15, %r8
    501d: 49 89 ce                     	movq	%rcx, %r14
    5020: 49 c1 c6 32                  	rolq	$0x32, %r14
    5024: 49 89 cf                     	movq	%rcx, %r15
    5027: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    502b: 4d 31 f7                     	xorq	%r14, %r15
    502e: 49 89 cc                     	movq	%rcx, %r12
    5031: 49 c1 c4 17                  	rolq	$0x17, %r12
    5035: 4d 31 fc                     	xorq	%r15, %r12
    5038: 49 89 d6                     	movq	%rdx, %r14
    503b: 4d 31 de                     	xorq	%r11, %r14
    503e: 49 21 ce                     	andq	%rcx, %r14
    5041: 4c 03 8d d0 fe ff ff         	addq	-0x130(%rbp), %r9
    5048: 4d 31 de                     	xorq	%r11, %r14
    504b: 4d 01 f1                     	addq	%r14, %r9
    504e: 49 be c8 d0 d2 b8 16 c1 a4 19	movabsq	$0x19a4c116b8d2d0c8, %r14 ## imm = 0x19A4C116B8D2D0C8
    5058: 4d 01 ce                     	addq	%r9, %r14
    505b: 4d 01 e6                     	addq	%r12, %r14
    505e: 4d 89 c1                     	movq	%r8, %r9
    5061: 49 c1 c1 24                  	rolq	$0x24, %r9
    5065: 4d 01 f2                     	addq	%r14, %r10
    5068: 4d 89 c7                     	movq	%r8, %r15
    506b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    506f: 4d 31 cf                     	xorq	%r9, %r15
    5072: 4d 89 c4                     	movq	%r8, %r12
    5075: 49 c1 c4 19                  	rolq	$0x19, %r12
    5079: 4d 31 fc                     	xorq	%r15, %r12
    507c: 49 89 f7                     	movq	%rsi, %r15
    507f: 49 09 df                     	orq	%rbx, %r15
    5082: 4d 21 c7                     	andq	%r8, %r15
    5085: 49 89 f1                     	movq	%rsi, %r9
    5088: 49 21 d9                     	andq	%rbx, %r9
    508b: 4d 09 f9                     	orq	%r15, %r9
    508e: 4d 01 e1                     	addq	%r12, %r9
    5091: 4d 01 f1                     	addq	%r14, %r9
    5094: 4d 89 d6                     	movq	%r10, %r14
    5097: 49 c1 c6 32                  	rolq	$0x32, %r14
    509b: 4d 89 d7                     	movq	%r10, %r15
    509e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    50a2: 4d 31 f7                     	xorq	%r14, %r15
    50a5: 4d 89 d4                     	movq	%r10, %r12
    50a8: 49 c1 c4 17                  	rolq	$0x17, %r12
    50ac: 4d 31 fc                     	xorq	%r15, %r12
    50af: 49 89 ce                     	movq	%rcx, %r14
    50b2: 49 31 d6                     	xorq	%rdx, %r14
    50b5: 4d 21 d6                     	andq	%r10, %r14
    50b8: 49 31 d6                     	xorq	%rdx, %r14
    50bb: 4c 03 9d d8 fe ff ff         	addq	-0x128(%rbp), %r11
    50c2: 4d 01 f3                     	addq	%r14, %r11
    50c5: 49 be 53 ab 41 51 08 6c 37 1e	movabsq	$0x1e376c085141ab53, %r14 ## imm = 0x1E376C085141AB53
    50cf: 4d 01 de                     	addq	%r11, %r14
    50d2: 4d 89 cb                     	movq	%r9, %r11
    50d5: 49 c1 c3 24                  	rolq	$0x24, %r11
    50d9: 4d 01 e6                     	addq	%r12, %r14
    50dc: 4d 89 cf                     	movq	%r9, %r15
    50df: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    50e3: 4c 01 f3                     	addq	%r14, %rbx
    50e6: 4d 89 cc                     	movq	%r9, %r12
    50e9: 49 c1 c4 19                  	rolq	$0x19, %r12
    50ed: 4d 31 df                     	xorq	%r11, %r15
    50f0: 4d 31 fc                     	xorq	%r15, %r12
    50f3: 4d 89 c7                     	movq	%r8, %r15
    50f6: 49 09 f7                     	orq	%rsi, %r15
    50f9: 4d 21 cf                     	andq	%r9, %r15
    50fc: 4d 89 c3                     	movq	%r8, %r11
    50ff: 49 21 f3                     	andq	%rsi, %r11
    5102: 4d 09 fb                     	orq	%r15, %r11
    5105: 4d 01 e3                     	addq	%r12, %r11
    5108: 49 89 df                     	movq	%rbx, %r15
    510b: 49 c1 c7 32                  	rolq	$0x32, %r15
    510f: 4d 01 f3                     	addq	%r14, %r11
    5112: 49 89 de                     	movq	%rbx, %r14
    5115: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5119: 4d 31 fe                     	xorq	%r15, %r14
    511c: 49 89 df                     	movq	%rbx, %r15
    511f: 49 c1 c7 17                  	rolq	$0x17, %r15
    5123: 4d 31 f7                     	xorq	%r14, %r15
    5126: 4d 89 d6                     	movq	%r10, %r14
    5129: 49 31 ce                     	xorq	%rcx, %r14
    512c: 49 21 de                     	andq	%rbx, %r14
    512f: 49 31 ce                     	xorq	%rcx, %r14
    5132: 48 03 95 e0 fe ff ff         	addq	-0x120(%rbp), %rdx
    5139: 4c 01 f2                     	addq	%r14, %rdx
    513c: 49 be 99 eb 8e df 4c 77 48 27	movabsq	$0x2748774cdf8eeb99, %r14 ## imm = 0x2748774CDF8EEB99
    5146: 49 01 d6                     	addq	%rdx, %r14
    5149: 4d 01 fe                     	addq	%r15, %r14
    514c: 4c 01 f6                     	addq	%r14, %rsi
    514f: 4c 89 da                     	movq	%r11, %rdx
    5152: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5156: 4d 89 df                     	movq	%r11, %r15
    5159: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    515d: 49 31 d7                     	xorq	%rdx, %r15
    5160: 4d 89 dc                     	movq	%r11, %r12
    5163: 49 c1 c4 19                  	rolq	$0x19, %r12
    5167: 4d 31 fc                     	xorq	%r15, %r12
    516a: 4d 89 cf                     	movq	%r9, %r15
    516d: 4d 09 c7                     	orq	%r8, %r15
    5170: 4d 21 df                     	andq	%r11, %r15
    5173: 4c 89 ca                     	movq	%r9, %rdx
    5176: 4c 21 c2                     	andq	%r8, %rdx
    5179: 4c 09 fa                     	orq	%r15, %rdx
    517c: 49 89 f7                     	movq	%rsi, %r15
    517f: 49 c1 c7 32                  	rolq	$0x32, %r15
    5183: 4c 01 e2                     	addq	%r12, %rdx
    5186: 49 89 f4                     	movq	%rsi, %r12
    5189: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    518d: 4c 01 f2                     	addq	%r14, %rdx
    5190: 49 89 f6                     	movq	%rsi, %r14
    5193: 49 c1 c6 17                  	rolq	$0x17, %r14
    5197: 4d 31 fc                     	xorq	%r15, %r12
    519a: 4d 31 e6                     	xorq	%r12, %r14
    519d: 49 89 df                     	movq	%rbx, %r15
    51a0: 4d 31 d7                     	xorq	%r10, %r15
    51a3: 49 21 f7                     	andq	%rsi, %r15
    51a6: 4d 31 d7                     	xorq	%r10, %r15
    51a9: 48 03 8d e8 fe ff ff         	addq	-0x118(%rbp), %rcx
    51b0: 4c 01 f9                     	addq	%r15, %rcx
    51b3: 49 bf a8 48 9b e1 b5 bc b0 34	movabsq	$0x34b0bcb5e19b48a8, %r15 ## imm = 0x34B0BCB5E19B48A8
    51bd: 49 01 cf                     	addq	%rcx, %r15
    51c0: 4d 01 f7                     	addq	%r14, %r15
    51c3: 4d 01 f8                     	addq	%r15, %r8
    51c6: 48 89 d1                     	movq	%rdx, %rcx
    51c9: 48 c1 c1 24                  	rolq	$0x24, %rcx
    51cd: 49 89 d6                     	movq	%rdx, %r14
    51d0: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    51d4: 49 31 ce                     	xorq	%rcx, %r14
    51d7: 49 89 d4                     	movq	%rdx, %r12
    51da: 49 c1 c4 19                  	rolq	$0x19, %r12
    51de: 4d 31 f4                     	xorq	%r14, %r12
    51e1: 4d 89 de                     	movq	%r11, %r14
    51e4: 4d 09 ce                     	orq	%r9, %r14
    51e7: 49 21 d6                     	andq	%rdx, %r14
    51ea: 4c 89 d9                     	movq	%r11, %rcx
    51ed: 4c 21 c9                     	andq	%r9, %rcx
    51f0: 4c 09 f1                     	orq	%r14, %rcx
    51f3: 4c 01 e1                     	addq	%r12, %rcx
    51f6: 4c 01 f9                     	addq	%r15, %rcx
    51f9: 4d 89 c6                     	movq	%r8, %r14
    51fc: 49 c1 c6 32                  	rolq	$0x32, %r14
    5200: 4d 89 c7                     	movq	%r8, %r15
    5203: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5207: 4d 31 f7                     	xorq	%r14, %r15
    520a: 4d 89 c4                     	movq	%r8, %r12
    520d: 49 c1 c4 17                  	rolq	$0x17, %r12
    5211: 4d 31 fc                     	xorq	%r15, %r12
    5214: 49 89 f6                     	movq	%rsi, %r14
    5217: 49 31 de                     	xorq	%rbx, %r14
    521a: 4d 21 c6                     	andq	%r8, %r14
    521d: 4c 03 95 f0 fe ff ff         	addq	-0x110(%rbp), %r10
    5224: 49 31 de                     	xorq	%rbx, %r14
    5227: 4d 01 f2                     	addq	%r14, %r10
    522a: 49 be 63 5a c9 c5 b3 0c 1c 39	movabsq	$0x391c0cb3c5c95a63, %r14 ## imm = 0x391C0CB3C5C95A63
    5234: 4d 01 d6                     	addq	%r10, %r14
    5237: 4d 01 e6                     	addq	%r12, %r14
    523a: 49 89 ca                     	movq	%rcx, %r10
    523d: 49 c1 c2 24                  	rolq	$0x24, %r10
    5241: 4d 01 f1                     	addq	%r14, %r9
    5244: 49 89 cf                     	movq	%rcx, %r15
    5247: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    524b: 4d 31 d7                     	xorq	%r10, %r15
    524e: 49 89 cc                     	movq	%rcx, %r12
    5251: 49 c1 c4 19                  	rolq	$0x19, %r12
    5255: 4d 31 fc                     	xorq	%r15, %r12
    5258: 49 89 d7                     	movq	%rdx, %r15
    525b: 4d 09 df                     	orq	%r11, %r15
    525e: 49 21 cf                     	andq	%rcx, %r15
    5261: 49 89 d2                     	movq	%rdx, %r10
    5264: 4d 21 da                     	andq	%r11, %r10
    5267: 4d 09 fa                     	orq	%r15, %r10
    526a: 4d 01 e2                     	addq	%r12, %r10
    526d: 4d 01 f2                     	addq	%r14, %r10
    5270: 4d 89 ce                     	movq	%r9, %r14
    5273: 49 c1 c6 32                  	rolq	$0x32, %r14
    5277: 4d 89 cf                     	movq	%r9, %r15
    527a: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    527e: 4d 31 f7                     	xorq	%r14, %r15
    5281: 4d 89 cc                     	movq	%r9, %r12
    5284: 49 c1 c4 17                  	rolq	$0x17, %r12
    5288: 4d 31 fc                     	xorq	%r15, %r12
    528b: 4d 89 c6                     	movq	%r8, %r14
    528e: 49 31 f6                     	xorq	%rsi, %r14
    5291: 4d 21 ce                     	andq	%r9, %r14
    5294: 49 31 f6                     	xorq	%rsi, %r14
    5297: 48 03 9d f8 fe ff ff         	addq	-0x108(%rbp), %rbx
    529e: 4c 01 f3                     	addq	%r14, %rbx
    52a1: 49 be cb 8a 41 e3 4a aa d8 4e	movabsq	$0x4ed8aa4ae3418acb, %r14 ## imm = 0x4ED8AA4AE3418ACB
    52ab: 49 01 de                     	addq	%rbx, %r14
    52ae: 4c 89 d3                     	movq	%r10, %rbx
    52b1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    52b5: 4d 01 e6                     	addq	%r12, %r14
    52b8: 4d 89 d7                     	movq	%r10, %r15
    52bb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    52bf: 4d 01 f3                     	addq	%r14, %r11
    52c2: 4d 89 d4                     	movq	%r10, %r12
    52c5: 49 c1 c4 19                  	rolq	$0x19, %r12
    52c9: 49 31 df                     	xorq	%rbx, %r15
    52cc: 4d 31 fc                     	xorq	%r15, %r12
    52cf: 49 89 cf                     	movq	%rcx, %r15
    52d2: 49 09 d7                     	orq	%rdx, %r15
    52d5: 4d 21 d7                     	andq	%r10, %r15
    52d8: 48 89 cb                     	movq	%rcx, %rbx
    52db: 48 21 d3                     	andq	%rdx, %rbx
    52de: 4c 09 fb                     	orq	%r15, %rbx
    52e1: 4c 01 e3                     	addq	%r12, %rbx
    52e4: 4d 89 df                     	movq	%r11, %r15
    52e7: 49 c1 c7 32                  	rolq	$0x32, %r15
    52eb: 4c 01 f3                     	addq	%r14, %rbx
    52ee: 4d 89 de                     	movq	%r11, %r14
    52f1: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    52f5: 4d 31 fe                     	xorq	%r15, %r14
    52f8: 4d 89 df                     	movq	%r11, %r15
    52fb: 49 c1 c7 17                  	rolq	$0x17, %r15
    52ff: 4d 31 f7                     	xorq	%r14, %r15
    5302: 4d 89 ce                     	movq	%r9, %r14
    5305: 4d 31 c6                     	xorq	%r8, %r14
    5308: 4d 21 de                     	andq	%r11, %r14
    530b: 4d 31 c6                     	xorq	%r8, %r14
    530e: 48 03 b5 00 ff ff ff         	addq	-0x100(%rbp), %rsi
    5315: 4c 01 f6                     	addq	%r14, %rsi
    5318: 49 be 73 e3 63 77 4f ca 9c 5b	movabsq	$0x5b9cca4f7763e373, %r14 ## imm = 0x5B9CCA4F7763E373
    5322: 49 01 f6                     	addq	%rsi, %r14
    5325: 4d 01 fe                     	addq	%r15, %r14
    5328: 4c 01 f2                     	addq	%r14, %rdx
    532b: 48 89 de                     	movq	%rbx, %rsi
    532e: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5332: 49 89 df                     	movq	%rbx, %r15
    5335: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5339: 49 31 f7                     	xorq	%rsi, %r15
    533c: 49 89 dc                     	movq	%rbx, %r12
    533f: 49 c1 c4 19                  	rolq	$0x19, %r12
    5343: 4d 31 fc                     	xorq	%r15, %r12
    5346: 4d 89 d7                     	movq	%r10, %r15
    5349: 49 09 cf                     	orq	%rcx, %r15
    534c: 49 21 df                     	andq	%rbx, %r15
    534f: 4c 89 d6                     	movq	%r10, %rsi
    5352: 48 21 ce                     	andq	%rcx, %rsi
    5355: 4c 09 fe                     	orq	%r15, %rsi
    5358: 49 89 d7                     	movq	%rdx, %r15
    535b: 49 c1 c7 32                  	rolq	$0x32, %r15
    535f: 4c 01 e6                     	addq	%r12, %rsi
    5362: 49 89 d4                     	movq	%rdx, %r12
    5365: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5369: 4c 01 f6                     	addq	%r14, %rsi
    536c: 49 89 d6                     	movq	%rdx, %r14
    536f: 49 c1 c6 17                  	rolq	$0x17, %r14
    5373: 4d 31 fc                     	xorq	%r15, %r12
    5376: 4d 31 e6                     	xorq	%r12, %r14
    5379: 4d 89 df                     	movq	%r11, %r15
    537c: 4d 31 cf                     	xorq	%r9, %r15
    537f: 49 21 d7                     	andq	%rdx, %r15
    5382: 4d 31 cf                     	xorq	%r9, %r15
    5385: 4c 03 85 08 ff ff ff         	addq	-0xf8(%rbp), %r8
    538c: 4d 01 f8                     	addq	%r15, %r8
    538f: 49 bf a3 b8 b2 d6 f3 6f 2e 68	movabsq	$0x682e6ff3d6b2b8a3, %r15 ## imm = 0x682E6FF3D6B2B8A3
    5399: 4d 01 c7                     	addq	%r8, %r15
    539c: 4d 01 f7                     	addq	%r14, %r15
    539f: 4c 01 f9                     	addq	%r15, %rcx
    53a2: 49 89 f0                     	movq	%rsi, %r8
    53a5: 49 c1 c0 24                  	rolq	$0x24, %r8
    53a9: 49 89 f6                     	movq	%rsi, %r14
    53ac: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    53b0: 4d 31 c6                     	xorq	%r8, %r14
    53b3: 49 89 f4                     	movq	%rsi, %r12
    53b6: 49 c1 c4 19                  	rolq	$0x19, %r12
    53ba: 4d 31 f4                     	xorq	%r14, %r12
    53bd: 49 89 de                     	movq	%rbx, %r14
    53c0: 4d 09 d6                     	orq	%r10, %r14
    53c3: 49 21 f6                     	andq	%rsi, %r14
    53c6: 49 89 d8                     	movq	%rbx, %r8
    53c9: 4d 21 d0                     	andq	%r10, %r8
    53cc: 4d 09 f0                     	orq	%r14, %r8
    53cf: 4d 01 e0                     	addq	%r12, %r8
    53d2: 4d 01 f8                     	addq	%r15, %r8
    53d5: 49 89 ce                     	movq	%rcx, %r14
    53d8: 49 c1 c6 32                  	rolq	$0x32, %r14
    53dc: 49 89 cf                     	movq	%rcx, %r15
    53df: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    53e3: 4d 31 f7                     	xorq	%r14, %r15
    53e6: 49 89 cc                     	movq	%rcx, %r12
    53e9: 49 c1 c4 17                  	rolq	$0x17, %r12
    53ed: 4d 31 fc                     	xorq	%r15, %r12
    53f0: 49 89 d6                     	movq	%rdx, %r14
    53f3: 4d 31 de                     	xorq	%r11, %r14
    53f6: 49 21 ce                     	andq	%rcx, %r14
    53f9: 4c 03 8d 10 ff ff ff         	addq	-0xf0(%rbp), %r9
    5400: 4d 31 de                     	xorq	%r11, %r14
    5403: 4d 01 f1                     	addq	%r14, %r9
    5406: 49 be fc b2 ef 5d ee 82 8f 74	movabsq	$0x748f82ee5defb2fc, %r14 ## imm = 0x748F82EE5DEFB2FC
    5410: 4d 01 ce                     	addq	%r9, %r14
    5413: 4d 01 e6                     	addq	%r12, %r14
    5416: 4d 89 c1                     	movq	%r8, %r9
    5419: 49 c1 c1 24                  	rolq	$0x24, %r9
    541d: 4d 01 f2                     	addq	%r14, %r10
    5420: 4d 89 c7                     	movq	%r8, %r15
    5423: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5427: 4d 31 cf                     	xorq	%r9, %r15
    542a: 4d 89 c4                     	movq	%r8, %r12
    542d: 49 c1 c4 19                  	rolq	$0x19, %r12
    5431: 4d 31 fc                     	xorq	%r15, %r12
    5434: 49 89 f7                     	movq	%rsi, %r15
    5437: 49 09 df                     	orq	%rbx, %r15
    543a: 4d 21 c7                     	andq	%r8, %r15
    543d: 49 89 f1                     	movq	%rsi, %r9
    5440: 49 21 d9                     	andq	%rbx, %r9
    5443: 4d 09 f9                     	orq	%r15, %r9
    5446: 4d 01 e1                     	addq	%r12, %r9
    5449: 4d 01 f1                     	addq	%r14, %r9
    544c: 4d 89 d6                     	movq	%r10, %r14
    544f: 49 c1 c6 32                  	rolq	$0x32, %r14
    5453: 4d 89 d7                     	movq	%r10, %r15
    5456: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    545a: 4d 31 f7                     	xorq	%r14, %r15
    545d: 4d 89 d4                     	movq	%r10, %r12
    5460: 49 c1 c4 17                  	rolq	$0x17, %r12
    5464: 4d 31 fc                     	xorq	%r15, %r12
    5467: 49 89 ce                     	movq	%rcx, %r14
    546a: 49 31 d6                     	xorq	%rdx, %r14
    546d: 4d 21 d6                     	andq	%r10, %r14
    5470: 49 31 d6                     	xorq	%rdx, %r14
    5473: 4c 03 9d 18 ff ff ff         	addq	-0xe8(%rbp), %r11
    547a: 4d 01 f3                     	addq	%r14, %r11
    547d: 49 be 60 2f 17 43 6f 63 a5 78	movabsq	$0x78a5636f43172f60, %r14 ## imm = 0x78A5636F43172F60
    5487: 4d 01 de                     	addq	%r11, %r14
    548a: 4d 89 cb                     	movq	%r9, %r11
    548d: 49 c1 c3 24                  	rolq	$0x24, %r11
    5491: 4d 01 e6                     	addq	%r12, %r14
    5494: 4d 89 cf                     	movq	%r9, %r15
    5497: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    549b: 4c 01 f3                     	addq	%r14, %rbx
    549e: 4d 89 cc                     	movq	%r9, %r12
    54a1: 49 c1 c4 19                  	rolq	$0x19, %r12
    54a5: 4d 31 df                     	xorq	%r11, %r15
    54a8: 4d 31 fc                     	xorq	%r15, %r12
    54ab: 4d 89 c7                     	movq	%r8, %r15
    54ae: 49 09 f7                     	orq	%rsi, %r15
    54b1: 4d 21 cf                     	andq	%r9, %r15
    54b4: 4d 89 c3                     	movq	%r8, %r11
    54b7: 49 21 f3                     	andq	%rsi, %r11
    54ba: 4d 09 fb                     	orq	%r15, %r11
    54bd: 4d 01 e3                     	addq	%r12, %r11
    54c0: 49 89 df                     	movq	%rbx, %r15
    54c3: 49 c1 c7 32                  	rolq	$0x32, %r15
    54c7: 4d 01 f3                     	addq	%r14, %r11
    54ca: 49 89 de                     	movq	%rbx, %r14
    54cd: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    54d1: 4d 31 fe                     	xorq	%r15, %r14
    54d4: 49 89 df                     	movq	%rbx, %r15
    54d7: 49 c1 c7 17                  	rolq	$0x17, %r15
    54db: 4d 31 f7                     	xorq	%r14, %r15
    54de: 4d 89 d6                     	movq	%r10, %r14
    54e1: 49 31 ce                     	xorq	%rcx, %r14
    54e4: 49 21 de                     	andq	%rbx, %r14
    54e7: 49 31 ce                     	xorq	%rcx, %r14
    54ea: 48 03 95 20 ff ff ff         	addq	-0xe0(%rbp), %rdx
    54f1: 4c 01 f2                     	addq	%r14, %rdx
    54f4: 49 be 72 ab f0 a1 14 78 c8 84	movabsq	$-0x7b3787eb5e0f548e, %r14 ## imm = 0x84C87814A1F0AB72
    54fe: 49 01 d6                     	addq	%rdx, %r14
    5501: 4d 01 fe                     	addq	%r15, %r14
    5504: 4c 01 f6                     	addq	%r14, %rsi
    5507: 4c 89 da                     	movq	%r11, %rdx
    550a: 48 c1 c2 24                  	rolq	$0x24, %rdx
    550e: 4d 89 df                     	movq	%r11, %r15
    5511: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5515: 49 31 d7                     	xorq	%rdx, %r15
    5518: 4d 89 dc                     	movq	%r11, %r12
    551b: 49 c1 c4 19                  	rolq	$0x19, %r12
    551f: 4d 31 fc                     	xorq	%r15, %r12
    5522: 4d 89 cf                     	movq	%r9, %r15
    5525: 4d 09 c7                     	orq	%r8, %r15
    5528: 4d 21 df                     	andq	%r11, %r15
    552b: 4c 89 ca                     	movq	%r9, %rdx
    552e: 4c 21 c2                     	andq	%r8, %rdx
    5531: 4c 09 fa                     	orq	%r15, %rdx
    5534: 49 89 f7                     	movq	%rsi, %r15
    5537: 49 c1 c7 32                  	rolq	$0x32, %r15
    553b: 4c 01 e2                     	addq	%r12, %rdx
    553e: 49 89 f4                     	movq	%rsi, %r12
    5541: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5545: 4c 01 f2                     	addq	%r14, %rdx
    5548: 49 89 f6                     	movq	%rsi, %r14
    554b: 49 c1 c6 17                  	rolq	$0x17, %r14
    554f: 4d 31 fc                     	xorq	%r15, %r12
    5552: 4d 31 e6                     	xorq	%r12, %r14
    5555: 49 89 df                     	movq	%rbx, %r15
    5558: 4d 31 d7                     	xorq	%r10, %r15
    555b: 49 21 f7                     	andq	%rsi, %r15
    555e: 4d 31 d7                     	xorq	%r10, %r15
    5561: 48 03 8d 28 ff ff ff         	addq	-0xd8(%rbp), %rcx
    5568: 4c 01 f9                     	addq	%r15, %rcx
    556b: 49 bf ec 39 64 1a 08 02 c7 8c	movabsq	$-0x7338fdf7e59bc614, %r15 ## imm = 0x8CC702081A6439EC
    5575: 49 01 cf                     	addq	%rcx, %r15
    5578: 4d 01 f7                     	addq	%r14, %r15
    557b: 4d 01 f8                     	addq	%r15, %r8
    557e: 48 89 d1                     	movq	%rdx, %rcx
    5581: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5585: 49 89 d6                     	movq	%rdx, %r14
    5588: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    558c: 49 31 ce                     	xorq	%rcx, %r14
    558f: 49 89 d4                     	movq	%rdx, %r12
    5592: 49 c1 c4 19                  	rolq	$0x19, %r12
    5596: 4d 31 f4                     	xorq	%r14, %r12
    5599: 4d 89 de                     	movq	%r11, %r14
    559c: 4d 09 ce                     	orq	%r9, %r14
    559f: 49 21 d6                     	andq	%rdx, %r14
    55a2: 4c 89 d9                     	movq	%r11, %rcx
    55a5: 4c 21 c9                     	andq	%r9, %rcx
    55a8: 4c 09 f1                     	orq	%r14, %rcx
    55ab: 4c 01 e1                     	addq	%r12, %rcx
    55ae: 4c 01 f9                     	addq	%r15, %rcx
    55b1: 4d 89 c6                     	movq	%r8, %r14
    55b4: 49 c1 c6 32                  	rolq	$0x32, %r14
    55b8: 4d 89 c7                     	movq	%r8, %r15
    55bb: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    55bf: 4d 31 f7                     	xorq	%r14, %r15
    55c2: 4d 89 c4                     	movq	%r8, %r12
    55c5: 49 c1 c4 17                  	rolq	$0x17, %r12
    55c9: 4d 31 fc                     	xorq	%r15, %r12
    55cc: 49 89 f6                     	movq	%rsi, %r14
    55cf: 49 31 de                     	xorq	%rbx, %r14
    55d2: 4d 21 c6                     	andq	%r8, %r14
    55d5: 4c 03 95 30 ff ff ff         	addq	-0xd0(%rbp), %r10
    55dc: 49 31 de                     	xorq	%rbx, %r14
    55df: 4d 01 f2                     	addq	%r14, %r10
    55e2: 49 be 28 1e 63 23 fa ff be 90	movabsq	$-0x6f410005dc9ce1d8, %r14 ## imm = 0x90BEFFFA23631E28
    55ec: 4d 01 d6                     	addq	%r10, %r14
    55ef: 4d 01 e6                     	addq	%r12, %r14
    55f2: 49 89 ca                     	movq	%rcx, %r10
    55f5: 49 c1 c2 24                  	rolq	$0x24, %r10
    55f9: 4d 01 f1                     	addq	%r14, %r9
    55fc: 49 89 cf                     	movq	%rcx, %r15
    55ff: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5603: 4d 31 d7                     	xorq	%r10, %r15
    5606: 49 89 cc                     	movq	%rcx, %r12
    5609: 49 c1 c4 19                  	rolq	$0x19, %r12
    560d: 4d 31 fc                     	xorq	%r15, %r12
    5610: 49 89 d7                     	movq	%rdx, %r15
    5613: 4d 09 df                     	orq	%r11, %r15
    5616: 49 21 cf                     	andq	%rcx, %r15
    5619: 49 89 d2                     	movq	%rdx, %r10
    561c: 4d 21 da                     	andq	%r11, %r10
    561f: 4d 09 fa                     	orq	%r15, %r10
    5622: 4d 01 e2                     	addq	%r12, %r10
    5625: 4d 01 f2                     	addq	%r14, %r10
    5628: 4d 89 ce                     	movq	%r9, %r14
    562b: 49 c1 c6 32                  	rolq	$0x32, %r14
    562f: 4d 89 cf                     	movq	%r9, %r15
    5632: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5636: 4d 31 f7                     	xorq	%r14, %r15
    5639: 4d 89 cc                     	movq	%r9, %r12
    563c: 49 c1 c4 17                  	rolq	$0x17, %r12
    5640: 4d 31 fc                     	xorq	%r15, %r12
    5643: 4d 89 c6                     	movq	%r8, %r14
    5646: 49 31 f6                     	xorq	%rsi, %r14
    5649: 4d 21 ce                     	andq	%r9, %r14
    564c: 49 31 f6                     	xorq	%rsi, %r14
    564f: 48 03 9d 38 ff ff ff         	addq	-0xc8(%rbp), %rbx
    5656: 4c 01 f3                     	addq	%r14, %rbx
    5659: 49 be e9 bd 82 de eb 6c 50 a4	movabsq	$-0x5baf9314217d4217, %r14 ## imm = 0xA4506CEBDE82BDE9
    5663: 49 01 de                     	addq	%rbx, %r14
    5666: 4c 89 d3                     	movq	%r10, %rbx
    5669: 48 c1 c3 24                  	rolq	$0x24, %rbx
    566d: 4d 01 e6                     	addq	%r12, %r14
    5670: 4d 89 d7                     	movq	%r10, %r15
    5673: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5677: 4d 01 f3                     	addq	%r14, %r11
    567a: 4d 89 d4                     	movq	%r10, %r12
    567d: 49 c1 c4 19                  	rolq	$0x19, %r12
    5681: 49 31 df                     	xorq	%rbx, %r15
    5684: 4d 31 fc                     	xorq	%r15, %r12
    5687: 49 89 cf                     	movq	%rcx, %r15
    568a: 49 09 d7                     	orq	%rdx, %r15
    568d: 4d 21 d7                     	andq	%r10, %r15
    5690: 48 89 cb                     	movq	%rcx, %rbx
    5693: 48 21 d3                     	andq	%rdx, %rbx
    5696: 4c 09 fb                     	orq	%r15, %rbx
    5699: 4c 01 e3                     	addq	%r12, %rbx
    569c: 4d 89 df                     	movq	%r11, %r15
    569f: 49 c1 c7 32                  	rolq	$0x32, %r15
    56a3: 4c 01 f3                     	addq	%r14, %rbx
    56a6: 4d 89 de                     	movq	%r11, %r14
    56a9: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    56ad: 4d 31 fe                     	xorq	%r15, %r14
    56b0: 4d 89 df                     	movq	%r11, %r15
    56b3: 49 c1 c7 17                  	rolq	$0x17, %r15
    56b7: 4d 31 f7                     	xorq	%r14, %r15
    56ba: 4d 89 ce                     	movq	%r9, %r14
    56bd: 4d 31 c6                     	xorq	%r8, %r14
    56c0: 4d 21 de                     	andq	%r11, %r14
    56c3: 4d 31 c6                     	xorq	%r8, %r14
    56c6: 48 03 b5 40 ff ff ff         	addq	-0xc0(%rbp), %rsi
    56cd: 4c 01 f6                     	addq	%r14, %rsi
    56d0: 49 be 15 79 c6 b2 f7 a3 f9 be	movabsq	$-0x41065c084d3986eb, %r14 ## imm = 0xBEF9A3F7B2C67915
    56da: 49 01 f6                     	addq	%rsi, %r14
    56dd: 4d 01 fe                     	addq	%r15, %r14
    56e0: 4c 01 f2                     	addq	%r14, %rdx
    56e3: 48 89 de                     	movq	%rbx, %rsi
    56e6: 48 c1 c6 24                  	rolq	$0x24, %rsi
    56ea: 49 89 df                     	movq	%rbx, %r15
    56ed: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    56f1: 49 31 f7                     	xorq	%rsi, %r15
    56f4: 49 89 dc                     	movq	%rbx, %r12
    56f7: 49 c1 c4 19                  	rolq	$0x19, %r12
    56fb: 4d 31 fc                     	xorq	%r15, %r12
    56fe: 4d 89 d7                     	movq	%r10, %r15
    5701: 49 09 cf                     	orq	%rcx, %r15
    5704: 49 21 df                     	andq	%rbx, %r15
    5707: 4c 89 d6                     	movq	%r10, %rsi
    570a: 48 21 ce                     	andq	%rcx, %rsi
    570d: 4c 09 fe                     	orq	%r15, %rsi
    5710: 49 89 d7                     	movq	%rdx, %r15
    5713: 49 c1 c7 32                  	rolq	$0x32, %r15
    5717: 4c 01 e6                     	addq	%r12, %rsi
    571a: 49 89 d4                     	movq	%rdx, %r12
    571d: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5721: 4c 01 f6                     	addq	%r14, %rsi
    5724: 49 89 d6                     	movq	%rdx, %r14
    5727: 49 c1 c6 17                  	rolq	$0x17, %r14
    572b: 4d 31 fc                     	xorq	%r15, %r12
    572e: 4d 31 e6                     	xorq	%r12, %r14
    5731: 4d 89 df                     	movq	%r11, %r15
    5734: 4d 31 cf                     	xorq	%r9, %r15
    5737: 49 21 d7                     	andq	%rdx, %r15
    573a: 4d 31 cf                     	xorq	%r9, %r15
    573d: 4c 03 85 48 ff ff ff         	addq	-0xb8(%rbp), %r8
    5744: 4d 01 f8                     	addq	%r15, %r8
    5747: 49 bf 2b 53 72 e3 f2 78 71 c6	movabsq	$-0x398e870d1c8dacd5, %r15 ## imm = 0xC67178F2E372532B
    5751: 4d 01 c7                     	addq	%r8, %r15
    5754: 4d 01 f7                     	addq	%r14, %r15
    5757: 4c 01 f9                     	addq	%r15, %rcx
    575a: 49 89 f0                     	movq	%rsi, %r8
    575d: 49 c1 c0 24                  	rolq	$0x24, %r8
    5761: 49 89 f6                     	movq	%rsi, %r14
    5764: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5768: 4d 31 c6                     	xorq	%r8, %r14
    576b: 49 89 f4                     	movq	%rsi, %r12
    576e: 49 c1 c4 19                  	rolq	$0x19, %r12
    5772: 4d 31 f4                     	xorq	%r14, %r12
    5775: 49 89 de                     	movq	%rbx, %r14
    5778: 4d 09 d6                     	orq	%r10, %r14
    577b: 49 21 f6                     	andq	%rsi, %r14
    577e: 49 89 d8                     	movq	%rbx, %r8
    5781: 4d 21 d0                     	andq	%r10, %r8
    5784: 4d 09 f0                     	orq	%r14, %r8
    5787: 4d 01 e0                     	addq	%r12, %r8
    578a: 4d 01 f8                     	addq	%r15, %r8
    578d: 49 89 ce                     	movq	%rcx, %r14
    5790: 49 c1 c6 32                  	rolq	$0x32, %r14
    5794: 49 89 cf                     	movq	%rcx, %r15
    5797: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    579b: 4d 31 f7                     	xorq	%r14, %r15
    579e: 49 89 cc                     	movq	%rcx, %r12
    57a1: 49 c1 c4 17                  	rolq	$0x17, %r12
    57a5: 4d 31 fc                     	xorq	%r15, %r12
    57a8: 49 89 d6                     	movq	%rdx, %r14
    57ab: 4d 31 de                     	xorq	%r11, %r14
    57ae: 49 21 ce                     	andq	%rcx, %r14
    57b1: 4c 03 8d 50 ff ff ff         	addq	-0xb0(%rbp), %r9
    57b8: 4d 31 de                     	xorq	%r11, %r14
    57bb: 4d 01 f1                     	addq	%r14, %r9
    57be: 49 be 9c 61 26 ea ce 3e 27 ca	movabsq	$-0x35d8c13115d99e64, %r14 ## imm = 0xCA273ECEEA26619C
    57c8: 4d 01 ce                     	addq	%r9, %r14
    57cb: 4d 01 e6                     	addq	%r12, %r14
    57ce: 4d 89 c1                     	movq	%r8, %r9
    57d1: 49 c1 c1 24                  	rolq	$0x24, %r9
    57d5: 4d 01 f2                     	addq	%r14, %r10
    57d8: 4d 89 c7                     	movq	%r8, %r15
    57db: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    57df: 4d 31 cf                     	xorq	%r9, %r15
    57e2: 4d 89 c4                     	movq	%r8, %r12
    57e5: 49 c1 c4 19                  	rolq	$0x19, %r12
    57e9: 4d 31 fc                     	xorq	%r15, %r12
    57ec: 49 89 f7                     	movq	%rsi, %r15
    57ef: 49 09 df                     	orq	%rbx, %r15
    57f2: 4d 21 c7                     	andq	%r8, %r15
    57f5: 49 89 f1                     	movq	%rsi, %r9
    57f8: 49 21 d9                     	andq	%rbx, %r9
    57fb: 4d 09 f9                     	orq	%r15, %r9
    57fe: 4d 01 e1                     	addq	%r12, %r9
    5801: 4d 01 f1                     	addq	%r14, %r9
    5804: 4d 89 d6                     	movq	%r10, %r14
    5807: 49 c1 c6 32                  	rolq	$0x32, %r14
    580b: 4d 89 d7                     	movq	%r10, %r15
    580e: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5812: 4d 31 f7                     	xorq	%r14, %r15
    5815: 4d 89 d4                     	movq	%r10, %r12
    5818: 49 c1 c4 17                  	rolq	$0x17, %r12
    581c: 4d 31 fc                     	xorq	%r15, %r12
    581f: 49 89 ce                     	movq	%rcx, %r14
    5822: 49 31 d6                     	xorq	%rdx, %r14
    5825: 4d 21 d6                     	andq	%r10, %r14
    5828: 49 31 d6                     	xorq	%rdx, %r14
    582b: 4c 03 9d 58 ff ff ff         	addq	-0xa8(%rbp), %r11
    5832: 4d 01 f3                     	addq	%r14, %r11
    5835: 49 be 07 c2 c0 21 c7 b8 86 d1	movabsq	$-0x2e794738de3f3df9, %r14 ## imm = 0xD186B8C721C0C207
    583f: 4d 01 de                     	addq	%r11, %r14
    5842: 4d 89 cb                     	movq	%r9, %r11
    5845: 49 c1 c3 24                  	rolq	$0x24, %r11
    5849: 4d 01 e6                     	addq	%r12, %r14
    584c: 4d 89 cf                     	movq	%r9, %r15
    584f: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5853: 4c 01 f3                     	addq	%r14, %rbx
    5856: 4d 89 cc                     	movq	%r9, %r12
    5859: 49 c1 c4 19                  	rolq	$0x19, %r12
    585d: 4d 31 df                     	xorq	%r11, %r15
    5860: 4d 31 fc                     	xorq	%r15, %r12
    5863: 4d 89 c7                     	movq	%r8, %r15
    5866: 49 09 f7                     	orq	%rsi, %r15
    5869: 4d 21 cf                     	andq	%r9, %r15
    586c: 4d 89 c3                     	movq	%r8, %r11
    586f: 49 21 f3                     	andq	%rsi, %r11
    5872: 4d 09 fb                     	orq	%r15, %r11
    5875: 4d 01 e3                     	addq	%r12, %r11
    5878: 49 89 df                     	movq	%rbx, %r15
    587b: 49 c1 c7 32                  	rolq	$0x32, %r15
    587f: 4d 01 f3                     	addq	%r14, %r11
    5882: 49 89 de                     	movq	%rbx, %r14
    5885: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5889: 4d 31 fe                     	xorq	%r15, %r14
    588c: 49 89 df                     	movq	%rbx, %r15
    588f: 49 c1 c7 17                  	rolq	$0x17, %r15
    5893: 4d 31 f7                     	xorq	%r14, %r15
    5896: 4d 89 d6                     	movq	%r10, %r14
    5899: 49 31 ce                     	xorq	%rcx, %r14
    589c: 49 21 de                     	andq	%rbx, %r14
    589f: 49 31 ce                     	xorq	%rcx, %r14
    58a2: 48 03 95 60 ff ff ff         	addq	-0xa0(%rbp), %rdx
    58a9: 4c 01 f2                     	addq	%r14, %rdx
    58ac: 49 be 1e eb e0 cd d6 7d da ea	movabsq	$-0x15258229321f14e2, %r14 ## imm = 0xEADA7DD6CDE0EB1E
    58b6: 49 01 d6                     	addq	%rdx, %r14
    58b9: 4d 01 fe                     	addq	%r15, %r14
    58bc: 4c 01 f6                     	addq	%r14, %rsi
    58bf: 4c 89 da                     	movq	%r11, %rdx
    58c2: 48 c1 c2 24                  	rolq	$0x24, %rdx
    58c6: 4d 89 df                     	movq	%r11, %r15
    58c9: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    58cd: 49 31 d7                     	xorq	%rdx, %r15
    58d0: 4d 89 dc                     	movq	%r11, %r12
    58d3: 49 c1 c4 19                  	rolq	$0x19, %r12
    58d7: 4d 31 fc                     	xorq	%r15, %r12
    58da: 4d 89 cf                     	movq	%r9, %r15
    58dd: 4d 09 c7                     	orq	%r8, %r15
    58e0: 4d 21 df                     	andq	%r11, %r15
    58e3: 4c 89 ca                     	movq	%r9, %rdx
    58e6: 4c 21 c2                     	andq	%r8, %rdx
    58e9: 4c 09 fa                     	orq	%r15, %rdx
    58ec: 49 89 f7                     	movq	%rsi, %r15
    58ef: 49 c1 c7 32                  	rolq	$0x32, %r15
    58f3: 4c 01 e2                     	addq	%r12, %rdx
    58f6: 49 89 f4                     	movq	%rsi, %r12
    58f9: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    58fd: 4c 01 f2                     	addq	%r14, %rdx
    5900: 49 89 f6                     	movq	%rsi, %r14
    5903: 49 c1 c6 17                  	rolq	$0x17, %r14
    5907: 4d 31 fc                     	xorq	%r15, %r12
    590a: 4d 31 e6                     	xorq	%r12, %r14
    590d: 49 89 df                     	movq	%rbx, %r15
    5910: 4d 31 d7                     	xorq	%r10, %r15
    5913: 49 21 f7                     	andq	%rsi, %r15
    5916: 4d 31 d7                     	xorq	%r10, %r15
    5919: 48 03 8d 68 ff ff ff         	addq	-0x98(%rbp), %rcx
    5920: 4c 01 f9                     	addq	%r15, %rcx
    5923: 49 bf 78 d1 6e ee 7f 4f 7d f5	movabsq	$-0xa82b08011912e88, %r15 ## imm = 0xF57D4F7FEE6ED178
    592d: 49 01 cf                     	addq	%rcx, %r15
    5930: 4d 01 f7                     	addq	%r14, %r15
    5933: 4d 01 f8                     	addq	%r15, %r8
    5936: 48 89 d1                     	movq	%rdx, %rcx
    5939: 48 c1 c1 24                  	rolq	$0x24, %rcx
    593d: 49 89 d6                     	movq	%rdx, %r14
    5940: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5944: 49 31 ce                     	xorq	%rcx, %r14
    5947: 49 89 d4                     	movq	%rdx, %r12
    594a: 49 c1 c4 19                  	rolq	$0x19, %r12
    594e: 4d 31 f4                     	xorq	%r14, %r12
    5951: 4d 89 de                     	movq	%r11, %r14
    5954: 4d 09 ce                     	orq	%r9, %r14
    5957: 49 21 d6                     	andq	%rdx, %r14
    595a: 4c 89 d9                     	movq	%r11, %rcx
    595d: 4c 21 c9                     	andq	%r9, %rcx
    5960: 4c 09 f1                     	orq	%r14, %rcx
    5963: 4c 01 e1                     	addq	%r12, %rcx
    5966: 4c 01 f9                     	addq	%r15, %rcx
    5969: 4d 89 c6                     	movq	%r8, %r14
    596c: 49 c1 c6 32                  	rolq	$0x32, %r14
    5970: 4d 89 c7                     	movq	%r8, %r15
    5973: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5977: 4d 31 f7                     	xorq	%r14, %r15
    597a: 4d 89 c4                     	movq	%r8, %r12
    597d: 49 c1 c4 17                  	rolq	$0x17, %r12
    5981: 4d 31 fc                     	xorq	%r15, %r12
    5984: 49 89 f6                     	movq	%rsi, %r14
    5987: 49 31 de                     	xorq	%rbx, %r14
    598a: 4d 21 c6                     	andq	%r8, %r14
    598d: 4c 03 95 70 ff ff ff         	addq	-0x90(%rbp), %r10
    5994: 49 31 de                     	xorq	%rbx, %r14
    5997: 4d 01 f2                     	addq	%r14, %r10
    599a: 49 be ba 6f 17 72 aa 67 f0 06	movabsq	$0x6f067aa72176fba, %r14 ## imm = 0x6F067AA72176FBA
    59a4: 4d 01 d6                     	addq	%r10, %r14
    59a7: 4d 01 e6                     	addq	%r12, %r14
    59aa: 49 89 ca                     	movq	%rcx, %r10
    59ad: 49 c1 c2 24                  	rolq	$0x24, %r10
    59b1: 4d 01 f1                     	addq	%r14, %r9
    59b4: 49 89 cf                     	movq	%rcx, %r15
    59b7: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    59bb: 4d 31 d7                     	xorq	%r10, %r15
    59be: 49 89 cc                     	movq	%rcx, %r12
    59c1: 49 c1 c4 19                  	rolq	$0x19, %r12
    59c5: 4d 31 fc                     	xorq	%r15, %r12
    59c8: 49 89 d7                     	movq	%rdx, %r15
    59cb: 4d 09 df                     	orq	%r11, %r15
    59ce: 49 21 cf                     	andq	%rcx, %r15
    59d1: 49 89 d2                     	movq	%rdx, %r10
    59d4: 4d 21 da                     	andq	%r11, %r10
    59d7: 4d 09 fa                     	orq	%r15, %r10
    59da: 4d 01 e2                     	addq	%r12, %r10
    59dd: 4d 01 f2                     	addq	%r14, %r10
    59e0: 4d 89 ce                     	movq	%r9, %r14
    59e3: 49 c1 c6 32                  	rolq	$0x32, %r14
    59e7: 4d 89 cf                     	movq	%r9, %r15
    59ea: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    59ee: 4d 31 f7                     	xorq	%r14, %r15
    59f1: 4d 89 cc                     	movq	%r9, %r12
    59f4: 49 c1 c4 17                  	rolq	$0x17, %r12
    59f8: 4d 31 fc                     	xorq	%r15, %r12
    59fb: 4d 89 c6                     	movq	%r8, %r14
    59fe: 49 31 f6                     	xorq	%rsi, %r14
    5a01: 4d 21 ce                     	andq	%r9, %r14
    5a04: 49 31 f6                     	xorq	%rsi, %r14
    5a07: 48 03 9d 78 ff ff ff         	addq	-0x88(%rbp), %rbx
    5a0e: 4c 01 f3                     	addq	%r14, %rbx
    5a11: 49 be a6 98 c8 a2 c5 7d 63 0a	movabsq	$0xa637dc5a2c898a6, %r14 ## imm = 0xA637DC5A2C898A6
    5a1b: 49 01 de                     	addq	%rbx, %r14
    5a1e: 4c 89 d3                     	movq	%r10, %rbx
    5a21: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5a25: 4d 01 e6                     	addq	%r12, %r14
    5a28: 4d 89 d7                     	movq	%r10, %r15
    5a2b: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5a2f: 4d 01 f3                     	addq	%r14, %r11
    5a32: 4d 89 d4                     	movq	%r10, %r12
    5a35: 49 c1 c4 19                  	rolq	$0x19, %r12
    5a39: 49 31 df                     	xorq	%rbx, %r15
    5a3c: 4d 31 fc                     	xorq	%r15, %r12
    5a3f: 49 89 cf                     	movq	%rcx, %r15
    5a42: 49 09 d7                     	orq	%rdx, %r15
    5a45: 4d 21 d7                     	andq	%r10, %r15
    5a48: 48 89 cb                     	movq	%rcx, %rbx
    5a4b: 48 21 d3                     	andq	%rdx, %rbx
    5a4e: 4c 09 fb                     	orq	%r15, %rbx
    5a51: 4c 01 e3                     	addq	%r12, %rbx
    5a54: 4d 89 df                     	movq	%r11, %r15
    5a57: 49 c1 c7 32                  	rolq	$0x32, %r15
    5a5b: 4c 01 f3                     	addq	%r14, %rbx
    5a5e: 4d 89 de                     	movq	%r11, %r14
    5a61: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5a65: 4d 31 fe                     	xorq	%r15, %r14
    5a68: 4d 89 df                     	movq	%r11, %r15
    5a6b: 49 c1 c7 17                  	rolq	$0x17, %r15
    5a6f: 4d 31 f7                     	xorq	%r14, %r15
    5a72: 4d 89 ce                     	movq	%r9, %r14
    5a75: 4d 31 c6                     	xorq	%r8, %r14
    5a78: 4d 21 de                     	andq	%r11, %r14
    5a7b: 4d 31 c6                     	xorq	%r8, %r14
    5a7e: 48 03 75 80                  	addq	-0x80(%rbp), %rsi
    5a82: 4c 01 f6                     	addq	%r14, %rsi
    5a85: 49 be ae 0d f9 be 04 98 3f 11	movabsq	$0x113f9804bef90dae, %r14 ## imm = 0x113F9804BEF90DAE
    5a8f: 49 01 f6                     	addq	%rsi, %r14
    5a92: 4d 01 fe                     	addq	%r15, %r14
    5a95: 4c 01 f2                     	addq	%r14, %rdx
    5a98: 48 89 de                     	movq	%rbx, %rsi
    5a9b: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5a9f: 49 89 df                     	movq	%rbx, %r15
    5aa2: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5aa6: 49 31 f7                     	xorq	%rsi, %r15
    5aa9: 49 89 dc                     	movq	%rbx, %r12
    5aac: 49 c1 c4 19                  	rolq	$0x19, %r12
    5ab0: 4d 31 fc                     	xorq	%r15, %r12
    5ab3: 4d 89 d7                     	movq	%r10, %r15
    5ab6: 49 09 cf                     	orq	%rcx, %r15
    5ab9: 49 21 df                     	andq	%rbx, %r15
    5abc: 4c 89 d6                     	movq	%r10, %rsi
    5abf: 48 21 ce                     	andq	%rcx, %rsi
    5ac2: 4c 09 fe                     	orq	%r15, %rsi
    5ac5: 49 89 d7                     	movq	%rdx, %r15
    5ac8: 49 c1 c7 32                  	rolq	$0x32, %r15
    5acc: 4c 01 e6                     	addq	%r12, %rsi
    5acf: 49 89 d4                     	movq	%rdx, %r12
    5ad2: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5ad6: 4c 01 f6                     	addq	%r14, %rsi
    5ad9: 49 89 d6                     	movq	%rdx, %r14
    5adc: 49 c1 c6 17                  	rolq	$0x17, %r14
    5ae0: 4d 31 fc                     	xorq	%r15, %r12
    5ae3: 4d 31 e6                     	xorq	%r12, %r14
    5ae6: 4d 89 df                     	movq	%r11, %r15
    5ae9: 4d 31 cf                     	xorq	%r9, %r15
    5aec: 49 21 d7                     	andq	%rdx, %r15
    5aef: 4d 31 cf                     	xorq	%r9, %r15
    5af2: 4c 03 45 88                  	addq	-0x78(%rbp), %r8
    5af6: 4d 01 f8                     	addq	%r15, %r8
    5af9: 49 bf 1b 47 1c 13 35 0b 71 1b	movabsq	$0x1b710b35131c471b, %r15 ## imm = 0x1B710B35131C471B
    5b03: 4d 01 c7                     	addq	%r8, %r15
    5b06: 4d 01 f7                     	addq	%r14, %r15
    5b09: 4c 01 f9                     	addq	%r15, %rcx
    5b0c: 49 89 f0                     	movq	%rsi, %r8
    5b0f: 49 c1 c0 24                  	rolq	$0x24, %r8
    5b13: 49 89 f6                     	movq	%rsi, %r14
    5b16: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5b1a: 4d 31 c6                     	xorq	%r8, %r14
    5b1d: 49 89 f4                     	movq	%rsi, %r12
    5b20: 49 c1 c4 19                  	rolq	$0x19, %r12
    5b24: 4d 31 f4                     	xorq	%r14, %r12
    5b27: 49 89 de                     	movq	%rbx, %r14
    5b2a: 4d 09 d6                     	orq	%r10, %r14
    5b2d: 49 21 f6                     	andq	%rsi, %r14
    5b30: 49 89 d8                     	movq	%rbx, %r8
    5b33: 4d 21 d0                     	andq	%r10, %r8
    5b36: 4d 09 f0                     	orq	%r14, %r8
    5b39: 4d 01 e0                     	addq	%r12, %r8
    5b3c: 4d 01 f8                     	addq	%r15, %r8
    5b3f: 49 89 ce                     	movq	%rcx, %r14
    5b42: 49 c1 c6 32                  	rolq	$0x32, %r14
    5b46: 49 89 cf                     	movq	%rcx, %r15
    5b49: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5b4d: 4d 31 f7                     	xorq	%r14, %r15
    5b50: 49 89 cc                     	movq	%rcx, %r12
    5b53: 49 c1 c4 17                  	rolq	$0x17, %r12
    5b57: 4d 31 fc                     	xorq	%r15, %r12
    5b5a: 49 89 d6                     	movq	%rdx, %r14
    5b5d: 4d 31 de                     	xorq	%r11, %r14
    5b60: 49 21 ce                     	andq	%rcx, %r14
    5b63: 4c 03 4d 90                  	addq	-0x70(%rbp), %r9
    5b67: 4d 31 de                     	xorq	%r11, %r14
    5b6a: 4d 01 f1                     	addq	%r14, %r9
    5b6d: 49 be 84 7d 04 23 f5 77 db 28	movabsq	$0x28db77f523047d84, %r14 ## imm = 0x28DB77F523047D84
    5b77: 4d 01 ce                     	addq	%r9, %r14
    5b7a: 4d 01 e6                     	addq	%r12, %r14
    5b7d: 4d 89 c1                     	movq	%r8, %r9
    5b80: 49 c1 c1 24                  	rolq	$0x24, %r9
    5b84: 4d 01 f2                     	addq	%r14, %r10
    5b87: 4d 89 c7                     	movq	%r8, %r15
    5b8a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5b8e: 4d 31 cf                     	xorq	%r9, %r15
    5b91: 4d 89 c4                     	movq	%r8, %r12
    5b94: 49 c1 c4 19                  	rolq	$0x19, %r12
    5b98: 4d 31 fc                     	xorq	%r15, %r12
    5b9b: 49 89 f7                     	movq	%rsi, %r15
    5b9e: 49 09 df                     	orq	%rbx, %r15
    5ba1: 4d 21 c7                     	andq	%r8, %r15
    5ba4: 49 89 f1                     	movq	%rsi, %r9
    5ba7: 49 21 d9                     	andq	%rbx, %r9
    5baa: 4d 09 f9                     	orq	%r15, %r9
    5bad: 4d 01 e1                     	addq	%r12, %r9
    5bb0: 4d 01 f1                     	addq	%r14, %r9
    5bb3: 4d 89 d6                     	movq	%r10, %r14
    5bb6: 49 c1 c6 32                  	rolq	$0x32, %r14
    5bba: 4d 89 d7                     	movq	%r10, %r15
    5bbd: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5bc1: 4d 31 f7                     	xorq	%r14, %r15
    5bc4: 4d 89 d4                     	movq	%r10, %r12
    5bc7: 49 c1 c4 17                  	rolq	$0x17, %r12
    5bcb: 4d 31 fc                     	xorq	%r15, %r12
    5bce: 49 89 ce                     	movq	%rcx, %r14
    5bd1: 49 31 d6                     	xorq	%rdx, %r14
    5bd4: 4d 21 d6                     	andq	%r10, %r14
    5bd7: 49 31 d6                     	xorq	%rdx, %r14
    5bda: 4c 03 5d 98                  	addq	-0x68(%rbp), %r11
    5bde: 4d 01 f3                     	addq	%r14, %r11
    5be1: 49 be 93 24 c7 40 7b ab ca 32	movabsq	$0x32caab7b40c72493, %r14 ## imm = 0x32CAAB7B40C72493
    5beb: 4d 01 de                     	addq	%r11, %r14
    5bee: 4d 89 cb                     	movq	%r9, %r11
    5bf1: 49 c1 c3 24                  	rolq	$0x24, %r11
    5bf5: 4d 01 e6                     	addq	%r12, %r14
    5bf8: 4d 89 cf                     	movq	%r9, %r15
    5bfb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5bff: 4c 01 f3                     	addq	%r14, %rbx
    5c02: 4d 89 cc                     	movq	%r9, %r12
    5c05: 49 c1 c4 19                  	rolq	$0x19, %r12
    5c09: 4d 31 df                     	xorq	%r11, %r15
    5c0c: 4d 31 fc                     	xorq	%r15, %r12
    5c0f: 4d 89 c7                     	movq	%r8, %r15
    5c12: 49 09 f7                     	orq	%rsi, %r15
    5c15: 4d 21 cf                     	andq	%r9, %r15
    5c18: 4d 89 c3                     	movq	%r8, %r11
    5c1b: 49 21 f3                     	andq	%rsi, %r11
    5c1e: 4d 09 fb                     	orq	%r15, %r11
    5c21: 4d 01 e3                     	addq	%r12, %r11
    5c24: 49 89 df                     	movq	%rbx, %r15
    5c27: 49 c1 c7 32                  	rolq	$0x32, %r15
    5c2b: 4d 01 f3                     	addq	%r14, %r11
    5c2e: 49 89 de                     	movq	%rbx, %r14
    5c31: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5c35: 4d 31 fe                     	xorq	%r15, %r14
    5c38: 49 89 df                     	movq	%rbx, %r15
    5c3b: 49 c1 c7 17                  	rolq	$0x17, %r15
    5c3f: 4d 31 f7                     	xorq	%r14, %r15
    5c42: 4d 89 d6                     	movq	%r10, %r14
    5c45: 49 31 ce                     	xorq	%rcx, %r14
    5c48: 49 21 de                     	andq	%rbx, %r14
    5c4b: 49 31 ce                     	xorq	%rcx, %r14
    5c4e: 48 03 55 a0                  	addq	-0x60(%rbp), %rdx
    5c52: 4c 01 f2                     	addq	%r14, %rdx
    5c55: 49 be bc be c9 15 0a be 9e 3c	movabsq	$0x3c9ebe0a15c9bebc, %r14 ## imm = 0x3C9EBE0A15C9BEBC
    5c5f: 49 01 d6                     	addq	%rdx, %r14
    5c62: 4d 01 fe                     	addq	%r15, %r14
    5c65: 4c 01 f6                     	addq	%r14, %rsi
    5c68: 4c 89 da                     	movq	%r11, %rdx
    5c6b: 48 c1 c2 24                  	rolq	$0x24, %rdx
    5c6f: 4d 89 df                     	movq	%r11, %r15
    5c72: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5c76: 49 31 d7                     	xorq	%rdx, %r15
    5c79: 4d 89 dc                     	movq	%r11, %r12
    5c7c: 49 c1 c4 19                  	rolq	$0x19, %r12
    5c80: 4d 31 fc                     	xorq	%r15, %r12
    5c83: 4d 89 cf                     	movq	%r9, %r15
    5c86: 4d 09 c7                     	orq	%r8, %r15
    5c89: 4d 21 df                     	andq	%r11, %r15
    5c8c: 4c 89 ca                     	movq	%r9, %rdx
    5c8f: 4c 21 c2                     	andq	%r8, %rdx
    5c92: 4c 09 fa                     	orq	%r15, %rdx
    5c95: 49 89 f7                     	movq	%rsi, %r15
    5c98: 49 c1 c7 32                  	rolq	$0x32, %r15
    5c9c: 4c 01 e2                     	addq	%r12, %rdx
    5c9f: 49 89 f4                     	movq	%rsi, %r12
    5ca2: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5ca6: 4c 01 f2                     	addq	%r14, %rdx
    5ca9: 49 89 f6                     	movq	%rsi, %r14
    5cac: 49 c1 c6 17                  	rolq	$0x17, %r14
    5cb0: 4d 31 fc                     	xorq	%r15, %r12
    5cb3: 4d 31 e6                     	xorq	%r12, %r14
    5cb6: 49 89 df                     	movq	%rbx, %r15
    5cb9: 4d 31 d7                     	xorq	%r10, %r15
    5cbc: 49 21 f7                     	andq	%rsi, %r15
    5cbf: 4d 31 d7                     	xorq	%r10, %r15
    5cc2: 48 03 4d a8                  	addq	-0x58(%rbp), %rcx
    5cc6: 4c 01 f9                     	addq	%r15, %rcx
    5cc9: 49 bf 4c 0d 10 9c c4 67 1d 43	movabsq	$0x431d67c49c100d4c, %r15 ## imm = 0x431D67C49C100D4C
    5cd3: 49 01 cf                     	addq	%rcx, %r15
    5cd6: 4d 01 f7                     	addq	%r14, %r15
    5cd9: 4d 01 f8                     	addq	%r15, %r8
    5cdc: 48 89 d1                     	movq	%rdx, %rcx
    5cdf: 48 c1 c1 24                  	rolq	$0x24, %rcx
    5ce3: 49 89 d6                     	movq	%rdx, %r14
    5ce6: 49 c1 c6 1e                  	rolq	$0x1e, %r14
    5cea: 49 31 ce                     	xorq	%rcx, %r14
    5ced: 49 89 d4                     	movq	%rdx, %r12
    5cf0: 49 c1 c4 19                  	rolq	$0x19, %r12
    5cf4: 4d 31 f4                     	xorq	%r14, %r12
    5cf7: 4d 89 de                     	movq	%r11, %r14
    5cfa: 4d 09 ce                     	orq	%r9, %r14
    5cfd: 49 21 d6                     	andq	%rdx, %r14
    5d00: 4c 89 d9                     	movq	%r11, %rcx
    5d03: 4c 21 c9                     	andq	%r9, %rcx
    5d06: 4c 09 f1                     	orq	%r14, %rcx
    5d09: 4c 01 e1                     	addq	%r12, %rcx
    5d0c: 4c 01 f9                     	addq	%r15, %rcx
    5d0f: 4d 89 c6                     	movq	%r8, %r14
    5d12: 49 c1 c6 32                  	rolq	$0x32, %r14
    5d16: 4d 89 c7                     	movq	%r8, %r15
    5d19: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5d1d: 4d 31 f7                     	xorq	%r14, %r15
    5d20: 4d 89 c4                     	movq	%r8, %r12
    5d23: 49 c1 c4 17                  	rolq	$0x17, %r12
    5d27: 4d 31 fc                     	xorq	%r15, %r12
    5d2a: 49 89 f6                     	movq	%rsi, %r14
    5d2d: 49 31 de                     	xorq	%rbx, %r14
    5d30: 4d 21 c6                     	andq	%r8, %r14
    5d33: 4c 03 55 b0                  	addq	-0x50(%rbp), %r10
    5d37: 49 31 de                     	xorq	%rbx, %r14
    5d3a: 4d 01 f2                     	addq	%r14, %r10
    5d3d: 49 be b6 42 3e cb be d4 c5 4c	movabsq	$0x4cc5d4becb3e42b6, %r14 ## imm = 0x4CC5D4BECB3E42B6
    5d47: 4d 01 d6                     	addq	%r10, %r14
    5d4a: 4d 01 e6                     	addq	%r12, %r14
    5d4d: 49 89 ca                     	movq	%rcx, %r10
    5d50: 49 c1 c2 24                  	rolq	$0x24, %r10
    5d54: 4d 01 f1                     	addq	%r14, %r9
    5d57: 49 89 cf                     	movq	%rcx, %r15
    5d5a: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5d5e: 4d 31 d7                     	xorq	%r10, %r15
    5d61: 49 89 cc                     	movq	%rcx, %r12
    5d64: 49 c1 c4 19                  	rolq	$0x19, %r12
    5d68: 4d 31 fc                     	xorq	%r15, %r12
    5d6b: 49 89 d7                     	movq	%rdx, %r15
    5d6e: 4d 09 df                     	orq	%r11, %r15
    5d71: 49 21 cf                     	andq	%rcx, %r15
    5d74: 49 89 d2                     	movq	%rdx, %r10
    5d77: 4d 21 da                     	andq	%r11, %r10
    5d7a: 4d 09 fa                     	orq	%r15, %r10
    5d7d: 4d 01 e2                     	addq	%r12, %r10
    5d80: 4d 01 f2                     	addq	%r14, %r10
    5d83: 4d 89 ce                     	movq	%r9, %r14
    5d86: 49 c1 c6 32                  	rolq	$0x32, %r14
    5d8a: 4d 89 cf                     	movq	%r9, %r15
    5d8d: 49 c1 c7 2e                  	rolq	$0x2e, %r15
    5d91: 4d 31 f7                     	xorq	%r14, %r15
    5d94: 4d 89 cc                     	movq	%r9, %r12
    5d97: 49 c1 c4 17                  	rolq	$0x17, %r12
    5d9b: 4d 31 fc                     	xorq	%r15, %r12
    5d9e: 4d 89 c6                     	movq	%r8, %r14
    5da1: 49 31 f6                     	xorq	%rsi, %r14
    5da4: 4d 21 ce                     	andq	%r9, %r14
    5da7: 49 31 f6                     	xorq	%rsi, %r14
    5daa: 48 03 5d b8                  	addq	-0x48(%rbp), %rbx
    5dae: 4c 01 f3                     	addq	%r14, %rbx
    5db1: 49 be 2a 7e 65 fc 9c 29 7f 59	movabsq	$0x597f299cfc657e2a, %r14 ## imm = 0x597F299CFC657E2A
    5dbb: 49 01 de                     	addq	%rbx, %r14
    5dbe: 4c 89 d3                     	movq	%r10, %rbx
    5dc1: 48 c1 c3 24                  	rolq	$0x24, %rbx
    5dc5: 4d 01 e6                     	addq	%r12, %r14
    5dc8: 4d 89 d7                     	movq	%r10, %r15
    5dcb: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5dcf: 4d 01 f3                     	addq	%r14, %r11
    5dd2: 4d 89 d4                     	movq	%r10, %r12
    5dd5: 49 c1 c4 19                  	rolq	$0x19, %r12
    5dd9: 49 31 df                     	xorq	%rbx, %r15
    5ddc: 4d 31 fc                     	xorq	%r15, %r12
    5ddf: 49 89 cf                     	movq	%rcx, %r15
    5de2: 49 09 d7                     	orq	%rdx, %r15
    5de5: 4d 21 d7                     	andq	%r10, %r15
    5de8: 48 89 cb                     	movq	%rcx, %rbx
    5deb: 48 21 d3                     	andq	%rdx, %rbx
    5dee: 4c 09 fb                     	orq	%r15, %rbx
    5df1: 4c 01 e3                     	addq	%r12, %rbx
    5df4: 4d 89 df                     	movq	%r11, %r15
    5df7: 49 c1 c7 32                  	rolq	$0x32, %r15
    5dfb: 4c 01 f3                     	addq	%r14, %rbx
    5dfe: 4d 89 de                     	movq	%r11, %r14
    5e01: 49 c1 c6 2e                  	rolq	$0x2e, %r14
    5e05: 4d 31 fe                     	xorq	%r15, %r14
    5e08: 4d 89 df                     	movq	%r11, %r15
    5e0b: 49 c1 c7 17                  	rolq	$0x17, %r15
    5e0f: 4d 31 f7                     	xorq	%r14, %r15
    5e12: 4d 89 ce                     	movq	%r9, %r14
    5e15: 4d 31 c6                     	xorq	%r8, %r14
    5e18: 4d 21 de                     	andq	%r11, %r14
    5e1b: 4d 31 c6                     	xorq	%r8, %r14
    5e1e: 48 03 75 c0                  	addq	-0x40(%rbp), %rsi
    5e22: 4c 01 f6                     	addq	%r14, %rsi
    5e25: 49 be ec fa d6 3a ab 6f cb 5f	movabsq	$0x5fcb6fab3ad6faec, %r14 ## imm = 0x5FCB6FAB3AD6FAEC
    5e2f: 49 01 f6                     	addq	%rsi, %r14
    5e32: 4d 01 fe                     	addq	%r15, %r14
    5e35: 4c 01 f2                     	addq	%r14, %rdx
    5e38: 48 89 de                     	movq	%rbx, %rsi
    5e3b: 48 c1 c6 24                  	rolq	$0x24, %rsi
    5e3f: 49 89 df                     	movq	%rbx, %r15
    5e42: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5e46: 49 31 f7                     	xorq	%rsi, %r15
    5e49: 49 89 dc                     	movq	%rbx, %r12
    5e4c: 49 c1 c4 19                  	rolq	$0x19, %r12
    5e50: 4d 31 fc                     	xorq	%r15, %r12
    5e53: 4d 89 d7                     	movq	%r10, %r15
    5e56: 49 09 cf                     	orq	%rcx, %r15
    5e59: 49 21 df                     	andq	%rbx, %r15
    5e5c: 4c 89 d6                     	movq	%r10, %rsi
    5e5f: 48 21 ce                     	andq	%rcx, %rsi
    5e62: 4c 09 fe                     	orq	%r15, %rsi
    5e65: 49 89 d7                     	movq	%rdx, %r15
    5e68: 49 c1 c7 32                  	rolq	$0x32, %r15
    5e6c: 4c 01 e6                     	addq	%r12, %rsi
    5e6f: 49 89 d4                     	movq	%rdx, %r12
    5e72: 49 c1 c4 2e                  	rolq	$0x2e, %r12
    5e76: 4c 01 f6                     	addq	%r14, %rsi
    5e79: 49 89 d5                     	movq	%rdx, %r13
    5e7c: 49 c1 c5 17                  	rolq	$0x17, %r13
    5e80: 4d 31 fc                     	xorq	%r15, %r12
    5e83: 4d 31 e5                     	xorq	%r12, %r13
    5e86: 4d 89 de                     	movq	%r11, %r14
    5e89: 4d 31 ce                     	xorq	%r9, %r14
    5e8c: 49 21 d6                     	andq	%rdx, %r14
    5e8f: 4d 31 ce                     	xorq	%r9, %r14
    5e92: 4c 03 45 c8                  	addq	-0x38(%rbp), %r8
    5e96: 4d 01 f0                     	addq	%r14, %r8
    5e99: 49 be 17 58 47 4a 8c 19 44 6c	movabsq	$0x6c44198c4a475817, %r14 ## imm = 0x6C44198C4A475817
    5ea3: 4d 01 c6                     	addq	%r8, %r14
    5ea6: 4d 01 ee                     	addq	%r13, %r14
    5ea9: 49 89 f0                     	movq	%rsi, %r8
    5eac: 49 c1 c0 24                  	rolq	$0x24, %r8
    5eb0: 49 89 f7                     	movq	%rsi, %r15
    5eb3: 49 c1 c7 1e                  	rolq	$0x1e, %r15
    5eb7: 4d 31 c7                     	xorq	%r8, %r15
    5eba: 49 89 f0                     	movq	%rsi, %r8
    5ebd: 49 c1 c0 19                  	rolq	$0x19, %r8
    5ec1: 4d 31 f8                     	xorq	%r15, %r8
    5ec4: 49 89 df                     	movq	%rbx, %r15
    5ec7: 4d 09 d7                     	orq	%r10, %r15
    5eca: 49 21 f7                     	andq	%rsi, %r15
    5ecd: 49 89 dc                     	movq	%rbx, %r12
    5ed0: 4d 21 d4                     	andq	%r10, %r12
    5ed3: 4d 09 fc                     	orq	%r15, %r12
    5ed6: 4d 01 c4                     	addq	%r8, %r12
    5ed9: 4d 01 f4                     	addq	%r14, %r12
    5edc: 49 01 c4                     	addq	%rax, %r12
    5edf: 4c 89 67 10                  	movq	%r12, 0x10(%rdi)
    5ee3: 48 01 77 18                  	addq	%rsi, 0x18(%rdi)
    5ee7: 48 01 5f 20                  	addq	%rbx, 0x20(%rdi)
    5eeb: 4c 01 57 28                  	addq	%r10, 0x28(%rdi)
    5eef: 4c 01 f1                     	addq	%r14, %rcx
    5ef2: 48 01 4f 30                  	addq	%rcx, 0x30(%rdi)
    5ef6: 48 01 57 38                  	addq	%rdx, 0x38(%rdi)
    5efa: 4c 01 5f 40                  	addq	%r11, 0x40(%rdi)
    5efe: 4c 01 4f 48                  	addq	%r9, 0x48(%rdi)
    5f02: 48 81 c4 08 02 00 00         	addq	$0x208, %rsp            ## imm = 0x208
    5f09: 5b                           	popq	%rbx
    5f0a: 41 5c                        	popq	%r12
    5f0c: 41 5d                        	popq	%r13
    5f0e: 41 5e                        	popq	%r14
    5f10: 41 5f                        	popq	%r15
    5f12: 5d                           	popq	%rbp
    5f13: c3                           	retq
    5f14: 66 2e 0f 1f 84 00 00 00 00 00	nopw	%cs:(%rax,%rax)
    5f1e: 66 90                        	nop

0000000000005f20 <_audit_master384>:
    5f20: 55                           	pushq	%rbp
    5f21: 48 89 e5                     	movq	%rsp, %rbp
    5f24: 41 56                        	pushq	%r14
    5f26: 53                           	pushq	%rbx
    5f27: 48 81 ec 70 01 00 00         	subq	$0x170, %rsp            ## imm = 0x170
    5f2e: 48 89 f3                     	movq	%rsi, %rbx
    5f31: 49 89 f8                     	movq	%rdi, %r8
    5f34: 66 c7 85 80 fe ff ff 00 30   	movw	$0x3000, -0x180(%rbp)   ## imm = 0x3000
    5f3d: c6 85 82 fe ff ff 0d         	movb	$0xd, -0x17e(%rbp)
    5f44: 48 b8 74 6c 73 31 33 20 64 65	movabsq	$0x6564203331736c74, %rax ## imm = 0x6564203331736C74
    5f4e: 48 89 85 83 fe ff ff         	movq	%rax, -0x17d(%rbp)
    5f55: 48 b8 20 64 65 72 69 76 65 64	movabsq	$0x6465766972656420, %rax ## imm = 0x6465766972656420
    5f5f: 48 89 85 88 fe ff ff         	movq	%rax, -0x178(%rbp)
    5f66: c6 85 90 fe ff ff 30         	movb	$0x30, -0x170(%rbp)
    5f6d: 48 b8 38 b0 60 a7 51 ac 96 38	movabsq	$0x3896ac51a760b038, %rax ## imm = 0x3896AC51A760B038
    5f77: 48 89 85 91 fe ff ff         	movq	%rax, -0x16f(%rbp)
    5f7e: 48 b8 4c d9 32 7e b1 b1 e3 6a	movabsq	$0x6ae3b1b17e32d94c, %rax ## imm = 0x6AE3B1B17E32D94C
    5f88: 48 89 85 99 fe ff ff         	movq	%rax, -0x167(%rbp)
    5f8f: 48 b8 21 fd b7 11 14 be 07 43	movabsq	$0x4307be1411b7fd21, %rax ## imm = 0x4307BE1411B7FD21
    5f99: 48 89 85 a1 fe ff ff         	movq	%rax, -0x15f(%rbp)
    5fa0: 48 b8 4c 0c c7 bf 63 f6 e1 da	movabsq	$-0x251e099c4038f3b4, %rax ## imm = 0xDAE1F663BFC70C4C
    5faa: 48 89 85 a9 fe ff ff         	movq	%rax, -0x157(%rbp)
    5fb1: 48 b8 27 4e de bf e7 6f 65 fb	movabsq	$-0x49a90184021b1d9, %rax ## imm = 0xFB656FE7BFDE4E27
    5fbb: 48 89 85 b1 fe ff ff         	movq	%rax, -0x14f(%rbp)
    5fc2: 48 b8 d5 1a d2 f1 48 98 b9 5b	movabsq	$0x5bb99848f1d21ad5, %rax ## imm = 0x5BB99848F1D21AD5
    5fcc: 48 89 85 b9 fe ff ff         	movq	%rax, -0x147(%rbp)
    5fd3: 4c 8d 75 90                  	leaq	-0x70(%rbp), %r14
    5fd7: 48 8d 95 80 fe ff ff         	leaq	-0x180(%rbp), %rdx
    5fde: be 30 00 00 00               	movl	$0x30, %esi
    5fe3: b9 41 00 00 00               	movl	$0x41, %ecx
    5fe8: 4c 89 f7                     	movq	%r14, %rdi
    5feb: e8 00 00 00 00               	callq	 <L0>
		0000000000005fec:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    5ff0: 48 8d 15 00 00 00 00         	leaq	, %rdx <_audit_master384+0xd7>
		0000000000005ff3:  X86_64_RELOC_SIGNED	_memx.Array(48).zero
    5ff7: 48 8d 7d c0                  	leaq	-0x40(%rbp), %rdi
    5ffb: 4c 89 f6                     	movq	%r14, %rsi
    5ffe: e8 00 00 00 00               	callq	 <L1>
		0000000000005fff:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).extract
<L1>:
    6003: 0f 57 c0                     	xorps	%xmm0, %xmm0
    6006: 0f 29 45 b0                  	movaps	%xmm0, -0x50(%rbp)
    600a: 0f 29 45 a0                  	movaps	%xmm0, -0x60(%rbp)
    600e: 0f 29 45 90                  	movaps	%xmm0, -0x70(%rbp)
    6012: 48 8b 45 e8                  	movq	-0x18(%rbp), %rax
    6016: 48 89 43 28                  	movq	%rax, 0x28(%rbx)
    601a: 48 8b 45 e0                  	movq	-0x20(%rbp), %rax
    601e: 48 89 43 20                  	movq	%rax, 0x20(%rbx)
    6022: 48 8b 45 d8                  	movq	-0x28(%rbp), %rax
    6026: 48 89 43 18                  	movq	%rax, 0x18(%rbx)
    602a: 48 8b 45 d0                  	movq	-0x30(%rbp), %rax
    602e: 48 89 43 10                  	movq	%rax, 0x10(%rbx)
    6032: 48 8b 45 c0                  	movq	-0x40(%rbp), %rax
    6036: 48 8b 4d c8                  	movq	-0x38(%rbp), %rcx
    603a: 48 89 4b 08                  	movq	%rcx, 0x8(%rbx)
    603e: 48 89 03                     	movq	%rax, (%rbx)
    6041: 48 81 c4 70 01 00 00         	addq	$0x170, %rsp            ## imm = 0x170
    6048: 5b                           	popq	%rbx
    6049: 41 5e                        	popq	%r14
    604b: 5d                           	popq	%rbp
    604c: c3                           	retq
    604d: 0f 1f 00                     	nopl	(%rax)

0000000000006050 <_audit_key384>:
    6050: 55                           	pushq	%rbp
    6051: 48 89 e5                     	movq	%rsp, %rbp
    6054: 48 81 ec 10 01 00 00         	subq	$0x110, %rsp            ## imm = 0x110
    605b: 48 89 f0                     	movq	%rsi, %rax
    605e: 49 89 f8                     	movq	%rdi, %r8
    6061: 66 c7 85 f4 fe ff ff 00 20   	movw	$0x2000, -0x10c(%rbp)   ## imm = 0x2000
    606a: c6 85 f6 fe ff ff 09         	movb	$0x9, -0x10a(%rbp)
    6071: 48 b9 74 6c 73 31 33 20 6b 65	movabsq	$0x656b203331736c74, %rcx ## imm = 0x656B203331736C74
    607b: 48 89 8d f7 fe ff ff         	movq	%rcx, -0x109(%rbp)
    6082: 66 c7 85 ff fe ff ff 79 00   	movw	$0x79, -0x101(%rbp)
    608b: 48 8d 95 f4 fe ff ff         	leaq	-0x10c(%rbp), %rdx
    6092: be 20 00 00 00               	movl	$0x20, %esi
    6097: b9 0d 00 00 00               	movl	$0xd, %ecx
    609c: 48 89 c7                     	movq	%rax, %rdi
    609f: e8 00 00 00 00               	callq	 <L0>
		00000000000060a0:  X86_64_RELOC_BRANCH	_crypto.hkdf.Hkdf(crypto.hmac.Hmac(crypto.sha2.Sha2x64(.{ 14680500436340154072, 7105036623409894663, 10473403895298186519, 1526699215303891257, 7436329637833083697, 10282925794625328401, 15784041429090275239, 5167115440072839076 },384))).expand
<L0>:
    60a4: 48 81 c4 10 01 00 00         	addq	$0x110, %rsp            ## imm = 0x110
    60ab: 5d                           	popq	%rbp
    60ac: c3                           	retq
