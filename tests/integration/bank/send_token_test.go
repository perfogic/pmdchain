package keeper_test

import (
	"github.com/cosmos/cosmos-sdk/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestSendCoin() {
	alice, err := types.AccAddressFromBech32(alice)
	if err != nil {
		panic(err)
	}

	bob, err := types.AccAddressFromBech32(bob)
	if err != nil {
		panic(err)
	}
	err = suite.app.BankKeeper.SendCoins(suite.ctx, alice, bob,
		sdk.Coins{
			sdk.Coin{
				Denom:  sdk.DefaultBondDenom,
				Amount: sdk.NewInt(balAlice / 10),
			},
		})
	suite.Require().NoError(err)
}
