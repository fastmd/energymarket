class DropMeterypeidFromMeters < ActiveRecord::Migration[5.0]
  def change
    remove_column :meters, :metertype_id, :integer
  end
end
