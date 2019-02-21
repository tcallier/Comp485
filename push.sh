#!/bin/bash

git add versions  && \
git add -u && \
git commit -m "remote commit" && \
git push origin HEAD 
