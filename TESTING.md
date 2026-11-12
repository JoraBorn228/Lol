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

## 2026-11-12 — Phase 3 verification

- Rojo build generated INDUSTRIA-Phase3.rbxlx. Actual Play exposed a client startup race (Controllers was not yet copied into PlayerScripts); bounded WaitForChild fixed it. Second launch loaded BuildingHUD successfully.
- Client BuildRequest placed a rotated TestMachine; server building and BuildId replicated to client. Removal through the same remote removed the exact test object.
- tests/Phase3.server.lua: 19 assertions passed, using two synthetic actors in one real client session. Covered negative snapping, NaN/infinity, unknown template, invalid rotation, off-grid/out-of-range requests, overlap, ownership, duplicate refunds and rate limiting.
- tests/Phase3.multiplayer.server.lua and .client.lua: ExecuteMultiplayerTestAsync(2, {phase3=true}) returned passed=true, realClients=2, ownership=true, replication=true, refunds=true. Two real simulated clients placed distinct GUID objects, rejected foreign removal, removed their own objects, and each finished with 20 construction units. Temporary harnesses were removed from the edit scene after the run; tests are outside src and excluded from normal builds.
- Official API: https://create.roblox.com/docs/reference/engine/classes/StudioTestService
- Manual owner checks: B toggles mode; pointer follows ground; R rotates rectangular footprint; green/red preview agrees with allowed/blocked placement; click places; X removes; HUD reports cost/refund. Check touch controls separately; a full mobile build UI is outside this phase.
- Construction budget is a session-only adapter starting at 20 units, not the Phase 4 item inventory. Buildings and budget are not persistent yet. Placement currently supports the flat Phase 1 foundation only, with no stacking or arbitrary terrain placement.
- PRE-016 Rojo live sync is still unverified. Final code was built with Rojo; client startup fix was transferred to the isolated Studio scene through MCP before tests.

Phase 4: 18 inventory assertions passed in Studio Server (isolated Folder actor): additions/removals, atomicity, NaN/infinity/fractions, capacity, unknown IDs, isolated snapshots and construction debit/refund. Real client InventoryHUD loaded, IronOre=10 and ConstructionUnit=20 replicated. Creating synthetic Player was denied by Studio capability; test uses an isolated attribute-compatible Folder instead.

## 2026-11-13 — Phase 5 production checks

- Three deterministic recipes checked: IronPlate (2 IronOre -> 1, 2s), CopperWire (1 CopperOre -> 2, 2s), Concrete (3 Limestone -> 1, 3s).
- tests/Phase5.server.lua: 36 assertions passed in Studio Server. Includes missing input, partial progress, pause/resume, exact consumption/yields, no free repeats, full output pause/resume, input capacity, atomic buffers, invalid dt, and full-inventory demolition refunds preserving both sides.
- Real client loaded InventoryHUD and MachineHUD without project startup errors.
- An initial live-session integration assertion used fixed starting stock while manual gameplay was also changing resources; this was not treated as a production failure. Repeated integration in a separate QA copy with known starting stock.
- ExecuteMultiplayerTestAsync(2,{phase5=true}) returned passed=true, clients=2, inventory=true, production=true, ownership=true, duplicateCollect=true, refund=true. Each client placed a test machine, failed to load/remove the foreign machine, deposited 2 ore, collected exactly 1 plate, could not collect twice, and received construction cost back on demolition.
- Temporary multiplayer harness scripts and result attributes were removed from the QA edit scene. Test files are outside src and excluded from normal builds.
- Final regression in the Phase5 QA session: Phase3 server checks 19/19, Phase4 inventory 18/18, Phase5 production 36/36 (73 total). Phase3 synthetic actor fixture adapted to the unified inventory surface.
- Manual owner checks: I opens inventory; B + click builds; approach test block and use E / proximity prompt; load one recipe batch, observe progress and output, collect, pause/resume, switch recipe only when empty. X demolition returns stored input/output and construction resources if capacity permits.
- Session-only data; persistence, electricity, conveyors and dedicated machine models belong to later phases. A single heartbeat dispatcher drives production; catch-up is capped at one second per tick and one cycle per step. No offline production.
- Studio plugin asset-type warnings persist for rbxassetid://203785492. Project startup and automated checks passed. Rojo live-sync PRE-016 remains unverified; build and Studio test access work.

## 2026-11-13 — inventory opening fix

Reproduced InventoryHUD present but I not opening at default action priority 2000. Raised inventory binding to priority 3001; added permanent bottom-left Inventory [I] button and explicit close button, with DisplayOrder 20. Live QA controller updated through MCP and restarted. Verified I opens and closes, mouse down/up opens via InventoryToggle, close button hides the panel. Input checks wait 300–350 ms for delivery; initial immediate assertions raced with input processing. Chat text focus still passes through. Rojo build is separate from live sync; PRE-016 remains open.
