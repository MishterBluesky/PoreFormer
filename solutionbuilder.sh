
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
scale=${10}
scale_z=${11}
max=$(awk "BEGIN {printf \"%.2f\", 705 * ${10}}")
min=$(awk "BEGIN {printf \"%.2f\", 315 * ${10}}")
cutx=$(awk "BEGIN {printf \"%.2f\", 40.5 * ${10}}")
cuty=$(awk "BEGIN {printf \"%.2f\", 40.5 * ${10}}")
cutz=$(awk "BEGIN {printf \"%.2f\", 40.5 * ${11}}")
./martinishcolab.sh $name $protein_pdb $workdir $Poredir $9


current_value=$start_value

    # Step 5
    python << END
import numpy as np
import MDAnalysis as mda
u = mda.Universe('5_Lipidx_$current_value.gro')
ag = u.select_atoms("byres ((prop abs y < $max) and (prop abs y > $min) and (prop abs z < $max) and (prop abs z > $min)) ")
ag.write('6_$name.gro')
END


    # Step 7
    gmx editconf -f 6_$name.gro -o 7_$name.gro -box $cutx $cuty $cutz 

    


