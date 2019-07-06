# PHN OpenWRT Packages

This repository contains the client-side application for the network security solution.

## Repository Layout
1. **client** - contains the source for the application
2. **packages** - contains the packaging instructions for integrating with OpenWRT

## Getting Started

### Setting-up the Build Environment
OpenWRT development prefers a Debian/Ubuntu-based development environment.

1. Follow the instructions in https://openwrt.org/docs/guide-developer/quickstart-build-images until you execute **'make menuconfig'**.
    * During 'make menuconfig', configure it to match your target device.

2. Clone this repository beside your cloned openwrt directory. That is, after cloning your working directory should look like this:
    ```
    # ls
    openwrt  ph_toptal
    ```

3. Edit the default configuration to match your server IP and URL. The URL must accept POST requests with text/plain body.
    ```
    In file ph_toptal/client/config.sh:
    POST_IP=172.16.2.1
    POST_URL="http://$POST_IP:9876/upload"
    ```

4. Add the package to the OpenWRT feeds.
    ```
    # cd openwrt
    # echo "src-link phn_packages $(pwd)/../ph_toptal/packages" > feeds.conf
    # ./scripts/feeds update -a
    # ./scripts/feeds install -a
    ```

### Configuring the Environment and Building the Package
5. Configure OpenWRT to build the package.
    1. Start menuconfig again.
       ```
       # make menuconfig
       ```
    2. Enable ip-full in Network -> Routing and Redirection -> ip-full
    3. Enable conntrack in Network -> Firewall -> conntrack
    4. Enable curl in Network -> File Transfer -> curl
    5. Enable coreutils in Utilities -> coreutils
    6. Enable nohup in Utilities -> coreutils -> coreutils-nohup
    7. Enable sleep in Utilities -> coreutils -> coreutils-sleep
    8. Enable phn-datamonitor in Network -> PH Networks -> phn-datamonitor
    9. Exit and save the configuration.

6. Build the toolchain.
    ```
    # make toolchain/install -j4
    # export PATH="$(pwd)/staging_dir/host/bin:$PATH"
    ```

7. Build the package.
    ```
    # make package/phn-dataclient/compile
    ```

### Installing the Package
8. Copy the package to your router.
    ```
    # scp bin/packages/<arch>/phn-packages/phn-datamonitor-<version>.ipk root@<router ip>:~/.
    ```

9. Install using opkg.
    ```
    # ssh root@<router ip>
    # opkg install phn-datamonitor-<version>.ipk
    ```
    
    If the installation fails because of missing dependencies, you can download and install the dependencies directly.
 
### Using the Package.
10. The monitoring app automatically starts after installation. You can control it using:
    ```
    # service phn-datamonitor [start|stop|restart]
    ```

11. You can enable some logging to help with troubleshooting by editing the package configuration and specifying a valid debug log.
    Restart the service afterwards.
    ```
    In file /usr/local/phn/config.sh:
    DEBUG_LOG="/dev/null"
    ```
