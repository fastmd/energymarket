class AddMeterMetertypeid < ActiveRecord::Migration[5.0]
 def change
   add_column :meters, :metertype_id, :integer
 end
end
