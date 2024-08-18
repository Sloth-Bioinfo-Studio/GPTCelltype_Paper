suppressMessages(library(celldex))
hpca.se <- HumanPrimaryCellAtlasData()
suppressMessages(library(SingleR))
# clu <- readRDS('/celltype/hcl/data/proc/anno.rds')
clu <- readRDS(snakemake@input[['anno']])
cn <- clu[,1]
clu <- clu$celltype
names(clu) <- cn
# d <- readRDS('/celltype/hcl/data/proc/norm.rds')
d <- readRDS(snakemake@input[['norm']])
rt <- system.time({pred <- SingleR(test = d, ref = hpca.se, assay.type.test=1,labels = hpca.se$label.main)})
# saveRDS(pred,file='/celltype/hcl/SingleR/fullpred.rds')
# saveRDS(rt,file='/celltype/hcl/SingleR/time.rds')
saveRDS(pred,file=snakemake@output[['fullpred']])
saveRDS(rt,file=snakemake@output[['time']])
mat <- pred$scores
rownames(mat) <- pred@rownames
k <- rowsum(mat[names(clu),],clu)
predct <- colnames(k)[apply(k,1,which.max)]
orict <- rownames(k)
ct <- data.frame(orict=orict,predct=predct)
# saveRDS(ct,file='/celltype/hcl/SingleR/res.rds')
saveRDS(ct,file=snakemake@output[['res']])
