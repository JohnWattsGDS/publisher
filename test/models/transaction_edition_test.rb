require "test_helper"

class TransactionEditionTest < ActiveSupport::TestCase
  setup do
    @artefact = FactoryBot.create(:artefact)
  end

  context "Department analytics profiles" do
    should "only allow valid Google Analytics profiles" do
      transaction = FactoryBot.create(:transaction_edition, panopticon_id: @artefact.id)

      %w[invalid ua-12345 UA-1234A-1].each do |id|
        transaction.department_analytics_profile = id
        refute transaction.valid?
      end

      %w[ua-123456-1 UA-00-10].each do |id|
        transaction.department_analytics_profile = id
        assert transaction.valid?
      end
    end
  end

  context "indexable_content" do
    should "include the introduction without markup" do
      transaction = FactoryBot.create(:transaction_edition, introduction: "## introduction", more_information: "", panopticon_id: @artefact.id)
      assert_equal "introduction", transaction.indexable_content
    end

    should "include the more_information without markup" do
      transaction = FactoryBot.create(:transaction_edition, more_information: "## more info", introduction: "", panopticon_id: @artefact.id)
      assert_equal "more info", transaction.indexable_content
    end
  end

  should "trim whitespace from URLs" do
    transaction = FactoryBot.build(:transaction_edition, link: " https://www.gov.uk ")
    assert transaction.valid?
    assert transaction.link == "https://www.gov.uk"
  end
end
