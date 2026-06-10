# 介入数据填报与管理平台迁移说明

## 文件说明

`Script` 目录只保留一个迁移入口和必要配套文件：

- `run_full_migration.bat`：唯一执行入口。
- `run_full_migration.ps1`：清理、迁移、文件归位调度。
- `01_migrate_all.ps1`：从旧 SQL Server 读取并导入新 PostgreSQL。
- `03_copy_migrated_files.ps1`：按本次迁移清单归位实体文件。
- `00_create_schema.sql`：新系统 `mcr` schema 建表。
- `03_cleanup_mcr_data.sql`：清理目标库中 MCR 数据。

迁移范围包括：

- 医院、用户、角色、权限。
- 病例、质控报表、评审会议、评审记录、汇总记录。
- 附件元数据和附件备注。
- 文献数据。

## 文件迁移规则

数据库只保存文件相对路径，实体文件必须放到新系统配置的文件夹下。

当前新系统配置：

- 普通上传文件：`MultiCenterRegistry\FileStorage\upload`
- DICOM 文件：`MultiCenterRegistry\FileStorage\dicom`

数据库中的路径规则：

- 病例图片附件统一迁移到 `upload/cases/{caseIdN}/{fieldKey}/{fileName}`，与新系统后续上传保持一致。
- 旧系统 3 个病例文件题固定映射为：`化验单图片上传 -> lab_file`、`心电图图片上传 -> ecg_file`、`心脏彩超 -> echo_file`。
- `file_path = upload/cases/xxx/lab_file/a.jpg` 时，实体文件应在 `MultiCenterRegistry\FileStorage\upload\cases\xxx\lab_file\a.jpg`
- 旧系统中不属于病例固定文件题的历史附件仍按 `upload/legacy/{fileId}/{fileName}` 归位。
- `file_path = dicom/study/a.dcm` 时，实体文件应在 `MultiCenterRegistry\FileStorage\dicom\study\a.dcm`

迁移脚本会生成 `Script\output\all_migration\05_files\file_manifest.csv`。该清单是本次迁移的文件归位依据，不是长期固定快照。`output` 是每次执行迁移时生成的运行产物，不需要提交或手工维护。

最终普通上传文件会归位到：

```text
MultiCenterRegistry\FileStorage\upload
```

最终 DICOM 文件会归位到：

```text
MultiCenterRegistry\FileStorage\dicom
```

正式上线时不要使用旧的 CSV 快照。每次正式迁移都执行 `run_full_migration.bat`，脚本会重新读取旧库、重新生成 `file_manifest.csv`，再按本次新生成的清单复制文件。

如果你先把云端旧文件整体下载到新系统 `FileStorage` 根目录下，不需要人工分拣。直接执行：

```bat
.\Script\run_full_migration.bat
```

`run_full_migration.bat` 默认读取旧文件源目录：

```text
MultiCenterRegistry\FileStorage
```

脚本会先全量迁移数据库，再递归索引该目录，自动排除已归位的 `upload` 和 `dicom` 目录，按本次迁移生成的 `file_manifest.csv` 自动复制：

- `target_area = upload` 的文件复制到 `FileStorage\upload`
- `target_area = dicom` 的文件复制到 `FileStorage\dicom`

bat 默认使用覆盖模式，便于一个月后正式迁移时用正式源文件覆盖测试迁移阶段复制过的同名文件。复制成功后，脚本会清理 `FileStorage` 根目录中已成功归位的源文件；不会删除 `upload`、`dicom` 目录中的文件，也不会删除缺失或复制失败的文件。

文件归位脚本会先读取 `FileStorage` 根目录文件索引，按 `file_manifest.csv` 快速匹配需要迁移的文件；只有未匹配到的文件才进入递归扫描。执行时会按 500 条输出进度，便于判断是否卡住。

正式迁移建议在 Windows 本机 PowerShell 或双击 bat 执行，不建议从 WSL 的 `/mnt/f` 路径执行大量文件扫描。WSL 访问 Windows 盘的小文件递归 I/O 会明显变慢。

## 推荐执行方式

正式迁移只需要执行一个 bat：

```bat
.\Script\run_full_migration.bat
```

执行前确认：

- 旧 SQL Server 连接串在 `run_full_migration.bat` 的 `MCR_SOURCE_SQLSERVER` 中。
- 新 PostgreSQL 连接串在 `MultiCenterRegistry\appsettings.json` 中。
- 旧系统实体文件已经整体放入 `MultiCenterRegistry\FileStorage` 根目录。
- 默认迁移账号密码为 `123456`，`run_full_migration.bat` 已内置对应 Hash。

执行时输入 `YES` 后，脚本会依次完成：

- 清理目标库中的 MCR 数据。
- 从旧 SQL Server 全量迁移到新 PostgreSQL。
- 读取本次生成的 `file_manifest.csv`，将实体文件归位到 `FileStorage\upload` 和 `FileStorage\dicom`。
- 清理已成功归位的根目录源文件。

## 输出文件

- `Script\output\all_migration\01_import_all.sql`：最终导入 SQL。
- `Script\output\all_migration\migration_report.json`：迁移数量报告。
- `Script\output\all_migration\05_files\registry_file.csv`：附件元数据，包含 `remark`。
- `Script\output\all_migration\05_files\file_manifest.csv`：实体文件核对清单。
- `Script\output\all_migration\05_files\file_copy_report\file_copy_result.csv`：实体文件复制结果。
- `Script\output\all_migration\05_files\file_copy_report\file_copy_summary.json`：实体文件复制统计。
- `Script\output\all_migration\unmapped_answers.csv`：无法映射到新固定表单字段的旧答案。

## 注意事项

- 全量导入会删除并重建 `mcr` schema。
- 全量导入不会修改新库中已存在的用户账号；旧库用户如果按账号已存在，只建立业务数据引用映射，不更新用户资料、密码、角色和医院范围。
- 全量导入会清理并重建 MCR 角色、MCR 权限、医院、科室及新迁移用户需要的角色范围数据。
- 新系统没有“科室权限范围”设计，未设置医院范围表示全部医院。
- 实体文件复制不依赖固定 CSV 快照，只依赖本次迁移重新生成的 `file_manifest.csv`。
- 实体文件可以用 `run_full_migration.bat` 从旧文件总目录自动复制，不需要逐条移动。
- 迁移完成后可用 `file_manifest.csv` 抽查数据库中的相对路径是否能在 `FileStorage` 下找到实体文件。
- 文件复制报告会统计 `copied`、`planned`、`missing`、`ambiguous`、`cleanup_deleted`、`cleanup_skipped`、`cleanup_failed`。`missing` 表示源目录中没有找到对应实体文件，需要回到旧服务器文件目录核对。
