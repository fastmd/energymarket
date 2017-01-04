class DelMpointsMeterfields < ActiveRecord::Migration[5.0]
  def change
    remove_column :mpoints, :metertype
    remove_column :mpoints, :meternum
    remove_column :mpoints, :koeftt
    remove_column :mpoints, :koeftn
    remove_column :mpoints, :koefcalc
  end
end
