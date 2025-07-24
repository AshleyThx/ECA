declare _G: typeof(_G) & {
	__DEBUG__: "true" | "false",
	__DEV__: boolean
}