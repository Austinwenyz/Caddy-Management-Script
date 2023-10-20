#!/bin/bash

# 自动获取Caddy的二进制文件路径
CADDY_BIN=$(which caddy)
if [[ -z $CADDY_BIN ]]; then
    echo "无法找到Caddy。请确保已安装Caddy并且它在您的PATH中。"
    exit 1
fi

# 检查同目录下是否存在Caddyfile
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CADDY_CONFIG="$SCRIPT_DIR/Caddyfile"

if [[ ! -f $CADDY_CONFIG ]]; then
    read -p "未找到Caddyfile， 请输入Caddyfile的路径: " CADDY_CONFIG
fi

function start_caddy {
    echo "启动Caddy..."
    nohup $CADDY_BIN run --config $CADDY_CONFIG &
    echo "Caddy已启动."
}

function stop_caddy {
    echo "停止Caddy..."
    $CADDY_BIN stop
    echo "Caddy已停止."
}

function reload_caddy {
    echo "重新加载Caddy配置..."
    $CADDY_BIN reload --config $CADDY_CONFIG
    echo "配置已重新加载."
}

function restart_caddy {
    stop_caddy
    start_caddy
}

function status_caddy {
    $CADDY_BIN status
}

function log_caddy {
    journalctl -u caddy --no-pager
}

function backup_config {
    BACKUP_FILE="$SCRIPT_DIR/Caddyfile.backup"
    cp $CADDY_CONFIG $BACKUP_FILE
    echo "配置已备份到 $BACKUP_FILE."
}

function restore_config {
    BACKUP_FILE="$SCRIPT_DIR/Caddyfile.backup"
    if [[ -f $BACKUP_FILE ]]; then
        cp $BACKUP_FILE $CADDY_CONFIG
        echo "配置已从 $BACKUP_FILE 恢复."
        reload_caddy
    else
        echo "未找到备份文件."
    fi
}

function display_help {
    echo "用法: $0 {start|stop|reload|restart|status|log|backup|restore|man}"
    echo "管理Caddy服务的简单脚本。"
    echo "命令:"
    echo "  start    启动Caddy服务"
    echo "  stop     停止Caddy服务"
    echo "  reload   重新加载Caddy配置"
    echo "  restart  重启Caddy服务"
    echo "  status   显示Caddy的状态"
    echo "  log      显示Caddy的日志"
    echo "  backup   备份Caddy配置"
    echo "  restore  从备份恢复Caddy配置"
    echo "  man      显示此帮助信息"
}

# 检查命令行参数并执行相应的函数
case $1 in
    start)
        start_caddy
        ;;
    stop)
        stop_caddy
        ;;
    reload)
        reload_caddy
        ;;
    restart)
        restart_caddy
        ;;
    status)
        status_caddy
        ;;
    log)
        log_caddy
        ;;
    backup)
        backup_config
        ;;
    restore)
        restore_config
        ;;
    man | "")
        display_help
        ;;
    *)
        echo "未知的命令: $1"
        display_help
        exit 1
        ;;
esac
