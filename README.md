## Ananb, the analysis notebook service


Launches analysis servers controlled by jupyter notebooks.

ananb launches a docker container for each user that requests one.


#### Quick start

Get Docker (if you already have Docker and use it please read the Makefil, the dev target might do evil things to you), then:

```
make dev
```

BAM! Visit http://192.168.59.103:8000/user/somestringhere/github.com/betatim/essence.git and you have a working ananb setup. Note, if you are using boot2docker, then you can find your docker host's ip address by running the following command in your console:

```
boot2docker ip
```

If it didn't come up, try running `docker ps -a` and `docker logs tmpnb` to help diagnose issues.


## Credits

This is based on [tmpnb](https://github.com/jupyter/tmpnb). The modifications were made by Tim Head <betatim@gmail.com>