#!/bin/bash

HERE="$( cd "$(dirname "$0")" ; pwd -P )"

docker run \
  --rm \
  --interactive \
  --tty \
  --volume "$HERE:/doc/" \
  thomasweise/texlive \
  pdflatex.sh jnr_template.tex
