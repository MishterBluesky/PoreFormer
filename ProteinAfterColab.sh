
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
name=$2



current_value=$start_value
 
    # Step 9
    gmx grompp -f em.mdp -o emx_$name -c 7_Lipidx_$name.gro -p topol.top -maxwarn 1000

    # Step 10
    gmx_d mdrun -deffnm emx_$name -v

    # Step 11
    gmx solvate -cs water.gro -o 8_Lipidx_$name.gro -radius 0.21 -cp emx_$name.gro -p topol.top

    # Step 12
    gmx grompp -f em.mdp -o 9_Lipidx_$name -c 8_Lipidx_$name.gro -maxwarn 1000

    # Step 13
    gmx_d mdrun -deffnm 9_Lipidx_$name -v

    # Step 14
    gmx grompp -f em.mdp -o neutral_$name.tpr -p topol.top -c 9_Lipidx_$name.gro -maxwarn 1000

    # Step 15
    gmx genion -s neutral_$name.tpr -o 10_Lipidx_$name.pdb -p topol.top -neutral

    # Step 16
    gmx grompp -f em.mdp -o 11_Lipid20x_$name.tpr -p topol.top -c 10_Lipidx_$name.pdb -maxwarn 1000

    # Step 17
    gmx_d mdrun -deffnm 11_Lipid20x_$name -v

    mkdir $name

    # Step 19
    gmx grompp -f mdp_files/cgmdprepx-p.mdp -o 11b_Lipid20_$name.tpr -c 11_Lipid20x_$name.gro -p topol.top -maxwarn 1000

    # Step 17
    gmx_d mdrun -deffnm 11b_Lipid20_$name -v

    # Step 19
    
    gmx grompp -f mdp_files/cgmd-1us-2024tpr-p.mdp -o $name/12_md20_$name -c 11b_Lipid20_$name.gro -p topol.top -maxwarn 1000
    mv topol.top > APL20bac_$name

    # Step 20




