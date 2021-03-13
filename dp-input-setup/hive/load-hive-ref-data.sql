
CREATE DATABASE IF NOT EXISTS public;

use public;
set hive.support.concurrency=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;


------------------------------------
--  cd_icd_cm table creation
------------------------------------

DROP TABLE IF EXISTS cd_icd_cm_txt PURGE;
CREATE EXTERNAL TABLE cd_icd_cm_txt (
codeid string,
altcodeid string,
isheader int,
shortname string,
longname string,
version string,
diseaseclass string,
ischronic string)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','  
STORED AS TEXTFILE
LOCATION
  'hdfs://namenode:8020/da-data/public/cd_icd_cm/txt'
TBLPROPERTIES(
    'external.table.purge'='true'
);


DROP TABLE IF EXISTS cd_icd_cm PURGE;
CREATE EXTERNAL TABLE cd_icd_cm (
codeid string,
altcodeid string,
isheader int,
shortname string,
longname string,
version string,
diseaseclass string,
ischronic string)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS ORC
LOCATION
  'hdfs://namenode:8020/da-data/public/cd_icd_cm/orc'
TBLPROPERTIES(
    "orc.compress"="SNAPPY",
    "external.table.purge"="true"
);


alter table cd_icd_cm_txt set tblproperties('EXTERNAL'='FALSE');
TRUNCATE TABLE cd_icd_cm_txt;
alter table cd_icd_cm_txt set tblproperties('EXTERNAL'='TRUE');

alter table cd_icd_cm set tblproperties('EXTERNAL'='FALSE');
TRUNCATE TABLE cd_icd_cm;
alter table cd_icd_cm set tblproperties('EXTERNAL'='TRUE');

LOAD DATA LOCAL INPATH '/opt/data/input/_codes/icd_cm_2019.csv' INTO Table cd_icd_cm_txt;
INSERT OVERWRITE TABLE cd_icd_cm SELECT * FROM cd_icd_cm_txt;

