#ifndef AUTH_HPP
#define AUTH_HPP

#include <QtQuick>
#include <QtNetwork>

static QString token;

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
