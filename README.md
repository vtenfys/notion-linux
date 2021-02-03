# Notion for Linux

Build Notion packages for Linux, using resources extracted from Notion's Windows installer.

## Install pre-built packages

Run the following commands in a terminal to install Notion:

### Ubuntu, Debian, Linux Mint

```sh
curl https://notion.davidbailey.codes/notion-linux.list | sudo tee /etc/apt/sources.list.d/notion-linux.list
sudo apt update
sudo apt install notion-desktop
```

### Fedora, CentOS

```sh
curl https://notion.davidbailey.codes/notion-linux.repo | sudo tee /etc/yum.repos.d/notion-linux.repo
sudo dnf install notion-desktop
```

### openSUSE

```sh
curl https://notion.davidbailey.codes/notion-linux.repo | sudo tee /etc/zypp/repos.d/notion-linux.repo
sudo zypper install notion-desktop
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

3. Install other packages required for building the app, e.g. using `apt`:

   ```sh
   sudo apt install p7zip-full imagemagick make g++ fakeroot rpm
   ```

   Only Debian-based distributions are officially supported for builds.

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
