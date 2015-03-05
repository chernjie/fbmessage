#!/usr/bin/env bash

use() {
	for i
	do
		if ! command -v $i > /dev/null
			then
			echo $i not found
		fi
	done
}

_window_exists() {
	chrome-cli list links | grep $1 | grep -oE ':[0-9]+' -m1 | tr -d :
}

_open() {
	_tab_id=$(_window_exists $1)

	test -z "$_tab_id" &&
		_tab_id=$(chrome-cli open $1 | grep ^Id | cut -d: -f2)
}

_javascript() {
	echo '(function (d){ d.querySelector("#composerInput").value = "'"$@"'"; d.querySelector("form").submit(); return "message sent"; })(document);'
}

_send_message() {
	chrome-cli execute "$(_javascript "$@")" -t $_tab_id
}

_main() {
	_open https://m.facebook.com/messages/read/?tid=id.398940466822049
	_send_message "$@"
}

### OPTIONS ###

use chrome-cli grep tr cut
case $1 in
	'') echo Write a reply... ;;
	*) _main "$@";;
	esac
