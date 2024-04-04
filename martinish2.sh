#!/bin/bash

name=$1
protein_pdb=$2
workdir=$3
Poredir=$4
translate=$5
echo "Martinish is making a backup of $2 called Untouched_$2"
cd $workdir
mv *.itp $Poredir/*.itp
cd $Poredir
sed -i "1s/.*/$1/" $1.gro
filename="$1.str"
# Define the text content
content="include $1.gro\n[Protein List]\n$1 1 0.01 0 0 $5\nEnd Protein\n"

# Write the content to the file
echo -e "$content" > "$filename"
