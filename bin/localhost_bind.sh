#!/usr/bin/env bash

set -e

# Insert this IP back into /etc/hosts and bind to localhost
ip="127.0.0.1"

# Don't do anything if binding is present
if egrep -q "127\.0\.0\.1\s+localhost" /etc/hosts;
then
	exit 0
else
	echo "Enter password to bind ${ip} to localhost."
	sudo tee -a /etc/hosts <<-EOF > /dev/null

	# Inserted by localhost_bind.sh script
	${ip} localhost

	EOF
	echo "Binding successful."
fi

exit 0
