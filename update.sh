#!/bin/bash
set -euo pipefail

# Usage: ./update.sh 5.4-beta3

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

current=$1
sha1="$(curl -fsSL "https://wordpress.org/wordpress-$current.tar.gz.sha1")"

phpVersions=( php*.* )

cliPossibleVersions=( $(
	git ls-remote --tags 'https://github.com/wp-cli/wp-cli.git' \
		| sed -r 's!^[^\t]+\trefs/tags/v([^^]+).*!\1!g' \
		| sort --version-sort --reverse
	)
)
cliVersion=
cliSha512=
for cliPosVer in "${cliPossibleVersions[@]}"; do
	cliUrl="https://github.com/wp-cli/wp-cli/releases/download/v${cliPosVer}/wp-cli-${cliPosVer}.phar.sha512"
	if cliSha512="$(curl -fsSL "$cliUrl" 2>/dev/null)"; then
		cliVersion="$cliPosVer"
		break
	fi
done
echo "$current (CLI '$cliVersion')"
# make sure we get a cliVersion
[ -n "$cliVersion" ]

declare -A variantExtras=(
	[apache]="$(< apache-extras.template)"
)
declare -A variantCmds=(
	[apache]='apache2-foreground'
	[fpm]='php-fpm'
	[fpm-alpine]='php-fpm'
	[cli]='' # unused
)
declare -A variantBases=(
	[apache]='debian'
	[fpm]='debian'
	[fpm-alpine]='alpine'
	[cli]='cli'
)

sed_escape_rhs() {
	sed -e 's/[\/&]/\\&/g; $!a\'$'\n''\\n' <<<"$*" | tr -d '\n'
}

travisEnv=
for phpVersion in "${phpVersions[@]}"; do
	phpVersionDir="$phpVersion"
	phpVersion="${phpVersion#php}"

	for variant in apache fpm fpm-alpine cli; do
		dir="$phpVersionDir/$variant"
		mkdir -p "$dir"

		extras="${variantExtras[$variant]:-}"
		if [ -n "$extras" ]; then
			extras=$'\n'"$extras"$'\n'
		fi
		cmd="${variantCmds[$variant]}"
		base="${variantBases[$variant]}"

		entrypoint='docker-entrypoint.sh'
		if [ "$variant" = 'cli' ]; then
			entrypoint='cli-entrypoint.sh'
		fi

		sed -r \
			-e 's!%%WORDPRESS_VERSION%%!'"$current"'!g' \
			-e 's!%%WORDPRESS_SHA1%%!'"$sha1"'!g' \
			-e 's!%%PHP_VERSION%%!'"$phpVersion"'!g' \
			-e 's!%%VARIANT%%!'"$variant"'!g' \
			-e 's!%%WORDPRESS_CLI_VERSION%%!'"$cliVersion"'!g' \
			-e 's!%%WORDPRESS_CLI_SHA512%%!'"$cliSha512"'!g' \
			-e 's!%%VARIANT_EXTRAS%%!'"$(sed_escape_rhs "$extras")"'!g' \
			-e 's!%%CMD%%!'"$cmd"'!g' \
			"Dockerfile-${base}.template" > "$dir/Dockerfile"

		case "$phpVersion" in
			7.2 )
				sed -ri \
					-e '/libzip-dev/d' \
					"$dir/Dockerfile"
				;;
		esac
		case "$phpVersion" in
			7.2 | 7.3 )
				sed -ri \
					-e 's!gd --with-freetype --with-jpeg!gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr!g' \
					"$dir/Dockerfile"
				;;
		esac

		cp -a "$entrypoint" "$dir/docker-entrypoint.sh"

		travisEnv+='\n  - VARIANT='"$dir"
	done
done

travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
