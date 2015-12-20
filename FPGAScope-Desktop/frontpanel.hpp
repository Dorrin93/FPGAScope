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
    void connectChannelA(double *basePtr, double *dataPtr);
    void connectChannelB(double *basePtr, double *dataPtr);

public slots:
    void refreshPlot();

private slots:
    void execUARTViewer();

private:
    Ui::FrontPanel *ui;
    QwtPlotCurve *_crvA;
    QwtPlotCurve *_crvB;
    QwtPlotGrid *_grd;

    //DEBUG
    std::unique_ptr<UARTViewer> _uview;

};

}

#endif // FRONTPANEL_HPP
