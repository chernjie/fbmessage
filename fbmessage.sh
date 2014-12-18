#!/usr/bin/env bash

function _setup()
{
	sudo apt-get install -y bundler firefox xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic libqt4-dev
	bundle install --path vendor/bundle
}

function _init()
{
	sudo nohup Xvfb :10 -ac
	until ps aux | grep Xvfb | grep -ve grep -c
	do
		echo .
	done &&
		DISPLAY=:10 firefox &
}

_init
bundle exec rspec -r ./loveyou.rb ./acceptance.rb