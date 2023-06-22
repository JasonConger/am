#!/bin/bash
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Set script variables
SPLUNKHOME=/opt/splunk
SPLUNKLOCAL=$SPLUNKHOME/etc/system/local

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

# Create user-seed.conf
echo "[user_info]" >> $SPLUNKLOCAL/user-seed.conf
echo USERNAME = $SPLUNKUSER >> $SPLUNKLOCAL/user-seed.conf
SPLUNKPWHASHED=$($SPLUNKHOME/bin/splunk hash-passwd $SPLUNKPW)
echo HASHED_PASSWORD = "$SPLUNKPWHASHED" >> $SPLUNKLOCAL/user-seed.conf

# Create Splunk user
useradd -m splunk

# Set ownership for Splunk user
chown -R splunk:splunk /opt/splunk

# Enable boot start with systemd
$SPLUNKHOME/bin/splunk enable boot-start -systemd-managed 1 -user splunk --accept-license

#Start Splunk
$SPLUNKHOME/bin/splunk start || true