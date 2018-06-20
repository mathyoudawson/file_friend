# Could these attrs have their own model which we assign in a user input class?
require_relative ('file_attributes.rb')
require_relative('user_input.rb')
require_relative('generate_file.rb')
require 'erb'

class GenerateGasInbound

  def initialize
    @file_attributes = FileAttributes.new
  end

  def generate_next_transaction_id(transaction)
    transaction_number = (transaction.match(/\d+/).to_s.to_i + 2).to_s
    transaction_text = transaction.match(/\D+/).to_s
    transaction_text + transaction_number
  end

# catsm_change_response
  def generate_catsm_change_response(attrs)
    # TODO: by taking attrs instead of binding generate_next_transaction_id has been deprecated , should this method be moved into file attributes
    message_id = attrs.fetch(:message_id)
    filename      = 'catsm_change_response'
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    GenerateFile.new.zip(message_id)
  end

# catsm_req
  def generate_catsm_req(attrs)
    message_id = attrs.fetch(:message_id)
    filename      = 'catsm_req'
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    GenerateFile.new.zip(message_id)
  end

# catsm_pen
  def generate_catsm_pen(attrs)
    message_id = attrs.fetch(:message_id)
    filename      = 'catsm_pen'
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    GenerateFile.new.zip(message_id)
  end

# catsm_com
  def generate_catsm_com(attrs)
    message_id = attrs.fetch(:message_id)
    filename      = 'catsm_com'
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    GenerateFile.new.zip(message_id)
  end

# mdmtm_acn
  def generate_mdmtm_acn(attrs)
    message_id = attrs.fetch(:message_id)
    filename      = 'mdmtm_acn'
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    GenerateFile.new.zip(message_id)
  end

  def generate_nmidm(attrs)
    message_id = attrs.fetch(:message_id)
    filename      = 'nmidm'
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    GenerateFile.new.zip(message_id)
  end

  def generate_all_files
    generate_nmidm(@file_attributes.nmidm_attrs)
    generate_catsm_change_response(@file_attributes.catsm_change_response_attrs)
    generate_catsm_req(@file_attributes.catsm_req_attrs)
    generate_catsm_pen(@file_attributes.catsm_pen_attrs)
    generate_catsm_com(@file_attributes.catsm_com_attrs)
    generate_mdmtm_acn(@file_attributes.mdmtm_acn_attrs)
  end

  def generate_au_gas_files
    user_input = UserInput.new(@file_attributes)
    user_input.set_attrs
    generate_all_files
    GenerateFile.new.validate(@file_attributes.id)
  end
end

generator = GenerateGasInbound.new
generator.generate_au_gas_files