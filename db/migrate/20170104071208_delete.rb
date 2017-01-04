class Delete < ActiveRecord::Migration[5.0]
  def change
    remove_column :mvalues, :actdae
  end
end
