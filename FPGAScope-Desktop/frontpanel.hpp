#ifndef FRONTPANEL_HPP
#define FRONTPANEL_HPP

#include <QMainWindow>
#include <memory>
#include <qwt_plot_curve.h>
#include <qwt_plot_grid.h>
#include "utils/uartviewer.hpp"

namespace Ui {
class FrontPanel;
}

namespace FPGAScope{

class FrontPanel : public QMainWindow
{
    Q_OBJECT

public:
    explicit FrontPanel(QWidget *parent = 0);
    ~FrontPanel();

    UARTViewer *uviewer() { return _uview.get(); }
    void connectChannelA(const double *basePtr, const double *dataPtr, int samples);
    void connectChannelB(const double *basePtr, const double *dataPtr, int samples);

signals:
    void triggerAChanged(double);
    void triggerBChanged(double);
    void switchedTrigger(char);
    void switchedSlope(bool);

public slots:
    void refreshPlot();
    void setTriggerVal(double val);

private slots:
    void triggerValChanged(double val);
    void execUARTViewer();
    void switchChannelA(bool state);
    void switchChannelB(bool state);
    void switchTriggerA(bool state);
    void switchTriggerB(bool state);
    void switchSlope(bool state);

private:
    Ui::FrontPanel *ui;
    QwtPlotCurve *_crvA;
    QwtPlotCurve *_crvB;
    QwtPlotGrid *_grd;
    bool _triggerA;

    //DEBUG
    std::unique_ptr<UARTViewer> _uview;

};

}

#endif // FRONTPANEL_HPP
