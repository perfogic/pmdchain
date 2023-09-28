package keeper_test

import (
	"testing"

	testkeeper "github.com/perfogic/pmdchain/testutil/keeper"
	"github.com/perfogic/pmdchain/x/pmdchain/types"
	"github.com/stretchr/testify/require"
)

func TestGetParams(t *testing.T) {
	k, ctx := testkeeper.PmdchainKeeper(t)
	params := types.DefaultParams()

	k.SetParams(ctx, params)

	require.EqualValues(t, params, k.GetParams(ctx))
}
