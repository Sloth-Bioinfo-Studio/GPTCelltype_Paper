library(data.table)
library(anndata)
library(openxlsx)

assignInNamespace("is_conda_python", function(x){ return(FALSE) }, ns="reticulate")

# 推测文件应当是`HCL_Fig1_cell_Info.xlsx`， 因此修改读取的部分
# a <- fread('/celltype/hcl/data/raw/anno.csv',data.table=F)
a <- read.xlsx(snakemake@input[['anno']], sheet = 1)

# d <- read_h5ad('/celltype/hcl/data/raw/HCL_Fig1_adata.h5ad')
d <- read_h5ad(snakemake@input[['h5ad']])
d <- t(d$X)
colnames(d) <- sub('-[0-9]$','',colnames(d))
dir.create(paste0(snakemake@params[['path']]))
saveRDS(d,snakemake@output[['count']])
d <- t(log2(t(d)/colSums(d)*10000+1))
rownames(a) <- a[,1]
a <- a[colnames(d),]
saveRDS(a,file=snakemake@output[['anno']])
saveRDS(d,file=snakemake@output[['norm']])

