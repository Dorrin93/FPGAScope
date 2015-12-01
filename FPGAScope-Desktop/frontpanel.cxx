#include "frontpanel.hpp"
#include "ui_frontpanel.h"

FrontPanel::FrontPanel(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::FrontPanel)
{
    ui->setupUi(this);
}

FrontPanel::~FrontPanel()
{
    delete ui;
}
