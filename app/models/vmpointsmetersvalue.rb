class Vmpointsmetersvalue < ActiveRecord::Base
  self.table_name = "public.vmpointsmetersmvalues"
  # set which DATE columns should be converted to Ruby Date using ActiveRecord Attribute API
  # Starting from Oracle enhanced adapter 1.7 Oracle `DATE` columns are mapped to Ruby `Date` by default.
  #attribute :data_nasterii, :date
  
  #attribute :rn, :integer 
  #attribute :dday, :integer
  #attribute :dmonth, :integer     
  # set which DATE columns should be converted to Ruby Time using ActiveRecord Attribute API
  #attribute :last_login_time, :datetime

  # set which VARCHAR2 columns should be converted to true and false using ActiveRecord Attribute API
  #attribute :manager, :boolean
  #attribute :active, :boolean

  # set which columns should be ignored in ActiveRecord
  #ignore_table_columns :attribute1, :attribute2
end
