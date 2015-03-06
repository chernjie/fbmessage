# Facebook-Messenger CLI

A simple tool to send messages on Facebook via command line.

### Usage

All commands assumes you are logged into Facebook.

```bash
	fbmessage.sh <user> <message>

		<user>
		A regex or an alias as stored in `fbmessage.sh.cache`. By the default it expects a Facebook thread ID (i.e. tid) which looks like `id.1234567890`. You can find 

		<message>
		Your intended message to the user

	fbmessage.sh list

		Generate a list of last 5 chat recipients with their relevant `tid`

```

### Installation

```bash
$ brew install chrome-cli xml2
$ cd ~/bin
$ git clone https://github.com/chernjie/fbmessage
$ ln -s fbmessage/fbmessage.sh .
```

