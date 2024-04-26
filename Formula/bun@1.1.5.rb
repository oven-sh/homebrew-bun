class BunAT115 < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one."
  homepage "https://bun.sh/"
  license "MIT"
  version "1.1.5"

  livecheck do
    url "https://github.com/oven-sh/bun/releases/latest"
    regex(%r{href=.*?/tag/bun-v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "727e298da6147975a8fc2a9366c65344b7c44c8e908b3a7c268b01c3dc90a1c5" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "8a8cfb32cceaa4449e5b9464f747f42232727ed2df94f94ed7fa4e53569e5156" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "26d92b3aa4401718c7e6816bfe3f8dfcbc4d362ec6457c0f94699cb715a47620" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "2a8a3177454e3b3e62e0ed9ef8129b1b8d42887dafa8e316808560b14f033e6b" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "e22bfa85a77b29a1292349e0d599d9142a9e54cf91dce11fd0a3c0b6c73a2bad" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "193568c64ef07214e226a091264b292c9197c0a0fddbe6584fb50158c84e3644" # bun-linux-x64-baseline.zip
    end
  else
    odie "Unsupported platform. Please submit a bug report here: https://bun.sh/issues\n#{OS.report}"
  end

  # TODO: to become an official formula we need to build from source
  def install
    bin.install "bun"
    ENV["BUN_INSTALL"] = "#{bin}"
    generate_completions_from_executable(bin/"bun", "completions")
  end

  def test
    assert_match "#{version}", shell_output("#{bin}/bun -v")
  end
end
