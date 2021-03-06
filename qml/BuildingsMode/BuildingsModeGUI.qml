import QtQuick 2.9

import Game 1.0

Item {
    id: root

    clip: true

    signal updateRequestedFromBuildingsModeGUI()
    signal mercenariesModeUpdateRequested()
    signal showSpecial()

    function returnToDefault()
    {
        list.state = "";
        menu.state = "hidden";
        list.returnToDefault();
        menu.returnToDefault();
    }

    function updateEverything()
    {
        transitionRoot.duration = transitionRoot.baseDuration * GameApi.animMultiplier();

        list.updateEverything();
        menu.updateEverything();
    }

    function reactToBackOnToolbar()//returns true if intervention was successful and nothing else is needed to be done
    {
        if (menu.state == "")
        {
            if (!menu.reactToBackOnToolbar())
            {
                list.state = "";
                menu.state = "hidden";
            }
            return true;
        }
        else
        {
            return false;
        }
    }

    function changeBuilding(buildingName)
    {
        if (buildingName == "Central Unit")
            menu.changeToCentralUnit();
        else if (buildingName == "Hospital")
            menu.changeToHospital();
        else if (buildingName == "Training Ground")
            menu.changeToTrainingGround();
        else if (buildingName == "Gym")
            menu.changeToGym();
        else if (buildingName == "Laboratory")
            menu.changeToLaboratory();
        else if (buildingName == "Playing Field")
            menu.changeToPlayingField();
        else if (buildingName == "Bar")
            menu.changeToBar();
        else if (buildingName == "Shrine")
            menu.changeToShrine();
        else if (buildingName == "Seclusion")
            menu.changeToSeclusion();
        else if (buildingName == "Powerplant")
            menu.changeToPowerplant();
        else if (buildingName == "Factory")
            menu.changeToFactory();
        else if (buildingName == "Cool Room")
            menu.changeToCoolRoom();
        else if (buildingName == "Storage Room")
            menu.changeToStorageRoom();
        else if (buildingName == "Aetherite Silo")
            menu.changeToAetheriteSilo();
        else if (buildingName == "Barracks")
            menu.changeToBarracks();
        else if (buildingName == "Docking Station")
            menu.changeToDockingStation();

        list.state = "hidden";
        menu.state = "";
    }

    function requestUnban(mercenaryName, buildingName)
    {
        menu.requestUnban(mercenaryName, buildingName);
    }

    function acknowledgeConsoleHiding()
    {
        menu.acknowledgeConsoleHiding();
    }

    BuildingsList {
        id: list

        x: 0
        y: 0
        width: root.width
        height: root.height

        onBuildingClicked: {
            changeBuilding(buildingName);
        }
    }

    BuildingMenu {
        id: menu

        x: 0
        y: 0
        width: root.width
        height: root.height

        onBackClickedFwd: {
            list.state = "";
            state = "hidden";
        }

        onUpdateRequestedFromBuildingMenu: {
            updateRequestedFromBuildingsModeGUI();
        }
        onMercenariesModeUpdateRequested: root.mercenariesModeUpdateRequested()
        onMarkAsUpgradedSignal: list.markAsUpgraded(buildingName,true);

        onShowSpecial: parent.showSpecial()

        Component.onCompleted: state = "hidden";
    }

    states: [
        State {
            name: "hiddenLeft"
            PropertyChanges { target: root; x: -1 * width }
        },
        State {
            name: "hiddenRight"
            PropertyChanges { target: root; x: width }
        }
    ]

    transitions: Transition {
        NumberAnimation { id: transitionRoot; properties: "x"; easing.type: Easing.InQuad; duration: baseDuration; property int baseDuration: 250 }
    }
}
