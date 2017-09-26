import QtQuick 2.9
import Game 1.0

import "../.."

Item {
    id: root

    width: 1080
    height: 1440

    property string heroName_: ""

    function updateEverything()
    {
        transitionRoot.duration = transitionRoot.baseDuration * GameApi.animMultiplier();

        var am=GameApi.base.heroes.amountOfHeroes();
        var intName = GameApi.globalsCpp.alterNormalTextToInternal(heroName_);
        for (var i=0;i<am;++i)
        {
            GameApi.base.heroes.prepareHeroAt(i);
            if (GameApi.base.heroes.preparedHero.name() == intName)
            {
                if (GameApi.base.heroes.preparedHero.isCommunicationAvailable())
                {
                    delegate.setName(heroName_);
                    delegate.setArtSource(GameApi.base.heroes.preparedHero.pathToArt());
                    delegate.setProfession(GameApi.base.heroes.preparedHero.professionString());

                    var ce=GameApi.base.heroes.preparedHero.combatEffectiveness();
                    var pr=GameApi.base.heroes.preparedHero.proficiency();
                    var cl=GameApi.base.heroes.preparedHero.cleverness();
                    var hp=GameApi.base.heroes.preparedHero.health();
                    var hpMax=GameApi.base.heroes.preparedHero.healthLimit();
                    var st=GameApi.base.heroes.preparedHero.stress();
                    var sr=GameApi.base.heroes.preparedHero.stressResistance();
                    var sl=GameApi.base.heroes.preparedHero.stressLimit();
                    var sa=GameApi.base.heroes.preparedHero.salary();
                    var fc=GameApi.base.heroes.preparedHero.dailyFoodConsumption();

                    var bce=GameApi.base.heroes.preparedHero.baseCombatEffectiveness();
                    var bpr=GameApi.base.heroes.preparedHero.baseProficiency();
                    var bcl=GameApi.base.heroes.preparedHero.baseCleverness();
                    var bhpMax=GameApi.base.heroes.preparedHero.baseHealthLimit();
                    var bsr=GameApi.base.heroes.preparedHero.baseStressResistance();
                    var bsl=GameApi.base.heroes.preparedHero.baseStressLimit();
                    var bsa=GameApi.base.heroes.preparedHero.baseSalary();
                    var bfc=GameApi.base.heroes.preparedHero.baseDailyFoodConsumption();

                    delegate.setCE(ce);
                    delegate.setPR(pr);
                    delegate.setCL(cl);
                    delegate.setHP(hp, hpMax);
                    delegate.setST(st);
                    delegate.setSR(sr);
                    delegate.setSL(sl);
                    delegate.setSA(sa);
                    delegate.setFC(fc);

                    if (hpMax == bhpMax)
                        delegate.setColorHL("#568b56");
                    else if (hpMax > bhpMax)
                        delegate.setColorHL("#439b20");
                    else
                        delegate.setColorHL("#bf0000");

                    if (sl == bsl)
                        delegate.setColorSL("#568b56");
                    else if (sl > bsl)
                        delegate.setColorSL("#439b20");
                    else
                        delegate.setColorSL("#bf0000");

                    if (ce == bce)
                        delegate.setColorCE("#568b56");
                    else if (ce > bce)
                        delegate.setColorCE("#439b20");
                    else
                        delegate.setColorCE("#bf0000");

                    if (pr == bpr)
                        delegate.setColorPR("#568b56");
                    else if (pr > bpr)
                        delegate.setColorPR("#439b20");
                    else
                        delegate.setColorPR("#bf0000");

                    if (cl == bcl)
                        delegate.setColorCL("#568b56");
                    else if (cl > bcl)
                        delegate.setColorCL("#439b20");
                    else
                        delegate.setColorCL("#bf0000");

                    if (sr == bsr)
                        delegate.setColorSR("#568b56");
                    else if (sr > bsr)
                        delegate.setColorSR("#bf0000");
                    else
                        delegate.setColorSR("#439b20");

                    if (fc == bfc)
                        delegate.setColorFC("#568b56");
                    else if (fc > bfc)
                        delegate.setColorFC("#bf0000");
                    else
                        delegate.setColorFC("#439b20");

                    if (sa == bsa)
                        delegate.setColorSA("#568b56");
                    else if (sa > bsa)
                        delegate.setColorSA("#bf0000");
                    else
                        delegate.setColorSA("#439b20");

                    armorArt.source = GameApi.base.heroes.preparedHero.hasArmor() ? GameApi.base.heroes.preparedHero.preparedArmor.pathToArt() : "qrc:/graphics/GUI/Slots/ArmourSlot.png";
                    if (GameApi.base.heroes.preparedHero.hasWeaponToolInSlot(0))
                    {
                        GameApi.base.heroes.preparedHero.prepareWeaponTool(0);
                        weapon1Art.source =  GameApi.base.heroes.preparedHero.preparedWeaponTool.pathToArt();
                        weapon1.name = GameApi.base.heroes.preparedHero.preparedWeaponTool.name();
                    }
                    else
                    {
                        weapon1Art.source = "qrc:/graphics/GUI/Slots/ToolSlot.png";
                        weapon1.name = "";
                    }
                    if (GameApi.base.heroes.preparedHero.hasWeaponToolInSlot(1))
                    {
                        GameApi.base.heroes.preparedHero.prepareWeaponTool(1);
                        weapon2Art.source =  GameApi.base.heroes.preparedHero.preparedWeaponTool.pathToArt();
                        weapon2.name = GameApi.base.heroes.preparedHero.preparedWeaponTool.name();
                    }
                    else
                    {
                        weapon2Art.source = "qrc:/graphics/GUI/Slots/ToolSlot.png";
                        weapon2.name = "";
                    }

                    energyAmount.text = GameApi.base.heroes.preparedHero.carriedEnergy();
                    foodSuppliesAmount.text = GameApi.base.heroes.preparedHero.carriedFoodSupplies();
                    buildingMaterialsAmount.text = GameApi.base.heroes.preparedHero.carriedBuildingMaterials();
                    aetheriteAmount.text = GameApi.base.heroes.preparedHero.carriedAetheriteOre();

                    equipment.visible = true;
                    var eqsAmount = GameApi.base.heroes.preparedHero.carriedEquipmentAmount();
                    if (eqsAmount>=1)
                    {
                        GameApi.base.heroes.preparedHero.prepareCarriedEquipment(eqsAmount-1);
                        eq1Art.source = GameApi.base.heroes.preparedHero.preparedCarriedEquipment.pathToArt();

                        if (eqsAmount>=2)
                        {
                            GameApi.base.heroes.preparedHero.prepareCarriedEquipment(eqsAmount-2);
                            eq2Art.source = GameApi.base.heroes.preparedHero.preparedCarriedEquipment.pathToArt();

                            if (eqsAmount>=3)
                            {
                                GameApi.base.heroes.preparedHero.prepareCarriedEquipment(eqsAmount-3);
                                eq3Art.source = GameApi.base.heroes.preparedHero.preparedCarriedEquipment.pathToArt();

                                if (eqsAmount>=4)
                                {
                                    GameApi.base.heroes.preparedHero.prepareCarriedEquipment(eqsAmount-4);
                                    eq4Art.source = GameApi.base.heroes.preparedHero.preparedCarriedEquipment.pathToArt();

                                    if (eqsAmount>=5)
                                    {
                                        GameApi.base.heroes.preparedHero.prepareCarriedEquipment(eqsAmount-5);
                                        eq5Art.source = GameApi.base.heroes.preparedHero.preparedCarriedEquipment.pathToArt();

                                        if (eqsAmount>=6)
                                        {
                                            GameApi.base.heroes.preparedHero.prepareCarriedEquipment(eqsAmount-6);
                                            eq6Art.source = GameApi.base.heroes.preparedHero.preparedCarriedEquipment.pathToArt();
                                        }
                                        else
                                            eq6Art.source = "";
                                    }
                                    else
                                    {
                                        eq5Art.source = "";
                                        eq6Art.source = "";
                                    }
                                }
                                else
                                {
                                    eq4Art.source = "";
                                    eq5Art.source = "";
                                    eq6Art.source = "";
                                }
                            }
                            else
                            {
                                eq3Art.source = "";
                                eq4Art.source = "";
                                eq5Art.source = "";
                                eq6Art.source = "";
                            }
                        }
                        else
                        {
                            eq2Art.source = "";
                            eq3Art.source = "";
                            eq4Art.source = "";
                            eq5Art.source = "";
                            eq6Art.source = "";
                        }
                    }
                    else
                    {
                        eq1Art.source = "";
                        eq2Art.source = "";
                        eq3Art.source = "";
                        eq4Art.source = "";
                        eq5Art.source = "";
                        eq6Art.source = "";
                    }
                }
                else
                {
                    delegate.setArtSource(GameApi.base.heroes.preparedHero.pathToArt());
                    delegate.setName(heroName_);
                    delegate.setProfession(GameApi.base.heroes.preparedHero.professionString());
                    delegate.setMIA();

                    delegate.setColorHL("#568b56");
                    delegate.setColorSL("#568b56");
                    delegate.setColorCE("#568b56");
                    delegate.setColorPR("#568b56");
                    delegate.setColorCL("#568b56");
                    delegate.setColorSR("#568b56");
                    delegate.setColorFC("#568b56");
                    delegate.setColorSA("#568b56");

                    armorArt.source = GameApi.base.heroes.preparedHero.hasArmor() ? GameApi.base.heroes.preparedHero.preparedArmor.pathToArt() : "qrc:/graphics/GUI/Slots/ArmourSlot.png";
                    if (GameApi.base.heroes.preparedHero.hasWeaponToolInSlot(0))
                    {
                        GameApi.base.heroes.preparedHero.prepareWeaponTool(0);
                        weapon1Art.source =  GameApi.base.heroes.preparedHero.preparedWeaponTool.pathToArt();
                        weapon1.name = GameApi.base.heroes.preparedHero.preparedWeaponTool.name();
                    }
                    else
                    {
                        weapon1Art.source = "qrc:/graphics/GUI/Slots/ToolSlot.png";
                        weapon1.name = "";
                    }
                    if (GameApi.base.heroes.preparedHero.hasWeaponToolInSlot(1))
                    {
                        GameApi.base.heroes.preparedHero.prepareWeaponTool(1);
                        weapon2Art.source =  GameApi.base.heroes.preparedHero.preparedWeaponTool.pathToArt();
                        weapon2.name = GameApi.base.heroes.preparedHero.preparedWeaponTool.name();
                    }
                    else
                    {
                        weapon2Art.source = "qrc:/graphics/GUI/Slots/ToolSlot.png";
                        weapon2.name = "";
                    }

                    energyAmount.text = "?";
                    foodSuppliesAmount.text = "?";
                    buildingMaterialsAmount.text = "?";
                    aetheriteAmount.text = "?";

                    equipment.visible = false;
                }
                break;
            }
        }
    }

    function setHero(heroName)
    {
        heroName_=heroName;
        updateEverything();
    }

    Text {
        x: 4
        y: 0

        color: "#94ef94"
        text: "Mercenary:"
        font.pixelSize: 50
        font.family: fontStencil.name
    }

    HeroDelegate {
        id: delegate

        x: 0
        y: 50
        width: parent.width
        height: 271
    }

    Text {
        x: 520
        y: 322

        color: "#94ef94"
        text: "Equipment:"
        font.pixelSize: 50
        font.family: fontStencil.name
    }

    Item {
        id: armor

        x: 4
        y: delegate.y + delegate.height + 4
        width: 260
        height: width

        Image {
            anchors.fill: parent

            source: "qrc:/graphics/GUI/Task_Picture.png"
        }
        Image {
            id: armorArt

            x: 3
            y: x
            width: 256
            height: width

            source: "qrc:/graphics/GUI/Slots/ArmourSlot.png"
        }
    }
    Item {
        id: weapon1

        x: armor.x
        y: armor.y + armor.height + 4
        width: 260
        height: width

        property string name: ""

        Image {
            anchors.fill: parent

            source: "qrc:/graphics/GUI/Task_Picture.png"
        }
        Image {
            id: weapon1Art

            x: 3
            y: x
            width: 256
            height: width

            source: "qrc:/graphics/GUI/Slots/ToolSlot.png"
        }
    }
    Item {
        id: weapon2

        x: weapon1.x
        y: weapon1.y + weapon1.height + 4
        width: weapon1.width
        height: width

        property string name: ""

        Image {
            anchors.fill: parent

            source: "qrc:/graphics/GUI/Task_Picture.png"
        }
        Image {
            id: weapon2Art

            x: 3
            y: x
            width: 256
            height: width

            source: "qrc:/graphics/GUI/Slots/ToolSlot.png"
        }
    }

    Item {
        id: energy

        x: armor.x + armor.width + 4
        y: (armor.y + armor.height/2 + 80)*0.75

        Image {
            id: energyIcon

            x: 0
            y: 0
            width: 100
            height: width

            source: "qrc:/graphics/GUI/Resources/Energy.png"
        }
        Text {
            id: energyAmount

            x: 280
            y: 0
            width: 240

            color: "#568b56"
            wrapMode: Text.WordWrap
            text: "Energy will probably run out after 10 days."
            font.pixelSize: 60
            font.family: fontStencil.name
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Item {
        id: buildingMaterials

        x: armor.x + armor.width + 4
        y: (weapon1.y + weapon1.height/2 + 80)*0.75

        Image {
            id: buildingMaterialsIcon

            x: -10
            y: -10
            width: 120
            height: width

            source: "qrc:/graphics/GUI/Resources/Buildingmaterials.png"
        }
        Text {
            id: buildingMaterialsAmount

            x: 280
            y: 0
            width: 240

            color: "#568b56"
            wrapMode: Text.WordWrap
            text: "Materials will probably run out after 10 days."
            font.pixelSize: 60
            font.family: fontStencil.name
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Item {
        id: foodSupplies

        x: armor.x + armor.width + 4
        y: (weapon2.y + weapon2.height/2 + 80)*0.75

        Image {
            id: foodSuppliesIcon

            x: 0
            y: -5
            width: 110
            height: width

            source: "qrc:/graphics/GUI/Resources/Foodsupplies.png"
        }
        Text {
            id: foodSuppliesAmount

            x: 280
            y: 0
            width: 240

            color: "#568b56"
            wrapMode: Text.WordWrap
            text: "Food will probably run out after 10 days."
            font.pixelSize: 60
            font.family: fontStencil.name
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Item {
        id: aetherite

        x: armor.x + armor.width + 4
        y: 2*foodSupplies.y-buildingMaterials.y

        Image {
            id: aetheriteIcon

            x: 0
            y: -5
            width: 110
            height: width

            source: "qrc:/graphics/GUI/Resources/Aetherite.png"
        }
        Text {
            id: aetheriteAmount

            x: 280
            y: 0
            width: 240

            color: "#568b56"
            wrapMode: Text.WordWrap
            font.pixelSize: 60
            font.family: fontStencil.name
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Item {
        id: equipment
        x: 20
        y: 1150
        width: parent.width-2*x
        height: 130

        Item {
            id: eq1

            width: height
            height: parent.height

            Image {
                anchors.fill: parent

                source: "qrc:/graphics/GUI/Task_Picture2.png"
            }
            Image {
                id: eq1Art

                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
            }
            MouseArea {
                anchors.fill: parent
            }
        }
        Item {
            id: eq2

            x: 180
            width: height
            height: parent.height

            Image {
                anchors.fill: parent

                source: "qrc:/graphics/GUI/Task_Picture2.png"
            }
            Image {
                id: eq2Art

                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
            }
            MouseArea {
                anchors.fill: parent
            }
        }
        Item {
            id: eq3

            x: 360
            width: height
            height: parent.height

            Image {
                anchors.fill: parent

                source: "qrc:/graphics/GUI/Task_Picture2.png"
            }
            Image {
                id: eq3Art

                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
            }
            MouseArea {
                anchors.fill: parent
            }
        }
        Item {
            id: eq4

            x: 540
            width: height
            height: parent.height

            Image {
                anchors.fill: parent

                source: "qrc:/graphics/GUI/Task_Picture2.png"
            }
            Image {
                id: eq4Art

                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
            }
            MouseArea {
                anchors.fill: parent
            }
        }
        Item {
            id: eq5

            x: 720
            width: height
            height: parent.height

            Image {
                anchors.fill: parent

                source: "qrc:/graphics/GUI/Task_Picture2.png"
            }
            Image {
                id: eq5Art

                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
            }
            MouseArea {
                anchors.fill: parent
            }
        }
        Item {
            id: eq6

            x: 900
            width: height
            height: parent.height

            Image {
                anchors.fill: parent

                source: "qrc:/graphics/GUI/Task_Picture2.png"
            }
            Image {
                id: eq6Art

                x: 1
                y: 1
                width: parent.width-2
                height: parent.height-2
            }
            MouseArea {
                anchors.fill: parent
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
        NumberAnimation { id: transitionRoot; properties: "x"; easing.type: Easing.InQuad; duration: baseDuration; property int baseDuration: 500 }
    }

    FontLoader {
        id: fontStencil

        source: "qrc:/fonts/STENCIL.TTF"
    }
}
