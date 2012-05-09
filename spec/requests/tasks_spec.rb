require 'spec_helper'

describe "Tasks" do

  describe "A User" do
    describe "should be able to create a task so that he/she does not forget something to do", :clean_db do
      before(:all) do
        visit root_path
        click_link t(:new_task)
        fill_in 'task_name', with: 'Buy milk'
        click_button t(:create_task)
      end

      subject {page}
      it 'should see the created task in the main list' do
        should have_content 'Buy milk'
      end

    end

    describe "should be able to create a task with a deadline so that he/she does not miss deadline", :clean_db do
      before do
        visit root_path
        click_link t(:new_task)
        fill_in 'task_name', with: 'Buy milk'
        fill_in 'task_deadline', with: '2012-12-21'
        click_button t(:create_task)
      end

      subject {page}

      it 'should see the created task with deadline in the main list' do
        should_have_the_task_listed
      end

    end

    describe "should be able to edit a task so that he/she can change a task after it has been created", :clean_db do

      let!(:task){create(:task, deadline: Date.tomorrow)}

      before do
        visit root_path
        click_link 'Edit'
        fill_in 'task_name', with: 'Buy milk'
        fill_in 'task_deadline', with: '2012-12-21'
        click_button t(:update_task)
      end

      subject {page}

      it 'should see the edited task in the main list' do
        should_have_the_task_listed
      end

    end

    describe "should be able to mark a task as done so that he/she can distinguish incomplete tasks from complete ones", :clean_db do

      let!(:task){create(:task)}

      before do
        visit root_path
      end

      subject {page}
      it "should have the done mark checked in the main list and be accordingly updated" do
        pending "HOW TO CHECK BUT HAVE JS TRIGGERED?"
        check 'done'
        should_have_the_task_listed
        task.reload.should be_done
      end

      it "should be in the done list" do
        task.mark_as_done
        click_link 'Done'
        should_have_the_task_listed
      end

    end

    describe "should be able to see all tasks which didn't meet deadline as of today", :clean_db do

      let!(:task){create(:expired_task)}

      subject {page}
      it "should be in the expired list" do
        visit expired_tasks_path
        should_have_the_expired_task_listed
      end

      it "should be in the all list" do
        visit tasks_path
        should_have_the_expired_task_listed
      end

      it "should not be in the pending list" do
        visit pending_tasks_path
        should_not_have_the_expired_task_listed
      end

      it "should not be in the done list" do
        visit done_tasks_path
        should_not_have_the_expired_task_listed
      end

    end

    describe "should be able to delete a task so that he/she can remove a task which is not a task anymore", :clean_db do

      subject {page}

      describe 'deleted task should not be in any list' do

        it "should not be in the all list" do
          create(:task)
          visit root_path
        end

        it "should not be in the done list" do
          create(:done_task)
          visit done_tasks_path
        end

        it "should not be in the pending list" do
          create(:task)
          visit pending_tasks_path
        end

        it "should not be in the expired list" do
          create(:expired_task)
          visit expired_tasks_path
        end

        after do
          click_link t(:delete)
          should_not_have_the_task_listed
          Task.count.should be_zero
        end

      end

    end

    describe "should be able to see paginated results on all lists (10 per page)", :clean_db do

      subject {page}
      it "in the all list" do

        create_tasks_for_two_pages

        visit tasks_path
        should_show_page_one

        click_link 'Next'
        should_show_page_two

      end

      it "in the expired list" do
        create_tasks_for_two_pages :expired_task

        visit expired_tasks_path
        should_show_page_one

        click_link 'Next'
        should_show_page_two
      end

      it "in the pending list" do
        create_tasks_for_two_pages :pending_task

        visit pending_tasks_path
        should_show_page_one

        click_link 'Next'
        should_show_page_two
      end

      it "in the done list" do
        create_tasks_for_two_pages :done_task

        visit done_tasks_path
        should_show_page_one

        click_link 'Next'
        should_show_page_two
      end

      def should_show_page_one
        10.times do |i|
          should have_content "Page 1 Task #{i}"
        end

        2.times do |i|
          should_not have_content "Page 2 Task #{10+i}"
        end
      end

      def should_show_page_two
        10.times do |i|
          should_not have_content "Page 1 Task #{i}"
        end
        2.times do |i|
          should have_content "Page 2 Task #{10+i}"
        end
      end

      # Type, expired_task, done_task, pending_task
      def create_tasks_for_two_pages(type = :task)
        10.times{ |i| create(type, name: "Page 1 Task #{i}") }
        2.times{ |i| create(type, name: "Page 2 Task #{10+i}") }
      end

    end

    describe "should be able to tasks search by name" do
      before(:all) do
        tasks = []
        tasks << create(:task, name: 'Use webkit')
        tasks << create(:task, name: 'Keep dOg')
        tasks << create(:task, name: 'Adopt kittens')
        tasks << create(:task, name: 'Call kid')
        tasks << create(:task, name: 'Feed dog')
      end

      before do
        visit root_path
      end

      subject {page}
      it 'should return results that contain kit' do
        fill_in 'q_name_cont', with: 'kit'
        click_button t(:search)
        should have_content 'Adopt kittens'
        should have_content 'Use webkit'
        should_not have_content 'Feed dog'
        should_not have_content 'Call kid'
      end

      it 'should return results that contain something similar like DoG' do
        fill_in 'q_name_cont', with: 'DoG'
        click_button t(:search)
        should have_content 'Keep dOg'
        should have_content 'Feed dog'

        should_not have_content 'Adopt kittens'
        should_not have_content 'Use webkit'
      end
    end

    def should_have_the_task_listed
      should have_content 'Buy milk'
      should have_content '21 December 2012'
    end

    def should_have_the_expired_task_listed
      should have_content 'Buy milk'
      should have_content Date.yesterday.strftime('%d %B %Y')
    end

    def should_not_have_the_expired_task_listed
      should_not have_content 'Buy milk'
      should_not have_content Date.yesterday.strftime('%d %B %Y')
    end

    def should_not_have_the_task_listed
      should_not have_content 'Buy milk'
      should_not have_content '21 December 2012'
    end

  end

end
