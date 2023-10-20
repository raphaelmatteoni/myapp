class CreateChargebacks < ActiveRecord::Migration[7.0]
  def change
    create_table :chargebacks do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
