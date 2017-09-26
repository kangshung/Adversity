import QtQuick 2.9

import "qrc:/qml/MercenariesMode/HeroesListScripts.js" as Scripts
import "../.."
import "../."
import Game 1.0

Item {
    id: rootHeroesList

    function updateEverything()
    {
        transitionRoot.duration = transitionRoot.baseDuration * GameApi.animMultiplier();

        var heroesAmount=0;
        var availableHeroes = new Array(GameApi.base.heroes.amountOfHeroes());
        for (var i=0;i<GameApi.base.heroes.amountOfHeroes();++i)
        {
            GameApi.base.heroes.prepareHeroAt(i);
            if (!GameApi.base.heroes.preparedHero.isDead() || !GameApi.base.heroes.preparedHero.isCommunicationAvailable())
            {
                ++heroesAmount;
                availableHeroes[i]=true;
            }
        }
        Scripts.setupList(Math.round((271/1080)*width), heroesAmount, width, height);
        var j=0;
        for (i=0;i<GameApi.base.heroes.amountOfHeroes() && j<heroesAmount;++i)
        {
            if (availableHeroes[i] == true)
            {
                GameApi.base.heroes.prepareHeroAt(i);
                if (GameApi.base.heroes.preparedHero.isCommunicationAvailable())
                    Scripts.createHero(GameApi.base.heroes.preparedHero.name(), GameApi.base.heroes.preparedHero.name(), GameApi.base.heroes.preparedHero.professionString(), GameApi.base.heroes.preparedHero.combatEffectiveness(), GameApi.base.heroes.preparedHero.proficiency(), GameApi.base.heroes.preparedHero.cleverness(), GameApi.base.heroes.preparedHero.health(), GameApi.base.heroes.preparedHero.healthLimit(), GameApi.base.heroes.preparedHero.stress(), GameApi.base.heroes.preparedHero.stressLimit(), GameApi.base.heroes.preparedHero.stressResistance(), GameApi.base.heroes.preparedHero.salary(), GameApi.base.heroes.preparedHero.dailyFoodConsumption(), GameApi.base.heroes.preparedHero.currentActivityString(), GameApi.base.heroes.preparedHero.baseCombatEffectiveness(), GameApi.base.heroes.preparedHero.baseProficiency(), GameApi.base.heroes.preparedHero.baseCleverness(), GameApi.base.heroes.preparedHero.baseHealthLimit(), GameApi.base.heroes.preparedHero.baseStressLimit(), GameApi.base.heroes.preparedHero.baseStressResistance(), GameApi.base.heroes.preparedHero.baseSalary(), GameApi.base.heroes.preparedHero.baseDailyFoodConsumption());
                else
                    Scripts.createMIAHero(GameApi.base.heroes.preparedHero.name(), GameApi.base.heroes.preparedHero.name(), GameApi.base.heroes.preparedHero.professionString());
                ++j;
            }
        }
    }

    function returnToDefault()
    {
        Scripts.scrollList(3000);
    }

    property int startY

    clip: true

    signal heroClicked(string heroName, string heroProfession)

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
                var h=Scripts.getClickedHeroName(y0);
                if (h!="")
                    heroClicked(h, Scripts.getClickedHeroName2(y0));
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
            PropertyChanges { target: rootHeroesList; y: -1*height }
        }
    ]

    transitions: Transition {
        NumberAnimation { id: transitionRoot; properties: "y"; easing.type: Easing.InQuad; duration: baseDuration; property int baseDuration: 500 }
    }
}
