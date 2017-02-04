#!/bin/bash

# disable `requiretty`, based on feedback from http://dcmnt.me/2c4dpmM
sed -i.bak -e '/Defaults.*requiretty/s/^/#/' /etc/sudoers
