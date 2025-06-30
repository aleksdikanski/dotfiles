local util = require('lspconfig.util')
local kotlin_ls_bin_name = 'kotlin-language-server'
if vim.fn.has 'win32' == 1 then
  kotlin_ls_bin_name = kotlin_ls_bin_name .. '.bat'
end
--- The presence of one of these files indicates a project root directory
--
--  These are configuration files for the various build systems supported by
--  Kotlin. I am not sure whether the language server supports Ant projects,
--  but I'm keeping it here as well since Ant does support Kotlin.
local root_files = {
  'settings.gradle', -- Gradle (multi-project)
  'settings.gradle.kts', -- Gradle (multi-project)
  'build.xml', -- Ant
  'pom.xml', -- Maven
}

local fallback_root_files = {
  'build.gradle', -- Gradle
  'build.gradle.kts', -- Gradle
}

return {
  filetypes = { 'kotlin' },
  root_dir = function(fname)
    return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
  end,
  cmd = { kotlin_ls_bin_name },
}
