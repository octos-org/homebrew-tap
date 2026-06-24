class OctosTui < Formula
  desc "Terminal UI client for the Octos UI Protocol"
  homepage "https://github.com/octos-org/octos-tui"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/octos-org/octos-tui/releases/download/v0.1.4/octos-tui-aarch64-apple-darwin.tar.xz"
    sha256 "c10ae8504d1025db82590f44353350d152fef86330ded8f88cfa62b3d060176c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/octos-org/octos-tui/releases/download/v0.1.4/octos-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "259feab68ad7aa7f5256c57f36870716a0c7a4a8229ee7fdce32ab1eb2d28531"
    end
    if Hardware::CPU.intel?
      url "https://github.com/octos-org/octos-tui/releases/download/v0.1.4/octos-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed41893c26b5638f0a12f5499b27bb049ff74fb80686e176ca02f8990c525390"
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
