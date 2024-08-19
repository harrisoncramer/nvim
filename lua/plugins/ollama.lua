return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
  config = function()
    local ollama = require("ollama")
    vim.keymap.set("n", "<leader>oo", ollama.prompt)
    vim.keymap.set("v", "<leader>oo", ollama.prompt)
    vim.keymap.set("n", "<leader>og", function()
      ollama.prompt("Generate_Code")
    end)
    ollama.setup({
      model = "codellama"
    })
  end,
}
