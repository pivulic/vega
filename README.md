# [vega](https://en.wikipedia.org/wiki/Vega)
Is the 2nd brightest star in the northern hemisphere and provides helpful scripts when working with Magento.

## Installation
1. Clone the repo:

    ```
    git clone git@github.com:pivulic/vega.git ~/vega
    ```
1. Add `source ~/vega/alias.sh` as a new line in your `~/.bash_profile`:

    ```
    echo 'source ~/vega/alias.sh' >> ~/.bash_profile
    ```

## Commands
Each command can use tab to auto complete, which is either an [alias](http://www.tldp.org/LDP/abs/html/aliases.html) (a keyboard shortcut) or a bash function.

Some of these scripts requires [Docker](https://www.docker.com/) to be installed.

Command | Description
--- | ---
`bash-reload` | Reload ~/.bash_profile
`d-composer` | Run Composer through the [Composer container](https://hub.docker.com/r/library/composer/)
`dangling-images` | Show dangling (`<none>:<none>`) Docker images
`dangling-volumes` | Show orphan Docker volumes
`docker-env` | Set `docker-machine` environment variables
`docker-exec` | Execute command inside Docker container, e.g: <br> `docker-exec m2clean_web_1 install`
`docker-images-by-name` | Show Docker Image ID by name, e.g: <br> `docker-images-by-name vendor/name`
`kubectl-exec` | Execute command inside Kubernetes pod, e.g: <br> `kubectl-exec web-1536742303-r0n4f install`
`m2` | Run `bin/magento` CLI
`m2-build-artifact` | Create & copy a m2-html.tar.gz artifact to local
`m2-create-project <project> <version> <release>` | Create a new M2 project, e.g: <br> `m2-create-project ikea CE 2.1.3`
`m2-install-sampledata` | Install Sample Data
`web-composer` | Execute composer command in `web` Docker Composer service
`m2-up` | Create/(re)start `web` Docker Compose service
`q` | Change directory to ~/projects/
`rm-all-containers [except container_name]` | Remove all Docker containers, e.g: <br> `rm-all-containers` <br> `rm-all-containers dinghy_http_proxy`
`rm-dangling-images` | Remove dangling (`<none>:<none>`) Docker images
`rm-dangling-volumes` | Remove dangling/orphan Docker volumes
`rm-docker-images-by-name` | Remove Docker images by name, e.g: <br> `rm-docker-images-by-name vendor/name`
`ssh-docker` | SSH into a Docker container, e.g: <br> `ssh-docker m2clean_web_1`
`ssh-k8` | SSH into a Kubernetes pod, e.g: <br> `ssh-k8 web-1536742303-r0n4f`
`ssh-key-copy` | Copy `~/.ssh/id_rsa.pub` to clipboard
`vega-update` | Update this repository to latest version

## Bash Prompt
To quickly make your Bash prompt more useful and fancy (similar to a [PS1 generator](http://bashrcgenerator.com)), add the following line to your `~/.bash_profile` by running:

```
echo 'source ~/vega/functions/bash-prompt.sh' >> ~/.bash_profile
```

## Run Tests
Bash units are tested with [Bats](https://github.com/sstephenson/bats) by running:

```
make test
```