# Modern Big Data Platform-in-a-box - dpbasic

Modern big data platforms needed for health research are complex systems that require extensive expertise to build and operate. One option is to utilize cloud solutions like Azure or AWS. These systems don’t require an up-front investment in hardware, but they can quickly become extremely expensive as the research effort grows thus eating away at research dollars. However, in many research institutions, computing platforms are readily available for free, but they don’t always keep pace with emerging big data technologies. In addition, many universities are interconnected over very high-speed networks creating even more possibilities for collaboration that are not available in the cloud. However, cloud resources can offer researchers the ability to elastically expand and contract their research platform at a reasonably low cost.

These concepts are the driving force behind why we created a hybrid big data platform-in-a-box. The platform makes it easier and faster for researchers to take advantage of modern technology without having to face the steep learning curve need to build such a platform. This platform-in-a-box is a small download that automates the process of build an advanced big data platform. It will also provide a means to interconnect to supercomputers and cloud resources in future releases. In order to get started, you simply download the platform automation scripts from this gethub repo and follow the steps below.

## 1 - Edit the .bash_profile or equivalent, copy and paste the text between the start and end tags to your .bash_profile or equivalent.
start ------------------------------------------- start
### \# da-platform envs
export DP_HOME_BASIC=~/dp-basic

export DP_DATA_DIR=$DP_HOME_BASIC/dp/docker-data

export DP_SETUP_DIR=$DP_HOME_BASIC/dp/docker-setup

export DP_INPUT_DIR=$DP_HOME_BASIC/dp-input-data

export DP_INPUT_SETUP_DIR=$DP_HOME_BASIC/dp-input-setup

export DA_YARN_NODE_SCALE=3

### \# da-platform alias commands
alias dp-start='sh $DP_SETUP_DIR/da-platform.sh start platform'

alias dp-stop='sh $DP_SETUP_DIR/da-platform.sh stop platform'

alias dp-restart-clean='sh $DP_SETUP_DIR/da-platform.sh restart-clean-all'

alias dp-stop-clean-containers='sh $DP_SETUP_DIR/da-platform.sh clean-all-containers'

alias dp-stop-clean-images='sh $DP_SETUP_DIR/da-platform.sh clean-all-images'

alias dp='sh $DP_SETUP_DIR/da-platform.sh'

alias dp-compose='docker-compose -f $DP_SETUP_DIR/docker-compose.yml'

alias dp-fly='docker-compose -f $DP_SETUP_DIR/docker-compose.yml run -rm cc-fly'

### \# da-platform ansible-playbook function
function  dp-ansible-playbook() {
   docker-compose -f $DP_SETUP_DIR/docker-compose.yml run --rm ansible -i inventory.ini  $1 $2 $3 $4
}

### \# da-platform hive related data functions
function  dp-hive() {
   docker-compose -f $DP_SETUP_DIR/docker-compose.yml run --rm b-loader -u jdbc:hive2://hive-server:10000/$1
}

function  dp-hive-file() {
   docker-compose -f $DP_SETUP_DIR/docker-compose.yml run --rm b-loader -u jdbc:hive2://hive-server:10000 -f /opt/data/data-setup/$1
}

function  dp-hive-command() {
   docker-compose -f $DP_SETUP_DIR/docker-compose.yml run --rm b-loader -u jdbc:hive2://hive-server:10000/$1 -e "$2"
}

function  dp-vertica-file() {
	docker-compose -f $DP_SETUP_DIR/docker-compose.yml run --rm v-loader -f /opt/data/data-setup/$1 -U dbadmin -d daplatform -h vertica
}

end ------------------------------------------- end

### Available platform commands:
   - dp-start (to start all platform services)
   - dp-stop (to stop all platform services)
   - dp-restart-clean (to remove all data and start over)
   - dp-stop-clean (stop and remove all data)
  -------------------------------------------

### Available data commands:
   - dp-hive-file [db-name, file-name] (run any hive file under dp-input-data/hive directory)
   - dp-hive-command [db-name, command in quotes] (run any hive command inline must be within single quotes)
   - dp-hive [db-name] (interactive hive/beeline cli tool - use !quit to end session)
   - dp-vertica-file [file-name] (run any file under dp-input-data/vertica directory)
  -----------------------------------------------------------------------------------

### Available data platform operations command
   - dp-hive public
   - dp-hive-file load-hive-ref-data.sql
   - dp-hive-command public 'select * from cd_icd_cm  Limit 5;'
   - dp-vertica-file load-ref-data.sql

### Available ansible example commands (requires python_proxy container)
   - dp-ansible-playbook create-python-users.yml  --extra-vars '{"users":["mike","mark"]}'
   - ssh -p 2221 mike@localhost

## 2 - Runing the platform:
   - dp-start
   or
   - dp start platform

This will take some time - the first time to download all of the technology component images

## 3 - useful docker commands to see the services and ports are available:
   - docker ps -a
   - docker stats

## 4 - the following ports will become available/port forwarded to localhost:
   - hdfs namenode: 8020
   - hdfs namenode: 50070
   - hdfs datanode: 50075
   - yarn nodemanager: 8042
   - yarn resourcemanager: 8088
   - yarn historyserver: 8188
   - hive server: 10000
   - hive postgres: 5432
   - livy: 8998
   - mysql: 3306


   - zeppelin: 8282
   - hue: 8888

## 5 - available urls to check for service availability:
   - yarn resource: http://localhost:8088/cluster/apps
   - yarn history: http://localhost:8188/applicationhistory/apps
   - hdfs namenode: http://localhost:50070/dfshealth.html#tab-overview
   - hdfs datanode: http://localhost:50075/datanode.html#tab-overview
   - livy: http://localhost:8998


   - hue: http://localhost:8888/filebrowser/#/  (first time in will ask for user/pass creation: admin/admin is fine)
   - zepplin: http://localhost:8282/#/

## 6 - proper shutdown protocol to avoid data loss (from ssh terminal):
   - dp-stop

# Working with Docker on Windows 10

## Complete Series
https://www.youtube.com/watch?v=_fntjriRe48&list=PLhfrWIlLOoKNMHhB39bh3XBpoLxV3f0V9

## Setup WSL
https://www.youtube.com/watch?v=_fntjriRe48

## Setup Docker using WSL
https://www.youtube.com/watch?v=5RQbdMn04Oc

