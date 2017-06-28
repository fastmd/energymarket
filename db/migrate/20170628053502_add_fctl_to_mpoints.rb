class AddFctlToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :fctl, :boolean
  end
end
