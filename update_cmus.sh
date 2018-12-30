#!/bin/bash
## This script updates the cmus library to be in sync with my music folder

cmus-remote -C clear
cmus-remote -C "add /media/acordier/Music"
cmus-remote -C "update-cache -f"
