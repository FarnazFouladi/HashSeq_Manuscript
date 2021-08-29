#!/bin/bash

cd $HOME/git/HashSeq_Manuscript

grep ">" ./data/DADA2/china_sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query  ./data/DADA2/china_sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/DADA2/sequences_china.txt

echo "China done!"

grep ">" ./data/DADA2/RYGB_sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/DADA2/RYGB_sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/DADA2/sequences_RYGB.txt

echo "RYGB done!"

grep ">" ./data/DADA2/autism_sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/DADA2/autism_sequences.fasta  \
-max_target_seqs 5 -outfmt 7 > ./blast/DADA2/sequences_autism.txt

echo "autism done!"

grep ">" ./data/DADA2/soil_sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/DADA2/soil_sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/DADA2/sequences_soil.txt

echo "soil done!"

grep ">" ./data/DADA2/MMC_sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/DADA2/MMC_sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/DADA2/sequences_MMC.txt

echo "MMC done!"

grep ">" ./data/DADA2/vaginal_sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/DADA2/vaginal_sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/DADA2/sequences_vaginal.txt

echo "vaginal done!"
