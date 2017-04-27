class AddForeignkeyRegion < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mesubstations SET f = true WHERE f is null;")
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
