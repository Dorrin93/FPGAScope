#include "frontpanel.hpp"
#include "ui_frontpanel.h"

FPGAScope::FrontPanel::FrontPanel(QWidget *parent) :
    QMainWindow(parent), _triggerA(true)
{
    ui = new Ui::FrontPanel();
    ui->setupUi(this);

    _uview = std::make_unique<UARTViewer>();

    _crvA = new QwtPlotCurve("ChannelA");
    _crvB = new QwtPlotCurve("ChannelB");

    _grd = new QwtPlotGrid();
    _grd->setPen(QPen(Qt::gray, 0.0, Qt::DotLine));
    _grd->enableX(true);
    _grd->enableXMin(true);
    _grd->enableY(true);
    _grd->enableYMin(true);
    _grd->attach(ui->mainScreen);

    //ui->mainScreen->enableAxis(2, false);
    ui->mainScreen->setAutoReplot(false);
    ui->mainScreen->setAxisScale(0, 0, 3, 0.25);

}

FPGAScope::FrontPanel::~FrontPanel()
{
    delete ui;
    delete _crvA;
    delete _crvB;
    delete _grd;
}

void FPGAScope::FrontPanel::connectChannelA(const double *basePtr, const double *dataPtr, int samples)
{
    _crvA->setRawSamples(basePtr, dataPtr, samples);
}

void FPGAScope::FrontPanel::connectChannelB(const double *basePtr, const double *dataPtr, int samples)
{
    _crvB->setRawSamples(basePtr, dataPtr, samples);
    _crvB->setStyle(QwtPlotCurve::Lines);
    _crvB->setCurveAttribute(QwtPlotCurve::Fitted, true);
}

void FPGAScope::FrontPanel::refreshPlot()
{
    ui->mainScreen->replot();
}

void FPGAScope::FrontPanel::setTriggerVal(double val)
{
    ui->TriggerKnob->setValue(val);
}

void FPGAScope::FrontPanel::triggerValChanged(double val)
{
    if(_triggerA)
        emit triggerAChanged(val);
    else
        emit triggerBChanged(val);
}

void FPGAScope::FrontPanel::execUARTViewer()
{
    _uview->show();
}

void FPGAScope::FrontPanel::switchChannelA(bool state)
{
    if(state){
        _crvA->attach(ui->mainScreen);
        ui->mainScreen->replot();
    }
    else
        _crvA->detach();
}

void FPGAScope::FrontPanel::switchChannelB(bool state)
{
    if(state){
        _crvB->attach(ui->mainScreen);
        ui->mainScreen->replot();
    }
    else
        _crvB->detach();
}

void FPGAScope::FrontPanel::switchTriggerA(bool state)
{
    if(state){
        _triggerA = true;
        emit switchedTrigger('A');
    }

}

void FPGAScope::FrontPanel::switchTriggerB(bool state)
{
    if(state){
        _triggerA = false;
        emit switchedTrigger('B');
    }

}

void FPGAScope::FrontPanel::switchSlope(bool state)
{
    emit switchedSlope(state);
}

