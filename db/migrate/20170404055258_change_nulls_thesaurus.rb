class ChangeNullsThesaurus < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :thesaurus, :name, false
    change_column_null    :thesaurus, :cvalue, false 
    change_column_null    :thesaurus, :f, false
    change_column_default :thesaurus, :f, true      
  end
end
