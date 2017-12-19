package main

import (
	"log"

	"github.com/joshgav/go-web/go_web/actions"
)

func main() {
	app := actions.App()
	if err := app.Serve(); err != nil {
		log.Fatal(err)
	}
}
