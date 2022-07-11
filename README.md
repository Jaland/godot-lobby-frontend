# Secret Hitler Frontend 2.0

This is a first attempt at creating the frontend for Secret Hitler using Godot. An opensource solution for game creation.

Language: GDScript

Renderer: GLES 2

# Prerequisites

[Godot](https://docs.godotengine.org/en/stable/)

The below build assumes you are on a linux machine with `http` installed (tested on Fedora)

## Build locally

Project can be exported manually using the gui or using the make file. To use the make file:

`make build` Creates the javascript program inside of the `target` directory

`make load-site` Will copy over the files into `/var/www/html` which should be available on `localhost` by default

## Install on Droplet

### Initial Setup

The following instructions only need to be done once on the creation of the Digital Ocean Droplet.


Install HTTPD

``` sh
dnf install httpd
```

