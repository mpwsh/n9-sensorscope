/**
 * SensorScope - qmlloader.h
 */

#ifndef QMLLOADER_H
#define QMLLOADER_H

#include <QObject>
#include <QDeclarativeView>
#include <QDeclarativeItem>

class QMLLoader : public QObject
{
    Q_OBJECT
public:
    explicit QMLLoader(QDeclarativeView *view);

public slots:
    void loadMainQML();

private:
    QDeclarativeView *m_View;
    QDeclarativeItem *m_MainItem;
};

#endif // QMLLOADER_H
