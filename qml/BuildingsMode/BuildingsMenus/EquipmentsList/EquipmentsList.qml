import QtQuick 2.9

import "qrc:/qml/BuildingsMode/BuildingsMenus/EquipmentsList/EquipmentsListScripts.js" as Scripts
import "../../.."
import "../.."
import Game 1.0

Item {
    id: rootEquipmentsList

    function update()
    {
        Scripts.setupList(Math.round((271/1080)*width), GameApi.base.equipment.amountOfAvailableEquipment(), width, height);
        for (var i=0;i<GameApi.base.equipment.amountOfAvailableEquipment();++i)
        {
            GameApi.base.equipment.prepareAvailableEquipment(i);

            var n=["","","","","",""],v=[0,0,0,0,0,0];
            if (GameApi.base.equipment.preparedAvailableEquipment.amountOfBonuses() >= 1)
            {
                n[0]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosName(0);
                v[0]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosValue(0);
            }
            if (GameApi.base.equipment.preparedAvailableEquipment.amountOfBonuses() >= 2)
            {
                n[1]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosName(1);
                v[1]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosValue(1);
            }
            if (GameApi.base.equipment.preparedAvailableEquipment.amountOfBonuses() >= 3)
            {
                n[2]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosName(2);
                v[2]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosValue(2);
            }
            if (GameApi.base.equipment.preparedAvailableEquipment.amountOfBonuses() >= 4)
            {
                n[3]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosName(3);
                v[3]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosValue(3);
            }
            if (GameApi.base.equipment.preparedAvailableEquipment.amountOfBonuses() >= 5)
            {
                n[4]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosName(4);
                v[4]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosValue(4);
            }
            if (GameApi.base.equipment.preparedAvailableEquipment.amountOfBonuses() >= 6)
            {
                n[5]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosName(5);
                v[5]=GameApi.base.equipment.preparedAvailableEquipment.bonusAtPosValue(5);
            }

            for (var j=0;j<6;++j)
                if (n[j]=="Luck" || n[j]=="Stress Border")
                {
                    for (var k=j+1;k<6;++k)
                    {
                        n[k-1]=n[k];
                        v[k-1]=v[k];
                    }
                    n[5]="";
                    v[5]="";
                }

            Scripts.createItem(GameApi.base.equipment.preparedAvailableEquipment.name(), GameApi.base.equipment.preparedAvailableEquipment.name(), GameApi.base.equipment.preparedAvailableEquipment.typeString(), GameApi.base.equipment.preparedAvailableEquipment.tier(),
                    n,v);
        }
    }

    function returnToDefault()
    {
        Scripts.scrollList(3000);
    }

    property int startY

    clip: true

    signal selected(string name, string artSource)

    Rectangle {
        id: additionalBackground

        anchors.fill: parent

        color: "#171717"
    }

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
}
