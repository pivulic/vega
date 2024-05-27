# [vega](https://en.wikipedia.org/wiki/Vega)
Is the 2nd brightest star in the northern hemisphere and provides helpful scripts when working with Magento.

## Installation
1. Clone the repo:

    ```
    git clone git@github.com:pivulic/vega.git ~/vega
    ```
1. Add `source ~/vega/alias.sh` as a new line in your `~/.zshrc`:

    ```
    echo 'source ~/vega/alias.sh' >> ~/.zshrc
    ```

## Commands
Each command can use tab to auto complete, which is either an [alias](http://www.tldp.org/LDP/abs/html/aliases.html) (a keyboard shortcut) or a bash function.

Some of these scripts requires [Docker](https://www.docker.com/) to be installed.

Command | Description
--- | ---
`bash-reload` | Reload ~/.zshrc
`dangling-images` | Show dangling (`<none>:<none>`) Docker images
`dangling-volumes` | Show orphan Docker volumes
`q` | Change directory to ~/projects/
`rm-all-containers [except container_name]` | Remove all Docker containers, e.g: <br> `rm-all-containers` <br> `rm-all-containers dinghy_http_proxy`
`rm-dangling-images` | Remove dangling (`<none>:<none>`) Docker images
`rm-dangling-volumes` | Remove dangling/orphan Docker volumes
`rm-docker-images-by-name` | Remove Docker images by name, e.g: <br> `rm-docker-images-by-name vendor/name`
`ssh-key-copy` | Copy `~/.ssh/id_ed25519.pub` to clipboard
`vega-update` | Update this repository to latest version
`ll` | List all files and folders

## Bash Prompt
To quickly make your Bash prompt more useful and fancy (similar to a [PS1 generator](http://bashrcgenerator.com)), add the following line to your `~/.zshrc` by running:

```
echo 'source ~/vega/functions/bash-prompt.sh' >> ~/.zshrc
```

## Run Tests
Bash units are tested with [Bats](https://github.com/sstephenson/bats) by running:

```
make test
```
