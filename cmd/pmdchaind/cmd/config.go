package cmd

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	cmdcfg "github.com/perfogic/pmdchain/cmd/config"
)

func InitSDKConfig() {
	// set the address prefixes
	config := sdk.GetConfig()
	cmdcfg.SetBech32Prefixes(config)
	cmdcfg.SetBip44CoinType(config)
	config.Seal()
}
