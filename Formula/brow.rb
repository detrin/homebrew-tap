class Brow < Formula
  include Language::Python::Virtualenv

  desc "Standalone Playwright CLI for agent browser automation"
  homepage "https://github.com/detrin/brow"
  url "https://files.pythonhosted.org/packages/20/61/bc7bb9e07be6753e474ad1d5ebed4d37e29ea2f4efa13c21f713fbc5e31c/brow_cli-1.2.0.tar.gz"
  sha256 "66e3b0864ffe134bb82f81f100aac8262f2add689c7efb98d7d84bf6d15a966b"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv with pip (unlike virtualenv_install_with_resources)
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", libexec
    # Install brow-cli with all dependencies from wheels
    system libexec/"bin/pip", "install", "--quiet", "brow-cli==1.2.0"
    # Create symlinks in bin
    bin.install_symlink libexec/"bin/brow"
    bin.install_symlink libexec/"bin/playwright"
  end

  def caveats
    <<~EOS
      Before using brow, install Chromium with:
        playwright install chromium

      Or let it install automatically on first run.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/brow --help")
  end
end
