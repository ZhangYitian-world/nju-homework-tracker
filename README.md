# 作业记录本（Homework Tracker）

一个**零构建、单文件**的网页应用：记录课程作业、日程安排和个人探索；支持上传课表截图，在浏览器本地 OCR 识别后生成周课表。

数据存在云端（WorkBuddy Cloud Service：Postgres + 邮箱账号 + 行级权限 RLS），登录后手机与电脑看到同一份数据，支持「添加到主屏幕」当 App 用。

## 功能

- **课程作业**：按课程记录作业，设置截止日期/时间，到期自动分组标色（已逾期 / 今天 / 明天 / 本周），三天内截止提醒
- **日程**：独立栏目，含活动分类、名称、日期、开始时间、地点、备注；日期未定的单独分组
- **我的探索**：记录自己想搞明白的方向（技术、书、工具…），与作业互不干扰
- **我的课表**：上传课表截图 → 浏览器本地 OCR → 逐条校正 → 保存为周课表；也支持手动补课
- **其它**：搜索、状态筛选、统计卡、PWA「添加到主屏幕」、多设备自动刷新

## 技术特点

- **单文件应用**：全部逻辑内联在 `index.html`，双击即可打开，无需 npm、无构建步骤
- **云 SDK 走 CDN**，带三级镜像回退（jsdelivr → fastly → unpkg），任一可用即可启动
- **OCR 全部本地执行**：Tesseract.js 静态托管在同源目录 `ocr/`，截图不上传、不入库
- **原生 JS + 原生 CSS**，无框架、无依赖树

## 快速开始

1. **准备后端**：在 WorkBuddy 云服务创建一个应用（含 Postgres、邮箱账号体系）。
2. **建表**：用云端 SQL 工具执行 `timetable-migration.sql` 和 `events-migration.sql`（迁移工具一次只接受一条语句，按分号拆分逐条执行）。
3. **填配置**：打开 `index.html`，把 `publicConfig` 换成你自己的：
   ```js
   const publicConfig = {
     endpoint: "https://你的应用域名",
     publishableKey: "你的 publishable key",
   };
   ```
4. **部署**：整目录上传到任意静态托管（注意 `ocr/` 必须一起部署，否则「截图导入」会失败）。

## 目录结构

```
index.html                 # 全部应用逻辑（HTML + CSS + JS 内联）
manifest.json              # PWA 清单
icon-180.png / icon-512.png# 主屏幕图标
timetable-migration.sql    # 课表表结构 + RLS
events-migration.sql       # 日程字段（homework.location）
ocr/                       # Tesseract.js 7.0.0 静态组件、WASM 与中英文模型
```

## 隐私与安全

- 每张表都开启 **RLS**：策略为 `owner_id = auth.uid()`，登录用户只能读写自己的记录
- 前端**从不传 `owner_id`**，由数据库默认值 `auth.uid()` 填充
- `publishableKey` 是**客户端公开密钥**（设计上就写在页面里），不是服务端密钥；但仓库里仍建议用占位符，避免把具体实例地址公开

## 第三方组件

`ocr/` 下为官方 Tesseract.js 7.0.0 静态文件与 `4.0.0_best_int` 中英文模型，许可证随目录保留（`ocr/LICENSE.md`、`ocr/core/LICENSE`）。

## 许可

本项目以 **MIT License** 发布，可自由使用、修改、再发布。详见 `LICENSE`。

## 说明

截图识别的网格解析针对常见的「周课表网格」截图格式做了适配；非规则排版、无色表格、模糊截图只能尽力提取，识别结果一律需要人工校正。
