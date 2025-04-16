#!/bin/bash -x

cryosparcm start database
cryosparcm fixdbport
cryosparcm restart
