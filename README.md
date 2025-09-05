# Human_LAD_SPAD_scripts

Raw_data_mapping.sh is used to mapping raw data to reference genome hg19, and call LADs/SPADs preliminary.

Inputs for p-value.sh are ‘ <path to bed file> <bed_file> <bam_file> <number of mapped reads>’.

Merge_bed.sh is used to merge LADs/SPADs  from two replicates.

nochrXY.sh is used to exclude chrX and chrY for basic information analysis of autosomes.

Length.sh is used to calculate the length of each LAD/SPAD.

Strength.sh is used to calculate the strength of LADs/SPADs for each stage.

make_boundary.sh is used to generate the regions of boundaries for each LAD/SPAD in different stages.

chr_state.sh is used to identify four types of regions. They are "BOTH", "SPAD", "LAD", "NONE".
