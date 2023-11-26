import csv
import os 
import sys

# TODO 

def raw2data(folder_dir, file_name):
    data = []
    dir = folder_dir + '/' + file_name
    with open(dir, 'r') as file:
        csv_reader = csv.reader(file)
        for row in csv_reader:
            data.append(row)
    
    return data

def write2file(file_name, data, label):

    for row in data:
        dest_path = DATDIR + '/' + row[0]

        if not os.path.exists(dest_path):
            os.mkdir(dest_path)

        dest_file = dest_path + '/' + file_name + '.dat'
        file = open(dest_file, 'w')
        for i in range(len(row)-1):
            output_line = row[i+1] + " " + label[i+1] + "\n"
            file.write(output_line)

TOPDIR = os.path.abspath(os.getcwd())
RAWDIR = TOPDIR + "/raw"
DATDIR = TOPDIR + "/dat"

file_name = sys.argv[1]

data = raw2data(RAWDIR, file_name + '.csv')

label = data[0]
data.pop(0)

write2file(file_name, data, label)
