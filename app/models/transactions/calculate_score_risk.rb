# frozen_string_literal: true

module Transactions
  class CalculateScoreRisk
    CONSECUTIVE_MULTIPLIER = 40

    def initialize(user, transaction)
      @user = user
      @transaction = transaction
    end
  
    def call
      total_score = 0

      total_score += check_consecutive_transactions_score
      total_score += check_transaction_amount_score
      total_score += check_chargeback_score

      return total_score
    end

    private

    def check_consecutive_transactions_score
      consecutive_count = 0
    
      user_transactions = @user.transactions.order(transaction_date: :desc)

      user_transactions.each do |transaction|
        if (transaction.transaction_date - @transaction.transaction_date).to_i < 3600
          consecutive_count += 1
        else
          consecutive_count = 0
        end
      end
    
      return consecutive_count * CONSECUTIVE_MULTIPLIER
    end

    def check_transaction_amount_score
      amount_limit = 2000
    
      time_window = 24 * 60 * 60  # 24 hours in seconds
    
      user_transactions = @user.transactions
                             .where("transaction_date >= ? AND transaction_date <= ?", 
                                    @transaction.transaction_date - time_window, @transaction.transaction_date)
    
      total_amount_within_window = user_transactions.sum(:transaction_amount)
    
      if total_amount_within_window + @transaction.transaction_amount > amount_limit
        return 100
      else
        return 0
      end
    end

    def check_chargeback_score
      return 100 if @user.chargebacks.present?
      return 0
    end
  end
end