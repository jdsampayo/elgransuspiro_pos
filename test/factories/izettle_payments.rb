FactoryBot.define do
  factory :izettle_payment do
    payed_at { "2020-11-14 09:39:54" }
    amount { "9.99" }
    type { 1 }
    transaction_id { "" }
    comanda { nil }
  end
end
