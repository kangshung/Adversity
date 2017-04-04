import QtQuick 2.5

import Game 1.0
import ".."

Item {
    id: root

    readonly property int theoreticalWidth: 1080
    readonly property int theoreticalHeight: 1920

    signal backClicked()
    signal upgradeRequested()

    function updateEverything()
    {
        topBar.setDescription(GameApi.base.powerplant.description());
        topBar.setLevel("Level: "+GameApi.base.powerplant.currentLevel());
        table.update();
        upgradeInfo.update();
    }

    width: 1080
    height: 1920

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

    BuildingsListDelegate {
        id: topBar

        x: 0
        y: 0
        width: 1080*450/parent.width
        height: 271*800/parent.height

        Component.onCompleted: {
            setArtSource("qrc:/graphics/Buildings/Powerplant.png");
            setName("Powerplant");
        }
    }

    Item {
        id: table

        x: 0
        y: topBar.height
        width: parent.width
        height: taskBorderBottom.y + taskBorderBottom.height

        function update()
        {
            energyDrainAmount1.text = GameApi.base.powerplant.basicCostInEnergy()+"/Day";
            maxCyclesAmount1.text = GameApi.base.powerplant.maxCycles()+"/Day";
            aetheriteUsedAmount1.text = GameApi.base.powerplant.useCostInAetheriteSingle();
            productionAmount1.text = 0-GameApi.base.powerplant.productionInEnergySingle();
            maxStorageAmount1.text = GameApi.base.powerplant.energyLimit();

            if (GameApi.base.powerplant.maxLevelReached())
            {
                energyDrainAmount2.text = "-";
                maxCyclesAmount2.text = "-";
                aetheriteUsedAmount2.text = "-";
                productionAmount2.text = "-";
                maxStorageAmount2.text = "-";
            }
            else
            {
                energyDrainAmount2.text = GameApi.base.powerplant.basicCostInEnergyAfterUpgrade()+"/Day";
                maxCyclesAmount2.text = GameApi.base.powerplant.maxCyclesAfterUpgrade()+"/Day";
                aetheriteUsedAmount2.text = GameApi.base.powerplant.useCostInAetheriteSingleAfterUpgrade();
                productionAmount2.text = 0-GameApi.base.powerplant.productionInEnergySingleAfterUpgrade();
                maxStorageAmount2.text = GameApi.base.powerplant.energyLimitAfterUpgrade();
            }
        }

        Text {
            id: levelText1

            x: 15
            y: 0

            color: "#94ef94"
            text: "Level: "
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 70
            font.family: fontStencil.name
        }
        Text {
            id: levelText2

            x: 490
            y: 0

            color: "#94ef94"
            text: "Current"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 70
            font.family: fontStencil.name
        }
        Text {
            id: levelText3

            x: 860
            y: 0

            color: "#94ef94"
            text: "Next"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 70
            font.family: fontStencil.name
        }

        Text {
            id: energyDrainText

            x: 15
            y: 64

            color: "#94ef94"
            text: "Energy Drain"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: energyDrainIcon

            x: 430
            y: 64
            width: 66
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Energy.png"
        }
        Text {
            id: energyDrainAmount1

            x: 530
            y: 64
            width: 230

            color: "#94ef94"
            text: "100/Day"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Text {
            id: energyDrainAmount2

            x: 830
            y: 64
            width: 230

            color: "#94ef94"
            text: "100/Day"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }

        Text {
            id: maxCyclesText

            x: 15
            y: 128

            color: "#94ef94"
            text: "Cycles Limit"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: maxCyclesIcon

            x: 430
            y: 128
            width: 66
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Settings.png"
        }
        Text {
            id: maxCyclesAmount1

            x: 560
            y: 128
            width: 200

            color: "#94ef94"
            text: "10/Day"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Text {
            id: maxCyclesAmount2

            x: 860
            y: 128
            width: 200

            color: "#94ef94"
            text: "10/Day"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }

        Text {
            id: aetheriteUsedText

            x: 15
            y: 192

            color: "#94ef94"
            text: "Aetherite"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: aetheriteUsedIcon

            x: 430
            y: 192
            width: 66
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Aetherite.png"
        }
        Text {
            id: aetheriteUsedAmount1

            x: 640
            y: 192

            color: "#94ef94"
            text: "1"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Text {
            id: aetheriteUsedAmount2

            x: 940
            y: 192

            color: "#94ef94"
            text: "1"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }

        Text {
            id: productionText

            x: 15
            y: 256

            color: "#94ef94"
            text: "Production"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: productionIcon

            x: 430
            y: 256
            width: 66
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Energy.png"
        }
        Text {
            id: productionAmount1

            x: 620
            y: 256
            width: 77

            color: "#94ef94"
            text: "10"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Text {
            id: productionAmount2

            x: 920
            y: 256
            width: 77

            color: "#94ef94"
            text: "10"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }

        Text {
            id: maxStorageText

            x: 15
            y: 310

            color: "#94ef94"
            text: "Max Storage"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: maxStorageIcon

            x: 430
            y: 310
            width: 66
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Energy.png"
        }
        Text {
            id: maxStorageAmount1

            x: 570
            y: 310
            width: 180

            color: "#94ef94"
            text: "10000"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Text {
            id: maxStorageAmount2

            x: 870
            y: 310
            width: 180

            color: "#94ef94"
            text: "10000"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 60
            font.family: fontStencil.name
        }

        Image {
            id: taskBorderBottom

            x: 17
            y: 390

            width: 1048
            height: 3

            source: "qrc:/graphics/GUI/Task_Border.png"
        }
    }

    Item {
        id: upgradeInfo

        x: 0
        y: table.y + table.height
        width: 1080
        height: 200

        function update()
        {
            if (GameApi.base.powerplant.maxLevelReached())
            {
                energyAmount.text = "-";
                bmAmount.text = "-";
                timeAmount.text = "-";
                upgradeButton.markAsUpgraded(false);
                upgradeButton.visible = false;
                timeRemaining.visible = true;
                timeRemaining.text = "Max Level Reached";
                timeRemainingIcon.visible = false;
            }
            else
            {
                energyAmount.text = GameApi.base.powerplant.requirementsForNextLevelEnergy();
                bmAmount.text = GameApi.base.powerplant.requirementsForNextLevelBM();
                timeAmount.text = GameApi.base.powerplant.requirementsForNextLevelTime();
                if (GameApi.base.powerplant.isBeingUpgraded())
                {
                    upgradeButton.markAsUpgraded(true);
                    timeRemaining.time = GameApi.base.powerplant.upgradeTimeRemaining();
                    timeRemaining.visible = true;
                    timeRemainingIcon.visible = true;
                }
                else
                {
                    upgradeButton.markAsUpgraded(false);
                    timeRemaining.visible = false;
                    timeRemainingIcon.visible = false;
                }
                energyAmount.text = GameApi.base.powerplant.requirementsForNextLevelEnergy();
                bmAmount.text = GameApi.base.powerplant.requirementsForNextLevelBM();
                timeAmount.text = GameApi.base.powerplant.requirementsForNextLevelTime();
            }
        }

        Text {
            id: upgradeText

            x: 15
            y: 0

            color: "#94ef94"
            text: "Upgrade: "
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 70
            font.family: fontStencil.name
        }

        Text {
            id: energyAmount

            x: 360
            y: 5
            width: 100

            color: "#94ef94"
            text: "100"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: energyIcon

            x: 450
            y: 5

            width: 70
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Energy.png"
        }

        Text {
            id: bmAmount

            x: 520
            y: 5
            width: 100

            color: "#94ef94"
            text: "100"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: bmIcon

            x: 620
            y: 0

            width: 80
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Buildingmaterials.png"
        }

        Text {
            id: timeAmount

            x: 700
            y: 5
            width: 100

            color: "#94ef94"
            text: "100"
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 60
            font.family: fontStencil.name
        }
        Image {
            id: timeIcon

            x: 810
            y: 5

            width: 70
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Time.png"
        }

        Text {
            id: timeRemaining

            property int time: 100

            x: 15
            y: 95

            color: "#94ef94"
            text: "Upgrade will be finished in "+time
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 48
            font.family: fontStencil.name
        }
        Image {
            id: timeRemainingIcon

            x: 820
            y: 95

            width: 60
            height: width / Globals.mainAreaHToWindowHRatio

            source: "qrc:/graphics/GUI/Time.png"
        }

        Image {
            id: taskBorderUpgradeBottom

            x: 17
            y: 165

            width: 1048
            height: 3

            source: "qrc:/graphics/GUI/Task_Border.png"
        }

        Item {
            id: upgradeButton

            x: 920
            y: 0
            width: 160
            height: width / Globals.mainAreaHToWindowHRatio

            function markAsUpgraded(isUpgraded)
            {
                if (isUpgraded)
                    anim.restart();
                else
                    anim.stop();
            }

            Image {
                id: upgradeButtonIcon

                property alias anim: anim

                anchors.fill: parent

                source: "qrc:/graphics/GUI/Settings.png"

                RotationAnimator on rotation {
                    id: anim

                    from: 0
                    to: 360
                    duration: 2500
                    loops: RotationAnimation.Infinite
                    running: false
                }
            }

            MouseArea {
                id: upgradeButtonMA

                anchors.fill: parent

                onClicked: upgradeRequested()
            }
        }
    }

    Item {
        id: back

        x: 400
        y: 1800
        width: 260
        height: 120

        Text {
            id: backText

            anchors.fill: parent
            color: "#94ef94"
            text: qsTr("Back")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 100
            font.family: fontStencil.name
        }
        MouseArea {
            id: backButton

            anchors.fill: parent

            onClicked: backClicked()
        }
    }

    FontLoader {
        id: fontStencil

        source: "qrc:/fonts/STENCIL.TTF"
    }
}
