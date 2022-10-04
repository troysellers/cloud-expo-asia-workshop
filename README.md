# Create CDC Pipeline with Aiven

In this 45 minute workshop you will create a complete, end to end, CDC pipeline for capturing and analysing data changes in a postgres database. 

Sounds too good to be true? 
Welcome to Aiven :) 

## Create your Aiven Account
If you haven't already done this, create a new Aiven trial at the [signup page](https://console.aiven.io/signup). You may notice some QR codes nearby, you could scan these and get to a trial with even a few more credits! 


![Signup](img/1%20-%20signup.png)

Here's how easy it is to get started with a trial in Aiven.

https://user-images.githubusercontent.com/768991/192938791-98effa95-d40f-4c32-b0a1-82752131f6f9.mp4

Done? Awesome, let's start creating the databases we are going to need. 

## Create Postgres

Click on the `create service` button to get started with your new Postgres service. 

https://user-images.githubusercontent.com/768991/192938883-949af89b-a75d-44e3-8b80-7228aaaace53.mp4



## Create Kafka


Click on the `create service` button to get started with your new Kafka service. 

https://user-images.githubusercontent.com/92002375/192944203-83e29756-90c1-481e-beba-13a2fe876f82.mp4


## Create Kafka Connect 

Go to your Kafka service overview page, `manage integrations`, and select `Kafka Connect` to get started! 


https://user-images.githubusercontent.com/92002375/193548233-7d6f6797-ab78-4e71-9037-65f00d50ae3f.mp4



## Create Debezium Connector

https://user-images.githubusercontent.com/92002375/193753962-7124b560-8cf6-4173-8afa-a49586a82434.mp4

Steps: 
1. Go to Kafka service overview page > `manage integrations` > `Kafka connect` 
2. Paste the sample code below into the connector JSON: 
   ```
   
    "name":"$KAFKA_CONNECTOR_NAME",
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "$PG_HOST",
    "database.port": "$PG_PORT",
    "database.user": "$PG_USER",
    "database.password": "$PG_PASSWORD",
    "database.dbname": "$PG_DATABASE_NAME",
    "database.sslmode": "$PG_SSL_MODE",
    "plugin.name": "pgoutput",
    "slot.name": "debezium",
    "publication.name": "debezium",
    "database.server.name": "$PROJECT_NAME$PG_SERVICE_NAME",
    "tasks.max":"1",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "transforms": "transform-1",
    "transforms.transform-1.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.transform-1.regex":"(.*)$KAFKA_TOPIC_NAME",
    "transforms.transform-1.replacement":"$KAFKA_TOPIC_NAME"
}
```
3. Modify the JSON file with configuration information from your `PostgreSQL service`.
4. Go to your `Kafka service` > Advanced configuration > Enable auto.create.topics 

## Send Data From PostgreSQL to Kafka 


## Create Clickhouse


## Configure Kafka -> Clickhouse


## Consume The Data Stream

# Bonus Marks!! 
Did you make it to the end already? Still have time left in our workshop? Well done, I told you Aiven was simple and easy to use didn't I! :) 

You can now have a go at 
[Adding an Observability Stack]
OR 
[Build This Again Using Terraform]

## Adding an Observability Stack


## Build This Again Using Terraform
