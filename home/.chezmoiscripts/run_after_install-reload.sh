#!/usr/bin/env bash

if command -v fc-cache > /dev/null 2>&1; then
    fc-cache
fi

if command -v aerospace > /dev/null 2>&1; then
    aerospace reload-config
fi
