#!/bin/bash

HERE="$( cd "$(dirname "$0")" ; pwd -P )"

docker run \
  --rm \
  --interactive \
  --tty \
  --volume "$HERE:/doc/" \
  thomasweise/texlive \
  pdflatex.sh Towards_Development_Of_Sustainable_Data_Treatment_Software.tex
