# apt.phanective.org

This is a Debian/Ubuntu repository which distributes some apps.
Currently, it only provides [github-desktop](https://github.com/shiftkey/desktop).

## Install github-desktop

Run following commands:

```shell
$ curl -sS https://apt.phanective.org/phanective.gpg | sudo gpg --dearmor --output /usr/share/keyrings/phanective.gpg
$ echo "deb [signed-by=/usr/share/keyrings/phanective.gpg] https://apt.phanective.org stable main" | sudo tee /etc/apt/sources.list.d/phanective.list
$ sudo apt update
$ sudo apt install github-desktop
```

## Available packages

- `github-desktop`
