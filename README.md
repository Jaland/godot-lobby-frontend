# Godot Lobby Example

The goal of this project is the creation of a basic lobby system in Godot that uses a backend server built in Java using the Quarkus framework, more information on that part of the project can be found [here](). While I was initially 

Language: GDScript

Renderer: GLES 2

# Prerequisites

[Godot](https://docs.godotengine.org/en/stable/)

The below build assumes you are on a linux machine with `http` installed (tested on Fedora)

## Build locally

Project can be exported manually using the gui or using the make file. To use the make file:

`make build` Creates the javascript program inside of the `target` directory

`make load-site` Will copy over the files into `/var/www/html` which should be available on `localhost` by default (assuming you are using Fedora linux)

## Install on Droplet

If using this lobby system in order to give access to your project to your friends across the internet you will need to install it on a machine that allows for external access. There are many inexpensive options that can be setup nowadays such a Google Cloud, AWS free, or even locally if you are able to open up some ports (I would not recommend this for security reasons unless you really know what you are doing).

Personally I found that the most simplistic option was creating a `Droplet` on (Digital Ocean)[https://m.do.co/c/5dca16f0ed95]. Creating and accessing it is very simple, the lowest level 1 gig of memory only cost like 7 dollars a month (which should be fine for initial testing), and you can easily turn it on and off as you please.

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

## TODO's

During login check if the user has a valid token if they do they automatically log them in.

Save User's game information to cache so they can be more easily reinserted into the game.

Add option for single session security where we validate the token and the session id match in the cache to prevent multiple session from opening (not sure if that is a good idea or not)


## Notes to myself

I can use the following command to keep an eye on my cached value when not using HTML 5:

`watch "cat ~/.local/share/godot/app_userdata/Hidden\ Movement\ Game/user.info"`
`watch "cat ~/.local/share/godot/app_userdata/Hidden\ Movement\ Game/game.info"`
