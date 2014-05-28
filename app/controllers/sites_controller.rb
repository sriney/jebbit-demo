class SitesController < ApplicationController
  respond_to :json # default to Active Model Serializers

  def index
    respond_with Site.all
  end

  def show
    respond_with Site.find(params[:id])
  end

  def create
    respond_with Site.create(site_params)
  end

  def update
    respond_with Site.update(params[:id], site_params)
  end

  def destroy
    respond_with Site.destroy(params[:id])
  end

  private
  def site_params
    params.require(:site).permit(:name, :img_url, :landing_url, :created_at, :author) # only allow these for now
  end
end
