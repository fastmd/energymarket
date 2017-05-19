class UpdateUnomToTransformators < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.transformators SET unom = '10/0,4';")
    execute("DROP VIEW vmpointstrparams;")
    execute("DROP VIEW vtrparams;")
    execute("CREATE OR REPLACE VIEW public.vtrparams AS
               SELECT t.id,
                  tr.name,
                  tr.name mark,
                  tr.unom,
                  tr.snom,
                  tr.pxx,
                  tr.pkz,
                  tr.ukz,
                  tr.i0,
                  tr.i0 io,
                  tr.qkz,
                  t.comment,
                  t.f,
                  t.mpoint_id,
                  t.created_at,
                  t.updated_at,
                  tr.comment tr_comment,
                  tr.f tr_f
                 FROM trparams t left outer join transformators tr on t.transformator_id = tr.id
                WHERE t.f = true and tr.f = true
                ORDER BY t.mpoint_id, t.id;")
    execute("CREATE OR REPLACE VIEW public.vmpointstrparams AS
               SELECT t1.id,
                  t1.company_id,
                  t1.furnizor_id,
                  t1.filial_id,
                  t1.region_id,
                  t1.mesubstation_id,
                  t1.name,
                  t1.cod,
                  t1.company,
                  t1.furnizor,
                  t1.filial,
                  t1.region,
                  t1.mesubstation,
                  t1.meconname,
                  t1.voltcl,
                  t2.id AS tr_id,
                  t2.name transformator_name,
                  t2.mark,
                  t2.unom,
                  t2.snom,
                  t2.pxx,
                  t2.pkz,
                  t2.ukz,
                  t2.i0,
                  t2.io,
                  t2.qkz,
                  t2.comment,
                  t2.updated_at
                 FROM vmpoints t1
                   JOIN vtrparams t2 ON t1.id = t2.mpoint_id
                ORDER BY t1.company, t1.name, t1.id, t2.id;")                                                 
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
