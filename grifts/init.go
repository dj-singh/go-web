package grifts

import (
	"github.com/gobuffalo/buffalo"
	"github.com/joshgav/go-web/go_web/actions"
)

func init() {
	buffalo.Grifts(actions.App())
}
