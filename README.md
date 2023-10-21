# Caddy Management Script

This script provides a convenient way to manage the [Caddy](https://caddyserver.com/) service, including starting, stopping, restarting, reloading configurations, checking status, and more. The script also supports logging to keep track of the Caddy service's activities.

## Features

- **Start Caddy**: Starts the Caddy service and redirects output to a log file.
- **Stop Caddy**: Stops the Caddy service.
- **Restart Caddy**: Restarts the Caddy service.
- **Reload Configuration**: Reloads the Caddy configuration file.
- **Check Status**: Checks whether the Caddy service is running.
- **Logging**: Saves operations and Caddy output to a log file.
- **Reset Paths**: Resets the saved paths for Caddy binary and configuration file.
- **Real-Time Log Display**: Displays Caddy log output in real-time.
- **Help**: Displays help information.

## Usage

You can use this script in two ways:

### 1. Interactive Menu

Running the script without any arguments will enter an interactive menu, where you can select the operation to perform:

```bash
./caddy_script.sh
```

### 2. Command Line Arguments

You can directly perform a specific operation by providing an argument:

```bash
./caddy_script.sh start
./caddy_script.sh stop
./caddy_script.sh restart
./caddy_script.sh reload
./caddy_script.sh check
./caddy_script.sh resetPath
./caddy_script.sh log
./caddy_script.sh man
```

## Configuration

On the first run, the script will attempt to automatically find the paths for the Caddy binary and configuration file. If it cannot find them, it will prompt you to enter these paths manually. This information will be saved in a hidden file in the same directory as the script for future use.

## Logging

All operations and Caddy's output will be logged to a file. The log files are located in a `log` folder in the script's directory and are named by date.

## Reset Paths

If you need to change the path of Caddy or its configuration file, you can use the `resetPath` command to reset these settings:

```bash
./caddy_script.sh resetPath
```

## View Logs

You can use the `log` command to view Caddy's log output in real-time:

```bash
./caddy_script.sh log
```

## Get Help

Running the script with the `man` argument will display help information:

```bash
./caddy_script.sh man
```

## Dependencies

- Bash
- Caddy
- coreutils (provides `date` and `find` commands)
- pgrep

Ensure that these dependencies are installed and available on your system.

---

Please adjust this README file according to your specific needs and environment.
------
# Caddy 管理脚本

这个脚本提供了一个方便的方式来管理 [Caddy](https://caddyserver.com/) 服务，包括启动、停止、重启、重新加载配置、检查状态等功能。脚本还支持日志记录，以便跟踪Caddy服务的运行情况。

## 功能

- **启动 Caddy**: 启动 Caddy 服务，并将输出重定向到日志文件。
- **停止 Caddy**: 停止 Caddy 服务。
- **重启 Caddy**: 重启 Caddy 服务。
- **重新加载配置**: 重新加载 Caddy 配置文件。
- **检查状态**: 检查 Caddy 是否正在运行。
- **日志记录**: 将操作和 Caddy 的输出保存到日志文件中。
- **重置路径**: 重置保存的 Caddy 路径和配置文件路径。
- **实时显示日志**: 实时查看 Caddy 的日志输出。
- **帮助**: 显示帮助信息。

## 使用方法

你可以通过两种方式使用这个脚本：

### 1. 交互式菜单

运行脚本而不带任何参数将进入一个交互式菜单，你可以从中选择要执行的操作：

```bash
./caddy_script.sh
```

### 2. 命令行参数

你可以通过提供一个参数来直接执行特定的操作：

```bash
./caddy_script.sh start
./caddy_script.sh stop
./caddy_script.sh restart
./caddy_script.sh reload
./caddy_script.sh check
./caddy_script.sh resetPath
./caddy_script.sh log
./caddy_script.sh man
```

## 配置

在第一次运行脚本时，它会尝试自动查找 Caddy 的二进制文件和配置文件的路径。如果找不到，它会提示你手动输入这些路径。这些信息将被保存到脚本所在目录下的一个隐藏文件中，以便将来使用。

## 日志

所有操作和 Caddy 的输出都会被记录到日志文件中。日志文件位于脚本所在目录下的 `log` 文件夹中，以日期命名。

## 重置路径

如果你需要更改 Caddy 的路径或配置文件路径，可以使用 `resetPath` 命令来重置这些设置：

```bash
./caddy_script.sh resetPath
```

## 查看日志

你可以使用 `log` 命令实时查看 Caddy 的日志输出：

```bash
./caddy_script.sh log
```

## 获取帮助

运行脚本带有 `man` 参数可以显示帮助信息：

```bash
./caddy_script.sh man
```

## 依赖

- Bash
- Caddy
- coreutils (提供 `date` 和 `find` 命令)
- pgrep

请确保这些依赖已经安装并且可用。
