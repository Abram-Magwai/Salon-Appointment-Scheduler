#!/bin/bash

PSQL="psql  --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

DISPLAY_SERVICES() {
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

PICK_SERVICE() {
  echo -e "\nselect service: "
  read SERVICE_ID_SELECTED
  SERVICE=$($PSQL "SELECT * FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE ]]
  then
    DISPLAY_SERVICES
  fi

  echo  -e "\Phone Id: "
  read CUSTOMER_PHONE
  PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $PHONE ]]
  then
    echo -e "\n Name: "
    read CUSTOMER_NAME
    INSERT_TO_CUSTOMERS=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

  fi

  echo -e "\nService Time"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_TO_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  if [[ $INSERT_TO_APPOINTMENT == 'INSERT 0 1' ]]
  then
    SERVICE_NAME=$(echo $SERVICE | grep -Eo '[0-9]+\|(.+)'| sed -E 's/[0-9]+\|(.+)/\1/')
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

DISPLAY_SERVICES
PICK_SERVICE
