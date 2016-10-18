class CompanysController < ApplicationController
  def new
  end

  def show
   @cp =  Company.find(params[:id])
   @mp =  @cp.mpoints.all
  end

  def index
  end
end
