#ifndef H4X_H
#define H4X_H

#include <QQmlApplicationEngine>
#include <QQmlContext>

static QQmlApplicationEngine *_h4xQmlEngine;

class H4X : public QObject
{
    Q_OBJECT

public:
    H4X(QQmlApplicationEngine *engine);//first use!
    H4X();//use it later on
    
    //time hacks
    Q_INVOKABLE void doTimeTravel(int days, int hours, int minutes) noexcept;//only forward
    Q_INVOKABLE void speedUpTime(float multiplier) noexcept;
    Q_INVOKABLE void slowDownTime(float multiplier) noexcept;
    Q_INVOKABLE void freezeTime() noexcept;
    Q_INVOKABLE void unfreezeTime() noexcept;

    //resource hacks
    Q_INVOKABLE void setAetherite(unsigned amount) noexcept;
    Q_INVOKABLE void setBuildingMaterials(unsigned amount) noexcept;
    Q_INVOKABLE void setEnergy(unsigned amount) noexcept;
    Q_INVOKABLE void setFoodSupplies(unsigned amount) noexcept;

    //docking station hacks
    Q_INVOKABLE void getFreshMeat() noexcept;
    
    //building hacks
    Q_INVOKABLE void upgradeBuilding(const QString &buildingName) noexcept;
    Q_INVOKABLE void setBuildingLevel(const QString &buildingName, unsigned level) noexcept;
    Q_INVOKABLE void completeUpgrade(const QString &buildingName) noexcept;
    Q_INVOKABLE void burnItDown() noexcept;
    
    //mercenary hacks
    Q_INVOKABLE void setMercenaryAttribute(const QString &mercenaryName, const QString &attribute, float value) noexcept;
    Q_INVOKABLE void hire(const QString &mercenaryName) noexcept;
    Q_INVOKABLE void kill(const QString &mercenaryName) noexcept;
    Q_INVOKABLE void dismiss(const QString &mercenaryName, unsigned banTime) noexcept;
    Q_INVOKABLE void killThemAll() noexcept;
    Q_INVOKABLE void engulfThemInPain() noexcept;
    Q_INVOKABLE void chaosComesForYou() noexcept;
    
    //ui hacks
    Q_INVOKABLE void forceUIUpdate() noexcept;

    //app hacks
    Q_INVOKABLE void destroyEverything() noexcept;
    Q_INVOKABLE void freezeGameProgress() noexcept;
    
private:
    QQmlApplicationEngine *m_qmlEngine;

};

#endif // H4X_H