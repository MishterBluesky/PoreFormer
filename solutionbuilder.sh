#!/bin/bash

name=$1
protein_pdb=$2
protein_number=$3
workdir=$4
Poredir=$5
scale=${6}
scale_z=${6}
cutx=$(awk "BEGIN {printf \"%.2f\", ${6}}")
cuty=$(awk "BEGIN {printf \"%.2f\", ${6}}")
cutz=$(awk "BEGIN {printf \"%.2f\", ${6}}")
gmx editconf -f 6_$name.gro -o 7_$name.gro -box $cutx $cuty $cutz 
