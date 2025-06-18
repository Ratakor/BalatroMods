#!/bin/sh
SKIP_DIRS=".git smods lovely"

for f in *; do
	if [ -d "$f" ] && echo "$SKIP_DIRS" | grep -qvw "$f"; then
		echo "Disabling $f"
		touch "$f/.lovelyignore"
	fi
done
