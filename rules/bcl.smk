from glob import glob

storage:
    provider="http",
    allow_redirects=True


rule fetch_h5ad:
    input:
        h5ad = storage.http(
            'https://zenodo.org/records/7813151/files/scRNA_BCR_TCR.h5ad?download=1',
        ),
    output:
        'data/cancer/bcl/scRNA_BCR_TCR.h5ad'
    shell:
        '''
        mv {input} {output}
        '''


rule proc:
    input:
        h5ad = 'data/cancer/bcl/scRNA_BCR_TCR.h5ad',
    output:
        norm = 'data/cancer/bcl/proc/norm.rds',
        anno = 'data/cancer/bcl/proc/anno.rds',
        count_rds = 'data/cancer/bcl/proc/count.rds',
    params:
        path = 'data/cancer/bcl/proc',
    script:
        '../anno/process/cancer/bcl/data/proc.R'


rule singler:
    input:
        anno = 'data/bcl/proc/anno.rds',
        norm = 'data/bcl/proc/norm.rds'
    output:
        res = 'anno/process/cancer/bcl/SingleR/res/res.rds',
        fullpred = 'anno/process/cancer/bcl/SingleR/res/fullpred.rds',
        time = 'anno/process/cancer/bcl/SingleR/res/time.rds',
        done = touch('anno/process/cancer/bcl/SingleR/res/done'),
    params:
        path = 'anno/process/cancer/bcl/SingleR/res'
    script:
        '../anno/process/cancer/bcl/SingleR/run.R'


rule sctype:
    input:
        norm = 'data/bcl/proc/norm.rds',
        anno = 'data/bcl/proc/anno.rds',
        full = 'software/sctype/ScTypeDB_full.xlsx',
        script1 = 'software/sctype/gene_sets_prepare.R',
        script2 = 'software/sctype/sctype_score_.R',
    output:
        res = 'anno/process/cancer/bcl/sctype/res/res.rds',
        time = 'anno/process/cancer/bcl/sctype/res/time.rds',
        done = touch('anno/process/cancer/bcl/sctype/res/done'),
    params:
        path = 'anno/process/cancer/bcl/sctype/res'
    output:
    script:
        '../anno/process/cancer/bcl/sctype/run.R'


rule check_run:
    input:
        singler = 'anno/process/cancer/bcl/SingleR/res/done',
        sctype = 'anno/process/cancer/bcl/sctype/res/done',
    output:
        touch('anno/process/cancer/bcl/celltype.done')
    shell:
        '''
        echo 'Celltype run for bcl dataset done'
        '''