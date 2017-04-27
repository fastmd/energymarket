class DropNotneededColumns < ActiveRecord::Migration[5.0]
  def change
    remove_index :mpoints, :filial_id
    remove_index :companies, :thesauru_id
    remove_foreign_key :mpoints, :filials 
    remove_foreign_key :mpoints, :thesaurus
    remove_foreign_key :companies, :thesaurus
    remove_column :companies, :thesauru_id, :integer
    remove_column :filials, :cod_id, :integer
    remove_column :furnizors, :cod_id, :string
    remove_column :mpoints, :filial_id, :integer
    remove_column :mpoints, :thesauru_id, :integer 
  end
end
