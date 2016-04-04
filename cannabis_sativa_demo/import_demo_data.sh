#!/bin/bash

ORGANISM=$(tbro-db organism insert --genus Cannabis --species sativa --common_name Weed --abbreviation C.sativa --short)
# tbro-db organism list

tbro-import sequence_ids --organism_id $ORGANISM --release 1.CasaPuKu --file_type only_isoforms transcriptome/cannabis_sativa_transcriptome.ids
tbro-import sequences_fasta --organism_id $ORGANISM --release 1.CasaPuKu transcriptome/cannabis_sativa_transcriptome.fasta

tbro-import peptide_ids --organism_id $ORGANISM --release 1.CasaPuKu peptids/predicted_peptides.tbl
tbro-import sequences_fasta --organism_id $ORGANISM --release 1.CasaPuKu peptids/best_candidates.eclipsed_orfs_removed.pep

tbro-import annotation_repeatmasker --organism_id $ORGANISM --release 1.CasaPuKu analyses/repeats/cannabis_sativa_transcriptome.fasta.out.xm

tbro-import annotation_interpro --organism_id $ORGANISM --release 1.CasaPuKu -i interproscan-5-RC5 analyses/interpro/interpro.tsv

tbro-import annotation_go --organism_id $ORGANISM --release 1.CasaPuKu analyses/blast2go/cannabis_sativa_transcriptome.blast2go.annot.go

#PROBLEM NO db EC --> error not null violation
tbro-import annotation_ec --organism_id $ORGANISM --release 1.CasaPuKu analyses/blast2go/cannabis_sativa_transcriptome.blast2go.annot.ec

tbro-import annotation_description --organism_id $ORGANISM --release 1.CasaPuKu analyses/blast2go/cannabis_sativa_transcriptome.blast2go.annot.go.description

tbro-import annotation_mapman --organism_id $ORGANISM --release 1.CasaPuKu analyses/mercator/mercator.results_max1499.txt
 
tbro-import annotation_mapman --organism_id $ORGANISM --release 1.CasaPuKu analyses/mercator/mercator.results_min1500.txt

# Prepare database for Expression Data Import
# Add missing biomaterials (Flower and Root are already present)
tbro-db biomaterial insert --name Flower
tbro-db biomaterial insert --name Leaf
tbro-db biomaterial insert --name Root
tbro-db biomaterial insert --name Stem
tbro-db biomaterial insert --name Shoot

# Add conditions
tbro-db biomaterial add_condition --name Flower.mature --parent_biomaterial_name Flower
tbro-db biomaterial add_condition --name Flower.buds --parent_biomaterial_name Flower
tbro-db biomaterial add_condition --name Flower.pre --parent_biomaterial_name Flower
tbro-db biomaterial add_condition --name Flower.early --parent_biomaterial_name Flower
tbro-db biomaterial add_condition --name Flower.mid --parent_biomaterial_name Flower
tbro-db biomaterial add_condition --name Leaf.mature --parent_biomaterial_name Leaf
tbro-db biomaterial add_condition --name Leaf.young --parent_biomaterial_name Leaf
tbro-db biomaterial add_condition --name Root.entire --parent_biomaterial_name Root
tbro-db biomaterial add_condition --name Root.full --parent_biomaterial_name Root
tbro-db biomaterial add_condition --name Stem.petiole --parent_biomaterial_name Stem
tbro-db biomaterial add_condition --name Stem.primary --parent_biomaterial_name Stem
tbro-db biomaterial add_condition --name Shoot.full --parent_biomaterial_name Shoot

