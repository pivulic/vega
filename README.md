# [vega](https://en.wikipedia.org/wiki/Vega)
Is the 2nd brightest star in the northern hemisphere and provides helpful scripts when working with Magento.

## Installation
1. Clone the repo:

    ```
    git clone git@github.com:pivulic/vega.git ~/
    ```
1. Add `source ~/vega/alias.sh` as a new line in your `~/.bash_profile`:

    ```
    echo source ~/vega/alias.sh >> ~/.bash_profile
    ```

## Commands
Each command can use tab to auto complete, which is either an [alias](http://www.tldp.org/LDP/abs/html/aliases.html) (a keyboard shortcut) or a bash function.

Command | Example   | Description
--- | --- | ---
`bash-reload` |  | Reload ~/.bash_profile
`q` |  | Change directory to /var/www
`m2-create-project <project> <version> <release>` | `m2-create-project CE 2.1.3` | Create a new M2 project

## Run Tests
Bash units are tested with [Bats](https://github.com/sstephenson/bats) by running:

```
make test
```