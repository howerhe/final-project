#!/usr/bin/env Rscript


# Load libraries
library(Seurat)
library(dplyr)


# Get input from bash
args <- commandArgs()


# Load the dataset
mm10gtn.data <- Read10X(data.dir = args[6])
# Use the setting in the tutorial
mm10gtn <- CreateSeuratObject(raw.data = mm10gtn.data, min.cells = 3,min.genes = 200, project = "mm10GTN")


# QC with mitochondria genes
mito.genes <- grep(pattern = "^MT-", x = rownames(x = mm10gtn@data), value = TRUE)
percent.mito <- Matrix::colSums(mm10gtn@raw.data[mito.genes, ])/Matrix::colSums(mm10gtn@raw.data)
mm10gtn <- AddMetaData(object = mm10gtn, metadata = percent.mito, col.name = "percent.mito")


# Cache the data
save(mm10gtn, file = "temp/mm10gtn.rdata")
save(mm10gtn.data, file = "temp/mm10gtn.data.rdata")


# GenePlot
setwd("figures/")
pdf("qc.pdf")
par(mfrow = c(1, 2))
GenePlot(object = mm10gtn, gene1 = "nUMI", gene2 = "percent.mito")
GenePlot(object = mm10gtn, gene1 = "nUMI", gene2 = "nGene")