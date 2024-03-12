#!/bin/bash

name=$1
protein_pdb=$2
workdir=$3
Poredir=$4
echo "Martinish is making a backup of $2 called Untouched_$2"
cd $workdir
mv molecule_0.itp $Poredir/$1.itp
cd $Poredir
sed -i "s/molecule_0/$1/g" $1.itp
sed -i "1s/.*/$1/" $1.gro
filename="$1.str"
# Define the text content
content="include $1.gro\n[Protein List]\n$1 1 0.01 0 0 -3\nEnd Protein\n"

# Write the content to the file
echo -e "$content" > "$filename"
