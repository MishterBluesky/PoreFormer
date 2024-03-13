#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <protein_with_dum.pdb> <output_file.txt>"
    exit 1
fi

# Input pdb file
protein_with_dum="$1"

# Output file
output_file="$2"

# Calculate center of mass for carbon backbone atoms
backbone_com=$(awk '/^ATOM/ && $3 == "C" {sum+=$7; count++} END {printf "%.6f", sum/count}' "$protein_with_dum")

# Difference in z-position between backbone COM and DUM oxygen z-coordinate (15)
difference_z=$(echo "$backbone_com 15" | awk '{printf "%.2f", $2 - $1}')

echo "Backbone COM: $backbone_com"
echo "Difference in z-position: $difference_z"

# Output the result to the specified output file
echo "Backbone COM: $backbone_com" > "$output_file"
echo "Difference in z-position: $difference_z" >> "$output_file"

echo "Difference calculation complete. Result saved in $output_file"
