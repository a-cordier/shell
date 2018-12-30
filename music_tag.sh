#!/bin/bash
## This script will add some usefull tags to files 
## using metaflac if file has a flac extension
## using mid3v2 if file has a mp3 extension

parse_arguments() {
  while getopts a:c:g: option
  do
    case "${option}" in
      a) ARTIST=${OPTARG};;
      c) ALBUM_ARTIST=${OPTARG};; # stands for compiler ie and artist that setted up a mix or a compilation of tracks
      g) GENRE=${OPTARG};;
    esac
  done

  shift "$((OPTIND - 1))"
  FILE=$1
  if [ -z "$FILE" ]; then 
    echo "File name is missing";
    exit 1;
  fi
}

tag_flac() {
  cmd="metaflac"  
  if [ -n "$ARTIST" ]; then cmd="${cmd} --remove-tag ARTIST --set-tag ARTIST=${ARTIST}"; fi
  if [ -n "$GENRE" ]; then cmd="${cmd} --remove-tag GENRE --set-tag GENRE=${GENRE}"; fi
  if [ -n "$ALBUM_ARTIST" ]; then cmd="${cmd} --remove-tag ALBUM_ARTIST --set-tag ALBUM_ARTIST=${ALBUM_ARTIST}"; fi
  echo "Running $cmd $FILE"
  $($cmd "$FILE")
}

tag_mp3() {
  cmd="mid3v2"
  if [ -n "$ARTIST" ]; then cmd="${cmd} -a ${ARTIST}"; fi
  if [ -n "$GENRE" ]; then cmd="${cmd} -g ${GENRE}"; fi
  if [ -n "$ALBUM_ARTIST" ]; then cmd="${cmd} --TPE2 ${ALBUM_ARTIST}"; fi
  echo "Running $cmd $FILE"
  $($cmd "$FILE")
}

main() {
  parse_arguments "$@"
  if [[ "$FILE" == *.flac ]]; then
    echo "Editing tags: assuming FLAC file"
    tag_flac
  fi

  if [[ "$FILE" == *.mp3 ]]; then
    echo "Editng tags: assuming mmp3 file"
    tag_mp3
  fi
}

main "$@"

