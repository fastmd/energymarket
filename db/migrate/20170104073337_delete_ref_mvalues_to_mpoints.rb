class DeleteRefMvaluesToMpoints < ActiveRecord::Migration[5.0]
  def change
    remove_reference :mvalues, :mpoint
  end
end
