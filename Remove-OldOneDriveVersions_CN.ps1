# 通过进程获取 OneDrive 路径
function Get-OneDrivePathFromProcess {
    # 查找当前运行的 OneDrive.exe 进程
    $oneDriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue

    if ($oneDriveProcess) {
        # 获取 OneDrive.exe 的完整路径
        $oneDrivePath = $oneDriveProcess.Path
        # 获取 OneDrive.exe 所在的文件夹路径
        $oneDriveFolderPath = Split-Path -Path $oneDrivePath -Parent
        return $oneDriveFolderPath
    } else {
        return $null
    }
}

# 获取 OneDrive 路径
Write-Output "正在查找 OneDrive 安装路径..."
$oneDrivePath = Get-OneDrivePathFromProcess

# 如果未找到路径，提示用户手动输入
if (-not $oneDrivePath) {
    Write-Output "未能获取到 OneDrive 安装路径（OneDrive 可能未运行）。"
    $oneDrivePath = Read-Host "请输入 OneDrive 安装路径"
}

Write-Output "获取到的 OneDrive 文件夹路径：$oneDrivePath"
# 检查路径中是否存在 OneDrive.exe
if (-not (Test-Path "$oneDrivePath\OneDrive.exe")) {
    Write-Output "未找到 OneDrive.exe 文件，请确认路径是否正确。"
    exit
}

# 获取当前 OneDrive 版本
$currentVersion = (Get-Item "$oneDrivePath\OneDrive.exe").VersionInfo.ProductVersion
Write-Output "当前使用的 OneDrive 版本：$currentVersion"

# 查找旧版本文件夹
Write-Output "查找旧版本文件夹..."
$oldFolders = Get-ChildItem -Path $oneDrivePath -Directory |
    Where-Object { $_.Name -match '^\d{2}\.\d{3}\.\d{4}\.\d{4}$' } |
    Where-Object { $_.Name -ne $currentVersion }

# 判断是否有旧版本文件夹
if ($oldFolders.Count -eq 0) {
    Write-Output "未找到旧版本的 OneDrive 文件夹。"
} else {
    # 删除旧版本文件夹
    $oldFolders | ForEach-Object {
        Write-Output "即将删除旧版本文件夹：$($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -Verbose
        Write-Output "已删除旧版本文件夹：$($_.FullName)"
    }
}

Write-Output "脚本执行完成！"
Write-Output "按任意键退出..."
[Console]::ReadKey()