class AddTimestampsToMinput < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:minputs)
  end 
end
