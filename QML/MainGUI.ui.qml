import QtQuick 2.9
import "./BuildingsMode"
import "./MercenariesMode"
import "./MissionsMode"
import "./Reports"
import "./Settings"
import FPSComponent 1.0

Rectangle {
    id: mainRoot

    property alias missionsButton: missionsButton
    property alias baseButton: baseButton
    property alias mercenariesButton: mercenariesButton
    property alias missionsButtonLight: missionsButtonLight
    property alias baseButtonLight: baseButtonLight
    property alias mercenariesButtonLight: mercenariesButtonLight

    property alias energyValue: energyText
    property alias energyValue2: energyText2
    property alias buildingMaterialsValue: buildingMaterialsText
    property alias buildingMaterialsValue2: buildingMaterialsText2
    property alias foodSuppliesValue: foodSuppliesText
    property alias foodSuppliesValue2: foodSuppliesText2
    property alias aetheriteValue: aetheriteText
    property alias aetheriteValue2: aetheriteText2

    property alias hourValue: hour
    property alias dayValue: day

    property alias settingsButton: settingsMA
    property alias settings: settings

    property alias buildingsGUI: buildingsMode
    property alias mercenariesGUI: mercenariesMode
    property alias missionsGUI: missionsMode

    property alias reportsNotification: reportsNotification
    property alias reportsOpener: reportsOpener
    property alias reportsList: reportsList

    property alias h4xScreen: h4xScreen

    property alias mercenaryDismissConfirmDialog: mercenaryDismissConfirmDialog

    property alias mercenaryArtPreview: mercenaryArtPreview

    property alias enableFPSCounter: fpsCnt.visible

    width: 1080
    height: 1920

    Image {
        id: background

        anchors.fill: parent

        source: "qrc:/graphics/GUI/Background.png"
    }

    BuildingsModeGUI {
        id: buildingsMode

        x: 0
        y: 189
        width: parent.width
        height: 1464
    }

    MercenariesModeGUI {
        id: mercenariesMode

        x: 0
        y: 189
        width: parent.width
        height: 1464
    }

    MissionsModeGUI {
        id: missionsMode

        x: 0
        y: 189
        width: parent.width
        height: 1464
    }

    ReportsNotification {
        id: reportsNotification

        x: 1080 - width
        y: 1400
        width: 425
        height: 200
    }

    ReportsList {
        id: reportsList

        x: 0
        y: 189
        width: parent.width
        height: 1464
    }

    Image {
        id: topAndBottomBar

        anchors.fill: parent

        source: "qrc:/graphics/GUI/GUI.png"

        MouseArea {
            id: missionsButton

            x: 57
            y: 1727
            width: 272
            height: 141

            visible: true
        }
        ModeButtonLight {
            id: missionsButtonLight

            x: missionsButton.x + 2
            y: missionsButton.y - 63.5
            width: 268
            height: 268
        }

        MouseArea {
            id: baseButton

            x: 403
            y: 1727
            width: 272
            height: 141

            visible: true
        }
        ModeButtonLight {
            id: baseButtonLight

            x: baseButton.x + 2
            y: baseButton.y - 63.5
            width: 268
            height: 268
        }

        MouseArea {
            id: mercenariesButton

            x: 751
            y: 1727
            width: 272
            height: 141

            visible: true
        }
        ModeButtonLight {
            id: mercenariesButtonLight

            x: mercenariesButton.x + 2
            y: mercenariesButton.y - 63.5
            width: 268
            height: 268
        }

        MouseArea {
            id: reportsOpener

            x: 0
            y: 0
            width: parent.width
            height: 125
        }

        Image {
            id: energyIcon

            x: -12
            y: 20
            width: 90
            height: 90

            source: "qrc:/graphics/GUI/Resources/Energy.png"
        }
        Text {
            id: energyText

            x: 53
            y: 18
            width: 166
            height: 39

            color: "#c0efc0"
            text: qsTr("1000/1000")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }
        Text {
            id: energyText2

            x: 72
            y: 64
            width: 132
            height: 39

            color: "#c0efc0"
            text: qsTr("100/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }

        Image {
            id: buildingMaterialsIcon

            x: 200
            y: 15
            width: 98
            height: 98

            source: "qrc:/graphics/GUI/Resources/Buildingmaterials.png"
        }
        Text {
            id: buildingMaterialsText

            x: 286
            y: 18
            width: 128
            height: 39

            color: "#c0efc0"
            text: qsTr("100/100")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }
        Text {
            id: buildingMaterialsText2

            x: 292
            y: 64
            width: 115
            height: 39

            color: "#c0efc0"
            text: qsTr("10/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }

        Image {
            id: foodSuppliesIcon

            x: 420
            y: 18
            width: 88
            height: 88

            source: "qrc:/graphics/GUI/Resources/Foodsupplies.png"
        }
        Text {
            id: foodSuppliesText

            x: 504
            y: 18
            width: 137
            height: 39

            color: "#c0efc0"
            text: qsTr("100/100")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }
        Text {
            id: foodSuppliesText2

            x: 510
            y: 64
            width: 121
            height: 39

            color: "#c0efc0"
            text: qsTr("-10/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }

        Image {
            id: aetheriteIcon

            x: 628
            y: 18
            width: 90
            height: 90

            source: "qrc:/graphics/GUI/Resources/Aetherite.png"
        }
        Text {
            id: aetheriteText

            x: 714
            y: 18
            width: 137
            height: 39

            color: "#c0efc0"
            text: qsTr("100/100")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }
        Text {
            id: aetheriteText2

            x: 714
            y: 64
            width: 131
            height: 39

            color: "#c0efc0"
            text: qsTr("-10/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 34
            font.family: fontStencil.name
        }

        Text {
            id: hour

            x: 870
            y: 8
            width: 129
            height: 55

            color: "#c0efc0"
            text: qsTr("12:00")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 48
            font.family: fontStencil.name
        }
        Text {
            id: day

            x: 873
            y: 64

            color: "#c0efc0"
            text: qsTr("DAY 1380")
            font.pixelSize: 43
            font.family: fontStencil.name
        }
        Item {
            id: settingsItem

            x: 1005
            y: 3
            width: 70
            height: 70

            property alias mouseArea: settingsMA

            Image {
                id: settingsImage

                anchors.fill: parent

                source: "qrc:/graphics/GUI/Settings.png"
            }
            MouseArea {
                id: settingsMA

                x: -132
                y: -3
                width: 217
                height: 129
            }
        }
    }

    Settings {
        id: settings

        x: 0
        y: 189
        width: parent.width
        height: 1464
    }

    H4XScreen {
        id: h4xScreen

        anchors.fill: parent

        visible: false
    }

    MercenaryArtPreview {
        id: mercenaryArtPreview

        anchors.fill: parent
    }

    ConfirmDialog {
        id: mercenaryDismissConfirmDialog

        anchors.fill: parent
    }

    FPSCounter {
        id: fpsCnt

        visible: false

        x: 0
        anchors.bottom: parent.bottom
        width: 200
        height: 125

        Text {
            x: 0
            width: parent.width
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            font.family: "Comic Sans"
            font.pixelSize: parent.height
            color: "white"
            text: fpsCnt.fps
        }
    }

    FontLoader {
        id: fontStencil

        source: "qrc:/fonts/STENCIL.TTF"
    }
}
