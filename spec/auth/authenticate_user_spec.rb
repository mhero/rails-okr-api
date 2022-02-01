# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthenticateUser do
  # create test user
  let!(:user) { create(:user, password: "hola") }

  describe "#call" do
    context "when valid credentials" do
      subject { described_class.new(username: user.username, password: "hola") }

      it "returns an auth token" do
        token = subject.call
        expect(token).not_to be_nil
      end
    end

    context "when invalid credentials" do
      subject { described_class.new(username: "foo", password: "bar") }

      it "raises an authentication error" do
        expect { subject.call }
          .to raise_error(
            ExceptionHandler::AuthenticationError,
            /Invalid credentials/
          )
      end
    end
  end
end
