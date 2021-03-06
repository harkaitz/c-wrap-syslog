#include <syslog.h>
#include <stdarg.h>
#include <stdbool.h>
#include <execinfo.h>
#include <stdlib.h>
#include <string.h>

__attribute__((weak)) bool SYSLOG_PRINT_STACKTRACE = true;


extern    void __real_vsyslog (int, char const *, va_list);
extern    void __real_syslog  (int, char const *, ...);
_Noreturn void __real_verr    (int, const char *, va_list);
_Noreturn void __real_verrx   (int, const char *, va_list);

void print_backtrace(void) {
    char **strings; int i;
    void  *backtrace_b[20];
    size_t backtrace_bsz;
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
}

void __wrap_vsyslog(int _prio, char const *_fmt, va_list _va) {
    if (_prio == LOG_ERR && SYSLOG_PRINT_STACKTRACE) {
        print_backtrace();
    }
    return __real_vsyslog(_prio, _fmt, _va);
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
