#!/usr/bin/python3
'''fabric script for task 2 0X03'''

from fabric.api import put, run, env
from os.path import exists


env.hosts = [
    '34.75.211.145',
    '3.236.217.0'
]


def do_deploy(archive_path):
    '''distributes an archive to my web servers'''
    if not exists(archive_path):
        return False
    try:
        file_n = archive_path.split("/")[-1]
        no_ext = file_n.split(".")[0]
        path = "/data/web_static/releases/"
        put(archive_path, '/tmp/')
        run('mkdir -p {}{}/'.format(path, no_ext))
        run('tar -xzf /tmp/{} -C {}{}/'.format(file_n, path, no_ext))
        run('rm /tmp/{}'.format(file_n))
        run('mv {0}{1}/web_static/* {0}{1}/'.format(path, no_ext))
        run('rm -rf {}{}/web_static'.format(path, no_ext))
        run('rm -rf /data/web_static/current')
        run('ln -s {}{}/ /data/web_static/current'.format(path, no_ext))
        return True
    except Exception:
        return False
