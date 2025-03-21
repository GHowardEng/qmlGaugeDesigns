import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Controls 2.12

ApplicationWindow {
    // Define the main window
    visible: true
    width: 500
    height: 500
    color: "#292929"

    // Object Properties
    property var needleVal:0
    property color stdColor:"#e5e5e5"
    property var warningVal:60
    property color warningColor:"#fb8d1a"
    property var criticalVal:80
    property color criticalColor:"#e8083e"
    property var maxVal:100
    property color faceColor: "#00516F"

    // Define the gauge object
    CircularGauge {
        id: rpmGauge
        anchors.centerIn: parent
        width: parent.width*0.8
        height: parent.height*0.8
        transformOrigin: Item.Center
        antialiasing: true

        // Value (needle position)
        value: needleVal // Drive value with propert

        // Space key press will modify the needle value
        Keys.onSpacePressed: (needleVal == 0) ? needleVal = Math.random()*maxVal : needleVal = 0;
        Keys.onReleased: {
            if (event.key === Qt.Key_Space) {
                event.accepted = true; // Is completion of the event required for function?
            }
        }
        Component.onCompleted: forceActiveFocus()

        // Use gauge value for an animation (smoothing needle motion)
        Behavior on value {
            NumberAnimation {
                duration: 200
            }
        }

        // Define visual style of the gauge:
        style:CircularGaugeStyle{

           function degreesToRadians(degrees) {
               return degrees * (Math.PI / 180);
           }

           // Function to condense calls for angle conversion
           function getAngleFromValue(val)
           {
               return degreesToRadians(valueToAngle(val) - 90)
           }

           // Function for color selection based on value range
           function getColor(value)
           {
                var tickColor;

                if(value >= criticalVal)
                    tickColor = criticalColor;
                else if (value >= warningVal)
                    tickColor = warningColor
                else
                    tickColor = stdColor

                return tickColor
           }

           // Funciton to simplify repeated arc draws
           function drawGaugeArc(ctx, radiusScale, startAngle, endAngle, color, lineWidth)
           {
               ctx.beginPath();
               ctx.strokeStyle = color;
               ctx.lineWidth = lineWidth;
               ctx.arc(outerRadius, outerRadius, outerRadius*radiusScale - ctx.lineWidth / 2, startAngle, endAngle);
               ctx.stroke();
           }

           //tickmarkInset: outerRadius*0.2
           tickmarkLabel:  Text {
               font.pixelSize: Math.max(15, outerRadius * 0.15)
               font.bold: true
               //font.family:
               text: styleData.value/10
               color: getColor(styleData.value)
               antialiasing: true
           }

           tickmark: Rectangle {
               implicitWidth: outerRadius * 0.03
               antialiasing: true
               implicitHeight: outerRadius * 0.1
               color: getColor(styleData.value)
           }

           minorTickmark: Rectangle {
               visible: styleData.value < warningVal
               implicitWidth: outerRadius * 0.01
               antialiasing: true
               implicitHeight: outerRadius * 0.08
               color: stdColor
           }

           // Background (used to draw arcs)
           background:
                Canvas {
                    onPaint: {
                       var ctx = getContext("2d");
                       ctx.reset();

                       // Gauge Face
                       drawGaugeArc(ctx,1,0,2*Math.PI, faceColor, outerRadius/2)

                       // Critical Arcs
                       drawGaugeArc(ctx,0.5,getAngleFromValue(criticalVal), getAngleFromValue(maxVal), criticalColor, outerRadius * 0.03)
                       drawGaugeArc(ctx,1,getAngleFromValue(criticalVal), getAngleFromValue(maxVal), criticalColor, outerRadius * 0.03)

                       // Warning Arcs
                       drawGaugeArc(ctx, 0.5, getAngleFromValue(warningVal), getAngleFromValue(criticalVal), warningColor, outerRadius * 0.03)
                       drawGaugeArc(ctx, 1, getAngleFromValue(warningVal), getAngleFromValue(criticalVal), warningColor, outerRadius * 0.03)

                       // Std Arcs
                       drawGaugeArc(ctx, 0.5, getAngleFromValue(0), getAngleFromValue(warningVal), stdColor, outerRadius * 0.03)
                       drawGaugeArc(ctx, 1, getAngleFromValue(0), getAngleFromValue(warningVal), stdColor, outerRadius * 0.03)
                    }
                }

                // How to add value readout?
                Text{
                    text: styleData.value
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -outerRadius*0.5
                    font.pixelSize: Math.max(15, outerRadius * 0.15)
                }

           //minimumValueAngle: -100
           //maximumValueAngle: 100
        }

        // Gauge range (minimum and maximum values)
        minimumValue: 0
        maximumValue: 100
    }
}

