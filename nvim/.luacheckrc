-- vim: ft=lua

-- Only files which have changed since last check will be re-checked
cache = true

ignore = {
  "631", -- max_line_length
  "212/_.*", -- unused argument, for vars with "_" prefix
}

-- Global objects defined by the C code
globals = {
  "vim",
}
