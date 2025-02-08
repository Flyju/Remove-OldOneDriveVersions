# Remove-OldOneDriveVersions
### **中文描述**
此 PowerShell 脚本用于自动查找并删除 Microsoft OneDrive 的旧版本文件夹。它首先通过检查正在运行的 `OneDrive.exe` 进程获取安装路径，若未找到则提示手动输入路径。然后，脚本会识别当前版本，并删除与当前版本不匹配的旧版本文件夹，释放硬盘空间。
如果觉得好用，请点个Star，谢谢。
---

### **English Description**
This PowerShell script is designed to automatically locate and delete old version folders of Microsoft OneDrive. It first retrieves the installation path by checking the running `OneDrive.exe` process. If the path is not found, it prompts the user to manually input the path. The script then identifies the current version and removes any outdated version folders that do not match the current version, helping users free up disk space.
If you find it useful, please give it a **Star**. Thank you!
