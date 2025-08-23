# DEPENDENCIES: curl, jq

DOMAIN_NAME="ryantullis.com"
DIGITALOCEAN_TOKEN=$(<do.ini)
LAST_IP_FILE="last_ip.txt"
 

ip=$(curl -s "https://ifconfig.io/ip")

if [ -f "$LAST_IP_FILE" ]; then
  last_ip=$(cat "$LAST_IP_FILE")
else
  last_ip=""
fi
if [ "$ip" != "$last_ip" ]; then
  echo "IP has changed from $last_ip to $ip"
  echo "$ip" > "$LAST_IP_FILE"
else
  echo "IP has not changed: $ip"
  exit 0
fi
#get the record ID for the A record of the domain
response=$(curl -s GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  "https://api.digitalocean.com/v2/domains/$DOMAIN_NAME/records?type=A&name=$DOMAIN_NAME")
id=$(echo $response | jq '.domain_records[0].id')

# Update the A record for the domain
curl -s -X PATCH \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  -d "{\"data\":\"$ip\"}" \
  "https://api.digitalocean.com/v2/domains/$DOMAIN_NAME/records/$id"