
#!/bin/bash

# Step 1

# Define parameters
start_value=$1
name=$2



current_value=$start_value
 
    # Step 9
    gmx grompp -f em.mdp -o emx_$name -c 7_$name.gro -p topol.top -maxwarn 1000

    # Step 10
    gmx_d mdrun -deffnm emx_$name -v

    # Step 11
    gmx solvate -cs water.gro -o 8_$name.gro -radius 0.21 -cp emx_$name.gro -p topol.top

    # Step 12
    gmx grompp -f em.mdp -o 9_$name -c 8_$name.gro -maxwarn 1000

    # Step 13
    gmx_d mdrun -deffnm 9_$name -v

    # Step 14
    gmx grompp -f em.mdp -o neutral_$name.tpr -p topol.top -c 9_$name.gro -maxwarn 1000

    # Step 15
    echo 16 | gmx genion -s neutral_$name.tpr -o 10_$name.pdb -p topol.top -neutral -conc $3

    # Step 16
    gmx grompp -f em.mdp -o 11_$name.tpr -p topol.top -c 10_$name.pdb -maxwarn 1000

    # Step 17
    gmx_d mdrun -deffnm 11_$name -v

    mkdir $name

    # Step 19
    gmx grompp -f mdp_files/cgmdprepx-protonly.mdp -o 11b_$name.tpr -c 11_$name.gro -p topol.top -maxwarn 1000

    # Step 17
    gmx_d mdrun -deffnm 11b_$name -v

    # Step 19
    
    gmx grompp -f cgmd-500ns-2024tpr-protonly.mdp -o $name/12_md20_$name -c 11b_$name.gro -p topol.top -maxwarn 1000
    mv topol.top > APL20bac_$name




