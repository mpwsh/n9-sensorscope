/**
 * SourceRegistry.qml
 *
 * The catalog of every data source SensorScope knows about. Each entry has:
 *   id        - unique key (used as filename for the wrapper)
 *   name      - human-readable label
 *   category  - "sensor" | "systeminfo" | "location"
 *   blurb     - one-line description shown in the list
 *   live      - true if values stream continuously, false if mostly static
 *
 * The detail view loads `sources/<id>Source.qml` for the chosen entry.
 *
 * Sensors omitted: TiltSensor, IRProximitySensor — those QML types are
 * not exposed by QtMobility.sensors on Harmattan. GeneralInfo omitted —
 * QSystemInfo is not a QML type in QtMobility.systeminfo 1.1.
 */

import QtQuick 1.1

QtObject {
    property variant sources: [
        // --- Sensors --------------------------------------------------------
        { id: "Accelerometer",     name: "Accelerometer",      category: "sensor",     live: true,
          blurb: "3-axis linear acceleration in m/s²" },
        { id: "Gyroscope",         name: "Gyroscope",          category: "sensor",     live: true,
          blurb: "3-axis angular velocity in °/s" },
        { id: "Magnetometer",      name: "Magnetometer",       category: "sensor",     live: true,
          blurb: "Raw magnetic field, 3-axis (Tesla)" },
        { id: "Compass",           name: "Compass",            category: "sensor",     live: true,
          blurb: "Derived heading + calibration level" },
        { id: "Orientation",       name: "Orientation",        category: "sensor",     live: true,
          blurb: "Discrete device orientation (face up, left up, …)" },
        { id: "Rotation",          name: "Rotation",           category: "sensor",     live: true,
          blurb: "Pitch / roll / yaw from sensor fusion" },
        { id: "AmbientLight",      name: "Ambient Light",      category: "sensor",     live: true,
          blurb: "Discrete brightness category (Dark, Twilight, …)" },
        { id: "Light",             name: "Light",              category: "sensor",     live: true,
          blurb: "Illuminance in lux" },
        { id: "Proximity",         name: "Proximity",          category: "sensor",     live: true,
          blurb: "Boolean near/far (the in-call screen sensor)" },
        { id: "Tap",               name: "Tap",                category: "sensor",     live: true,
          blurb: "Tap detection via accelerometer" },

        // --- Location -------------------------------------------------------
        { id: "Position",          name: "Position",           category: "location",   live: true,
          blurb: "Fused GPS / network position from QGeoPositionInfo" },

        // --- System info ----------------------------------------------------
        { id: "DeviceInfo",        name: "Device Info",        category: "systeminfo", live: false,
          blurb: "Manufacturer, model, product name" },
        { id: "BatteryInfo",       name: "Battery",            category: "systeminfo", live: true,
          blurb: "Charge level and power state" },
        { id: "NetworkInfo",       name: "Network",            category: "systeminfo", live: true,
          blurb: "Cellular signal, operator, cell ID" },
        { id: "StorageInfo",       name: "Storage",            category: "systeminfo", live: false,
          blurb: "Volume sizes and free space per mount" },
        { id: "GeneralInfo",       name: "General Info",       category: "systeminfo", live: false,
          blurb: "Language and country code" },
        { id: "DisplayInfo",       name: "Display",            category: "systeminfo", live: false,
          blurb: "Brightness, DPI, color depth, physical size" }
    ]

    function find(id) {
        for (var i = 0; i < sources.length; ++i)
            if (sources[i].id === id) return sources[i];
        return null;
    }
}
