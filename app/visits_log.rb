# frozen_string_literal: true

class VisitsLog
  def initialize(input_file_path = nil)
    @input_file_path = input_file_path
    @visits = {}
    load_from_file unless @input_file_path.nil?
  end

  def clear
    visits.clear
  end

  def websites
    visits.keys
  end

  def website_visits(path)
    visits[path] || []
  end

  def log_visit(path:, ip:)
    visits[path] ||= []
    visits[path].push ip
  end

  def most_unique_visits
    visits
      .map { |path, ip_list| { path: path, unique_visits: ip_list.uniq.size } }
      .sort_by { |website| -website[:unique_visits] }
  end

  def most_visits
    visits
      .map { |path, ip_list| { path: path, visits: ip_list.size } }
      .sort_by { |website| -website[:visits] }
  end

  private

  attr_accessor :input_file_path, :visits

  def load_from_file
    File.open(input_file_path, 'r') do |input|
      input.each_line do |line|
        parse_line line
      end
    end
  rescue StandardError => e
    raise VisitsLogError,
          "An error occurred when reading input file.\n" \
             "Input file: #{input_file_path}\n" \
             "Error: #{e.class.name} #{e.message}\n"
  end

  def parse_line(line)
    values = line.split(/\s/)
    log_visit(
      path: values[0],
      ip: values[1]
    )
  end
end

class VisitsLogError < StandardError; end
