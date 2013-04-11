#!/usr/bin/env bash
# ================================================================================
# A git-diftool utility for a TeX file using `latexdiff`.
#
#
# Usage
# -----
#   git latexdiff [<commit>]
#   git latexdiff --cached [<commit>]
#
#
# Installation
# ------------
# Configure ~/.gitconfig as the follwing::
#
#   [difftool.latex]
#       cmd = git-latexdiff.sh "$LOCAL" "$REMOTE"
#   [difftool]
#       prompt = false
#   [alias]
#       ...
#       latexdiff = difftool -t latex
#
#
# Requirements
# ------------
# This program requires latexdiff installed.
#
#
# Notes
# -----
# * CAUTION! This script can not handle a document consisting of multiple TeX
#   files.
# * On Mac OS X, it create a new instance of Skim.app and wait until the
#   instance quits.
#
# ================================================================================
\unalias -a
hash -r

PrintError() {
  printf "$@"
} >&2


# Set up a user configuration here.
LATEX=pdflatex
BIBTEX=bibtex
case $(uname -s) in
    Linux)
        VIEWER=evince ;;
    Darwin)
        # Create a new instance of Skim.app and wait until the instance quits.
        VIEWER="open -n -W -a Skim.app" ;;
esac
# Set LaTeX options.
LATEXOPTS="-src-specials -parse-first-line"


# Return -1 and die *silentlly* if no change has been made to the TeX file.
[ ${1##*.} != "tex" -o ${2##*.} != "tex" ] && exit 1

# Create the temporary directory.
TMPDIR=$(mktemp -d /tmp/git-latexdiff.XXXXXXXX)
PREFIX=$(mktemp diff.XXXXXX)
status=$?
if [[ -z "$TMPDIR" ]]; then
    PrintError "Failed to create temporary directory.\n"
    exit $status
fi
LATEXOPTS=$LATEXOPTS" -output-directory $TMPDIR"

# Set a trap for cleaning up the temporary directory.
trap 'rm -fr $TMPDIR $PREFIX*' ABRT EXIT HUP INT QUIT

# Run `latexdiff`.
latexdiff "$1" "$2" >$TMPDIR/$PREFIX.tex
status=$?
if [[ ! $status ]]; then
    PrintError "\`latexdiff\` failed.\n"
    exit $status
fi

# Make sure that cross-references are all right.
{
    $LATEX $LATEXOPTS $TMPDIR/$PREFIX.tex
    # Move diff.aux to the current directory and run `bibtex`, and then move
    # the resultant files and diff.aux back to $TMPDIR.  As of August 2011,
    # `bibtex` installed via MacPorts does not allow to process *.aux not
    # located in the current directory.
    #
    mv $TMPDIR/$PREFIX.aux .
    $BIBTEX $PREFIX
    mv $PREFIX* $TMPDIR
    $LATEX $LATEXOPTS $TMPDIR/$PREFIX.tex
    $LATEX $LATEXOPTS $TMPDIR/$PREFIX.tex
} >/dev/null

# Launch the viewer.
$VIEWER $TMPDIR/$PREFIX.pdf


# vim: ft=sh sw=4
