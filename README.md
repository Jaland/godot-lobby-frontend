# Godot Lobby Example

The goal of this project is the creation of a basic lobby system in Godot that uses a backend server built in Java using the Quarkus framework. For documentation on the the backend server check [this](https://github.com/Jaland/godot-lobby-backend) repository.

Language: GDScript

Renderer: GLES 2

Local Dev Using: Fedora Workstation 35

# Prerequisites

[Godot](https://docs.godotengine.org/en/stable/)

## Deploy locally

While I recommend most dev work being done through the Godot UI, I have provided a make files that allow for local deployment to an http server if desired.

> Note: This assumes you are running on a linux machine with `httpd` and `make` installed. But again using the Godot UI for testing is actually easier IMO.

### Building with the Make File

`make build` Creates the javascript program inside of the `target` directory

`make load-site` Will copy over the files into `/var/www/html` which should be available on `localhost` by default (assuming you are using Fedora linux)

## Install on DigitalOcean

While building locally is fun and easy, the idea of a a lobby service makes more sense when accessible over the internet. We can do that using the HTML5 builder, and pushing our static site onto a server with external connections. There are many inexpensive options for this nowadays such a Google Cloud, AWS free, or even locally if you are able to open up some ports on your router (I would not recommend this for security and difficulty reasons unless you really know what you are doing). I have decided to do my deployment using [Digital Ocean's Cloud](https://cloud.digitalocean.com/), just cause I found the UI to be pretty easy to understand and the pricing was pretty straight forward. And the rest of this section will assume that you are using `Digital Ocean Cloud` and `Github`.

> Note that the frontend install does not actually cost anything to host since it is a static site.

### Prerequisites

In order to use the processes I have created you will need the following:

* Forked Repository containing the code in this Repository that lives on `GitHub`
* [Digital Ocean's Cloud](https://cloud.digitalocean.com/) account
* Backend Installed, instructions can be found [here](https://github.com/Jaland/godot-lobby-backend)
  * Note: You can install the frontend without the backend and the login page will show up, but you obviously won't be able to actually log in

## Updating Server Host Information

Before we install our frontend application we will need to update our configuration so that our websockets can connect to our backend. First we will need to retrieve the hostname of our backend server from `Digital Ocean`. This can be done from the home page of the `App` menu item as seen below.

![Retrieve Backend URL](confg/readme/assets/retrieve-backend-url.png)

Now we just need to update our project to point to our backend host!

This project includes the custom value `Websocket Host-> Hostname Url` which is set to `ws://localhost:8080` by default (so it should work if the server is installed locally). We need to update it so that we are connecting to our new host using the Websocket Secure protocal so our new url should looks like `wss://<BACKEND_HOSTNAME>`

![Update Websocket Host](confg/readme/assets/hostname-option.png)

> **Tip** Changing the value in the `override.cfg` file at the base of the project will override this value when we deploy to our server using the Gitlab CI/CD. Which can be easier when testing locally

## Setting up Github Repo

The installation takes advantage of [Github Workflows](https://docs.github.com/en/actions/using-workflows) in order to do the installation of the frontend application to your `Digital Ocean` account, using DO's [doctl](https://docs.digitalocean.com/reference/doctl/) cli.

In order to allow Github to connect to your `Digital Ocean` account you will need to do two things:

First create a token on through the Digital Ocean UI. This can be done by navigating to `API` -> `Generate new Token`

![Get Access Token](confg/readme/assets/get-token.png)

Then 

> Tip: Make sure to capture your token on creation, there is no way to retrieve it afterwards. (But you can always just delete and recreate)



## Notes to myself

I can use the following command to keep an eye on my cached value when not using HTML 5:

`watch "cat ~/.local/share/godot/app_userdata/Hidden\ Movement\ Game/user.info"`
`watch "cat ~/.local/share/godot/app_userdata/Hidden\ Movement\ Game/game.info"`
