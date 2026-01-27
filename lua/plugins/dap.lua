-- Debug Adapter Protocol (DAP) configuration

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Точка останова" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Продолжить/Запустить" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Шаг с пропуском" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Шаг внутрь" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Шаг наружу" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Завершить отладку" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Переключить DAP UI" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Условная точка останова",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Точка логирования",
      },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Переключить REPL" },
      { "<leader>dR", function() require("dap").run_last() end, desc = "Повторить последний запуск" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        controls = {
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
      })

      -- Setup DAP virtual text
      require("nvim-dap-virtual-text").setup({
        commented = true,
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        virt_text_pos = "eol",
      })

      -- Setup Python debugging
      dap_python.setup("python3")

      -- Custom signs for breakpoints
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })

      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DiagnosticSignInfo",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DiagnosticSignInfo",
        linehl = "",
        numhl = "",
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
