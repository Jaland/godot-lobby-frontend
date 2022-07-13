IP_ADDRESS=162.243.168.138
USER=root
SHELL = /bin/bash

build:
	@rm -rf target
	@mkdir target
	source resources/env/local.env
	echo $TEST2
	godot --export "HTML5"

start-local:
	@sudo systemctl start httpd.service
restart-local:
	@sudo systemctl restart httpd.service
stop-local:
	@sudo systemctl stop httpd.service

load:
	@sudo rm -rf /var/www/html/*
	@sudo cp -rf target/* /var/www/html/

build-and-load: build load 

push-to-droplet:
	ssh $(USER)@$(IP_ADDRESS) rm -rf /var/www/html/*
	rsync target/* $(USER)@$(IP_ADDRESS):/var/www/html