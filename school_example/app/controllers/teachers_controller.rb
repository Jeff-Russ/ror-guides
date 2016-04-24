class TeachersController < ApplicationController
  def index
    @teachers = Teacher.order("last_name ASC")
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
  end
  
  def update
  end
  
  def destroy
  end
end