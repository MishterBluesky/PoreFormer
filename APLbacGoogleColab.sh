
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
end_value=$1
tsi=$2
scale=$3
max=$(awk "BEGIN {printf \"%.2f\", 915 * $3}")
min=$(awk "BEGIN {printf \"%.2f\", 405 * $3}")
cutx=$(awk "BEGIN {printf \"%.2f\", 50.5 * $3}")
cuty=$(awk "BEGIN {printf \"%.2f\", 50.5 * $3}")
cutz=$(awk "BEGIN {printf \"%.2f\", 80 * $4}")
echo "APL script initiated with APL value $1.. loading"
# Loop to create input.str files and carry out subsequent steps
current_value=$start_value


    # Step 3
    ./PLM -TSfile $2 -Mashno 3 -bilayerThickness 4.3 -rescalefactor 2 2 2 -o 4_Lipidx_$current_value

    # Create input.str file
    echo -e "[Lipids List]\nDomain 0\nPOPG $6 $6 $current_value\\nPOPE $5 $5 $current_value\nCDL1 $7 $7 $current_value\nEnd" > inputx_$current_value.str

    # Step 4

    ./PCG -dts 4_Lipidx_$current_value -str inputx_$current_value.str -seed 1 -Bondlength 0.4 -LLIB Martini3.LIB -defout 5_Lipidx_$current_value

    # Step 5
    python << END
import numpy as np
import MDAnalysis as mda
u = mda.Universe('5_Lipidx_$current_value.gro')
ag = u.select_atoms("byres ((prop abs y < $max) and (prop abs y > $min) and (prop abs z < $max) and (prop abs z > $min)) ")
ag.write('6_Lipidx_$current_value.gro')
END



    # Step 6
    gmx editconf -f 6_Lipidx_$current_value.gro -o 7_Lipidx_$current_value.gro -box $cutx $cuty $cutz -rotate 0 90 0
echo "max: $max"
echo "Value of \$3: $3"
echo "$scale"

