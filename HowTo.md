#CHIRP IT How-To Guide

##SAS / SQL Server Demonstration

###Database Preparation

A CHIRP TESTING data set is currently stored in a SQL Server database behind the School of Medicine's security walls. It is my current understanding that researchers running SAS on their local machines, and have the SAS ODBC module installed, will NOT be able to access it without having a special account setup in the School of Medicine.

For the moment, I have an account there which allows me to use the Citrix Receiver to connect to https://citrix.medicine.nevada.edu and access "Surgery 2040 - SAS PD". From here, I have access to SQL Server Management Studio to manage and modify a database called "NewbornResearch" that is running on the TSTLIBRA server. I also have access to a fully featured version of SAS.

The "Hospital Compare" database was downloaded from ...

```
https://data.medicare.gov/data/hospital-compare
```

... and imported into our database and will be used for the rest of this demo. Its contents are irrelevant, albeit somewhat related, and its purpose is simply to assist in demonstrating functionality. To isolate its contents, the tables of interest were placed in the "hospitalcompare" schema.

This database contains a number of tables including "HQI_HOSP" which contains some basic contact information and another "HQI_HOSP_HCAHPS" which contains some survey data. I chose to import the entire MDB Access database file, but could have just imported the 2 associated CSV files.


###Check SAS' Ability to Use ODBC Connection

Open SAS and run the following to check whether you will be able to use this new ODBC connection.

```
PROC SETINIT NOALIAS;
RUN;
```

The output should include the line ...

```
---SAS/ACCESS Interface to ODBC
```

If it does not, you will not be able to continue.


###Prepare an ODBC Database Connection

Access to the database from SAS is best done using an ODBC connection so let’s create one.

Click "Start" and then "Control Panel" to open the "Control Panel" window. Type "ODBC" in the search box. Only one option should appear, "Administrative Tools > Set up data sources (ODBC)". Click it to open the "ODBC Data Source Administrator" window.




On the “User DSN” tab, click “Add …”, select “SQL Server” from the list, click “Finish” to return to the “Control Panel”. Give this new source a name, description and type “TSTLIBRA” in the server box. It will not be listed. The name that you choose will be used in your SAS code so I recommend short and simple. I used “myodbc” so I will be using that throughout the rest of this demo. Click “Next” a couple times accepting the defaults. Check the checkbox to “Change the default database to:” “NewbornResearch”. Click “Next” until “Finish” is an option and then click “Finish”. Click “Test Data Source …” to do just that. It should then suggest that the tests were successful. Not sure what to do if they weren’t. Click “OK” and then “OK” again if they were. You should be back at the beginning and see you shiny new ODBC connection on the list. It is editable if you want to review it. We’re done here, so you can click either “OK” or “Cancel” to close the window and then close the “Control Panel” window.
Database Connection

One simple line will give you access to the data in the CHIRP database.

```
LIBNAME mydb ODBC DATASRC=myodbc SCHEMA=hospitalcompare;
```

That’s it. “mydb” is your reference to all of the available tables and views from within the “hospitalcompare” schema. Of course, you could call it something else, but I will be using “mydb” throughout the rest of this memo. SQL Server also allows its databases to contain multiple “schemas” which can be thought of as simply a grouping of tables. Much of the raw data will be grouped into separate schemas for internal clarity. These schemas would need to be used in all of the SQL commands as well adding a layer of complexity. As the data that is intended to be outward facing will be in the default schema “dbo”, we will not need to provide a schema there. There are other options that can be added here, but I have yet to find one that is necessary.



