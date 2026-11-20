-- ~/.config/nvim/ftplugin/java.lua

local jdtls = require 'jdtls'

-- The JVM that runs the language server must be >= 21 (that is what the
-- jdtls bundles require). It is independent of the JDK the project builds
-- with, so resolve it from jenv (following `jenv global`) rather than from
-- the project's `.java-version`.
local function jenv_java(version)
  if vim.fn.executable 'jenv' ~= 1 then return nil end
  local prefix = vim.fn.system { 'jenv', 'prefix', version }
  local ok = vim.v.shell_error == 0
  prefix = vim.trim(prefix)
  local exe = prefix .. '/bin/java'
  if ok and vim.fn.executable(exe) == 1 then return exe end
  return nil
end

local function resolve_ls_java()
  local exe = jenv_java '25' or jenv_java '21'
  if exe then return exe end
  if vim.env.JAVA_HOME and vim.env.JAVA_HOME ~= '' then
    exe = vim.env.JAVA_HOME .. '/bin/java'
    if vim.fn.executable(exe) == 1 then return exe end
  end
  for _, candidate in ipairs {
    '/opt/homebrew/opt/openjdk@25/bin/java',
    '/opt/homebrew/opt/openjdk@21/bin/java',
  } do
    if vim.fn.executable(candidate) == 1 then return candidate end
  end
end

local jdtls_runtime_java = resolve_ls_java()
if not jdtls_runtime_java then
  vim.notify('jdtls: no Java 21+ runtime found (checked jenv, JAVA_HOME, Homebrew)', vim.log.levels.ERROR)
  return
end

-- Root directory detection: walks up from the current file
-- looking for common Java project markers.
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if not root_dir then
  vim.notify('jdtls: no Java project root found for ' .. vim.fn.expand '%:p', vim.log.levels.WARN)
  return
end

-- Unique workspace per project, so different projects don't
-- clobber each other's jdtls state/cache.
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls-workspace/' .. project_name

-- Mason install paths
local mason_registry = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_path = mason_registry .. '/jdtls'

-- Find the launcher jar and OS/arch-specific config dir
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher_jar == '' then
  vim.notify('jdtls: launcher jar not found in ' .. jdtls_path, vim.log.levels.ERROR)
  return
end

local arch = vim.trim(vim.fn.system 'uname -m')
local is_arm = arch == 'arm64' or arch == 'aarch64'

local os_config
if vim.fn.has 'win32' == 1 then
  os_config = 'config_win'
elseif vim.fn.has 'mac' == 1 then
  os_config = is_arm and 'config_mac_arm' or 'config_mac'
elseif vim.fn.has 'unix' == 1 then
  os_config = is_arm and 'config_linux_arm' or 'config_linux'
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then capabilities = cmp_lsp.default_capabilities(capabilities) end

-- Bundles for debug/test support, if installed
local bundles = {}

local debug_path = mason_registry .. '/java-debug-adapter'
if vim.fn.isdirectory(debug_path) == 1 then
  vim.list_extend(bundles, vim.split(vim.fn.glob(debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n'))
end

local test_path = mason_registry .. '/java-test'
if vim.fn.isdirectory(test_path) == 1 then vim.list_extend(bundles, vim.split(vim.fn.glob(test_path .. '/extension/server/*.jar'), '\n')) end
bundles = vim.tbl_filter(function(s) return s ~= '' end, bundles)

-- WPILib projects ship their own JDK (e.g. 17 or 25). Keep that as the
-- *project/build* JDK; it must not be used to launch the language server.
local function project_jdk()
  local pref = root_dir .. '/.wpilib/wpilib_preferences.json'
  if vim.fn.filereadable(pref) ~= 1 then return nil end
  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(pref), '\n'))
  if not ok or type(data) ~= 'table' then return nil end
  local year = data.projectYear
  if type(year) ~= 'string' or year == '' or year == 'none' then return nil end
  local home = vim.fn.expand('~/wpilib/' .. year .. '/jdk')
  if vim.fn.isdirectory(home) == 1 then return home end
  return nil
end

local jdk_home = project_jdk()

local java_settings = {
  signatureHelp = { enabled = true },
  completion = {
    favoriteStaticMembers = {
      'org.junit.Assert.*',
      'org.junit.jupiter.api.Assertions.*',
      'java.util.Objects.requireNonNull',
    },
  },
}
if jdk_home then
  java_settings.import = { gradle = { java = { home = jdk_home } } }
end

local config = {
  cmd = {
    jdtls_runtime_java,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    launcher_jar,
    '-configuration',
    jdtls_path .. '/' .. os_config,
    '-data',
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = java_settings,
  },
  init_options = {
    bundles = bundles,
  },
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)

    -- nvim-jdtls specific extras
    if pcall(require, 'dap') then
      jdtls.setup_dap { hotcodereplace = 'auto' }
      require('jdtls.dap').setup_dap_main_class_configs()
    end

    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, opts)
    vim.keymap.set('n', '<leader>jt', jdtls.test_class, opts)
    vim.keymap.set('n', '<leader>jn', jdtls.test_nearest_method, opts)
  end,
}

jdtls.start_or_attach(config)
