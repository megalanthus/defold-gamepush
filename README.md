<p align="center">
  <img src="gp-logo.png" alt="GamePush Logo"/>
</p>

# GamePush for Defold

[GamePush](https://gamepush.com) (ранее GameScore) расширение для движка [Defold](https://defold.com) (для версии
Defold >= 1.4.0). GamePush это сервис для удобной публикации HTML5 игр на разных платформах с одним SDK. Сервисом
поддерживается локальная отладка игры.

- [Установка](#installation)
- [Инициализация](#initialize)
- [API](#api)
- [Вызов нативных методов платформы](#native-sdk)
- [Заглушка для других платформ, отличных от html](#mock)
- [Заглушка для нативных вызовов](#mock-native)

<a name="installation"></a>

## Установка

Вы можете использовать его в своем собственном проекте, добавив этот проект в
качестве [зависимости библиотеки Defold](https://defold.com/manuals/libraries/).

<a name="initialize"></a>

## Инициализация

В файл game.project необходимо добавить раздел gamepush и указать id и token игры, остальные параметры можно опустить:

```
[gamepush]
id = идентификатор игры
token = токен
description = There are not enough words to describe the awesomeness of the game
image = /img/ogimage.png
```

Дополнительные параметры: [(doc)](https://docs.gamepush.com/docs/social-actions)

Для начала необходимо инициализировать SDK с помощью метода init:

```lua
local gamepush = require("gamepush.gamepush")

gamepush.init(function(success)
    if success then
        -- инициализация прошла успешно
    else
        -- ошибка инициализации
    end
end)
```

Для подписки на событие необходимо определить соответсвующий метод таблицы callbacks:

```lua
local gamepush = require("gamepush.gamepush")

local function ads_start()
    -- выключаем звук
end

local function ads_close(success)
    -- включаем звук
end

local function ads_reward()
    -- подкидываем золотишка игроку
end

-- функции событий можно назначить до инициализации SDK
gamepush.ads.callbacks.start = ads_start
gamepush.ads.callbacks.close = ads_close
gamepush.ads.callbacks.rewarded_reward = ads_reward
-- инициализация SDK
gamepush.init(function(success)
    if success then
        -- показываем прелоадер
        gamepush.ads.show_preloader(function(result)
            -- реклама закрыта, можно что-то делать
        end)
        -- что то делаем еще

        -- показываем рекламу за вознаграждение 
        gamepush.ads.show_rewarded_video()

        -- показываем рекламу за вознаграждение с использованием колбека
        gamepush.ads.show_rewarded_video(function(result)
            if result then
                -- подкидываем игроку кристаллов
            end
        end)
    else
        -- ошибка инициализации
    end
end)
```

<a name="api"></a>

## API

| GamePush JS SDK                                                                                                     | GamePush Lua API                                                                                                                                                                                                                                                              |
|---------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Инициализация** [(doc)](https://docs.gamepush.com/docs/get-start/getting-started#sdk-initialization)              |                                                                                                                                                                                                                                                                               |
| `window.onGPInit`                                                                                                   | `init(callback)`<br> Инициализация модуля<br> callback(result): функция обратного вызова                                                                                                                                                                                      |
| **Общие возможности** [(doc)](docs.gamepush.com/docs/get-start/common-features)                                     |                                                                                                                                                                                                                                                                               |
| **Язык** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#language)                                 |                                                                                                                                                                                                                                                                               |
| `gp.language`                                                                                                       | `language()`<br> Выбранный язык в формате ISO 639-1                                                                                                                                                                                                                           |
| `gp.changeLanguage(languagecode)`                                                                                   | `changelanguage(languagecode)`<br> Устанавливает язык в формате ISO 639-1<br> languagecode: код языка                                                                                                                                                                         |
| Константы языков:                                                                                                   | `languages`<br> ENGLISH<br> RUSSIAN<br> FRENCH<br> ITALIAN<br> GERMAN<br> SPANISH<br> CHINESE<br> PORTUGUESE<br> KOREAN<br> JAPANESE                                                                                                                                          |
| **Системная информация** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#system-information)       |                                                                                                                                                                                                                                                                               |
| `gp.isDev`                                                                                                          | `is_dev()`<br> В разработке?                                                                                                                                                                                                                                                  |
| `gp.isMobile`                                                                                                       | `is_mobile()`<br> Мобильное устройство?                                                                                                                                                                                                                                       |
| `gp.isAllowedOrigin`                                                                                                | `is_allowed_origin()`<br> Хост игры в доверенных источниках?                                                                                                                                                                                                                  |
| ---                                                                                                                 | `get_plugin_version()`<br> Возвращает версию плагина                                                                                                                                                                                                                          |
| **Серверное время** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#server-time)                   |                                                                                                                                                                                                                                                                               |
| `gp.serverTime`                                                                                                     | `get_server_time()`<br> Возвращает серверное время в формате ISO 8601                                                                                                                                                                                                         |
| **Пауза** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#pause)                                   |                                                                                                                                                                                                                                                                               |
| `gp.isPaused`                                                                                                       | `is_paused()`<br> На паузе?                                                                                                                                                                                                                                                   |
| `gp.pause()`                                                                                                        | `pause()`<br> Поставить на паузу                                                                                                                                                                                                                                              |
| `gp.resume()`                                                                                                       | `resume()`<br> Возобновить                                                                                                                                                                                                                                                    |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.on('pause', () => {})`                                                                                          | `callbacks.pause()`<br> Поставили на паузу                                                                                                                                                                                                                                    |
| `gp.on('resume', () => {})`                                                                                         | `callbacks.resume()`<br> Возобновили игру                                                                                                                                                                                                                                     |
| **Фоновое изображение игры** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#set-background-image) |                                                                                                                                                                                                                                                                               |
| `gp.setBackground(parameters)`                                                                                      | `set_background(parameters)`<br> Установить фоновое изображение игры<br> parameters: таблица с параметрами                                                                                                                                                                    |
| **Старт игры** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#start-game)                         |                                                                                                                                                                                                                                                                               |
| `gp.gameStart()`                                                                                                    | `game_start()`<br> Старт игры                                                                                                                                                                                                                                                 |
| **Геймплей** [(doc)](https://docs.gamepush.com/docs/get-start/common-features#gameplay)                             |                                                                                                                                                                                                                                                                               |
| `gp.gameplayStart()`                                                                                                | `gameplay_start()`<br> Запуск геймплея                                                                                                                                                                                                                                        |
| `gp.gameplayStop()`                                                                                                 | `gameplay_stop()`<br> Завершение геймплея                                                                                                                                                                                                                                     |
| **Приложение** [(doc)](https://docs.gamepush.com/docs/get-start/application)                                        |                                                                                                                                                                                                                                                                               |
| `gp.app.title`                                                                                                      | `app.title()`<br> Название игры                                                                                                                                                                                                                                               |
| `gp.app.description`                                                                                                | `app.description()`<br> Описание                                                                                                                                                                                                                                              |
| `gp.app.image`                                                                                                      | `app.image()`<br> Изображение                                                                                                                                                                                                                                                 |
| `gp.app.url`                                                                                                        | `app.url()`<br> Адрес                                                                                                                                                                                                                                                         |
| **Платформа** [(doc)](https://docs.gamepush.com/docs/get-start/platform)                                            |                                                                                                                                                                                                                                                                               |
| `gp.platform.type`                                                                                                  | `platform.type()`<br> Тип платформы                                                                                                                                                                                                                                           |
| `gp.platform.hasIntegratedAuth`                                                                                     | `platform.has_integrated_auth()`<br> Возможность авторизации                                                                                                                                                                                                                  |
| `gp.platform.isExternalLinksAllowed`                                                                                | `platform.is_external_links_allowed()`<br> Возможность размещать внешние ссылки                                                                                                                                                                                               |
| `gp.platform.isSecretCodeAuthAvailable`                                                                             | `platform.is_secret_code_auth_available()`<br> Доступен секретный код авторизации                                                                                                                                                                                             |
| `gp.platform.getNativeSDK()`                                                                                        | `platform.call_native_sdk(method, parameters, callback)`<br> Вызывает нативный метод для платформы [подобнее](#native_sdk)<br> method: метод или поле объекта нативной платформы<br> parameters: параметры вызываемого метода<br> callback: функция обратного вызова          |
| Константы платформ:                                                                                                 | NONE<br> CRAZY_GAMES<br> GAME_DISTRIBUTION<br> GAME_MONETIZE<br> OK<br> SMARTMARKET<br> VK<br> YANDEX<br> GAMEPIX<br> POKI                                                                                                                                                    |
| **Игрок** [(doc)](https://docs.gamepush.com/docs/player)                                                            |                                                                                                                                                                                                                                                                               |
| **Менеджер игрока** [(doc)](https://docs.gamepush.com/docs/player/player-manager)                                   |                                                                                                                                                                                                                                                                               |
| `gp.player.isLoggedIn`                                                                                              | `player.is_logged_in()`<br> Игрок авторизован                                                                                                                                                                                                                                 |
| `gp.player.hasAnyCredentials`                                                                                       | `player.has_any_credentials()`<br> Игрок использует один из способов входа (кука, авторизация, секретный код)                                                                                                                                                                 |
| `gp.player.isLoggedInByPlatform`                                                                                    | `player.is_logged_in_by_platform()`<br> Игрок авторизован на платформе                                                                                                                                                                                                        |
| `gp.player.sync()`<br> `gp.player.sync({ override: true })`                                                         | `player.sync(parameters, callback)`<br> Синхронизирует игрока<br> parameters = {override = boolean или nil, silent = boolean или nil} или nil<br> callback(): функция обратного вызова или nil                                                                                |
| `gp.player.load()`                                                                                                  | `player.load(callback)`<br> Принудительная загрузка игрока, с перезаписью локального<br> callback(): функция обратного вызова или nil                                                                                                                                         |
| `gp.player.login()`                                                                                                 | `player.login(callback)`<br> Вход игрока<br> callback(result): функция обратного вызова или nil                                                                                                                                                                               |
| `gp.player.fetchFields()`                                                                                           | `player.fetch_fields(callback)`<br> Получить список полей игрока<br> callback(): функция обратного вызова или nil                                                                                                                                                             |
| **Состояние игрока** [(doc)](https://docs.gamepush.com/docs/player/player-state)                                    |                                                                                                                                                                                                                                                                               |
| `gp.player.id`                                                                                                      | `player.id()`<br> ID игрока                                                                                                                                                                                                                                                   |
| `gp.player.score`                                                                                                   | `player.score()`<br> Очки игрока                                                                                                                                                                                                                                              |
| `gp.player.name`                                                                                                    | `player.name()`<br> Имя игрока                                                                                                                                                                                                                                                |
| `gp.player.avatar`                                                                                                  | `player.avatar()`<br>  Ссылка на аватар игрока                                                                                                                                                                                                                                |
| `gp.player.isStub`                                                                                                  | `player.is_stub()`<br> Заглушка - пустой ли игрок или данные в нём отличаются умолчательных                                                                                                                                                                                   |
| `gp.player.fields`                                                                                                  | `player.fields()`<br> Поля игрока                                                                                                                                                                                                                                             |
| `gp.player.get(key)`                                                                                                | `player.get(key)`<br> Получить значение поля key<br> key = string                                                                                                                                                                                                             |
| `gp.player.set(key, value)`                                                                                         | `player.set(key, value)`<br> Установить значение поля key<br> key = string<br> value = string, number или boolean                                                                                                                                                             |
| `gp.player.add(key, value)`                                                                                         | `player.add(key, value)`<br> Добавить значение к полю key<br> key = string<br> value = string, number или boolean                                                                                                                                                             |
| `gp.player.toggle(key)`                                                                                             | `player.toggle(key)`<br> Инвертировать состояние поля key<br> key = string<br> value = string, number или boolean                                                                                                                                                             |
| `gp.player.has(key)`                                                                                                | `player.has(key)`<br> Проверить есть ли поле key и оно не пустое (не 0, '', false, null, undefined)<br> key = string                                                                                                                                                          |
| `gp.player.toJSON()`                                                                                                | `player.to_json()`<br> Возвращает состояние игрока объектом (таблицей)                                                                                                                                                                                                        |
| `gp.player.fromJSON()`                                                                                              | `player.from_json(player)`<br> Устанавливает состояние игрока из объекта (таблицы)<br> player = {key = value, key2 = value2}                                                                                                                                                  |
| `gp.player.reset()`                                                                                                 | `player.reset()`<br> Сбрасывает состояние игрока на умолчательное                                                                                                                                                                                                             |
| `gp.player.remove()`                                                                                                | `player.remove()`<br> Удаляет игрока — сбрасывает поля и очищает ID                                                                                                                                                                                                           |
| `gp.player.getField(key)`                                                                                           | `player.get_field(key)`<br> Получить поле по ключу key<br> key = string                                                                                                                                                                                                       |
| `gp.player.getFieldName(key)`                                                                                       | `player.get_field_name(key)`<br> Получить переведенное имя поля по ключу key<br> key = string                                                                                                                                                                                 |
| `gp.player.getFieldVariantName(key, value)`                                                                         | `player.get_field_variant_name(key, value)`<br> Получить переведенное имя варианта поля (enum) по ключу key и его значению value<br> key = string<br> value = string                                                                                                          |
| **Данные игрока** [(doc)](https://docs.gamepush.com/docs/player/players-data)                                       |                                                                                                                                                                                                                                                                               |
| `gp.players.fetch(parameters)`                                                                                      | `players.fetch(parameters, callback)`<br> Получить данные игроков<br> parameters = таблица с идентификаторами игроков<br> callback(result): функция обратного вызова                                                                                                          |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.player.on('sync', (success) => {})`                                                                             | `player.callbacks.sync(success)`<br> Синхронизация игрока                                                                                                                                                                                                                     |
| `gp.player.on('load', (success) => {})`                                                                             | `player.callbacks.load(success)`<br> Загрузка игрока                                                                                                                                                                                                                          |
| `gp.player.on('login', (success) => {})`                                                                            | `player.callbacks.login(success)`<br> Вход игрока                                                                                                                                                                                                                             |
| `gp.player.on('fetchFields', (success) => {})`                                                                      | `player.callbacks.fetch_fields(success)`<br> Получение полей игрока                                                                                                                                                                                                           |
| `gp.player.on('change', () => {})`                                                                                  | `player.callbacks.change()`<br> Изменение полей игрока                                                                                                                                                                                                                        |
| **Покупки** [(doc)](https://docs.gamepush.com/docs/purchases)                                                       |                                                                                                                                                                                                                                                                               |
| **Платежи** [(doc)](https://docs.gamepush.com/docs/purchases/payments)                                              |                                                                                                                                                                                                                                                                               |
| `gp.payments.isAvailable`                                                                                           | `payments.is_available()`<br> Проверка поддержки платежей на платформе                                                                                                                                                                                                        |
| `gp.payments.purchase(product)`                                                                                     | `payments.purchase(product, callback)`<br> Покупка продукта<br> product = number или string, id или tag продукта<br> callback(result): функция обратного вызова или nil                                                                                                       |
| `gp.payments.consume(product)`                                                                                      | `payments.consume(product, callback)`<br> Использование продукта<br> product = number или string, id или tag продукта<br> callback(result): функция обратного вызова или nil                                                                                                  |
| `gp.payments.has(product)`                                                                                          | `payments.has(product)`<br> Проверка наличия покупки<br> product: id или tag продукта                                                                                                                                                                                         |
| `gp.payments.fetchProducts()`                                                                                       | `payments.fetch_products(callback)`<br> Получение списка продуктов<br> callback(result): функция обратного вызова                                                                                                                                                             |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.payments.on('purchase', (result) => {})`                                                                        | `payments.callbacks.purchase(result)`<br> Покупка продукта                                                                                                                                                                                                                    |
| `gp.payments.on('error:purchase', (error) => {})`                                                                   | `payments.callbacks.purchase_error(error)`<br> Ошибка покупки продукта                                                                                                                                                                                                        |
| `gp.payments.on('consume', (result) => {})`                                                                         | `payments.callbacks.consume(result)`<br> Использование продукта                                                                                                                                                                                                               |
| `gp.payments.on('error:consume', (error) => {})`                                                                    | `payments.callbacks.consume_error(error)`<br> Ошибка использования продукта                                                                                                                                                                                                   |
| `gp.payments.on('fetchProducts', (result) => {})`                                                                   | `payments.callbacks.fetch_products(result)`<br> Получение списка продуктов                                                                                                                                                                                                    |
| `gp.payments.on('error:fetchProducts', (error) => {})`                                                              | `payments.callbacks.fetch_products_error(error)`<br> Ошибка получения списка продуктов                                                                                                                                                                                        |
| **Подписки** [(doc)](https://docs.gamepush.com/docs/purchases/subscriptions)                                        |                                                                                                                                                                                                                                                                               |
| `gp.payments.isSubscriptionsAvailable`                                                                              | `payments.is_subscriptions_available()`<br> Проверка поддержки подписки на платформе                                                                                                                                                                                          |
| `gp.payments.subscribe(product)`                                                                                    | `payments.subscribe(product, callback)`<br> Подписка<br> product = number или string, id или tag продукта<br> callback(result): функция обратного вызова или nil                                                                                                              |
| `gp.payments.unsubscribe(product)`                                                                                  | `payments.unsubscribe(product, callback)`<br> Отмена подписки<br> product = number или string, id или tag продукта<br> callback(result): функция обратного вызова или nil                                                                                                     |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.payments.on('subscribe', (result) => {})`                                                                       | `payments.callbacks.subscribe(result)`<br> Подписка                                                                                                                                                                                                                           |
| `gp.payments.on('error:subscribe', (error) => {})`                                                                  | `payments.callbacks.subscribe_error(error)`<br> Ошибка подписки                                                                                                                                                                                                               |
| `gp.payments.on('unsubscribe', (result) => {})`                                                                     | `payments.callbacks.unsubscribe(result)`<br> Отмена подписки                                                                                                                                                                                                                  |
| `gp.payments.on('error:unsubscribe', (error) => {})`                                                                | `payments.callbacks.unsubscribe_error(error)`<br> Ошибка отмены подписки                                                                                                                                                                                                      |
| **Таблицы лидеров** [(doc)](https://docs.gamepush.com/docs/leaderboards)                                            |                                                                                                                                                                                                                                                                               |
| **Таблица лидеров** [(doc)](https://docs.gamepush.com/docs/leaderboards/leaderboard)                                |                                                                                                                                                                                                                                                                               |
| `gp.leaderboard.open()`<br> `gp.leaderboard.open(parameters)`                                                       | `leaderboard.open(parameters)`<br> Показать таблицу лидеров во внутриигровом оверлее, parameters таблица параметров вывода или nil                                                                                                                                            |
| `gp.leaderboard.fetch()`<br> `gp.leaderboard.fetch(parameters)`                                                     | `leaderboard.fetch(parameters, callback)`<br> Получить таблицу лидеров<br> parameters: таблица параметров вывода или nil<br> callback(leaders): функция обратного вызова                                                                                                      |
| **Рейтинг игрока** [(doc)](https://docs.gamepush.com/docs/leaderboards/player-rating)                               |                                                                                                                                                                                                                                                                               |
| `gp.leaderboard.fetchPlayerRating()`<br> `gp.leaderboard.fetchPlayerRating(parameters)`                             | `leaderboard.fetch_player_rating(parameters, callback)`<br> Получить рейтинг игрока<br> parameters: таблица параметров вывода или nil<br> callback(leaders): функция обратного вызова                                                                                         |
| **Изолированная таблица лидеров** [(doc)](https://docs.gamepush.com/docs/leaderboards/scoped-leaderboard)           |                                                                                                                                                                                                                                                                               |
| `gp.leaderboard.openScoped(parameters)`                                                                             | `leaderboard.open_scoped(parameters, callback)`<br> Показать изолированную таблицу лидеров во внутриигровом оверлее, parameters таблица параметров вывода или nil<br> callback(result): функция обратного вызова                                                              |
| `gp.leaderboard.fetchScoped(parameters)`                                                                            | `leaderboard.fetch_scoped(parameters, callback)`<br> Получить изолированную таблицу лидеров<br> parameters: таблица параметров вывода или nil<br> callback(leaders): функция обратного вызова                                                                                 |
| `gp.leaderboard.publishRecord(parameters)`                                                                          | `leaderboard.publish_record(parameters, callback)`<br> Публикация рекорда игрока в изолированную таблицу<br> parameters: таблица с параметрами и рекордом для записи<br> callback(result): функция обратного вызова                                                           |
| **Получение рейтинга игрока** [(doc)](https://docs.gamepush.com/docs/leaderboards/player-scoped-rating)             |                                                                                                                                                                                                                                                                               |
| `gp.leaderboard.fetchPlayerRatingScoped(parameters)`                                                                | `leaderboard.fetch_player_rating_scoped(parameters, callback)`<br> Получить рейтинг игрока в изолированной таблице<br> parameters: таблица параметров вывода<br> callback(leaders): функция обратного вызова                                                                  |
| **Реклама** [(doc)](https://docs.gamepush.com/docs/advertising)                                                     |                                                                                                                                                                                                                                                                               |
| `gp.ads.isAdblockEnabled`                                                                                           | `ads.is_adblock_enabled()`<br> Проверка включенного AdBlock                                                                                                                                                                                                                   |
| `gp.ads.isStickyAvailable`                                                                                          | `ads.is_sticky_available()`<br> Проверка доступности баннера                                                                                                                                                                                                                  |
| `gp.ads.isFullscreenAvailable`                                                                                      | `ads.is_fullscreen_available()`<br> Проверка доступности полноэкранной рекламы                                                                                                                                                                                                |
| `gp.ads.isRewardedAvailable`                                                                                        | `ads.is_rewarded_available()`<br> Проверка доступности рекламы за вознаграждение                                                                                                                                                                                              |
| `gp.ads.isPreloaderAvailable`                                                                                       | `ads.is_preloader_available()`<br> Проверка доступности preload рекламы                                                                                                                                                                                                       |
| `gp.ads.isStickyPlaying`                                                                                            | `ads.is_sticky_playing()`<br> Проверка воспроизведения баннера                                                                                                                                                                                                                |
| `gp.ads.isFullscreenPlaying`                                                                                        | `ads.is_fullscreen_playing()`<br> Проверка воспроизведения полноэкранной рекламы                                                                                                                                                                                              |
| `gp.ads.isRewardedPlaying`                                                                                          | `ads.is_rewarded_playing()`<br> Проверка воспроизведения рекламы за вознаграждение                                                                                                                                                                                            |
| `gp.ads.isPreloaderPlaying`                                                                                         | `ads.is_preloader_playing()`<br> Проверка воспроизведения preload рекламы                                                                                                                                                                                                     |
| `gp.ads.showFullscreen()`                                                                                           | `ads.show_fullscreen(callback)`<br> Показывает полноэкранную рекламу<br> callback(result) функция обратного вызова или nil                                                                                                                                                    |
| `gp.ads.showPreloader()`                                                                                            | `ads.show_preloader(callback)`<br> Показывает баннерную рекламу (preloader)<br> callback(result) функция обратного вызова или nil                                                                                                                                             |
| `gp.ads.showRewardedVideo()`                                                                                        | `ads.show_rewarded_video(callback)`<br> Показывает рекламу за вознаграждение<br> callback(result) функция обратного вызова или nil                                                                                                                                            |
| `gp.ads.showSticky()`                                                                                               | `ads.show_sticky(callback)`<br> Показывает баннер<br> callback(result) функция обратного вызова или nil                                                                                                                                                                       |
| `gp.ads.refreshSticky()`                                                                                            | `ads.refresh_sticky(callback)`<br> Принудительное обновление баннера<br> callback(result) функция обратного вызова или nil                                                                                                                                                    |
| `gp.ads.closeSticky()`                                                                                              | `ads.close_sticky(callback)`<br> Закрывает баннер<br> callback() функция обратного вызова или nil                                                                                                                                                                             |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.ads.on('start', () => {})`                                                                                      | `ads.callbacks.start()`<br> Показ рекламы                                                                                                                                                                                                                                     |
| `gp.ads.on('close', (success) => {})`                                                                               | `ads.callbacks.close(success)`<br> Закрытие рекламы                                                                                                                                                                                                                           |
| `gp.ads.on('fullscreen:start', () => {})`                                                                           | `ads.callbacks.fullscreen_start()`<br> Показ полноэкранной рекламы                                                                                                                                                                                                            |
| `gp.ads.on('fullscreen:close', (success) => {})`                                                                    | `ads.callbacks.fullscreen_close(success)`<br> Закрытие полноэкранной рекламы                                                                                                                                                                                                  |
| `gp.ads.on('preloader:start', () => {})`                                                                            | `ads.callbacks.preloader_start()`<br> Показ preloader рекламы                                                                                                                                                                                                                 |
| `gp.ads.on('preloader:close', (success) => {})`                                                                     | `ads.callbacks.preloader_close(success)`<br> Закрытие preloader рекламы                                                                                                                                                                                                       |
| `gp.ads.on('rewarded:start', () => {})`                                                                             | `ads.callbacks.rewarded_start()`<br> Показ рекламы за вознаграждение                                                                                                                                                                                                          |
| `gp.ads.on('rewarded:close', (success) => {})`                                                                      | `ads.callbacks.rewarded_close(success)`<br> Закрытие рекламы за вознаграждение                                                                                                                                                                                                |
| `gp.ads.on('rewarded:reward', () => {})`                                                                            | `ads.callbacks.rewarded_reward()`<br> Получение награды за просмотр рекламы                                                                                                                                                                                                   |
| `gp.ads.on('sticky:start', () => {})`                                                                               | `ads.callbacks.sticky_start()`<br> Показ sticky баннера                                                                                                                                                                                                                       |
| `gp.ads.on('sticky:render', () => {})`                                                                              | `ads.callbacks.sticky_render()`<br> Рендер sticky баннера                                                                                                                                                                                                                     |
| `gp.ads.on('sticky:refresh', () => {})`                                                                             | `ads.callbacks.sticky_refresh()`<br> Обновление sticky баннера                                                                                                                                                                                                                |
| `gp.ads.on('sticky:close', () => {})`                                                                               | `ads.callbacks.sticky_close()`<br> Закрытие sticky баннера                                                                                                                                                                                                                    |
| **Достижения** [(doc)](https://docs.gamepush.com/docs/achievements)                                                 |                                                                                                                                                                                                                                                                               |
| `gp.achievements.unlock(achievement)`                                                                               | `achievements.unlock(achievement, callback)`<br> Разблокировать достижение<br> achievement: id или tag достижения<br> callback(result): функция обратного вызова                                                                                                              |
| `gp.achievements.open()`                                                                                            | `achievements.open(callback)`<br> Открыть достижения в оверлее<br> callback: функция обратного вызова при открытии окна достижений                                                                                                                                            |
| `gp.achievements.fetch()`                                                                                           | `achievements.fetch(callback)`<br> Запросить достижения<br> callback(achievements): функция обратного вызова                                                                                                                                                                  |
| Константы редкости достижений:                                                                                      | `achievements.rare`<br> COMMON<br> UNCOMMON<br> RARE<br> EPIC<br> LEGENDARY<br> MYTHIC                                                                                                                                                                                        |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.achievements.on('unlock', (achievement) => {})`                                                                 | `achievements.callbacks.unlock(achievement)`<br> Разблокировка достижения                                                                                                                                                                                                     |
| `gp.achievements.on('error:unlock', (error) => {})`                                                                 | `achievements.callbacks.unlock_error(error)`<br> Ошибка разблокировки достижения                                                                                                                                                                                              |
| `gp.achievements.on('open', () => {})`                                                                              | `achievements.callbacks.open()`<br> Открытие списка достижений в оверлее                                                                                                                                                                                                      |
| `gp.achievements.on('close', () => {})`                                                                             | `achievements.callbacks.close()`<br> Закрытие списка достижений                                                                                                                                                                                                               |
| `gp.achievements.on('fetch', (result) => {})`                                                                       | `achievements.callbacks.fetch(result)`<br> Получение списка достижений                                                                                                                                                                                                        |
| `gp.achievements.on('error:fetch', (error) => {})`                                                                  | `achievements.callbacks.fetch_error(error)`<br> Ошибка получения списка достижений                                                                                                                                                                                            |
| **Социальные действия** [(doc)](https://docs.gamepush.com/docs/social-actions)                                      |                                                                                                                                                                                                                                                                               |
| `gp.socials.isSupportsShare`                                                                                        | `socials.is_supports_share()`<br> Поддерживается ли шаринг                                                                                                                                                                                                                    |
| `gp.socials.isSupportsNativeShare`                                                                                  | `socials.is_supports_native_share()`<br> Проверка поддержки нативного шаринга                                                                                                                                                                                                 |
| `gp.socials.share(parameters)`                                                                                      | `socials.share(parameters)`<br> Поделиться<br> parameters: таблица с параметрами или nil                                                                                                                                                                                      |
| `gp.socials.isSupportsNativePosts`                                                                                  | `socials.is_supports_native_posts()`<br> Поддерживается ли нативный постинг                                                                                                                                                                                                   |
| `gp.socials.post(parameters)`                                                                                       | `socials.post(parameters)`<br> Опубликовать пост<br> parameters: таблица с параметрами или nil                                                                                                                                                                                |
| `gp.socials.isSupportsNativeInvite`                                                                                 | `socials.is_supports_native_invite()`<br> Проверка поддержки нативных инвайтов                                                                                                                                                                                                |
| `gp.socials.invite(parameters)`                                                                                     | `socials.invite(parameters)`<br> Пригласить друзей<br> parameters: таблица с параметрами или nil                                                                                                                                                                              |
| `gp.socials.canJoinCommunity`                                                                                       | `socials.can_join_community()`<br> Можно ли приглашать в сообщество на текущей платформе                                                                                                                                                                                      |
| `gp.socials.isSupportsNativeCommunityJoin`                                                                          | `socials.is_supports_native_community_join()`<br> Поддерживается ли нативное вступление в сообщество                                                                                                                                                                          |
| `gp.socials.joinCommunity()`                                                                                        | `socials.join_community()`<br> Вступить в сообщество                                                                                                                                                                                                                          |
| **Игровые переменные** [(doc)](https://docs.gamepush.com/docs/game-variables)                                       |                                                                                                                                                                                                                                                                               |
| `gp.variables.fetch()`                                                                                              | `variables.fetch(callback)`<br> Запросить переменные<br> callback(): функция обратного вызова или nil                                                                                                                                                                         |
| `gp.variables.get(variable)`                                                                                        | `variables.get(variable)`<br> Получить значение переменной<br> variable: название запрашиваемой переменной                                                                                                                                                                    |
| `gp.variables.has(variable)`                                                                                        | `variables.has(variable)`<br> Проверить существование переменной<br> variable: название переменной                                                                                                                                                                            |
| `gp.variables.type(variable)`                                                                                       | `variables.type(variable)`<br> Получить тип переменной<br> variable: название переменной                                                                                                                                                                                      |
| Константы типов переменной:                                                                                         | `variables.types`<br> DATA<br> STATS<br> FLAG<br> DOC_HTML<br> IMAGE<br> FILE                                                                                                                                                                                                 |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.variables.on('fetch', () => {})`                                                                                | `variables.callbacks.fetch()`<br> Получение переменных                                                                                                                                                                                                                        |
| `gp.variables.on('error:fetch', (error) => {})`                                                                     | `variables.callbacks.fetch_error(error)`<br> Ошибка получения переменных                                                                                                                                                                                                      |
| **Подборки игр** [(doc)](https://docs.gamepush.com/docs/games-collections)                                          |                                                                                                                                                                                                                                                                               |
| `gp.gamesCollections.open(collection)`                                                                              | `games_collections.open(collection, callback)`<br> Открыть оверлей с играми<br> collection = number или string, id или tag коллекции или nil<br> callback(): Функция обратного вызова или nil                                                                                 |
| `gp.gamesCollections.fetch(collection)`                                                                             | `games_collections.fetch(collection, callback)`<br> Получить коллекцию игр<br> collection = number или string, id или tag коллекции или nil<br> callback(result): Функция обратного вызова или nil                                                                            |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.gamesCollections.on('open', () => {})`                                                                          | `games_collections.callbacks.open()`<br> Открыт оверлей с играми                                                                                                                                                                                                              |
| `gp.gamesCollections.on('close', () => {})`                                                                         | `games_collections.callbacks.close()`<br> Закрыт оверлей с играми                                                                                                                                                                                                             |
| `gp.gamesCollections.on('fetch', (result) => {})`                                                                   | `games_collections.callbacks.fetch(result)`<br> Получение коллекции игр                                                                                                                                                                                                       |
| `gp.gamesCollections.on('error:fetch', (error) => {})`                                                              | `games_collections.callbacks.fetch_error(error)`<br> Ошибка получения коллекции игр                                                                                                                                                                                           |
| **Изображения** [(doc)](https://docs.gamepush.com/docs/images)                                                      |                                                                                                                                                                                                                                                                               |
| `gp.images.upload(parameters)`                                                                                      | `images.upload(parameters, callback)`<br> Загрузить изображение<br> parameters: таблица с параметрами<br> callback(image): функция обратного вызова или nil                                                                                                                   |
| `gp.images.uploadUrl(parameters)`                                                                                   | `images.upload_url(parameters, callback)`<br> Загрузить изображение по URL<br> parameters: таблица с параметрами<br> callback(image): функция обратного вызова или nil                                                                                                        |
| `gp.images.chooseFile()`                                                                                            | `images.choice_file(callback)`<br> Выбрать файл<br> callback(image): функция обратного вызова или nil                                                                                                                                                                         |
| `gp.images.fetch(parameters)`                                                                                       | `images.fetch(parameters, callback)`<br> Получить изображения<<br> parameters: таблица с параметрами<br> callback(image): функция обратного вызова или nil                                                                                                                    |
| `gp.images.fetchMore(parameters)`                                                                                   | `images.fetch_more(parameters, callback)`<br> Получить еще изображений<<br> parameters: таблица с параметрами<br> callback(image): функция обратного вызова или nil                                                                                                           |
| `gp.images.resize(url, width, height, crop)`                                                                        | `images.resize(uri, width, height, crop)`<br> Изменить размер изображения<<br> uri: адрес изображения<br> width: требуемая ширина изображения<br> height: требуемая высота изображения<br> crop: обрезка изображения<br> Функция возвращает ссылку на обрезанное изображение. |
| `gp.images.canUpload()`                                                                                             | `images.can_upload()`<br> Проверяет, можно ли загружать изображения                                                                                                                                                                                                           |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.images.on('upload', (image) => {})`                                                                             | `images.callbacks.upload(image)`<br> Загрузка изображения                                                                                                                                                                                                                     |
| `gp.images.on('error:upload', (error) => {})`                                                                       | `images.callbacks.upload_error(error)`<br> Ошибка загрузки изображения                                                                                                                                                                                                        |
| `gp.images.on('choose', (result) => {})`                                                                            | `images.callbacks.choose(result)`<br> Выбор изображения                                                                                                                                                                                                                       |
| `gp.images.on('error:choose', (error) => {})`                                                                       | `images.callbacks.choose_error(error)`<br> Ошибка выбора изображения                                                                                                                                                                                                          |
| `gp.images.on('fetch', (result) => {})`                                                                             | `images.callbacks.fetch(result)`<br> Получение изображения                                                                                                                                                                                                                    |
| `gp.images.on('error:fetch', (error) => {})`                                                                        | `images.callbacks.fetch_error(error)`<br> Ошибка получения изображения                                                                                                                                                                                                        |
| `gp.images.on('fetchMore', (result) => {})`                                                                         | `images.callbacks.fetch_more(result)`<br> Получение следующей партии изображений                                                                                                                                                                                              |
| `gp.images.on('error:fetchMore', (error) => {})`                                                                    | `images.callbacks.fetch_more_error(error)`<br> Ошибка получения следующей партии изображении                                                                                                                                                                                  |
| **Файлы** [(doc)](https://docs.gamepush.com/docs/files)                                                             |                                                                                                                                                                                                                                                                               |
| `gp.files.upload(parameters)`                                                                                       | `files.upload(parameters, callback)`<br> Загрузить файл<br> parameters: таблица с параметрами<br> callback(result): функция обратного вызова или nil                                                                                                                          |
| `gp.files.uploadUrl(parameters)`                                                                                    | `files.upload_url(parameters, callback)`<br> Загрузить файл по URL<br> parameters: таблица с параметрами<br> callback(result): функция обратного вызова или nil                                                                                                               |
| `gp.files.uploadContent(parameters)`                                                                                | `files.upload_content(parameters, callback)`<br> Загрузить контент<br> parameters: таблица с параметрами<br> callback(result): функция обратного вызова или nil                                                                                                               |
| `gp.files.loadContent(url)`                                                                                         | `files.load_content(url, callback)`<br> Получить контент<br> url: адрес файла<br> callback(result): функция обратного вызова или nil                                                                                                                                          |
| `gp.files.chooseFile(accept)`                                                                                       | `files.choose_file(accept, callback)`<br> Выбрать файл<br> accept: тип файла<br> callback(result): функция обратного вызова или nil                                                                                                                                           |
| `gp.files.fetch(parameters)`                                                                                        | `files.fetch(parameters, callback)`<br> Получить файлы<br> parameters: таблица с параметрами<br> callback(result): функция обратного вызова или nil                                                                                                                           |
| `gp.files.fetchMore(parameters)`                                                                                    | `files.fetch_more(parameters, callback)`<br> Получить файлы<br> parameters: таблица с параметрами<br> callback(result): функция обратного вызова или nil                                                                                                                      |
| `gp.files.canUpload()`                                                                                              | `files.can_upload()`<br> Проверяет, можно ли загружать файлы                                                                                                                                                                                                                  |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.files.on('upload', (result) => {})`                                                                             | `files.callbacks.upload(result)`<br> Загрузка файла                                                                                                                                                                                                                           |
| `gp.files.on('error:upload', (error) => {})`                                                                        | `files.callbacks.upload_error(result)`<br> Ошибка загрузки файла                                                                                                                                                                                                              |
| `gp.files.on('loadContent', (result) => {})`                                                                        | `files.callbacks.load_content(result)`<br> Контент получен                                                                                                                                                                                                                    |
| `gp.files.on('error:loadContent', (error) => {})`                                                                   | `files.callbacks.load_content_error(result)`<br> Ошибка получения контента                                                                                                                                                                                                    |
| `gp.files.on('choose', (result) => {})`                                                                             | `files.callbacks.choose(result)`<br> Файл выбран                                                                                                                                                                                                                              |
| `gp.files.on('error:choose', (error) => {})`                                                                        | `files.callbacks.choose_error(result)`<br> Ошибка выбора файла                                                                                                                                                                                                                |
| `gp.files.on('fetch', (result) => {})`                                                                              | `files.callbacks.fetch(result)`<br> Успешное получение файлов                                                                                                                                                                                                                 |
| `gp.files.on('error:fetch', (error) => {})`                                                                         | `files.callbacks.fetch_error(result)`<br> Ошибка при получении файлов                                                                                                                                                                                                         |
| `gp.files.on('fetchMore', (result) => {})`                                                                          | `files.callbacks.fetch_more(result)`<br> Успешная подгрузка файлов                                                                                                                                                                                                            |
| `gp.files.on('error:fetchMore', (error) => {})`                                                                     | `files.callbacks.fetch_more_error(result)`<br> Ошибка при подгрузке файлов                                                                                                                                                                                                    |
| **Документы** [(doc)](https://docs.gamepush.com/docs/documents)                                                     |                                                                                                                                                                                                                                                                               |
| `gp.documents.open(parameters)`                                                                                     | `documents.open(parameters)`<br> Открыть политику конфиденциальности<br> parameters: таблица с параметрами                                                                                                                                                                    |
| `gp.documents.fetch(parameters)`                                                                                    | `documents.fetch(parameters, callback)`<br> Получить политику конфиденциальности<br> parameters: таблица с параметрами<br> callback(result): функция обратного вызова или nil                                                                                                 |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.documents.on('open', () => {})`                                                                                 | `documents.callbacks.open()`<br> Открыта политика конфиденциальности                                                                                                                                                                                                          |
| `gp.documents.on('close', () => {})`                                                                                | `documents.callbacks.close()`<br> Закрыта политика конфиденциальности                                                                                                                                                                                                         |
| `gp.documents.on('fetch', (document) => {})`                                                                        | `documents.callbacks.fetch(document)`<br> Получение политики конфиденциальности                                                                                                                                                                                               |
| `gp.documents.on('error:fetch', (error) => {})`                                                                     | `documents.callbacks.fetch_error(error)`<br> Ошибка получения политики конфиденциальности                                                                                                                                                                                     |
| **Аналитика** [(doc)](https://docs.gamepush.com/docs/analytics)                                                     |                                                                                                                                                                                                                                                                               |
| `gp.analytics.hit(url)`                                                                                             | `analytics.hit(url)`<br> Посещение или просмотр страницы                                                                                                                                                                                                                      |
| `gp.analytics.goal(event, value)`                                                                                   | `analytics.goal(event, value)`<br> Отправка достижения цели                                                                                                                                                                                                                   |
| **Полный экран** [(doc)](https://docs.gamepush.com/docs/fullscreen)                                                 |                                                                                                                                                                                                                                                                               |
| `gp.fullscreen.open()`                                                                                              | `fullscreen.open()`<br> Войти в полноэкранный режим                                                                                                                                                                                                                           |
| `gp.fullscreen.close()`                                                                                             | `fullscreen.close()`<br> Выйти из полноэкранного режима                                                                                                                                                                                                                       |
| `gp.fullscreen.toggle()`                                                                                            | `fullscreen.toggle()`<br> Переключить полноэкранный режим                                                                                                                                                                                                                     |
| События:                                                                                                            |                                                                                                                                                                                                                                                                               |
| `gp.fullscreen.on('open', () => {})`                                                                                | `fullscreen.callbacks.open()`<br> Вход в полноэкранный режим                                                                                                                                                                                                                  |
| `gp.fullscreen.on('close', () => {})`                                                                               | `fullscreen.callbacks.close()`<br> Выход из полноэкранного режима                                                                                                                                                                                                             |
| `gp.fullscreen.on('change', () => {})`                                                                              | `fullscreen.callbacks.change()`<br> Переключение полноэкранного режима                                                                                                                                                                                                        |

<a name="native-sdk"></a>

## Вызов нативных методов платформы

Для вызова нативного метода, получения объекта или поля предназначена
функция `call_native_sdk(method, parameters, callback)`.

- method: строка, путь до метода, объекта или поля разделенного точками. Если указан путь до объекта или поля объекта,
  то parameters и callback будет проигнорирован.
- parameters: параметр вызываемого метода (string, number, boolean, table). Если необходимо передать несколько
  параметров, то параметры необходимо поместить в массив (таблицу). Порядок параметров определяется индексом
  массива.  **Не поддерживается передача функций в качестве параметров!**
- callback: функция обратного вызова, необходимо указывать, если нативный метод возвращает промис. Если callback == nil,
  то функция возвращает результат, иначе nil.

**Результат возвращаемый функцией формируется по правилам:**

1. Параметр method ссылается на объект или поле объекта:

- Если результат string, number, boolean или объект, то возвращаются полученные данные.
- В случае если произошло исключение, то данные об ошибке возвращаются в виде таблицы {error = "error description"}.

2. Параметр method ссылается на функцию:

- Если результат string, number, boolean или объект, то возвращаются полученные данные.
- В случае если произошло исключение, или промис завершился ошибкой, то данные об ошибке возвращаются в виде таблицы
  {error = "error description"}.

callback(result): result - результат выполнения промиса, если промис завершился ошибкой, то result = {error = "error
description"}.

### Расширенные действия с промисами

Бывают ситуации, когда промис возвращает объект с функциями, которые может потребоваться выполнить позже. Для этих
ситуаций предусмотрен механизм сохранения объекта на уровне JS и дальнейшего его использования при следующих вызовах
API.

В этих случаях формат параметра `method` для функции `call_native_sdk` может принимать вид:

- `var=path1.path2.path3`: объект path1.path2.path3 будет сохранен в переменную var
- `var:method`: вызов метода из ранее сохраненного объекта
- `var2=var:method2`: вызов метода (необходимо что-бы он был промисом) из ранее сохраненного объекта и сохранение
  результата в переменной var2

### Примеры различных вариантов вызова

| Запрос к СДК                     | Тип       | Вызов функции и результат                                                                                                                                                                                                                                             |
|----------------------------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| environment                      | object    | call_native_sdk("environment")<br> table                                                                                                                                                                                                                              |
| environment.i18n.lang            | string    | call_native_sdk("environment.i18n.lang")<br> string                                                                                                                                                                                                                   |
| env                              | undefined | call_native_sdk("env")<br> {error = 'Field or function "env" not found!'}                                                                                                                                                                                             |
| player.getUniqueID()             | function  | call_native_sdk("player.getUniqueID")<br> string                                                                                                                                                                                                                      |
| feedback.canReview()             | function  | call_native_sdk("feedback.canReview", nil, callback)<br> nil<br> После завершения промиса будет вызван callback.                                                                                                                                                      |
| getLeaderboards().then(lb => {}) | function  | call_native_sdk("lb=getLeaderboards", nil, callback)<br> nil<br> После завершения промиса будет вызван callback.<br> Результат будет сохранен в переменной JS.                                                                                                        |
| lb.setLeaderboardScore()         | function  | call_native_sdk("lb:setLeaderboardScore")<br> После завершения промиса будет вызван callback.<br> При вызове функции будет обращение к ранее сохраненной переменной JS, если она не найдена функция вернет {error = "The 'lb' object has not been previously saved!"} |

### Пример нативной работы с платформой Yandex:

```lua
local gamepush = require("gamepush.gamepush")

gamepush.init(function(result)
    if result then
        -- Получить переменные окружения Яндекса, эквивалент ysdk.environment
        local environment = gamepush.platform.call_native_sdk("environment")

        -- Получить язык интерфейса Яндекс.Игр в формате ISO 639-1, эквивалент ysdk.environment.i18n.lang
        local language = gamepush.platform.call_native_sdk("environment.i18n.lang")

        -- Получить таблицы лидеров, эквивалент ysdk.getLeaderboards()
        -- промис возвращает объект, сохраним его в переменную lb
        gamepush.platform.call_native_sdk("lb=getLeaderboards", nil, function(leaderboards)
            pprint(leaderboards)
            -- Запись нового рекорда, эквивалент lb.setLeaderboardScore('leaderboard2021', 120);
            -- будем обращаться к переменной lb
            gamepush.platform.call_native_sdk("lb:setLeaderboardScore", { "leaderboard2021", 120 })
            -- Получить данные таблицы лидеров, эквивалент lb.getLeaderboardEntries('leaderboard2021')
            gamepush.platform.call_native_sdk("lb:getLeaderboardEntries", "leaderboard2021", nil, function(result)
                pprint(result)
            end)

            -- Получить данные таблицы лидеров с параметрами
            -- эквивалент lb.getLeaderboardEntries('leaderboard2021', {quantityTop: 10, includeUser: true, quantityAround: 3})
            local parameters = {
                "leaderboard2021",
                { quantityTop = 10, includeUser = true, quantityAround = 3 }
            }
            gamepush.platform.call_native_sdk("lb:getLeaderboardEntries", parameters, function(result)
                pprint(result)
            end)
        end)
    end
end)
```

Представленный выше код эквивалентен коду JS:

```js
YaGames
    .init()
    .then(ysdk => {
        // Получить переменные окружения Яндекса
        let environment = ysdk.environment;

        // Получить язык интерфейса Яндекс.Игр в формате ISO 639-1
        let language = ysdk.environment.i18n.lang;

        // Получить таблицы лидеров
        ysdk.getLeaderboards().then(function (lb) {
            console.log(lb);
            // Запись нового рекорда
            lb.setLeaderboardScore('leaderboard2021', 120);
            // Получить данные таблицы лидеров
            lb.getLeaderboardEntries('leaderboard2021').then(function (result) {
                console.log(result);
            });

            // Получить данные таблицы лидеров с параметрами
            let parameters = {quantityTop: 10, includeUser: true, quantityAround: 3};
            lb.getLeaderboardEntries('leaderboard2021', parameters).then(function (result) {
                console.log(result);
            });
        });
    });
```

<a name="mock"></a>

## Заглушка для других платформ, отличных от html

Для платформ отличных от html предусмотрены заглушки для удобства отладки.

При использовании функций:

- player.get(key)
- player.set(key, value)
- player.add(key, value)
- player.toggle(key)
- player.has(key)
- player.to_json()
- player.from_json(player)

данные будут сохраняться/считываться с помощью sys.save()/sys.load() локально в/из файла "gamepush.dat" (можно
поменять)

```lua
local mock_api = require("gamepush.mock_api")

-- установим имя для файла локального хранилища данных
mock_api.file_storage = "my_storage.dat"

-- установка параметров "заглушек"
mock_api["player.name"] = "my player name"
mock_api["player.id"] = 625
mock_api["player.score"] = 500
```

Каждая функция-заглушка GamePush API может быть представлена данными или функцией выполняющее действие и/или
возвращающая данные. Любые функции/данные можно переопределять для удобства работы/отладки.

<a name="mock-native"></a>

## Заглушка для нативных вызовов

Заглушки для нативных вызовов выделены в отдельный модуль, чтобы его подключить используйте функцию `set_native_api`

```lua
--native_api.lua
local M = {}

M["environment"] = {
    app = {
        id = "app_id"
    },
    browser = {
        lang = "ru"
    },
    i18n = {
        lang = "ru",
        tld = "ru"
    }
}

return M
```

```lua
local mock = require("gamepush.mock")
local native_api = require("native_api")
local gamepush = require("gamepush.gamepush")

-- Устанавливаем заглушку для нативных функций
mock.set_native_api(native_api)
-- Обращаемся к нативной функции
local result = gamepush.platform.call_native_sdk("environment")
pprint(result)
```
