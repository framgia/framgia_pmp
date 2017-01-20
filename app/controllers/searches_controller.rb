class SearchesController < ApplicationController

  def index
    @search = Project.ransack params[:q]
    @projects = Kaminari.paginate_array(@search.result.first(Settings.per_page))
      .page(params[:page])
  end
end
