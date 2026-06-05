# 迁移脚本说明

本目录只放迁移相关脚本。默认脚本先做只读盘点，不直接写入 PostgreSQL。

## 文件

- `00_create_schema.sql`：新建 `mcr` 模式和核心业务表，执行前必须单独确认。
- `04_extend_form_storage.sql`：新增硬编码表单存储表，执行前必须单独确认。
- `01_inventory_source.ps1`：只读盘点旧 SQL Server 表数量。
- `02_inventory_form_fields.ps1`：只读导出病例、质控、评价相关表单字段配置和答案分布。
- `03_build_field_catalog.ps1`：基于只读盘点结果生成硬编码表单字段目录。
- `05_build_form_catalog_seed.ps1`：基于字段目录生成 `05_seed_form_catalog.sql`，执行前必须单独确认。
- `06_migrate_cases.ps1`：迁移病例主表和病例表单答案；默认需要 `-Export` 才生成导入文件，`-Execute` 才写入 PostgreSQL。
- `07_migrate_quality.ps1`：迁移质控主表、驳回记录和质控表单答案；默认需要 `-Export` 才生成导入文件，`-Execute` 才写入 PostgreSQL。
- `08_migrate_meetings.ps1`：迁移会议、专家、评价、总结、投票和专家评审答案；默认需要 `-Export` 才生成导入文件，`-Execute` 才写入 PostgreSQL。
- `09_migrate_identity.ps1`：迁移医院、科室、用户、MCR 角色权限，并把已迁移业务数据中的旧医院/用户 ID 映射为现系统 ID；默认需要 `-Export` 才生成导入文件，`-Execute` 才写入 PostgreSQL。
- `12_cleanup_create_case_form.sql`：清理旧库已生成的“创建病例信息”冗余模板、实例、字段值和附件，执行前必须单独确认。
- `13_extend_admin_content.sql`：新增文献、系统消息和门户配置运行期表，执行前必须单独确认。
- `14_migrate_articles.ps1`：迁移旧系统 `MCRArticle` 文献和系统消息；默认需要 `-Export` 才生成导入文件，`-Execute` 才写入 PostgreSQL。
- `15_extend_system_user_email.sql`：给 `system.sys_user` 增加邮箱字段，执行前必须单独确认；需要在重新执行 `09_migrate_identity.ps1 -Execute` 前先执行。
- `tools\PasswordHashTool`：使用现系统 Bio.Core 密码哈希器生成统一临时密码哈希，供用户迁移脚本使用。
- `run_inventory.bat`：Windows 批处理入口，调用只读盘点脚本。
- `run_form_inventory.bat`：Windows 批处理入口，调用表单字段盘点和字段目录生成脚本。
- `run_case_migration_export.bat`：Windows 批处理入口，只导出病例迁移 CSV 和导入 SQL，不写库。
- `run_quality_migration_export.bat`：Windows 批处理入口，只导出质控迁移 CSV 和导入 SQL，不写库。
- `run_meeting_migration_export.bat`：Windows 批处理入口，只导出会议评审迁移 CSV 和导入 SQL，不写库。
- `run_identity_migration_export.bat`：Windows 批处理入口，只导出身份数据迁移 CSV 和导入 SQL，不写库。
- `run_article_migration_export.bat`：Windows 批处理入口，只导出文献和系统消息迁移 CSV 和导入 SQL，不写库。

## 运行只读盘点

在 PowerShell 或批处理环境中先设置旧库连接字符串：

```powershell
$env:MCR_SOURCE_SQLSERVER = "<旧 SQL Server 连接字符串>"
.\Script\run_inventory.bat
```

生成结果默认写入 `Script\output\source_inventory.json`。
