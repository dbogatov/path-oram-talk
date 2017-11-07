#!/usr/bin/env bash

shopt -s globstar
set -e

INTERACTION=nonstopmode
OUTDIR=dist
JOBNAME=presentation
ITERATIONS=3
LATEX_DEBUG=""

usage() { echo "Usage: $0 [-i <number> -g -v -t]" 1>&2; exit 1; }

log() {
	if [ -n "${VERBOSE}" ]; then 
		echo $1
	fi
}

test() {

	echo "Test chktex..."

	rm -f chktex.out
	chktex -eall -n22 -n30 -n3 -e16 -I0 -q -o chktex.out **/*.tex
	cat chktex.out
	if [ -s chktex.out ] ; then
		rm -f chktex.out
		exit 1
	fi

	rm -f chktex.out

	echo "Test cspell..."

	sed -e "s/cSpell\.//g" .vscode/settings.json > .vscode/cspell.json
	docker run -v $(PWD):/code dbogatov/docker-images:cspell-latest /usr/bin/cspell -c /code/.vscode/cspell.json /code/**/*.tex
	rm .vscode/cspell.json

	echo "Tests passed!"
}

while getopts "i:vgt" o; do
	case "${o}" in
		g)
			DEBUG=true
			;;
		v)
			VERBOSE=true
			;;
		i)
			ITERATIONS=${OPTARG}
			;;
		t)
			test
			exit 0
			;;
		*)
			usage
			;;
	esac
done
shift $((OPTIND-1))

log "DEBUG = ${DEBUG}"

echo "Cleaning up workspace"

rm -f ${OUTDIR}/${JOBNAME}.pdf
mkdir -p ${OUTDIR}

log "Done."

if [ -n "${DEBUG}" ]; then
	LATEX_DEBUG="\def\debug{true}"
fi

echo "Compiling the project into ${JOBNAME}.pdf ..."

for j in `seq 1 $ITERATIONS`;	
do
	xelatex \
		--interaction=${INTERACTION} \
		-output-directory=${OUTDIR} \
		-jobname=${JOBNAME} \
		main

	if [ "$j" == "1" ]
	then
		bibtex ${OUTDIR}/${JOBNAME}
	fi
done

log "Done."

echo "Removing build files..."

rm -f ${OUTDIR}/*.{aux,log,out,xwm,toc,nav,snm,bbl,blg}

log "Done."

exit 0
