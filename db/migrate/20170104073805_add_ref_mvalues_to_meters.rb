class AddRefMvaluesToMeters < ActiveRecord::Migration[5.0]
  def change
     add_reference :mvalues, :meter, foreign_key: true
  end
end
