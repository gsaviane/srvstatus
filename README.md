# SRVSTATUS

## version 0.1

## Getting status of SystemD services using Telegraf+InfluxDB+Grafana

![Alt text](https://github.com/ratibor78/servicestat/blob/master/services_grafana.png?raw=true "Grafana dashboard example")
![Alt text](https://github.com/ratibor78/servicestat/blob/master/services_grafana1.png?raw=true "Grafana dashboard example")



  Main goal of this easy script is checking list of given SystemD services and sending their status 
  including Up/Down time in to InfluxDB and Grafana dashboards. 
  
  The script is written on python and I tried to use standard lib's as much as possible,
  but you still need a pip install.
  
  This script returns a Json format with services status coded by digits: 
```
  active (running) = 1
  active (existed) = 2
  inactive (dead) = 3
  failed  = 4
  no match = 0
```  
  so you need to convert it back to string in Grafana. 
  
  Actually the last Telegraf version accepts the string values in json format, 
  but if you want to use Grafana alerting you still need numeric format to put it on alert graphs. 
  
  Also script provide a service name and time recent service status in seconds, 
  so you can use it in Grafana dashboards.
  
  You can find the Grafana dashboard example in service_status.json file or on grafana.com:https://grafana.com/dashboards/8348

## Installation

```
$ cd /opt && git clone https://github.com/ratibor78/srvstatus.git
$ cd /opt/srvstatus
$ virtualenv venv && source venv/bin/activate
$ pip install -r requirements.txt
$ chmod +x ./service.py
```
  
  Rename **settings.ini.back** to **settings.ini**  and specify a list of services that you need to check: 

```
   [SERVICES]
    name = docker.service nginx.service
```
  You can also add your own **user services** list:

```
   [USER_SERVICES]
    name = syncthing.service
```

Then configure the Telegraf **exec** plugin like this: 

```
    [[inputs.exec]]

    commands = [
     "/opt/srvstatus/venv/bin/python /opt/srvstatus/service.py"
    ]

    timeout = "5s"
    name_override = "services_stats"
    data_format = "json"
    tag_keys = [
      "service"
    ]
```
That's all, now we can create nice and pretty Grafana dashboards for system services with alerting. 

Good luck. 

License
----

MIT

**Free Software, Hell Yeah!**
