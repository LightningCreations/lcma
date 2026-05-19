# Package

version       = "0.1.0"
author        = "Racclyn w/ Lightning Creations + contributors"
description   = "The server side code implementation for LCMA"
license       = "BSD-3-Clause"
srcDir        = "src"
bin           = @["server"]


# Dependencies

requires "nim >= 2.2.10"
requires "mummy >= 0.4.8"
requires "norm >= 2.8.0"

switch("path", "$nimbleDir/pkgs2")
