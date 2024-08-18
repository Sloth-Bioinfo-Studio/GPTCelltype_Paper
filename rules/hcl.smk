
rule unzip_data:
    input:
        'data/hcl.zip'
    output:
        h5ad = 'data/hcl/HCL_Fig1_adata.h5ad',
        anno = 'data/hcl/HCL_Fig1_cell_Info.xlsx',
    params:
        path = 'data/hcl'
    shell:
        '''
        unzip -d {params.path} {input}
        '''


rule proc:
    input:
        h5ad = 'data/hcl/HCL_Fig1_adata.h5ad',
        anno = 'data/hcl/HCL_Fig1_cell_Info.xlsx',
    output:
        norm = 'data/hcl/proc/norm.rds',
        anno = 'data/hcl/proc/anno.rds',
        count_rds = 'data/hcl/proc/count.rds',
    params:
        path = 'data/hcl/proc',
    script:
        '../anno/process/hcl/data/proc.R'


rule singler:
    input:
        anno = 'data/hcl/proc/anno.rds',
        norm = 'data/hcl/proc/norm.rds'
    output:
        res = 'anno/process/hcl/SingleR/res/res.rds',
        fullpred = 'anno/process/hcl/SingleR/res/fullpred.rds',
        time = 'anno/process/hcl/SingleR/res/time.rds',
        done = touch('anno/process/hcl/SingleR/res/done'),
    params:
        path = 'anno/process/hcl/SingleR/res'
    script:
        '../anno/process/hcl/SingleR/run.R'


rule sctype:
    input:
        norm = 'data/hcl/proc/norm.rds',
        anno = 'data/hcl/proc/anno.rds',
        full = 'software/sctype/ScTypeDB_full.xlsx',
        script1 = 'software/sctype/gene_sets_prepare.R',
        script2 = 'software/sctype/sctype_score_.R',
    output:
        res = 'anno/process/hcl/sctype/res/res.rds',
        time = 'anno/process/hcl/sctype/res/time.rds',
        done = touch('anno/process/hcl/sctype/res/done'),
    params:
        path = 'anno/process/hcl/sctype/res'
    output:
    script:
        '../anno/process/hcl/sctype/run.R'


rule check_run:
    input:
        singler = 'anno/process/hcl/SingleR/res/done',
        sctype = 'anno/process/hcl/sctype/res/done',
    output:
        touch('anno/process/hcl/celltype.done')
    shell:
        '''
        echo 'Celltype run for hcl dataset done'
        '''