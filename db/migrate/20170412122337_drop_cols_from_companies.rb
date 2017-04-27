class DropColsFromCompanies < ActiveRecord::Migration[5.0]
  def change
    remove_index :companies, :furnizor_id
    remove_index :companies, :filial_id
    remove_foreign_key :companies, :furnizors
    remove_foreign_key :companies, :filials 
    remove_column :companies, :furnizor_id, :integer
    remove_column :companies, :filial_id, :integer    
  end
end
