# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { "Authorization" => token_generator(user.id) } }

  describe "#call" do
    context "when the request is valid" do
      subject { described_class.new(header) }

      it "returns user object" do
        expect(subject.current_user).to eq(user)
      end
    end

    context "when the request is invalid" do
      context "when missing token" do
        subject { described_class.new({}) }

        it "raises a MissingToken error" do
          expect { subject.current_user }
            .to raise_error(ExceptionHandler::MissingToken, "Missing token")
        end
      end

      context "when invalid token" do
        subject do
          described_class.new("Authorization" => token_generator(5))
        end

        it "raises an InvalidToken error" do
          expect { subject.current_user }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context "when token is expired" do
        let(:header) { { "Authorization" => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }

        it "raises ExceptionHandler::ExpiredSignature error" do
          expect { request_obj.current_user }
            .to raise_error(
              ExceptionHandler::InvalidToken,
              /Signature has expired/
            )
        end
      end

      context "fake token" do
        let(:header) { { "Authorization" => "foobar" } }
        subject(:invalid_request_obj) { described_class.new(header) }

        it "handles JWT::DecodeError" do
          expect { invalid_request_obj.current_user }
            .to raise_error(
              ExceptionHandler::InvalidToken,
              /Not enough or too many segments/
            )
        end
      end
    end
  end
end
