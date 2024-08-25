# download data from source
# https://figshare.com/ndownloader/articles/5435866?private_link=865e694ad06d5857db4b

storage:
    provider="http",
    allow_redirects=True

rule all:
    input:
        'anno/process/hca/celltype.done',
        'anno/process/hcl/celltype.done'

        
rule fetch_sctype_script:
    input:
        script1 = storage.http(
            'https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R',
        ),
        script2 = storage.http(
            'https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R',
        ),
    output:
        script1 = 'software/sctype/gene_sets_prepare.R',
        script2 = 'software/sctype/sctype_score_.R',
    shell:
        '''
        mv {input.script1} {output.script1}
        mv {input.script2} {output.script2}
        '''


# rule unzip_mca_data:
#     input:
#         'data/mca.zip'
#     output:
#         h5ad = 'data/mca/MCA_BatchRemoved_Merge_dge.h5ad',
#         anno = 'dta/mca/MCA_CellAssignments.csv',
#         deg = 'data/mca/MCA_BatchRemove_dge.zip'
#     params:
#         path = 'data/mca'
#     shell:
#         '''
#         unzip -d {params.path} {input}
#         '''

# rule fetch_bcl_data:
#     input:
#         storage.http(
#             'https://zenodo.org/records/7813151/files/scRNA_BCR_TCR.h5ad?download=1',
#         ),
#     output:
#         'data/bcl/scRNA_BCR_TCR.h5ad'


# rule fetch_gtex_h5ad:
#     input:
#         h5ad = storage.http(
#             'https://storage.googleapis.com/adult-gtex/single-cell/v9/snrna-seq-data/GTEx_8_tissues_snRNAseq_atlas_071421.public_obs.h5ad',
#         ),
#     output:
#         ''

module hca:
    snakefile:
        "rules/hca.smk"
    config: config

use rule * from hca as hca_*

module hcl:
    snakefile:
        "rules/hcl.smk"
    config: config

use rule * from hcl as hcl_*