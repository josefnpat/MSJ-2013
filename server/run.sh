#!/bin/sh
while true; do
  git pull
  lua5.1 ./server.lua
  sleep 2
done