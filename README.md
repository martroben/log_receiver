# Log receiver
Socket server container on Docker for receiving syslogs from other Docker containers

# Setup
##### 1. Clone project
```Shell
git clone https://github.com/martroben/log_receiver
```

```Shell
cd log_receiver
```

##### 2. Build Docker image
```Shell
sudo docker build --rm -t log_receiver .
```

##### 3. Create a Docker volume for logs
```Shell
sudo docker volume create --label logs
```

##### 4. Create a dedicated network for your apps
```Shell
sudo docker network create \
    --subnet=188.0.0.0/24 \
    logged_containers
```

##### 5. Run the log receiver container
```Shell
sudo docker run \
    --rm \
    --name log_receiver \
    --mount source=logs,target=/log \
    --network logged_containers \
    --ip 188.0.0.4 \
    --env-file .env_sample \
    log_receiver \
    python3 /app/main.py
```
Modify .env file for different ip / port

##### 6. Run other services with the following options
```Shell
sudo docker run \
    --rm \
    --name my_app \
    --network logged_containers \
    --ip 188.0.0.3 \
    --log-driver syslog \
    --log-opt syslog-address=udp://188.0.0.4:7001 \
    --log-opt syslog-format=rfc3164 \
    my_app_container
```
See [get_logger.py](get_logger.py) for an example of how to set up logging on these.

##### 7. Access the logs
```Shell
sudo docker run \
    --mount source=logs,target=/log \
    --rm \
    -it \
    alpine sh
```
