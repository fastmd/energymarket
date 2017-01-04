class CreateMesubstations < ActiveRecord::Migration[5.0]
  def change
    create_table :mesubstations do |t|
      t.text :name
      t.text :vlclass
      t.integer :cod
      t.timestamps
    end
  end
end
