class LnparamsCondateToDatetime < ActiveRecord::Migration[5.0]
  def change
    execute("DROP VIEW public.vallmpointslnparams;")
    execute("DROP VIEW public.valllnparams;")
    execute("DROP VIEW public.vmpointslnparams;")
    execute("DROP VIEW public.vlnparams;")    
    change_column(:lnparams, :condate, :datetime)
    change_column_null(:lnparams, :condate, false)    
  end
end
