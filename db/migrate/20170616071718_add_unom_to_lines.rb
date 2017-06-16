class AddUnomToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :unom, :decimal, precision: 14, scale: 4 
  end
end
