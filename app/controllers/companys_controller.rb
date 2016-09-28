class CompanysController < ApplicationController
  def new
  end

  def show
   @cp =  Company.find(params[:num])
   @mp =  @cp.mpoints.all
  end

  def index
  end
end
