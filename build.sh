#!/bin/bash -eu

echo "--- Building base images"
docker build . -t sclorg/ubi8-stack-base --target base
docker build . -t sclorg/ubi8-stack-run --target run
docker build . -t sclorg/ubi8-stack-build --target build

echo "--- Building builder images with buildpacks"
pack --verbose builder create sclorg-ubi8-builder --config ./builder.toml

echo "--- Building application images"
pack build --path apps/standalone-test-app/ --builder sclorg-ubi8-builder standalone-test-app-image
pack build --path apps/uwsgi-test-app/ --builder sclorg-ubi8-builder uwsgi-test-app-image
pack build --path apps/setup-requirements-test-app --builder sclorg-ubi8-builder setup-requirements-test-app
pack build --path apps/puma-test-app --builder sclorg-ubi8-builder puma-test-app
pack build --path apps/rack-test-app --builder sclorg-ubi8-builder rack-test-app
