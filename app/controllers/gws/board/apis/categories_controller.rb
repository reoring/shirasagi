class Gws::Board::Apis::CategoriesController < ApplicationController
  include Gws::ApiFilter

  model Gws::Board::Category

  before_action :set_category

  private
    def set_category
      @groups = @model.site(@cur_site).reduce([]) do |ret, g|
        indent = "&nbsp;" * g.name.scan('/').size * 4
        ret << [ indent.html_safe + g.trailing_name, g.id ]
      end.to_a

      @group = params[:s] ? params[:s][:group] : nil
    end

    def parent_name
      return // unless @group
      parent = @model.where(id: @group).first
      return // unless parent
      /^#{parent.name}\//
    end

  public
    def index
      @multi = params[:single].blank?

      @items = @model.site(@cur_site).
        search(params[:s]).
        where(name: parent_name).
        page(params[:page]).per(50)
    end
end