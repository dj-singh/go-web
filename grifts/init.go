package grifts

import (
	"github.com/gobuffalo/buffalo"
	"github.com/joshgav/go-web/actions"
)

func init() {
	buffalo.Grifts(actions.App())
}
