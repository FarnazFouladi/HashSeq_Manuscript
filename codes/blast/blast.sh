#!/bin/bash

cd $HOME/git/HashSeq_Manuscript

grep ">" ./data/china/sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/china/sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/HashSeq/sequences_china.txt

echo "China done!"

grep ">" ./data/RYGB/sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/RYGB/sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/HashSeq/sequences_RYGB.txt

echo "RYGB done!"

grep ">" ./data/autism/sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/autism/sequences.fasta  \
-max_target_seqs 5 -outfmt 7 > ./blast/HashSeq/sequences_autism.txt

echo "autism done!"

grep ">" ./data/soil/sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/soil/sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/HashSeq/sequences_soil.txt

echo "soil done!"

grep ">" ./data/MMC/sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/MMC/sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/HashSeq/sequences_MMC.txt

echo "MMC done!"

grep ">" ./data/vaginal/sequences.fasta | wc

blastn -db /Users/farnazfouladi/database/SILVA/silva132 -query ./data/vaginal/sequences.fasta \
-max_target_seqs 5 -outfmt 7 > ./blast/HashSeq/sequences_vaginal.txt

echo "vaginal done!"
