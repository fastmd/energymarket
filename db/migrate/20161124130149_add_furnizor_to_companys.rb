class AddFurnizorToCompanys < ActiveRecord::Migration[5.0]
  def change
    add_reference :companies, :furnizor, foreign_key: true
  end
end
