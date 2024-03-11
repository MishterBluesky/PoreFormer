
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
name=$2
tsi_file=$3
protein_pdb=$4
ssh=$5
protein_number=$6
vertex_1=$7

./tsimodifier.sh $tsi_file $protein_number $vertex_1
./martinish.sh $name $protein_pdb $ssh


current_value=$start_value
    # Step 2
    ./compile.sh

    # Step 3
    ./PLM -TSfile modified.tsi -Mashno 3 -bilayerThickness 4.3 -rescalefactor 2 2 2 -o 4_Lipidx_$current_value

    # modify the existing str file
    echo  -e "[Lipids List]\nDomain 0\nPOPG 0.2 0.2 $current_value\\nPOPE 0.78 0.78 $current_value\nCDL1 0.02 0.02 $current_value\nEnd" >> $name.str

    # Step 4

    ./PCG -dts 4_Lipidx_$current_value -str $name.str -seed 1 -Bondlength 0.4 -LLIB Martini3.LIB -defout 5_Lipidx_$current_value
    module purge
    module load GCC/11.3.0 OpenMPI/4.1.4 MDAnalysis
    # Step 5
    python << END
import numpy as np
import MDAnalysis as mda
u = mda.Universe('5_Lipidx_$current_value.gro')
ag = u.select_atoms("byres ((prop abs y < 705) and (prop abs y > 315) and (prop abs z < 705) and (prop abs z > 315)) ")
ag.write('6_$name.gro')
END

    module purge
    module load GCC/11.2.0 OpenMPI/4.1.1 GROMACS/2021.5-PLUMED-2.8.0

    # Step 7
    gmx editconf -f 6_$name.gro -o 7_Lipidx_$name.gro -box 40.5 40.5 80 -rotate 0 90 0

    # Step 8
    ./topollipidp.sh 7_Lipidx_$name.gro $name $6
    # Step 9
    gmx grompp -f em.mdp -o emx_$name -c 7_Lipidx_$name.gro -p topol.top

    # Step 10
    gmx_d mdrun -deffnm emx_$name -v

    # Step 11
    gmx solvate -cs ~/water.gro -o 8_Lipidx_$name.gro -radius 0.21 -cp emx_$name.gro -p topol.top

    # Step 12
    gmx grompp -f em.mdp -o 9_Lipidx_$name -c 8_Lipidx_$name.gro

    # Step 13
    gmx_d mdrun -deffnm 9_Lipidx_$name -v

    # Step 14
    gmx grompp -f em.mdp -o neutral_$name.tpr -p topol.top -c 9_Lipidx_$name.gro 

    # Step 15
    gmx genion -s neutral_$name.tpr -o 10_Lipidx_$name.pdb -p topol.top -neutral

    # Step 16
    gmx grompp -f em.mdp -o 11_Lipid20x_$name.tpr -p topol.top -c 10_Lipidx_$name.pdb

    # Step 17
    gmx_d mdrun -deffnm 11_Lipid20x_$name -v

    mkdir $name

    # Step 19
    gmx grompp -f mdp_files/cgmdprepx-p.mdp -o 11b_Lipid20_$name.tpr -c 11_Lipid20x_$name.gro -p topol.top

    # Step 17
    gmx_d mdrun -deffnm 11b_Lipid20_$name -v

    # Step 19
    
    gmx grompp -f mdp_files/cgmd-10us-2024tpr-p.mdp -o $name/12_md20_$name -c 11b_Lipid20_$name.gro -p topol.top
    mv topol.top > APL20bac_$name

    # Step 20
    cd $name
    gmx mdrun -deffnm 12_md20_$name -v -nt 16