# Add samples
tbro-db biomaterial add_condition_sample --name Flower.pre_L1 --parent_condition_name Flower.pre
tbro-db biomaterial add_condition_sample --name Flower.early_L1 --parent_condition_name Flower.early
tbro-db biomaterial add_condition_sample --name Flower.mid_L1 --parent_condition_name Flower.mid
tbro-db biomaterial add_condition_sample --name Root.full_L1 --parent_condition_name Root.full
tbro-db biomaterial add_condition_sample --name Shoot.full_L1 --parent_condition_name Shoot.full
tbro-db biomaterial add_condition_sample --name Leaf.mature_L1 --parent_condition_name Leaf.mature
tbro-db biomaterial add_condition_sample --name Leaf.mature_L2 --parent_condition_name Leaf.mature
tbro-db biomaterial add_condition_sample --name Leaf.mature_L3 --parent_condition_name Leaf.mature
tbro-db biomaterial add_condition_sample --name Leaf.young_L1 --parent_condition_name Leaf.young
tbro-db biomaterial add_condition_sample --name Leaf.young_L2 --parent_condition_name Leaf.young
tbro-db biomaterial add_condition_sample --name Leaf.young_L3 --parent_condition_name Leaf.young
tbro-db biomaterial add_condition_sample --name Flower.mature_L1 --parent_condition_name Flower.mature
tbro-db biomaterial add_condition_sample --name Flower.mature_L2 --parent_condition_name Flower.mature
tbro-db biomaterial add_condition_sample --name Flower.mature_L3 --parent_condition_name Flower.mature
tbro-db biomaterial add_condition_sample --name Flower.buds_L1 --parent_condition_name Flower.buds
tbro-db biomaterial add_condition_sample --name Flower.buds_L2 --parent_condition_name Flower.buds
tbro-db biomaterial add_condition_sample --name Flower.buds_L3 --parent_condition_name Flower.buds
tbro-db biomaterial add_condition_sample --name Root.entire_L1 --parent_condition_name Root.entire
tbro-db biomaterial add_condition_sample --name Root.entire_L2 --parent_condition_name Root.entire
tbro-db biomaterial add_condition_sample --name Root.entire_L3 --parent_condition_name Root.entire
tbro-db biomaterial add_condition_sample --name Stem.primary_L1 --parent_condition_name Stem.primary
tbro-db biomaterial add_condition_sample --name Stem.primary_L2 --parent_condition_name Stem.primary
tbro-db biomaterial add_condition_sample --name Stem.petiole_L1 --parent_condition_name Stem.petiole
tbro-db biomaterial add_condition_sample --name Stem.petiole_L2 --parent_condition_name Stem.petiole

# Add contact
CONTACT=$(tbro-db contact insert --name TBroDemo --description 'TBro Demo User' --short)

#Add experiments 
ASSAY_M=$(tbro-db assay insert --name Michigan --operator_id $CONTACT --short)
ASSAY_T=$(tbro-db assay insert --name Toronto --operator_id $CONTACT --short)

# Add acquisitions (corresponding to experiments)
ACQUISITION_M=$(tbro-db acquisition insert --name Michigan --assay_id $ASSAY_M --short)
ACQUISITION_T=$(tbro-db acquisition insert --name Toronto --assay_id $ASSAY_T --short)

# Add analyses 
ANALYSIS_EXP_RSEM=$(tbro-db analysis insert --name RSEM-1.2.19_TMM --program RSEM --programversion 1.2.19 --sourcename Mapping --description 'RSEM 1.2.19 quantification with subsequent TMM normalization' --short)
ANALYSIS_EXP_SAIL=$(tbro-db analysis insert --name sailfish-0.6.3_TMM --program sailfish --programversion 0.6.3 --sourcename Mapping --description 'sailfish 0.6.3 quantification with subsequent TMM normalization' --short)
ANALYSIS_DIF=$(tbro-db analysis insert --name DESeq-1.18.0_isoform --program DESeq --programversion 1.18.0 --sourcename Mapping_isoform --short)

# Add quantifications
QUANTIFICATION_T_R=$(tbro-db quantification insert --name Toronto_RSEM --acquisition_id $ACQUISITION_T --analysis_id $ANALYSIS_EXP_RSEM --short)
QUANTIFICATION_T_S=$(tbro-db quantification insert --name Toronto_sailfish --acquisition_id $ACQUISITION_T --analysis_id $ANALYSIS_EXP_SAIL --short)
QUANTIFICATION_M_R=$(tbro-db quantification insert --name Michigan_RSEM --acquisition_id $ACQUISITION_M --analysis_id $ANALYSIS_EXP_RSEM --short)
QUANTIFICATION_M_S=$(tbro-db quantification insert --name Michigan_sailfish --acquisition_id $ACQUISITION_M --analysis_id $ANALYSIS_EXP_SAIL --short)

