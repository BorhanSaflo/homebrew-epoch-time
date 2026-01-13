class EpochTime < Formula
  desc "Print or manipulate Unix epoch timestamps"
  homepage "https://github.com/BorhanSaflo/epoch-time#readme"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BorhanSaflo/epoch-time/releases/download/v0.1.0/epoch-time-aarch64-apple-darwin.tar.xz"
      sha256 "44c8f5e80d59d1457203b62810762ebb5da2c38d319b407288ebbd72dcb39a11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/epoch-time/releases/download/v0.1.0/epoch-time-x86_64-apple-darwin.tar.xz"
      sha256 "ae0d22f5a01725b9895916defbac845740ee6bdd88fb11a8ca54ade022abe786"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/epoch-time/releases/download/v0.1.0/epoch-time-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e37f199d39c49462cf451f6668bdb71c1cd2884b416d4f4aae7ea05a0dff1fb"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "et" if OS.mac? && Hardware::CPU.arm?
    bin.install "et" if OS.mac? && Hardware::CPU.intel?
    bin.install "et" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
