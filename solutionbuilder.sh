
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
name=$2
protein_pdb=$4
protein_number=$5
workdir=$7
Poredir=$8
translate=$9
scale=${6}
scale_z=${6}
cutx=$(awk "BEGIN {printf \"%.2f\", ${6}}")
cuty=$(awk "BEGIN {printf \"%.2f\", ${6}}")
cutz=$(awk "BEGIN {printf \"%.2f\", ${6}}")
./martinishcolab.sh $name $protein_pdb $workdir $Poredir $9

gmx editconf -f 6_$name.gro -o 7_$name.gro -box $cutx $cuty $cutz 

    


