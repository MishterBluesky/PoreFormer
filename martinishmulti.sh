#!/bin/bash

name=$1
protein_pdb=$2
workdir=$3
Poredir=$4
name2=$5
protein_pdb_2=$6
workdir2=$7
translate1=$8
translate2=$9

echo "Martinish is making a backup of $2 called Untouched_$2"
cd $workdir
mv molecule_0.itp $Poredir/$1.itp
cd $Poredir
sed -i "s/molecule_0/$1/g" $1.itp
sed -i "1s/.*/$1/" $1.gro

echo "Martinish is making a backup of $6 called Untouched_$6"
cd $workdir2
mv molecule_0.itp $Poredir/$1.itp
cd $Poredir
sed -i "s/molecule_0/$5/g" $5.itp
sed -i "1s/.*/$5/" $5.gro

filename="$1$5.str"
# Define the text content
content="include $1.gro\ninclude $5.gro\n[Protein List]\n$1 1 0.01 0 0 ${8} \n$5 2 0.01 0 0 ${9} \nEnd Protein\n"

# Write the content to the file
echo -e "$content" > "$filename"
