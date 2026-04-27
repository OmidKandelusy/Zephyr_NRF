# Description

This repository demonstrates how to use the [Zephyr RTOS](https://www.zephyrproject.org) to make embedded applications. Particularly, the NRF52840dongle is used as the build target and a custom BLE service is created that can be interacted via phone applications such as nrfConnect. The current paln for the ble service is to enable fetching some mocked up sensor data and triggering different blink patterns. In order to use this repository, you need to have the Zephyr already installed on your host machine. In the following, a short a refresher on the build system in Zephyr RTOS is explained first and then the notes and potential gotchas related to installation and programing are given.

## Zephyr RTOS Build System

The Zephyr RTOS build system architecture revolves around a few core players, namely,
CMake, Kconfig, West, and Ninja interacting to produce a firmware binary. Particulary, the building workflow can be summarized as follows:


**1) west build is invoked** this is the entry point. It initializes the build directory and then calls CMake, passing along the selected board, toolchain, and application path.

**2)CMake configuration phase starts**
CMake sets up the build environment by locating the Zephyr base, selecting the correct toolchain, and loading board-specific settings. This is where the overall build configuration begins to take shape.

**3)Processing CMakeLists.txt files**
CMake walks through the build scripts starting from the application, then any included modules, and finally Zephyr’s root CMakeLists.txt. During this step, it defines which source files, libraries, and build targets will be part of the final build.

**4)Kconfig execution (configuration resolution)**
as part of the CMake phase, Kconfig is executed via kconfig.py. It merges configuration inputs such as prj.conf, the board’s default configuration, and Kconfig defaults and dependencies. The result is written to .config (a human-readable configuration file) and autoconf.h (the same configuration expressed as C macros for the compiler).

**5)DeviceTree processing (hardware description)**
during the CMake phase, DeviceTree files are processed as well. This includes the board’s .dts, SoC .dtsi files, and any application overlays. These are merged into a final zephyr.dts and compiled into devicetree_generated.h, which provides hardware definitions to the code.

**6)Configuration convergence**
at this point, the system has both the software configuration (.config) and the hardware description (DeviceTree). A feature or driver is only included if it is enabled in Kconfig and the corresponding hardware is present and enabled in the DeviceTree.

Build system generation
Once configuration is complete, CMake generates the Ninja build files (build.ninja), which contain all the rules needed to compile the project.
Build phase (ninja)
Finally, Ninja compiles the source code using the generated configuration headers (autoconf.h) and hardware definitions (devicetree_generated.h). This produces the final firmware outputs such as ELF and binary images.



## Zephyr RTOS installation
 In order to use this repository, it is requried to install the zephyr rtos. To do so, follow the instraction [here](https://docs.zephyrproject.org/latest/develop/getting_started/index.html). If you are on the MacOS, you can end up with plaguing dependency issues like what I had to go through. The best installation approach in this case is
 1. first install `pyenv` as `brew install pyenv 3.12`
 2. create a virtual environment as `python3.12 -m venv zephyr-env`
 3. activate the virtual environment
 4. resume the installation steps in the guid from `pip install west`

***Note***: It's critical to add the zephyr base to the system  environment variables so that you can use the zephyr build system in the out of tree projects like this repository: 
>export ZEPHYR_BASE=~/zephyrproject/zephyr

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

