# Notion for Linux

Build Notion packages for Linux, using resources extracted from Notion's Windows installer.

## Install pre-built packages

### Ubuntu, Debian, Linux Mint (DEB)

- [Download the latest DEB package for 64-bit Intel/AMD (most systems)](https://github.com/davidbailey00/notion-linux-builder/releases/download/v2.0.11-3/notion-desktop_2.0.11-3_amd64.deb)
- [Download the latest DEB package for 64-bit ARM (e.g. Raspberry Pi)](https://github.com/davidbailey00/notion-linux-builder/releases/download/v2.0.11-3/notion-desktop_2.0.11-3_arm64.deb)

### Fedora, CentOS

Run the following in a terminal:

```sh
wget https://raw.githubusercontent.com/davidbailey00/notion-linux-builder/main/repos/notion-linux.repo
sudo mv notion-linux.repo /etc/yum.repos.d/notion-linux.repo
sudo dnf install notion-desktop
```

## Requirements

1. Install Node.js, e.g. using [NVM](https://github.com/nvm-sh/nvm):

   ```sh
   nvm install node
   ```

2. Install NPM version 7:

   ```sh
   npm install -g npm@7
   ```

3. Install other packages required for building the app.

   Using Ubuntu or Debian with `apt`:

   ```sh
   sudo apt install p7zip-full imagemagick fakeroot make g++
   ```

   Using Fedora or CentOS with `dnf`:

   ```sh
   sudo dnf install p7zip ImageMagick make gcc-c++ rpm-build
   ```

   Using openSUSE with `zypper`:

   ```sh
   sudo zypper install p7zip-full ImageMagick make gcc-c++ rpm-build
   ```

## Build

To produce an AMD64 build, run the following:

```sh
./scripts/build.sh        # always run
./scripts/package-deb.sh  # run to produce a DEB
./scripts/package-rpm.sh  # run to produce an RPM
```

To produce an ARM64 build, run the following:

```sh
./scripts/build.sh arm64                # always run
./scripts/package-deb.sh arm64 arm64    # run to produce a DEB
./scripts/package-rpm.sh arm64 aarch64  # run to produce an RPM
```

Once complete, you should have a DEB and/or RPM package in the `out` directory.
