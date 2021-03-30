#!/bin/bash

function stop_all_clean_containers() {
    echo "Performing: clean-all"

	docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml down --remove-orphans

	docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -f

	rm -rf $DP_DATA_DIR/data*
	rm -rf $DP_DATA_DIR/job*
	rm -rf $DP_DATA_DIR/name*
	rm -rf $DP_DATA_DIR/livy
	rm -rf $DP_DATA_DIR/yarn
	rm -rf $DP_DATA_DIR/spark*
	rm -rf $DP_DATA_DIR/post*
	rm -rf $DP_DATA_DIR/mysql
	rm -rf $DP_DATA_DIR/knox

 	mkdir $DP_DATA_DIR/spark-proxy
 	mkdir $DP_DATA_DIR/spark-proxy/logs
 	mkdir $DP_DATA_DIR/spark-proxy/jars

 	mkdir $DP_DATA_DIR/spark-client
 	mkdir $DP_DATA_DIR/spark-client/logs
 	mkdir $DP_DATA_DIR/spark-client/jars

	# not currently removing vertica or knime
}


function stop_all_clean_images() {
    echo "Performing: clean-all"

	docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml down --remove-orphans
	docker rmi -f $(docker images --filter=reference="megoldsby/da-platform*" -q)
	docker rmi -f $(docker images --filter=reference="gethue/hue:*" -q)				
	docker rmi -f $(docker images --filter=reference="mysql:5.7" -q)				

	rm -rf $DP_DATA_DIR/*
}

function restart_all_clean() {
    echo "Performing: restart-all"

	stop_all_clean_images

	pull_all_images

	all_ops start

}

function pull_all_images() {
    echo "Performing: pull-all"

    docker pull  megoldsby/da-platform:apache-knox-1.4.0
	docker pull  megoldsby/da-platform:zeppelin-0.8.1-spark2.4
	docker pull  megoldsby/da-platform:spark-livy-2.4.3-hadoop2.7
	docker pull  megoldsby/da-platform:h-base-2.0.0-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:h-namenode-2.0.0-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:h-datanode-2.0.0-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:h-nodemanager-2.0.0-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:h-historyserver-2.0.0-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:h-resourcemanager-2.0.0-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:hive-metastore-postgresql-2.3.0
	docker pull  megoldsby/da-platform:h-hive-base-2.3.8
	docker pull  megoldsby/da-platform:h-hive-server-2.3.8
	docker pull  megoldsby/da-platform:spark-client-2.4.3-hadoop2.10.2-java8
	docker pull  megoldsby/da-platform:spark-proxy-2.4.3-hadoop2.10.2-java8
	docker pull  gethue/hue:latest
	docker pull  mysql:5.7

# I think we still need the vertica DB until we find a replacement
	docker pull  megoldsby/da-platform:vertica-9.2.1-centos7
	docker pull  megoldsby/da-platform:v-loader-9.2.1-centos7
	
}


function hdfs_ops() {
	local operation=$1
	local containergroup=hdfs
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop namenode datanode1
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start namenode datanode1
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start namenode datanode1
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs namenode datanode1
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-datanode*" -q)
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-namenode*" -q)
		rm -rf $DP_DATA_DIR/namenode
		rm -rf $DP_DATA_DIR/datanode1
		rm -rf $DP_DATA_DIR/datanode2
		rm -rf $DP_DATA_DIR/datanode3
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull namenode datanode1		
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs namenode datanode1
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start namenode datanode1
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start namenode datanode1
	fi
}

function hdfs_ops_3() {
	local operation=$1
	local containergroup=hdfs
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop namenode datanode1 datanode2 datanode3
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start namenode datanode1 datanode2 datanode3
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start namenode datanode1 datanode2 datanode3
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs namenode datanode1 datanode2 datanode3
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-datanode*" -q)
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-namenode*" -q)
		rm -rf $DP_DATA_DIR/namenode
		rm -rf $DP_DATA_DIR/datanode1
		rm -rf $DP_DATA_DIR/datanode2
		rm -rf $DP_DATA_DIR/datanode3
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull namenode datanode1 datanode2 datanode3		
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs namenode datanode1 datanode2 datanode3
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start namenode datanode1 datanode2 datanode3
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start namenode datanode1 datanode2 datanode3
	fi
}

# Updated function to include ${DP_SETUP_DIR}/docker-compose.yml
function spark_livy_ops() {
	local operation=$1
	local containergroup=spark-livy
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop spark-livy
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start spark-livy
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start spark-livy
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs spark-livy
		rm -rf $DP_DATA_DIR/livy
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:spark-l*" -q)
	elif [ "$operation" = "build" ]; then
		echo "Not avilable"	
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull spark-livy 			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs spark-livy 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start spark-livy
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start spark-livy
	fi
}

function spark_proxy_ops() {
	local operation=$1
	local containergroup=spark-proxy
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop spark-proxy
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		mkdir $DP_DATA_DIR/spark-proxy
 		mkdir $DP_DATA_DIR/spark-proxy/logs
 		mkdir $DP_DATA_DIR/spark-proxy/jars

		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start spark-proxy
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start spark-proxy
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs spark-proxy
		rm -rf $DP_DATA_DIR/spark-proxy
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:spark-p*" -q)
	elif [ "$operation" = "build" ]; then
		echo "Not avilable"	
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull spark-proxy 			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		rm -rf $DP_DATA_DIR/spark-proxy
		mkdir $DP_DATA_DIR/spark-proxy
 		mkdir $DP_DATA_DIR/spark-proxy/logs
 		mkdir $DP_DATA_DIR/spark-proxy/jars
		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs spark-proxy 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start spark-proxy
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start spark-proxy
	fi
}

function apache_knox_ops() {
	local operation=$1
	local containergroup=apache-knox
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop apache-knox
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start apache-knox
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start apache-knox
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs apache-knox
		docker rmi -f $(docker images --filter=reference="apache-knox-docker:*" -q)
		rm -rf $DP_DATA_DIR/knox
	elif [ "$operation" = "build" ]; then
		echo "Not avilable"	
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull apache-knox			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs apache-knox 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start apache-knox
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start apache-knox
	fi
}

# Updated function to include ${DP_SETUP_DIR}/docker-compose.yml
function yarn_ops() {
	local operation=$1
	local containergroup=yarn
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop resourcemanager nodemanager historyserver
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start resourcemanager nodemanager historyserver
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start resourcemanager nodemanager historyserver
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs resourcemanager nodemanager historyserver
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-historyserver*" -q)	
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-nodemanager*" -q)	
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-resourcemanager*" -q)	
		rm -rf $DP_DATA_DIR/yarn
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull resourcemanager nodemanager historyserver 			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs resourcemanager nodemanager historyserver 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start resourcemanager nodemanager historyserver
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start resourcemanager nodemanager historyserver
	fi
}

# Updated function to include ${DP_SETUP_DIR}/docker-compose.yml
function hive_ops() {
	local operation=$1
	local containergroup=hive
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop hive-metastore-postgresql hive-metastore hive-server
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start hive-metastore-postgresql hive-metastore hive-server
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start hive-metastore-postgresql
		echo "pausing 15 secs..."
		sleep 15
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start hive-metastore hive-server
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs hive-metastore-postgresql hive-metastore hive-server
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:h-hive*" -q)	
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:hive-metastore*" -q)	
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull hive-metastore-postgresql hive-metastore hive-server			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs hive-metastore-postgresql hive-metastore hive-server 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start hive-metastore-postgresql hive-metastore hive-server
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start hive-metastore-postgresql hive-metastore hive-server
	fi
}


# Updated function to include ${DP_SETUP_DIR}/docker-compose.yml
function hue_ops() {
	local operation=$1
	local containergroup=hue
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop hue
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start hue
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start hue
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs hue			
		docker rmi -f $(docker images --filter=reference="gethue/hue:*" -q)								
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull hue			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs hue
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start hue
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start hue
	fi
}

# Updated function to include ${DP_SETUP_DIR}/docker-compose.yml
function zeppelin_ops() {
	local operation=$1
	local containergroup=zeppelin
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop zeppelin
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start zeppelin
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start zeppelin
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs zeppelin
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:zeppelin*" -q)	
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull zeppelin			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs zeppelin 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start zeppelin
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start zeppelin
	fi
}


function mysql_db_ops() {
        local operation=$1
        local containergroup=mysql-db

	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop mysql-db
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start mysql-db
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start mysql-db
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs mysql-db			
		docker rmi -f $(docker images --filter=reference="mysql:5.7" -q)				
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull mysql-db			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs mysql-db
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start mysql-db
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start mysql-db
	fi
}

# I think we still need this but do we replace the data locations with something else?
function vertica_ops() {
	local operation=$1
	local containergroup=vertica
	
	echo "In containergroup $containergroup: $operation"
	if [ "$operation" = "stop" ]; then
		echo "Performing stop"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml stop vertica
	elif [ "$operation" = "start" ]; then
		echo "Performing: start"
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start vertica
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start vertica
	elif [ "$operation" = "clean" ]; then
		echo "Performing: clean"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs vertica
		docker rmi -f $(docker images --filter=reference="megoldsby/da-platform:vertica*" -q)
		rm -rf $DP_DATA_DIR/vertica/* 
	elif [ "$operation" = "build" ]; then
		echo "Performing: build **** currently not implemented"				
	elif [ "$operation" = "pull" ]; then
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml pull vertica 			
	elif [ "$operation" = "restart" ]; then
		echo "Performing: restart"		
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml rm -fs vertica
		rm -rf $DP_DATA_DIR/vertica/* 
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml up --no-start vertica
		docker-compose -f ${DP_SETUP_DIR}/docker-compose.yml start vertica
	fi
}

function all_ops() {
	local operation=$1
	local containergroup=all
	
	echo "In containergroup $containergroup: $operation"

	hdfs_ops $operation

	if [ "$operation" != "stop" ]; then
		echo "pausing 20 secs..."
		sleep 20
	fi

	yarn_ops $operation
	
	if [ "$operation" != "stop" ]; then
		echo "pausing 20 secs..."
		sleep 20
	fi

	hive_ops $operation	
	
	if [ "$operation" != "stop" ]; then
		echo "pausing 20 secs..."
		sleep 20
	fi
	
	spark_livy_ops $operation	

	spark_proxy_ops $operation

	mysql_db_ops $operation

	apache_knox_ops $operation
	
	if [ "$operation" != "stop" ]; then
		echo "pausing 20 secs..."
		sleep 20
	fi
}


function container_operations() {
    local operation=$1
    local containergroup=$2
    echo "Performing: $1 for container-group $containergroup"
	echo "DP_DATA_DIR set to: $DP_DATA_DIR"

	if [ "$containergroup" = "platform" ]; then
		all_ops $operation
	elif [ "$containergroup" = "hdfs" ]; then
		hdfs_ops $operation
	elif [ "$containergroup" = "spark-livy" ]; then
		spark_livy_ops $operation
	elif [ "$containergroup" = "spark-proxy" ]; then
		spark_proxy_ops $operation
	elif [ "$containergroup" = "apache-knox" ]; then
		apache_knox_ops $operation
	elif [ "$containergroup" = "yarn" ]; then
		yarn_ops $operation
	elif [ "$containergroup" = "hive" ]; then
		hive_ops $operation											
	elif [ "$containergroup" = "hue" ]; then
		hue_ops $operation							
	elif [ "$containergroup" = "zeppelin" ]; then
		zeppelin_ops $operation
	elif [ "$containergroup" = "vertica" ]; then
		vertica_ops $operation																											
	elif [ "$containergroup" = "mysql-db" ]; then
		mysql_db_ops $operation		
	else
	    echo "Unknown container group must be one of: [platform, hue, zeppelin, vertica]"
	fi
}


if [ "$1" != "" ]; then

    if [ "$1" = "restart-clean-all" ]; then   	
    	restart_all_clean
	elif [ "$1" = "clean-all-containers" ]; then
		stop_all_clean_containers
	elif [ "$1" = "clean-all-images" ]; then	 
    	stop_all_clean_images
	elif [ "$1" = "pull-all" ]; then	 
    	pull_all_images
	elif [ "$2" != "" ]; then	 
		if [ "$1" = "start" ]; then
			container_operations $1 $2
		elif [ "$1" = "stop" ]; then
			container_operations $1 $2
		elif [ "$1" = "clean" ]; then
			container_operations $1 $2
		elif [ "$1" = "build" ]; then
			container_operations $1 $2
		elif [ "$1" = "pull" ]; then
			container_operations $1 $2
		elif [ "$1" = "restart" ]; then
			container_operations $1 $2
		else
		    echo "Unknown command must be one of: [start, stop, restart, clean, build, pull]"
		fi
	else
		if [[ ("$1" = "start") || ("$1" = "stop") || ("$1" = "restart") || ("$1" = "clean") || ("$1" = "pull") || ("$1" = "build")]]; then
	    	echo "2nd parameter required for [start, stop, restart, clean, build, pull]: [platform, hue, zeppelin, vertica]"
		else
			echo "1st parameter must be [pull-all, start, stop, restart, clean, build, pull, restart-clean-all, clean-all-containers, clean-all-images]"
		fi
	fi
else
    
    echo "*******"
    echo "** NOTE: You Must follow the directions in the README to be able to properly setup the platform. "
    echo "** NOTE: clean related functions are destructive - they will remove underlying images"
    echo "*******"
    echo ""
    echo "The following inputs are available :"
    echo ""
    echo "[pull-all]"
    echo "[start] [platform, hue, zeppelin, vertica]"
    echo "[stop] [platform, hue, zeppelin, vertica]"
    echo "[restart] [platform, hue, zeppelin, vertica]"
    echo "[clean] [platform, hue, zeppelin, vertica]"
    echo "[build] [platform, hue, zeppelin, vertica]"
    echo "[pull] [platform, hue, zeppelin, vertica]"
    echo "[restart-clean-all]"
    echo "[clean-all-containers]"
    echo "[clean-all-images]"

fi

