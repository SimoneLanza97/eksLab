#!/bin/bash 

echo "creating kroki container for diagrams.."

docker compose up -d 
if [ $? -ne 0 ]; then 
    echo "Docker compose failed"
    exit 1
fi 

sleep 10 

python3 diagram.py 
if [ $? -ne 0 ]; then 
    echo "Python script failed"
    exit 1
fi 

docker compose down -v 
if [ $? -ne 0 ]; then 
    echo "Docker compose down failed"
    exit 1
fi

echo "Completed succesfully"