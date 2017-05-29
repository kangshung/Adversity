#ifndef HERO_H
#define HERO_H

#include <QString>
#include <QVector>

#include "equipment.h"

#include <QDebug>

class Mission;

struct HeroEnums
{
    enum Nature
    {
        N_Active,
        N_Convivial,
        N_Religious,
        N_Recluse,
        N_END
    };
    enum StressBorderEffect
    {
        SBE_None,
        SBE_Faint,
        SBE_Desertion,
        SBE_Fear,
        SBE_Rage,
        SBE_FanaticWrath,
        SBE_Paranoia,
        SBE_Bravery,
        SBE_Hopeless,
        SBE_Confusion,
        SBE_END
    };
    enum Attribute
    {
        A_CombatEffectiveness,
        A_Proficiency,
        A_Cleverness,
        A_Luck,
        A_Health,
        A_HealthLimit,
        A_DailyHealthRecovery,
        A_Stress,
        A_StressResistance,
        A_StressLimit,
        A_StressBorder,
        A_DailyStressRecovery,
        A_Salary,
        A_DailyFoodConsumption,
        A_END
    };
    enum CurrentActivity
    {
        CA_Idle,
        CA_OnMission,
        CA_InHospital,
        CA_OnTrainingGround,
        CA_InGym,
        CA_InLaboratory,
        CA_InPlayingField,
        CA_InBar,
        CA_InShrine,
        CA_InSeclusion,
        CA_END
    };
    enum DyingReason
    {
        DR_NoReason,
        DR_AttributeCheckFailed,
        DR_StressLimitAchieved,
        DR_KillEvent,
        DR_END
    };
    enum Profession
    {
        P_BountyHunter,
        P_Gunzerker,
        P_PriestOfTheUniverse,
        P_PriestessOfTheUniverse,
        P_BattleDroid,
        P_SpaceNomad,
        P_Archeologist,
        P_Criminal,
        P_Cyborg,
        P_Specialist,
        P_Doomsayer,
        P_END
    };

    static Nature fromQStringToNatureEnum(const QString &nature) noexcept;
    static QString fromNatureEnumToQString(Nature nature) noexcept;

    static StressBorderEffect fromQStringToStressBorderEffectEnum(const QString &stressBorderEffect) noexcept;
    static QString fromStressBorderEffectEnumToQString(StressBorderEffect stressBorderEffect) noexcept;

    static Attribute fromQStringToAttributeEnum(const QString &attribute) noexcept;
    static QString fromAttributeEnumToQString(Attribute attribute) noexcept;

    static CurrentActivity fromQStringToCurrentActivityEnum(const QString &currentActivity) noexcept;
    static QString fromCurrentActivityEnumToQString(CurrentActivity currentActivity) noexcept;

    static Profession fromQStringToProfessionEnum(const QString &profession) noexcept;
    static QString fromProfessionEnumToQString(Profession profession) noexcept;
};

struct HeroStressBorderEffect
{
    HeroStressBorderEffect() noexcept
        : effectName(HeroEnums::SBE_None) {}
    HeroStressBorderEffect(HeroEnums::StressBorderEffect effectName_, const QVector <QVariant> &effectParams_) noexcept
        : effectName(effectName_), effectParams(effectParams_) {}

    HeroEnums::StressBorderEffect effectName;
    QVector <QVariant> effectParams;

    QDataStream &read(QDataStream &stream) noexcept;
    QDataStream &write(QDataStream &stream) const noexcept;
};

QDataStream &operator<<(QDataStream &stream, const HeroStressBorderEffect &effect) noexcept;
QDataStream &operator>>(QDataStream &stream, HeroStressBorderEffect &effect) noexcept;

struct HeroAttributesSet
{
    HeroAttributesSet() noexcept
        : combatEffectiveness(0), proficiency(0), cleverness(0), luck(0), health(1), healthLimit(1), dailyHealthRecovery(0), stress(0), stressResistance(0), stressLimit(1), stressBorder(1), dailyStressRecovery(0), salary(0), dailyFoodConsumption(0) {}

    int combatEffectiveness;
    int proficiency;
    int cleverness;

    float luck;

    int health;
    int healthLimit;
    int dailyHealthRecovery;

    int stress;
    float stressResistance;
    int stressLimit;
    int stressBorder;
    int dailyStressRecovery;

    int salary;
    int dailyFoodConsumption;
};

QDataStream &operator<<(QDataStream &stream, const HeroAttributesSet &attrs) noexcept;
QDataStream &operator>>(QDataStream &stream, HeroAttributesSet &attrs) noexcept;

class Hero : public QObject
{
    Q_OBJECT

    friend class HeroBuilder;
    friend class KillHeroEventResult;
    friend class QDataStream;
public:
    Q_INVOKABLE QString name() const noexcept
    {
        return m_name;
    }

