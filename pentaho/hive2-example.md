# Start Pentaho Spoon
1. ssh into bigfoot with X11-Forwarding enabled

    For examples in Linux or Mac,
    ```
    $ ssh -X bigfoot.ccs.miami.edu
    ```
    If login from Mac, make sure your local x-server started. XQuartz is an open source x-server on Mac.
2. change to Pentaho directory

    Pentaho is installed on bigfoot user node localy and configured to communicate with bigfoot hadoop cluster components through kerberos.
    ```
    $ cd /opt/data-integration/
    ```
    
3. start spoon

    start spoon from command line in your login session.
    ```
    $ ./spoon.sh
    ```
    Pentaho spoon GUI should start.

# Create New Job
1. configure Hadoop cluster
2. configure Database connection
3. create workflow
4. run test job
