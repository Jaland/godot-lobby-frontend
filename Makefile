build:
	@rm -rf target
	@mkdir target
	@godot --export "HTML5"

start-local:
	sudo systemctl start httpd.service
restart-local:
	sudo systemctl restart httpd.service
stop-local:
	sudo systemctl stop httpd.service

load-site:
	@sudo rm -rf /var/www/html/*
	@sudo cp -rf target/* /var/www/html/