#!/bin/bash

# Load env variables
source .env

# Build web
flutter build web

# Replace env variables in index.html
sed -i "s|%BASE_URL%|$BASE_URL|g" build/web/index.html
sed -i "s|%AUTHORIZATION%|$AUTHORIZATION|g" build/web/index.html
