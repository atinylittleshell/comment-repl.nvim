local plugin = require("comment_repl")

describe("setup", function()
  it("works with default", function()
    assert(plugin.execute() == "Hello, World!", "Expected 'Hello, World!'")
  end)
end)
