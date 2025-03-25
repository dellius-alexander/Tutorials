#!/bin/bash
set -e

# Define log file path, default to /var/log/cloudflare_ddns.log if LOG_FILE is not set
LOG_FILE=${LOG_FILE:-/var/log/cloudflare_ddns.log}

# Log function to append messages to the log file with timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Report function to log and echo the message
report() {
    local message=$1
    log "$message"
    echo "$message"
}

# Regular expressions for IPv4 and IPv6
ipv4Regex="((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])"
ipv6Regex="(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"

# Enable IPv6 support by default
ipv6="true"

# DSM Config: username, password, hostname, ipAddr
username="$1"
password="$2"
hostname="$3"
ipAddr="$4"

# Fetch and filter IPv6 address if enabled
if [[ $ipv6 = "true" ]]; then
    ip6fetch=$(ip -6 addr show eth0 | grep -oP "$ipv6Regex" || true)
    ip6Addr=$(if [ -z "$ip6fetch" ]; then echo ""; else echo "${ip6fetch:0:$((${#ip6fetch})) - 7}"; fi)
    recType6="AAAA"

    if [[ -z "$ip6Addr" ]]; then
        ipv6="false"
    fi
    if [[ $ipAddr =~ $ipv4Regex ]]; then
        recordType="A"
    else
        recordType="AAAA"
        ipv6="false"
    fi
else
    recordType="A"
fi

# Log the start of the DDNS update process
log "Starting DDNS update for hostname: $hostname, IP: $ipAddr, IPv6: ${ip6Addr:-disabled}"

# Cloudflare API URLs for listing DNS records
listDnsApi="https://api.cloudflare.com/client/v4/zones/${username}/dns_records?type=${recordType}&name=${hostname}"
listDnsv6Api="https://api.cloudflare.com/client/v4/zones/${username}/dns_records?type=${recType6}&name=${hostname}"

# Fetch DNS records for the primary record type
res=$(curl -s -X GET "$listDnsApi" -H "Authorization: Bearer $password" -H "Content-Type:application/json")
resSuccess=$(echo "$res" | jq -r ".success")

if [[ $resSuccess != "true" ]]; then
    errorMsg=$(echo "$res" | jq -r ".errors[0].message")
    log "Error listing $recordType records: $errorMsg"
    report "badauth"
    exit 1
fi

# Fetch DNS records for IPv6 if enabled
if [[ $ipv6 = "true" ]]; then
    resv6=$(curl -s -X GET "$listDnsv6Api" -H "Authorization: Bearer $password" -H "Content-Type:application/json")
    resv6Success=$(echo "$resv6" | jq -r ".success")
    if [[ $resv6Success != "true" ]]; then
        errorMsg=$(echo "$resv6" | jq -r ".errors[0].message")
        log "Error listing $recType6 records: $errorMsg"
        report "badauth"
        exit 1
    fi
fi

# Extract record details
recordId=$(echo "$res" | jq -r ".result[0].id")
recordIp=$(echo "$res" | jq -r ".result[0].content")
recordProx=$(echo "$res" | jq -r ".result[0].proxied")
if [[ $ipv6 = "true" ]]; then
    recordIdv6=$(echo "$resv6" | jq -r ".result[0].id")
    recordIpv6=$(echo "$resv6" | jq -r ".result[0].content")
    recordProxv6=$(echo "$resv6" | jq -r ".result[0].proxied")
fi

# Check if the IP address hasn't changed
if [[ $recordIp = "$ipAddr" ]] && ( [[ $ipv6 != "true" ]] || [[ $recordIpv6 = "$ip6Addr" ]] ); then
    report "nochg"
    exit 0
fi

# API URLs for creating and updating DNS records
createDnsApi="https://api.cloudflare.com/client/v4/zones/${username}/dns_records"
updateDnsApi="https://api.cloudflare.com/client/v4/zones/${username}/dns_records/${recordId}"
update6DnsApi="https://api.cloudflare.com/client/v4/zones/${username}/dns_records/${recordIdv6}"

# Create or update the primary record
if [[ $recordId = "null" ]]; then
    log "Creating new $recordType record for $hostname"
    proxy="true" # Enable proxy for new records
    res=$(curl -s -X POST "$createDnsApi" -H "Authorization: Bearer $password" -H "Content-Type:application/json" --data "{\"type\":\"$recordType\",\"name\":\"$hostname\",\"content\":\"$ipAddr\",\"proxied\":$proxy}")
else
    log "Updating existing $recordType record for $hostname"
    res=$(curl -s -X PUT "$updateDnsApi" -H "Authorization: Bearer $password" -H "Content-Type:application/json" --data "{\"type\":\"$recordType\",\"name\":\"$hostname\",\"content\":\"$ipAddr\",\"proxied\":$recordProx}")
fi

resSuccess=$(echo "$res" | jq -r ".success")
if [[ $resSuccess != "true" ]]; then
    errorMsg=$(echo "$res" | jq -r ".errors[0].message")
    log "Error updating $recordType record: $errorMsg"
fi

# Create or update the IPv6 record if enabled
if [[ $ipv6 = "true" ]]; then
    if [[ $recordIdv6 = "null" ]]; then
        log "Creating new $recType6 record for $hostname"
        proxy="true" # Enable proxy for new records
        res6=$(curl -s -X POST "$createDnsApi" -H "Authorization: Bearer $password" -H "Content-Type:application/json" --data "{\"type\":\"$recType6\",\"name\":\"$hostname\",\"content\":\"$ip6Addr\",\"proxied\":$proxy}")
    else
        log "Updating existing $recType6 record for $hostname"
        res6=$(curl -s -X PUT "$update6DnsApi" -H "Authorization: Bearer $password" -H "Content-Type:application/json" --data "{\"type\":\"$recType6\",\"name\":\"$hostname\",\"content\":\"$ip6Addr\",\"proxied\":$recordProxv6}")
    fi
    res6Success=$(echo "$res6" | jq -r ".success")
    if [[ $res6Success != "true" ]]; then
        errorMsg=$(echo "$res6" | jq -r ".errors[0].message")
        log "Error updating $recType6 record: $errorMsg"
    fi
else
    res6Success="false" # Ensure res6Success is defined if IPv6 is not enabled
fi

# Report the final status based on the update results
if [[ $resSuccess = "true" ]] || [[ $res6Success = "true" ]]; then
    report "good"
    exit 0
else
    report "badauth"
    exit 1
fi
