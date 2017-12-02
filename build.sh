#!/usr/bin/env bash

shopt -s globstar
set -e

COMPILER=xelatex
INTERACTION=batchmode
OUTDIR=dist
JOBNAME=presentation
ITERATIONS=3
LATEX_DEBUG=""
LATEX_NOTES=""

usage() { echo "Usage: $0 [-i <number> -g -v -t -n -b -j <string>]" 1>&2; exit 1; }

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

bibliography () {

	JOBNAME=bibliography
	INTERACTION=batchmode

	rm -f ${OUTDIR}/${JOBNAME}.pdf

	echo "Compiling bibliography into ${JOBNAME}.pdf ..."

	for j in `seq 1 2`;	
	do
		${COMPILER} \
			--interaction=${INTERACTION} \
			-output-directory=${OUTDIR} \
			-jobname=${JOBNAME} \
			bibliography.tex

		if [ "$j" == "1" ]
		then
			biber ${OUTDIR}/${JOBNAME}
		fi
	done

	rm -f ${OUTDIR}/${JOBNAME}*.{aux,log,out,xwm,toc,nav,snm,bbl,blg,vrb,bcf,xml}

	echo "Done."
}

while getopts "c:j:i:vgtnb" o; do
	case "${o}" in
		c)
			COMPILER=${OPTARG}
			;;
		b)
			bibliography
			exit 0
			;;
		g)
			DEBUG=true
			INTERACTION=nonstopmode
			;;
		v)
			VERBOSE=true
			;;
		j)
			JOBNAME=${OPTARG}
			;;
		n)
			NOTES=true
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

rm -f ${OUTDIR}/${JOBNAME}.*
mkdir -p ${OUTDIR}

log "Done."

if [ -n "${DEBUG}" ]; then
	LATEX_DEBUG="\def\debug{true}"
fi

if [ -n "${NOTES}" ]; then
	LATEX_NOTES="\def\generatenotes{true}"
fi

echo "Compiling the project into ${JOBNAME}.pdf ..."

for j in `seq 1 $ITERATIONS`;	
do
	${COMPILER} \
		--interaction=${INTERACTION} \
		-output-directory=${OUTDIR} \
		-jobname=${JOBNAME} \
		"${LATEX_NOTES}${LATEX_DEBUG}\input main.tex"

	if [ "$j" == "1" ]
	then
		biber ${OUTDIR}/${JOBNAME}
	fi
done

log "Done."

echo "Removing build files..."

rm -f ${OUTDIR}/${JOBNAME}*.{aux,log,out,xwm,toc,nav,snm,bbl,blg,vrb,bcf,xml}

log "Done."

exit 0
