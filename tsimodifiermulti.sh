#!/bin/bash

# Main script
tsi_file="$1"
output_file="modified.tsi"
protein_no="$2"
vertex="$3"
vertex2="$4"

# Counter for additional lines
additional_lines=0

# Temporary file for modifications
temp_file=$(mktemp)

# Replace 'inclusion 0' with 'inclusion 2'
sed -e "s/inclusion\s*0/inclusion 2/" "$tsi_file" > "$temp_file"

# Append additional lines
echo "0   1   $vertex  0   1" >> "$temp_file"
echo "1   2   $vertex2  0   1" >> "$temp_file"

# Count the number of additional lines added
additional_lines=$(grep -c "1\s*$vertex" "$temp_file")

# Copy the modified content to the output file
cp "$temp_file" "$output_file"

# Print the number of additional lines added
echo "Added $additional_lines additional lines."

# Remove the temporary file
rm "$temp_file"

# Debug message
echo "Output file: $output_file"
