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

# TODO: by taking attrs instead of binding generate_next_transaction_id has been deprecated , should this method be moved into file attributes

  def generate_all_files(file_generator)
    file_generator.generate_xml(@file_attributes.nmidm_attrs, 'nmidm')
    file_generator.generate_xml(@file_attributes.catsm_change_response_attrs, 'catsm_change_response')
    file_generator.generate_xml(@file_attributes.catsm_req_attrs, 'catsm_req')
    file_generator.generate_xml(@file_attributes.catsm_pen_attrs, 'catsm_pen')
    file_generator.generate_xml(@file_attributes.catsm_com_attrs, 'catsm_com')
    file_generator.generate_xml(@file_attributes.mdmtm_acn_attrs, 'mdmtm_acn')
  end

  def generate_au_gas_files
    file_generator = GenerateFile.new
    user_input = UserInput.new(@file_attributes)
    user_input.set_attrs
    generate_all_files(file_generator)
    file_generator.validate(@file_attributes.id)
  end
end

generator = GenerateGasInbound.new
generator.generate_au_gas_files