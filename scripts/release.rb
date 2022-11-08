require "net/http"
require "json"
require "digest"

version = ARGV[0]
if version == nil
  abort "Usage: release.rb [x.y.z]"
else
  version = version.gsub(/[a-z-]*/i, "")
end

puts "Releasing Bun on Homebrew: v#{version}"

url = "https://api.github.com/repos/oven-sh/bun/releases/tags/bun-v#{version}"
response = Net::HTTP.get_response(URI(url))
unless response.is_a?(Net::HTTPSuccess)
  abort "Did not find release: bun-v#{version} [status: #{response.code}]"
end

release = JSON.parse(response.body)
puts "Found release: #{release["name"]}"

assets = {}
for asset in release["assets"]
  filename = asset["name"]
  if !filename.end_with?(".zip") || filename.include?("-profile")
    puts "Skipped asset: #{filename}"
    next
  end

  url = asset["browser_download_url"]
  begin
    response = Net::HTTP.get_response(URI(url))
    url = response["location"]
  end while response.is_a?(Net::HTTPRedirection)

  unless response.is_a?(Net::HTTPSuccess)
    abort "Did not find asset: #{filename} [status: #{response.code}]"
  end

  sha256 = Digest::SHA256.hexdigest(response.body)
  puts "Found asset: #{filename} [sha256: #{sha256}]"

  assets[filename] = sha256
end

formula = ""
File.open("Formula/bun.rb", "r") do |file|
  file.each_line do |line|
    query = line.strip

    new_line = if query.start_with?("version")
      line.gsub(/"[0-9\.]{1,}"/, "\"#{version}\"")
    elsif query.start_with?("sha256")
      asset = query[(query.index("#") + 2)..-1].strip
      sha256 = assets[asset]
      if sha256 == nil
        abort "Did not find sha256: #{asset}"
      end
      line.gsub(/"[A-Fa-f0-9]{1,}"/, "\"#{sha256}\"")
    else
      line
    end

    formula += new_line
  end
end

versioned_class = "class BunAT#{version.gsub(/\./, "")}"
versioned_formula = formula.gsub(/class Bun/, versioned_class)
File.write("Formula/bun@#{version}.rb", versioned_formula)
puts "Saved Formula/bun@#{version}.rb"

File.write("Formula/bun.rb", formula)
puts "Saved Formula/bun.rb"

readme = File.read("README.md")
new_readme = readme.gsub(/bun@[0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}/, "bun@#{version}")
File.write("README.md", new_readme)
puts "Saved README.md"

puts "Done"
