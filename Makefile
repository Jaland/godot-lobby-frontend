OVERRIDE_FILE=resources/overrides/override.cfg

build:
	@rm -rf target
	@mkdir target
	@cp ${OVERRIDE_FILE} override.cfg
	godot --export "HTML5"
	@rm override.cfg


build-local:
	@rm -rf target
	@mkdir target
	godot --export "HTML5"


# Used for local testing if you don't want to use the godot ui
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
