# Description

 This repository demonstrates how to use the Zephyr RTOS to make embedded applications. Particularly, the NRF52840dongle is used as the build target and a custom BLE service is created that can be interacted via phone applications such as nrfConnect. The current paln for the ble service is to enable fetching some mocked up sensor data and triggering different blink patterns.

 ## Zephyr RTOS installation
 In order to use this repository, it is requried to install the zephyr rtos. To do so, follow the instraction [here](https://docs.zephyrproject.org/latest/develop/getting_started/index.html). If you are on the MacOS, you can end up with plaguing dependency issues like what I had to go through. The best installation approach in this case is
 1. first install `pyenv` as `brew install pyenv 3.12`
 2. create a virtual environment as `python3.12 -m venv zephyr-env`
 3. activate the virtual environment
 4. resume the installation steps in the guid from `pip install west`

 ## Important
 It's critical to add the zephyr base to the system  environment variables so that you can use the zephyr build system in the out of tree projects like this repository:

 > export ZEPHYR_BASE=~/zephyrproject/zephyr

 ## Programing
 Again if you plan to use the nrf52840 dongle, you would need a few more things to do. 
 1. download the nrfutil from [here](https://www.nordicsemi.com/Products/Development-tools/nRF-Util)
 2. move the downloaded file to a location, make it executable with `chmod +x nrfutil`
 3. add the path to the nrfutil to the PATH varaible
 4. install the device tool as `nrfutil install device`
 5. install the  nrf5sdk-tools as `nrfutil install nrf5sdk-tools`
 6. check what already installed by `nrfutil search`
 
 Now the build system is ready, there are few more steps. First the building step. To build the application use the following sequence of commands
 1. `west build -p -b nrf52840dongle`
 2. `cd` to the build directory and then zephyr where the `zephyr.hex` resides by default
 3.  `nrfutil pkg generate --hw-version 52 --sd-req=0x00  --application zephyr.hex --application-version 1 app.zip`
 
 Now the image package is ready to be flashed to the dongle. Press the reset button to put the dongle into the dfu mode as described [here](https://academy.nordicsemi.com/flash-instructions-for-nrf52840-dongle/). Finally, flash the the image using the nrfutil by the following command
>  nrfutil device program --firmware app.zip --traits nordicDfu

## Custom Script
To facilitate this process, I have created a script which does all the steps sequentially from a clean build by west to flashing the program package onto the dongle. You get inspiration or directly use it if you are using the same type of dongle.
