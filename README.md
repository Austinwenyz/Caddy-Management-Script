# Caddy 管理脚本 Caddy Management Script

这个脚本提供了一个简单的方法来管理您的Caddy服务器。您可以通过命令行参数或交互式数字菜单来控制Caddy的运行。

This script offers a simplified way to manage your Caddy server. You can control the operation of Caddy via command line arguments or an interactive numeric menu.

## 功能 Features

- 启动 Caddy (Start Caddy)
- 停止 Caddy (Stop Caddy)
- 重新加载 Caddy 配置 (Reload Caddy Configuration)
- 重启 Caddy (Restart Caddy)
- 检查 Caddy 进程 (Check Caddy Process)
- 升级 Caddy (Upgrade Caddy)
- 添加/移除 Caddy 到/从开机启动 (Add/Remove Caddy to/from Autostart)
- 实时显示 Caddy 日志 (Display Caddy Log in Real-time)

## 使用 Usage

1. 将脚本保存为 `caddy_manager.sh`。
2. 给脚本执行权限：
    ```bash
    chmod +x caddy_manager.sh
    ```
3. 运行脚本并按照提示操作：
    ```bash
    ./caddy_manager.sh
    ```

1. Save the script as `caddy_manager.sh`.
2. Give execute permission to the script:
    ```bash
    chmod +x caddy_manager.sh
    ```
3. Run the script and follow the prompts:
    ```bash
    ./caddy_manager.sh
    ```

## 命令行参数 Command Line Arguments

- `start`: 启动 Caddy
- `stop`: 停止 Caddy
- `reload`: 重新加载 Caddy 配置
- `restart`: 重启 Caddy
- `check`: 检查 Caddy 进程
- `upgrade`: 升级 Caddy
- `enable-autostart`: 添加 Caddy 到开机启动
- `disable-autostart`: 从开机启动中移除 Caddy
- `log`: 实时显示 Caddy 日志
- `man`: 显示功能手册

- `start`: Start Caddy
- `stop`: Stop Caddy
- `reload`: Reload Caddy Configuration
- `restart`: Restart Caddy
- `check`: Check Caddy Process
- `upgrade`: Upgrade Caddy
- `enable-autostart`: Add Caddy to Autostart
- `disable-autostart`: Remove Caddy from Autostart
- `log`: Display Caddy Log in Real-time
- `man`: Display the manual

## 交互式菜单 Interactive Menu

当运行脚本时没有提供任何命令行参数，将显示交互式数字菜单，指南您完成各种操作。

When running the script without any command line arguments, an interactive numeric menu will be displayed guiding you through various operations.
