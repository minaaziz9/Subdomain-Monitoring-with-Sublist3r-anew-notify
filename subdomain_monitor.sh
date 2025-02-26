#!/bin/bash

# Path to the list of domains
DOMAINS_LIST="/path/to/domains.txt"

# Set Output File for Tracking Subdomains
SUBS_FILE="tracked_subdomains.txt"

# Temporary file to store new findings
TEMP_FILE="subs_tmp.txt"

# Clear the temp file
> $TEMP_FILE

# Loop through each domain and run subdomain enumeration
while read -r DOMAIN; do
    echo "🔍 Scanning: $DOMAIN"

    # Run Sublist3r and append results to temporary file
    python3 /path/to/Sublist3r/sublist3r.py -d $DOMAIN -o - -n >> $TEMP_FILE

done < "$DOMAINS_LIST"

# Use `anew` to detect only new subdomains and update the tracking file
NEW_SUBS=$(cat $TEMP_FILE | anew $SUBS_FILE)

# Send Notifications for New Subdomains using notify
if [[ -n "$NEW_SUBS" ]]; then
    echo "$NEW_SUBS" | notify -silent -provider slack-notifications
fi
