#include "controller.hpp"
#include <QDebug>

FPGAScope::Controller::Controller(FPGAScope::FrontPanel *panel, FPGAScope::CoreUnit *unit, QObject *parent):
    QThread(parent), _panel(panel), _unit(unit)
{
    _ucontrol = std::make_unique<UARTController>(_panel->uviewer(), _unit);

    _panel->connectChannelA(_unit->dataBase(), _unit->dataA(), 50);
    _panel->connectChannelB(_unit->dataBase(), _unit->dataB(), 50);

    QObject::connect(this, SIGNAL(updater()), _panel, SLOT(refreshPlot()), Qt::QueuedConnection);
    QObject::connect(_panel, SIGNAL(triggerAChanged(double)), this, SLOT(setTriggerAVal(double)));
    QObject::connect(_panel, SIGNAL(triggerBChanged(double)), this, SLOT(setTriggerBVal(double)));
    QObject::connect(_panel, SIGNAL(switchedTrigger(char)), this, SLOT(triggerSwitched(char)));
    QObject::connect(this, SIGNAL(triggerVal(double)), _panel, SLOT(setTriggerVal(double)));
    QObject::connect(_panel, SIGNAL(switchedSlope(bool)), this, SLOT(slopeSwitched(bool)));

}

FPGAScope::Controller::~Controller()
{}

void FPGAScope::Controller::setTriggerAVal(double val)
{
    _unit->setTriggerA(val);
}

void FPGAScope::Controller::setTriggerBVal(double val)
{
   _unit->setTriggerB(val);
}

void FPGAScope::Controller::triggerSwitched(char id)
{
    switch (id) {
    case 'A':
        emit triggerVal(_unit->getTriggerA());
        break;
    case 'B':
        emit triggerVal(_unit->getTriggerB());
        break;
    default:
        emit triggerVal(0);
        break;
    }
}

void FPGAScope::Controller::slopeSwitched(bool state)
{
   _unit->setSlope(state);
}

void FPGAScope::Controller::transmit()
{
    _unit->doubleChannelTransmission();
    emit updater();
}

void FPGAScope::Controller::run()
{
    QTimer timer;
    connect(&timer, SIGNAL(timeout()), this, SLOT(transmit()), Qt::DirectConnection);
    timer.setInterval(0);
    timer.start();
    exec();
    timer.stop();

}

