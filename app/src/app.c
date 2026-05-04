// including the required header files

/** application header files */
#include "connection_mngr.h"
#include "service_mngr.h"

// =================================================================================
// main application logic

int main(void){

    int ret = 0;
    ret = bluetooth_init();

    ble_service_init();

    return 0;
}