#!/usr/bin/env ruby
require 'erb'
require 'zip'

initiating_transaction_id = 'POWERSHOP-TNS-111'
request_id                = '12345'
actual_change_date        = '2018-10-10'
nmi                       = '5319999999'
nmi_checksum              = '1'
meter_serial_number       = '1000MG'
index_value               = '1234'
read_date                 = actual_change_date
house_number              = '357'
street_number             = 'Collins'
street_type               = 'STRT'
suburb                    = 'Melbourne'
post_code                 = '3002'

# the current time in seconds
# guarantees uniqueness (pretty much)
id = Time.now.to_i

catsm_change_request_attrs = {
  message_id:                "catsm-change-req-msg-#{id}",
  transaction_id:            "catsm-change-req-txn-#{id}",
  initiating_transaction_id: initiating_transaction_id,
  request_id:                request_id
}

catsm_req_attrs = {
  message_id:         "catsm-req-msg-#{id}",
  transaction_id:     "catsm-req-txn-#{id}",
  request_id:         request_id,
  actual_change_date: actual_change_date,
  checksum:           nmi_checksum,
  nmi:                nmi
}

catsm_pen_attrs = {
  message_id:         "catsm-pen-msg-#{id}",
  transaction_id:     "catsm-pen-txn-#{id}",
  request_id:         request_id,
  actual_change_date: actual_change_date,
  checksum:           nmi_checksum,
  nmi:                nmi
}

catsm_com_attrs = {
  message_id:         "catsm-com-msg-#{id}",
  transaction_id:     "catsm-com-txn-#{id}",
  request_id:         request_id,
  actual_change_date: actual_change_date,
  checksum:           nmi_checksum,
  nmi:                nmi
}

mdmtm_acn_attrs = {
  message_id:          "mdmtm_acn-msg-#{id}",
  transaction_id:      "mdmtm_acn-txn-#{id}",
  checksum:            nmi_checksum,
  nmi:                 nmi,
  meter_serial_number: meter_serial_number,
  index_value:         index_value,
  read_date:           read_date
}

nmidm_attrs = {
  message_id:                "nmidm-msg-#{id}",
  transaction_id:            "nmidm-txn-#{id}",
  initiating_transaction_id: initiating_transaction_id,
  checksum:                  nmi_checksum,
  nmi:                       nmi,
  meter_serial_number:       meter_serial_number,
  house_number:              house_number,
  street_number:             street_number,
  street_type:               street_type,
  suburb:                    suburb,
  post_code:                 post_code
}

def zip(filename)
  xml_path = File.expand_path('xml', __dir__)
  zip_path = File.expand_path('zip', __dir__)

  file = File.open(xml_path + "/#{filename}.xml")

  Zip::File.open("#{zip_path}/#{filename}.zip", Zip::File::CREATE) do |z|
    z.add("#{filename}.xml", file)
  end
end

# catsm_change_request
def generate_catsm_change_request(attrs)
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  initiating_transaction_id = attrs.fetch(:initiating_transaction_id)
  request_id = attrs.fetch(:request_id)

  filename      = 'catsm_change_request'
  template_path = File.expand_path('templates', __dir__)
  template      = File.read(template_path + "/#{filename}_template.xml.erb")

  File.open("xml/#{message_id}.xml", 'w+') do |f|
    f.write(ERB.new(template).result(binding))
  end

  zip(message_id)
end

# catsm_req
def generate_catsm_req(attrs)
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  request_id = attrs.fetch(:request_id)
  actual_change_date = attrs.fetch(:actual_change_date)
  checksum = attrs.fetch(:checksum)
  nmi = attrs.fetch(:nmi)

  filename      = 'catsm_req'
  template_path = File.expand_path('templates', __dir__)
  template      = File.read(template_path + "/#{filename}_template.xml.erb")

  File.open("xml/#{message_id}.xml", 'w+') do |f|
    f.write(ERB.new(template).result(binding))
  end

  zip(message_id)
end

# catsm_pen
def generate_catsm_pen(attrs)
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  request_id = attrs.fetch(:request_id)
  actual_change_date = attrs.fetch(:actual_change_date)
  checksum = attrs.fetch(:checksum)
  nmi = attrs.fetch(:nmi)

  filename      = 'catsm_pen'
  template_path = File.expand_path('templates', __dir__)
  template      = File.read(template_path + "/#{filename}_template.xml.erb")

  File.open("xml/#{message_id}.xml", 'w+') do |f|
    f.write(ERB.new(template).result(binding))
  end

  zip(message_id)
end

# catsm_com
def generate_catsm_com(attrs)
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  request_id = attrs.fetch(:request_id)
  actual_change_date = attrs.fetch(:actual_change_date)
  checksum = attrs.fetch(:checksum)
  nmi = attrs.fetch(:nmi)

  filename      = 'catsm_com'
  template_path = File.expand_path('templates', __dir__)
  template      = File.read(template_path + "/#{filename}_template.xml.erb")

  File.open("xml/#{message_id}.xml", 'w+') do |f|
    f.write(ERB.new(template).result(binding))
  end

  zip(message_id)
end

# mdmtm_acn
def generate_mdmtm_acn(attrs)
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  checksum = attrs.fetch(:checksum)
  nmi = attrs.fetch(:nmi)
  meter_serial_number = attrs.fetch(:meter_serial_number)
  index_value = attrs.fetch(:index_value)
  read_date = attrs.fetch(:read_date)

  filename      = 'mdmtm_acn'
  template_path = File.expand_path('templates', __dir__)
  template      = File.read(template_path + "/#{filename}_template.xml.erb")

  File.open("xml/#{message_id}.xml", 'w+') do |f|
    f.write(ERB.new(template).result(binding))
  end

  zip(message_id)
end

# nmidm
def generate_nmidm(attrs)
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  initiating_transaction_id = attrs.fetch(:initiating_transaction_id)
  checksum = attrs.fetch(:checksum)
  nmi = attrs.fetch(:nmi)
  meter_serial_number = attrs.fetch(:meter_serial_number)
  house_number = attrs.fetch(:house_number)
  street_number = attrs.fetch(:street_number)
  street_type = attrs.fetch(:street_type)
  suburb = attrs.fetch(:suburb)
  post_code = attrs.fetch(:post_code)

  filename      = 'nmidm'
  template_path = File.expand_path('templates', __dir__)
  template      = File.read(template_path + "/#{filename}_template.xml.erb")

  File.open("xml/#{message_id}.xml", 'w+') do |f|
    f.write(ERB.new(template).result(binding))
  end

  zip(message_id)
end

generate_catsm_change_request(catsm_change_request_attrs)
generate_catsm_req(catsm_req_attrs)
generate_catsm_pen(catsm_pen_attrs)
generate_catsm_com(catsm_com_attrs)
generate_mdmtm_acn(mdmtm_acn_attrs)
generate_nmidm(nmidm_attrs)

`find . -maxdepth 4 -type f -iname "*#{id}.xml" | xargs -I '{}' xmllint --noout --schema ~/Documents/schemas/r29/schema/aseXML_r29.xsd '{}'`