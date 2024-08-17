# download data from source
# https://figshare.com/ndownloader/articles/5435866?private_link=865e694ad06d5857db4b

module hca:
    snakefile:
        # here, plain paths, URLs and the special markers for code hosting providers (see below) are possible.
        "rules/hca.smk"
    config: config

use rule * from hca as hca_*

rule all:
    input:
        'anno/process/hca/celltype.done'
        
storage:
    provider="http",
    allow_redirects=True


# rule unzip_hcl_data:
#     input:
#         'data/hcl.zip'
#     output:
#         h5ad = 'data/hcl/MCA1.1_adata.h5ad',
#         anno = 'data/hcl/annotation_rmbatch_data_revised417.zip',
#         deg_raw = 'data/hcl/dge_raw_data.tar.gz',
#         deg_rmbatch = 'data/hcl/dge_rmbatch_data.tar.gz',
#     params:
#         path = 'data/hcl'
#     shell:
#         '''
#         unzip -d {params.path} {input}
#         '''


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