tbro-import expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu -q $QUANTIFICATION_T_R -a $ANALYSIS_EXP_RSEM analyses/expression/toronto.rsem.countmat.TMM.tsv
tbro-import expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu -q $QUANTIFICATION_T_S -a $ANALYSIS_EXP_SAIL analyses/expression/toronto.sailfish.countmat.TMM.tsv
tbro-import expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu -q $QUANTIFICATION_M_R -a $ANALYSIS_EXP_RSEM analyses/expression/michigan.rsem.countmat.TMM.tsv
tbro-import expressions -o $ORGANISM -r 1.CasaPuKu -q $QUANTIFICATION_M_S -a $ANALYSIS_EXP_SAIL analyses/expression/michigan.sailfish.countmat.TMM.tsv

# Diffexp toronto RSEM
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Root.full -B Shoot.full analyses/expression/diffexp/toronto.rsem.TMM_Root.full_Shoot.full.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Root.full -B Flower.pre analyses/expression/diffexp/toronto.rsem.TMM_Root.full_Flower.pre.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Root.full -B Flower.early analyses/expression/diffexp/toronto.rsem.TMM_Root.full_Flower.early.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Root.full -B Flower.mid analyses/expression/diffexp/toronto.rsem.TMM_Root.full_Flower.mid.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Shoot.full -B Flower.pre analyses/expression/diffexp/toronto.rsem.TMM_Shoot.full_Flower.pre.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Shoot.full -B Flower.early analyses/expression/diffexp/toronto.rsem.TMM_Shoot.full_Flower.early.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Shoot.full -B Flower.mid analyses/expression/diffexp/toronto.rsem.TMM_Shoot.full_Flower.mid.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Flower.pre -B Flower.early analyses/expression/diffexp/toronto.rsem.TMM_Flower.pre_Flower.early.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Flower.pre -B Flower.mid analyses/expression/diffexp/toronto.rsem.TMM_Flower.pre_Flower.mid.tsv
tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_R -A Flower.early -B Flower.mid analyses/expression/diffexp/toronto.rsem.TMM_Flower.early_Flower.mid.tsv

# Diffexp toronto sailfish
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Root.full -B Shoot.full analyses/expression/diffexp/toronto.sailfish.TMM_Root.full_Shoot.full.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Root.full -B Flower.pre analyses/expression/diffexp/toronto.sailfish.TMM_Root.full_Flower.pre.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Root.full -B Flower.early analyses/expression/diffexp/toronto.sailfish.TMM_Root.full_Flower.early.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Root.full -B Flower.mid analyses/expression/diffexp/toronto.sailfish.TMM_Root.full_Flower.mid.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Shoot.full -B Flower.pre analyses/expression/diffexp/toronto.sailfish.TMM_Shoot.full_Flower.pre.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Shoot.full -B Flower.early analyses/expression/diffexp/toronto.sailfish.TMM_Shoot.full_Flower.early.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Shoot.full -B Flower.mid analyses/expression/diffexp/toronto.sailfish.TMM_Shoot.full_Flower.mid.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Flower.pre -B Flower.early analyses/expression/diffexp/toronto.sailfish.TMM_Flower.pre_Flower.early.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Flower.pre -B Flower.mid analyses/expression/diffexp/toronto.sailfish.TMM_Flower.pre_Flower.mid.tsv
tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_T_S -A Flower.early -B Flower.mid analyses/expression/diffexp/toronto.sailfish.TMM_Flower.early_Flower.mid.tsv

