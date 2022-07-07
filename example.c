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
