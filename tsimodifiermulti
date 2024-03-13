#!/bin/bash

# Function to increment protein_no
increment_protein_no() {
    protein_no=$((protein_no + 1))
}

# Function to increment vertex
increment_vertex() {
    vertex=$((vertex + 1))
}

# Main script
tsi_file=$1
output_file="modified.tsi"
protein_no=$2
vertex=$3
vertex2=$4

# Counter for additional lines
additional_lines=0

# Flag to track if 'inclusion $2' is found
found_inclusion=false

# Temporary file for modifications
temp_file=$(mktemp)

# Replace 'inclusion 0' with 'inclusion $2' and append additional lines
sed -e "/inclusion	0/ { 
            s/inclusion	0/inclusion	$2/
            a\\
0   1   $vertex  0   1
1   2   $vertex2  0   1
            :loop
            \$!{
                s/.*/$((++i))   1   $vertex  0   1/
                b loop
            }
        }" "$tsi_file" > "$temp_file"



# Copy the modified content to the output file
cp "$temp_file" "$output_file"

# Print the number of additional lines added
additional_lines=$(grep -c "1   $vertex" "$temp_file")
echo "Added $additional_lines additional lines."

# Remove the temporary file
rm "$temp_file"

# Debug message
echo "Output file: $output_file"
