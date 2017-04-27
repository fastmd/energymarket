class Add1ForeignkeyRegion < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :mesubstations, :thesaurus, column: :region_id
    change_column_null    :mesubstations, :f, false
  end
end
