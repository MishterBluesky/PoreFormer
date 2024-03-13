#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <protein1.gro> <protein2.gro>"
    exit 1
fi

# Input gro files
protein1_gro="$1"
protein2_gro="$2"

# Output files
protein1_com="protein1_com.zvg"
protein2_com="protein2_com.zvg"

# Step 1: Calculate center of mass for each protein
gmx editconf -f "$protein1_gro" -o temp_protein1.gro -center 0 0 0
gmx editconf -f "$protein2_gro" -o temp_protein2.gro -center 0 0 0
gmx trjconv -f temp_protein1.gro -s temp_protein1.gro -o temp_protein1.gro -center 0 0 0
gmx trjconv -f temp_protein2.gro -s temp_protein2.gro -o temp_protein2.gro -center 0 0 0

gmx editconf -f temp_protein1.gro -o temp_protein1.gro -center 0 0 0 -princ
gmx editconf -f temp_protein2.gro -o temp_protein2.gro -center 0 0 0 -princ

gmx gyrate -f temp_protein1.gro -s temp_protein1.gro -o "$protein1_com" -n index.ndx
gmx gyrate -f temp_protein2.gro -s temp_protein2.gro -o "$protein2_com" -n index.ndx

# Step 2: Extract COM z-coordinates and calculate difference
protein1_com_z=$(awk '{if ($1 != "@" && $1 != "#" && NF) print $2}' "$protein1_com")
protein2_com_z=$(awk '{if ($1 != "@" && $1 != "#" && NF) print $2}' "$protein2_com")

# Calculate difference in z-position
difference_z=$(awk 'BEGIN {sum=0} {sum+=$1} END {print sum/NR}' <(paste <(echo "$protein1_com_z") <(echo "$protein2_com_z" ) | awk '{print $2 - $1}'))

# Output results
echo "Average Difference in Z-Position: $difference_z"

# Clean up temporary files
rm temp_protein1.gro temp_protein2.gro
