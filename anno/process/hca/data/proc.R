library(anndata)
library(Matrix)

# d <- read_h5ad('/celltype/hca/data/raw/GTEx_8_tissues_snRNAseq_atlas_071421.public_obs.h5ad')
d <- read_h5ad(snakemake@input[[1]])
x <- d$X
x <- t(x)
k <- d$obs
k <- k[k$Tissue!='Esophagus muscularis',] # 本数据集重并没有这个组织
x <- x[,rownames(k)]

n <- t(d$layers['counts'])
n <- n[,rownames(k)]

for (st in unique(k$Tissue)) {
	id <- which(k$Tissue==st)
	ct <- as.character(k[id,'Broad cell type'])
	names(ct) <- rownames(k[id,])
	sx <- x[,id]
	sn <- n[,id]
	st <- gsub(' ','_',st)
	# dir.create(paste0('/celltype/hca/data/proc/',st))
	# saveRDS(sx,file=paste0('/celltype/hca/data/proc/',st,'/norm.rds'))
	# saveRDS(sn,file=paste0('/celltype/hca/data/proc/',st,'/count.rds'))
	# saveRDS(ct,file=paste0('/celltype/hca/data/proc/',st,'/ct.rds'))
	dir.create(paste0(snakemake@params[[1]]))
	dir.create(paste0(snakemake@params[[1]],'/',st))
	saveRDS(sx,file=paste0(snakemake@output[[1]],'/',st,'/norm.rds'))
	saveRDS(sn,file=paste0(snakemake@output[[1]],'/',st,'/count.rds'))
	saveRDS(ct,file=paste0(snakemake@output[[1]],'/',st,'/ct.rds'))
}


