#!/bin/bash

git add hello.txt  && \
git add -u && \
git commit -m "remote commit" && \
git push origin HEAD 
