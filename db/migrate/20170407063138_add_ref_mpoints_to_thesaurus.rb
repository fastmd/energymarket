class AddRefMpointsToThesaurus < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :thesauru_id, :integer
    add_foreign_key :mpoints, :thesaurus
  end
end
