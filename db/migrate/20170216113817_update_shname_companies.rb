class UpdateShnameCompanies < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.companies SET shname = substring(name from 1 for 15);")
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
