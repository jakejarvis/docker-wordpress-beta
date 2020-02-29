#!/bin/bash
set -euo pipefail

# Usage: ./update.sh 5.4-beta3

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

phpVersion=7.4

current=$1
sha1="$(curl -fsSL "https://wordpress.org/wordpress-$current.tar.gz.sha1")"

declare -A variantExtras=(
	[apache]="$(< apache-extras.template)"
)
declare -A variantCmds=(
	[apache]='apache2-foreground'
	[fpm]='php-fpm'
	[fpm-alpine]='php-fpm'
)
declare -A variantBases=(
	[apache]='debian'
	[fpm]='debian'
	[fpm-alpine]='alpine'
)

sed_escape_rhs() {
	sed -e 's/[\/&]/\\&/g; $!a\'$'\n''\\n' <<<"$*" | tr -d '\n'
}

travisEnv=

for variant in apache fpm fpm-alpine; do
	dir="$variant"
	mkdir -p "$dir"

	extras="${variantExtras[$variant]:-}"
	if [ -n "$extras" ]; then
		extras=$'\n'"$extras"$'\n'
	fi
	cmd="${variantCmds[$variant]}"
	base="${variantBases[$variant]}"

	entrypoint='docker-entrypoint.sh'

	sed -r \
		-e 's!%%WORDPRESS_VERSION%%!'"$current"'!g' \
		-e 's!%%WORDPRESS_SHA1%%!'"$sha1"'!g' \
		-e 's!%%PHP_VERSION%%!'"$phpVersion"'!g' \
		-e 's!%%VARIANT%%!'"$variant"'!g' \
		-e 's!%%VARIANT_EXTRAS%%!'"$(sed_escape_rhs "$extras")"'!g' \
		-e 's!%%CMD%%!'"$cmd"'!g' \
		"Dockerfile-${base}.template" > "$dir/Dockerfile"

	cp -a "$entrypoint" "$dir/docker-entrypoint.sh"

	travisEnv+='\n    - VARIANT='"$dir"
done

travis="$(awk -v 'RS=\n\n' '$1 == "  matrix:" { $0 = "  matrix:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
