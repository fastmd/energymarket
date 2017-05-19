class AddUnomToTransformators < ActiveRecord::Migration[5.0]
  def change
    add_column :transformators, :unom, :string
  end
end