    Q_INVOKABLE int combatEffectiveness() const noexcept
    {
        return m_currentAttributesValues.combatEffectiveness;
    }
    Q_INVOKABLE int proficiency() const noexcept
    {
        return m_currentAttributesValues.proficiency;
    }
    Q_INVOKABLE int cleverness() const noexcept
    {
        return m_currentAttributesValues.cleverness;
    }

    Q_INVOKABLE float luck() const noexcept
    {
        return m_currentAttributesValues.luck;
    }

    Q_INVOKABLE int health() const noexcept
    {
        return m_currentAttributesValues.health;
    }
    Q_INVOKABLE int healthLimit() const noexcept
    {
        return m_currentAttributesValues.healthLimit;
    }
    Q_INVOKABLE int dailyHealthRecovery() const noexcept
    {
        return m_currentAttributesValues.dailyHealthRecovery;
    }

    Q_INVOKABLE int stress() const noexcept
    {
        return m_currentAttributesValues.stress;
    }
    Q_INVOKABLE float stressResistance() const noexcept
    {
        return m_currentAttributesValues.stressResistance;
    }
    Q_INVOKABLE int stressLimit() const noexcept
    {
        return m_currentAttributesValues.stressLimit;
    }
    Q_INVOKABLE int stressBorder() const noexcept
    {
        return m_currentAttributesValues.stressBorder;
    }
    const HeroStressBorderEffect &stressBorderEffect() const noexcept
    {
        return m_stressBorderEffect;
    }
    Q_INVOKABLE QString stressBorderEffectNameString() const noexcept
    {
        return HeroEnums::fromStressBorderEffectEnumToQString(m_stressBorderEffect.effectName);
    }
    Q_INVOKABLE int dailyStressRecovery() const noexcept
    {
        return m_currentAttributesValues.dailyStressRecovery;
    }

    Q_INVOKABLE int salary() const noexcept
    {
        return m_currentAttributesValues.salary;
    }

    Q_INVOKABLE int dailyFoodConsumption() const noexcept
    {
        return m_currentAttributesValues.dailyFoodConsumption;
    }

    HeroEnums::Nature nature() const noexcept
    {
        return m_nature;
    }
    Q_INVOKABLE QString natureString() const noexcept
    {
        return HeroEnums::fromNatureEnumToQString(m_nature);
    }

    HeroEnums::Profession profession() const noexcept
    {
        return m_profession;
    }
    Q_INVOKABLE QString professionString() const noexcept
    {
        return HeroEnums::fromProfessionEnumToQString(m_profession);
    }

    void changeCombatEffectiveness(int amount) noexcept;//change by amount so increase or decrease by amount, not set amount!
    void changeProficiency(int amount) noexcept;
    void changeCleverness(int amount) noexcept;

    void changeLuck(float amount) noexcept;

    void changeHealth(int amount) noexcept;
    void changeHealthLimit(int amount) noexcept;
    void changeDailyHealthRecovery(int amount) noexcept;

    void increaseStress(unsigned amount) noexcept;//use that
    void decreaseStress(unsigned amount) noexcept;//and that when changing value during playtime
    void changeStressResistance(float amount) noexcept;
    void changeStressLimit(int amount) noexcept;
    void changeStressBorder(int amount) noexcept;
    void changeDailyStressRecovery(int amount) noexcept;

    void changeSalary(int amount) noexcept;

    void changeDailyFoodConsumption(int amount) noexcept;

    Equipment *armor() const noexcept
    {
        return m_armor;
    }
    Equipment *weaponTool(int slot) const noexcept
    {
        return m_weaponsTools.value(slot,nullptr);
    }
    Q_INVOKABLE int amountOfWeaponToolSlots() const noexcept
    {
        return m_amountOfWeaponToolSlots;
    }

    void equipArmor(Equipment *armor) noexcept;
    void unequipArmor() noexcept;
    void equipWeaponTool(Equipment *weaponTool, int slot) noexcept;
    void unequipWeaponTool(int slot) noexcept;

    Q_INVOKABLE bool isDead() const noexcept
    {
        return m_isDead;
    }
    void setIsDead(bool isDead) noexcept
    {
        m_isDead = isDead;
    }

    Q_INVOKABLE int noSignalDaysRemaining() const noexcept
    {
        return m_noSignalDaysRemaining;
    }
    void setNoSignalDaysRemaining(int noSignalDaysRemaining) noexcept
    {
        m_noSignalDaysRemaining = noSignalDaysRemaining;
    }

    Q_INVOKABLE int carriedEnergy() const noexcept
    {
        return m_carriedEnergy;
    }
    void setCarriedEnergy(int carriedEnergy) noexcept;

    Q_INVOKABLE int carriedFoodSupplies() const noexcept
    {
        return m_carriedFoodSupplies;
    }
    void setCarriedFoodSupplies(int carriedFoodSupplies) noexcept;

