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
end