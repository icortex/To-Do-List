class TasksController < ApplicationController

  def index
    @task = Task.new
    @tasks = case params[:status]
               when 'pending'
                 @title = :pending_tasks
                 Task.pending
               when 'done'
                 @title = :tasks_done
                 Task.done
               when 'expired'
                 @title = :expired_tasks
                 Task.expired
               else
                 @title = :all_tasks
                 Task
             end
    @tasks = @tasks.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])
    @tasks = Task.all

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: 'Task was successfully created.' }
      else
        format.html { render action: "index" }
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
    end
  end
end
