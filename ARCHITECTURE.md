# PROJECT: INDUSTRIA — Technical Architecture

**Версия:** 0.1  
**Стек:** Roblox Studio, Luau, Rojo, Git  
**Принцип:** сервер — источник достоверного игрового состояния.

## 1. Слои

### Server

Сервер проверяет и изменяет строительство, владение, инвентари, добычу, производство, конвейеры, электрические сети, исследования, сохранения и права доступа. Клиентские запросы никогда не принимаются без проверки параметров и состояния.

### Shared

Реплицируемые типы, конфигурации, определения предметов и рецептов, идентификаторы RemoteEvents/RemoteFunctions и безопасные утилиты. Здесь не должно быть секретов или авторитетных данных.

### Client

Камера, управление персонажем, интерфейс, строительное превью, локальная визуализация конвейеров, анимации и эффекты. Клиент отображает состояние и отправляет запросы; он не определяет итоговые цены, ресурсы или права.

### Assets

Общие клиентские модели размещаются в ReplicatedStorage только если они нужны клиенту. Серверные шаблоны и внутренние ресурсы — в ServerStorage. Тяжёлые модели и окружение подключаются по мере появления, с учётом StreamingEnabled.

## 2. Структура Rojo

```text
default.project.json
src/
  ReplicatedStorage/
    Shared/
      Config/
      Types/
      Util/
    Assets/
  ServerScriptService/
    Services/
  ServerStorage/
    Assets/
  StarterPlayer/
    StarterPlayerScripts/
      Controllers/
  Workspace/
    Map/
```

Документы находятся в корне и не мапятся в DataModel. `default.project.json` связывает `src` с соответствующими Roblox Services. Тестовые сборки хранятся в игнорируемой папке `build/`.

## 3. Планируемые серверные системы

| Система | Ответственность |
|---|---|
| Bootstrap | Проверка зависимостей и запуск сервисов в установленном порядке |
| PlayerService | Подключение, состояния игрока и регистрация в сессии |
| BuildService | Серверная проверка и создание/удаление построек |
| InventoryService | Проверяемые операции с ресурсами |
| ProductionService | Общий тик-диспетчер рецептов и буферов |
| MachineService | Состояния машин и подключения портов |
| ConveyorService | Серверная логика предметов, маршрутов и передачи |
| PowerService | Сети генерации и потребления энергии |
| ResearchService | Проверяемое открытие рецептов и машин |
| PlayerDataService | Загрузка, версия и сохранение сериализуемых данных |
| PermissionService | Проверка владельца и совместного доступа |

Системы добавляются отдельными задачами. Этот перечень не означает, что они уже реализованы.

## 4. Клиентские контроллеры

Планируются CameraController, BuildingController, интерфейсные контроллеры и ConveyorVisualController. Клиентское превью строительства может быть отзывчивым, но окончательное решение о размещении принимает BuildService.

## 5. Сеть и безопасность

- RemoteEvents/RemoteFunctions имеют централизованные определения и версии payload.
- Сервер проверяет типы, диапазоны, частоту запросов, положение игрока, доступность объекта, стоимость и права.
- Сетевые сообщения передают намерение, а не готовое авторитетное состояние.
- Нельзя доверять клиенту количество предметов, результат рецепта, ID владельца или допустимость строительства.
- Массовые операции ограничиваются размером и делятся на безопасные порции.

## 6. Производство

Один общий диспетчер планирует обновления активных машин, избегая бесконечного цикла на каждую машину. Состояние машины включает рецепт, входной и выходной буферы, прогресс, питание и статус. Обработка нехватки входов, отсутствия питания и заполненного выхода должна быть детерминированной.

## 7. Логика и отображение конвейеров

Сервер хранит логический маршрут и положение предметов по пути, ограничивает передачу и разрешает вход/выход. Клиент интерполирует визуальные экземпляры из состояния маршрута и переиспользует их через pooling. Никакой предмет не движется по ленте с помощью физического толчка.

## 8. Данные

Кандидат на сериализуемую запись постройки:

```text
BuildRecord = {
  id, templateId, ownerUserId, transform, settings, machineState
}
```

Кандидат на запись игрока/мира включает `schemaVersion`, инвентарь, открытые технологии и записи построек. Точный формат зависит от решения об общей карте и владении; его нельзя считать утверждённым до PRE-011/решения владельца. DataStoreService использует проверку, версионирование, защиту от конфликтующей записи и обработку отказов.

## 9. Производительность

- Workspace.StreamingEnabled рассматривается для большой карты.
- Визуальные предметы и часто создаваемые объекты переиспользуются.
- Сетевой трафик отправляет изменения, а не полные заводы каждый кадр.
- Производственный диспетчер ограничивает число обновлений и обрабатывает только активные машины.
- Оптимизации подтверждаются измерениями в целевой сцене.

## 10. Сборка и синхронизация

Rojo использует `default.project.json`, CLI установлен как 7.7.1. `rojo serve` обслуживает исходники, а плагин Rojo в Studio применяет изменения к выбранному месту. Перед live sync необходимо открыть правильный проект и проверить место назначения. `rojo build` создаёт проверочную локальную сборку в `build/`.

## 11. Проверки

Каждая задача проверяет только затронутый слой. Статический анализ и тесты добавляются, когда проект обзаведётся подходящими инструментами. Игровой запуск и мультиплеер нельзя объявлять проверенными без фактического запуска в Roblox Studio.

## Phase 3 construction

BuildService is authoritative for placement and demolition. Clients send template/position/quarter-turn or a BuildId; the server checks finite types, grid, map bounds, collision, reach, ownership and rate limits. Server-generated GUIDs identify objects. ConstructionBudget is a temporary session-only adapter until Phase 4 InventoryService exists; it owns costs/refunds. No client-supplied resource or owner values are used. Current geometry intentionally supports the flat foundation without stacking.

## Phase 4–5 inventory and production implementation

InventoryService is the sole server-owned per-player quantity store, with finite integer transaction validation, total capacity and all-or-nothing deltas. Replicated Inventory folder attributes are presentation only; no remote exposes arbitrary resource mutation. ConstructionBudget delegates to InventoryService.

ItemBuffer stores bounded machine contents. ProductionEngine consumes a complete recipe batch only when the entire output fits; a non-yielding completion publishes output exactly once. Progress pauses when disabled, underfed or blocked. ProductionService runs one Heartbeat dispatcher, capped at 1200 machines, and replicates status/progress/buffer snapshots. No machine owns a polling coroutine.

MachineService registers placed assets by TemplateId and BuildId, validates nearby living owners and request rate, transfers a recipe batch from inventory into input and all output back into inventory. Recipe changes require an empty machine. Demolition refunds both buffers and construction cost atomically before destruction. The current catalog has a single generic TestMachine; dedicated machines, energy, conveyors and persistence are later work.

## Phase 6 machine assets and extraction

Each machine asset uses an invisible anchored BasePart as a bounded collision/interaction root with noncolliding decorative Parts. MachineAsset.pivot preserves every child transform; previews disable query/collision on the full subtree. Attachments define input/output/power port orientation for later phases. JSON primitive specifications and .blend libraries are committed as authoring sources.

ResourceService creates finite server-owned nodes. BuildService checks extractor placement against node centers, and MachineService binds the server node instance. ProductionEngine deducts node stock only at an atomic output completion, preserving stock when blocked. Missing/exhausted nodes stop production. Generator remains PowerPending until Phase 8. Dedicated machine configurations limit available recipes, while PrototypePlate remains confined to TestMachine for compatibility.
