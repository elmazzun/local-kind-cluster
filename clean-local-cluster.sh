#!/bin/bash

docker stop $(docker ps -a -q)

docker remove $(docker ps -a -q)
