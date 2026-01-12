/* Stub implementations for missing POSIX functions on Switch */

#include <sys/types.h>

/* umask is not available in newlib for Switch */
mode_t umask(mode_t mask) {
    (void)mask;
    return 0;
}
