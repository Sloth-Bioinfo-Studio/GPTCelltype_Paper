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
