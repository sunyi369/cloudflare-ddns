#!/bin/bash

# Cloudflare API Key and Zone ID
CF_API_KEY="你的密钥"
CF_ZONE_ID="你的区域id，点进域名右下方api上面"

# DNS record name and type
DNS_NAME="域名"
DNS_TYPE="A"

# Get current IP address
IP=$(curl -s https://ipinfo.io/ip)

# Get DNS record ID
DNS_RECORD=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?type=${DNS_TYPE}&name=${DNS_NAME}" \
-H "Authorization: Bearer ${CF_API_KEY}" \
-H "Content-Type: application/json" | jq -r '.result[0].id')

# Update DNS record if IP address has changed
if [[ "$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${DNS_RECORD}" \
-H "Authorization: Bearer ${CF_API_KEY}" \
-H "Content-Type: application/json" | jq -r '.result.content')" != "${IP}" ]]; then

  # Update DNS record with new IP address
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${DNS_RECORD}" \
  -H "Authorization: Bearer ${CF_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "{\"content\":\"${IP}\"}"
  
  # Print message to console
  echo "Cloudflare DNS record updated with IP address: ${IP}"
  else
  echo "No update"
fi
