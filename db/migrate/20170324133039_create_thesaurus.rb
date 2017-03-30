class CreateThesaurus < ActiveRecord::Migration[5.0]
  def change
    create_table :thesaurus do |t|
      t.integer :category
      t.string :name
      t.boolean :f

      t.timestamps
    end
  end
end
