class AddMeterThesauruid < ActiveRecord::Migration[5.0]
  def change
       add_column :meters, :thesauru_id, :integer
  end
end
