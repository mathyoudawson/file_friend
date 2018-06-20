require 'byebug'

class UserInput
  def  initialize(attributes_instance)
    @file_attributes = attributes_instance
  end

  def get_input(field)
    puts "Please enter #{field}, default is #{@file_attributes.send(field)}:"
    set_input(field, gets.chomp)
  end

  def set_input(field, value)
     unless value.to_s.empty?
      case field
      when 'nmi'
        @file_attributes.nmi = get_nmi
      when 'checksum'
        @file_attributes.nmi_checksum = value
      when 'initiating_transaction_id'
        @file_attributes.initiating_transaction_id = value
      when 'Request Id'
        @file_attributes.request_id = value
      when 'Meter Serial Number'
        @file_attributes.meter_serial_number = value
      when 'date'
        @file_attributes.actual_change_date = get_valid_date
      when 'Index Value'
        @file_attributes.index_value = value
      when 'House Number'
        @file_attributes.house_number = value
      when 'Street Name'
        @file_attributes.street_name = value
      when 'Street Type'
        @file_attributes.street_type = value
      when 'Suburb'
        @file_attributes.suburb = value
      when 'Post Code'
        @file_attributes.post_code = value
      else
        puts "Error occurred setting field: #{field} with value: #{value}"
      end
    end
  end

  def get_nmi
    puts 'Please enter a NMI which is 10 digits long: '
    user_input = gets.chomp

    until user_input.match?(/^\d{10}$/)
      puts 'Please make sure NMI is 10 digits long: '
      user_input = gets.chomp
    end
    checksum_for_nmi(user_input)
  end


  def get_valid_date
    begin
      puts 'Please enter the actual change date with the format YYYY-MM-DD: '
      user_input = gets.chomp
      date = Date.strptime(user_input, '%Y-%m-%d')
    rescue ArgumentError
      puts 'Invalid date'
      retry
    end
    date
  end

  def checksum_for_nmi(nmi)
    return if nmi.nil?
    doubling_offset = 1 - nmi.length % 2

    v = nmi.to_s.each_byte.each_with_index.sum do |byte, index|
      byte *= 2 if index % 2 == doubling_offset
      byte.to_s.each_char.sum(&:to_i)
    end

    checksum = (10 - (v % 10)) % 10
    set_input('checksum', checksum)
  end

  def set_attrs
    get_input('nmi')
    get_input('initiating_transaction_id')
    get_input('request_id')
    get_input('meter_serial_number')
    get_input('actual_change_date')
    get_input('index_value')
    get_input('house_number')
    get_input('street_name')
    get_input('street_type')
    get_input('suburb')
    get_input('post_code')
  end
end