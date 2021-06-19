#!/usr/bin/env bash
DOGRC=$HOME/.dogrc
AWS_CREDS=$HOME/.aws/credentials

if [ -e $DOGRC ]; then
    export DATADOG_API_KEY=$(grep apikey $DOGRC | cut -d= -f2 | sed 's/ //g')
    export DATADOG_APP_KEY=$(grep appkey $DOGRC | cut -d= -f2 | sed 's/ //g')
fi

if [ -e $AWS_CREDS ]; then
    export AWS_ACCESS_KEY_ID=$(grep aws_access_key_id $AWS_CREDS | cut -d= -f2 | sed 's/ //g')
    export AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key $AWS_CREDS | cut -d= -f2 | sed 's/ //g')
fi
