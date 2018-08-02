GROUP=yili-cus-euap-01
BASE_NAME=joshgav-goweb-tester
LOCATION=centraluseuap  # canary
GO_RUNTIME='go|1.x'

RANJITH_SUB=ce678eba-8ab3-4a0c-9610-97fee4ee6b34
GOSDK_SUB=11160a4e-7dc5-4c8e-a9d6-16251e5a4637

az account set --subscription $RANJITH_SUB

plan_id=$(az appservice plan create \
    --name "${BASE_NAME}-plan" \
    --resource-group "$GROUP" \
    --location "$LOCATION" \
    --is-linux \
    --output tsv --query "id")

webapp_id=$(az webapp create \
    --name "${BASE_NAME}-webapp" \
    --plan ${plan_id} \
    --resource-group $GROUP \
    --runtime $GO_RUNTIME)

az appservice plan delete --ids "${plan_id}" --yes

az account set --subscription $GOSDK_SUB
