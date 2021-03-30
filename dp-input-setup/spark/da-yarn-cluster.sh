#!/bin/sh
set -x

# first time create spark log directory on hdfs
hadoop fs -mkdir /spark-logs 
hadoop fs -mkdir /spark-data 
hadoop fs -copyFromLocal /opt/data/spark/jars/data-input.txt /spark-data/


#run a simple spark jar in yarn cluster
/opt/spark/bin/spark-submit \
  --verbose \
  --name DaPlatformSparkSample \
  --queue default \
  --class com.daplatform.spark.DaSparkEngineJob \
  --master yarn \
  --deploy-mode cluster \
  --conf spark.hadoop.yarn.timeline-service.enabled=false \
  --conf spark.sql.warehouse.dir=/apps/hive/warehouse \
  --conf spark.yarn.appMasterEnv.HADOOP_USER_NAME=root \
  --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
  /opt/data/spark/jars/da-platform-spark-0.0.1-SNAPSHOT.jar \
  hdfs:///cms_bene_stats_diabetes/orc \
  hdfs:///cms_diabetes_claim_totals/orc \
  hdfs:///spark-data/data-input.txt