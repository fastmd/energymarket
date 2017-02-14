class AddFlagToMeters < ActiveRecord::Migration[5.0]
  def change
    add_column :meters, :f, :boolean, column_options: { null: false, default: true }
    add_column :mpoints, :f, :boolean, column_options: { null: false, default: true }
    add_column :companies, :f, :boolean, column_options: { null: false, default: true }
  end
end
