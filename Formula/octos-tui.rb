class OctosTui < Formula
  desc "Terminal UI client for the Octos UI Protocol"
  homepage "https://github.com/octos-org/octos-tui"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/octos-org/octos-tui/releases/download/v0.1.3/octos-tui-aarch64-apple-darwin.tar.xz"
    sha256 "d88bd44331cbd200dc3f14813e940d36b0ebfe97034a8ee9da1a101c462638e4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/octos-org/octos-tui/releases/download/v0.1.3/octos-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a906bb7e551400cc1be54b58b96ec51d4c6b467992700bd1d32e0320754eef9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/octos-org/octos-tui/releases/download/v0.1.3/octos-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "844ea34f618e79e793e12d64769befb5decfca01b744a9f6dc3e36233aac3075"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "octos-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "octos-tui" if OS.linux? && Hardware::CPU.arm?
    bin.install "octos-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
