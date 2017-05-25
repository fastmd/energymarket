class Drop1ColsLnparams < ActiveRecord::Migration[5.0]
  def change
    remove_column    :lnparams, :mark, :string
  end
end
