# frozen_string_literal: true

require "rails_helper"

RSpec.describe KeyResult, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "#scopes" do
    subject { KeyResult.all }

    let!(:completed_kr) { create(:key_result, :completed) }
    let!(:in_progress_kr) { create(:key_result, :in_progress) }

    describe ".in_progress" do
      it "returns only key results that are in progress" do
        expect(subject.in_progress).to eq [in_progress_kr]
      end
    end

    describe ".completed" do
      it "returns only key results that are completed" do
        expect(subject.completed).to eq [completed_kr]
      end
    end
  end

  describe "#in_progress?" do
    let!(:completed_kr) { create(:key_result, :completed) }
    let!(:in_progress_kr) { create(:key_result, :in_progress) }

    it "returns true if the key result is in progress, false otherwise" do
      aggregate_failures do
        expect(completed_kr.in_progress?).to be false
        expect(in_progress_kr.in_progress?).to be true
      end
    end
  end

  describe "#completed?" do
    let!(:completed_kr) { create(:key_result, :completed) }
    let!(:in_progress_kr) { create(:key_result, :in_progress) }

    it "returns true if the key result is completed, false otherwise" do
      aggregate_failures do
        expect(completed_kr.completed?).to be true
        expect(in_progress_kr.completed?).to be false
      end
    end
  end

  describe "#status" do
    context "When the key result has not started" do
      let!(:kr) { create(:key_result) }

      it { expect(kr.status).to eq :non_started }
    end

    context "When the key result is in progress" do
      let!(:kr) { create(:key_result, :in_progress) }

      it { expect(kr.status).to eq :in_progress }
    end

    context "When the key result is completed" do
      let!(:kr) { create(:key_result, :completed) }

      it { expect(kr.status).to eq :completed }
    end
  end
end
