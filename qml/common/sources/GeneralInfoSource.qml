/**
 * GeneralInfoSource.qml
 *
 * The GeneralInfo QML element wraps QSystemInfo. Properties available
 * mirror QSystemInfo's: currentLanguage, currentCountryCode, etc.
 */

import QtQuick 1.1
import QtMobility.systeminfo 1.1

Item {
    id: source
    property string title: "General Info"
    property string subtitle: "Locale and system version"
    property bool active: true

    property string language: gi.currentLanguage
    property string countryCode: gi.currentCountryCode

    GeneralInfo { id: gi }
}
