# [WordPress Beta](https://make.wordpress.org/core/handbook/testing/beta-testing/) via Docker

[![Travis CI](https://img.shields.io/travis/com/jakejarvis/wordpress-beta-docker?label=Travis%20CI&logo=travis)](https://travis-ci.com/jakejarvis/wordpress-beta-docker) [![Docker Pulls](https://img.shields.io/docker/pulls/jakejarvis/wordpress-beta?label=Docker%20Hub&logo=docker)](https://hub.docker.com/r/jakejarvis/wordpress-beta)

## Supported tags and respective `Dockerfile` links

- [`5.4-beta3-apache`, `5.4-apache`, `apache`, `5.4-beta3`, `5.4`, `latest`](https://github.com/jakejarvis/docker-wordpress-beta/blob/451a70586a62f5762af7cbe9cd0a04002c7ef32a/apache/Dockerfile)
- [`5.4-beta3-fpm`, `5.4-fpm`, `fpm`](https://github.com/jakejarvis/docker-wordpress-beta/blob/451a70586a62f5762af7cbe9cd0a04002c7ef32a/fpm/Dockerfile)
- [`5.4-beta3-fpm-alpine`, `5.4-fpm-alpine`, `fpm-alpine`](https://github.com/jakejarvis/docker-wordpress-beta/blob/451a70586a62f5762af7cbe9cd0a04002c7ef32a/fpm-alpine/Dockerfile)

## Usage

```bash
$ docker run -p 8080:80 -d jakejarvis/wordpress-beta:latest
```

For more, refer to the [official WordPress image](https://hub.docker.com/_/wordpress/) which this repository was forked from.

## License

View [license information](https://wordpress.org/about/license/) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
