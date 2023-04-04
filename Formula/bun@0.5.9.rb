class BunAT059 < Formula
  desc "Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one."
  homepage "https://bun.sh/"
  license "MIT"
  version "0.5.9"

  livecheck do
    url "https://github.com/oven-sh/bun/releases/latest"
    regex(%r{href=.*?/tag/bun-v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "9e45d3c8932f18c073d71896b9d2d2c25facee06fbe74835a184ef3e863ea343" # bun-darwin-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "defc7ad6804d4bd2b9923022b483b7549ea654ae2fa640009fa3eeafba20b010" # bun-darwin-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "b3f2efc70a78b1506aec3ddecc28bbc66259b3204b85f0539b2b6a8bbcdbf222" # bun-darwin-x64-baseline.zip
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "a495f046ea248e5c1534ba036a3be12080732dd6141d9b0bc57afdf11902e878" # bun-linux-aarch64.zip
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "bf0c64c9d6097676fc3015007f2c295dd69a86cbb0e48be75dea149a2973aee1" # bun-linux-x64.zip
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "c2cbd74a0e73e886706e0fb1a983804a37619985813036b061de9f7fd4fe54e4" # bun-linux-x64-baseline.zip
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
