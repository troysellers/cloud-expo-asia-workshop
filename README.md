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


## Create Kafka Connect 


## Add Debezium


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
