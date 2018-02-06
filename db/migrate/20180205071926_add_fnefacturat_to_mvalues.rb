class AddFnefacturatToMvalues < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :fnefact, :boolean
  end
end
