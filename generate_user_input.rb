#!/usr/bin/env ruby
require 'erb'
require 'zip'
require 'date'
require 'byebug'

def zip(filename)
  xml_path = File.expand_path('xml', __dir__)
  zip_path = File.expand_path('zip', __dir__)

  file = File.open(xml_path + "/#{filename}.xml")

  Zip::File.open("#{zip_path}/#{filename}.zip", Zip::File::CREATE) do |z|
    z.add("#{filename}.xml", file)
  end
end

def generate_next_transaction_id(transaction)
  transaction_number = (transaction.match(/\d+/).to_s.to_i + 2).to_s
  transaction_text = transaction.match(/\D+/).to_s
  transaction_text + transaction_number
end

# catsm_change_response
def generate_catsm_change_response(attrs)
  byebug
  message_id = attrs.fetch(:message_id)
  transaction_id = attrs.fetch(:transaction_id)
  initiating_transaction_id = generate_next_transaction_id(attrs.fetch(:initiating_transaction_id))
  request_id = attrs.fetch(:request_id)

  filename      = 'catsm_change_response'
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
  street_name = attrs.fetch(:street_name)
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

def get_input(field)
  puts "Please enter #{field}: "
  gets.chomp
end

# def get_nmi
#   begin
#     puts "Please enter a NMI which is 10 digits long: "
#     user_input = gets.chomp
#      until user_input.match?(/^\d{10}$/)
#        puts "Please make sure NMI is 10 digits long: "
#        user_input = gets.chomp
#      end
#   end
# end

def get_nmi
  puts "Please enter a NMI which is 10 digits long: "
  user_input = gets.chomp

  until user_input.match?(/^\d{10}$/)
    puts "Please make sure NMI is 10 digits long: "
    user_input = gets.chomp
  end
  user_input
end


def get_valid_date
  begin
    puts "Please enter the actual change date with the format YYYY-MM-DD: "
    user_input = gets.chomp
    Date.strptime(user_input, '%Y-%m-%d')
  rescue ArgumentError
    puts "Invalid date"
    retry
  end
end

def checksum_for_nmi(nmi)
  return if nmi.nil?
  doubling_offset = 1 - nmi.length % 2

  v = nmi.to_s.each_byte.each_with_index.sum do |byte, index|
    byte *= 2 if index % 2 == doubling_offset
    byte.to_s.each_char.sum(&:to_i)
  end

  (10 - (v % 10)) % 10
end

initiating_transaction_id = get_input("initiating_transaction_id") # 'POWERSHOP-TNS-111'
request_id                = get_input("Request Id")
actual_change_date        = get_valid_date
nmi                       = get_nmi
nmi_checksum              = checksum_for_nmi(nmi)
meter_serial_number       = get_input("Meter Serial Number")
index_value               = get_input("Index Value")
read_date                 = actual_change_date
house_number              = get_input("House Number")
street_name               = get_input("Street Name")
street_type               = get_input("Street Type")
suburb                    = get_input("Suburb")
post_code                 = get_input("Post Code")

# the current time in seconds
# guarantees uniqueness (pretty much)
id = Time.now.to_i

catsm_change_response_attrs = {
  message_id:                "catsm-change-res-msg-#{id}",
  transaction_id:            "catsm-change-res-txn-#{id}",
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
  street_name:             street_name,
  street_type:               street_type,
  suburb:                    suburb,
  post_code:                 post_code
}

generate_catsm_change_response(catsm_change_response_attrs)
generate_catsm_req(catsm_req_attrs)
generate_catsm_pen(catsm_pen_attrs)
generate_catsm_com(catsm_com_attrs)
generate_mdmtm_acn(mdmtm_acn_attrs)
generate_nmidm(nmidm_attrs)

`find . -maxdepth 4 -type f -iname "*#{id}.xml" | xargs -I '{}' xmllint --noout --schema ~/Documents/schemas/r29/schema/aseXML_r29.xsd '{}'`