/**
 * SensorScope - main.cpp
 *
 * Minimal QML host. Based on Nokia's compass example, stripped of
 * Symbian-only code paths since this app is Harmattan-only.
 */

#include <QApplication>
#include <QDeclarativeView>
#include <QDesktopWidget>
#include <QTimer>
#include "qmlloader.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDeclarativeView view;
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view.setAutoFillBackground(false);

    QMLLoader qmlLoader(&view);
    QTimer::singleShot(0, &qmlLoader, SLOT(loadMainQML()));

    view.setGeometry(QApplication::desktop()->screenGeometry());
    view.showFullScreen();

    return app.exec();
}
