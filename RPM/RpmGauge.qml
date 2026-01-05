import QtQuick 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Controls 2.12

// Define the gauge object
CircularGauge {
    id: gauge

    // Object Properties
    property color stdColor:"#e5e5e5"
    property real warningVal:60
    property color warningColor:"#fb8d1a"
    property real criticalVal:80
    property color criticalColor:"#e8083e"
    property real maxVal:90
    property color faceColor: "#1F1F1F"
    property real needleVal:0
    property color setpointBackgroundColor: "#204000"
    property color setpointActiveColor: "#20F000"
    property real setpointVal:10
    property bool showSetpoint : true

    anchors.centerIn: parent
    width: parent.width/2
    height: parent.height/1.5
    stepSize: 0.1
    antialiasing: true

    // Value (needle position)
    value: needleVal // Drive value with propert

    // Use gauge value for an animation (smoothing needle motion)
    Behavior on value {
        NumberAnimation {
            duration: 100
        }
    }

    Behavior on setpointVal{
        NumberAnimation {
            duration: 100
        }
    }

    // Function for color selection based on value range
    function getColor(value){
         var tickColor;

         if(value >= criticalVal)
             tickColor = criticalColor;
         else if (value >= warningVal)
             tickColor = warningColor
         else
             tickColor = stdColor

         return tickColor
    }

    // Define visual style of the gauge:
    style:CircularGaugeStyle{
       // Functions to condense calls for angle conversion
       function degreesToRadians(degrees) {return degrees * (Math.PI / 180)}
       function getAngleFromValue(val){return degreesToRadians(valueToAngle(val) - 90)}

       // Funciton to simplify repeated arc draws
       function drawGaugeArc(ctx, radiusScale, startAngle, endAngle, color, lineWidth){
           ctx.beginPath();
           ctx.strokeStyle = color;
           ctx.lineWidth = lineWidth;
           ctx.arc(outerRadius, outerRadius, outerRadius*radiusScale - ctx.lineWidth / 2, startAngle, endAngle);
           ctx.stroke();
       }

       tickmarkLabel:  Text {
           font.pixelSize: Math.max(15, outerRadius * 0.15)
           font.bold: true
           text: styleData.value
           color: gauge.getColor(styleData.value)
           antialiasing: true
       }

       tickmark: Rectangle {
           implicitWidth: outerRadius * 0.02
           antialiasing: true
           implicitHeight: outerRadius * 0.08
           color: gauge.getColor(styleData.value)
       }

       minorTickmark: Rectangle {
           visible: styleData.value < gauge.maxVal
           implicitWidth: outerRadius * 0.01
           antialiasing: true
           implicitHeight: outerRadius * 0.08
           color: gauge.getColor(styleData.value)
       }

       // Background (used to draw arcs)
       background:
        Canvas {
            id:canvas
            Connections{
                target:gauge
                function onSetpointValChanged(){ canvas.requestPaint() }
            }

            onPaint: {
               var ctx = getContext("2d");
               ctx.reset();

               // Gauge Face
               drawGaugeArc(ctx,1,0,2*Math.PI, gauge.faceColor, outerRadius*0.5)

               // Critical Arcs
               drawGaugeArc(ctx,0.5,getAngleFromValue(gauge.criticalVal), getAngleFromValue(gauge.maxVal), gauge.criticalColor, outerRadius * 0.03)
               drawGaugeArc(ctx,1,getAngleFromValue(gauge.criticalVal), getAngleFromValue(gauge.maxVal), gauge.criticalColor, outerRadius * 0.03)

               // Warning Arcs
               drawGaugeArc(ctx, 0.5, getAngleFromValue(gauge.warningVal), getAngleFromValue(gauge.criticalVal), gauge.warningColor, outerRadius * 0.03)
               drawGaugeArc(ctx, 1, getAngleFromValue(gauge.warningVal), getAngleFromValue(gauge.criticalVal), gauge.warningColor, outerRadius * 0.03)

               // Std Arcs
               drawGaugeArc(ctx, 0.5, getAngleFromValue(0), getAngleFromValue(gauge.warningVal), gauge.stdColor, outerRadius * 0.03)
               drawGaugeArc(ctx, 1, getAngleFromValue(0), getAngleFromValue(gauge.warningVal), gauge.stdColor, outerRadius * 0.03)

               // Setpoint
               if(showSetpoint){
                drawGaugeArc(ctx, 0.65, getAngleFromValue(0), getAngleFromValue(gauge.maxVal), gauge.setpointBackgroundColor, outerRadius * 0.03)
                drawGaugeArc(ctx, 0.65, getAngleFromValue(0), getAngleFromValue(gauge.setpointVal), gauge.setpointActiveColor, outerRadius * 0.03)
               }

            }
        }
    }

    // Gauge range (minimum and maximum values)
    minimumValue: 0
    maximumValue: maxVal

    Label{
        id: valueLabel
        text: (gauge.value*1000).toFixed(0)
        color: gauge.getColor(gauge.value)
        anchors.verticalCenterOffset: parent.height*0.3
        anchors.horizontalCenterOffset: 0
        anchors.centerIn: parent
        font.pixelSize: gauge.height*0.08
        font.bold: true
    }

    Label{
        id: unitLabel
        text: "RPM x1000"
        color: gauge.stdColor
        anchors.verticalCenterOffset: parent.height*0.42
        anchors.horizontalCenterOffset: 0
        anchors.centerIn: parent
        font.pixelSize: gauge.height*0.06
        font.bold: true
    }
}
