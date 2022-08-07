#include <features.h>
#include <syslog.h>
#include <stdarg.h>
#include <stdbool.h>
#ifdef __GLIBC__
#  include <execinfo.h>
#endif
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#if __STDC_VERSION__ < 201112L
#  define _Noreturn
#else
#  include <stdnoreturn.h>
#endif


__attribute__((weak)) bool        SYSLOG_PRINT_STACKTRACE = true;
__attribute__((weak)) char const *SYSLOG_LOG_FILE         = NULL;
__attribute__((weak)) bool        SYSLOG_PRINT_STARTUP    = false;

extern    void __real_openlog (const char *, int, int);
extern    void __real_vsyslog (int, char const *, va_list);
extern    void __real_syslog  (int, char const *, ...);
_Noreturn void __real_verr    (int, const char *, va_list);
_Noreturn void __real_verrx   (int, const char *, va_list);

void __wrap_openlog (const char *_ident, int _logopt, int _facility) {
    if (SYSLOG_LOG_FILE) {
        int log_fd = open(SYSLOG_LOG_FILE, O_WRONLY|O_APPEND|O_CREAT, 0644);
        if (log_fd != -1) {
            dup2(log_fd, 2);
            close(log_fd);
        }
        __real_openlog(_ident, _logopt | LOG_PERROR, _facility);
    } else {
        __real_openlog(_ident, _logopt, _facility);
    }
    if (SYSLOG_PRINT_STARTUP) {
        syslog(LOG_INFO, "-");
        syslog(LOG_INFO, "PROGRAM LAUNCHED: %s", _ident);
        syslog(LOG_INFO, "-");
    }
}

void print_backtrace(void) {
#   ifdef __GLIBC__
    char **strings; int i;
    void  *backtrace_b[20];
    int    backtrace_bsz;
    backtrace_bsz = backtrace(backtrace_b, 20);
    strings = backtrace_symbols (backtrace_b, backtrace_bsz);
    if (strings) {
        for (i = 0; i < backtrace_bsz; i++) {
            if (!(strstr(strings[i], "(_start")       ||
                  strstr(strings[i], "(__libc_start") ||
                  strstr(strings[i], "print_backtrace"))) {
                __real_syslog(LOG_ERR, "BT: %s\n", strings[i]);
            }
        }
        free (strings);
    }
#   endif
}

void __wrap_vsyslog(int _prio, char const *_fmt, va_list _va) {
    if (_prio == LOG_ERR && SYSLOG_PRINT_STACKTRACE) {
        print_backtrace();
    }
    __real_vsyslog(_prio, _fmt, _va);
}

void __wrap_syslog(int _prio, char const *_fmt, ...) {
    if (_prio == LOG_ERR && SYSLOG_PRINT_STACKTRACE) {
        print_backtrace();
    }
    va_list va;
    va_start(va, _fmt);
    __real_vsyslog(_prio, _fmt, va);
    va_end(va);
}

_Noreturn void __wrap_verr(int _code, const char *_fmt, va_list _va) {
    if (SYSLOG_PRINT_STACKTRACE) print_backtrace();
    __real_verr(_code, _fmt, _va);
}

_Noreturn void __wrap_err(int _code, const char *_fmt, ...) {
    if (SYSLOG_PRINT_STACKTRACE) print_backtrace();
    va_list va;
    va_start(va, _fmt);
    __real_verr(_code, _fmt, va);
    va_end(va);
}

_Noreturn void __wrap_verrx(int _code, const char *_fmt, va_list _va) {
    if (SYSLOG_PRINT_STACKTRACE) print_backtrace();
    __real_verrx(_code, _fmt, _va);
}

_Noreturn void __wrap_errx(int _code, const char *_fmt, ...) {
    if (SYSLOG_PRINT_STACKTRACE) print_backtrace();
    va_list va;
    va_start(va, _fmt);
    __real_verrx(_code, _fmt, va);
    va_end(va);
}
