#
# A little wrapper to handle hiscore records
#
class Records < Array
  FILENAME = ENV['HOME'] + "/.pentix" # TODO win32

  def self.new
    @@instance ||= super # no need to bother HDD all the time
  end

  def initialize(*args)
    super *args

    File.read(FILENAME).split("\n").each do |line|
      if match = line.match(/^\s*(.*?)\s+(\d+)\s*$/)
        self << [match[1], match[2].to_i]
      end
    end if File.exists?(FILENAME)
  end

  def save
    File.open(FILENAME, "w") do |file|
      each do |entry|
        file.write "#{entry[0].ljust(40, ' ')} #{entry[1]}"
      end
    end
  end

  def add(name, value)
    self << [name, value]
    save
  end

  def top(size)
    sort{ |a, b| b[1] <=> a[1] }.uniq.slice(0, size)
  end
end