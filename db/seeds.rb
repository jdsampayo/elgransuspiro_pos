# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Mesero.create(nombre: 'Pablo')
Mesero.create(nombre: 'Mirel')

Articulo.create(nombre: 'Espresso', precio: 20)
Articulo.create(nombre: 'Espresso DOBLE', precio: 25)
Articulo.create(nombre: 'Americano', precio: 20)
Articulo.create(nombre: 'Americano GRANDE', precio: 25)
Articulo.create(nombre: 'Macchiato', precio: 25)
Articulo.create(nombre: 'Capuccino', precio: 25)
Articulo.create(nombre: 'Flat White', precio: 30)
Articulo.create(nombre: 'Latte', precio: 30)
Articulo.create(nombre: 'Latte GRANDE', precio: 35)
Articulo.create(nombre: 'Chocolate', precio: 25)
Articulo.create(nombre: 'Chocolate GRANDE', precio: 30)
Articulo.create(nombre: 'Infusiones o Tisanas', precio: 25)
Articulo.create(nombre: 'Infusiones o Tisanas GRANDE', precio: 30)

Articulo.create(nombre: 'Prensa Francesa', precio: 35)
Articulo.create(nombre: 'Aeropress', precio: 35)
Articulo.create(nombre: 'Clever', precio: 35)
Articulo.create(nombre: 'Dripper', precio: 35)
Articulo.create(nombre: 'V60 Decantado', precio: 35)
Articulo.create(nombre: 'V60 Frío', precio: 35)
Articulo.create(nombre: 'Chemex', precio: 35)

Articulo.create(nombre: 'Tetera', precio: 50)
Articulo.create(nombre: 'Tetera Matcha', precio: 80)

Articulo.create(nombre: 'Ciabatta Leónidas', precio: 60)
Articulo.create(nombre: 'Ciabatta Odiseo', precio: 60)
Articulo.create(nombre: 'Ciabatta Veggie', precio: 60)

Articulo.create(nombre: 'Postres', precio: 30)

Articulo.create(nombre: 'Malteada', precio: 40)
Articulo.create(nombre: 'Chocolate', precio: 35)
Articulo.create(nombre: 'Frappe', precio: 45)
Articulo.create(nombre: 'Soda Italiana', precio: 40)
Articulo.create(nombre: 'Smoothie Ensueño', precio: 35)
Articulo.create(nombre: 'Smoothie Aventura', precio: 35)

Articulo.create(nombre: 'Reposado', precio: 30)
Articulo.create(nombre: 'Carajillo', precio: 50)
Articulo.create(nombre: 'Affogato', precio: 35)

Articulo.create(nombre: 'Crepa Leónidas', precio: 60)
Articulo.create(nombre: 'Crepa Odiseo', precio: 60)
Articulo.create(nombre: 'Crepa Veggie', precio: 60)

Articulo.create(nombre: 'Crepa Cleopatra', precio: 50)
Articulo.create(nombre: 'Crepa Afrodita', precio: 50)
Articulo.create(nombre: 'Crepa Ixchel', precio: 50)

Extra.create(nombre: 'Cajeta', precio: 10)
Extra.create(nombre: 'Chocolate', precio: 10)
Extra.create(nombre: 'Crema Irlandesa', precio: 10)
Extra.create(nombre: 'Rompope', precio: 10)
Extra.create(nombre: 'Kalhúa', precio: 10)

Timecop.travel(1.days.ago)
corte = Corte.new(dia: Date.today, inicial: 0, siguiente_dia: 0)
corte.cerrar

=begin
def seed_day
  rand(1...8).times do

    comanda = Comanda.new()
    comanda.mesero = Mesero.order("RANDOM()").first

    rand(1...8).times do
      orden = Orden.new
      orden.cantidad = rand(1...4)
      orden.articulo = Articulo.order("RANDOM()").first
      comanda.ordenes << orden
    end

    comanda.save
  end

  gastos = ["verdura", "semilla", "helados", "agua"]
  rand(1...3).times do
    gasto = Gasto.new
    gasto.descripcion = gastos[rand(0...3)]
    gasto.monto = rand(10...100)
    gasto.save
  end

  corte = Corte.new(dia: Date.today, inicial: rand(100...300), siguiente_dia: rand(100...300))
  corte.cerrar
end

100.times do
  Timecop.travel(1.days.ago)
  seed_day
end
=end
