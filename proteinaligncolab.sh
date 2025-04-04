
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
name=$2
tsi_file=$3
protein_pdb=$4
protein_number=$5
vertex_1=$6
workdir=$7
Poredir=$8
translate=$9
scale=${10}
scale_z=${11}
max=$(awk "BEGIN {printf \"%.2f\", 705 * ${10}}")
min=$(awk "BEGIN {printf \"%.2f\", 315 * ${10}}")
cutx=$(awk "BEGIN {printf \"%.2f\", 40.5 * ${10}}")
cuty=$(awk "BEGIN {printf \"%.2f\", 40.5 * ${10}}")
cutz=$(awk "BEGIN {printf \"%.2f\", 80 * ${11}}")
cardio=${12}
popg=${13}
pope=${14}
./tsimodifier.sh $tsi_file $protein_number $vertex_1
./martinishcolab.sh $name $protein_pdb $workdir $Poredir $9


current_value=$start_value
    # Step 2
    ./compile.sh

    # Step 3
    ./PLM -TSfile modified.tsi -Mashno 4 -bilayerThickness 4.3 -rescalefactor 2 2 2 -o 4_Lipidx_$current_value

    # modify the existing str file
    echo  -e "[Lipids List]\nDomain 0\nPOPG $popg $popg $current_value\\nPOPE $pope $pope $current_value\nCDL1 $cardio $cardio $current_value\nEnd" >> $name.str

    # Step 4

    ./PCG -dts 4_Lipidx_$current_value -str $name.str -seed 1 -Bondlength 0.4 -LLIB Martini3.LIB -defout 5_Lipidx_$current_value

    # Step 5
    python << END
import numpy as np
import MDAnalysis as mda
u = mda.Universe('5_Lipidx_$current_value.gro')
ag = u.select_atoms("byres ((prop abs y < $max) and (prop abs y > $min) and (prop abs z < $max) and (prop abs z > $min)) ")
ag.write('6_$name.gro')
END


    # Step 7
    gmx editconf -f 6_$name.gro -o 7_Lipidx_$name.gro -box $cutx $cuty $cutz -rotate 0 90 0

    # Step 19
    



