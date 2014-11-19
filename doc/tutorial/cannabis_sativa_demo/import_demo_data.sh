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

# Add conditions
tbro-db biomaterial add_condition --name Flower.mature --parent_biomaterial_name Flower
tbro-db biomaterial add_condition --name Leaf.mature --parent_biomaterial_name Leaf
tbro-db biomaterial add_condition --name Root.entire --parent_biomaterial_name Root

# Add samples
tbro-db biomaterial add_condition_sample --name Flower.mature_L1 --parent_condition_name Flower.mature
tbro-db biomaterial add_condition_sample --name Flower.mature_L2 --parent_condition_name Flower.mature
tbro-db biomaterial add_condition_sample --name Flower.mature_L3 --parent_condition_name Flower.mature
tbro-db biomaterial add_condition_sample --name Leaf.mature_L1 --parent_condition_name Leaf.mature
tbro-db biomaterial add_condition_sample --name Leaf.mature_L2 --parent_condition_name Leaf.mature
tbro-db biomaterial add_condition_sample --name Leaf.mature_L3 --parent_condition_name Leaf.mature
tbro-db biomaterial add_condition_sample --name Root.entire_L1 --parent_condition_name Root.entire
tbro-db biomaterial add_condition_sample --name Root.entire_L2 --parent_condition_name Root.entire
tbro-db biomaterial add_condition_sample --name Root.entire_L3 --parent_condition_name Root.entire

# Add contact
CONTACT=$(tbro-db contact insert --name TBroDemo --description 'TBro Demo User' --short)

#Add experiments 
ASSAY=$(tbro-db assay insert --name SRX082027 --operator_id $CONTACT --short)

# Add acquisitions (corresponding to experiments)
ACQUISITION=$(tbro-db acquisition insert --name SRX082027 --assay_id $ASSAY --short)

# Add analyses 
ANALYSIS_EXP=$(tbro-db analysis insert --name RSEM_TMM --program RSEM --programversion 1.2.5 --sourcename Mapping --description 'RSEM quantification with subsequent TMM normalization' --short)
ANALYSIS_DIF=$(tbro-db analysis insert --name DESeq_isoform --program DESeq --programversion 1.12.1 --sourcename Mapping_isoform --short)

# Add quantifications
QUANTIFICATION=$(tbro-db quantification insert --name RSEM_SRX082027 --acquisition_id $ACQUISITION --analysis_id $ANALYSIS_EXP --short)

tbro-import expressions -o $ORGANISM -r 1.CasaPuKu -q $QUANTIFICATION -a $ANALYSIS_EXP analyses/rsem/rsem_aggregated_TMM.edit.mat

tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION -A Flower.mature -B Leaf.mature analyses/rsem/rsem_aggregated_TMM_diff_FvsL.mat
tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION -A Flower.mature -B Root.entire analyses/rsem/rsem_aggregated_TMM_diff_FvsR.mat
tbro-import differential_expressions -o $ORGANISM -r 1.CasaPuKu --analysis_id $ANALYSIS_DIF -q $QUANTIFICATION -A Root.entire -B Leaf.mature analyses/rsem/rsem_aggregated_TMM_diff_RvsL.mat

#phing queue-install-db

#-- database files available. name is the name it will be referenced by, md5 is the zip file's sum, download_uri specifies where the file can be retreived
#INSERT INTO database_files
# (name, md5, download_uri) VALUES
# ('cannabis_sativa_transcriptome.fasta', '1f87bbeee5a623e6d2f8cab8f68c9726',
# 'http://yourdomain/location/cannabis_sativa_transcriptome.zip'),
# ('cannabis_sativa_predpep.fasta', 'b2ab466c7bfb7d41c27a89cf40837fb4',
# 'http://yourdomain/location/cannabis_sativa_predpep.zip');
#
#-- contains information which program is available for which program.
#-- additionally, 'availability_filter' can be used to e.g. restrict use for a organism-release combination
#INSERT INTO program_database_relationships
# (programname, database_name, availability_filter) VALUES
# ('blastn','cannabis_sativa_transcriptome.fasta', '13_1.CasaPuKu'),
# ('blastp','cannabis_sativa_predpep.fasta', '13_1.CasaPuKu'),
# ('blastx','cannabis_sativa_predpep.fasta', '13_1.CasaPuKu'),
# ('tblastn','cannabis_sativa_transcriptome.fasta', '13_1.CasaPuKu'),
# ('tblastx','cannabis_sativa_transcriptome.fasta', '13_1.CasaPuKu');
#

### Call this manually with a valid feature_id
# FEATUREID=
# tbro-db feature add_synonym -f $FEATUREID --synonym 'InterestingTranscript' -b '[[publication/1ec511cfe178d54ff2ce82043ae958538/iimog]]' -u 'tbro' -t symbol -k 79595d0d12b7667344dd6d326fc7ba42

#tbro-tools addECInformationToDB ec_info.tab
#tbro-tools addPathwayInformationToDB kegg_info.tab
#tbro-tools addEC2PathwayMapping ec_kegg_map.tab

