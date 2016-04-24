class ClassroomsController < ApplicationController
  def index
    @classrooms = Classroom.order("room_num ASC")
  end

  def show
  end

  def new
    @classroom = Classroom.new
  end

  def edit
  end

  def create
  end

  def destroy
  end
end
