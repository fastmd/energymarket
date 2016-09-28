class CreateTrparams < ActiveRecord::Migration[5.0]
  def change
    create_table :trparams do |t|
      t.float :pxx
      t.float :pkz
      t.float :snom
      t.float :ukz
      t.float :io
      t.float :qkz
      t.belongs_to :mpoint, index: true
      t.timestamps
    end
  end
end
