A basic web site created with [Buffalo](https://github.com/gobuffalo/buffalo).

To deploy (rough):

```bash
# build image

docker build . -t 'joshgav/go-web:latest'
docker push `joshgav/go-web:latest`

# deploy postgres

go get -u github.com/hashicorp/terraform
cd infrastructure
terraform apply -auto-approve

# set db vars for web creation

export username=insert_username
export password=insert_password
export server_name_short=insert_server_name_short

export DATABASE_URL=postgres://${username}%40${server_name_short}:${password}@${server_name_short}.postgres.database.azure.com:5432/goweb`.

# deploy web

export GROUP=joshgav-go-test01-webs
export PLAN_NAME=go-plan01
export WEB_NAME=joshgav-go-web01

export GO_ENV=production


az appservice plan create \
  -g $GROUP \
  -n ${PLAN_NAME} \
  --is-linux \
  --location centraluseuap \
  --sku B1

az webapp create \
  -g $GROUP \
  --plan ${PLAN_NAME} \
  --name ${WEB_NAME} \
  --deployment-container-image-name 'joshgav/go-web:latest'

az webapp config appsettings set \
  --name ${WEB_NAME} \
  --resource-group ${GROUP} \
  --settings "GO_ENV=${GO_ENV} DATABASE_URL=${DATABASE_URL}"
```

