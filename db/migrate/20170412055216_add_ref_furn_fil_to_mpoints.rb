class AddRefFurnFilToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :furnizor_id, :integer
    add_foreign_key :mpoints, :furnizors
    add_column :mpoints, :filial_id, :integer
    add_foreign_key :mpoints, :filials
  end
end