# Diffexp michigan RSEM
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Root.entire -B Stem.primary analyses/expression/diffexp/michigan.rsem.TMM_Root.entire_Stem.primary.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Root.entire -B Stem.petiole analyses/expression/diffexp/michigan.rsem.TMM_Root.entire_Stem.petiole.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Root.entire -B Leaf.young analyses/expression/diffexp/michigan.rsem.TMM_Root.entire_Leaf.young.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Root.entire -B Leaf.mature analyses/expression/diffexp/michigan.rsem.TMM_Root.entire_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Root.entire -B Flower.buds analyses/expression/diffexp/michigan.rsem.TMM_Root.entire_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Root.entire -B Flower.mature analyses/expression/diffexp/michigan.rsem.TMM_Root.entire_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.primary -B Stem.petiole analyses/expression/diffexp/michigan.rsem.TMM_Stem.primary_Stem.petiole.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.primary -B Leaf.young analyses/expression/diffexp/michigan.rsem.TMM_Stem.primary_Leaf.young.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.primary -B Leaf.mature analyses/expression/diffexp/michigan.rsem.TMM_Stem.primary_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.primary -B Flower.buds analyses/expression/diffexp/michigan.rsem.TMM_Stem.primary_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.primary -B Flower.mature analyses/expression/diffexp/michigan.rsem.TMM_Stem.primary_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.petiole -B Leaf.young analyses/expression/diffexp/michigan.rsem.TMM_Stem.petiole_Leaf.young.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.petiole -B Leaf.mature analyses/expression/diffexp/michigan.rsem.TMM_Stem.petiole_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.petiole -B Flower.buds analyses/expression/diffexp/michigan.rsem.TMM_Stem.petiole_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Stem.petiole -B Flower.mature analyses/expression/diffexp/michigan.rsem.TMM_Stem.petiole_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Leaf.young -B Leaf.mature analyses/expression/diffexp/michigan.rsem.TMM_Leaf.young_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Leaf.young -B Flower.buds analyses/expression/diffexp/michigan.rsem.TMM_Leaf.young_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Leaf.young -B Flower.mature analyses/expression/diffexp/michigan.rsem.TMM_Leaf.young_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Leaf.mature -B Flower.buds analyses/expression/diffexp/michigan.rsem.TMM_Leaf.mature_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Leaf.mature -B Flower.mature analyses/expression/diffexp/michigan.rsem.TMM_Leaf.mature_Flower.mature.tsv
tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_R -A Flower.buds -B Flower.mature analyses/expression/diffexp/michigan.rsem.TMM_Flower.buds_Flower.mature.tsv

# Diffexp michigan sailfish
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Root.entire -B Stem.primary analyses/expression/diffexp/michigan.sailfish.TMM_Root.entire_Stem.primary.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Root.entire -B Stem.petiole analyses/expression/diffexp/michigan.sailfish.TMM_Root.entire_Stem.petiole.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Root.entire -B Leaf.young analyses/expression/diffexp/michigan.sailfish.TMM_Root.entire_Leaf.young.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Root.entire -B Leaf.mature analyses/expression/diffexp/michigan.sailfish.TMM_Root.entire_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Root.entire -B Flower.buds analyses/expression/diffexp/michigan.sailfish.TMM_Root.entire_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Root.entire -B Flower.mature analyses/expression/diffexp/michigan.sailfish.TMM_Root.entire_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.primary -B Stem.petiole analyses/expression/diffexp/michigan.sailfish.TMM_Stem.primary_Stem.petiole.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.primary -B Leaf.young analyses/expression/diffexp/michigan.sailfish.TMM_Stem.primary_Leaf.young.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.primary -B Leaf.mature analyses/expression/diffexp/michigan.sailfish.TMM_Stem.primary_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.primary -B Flower.buds analyses/expression/diffexp/michigan.sailfish.TMM_Stem.primary_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.primary -B Flower.mature analyses/expression/diffexp/michigan.sailfish.TMM_Stem.primary_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.petiole -B Leaf.young analyses/expression/diffexp/michigan.sailfish.TMM_Stem.petiole_Leaf.young.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.petiole -B Leaf.mature analyses/expression/diffexp/michigan.sailfish.TMM_Stem.petiole_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.petiole -B Flower.buds analyses/expression/diffexp/michigan.sailfish.TMM_Stem.petiole_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Stem.petiole -B Flower.mature analyses/expression/diffexp/michigan.sailfish.TMM_Stem.petiole_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Leaf.young -B Leaf.mature analyses/expression/diffexp/michigan.sailfish.TMM_Leaf.young_Leaf.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Leaf.young -B Flower.buds analyses/expression/diffexp/michigan.sailfish.TMM_Leaf.young_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Leaf.young -B Flower.mature analyses/expression/diffexp/michigan.sailfish.TMM_Leaf.young_Flower.mature.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Leaf.mature -B Flower.buds analyses/expression/diffexp/michigan.sailfish.TMM_Leaf.mature_Flower.buds.tsv
tbro-import differential_expressions --skip-materialize-views -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Leaf.mature -B Flower.mature analyses/expression/diffexp/michigan.sailfish.TMM_Leaf.mature_Flower.mature.tsv
tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION_M_S -A Flower.buds -B Flower.mature analyses/expression/diffexp/michigan.sailfish.TMM_Flower.buds_Flower.mature.tsv

