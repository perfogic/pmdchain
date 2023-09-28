package pmdchain_test

import (
	"testing"

	keepertest "github.com/perfogic/pmdchain/testutil/keeper"
	"github.com/perfogic/pmdchain/testutil/nullify"
	"github.com/perfogic/pmdchain/x/pmdchain"
	"github.com/perfogic/pmdchain/x/pmdchain/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		Params: types.DefaultParams(),

		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.PmdchainKeeper(t)
	pmdchain.InitGenesis(ctx, *k, genesisState)
	got := pmdchain.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	nullify.Fill(&genesisState)
	nullify.Fill(got)

	// this line is used by starport scaffolding # genesis/test/assert
}
