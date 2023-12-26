#ifndef NETWORK_H
#define NETWORK_H

#include <QtQuick>
#include <QtNetwork>

static QString token = "";
static QString user_login = "";
static QString user_server = "";
static QMap<qint64, QVariant> regs;

class DirectumData: public QObject {
    Q_OBJECT
signals:
    void getRequestIsFinished();
    void authIsFinished();

public:
    enum AuthResult { Okay, Error, Await };
    Q_ENUM(AuthResult)

    Q_INVOKABLE void try_auth(const QString &server, const QString &login, const QString &password);

    Q_INVOKABLE QString get_user_login();
    Q_INVOKABLE QString get_user_token();
    Q_INVOKABLE QString get_user_server();
    Q_INVOKABLE void make_get_request(QString url);
    Q_INVOKABLE void make_post_request(QString url, QString params);

    Q_INVOKABLE QJsonDocument string2json(QString json);
    Q_INVOKABLE QString json2string(QJsonDocument json, bool compact = true);

    Q_PROPERTY(AuthResult auth_result MEMBER auth_result_)
    Q_PROPERTY(QString auth_err MEMBER auth_err_)
    Q_PROPERTY(QString request_answer MEMBER request_answer_)
    Q_PROPERTY(qint64 request_answer_code MEMBER request_answer_code_)

    Q_INVOKABLE QVariant get_reg(qint64 index);
    Q_INVOKABLE void set_reg(qint64 index, QVariant value);

private:
    QString request_answer_ = "";
    qint64 request_answer_code_ = 0;
    QString auth_err_ = "";
    AuthResult auth_result_ = AuthResult::Await;
};

#endif // NETWORK_H
