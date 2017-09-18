import QtQuick 2.9

import "qrc:/qml/MissionsMode/MissionsList/Reports/ReportsListScripts.js" as Scripts
import "../../.."

import Game 1.0

Item {
    id: root

    width: 1080
    height: 1440

    property string name_

    function updateEverything()
    {
        var am=GameApi.base.heroes.amountOfHeroes();
        var intName = GameApi.globalsCpp.alterNormalTextToInternal(name_);
        for (var i=0;i<am;++i)
        {
            GameApi.base.heroes.prepareHeroAt(i);
            if (GameApi.base.heroes.preparedHero.name() == intName)
            {
                var am2=GameApi.base.heroes.preparedHero.assignedMission.amountOfReports();
                Scripts.setupList(am2, width, height);
                for (var j=0;j<am2;++j)
                {
                    GameApi.base.heroes.preparedHero.assignedMission.prepareReport(j);
                    Scripts.createItem(GameApi.base.heroes.preparedHero.assignedMission.preparedReport.timestamp(), GameApi.base.heroes.preparedHero.assignedMission.preparedReport.msg(), GameApi.base.heroes.preparedHero.assignedMission.preparedReport.artSource());
                }
            }
        }
    }

    function returnToDefault()
    {
        Scripts.scrollList(999999);
    }

    function setHero(name)
    {
        name_=name;
        updateEverything();
    }

    property int startY

    clip: true

    MouseArea {
        id: mouseArea

        readonly property int yChangedThresholdForScrolling: 1 // percent; <0;100>; after moving mouse up or down by this percent of screen height, scrolling mode will be activated and mouse release will no longer cause click - instead after each y change list will be scrolled

        property int y0: -1
        property bool isScrollingActive: false

        anchors.fill: parent

        onPressed: {
            y0 = mouseY;
            movementCheckTimer.start();
        }

        onReleased: {
            if (isScrollingActive == true)
                isScrollingActive = false;
            y0 = -1;
            movementCheckTimer.stop();
        }

        Timer {
            id: movementCheckTimer

            interval: 16
            repeat: true
            running: false

            onTriggered: {
                if (mouseArea.isScrollingActive == true)
                {
                    Scripts.scrollList(Math.ceil(mouseArea.mouseY) - mouseArea.y0);

                    mouseArea.y0 = Math.ceil(mouseArea.mouseY);
                }
                else
                {
                    if (Math.abs(mouseArea.mouseY - mouseArea.y0) >= Globals.windowHeight * mouseArea.yChangedThresholdForScrolling / 100)
                    {
                        mouseArea.isScrollingActive = true;
                        Scripts.scrollList(mouseArea.mouseY - mouseArea.y0);
                        mouseArea.y0 = mouseArea.mouseY;
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "hiddenRight"
            PropertyChanges { target: root; x: width }
        },
        State {
            name: "hiddenRight2"
            PropertyChanges { target: root; x: 2*width }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InQuad; duration: 500 }
    }

    FontLoader {
        id: fontStencil

        source: "qrc:/fonts/STENCIL.TTF"
    }
}
