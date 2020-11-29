FactoryBot.define do
  factory :izettle_purchase do
    amount { "9.99" }
    purchased_at { "2020-11-15 23:59:58" }
    id { "" }
    cc_masked_number { "MyString" }
    cc_brand { "MyString" }
    comanda_id { nil }
  end
end
