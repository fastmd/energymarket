class AddFlagToTrparams < ActiveRecord::Migration[5.0]
  def change
    add_column :lnparams, :f, :boolean, column_options: { null: false, default: true }
    add_column :trparams, :f, :boolean, column_options: { null: false, default: true }
  end
end
