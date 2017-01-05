class AddForeignKeyToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :mpoints, :companies 
  end
end
