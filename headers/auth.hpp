#ifndef AUTH_HPP
#define AUTH_HPP

#include <QtQuick>
#include <QtNetwork>

static QString token = "";
static QString user_login = "";

class UserLogin: public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString function_user_login();
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

#endif // AUTH_HPP
