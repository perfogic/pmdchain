package keeper

import (
	"github.com/perfogic/pmdchain/x/pmdchain/types"
)

var _ types.QueryServer = Keeper{}
