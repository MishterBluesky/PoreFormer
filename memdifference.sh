#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <protein1.pdb> <protein2.pdb>"
    exit 1
fi

# Input pdb files
protein1_pdb="$1"
protein2_pdb="$2"

# Output files
protein1_com="protein1_com.zvg"
protein2_com="protein2_com.zvg"

# Step 1: Calculate center of mass for each protein
gmx editconf -f "$protein1_pdb" -o temp_protein1.pdb -c
gmx editconf -f "$protein2_pdb" -o temp_protein2.pdb -c

gmx gyrate -f temp_protein1.pdb -s temp_protein1.pdb -o "$protein1_com"
gmx gyrate -f temp_protein2.pdb -s temp_protein2.pdb -o "$protein2_com"

# Step 2: Extract COM z-coordinates and calculate difference
protein1_com_z=$(awk '{if ($1 != "@" && $1 != "#" && NF) print $2}' "$protein1_com")
protein2_com_z=$(awk '{if ($1 != "@" && $1 != "#" && NF) print $2}' "$protein2_com")

# Calculate difference in z-position
difference_z=$(awk 'BEGIN {sum=0} {sum+=$1} END {print sum/NR}' <(paste <(echo "$protein1_com_z") <(echo "$protein2_com_z" ) | awk '{print $2 - $1}'))

# Output results
echo "Average Difference in Z-Position: $difference_z"

# Clean up temporary files
rm temp_protein1.pdb temp_protein2.pdb
