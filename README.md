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


Once your postgres service is up and running, it's time to load some data into it. 

We are going to simulate a table, so let's create one using psql from our local machine. 
If you don't have a local tool installed for running postgres scripts, you can look at something like [Retool](https://retool.com/)

Get your credentials from the Postgres service in Aiven 

![pg creds](img/2%20-%20pgcreds.png)

Then from the sql directory in this repository 
```console
$ psql postgres://avnadmin:<password>@postgres-db-tsellers-demo.aivencloud.com:18943/defaultdb -f create.sql
```

> Be sure to remove the ?sslmode parameter when using the psql from local machine

Now, let's load some data 

```console
$ psql postgres://avnadmin:<password>@postgres-db-tsellers-demo.aivencloud.com:18943/defaultdb -f insert.sql
```

Excellent, we know have our postgres database loaded with data. 

Let's move to the next step.

## Create Kafka


Click on the `create service` button to get started with your new Kafka service. 

https://user-images.githubusercontent.com/92002375/192944203-83e29756-90c1-481e-beba-13a2fe876f82.mp4

After creating the Kafka service, go to the `service overview` page and enable `Apache Kafka REST API (Karapace)`. 

Next, scroll down to `Advanced Configurations` and add in `kafka.auto_create_topics_enable`. Turn the configuration on and save advanced configuration. 

<img width="1434" alt="Screenshot 2022-10-07 at 1 24 52 PM" src="https://user-images.githubusercontent.com/92002375/194474892-968aa681-e2f4-4c5f-bae3-24ae106a7aa9.png">



## Create Kafka Connect 

Go to your Kafka service overview page, `manage integrations`, and select `Kafka Connect` to get started! 


https://user-images.githubusercontent.com/92002375/193548233-7d6f6797-ab78-4e71-9037-65f00d50ae3f.mp4



## Create Debezium Connector

https://user-images.githubusercontent.com/92002375/193753962-7124b560-8cf6-4173-8afa-a49586a82434.mp4

Go to Kafka service overview page > `manage integrations` > `Kafka connect`

You will need to install the aiven-extras extenstion and create a publication for all the tables. 

Use the `psql <POSTGRESQL_URI>` command to enter your database. 
Run 
```CREATE EXTENSION aiven_extras CASCADE;```
to create the extension, and 
```
SELECT *
FROM aiven_extras.pg_create_publication_for_all_tables(
    'debezium_publication',
    'INSERT,UPDATE,DELETE'
    ); 
```
to create the publication. 


Next, go to the connector type under Kafka Connect and paste the sample code below into the connector JSON: 
```
{
    "name":"$KAFKA_CONNECTOR_NAME",
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "$PG_HOST",
    "database.port": "$PG_PORT",
    "database.user": "$PG_USER",
    "database.password": "$PG_PASSWORD",
    "database.dbname": "$PG_DATABASE_NAME",
    "database.sslmode": "require",
    "plugin.name": "pgoutput",
    "slot.name": "debezium",
    "publication.name": "debezium_publication",
    "database.server.name": "$PROJECT_NAME$PG_SERVICE_NAME",
    "tasks.max":"1",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter"
}
```
Modify the JSON file with connection information from your `PostgreSQL service`. You can get your connection information by going to your PostgreSQL service overview tab.

## Send Data From PostgreSQL to Kafka 


https://user-images.githubusercontent.com/92002375/194475453-39cefaf3-2b25-4546-bdbe-c1f6f3f281ab.mp4

Connect into your database and run the following insert statement: 
```
INSERT INTO public.orders(first_name, last_name, email, gender, street, town, mobile, country, drink_type, cost, addons, comments) values ('Misty','Ketchum','ashketchum@champion.com','Male','26 Pallet Town','Ketchum Estate','+65 819 910 48618','Singapore','Latte',5.7,'sugar','cold water');
```

Go to your Kafka topic, messages and select fetch messages. Decode the message and observe that the data that you inserted to PostgreSQL shows up on Kafka. 

With that, you are done with your PostgreSQL and Kafka setup! Next, let's explore how to create a `Clickhouse` service. 


## Create Clickhouse


https://user-images.githubusercontent.com/92002375/194501434-6a2f743a-37cf-4502-81d3-a00e1574c336.mp4



## Configure Kafka -> Clickhouse


https://user-images.githubusercontent.com/92002375/194501462-c12ae651-120f-4fc2-8c8f-e664c9ee1f75.mp4



## Consume The Data Stream

# Bonus Marks!! 
Did you make it to the end already? Still have time left in our workshop? Well done, I told you Aiven was simple and easy to use didn't I! :) 

You can now have a go at 
[Adding an Observability Stack]
OR 
[Build This Again Using Terraform]

## Adding an Observability Stack


# Create Observability Stack
https://user-images.githubusercontent.com/92002375/194501746-d95575d4-acf2-48b1-949b-c8d85563509b.mp4

The Aiven platform comes with the capability of spinning up observability pipelines with a few clicks of a button. Follow the video and try it out!

# View Observability Stack


https://user-images.githubusercontent.com/92002375/194501920-89e54eb0-09df-4056-aa90-9e47166ea1eb.mp4

Spinning up an observability stack comes with pre-populated panels that you can use immediately to monitor your services. 


## Build This Again Using Terraform

You can also interface with Aiven's platform through Infrastructure-As-Code such as [Terraform](https://registry.terraform.io/providers/aiven/aiven/latest/docs) or [Kubernetes](https://docs.aiven.io/docs/tools/kubernetes.html). You can access the sample Terraform scripts that we have provided and give it a go!
