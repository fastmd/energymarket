class ChangeNullsLines < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :lines, :name, false
    change_column_null    :lines, :l, false
    change_column_null    :lines, :r, false
    change_column_null    :lines, :k_tr, false
    change_column_null    :lines, :k_f, false
    change_column_null    :lines, :f, false
    change_column_null    :lines, :wire_id, false
    change_column_null    :lines, :mesubstation_id, false
    change_column_null    :lnparams, :line_id, false
    change_column_null    :wires, :name, false
    change_column_null    :wires, :ro, false
    change_column_null    :wires, :k_scr, false
    change_column_null    :wires, :k_peb, false
    change_column_null    :wires, :q, false
    change_column_null    :wires, :f, false
  end
end
