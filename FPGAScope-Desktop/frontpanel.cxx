#include "frontpanel.hpp"
#include "ui_frontpanel.h"

FPGAScope::FrontPanel::FrontPanel(QWidget *parent) :
    QMainWindow(parent)
{
    ui = new Ui::FrontPanel();
    ui->setupUi(this);

    _uview = std::make_unique<UARTViewer>();

    //QwtPlotCurve *c1 = new QwtPlotCurve("Curve1");
    //c1->setRawSamples(x.data(), y2.linearize(), 10000);
    //c1->attach(ui->mainScreen);
    //ui->mainScreen->replot();
    //ui->mainScreen->show();

    _crvA = new QwtPlotCurve("ChannelA");
    _crvB = new QwtPlotCurve("ChannelB");

    _grd = new QwtPlotGrid();
    _grd->setPen(QPen(Qt::gray, 0.0, Qt::DotLine));
    _grd->enableX(true);
    _grd->enableXMin(true);
    _grd->enableY(true);
    _grd->enableYMin(true);
    _grd->attach(ui->mainScreen);

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

void FPGAScope::FrontPanel::connectChannelA(double *basePtr, double *dataPtr)
{
    _crvA->setRawSamples(basePtr, dataPtr, 10000);
    _crvA->attach(ui->mainScreen);
    ui->mainScreen->replot();
}

void FPGAScope::FrontPanel::connectChannelB(double *basePtr, double *dataPtr)
{
    _crvB->setRawSamples(basePtr, dataPtr, 10000);
    _crvB->attach(ui->mainScreen);
    ui->mainScreen->replot();
}

void FPGAScope::FrontPanel::refreshPlot()
{
   ui->mainScreen->replot();
}

void FPGAScope::FrontPanel::execUARTViewer()
{
    _uview->show();
}
