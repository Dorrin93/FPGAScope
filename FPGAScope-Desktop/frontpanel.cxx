#include "frontpanel.hpp"
#include "ui_frontpanel.h"
#include <QDebug>

FPGAScope::FrontPanel::FrontPanel(QWidget *parent) :
    QMainWindow(parent), _triggerA(true),_forceA(false), _forceB(false)
{
    ui = new Ui::FrontPanel();
    ui->setupUi(this);

    _uview = std::make_unique<UARTViewer>();

    _cursBaseTab[0] = 0.0;
    _cursBaseTab[1] = 260.0;
    _cursATab[0] = 3.0;
    _cursATab[1] = 3.0;
    _cursBTab[0] = 3.0;
    _cursBTab[1] = 3.0;

    _crvA = new QwtPlotCurve("ChannelA");
    _crvA->setStyle(QwtPlotCurve::Lines);
    _crvA->setXAxis(QwtPlot::xTop);
    _crvA->setPen(QPen(Qt::green, 2));

    _crvB = new QwtPlotCurve("ChannelB");
    _crvB->setStyle(QwtPlotCurve::Lines);
    _crvB->setXAxis(QwtPlot::xBottom);
    _crvB->setPen(QPen(Qt::red, 2));

    _cursA = new QwtPlotCurve("CursorA");
    _cursA->setXAxis(QwtPlot::xTop);
    _cursA->setPen(QPen(Qt::green, 0.6, Qt::DashLine));
    _cursA->setRawSamples(_cursBaseTab, _cursATab, 2);
    _cursA->attach(ui->mainScreen);

    _cursB = new QwtPlotCurve("CursorB");
    _cursB->setXAxis(QwtPlot::xBottom);
    _cursB->setPen(QPen(Qt::red, 0.6, Qt::DashLine));
    _cursB->setRawSamples(_cursBaseTab, _cursBTab, 2);
    _cursB->attach(ui->mainScreen);


    _grd = new QwtPlotGrid();
    _grd->setPen(QPen(Qt::gray, 0.0, Qt::DotLine));
    _grd->enableX(true);
    _grd->enableXMin(true);
    _grd->enableY(true);
    _grd->enableYMin(true);
    _grd->attach(ui->mainScreen);

    ui->mainScreen->enableAxis(2, false);
    ui->mainScreen->setAutoReplot(false);
    ui->mainScreen->setAxisScale(0, 0, 3, 0.25);

}

FPGAScope::FrontPanel::~FrontPanel()
{
    delete ui;
    delete _crvA;
    delete _crvB;
    delete _cursA;
    delete _cursB;
    delete _grd;
}

void FPGAScope::FrontPanel::connectChannelA(const double *basePtr, const double *dataPtr, int samples)
{
    ui->mainScreen->setAxisScale(3, 0, samples, samples/10);
    _crvA->setRawSamples(basePtr, dataPtr, samples+50);
}

void FPGAScope::FrontPanel::connectChannelB(const double *basePtr, const double *dataPtr, int samples)
{
    ui->mainScreen->setAxisScale(2, 0, samples, samples/10);
    _crvB->setRawSamples(basePtr, dataPtr, samples+50);
}

void FPGAScope::FrontPanel::refreshPlot()
{
    ui->mainScreen->replot();
}

void FPGAScope::FrontPanel::setTriggerVal(double val)
{
    ui->TriggerKnob->setValue(val);
}

void FPGAScope::FrontPanel::setAmplitude(double val, char channel)
{
    switch(channel) {
    case 'A':
        if(ui->lcdVA->isEnabled())
            ui->lcdVA->display(val);
        else
            ui->lcdVA->display(0);
        break;
    case 'B':
        if(ui->lcdVB->isEnabled())
            ui->lcdVB->display(val);
        else
            ui->lcdVB->display(0);
        break;
    }
}

void FPGAScope::FrontPanel::setOffset(double val, char channel)
{
    switch(channel){
    case 'A':
        if(ui->lcdOffsetA->isEnabled())
            ui->lcdOffsetA->display(val);
        else ui->lcdOffsetA->display(0);
    case 'B':
        if(ui->lcdOffsetB->isEnabled())
            ui->lcdOffsetB->display(val);
        else ui->lcdOffsetB->display(0);
    }
}

void FPGAScope::FrontPanel::triggerValChanged(double val)
{
    if(_triggerA){
        _cursATab[0] = _cursATab[1] = val;
        emit triggerAChanged(val);
    }
    else{
        _cursBTab[0] = _cursBTab[1] = val;
        emit triggerBChanged(val);
    }
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
        ui->lcdVA->setEnabled(true);
        ui->lcdOffsetA->setEnabled(true);
    }
    else{
        _crvA->detach();
        ui->lcdVA->setEnabled(false);
        ui->lcdOffsetA->setEnabled(false);
    }
}

void FPGAScope::FrontPanel::switchChannelB(bool state)
{
    if(state){
        _crvB->attach(ui->mainScreen);
        ui->mainScreen->replot();
        ui->lcdVB->setEnabled(true);
        ui->lcdOffsetB->setEnabled(true);
    }
    else{
        _crvB->detach();
        ui->lcdVB->setEnabled(false);
        ui->lcdOffsetB->setEnabled(false);
    }
}

void FPGAScope::FrontPanel::switchTriggerA(bool state)
{
    if(state){
        _triggerA = true;
        ui->ForceBox->setChecked(_forceA);
        emit switchedTrigger('A');
    }

}

void FPGAScope::FrontPanel::switchTriggerB(bool state)
{
    if(state){
        _triggerA = false;
        ui->ForceBox->setChecked(_forceB);
        emit switchedTrigger('B');
    }

}

void FPGAScope::FrontPanel::switchSlope(bool state)
{
    emit switchedSlope(state);
}


void FPGAScope::FrontPanel::switchInterpA(bool state)
{
    _crvA->setCurveAttribute(QwtPlotCurve::Fitted, state);
    ui->mainScreen->replot();
}


void FPGAScope::FrontPanel::switchInterpB(bool state)
{
    _crvB->setCurveAttribute(QwtPlotCurve::Fitted, state);
    ui->mainScreen->replot();
}

void FPGAScope::FrontPanel::switchForce(bool state)
{
    if(_triggerA)  {
        _forceA = state;
        emit switchedForce(state, 'A');
    }
    else{
        _forceB = state;
        emit switchedForce(state, 'B');
    }
}

void FPGAScope::FrontPanel::changeFreqA(int val)
{
    int samples = 2*pow(2, 1+val);
    ui->lcdNumberA->display(samples*20 / 53);
    emit changedFreq(val, 'A');
}

void FPGAScope::FrontPanel::changeFreqB(int val)
{
    int samples = 2*pow(2, 1+val);
    ui->lcdNumberB->display(samples*20 / 53);
    emit changedFreq(val, 'B');
}

void FPGAScope::FrontPanel::showInfo()
{
   QMessageBox m;
   m.information(this, QString::fromUtf8("O programie"), QString::fromUtf8("FPGAScope-Desktop\n")+
                 QString::fromUtf8("Program powstał w ramach pracy inżynierskiej \"Oscyloskop cyfrowy zbudowany z użyciem układu FPGA\"\n")+
                 QString::fromUtf8("Autorzy: Jakub Cholewiński i Bartłomiej Meder")
                 );
}

