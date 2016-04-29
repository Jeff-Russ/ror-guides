class TeachersController < ApplicationController
  def index
    @teachers = Teacher.order("last_name ASC")
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def new
    @teacher = Teacher.new
    puts "### in teachers#new"
  end

  def edit
  end

  def create
    puts "### in teachers#create"
    puts "#{params}"
    # instantiate a (unsaved) teacher object
    # with mass-assigment and whitelisting:
    @teacher = Teacher.new(teacher_params)

    if @teacher.save # <- save w/ test
      flash[:notice] = "New teacher added!"
      # success! send user to teacher index:
      redirect_to(action: 'index')
      puts "Save successful!"
    else
      # falure. send user back to form.
      # (where @teacher can prepopulate)
      render('new')
    end
  end

  def update
    # find teacher being updated: 
    @teacher = Teacher.find(params[:id])

    if @teacher.update_attributes(teacher_params)
      flash[:notice] = "Teacher updated!"
      # success! send user to teacher SHOW page:
      redirect_to(action: 'show', id:  @teacher.id ) 
    else
      # falure. send user back to EDIT form.
      # (where @teacher can prepopulate)
      render('edit')
    end
  end
  
  def delete
    @teacher = Teacher.find(params[:id])
  end
  
  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy
    flash[:notice] = "Teacher deleted!"
    redirect_to(action: 'index')
  end

 private
  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name)
  end
end