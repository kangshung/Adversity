#ifndef EVENT_H
#define EVENT_H

#include <QMap>
#include <QVector>
#include <QJSEngine>

#include "hero.h"
#include "equipment.h"
#include "base.h"
#include "timer.h"

#include <QDebug>

namespace Randomizer
{
    static void initialize() noexcept
    {
        qsrand(static_cast<quint64>(QTime::currentTime().msecsSinceStartOfDay()));
    }
    static unsigned randomBetweenAAndB(unsigned a, unsigned b) noexcept
    {
        return {qrand() % ((b + 1) - a) + a};
    }
}

struct EventEnums
{
    enum Action
    {
        A_Null,
        A_GiveHealth,
        A_GiveStress,
        A_ModifyAttribute,
        A_KillHero,
        A_AddEquipment,
        A_RemoveEquipment,
        A_GiveResource,
        A_NoSignal,
        A_END
    };
    enum Check
    {
        C_ValueCheck,
        C_EquipmentCheck,
        C_END
    };
    enum Type
    {
        T_Multi,
        T_Action,
        T_Check,
        T_Possibility,
        T_END
    };
    enum MissionDifficulty
    {
        MD_Short,
        MD_Medium,
        MD_Long,
        MD_Extreme,
        MD_Veteran,
        MD_Master,
        MD_Heroic,
        MD_END
    };

    static MissionDifficulty fromQStringToMissionDifficultyEnum(const QString &missionDifficulty) noexcept;
    static QString fromMissionDifficultyEnumToQString(MissionDifficulty missionDifficulty) noexcept;
};

class Expression
{
public:
    Expression() noexcept;
    Expression(const QString &expr) noexcept;
    Expression(const Expression &other) noexcept;

    inline explicit operator QString() const noexcept
    {
        return m_expr;
    }

    void set(const QString &expr) noexcept;

    bool isValid() const noexcept;

    QVariant evaluate(const Hero *context) const noexcept;

private:
    void validateExpr() noexcept;
    void handleEngine() noexcept;

    QString m_expr;
    bool m_isExprValid;
    QJSEngine *m_engine;
};

class ValueRange
{
public:
    ValueRange(const Expression &min, const Expression &max) noexcept;
    ValueRange(const Expression &value) noexcept;

    inline Expression min() const noexcept
    {
        return m_min;
    }
    inline Expression max() const noexcept
    {
        return m_max;
    }

    inline bool singleValue() const noexcept
    {
        return static_cast<QString>(m_min)==static_cast<QString>(m_max);
    }

private:
    Expression m_min, m_max;
};

typedef RBoundedValue<int, 0, 100, false> Chance;

typedef QString EventReport;

class Event
{
public:
    inline EventEnums::Type eventType() const noexcept
    {
        return m_eventType;
    }
    inline QString eventText() const noexcept
    {
        return m_eventText;
    }
    inline QVector <QString> unlockedDatabaseEntries() const noexcept
    {
        return m_unlockedDatabaseEntries;
    }

    QVector <EventReport> execute(Hero *context) noexcept;

protected:
    explicit Event(EventEnums::Type eventType) noexcept
        : m_eventType(eventType) {}

    void setEventText(const QString &text) noexcept;

private:
    void unlockDatabaseEntries(Hero *context) noexcept;
    virtual QVector <EventReport> executeSpecificOps(Hero *context) noexcept = 0;

    EventEnums::Type m_eventType;
    QString m_eventText;
    QVector <QString> m_unlockedDatabaseEntries;
};

class MultiEvent final : public Event
{
public:
    MultiEvent(const QVector <Event *> &events) noexcept
        : Event(EventEnums::T_Multi), m_eventsToExecute(events) {}

    QVector <EventReport> executeSpecificOps(Hero *context) noexcept final;

private:
    QVector <Event *> m_eventsToExecute;
};

class ActionEvent : public Event
{
public:
    auto eventResultType() const noexcept
    {
        return m_eventSubtype;
    }
    virtual QVector <EventReport> executeSpecificOps(Hero *hero) noexcept = 0;
    inline EventEnums::Action eventSubtype() const noexcept
    {
        return m_eventSubtype;
    }

protected:
    explicit ActionEvent(EventEnums::Action eventSubtype) noexcept
        : Event(EventEnums::T_Action), m_eventSubtype(eventSubtype) {}

private:
    EventEnums::Action m_eventSubtype;
};

