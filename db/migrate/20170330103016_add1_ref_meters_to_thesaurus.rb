class Add1RefMetersToThesaurus < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :meters, :thesaurus
  end
end
