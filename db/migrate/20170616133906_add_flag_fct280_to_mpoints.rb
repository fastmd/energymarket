class AddFlagFct280ToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mvalues, :fct280, :boolean
  end
end
