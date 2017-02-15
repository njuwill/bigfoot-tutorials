# rstudio

RStudio Server v1.0.44 open source version is available at `http://BIGFOOT_RSTUDIO_HOST:8787`. `BIGFOOT_RSTUDIO_HOST` is the host name of the rstudio node in bigfoot cluster. Open this url in your browser and then login with your bigfoot user name and password.

# Home Directory

The RStudio server share home directory with bigfoot user node. If you have not logged in user node before, please log into user node to create your home directory. Without home directory, your RStudio connection will fail.

# Kerberos Authentication

You can run R scripts without Kerberos authentication if you are using local data from your home directory. If you need use access cluster resource, for example, data in hdfs storage, or impala database, you will need kerberos ticket to proceed.

To finish kerberos authentication, from 'Tool' menu on top, find 'Shell'. Click to get a shell console windown. 

```
$ kinit BIGFOOT_USER_NAME
```

Type in your bigfoot password. If no error message shows up, your kerberos authentication is successful. Your R session now has a valid kerbose ticket. This ticket will expires in 48 hours. You need run this command again to retrieve a new ticket once it expires.

# Library Files

Some examples in this folder require impala jdbc driver. It is available from `/project/public/impala_jdbc_2.5.34.zip` from HDFS on bigfoot. You can download and extract as the following after logging in bigfoot through ssh.

```bash
$ hadoop fs -get /project/public/impala_jdbc_2.5.34.zip
$ unzip impala_jdbc_2.5.34.zip
```
