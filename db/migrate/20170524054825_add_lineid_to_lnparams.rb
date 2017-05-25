class AddLineidToLnparams < ActiveRecord::Migration[5.0]
  def change
    add_column :lnparams, :line_id, :integer
    add_foreign_key :lnparams, :lines
    add_index :lnparams, :line_id
    add_foreign_key :lines, :wires
    add_index :lines, :wire_id
    add_foreign_key :lines, :mesubstations
    add_index :lines, :mesubstation_id
  end
end
