[![Build Status](https://travis-ci.org/030/ansible-certbot.svg?branch=master)](https://travis-ci.org/030/ansible-certbot)

# ansible-certbot

Ensure that port 80 is available otherwise certbot will fail.

Installs certbot. Certbot is able to create certificates so that websites could be accessed securely.

A cert will be created based on the hostname of the system. Be sure that this is registered in an external DNS server as well.

## Role variables

By default, neither certs will be created, nor renewed. 

    certbot_create_certs: false
    certbot_mail_address: mail@example.com
    certbot_renew_certs: false

The email address that receives notifications when certs are going to be expired is empty by default and needs to be set otherwise the run will fail.

## Dependencies

None.
