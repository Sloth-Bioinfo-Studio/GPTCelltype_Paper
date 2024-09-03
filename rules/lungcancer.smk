from glob import glob

storage:
    provider="http",
    allow_redirects=True


rule fetch_metadata:
    input:
        storage.http(
            'https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE131907&format=file&file=GSE131907%5FLung%5FCancer%5Fcell%5Fannotation%2Etxt%2Egz',
        ),
    output:
        'data/cancer/lungcancer/GSE131907_Lung_Cancer_cell_annotation.txt'
    shell:
        '''
         gzip -dc {input} > {output}
        '''


rule fetch_count:
    input:
        storage.http(
            'https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE131907&format=file&file=GSE131907%5FLung%5FCancer%5Fraw%5FUMI%5Fmatrix%2Erds%2Egz',
        ),
    output:
        'data/cancer/lungcancer/GSE131907_Lung_Cancer_raw_UMI_matrix.rds'
    shell:
        '''
        gzip -dc {input} > {output}
        '''


rule fetch_norm:
    input:
        storage.http(
            'https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE131907&format=file&file=GSE131907%5FLung%5FCancer%5Fnormalized%5Flog2TPM%5Fmatrix%2Erds%2Egz',
        ),
    output:
        'data/cancer/lungcancer/GSE131907_Lung_Cancer_normalized_log2TPM_matrix.rds'
    shell:
        '''
        gzip -dc {input} > {output}
        '''


rule proc:
    input:
        metadata = 'data/cancer/lungcancer/GSE131907_Lung_Cancer_cell_annotation.txt',
        count_mtx = 'data/cancer/lungcancer/GSE131907_Lung_Cancer_raw_UMI_matrix.rds',
        norm = 'data/cancer/lungcancer/GSE131907_Lung_Cancer_normalized_log2TPM_matrix.rds',
    output:
        norm = 'data/cancer/lungcancer/proc/norm.rds',
        anno = 'data/cancer/lungcancer/proc/anno.rds',
        count_rds = 'data/cancer/lungcancer/proc/count.rds',
    script:
        '../anno/process/cancer/lungcancer/data/proc.R'


rule singler:
    input:
        anno = 'data/cancer/lungcancer/proc/anno.rds',
        norm = 'data/cancer/lungcancer/proc/norm.rds'
    output:
        res = 'anno/process/cancer/lungcancer/SingleR/res/res.rds',
        fullpred = 'anno/process/cancer/lungcancer/SingleR/res/fullpred.rds',
        time = 'anno/process/cancer/lungcancer/SingleR/res/time.rds',
        done = touch('anno/process/cancer/lungcancer/SingleR/res/done'),
    params:
        path = 'anno/process/cancer/lungcancer/SingleR/res'
    script:
        '../anno/process/cancer/lungcancer/SingleR/run.R'


rule sctype:
    input:
        norm = 'data/cancer/lungcancer/proc/norm.rds',
        anno = 'data/cancer/lungcancer/proc/anno.rds',
        full = 'software/sctype/ScTypeDB_full.xlsx',
        script1 = 'software/sctype/gene_sets_prepare.R',
        script2 = 'software/sctype/sctype_score_.R',
    output:
        res = 'anno/process/cancer/lungcancer/sctype/res/res.rds',
        time = 'anno/process/cancer/lungcancer/sctype/res/time.rds',
        done = touch('anno/process/cancer/lungcancer/sctype/res/done'),
    params:
        path = 'anno/process/cancer/lungcancer/sctype/res'
    output:
    script:
        '../anno/process/cancer/lungcancer/sctype/run.R'


rule check_run:
    input:
        singler = 'anno/process/cancer/lungcancer/SingleR/res/done',
        sctype = 'anno/process/cancer/lungcancer/sctype/res/done',
    output:
        touch('anno/process/cancer/lungcancer/celltype.done')
    shell:
        '''
        echo 'Celltype run for lungcancer dataset done'
        '''