__filename=${BASH_SOURCE[0]}
__dirname=$(cd $(dirname ${__filename}) && pwd)
__root=$(cd "${__dirname}/../../" && pwd)

RANJITH_SUB=ce678eba-8ab3-4a0c-9610-97fee4ee6b34
GOSDK_SUB=11160a4e-7dc5-4c8e-a9d6-16251e5a4637

GROUP_NAME=yili-cus-euap-01
BASE_NAME=joshgav-goweb-tester
LOCATION=centraluseuap  # canary

TEMP_RUNTIME='node|9.4'
GO_RUNTIME='go|1'
RUNTIME=$TEMP_RUNTIME

az account set --subscription $RANJITH_SUB

plan_id=$(az appservice plan create \
    --name "${BASE_NAME}-plan" \
    --resource-group "${GROUP_NAME}" \
    --location "$LOCATION" \
    --is-linux \
    --output tsv --query "id")
echo "created plan $plan_id"

webapp_id=$(az webapp create \
    --name "${BASE_NAME}-webapp" \
    --plan ${plan_id} \
    --resource-group ${GROUP_NAME} \
    --runtime ${RUNTIME} \
    --output tsv --query 'id')

config_id=$(az webapp config set --ids $webapp_id \
    --linux-fx-version "${GO_RUNTIME}" \
    --output tsv --query 'id')

echo "created webapp $webapp_id"

# az webapp delete --ids ${webapp_id}
# az appservice plan delete --ids "${plan_id}" --yes

az account set --subscription $GOSDK_SUB
