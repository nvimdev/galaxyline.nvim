local uv = vim.loop
local async_load_providers

async_load_providers = uv.new_async(vim.schedule_wrap(function ()
  local vcs = require('galaxyline.provider_vcs')
  local fileinfo = require('galaxyline.provider_fileinfo')
  local buffer = require('galaxyline.provider_buffer')
  local extension = require('galaxyline.provider_extensions')
  local whitespace =require('galaxyline.provider_whitespace')
  local lspclient = require('galaxyline.provider_lsp')
  _G.galaxyline_providers = {
  BufferIcon  = buffer.get_buffer_type_icon,
  BufferNumber = buffer.get_buffer_number,
  FileTypeName = buffer.get_buffer_filetype,
  GitBranch = vcs.get_git_branch,
  DiffAdd = vcs.diff_add,
  DiffModified = vcs.diff_modified,
  DiffRemove = vcs.diff_remove,
  LineColumn = fileinfo.line_column,
  FileFormat = fileinfo.get_file_format,
  FileEncode = fileinfo.get_file_encode,
  FileSize = fileinfo.get_file_size,
  FileIcon = fileinfo.get_file_icon,
  FileName = fileinfo.get_current_file_name,
  FilePath = fileinfo.get_current_file_path,
  SFileName = fileinfo.filename_in_special_buffer,
  LinePercent = fileinfo.current_line_percent,
  ScrollBar = extension.scrollbar_instance,
  VistaPlugin = extension.vista_nearest,
  WhiteSpace = whitespace.get_item,
  GetLspClient = lspclient.get_lsp_client,
  }
  local diagnostic = require('galaxyline.provider_diagnostic')
  _G.galaxyline_providers.DiagnosticError = diagnostic.get_diagnostic_error
  _G.galaxyline_providers.DiagnosticWarn = diagnostic.get_diagnostic_warn
  _G.galaxyline_providers.DiagnosticHint = diagnostic.get_diagnostic_hint
  _G.galaxyline_providers.DiagnosticInfo = diagnostic.get_diagnostic_info
  async_load_providers:close()
end))

return {
  async_load_providers = async_load_providers
}
