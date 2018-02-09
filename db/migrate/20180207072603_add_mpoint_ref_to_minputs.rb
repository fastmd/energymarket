class AddMpointRefToMinputs < ActiveRecord::Migration[5.0]
  def change
    add_reference :minputs, :mpoint, foreign_key: true
    change_column_null :minputs, :mpoint_id, false
  end
end
