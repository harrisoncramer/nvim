return {
  "chrisgrieser/nvim-recorder",
  dependencies = "rcarriga/nvim-notify",
  opts = {
    slots = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' },
    mapping = {
      startStopRecording = "r",
      playMacro = "R",
    },
    lessNotifications = false,
    clear = false,
    logLevel = vim.log.levels.INFO,
    dapSharedKeymaps = false,
  }
}
