local react = require("@pkg/react")

local e = react.createElement

return function(props: {})
	return e("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		test = e("TextLabel", {
			Text = "test",
			Size = UDim2.fromOffset(100, 100),
		}),
	})
end
