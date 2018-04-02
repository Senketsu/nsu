# Package
version = "0.1.3"
author = "Senketsu"
description = "A small screenshot library / utility for Windows & X11 based systems."
license = "MIT"
srcDir = "src"
bin = @["nsu"]

# Dependencies
requires "nim >= 0.17.2", "x11 >= 1.0.0", "oldwinapi >= 2.0.0", "png >= 0.2.0"
