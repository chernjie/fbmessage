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
	chrome-cli list links | grep $1 | grep -oE ':?[0-9]+' -m1 | head -1 | tr -d :
}

_open() {
	_tab_id=$(_window_exists $1)

	test -z "$_tab_id" &&
		_tab_id=$(chrome-cli open $1 | grep ^Id | cut -d: -f2)
}

_is_loaded() {
	until chrome-cli info -t $1 | grep "Loading: No" -q
	do
		sleep 1
		echo still loading...
	done
}

_javascript() {
	echo '(function (d){ d.querySelector("#composerInput").value = "'"$@"'"; d.querySelector("form").submit(); return "message sent"; })(document);'
}

_send_message() {
	chrome-cli execute "$(_javascript "$@")" -t $_tab_id
}

_recipient() {
	_find_recipient_by_pattern "$@" && return 0

	case "$@" in
		id.[0-9][0-9]*) echo "$@";;
		*)
			echo Who do you want to send it to?
			exit 1
			;;
	esac
}

_find_recipient_by_pattern() {
	test -f $0.cache || _recipients
	grep -i $@ $0.cache | cut -d" " -f1
	return ${PIPESTATUS[0]}
}

_is_recipient() {
	case "$@" in
		id.[0-9][0-9]*) return 0;;
		*)    return 1;;
	esac
}

_recipients_cache() {
	test -f $0.cache || _recipients
	cat $0.cache
}


_recipients() {
	_open https://m.facebook.com/messages/
	_is_loaded $_tab_id
	chrome-cli source -t $_tab_id |
		html2 2> /dev/null |
		grep messages/read/ -A50 |
		grep -e @href -e thread-title -A1 |
		grep -e @href -e strong |
		cut -d= -f2- |
		cut -d= -f2- |
		while read i
		do
			if _is_recipient "$i"
				then id="$i"
			else
				echo "$id" "$i" | tee -a $0.cache
				id=
			fi
		done
}

_main() {
	local tid=$(_recipient $1)
	shift
	_open https://m.facebook.com/messages/read/?tid=$(tid)
	_is_loaded $_tab_id
	_send_message "$@"
}

### OPTIONS ###

use chrome-cli grep tr cut html2
case $1 in
	'') echo Write a reply... ;;
	list) _recipients_cache;;
	*) _main "$@";;
	esac
