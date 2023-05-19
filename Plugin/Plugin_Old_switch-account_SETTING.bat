@echo off
title 账号切换插件设置
rem 初始化

rem 定义配置文件路径和需要检查的键值对
rem 获取脚本文件的目录
set "config_file=%CD%\config\gui.json"
set "start_with_key=Start.StartsWithScript"
set "start_with_value=Plugin_switch-account_start.bat"
set "end_with_key=Start.EndsWithScript"
set "end_with_value=Plugin_switch-account_end.bat"

rem 初始化状态变量
set "istatu=1"

rem 检查配置文件是否存在
echo 1
if not exist "%config_file%" (
    echo 插件状态【未安装】
    set isstatu=1
    set iestatu=1
) else (
    rem 读取配置文件内容并搜索键值对
    set start_with_found=""
    set end_with_found=""
    for /f "usebackq tokens=1,* delims=: " %%a in ("%config_file%") do (
        if "%%a"=="%start_with_key%" (
            set start_with_found=%%b
        )
        if "%%a"=="%end_with_key%" (
            set end_with_found=%%b
        )
    )

    rem 检查Start.StartsWithScript是否匹配
    if defined start_with_found (
        if "%start_with_value%"=="%start_with_found%" (
            echo 插件开始模块状态【已安装】
            set isstatu=0
        ) else (
            echo 插件开始模块状态【冲突】
            set isstatu=2
        )
    )

    rem 检查Start.EndsWithScript是否匹配
    if defined end_with_found (
        if "%end_with_value%"=="%end_with_found%" (
            echo 插件结束模块状态【已安装】
            set iestatu=0
        ) else (
            echo 插件结束模块状态【冲突】
            set iestatu=2
        )
    )
    echo Tip:
    echo 若出现冲突请检查是否有其他插件使用了MAA调用，若无特殊情况请手动复制到\Plugin_switch-account_resource\compatible-plugin-loader\并重命名为start.bat和end.bat
    echo 若为本插件的旧版本，请选择覆盖安装
)

:menu
echo 请选择一个选项：
echo [1] 安装插件
echo [2] 卸载插件
echo [3] 插件设置
echo [4] 退出

set /p option=请输入选项号码：

if "%option%"=="1" (
    call :installPlugin
    goto menu
) else if "%option%"=="2" (
    call :uninstallPlugin
    goto menu
) else if "%option%"=="3" (
    call :pluginSettingsMenu
    goto menu
) else if "%option%"=="4" (
    exit /b
) else (
    echo 无效的选项，请重新输入。
    pause
    goto menu
)

:installPlugin

rem 检查配置文件是否存在
if not exist "%config_file%" (
    rem 配置文件不存在，创建并写入键值对
    echo [ERROR]MAA配置文件不存在，请检查MAA是否为兼容版本
) else (
    rem 配置文件存在，读取内容并检查键值对
    set "content="
    for /f "usebackq delims=" %%a in ("%config_file%") do (
        set "content=%%a"
    )
    
    rem 检查是否存在指定的键值对
    echo %content% | findstr /C:"\"%start_with_key%\": \"%start_with_value%\"" >nul
    if %errorlevel% equ 0 (
        rem 键值对已存在，无需修改
        echo 插件已安装，无需更改
    ) else (
        rem 键值对不存在或值不同，修改配置文件
        echo %content% | findstr /C:"\"%start_with_key%\"" >nul
        if %errorlevel% equ 0 (
            rem 键存在但值不同，替换键值对
            set "content=!content:%start_with_key%=*!"
            set "content=!content:%end_with_key%=*!"
            echo {"%start_with_key%": "%start_with_value%", "%end_with_key%": "%end_with_value%"}>>"%config_file%.tmp"
            echo %content%>>"%config_file%.tmp"
            move /y "%config_file%.tmp" "%config_file%" >nul
            echo 插件设置已更新
        ) else (
            rem 键不存在，添加键值对
            echo {"%start_with_key%": "%start_with_value%", "%end_with_key%": "%end_with_value%"}>"%config_file%.tmp"
            echo %content%>>"%config_file%.tmp"
            move /y "%config_file%.tmp" "%config_file%" >nul
            echo 插件已安装
        )
    )
)

exit /b


:uninstallPlugin
rem 定义配置文件路径和需要删除的键值对

rem 检查配置文件是否存在
if not exist "%config_file%" (
    rem 配置文件不存在，插件未安装
    echo [ERROR]插件尚未安装
) else (
    rem 配置文件存在，读取内容并删除键值对
    set "content="
    for /f "usebackq delims=" %%a in ("%config_file%") do (
        set "content=%%a"
    )

    rem 检查是否存在指定的键值对
    echo %content% | findstr /C:"\"%start_with_key%\"" >nul
    if %errorlevel% equ 0 (
        rem 键存在，删除键值对
        set "content=!content:%start_with_key%=*!"
        set "content=!content:%end_with_key%=*!"
        echo %content%>"%config_file%.tmp"
        move /y "%config_file%.tmp" "%config_file%" >nul
        echo 插件已卸载
    ) else (
        rem 键不存在，插件未安装
        echo [ERROR]插件尚未安装
    )
)

exit /b


:pluginSettingsMenu
cls
echo 插件设置：
echo [1] 设置选项1
echo [2] 设置选项2
echo [3] 返回主菜单

set /p settingOption=请输入设置选项号码：

if "%settingOption%"=="1" (
    call :pluginSetting1
    goto pluginSettingsMenu
) else if "%settingOption%"=="2" (
    call :pluginSetting2
    goto pluginSettingsMenu
) else if "%settingOption%"=="3" (
    goto menu
) else (
    echo 无效的选项，请重新输入。
    pause
    goto pluginSettingsMenu
)

:pluginSetting1
rem 在此处添加插件设置选项1的逻辑
echo 插件设置选项1
pause
exit /b

:pluginSetting2
rem 在此处添加插件设置选项2的逻辑
echo 插件设置选项2
pause
exit /b
