class OctosTui < Formula
  desc "Terminal UI client for the Octos UI Protocol"
  homepage "https://github.com/octos-org/octos-tui"
  version "0.1.2-rc.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/octos-org/octos-tui/releases/download/v0.1.2-rc.2/octos-tui-aarch64-apple-darwin.tar.xz"
    sha256 "56064410770164826a373113d2de3fa8e2aad42d688eef96b5fea8fca7c07429"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/octos-org/octos-tui/releases/download/v0.1.2-rc.2/octos-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4786233fe6e639d5f874947862ec3ef7df293d9d5b6bb9e91b9aaa166199b2ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/octos-org/octos-tui/releases/download/v0.1.2-rc.2/octos-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ba5821655bd9c9e212b762db19e23c85b56040bb3cb7642ef0332cab622faf3"
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
