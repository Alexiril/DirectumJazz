#include "headers/auth.hpp"

void Auth::try_auth(const QString &login, const QString &password) {
    QNetworkAccessManager* manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    request.setUrl(QUrl("https://cpp-student.starkovgrp.ru/Integration/token"));
    request.setRawHeader("username", login.toUtf8());
    request.setRawHeader("password", password.toUtf8());
    auto reply = manager->get(request);
    auth_result_ = AuthResult::Await;
    QTimer timer;
    timer.start(30000);
    timer.setSingleShot(true);
    connect(&timer, &QTimer::timeout, this, [&reply]() { reply->abort(); });
    connect(manager, &QNetworkAccessManager::finished, [&](QNetworkReply* reply) {
        if (reply->error())
        {
            auth_result_ = AuthResult::Error;
            auth_err_ = reply->errorString();
            qDebug() << "Auth error: " << auth_err_ << "\n";

        }
        else
        {
            auth_result_ = AuthResult::Okay;
            token = QString(reply->readAll());
            qDebug() << "Auth okay, token: " << token << "\n";
        }
        emit authIsFinished();
    });
    connect(manager, &QNetworkAccessManager::finished, manager, &QNetworkAccessManager::deleteLater);
    connect(manager, &QNetworkAccessManager::finished, reply, &QNetworkReply::deleteLater);
}
