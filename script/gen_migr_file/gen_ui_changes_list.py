import sys

output_name = sys.argv[2] if len(sys.argv) > 2 else sys.argv[1] if len(sys.argv) > 1 else "difference_ui"

input_file_path = "difference_ui.txt"  # Replace with your actual file path
output_file_path = output_name + " (ui).sql"

# Read input file and process lines
with open(input_file_path, 'r') as input_file:
    lines = input_file.readlines()

# Process each line: add prefix, replace "oracle" with "..", and replace "/" with "\"
processed_lines = ['@@' + line.strip().replace("oracle", "..\..").replace("/", "\\") + ';' for line in lines]

# Add a line to turn off SQL*Plus define
processed_lines = ["set define off"] + processed_lines

# Write the processed content to the output file
with open(output_file_path, 'w') as output_file:
    output_file.write('\n'.join(processed_lines))

print(f"Create {output_file_path} successfully")
