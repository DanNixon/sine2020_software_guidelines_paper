#!/bin/bash

HERE="$( cd "$(dirname "$0")" ; pwd -P )"

docker run \
  --rm \
  --interactive \
  --tty \
  --volume "$HERE:/doc/" \
  thomasweise/texlive \
  pdflatex.sh \
  guidelines_for_collaborative_development_of_sustainable_data_treatment_software.tex
