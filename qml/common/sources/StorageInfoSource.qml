/**
 * StorageInfoSource.qml
 *
 * Lists up to two volumes (typical N9 = MyDocs internal + maybe a removable
 * mount). The per-drive size methods are Q_INVOKABLE in QtMobility, but
 * the QML binding coverage varies. We wrap calls in try/catch so missing
 * methods leave fields as zero rather than crashing the page.
 */

import QtQuick 1.1
import QtMobility.systeminfo 1.1

Item {
    id: source
    property string title: "Storage"
    property string subtitle: "Volume mounts, sizes, and free space"
    property bool active: true

    property string volume1Path: ""
    property string volume1Type: ""
    property real volume1TotalMB: 0
    property real volume1AvailMB: 0

    property string volume2Path: ""
    property string volume2Type: ""
    property real volume2TotalMB: 0
    property real volume2AvailMB: 0

    function typeName(t) {
        switch (t) {
        case 0: return "No drive";
        case 1: return "Internal";
        case 2: return "Removable";
        case 3: return "CD";
        case 4: return "Remote";
        }
        return "Code " + t;
    }

    function fillFromDrive(idx, path) {
        var t = 0, total = 0, avail = 0;
        try { t = si.typeForDrive(path); } catch (e) {}
        try { total = si.totalDiskSpace(path) / (1024 * 1024); } catch (e) {}
        try { avail = si.availableDiskSpace(path) / (1024 * 1024); } catch (e) {}

        if (idx === 1) {
            volume1Path = path; volume1Type = typeName(t);
            volume1TotalMB = total; volume1AvailMB = avail;
        } else {
            volume2Path = path; volume2Type = typeName(t);
            volume2TotalMB = total; volume2AvailMB = avail;
        }
    }

    StorageInfo { id: si }

    Component.onCompleted: {
        var vols = [];
        try { vols = si.logicalDrives; } catch (e) {}
        if (vols && vols.length > 0) fillFromDrive(1, vols[0]);
        if (vols && vols.length > 1) fillFromDrive(2, vols[1]);
    }
}
