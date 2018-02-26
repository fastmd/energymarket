class ChangeDigitsFromMeters < ActiveRecord::Migration[5.0]
  def change
    execute("UPDATE public.meters SET beforedigs=NULL;")
    execute("UPDATE public.meters SET afterdigs=NULL;") 
    change_column_default :meters, :beforedigs, nil
    change_column_default :meters, :afterdigs, nil      
  end
end
