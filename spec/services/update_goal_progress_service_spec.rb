# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateGoalProgressService do
  let!(:goal) { create(:goal) }
  let(:service) { described_class.new(goal_id: goal.id) }

  describe "Updates the goal with the correct progress" do
    context "When the goal doesn't have key results" do
      it "returns 0" do
        service.call
        expect(goal.reload.progress).to eq 0
      end
    end

    context "When the goal has key results" do
      describe "and none of them are completed" do
        let!(:key_results) { create_list(:key_result, 3, :in_progress, goal:) }

        it "returns 0" do
          service.call
          expect(goal.reload.progress).to eq 0
        end
      end

      describe "and some of them are completed" do
        let!(:key_results) do
          [
            create(:key_result, goal:),
            create(:key_result, :in_progress, goal:),
            create(:key_result, :completed, goal:)
          ]
        end

        it "returns the correct percentage according to the completed ones" do
          service.call
          expect(goal.reload.progress).to eq 0.33
        end
      end

      describe "and all of them are completed" do
        let!(:key_results) { create_list(:key_result, 3, :completed, goal:) }

        it "returns 1" do
          service.call
          expect(goal.reload.progress).to eq 1.0
        end
      end
    end
  end
end
