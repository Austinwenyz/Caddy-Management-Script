#!/bin/bash

# 自动获取Caddy的二进制文件路径和配置文件路径
CADDY_BIN=$(which caddy)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CADDY_CONFIG="$SCRIPT_DIR/Caddyfile"

if [[ -z $CADDY_BIN ]]; then
    echo "无法找到Caddy。请确保已安装Caddy并且它在您的PATH中。 Cannot find Caddy. Please ensure Caddy is installed and it's in your PATH."
    exit 1
fi

if [[ ! -f $CADDY_CONFIG ]]; then
    read -p "未找到Caddyfile， 请输入Caddyfile的路径: Caddyfile not found, please enter the path to the Caddyfile: " CADDY_CONFIG
fi

LOG_DIR="$SCRIPT_DIR/log"
mkdir -p $LOG_DIR  # 创建log文件夹，如果不存在的话
TODAY=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$TODAY.log"

function caddy_action {
    case $1 in
        start)
            echo "启动Caddy... Starting Caddy..."
            nohup $CADDY_BIN run --config $CADDY_CONFIG >> $LOG_FILE 2>&1 &
            ;;
        stop)
            echo "停止Caddy... Stopping Caddy..."
            $CADDY_BIN stop
            ;;
        reload)
            echo "重新加载Caddy配置... Reloading Caddy configuration..."
            $CADDY_BIN reload --config $CADDY_CONFIG
            echo "配置已重新加载. Configuration reloaded."
            ;;
        restart)
            caddy_action stop
            caddy_action start
            ;;
        *)
            echo "未知的操作: $1. Unknown operation: $1."
            exit 1
            ;;
    esac
    sleep 2
    check_caddy_process
}

function check_caddy_process {
    pgrep -x caddy > /dev/null && echo "Caddy正在运行. Caddy is running." || echo "Caddy未运行. Caddy is not running."
}

function upgrade_caddy {
    echo "升级Caddy... Upgrading Caddy..."
    if [[ $(uname) == "Darwin" ]]; then  # Check if the system is macOS
        brew upgrade caddy
    elif [[ $(uname) == "Linux" ]]; then
        sudo apt-get install --only-upgrade caddy -y || sudo yum update caddy -y
    fi
    echo "Caddy已升级. Caddy upgraded."
}

function enable_autostart {
    echo "添加Caddy到开机启动... Adding Caddy to autostart..."
    if [[ $(systemctl --version) ]]; then  # Check if the system uses systemd
        systemctl enable caddy
    elif [[ -d /etc/init.d ]]; then  # Check if the system uses init.d
        sudo update-rc.d caddy defaults
    fi
    echo "Caddy已添加到开机启动. Caddy has been added to autostart."
}

function disable_autostart {
    echo "从开机启动中移除Caddy... Removing Caddy from autostart..."
    if [[ $(systemctl --version) ]]; then
        systemctl disable caddy
    elif [[ -d /etc/init.d ]]; then
        sudo update-rc.d -f caddy remove
    fi
    echo "Caddy已从开机启动中移除. Caddy has been removed from autostart."
}

function display_log {
    tail -f $LOG_FILE
}

function display_manual {
    echo "
    start               启动Caddy服务 Start the Caddy service
    stop                停止Caddy服务 Stop the Caddy service
    reload              重新加载Caddy配置 Reload the Caddy configuration
    restart             重启Caddy服务 Restart the Caddy service
    check               检查Caddy进程 Check Caddy process
    upgrade             升级Caddy Upgrade Caddy
    enable-autostart    添加Caddy到开机启动 Enable Caddy autostart
    disable-autostart   从开机启动中移除Caddy Disable Caddy autostart
    log                 实时显示Caddy日志 Display Caddy log in real-time
    man                 显示此功能手册 Display this manual
    "
}

function display_menu {
    echo "1 - 启动Caddy Start Caddy"
    echo "2 - 停止Caddy Stop Caddy"
    echo "3 - 重新加载Caddy配置 Reload Caddy configuration"
    echo "4 - 重启Caddy Restart Caddy"
    echo "5 - 检查Caddy进程 Check Caddy process"
    echo "6 - 升级Caddy Upgrade Caddy"
    echo "7 - 添加Caddy到开机启动 Enable Caddy autostart"
    echo "8 - 从开机启动中移除Caddy Disable Caddy autostart"
    echo "9 - 实时显示Caddy日志 Display Caddy log in real-time"
    echo "0 - 退出 Exit"
    read -p "请选择一个操作: Please select an operation: " choice
    case $choice in
        1)
            caddy_action start
            ;;
        2)
            caddy_action stop
            ;;
        3)
            caddy_action reload
            ;;
        4)
            caddy_action restart
            ;;
        5)
            check_caddy_process
            ;;
        6)
            upgrade_caddy
            ;;
        7)
            enable_autostart
            ;;
        8)
            disable_autostart
            ;;
        9)
            display_log
            ;;
        0)
            exit 0
            ;;
        *)
            echo "无效的选择. Invalid choice."
            display_menu
            ;;
    esac
}

if [[ -z $1 ]]; then
    display_menu
elif [[ $1 == "man" ]]; then
    display_manual
elif [[ $1 == "log" ]]; then
    display_log
else
    caddy_action $1 || { shift; "$@"; }
fi
