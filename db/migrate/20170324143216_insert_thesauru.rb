class InsertThesauru < ActiveRecord::Migration[5.0]
 def change
   add_column :thesaurus, :cvalue, :string
 end
end 
