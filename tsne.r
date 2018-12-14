#!/usr/bin/env Rscript


# Load libraries
library(Seurat)
library(dplyr)


# Get input from bash
args <- commandArgs()


# Load the dataset
load("temp/mm10gtn.rdata")
load("temp/mm10gtn.data.rdata")


# Filter cells after QC
mm10gtn <- FilterCells(object = mm10gtn, subset.names = c("nGene", "percent.mito"), low.thresholds = c(as.numeric(args[6]), as.numeric(args[7])), high.thresholds = c(as.numeric(args[8]), as.numeric(args[9])))


# Normalization
mm10gtn <- NormalizeData(object = mm10gtn, normalization.method = "LogNormalize", scale.factor = 10000)


# Identify variable genes with the setting in the tutorial. Do not plot
mm10gtn <- FindVariableGenes(object = mm10gtn, mean.function = ExpMean, dispersion.function = LogVMR, do.plot = FALSE, x.low.cutoff = 0.0125, x.high.cutoff = 3, y.cutoff = 0.5)


# Scale the data
mm10gtn <- ScaleData(object = mm10gtn, vars.to.regress = c("nUMI", "percent.mito"))


# PCA. Use the setting in the tutorial. Do not print
mm10gtn <- RunPCA(object = mm10gtn, pc.genes = mm10gtn@var.genes, do.print = FALSE, pcs.print = 1:5, genes.print = 5)


# Cluster. Use the setting in the tutorial
mm10gtn <- FindClusters(object = mm10gtn, reduction.type = "pca", dims.use = 1:10, resolution = 0.6, print.output = 0, save.SNN = TRUE)


# tSNE. Use the setting in the tutorial
mm10gtn <- RunTSNE(object = mm10gtn, dims.use = 1:10, do.fast = TRUE)
setwd("figures/")
pdf("tsne.pdf")
TSNEPlot(object = mm10gtn)