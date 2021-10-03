# !!! Disclaimer !!!

This is no longer maintained. It _used_ to work in the past but currently it requires upgrading of tooling to resolve `set-value` security warning not to mention missing [hautelook/phpass](https://github.com/hautelook/phpass) dependency. I do not use this and it does not appear anyone else is using this. If you want to become an active contributor/maintainer, you can contact me on [LinkedIn](http://www.linkedin.com/in/alexkuc/).

### Table Of Contents

- [TL;DR](#tldr)
- [Quick Start (CI)](#quick-start-ci)
- [Quick Start (Local Development)](#quick-start-local-development)
- [Why?](#why)
- [Useful Examples (Bash Scripts)](#useful-examples-bash-scripts)
- [What's Inside (Feature)](#whats-inside-features)
- [How To Build Image](#how-to-build-image)

### TL;DR

This particular repository includes a fully working out-of-the-box implementation of CI for WordPress using WP-Browser (framework based on [CodeCeption](https://codeception.com/)) and SemaphoreCI config. WP-Browser which is based on CodeCeption comes with 4 fully configured types of tests: acceptance, functional, wpunit and unit. To get started, just clone this repository, set up your own SemaphoreCI account and everything should work out of the box. This work is not entirely exclusive as I have used [visiblevc/wordpress-starter](https://github.com/visiblevc/wordpress-starter) as a foundation for Docker's configuration. Special thanks to [contributors](https://github.com/visiblevc/wordpress-starter/graphs/contributors) of that repository! The theme code was actually scaffolded using [wp scaffold _s](https://developer.wordpress.org/cli/commands/scaffold/_s/). Special thanks to wp-cli [contributors](https://github.com/wp-cli/wp-cli/graphs/contributors)!

This is **not** a tutorial or how-to guide but rather a scaffolding-like (boilerplate) solution to quickly setup and deploy CI for WordPress. This repository assumes you have a good grasp of the following:

- [docker](https://docs.docker.com/engine/reference/run/)
- [docker-compose](https://docs.docker.com/compose/)
- [wp-cli](https://wp-cli.org/)
- Bash scripts
- [CodeCeption](https://codeception.com/)

([back to top](#table-of-contents))

### Quick Start (CI)

1. Clone this repository
2. Setup SemaphoreCI account [here](https://id.semaphoreci.com/init_auth)
3. Setup SemaphoreCI project ([how-to?](https://docs.semaphoreci.com/guided-tour/creating-your-first-project/))

At this point everything should be ready and working in terms of CI setup.

([back to top](#table-of-contents))

### Quick Start (Local Development)

1. Clone this repository
2. Open terminal where repository resides and launch these Bash scripts in the given order:
3. `./scripts/docker-machine-start.sh`
4. `./scripts/setup.sh`
5. `./scripts/up.sh`
6. Open browser and navigate to `http://localhost:8080`

At this point, you should see a WordPress page. Depending on how your `docker-machine` is set up, you may require additional configuration such as [forwarding ports](https://www.jhipster.tech/tips/020_tip_using_docker_containers_as_localhost_on_mac_and_windows.html) if you use VirtualBox. I have tested this setup on OSX 10.13.6 so your mileage may vary.

> Please **double check** Bash scripts before executing them!
> There is a potential for permanent change to the system depending on your specific configuration
> My knowledge of Linux is limited and I cannot anticipate all scenarios hence this warning

([back to top](#table-of-contents))

### Why?

As a part of my career change, I have decided to move into DevOps (CI) so I decided to experiment with different technologies. I have some experience with WordPress hence I have decided to use it. Depending on my schedule, I might add CircleCI and GitLab configs in the future (other CI providers are considered too!).

([back to top](#table-of-contents))

### Useful Examples (Bash Scripts)

- Start `docker-machine`: `./scripts/docker-machine-start.sh`
- Bring `docker-compose.yml` up: `./scripts/up.sh`
- Bring `docker-compose.yml` down: `./scripts/down.sh`
- - Additionally, a clean up is performed to allow a prestine state on subsequent `docker-compose.yml` launch
- Run all tests: `./scripts/test.sh`
- - Run a specific type of tests: `./scripts/test.sh acceptance`
- - Run a specific suite of tests: `./scripts/test.sh acceptance ThemeCest`
- - Run a specific test: `./scripts/test.sh acceptance ThemeCest:activateTheme`
- - Notes: 
- - - running `test.sh` will invoke `lint.sh` as a part of "catch errors/warnings early"
- - - if previous tests failed, `test.sh` will re-run failed tests regardless of provided parameters
- - - see [here](https://codeception.com/extensions#RunFailed) for more details
- - - all tests are run with `--debug` flag
- Install `Composer` and `Yarn` dependencies: `./scripts/setup.sh`
- - Install just `Composer` dependencies: `./scripts/setup.sh composer`
- - Install just `Yarn` dependencies: `./scripts/setup.sh yarn`
- - Switch to distribution mode for `Composer`: `export CI_COMPOSER_NO_DEV='1'` then run install script `setup.sh`
- - Switch to distribution mode for `Yarn`: `export CI_YARN_NO_DEV='1'` then run install script `setup.sh`
- Lint your files: `./scripts/lint/lint.sh` (this will call *all* linters)
- - ShellCheck: `./scripts/lint/shellcheck.sh`
- - JSHint: `./scripts/lint/jshint.sh`
- - PHPCS: `./scripts/lint/phpcs.sh`
- - PHPLint: `./scripts/lint/phplint.sh`
- Build minified assets (css and js): `./scripts/assets/create-min.sh` (requires `Yarn` with dev deps)
- Delete minified assets (css and js): `./scripts/assets/delete-min.sh` (requires `Yarn` with dev deps)
- Any Bash script placed into `scripts/containers/` will be automatically executed on container's start
- - See [here](https://github.com/visiblevc/wordpress-starter/blob/0b45d216f8e3fd503c24c48ac476b7ee023aba74/run.sh#L120) for more details
- Download Google Drive files automatically: see script `scripts/other/gdrive-dl-example.sh`
- Dual install boilerplate code: `scripts/other/local_or_docker_skeleton.sh`
- Create development distribution: `./scripts/deploy-dev.sh` (requires dev deps)
- Create regular distribution: `./scripts/deploy-dist.sh` (requires no-dev deps)

([back to top](#table-of-contents))

### What's Inside (Features)

My aim is to provide a scaffold-like template where you can use it entirely or simply pick parts of it for your workflow. Here's some of the bells and whistles I have included in this repository:

- Bash Scripts
- - Dual install: Bash scripts try to find a local binary first and if it fails, fallback to Docker based alternative
- - See file `local_or_docker_skeleton.sh` as it provides a boilerplate code for your own scripts
- - A lot of sanity checks: to simplify debugging/troubleshooting of Bash scripts I have included a large number of sanity checks
- - Aside from your regular trap/ERR, I have also included logical (sanity) checks to prevent (to an extent) user errors
- - DRY: where possible and to the best of my skills/knowledge, I have applied DRY pattern to keep scripts short
- - All-or-nothing: you can launch checks/tests from a single script or you can run an isolated test (see previous section on `test.sh`)
- - The purpose of this approach is to speed up local development such as to permit isolated testing
- - Deploy: using a single script, you can produce `src.zip` (distribution) which would include all necessary files, including no-dev dependencies (Composer and Yarn) and minified assets (css and js)
- - - including `vendor/` and `node_modules/` may seem unorthodox but my aim was to create "a single button" solution which wouldn't require side steps such as dependencies installation
- - - if such approach is not suitable to you, you only need to add `vendor` and `node_modules` to `.distignore` file and those folders won't be included in the `src.zip`
- WP-Browser/CodeCeption
- - All 4 types of tests (acceptance, functional, wpunit and unit) are fully configured and working out-of-the-box
- - There is a working example for each test as a part of scaffold/boilerplate code
- SemaphoreCI
- - Config includes caching for both, distribution and development dependencies (Composer and Yarn)
- - Last stage (deploy) produces an exportable artifact (`src.zip`) ready-for-consumption
- - Config follows fan-in/fan-out pattern which may be beneficial for your needs
- - Special note: this config uses `docker-compose.yml` as opposed to primary container & services approach as SemaphoreCI does have not adequate capabilities (at the moment) for service containers such as overriding command or entry point; available workaround here is to create your own image based on public image (e.g. MySQL) and override command, entry point, etc. using `Dockerfile`, building your own image and then uploading it to Docker Hub; example is available [here](https://github.community/t5/GitHub-Actions/How-to-specify-docker-image-command/m-p/39061/highlight/true#M3646)
- Docker/docker-compose
- - Config is portable in a sense it can be used for both, local development and CI testing
- - Apache configs (production and development) are included
- - Xdebug is preinstalled and basic config as a starting point is provided
- - I was able to get it working with minimal input doing the following:
- - - in the file `xdebug.ini`, `xdebug.remote_host` should be pointing to docker's machine network *interface* i.e. `ifconfig` on the host machine, then look for subnet matching `docker-machine ip default`
- - - then use PhpStorm to setup [zero-configuration debugging](https://www.jetbrains.com/help/phpstorm/2019.2/zero-configuration-debugging.html?utm_campaign=PS&utm_medium=link&utm_source=product&utm_content=2019.2)
- - - my primary IDE is SubLime but I had poor luck with getting Xdebug working on it
- - - in other words, it is possible to have a correct Xdebug config but broken client giving a wrong impression
- - - check Xdebug log `xdebug_errors.log` as it would usually show errors in such case
- - Bash script `up.sh` waits until WordPress container (including WordPress installation) is ready to avoid premature access
- - Theme folder (`src/`) is symlinked in Docker container so workdir points directly to the source (theme)
- - phpMyAdmin is included to allow GUI-friendly modification of the database
- - phpMyAdmin includes config to allow large MySQL dump imports
- - phpMyAdmin is accessible over `<docker-machine ip default>:22222` or use another machine name if you don't use `default`
- - Repository includes the source code of the custom Docker images used in case you have security concerns over running a 3rd partying Docker image in your environment
- WordPress
- - Classic editor is installed automatically
- - WordPress revisions are disabled
- - Admin username/password is `root`
- - - special note: if you will choose to change password, you will need to update WP-Browser configuration accordingly or your tests will fail
- Linters
- - jshint
- - shellcheck
- - phpcs
- - phplint
- - All linters are pre-configured and work out-of-the-box (see previous sections on how to call linters)
- GruntJS
- - Config includes a number of custom task to concat, minify and lint assets (css and js)
- - You do not need to call GruntJS tasks directly as they are included in the Bash scripts
- Theme (`src/`)
- - Custom function `get_min_file()` automatically substitutes original asset (css and js) with minified version if one exists to avoid hard-coding minified assets
- - Assets (css and js) are split into their respective folders
- - While this repository contains theme code, it should be fairly trivial to replace it with plugin code

([back to top](#table-of-contents))

### How To Build Image

In order to build your own image using the source files provided in the folder `docker-image-src`, execute the following command:

```
docker build -t <name:tag> .
```

where `-t <name:tag>` is optional. For more information, refer to [`docker build docs`](https://docs.docker.com/engine/reference/commandline/build/). Each image was moved into its own sub-folder to provide a better organization.

([back to top](#table-of-contents))
