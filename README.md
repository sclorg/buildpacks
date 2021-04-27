# Cloud native buildpacks based on Red Hat universal base container image

This is just a proof of concept for running [Cloud native buildpacks](https://buildpacks.io/) on UBI using some bits from [S2I Python container](https://github.com/sclorg/s2i-python-container) and [S2I Ruby container](https://github.com/sclorg/s2i-ruby-container).

## Disclaimer

This is just a proof of concept to check whether we are able to transfer scripts from S2I container images to CNB. Because the builder here is universal, the build and run images are large and they are not suitable for production use. We are looking for [RFC 0069](https://github.com/buildpacks/rfcs/blob/main/text/0069-stack-buildpacks.md) to be implemented which will allow us to install different sets of RPM packages into the build and run images. In the meantime, we just experiment with the universal images.

## Buildpacks

This example project currently implements two buildpacks – Python and Ruby.

For buildpacks settings, use `.environment` file in the root of you application – the same way you use `.s2i/environment` for S2I images. The file is sourced in all buildpacks at the very beginning of the build phase.

### Python

#### Available features

* dependencies installation from `requirements.txt`, `Pipfile.lock` or `setup.py`
* Gunicorn support
* `APP_SCRIPT`, `APP_FILE` or `APP_MODULE` settings. See [S2I documentation](https://github.com/sclorg/s2i-python-container/tree/master/3.6#environment-variables) for more information.

#### Example applications

* setup-requirements-test-app - uses Gunicorn, the name of the module is taken from `setup.py`
* standalone-test-app - uses Gunicorn but runs as a Python script which is configured via the `.environment` file
* uwsgi-test-app - uses uWSGI (compiled from sources), Flask and shell script to execute the server

### Ruby

#### Available features

* dependencies installation from `Gemfile` and `Gemfile.lock`
* detection of Puma or Rackup commands

#### Example applications

* puma-test-app - uses Gemfile to define dependencies, Sinatra as a web framework and Puma as a web server 
* rack-test-app - uses Gemfile.lock to define dependencies,  Sinatra as a web framework and Rack as a web server

## Usage

Use can play with this content with podman or in a virtual Centos 8 prepared for Vagrant with Docker CE. The virtual machine contains everything you need. For local usage, don't forget to download [pack CLI tool](https://github.com/buildpacks/pack).

Buildpacks currently implement only a subset of S2I container images' functionalities – see the example apps in the `apps` folder.

The `build.sh` script rebuilds all the container images, the builder image with buildpacks on top of them and then all the application images with the builder. 

### Podman (on Fedora)

First, make podman available via an unix socket to behave like a running Docker daemon:

```
podman system service --time 0 &
export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
```

Then you can run `build.sh` to build the images and example applications. The script uses `docker` so make sure you have podman-docker alias installed.

In case of any troubles with SELinux, switch from unix socket to TCP.

```
podman system service --time=0 tcp:0.0.0.0:1234
export DOCKER_HOST=tcp://127.0.0.1:1234
```

And then, every call to `pack` should have `--docker-host=tcp://127.0.0.1:1234 --network=host`.

### Docker in a virtual machine

Use `vagrant up` to start and provision a virtual machine and then run `build.sh` in the virtual machine.
