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
 'ftp://WORKER/cannabis_sativa_transcriptome.zip'),
 ('cannabis_sativa_predpep.fasta', '${MD5SUM_PROTEINS}',
 'ftp://WORKER/cannabis_sativa_predpep.zip');

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
('blastn',  'db',               '$DBFILE',   'cfunc_default_only',  NULL),
('blastp',  'task',             'blastp',    'cfunc_default_only',  NULL),
('blastp',  'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('blastp',  'outfmt',           '5',         'cfunc_default_only',  NULL),
('blastp',  'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('blastp',  'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('blastp',  'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('blastp',  'db',               '$DBFILE',   'cfunc_default_only',  NULL),
('blastx',  'outfmt',           '5',         'cfunc_default_only',  NULL),
('blastx',  'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('blastx',  'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('blastx',  'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('blastx',  'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('blastx',  'db',               '$DBFILE',   'cfunc_default_only',  NULL),
('tblastn', 'outfmt',           '5',         'cfunc_default_only',  NULL),
('tblastn', 'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('tblastn', 'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('tblastn', 'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('tblastn', 'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('tblastn', 'db',               '$DBFILE',   'cfunc_default_only',  NULL),
('tblastx', 'outfmt',           '5',         'cfunc_default_only',  NULL),
('tblastx', 'word_size',        '3',         'cfunc_in_array',      ARRAY['2', '3']),
('tblastx', 'max_target_seqs',  '10',        'cfunc_within_bounds', ARRAY['1','1000']),
('tblastx', 'evalue',           '0.1',       'cfunc_within_bounds', ARRAY['0','100']),
('tblastx', 'matrix',           'BLOSUM62',  'cfunc_in_array',      ARRAY['BLOSUM45', 'BLOSUM50', 'BLOSUM62', 'BLOSUM80', 'BLOSUM90', 'PAM30', 'PAM70', 'PAM250']),
('tblastx', 'db',               '$DBFILE',   'cfunc_default_only',  NULL);

COMMIT;
EOF

# set the environment variable to allow database access without password entry
export PGPASSWORD="$WORKER_ENV_DB_PW"

# run psql and commit the entries to the worker database
psql --host=WORKER --port=$WORKER_PORT_5432_TCP_PORT --username=$WORKER_ENV_DB_USER $WORKER_ENV_DB_NAME < /tmp/input.sql

# finally we have to upload the files to our FTP container
curl --progress-bar --data-binary --ftp-pasv --user "$WORKERFTP_ENV_FTP_USER":"$WORKERFTP_ENV_FTP_PW" -T blast/cannabis_sativa_transcriptome.zip ftp://WORKERFTP/
curl --progress-bar --data-binary --ftp-pasv --user "$WORKERFTP_ENV_FTP_USER":"$WORKERFTP_ENV_FTP_PW" -T blast/cannabis_sativa_predpep.zip ftp://WORKERFTP/

### Call this manually with a valid feature_id
# FEATUREID=
# tbro-db feature add_synonym -f $FEATUREID --synonym 'InterestingTranscript' -b '[[publication/1ec511cfe178d54ff2ce82043ae958538/iimog]]' -u 'tbro' -t symbol -k 79595d0d12b7667344dd6d326fc7ba42

tbro-tools addECInformationToDB ec2kegg/ec_info.tab
tbro-tools addPathwayInformationToDB ec2kegg/kegg_info.tab
tbro-tools addEC2PathwayMapping ec2kegg/ec_kegg_map.tab

