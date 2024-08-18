start with raw annotation and cell types
1. first generate cl, manually annotate, and repopulate back
2. then do agreement, manually annotate, and repopulate back
3. each time when update cl and agreement, check if already done

## Abstract

```bash
anno
    ├── cl
    │   ├── compiled.csv
    │   ├── generate.R
    │   └── relation.csv
    ├── code
    │   ├── all.R
    │   ├── gpt4topgenenumber.R
    │   ├── makegptother.R
    │   └── makegpttabulasapiens.R
    ├── compiled
    │   ├── all.csv
    │   └── gpt4topgenenumber.csv
    ├── process
    │   ├── agg
    │   │   ├── cancertemplate.R
    │   │   ├── sctype.R
    │   │   └── SingleR.R
    │   ├── cancer
    │   │   ├── bcl
    │   │   │   ├── data
    │   │   │   │   └── proc.R
    │   │   │   ├── diff
    │   │   │   │   └── diff.R
    │   │   │   ├── sctype
    │   │   │   │   └── run.R
    │   │   │   └── SingleR
    │   │   │       └── run.R
    │   │   ├── coloncancer
    │   │   │   ├── data
    │   │   │   │   └── proc.R
    │   │   │   ├── diff
    │   │   │   │   └── diff.R
    │   │   │   ├── sctype
    │   │   │   │   └── run.R
    │   │   │   └── SingleR
    │   │   │       └── run.R
    │   │   └── lungcancer
    │   │       ├── data
    │   │       │   └── proc.R
    │   │       ├── diff
    │   │       │   └── diff.R
    │   │       ├── sctype
    │   │       │   └── run.R
    │   │       └── SingleR
    │   │           └── run.R
    │   ├── hca
    │   │   ├── data
    │   │   │   └── proc.R
    │   │   ├── sctype
    │   │   │   └── run.R
    │   │   └── SingleR
    │   │       └── run.R
    │   ├── hcl
    │   │   ├── data
    │   │   │   └── proc.R
    │   │   ├── sctype
    │   │   │   └── run.R
    │   │   └── SingleR
    │   │       └── run.R
    │   ├── mca
    │   │   ├── data
    │   │   │   └── proc.R
    │   │   ├── sctype
    │   │   │   └── run.R
    │   │   └── SingleR
    │   │       └── run.R
    │   ├── numcell
    │   │   └── make.R
    │   ├── stromal
    │   │   ├── combineexpr.R
    │   │   └── expr.R
    │   └── tabulasapiens
    │       ├── data
    │       │   └── code
    │       │       ├── count.R
    │       │       └── norm.R
    │       ├── diff
    │       │   └── code
    │       │       └── run.R
    │       ├── sctype
    │       │   └── code
    │       │       └── run.R
    │       ├── SingleR
    │       │   └── code
    │       │       └── run.R
    │       └── template
    │           ├── make.R
    │           └── template.csv
    ├── README
    └── subtype
        ├── list.csv
        └── make.R
```

## Structure

- cl: 看上去是信息整合的表
- code:
- compiled: 可能是这部分的结果文件
- process: 原始数据处理部分, 
    + agg: 7个数据集结果汇总(SingleR和sctype, ？)
    + numcell: 将所有数据集中的metadata汇总？
    + stromal: 汇总所有表达矩阵
    + mca(1 dataset): MCA single cell DGE data数据集的处理脚本
    + hcl(1 dataset): HCL DGE Data数据集的处理脚本
    + hca(1 dataset): 对应GTEx数据集中的单细胞数据
    + cancer(3 dataset): 癌症数据, 包括一个来自zendo的数据集，两个来自GSE的数据集
    + tabulasapiens(1 dataset): UCSC Cell 数据库下的tabula-sapiens数据集
- 似乎缺少了HubMap的处理内容？

## Depencency

- 使用pixi准备了运行环境
- 使用的工具均为R包, 主要内容包括`SingleR`, `rols`, `Seurat`, `sctype`

## Content

### cl

- input:
    + `anno/compiled/gpt4topgenenumber.csv`
    + `anno/compiled/all.csv`
    + /simu/gpt4aug3/noise.csv
    + /simu/gpt4aug3/subset.csv
- output:
    + `anno/cl/compiled.csv`
- 作用:
    + 将注释的细胞类型归类到有CL编号的类型

### code

- all.R
    - input:
        + `anno/res/gpt4aug3.csv`
        + `anno/res/gpt4mar23.csv`
        + `anno/res/gpt3.5aug3.csv`
        + `anno/res/cellmarker.csv`
        + `anno/res/sctype.csv`
        + `anno/res/SingleR.csv`
        + `anno/cl/compiled.csv`
        + `anno/cl/relation.csv`
        + `anno/agreement/compiled.csv`
    - output:
        + `anno/compiled/all.csv`
    - 作用:
        + 汇总所有注释结果
        

- makegpttabulasapiens.R
    + input
        * `anno/code/gpttabulasapienstemplate.csv`
    + output
        * `anno/gpt3.5aug3tabulasapiens.csv`
    + 功能:
        读取问题模板, 调用接口获得回答结果

- makegptother.R
    + 功能输入类似makegpttabulasapiens.R, 选取基因似乎不同

- gpt4topgenenumber.R
    + 汇总不同数目TOP基因下, GPT的注释结果

### subtype

- 没看懂

### process

- data/code/*: 数据原始处理, 对表达矩阵进行norm
    + 如果没有`code`文件夹，可能直接是一个`Proc.R`脚本

- 不同数据集的处理
    + SingleR > 应该是生成了SingleCellExperiment对象
    + sctype > 生成Seurat对象

## 七个数据集可下载内容来源

- MCA: https://figshare.com/s/865e694ad06d5857db4b
- HCL: https://figshare.com/articles/dataset/HCL_DGE_Data/7235471
- GTEx: 
    + 注释结果和差异基因: 原文献的补充材料，https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9383269/bin/NIHMS1828607-supplement-Supplementary_Tables.zip
    + 表达矩阵: https://gtexportal.org/home/downloads/adult-gtex/single_cell
- BCL: https://zenodo.org/record/7813151
- Lung cancer gene expression matrix: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE131907
- Colon cancer gene expression: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE132465
- TS gene expression matrix: https://cells.ucsc.edu/?ds=tabula-sapiens
- HubMAP: https://azimuth.hubmapconsortium.org

## 运行复现流程

```bash
pixi run snakemake anno/process/hca/celltype.done -j 1 --rerun-triggers mtime 
```