import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Controls 2.12

ApplicationWindow {
    id: applicationWindow
    // Define the main window
    visible: true
    width: 1000
    height: 500
    color: "#626262"

    Rectangle{
        id:gaugeBackground
        color:"#292929"
        radius: leftRpm.height
        anchors.centerIn: parent
        height: leftRpm.height*1.1
        width: parent.width
    }

    RpmGauge{
        id:leftRpm
        anchors.horizontalCenterOffset: -parent.width/4
    }

    RpmGauge{
        id:rightRpm
        anchors.horizontalCenterOffset: parent.width/4
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}
}
##^##*/
