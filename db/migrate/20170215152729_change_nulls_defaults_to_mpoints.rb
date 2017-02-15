class ChangeNullsDefaultsToMpoints < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :mpoints, :messtation, false
    change_column_default :mpoints, :messtation, 'подстанция МЭ'
    change_column_null    :mpoints, :meconname, false
    change_column_default :mpoints, :meconname, 'фидер МЭ'
    change_column_null    :mpoints, :clsstation, false
    change_column_default :mpoints, :clsstation, 'подстанция клиента'
    change_column_null    :mpoints, :clconname, false
    change_column_default :mpoints, :clconname, 'фидер клиента'    
    change_column_null    :mpoints, :name, false
    change_column_default :mpoints, :name, 'точка учета'     
    change_column_null    :mpoints, :company_id, false
    change_column_null    :mpoints, :f, false
    change_column_default :mpoints, :f, true    
  end
end
