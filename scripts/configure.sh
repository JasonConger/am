#!/bin/bash
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Set script variables
#SPLUNKHOME=/opt/splunk
SPLUNKHOME=/home
#SPLUNKLOCAL=$SPLUNKHOME/etc/system/local
SPLUNKLOCAL=$SPLUNKHOME

# Parse command-line options

# Option strings
SHORT=u:p:
LONG=splunk-user:,splunk-password:

# Get options
OPTS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")
if [ $? != 0 ] ; then echo "Failed to parse options...exiting." >&2 ; exit 1 ; fi
eval set -- "$OPTS"

# Set default values
SPLUNKUSER=admin

# Set variables 
while true ; do
  case "$1" in
    -u | --splunk-user )
      SPLUNKUSER="$2"
      shift 2
      ;;
    -p | --splunk-password )
      SPLUNKPW="$2"
      shift 2
      ;;
    -- )
      shift
      break
      ;;
    *)
      echo "Internal error!"
      exit 1
      ;;
  esac
done

# Print the variables
echo "SPLUNKUSER = $SPLUNKUSER"

# Create PW hash for writing to config
#SPLUNKPWHASHED=$($SPLUNKHOME/bin/splunk hash-passwd $SPLUNKPW)

# Replace user and password placeholder tokens in user-seed.conf
#echo HASHED_PASSWORD = "$SPLUNKPWHASHED" >> $SPLUNKLOCAL/user-seed.conf
#sed -i "s/##SPLUNKUSER##/$SPLUNKUSER/g" $SPLUNKLOCAL/user-seed.conf
touch /home/user-seed.conf
echo "password" >> /home/user-seed.conf

# Create Splunk user
useradd -m splunk

# Set ownership for Splunk user
#chown -R splunk:splunk /opt/splunk

# Enable boot start with systemd
#$SPLUNKHOME/bin/splunk enable boot-start -systemd-managed 1 -user splunk --accept-license

#Start Splunk
#$SPLUNKHOME/bin/splunk start || true