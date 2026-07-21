# frozen_string_literal: true

# Tachyon is CLOSED-SOURCE. This formula installs a prebuilt binary — it is
# NEVER compiled from source, so it has no source `url`, `head`, or `bottle`.
#
# This is the TEMPLATE. It lives in this repo for review, but the *live* formula
# belongs in the separate public tap repo github.com/feyncode/homebrew-tap at
# Formula/tachyon.rb. The release CI fills the version and per-arch sha256
# placeholders below and pushes the rendered file there. See README.md here.
class Tachyon < Formula
  desc "Full-fledged terminal coding agent"
  homepage "https://tachyon.feyncode.com"
  version "0.18.0"
  license :cannot_represent # proprietary FeynCode EULA — no SPDX identifier

  depends_on :macos # only darwin assets are published today

  on_macos do
    on_arm do
      url "https://tachyon.feyncode.com/releases/v#{version}/tachyon-darwin-arm64"
      sha256 "e80481854b085fcf2ca5b8b76da123bd9e809a3d6faa01bfbc2294bc2ac83709"
    end
    on_intel do
      url "https://tachyon.feyncode.com/releases/v#{version}/tachyon-darwin-x64"
      sha256 "b86aeb1e17940f9cfa02a7d578b4e1d5d8ebccf6c16b95509d9a3dc4b1ea6e6a"
    end
  end

  def install
    # A bare (non-archive) download is staged under its remote basename; rename
    # it to `tachyon`. bin.install also sets the executable bit.
    binary = Hardware::CPU.arm? ? "tachyon-darwin-arm64" : "tachyon-darwin-x64"
    bin.install binary => "tachyon"
  end

  def caveats
    <<~EOS
      Tachyon is proprietary software under the FeynCode EULA:
        https://tachyon.feyncode.com/eula

      Authenticate before first use:
        tachyon login
    EOS
  end

  test do
    # Must stay non-interactive — never launch the TUI, or `brew test` hangs.
    assert_match version.to_s, shell_output("#{bin}/tachyon --version")
  end
end
