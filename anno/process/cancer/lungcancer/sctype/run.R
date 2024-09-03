scalematrix <- function(data) {
	cm <- rowMeans(data)
	csd <- sqrt((rowMeans(data*data) - cm^2) / (ncol(data) - 1) * ncol(data))
	(data - cm) / csd
}

lapply(c("dplyr","Seurat","HGNChelper","openxlsx"), library, character.only = T)
# source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R"); source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R")

# source('/celltype/software/sctype/sctype_score.R')
source(snakemake@input[['script1']])
source(snakemake@input[['script2']])
source('software/sctype/sctype_score.R')

# a <- readRDS('/celltype/cancer/lungcancer/data/proc/ct.rds')
# d <- readRDS('/celltype/cancer/lungcancer/data/proc/norm.rds')
a <- readRDS(snakemake@input[['anno']])
d <- readRDS(snakemake@input[['norm']])

d <- scalematrix(d)

# get cell-type-specific gene sets from our in-built database (DB)
# gs_list = gene_sets_prepare("/celltype/software/sctype/ScTypeDB_full.xlsx", "All") # e.g. Immune system, Liver, Pancreas, Kidney, Eye, Brain
gs_list = gene_sets_prepare(snakemake@input[['full']], "All") # e.g. Immune system, Liver, Pancreas, Kidney, Eye, Brain

rt <- system.time({
	es.max = sctype_score(scRNAseqData = d, scaled = TRUE, gs = gs_list$gs_positive, gs2 = gs_list$gs_negative)
	clu <- a[colnames(d)]
	ss <- rowsum(t(es.max),clu)
	ct <- colnames(ss)[apply(ss,1,which.max)]
	ct <- data.frame(orict=rownames(ss),predct=ct)
})

# saveRDS(rt,file='/celltype/cancer/lungcancer/sctype/time.rds')
# saveRDS(ct,file='/celltype/cancer/lungcancer/sctype/res.rds')
saveRDS(rt,snakemake@output[['time']])
saveRDS(ct,snakemake@output[['res']])
# k <- unique(a[,c('cluster','celltype')])
# res <- cbind(ct,k[match(as.numeric(rownames(ss)),k[,1]),2])




