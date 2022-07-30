require 'rails_helper'

RSpec.describe ClosePollJob, :type => :job do
    let!(:first_user) { FactoryBot.create(:user, email: 'first@user.com', password: 'firstuser') }   
    let!(:poll) { FactoryBot.create(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
    describe "#perform_later" do           
        it "closes the poll" do
            ActiveJob::Base.queue_adapter = :test
            expect {
                ClosePollJob.set(queue: "default", wait_until: poll.created_at + 1.day).perform_later(poll.id)
            }
            .to have_enqueued_job.with(poll.id).on_queue("default").at(poll.created_at + 1.day)
        end
    end
end