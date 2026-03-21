class Brow < Formula
  include Language::Python::Virtualenv

  desc "Standalone Playwright CLI for agent browser automation"
  homepage "https://github.com/detrin/brow"
  url "https://files.pythonhosted.org/packages/source/b/brow-cli/brow_cli-0.1.4.tar.gz"
  sha256 "0970ba8574117134d8cccf22911e869e46ac93f20bce74619a359259e60b3c8a"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
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
