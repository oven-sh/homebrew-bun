class BunAT1217 < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one."
  homepage "https://bun.sh/"
  license "MIT"
  version "1.2.17"

  livecheck do
    url "https://github.com/oven-sh/bun/releases/latest"
    regex(%r{href=.*?/tag/bun-v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "9f55fd213f2f768d02eb5b9885aaa44b1e1307a680c18622b57095302a931af9" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "038023b8dbdccc93383398a0c1be2ca82716649479cfae708b533ca7a9c5d083" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "a54b6a1778a522d8f8cf57c18095aca7642b009cf81613e48805fd82954fb0c1" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "a0b996f48c977beb4e87b09a471ded7e63ee5c2fb4b72790c7ab4badbc147d6b" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "6054207074653b4dbc2320d5a61e664e4b6f42379efc18d6181bffcc07a43193" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "6ea1861db6a6cd44d1c8b4bafb22006f4ae49f6a2d077623bf3f456ada026d67" # bun-linux-x64-baseline.zip
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
