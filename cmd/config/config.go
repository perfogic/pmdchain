package config

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	ethermint "github.com/evmos/ethermint/types"
)

const (
	// DisplayDenom defines the denomination displayed to users in client applications.
	DisplayDenom = "pmd"
	AttoDenom    = "aPmd"
)

// RegisterDenoms registers the base and display denominations to the SDK.
func RegisterDenoms() {
	// TODO: rename
	if err := sdk.RegisterDenom(DisplayDenom, sdk.OneDec()); err != nil {
		panic(err)
	}

	if err := sdk.RegisterDenom(AttoDenom, sdk.NewDecWithPrec(1, ethermint.BaseDenomUnit)); err != nil {
		panic(err)
	}
}
