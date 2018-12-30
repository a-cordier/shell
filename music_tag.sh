#!/bin/bash
## This script will add some usefull tags to files 
## using metaflac if file has a flac extension
## using mid3v2 if file has a mp3 extension


tag_flac() {
  cmd="metaflac"  
  if [ -n "$ARTIST" ]; then cmd="${cmd} --remove-tag ARTIST --set-tag ARTIST=${ARTIST}"; fi
  if [ -n "$GENRE" ]; then cmd="${cmd} --remove-tag GENRE --set-tag GENRE=${GENRE}"; fi
  if [ -n "$ALBUM_ARTIST" ]; then cmd="${cmd} --remove-tag ALBUM_ARTIST --set-tag ALBUM_ARTIST=${ALBUM_ARTIST}"; fi
  echo "Running $cmd $1"
  eval "$cmd $(printf '%q' $1)"
}

tag_mp3() {
  cmd="mid3v2"
  if [ -n "$ARTIST" ]; then cmd="${cmd} -a ${ARTIST}"; fi
  if [ -n "$GENRE" ]; then cmd="${cmd} -g ${GENRE}"; fi
  if [ -n "$ALBUM_ARTIST" ]; then cmd="${cmd} --TPE2 ${ALBUM_ARTIST}"; fi
  echo "Running $cmd $1"
  eval "$cmd $(printf '%q' $1)"
}

tag_file() {
  if [[ "$1" == *.flac ]]; then
    echo "Editing tags (assuming FLAC file from extension)"
    tag_flac "$1"
  fi

  if [[ "$1" == *.mp3 ]]; then
    echo "Editing tags (assuming mp3 file from extension)"
    tag_mp3 "$1"
  fi
}

main() {
  while getopts a:c:g: option
  do
    case "${option}" in
      a) ARTIST=${OPTARG};;
      c) ALBUM_ARTIST=${OPTARG};; # stands for compiler ie and artist that setted up a mix or a compilation of tracks
      g) GENRE=${OPTARG};;
    esac
  done

  shift "$((OPTIND - 1))"
  
  ((!$#)) && echo "File name is required"
  
  OLD_IFS=$IFS
  IFS=$'\n'
  for file in $@; do tag_file "$file"; done
  IFS=$OLD_IFS
}

main "$@"

