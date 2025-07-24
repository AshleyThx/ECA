export type DefaultLogConfig = {
	roblox_console_log: boolean,
	extended_timestamp: boolean,
	max_log_length: number,
}
type LogLevel = {
	RobloxLevel: Enum.AnalyticsLogLevel,
}

local DEFAULT_CONFIG: DefaultLogConfig = {
	roblox_console_log = true,
	executor_console_log = true,
	file_log = true,
	log_path = "global.log",
	extended_timestamp = false,
	max_log_length = 0,
}
local LOG_LEVELS = {
	TRACE = {
		RobloxLevel = Enum.AnalyticsLogLevel.Trace,
	} :: LogLevel,
	DEBUG = {
		RobloxLevel = Enum.AnalyticsLogLevel.Debug,
	} :: LogLevel,
	INFO = {
		RobloxLevel = Enum.AnalyticsLogLevel.Information,
	} :: LogLevel,
	ERROR = {
		RobloxLevel = Enum.AnalyticsLogLevel.Error,
	} :: LogLevel,
	FATAL = {
		RobloxLevel = Enum.AnalyticsLogLevel.Fatal,
	} :: LogLevel,
	WARNING = {
		RobloxLevel = Enum.AnalyticsLogLevel.Warning,
	} :: LogLevel,
}

local logger = {
	_config = table.clone(DEFAULT_CONFIG),
}

local function formatLog(level: string, text: string, timestamp: number)
	local cur_time = DateTime.fromUnixTimestampMillis(timestamp)

	local timestamp_text = if logger._config.extended_timestamp
		then cur_time:FormatUniversalTime("MM.DD.YY HH:mm:ss-SSS", "en-us")
		else cur_time:FormatUniversalTime("HH:mm:ss", "en-us")

	local log_str = ("%s [%s]: %s"):format(timestamp_text, level, text)
	local log_len = log_str:len()

	if logger._config.max_log_length > 0 and log_len > logger._config.max_log_length then
		local trunc_postfix = "... [TRUNCATED]"
		local trunc_len = trunc_postfix:len()

		log_str = log_str:sub(1, math.clamp(logger._config.max_log_length - trunc_len, 0, 1e6)) .. trunc_postfix
	end

	return log_str
end

local function logRobloxConsole(log_level: LogLevel, log: string)
	local log_analytics_level = log_level.RobloxLevel
	if log_analytics_level then
		if
			log_level.RobloxLevel == Enum.AnalyticsLogLevel.Information
			or log_level.RobloxLevel == Enum.AnalyticsLogLevel.Trace
		then
			print(log)
		else
			warn(log)
		end
	end
	--TODO: figure out how to output different levels like Luarmor
end

local function logText(
	level: keyof<typeof(LOG_LEVELS)>,
	text: string,
	timestamp: number?,
	no_file_log: boolean?
): string
	timestamp = timestamp or DateTime.now().UnixTimestampMillis

	assert(typeof(level) == "string", "Invalid argument #1, string expected")
	assert(typeof(text) == "string", "Invalid argument #2, string expected")
	assert(typeof(timestamp) == "number" or timestamp == nil, "Invalid argument #3, number or nil expected")
	assert(typeof(no_file_log) == "boolean" or no_file_log == nil, "Invalid argument #4, boolean or nil expected")

	local level_enum: LogLevel = LOG_LEVELS[level]
	assert(level_enum, `No log level {level} found`)

	local log_text = formatLog(level, text, timestamp)
	if logger._config.roblox_console_log then pcall(logRobloxConsole, level_enum, log_text) end

	return log_text
end

local function logtrace(text: string, timestamp: number?, no_file_log: boolean?): string
	return logText("TRACE", text, timestamp, no_file_log)
end
local function logdebug(text: string, timestamp: number?, no_file_log: boolean?): string
	return logText("DEBUG", text, timestamp, no_file_log)
end
local function loginfo(text: string, timestamp: number?, no_file_log: boolean?): string
	return logText("INFO", text, timestamp, no_file_log)
end
local function logfatal(text: string, timestamp: number?, no_file_log: boolean?): string
	return logText("FATAL", text, timestamp, no_file_log)
end
local function logwarn(text: string, timestamp: number?, no_file_log: boolean?): string
	return logText("WARNING", text, timestamp, no_file_log)
end
local function logerror(text: string, timestamp: number?, no_file_log: boolean?): string
	return logText("ERROR", text, timestamp, no_file_log)
end

local function setupLog(config: DefaultLogConfig)
	assert(typeof(config) == "table", "invalid 'config' argument, table expected")

	logger._config.roblox_console_log = config.roblox_console_log or logger._config.roblox_console_log
	logger._config.extended_timestamp = config.extended_timestamp or logger._config.extended_timestamp
	logger._config.max_log_length = config.max_log_length or logger._config.max_log_length

	return logger
end

logger.Trace = logtrace
logger.Debug = logdebug
logger.Info = loginfo
logger.Fatal = logfatal
logger.Warn = logwarn
logger.Error = logerror

logger.setup = setupLog

return logger
