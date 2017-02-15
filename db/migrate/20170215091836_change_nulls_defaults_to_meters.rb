class ChangeNullsDefaultsToMeters < ActiveRecord::Migration[5.0]
  def change
    change_column_null    :meters, :koeftn, false
    change_column_default :meters, :koeftn, '1 / 1'
    change_column_null    :meters, :metertype, false
    change_column_default :meters, :metertype, 'ZMD'
    change_column_null    :meters, :meternum, false
    change_column_null    :meters, :mpoint_id, false
    change_column_null    :meters, :relevance_date, false
    change_column_null    :meters, :f, false
    change_column_default :meters, :f, true
  end
end
