# download data from source
# https://figshare.com/ndownloader/articles/5435866?private_link=865e694ad06d5857db4b

storage:
    provider="http",
    allow_redirects=True

rule all:
    input:
        'anno/process/hca/celltype.done',
        'anno/process/hcl/celltype.done',
        'anno/process/cancer/bcl/celltype.done',
        'anno/process/mca/celltype.done',

        
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


module mca:
    snakefile:
        "rules/mca.smk"
    config: config

use rule * from mca as mca_*


module bcl:
    snakefile:
        "rules/bcl.smk"
    config: config

use rule * from bcl as bcl_*


