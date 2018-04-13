#! /bin/bash

cd infrastructure
terraform apply
cd ..

az appservice plan create -g ... -n ... --is-linux --location centraluseuap --sku B1
az webapp create -g 'joshgav-go-test01-webs' --plan 'go-plan02' --name 'joshgav-go-web02' --deployment-container-image-name 'joshgav/go-web:latest'
az webapp config appsettings set --name 'webapp-name' --resource-group 'group-name' --settings 'GO_ENV=production DATABASE_URL=...'

