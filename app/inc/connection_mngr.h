#ifndef CONNECTION_MNGR_HEADER_G
#define CONNECTION_MNGR_HEADER_G
// =================================================================================
// including the required header files

/** standard C header files */
#include <stdint.h>



// =================================================================================
// APIs

/**
 * @brief initiates the bluetooth subsystem in zephyr rtos
 * 
 * @return 0 on success, and negative error code on failure.
 */
int bluetooth_init(void);


#endif