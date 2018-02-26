class AddSignesToMeters < ActiveRecord::Migration[5.0]
  def change
    add_column :meters, :beforedigs, :integer, :default => 6
    add_column :meters, :afterdigs, :integer, :default => 4
    execute("UPDATE public.meters SET beforedigs=6 where beforedigs IS NULL;")
    execute("UPDATE public.meters SET afterdigs=4 where afterdigs IS NULL;")  
  end
end
