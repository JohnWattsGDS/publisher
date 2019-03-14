namespace :publishing_api do
  desc 'republish content'
  task republish_content: [:environment] do
    republish Edition.published
    republish_draft Edition.draft_in_publishing_api
  end

  desc 'republish by format'
  task :republish_by_format, [:format] => :environment do |_, args|
    format_editions = Edition.by_format(args[:format])

    republish format_editions.published
    republish_draft format_editions.draft_in_publishing_api
  end

  desc 'republish drafts by format'
  task :republish_drafts_by_format, [:format] => :environment do |_, args|
    format_editions = Edition.by_format(args[:format])

    republish_draft format_editions.draft_in_publishing_api
  end

  desc 'Publish the experimental knowledge API'
  task publish_knowledge: [:environment] do
    KnowledgeApi.new.publish
  end

  desc "Republish an edition"
  task :republish_edition, %w(slug) => :environment do |_, args|
    republish Edition.published.where(slug: args[:slug])
    republish_draft Edition.draft_in_publishing_api.where(slug: args[:slug])
  end

  def republish(editions)
    puts
    puts "Scheduling republishing of #{editions.count} editions"

    editions.each do |edition|
      RepublishWorker.perform_async(edition.id.to_s)
      print "."
    end

    puts
    puts "Scheduling finished"
  end

  def republish_draft(draft_editions)
    puts
    puts "Scheduling republishing of #{draft_editions.count} draft editions"

    draft_editions.each do |draft_edition|
      UpdateWorker.perform_async(draft_edition.id.to_s)
      print "."
    end

    puts
    puts "Scheduling finished"
  end
end
