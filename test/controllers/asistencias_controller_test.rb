# == Schema Information
#
# Table name: asistencias
#
#  id           :uuid             not null, primary key
#  mesero_id    :uuid
#  corte_id     :uuid
#  horas        :bigint(8)
#  horas_extra  :bigint(8)
#  retardo      :boolean
#  falta        :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  hora_entrada :datetime
#  hora_salida  :datetime
#

require 'test_helper'

class AsistenciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asistencia = asistencias(:one)
  end

  test "should get index" do
    get asistencias_url
    assert_response :success
  end

  test "should get new" do
    get new_asistencia_url
    assert_response :success
  end

  test "should create asistencia" do
    assert_difference('Asistencia.count') do
      post asistencias_url, params: { asistencia: { corte_id: @asistencia.corte_id, falta: @asistencia.falta, horas: @asistencia.horas, horas_extra: @asistencia.horas_extra, mesero_id: @asistencia.mesero_id, retardo: @asistencia.retardo } }
    end

    assert_redirected_to asistencia_url(Asistencia.last)
  end

  test "should show asistencia" do
    get asistencia_url(@asistencia)
    assert_response :success
  end

  test "should get edit" do
    get edit_asistencia_url(@asistencia)
    assert_response :success
  end

  test "should update asistencia" do
    patch asistencia_url(@asistencia), params: { asistencia: { corte_id: @asistencia.corte_id, falta: @asistencia.falta, horas: @asistencia.horas, horas_extra: @asistencia.horas_extra, mesero_id: @asistencia.mesero_id, retardo: @asistencia.retardo } }
    assert_redirected_to asistencia_url(@asistencia)
  end

  test "should destroy asistencia" do
    assert_difference('Asistencia.count', -1) do
      delete asistencia_url(@asistencia)
    end

    assert_redirected_to asistencias_url
  end
end
