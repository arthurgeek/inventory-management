# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]

  def new
    @staffs = current_location.staffs.all
  end

  def create
    @staff = Staff.find_by(id: params[:staff][:id])

    login @staff

    redirect_to root_path, notice: 'Signed in.'
  end

  def destroy
    logout

    redirect_to root_path, notice: 'Signed out.'
  end
end
