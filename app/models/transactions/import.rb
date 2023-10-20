# frozen_string_literal: true
require 'csv'

module Transactions
  class Import
    attr_reader :file

    def initialize(file = File.open('db/seeds/transactional-sample.csv'))
      @file = file
    end

    def call
      CSV.foreach(@file, headers: true) do |row|
        transaction_data = row.to_h
        create_user(transaction_data)
        create_transaction(transaction_data)
        create_chargeback(transaction_data) if transaction_data['has_cbk'] == 'TRUE'
      end      
    end

    private
    
    def create_user(transaction_data)
      @user = User.find_or_create_by(id: transaction_data['user_id'])
    end

    def create_transaction(transaction_data)
      @transaction = Transaction.create(
        id: transaction_data['transaction_id'],
        user_id: @user.id,
        merchant_id: transaction_data['merchant_id'],
        card_number: transaction_data['card_number'],
        transaction_amount: transaction_data['transaction_amount'],
        transaction_date: transaction_data['transaction_date'],
        device_id: transaction_data['device_id'],
        has_cbk: transaction_data['has_cbk']
      )
    end

    def create_chargeback(transaction_data)
      Chargeback.create(user_id: @user.id, transaction_id: @transaction.id)
    end
  end
end
  