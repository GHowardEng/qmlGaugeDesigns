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
                event.accepted = true; // Is completion of the event required for function?
            }
        }
        Component.onCompleted: forceActiveFocus()

        function rightRandom() {
            (rightRpm.needleVal == 0) ? rightRpm.needleVal = Math.random()*rightRpm.maxVal : rightRpm.needleVal = 0;
        }
        function leftRandom (){
            (leftRpm.needleVal == 0) ? leftRpm.needleVal = Math.random()*leftRpm.maxVal : leftRpm.needleVal = 0;
        }
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
