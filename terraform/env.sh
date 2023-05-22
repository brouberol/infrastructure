#!/usr/bin/env bash
DOGRC=$HOME/.dogrc
AWS_CREDS=$HOME/.aws/credentials

function extract_var_from_file {
    local varname=$1;
    local filename=$2;
    echo $(grep $varname $filename | cut -d= -f2 | sed 's/ //g')
}

if [ -e $DOGRC ]; then
    export DATADOG_API_KEY=$(extract_var_from_file apikey $DOGRC)
    export DATADOG_APP_KEY=$(extract_var_from_file appkey $DOGRC)
fi

if [ -e $AWS_CREDS ]; then
    export AWS_ACCESS_KEY_ID=$(extract_var_from_file aws_access_key_id $AWS_CREDS)
    export AWS_SECRET_ACCESS_KEY=$(extract_var_from_file aws_secret_access_key $AWS_CREDS)
fi
