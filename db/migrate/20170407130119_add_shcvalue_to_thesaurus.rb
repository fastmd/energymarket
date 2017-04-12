class AddShcvalueToThesaurus < ActiveRecord::Migration[5.0]
  def change
    add_column :thesaurus, :shcvalue, :string
    add_column :thesaurus, :cod, :string
  end
end
