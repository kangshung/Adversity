import QtQuick 2.1

import Game 1.0

Item {
    id: root

    property int theoreticalWidth: 1080
    property int theoreticalHeight: 1920

    width: 1080
    height: 1920

    clip: false

    transform: [
        Scale {
            id: someScale

            xScale: width/theoreticalWidth
            yScale: height/theoreticalHeight
        },
        Translate {
            x: (width-theoreticalWidth*someScale.xScale)/2
            y: (height-theoreticalHeight*someScale.yScale)/2
        }
    ]

    onVisibleChanged: {
        if (visible)
        {
            con.text="";
            con.forceActiveFocus();
        }
    }

    Image {
        id: background

        anchors.fill: parent

        source: "qrc:/graphics/GUI/Background.png"
    }

    TextInput {
        id: con

        x: 20
        y: 200
        width: 640
        height: font.pixelSize+20

        color: "#94ef94"
        wrapMode: TextInput.Wrap
        font.pixelSize: 26
        font.family: "Courier"

        onAccepted: {
            eval("GameApi.h4xLogic."+text);
            eval("GameApi.h4xLogic.forceUIUpdate()");

            parent.forceActiveFocus();
            parent.visible=false;
        }
    }
}