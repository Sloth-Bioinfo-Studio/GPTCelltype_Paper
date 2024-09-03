suppressMessages(library(celldex))
hpca.se <- HumanPrimaryCellAtlasData()
suppressMessages(library(SingleR))
# clu <- readRDS('/celltype/cancer/lungcancer/data/proc/ct.rds')
# d <- readRDS('/celltype/cancer/lungcancer/data/proc/norm.rds')

dir.create(snakemake@params[['path']])
clu <- readRDS(snakemake@input[['anno']])
d <- readRDS(snakemake@input[['norm']])

rt <- system.time({pred <- SingleR(test = d, ref = hpca.se, assay.type.test=1,labels = hpca.se$label.main)})

# saveRDS(pred,file='/celltype/cancer/lungcancer/SingleR/fullpred.rds')
# saveRDS(rt,file='/celltype/cancer/lungcancer/SingleR/time.rds')
saveRDS(pred,file=snakemake@output[['fullpred']])
saveRDS(rt,file=snakemake@output[['time']])

mat <- pred$scores
rownames(mat) <- pred@rownames
k <- rowsum(mat[names(clu),],clu)
predct <- colnames(k)[apply(k,1,which.max)]
orict <- rownames(k)
ct <- data.frame(orict=orict,predct=predct)

# saveRDS(ct,file='/celltype/cancer/lungcancer/SingleR/res.rds')
saveRDS(ct,file=snakemake@output[['res']])


