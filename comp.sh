#!/bin/bash
# Bash script to execute paper



project="competition"


#set -e  # exit on error

# Project name is root directory
echo "Batch file for project: ${project}..."


# directory structure
home="${research_home}/Papers/${project}"
stamp=$(date +%Y-%m-%d-%H-%M)

cd "${home}"


# Execute Stata Scripts removing coded data file first
echo "Executing Stata scripts..."
cd ./do

do_files=("raw" "code"  "first" "ols") # Array of do-files in execution order

for f in "${do_files[@]}"; do
    echo "Running ${f}.do"
    stata -e do "${f}.do"
    cat "${f}.log"
    rm -f "${f}.log"
    # display and remove auto gen log

done

# LaTeX
echo "Processing LaTeX for ${project} "
cd ../paper

pdflatex  -interaction=batchmode "${project}.tex" # note location of the aux file
bibtex "$project"
pdflatex  -interaction=batchmode "${project}.tex"
pdflatex  -interaction=batchmode "${project}.tex"

echo "LaTeX Done"

# time stamp and archive the file
cp "${project}.pdf" "../archived_papers/${project}_${stamp}.pdf"

# clean junk 
rm -f *.log *.aux *.toc *.nav *.snm *.out *.txt *.gz *.bbl  *.blg *.vrb

cd ..