# Notion DEB Builder

Build Notion packages for Ubuntu/Debian, using resources extracted from Notion's Windows or macOS packages.

## Prebuilt packages

See [Releases](https://github.com/davidbailey00/notion-deb-builder/releases)

## Requirements

1. Install Node.js, e.g. using NVM:

   ```sh
   nvm install node
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

4. Download the latest Notion Windows or macOS installer, as `notion.exe` or `notion.dmg` respectively, e.g. using wget:

   ```sh
   wget 'https://desktop-release.notion-static.com/Notion%20Setup%202.0.6.exe' -O notion.exe
   ```

# Build

Run the build script:

```sh
./build.sh <platform>
```

replacing `<platform>` with either `win` or `mac`, depending on which sources you would like to build from.

Once complete, you should have a DEB package in the `out` directory.
