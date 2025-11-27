return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { "/Users/xile/code/js-debug/src/dapDebugServer.js", "${port}" },
      },
    }

    if not dap.adapters["node"] then
      dap.adapters["node"] = function(cb, config)
        if config.type == "node" then config.type = "pwa-node" end
        local nativeAdapter = dap.adapters["pwa-node"]
        if type(nativeAdapter) == "function" then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end
  end,
}
