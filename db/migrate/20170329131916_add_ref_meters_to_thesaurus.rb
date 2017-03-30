class AddRefMetersToThesaurus < ActiveRecord::Migration[5.0]
  def change
     add_reference :thesaurus, :meter, foreign_key: true
  end
end
