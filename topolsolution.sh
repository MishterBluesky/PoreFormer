#!/bin/bash

# Define the .gro file and output topol.top file names
gro_file="$1"
topol_file="topol.top"
name=$2
number=$3

# Check if input files exist
if [ ! -f "$gro_file" ]; then
    echo "Error: $gro_file does not exist."
    exit 1
fi

# Create the topol.top file with the header
{
    echo '#include "martini_v3.0.0.itp"'
    echo '#include "martini_v3.0_CDLs.itp"'
    echo '#include "martini_v3.0.0_ions_v1.itp"'
    echo '#include "martini_v3.0.0_solvents_v1.itp"'
    echo '#include "martini_v3.0.0_phospholipids_v1.itp"'

    # Include all additional .itp files except martini ones
    for itp_file in *.itp; do
        if [[ ! "$itp_file" == *martini* ]]; then
            echo "#include \"$itp_file\""
        fi
    done

    echo ""
    echo "[ system ]"
    echo "This system topolfile was made by topolsolution.sh"
    echo ""
    echo "[ molecules ]"
    echo "; name  /number"

    # Extract molecule names dynamically from molecule_*.itp files
    for itp_file in molecule_*.itp; do
        if [[ -f "$itp_file" ]]; then
            molecule_name=$(basename "$itp_file" .itp)
            echo "$molecule_name $number"
        fi
    done
} > "$topol_file"

echo "Topology file '$topol_file' created successfully."
