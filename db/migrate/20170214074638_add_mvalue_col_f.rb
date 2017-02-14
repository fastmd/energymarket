class AddMvalueColF < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :f, :boolean, column_options: { null: false, default: true }
  end
end
