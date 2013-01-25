class Admin::EditionsController < ApplicationController

  before_filter :load_country, :only => [:create]
  before_filter :load_country_and_edition, :only => [:edit, :update]

  def create
    @edition = @country.build_new_edition_as(current_user)

    if @edition.save
      redirect_to edit_admin_edition_path(@edition)
    else
      redirect_to admin_country_path(@country.slug), :alert => "Failed to create new edition"
    end
  end

  def edit
  end

  def update
    if params[:edition][:note] && params[:edition][:note][:comment] && !params[:edition][:note][:comment].empty?
      @edition.build_action_as(current_user, Action::NOTE, params[:edition][:note][:comment])
    end

    if @edition.update_attributes(params[:edition])
      redirect_to edit_admin_edition_path(@edition), :alert => "#{@edition.title} updated."
    else
      flash[:alert] = "We had some problems saving: #{@edition.errors.full_messages.join(", ")}."
      render "/admin/editions/edit"
    end
  end

  def publish
    @edition = TravelAdviceEdition.find(params[:id])
    if @edition.publish_as(current_user)
      redirect_to admin_country_path(@edition.country_slug), :alert => "#{@edition.title} published."
    else
      redirect_to edit_admin_edition_path(@edition), :alert => "Only draft editions can be published."
    end
  end

  private

  def load_country_and_edition
    @edition = TravelAdviceEdition.find(params[:id])
    @country = Country.find_by_slug(@edition.country_slug)
  end

  def load_country
    @country = Country.find_by_slug(params[:country_id])
    error_404 unless @country
  end
end
