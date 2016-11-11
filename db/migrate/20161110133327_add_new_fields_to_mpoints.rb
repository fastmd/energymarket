class AddNewFieldsToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :messtation, :string
    add_column :mpoints, :meconname, :string
    add_column :mpoints, :clsstation, :string
    add_column :mpoints, :clconname, :string
    add_column :mpoints, :voltcl, :string
    add_column :mpoints, :metertype, :string
    add_column :mpoints, :meternum, :integer
    add_column :mpoints, :koeftt, :string
    add_column :mpoints, :koeftn, :string
    add_column :mpoints, :koefcalc, :integer
  end
end
