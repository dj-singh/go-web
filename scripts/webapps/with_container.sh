#!/usr/bin/env bash

__filename=${BASH_SOURCE[0]}
__dirname=$(cd $(dirname ${__filename}) && pwd)
__root=$(cd "${__dirname}/../../" && pwd)
if [[ -f "${__root}/.env" ]]; then source "${__root}/.env"; fi
source "${__dirname}/rm_helpers.sh"  # for ensure_group

BASE_NAME="${BASE_NAME}-container"

app_name=${1:-"${BASE_NAME}-webapp"}
plan_name=${2:-"${BASE_NAME}-plan"}
group_name=${3:-"${BASE_NAME}-group"}
location=${4:-${DEFAULT_LOCATION}}
image_uri=${5:-${DOCKER_TAG}}

url_suffix=azurewebsites.net

docker build \
    --tag ${image_uri} \
    --file ${__root}/Dockerfile \
    ${__root}

docker push ${image_uri}

ensure_group $group_name

plan_id=$(az appservice plan create \
    --name "$plan_name" \
    --resource-group "${group_name}" \
    --location "$location" \
    --is-linux \
    --output tsv --query "id")
echo "created plan $plan_id"

webapp_id=$(az webapp create \
    --name "$app_name" \
    --plan ${plan_id} \
    --resource-group ${group_name} \
    --deployment-container-image-name ${image_uri} \
    --output tsv --query 'id')

az webapp deployment container config --ids $webapp_id --enable-cd true
# to enable later zip-deploy or FTP
# az webapp config container set --ids $webapp_id --enable-app-service-storage true

curl -L "https://${app_name}.${url_suffix}/?name=gopherman"
echo ""
