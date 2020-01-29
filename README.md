# Notion DEB Builder

Build Notion packages for Ubuntu/Debian, using resources extracted from Notion's Windows or macOS packages.

## Prebuilt packages

See [Releases](https://github.com/davidbailey00/notion-deb-builder/releases)

## Requirements

1. Install Node.js v12, e.g. using NVM:

   ```sh
   nvm install 12
   ```

2. Install `asar`, `electron-packager` and `electron-installer-debian`:

   ```sh
   npm -g install asar electron-packager electron-installer-debian
   ```

3. Install packages required for `7z`, `convert`, `fakeroot` and `dpkg`.

   Using Ubuntu or Debian:

   ```sh
   sudo apt install p7zip-full imagemagick fakeroot
   ```

   Or, using macOS:

   ```sh
   brew install p7zip imagemagick fakeroot dpkg
   ```

4. Download the latest Notion Windows installer as `notion.exe`, e.g. using wget:

   ```sh
   wget 'https://desktop-release.notion-static.com/Notion%20Setup%202.0.6.exe' -o notion.exe
   ```

# Build

Run the build script:

```sh
./build.sh
```

Once complete, you should have a DEB package in the `out` directory.
