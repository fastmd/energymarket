class AddIndexFurnFilToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_index :mpoints, :furnizor_id
    add_index :mpoints, :filial_id
  end
end
