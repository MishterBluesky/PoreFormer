#!/bin/bash

name=$1
protein_pdb=$2
ssh=$3
echo "Martinish is making a backup of $2 called Untouched_$2"
cp $2 Untouched_$2
/home/lifesci/lfstgr/.local/bin/martinize2 -f $2 -ff martini3001 -x $1.pdb -o $1.top -ss $3 -elastic
mv molecule_0.itp $1.itp
sed -i "s/molecule_0/$1/g" $1.itp
module load GCC/11.2.0 OpenMPI/4.1.1 GROMACS/2021.5-PLUMED-2.8.0
gmx editconf -f $1.pdb -o $1.gro
sed -i "1s/.*/$1/" $1.gro
filename="$1.str"
# Define the text content
content="include $1.gro\n[Protein List]\n$1 1 0.01 0 0 -3\nEnd Protein\n"

# Write the content to the file
echo -e "$content" > "$filename"