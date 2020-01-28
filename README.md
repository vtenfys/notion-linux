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

Download the latest Notion Windows installer as `notion.exe`, e.g. using wget:

```sh
wget 'https://desktop-release.notion-static.com/Notion%20Setup%202.0.6.exe' -o notion.exe
```

# Build

Run the build script:

```sh
./build.sh
```

Once complete, you should have a DEB package in the `out` directory.
