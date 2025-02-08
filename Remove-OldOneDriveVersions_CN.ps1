# ͨ�����̻�ȡ OneDrive ·��
function Get-OneDrivePathFromProcess {
    # ���ҵ�ǰ���е� OneDrive.exe ����
    $oneDriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue

    if ($oneDriveProcess) {
        # ��ȡ OneDrive.exe ������·��
        $oneDrivePath = $oneDriveProcess.Path
        # ��ȡ OneDrive.exe ���ڵ��ļ���·��
        $oneDriveFolderPath = Split-Path -Path $oneDrivePath -Parent
        return $oneDriveFolderPath
    } else {
        return $null
    }
}

# ��ȡ OneDrive ·��
Write-Output "���ڲ��� OneDrive ��װ·��..."
$oneDrivePath = Get-OneDrivePathFromProcess

# ���δ�ҵ�·������ʾ�û��ֶ�����
if (-not $oneDrivePath) {
    Write-Output "δ�ܻ�ȡ�� OneDrive ��װ·����OneDrive ����δ���У���"
    $oneDrivePath = Read-Host "������ OneDrive ��װ·��"
}

Write-Output "��ȡ���� OneDrive �ļ���·����$oneDrivePath"
# ���·�����Ƿ���� OneDrive.exe
if (-not (Test-Path "$oneDrivePath\OneDrive.exe")) {
    Write-Output "δ�ҵ� OneDrive.exe �ļ�����ȷ��·���Ƿ���ȷ��"
    exit
}

# ��ȡ��ǰ OneDrive �汾
$currentVersion = (Get-Item "$oneDrivePath\OneDrive.exe").VersionInfo.ProductVersion
Write-Output "��ǰʹ�õ� OneDrive �汾��$currentVersion"

# ���Ҿɰ汾�ļ���
Write-Output "���Ҿɰ汾�ļ���..."
$oldFolders = Get-ChildItem -Path $oneDrivePath -Directory |
    Where-Object { $_.Name -match '^\d{2}\.\d{3}\.\d{4}\.\d{4}$' } |
    Where-Object { $_.Name -ne $currentVersion }

# �ж��Ƿ��оɰ汾�ļ���
if ($oldFolders.Count -eq 0) {
    Write-Output "δ�ҵ��ɰ汾�� OneDrive �ļ��С�"
} else {
    # ɾ���ɰ汾�ļ���
    $oldFolders | ForEach-Object {
        Write-Output "����ɾ���ɰ汾�ļ��У�$($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -Verbose
        Write-Output "��ɾ���ɰ汾�ļ��У�$($_.FullName)"
    }
}

Write-Output "�ű�ִ����ɣ�"
Write-Output "��������˳�..."
[Console]::ReadKey()