#!/bin/sh

head -1 debian/changelog |cut -d'(' -f2|cut -d')' -f1

