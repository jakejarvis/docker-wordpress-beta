# [WordPress Beta](https://make.wordpress.org/core/handbook/testing/beta-testing/) via Docker

[![Travis CI](https://img.shields.io/travis/com/jakejarvis/docker-wordpress-beta?label=Travis%20CI&logo=travis)](https://travis-ci.com/jakejarvis/docker-wordpress-beta) [![Docker Pulls](https://img.shields.io/docker/pulls/jakejarvis/wordpress-beta?label=Docker%20Hub&logo=docker)](https://hub.docker.com/r/jakejarvis/wordpress-beta)

## Supported tags and respective `Dockerfile` links

- [`5.4-beta3-apache`, `5.4-apache`, `apache`, `5.4-beta3`, `5.4`, `latest`](https://github.com/jakejarvis/docker-wordpress-beta/blob/451a70586a62f5762af7cbe9cd0a04002c7ef32a/apache/Dockerfile)
- [`5.4-beta3-fpm`, `5.4-fpm`, `fpm`](https://github.com/jakejarvis/docker-wordpress-beta/blob/451a70586a62f5762af7cbe9cd0a04002c7ef32a/fpm/Dockerfile)
- [`5.4-beta3-fpm-alpine`, `5.4-fpm-alpine`, `fpm-alpine`](https://github.com/jakejarvis/docker-wordpress-beta/blob/451a70586a62f5762af7cbe9cd0a04002c7ef32a/fpm-alpine/Dockerfile)

## Usage

```bash
$ docker run -p 8080:80 -d jakejarvis/wordpress-beta:latest
```

For a full plug-and-play setup, you can also reference an [example `docker-compose.yml` file](docker-compose.yml) I've provided, which includes this WordPress Beta container, [MariaDB](https://hub.docker.com/_/mariadb), [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/), and [WP-CLI](https://wp-cli.org/). Just run `docker-compose up` in this directory and visit [http://localhost:8080/](http://localhost:8080/) to see the magic happen!

You can also refer to the [official WordPress image](https://hub.docker.com/_/wordpress/), which this repository was forked from, for even more options — everything there is cross-compatible.

The [WordPress Beta Tester](https://wordpress.org/plugins/wordpress-beta-tester/) plugin can be added after setup to join the nightly (alpha) or trunk (literally the [latest commits](https://core.trac.wordpress.org/browser/trunk)) release channels (at your own risk 😬).

## License

View [license information](https://wordpress.org/about/license/) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
