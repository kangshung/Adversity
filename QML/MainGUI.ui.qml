import QtQuick 2.7
import "./BuildingsMode"
import "./MercenariesMode"

Rectangle {
    id: mainRoot

    property alias missionsButton: missionsButton
    property alias baseButton: baseButton
    property alias heroesButton: heroesButton
    property alias missionsButtonLight: missionsButtonLight
    property alias baseButtonLight: baseButtonLight
    property alias heroesButtonLight: heroesButtonLight

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

    property alias buildingsGUI: buildingsMode
    property alias mercenariesGUI: mercenariesMode

    property alias h4xScreen: h4xScreen

    width: 450
    height: 800

    Image {
        id: background

        anchors.fill: parent

        source: "qrc:/graphics/GUI/Background.png"
    }

    BuildingsModeGUI {
        id: buildingsMode

        x: 0
        y: 189 * parent.height / 1920
        width: parent.width
        height: 1464 * parent.height / 1920
    }

    MercenariesModeGUI {
        id: mercenariesMode

        x: 0
        y: 189 * parent.height / 1920
        width: parent.width
        height: 1464 * parent.height / 1920
    }

    Image {
        id: topAndBottomBar

        anchors.fill: parent

        source: "qrc:/graphics/GUI/GUI.png"

        MouseArea {
            id: missionsButton

            x: 57 * parent.width / 1080
            y: 1727 * parent.height / 1920
            width: 272 * parent.width / 1080
            height: 141 * parent.height / 1920

            visible: true
        }
        ModeButtonLight {
            id: missionsButtonLight

            x: missionsButton.x + 2 * parent.width / 1080
            y: missionsButton.y - 63.5 * parent.height / 1920
            width: 268 * parent.width / 1080
            height: 268 * parent.height / 1920
        }

        MouseArea {
            id: baseButton

            x: 403 * parent.width / 1080
            y: 1727 * parent.height / 1920
            width: 272 * parent.width / 1080
            height: 141 * parent.height / 1920

            visible: true
        }
        ModeButtonLight {
            id: baseButtonLight

            x: baseButton.x + 2 * parent.width / 1080
            y: baseButton.y - 63.5 * parent.height / 1920
            width: 268 * parent.width / 1080
            height: 268 * parent.height / 1920
        }

        MouseArea {
            id: heroesButton

            x: 751 * parent.width / 1080
            y: 1727 * parent.height / 1920
            width: 272 * parent.width / 1080
            height: 141 * parent.height / 1920

            visible: true
        }
        ModeButtonLight {
            id: heroesButtonLight

            x: heroesButton.x + 2 * parent.width / 1080
            y: heroesButton.y - 63.5 * parent.height / 1920
            width: 268 * parent.width / 1080
            height: 268 * parent.height / 1920
        }

        Image {
            id: energyIcon

            x: -12 * parent.width / 1080
            y: 20 * parent.height / 1920
            width: 90 * parent.width / 1080
            height: 90 * parent.height / 1920

            source: "qrc:/graphics/GUI/Energy.png"
        }
        Text {
            id: energyText

            x: 74 * parent.width / 1080
            y: 18 * parent.height / 1920
            width: 53

            color: "#c0efc0"
            text: qsTr("1000/1000")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }
        Text {
            id: energyText2

            x: 80 * parent.width / 1080
            y: 64 * parent.height / 1920
            width: 47

            color: "#c0efc0"
            text: qsTr("100/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }

        Image {
            id: buildingMaterialsIcon

            x: 200 * parent.width / 1080
            y: 15 * parent.height / 1920
            width: 98 * parent.width / 1080
            height: 98 * parent.height / 1920

            source: "qrc:/graphics/GUI/Buildingmaterials.png"
        }
        Text {
            id: buildingMaterialsText

            x: 286 * parent.width / 1080
            y: 18 * parent.height / 1920
            width: 53

            color: "#c0efc0"
            text: qsTr("100/100")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }
        Text {
            id: buildingMaterialsText2

            x: 292 * parent.width / 1080
            y: 64 * parent.height / 1920
            width: 47

            color: "#c0efc0"
            text: qsTr("10/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }

        Image {
            id: foodSuppliesIcon

            x: 420 * parent.width / 1080
            y: 18 * parent.height / 1920
            width: 88 * parent.width / 1080
            height: 88 * parent.height / 1920

            source: "qrc:/graphics/GUI/Foodsupplies.png"
        }
        Text {
            id: foodSuppliesText

            x: 504 * parent.width / 1080
            y: 18 * parent.height / 1920
            width: 53

            color: "#c0efc0"
            text: qsTr("100/100")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }
        Text {
            id: foodSuppliesText2

            x: 510 * parent.width / 1080
            y: 64 * parent.height / 1920
            width: 47

            color: "#c0efc0"
            text: qsTr("-10/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }

        Image {
            id: aetheriteIcon

            x: 628 * parent.width / 1080
            y: 18 * parent.height / 1920
            width: 90 * parent.width / 1080
            height: 90 * parent.height / 1920

            source: "qrc:/graphics/GUI/Aetherite.png"
        }
        Text {
            id: aetheriteText

            x: 714 * parent.width / 1080
            y: 18 * parent.height / 1920
            width: 53

            color: "#c0efc0"
            text: qsTr("100/100")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }
        Text {
            id: aetheriteText2

            x: 720 * parent.width / 1080
            y: 64 * parent.height / 1920
            width: 47

            color: "#c0efc0"
            text: qsTr("-10/DAY")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
            font.family: fontStencil.name
        }

        Text {
            id: hour

            x: 870 * parent.width / 1080
            y: 8 * parent.height / 1920
            width: 52

            color: "#c0efc0"
            text: qsTr("12:00")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
            font.family: fontStencil.name
        }
        Text {
            id: day

            x: 873 * parent.width / 1080
            y: 64 * parent.height / 1920

            color: "#c0efc0"
            text: qsTr("DAY 1380")
            font.pixelSize: 18
            font.family: fontStencil.name
        }
        Item {
            id: settingsItem

            x: 1005 * parent.width / 1080
            y: 3 * parent.height / 1920
            width: 70 * parent.width / 1080
            height: 70 * parent.height / 1920

            property alias mouseArea: settingsMA

            Image {
                id: settingsImage

                anchors.fill: parent

                source: "qrc:/graphics/GUI/Settings.png"
            }
            MouseArea {
                id: settingsMA

                anchors.fill: parent
            }
        }
    }

    H4XScreen {
        id: h4xScreen

        x: 0
        y: 0
        width: 1080
        height: 1920

        visible: false
    }

    FontLoader {
        id: fontStencil

        source: "qrc:/fonts/STENCIL.TTF"
    }
}
