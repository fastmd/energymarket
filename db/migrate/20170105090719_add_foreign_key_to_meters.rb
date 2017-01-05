class AddForeignKeyToMeters < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :meters, :mpoints
  end
end
