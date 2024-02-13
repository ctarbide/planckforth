#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
SH=${SH:-sh}; export SH
PERL=${PERL:-perl}; export PERL
exec nofake-exec.sh --error -Rmain "$@" -- "${SH}" -eu
exit 1

This is a live literate program.

<<references>>=
- https://github.com/nineties/planckforth

@

<<data>>=
00000000: 7f45 4c46 0101 0100   # planckforth -
00000008: 0000 0000 0000 0000   # Copyright (C) 2021 nineties
00000010: 0200 0300 0100 0000   ET_EXEC,EM_386,EV_CURRENT
00000018: 7480 0408 3400 0000   e_entry=0x08048074,e_phoff=<phdr>
00000020: 0000 0000 0000 0000   e_shoff,e_flags
00000028: 3400 2000 0100 0000   e_ehsize,e_phentsize,e_phnum,e_shentsize
00000030: 0000 0000 0100 0000   e_shnum,e_shstrndx,<phdr>p_type=PT_LOAD
00000038: 0000 0000 0080 0408   p_offset,p_vaddr=0x08048000
00000040: 0000 0000 0004 0000   p_paddr,p_filesz
00000048: 0000 2000 0700 0000   p_memsz(128KB),p_flags=PF_X|PF_W|PF_R
00000050: 0010 0000 0084 0408   p_align, <here>
00000058: 3882 0408 0000 0000   <latest:init="V">, <sp0>
00000060: c080 0408 f080 0408   <interpreter>key, find
00000068: fc80 0408 d880 0408   execute, jump
00000070: f0ff ffff be60 8004   -16, movl $interpreter, %esi
00000078: 08bd 0080 0608 8925   movl $0x08068000,%ebp; movl %esp,sp0;
00000080: 5c80 0408 adff 2000   next;
00000088: 0000 0000 0151 0000   Q: quit
00000090: 4482 0408
00000094: 8880 0408 0143 0000   C: cell
0000009c: 4c82 0408
000000a0: 9480 0408 0168 0000   h: &here
000000a8: 5182 0408
000000ac: a080 0408 016c 0000   l: &latest
000000b4: 5982 0408
000000b8: ac80 0408 016b 0000   k: key
000000c0: 6182 0408
000000c4: b880 0408 0174 0000   t: type
000000cc: 7b82 0408
000000d0: c480 0408 016a 0000   j: branch
000000d8: 9182 0408
000000dc: d080 0408 014a 0000   J: 0branch
000000e4: 9682 0408
000000e8: dc80 0408 0166 0000   f: find
000000f0: 9f82 0408
000000f4: e880 0408 0178 0000   x: execute
000000fc: bf82 0408
00000100: f480 0408 0140 0000   @: fetch
00000108: c282 0408
0000010c: 0081 0408 0121 0000   !: store
00000114: c982 0408
00000118: 0c81 0408 013f 0000   ?: cfetch
00000120: d082 0408
00000124: 1881 0408 0124 0000   $: cstore
0000012c: d882 0408
00000130: 2481 0408 0164 0000   d: dfetch
00000138: df82 0408
0000013c: 3081 0408 0144 0000   D: dstore
00000144: e382 0408
00000148: 3c81 0408 0172 0000   r: rfetch
00000150: e782 0408
00000154: 4881 0408 0152 0000   R: rstore
0000015c: eb82 0408
00000160: 5481 0408 0169 0000   i: docol
00000168: fd82 0408
0000016c: 6081 0408 0165 0000   e: exit
00000174: 0583 0408
00000178: 6c81 0408 014c 0000   L: lit
00000180: 0e83 0408
00000184: 7881 0408 0153 0000   S: litstring
0000018c: 1383 0408
00000190: 8481 0408 012b 0000   +: add
00000198: 1c83 0408
0000019c: 9081 0408 012d 0000   -: sub
000001a4: 2383 0408
000001a8: 9c81 0408 012a 0000   *: mul
000001b0: 2a83 0408
000001b4: a881 0408 012f 0000   /: divmod
000001bc: 3383 0408
000001c0: b481 0408 0126 0000   &: and
000001c8: 3e83 0408
000001cc: c081 0408 017c 0000   |: or
000001d4: 4583 0408
000001d8: cc81 0408 015e 0000   ^: xor
000001e0: 4c83 0408
000001e4: d881 0408 013c 0000   <: less
000001ec: 5383 0408
000001f0: e481 0408 0175 0000   u: uless (unsigned less)
000001f8: 6183 0408
000001fc: f081 0408 013d 0000   =: equal
00000204: 6f83 0408
00000208: fc81 0408 0128 0000   (: shl
00000210: 7d83 0408
00000214: 0882 0408 0129 0000   ): shr
0000021c: 8583 0408
00000220: 1482 0408 0125 0000   %: sar
00000228: 8d83 0408
0000022c: 2082 0408 0176 0000   v: argv
00000234: 9583 0408
00000238: 2c82 0408 0156 0000   V: version
00000240: a483 0408
00000244: 5bb8 0100 0000 cd80   (quit) popl %ebx; mov $SYS_EXIT,%eax; inx $0x80
0000024c: 6a04 adff 20          (cell) pushl $4; next;
00000251: 6854 8004 08ad ff20   (&here) pushl $here; next;
00000259: 6858 8004 08ad ff20   (&latest) pushl $latest; next;
00000261: 31c0 50ba 0100 0000   (key) xorl %eax,%eax; pushl %eax; movl $1,%edx;
00000269: 89e1 31db b803 0000   movl %esp,%ecx; xorl %ebx,%ebx (STDIN=0);
00000271: 00cd 8085 c076 ccad   movl $SYS_READ,%eax; int $0x80; test %eax,%eax;
00000279: ff20                  jbe 0x08048244(-52); next;
0000027b: ba01 0000 0089 e189   (type) movl $1,%edx; movl %esp,%ecx;
00000283: d3b8 0400 0000 cd80   movl $1,%ebx (STDOUT=1);movl $SYS_WRITE,%eax;
0000028b: 83c4 04ad ff20        int $0x80; addl $4,%esp; next;
00000291: 0336 adff 20          (branch) addl (%esi),%esi; next;
00000296: 5885 c074 f6ad adff   (0branch) popl %eax; test %eax,%eax;
0000029e: 20                    je 0x08048292(-10); lodsl; next;
0000029f: 8a24 24b0 018b 0d58   (find) movb (%esp),%ah;movb $1,%al;
000002a7: 8004 088b 5904 6639   movl latest,%ecx;<1>movl 4(%ecx),%ebx;
000002af: c374 048b 09eb f483   cmpw %ax,%bx;je 2f;movl (%ecx),%ecx
000002b7: c108 890c 24ad ff20   jmp 1b(-12);<2>addl $8,%ecx;movl %ecx,(%esp); next;
000002bf: 58ff 20               (execute) popl %eax; jmp *(%eax)
000002c2: 588b 0050 adff 20     (fetch) popl %eax; movl (%eax),%eax;push %eax; next;
000002c9: 585b 8918 adff 20     (store) popl %eax; popl %ebx; movl %ebx,(%eax); next
000002d0: 580f be00 50ad ff20   (cfetch) popl %eax; movsbl (%eax),%eax; next;
000002d8: 585b 8818 adff 20     (cstore) popl %eax; popl %ebx; movb %bl,(%eax); next;
000002df: 54ad ff20             (dfetch) movl %esp,%eax; pushl %eax; next;
000002e3: 5cad ff20             (dstore) popl %eax; movl %eax,%esp; next;
000002e7: 55ad ff20             (rfetch) pushl %ebp; next;
000002eb: 5dad ff20             (rstore) popl %ebp; next;
000002ef: 8d6d fc89 7500 83c0   <docol>rpush %esi; addl $4,%eax
000002f7: 0489 c6ad ff20        movl %eax,%esi; next;
000002fd: 68ef 8204 08ad ff20   (docol) pushl $docol; next;
00000305: 8b75 008d 6d04 adff   (exit) rpop %esi next;
0000030d: 20
0000030e: ad50 adff 20          (lit) lodsl; pushl %eax; next;
00000313: ad56 01c6 adff 2000   (litstring)lodsl; pushl %esi; addl %eax,%esi; next;
0000031b: 00
0000031c: 5801 0424 adff 20     (add) popl %eax; addl %eax,(%esp); next;
00000323: 5829 0424 adff 20     (sub) popl %eax; subl %eax,(%esp); next;
0000032a: 585b 0faf c350 adff   (mul) popl %eax; popl %ebx; imul %ebx,%eax
00000332: 20                    pushl %eax; next;
00000333: 31d2 5b58 f7fb 5250   (divmod) xorl %edx,%edx; popl %ebx; popl %eax
0000033b: adff 20               idiv %ebx; pushl %edx; pushl %eax; next;
0000033e: 5821 0424 adff 20     (and) popl %eax; andl %eax,(%esp); next;
00000345: 5809 0424 adff 20     (or) popl %eax; orl %eax,(%esp); next;
0000034c: 5831 0424 adff 20     (xor) popl %eax; andl %eax,(%esp); next;
00000353: 585b 39c3 0f9c c00f   (less) popl %eax; popl %ebx; cmpl %eax,%ebx
0000035b: b6c0 50ad ff20        setl %al; movzbl %al, %eax; pushl %eax; next;
00000361: 585b 39c3 0f92 c00f   (uless) popl %eax; popl %ebx; cmpl %eax,%ebx
00000369: b6c0 50ad ff20        setb %al; movzbl %al, %eax; pushl %eax; next;
0000036f: 585b 39c3 0f94 c00f   (equal) popl %eax; popl %ebx; cmpl %eax,%ebx
00000377: b6c0 50ad ff20        setl %al; movzbl %al, %eax; pushl %eax; next;
0000037d: 5958 d3e0 50ad ff20   (shl) popl %ecx; popl %eax; shll %cl,%eax;next;
00000385: 5958 d3e8 50ad ff20   (shr) popl %ecx; popl %eax; shrl %cl,%eax;next;
0000038d: 5958 d3f8 50ad ff20   (sar) popl %ecx; popl %eax; sarl %cl,%eax; next;
00000395: 8b05 5c80 0408 8d58   (argv) movl sp0,%eax; leal 4(%eax),%ebx
0000039d: 0453 ff30 adff 20     pushl %ebx; pushl (%eax); next;
000003a4: 68b0 8304 08ad ff20   (version) pushl $version; next
000003ac: 0000 0000             padding
000003b0: 6933 3836 2d6c 696e  i386-lin
000003b8: 7578 2d68 616e 6477  ux-handw
000003c0: 7269 7474 656e 3a43  ritten:C
000003c8: 6f70 7972 6967 6874  opyright
000003d0: 2028 6329 2032 3032   (c) 202
000003d8: 3120 4b6f 6963 6869  1 Koichi
000003e0: 204e 616b 616d 7572   Nakamur
000003e8: 6120 3c6b 6f69 6368  a <koich
000003f0: 6940 6964 6569 6e2e  i@idein.
000003f8: 6a70 3e00 0000 0000  jp>
@

