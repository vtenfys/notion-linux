# Notion for Ubuntu/Debian

Build Notion packages for Ubuntu/Debian, using resources extracted from Notion's Windows installer.

## Download the latest pre-built package

- [Download the latest package for 64-bit Intel/AMD (most systems)](https://github.com/davidbailey00/notion-deb-builder/releases/download/v2.0.11-patch2/notion-desktop_2.0.11_amd64.deb)
- [Download the latest package for 64-bit ARM (e.g. Raspberry Pi)](https://github.com/davidbailey00/notion-deb-builder/releases/download/v2.0.11-patch2/notion-desktop_2.0.11_arm64.deb)
- [See all releases](https://github.com/davidbailey00/notion-deb-builder/releases)

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
   
   _Please ensure that `p7zip-full` is at least version 16._

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
