class BunAT040 < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one."
  homepage "https://bun.sh/"
  license "MIT"
  version "0.4.0"

  livecheck do
    url "https://github.com/oven-sh/bun/releases/latest"
    regex(%r{href=.*?/tag/bun-v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "4febf1c18334cdcd47b0f8819dc668948aae82529386cc76443392dff8cf9f8b" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "c3aeb182655ea660b9e376a94d318b7de57714cb0b8a25297eacf3461a5a372f" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "7b439954e093592b8640d31882b90965a33e72d26d3473736998267c48be2253" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "004a38c579de3e54184d77a9c120d4686f0d7333dd4c26cf18fcf1807fbf1c7a" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "2ccbad7463621a9e1a2e67aa30b93c3dcd31223aa058f3ba192962d447d38246" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "3ea1bad61dc5678b8b8431abbead30e0a450642e7ea1bf30376dd71a3c57e822" # bun-linux-x64-baseline.zip
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
