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
