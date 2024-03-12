
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
name=$2
tsi_file=$3
protein_pdb=$4
protein_number=$5
vertex_1=$6
workdir =$7
Poredir =$8

./tsimodifier.sh $tsi_file $protein_number $vertex_1
./martinish.sh $name $protein_pdb $workdir $Poredir


current_value=$start_value
    # Step 2
    ./compile.sh

    # Step 3
    ./PLM -TSfile modified.tsi -Mashno 3 -bilayerThickness 4.3 -rescalefactor 2 2 2 -o 4_Lipidx_$current_value

    # modify the existing str file
    echo  -e "[Lipids List]\nDomain 0\nPOPG 0.2 0.2 $current_value\\nPOPE 0.78 0.78 $current_value\nCDL1 0.02 0.02 $current_value\nEnd" >> $name.str

    # Step 4

    ./PCG -dts 4_Lipidx_$current_value -str $name.str -seed 1 -Bondlength 0.4 -LLIB Martini3.LIB -defout 5_Lipidx_$current_value

    # Step 5
    python << END
import numpy as np
import MDAnalysis as mda
u = mda.Universe('5_Lipidx_$current_value.gro')
ag = u.select_atoms("byres ((prop abs y < 705) and (prop abs y > 315) and (prop abs z < 705) and (prop abs z > 315)) ")
ag.write('6_$name.gro')
END


    # Step 7
    gmx editconf -f 6_$name.gro -o 7_Lipidx_$name.gro -box 40.5 40.5 80 -rotate 0 90 0

    # Step 19
    