    Q_INVOKABLE int carriedBuildingMaterials() const noexcept
    {
        return m_carriedBuildingMaterials;
    }
    void setCarriedBuildingMaterials(int carriedBuildingMaterials) noexcept;

    Q_INVOKABLE int carriedAetheriteOre() const noexcept
    {
        return m_carriedAetheriteOre;
    }
    void setCarriedAetheriteOre(int carriedAetheriteOre) noexcept;

    Mission *assignedMission() noexcept
    {
        return m_assignedMission;
    }
    void assignMission(Mission *mission) noexcept;

    HeroEnums::CurrentActivity currentActivity() const noexcept
    {
        return m_currentActivity;
    }
    Q_INVOKABLE QString currentActivityString() const noexcept
    {
        return HeroEnums::fromCurrentActivityEnumToQString(m_currentActivity);
    }
    void setCurrentActivity(HeroEnums::CurrentActivity activity) noexcept;

    QDataStream &read(QDataStream &stream) noexcept;
    QDataStream &write(QDataStream &stream) const noexcept;

private:
    Hero() noexcept;

    void setName(const QString &name) noexcept
    {
        m_name=name;
    }
    void setStressBorderEffect(const HeroStressBorderEffect &stressBorderEffect) noexcept
    {
        m_stressBorderEffect=stressBorderEffect;
    }
    void setNature(HeroEnums::Nature nature) noexcept
    {
        m_nature=nature;
    }
    void setProfession(HeroEnums::Profession profession) noexcept
    {
        m_profession=profession;
    }

    void activateStressBorderEffect() noexcept;
    void deactivateStressBorderEffect() noexcept;

    void die(HeroEnums::DyingReason reason = HeroEnums::DR_NoReason) noexcept;

    void setArmor(Equipment *armor) noexcept;
    void setWeaponTool(Equipment *weaponTool, int slot) noexcept;

    void applyEquipmentEffect() noexcept;
    void unapplyEquipmentEffect() noexcept
    {
        applyEquipmentEffect();
    }

    void calculateCurrentAttributeValue(HeroEnums::Attribute attributeName) noexcept;
    void calculateCurrentAttributeValues() noexcept;

    QString m_name;

    HeroAttributesSet m_baseAttributesValues;
    HeroAttributesSet m_currentAttributesValues;//including eq bonuses, SBE impact
    HeroStressBorderEffect m_stressBorderEffect;
    HeroEnums::Nature m_nature;
    HeroEnums::Profession m_profession;

    Equipment *m_armor;
    QVector <Equipment *> m_weaponsTools;
    const int m_amountOfWeaponToolSlots = 2;

    bool m_isDead;
    bool m_isStressBorderEffectActive;

    int m_noSignalDaysRemaining;

    int m_carriedEnergy;
    int m_carriedFoodSupplies;
    int m_carriedBuildingMaterials;
    int m_carriedAetheriteOre;

    Mission *m_assignedMission;
    HeroEnums::CurrentActivity m_currentActivity;
};

QDataStream &operator<<(QDataStream &stream, const Hero &hero) noexcept;
QDataStream &operator>>(QDataStream &stream, Hero &hero) noexcept;

struct HeroDataHelper
{
    QString m_name;

    HeroAttributesSet m_baseAttributesValues;
    HeroAttributesSet m_currentAttributesValues;
    HeroStressBorderEffect m_stressBorderEffect;
    HeroEnums::Nature m_nature;
    HeroEnums::Profession m_profession;

    QString m_armor;
    QVector <QString> m_weaponsTools;

    bool m_isDead;
    bool m_isStressBorderEffectActive;

    int m_noSignalDaysRemaining;

    int m_carriedEnergy;
    int m_carriedFoodSupplies;
    int m_carriedBuildingMaterials;
    int m_carriedAetheriteOre;

    Mission *m_assignedMission;//TODO missions
    HeroEnums::CurrentActivity m_currentActivity;
};

class HeroBuilder
{
public:
    HeroBuilder() noexcept;
    ~HeroBuilder() noexcept;

    Hero *getHero() noexcept;

    Hero *qobjectifyHeroData(const HeroDataHelper &hero) noexcept;
    HeroDataHelper antiqobjectifyHero(Hero *hero) noexcept;

    void resetHero() noexcept;

    void setName(const QString &name) noexcept
    {
        m_hero->setName(name);
    }

    void setCombatEffectiveness(int combatEffectiveness) noexcept
    {
        if (combatEffectiveness>=0)
            m_hero->m_baseAttributesValues.combatEffectiveness=combatEffectiveness;
    }
    void setProficiency(int proficiency) noexcept
    {
        if (proficiency>=0)
            m_hero->m_baseAttributesValues.proficiency=proficiency;
    }
    void setCleverness(int cleverness) noexcept
    {
        if (cleverness>=0)
            m_hero->m_baseAttributesValues.cleverness=cleverness;
    }

