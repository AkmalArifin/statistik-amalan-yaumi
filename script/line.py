import os 
import sys
import re

RANGE = 1000 # cdf graph per 100 us

def combine_log(file_name, folder_name):

    # Open and read file
    dir = RAWDIR + '/' + folder_name + '/' + file_name
    file = open(dir, 'r', encoding="utf-8", errors="ignore")

    # Pass data to log
    log = []

    for line in file:
        parse_line = line.split(",")
        parse_line[-1] = parse_line[-1].replace('\n', '')
        to_int = [int(string) for string in parse_line]
        log.append(to_int)

    file.close()

    # Count highest index
    highest_count = 0
    cur_count = 1
    numjobs = 1
    for i in range(1, len(log)):
        prev_line = log[i-1]
        line = log[i]
        if (line[0] > prev_line[0]):
            cur_count += 1
        else:
            highest_count = max(highest_count, cur_count)
            cur_count = 1
            numjobs += 1

    highest_count = max(highest_count, cur_count)

    # create new log
    new_log = [[(i+1)*1000, 0] for i in range(highest_count)]

    # Create based on highest index
    for line in log:
        idx = int(line[0]/1000) - 1
        if (idx < highest_count):
            try:
                new_log[idx][1] += line[1]
            except:
                print(idx)

    return new_log

def average_log(file_name, folder_name):

    # Open and read file
    dir = RAWDIR + '/' + folder_name + '/' + file_name
    file = open(dir, 'r', encoding='utf-8', errors='ignore')

    # Pass data to log
    log = []

    for line in file:
        parse_line = line.split(",")
        parse_line[-1] = parse_line[-1].replace('\n', '')
        to_int = [int(string) for string in parse_line]
        log.append(to_int)

    file.close()

    # Count highest index
    highest_count = 0
    cur_count = 1
    numjobs = 1
    for i in range(1, len(log)):
        prev_line = log[i-1]
        line = log[i]
        if (line[0] > prev_line[0]):
            cur_count += 1
        else:
            highest_count = max(highest_count, cur_count)
            cur_count = 1
            numjobs += 1

    highest_count = max(highest_count, cur_count)

    # create new log
    new_log = [[(i+1)*1000, 0] for i in range(highest_count)]  

    # Create based on highest index
    for line in log:
        idx = int(line[0]/1000) - 1
        if (idx < highest_count):
            try:
                new_log[idx][1] += line[1]
            except:
                print(idx)

    for line in new_log:
        line[1] = line[1]/numjobs

    return new_log

# TODO: Fix cdf log
def cdf_log(log):
    # sort latency
    log.sort(key=lambda x: x[1])

    # for line in log:
    #     print(line)

    new_log = []
    new_log.append([0, log[0][1]])
    
    iter_lat = log[0][1]
    # print("Iter lat", iter_lat)
    total = len(log)
    for i in range(len(log)):
        if (iter_lat + RANGE < log[i][1]):
            prob = (i+1)/total
            new_log.append([prob, log[i-1][1]])
            iter_lat = log[i][1]

    # new_log.append([1.0, log[total-1][1]])

    # for line in new_log:
    #     print(line)
    return new_log

def write_file(log, file_name, folder_name):
    dest_path = DATDIR + '/' + folder_name
    if not os.path.exists(dest_path):
        os.mkdir(dest_path)

    dest_file = dest_path + '/' + file_name + '.dat'
    file = open(dest_file, 'w')

    for line in log:
        output_line = '  '.join(str(x) for x in line)
        output_line += '\n'
        file.write(output_line)


TOPDIR = os.path.abspath(os.getcwd())
RAWDIR = TOPDIR + "/raw"
DATDIR = TOPDIR + "/dat"

folder_name = sys.argv[1]
graph = sys.argv[2]
data = sys.argv[3]
target_folder_name = sys.argv[4]

data1 = data.split("-")[0]
data2 = data.split("-")[1]
data2.replace("\n", "")
pattern = r"_{}\.log$".format(data1)

results_log = []

for file_name in os.listdir(RAWDIR + '/' + folder_name):
    result = re.search(pattern,file_name)
    if (result):
        print(file_name)
        if data1 == "iops" or data1 == "bw":
            output = combine_log(file_name, folder_name)
        elif data1 == "lat":
            output = average_log(file_name, folder_name)
            if data2 == "cdf":
                output = cdf_log(output)
        else:
            print("Data is unknown")
            exit
        
        write_file(output, file_name, target_folder_name)