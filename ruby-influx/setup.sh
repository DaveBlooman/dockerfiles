#!/bin/sh -e

curl 'http://docker.local:8086/query?q=CREATE+USER+admin+WITH+PASSWORD+%27admin%27&db='
