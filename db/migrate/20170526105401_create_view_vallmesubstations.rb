class CreateViewVallmesubstations < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vallmesubstations AS
              SELECT  t.id,
                      t.name,
                      t.cod,
                      t.filial_id, 
                      ( SELECT v.name
                             FROM public.filials v
                            WHERE v.id = t.filial_id) AS filial_name,
                      t.region_id,      
                      ( SELECT v.cvalue
                             FROM  public.thesaurus v
                            WHERE v.id = t.region_id and v.name='region') AS region_name,
                      t.f,
                      t.created_at,
                      t.updated_at
                     FROM public.mesubstations t
                    ORDER BY t.filial_id,t.region_id, t.cod, t.name, t.id;")
    execute("CREATE OR REPLACE VIEW public.vmesubstations AS
             SELECT t.id,
                      t.name,
                      t.cod,
                      t.filial_id, 
                      ( SELECT v.name
                             FROM public.filials v
                            WHERE v.id = t.filial_id) AS filial_name,
                      t.region_id,      
                      ( SELECT v.cvalue
                             FROM  public.thesaurus v
                            WHERE v.id = t.region_id and v.name='region') AS region_name,
                      t.f,
                      t.created_at,
                      t.updated_at
                     FROM public.mesubstations t where t.f=true
                    ORDER BY t.filial_id,t.region_id, t.cod, t.name, t.id;")                                                                              
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
