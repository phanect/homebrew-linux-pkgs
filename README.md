# Homebrew Linux packages

Currently, only deb package is available.

## Install

> [!WARNING]
> When you update this homebrew package, the commands installed by homebrew may be unavailable until you re-login. 

Run following commands:

```shell
$ curl -sS https://apt.phanective.org/phanective.gpg | sudo gpg --dearmor --output /usr/share/keyrings/phanective.gpg
$ echo "deb [signed-by=/usr/share/keyrings/phanective.gpg] https://apt.phanective.org stable main" | sudo tee /etc/apt/sources.list.d/phanective.list
$ sudo apt update
$ sudo apt install homebrew
```

## License & Credits

This repository itself is licensed under the [CC0 1.0 Universal](./LICENSE.txt) i.e. Public Domain.
