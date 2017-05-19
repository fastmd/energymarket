class ChUnomToTransformators < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :transformators, :unom, false
  end
end
