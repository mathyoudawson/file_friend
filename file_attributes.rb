require 'date'
require 'byebug'

class FileAttributes

  attr_accessor :initiating_transaction_id, :request_id, :actual_change_date,
              :nmi, :nmi_checksum, :meter_serial_number, :index_value, :read_date,
              :house_number, :street_name, :street_type, :suburb, :post_code, :id,
              :catsm_change_response_attrs, :catsm_req_attrs, :catsm_pen_attrs,
              :catsm_com_attrs, :mdmtm_acn_attrs, :nmidm_attrs

  # the current time in seconds
  # guarantees uniqueness (pretty much)
  def initialize
    @id = Time.now.to_i
  end

  def initiating_transaction_id
    @initiating_transaction_id || 'POWRSHOP-5999999'
  end

  def request_id
    @request_id || '999999'
  end

  def actual_change_date
    @actual_change_date || Date.today.to_s
  end

  def nmi
    @nmi || '5310093303'
  end

  def nmi_checksum
    @nmi_checksum || '9'
  end

  def meter_serial_number
    @meter_serial_number || '1000MG'
  end

  def index_value
    @index_value || '2000'
  end

  def read_date
    actual_change_date
  end

  def house_number
    @house_number || '357'
  end

  def street_name
    @street_name || 'Collins'
  end

  def street_type
    @street_type || 'STRT'
  end

  def suburb
    @suburb || 'Melbourne'
  end

  def post_code
    @post_code || '3002'
  end

  def checksum_for_nmi(nmi)
    return if nmi.nil?
    doubling_offset = 1 - nmi.length % 2

    v = nmi.to_s.each_byte.each_with_index.sum do |byte, index|
      byte *= 2 if index % 2 == doubling_offset
      byte.to_s.each_char.sum(&:to_i)
    end

    @nmi_checksum = (10 - (v % 10)) % 10
  end

  def catsm_change_response_attrs
    @catsm_change_response_attrs = {
        message_id:                "catsm-change-res-msg-#{id}",
        transaction_id:            "catsm-change-res-txn-#{id}",
        initiating_transaction_id: initiating_transaction_id,
        request_id:                request_id
    }
  end

  def catsm_req_attrs
    @catsm_req_attrs = {
        message_id:         "catsm-req-msg-#{id}",
        transaction_id:     "catsm-req-txn-#{id}",
        request_id:         request_id,
        actual_change_date: actual_change_date,
        checksum:           nmi_checksum,
        nmi:                nmi
    }
  end

  def catsm_pen_attrs
    @catsm_pen_attrs = {
        message_id:         "catsm-pen-msg-#{id}",
        transaction_id:     "catsm-pen-txn-#{id}",
        request_id:         request_id,
        actual_change_date: actual_change_date,
        checksum:           nmi_checksum,
        nmi:                nmi
    }
  end

  def catsm_com_attrs
    @catsm_com_attrs = {
        message_id:         "catsm-com-msg-#{id}",
        transaction_id:     "catsm-com-txn-#{id}",
        request_id:         request_id,
        actual_change_date: actual_change_date,
        checksum:           nmi_checksum,
        nmi:                nmi
    }
  end

  def mdmtm_acn_attrs
    @mdmtm_acn_attrs = {
        message_id:          "mdmtm_acn-msg-#{id}",
        transaction_id:      "mdmtm_acn-txn-#{id}",
        checksum:            nmi_checksum,
        nmi:                 nmi,
        meter_serial_number: meter_serial_number,
        index_value:         index_value,
        read_date:           read_date
    }
  end

  def nmidm_attrs
    @nmidm_attrs = {
        message_id:                "nmidm-msg-#{id}",
        transaction_id:            "nmidm-txn-#{id}",
        initiating_transaction_id: initiating_transaction_id,
        checksum:                  nmi_checksum,
        nmi:                       nmi,
        meter_serial_number:       meter_serial_number,
        house_number:              house_number,
        street_name:               street_name,
        street_type:               street_type,
        suburb:                    suburb,
        post_code:                 post_code
    }
  end
end