#
# A little wrapper to handle hiscore records
#
class Records < Array
  FILENAME = File.join(ENV['HOME'] || ENV['USERPROFILE'], ".pentix")

  def self.new
    @@instance ||= super # no need to bother HDD all the time
  end

  def self.top(size)
    new.sort{ |a, b| b[1] <=> a[1] }.uniq.slice(0, size)
  end

  def self.add(name, score)
    list = self.new
    list << [name.strip, score]
    list.save
  end

  def self.last_name
    self.new.last_name
  end

  def initialize(*args)
    super *args

    File.read(FILENAME).split("\n").each do |line|
      if match = line.match(/^\s*(.*?)\s+(\d+)\s*$/)
        self << [@last_name = match[1].strip, match[2].to_i]
      end
    end if File.exists?(FILENAME)
  end

  def save
    File.open(FILENAME, "w") do |file|
      each do |entry|
        if entry[1] > 0
          file.write "#{entry[0].ljust(40, ' ')} #{entry[1]}\n"
        end
      end
    end
  end

  def last_name
    @last_name || ''
  end
end