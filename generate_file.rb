require 'zip'

class GenerateFile
  def zip(filename)
    xml_path = File.expand_path('xml', __dir__)
    zip_path = File.expand_path('zip', __dir__)

    file = File.open(xml_path + "/#{filename}.xml")

    Zip::File.open("#{zip_path}/#{filename}.zip", Zip::File::CREATE) do |z|
      z.add("#{filename}.xml", file)
    end
  end

  def validate(id)
    `find . -maxdepth 4 -type f -iname "*#{id}.xml" | xargs -I '{}' xmllint --noout --schema ~/Documents/schemas/r29/schema/aseXML_r29.xsd '{}'`
  end

  def generate_xml(attrs, filename)
    message_id = attrs.fetch(:message_id)
    template_path = File.expand_path('templates', __dir__)
    template      = File.read(template_path + "/#{filename}_template.xml.erb")

    File.open("xml/#{message_id}.xml", 'w+') do |f|
      f.write(ERB.new(template).result_with_hash(attrs))
    end

    zip(message_id)
  end
end