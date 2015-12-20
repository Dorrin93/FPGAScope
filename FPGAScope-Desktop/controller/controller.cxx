#include "controller.hpp"

FPGAScope::Controller::Controller(FPGAScope::FrontPanel *panel, FPGAScope::CoreUnit *unit, QObject *parent):
    QThread(parent), _panel(panel), _unit(unit)
{
    _ucontrol = std::make_unique<UARTController>(_panel->uviewer(), _unit);

    _panel->connectChannelA(_unit->dataBase(), _unit->dataA());
    //_panel->connectChannelB(_unit->dataBase(), _unit->dataB());

    QObject::connect(this, SIGNAL(updater()), _panel, SLOT(refreshPlot()), Qt::QueuedConnection);

}

FPGAScope::Controller::~Controller()
{}

void FPGAScope::Controller::transmit()
{
   _unit->doubleChannelTransmission();
   emit updater();
}

void FPGAScope::Controller::run()
{
    QTimer timer;
    connect(&timer, SIGNAL(timeout()), this, SLOT(transmit()), Qt::DirectConnection);
    timer.setInterval(1);
    timer.start();
    exec();
    timer.stop();

}

