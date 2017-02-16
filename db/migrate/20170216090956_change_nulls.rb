class ChangeNulls < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :companies, :furnizor_id, false
    change_column_null    :companies, :filial_id, false
    change_column_null    :companies, :name, false
    change_column_null    :companies, :shname, false
    change_column_null    :companies, :f, false
    change_column_default :companies, :name, 'потребитель'
    change_column_default :companies, :shname, 'потребитель'
    change_column_default :companies, :f, true
    change_column_null    :filials, :name, false
    change_column_null    :furnizors, :name, false
    change_column_default :filials, :name, 'филиал'
    change_column_default :furnizors, :name, 'поставщик'
    change_column_null    :mesubstations, :name, false
    change_column_default :mesubstations, :name, 'подстанция'            
  end
end
