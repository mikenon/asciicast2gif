#!/usr/bin/env bash

set -e

a2gif_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'a2gif-tmp')
trap 'rm -rf $tmp_dir' EXIT

theme="asciinema"
scale=2
width=""
height=""

while getopts ":w:h:t:s:" opt; do
    case $opt in
        t)
            theme=$OPTARG
            ;;
        s)
            scale=$OPTARG
            ;;
        w)
            width=$OPTARG
            ;;
        h)
            height=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

if (($# != 2)); then
    echo "usage: a2gif [-t theme] [-s scale] [-w columns] [-h rows] <input-json-path-or-url> <output-gif-path>"
    exit 1
fi

if [[ -n $width ]]; then
    export WIDTH=$width
fi

if [[ -n $height ]]; then
    export HEIGHT=$height
fi

node \
    --max-old-space-size=512 \
    "${a2gif_dir}/main.js" \
    "${1}" \
    "${2}" \
    "${tmp_dir}" \
    $theme \
    $scale

echo "Done."
