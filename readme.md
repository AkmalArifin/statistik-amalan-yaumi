# Statistik Amalan Yaumi
Auto processing amalan yaumi from csv format to pdf graph. This tools use specific format of csv file to generate multiple graph group by the first column, in my case was name, to individual graph.
The format csv file is the first row is column name, and it will group by the first column, and the rest of column is the amalan yaumi value in format of percent. [Example](https://drive.google.com/drive/folders/1VBYag4xRw9qGeMMOhzVbhz1MvhliTxou?usp=sharing).

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/AkmalArifin/statistik-amalan-yaumi.git
   ```
2. Install dependencies:
   - [Python](https://www.python.org/downloads/)
   - gnuplot
       - Windows:
           - Open gnuplot download link http://www.gnuplot.info/download.html
           - Choose 'primary download site'
           - Downdload the file and install
       - Mac:
           - Open your terminal
           - Type `brew install gnuplot`
       - Linux:
           - Open your terminal
           - Type `sudo apt-get install gnuplot`
     
## Usage
1. Save your csv file in `/raw` folder. Use format `{NUMBER_OF_ORDER}_{MONTH}.csv.` The graph will show according the number of order.
2. Before you start, makesure the other except `/script` and `/raw` is clear. You can use the command below to clear file on those folder.
      ``` bash
      ./clear.sh
      ```
4. To run the file, run the command below Fill your target file in `/raw` folder without the extension. Example `./all.sh 1_Januari`
      ``` bash
      ./all.sh {TARGET_FILE}
      ```
5. Wait until the program finished. It will took a while.
6. After it finished. Check `/get` folder. The file should be there.
7. If you want to make multiple month, just run the programme for other month but don't clear the results. It will automatically add to the existing graph.

## Contact
If there is an error or something, you can always ping me on my instagram [@menujuakmal](https://www.instagram.com/menujuakmal/)
Have Fun!
