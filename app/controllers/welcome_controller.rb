class WelcomeController < ApplicationController
  def index
    
    @companies = Company.all
    
  end
end
