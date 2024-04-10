local plugin = require("comment_repl")

describe("setup", function()
  it("works with no opts", function()
    plugin.setup()
  end)

  it("works with empty opts", function()
    plugin.setup({})
  end)

  it("works with opts", function()
    plugin.setup({
      log = {
        level = "trace",
      },
    })
  end)
end)
