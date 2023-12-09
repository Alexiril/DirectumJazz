#include "headers/network.hpp"

QString DirectumData::get_user_login(){
    return user_login;
}

QString DirectumData::get_user_token() {
    return token;
}

QJsonDocument DirectumData::string2json(QString json) {
    return QJsonDocument::fromJson(json.toUtf8());
}

QString DirectumData::json2string(QJsonDocument json, bool compact) {
    return json.toJson(compact ? QJsonDocument::JsonFormat::Compact : QJsonDocument::JsonFormat::Indented);
}

void DirectumData::make_get_request(QString function) {
    QNetworkAccessManager* manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    request.setUrl(QUrl("https://cpp-student.starkovgrp.ru/Integration/odata/DirectumAurora/" + function));
    request.setRawHeader("Authorization", ("Bearer " + token).toUtf8());
    auto reply = manager->get(request);
    QTimer timer;
    timer.start(30000);
    timer.setSingleShot(true);
    connect(&timer, &QTimer::timeout, this, [&reply]() { reply->abort(); });
    connect(manager, &QNetworkAccessManager::finished, [&](QNetworkReply* reply) {
        if (reply->error())
            request_answer_ = reply->errorString();
        else
            request_answer_ = QString(reply->readAll());
        QVariant code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
        request_answer_code_ = code.isValid() ? code.toInt() : 0;
        emit getRequestIsFinished();
    });
    connect(manager, &QNetworkAccessManager::finished, manager, &QNetworkAccessManager::deleteLater);
    connect(manager, &QNetworkAccessManager::finished, reply, &QNetworkReply::deleteLater);
}

void Auth::try_auth(const QString &login, const QString &password) {
    QNetworkAccessManager* manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    request.setUrl(QUrl("https://cpp-student.starkovgrp.ru/Integration/token"));
    request.setRawHeader("Username", login.toUtf8());
    request.setRawHeader("Password", password.toUtf8());
    user_login = login;
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

        }
        else
        {
            auth_result_ = AuthResult::Okay;
            token = QString(reply->readAll());
        }
        emit authIsFinished();
    });
    connect(manager, &QNetworkAccessManager::finished, manager, &QNetworkAccessManager::deleteLater);
    connect(manager, &QNetworkAccessManager::finished, reply, &QNetworkReply::deleteLater);
}
