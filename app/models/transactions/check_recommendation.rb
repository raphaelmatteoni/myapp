# frozen_string_literal: true

module Transactions
  class CheckRecommendation
    MIN_TO_RECOMMEND = 75

    def initialize(user, transaction_data)
      @user = user

      @transaction = Transaction.new(transaction_data)
    end

    def call
      score_risk = CalculateScoreRisk.new(@user, @transaction).call
      if score_risk < MIN_TO_RECOMMEND
        return "approve"
      else
        return "deny"
      end
    end
  end
end