class NullEventResult final : public ActionEvent
{
public:
    NullEventResult() noexcept
        : ActionEvent(EventEnums::A_Null) {}

    inline QVector <EventReport> executeSpecificOps(Hero *) noexcept final
    {
        return {eventText()};
    }
};

class GiveHealthEventResult final : public ActionEvent
{
public:
    explicit GiveHealthEventResult(const ValueRange &addedValue) noexcept;

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    ValueRange m_value;
};

class GiveStressEventResult final : public ActionEvent
{
public:
    explicit GiveStressEventResult(const ValueRange &addedValue) noexcept;

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    ValueRange m_value;
};

struct AttributeModification
{
    enum Type
    {
        T_Add,
        T_Subtract,
        T_Multiply,
        T_Divide,
        T_Set,
        T_END
    };

    HeroEnums::Attribute attribute;
    Type type;
    Expression expression;
    int duration;
};

class ModifyAttributeEventResult final : public ActionEvent
{
public:
    explicit ModifyAttributeEventResult(const AttributeModification &modification) noexcept;

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    AttributeModification m_modification;
};

class KillHeroEventResult final : public ActionEvent
{
public:
    KillHeroEventResult() noexcept
        : ActionEvent(EventEnums::A_KillHero) {}

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;
};

class AddEquipmentEventResult : public ActionEvent
{
public:
    explicit AddEquipmentEventResult(Equipment *equipment) noexcept
        : ActionEvent(EventEnums::A_AddEquipment), m_equipmentToAdd(equipment) {}

    virtual QVector <EventReport> executeSpecificOps(Hero *hero) noexcept override;

    Equipment *equipmentToAdd() const noexcept
    {
        return m_equipmentToAdd;
    }

protected:
    Equipment *m_equipmentToAdd;
};

class AddEquipmentRandomEventResult final : public AddEquipmentEventResult
{
public:
    AddEquipmentRandomEventResult(ValueRange tier, int equipmentTypeFlags) noexcept;

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    ValueRange m_tier;
    int m_eqTypes;
};

class RemoveEquipmentEventResult final : public ActionEvent
{
public:
    explicit RemoveEquipmentEventResult(EquipmentEnums::Type type, int slot) noexcept
        : ActionEvent(EventEnums::A_RemoveEquipment), m_equipmentType(type), m_equipmentSlot(slot) {}

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

    auto equipmentType() const noexcept
    {
        return m_equipmentType;
    }
    int equipmentSlot() const noexcept
    {
        return m_equipmentSlot;
    }

private:
    EquipmentEnums::Type m_equipmentType;
    int m_equipmentSlot;
};

class GiveResourceEventResult : public ActionEvent
{
public:
    explicit GiveResourceEventResult(BaseEnums::Resource resource, const ValueRange &amount) noexcept;

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

    inline BaseEnums::Resource resource() const noexcept
    {
        return m_resource;
    }
    inline ValueRange addedAmount() const noexcept
    {
        return m_amount;
    }

protected:
    BaseEnums::Resource m_resource;
    ValueRange m_amount;
};

class GiveResourceRandomEventResult final : public GiveResourceEventResult
{
public:
    explicit GiveResourceRandomEventResult(const ValueRange &amount) noexcept;
};

class NoSignalEventResult final : public ActionEvent
{
public:
    explicit NoSignalEventResult(const ValueRange &durationInDays) noexcept;

    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

    inline ValueRange durationInDays() const noexcept
    {
        return m_durationInDays;
    }

private:
    ValueRange m_durationInDays;
};

class CheckEventResults
{
    friend class CheckEventResultsBuilder;

public:
    CheckEventResults(const CheckEventResults &other) noexcept;

    inline QVector <QPair <Event *, Chance> > positive() const noexcept
    {
        return m_positive;
    }
    inline QVector <QPair <Event *, Chance> > negative() const noexcept
    {
        return m_negative;
    }

private:
    CheckEventResults() noexcept {}

    QVector <QPair <Event *, Chance> > m_positive;
    QVector <QPair <Event *, Chance> > m_negative;
};

class CheckEventResultsBuilder
{
public:
    CheckEventResults get() noexcept;
    void reset() noexcept;

    void addPositive(const QPair <Event *, Chance> &result) noexcept;
    void addNegative(const QPair <Event *, Chance> &result) noexcept;

private:
    void validateJustBeforeReturning() noexcept;

