# frozen_string_literal: true

require "rails_helper"

RSpec.describe Goal, type: :model do
  subject { create(:goal) }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(180) }

    describe "validates end_date is after start_date" do
      subject { build(:goal, end_date: 1.day.ago, start_date: DateTime.now) }

      it { is_expected.not_to be_valid }
    end
  end

  describe "#progress" do
    context "When the goal doesn't have key results" do
      it "returns 0" do
        expect(subject.progress).to be 0.0
      end
    end

    context "When the goal has key results" do
      before do
        subject.key_results << key_results
      end

      describe "and none of them are completed" do
        let!(:key_results) { create_list(:key_result, 3, :in_progress) }

        it "returns 0" do
          expect(subject.progress).to be 0.0
        end
      end

      describe "and some of them are completed" do
        let!(:key_results) do
          [
            create(:key_result),
            create(:key_result, :in_progress),
            create(:key_result, :completed)
          ]
        end

        it "returns the correct percentage according to the completed ones" do
          expect(subject.progress).to be 0.33
        end
      end

      describe "and all of them are completed" do
        let!(:key_results) { create_list(:key_result, 3, :completed) }

        it "returns 1" do
          expect(subject.progress).to be 1.0
        end
      end
    end
  end
end
