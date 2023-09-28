package main

import (
	"os"

	"github.com/cosmos/cosmos-sdk/server"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"

	"github.com/perfogic/pmdchain/app"
	cmdconfig "github.com/perfogic/pmdchain/cmd/config"
	"github.com/perfogic/pmdchain/cmd/pmdchaind/cmd"
)

func main() {
	cmdconfig.RegisterDenoms()
	rootCmd, _ := cmd.NewRootCmd()
	if err := svrcmd.Execute(rootCmd, "", app.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}
