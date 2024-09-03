library(data.table)
library(readxl)
# a <- fread('/celltype/mca/data/raw/celltype.csv',data.table=F)
# cl <- fread('/celltype/mca/data/raw/cluster.csv',data.table=F)
a <- read_excel(snakemake@input[['anno']], sheet = "MCA_Fig2_Celltype")
a <- as.data.frame(a)
cl <- fread(snakemake@input[['cluster']], data.table=F)
cl <- cl[,-1]

cl$celltype <- a[match(cl[,2],a[,1]),2]

# d <- fread('/celltype/mca/data/raw/Figure2-batch-removed.txt',data.table=F)
d <- fread(snakemake@input[['matrix']],data.table=F)
rownames(d) <- d[,1]
d <- as.matrix(d[,-1])
saveRDS(d,file=snakemake@output[['count_rds']])
d <- log2(t(t(d)/colSums(d)*10000)+1)
saveRDS(cl,file=snakemake@output[['anno']])
saveRDS(d,file=snakemake@output[['norm']])