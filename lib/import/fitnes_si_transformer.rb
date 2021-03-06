require 'import/transformer'

module Import
  class FitnesSiTransformer < Transformer
    def description
      "Import results from FitneSi".freeze
    end

    def transform(data)
      doc = Nokogiri::XML(data)

      klubs = doc.xpath('//marker')

      clean_data = []

      klubs.each do |klub|
        name = klub.attribute('name').try(:text)
        address = klub.attribute('address').try(:text)
        post_number = klub.attribute('post_number').try(:text)
        city = klub.attribute('city').try(:text)

        clean_data << {
          name: name,
          address: "#{address}, #{post_number}, #{city}",
          caterogies: ['fitnes']
        }
      end

      clean_data
    end
  end
end
