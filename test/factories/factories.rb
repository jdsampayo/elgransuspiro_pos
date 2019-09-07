FactoryBot.define do
  factory :categoria do
    nombre { 'calientes' }
  end

  factory :desechable do
    en_bodega { 100 }
    cantidad { 1 }
    costo_unitario { 0.5 }
    limite { 10 }

    trait :vaso do
      nombre { 'vaso' }
    end

    trait :tapa do
      nombre { 'tapa' }
    end
  end

  factory :articulo do
    nombre { 'Cappuccino' }
    precio { 30.0 }
    categoria
  end
end
