#!/usr/bin/env zsh


# Instructions
cat << EOF
This script will show you the contents of all of your "dangling blobs".

RECOVER:
	Page (with less) through the content, and if you would like to recover this
	file, press 'y' when prompted.

	Your desired content is recovered to a file named ".recovered_object". (Note:
	You can rename this and make any other changes you see fit at this point.)

SKIP:
	To skip the next file, press 'n' when prompted.

EOF

# Gather dangling blob SHAs
DANGLING_BLOBS_SHA=$(git fsck --lost-found | grep 'dangling blob' | awk '{print $3}')
BLOB_COUNT=$(echo ${DANGLING_BLOBS_SHA} | wc -l)

printf "%d blobs to inspect...\n\n" "$BLOB_COUNT"
read -s -k $'?Press any key to continue; CTRL+C to quit.\n'

# Show each blob until one is chosen to be saved
counter=1
while IFS='' read sha; do
	printf "\nBlob %d of %d: " "$counter" "$BLOB_COUNT"
	contents=$(git show ${sha})
	echo "$contents" | ${PAGER:-less}
	if read -q '? Save and quit? (y/n) '; then
		echo "$contents" > .recovered_object
		exit 0
	else
		((counter++))
	fi
done <<< ${DANGLING_BLOBS_SHA}

exit 0
