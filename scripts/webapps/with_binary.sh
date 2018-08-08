#!/usr/bin/env bash

__filename=${BASH_SOURCE[0]}
__dirname=$(cd $(dirname ${__filename}) && pwd)
__root=$(cd "${__dirname}/../../" && pwd)
if [[ ! -f "${__root}/.env" ]]; then cp "${__root}/.env.tpl" "${__root}/.env"; fi
source "${__root}/.env"
source ${__dirname}/rm_helpers.sh # for ensure_group

BASE_NAME="${BASE_NAME}-zip"

app_name=${1:-"${BASE_NAME}-webapp"}
plan_name=${2:-"${BASE_NAME}-plan"}
group_name=${3:-"${BASE_NAME}-group"}
location=${4:-${DEFAULT_LOCATION}}

url_suffix=azurewebsites.net
startup_file_name=server

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
	--runtime 'node|8.1' \
	--startup-file 'server' \
    --output tsv --query 'id')

go get -u github.com/golang/dep/cmd/dep && dep ensure -v
go build -v -o out/${startup_file_name} "${__root#${GOPATH}/src/}"
zip --junk-paths ${__root}/out/server.zip ${__root}/out/${startup_file_name}

az webapp deployment source config-zip \
    --ids ${webapp_id} \
    --src ${__root}/out/server.zip \
	--output json > /dev/null

curl -L "https://${app_name}.${url_suffix}/?name=gopherman"
echo ""
