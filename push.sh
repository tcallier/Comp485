#!/bin/bash

git add . && \
git add -u && \
git commit -m "remote commit" && \
git push origin HEAD 