<<hello world!>>=
khtketkltkltkotk tkwtkotkrtkltkdtk!tk:k0-tk0k0-Q
@

<<main>>=
thisprog=${1} # the initial script
mainprog=${0}
set -- "${thisprog}" --ba-- "${mainprog}" "$@" --ea--
rm -f planck
nofake --error -Rdata "${thisprog}" |
    nofake-exec.sh --error -Rperl "$@" -- perl -w > planck
chmod a+x,a-w planck
nofake --error -R'hello world!' "${thisprog}" | ./planck
@

loosely mimics 'xxd -r'

<<perl>>=
binmode STDOUT;
my ($mainprog, $thisprog) = splice(@ARGV, 0, 2);
while (<STDIN>) {
    chomp;
    if ( m{^
        ( [[:xdigit:]]{8} ) :
        \s+ ( [[:xdigit:]]{4} ) \s+ ( [[:xdigit:]]{4} )
        \s+ ( [[:xdigit:]]{4} ) \s+ ( [[:xdigit:]]{4} | [[:xdigit:]]{2} )
        ( \s+ .* | )
        $}xi
    ) {
        print(pack(q{H*}, ${2} . ${3} . ${4} . ${5}));
    } elsif ( m{^
        ( [[:xdigit:]]{8} ) :
        \s+ ( [[:xdigit:]]{4} ) \s+ ( [[:xdigit:]]{4} )
        \s+ ( [[:xdigit:]]{4} | [[:xdigit:]]{2} )
        ( \s+ .* | )
        $}xi
    ) {
        print(pack(q{H*}, ${2} . ${3} . ${4}));
    } elsif ( m{^
        ( [[:xdigit:]]{8} ) :
        \s+ ( [[:xdigit:]]{4} ) \s+ ( [[:xdigit:]]{4} | [[:xdigit:]]{2} )
        ( \s+ .* | )
        $}xi
    ) {
        print(pack(q{H*}, ${2} . ${3}));
    } elsif ( m{^
        ( [[:xdigit:]]{8} ) :
        \s+ ( [[:xdigit:]]{4} | [[:xdigit:]]{2} )
        ( \s+ .* | )
        $}xi
    ) {
        print(pack(q{H*}, ${2}));
    }
}
@
