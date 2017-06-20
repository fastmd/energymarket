class AddFlagF280ToMpoints < ActiveRecord::Migration[5.0]
  def change
     add_column :mpoints, :f280, :boolean
  end
end
