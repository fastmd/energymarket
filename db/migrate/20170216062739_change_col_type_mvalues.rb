class ChangeColTypeMvalues < ActiveRecord::Migration[5.0]
  def change
    remove_column :mvalues, :actp180, :string 
    remove_column :mvalues, :actp280, :string 
    remove_column :mvalues, :actp380, :string    
    remove_column :mvalues, :actp480, :string 
    add_column :mvalues, :actp180, :decimal, :precision => 14, :scale => 4, column_options: { null: false, default: 0 }
    add_column :mvalues, :actp280, :decimal, :precision => 14, :scale => 4, column_options: { null: false, default: 0 }
    add_column :mvalues, :actp380, :decimal, :precision => 14, :scale => 4, column_options: { null: false, default: 0 }
    add_column :mvalues, :actp480, :decimal, :precision => 14, :scale => 4, column_options: { null: false, default: 0 }  
  end
end