#phing queue-install-db

# generate zip md5sums
MD5SUM_TRANSCRIPTS=$(md5sum blast/cannabis_sativa_transcriptome.zip | cut -f 1 -d " ")
MD5SUM_PROTEINS=$(md5sum blast/cannabis_sativa_predpep.zip | cut -f 1 -d " ")

cat > /tmp/input.sql <<EOF
BEGIN TRANSACTION;

-- programs that the user is allowed to execute
INSERT INTO programs (name) VALUES
('blastn'),
('blastp'),
('blastx'),
('tblastn'),
('tblastx');

-- database files available. name is the name it will be referenced by, md5 is the zip file's sum, download_uri specifies where the file can be retreived
INSERT INTO database_files
 (name, md5, download_uri) VALUES
 ('cannabis_sativa_transcriptome.fasta', '${MD5SUM_TRANSCRIPTS}',
 'ftp://WORKERFTP/cannabis_sativa_transcriptome.zip'),
 ('cannabis_sativa_predpep.fasta', '${MD5SUM_PROTEINS}',
 'ftp://WORKERFTP/cannabis_sativa_predpep.zip');

-- contains information which program is available for which program.
-- additionally, 'availability_filter' can be used to e.g. restrict use for a organism-release combination
INSERT INTO program_database_relationships
 (programname, database_name, availability_filter) VALUES
 ('blastn','cannabis_sativa_transcriptome.fasta', '${ORGANISM}_1.CasaPuKu'),
 ('blastp','cannabis_sativa_predpep.fasta', '${ORGANISM}_1.CasaPuKu'),
 ('blastx','cannabis_sativa_predpep.fasta', '${ORGANISM}_1.CasaPuKu'),
 ('tblastn','cannabis_sativa_transcriptome.fasta', '${ORGANISM}_1.CasaPuKu'),
 ('tblastx','cannabis_sativa_transcriptome.fasta', '${ORGANISM}_1.CasaPuKu');

--time in seconds until a query job will be set from "PROCESSING" to "NOT_PROCESSED". make sure this value is big enough or some jobs will stay in the queue forever.
UPDATE options SET value=120 WHERE key='MAXIMUM_EXECUTION_TIME';
--time in seconds a worker has to send another keepalive_ping until a query job will be set from "PROCESSING" to "NOT_PROCESSED".
UPDATE options SET value=15 WHERE key='MAXIMUM_KEEPALIVE_TIMEOUT';


