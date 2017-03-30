class Update1ShnameToCompanies < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.companies 
             SET 
                shname = COALESCE(substring(name FROM '\"(.*?)\"'), substring(name from 1 for 15))
             where thesauru_id is not null 
            ;")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
