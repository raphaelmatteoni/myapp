require 'rails_helper'

RSpec.describe Transactions::CalculateScoreRisk do
  fixtures :users, :transactions, :chargebacks

  describe "#call" do
    it "calculates the score based on consecutive transactions" do
      user = users(:one)
      transaction = transactions(:one)
      user.transactions << transaction
      score = Transactions::CalculateScoreRisk.new(user, transaction).call
      expect(score).to eq(40)
    end


    it "calculates the score based on transaction amount" do
      user = users(:one)
      transaction = transactions(:one)
      transaction.transaction_amount = 3000
      user.transactions << transaction
      score = Transactions::CalculateScoreRisk.new(user, transaction).call
      expect(score).to eq(140)
    end

    it "calculates the score based on chargebacks" do
      user = users(:one)
      transaction = transactions(:one)
      chargeback = chargebacks(:one)
      user.chargebacks << chargeback
      score = Transactions::CalculateScoreRisk.new(user, transaction).call
      expect(score).to eq(100)
    end
  end
end
