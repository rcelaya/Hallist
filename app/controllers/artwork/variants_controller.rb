class Artwork::VariantsController < ApplicationController
  def destroy
    @variant = Variant.find(params[:id])
    @variant.destroy
    redirect_to :back
  end
end
