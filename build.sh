#!/bin/bash

HERE="$( cd "$(dirname "$0")" ; pwd -P )"

docker run \
  --rm \
  --interactive \
  --tty \
  --volume "$HERE:/doc/" \
  thomasweise/texlive \
  pdflatex.sh Standards_and_Guidelines_for_Developing_Data_Treatment_Software.tex
