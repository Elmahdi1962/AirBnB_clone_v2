#!/usr/bin/env bash
# sets up my web servers for the deployment of web_static
sudo apt -y update
sudo apt-get -y install nginx
sudo ufw allow 'Nginx HTTP'
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo "<h1>Test Page</h1>" > /data/web_static/releases/test/index.html
if [ -d "/data/web_static/current" ];
then
    echo "path /data/web_static/current exists"
    sudo rm -rf /data/web_static/current;
fi;
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data
config=\
"
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;
        add_header X-Served-By \$hostname;
        server_name _;

        location / {
                try_files \$uri \$uri/ =404;
        }

        location /hbnb_static/ { 
            alias /data/web_static/current/;
        }

        error_page 404 /404.html;
        location  /404.html {
            internal;
	    }

        }
        
        if (\$request_filename ~ redirect_me){
            rewrite ^ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
        }
}
"
echo "$config" > /etc/nginx/sites-available/default
sudo ln -sf '/etc/nginx/sites-available/default' '/etc/nginx/sites-enabled/default'
sudo service nginx restart
