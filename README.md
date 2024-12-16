# Добро пожаловать в репозиторий Bandastation по игре Space Station 13

[![Build Status](https://github.com/ss220club/Bandastation/workflows/CI%20Suite/badge.svg)](https://github.com/ss220club/Bandastation/actions?query=workflow%3A%22CI+Suite%22)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/ss220club/Bandastation.svg)](https://isitmaintained.com/project/ss220club/Bandastation "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/ss220club/Bandastation.svg)](https://isitmaintained.com/project/ss220club/Bandastation "Average time to resolve an issue")
![Coverage](https://img.shields.io/badge/coverage---4%25-red.svg)

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| Website                   | Link                                           |
|---------------------------|------------------------------------------------|
| Website                   | [https://ss220.club](https://ss220.club)          |
| Code                      | [https://github.com/ss220club/Bandastation](https://github.com/ss220club/Bandastation)    |
| Wiki                      | [https://tg.ss220.club](https://tg.ss220.club)   |
| Codedocs                  | [https://ss220club.github.io/Bandastation/](https://ss220club.github.io/Bandastation/)       |
| SS220 Discord             | [https://discord.gg/ss220](https://discord.gg/ss220) |
| Coderbus Discord          | [https://discord.gg/Vh8TJp9](https://discord.gg/Vh8TJp9)               |

This is the codebase for the /tg/station flavoured fork of SpaceStation 13.

Space Station 13 is a paranoia-laden round-based roleplaying game set against the backdrop of a nonsensical, metal death trap masquerading as a space station, with charming spritework designed to represent the sci-fi setting and its dangerous undertones. Have fun, and survive!

*All github inquiries (such as moderation actions) may be handled via the /tg/station discord [#coding-general](https://discord.com/channels/326822144233439242/326831214667235328). Simply ping the `@Maintainer` role, following the guide on asking questions located in the channel description, with your issue!*

## Загрузка
[Загрузка](.github/guides/DOWNLOADING.md)

[Запуск сервера](.github/guides/RUNNING_A_SERVER.md)

[Карты и руины](.github/guides/MAPS_AND_AWAY_MISSIONS.md)

## Компиляция

**Быстрый способ**. Найдите `bin/server.cmd` в этой папке и дважды щелкните по нему, чтобы автоматически собрать и запустить сервер на порту 1337.

**Долгий способ**. Найдите `bin/build.cmd` в этой папке и дважды щелкните по нему, чтобы начать сборку. Она состоит из нескольких шагов и может занять около 1-5 минут для компиляции. Если оно закроется, это значит, что работа завершена. Затем вы можете [настроить сервер](.github/guides/RUNNING_A_SERVER.md) как обычно, открыв `tgstation.dmb` в DreamDaemon.

**Сборка tgstation напрямую в DreamMaker устарела и может вызвать ошибки**, такие как `‘tgui.bundle.js’: не удается найти файл`.

**[Как компилировать в VSCode и другие варианты сборки](tools/build/README.md).**

## Начало работы

Для руководств по вкладу смотрите [Руководства для участников](.github/CONTRIBUTING.md).

Для начала работы (окружение разработчика, компиляция) смотрите документ HackMD [здесь](https://hackmd.io/@tgstation/HJ8OdjNBc#tgstation-Development-Guide).

Для общей документации по дизайну смотрите [HackMD](https://hackmd.io/@tgstation).

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/ss220club/Bandastation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/ss220club/Bandastation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless therir readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
