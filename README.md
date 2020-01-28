# Notion DEB Builder

Build Notion packages for Ubuntu/Debian.

## Requirements

Install Node.js v12, e.g. using NVM:

```sh
nvm install 12
```

Install `asar`, `electron-packager` and `electron-installer-debian`:

```sh
npm -g install asar electron-packager electron-installer-debian
```

Install `7z`, `convert` and `fakeroot` (assuming you already have `dpkg`):

```sh
sudo apt install p7zip-full imagemagick fakeroot
```

# Build

Run the build script:

```sh
./build.sh
```
