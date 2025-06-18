#!/bin/sh
SKIP_DIRS=".git smods lovely 3xCredits"

for f in *; do
	if [ -d "$f" ] && echo "$SKIP_DIRS" | grep -qvw "$f"; then
		echo "Disabling $f"
		touch "$f/.lovelyignore"
	fi
done
