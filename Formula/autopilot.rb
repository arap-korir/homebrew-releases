# typed: false
# frozen_string_literal: true

class Autopilot < Formula
  desc "Self-hosted local automation for coding agents"
  homepage "https://github.com/vkorir/autopilot"
  version "0.5.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/vkorir/autopilot/releases/download/v0.5.0/autopilot_v0.5.0_darwin_amd64.tar.gz"
      sha256 "bb9f22b617fe8729e58f30f5d124d6c055955f66d6ecbd3cbb51df390cfc37e0"

      define_method(:install) do
        bin.install "autopilot"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/vkorir/autopilot/releases/download/v0.5.0/autopilot_v0.5.0_darwin_arm64.tar.gz"
      sha256 "940183e33b769fbe0784e05c00cd6ff94c8f09d07a6e7e51cb662c29b64ca1a4"

      define_method(:install) do
        bin.install "autopilot"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/vkorir/autopilot/releases/download/v0.5.0/autopilot_v0.5.0_linux_amd64.tar.gz"
      sha256 "5d748045876b76679471949879423ea78e81b7945de17921ce8584373a5b0b0f"
      define_method(:install) do
        bin.install "autopilot"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/vkorir/autopilot/releases/download/v0.5.0/autopilot_v0.5.0_linux_arm64.tar.gz"
      sha256 "3400062500dc7ae9105cb3413e4ee4f978c3094c1a4e143899bf283b35e58525"
      define_method(:install) do
        bin.install "autopilot"
      end
    end
  end

  test do
    assert_match "autopilot v0.5.0", shell_output("#{bin}/autopilot version")
  end
end
