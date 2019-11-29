### TL;DR

This repository provides a working CI solution for WordPress out of the box.

### Introduction

This repository provides a working CI solution for WordPress stack using [Docker](https://www.docker.com/) ([docker-compose](https://docs.docker.com/compose/)) and [WP-Browser](https://wpbrowser.wptestkit.dev/) (framework based on [CodeCeption](https://codeception.com/)). The provided CI solution is suitable for both, WordPress themes and plugins, as this repository contains tests for both. The repository comes *fully working* and preconfigured with 4 types of tests:

- acceptance
- integration
- wpunit
- unit

This is **not** a tutorial or how-to guide but rather a scaffolding-like solution to quickly setup and deploy CI for WordPress. This repository assumes you have a good grasp of the following:

- [docker](https://docs.docker.com/engine/reference/run/)
- [docker-compose](https://docs.docker.com/compose/)
- [wp-cli](https://wp-cli.org/)
- Bash scripts
- [CodeCeption](https://codeception.com/)

For each supported CI provider (a list of supported providers is available below), the following is implemented:

- execution of CI tests
- caching of Composer (`vendor` folder)
- save/export of artifacts if CI tests fail (`wp-browser/tests/_output` folder)

The Docker image is based off [visiblevc/wordpress-starter](https://github.com/visiblevc/wordpress-starter). The only difference between this image and the one this repository uses is the installation of [PDO driver](https://www.php.net/manual/en/ref.pdo-mysql.php) for MySQL which is necessary in order to configure [CodeCeption](https://github.com/visiblevc/wordpress-starter). Source code of the Docker images are available in the folder `docker-image-src`. This is provided in case you have security concerns in using my own image, so you can compile yours (don't forget to modify `docker-compose.yml` to use your own image).

Please note that this is a very generic repository and for your specific needs you will probably need to adjust the configuration. Additionally, this repository was developed on Mac using [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_mac/) (**not** [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/)). For a comparison of differences, refer to this [link](https://docs.docker.com/docker-for-mac/docker-toolbox/). As such, you may or may not need to adjust the execution of scripts and `docker-compose.yml` depending on your specific Docker host implementation.

>Extra bonus: navigate to `docker-machine ip:22222` to open `phpMyAdmin` which allows large SQL import (see `configs/large-sql-import.ini`)

### Supported CI Providers

- SemaphoreCI
- GitLab (shared runner)

### How to Use Run Tests

To use the vanilla setup for WordPress i.e. without specific CI configuration, follow these steps:

1. Start docker containers, e.g. `./scripts/host/up.sh`
2. Install Composer dependencies, e.g. `./scripts/code/composer.sh`\*
3. Run CI tests, e.g. `./scripts/code/test.sh`\*\*

>\* This script uses dual configuration, where initially it tries to install dependencies using a locally installed Docker and if none is found, it defaults to [dockerized composer](https://hub.docker.com/_/composer)

>\*\* The script `scripts/code/test.sh` supports position arguments `$1` and `$2` so you can execute a specific instead of running the entire suite, e.g. `./scripts/host/test.sh acceptance PluginCest:activatePlugin`

>Scripts inside the folder `docker-scripts` are automatically executed by Docker container, see [L120 of `run.sh`](https://github.com/visiblevc/wordpress-starter/blob/0b45d216f8e3fd503c24c48ac476b7ee023aba74/run.sh#L120)

### How To Build Image

In order to build your own image using the source files provided in the folder `docker-image-src`, execute the following command:

```
docker build -t <name:tag> .
```

where `-t <name:tag>` is optional. For more information, refer to [`docker build docs`](https://docs.docker.com/engine/reference/commandline/build/). Each image was moved into its own sub-folder to provide a better organization.

| Sub-folder | Purpose |
| docker-compose | used by `docker-compose.yml` |
| gitlab-shared-runner | used by `.gitlab-ci.yml` |

### How To Use This Repository

The easiest way would be to fork this repository and start editing the files. If you are looking for a quick CI test on your local machine, refer to the above section.

### Useful Scripts

The folder `scripts/code` contains a collection of Bash scripts which could be potentially useful to your needs. I have tried to make them as generic as possible but your requirements may require additional changes.

### Configs

The folder with the name `configs` contains various useful configs. Currently, it has only php.ini for both, development and production. To switch between them, modify `docker-compose.yml` file.

### File Manifest

This section provides a quick glimpse of the folders/files and their purpose:

| File/Folder | Purpose |
| --- | --- |
| .semaphore | SemaphoreCI config |
| configs | folder with various config files |
| docker-image-src | source code of Docker image |
| my-plugin | WordPress plugin* |
| my-theme | WordPress theme* |
| scripts | collection of Bash scripts |
| wp-browser | WP-Browser and CI tests |
| .gitignore | Git ignore file |
| docker-compose.yml | Docker container definitions |
| README.md | this file |

>\* Generated scaffold using wp-cli
