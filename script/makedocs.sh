#!/usr/bin/env bash

# show python version just to be sure we're using the right one.
python --version

# simulating build process
echo "v3" >"$1/README"
