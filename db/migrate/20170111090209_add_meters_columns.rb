class AddMetersColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :meters, :relevance_date, :date
    add_column :meters, :comment, :string
  end
end
