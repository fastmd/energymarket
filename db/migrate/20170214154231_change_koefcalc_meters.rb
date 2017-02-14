class ChangeKoefcalcMeters < ActiveRecord::Migration[5.0]
  def change
    remove_column :meters, :koefcalc, :integer
    add_column :meters, :koefcalc, :float, null: false, default: 1    
  end
end
