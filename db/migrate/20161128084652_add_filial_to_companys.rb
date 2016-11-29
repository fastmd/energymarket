class AddFilialToCompanys < ActiveRecord::Migration[5.0]
  def change
    add_reference :companies, :filial, foreign_key: true
  end
end
