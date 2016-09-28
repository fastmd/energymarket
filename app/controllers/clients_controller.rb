class ClientsController < ApplicationController
  def new
  end

  def index
    @companies = Companies.all
  end

  def show
  end
end
