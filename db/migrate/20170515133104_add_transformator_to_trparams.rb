class AddTransformatorToTrparams < ActiveRecord::Migration[5.0]
    add_column :trparams, :transformator_id, :integer
    add_foreign_key :trparams, :transformators
    add_index :trparams, :transformator_id
end
