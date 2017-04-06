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
* copy to home directory in `bigfoot`
    ```
    $ cd ..
    $ hadoop fs -put PGYR15
    ```

