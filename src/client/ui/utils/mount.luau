local react = require "@pkg/react"
local reactrbx = require "@pkg/react-roblox"

return function(component: any, props, container)
	return reactrbx
		.createRoot(Instance.new("Folder"))
		:render(reactrbx.createPortal(react.createElement(component, props) :: any, container))
end
