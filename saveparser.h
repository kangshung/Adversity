#ifndef SAVEPARSER_H
#define SAVEPARSER_H

//File generated using Raddus Binary Data Parser Generator v1.0.1 Beta

#include <QDataStream>
#include <QFile>

#include <QString>
#include <QDateTime>

#include <QDebug>

struct SaveData
{
    struct Overall
    {
        QString baseName;
        QDateTime lastKnownDate;
        quint16 lastKnownDay;
        quint16 lastKnownHour;
        quint16 lastKnownMinute;
    } overall;
    struct Buildings
    {
        struct Levels
        {
            quint8 centralUnit;
            quint8 powerplant;
            quint8 factory;
            quint8 coolRoom;
            quint8 storageRoom;
            quint8 aetheriteSilo;
            quint8 hospital;
            quint8 barracks;
            quint8 dockingStation;
            quint8 trainingGround;
            quint8 gym;
            quint8 laboratory;
            quint8 playingField;
            quint8 bar;
            quint8 shrine;
            quint8 seclusion;
        } levels;
        struct CyclesSet
        {
            quint8 powerPlant;
            quint8 factory;
        } cyclesSet;
    } buildings;
    struct Resources
    {
        quint16 energy;
        quint16 buildingMaterials;
        quint16 foodSupplies;
        quint16 aetheriteOre;
    } resources;
};

class SaveParser
{
public:
    static SaveData readData(const QString &path);
    static void writeData(const QString &path, const SaveData& data);
};

#endif // SAVEPARSER_H
