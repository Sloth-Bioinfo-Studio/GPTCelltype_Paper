from glob import glob

storage:
    provider="http",
    allow_redirects=True


rule fetch_h5ad:
    input:
        h5ad = storage.http(
            'https://storage.googleapis.com/adult-gtex/single-cell/v9/snrna-seq-data/GTEx_8_tissues_snRNAseq_atlas_071421.public_obs.h5ad',
        ),
    output:
        'data/hca/GTEx_8_tissues_snRNAseq_atlas_071421.public_obs.h5ad'
    shell:
        '''
        mv {input} {output}
        '''

# rule fetch_gtex_supp:
#     input:
#         supp = storage.http(
#             'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9383269/bin/NIHMS1828607-supplement-Supplementary_Tables.zip',
#         ),
#     output:
#         supp = 'NIHMS1828607-supplement-Supplementary_Tables.zip'

# 这个步骤实际上将数据集按照tissue进行了拆分
checkpoint proc:
    input:
        'data/hca/GTEx_8_tissues_snRNAseq_atlas_071421.public_obs.h5ad'
    output:
        directory('data/hca/proc')
    script:
        '../anno/process/hca/data/proc.R'


rule singler:
    input:
        norm = 'data/hca/proc/{tissue}/norm.rds',
        ct = 'data/hca/proc/{tissue}/ct.rds'
    output:
        res = 'anno/process/hca/SingleR/res/{tissue}/res.rds',
        fullpred = 'anno/process/hca/SingleR/res/{tissue}/fullpred.rds',
        time = 'anno/process/hca/SingleR/res/{tissue}/time.rds',
        done = touch('anno/process/hca/SingleR/res/{tissue}/done'),
    params:
        path = 'anno/process/hca/SingleR/res/{tissue}'
    script:
        '../anno/process/hca/SingleR/run.R'


rule sctype:
    input:
        norm = 'data/hca/proc/{tissue}/norm.rds',
        ct = 'data/hca/proc/{tissue}/ct.rds',
        full = 'software/sctype/ScTypeDB_full.xlsx',
        script1 = 'software/sctype/gene_sets_prepare.R',
        script2 = 'software/sctype/sctype_score_.R',
    output:
        res = 'anno/process/hca/sctype/res/{tissue}/res.rds',
        time = 'anno/process/hca/sctype/res/{tissue}/time.rds',
        done = touch('anno/process/hca/sctype/res/{tissue}/done'),
    params:
        path = 'anno/process/hca/sctype/res/{tissue}'
    output:
    script:
        '../anno/process/hca/sctype/run.R'


def get_input(wc):
    oPath = checkpoints.proc.get(**wc).output[0]
    tags = [p.split('/')[-1] for p in glob(f'{oPath}/*')]
    return expand('anno/process/hca/{soft}/res/{tissue}/done', tissue=tags, soft=['SingleR', 'sctype'])


rule check_run:
    input:
        get_input
    output:
        touch('anno/process/hca/celltype.done')
    shell:
        '''
        echo 'Celltype run for hca dataset done'
        '''