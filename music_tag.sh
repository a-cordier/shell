#!/bin/bash
#title           : music_tag.sh
#description     : This script will add some usefull tags to music files (mp3 and flac)
#author		       : acordier
#usage		       : bash music_tag.sh -g Techno -a Plastikman -A Consumer *
#notes           : To run in cmus: run music_tag.sh -g Techno -a Plastikman -A Consumer {}
#==============================================================================


tag_flac() {
  cmd="metaflac"  
  if [ -n "$ARTIST" ]; then cmd="${cmd} --remove-tag ARTIST --set-tag ARTIST=$(printf '%q' $ARTIST)"; fi
  if [ -n "$GENRE" ]; then cmd="${cmd} --remove-tag GENRE --set-tag GENRE=$(printf '%q' $GENRE)"; fi
  if [ -n "$ALBUM_ARTIST" ]; then cmd="${cmd} --remove-tag ALBUM_ARTIST --set-tag ALBUM_ARTIST=$(printf '%q' $ALBUM_ARTIST)"; fi
  if [ -n "$ALBUM" ]; then cmd="${cmd} --remove-tag ALBUM --set-tag ALBUM=$(printf '%q' $ALBUM)"; fi
  echo "Running $cmd $1"
  eval "$cmd $(printf '%q' $1)"
}

tag_mp3() {
  cmd="mid3v2"
  if [ -n "$ARTIST" ]; then cmd="${cmd} -a $(printf '%q' $ARTIST)"; fi
  if [ -n "$GENRE" ]; then cmd="${cmd} -g $(printf '%q' $GENRE)"; fi
  if [ -n "$ALBUM_ARTIST" ]; then cmd="${cmd} --TPE2 $(printf '%q' $ALBUM_ARTIST)"; fi
  if [ -n "$ALBUM" ]; then cmd="${cmd} -A $(printf '%q' $ALBUM)"; fi
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
  while getopts A:a:c:g: option
  do
    case "${option}" in
      a) ARTIST=${OPTARG};;
      c) ALBUM_ARTIST=${OPTARG};; # stands for compiler ie and artist that setted up a mix or a compilation of tracks
      g) GENRE=${OPTARG};;
      A) ALBUM=${OPTARG};;
    esac
  done

  shift "$((OPTIND - 1))"
  
  ((!$#)) && echo "File name is required"
  
  OLD_IFS=$IFS; IFS=$'\n'
  for file in $@; do tag_file "$file"; done
  IFS=$OLD_IFS
}

main "$@"

