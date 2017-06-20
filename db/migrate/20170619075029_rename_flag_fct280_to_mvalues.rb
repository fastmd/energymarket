class RenameFlagFct280ToMvalues < ActiveRecord::Migration[5.0]
  def change
    rename_column :mvalues, :fct280, :fanulare
  end
end
