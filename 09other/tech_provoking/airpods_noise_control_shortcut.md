# macOS 快捷键切换 AirPods Pro 降噪模式

> macOS 没有原生快捷键直接切换 AirPods Pro 的降噪/通透/自适应模式，需要借助工具实现。
>
> 以下方案在 macOS 26.2 (Tahoe) 下整理。

## 方案一：Raycast 扩展（推荐）

[AirPods Noise Control](https://www.raycast.com/chrahe/airpods-noise-control) 扩展已在 macOS Tahoe 上测试通过。

**步骤：**

1. 安装 [Raycast](https://www.raycast.com/)（免费）
2. 在 Raycast Store 搜索安装 ==AirPods Noise Control==
3. 配置扩展参数：
   - **AirPods List Position**：AirPods 在声音菜单中的位置序号
   - **AirPods Type**：选择 AirPods Pro
   - **Sound Menu Localization**：中文系统设为 `声音`
4. 在 Raycast 设置中为 **Switch Noise Control Mode** 命令分配全局快捷键
	1. 

支持在 **关闭 / 通透 / 自适应 / 主动降噪** 四种模式间切换，还支持 Toggle Conversation Awareness。

## 方案二：AppleScript + 快捷键工具

核心原理是通过 AppleScript 模拟点击控制中心的声音菜单来切换模式。

### AppleScript

> [!warning] 注意
> 中文系统下需将 `"Sound"` 改为 `"声音"`，`"Transparency"` 改为 `"通透"`，`"Noise Cancellation"` 改为 `"噪声控制"` 等，具体以系统实际显示为准。macOS 版本更新后 UI 结构可能变化，脚本需要相应调整。

来源：[GitHub Gist](https://gist.github.com/rossinek/c0807a6a08cbfbf3f14259c70d15e643)

```applescript
set soundMenu to ""
set airPodsToggle to ""
set ancToggle to ""
set transparencyToggle to ""

tell application "System Events"
    tell its application process "ControlCenter"
        set menuBarItems to menu bar items of menu bar 1
        repeat with mbi in menuBarItems
            if name of mbi contains "Sound" then
                set soundMenu to mbi
            end if
        end repeat

        if soundMenu is not equal to "" then
            click soundMenu
            set soundCheckboxes to checkbox of scroll area 1 of group 1 of window 1
            repeat with ch in soundCheckboxes
                if name of ch contains "AirPods" then
                    set airPodsToggle to ch
                end if
            end repeat

            if airPodsToggle is not equal to "" then
                if 1 is not value of airPodsToggle then
                    click airPodsToggle
                    return
                end if
            end if

            set soundCheckboxes to checkbox of scroll area 1 of group 1 of window 1
            repeat with ch in soundCheckboxes
                if name of ch contains "Transparency" then
                    set transparencyToggle to ch
                end if
                if name of ch contains "Noise Cancellation" then
                    set ancToggle to ch
                end if
            end repeat

            if transparencyToggle is equal to "" or ancToggle is equal to "" then
                return
            end if

            if value of transparencyToggle is 1 then
                click ancToggle
            else
                click transparencyToggle
            end if

            click soundMenu
        end if
    end tell
end tell
```

### 绑定快捷键

有几种工具可以将上面的 AppleScript 绑定到快捷键：

| 工具 | 说明 |
|:-----|:-----|
| [Keyboard Maestro](https://www.keyboardmaestro.com/) | 创建宏 → 添加 Execute AppleScript → 粘贴脚本 → 设定触发快捷键（付费） |
| [BetterTouchTool](https://folivora.ai/) | 同样支持绑定 AppleScript 到快捷键（付费） |
| Automator（系统自带） | 创建「快速操作」→ 添加「运行 AppleScript」→ 在 **系统设置 → 键盘 → 键盘快捷键 → 服务** 中分配快捷键（免费） |

> [!tip] 已知限制
> AppleScript 方案在**全屏模式**下可能不生效，因为控制中心菜单的后续点击无法执行。

## 方案三：Apple 快捷指令（有 bug）

macOS 快捷指令 App 中有「设定噪声控制模式」操作，理论上可行但存在已知问题。

**步骤：**

1. 打开「快捷指令」App
2. 新建快捷指令 → 搜索添加「设定噪声控制模式」
3. 选择路由设备为 AirPods Pro，模式选「每次询问」
4. 在快捷指令详情中分配键盘快捷键

> [!bug] 已知问题
> 当 AirPods 作为当前音频输出时，该快捷指令在 macOS 上[可能不生效](https://discussions.apple.com/thread/253584952)（iOS 上正常）。

## 方案对比

| 方案 | 优点 | 缺点 |
|:-----|:-----|:-----|
| **Raycast 扩展** | 开箱即用、已适配 macOS 26、免费 | 需安装 Raycast |
| **AppleScript** | 灵活可定制 | 依赖 UI 结构，系统更新可能失效；全屏下可能不工作 |
| **Apple 快捷指令** | 原生，无需第三方工具 | macOS 上有 bug，可能不生效 |
