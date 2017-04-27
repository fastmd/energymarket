class DeleteCompanyFromThesaurus < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW vcompanies;")
    execute("DELETE FROM public.thesaurus WHERE name = 'company';")                       
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
