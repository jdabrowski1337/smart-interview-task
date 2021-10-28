# frozen_string_literal: true

class App
  def main(args)
    if args.size < 1 || args[0] == 'help'
      puts File.read("README")
      return
    end

    @websites = VisitsLog.new(args[0])

    puts '========================='
    puts 'Websites with most visits'
    @websites.most_visits.each do |website|
      puts format('%-30.30s', "Path: #{website[:path]}") +
        " Visits: #{website[:visits]}"
    end

    puts "\n\n"

    puts '========================='
    puts 'Websites with most unique visits'
    @websites.most_unique_visits.each do |website|
      puts format('%-30.30s', "Path: #{website[:path]}") +
        " Unique visits: #{website[:unique_visits]}"
    end
  rescue WebsitesLogError => e
    puts e.message
  end
end
