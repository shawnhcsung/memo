#!/bin/bash

TYPE=svg

if [ -z "$1" ]; then
    echo "usage: $0 \$PATH_TO_SCAN"
    exit
fi

for source in $(find $1 -name "*.gv"); do
    target="${source::-3}.${TYPE}"
    if [ "$target" -ot "$source" ]; then
        echo "Processing \"$source\" ..."
        dot -T${TYPE} -o "$target" "$source"
    fi
done
