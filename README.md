# Notion for Linux

Native Notion packages for Linux, built from Notion's Windows installer.

## Install

Run the following commands in a terminal to install Notion. Packages are available for Intel/AMD and ARM64.

### Ubuntu, Debian, Linux Mint

```sh
wget https://notion.davidbailey.codes/notion-linux.list
sudo mv notion-linux.list /etc/apt/sources.list.d/notion-linux.list
sudo apt update && sudo apt install notion-desktop
```

You may see the following line when running `sudo apt update` on an Intel/AMD system:

```
N: Skipping acquire of configured file 'main/binary-i386/Packages' as repository 'https://notion.davidbailey.codes/debs stable InRelease' doesn't support architecture 'i386'
```

This is an informational message only and is safe to ignore. See [#26](https://github.com/davidbailey00/notion-linux/issues/26) and [#29](https://github.com/davidbailey00/notion-linux/issues/29).

### Fedora, CentOS

```sh
wget https://notion.davidbailey.codes/notion-linux.repo
sudo mv notion-linux.repo /etc/yum.repos.d/notion-linux.repo
sudo dnf install notion-desktop
```

### openSUSE

```sh
wget https://notion.davidbailey.codes/notion-linux.repo
sudo mv notion-linux.repo /etc/zypp/repos.d/notion-linux.repo
sudo zypper install notion-desktop
```

## Build

First, install the requirements:

1. Install Node.js, e.g. using [NVM](https://github.com/nvm-sh/nvm):

   ```sh
   nvm install node
   ```

2. Install NPM version 7:

   ```sh
   npm install -g npm@7
   ```

3. Install other packages required for building the app, e.g. using `apt`:

   ```sh
   sudo apt install p7zip-full imagemagick make g++ fakeroot rpm
   ```

   Only Debian-based distributions are officially supported for builds.

Next, to produce an AMD64 build, run the following:

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
