#!/usr/bin/env bash

cp ./package.json ./package.json.copy
jq 'del(.dependencies)' ./package.json.copy > ./package.json
mv node_modules node_modules.copy
mv deno.lock deno.lock.copy

deno compile --allow-read --allow-write --allow-net --allow-env --allow-run --ext=js --output=./dist/single-file-aarch64-apple-darwin --target=aarch64-apple-darwin ./single-file
deno compile --allow-read --allow-write --allow-net --allow-env --allow-run --ext=js --output=./dist/single-file-x86_64-apple-darwin --target=x86_64-apple-darwin ./single-file
deno compile --allow-read --allow-write --allow-net --allow-env --allow-run --ext=js --output=./dist/single-file-x86_64-linux --target=x86_64-unknown-linux-gnu ./single-file
deno compile --allow-read --allow-write --allow-net --allow-env --allow-run --ext=js --output=./dist/single-file-aarch64-linux --target=aarch64-unknown-linux-gnu ./single-file
deno compile --allow-all --ext=js --output=./dist/single-file.exe --target=x86_64-pc-windows-msvc --icon=./resources/single-file.ico ./single-file

dev_id=$(security find-identity -p codesigning -v | grep "Apple Development" | awk '{print $2}')
codesign -f -s $dev_id ./dist/single-file-aarch64-apple-darwin
codesign -f -s $dev_id ./dist/single-file-x86_64-apple-darwin

mv ./package.json.copy ./package.json
mv node_modules.copy node_modules
mv deno.lock.copy deno.lock