#!/bin/bash


# Directories
basedir=$(pwd)
raw=$basedir/raw
temp=$basedir/temp
figures=$basedir/figures


# Get raw data
# wget...
# Here, the data was copied into "$basedir/raw"
data_dir=$basedir/raw/mm10GTN


# QC
./qc.r "$data_dir"
# On Mac, "open" is used instead of "display"
open "$figures/qc.pdf"

# The remaining steps
echo "Input the cutoff threshold: nGene_min percent.mito_min nGene_max percent.mito_max"
read threshold
./tsne.r $threshold
open "$figures/tsne.pdf"