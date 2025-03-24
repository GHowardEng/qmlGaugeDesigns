import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Controls 2.12

ApplicationWindow {
    id: applicationWindow
    // Define the main window
    visible: true
    width: 800
    height: 500
    color: "#626262"

    Rectangle{
        id:gaugeBackground
        color:"#292929"
        radius: leftRpm.height
        anchors.centerIn: parent
        height: leftRpm.height*1.1
        width: parent.width

        // Space key press will modify the needle values
        Keys.onSpacePressed: (Math.random() > 0.5) ?  rightRandom() : leftRandom();
        Keys.onReleased: {
            if (event.key === Qt.Key_Space) {
                event.accepted = true;
            }
        }
        Component.onCompleted: forceActiveFocus()

        // Try using alias
        property alias rightVal: rightRpm.needleVal
        property alias leftVal: leftRpm.needleVal

        function rightRandom() {(rightVal == 0) ? rightVal = Math.random()*rightRpm.maxVal : rightVal = 0;}
        function leftRandom() {(leftVal == 0) ? leftVal = Math.random()*leftRpm.maxVal : leftVal = 0;}
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
