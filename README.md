# CHIRP

## Preparations and TSQL Code for creating a database and warehouse

### i2b2

I have been reviewing the i2b2 CRC Design Document.
It seems to be a good reference, but contains many items
which I would prefer not too use.  As such, it will stay just that.
A reference.

Ultimately, this database will contain a great deal of raw
data acquired from a number of sources.
This raw data will be selected and placed into a star or snowflake
schema data warehouse.

As all/most data warehouses are centered around a fact table,
so shall this one.  This central fact will be an "observation"
much like the i2b2.


From this point on, I am just brainstorming / rambling.



Observation (fact)
* Of What/Whom? (patient dimension [names,???])
* Who made it? (provider dimension [doctor,nurse,???])
* Where was it made? (location dimension [WalGreens,Renown Hospital,ER,???])
* When was it made? (time dimension / visit dimension?)
* What was made? (concept dimension)
* How was it made? (not sure what I mean here)
* value of observation


I suppose in practice, every attribute on a birth certificate
and any other type of observation
needs to be accurately recordable in this system.
What don't we record?
* height
* weight
* race
* income
* vaccination
* surgery
* cholesterol level
* pulse
* blood pressure
* just visited doctor to say hello?
* broken arm
* incarcerated?
* changed address?
* changed phone number?











