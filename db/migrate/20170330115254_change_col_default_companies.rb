class ChangeColDefaultCompanies < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:companies, :name, nil)
    change_column_default(:companies, :shname, nil)
  end
end