    CheckEventResults m_results;
};

class CheckEvent : public Event
{
public:
    inline auto eventResultType() const noexcept
    {
        return m_eventSubtype;
    }
    virtual QVector <EventReport> executeSpecificOps(Hero *hero) noexcept override = 0;

protected:
    explicit CheckEvent(EventEnums::Check eventSubtype, const CheckEventResults &results) noexcept;

    CheckEventResults m_results;

private:
    EventEnums::Check m_eventSubtype;
};

class ValueCheckEvent final : public CheckEvent
{
public:
    explicit ValueCheckEvent(const Expression &condition, const CheckEventResults &results) noexcept;
    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    Expression m_condition;
};

class EquipmentCheckEvent final : public CheckEvent
{
public:
    explicit EquipmentCheckEvent(EquipmentEnums::Category neededEq, const CheckEventResults &results) noexcept;
    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    EquipmentEnums::Category m_neededEquipment;
};

class PossibilityEvent final : public Event
{
public:
    explicit PossibilityEvent(Chance chance, Event *event) noexcept;
    QVector <EventReport> executeSpecificOps(Hero *hero) noexcept final;

private:
    Chance m_chance;
    Event *m_event;
};

class EncounterReport
{
public:
    EncounterReport(const QString &encName, const QVector <EventReport> &events, const Time &time) noexcept;

    inline QVector <QString> text() const noexcept
    {
        return QVector<QString>{m_encounterName}+m_events;
    }
    inline const Time &timestamp() const noexcept
    {
        return m_time;
    }

private:
    QString m_encounterName;
    QVector <EventReport> m_events;
    Time m_time;
};

class Encounter
{
public:
    explicit Encounter(const QString &name, Event *rootEvent) noexcept;

    EncounterReport execute(Hero *hero, const Time &currentTime) const noexcept;

    inline QString name() const noexcept
    {
        return m_name;
    }

private:
    QString m_name;
    Event *m_rootEvent;
};

class EncountersContainer
{
public:
    ~EncountersContainer() noexcept;

    void addEncounter(Encounter *enc) noexcept;
    void removeEncounter(unsigned index) noexcept;
    inline const QVector <Encounter *> &encounters() const noexcept
    {
        return m_encounters;
    }

private:
    QVector <Encounter *> m_encounters;
};

struct LandInfo
{
    QString name;
    QString description;
    QPair <int, int> position;
};

class Land : public QObject
{
    Q_OBJECT

    friend class LandBuilder;

public:
    explicit Land(const LandInfo &info) noexcept;

    Q_INVOKABLE inline QString name() const noexcept
    {
        return m_info.name;
    }
    Q_INVOKABLE inline QString description() const noexcept
    {
        return m_info.description;
    }
    Q_INVOKABLE inline int posX() const noexcept
    {
        return m_info.position.first;
    }
    Q_INVOKABLE inline int posY() const noexcept
    {
        return m_info.position.second;
    }

    Encounter *makeRandomEncounter() const noexcept;
    inline const EncountersContainer &encounters() const noexcept
    {
        return m_encounters;
    }

private:
    void setInfo(const LandInfo &info) noexcept;

    void setAssociatedEncountersContainer(const EncountersContainer &encCont) noexcept;

    LandInfo m_info;
    EncountersContainer m_encounters;
};

class LandBuilder
{
public:
    LandBuilder() noexcept;
    ~LandBuilder() noexcept;

    Land *getLand() noexcept;
    void resetLand() noexcept;

    void setInfo(const LandInfo &info) noexcept;

    void setAssociatedEncountersContainer(const EncountersContainer &encCont) noexcept;

private:
    Land *m_land;
};

class Mission
{
    friend class MissionBuilder;

public:
    typedef unsigned MissionDay;

    inline const Land *land() const noexcept
    {
        return m_land;
    }
    inline EventEnums::MissionDifficulty difficulty() const noexcept
    {
        return m_difficulty;
    }
    inline unsigned fullDuration() const noexcept
    {
        return m_duration;
    }
    inline unsigned remainingDays() const noexcept
    {
        return m_remainingDays;
    }
    void decrementDuration() noexcept;

    void assignHero(Hero *hero) noexcept;
    inline const Hero *assignedHero() const noexcept
    {
        return m_assignedHero;
    }

