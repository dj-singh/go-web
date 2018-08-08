#!/usr/bin/env bash

__filename=${BASH_SOURCE[0]}
__dirname=$(cd $(dirname ${__filename}) && pwd)
__root=$(cd "${__dirname}/../../" && pwd)
if [[ ! -f "${__root}/.env" ]]; then cp "${__root}/.env.tpl" "${__root}/.env"; fi
source "${__root}/.env"
source ${__dirname}/rm_helpers.sh # for ensure_group

BASE_NAME="${BASE_NAME}-source"

app_name=${1:-"${BASE_NAME}-webapp"}
plan_name=${2:-"${BASE_NAME}-plan"}
group_name=${3:-"${BASE_NAME}-group"}
location=${4:-${DEFAULT_LOCATION}}
project_name=${5:-${PROJECT_NAME}}
gh_token=${6:-${GH_TOKEN}}

url_suffix=azurewebsites.net

## to be removed
GROUP_NAME_OVERRIDE=yili-cus-euap-01
LOCATION_OVERRIDE=centraluseuap
RANJITH_SUB=ce678eba-8ab3-4a0c-9610-97fee4ee6b34
GOSDK_SUB=11160a4e-7dc5-4c8e-a9d6-16251e5a4637
group_name=${GROUP_NAME_OVERRIDE}
location=${LOCATION_OVERRIDE}
onexit () { az account set --subscription $GOSDK_SUB; }
az account set --subscription $RANJITH_SUB
trap onexit EXIT
TEMP_RUNTIME='node|9.4'
GO_RUNTIME='go|1'
## end to be removed
RUNTIME=$TEMP_RUNTIME

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
    --runtime ${RUNTIME} \
    --output tsv --query 'id')

config_id=$(az webapp config set --ids $webapp_id \
    --linux-fx-version "${GO_RUNTIME}" \
    --output tsv --query 'id')

echo "created webapp $webapp_id"

source_config_id=$(az webapp deployment source config \
    --ids $webapp_id \
    --repo-url "https://github.com/${project_name}" \
    --branch 'master' \
    --git-token ${gh_token} \
    --repository-type git \
    --output tsv --query 'id')

curl -L "https://${app_name}.${url_suffix}/?name=gopherman"
echo ""

# az webapp delete --ids ${webapp_id}
# az appservice plan delete --ids "${plan_id}" --yes

