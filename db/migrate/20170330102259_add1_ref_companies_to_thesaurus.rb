class Add1RefCompaniesToThesaurus < ActiveRecord::Migration[5.0]
  def change
     add_reference :companies, :thesauru, foreign_key: true
  end
end
