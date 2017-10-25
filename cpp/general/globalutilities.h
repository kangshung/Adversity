#pragma once

#include <QObject>

class GlobalUtilities : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE static double roundDouble(double d, unsigned prec) noexcept;
    Q_INVOKABLE static QString alterNormalTextToInternal(QString normalText) noexcept;
    Q_INVOKABLE static QString sanitize(QString script) noexcept;
};
