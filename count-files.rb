require 'digest'
require 'pathname'

def count_files_with_same_content(folder_path)
  file_contents = Hash.new { |hash, key| hash[key] = [] }

  Dir.glob("#{folder_path}/**/*").each do |file_path|
    next unless File.file?(file_path)

    content_hash = Digest::MD5.file(file_path).hexdigest
    file_contents[content_hash] << File.read(file_path)
  end

  max_content_files = file_contents.values.max_by(&:size)

  [max_content_files.first, max_content_files.size]
end

if ARGV.empty?
  puts "Usage: count-files.rb <folder_path>"
  exit
end

folder_path = ARGV[0]
unless File.directory?(folder_path)
  puts "Error: Invalid folder path"
  exit
end

max_content, count = count_files_with_same_content(folder_path)
puts "Content: #{max_content}"
puts "Count: #{count}"
