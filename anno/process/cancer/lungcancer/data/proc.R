library(data.table)
# d <- fread('/celltype/cancer/lungcancer/data/raw/GSE131907_Lung_Cancer_cell_annotation.txt.gz',data.table=F)
d <- fread(snakemake@input[['metadata']],data.table=F)
ct <- d$Cell_type
ct[d$Cell_subtype=='Malignant cells'] <- 'Malignant cells'
names(ct) <- d[,1]
ct <- ct[ct!='Undetermined']
# m <- readRDS('/celltype/cancer/lungcancer/data/raw/GSE131907_Lung_Cancer_raw_UMI_matrix.rds')
m <- readRDS(snakemake@input[['count_mtx']])
m <- as.matrix(m)
m <- m[,names(ct)]
# n <- readRDS('/celltype/cancer/lungcancer/data/raw/GSE131907_Lung_Cancer_normalized_log2TPM_matrix.rds')
n <- readRDS(snakemake@input[['norm']])
n <- as.matrix(n)
n <- n[,names(ct)]
# saveRDS(ct,file='/celltype/cancer/lungcancer/data/proc/ct.rds')
# saveRDS(m,file='/celltype/cancer/lungcancer/data/proc/count.rds')
# saveRDS(n,file='/celltype/cancer/lungcancer/data/proc/norm.rds')

saveRDS(m,file=snakemake@output[['count_rds']])
saveRDS(ct,file=snakemake@output[['anno']])
saveRDS(n,file=snakemake@output[['norm']])
