class AddCortesToGastos < ActiveRecord::Migration[5.1]
  def change
    Gasto.all.each do |gasto|
      dia = gasto.created_at.to_date
      corte = Corte.where(dia: dia).take
      gasto.corte = corte
      gasto.save
    end
  end
end
