# frozen_string_literal: true

require "rails_helper"

RSpec.describe Goal, type: :model do
  subject { create(:goal) }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(180) }

    describe "validates end_date is after started_at" do
      subject { build(:goal, ended_at: 1.day.ago, started_at: DateTime.now) }

      it { is_expected.not_to be_valid }
    end
  end
end
