class RemakeViewsForMpoints2 < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vallmpoints AS
               SELECT 
                  t.*,
                  ( SELECT v.filial_id
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation_id) AS filial_id,
                  ( SELECT v.region_id
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation_id) AS region_id,
                  ( SELECT v.name
                         FROM companies v
                        WHERE t.company_id = v.id) AS company_name,
                  ( SELECT v.shname
                         FROM companies v
                        WHERE t.company_id = v.id) AS company_shname,
                  ( SELECT v.name
                         FROM furnizors v
                        WHERE v.id = t.furnizor_id) AS furnizor_name,
                  ( SELECT f.name
                         FROM mesubstations v,
                          filials f
                        WHERE v.id = t.mesubstation_id AND v.filial_id = f.id) AS filial_name,
                  ( SELECT f.cvalue
                         FROM mesubstations v,
                          thesaurus f
                        WHERE v.id = t.mesubstation_id AND v.region_id = f.id) AS region_name,
                  ( SELECT v.name
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation_id) AS mesubstation_name,
                  m.propdate,
                  m.voltcl mproperty_voltcl,
                  m.cosfi,
                  m.fct,
                  m.fctc,
                  m.fctl,
                  m.four,
                  m.fturn,
                  m.fmargin,
                  m.fminuslinelosses,    
                  m.comment as mproperty_comment,
                  m.f as mproperty_f,
                  m.id as prop_id
                 FROM mpoints t left outer join mproperties m on t.id=m.mpoint_id
                ORDER BY  t.company_id, t.id, m.propdate;")  
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end   
end

