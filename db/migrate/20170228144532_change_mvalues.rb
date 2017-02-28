class ChangeMvalues < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :r, :boolean, column_options: { default: true }
  end
end
