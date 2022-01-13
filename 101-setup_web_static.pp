# update packages
exec { 'apt-get-update':
  command  => 'sudo apt-get -y update',
  provider => shell,
}

# install nginx
exec {'install nginx':
  command  => 'sudo apt-get -y install nginx',
  provider => shell,
}

# allow HTTP in Nginx
# exec {'allow HTTP':
#  command  => "sudo ufw allow 'Nginx HTTP'",
#  provider => shell,
# }

# create the path /data/web_static/releases/test/
exec {'mkdir /test':
  command  => 'sudo mkdir -p /data/web_static/releases/test/',
  provider => shell,
}

# create the path /data/web_static/shared/
exec {'mkdir /shared':
  command  => 'sudo mkdir -p /data/web_static/shared/',
  provider => shell,
}

# change owner of folder /date recursively
exec {'chown-data':
  command  => 'sudo chown -hR ubuntu:ubuntu /data',
  provider => shell,
}

# create test inex file with temporary content
exec {'create index.html':
  command  => 'echo "Set by puppet manifest of task 5 from project 0X03 AirBnB" > /data/web_static/releases/test/index.html',
  provider => shell,
}

file { '/etc/nginx/sites-available/default':
  ensure  => file,
  mode    => '0644',
  owner   => 'www-data',
  content =>
"server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    index index.html index.htm;
    error_page 404 /404.html;
    add_header X-Served-By \$hostname;
    location / {
        root /var/www/html/;
        try_files \$uri \$uri/ =404;
    }
    location /hbnb_static {
        alias /data/web_static/current/;
    }
    if (\$request_filename ~ redirect_me){
        rewrite ^ https://sketchfab.com/bluepeno/models permanent;
    }
    location = /404.html {
        root /var/www/error/;
        internal;
    }
}",
}

# link /current to /test
exec {'link /current ot /test':
  command  => 'sudo ln -sf /data/web_static/releases/test /data/web_static/current',
  provider => shell,
}

# add /hbnb_static location to nginx config
# exec {'add new location /hbnb_static':
#  command  => 'sudo sed -i "38i\ \\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n" /etc/nginx/sites-available/default',
#  provider => shell,
# }

# link sites-enabled/default to sites-available/default
exec {'link sites enabled to available':
  command  => 'sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default',
  provider => shell,
}

# restart Nginx service
exec {'restart nginx':
  command  => 'sudo service nginx restart',
  provider => shell,
}
