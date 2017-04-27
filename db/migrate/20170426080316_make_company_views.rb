class MakeCompanyViews < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vcompanies AS
             SELECT  t.*
                     FROM public.companies t
                    WHERE t.f = true
                    ORDER BY t.id, t.name;")
    execute("CREATE OR REPLACE VIEW public.vallcompanies AS
             SELECT   t.*
                     FROM public.companies t
                    ORDER BY t.id, t.name;")                                  
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
