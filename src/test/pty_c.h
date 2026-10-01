// #145 — translate-c wrapper for the #114 encrypted-PEM non-interaction
// check. POSIX.1-2001 exposes the PTY allocation calls (`posix_openpt`,
// `grantpt`, `unlockpt`, `ptsname`) on glibc and Darwin alike; the
// feature-test macro must be set before any libc header to select them.
#define _XOPEN_SOURCE 700

#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
