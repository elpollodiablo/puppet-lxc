#!/bin/sh

for thing in subuid subgid; do
	awk -F\: '{print "'$thing'_" $1 "_offset=" $2 "\n'$thing'_" $1 "_size=" $3 }' /etc/$thing
done
