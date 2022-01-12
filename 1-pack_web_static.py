#!/usr/bin/python3
'''Fabric script for task 1 0X03'''

from fabric.api import local
from datetime import datetime


def do_pack():
    '''generates a .tgz archive from the contents of the web_static folder'''
    local("mkdir -p versions")
    result = local("tar -cvzf versions/web_static_{}.tgz web_static"
                   .format(datetime.strftime(datetime.now(), "%Y%m%d%H%M%S")),
                   capture=True)

    if result.failed:
        return None
    return result
