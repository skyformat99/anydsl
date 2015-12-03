#!/bin/bash
set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${DIR}"/..

# fetch sources
git clone git@github.com:AnyDSL/anydsl.github.io
git clone https://github.com/AnyDSL/anydsl.wiki.git

# symlink git hook
ln -sv "${DIR}/pre-commit-wiki.hook" "${DIR}/../anydsl.wiki/.git/hooks/."
