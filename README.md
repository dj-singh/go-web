A basic web site created with [Buffalo](https://github.com/gobuffalo/buffalo).

For production, set:

* DATABASE_URL=postgres://username%40server:password@server.postgres.database.azure.com:5432/goweb`.
* GO_ENV=production

az appservice plan create -g ... -n ... --is-linux --location centraluseuap --sku B1

az webapp create -g 'joshgav-go-test01-webs' --plan 'go-plan02' --name 'joshgav-go-web02' --deployment-container-image-name 'joshgav/go-web:latest'

az webapp config appsettings set --name 'webapp-name' --resource-group 'group-name' --setings 'GO_ENV=production DATABASE_URL=...'


