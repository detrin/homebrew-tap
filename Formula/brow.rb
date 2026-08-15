class Brow < Formula
  include Language::Python::Virtualenv

  desc "Standalone Playwright CLI for agent browser automation"
  homepage "https://github.com/detrin/brow"
  url "https://files.pythonhosted.org/packages/28/bd/331feeb82bb5c30b18b9afffa2b32f3ebc303a4b39f7d66a95bee1e92314/brow_cli-1.3.0.tar.gz"
  sha256 "dff9a948e81f53969d0d72ed4ae6a2f68c6ade6974265203a0110444fbf10169"
  license "Elastic-2.0"

  depends_on "python@3.12"

  def install
    # Create venv with pip (unlike virtualenv_install_with_resources)
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", libexec
    # Install brow-cli with all dependencies from wheels
    system libexec/"bin/pip", "install", "--quiet", "brow-cli==1.3.0"
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
