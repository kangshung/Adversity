import QtQuick 2.9

import "qrc:/qml/MercenariesMode/MercenariesListScripts.js" as Scripts
import "../.."
import "../."
import Game 1.0

Item {
    id: rootMercenariesList

    function updateEverything()
    {
        transitionRoot.duration = transitionRoot.baseDuration * GameApi.animMultiplier();

        var mercenariesAmount=GameApi.base.mercenaries.amountOfMercenaries();
        Scripts.setupList(Math.round((271/1080)*width), mercenariesAmount, width, height);
        for (var i=0;i<mercenariesAmount;++i)
        {
            GameApi.base.mercenaries.prepareMercenaryAt(i);
            if (GameApi.base.mercenaries.preparedMercenary.isCommunicationAvailable())
                Scripts.createMercenary(GameApi.base.mercenaries.preparedMercenary.name(), GameApi.base.mercenaries.preparedMercenary.name(), GameApi.base.mercenaries.preparedMercenary.professionString(), GameApi.base.mercenaries.preparedMercenary.combatEffectiveness(), GameApi.base.mercenaries.preparedMercenary.proficiency(), GameApi.base.mercenaries.preparedMercenary.cleverness(), GameApi.base.mercenaries.preparedMercenary.health(), GameApi.base.mercenaries.preparedMercenary.healthLimit(), GameApi.base.mercenaries.preparedMercenary.stress(), GameApi.base.mercenaries.preparedMercenary.stressLimit(), GameApi.base.mercenaries.preparedMercenary.stressResistance(), GameApi.base.mercenaries.preparedMercenary.salary(), GameApi.base.mercenaries.preparedMercenary.dailyFoodConsumption(), GameApi.base.mercenaries.preparedMercenary.currentActivityString(), GameApi.base.mercenaries.preparedMercenary.baseCombatEffectiveness(), GameApi.base.mercenaries.preparedMercenary.baseProficiency(), GameApi.base.mercenaries.preparedMercenary.baseCleverness(), GameApi.base.mercenaries.preparedMercenary.baseHealthLimit(), GameApi.base.mercenaries.preparedMercenary.baseStressLimit(), GameApi.base.mercenaries.preparedMercenary.baseStressResistance(), GameApi.base.mercenaries.preparedMercenary.baseSalary(), GameApi.base.mercenaries.preparedMercenary.baseDailyFoodConsumption());
            else
                Scripts.createMIAMercenary(GameApi.base.mercenaries.preparedMercenary.name(), GameApi.base.mercenaries.preparedMercenary.name(), GameApi.base.mercenaries.preparedMercenary.professionString());
        }
    }

    function returnToDefault()
    {
        Scripts.scrollList(3000);
    }

    property int startY

    clip: true

    signal mercenaryClicked(string mercenaryName, string mercenaryProfession)

    MouseArea {
        id: mouseArea

        readonly property int yChangedThresholdForScrolling: 1 // percent; <0;100>; after moving mouse up or down by this percent of screen height, scrolling mode will be activated and mouse release will no longer cause click - instead after each y change list will be scrolled

        property int y0: -1
        property bool isScrollingActive: false

        x: 0
        y: 0
        width: parent.width
        height: parent.height

        onPressed: {
            y0 = mouseY;
            movementCheckTimer.start();
        }

        onReleased: {
            if (isScrollingActive == true)
                isScrollingActive = false;
            else
            {
                var h=Scripts.getClickedMercenaryName(y0);
                if (h!="")
                    mercenaryClicked(h, Scripts.getClickedMercenaryName2(y0));
            }
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
            name: "hidden"
            PropertyChanges { target: rootMercenariesList; y: -1*height }
        }
    ]

    transitions: Transition {
        NumberAnimation { id: transitionRoot; properties: "y"; easing.type: Easing.InQuad; duration: baseDuration; property int baseDuration: 500 }
    }
}
