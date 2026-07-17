 local M = {}

function M.setup()
  vim.g.colors_name = 'matugen'

  require('base16-colorscheme').setup({
    base00 = '{{colors.surface.default.hex}}',
    base01 = '{{colors.surface_container.default.hex}}',
    base02 = '{{colors.surface_container_high.default.hex}}',
    base03 = '{{colors.outline.default.hex}}',
    base04 = '{{colors.on_surface_variant.default.hex}}',
    base05 = '{{colors.on_surface.default.hex}}',
    base06 = '{{colors.on_surface.default.hex}}',
    base07 = '{{colors.on_background.default.hex}}',
    base08 = '{{colors.error.default.hex}}',
    base09 = '{{colors.tertiary.default.hex}}',
    base0A = '{{colors.secondary.default.hex}}',
    base0B = '{{colors.primary.default.hex}}',
    base0C = '{{colors.tertiary_fixed_dim.default.hex}}',
    base0D = '{{colors.primary_fixed_dim.default.hex}}',
    base0E = '{{colors.secondary_fixed_dim.default.hex}}',
    base0F = '{{colors.error_container.default.hex}}',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  local c = {
    bg = '{{colors.surface.default.hex}}',
    bg_alt = '{{colors.surface_container.default.hex}}',
    bg_high = '{{colors.surface_container_high.default.hex}}',
    fg = '{{colors.on_surface.default.hex}}',
    muted = '{{colors.on_surface_variant.default.hex}}',
    comment = '{{colors.outline.default.hex}}',
    primary = '{{colors.primary.default.hex}}',
    primary_dim = '{{colors.primary_fixed_dim.default.hex}}',
    secondary = '{{colors.secondary.default.hex}}',
    secondary_dim = '{{colors.secondary_fixed_dim.default.hex}}',
    tertiary = '{{colors.tertiary.default.hex}}',
    tertiary_dim = '{{colors.tertiary_fixed_dim.default.hex}}',
    error = '{{colors.error.default.hex}}',
    error_container = '{{colors.error_container.default.hex}}',
  }

  local function is_light(hex)
    local r, g, b = hex:match('^#(%x%x)(%x%x)(%x%x)$')
    if not r then
      return vim.o.background == 'light'
    end
    local luminance = (0.299 * tonumber(r, 16)) + (0.587 * tonumber(g, 16)) + (0.114 * tonumber(b, 16))
    return luminance > 150
  end

  vim.o.background = is_light(c.bg) and 'light' or 'dark'
  local is_dark = not is_light(c.bg)
  local dark_syntax = {
    variable = '#89b4fa',
    variable_builtin = '#f38ba8',
    parameter = '#f9e2af',
    property = '#94e2d5',
    function_name = '#a6e3a1',
    function_call = '#74c7ec',
    function_builtin = '#fab387',
    type_name = '#cba6f7',
    type_builtin = '#b4befe',
    module = '#fab387',
    keyword = '#f38ba8',
    operator = '#f5c2e7',
    string = '#a6e3a1',
    string_special = '#94e2d5',
    number = '#fab387',
    constant = '#b4befe',
    comment = '#6c7086',
    tag = '#89dceb',
  }
  local light_syntax = {
    variable = '#1e66f5',
    variable_builtin = '#d20f39',
    parameter = '#df8e1d',
    property = '#179299',
    function_name = '#40a02b',
    function_call = '#04a5e5',
    function_builtin = '#fe640b',
    type_name = '#8839ef',
    type_builtin = '#7287fd',
    module = '#fe640b',
    keyword = '#d20f39',
    operator = '#ea76cb',
    string = '#40a02b',
    string_special = '#179299',
    number = '#fe640b',
    constant = '#7287fd',
    comment = '#6c6f85',
    tag = '#209fb5',
  }
  local syntax = is_dark and dark_syntax or light_syntax

  hi('Comment',        { fg = syntax.comment, italic = true })
  hi('SpecialComment', { fg = syntax.string_special, italic = true })
  hi('Todo',           { fg = c.bg, bg = syntax.keyword, bold = true })

  hi('Identifier',   { fg = syntax.variable })
  hi('Function',     { fg = syntax.function_name, bold = true })
  hi('Type',         { fg = syntax.type_name, bold = true })
  hi('Structure',    { fg = syntax.type_name, bold = true })
  hi('StorageClass', { fg = syntax.type_name, bold = true, italic = true })
  hi('Keyword',      { fg = syntax.keyword, bold = true })
  hi('Statement',    { fg = syntax.keyword, bold = true })
  hi('Conditional',  { fg = syntax.keyword, bold = true })
  hi('Repeat',       { fg = syntax.keyword, bold = true })
  hi('Operator',     { fg = syntax.operator, bold = true })
  hi('String',       { fg = syntax.string })
  hi('Character',    { fg = syntax.string_special })
  hi('Number',       { fg = syntax.number })
  hi('Boolean',      { fg = syntax.keyword, bold = true })
  hi('Float',        { fg = syntax.number })
  hi('Constant',     { fg = syntax.constant })
  hi('PreProc',      { fg = syntax.module, bold = true })
  hi('Include',      { fg = syntax.module, bold = true })
  hi('Define',       { fg = syntax.module, bold = true })
  hi('Macro',        { fg = syntax.module, bold = true })
  hi('Special',      { fg = syntax.string_special })
  hi('Delimiter',    { fg = c.muted })
  hi('Error',        { fg = c.error, bold = true })

  hi('@variable',                { fg = syntax.variable })
  hi('@variable.python',         { fg = syntax.variable })
  hi('@variable.builtin',        { fg = syntax.variable_builtin, italic = true })
  hi('@variable.builtin.python', { fg = syntax.variable_builtin, italic = true })
  hi('@variable.parameter',      { fg = syntax.parameter, italic = true })
  hi('@variable.parameter.python', { fg = syntax.parameter, italic = true })
  hi('@variable.member',         { fg = syntax.property })
  hi('@variable.field',          { fg = syntax.property })
  hi('@property',                { fg = syntax.property })
  hi('@field',                   { fg = syntax.property })

  hi('@function',                { fg = syntax.function_name, bold = true })
  hi('@function.python',         { fg = syntax.function_name, bold = true })
  hi('@function.call',           { fg = syntax.function_call })
  hi('@function.call.python',    { fg = syntax.function_call })
  hi('@function.builtin',        { fg = syntax.function_builtin, bold = true, italic = true })
  hi('@function.builtin.python', { fg = syntax.function_builtin, bold = true, italic = true })
  hi('@function.method',         { fg = syntax.function_name, bold = true })
  hi('@function.method.call',    { fg = syntax.function_call })
  hi('@constructor',             { fg = syntax.type_name, bold = true })

  hi('@type',                    { fg = syntax.type_name, bold = true })
  hi('@type.builtin',            { fg = syntax.type_builtin, bold = true, italic = true })
  hi('@type.definition',         { fg = syntax.type_name, bold = true })
  hi('@class',                   { fg = syntax.type_name, bold = true })
  hi('@interface',               { fg = syntax.type_name, bold = true, italic = true })
  hi('@namespace',               { fg = syntax.module })
  hi('@module',                  { fg = syntax.module })
  hi('@module.builtin',          { fg = syntax.module, italic = true })
  hi('@module.import',           { fg = syntax.module, bold = true })

  hi('@keyword',                 { fg = syntax.keyword, bold = true })
  hi('@keyword.function',        { fg = syntax.keyword, bold = true })
  hi('@keyword.return',          { fg = syntax.keyword, bold = true, italic = true })
  hi('@keyword.operator',        { fg = syntax.operator, bold = true })
  hi('@conditional',             { fg = syntax.keyword, bold = true })
  hi('@repeat',                  { fg = syntax.keyword, bold = true })
  hi('@operator',                { fg = syntax.operator, bold = true })
  hi('@punctuation.delimiter',   { fg = c.muted })
  hi('@punctuation.bracket',     { fg = c.muted })
  hi('@punctuation.special',     { fg = syntax.operator })

  hi('@string',                  { fg = syntax.string })
  hi('@string.escape',           { fg = syntax.string_special, bold = true })
  hi('@string.special',          { fg = syntax.string_special, italic = true })
  hi('@character',               { fg = syntax.string_special })
  hi('@number',                  { fg = syntax.number })
  hi('@boolean',                 { fg = syntax.keyword, bold = true })
  hi('@constant',                { fg = syntax.constant })
  hi('@constant.builtin',        { fg = syntax.constant, bold = true, italic = true })
  hi('@constant.macro',          { fg = syntax.constant, bold = true })

  hi('@comment',                 { fg = syntax.comment, italic = true })
  hi('@comment.todo',            { fg = c.bg, bg = syntax.keyword, bold = true })
  hi('@comment.note',            { fg = c.bg, bg = syntax.type_name, bold = true })
  hi('@comment.warning',         { fg = c.bg, bg = syntax.module, bold = true })
  hi('@comment.error',           { fg = c.bg, bg = c.error, bold = true })

  hi('@tag',                     { fg = syntax.tag, bold = true })
  hi('@tag.attribute',           { fg = syntax.property, italic = true })
  hi('@tag.delimiter',           { fg = c.muted })

  hi('DiagnosticError',          { fg = c.error })
  hi('DiagnosticWarn',           { fg = syntax.module })
  hi('DiagnosticInfo',           { fg = syntax.type_name })
  hi('DiagnosticHint',           { fg = syntax.function_name })
  hi('DiagnosticUnderlineError', { undercurl = true, sp = c.error })
  hi('DiagnosticUnderlineWarn',  { undercurl = true, sp = syntax.module })
  hi('DiagnosticUnderlineInfo',  { undercurl = true, sp = syntax.type_name })
  hi('DiagnosticUnderlineHint',  { undercurl = true, sp = syntax.function_name })

  hi('CursorLine',               { bg = c.bg_alt })
  hi('CursorLineNr',             { fg = syntax.function_name, bold = true })
  hi('LineNr',                   { fg = c.muted })
  hi('Visual',                   { bg = c.bg_high })
  hi('Search',                   { fg = c.bg, bg = syntax.function_name, bold = true })
  hi('IncSearch',                { fg = c.bg, bg = syntax.keyword, bold = true })
  hi('MatchParen',               { fg = syntax.keyword, bg = c.bg_high, bold = true })

  hi('IlluminatedWordRead',      { fg = c.fg, bg = c.bg_high })
  hi('IlluminatedWordWrite',     { fg = c.fg, bg = c.bg_high })
  hi('IlluminatedWordText',      { fg = c.fg, bg = c.bg_high })

  hi('TelescopeNormal',         { fg = c.fg,                bg = c.bg })
  hi('TelescopeBorder',         { fg = syntax.comment,     bg = c.bg })
  hi('TelescopePromptNormal',   { fg = c.fg,                bg = c.bg })
  hi('TelescopePromptBorder',   { fg = syntax.comment,     bg = c.bg })
  hi('TelescopePromptPrefix',   { fg = syntax.function_name, bg = c.bg })
  hi('TelescopePromptCounter',  { fg = c.muted,             bg = c.bg })
  hi('TelescopePromptTitle',    { fg = c.bg,                bg = syntax.function_name })
  hi('TelescopePreviewTitle',   { fg = c.bg,                bg = syntax.module })
  hi('TelescopeResultsTitle',   { fg = c.bg,                bg = syntax.type_name })
  hi('TelescopeSelection',      { fg = c.fg,                bg = c.bg_high })
  hi('TelescopeSelectionCaret', { fg = syntax.keyword,      bg = c.bg_high })
  hi('TelescopeMatching',       { fg = syntax.keyword,      bold = true })
  hi('MatugenLualineNormalA',   { fg = c.bg,    bg = c.primary,   bold = true })
  hi('MatugenLualineNormalB',   { fg = c.fg,    bg = c.bg_high })
  hi('MatugenLualineNormalC',   { fg = c.fg,    bg = c.bg_alt })
  hi('MatugenLualineInsertA',   { fg = c.bg,    bg = syntax.function_name, bold = true })
  hi('MatugenLualineInsertB',   { fg = c.fg,    bg = c.bg_high })
  hi('MatugenLualineInsertC',   { fg = c.fg,    bg = c.bg_alt })
  hi('MatugenLualineVisualA',   { fg = c.bg,    bg = syntax.type_name, bold = true })
  hi('MatugenLualineVisualB',   { fg = c.fg,    bg = c.bg_high })
  hi('MatugenLualineVisualC',   { fg = c.fg,    bg = c.bg_alt })
  hi('MatugenLualineReplaceA',  { fg = c.bg,    bg = c.error,    bold = true })
  hi('MatugenLualineReplaceB',  { fg = c.fg,    bg = c.bg_high })
  hi('MatugenLualineReplaceC',  { fg = c.fg,    bg = c.bg_alt })
  hi('MatugenLualineCommandA',  { fg = c.bg,    bg = syntax.keyword, bold = true })
  hi('MatugenLualineCommandB',  { fg = c.fg,    bg = c.bg_high })
  hi('MatugenLualineCommandC',  { fg = c.fg,    bg = c.bg_alt })
  hi('MatugenLualineInactiveA', { fg = c.muted, bg = c.bg_alt })
  hi('MatugenLualineInactiveB', { fg = c.muted, bg = c.bg_alt })
  hi('MatugenLualineInactiveC', { fg = c.muted, bg = c.bg_alt })

  hi('MatugenBufferlineFill',              { fg = c.muted, bg = c.bg })
  hi('MatugenBufferlineBackground',        { fg = c.muted, bg = c.bg_alt })
  hi('MatugenBufferlineBufferSelected',    { fg = c.fg,    bg = c.bg_high, bold = true })
  hi('MatugenBufferlineIndicatorSelected', { fg = c.primary, bg = c.bg_high })
  hi('MatugenBufferlineSeparator',         { fg = c.bg,    bg = c.bg_alt })
  hi('MatugenBufferlineSeparatorSelected', { fg = c.primary, bg = c.bg_high })
  hi('MatugenBufferlineCloseButton',       { fg = c.muted, bg = c.bg_alt })
  hi('MatugenBufferlineCloseButtonSelected', { fg = c.error, bg = c.bg_high })
  hi('MatugenBufferlineModified',          { fg = syntax.function_name, bg = c.bg_alt })
  hi('MatugenBufferlineModifiedSelected',  { fg = syntax.function_name, bg = c.bg_high })
  hi('MatugenBufferlineDiagnostic',        { fg = c.error, bg = c.bg_alt })
  hi('MatugenBufferlineDiagnosticSelected', { fg = c.error, bg = c.bg_high })

  pcall(function()
    require('lualine').refresh({ place = { 'statusline' } })
  end)
end

local function reload_matugen()
  package.loaded['matugen'] = nil
  require('matugen').setup()
  vim.cmd('redraw!')
end

if _G.__matugen_signal then
  pcall(function()
    _G.__matugen_signal:stop()
    _G.__matugen_signal:close()
  end)
end

_G.__matugen_signal = vim.uv.new_signal()
_G.__matugen_signal:start(
  'sigusr1',
  vim.schedule_wrap(reload_matugen)
)

return M