    void start() noexcept;
    EncounterReport doEncounter() noexcept;

private:
    Mission() noexcept;
    ~Mission() noexcept;

    void planNextEncounter() noexcept;

    void setLand(const Land *land) noexcept;
    void setDifficulty(EventEnums::MissionDifficulty difficulty) noexcept;
    void setDuration(unsigned days) noexcept;
    void addEncounter(MissionDay day, Encounter *encounter) noexcept;

    const Land *m_land;
    EventEnums::MissionDifficulty m_difficulty;
    unsigned m_duration;
    unsigned m_remainingDays;
    QVector <QPair <MissionDay, Encounter *> > m_encounters;
    unsigned m_currentEncounter;
    int m_minutesSinceMidnightForLastEncounter;
    Hero *m_assignedHero;
};

struct MissionDataHelper
{
    QString land;
    EventEnums::MissionDifficulty difficulty;
    unsigned duration, remainingDays;
    QVector <QPair <unsigned, QString> > encounters;
    unsigned currentEncounter;
    int minutesSinceMidnightForLastEncounter;
    QString hero;
};

QDataStream &operator<<(QDataStream &stream, const MissionDataHelper &mission) noexcept;
QDataStream &operator>>(QDataStream &stream, MissionDataHelper &mission) noexcept;

class MissionBuilder
{
public:
    MissionBuilder(Base *base) noexcept;
    ~MissionBuilder() noexcept;

    Mission *getMission() noexcept; // resets
    Mission *generateMission(const Land *land, EventEnums::MissionDifficulty difficulty) noexcept; // resets
    void resetMission() noexcept; 

    static Mission *qobjectifyMissionData(const MissionDataHelper &mission, Base *base) noexcept;
    static MissionDataHelper deqobjectifyMission(Mission *mission) noexcept;

    void setLand(const Land *land) noexcept;
    void setDifficulty(EventEnums::MissionDifficulty difficulty) noexcept;
    void setDuration(unsigned duration) noexcept;
    void addRandomEncounter() noexcept;
    void addEncounter(Mission::MissionDay day, Encounter *encounter) noexcept;

private:
    unsigned generateDuration(EventEnums::MissionDifficulty difficulty) const noexcept;
    unsigned generateAmountOfEncountersPerDay(EventEnums::MissionDifficulty difficulty) const noexcept;
    QVector <QPair <Mission::MissionDay, Encounter *> > generateEncounters(const Land *land, EventEnums::MissionDifficulty difficulty, unsigned duration) const noexcept;

    static bool lessThanEncounterSorting(const QPair <Mission::MissionDay, Encounter *> &first, const QPair <Mission::MissionDay, Encounter *> &second) noexcept;

    Mission *m_mission;
    Base *m_base;
};

class MissionInitializer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Hero* selectedHero MEMBER m_hero)

public:
    explicit MissionInitializer(Base *base) noexcept;

    Q_INVOKABLE void reset() noexcept;
    Q_INVOKABLE bool start() noexcept;

    Q_INVOKABLE void setLand(const QString &name) noexcept;
    Q_INVOKABLE void setDifficulty(const QString &difficulty) noexcept;
    Q_INVOKABLE QString difficulty() const noexcept;

    Q_INVOKABLE void setHero(const QString &name) noexcept;
    Q_INVOKABLE inline bool isHeroSelected() const noexcept
    {
        return m_hero!=nullptr;
    }

    Q_INVOKABLE void setArmor(const QString &name) noexcept;
    Q_INVOKABLE void setWeaponTool(const QString &name, unsigned slot) noexcept;

    Q_INVOKABLE void setAetherite(unsigned amount) noexcept;
    Q_INVOKABLE void setEnergy(unsigned amount) noexcept;
    Q_INVOKABLE void setBuildingMaterials(unsigned amount) noexcept;
    Q_INVOKABLE void setFoodSupplies(unsigned amount) noexcept;

private:
    void prepareHero() noexcept;
    void unprepareHero() noexcept;

    Base *m_basePtr;
    MissionBuilder m_missionBuilder;
    const Land *m_land;
    EventEnums::MissionDifficulty m_difficulty;
    Hero *m_hero;
    Equipment *m_armor;
    Equipment *m_weaponTool[2];
    unsigned m_aetherite, m_energy, m_bm, m_food;
};

#endif // EVENT_H
