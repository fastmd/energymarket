class UpdateThesauruidToCompanies < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.companies SET thesauru_id = ( select t2.id tid from  public.thesaurus t2 where trim(shname) = t2.cvalue ) ;")
  end
  def down
   raise ActiveRecord::IrreversibleMigration
  end 
end
