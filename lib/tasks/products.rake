require 'date'

task "Download Products from Amazon (requires mechanize)"
task :download do
  web = Mechanize.new
  @products = []

  [ "http://www.amazon.com/s/ref=nb_sb_ss_c_1_16?url=search-alias%3Dstripbooks&field-keywords=ruby+programming&x=0&y=0&sprefix=ruby+programming",
    "http://www.amazon.com/s/ref=nb_sb_ss_c_1_16?url=search-alias%3Dstripbooks&field-keywords=ruby+programming&x=0&y=0&sprefix=ruby+programming#/ref=sr_pg_2?rh=n%3A283155%2Ck%3Aruby+programming&page=2&keywords=ruby+programming&ie=UTF8&qid=1297954339",
    "http://www.amazon.com/s/ref=nb_sb_ss_c_1_16?url=search-alias%3Dstripbooks&field-keywords=ruby+programming&x=0&y=0&sprefix=ruby+programming#/ref=sr_pg_3?rh=n%3A283155%2Ck%3Aruby+programming&page=3&keywords=ruby+programming&ie=UTF8&qid=1297956477"
  ].each do |uri|
    web.get(uri) do |page|
      page.search(".result").each do |result|
        begin
          title, metadata = result.search(".productTitle").first.text.split(' by ')
          title = title.strip
          author = metadata.split('(').first
          price = result.search(".newPrice span").first.text.gsub('$','')

          # Download Image
          image_uri = result.search(".productImage img").first.attr("src")
          image_filename = title.downcase.gsub(/[\W ]/, '-').gsub(/-+/, '-') + ".jpg"
          web.get(image_uri).save_as("#{Rails.root}/public/images/products/#{image_filename}")
          @products << {
            :title => title,
            :author => author,
            :price => price,
            :image_file_name => image_filename,
            :available_on => Date.today - 1
          }
        rescue
        end
      end
    end
  end

  File.open("#{Rails.root}/db/seeds/products.yml", 'w+'){|f| f.write(@products.to_yaml) }

end
