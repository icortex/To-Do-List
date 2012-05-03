require 'spec_helper'

describe "Tasks", :focus do

  describe "A User" do
    describe "should be able to create a task so that he/she does not forget something to do" do
      before(:all) do
        visit root_path
        click_link 'New Task'
        fill_in 'task_name', with: 'Buy milk'
        click_button 'Create Task'
      end

      subject {page}
      it 'should see the created task in the main list' do
        should have_content 'Buy milk'
      end

    end

    describe "should be able to create a task with a deadline so that he/she does not miss deadline" do
      before do
        visit root_path
        click_link 'New Task'
        fill_in 'task_name', with: 'Buy milk'
        fill_in 'task_deadline', with: '2012-12-21'
        click_button 'Create Task'
      end

      subject {page}

      it 'should see the created task with deadline in the main list' do
        should_have_the_task_listed
      end

    end

    describe "should be able to edit a task so that he/she can change a task after it has been created" do

      # Factory would be nice
      let!(:task){Task.create!(name: 'Buy milk', deadline: Date.tomorrow)}

      before do
        visit root_path
        click_link 'Edit'
        fill_in 'task_name', with: 'Buy milk'
        fill_in 'task_deadline', with: '2012-12-21'
        click_button 'Update Task'
      end

      subject {page}

      it 'should see the edited task in the main list' do
        should_have_the_task_listed
      end

    end

    describe "should be able to mark a task as done so that he/she can distinguish incomplete tasks from complete ones" do

      # Factory would be nice
      let!(:task){Task.create!(name: 'Buy milk', deadline: Date.parse('2012-12-21'))}

      before do
        visit root_path
        check 'done'
      end

      subject {page}
      it "should have the done mark checked in the main list" do
        should have_checked_field 'done'
      end

      it "should be in the done list" do
        click_link 'Done'
        save_and_open_page
        should_have_the_task_listed
      end

    end

    def should_have_the_task_listed
      should have_content 'Buy milk'
      should have_content '21 December 2012'
    end

  end
end
