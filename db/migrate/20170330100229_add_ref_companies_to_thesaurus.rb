class AddRefCompaniesToThesaurus < ActiveRecord::Migration[5.0]
  def change
    add_reference :thesaurus, :companies, foreign_key: true
  end
end