    void setLuck(float luck) noexcept
    {
        if (luck>=0 && luck<=1)
            m_hero->m_baseAttributesValues.luck=luck;
    }

    void setHealth(int health) noexcept
    {
        if (health>=0)
            m_hero->m_currentAttributesValues.health=health;
    }
    void setHealthLimit(int healthLimit) noexcept
    {
        if (healthLimit>0)
            m_hero->m_baseAttributesValues.healthLimit=healthLimit;
    }
    void setDailyHealthRecovery(int dailyHealthRecovery) noexcept
    {
        m_hero->m_baseAttributesValues.dailyHealthRecovery=dailyHealthRecovery;
    }

    void setStress(int stress) noexcept
    {
        if (stress>=0)
            m_hero->m_currentAttributesValues.stress=stress;
    }
    void setStressResistance(float stressResistance) noexcept
    {
        if (stressResistance>=0)
            m_hero->m_baseAttributesValues.stressResistance=stressResistance;
    }
    void setStressLimit(int stressLimit) noexcept
    {
        if (stressLimit>0)
            m_hero->m_baseAttributesValues.stressLimit=stressLimit;
    }
    void setStressBorder(int stressBorder) noexcept
    {
        if (stressBorder>=0)
            m_hero->m_baseAttributesValues.stressBorder=stressBorder;
    }
    void setStressBorderEffect(const HeroStressBorderEffect &stressBorderEffect) noexcept
    {
        m_hero->setStressBorderEffect(stressBorderEffect);
    }
    void setDailyStressRecovery(int dailyStressRecovery) noexcept
    {
        m_hero->m_baseAttributesValues.dailyStressRecovery=dailyStressRecovery;
    }

    void setSalary(int salary) noexcept
    {
        m_hero->m_baseAttributesValues.salary=salary;
    }

    void setDailyFoodConsumption(int dailyFoodConsumption) noexcept
    {
        if (dailyFoodConsumption>=0)
            m_hero->m_baseAttributesValues.dailyFoodConsumption=dailyFoodConsumption;
    }

    void setNature(HeroEnums::Nature nature) noexcept
    {
        m_hero->m_nature=nature;
    }

    void setProfession(HeroEnums::Profession profession) noexcept
    {
        m_hero->m_profession=profession;
    }

    void setAndEquipArmor(Equipment *armor) noexcept
    {
        m_hero->equipArmor(armor);
    }
    void setAndEquipWeaponTool(Equipment *weaponTool, unsigned slot) noexcept
    {
        if (slot<m_hero->amountOfWeaponToolSlots())
            m_hero->equipWeaponTool(weaponTool,slot);
    }

    void setIsDead(bool dead) noexcept
    {
        m_hero->m_isDead=dead;
    }
    void setIsSBEActive(bool active) noexcept
    {
        m_hero->m_isStressBorderEffectActive=active;
    }

    void setNoSignalDaysRemaining(unsigned amount) noexcept
    {
        m_hero->m_noSignalDaysRemaining=amount;
    }

    void setCarriedEnergy(int amount) noexcept
    {
        m_hero->m_carriedEnergy=amount;
    }
    void setCarriedFoodSupplies(int amount) noexcept
    {
        m_hero->m_carriedFoodSupplies=amount;
    }
    void setCarriedBuildingMaterials(int amount) noexcept
    {
        m_hero->m_carriedBuildingMaterials=amount;
    }
    void setCarriedAetheriteOre(int amount) noexcept
    {
        m_hero->m_carriedAetheriteOre=amount;
    }

    void setAssignedMission(Mission *mission) noexcept
    {
        m_hero->m_assignedMission=mission;
    }
    void setCurrentActivity(HeroEnums::CurrentActivity activity) noexcept
    {
        m_hero->m_currentActivity=activity;
    }

private:
    Hero *m_hero;
};

class HeroesContainer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Hero* preparedHero MEMBER m_preparedHero)

public:
    HeroesContainer() noexcept;
    ~HeroesContainer() noexcept;

    Q_INVOKABLE bool prepareHeroAt(unsigned index) noexcept;
    void addHero(Hero *hero) noexcept;
    void removeHero(unsigned index) noexcept;
    const QVector <Hero *> &heroes() noexcept
    {
        return m_heroes;
    }
    Q_INVOKABLE int amountOfHeroes() const noexcept
    {
        return m_heroes.size();
    }
    Q_INVOKABLE int findHero(const QString &name) const noexcept;
    Hero *getHero(unsigned index) noexcept
    {
        return m_heroes.value(index,nullptr);
    }

private:
    QVector <Hero *> m_heroes;
    Hero *m_preparedHero;
};

#endif // HERO_H
