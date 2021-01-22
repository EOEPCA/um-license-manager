#!/usr/bin/env bash

ORIG_DIR="$(pwd)"
cd "$(dirname "$0")"
BIN_DIR="$(pwd)"

trap "cd '${ORIG_DIR}';" EXIT

# Work in the docs/ directory
cd "${BIN_DIR}/.."

# Deduce the name of the repository
if [ -z "${GH_REPOS_NAME}" ]
then
  export GH_REPOS_NAME="$(basename $(dirname $PWD))"
fi

# Clone the 'gh-pages' branch
git clone --branch gh-pages --single-branch "git@github.com:AlvaroVillanueva/EOEPCA/${GH_REPOS_NAME}" repos

for doc in SDD ICD; do
	# Check the output directory exists
	if [ ! -d "$doc/output" ]
		then
		  echo "ERROR: output directory is missing, generate-docs must be run first" >&2
		exit 1
	fi
	cd repos/$doc
	rm -rf current
	mv ../../$doc/output current
	mv current/index.pdf current/EOEPCA-${GH_REPOS_NAME}.pdf

	# Prepare the root landing page/README - but don't overwrite if they already exist
	#if [ ! -e index.html ]; then cp ../gh-page-root.html index.html; fi
	#if [ ! -e README.adoc ]; then cp ../gh-page-README.adoc README.adoc; fi
	cd ${BIN_DIR}/..

done

cd repos
# Config git profile for commits
export GH_USER_NAME="AlvaroVillanueva"
export GH_USER_EMAIL="alvaro.villanueva@deimos-space.com"
export GH_TOKEN="186205d4a6447b858fb673ed1a697166423dd373"
if [ -n "${GH_USER_NAME}" ]; then git config --global user.name "${GH_USER_NAME}"; fi
if [ -n "${GH_USER_EMAIL}" ]; then git config --global user.email "${GH_USER_EMAIL}"; fi

# Commit the newly generated docs, and push to upstream
git add . ; git commit -m "Deploy to GitHub Pages @ $(date -u)"
git push
