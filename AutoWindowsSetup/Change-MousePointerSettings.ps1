# マウスカーソルの種類と大きさを変更するスクリプト
# 設定アプリ ＞ デバイス ＞ マウス ＞ マウス ポインターとタッチ から変更する項目

# 共通ライブラリの読み込み
. "$PSScriptRoot\ClassLibrary\Logger.ps1"
. "$PSScriptRoot\ClassLibrary\CommonUtil.ps1"

$RegPath = "HKCU:\Control Panel\Cursors"

# マウスポインターの色を黒に設定
[Logger]::Info("===== マウスポインターの色を黒に設定します... =====")

# スキーム名
Set-ItemProperty -Path $RegPath -Name "(default)" -Value "Windows Black" -Force

# サイズの変更
Set-ItemProperty -Path $RegPath -Name "CursorBaseSize" -Value 48 -Type DWord -Force
# 各ポインターの設定
$expandValues = @{
    # AppStarting: 矢印+砂時計/円
    # サイズ1画像: wait_r.cur -> サイズ2標準: work_rm.ani
    "AppStarting" = "%SystemRoot%\cursors\wait_r.cur"
    # Arrow: 通常の矢印
    # サイズ1画像: arrow_r.cur -> サイズ2標準: arrow_rm.cur
    "Arrow"       = "%SystemRoot%\cursors\arrow_r.cur"
    # Crosshair: 十字
    "Crosshair"   = "%SystemRoot%\cursors\cross_r.cur"
    # Help: ヘルプ選択
    "Help"        = "%SystemRoot%\cursors\help_r.cur"
    # IBeam: テキスト選択
    "IBeam"       = "%SystemRoot%\cursors\beam_r.cur"
    # No: 利用不可
    "No"          = "%SystemRoot%\cursors\no_r.cur"
    # NWPen: 手書き
    "NWPen"       = "%SystemRoot%\cursors\pen_r.cur"
    # Person: ユーザー
    "Person"      = "%SystemRoot%\cursors\person_r.cur"
    # Pin: ピン
    "Pin"         = "%SystemRoot%\cursors\pin_r.cur"
    # SizeAll: 移動
    "SizeAll"     = "%SystemRoot%\cursors\move_r.cur"
    # SizeNESW: 斜めサイズ変更1
    "SizeNESW"    = "%SystemRoot%\cursors\size1_r.cur"
    # SizeNS: 縦サイズ変更
    "SizeNS"      = "%SystemRoot%\cursors\size4_r.cur"
    # SizeNWSE: 斜めサイズ変更2
    "SizeNWSE"    = "%SystemRoot%\cursors\size2_r.cur"
    # SizeWE: 横サイズ変更
    "SizeWE"      = "%SystemRoot%\cursors\size3_r.cur"
    # UpArrow: 上向き矢印
    "UpArrow"     = "%SystemRoot%\cursors\up_r.cur"
    # Wait: 待機状態 (砂時計/円)
    "Wait"        = "%SystemRoot%\cursors\busy_r.cur"
}

foreach ($name in $expandValues.Keys) {
    $value = $expandValues[$name]
    Set-ItemProperty -Path $RegPath -Name $name -Value $value -Force
}

[Logger]::Info("マウスポインター設定の変更が完了しました。")

# --- 設定反映 (サインアウト/サインイン) ---
[Logger]::Warning("設定を反映するにはサインアウトが必要です")

if ([CommonUtil]::Confirm("今すぐサインアウトしますか?")) {
    [Logger]::Write("サインアウトします...")
    shutdown.exe /l
} else {
    [Logger]::Write("スキップしました。後でサインアウトして設定を反映してください。")
}

[Logger]::Success("===== マウスポインターの設定を変更しました =====")