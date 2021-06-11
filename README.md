**11 June 20221: End of support**

I no longer use either Notion or Linux. Furthermore, recent updates to Notion have been difficult for me to support all the existing variants (e.g. arm64, enhanced), due to new native modules and incompatibilities with Notion Enhancer. If you would like to maintain this project, please contact me by opening an issue, or through my website.

For Arch Linux users, I recommend using [notion-app](https://aur.archlinux.org/packages/notion-app/). For other Linux users, I recommend using the Notion web app. For [Notion Enhancer](https://github.com/notion-enhancer/notion-enhancer) users, its maintainer reports that a Chrome extension may be coming soon. You can also continue using the current latest version indefinitely, as the current hosting solution is free on my end.

---

**13 February 2021**: [Action is required for existing Debian, Ubuntu and Linux Mint users](https://github.com/davidbailey00/notion-linux/releases/tag/gemfury)

# Notion for Linux

Native Notion packages for Linux, built from Notion's Windows installer.

## Install

Run the following commands in a terminal to install Notion. Packages are available for Intel/AMD and ARM64.

To install Notion with [Notion Enhancer](https://github.com/notion-enhancer/notion-enhancer) mods applied, replace `notion-desktop` with `notion-enhanced` in the commands below.

### Ubuntu, Debian, Linux Mint

```sh
wget https://notion.davidbailey.codes/notion-linux.list
sudo mv notion-linux.list /etc/apt/sources.list.d/notion-linux.list
sudo apt update && sudo apt install notion-desktop
```

### Fedora, CentOS

```sh
wget https://notion.davidbailey.codes/notion-linux.repo
sudo mv notion-linux.repo /etc/yum.repos.d/notion-linux.repo
sudo dnf install notion-desktop
```

### openSUSE

```sh
sudo zypper ar -r https://notion.davidbailey.codes/notion-linux.repo
sudo zypper --gpg-auto-import-keys install notion-desktop
```

## Build

### Install requirements

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

### Build `notion-desktop`

`notion-desktop` is the vanilla Notion package.

To produce an AMD64 build, run the following:

```sh
scripts/build.sh        # always run
scripts/package-deb.sh  # run to produce a DEB
scripts/package-rpm.sh  # run to produce an RPM
```

To produce an ARM64 build, run the following:

```sh
scripts/build.sh -b arm64        # always run
scripts/package-deb.sh -b arm64  # run to produce a DEB
scripts/package-rpm.sh -b arm64  # run to produce an RPM
```

Once complete, you should have DEB and/or RPM packages in the `out` directory.

### Build `notion-enhanced`

`notion-enhanced` is the Notion package with [Notion Enhancer](https://github.com/notion-enhancer/notion-enhancer) mods applied.

To produce an AMD64 build, run the following:

```sh
scripts/build.sh                           # always run
scripts/enhance.sh                         # always run
scripts/package-deb.sh -n notion-enhanced  # run to produce a DEB
scripts/package-rpm.sh -n notion-enhanced  # run to produce an RPM
```

To produce an ARM64 build, run the following:

```sh
scripts/build.sh -b arm64                           # always run
scripts/enhance.sh -b arm64                         # always run
scripts/package-deb.sh -n notion-enhanced -b arm64  # run to produce a DEB
scripts/package-rpm.sh -n notion-enhanced -b arm64  # run to produce an RPM
```

Once complete, you should have DEB and/or RPM packages in the `out` directory.
