class AddMesubstationsFields < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :mess_id, :integer
  end
end
