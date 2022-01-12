# puppet manifest sets up my web servers for the deployment 

# update packages
exec { 'apt-get-update':
  command  => 'apt-get -y update',
  provider => shell,
}

# install nginx
exec {'install nginx':
  command  => 'apt-get -y install nginx',
  provider => shell,
}

# allow HTTP in Nginx
exec {'allow HTTP':
  command  => "/ufw allow 'Nginx HTTP'",
  provider => shell,
}

# create the path /data/web_static/releases/test/
exec {'mkdir /test':
  command  => 'kdir -p /data/web_static/releases/test/',
  provider => shell,
}

# create the path /data/web_static/shared/
exec {'mkdir /shared':
  command  => 'mkdir -p /data/web_static/shared/',
  provider => shell,
}

# create test inex file with temporary content
exec {'create index.html':
  command  => 'echo "Set by puppet manifest of task 5 from project 0X03 AirBnB" > /data/web_static/releases/test/index.html',
  provider => shell,
}

# delete current folder
exec {'delete /current':
  command  => 'rm -rf /data/web_static/current',
  provider => shell,
}

# link /current to /test
exec {'link /current ot /test':
  command  => 'ln -sf /data/web_static/releases/test /data/web_static/current',
  provider => shell,
}

# change owner of folder /date recursively
exec {'chown /data recursively':
  command  => 'chown -hR ubuntu:ubuntu /data',
  provider => shell,
}

# add /hbnb_static location to nginx config
exec {'add new location /hbnb_static':
  command  => 'sed -i "/server_name _;/a \\\n\tlocation /hbnb_static { \n\t\talias /data/web_static/current/;\n\t\tautoindex on;\n\t}" /etc/nginx/sites-available/default',
  provider => shell,
}

# link sites-enabled/default to sites-available/default
exec {'link /current ot /test':
  command  => 'ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default',
  provider => shell,
}

# restart Nginx service
exec {'restart nginx':
  command  => 'service nginx restart',
  provider => shell,
}
