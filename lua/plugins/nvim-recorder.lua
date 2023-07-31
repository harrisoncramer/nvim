return {
  "chrisgrieser/nvim-recorder",
  dependencies = "rcarriga/nvim-notify", -- optional
  opts = {
    slots = { "a", "b", "c" },
    mapping = {
      startStopRecording = "q",
      playMacro = "Q",
      editMacro = "<leader>qe",
      switchSlot = "<leader>qt",
    },
    clear = false,
    logLevel = vim.log.levels.INFO,
    dapSharedKeymaps = false,
  }
}
