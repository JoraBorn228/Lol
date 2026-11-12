# CHANGELOG — PROJECT: INDUSTRIA

Все даты указаны по локальному времени владельца. Изменения остаются локальными до принятия задач и отдельного разрешения на push.

## 2026-11-11 — Phase 0 preparation

- Установлен Rojo CLI 7.7.1 из официального GitHub-релиза; добавлен пользовательский PATH.
- Установлен Rojo Studio-плагин `RojoManagedPlugin.rbxm`.
- Инициализирован локальный Git-репозиторий на ветке `main`, настроен `origin` на `JoraBorn228/Lol`; push не выполнялся.
- Созданы `default.project.json`, `src/`, `.gitignore` и проектная документация.
- Успешно собрана локальная тестовая карта через `rojo build`; `rojo serve` слушает `localhost:34872`.
- Live-синхронизация пока не подтверждена: тестовое окно Studio остановилось на диалоге сохранения при перезапуске для загрузки Rojo-плагина. Исходный `Place1` не менялся; удалённый репозиторий не изменялся.

## 2026-11-11 — Phase 1 entry

- Начальный Phase 0 коммит `38dc68e` отправлен в `origin/main` по прямому разрешению владельца.
- По разрешению владельца начата Phase 1, пока PRE-016 всё ещё открыта.
- CORE-001: добавлен `src/ServerScriptService/Bootstrap.server.lua` как минимальная серверная точка входа; игровой запуск ещё не проверялся.
- После команды владельца продолжить CORE-001 принят; CORE-002: добавлена минимальная клиентская точка входа `src/StarterPlayer/StarterPlayerScripts/Bootstrap.client.lua`.

## 2026-11-12 — Phase 1 foundation

- Adopted autonomous per-task commits and phase summary commits at owner request.
- Fixed uncommented prose in the client bootstrap; previous Rojo build checks had not detected the Luau syntax issue.
- CORE-003: shared frozen GameConfig.
- CORE-004: scoped info/debug/warn logger.
- CORE-005: idempotent server-owned RemoteEvent setup and persistent readiness.
- CORE-006: player session registration/removal and bootstrap wiring.
- CORE-007/008: anchored 256-stud test ground and neutral enabled spawn.
- CORE-009: real server/client Play checks passed; registration, live character, readiness and repeat remote setup verified. Bounded readiness wait fixes a possible client startup race.
- All Phase 1 tasks remain REVIEW. PRE-016 remains open; no claim of completed Phase 0 or verified live sync.

## 2026-11-12 — Phase 3 Building Foundation complete

- Phase 2 skipped by direct owner instruction; default Roblox camera/controls retained.
- BUILD-001…BUILD-018 implemented as separate commits: config, grid, catalog, original 4x4x8 test asset, build toggle, local ghost, pointer raycast, quarter-turn rotation, overlap and map bounds, validity HUD, request/result remotes, authoritative placement, GUIDs, owner-checked demolition, charge/refund adapter.
- BUILD-019: 19 server checks and actual two-client placement/ownership/refund test passed. Startup race fixed; temporary test scripts removed from Studio.
- All BUILD tasks are REVIEW. Owner manual review remains pending. Materials use a temporary construction balance until Phase 4 inventory integration. Flat foundation only; persistence is planned later.
- Phase 3 summary commit records completion; stop at phase boundary per working agreement. PRE-016 remains open independently.
