package keeper_test

import (
	"context"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	keepertest "github.com/perfogic/pmdchain/testutil/keeper"
	"github.com/perfogic/pmdchain/x/pmdchain/keeper"
	"github.com/perfogic/pmdchain/x/pmdchain/types"
)

func setupMsgServer(t testing.TB) (types.MsgServer, context.Context) {
	k, ctx := keepertest.PmdchainKeeper(t)
	return keeper.NewMsgServerImpl(*k), sdk.WrapSDKContext(ctx)
}
