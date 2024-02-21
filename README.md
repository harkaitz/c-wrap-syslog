# C-WRAPPER-SYSLOG

This library wraps the following functions with a backtrace.

    syslog vsyslog verr err verrx errx

For example the following program:

    #include <syslog.h>
    #include <err.h>
    
    int main (int _argc, char *_argv[]) {
        openlog("example", LOG_PERROR, LOG_USER);
        syslog(LOG_ERR, "Here backtrace.\n");
        warn("Here a warning");
        err(0, "Here a fatal error");
        warn("!!You should never read this!!");
        return 0;
    }
    
Compiled like this:

    gcc ...                 # Not wrapped
    gcc ... `l-wrap-syslog` # Wrapper.

Generates the following output on execution:

    ==== NOT WRAPPED =========
    example: Here backtrace.
    example-nw: Here a warning: Success
    example-nw: Here a fatal error: Success
    ==== WRAPPED =============
    example: BT: ./example-w(__wrap_syslog+0x83) [0x561fd214847e]
    example: BT: ./example-w(main+0x3b) [0x561fd2148210]
    example: Here backtrace.
    example-w: Here a warning: Success
    example: BT: ./example-w(__wrap_err+0x7a) [0x561fd2148595]
    example-w: Here a fatal error: Success

## Wanted features (Any PR will be appreciated)

- Add a callback support.
- Add prefixed message support.
- Add stdio output support.
- Add TCP output support.

## Collaborating

For making bug reports, feature requests and donations visit
one of the following links:

1. [gemini://harkadev.com/oss/](gemini://harkadev.com/oss/)
2. [https://harkadev.com/oss/](https://harkadev.com/oss/)
