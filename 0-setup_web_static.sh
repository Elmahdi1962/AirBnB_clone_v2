#!/usr/bin/env bash
# sets up my web servers for the deployment of web_static
sudo apt -y update
sudo apt-get -y install nginx
ufw allow 'Nginx HTTP'
mkdir -p /var/www/html
sudo chmod -R 755 /var/www
echo 'Hello World!' > /var/www/html/index.html
echo -e "Ceci n\x27est pas une page" > /var/www/html/404.html
mkdir -p /data/web_static/
mkdir -p /data/web_static/shared/
mkdir -p /data/web_static/releases/test/
echo "<h1>Test Page</h1>" > /data/web_static/releases/test/index.html
if [ -d "/data/web_static/current" ];
then
    echo "path /data/web_static/current exists"
    rm -rf /data/web_static/current;
fi;
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data
sed -i "/server_name _;/a \\\n\tlocation /hbnb_static { \n\t\talias /data/web_static/current/;\n\t\tautoindex on;\n\t}" /etc/nginx/sites-available/default
ln -sf '/etc/nginx/sites-available/default' '/etc/nginx/sites-enabled/default'
sudo service nginx restart
