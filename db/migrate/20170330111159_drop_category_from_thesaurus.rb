class DropCategoryFromThesaurus < ActiveRecord::Migration[5.0]
  def change
    remove_column :thesaurus, :category, :integer
  end
end
