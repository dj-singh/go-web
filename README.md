A basic Go web app for tests.

Run in current namespaces with `make binary`, or run in an isolated container
via Docker daemon with `make container`. Both include a basic `curl` test.

This app can also be deployed to **Azure App Service** in the following ways:

1. Directly from a source repo: `scripts/webapps/from_source.sh`
1. Build a binary locally, zip and push: `scripts/webapps/with_binary.sh`
1. Build a container locally and push: `scripts/webapps/with_container.sh`

The scripts use [Azure CLI](https://github.com/Azure/azure-cli) and use the
current logged-in user account and subscription. Configuration is read from
`.env`, which is created from `.env.tpl` if not found.

