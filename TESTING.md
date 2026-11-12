# TESTING — PROJECT: INDUSTRIA

## Проверки PRE-001…PRE-007

| Проверка | Результат | Доказательство |
|---|---|---|
| Roblox Studio | Доступна | MCP видит `Place1` в режиме Edit |
| Codex и рабочая папка | Доступны | CLI отвечает; рабочая папка читается |
| Blender | Доступен | Blender 4.3.2 отвечает через MCP |
| Blender MCP | Подключён | Add-on 1.8, protocol 15 совпадает с сервером |
| Roblox Studio MCP | Подключён | `list_roblox_studios` возвращает `Place1` |
| Git | Доступен | Git 2.51.0.windows.1 |
| Rojo | Установлен | CLI 7.7.1; пользовательский PATH обновлён; Studio-плагин установлен |

## Проверки PRE-008…PRE-015

Локальный Git-репозиторий и базовая структура созданы. Проверки после создания файлов будут записаны ниже. Удалённая отправка не выполнялась.

## PRE-016 — Rojo synchronization

Статус: **IN_PROGRESS**. `rojo build default.project.json --output build/INDUSTRIA.rbxlx` завершился успешно (Rojo 7.7.1). `rojo serve` запущен и слушает `localhost:34872`. Отдельная локальная копия `build/INDUSTRIA.rbxlx` открыта в Roblox Studio (`persistedToCloud=false`); исходное `Place1` не изменялось.

Live sync не подтверждён: тестовое окно Studio открыло служебное окно сохранения при попытке перезапустить Studio для загрузки только что установленного плагина. Плагин Rojo не показал подключённого клиента в журнале сервера. Для завершения нужно закрыть/разрешить этот диалог в тестовом Studio, открыть вкладку Plugins → Rojo, нажать Connect и проверить поступление временного файла из `src/ServerScriptService`. Не сохранять тестовое место в облако.

## Ограничения

- Исходное `Place1` не изменялось. Тестовая копия `INDUSTRIA.rbxlx` локальная и сообщает `persistedToCloud=false`.
- Сборка или синхронизация не подтверждают запуск игры или работу мультиплеера.

## CORE-001 — Bootstrap.server.lua

`rojo build default.project.json --output build/INDUSTRIA.rbxlx` завершился успешно; проверочная сборка содержит `Bootstrap.server.lua`. Запуск игры не выполнялся, так как CORE-001 требует создания точки входа, а отдельная задача CORE-009 предназначена для запуска и проверки игры.

## CORE-002 — Bootstrap.client.lua

Статус: **REVIEW**. Проверочная сборка Rojo должна включать LocalScript из `StarterPlayerScripts`. Игровой запуск не выполнялся; он предусмотрен задачей CORE-009.

## 2026-11-12 — CORE-009: actual Studio play check

- Built and opened isolated `build/INDUSTRIA-Phase1.rbxlx`.
- Started and stopped Play twice. Server and client bootstrap messages appeared; project startup had no Luau errors.
- Verified an alive client character at approximately Y=5.09 above the spawn pad, server-owned readiness, a RemoteEvent and idempotent remote creation.
- Confirmed player registration through the live player's IndustriaSessionRegistered attribute. Requiring PlayerService from MCP initially returned a separate module state (count 0 while the game reported registration), so that count was not treated as a reliable live-state observation.
- Updated sources through MCP for the second run. This does NOT verify Rojo live-sync; PRE-016 remains IN_PROGRESS.
- Output contains asset-type warnings for rbxassetid://203785492 from Studio tooling. No project script uses this asset.
- Owner check: walk, jump, reset the character, confirm respawn on the pad; test player leaving and a multi-client session later. These interactions were not exercised automatically.

## 2026-11-12 — tool access audit

- Roblox Studio MCP: listing, Edit/Server/Client execution, Play start/stop, Output reading work.
- Blender MCP: addon status and scene inspection work; Blender 4.3.2 has addon protocol 15 while server expects 16. Updated addon file through official `uvx mcp-for-blender install-addon`; running addon still needs reloading in Blender. Current fallback connection works.
- Poly Haven, Sketchfab, Poly Pizza and paid generators are off. They are optional and were not activated or used.
- Git CLI, authenticated origin push (previously verified), filesystem, Rojo 7.7.1 build work. No cloud game publishing was performed.
- PRE-016 is still pending plugin Connect. A working Studio MCP connection is independent of Rojo synchronization.
