#pragma once

#include <QColor>
#include <QObject>
#include <QSettings>
#include <QStandardPaths>
#include <QString>
#include <QTimer>

#include <functional>
#include <memory>

// The shell's own widget colours (window frame, tab bar, docks), matched to
// the design system's theme. Logos.Theme keeps the person's choice in one
// settings file that every window and app process reads; ShellTheme reads the
// same file, so the parts drawn in C++ follow the QML ones. Header-only, for
// both the app and the main_ui plugin.
namespace ShellTheme {

inline QString settingsPath()
{
    return QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation)
        + QStringLiteral("/Logos/design-system.ini");
}

// "dark", "light" or "high-contrast".
inline QString name()
{
    QSettings settings(settingsPath(), QSettings::IniFormat);
    return settings.value(QStringLiteral("LogosDesignSystem/theme"), QStringLiteral("dark")).toString();
}

struct Colors {
    QColor shell;          // window and dock background (Theme.palette.background)
    QColor tab;            // a selected or hovered tab
    QColor tabText;
    QColor idleTab;        // a tab that is not selected
    QColor idleTabText;
    QColor secondaryText;
    QColor hoverWash;      // hover on a tool button
};

inline Colors colors(const QString& theme = name())
{
    if (theme == QLatin1String("light"))
        // Day: a sand frame around paper-white content.
        return {QColor("#ECE7DC"), QColor("#FFFFFF"), QColor("#1B1A17"), QColor(27, 26, 23, 12),
                QColor("#6E695F"), QColor("#55514A"), QColor(27, 26, 23, 16)};
    if (theme == QLatin1String("high-contrast"))
        return {QColor("#000000"), QColor("#1A1A1A"), QColor("#EDEDED"), QColor("#0A0A0A"),
                QColor("#BDBDBD"), QColor("#EDEDED"), QColor(255, 255, 255, 26)};
    return {QColor("#171717"), QColor("#262626"), QColor("#A4A4A4"), QColor(38, 38, 38, 153),
            QColor("#626262"), QColor("#A0A0A0"), QColor(255, 255, 255, 26)};
}

inline QString css(const QColor& c)
{
    return QStringLiteral("rgba(%1, %2, %3, %4)").arg(c.red()).arg(c.green()).arg(c.blue()).arg(c.alphaF());
}

// Calls `apply` now and again whenever the theme changes (checked each second)
// for as long as `owner` lives.
inline void follow(QObject* owner, std::function<void(const Colors&)> apply)
{
    auto current = std::make_shared<QString>(name());
    apply(colors(*current));
    auto* timer = new QTimer(owner);
    timer->setInterval(1000);
    QObject::connect(timer, &QTimer::timeout, owner, [current, apply]() {
        const QString now = name();
        if (now == *current) return;
        *current = now;
        apply(colors(now));
    });
    timer->start();
}

} // namespace ShellTheme
