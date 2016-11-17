class AddFieldsToMvalues < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :actdae, :date
    add_column :mvalues, :actp180, :string
    add_column :mvalues, :actp280, :string
    add_column :mvalues, :actp380, :string
    add_column :mvalues, :actp480, :string
    
  end
end
