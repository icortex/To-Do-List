require 'spec_helper'

describe "tasks/edit", :focus do
  before(:each) do
    @task = assign(:task, stub_model(Task,
      :name => "Buk milk",
      :done => false
    ))
  end

  it "renders the edit task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tasks_path(@task), :method => "post" do
      assert_select "input#task_name", :name => "task[name]", class: 'required'
      assert_select "input#task_done", :name => "task[done]"
      assert_select "input#task_deadline", :name => "task[deadline]"
    end
  end
end
