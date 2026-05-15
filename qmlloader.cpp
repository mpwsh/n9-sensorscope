/**
 * SensorScope - qmlloader.cpp
 *
 * Loads the Harmattan Main.qml. No splash screen, no custom QML types
 * registered (we don't need Arc or PersistentStorage from the compass app).
 */

#include <QtDeclarative>
#include <QDir>
#include "qmlloader.h"

QMLLoader::QMLLoader(QDeclarativeView *view)
    : m_View(view), m_MainItem(0)
{
}

void QMLLoader::loadMainQML()
{
    // appFolder is exposed to QML in case wrappers want to load asset files
    // from the install dir. Mirrors the compass app convention.
    m_View->rootContext()->setContextProperty(
        "appFolder",
        "file://" + qApp->applicationDirPath() + QDir::separator());

    QString mainQmlFile =
        qApp->applicationDirPath() + "/../qml/harmattan/Main.qml";

    QDeclarativeComponent component(m_View->engine(),
                                    QUrl::fromLocalFile(mainQmlFile));

    if (component.status() == QDeclarativeComponent::Error) {
        qDebug() << "QML error(s):" << component.errors();
        return;
    }

    m_MainItem = qobject_cast<QDeclarativeItem*>(component.create());
    if (!m_MainItem) {
        qDebug() << "MainItem is NULL";
        return;
    }
    m_View->scene()->addItem(m_MainItem);

    connect((QObject*)m_View->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));
}
