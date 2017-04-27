class ChangeForeignkeyRegion < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :mesubstations, column: :region_id
  end
end
