#!/usr/bin/python3
'''fabric script for task 2 0X03'''

from fabric.api import put, run, env
import re
from os import path


env.hosts = [
    '34.75.211.145',
    '3.236.217.0'
]


def do_deploy(archive_path):
    '''distributes an archive to my web servers'''
    if not path.exists(archive_path):
        return False
    try:
        file_name = re.search(r'versions/(\S+).tgz', archive_path)
        if file_name is None:
            return False
        file_name = file_name.group(1)
        put(local_path=archive_path, remote_path="/tmp/{}.tgz"
            .format(file_name))

        run("mkdir -p /data/web_static/releases/{}".format(file_name))

        run("tar -xzf /tmp/{}.tgz -C /data/web_static/releases/{}/"
            .format(file_name, file_name))

        run('rm -rf /tmp/{}.tgz'.format(file_name))

        run(('mv /data/web_static/releases/{}/web_static/* ' +
            '/data/web_static/releases/{}/')
            .format(file_name, file_name))

        run('rm -rf /data/web_static/releases/{}/web_static'
            .format(file_name))

        run('rm -rf /data/web_static/current')

        run(('ln -s /data/web_static/releases/{}/' +
            ' /data/web_static/current')
            .format(file_name))
        return True
    except Exception:
        return False
