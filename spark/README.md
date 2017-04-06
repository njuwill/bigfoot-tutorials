# Spark Tutorials

## Prepare sample data

* download `Complete 2015 Program Year Open Payments Dataset` from [cms.gov](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html) to local computer
* copy zip file to `bigfoot`
    ```
    $ scp PGYR15_P011717.ZIP bigfoot.ccs.miami.edu:
    ```
* login to `bigfoot`
    ```
    $ ssh bigfoot.ccs.miami.edu
    ```
* create a folder and unzip it
    ```
    $ mkdir PGYR15
    $ cd PGYR15
    $ unzip -l ../PGYR15_P011717.ZIP
    $ du -sm .
    6350    .
    ```
    The last command shows the total size of the data after unzipping.
* copy to home directory in `bigfoot`
    ```
    $ cd ..
    $ hadoop fs -put PGYR15
    ```
    This command will push the whole folder to home path inside `bigfoot` `hdfs`. It is then ready for further processing. The folder will be at `/user/USERNAME/PGYR15` in `hdfs`. Make sure you do not have this folder created before. `hadoop fs -put` wont overwrite existing files/directories. We can also specify a specific path as target location. For example, the following command copied data to `/project/public/PGYR15`.
    ```
    $ hadoop fs -put PGYR15 /project/public/
    ```
* check data and practice
    ```
    $ hadoop fs -ls PGYR15
    ```

## Hdfs file management from command line

Practicing data management on bigfoot with hadoop commands
    ```
    # check contents in your home on bigfoot hdfs
    $ hadoop fs -ls

    # create temporary directory for practicing
    $ hadoop fs -mkdir temp

    # copy file
    $ hadoop fs -cp PGYR2015/OP_DTL_OWNRSHP_PGYR2015_P01172017.csv temp

    # check copying result
    $ hadoop fs -ls temp

    # change file name
    $ hadoop fs -mv temp/OP_DTL_OWNRSHP_PGYR2015_P01172017.csv temp/new_file.csv

    # copy file in saem folder
    $ hadoop fs -cp temp/new_file.csv temp/new_file_copy.csv

    # check copying results
    $ hadoop fs -ls temp

    # download file to your bigfoot home
    $ hadoop fs -get temp/new_file.csv

    # check file
    $ ls -l new_file.csv
    $ head new_file.csv
    $ tail new_file.csv

    # remove temporary file from bigfoot home
    $ rm new_file.csv

    # download folder
    $ hadoop fs -get temp

    # check downloading results
    $ ls -l temp

    # remove temporary folder under your bigfoot home
    $ rm -rf temp

    # download folder to a single merged file
    $ hadoop fs -getmerge temp temp.txt

    # check file size
    $ ls -l temp.txt

    # remove temporary file
    $ rm temp.txt

    # remove file in hdfs
    $ hadoop fs -rm temp/new_file.csv

    # check files in hdfs temp folder
    $ hadoop fs -ls temp

    # remove temporary folder on bigfoot hdfs home
    $ hadoop fs -rm -r temp
    
    # check remote hdfs home, temporary folder should be gone
    $ hadoop fs -ls
    ```
    Remove sample data on remote home to save space. The same sample data is available at `/project/public/PGYR15`.

