# Retired
The upstream notion-deb-builder is now supported by Notion-Enhancer

# Notion for Ubuntu/Debian

Build Notion packages for Ubuntu/Debian, using resources extracted from Notion's Windows installer.

## Prebuilt packages (or, Take me to the downloads!)

See the [latest release](https://github.com/davidbailey00/notion-deb-builder/releases/latest) [all releases](https://github.com/davidbailey00/notion-deb-builder/releases).

## Requirements

1. Install Node.js, e.g. using NVM:

   ```sh
   nvm install node
   ```

2. Install `asar`, `electron-packager` and `electron-installer-debian`:

   ```sh
   npm install
   ```

3. Install packages required for `7z`, `convert`, `fakeroot`, make, `g++` and `dpkg`.

   Using Ubuntu or Debian:

   ```sh
   sudo apt install p7zip-full imagemagick fakeroot make g++
   ```

   Or, using macOS:

   ```sh
   brew install p7zip imagemagick fakeroot dpkg
   ```

4. Download the latest Notion Windows installer, naming it `notion.exe`, e.g. using wget:

   ```sh
   wget 'https://desktop-release.notion-static.com/Notion%20Setup%202.0.10.exe' -O notion.exe
   ```

## Build

Run the build script:

```sh
./build.sh
```

Once complete, you should have a DEB package in the `out` directory.

### Build using Earthly

As an alternative to installing the tooling on your system, you can build the `deb` using [Earthly](https://docs.earthly.dev/installation) and [Docker](https://docs.docker.com/get-docker/).

Once these tools are installed, run `earth +build`. The `deb` will be in the `out` directory. One advantage is that this eliminates any differences in other environments, and may provide an easier installation process.

## FAQ

### Google/Apple Login doesn't work; what can I do?

Google/Apple login is not supported. You can [login using your email address instead](https://github.com/davidbailey00/notion-deb-builder/issues/13#issuecomment-719966960), making sure to use the same email as your Google Account or Apple ID.
