# Fraud Detection System

This project is a Fraud Detection System designed to analyze transaction data and determine whether a given transaction should be approved or denied based on risk scores.

## Introduction

The Fraud Detection System is designed to help businesses protect themselves from fraudulent transactions. It calculates a risk score for each transaction and determines whether to approve or deny the transaction based on predefined risk thresholds.

## Request and Response

### Request

POST /anti_fraud/check_transaction => JSON

To use the system, send a request with transaction data, typically including information such as:

- `user_id`: The user ID associated with the transaction.
- `transaction_id`: A unique identifier for the transaction.
- `transaction_amount`: The amount of the transaction.
- `transaction_date`: The date and time of the transaction.
- Other relevant information like `merchant_id`, `card_number`, and `device_id`.

Here's an example of a request:

```json
{
  "user_id": 12345,
  "transaction_id": 67890,
  "transaction_amount": 500.00,
  "transaction_date": "2023-10-18T14:30:00.000Z",
  "merchant_id": 9876,
  "card_number": "**** **** **** 1234",
  "device_id": 5678
}
```

### Response

The system processes the request and returns a recommendation based on the calculated risk score.

- If the calculated risk score is below a predefined minimum recommendation threshold (e.g., 75), it returns "approve."
- If the risk score is equal to or above the threshold, it returns "deny."

Here's an example of a response:

```json
{
  "transaction_id" : 2342357,
  "recommendation": "approve"
}
```

## Usage

Send a POST request to the system with transaction data.
Receive a response with a recommendation of "approve" or "deny."

## Installation

To install and set up the Fraud Detection System locally:

```sh
$ git clone git@github.com:raphaelmatteoni/myapp.git
$ cd myapp
$ docker-compose up --build
$ docker-compose run web rake db:setup
```

## Run tests

The [Rspec](https://github.com/rspec/rspec-rails) testing framework is being used in this project.
```sh
$ docker-compose exec web rspec spec
```

### Ruby and Rails versions

- Ruby 3.2.2
- Rails 7.0.7