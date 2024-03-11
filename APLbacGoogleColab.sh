
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
end_value=$1
echo "APL script initiated with APL value $1.. loading"
# Loop to create input.str files and carry out subsequent steps
current_value=$start_value


    # Step 3
    ./PLM -TSfile 3_Bigcare.tsi -Mashno 3 -bilayerThickness 4.3 -rescalefactor 2 2 2 -o 4_Lipidx_$current_value

    # Create input.str file
    echo -e "[Lipids List]\nDomain 0\nPOPG 0.2 0.2 $current_value\\nPOPE 0.78 0.78 $current_value\nCDL1 0.02 0.02 $current_value\nEnd" > inputx_$current_value.str

    # Step 4

    ./PCG -dts 4_Lipidx_$current_value -str inputx_$current_value.str -seed 1 -Bondlength 0.4 -LLIB Martini3.LIB -defout 5_Lipidx_$current_value

    # Step 5
    python << END
import numpy as np
import MDAnalysis as mda
u = mda.Universe('5_Lipidx_$current_value.gro')
ag = u.select_atoms("byres ((prop abs y < 705) and (prop abs y > 315) and (prop abs z < 705) and (prop abs z > 315)) ")
ag.write('6_Lipidx_$current_value.gro')
END

    # Step 6


    # Step 7
    gmx editconf -f 6_Lipidx_$current_value.gro -o 7_Lipidx_$current_value.gro -box 40.5 40.5 80 -rotate 0 90 0

    # Step 8
    ./topollipid.sh 7_Lipidx_$current_value.gro
    # Step 9
    gmx grompp -f em.mdp -o emx_$current_value -c 7_Lipidx_$current_value.gro -p topol.top

    # Step 10
    gmx_d mdrun -deffnm emx_$current_value -v

    # Step 11
    gmx solvate -cs ~/water.gro -o 8_Lipidx_$current_value.gro -radius 0.21 -cp emx_$current_value.gro -p topol.top

    # Step 12
    gmx grompp -f em.mdp -o 9_Lipidx_$current_value -c 8_Lipidx_$current_value.gro

    # Step 13
    gmx_d mdrun -deffnm 9_Lipidx_$current_value -v

    # Step 14
    gmx grompp -f em.mdp -o neutral_$current_value.tpr -p topol.top -c 9_Lipidx_$current_value.gro 

    # Step 15
    gmx genion -s neutral_$current_value.tpr -o 10_Lipidx_$current_value.pdb -p topol.top -neutral

    # Step 16
    gmx grompp -f em.mdp -o 11_Lipid20x_$current_value.tpr -p topol.top -c 10_Lipidx_$current_value.pdb

    # Step 17
    gmx_d mdrun -deffnm 11_Lipid20x_$current_value -v

    mkdir APL20bac_$current_value

    # Step 19
    gmx grompp -f mdp_files/cgmdprepx.mdp -o 11b_Lipid20_$current_value.tpr -c 11_Lipid20x_$current_value.gro -p topol.top

    # Step 17
    gmx_d mdrun -deffnm 11b_Lipid20_$current_value -v

    # Step 19
    
    gmx grompp -f mdp_files/cgmd-10us-2024tpr.mdp -o APL20bac_$current_value/12_md20_$current_value -c 11b_Lipid20_$current_value.gro -p topol.top
	 mv topol.top > APL20bac_$current_value





