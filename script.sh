DOMAIN_NAME="yourdomain.com"
DIGITALOCEAN_TOKEN="your_api_token_here"



ip=curl -s "https://ifconfig.io/ip"

curl -X PATCH \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
  -d '{"name":"blog","type":"A"}' \
  "https://api.digitalocean.com/v2/domains/$DOMAIN_NAME/records/3352896"