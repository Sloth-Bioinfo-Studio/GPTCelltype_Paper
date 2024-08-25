rule unzip_data:
    input:
        'data/mca.zip'
    output:
        matrix = 'data/mca/MCA_Figure2-batch-removed.txt',
        anno = 'data/mca/MCA_Figure2_Cell.Info.xlsx',
        cluster = 'data/mca/MCA_BatchRemoved_Merge_dge_cellinfo.csv',
    params:
        path = 'data/mca',
        tar = 'data/mca/MCA_Figure2-batch-removed.txt.tar.gz'
    shell:
        '''
        mkdir -p {params.path}
        unzip -d {params.path} {input}
        tar xvf {params.tar} -C {params.path}
        '''


rule proc:
    input:
        matrix = 'data/mca/MCA_Figure2-batch-removed.txt',
        anno = 'data/mca/MCA_Figure2_Cell.Info.xlsx',
        cluster = 'data/mca/MCA_BatchRemoved_Merge_dge_cellinfo.csv',
    output:
        norm = 'data/mca/proc/norm.rds',
        anno = 'data/mca/proc/anno.rds',
        count_rds = 'data/mca/proc/count.rds',
    params:
        path = 'data/mca/proc',
    script:
        '../anno/process/mca/data/proc.R'


rule singler:
    input:
        anno = 'data/mca/proc/anno.rds',
        norm = 'data/mca/proc/norm.rds'
    output:
        res = 'anno/process/cancer/mca/SingleR/res/res.rds',
        fullpred = 'anno/process/cancer/mca/SingleR/res/fullpred.rds',
        time = 'anno/process/cancer/mca/SingleR/res/time.rds',
        done = touch('anno/process/cancer/mca/SingleR/res/done'),
    params:
        path = 'anno/process/cancer/mca/SingleR/res'
    script:
        '../anno/process/cancer/mca/SingleR/run.R'


rule sctype:
    input:
        norm = 'data/mca/proc/norm.rds',
        anno = 'data/mca/proc/anno.rds',
        full = 'software/sctype/ScTypeDB_full.xlsx',
        script1 = 'software/sctype/gene_sets_prepare.R',
        script2 = 'software/sctype/sctype_score_.R',
    output:
        res = 'anno/process/cancer/mca/sctype/res/res.rds',
        time = 'anno/process/cancer/mca/sctype/res/time.rds',
        done = touch('anno/process/cancer/mca/sctype/res/done'),
    params:
        path = 'anno/process/cancer/mca/sctype/res'
    output:
    script:
        '../anno/process/cancer/mca/sctype/run.R'


rule check_run:
    input:
        singler = 'anno/process/cancer/mca/SingleR/res/done',
        sctype = 'anno/process/cancer/mca/sctype/res/done',
    output:
        touch('anno/process/cancer/mca/celltype.done')
    shell:
        '''
        echo 'Celltype run for mca dataset done'
        '''