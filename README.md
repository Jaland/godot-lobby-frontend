# Godot Lobby Example

The goal of this project is the creation of a basic lobby system with a frontend using Godot and a backend server built in Java using the Quarkus framework. For documentation on the the backend server check [this](https://github.com/Jaland/godot-lobby-backend) repository.

Language: GDScript

Renderer: GLES 2

Local Dev Using: Fedora Workstation 35

## Prerequisites

* [Godot 3.4+](https://docs.godotengine.org/en/stable/)

# Deploying

## Deploy Local

The easiest way to do local deployment of the frontend is using the Godot UI. The normal play button will create a running instance of your application that should work fine but you can also use the `Exported HTML` button to run the game in the browser. For the most part it should work the same in both, but there are some minor differences between using HTML5 and the normal build. Also using the `HTML` button you can have multiple instances of the app running in different windows which makes it easier to test the lobby systems.

I have also provided a make files that allow for local deployment to an http server if desired.

> Note: This assumes you are running on a linux machine with `httpd` and `make` installed. But again using the Godot UI for testing is actually easier IMO.

### Building with the Make File

`make build` Creates the javascript program inside of the `target` directory

`make load-site` Will copy over the files into `/var/www/html` which should be available on `localhost` by default (assuming you are using Fedora linux)

## Install on DigitalOcean

While building locally is fun and easy(er), the idea of a a lobby service makes more sense when accessible over the internet. We can do that using the HTML5 builder, and pushing our static site onto a server with external connections. There are many inexpensive options for this nowadays such a Google Cloud, AWS has a free teir I think, or even locally if you are able to open up some ports on your router (I would not recommend this for security and difficulty reasons unless you really know what you are doing). I have decided to do my deployment using [Digital Ocean's Cloud](https://cloud.digitalocean.com/), just cause I found the UI to be pretty easy to understand and the pricing was pretty straight forward. And the rest of this section will assume that you are using `Digital Ocean Cloud` and `Github`.

> Note that the frontend install does not actually cost anything to host since it is a static site.

### Prerequisites

In order to use the processes I have created you will need the following:

* Forked Repository containing the code in this Repository that lives on `GitHub`
* [Digital Ocean's Cloud](https://cloud.digitalocean.com/) account
* Backend Installed, instructions can be found [here](https://github.com/Jaland/godot-lobby-backend)
  * Note: You can install the frontend without the backend and the login page will show up, but you obviously won't be able to actually log in

### Code Build Architectures


```mermaid
  graph TD

    subgraph GR[Github Repository]
      wf[Create Frontend App Workflow]
      spec>config/digital-ocean/spec.yaml]

      wf -->|Read Spec| spec 
    end

    subgraph DO[Digital Ocean]
      app([Apps])
      net([Networking])    
      %% cr[(Container Registry)]

      app -.->|"(Optional) Set Domain"| net
    end

    wf --->|Deploy Static Application| app

      u1[User 1]
      u2[User 2]

      u1 --> net
      u2 --> net
      
    style GR fill:#c9510c
    style DO fill:#008bcf
```

### Updating Server Host Information

Before we install our frontend application we will need to update our configuration so that our websockets can connect to our backend. First we will need to retrieve the hostname of our backend server from `Digital Ocean`. This can be done from the home page of the `App` menu item as seen below.

![Retrieve Backend URL](config/readme/assets/retrieve-backend-url.png)

Now we just need to update our project to point to our backend host!

This project includes the custom value `Websocket Host-> Hostname Url` which is set to `ws://localhost:8080` by default (so it should work if the server is installed locally). We need to update it so that we are connecting to our new host using the Websocket Secure protocol so our new url should looks like `wss://<BACKEND_HOSTNAME>`

![Update Websocket Host](config/readme/assets/hostname-option.png)

> **Tip** Changing the value in the `override.cfg` file at the base of the project will override this value when we deploy to our server using the `make build` command. Or you can copy the `override.cfg` file to the base directory if you are building directly using `godot`

### Building Your Application

Now that our hostname is set we can build our static site and push it to our Git Repo. This can be done in one of two ways:

1. **Using Make:** `make build`
1. **Using Godot Native:** `godot --export "HTML5"`
    * Note: Make sure that you move the `override.cfg` file to the base folder if required

> **Info:** Normally I would have the build done using `Gitlab Workflows` but doing it locally and pushing sidesteps versioning issues and just makes it simpler. But does mean you will have to make sure you actually build before you push.

## Setting up Github Repo

This project takes advantage of [Github Workflows](https://docs.github.com/en/actions/using-workflows) in order to do the installation of the frontend application to your `Digital Ocean` account, using DO's [doctl](https://docs.digitalocean.com/reference/doctl/) cli.

In order to allow Github to connect to your `Digital Ocean` account you will need to do two things:

First create a token on through the Digital Ocean UI. This can be done by navigating to `API` -> `Generate new Token`

![Get Access Token](config/readme/assets/get-token.png)

> Tip: Make sure to capture your token on creation, there is no way to retrieve it afterwards. (But you can always just delete and recreate)

Then we need to store that token inside of a `Repository Secret` in our Git Repository that will allow our workflow to push into our DigitalOcean account.

### Required Secrets

| Name                      | Value                                                                                                       | Example                     |
| ------------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------- |
| DIGITALOCEAN_ACCESS_TOKEN | Token retrieved from the DO cloud ui. `API -> Generate New Token`                                           |                             |
|

### Creating Repository Secret

Creating a `Repository Secret` in Github is fairly simple. Just navigate to `Settings` -> `Secrets` -> `Actions` -> `New Repository Secret`

![Update Websocket Host](config/readme/assets/create-secret.png)

## Notes to myself

I can use the following command to keep an eye on my cached value when not using HTML 5:

`watch "cat ~/.local/share/godot/app_userdata/Hidden\ Movement\ Game/user.info"`
`watch "cat ~/.local/share/godot/app_userdata/Hidden\ Movement\ Game/game.info"`
