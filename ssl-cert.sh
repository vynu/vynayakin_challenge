#!/bin/bash
openssl req -nodes -new -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 365 -subj "/C=FR/ST=IDF/L=US/O=MyInc/OU=DevOps/CN=localhost/emailAddress=v@v.com"