-- allowed parameters to be passed for each of these programs
-- if a parameter is omited by create_job, the default_value will be used. can contain the variable $DBFILE
-- the constraint_function will be executed on the parameter value, together with constraint_function_parameters
-- available constraints function are (but can be extended):
--   cfunc_in_array - takes an array of values as constraint_function_parameters
--   cfunc_within_bounds - takes an array of {min,max} as constraint_function_parameters
--   cfunc_default_only - user can not change it, always use default parameter
INSERT INTO allowed_parameters
(programname, param_name, default_value, constraint_function, constraint_function_parameters) VALUES
('blastn',  'task',             'megablast', 'cfunc_in_array',      ARRAY['blastn', 'dc-megablast', 'megablast']),
('blastn',  'word_size',        '11',        'cfunc_in_array',      ARRAY['7', '11', '15']),
('blastn',  'outfmt',           '5',         'cfunc_default_only',  NULL),
('blastn',  'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('blastn',  'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('blastn',  'db',               '\$DBFILE',   'cfunc_default_only',  NULL),
('blastp',  'task',             'blastp',    'cfunc_default_only',  NULL),
('blastp',  'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('blastp',  'outfmt',           '5',         'cfunc_default_only',  NULL),
('blastp',  'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('blastp',  'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('blastp',  'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('blastp',  'db',               '\$DBFILE',   'cfunc_default_only',  NULL),
('blastx',  'outfmt',           '5',         'cfunc_default_only',  NULL),
('blastx',  'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('blastx',  'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('blastx',  'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('blastx',  'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('blastx',  'db',               '\$DBFILE',   'cfunc_default_only',  NULL),
('tblastn', 'outfmt',           '5',         'cfunc_default_only',  NULL),
('tblastn', 'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('tblastn', 'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('tblastn', 'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('tblastn', 'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('tblastn', 'db',               '\$DBFILE',   'cfunc_default_only',  NULL),
('tblastx', 'outfmt',           '5',         'cfunc_default_only',  NULL),
('tblastx', 'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('tblastx', 'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('tblastx', 'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('tblastx', 'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('tblastx', 'db',               '\$DBFILE',   'cfunc_default_only',  NULL);

COMMIT;
EOF

# set the environment variable to allow database access without password entry
export PGPASSWORD="$WORKER_ENV_DB_PW"

# run psql and commit the entries to the worker database
psql --host=WORKER --port=$WORKER_PORT_5432_TCP_PORT --username=$WORKER_ENV_DB_USER $WORKER_ENV_DB_NAME < /tmp/input.sql

# finally we have to upload the files to our FTP container
curl --progress-bar --data-binary --ftp-pasv --user "$WORKERFTP_ENV_FTP_USER":"$WORKERFTP_ENV_FTP_PW" -T blast/cannabis_sativa_transcriptome.zip ftp://WORKERFTP/
curl --progress-bar --data-binary --ftp-pasv --user "$WORKERFTP_ENV_FTP_USER":"$WORKERFTP_ENV_FTP_PW" -T blast/cannabis_sativa_predpep.zip ftp://WORKERFTP/
for j in $(for i in $(sort --random-sort transcriptome/cannabis_sativa_transcriptome.ids | head -100); do tbro-db feature list --name "$i" | sed -n '4{p;q}' | cut -f 2 -d "|"; done)
do 
    FEATUREID=$j
    tbro-db feature add_synonym -f $FEATUREID --synonym 'InterestingTranscript'_$j -b '[[publication/1ec511cfe178d54ff2ce82043ae958538/tbro]]' -u 'tbro' -t symbol -k 79595d0d12b7667344dd6d326fc7ba42
done
FEATUREID=$(tbro-db feature list --name $(head -n1 transcriptome/cannabis_sativa_transcriptome.ids) | sed -n '4{p;q}' | cut -f 2 -d "|")
tbro-db feature add_synonym -f $FEATUREID --synonym 'InterestingTranscript' -b '[[publication/1ec511cfe178d54ff2ce82043ae958538/tbro]]' -u 'tbro' -t symbol -k 79595d0d12b7667344dd6d326fc7ba42

tbro-tools addECInformationToDB ec2kegg/ec_info.tab
tbro-tools addPathwayInformationToDB ec2kegg/kegg_info.tab
tbro-tools addEC2PathwayMapping ec2kegg/ec_kegg_map.tab

