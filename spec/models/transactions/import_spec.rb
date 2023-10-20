# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe Transactions::Import do
  describe '#call' do
    it 'creates users and transactions from CSV' do
      csv_fixture_path = Rails.root.join('spec', 'fixtures', 'transactional-sample.csv')
      import = Transactions::Import.new(File.open(csv_fixture_path))

      expect { import.call }.to change(User, :count).by(26)
                                    .and change(Transaction, :count).by(30)
    end

    it 'creates chargebacks when has_cbk is TRUE' do
      csv_fixture_path = Rails.root.join('spec', 'fixtures', 'transactional-sample.csv')
      import = Transactions::Import.new(File.open(csv_fixture_path))

      expect { import.call }.to change(Chargeback, :count).by(8)
    end
  end
end