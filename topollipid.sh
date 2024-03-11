#!/bin/bash

# Define the .gro file and output topol.top file names
gro_file="$1"
topol_file="topol.top"

# Check if input files exist
if [ ! -f "$gro_file" ]; then
    echo "Error: $gro_file does not exist."
    exit 1
fi

# Initialize arrays to store counts for different molecules
declare -A molecule_counts
declare -A division_values=(
    ["POPG"]=12
    ["POPE"]=12
    ["CDL1"]=27
)

# Create the topol.top file with the header
{
    echo '#include "martini_v3.0.0.itp"'
    echo '#include "martini_v3.0_CDLs.itp"'
    echo '#include "martini_v3.0.0_ions_v1.itp"'
    echo '#include "martini_v3.0.0_solvents_v1.itp"'
    echo '#include "martini_v3.0.0_phospholipids_v1.itp"'
    echo "[system]"
    echo 'This system topolfile was made by topollipid.sh'
    echo '[molecules]'
    echo '; name  number'
} > "$topol_file"

# Initialize variables to keep track of the current molecule
current_molecule=""
current_count=0

# Read the .gro file line by line
while IFS= read -r line
do
    # Extract the molecule name using grep
    molecule_name=$(echo "$line" | grep -o -E "POPG|POPE|CDL1")
    
    if [ -n "$molecule_name" ]; then
        if [ "$molecule_name" != "$current_molecule" ]; then
            if [ "$current_count" -gt 0 ]; then
                echo "$current_molecule        $current_count" >> "$topol_file"
            fi
            
            echo "Okay lipid person, I am reading the .gro file you gave me and adding $molecule_name to the topol file now"
            
            current_molecule="$molecule_name"
            current_count=0
        fi
        
        current_count=$((current_count + 1))
    fi
done < "$gro_file"

# Add the last molecule to the topol.top file
if [ "$current_count" -gt 0 ]; then
    echo "$current_molecule        $current_count" >> "$topol_file"
fi

# Create a temporary topol.top file to store the modified counts
tmp_topol_file="tmp_topol.top"

# Read the original topol.top file and divide the counts
while IFS= read -r line
do
    molecule_name=$(echo "$line" | awk '{print $1}')
    count=$(echo "$line" | awk '{print $2}')

    if [[ ${division_values[$molecule_name]+_} ]]; then
        division_factor=${division_values[$molecule_name]}
        count=$((count / division_factor))
    fi

    echo "$molecule_name        $count" >> "$tmp_topol_file"
done < "$topol_file"

# Replace the original topol.top file with the modified one
mv "$tmp_topol_file" "$topol_file"
