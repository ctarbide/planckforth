/* planck - 
 * Copyright (C) 2021 nineties
 */
#ifndef INCLUDE_DEFS
#define INCLUDE_DEFS

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define COPYRIGHT "Copyright (c) 2021 Koichi Nakamura <koichi@idein.jp>"
#define STRINGIFY(s) #s
#define RUNTIME_NAME(c) STRINGIFY(c)

#define VERSION RUNTIME_NAME(COMPILER) ":" COPYRIGHT

typedef uintptr_t cell;
typedef void (**cfa)();

#define CELL            sizeof(cell)
#define STACK_SIZE      1024
#define RSTACK_SIZE     1024
#define MEMORY_SIZE     0x20000

typedef struct builtin {
    struct builtin *prev;
    char len;
    char name;
    char padding[CELL-2];
    void (*fun)();
} builtin;

static cell stack[STACK_SIZE];
static cell rstack[RSTACK_SIZE];
static cell *dsp = stack + STACK_SIZE;
static cell *rsp = rstack + RSTACK_SIZE;

static cell memory[MEMORY_SIZE];
static builtin *latest = 0;
static cell *here = memory;
static cell *np = NULL;
static cfa  ip = NULL;

#define next()     (*(ip = (cfa)(*np++)))()

static void push(cell v)  { *(--dsp) = v; }
static cell pop(void)     { return *dsp++; }
static void rpush(cell v) { *(--rsp) = v; }
static cell rpop(void)    { return *rsp++; }

static void docol(void) {
    rpush((cell) np);
    np = (cell*)ip + 1;
    next();
}

static cfa find(char c) {
    for (builtin *it = latest; it; it = it->prev)
        if (it->len == 1 && it->name == c)
            return &it->fun;
    return 0;
}

static int saved_argc = 0;
static char **saved_argv = 0;

#define defcode(name, label) \
static void label()
#include "planck.c"
#undef defcode

static void align() {
    here = (cell*)((((cell)here) + CELL - 1) & ~(CELL - 1));
}
static void comma(cell v) { *here++ = v; }
static void comma_byte(char c) {
    *(char*)here = c;
    here = (cell*)(((char*)here) + 1);
}
static void comma_string(char *s) {
    while (*s) comma_byte(*s++);
    comma_byte(0);
}

int main(int argc, char *argv[]) {
    saved_argc = argc;
    saved_argv = argv;

#define defcode(name, label)        \
    comma((cell) latest);           \
    latest = (void*)here - CELL;    \
    comma_byte(strlen(name));       \
    comma_string(name);             \
    align();                        \
    comma((cell) label);            \
    if (0) // skip function body

#include "planck.c"

    cfa start = (cfa) here;
    *here++ = (cell) find('k');
    *here++ = (cell) find('f');
    *here++ = (cell) find('x');
    *here++ = (cell) find('j');
    *here++ = (cell) -4 * CELL;
    np = (cell*) start;
    next();
    return 0;
}
#else
defcode("Q", quit) { exit(pop()); }
defcode("C", cell_) { push(CELL); next(); }
defcode("h", here_) { push((cell)&here); next(); }
defcode("l", latest_) { push((cell)&latest); next(); }
defcode("i", docol_) { push((cell)docol); next(); }
defcode("e", exit_) { np = (cell*)rpop(); next(); }
defcode("@", fetch) { cell *p = (cell*)pop(); push(*p); next(); }
defcode("!", store) { cell *p = (cell*)pop(); *p = pop(); next(); }
defcode("?", cfetch) { char *p = (char*)pop(); push(*p); next(); }
defcode("$", cstore) { char *p = (char*)pop(); *p = pop(); next(); }
defcode("d", dfetch) { push((cell)dsp); next(); }
defcode("D", dstore) { dsp = (cell*) pop(); next(); }
defcode("r", rfetch) { push((cell)rsp); next(); }
defcode("R", rstore) { rsp = (cell*) pop(); next(); }
defcode("j", jump) { np += (int)*np/CELL; next(); }
defcode("J", jump0) { np += (int)(pop()?1:*np/CELL); next(); }
defcode("L", lit) { push(*np++); next(); }
defcode("S", litstring) {
    int n = *np++;
    push((cell)np);
    np += n/CELL;
    next();
}
defcode("k", key) {
    int c = getchar();
    if (c <= 0)
        exit(0);
    push(c);
    next();
}
defcode("t", type) { putchar(pop()); next(); }
defcode("x", exec) { (*(ip = (cfa) pop()))(); }
defcode("f", find_) { push((cell) find(pop())); next(); }
defcode("v", argv_) { push((cell) saved_argv); push(saved_argc); next(); }
defcode("V", impl) { push((cell) VERSION); next(); }
defcode("/", divmod) {
    uintptr_t b = pop();
    uintptr_t a = pop();
    push(a%b);
    push(a/b);
    next();
}
#define defbinary(name, label, op, ty) \
defcode(name, label) { \
    ty b = (ty) pop(); \
    *dsp = (cell)((ty) *dsp op b); \
    next(); \
}
defbinary("+", add, +, intptr_t)
defbinary("-", sub, -, intptr_t)
defbinary("*", mul, *, intptr_t)
defbinary("&", and, &, uintptr_t)
defbinary("|", or, |, uintptr_t)
defbinary("^", xor, ^, uintptr_t)
defbinary("<", lt, <, intptr_t)
defbinary("u", ult, <, uintptr_t)
defbinary("=", eq, ==, intptr_t)
defbinary("(", shl, <<, uintptr_t)
defbinary(")", shr, >>, uintptr_t)
defbinary("%", sar, >>, intptr_t)

/* File IO */
defcode("(open)", openfile) {
    int flags = pop();
    char *name = (char*) pop();
    int fd = open(name, flags, 0644);
    push(fd);
    next();
}
defcode("(close)", closefile) {
    int fd = pop();
    push(close(fd));
    next();
}
defcode("(read)", readfile) {
    int fd = pop();
    int size = pop();
    char *buf = (char*) pop();
    push(read(fd, buf, size));
    next();
}
defcode("(write)", writefile) {
    int fd = pop();
    int size = pop();
    char *buf = (char*) pop();
    push(write(fd, buf, size));
    next();
}
defcode("(allocate)", allocate) {
    int size = pop();
    void *p = calloc(size, 1);
    push((cell) p);
    next();
}
defcode("(free)", free_) {
    free((void*) pop());
    next();
}

#endif
