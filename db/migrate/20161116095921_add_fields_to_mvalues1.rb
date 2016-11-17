class AddFieldsToMvalues1 < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :actdate, :date
  end
end
