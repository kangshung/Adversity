import QtQuick 2.9
import QtQuick.Window 2.3

import Game 1.0
import "."

Window {
    id: win

    property int currentMode: 0

    color: "black"

    function changeMode(mode)
    {
        mainGUI.reportsList.state = "hidden";
        mainGUI.settings.hide();

        if (currentMode == 0)
        {
            mainGUI.missionsGUI.returnToDefault();
        }
        else if (currentMode == 1)
        {
            mainGUI.buildingsGUI.returnToDefault();
        }
        else if (currentMode == 2)
        {
            mainGUI.mercenariesGUI.returnToDefault();
        }

        currentMode = mode;

        if (mode == 0)
        {
            mainGUI.missionsGUI.state = "";
            mainGUI.buildingsGUI.state = "hiddenRight";
            mainGUI.mercenariesGUI.state = "hiddenRight2";
        }
        else if (mode == 1)
        {
            mainGUI.missionsGUI.state = "hiddenLeft";
            mainGUI.buildingsGUI.state = "";
            mainGUI.mercenariesGUI.state = "hiddenRight";
        }
        else if (mode == 2)
        {
            mainGUI.missionsGUI.state = "hiddenLeft2";
            mainGUI.buildingsGUI.state = "hiddenLeft";
            mainGUI.mercenariesGUI.state = "";
        }
    }

    function updateEverything()
    {
        mainGUI.updateEverything();
    }

    function showReportNotification()
    {
        mainGUI.reportsNotification.setAmount(GameApi.base.reports.amountOfNewReports());
        mainGUI.reportsNotification.show();
    }

    //for h4x
    property alias gameTimerInterval: gameTimer.interval
    property alias gameTimerRunning: gameTimer.running

    property alias enableFPSCounter: mainGUI.enableFPSCounter

    visible: true
    width: 450
    height: 800
    title: "Adversity"

    onWidthChanged: Globals.windowWidth = width;
    onHeightChanged: Globals.windowHeight = height;

    MainGUI {
        id: mainGUI

        visible: false

        function updateResources()
        {
            energyValue.text = GameApi.base.resources.currentEnergyAmount() + '/' + GameApi.base.buildings.powerplant.energyLimit();
            if (GameApi.base.resources.currentEnergyAmount() === 0)
                energyValue.color = "#b30000";
            else if (GameApi.base.resources.currentEnergyAmount() === GameApi.base.buildings.powerplant.energyLimit())
                energyValue.color = "#ffd480";
            else
                energyValue.color = "#c0efc0";

            foodSuppliesValue.text = GameApi.base.resources.currentFoodSuppliesAmount() + '/' + GameApi.base.buildings.coolRoom.foodSuppliesLimit();
            if (GameApi.base.resources.currentFoodSuppliesAmount() === 0)
                foodSuppliesValue.color = "#b30000";
            else if (GameApi.base.resources.currentFoodSuppliesAmount() === GameApi.base.buildings.coolRoom.foodSuppliesLimit())
                foodSuppliesValue.color = "#ffd480";
            else
                foodSuppliesValue.color = "#c0efc0";

            buildingMaterialsValue.text = GameApi.base.resources.currentBuildingMaterialsAmount() + '/' + GameApi.base.buildings.storageRoom.buildingMaterialsLimit();
            if (GameApi.base.resources.currentBuildingMaterialsAmount() === 0)
                buildingMaterialsValue.color = "#b30000";
            else if (GameApi.base.resources.currentBuildingMaterialsAmount() === GameApi.base.buildings.storageRoom.buildingMaterialsLimit())
                buildingMaterialsValue.color = "#ffd480";
            else
                buildingMaterialsValue.color = "#c0efc0";

            aetheriteValue.text = GameApi.base.resources.currentAetheriteAmount() + '/' + GameApi.base.buildings.aetheriteSilo.aetheriteLimit();
            if (GameApi.base.resources.currentAetheriteAmount() === 0)
                aetheriteValue.color = "#b30000";
            else if (GameApi.base.resources.currentAetheriteAmount() === GameApi.base.buildings.aetheriteSilo.aetheriteLimit())
                aetheriteValue.color = "#ffd480";
            else
                aetheriteValue.color = "#c0efc0";

            energyValue2.text = GameApi.base.resources.currentEnergyIncome() + '/' + "day";
            foodSuppliesValue2.text = GameApi.base.resources.currentFoodSuppliesIncome() + '/' + "day";
            buildingMaterialsValue2.text = GameApi.base.resources.currentBuildingMaterialsIncome() + '/' + "day";
            aetheriteValue2.text = GameApi.base.resources.currentAetheriteIncome() + '/' + "day";
        }

        function updateClock()
        {
            dayValue.text = "Day " + GameApi.base.gameClock.currentDay();

            hourValue.text = (GameApi.base.gameClock.currentHour() < 10 ?
                                  '0' + GameApi.base.gameClock.currentHour() :
                                  GameApi.base.gameClock.currentHour())
                    + ':' +
                    (GameApi.base.gameClock.currentMin() < 10 ?
                         '0' + GameApi.base.gameClock.currentMin() :
                         GameApi.base.gameClock.currentMin());
        }

        function updateMainContent()
        {
            mainGUI.buildingsGUI.updateEverything();
            mainGUI.mercenariesGUI.updateEverything();
            mainGUI.missionsGUI.updateEverything();
        }

        function updateEverything()
        {
            updateResources();
            updateClock();
            updateMainContent();
            reportsList.updateEverything();
            settings.update();
        }

        transform: [
            Scale {
                id: scale

                xScale: win.width/mainGUI.width
                yScale: win.height/mainGUI.height
            },
            Translate {
                x: (win.width-mainGUI.width*scale.xScale)/2
                y: (win.height-mainGUI.height*scale.yScale)/2
            }
        ]

        missionsButton.onClicked: changeMode(0);
        baseButton.onClicked: changeMode(1);
        mercenariesButton.onClicked: changeMode(2);

        buildingsGUI.onUpdateRequestedFromBuildingsModeGUI: updateEverything();
        mercenariesGUI.onUpdateRequestedFromMercenariesModeGUI: updateEverything();

        buildingsGUI.onMercenariesModeUpdateRequested: mercenariesGUI.updateEverything();
        missionsGUI.onMercenariesModeUpdateRequested: mercenariesGUI.updateEverything();

        missionsGUI.onResourcesUpdateRequested: updateResources();

        buildingsGUI.onShowSpecial: h4xScreen.visible = true;
        h4xScreen.onHiding: buildingsGUI.acknowledgeConsoleHiding();

        mercenariesGUI.onBuildingMenuRequested: {
            changeMode(1);
            buildingsGUI.changeBuilding(buildingName);
        }

        mercenariesGUI.onDismissClickedFwd: mercenaryDismissConfirmDialog.show()
        mercenariesGUI.onDismissDialogHidingRequested: mercenaryDismissConfirmDialog.hide()
        mercenaryDismissConfirmDialog.onAccepted: mercenariesGUI.dismissMercenaryFwd()
        mercenaryDismissConfirmDialog.onDeclined: mercenariesGUI.acknowledgeConfirmDialogClosing()
        mercenariesGUI.onUnbanRequested: buildingsGUI.requestUnban(mercenaryName, buildingName)

        mercenariesGUI.onArtPreviewRequested: mercenaryArtPreview.show(artSource)
        mercenariesGUI.onArtPreviewHidingRequested: mercenaryArtPreview.hide()
        mercenaryArtPreview.onClosing: mercenariesGUI.acknowledgeArtPreviewClosing()

        settingsButton.onClicked: settings.show();
        settings.onBackClicked: settings.hide();

        onEnableFPSCounterChanged: settings.acknowledgeFPSToggle(enableFPSCounter);

        reportsNotification.onClicked: {
            reportsList.updateEverything();
            reportsList.state = "";
        }
        reportsOpener.onClicked: {
            reportsList.updateEverything();
            reportsList.state = "";
        }
        reportsList.onBackClicked: {
            reportsList.state = "hidden";
        }
    }

    Timer {
        id: gameTimer

        interval: 625
        running: false
        repeat: true
        onTriggered: {
            GameApi.base.gameClock.updateClock();
            mainGUI.updateClock();
            if (GameApi.base.gameClock.hasDayChangedLately())
            {
                mainGUI.updateEverything();
            }
        }
    }

    SplashScreen {
        id: splash

        anchors.fill: parent

        minDurationInMs: 1500
        splashDisappearAnimationDuration: 500
        canCloseRefreshingRateInMs: 100
        canClose: false
        splashImageSource: "qrc:/graphics/splash.png"

        onShowing: mainGUI.visible = false;
        onHiding: {
            gameTimer.running = true;
            mainGUI.updateEverything();
            mainGUI.visible = true;
            console.info("[",Math.floor(GameApi.startupTimerElapsed()/1000),'.',('00' + GameApi.startupTimerElapsed()%1000).substr(-3),"] Splash screen has started hiding");
            console.info("[",Math.floor((GameApi.startupTimerElapsed()+splashDisappearAnimationDuration)/1000),'.',('00' + (GameApi.startupTimerElapsed()+splashDisappearAnimationDuration)%1000).substr(-3),"] Splash screen has hidden");
        }
    }

    Component.onCompleted: {
        splash.show();
        Globals.windowWidth = width;
        Globals.windowHeight = height;
        GameApi.savesManager.loadSave("A",""); // doesn't create new saves, needs to be soon replaced
        changeMode(1);
        splash.canClose = true;
        console.info("[",Math.floor(GameApi.startupTimerElapsed()/1000),'.',('00' + GameApi.startupTimerElapsed()%1000).substr(-3),"] Main QML component has been built");
    }
    onClosing: {
        if (mainGUI.h4xScreen.visible)
        {
            mainGUI.h4xScreen.visible = false;
            mainGUI.h4xScreen.cursorLoseFocus();
            close.accepted = false;
        }
        else
        {
            if (mainGUI.settings.state == "")
            {
                if (!mainGUI.settings.reactToBackOnToolbar())
                    mainGUI.settings.state = "hidden";
                close.accepted = false;
            }
            else if (mainGUI.reportsList.state == "")
            {
                if (!mainGUI.reportsList.reactToBackOnToolbar())
                    mainGUI.reportsList.state = "hidden";
                close.accepted = false;
            }
            else if (currentMode == 0)
            {
                if (mainGUI.missionsGUI.reactToBackOnToolbar())
                    close.accepted = false;
                else
                {
                    GameApi.saveBase();
                }
            }
            else if (currentMode == 1)
            {
                if (mainGUI.buildingsGUI.reactToBackOnToolbar())
                    close.accepted = false;
                else
                {
                    GameApi.saveBase();
                }
            }
            else if (currentMode == 2)
            {
                if (mainGUI.mercenariesGUI.reactToBackOnToolbar())
                    close.accepted = false;
                else
                {
                    GameApi.saveBase();
                }
            }
        }
    }
}
