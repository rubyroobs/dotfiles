#!/usr/bin/env bash

if command -v fc-cache > /dev/null 2>&1; then
    fc-cache
fi

if command -v skhd > /dev/null 2>&1; then
    skhd --stop-service
    skhd --start-service
fi
