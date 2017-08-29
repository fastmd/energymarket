class AddOtpaikaToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :mesubstation2_id, :integer
    add_foreign_key :lines, :mesubstations, column: :mesubstation2_id
    add_index :lines, :mesubstation2_id
  end
end
