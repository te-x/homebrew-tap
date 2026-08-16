cask "less-sheet" do
  # sha256 is the digest of the PUBLISHED .zip, taken from dist/SHA256SUMS and
  # confirmed against the asset list on the release page. Do not hand-edit it:
  # a wrong digest does not fail for you, it fails for everyone who installs
  # after you, with an error that looks like a corrupted download.
  version "0.1.0"
  sha256 "e578994442a1a081de14663de49ee88fdfdc60759555ffef4606396f76ab2f6f"

  url "https://github.com/te-x/less-sheet-site/releases/download/v#{version}/less-sheet-#{version}-macos-arm64.zip"
  name "less-sheet"
  desc "Read-only viewer for spreadsheet-sized CSV, plain, gzipped or over HTTP"
  homepage "https://te-x.github.io/less-sheet-site/"

  # Apple silicon only, and the app genuinely refuses to start below its floor
  # rather than starting and misbehaving, so these are real constraints.
  depends_on arch: :arm64
  # macOS 26. A bare symbol, NOT ">= :tahoe": the string-comparison form is
  # deprecated and warns on every `brew tap`. It still means "or newer" —
  # Homebrew parses this argument with comparator ">=" by default
  # (Library/Homebrew/cask/dsl/depends_on.rb), so the floor is unchanged.
  depends_on macos: :tahoe

  app "less-sheet.app"

  # NO postflight that strips com.apple.quarantine.
  #
  # It would work, and it would make `brew install --cask less-sheet` a clean
  # one-liner with no flag. It is deliberately not here: silently disabling a
  # Gatekeeper check on someone's machine, because they installed your app, is
  # not a decision this file gets to make for them.
  #
  # There is no flag for it any more either: Homebrew 6 REMOVED
  # `--no-quarantine`. Casks are always quarantined, and the user approves once
  # in System Settings -> Privacy & Security -> "Open Anyway". Homebrew carries
  # that approval into later upgrades (Quarantine.inherit_user_approval!) but
  # only while the app's DESIGNATED REQUIREMENT is unchanged — and an ad-hoc
  # signature's requirement is derived from the cdhash, so it changes on every
  # build and every upgrade asks again.
  #
  # Notarizing is what fixes that: a Developer ID requirement is identity-based
  # and stable, so the approval is inherited. Nothing else here changes.

  zap trash: [
    "~/Library/Preferences/com.lesssheet.LessSheet.plist",
    "~/Library/Saved Application State/com.lesssheet.LessSheet.savedState",
  ]
end
