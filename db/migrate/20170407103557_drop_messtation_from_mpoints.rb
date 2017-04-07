class DropMesstationFromMpoints < ActiveRecord::Migration[5.0]
  def change
    remove_column :mpoints, :messtation, :string
  end
end
