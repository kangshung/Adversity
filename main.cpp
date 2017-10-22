#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "h4x.h"
#include "game.h"
#include "timer.h"
#include "fpscounter.h"

#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationDisplayName("Adversity");
    QGuiApplication::setApplicationName("Adversity");
    QGuiApplication::setOrganizationName("Raddos Games");
    QGuiApplication::setApplicationVersion("1.0.2-beta-1");

    Randomizer::initialize();

    qmlRegisterType<FPSText>("FPSComponent",1,0,"FPSCounter");

    qmlRegisterInterface<Base>("Base");
    qmlRegisterInterface<CentralUnit>("CentralUnit");
    qmlRegisterInterface<Hospital>("Hospital");
    qmlRegisterInterface<TrainingGround>("TrainingGround");
    qmlRegisterInterface<Gym>("Gym");
    qmlRegisterInterface<Laboratory>("Laboratory");
    qmlRegisterInterface<PlayingField>("PlayingField");
    qmlRegisterInterface<Bar>("Bar");
    qmlRegisterInterface<Shrine>("Shrine");
    qmlRegisterInterface<Seclusion>("Seclusion");
    qmlRegisterInterface<Powerplant>("Powerplant");
    qmlRegisterInterface<Factory>("Factory");
    qmlRegisterInterface<CoolRoom>("CoolRoom");
    qmlRegisterInterface<StorageRoom>("StorageRoom");
    qmlRegisterInterface<AetheriteSilo>("AetheriteSilo");
    qmlRegisterInterface<Barracks>("Barracks");
    qmlRegisterInterface<DockingStation>("DockingStation");
    qmlRegisterInterface<GameClock>("GameClock");
    qmlRegisterInterface<HeroesContainer>("HeroesContainer");
    qmlRegisterInterface<Equipment>("Equipment");
    qmlRegisterInterface<Mission>("Mission");
    qmlRegisterInterface<MissionInitializer>("MissionInitializer");
    qmlRegisterInterface<Land>("Land");
    qmlRegisterInterface<LandsInfo>("LandsInfo");
    qmlRegisterInterface<UnifiedReport>("UnifiedReport");
    qmlRegisterInterface<LoggersHandler>("LoggersHandler");

    qmlRegisterSingletonType<Game>("Game", 1, 0, "GameApi", gameQObjectSingletontypeProvider);

    QQmlApplicationEngine engine;

    H4X{&engine};

    Game::setQMLEnginePtr(&engine);

    QJSValue globalsObj = engine.newQObject(new Global);
    engine.globalObject().setProperty("GlobalsCpp", globalsObj);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

#ifdef ENABLE_CONSOLE_WINDOW
    engine.load("../GameBase/qml/H4XWindow.qml");
    bool *eventFiltersLocker=new bool(0);
    MainWindowEventFilter mwef{engine.rootObjects()[1], eventFiltersLocker};
    ConsoleWindowEventFilter cwef{engine.rootObjects()[0], eventFiltersLocker};
    engine.rootObjects()[0]->installEventFilter(&mwef);
    engine.rootObjects()[1]->installEventFilter(&cwef);
#endif

    return app.exec();
}
