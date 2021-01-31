# Notion for Linux

Build Notion packages for Linux, using resources extracted from Notion's Windows installer.

## Download pre-built packages

### Ubuntu, Debian, Linux Mint (DEB)

- [Download the latest package for 64-bit Intel/AMD (most systems)](https://github.com/davidbailey00/notion-linux-builder/releases/download/v2.0.11-patch2/notion-desktop_2.0.11_amd64.deb)
- [Download the latest package for 64-bit ARM (e.g. Raspberry Pi)](https://github.com/davidbailey00/notion-linux-builder/releases/download/v2.0.11-patch2/notion-desktop_2.0.11_arm64.deb)

### Fedora, RHEL, openSUSE (RPM)

- Coming soon

## Requirements

1. Install Node.js, e.g. using [NVM](https://github.com/nvm-sh/nvm):

   ```sh
   nvm install node
   ```

   _Please ensure that NPM is at least version 7._

2. Install other packages required for building the app.

   Using Ubuntu or Debian with `apt`:

   ```sh
   sudo apt install p7zip-full imagemagick fakeroot make g++
   ```

   Using Fedora or RHEL with `dnf`:

   ```sh
   sudo dnf install p7zip ImageMagick fakeroot make gcc-c++
   ```

   Using openSUSE with `zypper`:

   ```sh
   sudo zypper install p7zip-full ImageMagick fakeroot make gcc-c++
   ```

## Build

Run the build script:

```sh
./build.sh
```

To produce an ARM64 build, run the following:

```sh
./build.sh arm64 arm64
```

Once complete, you should have a DEB package in the `out` directory.
