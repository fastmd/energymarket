class AddRegToCompanys < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :region, :string
  end
end
