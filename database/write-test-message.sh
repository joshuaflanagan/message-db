#!/usr/bin/env bash

set -u

instances=1
if [ ! -z ${INSTANCES+x} ]; then
  instances=$INSTANCES
fi

stream_name="testStream-$(uuidgen)"
if [ ! -z ${STREAM_NAME+x} ]; then
  stream_name=$STREAM_NAME
fi

echo
echo "Writing $instances Messages to Stream $stream_name"
echo "= = ="
echo

default_name=message_store

if [ -z ${DATABASE_USER+x} ]; then
  echo "(DATABASE_USER is not set)"
  user=$default_name
else
  user=$DATABASE_USER
fi
echo "Database user is: $user"

if [ -z ${DATABASE_NAME+x} ]; then
  echo "(DATABASE_NAME is not set)"
  database=$default_name
else
  database=$DATABASE_NAME
fi
echo "Database name is: $database"
echo


for (( i=1; i<=instances; i++ )); do
  uuid=$(uuidgen)
  echo "Instance: $i, Message ID: $uuid"

  psql $database -c "SELECT write_message('$uuid'::varchar, '$stream_name'::varchar, 'SomeType'::varchar, '{\"attribute\": \"some value\"}'::jsonb, '{\"metaAttribute\": \"some meta value\"}'::jsonb);" > /dev/null
done

echo