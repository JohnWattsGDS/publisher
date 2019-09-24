require "test_helper"

class PublishingApiWorkflowBypassPublisherTest < ActiveSupport::TestCase
  setup do
    UpdateService.stubs(:call)
    PublishService.stubs(:call)
  end

  context ".call" do
    context "when there is both a live and a draft edition" do
      should "discard the draft edition in the publishing-api" do
        create_draft_and_live_editions
        Services.publishing_api.expects(:discard_draft).with(artefact.content_id).once
        PublishingApiWorkflowBypassPublisher.call(artefact)
      end

      should "republish the currently live edition" do
        create_draft_and_live_editions
        RepublishService.expects(:call).with(live_edition).once
        PublishingApiWorkflowBypassPublisher.call(artefact)
      end

      should "replace the draft edition in the publishing-api" do
        create_draft_and_live_editions
        UpdateService.expects(:call).with(draft_edition).once
        PublishingApiWorkflowBypassPublisher.call(artefact)
      end
    end

    context "when there is a live edition but no draft edition" do
      should "not call the discard-draft endpoint in the publishing-api" do
        create_live_edition
        Services.publishing_api.expects(:discard_draft).never
        PublishingApiWorkflowBypassPublisher.call(artefact)
      end

      should "republish the currently live edition" do
        create_live_edition
        RepublishService.expects(:call).with(live_edition).once
        PublishingApiWorkflowBypassPublisher.call(artefact)
      end
    end

    context "when there is no live or draft edition" do
      should "does nothing" do
        create_archived_edition
        UpdateService.expects(:call).never
        RepublishService.expects(:call).never
        Services.publishing_api.expects(:discard_draft).never

        PublishingApiWorkflowBypassPublisher.call(artefact)
      end
    end

    context "when the artefact is nil" do
      should "does nothing" do
        UpdateService.expects(:call).never
        RepublishService.expects(:call).never
        Services.publishing_api.expects(:discard_draft).never

        PublishingApiWorkflowBypassPublisher.call(nil)
      end
    end
  end

  def live_edition
    @live_edition ||=
      FactoryBot.create(:transaction_edition, :published, panopticon_id: artefact.id)
  end

  def draft_edition
    @draft_edition ||=
      FactoryBot.create(:transaction_edition, state: "ready", panopticon_id: artefact.id)
  end

  def archived_edition
    @archived_edition ||=
      FactoryBot.create(:transaction_edition, state: "archived", panopticon_id: artefact.id)
  end

  def artefact
    @artefact ||= FactoryBot.create(:artefact)
  end

  def create_draft_and_live_editions
    draft_edition
    live_edition
  end

  def create_live_edition
    live_edition
  end

  def create_archived_edition
    archived_edition
  end
end
