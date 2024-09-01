rule unzip_data:
    input:
        'data/mca.zip'
    output:
        matrix = 'data/cancer/mca/Figure2-batch-removed.txt',
        anno = 'data/cancer/mca/MCA_Figure2_Cell.Info.xlsx',
        cluster = 'data/cancer/mca/MCA_BatchRemoved_Merge_dge_cellinfo.csv',
    params:
        path = 'data/cancer/mca',
        tar = 'data/cancer/mca/MCA_Figure2-batch-removed.txt.tar.gz'
    shell:
        '''
        mkdir -p {params.path}
        unzip -o -d {params.path} {input}
        tar --overwrite -xvf {params.tar} -C {params.path}
        '''


rule proc:
    input:
        matrix = 'data/cancer/mca/Figure2-batch-removed.txt',
        anno = 'data/cancer/mca/MCA_Figure2_Cell.Info.xlsx',
        cluster = 'data/cancer/mca/MCA_BatchRemoved_Merge_dge_cellinfo.csv',
    output:
        norm = 'data/cancer/mca/proc/norm.rds',
        anno = 'data/cancer/mca/proc/anno.rds',
        count_rds = 'data/cancer/mca/proc/count.rds',
    params:
        path = 'data/cancer/mca/proc',
    script:
        '../anno/process/mca/data/proc.R'


rule singler:
    input:
        anno = 'data/cancer/mca/proc/anno.rds',
        norm = 'data/cancer/mca/proc/norm.rds'
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
        norm = 'data/cancer/mca/proc/norm.rds',
        anno = 'data/cancer/mca/proc/anno.rds',
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