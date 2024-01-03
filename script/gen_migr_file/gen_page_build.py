import os
import shutil

# Specify the starting directory (change as needed)
starting_directory = "../../../"  # This goes three directories back from the script's location

# Specify the name of your text file with file paths
input_file = "difference_page.txt"  # Replace with the actual name of your text file

# Read file paths from the input file
with open(input_file, 'r') as file:
    file_paths = file.read().splitlines()

# Create copies of each file found three directories back
for file_path in file_paths:
    # Form the absolute path based on the starting directory
    real_path = (starting_directory + file_path).replace("/", "\\")

    try:
        if os.path.isfile(real_path):
            # Create destination directory if it does not exist
            destination_dir = os.path.dirname(file_path)
            os.makedirs(destination_dir, exist_ok=True)
            
            # Copy the file
            shutil.copy(real_path, file_path)
            print(f"Copied {file_path}")
        else:
            print(f"File not found: {real_path}")
    except Exception as e:
        print(f"Error copying {real_path}: {e}")

print("Script completed")