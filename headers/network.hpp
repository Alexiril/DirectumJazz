#ifndef NETWORK_H
#define NETWORK_H

#include <QtQuick>
#include <QtNetwork>

static QString token = "";
static QString user_login = "";

class DirectumData: public QObject {
    Q_OBJECT
signals:
    void getRequestIsFinished();

public:
    Q_INVOKABLE QString get_user_login();
    Q_INVOKABLE QString get_user_token();
    Q_INVOKABLE void make_get_request(QString function);

    Q_INVOKABLE QJsonDocument string2json(QString json);
    Q_INVOKABLE QString json2string(QJsonDocument json, bool compact = true);

    Q_PROPERTY(QString request_answer MEMBER request_answer_)
    Q_PROPERTY(qint64 request_answer_code MEMBER request_answer_code_)
private:
    QString request_answer_ = "";
    qint64 request_answer_code_ = 0;
};

class Auth : public QObject {
    Q_OBJECT
signals:
    void authIsFinished();

public:
    enum AuthResult { Okay, Error, Await };
    Q_ENUM(AuthResult)

    Q_INVOKABLE void try_auth(const QString &login, const QString &password);

    Q_PROPERTY(AuthResult auth_result MEMBER auth_result_)
    Q_PROPERTY(QString auth_err MEMBER auth_err_)
private:
    QString auth_err_ = "";
    AuthResult auth_result_ = AuthResult::Await;
};

#endif // NETWORK_H
