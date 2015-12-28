#include "controller.hpp"
#include <QDebug>
//54 próbki = 50 Hz

FPGAScope::Controller::Controller(FPGAScope::FrontPanel *panel, FPGAScope::CoreUnit *unit, QObject *parent):
    QThread(parent), _panel(panel), _unit(unit)
{
    _ucontrol = std::make_unique<UARTController>(_panel->uviewer(), _unit);

    _panel->connectChannelA(_unit->dataTimebase(), _unit->dataA(), 32);
    _panel->connectChannelB(_unit->dataTimebase(), _unit->dataB(), 32);

    QObject::connect(this, SIGNAL(updater()), _panel, SLOT(refreshPlot()), Qt::QueuedConnection);
    QObject::connect(_panel, SIGNAL(triggerAChanged(double)), this, SLOT(setTriggerAVal(double)));
    QObject::connect(_panel, SIGNAL(triggerBChanged(double)), this, SLOT(setTriggerBVal(double)));
    QObject::connect(_panel, SIGNAL(switchedTrigger(char)), this, SLOT(triggerSwitched(char)));
    QObject::connect(this, SIGNAL(triggerVal(double)), _panel, SLOT(setTriggerVal(double)));
    QObject::connect(_panel, SIGNAL(switchedSlope(bool)), this, SLOT(slopeSwitched(bool)));
    QObject::connect(_panel, SIGNAL(switchedForce(bool,char)), this, SLOT(forceSwitched(bool,char)));
    QObject::connect(_panel, SIGNAL(changedFreq(int,char)), this, SLOT(freqChanged(int,char)));
    QObject::connect(this, SIGNAL(ampVal(double,char)), _panel, SLOT(setAmplitude(double,char)));
    QObject::connect(this, SIGNAL(offsetVal(double,char)), _panel, SLOT(setOffset(double,char)));

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

void FPGAScope::Controller::triggerSwitched(char channel)
{
    switch (channel) {
    case 'A':
        emit triggerVal(_unit->getTriggerA());
        break;
    case 'B':
        emit triggerVal(_unit->getTriggerB());
        break;
    }
}

void FPGAScope::Controller::slopeSwitched(bool state)
{
    _unit->setSlope(state);
}

void FPGAScope::Controller::forceSwitched(bool state, char channel)
{
    switch(channel) {
    case 'A':
        _unit->setForceA(state);
        break;
    case 'B':
        _unit->setForceB(state);
        break;
    }
}

void FPGAScope::Controller::freqChanged(int val, char channel)
{
    int freq = 2 * pow(2, 1+val);
    switch(channel) {
    case 'A':
        _panel->connectChannelA(_unit->dataTimebase(), _unit->dataA(), freq);
        if(freq == 4) freq += 4;
        _unit->setSamplesA(freq);
        break;
    case 'B':
        _panel->connectChannelB(_unit->dataTimebase(), _unit->dataB(), freq);
        if(freq == 4) freq += 4;
        _unit->setSamplesB(freq);
        break;
    }
}

void FPGAScope::Controller::transmit()
{
    _unit->doubleChannelTransmission();
    emit updater();
    auto propA = _unit->propertiesA();
    auto propB = _unit->propertiesB();
    emit ampVal(propA.first, 'A');
    emit ampVal(propB.first, 'B');
    emit offsetVal(propA.second, 'A');
    emit offsetVal(propB.second, 'B');
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

