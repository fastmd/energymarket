class DropRefCompaniesToThesaurus < ActiveRecord::Migration[5.0]
  def change

     remove_reference(:thesaurus, :meter, index: true, foreign_key: true)
  
  end
end
