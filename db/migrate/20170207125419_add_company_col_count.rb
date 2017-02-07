class AddCompanyColCount < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :shname, :string
    add_column :companies, :mpoints_count, :integer
  end
end
