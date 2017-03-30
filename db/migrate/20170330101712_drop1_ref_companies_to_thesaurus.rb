class Drop1RefCompaniesToThesaurus < ActiveRecord::Migration[5.0]
  def change
    remove_reference(:thesaurus, :companies, index: true, foreign_key: true)
  end
end
