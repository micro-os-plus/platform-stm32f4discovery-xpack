[![license](https://img.shields.io/github/license/micro-os-plus/platform-stm32f4discovery-xpack)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/blob/xpack/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/micro-os-plus/platform-stm32f4discovery-xpack.svg)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/issues)
[![GitHub pulls](https://img.shields.io/github/issues-pr/micro-os-plus/platform-stm32f4discovery-xpack.svg)](https://github.com/micro-os-plus/platform-stm32f4discovery-xpack/pulls)

# Maintainer info

## Project repository

The project is hosted on GitHub:

- https://github.com/micro-os-plus/platform-stm32f4discovery-xpack.git

To clone it:

```
git clone https://github.com/micro-os-plus/platform-stm32f4discovery-xpack.git platform-stm32f4discovery-xpack.git
```

## Prerequisites

A recent [xpm](https://xpack.github.io/xpm/), which is a portable
[Node.js](https://nodejs.org/) command line application.

## Publish to npmjs.com

- select the `xpack-develop` branch
- commit all changes
- update `CHANGELOG.md`; commit with a message like _CHANGELOG: prepare v0.1.0_
- `npm pack` and check the content of the archive, which should list
  only the `package.json`, the `README.md`, `LICENSE` and `CHANGELOG.md`;
  possibly adjust `.npmignore`
- `npm version patch`, `npm version minor`, `npm version major`
- push the `xpack-develop` branch to GitHub
- `npm publish --tag next` (use `--access public` when publishing for
  the first time)

The version is visible at:

- https://www.npmjs.com/package/@micro-os-plus/platform-stm32f4discovery?activeTab=versions

## Test

Test the package.

## Update the repo

When the package is considered stable:

- with Sourcetree
- merge `xpack-develop` into `xpack`
- push to GitHub

## Tag the npm package as `latest`

When the release is considered stable, promote it as `latest`:

- `npm dist-tag ls @micro-os-plus/platform-stm32f4discovery`
- `npm dist-tag add @micro-os-plus/platform-stm32f4discovery@0.1.0 latest`
- `npm dist-tag ls @@micro-os-plus/platform-stm32f4discovery`

## Announce to the community

Post an announcement to the forum or on Twitter.
