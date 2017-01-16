class AddCompaniesColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :comment, :text
  end
end
