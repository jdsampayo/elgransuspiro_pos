# frozen_string_literal: true

require 'net/http'
require 'uri'

class Izettle

  def initialize(credentials)
    @client_id = credentials[:client_id]
    @assertion = credentials[:assertion]
  end

  def token
    @token ||= authenticate['access_token']
  end

  def authenticate
    uri = URI.parse('https://oauth.izettle.com/token')

    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/x-www-form-urlencoded'
    request.set_form_data(
      assertion: @assertion,
      client_id: @client_id,
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer'
    )

    Rails.logger.info "Authenticating iZettle"

    call(request, uri)
  end

  def balance(type='LIQUID')
    uri = URI.parse("https://finance.izettle.com/organizations/us/accounts/#{type}/balance")

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{token}"

    call(request, uri)
  end

  def transactions(date_start, date_end, type='LIQUID')
    uri = URI.parse("https://finance.izettle.com/organizations/us/accounts/#{type}/transactions?start=#{date_start.iso8601}&end=#{date_end.iso8601}")

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{token}"

    Rails.logger.info "Transactions iZettle #{uri}"

    call(request, uri)['data']
  end

  def purchases(date_start, date_end)
    uri = URI.parse("https://purchase.izettle.com/purchases/v2?startDate=#{date_start.iso8601}&endDate=#{date_end.iso8601}")

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{token}"

    Rails.logger.info "Purchases iZettle #{uri}"

    call(request, uri)['purchases']
  end

  def call(request, uri)
    req_options = {
      use_ssl: (uri.scheme == 'https')
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    unless response.code == '200'
      raise "Unsuccessful call to #{uri.hostname}: #{response.code} #{response.body}"
    end

    return JSON.parse(response.body)
  rescue TypeError
    raise "Can't parse response of #{uri.hostname}: #{response.body}"
  end
end
