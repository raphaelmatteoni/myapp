require 'rails_helper'

RSpec.describe Transactions::CheckRecommendation do
  fixtures :users, :transactions, :chargebacks

  let(:user) { users(:one) }

  describe "#call" do
    context "when the score risk is below the minimum recommendation threshold" do
      it "returns 'approve'" do
        transaction_data = {
          user_id: user.id,
          transaction_id: 1,
          merchant_id: 29744,
          card_number: "434505******9116",
          transaction_date: "2019-11-31T23:16:32.812632",
          transaction_amount: 300,
          device_id: 285475
        }
        recommendation = Transactions::CheckRecommendation.new(user, transaction_data).call
        expect(recommendation).to eq("approve")
      end
    end

    context "when the score risk is equal to or above the minimum recommendation threshold" do
      it "returns 'deny'" do
        transaction_data = {
          user_id: user.id,
          transaction_id: 1,
          merchant_id: 29744,
          card_number: "434505******9116",
          transaction_date: "2019-11-31T23:16:32.812632",
          transaction_amount: 3000,
          device_id: 285475
        }

        allow_any_instance_of(Transactions::CalculateScoreRisk).to receive(:call).and_return(75)

        recommendation = Transactions::CheckRecommendation.new(user, transaction_data).call
        expect(recommendation).to eq("deny")
      end
    end
  end
end