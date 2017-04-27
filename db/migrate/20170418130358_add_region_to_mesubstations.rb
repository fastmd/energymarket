class AddRegionToMesubstations < ActiveRecord::Migration[5.0]
  def change
    add_column :mesubstations, :region_id, :integer
    add_foreign_key :mesubstations, :thesaurus, column: :region_id
    add_column :mesubstations, :filial_id, :integer
    add_foreign_key :mesubstations, :filials
    add_column :mesubstations, :f, :boolean
    change_column_default :mesubstations, :f, true 
    add_index :mesubstations, :region_id
    add_index :mesubstations, :filial_id
  end
end
