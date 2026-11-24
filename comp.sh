#!/bin/bash
# Bash script to execute paper



project="competition"


#set -e  # exit on error

# Project name is root directory
echo "Batch file for project: ${project}..."


# directory structure
home="${research_home}/Papers/${project}"
stamp=$(date +%Y-%m-%d-%H-%M)


# clean junk
cd "${home}"


cd ./paper
rm -f *.log *.aux *.toc *.nav *.snm *.out *.txt *.gz *.bbl *.pdf *.blg *.vrb
cd ../output
rm -f *.log *.aux *.toc *.nav *.snm *.out *.txt *.gz *.bbl *.pdf *.blg *.vrb *smcl
rm -f ./word/*.rtf ./word/*.docx   # table numbers come from do/tables.do and can shift




# Execute Stata Scripts removing coded data file first
echo "Executing Stata scripts..."

cd ../data/coded
rm -f *.dta

cd ../../do


# Array of do-files in execution order
do_files=("raw" "code"  "first" )

for f in "${do_files[@]}"; do
    echo "Running ${f}.do"
    stata -e do "${f}.do"
    cat "${f}.log"
    rm -f "${f}.log"
    # display and remove auto gen log

done

# LaTeX
echo "Processing LaTeX"
cd ../paper
echo "${project}"




pdflatex  -interaction=batchmode "${project}.tex"
# note location of the aux file
bibtex "$project"

pdflatex  -interaction=batchmode "${project}.tex"
pdflatex  -interaction=batchmode "${project}.tex"

echo "LaTeX Done"

# put date on the pdf file
cp "${project}.pdf" "../archived_papers/${project}_${stamp}.pdf"

# clean junk again
rm -f *.log *.aux *.toc *.nav *.snm *.out *.txt *.gz *.bbl  *.blg *.vrb
#cd ../output  keep so i can check manually
#rm -f *.log *.aux *.toc *.nav *.snm *.out *.txt *.gz *.bbl *.pdf *.blg *.vrb * smcl
#cd ../do
#rm -f *.log *.aux *.toc *.nav *.snm *.out *.txt *.gz *.bbl *.pdf *.blg *.vrb *smcl

cd ..
