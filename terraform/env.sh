#!/usr/bin/env bash
DOGRC=$HOME/.dogrc

export DATADOG_API_KEY=$(grep apikey $DOGRC | cut -d= -f2 | sed 's/ //g')
export DATADOG_APP_KEY=$(grep appkey $DOGRC | cut -d= -f2 | sed 's/ //g')