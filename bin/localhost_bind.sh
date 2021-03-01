#!/usr/bin/env bash

set -e

# Insert this IP back into /etc/hosts and bind to localhost
ip="127.0.0.1"

# Don't do anything if binding is present
if egrep -q "127\.0\.0\.1\s+localhost" /etc/hosts;
then
		exit 0
else
		tee -a /etc/hosts <<-EOF > /dev/null
		# Reinsert binding
		localhost ${ip}
		EOF
fi

exit 0
