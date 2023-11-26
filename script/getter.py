import os
import sys
import shutil

folder_name = sys.argv[1]
file_name = sys.argv[2]

# List all files in the folder
folders = os.listdir(folder_name)

# Iterate through the files
for folder in folders:
    src_path = "./" + folder_name + "/" + folder + "/" + file_name + ".pdf"
    dest_path = "./get/" + folder + ".pdf"
    if os.path.exists(src_path):
        shutil.copy(src_path, dest_path)

