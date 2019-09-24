task bulk_discard_placeholder_draft_content: :environment do
  # Result of running ContentItem.where(schema_name: "placeholder", publishing_app: "publisher").order_by(:base_path.asc).pluck(:base_path, :content_id)
  # in the draft content store, paths included for some readability.
  [
    ["/change-vehicle-tax-rate", "3fd872e6-0b51-4a13-be5f-f67da80ecc5d"],
    ["/diffuse-mesothelioma-payments", "ff352e2b-1269-4ab6-8b12-ea9040b25951"],
    ["/done/deposit-foreign-marriage", "2f0812ec-9671-4851-9d46-6fa6fb3985e1"],
    ["/done/register-sorn-statutory-off-road-notification", "86f2615f-602e-4e6e-98cd-cd35cad005ff"],
    ["/erdf-low-carbon-grant", "36ef73e9-b2ec-4631-b837-3643bbef348f"],
    ["/graduate-recruitment-grap-programme", "4355fdc9-833e-44c9-949c-66cf4a704178"],
    ["/low-carbon-building-project", "8b883728-1ec8-4383-b8fb-981cbba71c82"],
    ["/ready-for-business", "4a159e85-6848-492c-8f2e-28d24e9989eb"],
    ["/sustainabuild", "2aefe932-8abf-4a4a-9ae4-468fd09d3d83"],
    ["/work-after-state-pension-age", "effa2e51-352e-4a4d-b974-c881283633c6"],
  ].each do |(base_path, content_id)|
    begin
      Services.publishing_api.discard_draft(content_id)
    rescue StandardError
      puts "Failed to discard #{base_path} (#{content_id})"
    end
  end
end
