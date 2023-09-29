package main_test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/cosmos/cosmos-sdk/client/flags"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"
	"github.com/cosmos/cosmos-sdk/x/genutil/client/cli"

	"github.com/perfogic/pmdchain/app"
	cmdconfig "github.com/perfogic/pmdchain/cmd/config"
	"github.com/perfogic/pmdchain/cmd/pmdchaind/cmd"
)

func TestInitCmd(t *testing.T) {
	cmd.InitSDKConfig()
	cmdconfig.RegisterDenoms()
	rootCmd, _ := cmd.NewRootCmd()
	rootCmd.SetArgs([]string{
		"init",          // Test the init cmd
		"etherminttest", // Moniker
		fmt.Sprintf("--%s=%s", cli.FlagOverwrite, "true"), // Overwrite genesis.json, in case it already exists
		fmt.Sprintf("--%s=%s", flags.FlagChainID, "pmdchain_9000-1"),
	})

	err := svrcmd.Execute(rootCmd, "", app.DefaultNodeHome)
	require.NoError(t, err)
}
