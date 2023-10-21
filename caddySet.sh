#!/bin/bash

# Define constants
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SAVE_FILE="$SCRIPT_DIR/.caddySetSave"
LOG_DIR="$SCRIPT_DIR/log"
mkdir -p $LOG_DIR
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"

# --------------------- Utility Functions ---------------------
function log {
    echo "-------- $(date) -------- $1 --------" >> $LOG_FILE
}

function find_caddy {
    which caddy 2>/dev/null || find "$SCRIPT_DIR" -type f -name "caddy" 2>/dev/null
}

function find_caddy_config {
    find "$SCRIPT_DIR" -type f -name "Caddyfile" 2>/dev/null
}

function save_to_file {
    echo "CADDY_BIN=$1" > $SAVE_FILE
    echo "CADDY_CONFIG=$2" >> $SAVE_FILE
    echo "LOG_FILE=$LOG_FILE" >> $SAVE_FILE
}

function load_from_file {
    if [[ -f $SAVE_FILE ]]; then
        source $SAVE_FILE
    fi
}

# --------------------- Core Functions ---------------------
function caddy_action {
    case $1 in
        start)
            set_paths
            log "CADDY STARTED"
            nohup $CADDY_BIN run --config $CADDY_CONFIG >> $LOG_FILE 2>&1 &
            sleep 2
            caddy_action check
            ;;
        stop)
            set_paths
            log "CADDY STOPPED"
            $CADDY_BIN stop
            sleep 2
            caddy_action check
            ;;
        reload)
            set_paths
            log "CADDY RELOADED"
            $CADDY_BIN reload --config $CADDY_CONFIG
            echo "配置已重新加载. Configuration reloaded."
            sleep 2
            caddy_action check
            ;;
        restart)
            set_paths
            caddy_action stop
            caddy_action start
            ;;
        check)
            pgrep -x caddy &>/dev/null && echo "Caddy正在运行. Caddy is running." || echo "Caddy未运行. Caddy is not running."
            ;;
    esac
}

function reset_paths {
    rm -f "$SAVE_FILE"
    unset CADDY_BIN CADDY_CONFIG
    set_paths
    echo "Caddy路径和配置路径都已重置. Caddy path and configuration path have been reset."
}

function display_log {
    if [[ -f $SAVE_FILE ]]; then
        source $SAVE_FILE
        tail -f $LOG_FILE
    else
        echo "未找到日志文件路径。请使用有效命令运行脚本以生成日志文件路径。"
        echo "Log file path not found. Please run the script with a valid command to generate the log file path."
    fi
}

function display_manual {
    echo "
Usage: $(basename $0) [COMMAND]

Available commands:
    start      启动Caddy | Start Caddy
    stop       停止Caddy | Stop Caddy
    reload     重新加载Caddy配置 | Reload Caddy configuration
    restart    重启Caddy | Restart Caddy
    check      检查Caddy进程 | Check Caddy process
    resetPath  重置Caddy和配置路径 | Reset Caddy and configuration paths
    log        实时显示Caddy日志 | Display Caddy log in real-time
    man        显示此功能手册 | Display this manual
    "
}

function display_menu {
    echo "当前使用的Caddy路径/Current Caddy path: $CADDY_BIN"
    echo "当前使用的Caddy配置文件路径/Current Caddy config file path: $CADDY_CONFIG"
    echo "----------------------------------------------"
    echo "1 - 启动Caddy Start Caddy"
    echo "2 - 停止Caddy Stop Caddy"
    echo "3 - 重新加载Caddy配置 Reload Caddy configuration"
    echo "4 - 重启Caddy Restart Caddy"
    echo "5 - 检查Caddy进程 Check Caddy process"
    echo "6 - 重置Caddy和配置路径 Reset Caddy and configuration paths"
    echo "7 - 实时显示Caddy日志 Display Caddy log in real-time"
    echo "0 - 退出 Exit"
    
    read -p "请选择一个操作: Please select an operation: " choice

    case $choice in
        1) caddy_action start ;;
        2) caddy_action stop ;;
        3) caddy_action reload ;;
        4) caddy_action restart ;;
        5) caddy_action check ;;
        6) reset_paths ;;
        7) display_log ;;
        0) exit 0 ;;
        *) echo "无效的选择/Invalid choice." ;;
    esac
}

function command_line_action {
    case $1 in
        start)      caddy_action start ;;
        stop)       caddy_action stop ;;
        reload)     caddy_action reload ;;
        restart)    caddy_action restart ;;
        check)      caddy_action check ;;
        resetPath)  reset_paths ;;
        log)        display_log ;;
        man)        display_manual ;;
        *)          echo "无效的参数/Invalid argument: $1"; exit 1 ;;
    esac
}

function set_paths {
    load_from_file

    if [[ -z $CADDY_BIN || ! -x $CADDY_BIN ]]; then
        local caddy_binaries=($(find_caddy))
        case ${#caddy_binaries[@]} in
            0)
                read -p "未找到Caddy，请提供Caddy的完整路径/Couldn't find Caddy, please provide the full path to Caddy: " CADDY_BIN
                ;;
            1)
                CADDY_BIN=${caddy_binaries[0]}
                ;;
            *)
                echo "找到多个Caddy，请选择一个/Found multiple Caddy binaries, please choose one:"
                select choice in "${caddy_binaries[@]}"; do
                    CADDY_BIN=$choice
                    break
                done
                ;;
        esac
    fi

    if [[ -z $CADDY_CONFIG || ! -f $CADDY_CONFIG ]]; then
        local configs=($(find_caddy_config))
        case ${#configs[@]} in
            0)
                read -p "未找到Caddy配置，请提供Caddy配置的完整路径/Couldn't find Caddy configuration, please provide the full path to the configuration: " CADDY_CONFIG
                ;;
            1)
                CADDY_CONFIG=${configs[0]}
                ;;
            *)
                echo "找到多个Caddy配置文件，请选择一个/Found multiple Caddy configuration files, please choose one:"
                select choice in "${configs[@]}"; do
                    CADDY_CONFIG=$choice
                    break
                done
                ;;
        esac
    fi

    save_to_file $CADDY_BIN $CADDY_CONFIG
}

# Execution starts here
set_paths
[[ -z $1 ]] && display_menu || command_line_action $1
