# Secret Vampire

This is a first attempt at creating the frontend for my new hidden movement games

Language: GDScript

Renderer: GLES 2

# Prerequisites

[Godot](https://docs.godotengine.org/en/stable/)

The below build assumes you are on a linux machine with `http` installed (tested on Fedora)

## Build locally

Project can be exported manually using the gui or using the make file. To use the make file:

`make build` Creates the javascript program inside of the `target` directory

`make load-site` Will copy over the files into `/var/www/html` which should be available on `localhost` by default

> **Note:** you will also need to load the environment variables the first time from `resources/env/local.env` this can be done with `source resources/env/local.env`

## Install on Droplet

### Initial Setup

The following instructions only need to be done once on the creation of the Digital Ocean Droplet.

Install HTTPD, make and Git

``` sh
dnf install httpd git make
```

Clone Repo

``` sh
git clone https://github.com/Jaland/secret-hitler-2.0.git
```

Start the server once in order to create the `/etc/www` directory

``` sh
sudo systemctl start httpd
```

### Update Version

``` sh
cd secret-hitler-2.0/
git pull
```
