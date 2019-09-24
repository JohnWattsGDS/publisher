require "integration_test_helper"

class DeleteEditionTest < ActionDispatch::IntegrationTest
  setup do
    content_id = SecureRandom.uuid
    @artefact = FactoryBot.create(
      :artefact,
      slug: "i-dont-want-this",
      content_id: content_id,
      kind: "guide",
      name: "Foo bar",
      owning_app: "publisher",
    )

    @edition = FactoryBot.create(:guide_edition, panopticon_id: @artefact.id)

    setup_users
    stub_linkables
    stub_holidays_used_by_fact_check
  end

  teardown do
    GDS::SSO.test_user = nil
  end

  test "deleting a draft edition discards the draft in the publishing api" do
    visit_edition @edition

    click_on "Admin"

    Services.publishing_api.expects(:discard_draft).with(@artefact.content_id)

    click_button "Delete this edition – #1"

    within(".alert-success") do
      assert page.has_content?("Guide destroyed")
    end
  end
end
