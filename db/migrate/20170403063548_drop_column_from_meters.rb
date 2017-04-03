class DropColumnFromMeters < ActiveRecord::Migration[5.0]
  def change
    remove_column :meters, :metertype, :string
  end
end
