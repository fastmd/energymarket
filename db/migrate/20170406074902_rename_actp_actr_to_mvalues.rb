class RenameActpActrToMvalues < ActiveRecord::Migration[5.0]
  def change
    rename_column :mvalues, :actr580, :actp580
    rename_column :mvalues, :actr880, :actp880
  end
end
