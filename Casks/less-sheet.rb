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
  # not a decision this file gets to make for them. `--no-quarantine` is the
  # supported way to say yes, and it makes the choice theirs and visible:
  #
  #     brew install --cask less-sheet --no-quarantine
  #
  # Without that flag the app installs fine but macOS refuses the first launch
  # (System Settings -> Privacy & Security -> "Open Anyway"), because this build
  # is ad-hoc signed and not notarized through Apple's paid programme.
  #
  # If less-sheet is ever notarized, delete this comment and the flag disappears
  # from the docs — nothing else here changes.

  zap trash: [
    "~/Library/Preferences/com.lesssheet.LessSheet.plist",
    "~/Library/Saved Application State/com.lesssheet.LessSheet.savedState",
  ]
end
