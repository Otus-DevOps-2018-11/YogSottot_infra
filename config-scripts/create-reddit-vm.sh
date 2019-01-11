#!/usr/bin/env bash

gcloud compute instances create reddit-app --tags puma-server --image-family reddit-full --machine-type=g1-small
